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
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"
#include "dmlb.ch"
#include "ads.ch"
#include "odbcdbe.ch"

#pragma library ("Xppui2.lib")
#pragma library ("ADSUTIL.lib")
#pragma library( "ADAC20B.LIB" )
#pragma library("odbcut10.lib")

**************************************************************************
* Application initialization. Good place to create PUBLIC defined objects and vars.
**************************************************************************
PROCEDURE AppSYS()
local  oDlg

LOCAL  cDrive, cDirAdr, cAPPname
PUBLIC drgINI, drgRef, drgDBMS, drgFormManager, drgServiceThread
PUBLIC drgNLS, drgScrPos, drgLog, drgPP, drgHelp
*
PUBLIC osplash_for_dialog, osplash_for_start
PUBLIC drgTaskManager


  SET CHARSET TO ANSI
  SET DELETED ON
  SET CENTURY ON
  SET EXACT ON
  SET SOFTSEEK OFF
  SET EPOCH TO 1949
  SET TIME TO HH:MM:SS

  * splash for start

  // JS aù n·m tam nesvÌtÌ pokud testujem
  #ifndef WORK_VERSION
    osplash_for_start := displayLogo()
  #endif

  * Create DRG global parameters object
  drgIni := drgIni():new()
  drgINI:appName := LEFT(AppName(), AT('.', AppName()) -1)

  dclUsrPublicVars()
  if( file('Asystem++.ini'), drgReadINI('Asystem++.ini'), nil)

  drgServiceThread := drgServiceThread():new()
  drgServiceThread:start()

**  drgRef := drgRef():new()
/* p¯esunuto do  asystem++_main
* Uncomment for (eg. Slovenian) localized DRG messages. Original DRG messages are all english (EN).
  drgINI:nlsDRGLoc := 'CZ'
* Uncomment for multilingual user application written in English.
  drgINI:nlsAPPorg := 'CZ'
  drgINI:nlsAPPLoc := 'CZ'
  drgNLS    := drgNLS():new()
  drgNLS:readMsgFile('drgMSG',.T.)
  drgNLS:readMSGFile('appMSG',.F.)
*/
  drgFormManager := drgFormManager():new()

* Presentation parameters
  drgPP     := drgPP():new()
/*
* Update list of available printers
  drgPrinterCreateList()
* ADD values for preview and print to file to printer list
  AADD(drgINI:printerList,{ drgNLS:msg('Screen preview'),'HTML','out.htm', '72', '70',''} )
  AADD(drgINI:printerList,{ drgNLS:msg('Print to file'),'TAB','out.prn', '72', '70', '852'} )
*/
RETURN

**************************************************************************
* Database drivers initialization. Load only Clipper compatible drivers.
**************************************************************************
PROCEDURE DBESYS()
  SET DATE TO GERMAN
*
  IF !DbeLoad( "FOXDBE", .T.)
    Alert( "Database engine FOXDBE not loaded" , {"OK"} )
  ENDIF

  IF !DbeLoad( "CDXDBE",.T.)
    Alert( "Database-Engine CDXDBE not loaded" , {"OK"} )
  ENDIF

  IF !DbeBuild( "FOXCDX", "FOXDBE", "CDXDBE" )
    Alert( "FOXCDX Database-Engine;is not created" , {"OK"} )
  ENDIF

  IF ! DbeLoad( "ODBCDBE" )
    Alert( "Database Engine ADSDBE not loaded" , {"OK"} )
  ENDIF

  IF ! DbeLoad( "ADSDBE", .F. )
    Alert( "Database Engine ADSDBE not loaded" , {"OK"} )
  ENDIF
  DbeSetDefault( "ADSDBE" )

  if isDataTypeDBF
// --------------- DBF --------------------------------------------
    DbeInfo( COMPONENT_DATA,  ADSDBE_TBL_MODE,  ADSDBE_CDX)
    DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, "CDX")
    DbeInfo( COMPONENT_DATA,  ADSDBE_LOCK_MODE, ADSDBE_COMPATIBLE_LOCKING)
  else

// --------------- ADT --------------------------------------------
    DbeInfo( COMPONENT_DATA,  ADSDBE_TBL_MODE, ADSDBE_ADT)
    DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_ADT)
    DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, "ADI")
  endif
RETURN