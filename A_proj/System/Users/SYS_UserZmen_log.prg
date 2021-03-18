
#include "Common.ch"
#include "Appevent.ch"
#include "drg.ch"
#include "drgRes.ch"
#include "xbp.ch"

********************************************************************************
* Pro zobrazení uživatelských zmìn na záznamu
********************************************************************************
CLASS SYS_UserZmen_Log FROM drgUsrClass

  EXPORTED:
    VAR     cLog, cFile
    *
    METHOD  init, destroy, getForm, EventHandled
    METHOD  logPrint, logMail
    *
    METHOD  drgUsrIconBar, drgUsrDialogMenu
ENDCLASS

********************************************************************************
METHOD SYS_UserZmen_Log:init( parent)
  ::drgUsrClass:init(parent)
  ::cFile := ::drgDialog:cargo:cFile
RETURN self

********************************************************************************
METHOD SYS_UserZmen_Log:getForm()
  LOCAL  aFC := {}

  ::dialogTitle := drgNLS:msg('Archiv zmìn na záznamu [ & ]', ::cFile)
  ::dialogIcon  := DRG_ICON_ERRLOG
  ::cLog        := (::cFile)->mUserZmenR
* There is a bug in MLE
  IF LEN(::cLog) > 16000
    ::cLog := LEFT( ::cLog, 16000)
  ENDIF

  aFC := {"TYPE(drgForm) SIZE(60,20) GUILOOK(Action:N,Message:N)",;
          "TYPE(MLE) NAME(cLog) FPOS(0,0) SIZE(60,20) READONLY(Y)" }

RETURN drgFormContainer():new( aFC)

********************************************************************************
METHOD SYS_UserZmen_Log:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,,, oDialog:dialog)
        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .t.

********************************************************************************
METHOD SYS_UserZmen_Log:logPrint()
RETURN self

********************************************************************************
METHOD SYS_UserZmen_Log:logMail()
RETURN self

**********************************************************************
METHOD SYS_UserZmen_Log:drgUsrIconBar(oParent, oBord)
LOCAL iconBar, size, pos, ms
  DEFAULT oBord TO parent:dialog:drawingArea

*  ms := drgNLS:msg('Quit dialog,Print log,Mail log to administrator,Delete log file,Help')
  ms := drgNLS:msg('Quit dialog,Print log,Mail log to administrator,Help')

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
*  iconBar:addAction( pos, size, 1, DRG_ICON_TRASH, gDRG_ICON_TRASH,,, drgParse(@ms),'logDelete',.F.)
*  pos[1] += 30
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

RETURN iconBar

**********************************************************************
METHOD SYS_UserZmen_Log:drgUsrDialogMenu( myMenuBar )
LOCAL myMenu, ms

*  ms := drgNLS:msg('~Dialog,~Print log,Send as ~Mail,~Erase,~Quit,~Help,Help on log,Help index')
  ms := drgNLS:msg('~Dialog,~Print log,Send as ~Mail,~Quit,~Help,Help on log,Help index')

  myMenu       := XbpMenu():new(myMenuBar)
  myMenu:title := drgParse(@ms)
  myMenu:create()

  myMenu:addItem( {drgParse(@ms) + TAB + "Ctrl+P", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logPrint', '0', obj ) }} )
  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+M", ;
                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logMail', '0', obj ) }} )
*  myMenu:addItem( {drgParse(@ms) + TAB + "Alt+E", ;
*                  {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'logDelete', '0', obj ) }} )
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

********************************************************************************
METHOD SYS_UserZmen_Log:destroy
*  ::drgUsrClass:destroy()
  ::cLog  := ;
  ::cFile := ;
  NIL
RETURN self