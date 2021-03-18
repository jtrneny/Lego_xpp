#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "common.ch"
#include "drg.ch"
#include "CLASS.CH"

#include "..\Asystem++\Asystem++.ch"
#include "..\Mzdy\Kmenove\MZD_kmenove_.ch"


*
*  MSPRC_MO
** CLASS MZD_kmenove_SCR *******************************************************
CLASS MZD_kmenove_CRD FROM drgUsrClass, MZD_kmenove_IN
EXPORTED:

  inline access assign method cnazFirmy()    var cnazFirmy
    trvZavHd->( dbseek( upper(msSrz_mow->cpohZavFir),,'TRVZAVHD02'))
    return trvZavhd->cnazev

  INLINE ACCESS ASSIGN METHOD cnazgendmz1()  VAR cNazGenDMZ1
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy,, 'DRUHYMZD01')),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz2()  VAR cNazGenDMZ2
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy2,,'DRUHYMZD01')),DRUHYMZD->cNazevDMZ, '')
  *
  INLINE ACCESS ASSIGN METHOD cnazgendmz3()  VAR cNazGenDMZ3
    RETURN IF( DRUHYMZD->( DbSeek(MSSRZ_MOw->nDruhMzdy3,,'DRUHYMZD01')),DRUHYMZD->cNazevDMZ, '')
  *
  ** TAB_mzda    -> 3
  inline access assign method autoVypHM() var autoVypHM
    return if( msMzdyhdW->lautoVypHM, 172, 0)
  *
  ** TAB_srazky  -> 4
  inline access assign method is_aktivSrz() var is_aktivSrz
    return if( msSrz_moW->lAktivSrz, MIS_ICON_OK, 0 )
  *
  ** TAB_duchody -> 8
  inline access assign method nazDuchod() var nazDuchod
    c_duchod->(dbseek( duchodyW->ntypDuchod,,'C_DUCHOD01'))
    return c_duchod->cnazDuchod


  method  init
  method  drgDialogStart
  method  postValidate
  method  postLastField
  method  destroy
  method  onSave
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow

  method  MZD_kmenove_SEL

  var     lnewRec
  var     lpravdPod

  inline method itemMarked_msMzdyhdW()

    msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( msMzdyhdW->nkeyMatr,4)), dbgoTop())
**    ::oBRO_msMzdyitW:oxbp:refreshAll()
    return self

  inline access assign method is_aktiv() var is_aktiv
    return if( duchodyW->lAktiv, MIS_ICON_OK, 0 )
  *
  **
  inline method tabSelect(oTabPage,tabNum)
    local  cfile
    *
    local  drgVar
    local  drgButton

    if otabPage:tabNumber = TAB_srazky
     ::tabNum := otabPage:tabNumber
    else
      ::tabNum := otabPage:tabNumber + if( len( otabPage:subTabs) > 0, 1, 0)
    endif

    if( ::tabNum = TAB_srazky, ::msSrz_moW_modiCards(), nil )

    if isObject(drgVar := ::pa_focusOnEdit[otabPage:tabNumber])
      (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )

      if isObject(drgButton := ::paoB_editParent[otabPage:tabNumber])
        cfile := drgParse(drgVar:name,'-')

        if( (cfile)->(eof()), drgButton:disable(), ;
                              drgButton:enable()   )
      endif
    endif
    ::relForText()
    ::setFocus_onTab(.t.)
    return .t.
  *
  **
  inline method checkItemSelected(drgCheckBox)
    local  name   := lower(drgCheckBox:name)
    local  file   := drgParse(name,'-')
    local  drgVar := drgCheckBox:oVar

    if( file = 'msprc_mow' .and. isBlock(drgVar:block))
      eval(drgVar:block,drgCheckBox:value)
      PostAppEvent(drgEVENT_OBJEXIT,,, drgCheckBox:oXbp)
*      drgVar:initValue := drgVar:value
    endif
    return .t.
  *
  **
  inline method eventHandled(nEvent,mp1,mp2,oXbp)
    LOCAL  tabNum, cfile
    local  drgVar    := ::pa_focusOnEdit[::tabNum]
    local  drgButton := ::paoB_editParent[::tabNum]
    local  inEdit := (oXbp:ClassName() <> 'XbpBrowse')

    DO CASE
    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0
      ::restColor()

      if( ::tabNum = TAB_srazky, ::msSrz_moW_modiCards(mssrz_moW->ctypSrz), nil )
      if( ::tabNum = TAB_rodPrislusnici, ;
        ( osoby_Rp->(dbseek( vazOsobyW->ncisOsoby,,'OSOBY01')), ::dm:refresh()), nil )
      RETURN .F.

    case(nevent = drgEVENT_ACTION)
      cfile  := if( isObject(drgVar), lower(drgParse(drgVar:name,'-')), '')

      if isNumber( mp1 )
        if     mp1 = drgEVENT_APPEND

          do case
          case ::tabNum = TAB_kmenove .or. ;
               ::tabNum = TAB_mzdove  .or. ;
               ::tabNum = TAB_osobni  .or. ;
               ::tabNum = TAB_info_osoby
            return .t.

          case ::tabNum = TAB_srazky  .or. ::tabNum = TAB_rodPrislusnici .or. ::tabNum = TAB_duchody
            ::state := 2
            if( ::tabNum = TAB_rodPrislusnici, ::relForText(), ::dm:refreshAndSetEmpty( cfile ) )
            if( ::tabNum = TAB_srazky        , ::msSrz_moW_modiCards( if( ::state = 2, '', nil )), nil )

            ::df:setNextFocus( drgVar:odrg,, .T. )
            ( drgVar:odrg:isEdit           := .t., ;
              drgVar:odrg:pushGet:disabled := .f., ;
              drgVar:odrg:oxbp:enable()            )
            return .t.
          endcase

        elseif mp1 = drgEVENT_EDIT
          do case
          case ::tabNum = TAB_srazky .or. ::tabNum = TAB_rodPrislusnici .or. ::tabNum = TAB_duchody
            ::state := 1
            ::df:setNextFocus( drgvar:odrg,, .T. )
            RETURN .T.
          endcase

        elseif mp1 = drgEVENT_SAVE

          do case
          case ( ::tabNum = TAB_srazky         .or. ;
                   ::tabNum = TAB_zakladni     .or. ;
                   ::tabNum = TAB_doplnujici   .or. ;
                 ::tabNum = TAB_rodPrislusnici .or. ;
                 ::tabNum = TAB_duchody) .and. inEdit

            if ::tabNum = TAB_zakladni .or. ::tabNum = TAB_doplnujici
              ::tabNum := TAB_srazky
              drgVar   := ::pa_focusOnEdit[::tabNum]
            endif

            cfile := lower(drgParse(drgVar:name,'-'))

            if ::postValidate_onTabs(cfile)
              ::save_onTabs( cfile )
              ::setFocus_onTab(.t.)
              ::state := 0
              _clearEventLoop()
              return .t.
            endif

          otherwise
            *  ukládáme celou kartu
            cfile := 'msPrc_moW'

            if mzd_postSave()
              if ::postValidate_onTabs(cfile)
                 MZD_kmenove_wrt( self )
                 _clearEventLoop()
                 PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
                 RETURN .T.
              endif
            endif
          endcase
        endif
      endif

      do case
      case ::tabNum = TAB_srazky .and. lower(::df:oLastDrg:classname()) $ 'drgdbrowse' .and. if( isNumber(mp1), mp1 = drgEVENT_EDIT, .f. )
        ::df:setNextFocus('mssrz_moW->czkrSrazky',,.t.)
        return .t.
      endcase
      return.f.

    case nEvent = drgEVENT_DELETE
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        cfile := lower( ::df:oLastDrg:cfile )
        if( .not. (cfile) ->(eof()), ::all_broDelete(cfile, ::df:oLastDrg), nil )
        return .t.
      endif

    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        do case
        case ( ::tabNum = TAB_mzdove         .or. ;
               ::tabNum = TAB_srazky         .or. ;
                 ::tabNum = TAB_zakladni     .or. ;
                 ::tabNum = TAB_doplnujici   .or. ;
               ::tabNum = TAB_rodPrislusnici .or. ;
               ::tabNum = TAB_duchody) .and. inEdit

           if ::tabNum = TAB_zakladni .or. ::tabNum = TAB_doplnujici
             ::tabNum := TAB_srazky
           endif

           ::state := 0
           ::setFocus_onTab(.t.)
           ::dm:refresh()
           return .t.

        otherWise
           if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp), nil)
        endcase
        return .t.
      endif

      if oxbp:className() = 'XbpGet'
        if ascan( ::pa_only_positiveGets, {|x| x = oxbp}) <> 0
          if mp1 = 45 // -
            return .t.
          else
            return .f.
          endif
        endif
      endif

      return .f.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR   oBROw, inEdit, aEdits, oscisPrac
  var   pa_only_positiveGets
  var   oBRO_msMzdyhdW, oBRO_msMzdyitW
  *

  inline method all_broDelete( cfile, obro )
    local  cInfo  := 'Promiòte prosím,'          +CRLF + ;
                     'požadujete zrušit položku '
    local  cc     := '', nsel, pa := {}, recNo, npos

    do case
    case( cfile = 'mstarindw' ) ;  cc := 'individuálního tarifu'                // Individuální tarif pro zamìstnance
    case( cfile = 'mssazzamw' ) ;  cc := 'individuální sazby'                   // Sazbu  pro zamìstance
    case( cfile = 'msmzdyhdw' ) ;  cc := 'definovaného vzoru po poøízení mezd'  // Matrici vèetnì položek
    case( cfile = 'msmzdyitw' ) ;  cc := 'vzoru pro poøízení mezd'              // Položka matrice
    case( cfile = 'mssrz_mow' ) ;  cc := 'pøednastavené srážky'                 // Srážku pro zamìstnance
    case( cfile = 'vazosobyw' ) ;  cc    := 'rodinného pøíslušníka'             // Vazby na rodinné pøíslušníky
                                   pa    := ::pa_vazRecs[1]
                                   recNo := osoby_Rp->(recNo())
    case( cfile = 'duchodyw'  ) ;  cc    := 'pøiznaného dùchodu'                // dùchody
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

        if( npos := ascan( pa, recNo)) <> 0
          aRemove( pa, npos)
        endif

        if cfile = 'msmzdyhdw'
          msMzdyitW->( dbgoTop(), ;
                       dbeval( { || if( msMzdyitW->_nrecor = 0, ;
                                        msMzdyitW->( dbdelete()), msMzdyitW->_delrec := '9' ) } ), ;
                       dbgoTop()  )
        endif

        obro:oxbp:refreshAll()

        if (cfile)->( eof())
          obro:oxbp:up():forceStable()
          obro:oxbp:refreshAll()
        endif
        ::relForText()
      endif
    endif
    return .t.


  inline method postEscape()
    local nsel

    nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                        'Data nebudou uložena ...'                     , ;
                         XBPMB_YESNO                                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                         XBPMB_DEFBUTTON2                                )

    _clearEventLoop(.t.)
    return (nsel = XBPMB_RET_YES)

ENDCLASS

*
** init
METHOD MZD_kmenove_CRD:init(parent)
  LOCAL  cKy     := MSPRC_MO ->(sx_KeyData(1))
  local  nrok    := uctOBDOBI:MZD:NROK
  local  nobdobi := uctOBDOBI:MZD:NOBDOBI
  *
  local  sname    := drgINI:dir_USERfitm +'mmacro', fields
  local  lenBuff  := 40960, buffer := space(lenBuff)
  *
  ::drgUsrClass:init(parent)
  ::lpravdPod := .f.

  ** definované výkonné bloky pro ins, a pøebírání do msPrc_moW v metodì SEL
  ::b_INSERT                := { || .t. }
  ::b_OSOBY_MSPRC_MOW       := { || .t. }
  ::b_MSPRC_MO_MSPRC_MOW    := { || .t. }
  ::b_MSPRC_MO_MSPRC_MOW_Pv := { || .t. }
  ::b_MSPRC_MOW_PRSMLDOH    := { || .t. }
  ::b_MSPRC_MOW_MSOSB_MO    := { || .t. }

  if asystem->( dbseek( 'MZD_KMENOVE_CRD',, 'ASYSTEM01'))
    memoWrit( sname, asystem->mMacro )
    *
    * naèetem ze sekce UsedIdentifiers Fields *
    buffer := space(lenBuff)
    GetPrivateProfileSectionA('INSERT', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_INSERT := COMPILE( fields  )

    buffer := space(lenBuff)
    GetPrivateProfileSectionA('OSOBY_MSPRC_MOW', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_OSOBY_MSPRC_MOW := COMPILE( fields  )

    buffer := space(lenBuff)
    GetPrivateProfileSectionA('MSPRC_MO_MSPRC_MOW', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_MSPRC_MO_MSPRC_MOW := COMPILE( fields  )

    buffer := space(lenBuff)
    GetPrivateProfileSectionA('MSPRC_MO_MSPRC_MOW_Pv', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_MSPRC_MO_MSPRC_MOW_Pv := COMPILE( fields  )

    buffer := space(lenBuff)
    GetPrivateProfileSectionA('MSPRC_MOW_PRSMLDOH', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_MSPRC_MOW_PRSMLDOH := COMPILE( if( empty(fields), '.t.', fields) )

    buffer := space(lenBuff)
    GetPrivateProfileSectionA('MSPRC_MOW_MSOSB_MO', @buffer, lenBuff, sname)
      fields := substr(buffer,1,len(trim(buffer))-1)
      fields := strtran(fields,chr(0),',')
      fields := substr(fields,1,len(fields) -1)
      ::b_MSPRC_MOW_MSOSB_MO := COMPILE( if( empty(fields), '.t.', fields) )

    ferase(sname)
    buffer := ''
  endif

  *
  ::lNEWrec     := .not. (parent:cargo = drgEVENT_EDIT)

  *                      rodinní pøíslušníci lékarské prohlídky školení/ kurzy
  * TAB                  6                   0                  0
  ::pa_vazRecs      := { {},                 {},                {}     }
  ::tabNum          := TAB_kmenove
  ::onTabselect     := {}
  ::pao_Brow        := {}
  ::paoB_editParent := { , , , , , , , , , , , , , , , , , }

  * for all
  drgDBMS:open('osobySk' )

  * TAB - 1
  drgDBMS:open('msprc_mo',,,,,'msprc_moc')        // pomocný soubor pro validace
  drgDBMS:open('mimPrvz' )
  drgDBMS:open('duchody' )
  drgDBMS:open('duchody' ,,,,, 'duchodyX')

  drgDBMS:open('msOdppol')
  drgDBMS:open('vazOsoby',,,,,'vazOsobyX')        // pro msOdppol a osoby_Rp
  drgDBMS:open('c_odpoc' )

  drgDBMS:open('prSmlDoh')                        // kopie msPrc_mo pøi ukládání

  * TAB - 2
  drgDBMS:open('msTarind')
  drgDBMS:open('msSazzam')

  * TAB - 3
  drgDBMS:open('msMzdyhd')
  drgDBMS:open('msMzdyit')

  * TAB - 4
  drgDBMS:open('msSrz_mo')
  drgDBMS:open('msSrz_mo',,,,,'msSrz_mox')        // pomocný soubor pro kopii srážek
  drgDBMS:open('druhyMzd')
  cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {nrok,nobdobi})
  druhyMzd->( ads_setaof(cfiltr), dbGoTop())
  drgDBMS:open('trvZavhd')

  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))

   drgDBMS:open('c_typpoh',,,,,'c_typpoha')

  * TAB - 5
  ** SUB TAB - 6 - osoby
  drgDBMS:open('osoby'   )
  drgDBMS:open('msOsb_mo')

  ** SUB TAB - 7 - rodiní pøíslušníci
  drgDBMS:open('osoby'   ,,,,,'osoby_Rp' )
  drgDBMS:open('c_psc'   ,,,,,'c_psc_2'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_2')

  ** SUB TAB - 8 dùchody
  drgDBMS:open('c_psc'   ,,,,,'c_psc_3'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_3')

  MZD_kmenove_cpy( self )
RETURN self


METHOD MZD_kmenove_CRD:drgDialogStart(drgDialog)
  LOCAL  x, cfile, cfield
  local  tabNum
  local  aMembers := drgDialog:oForm:aMembers, oColumn
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin
  local  lok   := .t.
  *
  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  ::inEdit := .F.
  ::aEdits := {}
  ::state  := 0

  if ::lNewRec .and. uctOBDOBI:MZD:COBDOBI <> uctOBDOBI_LAST:MZD:COBDOBI
    drgMsgBox(drgNLS:msg('Zakládat nového pracovníka lze pouze v posledním otevøeném období a to je ' + uctOBDOBI_LAST:MZD:COBDOBI +  ' !!!'))
    lok := .f.
  endif

  if lok
    for x := 1 TO len(aMembers) step 1

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
        *
        ** potøebujeme BRO pro refresh master / detail
        cfile := lower(amembers[x]:cfile)
        if( cfile = 'msmzdyhdw', ::oBRO_msMzdyhdw := amembers[x], nil )
        if( cfile = 'msmzdyitw', ::oBRO_msMzdyitw := amembers[x], nil )

      endif

      if ( amembers[x]:ClassName() = 'drgPushButton' .and. isCharacter( amembers[x]:event) )
        if lower( amembers[x]:event) = 'editparent'
          tabNum := val(amembers[x]:caption)

          aMembers[x]:isEdit        := .f.
          ::paoB_editParent[tabNum] := amembers[x]
        endif
      endif
    next

    ::oscisPrac            := ::dm:get( 'msPrc_moW->nosCisPrac' , .F.)
    ::pa_only_positiveGets := { ::dm:has( 'msSrz_moW->nSplatka'):odrg:oxbp }


  *  ::pa_only_positiveGets := { ::dm:has( 'msSrz_moW->nSplatka'):odrg:oxbp , ;
  *                              ::dm:has( 'msSrz_moW->nCelkem'):odrg:oxbp  , ;
  *                              ::dm:has( 'msSrz_moW->nNedoplat'):odrg:oxbp, ;
  *                              ::dm:has( 'msSrz_moW->nSplaceno'):odrg:oxbp, ;
  *                              ::dm:has( 'msSrz_moW->nZustatek'):odrg:oxbp  }
    ::pa_focusOnEdit       := { ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ::dm:has('msSrz_moW->czkrSrazky'), ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ''                               , ;
                                ::dm:has('vazOsobyW->ncisOsoby' ), ;
                                ::dm:has('duchodyW->ntypDuchod' ), ;
                                ''                                 }
  endif

return lok


method MZD_kmenove_CRD:ebro_beforeAppend(o_EBro)
  local  cfile := lower( o_EBro:cfile)
  local  lok   := .t.

  do case
  case cfile = 'msmzdyitw'
    lok := .not. msMzdyhdw->(eof())
  endcase
return lok


method MZD_kmenove_CRD:ebro_afterAppend(o_eBro)
  local  cfile   := lower( o_EBro:cfile)
  local  keyMatr

  do case
  case cfile = 'msmzdyhdw'

*    keyMatr := msMzdyhdW->( Ads_getLastAutoinc()) +1
    keyMatr := msMzdyhdW->( Ads_GetRecordCount()) +1

    ::dm:set( 'msMzdyhdw->laktivni', .t.)
    ::dm:set( 'msMzdyhdw->nkeyMatr', keyMatr)

    msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( keyMatr,4)), dbgoTop())
    ::oBRO_msMzdyitw:oxbp:refreshAll()

  case cfile = 'msmzdyitw'
    ::dm:set( 'msMzdyitw->laktivni', .t.)

  endcase
return .t.


method MZD_kmenove_CRD:ebro_saveEditRow(o_EBro)
  local  cfile := lower( o_EBro:cfile)
  local  ordRec, recNo, nordItem
  local  kyPoh
  * 2
  * mstarindw
  * mssazzamw

  * 3
  * msmzdyhdw
  * msmzdyitw

  if o_EBro:state = 2 .or. (cfile)->nosCisPrac = 0
    if( (cfile)->(fieldPos('ctask' )) <> 0, (cfile)->ctask  := msprc_mow->ctask , nil )
    if( (cfile)->(fieldPos('culoha')) <> 0, (cfile)->culoha := msprc_mow->culoha, nil )

    (cfile)->nosCisPrac := msprc_mow->nosCisPrac
    (cfile)->nporPraVzt := msprc_mow->nporPraVzt

    do case
    case cfile = 'msmzdyhdw'
      msMzdyhdW->ctask      := msPrc_moW->ctask
      msMzdyhdW->culoha     := msPrc_moW->culoha
      msMzdyhdW->cdenik     := 'MH'
      msMzdyhdW->nkeyMatr   := isNull( msMzdyhdW->sID, 0)
      msMzdyhdW->lautoVypHM := msMzdyhdW->ctypmasky = 'AUVYH'

      kyPoh := UPPER('MDOKLADY        ')+UPPER(AllTrim(msMzdyhdW->ctyppohybu))
      if c_typpoha->( dbSeek( kyPoh,,'C_TYPPOH02'))
        msMzdyhdW->ctypdoklad := c_typpoha->ctypdoklad
      endif
      msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( msMzdyhdW->nkeyMatr,4)), dbgoTop())

    case cfile = 'msmzdyitw'
      msMzdyitW->ctask      := msMzdyhdW->ctask
      msMzdyitW->culoha     := msMzdyhdW->culoha
      msMzdyitW->cdenik     := msMzdyhdW->cdenik
      msMzdyitW->ctypmasky  := msMzdyhdW->ctypmasky
      msMzdyitW->ctypdoklad := msMzdyhdW->ctypdoklad
      msMzdyitW->ctyppohybu := msMzdyhdW->ctyppohybu
      msMzdyitW->cpracovnik := msprc_mow->cpracovnik
      msMzdyitW->cjmenorozl := msprc_mow->cjmenorozl
      msMzdyitW->ckmenstrpr := msprc_mow->ckmenstrpr

      msMzdyitW->cucetskup  := AllTrim( Str( msMzdyitW->ndruhmzdy))
      msMzdyitW->nkeyMatr   := msMzdyhdW->nkeyMatr

//      msMzdyitW->nmsmzdyhd  := msMzdyhdW->sid    //  chyba
      msMzdyitW->( dbCommit())

      nordItem := max( o_eBro:odata:nordItem, 10)

      do case
      case o_eBro:isAppend

        if o_eBro:isAddData .or. msMzdyitW->(eof())
          msMzdyitW->nordItem := nordItem +10

        else
          msMzdyitW->nordItem := nordItem

           recNo := msMzdyitW->(recNo())
          ordRec := fordRec({ 'msMzdyitW' })

          msMzdyitW ->(AdsSetOrder(0),dbgoTop())

          do while .not. msMzdyitW->(eof())
            if msMzdyitW->nordItem >= nordItem  .and. msMzdyitW->(recNo()) <> recNo
              msMzdyitW->nordItem += 10
            endif

            msMzdyitW->(dbskip())
          enddo
          fordRec()
        endif
      endcase

    case cfile = 'mstarindw'
      mstarindw->( dbCommit())
      ::lPravdPod := VypPravdPruMS(self)

    case cfile = 'mssazzamw'
      mssazzamw->( dbCommit())
      ::lPravdPod := VypPravdPruMS(self)

    endcase
  endif

//  if cfile = 'mstarindw' .or. cfile = 'mssazzamw'
//  endif

return .t.


METHOD MZD_kmenove_CRD:postValidate(drgVar, lis_formValidate)
  LOCAL  name := Lower(drgVar:name)
  local  file := drgParse(name,'-')
  local  item := drgParseSecond( name, '>' )
  local  value := drgVar:get(), changed := drgVAR:changed()
  *
  LOCAL  lOK  := .T., pa, xval, dTm, nval
  LOCAL  cky, cjmenoRozl, cinfo
  ** new
  local  exitState :=  ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )

  default lis_formValidate to .f.

  DO CASE
  case( name = 'msprc_mow->cprijosob'  .or. ;
        name = 'msprc_mow->cjmenoosob' .or. ;
        name = 'msprc_mow->crozljmena'      )

    if( changed, (::dm:save(), ::dm:refresh(.T.)), NIL )
    lok := ::MZD_kmenove_SEL()

  CASE(name = 'msprc_mow->noscisprac')
    if Empty(value)
      ::msg:writeMessage('OSOBNÍ ÈÍSLO pracovníka je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      if ( ::lNEWrec .and. changed ) .or. (msprc_mow->nporpravzt = 0)
         cky :=  StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2) ;
                 +strzero(value,5)

        if msprc_moc->( dbseek( cky,,'MSPRMO01',.t.))
          cinfo := str(value) +'_ ' + allTrim( msPrc_moC->cjmenoRozl)
          ::msg:writeMessage('OSOBNÍ ÈÍSLO ' +cinfo +' je již obsazeno ...',DRG_MSG_ERROR)
          lOK := .f.

        else
          msprc_mow->nporpravzt := 1
          ::drgDialog:dataManager:set('msprc_mow->nporpravzt', msprc_mow->nporpravzt)
        endi
      endif
    endif

  CASE(name = 'msprc_mow->crodcispra'.and. changed)
    MSPRC_MOw->cRODCISPRN := StrTran( StrTran(value, '-', ''), '/', '')
    if .not. Empty(MSPRC_MOw->cRODCISPRN)
      if MSPRC_MOc ->(DbSeek(Upper(value),,'MSPRMO03')) .or. osoby ->( dbseek(Upper(value),,'OSOBY08'))
        ::msg:writeMessage('Nalezeno duplicitní RÈ v martièních souborech pracovníkù ...',DRG_MSG_ERROR)
        lOk := .F.
      else
        MSPRC_MOw->nRODCISPRA := Val(MSPRC_MOw->cRODCISPRN)
        MSPRC_MOw->nMUZ       := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) < '2', 1, 0)
        MSPRC_MOw->nZENA      := IF( SubStr(MSPRC_MOw->cRODCISPRA, 4, 1) > '1', 1, 0)

        if Empty( osobyW->ddatNaroz)
          osobyW->ddatNaroz := fDATzRC( value )
/*
          if SubStr( msprc_mow->cRodCisPra, 4, 1)  == "5"                     ;
            .or. SubStr( msprc_mow->cRodCisPra, 4, 1) == "6"
            osobyW->ddatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                  +if( SubStr( msprc_mow->cRodCisPra, 4, 1) == "5", "0", "1")    ;
                                    +SubStr( msprc_mow->cRodCisPra, 5, 1) +"/"                    ;
                                      +SubStr( msprc_mow->cRodCisPra, 1, 2))
          else
            osobyW->dDatNaroz := CtoD( SubStr( msprc_mow->cRodCisPra, 7,2) +"/" ;
                                  +SubStr( msprc_mow->cRodCisPra, 4,2) +"/"     ;
                                    +SubStr( msprc_mow->cRodCisPra, 1,2))
          endif
*/
          ::dm:set( 'osobyW->ddatNaroz', osobyW->ddatNaroz)
        endif
      endif
    else
      ::msg:writeMessage( 'Pokud nebude RÈ zadáno nebude pracovník založen do personalistiky ...',DRG_MSG_WARNING)
    endif

  CASE(name = 'msprc_mow->ddatnast')
    if Empty(value)
      ::msg:writeMessage('"Datum nástupu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
*      if Empty( ::drgDialog:dataManager:get('msprc_mow->ddatvznprv'))
        if value < mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI) .and. ::lnewREc
          ::msg:writeMessage('"POZOR datum nástupu je menší než první den období ...',DRG_MSG_WARNING)
        endif

        ::drgDialog:dataManager:set('msprc_mow->ddatvznprv', value)
        if changed
          dTm := if( empty( msprc_mow->ddatvyst), mh_LastODate( uctOBDOBI:MZD:NROK, 12), msprc_mow->ddatvyst)
          if msprc_mow->nRok >= 2021
            if msprc_mow->nHDoBezNar = 0
              nvalue := prepNarDov21( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nTDoBezNar'), ::drgDialog:dataManager:get('msprc_mow->cdelkprdob'))
              ::drgDialog:dataManager:set('msprc_mow->nhdobeznar', nvalue)
            endif
            if msprc_mow->nHDdBezNar = 0
              nvalue := prepNarDov21( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nTDDBezNar'), ::drgDialog:dataManager:get('msprc_mow->cdelkprdob'))
              ::drgDialog:dataManager:set('msprc_mow->nhddbeznar', nvalue)
            endif
            prepZustDov21(::drgDialog)
          else
            if msprc_mow->nDovBezNar = 0
              nvalue := prepNarDov( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nNarDovol'))
              ::drgDialog:dataManager:set('msprc_mow->ndovbeznar', nvalue)
            endif
            if msprc_mow->nDodBezNar = 0
              nvalue := prepNarDov( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nNarDovolD'))
              ::drgDialog:dataManager:set('msprc_mow->ndodbeznar', nvalue)
            endif
            prepZustDov(::drgDialog)
          endif

          ::lPravdPod := VypPravdPruMS(self)
        endif
*      endif
    endif

  CASE(name = 'msprc_mow->cdrupravzt')
    do case
    case msprc_mow->cdrupravzt = 'DOHODA'
      ::drgDialog:dataManager:set('msprc_mow->cvznpravzt', 'DOHODOU')
    endcase

  CASE(name = 'msprc_mow->ntyppravzt')
    if Empty(value)
      ::msg:writeMessage('"Typ pracovního vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      MSPRC_MOw->nCLENSPOL  := IF( value $ {2,3,4}, 1, 0)
      ::drgDialog:dataManager:set('msprc_mow->cTypPPVReg', c_pracvz->cTypPPVReg)
      ::drgDialog:dataManager:set('msprc_mow->lzdrpojis',  c_pracvz->lzdrpojis)
      ::drgDialog:dataManager:set('msprc_mow->lsocpojis',  c_pracvz->lsocpojis)
    endif

  CASE(name = 'msprc_mow->ddatvyst')
    MSPRC_MOw->nTMDATVYST := IF( Empty(value), 99999999, (Year(value) *10000) +(Month(value) *100) +Day(value))
    if changed .and. .not. Empty( value)
      dTm := if( msprc_mow->ddatnast < mh_FirstODate( uctOBDOBI:MZD:NROK, 1), mh_FirstODate( uctOBDOBI:MZD:NROK, 1), msprc_mow->ddatnast)

      if msprc_mow->nrok >= 2021
        if msprc_mow->nHDoBezNar = 0
          nvalue := prepNarDov21( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nTDoBezNar'), ::drgDialog:dataManager:get('msprc_mow->cdelkprdob'))
          ::drgDialog:dataManager:set('msprc_mow->nhdobeznar', nvalue)
        endif
        if msprc_mow->nHDdBezNar = 0
          nvalue := prepNarDov21( ::drgDialog:dataManager:get('msprc_mow->ddatnast'), dTm, SysConfig( 'Mzdy:nTDDBezNar'), ::drgDialog:dataManager:get('msprc_mow->cdelkprdob'))
          ::drgDialog:dataManager:set('msprc_mow->nhddbeznar', nvalue)
        endif
        prepZustDov21(::drgDialog)
      else
        nvalue := prepNarDov( dTm, ::drgDialog:dataManager:get('msprc_mow->ddatvyst'), msprc_mow->nDovBezNar )
        ::drgDialog:dataManager:set('msprc_mow->ndovbeznar', nvalue)

        nvalue := prepNarDov( dTm, ::drgDialog:dataManager:get('msprc_mow->ddatvyst'), msprc_mow->nDodBezNar )
        ::drgDialog:dataManager:set('msprc_mow->ndodbeznar', nvalue)

        prepZustDov(::drgDialog)
      endif
    endif

  CASE(name = 'msprc_mow->ntypzamvzt')
    if Empty(value)
      ::msg:writeMessage('"Typ zamìstnaneckého vztahu je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    endif

  CASE(name = 'msprc_mow->nZdrPojis')
    if value = 0 .and. ::dm:get( 'msprc_mow->lZdrPojis' )
      ::msg:writeMessage('Pozor nemáte nastavenou zdravotní pojišovnu ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      if .not. ::dm:get( 'msprc_mow->lZdrPojis' ) .and. ( ::dm:get( 'msprc_mow->ntyppravzt' ) = 5 .or.         ;
                 ( ::dm:get( 'msprc_mow->ntyppravzt' ) >= 30 .and. ::dm:get( 'msprc_mow->ntyppravzt' ) <= 35))

        ::msg:writeMessage('Pozor nemáte nastaveno, že zamìstnanec je zdravotnì pojištìn ...',DRG_MSG_ERROR)
      endif
    endif


  CASE(name = 'mstarindW->dplattarod')
    if Empty(value)
      ::msg:writeMessage('Datum platnosti by mìl být uveden. Jinak nebude možné sledovat historii ...',DRG_MSG_WARNING)
    endif

  * mzdové údaje 2 - tabPage
  CASE(name = 'mstarindW->ntarsazhod')
    if changed .and. value <> 0
      ::lPravdPod := VypPravdPruMS(self)
    endif

  CASE(name = 'mstarindW->ntarsazmes')
    if changed .and. value <> 0
      ::lPravdPod := VypPravdPruMS(self)
    endif

  CASE(name = 'mssazzamW->nsazba')
    if changed .and. value <> 0
      ::lPravdPod := VypPravdPruMS(self)
    endif

  CASE(name = 'msprc_mow->nalgprapru')
    if changed
//      ::lPravdPod := VypPravdPruMS(self)
    endif


  * srážky 4 - tabPage
  case ( file = 'mssrz_mow' .and. ::tabNum = TAB_srazky )   // .and. ::state <> 0 )

    do case
    case ( item = 'czkrsrazky' .and. changed )

      if c_srazky->ctypSrz = "SR00"
        fordRec( { 'mssrz_mow' }  )
        if mssrz_mow->( dbseek( "SR00",,'MSSRZW05'))
          fin_info_box( 'Srážka - ' +CRLF +;
                        'prevod mzdy na úcet mùže být použita jen jednou .... ')
          lOk := .f.
        endif
        fordRec()
      endif

      ::msSrz_moW_modiCards( c_srazky->ctypSrz, .t. )

      ::dm:set( 'mssrz_mow->lprednPohl' , c_srazky->lprednPohl )
      ::dm:set( 'mssrz_mow->cpopSrazky' , c_srazky->cnazSrazky )
      ::dm:set( 'mssrz_mow->ndruhMzdy'  , c_srazky->ndruhMzdy  )
      ::dm:set( 'mssrz_mow->ndruhMzdy2' , c_srazky->ndruhMzdy2 )
      ::dm:set( 'mssrz_mow->ndruhMzdy3' , c_srazky->ndruhMzdy3 )

    case ( item = 'nporuplsrz' .and. changed )
      if value = 90
        fin_info_box( 'Poøadí uplatnìní srážky - 90 - ' +CRLF +;
                      'je urèeno pouze pro prevod mzdy na úcet .... ')
        return .f.
      endif

      fordrec( { 'mssrz_mow' } )
      if mssrz_mow->( dbseek( value,, 'MsSrzW01'))
        if empty( mssrz_mow->_delRec)
          lok := drgIsYESNO( 'Poøadí srážky _' +str(value) +'_ již EXISTUJE, ; ' + ;
                             'povolujete pøeèíslování poøadí stážek ?'             )
        endif
      endif
      fordrec()

    case ( name = 'mssrz_mow->ncelkem'   )
      if c_srazky->ctypSrz = 'SRUV'    // Ostatní pùjèky, Pùjèka z FKSP ..
        if empty( value )
          fin_info_box( 'U srážky - '                     + CRLF + ;
                        '[ ' + c_srazky->cnazSrazky +' ]' + CRLF + ;
                        'je __celkem srážka__ povinný údaj .... ')
          lOk := .f.
        endif
      endif

    case ( name = 'mssrz_mow->cucet_uct' )
      if exitState
        PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
        ::df:nexitState = 0
      endif
    endcase


  case ( name = 'osobyw->cidoskarty' )
    if changed
      drgDBMS:open('osoby'   ,,,,,'osoby_oW' )

      if osoby_oW->( dbSeek( value,,'Osoby22')) .and. .not. Empty(value)
        lOk   := .f.
        fin_info_box( 'id karty < ' + AllTrim(value) +' >, je již použito u osoby' +CRLF + ;
                      AllTrim( osoby_oW->cjmenorozl), XBPMB_CRITICAL )
      endif
    endif

  case ( name = 'vazosobyw->ncisOsoby' )
    lok := ::per_osoby_sel()

  case ( name = 'vazosobyw->lsleodpdan' .or. ;
         name = 'duchodyw->ncisfirmy'        )

    if exitState
      PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
      ::df:nexitState = 0
    endif



  endcase


* 1  MSPRC_MOw
* 2  MSPRC_MOw   mstarindW mssazzamW NE
* 3  msMzdyHDw   msMzdyITw           NE
* 4              MSPRC_MOw           NE
* 5              msmzdyitW           NE
* 6 osobyW

  ** ukládáme pøi zmìnì do tmp jen u vybraných souborù **
  if file = 'msprc_mow' .or. file = 'osobyw'
    if( changed, (::dm:save(), ::dm:refresh(.T.)), NIL )
  endif
RETURN lOk


METHOD MZD_kmenove_CRD:onSave(lIsCheck,lIsAppend)
RETURN .F.


METHOD MZD_kmenove_CRD:destroy()
RETURN SELF


METHOD MZD_kmenove_CRD:MZD_kmenove_SEL(drgDialog)
  local  showDlg := .f., ok := .f., isOk := .f.
  local  odrg    := ::dm:drgDialog:lastXbpInFocus:cargo
  local  items   := lower(drgParseSecond(odrg:name,'>'))
  *
  local  odialog, nexit := drgEVENT_QUIT
  local  cInfo   := 'Promiòte prosím,', paButon, nsel, cansWer_SEL
  local  aButton := {  { '   ~Ano    ', '    ~Ne   '                                      }, ;
                       { '~Ano', '~Pøevzít z pøedchozího Pv', 'Nové ~Osobní èíslo', '~Ne' }, ;
                       { '~Ano', '~Pøevzít z pøedchozího Pv'                              }  }
  *
  local  cjmenoRozl := allTrim( msPrc_moW->cprijOsob ) +' ' + ;
                       allTrim( msPrc_moW->cjmenoOsob) +' ' + ;
                       allTrim( msPrc_moW->cRozlJmena)

  if isObject(drgDialog)
    showDlg := .t.

  else
    do case
    case empty( cjmenoRozl)
      cInfo += CRLF +'identifikace pracovníka / pøíjmení, jméno /' +CRLF +CRLF + ;
                     'jsou povinné údaje !!! '
      fin_info_box( cinfo, XBPMB_CRITICAL)
      return .f.

    case osoby->(dbseek( upper( cjmenoRozl),,'OSOBY09'))
      if osoby->noscisPrac = 0 .or. ( osoby->noscisPrac <> 0 .and. osoby->nPorPraVzt = 0)
        cInfo       += ';osoba <' +cjmenoRozl +'_' +str( osoby->ncisOsoby) +'>;' + ;
                       'existuje v evidenci osob,;'                              + ;
                       'požadujete založit nový zamìstnanecký vztah ?'

        paButton    := aButton[1]
        cansWer_SEL := '0'
      else
        cInfo       += ';pracovník <' +cjmenoRozl +'_' +str( osoby->nosCisPrac) +'>;' + ;
                       'již existuje, požadujete založit nový pracovní vztah ?'
        paButton    := aButton[2]
        cansWer_SEL := '1'
      endif

      nsel        := alertBox( ::drgDialog:dialog, cInfo                 , ;
                                 paButton, XBPSTATIC_SYSICON_ICONQUESTION, ;
                                'Zvolte možnost ...'                       )
      cansWer_SEL += str( nsel,1)

      do case
      case( nsel <> 0 .and. nsel <> len(paButton))
        ok := ::MZD_copy_tomsPrc( cansWer_SEL )
      otherWise
        ok := if( items = 'crozljmena', .f., ;
               if( empty(msPrc_moW->cRozlJmena), .t., .f. ))
      endcase

    otherWise
      ok := .t.
    endcase
  endif

  **
  if showDlg
    odialog := drgDialog():new('MZD_kmenove_SEL', ::drgDialog)
    odialog:create(,,.T.)
    nexit := odialog:exitState

    if nexit <> drgEVENT_QUIT

      if osoby->noscisPrac = 0
        ok := ::MZD_copy_tomsPrc( '01' )

      else

        cjmenoRozl  := osoby->cjmenoRozl
        cInfo       += ';pracovník <' +cjmenoRozl +'_' +str( osoby->nosCisPrac) +'>;' + ;
                       'již existuje, požadujete založit nový pracovní vztah ?'
        paButton    := aButton[2]
        cansWer_SEL := '1'

        nsel        := alertBox( ::drgDialog:dialog, cInfo                 , ;
                                   paButton, XBPSTATIC_SYSICON_ICONQUESTION, ;
                                  'Zvolte možnost ...'                       )
        cansWer_SEL += str( nsel,1)

        do case
        case( nsel <> 0 .and. nsel <> len(paButton))
          ok := ::MZD_copy_tomsPrc( cansWer_SEL )

          ::oscisPrac:odrg:isEdit := (nsel = 3)
          if( nsel = 3, ::oscisPrac:odrg:oxbp:enable(), ::oscisPrac:odrg:oxbp:disable() )
        otherWise
          ok := .f.
        endcase

      endif
    endif
  endif
return (nexit != drgEVENT_QUIT) .or. ok



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