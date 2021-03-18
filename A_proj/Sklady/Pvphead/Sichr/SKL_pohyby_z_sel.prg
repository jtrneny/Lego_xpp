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
*  class skl_typPoh_sel c_typPoh
********************************************************************************
CLASS SKL_typPoh_SEL FROM drgUsrClass
EXPORTED:
  METHOD  drgDialogStart, tabSelect, getFORM

  inline method init( parent)
    ::drgUsrClass:init(parent)
    *
    ::m_udcp    := parent:parent:udcp
    ::tabNum    := pvpHeadW ->ntypPvp
    ::typPohybu := pvpHeadW ->ctypPohybu
  return self

  inline access assign method is_stornoDok() var is_stornoDok
    return if( c_typPoh->nstornoDok = 1, 300, 0 )

  inline access assign method skl_karta() var skl_karta
    return val ( right( allTrim(c_typPoh->ctypDoklad), 3))


  inline method drgDialogInit(drgDialog)
*    drgDialog:dialog:drawingArea:bitmap  := 1016
*    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
    OTHERWISE
      RETURN  .F.
    ENDCASE
  return .t.

  inline method itemMarked()
    local typDoklad := allTrim(c_typPoh->ctypDoklad)
    local typPohybu := left(typDoklad,7)

    if ::oDBro:oxbp:currentState() = 1 .and. isMethod( ::m_udcp, 'sel_typPohybu')
      ::m_udcp:sel_typPohybu()
    endif
  return self

  inline method destroy()
    ::drgUsrClass:destroy()
    c_typPoh->( ads_clearAof())
  return self

HIDDEN:
  var     m_udcp
  VAR     tabNum, typPohybu
  var     df, tabPageManager, oDBro

  inline method setFilter( nPohyb)
    local Filter

    Do case
    Case nPohyb = 1     // pouze pøíjmové pohyby
      Filter := FORMAT( "Left( Right( Alltrim( cTypDoklad),3), 1) $ '%%' .and. cUloha = 'S'" , {'14'} )

    Case nPohyb = 2     // pouze výdajové pohyby
      Filter := FORMAT( "Left( Right( AllTrim( cTypDoklad),3), 1) = '%%'.and. cUloha = 'S' .and. left(ctypPohybu,1) > '1'" , {'2'} )

    Case nPohyb = 3     // pouze pøevodní pohyby
      Filter := FORMAT( "Left( Right( AllTrim( cTypDoklad),3), 1) = '%%'.and. cUloha = 'S' .and. left(ctypPohybu,1) > '5'" , {'3'} )

    EndCase

    * musíme vylouèit tyto pohyby SKL_VYD255
    filter += " .and. .not. ( ctypdoklad = 'SKL_STA100' .or. ctypDoklad = 'SKL_VYD255' .or. ctypDoklad = 'SKL_VYD283' .or. ctypDoklad = 'SKL_VYD299' )"

    c_typPoh->( ads_setAof( filter ), dbgoTop() )
  return .t.

ENDCLASS


METHOD SKL_TypPoh_SEL:drgDialogStart(drgDialog)
  Local oBro := ::drgDialog:dialogCtrl:oBrowse[1], oColumn, x, n

  ::df             := drgDialog:oForm                    // form
  ::tabPageManager := drgDialog:oForm:tabPageManager     // tabPageManager
  ::oDBro          := ::drgDialog:dialogCtrl:oBrowse[1]

  FOR n := 1 To len(::drgDialog:dialogCtrl:oBrowse) step 1
    oBro := ::drgDialog:dialogCtrl:oBrowse[n]
    FOR x := 1 TO oBro:oXbp:colcount
      ocolumn := oBro:oXbp:getColumn(x)
      ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR] := GraMakeRGBColor( {255, 255, 200} )
      ocolumn:configure()
    NEXT
    oBro:oXbp:refreshAll()
  NEXT
  *
  ::tabPageManager:showPage( ::TABnum, .t. )
*  ::tabSelect( , ::tabNUM)
RETURN self


METHOD SKL_TypPoh_SEL:tabSelect( tabPage, tabNumber)
  Local Filter

  ::tabNUM := tabNumber
  ::setFilter( ::tabNUM)
  *
  ::df:olastdrg   := ::oDBro
  ::df:olastdrg:setFocus()
  SetAppFocus( ::oDBro:oxbp)

  if .not. c_typPoh->( dbseek( ::typPohybu,,'C_TYPPOH09'))
    c_typPoh->(dbgoTop())
  endif

  ::oDBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::oDBro:oxbp)
RETURN .T.


method SKL_typpoh_SEL:getForm()
  Local  oDrg, drgFC

  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 57,17 DTYPE '10' TITLE 'Výbìr pohybu ..... ' ;
                                           GUILOOK 'All:N,Border:Y'

  DRGTEXT INTO drgFC CAPTION 'Vyber typ požadovaného dokladu ... ' CPOS 0,16 CLEN 57 PP 2 BGND 15

  DRGTABPAGE INTO drgFC CAPTION 'Pøíjem' OFFSET  1,82 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Výdej'  OFFSET 16,68 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Pøevod' OFFSET 31,53 SIZE 57,1.2 PRE 'tabSelect'
    DRGPUSHBUTTON INTO drgFC POS 0,0 SIZE 0,0
  DRGEND INTO drgFC

  DRGDBROWSE INTO drgFC  SIZE 57,14.8 FPOS 0,1.2 FILE 'C_TypPOH' INDEXORD 7 ;
             FIELDS 'cTypDoklad:typDokl,'        + ;
                    'cTypPohybu:pohyb:7,'        + ;
                    'M->skl_karta:karta:4,'      + ;
                    'M->is_stornoDok:st:2.6::2,' + ;
                    'cNazTypPoh:název pohybu:31'   ;
             SCROLL 'ny' CURSORMODE 3 PP 7 ITEMMARKED 'itemMarked' POPUPMENU 'yy'

RETURN drgFC


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
    if ( ::o_dBro:oxbp = ::dc:oaBrowse:oxbp )   // in objvysit
      ::sta_activeBro:oxbp:setCaption( 337 )
      ::state := 2
      ::o_parent_udcp:takeValue(::it_file, 'objVysit', 4, ::dm)

    else
      ::sta_activeBro:oxbp:setCaption( 338 )   // in pvpitemWW
      ::state := 1
*      ::o_parent_udcp:takeValue(::it_file, ::it_file, 1, ::dm)
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
    local  lok  := .t.

    lok :=  ::o_parent_udcp:postValidate(drgVar, ::dm)
    return lok

  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EDIT .and. ::smallBasket_State
      ::o_parent_udcp:takeValue(::it_file, 'objvysit', 4, ::dm)
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
    pvpitemWW->( ordSetFocus( 'PVPITww_01' ))
    ::o_parent_dBro:oxbp:goBottom():refreshall()

    objVysit->( ads_clearAof())
  return

HIDDEN:
  var  msg, dm, dc, df


  var  m_filter, in_file
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

ENDCLASS


method skl_objvysit_sel:init(parent)
  ::drgUsrClass:init(parent)

  ::m_filter := objVysit->(ads_getAof())
  ::m_udcp   := parent:parent:udcp:hd_udcp
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
  ::smallBasket_Gets      := { 'pvpitemWW->nMnozDokl1', 'pvpitemWW->cMjDokl1', 'pvpitemWW->ncenNADOzm', 'pvpitemWW->nMnozPrDod' }
// ordItem  ::intCount              := ::m_parent:ordItem()

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




* pvpitem.výdej_pøevod
*
*  class skl_objItem_sel   objItem      skl_objItem_sel.frm
*                                       skl_pohybyit(prg):skl_objItem_sel(m)
********************************************************************************
CLASS SKL_objItem_SEL FROM drgUsrClass
EXPORTED:
  var     m_udcp
  method  createContext, fromContext

  *
  ** BRO column
  inline access assign method objitem_is() var objitem_is
    return if(::m_udcp:wsd_objitem_kDis <> 0, 6001, 0)


  inline access assign method wds_objitem_kDis() var wds_objitem_kDis
    local pa := ::m_udcp:wds_objitem, recNo := objitem->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, 2]
    endif
    return (objitem->nmnozOBodb -objitem->nmnozPLodb) -nval

  inline access assign method stav_Svydw() var stav_Svydw
    local  retVal    := 0
    local  cky       := upper(objitem->ccisSklad) +upper(objitem->csklPol)
    local  mnozOBodb := objitem->nmnozOBodb -objitem->nmnozPLodb
    local  mnozSzbo

    cenZboz->( dbseek( cky,,'CENIK03'))
    mnozSzbo := cenZboz->nmnozSzbo

    if objItem->sID = 0
      return 0
    endif

    do case
    case( mnozSzbo =  0         )  ;  retVal := 558  // m_Cervena
    case( mnozSzbo >= mnozOBodb )  ;  retVal := 556  // m_Zelena
    case( mnozSzbo <  mnozOBodb )  ;  retVal := 555  // m_Zluta
    endcase
    return retVal

  inline access assign method mn_doDokl() var mn_doDokl
    return (objitem->nmnozObOdb -objitem->nmnozPlOdb)

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

    ::m_udcp := parent:parent:udcp:hd_udcp

    ::m_filter := objItem->(ads_getAof())
    ::m_udcp   := parent:parent:udcp:hd_udcp
    ::in_file  := 'objItem'
    ::popState := 1
    ::a_popUp  := {{ 'Kompletní seznam  ', ''                                                                       }, ;
                   { 'Nevykryté         ', '(nmnozPLodb =  0 .or. (nmnozPLodb <> 0 .and. nmnozPLodb < nmnozOBodb))' }, ;
                   { 'Èásteènì vykryté  ', '(nmnozPLodb <> 0 .and. nmnozPLodb < nmnozOBodb)'                        }, ;
                   { 'Vykryté           ', '(nmnozPLodb <> 0 .and. nmnozPLodb >= nmnozOBodb)'                       }  }

    drgDBMS:open('objItem')
    drgDBMS:open('objHead')
  return self


  inline method drgDialogInit(drgDialog)
    local nKarta := drgDialog:parentDialog:cargo:udcp:nKarta

    drgDialog:formHeader:title := if(nKarta = 274, 'Výrobní zakázky - VÝBÌR'  , ;
                                                    drgDialog:formHeader:title  )
  return self

  inline method drgDialogStart(drgDialog)
    local  x, members := drgDialog:oForm:aMembers
    local  pa_tagKey, nsid_old

    pa_tagKey := drgScrPos:getPos_forSel('SKL_objItem_SEL', drgDialog, ::in_file)
    nsid_old  := pa_tagKey[3]

    if .not. empty(nsid_old)
      lok_old := (::in_file)->( dbseek( nsid_old,, 'ID' ))
    else
      lok_old := .t.
    endif

    for x := 1 to len(members) step 1
     if  members[x]:ClassName() = 'drgPushButton'
       do case
       case members[x]:event = 'createContext'  ;  ::pb_context     := members[x]
       case members[x]:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
       case members[x]:event = 'save_marked'    ;  ::pb_save_marked := members[x]
       endcase
     endif
   next

   ::pb_context:oXbp:setFont(drgPP:getFont(5))
   ::pb_context:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )
   ::pb_save_marked:disable()

   ::fromContext(2,'Nevykryté ')

   ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   return self

HIDDEN:
  var  m_filter, in_file
  VAR  popState, a_popUp, pb_context, pb_mark_doklad, pb_save_marked, main_is

ENDCLASS


method SKL_objItem_SEL:createContext()
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


method SKL_objItem_SEL:fromContext(aorder,nmenu)
  local  obro    := ::drgDialog:dialogCtrl:oBrowse[1]
  local  filter  := ::m_filter +if(.not. empty(::m_filter), " .and. ", "")
  *
  local  ardef   := obro:ardef, npos_is, ocol_is
  local  in_file := ::in_file, pa := {}
  local  pa_wds, pa_exclude := {}
  *
  local  recNo    := (::in_file)->( recNo()), sID := isNull((::in_file)->sID,0)
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
    pa_wds := ::m_udcp:wds_objItem
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




*
*  class skl_vyrZakit_sel   vyrZakit
*                                        skl_pohybyit(prg):skl_vyrZakit_sel (m)
********************************************************************************
CLASS SKL_vyrZakit_SEL FROM drgUsrClass
EXPORTED:
  VAR     lDataFilter, mainBro

  * struktura pole
  * { recno()  ,curr_curr_mnozDokl1/pocPol, curr_mnozPrDod/pocPol,
  *             curr_celkItem/pocPol      , curr_celkDokl/pocPol , ccisZakazi }
  var     pa_mnozDokl1

  method init, getForm, drgDialogInit, drgDialogStart

  *
  ** bro column_1 - bude/ nebude  pøenesena do položek dokladu
  inline access assign method vyrZakitw_isOk() var vyrZakitw_isOk
    local  recNo := vyrZakitw->( recNo())
    if isObject( ::d_Bro)
      pa := ::d_Bro:arSelect

      return if( ascan( pa, recNo) <> 0 .or. ::d_Bro:is_selAllRec, 6001, 0)
    endif
    return 0

  ** bro column_4 - rozpoèítané množství nmnozDokl1 do položky dokladu
  inline access assign method mnozDokl1() var mnozDokl1
    local  npos, recNo := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      return pa_mnoz[ npos,2]
    endif
    return 0

  ** bro column_5 - rozpoèítané množství nmnozPrDod do položky dokladu
  inline access assign method mnozPrDod() var mnozPrDod
    local  npos, recNo := vyrZakitw->( recNo())
    local  pa_mnoz := ::pa_mnozDokl1

    if ( npos := ascan( pa_mnoz, { |x| x[1] = recNo })) <> 0
      return pa_mnoz[ npos,3]
    endif
    return 0


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    if ::d_Bro:is_selAllRec <> ::is_selAllRec
      ::is_selAllRec := ::d_Bro:is_selAllRec

      ::post_bro_colourCode(::is_selAllRec)
    endif

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::recordSelected()

    CASE nEvent = drgEVENT_APPEND
*      ::recordEdit()

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
    RETURN .T.

  inline method post_bro_colourCode(is_selAllRec)
    local  npos, recNo := vyrZakitw->(recNo())
    local  pa_sel         := ::arSelect
    local  pa_mnoz        := ::pa_mnozDokl1
    local  curr_mnozDokl1 := ::curr_mnozDokl1
    local  curr_mnozPrDod := ::curr_mnozPrDod
    local  curr_celkItem  := ::curr_celkItem
    local  curr_celkDokl  := ::curr_celkDokl

    if isLogical(is_selAllRec)
      do case
      case is_selAllRec
        pa_mnoz := ::pa_mnozDokl1 := {}
        vyrZakitW->( dbeval( { || aadd(pa_mnoz, { vyrZakitw->( recNo()), 0, 0, 0, 0, vyrZakitw->ccisZakazi }) } ), ;
                     dbgoTo( recNo)                                                                                )

      otherwise
        pa_mnoz := ::pa_mnozDokl1 := {}

      endcase
    else
      npos := ascan( pa_mnoz, { |x| x[1] = recNo } )

      do case
      case npos  = 0        // oznaèil položku pro rozpad množství
        aadd( pa_mnoz, { recNo, 0, 0, 0, 0, vyrZakitw->ccisZakazi } )
      case npos <> 0        // zrušil rozpad množství
        ARemove( pa_mnoz, npos )
      endcase
    endif

    aeval( pa_mnoz, { |x| ( x[2] := curr_mnozDokl1/ len(pa_mnoz), ;
                            x[3] := curr_mnozPrDod/ len(pa_mnoz), ;
                            x[4] := curr_celkItem / len(pa_mnoz), ;
                            x[5] := curr_celkDokl / len(pa_mnoz)  ) } )
    ::sumColumn()
    ::d_Bro:oxbp:refreshAll()
    setAppFocus(::d_Bro:oxbp)
    return 1

  inline method mark_doklad()
    postAppEvent( xbeP_Keyboard, xbeK_CTRL_ENTER,,::d_bro:oXbp)
    return self

  inline method save_marked()
    postAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self

HIDDEN:
  VAR     in_file, d_Bro, arSelect, pb_mark_doklad, pb_save_marked
  *
  ** tohle získáme z parenta
  var     curr_mnozDokl1, curr_mjDokl1, curr_mnozPrDod, curr_celkItem, curr_celkDokl
  var     is_selAllRec
  **
  *
  var     m_dm, drgGet

  * suma
  inline method sumColumn()
    local  mnozDok1  := mnozPrDod := 0
    local  sumCol
    local  pa_column := { ::d_Bro:getColumn_byName('M->mnozDokl1'), ::d_Bro:getColumn_byName('M->mnozPrDod') }
    local  pa_mnoz   := ::pa_mnozDokl1

    aeval( pa_mnoz, { |x| ( mnozDok1 += x[2], mnozPrDod += x[3] ) })

    for x := 1 to len( pa_column) step 1
      sumCol := pa_column[x]

      sumCol:Footing:hide()
      sumCol:Footing:setCell(1, transForm( if( x = 1, mnozDok1, mnozPrDod), '999999999.9999'))
      sumCol:Footing:show()
    next

    if( mnozDok1 <> 0, ::pb_save_marked:enable(), ::pb_save_marked:disable() )
  return self


  inline method RecordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self
ENDCLASS


method skl_vyrZakit_sel:init(parent)
  local  nEvent := mp1 := mp2 := oXbp := nil
  local  m_dm
  *
  local  chFilter := "ccisZakaz = '%%' .and. (.not. lzavren .or. isnull(lzavren))", cfilter

  ::drgUsrClass:init(parent)

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, nil )

  ::m_dm           := parent:parent:dataManager
  ::curr_mnozDokl1 := ::m_dm:get('pvpitemww->nmnozDokl1')
  ::curr_mjDokl1   := ::m_dm:get('pvpitemww->cmjDokl1'  )
  ::curr_mnozPrDod := ::m_dm:get('pvpitemww->nmnozPrDod')
  ::curr_celkItem  := ::m_dm:get('M->ncelkItem'         )
  ::curr_celkDokl  := ::m_dm:get('M->ncelkDokl'         )

  ::pa_mnozDokl1   := aclone( parent:parent:udcp:pa_mnozDokl1 )
return self


method skl_vyrZakit_sel:getForm()
  local  oDrg, drgFC
  local  cHead := allTrim(vyrZak->ccisZakaz) +' ... ' +allTrim(vyrZak->cnazevZak1) + ;
                  '   množSpotøeby => ' +allTrim( str(::curr_mnozDokl1)) +' ' +::curr_mjDokl1

  local  cFoot := '[ ' +allTrim(cenZboz->ccisSklad) +'/'    ;
                       +allTrim(cenZboz->csklPol)   +' ] _' ;
                       +allTrim(cenZboz->cnazZbo)   +       ;
                       '   k dispozici '            +       ;
                       str(cenZboz->nmnozDZbo)      +       ;
                       ' ' +cenZboz->cZkratJedn

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 87,15.2 DTYPE '10' TITLE 'Výdej na položky zakázky ...' ;
                                             GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 87,13 FILE 'vyrZakitw'     ;
    FIELDS 'M->vyrZakitw_isOk::2.7::2,'                          + ;
           'ccisZakazi:výrÈíslo:20,'                             + ;
           'cnazevZak1:název zakázky:31,'                        + ;
           'M->mnozDokl1:množSpoø:15:999999999.9999,'            + ;
           'M->mnozPrDod:množSpoø_pøep:15:999999999.9999'          ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y' FOOTER 'y'

  DRGTEXT       INTO drgFC CAPTION cFoot CPOS 0,14 CLEN 87 FONT 2 BGND 12 CTYPE 1

  DRGSTATIC INTO drgFC FPOS 0.2,0.1 SIZE 119.6,1.2 STYPE 1 RESIZE 'nn'
    DRGTEXT       INTO drgFC CAPTION cHead CPOS 0,0 CLEN 81 FONT 5 BGND 12 CTYPE 1

    DRGPUSHBUTTON INTO drgFC POS 81,0 SIZE 3,1.1 ATYPE 1                 ;
                  EVENT 'mark_doklad' TIPTEXT 'Oznaè vstupní doklad ...' ;
                  ICON1 MIS_ICON_CHECK ICON2 gMIS_ICON_CHECK

    DRGPUSHBUTTON INTO drgFC POS 84,0 SIZE 3,1.1 ATYPE 1                       ;
                  EVENT 'save_marked' TIPTEXT 'Pøevzít položky do dokladu ...' ;
                  ICON1 MIS_ICON_SAVE_AS ICON2 gMIS_ICON_SAVE_AS

  DRGEND INTO drgFC
return drgFC


method skl_vyrZakit_sel:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.
  drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
return self


method skl_vyrZakit_sel:drgDialogStart( drgDialog )
  local  x, members := drgDialog:oForm:aMembers, odrg
  local  pa_mnoz    := ::pa_mnozDokl1, npos

  ::d_Bro        := drgDialog:dialogCtrl:obrowse[1]
  ::is_selAllRec := ::d_Bro:is_selAllRec := ( len(pa_mnoz) = vyrZakitw->( recCount()) )
  ::arSelect     := ::d_Bro:arSelect

  if .not. ::is_selAllRec
    for x := 1 to len (pa_mnoz) step 1 ; aadd( ::arSelect, pa_mnoz[x,1] ) ;  next
  endif

  for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case  odrg:ClassName() = 'drgPushButton'
      do case
      case odrg:event = 'mark_doklad'    ;  ::pb_mark_doklad := members[x]
      case odrg:event = 'save_marked'    ;  ::pb_save_marked := members[x]
      endcase

    case odrg:ClassName() = 'drgText'
      odrg:oxbp:setcolorbg( GraMakeRGBColor( {196, 196, 255} ))

    endcase
  next

  ::sumColumn()
return self

*
*  class skl_pvpitem_sel   pvpitem
*                          sel - pro storno položky dokladu
********************************************************************************
CLASS SKL_pvpitem_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )

    ::drgUsrClass:init(parent)

    drgDBMS:open( 'pvpitem',,,,,'pvpitem_ss')
  return self

endClass


*
** CLASS for SKL_msDim_pk_SEL ************************************************
** cskladKAM, csklPolKAM        - Pøevod_Kam
*
CLASS SKL_msDim_pk_SEL FROM drgUsrClass
EXPORTED:
  var nazevDIm
  var cisSklad , nazSklad , sklPol   , nazZbo
  var klicSKmis, klicODmis, invCISdim, mnozPRdod

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
    local o_incCISdim

    ::drgUsrClass:init(parent)
    drgDBMS:open( 'c_sklady',,,,, 'c_sklady_p' )

    ::m_udcp        := parent:parent:udcp:hd_udcp
    ::m_dm          := ::m_udcp:dataManager

    ::nazevDIm      := if( parent:cargo <> 0, msDim->cnazevDIm, ::m_dm:get('pvpitemWW->cnazZbo') )

     c_sklady_p->( dbseek( upper( pvpheadW->ccisSklad),,'C_SKLAD1') )
    ::cisSklad      := ::m_dm:get('pvpheadW->ccisSklad'  )
    ::nazSklad      := c_sklady_p->cnazSklad
    ::sklPol        := ::m_dm:get('pvpitemWW->csklPol'   )
    ::nazZbo        := ::m_dm:get('pvpitemWW->cnazZbo'   )

    ::klicSKmis     := ::m_dm:get('pvpitemWW->cklicSKmis' )
    ::klicODmis     := ::m_dm:get('pvpitemWW->cklicODmis' )

    o_invCISdim     := ::m_dm:has('pvpitemWW->ninvCISdim' )
    ::invCISdim     := o_invCISdim:odrg:oxbp:value
    ::mnozPRdod     := ::m_dm:get('pvpitemWW->nmnozPRdod' )

    ::pa_itemsNew   := { { '...->cklicSKmis', ::klicSKmis                      }, ;
                         { '...->cklicODmis', ::klicODmis                      }, ;
                         { '...->ninvCISdim', ::invCISdim                      }, ;
                         { '...->cnazevDim' , cenZboz->cnazZbo                 }, ;
                         { '...->ddatZARdim', date()                           }, ;
                         { '...->ntypDim'   , 1                                }, ;
                         { '...->npocKUSdim', ::mnozPRdod                      }, ;
                         { '...->czkratJedn', cenZboz->czkratJedn              }, ;
                         { '...->ncenJEDdim', cenZboz->ncenaSzbo               }, ;
                         { '...->ncenCELdim', cenZboz->ncenaSzbo * ::mnozPRdod }  }
  return self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oForm:aMembers
    local  x, odrg, groups, name, tipText
    *
    local  acolors  := MIS_COLORS, pa_groups, nin

    ::dm         := drgDialog:dataManager             // dataManager
    ::df         := drgDialog:oForm                   // form

    ::odBro      := ::drgDialog:odBrowse[1]
    ::oxbp_Brow  := ::odBro:oxbp
//    ::o_skladKAM := ::dm:has( 'M->skladKAM' )

    for x := 1 to len(members) step 1
      odrg    := members[x]
      groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
      groups  := allTrim(groups)
      name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
      tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')
      *
      *
      if odrg:className() = 'drgText' .and. .not. empty(groups)
        pa_groups := ListAsArray(groups)

        * XBPSTATIC_TYPE_RAISEDBOX           12
        * XBPSTATIC_TYPE_RECESSEDBOX         13

        if pa_groups[1] = 'SKL_PRE_MAIN'
          ::odrg_SKL_PRE_MAIN := odrg
          odrg:oxbp:disable()
        endif

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
            odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN) // GRA_CLR_BLUE)
          endif
        endif
      endif

      if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
        odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
      endif

      if odrg:className() = 'drgPushButton'
        do case
        case odrg:event = 'skl_msDim_pk_autoNew'  ;  ::obtn_autoNew := odrg
        case odrg:event = 'skl_msDim_pk_editNew'  ;  ::obtn_editNew := odrg
        endcase
      endif
    next

    if drgDialog:cargo <> 0
      msDim->( dbgoTo( drgDialog:cargo ))
      ::is_msDim_kam( .t.)
    else
      msDim->( dbgoTop())
    endif

    ::df:setNextFocus( ::odBro )
  return self


  inline method skl_msDim_pk_autoNew()
    local  pa := aclone(::pa_itemsNew)

//    cenZboz->( dbseek( upper(::cisSklad) +upper(::sklPol),,'CENIK03' ) )
    for x := 1 to len(pa) step 1
      pa[x,1] := strTran( pa[x,1], '...', 'msDimW' )
    next

*    if addRec( 'msDIm' )
    msDimW->( dbappend())
    aeval( pa, { |X,n|  &(pa[n,1]) := pa[n,2] } )

    ::oxbp_Brow:refreshAll()
    postAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
  return .t.


HIDDEN:
  var     m_udcp, m_dm
  var     dc, dm, df, ab, odBro, oxbp_Brow
  var     pa_itemsNew
  var     odrg_SKL_PRE_MAIN
  var     obtn_autoNew, obtn_editNew

  * položka DIMu exituje/ nexituje
  inline method is_msDim_kam(lis_msDim)
    if lis_msDim
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... inventární èíslo DIMu existuje v evidenci na jiném skup/odp místì ...' )
      ::obtn_autoNew:oxbp:disable()
      ::obtn_editNew:oxbp:disable()
    else
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... inventární èíslo DIMu neexistuje v evidenci ...' )
      ::obtn_autoNew:oxbp:enable()
      ::obtn_editNew:oxbp:enable()
    endif
  return self

ENDCLASS