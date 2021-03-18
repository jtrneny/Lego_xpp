/*

This program is used to run a *.SQL file.

It does NOT require ADS.DBE

It can connect to a Data Dictionary or a directory of tables.

*/

#INCLUDE "dcdialog.CH"

FUNCTION Main()

LOCAL i, cParam, cUserName, cPassword, cDataPath, cStatement, ;
      nLockingMode, nIndexMode, cServer, cSQLFile, lDeleteSQLFile, ;
      lExit, lAlways, lStatus

DEFAULT cDataPath := DC_Path(AppName(.t.)), ;
        cServer := cDataPath, ;
        nLockingMode := 1, ;
        nIndexMode := 2, ;
        lDeleteSQLFile := .f., ;
        lExit := .f., ;
        lAlways := .f.

FOR i := 1 TO PCount()
  cParam := PValue(i)
  IF !Empty(cParam)
    IF Upper(cParam) = '/SRV:'
      cServer := SubStr(cParam,6)
    ELSEIF Upper(cParam) = '/USR:'
      cUserName := SubStr(cParam,6)
    ELSEIF Upper(cParam) = '/PWD:'
      cPassword := Substr(cParam,6)
    ELSEIF Upper(cParam) = '/PATH:'
      cDataPath := Substr(cParam,7)
    ELSEIF Upper(cParam) = '/LOCK:'
      nLockingMode := Val(Substr(cParam,7))
    ELSEIF Upper(cParam) = '/INDEX:'
      nIndexMode := Val(Substr(cParam,8))
    ELSEIF Upper(cParam) = '/SQL:'
      cSqlFile := Substr(cParam,6)
    ELSEIF Upper(cParam) = '/DEL'
      lDeleteSqlFile := .t.
    ELSEIF Upper(cParam) = '/EXIT'
      lExit := .t.
    ELSEIF Upper(cParam) = '/ALWAYS'
      lAlways := .t.
    ELSEIF '/?' $ cParam .OR. '/H' $ Upper(cParam)
      ShowOptions()
    ELSEIF cParam = '/'
      DC_WinAlert('Unknown command line parameter: ' + cParam)
    ENDIF
  ENDIF
NEXT

IF PCount() == 0
  ShowOptions()
  QUIT
ENDIF

IF !Empty(cSqlFile) .AND. FExists(cSqlFile)
  cStatement := MemoRead(cSqlFile)
ENDIF

lStatus := DC_AdsSqlQuery( cServer, cUserName, cPassword, cDataPath, , ;
                           nIndexMode, nLockingMode,, cStatement, lExit, lAlways )

IF (Valtype(lStatus) == 'L' .AND. lStatus) .OR. lAlways
  IF lDeleteSqlFile .AND. !Empty(cSqlFile)
    FErase(cSqlFile)
  ENDIF
ENDIF

RETURN nil

* --------------

PROC appsys ; RETURN

* --------------

STATIC FUNCTION ShowOptions()

DC_MsgBox({'Command line Options:', ;
           '', ;
           '/srv:<server> - Set dictionary (.add) name or Drive Letter', ;
           '/usr:<user> - Set user name', ;
           '/pwd:<pwd> - Set password', ;
           '/path:<path> - Set Data Path', ;
           '/lock:<locking mode> - 0=Compatible, 1=Proprietary (default)', ;
           '/index:<index mode> - 1=NTX, 2=CDX (default)', ;
           '/sql:<sql file> - SQL to Run', ;
           '/del - Delete the SQL File after Executing Statement', ;
           '/exit - Exit program after Executing Statement', ;
           ''}, ;
           ,,,,,,,,,,,'8.Courier')

RETURN nil



