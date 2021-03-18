#include "Common.ch"
#include "drg.ch"
#include "dbstruct.ch"

#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"


static     pa_inBasket


*   CENÍK ZBOŽÍ pro REGISTRAÈNÍ POKLADNU
**  CLASS for PRO_poklhd_cen_sel ***********************************************
CLASS PRO_poklhd_cen_sel FROM drgUsrClass, FIN_pro_fakdol
exported:
  method  init
  method  drgDialogInit, drgDialogStart, drgDialogEnd, eventHandled
  method  createContext, fromContext
  method  postLastField
  *
  method  poklhd_c_prepmj_sel, edit_pc
  *
  **
  var     msg, dm, df, dc, members_inf
  var     on_sklPol, on_basketSave
  var     cisSklad, sklPol
  var     hd_file, it_file
  *
  * cenzboz - ceníková/neceníková položka
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method vychoziMj() var vychoziMj
    local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

    c_prepmj->( dbseek( cky,, 'C_PREPMJ02'))
    return c_prepmj->cvychoziMJ


  inline method stableBlock(oxbp)
  return self

  inline method post_drgEvent_Refresh()
    if ( ::o_dBro:oxbp = ::dc:oaBrowse:oxbp )   // in cenZboz
      ::sta_activeBro:oxbp:setCaption( 337 )
      ::state := 2
      ::o_parent_udcp:takeValue(::it_file, 'cenzboz', 2, ::dm)

    else
      ::sta_activeBro:oxbp:setCaption( 338 )   // in poklitW
      ::state := 1
      ::o_parent_udcp:takeValue(::it_file, ::it_file, 3, ::dm)
    endif

    _clearEventLoop(.t.)
  return self


  inline method postValidate(drgVar)
    local  name := Lower(drgVar:name)
    local  ok   := .t., lastOk := .f.
    *
    local  nevent := mp1 := mp2 := nil

    nevent  := LastAppEvent(@mp1,@mp2)

    if ::smallBasket_State
      ok := ::FIN_PRO_fakdol:postValidate(drgVar)

      if( nevent = xbeP_Keyboard .and. isNumber(mp1) )
        if( mp1 = xbeK_RETURN .and. ok)

          do case
          case( name = ::it_file +'->nfaktmnkoe' )  ;  lastOk := ( ::on_basketSave = '0')
          case( name = ::it_file +'->czkrjednd'  )  ;  lastOk := ( ::on_basketSave = '1')
          case( name = ::it_file +'->ncejprkdz'  )  ;  lastOk := .t.
          endcase

          if( lastOk, (_clearEventLoop(.t.), ::postLastField()), nil)
        endif
      endif
    endif
  return ok

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
      ::enable_or_disable_Gets()
      ::set_focus_dBro()
    endif
  return .t.


hidden:
  var     drgVar  , drgPush , state    , intCount
  var     fakMnoz , koefMn  , faktMnKoe, zkrJednD
  var     cejPrZDZ, cejPrKDZ, procSlev , hodnSlev

  *       cenZboz         poklitW
  var     o_dBro        , o_dBro_basketW

  var     pb_context    , a_popUp    , popState
  var     o_parent_udcp , o_parent_dm, o_parent_dBro
  var     pb_smallBasket, smallBasket_State, smallBasket_Gets
  var     sta_activeBro

  var     selSklad, s_popup, m_parent
  *
  ** smallBasket
  inline method enable_or_disable_Gets()
    local pa := ::smallBasket_Gets, x, odrg

    for x := 1 to len( pa) step 1
      odrg            := ::dm:has(pa[x]):odrg
      odrg:oVar:block := nil
      odrg:IsEdit := ::smallBasket_State
      if( ::smallBasket_State, odrg:oxbp:enable(), odrg:oxbp:disable() )
    next
  return self

  inline method set_focus_dBro()
    local  o_dBro  := ::o_dBro
    local  members := ::df:aMembers, pos

    pos := ascan(members,{|X| (x = o_dBro )})
    ::df:olastdrg   := ::o_dBro
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()

    setAppFocus( ::o_dBro:oxbp )
  return self

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

  inline method sumColumn()
    local  arDef := ::o_dBro_basketW:arDef
    local  pa    := { { 'nfaktmnoz', 0 }, { 'ncecprkdz', 0 } }
    *
    local  recNo := poklitw->( recNo()), x, npos, ocolumn

    poklitW->( dbeval( { || ( pa[1,2] += poklitW->nfaktmnoz, ;
                              pa[2,2] += poklitW->ncecprkdz  ) } ) )
    poklitW->( dbgoTo( recNo))

    for x := 1 to len(pa) step 1
      if( npos := ascan( arDef, { |ait| pa[x,1] $ lower( ait[2]) })) <> 0

        ocolumn := ::o_dBro_basketW:oxbp:getColumn(npos)
        ocolumn:Footing:Hide()
        ocolumn:Footing:setCell(1, pa[x,2] )
        ocolumn:Footing:show()
      endif
    next
  return .t.

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


method PRO_poklhd_cen_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  local oDialog, nExit, m_file

  do case
  case nEvent = drgEVENT_EDIT .and. ::smallBasket_State
    ::o_parent_udcp:takeValue(::it_file, 'cenzboz', 2, ::dm)
    ::df:setNextFocus('poklitW->nfaktMnKoe',,.t.)
    return .t.

  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    cenzboz->(ads_clearAof())
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  case nEvent = drgEVENT_APPEND
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    oXbp:refreshAll()

  case nEvent = drgEVENT_FORMDRAWN
     Return .T.

  case nEvent = xbeP_Keyboard
    do case
    case mp1 = xbeK_ESC
      if oXbp:className() = 'xbpGet'
        ::set_focus_dBro()
      else
        PostAppEvent(xbeP_Close,,, oXbp)
        ::o_parent_dm:refreshAndSetEmpty( 'poklitW' )
      endif

    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.


method PRO_poklhd_cen_sel:init(parent)

  ::drgUsrClass:init(parent)

  ::o_parent_udcp := parent:parent:udcp
  ::o_parent_dm   := parent:parent:dataManager
  ::o_parent_dBro := parent:parent:odBrowse[1]

  ::drgVar   := parent:parent:lastXbpInFocus:cargo
  ::popState := 1
  ::selSklad := parent:parent:UDCP:selSklad
  ::s_popup  := parent:parent:UDCP:s_popup
  ::a_popup  := listAsArray(::s_popup)
  ::m_parent := parent:parent:UDCP

  drgDBMS:open('CenZBOZ' )

  * pro smallBasket
  ::hd_file               := ::o_parent_udcp:hd_file
  ::it_file               := ::o_parent_udcp:it_file
  ::smallBasket_Gets      := { 'POKLITw->nFaktMnKoe', 'POKLITw->czkrJednD', 'POKLITw->ncejprkdz', 'POKLITw->ncecprkdz' }
  ::intCount              := ::m_parent:ordItem()

  (::it_file)->(ads_setAof('.F.'),dbgoTop() )
return self


method PRO_poklhd_cen_sel:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize

return


method PRO_poklhd_cen_sel:drgDialogStart(drgDialog)
  local  aMembers  := drgDialog:oForm:aMembers
  *
  local  pa := ::a_popup, pos, curSklad := allTrim(::selSklad) +'.'
  local  ocolumn
  *
  **
  ::msg            := drgDialog:oMessageBar             // messageBar
  ::dm             := drgDialog:dataManager             // dataMananager
  ::dc             := drgDialog:dialogCtrl              // dataCtrl
  ::df             := drgDialog:oForm                   // form
  ::members_inf    := {}
  ::on_sklPol      := ''
  ::on_basketSave  := ::o_parent_udcp:on_basketSave

  ::o_dBro         := drgDialog:odBrowse[1]
  ::o_dBro_basketW := drgDialog:odBrowse[2]
  *
  ** vazba na poklhd_c_prepmj_sel
  ::cisSklad       := ::dm:has( ::it_file +'->ccissklad' )
  ::sklPol         := ::dm:has( ::it_file +'->csklpol'   )
  *
  ** vazba na edit_pc
  ::cejPrZDZ       := ::dm:has(::it_file +'->ncejPrZDZ' , .F.)
  ::cejPrKDZ       := ::dm:has(::it_file +'->ncejPrKDZ' , .F.)
  ::procSlev       := ::dm:has(::it_file +'->nprocSlev' , .F.)
  ::hodnSlev       := ::dm:has(::it_file +'->nhodnSlev' , .F.)

  ::fakMnoz        := ::dm:has( ::it_file +'->nfakMnoz'  )
  ::koefMn         := ::dm:has( ::it_file +'->nkoefMn'   )
  ::faktMnKoe      := ::dm:has( ::it_file +'->nfaktMnKoe')
  ::zkrJednD       := ::dm:has( ::it_file +'->czkrJednD' )
  *
  for x := 1 TO LEN(aMembers) step 1
    if     aMembers[x]:ClassName() = 'drgPushButton'
      ::drgPush := aMembers[x]
      if( aMembers[x]:event = 'createContext', ::pb_context     := aMembers[x], nil )
      if( aMembers[x]:event = 'smallBasket'  , ::pb_smallBasket := aMembers[x], nil )

    elseif aMembers[x]:ClassName() = 'drgStatic'

      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeBro := aMembers[x]
      endif
    endif
  next

  * úprava pro indikace pøevzatých položek do košíku na cenZboz
  pa_inBasket := {}
  for x := 1 to ::o_dBro:oxbp:colCount step 1
    ocolumn := ::o_dBro:oxbp:getColumn(x)
    ocolumn:colorBlock := &( '{|a,b,c| pro_poklhd_cen_sel_colorBlock( a, b, c ) }' )
  next

  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

  pos := ascan(pa, {|x| curSklad $ strTran( x, ' ', '') })
  if( pos = 0, pos := 1, nil )

  ::fromContext(pos, pa[pos])
  *
  ** smallBasket
  ::fin_pro_fakdol:init(drgDialog:udcp)
  ::fin_pro_fakdol:hd_file := ::hd_file
  ::fin_pro_fakdol:it_file := ::it_file

  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self

function pro_poklhd_cen_sel_colorBlock( a, b, c )
  local recNo   := cenZboz->( recNo())
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({0,191,191}), }

  AClr := if( ascan( pa_inBasket, recNo) <> 0, aCOL_er, aCOL_ok )
return AClr


method pro_poklhd_cen_sel:poklhd_c_prepmj_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, dm, mp1
  local  koefMn
  *
  **
  odialog       := drgDialog():new('PRO_poklhd_c_prepmj_sel',::dm:drgDialog)
  odialog:create(,,.T.)
  nexit := odialog:exitState

  mp1   := if( odialog:exitState = drgEVENT_SAVE, xbeK_ENTER, xbeK_ESC )

  if nexit = drgEVENT_SAVE
    if ::zkrJednD:value <> c_prepmj->cvychoziMJ
     koefMn := c_prepmj->nkoefPrVC
    ::fakMnoz:set( ::faktMnKoe:value *koefMn )

    ::koefMn:set( c_prepmj->nkoefPrVC )
    ::zkrJednD:set( c_prepmj->cvychoziMJ )
    endif
  endif

  odialog:destroy()
  odialog := nil

  PostAppEvent(xbeP_Keyboard, mp1,,::zkrJednD:odrg:oxbp)
return .t.


method pro_poklhd_cen_sel:edit_pc(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, dm, mp1, pa_cargo_Usr
  *
  **
  pa_cargo_Usr := { ::dm:has(::it_file +'->nCEJPRZDZ' ):value, ;
                    ::dm:has(::it_file +'->nHODNSLEV' ):value, ;
                    ::dm:has(::it_file +'->nPROCSLEV' ):value, ;
                    ::dm:has(::it_file +'->nCEJPRKDZ' ):value, ;
                    ::dm:has(::it_file +'->nCELKSLEV' ):value, ;
                    ::dm:has(::it_file +'->nCECPRKDZ' ):value, ;
                    ::dm:has(::it_file +'->nFAKTMNKOE'):value  }


  odialog           := drgDialog():new('PRO_poklhd_edit_pc',::dm:drgDialog)
  odialog:cargo_Usr := pa_cargo_Usr
  odialog:create(,,.T.)
  nexit := odialog:exitState

  mp1   := if( odialog:exitState = drgEVENT_SAVE, xbeK_ENTER, xbeK_ESC )

  if nexit = drgEVENT_SAVE
    dm := oDialog:dataManager

    * 1
    ::cejPrZDZ:set( dm:get( ::it_file +'->ncejPrZdz' ) )
    ::hodnSlev:set( dm:get( ::it_file +'->nhodnSlev' ) )
    ::procSlev:set( dm:get( ::it_file +'->nprocSlev' ) )
    ::cejPrKdz:set( dm:get( ::it_file +'->ncejPrKdz' ) )
  endif

  odialog:destroy()
  odialog := nil

  if .t. .and. mp1 = xbeK_ESC
  else
    PostAppEvent(xbeP_Keyboard, mp1,,::cejPrKdz:odrg:oxbp)
  endif
return


method PRO_poklhd_cen_sel:postLastField()
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         pa        := ::m_parent:a_nazPol                             , ;
         is_nazPol := .f.

  AEval( pa, {|x| if( empty(x), nil, is_nazPol := .t. ) } )

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if .not. empty(file_iv)
                          (file_iv)->(dbgoto(recs_iv))
                          ::copyfldto_w(file_iv,::it_file)
                       endif
                       ::intCount++
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->ncislopvp  := 0
                       (::it_file)->nintcount  := ::intCount
    endif

    ::itsave()
    ( poklitW->nfaktMnKoe := ::dm:get('poklitW->nfaktMnKoe'), ;
      poklitW->czkrJednD  := ::dm:get('poklitW->czkrJednD' ), ;
      poklitW->ncejprkdz  := ::dm:get('poklitW->ncejprkdz' ), ;
      poklitW->ncecprkdz  := ::dm:get('poklitW->ncecprkdz' )  )

    (::it_file)->ncenzahcel := (::it_file)->ncecprkbz
    *
    if is_nazPol
      (::it_file)->cnazPol1 := pa[1]
      (::it_file)->cnazPol2 := pa[2]
      (::it_file)->cnazPol3 := pa[3]
      (::it_file)->cnazPol4 := pa[4]
      (::it_file)->cnazPol5 := pa[5]
      (::it_file)->cnazPol6 := pa[6]
    endif
    *
    c_dph->(dbseek((::it_file)->nprocdph,,'C_DPH2'))
    (::it_file)->nklicdph := c_dph->nklicdph

    if ::state = 2
      (::it_file)->( ads_customizeAof( { poklitW->(recNo()) } ))
      ::o_dBro_basketW:oxbp:gobottom():refreshAll()
    else
      ::o_dBro_basketW:oxbp:refreshCurrent()
    endif

    (::it_file)->(flock())
  endif

  fin_ap_modihd(::hd_file,.t.)
  ::sumColumn()

  if ::state = 2
    aadd( pa_inBasket, cenZboz->( recNo()) )
    ::o_dBro:oxbp:refreshCurrent()
  endif

  ::set_focus_dBro()
  ::dm:refresh()
return .t.


method PRO_poklhd_cen_sel:createContext()
  LOCAL cSubMenu, oPopup, x, pa, nIn
  *
  local  popUp   := ::s_popup
  local  aPos    := ::pb_context:oXbp:currentPos()
  local  aSize   := ::pb_context:oXbp:currentSize()

  pA       := ListAsArray(popup)
  cSubMenu := drgNLS:msg(popUp)
  oPopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 TO LEN(pA) step 1
    oPopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  oPopup:disableItem(::popState)
  opopup:popup( ::pb_context:oxbp:parent, apos )
return self


method PRO_poklhd_cen_sel:fromContext(aOrder, nMENU)
  local  obro := ::drgDialog:odbrowse[1]
  *
*  local  filtr, flt := "(ccissklad = '%%' .and. nmnozdzbo <> 0 .and. ncenapzbo <> 0 .and. laktivni)"
  local  filtr, flt := "(ccissklad = '%%' .and. ncenapzbo <> 0 .and. laktivni .and. (( cpolcen = 'C' .and. nmnozdzbo <> 0) .or. cpolcen <> 'C'))"
  local  selSklad := ::a_popup[aOrder]

  ::popState := aOrder
  ::pb_context:oxbp:setCaption(nMENU)
  *
  selSklad := substr(selSklad,1,at('.',selSklad)-1)
  filtr    := format(flt,{selSklad})
  cenzboz->(ads_setaof(filtr),dbgotop())

  ::m_parent:selSklad := ::selSklad := selSklad
  ::m_parent:cisSklad:set(selSklad)
  ::m_parent:cisSklad:initValue := ::m_parent:cisSklad:prevValue := selSklad

  obro:oxbp:refreshAll()
return self


method PRO_poklhd_cen_sel:drgDialogEnd(drgDialog)

  (::it_file)->(ads_clearAof())
***  ::wds_disconnect()

  fin_ap_modihd(::hd_file,.t.)
  ::o_parent_udcp:cenZahCel:set( DBGetVal(( ::hd_file) +'->ncenZahCel') )
  ::o_parent_dBro:oxbp:goBottom():refreshall()
return self