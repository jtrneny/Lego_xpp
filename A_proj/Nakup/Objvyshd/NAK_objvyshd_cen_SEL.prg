#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"


*   CENÍK ZBOŽÍ pro OBJEDNÁVKY PØIJATÉ
**  CLASS for NAK_objvyshd_cen_sel *********************************************
CLASS NAK_objvyshd_cen_sel FROM drgUsrClass
exported:
  method  init, ItemMarked, eventHandled
  method  drgDialogStart, drgDialogEnd
  method  createContext, fromContext
  method  postValidate

  var     quickFilter
  var     sel_Item, sel_Filtrs

  var     smallBasket_katCZbo, smallBasket_cenNaoDod, smallBasket_mnozObSkl

  * cenzboz - ceníková/neceníková položka
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method hlavniDod() var hlavniDod
    return if( dodZboz->lhlavniDod, MIS_ICON_OK, 0)

  *
  ** smallBasket
  inline method smallBasket()
    local  state_y
    local  oIcon := XbpIcon():new():create()

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
  method  relFiltrs
  var     dm, df, drgVar, drgPush
  var     nrok

  var     hd_file, it_file

  *       cenZboz         objVysitW
  var     o_dBro        , o_dBro_basketW
  var     oico_noQuick  , oico_isQuick
  var     pb_context    , a_popUp, popState

  var     o_parent_udcp , o_parent_dm, o_parent_dBro
  var     pb_smallBasket, smallBasket_State, smallBasket_Gets

  *
  ** smallBasket
  inline method enable_or_disable_Gets()
    local pa := ::smallBasket_Gets, x, odrg

    for x := 1 to len( pa) step 1
      odrg        := ::dm:has(pa[x]):odrg
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
    postAppEvent( xbeBRW_ItemMarked,,, ::o_dBro:oxbp)
  return self

  inline method save_to_basketW()
    local file_iv := 'cenZboz'

    ::o_parent_udcp:takeValue( file_iv, 2)
    ::o_parent_udcp:copyfldto_w( ::hd_file, ::it_file,.t.)

    (::it_file)->nintCount := ::o_parent_udcp:ordItem() +1

    ::itSave_to_basketW( ::o_parent_udcp:dm )

    * výpoèet nKcBdObj / nkcZdObj
    c_dph  ->( dbseek( (::it_file)->nklicDph,,'C_DPH1'))

    (::it_file)->ckatCZbo   := ::dm:get('M->smallBasket_katCZbo'  )
    (::it_file)->nmnozObSkl := ::dm:get('M->smallBasket_mnozObSkl')
    (::it_file)->nmnozObDod := ::dm:get('M->smallBasket_mnozObSkl')
    (::it_file)->ncenNaoDod := ::dm:get('M->smallBasket_cenNaoDod')

    (::it_file)->nkcBdObj   := (::it_file)->nmnozObDod  * (::it_file)->ncenNaoDod
    (::it_file)->nkcZdObj   := (::it_file)->nkcBdObj    + int((::it_file)->nkcBdObj * c_dph->nprocDph/100)
    (::it_file)->nhmotnost  := ((::it_file)->nmnozObDod * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem     := ((::it_file)->nmnozObDod * (::it_file)->nobjemJ   )
    (::it_file)->_nbasket   := 1
    (::it_file)->(dbcommit())

    nak_objvyshd_cmp()
    ::o_dBro_basketW:oxbp:goBottom():refreshall()

    ::set_focus_dBro()
  return self


  inline method itSave_to_basketW( dm )
    local  x, ok := .t., vars := dm:vars, drgVar, ok_it

    for x := 1 to dm:vars:size() step 1
      drgVar := dm:vars:getNth(x)

      * musí to být jen objvyshdw, objvysitw
      ok_it := ( at( 'objvyshdw', lower(drgVar:name)) <> 0 .or. ;
                 at( 'objvysitw', lower(drgVar:name)) <> 0      )

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok_it
        if (eval(drgvar:block) <> drgVar:value)
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
  return self
ENDCLASS


method NAK_objvyshd_cen_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  local oDialog, nExit

  do case
  case nEvent = drgEVENT_EDIT .and. ::smallBasket_State
    ::df:setNextFocus('M->smallBasket_mnozObSkl',,.t.)
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
        ::o_parent_dm:refreshAndSetEmpty( 'objVysitw' )
      endif

     otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.


method NAK_objvyshd_cen_sel:init(parent)
  local m_parent
  local ex_filtr := "(cpolcen = 'C' .or. cpolCen = 'E')"

  ::drgUsrClass:init(parent)

  ::o_parent_udcp := parent:parent:udcp
  ::o_parent_dm   := parent:parent:dataManager
  ::o_parent_dBro := parent:parent:odBrowse[1]

  ::drgVar        := setAppFocus():cargo
  ::nrok          := uctObdobi:SKL:nROK

  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('dodZboz' )

  * pro smallBasket
  drgDBMS:open( 'dodZboz',,,,,'dodZboz_a')
  ::hd_file               := ::o_parent_udcp:hd_file
  ::it_file               := ::o_parent_udcp:it_file
  ::smallBasket_Gets      := { 'M->smallBasket_katCZbo', 'M->smallBasket_cenNaoDod', 'M->smallBasket_mnozObSkl' }
  ::smallBasket_katCZbo   := ''
  ::smallBasket_cenNaoDod := 0 //  .00
  ::smallBasket_mnozObSkl := 0 //  .00

  drgDBMS:open('CENZB_ps')
  drgDBMS:open('C_SKLADY')

  drgDBMS:open('C_DPH'   )
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))

  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))

  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))

  ::sel_Item   := ''
  ::sel_Filtrs := {}
  ::a_popUp    := { { 'Kompletní seznam                 ', ''                                      }, ;
                    { 'Aktivní položky                  ', ex_filtr +" .and. laktivni"             }, ;
                    { 'Neaktivní položky                ', ex_filtr +" .and. .not. laktivni"       }, ;
                    { 'Zboží k objednání                ', ex_filtr +" .and. nmnozKZbo <> 0"       }, ;
                    { 'Zboží k dodavateli               ', '5'  }, ;
                    { 'Zboží k dodavateli a k objednámí ', '6'  }, ;
                    { 'Zboží pod minStavem              ', ex_filtr +" .and. nmnozSZbo < nminZbo"  }, ;
                    { 'Zboží pod minStavem  k dodavateli', '8'  }, ;
                    { 'Zboží k objedání k hlDodavateli  ', '9'  }  }

  if isObject( m_parent := parent:parent )
    if m_parent:lastXbpInFocus:className() = 'XbpGet'
      ::sel_Item := m_parent:lastXbpInFocus:cargo:name
    endif
  endif
return self


method NAK_objvyshd_cen_sel:drgDialogStart(drgDialog)
  local  aMembers := drgDialog:oForm:aMembers
  local  showDlg  := .T., file_iv, varSym, tagNo, pa
  *
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp
  local  XbpDialog  := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize
  local  curr_Filter
  *
  **
  ::dm             := drgDialog:dataManager               // dataMananager
  ::df             := drgDialog:oForm                     // form
  ::o_dBro         := drgDialog:odBrowse[1]

  if IsObject(::drgVar)
    apos := mh_GetAbsPosDlg(::drgVar:oXbp,drgDialog:dataAreaSize)
  endif
  *
  for x := 1 to len(aMembers) step 1
    if aMembers[x]:ClassName() = 'drgPushButton'
      ::drgPush := aMembers[x]
      if( aMembers[x]:event = 'createContext', ::pb_context     := aMembers[x], nil )
      if( aMembers[x]:event = 'smallBasket'  , ::pb_smallBasket := aMembers[x], nil )
    endif
  next

  ::oico_noQuick := XbpIcon():new():create()
  ::oico_isQuick := XbpIcon():new():create()
  ::oico_isQuick:load( NIL, 101 )

  ::pb_context:oxbp:setImage( ::oico_noQuick )
  ::popState    := 1
  ::quickFilter := 0
  *
  ** quickFiltrs na SEL dialogu
  ** { { 'cenzboz,  { 'Zboží k dodavateli               ', 'B'   } }
  do case
  case .not. empty( sel_Filtrs )
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'cenzboz'} )) <> 0
      if ( nitem := ascan( a_popUp, {|x| x[2] = sel_Filtrs[nfile,2,2]} )) <> 0
        ::quickFilter := nitem
        ::fromContext(nitem, sel_Filtrs[nfile,2])
      endif
    endif

  case .not. empty(curr_Filter := cenZboz->(ads_getAof()) )
    if ( nitem := ascan( a_popUp, {|x| upper( allTrim( x[2])) = curr_Filter } )) <> 0
      ::quickFilter := nitem
      ::fromContext(nitem, a_poPup[nitem])
    endif
  endCase

  ::drgPush:oXbp:setFont(drgPP:getFont(5))
  ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  *
  ** smallBasket
  ::o_dBro_basketW    := drgDialog:odBrowse[4]
  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self


method NAK_objvyshd_cen_sel:drgDialogEnd(drgDialog)
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp
  local  nfile, nitem

  if ::smallBasket_State .and. .not.(::it_file)->( eof())
    postAppEvent(xbeP_Keyboard,xbeK_ESC,,::o_parent_dm:drgDialog:lastXbpInFocus )
  endif

  objVysitW->( ordSetFocus( 'OBJVYSIT_1' ))
  ::o_parent_dBro:oxbp:goBottom():refreshall()

  if ::quickFilter <> 0
    if empty( sel_Filtrs)
      aadd( sel_Filtrs, { 'cenzboz', a_popUp[::quickFilter] } )

    else
      if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'cenzboz'} )) = 0
        aadd( sel_Filtrs, { 'cenzboz', a_popUp[::quickFilter] } )

      else
        sel_Filtrs[nfile,2] := a_popUp[::quickFilter]

      endif
    endif
  else
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'cenzboz'} )) <> 0
      aRemove( sel_Filtrs, nfile )
    endif
  endif
return self


method NAK_objvyshd_cen_sel:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case( name = 'M->smallBasket_mnozObSkl' )
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN )
      if( value <> 0, ::save_to_basketW(), ::set_focus_dBro())
    endif
  endCase
return .t.


method NAK_objvyshd_cen_sel:itemMarked(arowco,unil,oxbp)
  local  m_file, cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol) +objVysHDw->czkratMenZ
  local  ncenNAOdod

  if isObject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    do case
    case( m_file = 'cenzboz' )
      dodZboz ->( ordSetFocus( 'DODAV5'), dbSetScope(SCOPE_BOTH, cky), dbgotop())
      pvpKumul->( ordSetFocus('PVPKUM2'), dbSetScope(SCOPE_BOTH, cky), dbgotop())
    endcase
  endif

  dodZboz_a->(dbseek(strZero(objVysHDw->ncisFirmy,5) +cky,,'DODAV6'))
  ncenNAOdod := if(dodzboz_a->ncenaOzbo = 0, dodzboz_a->ncenaNzbo, dodzboz_a->ncenaOzbo)

  ::smallBasket_katCZbo   := dodZboz_a->ckatcZbo
  ::smallBasket_cenNaoDod := ncenNAOdod

  ::dm:set('M->smallBasket_katCZbo'  , dodZboz_a->ckatcZbo )
  ::dm:set('M->smallBasket_cenNaoDod', ncenNAOdod          )
return self


method NAK_objvyshd_cen_sel:createContext()
  local  csubmenu, opopup
  *
  local  pa := ::a_popUp
  local  aPos    := ::pb_context:oXbp:currentPos()
  local  aSize   := ::pb_context:oXbp:currentSize()

  opopup         := XbpImageMenu():new( ::drgDialog:dialog )
  opopup:barText := 'Ceník zboží'
  opopup:create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {pa[x,1]                       , ;
                     de_BrowseContext(self,x,pA[x]), ;
                                                   , ;
                     XBPMENUBAR_MIA_OWNERDRAW        }, ;
                     if( x = ::quickFilter, 500, 0)     )
  next

  opopUp:disableItem( ::popState )

  apos    := ::pb_context:oXbp:currentPos()
  opopUp:popUp(::drgDialog:dialog, apos )
RETURN self


method NAK_objvyshd_cen_sel:fromContext(aorder, p_popUp )
  local  obro := ::drgDialog:odbrowse[1]
  *
  local  crels := 'strZero(objvyshdw->ncisFirmy) +upper(cenzboz->ccisSklad) +upper(cenZboz ->csklPol)'
  local  filter, ex_filtr := "(cpolcen = 'C' .or. cpolCen = 'E')", ex_cond
  *
  local  cky_dodZboz := strZero(objvyshdw->ncisFirmy, 5) // +upper(cenzboz->ccisSklad) +upper(cenZboz ->csklPol)


  ::popState := aOrder
  *
  ** ? oznaèil si pøednastavený quickFilter, poku ne je to jen pøepnutí
  if AppKeyState( xbeK_CTRL ) = APPKEY_DOWN
    ::quickFilter := if( ::quickFilter = aorder, 0, aorder )
  endif

  ::pb_context:oxbp:setImage( if( ::quickFilter = aorder, ::oico_isQuick, ::oico_noQuick ))
  ::pb_context:oxbp:setCaption( allTrim( p_popUp[1]))
  ::pb_context:oxbp:setFont(drgPP:getFont(5))
  ::pb_context:oxbp:setColorFG(GRA_CLR_RED)


  do case
  case(aOrder = 1)                  ;  cenzboz->(ads_clearAof(), dbgoTop())
  case(aOrder = 2)
    filter = ex_filtr + " .and. laktivni"

  case(aOrder = 3)
    filter = ex_filtr + " .and. .not. laktivni"

  case(aOrder = 4)
    filter = ex_filtr + " .and. nmnozKZbo <> 0"

  case(aOrder = 5)
    filter  := ex_filtr
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 6)
    filter  := ex_filtr +" .and. nmnozKZbo <> 0"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 7)
    filter := ex_filtr +" .and. nmnozSZbo < nminZbo"

  case(aOrder = 8)
    filter  := ex_filtr +" .and. nmnozSZbo < nminZbo"
    ex_cond := 'objvyshdw->ncisFirmy = dodzboz->ncisFirmy'

  case(aOrder = 9)
    filter  := ex_filtr +" .and. nmnozKZbo > 0"
    ex_cond := 'dodzboz->lhlavniDod'                        // DODAV7
  endcase

  if .not. isnull(filter)
    cenzboz->(ads_setAof(filter), dbgoTop())

    if( .not. isNull(ex_cond), relfiltrs(cky_dodZboz), nil )
  endif

  obro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,obro:oxbp)
  SetAppFocus( obro:oXbp )
return self


static function relfiltrs(cky_dodZboz)
  local  pa := {}, filter := '', cky

  dodZboz->( ordSetFocus('DODAV6')               , ;
             dbsetScope( SCOPE_BOTH, cky_dodZboz), ;
             dbgoTop()                             )

  do while .not. dodZboz->( eof())
    cky := upper(dodZboz->ccisSklad) +upper(dodZboz->csklPol)

    if cenZboz->( dbseek( upper(dodZboz->ccisSklad) +upper(dodZboz->csklPol),,'CENIK03'))
      aadd( pa, cenZboz->(recNo()) )
    endif
    dodZboz->( dbskip())
  enddo

  cenZboz->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  cenZboz->( ads_setaof(filter), dbgotop())
  dodZboz->( dbclearScope())
return .t.



method NAK_objvyshd_cen_sel:relfiltrs(mfile, ex_cond)
  local  pa := {}, filter := ''


  do while .not. (mfile)->(eof())
    if( DBGetVal(ex_cond), aadd(pa,(mfile)->(recno())), nil)

    (mfile)->(dbskip())
  enddo

  (mfile)->(ads_clearaof(), dbgotop())

  aeval(pa,{|x| filter += 'recno() = ' +str(x) +' .or. '})
  filter := left(filter, len(filter)-6)
  if( empty(filter), filter := 'recno() = 0', nil)

  (mfile)->(dbclearRelation(), ads_setaof(filter), dbgotop())
return self