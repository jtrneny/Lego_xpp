#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"

#include "..\Asystem++\Asystem++.ch"


*  DOSAŽENÉ VZDÌLÁNÍ
** CLASS PER_vzdelani_IN ******************************************************
CLASS PER_vzdelani_IN FROM drgUsrClass //, MZD_kmenove_IN
EXPORTED:
  METHOD  init, drgDialogStart
  method  postValidate, destroy

  inline access assign method nazVzdela() var nazVzdela
    c_vzdel->( dbseek( upper( vzdelaniW->czkrVzdel),,'C_VZDEL01'))
    return c_Vzdel->cnazVzdela

  *
  **
  inline method eventHandled(nEvent,mp1,mp2,oXbp)
    local  tabNum, cfile
    local  drgVar    := ::o_zkrVzdel
    local  inEdit := (oXbp:ClassName() <> 'XbpBrowse')

    do case
    case nEvent = xbeBRW_ItemMarked
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0

      if( inEdit, ::setFocus( .t. ), nil )

      ::restColor()
      ::relForText()
      ::dm:refresh()

      if isObject(drgVar)
        (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
      endif
      return .F.

    case(nevent = drgEVENT_ACTION)
      cfile  := if( isObject(drgVar), lower(drgParse(drgVar:name,'-')), '')

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
            ::save_items()
            return .t.

          otherwise
            *  ukládáme celou kartu
            PER_vzdelani_in_wrt()

            _clearEventLoop()
            PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
            RETURN .T.
          endcase
        endif
      endif

    case nEvent = drgEVENT_DELETE
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        if( .not. vzdelaniW ->(eof()), ::delete_item(), nil )
        return .t.
      endif

    case nEvent = xbeP_Keyboard
      if mp1 == xbeK_ESC
        do case
        case inEdit
          ::setFocus(.t.)
          postAppEvent(xbeBRW_ItemMarked,,,::oDbro:oxbp)
          return .t.

        otherWise
           if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,::oDbro:oXbp), nil)
        endcase
        return .t.
      endif
      return .f.

    endCase
    return .F.


HIDDEN:
  var   msg, dm, dc, df, ab
  var   state, pao_brow

  VAR   lnewRec
  VAR   oDbro, inEdit
  var   o_zkrVzdel

  VAR   it_file

  inline method relForText()

    if ::state = 2
      ::dm:set( 'C_PSC_2->CMISTO'      , '' )
      ::dm:set( 'C_STATY_2->cNAZEVSTAT', '' )
    else
      c_vzdel   ->( dbseek( upper( vzdelaniW->czkrVzdel) ,,'C_VZDEL01' ))
      c_vzdeUK  ->( dbseek( upper( vzdelaniW->czkrUkoVzd),,'C_VZDEUK01'))
      c_psc_2   ->( dbseek( upper( vzdelaniW->cpsc)      ,, 'C_PSC1'   ))
      c_staty_2 ->( dbseek( upper( vzdelaniW->czkratStat),, 'C_STATY1' ))
    endif
    return self

  inline method restColor()
    local  members := ::df:aMembers

    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  inline method setFocus( refreshAll )
    local  nIn       := 1
    local  drgVar    := ::o_zkrVzdel

    default refreshAll to .f.

    ::df:olastdrg   := ::pao_brow[nIn,2]
    ::df:nlastdrgix := ::pao_brow[nIn,1]
    ::dm:drgDialog:lastXbpInFocus := ::pao_brow[nIn,2]:oxbp

    ::dc:oaBrowse := ::pao_brow[nIn,2]
    brow := ::dc:oaBrowse:oXbp
    ::dm:refresh()

    if( refreshAll, ( brow:refreshAll(), ::restColor(), setAppFocus(brow) ), nil )
    return self

  inline method save_items()
    local  npor    := vzdelaniW->( Ads_getLastAutoinc()) +1
    local  lnewRec := ( vzdelaniW->(eof()) .or. ::state = 2)
    *
    local  vars    := ::dm:vars, drgVar, x

    if lnewRec
      mh_copyFld( 'osoby', 'vzdelaniW', .t., .f. )
      vzdelaniW->nOSOBY  := isNull( osoby->sID, 0)
      vzdelaniW->nporadi := npor
    endif

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      groups := isNull( drgVar:odrg:groups, '' )

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0
        if (eval(drgvar:block) <> drgVar:value)
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next

    ::setFocus(.t.)
    ::state := 0
    _clearEventLoop()
    return self

  inline method delete_item()
    local  cInfo  := 'Promiòte prosím,'                   +CRLF       + ;
                     'požadujete zrušit položku VZDÌLÁNÍ' +CRLF +CRLF + ;
                     'pro pracovníka _' +upper( allTrim(osoby->cjmenoRozl)) +'_'

    nsel := ConfirmBox( , cInfo, ;
                         'Zrušení položky vzdìlání ...' , ;
                         XBPMB_YESNO                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      vzdelaniW ->_delrec := '9'
      if( vzdelaniW ->_nrecor = 0, vzdelaniW->( dbdelete()), nil )

      ::oDBro:oxbp:panHome():refreshAll()

      if vzdelaniW->( eof())
        ::oDBro:oxbp:up():forceStable()
        ::oDBro:oxbp:refreshAll()
      endif
      ::relForText()
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


METHOD PER_vzdelani_IN:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
  drgDBMS:open( 'c_vzdel'  )
  drgDBMS:open( 'c_vzdeUK' )

  drgDBMS:open('c_psc'   ,,,,,'c_psc_2'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_2')

  drgDBMS:open( 'vzdelaniW', .T., .T. , drgINI:dir_USERfitm); ZAP

  vzdelani->( dbeval( {|| mh_copyFld( 'vzdelani', 'vzdelaniW', .t., .t. ) } ), ;
              dbgoTop()                                                        )
RETURN self


METHOD PER_vzdelani_IN:drgDialogStart(drgDialog)
  LOCAL  x, cfield
  local  tabNum
  local  aMembers := drgDialog:oForm:aMembers, oColumn
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  * NEWs *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // dialogForm
  ::ab       := drgDialog:oActionBar:members      // actionBar

  ::oDbro    := drgDialog:dialogCtrl:oBrowse[1]
  ::inEdit   := .F.
  ::state    := 0
  ::pao_Brow := {}

  ::o_zkrVzdel  := ::dm:has('vzdelaniW->czkrVzdel' )

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
return self


METHOD PER_vzdelani_IN:postValidate(drgVar, lis_formValidate)
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
  case ( name = 'vazosobyw->ncisosoby' )
    lok := ::per_osoby_sel()

  case ( name = 'vazosobyw->lsleodpdan' .or. ;
         name = 'duchodyw->ncisfirmy'        )


  case ( name = 'vzdelaniw->czkratstat' )
    if exitState
      PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
      ::df:nexitState = 0
    endif
  endcase
return lok


METHOD PER_vzdelani_IN:destroy()
 ::drgUsrClass:destroy()

RETURN SELF

*
**
static function PER_vzdelani_in_wrt()
  local  mainOk := .t., nrecOr
  local  anVzd  := {}

  vzdelaniW->( AdsSetOrder(0)                                   , ;
               dbeval( { || aadd( anVzd, vzdelaniW->_nrecor ) } , ;
                       { || vzdelaniW->_nrecor <> 0           } ) )

  mainOk := vzdelani->( sx_rlock( anVzd ))

  if mainOk
    vzdelaniW->( dbgoTop())

    do while .not. vzdelaniW ->(eof())
      if((nrecor := vzdelaniW ->_nrecor) = 0, nil, vzdelani->(dbgoto(nrecor)))

      if   vzdelaniW ->_delrec = '9'
        if( nrecor <> 0, vzdelani ->(dbdelete()), nil )
      else
        mh_copyFld( 'vzdelaniW', 'vzdelani', (nrecOr = 0), .f. )
      endif

      vzdelaniW->( dbskip())
    enddo
  else

    drgMsgBox(drgNLS:msg('Nelze modifikovat VZDÌLÁNÍ pracovníka, blokováno uživatelem ...'))
  endif

  vzdelani ->(dbunlock(),dbcommit())
return mainOk

