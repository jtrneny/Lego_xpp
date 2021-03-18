//////////////////////////////////////////////////////////////////////
//
//  drgFormManager.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//            \bCLASS drgFormsManagerb\ loads form from disk definition file. It also caches forms \
//      in memory so consequential using of forms is faster.
//      \bCLASS drgFContainerb\ contains single form definition
//      \bCLASS drgFAbstractb\ abstract definition of one drgForm line. Contains methods \
//      common to different line type.
//
//
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"

CLASS drgFormManager
  EXPORTED:

  VAR     members

  METHOD  init
  METHOD  destroy
  METHOD  getForm
ENDCLASS

************************************************************************
************************************************************************
METHOD drgFormManager:init()
  ::members := {}
RETURN self

************************************************************************
************************************************************************
METHOD drgFormManager:getForm(formName)
LOCAL x, f, aVar
  formName := LOWER(formName)
* check if form is already loaded
/*
  IF ( x := ASCAN(::members, { |m| m[1] == formName} )) > 0
    aVar := BIN2VAR(::members[x, 2])
    RETURN aVar
  ELSE
    f := drgFormContainer():new(formName)
    IF f != NIL
      aVAR := VAR2BIN(f)
      AADD(::members, {formName, aVar })
      RETURN BIN2VAR(aVar)
    ENDIF
  ENDIF
*   POST ERROR
*/
  f := drgFormContainer():new(formName)
  IF f != NIL
    RETURN f
  ENDIF

  f := NIL
RETURN NIL

************************************************************************
* Clean UP
************************************************************************
METHOD drgFormManager:destroy()
LOCAL x
  FOR x := 1 TO LEN(::members)
    ::members[x,2]:destroy()
  NEXT
  members := NIL
RETURN

************************************************************************
*
* drgFormContainer class hold definition of drgForm form type.
*
************************************************************************
CLASS drgFormContainer
EXPORTED:
  VAR     formName, members

  METHOD  init
  METHOD  loadForm
  METHOD  addLine
  METHOD  destroy

  METHOD  getLine

HIDDEN:
**  VAR     members                                                    // miss
  VAR     pos
  VAR     len
ENDCLASS

************************************************************************
************************************************************************
METHOD drgFormContainer:init(cFormName)
  ::formName := cFormName
  ::members  := {}
  IF ::formName != NIL
    IF ::loadForm(cFormName) = NIL
      RETURN NIL
    ENDIF
  ENDIF
RETURN self

************************************************************************
* Loads Form from file. If send as array of lines decodes line by line.
************************************************************************
METHOD drgFormContainer:loadForm(cFormName)
LOCAL F, st, fileName, type, name, aDesc, nType
* If formname passed as parameter add default extension
  IF VALTYPE(cFormName) = 'C'

    if file(drgINI:dir_RSRCfi + cFormName + '.FRM')
      fileName := drgINI:dir_RSRCfi + cFormName + '.FRM'
    else
      fileName := drgINI:dir_RSRC + cFormName + '.FRM'
    endif

  ELSE
    fileName := cFormName
  ENDIF
* Read first line of resource. IF not found return.
  IF ( st := _drgGetSection(@F, @fileName, @nType) ) = NIL
    drgLog:cargo := 'Form ' + cFormName + ' not defined!'
    RETURN NIL
  ENDIF
  drgLog:cargo := st
* Check for type parameter
  IF (type := drgGetParm("TYPE",st)) = NIL
    FCLOSE(F)
    RETURN NIL
  ENDIF
* Check if form keyword is OK
  type := LOWER(type)
*  IF !( type = 'drgform' .OR. type = 'drgwizard')
*    FCLOSE(F)
*    RETURN NIL
*  ENDIF
* add definition
  AADD(::members, _drgDrgForm():new(st, type) )
* proceed with other parameters
  WHILE ( st := _drgGetSection(@F, @fileName, @nType) ) != NIL
    drgLog:cargo := st
    type  := drgGetParm("TYPE",st)
    IF LOWER( LEFT(type,3) ) = 'end'; type := 'end'; ENDIF

    name  := '{ |a,b,c,d| ' + '_drg' + type + '():new(a,b,c,d) }'
    aDesc := EVAL(&name, st, F, fileName, nType)
    AADD(::members, aDesc)
  ENDDO

  IF VALTYPE(cFormName) = 'C'
    ::formName := cFormName
  ENDIF
  ::pos := 0
  ::len := LEN(::members)

  drgLog:cargo := NIL
RETURN self

************************************************************************
* Returns next form line
************************************************************************
METHOD drgFormContainer:getLine()
  IF ++::pos > ::len
    ::pos := 0
    RETURN NIL
  ENDIF
RETURN ::members[::pos]

************************************************************************
* Adds _drg* object form container. This method is used when direct programming \
* of form is used.
************************************************************************
METHOD drgFormContainer:addLine(drgLine)
  AADD(::members, drgLine)
  ::pos := 0
  ::len := LEN(::members)
RETURN self

************************************************************************
* Clean UP
************************************************************************
METHOD drgFormContainer:destroy()
LOCAL x
  IF !EMPTY(::members)
    FOR x := LEN(::members) TO 1 STEP -1
      ::members[x]:destroy()
    NEXT
  ENDIF

  ::members := ;
  ::formName:= ;
  ::len     := ;
  ::pos     := ;
               NIL
RETURN

************************************************************************
************************************************************************
*
* drgDynamicForm type definition class
*
************************************************************************
************************************************************************
CLASS _drgDrgDynamicForm FROM _drgDrgForm
  EXPORTED:
  INLINE METHOD init(line)
    ::_drgDrgForm:init(line)
    ::type := 'DrgDynamicForm'
  RETURN self
ENDCLASS

************************************************************************
************************************************************************
*
* drgForm type definition class
*
************************************************************************
************************************************************************
CLASS _drgDrgForm
  EXPORTED:

  VAR     type
  VAR     dType
  VAR     isReadOnly
  VAR     title
  VAR     guiLook
  VAR     file
  VAR     cargo
  VAR     print
  VAR     size
  VAR     pgm
  VAR     pre
  VAR     post
  VAR     border
  VAR     help

  VAR     cbLoad
  VAR     cbSave
  VAR     cbDelete

  var     prnFiles
  var     comFiles
  var     tskObdobi

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgDrgForm:init(line)
  ::type := 'drgform'

  IF line != NIL
    ::parse(line)
  ENDIF

  DEFAULT ::title      TO ''
  DEFAULT ::size       TO {80, 20}
  DEFAULT ::dType      TO '0'
  DEFAULT ::isReadOnly TO .F.
  DEFAULT ::border     TO drgINI:defDlgBorder
  DEFAULT ::prnFiles   TO ''
  DEFAULT ::comFiles   TO ''
  DEFAULT ::tskObdobi  TO ''
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgDrgForm:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'SIZE'       ;  ::size       := _getNumArr(value)
    CASE keyWord == 'DTYPE'      ;  ::dType      := ALLTRIM( _getStr(value) )
    CASE keyWord == 'CARGO'      ;  ::cargo      := _getStr(value)
    CASE keyWord == 'FILE'       ;  ::file       := UPPER( _getStr(value) )
    CASE keyWord == 'TITLE'      ;  ::title      := _getStr(value)
    CASE keyWord == 'GUILOOK'    ;  ::guilook    := _getStr(value)
    CASE keyWord == 'PGM'        ;  ::pgm        := _getStr(value)
    CASE keyWord == 'PRINT'      ;  ::print      := _getStr(value)
    CASE keyWord == 'PRE'        ;  ::pre        := _getStr(value)
    CASE keyWord == 'POST'       ;  ::post       := _getStr(value)
    CASE keyWord == 'CBLOAD'     ;  ::cbLoad     := _getStr(value)
    CASE keyWord == 'CBDELETE'   ;  ::cbDelete   := _getStr(value)
    CASE keyWord == 'CBSAVE'     ;  ::cbSave     := _getStr(value)
    CASE keyWord == 'READONLY'   ;  ::isReadOnly := UPPER(_getStr(value)) = 'Y'
    CASE keyWord == 'BORDER'     ;  ::border     := _getNum(value)
    CASE keyWord == 'HELP'       ;  ::help       := _getStr(value)
    CASE keyWord == 'PRINTFILES' ;  ::prnFiles   := strtran(_getStr(value),' ','')
    CASE keyWord == 'COMMFILES'  ;  ::comFiles   := strtran(_getStr(value),' ','')
    CASE keyWord == 'OBDOBI'     ;  ::tskObdobi  := _getStr(value)


*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDrgForm:destroy()

  ::type        := ;
  ::dType       := ;
  ::isReadOnly  := ;
  ::title       := ;
  ::guiLook     := ;
  ::file        := ;
  ::cargo       := ;
  ::print       := ;
  ::size        := ;
  ::pgm         := ;
  ::pre         := ;
  ::post        := ;
  ::border      := ;
  ::cbLoad      := ;
  ::cbSave      := ;
  ::cbDelete    := ;
  ::help        := ;
                   NIL
RETURN

************************************************************************
************************************************************************
*
* drgWizardPage type definition class
*
************************************************************************
************************************************************************
CLASS _drgWizardPage
  EXPORTED:

  VAR     type
  VAR     title
  VAR     pre
  VAR     post

  METHOD  init
  METHOD  parse
  METHOD  destroy

ENDCLASS

************************************************************************
* Init
************************************************************************
METHOD _drgWizardPage:init(line, type)
  ::type := 'wizardpage'
  IF line != NIL
    ::parse(line)
  ENDIF
RETURN self

************************************************************************
* Parse values from line description
************************************************************************
METHOD _drgWizardPage:parse(line)
LOCAL keyWord, value
  WHILE ( keyWord := _parse(@line, @value) ) != NIL
    DO CASE
    CASE keyWord == 'TITLE'
      ::title := _getStr(value)
    CASE keyWord == 'PRE'
      ::guilook := _getStr(value)
    CASE keyWord == 'POST'
      ::guilook := _getStr(value)
*    OTHERWISE
*   POST ERROR
    ENDCASE
  ENDDO
  DEFAULT ::title TO ''
RETURN

************************************************************************
* CleanUP
************************************************************************
METHOD _drgWizardPage:destroy()
  ::type    := ;
  ::title   := ;
  ::pre     := ;
  ::post    := ;
              NIL
RETURN

************************************************************************
************************************************************************
*
* EndXXX type definition class
*
************************************************************************
************************************************************************
CLASS _drgEnd
  EXPORTED:
  VAR     type
*******
  INLINE METHOD  init
    ::type := 'end'
  RETURN self
*******
  INLINE METHOD  destroy
    ::type  := NIL
  RETURN
ENDCLASS