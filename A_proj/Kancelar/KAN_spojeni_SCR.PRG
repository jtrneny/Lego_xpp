#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  SPOJENI
** CLASS KAN_spojeni_SCR *******************************************************
CLASS KAN_spojeni_SCR FROM drgUsrClass, OSB_osoby_IN
EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart
  METHOD  tabSelect

HIDDEN:

  VAR vazFILE, tabNum

ENDCLASS


METHOD KAN_spojeni_SCR:init(parent)

  ::drgUsrClass:init(parent)
  ::tabNum  := 1

  ::vazFILE := {{'VAZOSOBY','OSOBY'},{'VAZFIRMY','FIRMY'}}


  drgDBMS:open('osoby'   )
  drgDBMS:open('msPrc_mo')
  *
  drgDBMS:open('vazSpoje')
RETURN self


METHOD KAN_spojeni_SCR:drgDialogStart()
//  PostAppEvent(drgEVENT_MSG,,drgEVENT_SAVE, ::drgDialog:dialog)
RETURN self


METHOD KAN_spojeni_SCR:tabSelect(oTabPage,tabnum)
  ::tabNum := tabnum
  ::itemMarked()
RETURN .T.


METHOD KAN_spojeni_SCR:itemMarked()
  local  cf := "SPOJENI = %%", filtrs

  filtrs := format( cf, { isNull( spojeni->sID,0) })
  vazSpoje->( ads_setAof( filtrs ), dbgoTop() )

  * relFor txt
*  c_psc   ->(dbseek( osoby->cpsc      ,, 'C_PSC1'  ))
*  c_staty ->(dbseek( osoby->czkratStat,, 'C_STATY1'))
RETURN SELF

*
** CLASS KAN_spojeni_SEL *******************************************************
CLASS KAN_spojeni_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
    *
    local   olastDrg

    ::pa_vazRecs := {}

    drgDBMS:open('spojeni')

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

    if isObject( parent:parent )
      if isObject( parent:parent:oForm )
        if isObject( olastDrg := parent:parent:oForm:olastDrg )
          if lower( olastDrg:className()) = 'drgget'
            if( isNull(::drgGet), ::drgGet := olastDrg, nil )

            if len(pa_initParam := listAsArray(parent:initParam)) = 2
              ::pa_vazRecs := pa := parent:parent:UDCP:pa_vazRecs[ val( pa_initParam[2] ) ]

*              if .not. empty( pa )
*                spojeni->( ads_setAof('.T.'))
*                spojeni->( ads_customizeAOF( pa, 3))
*              endif

            endif
          endif
        endif
      endif
    endif

    if( isObject(::drgGet), ::drgGet:cargoGet := nil, nil )
    ::lsearch   := (::drgGet <> NIL)
    ::tabNumber := 1

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  RETURN self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oActionBar:members
    local  aPP     := drgPP:getPP(2), oColumn, x
    local  pa_quick := { ;
    { 'Kompletní seznam                  ', ''            } }

    ::brow    := drgDialog:dialogCtrl:oBrowse[1]
    ::msg     := drgDialog:oMessageBar             // messageBar
    ::dm      := drgDialog:dataManager             // dataMabanager
    ::dc      := drgDialog:dialogCtrl              // dataCtrl
    ::df      := drgDialog:oForm                   // form
    if isobject(drgDialog:oActionBar)
      ::ab      := drgDialog:oActionBar:members    // actionBar
    endif

    if ::lsearch
      for x := 1 TO ::brow:oXbp:colcount
        ocolumn := ::brow:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      next
    endif

    for x := 1 to len(members) step 1
      if( members[x]:event = 'kan_spojeni_new'   , ::act_new    := members[x], nil)
      if( members[x]:event = 'kan_spojeni_modify', ::act_modify := members[x], nil)
    next

    drgDBMS:open('c_typSpo')
    c_typSpo->(dbgotop())

    do while .not. c_typSpo->( eof())
      x := { left( c_typSpo->cnazTyp, 30)                   , ;
             format( "ctypSpoj = '%%'", {c_typSpo->ctypSpoj}) }

      aadd( pa_quick, x )
      c_typSpo->(dbskip())
    enddo

    ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Spojeni', ::pa_vazRecs, 2 )
    return self


  inline method onLoad( isApend )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = xbeP_Keyboard
      do case
      case( mp1 = xbeK_ALT_N )  ;  ::act_firmy_nova:activate()
      case( mp1 = xbeK_ALT_O )  ;  ::act_firmy_oprava:activate()
      otherWise
        RETURN .F.
      endcase

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        ::drgGet:ovar:set(spojeni->ncisSpoj)
        ::drgGet:cargoGet := isNull( spojeni->sID, 0)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
    endcase
  return .f.


  inline method kan_spojeni_new(drgDialog)
    local  oDialog, nExit
    *
    local  pa := ::pa_vazRecs

    DRGDIALOG FORM 'KAN_SPOJENI_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    if .not. empty(pa)
      spojeni->( ads_setAof('.T.'))
      spojeni->( ads_customizeAOF( pa, 3))
    endif

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
    ::dm:refresh()
  return .t.


  inline method kan_spojeni_modify(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'KAN_SPOJENI_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
    ::dm:refresh()
  return .t.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber, pa_vazRecs
  var    act_new, act_modify
ENDCLASS