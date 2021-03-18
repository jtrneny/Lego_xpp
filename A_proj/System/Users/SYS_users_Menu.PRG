
#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "gra.ch"
#include "drgRes.ch"

FUNCTION IconType()
  Local type := ALLTRIM( SUBSTR( ASystem->cTypObject, 5, 6))
  Local Icon := IF( type = 'menu'   , 421,;         // DRG_ICON_MNU1
                IF( type = 'dialog' , DRG_ICON_DIA1,;
                IF( type = 'program', DRG_ICON_PGM1,;
                IF( type = 'report' , DRG_ICON_REP1, 0 ))))
RETURN Icon

*
********************************************************************************
CLASS Sys_users_Menu FROM drgUsrClass
EXPORTED:
  VAR     oTree, aTree, oTreeItem, CaptionItem
  VAR     dc, dm
  VAR     mMenu_org, mMenu_new
  *
  METHOD  init, destroy, getForm, drgDialogStart
  METHOD  treeViewInit, treeItemSelected, treeItemMarked
  METHOD  processMNUfile
  METHOD  eventHandled, postValidate
  *
  METHOD  SubItemINS, SubItemDEL
  METHOD  Menu_INFO, saveMenu
  METHOD  Menu_PRINT
  method  asysAct

HIDDEN:
  var     oDBro
  VAR     mnuFileName, lMenuUser
  VAR     icon1, icon2, icon3, idMenu
  *
  METHOD  setIcons

ENDCLASS

********************************************************************************
METHOD Sys_users_Menu:init(parent, InitParam )
  ::drgUsrClass:init(parent)
  ::mnuFileName := drgParseSecond(::drgDialog:initParam)
  ::lMenuUser   := ( ::mnuFileName = 'UserMenu' )
RETURN self

********************************************************************************
METHOD Sys_users_Menu:drgDialogStart(drgDialog)

  ::dc    := drgDialog:dialogCtrl
  ::dm    := drgDialog:dataManager
  ::oDBro := drgDialog:odbrowse[1]
  *
  drgDBMS:open( 'asysActW', .T., .T., drgINI:dir_USERfitm); ZAP

  ASYSTEM->( AdsSetOrder( 3),;
             mh_SetFilter( "cTypObject = 'MNU_'"), dbGoTOP() )
*             mh_SetScope( 'MNU_'))
RETURN self

********************************************************************************
METHOD Sys_users_Menu:getForm(drgObj)
  LOCAL oFC
  Local cTitle  := if( ::lMenuUser, 'Uživatelské ', 'Skupinové ') + 'menu'
  Local infUser := AllTrim( if( ::lMenuUser, USERs->cOsoba, USERsGRP->cNameGroup))
  *
  ::mnuFileName := drgParseSecond(::drgDialog:initParam)

  oFC := drgFormContainer():new()
  *
  DRGFORM INTO oFC SIZE 110,25  DTYPE '10' TITLE cTitle GUILOOK 'Action:y,Message:N,Menu:n,IconBar:y';
                                POST 'PostValidate'

  DRGAction INTO oFC CAPTION 'info ~Menu'  EVENT 'Menu_INFO'    TIPTEXT 'Popis vyvolané akce ...'
  DRGACTION INTO oFC ATYPE 5
  DRGACTION INTO oFC ATYPE 5
  DRGACTION INTO oFC ATYPE 5
  DRGACTION INTO oFC ATYPE 5
  DRGAction INTO oFC CAPTION '~Oprávnìní'  EVENT 'asysact'      TIPTEXT 'Uživatelská oprávnìní pøístupu ...'

*  DRGAction INTO oFC CAPTION 'tisk ~Menu'  EVENT 'Menu_PRINT'    TIPTEXT 'TMP pro tisk menu'
*  DRGAction INTO oFC CAPTION '~Kopírování' EVENT 'Menu_COPY'    TIPTEXT 'Kopírování menu z jiného uživatele'



  DRGSTATIC INTO oFC FPOS 0,0 SIZE 40,1.4 STYPE XBPSTATIC_TYPE_RECESSEDBOX RESIZE 'xn'
    DRGTEXT INTO oFC CPOS  0.3, 0.2 CLEN 39 CAPTION infUser FONT 7 CTYPE 3
  DRGEND  INTO oFC
  DRGTREEVIEW INTO oFC FPOS 0, 1.5 SIZE 40,20.5 HASLINES HASBUTTONS RESIZE 'xy' TIPTEXT cTitle ;
                    ITEMMARKED 'TreeItemMarked'
  DRGGET M->CaptionItem   INTO oFC FPOS 7.5,22 FLEN 40 FCAPTION 'Název' CPOS 0.5,22

  DRGPUSHBUTTON INTO oFC CAPTION 'Uložit' POS 10, 23.5 SIZE 10,1 ;
                  EVENT 'SaveMenu' ICON1 101 ICON2 201 ATYPE 3  TIPTEXT  cTitle + ' - ULOŽENÍ'

  DRGPUSHBUTTON INTO oFC CAPTION 'Storno' POS 22, 23.5 SIZE 10,1 ;
                  EVENT drgEVENT_QUIT ICON1 102 ICON2 202 ATYPE 3  TIPTEXT ''

  DRGSTATIC INTO oFC FPOS 41,0 SIZE 69, 23 STYPE XBPSTATIC_TYPE_RECESSEDBOX  RESIZE 'yy'
    DRGSTATIC INTO oFC FPOS 0,0 SIZE 69,1.4 STYPE XBPSTATIC_TYPE_RECESSEDBOX RESIZE 'yn'
      DRGTEXT INTO oFC CPOS  0.3, 0.2 CLEN 68 CAPTION  'Seznam nabídek' FONT 7 CTYPE 0
    DRGEND  INTO oFC
    DRGDBROWSE INTO oFC FPOS 0.5, 1.5 SIZE 69, 21.4 FILE 'ASYSTEM'      ;
      FIELDS 'IconType():Typ:6::1,'   + ;
             'CNAMEOBJ:Popis položky menu:25,'  + ;
             'CCAPTION:Název položky menu:25,'  + ;
             'CTASK,'           + ;
             'CTYPOBJECT'         ;
              ITEMMARKED 'itemMarked' ITEMSELECTED 'itemSelected'    ;
              SCROLL 'yy' CURSORMODE 3 PP 7 POPUPMENU 'y' RESIZE 'yy'

*    DRGSTATIC INTO oFC FPOS 0,21.6 SIZE 69,1.4 STYPE XBPSTATIC_TYPE_RECESSEDBOX RESIZE 'xy'
*      DRGTEXT INTO oFC CPOS  1, 0.1 CLEN 8 CAPTION  'POPIS : '    CTYPE 0
*      DRGTEXT INTO oFC CPOS  9, 0.1 CLEN 60 NAME asystem->cNameObj  CTYPE 0
*    DRGEND  INTO oFC

  DRGEND  INTO oFC
*  DRGTEXT INTO oFC CPOS  45, 23 CLEN 60 CAPTION  'CTRL+INS  - založení položky menu na základní úroveò'  CTYPE 3
*  DRGTEXT INTO oFC CPOS  45, 24 CLEN 60 CAPTION  'INS       - vložení na konec submenu'       CTYPE 3
*  DRGTEXT INTO oFC CPOS  45, 25 CLEN 60 CAPTION  'ALT+INS   - vložení položky stejné úrovnì za aktuální'   CTYPE 3


RETURN oFC

********************************************************************************
METHOD Sys_users_Menu:treeViewInit(drgObj)
LOCAL oItem, rItem, x, aDirList

*  ::selICON := DRG_ICON_SELECTF
  ::oTree := drgObj:oXbp
  ::aTree := {}
*  ::posPopup[2] := ::oTree:currentSize()[2] + 1
  ::processMNUfile( Alltrim(::mnuFileName))
  ::CaptionItem := ''  //::oTreeItem:MenuCaption
  /*
  do case
  case ::mnuFileName == 'UserMenu'
    ::processMNUfile(::mnuFileName)
  case EMPTY(::mnuFileName)
    aDirList := DIRECTORY(drgINI:dir_RSRC+'*.MNU')    // Load directory list of all menu files
    ASORT( aDirList,,, {|aX,aY| aX[1] < aY[1] } )     // Sort by name
    AEVAL( aDirList, {|e| ::processMNUfile(e[1]) } )
  otherwise
    ::processMNUfile(::mnuFileName+'.MNU')
  endcase
  */
RETURN

********************************************************************************
METHOD Sys_users_Menu:processMNUfile(cName)
  LOCAL F, st, cLine, oItem, nRsrc
  LOCAL data, level, parent, type, caption, keyWord, value
  LOCAL treeLevel := ARRAY(8)

  do case
  case cName = 'UserMenu'
*    ( drgDBMS:open('USERS'), USERS->( dbSeek(Upper(usrName),, AdsCtag(1) )))
    IF( EMPTY( USERS->mMenuUser))
      ( drgDBMS:open('USERSGRP'), USERSGRP->( dbSeek(Upper(USERS->cGroup),, AdsCtag(1) )))
       ::mMenu_org := cName := USERSGRP->mMenuGroup
    ELSE
       ::mMenu_org := cName := USERS->mMenuUser
    ENDIF
    ::mMenu_new := ''
    nRsrc := 2
    F     := 1
  case cName = 'GroupMenu'
    ::mMenu_org := cName := USERSGRP->mMenuGroup
    ::mMenu_new := ''
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
    ::icon1 := ::icon2 := ::icon3 := data := NIL
*    data  := NIL
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
        ::icon1 := _getNum(value)
      CASE keyWord == 'ICON2'
        ::icon2 := _getNum(value)
      CASE keyWord == 'ICON3'
        ::icon3 := _getNum(value)
     CASE keyWord == 'IDMENU'
        ::idMenu := _getStr(value)

      ENDCASE
    ENDDO

    DEFAULT data TO ''
    DEFAULT caption TO '**'
    *
    oItem := mnuXbpTreeViewItem():new()
    ******
    IF ::icon1 = NIL
      ::setIcons( type)
*      oItem:dllName := 'drgRes.dll'
    ELSE
      DEFAULT ::icon2 TO ::icon1
      DEFAULT ::icon3 TO ::icon1
    ENDIF
* Set icon images
    oItem:image         := ::icon1
    oItem:expandedImage := ::icon2
    oItem:markedImage   := ::icon3
    oItem:caption       := caption
    oItem:idMenu        := ::idMenu
    * cargo will contain type of program and data
    oItem:cargo         := cLine
    *
    oItem:MenuType      := type
    oItem:MenuLevel     := level
    oItem:MenuCaption   := caption
    oItem:MenuData      := data
    *
    oItem:create()
    *
    AADD( ::aTree, oItem)
    * Add item to itemTree
    IF level = 0
      ::oTree:rootItem:addItem( oItem, LEN(::aTree) )
      treeLevel[1] := oItem
    ELSE
      treeLevel[level]:addItem( oItem, LEN(::aTree) )
      treeLevel[level + 1] := oItem
    ENDIF

  ENDDO
  ::oTree:setColorBG(GraMakeRGBColor( {220, 220, 250} ))
RETURN

********************************************************************************
METHOD Sys_users_Menu:EventHandled(nEvent, mp1, mp2, oXbp)
  Local anRec

  IF nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)
    RETURN .T.
  ENDIF

  IF oXbp:className() = 'XbpTreeView'
    DO CASE
    CASE nEvent = xbeTV_ItemMarked
      ::TreeItemMarked( mp1, mp2, oXbp)
    CASE nEvent = xbeTV_ItemSelected
      ::TreeItemSelected( mp1, mp2, oXbp)

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_DEL
        ::subItemDEL()
        RETURN .F.
      CASE mp1 = 43 .or. mp1 = 45    //  +, -  for Expanded / Collapsed
        Return .F.
      OTHERWISE
        Return .F.
      ENDCASE
    OTHERWISE
      RETURN .F.
    ENDCASE

  ELSEIF oXbp:className() = 'XbpBrowse'
    DO CASE
    CASE nEvent = drgEVENT_APPEND
      IF LEN( ::aTree) = 0
        drgMsgBox(drgNLS:msg( 'Musíte nejprve založit položky na základní úrovni menu pomocí CTRL+INS ...' ))
        RETURN .T.
      ENDIF
      IF ::oTreeItem:MenuType <> 'menu'
        drgMsgBox(drgNLS:msg( 'Vkládat lze pouze do položky typu  MENU ...' ))
        RETURN .T.
      ENDIF
      ::subItemINS( xbeK_INS)
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_CTRL_INS
*      drgMsgBox(drgNLS:msg( 'CTRL + INSERT ...' ))
        ::subItemINS( mp1)     // ::subItemINS( .T.)
      CASE mp1 = xbeK_ALT_INS
        IF LEN( ::aTree) = 0
          drgMsgBox(drgNLS:msg( 'Musíte nejprve založit položky na základní úrovni menu pomocí CTRL+INS ...' ))
          RETURN .T.
        ENDIF
        ::subItemINS( mp1)
      OTHERWISE
        Return .F.
      ENDCASE

    OTHERWISE
      Return .F.
    ENDCASE
  ELSE
    Return .F.
  ENDIF

RETURN .T.

*******************************************************************************
METHOD Sys_users_Menu:SubItemINS( Key  )   // isRootItem)
  LOCAL oIt, aChildItems, nArPos
  LOCAL cMenuType := ALLTRIM( SUBSTR( ASystem->cTypObject, 5, 6))
  Local isRootItem := ( Key = xbeK_CTRL_INS )

  DEFAULT isRootItem TO .F.
  *
  oIt := mnuXbpTreeViewItem():new()
  oIt:caption := ALLTRIM( ASystem->cCaption)   // ALLTRIM( ASystem->cMenuCap)
  ::setIcons( cMenuType)                       // ALLTRIM( ASystem->cMenuType))
  oIt:image         := ::icon1
  oIt:expandedImage := ::icon2
  oIt:markedImage   := ::icon3
  oIt:MenuType      := cMenuType        // ALLTRIM( ASystem->cMenuType)
*  oIt:MenuLevel   := IF( isRootItem .or. LEN( ::aTree) = 0, 0, ::oTreeItem:MenuLevel + 1)
  oIt:MenuLevel   := IF( isRootItem .or. LEN( ::aTree) = 0, 0,;
                     IF( Key = xbeK_ALT_INS, ::oTreeItem:MenuLevel,;
                     IF( Key = xbeK_INS, ::oTreeItem:MenuLevel + 1, 0 )))
  oIt:MenuCaption := ALLTRIM( ASystem->cCaption)  // ALLTRIM( ASystem->cMenuCap)
  oIt:MenuData    := ALLTRIM( ASystem->mObject)    // ALLTRIM( ASystem->cMenuData)
  oIt:idMenu      := ALLTRIM( ASystem->cIdObject)
  oIt:create()
  *
  IF isRootItem                    // Založí do rootu  Level = 0
    AAdd( ::aTree, oIt )
    ::oTree:rootItem:addItem( oIt, LEN(::aTree) )

  ELSEIF ( Key = xbeK_INS )        // Vloží na konec
    nArPos := ::oTreeItem:getData()
    *
    aChildItems := ::oTreeItem:getChildItems()
    nPos := 0
    lOK  := .T.
    DO WHILE lOK
      IF  VALTYPE( aChildItems) = 'A'
        IF Len( aChildItems) > 0
*          aChildItems := aChildItems[ Len( aChildItems)]
          nArPos      := aChildItems[ Len( aChildItems)]:getData()
          aChildItems := aChildItems[ Len( aChildItems)]:getChildItems()
        ELSE
          lOK := .F.
        ENDIF
      ELSE
        lOK := .F.
      ENDIF
    ENDDO
    nArPos++
    oIt := ::oTreeItem:addItem( oIt, nArPos)
*    oIt:setData( nArPos)
    *
    AAdd( ::aTree, NIL )
    AINS( ::aTree, nArPos, oIt)
    AEVAL( ::aTree, {|o| o:setData( o:getData() + 1)}, nArPos+1)
    *
    ::oTreeItem:expand(.t.)

  ELSEIF( Key = xbeK_ALT_INS )
    nArPos := ::oTreeItem:getData()
    nPos := ASCAN( ::aTree, {|o, x| o:MenuLevel = ::oTreeItem:MenuLevel}, nArPos + 1)
    nArPos := IF( nPos <> 0, ::aTree[ nPos]:getData(), nArPos )
    oIt := ::oTreeItem:getParentItem():insItem(::oTreeItem, oIt, nArPos )
    *
    AAdd( ::aTree, NIL )
    AINS( ::aTree, nArPos, oIt)
    AEVAL( ::aTree, {|o| o:setData( o:getData() + 1)}, nArPos+1)
    *
    ::oTreeItem:expand(.t.)

  ENDIF

RETURN self

*******************************************************************************
METHOD Sys_users_Menu:SubItemDEL()
  LOCAL nLEN, nArPos := ::oTreeItem:getData()
  Local aItems := ::oTreeItem:getChildItems()

  IF LEN( aItems) > 0
    nLen := aItems[ 1]:getData()
    AEval( aItems, {|o|( aDEL( ::aTree, nLen),;
                         aSIZE( ::aTree, Len( ::aTree)-1),;
                         ::oTreeItem:delItem(o) ) } )
  ENDIF
  aDEL( ::aTree , ::oTreeItem:getData())
  aSIZE( ::aTree, Len( ::aTree)-1)
  ::oTreeItem:getParentItem():delItem( ::oTreeItem)
  *
  AEVAL( ::aTree, {|o,n| o:setData(n)}, nArPos)

RETURN self

********************************************************************************
METHOD Sys_users_Menu:TreeItemMarked( oItem, aRect, oXbp)
  Local oVar := ::dm:has('M->CaptionItem')
  local cc   := allTrim(oitem:menuCaption) +'  (' +allTrim(oitem:idMenu) +' )'

  ::oTreeItem := oItem
  ::CaptionItem := oVar:value := oVar:Initvalue := oVar:prevvalue := ::oTreeItem:MenuCaption
  ::dm:refresh()

*  asystem->( dbseek(oitem:idMenu,,'ASYSTEM04'))
*  ::oDBro:oxbp:refreshAll()
RETURN SELF

********************************************************************************
METHOD Sys_users_Menu:treeItemSelected( oItem, aRect, oXbp)
  LOCAL cargo

  cargo := ::oTree:getData():cargo              // get cargo of currently selected item
  ::drgDialog:oForm:setNextFocus('M->CaptionItem',, .T. )

*  ::selICON := IF( ::selICON = DRG_ICON_SELECTF, DRG_ICON_SELECTT, DRG_ICON_SELECTF)
*  oItem:image := oItem:expandedImage := oItem:markedImage := ::selICON
RETURN

********************************************************************************
METHOD Sys_users_Menu:PostValidate( oVar)
  LOCAL  xVAL := oVar:get()
  LOCAL  lChanged := oVar:changed()
  LOCAL  cNAMe := oVar:name

  Do Case
  Case cName = 'M->CaptionItem'
    ::oTreeItem:Caption := xVal
    ::aTree[ ::oTreeItem:getData()]:MenuCaption := xVal
  EndCase
RETURN .T.

*
********************************************************************************
METHOD Sys_users_Menu:SaveMenu()
  Local aItems, oItem, x, cLine
  Local cItem := IF( ::lMenuUser, 'USERs->cOsoba', 'USERSGRP->cGroup')
  Local cMsg  := IF( ::lMenuUser, 'Chcete uložit menu k uživateli [ & ]  ?',;
                                  'Chcete uložit menu ke skupinì uživatelù [ & ]  ?' )

  IF drgIsYesNo(drgNLS:msg( cMsg, &cItem ))

    ::mMenu_new := ''
    ::oTree:lockUpdate( .T. )

    FOR x := 1 TO LEN( ::aTree)
       cLine := 'TYPE('    + ::aTree[ x]:MenuType                + ') ' + ;
                'LEVEL('   + STR(::aTree[ x]:MenuLevel, 1)       + ') ' + ;
                'CAPTION(' + AllTrim(::aTree[ x]:MenuCaption )   + ') ' + ;
                IF( ::aTree[ x]:MenuType = 'Menu', '',;
                'DATA(' + ::aTree[ x]:MenuData + ') ' )          + ;
                'IDMENU(' + if( Empty(::aTree[ x]:idMenu),'DIST000000',::aTree[ x]:idMenu) + ')'              //+ ;
*                IF( ::aTree[ x]:MenuType = 'Menu' .and. ::aTree[ x]:MenuLevel = 0,;
*                'ICON1(500)', '')

       ::mMenu_new += cLine + CRLF
    NEXT
    IF ::lMenuUser
      IF USERS->( dbRLock())
        USERS->mMenuUser := ::mMenu_new
        USERS->( dbUnLock())
      ENDIF
    ELSE
      IF USERSGRP->( dbRLock())
        USERSGRP->mMenuGroup := ::mMenu_new
        USERSGRP->( dbUnLock())
      ENDIF

    ENDIF

    ::oTree:LockUpdate( .F. )
  *  AEVAL( ::aTree, {|o| drgDump( o:caption) } )
 ENDIF

RETURN .T.

********************************************************************************
METHOD Sys_users_Menu:Menu_INFO()
  Local oXbp := ::dc:drgDialog:lastXbpInFocus

*  drgMsgBox(drgNLS:msg('Menu_INFO ... '))
  IF oXbp:ClassName() = 'XbpTreeView'
    ASYSTEM->( dbSEEK( Upper( ::oTreeItem:idMenu),,'ASYSTEM04'))
    ::dm:drgDialog:dialogCtrl:oBrowse[1]:refresh()
    ::dm:refresh()
  ENDIF

RETURN .T.


method sys_users_Menu:asysAct()
  local x, o_item, pa := {}

  for x := 1 to len(::aTree) step 1
    o_item := ::aTree[x]
    if lower(o_item:menuType) $ 'dialog,report'
      aadd( pa, { o_item:idMenu, o_item:menuType } )
    endif
  next

  for x := 1 to len(pa) step 1
    asysActW->( dbappend())

    asysActW->cuser     := users->cuser
    asysActW->cidObject := pa[x,1]

  next
return self


********************************************************************************
METHOD Sys_users_Menu:Menu_PRINT()
  Local oXbp := ::dc:drgDialog:lastXbpInFocus

*  drgMsgBox(drgNLS:msg('Menu_INFO ... '))
  TM_PRNmenu()

RETURN .T.


********************************************************************************
METHOD Sys_users_Menu:destroy()
  ::drgUsrClass:destroy()
  *
  ::oTree := ::aTree := ::oTreeItem := ::CaptionItem := ;
  ::mMenu_org := ::mMenu_new := ;
  NIL
  ASYSTEM->( mh_ClrFilter())
RETURN self

*
** HIDDEN******************************************************************************
METHOD Sys_users_Menu:setIcons( type)

  DO CASE
  CASE type = 'modul'
    ::icon1 := 500  //  MIS_ICON_MODULE
    ::icon2 := 500  //
    ::icon3 := 500  //
  CASE type = 'menu'
    ::icon1 :=  421  // MIS_ICON_CLOSEDFOLDER // DRG_ICON_MNU1
    ::icon2 :=  420  // MIS_ICON_OPENFOLDER   // DRG_ICON_MNU2
    ::icon3 :=  421  // MIS_ICON_CLOSEDFOLDER   // DRG_ICON_MNU3
  CASE type = 'dialog'
    ::icon1 := DRG_ICON_DIA1
    ::icon2 := DRG_ICON_DIA2
    ::icon3 := DRG_ICON_DIA3
  CASE type = 'program'
    ::icon1 := DRG_ICON_PGM1
    ::icon2 := DRG_ICON_PGM2
    ::icon3 := DRG_ICON_PGM3
  CASE type = 'report'
    ::icon1 := DRG_ICON_REP1
    ::icon2 := DRG_ICON_REP2
    ::icon3 := DRG_ICON_REP3
  OTHERWISE
    ::icon1 := DRG_ICON_UNK1
    ::icon2 := DRG_ICON_UNK2
    ::icon3 := DRG_ICON_UNK3
  ENDCASE

RETURN self


*
********************************************************************************
CLASS mnuXbpTreeViewItem FROM XbpTreeViewItem
EXPORTED:
   VAR     idMenu, MenuType, MenuLevel, MenuCaption, MenuData

   METHOD  Init, Destroy, EventHandled

ENDCLASS

METHOD mnuXbpTreeViewItem:Init( parent)
  ::XbpTreeViewItem:init(parent)
  *
  ::idMenu      := ''
  ::MenuType    := ''
  ::MenuLevel   := 0
  ::MenuCaption := ''
  ::MenuData    := ''
RETURN self

METHOD mnuXbpTreeViewItem:Destroy()
  ::idMenu := ::MenuType := ::MenuLevel := ::MenuCaption := ::MenuData := NIL
RETURN self

********************************************************************************
METHOD mnuXbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)

  ::XbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)
RETURN .t.

/*
********************************************************************************
CLASS SYS_Asystem_scr FROM drgUsrClass
EXPORTED
  VAR       cType

  METHOD    init
ENDCLASS

METHOD SYS_Asystem_scr:Init( parent)
 ::drgUsrClass:init(parent)
RETURN self
*/


Function TM_PRNmenu()
  local F, st, cLine, Item, nRsrc
  local data, level, parent, type, caption, keyWord, value, odd
  local cName, j, idMenu
  local aMenu

  j     := 1
  nRsrc := 2
  F     := 1
  cName := USERS->mMenuUser
  aMenu := {}
  Item  := 0

  WHILE ( cLine := _drgGetSection(@F, @cName, @nRsrc) ) != NIL
    * No type definition. Read next line
    IF (type := drgGetParm("TYPE",cLine)) = NIL
      LOOP
    ENDIF
*
    type  := LOWER(type)
*    ::icon1 := ::icon2 := ::icon3 := data := NIL
*    data  := NIL
    st    := cLine
    WHILE ( keyWord := _parse(@st, @value) ) != NIL
      DO CASE
      CASE keyWord == 'LEVEL'
        level   := _getNum(value)
      CASE keyWord == 'CAPTION'
        caption := _getStr(value)
      CASE keyWord == 'IDMENU'
        idMenu := _getStr(value)

//      CASE keyWord == 'PARENT'
//        parent  := _getStr(value)
//      CASE keyWord == 'DATA'
//        data    := _getStr(value)
//      CASE keyWord == 'ICON1'
//        ::icon1 := _getNum(value)
//      CASE keyWord == 'ICON2'
//        ::icon2 := _getNum(value)
//      CASE keyWord == 'ICON3'
//        ::icon3 := _getNum(value)

      ENDCASE
    ENDDO

    odd := Replicate('_', level +1)

    if type = 'dialog'
      AADD( aMenu, { level, odd, caption, type, idMenu})
    endif

  ENDDO

  drgDBMS:open( 'PRNMENUw', .T., .T., drgINI:dir_USERfitm); ZAP

  for j := 1 to len(aMenu)
    PRNMENUw->( dbAppend())
    PRNMENUw->nItMenu := aMenu[j,1]
    PRNMENUw->cItMenu := StrZero(aMenu[j,1])
    PRNMENUw->cTree   := aMenu[j,2]
    PRNMENUw->cMenu   := aMenu[j,3]
    PRNMENUw->cTyp    := aMenu[j,4]
    PRNMENUw->cID     := aMenu[j,5]
  next
  PRNMENUw->( dbGoTop())

return nil