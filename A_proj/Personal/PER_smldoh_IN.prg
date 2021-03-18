#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"


#include "..\Asystem++\Asystem++.ch"


*  ZMÌNY PRACOVNÍCH SMUV a DOHOD
** CLASS PER_smldoh_IN **********************************************************
CLASS PER_smldoh_IN FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart
  method  postValidate, destroy


  inline method ebro_afterAppend()
    local  nporZmeny := prsmdozm->(Ads_GetRecordCount())
      ::nPorIT := nporZmeny +1
    ::dm:set( 'prsmdozm->nPorZmeny', ::nPorIT )
//    ::dm:set( 'prsmdozm->nPorZmeny', nporZmeny +1 )
  return self


  inline method eBro_saveEditRow(o_eBro)
    if prsmdozm->ncisosoby = 0
      mh_copyFld('msprc_mo', 'prsmdozm', .f., .t.)
//      mh_copyFld('prsmldoh', 'prsmdozm', .f., .t.)
      prSmDozm->nPorZmeny := ::nPorIT
      prSmDozm->nPRSMLDOH := prSmlDoh->sID
      prSmDozm->nOSOBY    := osoby->sID
      prSmDozm->nMSPRC_MO := msprc_mo->sID
    endif
    return .t.


  *
  **
  inline method eventHandled(nEvent,mp1,mp2,oXbp)
    local  tabNum, cfile
//    local  drgVar    := ::pa_focusOnEdit[::tabNum]
//    local  drgButton := ::paoB_editParent[::tabNum]
//    local  inEdit := (oXbp:ClassName() <> 'XbpBrowse')

    do case
    case nEvent = xbeBRW_ItemMarked
//      ::msg:editState:caption := 0
//      ::msg:WriteMessage(,0)
//      ::state := 0
//      ::restColor()
/*
      osoby_Rp->(dbseek( vazOsobyW->ncisOsoby,,'OSOBY01'))
      ::dm:refresh()

      if isObject(drgVar)
        (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )

        if isObject(drgButton)
          if( (::it_file)->(eof()), drgButton:disable(), drgButton:enable())
        endif
      endif
      ::relForText()
*/      return .F.

    case(nevent = drgEVENT_ACTION)
****      cfile  := if( isObject(drgVar), lower(drgParse(drgVar:name,'-')), '')

/*
      if isNumber( mp1 )
        if     mp1 = drgEVENT_APPEND

           ::state := 2
           ( ::relForText(), ::dm:refreshAndSetEmpty( cfile ) )

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
            PER_smldoh_IN_wrt()

            _clearEventLoop()
            PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
            RETURN .T.
          endcase
        endif
      endif
*/
    case nEvent = drgEVENT_DELETE
/*
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        if( .not. (::it_file) ->(eof()), ::all_broDelete( lower(::it_file), ::oDbro), nil )
        return .t.
      endif
*/
    case nEvent = xbeP_Keyboard
/*
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
*/
      return .f.

    endCase
    return .F.


HIDDEN:
  VAR   msg, dm, dc, df, ab, brow

  VAR   lnewRec
  VAR   oDbro, inEdit, aEdits
  VAR   it_file
  VAR   nPorIT
/*
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

  */
ENDCLASS


METHOD PER_smldoh_IN:init(parent)

  ::drgUsrClass:init(parent)
RETURN self


METHOD PER_smldoh_IN:drgDialogStart(drgDialog)
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

  ::nPorIT := 0
*  ::ab     := drgDialog:oActionBar:members      // actionBar

//  ::oDbro   := drgDialog:dialogCtrl:oBrowse[1]
//  ::inEdit := .F.
//  ::aEdits := {}
//  ::state  := 0

/*
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

*/
return self


METHOD PER_smldoh_IN:postValidate(drgVar, lis_formValidate)
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
  case ( name = 'prsmdozm->ctypzmsmdo' ) .and. changed
    ::dm:set( 'prsmdozm->cpopiszmen', c_zmsmdo->cPopisZmen )


//  case ( name = 'vazosobyw->lsleodpdan' .or. ;
//         name = 'duchodyw->ncisfirmy'        )

//    if exitState
//      PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
//      ::df:nexitState = 0
//    endif
  endcase
*/
return lok



METHOD PER_smldoh_IN:destroy()
 ::drgUsrClass:destroy()

RETURN SELF
