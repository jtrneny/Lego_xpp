#include "Common.ch"
#include "drg.ch"
#include "dbstruct.ch"

#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"


#xtranslate  .p_uloha     =>  \[ 1\]
#xtranslate  .p_podUloha  =>  \[ 2\]
#xtranslate  .p_typDoklad =>  \[ 3\]
#xtranslate  .p_typPohybu =>  \[ 4\]
#xtranslate  .p_nazTypPoh =>  \[ 5\]


*   Pøednastavení úètu a nákladové struktury pro cenZboz
*
**  CLASS for SKL_cenZb_ns_IN **************************************************
CLASS SKL_cenZb_ns_IN FROM drgUsrClass
exported:
  method  init
  method  drgDialogInit, drgDialogStart, drgDialogEnd, eventHandled
  method  createContext, fromContext
  method  postValidate , c_naklst_vld, postLastField
  *
  * BRO cenzboz - ceníková/neceníková položka
  inline access assign method is_in_cenZb_ns() var is_in_cenZb_ns
    local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)
    return( if( cenZb_oW->( dbseek( cky,,'CENZBNS1')), 607, 0 ) )

  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method vychoziMj() var vychoziMj
    local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

    c_prepmj->( dbseek( cky,, 'C_PREPMJ02'))
    return c_prepmj->cvychoziMJ

  *
  * CRD cenZboz / cenZb_ns
  inline access assign method cZns_cisSklad() var cZns_cisSklad
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->ccisSklad, cenZb_ns->ccisSklad )
    endif
    return ''

  inline access assign method cZns_sklPol() var cZns_sklPol
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->csklPol, cenZb_ns->csklPol )
    endif
    return ''

  inline access assign method cZns_nazZbo() var cZns_nazZbo
    if isObject(::dc)
      return if( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp, cenZboz->cnazZbo, ::ns_nazZbo() )
    endif
    return ''

  *
  * BRO cenZb_ns - cnazZbo
  inline access assign method ns_nazZbo() var ns_nazZbo
    local  cky := upper(cenZb_ns->ccisSklad) +upper(cenZb_ns->csklPol)

    cenZboz_ns->( dbseek( cky,,'CENIK03'))
    return cenZboz_ns->cnazZbo

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
    if ( ::o_DBro_cenZboz:oxbp  = ::dc:oaBrowse:oxbp )   // in cenZboz
      ::sta_activeBro:oxbp:setCaption( 337 )

      if cenZb_oW->( dbseek( upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol),,'CENZBNS1'))
        cenZb_ns->( dbgoTo( cenZb_oW->( recNo()) ))

        ::o_DBro_cenZb_ns:oxbp:invalidateRect(,,XBP_INVREGION_LOCK)
          ::o_DBro_cenZb_ns:oxbp:refreshAll()
        ::o_DBro_cenZb_ns:oxbp:invalidateRect()

        ::takeValue(::it_file, 'cenZb_ns', 3)
        ::state := 1
      else
        ::takeValue(::it_file, 'cenzboz' , 2)
        ::state := 2
      endif

    else
      ::sta_activeBro:oxbp:setCaption( 338 )             // in cenZb_ns
      ::state := 1

      ::takeValue(::it_file, 'cenZb_ns', 3)
    endif

    ::enable_or_disable_Gets()
    *
    o_msg:setCaption( '' )
    oPS := o_msg:lockPS()

      GraGradient( ops               , ;
                 { 2, 2 }            , ;
                 { curSize }, pa, GRA_GRADIENT_HORIZONTAL)

      GraSetFont( oPS, oFont )
      aAttr[GRA_AS_COLOR] := GRA_CLR_RED
      GraSetAttrString( oPS, aAttr )

      c_typPoh->( dbseek( upper(cenZb_ns->ctypPohybu),,'C_TYPPOH03'))
      GraStringAt( oPS, {   4, 4}, c_typpoh->cnaztyppoh )

      aAttr[GRA_AS_COLOR] := GRA_CLR_WHITE
      GraSetAttrString( oPS, aAttr )
      GraStringAt( oPS, {   5, 4}, c_typpoh->cnaztyppoh )
    o_msg:unlockPS()
    *
**    _clearEventLoop(.t.)
  return self


hidden:
  method  takeValue, cenZn_ns_ucns

  var     msg, dm, df, dc
  var     pb_smallBasket, smallBasket_State, msg_editState

  *       cenZboz         cenZb_ns
  var     hd_file       , it_file        , it_file_currAof
  var     o_DBro_cenZboz, o_DBro_cenZb_ns
  var     pb_context    , a_popUp        , popState
  var     state         , sta_activeBro
  var     pa_Gets
  *
  **
  inline method refreshAndSetEmpty()
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x
    local  drgVar

    for x := 1 to size step 1
      drgVar := values[x,2]
      drgVar:prevValue := drgVar:initValue := drgVar:value := ''
      drgVar:odrg:refresh('')
    next
    ::state := 2
    ::takeValue(::it_file, 'cenzboz' , 2)

    ::df:setNextFocus('cenZb_ns->cucet',,.t.)
    return self


  inline method enable_or_disable_Gets()
    local  pa     := ::pa_Gets, x, odrg
    local  isEdit := .t.

    if ::popState = 1        // Kompletní seznam nastavení
      do case
      case ( ::dc:oaBrowse = ::o_DBro_cenZboz )
        isEdit := .f.
      case ( ::dc:oaBrowse = ::o_DBro_cenZb_ns)
        isEdit := ( cenZb_ns->sid <> 0 )
      endcase
    endif

    for x := 1 to len( pa) step 1
      odrg            := ::dm:has(pa[x]):odrg
      odrg:oVar:block := nil
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


  inline method copyfldto_w(from_db,to_db,app_db)
    local npos, xval, afrom := (from_db)->(dbstruct()), x

    if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
    for x := 1 to len(afrom) step 1
      if .not. (lower(afrom[x,DBS_NAME]) $ '_nrecor,_delrec,nfaktm_org')
        xval := (from_db)->(fieldget(x))
        npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

        if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
      endif
    next
    return nil


  inline method itSave(panGroup)
    local  x, ok := .t., vars := ::dm:vars, drgVar

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      if ISCHARACTER(panGroup)
        ok := (empty(drgVar:odrg:groups) .or. drgVar:odrg:groups = panGroup)
      endif

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok
        if (eval(drgvar:block) <> drgVar:value) // .and. .not. drgVar:rOnly
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
    return self

ENDCLASS


method SKL_cenZb_ns_IN:eventHandled(nEvent, mp1, mp2, oXbp)
  local  oDialog, nExit, m_file := lower(::dc:oaBrowse:cfile)
  *
  local  typPohybu, recCnt

  do case
  case nEvent = drgEVENT_EDIT
    if ::popState = 1 .and. m_file = 'cenzboz'
       fin_info_box('Tohle opravdu nejde, pøeètete si prosím nápovìdu ...')
    else
      ::df:setNextFocus('cenZb_ns->cucet',,.t.)
    endif
    return .t.

  case nEvent = drgEVENT_SAVE // .or. nevent = drgEVENT_EXIT
    if ::c_naklst_vld()
      ::postLastField()
    else
      return .f.
    endif

  case nEvent = drgEVENT_DELETE
    if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')

       if( m_file = 'cenzb_ns' )
         if .not. (m_file) ->(eof()) .and. (m_file)->(sx_RLock())
           if drgIsYESNO('Požadujete zrušit pøednastavenou položku ?')
             (m_file)->(dbdelete(), dbunlock())
             ::o_DBro_cenZb_ns:oxbp:refreshAll()
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
        typPohybu := padR(::a_poPup[::popState].p_typPohybu, 10)
        recCnt    := 0
        cenZb_oW->( dbeval( { || recCnt++ }, { || cenZb_oW->ctypPohybu = typPohybu .and. empty(cenZb_oW->csklPol) } ))

        if recCnt = 0
          ::refreshAndSetEmpty()
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


method SKL_cenZb_ns_IN:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'cenZboz'  )
  drgDBMS:open( 'cenZboz',,,,, 'cenZboz_ns' )  // pro cenZb_ns.cnazZbo

  drgDBMS:open( 'cenZb_ns' )
  drgDBMS:open( 'c_naklst')
  drgDBMS:open( 'c_uctosn')

  drgDBMS:open( 'cenZb_ns',,,,, 'cenZb_oW'  )
  drgDBMS:open( 'cenZb_ns',,,,, 'cenZb_nsW' )

  ( ::hd_file := 'cenZboz', ::it_file := 'cenZb_ns' )
  ::pa_gets   := { 'cenZb_ns->cucet', 'cenZb_ns->cnazPol1', 'cenZb_ns->cnazPol2', 'cenZb_ns->cnazPol3', ;
                                      'cenZb_ns->cnazPol4', 'cenZb_ns->cnazPol5', 'cenZb_ns->cnazPol6'  }

  ::popState        := 1
  ::it_file_currAof := ''

  * výbìr z c_typPoh
  drgDBMS:open( 'c_typPoh' )
  c_typPoh->( dbgoTop())
  ::a_poPup := { { ' ', space(15), space(10), '0', 'Kompletní seznam nastavení' } }

  do while .not. c_typPoh ->( eof())
    if c_typPoh->npredCenZb = 1
       aadd( ::a_poPup, { c_typPoh->culoha              , ;
                          c_typPoh->cpodUloha           , ;
                          c_typPoh->ctypDoklad          , ;
                          c_typPoh->ctypPohybu          , ;
                          allTrim(c_typpoh ->cnazTypPoh) +' (' +allTrim(c_typPoh->ctypPohybu) +')'  } )

    endif
    c_typPoh->( dbskip())
  enddo
return self


method SKL_cenZb_ns_IN:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize

return


method SKL_cenZb_ns_IN:drgDialogStart(drgDialog)
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

  ::dm             := drgDialog:dataManager             // dataMananager
  ::dc             := drgDialog:dialogCtrl              // dataCtrl
  ::df             := drgDialog:oForm                   // form
  *
  ::o_DBro_cenZboz  := drgDialog:odBrowse[1]
  ::o_DBro_cenZb_ns := drgDialog:odBrowse[2]

  * Test - visual style
  ::o_DBro_cenZb_ns:oxbp:useVisualStyle := .t.

      obro_2  := ::o_DBro_cenZb_ns
  xbp_obro_2  := ::o_DBro_cenZb_ns:oXbp
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

  isEditGet( { 'M->cZns_cisSklad', 'M->cZns_sklPol', 'M->cZns_nazZbo'}, drgDialog, .F. )

  ::pb_context:oXbp:setFont(drgPP:getFont(5))
  ::pb_context:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

*  ::dc:sp_resetActiveArea( ::o_DBro_cenZb_ns, .f., .f. )
*  ::dc:sp_resetActiveArea( ::o_DBro_cenZboz , .f., .t. )

  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self


method SKL_cenZb_ns_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case ( field_Name = 'cucet'   )
  case ( field_Name = 'cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if( ::c_naklst_vld(), ::postLastField(), nil )
    endif
  endCase
return ok


method SKL_cenZb_ns_IN:c_naklst_vld()
  local  ucet           := ::dm:get('cenZb_ns->cucet'    )
  local  drgVar_nazPol1 := ::dm:has( ::it_file +'->cnazPol1' )
  *
  local  oDialog, nExit := drgEVENT_QUIT
  local  x, cvalue := ''
  local  ok := .f., showDlg := .f.
  local  lnaklStr := .f.                         // nákladová struktura není povinná

  if .not. empty(ucet)
    c_uctosn->(dbSeek( upper(ucet),,'UCTOSN1'))
    lnaklStr := c_uctosn->lnaklStr
  endif

  for x := 1 to 6 step 1
    cvalue += padR( upper(::dm:get( ::it_file +'->cnazPol' +str(x,1))), 8)
  next

  do case
  case( empty(ucet) .and. empty(cvalue) )
    fin_info_box('Položku nelze uložit, nemá žádnou vypovídací hodnotu ...')
    ::df:setNextFocus(::it_file +'->cucet',,.t.)

  case( empty(cvalue) .and. .not. lnaklStr)
    ok      := .t.

  case( empty(cvalue) .and.       lnaklStr)
    fin_info_box('Nákladová struktura je pro úèet > ' +ucet +' <' +CRLF+CRLF +'                 !!!  POVINNÁ  !!!')
    ::df:setNextFocus(::it_file +'->cnazPol1',,.t.)

  otherwise
    ok      := c_naklSt->(dbseek(cvalue,,'C_NAKLST1'))
    showDlg := .not. ok
  endcase

  if showDlg
    DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                        DESTROY         ;
                                                        EXITSTATE nExit ;
                                                        CARGO drgVar_nazPol1

    if nexit != drgEVENT_QUIT .or. ok
      for x := 1 to 6 step 1
        ::dm:set(::it_file + '->cnazPol' +str(x,1), DBGetVal('c_naklSt->cnazPol' +str(x,1)))
      next
      postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar_nazPol1:odrg:oxbp)
      ok := .t.
    else
      ::df:setNextFocus(::it_file +'->cnazPol1',,.t.)
    endif
  endif
return ok


method SKL_cenZb_ns_IN:postLastField()
  local  isChanged     := ::dm:changed()
  local  pa_poPup      := ::a_poPup[::popState]
  local  cisSklad      := padR( ::dm:get('M->cZns_cisSklad'),  8)
  local  sklPol        := padR( ::dm:get('M->cZns_sklPol'  ), 15)
  local  is_incenZb_ns := cenZb_oW->( dbseek( upper(cisSklad) +upper(sklPol),,'CENZBNS1'))  // CENZBNS3
  *                                                                                         // UPPER(CTYPPOHYBU) +UPPER(CCISSKLAD) +UPPER(CSKLPOL) +UPPER(CUCET) +UPPER(CNAZPOL1) +UPPER(CNAZPOL2) +UPPER(CNAZPOL3) +UPPER(CNAZPOL4) +UPPER(CNAZPOL5) +UPPER(CNAZPOL6)
  ** ukládáme na posledním PRVKU *

//  local  lnewRec   := ( cenZb_ns->(eof()) .or. ::state = 2 )

  if((::it_file)->(eof()), ::state := 2, nil)

  if isChanged .and. if(::state = 2 .and. .not. is_incenZb_ns, addRec(::it_file), replRec(::it_file) )

    if ::state = 2

      ( (::it_file)->culoha     := pa_poPup.p_uloha       , ;
        (::it_file)->cpodUloha  := pa_poPup.p_podUloha    , ;
        (::it_file)->ctypDoklad := pa_poPup.p_typDoklad   , ;
        (::it_file)->ctypPohybu := pa_poPup.p_typPohybu     )

      * novinka, lze zadat ucet a ns jen pro ctypPohybu
      if is_incenZb_ns
        ( (::it_file)->nzboziKat  := (::hd_file)->nzboziKat , ;
          (::it_file)->ccisSklad  := (::hd_file)->ccisSklad , ;
          (::it_file)->csklPol    := (::hd_file)->csklPol     )
      endif
    endif

    ( (::it_file)->cucet      := ::dm:get('cenZb_ns->cucet'   ) , ;
      (::it_file)->cnazPol1   := ::dm:get('cenZb_ns->cnazPol1') , ;
      (::it_file)->cnazPol2   := ::dm:get('cenZb_ns->cnazPol2') , ;
      (::it_file)->cnazPol3   := ::dm:get('cenZb_ns->cnazPol3') , ;
      (::it_file)->cnazPol4   := ::dm:get('cenZb_ns->cnazPol4') , ;
      (::it_file)->cnazPol5   := ::dm:get('cenZb_ns->cnazPol5') , ;
      (::it_file)->cnazPol6   := ::dm:get('cenZb_ns->cnazPol6')   )

    if( ::state = 1, (::it_file)->( dbunlock()), nil )

    if ::state = 2
      ::o_dBro_cenZb_ns:oxbp:gobottom():refreshAll()
    else
      ::o_dBro_cenZb_ns:oxbp:refreshCurrent()
    endif
  endif

  ::dm:refresh()
  ::set_focus_dBro()

  if ::state = 2  .and. ::smallBasket_State
    ::o_dBro_cenZboz:oxbp:down():refreshCurrent()

    if .not. cenZboz->( eof())
      postAppEvent( drgEVENT_EDIT,,,::o_dBro_cenZboz:oxbp )
    endif
  endif
return .t.


method SKL_cenZb_ns_IN:createContext()
  local  pa     := ::a_popUp, x
  local  aPos   := ::pb_context:oXbp:currentPos()
  local  aSize  := ::pb_context:oXbp:currentSize()
  local  opoPup := XbpImageMenu():new( ::drgDialog:dialog )
  local  typPohybu, in_cenZbNs

  opoPup:barText := 'Pohyby'
  opoPup:create()

  for x := 1 to len(pa) step 1
    in_cenZbNs := .f.

    if (typPohybu := pa[x].p_typPohybu) <> '0'
      in_cenZbNs := cenZb_nsW->( dbseek( typPohybu,,'CENZBNS3'))
    endif

    opoPup:addItem( { pa[x].p_nazTypPoh             , ;
                      de_BrowseContext(self,x,pA[x]), ;
                                                    , ;
                      XBPMENUBAR_MIA_OWNERDRAW        }, ;
                      if( in_cenZbNs, 303, 0 )           )
  next

  opoPup:popup( ::pb_context:oxbp:parent, apos )
return self


method SKL_cenZb_ns_IN:fromContext(aOrder, nMENU)
  local  obro := ::drgDialog:odbrowse[1]
  *
  local  filtr, flt := "ctypPohybu = '%%'"
  local  selPohyb   := ::a_popup[aOrder]
  local  typPohybu  := selPohyb.p_typPohybu

  ::popState := aOrder
  ::pb_context:oxbp:setCaption( selPohyb.p_nazTypPoh )
  *
  do case
  case typPohybu = '0'
    cenZb_ns->( ads_clearAof(), dbgoTop())
    cenZb_oW->( ads_clearAof(), dbgoTop())
  otherwise
    filtr := format( flt, { typPohybu } )
    cenZb_ns->( ads_setAof(filtr), dbgoTop())
    cenZb_oW->( ads_setAof(filtr), dbgoTop())
  endcase

  ::it_file_currAof := cenZb_ns->( ads_getAof())

  ::o_DBro_cenZboz:oxbp:invalidateRect(,,XBP_INVREGION_LOCK)
  ::o_DBro_cenZboz:oxbp:refreshAll()
  ::o_DBro_cenZboz:oxbp:invalidateRect()

  ::o_DBro_cenZb_ns:oxbp:refreshAll()
  ::set_focus_dBro()
  ::enable_or_disable_Gets()
return self


method SKL_cenZb_ns_IN:takeValue(it_file,iz_file,iz_pos)
  local  x, pos, value, items, mname, par
  local  iz_recs := (iz_file)->(recno())

*                     cenZb_ns,        cenzboz,     cenZb_ns
*
  local  pa := { { 'ccissklad',        'ccissklad',  'ccissklad' }, ;
                 {   'csklpol',          'csklpol',    'csklpol' }, ;
                 {   'cnazzbo',          'cnazzbo',    'cnazzbo' }, ;
                 {     'cucet', ':cenZn_ns_ucns/0',      'cucet' }, ;
                 {  'cnazpol1', ':cenZn_ns_ucns/1',   'cnazpol1' }, ;
                 {  'cnazpol2', ':cenZn_ns_ucns/2',   'cnazpol2' }, ;
                 {  'cnazpol3', ':cenZn_ns_ucns/3',   'cnazpol3' }, ;
                 {  'cnazpol4', ':cenZn_ns_ucns/4',   'cnazpol4' }, ;
                 {  'cnazpol5', ':cenZn_ns_ucns/5',   'cnazpol5' }, ;
                 {  'cnazpol6', ':cenZn_ns_ucns/6',   'cnazpol6' }  }

  for x := 1 to len(pa) step 1
    if IsObject(ovar := ::dm:has(it_file +'->' +pa[x,1]))

      do case
      case empty(pa[x,iz_pos]) .or. isnumber(pa[x,iz_pos])
        value := pa[x,iz_pos]

      case at(':', pa[x,iz_pos]) <> 0
        items := strtran(pa[x,iz_pos],':','')
        mname := substr(items,1,at('/',items) -1)
        par   := val(substr(items,  at('/',items) +1))
        value := self:&mname(par)

      otherwise
        value := DBGetVal(iz_file +"->" +pa[x,iz_pos])
      endcase

      ovar:set(value)
      ovar:initValue := ovar:prevValue := value

      * nìkdo nastavuje relaèní vazby na DB - pak dojde k repozici na postValidateRelate
      * hlavnì u cenzboz tam je klíè ccisSklad +csklPol
      * nastavení relace jen na csklPol je chybé !!!
      if iz_recs <> 0
        if( iz_recs <> (iz_file)->(recno()), (iz_file)->(dbgoto(iz_recs)), nil )
      endif

    endif
  next
return
*
*  cucet, cnazpol1, cnazpol2, cnazpol3, cnazpol4, cnazpol5, cnazpol6
method SKL_cenZb_ns_IN:cenZn_ns_ucns(par)
  local retVal
  *
  do case
  case(par = 0)  ;  retVal := space(6)  // ucetprit->cucetmd
  case(par = 1)  ;  retVal := space(8)  // ucetprit->cnazpol1
  case(par = 2)  ;  retVal := space(8)  // ucetprit->cnazpol2
  case(par = 3)  ;  retVal := space(8)  // ucetprit->cnazpol3
  case(par = 4)  ;  retVal := space(8)  // ucetprit->cnazpol4
  case(par = 5)  ;  retVal := space(8)  // ucetprit->cnazpol5
  case(par = 6)  ;  retVal := space(8)  // ucetprit->cnazpol6
  endcase
return retVal


method SKL_cenZb_ns_IN:drgDialogEnd(drgDialog)

*  (::it_file)->(ads_clearAof())
*  fin_ap_modihd(::hd_file,.t.)
return self


procedure ns_showHelp()
  local  cmsg := ;
   'Dobrý den,'                                                                           +';' + ;
   'je zøejmé, že do této èinnosti nastavení vstupujete po prvé,'                         +';' + ;
   'proto jsem pøistoupil k následujícímu popisu.'                                        +';' + ;
   ''                                                                                     +';' + ;
   '1. je nutné v èíselníku typ pohybù povolit pøednastavení úètu a náklStrukury'         +';' + ;
   '2. v horním pohledu je vidìt ceník zboží, v dolním Vaše pøednastavení'                +';' + ;
   '   - pokud je v horním tlaèítku zobrazen text Kompletní seznam nastavení,'            +';' + ;
   '     jde pouze o pohled na nastavení a lze ve spodním pohledu, (pokud'                +';' + ;
   '     existují položky) opravovat, pøípadnì rušit existující položky'                  +';' + ;
   ''                                                                                     +';' + ;
   '   - pokud v horním tlaèítku, vyberete typ pohybu, zaène fungovat celý'               +';' + ;
   '     mechanismus nastavení'                                                           +';' + ;
   ''                                                                                     +';' + ;
   '  - ENTER na horním pohledu, otevøe editaci pro nastavení vybrané sklPoložky'         +';' + ;
   '    a umožní zadat úèet a náklStrukturu'                                              +';' + ;
   ''                                                                                     +';' + ;
   '  - ENTER na dolním pohledu, (pokud exitují položky) umožní opravu úètu a NS'         +';' + ;
   ''                                                                                     +';' + ;
   '  - INS   na dolním pohledu umožní nastavit úèet a NS bez vazby na sklad/sklPoložku'  +';' + ;
   '    nevím na co je to vhodné, ale byl to požadavek zákazníka'                         +';' + ;
   ''                                                                                     +';' + ;
   '3. byla doplnìna striktní vazba typPohybu, úèet a náklStruktura na jednoznaènost'     +';' + ;
   '   Vašeho zadání, pokud záznam s tìmito údaji existuje, nelze uložit'                 +';' + ;
   ''                                                                                     +';' + ;
   'Dìkuji Vám za pozornost a'                                                            +';' + ;
   'doufám, že toto pøednastavení vám zpøíjemní práci.'                                   +';;'


  alertBox( , cmsg, { "       ~Ok       " }, XBPSTATIC_SYSICON_ICONQUESTION, 'Nastavení úètu a nákladové struktury ... '    )
  _clearEventLoop(.t.)
return