//////////////////////////////////////////////////////////////////////
//
//  drgRef.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      drgRef object holds descriptions of reference fields.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Directry.ch"

CLASS drgRef

EXPORTED:

  VAR     ref

  METHOD  init
  METHOD  getRef

  METHOD  addFile
  METHOD  destroy

ENDCLASS

********************************************************************
* Initialization part. Just create empty drgArray.
********************************************************************
METHOD drgRef:init(numElements, aFileList)
LOCAL c
  DEFAULT numElements TO 200
  ::ref := drgArray():new(numElements)
*
  IF EMPTY(aFileList)
    aFileList := Directory(drgINI:dir_RSRC + 'REF*.DBD')
    AEVAL(aFileList, { |a| ::addFile( drgINI:dir_RSRC + a[F_NAME] ) } )
  ELSEIF VALTYPE(aFileList) = 'C'
    WHILE !EMPTY(c := drgParse(@aFileList) )
      ::addFile( ALLTRIM(c) + '.DBD' )
    ENDDO
  ELSE
    AEVAL(aFileList, { |a| ::addFile( a + '.DBD' ) } )
  ENDIF

RETURN self

********************************************************************
* Add new references from description file.
********************************************************************
METHOD drgRef:addFile(cRsrcName)
LOCAL aRF, keyWord, line, value, F, nRsrc

  WHILE (line := _drgGetSection(@F, @cRsrcName, @nRsrc)) != NIL
    keyWord := _parse(@line, @value)
    IF UPPER(value) = 'FIELD'
      aRF := _drgRF():new()
      WHILE ( keyWord := _parse(@line, @value) ) != NIL
* Only TYPE=FIELD keywords are processed
        DO CASE
        CASE keyWord = 'NAME'
          aRF:name    := UPPER(_getStr(value))
        CASE keyWord = 'DESC'
          aRF:desc    := _getStr(value)
        CASE keyWord = 'FTYPE'
          aRF:type    := UPPER( _getStr(value) )
        CASE keyWord = 'FLEN'
          aRF:len     := _getNum(value)
        CASE keyWord = 'DEC'
          aRF:dec     := _getNum(value)
        CASE keyWord = 'CAPTION'
          aRF:caption := _getStr(value)
        CASE keyWord = 'RELATETO'
          aRF:relTO   := UPPER( _getStr(value) )
        CASE keyWord = 'RELATETYPE'
          aRF:relType := _getStr(value)
        CASE keyWord = 'VALUES'
          aRF:values  := _getStr(value)
        CASE keyWord = 'DEFVALUE'
          aRF:defValue:= _getStr(value)
        CASE keyWord = 'PICTURE'
          aRF:picture := ALLTRIM(_getStr(value))
        CASE keyWord = 'REF'
          aRF:picture := UPPER(_getStr(value))

        ENDCASE
      ENDDO
      ::ref:add(aRF, aRF:name)
    ENDIF
  ENDDO
  ::ref:reSort()
RETURN self

*********************************************************************
* Search for reference definition.
* \bParameters:b\
* < cName >      : string  : Reference name.
*
* \bReturns:b\  : object of _drgRF : Reference object description. NIL if not found.
*********************************************************************
METHOD drgRef:getRef(cName)
RETURN ::ref:getByKey(cName)

*********************************************************************
* CleanUP
*********************************************************************
METHOD drgRef:destroy()
  ::ref:destroy()
  ::ref := NIL
RETURN NIL

*********************************************************************
* Reference field definition CLASS
*********************************************************************
CLASS _drgRF
EXPORTED:
  VAR name
  VAR desc
  VAR type
  VAR len
  VAR dec
  VAR caption
  VAR relTO
  VAR relType
  VAR relORD
  VAR values
  VAR defValue
  VAR picture
  VAR ref
  *
  VAR org_name   // original názvu položky v DBD v promìnné name je upper !
  VAR adt_type
  VAR adt_len
  VAR adt_dec

  METHOD init
  METHOD destroy

ENDCLASS

*********************************************************************
* Initialization
*********************************************************************
METHOD _drgRF:init()
  ::type    := 'C'
  ::len     := 1
  ::dec     := 0
  ::caption := ''
  ::relType := 0
  ::relORD  := 1
RETURN self

*********************************************************************
* CleanUp
*********************************************************************
METHOD _drgRF:destroy()
  ::ref     := ;
  ::picture := ;
  ::defValue:= ;
  ::values  := ;
  ::relType := ;
  ::relTO   := ;
  ::relORD  := ;
  ::caption := ;
  ::dec     := ;
  ::len     := ;
  ::type    := ;
  ::desc    := ;
  ::name    := ;
               NIL
RETURN

*********************************************************************
* Index definition CLASS
*********************************************************************
CLASS _drgIndex
EXPORTED:
  VAR cName
  VAR cFileName
  VAR cCaption
  VAR cIndexKey
  VAR cFor
  VAR cWhile
  VAR nRecord
  VAR lDescend
  VAR lUnique
  VAR lDupKeys
  VAR lDirty
  VAR lInSort

*  METHOD init
  METHOD destroy

ENDCLASS

*********************************************************************
* Initialization
*********************************************************************
*METHOD _drgIndex:init()
*  ::lDirty := .F.
*RETURN self

*********************************************************************
* CleanUp
*********************************************************************
METHOD _drgIndex:destroy()
  ::cName     := ;
  ::cFileName := ;
  ::cCaption  := ;
  ::cIndexKey := ;
  ::cFor      := ;
  ::cWhile    := ;
  ::nRecord   := ;
  ::lDescend  := ;
  ::lUnique   := ;
  ::lDupKeys  := ;
  ::lDirty    := ;
  ::lInSort   := ;
               NIL
RETURN


*********************************************************************
* Search definition CLASS
*********************************************************************
CLASS _drgSEA
EXPORTED:
  VAR srchFields
  VAR srchOrder
  VAR srchReturn

  METHOD destroy
ENDCLASS


*********************************************************************
* CleanUp
*********************************************************************
METHOD _drgSEA:destroy()
  ::srchFields   := ;
  ::srchOrder    := ;
  ::srchReturn   := ;
               NIL
RETURN


*********************************************************************
* Relation definition CLASS
*********************************************************************
CLASS _drgREL
EXPORTED:
  VAR relFile
  VAR relKey
  VAR relOrder
  VAR mainFile
  *
  VAR relSubs


  METHOD destroy
ENDCLASS


*********************************************************************
* CleanUp
*********************************************************************
METHOD _drgREL:destroy()
  ::relFile    := ;
  ::relKey     := ;
  ::relOrder   := ;
  ::relSubs    := NIL
RETURN