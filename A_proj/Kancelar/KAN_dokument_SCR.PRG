#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  DOKUMENT
** CLASS KAN_dokument_SCR ******************************************************
CLASS KAN_dokument_SCR FROM drgUsrClass, OSB_osoby_IN

EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart

ENDCLASS


METHOD KAN_dokument_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('osoby'   )
  drgDBMS:open('msPrc_mo')
  *
  drgDBMS:open('vazDokum')
RETURN self


method KAN_dokument_SCR:drgDialogStart()
return self


METHOD KAN_dokument_SCR:itemMarked()
  local  cf := "DOKUMENT = %%", filtrs

  filtrs := format( cf, { isNull( dokument->sID, 0) })
  vazDokum->( ads_setAof( filtrs ), dbgoTop())

  * relFor txt
*  c_psc   ->(dbseek( osoby->cpsc      ,, 'C_PSC1'  ))
*  c_staty ->(dbseek( osoby->czkratStat,, 'C_STATY1'))
RETURN SELF


*
** CLASS KAN_dolumen_SEL *******************************************************
CLASS KAN_dokument_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

    ::lsearch   := (::drgGet <> NIL)
    ::tabNumber := 1
    ::pa_vazRecs := {}

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
      if( members[x]:event = 'kan_dokument_new'   , ::act_new    := members[x], nil)
      if( members[x]:event = 'kan_dolument_modify', ::act_modify := members[x], nil)
    next

    drgDBMS:open('c_typDkm')
    c_typDkm->(dbgotop())

    do while .not. c_typDkm->( eof())
      x := { left( c_typDkm->cnazTyp, 30)                       , ;
             format( "ctypDokum = '%%'", {c_typDokum->ctypUkolu}) }

      aadd( pa_quick, x )
      c_typDkm->(dbskip())
    enddo

    ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Dokumenty', ::pa_vazRecs, 2 )
    return self


  inline method onLoad( isApend )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = xbeP_Keyboard
      do case
      case( mp1 = xbeK_ALT_N )  ;  ::act_new:activate()
      case( mp1 = xbeK_ALT_O )  ;  ::act_modify:activate()
      otherWise
        RETURN .F.
      endcase

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
    endcase
  return .f.


  inline method kan_dokument_new(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'SYS_DOKUMENT_IN' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method kan_dokument_modify(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'SYS_DOKUMENT_IN' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber, pa_vazRecs
  var    act_new, act_modify
ENDCLASS