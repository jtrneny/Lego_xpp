//////////////////////////////////////////////////////////////////////
//
//  drgProgram.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgProgram creates default drgDialog for running batch programs.
//
//   Remarks:
//       Program, UDCP or CLASS name is supplied by initParam exported variable \
//       of parent object. Parameters separated by comma are:
//
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"

CLASS drgProgramDialog from drgUsrClass
EXPORTED:
  VAR     aForm

  VAR     formName
  VAR     pgmName
  VAR     title

  METHOD  init
  METHOD  getForm
  METHOD  doRun
*********
  METHOD  destroy

ENDCLASS

************************************************************************
* Initialization of drgProgramDialog.
************************************************************************
METHOD drgProgramDialog:init(parent)
LOCAL F, st, prmtrs, aLen
LOCAL fileName, nRsrc, type

  ::drgUsrClass:init(parent)
  ::aForm   := {}
* PARSE parameters
  prmtrs   := parent:initParam
  drgParse(@prmtrs)
  ::formName:= drgParse(@prmtrs)
* Printout program name
  IF EMPTY( ::pgmName := drgParse(@prmtrs) )
    ::pgmName := 'program_' + ::formName
  ENDIF
* Dialog title, if supplied
  ::title := drgNLS:msg('Run program') + ':' + drgNLS:msg( drgParse(@prmtrs) )
* Check if file exists
  fileName := drgINI:dir_RSRC + ::formName + '.FRM'
* Try to read dialog header from header file.
  IF (st := _drgGetSection(@F, @fileName, @nRsrc)) = NIL
    st := ''
  ENDIF
* Check for type parameter and create one if not found
  IF (type := drgGetParm("TYPE",st)) = NIL
    AADD(::aForm,'TYPE(drgForm) SIZE(50,10)')
* TYPE present but not of drgForm. Create one.
  ELSEIF LOWER(type) != 'drgform'
    AADD(::aForm,'TYPE(drgForm) SIZE(50,10)')
    AADD(::aForm, st)
* add drgForm TYPE line
  ELSE
    AADD(::aForm, st)
  ENDIF
* Set guilook if not set yet
  IF drgGetParm("GUILOOK",::aForm[1]) = NIL
    ::aForm[1] += 'GUILOOK(All:N,Action:Y)'
  ENDIF
* PGM  must be set
  IF drgGetParm("CARGO",::aForm[1]) = NIL
    ::aForm[1] += 'CARGO(' + ::formName + ')'
  ENDIF
* Set title
  IF drgGetParm("TITLE",::aForm[1]) = NIL
    ::aForm[1] += 'TITLE(' + ::title + ')'
  ENDIF

* Read rest of header file for other form definitions and add them to form object
  WHILE ( st := _drgGetSection(@F, @fileName, @nRsrc) ) != NIL
    IF (type  := drgGetParm("TYPE",st) ) != NIL
      AADD(::aForm, st)
    ENDIF
  ENDDO
* Add some constant actions
  AADD(::aForm, 'TYPE(ACTION) CAPTION(~Run) EVENT(doRun) PRE(2) ATYPE(3) ICON1(159) ICON2(158)TIPTEXT(' + drgNLS:msg('Run program') + ')' )
  AADD(::aForm, 'TYPE(ACTION) CAPTION(Cancel)  EVENT(140000002)  ATYPE(3) ICON1(102) ICON2(202)TIPTEXT(' + drgNLS:msg('Cancel and close dialog.') + ')' )
* ADD dummy invisible pushbutton in case that no input field is specified
  AADD(::aForm, 'TYPE(PUSHBUTTON) CAPTION() POS(0)SIZE(0,0) EVENT(doRun) PRE(2)ATYPE(4)')
*
RETURN self

************************************************************************
* Returns form definition for dialog. Form has been created in init section.
************************************************************************
METHOD drgProgramDialog:getForm()
  IF LEN(::aForm) > 0
    RETURN drgFormContainer():new(::aForm)
  ENDIF
RETURN NIL

************************************************************************
* Called on Print action selected. Calls required function or class and thus \
* starts printing.
************************************************************************
METHOD drgProgramDialog:doRun()
LOCAL cPgmBlock, prObj
LOCAL ret := .T.
  ::dataManager:save()
  drgINI:printerName := RTRIM(drgINI:printerName)
  IF ISMETHOD(self, '_doRun')
    ::_doRun()
  ELSEIF ISFUNCTION(::pgmName)                    // if function
    cPgmBlock := '{ |a| ' + ::pgmName + '(a) }'   // create codeBlock
    EVAL(&(cPgmBlock), self)                      // call function
  ELSEIF ClassObject( ::pgmName ) = NIL           // if not class
    drgMsgBox(drgNLS:msg("Program & doesn't exist!",::pgmName))
    ret := .F.                                    // probably an error
  ELSE
    cPgmBlock := '{ |a| ' + ::pgmName + '():new(a) }'     // execute create object
    prObj := EVAL(&cPgmBlock, self)
    prObj:create()
    prObj:destroy()
    prObj := NIL
  ENDIF
*
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN ret

*************************************************************************
* CleanUP
*************************************************************************
METHOD drgProgramDialog:destroy()
  ::drgUsrClass:destroy()

  ::aForm       := ;
  ::formName    := ;
  ::pgmName     := ;
  ::title       := ;
                   NIL
RETURN self


