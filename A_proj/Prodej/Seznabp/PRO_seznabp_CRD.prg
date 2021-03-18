#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



//-----+ ODB_seznabp_CRD +------------------------------------------------------
CLASS ODB_seznabp_CRD FROM drgUsrClass
EXPORTED:

  METHOD  init
  METHOD  itemMarked

  METHOD  ComboBoxInit
  METHOD  ComboItemSelected
ENDCLASS


METHOD ODB_seznabp_CRD:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('ODB_SEZNABP')
  drgDBMS:open('ODB_POLNABP')
  drgDBMS:open('FIR_FIRMY')
  ODB_SEZNABP ->( DbSetRelation('FIR_FIRMY', { || ODB_SEZNABP ->nCISFIRMY }))

  ::itemMarked()
RETURN self


METHOD ODB_seznabp_CRD:itemMarked()
  Local  cKy_pol
**  Local  dc      := ::drgDialog:dialogCtrl

**  ODB_SEZNABP ->( AdsSetOrder(1), dbSetScope(SCOPE_BOTH, STRZERO(FIR_FIRMY ->nCISFIRMY)),dbGOTOP())
  cKy_pol := STRZERO(ODB_SEZNABP ->nCISFIRMY) +STRZERO(ODB_SEZNABP ->nCISNAB)
  ODB_POLNABP ->( AdsSetOrder(6), dbSetScope(SCOPE_BOTH, cKY_pol), dbGOTOP())
RETURN SELF


METHOD ODB_seznabp_CRD:ComboBoxInit(drgComboBox)
  Local aFIRMy := {}

  FIR_FIRMY ->(DbEval( { || AAdd(aFIRMy, { FIR_FIRMY->nCISFIRMY, FIR_FIRMY->cNAZEV }) } ))

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( aFIRMy,,, {|aX,aY| aX[2] < aY[2] } )
  AEVAL(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
RETURN SELF


METHOD ODB_seznabp_CRD:ComboItemSelected(mp1, mp2, o)
  Local nCISfirmy := mp1:value

  ODB_SEZNABP ->( AdsSetOrder(1), ;
                  DbSetScope(SCOPE_BOTH, STRZERO(nCISFIRMY)),dbGOTOP())

  PostAppEvent(drgEVENT_REFRESH,,,mp1:oXbp)
RETURN .T.
