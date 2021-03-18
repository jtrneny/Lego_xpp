#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "common.ch"
#include "drg.ch"
#include "CLASS.CH"

#include "..\Asystem++\Asystem++.ch"


* TAB 1 - Kmenové
* msPrc_mo                                               W
*   nmimoPrVzt  MZD_mimoprvz_CRD ( mimPrvzt )   PER_data W    ncisOsoby
*   ntypDuchod  MZD_duchody_CRD  ( duchody  )            W    ncisOsoby
*   nodpocObd   MZD_odpocpol_CRD ( msOdpPol )            W    nrok +nosCisPrac

* TAB 2 - Mzdové
* msPrc_mo
*   msTarInd(E_bro)              ( msTartind)            W    nOsCisPrac +nPorPraVzt
*   msSazZam(E_bro)              ( msSazzam )            W    nOsCisPrac +nPorPraVzt
*

* TAb 3 - Srážky
* msSrz_mo(D_bro +crd)           ( msSrz_mo )            W    nOsCisPrac +nPorPraVzt

* TAB 4 - Osobní
* osoby                                         W

* TAB 5 - RodPøíslušníci
* vazOsoby                                      W
*   osoby_Rp, osoby_Vm

* TAB 6 - Dùchody
* duchody                                       W


*
*  MSPRC_MO
** CLASS MZD_kmenove_SCR *******************************************************
CLASS MZD_kmenove_CRD FROM drgUsrClass
EXPORTED:

  INLINE ACCESS ASSIGN METHOD cnazgendmz1()  VAR cNazGenDMZ1
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy)),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz2()  VAR cNazGenDMZ2
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy2)),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz3()  VAR cNazGenDMZ3
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy3)),DRUHYMZD->cNazevDMZ, '')
  *

  method  init
  method  drgDialogStart
  method  postValidate
  method  postLastField
  method  destroy
  method  onSave
  method  ebro_saveEditRow
  method  ebro_beforeAppend

  method  MZD_kmenove_SEL
  method  MZD_mimoprvz_CRD
  method  MZD_duchody_CRD
  method  MZD_odpocpol_CRD

  *
  inline method tabSelect(oTabPage,tabNum)
*    local pt := ::pa_otp

*    if .not. empty(otabPage:subs)
*      aeval(pt, { |x| x[3]:oxbp:setColorFG(GRA_CLR_BLACK) })
*    endif
*
*    ::tabSet := .t.
    ::tabNum := otabPage:tabNumber
    if( ::tabNum = 3, ::mssrz_modiCards(), nil )
    ::setFocus_onTab()
  return .t.

  *
  INLINE METHOD eventHandled(nEvent,mp1,mp2,oXbp)
    LOCAL tabNum, cfile

    DO CASE
    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0
      ::restColor()

      if( ::tabNum = 3, ::mssrz_modiCards(), nil )
      RETURN .F.

    case(nevent = drgEVENT_ACTION)
      do case
      case ::tabNum = 3 .and. lower(::df:oLastDrg:classname()) $ 'drgdbrowse' .and. mp1 = drgEVENT_EDIT
        ::df:setNextFocus('mssrz_moW->czkrSrazky',,.t.)
        return .t.
      endcase
      return.f.

    case(nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT)
      do case
      case( ::tabNum = 3 )

        if(nEvent = drgEVENT_APPEND, ( ::dm:refreshAndSetEmpty( 'mssrz_moW' ), ::state := 2), nil )
        ::mssrz_modiCards( if( ::state = 2, '', nil ) )
        ::df:setNextFocus('mssrz_moW->czkrSrazky',,.t.)
        ::state := 1
        return .t.
      endcase

    CASE(nEvent = xbeP_SetInputFocus .and. oXbp:ClassName() = 'XbpTabPage')
       ::nextFocus( Val(SubStr(oXbp:caption,2,1)))
       RETURN .F.

    CASE nEvent = drgEVENT_SAVE

       do case
       case ::tabNum = 3 .and. .not. (lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')

         ::mssrz_save()
         ::state := 0
         return .t.

       otherwise
         MZD_kmenove_wrt(self)
         _clearEventLoop()
         PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
         RETURN .T.
       endcase

    case nEvent = drgEVENT_DELETE
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        cfile := lower( ::df:oLastDrg:cfile )
        if( .not. (cfile) ->(eof()), ::all_broDelete(cfile, ::df:oLastDrg), nil )
        return .t.
      endif

    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        do case
        case(::tabNum = 3 .or. ::tabNum = 5) .and. oXbp:ClassName() <> 'XbpBrowse'
          ::restColor()
          ::setFocus_onTab()
          return .t.

        otherwise
          if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp), nil)

        endcase
        return .t.
      endif
      RETURN .F.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  VAR   lNEWrec

HIDDEN:
  method  copyNewPV

  VAR   msg, dm, dc, df, ab
  VAR   tabNum, onTabSelect, pao_brow
  VAR   oBROw, inEdit, aEdits, state            // 0 - inBrowse  1 - inEdit  2 -
  *
  var   pa_mssrz_Cards


  inline method all_broDelete( cfile, obro )
    local  cInfo  := 'Promiòte prosím,'          +CRLF + ;
                     'požadujete zrušit položku '
    local  cc     := '', nsel

    do case
    case( cfile = 'mstarindw' ) ;  cc := 'individuálního tarifu'   // Individuální tarif pro zamìstnance
    case( cfile = 'mssazzamw' ) ;  cc := 'individuální sazby'      // Sazbu  pro zamìstance
    case( cfile = 'mssrz_mow' ) ;  cc := 'pøednastavené srážky'    // Srážku pro zamìstnance
    case( cfile = 'msmzdyitw' ) ;  cc := 'pøednastavené mzdy'      // Položku pøednastavené mzdy
    endcase

    if .not. empty(cc)
      cInfo += '. ' +upper(cc) +' .' +CRLF + CRLF + ;
               'pro pracovníka _' +upper( allTrim(msprc_mow->cpracovnik)) +'_'

      nsel := ConfirmBox( , cInfo, ;
                           'Zrušení ' +cc +' ...' , ;
                            XBPMB_YESNO                   , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      if nsel = XBPMB_RET_YES
        (cfile)->_delrec := '9'
        if( (cfile) ->_nrecor = 0, (cfile)->( dbdelete()), nil )

        obro:oxbp:refreshAll()
      endif
    endif
  return .t.

  *
  ** metody pro práci s mssrz_mow
  inline method mssrz_modiCards( typSrz, is_inPostValidate )
    local  o_porUplsrz := ::dm:has( 'mssrz_moW->nporUplsrz'):odrg
    local  o_zkrSrazky := ::dm:has( 'mssrz_moW->czkrSrazky'):odrg
    local  pa          := ::pa_mssrz_Cards

    default typSrz            to ::dm:get( 'mssrz_moW->ctypSrz'   ), ;
            is_inPostValidate to .f.

    if isNull( pa )
      pa := { ::dm:has( 'mssrz_moW->ntypCastka' ):odrg, ::dm:has( 'mssrz_moW->nsplatka' ):odrg, ;
              ::dm:has( 'mssrz_moW->ncelkem'    ):odrg, ::dm:has( 'mssrz_moW->nnedoplat'):odrg, ;
              ::dm:has( 'mssrz_moW->nsplaceno'  ):odrg, ::dm:has( 'mssrz_moW->nzustatek'):odrg  }
    endif

    do case
    case      typSrz = 'SR00'    // Pøevod mzdy na úèet
      aeval( pa, { |x| ( x:isEdit := .f., x:oxbp:disable() ) })

    case      typSrz = 'SRUV'    // Ostatní pùjèky, Pùjèka z FKSP ...
      aeval( pa, { |x| ( x:isEdit := .t., x:oxbp:enable() ) })

    otherwise                    // SROB  Exekuce, Ostatní srážky ze mzdy, Pojištìní u pojišov.úst. ...
                                 // SROD  Srážka pro odborovou org.
                                 // SRPP  Penz.pøipoj. - organizace, Životní poj. -organizace

      aeval( pa, { |x| ( x:isEdit := .f., x:oxbp:disable() ) }, 2)
      ( pa[1]:isEdit := .t., pa[1]:oxbp:enable() )
      ( pa[2]:isEdit := .t., pa[2]:oxbp:enable() )
    endCase

    if( .not. empty(typSrz), ( o_zkrSrazky:isEdit := .f., o_zkrSrazky:oxbp:disable()), ;
                             ( o_zkrSrazky:isEdit := .t., o_zkrSrazky:oxbp:enable() )  )

    if( pa[1]:isEdit       , ( o_porUplsrz:isEdit := .t., o_porUplsrz:oxbp:enable() ), ;
                             ( o_porUplsrz:isEdit := .f., o_porUplsrz:oxbp:disable())  )

    * v INS povolíme editaci zkrSrazky
    if ::state = 2
      ( o_zkrSrazky:isEdit := .t., o_zkrSrazky:oxbp:enable())
      *
      ** pøednastavíme
      ::dm:set( 'mssrz_moW->laktivSrz', .t.)
      ::dm:set( 'mssrz_moW->ddatOdSpl', mh_firstOdate( msprc_moW->nrok, msprc_moW->nobdobi) )
    endif

    if( ::state = 2 .or. is_inPostValidate, ::mssrz_poradiSrazky( typSrz ), nil )
  return .t.


  inline method mssrz_poradiSrazky( typSrz )
    local  nporadi := 0, nporUplSrz := 0, ncnt := 0
    local  recNo   := mssrz_mow->( recNo())
    * nporadi
    * nporUplSrz
    * pokud je typSrz NIL jedná se o uložení, musíme zkotrolovat nporUplSrz
    *                                         a nastavit hodnotu nporadí

    Fordrec( {'mssrz_mow'} )

    if isCharacter( typSrz )

      mssrz_mow->(dbgotop()                                           , ;
                  dbeval( { || nporUplSrz := mssrz_mow->nporUplSrz }  , ;
                          { || mssrz_mow->nporUplsrz <> 90         } )  )

      nporUplSrz := if( typSrz = 'SR00', 90, nporUplSrz +1 )
      ::dm:set( 'mssrz_mow->nporUplSrz', nporUplSrz )

    else
      nporUplSrz := mssrz_mow->nporUplSrz

      mssrz_mow->( ordsetFocus( 'MsSrzW04')     , ;
                   dbgoBottom()                 , ;
                   nporadi := mssrz_mow->nporadi, ;
                   dbgoTo( recNo)                 )

      nporadi++
      if( mssrz_mow->nporadi = 0, mssrz_mow->nporadi := nporadi, nil )

      * pøeèíslováváme mimo 90
      mssrz_mow->( dbeval ( { || ncnt++ }, { || mssrz_mow->nporUplSrz = nporUplSrz } ))

      if ncnt > 1
        mssrz_mow->( dbgoTo( recNo), dbskip())

        do while .not.  mssrz_mow->( eof())
          mssrz_mow->nporUplSrz := min( mssrz_mow->nporUplSrz +1, 90)
          mssrz_mow->( dbskip())
        enddo
      endif
    endif

    Fordrec()
  return .t.


  inline method mssrz_save()

    if mssrz_moW->(eof()) .or. ::state = 2
      mh_copyFld( 'msprc_mow', 'mssrz_mow', .t. )
    endif

    (::dm:save(), ::dm:refresh(.T.))

    * musíme zkotrolovat nporUplSrz
    ::mssrz_poradiSrazky()

    ::restColor()
    ::setFocus_onTab()
  return .t.
  **
  *

  inline method restColor()
    local  members := ::df:aMembers
    local  brow, nin, npos := 0
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.


  inline method setFocus_onTab()
    local  nIn, zkr_skup, cky, brow
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum

    if( nIn := ascan(pao_brow, {|x| x[3] = tabNum })) <> 0
      ::df:olastdrg   := ::pao_brow[nIn,2]
      ::df:nlastdrgix := ::pao_brow[nIn,1]
      ::df:olastdrg:setFocus()

      ::dc:oaBrowse := ::pao_brow[nIn,2]
      brow := ::dc:oaBrowse:oXbp
      ::dm:refresh()

*      if npos <> 0
        brow:refreshAll()
        brow:panHome()
*      else
*        PostAppEvent(xbeBRW_ItemMarked,,,brow)
*        brow:refreshCurrent():hilite()
*      endif
    endif

**    ::tabSet := .f.
  return .t.

  inline method postEscape()
    local nsel

    nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                        'Data nebudou uložena ...'                     , ;
                         XBPMB_YESNO                                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                         XBPMB_DEFBUTTON2                                )
    return (nsel = XBPMB_RET_YES)


  INLINE METHOD nextFocus(tabNum)
    LOCAL tabPos   := ::onTABselect[tabNum,1]
    LOCAL aMembers := ::drgDialog:oForm:aMembers
    *
    LOCAL x, name := ''

    BEGIN SEQUENCE
      FOR x := tabPos +1 TO LEN(aMembers)
        IF IsMemberVar( aMembers[x], 'isEdit')
          IF aMembers[x]:isEdit
            name := aMembers[x]:name
    BREAK
          ENDIF
        ENDIF
      NEXT
    END SEQUENCE

    if( ::lNEWrec .and. name = 'MSPRC_MOW->CDRUPRAVZT', name := 'MSPRC_MOW->NOSCISPRAC', nil)
    IF( .not. Empty(name), ::df:setNextFocus(name,,.T.), NIL )

  RETURN

ENDCLASS

*
** init
METHOD MZD_kmenove_CRD:init(parent)
  LOCAL  cKy     := MSPRC_MO ->(sx_KeyData(1))
  local  nrok    := uctOBDOBI:MZD:NROK
  local  nobdobi := uctOBDOBI:MZD:NOBDOBI
  *
  ::drgUsrClass:init(parent)
  *
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)
  ::tabNum      := 1
  ::onTabselect := {}
  ::pao_Brow    := {}

  drgDBMS:open('msprc_md')                 // Docházka matrièní soubor pracovníkù -- PROÈ
  drgDBMS:open('msprc_mo',,,,,'msprc_moc') // pomocný soubor pro validace
  drgDBMS:open('personal',,,,,'personalc')

  drgDBMS:open('msmzdyhd')

  drgDBMS:open('DRUHYMZD')
  cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {nrok,nobdobi})
  druhyMzd->( ads_setaof(cfiltr), dbGoTop())

  * TMP soubory *
  drgDBMS:open('MSPRC_MOw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MSPRC_MDw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MSSRZ_MOw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PERSONALw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

//  drgDBMS:open('MSMZDYHDw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
//  drgDBMS:open('MSMZDYITw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP


  * TAB 4 osoby/ personalistika
  drgDBMS:open('OSOBYW'     ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  osobyW->(dbappend())

  if ::lNEWrec
    msprc_mow ->(DbAppend())
    msprc_mow ->ctask   :=  'MZD'
    msprc_mow ->culoha  :=  'M'
    msprc_mow ->nrok    :=  uctOBDOBI:MZD:NROK
    msprc_mow ->nobdobi :=  uctOBDOBI:MZD:NOBDOBI
    msprc_mow ->cobdobi :=  uctOBDOBI:MZD:COBDOBI
    msprc_mow ->nrokObd := (uctOBDOBI:MZD:NROK *100) +uctOBDOBI:MZD:NOBDOBI

    if parent:cargo = drgEVENT_APPEND2
      msprc_mow->nosCisPrac := msprc_mo->nosCisPrac
      msprc_mow->cpracovnik := msprc_mo->cpracovnik
      msprc_mow->crodCisPra := msprc_mo->crodCisPra
    endif

  else                                                                          // oprava
    mh_COPYFLD('MSPRC_MO', 'MSPRC_MOw', .T.)
    mh_COPYFLD('PERSONAL', 'PERSONALw', .T.)

    mh_copyFld( 'osoby', 'osobyW' )
    MSSRZ_MO->( DbSetScope(SCOPE_BOTH, cKy)                                  , ;
                DBEval( { || mh_COPYFLD('MSSRZ_MO', 'MSSRZ_MOw', .T., .t.) }), ;
                dbClearScope()                                                 )
  endif

  *  1_mimopracovní vztahy
  ** MIMOPRVZ->nMIMOPRVZT(db) ->MZD_mimopr_CRD(fm) ->MZD_mimopr_CRD(pr) *
  ** nosCiPrac +nporPrVzt

  cKy := Upper(MSPRC_MOw->cRodCisPra)
  CopyDBWithScope(1,cKy,'MIMPRVZ','MIMPRVZw',.t.)

  *  1_dùchody
  ** DUCHODY->nTYPDUCHOD(db) ->MZD_duchody_CRD(fm) ->MZD_duchody_CRD(pr) *
  CopyDBWithScope(1,cKy,'DUCHODY','DUCHODYw',.t.)

  *  1_odpoèitatelné položky
  ** MSODPPOL->nODPODOBD(db) ->MZD_odpocpol_CRD(fm) ->MZD_odpocpol_CRD(pr)
  _cpyMSODPPOL( .t. )

  *  2_tarifní sazby
  ** MSTARIND/MSTARZAM (eB)
  _cpyMSTAR_SAZ( .t. )
RETURN self


METHOD MZD_kmenove_CRD:drgDialogStart(drgDialog)
  LOCAL  x, cfield
  LOCAL  aMembers := drgDialog:oForm:aMembers, oColumn
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  ::inEdit := .F.
  ::aEdits := {}
  ::state  := 0

  FOR x := 1 TO LEN(aMembers)
    IF     aMembers[x]:ClassName() = 'drgBrowse'
      IF aMembers[x]:cFile = "MSTARINDw"
        ::oBROw := aMembers[x]:oXbp
      ENDIF
    ELSEIF aMembers[x]:ClassName() = 'drgGet'
      IF !Empty(aMembers[x]:Groups)
        AAdd(::aEdits, { NIL, aMembers[x], Val(aMembers[x]:groups), NIL })
      ENDIF
    ELSEIF aMembers[x]:ClassName() = 'drgPushButton'
      BEGIN SEQUENCE
      FOR nIn := 1 TO LEN(::aEdits)
        IF aMembers[x]:drgGet = ::aEdits[nIn][2]
          ::aEdits[nIn][4] := aMembers[x]
      BREAK
        ENDIF
      NEXT
      END SEQUENCE
**      aMembers[x]:oXbp:hide()
    ELSEIF aMembers[x]:ClassName() = 'drgTabPage'
      AAdd(::onTABselect, {x,aMembers[x]})
    ENDIF

    * font a barva u textù
    if  aMembers[x]:ClassName() = 'drgText' .and. .not. empty(aMembers[x]:groups)
      if 'SETFONT' $ aMembers[x]:groups
        pa_groups := ListAsArray(aMembers[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            aMembers[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          aMembers[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif

    if lower(amembers[x]:ClassName()) $ 'drgdbrowse,drgebrowse'
      if .not. empty( amembers[x]:groups )
        AAdd(::pao_brow, {x, amembers[x], val( amembers[x]:groups)})
      endif
    endif
  NEXT

  ::nextFocus(1)
RETURN self


method MZD_kmenove_CRD:ebro_beforeAppend()
return .t.


method MZD_kmenove_CRD:ebro_saveEditRow(o_EBro)
  local  cfile := lower( o_EBro:cfile)

  * 2
  * mstarindw
  * mssazzamw

  * 4
  * msmzdyhdw
  * msmzdyitw

  if o_EBro:state = 2 .or. (cfile)->nosCisPrac = 0
    if( (cfile)->(fieldPos('stask' )) <> 0, (cfile)->ctask  := msprc_mow->ctask , nil )
    if( (cfile)->(fieldPos('culoha')) <> 0, (cfile)->culoha := msprc_mow->culoha, nil )

    (cfile)->nosCisPrac := msprc_mow->nosCisPrac
    (cfile)->nporPraVzt := msprc_mow->nporPraVzt
  endif
return .t.


METHOD MZD_kmenove_CRD:postValidate(drgVar, lis_formValidate)
  LOCAL  name := Lower(drgVar:name)
  local  file := drgParse(name,'-')
  local  item := drgParseSecond( name, '>' )
  local value := drgVar:get(), changed := drgVAR:changed()
  *
  LOCAL  lOK  := .T., pa, xval
  LOCAL  cky

  default lis_formValidate to .f.

  DO CASE
  CASE(name = 'msprc_mow->noscisprac')
    if Empty(value)
      ::msg:writeMessage('OSOBNÍ ÈÍSLO pracovníka je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    else
      if ( ::lNEWrec .and. changed ) .or. (msprc_mow->nporpravzt = 0)
        cky :=  StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2) ;
                 +strzero(value,5)
        if msprc_moc->( dbseek( cky,,'MSPRMO01',.t.))

          ::dm:set('msprc_mow->cpracovnik', msprc_moc->cpracovnik )
          ::dm:set('msprc_mow->crodCisPra', msprc_moc->crodCisPra )

          ::copyNewPV( msprc_moc->(recno()))
        else
          msprc_mow->nporpravzt := 1
          ::drgDialog:dataManager:set('msprc_mow->nporpravzt', msprc_mow->nporpravzt)
        endi
      endif
    endif

  CASE(name = 'msprc_mow->cpracovnik')
    pa := ListAsArray(value, ' ')
    IF .not. Empty(value) .and. Len(pa) >= 2
      MSPRC_MOw->cJMENOPRAC := pa[1]
      MSPRC_MOw->cPRIJPRAC  := pa[2]
      MSPRC_MOw->cTITULPRAC := IF( Len(pa) >= 3, pa[3], '' )
    ELSE
      ::msg:writeMessage('JMÉNO pracovníka je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    ENDIF

  CASE(name = 'msprc_mow->crodcispra'.and. changed)
    MSPRC_MOw->cRODCISPRN := StrTran( StrTran(value, '-', ''), '/', '')
    if .not. Empty(MSPRC_MOw->cRODCISPRN)
      if MSPRC_MOc ->(DbSeek(Upper(value),,'MSPRMO03')) .or. PERSONALc ->(DbSeek(Upper(value),,'PERSONAL03'))
        ::msg:writeMessage('Nalezeno duplicitní RÈ v martièních souborech pracovníkù ...',DRG_MSG_WARNING)
        lOk := .F.
      else
        MSPRC_MOw->nRODCISPRA := Val(MSPRC_MOw->cRODCISPRN)
        MSPRC_MOw->nMUZ       := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) < '2', 1, 0)
        MSPRC_MOw->nZENA      := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) > '1', 1, 0)
        if Empty( personalw->dDatNaroz)
          if SubStr( msprc_mow->cRodCisPra, 4, 1)  == "5"                     ;
            .or. SubStr( msprc_mow->cRodCisPra, 4, 1) == "6"
            personalw->dDatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                     +if( SubStr( msprc_mow->cRodCisPra, 4, 1) == "5", "0", "1")    ;
                                       +SubStr( msprc_mow->cRodCisPra, 5, 1) +"/"                    ;
                                         +SubStr( msprc_mow->cRodCisPra, 1, 2))
          else
            personalw->dDatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                     +SubStr( msprc_mow->cRodCisPra, 4,2) +"/"     ;
                                       +SubStr( msprc_mow->cRodCisPra, 1,2))
          endif
          ::dm:set('personalw->dDatNaroz', personalw->dDatNaroz)
        endif
      endif
    else
      ::msg:writeMessage( 'Pokud nebude RÈ zadáno nebude pracovník založen do personalistiky ...',DRG_MSG_WARNING)
    endif

  CASE(name = 'msprc_mow->ddatnast')
    if Empty(value)
      ::msg:writeMessage('"Datum nástupu je povinný údaj ...',DRG_MSG_WARNING)
      lOk := .F.
    else
      if Empty( ::drgDialog:dataManager:get('msprc_mow->ddatvznprv'))
        ::drgDialog:dataManager:set('msprc_mow->ddatvznprv', value)
      endif
    endif

  CASE(name = 'msprc_mow->ntyppravzt')
    if Empty(value)
      ::msg:writeMessage('"Typ pracovního vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      MSPRC_MOw->nCLENSPOL  := IF( value $ {2,3,4}, 1, 0)
    endif


  CASE(name = 'msprc_mow->ddatvyst')
    MSPRC_MOw->nTMDATVYST := IF( Empty(value), 99999999, (Year(value) *10000) +(Month(value) *100) +Day(value))

  CASE(name = 'msprc_mow->ntypzamvzt')
    if Empty(value)
      ::msg:writeMessage('"Typ zamìstnaneckého vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  * strážky 3 - tabPage
  case ( file = 'mssrz_mow' .and. ::tabNum = 3 .and. ::state <> 0 )

    do case
    case ( item = 'czkrsrazky' .and. changed )

      if c_srazky->ctypSrz = "SR00"
        if mssrz_mow->( dbseek( "SR00",,'MSSRZW05'))
          fin_info_box( 'Srážka - ' +CRLF +;
                        'prevod mzdy na úcet mùže být použita jen jednou .... ')
          return .f.
        endif
      endif

      ::mssrz_modiCards( c_srazky->ctypSrz, .t. )

      ::dm:set( 'mssrz_mow->lprednPohl' , c_srazky->lprednPohl )
      ::dm:set( 'mssrz_mow->cpopSrazky' , c_srazky->cnazSrazky )
      ::dm:set( 'mssrz_mow->ndruhMzdy'  , c_srazky->ndruhMzdy  )
      ::dm:set( 'mssrz_mow->ndruhMzdy2' , c_srazky->ndruhMzdy2 )
      ::dm:set( 'mssrz_mow->ndruhMzdy3' , c_srazky->ndruhMzdy3 )

    case ( item = 'nporuplsrz' .and. changed )
      Fordrec( { 'mssrz_mow' } )
        if mssrz_mow->( dbseek( value,, 'MsSrzW01'))
          if empty( mssrz_mow->_delRec)
            lok := drgIsYESNO( 'Poøadí srážky _' +str(value) +'_ již EXISTUJE, ; ' + ;
                               'povolujete pøeèíslování poøadí stážek ?'             )
          endif
        endif
      Fordrec()

    case ( item = 'cucet_uct' )
      if lok .and. ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
        ::mssrz_save()
        return .f.
      endif
    endcase

  ENDCASE

* 1  MSPRC_MOw
* 2  MSPRC_MOw   mstarindW mssazzamW NE
* 3              MSPRC_MOw           NE
* 4              msmzdyitW           NE
* 5 osobyW

  ** ukládáme pøi zmìnì do tmp jen u vybraných souborù **
  if file = 'msprc_mow' .or. file = 'osobyw'
    if( changed, (::dm:save(), ::dm:refresh(.T.)), NIL )
  endif
RETURN lOk


METHOD MZD_kmenove_CRD:onSave(lIsCheck,lIsAppend)
RETURN .F.


METHOD MZD_kmenove_CRD:destroy()
RETURN SELF


METHOD MZD_kmenove_CRD:MZD_kmenove_SEL()
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)
  local  tabNum

  DRGDIALOG FORM 'MZD_kmenove_SEL' PARENT ::drgDialog MODAL EXITSTATE nExit

  tabNum := oDialog:UDCP:tabNum
  oDialog:destroy(.T.)
  oDialog := NIL

  if nexit <> drgEVENT_QUIT
    if tabNum = 1
      ::copyNewPV( msprc_mob->(recno()) )

    else
      msprc_mow->cpracovnik := osoby->cosoba
      msprc_mow->crodCisPra := osoby->crodCisOsb

      ::dm:set('msprc_mow->cpracovnik', osoby->cosoba     )
      ::dm:set('msprc_mow->crodCisPra', osoby->crodCisOsb )
    endif
  endif
RETURN self


method MZD_kmenove_CRD:copyNewPV( rec)
  local vars := ::drgDialog:datamanager:vars:values
  local dm   := ::drgDialog:dataManager
  local n, cky
  local nn := 3
  local newPVcpy := { 'noscisprac', 'cpracovnik', 'crodcispra', ;
                      'cnazpol1',   'ckmenstrpr', ;
                      'cdrupravzt', ;
                      'ntyppravzt', 'cvznpravzt', ;
                      'ntypzamvzt', 'ntypduchod', ;
                      'cmzdkatpra', 'cpraczar',   ;
                      'cfunpra',    'cnazpol4',   ;
                      'cvyplmist',  'nzdrpojis',  ;
                      'nzdrpojdop', 'ldanprohl',  ;
                      'lvypcismzd', 'lautosz400', ;
                      'lautovypcm', 'lzaokrna10', ;
                      'lautovyphm', 'lodborar',   ;
                      'lautovyppr', 'lstatuzast', ;
                      'ltiskmzdli', 'limportdoc', ;
                      'lgenereldp', 'lexport',    ;
                      'ltiskkontr', 'lvyradano'}

  if drgIsYESNO(drgNLS:msg('Pøevzít data z pøedchozího PV ?'))
    nn := len(newPVcpy)
  endif

  msprc_moc->( dbGoto(rec))
  msprc_mow->noscisprac := msprc_moc->noscisprac
*  aEval( newPVcpy,|X| dm:set('msprc_mow->'+X, DBGetVal('msprc_moc->'+ X)),,nn )

  for n := 1 to nn
    dm:set('msprc_mow->'+newPVcpy[n],DBGetVal('msprc_moc->'+newPVcpy[n]))   //DBGetVal(iz_file +"->" +pa[x,iz_pos])
  next

  cky :=  strzero(msprc_mow->nrok,4) +strzero(msprc_mow->nobdobi,2)   ;
           +strzero(msprc_mow->noscisprac,5)
  msprc_moc->( dbseek( cky,,'MSPRMO01',.t.))
  msprc_mow->nporpravzt := msprc_moc->nporpravzt +1
  dm:set('msprc_mow->nporpravzt', msprc_mow->nporpravzt )
  dm:save(.T.)
  dm:refresh(.T.)

  cky += Strzero( msprc_moc->nporpravzt, 3)
  MSSRZ_MO ->( DbSetScope(SCOPE_BOTH, cKy)                        , ;
                DBEval( { || mh_COPYFLD('MSSRZ_MO', 'MSSRZ_MOw', .T.) } ) )

  cky := Upper(MSPRC_MOw->cRodCisPra)
  personalc->( dbseek( cky,,'PERSONAL03'))
  mh_COPYFLD('personalc', 'personalw', .T.)

  *  1_mimopracovní vztahy
  ** MIMOPRVZ->nMIMOPRVZT(db) ->MZD_mimopr_CRD(fm) ->MZD_mimopr_CRD(pr) *
  CopyDBWithScope(1,cKy,'MIMPRVZ','MIMPRVZw', .f.)

  *  1_dùchody
  ** DUCHODY->nTYPDUCHOD(db) ->MZD_duchody_CRD(fm) ->MZD_duchody_CRD(pr) *
  CopyDBWithScope(1,cKy,'DUCHODY','DUCHODYw', .f.)

  *  1_odpoèitatelné položky
  ** MSODPPOL->nODPODOBD(db) ->MZD_odpocpol_CRD(fm) ->MZD_odpocpol_CRD(pr)
  _cpyMSODPPOL()

  *  2_tarifní sazby
  ** MSTARIND/MSTARZAM (eB)
  _cpyMSTAR_SAZ()

  personalc->( dbCloseArea())

  ::df:setNextFocus( 'MSPRC_MOW->CDRUPRAVZT',,.T.)
return .t.

*
** Typ evidenèního stavu  ( MSPRC_MOw->nMimoPrVzt )
METHOD MZD_kmenove_CRD:MZD_mimoprvz_CRD()
  local  oDialog, nexit, nmimoPrVzt := 0
  *
  local  odrg := ::dm:has('msprc_moW->nmimoPrVzt'):odrg

  DRGDIALOG FORM 'MZD_mimoprvz_CRD' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

*  if nexit != drgEVENT_QUIT
    if mimPrvzW->( dbLocate( { || mimPrvzW->lAktiv } ))
      nmimoPrVzt := mimPrvzW->nmimoPrVzt
    endif
    ::dm:set( 'msprc_moW->nmimoPrVzt', nmimoPrVzt )

*  endif

  postAppEvent(xbeP_Keyboard, xbeK_RETURN,,odrg:oXbp)
RETURN self


METHOD MZD_kmenove_CRD:MZD_duchody_CRD()
  local  oDialog, nexit, ntypDuchod := 0
  *
  local  odrg := ::dm:has('msprc_moW->ntypDuchod'):odrg

  DRGDIALOG FORM 'MZD_duchody_CRD' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

*  if nexit != drgEVENT_QUIT
    if duchodyW->( dbLocate( { || duchodyW->laktiv } ))
      ntypDuchod := duchodyW->ntypDuchod
    endif
    ::dm:set( 'msprc_moW->ntypDuchod', ntypDuchod )

*  endif                                               s

  postAppEvent(xbeP_Keyboard, xbeK_RETURN,,odrg:oXbp)
RETURN self


METHOD MZD_kmenove_CRD:MZD_odpocpol_CRD()
  LOCAL oDialog, nexit
  *
  local  odrg := ::dm:has('msprc_mow->nodpocobd'):odrg

  DRGDIALOG FORM 'MZD_odpocpol_CRD' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

*  if nexit != drgEVENT_QUIT
    ::dm:set( 'msprc_mow->nodpocobd', msprc_mow->nodpocobd )
    ::dm:set( 'msprc_mow->nodpocrok', msprc_mow->nodpocrok )
    ::dm:set( 'msprc_mow->ndanulobd', msprc_mow->ndanulobd )
    ::dm:set( 'msprc_mow->ndanulrok', msprc_mow->ndanulrok )
*  endif

** NE **  postAppEvent(xbeP_Keyboard, xbeK_RETURN,,odrg:oXbp)
RETURN self



METHOD MZD_kmenove_CRD:postLastField(drgVar)
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  name   := drgVAR:name
  LOCAL  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme VYKDPH_P na každém PRVKU //
  IF lZMENa
    ::dataManager:save()
    ::oBROw:refreshCurrent()
  ENDIF
RETURN .T.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
FUNCTION _cpyMSODPPOL( isMain )
  local  nCelkOdOBD := nCelkOdROK := nCelkUlOBD := nCelkUlROK := 0
  local  cKy        := strZero(msprc_mow->nrok,4)       + ;
                       strZero(msprc_mow->nosCisPrac,5) + ;
                       strZero(msprc_mow->nporPraVzt,3)
  local  newcpypv   := {}
  *
  default isMain to .f.
  *
  drgDBMS:open('C_ODPOC')
  drgDBMS:open('MSODPPOL')
  drgDBMS:open('RODPRISL')
  drgDBMS:open('OSOBY',,,,,'osobyc')
  *
  drgDBMS:open('C_ODPOCw',.T.,.T.,drgINI:dir_USERfitm);  ZAP
  drgDBMS:open('MSODPPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  MSODPPOL->( AdsSetOrder( 7),DbSetScope(SCOPE_BOTH,cKy),dbGoTop())

  DO WHILE .not. MSODPPOL->( Eof())
    mh_COPYFLD( 'MSODPPOL', 'MSODPPOLw', .T., isMain )
    IF( Year(MSODPPOLw->dPlatnDo)*100 +Month(MSODPPOLw->dPlatnDo)) >= (uctOBDOBI:MZD:nROK*100 +uctOBDOBI:MZD:nOBDOBI) ;
       .OR. Empty(MSODPPOLw->dPlatnDo)
      MSODPPOLw->lAktiv := .T.
      IF MSODPPOLw->lOdpocet
        nCelkOdOBD += MSODPPOLw->nOdpocOBD
        nCelkOdROK += MSODPPOLw->nOdpocROK
      ELSE
        nCelkUlOBD += MSODPPOLw->nDanUlOBD
        nCelkUlROK += MSODPPOLw->nDanUlROK
      ENDIF
    ENDIF
    MSODPPOL->( dbSkip())
  ENDDO

  * odpoèet na dìti *
  cKy := Upper(MSPRC_MOw->cRodCisPra)
  RODPRISL ->( AdsSetOrder(1),DbSetScope(SCOPE_BOTH,cKy),dbGoTop())
  C_ODPOC  ->( AdsSetOrder(3),DbSetScope(SCOPE_BOTH, StrZero(uctOBDOBI:MZD:nROK,4)),dbGoTop())
  MSODPPOLw->( AdsSetOrder( 2))

  DO WHILE .not. C_ODPOC->( Eof())
    lDOPLN  := .F.
    lGENrec := .T.
    *
    DO CASE
    CASE C_ODPOC->cTypOdpPol = "DITE"            // Daòová úleva na dìti
      DO WHILE .not. RODPRISL->( Eof())          // TAG  -- MsOdpPoW02
        IF RODPRISL->cTypRodPri = "DITE" .AND. ;
           .not. MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol) +UPPER(RODPRISL ->cRodCisRP) +"1"))
          mh_COPYFLD( 'C_ODPOC', 'C_ODPOCw', .T., isMain)
          osobyc->( dbSeek(rodprisl->ncisosobrp,,'osoby01'))

          C_ODPOCw ->cNazOdpPol := osobyc->cosoba
          C_ODPOCw ->cRodCisRP  := RODPRISL->cRodCisRP
          C_ODPOCw ->nRodPrisl  := RODPRISL->nRodPrisl
          C_ODPOCw->nOsCisPrac  := MSPRC_MOw->nOsCisPrac
          C_ODPOCw->cKmenStrPr  := MSPRC_MOw->cKmenStrPr
          C_ODPOCw->cPracovnik  := MSPRC_MOw->cPracovnik
          C_ODPOCw->nPorPraVzt  := MSPRC_MOw->nPorPraVzt
          C_ODPOCw->dPlatnOd    := cTOd( "01/" +Str( uctOBDOBI:MZD:nOBDOBI) +"/" +Str( uctOBDOBI:MZD:nROK))
          C_ODPOCw->cObdOd      := uctOBDOBI:MZD:cOBDOBI
          C_ODPOCw->cObdDo      := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
        ENDIF
        RODPRISL->( dbSkip())
      ENDDO
      lGENrec := .f.

    CASE C_ODPOC->cTypOdpPol = "ZAKL"            // Sleva na dani za poplatníka
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->lDanProhl)

    CASE C_ODPOC->cTypOdpPol = "INVC"            // Sleva na dani na èásteè.inval.
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 7)

    CASE C_ODPOC->cTypOdpPol = "INVP"            // Sleva na dani na plnou inval.
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 5)

    CASE C_ODPOC->cTypOdpPol = "INVZ"            // Sleva na dani za ZTP-P
      lGENrec := IF( MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol))), .F., MSPRC_MOw->nTypDuchod == 6)

    case c_odpoc->ctypOdpPol = 'STUD'
      lGENrec := .not.  MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol)))

    case c_odpoc->ctypOdpPol = 'MANZ'
      lGENrec := .not.  MSODPPOLw->( DbSeek( Upper(C_ODPOC ->cTypOdpPol)))
    ENDCASE

    IF lGENrec
      mh_COPYFLD( 'C_ODPOC', 'C_ODPOCw', .T., isMain)

      C_ODPOCw->nOsCisPrac := MSPRC_MOw ->nOsCisPrac
      C_ODPOCw->cKmenStrPr := MSPRC_MOw ->cKmenStrPr
      C_ODPOCw->cPracovnik := Left( MSPRC_MOw ->cPracovnik, 25) +StrZero( MSPRC_MOw ->nOsCisPrac, 5)
      C_ODPOCw->dPlatnOd   := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
      C_ODPOCw->cObdOd     := uctOBDOBI:MZD:cOBDOBI
      C_ODPOCw->cObdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
      C_ODPOCw->nPorOdpPol := C_ODPOCw->( Recno())
    ENDIF

    C_ODPOC->( dbSkip())
  ENDDO
RETURN NIL


STATIC FUNCTION _cpyMSTAR_SAZ( isMain )
  LOCAL cKy := StrZero(MSPRC_MOw->nOsCisPrac,5) +StrZero( MSPRC_MOw->nPorPraVzt,3)

  default isMain to .f.

  * tarify individuální *
  drgDBMS:open('MSTARIND')
  drgDBMS:open('MSTARINDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  MSTARIND->( AdsSetOrder(4), DbSetScope(SCOPE_BOTH, cKy),dbGoTop())

  DO WHILE .not. MSTARIND->( Eof())
    IF .not. Empty( MSTARIND->dPlatTarDo) .AND.                 ;
        ( MSPRC_MOw->nRok <= Year( MSTARIND->dPlatTarDo)) .AND. ;
          ( MSPRC_MOw->nObdobi <= Month( MSTARIND->dPlatTarDo))
      mh_COPYFLD( 'MSTARIND', 'MSTARINDw', .T., isMain)

    ELSE
      IF .not. Empty(MSTARINDw->dPlatTarOd)
        MSTARINDw->dPlatTarDo := MSTARINDw->dPlatTarOd -1
        IF ( MSPRC_MOw->nRok > Year( MSTARINDw->dPlatTarDo))
          MSTARINDw->( dbDelete())
        ELSE
         IF ( MSPRC_MOw->nRok = Year( MSTARINDw->dPlatTarDo)) .AND. ;
            ( MSPRC_MOw->nObdobi > Month( MSTARINDw->dPlatTarDo))
           MSTARINDw->( dbDelete())
         ENDIF
        ENDIF
      ENDIF
      mh_COPYFLD( 'MSTARIND', 'MSTARINDw', .T., isMain)
    ENDIF
    MSTARIND->( dbSkip())
  ENDDO

  * tarify zamìstancù *
  drgDBMS:open('MSSAZZAM')
  drgDBMS:open('MSSAZZAMw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  MSSAZZAM->( AdsSetOrder(4),DbSetScope(SCOPE_BOTH, cKy), dbGoTop())

  DO WHILE .not. MSSAZZAM->( Eof())
    IF .not. Empty( MSSAZZAM->dPlatSazDo) .AND.                ;
       ( MSPRC_MOw->nRok <= Year( MSSAZZAM->dPlatSazDo)) .AND. ;
       ( MSPRC_MOw->nObdobi <= Month( MSSAZZAM->dPlatSazDo))
      mh_COPYFLD( 'MSSAZZAM', 'MSSAZZAMw', .T., isMain )
    ELSE
      IF .not. Empty( MSSAZZAMw->dPlatSazOd)
        MSSAZZAMw->dPlatSazDo := MSSAZZAMw->dPlatSazOd -1
        IF ( MSPRC_MOw->nRok > Year( MSSAZZAMw->dPlatSazDo))
          MSSAZZAMw->( dbDelete())
        ELSE
          IF ( MSPRC_MOw->nRok = Year( MSSAZZAMw->dPlatSazDo)) .AND. ;
                ( MSPRC_MOw->nObdobi > Month( MSSAZZAMw->dPlatSazDo))
            MSSAZZAMw->( dbDelete())
          ENDIF
        ENDIF
      ENDIF
      mh_COPYFLD( 'MSSAZZAM', 'MSSAZZAMw', .T., isMain )
    ENDIF
    MSSAZZAM->( dbSkip())
  ENDDO
RETURN NIL