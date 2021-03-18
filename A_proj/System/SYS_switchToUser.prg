#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

#include "..\A_main\ace.ch"



//  ------------------------ výbìr uživatele pro pøihlášení ----------------
CLASS SYS_switchToUser FROM drgUsrClass
EXPORTED:

  VAR arrUSER

  METHOD  getForm
  METHOD  init
  METHOD  drgDialogInit
//  METHOD  eventHandled

  METHOD  destroy             // release all resources used by this object

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    usrName     := allTrim(users->cuser     )
    usrOsoba    := allTrim(users->cosoba    )
    logUser     := allTrim(users->cPrihlJmen)
    logOsoba    := allTrim(users->cOsoba    )
    logCisOsoby := Users->nCisOsoby
    syOpravneni := allTrim(users->copravneni)

    if lower(usrName) = 'admin'
      ( isWorkVersion := .t., isRestFRM := .f. )
    else
      ( isWorkVersion := .f., isRestFRM := .t. )
    endif
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

//  CASE nEvent = drgEVENT_APPEND
//  CASE nEvent = drgEVENT_FORMDRAWN
//     Return .T.

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

HIDDEN:
  VAR  drgGet

ENDCLASS


****************************************************************************
* Returns form definition for drgLogin UDCP.
****************************************************************************
METHOD SYS_switchToUser:getForm()
LOCAL drgFC, oDrg
  drgFC  := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 57,12 TITLE 'Select' GUILOOK 'All:N,Border:Y'

  DRGTEXT INTO drgFC CAPTION 'Výbìr uživatele' FONT 5 CPOS 2,0.10 BGND(1)
  DRGDBROWSE INTO drgFC FPOS .5,1.2 SIZE 56,10.7 FILE 'users' ;
    FIELDS 'cPrihlJmen:Uživatel:30,' + ;
           'cuser:zkr,'              + ;
           'copravneni:opravneni'      ;
    SCROLL 'ny' CURSORMODE 3 PP 9 POPUPMENU 'y'

  DRGPUSHBUTTON INTO drgFC EVENT 140000002 SIZE 3,1 POS 53.5,0 ;
    ICON1 102 ICON2 202 ATYPE 1 TIPTEXT 'Ukonèi dialog'

RETURN drgFC


METHOD SYS_switchToUser:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
*  IF IsOBJECT(oXbp:cargo)
*    ::drgGet := oXbp:cargo
*  ENDIF

  ::drgUsrClass:init(parent)
RETURN self


METHOD SYS_switchToUser:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  drgDialog:hasIconArea := drgDialog:hasActionArea := ;
  drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
  XbpDialog:titleBar    := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN


****************************************************************************
* CleanUp
****************************************************************************
METHOD SYS_switchToUser:destroy()
  ::drgUsrClass:destroy()
RETURN NIL

