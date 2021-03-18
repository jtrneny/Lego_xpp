//////////////////////////////////////////////////////////////////////
//
//  \TC Main application menu TC\
//
//  Copyright:
//      DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       Main application menu
//
//  Remarks:
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "gra.ch"
#include "drgRes.ch"

#include "..\Asystem++\drgApp++.ch"
#include "..\Asystem++\Asystem++.ch"

CLASS drgApp_Menu FROM drgUsrClass
EXPORTED:
  VAR     dummy
  VAR     posProject
  VAR     oPopMenu

  METHOD  destroy

  METHOD  getForm
  METHOD  drgUsrDialogMenu
  METHOD  drgUsrIconBar
  METHOD  editDBD
  METHOD  editREF
  METHOD  createApp
  METHOD  testForm

  METHOD  doMenuProject
  METHOD  doSettings
  METHOD  doNewProject
  METHOD  doOpenProject
  METHOD  doDeleteProject

ENDCLASS

*********************************************************************
* Returns form definition for drgAppMenu
*********************************************************************
METHOD drgApp_Menu:getForm(drgObj)
LOCAL oDrg, drgFC
  drgFC := drgFormContainer():new()

  DRGFORM INTO drgFC SIZE 60,0 TITLE 'Build DRG application' GUILOOK 'Action:N,Message:N' BORDER 4
* Dummy field must be created, because otherwise Form object doesn't know where to start
  DRGGET dummy  INTO drgFC FPOS 2,2 FLEN 1 PICTURE 'X'

  ::dummy      := ''
RETURN drgFC

***********************************************************************
* User define menubar for drgAppMenu.
***********************************************************************
METHOD drgApp_Menu:drgUsrDialogMenu(oMenuBar)
LOCAL ms, oMenu

  ms := drgNLS:msg( ;
  '~Dialog,E~xit,' + ;
  '~Actions,Create ~default files,Edit ~Reference DBD,Edit D~BD,' + ;
  '~Help,App Help,Help on,Help index,About')

  oMenu       := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()
  oMenu:addItem( {drgParse(@ms)+TAB+"Alt+X", ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_QUIT, mp1, mp2, obj ) }} )
  oMenubar:addItem( {oMenu, NIL} )

* Edit menu
  oMenu       := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()
  oMenu:addItem( {drgParse(@ms), ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'createApp', '0', obj ) }} )
  oMenu:addItem( {drgParse(@ms), ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'editRef', '0', obj ) }} )
  oMenu:addItem( {drgParse(@ms), ;
                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'editDBD', '0', obj ) }} )
*  oMenu:addItem( {drgParse(@ms)+TAB+"Ctrl+S", ;
*                 {|mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'editForm', '0', obj ) }} )
  oMenubar:addItem( {oMenu, NIL} )


* Help menu
  oMenu := XbpMenu():new(oMenuBar)
  oMenu:title := drgParse(@ms)
  oMenu:create()

  oMenu:addItem( {drgParse(@ms), NIL} )
  oMenu:addItem( {drgParse(@ms)+TAB+"F1", NIL} )
  oMenu:addItem( {drgParse(@ms)+TAB+"Alt+F1", NIL} )
  oMenu:addItem( {NIL, NIL, XBPMENUBAR_MIS_SEPARATOR, 0} )
  oMenu:addItem( {drgParse(@ms) , NIL} )

  oMenubar:addItem( {oMenu, NIL} )
RETURN self

**********************************************************************
* User defined iconbar for drgApp program.
**********************************************************************
METHOD drgApp_Menu:drgUsrIconBar(parent, oBord)
LOCAL iconBar, size, pos, ms
  DEFAULT oBord TO parent:dialog:drawingArea

  ms := drgNLS:msg('Exit,Create default application files,Edit Reference file,Edit DBD,Edit Form,Test Form,Help')
* Get size of drawing area
  size := ACLONE( parent:dataAreaSize )
  size[2] := 24

* Get position of iconBar area
  pos  := ACLONE( parent:dataAreaSize )
  pos[1] := 0
  pos[2] += 0

* create iconBar = drgActions object
  iconBar := drgActions():new(parent)
  iconBar:create(oBord, pos, size)
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms), drgEVENT_QUIT,.F.)
  pos[1] += 34
  iconBar:addAction( pos, size, 1, icDRGAPP_NEW, igDRGAPP_NEW,,, drgParse(@ms), 'createApp',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, icDRGAPP_REF, igDRGAPP_REF,,, drgParse(@ms), 'editRef',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, icDRGAPP_DBD, igDRGAPP_DBD,,, drgParse(@ms), 'editDBD',.F.)
*  pos[1] += 24
*  iconBar:addAction( pos, size, 1, icDRGAPP_FORM, igDRGAPP_FORM,,, drgParse(@ms),'editForm',.F.)
  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)
  pos[1] += 4
/*
  iconBar:addAction( pos, size, 1, icDRGAPP_SET, igDRGAPP_SET,,, 'IDE settings', 'doSettings',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, icDRGAPP_NEW, igDRGAPP_NEW,,, 'Project', 'doMenuProject',.F.)
  ::posProject := ACLONE(pos)
  pos[1] += 24
*/
*  iconBar:addAction( pos, size, 1, icDRGAPP_DIALOG, igDRGAPP_DIALOG,,, drgParse(@ms), 'testForm',.F.)
*  pos[1] += 26
*  iconBar:addAction( pos, size, 1, icDRGAPP_CLOSE, igDRGAPP_CLOSE,,, drgParse(@ms), 'testForm',.F.)
*  pos[1] += 26
*  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

RETURN iconBar

*************************************************************************
* Call DBD editor.
*************************************************************************
METHOD drgApp_Menu:editDBD()
LOCAL oDlg, cName, oDialog, cFileName
* Create system file open dialog
  oDlg := XbpFileDialog():new( AppDesktop() )
  oDlg:create()
*
  oDlg:title := drgNLS:msg('Open DBD')
  IF ( cName := oDlg:open('*.DBD',.T.) ) != NIL
    cFileName := parseFileName(cName)
    IF UPPER(LEFT(cFileName, 3) ) != 'REF'
      DRGDIALOG FORM 'drgApp_Edit_DBD' PARENT ::drgDialog CARGO cName MODAL DESTROY
    ELSE
      drgMsgBox(drgNLS:msg('Edit reference file with REF file editor!') )
    ENDIF
  ENDIF
  oDlg:destroy()

RETURN self

*************************************************************************
* Call REF DBD editor.
*************************************************************************
METHOD drgApp_Menu:editREF()
LOCAL oDlg, cName, cFileName, oDialog
* Create system file open dialog
  oDlg := XbpFileDialog():new(AppDesktop())
  oDlg:create()
  oDlg:title := drgNLS:msg('Open Reference file')
*
  IF ( cName := oDlg:open('REF*.DBD',.T.) ) != NIL
    cFileName := parseFileName(cName)
    IF UPPER(LEFT(cFileName, 3) ) = 'REF'
      DRGDIALOG FORM 'DRG002' PARENT ::drgDialog CARGO cName MODAL DESTROY
    ELSE
      drgMsgBox(drgNLS:msg('This is not a reference file!') )
    ENDIF
  ENDIF
  oDlg:destroy()

RETURN self

*************************************************************************
* Create default application environment.
*************************************************************************
METHOD drgApp_Menu:createApp()
LOCAL oDialog
  DRGDIALOG FORM 'DRG005' PARENT ::drgDialog MODAL DESTROY
RETURN self


*************************************************************************
* Edit default settings
*************************************************************************
METHOD drgApp_Menu:doSettings()
LOCAL oDialog
  DRGDIALOG FORM 'DRG013' PARENT ::drgDialog MODAL DESTROY
RETURN self

*************************************************************************
* Open project submenu
*************************************************************************
METHOD drgApp_Menu:doMenuProject()
LOCAL oDialog
  ::oPopMenu := XbpMenu():new( ::drgDialog:oBord ):create()
  ::oPopMenu:addItem( {'New project', ;
   { || PostAppEvent(drgEVENT_ACTION, 'doNewProject','0',::drgDialog:dialog ) } } )
  ::oPopMenu:addItem( {'Open project', ;
   { || PostAppEvent(drgEVENT_ACTION, 'doOpenProject','0',::drgDialog:dialog ) } } )
  ::oPopMenu:addItem( {'Delete project', ;
   { || PostAppEvent(drgEVENT_ACTION, 'doDeleteProject','0',::drgDialog:dialog ) } } )
* Pop list
  ::oPopMenu:popup( ::drgDialog:dialog, ::posProject )

RETURN self

*************************************************************************
* New project selected
*************************************************************************
METHOD drgApp_Menu:doNewProject()
LOCAL oDialog, nExit
  DRGDIALOG FORM 'DRG010' PARENT ::drgDialog CARGO '1' MODAL DESTROY EXITSTATE nExit
  IF nExit != drgEVENT_QUIT
* GO TO EDITING
    DRGDIALOG FORM 'DRG020' PARENT ::drgDialog MODAL DESTROY
  ENDIF
RETURN self

*************************************************************************
* Edit existing project
*************************************************************************
METHOD drgApp_Menu:doOpenProject()
LOCAL oDialog, nExit
  DRGDIALOG FORM 'DRG010A' PARENT ::drgDialog CARGO '2' MODAL DESTROY EXITSTATE nExit
  IF nExit != drgEVENT_QUIT
* GO TO EDITING
    DRGDIALOG FORM 'DRG020' PARENT ::drgDialog MODAL DESTROY
  ENDIF
RETURN self

*************************************************************************
* Delete project
*************************************************************************
METHOD drgApp_Menu:doDeleteProject()
LOCAL oDialog, nExit
  DRGDIALOG FORM 'DRG010A' PARENT ::drgDialog CARGO '3' MODAL DESTROY EXITSTATE nExit
  IF nExit != drgEVENT_QUIT
    IF drgIsYESNO('Do you really want to delete project ' + PROJECT->Name)
* Perform delete project
    ENDIF
  ENDIF
RETURN self

*************************************************************************
* Test RUN created form.
*************************************************************************
METHOD drgApp_Menu:testForm()
LOCAL fDlg, fName, aDialog
* Create system file open dialog
  oldDefDir   := Set( _SET_DEFAULT)
  fDlg := XbpFileDialog():new(AppDesktop())
  fDlg:create()
  fDlg:title := drgNLS:msg('Select form')
  fName := fDlg:open('*.FRM',.T.)
  Set( _SET_DEFAULT, oldDefDir)
  IF fName != NIL
    dName := parseFileName(fName,2)
    aDialog := drgDialog():new(dName, ::drgDialog)      // drg DBD edit dialog
* Put filename as parameter in dialog's cargo property
    aDialog:create(,,.T.)                               // create modal dialog
* Dialog has ended. Cleanup.
    aDialog:destroy()
    aDialog := NIL
  ENDIF

RETURN self


*************************************************************************
* Cleanup.
*************************************************************************
METHOD drgApp_Menu:destroy()
  ::drgUsrClass:destroy()

  ::oPopMenu   := ;
  ::posProject := ;
                   NIL
RETURN self

