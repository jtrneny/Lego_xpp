//////////////////////////////////////////////////////////////////////
//
//  SIMPLECTR.PRG
//
//  Copyright:
//     Alaska Software, (c) 2002-2006. All rights reserved.
//
//  Contents:
//     Application for controlling the service simpleservice.exe
//
//  Syntax:
//     simplectr <isxu> [".\AccountName" "Passwort"]
//
//     Flags:
//
//        i installs the service simpleservice.exe
//          When installing the service the account name and the
//          password of this account become mandatory parameters.
//          ( Note: Point and Backslash (".\") must prefix the
//                  account name )
//        s starts the service
//        x stopps the service
//        u deinstalls the service
//
//     Debugging:
//
//        To debug the service, start it with:
//
//          XppDbg simpleservice.exe
//
//////////////////////////////////////////////////////////////////////

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
#include "os.ch"

#include "COLLAT.CH"
#include "DMLB.CH"
#include "GET.CH"
#include "MEMVAR.CH"
#include "NATMSG.CH"
#include "PROMPT.CH"
#include "SET.CH"
#include "STD.CH"


#include "Asinetc.ch"

#include "..\Asystem++\Asystem++.ch"

#include "service.ch"

//REQUEST Scatter  // from \SOURCE\SYS\BLOCKS.PRG


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

/*
FUNCTION ChkOsVersion()
  LOCAL cFamily, cFullName

  cFamily := Os( OS_FAMILY )
  IF "WIN9X" == cFamily
    cFullName := OS( OS_FULLNAME )
    MsgBox( cFullName + " does not support services" )
    RETURN .F.
  ENDIF

RETURN .T.
*/

PROCEDURE Main( cServiceName, cFlag, cUser, cPass )
  local cLocation, oLog, oCtrl, lOk
  local cMessage

  default cServiceName to "A++_task_service"
  default cFlag to "i"
  default cUser to ""
  default cPass to ""

  lOk := .f.

/*
  IF ! CheckParam( cFlag, cUser, cPass )
    Quit
  ENDIF

  IF ! ChkOsVersion()
    Quit
  ENDIF
*/

//  cServiceName := "A++_task_service"
  cLocation    := CurDrive() + ":\" + CurDir() + "\"
  oLog         := Logger():new()
  oCtrl        := ServiceController()

  oCtrl:addController( cServiceName ,                       ;
                       cServiceName   , ;
                       cLocation + cServiceName + ".exe" , ;
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
    Usage()
    Quit
  ENDCASE

  MsgBox( cMessage )

RETURN

/*
FUNCTION CheckParam( cFlag, cUser, cPass )

  IF ! "C" == Valtype( cFlag )
    Usage()
    RETURN .F.
  ENDIF

  IF ! cFlag $ "isxu"
    Usage()
    RETURN .F.
  ENDIF

  IF cFlag == "i"
    IF "U" == Valtype( cUser ) .OR. ;
       "U" == Valtype( cPass )
      Usage()
      RETURN .F.
    ENDIF
  ENDIF

RETURN .T.
*/

PROCEDURE Usage()

  local cTxt

TEXT INTO cTxt WRAP
  Usage:

     simplectr <isxu> [".\AccountName" "Passwort"]

  Flags:

     i installs the service simpleservice.exe
       When installing the service the account name and the
       password of this account become mandatory parameters.
       ( Note: Point and Backslash (".\") must prefix the
               account name )
     s starts the service
     x stopps the service
     u deinstalls the service

  Debugging:

     To debug the service, start it with:

       XppDbg simpleservice.exe

ENDTEXT

  MsgBox( cTxt )

RETURN