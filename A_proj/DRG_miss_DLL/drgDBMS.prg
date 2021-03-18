//////////////////////////////////////////////////////////////////////
//
//  drgDBMS.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgDBMS class manages all files belonging to a project.
//       It holds data description and index descriptions for files,
//       menages upgrading of database files, holds information about
//       database location,
//
//  Remarks:
//       The :init() method scans for files descriptions in the dbms
//       directory and loads all descriptions into the memory.
//       File descriptions not found in the dbms directory cannot be
//       used by the project.
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Directry.ch"

CLASS drgDBMS
  EXPORTED:
    METHOD  init
    METHOD  loadDBD
    METHOD  addDBD
    METHOD  open                  // opens a file and returns workarea number
    METHOD  getDBD                // returns file description for specifiled file
    METHOD  getFieldDesc          // returns field description for specifield file and field

    METHOD  getFieldDec           // returns field dec - poèet desetinných míst pro field
    METHOD  getTagByOrder         // returns cTagName for nTagNo

    METHOD  getNthDBD
    METHOD  checkDB               // checks all file descriptions and refreshes desig
    METHOD  checkIndexes
    METHOD  destroy

**  HIDDEN:
    VAR     dbd READONLY
ENDCLASS

***************************************************************************
* Initialize drgDBMS. Loads into memory all file descriptions from disk
***************************************************************************
METHOD drgDBMS:init(nInitialCapacity)
  DEFAULT nInitialCapacity TO 10
  ::dbd := drgArray():new(nInitialCapacity)         // Create array for descriptions
RETURN self

***************************************************************************
* Load DBD definitions
***************************************************************************
METHOD drgDBMS:loadDBD(aFileList)
LOCAL c
  IF EMPTY(aFileList)
    aFileList := Directory(drgINI:dir_RSRC + '*.DBD')
    AEVAL(aFileList, { |a| ::addDBD( drgINI:dir_RSRC + a[F_NAME] ) } )
  ELSEIF VALTYPE(aFileList) = 'C'
    WHILE !EMPTY(c := drgParse(@aFileList) )
      ::addDBD( ALLTRIM(c) + '.DBD' )
    ENDDO
  ELSE
    AEVAL(aFileList, { |a| ::addDBD( a + '.DBD' ) } )
  ENDIF
RETURN self

***************************************************************************
* Loads DB dictionary file and adds to description files array.
***************************************************************************
METHOD drgDBMS:addDBD(cDBDName)
LOCAL oDBD, bDBD, F, st, nRsrc
LOCAL cType, cDBEngine := '', cOptions, aOptions := {}
LOCAL x := 0, cOpt, n1,n2,m3
* Skip reference files
  IF VALTYPE(cDBDName) = 'C' .AND. UPPER( LEFT(parseFileName(cDBDName), 3 ) ) = 'REF'
    RETURN self
  ENDIF
*
*
  cDBEngine := DbeSetDefault()
  WHILE ( st := _drgGetSection(@F, @cDBDName, @nRsrc) ) != NIL

//    drgDump(st)

*     drgLog:cargo := 'DBD ' + cDBDName + ' line ' + STR(++x)
    cType  := drgGetParm("TYPE",st)
* DBD
    IF LOWER(cType) = 'dbd'
      IF EMPTY(cDBEngine := drgGetParm("DBENGINE", st) )
        cDBEngine := 'DEFAULT'
      ENDIF
      cDBEngine := UPPER(ALLTRIM(cDBEngine))
* Default engine
      IF cDBEngine = 'DEFAULT'
        cDBEngine := DbeSetDefault()
      ENDIF
* Parse options
      IF !EMPTY(cOptions  := drgGetParm("OPTIONS", st))
        cOptions := ALLTRIM(cOptions)
        WHILE !EMPTY(cOpt := drgParse(@cOptions) )
          n1 := VAL(drgParse(@cOpt,':'))
          n2 := VAL(drgParse(@cOpt,':'))
          m3 := _getStr(drgParse(@cOpt,':'))
* Add to options array
          AADD(aOptions,{n1,n2,m3} )
        ENDDO
      ENDIF
      LOOP                                    // get next line
    ENDIF
* FILE
    IF LOWER(cType) = 'file'
      IF oDBD != NIL                           // .NOT. 1st file
        ::dbd:add(oDBD, oDBD:fileName)         // add to DBD array
      ENDIF
*
      bDBD := '{ |a,b| ' + '_drgFile' + cDBEngine + '():new(a,b) }'
      oDBD := EVAL(&bDBD, cDBDName, aOptions)
    ENDIF
*
    IF oDBD != NIL
      oDBD:parse(st)
    ENDIF
  ENDDO
* Add oDBD to array
  IF oDBD != NIL
    ::dbd:add(oDBD, oDBD:fileName)
  ENDIF
  ::dbd:reSort()
RETURN self

***************************************************************************
* checks all file descriptions
***************************************************************************
METHOD drgDBMS:checkDB(aFileList)
LOCAL oDBD, n

  if isArray(aFileList)
    for n := 1 to len(aFileList) step 1
      ::dbd:getByKey(aFileList[n]):dbdCheck()
    next
  else
    FOR n := 1 TO ::dbd:size()
      ::dbd:getNth(n):dbdCheck()
    NEXT
  endif
RETURN self

***************************************************************************
* checks all file descriptions
***************************************************************************
METHOD drgDBMS:checkIndexes()
LOCAL n
  FOR n := 1 TO ::dbd:size()
    ::dbd:getNth(n):open(.T.)
    DBCOMMIT()
    DBCLOSEAREA()
  NEXT
RETURN self

***************************************************************************
* opens a file and returns work area number
***************************************************************************
METHOD drgDBMS:open(cFileName, lExclusive, lIsWork, cDirName, lReadOnly, cAlias, lNoCheck)
LOCAL oDBD
  cFileName := UPPER(cFileName)
  IF (oDBD := ::dbd:getByKey(cFileName) ) = NIL
    RETURN NIL
  ENDIF
RETURN oDBD:open(lExclusive, lIsWork, cDirName, lReadOnly, cAlias, lNoCheck)

***************************************************************************
* Returns drgFile object for specifield file name
***************************************************************************
METHOD drgDBMS:getDBD(cFileName)
RETURN ::dbd:getByKey(cFileName)

***************************************************************************
* Returns field description for specified file.
*
* \b< Parameters: b\
* \b< dbName >b\      : String  : Database file name
* \b< fldName >b\     : String  : Field name
*
* \b< Returns: >b\    : object : of type drgRef = field description
***************************************************************************
METHOD drgDBMS:getFieldDesc(cDBDName, cFieldName)
LOCAL oDBD
*  drgDump(fldName, dbName)
  IF EMPTY(cFieldName)
    cFieldName := drgParseSecond(cDBDName,'>')
    cDBDName   := drgParse(cDBDName,'-')
  ENDIF
*
  IF (oDBD := ::getDBD(cDBDName) ) != NIL
    RETURN oDBD:getFieldDesc(cFieldName)
  ENDIF
RETURN NIL

*
** return field_dec poèet desetinných míst
method drgDBMS:getFieldDec( cDBDName, cFieldName )
  local oDBD

  if empty( cFieldName )
    cFieldName := drgParseSecond( cDBDName, '>' )
    cDBDName   := drgParse      ( cDBDName, '-' )
  endif

  if ( oDBD := ::getDBD( cDBDName )) != NIL
    return oDBD:getFieldDec( cFieldName )
  endif
return 0

*
** return cTagName for nTagNo
method drgDBMS:getTagByOrder( cDBDName, nTagNo )
  local oDBD

  if ( oDBD := ::getDBD( cDBDName )) != NIL
    return oDBD:getTagByOrder( nTagNo )
  endif
return 0


***************************************************************************
* Returns DBD description searched by absolute position
***************************************************************************
METHOD drgDBMS:getNthDBD(n)
RETURN ::dbd:getNth(n)

***************************************************************************
* destroys all objects assosiated with drgDBMS
***************************************************************************
METHOD drgDBMS:destroy()
  ::dbd:destroy()
  ::dbd := NIL
RETURN self