#include "Common.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "drg.ch"
#include "drgRes.ch"



CLASS AsystemLogin FROM drgUsrClass
EXPORTED:
  VAR     usrFirma
  VAR     usrName
  VAR     usrPswd
  VAR     usrPgm
  VAR     isUSERs
  VAR     selUSERs

  METHOD  init
  METHOD  getForm
  METHOD  drgDialogInit, drgDialogStart
  METHOD  checkPassword
  METHOD  selLicFirma
  METHOD  iniUsers
  METHOD  selUser
  METHOD  postValidate

  METHOD  destroy             // release all resources used by this object

  method  in_dir, out_dir

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  new_val

    if isobject(::opsw)
      if ::opsw:odrg:oXbp:xbpSle:changed
        new_val := alltrim(::opsw:odrg:oXbp:xbpSle:getdata())
        ::opsw:set(new_val)
      endif
    endif
    return .f.

hidden:
  var     opsw

ENDCLASS


METHOD AsystemLogin:init(parent)
  ::selUSERs := {'','','','',''}
  ::drgUsrClass:init(parent)
/*
  LicAsys->(dbGoTop())
  if .not. Empty(logFirma) .and. .not. Empty(logUser)
    if .not. LicAsys->(DbLocate( {|| AllTrim( LicAsys->cNazFirPri) == Alltrim( logFirma)}))
      LicAsys->(dbGoTop())
    endif
  endif
*/
  ::usrFirma := 'moje'  // LicAsys->cNazFirPri
  logFirma   := 'moje'  // AllTrim(LicAsys->cNazFirPri)
  recFirma   :=  1      // LicAsys->( Recno())
  usrIdSW    :=  101     // LicAsys->NIDUZIVSW
  usrIdDB    :=   102   // LicAsys->nUsrIdDB

*  drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
*  ::isUsers := ::iniUsers()
RETURN self


****************************************************************************
* Returns form definition for drgLogin UDCP.
****************************************************************************
METHOD AsystemLogin:getForm()
LOCAL drgFC, oDrg, cParm

  LOCAL nEvent, mp1 := NIL, mp2 := NIL, oXbp, lExit, aPos, aWinPos
  LOCAL oDlg, oID, oPW, drawingArea, aSize

  drgFC  := drgFormContainer():new()
* Get password checking routine and default username
  cParm  := drgParseSecond(::drgDialog:initParam)
  ::usrPgm   := drgParse(@cParm)
  ::usrFirma := drgParse(@cParm)
  ::usrName  := drgParse(@cParm)
  ::usrPswd  := ''
* If you wonder why using drgNLS. Default behaviour is to translate messages through
* application program message file. Thus translation will be done through DRG system messages


  DRGFORM INTO drgFC SIZE 80,6 DTYPE '1' TITLE 'Pøihlášení';
    GUILOOK 'ALL:Y BORDER:N ACTION:Y'

  DRGTEXT INTO drgFC CAPTION 'Vstupní adresáø'    CPOS 1,1 BGND(1)
  DRGGET usrFirma INTO drgFC FPOS 15,1 FLEN 50 POST 'postValidate'
  odrg:push := 'in_dir'

  DRGTEXT INTO drgFC CAPTION 'Výstupní adresáø'   CPOS 1,2 BGND(1)
  DRGGET usrName  INTO drgFC FPOS 15,2 FLEN 50 POST 'postValidate'
  oDrg:push := 'out_dir'

  DRGTEXT INTO drgFC CAPTION 'ID databáze'        CPOS 1,3 BGND(1) // PUSH(LoginFirma)
  DRGGET usrPswd  INTO drgFC FPOS 15,3 FLEN 25 POST 'postValidate'

  DRGPUSHBUTTON INTO drgFC CAPTION 'O~K' EVENT 'checkPassword' PRE '0'   SIZE 10,1 POS 22,4.80 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION '~Konec' EVENT drgEVENT_QUIT PRE '0' SIZE 10,1 POS 33,4.80 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

**********************************************************************
* Called just before dialog has been displayed. Set password field to \
* unreadable so password would not be seen.
**********************************************************************
method AsystemLogin:drgDialogInit(drgDialog)

**   drgDialog:dialog:AlwaysOnTop := .T.
return self




METHOD AsystemLogin:drgDialogStart()
  local  usrpath

  ::dataManager:set('m->usrfirma', logFirma)
  ::dataManager:set('m->usrname', ::selUSERs[2])

  ::opsw := ::dataManager:get('usrpswd', .F.)  //:oDrg:oXbp:xbpSle
  ::opsw:oDrg:oXbp:xbpSle:tabStop      := .T.
  ::opsw:oDrg:oXbp:xbpSle:bufferLength := Len( ::usrPswd)
  ::opsw:oDrg:oXbp:xbpSle:unReadable   := .T.
  ::opsw:oDrg:oXbp:xbpSle:configure()

  ::dataManager:refresh()
RETURN self



METHOD AsystemLogin:in_dir()
  local in_dir

  in_dir := _DirDialog('Vstupní adresáø ...', ::drgDialog)

  if .not. empty(in_dir)
    ::drgDialog:dataManager:set('m->usrfirma', in_dir)
  endif


*  DRGDIALOG FORM 'dirSelector' PARENT ::drgDialog MODAL DESTROY ;
*                                                  EXITSTATE nExit

RETURN .t.


METHOD AsystemLogin:out_dir()
  local out_dir

  out_dir := _DirDialog('Výstupní adresáø ...', ::drgDialog)

  if .not. empty(out_dir)
    ::drgDialog:dataManager:set('m->usrName', out_dir)
  endif


*  DRGDIALOG FORM 'dirSelector' PARENT ::drgDialog MODAL DESTROY ;
*                                                  EXITSTATE nExit

RETURN .t.


**
** SELL METHOD *****************************************************************
METHOD AsystemLogin:selLicFirma()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'LoginFirma' PARENT ::drgDialog MODAL DESTROY ;
                                                 EXITSTATE nExit
  IF nExit != drgEVENT_QUIT
    ::drgDialog:dataManager:set('m->usrfirma', LicAsys->cNazFirPri)
  ENDIF

RETURN (nExit != drgEVENT_QUIT)



METHOD AsystemLogin:iniUsers(parent)
  LOCAL isUSERs := .F.
/*
  if( !File(drgINI:dir_DATA+'USERS.DBF'), myCreateDir( drgINI:dir_DATA), nil)
  drgDBMS:open('USERS',,,drgINI:dir_DATA,,,syApa)
  if Users->( LastRec()) = 0
    Users->( dbAppend())
    Users->cUser      := 'Admin'
    Users->cPrihlJmen := 'Administrátor'
    Users->cPassword  := 'admin'
    Users->dPlatn_OD  := Date()
    Users->cOpravneni := 'SYS_ADMIN'
  endif

  if .not. Empty(logFirma) .and. .not. Empty(logUser)
 * ( .not. LicAsys->(Found()), ::AsystemLogin:selLicFirma(), NIL)
    Users->(DbLocate( {|| AllTrim(Users->cPrihlJmen) == AllTrim(logUser)}))
  endif
  ::selUSERs[1] := Users->cUser
  ::selUSERs[2] := Users->cPrihlJmen
  ::selUSERs[3] := Users->cPassword
  ::selUSERs[4] := Users->cOpravneni
  ::selUSERs[5] := Users->cOsoba
  isUsers := .T.
*/
RETURN( isUsers)


**
** SELL METHOD *****************************************************************
METHOD AsystemLogin:selUser()
  LOCAL oDialog, nExit

  if ::isUSERs
    DRGDIALOG FORM 'LoginUser' PARENT ::drgDialog MODAL EXITSTATE nExit
    ::selUSERs[1] := Users->cUser
    ::selUSERs[2] := Users->cPrihlJmen
    ::selUSERs[3] := Users->cPassword
    ::selUSERs[4] := Users->cOpravneni
    ::selUSERs[5] := Users->cOsoba
  endif

  IF nExit != drgEVENT_QUIT
    ::drgDialog:dataManager:set('m->usrname', ::selUSERs[2])
    ::drgDialog:dataManager:refresh()
  ENDIF

RETURN (nExit != drgEVENT_QUIT)



**********************************************************************
* Method called by pushButton OK Action. Check for presence of user defined \
* program for checking password.
**********************************************************************
METHOD AsystemLogin:checkPassword()
LOCAL oPgm, lOk := .T.
local rec
/*
  ::dataManager:save()
* Call UDP function to check password
  IF (oPgm := ::drgDialog:getMethod(::usrPgm) ) != NIL
    lOk := EVAL(oPgm, ::usrFirma, ::selUSERs[3], ::usrPswd)

    if .not. lOk .and. SysConfig('system:ladminpsw')
      rec := Users->( RecNo())
      Users->(DbLocate( {|| AllTrim( Users->cPrihlJmen) == Alltrim( 'Administrátor')}))
      if Users->(Found())
        lOk := EVAL(oPgm, ::usrFirma, Users->cPassword, ::usrPswd)
      endif
      Users->( dbGoTo(rec))
    endif
  ENDIF
* IF OK post close dialog event and set drgEVENT_EXIT as dialog close event
  IF lOK
// nastavení adresáøe pro uživatele

    drgINI:dir_USER     := AllTrim(drgINI:dir_USER) +AllTrim(::selUSERs[2]) + '\'
    drgINI:dir_USERfi   := drgINI:dir_USER +AllTrim( LICASYS->cDataDir) +'\'
    drgINI:dir_USERfitm := drgINI:dir_USERfi +'TMP\'

* Usefull on network. One ini for everyone. And when a workstation needs something
* different (eg. printer port) put another ini file on the work directory of that station.
    drgReadINI(drgINI:dir_USERfi + 'User.ini')

 * Load saved values from previous program session
    cSaveFile := drgINI:dir_USERfi + drgINI:appName + '.SAV'
    drgReadINI(cSaveFile)

// nastavení public promìnných
    usrName     := Alltrim( ::selUSERs[1])
    syOpravneni := Alltrim( ::selUSERs[4])
    usrOsoba    := Alltrim( ::selUSERs[5])
    if Users->(dbRlock()) .and. Users->(FieldPos('dPrihlUser')) > 0
      Users->dPrihlUser := Date()
      Users->cPrihlUser := Time()
      Users->(dbUnlock())
    endif

    if( ::isUSERs, USERS->(dbCloseArea()), NIL)

    PostAppEvent(xbeP_Close,drgEVENT_EXIT,,::drgDialog:dialog)
* otherwise post error
   ELSE
    drgMsgBox(drgNLS:msg('Chybnì zadané heslo uživatele !'),XBPMB_CRITICAL )
    ::usrPswd := ''
    ::dataManager:refresh()
    ::drgDialog:oForm:setNextFocus(1,,.T.)
  ENDIF
*/
RETURN self


METHOD AsystemLogin:postValidate(drgVar)
  LOCAL lOK    := .T.
  LOCAL cNAME  := UPPER(drgVar:name)
  LOCAL xValue := drgVar:get()
  LOCAL aX, i
/*
  DO CASE
  CASE cNAME == 'M->USRFIRMA'
    LicAsys->(dbGoTop())
    LicAsys->(DbLocate( {|| AllTrim( LicAsys->cNazFirPri) == Alltrim( xValue)}))
    IF( .not. LicAsys->(Found()), ::AsystemLogin:selLicFirma(), NIL)
    ::usrFirma := LicAsys->cNazFirPri
    logFirma   := AllTrim(LicAsys->cNazFirPri)
    recFirma   := LicAsys->( Recno())
    usrIdSW    := LicAsys->NIDUZIVSW
    usrIdDB    := LicAsys->nUsrIdDB

    if drgINI:dir_DATA <> (drgINI:dir_DATAroot +AllTrim( LICASYS->cDataDir) +'\Data\')
      ::drgDialog:dataManager:set('m->usrfirma', ::usrFirma)
      if( SELECT('USERS') <> 0, USERS->(dbCloseArea()), NIL)
      drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
      ::isUSERs := ::iniUsers()
      ::drgDialog:dataManager:set('m->usrname', ::selUSERs[2])
    endif

  CASE cNAME == 'M->USRNAME'
    if ::isUSERs
      Users->(DbLocate( {|| AllTrim( Users->cPrihlJmen) == Alltrim( xValue)}))
      if .not. Users->(Found())
        ::AsystemLogin:selUser()
      else
        ::selUSERs[1] := Users->cUser
        ::selUSERs[2] := Users->cPrihlJmen
        ::selUSERs[3] := Users->cPassword
        ::selUSERs[4] := Users->cOpravneni
        ::selUSERs[5] := Users->cOsoba
      endif
    else
      lOK := 'Administrátor' == AllTrim(xValue)
    endif
    if .not. lOK
      drgMsgBox(drgNLS:msg('Chybnì zadané pøihlašovací jméno !'),XBPMB_CRITICAL )
    endif

  CASE cNAME == 'M->USRPSWD'
    ::usrPswd := xValue
  ENDCASE
*/
RETURN lOK


****************************************************************************
* CleanUp
****************************************************************************
METHOD AsystemLogin:destroy()
  ::drgUsrClass:destroy()
  ::usrFirma := ;
  ::usrName  := ;
  ::usrPswd  := ;
  ::usrPgm   := ;
  NIL
RETURN NIL

//  ------------------------ výbìr firmy pro pøihlášení ----------------

CLASS LoginFirma FROM drgUsrClass

EXPORTED:

  VAR arrFIRMA

  METHOD  getForm
  METHOD  init
  METHOD  drgDialogInit
//  METHOD  eventHandled

  METHOD  destroy             // release all resources used by this object

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    IF dc:browseInFocus() .AND. dc:oBrowse:oXbp:colPos = 1
      dc:oBrowse:refresh(.F.)
    ENDIF

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
METHOD LoginFirma:getForm()
LOCAL drgFC, oDrg
  drgFC  := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 41,12 TITLE 'Select' GUILOOK 'All:N,Border:Y'

  DRGTEXT INTO drgFC CAPTION 'Výbìr firmy' FONT 5 CPOS 2,0.10 BGND(1)
  DRGBROWSE INTO drgFC SIZE 40,10.7                     ;
                       FPOS  0.5,1.2                    ;
                       FIELDS 'cNazFirPri:Název firmy:40'        ;
                       SCROLL 'ny' CURSORMODE 3 PP 1    ;
                       FILE 'LICASYS'

  DRGPUSHBUTTON INTO drgFC EVENT 140000002 SIZE 3,1 POS 37.5,0 ;
    ICON1 102 ICON2 202 ATYPE 1 TIPTEXT 'Ukonèi dialog'

RETURN drgFC


METHOD LoginFirma:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
RETURN self


METHOD LoginFirma:drgDialogInit(drgDialog)
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
METHOD LoginFirma:destroy()
  ::drgUsrClass:destroy()
RETURN NIL


//  ------------------------ výbìr uživatele pro pøihlášení ----------------
CLASS LoginUser FROM drgUsrClass

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
    IF dc:browseInFocus() .AND. dc:oBrowse:oXbp:colPos = 1
      dc:oBrowse:refresh(.F.)
    ENDIF

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
METHOD LoginUser:getForm()
LOCAL drgFC, oDrg
  drgFC  := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 41,12 TITLE 'Select' GUILOOK 'All:N,Border:Y'

  DRGTEXT INTO drgFC CAPTION 'Výbìr uživatele' FONT 5 CPOS 2,0.10 BGND(1)
  DRGBROWSE INTO drgFC SIZE 40,10.7                     ;
                       FPOS  0.5,1.2                    ;
                       FIELDS 'cPrihlJmen:Uživatel:39'           ;
                       SCROLL 'ny' CURSORMODE 3 PP 1    ;
                       FILE 'Users'

  DRGPUSHBUTTON INTO drgFC EVENT 140000002 SIZE 3,1 POS 37.5,0 ;
    ICON1 102 ICON2 202 ATYPE 1 TIPTEXT 'Ukonèi dialog'

RETURN drgFC


METHOD LoginUser:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)
RETURN self


METHOD LoginUser:drgDialogInit(drgDialog)
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
METHOD LoginUser:destroy()
  ::drgUsrClass:destroy()
RETURN NIL


//  ------------------------ výbìr uživatele pro pøihlášení ----------------
CLASS AsystemStart FROM drgUsrClass

EXPORTED:

  METHOD  getForm
  METHOD  init
  METHOD  drgDialogInit

  METHOD  destroy             // release all resources used by this object
//  METHOD  eventHandled


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl


  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
  CASE nEvent = xbeP_Keyboard
  OTHERWISE
    RETURN .T.
  ENDCASE
RETURN .T.


ENDCLASS


****************************************************************************
* Returns form definition for drgLogin UDCP.
****************************************************************************
METHOD AsystemStart:getForm()
LOCAL drgFC, oDrg

  drgFC  := drgFormContainer():new()

  DRGFORM INTO drgFC DTYPE '2' SIZE 80,18 GUILOOK 'All:N,Border:N'

  DRGSTATIC INTO drgFC STYPE 5 FPOS 0.0,0.0 SIZE 700,500 CAPTION 'c:\LEGO_xpp\A_proj\Asystem++\Asystem++.bmp'

RETURN drgFC


METHOD AsystemStart:init(parent)
  Local nEvent,mp1,mp2,oXbp
/*
  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)
*/

RETURN self


METHOD AsystemStart:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  drgDialog:hasIconArea := drgDialog:hasActionArea := ;
  drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
  XbpDialog:titleBar    := .F.

RETURN


****************************************************************************
* CleanUp
****************************************************************************
METHOD AsystemStart:destroy()
  ::drgUsrClass:destroy()
RETURN NIL