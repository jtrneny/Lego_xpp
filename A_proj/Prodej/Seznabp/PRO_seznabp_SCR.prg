#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



//-----+ ODB_seznabp_SCR +------------------------------------------------------
CLASS ODB_seznabp_SCR FROM drgUsrClass          // dle Nabídek
EXPORTED:

  METHOD  itemMarked
ENDCLASS


METHOD ODB_seznabp_SCR:itemMarked()
  Local  cKy_pol
  Local  dc      := ::drgDialog:dialogCtrl

  cKy_pol := STRZERO(SEZNABP ->nCISFIRMY) +STRZERO(SEZNABP ->nCISNAB)
  POLNABP ->( AdsSetOrder(6), dbSetScope(SCOPE_BOTH, cKY_pol) ,dbGOTOP())
RETURN SELF



// tohle øízení podel Jožky bude na CENZBOZ
CLASS ODB_seznabpZ_SCR FROM drgUsrClass          // dle Zboží
EXPORTED:

  METHOD  init
ENDCLASS


METHOD ODB_seznabpZ_SCR:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('POLNABP')
  drgDBMS:open('FIRMY')
  FIRMY ->(DbSetRelation( 'POLNABP', { || POLNABP ->nCISFIRMY }))
RETURN self


// tohle øízení podel Jožky bude na FIRMY
CLASS ODB_seznabpF_SCR FROM drgUsrClass          // dle Firem
EXPORTED:

  METHOD  itemMarked
ENDCLASS


METHOD ODB_seznabpF_SCR:itemMarked()
  Local  cKy_pol
  Local  dc      := ::drgDialog:dialogCtrl

  SEZNABP ->( AdsSetOrder(1), dbSetScope(SCOPE_BOTH, STRZERO(FIRMY ->nCISFIRMY)),dbGOTOP())
  cKy_pol := STRZERO(SEZNABP ->nCISFIRMY) +STRZERO(SEZNABP ->nCISNAB)
  POLNABP ->( AdsSetOrder(6), dbSetScope(SCOPE_BOTH, cKY_pol), dbGOTOP())
RETURN SELF



FUNCTION firmy_DLG()
  Local  drgDialog
  Local  nEvent, mp1, mp2, oXbp

  nEvent := AppEvent(@mp1,@mp2,@oXbp)
  drgDialog := mp1:parent:drgDialog

  drgDialog:pushArea()
    DRGDIALOG FORM 'ODB_firmy_DLG' PARENT drgDialog MODAL
  drgDialog:popArea()
RETURN NIL
