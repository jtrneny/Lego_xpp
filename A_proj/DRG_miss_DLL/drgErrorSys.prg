//////////////////////////////////////////////////////////////////////
//
//  ERRORSYS.PRG
//
//  Copyright:
//      Alaska Software, (c) 1997-2003. All rights reserved.
//      Parts by DRGS d.o.o., 2003.
//  Contents:
//      Install default error code block
//
//  Remarks:
//      Function ErrorSys() is always called at program startup
//
//////////////////////////////////////////////////////////////////////

#include "Xbp.ch"
#include "drg.ch"
#include "Error.ch"


/*
 *  language specific string constant which are used in the error handler
 */
#define EHS_CANCEL            "Cancel"
#define EHS_EXIT_WITH_LOG     "Exit with LOG file"
#define EHS_RETRY             "Retry"
#define EHS_IGNORE            "Ignore"
#define EHS_OS_ERROR          ";Operating system error : "
#define EHS_CALLED_FROM       "Called from"
#define EHS_XPP_ERROR_MESSAGE "Xbase++ Error Message"
#define EHS_ERROR             "Error "
#define EHS_WARNING           "Warning "
#define EHS_DESCRIPTION       ";Description : "
#define EHS_FILE              ";File : "
#define EHS_OPERATION         ";Operation : "
#define EHS_LOG_OPEN_FAILED   "Unable to open error log file"
#define EHS_ERROR_LOG_OF      "ERROR LOG of "
#define EHS_DATE              " Date:"
#define EHS_XPP_VERSION       "Xbase++ version     :"
#define EHS_OS_VERSION        "Operating system    :"
#define EHS_LOG_WRITTEN_TO(cFile) "Error log was written to the file "+ cFile

***********************************
* Install default error code block
***********************************
PROCEDURE drgErrorSys()
RETURN

*************************************
* Default error handler function
*************************************
FUNCTION drgStandardEH( oError )
LOCAL i, cMessage, aOptions, nOption, nSeverity
LOCAL oDacSession, oSession
LOCAL oXbp

  /* Check if error is handled automatically */
  DO CASE

  /* Division by zero results in 0 */
  CASE oError:genCode == XPP_ERR_ZERODIV
    RETURN 0

  case oError:genCode == XPP_ERR_FIELD_READONLY
**    if isWorkVersion .or. ( 'SYS_' $ syOpravneni )
**    else
      retur .f.
**    endif

  /* Zero divide by zero is also 0 and may occur
   * in operations like /, /=, % and %=
   */
  CASE oError:genCode == XPP_ERR_NUMERR
    IF "/" $ oError:operation .OR. "%" $ oError:operation
      IF oError:args[-1] == 0
        RETURN 0
      ENDIF
    ENDIF

  /* Error opening a file on a network */
  CASE oError:genCode == XPP_ERR_OPEN  .AND. ;
       oError:osCode  == 32            .AND. ;
       oError:canDefault
    RETURN(.F.)

  /* No lock is set */
  CASE oError:genCode == XPP_ERR_APPENDLOCK .AND. ;
       oError:canDefault
    RETURN(.F.)


  ENDCASE

  oSession := DbSession()
  IF oSession = NIL .AND. IsFunction("DacSession", FUNC_CLASS)
     oDacSession := &("DacSession()")
     oSession := oDacSession:getDefault()
  ENDIF
  IF oSession != NIL
      IF oSession:getLastError() != 0
          oError:cargo := {oError:cargo, ;
                           oSession:getLastError(),;
                           oSession:getLastMessage() }
      ENDIF
  ENDIF

  /* No default handling defined: create error message */
  cMessage := ErrorMessage( oError )

  /* Array for selection */
  aOptions := { EHS_CANCEL }

  IF oError:canRetry
     AAdd( aOptions, EHS_RETRY )
  ENDIF

  IF oError:canDefault
     AAdd( aOptions, EHS_IGNORE )
  ENDIF

  IF ! Empty( oError:osCode )
     cMessage += EHS_OS_ERROR + LTrim(Str(oError:osCode)) +;
                 ";" + DosErrorMessage(oError:osCode)
  ENDIF

  IF oError:canDefault .AND. oError:canRetry
     nOption := XBPMB_ABORTRETRYIGNORE
  ELSEIF oError:canRetry
     nOption := XBPMB_RETRYCANCEL
  ELSEIF oError:canDefault
     nOption := XBPMB_OKCANCEL
  ELSE
     nOption := XBPMB_CANCEL
  ENDIF

  i := 1
  DO WHILE !Empty( ProcName(++i) )
     cMessage+= ";" + EHS_CALLED_FROM +" " + Trim( ProcName(i) )   + "(" + ;
                            LTrim( Str( ProcLine(i) ) ) + ")"
  ENDDO
  i := 0

/* select icon for ConfirmBox() */
  DO CASE
  CASE oError:severity == XPP_ES_FATAL
    nSeverity := XBPMB_CRITICAL
  CASE oError:severity == XPP_ES_ERROR
    nSeverity := XBPMB_CRITICAL
  CASE oError:severity == XPP_ES_WARNING
    nSeverity := XBPMB_WARNING
  OTHERWISE
    nSeverity := XBPMB_INFORMATION
  ENDCASE
   /* Display ConfirmBox() */
  oXbp := SetAppFocus()
  i := ConfirmBox( , StrTran( cMessage, ";", Chr(13) ), ;
                   drgNLS:msg('Program Error Message!'), ;
                   nOption, ;
                   nSeverity + XBPMB_APPMODAL+XBPMB_MOVEABLE )

*
  IF i == XBPMB_RET_RETRY
    RETURN .T.
  ELSEIF i == XBPMB_RET_IGNORE
    RETURN .F.
  ENDIF
  SetAppFocus(oXbp)
*Dump error to file
  drgDumpError( oError )

*  stopnem connect
// ne   DBCOMMITALL()
// ne   DBCLOSEALL()

**   if( oSession != NIL, osession:disconnect(), nil)

  Break( oError )

RETURN .F. /* The compiler expects a return value */

***************************************
*  Creates a string with the important Informations
*  from the error object
***************************************
STATIC FUNCTION ErrorMessage( oError )

   /* Check if this is an error or warning message */
   LOCAL cMessage := ;
         IIf( oError:severity > XPP_ES_WARNING, ;
                          EHS_ERROR, EHS_WARNING )

   /* Add name of subsystem or 'unkown subsytem' */
   IF Valtype( oError:subSystem ) == "C"
      cMessage += oError:subSystem
   ELSE
      cMessage += "????"
   ENDIF

   /* Add error code of subsystem */
   IF Valtype( oError:subCode ) == "N"
      cMessage += "/"+ LTrim(Str(oError:subCode))
   ELSE
      cMessage += "/????"
   ENDIF

   /* Optional: Add error description */
   IF Valtype( oError:description ) == "C"
      cMessage += drgNLS:msg( EHS_DESCRIPTION ) + ;
                   oError:description
   ENDIF

   /* Optional: Add name of the file which were the error occured */
   IF ! Empty( oError:fileName )
      cMessage += drgNLS:msg( EHS_FILE ) + oError:fileName
   ENDIF

   /* Optional: Add name of the operation which caused the error */
   IF ! Empty( oError:operation )
      cMessage += drgNLS:msg( EHS_OPERATION ) + oError:operation
   ENDIF

   /* Add Thread ID of the thread on which the error occured */
   cMessage += ";Thread ID : " + ;
                LTrim(Str(oError:thread))

   IF Valtype(oError:cargo)="A" .AND. len(oError:cargo) == 3
      IF ValType(oError:cargo[1])=="C"
         cMessage += ";" +  LineSplit(oError:cargo[1], 50)
      ENDIF
      cMessage += ";" +  LineSplit(oError:cargo[3], 50)
   ENDIF
RETURN cMessage

***************************************************************************
* Dumps error to standard error log file.
*
* /b< oError >b/ : Error object.
***************************************************************************
PROCEDURE drgDumpError(oError)
LOCAL cLog, i
  cLog := REPLICATE('-', 80) + CRLF
  cLog += '::01:: RunTime error!' + CRLF + ;
          'Time  : ' + DTOC( DATE() ) + '@' + TIME() + CRLF + ;
          'oError:args         :' + CRLF

  cLog += "Firma          : " +logFirma       + CRLF + ;
          "Uživatel       : " +logOsoba       + CRLF + ;
          "Verze Souboru  : " +verzeAsys[3,2] + CRLF + ;
          "Verze Databáze : " +specialBuild   + CRLF

  IF Valtype(oError:Args) == 'A'
    AEval( oError:Args, ;
         {|x,y| cLog += Space(9) + "-> VALTYPE : ", y := Valtype(x) , ;
         IIF( y=="O", cLog += "CLASS : " + x:className() + CRLF  , ;
                      cLog += "VALUE : " + Var2Char(x) + CRLF ) } )
  ELSE
    cLog += Space(10) + "-> NIL"+ CRLF
  ENDIF
*
  cLog += CRLF + ;
   "oError:description  : " + oError:description   + CRLF + ;
   "oError:filename     : " + oError:filename      + CRLF + ;
   "oError:genCode      : " + STR(oError:genCode)  + CRLF + ;
   "oError:operation    : " + oError:operation     + CRLF + ;
   "oError:osCode       : " + STR(oError:osCode)   + CRLF + ;
   "oError:severity     : " + STR(oError:severity) + CRLF + ;
   "oError:subCode      : " + STR(oError:subCode)  + CRLF + ;
   "oError:subSystem    : " + oError:subSystem     + CRLF + ;
   "oError:thread       : " + STR(oError:thread)   + CRLF + CRLF + ;
   "CALLSTACK:"+ CRLF

  i := 1
  WHILE !EMPTY( ProcName(++i) )
    cLog += "Called from " + Trim( ProcName(i) )   + "(" + ;
                            LTrim( Str( ProcLine(i) ) ) + ")" + CRLF
  ENDDO

//  info_UsedWorkAreas(@clog)

  drgLog:write(cLog)

* Active thread must be killed before msgBox appears
  drgServiceThread:setActiveThread(0)
  drgMsgBox(drgNLS:msg('Unrecoverable error has ocured. Please see error log for more information!'), XBPMB_CRITICAL)
*  Break()
RETURN


*
** informace o otevøených pracovních souboreh pøi pádu aplikace
static function info_UsedWorkAreas(pclog)
  local  asaved := {}
  local  x, y, pa, cval_1, cval_2

  WorkSpaceEval( {|| aadd( asaved, SaveWorkarea() ) } )

  pcLog := REPLICATE('-', 80) + CRLF

  for x := 1 to len( asaved) step 1
    for y := 1 to len(asaved[x]) step 1
      pa     := asaved[x,y]

      cval_1 := valToStr( pa[1] )
      cval_2 := valToStr( pa[2] )

      pcLog  += pa[3] +cval_1 +if( .not. empty(cval_2), ', ' +cval_2, '') +CRLF
    next
  next
return nil


static function SaveWorkarea()
  return { { Alias( Select() ) , ''                   , 'Alias       -> ' } , ;
           { OrdSetFocus()     , ''                   , 'OrdSetFocus -> ' } , ;
           { RecNo()           , ''                   , 'RecNo       -> ' } , ;
           { ads_getAof()      , ''                   , 'ads_getAof  -> ' } , ;
           { dbrselect(1)      , dbrelation(1)        , 'Relation    -> ' } , ;
           { dbscope(SCOPE_TOP), dbscope(SCOPE_BOTTOM), 'DbScope -> '     }   }


static function valToStr( x)
  Local  cStr := '', cTyp := ValType ( x)
  Local  nLen

  Do Case
  Case cTyp == 'C'  ;  cStr := AllTrim( x)
  Case cTyp == 'N'  ;  cStr := AllTrim( Str( x))
  Case cTyp == 'D'  ;  cStr := AllTrim( dToC( x))
  Case cTyp == 'L'  ;  cStr := If( x, 'Ano', 'Ne ')
  EndCase
return( cStr)


/* Split large line for Alert()-box output */
/*
FUNCTION LineSplit(cMessage, nMaxCol)
LOCAL i
LOCAL cLines := ""
LOCAL nLines

   nLines := MlCount(cMessage, nMaxCol,, .T.)
   FOR i:= 1 TO nLines
        cLines += Rtrim(MemoLine(cMessage, nMaxCol, i,,.T.)) +";"
   NEXT
   IF cLines[-1]==";"
      cLines := Left(cLines,len(cLines)-1)
   ENDIF
RETURN cLines

*/