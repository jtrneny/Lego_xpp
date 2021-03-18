//////////////////////////////////////////////////////////////////////
//
//  drgEdit_DBD.PRG
//
//  Copyright:
//           DRGS d.o.o., (c) 2003. All rights reserved.
//
//  Contents:
//          Classes for editing DB dictionary.
//
//  Remarks:
//          It's all about filling objects oFile, oField, oIndex, oSearch and
//          displaying proper tabPage page when item is selected.
//
//
//////////////////////////////////////////////////////////////////////

#include "Appevent.ch"
#include "Common.ch"
#include "Xbp.ch"
#include "Set.ch"
#include "drg.ch"
#include "drgRes.ch"

#include "..\Asystem++\drgApp++.ch"
#include "..\Asystem++\Asystem++.ch"


****************************************************************************
*
****************************************************************************
CLASS drgApp_Edit_DBD FROM drgUsrClass
EXPORTED:
  VAR     oDrg                            // TreeView DRG object
  VAR     oTree                           // xbpTreeView object
  VAR     oDBD                            // work object for DBD header definition
  VAR     oFile                           // work object for file definition
  VAR     oField                          // work object for field definition
  VAR     oIndex                          // work object for index definition
  VAR     oSearch                         // work object for search definition

  VAR     saved                           // has DBD been saved

  METHOD  init
  METHOD  destroy                         // clean up
  METHOD  eventHandled                    // usr event defined routine

  METHOD  treeViewInit                    // treeView initialization callback
  METHOD  treeItemMarked                  // treeView itemMarked callback
  METHOD  postLastField                   // postValidation for last field in a tabpage
  METHOD  postTreeView                    // postValidation for treeView
  METHOD  copyTree                        // copies a treeViewItem

  METHOD  editDBDHeader                   // edit default DBD header definitions
  METHOD  generateForm                    // Generate defualt form Action
  METHOD  importDBD                       // import from dbd ACTION

  METHOD  postAll                         // postValidation all fields
  METHOD  preAll                          // preValidation for all fields
  METHOD  getFLDTypes                     // get allowed combobox field types

HIDDEN:
  VAR     dbItem                          // work item for adding file def. 2 treeView
  VAR     flItem                          // work item for adding field def. 2 treeView
  VAR     ixItem                          // work item for adding index def. 2 treeView
  VAR     scItem                          // work item for adding search def. 2 treeView
  VAR     dbdName                         // name of DBD file on a disk
  VAR     lastMarkedItem                  // last marked object in treeView

  METHOD  editItem                        // start editing item
  METHOD  saveItem                        // save last edited item
  METHOD  moveItem                        // move currently selected item

  METHOD  newItem                         // appending new item
  METHOD  newFileItem                     // appending new file item
  METHOD  newFieldItem                    // appending new field item
  METHOD  deleteItem                      // delete item from tree
  METHOD  appendItem                      // append item to tree
  METHOD  append2Tree
  METHOD  saveDBD
  METHOD  getDescription

  inline method refresh()
    local  nin, ovar, vars, new_val

     vars   := ::drgDialog:dataManager:vars

     for nIn := 1 TO vars:size() step 1
       oVar := vars:getNth(nIn)

       if ( 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
         if(new_val := eval(ovar:block)) <> ovar:value
           ovar:set(new_val)
         endif
         ovar:initValue := ovar:prevValue := ovar:value
       endif
     next
     return .t.


ENDCLASS

*********************************************************************
* Initialization part. Create default work objects.
*********************************************************************
METHOD drgApp_Edit_DBD:init(parent)
  ::drgUsrClass:init(parent)

  ::oDBD    := _drgDBDDBD():new()
  ::oFile   := _drgDBDFile():new()
  ::oField  := _drgDBDField():new()
  ::oIndex  := _drgDBDIndex():new()
  ::oSearch := _drgDBDSearch():new()

  ::dialogTitle := 'Edit DBD:' + UPPER(::drgDialog:cargo)
  ::dialogIcon  := DRG001_IC_FILE
  ::saved       := .T.
RETURN self

*********************************************************************
* TreeView calls TreeViewInit method when created. This method is used \
* to fill initial TreeView contents.
* Method reads DBD file specified by drgDialog:cargo property and creates TreeView.
*
* \bParameters:b\
* \b< oDrg >         : Object : of type drgTreeView
* \bReturn:b\        : self
*********************************************************************
METHOD drgApp_Edit_DBD:treeViewInit(oDrg)
LOCAL oItem
LOCAL st, F, cFileName
LOCAL aName, cDesc, aType, ico
LOCAL dbdName, nRsrc
  ::oTree   := oDrg:oXbp                // xbpTreeView object
  ::oDrg    := oDrg                     // Save reference to drgTreeView object

  dbdName   := ::drgDialog:cargo          // File name parameter
  IF EMPTY(parseFileName(dbdName,2))      // no extension
    dbdName += '.DBD'
  ENDIF
  ::dbdName := dbdName                    // save DBD name
* IF DBD file exists
  IF FILE(dbdName)
    WHILE ( st := _drgGetSection(@F, @dbdName, @nRsrc) ) != NIL
      st := ALLTRIM(st)
      aType  := drgGetParm('TYPE',st)

      DO CASE
* Create FIELD item
      CASE aType = 'FIELD'
        ::oField:setCargo(st)
        oItem := ::newItem(::oField:getCaption(), DRG001_IC_FLD, st)
        ::flItem:addItem( oItem )

* Create INDEX item
      CASE aType = 'INDEX'
        ::oIndex:setCargo(st)
        oItem := ::newItem(::oIndex:getCaption(), DRG001_IC_IX, st)
        ::ixItem:addItem( oItem )

      CASE aType = 'FILE'
        ::dbItem := ::newFileItem(st)

      CASE aType = 'SEARCH'
        ::scItem:cargo  := st

      CASE aType = 'DBD'
        ::oDBD:setCargo(st)

      ENDCASE
    ENDDO
* New DBD file. Create NEW empty file item
  ELSE
    ::dbItem := ::newFileItem('TYPE(FILE) NAME(NEWFILE) DESC(New file)')
  ENDIF
RETURN self

*********************************************************************
* Create new item for displaying in DBD tree view.
*
* \bParameters:b\
* \b< cCaption >b\      : charachter : New created item's cargo
* \b< image >b\         : numeric    : Resource ID of image to display at caption
* \b< cCargo >b\        : charachter : Cargo contents. It's text description read from file.
*
* \bReturn:b\           : object of type treeViewItem
*********************************************************************
METHOD drgApp_Edit_DBD:newItem(cCaption, nImage, cCargo)
LOCAL oItem
  oItem := XbpTreeViewItem():new()
  oItem:caption       := cCaption
  oItem:image         := nImage
  oItem:expandedImage := nImage
  oItem:markedImage   := nImage
*
  oItem:cargo         := cCargo
  oItem:create()
RETURN oItem

*********************************************************************
* Create item for displaying FILE TYPE definition
*
* \bParameters:b\
* \b< cargo >b\        : charachter : Cargo contents. It's Text description read from file.
*
* \bReturn:b\          : object of type treeViewItem
*********************************************************************
METHOD drgApp_Edit_DBD:newFileItem(st)
LOCAL cDesc, aName, oItem
  ::oFile:setCargo(st)

  oItem := ::newItem(::oFile:getCaption(), DRG001_IC_FILE, st)
  ::oTree:rootItem:addItem( oItem )

* FIELD def root item
  ::flItem := ::newItem(drgNLS:msg('Field definition'), DRG001_IC_FLDS, 'TYPE(FLDROOT)')
  oItem:addItem( ::flItem )
* INDEX root item
  ::ixItem := ::newItem(drgNLS:msg('Index definition'), DRG001_IC_IDX, 'TYPE(IXROOT)')
  oItem:addItem( ::ixItem )
* SEARCH item
  ::scItem := ::newItem(drgNLS:msg('Search'), DRG001_IC_SRC, 'TYPE(SEARCH)')
  oItem:addItem( ::scItem )
RETURN ::dbItem

*********************************************************************
* Create item for displaying a FIELD type.
*
* \bParameters:b\
* \b< cargo >b\        : charachter : Cargo contents. It's Text description read from file.
*
* \bReturn:b\          : object of type treeViewItem
*********************************************************************
METHOD drgApp_Edit_DBD:newFieldItem(c)
LOCAL cName, cDesc, cType, nIco
  DEFAULT c TO "TYPE(FIELD) NAME(new) CAPTION() FTYPE(C)"

  cName := drgGetParm('NAME',c)
  cDesc := drgGetParm('DESC',c)
  DEFAULT cDesc TO ''
  cType := IIF(EMPTY(drgGetParm('REF',c)), drgGetParm('FTYPE',c),'REF')
  nIco   := DRG001_IC_FLD
/*
  DO CASE
  CASE aType = 'C'; ico := DRG001_IC_FLDC
  CASE aType = 'N'; ico := DRG001_IC_FLDN
  CASE aType = 'D'; ico := DRG001_IC_FLDD
  CASE aType = 'L'; ico := DRG001_IC_FLDL
  OTHERWISE
    ico := DRG001_IC_FLDC
  ENDCASE
*/

RETURN ::newItem(cType + ':' + cName + ':' + cDesc, nIco, c)

*********************************************************************
* Handles DRG events which are specific to drgEdit_DBD class.
*********************************************************************
METHOD drgApp_Edit_DBD:eventHandled(nEvent, mp1, mp2, oXbp)
LOCAL ar, x

  DO CASE
  CASE nEvent = xbeTV_ItemMarked
    ::TreeItemMarked( mp1, mp2, oXbp)


  CASE nEvent = drgEVENT_NEXT .OR. nEvent = drgEVENT_PREV .OR. ;
       nEvent = drgEVENT_TOP  .OR. nEvent = drgEVENT_BOTTOM
    ::saveItem()
    ::moveItem(nEvent)
*    ::editItem()

  CASE nEvent = drgEVENT_EDIT
    ::saveItem()
    ::editItem()
  CASE nEvent = drgEVENT_DELETE
    ::deleteItem()
    ::editItem()

  CASE nEvent = drgEVENT_APPEND
    ::saveItem()
    ::appendItem(.F.)
    ::editItem()

  CASE nEvent = drgEVENT_APPEND2
    ::saveItem()
    ::appendItem(.T.)
    ::editItem()

  CASE nEvent = drgEVENT_SAVE
    ::saveItem()
    ::saveDBD()
    ::saved := .T.
    PostAppEvent(drgEVENT_MSG,,nEvent, ::drgDialog:dialog)      // clear message line

  CASE nEvent = drgEVENT_EXIT
    ::saveItem()
    ::saveDBD()
    PostAppEvent(xbeP_Close,nEvent,,::drgDialog:dialog)

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*********************************************************************
* TreeView item was selected (double clicked or enter was pressed. \
* Start editing if proper type. Problem with treeView item is \
* when tree can be expanded it also gets expanded on this event. \
* So we allow to edit only items which are not expandedable.
*********************************************************************
METHOD drgApp_Edit_DBD:treeItemMarked()
LOCAL type, oType
  ::saveItem()                            // save last edited
  ::editItem()
RETURN self

*********************************************************************
* Start editing curren treeView item data.
*********************************************************************
METHOD drgApp_Edit_DBD:editItem()
LOCAL data, type, cargo
LOCAL page

  ::lastMarkedItem := ::oTree:getData()           // remember last edited
  cargo := ::oTree:getData():cargo
  type  := drgGetParm('TYPE', cargo)

  DO CASE
  CASE type = 'FILE';   page  := 1; ::oFile:setCargo(cargo)
  CASE type = 'FIELD';  page  := 2; ::oField:setCargo(cargo)
  CASE type = 'INDEX';  page  := 3; ::oIndex:setCargo(cargo)
  CASE type = 'SEARCH'; page  := 4; ::oSearch:setCargo(cargo)
  OTHERWISE
    page := 5                                     // blank page
  ENDCASE

  ::refresh()
**  ::drgDialog:dataManager:refresh()                // refresh values
  ::drgDialog:oForm:tabPageManager:showPage(page) // force page to display

RETURN self

*********************************************************************
* Save item definition to treeViewCargo and update caption if needed.
*********************************************************************
METHOD drgApp_Edit_DBD:saveItem()
LOCAL type, oType
* Save last edited if chenged
  IF ::drgDialog:dataManager:changed()
    ::drgDialog:dataManager:save()
* Determine type of last marked item
    type  := drgGetParm('TYPE', ::lastMarkedItem:cargo)
* Update cargo contents of ::lastMarkedItem
    DO CASE
    CASE type = 'FILE';   oType := ::oFile
    CASE type = 'FIELD';  oType := ::oField
    CASE type = 'INDEX';  oType := ::oIndex
    CASE type = 'SEARCH'; oType := ::oSearch
    OTHERWISE
* No use and will prevent from error below.
      RETURN self
    ENDCASE
* Update cargo and caption
    ::lastMarkedItem:cargo := oType:getCargo()
    ::lastMarkedItem:setCaption( oType:getCaption() )
  ENDIF
RETURN self

*********************************************************************
* PostValidation is defined because next focusable field must be set when treeView is left. \
* drgForm will automaticaly position focus to the next field in order found \
* in form description file. Since next field is tabPage for file definition \
* focus would be set to File:name field. To prevent this next focusable field \
* depending of treeViewItem type is set here.
*********************************************************************
METHOD drgApp_Edit_DBD:postTreeView()
LOCAL type, cargo, nField
* Only if exit was forced by keypressed
  IF ::oDrg:keyboardExit
    type  := drgGetParm( 'TYPE', ::oTree:getData():cargo )
    DO CASE
    CASE type = 'FILE';   nField := 'oFile:Name'
    CASE type = 'FIELD';  nField := 'oField:Name'
    CASE type = 'INDEX';  nField := 'oIndex:Name'
    CASE type = 'SEARCH'; nField := 'oSearch:Order'
    OTHERWISE
      RETURN .F.
    ENDCASE
* Set field which will get next focus
    ::drgDialog:oForm:setNextFocus(nField)
  ENDIF
RETURN .T.

*********************************************************************
* Delete selected item
*********************************************************************
METHOD drgApp_Edit_DBD:deleteItem()
LOCAL type, oItem, oParent
LOCAL dialog, dName
  oItem := ::oTree:getData()
  type  := drgGetParm('TYPE', oItem:cargo)
  IF TYPE = 'FLDROOT' .OR. TYPE = 'IXROOT' .OR. TYPE = 'SEARCH'
    drgMsg(drgNLS:msg("Item can't be removed!"),, ::oTree)
    RETURN self
  ENDIF

  IF !drgIsYesNO(drgNLS:msg('Remove & definition! Are you sure?', type))
    RETURN self
  ENDIF

  oParent := oItem:getParentItem()
  oParent:delItem(oItem)
RETURN self

*********************************************************************
* Move selected item.
*********************************************************************
METHOD drgApp_Edit_DBD:moveItem(nEvent)
LOCAL type, oItem, oParent, aItem
LOCAL aList, x, iPos
  oItem := ::oTree:getData()
  type  := drgGetParm('TYPE', oItem:cargo)
  IF TYPE = 'FLDROOT' .OR. TYPE = 'IXROOT' .OR. TYPE = 'SEARCH'
    drgMsg(drgNLS:msg("Item can't be moved!"),, ::oTree)
    RETURN self
  ENDIF
* Get items parent
  oParent := oItem:getParentItem()
* Get list of all children of items parent
  aList   := oParent:getChildItems()
* Find item's position in a list of childItems
  iPos    := ASCAN( aList, {|a| oItem == a } )
  IF iPos = 0
    drgMsg(drgNLS:msg("Error moveing item!"),, ::oTree)
    RETURN self
  ENDIF

  DO CASE
* Position to TOP
  CASE nEvent = drgEVENT_TOP
    IF iPos > 1
      ::copyTree(oItem, oParent, 0)
      oParent:delItem(oItem)
      PostAppEvent(xbeP_Keyboard, xbeK_HOME,,::oTree)
    ENDIF

* Position one level upward
  CASE nEvent = drgEVENT_PREV
    IF iPos > 2
      ::copyTree(oItem, oParent, aList[iPos-2])
      oParent:delItem(oItem)
      PostAppEvent(xbeP_Keyboard, xbeK_UP,,::oTree)
* Must be two UPS unless in last pos
      IF iPos < LEN(aList)
        PostAppEvent(xbeP_Keyboard, xbeK_UP,,::oTree)
      ENDIF
    ENDIF

* Position to BOTTOM
  CASE nEvent = drgEVENT_BOTTOM
    IF iPos < LEN(aList)
      ::copyTree(oItem, oParent, aList[LEN(aList)])
      oParent:delItem(oItem)
      PostAppEvent(xbeP_Keyboard, xbeK_END,,::oTree)
    ENDIF

* Position one level beyond
  CASE nEvent = drgEVENT_NEXT
    IF iPos < LEN(aList)
      ::copyTree(oItem, oParent, aList[++iPos])
      oParent:delItem(oItem)
      PostAppEvent(xbeP_Keyboard, xbeK_DOWN,,::oTree)
    ENDIF

  ENDCASE

RETURN self

*********************************************************************
* It's a sad thing that after delItem method Item looses all its children. \
* So item cannot be moved in a treeView just by deleting and inserting somewhere else. \
* The method is a subroutine of moveItem and it performs a copy of whole treeView.
*
* \bParameters:b\
* \b< withCopy >       : Logical : Append with copy of selected object
*********************************************************************
METHOD drgApp_Edit_DBD:copyTree(cItem, oParent, whereTo)
LOCAL aList, aItem, x, oItem
  IF whereTo != NIL
* On top. Item where this item is to be inserted must be NIL. But this spoils recursion.
    IF VALTYPE(whereTo) = 'N'
      wherTo := NIL
    ENDIF
    oItem := ::newItem(cItem:caption, cItem:image, cItem:cargo)
    oParent:insItem(whereTo, oItem) // ::copyTree(oItem))
    oParent := oItem
  ENDIF

  aList := cItem:getChildItems()
  FOR x := 1 TO LEN(aList)
    aItem := ::newItem(aList[x]:caption, aList[x]:image, aList[x]:cargo)
    oParent:addItem(aItem)

    IF !EMPTY(aList[x]:getChildItems() )
      ::copyTree(aList[x], aItem)
    ENDIF
  NEXT
RETURN oItem

*********************************************************************
* Append icon was selected on ToolBar. Currently selected item determines which \
* definition type is appended.
*
* \bParameters:b\
* \b< lCopy >       : Logical : Append with copy of selected object
*********************************************************************
METHOD drgApp_Edit_DBD:appendItem(lCopy)
LOCAL type, oItem, oParent
  oItem := ::oTree:getData()
  type  := drgGetParm('TYPE', oItem:cargo)
  IF TYPE = 'SEARCH' .OR.  ;
     ( lCopy .AND. ( TYPE = 'FLDROOT' .OR. TYPE = 'IXROOT') )
    drgMsg(drgNLS:msg("Invalid operation!"),, ::oTree)
    RETURN self
  ENDIF
* Find parent item to append to
  IF oItem = ::oTree:rootItem
    oParent := ::oTree:rootItem
    oItem   := NIL
  ELSE
    oParent := oItem:getParentItem()
  ENDIF
  ::append2Tree(oItem, oParent, lCopy)
RETURN self

*********************************************************************
* Perform appending of new definition
*
* \bParameters:b\
* \b<oItem>       : object of treeViewItem : Currently selected item
* \b<oParent>     : object of treeViewItem : Currently selected item parent item
* \b<lCopy>    : Logical : Append with copy of selected object
*********************************************************************
METHOD drgApp_Edit_DBD:append2Tree(oItem, oParent, lCopy)
LOCAL type, nItem, aName, cDesc
LOCAL dName, cargo

  cargo := IIF(oItem = NIL, 'TYPE(FILE) ', oItem:cargo)
  type  := drgGetParm('TYPE', cargo)

  IF lCopy
    DO CASE
    CASE type = 'FIELD'
      nItem := ::newFieldItem(oItem:cargo)
      oParent:addItem(nItem)
    CASE type = 'INDEX'
      aName := drgGetParm('NAME', cargo)
      cDesc := drgGetParm('CAPTION', cargo)
      nItem := ::newItem(aName + ' : ' + cDesc, DRG001_IC_IX, oItem:cargo)
      oParent:addItem(nItem)
    ENDCASE
  ELSE
    DO CASE
    CASE type = 'FILE'
      ::dbItem := ::newFileItem('TYPE(FILE) NAME(NEWFILE) DESC(New file)')
*
    CASE type = 'FIELD'
      nItem := ::newFieldItem()
      oParent:insItem(oItem, nItem)
*
    CASE type = 'FLDROOT'
      nItem := ::newFieldItem()
      oItem:addItem(nItem)
      IF !oItem:isExpanded()              // expand item if not already expanded
        oItem:expand(.T.)                 // this will display added item
      ENDIF
*
    CASE type = 'INDEX'
      nItem := ::newItem('New index', DRG001_IC_IX, 'TYPE(INDEX) NAME(NEWINDEX) CAPTION(New Index)')
      oParent:insItem(oItem, nItem)
*
    CASE type = 'IXROOT'
      nItem := ::newItem('New index', DRG001_IC_IX, 'TYPE(INDEX) NAME(NEWINDEX) CAPTION(New Index)')
      oItem:addItem(nItem)
      IF !oItem:isExpanded()
        oItem:expand(.T.)
      ENDIF
    ENDCASE
  ENDIF

RETURN self

*********************************************************************
* Postvalidation control called when last field on a tabPage is left. \
* When last field is left focus must be set to treeView.
*********************************************************************
METHOD drgApp_Edit_DBD:postLastField()
  ::drgDialog:oForm:setNextFocus(1)
RETURN .T.

*********************************************************************
* Save DBD description to FILE
*********************************************************************
METHOD drgApp_Edit_DBD:saveDBD()
  fName := parseFileName(::dbdName,3) + '\' + parseFileName(::dbdName)
  drgFRename(::dbdName, fName + '.BAK')
  F := FCREATE(::dbdName)
  ::getDescription(::oTree:rootItem, @st)
  FWRITE(F, st)
  FCLOSE(F)
RETURN self

*********************************************************************
* Returns description of specifield file item. If passed treeItem has \
* child etems method is called recursively for every child item.
*********************************************************************
METHOD drgApp_Edit_DBD:getDescription(oItem, cDesc)
LOCAL items, aItem, type, fName, x, astex
  astex := REPLICATE('*',50)
* On first call
  IF cDesc = NIL
    cDesc := ::oDBD:getCargo() + CRLF

    IF oItem != ::oTree:rootItem
      cDesc += CRLF + astex + CRLF + ;
               '*' + CRLF   + ;
               '* FILE DEFINITION' + CRLF + ;
               '*' + CRLF   + ;
               astex + CRLF + ;
               oItem:cargo + CRLF
    ENDIF
  ENDIF

  items := oItem:getChildItems()                        // get all childs
  FOR x := 1 TO LEN(items)                              // loop childeren
    aItem := items[x]
    type  := drgGetParm('TYPE', aItem:cargo)

    DO CASE
    CASE type = 'FILE'
      cDesc += CRLF + '*' + CRLF   + ;
               '* FILE DEFINITION ' + astex + CRLF + ;
               '*' + CRLF   + ;
               aItem:cargo  + CRLF

    CASE type = 'FLDROOT'
      cDesc += IIF( EMPTY(aItem:getChildItems()), '', '* FIELD DEFINITION '  + astex + CRLF )

    CASE type = 'FIELD' .OR. type = 'INDEX'
      cDesc += '  ' + aItem:cargo + CRLF

    CASE type = 'IXROOT'
      cDesc += IIF( EMPTY(aItem:getChildItems()),'', '* INDEX DEFINITION ' + astex + CRLF )

    CASE type = 'SEARCH'
      IF !EMPTY( drgGetParm('RETURN',aItem:cargo) )
        cDesc += '* SEARCH DEFINITION' + astex + CRLF + ;
                 '  ' + aItem:cargo + CRLF
      ENDIF
    ENDCASE

* Recursive call to save child items definitions
    IF !EMPTY(aItem:getChildItems() )
      ::getDescription(aItem, @cDesc)
    ENDIF
  NEXT x
RETURN self

*********************************************************************
* This method is called upon "Generate default form" Action.
*********************************************************************
METHOD drgApp_Edit_DBD:generateForm()
LOCAL oItem, type, oDialog, st
  IF !::saved
    drgMsg(drgNLS:msg("Save description first!"),, ::oTree)
    RETURN
  ENDIF
*
*  ::saveItem()
  oItem := ::oTree:getData()
  IF (type := drgGetParm('TYPE', oItem:cargo) ) != 'FILE'
    drgMsg(drgNLS:msg("File must be selected!"),, ::oTree)
    RETURN
  ENDIF
  ::getDescription(oItem, @st)
  st := drgGetParm('NAME', oItem:cargo) + ',' + parseFileName(::dbdName,3)

* Dialog to create default form
  DRGDIALOG FORM 'DRG003' PARENT ::drgDialog CARGO st MODAL DESTROY

RETURN self

*********************************************************************
* This method is called upon "Generate default form" Action.
*********************************************************************
METHOD drgApp_Edit_DBD:importDBD()
LOCAL arDsc
LOCAL st, x, aType
  ::saveItem()  // save first
  IF (type := drgGetParm('TYPE', ::oTree:getData():cargo) ) != 'FILE'
    drgMsg(drgNLS:msg("File must be selected!"),, ::oTree)
    RETURN
  ENDIF

* Fill treeViewItem with values from array
  IF (arDsc := doImportDBD(::oDBD) ) != NIL
    FOR x := 1 TO LEN(arDsc)
      st := arDsc[x]
      aType  := drgGetParm('TYPE',st)
      DO CASE
      CASE aType = 'FILE'
        ::dbItem := ::newFileItem(st)

* Create FIELD item
      CASE aType = 'FIELD'
        ::oField:setCargo(st)
        oItem := ::newItem(::oField:getCaption(), DRG001_IC_FLD, st)
        ::flItem:addItem( oItem )

* Create INDEX item
      CASE aType = 'INDEX'
        ::oIndex:setCargo(st)
        oItem := ::newItem(::oIndex:getCaption(), DRG001_IC_IX, st)
        ::ixItem:addItem( oItem )
      ENDCASE
    NEXT
  ENDIF
RETURN self

*********************************************************************
* Edit DBD default database description.
*********************************************************************
METHOD drgApp_Edit_DBD:editDBDHeader()
LOCAL oDialog, cEngine := ::oDBD:dbEngine
  DRGDIALOG FORM 'DRG004' PARENT ::drgDialog CARGO ::oDBD MODAL DESTROY
  IF cEngine != ::oDBD:dbEngine
    drgMsgBox(drgNLS:msg("DB engine is changed. Edit window will be closed automatically!"), XBPMB_INFORMATION )
    ::saveDBD()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  ENDIF

RETURN self

************************************************************************
* PostValidation control for all fields on form.
************************************************************************
METHOD drgApp_Edit_DBD:postAll(oVar)
LOCAL cName := oVar:name
LOCAL value := oVar:get()
LOCAL oLen, oDec, lRet := .T.

  DO CASE
* oField:name
  CASE cName = 'M->oField:name'
    IF EMPTY(value)
      drgMsg(drgNLS:msg('Field name must be specified!'),, ::oTree)
*      RETURN .F.
    ENDIF

* oField:type
  CASE cName = 'M->oField:ftype'
    oLen := ::dataManager:get('oField:flen',.F.)
    oDec := ::dataManager:get('ofield:dec',.F.)
    IF value = 'L'
      oLen:set(1)
      oDec:set(0)
    ELSEIF value = 'C'
      oDec:set(0)
    ELSEIF value = 'I'
      oLen:set(4)
      oDec:set(0)
    ELSEIF value $ 'FDTY'
      oLen:set(8)
      oDec:set(0)
    ENDIF
*******

  CASE cName = 'M->oField:flen'
    oLen := ::dataManager:get('oField:flen',.F.)
    value := ::dataManager:get('oField:ftype')
    IF value = 'C'
      IF ::oDBD:dbEngine = 'FOXDBE'
        lRet := oLen:get() < 255 .AND. oLen:get() > 0
      ELSE
        lRet := oLen:get() < 2**16 .AND. oLen:get() > 0
      ENDIF

    ELSEIF value $ 'N'
      IF ::oDBD:dbEngine = 'FOXDBE'
        lRet := oLen:get() <= 20 .AND. oLen:get() > 0
      ELSE
        lRet := oLen:get() <= 19 .AND. oLen:get() > 0
      ENDIF
    ENDIF
*******
  ENDCASE
*
  IF oVar:changed()
    ::saved := .F.
  ENDIF

RETURN lRet

************************************************************************
* PreValidation control for all fields on form.
************************************************************************
METHOD drgApp_Edit_DBD:preAll(oVar)
LOCAL value := oVar:get()
LOCAL cName := oVar:name
LOCAL lRet  := .T.
  DO CASE
* oField:name
  CASE cName = 'M->oField:flen'
    oType := ::drgDialog:dataManager:get('oField:ftype')
    lRet := !(oType $ 'FDLBTYI')

* oField:type
  CASE cName = 'M->oField:dec'
    oType := ::drgDialog:dataManager:get('oField:ftype')
    lRet := !(oType $ 'DLCMTBIV')

  ENDCASE
RETURN lRet

************************************************************************
* Get field type combobox alllowed values
************************************************************************
METHOD drgApp_Edit_DBD:getFLDTypes()
LOCAL s := UPPER( ::oDBD:dbEngine ), ret, oRef
  IF s = 'DEFAULT'; s := 'DBFNTX'; ENDIF
  s := IIF(s = 'FOXCDX','DRGFTYPFOX','DRGFTYPDB3')

  IF ( oRef := drgRef:getRef( s ) ) != NIL
    RETURN oRef:values
  ENDIF
RETURN NIL

************************************************************************
* CleanUp
************************************************************************
METHOD drgApp_Edit_DBD:destroy()
  ::drgUsrClass:destroy()

  ::oTree       := ;
  ::oDrg        := ;
  ::dbItem      := ;
  ::flItem      := ;
  ::ixItem      := ;
  ::scItem      := ;
  ::saved       := ;
                   NIL
RETURN self

************************************************************************
* Imports DBD description from file into treeview structure.
************************************************************************
STATIC FUNCTION doImportDBD(oDBD)
LOCAL fDlg, cFileName, justName
LOCAL cIxName, indexes, cIndex, x
LOCAL cOldDir := Set(_SET_DEFAULT)
LOCAL arDesc := {}, arStruct
LOCAL bSaveErrorBlock, n
* Set default extension
  IF ( cEngine := oDBD:dbEngine ) = 'DEFAULT'
    cEngine := 'DBFNTX'
  ENDIF
  cExt := RIGHT(cEngine,3)
* Prompt for cFileName
  fDlg := XbpFileDialog():new(AppDesktop())
  fDlg:create()
  fDlg:title := drgNLS:msg('Select DBF file for description import')
  cFileName   := fDlg:open("*.DBF",.T.)
* Prompt for indexes
  IF  cFileName != NIL
    justName := parseFileName(cFileName,1)
* Assume index files have first charachters similar to DBF files
    justName :=  LEFT(justName, LEN(justName) - 2)
    x := 0
    indexes := ''
    WHILE .T.
      fDlg:title := drgNLS:msg("Select INDEXFILE no. & ", ++x)
      IF (cIxName := fDlg:open(justName + "*." + cExt,.T.) ) = NIL
        EXIT
      ENDIF
      indexes += parseFileName(cIxName,1) + ','
    ENDDO
    fDlg:destroy()
  ELSE
    Set(_SET_DEFAULT, cOldDir)
    RETURN NIL
  ENDIF

  justName   := parseFileName(cFileName,1)
  dirName    := parseFileName(cFileName,3)
* Open file and read structure
  DBUseArea(.T., cEngine, cFileName)
  arStruct := DbStruct()

* FILE DEFINITION
  AADD(arDesc, 'TYPE(FILE) NAME(' + UPPER(justName) + ')' )

* FIELD DEFINITIONS
  FOR x := 1 TO LEN(arStruct)
    AADD(arDesc, 'TYPE(FIELD) NAME(' + arStruct[x,1] + ') ' + ;
                 'FTYPE('   + arStruct[x,2] + ') ' + ;
                 'FLEN('    + LTRIM(STR(arStruct[x,3],5,0)) + ') ' + ;
                 'DEC('     + LTRIM(STR(arStruct[x,4],2,0)) + ') ' + ;
                 'CAPTION(' + arStruct[x,1] + ')' )
  NEXT x

* INDEX DEFINITIONS
  bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )   // save error block
  WHILE !EMPTY( cIndex := drgParse(@indexes) )
    cIxName := parseFileName(UPPER(cIndex),1)
    BEGIN SEQUENCE
      IF cExt = 'NTX'
        SET INDEX TO &cIxName
        AADD(arDesc,'TYPE(INDEX) NAME(' + cIxName + ;
                    ') CAPTION(Index ' + cIxName + ;
                    ') KEY(' + OrdKey() + ;
                    IIF(OrdIsDescend(),') DESCEND(Y','') + ;
                    IIF(OrdIsUnique(),') UNIQUE(Y','') + ;
                    IIF(EMPTY(OrdFor()),'',') FOR(' + OrdFor() ) + ;
                    ')' )
      ELSEIF cExt = 'CDX'
        SET INDEX TO &cIxName
        FOR n := 1 TO OrdCount()
          DBSETORDER(n)
          AADD(arDesc,'TYPE(INDEX) NAME(' + ordName() + ;
                      ') FNAME(' + cIxName + ;
                      ') CAPTION(Index ' + ordName() + ;
                      ') KEY(' + OrdKey() + ;
                      IIF(OrdIsDescend(),') DESCEND(Y','') + ;
                      IIF(OrdIsUnique(),') UNIQUE(Y','') + ;
                      IIF(EMPTY(OrdFor()),'',') FOR(' + OrdFor() ) + ;
                      ')' )
        NEXT
      ENDIF
    RECOVER
      drgMsgBox(drgNLS:msg("Definition for index file & can not be imported. ",cIxName))
    END SEQUENCE
  ENDDO
  ErrorBlock(bSaveErrorBlock)       // reset old error block
*
  DBCLOSEALL()
  Set(_SET_DEFAULT, cOldDir)
RETURN arDesc


************************************************************************
************************************************************************
*
* CLASS definition for DBD type description
*
************************************************************************
************************************************************************
CLASS _drgDBDDBD
  EXPORTED:

  VAR     type
  VAR     line
  VAR     dbEngine
  VAR     options

  METHOD  init
  METHOD  setCargo
  METHOD  getCargo
  METHOD  getCaption
  METHOD  destroy

ENDCLASS

************************************************************************
* Init object and parse description if passed
************************************************************************
METHOD _drgDBDDBD:init(line)
  DEFAULT line TO ''
  ::setCargo(line)
RETURN self

************************************************************************
* Parse line description to individual values
************************************************************************
METHOD _drgDBDDBD:setCargo(line)
LOCAL cOpt
  ::line := line                                      // save line description
* Parse values
  ::type     := 'DBD'
  ::dbEngine := drgGetParm('DBENGINE',line)
  cOpt       := drgGetParm('OPTIONS' ,line)
*  ::options  := IIF(EMPTY(cOpt), '', STRTRAN(cOpt,',',CRLF))
  ::options  := cOpt

  DEFAULT ::dbEngine  TO 'DEFAULT'
  DEFAULT ::options   TO ' '
RETURN self

************************************************************************
* Returns line description from individual values
************************************************************************
METHOD _drgDBDDBD:getCargo()
LOCAL cOpt
* Transform CRLF back to commas
  cOpt := STRTRAN(::options, CRLF, ',')
  IF EMPTY( drgParse(cOpt,',') )
    cOpt := ''
  ENDIF

  ::line := 'TYPE(DBD) ' + ;
            drgGetKeyword(::dbEngine,'DBENGINE') + ;
            drgGetKeyword(cOpt    ,'OPTIONS' )

RETURN ::line

************************************************************************
* Returns caption for displaying on a treeViewItem
************************************************************************
METHOD _drgDBDDBD:getCaption()
RETURN 'DBD'

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDBDDBD:destroy()
  ::line      := ;
  ::type      := ;
  ::dbEngine  := ;
  ::options   := ;
                  NIL
RETURN

************************************************************************
************************************************************************
*
* CLASS definition for FILE type description
*
************************************************************************
************************************************************************
CLASS _drgDBDFile
  EXPORTED:

  VAR     type
  VAR     name
  VAR     desc
  VAR     alias
  VAR     like
  VAR     line

  METHOD  init
  METHOD  setCargo
  METHOD  getCargo
  METHOD  getCaption
  METHOD  destroy

ENDCLASS

************************************************************************
* Init object and parse description if passed
************************************************************************
METHOD _drgDBDFile:init(line)
  DEFAULT line TO ''
  ::setCargo(line)
RETURN self

************************************************************************
* Parse line description to individual values
************************************************************************
METHOD _drgDBDFile:setCargo(line)
LOCAL keyWord, value

  ::line := line                                      // save line description
* Parse values
  ::name  := drgGetParm('NAME'  ,line)
  ::desc  := drgGetParm('DESC'  ,line)
  ::alias := drgGetParm('ALIAS' ,line)
  ::like  := drgGetParm('LIKE' ,line)

* SET default values
  DEFAULT ::type  TO 'FILE'
  DEFAULT ::desc  TO ''
  DEFAULT ::name  TO ''
  DEFAULT ::alias TO ''
  DEFAULT ::like  TO ''
RETURN self

************************************************************************
* Returns line description from individual values
************************************************************************
METHOD _drgDBDFile:getCargo()
  ::line := 'TYPE(FILE) ' + ;
            drgGetKeyword(::name, 'NAME'  ) + ;
            drgGetKeyword(::alias,'ALIAS' ) + ;
            drgGetKeyword(::desc, 'DESC'  ) + ;
            drgGetKeyword(::like, 'LIKE'  )

RETURN ::line

************************************************************************
* Returns caption for displaying on a treeViewItem
************************************************************************
METHOD _drgDBDFile:getCaption()
RETURN ::name + ':' + ::desc

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDBDFile:destroy()
  ::type     := ;
  ::name     := ;
  ::desc     := ;
  ::alias    := ;
  ::like     := ;
  ::line     := ;
                NIL
RETURN

************************************************************************
************************************************************************
*
* CLASS definition for FIELD type description
*
************************************************************************
************************************************************************
CLASS _drgDBDField
  EXPORTED:

  VAR     type
  VAR     name
  VAR     desc
  VAR     ref
  VAR     caption
  VAR     fType
  VAR     fLen
  VAR     dec
  VAR     picture
  VAR     relateto
  VAR     relatetype
  VAR     values
  VAR     defValue
  VAR     line

  METHOD  init
  METHOD  setCargo
  METHOD  getCargo
  METHOD  getCaption
  METHOD  destroy

ENDCLASS

************************************************************************
* Init object and parse description if passed
************************************************************************
METHOD _drgDBDField:init(line)
  DEFAULT line TO ''
  ::setCargo(line)
RETURN self

************************************************************************
* Parse line description to individual values
************************************************************************
METHOD _drgDBDField:setCargo(line)
LOCAL vals

  ::line := line                                      // save line description
* Parse values
  ::type        := 'FIELD'
  ::name        := drgGetParm('NAME'      ,line)
  ::desc        := drgGetParm('DESC'      ,line)
  ::ref         := drgGetParm('REF'       ,line)
  ::caption     := drgGetParm('CAPTION'   ,line)
  ::fType       := drgGetParm('FTYPE'     ,line)
  vals          := drgGetParm('FLEN'    ,line)
  ::fLen        := IIF(vals=NIL, 1, VAL(vals) )
  vals          := drgGetParm('DEC' ,line)
  ::dec         := IIF(vals=NIL, 0, VAL(vals) )
  ::picture     := drgGetParm('PICTURE'   ,line)
  ::relateto    := drgGetParm('RELATETO'  ,line)
  ::relatetype  := drgGetParm('RELATETYPE',line)
*
  vals          := drgGetParm('VALUES'    ,line)
  ::values      := IIF(EMPTY(vals), '', vals)
  ::defValue    := drgGetParm('DEFVALUE'  ,line)

* SET default values
  DEFAULT ::name        TO ''
  DEFAULT ::desc        TO ''
  DEFAULT ::ref         TO ''
  DEFAULT ::caption     TO ''
  DEFAULT ::fType       TO ''
  DEFAULT ::fLen        TO 0
  DEFAULT ::dec         TO 0
  DEFAULT ::picture     TO ''
  DEFAULT ::relateto    TO ''
  DEFAULT ::relatetype  TO ' '
  DEFAULT ::defValue    TO ''
RETURN self

************************************************************************
* Returns line description from individual values
************************************************************************
METHOD _drgDBDField:getCargo()
LOCAL vals
* Transform CRLF back to commas
  vals := STRTRAN(::values, CRLF, ',')
  IF EMPTY( drgParse(vals,',') )
    vals := ''
  ENDIF

  ::line := 'TYPE(FIELD) ' + ;
            drgGetKeyword(::name      ,'NAME'       ) + ;
            drgGetKeyword(::desc      ,'DESC'       ) + ;
            drgGetKeyword(::ref       ,'REF'        ) + ;
            drgGetKeyword(::caption   ,'CAPTION'    )
  IF EMPTY(::ref)
  ::line += drgGetKeyword(::fType     ,'FTYPE'      ) + ;
            drgGetKeyword(::fLen      ,'FLEN'       ) + ;
            drgGetKeyword(::dec       ,'DEC'        )
  ENDIF
  ::line += drgGetKeyword(::picture   ,'PICTURE'    ) + ;
            drgGetKeyword(::relateto  ,'RELATETO'   ) + ;
            drgGetKeyword(::relatetype,'RELATETYPE' ) + ;
            drgGetKeyword(vals        ,'VALUES'     ) + ;
            drgGetKeyword(::defvalue  ,'DEFVALUE'   )
RETURN ::line

************************************************************************
* Returns caption for displaying on a treeViewItem
************************************************************************
METHOD _drgDBDField:getCaption()
RETURN IIF(!EMPTY(::ref),'REF',::fType) + ':' + ::name + ':' + ::desc

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDBDField:destroy()
  ::type        := ;
  ::name        := ;
  ::desc        := ;
  ::ref         := ;
  ::caption     := ;
  ::fType       := ;
  ::fLen        := ;
  ::dec         := ;
  ::picture     := ;
  ::relateto    := ;
  ::relatetype  := ;
  ::values      := ;
  ::defValue    := ;
  ::line     := ;
                NIL
RETURN

************************************************************************
************************************************************************
*
* CLASS definition for INDEX type description
*
************************************************************************
************************************************************************
CLASS _drgDBDIndex
  EXPORTED:

  VAR     type
  VAR     line

  VAR     name
  VAR     fName
  VAR     caption
  VAR     data
  VAR     unique
  VAR     dupkeys
  VAR     cFor
  VAR     cWhile
  VAR     nRecord
  VAR     cDescend

  METHOD  init
  METHOD  setCargo
  METHOD  getCargo
  METHOD  getCaption
  METHOD  destroy

ENDCLASS

************************************************************************
* Init object and parse description if passed
************************************************************************
METHOD _drgDBDIndex:init(line)
  DEFAULT line TO ''
  ::setCargo(line)
RETURN self

************************************************************************
* Parse line description to individual values
************************************************************************
METHOD _drgDBDIndex:setCargo(line)
LOCAL aVal
  ::line := line                                      // save line description
* Parse values
  ::type     := 'INDEX'
  ::name     := drgGetParm('NAME'   ,line)
  ::fName    := drgGetParm('FNAME'  ,line)
  ::caption  := drgGetParm('CAPTION',line)
  ::data     := drgGetParm('KEY'    ,line)
  IF ::data = NIL
    ::data     := drgGetParm('DATA'   ,line)
  ENDIF
  ::unique   := drgGetParm('UNIQUE' ,line)
  ::dupkeys  := drgGetParm('DUPKEYS',line)
  ::cFor     := drgGetParm('FOR'    ,line)
  ::cWhile   := drgGetParm('WHILE'  ,line)
  ::cDescend := drgGetParm('DESCEND',line)
  aVal       := drgGetParm('RECORD' ,line)
  ::nRecord  := IIF(aVal=NIL, 0, VAL(aVal) )

* SET default values
  DEFAULT ::name      TO ''
  DEFAULT ::fName     TO ''
  DEFAULT ::caption   TO ''
  DEFAULT ::data      TO ''
  DEFAULT ::unique    TO ' '
  DEFAULT ::dupkeys   TO ' '
  DEFAULT ::cFor      TO ''
  DEFAULT ::cWhile    TO ''
  DEFAULT ::cDescend  TO ' '

RETURN self

************************************************************************
* Returns line description from individual values
************************************************************************
METHOD _drgDBDIndex:getCargo()
  ::line := 'TYPE(INDEX) ' + ;
            drgGetKeyword(::name    ,'NAME'    ) + ;
            drgGetKeyword(::fName   ,'FNAME'   ) + ;
            drgGetKeyword(::caption ,'CAPTION' ) + ;
            drgGetKeyword(::data    ,'KEY'     ) + ;
            drgGetKeyword(::cFor    ,'FOR'     ) + ;
            drgGetKeyword(::cWhile  ,'WHILE'   ) + ;
            drgGetKeyword(::unique  ,'UNIQUE'  ) + ;
            drgGetKeyword(::dupkeys ,'DUPKEYS' ) + ;
            drgGetKeyword(::cDescend,'DESCEND' ) + ;
            IIF(::nRecord = 0,'', drgGetKeyword(::nRecord ,'RECORD' ) )

RETURN ::line

************************************************************************
* Returns caption for displaying on a treeViewItem
************************************************************************
METHOD _drgDBDIndex:getCaption()
RETURN ::name + ':' + ::caption

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDBDIndex:destroy()
  ::type        := ;
  ::name     := ;
  ::fName    := ;
  ::caption  := ;
  ::data     := ;
  ::unique   := ;
  ::dupkeys  := ;
  ::line     := ;
                NIL
RETURN


************************************************************************
************************************************************************
*
* CLASS definition for SEARCH type description
*
************************************************************************
************************************************************************
CLASS _drgDBDSearch
  EXPORTED:

  VAR     type
  VAR     fields
  VAR     order
  VAR     ret
  VAR     line

  METHOD  init
  METHOD  setCargo
  METHOD  getCargo
  METHOD  getCaption
  METHOD  destroy

ENDCLASS

************************************************************************
* Init object and parse description if passed
************************************************************************
METHOD _drgDBDSearch:init(line)
  DEFAULT line TO ''
  ::setCargo(line)
RETURN self

************************************************************************
* Parse line description to individual values
************************************************************************
METHOD _drgDBDSearch:setCargo(line)
LOCAL vals
  ::line := line                                      // save line description
* Parse values
  ::type    := 'SEARCH'
  vals          := drgGetParm('FIELDS'    ,line)
  ::fields      := IIF(EMPTY(vals), '', vals)
  ::order   := drgGetParm('ORDER'   ,line)
  ::ret     := drgGetParm('RETURN'  ,line)

* SET default values
  DEFAULT ::fields TO ''
  DEFAULT ::order  TO ''
  DEFAULT ::ret    TO ''
RETURN self

************************************************************************
* Returns line description from individual values
************************************************************************
METHOD _drgDBDSearch:getCargo()
LOCAL vals
  vals := STRTRAN(::fields,CRLF,',')     // replace CRLF with comma
  IF EMPTY( drgParse(vals,',') )
    vals := ''
  ENDIF

  ::line := 'TYPE(SEARCH) ' + ;
            drgGetKeyword(vals     , 'FIELDS'   ) + ;
            drgGetKeyword(::order  , 'ORDER'    ) + ;
            drgGetKeyword(::ret    , 'RETURN'   )

RETURN ::line

************************************************************************
* Returns caption for displaying on a treeViewItem
************************************************************************
METHOD _drgDBDSearch:getCaption()
RETURN 'Search'

************************************************************************
* CleanUP
************************************************************************
METHOD _drgDBDSearch:destroy()
  ::type     := ;
  ::fields   := ;
  ::order    := ;
  ::ret      := ;
  ::line     := ;
                NIL
RETURN

