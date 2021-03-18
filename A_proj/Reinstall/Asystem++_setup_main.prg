#include "Appevent.ch"
#include "Common.ch"
#include "Dll.ch"
#include "Font.ch"
#include "Foxdbe.ch"
#include "Gra.ch"
#include "xbp.ch"

#include "ads.ch"
#include "adsdbe.ch"

#include "drg.ch"

#include "XbZ_Zip.ch"


#define xbeP_Eval    xbeP_User + 1


**************************************************************************
* Here is where everything starts. Every XBase++ has to have one (and one only)
* Main procedure defined. Main procedure is the program entry point.
**************************************************************************
PROCEDURE Main()
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
  local   oinfo, oDlg
  local   osetup
  *
  local   cConnect, curDir, phConnect
  *
  local   cCurDir     := if( empty( CurDrive()), CurDir(), CurDrive() +':\' +CurDir( curDrive()) ) +'\'
  local   csystem_Azf := cCurDir + 'A++_System.azf'
  local   csystem_Dir := cCurDir + 'system'
  *
  local   cdata_Azf   := cCurDir +'A++_Data.azf'
  local   cdata_Dir   := cCurDir +'data'
  *
  local   csystem_Arc

  local   ozip
  *
  public  oSession_free, oSession_data
  public  usrIdDB      := 0
  public  syApa        := 'V73ra5-xWdeYa46í8øK2'
  public  cdistrib_Dir := ''
  public  ccurrent_Dir := cCurDir +'\'

  *
  * jako první MUSÍM rozablit reinstalaèní balíèek
  if .not. isWorkVersion
    createDir(csystem_Dir)
    ozip := XbZLibZip():New( csystem_Azf, XBZ_OPEN_READ)
    ozip:Extract( csystem_Dir, '*.dbd', .t., XBZ_OVERWRITE_ALL )
    ozip:Extract( csystem_Dir, '*.arc', .t., XBZ_OVERWRITE_ALL )
    ozip:close()

    drgINI:dir_RSRC     := csystem_Dir +'\'
    drgINI:dir_USERfitm := cCurDir     +'\'

    createDir(cdata_Dir)
    ozip := XbZLibZip():New( cdata_Azf, XBZ_OPEN_READ)
    ozip:Extract( cdata_Dir, '*.*', .t., XBZ_OVERWRITE_ALL )
    ozip:close()

    cdistrib_Dir := cdata_Dir +'\'

    csystem_Arc := csystem_Dir +'\' +'ASYSTEM++_ver_DB.arc'
  else
    * bacha pro test

    cdistrib_Dir := cdata_Dir +'\'

    csystem_Arc := drgINI:dir_RSRC  +'ASYSTEM++_ver_DB.arc'
  endif

  * musíme naèíst verzi DB
  if( file(csystem_Arc), drgReadINI(csystem_Arc), nil )

  * základní okno
  oDlg := XbpDialog():new( AppDesktop(), , {10, 10}, {10, 10},,.F.)
  oDlg:taskList := .F.
  oDlg:create()

  * info o souboru
***  oinfo := TFileVersionInfo():New( AppName(.f.) )
***  SpecialBuild := oinfo:QueryValue(1,"SpecialBuild")
***  oinfo:destroy()
  *
  *
  drgLog    := drgLog():new()
  drgScrPos := drgScrPos():new()

  dclDefaultInitVars()

  drgRef  := drgRef():new()
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
  drgDBMS := drgDBMS():new()
  drgDBMS:loadDBD()

  * connect to the ADS free-server                drgINI:dir_DATA
  cConnect      := "DBE=ADSDBE;SERVER="  +AllTrim(drgINI:dir_USER) +";ADS_LOCAL_SERVER"
  oSession_free := dacSession():New( cConnect)

  * check if we are connected to the ADS free-server
  if .not. ( oSession_free:isConnected() )
    drgMsgBox(drgNLS:msg('Nelze se pøipojit na >FREE< server ADS !!!'))
    QUIT
  endif

  phConnect := oSession_free:getConnectionHandle()
  osetup    := drgDialogThread():new()

  * blbne COMMITALL DBCLOSEALL
  osetup:cargo := -1
  osetup:start( ,'AsystemLogin', oDlg)

  WHILE (nEvent := AppEvent( @mp1, @mp2, @oXbp ) ) != drgDIALOG_END
    oXbp:HandleEvent( nEvent, mp1, mp2 )
  ENDDO

  drgServiceThread:terminated := .t.


**  if( isObject(oSession_free), oSession_free:disconnect(), nil )
  if( isObject(oSession_free), AdsDisconnect( phConnect ), nil )
  *
  * smažene pracovní adresáøe - pøi ukonèení
  if .not. isWorkVersion
    erase_userWorkDir( csystem_Dir, cdata_Dir )
  endif

  odlg:destroy()
  QUIT


**  QUIT

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
** zrušení pracovních adresáøú
static function erase_userWorkDir( csystem_Dir, cdata_Dir )
  local  cwork := drgINI:dir_USERfitm, adir, x

  * TMP - pracovní adresáø
  adir  := directory( cwork +'dir_*', 'D' )
  *
  for x := 1 to len(adir) step 1
    aeval( directory( cwork +adir[x,1] +'\' ), { |afile| ferase( cwork +adir[x,1] +'\'+ afile[1] ) })
    removedir(cwork +adir[x,1])
  next
  *
  * SYSTEM
  aeval( directory( csystem_Dir + '\' ), { |afile| ferase( csystem_Dir +'\'+ afile[1] ) })
  removedir( csystem_Dir )
  *
  * DATA
  aeval( directory( cdata_Dir + '\' ), { |afile| ferase( cdata_Dir +'\'+ afile[1] ) })
  removedir( cdata_Dir )
return nil




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
**   local  ver_DB_arc := 'ASYSTEM++_ver_DB.arc', cc

   PUBLIC myCompanyName    := 'MISS Software, s.r.o.'
   PUBLIC myCompanyAdress1 := 'Mlýnská 1228'
   PUBLIC myCompanyAdress2 := 'Uherské Hradištì'
   PUBLIC myNumber         := 100
   PUBLIC myDate           := STOD('20050901')
   PUBLIC isDemoVersion    := .T.
   PUBLIC isWorkVersion    := .F.
   PUBLIC isdeSysLock      := .F.
   PUBLIC isRestFRM        := .T.
   PUBLIC isDataTypeDBF    := .F.      // ---- ok
   PUBLIC syCheckDB        := 0
   PUBLIC recFirma         := 0
   PUBLIC obdReport        := ''

   PUBLIC verzeAsys        := LoadResource(1, XPP_MOD_EXE, RES_VERSION)
   PUBLIC usrName          := ''   // zkratka uživatele
   PUBLIC usrOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
   PUBLIC logFirma         := ''   // pøihlašovací jméno firmy
   PUBLIC logUser          := ''   // pøihlašovací jméno uživatele
   PUBLIC logOsoba         := ''   // celé jméno pøihlášené osoby - uživatele
   PUBLIC syOpravneni      := ''

   PUBLIC SpecialBuild     := '0.0'

   * tato úprava je vazba na drgLog, jinak to tam spadne
   if empty( verzeAsys)
     verzeAsys := { {}, {}, { , 'setup' } }
   endif
RETURN


PROCEDURE dclDefaultInitVars()
  local  npos

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
        , drgINI:dir_RSRC     := drgChkDirName( drgINI:dir_SYSTEM) + 'RESOURCE\RSRC\', NIL)
  IF( Empty(drgINI:dir_WORK)                                       ;
        , drgINI:dir_WORK     := drgChkDirName( drgINI:dir_USERfi) , NIL)
RETURN


PROCEDURE ModiFirmaCFG()
  local n
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