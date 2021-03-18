#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"


#include "..\Asystem++\Asystem++.ch"


*  DUCHODY k osobám
** CLASS PER_duchody_IN ******************************************************
CLASS PER_duchody_IN FROM drgUsrClass, MZD_kmenove_IN
EXPORTED:
  METHOD  init, drgDialogStart
  method  postValidate, destroy

  inline access assign method nazDuchod() var nazDuchod
    c_duchod->(dbseek( duchodyW->ntypDuchod,,'C_DUCHOD01'))
    return c_duchod->cnazDuchod

  inline access assign method is_aktiv() var is_aktiv
    return if( duchodyW->lAktiv, MIS_ICON_OK, 0 )

  *
  **
  inline method eventHandled(nEvent,mp1,mp2,oXbp)
    local  tabNum, cfile
    local  drgVar    := ::pa_focusOnEdit[::tabNum]
    local  drgButton := ::paoB_editParent[::tabNum]
    local  inEdit := (oXbp:ClassName() <> 'XbpBrowse')

    do case
    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0
      ::restColor()

      ::dm:refresh()

      if isObject(drgVar)
        (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )

        if isObject(drgButton)
          if( (::it_file)->(eof()), drgButton:disable(), drgButton:enable())
        endif
      endif
      ::relForText()
      return .F.

    case(nevent = drgEVENT_ACTION)

      if isNumber( mp1 )
        if     mp1 = drgEVENT_APPEND

           ::state := 2
           ( ::relForText(), ::dm:refreshAndSetEmpty( ::it_file ) )

           ::df:setNextFocus( drgVar:odrg,, .T. )
           ( drgVar:odrg:isEdit           := .t., ;
             drgVar:odrg:pushGet:disabled := .f., ;
             drgVar:odrg:oxbp:enable()            )
           return .t.

        elseif mp1 = drgEVENT_EDIT
          ::df:setNextFocus( drgvar:odrg,, .T. )
          RETURN .T.

        elseif mp1 = drgEVENT_SAVE
          do case
          case  inEdit
            if ::postValidate_onTabs( ::it_file )
              ::save_onTabs( ::it_file )
              ::setFocus_onTab(.t.)
              ::state := 0
              _clearEventLoop()
              return .t.
            endif

          otherwise
            *  ukládáme celou kartu
            PER_duchody_in_wrt()

            _clearEventLoop()
            PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
            RETURN .T.
          endcase
        endif
      endif

    case nEvent = drgEVENT_DELETE
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        if( .not. (::it_file) ->(eof()), ::all_broDelete( lower(::it_file), ::oDbro), nil )
        return .t.
      endif

    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        do case
        case inEdit
          ::setFocus_onTab(.t.)
          postAppEvent(xbeBRW_ItemMarked,,,::oDbro:oxbp)
          return .t.

        otherWise
           if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,::oDbro:oXbp), nil)
        endcase
        return .t.
      endif
      return .f.


    endCase
    return .f.


HIDDEN:
  VAR   lnewRec
  VAR   oDbro, inEdit, aEdits
  VAR   it_file

  inline method all_broDelete( cfile, obro )
    local  cInfo  := 'Promiòte prosím,'          +CRLF + ;
                     'požadujete zrušit položku '
    local  cc     := '', nsel, pa := {}, recNo, npos

    do case
    case( cfile = 'mstarindw' ) ;  cc := 'individuálního tarifu'     // Individuální tarif pro zamìstnance
    case( cfile = 'mssazzamw' ) ;  cc := 'individuální sazby'        // Sazbu  pro zamìstance
    case( cfile = 'mssrz_mow' ) ;  cc := 'pøednastavené srážky'      // Srážku pro zamìstnance
    case( cfile = 'vazosobyw' ) ;  cc    := 'rodinného pøíslušníka'  // Vazby na rodinné pøíslušníky
                                   pa    := ::pa_vazRecs[1]
                                   recNo := osoby_Rp->(recNo())
    case( cfile = 'duchodyw'  ) ;  cc    := 'pøiznaného dùchodu'     // dùchody
    endcase

    if .not. empty(cc)
      cInfo += '. ' +upper(cc) +' .' +CRLF + CRLF + ;
               'pro pracovníka _' +upper( allTrim(msprc_mo->cpracovnik)) +'_'

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

        obro:oxbp:panHome():refreshAll()

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
    return (nsel = XBPMB_RET_YES)


ENDCLASS


METHOD PER_duchody_IN:init(parent)
  local  nKy := msPrc_mo->ncisOsoby

  ::drgUsrClass:init(parent)
  ::it_file := 'duchodyW'

  *                      rodinní pøíslušníci lékarské prohlídky školení/ kurzy
  * TAB                  6                   0                  0
  ::pa_vazRecs      := { {},                 {},                {}     }
  ::tabNum          := 7
  ::onTabselect     := {}
  ::pao_Brow        := {}
  ::paoB_editParent := { , , , , , , }

  * zákkladní soubor pro doplnìní vazeb
  drgDBMS:open( 'msPrc_moW', .T., .T., drgINI:dir_USERfitm); ZAP
  mh_copyFld( 'msPrc_mo', 'msPrc_moW',, .t. )

  * dùchody
  drgDBMS:open('duchody')
  drgDBMS:open('duchody' ,,,,, 'duchodyX')

  ** SUB TAB - 7 dùchody
  drgDBMS:open('c_psc'   ,,,,,'c_psc_3'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_3')

  * TMP soubory
  drgDBMS:open('duchodyW',.T.,.T.,drgINI:dir_USERfitm); ZAP

  duchodyX->( adsSetOrder('DUCHODY04')   , ;
              dbsetScope(SCOPE_BOTH, nKy), ;
              dbgoTop()                  , ;
              dbEval( { || mh_copyFld('duchodyX', 'duchodyW' , .t., .t.) } ))

RETURN self


METHOD PER_duchody_IN:drgDialogStart(drgDialog)
  LOCAL  x, cfield
  local  tabNum
  local  aMembers := drgDialog:oForm:aMembers, oColumn
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar

  ::oDbro   := drgDialog:dialogCtrl:oBrowse[1]
  ::inEdit := .F.
  ::aEdits := {}
  ::state  := 0

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
    endif

    if ( amembers[x]:ClassName() = 'drgPushButton' .and. isCharacter( amembers[x]:event) )
      if lower( amembers[x]:event) = 'editparent'
        tabNum := val(amembers[x]:caption)

        aMembers[x]:isEdit        := .f.
        ::paoB_editParent[tabNum] := amembers[x]
      endif
    endif
  next

  ::pa_focusOnEdit := { ''                               , ;
                        ''                               , ;
                        ::dm:has('msSrz_moW->czkrSrazky'), ;
                        ''                               , ;
                        ''                               , ;
                        ::dm:has('vazOsobyW->ncisOsoby' ), ;
                        ::dm:has('duchodyW->ntypDuchod' )  }

return self


METHOD PER_duchody_IN:postValidate(drgVar, lis_formValidate)
  LOCAL  name := Lower(drgVar:name)
  local  file := drgParse(name,'-')
  local  item := drgParseSecond( name, '>' )
  local  value := drgVar:get(), changed := drgVAR:changed()
  *
  LOCAL  lOK  := .T., pa, xval
  LOCAL  cky, cjmenoRozl
  ** new
  local  exitState :=  ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )

  default lis_formValidate to .f.

  do case
  case ( name = 'duchodyw->ntypduchod' )
    lOk := c_duchod->(dbseek( value,,'C_DUCHOD01'))
    if( lOk, nil, fin_info_box( 'Typ dùchodu - je povinný údaj .... '))

  case ( name = 'vazosobyw->lsleodpdan' .or. ;
         name = 'duchodyw->ncisfirmy'        )

    if exitState
      PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
      ::df:nexitState = 0
    endif
  endcase
return lok


METHOD PER_duchody_IN:destroy()
 ::drgUsrClass:destroy()

RETURN SELF


*
**
static function PER_duchody_in_wrt()
  local  ok       := .t.
  local  x, cfile_M, paLock, paObj, cfile_W, paVaz, isEmpty, val, nIn
  local  pa_osobySk, nsk
  *
  local                                     modify_cisOsoby
  local                                          modify_oscisPrac
  local  paF := {  { 'duchody' , {}, nil, 0, .t., .t. } }

  * musíme napozicovat osoby pro sID
  osoby->(dbseek( msPrc_mo->ncisOsoby,,'OSOBY01'))

  * zámky
  for x := 1 to len(paF) step 1
    cfile_M := paF[x,1]
    cfile_W := cfile_M +'w'
    paLock  := paF[x,2]
    paObj   := paF[x,3]

    (cfile_W)->(ordSetFocus(0), dbgoTop())

    do while .not. (cfile_W)->(eof())
      if((cfile_W)->_nrecor <> 0, AAdd(paLock, (cfile_W)->_nrecor), nil)

      if isArray(paObj) .or. isCharacter(paObj)
        isEmpty := .t.
        if isArray(paObj)
          AEval(paObj,{|x| isEmpty := (isEmpty .and. empty( eval(x:ovar:block))) })
        else
          isEmpty := (isEmpty .and. .not. DBGetVal(paObj))
        endif

        if( isEmpty, (cfile_W)->_delrec := '9', nil)
      endif
      (cfile_W)->(dbSkip())
    enddo

    ok := (ok .and. (cfile_M)->(sx_RLock(paLock)))
  next

  * ukládáme
  if ok
    for x := 1 to len(paF) step 1
      cfile_M          := paF[x,1]
      cfile_W          := cfile_M +'w'
      paLock           := paF[x,2]
      paVaz            := paF[x,4]
      modify_cisOsoby  := paF[x,5]
      modify_oscisPrac := paF[x,6]
      pa_osobySk       := {}

      (cfile_W)->(dbgoTop())

      do while .not. (cfile_W)->(eof())
        if (cfile_W)->_delrec <> '9'

          if((nrecor := (cfile_W)->_nrecor) = 0, nil, (cfile_M)->(dbgoto(nrecor)))
          if   (cfile_W)->_delrec = '9'  ;  (cfile_M)->(dbdelete())
          else
            if( paVaz = 1, (cfile_W)->OSOBY  := isNull( osoby->sID, 0), nil )
            if( paVaz = 2, (cfile_W)->nOSOBY := isNull( osoby->sID, 0), nil )

            if cfile_M = 'osoby'
              do case
              case ( osobyW->nis_PER +osobyW->nis_ZAM ) = 0
                osobyW->nis_PER := 1
                osobyW->nis_ZAM := 1
                pa_osobySk      := {'PER','ZAM'}

              case osobyW->nis_PER = 0
                osobyW->nis_PER := 1
                pa_osobySk      := {'PER'}

              case osobyW->nis_ZAM = 0
                osobyW->nis_ZAM := 1
                pa_osobySk      := {'ZAM'}
              endcase
            endif

            if modify_cisOsoby  .and. (cfile_W)->(fieldPos('ncisOsoby' )) <> 0
              (cfile_W)->ncisOsoby := osoby->ncisOsoby
            endif

            if modify_oscisPrac .and. (cfile_W)->(fieldPos('noscisPrac')) <> 0
              (cfile_W)->noscisPrac := msPrc_mo->noscisPrac
            endif

            mh_copyFld(cfile_W, cfile_M, ((cfile_W)->_nrecor = 0))

            for nsk := 1 to len(pa_osobySk) step 1
              osobySk->(dbappend(),Rlock())
              osobySk->ncisOsoby := osoby->ncisOsoby
              osobySk->czkr_skup := pa_osobySk[nsk]
              osobySk->(dbUnlock(), dbcommit())
            next

            if(nIn := AScan(paLock, nrecor)) <> 0
              (adel(paLock,nIn), asize(paLock, len(paLock) -1))
            endif
          endif
        endif

        (cfile_W)->(dbSkip())
      enddo

      AEval(paLock, {|recs| (cfile_M)->(dbgoTo(recs), dbDelete()) })
    next

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat KMENOVÉ údaje pracovníka, blokováno uživatelem !!!'))
  endif

  AEval( paF, { |x| (x[1])->(dbUnlock(),dbCommit()) })
return ok