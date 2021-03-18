/*==============================================================================
  VYR_KusTREE_ex_gen.PRG
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
CLASS VYR_KusTREE_ex_gen
EXPORTED:
  VAR     oDrg
  VAR     oTree, oRoot, show_Tree
  VAR     nROZPAD
  VAR     nRecnoRoot, nTreeRecNO, oTreeItem
  VAR     TreeITEMs, cSeaKey, nSearch     // pro dohledávání
  var     cvyrPol, nmnFinal

  // Saves or loads the control's layout, such as positions of the columns, scroll position, filtering values.
  var     tre_Layout

  METHOD  Init, Destroy
  METHOD  TreeInit, TreeRebuild

  method  ex_fillTree

  ** edit
  inline method OnClick(oTree)
    local oItems := oTree:Items()

    if ( .not. kusTree->lnakPol .and. empty(kusTree->ccisZakaz) )
      oItems:Edit(oItems:FocusItem(), "mnZadVýr" ) // 4
    endif
  return self


  inline method OnAfterCellEdit(oTree,Item,ColIndex,NewCaption)
    local  oItems   := oTree:Items()
    local  pa_items := oTree:getItems(1)   // vrátí pole h položek, 1 je ROOT
    *
    local  ncnt, nIn, x, hChild, hc, recNo, recNo_org
    local  sid := if( kusTree->nKUSOV = 1, 0, kusTree->nKUSOV )
    *
    local  pa        := {}
    local  mnozZadan := val(NewCaption)
    local  mnozTopTree

    oTree:Items():SetProperty("CellCaption",Item,ColIndex,NewCaption)

    if ( KusTree->nmnozZadan <> val(NewCaption) .or.  oItems:ItemParent(Item) = 0 )
      oTree:BeginUpdate()


      if( hParent := oItems:ItemParent(Item)) = 0 // Root item

        ::nmnFinal := val(NewCaption)
        kusTree->(ordSetFocus('TREE1'),dbgoTop())
        *
        ** root
        KusTree->nmnozZadan := val(NewCaption)
        KusTree->nspMNOnas  := KusTree->nSpMno    *KusTree->nmnozZadan
        KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
        kusTree->( dbskip())

        cKy       :=  Left( KusTree->cTreeKey, 3 )

        if .not. kusTree->lnakPol
          do case
          case KusTree->nmnozDzbo    = 0
            mnozZadan := val(NewCaption)

          case ( KusTree->nmnozDzbo >= (KusTree->nSpMno * mnozZadan) )
            mnozZadan := 0

          case ( KusTree->nmnozDzbo <  (KusTree->nSpMno * mnozZadan) )
            mnozZadan := val(NewCaption) - KusTree->nmnozDzbo
          endcase
        endif


        do while .not. kusTree->( eof())
          KusTree->nmnozZadan := mnozZadan

//          KusTree->nspMNOnas  := KusTree->nSpMno    * if( kusTree->lnakPol, KusTree->nmnozZadan, val(NewCaption) )

          if kusTree->lnakPol
             KusTree->nspMNOnas  := KusTree->nSpMno    * KusTree->nmnozZadan
          else
            do case
            case Len( AllTrim(KusTree->cTreeKey)) <= 6
               KusTree->nspMNOnas  := KusTree->nSpMno    * val(NewCaption)
            case mnozZadan <> 0
               KusTree->nspMNOnas  := KusTree->nSpMno    * mnozZadan
            otherwise
               KusTree->nspMNOnas  := 0
//             KusTree->nspMNOnas  := KusTree->nSpMno    * val(NewCaption)
            endcase

//             KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
          endif

          KusTree->nmnozZadan := KusTree->nSpMno    * mnozZadan   // asi ne val(NewCaption)
          KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
          kusTree->( dbSkip())

          if cKy <> Left( KusTree->cTreeKey, 3 )
            cKy       :=  Left( KusTree->cTreeKey, 3 )
            mnozZadan := val(NewCaption)

            if .not. kusTree->lnakPol
            do case
              case KusTree->nmnozDzbo    = 0
                mnozZadan := val(NewCaption)

              case ( KusTree->nmnozDzbo >= (KusTree->nSpMno * mnozZadan) )
                mnozZadan := 0

              case ( KusTree->nmnozDzbo <  (KusTree->nSpMno * mnozZadan) )
                mnozZadan := val(NewCaption) - KusTree->nmnozDzbo
              endcase
            endif
          endif
        enddo

      else

        recNo_org := kusTree->( recNo())
        hParent   := oItems:ItemParent(Item)   // 0 = Root item
        recNo     := oItems:cellData( hParent, 0 )

          KusTree->( dbGoTO( recNo))
          nmnozZadan := KusTree->nmnozZadan
          KusTree->( dbGoTO( recNo_org))

        KusTree->nmnozZadan := val(NewCaption)


//        KusTree->nspMNOnas  := KusTree->nSpMno * if( kusTree->lnakPol, KusTree->nmnozZadan, ::nmnFinal )

        if kusTree->lnakPol
          KusTree->nspMNOnas  := KusTree->nSpMno * KusTree->nmnozZadan
        else
          do case
          case Len( AllTrim(KusTree->cTreeKey)) <= 6
            KusTree->nspMNOnas  := KusTree->nSpMno    * ::nmnFinal
          case mnozZadan <> 0
            KusTree->nspMNOnas  := KusTree->nSpMno    * nmnozZadan
          otherwise
          endcase
        endif

        KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas

        if( nCnt := oItems:ChildCount(Item)) <> 0
          mnozTopTree := val(NewCaption)
          nIn  := ascan( pa_items, Item )

          ::recItem( oTree, Item, pa )

          for x := 1 to len(pa) step 1
            hChild := pa[x]
            recNo  := oItems:CellData( hChild, 0)

            if( isNumber(recNo), KusTree->( dbGoTO( recNo)), nil )
            KusTree->nmnozZadan := val(NewCaption)

            if kusTree->lnakPol
//            KusTree->nspMNOnas  := KusTree->nSpMno   * KusTree->nmnozZadan
              KusTree->nspMNOnas  := KusTree->nspMno_J * KusTree->nmnozZadan
            else
              KusTree->nspMNOnas  := KusTree->nspMno_J * KusTree->nmnozZadan

/*
              do case
              case mnozTopTree <> 0 .and. mnozTopTree <> ::nmnFinal
                KusTree->nspMNOnas  := KusTree->nSpMno   * mnozTopTree
              case mnozTopTree = 0
                KusTree->nspMNOnas  := KusTree->nSpMno   * mnozTopTree
              case nmnozZadan <> 0
                KusTree->nspMNOnas  := KusTree->nSpMno   * nmnozZadan
              otherwise
                KusTree->nspMNOnas  := KusTree->nSpMno   * ::nmnFinal
              endcase
*/
            endif

//          KusTree->nmnozZadan := KusTree->nSpMno    * val(NewCaption)
            KusTree->nmnozZadan := KusTree->nspMno_J  * val(NewCaption)
            KusTree->nrozD_NAS  := KusTree->nmnozDzbo -KusTree->nSpMnoNas
          next
        endif
      endif

      kusTree->( dbgoTop())

      oItems:RemoveAllItems()
      ::ex_fillTree()
      oTree:setProperty( 'Layout', ::tre_Layout )

      // postavit se záznam  podle sid
      if ( hc := oItems:FindItemData(sid) ) <> 0
        oItems:setProperty("SelectItem", hc, .t. )
        oItems:EnsureVisibleItem(hc)

        recNo  := oItems:CellData( hc, 0)
        kusTree->( dbgoTo( recNo))
      endif

      oTree:EndUpdate()
    endif
  return


  inline method OnCancelCellEdit(oTree,Item,ColIndex,Reserved)
    oTree:Items():SetProperty("CellCaption",Item,ColIndex,Reserved)
  return self


  inline method RecItem( oTree, h, pa )
    local  oItems := oTree:Items()
    local  hChild

    if .not. ( h = 0 )
      hChild := oItems:ItemChild(h)
      if( hChild <> 0, aadd( pa, hChild ), nil )

      do while .not. ( hChild = 0 )
        ::RecItem( oTree, hChild, pa)

        hChild := oItems:NextSiblingItem(hChild)
        if( hChild <> 0, aadd( pa, hChild ), nil )
      enddo
    endif
  return
  ** edit

ENDCLASS

*
********************************************************************************
METHOD VYR_KusTREE_ex_gen:init(parent, show_Tree)

  DEFAULT show_Tree TO Tree_FULL
  *
  ::show_Tree  := show_Tree
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
//  netuším  VyrPOL->( DbSetRelation( 'VyrZAK', { || Upper(VyrPOL->cCisZakaz) },'Upper(VyrPOL->cCisZakaz)'))
  drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  KusTree->( AdsSetOrder( 1))

RETURN self

*
********************************************************************************
METHOD  VYR_KusTREE_ex_gen:TreeInit( oDrg, TreeRecNO)
  LOCAL cFilter, fromNabVys, nmnFinal

  DEFAULT ::nRecNoROOT TO VyrPol->( RecNO()), TreeRecNO TO 1

  IF( ::nRecNoROOT <> VyrPol->( RecNO()), VyrPol->( dbGoTO( ::nRecNoROOT)), NIL )

  ::nTreeRecNO := TreeRecNO
  * pro dohledávání
  ::TreeITEMs  := {}     // uložení všech záznamù stromu
  ::cSeaKEY    := ''     // hledaný øetìzec
  ::nSearch    := 1      // kritérium hledání  ( 1 = cSklPol, 2 = cNazev)

*  ::oTree:FullRowMark := .T.   ???
  ** Vygenerovat KusTree
  KusTREE->( dbZAP())

//  ::oTree:parent:cargo:drgDialog:dbName

  fromNabVys := .f.   // ( oDrg:drgDialog:parent:dbName = 'NabVysHDw')

//GenTreeFILE( nRozpad, lMomentBox, nMnFinal, lNakPolCFG, fromNabVys )

  nmnFinal   := if( empty(vyrZak->ccisZakaz), 1,vyrZak->nmnozZadan )
  ::cvyrPol  := vyrZak->cvyrPol
  ::nmnFinal := nmnFinal

  GenTreeFILE( ::nRozpad,, nmnFinal,, fromNabVys)
  *

  IF ::nRozpad = ROZPAD_POPOL
    * vyfiltrují se pouze vyrábìné položky
    cFilter := "lNakPol = .F."
    KusTREE->( mh_SetFILTER( cFilter))               // Ads_SetAof( cFilter), dbGoTOP() )
  ENDIF
  *
  ** Test
*  ::nROZPAD := IsNULL( ::nROZPAD, 1000)

  *
  ** Naplnit TreeView
  ::tre_Layout := ''

  if isObject(oDrg) .and. oDrg:ClassName() = 'drgTreeView'
    ::tre_Layout := drgScrPos:getTre_Layout( 'VYR_KusTREE_ex_scr', oDrg:drgDialog, 'KUSTREE' )
  endif
  ::ex_fillTree(odrg, .t.)
RETURN self


method VYR_KusTREE_ex_gen:ex_fillTree(drgObj, lres_Layout)
  local  oBord, apos, asize
  *
  local  oColumns, oColumn
  local  anode := {}, asubNode := {}, nvyrST, wvyrST
  local  vysPol
  *
  local  hRoot
  local  oFont_task  := XbpFont():new():create( "10.Helvetica BOLD" )
  local  nColor_task := AutomationTranslateColor( GRA_CLR_BLUE, .f. )
  local  nColor_vyr  := AutomationTranslateColor( GRA_CLR_DARKGREEN, .f. )
  local  citem

  default lres_Layout to .f.

  if .not. isObject(::oTree)
    oBord := drgObj:oBord
    apos  := drgObj:oxbp:currentPos()
    asize := drgObj:oxbp:currentSize()

    ::oTree := XbpActiveXControl():new( oBord )
    ::oTree:CLSID  := "Exontrol.Tree.1" // {3C5FC763-72BA-4B97-9985-81862E9251F2}
    ::oTree:create(,, apos, asize )

    drgObj:oxbp:hide()
    drgObj:oxbp := ::oTree
  endif

  ::oTree:LinesAtRoot      := -1           // exLinesAtRoot
  ::oTree:hasLines         :=  1           // .t.   0, -1, 1, 2
  ::oTree:DrawGridLines    := -1           // exAllLines
  ::oTree:ExpandOnDblClick := .f.

  ::oTree:LbClick       := { ||     ::treeItemMarked(::oTree, 0   ) }
  ::oTree:LbDblClick    := { ||     ::treeItemMarked(::oTree, xbeK_ENTER ) }
  ::oTree:KeyBoard      := { |nkey| ::treeItemMarked(::oTree, nkey) }

  ** edit
  ::oTree:AllowEdit      := empty(kusTree->ccisZakaz)
  ::oTree:SelStart       := 10
  ::oTree:AfterCellEdit  := {|Item,ColIndex,NewCaption| ::OnAfterCellEdit(::oTree,Item,ColIndex,NewCaption)}
  ::oTree:CancelCellEdit := {|Item,ColIndex,Reserved|   ::OnCancelCellEdit(::oTree,Item,ColIndex,Reserved) }
  ::oTree:RClick         := {|| ::OnClick(::oTree) }
  ** edit


  if ::oTree:Columns:Count() = 0 // init, nebo chce pùvodní nastavení Tree

    oColumn              := ::oTree:Columns():Add( kusTree->cvyrPol)
    oColumn:AllowSort    := .f.
    oColumn:SetProperty("Def",  3, .T.)    // exCellHasCheckBox//
    oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)
    oColumn:PartialCheck := .T.
    **
    oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)
    oColumn:Width := 150
    oColumn:DisplayFilterButton := .T.
    ::oTree:SetProperty("Description",3/*exFilterBarFilterForCaption*/,"new caption")

    * 1
    oColumn := ::oTree:Columns():Add("rPos")
    oColumn:FormatColumn := "1 rpos ``"
    oColumn:AllowSort := .F.
    oColumn:SetProperty("Def",4/*exCellBackColor*/,15790320)
    oColumn:SetProperty("Def",5/*exCellForeColor*/,8421504)
    oColumn:SetProperty("Def",8/*exHeaderForeColor*/,oColumn:Def(5/*exCellForeColor*/))
    oColumn:Position  := 0
    * 2
    oColumn := ::oTree:Columns():Add("pozice")
    oColumn:AllowSort := .f.
    oColumn:Position  := 1
    * 3
    oColumn := ::oTree:Columns():Add("název položky")
    oColumn:AllowSort := .f.
*    oColumn:WidthAutoResize := .T. // test, v editaci posouvá sloupce
    * 4
    ::oTree:Columns():Add("spMnož/1"):AllowSort := .f.
    * 5
    ::oTree:Columns():Add("spMnož/výr"):AllowSort := .f.
    * 6
    oColumn := ::oTree:Columns():Add("mnZadVýr")
    oColumn:AllowSort    := .f.
    * 7
    ::oTree:Columns():Add("mj"):AllowSort := .f.
    * 8
    ::oTree:Columns():Add("spMnZak"):AllowSort := .f.
    * 9
    ::oTree:Columns():Add("dispMnož"):AllowSort := .f.
    * 10
    oColumn := ::oTree:Columns():Add("rozS_zak")
    oColumn:AllowSort := .f.
    oColumn:FormatColumn := "type(value) in (0,1) ? 'null' : ( dbl(value)<0 ? '<fgcolor=FF0000>'+ (value format '2|.|3|,|1' ) : (dbl(value)>0 ? '<fgcolor=0000FF>+'+(value format '2|.|3|,' ): '0.00') )"
    oColumn:SetProperty("Def",17/*exCellCaptionFormat*/,1)

    oColumn := ::oTree:Columns():Add("recNo")
    oColumn:AllowSort := .f.
    oColumn:setProperty( "Visible", .f. )

  else
    ocolumn := ::oTree:Columns():Item( kusTree->cvyrPol)
  endif

  aadd( anode, { ocolumn, 1, .f., '' } )

  oItems := ::oTree:Items()
  cItem  := KusTree->cNazev
  hRoot  := oItems:addItem(citem)
            oItems:SetProperty("CellCaption",hRoot, 3,kusTree->cnazev    )
            oItems:SetProperty("CellCaption",hRoot, 4,KusTree->nspMno_J  )
            oItems:SetProperty("CellCaption",hRoot, 5,KusTree->nSpMno    )
            oItems:SetProperty("CellCaption",hRoot, 6,KusTree->nmnozZadan)
            oItems:SetProperty("CellCaption",hRoot, 7,KusTree->cmjSpo    )
            oItems:SetProperty("CellCaption",hRoot, 8,KusTree->nspMNOnas )
            oItems:SetProperty("CellCaption",hRoot, 9,KusTree->nmnozDzbo )
            oItems:SetProperty("CellCaption",hRoot,10,KusTree->nrozD_NAS )

            oItems:SetProperty("CellData"   ,hRoot, 0,kusTree->( recno()))
            oItems:SetProperty("ItemData",   hRoot,   0                  )



  do while len(anode) > 0
    for x := 1 to len(anode) step 1
      KusTree->( DBGOTO( aNode[ x, 2]) )
      nVyrST := KusTree->nVyrST

      KusTree->( DBSKIP() )

      if anode[x,3]
         h := anode[x,1]  // , cvyrPol := anode[x,4] )
      endif

      do while .not. kusTree->( eof())
        wVyrST  := KusTree->nVyrST

        IF wVyrST = nVyrST + 1
          vysPol := kusTree->cvysPol
          citem  := IF( KusTree->lNakPOL, KusTree->cSklPOL, KusTree->cVyrPol)

          if anode[x,3]
             if vysPol = anode[x,4]
               hc := oItems:InsertItem( h, 0, citem  )
                     oItems:SetProperty("CellCaption",hc, 2, kusTree->npozice   )
                     oItems:SetProperty("CellCaption",hc, 3, kusTree->cnazev    )
                     oItems:SetProperty("CellCaption",hc, 4, KusTree->nspMno_J    )
                     oItems:SetProperty("CellCaption",hc, 5, KusTree->nSpMno    )
                     oItems:SetProperty("CellCaption",hc, 6, KusTree->nmnozZadan)
                     oItems:SetProperty("CellCaption",hc, 7, KusTree->cmjSpo    )
                     oItems:SetProperty("CellCaption",hc, 8, KusTree->nspMNOnas )
                     oItems:SetProperty("CellCaption",hc, 9, KusTree->nmnozDzbo )
                     oItems:SetProperty("CellCaption",hc,10, KusTree->nrozD_NAS )
                     *
                     oItems:SetProperty("CellData"   ,hc, 0, kusTree->( recno()))
                     oItems:SetProperty("ItemData",   hc,    kusTree->nKUSOV    )

                     oItems:SetProperty("ExpandItem" ,hc,.T.)

                    if .not. kusTree->lnakPol
                      for nit := 0 to 6 step 1
                       oItems:setProperty( "CellFont"     , hc, nit, oFont_task )
                       oItems:setProperty( "CellForeColor", hc, nit, nColor_vyr )
                     next
                   endif

               aadd( asubNode, { hc, kusTree->( recno()), .t., kusTree->cvyrPol } )
             endif

          else
            h := oItems:InsertItem( hRoot, 0, citem  )
                 oItems:SetProperty("CellCaption", h, 2, kusTree->npozice   )
                 oItems:SetProperty("CellCaption", h, 3, kusTree->cnazev    )
                 oItems:SetProperty("CellCaption", h, 4, KusTree->nspMno_J    )
                 oItems:SetProperty("CellCaption", h, 5, KusTree->nSpMno    )
                 oItems:SetProperty("CellCaption", h, 6, KusTree->nmnozZadan)
                 oItems:SetProperty("CellCaption", h, 7, KusTree->cmjSpo    )
                 oItems:SetProperty("CellCaption", h, 8, KusTree->nspMNOnas )
                 oItems:SetProperty("CellCaption", h, 9, KusTree->nmnozDzbo )
                 oItems:SetProperty("CellCaption", h,10, KusTree->nrozD_NAS )
                 *
                 oItems:SetProperty("CellData"   , h, 0, kusTree->( recno()))
                 oItems:SetProperty("ItemData"   , h,    kusTree->nKUSOV    )
                 oItems:SetProperty("ExpandItem" , h,.T.)

                 if .not. kusTree->lnakPol
                   for nit := 0 to 6 step 1
                     oItems:setProperty( "CellFont"     , h, nit, oFont_task )
                     oItems:setProperty( "CellForeColor", h, nit, nColor_vyr )
                   next
                 endif

            aadd( asubNode, { h, kusTree->( recno()), .t., kusTree->cvyrPol } )
          endif
        endif
        kusTree->( dbSkip())
      enddo
    next

    anode := aclone(asubNode)
    asubNode := {}
  enddo

  *  bacha musí být tady
  if( lres_Layout, ::oTree:setProperty( 'Layout', ::tre_Layout ), nil )

*  ::oTree:SetProperty("Background",166/*exSelBackColorHide*/,AutomationTranslateColor( GraMakeRGBColor  ( { 196,196,196 } )  , .F. ))
*  ::oTree:SetProperty("Background",167/*exSelForeColorHide*/,AutomationTranslateColor( GraMakeRGBColor  ( { 0,0,1 } )  , .F. ))

  oItems:SetProperty("ExpandItem",hRoot,.T.)
  oItems:setProperty("SelectItem",hroot,.T.)
return self


*
********************************************************************************
METHOD  VYR_KusTREE_ex_gen:TreeRebuild()
  LOCAL aItems

  ::oTree:lockUpdate( .T. )

  aItems := ::oTree:rootItem:getChildItems()
  AEval( aItems, {|O| ::oTree:rootItem:delItem(O) } )
  ::Treeinit(::oTree:cargo, KusTREE->( RECNO()))

  ::oTree:LockUpdate( .F. )
RETURN self


*
********************************************************************************
METHOD VYR_KusTREE_ex_gen:destroy()

  ::drgUsrClass:destroy()
  *
  ::oDrg    := oTree      := ;
  ::nRozpad := nRecNoRoot :=  ::show_Tree := ::nSearch := ;
  NIL

RETURN self