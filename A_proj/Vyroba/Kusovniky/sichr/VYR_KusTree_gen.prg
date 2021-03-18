/*==============================================================================
  VYR_KusTREE_gen.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "gra.ch"
#include "appevent.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#include "Xbp.ch"
#include "Font.ch"
#include "drgres.ch"

#define xbeUser_Eval   xbeP_User + 1

* #DEFINE   Tree_FULL   0     // rozbalí plný kusovník
* #DEFINE   Tree_FIRST  1     // rozbalí první výrobní stupeò

********************************************************************************
*
********************************************************************************
CLASS VYR_KusTREE_gen
EXPORTED:
  VAR     oDrg
  VAR     oTree, oRoot, show_Tree
  VAR     nROZPAD
  VAR     nRecnoRoot, nTreeRecNO, oTreeItem
  VAR     TreeITEMs, cSeaKey, nSearch     // pro dohledávání

  METHOD  Init, Destroy
  METHOD  TreeInit, TreeRebuild

  METHOD  fillTree, addItem
  METHOD  dlgSearch, searchInTree

ENDCLASS

*
********************************************************************************
METHOD VYR_KusTREE_gen:init(parent, show_Tree)

  DEFAULT show_Tree TO Tree_FULL
  *
  ::show_Tree := show_Tree
  *
  drgDBMS:open('CenZboz' )
  drgDBMS:open('NakPol'  )
  drgDBMS:open('DodZboz' )
  drgDBMS:open('Kusov'   )
  drgDBMS:open('PolOPER' )
  drgDBMS:open('VyrZAK'  )
  drgDBMS:open('VyrPol'  )
  drgDBMS:open('C_Stred' )
  drgDBMS:open('C_TypPol')
  *
  VyrPOL->( DbSetRelation( 'VyrZAK', { || Upper(VyrPOL->cCisZakaz) },'Upper(VyrPOL->cCisZakaz)'))
  drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  KusTree->( AdsSetOrder( 1))

RETURN self

*
********************************************************************************
METHOD  VYR_KusTREE_gen:TreeInit( oDrg, TreeRecNO)
  LOCAL cFilter, fromNabVys

  DEFAULT ::nRecNoROOT TO VyrPol->( RecNO()), TreeRecNO TO 1

  IF( ::nRecNoROOT <> VyrPol->( RecNO()), VyrPol->( dbGoTO( ::nRecNoROOT)), NIL )

  ::oTree      := oDrg:oXbp
  ::nTreeRecNO := TreeRecNO
  * pro dohledávání
  ::TreeITEMs  := {}     // uložení všech záznamù stromu
  ::cSeaKEY    := ''     // hledaný øetìzec
  ::nSearch    := 1      // kritérium hledání  ( 1 = cSklPol, 2 = cNazev)

*  ::oTree:FullRowMark := .T.   ???
  ** Vygenerovat KusTree
  KusTREE->( dbZAP())
  fromNabVys := ( oDrg:drgDialog:parent:dbName = 'NabVysHDw')
  GenTreeFILE( ::nRozpad,,,, fromNabVys)   //(0)
  *
  IF ::nRozpad = ROZPAD_POPOL
    * vyfiltrují se pouze vyrábìné položky
    cFilter := "lNakPol = .F."
    KusTREE->( mh_SetFILTER( cFilter))               // Ads_SetAof( cFilter), dbGoTOP() )
  ENDIF
  *
  ** Test
*  ::nROZPAD := IsNULL( ::nROZPAD, 1000)
  ** Naplnit TreeView
  ::fillTree( ::oTree:rootItem )
  IF ::show_Tree = Tree_FIRST
    ::oTree:rootItem:expand(.T.)  // zobrazí jen 1.výr.stupeò
  ENDIF
  ::oTree:setColorBG(GraMakeRGBColor( {220, 220, 250} ))
  ::oTree:alwaysShowSelection        := .T.

RETURN self

*
********************************************************************************
METHOD  VYR_KusTREE_gen:fillTREE(Obj)
  LOCAL oFinal, oItem, cItem, cPozice
  LOCAL aNode := {}, aSubNode := {}, aRecNO := { 2}
  LOCAL N, nVyrST, wVyrST, cKey, lWrt

  KusTree->( DBGOTOP() )
//  cItem := KusTree->cNazev  + ' - ' + STR(KusTree->(RecNo()))
  cItem :=  KusTree->cNazev  + ' - ' + STR(KusTree->nSpMno) + ' ' + KusTree->cMjSpo   // cZkratJedn
  oFinal := ::addItem( ::oTree:rootItem, cItem,, KusTree->( RecNo())  ) //, ICON_SET)
**  oFinal := ::addItem( ::oTree:rootItem, cItem,DRG_ICON_SELECTT, KusTree->( RecNo())  ) //, ICON_SET)
  AADD( aNode,{ oFinal, 1 } )
  ::oRoot := oFinal
  ::oTreeItem := oFinal

  DO WHILE  LEN( aNode) > 0
    FOR N := 1 TO LEN( aNode)
      KusTree->( DBGOTO( aNode[ N, 2]) )
      nVyrST := KusTree->nVyrST
      KusTree->( DBSKIP() )

      lWrt := .T.
      WHILE !KusTree->( EOF())
        wVyrST  := KusTree->nVyrST
        cPozice := ALLTRIM( STR( KusTree->nPozice)) + '.|   '
//        IF ::nROZPAD = 1000
          IF wVyrST = nVyrST + 1
            IF lWrt
              cItem := cPozice + ;
                       IF( KusTree->lNakPOL, KusTree->cSklPOL, KusTree->cVyrPol) + ' - ' + ;
                       KusTree->cNazev  + ' - ' + STR(KusTree->nSpMno) + ' ' + KusTree->cMjSpo   // cZkratJedn
              oItem := ::addItem( aNode[ n, 1], cItem,, KusTree->( RecNo()) )//, ICON_SET)
              AADD( aSubNode, { oItem, KusTree->( RecNo()) } )
            EndIf
            AADD( aRecNO  , KusTree->( RecNo()) )
          ElseIF wVyrST <= nVyrST
            lWrt := .F.
          EndIf
/*
        ELSE
          ** vygeneruje jen nejbližší nižší
          IF wVyrST = 2
            IF lWrt
              cItem := cPozice + ;
                       KusTree->cVyrPol + ' - ' + ;
                       KusTree->cNazev  + ' - ' + STR(KusTree->(RecNo()))
              oItem := ::addItem( aNode[ n, 1], cItem,, KusTree->( RecNo()) )//, ICON_SET)
              * AADD( aSubNode, { oItem, KusTree->( RecNo()) } )
            EndIf
            AADD( aRecNO  , KusTree->( RecNo()) )
          EndIf

        ENDIF
*/
        KusTree->( DBSKIP() )
      ENDDO

    NEXT

    aNode    := aSubNode
    aSubNode := {}
  ENDDO

RETURN self

* addItem
********************************************************************************
METHOD VYR_KusTREE_gen:addItem(oParent, cCaption, nIcon, mData)
  LOCAL oItem

  oItem := oParent:addItem( cCaption, nIcon, nIcon, nIcon, NIL, mData)
  oItem:setData( KusTREE->( RECNO() ) )
  AADD( ::TreeITEMs, oItem )
  IF ::nTreeRecNO = KusTREE->( RECNO() )
    ::oTreeItem := oItem
  ENDIF
*  oItem:dataLink := {|| KusTREE->( RECNO()) }

  IF ::show_Tree = Tree_FULL
    oParent:expand( .T.)   // zoobrazí celý kusovník rozbalený
  ENDIF
RETURN oItem

*
********************************************************************************
METHOD  VYR_KusTREE_gen:TreeRebuild()
  LOCAL aItems

  ::oTree:lockUpdate( .T. )

  aItems := ::oTree:rootItem:getChildItems()
  AEval( aItems, {|O| ::oTree:rootItem:delItem(O) } )
  ::Treeinit(::oTree:cargo, KusTREE->( RECNO()))

  ::oTree:LockUpdate( .F. )
RETURN self

*
********************************************************************************
METHOD VYR_KusTREE_gen:dlgSearch( nKey, oTreeView)
   Local nEvent, mp1 := Nil, mp2 := Nil
   Local oDlg, oXbp, drawingArea, oBtn, aPos:={}, oSeek := Nil
   Local aSize, aPSize, bItemSelected
*   Local aSearch := { 'Skladová položka', 'Název zboží'}, bItemSelected
   Local aSearch := { { 1, 'Skladová položka'},;
                      { 2, 'Název zboží'     } }

   aSize  := {500,100}    // {419,143}
   aPSize := AppDesktop():currentSize()
   aPos   := { (aPSize[1] - aSize[1]) / 2, ;
               (aPSize[2] - aSize[2]) / 2  }
   *
   oDlg:=XbpDialog():new(AppDesktop(), SetAppWindow(), aPos, aSize, , .F.)
   oDlg:icon:= DRG_ICON_FIND
   oDlg:taskList:=.T.
   oDlg:border:=XBPDLG_RAISEDBORDERTHIN_FIXED
   oDlg:close:={|mp1,mp2,obj| PostAppEvent(xbeP_Close) }
   oDlg:title:="Hledej..."
   oDlg:create()
   oDlg:setModalState(XBP_DISP_APPMODAL)
   drawingArea:=oDlg:drawingArea
   drawingArea:setFontCompoundName("8.Arial")
   *
   oXbp:=XbpStatic():new(drawingArea, , {15,40}, {110,24})
   oXbp:caption:= 'dle kritéria'
   oXbp:clipSiblings:=.T.
   oXbp:options:=XBPSTATIC_TEXT_VCENTER+XBPSTATIC_TEXT_RIGHT  //LEFT
   oXbp:create()

   oCombo := XbpCombobox():new( drawingArea, , {15,20}, {110,24} )
   oCombo:clipSiblings := .T.
   oCombo:type := XBPCOMBO_DROPDOWNLIST
   oCombo:create()
   AEVAL( aSearch, {|c| oCombo:addItem(c[2]) } )
   oCombo:xbpListbox:setData( {1} )

*   bItemSelected := {|mp1,mp2,O| TEST (mp1, mp2, O) }
   bItemSelected := {|mp1,mp2,O| ::nSearch := O:getData()[1]  }
   oCombo:ItemSelected := bItemSelected
*   oCombo:xbpSle:setData( {1} )

*   oSeek:=XbpSLE():new(oGroup, , {12,35}, {350,24}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } })
   oSeek:=XbpSLE():new( drawingArea, , {140, 20}, {250,24}, { { XBP_PP_BGCLR, XBPSYSCLR_ENTRYFIELD } })
   oSeek:tabStop:=.T.
   oSeek:create()
   oSeek:setData( CHR( nKey))
   oSeek:setMarked( {2,2} )
   oSeek:keyBoard:={| nKey, uNIL, self | oTreeView:SearchInTree( nKey, 'KusTree', oSeek, oTreeView) }
   *
   oBtn := XbpPushButton():new( drawingArea, , {400,20}, {90,24} )
   oBtn:caption := "Další výskyt"
   oBtn:create()
   oBtn:activate:= {|| oTreeView:SearchInTree( , 'KusTree', oSeek, oTreeView) }
   *
   oDlg:show()

   SetAppFocus(oSeek)
   oTreeView:SearchInTree( nKey, 'KusTree', oSeek, oTreeView)

   nEvent:=xbe_None
   Do While nEvent<>xbeP_Close  // +1000
      nEvent:=AppEvent(@mp1, @mp2, @oXbp)

      IF nEvent == xbeUser_Eval
         Eval( mp1, oXbp )
*         oBrowse:cargo:drgDialog:dataManager:refresh()
         PostAppEvent( xbeTV_ItemMarked, ::oTreeItem,, ::oTree )

      ELSEIF nEvent == xbeTV_ItemMarked
         PostAppEvent( xbeTV_ItemMarked, ::oTreeItem,, ::oTree )
      ELSE
         oXbp:handleEvent( nEvent, mp1, mp2 )
      ENDIF

   EndDo

   ::cSeaKEY := ''
   oDlg:destroy()
   SetAppFocus( ::oTree)
RETURN

PROCEDURE TEST(mp1, mp2, O)
  O:nSearch := O:getData()[ 1]
RETURN
*
********************************************************************************
METHOD  VYR_KusTREE_gen:SearchInTree( nKey, cFILE, oSeek)
  Local  nPos, C
  Local  nRecNo := ( cFILE)->( RecNo()), cTag := ( cFILE)->( OrdSetFocus())
  Local  lCtrl_L := ( nKey = NIL ), lSEEK

  IF nKey == xbeK_ESC .or. nKey == xbeK_ENTER
    ::cSeaKEY := ''
    PostAppEvent( xbeP_Close, nKey, NIL, oSeek )
    RETURN
  ENDIF

  IF IsNIL( nKEY)
    * Další výskyt
    KusTREE->( dbSKIP())
  ELSE
    ::cSeaKEY := If( nKey = xbeK_BS, LEFT( ::cSeaKEY, Len( ::cSeaKEY) -1),;
                 If( lCtrl_L, ::cSeaKEY, ::cSeaKEY + CHR( nKEY) ))
  ENDIF

  If !EMPTY( ::cSeaKEY) .or. ( EMPTY( ::cSeaKEY) .and. !lCtrl_L )
    * If( lCtrl_L, NIL, oB:GoTop() )
    C := IF( ::nSearch = 1, "LEFT(cSklPol,", "LEFT(cNazev," )
    C +=  STR(LEN( ::cSeaKey)) + ") = " + "'" + Upper(::cSeaKey) + "'"

    If( lSEEK := ( cFILE)->( dbLocate( COMPILE( C),,,, lCtrl_L) ))
    Else
      Tone(500)
    EndIf
  EndIF
  *
  nPos := ASCAN( ::TreeItems, {|O| O:UndoBuffer = KusTree->( RecNO()) } )
  IF( nPos > 0, ::oTree:setData( ::oTreeItem := ::TreeItems[ nPos] ), NIL )

RETURN self

*
********************************************************************************
METHOD VYR_KusTREE_gen:destroy()

  ::drgUsrClass:destroy()
  *
  ::oDrg    := oTree      := ;
  ::nRozpad := nRecNoRoot :=  ::show_Tree := ::nSearch := ;
  NIL

RETURN self