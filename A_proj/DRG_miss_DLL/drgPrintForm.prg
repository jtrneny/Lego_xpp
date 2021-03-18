//////////////////////////////////////////////////////////////////////
//
//  drgPrintForm.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Default print dialog implementation with
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drgRes.ch"
#include "drg.ch"
#pragma Library( "XppUI2.lib" )

************************************************************************
*
* drgPrintDialog object is an entry point for drg printer outputs.
*
************************************************************************
CLASS drgPrintDialog from drgUsrClass
EXPORTED:
  VAR     aForm

  VAR     HDRName
  VAR     pgmName
  VAR     title

  METHOD  init
  METHOD  getForm
  METHOD  doSetup
  METHOD  _doPrint
*********
  METHOD  destroy

ENDCLASS

************************************************************************
* Initialization of drgPrintDialog.
************************************************************************
METHOD drgPrintDialog:init(parent)
LOCAL F, st, prmtrs, aLen, type
LOCAL fileName, nRsrc, pgmName

  ::dialogIcon := DRG_ICON_PRINT
  ::drgUsrClass:init(parent)
  ::aForm := {}
* PARSE parameters
  prmtrs  := parent:initParam
  pgmName := drgParse(@prmtrs)
* Get HDRName if set
  IF EMPTY(::HDRName := drgParse(@prmtrs) )
    ::HDRName := pgmName
  ENDIF
* Printout program name
  IF EMPTY( ::pgmName := drgParse(@prmtrs) )
    ::pgmName := 'print_' + ::HDRName
  ENDIF
* Dialog title, if supplied
  IF EMPTY( ::title := drgParse(@prmtrs) )
    ::title := drgNLS:msg('Print dialog')
  ENDIF
* Check if file exists
  fileName := drgINI:dir_RSRC + ::HDRName + '.HDR'
* Try to read dialog header from header file.
  IF (st := _drgGetSection(@F, @fileName, @nRsrc)) = NIL
*    drgMsgBox(drgNLS:msg('Print program HDR definition & not found.',::HDRName))
*    RETURN NIL
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
    ::aForm[1] += 'CARGO(' + ::HDRName + ')'
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
*  AADD(::aForm, 'TYPE(ACTION) CAPTION(' + drgNLS:msg('~Setup') + ') TIPTEXT(' + drgNLS:msg('Setup print device') + ')EVENT(doSetup) PRE(2) ATYPE(3) ICON1(115) ICON2(215)')
  AADD(::aForm, 'TYPE(ACTION) CAPTION(~Setup) TIPTEXT(Setup print device) EVENT(doSetup) PRE(2) ATYPE(3) ICON1(115) ICON2(215)')
  AADD(::aForm, 'TYPE(ACTION) CAPTION(~Print) TIPTEXT(Start print job) EVENT(_doPrint) PRE(2) ATYPE(3) ICON1(101) ICON2(201)')
  AADD(::aForm, 'TYPE(ACTION) CAPTION(Cancel) TIPTEXT(Cancel printing) EVENT(140000002)  ATYPE(3) ICON1(102) ICON2(202)')
* Create line for displaying currently selected printer
  IF EMPTY(aLen := drgParse(drgGetParm("SIZE",::aForm[1])))
    aLen := '10'
  ENDIF
  AADD(::aForm, 'TYPE(TEXT) FCAPTION('+ drgNLS:msg('Printer') + ')CPOS(0,0)CLEN(8)')
  st := 'TYPE(TEXT) NAME(drgIni:printerName) CPOS(8,0) FONT(5)'
  st += 'CLEN(' + ALLTRIM(STR(VAL(aLen)-8)) + ')'
  AADD(::aForm, st)
*
RETURN self

************************************************************************
* Returns form definition for dialog. Form has been created in init section.
************************************************************************
METHOD drgPrintDialog:getForm()
  IF LEN(::aForm) > 0
* ADD dummy invisible pushbutton in case that no input field is specified
    AADD(::aForm, 'TYPE(PUSHBUTTON) CAPTION() POS(0) SIZE(0,0) EVENT(_doPrint) PRE(2) ATYPE(4)')
    RETURN drgFormContainer():new(::aForm)
  ENDIF
RETURN NIL

************************************************************************
* Called on Print action selected. Calls required function or class and thus \
* starts printing.
************************************************************************
METHOD drgPrintDialog:doSetup()
LOCAL oDialog, nExit
* Create printer setup dialog
  DRGDIALOG FORM 'drgPrintSetup' PARENT ::drgDialog EXITSTATE nExit MODAL DESTROY
* Refresh active printer
  IF nExit != drgEVENT_QUIT
    ::dataManager:get('m->drgIni:printerName',.F.):refresh()
  ENDIF
RETURN NIL

************************************************************************
* Called on Print action selected. Calls required function or class and thus \
* starts printing.
************************************************************************
METHOD drgPrintDialog:_doPrint()
LOCAL cPgmBlock, oPrint
LOCAL ret := .T.
*  cPGM := ::pgmName
  ::dataManager:save()
  IF ISMETHOD(self, 'doPrint')
    ::doPrint()
  ELSEIF ISFUNCTION(::pgmName)                    // if function
    cPgmBlock := '{ |a| ' + ::pgmName + '(a) }'   // create codeBlock
    EVAL(&(cPgmBlock), self)                      // call function
  ELSEIF ClassObject( ::pgmName ) = NIL           // if not class
    drgMsgBox(drgNLS:msg('Invalid print program definition &.',::pgmName))
    ret := .F.                                    // probably an error
  ELSE
    cPgmBlock := '{ |a| ' + ::pgmName + '():new(a) }'     // execute create object
    oPrint := EVAL(&cPgmBlock, self)
    oPrint:create()
    oPrint:destroy()
    oPrint := NIL
  ENDIF
*
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN ret

*************************************************************************
* CleanUP
*************************************************************************
METHOD drgPrintDialog:destroy()
  ::drgUsrClass:destroy()

  ::aForm   := ;
  ::HDRName := ;
  ::pgmName := ;
  ::title   := ;
               NIL
RETURN self

************************************************************************
*
* drgPrintSetup is printer setup dilaog.
*
************************************************************************
CLASS drgPrintSetup from drgUsrClass
EXPORTED:

  METHOD  getForm
  METHOD  postName
  METHOD  doProperties
*********
  METHOD  destroy

HIDDEN:
  VAR     prVar

ENDCLASS

************************************************************************
*
************************************************************************
METHOD drgPrintSetup:getForm()
LOCAL fCnt, oDrg, x, st := ''
  fCnt := drgFormContainer():new()
  DRGFORM INTO fCnt TITLE 'Print device setup' SIZE 51,5 GUILOOK 'All:N'
* Combobox for choices
  FOR x := 1 TO LEN(drgINI:printerList)
    st += drgINI:printerList[x,1] + ','
  NEXT
  st := LEFT(st, LEN(st) - 1)
  DRGCOMBOBOX drgINI:printerName INTO fCnt FPOS 1,1 FLEN 37 POST 'postName' ;
    VALUES st
* PushButton for properties
  DRGPUSHBUTTON INTO fCnt POS 40,1 CAPTION 'Properties' ATYPE 4 PRE '1' ;
    EVENT 'doProperties'
* PushButton for OK
  DRGPUSHBUTTON INTO fCnt POS 30,4 CAPTION 'O~K' ATYPE 3 PRE '1' ;
    ICON1 101 ICON2 201 EVENT drgEVENT_EXIT
* PushButton for Cancel
  DRGPUSHBUTTON INTO fCnt POS 40,4 CAPTION 'Cancel' ATYPE 3 PRE '0' ;
    ICON1 102 ICON2 202 EVENT drgEVENT_QUIT
RETURN fCnt

*************************************************************************
* Just save internal objects pointer so it can be set on printer properties.
*************************************************************************
METHOD drgPrintSetup:postName(aVar)
  ::prVar := aVar
RETURN .T.

*************************************************************************
* Properties button was selected.
*************************************************************************
METHOD drgPrintSetup:doProperties()
LOCAL oPrinter, oPS, oDlg, aSize
  oDlg := XbpPrintDialog():new()
* Default output goes to file
  oDlg:enablePrintToFile := .T.
  oDlg:create()
* Obtain configured printer object
  oPrinter := oDlg:display()
  oDlg:destroy()
* Save selected printer to comboBox
  IF oPrinter != NIL
    ::prVar:set(oPrinter:devName)
  ENDIF
RETURN self

*************************************************************************
* CleanUP
*************************************************************************
METHOD drgPrintSetup:destroy()
  ::drgUsrClass:destroy()

  ::prVar       := ;
                   NIL
RETURN self


