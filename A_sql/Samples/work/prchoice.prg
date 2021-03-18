#INCLUDE "dcdialog.CH"
#INCLUDE "dcprint.CH"
#INCLUDE "common.CH"

*********************************************
**********  Printer Definitions  ************
*********************************************

#define PRN_MODE                1
#define PRN_ORIENTATION         2
#define PRN_OUTFILE             3
#define PRN_TEXTONLY            4
#define PRN_USEDEFAULT          5
#define PRN_FONT                6
#define PRN_TEMPFILE            7
#define PRN_EMAILTO             9
#define PRN_EMAILMEMO           10
#define PRN_WIDTH               11
#define PRN_LMARGIN             12
#define PRN_RMARGIN             13
#define PRN_START_ROW           14
#define PRN_COVER               15
#define PRN_DBL_SPACE           16
#define PRN_TITLE               17
#define PRN_COPIES              18
#define PRN_EMAIL               19

#DEFINE CRLF  Chr(13)+Chr(10)

STATIC saPrintOptions[20]

// #define SENDMAIL_ASINET
// #define SENDMAIL_MARSHALLSOFT

#ifdef SENDMAIL_ASINET
  #include "asinetc.ch"
  #pragma Library("asinet10.lib")
  #pragma Library("asinet1c.lib")
  #pragma Library("asiutl10.lib")
#endif

#ifdef SENDMAIL_MARSHALLSOFT
  #include "dll.ch"
  #include "see32.ch"
  #include "keycode.ch"
#endif

* -----------------

FUNCTION Print_Loop( cTitle, nCopies, lEmail, bEval )

LOCAL nExit

DEFAULT lEmail := .F.

IF lEmail
  IF Print_Choice( cTitle, nCopies, .T., .F.  )
    Eval( bEval )
  ENDIF
ELSE
  DO WHILE .T.
    nExit := Print_Choice( cTitle, nCopies, lEmail, TRUE )
    IF Empty(nExit)
      EXIT
    ENDIF
    Eval( bEval )
    IF Valtype(nExit) = 'N'
      IF nExit = 1
        EXIT
      ENDIF
    ELSE
      EXIT
    ENDIF
  ENDDO
ENDIF

RETURN .T.



// *************************************************
//  Function: Print_Choice
//  Purpose: Asks if user wants a printed copy of
//           the current form.
//
//  Returns: TRUE if yes, FALSE if no.
//
// *************************************************

FUNCTION Print_Choice( cTitle, nCopies, cEmail, lLoop )

LOCAL GetList[0], GetOptions, lStatus, oPrintModeGroup, oPrintLayoutGroup, ;
      oPrintEmailGroup, oPrintFileGroup, nExit := 0, aButtons, aFonts, ;
      oFileFormatGroup

DEFAULT lLoop := .F.

aFonts := { ;
  '11.Courier New', ;
  '11.Courier New Bold', ;
  '11.Lucida Console', ;
  '11.Lucida Console Bold', ;
  '11.Terminal' , ;
  '11.Terminal Bold' }

ClearPrintVars()

DEFAULT cEmail := Space(100)

saPrintOptions[PRN_EMAILTO] := cEmail

DEFAULT saPrintOptions := {}
ASize(saPrintOptions,20)

saPrintOptions[PRN_COPIES] := nCopies

DEFAULT saPrintOptions[PRN_MODE] := 4, ;
        saPrintOptions[PRN_ORIENTATION] := 1, ;
        saPrintOptions[PRN_OUTFILE] := '', ;
        saPrintOptions[PRN_TEXTONLY] := .T., ;
        saPrintOptions[PRN_EMAIL] := .F., ;
        saPrintOptions[PRN_EMAILMEMO] := '', ;
        saPrintOptions[PRN_FONT] := '11.Lucida Console Bold', ;
        saPrintOptions[PRN_COPIES] := 1

saPrintOptions[PRN_OUTFILE] := Pad(saPrintOptions[PRN_OUTFILE],45)
saPrintOptions[PRN_EMAILTO] := Pad(saPrintOptions[PRN_EMAILTO],50)
saPrintOptions[PRN_FONT] := Pad(saPrintOptions[PRN_FONT],30)

@ 0,0 DCSAY 'Select Output Mode' SAYSIZE 65 SAYCENTER FONT '11.Arial Bold'
@ 1,0 DCSTATIC TYPE XBPSTATIC_TYPE_RAISEDBOX SIZE 65, .1

* ------- Mode Group -------- *

@ 2,0 DCGROUP oPrintModeGroup CAPTION 'Print Mode' SIZE 23,10

@ 1,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 1 PROMPT 'Normal Preview' ;
      TOOLTIP 'Preview with built-in Preview Window' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_EMAIL] := .F. }

@ 2,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 2 PROMPT 'Preview w/Acrobat' ;
      TOOLTIP 'Preview with Acrobat Reader;Requires Win2PDF driver and Acrobat Installed ' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_TEXTONLY] := .F., ;
                saPrintOptions[PRN_EMAIL] := .F., ;
                DC_GetRefresh(GetList)} ;
      WHEN {||AScan(XbpPrinter():new():list(),{|c|Upper(c)=='WIN2PDF'})>0} ;

@ 3,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 7 PROMPT 'Preview w/Image Writer' ;
      TOOLTIP 'Preview with Microsoft Image Writer;Requires Microsoft Office Image Writer printer driver Installed ' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_TEXTONLY] := .F., ;
                saPrintOptions[PRN_EMAIL] := .F., ;
                DC_GetRefresh(GetList)} ;
      WHEN {||AScan(XbpPrinter():new():list(), ;
              {|c|Upper(c)=='MICROSOFT OFFICE DOCUMENT IMAGE WRITER'})>0} ;

@ 4,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 3 PROMPT 'Selected Printer' ;
      TOOLTIP 'Print to any installed printer device;Select a printer from standard dialog' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_EMAIL] := .F. }

@ 5,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 4 PROMPT 'Default Printer' ;
      TOOLTIP 'Print to the default printer device' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_EMAIL] := .F. }

@ 6,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 5 PROMPT 'Send to File' ;
      TOOLTIP 'Create a File for emailing or Export' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_EMAIL] := .F. }

@ 7,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 6 PROMPT 'Send by Email' ;
      TOOLTIP 'Create a File for emailing or Export' ;
      PARENT oPrintModeGroup ;
      ACTION {|a,b,o|IIF(saPrintOptions[PRN_MODE]=6, ;
                        saPrintOptions[PRN_EMAIL]:=.t., nil), ;
                        DC_GetRefresh(GetList)}

@ 8,2 DCRADIO saPrintOptions[PRN_MODE] VALUE 8 PROMPT 'Send to Excel' ;
      TOOLTIP 'Create a XLS File for viewing in Excel' ;
      PARENT oPrintModeGroup ;
      ACTION {||saPrintOptions[PRN_EMAIL] := .F. }

* ------- Layout Group -------- *

@ 2,25 DCGROUP oPrintLayoutGroup CAPTION 'Layout / Copies' SIZE 40,4

@ 1,2 DCRADIO saPrintOptions[PRN_ORIENTATION] VALUE 1 PROMPT 'Portrait' ;
      PARENT oPrintLayoutGroup

@ 2,2 DCRADIO saPrintOptions[PRN_ORIENTATION] VALUE 2 PROMPT 'Landscape' ;
      PARENT oPrintLayoutGroup

@ 1,22 DCSAY '# Copies' SAYSIZE 0 SAYBOTTOM PARENT oPrintLayoutGroup

@ DCGUI_ROW, DCGUI_COL + 10 DCSPINBUTTON saPrintOptions[PRN_COPIES] ;
      SIZE 6 ;
      LIMITS 1, 99 ;
      PARENT oPrintLayoutGroup ;
      WHEN {||saPrintOptions[PRN_MODE] $ {3,4}}


* ------- File Format Group -------- *

@ 6,25 DCGROUP oFileFormatGroup CAPTION 'File Format' SIZE 40,4

@ 1,2 DCRADIO saPrintOptions[PRN_TEXTONLY] VALUE .T. PROMPT 'Text (.TXT)' ;
      PARENT oFileFormatGroup WHEN {||saPrintOptions[PRN_MODE] $ {5,6} }

@ 2,2 DCRADIO saPrintOptions[PRN_TEXTONLY] VALUE .F. PROMPT 'Acrobat (.PDF)' ;
      PARENT oFileFormatGroup WHEN {||saPrintOptions[PRN_MODE] $ {5,6} ;
        .AND. AScan(XbpPrinter():new():list(),{|c|Upper(c)=='WIN2PDF'})>0 }

* ------- Font ---------- *

@12.5, 0 DCSAY 'Font' GET saPrintOptions[PRN_FONT] ;
       SAYSIZE 0 SAYBOTTOM ;
       COMBO DATA aFonts HEIGHT 9 WIDTH 30 ;
       WHEN {||saPrintOptions[PRN_MODE]${1,2,3,4,7}}

* ------- File Group -------- *

@14,0 DCGROUP oPrintFileGroup CAPTION 'File Output' SIZE 65,3

@ 1,2 DCSAY "Output File" GET saPrintOptions[PRN_OUTFILE] ;
      SAYSIZE 0 SAYBOTTOM ;
      PARENT oPrintFileGroup ;
      WHEN {||saPrintOptions[PRN_MODE] $ {5,7,8}}

* ------- Email Group -------- *

@17,0 DCGROUP oPrintEmailGroup CAPTION 'Email' SIZE 65,9

@ 1,2 DCSAY 'Email Address:' SAYSIZE 0 PARENT oPrintEmailGroup

@ 2,2 DCGET saPrintOptions[PRN_EMAILTO] PARENT oPrintEmailGroup ;
      WHEN {||saPrintOptions[PRN_MODE]=6}

@ 4,2 DCSAY 'Email Memo:' SAYSIZE 0 PARENT oPrintEmailGroup

@ 5,2 DCMULTILINE saPrintOptions[PRN_EMAILMEMO] SIZE 60,3 ;
      PARENT oPrintEmailGroup ;
      WHEN {||saPrintOptions[PRN_MODE]=6}

IF lLoop

  @ 26,10 DCPUSHBUTTON CAPTION 'Print and Exit' ;
          ACTION {||nExit := 1, DC_ReadGuiEvent(DCGUI_EXIT_OK,GetList)} ;
          SIZE 15,1.2 ;
          ID 'DCGUI_BUTTON_OK' ;
          TOOLTIP 'Print this job using selected parameters and exit'

  @ DCGUI_ROW, DCGUI_COL+10 DCPUSHBUTTON CAPTION 'Print and Loop' ;
          ACTION {||nExit := 2, DC_ReadGuiEvent(DCGUI_EXIT_OK,GetList)} ;
          SIZE 15,1.2 ;
          TOOLTIP 'Print this job using selected parameters, then redisplay;' + ;
                  'this dialog window to print the job again using different;' + ;
                  'parameters.'

  @ DCGUI_ROW, DCGUI_COL+10 DCPUSHBUTTON CAPTION 'Cancel' ;
          ACTION {||nExit := 0, DC_ReadGuiEvent(DCGUI_EXIT_ABORT,GetList)} ;
          SIZE 15,1.2

ENDIF

DCGETOPTIONS ;
   NOMINBUTTON ;
   NOMAXBUTTON ;
   BUTTONALIGN DCGUI_BUTTONALIGN_CENTER ;
   TABSTOP ;
   BUTTONS aButtons

DCREAD GUI ;
   FIT ;
   _ADDBUTTONS !lLoop ;
   TITLE 'Printer Options' ;
   OPTIONS GetOptions ;
   MODAL ;
   SETAPPWINDOW ;
   TO lStatus ;
   SETFOCUS 'DCGUI_BUTTON_OK'

IF lStatus
  saPrintOptions[PRN_TITLE] := cTitle
ENDIF

saPrintOptions[PRN_FONT] := Alltrim(saPrintOptions[PRN_FONT])

IF lLoop
  RETURN nExit
ENDIF

RETURN lStatus

* --------------

STATIC FUNCTION ClearPrintVars( GetList )

saPrintOptions[PRN_OUTFILE] := Space(45)
saPrintOptions[PRN_EMAILTO] := Space(45)
saPrintOptions[PRN_EMAILMEMO] := ''

IF Valtype(GetList) = 'A'
  DC_GetRefresh(GetList)
ENDIF

RETURN nil

// **********************************************************
//  Function: PrintOn( cTitle, @oPrinter )
//  Purpose:  Sets the printer startup parameters
//
//  Params:   cTitle: The title of the Print Job
//
//  Returns:  aPointer to the DC_Printer() object.
// *************************************************************

FUNCTION PrintOn( cTitle, oPrinter, nOrientation, cFont, nCopies )

LOCAL cPrinterName, cFileName, nPointSize, nRows, nCols

// Characters not allowed in file names.
LOCAL aBadChars := {"/", "\", ":", "*", "?", '"', "<", ">", "|"}
LOCAL aMessage, lStatus

DEFAULT nOrientation := saPrintOptions[PRN_ORIENTATION]
DEFAULT cFont := saPrintOptions[PRN_FONT]
DEFAULT nCopies := saPrintOptions[PRN_COPIES]
DEFAULT cTitle := 'Print_Job'

/*
DO WHILE Valtype(DC_PrinterObject()) = 'O'

  aMessage := {'The system does not allow more than one', ;
               'print job to be run simultaneously.', ;
               'Please wait for the current job to finish.', ;
               '', ;
               'Retry?' }

  lStatus := YesNoBox('Print Job Warning','Print Job Warning',aMessage,50)
  IF !lStatus
    RETURN .F.
  ENDIF

ENDDO
*/

IF Empty(cFont)
  cFont := '11.Courier New'
ENDIF

nPointSize := Val(cFont)

// Get print row/column grid geometry w.r.t. page orientation and
// current body font point size.
if nOrientation = 1     // portrait ------
  nRows := Round(726/nPointSize,0)    // 60*11.Courier
  nCols := Round(880/nPointSize,0)    // 80*11.Courier
else                                   // landscape ------
  nRows := Round( 510/nPointSize,0)   // ((8.5/11)*660)*11.Courier
  nCols := Round(1139/nPointSize,0)   // ((11/8.5)*880)*11.Courier
endif

// Process output device names (for print to file and email).
cFileName := alltrim(saPrintOptions[PRN_OUTFILE])
if !Empty(saPrintOptions[PRN_OUTFILE]) .AND. !saPrintOptions[PRN_TEXTONLY]
  cPrinterName := 'Win2PDF'
elseif !Empty(saPrintOptions[PRN_EMAILTO]) .AND. saPrintOptions[PRN_MODE] = 6
  IF saPrintOptions[PRN_TEXTONLY]
    cPrinterName := 'TextFile'
    saPrintOptions[PRN_TEMPFILE] := Alltrim(Strtran(cTitle,' ','')) + '.TXT'
  ELSE
    cPrintername := 'Win2PDF'
    saPrintOptions[PRN_TEMPFILE] := Alltrim(Strtran(cTitle,' ','')) + '.PDF'
  ENDIF
  AEval(aBadChars, ;   // make sure we have a legal file name
            {|e|saPrintOptions[PRN_TEMPFILE] := StrTran(saPrintOptions[PRN_TEMPFILE],e,"-")})
  cFileName := saPrintOptions[PRN_TEMPFILE]
endif

DCPRINT ON ;
  TO           oPrinter ;
  TITLE        "Print Job: " + Alltrim(cTitle) ;
  NAME         cPrinterName ;
  _TEXTONLY    saPrintOptions[PRN_TEXTONLY] .AND. saPrintOptions[PRN_MODE] $ {5,6};
  _PREVIEW     saPrintOptions[PRN_MODE] = 1 ;
;//  PSIZE 600, 600 ;
;//  ZOOMFACTOR 1.0 ;
  _ACROBAT     saPrintOptions[PRN_MODE] = 2 ;
  _IMAGEWRITER saPrintOptions[PRN_MODE] = 7 ;
  _EXCEL       saPrintOptions[PRN_MODE] = 8 ;
  _TOFILE      !Empty(cFileName) ;
  OUTFILE      (cFileName) ;
  NOSTOP ;
  _HIDE        saPrintOptions[PRN_MODE] = 1 ;
  ORIENTATION  nOrientation ;
  SIZE         nRows, nCols ;
  FONT         Alltrim(cFont) ;
  _USEDEFAULT  saPrintOptions[PRN_MODE] = 4 ;
  COPIES       nCopies ;
  COMBINEEXCELSHEETS

return (valtype(oPrinter)=="O" .AND. oPrinter:lactive)

* ---------------

// **********************************************************
//  Function: PrintOff( oPrinter )
//  Purpose:  Turns off the print job and spools output
//
//  Params:   oPrinter: The Printer object returned by PrintOn()
//
//  Returns:  aPointer to the DC_Printer() object.
// **********************************************************

FUNCTION PrintOff( oPrinter, cTitle )

LOCAL cErrorText, lStatus, lSendMail, cText, cAttachment, cHeading, ;
      cMemo

DEFAULT cTitle := saPrintOptions[PRN_TITLE]

// Resolve function arguments.
iif(!Valtype(oPrinter)=="O", oPrinter := DC_PrinterObject(),)

lSendMail := !Empty(saPrintOptions[PRN_TEMPFILE]) .AND. ;
             saPrintOptions[PRN_MODE] = 6

lStatus := DC_PrinterOff(oPrinter,,saPrintOptions[PRN_MODE] # 1)

Sleep(10)

// Handle email report request.
if lSendMail .AND. lStatus

  IF saPrintOptions[PRN_TEXTONLY]
    IF !Empty(saPrintOptions[PRN_EMAILMEMO])
      cMemo := MemoTrim(saPrintOptions[PRN_EMAILMEMO]) + CRLF + CRLF
    ELSE
      cMemo := ''
    ENDIF
    cHeading := 'Here is the report you requested:' + CRLF + CRLF

    cText := cMemo + ;
             cHeading + ;
             MemoRead(saPrintOptions[PRN_TEMPFILE])
  ELSE
    cText := saPrintOptions[PRN_EMAILMEMO]
    cAttachment := saPrintOptions[PRN_TEMPFILE]
  ENDIF

  if SendMail( nil, nil, alltrim(saPrintOptions[PRN_EMAILTO]), ;
               cTitle, nil, cAttachment, cText, @cErrorText )
       MsgBox('Report has been sent via email to: ' + ;
              Alltrim(saPrintOptions[PRN_EMAILTO]))
  else
    DC_WinAlert(cErrorText)
  endif

endif

FErase(saPrintOptions[PRN_TEMPFILE])

DC_PrinterObject(nil,.t.)

return (nil)

* -----------------

FUNCTION SendMail( cSMTPServer, cSender, cRecipient, cSubject, ;
                   cReplyTo, aAttachment, cText, cErrorText )

LOCAL oMail, oSender, oRecipient, oSmtp, lError := .t., cPrefix, ;
      cDefaultSMTPServer, cDefaultRecipient, cDefaultSender, aMailDef, ;
      aMailData, lSendMail := .F., nCode, cDiagFile, cCCList, cBCCList, i, ;
      cUserId, cPassword, cAttachment, cEmptyStr := Chr(0)

aMailDef := { 'SMTPServer', 'Recipient', 'Sender','UserID','Password' }
aMailData := { Space(100), Space(100), Space(100), Space(50), Space(50) }

DC_IniLoad( 'EMAIL.INI', ;
            { { 'SENDMAIL',  aMailData,  aMailDef } } )

IF !Empty(aMailData[1])
  cSMTPServer := aMailData[1]
ENDIF
IF !Empty(aMailData[2]) .AND. Empty(cRecipient)
  cRecipient := aMailData[2]
ENDIF
IF !Empty(aMailData[3])
  cSender := aMailData[3]
ENDIF
cUserId := aMailData[4]
cPassword := aMailData[5]

IF Empty(cSMTPServer)
  DC_WinAlert('You must set-up the Mail Server')
  cErrorText := 'No SMTP Server designated'
  EmailSetup()
  RETURN .F.
ENDIF

cSMTPServer := Alltrim(cSMTPServer)
cRecipient := Alltrim(cRecipient)
cSender := Alltrim(cSender)
cUserId := Alltrim(cUserId)
cPassword := Alltrim(cPassword)

IF Empty(cSMTPServer)
  cErrortext := 'No SMTP Server Address'
ELSEIF Empty(cSender)
  cErrorText := 'No Sender Address'
ELSEIF Empty(cRecipient)
  cErrorText := 'No Recipient Address'
ELSEIF Empty(cSubject)
  cErrortext := 'No Subject'
ELSE
  lError := .f.
ENDIF

IF lError
  dcbdebug cErrorText PAUSE
  RETURN .f.
ENDIF

cText := '<pre>' + CRLF + cText + CRLF + '</pre>' + CRLF
cText := Strtran(cText,Chr(13),Chr(13)+Chr(10))
cText := Strtran(cText,Chr(13)+Chr(10)+Chr(10),Chr(13)+Chr(10))

#ifdef SENDMAIL_ASINET

  oMail      := MIMEMessage():new()
  oSender    := MailAddress():new( Alltrim(cSender) )
  oRecipient := MailAddress():new( Alltrim(cRecipient) )

  // Assemble the e-mail
  oMail:setFrom( oSender     )
  oMail:setSubject( Alltrim(cSubject) )

  oMail:setMessage( cText )
  oMail:addRecipient( oRecipient  )
  IF !Empty(cReplyTo)
    oMail:addHeader( "Reply-To", Alltrim(cReplyTo) )
  ENDIF
  oMail:setContentType('text/html')

  IF !Empty(aAttachment)
    FOR i := 1 TO Len(aAttachment)
      oMail:attachFile( aAttachment[i] )
    NEXT
  ENDIF

  oSmtp := SMTPClient():new( Alltrim(cSMTPServer) )
  IF oSmtp:connect()
    oSmtp:send( oMail )
    oSmtp:disconnect()
    lError := .f.
  ELSE
    cErrorText := "Unable to connect to mail server"
  ENDIF

#endif

#ifdef SENDMAIL_MARSHALLSOFT

  DEFAULT cReplyTo := cSender, ;
          cAttachment := '', ;
          cCCList := '', ;
          cBCCList := ''

  cReplyTo := '<' + cReplyTo + '>'
  cSender := '<' + cSender + '>'
  cRecipient := '<' + cRecipient + '>'

  IF !Empty(aAttachment)
    FOR i := 1 TO Len(aAttachment)
      IF File(aAttachment[i])
        cAttachment += aAttachment[i] + IIF( i < Len(aAttachment),';','' )
      ENDIF
    NEXT
  ENDIF

  nCode := XseeAttach(1, 67837799) // shareware version
  IF nCode < 0
    cErrorText := "Cannot attach SEE"
    dcbdebug cErrorText pause
    RETURN .F.
  ENDIF

  cDiagFile := 'EMAIL.LOG'
  nCode := XseeStringParam(0, SEE_LOG_FILE, @cDiagFile)

  // enable SMTP ("AUTH PLAIN" / "AUTH LOGIN" / "CRAM-MD5") authentication
  // nCode := XseeIntegerParam(0, SEE_ENABLE_ESMTP, AUTHENTICATE_PLAIN)
  nCode := XseeIntegerParam(0, SEE_ENABLE_ESMTP, 4)

  nCode := XseeStringParam(0, SEE_SET_USER,    @cUserId)
  nCode := XseeStringParam(0, SEE_SET_SECRET,  @cPassword)

  * enable HTML quoting
  nCode := XseeIntegerParam(0,SEE_QUOTED_PRINTABLE, QUOTED_HTML)
  * specify iso-8859 HTML charset
  nCode := XseeIntegerParam(0,SEE_HTML_CHARSET, CHARSET_8859)

  nCode := XseeSmtpConnect(0, @cSMTPServer, @cSender, @cReplyTo)

  IF nCode < 0
    cErrorText := SPACE(128)
    nCode := XseeErrorText(0,nCode,@cErrorText,128)
  ELSE
    * send email message
    Sleep(10)

    nCode = XseeSendHTML(0,@cRecipient,@cCCList,@cBCCList,@cSubject, ;
                         @cText,@cEmptyStr,@cEmptyStr,@cAttachment)

    /*
    nCode = XseeSendEmail(0,@cRecipient,@cCCList,@cBCCList,@cSubject, ;
                         @cText,@cAttachment)
    */

    IF nCode < 0
      cErrorText := SPACE(128)
      nCode := XseeErrorText(0,nCode,@cErrorText,128)
    ELSE
      lError := .F.
    ENDIF
  ENDIF
  nCode := XseeClose(0)
  nCode := XseeRelease()

#endif

IF !Empty(cErrorText)
  dcbdebug cErrorText
  lError := .T.
ENDIF

RETURN !lError

* -----------------

FUNCTION EmailSetup()

LOCAL GetList[0], GetOptions, cSMTPServer := '', cSMTPRecipient := '', ;
      cSMTPSender := '', cSMTPUserName := '', cSMTPPassword := '', aData, ;
      aRef, lStatus

// Load [SENDMAIL] group of EMAIL.INI

aRef := { ;
  'SMTPServer', ;
  'Recipient', ;
  'Sender', ;
  'UserName', ;
  'Password' }

aData := { ;
  Pad(cSMTPServer,100), ;
  Pad(cSMTPRecipient,100), ;
  Pad(cSMTPSender,100), ;
  Pad(cSMTPUserName,30), ;
  Pad(cSMTPPassword,30) }

DC_IniLoad('EMAIL.INI','SENDMAIL',aData, aRef)

cSMTPServer := aData[1]
cSMTPRecipient := aData[2]
cSMTPSender := aData[3]
cSMTPUserName := aData[4]
cSMTPPassword := aData[5]

@ 1,2 DCSAY 'Server Name' GET cSMTPServer GETSIZE 60 ;
         TOOLTIP 'Server fully qualified name or IP address'

@ 2,2 DCSAY 'Recipient Email' GET cSMTPRecipient GETSIZE 60 ;
         TOOLTIP 'Email Address of DEFAULT recipient'

@ 3,2 DCSAY 'Sender Email' GET cSMTPSender GETSIZE 60 ;
         TOOLTIP 'Email Address of DEFAULT sender'

@ 4,2 DCSAY 'User Name' GET cSMTPUserName ;
         TOOLTIP 'User Name or ID for SMTP Login Authentication'

@ 5,2 DCSAY 'Password' GET cSMTPPassword ;
         TOOLTIP 'Password for SMTP Login Authentication' PASSWORD

DCGETOPTIONS ;
   SAYRIGHTBOTTOM ;
   SAYWIDTH 120 ;
   TABSTOP

DCREAD GUI ;
   FIT ;
   OPTIONS GetOptions ;
   ADDBUTTONS ;
   TITLE 'E-Mail Setup' ;
   MODAL ;
   TO lStatus

IF lStatus

  aData := { ;
   cSMTPServer, ;
   cSMTPRecipient, ;
   cSMTPSender, ;
   cSMTPUserName, ;
   cSMTPPassword }

  DC_IniSave('EMAIL.INI','SENDMAIL',aData, aRef)

ENDIF

RETURN nil

* -----------------

FUNCTION YesNoBox( cHeader, cTitle, aMessage, nWidth, nChoice )

LOCAL GetList[0], GetOptions, nRow := 1, lStatus, aButtons, i

DEFAULT nWidth := 60, ;
        nChoice := 1

IF Valtype(aMessage) = 'C'
  aMessage := { aMessage }
ENDIF

@ nRow++, 1 DCSAY cHeader SAYSIZE nWidth, 1.2 SAYCENTER FONT '11.Arial Bold'
@ nRow++, 1 DCSTATIC TYPE XBPSTATIC_TYPE_RAISEDBOX SIZE nWidth, .1
FOR i := 1 TO Len(aMessage)
  @ nRow++, 1 DCSAY aMessage[i] SAYSIZE nWidth SAYCENTER
NEXT

aButtons := { ;
   {'~Yes',70,22,{||DC_ReadGuiEvent(DCGUI_EXIT_OK,GetList)}}, ;
   {'~No',70,22,{||DC_ReadGuiEvent(DCGUI_EXIT_ABORT,GetList)}} }

DCGETOPTIONS ;
   NORESIZE ;
   NOMINBUTTON ;
   NOMAXBUTTON ;
   BUTTONS aButtons ;
   BUTTONALIGN DCGUI_BUTTONALIGN_CENTER

DCREAD GUI ;
   FIT ;
   OPTIONS GetOptions ;
   TITLE cTitle ;
   MODAL ;
   SETFOCUS IIF(nChoice==1,'DCGUI_BUTTON_CUSTOM_1','DCGUI_BUTTON_CUSTOM_2') ;
   SETAPPWINDOW ;
   TO lStatus ;
   TIMEOUT 300

return lStatus

* ----------------

FUNCTION MemoTrim( cMemo, cQuote, cEndofLine, cBlankLine, lTrim )

LOCAL cOut := '', cLine, nLines, i

cQuote     := IIF(Valtype(cQuote)='C',cQuote,'')
cEndofLine := IIF(Valtype(cEndofLine)='C',cEndofLine,'')
cBlankLine := IIF(Valtype(cBlankLine)='C',cBlankLine,'')
lTrim      := IIF(Valtype(lTrim)='L',lTrim,.f.)

nLines := MLCOUNT(cMemo)
FOR i := nLines TO 1 STEP -1
  IF !EMPTY(TRIM(MEMOLINE(cMemo,,i)))
    EXIT
  ENDIF
NEXT
nLines := i
FOR i := 1 TO nLines
  cLine := TRIM( MEMOLINE( cMemo,, i ) )
  IF lTrim
    cLine := AllTrim(cLine)
  ENDIF
  IF Empty(cLine)
    cLine := cBlankLine
  ENDIF
  IF EMPTY(cLine) .AND. i=nLines
    EXIT
  ENDIF
  cLine := cLine + cEndofLine + CHR(13) +CHR(10)
  cOut := cOut + cQuote + cLine
NEXT
RETURN cOut


