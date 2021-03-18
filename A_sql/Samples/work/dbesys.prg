////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DBESYS.PRG
//
//  DbeSys() is called automatically at program start before the function MAIN.
//
////////////////////////////////////////////////////////////////////////////////////////////////////

#INCLUDE "adsdbe.CH"
#INCLUDE "common.CH"

#define MSG_DBE_NOT_LOADED   " database engine not loaded"
#define MSG_DBE_NOT_CREATED  " database engine could not be created"

#define INDEX_TYPE  "CDX"
#define COMPATIBLE  TRUE

*******************************************************************************
* DbeSys() is always executed at program startup
*******************************************************************************

PROCEDURE dbeSys()

LOCAL i
LOCAL aDbes := { {"FOXDBE", .T.},{"CDXDBE", .T.},{"DBFDBE",.t.},{"NTXDBE",.t.} }
LOCAL aBuild :={ {"FOXCDX", 1, 2 }, {"DBFNTX", 1, 2 } }

//  Set the sorting order and the date format
SET COLLATION TO AMERICAN
SET DATE TO AMERICAN

// load database engines
FOR i:= 1 TO len(aDbes)
  IF ! DbeLoad( aDbes[i][1], aDbes[i][2])
    Alert( aDbes[i][1] + MSG_DBE_NOT_LOADED , {"OK"} )
  ENDIF
NEXT i

// create database engines
FOR i:= 1 TO len(aBuild)
  IF ! DbeBuild( aBuild[i][1], aDbes[aBuild[i][2]][1], aDbes[aBuild[i][3]][1])
    Alert( aBuild[i][1] + MSG_DBE_NOT_CREATED , {"OK"} )
  ENDIF
NEXT i

dbeSetDefault('FOXCDX')

// Add  this code to use ADS
IF !LoadAds(INDEX_TYPE, COMPATIBLE)
  QUIT
ENDIF

RETURN

/*
Add the below code to your DBESYS.PRG to enable Advantage Server
*/

* --------------

FUNCTION LoadAds( cExt, lCompatibleLocking )

LOCAL lAdsCompatible, cAdsServer, cSession, oAdsSession, cError

DEFAULT lCompatibleLocking TO .T.
DEFAULT cExt TO 'CDX'

IF !"ADSDBE" $ DbeList()
  IF ! DbeLoad( "ADSDBE" )
    Alert( "Unable to load ADSDBE", "ADS Server")
    RETURN .f.
  ENDIF
ENDIF

cAdsServer := CurDrive() + ":"
cSession := "DBE=ADSDBE;SERVER=" + cAdsServer
oAdsSession := DacSession():new(cSession)

IF !oAdsSession:isConnected()
  cError := "Error Code: " + Alltrim(Str(oAdsSession:getLastError())) + ;
            Chr(13) + oAdsSession:getLastMessage()
  Alert( "Unable to establish connection to ADS Server" + Chr(13) + cError, 'ADS Server' )
  RETURN .f.
ENDIF

AdsSession( oAdsSession )
dbeSetDefault('ADSDBE')
IF cExt == 'CDX'
  DbeInfo( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_CDX )
  DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_CDX )
ELSE
  DbeInfo( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_NTX )
  DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_NTX )
ENDIF

IF lCompatibleLocking
  DbeInfo( COMPONENT_DATA, ADSDBE_LOCK_MODE, ADSDBE_COMPATIBLE_LOCKING  )
ELSE
  DbeInfo( COMPONENT_DATA, ADSDBE_LOCK_MODE, ADSDBE_PROPRIETARY_LOCKING  )
ENDIF

RETURN .t.

* --------------

FUNCTION AdsSession( oAdsSession )

STATIC soAdsSession

IF PCount() == 1
  soAdsSession := oAdsSession
ENDIF

RETURN soAdsSession

*--------------------------------------

EXIT PROCEDURE AdsDisconnect

LOCAL oSession := AdsSession()

IF Valtype(oSession) == 'O' .AND. oSession:isConnected()
  oSession:disconnect()
ENDIF

RETURN

