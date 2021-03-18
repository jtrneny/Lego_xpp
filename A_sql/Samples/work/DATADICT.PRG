/*

This program uses opens a data dictionary and provides
a treeview of all tables and views in the dictionary.
Right-click a tree item for a menu.

Menu options are the following:

Browse this Table (all fields - SQL
Browse this Table (all fields - ISAM)'
Browse this Table (SQL Select)
Properties

Start program as follows:

DATADICT /dict:.\data\samples.add

*/

#INCLUDE "dcdialog.CH"
#INCLUDE "dcprint.CH"
#INCLUDE "dctree.CH"
#INCLUDE "adsdbe.CH"
#INCLUDE "dcads.CH"
#INCLUDE "dcicon.CH"
#INCLUDE "dcpick.CH"
#INCLUDE "dmlb.CH"
#INCLUDE "ddicon.CH"
#INCLUDE "appevent.CH"

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

STATIC soMainWindow, snDictHandle, snFreeHandle, soTree, ;
       scDictName, scDataPath, scUserName, scPassword, ;
       slPropertiesPane := .f., soPropertiesPane, ;
       soPropertiesPaneParent, soMessageBox, soAdsSessionDict, ;
       soAdsSessionFree, scDictServer, scFreeServer, soMenuBar

PROC appsys
RETURN

* ----------------

FUNCTION Main()

LOCAL GetList[0], GetOptions, oMenuBar, oMenuMigrate, oStatBot, ;
      nError, oTreeMenu, oMenuView, bItemMarked, oTreeTables, ;
      oMenuSql, oMenuUtil, oMenuTranny, lStatus, cSearch, ;
      cUser, cPassword, i, cParam

scUserName := 'AdsSys'
scPassword := ''
scDataPath := DC_CurPath() + '\'
scFreeServer := CurDrive()

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

DC_IconDefault(ICON_DICTIONARY)

snDictHandle := 0
snFreeHandle := 0
cSearch := Space(20)

nError := AdsConnect60( Alltrim(scDictName), ;
                ADS_REMOTE_SERVER + ADS_LOCAL_SERVER, ;
                scUserName, ;
                scPassword, ;
                ADS_DEFAULT, ;
                @snDictHandle )

IF nError > 0
  DCMSGBOX DC_AdsGetLastError()
  RETURN .f.
ENDIF

DICT_AdsDictInit( scUserName, scPassword, snDictHandle, snFreeHandle )

nError := AdsConnect( Alltrim(scDataPath), @snFreeHandle )

IF nError > 0
  DCMSGBOX DC_AdsGetLastError()
  RETURN .f.
ENDIF

DICT_LoadDbes()
DbSetNullValue(.f.)

DCMENUBAR oMenuBar // OWNERDRAW

  /*
  * -------- Migrate menu --------
  DCSUBMENU oMenuMigrate PARENT oMenuBar PROMPT 'Migrate'
    DCMENUITEM 'Add Table to Data Dictionary (ABC.ADD)' PARENT oMenuMigrate ;
      ACTION {||BuildABCDD()} ;
      MESSAGE 'Create ABC.ADD from U90FL.DBF dictionary'
  */

  * --------- SQL menu --------

  DCSUBMENU oMenuSQL PROMPT 'SQL' PARENT oMenuBar
    DCMENUITEM 'SQL Query' PARENT oMenuSQL ;
      ACTION {||GuiRun({|a|DICT_SQL2Dbu(a)})}

  * ------- View Menu -------
  DCSUBMENU oMenuView PARENT oMenuBar PROMPT 'View'
    DCMENUITEM 'Properties Pane' PARENT oMenuView ;
      ACTION {||slPropertiesPane := !slPropertiesPane, ;
                DICT_PropertiesPane(), ;
                DC_GetWhen(GetList)} ;
      CHECKWHEN {||slPropertiesPane}

  * -------- Util Menu -------
  DCSUBMENU oMenuUtil PROMPT 'Util' PARENT oMenuBar
    DCMENUITEM 'Dot Prompt' ACTION {||GuiRun({||DC_Dot()})} PARENT oMenuUtil
    DCMENUITEM 'Run a Procedure' ACTION {||DICT_RunProc()} PARENT oMenuUtil

bItemMarked := {|a,b,o|IIF(slPropertiesPane, ;
                       DICT_ShowPropertiesPane(o:getData()),nil)}

@ 25,0 DCTREEROOT OBJECT soTree SIZE 350,530 ;
      RESIZE DCGUI_RESIZE_RESIZEONLY_Y ;
      HASLINES ;
      HASBUTTONS ;
      FONT '8.Lucida Console' ;
      ALWAYSSHOWSELECTION ;
      ITEMMARKED bItemMarked ;
      EVAL {|o|o:lbClick := {|aPos|soTree:SetData(soTree:itemFromPos(aPos))}, ;
               o:rbDown := {|aPos|soTree:SetData(soTree:itemFromPos(aPos)), ;
                               TreeMenu(aPos,@oTreeTables)}}

@ 25,350 DCSTATIC TYPE XBPSTATIC_TYPE_TEXT ;
      SIZE 500,530 ;
      RESIZE DCGUI_RESIZE_RESIZEONLY ;
      OBJECT soPropertiesPaneParent ;
      COLOR nil, GRA_CLR_DARKCYAN

DCSTATUSBAR oStatBot HEIGHT 25 ALIGN DCGUI_ALIGN_BOTTOM

@ 0,2 DCSAY '' OBJECT soMessageBox SIZE 100,20 PIXEL;
   COLOR GRA_CLR_BLUE, GRA_CLR_WHITE PARENT oStatBot

@ 0,2 DCSAY 'Search' GET cSearch PARENT oStatBot SAYSIZE 0 SAYBOTTOM ;
      KEYBLOCK {|n,x,o|IIF(n==xbeK_ENTER,(o:getData(),TableSearch(oTreeTables,cSearch)),nil)}

@ 0,2 DCPUSHBUTTON CAPTION 'Go' SIZE 30,20 ;
      ACTION {||TableSearch( oTreeTables, cSearch)} PARENT oStatBot

@ 0,2 DCSAY ' ' SAYSIZE 5,20 PARENT oStatBot

DCGETOPTIONS ;
   WINDOWWIDTH 800 ;
   WINDOWHEIGHT 600 ;
   PIXEL ;
   RESIZE ;
   COLOR GRA_CLR_WHITE ;
   MESSAGEINTO {|c|soMessageBox:setCaption(c)}

DCREAD GUI ;
   TITLE 'Database Manager (SQL-based)' ;
   OPTIONS GetOptions ;
   SETAPPWINDOW  ;
   EVAL {|o|soMainWindow := o, ;
            oTreeTables := RebuildTree(), ;
            soMenuBar := oMenuBar}

AdsDisconnect(snDictHandle)
AdsDisconnect(snFreeHandle)

RETURN nil

* -----------

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

* --------------

STATIC FUNCTION RebuildTree( nSort )

LOCAL aDictObjects, aFreeObjects, oTreeTables
DC_PointerWait()
aDictObjects := DICT_BuildDictArray(nSort)

aFreeObjects := {{}}  // DICT_BuildFreeArray(snFreeHandle,aDictObjects[1])

oTreeTables := DICT_BuildTree( aDictObjects, aFreeObjects )
DC_PointerArrow()

RETURN oTreeTables

* --------------

STATIC FUNCTION TableSearch( oTreeTables, cSearch )

LOCAL i, aChildList := oTreeTables:getChildItems()

cSearch := Alltrim(Upper(cSearch))

FOR i := 1 TO Len(aChildList)
  IF cSearch $ Upper( aChildList[i]:caption)
    soTree:setData(aChildList[i])
    EXIT
  ENDIF
NEXT

RETURN nil

* --------------

STATIC FUNCTION TreeMenu( aPos, oTreeTables )

LOCAL GetList[0], aData, oTreeMenu, lRebuild := .f.

aData := soTree:getData():cargo

DCSUBMENU oTreeMenu PROMPT 'Tree Menu' // OWNERDRAW

IF Empty(aData)
  // No menu attached

ELSEIF aData[1] = 'Dict'

  DCMENUITEM 'Add Table' PARENT oTreeMenu ;
    ;// ACTION {||DICT_DictAddTable( aData[2], nConnectHandle )} ;

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ;// ACTION {||DICT_DictProperties( aData[2] )}

  DCMENUITEM 'Sort by File Name' PARENT oTreeMenu ;
    MESSAGE 'Sort Tables by File Name' ;
    ACTION {||oTreeTables := RebuildTree(1)}

  DCMENUITEM 'Sort by Description' PARENT oTreeMenu ;
    MESSAGE 'Sort Tables by Description' ;
    ACTION {||oTreeTables := RebuildTree(2)}

ELSEIF aData[1] = 'Table'

  /*
  DCMENUITEM 'Remove this Table' PARENT oTreeMenu ;
    ACTION {||DICT_DictRemoveTable( aData[2], snDictHandle ), ;
              lRebuild := .t.} ;
    MESSAGE 'Disassociate this table from the Data Dictionary'
  */

  DCMENUITEM 'Browse this Table (all fields - SQL )' PARENT oTreeMenu ;
    ACTION {||GuiRun({|a|ExecuteSQL('SELECT * from ' + aData[2],aData[2])})}

  DCMENUITEM 'Browse this Table (all fields - ISAM)' PARENT oTreeMenu ;
    ACTION {||GuiRun({|a|BrowseISAM(aData[2])})}

  DCMENUITEM 'Browse this Table (SQL Select)' PARENT oTreeMenu ;
    ACTION {||GuiRun({|a|DICT_SQL2Dbu(a,aData)})}

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictTableProperties( .f., aData[2], snDictHandle )}

  /*
  DCMENUITEM 'Build Free Index' PARENT oTreeMenu ;
    ACTION {||DICT_BuildFreeIndex(aData[2],snDictHandle)}
  */

ELSEIF aData[1] = 'Index File'

  DCMENUITEM 'Reindex' PARENT oTreeMenu ;
    ACTION {||DICT_DictReindexTable(aData[3]:cargo[2],snDictHandle)} ;
    MESSAGE 'Rebuild all open indexes associated with table ' + ;
            aData[3]:cargo[2] + ' using info in existing index files'

  DCMENUITEM 'Add New Index Tag to ' + aData[2] PARENT oTreeMenu ;
    ACTION {||(dcbdebug aData)} ;

ELSEIF aData[1] = 'View'

  DCMENUITEM 'Execute this View' PARENT oTreeMenu ;
    ACTION {||DICT_DictViewExecuteSQL( aData[2], snDictHandle )}

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictViewProperties( .f., aData[2], snDictHandle )}

ELSEIF aData[1] = 'Field'

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictFieldProperties( .f., aData[3], aData[2], snDictHandle )}

ELSEIF aData[1] = 'Group'

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictGroupProperties( .f., aData[2], snDictHandle )}

ELSEIF aData[1] = 'User'

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictUserProperties( .f., aData[2], snDictHandle )}

ELSEIF aData[1] = 'RI'

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictRIProperties( .f., aData[2], snDictHandle )}

ELSEIF aData[1] = 'Index Tag'

  DCMENUITEM 'Reindex this tag (' + aData[2] + ')' PARENT oTreeMenu ;
    ACTION {||(dcbdebug aData)}

  DCMENUITEM 'Add New Index Tag' PARENT oTreeMenu ;
    ACTION {||(dcbdebug aData)} ;

  DCMENUITEM 'Properties' PARENT oTreeMenu ;
    ACTION {||DICT_DictIndexProperties( .f., aData[3]:cargo[3]:cargo[2], ;
                                      aData[2], snDictHandle )}

ENDIF

DCREAD GUI EXIT PARENT AppDeskTop()

oTreeMenu:popup( soTree, aPos, 2, ;
                XBPMENU_PU_DEFAULT + XBPMENU_PU_MOUSE_RBDOWN )

IF lRebuild
  RebuildTree()
ENDIF

RETURN nil

* --------------

FUNCTION DICT_BuildFreeArray( aDictTables )

LOCAL aObjects, aTables[0], aDir, nTableHandle := 0, ;
      nIndexHandle, nError, cTableName, cIndexName, ;
      aIndex := {}, i, nLen := 100

aDir := Directory(scDataPath + '*.DBF')

FOR i := 1 TO Len(aDir)

  cTableName := Upper(aDir[i,1])

  nError := AdsOpenTable( snFreeHandle, ;
              scDataPath + cTableName, ;
              '', ;
              ADS_CDX, ;
              ADS_OEM, ;
              ADS_PROPRIETARY_LOCKING, ;
              ADS_IGNORERIGHTS, ;
              ADS_READONLY, ;
              @nTableHandle )

  IF nError = 0 .AND. nTableHandle > 0
    AAdd( aTables, { cTableName, {} } )
    cIndexName := scDataPath + Strtran(cTableName,'.DBF','.CDX')
    IF File(cIndexName)
      nLen := 100
      aIndex := Space(100)
      nError := AdsOpenIndex( nTableHandle, ;
                              cIndexName, ;
                              @aIndex, ;
                              @nLen )
    ENDIF
  ENDIF
  AdsCloseTable( nTableHandle )

NEXT

aObjects := { aTables }

RETURN aObjects

* --------------

FUNCTION DICT_BuildDictArray( nSort )

LOCAL aTables, nError, cData, nLen, i, j, cTableName, cFieldName := '', ;
      nHandle, aObjects[OBJECT_SIZE], xValue

DEFAULT nSort := 1

* -------- Tables ---------

aTables := BuildObjectArray( ADS_DD_TABLE_OBJECT, 2 )

ASort(aTables,,,{|a,b|a[1]<b[1]})

FOR i := 1 TO Len(aTables)
  cTableName := aTables[i,1]
  xValue := Space(200)
  nLen := 200
  nError := AdsDDGetTableProperty( snDictHandle, ;
                         cTableName, ;
                         ADS_DD_COMMENT, ;
                         @xValue, ;
                         @nLen )
  xValue := Trim(xValue)
  AAdd(aTables[i],xValue)
NEXT

IF nSort == 2
  ASort(aTables,,,{|a,b|a[4]<b[4]})
ENDIF

aObjects[OBJECT_TABLES] := aTables

* -------- Users ---------

aObjects[OBJECT_USERS] := BuildObjectArray( ADS_DD_USER_OBJECT )

* -------- Views ---------

aObjects[OBJECT_VIEWS] := BuildObjectArray( ADS_DD_VIEW_OBJECT )

* -------- Groups ---------

aObjects[OBJECT_GROUPS] := BuildObjectArray( ADS_DD_USER_GROUP_OBJECT )

* -------- Stored Procedures ---------

aObjects[OBJECT_PROCEDURES] := BuildObjectArray( ADS_DD_PROCEDURE_OBJECT )

* -------- Links ---------

aObjects[OBJECT_LINKS] := BuildObjectArray( ADS_DD_LINK_OBJECT )

* -------- Triggers ---------

aObjects[OBJECT_TRIGGERS] := BuildObjectArray( ADS_DD_TRIGGER_OBJECT )

* -------- Relations (RI) ---------

aObjects[OBJECT_RELATIONS] := BuildObjectArray( ADS_DD_RELATION_OBJECT )

* -------- Publications ---------

aObjects[OBJECT_PUBLICATIONS] := BuildObjectArray( ADS_DD_PUBLICATION_OBJECT )

* -------- Articles ---------

aObjects[OBJECT_ARTICLES] := BuildObjectArray( ADS_DD_ARTICLE_OBJECT )

* -------- Subscriptions ---------

aObjects[OBJECT_SUBSCRIPTIONS] := BuildObjectArray( ADS_DD_SUBSCRIPTION_OBJECT )

* ------ Fields ---------

FOR i := 1 TO Len(aTables)
  aTables[i,3] := GetFieldNameArray( aTables[i,1], snDictHandle )
NEXT

* -------- Index Files ---------

FOR i := 1 TO Len(aTables)

  cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
  nLen := ADS_DD_MAX_OBJECT_NAME_LEN
  nHandle := 0
  nError := AdsDDFindFirstObject( snDictHandle, ;
                      ADS_DD_INDEX_FILE_OBJECT, ;
                      aTables[i,1], ;
                      @cData, ;
                      @nLen, ;
                      @nHandle )

  IF nError == 0
    cData := Strtran(cData,Chr(0),'')
    AAdd( aTables[i,2], { Alltrim(cData), {} } )
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
      AAdd( aTables[i,2], { Alltrim(cData), {} } )
    ENDIF
  ENDDO
  AdsDDFindClose(nHandle)

NEXT

* --------- Index Tags ---------

FOR i := 1 TO Len(aTables)

  FOR j := 1 TO Len(aTables[i,2])

    cData := Space(ADS_DD_MAX_OBJECT_NAME_LEN)
    nLen := ADS_DD_MAX_OBJECT_NAME_LEN
    nHandle := 0

    nError := AdsDDFindFirstObject( snDictHandle, ;
                      ADS_DD_INDEX_OBJECT, ;
                      aTables[i,1], ;
                      @cData, ;
                      @nLen, ;
                      @nHandle )

    IF nError == 0
      cData := Strtran(cData,Chr(0),'')
      AAdd( aTables[i,2,j,2], Alltrim(cData))
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
        AAdd( aTables[i,2,j,2], Alltrim(cData) )
      ENDIF
    ENDDO
    AdsDDFindClose(nHandle)

  NEXT j

NEXT i

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

* --------------

FUNCTION DICT_BuildTree( aDictObjects, aFreeObjects )

LOCAL i, j, k, oTreeItem, oTree, oTreeTables, aUsers, ;
      oTableItem, oIndexItem, oTagItem, oTreeDict, oTreeFree, ;
      aDictTables, aFreeTables, aViews, aGroups, aRelations, ;
      aArticles, oFieldItem

soTree:destroy()
soTree:create()

aUsers := aDictObjects[OBJECT_USERS]
aViews := aDictObjects[OBJECT_VIEWS]
aGroups := aDictObjects[OBJECT_GROUPS]
aRelations := aDictObjects[OBJECT_RELATIONS]
aArticles := aDictObjects[OBJECT_ARTICLES]

aDictTables := aDictObjects[OBJECT_TABLES]
aFreeTables := aFreeObjects[OBJECT_TABLES]

oTreeDict := soTree:rootItem:addItem('Dict (' + scDictname + ')', ;
             ICON_DICTIONARY,ICON_DICTIONARY,ICON_DICTIONARY)
oTreeDict:cargo := { 'Dict', scDictName }

oTreeTables := oTreeDict:addItem('Tables',ICON_TABLE,ICON_TABLE,ICON_TABLE)

FOR i := 1 TO Len(aDictTables)
  oTableItem := oTreeTables:addItem(Pad(aDictTables[i,1],9) + DC_CapFirst(aDictTables[i,4],.t.), ;
                                    ICON_TABLE,ICON_TABLE,ICON_TABLE)
  oTableItem:cargo := { 'Table', aDictTables[i,1], oTreeTables, aDictTables[i,3] }
  FOR j := 1 TO Len(aDictTables[i,2])
    oIndexItem := oTableItem:addItem(aDictTables[i,2,j,1],ICON_INDEXFILE,ICON_INDEXFILE,ICON_INDEXFILE)
    oIndexItem:cargo := { 'Index File', aDictTables[i,2,j,1], oTableItem }
    FOR k := 1 TO Len(aDictTables[i,2,j,2])
      oTagItem := oIndexItem:addItem(aDictTables[i,2,j,2,k],ICON_INDEXTAG,ICON_INDEXTAG,ICON_INDEXTAG)
      oTagItem:cargo := { 'Index Tag', aDictTables[i,2,j,2,k], oIndexItem }
    NEXT
  NEXT
  oFieldItem := oTableItem:addItem('Fields',ICON_FIELD,ICON_FIELD,ICON_FIELD)
  FOR j := 1 TO Len(aDictTables[i,3])
    oTreeItem := oFieldItem:addItem(aDictTables[i,3,j],ICON_FIELD,ICON_FIELD,ICON_FIELD)
    oTreeItem:cargo := { 'Field', aDictTables[i,3,j], aDictTables[i,1], oFieldItem }
  NEXT
NEXT

oTree := oTreeDict:addItem('Views',ICON_VIEWS,ICON_VIEWS,ICON_VIEWS)
FOR i := 1 TO Len(aViews)
  oTreeItem := oTree:addItem(aViews[i],ICON_VIEWS,ICON_VIEWS,ICON_VIEWS)
  oTreeItem:cargo := { 'Views', aViews[i], oTree }
NEXT

RETURN oTreeTables

* ---------------

FUNCTION DICT_SQL2Dbu( a, aData )

LOCAL GetList[0], GetOptions, cSQL, aAvailFields[0], aPickedFields[0], ;
      cTableName, i, cField

cSQL := ''

@ 0,0 DCSAY 'Enter SQL Statement:' SAYSIZE 0 SAYBOTTOM

@ DCGUI_ROW, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'Execute SQL' ;
   SIZE 15,1 ACTION {||GuiRun({|a|ExecuteSQL(cSQL,a)})}

@ DCGUI_ROW, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'Save SQL' ;
   SIZE 15,1 ACTION {||SaveSQL(@cSQL)}

@ DCGUI_ROW, DCGUI_COL + 10 DCPUSHBUTTON CAPTION 'Load SQL' ;
   SIZE 15,1 ACTION {||cSQL := LoadSQL(cSQL),DC_GetRefresh(GetList)}

@ 1,0 DCMULTILINE cSQL SIZE 80,10 FONT '10.Lucida Console' ;
      NOHSCROLL

IF !Empty(aData)
  cTableName := aData[2]
  aAvailFields := AClone(aData[4])

  IF cTableName == 'QMEMB'
    IF !DC_DbSel('Q05UL')
      USE Q05UL NEW
    ENDIF
    FOR i := 1 TO Len(aAvailFields)
      IF Left(aAvailFields[i],4) == 'USER'
        cField := 'Q05UL->LABEL' + Substr(aAvailFields[i],5)
        IF !Empty(&(cField))
          aAvailFields[i] += ' (' + Trim(&(cField)) + ')'
        ENDIF
      ENDIF
    NEXT
  ENDIF

  @ 11,0 DCSAY 'Fields from table: ' + cTableName SAYSIZE 0 SAYBOTTOM
  @ DCGUI_ROW, DCGUI_COL + 20 DCSAY '(choose fields then Click OK to create SQL Query)' ;
     SAYSIZE 0 COLOR GRA_CLR_BLUE SAYBOTTOM
  @ 12,0 DCPICKLIST aPickedFields LIST aAvailFields ;
   CAPTION "Available Fields", "Selected Fields" ;
   SIZE 60,11 ;
   COPYITEMS ;
   DATALINK {||BuildSQLSelect(cTableName,aPickedFields,@cSQL,GetList)}
ENDIF

DCREAD GUI FIT ;
   TITLE 'View SQL Query in xDBU' ;
   OPTIONS GetOptions ;
   APPWINDOW soMainWindow:drawingArea

RETURN nil

* ---------------

STATIC FUNCTION SaveSQL( cSQL )

LOCAL GetList[0], cFileName := Space(100), lStatus

@ 0,0 DCSAY 'File Name to Save To (*.SQL)' SAYSIZE 0
@ 1,0 DCGET cFileName GETSIZE 50

DCREAD GUI FIT ADDBUTTONS TITLE 'Save SQL to File' MODAL TO lStatus

IF lStatus
  cFileName := Alltrim(cFileName)
  IF !(Upper(Right(cFileName,4))) == '.SQL'
    cFileName += '.SQL'
  ENDIF
  MemoWrit(cFileName,Alltrim(cSQL))
ENDIF

RETURN nil

* ---------------

STATIC FUNCTION LoadSQL( cSQL )

LOCAL GetList[0], cFileName := Space(100), aFileFilters, lStatus

aFileFilters := { {"SQL Files", "*.SQL"}, ;
                  {"All Files", "*.*"  } }

@ 0,0 DCSAY 'File Name to Load (*.SQL)' SAYSIZE 0
@ 1,0 DCGET cFileName POPUP {|c|DC_PopFile(c,,'*.SQL','Load a SQL File',aFileFilters)} GETSIZE 50

DCREAD GUI FIT ADDBUTTONS TITLE 'Load SQL from File' MODAL TO lStatus

IF lStatus
  cFileName := Alltrim(cFileName)
  IF !(Upper(Right(cFileName,4))) == '.SQL'
    cFileName += '.SQL'
  ENDIF
  cSQL := MemoRead(cFileName)
ENDIF

RETURN cSQL

* ---------------

STATIC FUNCTION BuildSQLSelect( cTableName, aPickedFields, cSQL, GetList)

LOCAL i, nFound

FOR i := 1 TO Len(aPickedFields)
  nFound := At('(',aPickedFields[i])
  IF nFound > 0
    aPickedFields[i] := Substr(aPickedFields[i],1,nFound-2)
  ENDIF
NEXT

cSQL := 'SELECT '
FOR i := 1 TO Len(aPickedFields)
  cSQL += Alltrim(aPickedFields[i]) + IIF(i<Len(aPickedFields),', ','')
NEXT

cSQL += ' FROM ' + cTableName

DC_GetRefresh(GetList)

RETURN nil

* ---------------

STATIC FUNCTION BrowseISAM( cAlias )

USE (cAlias) VIA 'ADSDBE'

DICT_Browse(.t.)

CLOSE DATABASES

RETURN nil

* ---------------

STATIC FUNCTION ExecuteSQL( cStatement, cAlias )

LOCAL oStatement, oSession

SELECT 0

oSession := soAdsSessionDict

oStatement := DC_AdsStatement():New(cStatement,oSession)

IF oStatement:LastError > 0
  RETURN .f.
ENDIF
cAlias := oStatement:Execute( cAlias )
IF Empty(cAlias)
  RETURN .f.
ENDIF

DICT_Browse( .f.)

CLOSE DATABASES

RETURN nil

* ---------------

FUNCTION DICT_Browse( lIsam )

LOCAL GetList[0], GetOptions, oBrowse, cAlias := Alias(), ;
      aFields, i

aFields := dbStruct()

@ 0,0 DCPUSHBUTTON CAPTION 'Print' SIZE 10,1 ;
      ACTION {||PrintBrowse(oBrowse)}

@ 1,0 DCBROWSE oBrowse ALIAS cAlias SIZE 100, 20 ;
      PRESENTATION DC_BrowPres() ;
      FONT '9.Lucida Console'

FOR i := 1 TO Len(aFields)
  DCBROWSECOL DATA DC_FieldWBlock(aFields[i,1],cAlias) ;
    PARENT oBrowse HEADER aFields[i,1]
NEXT

DCREAD GUI FIT TITLE IIF( lIsam, 'Browsing ISAM','Browsing SQL Statement')

RETURN nil

* ---------------

FUNCTION PrintBrowse( oBrowse )

LOCAL oPrinter, aOptions, nRecNo, nPage := 1, nRow := 1, nCol, i, ;
      xValue, aStru

IF !Print_Choice( 'SQL Statement' ) .OR. ;
   !PrintOn('SQL Statement',@oPrinter)
  RETURN .f.
ENDIF

DCPRINT OPTIONS TO aOptions

nRecNo := RecNo()
DC_DbGoTop()
aStru := dbStruct()

DO WHILE !Eof()

  IF nRow == 1

    DCPRINT FONT '9.Lucida Console Bold' PRINTER oPrinter
    nCol := 0
    FOR i := 1 TO Len(aStru)
      @ nRow, nCol DCPRINT SAY aStru[i,1] PRINTER oPrinter
      nCol += Max(aStru[i,3],Len(aStru[i,1])) + 1
    NEXT
    DCPRINT FONT '9.Lucida Console' PRINTER oPrinter
    nRow += 2

  ENDIF

  nCol := 0
  FOR i := 1 TO Len(aStru)
    xValue := &(aStru[i,1])
    IF xValue == NIL
      xValue := ''
    ENDIF
    @ nRow, nCol DCPRINT SAY xValue PRINTER oPrinter
    nCol += Max(aStru[i,3],Len(aStru[i,1])) + 1
  NEXT
  nRow++

  IF nRow > 60
    nRow := 1
    nPage++
    DCPRINT EJECT PRINTER oPrinter
  ENDIF

  DC_DbSkip()

ENDDO

PrintOff( oPrinter )
dbGoTo(nRecNo)

RETURN .t.

* ---------------

FUNCTION GuiRun( bBlock )

LOCAL oThread

oThread := Thread():new()
oThread:start( {||_GuiRun(bBlock)} )

RETURN .t.

* ----------------

STATIC FUNCTION _GuiRun( bBlock )

LOCAL cSession, oAdsSessionDict, oAdsSessionFree, cServer, oParent

Set(_SET_NULLVALUE,.f.)

cServer := scDictServer

oAdsSessionDict := AdsSessionDict():setDefault()
//oAdsSessionFree := AdsSessionFree():setDefault()

dbeSetDefault('ADSDBE')

BEGIN SEQUENCE

Eval( bBlock )

END SEQUENCE

RETURN nil

* ------------------

FUNCTION DICT_DictTableProperties( lShowPane, cTableName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment' }, ;
   { ADS_DD_USER_DEFINED_PROP, Space(200), 200, 'User Defined Table Property'}, ;
   { ADS_DD_TABLE_VALIDATION_EXPR, Space(200), 200, 'Record Level Validation Expression'}, ;
   { ADS_DD_TABLE_VALIDATION_MSG, Space(200), 200, 'Table Validation Error Message'}, ;
   { ADS_DD_TABLE_PRIMARY_KEY, Space(200), 200, 'Table Primary Key'}, ;
   { ADS_DD_TABLE_TYPE, 2, 2, 'Type of Base Table'}, ;
   { ADS_DD_TABLE_FIELD_COUNT, 100, 100, 'Field Count'}, ;
   { ADS_DD_TABLE_ENCRYPTION, 2, 2, 'Encryption State'}, ;
   { ADS_DD_TABLE_DEFAULT_INDEX, Space(200), 200, 'Default Index'}, ;
   { ADS_DD_TABLE_IS_RI_PARENT, 2, 2, 'Is Referential Integrity Rule?'}, ;
   { ADS_DD_TABLE_AUTO_CREATE, 2, 2, 'Is Auto Created?'}, ;
   { ADS_DD_TABLE_PERMISSION_LEVEL, 2, 2, 'Table Permission Level'}, ;
   { ADS_DD_TABLE_MEMO_BLOCK_SIZE, 2, 2, 'Memo Block Size'} }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetTableProperty( nConnectHandle, ;
                         cTableName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'Table: ' + cTableName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictIndexProperties( lShowPane, cTableName, cIndexName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment' }, ;
   { ADS_DD_INDEX_FILE_NAME, Space(200), 200, 'Index File Name'}, ;
   { ADS_DD_INDEX_EXPRESSION, Space(200), 200, 'Index Expression'}, ;
   { ADS_DD_INDEX_CONDITION, Space(200), 200, 'Index Condition'}, ;
   { ADS_DD_INDEX_OPTIONS, 4, 4, 'Index Options'}, ;
   { ADS_DD_INDEX_KEY_LENGTH, 2, 2, 'Index Key Length'}, ;
   { ADS_DD_INDEX_KEY_TYPE, 2, 2, 'Index Key Type'} }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetIndexProperty( nConnectHandle, ;
                         cTableName, ;
                         cIndexName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'Table: ' + cTableName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictViewProperties( lShowPane, cViewName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment'}, ;
   { ADS_DD_VIEW_STMT, Space(200), 200, 'Statement' }, ;
   { ADS_DD_VIEW_STMT_LEN, Space(200), 200, 'Statement Length'} }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetViewProperty( nConnectHandle, ;
                         cViewName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'View: ' + cViewName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictFieldProperties( lShowPane, cTableName, cFieldName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment'}, ;
   { ADS_DD_USER_DEFINED_PROP, Space(200), 200, 'User Defined Property' }, ;
   { ADS_DD_FIELD_DEFAULT_VALUE, Space(200), 200, 'Default Value'}, ;
   { ADS_DD_FIELD_CAN_NULL, 2, 2, 'Null Value Allowed'}, ;
   { ADS_DD_FIELD_MIN_VALUE, Space(200), 200, 'Minimum Value'}, ;
   { ADS_DD_FIELD_MAX_VALUE, Space(200), 200, 'Maximum Value'}, ;
   { ADS_DD_FIELD_VALIDATION_MSG, Space(200), 200, 'Validation Error Message'}, ;
   { ADS_DD_FIELD_LENGTH, 2, 2, 'Field Length'}, ;
   { ADS_DD_FIELD_TYPE, 2, 2, 'Field Type'}, ;
   { ADS_DD_FIELD_DECIMAL, 2, 2, 'Field Decimals'} }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetFieldProperty( nConnectHandle, ;
                         cTableName, ;
                         cFieldName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'Field: ' + cTableName + '.' + cFieldName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictGroupProperties( lShowPane, cGroupName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment'}, ;
   { ADS_DD_USER_DEFINED_PROP, Space(200), 200, 'User Defined Property' } }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetUserGroupProperty( nConnectHandle, ;
                         cGroupName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'Group: ' + cGroupName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictUserProperties( lShowPane, cUserName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment'}, ;
   { ADS_DD_USER_DEFINED_PROP, Space(200), 200, 'User Defined Property' }, ;
   { ADS_DD_USER_GROUP_MEMBERSHIP, Space(200), 200, 'Group Membership' } }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetUserProperty( nConnectHandle, ;
                         cUserName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'User: ' + cUserName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* ------------------

FUNCTION DICT_DictRIProperties( lShowPane, cRIName, nConnectHandle )

LOCAL aProperties, i, nProperty, xValue, nLen, nError, nRow, ;
      GetList[0], GetOptions, nColor, oAppWindow

aProperties := { ;
   { ADS_DD_COMMENT, Space(200), 200, 'Comment'}, ;
   { ADS_DD_RI_PRIMARY_TABLE, Space(200), 200, 'Primary Table' }, ;
   { ADS_DD_RI_PRIMARY_INDEX, Space(200), 200, 'Primary Index' }, ;
   { ADS_DD_RI_FOREIGN_TABLE, Space(200), 200, 'Foreign Table' }, ;
   { ADS_DD_RI_FOREIGN_INDEX, Space(200), 200, 'Foreign Index' }, ;
   { ADS_DD_RI_NO_PKEY_ERROR, Space(200), 200, 'Primary Key Violation Error Message' }, ;
   { ADS_DD_RI_CASCADE_ERROR, Space(200), 200, 'Cascade Error Message' }, ;
   { ADS_DD_RI_UPDATERULE, 2, 2, 'Update Rule for RI Constraint' }, ;
   { ADS_DD_RI_DELETERULE, 2, 2, 'Delete Rule for RI Constraint' } }

nRow := 0

FOR i := 1 TO Len(aProperties)

  ASize(aProperties[i],7)
  nProperty := aProperties[i,1]
  xValue := aProperties[i,2]
  nLen := aProperties[i,3]

  nError := AdsDDGetRefIntegrityProperty( nConnectHandle, ;
                         cRIName, ;
                         nProperty, ;
                         @xValue, ;
                         @nLen )

  IF Valtype(xValue) = 'C'
    xValue := Strtran(xValue,Chr(0),'')
  ENDIF
  aProperties[i,5] := xValue
  aProperties[i,6] := nError
  aProperties[i,7] := AllTrim(DC_AdsGetLastError())

  IF nError == 0
    nColor := GRA_CLR_WHITE
  ELSE
    nColor := GRA_CLR_PALEGRAY
  ENDIF

  @ nRow++, 0 DCSAY aProperties[i,4] + ':' SAYSIZE 0 SAYBOTTOM
  @ nRow++, 0 DCGET aProperties[i,5] GETSIZE IIF(aProperties[i,3]>100,50,nil) ;
              TOOLTIP aProperties[i,7] COLOR nil, nColor

NEXT

oAppWindow := DICT_PropertiesPane()

DCGETOPTIONS NORESIZE EDITPROTECT {||.t.} COLOR GRA_CLR_WHITE
DCREAD GUI FIT ;
   NOAUTORESTORE ;
   _MODAL !lShowPane ;
   BUTTONS IIF(!lShowPane,DCGUI_BUTTON_OK,nil) ;
   TITLE 'Relation (RI): ' + cRIName + ' Properties' ;
   OPTIONS GetOptions ;
   APPWINDOW oAppWindow ;
   _EXIT lShowPane

RETURN nil

* -------------

FUNCTION DICT_DictRemoveTable( cTableName, nConnectHandle, lPrompt )

LOCAL nError

DEFAULT lPrompt := .t.

nError := AdsDDRemoveTable( nConnectHandle, ;
                            cTableName, ;
                            0 )

IF lPrompt
  IF nError > 0
    DC_WinAlert( DC_AdsGetLastError() )
  ELSE
    DCMSGBOX 'Table ' + cTableName + ' has been removed from Dictionary'
  ENDIF
ENDIF

RETURN nError

* -------------

FUNCTION DICT_DictReindexTable( cTableName, nConnectHandle )

LOCAL nError, nTablehandle := 0

nError := AdsOpenTable( nConnectHandle, ;
              cTableName, ;
              '', ;
              ADS_DEFAULT, ;
              ADS_OEM, ;
              ADS_PROPRIETARY_LOCKING, ;
              ADS_IGNORERIGHTS, ;
              ADS_EXCLUSIVE, ;
              @nTableHandle )

IF nError > 0
  DC_WinAlert(DC_AdsGetLastError())
  RETURN .f.
ENDIF

DC_PointerWait()
nError := AdsReindex( nTableHandle )
AdsCloseTable(nTableHandle)
DC_PointerArrow()

IF nError > 0
  DC_WinAlert(DC_AdsGetLastError())
  RETURN .f.
ELSE
  DCMSGBOX 'Reindex Complete!'
ENDIF

RETURN .t.

* -------------

FUNCTION DICT_DictViewExecuteSQL( cViewName, nConnectHandle )

LOCAL nProperty, cStatement, nLen, nError

nProperty := ADS_DD_VIEW_STMT
cStatement := Space(500)
nLen := 500

nError := AdsDDGetViewProperty( nConnectHandle, ;
                         cViewName, ;
                         nProperty, ;
                         @cStatement, ;
                         @nLen )

cStatement := Pad(cStatement,nLen)

GuiRun({|a|ExecuteSQL(cStatement,a)})

RETURN nil

* ----------------

FUNCTION DICT_ShowPropertiesPane( oData )

LOCAL aData := oData:cargo

IF Empty(aData)
  // No properties
  DICT_PropertiesPane()
ELSEIF aData[1] = 'Data Dict'
  DICT_PropertiesPane()
ELSEIF aData[1] = 'Table'
  DICT_DictTableProperties( .t., aData[2], snDictHandle )
ELSEIF aData[1] = 'Index File'
  DICT_PropertiesPane()
ELSEIF aData[1] = 'View'
  DICT_DictViewProperties( .t., aData[2], snDictHandle )
ELSEIF aData[1] = 'Field'
  DICT_DictFieldProperties( .t., aData[3], aData[2], snDictHandle )
ELSEIF aData[1] = 'Group'
  DICT_DictGroupProperties( .t., aData[2], snDictHandle )
ELSEIF aData[1] = 'User'
  DICT_DictUserProperties( .t., aData[2], snDictHandle )
ELSEIF aData[1] = 'RI'
  DICT_DictRIProperties( .t., aData[2], snDictHandle )
ELSEIF aData[1] = 'Index Tag'
  DICT_DictIndexProperties( .t., aData[3]:cargo[3]:cargo[2], ;
                                aData[2], snDictHandle )
ENDIF

RETURN nil

* ------------

FUNCTION DICT_PropertiesPane()

LOCAL i, aChildList

IF slPropertiesPane
  aChildList := soPropertiesPaneParent:childList()
  FOR i := 1 TO Len(aChildList)
    IF aChildList[i]:status() > 0
      aChildList[i]:destroy()
    ENDIF
  NEXT
  RETURN soPropertiesPaneParent
ENDIF

RETURN nil

* ---------------

FUNCTION DICT_ReplaceNullValues( cTableName )

LOCAL i, aStru, xValue, nLen, nCount := 0

dbSetNullValue(.t.)
Set(_SET_NULLVALUE,.t.)

DICT_Use(cTableName,.t.)
OrdSetFocus(0)
aStru := dbStruct()
nLen := Len(aStru)
dbGoTop()

DC_PointerWait()

DO WHILE !Eof()
  FOR i := 1 TO nLen
    IF FieldGet(i) == nil
      IF aStru[i,2] == 'C'
        xValue := ' '
      ELSEIF aStru[i,2] == 'N'
        xValue := 0
      ELSEIF aStru[i,2] == 'D'
        LOOP
        xValue := CtoD('')
      ELSEIF aStru[i,2] == 'L'
        xValue := .f.
      ELSE
        LOOP
      ENDIF
      FieldPut(i,xValue)
      IF ++nCount % 1000 == 0
        soMessageBox:setCaption( Alltrim(Str(nCount)) + ' fields replaced' )
      ENDIF
    ENDIF
  NEXT
  DbSkip()
ENDDO
DC_PointerArrow()

soMessageBox:setCaption( Alltrim(Str(nCount)) + ' fields replaced' )

RETURN nil

* --------------

FUNCTION DICT_SetDefaultValues( cTableName, nConnectHandle )

LOCAL i, aFields, xValue, nLen, nError, cFieldName, cSQL, ;
      nStatementHandle, nCursor, nFieldCount := 0

aFields := GetFieldNameArray( cTableName, nConnectHandle )

FOR i := 1 TO Len(aFields)

  cFieldName := aFields[i]
  xValue := Space(30)
  nLen := 30

  nError := AdsDDGetFieldProperty( nConnectHandle, ;
                         cTableName, ;
                         cFieldName, ;
                         ADS_DD_FIELD_DEFAULT_VALUE, ;
                         @xValue, ;
                         @nLen )

  xValue := Alltrim(Strtran(xValue,Chr(0),''))

  IF nError # 5138 // property was already set
    LOOP
  ENDIF

  xValue := 0
  nLen := 2

  nError := AdsDDGetFieldProperty( nConnectHandle, ;
                         cTableName, ;
                         cFieldName, ;
                         ADS_DD_FIELD_TYPE, ;
                         @xValue, ;
                         @nLen )

  IF xValue == ADS_NUMERIC
    xValue := '0'
  ELSEIF xValue == ADS_DATE
    xValue := ' '
  ELSEIF xValue == ADS_STRING
    xValue := ' '
  ELSEIF xValue == ADS_MEMO
    LOOP
  ELSEIF xValue == ADS_LOGICAL
    xValue := 'FALSE'
  ELSE
    LOOP
  ENDIF

  cSQL := "EXECUTE PROCEDURE sp_ModifyFieldProperty(" + ;
            "'?'," + ;
            "'?'," + ;
            "'FIELD_DEFAULT_VALUE'," + ;
            "?," + ;
            "'RETURN_ERROR'," + ;
            "NULL );"

  cSQL := DICT_ApplySQLParams( cSQL, { cTableName, cFieldName, xValue } )

  nStatementHandle := 0
  nError := AdsCreateSQLStatement( nConnectHandle, @nStatementHandle)

  nCursor := 0
  nError := AdsExecuteSQLDirect( nStatementHandle, cSQL, @nCursor )

  IF nError > 0
    DC_WinAlert( DC_AdsGetLastError() )
  ELSE
    nFieldCount++
  ENDIF

  AdsCloseSQLStatement( nStatementHandle )

NEXT

soMessageBox:setCaption( Alltrim(Str(nFieldCount)) + ' field default values were updated' )

RETURN nil

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

* ----------

STATIC FUNCTION FieldList( nDictHandle )

LOCAL GetList[0], GetOptions, aFields, lStatus, cFieldList, cTableName

cTableName := Space(25)

@ 0,0 DCSAY 'Table Name' GET cTableName PICT '@!' SAYSIZE 0 SAYBOTTOM

DCGETOPTIONS NORESIZE
DCREAD GUI FIT ADDBUTTONS TO lStatus MODAL TITLE 'Insert Field List' ;
   OPTIONS GetOptions ENTEREXIT NOAUTORESTORE

IF lStatus
  aFields := GetFieldNameArray( Alltrim(cTableName), nDictHandle )
ELSE
  RETURN ''
ENDIF

IF Empty(aFields)
  DC_WinAlert('Invalid Table name')
ENDIF

cFieldList := DC_Array2String(aFields)
cFieldList := StrTran(cFieldList,'{','')
cFieldList := StrTran(cFieldList,'}','')
cFieldList := StrTran(cFieldList,'"','')

RETURN cFieldList

* ----------------

FUNCTION BuildABCDD()

LOCAL GetList[0], GetOptions, lStatus, aFiles[0], i, cIndexName

USE U90FL VIA 'DBFCDX'

DO WHILE !Eof()
  AAdd( aFiles, { Alltrim(U90FL->dbf_name), Alltrim(U90FL->descrip), {} } )
  FOR i := 1 TO 10
    cIndexName := &('U90FL->index' + Alltrim(Str(i)))
    IF !Empty(cIndexName)
      AAdd( ATail(aFiles)[3],Alltrim(cIndexName))
    ENDIF
  NEXT
  U90FL->(dbSkip())
ENDDO

DC_AdsArray2DD( 'ABC.ADD', 'ABC System', , aFiles )

RETURN nil

* --------------

FUNCTION DC_AdsArray2DD( cFileName, cFileDesc, cFilePath, aFiles, cUserName, cPassword )

LOCAL nHandle := 0, cErrorString, lStatus, cTableName, i, j, ;
      cIndexes, cComments, cFile, nError, aIndex, cIndexName, ;
      cDesc

DEFAULT cFilePath := DC_Path(AppName(.t.)), ;
        cUserName := '', ;
        cPassWord := ''

AdsSetServerType( ADS_REMOTE_SERVER + ADS_LOCAL_SERVER )

IF File(Alltrim(cFileName))

  DCMSGBOX Alltrim(cFileName), 'Dictionary file already exists.', ;
     'Add tables to existing file?' YESNO TO lStatus

  IF !lStatus
    RETURN .F.
  ENDIF

  nError := AdsConnect60( Alltrim(cFileName), ;
                ADS_REMOTE_SERVER + ADS_LOCAL_SERVER, ;
                cUserName, ;
                cPassword, ;
                ADS_DEFAULT, ;
                @nHandle )

ELSE

  nError := AdsDDCreate( Alltrim(cFileName), .F., Alltrim(cFileDesc), @nHandle )
  IF nError == 0 .AND. !Empty(cUserName)
    AdsDDCreateUser( nHandle, '', cUserName, cPassword, 'Administrative User' )
  ENDIF

Endif

IF nHandle <= 0 .OR. nError > 0
  cErrorString := DC_AdsGetLastError()
  DC_WinAlert(cErrorString)
  RETURN .F.
ENDIF

FOR i := 1 TO Len(aFiles)
  cIndexes := ''
  cComments := ''

  cTableName := Alltrim(aFiles[i,1])
  cDesc := Alltrim(aFiles[i,2])

  nError := AdsDDAddTable( nHandle, cTableName, cTableName+'.DBF', ADS_NTX, ADS_OEM, '', cDesc )
  IF nError > 0
    cErrorString := DC_AdsGetLastError()
    DCMSGBOX cErrorString, cTableName+'.DBF','','Continue Adding Files?' YESNO TO lStatus
    IF !lStatus
      EXIT
    ENDIF
  ELSE
    aIndex := aFiles[i,3]
    FOR j := 1 TO Len(aIndex)
      cIndexName := aIndex[j] + '.NTX'
      nError := AdsDDAddIndexFile( nHandle, cTableName, cIndexName )
      IF nError > 0
        cErrorString := DC_AdsGetLastError()
        DCMSGBOX cErrorString, 'Continue Adding Index Files?' YESNO TO lStatus
        IF !lStatus
          EXIT
        ENDIF
      ENDIF
    NEXT
  ENDIF
NEXT

AdsDisconnect(nHandle)

IF nError == 0
  DCMSGBOX 'Done!' TIMEOUT 2
ENDIF

RETURN .T.

* -----------

FUNCTION DICT_ApplySQLParams( cSqlStatement, aParams )

LOCAL i, cValue, cDate, xValue, nError

FOR i := 1 TO Len(aParams)
   IF aParams[i] == NIL
      LOOP
   ENDIF
   xValue := aParams[i]
   IF Valtype(xValue) == 'N'
      cValue := Alltrim(Str(xValue))
   ELSEIF Valtype(xValue) == 'L'
      IF xValue
         cValue := 'TRUE'
      ELSE
         cValue := 'FALSE'
      ENDIF
   ELSEIF Valtype(xValue) == 'D'
      cDate := DtoS(xValue)
      cDate := Ltrim(Rtrim(SubStr(cDate,1,4) + '-' + ;
         SubStr(cDate,5,2) + '-' + ;
         SubStr(cDate,7,2)))
      cValue := "{ d '" + cDate + "'}"
   ELSEIF Valtype(xValue) == 'C'
      cValue := "'" + xValue + "'"
   ELSE
      cValue := Trim(DC_XtoC(xValue))
   ENDIF
   cSqlStatement := StrTran(cSqlStatement,'?',cValue,,1)
NEXT

RETURN cSqlStatement

* ---------------

FUNCTION DICT_ExecuteSQL( cStatement, cErrorString, nRecords, oSession )

LOCAL oDictConnection, nDictHandle, nIndexMode := ADS_CDX, ;
      nHandle, nStatementHandle, lStatus := .t., ;
      nLockingMode := ADS_PROPRIETARY_LOCKING, nError

DEFAULT nRecords := 0

IF Empty(oSession)
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

* --------------

FUNCTION DICT_GetDictInfo( cFileName, cAlias, aStru, aIndex )

LOCAL cSearchStr, aTokens, nFound, nHandle, cText, aSubIndex

cFileName := Alltrim(Upper(cFilename))

nHandle := DC_TxtOpen('.\TABLES\ALLTABLES.SQL')
IF nHandle > 0
  cSearchStr := 'CREATE TABLE ' + cFileName
  nFound := DC_Txtfind( nHandle, cSearchStr )
  IF nFound > 0
    aStru := Array(0)
    aIndex := Array(0)
    DC_TxtSkip( nHandle, 1 )
    DO WHILE !DC_TxtEof( nHandle )
      cText := Alltrim(DC_TxtLine( nHandle ))
      DC_TxtSkip( nHandle )
      IF cText = 'CREATE TABLE'
        EXIT
      ELSEIF '(' $ cText .AND. ')' $ cText
        cText := StrTran(cText,'(','')
        cText := StrTran(cText,')','')
        aTokens := DC_TokenArray( cText, ' ,' )
        ASize(aTokens,4)
        aTokens[2] := Left(aTokens[2],1)
        aTokens[3] := Val(DC_XtoC(aTokens[3]))
        aTokens[4] := Val(DC_XtoC(aTokens[4]))
        aTokens[1] := Strtran(aTokens[1],'[','')
        aTokens[1] := Strtran(aTokens[1],']','')
        AAdd( aStru, aTokens )
      ELSEIF cText = 'EXECUTE PROCEDURE sp_CreateIndex'
        DC_TxtSkip( nHandle, 1 )
        aSubIndex := Array(0)
        DO WHILE !DC_TxtEof( nHandle )
          cText := Alltrim(DC_TxtLine( nHandle ))
          IF Empty(cText)
            EXIT
          ENDIF
          cText := Strtran(cText,"'","")
          cText := Strtran(cText,",","")
          cText := Strtran(cText,";","")
          AAdd( aSubIndex, cText )
          DC_TxtSkip(nHandle,1)
        ENDDO
        ASize( aSubIndex, 5 )
        aSubIndex[5] := IIF( aSubIndex[5]=='2',.f.,.t. )
        AAdd( aIndex, aSubIndex )
      ENDIF
    ENDDO
    DC_TxtClose( nHandle )
    RETURN nil
  ENDIF
ENDIF

RETURN nil

* -------------

FUNCTION DICT_RunProc()

LOCAL GetList[0], cExpression := Space(200), cRunMode := 'G', lStatus, ;
   GetOptions, bExpr, bError

@ 4,0 DCSAY 'Expression to Run' GET cExpression ;
   GETSIZE 60 ;
   SAYSIZE 0 ;
   SAYBOTTOM ;
   GETID 'EXPRESSION' ;
   VALID {||DC_ValidateBlock(cExpression,,@bExpr,.f.)}

DCGETOPTIONS NOMINBUTTON NOMAXBUTTON NORESIZE
DCREAD GUI FIT ADDBUTTONS TITLE 'Run a Program' MODAL TO lStatus ;
   OPTIONS GetOptions ENTEREXIT SETFOCUS 'EXPRESSION' NOAUTORESTORE

IF lStatus
   GuiRun( bExpr )
ENDIF

RETURN nil

* ---------------

FUNCTION DICT_AdsDictInit( cUserName, cPassword, nDictHandle, nFreeHandle)

DEFAULT cUserName := 'adssys', ;
        cPassword := ''

scUserName := cUserName
scPassword := cPassword
scDictServer := scDictName + ';UID=' + scUserName + ';PWD=' + scPassword + ';DbfsUseNulls=FALSE'
scFreeServer := CurDrive()
snDictHandle := nDictHandle
snFreeHandle := nFreeHandle

RETURN nil

* --------------

FUNCTION AdsSessionDict()

RETURN soAdsSessionDict

* --------------

FUNCTION AdsSessionFree()

RETURN soAdsSessionFree

* --------------

FUNCTION DICT_Use( cFileName, lExclusive, cAlias, cTagName, ;
                 lStruTest, lIndexBuild, lUseAlias, lDisperror, ;
                 nWait, cPath, aParams )

LOCAL i, lOk, aStru, aIndex, lStruUpdated, nWorkArea, cOldrdd,;
              aStructs, aSubStru, oDictConnection, oStatement, ;
              cSql, cStatement

cFileName  := IIF(Valtype(cFileName)='C',UPPER(cFileName),'')
cPath      := IIF(Valtype(cPath)='C',alltrim(UPPER(cPath)),'')
lExclusive := IIF(Valtype(lExclusive)='L',lExclusive,.f.)
cAlias     := UPPER(IIF(Valtype(cAlias)='C',cAlias,cFileName))
lStruTest  := .f. // IIF(Valtype(lStruTest)='L',lStruTest, .f.)
lIndexBuild:= IIF(Valtype(lIndexBuild)='L',lIndexBuild, .f.)
lUseAlias  := IIF(Valtype(lUseAlias)='L',lUseAlias, .f.)
lDispError := IIF(Valtype(lDispError)='L',lDispError,.t.)
nWait      := IIF(Valtype(nWait)='N',nWait,10)

oDictConnection := AdsSessionDict():setDefault()

IF Upper(AllTrim(cFileName))='SELECT'
  IF cAlias = 'SELECT'
    cAlias := 'QUERY'
  ENDIF
  oStatement := DC_AdsStatement():New(cFileName,oDictConnection)
  IF oStatement:LastError > 0
    RETURN .f.
  ENDIF
  cAlias := oStatement:Execute(cAlias)
  RETURN !Empty(cAlias)
ELSEIF Upper(cFileName)='DCUSERS'
  cFilename := 'TLUSERS'
ENDIF

nWorkArea  := Select(cAlias)
IF nWorkArea > 0
   Select(nWorkArea)
   IF Valtype(cTagName)='C'
      OrdSetFocus(cTagName)
   ENDIF
   RETURN .t.
ENDIF

SET DELETED ON

IF lStruTest

  aIndex := nil
  DICT_GetDictInfo( cFileName, cAlias, @aStru, @aIndex )
  IF Valtype(aStru) == 'A'
    FOR i := 1 TO Len(aStru)
      aStru[i,1] := Alltrim(aStru[i,1])
    NEXT
    aSubStru := { { 'RECORD_ID','C',30,0} }
    FOR i := 1 TO Len(aSubStru)
      IF AScan(aStru,{|a|Upper(Alltrim(a[1]))==Upper(Alltrim(aSubStru[i,1]))}) == 0
        AAdd(aStru,aSubstru[i])
      ENDIF
    NEXT
  ENDIF

ELSEIF !lStruTest .AND. File(cPath+cFilename+DC_DbfExt())

  aStru := nil

ENDIF

IF nWorkArea <= 0

  lOk := .f.
  IF lUseAlias
    FOR i := 1 TO 20
       Select (i)
       IF '\'+(cFileName)+'.DBF' $ dc_tablename()
          lOk := .t.
          EXIT
       ENDIF
    NEXT
  ENDIF
  IF lOk
    RETURN .t.
  ENDIF

  SELE 0

  /*
  IF !File(DC_CurPath()+ '\' + cFilename+'.DBF')
    cSql := DC_CurPath() + '\STRUC\TABLES\' + cFileName + '.sql'
    cStatement := MemoRead(cSql)
    IF !Empty(cStatement)
      TL_ExecuteSQL(cStatement)
    ENDIF
  ENDIF

  IF !File(DC_CurPath() + '\' + cFilename+'.CDX')
    cSql := DC_CurPath() + '\STRUC\INDEXES\' + cFileName + '.sql'
    cStatement := MemoRead(cSql)
    IF !Empty(cStatement)
      TL_ExecuteSQL(cStatement)
    ENDIF
  ENDIF
  */

  lOk := DC_Dbfile( nil ,alltrim(cPath)+cFileName, .t., lExclusive, nWait, ;
                    oDictConnection, .f., aStru, cAlias, !lDispError, nil, ;
                    @lStruUpdated, nil, .f. )

  dbSetNullValue(.f.)

ENDIF

IF Valtype(cTagName)='C' .AND. !Empty(Alias())
  OrdSetFocus(cTagName)
ENDIF

RETURN .t.

* -----------

FUNCTION DICT_LoadDbes()

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

IF !('DBFDBE'$aDbeList) .AND. !DbeLoad( "DBFDBE",.T.)
   Alert( "Database-Engine DBFDBE not loaded" , {"OK"} )
ENDIF

IF !('CDXDBE'$aDbeList) .AND. !DbeLoad( "CDXDBE",.T.)
   Alert( "Database-Engine CDXDBE not loaded" , {"OK"} )
ENDIF

IF !('DBFCDX'$aDbeList) .AND. !DbeBuild( "DBFCDX", "DBFDBE", "CDXDBE" )
   Alert( "DBFCDX Database-Engine;Could not build engine" , {"OK"} )
ENDIF

RETURN soAdsSessionDict


