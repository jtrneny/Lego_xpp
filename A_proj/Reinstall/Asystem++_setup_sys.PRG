#include "Common.ch"
#include "drg.ch"
#include "xbp.ch"
#include "gra.ch"
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"


PROCEDURE AppSYS()
  LOCAL  cDrive, cDirAdr, cAPPname
  *
  PUBLIC drgINI, drgRef, drgDBMS, drgFormManager, drgServiceThread
  PUBLIC drgNLS, drgScrPos, drgLog, drgPP, drgHelp
  *
  PUBLIC osplash_for_dialog


  SET CHARSET TO ANSI
  SET DELETED ON
  SET CENTURY ON
  SET EXACT ON
  SET SOFTSEEK OFF
  SET EPOCH TO 1949

* Create DRG global parameters object
  drgIni := drgIni():new()
  drgINI:appName := LEFT(AppName(), AT('.', AppName()) -1)

  dclUsrPublicVars()
  if( file('Asystem++.ini'), drgReadINI('Asystem++.ini'), nil)

  drgServiceThread := drgServiceThread():new()
  drgServiceThread:start()

  drgFormManager := drgFormManager():new()

* Presentation parameters
  drgPP     := drgPP():new()

  *
  SET(_SET_DATEFORMAT, 'dd.mm.yyyy')
  SET NULLVALUE off
RETURN


*
***
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