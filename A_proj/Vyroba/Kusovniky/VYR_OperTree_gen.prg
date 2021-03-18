/*==============================================================================
  VYR_OperTREE_gen.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "gra.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_OperTREE_gen
EXPORTED:
  VAR     oDrg
  VAR     oTree, oRoot
  VAR     nROZPAD
  VAR     nRecnoRoot, nTreeRecNO, oTreeItem

  METHOD  Init
  METHOD  TreeInit
  METHOD  TreeRebuild
  METHOD  Destroy

  METHOD  fillTree
  METHOD  addItem

ENDCLASS

*
********************************************************************************
METHOD VYR_OperTREE_gen:init(parent)

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
  drgDBMS:open('OperTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  OperTree->( AdsSetOrder( 1))

RETURN self

*
********************************************************************************
METHOD  VYR_OperTREE_gen:TreeInit( oDrg, TreeRecNO)
  LOCAL cFilter

  DEFAULT ::nRecNoROOT TO VyrPol->( RecNO()), TreeRecNO TO 1

  IF( ::nRecNoROOT <> VyrPol->( RecNO()), VyrPol->( dbGoTO( ::nRecNoROOT)), NIL )

  ::oTree := oDrg:oXbp
  ::nTreeRecNO := TreeRecNO

*  ::oTree:FullRowMark := .T.   ???
  ** Vygenerovat KusTree
  KusTREE->( dbZAP())
  GenTreeFILE( ::nRozpad)   //(0)
  GenOperTree()
  *
  *
  ** Test
*  ::nROZPAD := IsNULL( ::nROZPAD, 1000)
  ** Naplnit TreeView
  ::fillTree( ::oTree:rootItem )
*  ::oTree:rootItem:expand(.T.)
  ::oTree:setColorBG(GraMakeRGBColor( {220, 220, 250} ))
  ::oTree:alwaysShowSelection        := .T.

RETURN self

*
********************************************************************************
METHOD  VYR_OperTREE_gen:fillTREE(Obj)
  LOCAL oFinal, oItem, cItem, cPozice
  LOCAL aNode := {}, aSubNode := {}, aRecNO := {}
  LOCAL N, nVyrST, wVyrST, cTreeKey, wTreeKey, cKey, lWrt
  LOCAL xRec, nCnt := 0, nTest := 2 , lPol, lOper

  OperTree->( DBGOTOP() )
//  cItem := KusTree->cNazev  + ' - ' + STR(KusTree->(RecNo()))
  cItem := OperTree->cNazev  + ' - ' + STR(OperTree->nSpMno) + ' ' + OperTree->cZkratJedn
  oFinal := ::addItem( ::oTree:rootItem, cItem,, OperTree->( RecNo())  ) //, ICON_SET)
  AADD( aNode,{ oFinal, 1 } )
  ::oRoot := oFinal
  ::oTreeItem := oFinal

  DO WHILE  LEN( aNode) > 0
    FOR N := 1 TO LEN( aNode)
      OperTree->( DBGOTO( aNode[ N, 2]) )

      IF EMPTY( OperTree->cOznOper)
        nVyrST   := OperTree->nVyrST
        cTreeKey := ALLTRIM( OperTree->cTreeKey)
        OperTree->( DBSKIP() )

        lWrt := .T.
        WHILE !OperTree->( EOF())
            xRec := OperTree->( RecNo())
            wVyrST   := OperTree->nVyrST
            wTreeKey := ALLTRIM(OperTree->cTreeKey)
**            cPozice  := IF( EMPTY( OperTree->cOznOper), ALLTRIM( STR( OperTree->nPozice)) + '.|   '+ OperTree->cVyrPol + ' - ' + OperTree->cNazev ,;
**                                                       ' - - - ' + Str( OperTree->nCisOper) + '  ' + OperTree->cOznOper + ' - ' + OperTree->cNazOper )
            lPol  := ( nVyrST + 1 = wVyrST  .and. LEN( wTreeKey) = 3*(nVyrSt+1) .and. IF( nVyrST >= 2, LEFT( cTreeKEY, (nVyrST-1)*3) = LEFT( wTreeKEY, (nVyrST-1)*3), .T. ))
            lOper := ( nVyrST     = wVyrST  .and. '!' $ wTreeKey .and. LEFT( cTreeKEY, nVyrST*3) = LEFT( wTreeKEY, nVyrST*3) )
            IF lPol .or. lOper

              IF lWrt .and. ( nPos := ASCAN( aRecNO, OperTree->( RecNo()) )) = 0
                cPozice  := IF( EMPTY( OperTree->cOznOper), ALLTRIM( STR( OperTree->nPozice)) + '.|   '+ OperTree->cVyrPol + ' - ' + OperTree->cNazev ,;
                                                           ' - - - ' + Str( OperTree->nCisOper) + '  ' + OperTree->cOznOper + ' - ' + OperTree->cNazOper )
                cItem := cPozice + ' - ' + OperTree->cText1 + ;
                         ' - ' + STR(OperTree->nSpMno) + ' ' + OperTree->cZkratJedn + '-- ' + STR(OperTree->( RecNo()))
                oItem := ::addItem( aNode[ n, 1], cItem,, OperTree->( RecNo()) )//, ICON_SET)
                AADD( aRecNO  , OperTree->( RecNo()) )
                AADD( aSubNode, { oItem, OperTree->( RecNo()) } )
              ENDIF

            ELSEIF wVyrST < nVyrST .OR.  LEFT( cTreeKEY, nVyrST*3) <> LEFT( wTreeKEY, nVyrST*3)
*              lWrt := .F.
            ENDIF

          OperTree->( DBSKIP() )
        ENDDO
      ENDIF
    NEXT

    nCnt++
    aNode    := aSubNode // IF( nCnt <= nTest, aSubNode, {}) //  aSubNode
    aSubNode := {}
  ENDDO

  /*
  DO WHILE  LEN( aNode) > 0
    FOR N := 1 TO LEN( aNode)
      OperTree->( DBGOTO( aNode[ N, 2]) )

**      IF EMPTY( OperTree->cOznOper)
      nVyrST   := OperTree->nVyrST
      cTreeKey := ALLTRIM( OperTree->cTreeKey)
      OperTree->( DBSKIP() )

      lWrt := .T.
      WHILE !OperTree->( EOF())
          xRec := OperTree->( RecNo())
          wVyrST   := OperTree->nVyrST
          wTreeKey := ALLTRIM(OperTree->cTreeKey)
          cPozice  := IF( EMPTY( OperTree->cOznOper), ALLTRIM( STR( OperTree->nPozice)) + '.|   '+ wtreekey + '  ' + OperTree->cVyrPol + ' - ' + OperTree->cNazev ,;
                                                     ' - - - ' + wtreekey + ' - - - ' + Str( OperTree->nCisOper) + '  ' + OperTree->cOznOper + ' - ' + OperTree->cNazOper )
          IF ( nVyrST + 1 = wVyrST  .and. LEN( wTreeKey) = 3*(nVyrSt+1) ) .or. ;
             ( nVyrST     = wVyrST  .and. '!' $ wTreeKey .and. LEFT( cTreeKEY, nVyrST) = LEFT( wTreeKEY, nVyrST) )
*             ( nVyrST     = wVyrST  .and. '!' $ wTreeKey )
            IF lWrt  //   ( nPos := ASCAN( aRecNO, OperTree->( RecNo()) )) = 0
              cItem := cPozice + ' - ' + OperTree->cText1 + ;
                       ' - ' + STR(OperTree->nSpMno) + ' ' + OperTree->cZkratJedn + '-- ' + STR(OperTree->( RecNo()))
              oItem := ::addItem( aNode[ n, 1], cItem,, OperTree->( RecNo()) )//, ICON_SET)
              AADD( aRecNO  , OperTree->( RecNo()) )
              IF EMPTY( OperTree->cOznOper)
                AADD( aSubNode, { oItem, OperTree->( RecNo()) } )
              ENDIF
            ENDIF
*            AADD( aRecNO  , OperTree->( RecNo()) )
          ELSEIF wVyrST < nVyrST   .OR.  LEN( wTreeKey) <> 3*(nVyrSt+1) // .not. '!' $ wTreeKey
*            lWrt := .F.
          ENDIF

        OperTree->( DBSKIP() )
      ENDDO
**      ENDIF
    NEXT

    aNode    := aSubNode
    aSubNode := {}
  ENDDO
  */
RETURN self

* addItem
********************************************************************************
METHOD VYR_OperTREE_gen:addItem(oParent, cCaption, nIcon, mData)
  LOCAL oItem

  oItem := oParent:addItem( cCaption, nIcon, nIcon, nIcon, NIL, mData)
  oItem:setData( OperTREE->( RECNO() ) )
  IF ::nTreeRecNO = OperTREE->( RECNO() )
    ::oTreeItem := oItem
  ENDIF
*  oItem:dataLink := {|| KusTREE->( RECNO()) }
  oParent:expand( .T.)
RETURN oItem

*
********************************************************************************
METHOD  VYR_OperTREE_gen:TreeRebuild()
  LOCAL aItems

  ::oTree:lockUpdate( .T. )

  aItems := ::oTree:rootItem:getChildItems()
  AEval( aItems, {|O| ::oTree:rootItem:delItem(O) } )
  ::Treeinit(::oTree:cargo, OperTREE->( RECNO()))

  ::oTree:LockUpdate( .F. )
RETURN self

*
********************************************************************************
METHOD VYR_OperTREE_gen:destroy()

  ::drgUsrClass:destroy()
  *
  ::oDrg    := oTree      := ;
  ::nRozpad := nRecNoRoot := ;
  NIL

RETURN self


* Generov n¡ strukt. kusovn¡ku s operacemi do OPERTREE
*-------------------------------------------------------------------------------
Function GenOperTree()
  Local cText, cChar, cTag, lLast
  Local cSklPol, cNazZbo, cNizPol, cNazevNiz, nNizVar, nSpMnoNaNi
  Local cFinVyr, nFinVar, nNhCELK, nKcCELK
  Local nPos, nCountVP := 0  // PoŸet vyr. polo§ek v KusTree

  drgDBMS:open( 'C_PRACOV' )
  OperTREE->( dbZAP())
*  CreateTMP( 'OperTree', 'OperTree', NO )
  KusTree->( dbGoTop())
  KusTree->( dbEval( {|| If( !KusTree->lNakPol, nCountVP++, Nil) }))
  KusTree->( dbGoTop())
  cFinVyr := KusTREE->cVyrPol
  nFinVar := GetVarPos()  // KusTREE->nVarCis

  Do While !KusTree->( Eof())
    If !KusTree->lNakPol
       KusTree->( dbSkip())
       IF KusTree->lNakPol
          cSklPol    := KusTree->cSklPol
          cNazZbo    := KusTree->cNazev
          cNizPol    := EMPTY_VYRPOL // SPACE( 15)
          nNizVar    := 0
          cNazevNiz  := SPACE( 30)
       ELSE
          cSklPol    := SPACE( 15)
          cNazZbo    := SPACE( 30)
          cNizPol    := KusTree->cVyrPol
          nNizVar    := KusTree->nVarCis
          cNazevNiz  := KusTree->cNazev
       ENDIF
       nSpMnoNaNi := KusTree->nSpMnoNas
       KusTree->( dbSkip(-1))
       If AddRec( 'OperTree')
          mh_CopyFLD( 'KusTree', 'OperTree')
          //-29.10.02
          OperTREE->cVyssiPol := KusTREE->cVysPol
          OperTREE->nVyssiVar := KusTree->nVysVar
          OperTREE->cVysPol   := KusTREE->cVyrPol
          OperTREE->nVysVar   := KusTREE->nVarCis
          //-
          OperTREE->cFinVyr  := cFinVyr
          OperTREE->nFinVar  := nFinVar
          OperTree->( dbUnlock())
          VYR_ScopeOper( .T.)   // ScopeOper( .F., .T.)
          Do While !PolOper->( Eof())
            If AddRec( 'OperTree')
               //Ä Jen pro potýeby dohled v n¡
               //PutItem( 'OperTree', 'KusTree' )
                mh_CopyFLD( 'KusTree', 'OperTree')
               //-29.10.02
               OperTREE->cVyssiPol := KusTREE->cVysPol
               OperTREE->nVyssiVar := KusTree->nVysVar
               OperTREE->cVysPol   := KusTREE->cVyrPol
               OperTREE->nVysVar   := KusTREE->nVarCis
               //
               OperTREE->cFinVyr   := cFinVyr
               OperTREE->nFinVar   := nFinVar
               OperTree->lNakPol   := YES
               OperTree->cNazev    := If( EMPTY( Operace->cNazOper) ,;
                                          'N zev operace neuveden !',;
                                          Operace->cNazOper )
               OperTree->cVyrPol   := PolOper->cOznOper
               *
               lLast := ( ( nPos := AT( 'À', KusTree->cTreeText )) <> 0 ) .OR. ;
                          nCountVP == 1
               cChar := If( lLast, ' ...', '³...')
               cText := If( KusTree->nVyrSt > 1,;
                            Left( KusTree->cTreeText, ( KusTree->nVyrSt - 2) * 3) + cChar, cChar ) + ;
                        Str( PolOper->nCisOper)+ ' - '+ OperTree->cVyrPol + ' - ' +;
                        AllTrim( OperTree->cNazev) + ' - ' + PolOPER->cText1  //- 14.5.02
               OperTree->cTreeText := cText
               OperTree->cTreeKey  := AllTrim( KusTree->cTreeKey) + CHR( 33)
               // PutItem( 'OperTree', 'PolOper')
                mh_CopyFLD( 'PolOper', 'OperTree')
               OperTree->mTextOper := PolOper->mPolOper
               // OperTREE->nNhCELK   := PolOPER->nCelkKusCa
               // OperTREE->nKcCELK   := PolOPER->nKcNaOper
               OperTree->cSklPol   := cSklPol
               OperTree->cNazZbo   := cNazZbo
               OperTree->cNizPol   := cNizPol
               OperTree->nNizVar   := nNizVar
               OperTree->cNazevNiz := cNazevNiz
               OperTree->nSpMnoNaNi:= nSpMnoNaNi
               OperTree->cNazOper  := Operace->cNazOper
               OperTree->cStred    := Operace->cStred
               OperTree->cOznPrac  := Operace->cOznPrac
               OperTree->nPocRadku := 0
               IF UPPER( Operace->cTypOper) == 'KOO'
                  OperTree->nKcNaKoop := OperTree->nKcNaOper
               ENDIF
               IF PolOper->lTranMnoz
                  cTag := C_Pracov->( AdsSetOrder( 1))
                  IF C_Pracov->( dbSeek( Upper( Operace->cOznPrac)))
                     OperTree->nTranMnoz := C_Pracov->nTranMnoz
                  ENDIF
                  C_Pracov->( AdsSetOrder( cTag))
               ENDIF
               //Ä  Spotý. mn. na zak zku
               cTag := VyrZak->( AdsSetOrder( 1))
               IF VyrZak->( dbSeek( Upper( OperTree->cCisZakaz)))
                  OperTree->nSpMnoZak := VyrZak->nMnozPlano * nSpMnoNaNi
               ENDIF
               VyrZak->( AdsSetOrder( cTag))
               //Ä  Spotý. mn. na zak zku ve skladov‚ MJ
               cTag := NakPol->( AdsSetOrder( 1))
               IF NakPol->( dbSeek( Upper( OperTree->cSklPol)))
                  OperTree->nMnSkJeZak := OperTree->nSpMnoZak * NakPol->nKoefPrep
               ENDIF
**               mh_WRTzmena( 'OperTREE', .T.)
               NakPol->( AdsSetOrder( cTag))

               OperTree->( dbUnlock())
            Endif
            PolOper->( dbSkip())
          EndDo
          VYR_ScopeOper( .F.)     // PolOper->( dbClearFilter())  15.8.2007
       Endif
    Endif
    KusTree->( dbSkip())
  EndDo
  //Ä
  /*
  SUM OperTREE->nCelkKusCa, OperTREE->nKcNaOper TO nNhCELK, nKcCELK
  OperTREE->( dbGoTOP())
  OperTREE->( dbEVAL( {|| OperTREE->nNhCELK := nNhCELK ,;
                          OperTREE->nKcCELK := nKcCELK  }))
*/
  OperTREE->( dbGoTOP())
Return NIL