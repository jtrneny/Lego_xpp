#include "Common.ch"
#include "drg.ch"
#include "dbstruct.ch"

#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"



*   Pøednastavení recyklaèních poplatkù na skladovou položku cenZboz
*
**  CLASS for SKL_cenZb_rp_IN **************************************************
CLASS SKL_cenZb_rp_IN FROM drgUsrClass
exported:
  method  init
  method  drgDialogInit, drgDialogStart, drgDialogEnd, eventHandled
  method  postValidate
  method  ebro_saveEditRow

  method  cenZb_rp_sel
  *
  * BRO cenzboz - in cenZB_rp
  inline access assign method is_in_cenZb_rp() var is_in_cenZb_rp
    local  nyCENZBOZ := isNull( cenZboz->sid, 0)
    return( if( cenZb_oW->( dbseek( nyCENZBOZ,,'CENZBRP4')), 607, 0 ) )

  *
  * CRD cenZboz / cenZb_rp
  inline access assign method cZrp_zboziKat() var cZrp_zboziKat
    local  cky := upper(cenZb_rp->ccisSklad) +upper(cenZb_rp->csklPol)
    cenZboz_oW->( dbseek( cky,,'CENIK03'))
    return cenZboz_oW->nzboziKat

  inline access assign method cZrp_zkratJedn() var cZrp_zkratJedn
    local  cky := upper(cenZb_rp->ccisSklad) +upper(cenZb_rp->csklPol)
    cenZboz_oW->( dbseek( cky,,'CENIK03'))
    return cenZboz_oW->czkratJedn

  inline access assign method cZrp_cenaMZbo() var cZrp_cenaMZbo
    local  cky := upper(cenZb_rp->ccisSklad) +upper(cenZb_rp->csklPol)
    cenZboz_oW->( dbseek( cky,,'CENIK03'))
    return cenZboz_oW->ncenaMZbo

  inline access assign method cZrp_cenaPZbo() var cZrp_cenaPZbo
    local  cky := upper(cenZb_rp->ccisSklad) +upper(cenZb_rp->csklPol)
    cenZboz_oW->( dbseek( cky,,'CENIK03'))
    return cenZboz_oW->ncenaPZbo

  inline access assign method cZrp_cenaNZbo() var cZrp_cenaNZbo
    local  cky := upper(cenZb_rp->ccisSklad) +upper(cenZb_rp->csklPol)
    cenZboz_oW->( dbseek( cky,,'CENIK03'))
    return cenZboz_oW->ncenaNZbo
  **
  *
  inline access assign method cZrp_cisSklad() var cZrp_cisSklad
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->ccisSklad, cenZb_rp->ccisSklad )
    endif
    return ''

  inline access assign method cZrp_sklPol() var cZrp_sklPol
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->csklPol, cenZb_rp->csklPol )
    endif
    return ''

  inline access assign method cZrp_nazZbo() var cZrp_nazZbo
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->cnazZbo, cenZb_rp->cnazZbo )
    endif
    return ''

  *
  ** Založit kartu skladové položky
  inline method skl_cenZboz_crdNew()
    local  odialog, nexit
    *
    odialog := drgDialog():new('SKL_cenZboz_CRD', ::drgDialog)
    odialog:create()

    odialog:destroy()
    odialog := nil

    ::o_DBro_cenZboz:oxbp:refreshAll()
  return .t.
    *
  ** doplníme cenZb_rp ze stávajícícj dat uživatele
  **
  inline method set_rp_fromOldFiles()
    local  cMess := 'Promiòte prosím, ' +CRLF +CRLF
    local  cTitl := 'Nastavení akuální kalkulace '
    local  nsel
    *
    local  o_msg    := ::msg:msgStatus, oPS
    local  curSize  := o_msg:currentSize()
    local  pa_msg   := { graMakeRGBColor( {255,255,13} ), graMakeRGBColor( {255,255,166} ) }
    local  oFont    := XbpFont():new():create( "10.Arial Bold CE" )
    local  aAttr    := ARRAY( GRA_AS_COUNT )
    local  nrecCnt, nkeyNo
    *
    local x, cfile_m, ctag_m, caof_m
    local cycisSklad, cysklPol, nyCENZBOZ          // RP parent
    local  ccisSklad,  csklPol, cnazZbo, nCENZBOZ  // vazba na sklPol
    *
    local pa := {{ 'fakvysit', 'FVYSIT4' , "nrok    => 2019", 'faktur vystavených'     }, ;
                 { 'objitem' , 'OBJITEM2', "nextObj = 1"    , 'objednávek vystavených' }, ;
                 { 'nabvysit', 'NABVYSI1', ""               , 'nabídek vystavených'    }  }

    cMess += 'požadujete provést kontrolu/nastavení recyklaèních poplatkù ' +CRLF+ ;
             'ke skladovýnm položkám ze stávajících dat '                   +CRLF+ ;
             'faktur, objednávek a nabídek'

    nsel := ConfirmBox( ,cMess +chr(13) +chr(10), ;
                         cTitl                  , ;
                         XBPMB_YESNO            , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2 )

    if nsel = XBPMB_RET_YES

      for x := 1 to len(pa) step 1
        cfile_m := pa[x,1]
        ctag_m  := pa[x,2]
        caof_m  := pa[x,3]

        * info in msgStatus
        o_msg:setCaption( '' )
        oPS := o_msg:lockPS()
        GraGradient( ops               , ;
                    { 2, 2 }           , ;
                    { curSize }, pa_msg, GRA_GRADIENT_HORIZONTAL)

        GraSetFont( oPS, oFont )
        aAttr[GRA_AS_COLOR] := GRA_CLR_WHITE
        GraSetAttrString( oPS, aAttr )

        GraStringAt( oPS, {   4, 4}, '   Aktualizuji data z ' +pa[x,4] )

        aAttr[GRA_AS_COLOR] := GRA_CLR_BLACK
        GraSetAttrString( oPS, aAttr )
        GraStringAt( oPS, {   5, 4}, '   Aktualizuji data z ' +pa[x,4] )
        o_msg:unlockPS()
        * info in msgStatus

        drgDBMS:open( cfile_m )
        (cfile_m)->(ordSetFocus(ctag_m), dbgoTop())
        if( .not. empty(caof_m), (cfile_m)->(ads_setAof(caof_m), dbgoTop()), nil )

        nrecCnt := (cfile_m)->(lastRec())
        nkeyNo  := 1

        do while .not. (cfile_m)->(eof())

          ccisSklad := upper((cfile_m)->ccisSklad)
          csklPol   := upper((cfile_m)->csklPol)
          nkeyNo++

          oPS := o_msg:lockPS()
          val := int(nkeyNo / nrecCnt *100)
          prc := if( val >= 100, '100', str(val,3,0)) +' %'

          GraSetFont( oPS, oFont )
          GraGradient( ops, { int(curSize[1]/2) -20, 4}, { curSize }, pa_msg, GRA_GRADIENT_HORIZONTAL)
          GraStringAt( ops, { int(curSize[1]/2) -20, 4}, prc    )
          o_msg:unlockPS()

          if cenZboz_pk->( dbseek( ccisSklad +csklPol,,'CENIK03'))
            if cenZboz_pk->ctypSKLpol <> 'Y '
              cnazZbo  := cenZboz_pk->cnazZbo
              nCENZBOZ := cenZboz_pk->sid

              (cfile_m)->(dbskip())
              nkeyNo++

              cycisSklad := upper((cfile_m)->ccisSklad)
              cysklPol   := upper((cfile_m)->csklPol)

              if cenZboz_pk->( dbseek( cycisSklad +cysklPol,,'CENIK03'))
                if cenZboz_pk->ctypSKLpol = 'Y '
                  nyCENZBOZ := cenZboz_pk->sid

                  if .not. cenZb_ow->( dbseek( ccisSklad +csklPol,,'CENZBRP1'))

                    cenZb_rp->( dbappend())

                    cenZb_rp->cycisSklad := cycisSklad
                    cenZb_rp->cysklPol   := cysklPol
                    cenZb_rp->nyCENZBOZ  := nyCENZBOZ

                    cenZb_rp->ccisSklad  := cCisSklad
                    cenZb_rp->csklPol    := csklPol
                    cenZb_rp->cnazZbo    := cnazZbo
                    cenZb_rp->nCENZBOZ   := nCENZBOZ
                  endif
                endif
              endif
            endif
          endif

          (cfile_m)->(dbskip())
        enddo

        cenZb_rp->( dbunlock(), dbcommit() )
        (cfile_m)->( dbcloseArea())
      next

      confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                          ;
                   'Dokonèena kontrola/nastavení recyklaèních poplatkù ...' , ;
                   'Dokonèeno kontrola podkladù ...'                        , ;
                XBPMB_OK                                                    , ;
                XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE                  )
      _clearEventLoop(.t.)

      ::dc:oaBrowse := ::o_DBro_cenZboz
      ::o_DBro_cenZboz:oxbp:goTop():refreshAll()
      ::o_DBro_cenZboz:oxbp:refreshAll()
      ::set_focus_dBro()

    endif
  return self

  *
  ** smallBasket
  inline method smallBasket()
    local  state_y
    local  oIcon := XbpIcon():new():create()
    local  oBmp  := XbpBitmap():new():create(), cBuffer

    if isObject(::pb_smallBasket)

      ::smallBasket_State := .not. ::smallBasket_State
      state_y := if( ::smallBasket_State, DRG_ICON_APPEND2, gDRG_ICON_APPEND2 )
      oicon:load( NIL, state_y)

      ::pb_smallBasket:oxbp:setImage( oicon )
**      ::enable_or_disable_Gets()
      ::set_focus_dBro()
    endif
  return .t.


  inline method post_drgEvent_Refresh()
    local  o_msg    := ::msg:msgStatus, oPS
    local  curSize  := o_msg:currentSize()
    local  pa       := { GraMakeRGBColor({ 78,154,125}), GraMakeRGBColor({157,206,188})  }
    local  oFont    := XbpFont():new():create( "10.Arial Bold CE" )
    local  aAttr    := ARRAY( GRA_AS_COUNT )
    *
    local  nyCENZBOZ  := isNull( cenZboz->sid, 0)
    local  cnazRECpop := if( empty(cenZboz->crecPopl), 'Není nastaven typ recyklaèního polatku, bylo by vhodné jej nastavit ...', c_recPop->cnazRECpop )
    *

    if ( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp )   // in cenZboz
      ::sta_activeBro:oxbp:setCaption( 337 )

      if ::o_EBro_cenZb_rp:state <> 0
        ::o_EBro_cenZb_rp:killEditRow()
        PostAppEvent(xbeP_Keyboard,xbeK_ESC,,::sklPol:odrg:oxbp)
      endif

      ::o_EBro_cenZb_rp:oxbp:invalidateRect(,,XBP_INVREGION_LOCK)
        cenZb_rp->( ads_setAof( format( "nyCENZBOZ = %%", { nyCENZBOZ } )), dbgoTop() )
        ::o_EBro_cenZb_rp:oxbp:refreshAll()
      ::o_EBro_cenZb_rp:oxbp:invalidateRect()


      if cenZb_oW->( dbseek( upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol),,'CENZBNS1'))
        cenZb_ns->( dbgoTo( cenZb_oW->( recNo()) ))

        ::o_EBro_cenZb_rp:oxbp:invalidateRect(,,XBP_INVREGION_LOCK)
          ::o_EBro_cenZb_rp:oxbp:refreshAll()
        ::o_EBro_cenZb_rp:oxbp:invalidateRect()

        ::takeValue(::it_file, 'cenZb_ns', 3)
        ::state := 1
      else
        ::state := 2
      endif

    else
      ::sta_activeBro:oxbp:setCaption( 338 )             // in cenZb_rp
      ::state := 1
    endif

    ::restColor()
    ::enable_or_disable_Gets()
    *
    o_msg:setCaption( '' )
    oPS := o_msg:lockPS()

      GraGradient( ops               , ;
                 { 2, 2 }            , ;
                 { curSize }, pa, GRA_GRADIENT_HORIZONTAL)

      GraSetFont( oPS, oFont )
      aAttr[GRA_AS_COLOR] := GRA_CLR_WHITE
      GraSetAttrString( oPS, aAttr )

      GraStringAt( oPS, {   4, 4}, cnazRECpop )

      aAttr[GRA_AS_COLOR] := GRA_CLR_BLACK
      GraSetAttrString( oPS, aAttr )
      GraStringAt( oPS, {   5, 4}, cnazRECpop )
    o_msg:unlockPS()
  return self


hidden:
  var     msg, dm, df, dc
  var     pb_smallBasket, smallBasket_State, msg_editState

  *       cenZboz         cenZb_rp
  var     hd_file       , it_file        , it_file_currAof
  var     o_DBro_cenZboz, o_EBro_cenZb_rp
  var                     cisSklad, sklPol

  var     pb_context    , a_popUp        , popState
  var     state         , sta_activeBro
  var     pa_Gets
  *
  **
  inline method enable_or_disable_Gets()
    local  pa     := ::pa_Gets, x, odrg
    local  isEdit := .t.

    isEdit := if(::dc:oaBrowse = ::o_DBro_cenZboz, .t., .f. )

    for x := 1 to len( pa) step 1
      odrg            := ::dm:has(pa[x]):odrg
      odrg:IsEdit     := isEdit
      if( isEdit, odrg:oxbp:enable(), odrg:oxbp:disable() )
      if( isEdit, odrg:oxbp:setcolorbg(odrg:clrfocus), nil )
    next
    return self

  inline method set_focus_dBro()
    local  o_dBro  := ::dc:oaBrowse // ::o_DBro_cenZboz
    local  members := ::df:aMembers, pos

    pos := ascan(members,{|X| (x = o_dBro )})
    ::df:olastdrg   := o_dBro
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()

    ::enable_or_disable_Gets()

    ::sta_activeBro:oxbp:setCaption( 337 )

    setAppFocus( o_dBro:oxbp )
    postAppEvent( xbeBRW_ItemMarked,,, o_dBro:oxbp)
    return self

  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

ENDCLASS


method SKL_cenZb_rp_IN:eventHandled(nEvent, mp1, mp2, oXbp)
  local  oDialog, nExit, m_file := lower(::dc:oaBrowse:cfile)
  *
  local  typPohybu, recCnt

  do case
  case nEvent = drgEVENT_EDIT
    if( m_file = 'cenzboz', ::df:setNextFocus('cenZboz->crecPopl',,.t.), nil )
    return .t.

  case nEvent = drgEVENT_DELETE
    if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')

       if( m_file = 'cenzb_rp' )
         if .not. (m_file) ->(eof()) .and. (m_file)->(sx_RLock())
           if drgIsYESNO('Požadujete zrušit pøednastavenou položku ?')
             (m_file)->(dbdelete(), dbunlock())
             ::o_EBro_cenZb_rp:oxbp:up():forceStable()
             ::o_EBro_cenZb_rp:oxbp:refreshAll()

             ::o_DBro_cenZboz:oxbp:refreshCurrent()
           else
             (m_file)->(dbunlock())
           endif
         endif
       endif
     endif
     return .t.

  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    cenzboz->(ads_clearAof())
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  case nEvent = drgEVENT_APPEND
    if m_file = 'cenzb_ns'
      if ::popState = 1
        fin_info_box('Tohle opravdu nejde, pøeètete si prosím nápovìdu ...')
      else
*        typPohybu := padR(::a_poPup[::popState].p_typPohybu, 10)
        recCnt    := 0
        cenZb_oW->( dbeval( { || recCnt++ }, { || cenZb_oW->ctypPohybu = typPohybu .and. empty(cenZb_oW->csklPol) } ))

        if recCnt = 0
**** nic          ::refreshAndSetEmpty()
        else
          fin_info_box('Zadat úèet a Ns bez vazby na sklPoložku, lze jen jednou ...')
        endif
      endif
    endif

  case nEvent = drgEVENT_FORMDRAWN
     Return .T.

  case nEvent = xbeP_Keyboard
    do case
    case mp1 = xbeK_ESC
      if oXbp:className() = 'xbpGet'
**        ::fromContext(::popState)
        ::set_focus_dBro()
      else
        PostAppEvent(xbeP_Close,,, oXbp)
      endif

    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.

* cenZboz     - recyklaèní poplatky /ctypSKLpol = Y/ pokud bude potøeba tak vlákno
* cenZboz_oW  - pro dotažení VARu pro cenZboz a cenZb_rp
* cenZboz_pk  - pro kontrolu a nabídku pøevzetí / použijem DBD pro pøevodKam
**
method SKL_cenZb_rp_IN:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'cenZboz'  )
  drgDBMS:open( 'cenZboz' ,,,,, 'cenZboz_oW' )  // pro cenZb_rp a cenZbpz virtuální položky
  drgDBMS:open( 'cenZb_rp',,,,, 'cenZb_oW'   )
  drgDBMS:open( 'cenZboz' ,,,,, 'cenZboz_pK' )

  drgDBMS:open( 'c_recPop' )

  ( ::hd_file := 'cenZboz', ::it_file := 'cenZb_rp' )
  ::pa_gets   := { 'cenZboz->crecPopl' }
return self


method SKL_cenZb_rp_IN:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize

return

//  ::xbp_therm      := drgDialog:oMessageBar:msgStatus

method SKL_cenZb_rp_IN:drgDialogStart(drgDialog)
  local  groups, pa_groups, nin
  local  obro_2, xbp_obro_2
  *
  local  aMembers := drgDialog:oForm:aMembers
  local  acolors  := MIS_COLORS
  *
  **
  ::msg            := drgDialog:oMessageBar             // messageBar
  ::msg:can_writeMessage := .f.
  ::msg:msgStatus:paint  := { |aRect| ::post_drgEvent_Refresh(aRect) }

  ::msg_editState        := ::msg:editState             // gDRG_ICON_ERRLOG, DRG_ICON_APPEND DRG_ICON_EDIT
  ::msg_editState:setCaption(gDRG_ICON_ERRLOG)

  ::dm              := drgDialog:dataManager             // dataMananager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  *
  ::o_DBro_cenZboz  := drgDialog:odBrowse[1]
  ::o_EBro_cenZb_rp := drgDialog:odBrowse[2]

  ::cisSklad        := ::dm:get('cenZb_rp->ccisSklad', .f.)
  ::sklPol          := ::dm:get('cenZb_rp->csklpol'  , .f.)

  * Test - visual style
  ::o_EBro_cenZb_rp:oxbp:useVisualStyle  := .t.

      obro_2  := ::o_EBro_cenZb_rp
  xbp_obro_2  := ::o_EBro_cenZb_rp:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }


  for x := 1 TO LEN(aMembers) step 1
    if     aMembers[x]:ClassName() = 'drgPushButton'
      if( aMembers[x]:event = 'createContext', ::pb_context     := aMembers[x], nil )
      if( aMembers[x]:event = 'smallBasket'  , ::pb_smallBasket := aMembers[x], nil )

    elseif aMembers[x]:ClassName() = 'drgStatic'

      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeBro := aMembers[x]
      endif
    endif

    groups := if( isMemberVar(aMembers[x],'groups'), isnull(aMembers[x]:groups,''), '')

    if 'SETFONT' $ groups
      pa_groups := ListAsArray( groups )
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
  next

  cenZboz->( ads_setAof("ctypSKLpol = 'Y '"), dbgoTop())
  isEditGet( { 'M->cZns_cisSklad', 'M->cZns_sklPol', 'M->cZns_nazZbo'}, drgDialog, .F. )

  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self


method SKL_cenZb_rp_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case ( field_Name = 'crecPopl')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if( cenZboz->(sx_rLock()),  cenZboz->crecPopl := drgVar:value, nil )
      cenZboz->( dbUnlock())

      ::set_focus_dBro()
    endif

  case ( field_Name = 'csklpol' )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

      if( ok := ::cenZb_rp_sel() )
        ::o_EBro_cenZb_rp:killEditRow()
        PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::sklPol:odrg:oxbp)
      endif
    endif
  endCase
return ok

/*
    local  fc := "cpolCen = 'C ' and czkratJedn = '%%'
    local  filtr

    filtr     := format( cf, { cenzboz->czkratJedn })
    cenZboz_pk->( ads_setAof(filtr),dbgoTop())

    o_eBro:enabled_insCykl := .f.

*/

method SKL_cenZb_rp_IN:cenZb_rp_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  local  recCnt := 0, showDlg  := .f., ok := .f., copy := .f.
  local  arSelect := {}, nin

  if( cenZboz_pk->(dbScope()), cenZboz_pk->(dbclearscope()), nil )

  ok := ( cenzboz_pk->(dbseek( upper(::cisSklad:value) +upper(::sklPol:value),,'CENIK03' )) .or. ;
          cenzboz_pk->(dbseek( upper(::sklPol:value),,'CENIK01'))                                )

  if isobject(drgdialog) .or. .not. ok
    showDlg := .t.

  else
    if cenzboz_pk->(dbseek( upper(::cisSklad:value) +upper(::sklPol:value),,'CENIK03' ))
      ok := .t.
    else
      fordRec({ 'cenZboz_pk' })
      cenZboz_pk->(AdsSetOrder('CENIK01')                      , ;
                   dbsetscope(SCOPE_BOTH,upper(::sklPol:value)), ;
                   dbgotop()                                   , ;
                   dbeval( {|| recCnt++ })                     , ;
                   dbgotop()                                     )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)
      if(recCnt = 0, cenZboz_pk->(dbclearscope(),dbgotop()), nil)
      if(recCnt = 0, fordRec(), nil  )
    endif
  endif

  if showDlg
**  if isobject(drgdialog) .or. .not. ok
     odialog := drgDialog():new('SKL_cenZb_rp_SEL',::dm:drgDialog)
     odialog:create(,,.T.)
     nexit := odialog:exitState

     arSelect := odialog:dialogCtrl:oaBrowse:arSelect
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))

    do case
    case( len(arSelect) = 0 )   // pøevzít jednu položku
     ::sklPol:set(cenzboz_pk->csklPol)

     ::dm:set('cenZb_rp->ccissklad', cenZboz_pk->ccisSklad  )
     ::dm:set('cenZb_rp->cnazZbo'  , cenZboz_pk->cnazZbo    )
     ::dm:set('M->cZrp_zboziKat'   , cenZboz_pk->nzboziKat  )
     ::dm:set('M->cZrp_zkratJedn'  , cenZboz_pk->czkratJedn )
     ::dm:set('M->cZrp_cenaMZbo'   , cenZboz_pk->ncenaMZbo  )
     ::dm:set('M->cZrp_cenaPZbo'   , cenZboz_pk->ncenaPZbo  )
     ::dm:set('M->cZrp_cenaNZbo'   , cenZboz_pk->ncenaNZbo  )

     ::sklPol:prevValue := ::sklPol:initValue := ::sklPol:value := cenzboz_pk->csklPol

    case( len(arSelect) > 1 )   // v cyklu N - položek
      ::o_EBro_cenZb_rp:killEditRow()
      PostAppEvent(xbeP_Keyboard,xbeK_ESC,,::sklPol:odrg:oxbp)

      for nin := 1 to len(arSelect) step 1
        cenZboz_pk->(dbgoTo(arSelect[nin]))

        (::it_file)->( dbappend())
        ::ebro_saveEditRow(::o_EBro_cenZb_rp)

        ::o_EBro_cenZb_rp:oxbp:down():refreshAll()
      next
    endcase
  endif

  ::o_DBro_cenZboz:oxbp:refreshCurrent()
return (nexit != drgEVENT_QUIT) .or. ok


method SKL_cenZb_rp_IN:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky, lnew_proCENit := .f.

  (::it_file)->cycisSklad := cenzboz->cCisSklad
  (::it_file)->cysklPol   := cenzboz->csklPol
  (::it_file)->nyCENZBOZ  := cenzboz->sid

  (::it_file)->ccisSklad  := cenzboz_pk->cCisSklad
  (::it_file)->csklPol    := cenzboz_pk->csklPol
  (::it_file)->cnazZbo    := cenzboz_pk->cnazZbo
  (::it_file)->nCENZBOZ   := cenzboz_pk->sid
return


method SKL_cenZb_rp_IN:drgDialogEnd(drgDialog)

*  (::it_file)->(ads_clearAof())
*  fin_ap_modihd(::hd_file,.t.)
return self


*
**
CLASS SKL_cenZb_rp_SEL FROM drgUsrClass
exported:

  * CENZBOZ ceníková položka
  inline access assign method cenPol() var cenPol
    return if(cenZboz_pk->cpolcen = 'C', MIS_ICON_OK, 0)


  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open( 'cenZboz',,,,, 'cenZboz_pk' )
  return self

  inline method drgDialogStart(drgDialog)
  return

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL oDialog, nExit

    DO CASE
    CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::drgDialog:odBrowse[1]:oXbp:refreshAll()

    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,, oXbp)
      OTHERWISE
        RETURN .F.
    ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  inline method itemSelected()
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
    return self

  inline method getForm()
    local  odrg, drgFC

    drgFC := drgFormContainer():new()
    DRGFORM INTO drgFC SIZE 119,17.6 DTYPE '10' TITLE 'Seznam skladových položek _ výbìr ...' ;
                                                GUILOOK 'All:N,Border:Y'

    * Pøevzít z Ceníku zboží         ->cenzboz
    DRGDBROWSE INTO drgFC FPOS 0,1.5 SIZE 119,16 FILE 'cenZboz_pk' ;
       FIELDS  'M->cenPol:c:2.6::2,'                             + ;
               'cCISSKLAD:èisSklad,'                             + ;
               'cSKLPOL:sklPoložka,'                             + ;
               'cNAZZBO:název zboží:25,'                         + ;
               'nZBOZIKAT:katZbo,'                               + ;
               'nMNOZDZBO:množKDisp:10,'                         + ;
               'cZkratJedn:mjSkl,'                               + ;
               'nCenaMZBO:prodCena,'                             + ;
               'nCenaPZBO:cenaProdBdph,'                         + ;
               'nCenaNZBO:nákCena'                                 ;
        SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' RESIZE 'yy'


    DRGSTATIC INTO drgFC FPOS .2, .25 SIZE 118.3,1.4 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
        odrg:ctype := 2

        DRGTEXT INTO drgFC CAPTION 'Vyberte ceníkové položky pro nastaveni recylaèního poplatku ... ' CPOS 1,.1 CLEN 70 PP 2 FONT 5

        DRGPUSHBUTTON INTO drgFC CAPTION '   ~Ok'    ;
                                 POS 91,.2           ;
                                 SIZE 13,1.1         ;
                                 ATYPE 3             ;
                                 ICON1 429           ;
                                 ICON2 430           ;
                                 EVENT 'itemSelected' TIPTEXT 'Pøevzít úèet do položky dokladu ...'

        DRGPUSHBUTTON INTO drgFC CAPTION '   ~Storno' ;
                                 POS 105,.2           ;
                                 SIZE 13,1.1          ;
                                 ATYPE 3              ;
                                 ICON1 102            ;
                                 ICON2 202            ;
                                 EVENT 140000002 TIPTEXT 'Ukonèi dialog ...'
    DRGEND  INTO drgFC

  return drgFC

* EXPORTED:
*  METHOD  Init, EventHandled, drgDialogStart
ENDCLASS


** help
procedure rp_showHelp()
  local  cmsg := ;
   'Dobrý den,'                                                                           +';' + ;
   'je zøejmé, že do této èinnosti nastavení vstupujete po prvé,'                         +';' + ;
   'proto jsem pøistoupil k následujícímu popisu.'                                        +';' + ;
   ''                                                                                     +';' + ;
   '1. je nutné v èíselníku zboží natavit typ položky na Recyklaèní poplatky'             +';' + ;
   '   - na záložce Ostatní údaje je vhodné nastavit typ Recyklaèního polatku'            +';' + ;
   ''                                                                                     +';' + ;
   '2. v horním pohledu je vidìt ceník zboží recPoplatky, v dolním Vaše pøednastavení'    +';' + ;
   ''                                                                                     +';' + ;
   '   - ENTER na horním pohledu, otevøe údaj recPoplatek pro editaci'                    +';' + ;
   ''                                                                                     +';' + ;
   '   - INS/ENTER na dolním pohledu, umožní opravu nebo zadání vazby na sklPoložku'      +';' + ;
   '     v režimu INS je možné oznaèit sklPoložky a pøevzít v cyklu'                      +';' + ;
   ''                                                                                     +';' + ;
   'Dìkuji Vám za pozornost a'                                                            +';' + ;
   'doufám, že toto pøednastavení vám zpøíjemní práci.'                                   +';;'


  alertBox( , cmsg, { "       ~Ok       " }, XBPSTATIC_SYSICON_ICONQUESTION, 'Nastavení úètu a nákladové struktury ... '    )
  _clearEventLoop(.t.)
return