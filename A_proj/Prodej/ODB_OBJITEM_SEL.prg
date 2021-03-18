********************************************************************************
*
* ODB_OBJITEM_SEL.PRG    .... Do ODBYTU
*
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


********************************************************************************
* ODB_OBJITEM_SEL ...
********************************************************************************
CLASS ODB_OBJITEM_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogStart
  METHOD  EventHandled
  METHOD  RecordSelected
  METHOD  RecordEdit
ENDCLASS

*
********************************************************************************
METHOD ODB_OBJITEM_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('OBJITEM')
RETURN self

*
*****************************************************************
METHOD ODB_OBJITEM_SEL:drgDialogStart(drgDialog)
  IF IsNumber(drgDialog:cargo) .and. drgDialog:cargo <> 0
    ObjItem->( dbGoTO( drgDialog:cargo))
    drgDialog:dialogCtrl:oBrowse[1]:refresh()
  EndIf
RETURN self

*
********************************************************************************
METHOD ODB_OBJITEM_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
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
METHOD ODB_OBJITEM_SEL:RecordSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN SELF

*
********************************************************************************
METHOD ODB_OBJITEM_SEL:RecordEdit()
*  DRGDIALOG FORM 'SKL_CENZBOZ_SCR' PARENT ::drgDialog DESTROY
RETURN self