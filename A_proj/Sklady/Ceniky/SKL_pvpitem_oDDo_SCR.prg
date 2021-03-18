#include "adsdbe.ch"
#include "common.ch"
#include "dmlb.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for SKL_pvpitem_oDDo_scr *********************************************

CLASS SKL_pvpitem_oDDo_scr FROM drgUsrClass
EXPORTED:
  var     nastaveni, ddatDO_od, ddatDO_do

  METHOD  Destroy, drgDialogStart, drgDialogEnd, eventHandled
  METHOD  postValidate


**
  inline method createContext()
    local  opopUp, x, apos
    local  pa := { { 'Kompletní seznam pohybù položky', 0 }, ;
                   { 'Pøíjmové pohyby položky'        , 1 }, ;
                   { 'Výdejové pohyby položky'        , 2 }  }

    opopUp := XbpImageMenu( ::drgDialog:dialog ):new()
    opopUp:barText := 'pohyby'
    opopUp:create()

    for x := 1 to len(pa) step 1
      opopup:addItem( {pa[x,1]                       , ;
                       de_BrowseContext(self,x,pA[x]), ;
                                                     , ;
                       XBPMENUBAR_MIA_OWNERDRAW        }, ;
                       if( x = ::popState, 500, 0)     )
    next

     apos     := ::drgPush:oXbp:currentPos()
     apos_parent := ::drgPush:oXbp:parent:currentPos()

     opopup:popup( ::drgPush:oxbp:parent, { apos[1] -30, apos[2] } )
  return self


  inline method fromContext(aorder,p_popUp,apos)
    local  members := ::df:aMembers, pos, oDBro_main := ::oDBro_main
    *
    local  cky   := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)
    local  exAof := "", cfilter := ''

    ::popState := aorder
    ::drgPush:oxbp:setCaption( allTrim( p_popUp[1]))

    if aorder <> 1
      exAof  := format("ntypPvp = %%", {p_popUp[2]})
    endif

    pos := ascan(members,{|X| (x = oDBro_main)})
      ::df:olastdrg   := oDBro_main
      ::df:nlastdrgix := pos
      ::df:olastdrg:setFocus()

    if( empty(pvpItem->( ads_getAof())), nil, pvpItem->(ads_clearAof()) )
    pvpItem->( ordSetFocus( 'PVPITEM28'), dbsetScope(SCOPE_BOTH, cky), dbgotop())

    do case
    case       empty(::caof_pvpitem) .and. empty(exAof)
    case .not. empty(::caof_pvpitem) .and. empty(exAof)
      cfilter := ::caof_pvpitem
    case       empty(::caof_pvpitem) .and. .not. empty(exAof)
      cfilter := exAof
    otherwise
      cfilter := ::caof_pvpitem +" and " +exAof
    endcase

    if .not. empty(cfilter)
      pvpitem->(ads_setAof(cfilter), dbgoTop() )
    endif
    ::sumColumn()
    ::oDBro_main:oxbp:goTop():refreshAll()

  return self


  inline method init(parent)
    ::drgUsrClass:init(parent)
    *
    ::nastaveni  := '0'
    ::ddatDO_od := ctod('  .  .  ')
    ::ddatDo_do := date()

    ::caof_pvpitem      := ''
    ::caof_pvpitem_new  := ''
    ::c_pvpitem_inRange := ''
  return self



  inline method post_drgEvent_Refresh()

*    if ( ::broDOD = ::dc:oaBrowse:oxbp )
*      ::sta_activeBro:oxbp:setCaption( 337 )     // in dodZboz
*    else
*      ::sta_activeBro:oxbp:setCaption( 338 )     // in pvpItem
*    endif
  return self

HIDDEN
* sys
  var     brow, msg, dm, dc, df
  var     sta_activeBro

  var     caof_pvpitem, caof_pvpitem_new, c_pvpitem_inRange
  var     oDBro_main, oget_ddatDO_od, oget_ddatDO_do
  var     drgPush, popState

  METHOD  setFilter

  inline method refresh()
    LOCAL  nIn, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    *
    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  return .t.


  inline method sumColumn()
    local  arDef := ::oDBro_main:arDef
    local  pa    := { { 'nmnozprdod', 0 }, { 'ncenacelk', 0 } }
    *
    local  recNo := pvpItem->( recNo()), x, npos, ocolumn

    pvpItem->( dbeval( { || ( pa[1,2] += pvpItem->nmnozPrDod, ;
                              pa[2,2] += pvpItem->ncenaCelk   ) } ) )
    pvpItem->( dbgoTo( recNo))

    for x := 1 to len(pa) step 1
      if( npos := ascan( arDef, { |ait| pa[x,1] $ lower( ait[2]) })) <> 0

        ocolumn := ::oDBro_main:oxbp:getColumn(npos)
        ocolumn:Footing:Hide()
        ocolumn:Footing:setCell(1, pa[x,2] )
        ocolumn:Footing:show()
      endif
    next
  return .t.

ENDCLASS


method SKL_pvpitem_oDDo_scr:drgDialogStart(drgDialog)
  local  x
  local  aMembers := drgDialog:oForm:aMembers, cevent
  *
  local  cky := upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form

  ::oDBro_main     := drgDialog:dialogCtrl:oBrowse[1]
  ::oget_ddatDO_od := ::dm:has('M->ddatDO_od'):odrg
  ::oget_ddatDO_do := ::dm:has('M->ddatDO_do'):odrg


  for x := 1 TO LEN(aMembers) step 1
    do case
    case aMembers[x]:ClassName() = 'drgStatic'
      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeBro := aMembers[x]
      endif

    case aMembers[x]:ClassName() = "drgPushButton"
      cevent  := isNull(aMembers[x]:event  , '' )
      if( cevent = 'createContext',  ::drgPush := aMembers[x], nil )

    case aMembers[x]:ClassName() = 'drgDBrowse'
      drgDialog:oForm:nextFocus := x

    endcase
  next

  ColorOfTEXT( ::dc:members[1]:aMembers )
  pvpItem->( ordSetFocus( 'PVPITEM28'), dbsetScope(SCOPE_BOTH, cky), dbgotop())

  ::sumColumn()
RETURN


********************************************************************************
METHOD SKL_pvpitem_oDDo_scr:destroy()
  ::drgUsrClass:destroy()
  ::dc := ::dm := NIL
RETURN self


********************************************************************************
METHOD SKL_pvpitem_oDDo_scr:drgDialogEnd(drgDialog)

  pvpItem->( dbclearScope(), ads_clearAof())
RETURN self


method SKL_pvpitem_oDDo_scr:eventHandled(nEvent, mp1, mp2, oXbp)
  local  m_file   := lower(::dc:oaBrowse:cfile)
  local  myEv     := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_DELETE}

/*
  if ascan(myEv,nevent) <> 0
    if m_file = 'pvpitem'
      fin_info_box('Tohle opravdu nejde, pøeètete si prosím nápovìdu ...')
      return .t.
    else
      if cisFirmy = 0  // no DEL - ENTER->INS
        nevent := if( nevent = drgEVENT_EDIT, drgEVENT_APPEND, 0 )
      endif
    endif
  endif


  IF nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC
      IF ::tabNum = 1
        postAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)

      ELSEIF ::tabNum = 2
        postAppEvent(xbeTab_TabActivate,,, ::df:tabPageManager:members[1]:oxbp)
**        ::tabPM:toFront(1)
        IF ::lNewRec
**          IF( IsNull( ::RecNO), nil, DodZBOZ->( dbGoTO(::RecNO )) )
          ::broDOD:refreshCurrent()
        ELSE
          ::broDOD:refreshALL()
        ENDIF
        ::itemMarked()
        ::lnewRec := .F.
        SetAppFocus( ::broDOD)
        ::df:oLastDrg := ::brow[1]

        RETURN .T.
      ENDIF
    ENDIF
  ENDIF
*/

  do case
  case ( nEvent = drgEVENT_APPEND )
  case ( nEvent = drgEVENT_EDIT )
  case ( nEvent = drgEVENT_DELETE )
  case ( nEvent = drgEVENT_SAVE )
  otherWise
     RETURN .F.
   endcase
RETURN .T.


method SKL_pvpitem_oDDo_scr:postVALIDATE(drgVar)
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  lok    := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  if ( name = 'm->ddatdo_od' .or. name = 'm->ddatdo_do' )

    if( name = 'm->ddatdo_od', ::ddatDO_od := value, ::ddatDO_do := value )

    do case
    case(       empty(::ddatDO_od) .and.       empty(::ddatDO_do) )
      ::caof_pvpitem_new  := ''

     case( .not. empty(::ddatDO_od) .and.       empty(::ddatDO_do) )
       ::caof_pvpitem_new  := format( "(ddatPvp >= '%%')", {::ddatDO_od} )

     otherwise
       if( ::ddatDO_od > ::ddatDO_do )
         ::ddatDO_do := ctod('  .  .  ')
         ::oget_ddatDO_do:ovar:set(::ddatDO_od )
       else
         ::caof_pvpitem_new := format( "(ddatPvp >= '%%' and ddatPvp <= '%%')", {::ddatDO_od, ::ddatDO_do} )
       endif
     endcase

     if ( name = 'm->ddatdo_do' )
       if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

         if ::caof_pvpitem <> ::caof_pvpitem_new
           ::caof_pvpitem := ::caof_pvpitem_new

//           pvpitem->(ads_setAof(::caof_pvpitem), dbgoTop() )
         endif

//         ::oDBro_main:oxbp:refreshAll()
       endif
     endif

   endif
return lok




** HIDDEN **********************************************************************
METHOD SKL_pvpitem_oDDo_scr:setFilter( cAlias)
  Local  Filter, cFilter, aFilter, aRec := {}, nCount := 0
  local  isdat_ok := .f.
  *
  local  cky := upper(cenZboz->ccisSklad)     + ;
                upper(cenZboz->csklPol)

  IF cAlias = 'PVPITEM'
    if( empty(pvpItem->( ads_getAof())), nil, pvpItem->(ads_clearAof()) )

    pvpItem->( ordSetFocus( 'PVPITEM28'), dbsetScope(SCOPE_BOTH, cky), dbgotop())

    if .not. pvpItem->( eof())
      if .not. empty( ::dprijemOD) .and. ( ::dprijemOD <= ::dprijemDO )
        cfilter  := "ddatPvp >= '%%' .and. ddatPvp <= '%%'"
         filter  := format( cFilter, { dtos(::dPrijemOd), dtos(::dPrijemDo) } )
        pvpItem->(ads_setAof( filter), dbgoTop() )
      endif
    endif
  endif

RETURN .T.