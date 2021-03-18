//////////////////////////////////////////////////////////////////////
//
//  drgMenu.PRG
//
//  Copyright:
//       DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//       drgMenu object is implementation of menu in drg style
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

// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


CLASS drgMenu FROM drgUsrClass
EXPORTED:
  VAR     oTree
  VAR     oDialogList
  VAR     posPopUp
  VAR     dialogList

  METHOD  destroy

  METHOD  eventHandled
  METHOD  getForm
  METHOD  treeViewInit
  METHOD  treeItemSelected
  METHOD  processMNUfile
  METHOD  drgUsrDialogMenu
  METHOD  drgUsrIconBar
  METHOD  selectDialog
  METHOD  popDialogList
  METHOD  popErrorLog
  METHOD  popSwHelp

  inline method set_oldFont()
    ::otree:setFont(::otreeFont)
  return self

HIDDEN:
  VAR     mnuFileName, otreeFont

ENDCLASS

*********************************************************************
* Returns form definition for drgMenu
*********************************************************************
METHOD drgMenu:getForm(drgObj)
LOCAL oFC, oDrg
local xval, col, typ

  xval := mh_token(typPanel)
  typ  := Val( xval[1])

  do case
  case typ = 0                 ;    col := 40
  case typ = 1 .or. typ = 2    ;    col := 90
  case typ = 3 .or. typ = 4    ;    col := 120
  endcase

  ::mnuFileName := drgParseSecond(::drgDialog:initParam)
  oFC := drgFormContainer():new()

  DRGFORM INTO oFC SIZE col,25 TITLE 'Main menu' GUILOOK 'Action:N,Message:N'
  DRGTREEVIEW INTO oFC SIZE 40,25 HASLINES HASBUTTONS TIPTEXT 'Main menu'


  do case
  case typ = 1 .or. typ = 3
   DRGSTATIC INTO oFC FPOS 40.5,0.1 SIZE 49,24.7 RESIZE 'ny' CAPTION 'Informaèní panel' STYPE 13   //XBPSTATIC_TYPE_ICON
*    DRGTEXT INTO oFC  CAPTION 'Informaèní panel'  CPOS 50,0.1 CLEN 20 FONT 5
    DRGDBROWSE INTO oFC FPOS 0.5,0.1 SIZE 48,16 FILE 'ASYSINFO' INDEXORD 1  RESIZE 'ny'        ;
          FIELDS 'CZPRAVA:Info kanál:46'                                      ;
          ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' SCROLL 'ny' CURSORMODE 3 PP 1 POPUPMENU 'yy'
    DRGMLE ASYSINFO->mPopisZpr INTO oFC FPOS 0.5,16.4 SIZE 48,8.0 SCROLL 'nn' RESIZE 'xx'
**  oDrg:isedit_inrev := .f.
    oDrg:ronly := .t.
    if typ = 3
      DRGTEXT INTO oFC  CAPTION 'Pracovní plocha'  CPOS 90,0.1 CLEN 20 FONT 5
      DRGSTATIC INTO oFC FPOS 80.5,1.1 SIZE 39,23.0 STYPE 7   //XBPSTATIC_TYPE_ICON
    endif
   DRGEND INTO oFC
  case typ = 2 .or. typ = 4
    DRGTEXT INTO oFC  CAPTION 'Pracovní plocha'  CPOS 50,0.1 CLEN 20 FONT 5
    DRGSTATIC INTO oFC FPOS 40.5,1.1 SIZE 39,23.0 STYPE 7   //XBPSTATIC_TYPE_ICON

    if typ = 4
      DRGTEXT INTO oFC  CAPTION 'Informaèní panel'  CPOS 90,0.1 CLEN 20 FONT 5
      DRGDBROWSE INTO oFC FPOS 80.5,1.1 SIZE 39,15 FILE 'ASYSINFO' INDEXORD 1        ;
            FIELDS 'CZPRAVA:Info kanál:36'                                      ;
            ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected' SCROLL 'ny' CURSORMODE 3 PP 1 POPUPMENU 'yy'
      DRGMLE ASYSINFO->mPopisZpr INTO oFC FPOS 80.5,17.0 SIZE 39,7.8 SCROLL 'nn'
**  oDrg:isedit_inrev := .f.
    oDrg:ronly := .t.
    endif
  endcase

  ::posPopup    := {0, 0}
  ::dialogList  := {}

RETURN oFC

*********************************************************************
* Initialize treeView object containing menus.
*********************************************************************
METHOD drgMenu:treeViewInit(drgObj)
LOCAL oItem, rItem, x, aDirList
  ::oTree       := drgObj:oXbp
  ::otreeFont   := ::otree:setFont()
  ::posPopup[2] := ::oTree:currentSize()[2] + 1

  do case
  case ::mnuFileName == 'UserMenu' .or. ::mnuFileName == 'GroupMenu'
    ::processMNUfile(::mnuFileName)
  case EMPTY(::mnuFileName)
    aDirList := DIRECTORY(drgINI:dir_RSRC+'*.MNU')    // Load directory list of all menu files
    ASORT( aDirList,,, {|aX,aY| aX[1] < aY[1] } )     // Sort by name
    AEVAL( aDirList, {|e| ::processMNUfile(e[1]) } )
  otherwise
    ::processMNUfile(::mnuFileName+'.MNU')
  endcase

  ::otree:enter := { |a,b,c| ::set_oldFont() }
RETURN

*********************************************************************
* Event handled method for menu. This method basicly listens only for \
* two events to happend. drgDIALOG_START which indicates that dialog has \
* started and drgDIALOG_END hich indicates that dialog has ended.
*********************************************************************
METHOD drgMenu:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL ar, x

  DO CASE
* Running Dialog has started. mp1=thread number, mp2=description
  CASE nEvent = drgDIALOG_START
    AADD(::dialogList, { mp1, mp2, NIL } )

* Running Dialog has ended
  CASE nEvent = drgDIALOG_END
    x := ASCAN(::dialogList, {|a| a[1] = mp1 } )
    IF x > 0
      ::dialogList[x,1] := NIL
    ENDIF
    ar := ACLONE(::dialogList)
    ::dialogList := {}
    AEVAL(ar, { |e| IIF(e[1] != NIL, AADD(::dialogList, e),) } )
    ar := NIL
    ::otree:setFont(::otreeFont)

* Check for active dialogs on close
  CASE nEvent = xbeP_Close
    IF LEN(::dialogList) > 0
      drgMsgBox(drgNLS:msg('All dialogs must be closed before application end!') )
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*********************************************************************
* Processes one menu file
*
* /bParameters:b/
* /b< cFileName >b/   : character : Menu file name
*********************************************************************
METHOD drgMenu:processMNUfile(cName)
LOCAL F, st, cLine, oItem, nRsrc
LOCAL icon1, icon2, icon3, data, level, parent, type, caption, keyWord, value
LOCAL treeLevel := ARRAY(8)

  do case
  case cName = 'UserMenu'
    ( drgDBMS:open('USERS'), USERS->( dbSeek(Upper(usrName),,1)))
    IF( EMPTY( USERS->mMenuUser))
      ( drgDBMS:open('USERSGRP'), USERSGRP->( dbSeek(Upper(USERS->cGroup),,1)))
      cName := USERSGRP->mMenuGroup
    ELSE
      cName := USERS->mMenuUser
    ENDIF
    nRsrc := 2
    F     := 1
  case cName = 'GroupMenu'
    ( drgDBMS:open('USERS'), USERS->( dbSeek(Upper(usrName),,1)))
    ( drgDBMS:open('USERSGRP'), USERSGRP->( dbSeek(Upper(USERS->cGroup),,1)))
    cName := USERSGRP->mMenuGroup
    nRsrc := 2
    F     := 1
  otherwise
    cName := drgINI:dir_RSRC + cName
  endcase

  WHILE ( cLine := _drgGetSection(@F, @cName, @nRsrc) ) != NIL
* No type definition. Read next line
    IF (type := drgGetParm("TYPE",cLine)) = NIL
      LOOP
    ENDIF
*
    type  := LOWER(type)
    icon1 := icon2 := icon3 := data := NIL
    st    := cLine
    WHILE ( keyWord := _parse(@st, @value) ) != NIL
      DO CASE
      CASE keyWord == 'LEVEL'
        level   := _getNum(value)
      CASE keyWord == 'CAPTION'
        caption := _getStr(value)
      CASE keyWord == 'PARENT'
        parent  := _getStr(value)
      CASE keyWord == 'DATA'
        data    := _getStr(value)
      CASE keyWord == 'ICON1'
        icon1 := _getNum(value)
      CASE keyWord == 'ICON2'
        icon2 := _getNum(value)
      CASE keyWord == 'ICON3'
        icon3 := _getNum(value)
      ENDCASE
    ENDDO
    DEFAULT data TO ''
    DEFAULT caption TO '**'
* Create treeView
    oItem := XbpTreeViewItem():new()
* Assign icons if not explicitly set
    IF icon1 = NIL
      DO CASE
      CASE type = 'menu'
        icon1 := 421  // MIS_ICON_CLOSEDFOLDER // DRG_ICON_MNU1
        icon2 := 420  // MIS_ICON_OPENFOLDER   // DRG_ICON_MNU2
        icon3 := 421  // MIS_ICON_CLOSEDFOLDER   // DRG_ICON_MNU3
      CASE type = 'dialog'
        icon1 := DRG_ICON_DIA1
        icon2 := DRG_ICON_DIA2
        icon3 := DRG_ICON_DIA3
      CASE type = 'program'
        icon1 := DRG_ICON_PGM1
        icon2 := DRG_ICON_PGM2
        icon3 := DRG_ICON_PGM3
      CASE type = 'report'
        icon1 := DRG_ICON_REP1
        icon2 := DRG_ICON_REP2
        icon3 := DRG_ICON_REP3
      OTHERWISE
        icon1 := DRG_ICON_UNK1
        icon2 := DRG_ICON_UNK2
        icon3 := DRG_ICON_UNK3
      ENDCASE
*      oItem:dllName := 'drgRes.dll'
    ELSE
      DEFAULT icon2 TO icon1
      DEFAULT icon3 TO icon1
    ENDIF
* Set icon images
    oItem:image         := icon1
    oItem:expandedImage := icon2
    oItem:markedImage   := icon3
    oItem:caption       := caption

* cargo will contain type of program and data
    oItem:cargo         := cLine
    oItem:create()
* Add item to itemTree
    IF level = 0
      ::oTree:rootItem:addItem( oItem )
      treeLevel[1] := oItem
    ELSE
      treeLevel[level]:addItem( oItem )
      treeLevel[level + 1] := oItem
    ENDIF

  ENDDO
RETURN


*********************************************************************
* TreeViewItem has been selected callback.
*********************************************************************
METHOD drgMenu:treeItemSelected()
LOCAL cData, cType, cargo, cName
LOCAL oThread, lThreaded
LOCAL oDialog

  cargo := ::oTree:getData():cargo              // get cargo of currently selected item

* menu item type
  cType := LOWER(drgGetParm("TYPE",cargo))
* menu item data
  IF EMPTY( cData := drgGetParm("DATA",cargo) )
    RETURN                                      // development time
  ENDIF
* Is dialog threaded
  IF EMPTY(cName := drgGetParm("THREAD",cargo))
    cName := 'y'                                // default is threaded
  ENDIF
  lThreaded := _getLogical(cName)
*
  DO CASE
* DIALOG
  CASE cType = 'dialog'
* PROGRAM
  CASE cType = 'program'
* Set default print dialog if first parameter is empty
    IF EMPTY( cName := drgParse(cData) )
      cData := 'drgProgramDialog' + cData
    ENDIF
    cName :=  ::oTree:getData():caption           // program description name
    cData += ',' + cName                          // Add menu caption as dialog title
* Search if program is active and return if so
*    IF (n := ASCAN(::dialogList, {|e| e[2] = cName }) ) > 0
*      drgNLS:msg('Program is already active!')
*      RETURN
*    ENDIF
* PRINTER REPORT
  CASE cType = 'report'
* Set default print dialog if first parameter is empty
    IF EMPTY( cName := drgParse(cData) )
      cData := 'drgPrintDialog' + cData
    ENDIF
    cName :=  ::oTree:getData():caption           // program description name
    cData += ',' + cName                          // Add menu caption as dialog title
  OTHERWISE
    RETURN
  ENDCASE

* Run dialog
  IF lThreaded
    oThread := drgDialogThread():new()
    oThread:start(,cData, ::drgDialog)
  ELSE
    DRGDIALOG FORM cData PARENT ::drgDialog MODAL DESTROY
  ENDIF
RETURN

***********************************************************************
* Called when menu item is selected from active dialog list.
***********************************************************************
METHOD drgMenu:selectDialog(nItem)
LOCAL aDialog
* Selected must be of type object=Dialog
  IF nItem > 2 .AND. VALTYPE(::dialogList[nItem - 2,2]) = 'O'
    aDialog := ::dialogList[nItem - 2,2]:dialog
* Is window minimized
    IF aDialog:getFrameState() = XBPDLG_FRAMESTAT_MINIMIZED
      aDialog:setFrameState(XBPDLG_FRAMESTAT_NORMALIZED)
    ENDIF
* Set focus to activated window dialog
    SetAppFocus(aDialog)
  ENDIF
* Destroy dialoglist window
  ::oDialogList:destroy()
  ::oDialogList := NIL
RETURN self

***********************************************************************
* Displays currently active dialogs list on the screen.
***********************************************************************
METHOD drgMenu:popDialogList()
LOCAL x, st
  ::oDialogList := XbpMenu():new( ::oTree ):create()
  ::oDialogList:addItem( { drgNLS:msg('Dialog list') } )
  ::oDialogList:addItem( {NIL, NIL , XBPMENUBAR_MIS_SEPARATOR, 0 } )
  FOR x := 1 TO LEN(::dialogList)
    IF EMPTY(::dialogList[x, 3])
* IF Type=Char it is submited program.
      IF VALTYPE(::dialogList[x,2]) = 'C'
        ::dialogList[x,3] := '>' + ::dialogList[x,2]
      ELSE
        ::dialogList[x,3] := ::dialogList[x,2]:dialog:title
      ENDIF
    ENDIF
    st := STR(x,2) + ':' + ::dialogList[x,3]
    ::oDialogList:addItem( { st } )

  NEXT x
* Create item selected callback
  ::oDialogList:itemSelected := {|nItem| ::selectDialog( nItem ) }
* Pop list
  ::oDialogList:popup( ::oTree, ::posPopup )
RETURN self

***********************************************************************
* Displays error log.
***********************************************************************
METHOD drgMenu:popErrorLog()
LOCAL oDialog
  DRGDIALOG FORM 'drgErrorLog' PARENT ::drgDialog MODAL DESTROY
RETURN self


METHOD drgMenu:popSwHelp()
LOCAL oDialog
  DRGDIALOG FORM 'SYS_pripominky_CRD' PARENT ::drgDialog MODAL DESTROY
RETURN self


***********************************************************************
* Creates standard menu bar for drgMenu
***********************************************************************
method drgMenu:drgUsrDialogMenu(oMBar,drgDialog)
  local  oDMenu, oHMenu
  *
  local  odlg := drgDialog:dialog
  local  ms   := drgNLS:msg('~Dialog,~Error log,Dialog ~list,End application,~Help,Help on menu,Help on application,About')

  oDMenu := XbpImageMenu():new(oMBar)
  oDMenu:title   := drgParse(@ms)
  oDMenu:barText := strTran(oDMenu:title,'~','')
  oDMenu:create()

* dialog
  oDMenu:addItem( {drgParse(@ms) +chr(9) +'ALt+E', ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'popErrorLog'  ,'0' , obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 504 )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'Alt+L' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'popDialogList','0' , obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 505 )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'Ctrl+W', ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_ACTION, 'popSwHelp'    , '0', obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 526 )

  oDMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oDMenu:addItem( {drgParse(@ms) +chr(9) +'ALt+X' , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_QUIT, mp1, mp2, obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 503 )

* nápovìda
  oHMenu := XbpImageMenu():new(oMBar)
  oHMenu:title   := drgParse(@ms)
  oHMenu:barText := strTran(oHMenu:title,'~','')
  oHMenu:create()

  oHMenu:addItem( {drgParse(@ms) +chr(9) +'F1'        , ;
                  { |mp1,mp2,obj| PostAppEvent( drgEVENT_HELP, mp1, mp2, obj ) },, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }      )

  oHMenu:addItem( {drgParse(@ms) +chr(9) +'Alt+F1'    , ;
                  { || drgHelp:showHelpContents() }                             ,,;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 530 )

  oHMenu:addItem( {NIL,;
                  {|| NIL}, XBPMENUBAR_MIS_SEPARATOR, XBPMENUBAR_MIA_OWNERDRAW } )

  oHMenu:addItem( {drgParse(@ms)                      , ;
                  { |a| _drgCallAboutDialog(oMbar:setOwner()) }                          ,, ;
                  XBPMENUBAR_MIA_OWNERDRAW       }, 531 )


  // Add popup-menus to menubar
  oMbar:measureItem := {|nItem,aDims,self| MeasureMenubarItem(oDlg,self,nItem,aDims) }
  oMbar:drawItem    := {|oPS,aInfo,self  | DrawMenubarItem(oDlg,self,oPS,aInfo) }

  oMbar:addItem( {oDMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
  oMbar:addItem( {oHMenu,,, NIL })    // XBPMENUBAR_MIA_OWNERDRAW} )
return self


**********************************************************************
METHOD drgMenu:drgUsrIconBar(parent, oBord)
LOCAL iconBar, size, pos, ms
  DEFAULT oBord TO parent:dialog:drawingArea

  ms := drgNLS:msg('End application,Display error log,Display currently active dialog list,Help on application')

* Get size of drawing area
  size := ACLONE( parent:dataAreaSize )
  size[2] := 24

* Get position of iconBar area
  pos  := ACLONE( parent:dataAreaSize )
  pos[1] := 0
  pos[2] += 0

* create iconBar = drgActions object
  iconBar := drgActions():new(parent, .t.)
  iconBar:create(oBord, pos, size)
  pos  := {4, 1}
  size := {24, 22}
* Separator
  iconBar:addAction( {pos[1],3}, {3, 18}, 0)
  pos[1] += 6
*
  iconBar:addAction( pos, size, 1, DRG_ICON_QUIT, gDRG_ICON_QUIT,,, drgParse(@ms), drgEVENT_QUIT,.F.)
  pos[1] += 30

  iconBar:addAction( pos, size, 1, DRG_ICON_ERRLOG, gDRG_ICON_ERRLOG,,, drgParse(@ms),'popErrorLog',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, DRG_ICON_DIALIST, gDRG_ICON_DIALIST,,, drgParse(@ms),'popDialogList',.F.)
  pos[1] += 24
  iconBar:addAction( pos, size, 1, MIS_ICON_SWHELP, gMIS_ICON_SWHELP,,, drgParse(@ms),'popSwHelp',.F.)
* Remember the position for dialoglist popup
  ::posPopup[1] := pos[1] - 5

  pos[1] += 26
  iconBar:addAction( {pos[1],3}, {2, 18}, 0)

  pos[1] +=  4
  iconBar:addAction( pos, size, 1, DRG_ICON_HELP, gDRG_ICON_HELP,,, drgParse(@ms),drgEVENT_HELP,.F.)

RETURN iconBar

*************************************************************************
* CleanUP
*************************************************************************
METHOD drgMenu:destroy()
  ::drgUsrClass:destroy()

  ::oTree       := ;
  ::oDialogList := ;
  ::posPopUp    := ;
  ::dialogList  := ;
                   NIL
RETURN self