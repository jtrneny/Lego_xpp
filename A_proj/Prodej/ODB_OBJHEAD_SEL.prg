********************************************************************************
*
* ODB_OBJHEAD_SEL.PRG    .... Do ODBYTU
*
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


********************************************************************************
* ODB_OBJHEAD_SEL ...
********************************************************************************
CLASS ODB_OBJHEAD_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  EventHandled
  METHOD  ItemMarked
  METHOD  RecordSelected
  METHOD  RecordEdit
ENDCLASS

*
********************************************************************************
METHOD ODB_OBJHEAD_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('OBJITEM')
  drgDBMS:open('OBJHEAD')
  ::itemMarked()
RETURN self

*
********************************************************************************
METHOD ODB_OBJHEAD_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::recordSelected()

  CASE nEvent = drgEVENT_APPEND
*    ::recordEdit()

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

*
********************************************************************************
METHOD ODB_OBJHEAD_SEL:ItemMarked()
  LOCAL cScope := StrZero( ObjHEAD->nCisFirmy, 5) + Upper( ObjHead->cCislObInt)

  ObjItem ->( dbSetScope(SCOPE_BOTH, cScope), dbGOTOP())
RETURN SELF

*
********************************************************************************
METHOD ODB_OBJHEAD_SEL:RecordSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN SELF

*
********************************************************************************
METHOD ODB_OBJHEAD_SEL:RecordEdit()
*  DRGDIALOG FORM 'SKL_CENZBOZ_SCR' PARENT ::drgDialog DESTROY
RETURN self