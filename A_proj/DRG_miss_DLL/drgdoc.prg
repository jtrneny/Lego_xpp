//////////////////////////////////////////////////////////////////////
//
//  \TCGenerate HTML documentation of Application
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgDOC program creates application documentation in a HTML. Program checks
//       for commented lines in the beggining of the program and just prior
//       PROCEDURE and FUNCTION statements and creates a HTML file for each
//       selected PRG. PRGDOC.HHP should than be compiled with HHW.EXE
//
//       This is just a raw preposition and an example of what can be done with HHW.
//       I am open for your further suggestions.
//
//   Remarks:
//       PRGDOC subdirectory should be created prior running the program.
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"

***************************************************************************
* Main program procedure.
*
* \bParameters:b\
* \b< selection >b\ : String : File name selection. Mainly "*.prg"
***************************************************************************
PROCEDURE Main()
LOCAL  dirList, x
PUBLIC CRLF:=CHR(13)+CHR(10)
PUBLIC procList, indexList:={}, tableList := {}
PUBLIC currDir, tableOfContest

  FOR x := 1 TO PCOUNT()
    aParm := PValue(x)
    DO CASE
    CASE  LEFT(PValue(1),1,1) = '@'
*     doMakeFile(selection)
    OTHERWISE
      currDir := CurDir()
      dirList := Directory(aParm)
      AEVAL(dirList, { |x| doOnePRG(x[1]) } )
    ENDCASE
  NEXT
  createHHP()
  createHHC()
  createHHK()
  QUIT
RETURN

***************************************************************************
* Returns just file name without extension
*
* \bParameters:b\
* \b< FileName >b\ : String : Whole file name with extension
*
* \bReturns:b\ : String : Just file name
***************************************************************************
FUNCTION JustFileName(aFileName)
LOCAL x
  x := AT('.',aFileName)
RETURN LEFT(aFileName,--x)

***************************************************************************
* Processes one prg file
*
* \bParameters:b\
* \b< FileName >b\ : String : File name to be processed
***************************************************************************
PROCEDURE doOnePRG(aFileName)
LOCAL F, St,Body, arr, x, prc, comm
PRIVATE currentLine := 0, data:={}
PRIVATE fontArr := ;
        {'<font size="2" color="#404040" face="Arial">', ;
         '<font size="2" color="#108010" face="Arial">', ;
         '<font size="2" color="#0080FF" face="Arial">', ;
         '<font size="2" color="#0080FF" face="Courier">' }

  F:=FOPEN(aFileName)
  WHILE FReadLn(F,@st)
    AADD(data, st)
  ENDDO
  FCLOSE(F)
  aName := justFileName(aFileName)
  F := FCREATE('PRGDOC\' + aName + '.HTM')

  St := '<html>' + CRLF + ;
        '<head>' + CRLF + ;
        '<meta http-equiv="Content-Type"' + CRLF + ;
        'content="text/html">' + CRLF + ;
        '<meta name="GENERATOR" content="drgDOC 1.0.">' + CRLF + ;
        '<title>Program documentation for - ' + aFileName + ' </title>' + CRLF + ;
        '</head>' + CRLF + ;
        '<body>' + CRLF

  FWRITE(F,St)
  FWRITE(F,getHTML('<A HREF="c:\Alaska\drg\drg\'+aFileName+'"> <B>PROGRAM:' + UPPER(aFileName) + '</B></A><hr>', 2) )
/*
  FWRITE(F, CRLF + ;
  '<OBJECT' + CRLF    + ;
  'id=shortcut' + CRLF + ;
  'type="application/x-oleobject"' + CRLF + ;
  'classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11"' + CRLF + ;
  'codebase="hhctrl.ocx#Version=4,72,8252,0"' + CRLF + ;
  'width=100' + CRLF + ;
  'height=100' + CRLF + ;
  '> ' + CRLF + ;
  '<PARAM name="Command" value="ShortCut">' + CRLF + ;
  '<PARAM name="Button" value="Bitmap:shortcut">' + CRLF + ;
  '<PARAM name="Item1" value="notepad,notepad.exe,">' + CRLF + ;
  '<PARAM name="Item2" value="273,1,1">' + CRLF + ;
  '</OBJECT> ' + CRLF)
*/
  lines := LEN(data)
* First get header of the program
  arr   := doHeader()
  FWRITE(F,getHTML(arr, 2)+CRLF)
  body := ''
  procList:={}

  WHILE currentLine < LEN(data)
    st := data[++currentLine]

    IF AT('CLASS', st) > 0
      IF doClass(@prc, @comm)
        body+='<hr><B>' + getHTML(prc, 1) + '</B>'+ CRLF + getHTML(comm, 3)
        LOOP
      ENDIF
    ENDIF

    IF AT('PROCEDURE',st) > 0 .OR. AT('FUNCTION',st) > 0
      IF doProc(@prc, @comm)
        body+='<hr> <B> <A NAME="A' + getAnchor() + '">'   // Naredi anchor
        body+=getHTML(prc, 1) + '</B>'+ CRLF + getHTML(comm, 3)
        AADD(indexList, { prc, getAnchor(), aName, getPrcName(prc) })
      ENDIF
    ENDIF
  ENDDO

  FWRITE(F,getProcTable())
  FWRITE(F,body+'</body></html>')
  AADD(tableList, { aFileName,  tableOfContest })
  FCLOSE(F)
RETURN

***************************************************************************
* Gets comment lines in the begining of the program
*
* \bReturns:b\  : Array of String : comment lines in the begining of the program
***************************************************************************
STATIC FUNCTION doHeader()
LOCAL st, moreLiner := .F., arr:={}, x, x1, x2

  tableOfContest := ''
  WHILE .T.
    st := data[++currentLine]
    IF !moreLiner
      st := LTRIM(st)
    ENDIF

    IF (x := AT('/*', st) ) > 0          // more lines comment
      moreLiner := .T.
      st := SUBSTR(st,x+2,LEN(st))
    ENDIF

    IF !moreLiner
      IF LEFT(st,1) = '*'
        st := RIGHT(st,LEN(st)-1)
      ELSEIF ( LEFT(st,2) = '//' .OR. LEFT(st,2) = '&&' )
        st := RIGHT(st,LEN(st)-2)
      ELSE
        EXIT                           // no more comment
      ENDIF
    ELSE
      IF (x := AT('*/', st) ) > 0
        moreLiner := .F.
        st := LEFT(st,x)
      ENDIF
    ENDIF
    st := removeRest(st)
    IF CurrentLine < 3 .AND. LEN(ALLTRIM(st)) = 0
      LOOP
    ENDIF
* For Table of contest
    IF ( x1 := AT("\TC", st) ) > 0
      IF (x2 := AT("TC\", st) ) = 0
        x2 := LEN(st)
      ENDIF
      tableOfContest := SUBSTR(st, x1+3, x2 - x1 - 2)
      st:=STRTRAN(st,'\TC','',1,1)
      st:=STRTRAN(st,'TC\','',1,1)
    ENDIF
    AADD(arr, st)
  ENDDO
RETURN arr

***************************************************************************
* Gets comment lines before PROCEDURE OR FUNCTION statement
*
* \bParameters:b\
* \b< @prc >b\     : String : Contents of line. Passed by reference.
* \b< @comm >b\    : String : Contents of comment lines. Passed by reference.
*
* \bReturns:b\ : Logical : True if current line is not commented.
***************************************************************************
FUNCTION doProc(prc, comm)
LOCAL st, ch, x
* return if this line is commented
  st := LTRIM(data[currentLine])
  ch := UPPER(LEFT(st,3))
  IF !(ch = 'PRO' .OR. ch = 'FUN' .OR. ch = 'STA')
    RETURN .F.
  ENDIF
  prc := ALLTRIM(st)
  AADD(procList, prc)

  comm := ''
  x := currentLine
  WHILE .T.
* No comment at start
    IF x = 1
      EXIT
    ENDIF
    st := LTRIM(data[--x])

* First blank line before
    IF LEN(st) = 0
      EXIT
    ENDIF

* First RETURN before
    IF LEFT(LTRIM(st),6) = 'RETURN'
      EXIT
    ENDIF
    st := removeRest(st)
* EMPTY commented line just before statement
    IF (x = (currentLine - 1)) .AND. LEN(ALLTRIM(st)) = 0
      LOOP
    ENDIF

*    IF EMPTY(st); st := '</br></br>'
    st:=STRTRAN(st,'\b','<strong>',1,1)
    st:=STRTRAN(st,'b\','</strong>',1,1)
* Don't insert new line if \ is the last char
    IF RIGHT(st,1) = '\'
      comm = LEFT(st,LEN(st)- 1) + ' ' + comm
    ELSE
      comm = st + '</br>' + comm
    ENDIF

  ENDDO
RETURN .T.

***************************************************************************
* Documents class definition. Basicly everything beetwen CLASS and ENDCLASS statement.
* This is very raw. Comments befor METHOD implementations are not yet included.
*
* \bParameters:b\
* \b< @prc >b\  : String : Contents CLASS line. Passed by reference.
* \b< @comm >b\ : String : Contents of CLASS definition. Passed by reference.
*
* \bReturns:b\ Logical : True if current line is not commented.
***************************************************************************
FUNCTION doClass(prc, comm)
LOCAL st, ch
* return if this line is commented
  st := LTRIM(data[currentLine])
  IF LEFT(st,5) != 'CLASS'
    RETURN .F.
  ENDIF
  prc   := RTRIM(st)
  comm  := ''
  x := currentLine
  WHILE .T.
    IF x = LEN(data)
      EXIT
    ENDIF
    st := LTRIM(data[++x])

* First RETURN before
    IF AT('ENDCLASS', st) > 0
      EXIT
    ENDIF
    st   :=STRTRAN(st,'METHOD','<strong>METHOD</strong>',1,1)
    st   :=STRTRAN(st,'VAR','<strong>VAR</strong>',1,1)
    st   := removeRest(st)
    comm +=  st + '</br>'
  ENDDO
  comm := fontArr[3] + comm + '</FONT>'
  currentLine := x
RETURN .T.

************************************************************************
* Removes comment chars from left and right side of comment line
*
* \bParameters:b\
* \b< st >b\       : String : Line to be processed
*
* \bReturns:b\ : String : Cleared line
*************************************************************************
FUNCTION removeRest(St)
LOCAL x, ch
  st := RTRIM(st)
* Left SIDE
  FOR x := 1 TO LEN(st)
    ch := SUBSTR(st,x,1)
    IF !(ch = '*' .OR. ch = '/' .OR. ch = '&')
      EXIT
    ENDIF
  NEXT x
  st := SUBSTR(st, x, LEN(st))

* RIGHT SIDE
  FOR x := LEN(st) TO 1 STEP -1
    ch := SUBSTR(st,x,1)
    IF !(ch = '*' .OR. ch = '/' .OR. ch = '&')
      EXIT
    ENDIF
  NEXT x
  st := LEFT(st,x)
RETURN RTRIM(st)                          // remove also all trailing blanks

***************************************************************************
* Formats passed parameter with HTML tags.
*
* \bParameters:b\
* \b< what >b\ : String : Data passed as String
* \b< what >b\ : Array  : Data passed as Array of Strings
* \b[ font ]b\ : Num    : Font type. Default is 1.
*
* \bReturns:b\ String : Formated string
***************************************************************************
FUNCTION getHTML(what, font)
LOCAL st
  DEFAULT font TO 1
  St :=  fontArr[font]
  IF VALTYPE(what) = 'C'
    St += what //+ '</br>'
  ELSE
    AEVAL(what, {|a| St += a + '</br>'})
  ENDIF
  St += '</font>'
RETURN st

PROCEDURE writeHeader()
RETURN

***************************************************************************
* Creates prgdoc.HHP file
*
* \bParameters:b\
* \b< dirList >b\ : String : Data passed as String
***************************************************************************
PROCEDURE createHHP(dirList)
LOCAL st, F
  F := FCREATE('PRGDOC\prgdoc.HHP')
  st := '[OPTIONS]' + CRLF + ;
        'Compatibility=1.1 or later' + CRLF + ;
        'Compiled file=prgdoc.chm'  + CRLF + ;
        'Contents file=prgdoc.hhc' + CRLF + ;
        'Default topic=prgdoc.htm' + CRLF + ;
        'Display compile progress=No' + CRLF + ;
        'Index file=prgdoc.hhk' + CRLF + ;  //        Language=0x424 Slovenian
        'Title=Dokumentacija programa' + CRLF + CRLF
  FWRITE(F,st)
  st := '[FILES]' + CRLF
  AEVAL(tableList, { |aFile| st+=justFileName(aFile[1]) + '.htm' + CRLF } )

  st += CRLF + '[INFOTYPES]' + CRLF
  FWRITE(F,st)
  FCLOSE(F)
RETURN

***************************************************************************
* Creates prgdoc.HHC file
***************************************************************************
PROCEDURE createHHC()
LOCAL st, F
  F := FCREATE('PRGDOC\prgdoc.HHC')
  St := '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' + CRLF + ;
        '<HTML>' + CRLF + ;
        '<HEAD>' + CRLF + ;
        '<meta name="GENERATOR" content="DRGS&reg; drgDOC 1.0">' + CRLF + ;
        '<!-- Sitemap 1.0 -->' + CRLF + ;
        '</HEAD><BODY>' + CRLF + ;
        '<OBJECT type="text/site properties">' + CRLF + ;
      	'<param name="Window Styles" value="0x800025">' + CRLF + ;
        '</OBJECT>' + CRLF
  FWRITE(F,St)

  St := '<UL>' + CRLF + ;
        '<LI> <OBJECT type="text/sitemap">' + CRLF + ;
        '<param name="Name" value="Programi">' + CRLF + ;
        '<param name="Local" value="prgDoc.htm">' + CRLF + ;
        '</OBJECT>' + CRLF
  FWRITE(F, st)

  st := '<UL>' + CRLF
  AEVAL(tableList, { |aTable| st+= ;
        '<LI><OBJECT type="text/sitemap">' + CRLF + ;
        '<param name="Name" value="' + UPPER(aTable[1]) + ' ' + aTable[2] + '">' + CRLF + ;
        '<param name="Local" value="' + justFileName(aTable[1]) + '.htm' + '">' + CRLF + ;
        '</OBJECT>' + CRLF } )
  FWRITE(F, st)

  st := '</UL>' + CRLF + ;
        '</UL>' + CRLF + ;
        '</BODY></HTML>' + CRLF
  FWRITE(F, st)
  FCLOSE(F)
RETURN

***************************************************************************
* Creates prgdoc.HHK (index) file
***************************************************************************
PROCEDURE createHHK()
LOCAL st, F, x
  F := FCREATE('PRGDOC\prgdoc.HHK')
  St := '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' + CRLF + ;
        '<HTML>' + CRLF + ;
        '<HEAD>' + CRLF + ;
        '<meta name="GENERATOR" content="Damjan Rems&reg; drgDOC 1.0">' + CRLF + ;
        '<!-- Sitemap 1.0 -->' + CRLF + ;
        '</HEAD><BODY><UL>' + CRLF
  FWRITE(F,St)
/*
  St := '<UL>' + CRLF + ;
        '<LI> <OBJECT type="text/sitemap">' + CRLF + ;
        '<param name="Name" value="Programi">' + CRLF + ;
        '<param name="Local" value="prgDoc.htm">' + CRLF + ;
        '</OBJECT>' + CRLF
  FWRITE(F, st)
*/
  ASORT(indexList,,, {|aX,aY| aX[4] < aY[4] } )

  lastProc := 'X'
  st := ''
  FOR x := 1 TO LEN(indexList)
    aProc := indexList[x]
    IF aProc[4] != lastProc
      FWRITE(F,St)
      st := '<LI> <OBJECT type="text/sitemap">' + ;
            '<param name="Name" value="' + getPrcName(aProc[1]) + '">' + ;
            '<param name="Local" value="prgDoc.htm">' +  ;
            '</OBJECT> <UL>' + CRLF
      IF x > 1
        st := '</UL>' + st
      ENDIF
      lastProc := aProc[4]
    ENDIF
    st += '<LI> <OBJECT type="text/sitemap">' + ;
          '<param name="Name" value="' + getDefName(aProc[1]) + ;
          ' in ' + aProc[3] + '">' + ;
          '<param name="Local" value="' + aProc[3] + '.htm#A' + aProc[2] + '">' + ;
          '</OBJECT>' + CRLF
  NEXT x
  FWRITE(F,St)

  st := '</UL>' + CRLF + ;
        '</UL>' + CRLF + ;
        '</BODY></HTML>' + CRLF
  FWRITE(F, st)
  FCLOSE(F)
RETURN

*************************************************************************************
FUNCTION getProcTable()
LOCAL st := '', x ,item
  st += '<font size="1" color=BLACK face="Arial">'
  st += '<TABLE COLS=3 BORDER=1 FRAME=BORDER CELLPADDING="4" CELLSPACING="0" BORDERCOLOR=#808080> ' +CRLF
  st += '<THEAD align=left bgcolor=LIGHTSKYBLUE> ' +;
        ' <TR> <TH>Visible</TH><TH>Type</TH><TH>Contents</TH> </TR> <TBODY>'+CRLF

  FOR x := 1 TO LEN(procList)
    item := ALLTRIM(procList[x])

    i := AT(' ', item)
    aStat := UPPER(LEFT(item, i))
    IF aStat = 'STATIC'
      item := ALLTRIM(SUBSTR(item, i, LEN(item) ) )
    ELSE
      aStat := ''
    ENDIF
    st += '<TR><TD><B>' + aStat + '</B></TD>'

    i := AT(' ', item)
    aStat := UPPER(LEFT(item, i))
    item  := ALLTRIM(SUBSTR(item, i, LEN(item) ) )
    st += '<TD><B>' + aStat + '</B></TD>'
    st += '<TD><A HREF="#A' + getAnchor(x) + '">' + item + '</A> </TD></TR>'+CRLF
  NEXT
  st += '</TABLE> </FONT> '
RETURN st

************************************************************************
* Returns TAG name inside the PRG file. IF parameter x is passed then \
* anchor number is trimmed value of its value else anchor number is current \
* length of procList array.
*
* \bParameters:b\
* \b[ x ]b\       : Number : Number of procedure (function) statement.
*
* \bReturns:b\    : String : Trimmed value of anchor as string.
************************************************************************
STATIC FUNCTION getAnchor(x)
LOCAL st
  IF x = NIL
    st := STR(LEN(procList))
  ELSE
    st := STR(x)
  ENDIF
RETURN ALLTRIM(st)

************************************************************************
* Returns just procedure name. Without PROCEDURE, FUNCTION and STATIC statement.
*
* \bParameters:b\
* \b< fullLine >b\   : String : Full PROCEDURE or FUNCTION declaration
*
* \bReturns:b\       : String : Just name.
************************************************************************
STATIC FUNCTION getPrcName(fullLine)
LOCAL st, x
  IF (x := AT('(', fullLine) ) = 0                 // position of (
    x := LEN(fullLine) + 1
  ENDIF
  fullLine := ALLTRIM(LEFT(fullLine, --x))         // LEFT part is interesting
  IF (x := RAT(' ', fullLine) ) = 0                // position of ' '
    x := LEN(fullLine)
  ENDIF
  st := SUBSTR(fullLine, x, LEN(fullLine) )        // this should be just the name
RETURN UPPER(ALLTRIM(st))

************************************************************************
* Returns just procedure definition (STATIC) PROCEDURE or FUNCTION
*
* \bParameters:b\
* \b< fullLine >b\   : String : Full PROCEDURE or FUNCTION declaration
*
* \bReturns:b\       : String : Just definition.
************************************************************************
STATIC FUNCTION getDefName(fullLine)
LOCAL st, x
  IF (x := AT('(', fullLine) ) = 0                   // position of (
    x := LEN(fullLine)
  ENDIF
  fullLine := ALLTRIM(LEFT(fullLine, x))           // LEFT part is interesting
  IF (x := RAT(' ', fullLine) ) = 0                // position of ' '
    x := LEN(fullLine)
  ENDIF
  st := ALLTRIM(LEFT(fullLine, x))           // LEFT part is interesting
RETURN st


************************************************************************
* Reads one line from txt file. I don't understand why this has never been \
* implemented neither in Clipper or Alaska. It should have been faster in \
* native language.
*
* \bParameters:b\
* \b< FHandle >b\   : File    : File handle
* \b< @Rec >b\      : String  : Next line from file. Passed by reference.
*
* \bReturns:b\    : Logical : True if .NOT. yet EOF
************************************************************************
FUNCTION FReadLn(FHandle,Rec)
LOCAL Buf:=SPACE(128)
LOCAL BytesRead,X

  Rec := ''
  BytesRead:=FREAD(FHandle,@Buf,128)
  IF BytesRead < 2
    IF BytesRead = 0
      RETURN .F.
    ELSE
      IF LEFT(Buf,1) = CHR(26)
        RETURN .F.
      ENDIF
    ENDIF
  ENDIF

  WHILE BytesRead > 0
    X:=AT(CHR(13),Buf)
    IF X = 0
      Rec+=Buf
    ELSE
      Rec+=LEFT(Buf, X - 1)
      FSEEK(FHandle,(0 - BytesRead) + X + 1, 1)
      RETURN .T.
    ENDIF
    BytesRead:=FREAD(FHandle,@Buf,128)
  ENDDO
RETURN .T.

