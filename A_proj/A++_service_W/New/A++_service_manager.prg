#include "service.ch"
#include "os.ch"
#include "simpleio.ch"
#include "common.ch"

#include "..\Asystem++\Asystem++.ch"


CLASS Logger
  EXPORTED:
    INLINE METHOD write( cMsg )
      MsgBox( cMsg )
  RETURN SELF
ENDCLASS


PROCEDURE AppSys()

  SET CHARSET TO ANSI
  SET DELETED ON
  SET CENTURY ON
  SET EXACT ON
  SET SOFTSEEK OFF
  SET EPOCH TO 1949
  SET(_SET_DATEFORMAT, 'dd.mm.yyyy')
  SET NULLVALUE off
RETURN


PROCEDURE Main( cServiceName, cFlag, cUser, cPass )
  local cLocation, oLog, oCtrl, lOk := .f.
  local cMessage

  default cServiceName to "A++_service_task", cFlag to "i", ;
          cUser        to ""                , cPass to ""


  cLocation    := CurDrive() + ":\" + CurDir() + "\"
  oLog         := Logger():new()
  oCtrl        := ServiceController()

  oCtrl:addController( cServiceName ,                       ;
                       cServiceName   , ;
                       cLocation + "A++_service_task.exe", ;
                       cUser, cPass,  /*parameter*/ , ;
                       oLog )


  DO CASE
  CASE cFlag == "i"
    lOk := oCtrl:install( cServiceName )
    cMessage := if( lOk, "služba byla nainstalována...", "služba nebyla nainstalována..." )
  CASE cFlag == "s"
    lOk := oCtrl:start( cServiceName )
    cMessage := if( lOk, "služba byla spuštìna...", "služba nebyla spuštìna..." )
  CASE cFlag == "x"
    lOk := oCtrl:stop( cServiceName )
    cMessage := if( lOk, "služba byla zastavena...", "služba nebyla zastavena..." )
  CASE cFlag == "u"
    lOk := oCtrl:uninstall( cServiceName )
    cMessage := if( lOk, "služba byla odinstalována...", "služba nebyla odinstalována..." )
  CASE cFlag == "r"
    lOk := oCtrl:removeByName( cServiceName )
    cMessage := if( lOk, "služba byla odstranìna...", "služba nebyla odstranìna..." )
  OTHERWISE
    Quit
  ENDCASE

  MsgBox( cMessage )
RETURN