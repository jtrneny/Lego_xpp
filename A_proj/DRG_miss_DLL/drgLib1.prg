//////////////////////////////////////////////////////////////////////
//
//  \TCDRGLib utilities that are always needed
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//      Library of common used functions and procedures.
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Directry.ch"
#include "Fileio.ch"
#include "Xbp.ch"
#include "Drg.ch"


#pragma Library( "ADAC20B.LIB" )
#pragma Library( "XppRt1.LIB" )



*******************************************************************
* Returns value for the specified keyword.
*
* \bParameters:b\
* < cKeyWord > : charachter : keyword to search
* < cLine >    : charachter : data line to search in
* < nType >    : numeric : type of data to return. Possible values are:
* 0 = charachter (default)
* 1 = numeric
* 2 = two dimensional numeric array
*******************************************************************
FUNCTION drgGetParm(cKeyWord, cLine, nType)
LOCAL i, ar, x, n
LOCAL nCount := 0, nStart
  DEFAULT nType TO 0

* IF KEYWORD EXIST
  IF (n := AT(cKeyWord+'(', cLine )) = 0
    RETURN NIL
  ENDIF
*
  nStart := n + LEN(cKeyWord) + 1
  FOR n := nStart TO LEN(cLine)
    IF cLine[n] = '('
* another open bracket found. Count brackets to skip.
      nCount++
    ENDIF
* close bracket.
    IF cLine[n] = ')'
      IF nCount = 0
        EXIT
      ELSE
        nCount--
      ENDIF
    ENDIF
  NEXT
  cLine := SUBSTR(cLine,nStart,n - nStart)
*
  DO CASE
    CASE nType = 0                      // Character
      IF LEFT(cLine,1) = '"' .OR. LEFT(cLine,1) = "'"
        RETURN SUBSTR(cLine,2,LEN(cLine)-2)
      ELSE
        RETURN cLine
      ENDIF
    CASE nType = 1                      // Numeric
      RETURN VAL(cLine)
    CASE nType = 2                      // 2D Numeric array
      ar:={0,0}
      x:=AT(",",cLine)
      ar[1]:=VAL(LTRIM(LEFT(cLine,x-1) ))
      ar[2]:=VAL(LTRIM(SUBSTR(cLine,x+1,10) ))
      RETURN ar
  ENDCASE

RETURN cLine

**************************************************************************
* Dumps variable tu DUMP.TXT file. This is usefull until I find out how to
* replace ? command in PM mode.
**************************************************************************
PROCEDURE drgDump(xWhat,cDesc)
LOCAL F,tip,st,dumpName:='DUMP.TXT'
  st  := IIF(cDesc = NIL, '', cDesc + "=")
  tip := VALTYPE(xWhat)
  IF xWhat = NIL
    st += "NIL"
  ELSE
    DO CASE
      CASE tip = 'C'
        st += '"'+xWhat+'"'
      CASE tip = 'D'
        st += DTOC(xWhat)
      CASE tip = 'L'
        st += IIF(xWhat,'.T.','.F.')
      CASE tip = 'N'
        st += STR(xWhat,15,3)
      CASE tip = 'U'
        st += 'unknown'
      CASE tip = 'A'
        AEVAL(xWhat, { |v| drgDump(v) } )
      CASE tip = 'O'
        st += ' className=' +  xWhat:className()
      OTHERWISE
        st += 'Type ' + tip + ' not available.'
    ENDCASE
  ENDIF
  F := IIF(FILE(dumpName), FOPEN(dumpName,2), FCREATE(dumpName) )

  FSEEK(F,0,2)
  FWRITE(F,st+CHR(10))
  FCLOSE(F)
RETURN

**************************************************************************
* Returns current procedure call stack as string. Used for determining of program position.
**************************************************************************
FUNCTION drgDumpCallStack()
LOCAL i, c := ''
  i := 1
  WHILE !EMPTY( ProcName(++i) )
    c += "Called from " + Trim( ProcName(i) )   + "(" + ;
                            LTrim( Str( ProcLine(i) ) ) + ")" + CRLF
  ENDDO
RETURN c

**************************************************************************
* Returns value as characther with the picture set. If picture is not set \
* default @N is used for numeric and @D is used for date value.
**************************************************************************
FUNCTION drg2String(xValue, cPic)
LOCAL tip, value
  IF xValue = NIL                           // For safety reasons
    RETURN 'NIL'
  ENDIF
*

  tip = VALTYPE(xValue)
  IF tip = 'B'                            // evaluate if  type codeblock
    value := EVAL(xValue)
    tip   := VALTYPE(value)
  ELSE
    value := xValue
  ENDIF

  IF tip = 'C' .or. tip = 'M' // ADT .or. tip = 'U'
    RETURN value
  ENDIF

  IF tip = 'D' .AND. cPic = NIL
    cPic := '@D'
  ENDIF

  IF tip = 'N' .AND. cPic = NIL
    cPic := '@N'                           // support national specific formats
  ENDIF
  *
  IF tip = 'L' .AND. cPic = NIL
    cPic := 'L'
  ENDIF
RETURN TRANSFORM(value, cPic)

**************************************************************************
* Returns subCharacter. Differs from SUBSTR in a way that returns Character beetween
* start and end position.
**************************************************************************
FUNCTION drgSubSTR(c, nStart, nEnd)
RETURN SUBSTR(c, nStart, ++nEnd - nStart)

**************************************************************************
* DRG parser. Returns subCharacter from begining up to charachter specified by \
* parse char. If parameter inputCharacter is passed by reference token is also deleted from
* passed parameter. This way entierly Character can be parsed.
*
* \bParameters:b\
* \b< @c >b\        : character : Character Character to be parsed. If passed by \
* reference parsed part will be stripped from the begining of Character.
* \b[ cParseChar ]b\ : character : Char which is used as token delimiter. \
* Default value is comma ','.
*
* \bReturn:b\      : cParsed
*
* \bExample:b\
* st := 'one:two:three'
* WHILE !EMPTY( token := drgParse(@st,':') )
*   ? token
* ENDDO
*
* would result in
*
* 'one'
* 'two'
* 'three'
**************************************************************************
FUNCTION drgParse(st, parseChar)
LOCAL parsed,x
  DEFAULT parseChar TO ","
* RETURN NIL if no parameter
  IF St = NIL; RETURN NIL; ENDIF

  IF LEN(St) = 0; RETURN ''; ENDIF

  IF (x := AT(parseChar, st )) = 0
    IF LEN(st) > 0
      parsed := st
      st     := ""
      RETURN parsed
    ELSE
      RETURN NIL
    ENDIF
  ENDIF
  parsed := LEFT(st, x-1)
  st     := RIGHT(st, LEN(st) - x)
RETURN parsed

**************************************************************************
* Parse second is used when Character parameter has only two tokens and original \
* value of passed parameter must remain unchanged.
*
* \bParameters:b\
* \b< c >b\         : character  : Character to be parsed.
* \b[ cParseChar ]b\   : character  : Char which is used as delimiter beetwen tokens. \
* Default value is comma.
*
* \bReturn:b\      : Character  : Second token in passed parameter.
*
* \bExample:b\
* st := "FILE->FIELD"
* ? drgParse(st,'-')
* ? drgParseSecond(st,'>')
*
* would result in
* FILE
* FIELD
**************************************************************************
FUNCTION drgParseSecond(c, cParseChar)
LOCAL parsed
  parsed := c
  drgParse(@parsed, cParseChar)
RETURN parsed

**************************************************************************
* Does what is says. Nothing.
**************************************************************************
PROCEDURE drgNothing()
RETURN

**************************************************************************
* Generic code block for variable passed by reference
**************************************************************************
FUNCTION drgVarBlock( xVal )
RETURN { |x| IF( PCOUNT()==1, xVal := x, xVal ) }

**************************************************************************
* Resets all field values in array
**************************************************************************
PROCEDURE drgClearData(data)
LOCAL x, tip
  FOR x := 1 TO LEN(data)
    tip := VALTYPE(data[x])
    IF data[x] != NIL
      DO CASE
        CASE tip = 'C'
          data[x]:=Replicate(' ',LEN(data[x]))
        CASE tip = 'D'
          data[x]:=CTOD('')
        CASE tip = 'L'
          data[x]:=.F.
        CASE tip = 'N'
          data[x]:=0
        OTHERWISE
          data[x]:=NIL
      ENDCASE
    ENDIF
  NEXT
RETURN

*********************************************************************
* The function deletes current record.
*
* \b<Return>b\  : boolean : true if record was succesfuly deleted
*********************************************************************
FUNCTION drgDeleteRecord()
  IF drgLockOK()
    DBDELETE()
    RETURN .T.
  ENDIF
RETURN .F.

*********************************************************************
* DRG replacement for MSGBOX. Procedure remembers last oXbp in focus and \
* posts focus back to it when message windows is closed.
*
* \bParameters:b\
* \b< cMsg >b\         : character : Message to display
* \b< nIcoType >b\     : numeric   : Icon type to display acording to XBPMB_* defines in XBP.CH
*********************************************************************
PROCEDURE drgMsgBox(cMsg, nIcoType)
LOCAL oXbp := SetAppFocus()                // save last object in focus
LOCAL cTitle
  DEFAULT nIcoType TO XBPMB_WARNING
* Set default window title for message type
  DO CASE
  CASE nIcoType = XBPMB_WARNING
    cTitle := drgNLS:msg("Warning!")
    Tone(500,3)
  CASE nIcoType = XBPMB_CRITICAL
    cTitle := drgNLS:msg("Error!")
    Tone(150,3)
  OTHERWISE
    cTitle := drgNLS:msg("Message!")
    Tone(500,3)
  ENDCASE

  cMsg := STRTRAN(cMsg,';',CRLF)
  ConfirmBox( , cMsg , cTitle, ;
              XBPMB_OK , ;
              nIcoType + XBPMB_APPMODAL + XBPMB_MOVEABLE )
* Set focus back to last object in focus
  SetAppFocus(oXbp)
RETURN

*********************************************************************
* Function posts drgEVENT_MSG to passed dialog parameter which results in displaying \
* message on the message line of dialog window.
*
* \bParameters:b\
* \b< msg >b\         : Character  : Message to post
* \b< msgType >b\     : Numeric : Message type acording to DRG_MSG_* defines in DRG.CH. \
* Default value is DRG_MSG_ERROR.
* \b< oXbp >b\        : object of type xbpXXX : Any object within drgDialog.
*********************************************************************
PROCEDURE drgMsg(cMsg, nMsgType, oXbp)
LOCAL recipient
  DEFAULT nMsgType TO DRG_MSG_ERROR

  IF oXbp:isDerivedFrom( "DrgDialog" )
    recipient := oXbp:dialog
  ELSEIF oXbp:isDerivedFrom( "DrgUsrClass" )
    recipient := oXbp:drgDialog:dialog
  ELSE
    recipient := oXbp
  ENDIF

  PostAppEvent(drgEVENT_MSG, cMsg, nMsgType, recipient )
RETURN

*********************************************************************
* Creates ConfirmBox dialog on the screen and user is prompted to choose \
* beetwen YES or NO. User is also warned with a beep.
*
* \bParameters:b\
* \b < cMsg > b\   : Charachter :  Message to be displayed
* \b [ nButtons ] b\   : NUmeric :  can be used to specify an optional constant \
* from those defined in the XBP.CH file. These constants begin with XBPMB_ and \
* specify the number of pushbuttons displayed as selections and their captions. \
* Default value is XBPMB_YESNO.
*
* \bReturns: b\ : Logical : True if Yes was selected.
*********************************************************************
FUNCTION drgIsYESNO(cMsg, nButtons, nIcoType)
LOCAL nButton
LOCAL oXbp := SetAppFocus()
  DEFAULT cMsg TO drgNLS:msg("Choose option!")
  DEFAULT nButtons TO XBPMB_YESNO
  DEFAULT nIcoType TO XBPMB_QUESTION

  Tone(500,3)
  cMsg    := STRTRAN(cMsg,';',CRLF)
  nButton := ConfirmBox( , cMsg , drgNLS:msg("Choose option!"), ;
                        nButtons , ;
                        nIcoType + XBPMB_APPMODAL + XBPMB_MOVEABLE )

  SetAppFocus(oXbp)
RETURN nButton == XBPMB_RET_YES

*********************************************************************
* Returns part of file name depending on parameter.
*
* \bParameters:b\
* \b < cName > b\   : character :  Full file name
* \b < nType > b\   : numeric   : The part of file name which is to be returned.
* 1 = Only filename
* 2 = Only estension
* 3 = Only Directory name
* 4 = Filename with extension
* 5 = Filename with directory name. Without extension.
*
* \bReturns: b\ : character : cFileNamePart
*********************************************************************
FUNCTION parseFileName(cName, nType)
  LOCAL x1,x2
  *
  local  csubName

  DEFAULT nType TO 1

  cName := STRTRAN(cName,'/','\')
  DO CASE
    CASE nType = 1                   // Just file cName
      x1       := rat( '\', cName ) +1
      csubName := subStr( cName, x1 )

      x2       := at( '.', csubName )
      x2       := if( x2 = 0, len( csubName ), x2 -1 )
      return subStr( csubName, 1, x2 )

/*
      x1 := RAT('\',cName) + 1
      IF ( x2 := AT('.',cName) ) = 0
        x2 := LEN(cName) + 1
      ENDIF
      RETURN SUBSTR(cName, x1, x2 - x1)
*/


    CASE nType = 2                   // Just Extension
      IF (x1 := RAT('.',cName) ) = 0
        RETURN ''
      ENDIF
      RETURN RIGHT(cName, LEN(cName) - x1)

    CASE nType = 3                   // Just directory cName
* Dir only passed
      IF ( x1 := RAT('.',cName) ) = 0
        RETURN cName
      ENDIF
* File name only. Return empty
      IF ( x1 := RAT('\',cName) ) = 0
        RETURN ''
      ENDIF
*
      RETURN LEFT(cName,--x1)

    CASE nType = 4                   // Filename with exstension
      x1 := RAT('\',cName) + 1
      x2 := LEN(cName) + 1
      RETURN SUBSTR(cName, x1, x2 - x1)

    CASE nType = 5                   // Filename with directory. No extension.
      IF (x1 := RAT('.',cName) ) = 0
        RETURN cName
      ENDIF
      RETURN LEFT( cName, --x1 )

  ENDCASE
RETURN NIL

***********************************************************************
* Checks if directory name contatins trailing backslash character.

* \bParameters:b\
* \b< cDir >b\   : character :  Directory name
*
* \bReturns: b\ : character : Directory name with trailing backslash ensured
*********************************************************************
FUNCTION drgChkDirName(cDir)
  cDIR := RTRIM(cDir)
  cDir := cDir + IIF( RIGHT(cDir,1) $ '/\', '', '\')
RETURN cDir

***********************************************************************
* Reads and returns one section of description file
***********************************************************************
FUNCTION _drgGetSection(mF, mData, nType, lEmpty)
LOCAL st, line, mRsrc, x, cData
LOCAL cType, cName, aLog, i
  DEFAULT lEmpty TO .F.
* On first call
  IF nType = NIL
    mF := 1
    IF ValType(mData) = 'A'
      nType := 0
      mF    := 0
    ELSEIF AT('.', mData) > 0
      cData := mData
      cType := ParseFileName(mData,2)     // Extension
      cName := ParseFileName(mData,1)     // name
* Load resource if exist otherwise open file
      IF ( mData := LoadResource(cName,,cType) ) = NIL
        IF FILE(cData)
          mData := MemoRead(cData)
        ELSE
          mData := ''
        ENDIF
*        mF := FOPEN(cData, 64)
        nType := 2
      ELSE
        nType := 2
      ENDIF
    ELSE
      mData := LoadResource(mData,,'DRG')
      nType := 2
    ENDIF
  ENDIF

*
  line := ""
  WHILE .T.
    DO CASE
* RESOURCE
    CASE nType = 2
      IF ( x := AT(CHR(13), mData, mF) ) > 0
        st := SUBSTR(mData, mF, x - mF )
        mF := x + 2
      ELSEIF EMPTY(line)
        RETURN NIL
      ELSE
        RETURN line
      ENDIF
* ARRAY
    CASE nType = 0
      IF ++mF > LEN(mData)               // next element of array
        EXIT
      ENDIF
      st := mData[mF]
* FILE. Not used anymore
    CASE nType = 1
      IF !fReadLn(mF,@st)               // read from file
        EXIT
      ENDIF

    ENDCASE
* If empty allowed then return
    IF lEmpty .AND. LEN(RTRIM(st)) < 5 .AND. LEFT(st,1) != '*'
      RETURN st
    ENDIF
* Ignore if comment or smaller then 5
    st := RTRIM(st)
    IF LEN(st) < 5 .OR. LEFT(st,1) = "*"
      LOOP
    ENDIF
* IF plus sign, remove it and continue
    IF RIGHT(st,1) $ "+;"
      line += LEFT(st, LEN(st) - 1)
      LOOP
    ELSE
      line += st
    ENDIF
    RETURN line
  ENDDO
* IF we are here, there is nothing more. Close file
  IF nType = 1
    FCLOSE(mF)
  ENDIF
  mF := NIL
RETURN NIL

***********************************************************************
* Dummy calls about dialog.
***********************************************************************
PROCEDURE _drgCallAboutDialog(pDialog)
  LOCAL c := 'drgCallAboutDialog', odialog, nexit

  do case
  case isFunction(c)
    c := '{ |a| drgCallAboutDialog(a) }'
    EVAL(&c, oDialog)

  otherwise
    DRGDIALOG FORM drgIni:stdDialogAbout PARENT pDialog MODAL DESTROY
  endcase

/*
  IF ISFUNCTION(c)
    c := '{ |a| drgCallAboutDialog(a) }'
    EVAL(&c, oDialog)
  ELSE
    drgMsgBox('About dialog.')
  ENDIF
*/
RETURN

************************************************************************
* Reads single line from text file. Returns true until lines can be read.
* When EOF() is reached false is returned.
* \bParameters:b\
* \b< FHandle >b\     : Numeric   : File handle returned by FOPEN()
* \b< @cRec >b\       : Character : Character string returned
*
* \bReturns:>b\       : Logical : True if line could be read from text file
************************************************************************
FUNCTION FReadLn(FHandle,cRec)
LOCAL Buf:=SPACE(128)
LOCAL BytesRead,X

  cRec := ''
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
      cRec+=Buf
    ELSE
      cRec+=LEFT(Buf, X - 1)
      FSEEK(FHandle,(0 - BytesRead) + X + 1, 1)
      RETURN .T.
    ENDIF
    BytesRead:=FREAD(FHandle,@Buf,128)
  ENDDO
RETURN .T.

*************************************************************************
* DRG implementation of Scatter function.
*
* \bReturns:>b\   : Array : Array filed with values from database file
***************************************************************************
FUNCTION drgScatter()
LOCAL data  :=  ARRAY(FCOUNT())
RETURN AEVAL(data,{ |ele,num| data[Num] := FIELDGET(Num)})

***************************************************************************
* DRG implementation of Gather function. Does the oposite of drgScatter, updates
* values of fields in database with values from array.
***************************************************************************
PROCEDURE drgGather(arr)
  AEVAL(arr,{ |ele,num| FIELDPUT(num,ele) })
RETURN

***************************************************************************
* Update all fields from file "cDest" with the fields with same name from file \
* "cSource".
***************************************************************************
PROCEDURE drgCopyRecord(cSource, cDest)
LOCAL sData, dData, x, pos, name
LOCAL oldSelect := ALIAS()
  DEFAULT cSource TO oldSelect
  DEFAULT cDest   TO oldSelect

  SELECT(cSource)
  sData := drgScatter()

  SELECT(cDest)
  dData := drgScatter()

  FOR x := 1 TO LEN(sData)
    SELECT(cSource)
    name := FIELDNAME(x)                    // Name of field on x-th position

    SELECT(cDest)
    IF (pos := FIELDPOS(name) ) > 0         // position in destination
      dData[pos] := sData[x]                // excahange values of data array
    ENDIF
  NEXT x

*  IF drgLockOK()                            // update
    drgGather(dData)
*    DBUNLOCK()
*  ENDIF
  SELECT(OldSelect)
RETURN

**************************************************************************
* Tries to lock record and returns true if lock was succesfull.
* If the lock was not succesfull function informs user and user is
* prompted to answer what to do. If Cancle is selected false is returned.
**************************************************************************
FUNCTION  drgLockOK()
LOCAL nButton, msg
  WHILE !RLOCK()
    msg := drgNLS:msg('Record has been locked by other user.' + ;
                     'Choose "Retry" to retry update of record!;' + ;
                     'If you choose "Cancel" your data might become unstable!;' + ;
                     'In this case you should probably contact program supplier!;' )
    msg     := STRTRAN(msg,';',CRLF)
    nButton := ConfirmBox( , msg , drgNLS:msg("Warning!"), ;
                           XBPMB_RETRYCANCEL , ;
                           XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    IF nButton = XBPMB_CANCEL
      msg := drgNLS:msg('You have choosed "Cancel". Is this OK?')
      IF ConfirmBox( , msg , drgNLS:msg("Warning!"), ;
                     XBPMB_YESNO , ;
                     XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE ) = XBPMB_RET_YES
        RETURN .F.
      ENDIF
    ENDIF
/*
    IF ++x > 3
      EXIT
    ENDIF
*/
  ENDDO
RETURN .T.

**************************************************************************
* This dummy function does nothing but returns true. It is often used
* inside drg objects where default operation is required.
*
* <Returns:>  : Logical : always True
**************************************************************************
FUNCTION drgAlwaysTrue()
RETURN .T.

**************************************************************************
* This dummy function does nothing but returns false. It is often used
* inside drg objects where default operation is required.
*
* <Returns:>  : Logical : always False
**************************************************************************
FUNCTION drgAlwaysFalse()
RETURN .F.

***************************************************************************
* Checks parameter for appereance of keyword and returns boolean value if
* keyword parameter value is found in true values.
* \bParameters:b\
* \b<aParm>b\         : Character  : Parameter value
* \b<aKeyword>b\      : Character  : Keyword name to search
* \b[trueValues]b\    : Character  : Holding definition values valid for true. Values are \
* separated by comma sign. \b Default is '1,Y' b\ .
* \b[defaultValue]b\  : Logical : Default value to return when keyword is not found. \b Default is .T. b\.
* \b[delimiter]b\     : Character  : Default keyword delimiter. \b Default is ':' b\ .
*
* \bReturns:>b\       : Logical : True if keyword value meets true condition
***************************************************************************
FUNCTION drgIsParamTrue(aParm, aKeyword, trueValues, defaultValue, delimiter)
LOCAL x, st, prm
  DEFAULT trueValues    TO '1,Y'
  DEFAULT defaultValue  TO .T.
  DEFAULT delimiter     TO ':'
* parameter might be NIL
  IF VALTYPE(aParm) != 'C'
    RETURN defaultValue
  ENDIF
  aParm     := LOWER(aParm)
  aKeyword  := LOWER(aKeyword)

* keyword not found. Return default value.
  IF ( x := AT(aKeyword+delimiter,aParm) ) = 0
    RETURN defaultValue
  ENDIF
* strip value from parameter
  prm := SUBSTR(aParm,x,LEN(aParm) )                // rest of Character
  prm := drgParse(prm,',')                          // parse parameter
  prm := UPPER(ALLTRIM(drgParseSecond(prm,':')))    // get parameter
* check if parameter is in truValues
  WHILE LEN( st := drgParse(@trueValues,',') ) > 0
    IF st == LEFT(prm, LEN(st) )
      RETURN .T.
    ENDIF
  ENDDO
RETURN .F.

***************************************************************************
* Used for saving form definitions to file. Function checks if parameter
* is specifield ( !NIL or '') and creates a keyword for saving to file.
*
* \bParameters:b\
* \b<aParm>b\     : anyType : Keyword value
* \b<aKeyword>b\  : Character  : Keyword name
*
* \bReturns:> b\    : Character  : Full keyword with value specified or ''
***************************************************************************
FUNCTION drgGetKeyword(aParm, aKeyword)
LOCAL aVal
  IF aParm = NIL
    RETURN ''
  ENDIF

  DO CASE
  CASE VALTYPE(aParm) = 'C'
    aVal := RTRIM(aParm)
  CASE VALTYPE(aParm) = 'N'
    aVal := ALLTRIM(STR(aParm))
  ENDCASE

  IF EMPTY(aVal)
    RETURN ''
  ENDIF

RETURN aKeyWord + '(' + aVal + ') '

***************************************************************************
* Compares two arrays and returns true if there are differences beetwen them.
* Usefull for comparing if data has been changed when on edit dialog.
*
* \bParameters:b\
* \b< ar1 >b\  : Array : First array
* \b< ar2 >b\  : Array : Second array
*
* \bReturns:b\  : lDifferent : True if arrays are different
***************************************************************************
FUNCTION drgArrayDif(ar1, ar2)
LOCAL x
  FOR x = 1 TO LEN(ar1)
    IF !(ar1[x] == ar2[x])
      RETURN .T.
    ENDIF
  NEXT
RETURN .F.

***************************************************************************
* Sets array fields lenghts to lenghts specified by second parameter.
* XbpGet takes as much charachters as it's initial length is. This procedure
* adds blanks to the end of each array parameter so the length of array element
* would be as specified with second parameter. Second parameter is array defining
* length of individual index field in array.
*
* \bParameters:b\
* \b<@ar>b\  : Array : Array to change length. Passed as reference.
* \b<arl>b\  : Array : Array defining lengths of each index in first array {10,12,...,5}
***************************************************************************
PROCEDURE _drgSetArrLength(ar,arl)
LOCAL x, i
  FOR x := 1 TO LEN(arl)
    IF arl[x] != NIL
      IF ar[x] = NIL
        ar[x] := ''
      ENDIF
*
      IF VALTYPE(ar[x]) = 'C'
        IF ( i := LEN(ar[x]) ) < arl[x]
          ar[x] += SPACE(arl[x]-i)
        ENDIF
      ENDIF
    ENDIF
  NEXT
RETURN

***************************************************************************
* Duplicates (copies) cSource file to destination file. Replace for OS COPY command.
*
* \bParameters:b\
* \b<cSource>b\  : charachter : Source file name
* \b<cDest>b\    : charachter : Destination file name
***************************************************************************
FUNCTION drgDupFile(cSource, cDest)
LOCAL aSrc, aDest
LOCAL FI, FO, c, nRead

  cSource := STRTRAN(cSource,'/','\')
  cDest   := STRTRAN(cDest,'/','\')

* Detect if cSource file exist
  IF !FILE(cSource)
    RETURN .F.
  ENDIF

* Delete destination file if exists
  IF FILE(cDest)
    FERASE(cDest)
  ENDIF

* Perform COPY
  FI := FOPEN(cSource, FO_READ )
  FO := FCREATE(cDest, FC_NORMAL)
  c := SPACE(4096)
  WHILE ( nRead := FREAD(FI, @c, 4096) ) > 0
    FWRITE(FO, c, nRead)
  ENDDO
  FCLOSE(FO); FCLOSE(FI)
*
  aSrc := DIRECTORY(cSource)
  aDest := DIRECTORY(cDest)
  IF LEN(aSrc) != LEN(aDest) .OR. ;
     aSrc[1, F_SIZE] != aDest[1, F_SIZE]  //.OR. ;
*     ( aSrc[1, F_WRITE_TIME] != aDest[1, F_WRITE_TIME] )
      FERASE(cDest)
    RETURN .F.
  ENDIF

RETURN .T.

***************************************************************************
* Renames cSource file to destination file. Original FRENAME function doesn't \
* rename file if destination file already exists.
*
* \bParameters:b\
* \b<cSource>b\  : Character : cSource file name
* \b<cDest>b\    : Character : Destination file name
*
* \bReturns:b\  : boolean : True if rename is successfull. If cSource file exists.
***************************************************************************
FUNCTION drgFRename(cSource, cDest)
  IF !FILE(cSource)
    RETURN .F.
  ENDIF

  IF FILE(cDest)
    FERASE(cDest)
  ENDIF

  FRENAME(cSource, cDest)
RETURN .T.

***************************************************************************
* Duplicates (copies) cSource file to destination file. Replace for OS COPY command.
*
* \bParameters:b\
* \b<cSource>b\  : Character : cSource file name
* \b<cDest>b\    : Character : Destination file name
***************************************************************************
FUNCTION _DupFile(cSource,cDest)
LOCAL Buf:=SPACE(4096), BytesRead
LOCAL FI,FO,Size,Scr,Kopirano
  FI := FOPEN(cSource)
  IF FERROR() != 0
    RETURN .F.
  ENDIF
  FO := FCREATE(cDest)
  BytesRead := FREAD(FI,@Buf,4096)
  WHILE BytesRead > 0
    FWRITE(FO,@Buf,BytesRead)
    BytesRead := FREAD(FI,@Buf,4096)
  ENDDO
  FCLOSE(FO); FCLOSE(FI)
RETURN .T.

************************************************************************
* INI file is a text file with initialization values for internal variables. \
* Values of variables can be assignet as if they were written inside the program eg:
* varCharacter := 'character varûiable'    // and this is komment
* varLogical   :=.T.
* aNumber     = 1000                      // : can be ommited
* startDate :=20021231                    // date is in format for STOD
*
* Warning: Variable must be PUBLIC declared and initialized with default value before \
* it can be set. If variable is not found line will be ignored.
*
* \bParameters:b\
* \b< fileName >b\  : character : File name containing initialization settings.
************************************************************************
PROCEDURE drgReadINI(fileName)
LOCAL F, st, Err := .F., LinNum := 0
LOCAL varName, varValue, varBlock, varType
LOCAL s, aVal, cName, cObj, n, x

  IF !FILE(fileName)
*    wErrorWait('Error in InstExtVars(). File '+FName+' not found!')
    RETURN
  ENDIF

  F := FOPEN(fileName)
  WHILE FReadLn(F,@st)
    LinNum++
* Everything after // is comment
    IF ( x := AT('//',st) ) > 0
      st := LEFT(st, --x)
    ENDIF
* Everything after && is comment
    IF ( x := AT('&&',st) ) > 0
      st := LEFT(st, --x)
    ENDIF
* Comment is also Asterix at start
    st := LTRIM(st)
    IF LEFT(st,1) = '*'
      LOOP
    ENDIF
* IF := then remove :
    IF ( x := AT(':=', st) ) > 0
      st := STUFF(st, x, 2, '=')
    ENDIF

    st := ALLTRIM(st)
    IF ( x := AT('=', st) ) > 0                       // at least one =
      varName  := ALLTRIM( LEFT(st, x - 1) )          // get Variable name
      varValue := ALLTRIM( RIGHT(st, LEN(st) - x) )   // get Variable value
* Inside object
      IF (n := AT(':', varName) ) > 0
        cObj     := drgParse(varName,':')
        cName    := drgParseSecond(varName,':')
        varBlock := drgVarBlock(@&cObj:&cName)
      ELSE
        if( at( '"', varName) <> 0, varName := strTran( varName, '"', ''), nil )
        varBlock := MEMVARBLOCK(varName)                // get Variable Block
      ENDIF
*
      IF varBlock != NIL
        varType := VALTYPE(EVAL(varBlock))            // get type of block

        DO CASE
* Character
        CASE varType = 'C'
          varValue := _getStr(varValue)
          EVAL(varBlock, varValue)
* Logical
        CASE varType = 'L'
          EVAL(varBlock, UPPER(SUBSTR(varValue, 2, 1)) = 'T')
* Date
        CASE varType = 'D'
          varValue := _getStr(varValue)
          EVAL(varBlock, STOD(varValue))
* Numeric
        CASE varType = 'N'
          EVAL(varBlock, VAL(varValue))
* Multi dim array
        CASE varType = 'A'
          varValue := _getStr(varValue)
          s := '{'
          WHILE LEN( aVal := drgParse(@varValue) ) > 0
            s += '"' + aVal + '",'
          ENDDO
          s := LEFT(s,LEN(s)-1) + '}'       // remove last comma
          AADD(&(varName),&(s))
*          drgDump(&(varName),'vrednost')

        ENDCASE
      ELSE
*        ? 'Error in InstExtVars(). Line '+STR(LinNum,5,0)
        Err:=.T.
      ENDIF
    ENDIF

  ENDDO
  FCLOSE(F)
*  IF Err
*    ? 'Press any key to continue'
*    INKEY(0)
*  ENDIF
RETURN

************************************************************************
* Saves specified internal variables to external INI file so they can be restored \
* on another usage of program.
* \bParameters:b\
* \b< fileName >b\  : character : Output file name
* \b< varList >b\   : character | array of charachter : List of variables to save. \
* List can be specified as Character of variable names delimited with comma or\
* as array of specified variable names.
************************************************************************
PROCEDURE drgSaveINI(fileName, varList)
LOCAL varName, varBlock, varType, varValue
LOCAL F, st, s:= '', n, cObj, cName
* Change array into comma delimited Character
  IF VALTYPE(varList) = 'A'
    EVAL(varList, {|el| s := el + ','} )
  ELSE
    s := varList
  ENDIF
*
  F := FCREATE(fileName)
  WHILE !EMPTY(varName := drgParse(@s) )
    varName   := ALLTRIM(varName)
* In object
    IF (n := AT(':', varName) ) > 0
      cObj  := drgParse(varName,':')
      cName := drgParseSecond(varName,':')
      varBlock := drgVarBlock(@&cObj:&cName)
    ELSE
      varBlock  := MEMVARBLOCK(varName)               // get Variable Block
    ENDIF
*
    IF varBlock != NIL
      varValue := EVAL(varBlock)                    // get variable value
*
      IF VALTYPE(varValue) = 'O'
        st := varValue:getUpdated()
      ELSE
        st := varName + ':=' + drgINIVar4(varValue)
      ENDIF
* Write to file
      FWRITE(F,st + CRLF)
    ENDIF

  ENDDO
  FCLOSE(F)
RETURN

**************************************************************************
* Return value formated 4 saveing as INI variable.
*
* \bParameters:b\
* \b< xValue >b\  : value to be formated
**************************************************************************
FUNCTION drgINIVar4(xValue)
LOCAL st, varType := VALTYPE(xValue)                 // get type of value
   DO CASE
* Character
   CASE varType = 'C'
     st := "'" + xValue + "'"
* Logical
   CASE varType = 'L'
     st := IIF(xValue,'.T.','.F.')
* Date
   CASE varType = 'D'
     st := DTOS(xValue)
* Numeric
   CASE varType = 'N'
     st := ALLTRIM(STR(xValue))
   ENDCASE
RETURN st

**************************************************************************
* Simulates KEYBOARD function.
*
* \bParameters:b\
* \b<oXbp>b\    : xbpDialog : Dialog to send KEYBOARD sequence TO
* \b<seq>b\     : Character : Sequence to send
**************************************************************************
PROCEDURE drgKEYBOARD(oXbp, seq)
LOCAL x
  FOR x := 1 TO LEN(seq)
    PostAppEvent( xbeP_Keyboard, ASC(seq[x] ), , oXbp)
  NEXT x
RETURN

**************************************************************************
* Validates field with time entered. It also sets
*
* \bParameters:b\
* \b<oVar>b\    : drgVar : Object of drgVar
*
* \bReturn:b\   : Boolean : True if enetred time is valid
**************************************************************************
FUNCTION drgValidateTime(oVar)
LOCAL h,m,s, aVal
  aVal := oVar:get()
  h    := VAL( ALLTRIM(drgParse(@aVal,':')) )
  m    := VAL( ALLTRIM(drgParse(@aVal,':')) )
  s    := VAL( ALLTRIM(aVal) )

  IF h > 23 .OR. m > 59 .OR. s > 59 .OR. h < 0 .OR. m < 0 .OR. s < 0
    RETURN .F.
  ENDIF
  oVar:set(drgPADL(h, 2) + ':' + drgPADL(m ,2) + ':' + drgPADL(s, 2) )
RETURN .T.

***************************************************************************
* DRG replacement for PADL function. It is most often used where a Character number must be \
* filled with leading zeros. Passed Character parameter is trimmed before \
* padded with cFillChar. Expression may be passed as numeric value. \
* In this case parameter is converted to Character before padded. Function is a replacement \
* for expression st := PADL(ALLTRIM(st), nLen, '0')
*
* \bParameters:b\
* \b< Expression >b\  : Character  or numeric : Expression of type Character or numeric. If \
* numeric is passed then it is converted with STR(INT(Expression)) to Character.
* \b< nLen >b\        : Numeric : is a positive integer indicating the length of the character Character returned
* \b[cFillChar]b\   : Character  : Znak s katerim ßelimo zapolniti manjkajoüa mesta. Privzeto '0'.
*
* \bReturns:b\     : Character  : <cFillChr> specifies the fill character used to PADL \
* the character Character after conversion from <Expression> . The zero '0' is the default fill character
**************************************************************************
FUNCTION drgPADL(Expression, nLen, cFillChar)
LOCAL aExpression
  DEFAULT cFillChar TO '0'

  IF VALTYPE(Expression) = 'N'
    aExpression := ALLTRIM(STR(INT(Expression)))
  ELSE
    aExpression := ALLTRIM(Expression)
  ENDIF

  IF LEN(aExpression) > nLen
    RETURN RIGHT(aExpression, nLen)
  ENDIF
RETURN PADL(aExpression, nLen, cFillChar)

***************************************************************************
* Same as drgPADL, but doesn't PAD characters when expression value doesn't start with \
* digit. Mostly used for POSTEVAL function on form when keys must be filled with zeros
* but not when search is required.
*
* \bParameters:b\
* \b< Expression >b\  : character  or numeric : Expression of type Character or numeric. If \
* numeric is passed then it is converted with STR(INT(Expression)) to Character.
* \b< nLen >b\        : Numeric : is a positive integer indicating the length of the character Character returned
* \b[cFillChar]b\     : Character  : Znak s katerim ßelimo zapolniti manjkajoüa mesta. Privzeto '0'.
*
* \bReturns:b\     : Character  : <cFillChr> specifies the fill character used to PADL \
* the character Character after conversion from <Expression> . The zero '0' is the default fill character
**************************************************************************
FUNCTION drgPADL0(Expression, nLen, cFillChar)
  IF VALTYPE(Expression) = 'N' .OR. ISDIGIT(expression)
    RETURN drgPADL(Expression, nLen, cFillChar)
  ENDIF
RETURN expression


***************************************************************************
* Parse single keyword from line description. All parameters must be passed by reference. \
* The line parameter contains the remaining of passed line after parsing. Parameter value \
* hold value of parsed keyword.
*
* \bParameters:b\
* \b< @cLine > b\  : character  : Description line from description file.
* \b< @cValue > b\ : character  : Value of keyword
*
* \bReturns:b\    : character  : Parsed keyword. NIL if nothing left
***************************************************************************
FUNCTION _parse(cLine, cValue)
LOCAL nLen := LEN(cLine), cRet
LOCAL n, nCount := 0, nStart := 0, nEnd := 0
  FOR nEnd := 1 TO nLen
* IF start not defined yet. Mark start.
    IF cLine[nEnd] = '('
      IF nStart = 0
        nStart := nEnd
* another open bracket found. Count brackets to skip.
      ELSE
        nCount++
      ENDIF
    ENDIF
* close bracket.
    IF cLine[nEnd] = ')'
      IF nCount = 0
        EXIT
      ELSE
        nCount--
      ENDIF
    ENDIF
  NEXT
* No brackets found
  IF nStart = 0 .OR. nCount > 0
*    drgLOG:cargo := cLine
    RETURN NIL
  ENDIF
*
  cValue := ALLTRIM(drgSubSTR(cLine, nStart + 1, nEnd - 1) )
  cRet   := ALLTRIM(LEFT(cLine, nStart - 1) )
  cLine  := RIGHT(cLine, nLen - nEnd)
RETURN cRet

***************************************************************************
* Returns value of keyword as Character with removed parenthises.
*
* \bParameters:b\
* \b< @value >b\    : Character  : passed value
***************************************************************************
FUNCTION _getStr(value)
* Remove leading and trailing parenthises
  IF LEFT(value, 1) = '"' .OR. LEFT(value, 1) = "'"
    RETURN SUBSTR(value, 2, LEN(value) - 2)
  ENDIF
RETURN value

***************************************************************************
* Returns last keyword value as Array
***************************************************************************
FUNCTION _getNumArr(value)
LOCAL ar := {0,0}, x
  x := AT(",", value)
  ar[1] := VAL(LTRIM(LEFT(value, x - 1) ))
  ar[2] := VAL(LTRIM(SUBSTR(value, x + 1, 10) ))
RETURN ar

***************************************************************************
* Returns last keyword value as Number
***************************************************************************
FUNCTION _getNum(value)
RETURN VAL(ALLTRIM(value))

***************************************************************************
* Returns last keyword value as Logical value. Logical True is Y or 1 or T
***************************************************************************
FUNCTION _getLogical(value)
  IF !EMPTY(value)
    value := LEFT( LOWER( ALLTRIM(value) ), 1)
    RETURN AT(value,'1yt') > 0
  ENDIF
* Default is .T.
RETURN .T.

***************************************************************************
* Usr declared function for converting data from different codepages
***************************************************************************
FUNCTION _drgUsrCPconvert(st, lFromDB)
LOCAL aData := drgNLS:arCPdata
LOCAL aApp  := drgNLS:arCPapp
* Konverzija
  IF lFromDB
    AEVAL( aData, {|ch, i| st := STRTRAN(st, ch, aApp[i]) } )
  ELSE
    AEVAL( aData, {|ch, i| st := STRTRAN(st, aApp[i], ch) } )
  ENDIF
RETURN st

***************************************************************************
* Clears event loop. Used when all events must be deleted from event queue.
* Returns True if events were removed.
* \bParameters:b\
* \b< lAll >b\      : logical : Clear all or only last event. Default is false \
* for single event deletion.
*
* \bReturns:b\ lDeleted : True if any events were deleted.
***************************************************************************
FUNCTION _clearEventLoop(lAll)
LOCAL nEvent, oXbp, mp1, mp2, n := 1
LOCAL ar := {}, lCleared := .F.

  DEFAULT lAll TO .F.
/*
  WHILE (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) != xbe_None
    IF nEvent > drgEVENT_MAX .OR. nEvent < drgEVENT_MIN
      AADD(ar, {nEvent, mp1, mp2, oXbp } )
    ELSE
      lCleared := .T.
    ENDIF
  ENDDO
*
  FOR n := 1 TO LEN(ar)
    PostAppEvent(ar[n,1], ar[n,2], ar[n,3], ar[n,4] )
  NEXT
  ar := NIL
RETURN lCleared
*/

  IF (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) = xbe_None
    RETURN .F.
  ENDIF
  IF nEvent = drgEVENT_MSG
    AADD(ar, {nEvent, mp1, mp2, oXbp } )
  ENDIF
*  drgDump(nEvent,'1 CLEARED EVENT')
* Return if not delete all events
  IF !lAll; RETURN .T.; ENDIF
*
  IF lAll
    WHILE (nEvent := AppEvent(@mp1, @mp2, @oXbp, 1) ) != xbe_None
*    drgDump(nEvent, STR(++n) + ' CLEARED EVENT')
      IF nEvent = drgEVENT_MSG
        AADD(ar, {nEvent, mp1, mp2, oXbp } )
      ENDIF
    ENDDO
  ENDIF
  AEVAL(ar, { |el, n| PostAppEvent(ar[n,1], ar[n,2], ar[n,3], ar[n,4] ) } )
RETURN .T.


***************************************************************************
* Calculates position for dialog, which is to be displayed in the center of parent window.
*
* \bParameters:b\
* \b< @aDlg >b\     : object of xbpDialog  : Dialog to be centered
* \b< @aParent >b\  : object of xbpDialog  : Parent to whom dialog is to be centered
*
* \bReturns:b\      : ARRAY(2) of numeric  : Coordinate for displaying dialog
***************************************************************************
FUNCTION _CenterPos( aDlg, aParent)
LOCAL x, y, aSize, aPSize, aPPos
  DEFAULT aParent TO AppDesktop()

  aSize  := aDlg:currentSize()
  aPSize := aParent:currentSize()
  aPPos  := aParent:currentPos()
  x := aPPos[1] + (aPSize[1]-aSize[1])/2
  y := aPPos[2] + (aPSize[2]-aSize[2])/2
RETURN {x,y}

***************************************************************************
* Function returns next value for specified key. It is very useful for requesting \
* next needed document number. If key is compound from year and database name \
* document numbering will start from 1 every new year. If document is not saved \
* function should be called again with second parameter passed. Thus will result in \
* value beeing saved to file for recycling unsaved document numbers.

*
* Databases drg100 and drg101 hold values for last used valus for specified key. \
* Function first looks into drg101 file, which holds values of documents which were reserved \
* and not saved. If value is found there it returns that value otherwise it looks for \
* next value for specified key in the drg100 file, adds 1 to value, saves new value \
* and returns value to caller.
*
* \bParameters:b\
* \b< key >b\     : Character  : key which determines re
* \b[ value ]b\   : numeric : value which needs to be recycled. Passed only when \
* requested document number was not saved.
***************************************************************************
FUNCTION drgNextDocNumber(key, value)
LOCAL num := NIL, area := SELECT(), ret := .F.
  drgDBMS:open('drg101')
  IF value != NIL                       // value must be recycled
    IF !DBSEEK( REPLICATE('9',30) )
      DBAPPEND()                        // add to recycled
    ENDIF
    IF drgLockOK()
      DRG101->key   := key              // recycle key
      DRG101->value := value
      DBUNLOCK()
    ENDIF
    ret := .T.
  ELSEIF DBSEEK(key)                    // value found in recycled
    IF drgLockOK()                      // return value
      num := DRG101->value
      DRG101->value := 0                // delete in recycled
      DRG101->key   := REPLICATE('9',30)
      DBUNLOCK()
      ret := .T.
    ELSE
      num := NIL                        // will result in RunTime error
    ENDIF
  ENDIF
  DRG101->( DBCOMMIT() )             // We won't need it anymore
  DRG101->( DBCLOSEAREA() )             // We won't need it anymore
  IF ret
    DBSELECTAREA(area)
    RETURN num
  ENDIF

* Not found in recycled. Search for next value in DRG100
  drgDBMS:open('drg100')
  IF !DBSEEK(key)                        // key is not yet defined
    DBAPPEND()
    DRG100->key := key
  ENDIF

  IF drgLockOK()
    num := DRG100->value + 1
    DRG100->value := num
  ELSE
    num := NIL                          // Runtime error
  ENDIF
  DRG100->( DBCOMMIT() )
  DRG100->( DBCLOSEAREA() )

  DBSELECTAREA(area)
RETURN num

***************************************************************************
* Returns year as two digit Character number. If parameter aDate is passed year is \
* extracted from the parameter otherwise DATE() is used instead.
* \bSe also:b\ drgYear4
*
* \bParameters:b\
* \b[ aDate ]b\   : date : date from where 2 year digit is extracted
*
* \bReturns:b\    : Character : 2 digit year number
***************************************************************************
FUNCTION drgYear2(aDate)
  DEFAULT aDate TO DATE()
RETURN SUBSTR(DTOS(aDate), 3, 2)

***************************************************************************
* Returns year as four digit Character number. If parameter aDate is passed year is \
* extracted from the parameter, otherwise DATE() is used instead.
* \bSe also:b\ drgYear2
*
* \bParameters:b\
* \b[ aDate ]b\   : date : date from where 4 year digit is extracted
*
* \bReturns:b\    : Character : 4 digit year number
***************************************************************************
FUNCTION drgYear4(aDate)
  DEFAULT aDate TO DATE()
RETURN LEFT(DTOS(aDate), 4)

*************************************************************************
* Formats number acording to picture string. If picture is passed as numeric \
* type default picture (ex. 999,999.99) is created and used for \
* transformation. The return string is right adjusted.
*
* Parameters:
* < num > : number : number to be transformed to Character
* < len > : character : transform picture
* < len > : number : length of return Character
* < dec > : number : number of decimal places if output length is passed as parameter. \
* Default value is 2.
*
* Return: Character : number as Character transformated acording to picture
*************************************************************************
FUNCTION drgFormNum(Num, len, Dec)
LOCAL ret, pic, pz := ''
  DEFAULT dec TO 2
  IF VALTYPE(len) = 'C'                                 // picture is passed
    ret := ALLTRIM( TRANSFORM(num, len) )
* my old fashioned way
  ELSE
* compose default picture
    pic := IIF(dec > 0, '.' + REPLICATE('9', dec), '')
    len := len - LEN(pic) - 1
    WHILE len >= 0
      pic := ',999' + pic
      len -= 4
    ENDDO
*
    pic := '@N ' + RIGHT(pic, LEN(pic) + len)   // delete starting comma
    IF drgINI:printSignRight
      pz  := IIF(num < 0, '-', ' ')             // zapomnim predznak
      num := ABS(num)
    ENDIF
    ret := TRANSFORM(num, pic) + pz
  ENDIF
RETURN ret

*************************************************************************
* Function used by all drg objects to determine file name and variable name from \
* supplied description.
*
* Parameters:
* < @cName  > : character    : Field name to be returned
* < oDesc   > : _drg* object : description object
* < cDBName > : character    : Default file name from FORM description
*
* \bReturn:b\
* < cFile > : character : File name
*************************************************************************
FUNCTION _getcFilecName(cName, oDesc, cDBName)
LOCAL cFile
  IF AT('->', oDesc:name) = 0
    cFile := IIF(oDesc:file = NIL, cDBName, oDesc:file)
    cName := oDesc:name
    cFile := IIF(EMPTY(cFile),'M',cFile)
  ELSE
    cFile := drgParse(oDesc:name,'-')
    cName := drgParseSecond(oDesc:name,'>')
  ENDIF

* Sometimes names of fields must be left lowercase, but not on database fields
  IF ( cFile := UPPER(cFile) ) != 'M'
    cName := UPPER( cName)
  ENDIF

*  cName := UPPER(cName)
RETURN cFile //UPPER(cFile)

*************************************************************************
* Function used by checkBox, comboBox, radioButton to determine VALUES keyword.
*
* Parameters:
* \b< oDesc >b\ : _drg* object : description object
* \b< oDrg  >b\ : drg* object  : callers object
*
* \bReturn:b\
* \b< aValues >b\ : array : Array defining allowed values
*************************************************************************
FUNCTION _getBoxValues(oDesc, oDrg)
LOCAL aVals := {}, values := '', xval
LOCAL cRef, cVal, cDesc, cType
LOCAL cName1, cName2, cFile, nLen

  IF oDesc:ref != NIL
* Values from reference field description
    IF AT('-',oDesc:Ref) > 0
      IF ( cRef := drgDBMS:getFieldDesc( oDesc:ref ) ) != NIL
        values := cRef:values
      ENDIF
    ELSEIF ( cRef := drgRef:getRef( oDesc:ref ) ) != NIL
      values := cRef:values
    ENDIF
* Reference is from file
  ELSEIF oDesc:values != NIL
    IF AT('->',oDesc:Values) > 0
      cRef    := oDesc:Values
      cFile   := ALLTRIM(drgParse(@cRef,'-'))
      cRef    := SUBSTR(cRef,2,LEN(cRef) )              // delete '>' char
      cName1  := ALLTRIM(drgParse(@cRef,':') )
      cRef    := ALLTRIM(cRef)
      cName2  := IIF(EMPTY(cRef), cName1, cRef)         // IF not set default to name1
      oDrg:drgDialog:pushArea()
* Open file and read values into values array
      IF drgDBMS:open(cFile) != NIL
        values := ''
        ctype  := valtype(oDrg:oVar:get())
        DBGOTOP()

        WHILE !EOF()
          xval   := if(ctype = 'N', str(&(cFile+'->'+cName1)), &(cFile+'->'+cName1))
          values += xval +':' +drgNLS:dataConvert( &(cfile+'->'+cname2), .T. ) + ','

*-          values += &(cFile+'->'+cName1) + ':' + drgNLS:dataConvert( &(cFile+'->'+cName2), .T. ) + ','
          DBSKIP()
        ENDDO
        values := LEFT(values, LEN(values) - 1)   // remove last comma
      ELSE
        drgLog:cargo := 'ComboBox: VALUES '+oDesc:Values+' not valid!'
      ENDIF
      oDrg:drgDialog:popArea()
* VALUES keyword is specified
    ELSEIF AT(',', oDesc:values) = 0
      cName2 := ALLTRIM(oDesc:values)
      IF ( cName1 := oDrg:drgDialog:getMethod(cName2) ) != NIL
        values := EVAL(cName1, oDrg)
      else
        values := oDesc:values
      ENDIF
    ELSE
      values := oDesc:values
    ENDIF
* Values from curently active filearea
  ELSE
    values := oDrg:oVar:ref:values
  ENDIF
*
  IF values = NIL .OR. LEN(values) = 0
* POST ERROR Reference field not found
    values := '1 ERROR:1 ERROR'
  ENDIF
  cType := VALTYPE(oDrg:oVar:get())
* Convert values to array
  WHILE LEN(cDesc := drgParse(@values)) > 0
    cVal  := drgParse(@cDesc,':')
* Blank values are allowed
    IF LEN(cDesc) > 0 .AND. !EMPTY(cDesc)
      cDesc := ALLTRIM(cDesc)
    ENDIF
* Return values are also result values
    IF EMPTY(cDesc)
      cDesc := cVal
    ENDIF
* Result is numeric
    IF cType = 'N'
      cVal := VAL(cVal)
    ELSEIF cType = 'L'
      cVal := _getLogical(cVal)
    ELSEIF cType = 'C'
* Must be padded with blanks
      nLen := LEN(oDrg:oVar:get())
      IF LEN(cVal) < nLen
* This works ok for database fields only.
        cVal := PADR(cVal, nLen)
      ENDIF

      * u combobox pokud pouûiji pokraËovacÌ ¯·dky + ; *
      IF Len(cVal) > nLen
        cVal := AllTrim(cVal)
        cVal := PadR(cVal, nLen)
      ENDIF
    ENDIF

* Add to values array
    AADD(aVals, {cVal, drgNLS:msg(cDesc) } )
  ENDDO
RETURN aVals

*************************************************************************
* Function used by browse enabled drg objects to determine FIELDS  keyword.
*
* Parameters:
* \b< oDesc >b\ : _drg* object : description object
* \b< oDrg  >b\ : drg* object  : callers object
*
* \bReturn:b\
* \b< aFields >b\ : array : Array defining fields values
*************************************************************************
FUNCTION _getBrowseFields(oDesc, oDrg)
  LOCAL  ar, parsed, cFile, cName
  LOCAL  cField, fields, lIsFunction
  LOCAL  defCap, defName, defLen, defType, defPic, defSum
  *
  local  oDBD_desc, cc, pa_toolTipText := if( isMemberVar( odrg, 'pa_toolTipText'), odrg:pa_toolTipText, {} )
  *
  ar := {}
  fields  := oDesc:fields
  *
  ** tohle je ˙prava pro reinstalaci p¯i reinstalaci nenÌ objek inicializov·n
  if isObject( osplash_for_dialog )
    if(select('asysvircol') = 0, drgDBMS:open('asysvirCol'), nil)
  endif


  WHILE !EMPTY( cField := drgParse(@fields,',') )
**************************
* Parse index
**************************
    lIsFunction := .F.
    drgLog:cargo := 'xxxBrowse:FIELDS ' + cField
    parsed := ALLTRIM( drgParse(@cField,':') )
    IF !oDrg:isFile
* For safety porpuses. Index 0 will result in error
      IF ( defName := VAL( LTRIM(parsed)) ) = 0
* Probably object
        defName := ALLTRIM(parsed)
      ENDIF
    ELSEIF AT('(',parsed) > 0
      defName := parsed
      lIsFunction := .T.
    ELSE
      IF AT('->',parsed) = 0
        parsed := oDrg:cFile + '->' + parsed       // FILE->FieldName
      ENDIF
      cFile := drgParse(parsed,'-')                // Get FILE
      cName := drgParseSecond(parsed,'>')          // Get FieldName
      defName := parsed
    ENDIF

    oDBD_desc := drgDBMS:getFieldDesc(cFile, cName)

**************************
* Parse caption
**************************
    parsed := ALLTRIM( drgParse(@cField,':') )
* Search for caption in description
    IF EMPTY(parsed) .AND. oDrg:isFile .AND. !lIsFunction .and. !(cfile = 'M')
      parsed := drgDBMS:getFieldDesc(cFile, cName):caption
    ENDIF
    defCap := drgNLS:msg(parsed)
**************************
* Parse length
**************************
    parsed := ALLTRIM( drgParse(@cField,':') )
    IF EMPTY(parsed) .AND. oDrg:isFile .AND. !lIsFunction .and. !(cfile = 'M')
      parsed := STR(drgDBMS:getFieldDesc(cFile, cName):len + 1)  // 2 STR because of VAL
    ENDIF
    defLen := IIF(EMPTY(parsed), 10, VAL(parsed) )
**************************
* Parse picture
**************************
    defPic  := ALLTRIM( drgParse(@cField,':') )
    IF EMPTY(defPic) .AND. oDrg:isFile .AND. !lIsFunction .and. !(cfile = 'M')
      defPic := drgDBMS:getFieldDesc(cFile, cName):picture // picture from field description
    ENDIF
**************************
* Parse column type
**************************
    parsed  := ALLTRIM( drgParse(@cField,':') )
    defType := IIF( EMPTY(parsed), 4, VAL(parsed) )

**************************
* Parse sum column type
**************************
    parsed  := ALLTRIM( drgParse(@cField,':') )
    defSum  := IIF( EMPTY(parsed), 0, VAL(parsed) )

    AADD(ar, {defCap, defName, defLen, defPic, defType, defSum } )

    if isObject( oDBD_desc )
      aadd( pa_toolTipText, oDBD_desc:desc )
    else

      * tohle je ˙prava pro reinstalaci
      if isObject( osplash_for_dialog ) //  zatÌm blbne to na ListBrowse .and. isCharacter(defName)
        if asysvirCol->( dbseek( upper(defName),,'ASYSVCOL01'))
          cc := allTrim(asysvirCol->cnazColumn)
        else
          cc :=  'Virtu·lnÌ sloupec'

          asysvirCol->( dbappend())
          asysvirCol->cvirColumn := defName
          asysvirCol->(dbunlock(),dbcommit() )
        endif
      else
        cc :=  'Virtu·lnÌ sloupec'
      endif

      aadd( pa_toolTipText, cc +' ...' )
    endif

    drgLog:cargo := NIL
  ENDDO
RETURN ar


*************************************************************************
* Add values in elements of first array to the elements of second array. \
* Values in first array may be optionaly reset to zero. Usefull for printing \
* reports.
*
* \bParameters:b\
* \b< @ar >b\    : array of numeric : array to add
* \b< @arSum >b\ : array of numeric : summary array
* \b[ lZero ]b\  : logical : Set to true when input array values must be set \
* to zero after its values were added to summary array. Default is false.
*************************************************************************
PROCEDURE _ArrayAdd(ar, arSum, lZero)
  DEFAULT lZero TO .F.
*
  AEVAL(ar, { | nVal,n | arSum[n] += ar[n] })
  IF lZero
    AEVAL(ar, { | nVal,n | ar[n] := 0 })
  ENDIF
RETURN

*************************************************************************
* Reset all elements of array to value zero.
*
* \bParameters:b\
* \b< @ar >b\    : array of numeric : array to be cleared
*************************************************************************
PROCEDURE _ArrayClear(ar)
  AEVAL(ar, { | nVal,n | ar[n] := 0 })
RETURN

*************************************************************************
* Checks if all elemets of string array have default values defined
*
* \bParameters:b\
* \b< @ar >b\    : array of numeric : array to be cleared
*************************************************************************
FUNCTION _drgCheckStringArray(cAr, nLen)
LOCAL c, ar

RETURN ar

*************************************************************************
* Returns value for specified field. The function can be used for returning \
* of related database field or return the description of referenced field for
* browser objects.
*
* \bParameters:b\
* \b< @ar >b\    : array of numeric : array to be cleared
*************************************************************************
FUNCTION drgReference4(p1, p2)
LOCAL cVal, oldArea, cRet := '**'
LOCAL cName, cFile, oRef
LOCAL c, cParsed
  IF VALTYPE(p1) = 'C'
    IF AT('->',p1) > 0
      cVal := EVAL( FIELDWBLOCK( drgParseSecond(p1,'>'), drgParse(p1,'-') ) )
    ELSE
      cVal := p1
    ENDIF
  ELSEIF VALTYPE(p1) = 'B'                            // evaluate if  type codeblock
    cVal := EVAL(p1)
  ELSE
    cVal := p1
  ENDIF
*
  IF cVal != NIL
    IF AT('->',p2) != 0
      cFile := drgParse(p2,'-')
      cName := drgParseSecond(p2,'>')
      oldArea := SELECT()
      SELECT(cFile)
      DBSEEK(cVal)
      cRet := &cName
      SELECT(oldArea)
    ELSEIF ( oRef := drgRef:getRef(p2) ) != NIL
      c := oRef:values
      WHILE !EMPTY(cParsed := drgParse(@c) )
        IF drgParse(cParsed,':') == cVal
          cRet := drgParseSecond(cParsed,':')
          EXIT
        ENDIF
      ENDDO
    ENDIF
  ENDIF
RETURN RTRIM( cRet )