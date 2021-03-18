/*
This program is used to update the structure of a set of database
files and indexes to exactly match the structure in a
data-dictionary (.ADD) file.

This is a much faster and more reliable method of updating
structure than the more common techiques employed in Xbase++
applications because it uses SQL to perform the updates.

This is accomplished by comparing the structure of the actual
databases and indexes to the structure in the data dictionary
and then creating a set of *.SQL files to execute.  The .SQL
files will contain the SQL commands needed to make all of
the changes.

Pass 1:

Extract dictionary information and store in memory.

Pass 2:

Run all distributed *.SQL files that currently exist.

Pass 3:

Create a set of *.SQL files by comparing dictionary data to
actual structure of databases and indexes.

Pass 4:

Run all *.SQL files to perform the structure updates.

*/

#INCLUDE "dcdialog.CH"
#INCLUDE "adsdbe.CH"
#INCLUDE "dcicon.CH"
//#INCLUDE "dcads.CH"
#INCLUDE "ddicon.CH"

#Pragma Library("dclip1.lib")

#DEFINE CRLF Chr(13)+Chr(10)

#DEFINE OBJECT_TABLES         1
#DEFINE OBJECT_USERS          2
#DEFINE OBJECT_VIEWS          3
#DEFINE OBJECT_GROUPS         4
#DEFINE OBJECT_PROCEDURES     5
#DEFINE OBJECT_TRIGGERS       6
#DEFINE OBJECT_RELATIONS      7
#DEFINE OBJECT_LINKS          8
#DEFINE OBJECT_ARTICLES       9
#DEFINE OBJECT_SUBSCRIPTIONS  10
#DEFINE OBJECT_PUBLICATIONS   11

#DEFINE OBJECT_SIZE           11

#define ADS_PROPRIETARY  1

STATIC soMainWindow, snDictHandle, snFreeHandle, soTree, ;
       scDictName, scDataPath, scUserName, scPassword, ;
       slPropertiesPane := .f., soPropertiesPane, ;
       soPropertiesPaneParent, soMessageBox, soAdsSessionDict, ;
       soAdsSessionFree, scDictServer, scFreeServer


PROC appsys
RETURN

* -------------

FUNCTION Main()

LOCAL nError, GetList[0], GetOptions, lUpdateStruct := .t., ;
      lUpdateIndex := .t., lUpdating := .f., i, cParam, ;
      lRunDistributed := .f.

DC_IconDefault(ICON_DICTIONARY)

snDictHandle := 0
snFreeHandle := 0
scFreeServer := CurDrive()
scUserName := 'AdsSys'
scPassword := ''
scDataPath := ''

FOR i := 1 TO PCount()
  cParam := PValue(i)
  IF !Empty(cParam)
    IF Upper(cParam) = '/DICT:'
      scDictName := SubStr(cParam,7)
    ELSEIF Upper(cParam) = '/USR:'
      scUserName := SubStr(cParam,6)
    ELSEIF Upper(cParam) = '/PWD:'
      scPassword := Substr(cParam,6)
    ELSEIF Upper(cParam) = '/PATH:'
      scDataPath := Substr(cParam,7)
    ELSEIF Upper(cParam) = '/FREE:'
      scFreeServer := Substr(cParam,7)
    ELSEIF '/?' $ cParam .OR. '/H' $ Upper(cParam)
      ShowOptions()
    ELSEIF cParam = '/'
      DC_WinAlert('Unknown command line parameter: ' + cParam)
    ENDIF
  ENDIF
NEXT

IF Empty(scDictName)
  DC_WinAlert('No Dictionary specified')
  ShowOptions()
  QUIT
ENDIF

IF Empty(scDataPath)
  scDataPath := DC_Path(scDictName)
ENDIF

DC_ChDir(scDataPath)

nError := AdsConnect60( Alltrim(scDictName), ;
                ADS_REMOTE_SERVER + ADS_LOCAL_SERVER, ;
                scUserName, ;
                scPassword, ;
                ADS_DEFAULT, ;
                @snDictHandle )

AdsDictInit( scUserName, scPassword, snDictHandle, snFreeHandle )

nError := AdsConnect( Alltrim(scDataPath), @snFreeHandle )

IF nError > 0
  DCMSGBOX DC_AdsGetLastError()
  RETURN .f.
ENDIF

LoadDbes()
Set(_SET_NULLVALUE,.f.)

@ 0,0 DCSAY 'This utility program updates all .DBF files to the;' + ;
            'most current version defined in the ' + Upper(scDictName) + ;
            ' Data-Dictionary file.' SAYSIZE 40,2 SAYWORDBREAK

@ 3,0 DCPUSHBUTTON CAPTION 'Start Update' SIZE 20,2 ;
      ACTION {||lUpdating := .t., ;
                DC_GetRefresh(GetList), ;
                StartUpdate(GetList,lUpdateStruct,lUpdateIndex,@lUpdating,lRunDistributed), ;
                lUpdating := .f., ;
                DC_GetRefresh(GetList)} ;
      WHEN {||!lUpdating}

@ 6,0 DCCHECKBOX lRunDistributed PROMPT 'Run Distributed *.SQL files'
@ 7,0 DCCHECKBOX lUpdateStruct PROMPT 'Update Data Structures'
@ 8,0 DCCHECKBOX lUpdateIndex PROMPT 'Update Indexes'

@10,0 DCSAY '' SAYSIZE 70,.9 COLOR GRA_CLR_BLUE, GRA_CLR_WHITE ;
     FONT '9.Lucida Console' ID 'MESSAGEBOX_1' SAYLEFTBOTTOM

@11,0 DCSAY '' SAYSIZE 70,.9 COLOR GRA_CLR_BLUE, GRA_CLR_WHITE ;
     FONT '9.Lucida Console' ID 'MESSAGEBOX_2' SAYLEFTBOTTOM

DCGETOPTIONS
DCREAD GUI FIT TITLE 'Database Update Utility'

RETURN nil

* ------------

STATIC FUNCTION ShowOptions()

DC_MsgBox({'Command line Options:', ;
           '', ;
           '/dict:<dictionary> - Set dictionary (.add) name', ;
           '/usr:<user> - Set user name', ;
           '/pwd:<pwd> - Set password', ;
           '/path:<path> - Set Data Path', ;
           '/free:<drive> - Set Free Server Drive', ;
           ''}, ;
           ,,,,,,,,,,,'8.Courier')

RETURN nil

* ------------

STATIC FUNCTION StartUpdate( GetList, lUpdateStruct, lUpdateIndex, lUpdating, lRunDistributed )

LOCAL aObjects, aTables, i, cTableName, oMessage1, oMessage2, ;
      aOldStru, aNewStru, cMessage, lStatus, aDir, cFileName, ;
      cStatement, cErrorString, aOldIndex, aNewIndex, nHandle

oMessage1 := DC_GetObject( GetList, 'MESSAGEBOX_1' )
oMessage2 := DC_GetObject( GetList, 'MESSAGEBOX_2' )

DirMake('Sql')
DirMake('Sql\Update')

nHandle := FCreate( DC_CurPath() + '\SQL\UPDATE\UPDATE.LOG' )
oMessage1:setCaption( 'Pass 1 : Extracting Dictionary Info...')
FWrite( nHandle, 'Pass 1 : Extracting Dictionary Info...' + CRLF + CRLF )
aObjects := BuildDictArray()

aTables := aObjects[OBJECT_TABLES]

IF lRunDistributed
  oMessage1:setCaption( 'Pass 2 : Executing Distributed SQL files...' )
  FWrite( nHandle, 'Pass 2 : Executing Distributed SQL files...' + CRLF + CRLF )

  aDir := Directory( DC_CurPath() + '\SQL\UPDATE\*.Sql' )
  ASort( aDir,,,{|a,b|a[1]<b[1]})

  DC_CompleteEvents()

  FOR i := 1 TO Len(aDir)
    cFileName := DC_CurPath() + '\SQL\UPDATE\' + aDir[i,1]
    cMessage := 'Executing ' + cFileName
    FWrite( nHandle, cMessage + CRLF )
    oMessage2:setCaption(cMessage)
    cStatement := MemoRead( cFileName )
    IF !ExecuteSQL( cStatement, @cErrorString, nil, snDictHandle )
      oMessage2:setCaption( cMessage + '  FAILED!!!' )
      FWrite( nHandle, cMessage + '  FAILED!!!' + CRLF )
      FWrite( nHandle, cErrorString + CRLF )
      oMessage2:setColorFG( GRA_CLR_RED )
      LOOP
    ENDIF
    // Ferase( cFileName )
  NEXT
ENDIF

oMessage1:setCaption( 'Pass 3 : Creating SQL files...' )
FWrite( nHandle, 'Pass 3 : Creating SQL files...' + CRLF )

FOR i := 1 TO Len(aTables)
   DC_CompleteEvents()
   cTableName := aTables[i,1]
   aNewStru := aTables[i,3]
   aNewIndex := aTables[i,2]
   IF !File( DC_CurPath() + '\' + cTableName + '.DBF' )
      cMessage := cTableName + ' : Creating NEW TABLE SQL'
      oMessage2:setCaption(cMessage)
      FWrite( nHandle, cMessage + CRLF )
      lStatus := WriteNewTableSQL( cTableName, aTables[i,3], aTables[i,2], ;
                 lUpdateStruct, lUpdateIndex )
      IF lStatus
         cMessage += '   Done'
      ELSE
         cMessage += '   Error!!!'
      ENDIF
      oMessage2:setCaption(cMessage)
      Sleep(100)
   ELSE
      cMessage := cTableName + ' : Creating UPDATE TABLE SQL...'
      oMessage2:setCaption(cMessage)
      USE (cTableName)
      aOldStru := dbStruct()
      IF File(cTableName+'.CDX')
         SET INDEX TO (cTableName)
         aOldIndex := DC_TagInfo()
      ELSE
         aOldIndex := {}
      ENDIF
      CLOSE DATABASES
      lStatus := WriteUpdateTableSQL( cTableName, aOldStru, aNewStru, aOldIndex, ;
                                      aNewIndex, lUpdateStruct, lUpdateIndex )
      IF lStatus
         cMessage += '   Created!!!'
         FWrite( nHandle, cMessage + CRLF )
         Sleep(100)
      ELSE
         cMessage += '   Nothing Done!!!'
      ENDIF
      oMessage2:setCaption(cMessage)
   ENDIF
   Sleep(1)
NEXT

oMessage2:setCaption( '' )
oMessage1:setCaption( 'Pass 4 : Executing New SQL files' )
FWrite( nHandle, 'Pass 4 : Executing New SQL files' + CRLF )

aDir := Directory( DC_CurPath() + '\SQL\UPDATE\*Update.Sql' )

FOR i := 1 TO Len(aDir)
  DC_CompleteEvents()
  cFileName := DC_CurPath() + '\SQL\UPDATE\' + aDir[i,1]
  cMessage := 'Executing ' + cFileName
  oMessage2:setCaption(cMessage)
  FWrite( nHandle, CRLF + cMessage + CRLF )
  cStatement := MemoRead( cFileName )
  IF !ExecuteSQL( cStatement, @cErrorString, nil, snDictHandle )
    oMessage2:setCaption( cMessage + '  FAILED!!!' )
    oMessage2:setColorFG(GRA_CLR_RED)
    FWrite( nHandle, cMessage + '   FAILED!!!' + CRLF )
    FWrite( nHandle, cErrorString + CRLF )
    LOOP
  ENDIF
  // Ferase(cFileName)
NEXT

aDir := Directory( DC_CurPath() + '\SQL\UPDATE\*Reindex.Sql' )

FOR i := 1 TO Len(aDir)
  DC_CompleteEvents()
  cFileName := DC_CurPath() + '\SQL\UPDATE\' + aDir[i,1]
  cMessage := 'Executing ' + cFileName
  oMessage2:setCaption(cMessage)
  FWrite( nHandle, cMessage + CRLF )
  cStatement := MemoRead( cFileName )
  IF !ExecuteSQL( cStatement, @cErrorString, nil, snDictHandle )
    oMessage2:setCaption( cMessage + '  FAILED!!!' )
    oMessage2:setColorFG(GRA_CLR_RED)
    FWrite( nHandle, cMessage + '   FAILED!!!' + CRLF )
    FWrite( nHandle, cErrorString + CRLF )
    LOOP
  ENDIF
  // Ferase(cFileName)
NEXT

oMessage1:setCaption( 'Update Complete!!!' )
oMessage2:setCaption( '' )
FClose(nHandle)
DC_CompleteEvents()

RETURN nil

* ------------

FUNCTION AdsDictInit( cUserName, cPassword, nDictHandle, nFreeHandle)

DEFAULT cUserName := 'tlappuser', ;
   cPassword := 'xxxx'

scUserName := cUserName
scPassword := cPassword
scDictServer := scDictName + ';UID=' + scUserName + ';PWD=' + scPassword
snDictHandle := nDictHandle
snFreeHandle := nFreeHandle

RETURN nil

* --------------

FUNCTION BuildDictArray()

LOCAL aTables, nError, cData, nLen, i, j, nHandle, aObjects[OBJECT_SIZE], ;
      aFieldNames, aIndexNames

* -------- Tables ---------

aTables := BuildObjectArray( ADS_DD_TABLE_OBJECT, 2 )
ASort(aTables,,,{|a,b|a[1]<b[1]})

aObjects[OBJECT_TABLES] := aTables

* ------ Fields ---------

FOR i := 1 TO Len(aTables)
  aFieldNames := GetFieldNameArray( aTables[i,1], snDictHandle )
  aTables[i,3] := DictTableStru( aTables[i,1], aFieldNames )
NEXT

* -------- Index Files ---------

FOR i := 1 TO Len(aTables)
  aIndexNames := GetIndexNameArray( aTables[i,1], snDictHandle )
  aTables[i,2] := DictTableIndex( aTables[i,1], aIndexNames )
NEXT

RETURN aObjects

* --------------

STATIC FUNCTION BuildObjectArray( nObject, nChildObjects, cParent)

LOCAL i, cData, nLen, nHandle, nError, aObject[0]

DEFAULT nChildObjects := 0, ;
        cParent := ''

cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
nLen := ADS_DD_MAX_OBJECT_NAME_LEN
nHandle := 0
nError := AdsDDFindFirstObject( snDictHandle, ;
                      nObject, ;
                      cParent, ;
                      @cData, ;
                      @nLen, ;
                      @nHandle )

IF nError == 0
  cData := Strtran(cData,Chr(0),'')
  IF nChildObjects > 0
    AAdd( aObject, { Alltrim(cData) } )
    FOR i := 1 TO nChildObjects
       AAdd(ATail(aObject),{})
    NEXT
  ELSE
    AAdd( aObject, Alltrim(cData))
  ENDIF
ENDIF

DO WHILE nError == 0 .AND. nHandle > 0

  cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
  nLen := ADS_DD_MAX_OBJECT_NAME_LEN
  nError := AdsDDFindNextObject( snDictHandle, ;
                      nHandle, ;
                      @cData, ;
                      @nLen )

  IF nError == 0 .AND. !Empty(cData)
    cData := Strtran(cData,Chr(0),'')
    IF nChildObjects > 0
      AAdd( aObject, { Alltrim(cData) } )
      FOR i := 1 TO nChildObjects
         AAdd(ATail(aObject),{})
      NEXT
    ELSE
      AAdd( aObject, Alltrim(cData))
    ENDIF
  ENDIF

ENDDO
AdsDDFindClose(nHandle)

RETURN aObject

* ---------------

STATIC FUNCTION DictTableStru( cTableName, aFieldNames )

LOCAL i, aStru[0], aField

FOR i := 1 TO Len(aFieldNames)
  aField := DictFieldProperties( cTableName, aFieldNames[i])
  AAdd(aStru,aField)
NEXT

RETURN aStru

* ---------------

STATIC FUNCTION DictFieldProperties( cTableName, cFieldName )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, aField


aProperties := { ;
   { ADS_DD_FIELD_TYPE, 2, 2, 'Field Type'}, ;
   { ADS_DD_FIELD_LENGTH, 2, 2, 'Field Length'}, ;
   { ADS_DD_FIELD_DECIMAL, 2, 2, 'Field Decimals'} }

aField := { cFieldName, nil, nil, nil }

FOR i := 1 TO Len(aProperties)

  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetFieldProperty( snDictHandle, ;
                         cTableName, ;
                         cFieldName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF i == 1
    IF xValue == ADS_LOGICAL
      xValue := 'L'
    ELSEIF xValue == ADS_STRING
      xValue := 'C'
    ELSEIF xValue == ADS_MEMO
      xValue := 'M'
    ELSEIF xValue == ADS_NUMERIC
      xValue := 'N'
    ELSEIF xValue == ADS_DATE
      xValue := 'D'
    ENDIF
  ENDIF

  aField[i+1] := xValue

NEXT

RETURN aField

* ---------------

STATIC FUNCTION DictTableIndex( cTableName, aIndexNames )

LOCAL i, aIndexes[0], aIndex

FOR i := 1 TO Len(aIndexNames)
  aIndex := DictIndexProperties( cTableName, aIndexNames[i])
  AAdd(aIndexes,aIndex)
NEXT

RETURN aIndexes

* ---------------

STATIC FUNCTION DictIndexProperties( cTableName, cIndexName )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, aIndex

aProperties := { ;
   { ADS_DD_INDEX_EXPRESSION, Space(200), 200, 'Index Expression'}, ;
   { ADS_DD_INDEX_CONDITION, Space(200), 200, 'Index Condition'}, ;
   { ADS_DD_INDEX_OPTIONS, 4, 4, 'Index Options'} }

aIndex := { cIndexName, nil, nil, nil, nil, .f. }

FOR i := 1 TO Len(aProperties)

  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetIndexProperty( snDictHandle, ;
                         cTableName, ;
                         cIndexName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) == 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF

  IF i == 3
    aIndex[4] := DC_BitTest( xValue, 1 ) // unique
    aIndex[5] := DC_BitTest( xValue, 4 ) // descending
  ELSE
    aIndex[i+1] := Alltrim(Strtran(xValue,"'",'"'))
  ENDIF

NEXT

RETURN aIndex

* -------------

FUNCTION WriteUpdateTableSQL( cTableName, aStruOld, aStruNew, aIndexOld, aIndexNew, ;
                              lUpdateStruct, lUpdateIndex )

LOCAL i, cFieldName, nFound, nHandle, aFieldOld, aFieldNew, ;
      cString, cIndex, cType, lStatus, cTagName, lRebuildIndex, ;
      nOptions

cString := ''

IF lUpdateStruct
   FOR i := 1 TO Len(aStruOld)
      cFieldName := Alltrim(Upper(aStruOld[i,1]))
      aFieldOld := aStruOld[i]
      nFound := AScan(aStruNew,{|a|Alltrim(Upper(a[1]))==cFieldName})
      IF nFound == 0
         cString += '  DROP [' + cFieldname + ']' + CRLF
      ELSE
         aFieldNew := aStruNew[nFound]
         IF !aFieldOld[2] == aFieldNew[2] .OR. ;
               !aFieldOld[3] == aFieldNew[3] .OR. ;
               !aFieldOld[4] == aFieldNew[4]
            IF aFieldNew[2] = 'C'
               cType := 'Char( ' + Alltrim(Str(aFieldNew[3])) + ' )'
            ELSEIF aFieldNew[2] = 'N'
               IF aFieldNew[3] == 1
                 aFieldNew[3] := 2
               ENDIF
               cType := 'Numeric( ' + Alltrim(Str(aFieldNew[3])) + ', ' + Alltrim(Str(aFieldNew[4])) + ' )'
            ELSEIF aFieldNew[2] = 'D'
               cType := 'Date'
            ELSEIF aFieldNew[2] = 'L'
               cType := 'Logical'
            ELSEIF aFieldNew[2] = 'M'
               cType := 'Memo'
            ELSE
               cType := ''
            ENDIF
            cString += '  ALTER COLUMN [' + cFieldName + '] [' + cFieldName + '] ' + cType + CRLF
         ENDIF
      ENDIF
   NEXT

   FOR i := 1 TO Len(aStruNew)
      cFieldName := Alltrim(Upper(aStruNew[i,1]))
      aFieldNew := aStruNew[i]
      nFound := AScan(aStruOld,{|a|Alltrim(Upper(a[1]))==cFieldName})
      IF nFound == 0
         aFieldNew := aStruNew[i]
         IF aFieldNew[2] = 'C'
            cType := 'Char( ' + Alltrim(Str(aFieldNew[3])) + ' )'
         ELSEIF aFieldNew[2] = 'N'
            IF aFieldNew[3] == 1
              aFieldNew[3] := 2
            ENDIF
            cType := 'Numeric( ' + Alltrim(Str(aFieldNew[3])) + ', ' + Alltrim(Str(aFieldNew[4])) + ' )'
         ELSEIF aFieldNew[2] = 'D'
            cType := 'Date'
         ELSEIF aFieldNew[2] = 'L'
            cType := 'Logical'
         ELSEIF aFieldNew[2] = 'M'
            cType := 'Memo'
         ELSE
            cType := ''
         ENDIF
         cString += "  ADD COLUMN [" + cFieldName + "] " + cType + CRLF
      ENDIF
   NEXT
ENDIF

cIndex := ''

lRebuildIndex := .f.
IF lUpdateIndex
   FOR i := 1 TO Len(aIndexOld)
      cTagName := Upper(Alltrim(aIndexOld[i,1]))
      nFound := AScan( aIndexNew,{|a|Upper(Alltrim(a[1]))==cTagName} )
      IF nFound == 0
         lRebuildIndex := .t.
         EXIT
      ELSEIF !(aIndexNew[nFound,2] == aIndexOld[i,2]) .OR. ;
            !(aIndexNew[nFound,3] == aIndexOld[i,3]) .OR. ;
            !(aIndexNew[nFound,4] == aIndexOld[i,4]) .OR. ;
            !(aIndexNew[nFound,5] == aIndexOld[i,5])

         lRebuildIndex := .t.
         EXIT
      ENDIF
   NEXT

   IF !lRebuildIndex
      FOR i := 1 TO Len(aIndexNew)
         cTagname := Upper(Alltrim(aIndexNew[i,1]))
         nFound := AScan( aIndexOld,{|a|Upper(Alltrim(a[1]))==cTagName} )
         IF nFound == 0
            lRebuildIndex := .t.
            EXIT
         ENDIF
      NEXT
   ENDIF
ENDIF

IF lRebuildIndex

  cIndex := "EXECUTE PROCEDURE sp_ModifyTableProperty( '" + cTablename + "'," + ;
            "'Table_Auto_Create'," + ;
            "'True', 'APPEND_FAIL', '" + cTableName + "fail');" + CRLF + CRLF

  FOR i := 1 TO Len(aIndexOld)
    cTagName := aIndexOld[i,1]
    cIndex += 'DROP INDEX ' + cTableName + '.' + cTagName + ';' + CRLF
  NEXT
  cIndex += CRLF
  FOR i := 1 TO Len(aIndexNew)
    cIndex += CRLF + 'EXECUTE PROCEDURE sp_CreateIndex(' + CRLF
    nOptions := 2
    IF aIndexNew[i,4] // unique
      nOptions += 1
    ENDIF
    IF aIndexNew[i,5] // descending
      nOptions += 8
    ENDIF
    cIndex += "  '" + cTableName + "'," + CRLF
    cIndex += "  '" + cTableName + ".cdx'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,1]) + "'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,2]) + "'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,3]) + "'," + CRLF
    cIndex += "  " + Alltrim(Str(nOptions)) + "," + CRLF
    cIndex += "  " + Alltrim(Str(1024)) + " );" + CRLF
  NEXT
ENDIF

IF !Empty(cString)
  IF !Empty(cString)
    cString := 'ALTER TABLE ' + cTableName + CRLF + cString + ' ;' + CRLF
  ENDIF
  nHandle := FCreate( DC_CurPath() + '\SQL\UPDATE\' + cTableName + '-Update.Sql')
  FWrite(nHandle,cString)
  FClose(nHandle)
ENDIF

IF !Empty(cIndex)
  nHandle := FCreate( DC_CurPath() + '\SQL\UPDATE\' + cTableName + '-Reindex.Sql')
  FWrite(nHandle,cIndex)
  FClose(nHandle)
ENDIF

RETURN !Empty(cString) .OR. !Empty(cIndex)

* -------------

FUNCTION WriteNewTableSQL( cTableName, aStruNew, aIndexNew, lUpdateStruct, lUpdateIndex )

LOCAL i, cFieldName, nFound, nHandle, lStatus, nOptions, ;
      aFieldOld, aFieldNew, cString, cType, cIndex

DEFAULT cTableName := 'PARTS'

cString := ''

IF lUpdateStruct
   FOR i := 1 TO Len(aStruNew)
      cFieldName := Alltrim(Upper(aStruNew[i,1]))
      aFieldNew := aStruNew[i]
      IF aFieldNew[2] = 'C'
         cType := 'Char( ' + Alltrim(Str(aFieldNew[3])) + ' )'
      ELSEIF aFieldNew[2] = 'N'
         IF aFieldNew[3] == 1
           aFieldNew[3] := 2
         ENDIF
         cType := 'Numeric( ' + Alltrim(Str(aFieldNew[3])) + ', ' + Alltrim(Str(aFieldNew[4])) + ' )'
      ELSEIF aFieldNew[2] = 'D'
         cType := 'Date'
      ELSEIF aFieldNew[2] = 'L'
         cType := 'Logical'
      ELSEIF aFieldNew[2] = 'M'
         cType := 'Memo'
      ELSE
         cType := ''
      ENDIF
      cString += "  [" + cFieldName + "] " + cType + IIF(i<Len(aStruNew),' , ' + CRLF, ' ')
   NEXT

   cString := 'DROP TABLE ' + cTableName + ' FROM DATABASE NO_DELETE ;' + CRLF + CRLF + ;
      'CREATE TABLE ' + cTableName + ' (' + CRLF + cString + ');'
ENDIF

cIndex := CRLF
IF !Empty(aIndexNew) .AND. lUpdateIndex
  FOR i := 1 TO Len(aIndexNew)
    cIndex += CRLF + 'EXECUTE PROCEDURE sp_CreateIndex(' + CRLF
    nOptions := 2
    IF aIndexNew[i,4] // unique
      nOptions += 1
    ENDIF
    IF aIndexNew[i,5] // descending
      nOptions += 8
    ENDIF
    cIndex += "  '" + cTableName + "'," + CRLF
    cIndex += "  '" + cTableName + ".cdx'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,1]) + "'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,2]) + "'," + CRLF
    cIndex += "  '" + Alltrim(aIndexNew[i,3]) + "'," + CRLF
    cIndex += "  " + Alltrim(Str(nOptions)) + "," + CRLF
    cIndex += "  " + Alltrim(Str(1024)) + " );" + CRLF
  NEXT
ENDIF

nHandle := FCreate( DC_CurPath() + '\SQL\UPDATE\' + cTableName + '-Create.Sql')
FWrite(nHandle,cString+cIndex)
FClose(nHandle)
lStatus := .t.

RETURN lStatus

* --------------

STATIC FUNCTION GetFieldNameArray( cTableName, nDictHandle )

LOCAL cData, nLen, nHandle, nError, aFields[0]

cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
nLen := ADS_DD_MAX_OBJECT_NAME_LEN
nHandle := 0
nError := AdsDDFindFirstObject( nDictHandle, ;
                      ADS_DD_FIELD_OBJECT, ;
                      cTableName, ;
                      @cData, ;
                      @nLen, ;
                      @nHandle )

IF nError == 0
  cData := Strtran(cData,Chr(0),'')
  AAdd( aFields, Alltrim(cData) )
ENDIF

DO WHILE nError == 0 .AND. nHandle > 0
  cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
  nLen := ADS_DD_MAX_OBJECT_NAME_LEN
  nError := AdsDDFindNextObject( nDictHandle, ;
                      nHandle, ;
                      @cData, ;
                      @nLen )
  IF nError == 0 .AND. !Empty(cData)
    cData := Strtran(cData,Chr(0),'')
    AAdd( aFields, Alltrim(cData) )
  ENDIF
ENDDO
AdsDDFindClose(nHandle)

RETURN aFields

* --------------

STATIC FUNCTION GetIndexNameArray( cTableName, nDictHandle )

LOCAL cData, nLen, nHandle, nError, aFields[0]

cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
nLen := ADS_DD_MAX_OBJECT_NAME_LEN
nHandle := 0
nError := AdsDDFindFirstObject( nDictHandle, ;
                      ADS_DD_INDEX_OBJECT, ;
                      cTableName, ;
                      @cData, ;
                      @nLen, ;
                      @nHandle )

IF nError == 0
  cData := Strtran(cData,Chr(0),'')
  AAdd( aFields, Alltrim(cData) )
ENDIF

DO WHILE nError == 0 .AND. nHandle > 0
  cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
  nLen := ADS_DD_MAX_OBJECT_NAME_LEN
  nError := AdsDDFindNextObject( nDictHandle, ;
                      nHandle, ;
                      @cData, ;
                      @nLen )
  IF nError == 0 .AND. !Empty(cData)
    cData := Strtran(cData,Chr(0),'')
    AAdd( aFields, Alltrim(cData) )
  ENDIF
ENDDO
AdsDDFindClose(nHandle)

RETURN aFields

* -----------

FUNCTION LoadDbes()

LOCAL cSession, aDbeList := dbeList()

IF ! DbeLoad( "ADSDBE" )
   DC_WinAlert( "Unable to load ADSDBE", "ADS Server",, ;
      XBPMB_WARNING + XBPMB_APPMODAL )
ELSE

   DbeSetDefault( "ADSDBE" )

   DbeInfo( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_CDX )
   DbeInfo( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_CDX )
   DbeInfo( COMPONENT_DATA, ADSDBE_LOCK_MODE, ADSDBE_PROPRIETARY_LOCKING  )

   cSession := "DBE=ADSDBE;SERVER=" + scDictServer
   soAdsSessionDict := DacSession():new(cSession)
   IF !soAdsSessionDict:isConnected()
      MsgBox( "Unable to establish DICTIONARY connection to ADS Server" + Chr(13) + ;
         cSession + Chr(13) + ;
         "Error Code: " + Alltrim(Str(soAdsSessionDict:getLastError())) + Chr(13) + ;
         soAdsSessionDict:getLastMessage() )
   ELSE
      DC_AdsSession( soAdsSessionDict,1 )
   ENDIF

   cSession := "DBE=ADSDBE;SERVER=" + scFreeServer
   soAdsSessionFree := DacSession():new(cSession)
   IF !soAdsSessionFree:isConnected()
      MsgBox( "Unable to establish FREE connection to ADS Server" + Chr(13) + ;
         cSession + Chr(13) + ;
         "Error Code: " + Alltrim(Str(soAdsSessionFree:getLastError())) + Chr(13) + ;
         soAdsSessionFree:getLastMessage() )
   ELSE
      DC_AdsSession( soAdsSessionFree, 2 )
   ENDIF

ENDIF

IF !('FOXDBE'$aDbeList) .AND. !DbeLoad( "FOXDBE",.T.)
   Alert( "Database-Engine FOXDBE not loaded" , {"OK"} )
ENDIF

IF !('FOXCDX'$aDbeList) .AND. !DbeBuild( "FOXCDX", "FOXDBE", "CDXDBE" )
   Alert( "FOXCDX Database-Engine;Could not build engine" , {"OK"} )
ENDIF

// AdsSessionDict( soAdsSessionDict )

RETURN soAdsSessionDict

* -----------

FUNCTION AdsSessionDict()

RETURN soAdsSessionDict

* --------------

FUNCTION AdsSessionFree()

RETURN soAdsSessionFree

* -----------

FUNCTION ExecuteSQL( cStatement, cErrorString, nRecords, oSession )

LOCAL oDictConnection, nDictHandle, nIndexMode := ADS_CDX, ;
      nHandle, nStatementHandle, lStatus := .t., ;
      nLockingMode := ADS_PROPRIETARY, nError

DEFAULT nRecords := 0

IF Valtype(oSession) == 'N'
   nDictHandle := oSession
ELSEIF Empty(oSession)
   IF Valtype(snDictHandle) == 'N'
      nDictHandle := snDictHandle
   ELSE
      oDictConnection := AdsSessionDict():setDefault()
      nDictHandle := oDictConnection:getConnectionHandle()
   ENDIF
ELSE
   nDictHandle := oSession:getConnectionHandle()
ENDIF

DC_ExecuteSQL(nDictHandle,cStatement,,@nHandle,,,,,nIndexMode,nLockingMode, ;
   @cErrorString,,@nStatementHandle)

cErrorString := Strtran(cErrorString,Chr(0),'')

IF !Empty(cErrorString)
   IF !(Upper(cErrorString) == 'SUCCESS')
      lStatus := .f.
   ENDIF
ELSE
   cErrorString := 'SUCCESS'
ENDIF

nError := AdsGetRecordCount( nStatementHandle, ADS_IGNOREFILTERS, @nRecords )

AdsCloseSqlStatement(nStatementHandle)

RETURN lStatus


