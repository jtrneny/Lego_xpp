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

  dclUsrPublicVars()
//  if( file('A++_service.ini'), drgReadINI('A++_service.ini'), nil)
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

// --------------- ADT --------------------------------------------
  DbeInfo( COMPONENT_DATA,  ADSDBE_TBL_MODE, ADSDBE_ADT)
  DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_ADT)
  DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, "ADI")

RETURN