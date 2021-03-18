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
#include "drg.ch"
#include "xbp.ch"
#include "gra.ch"

**************************************************************************
* Application initialization. Good place to create PUBLIC defined objects and vars.
**************************************************************************
PROCEDURE AppSYS()
LOCAL  cDrive, cAPPname
PUBLIC drgINI, drgRef, drgDBMS, drgFormManager, drgServiceThread
PUBLIC drgNLS, drgScrPos, drgLog, drgPP, drgHelp
PUBLIC usrIdDB


  SET CHARSET TO ANSI
  SET DELETED ON
  SET CENTURY ON
  SET EXACT ON
  SET SOFTSEEK OFF

  * impicitnì nastaveno ON ...  aplication closes itself
  SET OPTIMIZE OFF
  SET SMARTFILTER OFF
  SET RUSHMORE OFF
  *

* Create DRG global parameters object
  drgIni := drgIni():new()
  drgINI:appName := LEFT(AppName(), AT('.', AppName()) -1)

  * Nìkterá nastaveí prostøedí
  cDrive := CurDrive()
  drgINI:dir_DATA := drgINI:dir_APP
  drgINI:dir_RSRC := drgINI:dir_APP + '\RSRC\'
  drgINI:dir_WORK := drgINI:dir_APP + '\TMP\'
  drgINI:defTextBGND := 1   //   default je XBPSTATIC_TYPE_RAISEDBOX
*  drgINI:defFontSize := 9  // default je 8

  dclUsrPublicVars()
  drgReadINI('myApp.ini')
* Usefull on network. One ini for everyone. And when a workstation needs something
* different (eg. printer port) put another ini file on the work directory of that station.
  drgReadINI(drgINI:dir_WORK + 'myApp.ini')

  drgServiceThread := drgServiceThread():new()
  drgServiceThread:start()

  drgLog    := drgLog():new()
  drgScrPos := drgScrPos():new()

  drgRef    := drgRef():new()

* Uncomment for (eg. Slovenian) localized DRG messages. Original DRG messages are all english (EN).
  drgINI:nlsDRGLoc := 'CZ'
* Uncomment for multilingual user application written in English.
  drgINI:nlsAPPorg := 'CZ'
  drgINI:nlsAPPLoc := 'CZ'
  drgNLS    := drgNLS():new()
  drgNLS:readMsgFile('drgMSG',.T.)
  drgNLS:readMSGFile('appMSG',.F.)
*

  drgFormManager := drgFormManager():new()
  drgHelp   := XbpHelp():new():create( SetAppWindow(), drgINI:dir_APP + drgINI:appName +".chm", "myApp Help file")

* Presentation parameters
  drgPP     := drgPP():new()

* Update list of available printers
  drgPrinterCreateList()
* ADD values for preview and print to file to printer list
  AADD(drgINI:printerList,{ drgNLS:msg('Screen preview'),'HTML','out.htm', '72', '70',''} )
  AADD(drgINI:printerList,{ drgNLS:msg('Print to file'),'TAB','out.prn', '72', '70', '852'} )

RETURN

**************************************************************************
* Database drivers initialization. Load only Clipper compatible drivers.
**************************************************************************
PROCEDURE DBESYS()

// SET DATE TO SYSTEM doesn't work for Slovenia on WIN NT. This is the safe way.
  SET DATE TO GERMAN

  IF !DbeLoad( "FOXDBE", .T.)
    Alert( "Database engine FOXDBE not loaded" , {"OK"} )
  ENDIF

  IF !DbeLoad( "CDXDBE",.T.)
    Alert( "Database-Engine CDXDBE not loaded" , {"OK"} )
  ENDIF

  IF !DbeBuild( "FOXCDX", "FOXDBE", "CDXDBE" )
    Alert( "FOXCDX Database-Engine;is not created" , {"OK"} )
  ENDIF

   /*
    * Load ADS database engine and register it as default DBE;
    * there is no need to load it "hidden", because we don't build
    * a compound DBE
    */
   IF ! DbeLoad( "ADSDBE", .F. )
      Alert( "Database Engine ADSDBE not loaded" , {"OK"} )
   ENDIF
   DbeSetDefault( "ADSDBE" )

RETURN