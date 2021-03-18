#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


function uct_ucetpol_all_(column)
  local  xretVal := ''

  ucetsys->(dbseek('U' +upper(ucetpol->cobdobi),,'UCETSYS2'))

  do case
  case(column = 'uzav')  ;  xretVal := if(ucetsys->lzavren      ,U_big   ,0)
  case(column = 'aktu')  ;  xretVal := if(ucetsys->naktuc_ks = 2,MIS_BOOK,0)
  case(column = 'obdo')  ;  xretVal := str(ucetpol->nobdobi,2) +'/' +str(ucetpol->nrok,4)
  endcase
return xretVal


*
** CLASS for UCT_ucetpol_deniky_SCR ********************************************
CLASS UCT_ucetpol_deniky_SCR FROM drgUsrClass
EXPORTED:
  VAR     cDENIK

  METHOD  Init
  METHOD  comboItemSelected
  METHOD  itemSelected

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetpol_deniky_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOL')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('UCETSYS')

  // relace //
//  UCETPOLA ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPOLA->CUCETMD) }))
RETURN self


METHOD UCT_ucetpol_deniky_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetpol_deniky_SCR:itemSelected()
/*
  Local  nRECs  := UCETPOLA ->(RECNO())
  Local  nORDs  := UCETPOLA ->(OrdSetFocus())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'UCT_ucetpola_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  UCETPOLA ->(OrdSetFocus(nORDs), DBGoTo(nRECs))
*/
Return self



function uct_c_uctosn_all_(column)
  local  ok := DBGetVal('c_uctosn->l' +column)

return if(ok, MIS_ICON_OK, 0)


*
** CLASS for UCT_ucetpol_karty_SCR ********************************************
CLASS UCT_ucetpol_karty_SCR FROM drgUsrClass
EXPORTED:
  var     cDENIK
  method  init, comboItemSelected, itemMarked

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
*-      ::itemSelected()
    CASE nEvent = drgEVENT_DELETE
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS


METHOD UCT_ucetpol_karty_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::cDENIK := 'A'

  drgDBMS:open('UCETPOL')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('UCETSYS')

  // relace //
//  UCETPOLA ->( DbSetRelation( 'C_UCTOSN', { || UPPER(UCETPOLA->CUCETMD) }))
RETURN self


METHOD UCT_ucetpol_karty_SCR:comboItemSelected(mp1, mp2, o)
  LOCAL  dc     := ::drgDialog:dialogCtrl

  IF ::cDENIK <> mp1:value
    UCETPOLA ->( Ads_SetAof("cDENIK = '" +mp1:value +"'"), ;
                 dbGoTop()                                   )

    dc:oaBrowse:refresh(.T.)
    SetAppFocus(dc:oaBrowse:oXbp)
  ENDIF
RETURN .T.


METHOD UCT_ucetpol_karty_SCR:itemMarked()
  local  ky := upper(c_uctosn->cucet)

  ucetpol->(ordSetFocus('UCETPO08'),dbSetScope(SCOPE_BOTH,ky), dbGoTop())
Return self