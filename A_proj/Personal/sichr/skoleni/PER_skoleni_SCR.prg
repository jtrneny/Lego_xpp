#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


#include "..\Asystem++\Asystem++.ch"

*  SKOLENI
** CLASS PER_skoleni_SCR *******************************************************
CLASS PER_skoleni_SCR FROM drgUsrClass, OSB_osoby_IN
EXPORTED:
  METHOD  init, itemMarked, drgDialogStart

ENDCLASS


METHOD PER_skoleni_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('SKOLENI' )
  drgDBMS:open('C_SKOLEN')
  drgDBMS:open('C_SKOLUK')

  drgDBMS:open('vazSkol' )
  drgDBMS:open('osoby'   )
  drgDBMS:open('msPrc_mo')

  SKOLENI->( DbSetRelation( 'C_SKOLEN',  { || UPPER(SKOLENI->cZkratka)},  'UPPER(SKOLENI->cZkratka)'))
  SKOLENI->( DbSetRelation( 'C_SKOLUK',  { || UPPER(SKOLENI->cZkratkaUk)},  'UPPER(SKOLENI->cZkratkaUk)'))
RETURN self


METHOD PER_skoleni_SCR:drgDialogStart(drgDialog)
RETURN self


method PER_skoleni_SCR:itemMarked()
  local  cf := "vazSkol->SKOLENI = %%", filtrs

  filtrs := format( cf, { isNull( skoleni->sID, 0) })
  vazSkol ->(ads_setAof( filtrs ), dbgoTop())
RETURN SELF

*
** CLASS PER_skoleni_SEL *******************************************************
CLASS PER_skoleni_SEL FROM drgUsrClass
EXPORTED:

  inline access assign method nazev_Skoleni() var nazev_Skoleni
    c_skolen->(dbseek( upper(skoleni->czkratka),,'C_SKOLEN01'))
    return c_skolen->cnazev

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

    ::lsearch   := (::drgGet <> NIL)
    ::tabNumber := 1

    drgDBMS:open('c_skolen')
    drgDBMS:open('c_SkolUk')

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  RETURN self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oActionBar:members
    local  aPP     := drgPP:getPP(2), oColumn, x

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
      if( members[x]:event = 'per_skoleni_new'   , ::act_new    := members[x], nil)
      if( members[x]:event = 'per_skoleni_modify', ::act_modify := members[x], nil)
    next

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


  inline method per_skoleni_new(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'PER_SKOLENI_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method per_skoleni_modify(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'PER_SKOLENI_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber
  var    act_new, act_modify
ENDCLASS