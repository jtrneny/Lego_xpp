//////////////////////////////////////////////////////////////////////
//
//  drgLog.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgLog object takes care for logging
//
//   Remarks:
//
//////////////////////////////////////////////////////////////////////
#include "Common.ch"
#include "Appevent.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "xbp.ch"

CLASS drgLog
  EXPORTED:
  VAR     cargo

  METHOD  init
  METHOD  destroy
  METHOD  log
  METHOD  write
  METHOD  dumpError

  HIDDEN:
  VAR     logName

ENDCLASS

***************************************************************************
* Initialize drgLog object
***************************************************************************
METHOD drgLog:init()
  local  cver := 'A++' +verzeAsys[3,2]

  if isWorkVersion
    ::logName := drgIni:dir_WORK + ALLTRIM(drgINI:appName) + '.LOG'
  else
    ::logName := drgIni:dir_WORK +allTrim( cVer ) +'.LOG'
  endif

*  ::logName := drgIni:dir_WORK + ALLTRIM(drgINI:appName) + '.LOG'
*  ::logName := drgIni:dir_WORK + 'A.LOG'
RETURN self

***************************************************************************
* Logs a message
***************************************************************************
METHOD drgLog:log(logString, errNo)
LOCAL st, errStr
  DEFAULT errNo TO 1
  errStr := PADL(ALLTRIM(STR(errNo)),2,'0')

  st := REPLICATE('-', 80) + CRLF
  st += '::' + errStr + '::' + CRLF + logString + CRLF
  ::write(st)
RETURN self

***************************************************************************
* Writes message to LOG file
***************************************************************************
METHOD drgLog:write(cMsg)
  local  F
  local  cver:= 'A++' +str(usrIdDB)      // +'_' +verzeAsys[3,2]

  if isWorkVersion
    ::logName := drgIni:dir_WORK + ALLTRIM(drgINI:appName) + '.LOG'
  else
    ::logName := drgIni:dir_WORK +strTran( cVer, ' ', '' ) +'.LOG'
  endif

  IF FILE(::logName)
    F:=FOPEN(::logName,2)
  ELSE
    F:=FCREATE(::logName)
  ENDIF
  cMsg += CRLF + 'LOG cargo           : ' + drg2String(::cargo) + CRLF
  FSEEK(F,0,2)
  FWRITE(F,cMsg + CRLF)
  FCLOSE(F)
  ::cargo := NIL
RETURN self

***************************************************************************
* Dump error log to LOG FILE
***************************************************************************
METHOD drgLog:dumpError(oError)
RETURN self

***************************************************************************
* Dump error log to LOG FILE
***************************************************************************
METHOD drgLog:destroy()
  ::logName := ;
  ::cargo   := ;
               NIL
RETURN self


//////////////////////////////////////////////////////////////////////
//
//  drgErrLog.PRG
//
//  Copyright:
//       Damjan Rems, (c) 2001. All rights reserved.
//
//  Contents:
//       drgErrLog is used for displaying error log window
//
//  Remarks:
//
//
//////////////////////////////////////////////////////////////////////

CLASS drgErrorLog FROM drgUsrClass
  EXPORTED:

    VAR     aLog

    METHOD  destroy             // release all resources used by this object

    METHOD  getForm
    METHOD  logPrint
    METHOD  logDelete
    METHOD  logMail
    METHOD  drgUsrIconBar
    METHOD  drgUsrDialogMenu

ENDCLASS

**********************************************************************
* Returns form for this drgErrorLog dialog.
**********************************************************************
METHOD drgErrorLog:getForm()
  local  farr := {}
  local  cver := 'A++' +str(usrIdDB) +'_' +verzeAsys[3,2]
//  local  cver := 'A++' +strTran( verzeAsys[3,2], '.', '_' )
  *
  local  logName

* Set dialog title and Icon
  ::dialogTitle := drgNLS:msg('Error log')
  ::dialogIcon  := DRG_ICON_ERRLOG

  if isWorkVersion
    logName := drgIni:dir_WORK + ALLTRIM(drgINI:appName) + '.LOG'
  else
    logName := drgIni:dir_WORK +allTrim( cVer ) +'.LOG'
  endif

  ::aLog  := MemoRead( logName )

* There is a bug in MLE
  IF LEN(::aLog) > 16000
    ::aLog := RIGHT( ::aLog, 16000)
  ENDIF

  farr := ;
  {"TYPE(drgForm) SIZE(60,20) GUILOOK(Action:N,Message:N)" , ;
   "TYPE(MLE) NAME(aLog) FPOS(0,0) SIZE(60,20) READONLY(Y)" }

RETURN drgFormContainer():new(farr)

**********************************************************************
* Print current log file to printer.
**********************************************************************
METHOD drgErrorLog:logPrint()
RETURN self

**********************************************************************
* Delete current log.
**********************************************************************
METHOD drgErrorLog:logDelete()
  IF drgIsYESNO(drgNLS:msg('Delete log file?' ))
    FERASE(drgINI:dir_WORK + drgINI:appName + '.LOG')
  ENDIF
RETURN self

**********************************************************************
* Mail log to administrator
**********************************************************************
METHOD drgErrorLog:logMail()
RETURN self

**********************************************************************
* Creates dialog IconBar for drgErrorLog usr defined class.
**********************************************************************
METHOD drgErrorLog:drgUsrIconBar(oParent, oBord)
LOCAL iconBar, size, pos, ms
  DEFAULT oBord TO parent:dialog:drawingArea

  ms := drgNLS:msg('Quit dialog,Print log,Mail log to administrator,Delete log file,Help')

* Get size of drawing area
  size := ACLONE( oParent:dataAreaSize )
  size[2] := 24

* Get position of iconBar area
  pos  := ACLONE( oParent:dataAreaSize )
  pos[1] := 0
  pos[2] += 0

* create iconBar = drgActions object
  iconBar := drgActions():new(oParent)
  iconBar:create(oBord, pos, size)
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms),drgEVENT_QUIT,.F.)
  pos[1] += 30
  iconBar:addAction( pos, size, 1, DRG_ICON_PRINT, gDRG_ICON_PRINT,,, drgParse(@ms),'logPrint',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_MAIL, gDRG_ICON_MAIL,,, drgParse(@ms),'logMail',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_TRASH, gDRG_ICON_TRASH,,, drgParse(@ms),'logDelete',.F.)
  pos[1] += 30
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

RETURN iconBar

**********************************************************************
* Creates dialog Menu for drgErrorLog usr defined class.
**********************************************************************
METHOD drgErrorLog:drgUsrDialogMenu( myMenuBar )
LOCAL myMenu, ms

  ms := drgNLS:msg('~Dialog,~Print log,Send as ~Mail,~Erase,~Quit,~Help,Help on log,Help index')

  myMenu       := XbpMenu():new(myMenuBar)
  myMenu:title := drgParse(@ms)
  myMenu:create()

  myMenu:addItem( {drgParse(@ms) + TAB + "Ctrl+P", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logPrint', '0', obj ) }} )
  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+M", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logMail', '0', obj ) }} )
  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+E", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logDelete', '0', obj ) }} )
  myMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+Q", ;
                   {|mp1,mp2,obj| PostAppEvent( drgEVENT_QUIT, mp1, mp2, obj ) }} )

  myMenuBar:addItem( {myMenu, NIL} )

* Help menu
  myMenu := XbpMenu():new(myMenuBar)
  myMenu:title := drgParse(@ms)
  myMenu:create()

  myMenu:addItem( {drgParse(@ms)+TAB+"F1", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_HELP, mp1, mp2, obj ) }} )
  myMenu:addItem( {drgParse(@ms), ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logHelp', '0', obj ) }} )

  myMenuBar:addItem( {myMenu, NIL} )
RETURN

*********************************************************************
* Destroys drgErrorLog object
*********************************************************************
METHOD drgErrorLog:destroy
  ::drgUsrClass:destroy()
  ::aLog := NIL
RETURN self