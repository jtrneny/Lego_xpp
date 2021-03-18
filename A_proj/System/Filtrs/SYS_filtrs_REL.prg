#include "Appevent.ch"
#include "Common.ch"
#include "dll.ch"
#include "Gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "Font.ch"
#include "drgres.ch"
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#pragma Library( "XppUI2.LIB" )


*
**
CLASS SYS_filtrs_REL FROM drgUsrClass
EXPORTED:
  VAR     M_tree, M_rootItem
  var     R_tree, R_rootItem

  METHOD  init, getForm, drgDialogStart
  method  M_treeViewInit, M_treeItemMarked
  method  R_treeViewInit
  *
  method  fillTree, subTree
  METHOD  eventHandled

  method  rightAction


HIDDEN:
  var     dm
  var     a_relFiles, m_file, oini

  var     M_itemMarked
  method  M_fillRoot
  method  R_fillRoot
ENDCLASS


* takhle ne
METHOD SYS_filtrs_REL:eventHandled(nEvent, mp1, mp2, oXbp)
  DO CASE
  CASE nEvent = xbeM_RbDown
    IF ::oTree:itemFromPos(mp1) = ::oTree:getData()
      ::doPopup(mp1)
    ELSE
      RETURN .F.
    ENDIF

* Better then itemSelected callback from xbpTreeView
  CASE nEvent = xbeM_LbDblClick
    IF ::oTree:itemFromPos(mp1) = ::oTree:getData()
//      ::itemSelected(mp1)
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.
*


method sys_filtrs_rel:init(parent)
  ::drgUsrClass:init(parent)

  ::a_relFiles := { alltrim(filtrsW->cmainFile) }
  ::m_file     := alltrim(filtrsW->cmainFile)

  ::oini       := flt_setcond():new(.f.,.f.)
return self


method sys_filtrs_rel:getForm()
  local drgFC := drgFormContainer():new(), oDrg

  DRGFORM INTO drgFC SIZE 110,18 DTYPE '10' TITLE 'Nastavení relaèních vazeb' GUILOOK 'Message:Y,Action:N,IconBar:N,Menu:N'

  DRGTREEVIEW INTO drgFC                   ;
              FPOS  0, 1                   ;
              SIZE 49,17                   ;
              TREEINIT 'M_treeViewInit'    ;
              ITEMMARKED 'M_treeItemMarked';
              HASLINES                     ;
              HASBUTTONS                   ;
              RESIZE  'YN'

  DRGTREEVIEW INTO drgFC                 ;
              FPOS 59.5, 1               ;
              SIZE 50,17                 ;
              TREEINIT 'R_treeViewInit'  ;
              ITEMMARKED 'treeItemMarked';
              HASLINES                   ;
              HASBUTTONS                 ;
              RESIZE  'YN'

  DRGPushButton INTO drgFC POS 107  , 0 SIZE  3.2,1            EVENT drgEVENT_QUIT ICON1 102 ICON2 202 ATYPE 1 TIPTEXT 'Ukonèi dialog'
  DRGPushButton INTO drgFC POS  49.3, 7 SIZE 10,1 CAPTION '>>' EVENT 'rightAction'
  DRGPushButton INTO drgFC POS  49.3,10 SIZE 10,1 CAPTION '<<' EVENT 'leftAction'
return drgFC


METHOD SYS_filtrs_REL:drgDialogStart(drgDialog)
  ::dm       := drgDialog:dataManager             // dataManager

  ::dm:refresh()
  ::M_rootItem:expand(.t.)
return self


METHOD SYS_filtrs_rel:rightAction()
  local  oParent, pa_in := {}, sub_item, x, o_ITm
  *
  local  oItem := ::M_itemMarked, menuLevel := 0, pa := {}, ok := .t.

  do while ok
    oParent   := oItem:getParentItem()
    menuLevel := oParent:menuLevel

    if( oParent <> ::M_rootItem, (AAdd( pa, oParent),oItem := oParent), nil)
    ok := .not. (menuLevel = 0)
  enddo

  *  root
  ** sub_root
  for x := len(pa) to 1 step -1
    oItem   := relXbpTreeViewItem():New()

    * Set icon images
    oItem:image         := DRG_ICON_PGM1 // DIA1
    oItem:expandedImage := DRG_ICON_PGM2 // DIA2
    oItem:markedImage   := DRG_ICON_PGM3 // DIA3

    oItem:caption       := pa[x]:caption
    oItem:cargo         := pa[x]:cargo
    oItem:create()

    if pa[x]:menuLevel = 0
      ::R_rootItem:addItem(oItem)
      o_ITm := oItem
    else
      o_ITm:addItem(oItem)
    endif
  next

  * item
  if( len(pa) = 0, o_ITm := ::R_rootItem, nil)
  sub_item   := relXbpTreeViewItem():New()

  * Set icon images
  sub_item:image         := DRG_ICON_PGM1 // DIA1
  sub_item:expandedImage := DRG_ICON_PGM2 // DIA2
  sub_item:markedImage   := DRG_ICON_PGM3 // DIA3

  sub_item:caption       := ::M_itemMarked:caption
  sub_item:cargo         := ::M_itemMarked:cargo

  sub_item:create()
  o_ITm:additem(sub_item)

  ::R_rootItem:expand(.t.)
return self


METHOD SYS_filtrs_REL:M_treeViewInit(drgObj)
  ::M_tree := drgObj:oXbp
  ::M_fillRoot(::M_tree)

*-  drgObj:oXbp:itemSelected := {|oItem| ::fillTree( oItem ) }
*-  drgObj:oXbp:itemExpanded := {|oItem| if( isObject(oItem:cargo), ::subTree( oItem ), nil) }

  ::fillTree()
RETURN


method SYS_filtrs_rel:M_fillRoot()
  local  oDbd  := drgDBMS:getDBD(::m_file)
  *
  ::M_rootItem := relXbpTreeViewItem():New()
  * Set icon images
  ::M_rootItem:image         := DRG_ICON_PGM1 // DIA1
  ::M_rootItem:expandedImage := DRG_ICON_PGM2 // DIA2
  ::M_rootItem:markedImage   := DRG_ICON_PGM3 // DIA3
  ::M_rootItem:caption       := oDbd:description + '[' +upper(::m_file) +']'

  ::M_rootItem:create()
  ::M_tree:rootitem:additem(::M_rootItem)
return self


method SYS_filtrs_rel:M_treeItemMarked(oItem,aRect,oXbp)
  ::M_itemMarked := oItem
return self


*
**
method SYS_filtrs_rel:R_treeViewInit(drgObj)
  ::R_tree := drgObj:oXbp
  ::R_fillRoot(::R_tree)
return


method SYS_filtrs_rel:R_fillRoot()
  local  oDbd  := drgDBMS:getDBD(::m_file)
  *
  ::R_rootItem := relXbpTreeViewItem():New()
  * Set icon images
  ::R_rootItem:image         := DRG_ICON_PGM1 // DIA1
  ::R_rootItem:expandedImage := DRG_ICON_PGM2 // DIA2
  ::R_rootItem:markedImage   := DRG_ICON_PGM3 // DIA3
  ::R_rootItem:caption       := oDbd:description + '[' +upper(::m_file) +']'

  ::R_rootItem:create()
  ::R_tree:rootitem:additem(::R_rootItem)
return self


method SYS_filtrs_rel:fillTree()
  local  oDbd := drgDBMS:getDBD(::m_file)
  local  x, y, oRELa, oRELs
  *
  local  o_rootItem := ::M_rootItem, oSUBitm, oSSUBitm, oItem, pa := ::a_relFIles

  oRELa := oDbd:relDef

  for x := 1 to len(oRELa) step 1
*****
    AAdd(pa, oRELa[x]:relFile)
*****
    oItem := relXbpTreeViewItem():New()

    * Set icon images
    oItem:image         := DRG_ICON_PGM1 // DIA1
    oItem:expandedImage := DRG_ICON_PGM2 // DIA2
    oItem:markedImage   := DRG_ICON_PGM3 // DIA3

    oItem:caption       := drgDBMS:getDBD(oRELa[x]:relFile):description + '[' +oRELa[x]:relKey +']'
    oItem:cargo         := oRELa[x]

    oItem:create()
    o_rootItem:additem(oItem)

    for y := 1 to len(oRELa[x]:relSubs) step 1
      oRELs     := oRELa[x]:relSubs[y]
      otree_itm := relXbpTreeViewItem():New()

      otree_itm:caption := drgDBMS:getDBD(oRELs:relFile):description + '[' +oRELs:relKey +']'
      otree_itm:cargo   := oRELs

      otree_itm:create()
      oItem:addItem(otree_itm)

      oItem := otree_itm
    next
  next
return self



method SYS_filtrs_rel:subTree(otree_item)
  local  oRel := otree_item:cargo
  local  oDbd := drgDBMS:getDBD(oRel:relFile)
  *
  local  x, oRELa, otree_itm, aItems, sub_tree
  local  pa := ::a_relFIles, pa_in := {}

  oParent := otree_item:getParentItem()
  aItems  := oParent:getChildItems()
  AEval(aItems, {|obj| if( isObject(obj:cargo), ;
                           AAdd(pa_in, obj:cargo:relFile +obj:cargo:relKey), nil) })

  oRELa  := oDbd:relDef
  aItems := otree_item:getChildItems()
  AEval( aItems, {|obj| otree_item:delItem(obj) } )

  for x := 1 to len(oRELa) step 1
*****
    if AScan(pa, oRELa[x]:relFile) = 0 .and. AScan(pa_in, oRELa[x]:relFile +oRELa[x]:relKey) = 0
*****
      otree_itm := relXbpTreeViewItem():New()
      *
      otree_itm:image         := gDRG_ICON_SAVE // DRG_ICON_DIA1
      otree_itm:expandedImage := gDRG_ICON_SAVE // DRG_ICON_DIA1
      otree_itm:markedImage   := DRG_ICON_SAVE // DRG_ICON_DIA1

      otree_itm:caption   := drgDBMS:getDBD(oRELa[x]:relFile):description + '[' +oRELa[x]:relKey +']'
      otree_itm:cargo     := oRELa[x]
      otree_itm:MenuLevel := otree_item:MenuLevel+1
      otree_itm:create()
      otree_item:additem(otree_itm)

      if .not. empty(drgDBMS:getDBD(oRELa[x]:relFile):relDef)
        sub_tree := relXbpTreeViewItem():New()

        sub_tree:caption := ''
        sub_tree:create()
        otree_itm:additem(sub_tree)
      endif

      AAdd(pa_in,oRELa[x]:relFile +oRELa[x]:relKey)
    endif
  next

  ::dm:refresh()
return self


*
**
CLASS relXbpTreeViewItem FROM XbpTreeViewItem
EXPORTED:
   VAR     idMenu, MenuType, MenuLevel, MenuCaption, MenuData

   METHOD  Init, Destroy, EventHandled
ENDCLASS

METHOD relXbpTreeViewItem:Init( parent)
  ::XbpTreeViewItem:init(parent)
  *
  ::idMenu      := ''
  ::MenuType    := ''
  ::MenuLevel   := 0
  ::MenuCaption := ''
  ::MenuData    := ''
RETURN self

METHOD relXbpTreeViewItem:Destroy()
  ::idMenu := ::MenuType := ::MenuLevel := ::MenuCaption := ::MenuData := NIL
RETURN self

********************************************************************************
METHOD relXbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)

  ::XbpTreeViewItem:EventHandled(nEvent, mp1, mp2, oXbp)
RETURN .t.