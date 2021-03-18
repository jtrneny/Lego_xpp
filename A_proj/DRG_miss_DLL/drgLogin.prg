//////////////////////////////////////////////////////////////////////
//
//  drgLogin.PRG
//
//  Copyright:
//       Yedro d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Login drgDialog.
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"

CLASS drgLogin FROM drgUsrClass

EXPORTED:
  VAR     usrName
  VAR     usrPswd
  VAR     usrPgm

  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  checkPassword

  METHOD  destroy             // release all resources used by this object
ENDCLASS

****************************************************************************
* Returns form definition for drgLogin UDCP.
****************************************************************************
METHOD drgLogin:getForm()
LOCAL drgFC, oDrg, cParm
  drgFC  := drgFormContainer():new()
* Get password checking routine and default username
  cParm  := drgParseSecond(::drgDialog:initParam)
  ::usrPgm  := drgParse(@cParm)
  ::usrName := drgParse(@cParm)
  ::usrPswd := ''
* If you wonder why using drgNLS. Default behaviour is to translate messages through
* application program message file. Thus translation will be done through DRG system messages
  DRGFORM INTO drgFC SIZE 26,5 DTYPE '0' TITLE drgNLS:msg('Login');
    GUILOOK 'ALL:N' BORDER(3)

  DRGGET usrName INTO drgFC FPOS 15,1 FLEN 8 FCAPTION drgNLS:msg('Username') CPOS 1,1
  DRGGET usrPswd INTO drgFC FPOS 15,2 FLEN 8 FCAPTION drgNLS:msg('Password') CPOS 1,2

  DRGPUSHBUTTON INTO drgFC CAPTION drgNLS:msg('O~K') EVENT 'checkPassword' PRE '0' SIZE 12,1 POS 1,4 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION drgNLS:msg('~Cancel') EVENT drgEVENT_QUIT PRE '0' SIZE 12,1 POS 13,4 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

**********************************************************************
* Called just before dialog has been displayed. Set password field to \
* unreadable so password would not be seen.
**********************************************************************
METHOD drgLogin:drgDialogStart()
LOCAL oSle
* This looks little silly, but it is the beauty of OOP.
* Memory manager returns field var for usrPswd, which holds pointer to oDrg
* (drgGet in our case) which holds pointer to oXbp (xbpGet) which returns
* reference to internal xbpSLE object. oSLE now points to xbpSLE object.
  oSle := ::dataManager:get('usrpswd', .F.):oDrg:oXbp:xbpSle
* Set sle to unreadable and reconfigure it
  oSle:unReadable   := .T.
  oSle:configure()
RETURN self

**********************************************************************
* Method called by pushButton OK Action. Check for presence of user defined \
* program for checking password.
**********************************************************************
METHOD drgLogin:checkPassword()
LOCAL oPgm, lOk := .T.
  ::dataManager:save()
* Call UDP function to check password
  IF (oPgm := ::drgDialog:getMethod(::usrPgm) ) != NIL
    lOk := EVAL(oPgm, ::usrName, ::usrPswd)
  ENDIF
* IF OK post close dialog event and set drgEVENT_EXIT as dialog close event
  IF lOK
    PostAppEvent(xbeP_Close,drgEVENT_EXIT,,::drgDialog:dialog)
* otherwise post error
   ELSE
    ::usrPswd := ''
    ::dataManager:refresh()
    ::drgDialog:oForm:setNextFocus(1,,.T.)
    drgMsgBox(drgNLS:msg('Invalid password entered!'),XBPMB_CRITICAL )
  ENDIF

RETURN self

****************************************************************************
* CleanUp
****************************************************************************
METHOD drgLogin:destroy()
  ::drgUsrClass:destroy()
  ::usrName := ;
  ::usrPswd := ;
  ::usrPgm  := ;
               NIL
RETURN


