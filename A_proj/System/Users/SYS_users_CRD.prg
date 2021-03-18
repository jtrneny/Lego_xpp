#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


**  Správa uživatelù systému
** CLASS SYS_users_SCR *********************************************
CLASS SYS_users_SCR FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  itemMarked
  METHOD  getForm
  METHOD  userIn, userDel
  *
  METHOD  osoby, usrMenu, emptyMNU, config, asysact, copysettings
  METHOD  destroy

  VAR     typIn, pa_usersTask

  * je vytvoøeno menu
  inline access assign method userMenu_is() var usermenu_is
    return if(empty(users->mmenuuser), 0, MIS_ICON_OK)

  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_APPEND
//    USERS->(dbAppend())
      ::typIn := "APPEND"
      ::userIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT //.OR. nEvent = xbeM_LbDblClick // .OR. nEvent = drgEVENT_FORMDRAWN
      ::typIn := "EDIT"
//    USERS->(dbRlock())
      ::userIN()
      dc:oBrowse[1]:refresh(.T.)
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      IF USERS->CUSER <> "Admin"
        ::userDel()
        dc:oBrowse[1]:refresh(.T.)
      ELSE
        ::drgDialog:oMessageBar:writeMessage('Uživatele ADMINISTRÁTOR nelze smazat ...',DRG_MSG_WARNING)
      ENDIF
      RETURN .T.

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  var ab
  var obtn_emptyMNU, obtn_asysact, obtn_copySettings


  inline method processMNUfile()
    local  cline, st, F := 1, nRsrc := 2, type, keyWord, value, ctask
    local  cmenuUser := users->mmenuUser
    local  pa        := ::pa_usersTask := {}

    if empty( cmenuUser)
      drgDBMS:open( 'usersGrp' )
      usersGrp->( dbseek( upper( users->cgroup),, 'USERSGRP01'))
      cmenuUser := usersGrp->mmenuGroup
    endif

    while ( cline := _drgGetSection(@F, @cmenuUser, @nRsrc) ) != NIL

      * No type definition. Read next line
      if (type := drgGetParm("TYPE", cLine)) = NIL
        LOOP
      endif

      type := lower(type)
      st   := cline

      while ( keyWord := _parse(@st, @value) ) != NIL
        if keyWord == 'DATA'
          ctask := upper( left( _getStr(value), 3))
          if .not. empty(ctask) .and. ;
             ( c_task->( dbseek( ctask,,'C_TASK01')) .and. config_ts->( dbseek( ctask,,'CONFIGHD04')))

            if( ascan( pa, {|x| x = ctask }) = 0, aadd( pa, ctask), nil )
          endif
        endif
      enddo
    enddo
  return self

ENDCLASS

METHOD SYS_users_SCR:init(parent)
  LOCAL aUsers
  LOCAL n

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'c_task' )
  drgDBMS:open( 'confighd',,,,,'config_ts')

  drgDBMS:open('OSOBY')
  drgDBMS:open('USERS',,,,,,syApa)

  ::pa_usersTask := {}
RETURN self


METHOD SYS_users_SCR:getForm()
  LOCAL drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,25 DTYPE '10' TITLE 'Uživatelé systému' GUILOOK 'All:Y,Border:Y,Action:Y'

  DRGAction INTO drgFC CAPTION 'Osoby'           EVENT 'osoby'         TIPTEXT 'Osoby evidované systémem'            // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Menu'            EVENT 'usrMenu'       TIPTEXT 'Uživatelské menu'                    // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'ZrušMenu'        EVENT 'emptyMNU'      TIPTEXT 'Zrušení nastaveného menu'            // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Konfigurace'     EVENT 'config'        TIPTEXT 'Uživatelská konfigurace'             // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Oprávnìní'       EVENT 'asysact'       TIPTEXT 'Uživatelská oprávnìní pøístupu'      // ICON1 101 ICON2 201 ATYPE 3
  DRGAction INTO drgFC CAPTION 'Kopie nastavení' EVENT 'copySettings'  TIPTEXT 'Kopie nastavení z jiného Uživatele'  // ICON1 101 ICON2 201 ATYPE 3

  DRGDBROWSE INTO drgFC FPOS 0.5,0.05 SIZE 99.0,24.7 FILE 'USERS'            ;
    FIELDS 'M->usermenu_is::2.7::2,'                                      + ;
           'COSOBA:Jméno osoby:30:::GET,'                                 + ;
           'CPRIHLJMEN:Pøihlašovací jméno::::GET,'                        + ;
           'CUSER:Zkratka uživatele::::GET,'                              + ;
           'CGROUP:Zkratka skupiny::::GET,'                               + ;
           'DPRIHLUSER:Datum pøihlášení::::GET,'                          + ;
           'CPRIHLUSER:Èas pøihlášení::::GET,'                            + ;
           'DPLATN_OD:Platnost OD::::GET,'                                + ;
           'DPLATN_DO:Platnost DO::::GET,'                                + ;
           'COPRAVNENI:Oprávnìní,'                                        + ;
           'NCISOSOBY:Èíslo osoby::::GET'                                   ;
            ITEMMARKED 'itemMarked' SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y'

RETURN drgFC


method SYS_users_SCR:drgDialogStart(drgDialog)
  local  x

  ::ab        := drgDialog:oActionBar:members      // actionBar

  for x := 1 TO len(::ab) step 1
    do case
    case ::ab[x]:event = 'emptyMNU'      ;  ::obtn_emptyMNU     := ::ab[x]
    case ::ab[x]:event = 'asysact'       ;  ::obtn_asysact      := ::ab[x]
    case ::ab[x]:event = 'copySettings'  ;  ::obtn_copySettings := ::ab[x]
    endcase
  next
return self


METHOD SYS_users_SCR:itemMarked()
RETURN self


METHOD SYS_users_SCR:userIn()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_users_IN,' + ::typIn PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_SCR:userDel()
  LOCAL aUsers
  LOCAL n

//        if drgIsYESNO(drgNLS:msg( 'Zrušit uživatelský filtr <&> ?' , fltusers->cidfilters) )
  IF drgIsYESNO(drgNLS:msg( 'Zrušit uživatele <&> ?' , USERS->COSOBA) )
    IF( USERS->(dbRlock()), USERS->( dbDelete(), dbUnlock()), NIL)
  ENDIF

RETURN .T.

METHOD SYS_users_SCR:osoby()
  LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'OSB_osoby_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_SCR:usrMenu()
  LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'Sys_users_Menu,UserMenu' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_SCR:emptyMNU()
  LOCAL aUsers
  LOCAL n

//        if drgIsYESNO(drgNLS:msg( 'Zrušit uživatelský filtr <&> ?' , fltusers->cidfilters) )
  IF drgIsYESNO(drgNLS:msg( 'Zrušit menu uživatele <&> ?' , USERS->COSOBA) )
    IF USERS->(dbRlock())
     USERS->MMENUUSER := ''
     USERS->( dbUnlock())
    endif
  ENDIF

RETURN .T.


METHOD SYS_users_SCR:config()
  LOCAL oDialog

  ::processMNUfile()

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_config_CRD,USER' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_SCR:asysact()
  LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_asysact_IN,USER' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_SCR:CopySettings()
  LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_users_CopySettings,USER' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


** END of CLASS ****************************************************************
METHOD SYS_users_SCR:destroy()
  ::drgUsrClass:destroy()

RETURN NIL



**  Aktualizace uživatele
** CLASS for SYS_users_IN *********************************************
CLASS SYS_users_IN FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  postAppend
  METHOD  returnOsoba
  METHOD  onSave
  METHOD  getForm
  METHOD  osoby
  METHOD  group

  METHOD  destroy

  VAR     paswordCheck, idOsoby
  VAR     newRec


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc := ::drgDialog:dialogCtrl, new_val

    if isobject(::opsw_1)
      do case
      case ::opsw_1:odrg:oXbp:xbpSle:changed
        new_val := alltrim(::opsw_1:odrg:oXbp:xbpSle:getdata())
        ::opsw_1:set(new_val)
      case ::opsw_2:odrg:oXbp:xbpSle:changed
        new_val := alltrim(::opsw_2:odrg:oXbp:xbpSle:getdata())
        ::opsw_2:set(new_val)
      endcase
    endif

    DO CASE
    CASE nEvent = drgEVENT_SAVE .or. nEvent = drgEVENT_EXIT
      ::onSave()
*      if nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
*      endif
      RETURN .t.
    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR typ, dm, msg, opsw_1, opsw_2

ENDCLASS


METHOD SYS_users_IN:init(parent)

  drgDBMS:open('USERS',,,,,"USERStm")
  drgDBMS:open('OSOBY')

  ::drgUsrClass:init(parent)
  ::idOsoby      := 0
  ::paswordCheck := ''

RETURN self


METHOD SYS_users_IN:getForm()
  LOCAL drgFC, cParm, oDrg

  cParm    := drgParseSecond(::drgDialog:initParam)
  ::newRec := IF( cParm == "APPEND", .T., .F.)

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 100,15 DTYPE '10' TITLE 'Modifikace uživatelù systému' GUILOOK 'All:Y,Border:Y,Action:N' POST 'postValidate' FILE 'USERS'

*    DRGAction INTO drgFC CAPTION 'Konfigurace' EVENT 'config'  TIPTEXT 'Nastavení uživatelské konfigurace'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Menu' EVENT 'menu'  TIPTEXT 'Nastavení uživatelského menu'// ICON1 101 ICON2 201 ATYPE 3
*    DRGAction INTO drgFC CAPTION 'Opravnìní' EVENT 'osoby'  TIPTEXT 'Nastavení uživatelského oprávnìní - pøístupu'// ICON1 101 ICON2 201 ATYPE 3

//  DRGSTATIC INTO drgFC FPOS 0.5,0.07 SIZE 99.1,7.6 STYPE XBPSTATIC_TYPE_RECESSEDRECT
    DRGTEXT INTO drgFC CAPTION 'Jméno osoby uživatele'  CPOS 1,0.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->COSOBA INTO drgFC FPOS 25,0.5 FLEN 50 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'osoby'

    DRGTEXT INTO drgFC CAPTION 'Pøihlašovací jméno' CPOS 1,2.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->CPRIHLJMEN INTO drgFC FPOS 25,2.4 FLEN 50 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Zkratka uživatele'  CPOS 1,3.4 CLEN 20  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->CUSER INTO drgFC FPOS 25,3.4 FLEN 15 PP 2 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Skupina uživatelù'  CPOS 1,5.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->CGROUP INTO drgFC FPOS 25,5.4 FLEN 15 PP 2
     oDrg:push := 'group'

    DRGTEXT INTO drgFC CAPTION 'Systémové oprávnìní'  CPOS 1,7.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->COPRAVNENI INTO drgFC FPOS 25,7.4 FLEN 15 PP 2
//     DRGTEXT C_OPRAVN->CNAZOPRAVN INTO drgFC CPOS 43,5.4 FLEN 30 BGND 13 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Platnost OD'  CPOS 1,9.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->dPLATN_OD INTO drgFC FPOS 25,9.4 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'clickdate'
    DRGTEXT INTO drgFC CAPTION 'Platnost DO'  CPOS 1,10.4 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->dPLATN_DO INTO drgFC FPOS 25,10.4 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'clickdate'
    DRGTEXT INTO drgFC CAPTION 'Heslo' CPOS 1,12.2 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->cPASSWORD INTO drgFC FPOS 25,12.2 FLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
    DRGTEXT INTO drgFC CAPTION 'Potvrzení hesla' CPOS 1,13.2 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET M->PASWORDCHECK INTO drgFC FPOS 25,13.2 FLEN 15  // FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Email klíè na web' CPOS 43,12.2 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET USERS->cEmailWeb INTO drgFC FPOS 60,12.2 FLEN 37 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

     DRGGET USERS->nCISOSOBY INTO drgFC FPOS 0,0 FLEN 0 // FCAPTION 'Distribuèní hodnota' CPOS 1,2

     //  DRGEND  INTO drgFC


RETURN drgFC


METHOD SYS_users_IN:drgDialogStart(drgDialog)
  LOCAL aUsers, n, oSle, new_val

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager

  if !::newRec
    oSle := ::dataManager:get('USERS->CUSER', .F.)// :oDrg:oXpb:xbpSle
    osle:odrg:isEdit := .f.
    osle:odrg:oxbp:disable()
  else
    ::postAppend()
  endif

  oSle := ::dataManager:get('USERS->CPASSWORD', .F.) // :oDrg:oXbp:xbpSle
  oSle:odrg:oXbp:xbpSle:unReadable   := .T.
  oSle:odrg:oXbp:xbpSle:configure()
  oSle:refresh()
  ::opsw_1 := osle

  oSle := ::dataManager:get('M->PASWORDCHECK', .F.) // :oDrg:oXbp:xbpSle
  oSle:odrg:oXbp:xbpSle:unReadable := .T.
  oSle:odrg:oXbp:xbpSle:configure()
  ::opsw_2 := osle

  oSle := ::dataManager:get('USERS->NCISOSOBY', .F.)// :oDrg:oXpb:xbpSle
  osle:odrg:isEdit := .f.

  IF ::newRec
    ::dataManager:set("users->copravneni", "USR_ZAKLAD")
    ::dataManager:set("users->dPlatn_Od", Date())
    ::dataManager:set("users->cpassword", '')
  ELSE
    ::dataManager:set("m->paswordcheck", USERS->CPASSWORD)
    ::paswordCheck := USERS->CPASSWORD
  ENDIF

  *
  if .not. ::newRec
    new_val := alltrim(::opsw_1:odrg:oXbp:xbpSle:getdata())
    ::opsw_1:set(new_val)

    new_val := alltrim(::opsw_2:odrg:oXbp:xbpSle:getdata())
    ::opsw_2:set(new_val)
  endif
RETURN self

                                  *
*****************************************************************
METHOD SYS_users_IN:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

  DO CASE
  CASE(name = 'users->cosoba')
    if( !Empty( value) .and. (::newRec .or. changed)                         ;
          ,lOK := ::returnOsoba(value), NIL)

  CASE(name = 'users->cuser')
    IF Empty(value)
      ::msg:writeMessage('Zkratka uživatele je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    ELSE
      IF ::newRec .AND. USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,10)),, AdsCtag(1) ))
        ::msg:writeMessage('Zkratka uživatele již existuje, musíte zadat jinou ....',DRG_MSG_ERROR)
        lOk := .F.
      ENDIF
    ENDIF

  CASE(name = 'users->cprihljmen')
    if Empty(value)
      ::msg:writeMessage('Pøihlašovací jméno je povinný údaj ...',DRG_MSG_ERROR)
      lOk := .F.
    else
      if USERStm->(dbSeek(Upper(Padr(AllTrim( value) ,20)),, AdsCtag(3) ))
        ::msg:writeMessage('Pøihlašovací jméno již existuje, musíte zadat jiné ....',DRG_MSG_ERROR)
        lOk := .T.    /// OPRAVIT ///
      endif
    endif

  CASE(name = 'm->paswordcheck')
    IF value <> ::dataManager:get("users->cpassword")
      ::msg:writeMessage('Chybnì zadané heslo ...',DRG_MSG_ERROR)
      lOk := .F.
    ENDIF

  ENDCASE

  ** ukládáme pøi zmìnì do tmp **
  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk


method SYS_users_IN:returnOsoba(value)
  LOCAL  filtr, n, cval, cnam
  LOCAL  lOK := .T., lSel := .F.
  LOCAL  idOsoba
  LOCAL  nX, cX

  nX := Len( OSOBY->cOsoba)
  cX := Padr(value, nX)
  if !OSOBY->(dbSeek(Upper(cX),, AdsCtag(2) ))
    cval := Upper(AllTrim(value)+"*")
    cnam := 'upper(cOsoba)'
*    filtr := 'contains(' +cnam +'", ' +cval +')'
    filtr := 'contains(' +cnam + ',"' +cval + '")'
*             'contains(' +cnam + ',"' +cval + '")' +' '

    OSOBY->(ads_clearaof(), ads_setaof(filtr), DbGoTop())
//          n := OSOBY->(Ads_GetRecordCount())
    n := OSOBY->( mh_COUNTREC())
    do case
    case n = 0
      ::msg:writeMessage('Uživatel musí být zaøazen v seznamu osob...',DRG_MSG_ERROR)
       lOK := .F.
    case n > 1
      ::Osoby()
    otherwise
      ::dataManager:set("users->cOsoba", OSOBY->COSOBA)
      ::dataManager:set("users->nCisOsoby", OSOBY->nCisOsoby)
    endcase
  else
    ::dataManager:set("users->cOsoba", OSOBY->COSOBA)
    ::dataManager:set("users->nCisOsoby", OSOBY->nCisOsoby)
  endif

  idOsoby := ::dataManager:get("users->nCisOsoby")
  if USERStm->(dbSeek( idOsoby,, AdsCtag(2) )) .and. lOK
    ::msg:writeMessage('Osoba je již v seznamu uživatelù...',DRG_MSG_ERROR)
    lOK := .F.
  endif

  OSOBY->(ads_clearaof())

return( lOK)

* ok
method SYS_users_IN:postAppend()
  local x, ovar, type, val, ok, file

  for x := 1 to ::dm:vars:size() step 1
    ok   := .f.
    ovar := ::dm:vars:getNth(x)
    type := valtype(ovar:value)
    file := lower(drgParse(ovar:name,'-'))

    do case
    case(type == 'N')  ;  val := 0
    case(type == 'C')  ;  val := ''
    case(type == 'D')  ;  val := ctod('  .  .  ')
    case(type == 'L')  ;  val := .f.
    endcase

    ovar:set(val)
    ovar:initValue := ovar:prevValue := ovar:value := val
  next
return .t.


METHOD SYS_users_IN:onSave()
  LOCAL aUsers
  LOCAL n

  IF( ::newRec, USERS->(dbAppend()), USERS->(dbRlock()))
  ::dm:save()
  USERS->cPassword := AllTrim(USERS->cPassword)
  USERS->(dbUnlock())

RETURN .T.


METHOD SYS_users_IN:osoby()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dataManager:set("users->cOsoba", OSOBY->COSOBA)
    ::dataManager:set("users->nCisOsoby", OSOBY->nCisOsoby)
  endif
  ::drgDialog:popArea()                  // Restore work area
RETURN self


METHOD SYS_users_IN:group()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SYS_usersgrp_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dataManager:set("users->cgroup", usersgrp->cgroup)
  endif
  ::drgDialog:popArea()                  // Restore work area
RETURN self


** END of CLASS ****************************************************************
METHOD SYS_users_IN:destroy()
  ::drgUsrClass:destroy()

RETURN NIL


