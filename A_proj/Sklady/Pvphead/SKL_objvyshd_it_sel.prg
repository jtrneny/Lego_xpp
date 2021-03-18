#include "Appevent.ch"
#include "Common.ch"
#include "Class.ch"
#include "Gra.ch"
#include "xbp.ch"

#include "drg.ch"
#include "DRGres.Ch'
//
#include "..\Asystem++\Asystem++.ch"


*
** pvpHead
*  class skl_objVyshd_sel objvyshd
*******************************************************************************
class skl_objVyshd_sel from drgUsrClass
EXPORTED:

  * objvyshd
  inline access assign method stav_objvyshd() var stav_objvyshd
    local retVal := 0

    do case
    case(objvyshd->nmnozobdod = 0                    )  ;  retVal := 302
    case(objvyshd->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvyshd->nmnozpldod >= objvyshd->nmnozobdod)  ;  retVal := 302
    case(objvyshd->nmnozpldod <  objvyshd->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal


  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.
    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  return .t.

   inline method init(parent)
     ::drgUsrClass:init(parent)

     drgDBMS:open('objVyshd')
   return self


   inline method drgDialogInit(drgDialog)
*    drgDialog:dialog:drawingArea:bitmap  := 1016
*    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
   return self

   inline method destroy()
     ::drgUsrClass:destroy()
*    c_typPoh->( ads_clearAof())
   return self
ENDCLASS


*
** pvpItem.pøíjem
*
*  class skl_objVysit_sel   objVysit     skl_objVysit_sel.frm
*                                        skl_pohybyit(prg):skl_objVysit_sel(m)
********************************************************************************
CLASS SKL_objVysit_SEL FROM drgUsrClass
EXPORTED:
  method  init, drgDialogStart
  method  createContext, fromContext
  method  mark_doklad  , save_marked

  var     m_udcp, sp_saved, d_bro
  var     hd_file, it_file

  *
  ** BRO column objvysit
  inline access assign method objVysit_is() var objVysit_is
    return if(::m_udcp:wsd_objVysit_kDis <> 0, 6001, 0)

  inline access assign method wds_objvysit_kDis() var wds_objvysit_kDis
    local pa := ::m_udcp:wds_objvysit, recNo := objvysit->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, 2]
    endif
    return (objvysit->nmnozOBdod -objvysit->nmnozPLdod) -nval

  inline access assign method stav_objvysit() var stav_objvysit
    local retVal := 0

    do case
    case(objvysit->nmnozpldod = 0                    )  ;  retVal :=   0
    case(objvysit->nmnozpldod >= objvysit->nmnozobdod)  ;  retVal := 302
    case(objvysit->nmnozpldod <  objvysit->nmnozobdod)  ;  retVal := 303
    endcase
    return retVal

  inline access assign method cisObj_dodavatele() var cisObj_dodavatele
    local  cky   := strZero( objVysit->ncisFirmy,5) +upper( objVysIt->ccisObj)
    local  cky_c := upper( objVysit->ccisSklad) +upper( objVysit->csklPol)

    cenzboz ->( dbseek( cky_c,,'CENIK03' ))
    objVyshd->( dbSeek( cky  ,,'OBJDODH2'))
    return objVyshd->czakOBJint

  *
  ** na pvpitemWW
  inline access assign method pvpitemWW_zahrMena() var pvpitemWW_zahrMena
    return pvpheadW->czahrMena

  inline access assign method cenZboz_czkratJedn() var cenZboz_czkratJedn
    local  cky := upper( pvpItemWW->ccisSklad) +upper( pvpItemWW->csklPol)
    return cenZboz->czkratJedn

  inline access assign method cenZboz_czkratMeny() var cenZboz_czkratMeny
    local  cky := upper( pvpItemWW->ccisSklad) +upper( pvpItemWW->csklPol)
    return cenZboz->czkratMeny


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

  inline method stableBlock(oxbp)
  return self

  inline method post_drgEvent_Refresh()
    local  drgVar := ::dm:has( 'pvpitemWW->nMnozDokl1' )

    if ( ::o_dBro:oxbp = ::dc:oaBrowse:oxbp )   // in objvysit
      ::sta_activeBro:oxbp:setCaption( 337 )
      ::state := 2
      ::o_parent_udcp:takeValue(::it_file, 'objVysit', 4, ::dm)

      ::o_parent_udcp:postValidate(drgVar, ::dm)
    else
      ::sta_activeBro:oxbp:setCaption( 338 )   // in pvpitemWW
      ::state := 1
      ::refresh_basketW()
    endif

    _clearEventLoop(.t.)
  return self


  inline method post_bro_colourCode()
    local recNo := (::in_file)->(recNo()), ;
             pa := ::d_Bro:arselect      , ;
             ok := .f.                   , in_file, obro, ardef, npos_in, ocol_is

    *
    in_file := ::in_file
    obro    := ::drgDialog:dialogCtrl:oBrowse[1]
    ardef   := obro:ardef

    npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_is' })
    ocol_is := obro:oxbp:getColumn(npos_is)

    ok := .t.
    if ocol_is:getData() = 6001
      if (npos := ascan(pa, recNo)) = 0
        aadd(pa, recNo)
      else
        Aremove(pa, npos )
      endif

      if( len(pa) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
      ::d_Bro:arselect := pa
    endif
  return .t.   /// øešení na BRO není povoleno ok


  inline method postValidate(drgVar)
    local  name := Lower(drgVar:name)
    local  lok   := .t., lastOk := .f.
    *
    local  nevent := mp1 := mp2 := nil

    nevent  := LastAppEvent(@mp1,@mp2)

    if ::smallBasket_State
      lok :=  ::o_parent_udcp:postValidate(drgVar, ::dm)

      if( nevent = xbeP_Keyboard .and. isNumber(mp1) )
        if( mp1 = xbeK_RETURN .and. lok)

          do case
          case( name = ::it_file +'->nmnozprdod' )  ;  lastOk := .t.
          endcase

          if( lastOk, ( _clearEventLoop(.t.), ::postLastField() ), nil)
        endif
      endif
    endif
  return lok


  inline method postLastField()

    pvpitemWW->( ordSetFocus( ::ordFocus_it_file ))
    ::o_parent_udcp:postLastField(::dm)

    pvpitemWW->_nbasket := 1
    pvpitemWW->( ordSetFocus( 'PVPITww_04'))

    ::o_dBro_basketW:oxbp:gobottom():refreshAll()
    ::set_focus_dBro()
  return .t.

  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EDIT .and. ::smallBasket_State
      ::df:setNextFocus('pvpitemWW->nMnozDokl1',,.t.)
      return .t.

    case  nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,, oXbp)

    case nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        if oXbp:className() = 'xbpGet'
          ::set_focus_dBro()
        else
          PostAppEvent(xbeP_Close,,, oXbp)
          ::o_parent_dm:refreshAndSetEmpty( 'pvpitemWW' )
        endif

      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.


  inline method drgDialogEnd( drgDialog)
    pvpitemWW->( ordSetFocus( ::ordFocus_it_file ))
    ::o_parent_dBro:oxbp:goBottom():refreshall()

    objVysit->( ads_clearAof())
  return

HIDDEN:
  var  msg, dm, dc, df


  var  m_filter, in_file, ordFocus_it_file
  VAR  popState, a_popUp, pb_context, pb_mark_doklad, pb_save_marked, main_is

  *    objvysit        pvpitemWW
  var  o_dBro        , o_dBro_basketW
  var  o_parent_udcp , o_parent_dm, o_parent_dBro
  var  pb_smallBasket, smallBasket_State, smallBasket_Gets
  var  state         , sta_activeBro

  var  m_parent

  *
  ** smallBasket
  inline method enable_or_disable_Gets()
    local pa := ::smallBasket_Gets, x, odrg

    for x := 1 to len( pa) step 1
      odrg    := ::dm:has(pa[x]):odrg
//      odrg:oVar:block := nil
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


  inline method refresh_basketW()
    local  x
    local  ovar, vars := ::drgDialog:dataManager:vars
    local  dbArea  := ALIAS(::dc:dbArea)

    for x := 1 to vars:size() step 1
      oVar := vars:getNth(x)

      if dbArea +'->' $ ovar:name
        xval := DBGetVal( ovar:name )

        if ovar:value <> xVal
          ovar:initValue := ovar:prevValue := ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    next
  return .t.

ENDCLASS


method skl_objvysit_sel:init(parent)
  ::drgUsrClass:init(parent)

  ::m_filter := objVysit->(ads_getAof())
  ::m_udcp   := parent:parent:udcp:hd_udcp
  ::sp_saved := .f.
  ::in_file  := 'objVysit'
  ::popState := 1
  ::a_popUp  := {{ 'Kompletní seznam  ', ''                                                                       }, ;
                 { 'Nevykryté         ', '(nmnozpldod =  0 .or. (nmnozpldod <> 0 .and. nmnozpldod < nmnozobdod))' }, ;
                 { 'Èásteènì vykryté  ', '(nmnozpldod <> 0 .and. nmnozpldod < nmnozobdod)'                        }, ;
                 { 'Vykryté           ', '(nmnozpldod <> 0 .and. nmnozpldod >= nmnozobdod)'                       }  }

  drgDBMS:open('OBJVYSIT')
  drgDBMS:open('OBJVYSHD')


  * pro smallBasket
  ::o_parent_udcp := parent:parent:udcp
  ::o_parent_dm   := parent:parent:dataManager
  ::o_parent_dBro := parent:parent:odBrowse[1]

  ::hd_file               := ::o_parent_udcp:hd_file
  ::it_file               := ::o_parent_udcp:it_file
  ::ordFocus_it_file      := (::it_file)->( ordSetFocus())
  ::smallBasket_Gets      := { 'pvpitemWW->nMnozDokl1', 'pvpitemWW->cMjDokl1', 'pvpitemWW->ncenNADOzm', 'pvpitemWW->nMnozPrDod' }
return self


method skl_objvysit_sel:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin
  *
  local  pa_tagKey, nsid_old

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMananager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  pa_tagKey := drgScrPos:getPos_forSel('SKL_objvysit_SEL', drgDialog, ::in_file)
  nsid_old  := pa_tagKey[3]

  if .not. empty(nsid_old)
    lok_old := (::in_file)->( dbseek( nsid_old,, 'ID' ))
  else
    lok_old := .t.
  endif

  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif

*      groups      := pa_groups[1]
*      odrg:groups := groups
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
      ::sta_activeBro := odrg
    endif


    if  odrg:ClassName() = 'drgPushButton'
      do case
      case members[x]:event = 'createContext'  ;  ::pb_context     := members[x]
      case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      case members[x]:event = 'smallBasket'    ;  ::pb_smallBasket := members[x]
      endcase
    endif
  next

  ::pb_context:oXbp:setFont(drgPP:getFont(5))
  ::pb_context:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
  ::pb_save_marked:disable()

  ::fromContext(2,'Nevykryté ')

  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  ::d_Bro  := drgDialog:odBrowse[1]
  ::o_dBro := ::d_Bro
  *
  ** smallBasket
  ::o_dBro_basketW    := drgDialog:odBrowse[2]
  ::smallBasket_State := .f.
  ::enable_or_disable_Gets()
return self


method SKL_objVysit_SEL:createContext()
  local  opopup
  local  pa    := ::a_popUp
  local  aPos  := ::pb_context:oXbp:currentPos()
  local  aSize := ::pb_context:oXbp:currentSize()

  opopup         := XbpImageMenu():new( ::drgDialog:dialog )
  opopup:barText := 'Objednávky'
  opopup:create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {pa[x,1]                       , ;
                     de_BrowseContext(self,x,pA[x]), ;
                                                   , ;
                     XBPMENUBAR_MIA_OWNERDRAW        }, ;
                     if( x = ::popState, 500, 0)        )
  next


  opopup:disableItem(::popState)

  opopup:popup( ::pb_context:oxbp:parent, { apos[1] +10, apos[2] } )
return self

method SKL_objVysit_SEL:fromContext(aorder,nmenu)
  local  obro    := ::drgDialog:dialogCtrl:oBrowse[1]
  local  filter  := ::m_filter +if(.not. empty(::m_filter), " .and. ", "")
  *
  local  ardef   := obro:ardef, npos_is, ocol_is
  local  in_file := ::in_file, pa := {}
  local  pa_wds, pa_exclude := {}
  *
  local  recNo    := (::in_file)->( recNo()), sID := isNUll((::in_file)->sID,0)
  local  a_popUp  := ::a_popUp

  npos_is := ascan(ardef, {|x| x[2] = 'M->' +in_file +'_is' })
  ocol_is := obro:oxbp:getColumn(npos_is)

  ::popState := aorder
  ::pb_context:oxbp:setCaption( a_popUp[aorder,1])
  curr_recNo := recNo

  do case
  case(aorder = 1)                               // Kompletní seznam
    (in_file)->( ads_setAof(::m_filter))

  otherwise
    filter += a_popUp[ aorder, 2 ]
    if( .not. empty(filter), (in_file)->(ads_setAof(filter),dbgoTop()), nil)
  endcase

  if(aorder = 2 .or. aorder = 4)
    pa_wds := ::m_udcp:wds_objVysit
    *
    ** vyjmeme záznamy, kde množství pro pøevzetí je --> 0
    aeval( pa_wds, { |x|  (in_file) ->( dbgoto(x[1])) , ;
                          if( ocol_is:getData() = 0, aadd( pa_exclude, x[1] ), nil ) } )

    if len( pa_exclude ) <> 0
      (in_file)->( ads_customizeAOF( pa_exclude, 2))
    endif
  endif

  if( sID = 0, (in_file)->( dbgoTop()), (in_file)->( dbgoTo( recNo)) )

  if .not. (in_file)->( ads_isRecordInAOF(recNo))
    (in_file)->( dbskip())
    obro:oxbp:panHome():forceStable()
  else
    (in_file)->( dbgoTo(recNo))
  endif

  * rušíme oznaèení
  obro:arselect := {}
  obro:oxbp:panHome():forceStable()
  obro:oxbp:refreshAll()

  if( aorder = 2, ::pb_mark_doklad:enable(), ::pb_mark_doklad:disable())
  ::pb_save_marked:disable()

  setAppFocus( obro:oxbp )
  PostAppEvent(xbeBRW_ItemMarked,,,obro:oxbp)
RETURN self


method skl_objVysit_sel:mark_doklad(drgDialog)
  local in_file := ::in_file, recNo, ;
             pa := ::d_bro:arselect, ps, doklad, block, ok := .t., is_ctrlA, ;
          nskip := 0

  if ::popState = 2
    recNo    := (in_file)->(recNo())
    ps       := {}
    is_ctrlA := if( isObject(drgDialog), .f., .t.)

    do case
    case is_ctrlA  ;  ( ok := (len(pa) = 0),  block := ".t." )
    otherwise
      doklad := (in_file)->ndoklad
      block  := format("ndoklad = %%", {(in_file)->ndoklad})
    endcase

    if ok
      (in_file)->(dbGoTop())
      do while .not. (in_file)->(eof())
        if (in_file) ->( eval(COMPILE(block)))
         if ascan(pa,(in_file)->(recNo())) = 0
           aadd(ps, (in_file)->(recNo()) )
         endif
        endif

        (in_file)->(dbskip())
        nskip++
      enddo

      do while (in_file)->(recNo()) <> recNo ; (in_file)->(dbskip(-1)) ; enddo
    endif

    if( len(ps) = 0, ::pb_save_marked:disable(), ::pb_save_marked:enable())
    ::d_bro:arselect := ps

    ::d_bro:oxbp:refreshAll()
  endif
return


method skl_objVysit_sel:save_marked()
  ::sp_saved := .t.
  postappevent(drgEVENT_EDIT,,,::d_bro:oxbp)
return
