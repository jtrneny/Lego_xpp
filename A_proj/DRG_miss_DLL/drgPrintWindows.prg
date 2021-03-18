//////////////////////////////////////////////////////////////////////
//
//  drgPrint.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//        Implementation of drgPrint class for Windows printer.
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Common.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"

CLASS drgPrint_WINDOWS FROM drgPrint
EXPORTED:
  VAR     paperSize
  VAR     fonts
  VAR     lastFont
  VAR     lastFontName

  METHOD  init
  METHOD  create

  METHOD  print
  METHOD  printPage
  METHOD  printSkip
  METHOD  write
  METHOD  controlChars

  METHOD  destroy

HIDDEN:
  VAR     defFontCP            // default font code page
  VAR     lineHeight
  VAR     tmpFontSize
  VAR     tmpCharSize
  VAR     tmpFontName
  VAR     tmpIsBold
  VAR     tmpIsItalic
  VAR     tmpString
  VAR     tmpRPos

  METHOD  setFont

ENDCLASS

*********************************************************************
* Initialization part of drgPrint_WINDOWS.
*********************************************************************
METHOD drgPrint_WINDOWS:init(prHdrFile, prPageLen, prLastLine)
LOCAL oFont, oPS
  DEFAULT prPageLen TO 66
  DEFAULT prLastLine TO 66

  ::type := 'WINDOWS'
  ::prReset    := ::prFormLen   := ''
  ::prCPI10    := ::prCPI12     := ::prCPI15    := ::prCPI17    := ::prCPI20 := ''
  ::prNextLine := ::prFormFeed  := ''
  ::prExp_ON   := ::prExp_OFF   := ::prExt_ON   := ::prExt_OFF  := ::prCPI5 := ''
  ::prCond_ON  := ::prCond_OFF  := ''
  ::prBold_ON  := ::prBold_OFF  := ::prItal_ON  := ::prItal_OFF := ''
  ::prULin_ON  := ::prULin_OFF  := ::prLQ_ON    := ::prLQ_OFF   := ::prPrefix := ''

  ::drgPrint:init(prHdrFile, prPageLen, prLastLine)

  ::prOutFile   := drgINI:printerName
* Create default font
  ::fonts           := drgArray():new(20)
  ::currentCPI      := 0
  ::tmpFontSize     := 32
* ::tmpFontName     := 'Lucida Console'
  ::tmpFontName     := drgINI:printerWinFont
*  ::tmpFontName     := 'Tahoma'
*  ::tmpFontName     := 'Arial'
*  ::tmpFontName     := 'Comic Sans MS'
  ::tmpIsBold   := .F.
  ::tmpIsItalic := .F.
  ::tmpString   := REPLICATE('O',512)
  ::tmpRPos     := 0
RETURN self

************************************************************************
METHOD drgPrint_WINDOWS:create()
LOCAL oPS, oDC, oFont
LOCAL aSize, pSize, qBox

  oDC := XbpPrinter():New()
  oDC:Create( ::prOutFile )               // ::prOutFile represents printer device name

  ::prFile  := XbpPresSpace():New()       // ::prFile is actualy presentation space
  aSize := oDC:paperSize()

// Size of printable region on paper
  ::paperSize  := {aSize[5] - aSize[3], aSize[6] - aSize[4]}
*  drgDump(::paperSize,'paperSize')
  ::lineHeight := ROUND(::paperSize[2]/::prPageLen,2)
  ::prFile:Create( oDC, aSize, GRA_PU_LOMETRIC )

// Activate spooling
  ::prFile:device():startDoc(drgINI:appName + ' - ' + drgNLS:msg('print job'))

* Get default font codepage from PP object
*********************************
  ::defFontCP := drgPP:defFontCP
  ::setFont()
* Calculate size of char
  qBox  := GraQueryTextBox( ::prFile, LEFT(::tmpString,80))
  pSize := qBox[3,1] - qBox[2,1]
  ::tmpFontSize := ROUND(2032*::tmpFontSize/pSize, 2)
  ::currentCPI  := 10
  ::setFont()
RETURN self

************************************************************************
* Returns requested xbpFont object. If font doesn't exist it is created and added to \
* internal fonts array.
*
* Parameters:
* < fontFamily >  : string  : requested font family name . Default "Courier"
* < pointSize >   : numeric : size of requested font.
* < fontWeight >  : numeric : font weight defined by XBPFONT_WEIGHT* constants. \
* Default value is XBPFONT_WEIGHT_NORMAL.
************************************************************************
METHOD drgPrint_WINDOWS:setFont()
LOCAL fontName, oFnt,pSize

  fontName := ::tmpFontName + STR(::currentCPI,3) + Var2Char(::tmpIsBold) + Var2Char(::tmpIsItalic)
* Quickie if no change since last font
  IF ::lastFontName = fontName
    RETURN self
  ENDIF
***********************************************
  IF ::currentCPI = 0                                // Only at start for default size measuring
    pSize := 32
  ELSE
    pSize := ROUND(::tmpFontSize*10/::currentCPI,2)
  ENDIF
* IF font not already created
  IF (oFnt := ::fonts:getByKey(fontName) ) = NIL
* Create font object
    oFnt := XbpFont():new( AppDesktop():lockPS() )
    oFnt:familyName       := ::tmpFontName
    oFnt:nominalPointSize := pSize
    oFnt:generic          := .T.
    oFnt:bold             := ::tmpIsBold
    oFnt:italic           := ::tmpIsItalic
    oFnt:codePage         := ::defFontCP
    oFnt:weightClass      := XBPFONT_WEIGHT_DONT_CARE
    oFnt:create()
    AppDesktop():unlockPS()
    ::fonts:add(oFnt, fontName)
    ::fonts:resort()
*    drgDump(fontName,'fontName')
  ENDIF
***********************************************
  ::lastFontName := fontName
  GraSetFont( ::prFile, oFnt )
  ::tmpCharSize := (oFnt:width + oFnt:nominalPointSize)/2
RETURN self

******************************************************************
* Searches string for control chars and replaces chars with appropriate printer commands
******************************************************************
METHOD drgPrint_WINDOWS:controlChars(st)
LOCAL x,Tip, ch, s, rPos
  rPos := 0
  WHILE (x := AT("?",st)) > 0
    s := LEFT(st, x-1)
    rPos += x - 1
    ::write(s, rPos, LEN(s), .T. )
    ::prCurrCol  := rPos                    // sets last right position
*
    Tip := SUBSTR(st, x+1, 1)
    DO CASE
* CONDENSED
    CASE Tip = 'C'
* set CPI
      IF SUBSTR(st,x+2,1) = 'F'
        ::currentCPI := IIF(::currentCPI = 15, 10, 12)
      ELSE
        ::currentCPI := IIF(::currentCPI = 10, 17, 20)
      ENDIF
      x += 3
* ITALIC
    CASE Tip = 'I'
      ::tmpIsItalic := !SUBSTR(st,x+2,1) = 'F'
      x += 3
* UNDERLINE
    CASE Tip = 'U'
*        ::tmpIsItalic := IIF(SUBSTR(st,x+2,1) = 'F',::prULin_OFF, ::prULin_ON)
      x += 3
* LQ
    CASE Tip = 'L'
*        ch := IIF(SUBSTR(st,x+2,1) = 'F',::prLQ_OFF, ::prLQ_ON)
      x += 3
* BOLD or EXPANDED
    CASE Tip = 'E' .OR. Tip = 'B'
      ::tmpIsBold := !SUBSTR(st,x+2,1) = 'F'
      x += 3
* Expanded
    CASE Tip = 'W'
      ::currentCPI := IIF(SUBSTR(st,x+2,1) = 'F', 10, 5)
      x += 3
* Extended
    CASE Tip = 'w'
      ::currentCPI := IIF(SUBSTR(st,x+2,1) = 'F', 10, 5)
      x += 3

* 80 CPI
    CASE Tip = 'N'
      x += 2
      ::currentCPI := 10
* 96 CPI
    CASE Tip = 'S'
      x += 2
      ::currentCPI := 12
* 120 CPI
    CASE Tip = 'K'
      x += 2
      ::currentCPI := 15
* xx CPI
    CASE Tip = 'X'
      ::currentCPI := VAL(SUBSTR(st,x+2,2) )
      x += 4

    OTHERWISE
      x++

    ENDCASE
    ::setFont()
    st := RIGHT(st,LEN(st) - x + 1 )
  ENDDO
  ::setFont()
  rPos += LEN(st)
  ::write(st, rPos, LEN(st), .T. )
RETURN ''
/*
************************************************************************
*
*
*
************************************************************************
METHOD drgPrint_WINDOWS:write(st, rPos, size,  adjustLeft )
LOCAL qBox, pSize, cSize, aPos := {0,0}, blanks
// Calculate size of string to draw
  IF st = NIL .OR. LEN(st) = 0; RETURN self; ENDIF
* Calculate position of string on the paper. Calculate on standard pattern of OOOOO's
  qBox    := GraQueryTextBox( ::prFile, LEFT(::tmpString, rPos - ::prCurrCol))
  xPos    := qBox[3,1] - qBox[2,1]
*
  qBox := GraQueryTextBox( ::prFile, st)
  pSize := qBox[3,1] - qBox[2,1]
*
  aPos[1] := IIF(adjustLeft, 0, xPos - pSize) + ::tmpRPos
  aPos[2] := ::paperSize[2] - (::prCurrLine)*::lineHeight

* Print IT
  GraStringAt( ::prFile, aPos, st )
* Save last Right pos
  ::tmpRPos += xPos
RETURN
*/
************************************************************************
*
*
*
************************************************************************
METHOD drgPrint_WINDOWS:write(st, rPos, size,  adjustLeft )
LOCAL charSize, stLen, aPos := {0,0}, qBox, pSize
LOCAL n, x, n1
  IF st = NIL .OR. LEN(st) = 0; RETURN self; ENDIF
* Vertical position
  aPos[2] := ::paperSize[2] - (::prCurrLine)*::lineHeight
* temporary character size acording to selected CPI
  charSize := INT( ::paperSize[1]/(::currentCPI*8) )
* PAD string with blank characters
  stLen := rPos - ::prCurrCol
  st := IIF(adjustLeft, PADL(st,stLen), PADR(st,stLen) )
* Print LOOP
  FOR n := 1 TO stLen
* Print IT
    IF st[n] != ' '
* Replace several occurences of - and = with lines
      IF st[n] $ '-='
        x := n + 1
* Count length
        IF st[x] = st[n]
          WHILE x <= stLen .AND. st[x] = st[n]
            x++
          ENDDO
* Draw single line
          aPos[1] := ::tmpRPos + 1
          n1 := INT(::lineHeight/2) - 12
          GraBox( ::prFile, { aPos[1], aPos[2]+n1 }, {aPos[1] + (x-n)*charSize - 2, aPos[2]+n1-2 }, GRA_FILL  )
* Draw double line
          IF st[n] = '='
            n1 := INT(::lineHeight/2) - 5
            GraBox( ::prFile, { aPos[1], aPos[2]+n1 }, {aPos[1] + (x-n)*charSize - 2, aPos[2]+n1-2 }, GRA_FILL  )
          ENDIF
* Correct positions
          ::tmpRPos += charSize*(x-n)
          n := x - 1
          LOOP
        ENDIF
      ENDIF
*
      qBox    := GraQueryTextBox( ::prFile, st[n])
      pSize   := qBox[3,1] - qBox[2,1]
* Center in the middle of space
      aPos[1] := ::tmpRPos + (charSize-pSize)/2

      GraStringAt( ::prFile, aPos, st[n] )
    ENDIF
* Save last Right pos
    ::tmpRPos += charSize
*    drgDump(aPos, st[n])
  NEXT

RETURN

*********************************************************************
* Skips (feed) specified number of lines
*
* Parameters:
* num   : number : number of lines to skip. Default is one.
*********************************************************************
METHOD drgPrint_WINDOWS:printSkip(num)
  DEFAULT num TO 1
* if not in first column then additional linefeed must be specified
  IF ::prCurrCol > 0
    num++
  ENDIF
*
  ::prCurrLine += num
  ::prCurrCol  := 0
  ::tmpRPos    := 0
RETURN self

*********************************************************************
* Skips to next page. Performs form feed.
*********************************************************************
METHOD drgPrint_WINDOWS:PrintPage()
* Call footer method of parent
  IF ::parent != NIL .AND. isMethod(::parent,'printHDRFTR')
    ::parent:printHDRFTR(self, .F.)
  ENDIF
*
  ::prFile:device():newPage()
  ::prIsNewPage:=.T.
RETURN

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
METHOD drgPrint_WINDOWS:print(st, rPos , aLen, code, leftAdjust)

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
    ::printSkip(1)                    // must be done
  ENDIF
* Must not be too long
*  st := LEFT(st, aLen)
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
    CASE code = 0
    CASE code = 1; ::tmpIsBold := .T.
  OTHERWISE
*    CASE code = 2; ::write(::prItal_ON+St+::prItal_OFF)
*    CASE code = 4; ::write(::prULin_ON+St+::prULin_OFF)
*    CASE code = 8; ::write(::prExp_ON +St+::prExp_OFF)
  ENDCASE
  ::setFont()
  ::write(st, rPos, aLen, leftAdjust)
*
  DO CASE
    CASE code = 0
    CASE code = 1; ::tmpIsBold := .F.
  OTHERWISE
*    CASE code = 2; ::write(::prItal_ON+St+::prItal_OFF)
*    CASE code = 4; ::write(::prULin_ON+St+::prULin_OFF)
*    CASE code = 8; ::write(::prExp_ON +St+::prExp_OFF)
  ENDCASE
  ::setFont()
*
  ::prCurrCol := rPos
RETURN

************************************************************************
************************************************************************
*METHOD drgPrint_WINDOWS:convert(st)
*RETURN st

*********************************************************************
* Clean up
*********************************************************************
METHOD drgPrint_WINDOWS:destroy()
LOCAL oDC := ::prFile:device()
* Call footer method of parent
  IF ::parent != NIL .AND. isMethod(::parent,'printHDRFTR')
    ::parent:printHDRFTR(self, .F.)
  ENDIF
*
  oDC:endDoc()
  oDC:destroy()
  ::prFile:configure()
  ::prFile:destroy()
  ::fonts:destroy()

  ::prFile        := ;
  ::fonts         := ;
  ::paperSize     := ;
  ::lastFont      := ;
  ::lastFontName  := ;
  ::defFontCP     := ;
  ::lineHeight    := ;
  ::tmpFontSize   := ;
  ::tmpCharSize   := ;
  ::tmpFontName   := ;
  ::tmpIsBold     := ;
  ::tmpIsItalic   := ;
  ::tmpString     := ;
  ::tmpRPos       := ;
                     NIL

RETURN self

