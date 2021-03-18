//////////////////////////////////////////////////////////////////////
//
//  drgFileObj.PRG
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgFile holds class definitions for different database engines.
//      Most class definitions inherit code from drgFile object.
//
//   Remarks:
//      Classes are defined with _drgFileXXXXX names. Where X-ese define
//      different database engine eg. _drgFileDBFNTX, drgFIleDBFCDX, etc..
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Set.ch"
#include "dbfdbe.ch"

#include "ads.ch"
#include "adsdbe.ch"

CLASS _drgFileDBFNTX from drgFile
EXPORTED:
  METHOD  init
  METHOD  openIndex       // opens single index file
  METHOD  createIndex     // creates indexes if necessary
ENDCLASS

***************************************************************************
* Initialize drgFile object. Reads description file
***************************************************************************
METHOD _drgFileDBFNTX:init(cDBDName, aOptions)
  ::dbEngine := 'DBFNTX'
  ::drgFile:init(cDBDName, aOptions)
RETURN self

****************************************************************************
* Creates index file if it doesn't exist. Parameters are passed as array
* containing name and index description.
****************************************************************************
METHOD _drgFileDBFNTX:openIndex(lReCreate, cDirName)
LOCAL cIxFileName, cDefExt, cName
LOCAL bKey, bFor, bWhile
LOCAL x
* Show progress on recreation
  IF lReCreate
    drgServiceThread:progressStart(drgNLS:msg('Creating index files for table &.', ::fileName), LEN(::indexDef) )
  ENDIF
* Check for every index file to be present
  FOR x := 1 TO LEN(::indexDef)
    cName := ::getName(::indexDef[x]:cName, .F., cDirName)
    IF !FILE(cName) .OR. lReCreate
      ::createIndex(cName, ::indexDef[x])
      IF lReCreate
        drgServiceThread:progressInc()
      ENDIF
    ENDIF
  NEXT x
* End progress window
  IF lReCreate
    drgServiceThread:progressEnd()
  ENDIF
*
  ordListClear()
  AEVAL(::indexDef,{ | aIndex | ordListAdd(::getName(aIndex:cName, .F., cDirName) ) } )
RETURN

****************************************************************************
* Creates index
****************************************************************************
METHOD _drgFileDBFNTX:createIndex(cIxFileName, oIndex)
LOCAL bKey, bFor, bWhile
  bKey   := IIF(oIndex:cIndexKey = NIL, NIL, &('{ || ' + oIndex:cIndexKey + '}') )
  bFor   := IIF(oIndex:cFor   = NIL, NIL,&('{ || ' + oIndex:cFor + '}') )
  bWhile := IIF(oIndex:cWhile = NIL, NIL,&('{ || ' + oIndex:cWhile + '}') )

  OrdCondSet(oIndex:cFor, , , bWhile, , , , , oIndex:nRecord, , oIndex:lDescend)
  OrdCreate(Lower(cIxFileName), oIndex:cName, oIndex:cIndexKey, bKey, oIndex:lUnique)
  // {|| bBlock, drgServiceThread:progressInc() } )
  DBCOMMIT()
RETURN self


***************************************************************************
*
* DBFCDX drgFile object.
*
*
***************************************************************************
CLASS _drgFileDBFCDX from drgFile
EXPORTED:
  METHOD  init
  METHOD  openIndex       // opens single index file
  METHOD  createIndex     // creates indexes if necessary
ENDCLASS

***************************************************************************
* Initialize drgFile object. Reads description file
***************************************************************************
METHOD _drgFileDBFCDX:init(cDBDName, aOptions)
  ::dbEngine := 'DBFCDX'
  ::drgFile:init(cDBDName, aOptions)
RETURN self

****************************************************************************
* Creates index file if it doesn't exist. Parameters are passed as array
* containing name and index description.
****************************************************************************
METHOD _drgFileDBFCDX:openIndex(lReCreate, cDirName, cDBFname, cAlias, lExc)
  LOCAL x, cName, lReindex := lReCreate
  LOCAL nArea, cOldName
  *
  local ordList := ordList(), ctagName


* Show progress on recreation
  IF lReCreate
    drgServiceThread:progressStart(drgNLS:msg('Creating index files for table &.', ::fileName), LEN(::indexDef) )
  ENDIF
* Check for every index file to be present
  ordListClear()
  cOldName := 'xx'
  FOR x := 1 TO LEN(::indexDef)
    ::indexDef[x]:lDirty := .F.
    cName := ::getName(::indexDef[x]:cFileName, .F., cDirName)
    IF lReCreate
      ::indexDef[x]:lDirty := .T.
    ELSEIF !FILE(cName)
      ::indexDef[x]:lDirty := .T.
      lReIndex := .T.
    ELSE
      IF cOldName != cName
        ORDLISTADD(cName)
        cOldName := cName
      ENDIF
*
      ctagName := ::indexDef[x]:cName

      if( ascan( ordList, { |x| upper(x) = upper(ctagName) }) ) = 0
*        IF xRDNUMBER(::indexDef[x]:cName) = 0
        ::indexDef[x]:lDirty := .T.
        lReIndex := .T.
      ENDIF
    ENDIF
  NEXT
* Indexing is required.
* File must be opened exclusively to be indexed
  IF lReIndex
    DBCLOSEAREA()
    DBUseArea(.T., oSession, cDBFname, cAlias , .T.)
*
    FOR x := 1 TO LEN(::indexDef)
      IF ::indexDef[x]:lDirty
        cName := ::getName(::indexDef[x]:cFileName, .F., cDirName)
        ::createIndex(cName, ::indexDef[x])
        IF lReCreate
          drgServiceThread:progressInc()
        ENDIF
      ENDIF
    NEXT
* Reopen area
    DBCLOSEAREA()
    DBUseArea(.T., oSession, cDBFname, cAlias ,!lExc)
  ENDIF
* End progress window
  IF lReCreate
    drgServiceThread:progressEnd()
  ENDIF
* And finaly. Open indexes
  ordListClear()
  cOldName := 'xx'
  FOR x := 1 TO LEN(::indexDef)
    cName := ::getName(::indexDef[x]:cFileName, .F., cDirName)
    IF cOldName != cName
      ORDLISTADD(cName)
      cOldName := cName
     ENDIF
     AdsSetOrder(1)
   NEXT
RETURN

****************************************************************************
* Creates index
****************************************************************************
METHOD _drgFileDBFCDX:createIndex(cIxFileName, oIndex)
LOCAL bKey, bFor, bWhile
  bKey   := IIF(oIndex:cIndexKey = NIL, NIL, &('{ || ' + oIndex:cIndexKey + '}') )
  bFor   := IIF(oIndex:cFor   = NIL, NIL,&('{ || ' + oIndex:cFor + '}') )
  bWhile := IIF(oIndex:cWhile = NIL, NIL,&('{ || ' + oIndex:cWhile + '}') )

  OrdCondSet(oIndex:cFor, , , bWhile, , , , , oIndex:nRecord, , oIndex:lDescend)
  OrdCreate(Lower(cIxFileName), oIndex:cName, oIndex:cIndexKey, bKey, oIndex:lUnique)
  DBCOMMIT()
RETURN self

***************************************************************************
*
* FOXCDX drgFile object.
*
*
***************************************************************************
CLASS _drgFileFOXCDX from _drgFileDBFCDX
EXPORTED:
INLINE METHOD init(cDBDName, aOptions)
  ::_drgFileDBFCDX:init(cDBDName, aOptions)
  ::dbEngine := 'FOXCDX'
RETURN self
ENDCLASS

***************************************************************************
*
* ADSDBE drgFile object.
*
*
***************************************************************************
CLASS _drgFileADSDBE from drgFile
EXPORTED:
  METHOD  init
  METHOD  openIndex       // opens single index file
  METHOD  createIndex     // creates indexes if necessary
ENDCLASS

***************************************************************************
* Initialize drgFile object. Reads description file
***************************************************************************
METHOD _drgFileADSDBE:init(cDBDName, aOptions)
  ::dbEngine := 'ADSDBE'
  ::drgFile:init(cDBDName, aOptions)
RETURN self

****************************************************************************
* Creates index file if it doesn't exist. Parameters are passed as array
* containing name and index description.
****************************************************************************
METHOD _drgFileADSDBE:openIndex(lReCreate, cDirName, cDBFname, cAlias, lExc)
  LOCAL x, cName, lReindex := lReCreate
  LOCAL nArea, cOldName
  LOCAL cc, nType
  *
  local  osession, cfile := Alias( Select() )
  *
  local ordList := ordList(), ctagName

  osession := oSession_free  // DacSession():sessionList()[1]

* Show progress on recreation
  IF lReCreate
    drgServiceThread:progressStart(drgNLS:msg('Creating index files for table &.', ::fileName), LEN(::indexDef) )
  ENDIF
* Check for every index file to be present
  ordListClear()
  cOldName := 'xx'
  FOR x := 1 TO LEN(::indexDef)
    ::indexDef[x]:lDirty := .F.
    cName := ::getName(::indexDef[x]:cFileName, .F., cDirName)
    IF lReCreate
      ::indexDef[x]:lDirty := .T.
    ELSEIF !FILE(cName)
      ::indexDef[x]:lDirty := .T.
      lReIndex := .T.
    ELSE
      IF cOldName != cName
        ORDLISTADD(cName)
        cOldName := cName
      ENDIF
*
      ctagName := ::indexDef[x]:cName

      if( ascan( ordList, { |x| upper(x) = upper(ctagName) }) ) = 0

*       IF xRDNUMBER(::indexDef[x]:cName) = 0
        ::indexDef[x]:lDirty := .T.
        lReIndex := .T.
      ENDIF
    ENDIF
  NEXT

* Indexing is required.
* File must be opened exclusively to be indexed

  IF lReIndex
    DBCLOSEAREA()
    DBUseArea(.T., oSession, cDBFname, cAlias , .F.)
**    dbSetNullValue(.F.)

    if( ::isCrypt, AX_SetPass(syApa), NIL)
*
    FOR x := 1 TO LEN(::indexDef)
      IF ::indexDef[x]:lDirty
        cName  := IIF(RIGHT(cDirName,1) $ '/\', cDirName, cDirName + '\') +::indexDef[x]:cFileName
        ::createIndex(cName, ::indexDef[x])
        IF lReCreate
          drgServiceThread:progressInc()
        ENDIF
      ENDIF
    NEXT
* Reopen area

    DBCLOSEAREA()
    DBUseArea(.T., oSession, cDBFname, cAlias ,!lExc)
**    dbSetNullValue(.F.)

    if( ::isCrypt, AX_SetPass(syApa), NIL)
 ENDIF
* End progress window
  IF lReCreate
    drgServiceThread:progressEnd()
  ENDIF
* And finaly. Open indexes

  AdsSetOrder(1)
RETURN

****************************************************************************
* Creates index
****************************************************************************
METHOD _drgFileADSDBE:createIndex(cIxFileName, oIndex)
LOCAL bKey, bFor, bWhile
  bKey   := IIF(oIndex:cIndexKey = NIL, NIL, &('{ || ' + oIndex:cIndexKey + '}') )
  bFor   := IIF(oIndex:cFor   = NIL, NIL,&('{ || ' + oIndex:cFor + '}') )
  bWhile := IIF(oIndex:cWhile = NIL, NIL,&('{ || ' + oIndex:cWhile + '}') )

  OrdCondSet(oIndex:cFor, , , bWhile, , , , , oIndex:nRecord, , oIndex:lDescend)
  OrdCreate(Lower(cIxFileName), oIndex:cName, oIndex:cIndexKey, bKey, oIndex:lUnique)
  DBCOMMIT()
RETURN self