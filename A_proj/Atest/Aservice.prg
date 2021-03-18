//////////////////////////////////////////////////////////////////////
//
//  SIMPLESERVICE.PRG
//
//  Copyright:
//     Alaska Software, (c) 2002-2006. All rights reserved.
//
//  Contents:
//     Implementation of the service simpleservice
//
//  Remarks:
//     This service may not be executed directly.
//     For controlling, the application simplectr.exe may be used.
//     Use xppdbg.exe for debugging the service.
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

#include "COLLAT.CH"
#include "DMLB.CH"
#include "GET.CH"
#include "MEMVAR.CH"
#include "NATMSG.CH"
#include "PROMPT.CH"
#include "SET.CH"
#include "STD.CH"

#include "Fileio.ch"
#include "class.ch"

#include "Deldbe.ch"
#include "Sdfdbe.ch"
#include "DbStruct.ch"
#include "Directry.ch"

#include "..\A_main\WinApi_.ch"


#include "Asinetc.ch"

#include "..\Asystem++\Asystem++.ch"

#include "service.ch"
#include "XbZ_Zip.ch"

#pragma Library( "ASINet10.lib" )

//REQUEST Scatter  // from \SOURCE\SYS\BLOCKS.PRG


// Entry point of application
PROCEDURE Main()
  public odata
  public logOsoba

  logOsoba := 'A++_service'
//  MsgBox( "spouštím službu ASYSSVR..." )
  *
  Aservice():start()
RETURN


CLASS Aservice From ServiceApp
  EXPORTED:
    CLASS METHOD main
    CLASS METHOD stop
  HIDDEN:
    CLASS VAR lRunning
    CLASS VAR oThread
ENDCLASS

// Entry point of service
CLASS METHOD Aservice:main()
  local cConnect
  local nHandle, file
  local timeStart
  local ldayStart := .t.

  ::lRunning := .T.

//  IF !File('A++_service.ini')
//    MsgBox( 'Chybí inicializaèní soubor A++_SERVICE.INI  !!!', 'CHYBA...' )
//    DBCLOSEALL()
//    QUIT
//  ENDIF
  *
//  drgReadINI('A++_service.ini')

//  file := drgINI:dir_DATA +'\' + drgINI:add_FILE
//  cConnect := "DBE=ADSDBE;SERVER="  + file    //AllTrim(drgINI:dir_SYSTEM) // +";ADS_LOCAL_SERVER"
//  odata    := dacSession():New( cConnect)

//  if .not. ( odata:isConnected() )
//    MsgBox('Nelze se pøipojit na >DATOVÝ< server ADS !!!')
//    QUIT
//  endIf

//  timeStart := Seconds( '10:00:00')

  DO WHILE ::lRunning

    Tone( 400, 9 )
    Sleep( 500 )
/*
    if timeStart <= Seconds() .and. ldayStart
      ::DIST000066()
      ::DIST000067()
      ::DIST000068()
//    ::DIST000079()
//    if Empty( ::oThread)
//      ::oThread := runAppThread():new()
//      ::oThread:SetInterval( 700)
//      ::oThread:start()
//    endif

//    Tone( 400, 9 )
      ldayStart := .f.
    endif
    if Seconds() = 0
      ldayStart := .t.
    endif

    Sleep( timeCyklus)
*/

  ENDDO

RETURN self

// Entry point for stop request
CLASS METHOD Aservice:stop()
  ::lRunning := .F.
//  ::oThread:stop()
RETURN self

