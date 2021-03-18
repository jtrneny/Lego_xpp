#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

#include "DRGres.ch'
#include "XBP.ch"
#include "Gra.ch"
#include "adsdbe.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_MListIT_vyk FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy, drgDialogStart, drgDialogEnd, EventHandled
  METHOD  PostValidate
HIDDEN
  VAR     dm, dc
ENDCLASS

********************************************************************************
METHOD VYR_MListIT_vyk:Init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VyrZAK')
  drgDBMS:open('LISTITw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  LISTITw->( dbAppend())
*     ListITw->nPorCisLis :=
*     ListITw->nRokVytvor :=
     LISTITw->nKusyCelk  := 1
      /*
     oDlg:cTypML := IF( IsNil( oDlg:cTypML) .OR. oDlg:nCisML <> ListHD->nPorCisLis,;
                     ListIT->cTypListku, ::cTypML)
     oDlg:nDrMZD := IF( IsNil( oDlg:nDrMZD) .OR. oDlg:nCisML <> ListHD->nPorCisLis,;
                     ListIT->nDruhMzdy, oDlg:nDrMZD)
     LISTITw->cTypListku := oDlg:cTypML
     LISTITw->nDruhMzdy  := oDlg:nDrMZD

     IF IsNIL( oDlg:dVyhotML)
//       oDlg:dVyhotML := CTOD( '01.' + LEFT( cObdForML, 2) + '.'+ RIGHT( cObdForML, 2) )
       oDlg:dVyhotML := CTOD( '01.' + StrZero( uctObdobi:VYR:nOBDOBI, 2) + '.'+ StrZero(uctObdobi:VYR:nROK, 4) )
     ENDIF
     LISTITw->dVyhotSkut := oDlg:dVyhotML
     LISTITw->nTydKapBlo := mh_WEEKofYear( DATE())
     */
     LISTITw->cStavListk := '1'

RETURN self

********************************************************************************
METHOD VYR_MListIT_vyk:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD  VYR_MListIT_vyk:drgDialogEnd(drgDialog)
RETURN

********************************************************************************
METHOD VYR_MListIT_vyk:eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_DELETE
*    CASE nEvent = drgEVENT_EDIT
    OTHERWISE
      RETURN .F.
    ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_MListIT_vyk:PostValidate(oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)
  *
  DO CASE
  CASE cName = 'ListITw->nOsCisPrac'
    IF xVar = 0
      PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
    ENDIF

  CASE ( Name = 'ListITw->nKusyCelk' )

  ENDCASE
  *
RETURN  lOK

********************************************************************************
METHOD VYR_MListIT_vyk:destroy()
  ::drgUsrClass:destroy()
  *
RETURN self