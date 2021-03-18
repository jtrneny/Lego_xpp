/*==============================================================================
  VYR_CMAJ_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* Majetek v evidenci
********************************************************************************
CLASS VYR_CMAJ_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled
ENDCLASS

*
********************************************************************************
METHOD VYR_CMAJ_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
*****************************************************************
METHOD VYR_CMAJ_SCR:drgDialogStart(drgDialog)
RETURN self

*
********************************************************************************
METHOD VYR_CMAJ_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_APPEND
      *  Insert není povolen
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

********************************************************************************
* Karta investièního majetku
********************************************************************************
CLASS VYR_CMAJ_crd FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart
HIDDEN
VAR       dm

ENDCLASS

*
********************************************************************************
METHOD VYR_CMAJ_crd:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
********************************************************************************
METHOD VYR_CMAJ_CRD:drgDialogStart(drgDialog)
  LOCAL InvCis, InvCisDIM

  ::dm      := drgDialog:dataManager
  *
  InvCis    := ::dm:has( 'C_MAJ->nInvCis')
  InvCisDIM := ::dm:has( 'C_MAJ->nInvCisDIM')
  IF C_MAJ->cDruhMaj = 'I '    // HIM
    InvCis:oDrg:oXbp:show()
    InvCisDim:oDrg:oXbp:hide()
  ELSE                         // DIM
    InvCis:oDrg:oXbp:hide()
    InvCisDim:oDrg:oXbp:show()
  ENDIF

RETURN self

*****************************************************************
* VYR_CMAJ_SEL ... Výbìr z èíselníku majetkù
*****************************************************************
CLASS VYR_CMAJ_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  getForm

HIDDEN:
  VAR  drgGet
ENDCLASS

*
*****************************************************************
METHOD VYR_CMAJ_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
RETURN self

*
**********************************************************************
METHOD VYR_CMAJ_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
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
METHOD VYR_CMAJ_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .T.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

*
********************************************************************************
METHOD VYR_CMAJ_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    drgDialog:dialogCtrl:browseRefresh()
  ENDIF
RETURN self

*
********************************************************************************
METHOD VYR_CMAJ_SEL:getForm()
  LOCAL oDrg, drgFC, cDruhMaj:= ALLTRIM( ::drgDialog:cargo)
  LOCAL cTitle := IF( cDruhMaj = 'I', 'IMu', 'DIMu' )

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75, 12 DTYPE '10' TITLE 'Seznam ' + cTitle + ' - VÝBÌR' ;
                                           FILE 'C_MAJ'                   ;
                                           GUILOOK 'All:N,Border:Y'

  IF cDruhMaj = 'I'
    DRGBROWSE INTO drgFC SIZE 75,11.8 ;
                         FIELDS 'nInvCis, cNazevMaj, cDruhMaj, cVyrCisIM'  ;
                         INDEXORD 4 SCROLL 'ny' CURSORMODE 3 PP 7
  ELSE
    DRGBROWSE INTO drgFC SIZE 75,11.8 ;
                         FIELDS 'nInvCisDIM, cNazevMaj, cDruhMaj, cVyrCisIM'  ;
                         INDEXORD 5 SCROLL 'ny' CURSORMODE 3 PP 7
  ENDIF
RETURN drgFC