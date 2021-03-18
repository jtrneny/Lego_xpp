//////////////////////////////////////////////////////////////////////
//
//  drgPrint.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Printing subsystem controller. drgPrint Class is abstract class
//       for different printer class implementation. drg provides classes for
//       text printers (Epson, HP) and Windows printing subsistem.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "gra.ch"
#include "drgRes.ch"
#include "drg.ch"

CLASS drgPrint
EXPORTED:

  VAR type
  VAR parent
************************************
* PRINTER COMMANDS DEFINITION
************************************
  VAR prReset
  VAR prCPI5
  VAR prCPI10
  VAR prCPI12
  VAR prCPI15
  VAR prCPI17
  VAR prCPI20
  VAR prNextLine
  VAR prFormFeed
  VAR prFormLen
  VAR currentCPI            // current CPI value

  VAR prBold_ON
  VAR prBold_OFF
  VAR prULin_ON
  VAR prULin_OFF
  VAR prExp_ON
  VAR prExp_OFF
  VAR prExt_ON
  VAR prExt_OFF
  VAR prItal_ON
  VAR prItal_OFF
  VAR prCond_ON
  VAR prCond_OFF
  VAR prLQ_ON
  VAR prLQ_OFF

  VAR prPrefix                    // print line prefix string

  VAR prPageLen                   // page length in lines
  VAR prLastLine                  // last line number of printout
  VAR prCurrLine                  // current printhead line position
  VAR prCurrCol                   // current printhead column position
  VAR prPageNum                   // current page number

  VAR prIsNewPage                 // .T. when skip to new page must be performed
  VAR prIs1stPage                 // .T. before first line is printed

  VAR prOutFile                   // printer output file name
  VAR prFile                      // file object

  VAR prPrintOK                   // last print request was succesfull
  VAR prCancelOK                  // can printing be canceled on orror

  VAR prOldPort
  VAR prDelimited                 // requested is tab delimited write to file

  METHOD  init                    // initialization part
  METHOD  create                  // creation part
  METHOD  printHDR
  METHOD  write                   // write chars to printer
* Printing
  METHOD  printLine               // prints line of chars
  METHOD  printSkip               // skips specified number of lines
  METHOD  printPage               // skips to next page
  METHOD  print                   // perform print of object
  METHOD  printNum                // prints a number
* dummy methods for preprocessor. These methods call
  METHOD  _printLine
  METHOD  _printSkip
  METHOD  _printPage
  METHOD  _print
  METHOD  _printNum

  METHOD  controlChars
  METHOD  convert
  METHOD  destroy

HIDDEN:
  VAR     header

  METHOD  prepareHDR
  METHOD  fieldLength
ENDCLASS

*********************************************************************
* Initialization part of drgPrint.
*********************************************************************
METHOD drgPrint:init(prHdrFile, prPageLen, prLastLine)
  DEFAULT prPageLen   TO drgINI:printPageLen
  DEFAULT prLastLine  TO prPageLen - 4

  ::prLastLine  := prLastLine
  ::prPageLen   := prPageLen

  ::prOldPort   := ''
  ::prDelimited := .F.

  ::prCurrCol   := 0
  ::prPageNum   := 0
  ::prCurrLine  := 0
  ::prIsNewPage := .T.
  ::prIs1stPage := .T.
  ::prPrintOK   := .T.
  ::prCancelOK  := .T.
  ::prOutFile   := drgINI:printerDevice
  ::currentCPI  := 10

  IF VALTYPE(prHdrFile) = 'A'
    ::header := ACLONE(prHdrFile)
  ELSE
    ::prepareHDR(prHdrFile)
  ENDIF
RETURN self

************************************************************************
METHOD drgPrint:create()
LOCAL err
* Open file for printing
  ::prFILE := FCREATE(::prOutFile)
  ::write(::prReset)

  IF !::prDelimited
    ::write(::prCond_OFF+::prBold_OFF+::prUlin_OFF+::prItal_OFF+::prExp_OFF+::prCPI10)
  ENDIF
RETURN self

************************************************************************
* Performs write to output printer file. After write, error is examined and \
* user is informed when error ocurs.
*
* Parameters:
* < s > : string : string to write to printer file
************************************************************************
METHOD drgPrint:write(s)
LOCAL err

  WHILE ::prPrintOK
    FWRITE(::prFILE, ::prPrefix + s)
    IF (err := FERROR() ) = 0
      RETURN
    ELSE
      IF !drgIsYesNO(drgNLS:msg('Print error!;& &;;Correct error and choose option.', ;
                       ALLTRIM(STR(err,5)), DosErrorMessage(err) ), XBPMB_RETRYCANCEL)
        IF ::prCancelOK                           // can it be canceled
          ::prPrintOK := .F.                      // YES. Set no print VAR
          RETURN
        ELSE                                      // NO. Pos message
          drgMsgBox(drgNLS:msg("Printing may not be canceled!") )
        ENDIF
      ENDIF
    ENDIF
  ENDDO
RETURN

**************************************************************************
METHOD drgPrint:PrepareHDR(cHDRFile)
LOCAL F, st, hFileName, nType

  ::header  := {}
  hFileName := drgINI:dir_RSRC + cHDRFile + '.HDR'
  IF ( st := _drgGetSection(@F, @hFileName, @nType, .T.) ) = NIL
    drgMsgBox(drgNLS:msg('Print program HDR definition & not found.',cHDRFile))
    RETURN .F.
  ENDIF
*
  WHILE st != NIL
    IF AT('type(',LOWER(st)) = 0      // ignore dialog definitions
      AADD(::header, st)
    ENDIF
    st := _drgGetSection(@F, @hFileName, @nType, .T.)
  ENDDO
RETURN .T.

*************************************************************************
* Prints header at the begining of new page.
*************************************************************************
METHOD drgPrint:PrintHDR()
LOCAL x, st, fLen, recNum, dataNum
*
  dataNum := 0
  IF ::prIs1stPage .OR. !::prDelimited     && No header on additional pages if delimited
    ::write(::prCond_OFF+::prBold_OFF+::prUlin_OFF+::prItal_OFF+::prExp_OFF+::prCPI10)
    ::currentCPI := 10
    FOR recNum := 1 TO LEN(::header)                // FOR all header lines
      ::prCurrLine := recNum
      st := ::header[recNum]
      WHILE ( x := AT("$",st) ) > 0                 // is HEAD field present in line
        fLen  := ::fieldLength(st, x)
* Set length
        DataNum++
        HEAD[DataNum] := PADR(HEAD[DataNum],fLen,' ')
        HEAD[DataNum] := LEFT(HEAD[DataNum],fLen)
*
        st := STUFF(st, x, fLen, HEAD[DataNum])
      ENDDO
* Datum
      IF ( x := AT("#",St) ) > 0
        fLen  := ::fieldLength(st, x)
        st    := STUFF(st, x, fLen, TRANSFORM(DATE(),"D"))
      ENDIF
* Stran
      IF ( x := AT("!",St) ) > 0
        fLen  := ::fieldLength(st, x)
        st    := STUFF(st, x, fLen, drgPadL(::prPageNum, fLen))
      ENDIF
      st := ::controlChars(st)
      ::write(st, LEN(st), LEN(st), .T.)
      ::printSkip(0)                     //  + ::prNextLine
    NEXT
  ENDIF
  ::prIs1stPage  := .F.
* Call header method of parent
  IF ::parent != NIL .AND. isMethod(::parent,'printHDRFTR')
    ::parent:printHDRFTR(self, .T.)
  ENDIF
RETURN

*********************************************************************
* Will return number of equal charachters from start position. It is used for \
* determining the length of calculated field on the form.
*
* Parameters:
* st : String : string to search
* start : number : search start position
*
* Return: number : Length of parameter
*********************************************************************
METHOD drgPrint:fieldLength(st, start)
LOCAL aPos := start
LOCAL aChar
  aChar := SUBSTR(st,start,1)
  WHILE SUBSTR(st,aPos,1) == aChar
    aPos++
  ENDDO
RETURN aPos - start

******************************************************************
* Searches string for control chars and replaces chars with appropriate printer commands
******************************************************************
METHOD drgPrint:controlChars(st)
LOCAL x,Tip, ch, s
  ::prCurrCol  := 1                    // sets last right position
  WHILE (x := AT("?",st)) > 0
    Tip := SUBSTR(st, x+1, 1)
    s := LEFT(st, x-1)

    DO CASE
* CONDENSED
    CASE Tip = 'C'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prCond_OFF, ::prCond_ON)
* set CPI
      IF ch = ::prCond_ON
        ::currentCPI := IIF(::currentCPI = 10, 17, 20)
      ELSE
        ::currentCPI := IIF(::currentCPI = 15, 10, 12)
      ENDIF
      x+=3
* ITALIC
    CASE Tip = 'I'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prItal_OFF, ::prItal_ON)
      x+=3
* UNDERLINE
    CASE Tip = 'U'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prULin_OFF, ::prULin_ON)
      x+=3
* LQ
    CASE Tip = 'L'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prLQ_OFF, ::prLQ_ON)
      x+=3
* EXPANDED
    CASE Tip = 'E'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prExp_OFF, ::prExp_ON)
      x+=3
* BOLD
    CASE Tip = 'B'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prBold_OFF, ::prBold_ON)
      x+=3
* Expanded
    CASE Tip = 'W'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prExp_OFF, ::prExp_ON)
      x+=3
* Extended
    CASE Tip = 'w'
      ch := IIF(SUBSTR(st,x+2,1) = 'F',::prExt_OFF, ::prExt_ON)
      ::currentCPI := IIF(ch = ::prExt_OFF, 10, 5)
      x+=3
* 80 CPI
    CASE Tip = 'N'
      ch := ::prCPI10
      ::currentCPI := 10
      x+=2
* 96 CPI
    CASE Tip = 'S'
      ch := ::prCPI12
      ::currentCPI := 12
      x+=2
* 120 CPI
    CASE Tip = 'K'
      ch := ::prCPI15
      ::currentCPI := 15
      x+=2
    OTHERWISE
      St := STUFF(St,X,1,' ')
      x++

    ENDCASE
    ::write(::convert(s)+ch)
    st := RIGHT(st,LEN(st) - x + 1 )
  ENDDO
  ::write(::convert(st) )
*   + conversion if needed
RETURN ''

*********************************************************************
* Print full line of charachters. Before writing totals it is a custom to write \
* a line across the form.
*
* Parameters:
* rPos  : number : right position of line
* lLen  : number : line length. Default is rPos.
* char  : charachter to print. Default char is '-'.
*********************************************************************
METHOD drgPrint:printLine(rPos, lLen, char)
  DEFAULT lLen TO rPos
  DEFAULT char TO '-'

  ::print(REPLICATE(char, lLen), rPos, lLen)
RETURN self

*********************************************************************
*********************************************************************
METHOD drgPrint:_printLine(rPos,lLen,char)
RETURN ::printLine(rPos,lLen,char)

*********************************************************************
* Skips (feed) specified number of lines
*
* Parameters:
* num   : number : number of lines to skip. Default is one.
*********************************************************************
METHOD drgPrint:printSkip(num)
LOCAL x
  DEFAULT num TO 1
* if not in first column then additional linefeed must be specified
  IF ::prCurrCol > 0
    num++
  ENDIF
*
  FOR x := 1 TO num
    ::write(::prNextLine)
  NEXT
  ::prCurrLine += num
  ::prCurrCol  := 0
RETURN self

*********************************************************************
*********************************************************************
METHOD drgPrint:_printSkip(num)
RETURN ::printSkip(num)

*********************************************************************
* Skips to next page. Performs form feed.
*********************************************************************
METHOD drgPrint:PrintPage()
* Call footer method of parent
  IF ::parent != NIL .AND. isMethod(::parent,'printHDRFTR')
    ::parent:printHDRFTR(self, .F.)
  ENDIF
*
  IF !::prDelimited
    ::write(::prFormFeed)
  ENDIF
  ::prIsNewPage:=.T.
RETURN

************************************************************************
************************************************************************
METHOD drgPrint:_printPage()
RETURN ::printPage()

************************************************************************
* Performs print of field.
*
* Parameters:
* st    : character : character string to print
* rPos  : numeric : right printing position
* aLen  : numeric : Length of string. Default is LEN(st).
* code  : numeric : Defines if bold, italic, underline or expanded printing is selected.
* leftAdjust : logical : .T. if string is printed left adjusted. .F. is used \
* for printing numbers which are usualy right adjusted.
************************************************************************
METHOD drgPrint:print(st, rPos , aLen, code, leftAdjust)

  DEFAULT code       TO 0
  DEFAULT leftAdjust TO .T.
  DEFAULT aLen       TO LEN(St)

* skip to next line when right pos is lower than last right pos
  IF rPos - aLen - ::prCurrCol < 0
    ::printSkip(0)
  ENDIF
* new page when line is after page endLine
  IF ::prCurrLine > ::prLastLine
    ::printPage()
  ENDIF
* If owerflow (new page) then print header
  IF ::prIsNewPage
    ::prPageNum++
    ::printHDR()
    ::prIsNewPage := .F.
  ENDIF

  IF LEN(st) < aLen
    IF leftAdjust
      st += REPLICATE(" ",aLen-LEN(st))          // left adjust. add blanks to end
    ELSE
      st := REPLICATE(" ",aLen-LEN(st)) + st     // right adjust. add blanks to start
    ENDIF
  ENDIF
  st := LEFT(st, aLen)
* Space beetween two fields. Append blanks.
  IF ::prCurrCol + aLen < rPos
    st := REPLICATE(" ",rPos - aLen - ::prCurrCol) + st
  ENDIF

  st := ::convert(st)
  DO CASE
    CASE code = 0; ::write(st)
    CASE code = 1; ::write(::prBold_ON+St+::prBold_OFF)
    CASE code = 2; ::write(::prItal_ON+St+::prItal_OFF)
    CASE code = 4; ::write(::prULin_ON+St+::prULin_OFF)
    CASE code = 8; ::write(::prExp_ON +St+::prExp_OFF)
  ENDCASE
*
  IF ::prDelimited                  // Add Tab char for delimited files
    ::write(CHR(09))
  ENDIF
  ::prCurrCol := rPos
RETURN

************************************************************************
************************************************************************
METHOD drgPrint:_print(st, rPos , aLen, code, leftAdjust)
RETURN ::print(st, rPos , aLen, code, leftAdjust)

************************************************************************
************************************************************************
METHOD drgPrint:convert(st)
RETURN drgNLS:prConvert(st)

************************************************************************
* Performs print of numeric field.
*
* Parameters:
* \b< num  >b\  : numeric   : number to be printed
* \b< nPos >b\  : numeric   : Right printing position
* \b< mLen >b\  : numeric   : Length of resulting string
* \b< mLen >b\  : character : transform picture
* \b[ nDec ]b\  : numeric   : number of decimals. Default is 2.
* \b[ lZero ]b\ : logical   : print zeros when value of number is zero. Default is .T.
************************************************************************
METHOD drgPrint:printNum(num, nPos, mLen, nDec, lZero)
LOCAL St
  DEFAULT nDec TO 2
* Must write 0 when delimited
  lZero := IIF(lZero = NIL .OR. ::prDelimited, .T., lZero)

  IF ::prDelimited
    st := ALLTRIM( STR(num) )              // no formating
*    st :=STRTRAN(St,'.',',')
  ELSE
* Len specified
    IF VALTYPE(mLen) = 'N'
      st := drgFormNum(num, mLen, nDec)     // formated
* Picture specified
    ELSE
      st := TRANSFORM(num, mLen)
    ENDIF
  ENDIF
*
  IF lZero .OR. num != 0
    ::print(st, nPos, LEN(st),,.F.)
  ENDIF
RETURN

*********************************************************************
*********************************************************************
METHOD drgPrint:_printNum(num, rPos, aLen, dec, wZero)
RETURN ::printNum(num, rPos, aLen, dec, wZero)

*********************************************************************
* Clean up
*********************************************************************
METHOD drgPrint:destroy()
  IF !::prDelimited
    ::write(::prFormFeed)
  ENDIF
  FCLOSE(::prFILE)
*
  ::header := NIL
RETURN

**********************************************************************
**********************************************************************
FUNCTION drgPrintReport(prHdrFile, prPageLen, prLastLine)
LOCAL prObj, cPGM, cPgmBlock, x
* Printer device not found on printer list. Something is wrong.
*  drgDump(drgINI:printerName,'drgINI:printerName')
  IF(x := ASCAN(drgINI:printerList, {|a| a[1] = drgINI:printerName} ) ) = 0
    drgLog:log('WARNING! Printer name not found in printer list!')
    IF LEN(drgINI:printerList) > 0
      x := 1
    ELSE
      RETURN NIL
    ENDIF
  ENDIF
*
  drgINI:printerName    := drgINI:printerList[x,1]
  drgINI:printerType    := drgINI:printerList[x,2]
  drgINI:printerDevice  := drgINI:printerList[x,3]
*
  cPGM := 'drgPrint_'+drgINI:printerType
  IF ClassObject( cPGM ) = NIL                      // No program, no form.
    RETURN NIL                                      // Must return.
  ENDIF
*
  DEFAULT prPageLen  TO VAL(drgINI:printerList[x,4])
  DEFAULT prLastLine TO VAL(drgINI:printerList[x,5])
  drgNLS:setPrinterCP(drgINI:printerList[x,6])
*
  cPgmBlock := '{ |a, b, c| ' + cPGM + '():new(a, b, c) }'
  prObj := EVAL(&cPgmBlock, prHdrFile, prPageLen, prLastLine)

* User initialization if required
  IF ISFunction(drgINI:stdPrinterInit)
    cPgmBlock := '{ |a| ' + drgINI:stdPrinterInit + '(a) }'
    EVAL(&cPgmBlock, prObj)
  ENDIF
*
  prObj:create()
RETURN prObj

**********************************************************************
* Creates internal list of available printers on this computer. This list \
* is later used for determining of printer output. Procedure should be called \
* only once at the beginning of the program.
**********************************************************************
PROCEDURE drgPrinterCreateList()
LOCAL oDC := XbpPrinter():New()
LOCAL aList
  IF !EMPTY(oDC:list())
    AEVAL(oDC:list(), {|el| AADD(drgINI:printerList, {el,'windows','', '66', '66',''}) })
  ENDIF
RETURN

**********************************************************************
* Does nothing since nothing is to be done.
**********************************************************************
PROCEDURE _drgStdPrinterInit(prObj)
*  drgDump(prObj,'prObj')
RETURN

