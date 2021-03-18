
***************************************************************************
*
*   Copyright:
*             , (c) 2003. All rights reserved.
*

*    Contents:
*             myApp main program definition.
*
***************************************************************************
#include "Common.ch"
#include "dll.ch"
#include "drg.ch"
#include "xbp.ch"
#include "gra.ch"
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"
#include "Appevent.ch"
#include "simpleio.ch"

#include "odbcdbe.ch"

#include "Thread.ch"


#define VALID_DATE   '20130630'
#define xbeP_Eval   xbeP_User + 1



**************************************************************************
* Here is where everything starts. Every XBase++ has to have one (and one only) \
* Main procedure defined. Main procedure is the program entry point.
**************************************************************************
PROCEDURE Main( lRun)
  LOCAL oMenu, oDialog
  LOCAL oBeg, aPos[2], aSize, oStart
  LOCAL nEvent, mp1 := NIL, mp2 := NIL, oXbp := NIL
  LOCAL cSaveFile

// make sure this mapping and directory does exist
  LOCAL   cDBasys  ///, oDlg
  LOCAL   cUSRasys
  LOCAL   cConnect ///, oDlg

  public  oSession_sys, oSession_data, oSession_free
  PUBLIC  uctOBDOBI, uctOBDOBI_LAST
  PUBLIC  usrIdSW
  PUBLIC  usrIdDB
  PUBLIC  syApa := 'V73ra5-xWdeYa46í8øK2'
  PUBLIC  timeRun

  DEFAULT lRun TO .f.

  timeRun := {}

  oDlg := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oDlg:taskList := .F.
  oDlg:create()

//  oapp := GetApplication()
//  oapp:enableVisualStyles := 0
//  oapp:mainForm           := oDlg

  IF !File('Asystem++.ini')
    MsgBox( 'Chybí inicializaèní soubor ASYSTEM++.INI  !!!', 'CHYBA...' )
    DBCLOSEALL()
    QUIT
  ENDIF
  *
  drgReadINI('Asystem++.ini')
  *
  drgLog    := drgLog():new()
  drgScrPos := drgScrPos():new()

  dclDefaultInitVars()

  drgRef := drgRef():new()
  *
  * Uncomment for (eg. Slovenian) localized DRG messages. Original DRG messages are all english (EN).
  drgINI:nlsDRGLoc := 'CZ'
  * Uncomment for multilingual user application written in English.
  drgINI:nlsAPPorg := 'CZ'
  drgINI:nlsAPPLoc := 'CZ'
  drgNLS    := drgNLS():new()
  drgNLS:readMsgFile('drgMSG',.T.)
  drgNLS:readMSGFile('appMSG',.F.)

  *
/*
  #ifdef VALID_DATE
    IF DATE() > STOD( VALID_DATE)
      drgMsgBox(drgNLS:msg('Platnost vaší verze vypršela - kontaktujte distributora !'), XBPMB_CRITICAL)
      DBCLOSEALL()
      QUIT
    ELSEIF DATE() > STOD( VALID_DATE) - 30
      nD := STOD( VALID_DATE) - DATE()
      cD := IF( nD = 1, ' den',;
            IF( nD >= 2 .and. nD <= 4, ' dny', ' dnù' ))
      drgMsgBox(drgNLS:msg('Platnost vaší verze vyprší za & & !', nD, cD))
    ENDIF
  #endif
*/
  *
  SET(_SET_DATEFORMAT, 'dd.mm.yyyy')
  SET NULLVALUE off

* Turn off Alt+C when compiled for distribution
  #ifndef DEBUG
    SetCancel(.F.)
  #endif

// connect to the ADS uživatelská podpora A++
//    cDBasys         := AllTrim(SysConfig('System:cFtpAdrKom'))
    cDBasys         := '77.95.199.110'
    cDBasys         := "\\"+ cDBasys +":6263\dataa\A_System\Asystem++\Data\A++\Data\A++_100101.add"
    cUSRasys        := "UID=UsrPodpora;PWD=BarUhvezdY;"
    cConnect        := "DBE=ADSDBE;SERVER="  +cDBasys +";ADS_AIS_SERVER;ADS_COMPRESS_INTERNET;" +cUSRasys
***
/*
    osession_aplus  := dacSession():New( cConnect)
    if .not. ( osession_aplus:isConnected() )
      drgMsgBox(drgNLS:msg('Uživatelská podpora >> A++ << není k dispozici !!!'))
    endif
*/
***

// connect to the ADS server systémová èást
//    cUSRasys        := "UID=ADSSYS;PWD='';"
    cUSRasys      := "UID=ADSSYS;"
    cConnect      := "DBE=ADSDBE;SERVER=" +AllTrim(drgINI:dir_SYSTEM) +";"+AllTrim(drgINI:ads_SERVER_TYPE)+";" +cUSRasys
    osession_sys  := dacSession():New( cConnect)

// connect to the ADS server uživatelská èást
    cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_USER) +";ADS_LOCAL_SERVER" +";" +cUSRasys
    osession_free := dacSession():New( cConnect)
    oSession_free:setProperty(ODBCSSN_TIMESTAMP_AS_DATE, .T.)

// check if we are connected to the ADS server
    IF .NOT. ( oSession_free:isConnected() )
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na >FREE< server ADS !!!'))
      QUIT
    ENDIF
    oSession_free:setDefault()

* Create DB dictionary. This must be done here because default database engines
* must be already loaded.
    drgDBMS := drgDBMS():new()
    drgDBMS:loadDBD()

* musíme ovìøit systémové soubory
**  check_sysFiles()

* Nìkterá nastavení prostøedí
//    oMenu       := drgDialogThread():new()
//    oMenu:cargo := -1

    if .not. ( oSession_sys:isConnected())
      drgMsgBox(drgNLS:msg('Nelze se pøipojit na >SYSTEM< server ADS !!!'))
      QUIT
    endif

    dbUseArea(.t., oSession_sys, drgINI:dir_SYSTEM +'licAsys',, .T.)
    licAsys->( AX_SetPass(syApa))

    IF !isWorkVersion
      if File(winapi_getUserPrivatePath()+'\Asystem++\ASYSUSER.INI')
        drgReadINI(winapi_getUserPrivatePath()+'\Asystem++\ASYSUSER.INI')
      endif

      DRGDIALOG FORM 'AsystemLogin'+',checkPswdFunction'+','+LICASYS->cNazFirPri +',admin' PARENT oDlg ;
      EXITSTATE nExit MODAL DESTROY

      IF nExit = drgEVENT_QUIT
        DBCOMMITALL()
        DBCLOSEALL()

        oSession_sys:disconnect()
        oSession_free:disconnect()
        if( isObject(oSession_data), oSession_data:disconnect(), nil )
        QUIT
      ENDIF

//   založení adresáøù
      myCreateDir( winapi_getUserPrivatePath()+'\Asystem++')
      myCreateDir( drgINI:dir_USER)
      myCreateDir( drgINI:dir_USERfi)
      myCreateDir( drgINI:dir_USERfitm)
      drgReadINI(drgINI:dir_USER + 'User.ini')
    ELSE
      cConnect      := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATAroot +drgINI:add_FILE +";ADS_COMPRESS_ALWAYS;"+AllTrim(drgINI:ads_SERVER_TYPE)+";"+cUSRasys
//      cConnect      := "DBE=ADSDBE;SERVER=" +drgINI:dir_DATAroot +drgINI:add_FILE +";UID=josef;PWD=ads;"
      oSession_data := dacSession():New(cConnect)
      oSession_data:setProperty(ODBCSSN_TIMESTAMP_AS_DATE, .T.)


      if .not. ( oSession_data:isConnected() )
        drgMsgBox(drgNLS:msg('Nelze se pøipojit na >DATOVÝ< server ADS !!!'))
        QUIT
      endIf

      LICASYS->(DbLocate( {|| LICASYS->NIDUZIVSW = 999900 } ))
      if( LICASYS->( found()), recFirma := LICASYS->(Recno()), nil)
      usrIdSW     := 999900
      usrIdDB     := 999901
      usrName     := 'Admin'
      usrOsoba    := 'Administrátor'
      logUser     := 'admin'
      logOsoba    := 'Administrátor'
      syOpravneni := 'SYS_ADMMZ'

      drgReadINI(drgINI:dir_USER + 'User.ini')
      cSaveFile := drgINI:dir_USERfi + drgINI:appName + '.SAV'
      drgReadINI(cSaveFile)
    ENDIF

    drgINI:dir_RSRCfi := drgINI:dir_RSRC +AllTrim(LICASYS->cDataDir) +'\'
    myCreateDir( drgINI:dir_RSRCfi )

    oMenu       := drgDialogThread():new()
    oMenu:cargo := -1

//  inicializace prostøedí
    drgINI:defTextBGND := 1   // default je XBPSTATIC_TYPE_RAISEDBOX
    drgINI:defFontSize := 8   // default je 8
    * RSRC pro firmu
//    drgINI:dir_RSRCfi := drgINI:dir_RSRC +AllTrim(LICASYS->cDataDir) +'\'
//    myCreateDir( drgINI:dir_RSRCfi )

    drgLog:destroy()
    drgLog := NIL
    drgLog := drgLog():new()

    drgScrPos:destroy()
    drgScrPos := NIL
    drgScrPos := drgScrPos():new()

    drgHelp   := XbpHelp():new():create( SetAppWindow(), drgINI:dir_SYSTEM +'\Help\' + drgINI:appName +'.chm', "myApp Help file")

* Check if DB dictionary has changed. Reorganize DBF structure if needed.
* This is very dangerous feature in multiuser environment. Use it only when
* only one user is active.

  if( select('asysini') <> 0, asysini->(dbcloseArea()), nil)
  *

  if .not. Empty(recFirma)
    ( drgDBMS:open('LICASYS',,,drgINI:dir_SYSTEM), LICASYS->( dbGoTo(recFirma)))

    if LICASYS->NSYSLOCK > 0 .and. usrName <> 'admin'
      drgMsgBox(drgNLS:msg('Na systému probíhá údržba. Pøihlaste se pozdìji.'))
      QUIT
    endif

    #ifdef WORK_VERSION
      if(syCheckDB <> 0, drgDBMS:checkDB(), nil)
    #else
      if LICASYS->NSYCHECKDB > 0
        ( LICASYS->(dbRlock()), LICASYS->NSYSLOCK := 1)
        syCheckDB := LICASYS->NSYCHECKDB
        drgDBMS:checkDB()
        ( LICASYS->NSYCHECKDB := 0, LICASYS->NSYSLOCK := 0, LICASYS->(dbUnLock()))
      endif
    #endif

    logFirm := AllTrim(LicAsys->cNazFirPri)
    ModiFirmaCFG()
  endif

  if .not. Empty(usrName)
   ( drgDBMS:open('USERS'), USERS->( dbSeek(Upper(usrName),,'USERS01')))
   logUser     := AllTrim( Users->cPrihlJmen)
   logCisOsoby := Users->nCisOsoby
   logOsoba    := if( isWorkVersion, logOsoba, AllTrim( Users->cOsoba))
  endif

  * OBJEKT pro práci s UCT_ucetsys a základním kalendáøem *
  uctOBDOBI := uctOBDOBI():new()
  if .not. IsNil(uctOBDOBI:UCT)
    obdReport := strZero(uctOBDOBI:UCT:nobdobi,2) +'/' +strZero(uctOBDOBI:UCT:nrok,4)
  endif

  uctOBDOBI_LAST := uctOBDOBI_LAST():new()

  * splash for dialog
  osplash_for_dialog := splash_for_dialog()

  typPanel := if( valType( SysConfig("System:cTypPanel")) = 'A', '0', SysConfig("System:cTypPanel"))

* OR LIKE THIS
* Start menu dialog in new thread
*-  oMenu := drgDialogThread():new()

  IF Upper(AllTrim( drgINI:appName)) == 'ASYSTEM++' .or. Upper(AllTrim( drgINI:appName)) == 'ASYSTEM++_SKL'
    ( drgDBMS:open('USERS')   , USERS->( dbSeek(Upper(usrName),,'USERS01')))
    ( drgDBMS:open('USERSGRP'), USERSGRP->( dbSeek(Upper(USERS->cGroup),,'USERSGRP01')))
    do case
    case .not. Empty(USERS->mMenuUser)
      oMenu:start(,'drgMenu,UserMenu', oDlg)
    case .not. Empty(USERSGRP->mMenuGroup)
      oMenu:start(,'drgMenu,GroupMenu', oDlg)
    otherwise
      if usrName = 'admin' .or. At('ADMIN',USERS->cOpravneni) > 0
        oMenu:start(,'drgMenu,Asystem++_menu', oDlg)       //'drgMenu,SKL_menu'
      else
        drgMsgBox(drgNLS:msg('Uživatel nemá nastaven pøístup do systému !'))
        QUIT
      endif
    endcase
  ELSE
    DO CASE
    CASE Upper( drgINI:appName) = "OSOBY"           ; cX := "OSB"
    CASE Upper( drgINI:appName) = "DOCHAZKA"        ; cX := "DOH"
    CASE Upper( drgINI:appName) = "ASYSTEM++_ADD"   ; cX := "ASYSTEM++_ADD"
    CASE Upper( drgINI:appName) = "JSU_ASYSTEM++"   ; cX := "JSU_ASYSTEM++"
    CASE Upper( drgINI:appName) = "JTR_ASYSTEM++"   ; cX := "JTR_ASYSTEM++"
    CASE Upper( drgINI:appName) = "MPR_ASYSTEM++"   ; cX := "MPR_ASYSTEM++"

      ( drgDBMS:open('USERS')   , USERS->( dbSeek(Upper(usrName),,'USERS01')))
      ( drgDBMS:open('USERSGRP'), USERSGRP->( dbSeek(Upper(USERS->cGroup),,'USERSGRP01')))
      do case
      case usrname = 'admin'
        oMenu:start(,'drgMenu,MPR_ASYSTEM++_menu', oDlg)
      case .not. Empty(USERS->mMenuUser)
        oMenu:start(,'drgMenu,UserMenu', oDlg)
      case .not. Empty(USERSGRP->mMenuGroup)
        oMenu:start(,'drgMenu,GroupMenu', oDlg)
      otherwise
        oMenu:start(,'drgMenu,MPR_ASYSTEM++_menu', oDlg)
      endcase

    OTHERWISE                                       ; cX := Left( drgINI:appName, 3)
    ENDCASE
    cX := cX +"_menu"
    oMenu:start(,'drgMenu,' +cX, oDlg)       //'drgMenu,SKL_menu'
  ENDIF

  *
  ** úprava pro SYS_ADMIN - DIS_ADMIN - DLS_ADMIN - lze odblokovat celé zpracování mezd
  if upper( defaultDisUsr( 'MZD', 'BLOCKOBDMZDY')) = 'NE'
    drgINI:l_blockObdMzdy  := .F.
  endif
  *
  ** je nastartovnaý objekt osplash_for_start ?
  if( isObject( osplash_for_start), osplash_for_start:hide(), nil )


  * smažene pracovní adresáøe - pøi startu - pokud to spadne zùstaly by tam
  if( isWorkVersion, nil, erase_userWorkDir() )

  * pøi startu A++ ovìøíme záznamy ve WDS pro usrName, pokud by tan zùstaly smažeme
  * jedná se o jakýkoliv pád A++
  wds_resetUsers_inStart()

  * nastaví odkaz na vlastní firmu (èíslo firmy) v adresáøi firem
  drgDBMS:open('firmy',,,,,'firmyx')
  MyFIRMA := if( firmyx->( dbseek( 1,,'FIRMY18')), firmyx->ncisfirmy, 0)
  firmyx->( dbCloseArea())

*

*  cSQL := "SELECT ncisfirmy,cnazev,cmisto FROM firmy;"
*  USE (cSQL) ALIAS Test NEW

*  use cenzboz

*  onazev := DacField():QueryObject("cenzboz->cnazzbo")
*  ocenzboz := DacSDataset():QueryObject("cenzboz")
*  oZip      := ocenzboz:QueryField("nmnozszbo")

*  Browse()

 * Event LOOP. Just wait until menu thread terminates
* BEGIN SEQUENCE

   if isWorkVersion                                                             // musím to zablokovat, jednak to zdržuje a nedá se ladit
**     drgTaskManager := drgTaskManager():new()
**     drgTaskManager:start()
   endif

   WHILE (nEvent := AppEvent( @mp1, @mp2, @oXbp ) ) != drgDIALOG_END
     oXbp:HandleEvent( nEvent, mp1, mp2 )
   ENDDO

* RECOVER using oError
* END SEQUENCE

  drgServiceThread:terminated := .t.

**  if( isWorkVersion, drgTaskManager:terminated := .t., nil )                  // musím to zablokovat, jednak to zdržuje a nedá se ladit

/* END OR LIKE THIS */
* smažene pracovní adresáøe - pøi ukonèení

  if( isWorkVersion, nil, erase_userWorkDir() )

* On destroy save last dialog positions to file.
  IF AllTrim( drgINI:appName) == 'ASYSTEM++'
    if Users->(dbRlock())
      Users->dPrihlUser := CtoD('  .  .    ')
      Users->cPrihlUser := ''
      Users->(dbUnlock())
    endif
  ENDIF

  drgScrPos:destroy()

* uložení nastavených období pro úlohy na uživatele
  save_mobdUsers()

* Save var values for next program session
  drgSaveINI(drgINI:dir_USER + 'User.ini','visualStyle')
  drgSaveINI(cSaveFile,'drgINI:PrinterName,myNumber,myDate')
  drgSaveINI(winapi_getUserPrivatePath()+'\Asystem++\asysuser.ini','logFirma,logUser')

  DBCOMMITALL()
  DBCLOSEALL()

  if( isObject(oSession_free), oSession_free:disconnect(), nil )
  if( isObject(oSession_sys),  oSession_sys:disconnect(), nil )
  if( isObject(oSession_data), oSession_data:disconnect(), nil )

//   pozor tady to houkne a neukonèí proces
  odlg:destroy()
  QUIT

*  end_ofMain()
RETURN


*
** blbne nám QUIT - až budeme mít trochu èas muíme to najít
**                  nìjak to souvisí s vlákny a jejich nekorektním ukonèením
**                  jedná se o omenu a drgServiceThread
function end_ofMain()
  local bSaveErrorBlock

  bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )

  begin sequence
    QUIT
  recover using oError
  end sequence

  ErrorBlock(bSaveErrorBlock)
return .t.


*
** zrušení pracovních adresáøú uživatele
function erase_userWorkDir()
  local  cwork := drgINI:dir_USERfitm, adir, x

  adir  := directory( cwork +'dir_*', 'D' )
  *
  for x := 1 to len(adir) step 1
    aeval( directory( cwork +adir[x,1] +'\' ), { |afile| ferase( cwork +adir[x,1] +'\'+ afile[1] ) })
    removedir(cwork +adir[x,1])
  next
  *
  aeval( directory( cwork ), { |afile| ferase( cwork +afile[1] ) })
return nil

*
** uložení nastavených období pro úlohy na uživatele
static function save_mobdUsers()
  local  pa := uctOBDOBI:a_mobdUser
  local  nin
  *
  local  mobdUser := ''

  for nin := 1 to len(pa) step 1
    mobdUser += pa[nin,1] +',' +pa[nin,2] +';'
  next

  if users->( dbRlock())
    users->mobdUser := subStr( mobdUser, 1, len( mobdUser) -1 )
    Users->(dbUnlock())
  endif
return nil


*
** ovìøíme systémové soubory
static function check_sysFiles()
  local bSaveErrorBlock

  bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )

  begin sequence
    *
    ** pokud licasys exclusive - jsem tam sám
    *
    drgDBMS:open('licasys',.t.,,drgINI:dir_SYSTEM)
    licasys->(dbCloseArea())

    drgDBMS:checkDB({'asysini','licasys'} )
  recover using oError
  end sequence

  ErrorBlock(bSaveErrorBlock)
return .t.


**************************************************************************
* FUNCTION to check password enetered
**************************************************************************
FUNCTION checkPswdFunction(fir, usr, pwd)
* Dummy check. It is up to you how to implement this
RETURN LOWER(ALLTRIM(usr)) == LOWER(ALLTRIM(pwd))



**************************************************************************
* Declaration of PUBLIC visible variables with initial values set.
**************************************************************************
PROCEDURE dclUsrPublicVars()
  local oinfo, cbuild

PUBLIC myCompanyName    := 'MISS Software, s.r.o.'
PUBLIC myCompanyAdress1 := 'Studentské námìstí 1531'
PUBLIC myCompanyAdress2 := 'Uherské Hradištì'
PUBLIC myNumber         := 100
PUBLIC myDate           := STOD('20050901')
PUBLIC isDemoVersion    := .T.
PUBLIC isWorkVersion    := .F.
PUBLIC isRunTaskManager := .T.

PUBLIC isdeSysLock      := .F.
PUBLIC isRestFRM        := .T.
PUBLIC isDataTypeDBF    := .F.
PUBLIC syCheckDB        := 0
PUBLIC recFirma         := 0
PUBLIC MyFIRMA          := 0   // vazba na vlastní firmu v adresáøi firem
PUBLIC obdReport        := ''

PUBLIC obdKeyML         := ''

PUBLIC verzeAsys        := LoadResource(1, XPP_MOD_EXE, RES_VERSION)
PUBLIC usrName          := ''   // zkratka uživatele
PUBLIC usrOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
PUBLIC logFirma         := ''   // pøihlašovací jméno firmy
PUBLIC logUser          := ''   // pøihlašovací jméno uživatele
PUBLIC logOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
PUBLIC logCisOsoby      := 0    // osobní èíslo pøihlášené osoby - uživatele
PUBLIC syOpravneni      := ''

PUBLIC SpecialBuild     := ''

PUBLIC typPanel           := ''
PUBLIC istriggers_pvpitem := .f.

// nastavení pro users.ini
PUBLIC visualStyle      := .f.
//PUBLIC noaktivRGB       := 248


  oinfo  := TFileVersionInfo():New( AppName(.f.) )
  cbuild := oinfo:QueryValue(1,"SpecialBuild")
  oinfo:destroy()

  verzeAsys[3,2] := Padl(AllTrim(verzeAsys[3,2]),13,'0')
  verzeAsys[8,2] := Padl(AllTrim(verzeAsys[8,2]), 8,'0')


  SpecialBuild := if( .not. empty(cbuild), Padl(AllTrim(Left(cbuild,7)), 7, '0' ), '00.0000' )
//  SpecialBuild := Padl(AllTrim( SpecialBuild), 8, '0' )
//  SpecialBuild := strTran( SpecialBuild, chr(0), '' )
  istriggers_pvpitem := val( subStr( verzeAsys[3,2], 4, 2 )) >= 8


RETURN


PROCEDURE dclDefaultInitVars()
  local  npos
  local  cx

  if isWorkVersion
    *
    ** úprava dir_DATA
    npos := rat('\', drgINI:dir_DATA)
    drgINI:add_FILE  := subStr(drgINI:dir_DATA, npos +1)
    drgINI:dir_DATA  := subStr(drgINI:dir_DATA, 1      , npos)
  else
    drgINI:dir_SYSTEM   += IF( Right( AllTrim(drgINI:dir_SYSTEM),1)=="\", "", "\")
    drgINI:dir_DATA     += IF( Right( AllTrim(drgINI:dir_DATA),1)=="\",   "", "\")
    drgINI:dir_USER     += IF( Right( AllTrim(drgINI:dir_USER),1)=="\",   "", "\")
  endif

  if( empty(drgINI:dir_DATAroot), drgINI:dir_DATAroot := drgINI:dir_DATA, nil)

// nastavení default hodnoty
  IF( Empty(drgINI:dir_USERfi)                                     ;
        , drgINI:dir_USERfi   := drgChkDirName( drgINI:dir_USER), NIL)
  IF( Empty(drgINI:dir_USERfitm)                                   ;
        , drgINI:dir_USERfitm := drgChkDirName( drgINI:dir_USERfi) + 'TMP\', NIL)
  IF( Empty(drgINI:dir_RSRC)                                       ;
        , drgINI:dir_RSRC     := drgChkDirName( drgINI:dir_SYSTEM) + 'RESOURCE\', NIL)
  IF( Empty(drgINI:dir_WORK)                                       ;
        , drgINI:dir_WORK     := drgChkDirName( drgINI:dir_USERfi) , NIL)

// úprava drgINI:dir_RSRC pro vylouèení pøíslušného portu pøi volání RSRC JT 16.05.2018

  if At('\\',drgINI:dir_RSRC) > 0
    if ( npos := At(':',drgINI:dir_RSRC)) > 0
      cx :=  SubStr( drgINI:dir_RSRC, 1, npos-1)
      if ( npos := At('\', drgINI:dir_RSRC, npos)) > 0
        drgINI:dir_RSRC := cx + SubStr( drgINI:dir_RSRC, npos)
      endif
    endif
  endif
RETURN


PROCEDURE ModiFirmaCFG()
  LOCAL cX
  LOCAL modiARR := { {'CPODNIK',    'CNAZFIRMY'}        ;
                    ,{'CULICEORG',  'CULICE'}           ;
                    ,{'CCISPOPORG', 'CCISPOPIS'}        ;
                    ,{'CULICE',     'CULICE'}           ;
                    ,{'CPSC',       'CPSC'}             ;
                    ,{'CSIDLO',     'CMISTO'}           ;
                    ,{'CZKRSTAORG', 'CZKRSTAT'}         ;
                    ,{'CZKRNAZPOD', 'CZKRNAZEV'}        ;
                    ,{'NICO',       'CICO'}             ;
                    ,{'CDIC',       'CDIC'}}


  drgDBMS:open('CONFIGHD')

  for n := 1 to Len( modiARR)
    CONFIGHD->(DbLocate({|| AllTrim(Upper(CONFIGHD->cItem)) == modiARR[n,1]}))
    CONFIGHD->(dbRlock())
    do case
    case modiARR[n,1] == 'CULICE'
      CONFIGHD->cValue := AllTrim(LicAsys->CULICE) + ' '+AllTrim(LicAsys->CCISPOPIS)
      myCompanyAdress1 := CONFIGHD->cValue
    otherwise
      CONFIGHD->cValue := &('LicAsys->' +modiARR[n,2])
    endcase
  next

  myCompanyName    := LicAsys->CNAZFIRMY
  myCompanyAdress2 := LicAsys->CMISTO
  CONFIGHD->( dbUnlock())

RETURN


// doèasná funkce pro práci s pùvodním systémem
function CS2KEY( cKey)
return(cKey)