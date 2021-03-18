//////////////////////////////////////////////////////////////////////
//
//  drgFile.PRG
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgFile holds a description of a DB file.
//       Description consists of fields, indexes, relations, search fields descriptions.
//
//   Remarks:
//       relations array holds field name [1]
//                             relation file name [2]
//                             relation type [3] 1=Strict, 2=may be blank, 3=categorized
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Set.ch"
#include "dbfdbe.ch"
#include "dbstruct.ch"
*
#include "dmlb.ch"
#include "ads.ch"
#include "adsdbe.ch"


CLASS drgFile
EXPORTED:
  VAR     dbdName         // dbd file name
  VAR     fileName        // database file name
  VAR     aliasName       // database alias name
  VAR     description     // database description
  VAR     dbEngine        // default database engine
  VAR     dbOptions       // database engine options

  VAR     desc            // array holding database fields descriptions
  VAR     indexDef        // array holding index definitions
  VAR     srchDef         // pole obsahujíci search definici                    // MISs
  VAR     srchFields      // string holding fields shown upon search
  VAR     srchReturn      // string holding field name returned upon search
  VAR     srchOrder       // num, starting order upon search
  VAR     relDef          // pole obsahující definici relaèních vazeb
  VAR     defaultDir      // default directory for this file. Usualy drgINI:dir_DATA
  VAR     status          // Status of this DBD. Used when editing description

  VAR     lIsCheck        // bude/nebude kontrolována pøi staru úlohy
  VAR     isCrypt         // zda bude soubor klíèován

  VAR     task            // pod kterou úlohou je tabulka zaøazena

  METHOD  init            // object initializacion
  METHOD  destroy         // release all resources used by this object
  METHOD  parse           // parses one line from DBD description
  METHOD  open            // open file associated with this object
  METHOD  dbdCheck        // checks dbd and recreates file if necessary
  METHOD  getRelation     // returns relation parameters for the specifield field
  METHOD  getCaption      // returns caption for the specifield field
  METHOD  getValues       // returns allowed values for the specifield field
  METHOD  getFieldDesc    // returns description of a field

  METHOD  getFieldDec     // return dec - poèet desetinných míst pro field

  METHOD  fieldIndex      // returns index to fields array for specifield field
  METHOD  indexNum        // returns number of index if passed field is part of index
  METHOD  getName         // Returns full name for specified file. Must be EXPORTED. EVAL.

  METHOD  openIndex       // opens all indexes for this file DBFNTX
  METHOD  createIndex     // creates indexes if necessary
  METHOD  setBrowseCodeBlocks

HIDDEN:
  VAR     defDBext       // default DB file extension
  VAR     defIXext       // default Index file extension

  METHOD  cloneRef        // clones reference fields properties
  METHOD  dbdGoFile       // processes FILE section of dbd file
  METHOD  dbdGoField      // processes FIELD section of dbd file
  METHOD  dbdGoIndex      // processes INDEX section of dbd file
  METHOD  dbdGoSearch     // processes SEARCH section of dbd file
  METHOD  dbdGoRelations  // processwd RELATIONS section of dbd file
  METHOD  setOptions

        // Sets options for this DBENGINE
ENDCLASS

***************************************************************************
* Initialize drgFile object. Reads description file
***************************************************************************
METHOD drgFile:init(cDBDName, aOptions)
  ::dbdName    := cDBDName
  ::dbOptions  := ACLONE(aOptions)
  ::defaultDir := drgINI:dir_DATA
  ::desc       := {}
  ::indexDef   := {}
  ::srchDef    := {}
  ::relDef     := {}
  ::status     := 0
  ::lIsCheck   := .T.
  ::isCrypt    := .F.
  ::task       := ''
RETURN self

***********************************************************************
* Reads and returns one section of description file
***********************************************************************
METHOD drgFile:parse(st)
LOCAL aType
  aType := UPPER(drgGetParm("TYPE",st))
  DO CASE
  CASE aType = "FILE"
    ::dbdGoFile(st)
  CASE aType = "FIELD"
    ::dbdGoField(st)
  CASE aType = "INDEX"
    ::dbdGoIndex(st)
  CASE aType = "SEARCH"
    ::dbdGoSearch(st)
  case aType = "RELATION"
    ::dbdGoRelations(st)
  ENDCASE
RETURN self

***********************************************************************
* Processes FILE section of dbd file
***********************************************************************
METHOD drgFile:dbdGoFile(st)
LOCAL keyWord, value
LOCAL like, aDBD, aRF, ref, x
  WHILE ( keyWord := _parse(@st, @value) ) != NIL
    DO CASE
    CASE keyWord = 'NAME'
      ::fileName := UPPER(_getStr(value))
    CASE keyWord = 'ALIAS'
      ::aliasName := UPPER(_getStr(value))
    CASE keyWord = 'DESC'
      ::description := _getStr(value)
    Case keyWord = 'NOCHECK'
      ::lIsCheck  := .F.
    Case keyWord = 'CRYPT'
      ::isCrypt   := .T.
    CASE keyWord = 'TASK'
      ::task      := UPPER(_getStr(value))
* Copy Field descriptions from defined file
    CASE keyWord = 'LIKE'
      like := _getStr(value)
      IF ( aDBD := drgDBMS:getDBD(like) ) != NIL
* Copy all fields
        FOR x := 1 TO LEN(aDBD:desc)
          aRF := _drgRF():new()
          ref := aDBD:desc[x]
* Clone data from reference description
          aRF:name    := ref:name
          ::cloneRef(@aRF, ref)
          AADD(::desc, aRF)
        NEXT x
      ENDIF
    ENDCASE
  ENDDO

  DEFAULT ::aliasName TO ''
  DEFAULT ::description TO ::fileName
RETURN

***********************************************************************
* Processes FIELD section of dbd file
***********************************************************************
METHOD drgFile:dbdGoField(st)
  LOCAL aRF, aDBD, keyWord, value
  LOCAL ref, refName, refFile, refDsc
  *
  local org_name

  aRF := _drgRF():new()
  WHILE ( keyWord := _parse(@st, @value) ) != NIL
    DO CASE
    CASE keyWord = 'NAME'
      org_name     := _getStr(value)
      aRF:name     := upper( org_name )
      aRF:org_name := org_name
**      aRF:name    := UPPER(_getStr(value))

    CASE keyWord = 'FTYPE'
      aRF:type    := UPPER( _getStr(value) )
    CASE keyWord = 'FLEN'
      aRF:len     := _getNum(value)
    CASE keyWord = 'DEC'
      aRF:dec     := _getNum(value)
    CASE keyWord = 'CAPTION'
      aRF:caption := _getStr(value)
    CASE keyWord = 'DESC'
      aRF:desc    := _getStr(value)
    CASE keyWord = 'RELATETO'
      aRF:relTO   := UPPER( _getStr(value) )
    CASE keyWord = 'RELATETYPE'
      aRF:relType := _getStr(value)
    CASE keyWord = 'RELATEORD'                                                  // MISs
      aRF:relORD := _getNum(value)
    CASE keyWord = 'VALUES'
      aRF:values := _getStr(value)
    CASE keyWord = 'DEFVALUE'
      aRF:defValue:= _getStr(value)
    CASE keyWord = 'PICTURE'
      aRF:picture := ALLTRIM(_getStr(value))
* Reference field
    CASE keyWord = 'REF'
      refDsc := ALLTRIM(_getStr(value))
      IF AT('->',refDsc) = 0
        refDsc := 'REF->' + refDsc
      ENDIF
      refFile := UPPER(drgParse(refDsc,'-') )
      refName := UPPER(drgParseSecond(refDsc,'>') )
      IF refFile = 'REF'
        IF (ref := drgRef:getRef(refName) ) != NIL
          ::cloneRef(@aRF, ref)
          LOOP
        ENDIF
      ELSE
        IF ( aDBD := drgDBMS:getDBD(refFile) ) != NIL
          IF ( ref := aDBD:getFieldDesc(refName) ) != NIL
            ::cloneRef(@aRF, ref)
            LOOP
          ENDIF
        ENDIF
        drgLog:write('ERROR: Reference ' + refDsc + ' not found. FILE=' + ;
                     ::dbdName +' FIELD=' + aRF:name)
* It is an error
        RETURN
      ENDIF

    ENDCASE
  ENDDO

  *
  ** ADT struktura
  do case
  case aRF:type = 'N'
    do case
    case aRF:dec <> 0
      *
      ** u ADT Numeric je 1B znaménko
      ( aRF:adt_type := 'N'   , aRF:adt_len := aRF:len +1 , aRF:adt_dec := aRF:dec )
**    ( aRF:adt_type := 'F'   , aRF:adt_len := 8          , aRF:adt_dec := aRF:dec )

    case aRF:len >= 1 .and. aRF:len <= 4
      ( aRF:adt_type := 'I'   , aRF:adt_len := 2          , aRF:adt_dec := 0       )

    case aRF:len >  4 .and. aRF:len <= 9
      ( aRF:adt_type := 'I'   , aRF:adt_len := 4          , aRF:adt_dec := 0       )

    otherwise
      ( aRF:adt_type := 'F'   , aRF:adt_len := 8          , aRF:adt_dec := 0       )
    endcase

  case aRF:type = 'M'
    ( aRF:adt_type := 'M'     , aRF:adt_len := 9          , aRF:adt_dec := 0       )

  case aRF:type = 'D'
    ( aRF:adt_type := 'D'     , aRF:adt_len := 4          , aRF:adt_dec := 0       )

  otherwise
    ( aRF:adt_type := aRF:type, aRF:adt_len := aRF:len, aRF:adt_dec := aRF:dec )

  endcase


  if empty(aRF:picture)
    do case
    case(aRF:type = 'N')
      aRF:picture := '@N ' +REPLICATE('9', aRF:len)
      if aRF:dec <> 0
        aRF:picture := Stuff(aRF:picture,aRF:len -aRF:dec +3,1,'.')
      endif

    case(aRF:type = 'D')
      aRF:picture := '@D'

    case(aRF:type = 'C')
      if lower(aRF:name) = 'cobdobi' .or. lower(aRF:name) = 'cobdobidan'
        aRF:picture := '99/99'
      else
        aRF:picture := replicate('X',aRF:len)
      endif
    endcase
  else
    if( at('&',aRF:picture) <> 0, aRF:picture := drgPicture(aRF:picture), nil)
  endif

  AADD(::desc, aRF)
RETURN self


*
** modifikace speciální masky '&99 X'
static function drgPicture(cpic)
  local xpic := cpic
  local x, m, n, i, ch

* Replace all ocurence of & with no. of chars defined by '&99 X'
  do while( x := at('&',cpic)) > 0
    m := ''
    n := 2

* - Search for first non digit char
    for i := x+1 to len(cpic) step 1
      if isdigit(cpic[i])
        m := m +cpic[i]
        n++
      else
        EXIT
      endif
    next

* - if char is blank than next char is to be multiplicated
    if empty(cpic[i])  ;  ch := cpic[i+1]
                          n++
    else               ;  ch := cpic[i]
    endif

    ch   := replicate(ch, val(m))
    cpic := stuff(cpic, x-1, n, ch)
  enddo
return cpic


***********************************************************************
* Clones description of reference field.
***********************************************************************
METHOD drgFile:cloneRef(aDesc, ref)
  aDesc:desc     := ref:desc
  aDesc:type     := ref:type
  aDesc:len      := ref:len
  aDesc:dec      := ref:dec
  aDesc:caption  := ref:caption
  aDesc:relTO    := ref:relTO
  aDesc:relType  := ref:relType
  aDesc:relORD   := ref:relORD
  aDesc:values   := ref:values
  aDesc:defValue := ref:defValue
  aDesc:picture  := ref:picture
  *
  aDesc:org_name := ref:org_name
  aDesc:adt_type := ref:adt_type
  aDesc:adt_len  := ref:adt_len
  aDesc:adt_dec  := ref:adt_dec
RETURN self

***********************************************************************
* Processes INDEX section of dbd file
***********************************************************************
METHOD drgFile:dbdGoIndex(st)
LOCAL keyWord, value
LOCAL oIx
  oIx := _drgIndex():new()
  WHILE ( keyWord := _parse(@st, @value) ) != NIL
    DO CASE
    CASE keyWord = 'NAME'
      oIx:cName     := UPPER(_getStr(value))
    CASE keyWord = 'FNAME'
      oIx:cFileName := UPPER(_getStr(value))
    CASE keyWord = 'CAPTION'
      oIx:cCaption  := _getStr(value)
    CASE keyWord = 'DATA'
      oIx:cIndexKey := UPPER( _getStr(value) )      // vseeno kaj
    CASE keyWord = 'KEY'
      oIx:cIndexKey := UPPER( _getStr(value) )
    CASE keyWord = 'FOR'
      oIx:cFor      := UPPER( _getStr(value) )
    CASE keyWord = 'WHILE'
      oIx:cWhile    := UPPER( _getStr(value) )
    CASE keyWord = 'RECORD'
      oIx:nRecord   := _getNum(value)
    CASE keyWord = 'UNIQUE'
      oIx:lUnique   := UPPER(_getStr(value)) = 'Y'
    CASE keyWord = 'DUPKEYS'
      oIx:lDupKeys  := UPPER(_getStr(value)) = 'Y'
    CASE keyWord = 'DESCEND'
      oIx:lDescend  := UPPER(_getStr(value)) = 'Y'
    CASE keyWord = 'INSORT'
      oIx:lInSort   := UPPER(_getStr(value)) = 'Y'


    ENDCASE
  ENDDO

  DEFAULT oIx:cCaption  TO 'Index ' + ALLTRIM(STR(LEN(::indexDef)+1))
  DEFAULT oIx:lUnique   TO Set(_SET_UNIQUE)
  DEFAULT oIx:lDupKeys  TO .T.
  DEFAULT oIx:lDescend  TO .F.
  DEFAULT oIx:cFileName TO oIx:cName
  DEFAULT oIx:lInSort   TO .T.

  AADD(::indexDef, oIx )
RETURN NIL

***********************************************************************
* Processes SEARCH section of dbd file
***********************************************************************
METHOD drgFile:dbdGoSearch(c)                                                   // MISs
LOCAL cKeyWord, value
LOCAL oSEa

  oSEa := _drgSEA():new()

  WHILE ( cKeyWord := _parse(@c, @value) ) != NIL
    DO CASE
    CASE cKeyWord = 'FIELDS'
      oSEa:srchFields := UPPER(_getStr(value))
    CASE cKeyWord = 'ORDER'
      oSEa:srchOrder  := _getNum(value)
    CASE cKeyWord = 'RETURN'
      oSEa:srchReturn := UPPER(_getStr(value))
    ENDCASE
  ENDDO

  DEFAULT oSEa:srchOrder  TO 1
  DEFAULT oSEa:srchReturn TO ::desc[1]:name

  AAdd(::srchDef, oSEa )
RETURN NIL


METHOD drgFile:dbdGoRelations(c)                                                // MISs
  LOCAL cKeyWord, value, fileName
  LOCAL oRELa, oRELs, oREL, nlevl := 0

  oRELa := _drgREL():new()
  oRELa:mainFile := ::fileName
  oRELa:relSubs  := {}
  oREL  := oRELa

  WHILE ( cKeyWord := _parse(@c, @value) ) != NIL
    if nlevl = 3
      oRELs := _drgREL():new()
      oRELs:mainFile := fileName
      oRELs:relSubs  := {}

      AAdd(oRELa:relSubs, oRELs )
      oREL := oRELs
      nlevl := 0
    endif

    DO CASE
    CASE cKeyWord = 'TO'
      oREL:relFile := UPPER(_getStr(value))
      fileName     := oREL:relFile
      nlevl++
    case( ckeyWord = 'KEY')
      oREL:relKey  := UPPER(_getStr(value))
      nlevl++
    case( ckeyWord = 'TAG')
      oREL:relOrder := _getNum(value)
      nlevl++
    ENDCASE
  ENDDO

  AAdd(::relDef, oRELa)
RETURN NIL


***********************************************************************
* Checks description and or creates file if it doesn't exist, recreates
* indexes if necesary.
***********************************************************************
METHOD drgFile:dbdCheck(lIsWork, cDirName)
LOCAL cFile
LOCAL nType
LOCAL lReIndex

  ::setOptions()                        // this might be called prior to open
  DEFAULT cDirName  TO drgINI:dir_DATA
  DEFAULT lIsWork   TO .F.
*
  cFile := ::getName(, lIsWork, cDirName)

  IF dbdCheckFile(cFile, self, lIsWork)
*    USE (cFile) NEW EXCLUSIVE //- VIA (oSession)
*    if ::isCrypt
*      AX_SetPass(syApa)
*      if( AX_TableType() <> ADS_ENCRYPTED_TABLE, AX_DBFEncrypt(), NIL)
*    endif
*    lReIndex := syCheckDb == 1
*    ::openIndex( lReIndex, parseFileName(cFile, 3), cFile,,.T.)
*    DBCOMMIT()
*    DBCLOSEAREA()
  ENDIF
*
RETURN NIL

***********************************************************************
* Returns default codeblocks for file browseing.
***********************************************************************
METHOD drgFile:setBrowseCodeBlocks(oBrowse, nArea)
  oBrowse:goTopBlock    := {| | (nArea)->( DbGoTop())    }
  oBrowse:goBottomBlock := {| | (nArea)->( DbGoBottom()) }
  oBrowse:phyPosBlock   := {| | (nArea)->( Recno())      }
  oBrowse:skipBlock     := {|n| (nArea)->( DbSkipper(n)) }

  oBrowse:firstPosBlock := {| | 1           }
  oBrowse:lastPosBlock  := {| | 100         }
  oBrowse:posBlock      := {| | (nArea)->( DbPosition())    }
  oBrowse:goPosBlock    := {|n| (nArea)->( DbGoPosition(n)) }
RETURN self

***********************************************************************
* Returns relation if exists otherwise returns NIL
***********************************************************************
METHOD drgFile:getRelation(cName)
LOCAL nPos
  nPos := AScan( ::relations, {|a| cName == a[1] } )
RETURN IIF(nPos = 0, NIL, ::relations[nPos] )

***********************************************************************
* Returns description of field
***********************************************************************
METHOD drgFile:getFieldDesc(cName)
LOCAL x
  x := ::fieldIndex(cName)
RETURN IIF(x = 0, NIL, ::desc[x])

*
* return Field:dec - poèet desetinných míst pro field
method drgFile:getFieldDec(cName)
  local npos := ::fieldIndex(cName)
return if( npos = 0, 0, ::desc[npos]:dec )


***********************************************************************
* Returns index to fields array for specifield field
***********************************************************************
METHOD drgFile:fieldIndex(cName)
  cName := UPPER(cName)
RETURN ASCAN( ::desc, {|a| cName == a:name } )

***********************************************************************
* Returns caption for the field specified either with name or index.
*               7
* Parameters:
*
* < mField > : numeric    : index to field
* < mField > : character  : field name
***********************************************************************
METHOD drgFile:getCaption(mField)
LOCAL n
  IF VALTYPE(mField) = 'N'                      // index passed
    RETURN ::desc[mField]:caption
  ELSEIF (n := ::fieldIndex(mField)) > 0       // fieldname passed
    RETURN ::desc[n]:caption
  ENDIF
RETURN '**'

***********************************************************************
* Return <String> Specified values string if exists. Otherwise returns NIL.
*
* Parameters <aField> : character : Field name
*                     : numeric   : Index position of field in work area
***********************************************************************
METHOD drgFile:getValues(mField)
LOCAL n
  IF VALTYPE(mField) = 'N'                      // index passed
    RETURN ::desc[mField]:values
  ELSEIF (n := ::fieldIndex(mField)) > 0       // fieldname passed
    RETURN ::desc[n]:values
  ENDIF
RETURN NIL

***********************************************************************
* Returns index order number if specified field is part of a index order
***********************************************************************
METHOD drgFile:indexNum(cField)
LOCAL x, nLen, cFileName
  cFileName := UPPER(cField)
  nLen      := LEN(cField)
  FOR x := 1 TO LEN(::indexDef)                 // search through indexes for name
* Field name found in first position of index descriptions
    IF cField = UPPER(LEFT(::indexDef[x]:cIndexKey,nLen))
      RETURN x
    ENDIF
  NEXT x
RETURN 0

****************************************************************************
* Creates index file if it doesn't exist. Parameters are passed as array
* containing name and index description.
****************************************************************************
METHOD drgFile:openIndex(lReCreate, cDirName)
RETURN self

****************************************************************************
* Creates index
****************************************************************************
METHOD drgFile:createIndex(cIxFileName, oIndex)
RETURN self

****************************************************************************
* Sets default database options for this file.
****************************************************************************
METHOD drgFile:setOptions()
LOCAL x, mOpt0, mOpt1
  IF ::defDBext = NIL

* Set default engine
//    IF DbeSetDefault() != ::dbEngine
//      DbeSetDefault(::dbEngine)
//    ENDIF
* Set options
    FOR x := 1 TO LEN(::dbOptions)
* Get option
      mOpt0 := DbeInfo( ::dbOptions[x,1],  ::dbOptions[x,2] )
      IF VALTYPE(mOpt0) = 'N'
        mOpt1 := VAL(::dbOptions[x,3])
      ELSEIF VALTYPE(mOpt0) = 'L'
        mOpt1 := _getLogical(::dbOptions[x,3])
      ELSE
        mOpt1 := ::dbOptions[x,3]
      ENDIF
* set option
      IF mOpt0 != mOpt1
        DbeInfo( ::dbOptions[x,1],  ::dbOptions[x,2], ::dbOptions[x,3] )
      ENDIF
    NEXT
* Get default index names from DBEINFO
    ::defDBext  := DBEINFO( COMPONENT_DATA, DBE_EXTENSION)
    ::defIXext  := DBEINFO( COMPONENT_ORDER, DBE_EXTENSION)
*
  ENDIF
RETURN self

****************************************************************************
* Returns full file name with directory and extension.
****************************************************************************
METHOD drgFile:getName(cIxName, lIsWork, cDirName)
LOCAL cExt, cDir, cFile
  cExt  := IIF(EMPTY(cIxName), ::defDBext, ::defIXext)
  cFile := IIF(EMPTY(cIxName), ::fileName, cIxName)

  cDir  := IIF(EMPTY(cDirName), IIF(lIsWork, drgINI:dir_WORK, drgINI:dir_DATA) , cDirName)
* Add ending backslash if not there
  IF !EMPTY(cDir)
    cDir  := IIF(RIGHT(cDir,1) $ '/\', cDir, cDir + '\')
  ENDIF

 * work file in path dir_ +AllTrim(Str(ThreadID())
  if lIsWork
    cdir += userWorkDir() +'\'

*--->    cdir += 'dir_' +allTrim(str(ThreadID())) +'\'
    CreateDir(cdir)
  endif
RETURN cDir + cFile + '.' + cExt

****************************************************************************
* Opens a file in a new databesa area
****************************************************************************
METHOD drgFile:open(lExc, lIsWork, cDirName, lReadOnly, cAlias, lNoCheck)
  LOCAL  cDir, nArea, cFile, cconnect, osession
  *
  DEFAULT lIsWork  TO .F.
  DEFAULT lExc     TO Set(_SET_EXCLUSIVE) .OR. lIsWork
  DEFAULT cAlias   TO ::fileName
  DEFAULT lNoCheck TO .F.

* Set default database options on first open
  ::setOptions()

* File is not opened yet
  IF (nArea := SELECT(cAlias)) = 0

    cFile := ::getName(,lIsWork, cDirName)

    IF lIsWork .OR. !FILE(cFile)
      if File(cFile) .and. lNoCheck
        *
        * pracovní soubor, existuje a byl vytvoøen korektnì v nìjaké èinnosti
        * nesmí se znovu zakládat
        *
      else
        ::dbdCheck(lIsWork, cDirName)
      endif
    ENDIF

    if lIsWork
      DBUseArea(.T., oSession_free, cFile, cAlias ,!lExc, lReadOnly)
      if( ::isCrypt, AX_SetPass(syApa), NIL)

      cDirName := IIF(EMPTY(cDirName), IIF(lIsWork, drgINI:dir_WORK, drgINI:dir_DATA) , cDirName)

    * work file in path dir_ +AllTrim(Str(ThreadID())
      cdirName += if(lIsWork, userWorkDir() +'\', '')

      ::openIndex(.F.,cDirName, cFile, cAlias, lExc)

    else
      cFile    := ::fileName
      DBUseArea(.T., oSession_data, cFile, cAlias ,!lExc, lReadOnly)
      dbSetOrder(1)
    endif


  * File already open. Set control index to 1
  ELSE

    DBSELECTAREA(nArea)
  ENDIF
RETURN SELECT()

***********************************************************************
* Destroys all objects assiciated with drgFile
***********************************************************************
METHOD drgFile:destroy()

  AEVAL(::desc, { |a| a:destroy() } )
  ::dbdName     := ;
  ::fileName    := ;
  ::aliasName   := ;
  ::description := ;
  ::desc        := ;
  ::indexDef    := ;
  ::srchFields  := ;
  ::srchReturn  := ;
  ::srchOrder   := ;
  ::defaultDir  := ;
  ::status      := ;
  ::task        := ;
                NIL
RETURN self


***********************************************************************
* Checks description and or creates file if it doesn't exist
***********************************************************************
FUNCTION dbdCheckFile(cFileName,oFile,lIsWork)
  LOCAL l4UpDate := .F.
  *
  LOCAL engine  := oFile:dbEngine, tblMode

  DO CASE
  CASE engine = 'FOXCDX'                                         // DBF-FPT-CDX
    l4UpDate := dbdCheckFile_DBF(cFileName,oFile,lIsWork)
  CASE engine = 'ADSDBE'
    IF DbeInfo(COMPONENT_DATA, ADSDBE_TBL_MODE) = ADSDBE_CDX
      l4UpDate := dbdCheckFile_DBF(cFileName,oFile,lIsWork)      // DBF-FPT-CDX
    ELSE
      l4UpDate := dbdCheckFile_ADT(cFileName,oFile,lIsWork)      // ADT-ADM-ADI
    ENDIF
  ENDCASE

RETURN l4UpDate


STATIC FUNCTION dbdCheckFile_ADT(cFileName, oFile, lIsWork)
  LOCAL  l4UpDate := .F.
  *
  LOCAL  x, y, sfile_dir, sfile_name, val, pos
  LOCAL  adesc    := oFile:desc, pao, adesc_dbd := {}, adesc_dat
  *
  local  cold_ext

  IF Empty(adesc)
      drgLog:write('New description for file ' + cFileName + ' was EMPTY!')
    RETURN .F.
  ENDIF

  * New description is supplied as array of reference objects
  IF ValType(aDesc[1]) = 'O'
    FOR x :=  1 TO Len(adesc) STEP 1
      pao := adesc[x]

      DO CASE
      CASE pao:type = 'N'
        DO CASE
        CASE pao:dec <> 0
**          AAdd( adesc_dbd, {pao:name, pao:type, pao:len, pao:dec})
          AAdd( adesc_dbd, {pao:name,      'F',       8, pao:dec})

        CASE pao:len >= 1 .and. pao:len <= 4
          AAdd( adesc_dbd, {pao:name, 'I', 2, 0})
        CASE pao:len >  4 .and. pao:len <= 9
          AAdd( adesc_dbd, {pao:name, 'I', 4, 0})
        OTHERWISE
          AAdd( adesc_dbd, {pao:name, 'F', 8, 0})
        ENDCASE
      CASE pao:type = 'M'
        AAdd( adesc_dbd, {pao:name, 'M', 9, 0})
      CASE pao:type = 'D'
        AAdd( adesc_dbd, {pao:name, 'D', 4, 0})
      OTHERWISE
        AAdd( adesc_dbd, {pao:name, pao:type, pao:len, pao:dec})
      ENDCASE
    NEXT
  ELSE
    * New description is supplied as array[name,type,len,dec]
    FOR x :=  1 TO Len(adesc) STEP 1
      pao := adesc[x]

      DO CASE
      CASE pao[DBS_TYPE] = 'N'
        DO CASE
        CASE pao[DBS_DEC] <> 0
**          AAdd( adesc_dbd, {pao[DBS_NAME], 'N', pao[DBS_LEN], pao[DBS_DEC]})
          AAdd( adesc_dbd, {pao[DBS_NAME], 'F', 8, pao[DBS_DEC]})

        CASE pao[DBS_LEN] >= 1 .and. pao[DBS_LEN] <= 4
          AAdd( adesc_dbd, {pao[DBS_NAME], 'I', 2, 0})
        CASE pao[DBS_LEN] >  4 .and. pao[DBS_LEN] <= 9
          AAdd( adesc_dbd, {pao[DBS_NAME], 'I', 4, 0})
        OTHERWISE
          AAdd( adesc_dbd, {pao[DBS_NAME], 'F', 8, 0})
        ENDCASE
      CASE pao[DBS_TYPE] = 'M'
        AAdd( adesc_dbd, {pao[DBS_NAME], 'M', 9, 0})
      CASE pap[DBS_TYPE] = 'D'
        AAdd( adesc_dbd, {pap[DBS_NAME], 'D', 4, 0})
      OTHERWISE
        AAdd( adesc_dbd, {pao[DBS_NAME], pao[DBS_TYPE], pao[DBS_LEN], pao[DBS_DEC]})
      ENDCASE

    NEXT
  ENDIF

  * check if file exist
  If lIsWork
    DBCREATE(Lower(cFileName),adesc_dbd, oSession_free)
    return .t.
  ENDIF

  if File(cFileName) .and. Upper(oFile:fileName) <> "LICASYS"
    USE (cFileName) NEW SHARED // *- VIA (oSession)
    adesc_dat  := DBstruct()
    DBCLOSEAREA()

    * Check if Update is necessary
    IF Len(adesc_dbd) <> Len(adesc_dat)
      l4Update := .T.
    ELSE
      BEGIN SEQUENCE
      FOR x := 1 to Len(adesc_dbd) STEP 1
        FOR y := 1 TO DBS_LEN STEP 1
          IF adesc_dbd[x,y] <> adesc_dat[x,y]
            l4Update := .T.
      BREAK
          ENDIF
        NEXT
      NEXT
      END SEQUENCE
    ENDIF


    if l4UpDate
      sfile_dir  := parseFileName(cFileName,3)  // adresáø souboru bez \
      sfile_name := parseFileName(cFileName,5)  // název   souboru s cestou bez extenze

      FRename(cFileName,sfile_dir +'\ORIG__.ADT')
      IF( File(sfile_name +'.ADM'), FRename(sfile_name +'.ADM',sfile_dir +'\ORIG__.ADM'), NIL )
      IF( File(sfile_name +'.ADI'), FErase (sfile_name +'.ADI'), NIL )

      DbCreate(lower(cFileName), adesc_dbd)  // *- , oSession)
      USE (cFileName)                 NEW EXCLUSIVE ALIAS NEWs // *- VIA (oSession)
      if oFile:isCrypt
        AX_SetPass(syApa)
        if( AX_TableType() <> ADS_ENCRYPTED_TABLE, AX_DBFEncrypt(), NIL)
      endif

      USE (sfile_dir +'\ORIG__.ADT')  NEW EXCLUSIVE ALIAS OLDs // * - VIA (oSession)
      if( oFile:isCrypt, AX_SetPass(syApa), NIL)

      drgServiceThread:progressStart(drgNLS:msg('Conversion of table & in progress.', oFile:fileName), OLDs ->(LastRec()) )

      DO WHILE .not. OLDs ->(Eof())
        NEWs ->(DbAppend())

        AEval( adesc_dat, {|x,m|                                 ;
               val := OLDs ->(FieldGet(m))                     , ;
               pos := NEWs ->(FieldPos(x[DBS_NAME]))           , ;
               IF( pos <> 0, NEWs ->(FieldPut(pos,val)), NIL ) } )

        OLDs ->(DbSkip())
        drgServiceThread:progressInc()
      ENDDO

      NEWs->( DbCloseArea())
      OLDs->( DbCloseArea() )
      FErase(sfile_dir +'\ORIG__.ADT')
      Ferase(sfile_dir +'\ORIG__.ADM')
      drgServiceThread:progressEnd()
    endif
    l4Update := .T.
  ELSE
    If lIsWork
//    If (!lIsWork .and. oFile:lIsCheck ) .or. lIsWork
      DBCREATE(Lower(cFileName),adesc_dbd)  // *- ,oSession)
      l4Update := .T.
    ENDIF
  ENDIF
RETURN l4UpDate


STATIC FUNCTION dbdCheckFile_DBF(cFileName, oFile, lIsWork)
  LOCAL  l4UpDate := .F.
  *
  LOCAL  x, y, sfile_dir, sfile_name, val, pos
  LOCAL  adesc    := oFile:desc, pao, adesc_dbd := {}, adesc_dat
  LOCAL  cFile

  if Empty(adesc)
      drgLog:write('New description for file ' + cFileName + ' was EMPTY!')
    RETURN .F.
  endif

  * New description is supplied as array of reference objects
  if ValType(aDesc[1]) = 'O'
    AEval(aDesc, { |o| AAdd(adesc_dbd, {o:name,o:type,o:len,o:dec}) })
  else
    adesc_dbd := AClone(aDesc)
  endif

  * check if file exist
  if File(cFileName) .and. Upper(oFile:fileName) <> "LICASYS"
    USE (cFileName) NEW SHARED    // - VIA (oSession)
    adesc_dat  := DBstruct()
    DBCLOSEAREA()

    * Check if Update is necessary
    if Len(adesc_dbd) <> Len(adesc_dat)
      l4Update := .T.
    else
      BEGIN SEQUENCE
        FOR x := 1 to Len(adesc_dbd) STEP 1
          FOR y := 1 TO DBS_LEN STEP 1
            IF adesc_dbd[x,y] <> adesc_dat[x,y]
              l4Update := .T.
      BREAK
            ENDIF
          NEXT
        NEXT
      END SEQUENCE
    endif

    if l4UpDate
      sfile_dir  := parseFileName(cFileName,3)  // adresáø souboru bez \
      sfile_name := parseFileName(cFileName,5)  // název   souboru s cestou bez extenze

      FRename(cFileName,sfile_dir +'\ORIG__.DBF')
      IF( File(sfile_name +'.FPT'), FRename(sfile_name +'.FPT',sfile_dir +'\ORIG__.FPT'), NIL )
      IF( File(sfile_name +'.CDX'), FErase (sfile_name +'.CDX'), NIL )

      DbCreate(Lower(cFileName), adesc_dbd)  // *- , oSession)
      USE (cFileName)                 NEW EXCLUSIVE ALIAS NEWs // *- VIA (oSession)
      if oFile:isCrypt
        AX_SetPass(syApa)
        if( AX_TableType() <> ADS_ENCRYPTED_TABLE, AX_DBFEncrypt(), NIL)
      endif

      USE (sfile_dir +'\ORIG__.DBF')  NEW EXCLUSIVE ALIAS OLDs // - VIA (oSession)
      if( oFile:isCrypt, AX_SetPass(syApa), NIL)

      drgServiceThread:progressStart(drgNLS:msg('Conversion of table & in progress.', oFile:fileName), OLDs ->(LastRec()) )

      do while .not. OLDs ->(Eof())
        NEWs ->(DbAppend())

        AEval( adesc_dat, {|x,m|                                 ;
               val := OLDs ->(FieldGet(m))                     , ;
               pos := NEWs ->(FieldPos(x[DBS_NAME]))           , ;
               IF( pos <> 0, NEWs ->(FieldPut(pos,val)), NIL ) } )

        OLDs ->(DbSkip())
        drgServiceThread:progressInc()
      enddo

      NEWs->( DbCloseArea())
      OLDs->( DbCloseArea() )
      FErase(sfile_dir +'\ORIG__.DBF')
      Ferase(sfile_dir +'\ORIG__.FPT')
      drgServiceThread:progressEnd()
    endif
    l4Update := .T.
  else
    if (!lIsWork .and. oFile:lIsCheck .and. Upper(oFile:fileName) <> "LICASYS") .or. lIsWork
      DBCREATE(Lower(cFileName),adesc_dbd)  // -,oSession)
      l4Update := .T.
    endif
  endif

RETURN l4UpDate

*
** BACK **
STATIC FUNCTION dbdCheckFile_DBB(cFileName, oFile, lIsWork)
LOCAL x, y, l4Update := .F., cFBak
LOCAL aDesc := oFile:desc, aNewDesc, aOldDesc, aOut

  IF EMPTY(aDesc)
    drgLog:write('New description for file ' + cFileName + ' was EMPTY!')
    RETURN .F.
  ENDIF
* New description is supplied as array of reference objects
  IF VALTYPE(aDesc[1]) = 'O'
    aNewDesc := {}
    AEVAL(aDesc, {|o| AADD(aNewDesc, { o:name, o:type, o:len, o:dec} ) } )
  ELSE
* New description is supplied as array[name, type, len, dec]
    aNewDesc := ACLONE(aDesc)
  ENDIF

*  ixName:=LEFT(name,LEN(name)-1)+'*.NTX'   && Sestavim ime za brisanje indexov
  IF FILE(cFileName)
    USE (cFileName) NEW SHARED // *- VIA (oSession)
    aOldDesc := DBSTRUCT()
    DBCLOSEAREA()
* Check if Update is necessary
    IF LEN(aOldDesc) != LEN(aNewDesc)
      l4Update := .T.
    ELSE
      FOR x := 1 to LEN(aNewDesc)
        FOR y := 1 TO 4
          IF aOldDesc[x, y] != aNewDesc[x, y]
            l4Update := .T.
            EXIT
          ENDIF
        NEXT y
        IF l4Update; EXIT; ENDIF            //**
      NEXT x
    ENDIF

    IF l4Update                       // Ce je kaksna sprememba
//      cFBak:= parseFileName(cFileName,5) + '.BKK'
//      FERASE(cFBak)                             // za vsak slucaj
//      FRENAME(cFileName,cFBak)                  // preimenuj

      cFBak := parseFileName(cFileName,5)
      Frename(cFILEname,parseFileName(cFileName,3) +'\ORIG__.DBF')
      If( FILE(cFBak +'.FPT'), Frename(cFBak +'.FPT',parseFileName(cFileName,3) +'\ORIG__.FPT'), NIL )
      cFBak := parseFileName(cFileName,3) +'\ORIG__.DBF'

      DBCREATE(Lower(cFileName), aNewDesc) // *-, oSession)             // kreiraj novo datoteko
      USE (cFileName) NEW EXCLUSIVE ALIAS BB // * - VIA (oSession)  // odpri novo
      USE (cFBak)  NEW EXCLUSIVE ALIAS AA // * - VIA (oSession)       // odpri staro

      drgServiceThread:progressStart(drgNLS:msg('Conversion of table & in progress.', oFile:fileName), LASTREC() )
      aOut := {}
* Create array holding indexes to fields in old file
      FOR x := 1 TO LEN(aNewDesc)
        AADD(aOut, FIELDPOS(aNewDesc[x, 1]) )
      NEXT

      y := LEN(aNewDesc)                  // še malo hitrejša zanka
      WHILE !EOF()
        SELECT BB
        DBAPPEND()
        FOR x := 1 TO y
          IF aOut[x] != 0
            FIELDPUT( x, AA->( FIELDGET(aOut[x]) ) )
          ENDIF
        NEXT
        SELECT AA
        DBSKIP()
        drgServiceThread:progressInc()
      ENDDO

      DBCOMMITALL()
      AA->( DBCLOSEAREA() )
      BB->( DBCLOSEAREA() )
      Ferase(parseFileName(cFileName,3) +'\ORIG__.DBF')
      Ferase(parseFileName(cFileName,3) +'\ORIG__.FPT')
      drgServiceThread:progressEnd()
    ENDIF
* Datoteka ne obstaja. Kreiraj jo.
  ELSE
    If (!lIsWork .and. oFile:lIsCheck) .or. lIsWork
      DBCREATE(Lower(cFileName), aNewDesc)  // * - , oSession)
      l4Update := .T.
    EndIf
  ENDIF
RETURN l4Update