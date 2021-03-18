/////////////////////////////////////////////////////////////////////
//
//  Asystem++_login.PRG
//
//  Copyright:
//       MISS Software, s.r.o., (c) 2005. All rights reserved.
//
//  Contents:
//       Login Asystem++Dialog.
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

#include "..\A_main\ace.ch"



CLASS AsystemLogin FROM drgUsrClass

EXPORTED:
  VAR     usrFirma
  VAR     usrName
  VAR     usrPswd
  VAR     usrPgm
  VAR     isUSERs
  VAR     selUSERs
  *
  var     osession

  METHOD  init
  METHOD  getForm
  METHOD  drgDialogInit, drgDialogStart
  METHOD  checkPassword
  METHOD  selLicFirma
  METHOD  iniUsers
  METHOD  selUser
  METHOD  postValidate

  METHOD  destroy             // release all resources used by this object

  inline method connect_to_data()
    local cConnect
    local cUSRasys

//    cUSRasys := "UID=ADSSYS;PWD='';"
    cUSRasys := "UID=ADSSYS;"
    cConnect := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATA +drgINI:add_FILE +";" +AllTrim(drgINI:ads_SERVER_TYPE) +";" +cUSRasys

    oSession_data := ::osession := dacSession():New(cConnect)

    if .not. ( ::osession:isConnected() )
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ< server ADS !!!' +;
                           'Server: ' +cConnect +' neexistuje !!!' ))
      QUIT
    endIf

    ::osession:setDefault()
  return

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

  dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
  licAsys->( AX_SetPass(syApa))

  LicAsys->(dbGoTop())
  if .not. Empty(logFirma) .and. .not. Empty(logUser)
    ::isUsers := .t.

    if .not. LicAsys->(DbLocate( {|| AllTrim( LicAsys->cNazFirPri) == Alltrim( logFirma)}))
      LicAsys->(dbGoTop())
    endif
  endif

  ::usrFirma := LicAsys->cNazFirPri
  logFirma   := AllTrim(LicAsys->cNazFirPri)
  recFirma   := LicAsys->( Recno())
  usrIdSW    := LicAsys->NIDUZIVSW
  usrIdDB    := LicAsys->nUsrIdDB

  drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
  drgINI:add_FILE := 'A++_' +strZero(licAsys->nUsrIDDB,6) +'.add'
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


  DRGFORM INTO drgFC SIZE 44,6 DTYPE '1' TITLE drgNLS:msg('Pøihlášení');
    GUILOOK 'ALL:Y BORDER:N ACTION:Y'

  DRGTEXT INTO drgFC CAPTION drgNLS:msg('Firma')    CPOS 1,1 BGND(1)
  DRGGET usrFirma INTO drgFC FPOS 12,1 FLEN 25 POST 'postValidate'
  oDrg:push := 'selLicFirma'

  DRGTEXT INTO drgFC CAPTION drgNLS:msg('Uživatel') CPOS 1,2 BGND(1)
  DRGGET usrName  INTO drgFC FPOS 12,2 FLEN 25 POST 'postValidate'
  oDrg:push := 'selUser'

  DRGTEXT INTO drgFC CAPTION drgNLS:msg('Heslo')    CPOS 1,3 BGND(1)
  DRGGET usrPswd  INTO drgFC FPOS 12,3 FLEN 25 POST 'postValidate'

  DRGPUSHBUTTON INTO drgFC CAPTION drgNLS:msg('O~K') EVENT 'checkPassword' PRE '0'   SIZE 10,1 POS 22,4.80 ;
    ICON1 DRG_ICON_SAVE ICON2 gDRG_ICON_SAVE ATYPE 3
  DRGPUSHBUTTON INTO drgFC CAPTION drgNLS:msg('~Konec') EVENT drgEVENT_QUIT PRE '0' SIZE 10,1 POS 33,4.80 ;
    ICON1 DRG_ICON_QUIT ICON2 gDRG_ICON_QUIT ATYPE 3

RETURN drgFC

**********************************************************************
* Called just before dialog has been displayed. Set password field to \
* unreadable so password would not be seen.
**********************************************************************
method AsystemLogin:drgDialogInit(drgDialog)

//  drgDialog:dialog:AlwaysOnTop := .T.
return self


METHOD AsystemLogin:drgDialogStart(drgDialog)
  local  usrpath

  ::dataManager:set('m->usrfirma', logFirma )
  ::dataManager:set('m->usrname' , logUser  )

  ::opsw := ::dataManager:get('usrpswd', .F.)
  ::opsw:oDrg:oXbp:xbpSle:tabStop      := .T.
  ::opsw:oDrg:oXbp:xbpSle:bufferLength := Len( ::usrPswd)
  ::opsw:oDrg:oXbp:xbpSle:unReadable   := .T.
  ::opsw:oDrg:oXbp:xbpSle:configure()

  ::dataManager:refresh()
RETURN self



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
  local phConnect, cversionDB
  local filtr

//  #ifdef VALID_DATE
  if .not. Empty( LicAsys->dplatlicdo)
    if DATE() > LicAsys->dplatlicdo
      drgMsgBox(drgNLS:msg('Platnost vaší verze vypršela - kontaktujte distributora !'), XBPMB_CRITICAL)
      DBCLOSEALL()
      QUIT
    elseif DATE() > LicAsys->dplatlicdo - 30
      nD := LicAsys->dplatlicdo - DATE()
      cD := if( nD = 1, ' den',;
            if( nD >= 2 .and. nD <= 4, ' dny', ' dnù' ))
      drgMsgBox(drgNLS:msg('Platnost vaší verze vyprší za & & !', nD, cD))
    endif
  endif
//  #endif

  ::connect_to_data()

  phConnect := oSession_data:getConnectionHandle()

  verMajor  := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MAJOR, 0, 2 )
  verMinor  := AdsDDGetDatabaseProperty( phConnect, ADS_DD_VERSION_MINOR, 0, 2 )

  cversionDB := Padl(AllTrim(str(verMajor)) +'.' +AllTrim(str(verMinor)), 7, '0')

  if SpecialBuild <> cversionDB
    ConfirmBox( ,'Nesouhlasí verze databáze s distribuèní verzí ...', ;
                 cversionDB + ' --> ' +SpecialBuild                 , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

  endif

  drgDBMS:open('USERS')

  cfiltr := Format("dPlatn_DO >= '%%' or Empty(dPlatn_DO)", {Date()})
  Users->( ads_setaof(cfiltr), dbGoTop())

  if Users->( LastRec()) = 0
    Users->( dbAppend())
    Users->cUser      := 'Admin'
    Users->cPrihlJmen := 'Administrátor'
    Users->cPassword  := 'admin'
    Users->dPlatn_OD  := Date()
    Users->cOpravneni := 'USR_ADMIN'
  endif

  if .not. Empty(logFirma) .and. .not. Empty(logUser)
    Users->(DbLocate( {|| AllTrim(Users->cPrihlJmen) == AllTrim(logUser)}))
  endif
  ::selUSERs[1] := Users->cUser
  ::selUSERs[2] := Users->cPrihlJmen
  ::selUSERs[3] := Users->cPassword
  ::selUSERs[4] := Users->cOpravneni
  ::selUSERs[5] := Users->cOsoba
  ::isUsers     := .T.
RETURN( ::isUsers)


**
** SELL METHOD *****************************************************************
METHOD AsystemLogin:selUser()
  LOCAL oDialog, nExit

  if( isObject(::oSession), nil, ::connect_to_data() )

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

  ::dataManager:save()

  * pøednastaveno z asysuser.ini jen klepne OK
  if( isNull( ::osession ), ::iniUsers(), nil )

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

// menusí být otevøený users
    if SELECT('USERS') = 0
      drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
      drgINI:add_FILE := 'A++_' +strZero(licAsys->nUsrIDDB,6) +'.add'

       ::iniUsers()
    endif

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

RETURN self


METHOD AsystemLogin:postValidate(drgVar)
  LOCAL lOK    := .T.
  LOCAL cNAME  := UPPER(drgVar:name)
  LOCAL xValue := drgVar:get()
  LOCAL aX, i

  DO CASE
  CASE cNAME == 'M->USRFIRMA'
    LicAsys->(dbGoTop())
    LicAsys->(DbLocate( {|| AllTrim( LicAsys->cNazFirPri) == Alltrim( xValue)}))
    IF( .not. LicAsys->(Found()), lOk := ::AsystemLogin:selLicFirma(), lOk := .t.)
    ::usrFirma := LicAsys->cNazFirPri
    logFirma   := AllTrim(LicAsys->cNazFirPri)
    recFirma   := LicAsys->( Recno())
    usrIdSW    := LicAsys->NIDUZIVSW
    usrIdDB    := LicAsys->nUsrIdDB

    if lOk
**    if drgINI:dir_DATA <> (drgINI:dir_DATAroot +AllTrim( LICASYS->cDataDir) +'\Data\')
      ::drgDialog:dataManager:set('m->usrfirma', ::usrFirma)
      if( SELECT('USERS') <> 0, USERS->(dbCloseArea()), NIL)

      drgINI:dir_DATA := AllTrim(drgINI:dir_DATAroot) +AllTrim( LICASYS->cDataDir) +'\Data\'
      drgINI:add_FILE := 'A++_' +strZero(licAsys->nUsrIDDB,6) +'.add'

      ::isUSERs := ::iniUsers()
      ::drgDialog:dataManager:set('m->usrname', ::selUSERs[2])
    endif

  CASE cNAME == 'M->USRNAME'
    if( isObject(::oSession), nil, ::connect_to_data() )
    if( select('users') = 0, drgDBMS:open('USERS'), nil)

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
  ::oSession := NIL
RETURN NIL

//  ------------------------ výbìr firmy pro pøihlášení ----------------

CLASS LoginFirma FROM drgUsrClass

EXPORTED:

  VAR arrFIRMA

  METHOD  getForm
  METHOD  init
  METHOD  drgDialogInit
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
  DRGDBROWSE INTO drgFC SIZE 40,10.7                       ;
                        FPOS  0.5,1.2                      ;
                        FIELDS 'cNazFirPri:Název firmy:40' ;
                        SCROLL 'ny' CURSORMODE 3 PP 1      ;
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
  DRGDBROWSE INTO drgFC SIZE 40,10.7                     ;
                        FPOS  0.5,1.2                    ;
                        FIELDS 'cPrihlJmen:Uživatel:39'  ;
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