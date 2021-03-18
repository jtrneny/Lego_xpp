/*==============================================================================
  VYR_Zapus_DILPR.PRG
  ----------------------------------------------------------------------------
  XPP                  ->  DOS           in   DOS.Prg
  VYR_GenListky_DILPR      GenLISTKY_5()      ZakZap.Prg
  VYR_GenML_DILPR          GenML_5()          ZakZap.Prg
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "gra.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_Zapus_DILPR FROM drgUsrClass, VYR_KusTREE_gen
EXPORTED:
  VAR     nRec, aRect, aRectPrev
  VAR     prevItem

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  TreeItemMarked, TreeItemSelected

HIDDEN:
  VAR     dm
  METHOD  Set_zapustit
ENDCLASS

*
********************************************************************************
METHOD VYR_Zapus_DILPR:init(parent)

  ::drgUsrClass:init(parent)
  *
  ::VYR_KusTREE_gen:init(parent)
  ::VYR_KusTREE_gen:nRozpad := ROZPAD_DILPR

  ::nREC    := KusTREE->( RecNO())

RETURN self

*
********************************************************************************
METHOD VYR_Zapus_DILPR:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
*  ::dc := ::drgDialog:dialogCtrl
  ::dm := ::drgDialog:dataManager

  KusTree->( dbGoTOP())

  SetAppFocus( ::oTree)
  ::oTree:SetData( ::oTreeItem)
  *
  ::prevItem := ::oTreeItem

RETURN self

*
********************************************************************************
METHOD VYR_Zapus_DILPR:EventHandled(nEvent, mp1, mp2, oXbp)
*  LOCAL o, xRec

  DO CASE

  CASE nEvent = xbeTV_ItemMarked
    ::TreeItemMarked( mp1, mp2, oXbp)

  CASE nEvent = xbeTV_ItemSelected
    ::TreeItemSelected( mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_INS
      ::TreeItemSelected( oXbp:getData(),, oXbp)

    CASE mp1 = xbeK_CTRL_INS
      ::TreeItemSelected( oXbp:getData(),, oXbp)
      * !!! Dopracovat oznaèování celých uzlù
*       drgMsgBox(drgNLS:msg('xbeK_CTRL_INS  ...') )

    CASE mp1 = xbeK_ESC
      IF( oXbp:className() = 'xbpTreeView',;
          PostAppEvent(xbeP_Close,nEvent,,oXbp), SetAppFocus( ::oTree) )

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_Zapus_DILPR:TreeItemMarked( oItem, aRect, oXbp)

  * Synchronizace s KusTREE
  ::prevItem  := ::oTreeItem
  KusTree->( dbGoTO( ::prevItem:undoBuffer))
  ::nREC    := KusTREE->( RecNO())
  ::aRectPrev := ::aRect
  ::Set_zapustit( ::prevItem, oXbp, .T.)
  *
  KusTree->( dbGoTO( oItem:undoBuffer))
  ::nREC    := KusTREE->( RecNO())
  ::oTreeItem := oItem
  ::aRect     := aRect
  ::Set_zapustit( oItem, oXbp, .F.)
  *
  ::dm:refresh()

RETURN SELF

*
********************************************************************************
METHOD VYR_Zapus_DILPR:TreeItemSelected( oItem, aRect, oXbp)
  KusTree->lZapustit := !KusTree->lZapustit
  ::Set_zapustit( oItem, oXbp)
RETURN SELF

*
********************************************************************************
METHOD VYR_Zapus_DILPR:destroy()
  ::drgUsrClass:destroy()
  ::dm := ::prevItem := ;
                  NIL
  KusTREE->( Ads_ClearAof(), dbGoTOP() )
*  KusTREE->( dbCloseArea())
RETURN self

*
********************************************************************************
METHOD VYR_Zapus_DILPR:Set_zapustit( oItem, oXbp, isPrev)
  Local aAttr := ARRAY( GRA_AS_COUNT ), oPS

  DEFAULT isPrev TO .F.
  IF ::aRect <> NIL
    oPS := oXbp:lockPS()
    IF isPrev
      aAttr [ GRA_AS_COLOR ] := IF( KusTree->lZapustit, GRA_CLR_RED, GRA_CLR_BLACK)
      GraSetAttrString( oPS, aAttr )
      GraStringAt( oPS, {::aRectPrev[1]+2, ::aRectPrev[2]-17}, oItem:caption )
    ELSE
      aAttr [ GRA_AS_COLOR ] := IF( KusTree->lZapustit, GRA_CLR_RED, GRA_CLR_WHITE)
      GraSetAttrString( oPS, aAttr )
      GraStringAt( oPS, {::aRect[1]+2, ::aRect[2]-17}, oItem:caption )
    ENDIF
**    GraSetAttrString( oPS, aAttr )
**    GraStringAt( oPS, {::aRect[1]+2, ::aRect[2]-17}, oItem:caption )
    oXbp:unlockPS(oPS)
  ENDIF
RETURN SELF


* Generování ML pro zapuštìní typu DLE DÍLEN A PRACOVIŠ  ... PACOV
*===============================================================================
FUNCTION VYR_GenLISTKY_DILPR()
  Local cKey, cVyrPOL, cKEY1, cVyrPOL_02
  Local nS1 := 0, nS2 := PolOp_02->nPriprCas, nS3 := 0, nS4 := 0, nS5 := PolOP_02->nMnZadVA
  Local aREC := {}, nHLP, nPos
  Local nCOUNT := 1, nRecCOUNT := PolOP_02->( LastREC())
  Local cTAG := PolOPER->( AdsSetOrder( 1 ))  // 7
  Local nAREA := SELECT(), lFIRST := YES, nMzd := 0

  dbSelectAREA( 'PolOPER')
  PolOP_02->( dbGoTOP())
  cKey := PolOP_02->cStred + PolOP_02->cOznPrac
  cVyrPOL := PolOP_02->cVyrPOL + StrZERO( PolOP_02->nCisOper,4)
*  BOX_THERMO( 1, nCount, nRecCount, '( Okam§ik pros¡m ... )',;
*                 'Prob¡h  kumulace operac¡ ...', cClr, 9 )

  DO  WHILE !PolOP_02->( EOF())
    cVyrPOL_02 := PolOP_02->cVyrPOL + StrZERO( PolOP_02->nCisOper,4)
    Operace->( dbSeek( Upper( PolOp_02->cOznOper)))
    C_Tarif->( dbSeek( Upper( Operace->cTarifStup) + Upper( Operace->cTarifTrid)))
    IF cKEY == PolOP_02->cStred + PolOP_02->cOznPrac
      nS1 += PolOp_02->nCelkKusCa
//      nS2 += PolOp_02->nPriprCas
      * nNmNaOpePL
      nS3 += ( PolOp_02->nCelkKusCa * PolOP_02->nMnZadVA ) + ;
             IF( cVyrPOL <> cVyrPOL_02 .OR. lFIRST,;
                ( PolOp_02->nPriprCas * PolOp_02->nKoefKusCa ), 0 )
      * nKcNaOpePL
      nHLP := ( ( PolOp_02->nPriprCas * PolOp_02->nKoefKusCa ) * ;
                (( C_Tarif->nHodinSaz + C_Tarif->nHodinNav)/60 ))
      nHLP := IF( cVyrPOL <> cVyrPOL_02 .OR. lFIRST, nHLP, 0)
      IF UPPER( Operace->cTypOper) == 'KOO'
         nS4 += ( PolOp_02->nKcNaOper * PolOp_02->nMnZadVA ) + nHLP
      ELSE
         nS4 += ( ( PolOp_02->nCelkKusCa * PolOP_02->nMnZadVA ) * ;
                  (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav )/ 60 ) ) + nHLP
      ENDIF
      * nKusyCelk
      IF cVyrPOL <> cVyrPOL_02
         nS2 += PolOp_02->nPriprCas
         nS5 += PolOp_02->nMnZadVA
         cVyrPOL := cVyrPOL_02
      ENDIF
      nPOS := ASCAN( aREC, {|X| X[1] == PolOP_02->nRecPolOP } )
      IF nPOS == 0
        cKEY1 := Upper( PolOP_02->cCisZAKAZ) + Upper( PolOP_02->cVyrPOL) + ;
                 STRZERO( PolOP_02->nCisOper,4) + STRZERO( PolOP_02->nUkonOper,2) + ;
                 STRZERO( PolOP_02->nVarOper,3) + StrZERO( PolOP_02->nPocCeZapZ,2)
        AADD( aREC, { PolOP_02->nRecPolOp, PolOP_02->nMnZadVA, cKEY1 } )
      ELSE
        aREC[ nPOS, 2] += PolOP_02->nMnZadVA
      ENDIF
//      IF( nPOS == 0, AADD( aREC, { PolOP_02->nRecPolOp, PolOP_02->nMnZadVA } ),;
//                     aREC[ nPOS, 2] += PolOP_02->nMnZadVA )
**      BOX_THERMO( 0, nCount, nRecCount)
      lFIRST := NO
      ( PolOP_02->( dbSKIP()), nCount++ )
    ELSE
      PolOP_02->( dbSKIP( -1))
      VYR_GenML_DILPR( aREC, nS1, nS2, nS3, nS4, nS5 )
      nMZD++
      PolOP_02->( dbSKIP())
      nS1 := 0
      nS2 := PolOp_02->nPriprCas
      nS3 := 0
      nS4 := 0
      nS5 := PolOp_02->nMnZadVA
      cKey := PolOP_02->cStred + PolOP_02->cOznPrac
      cVyrPOL := PolOP_02->cVyrPOL + StrZERO( PolOP_02->nCisOper,4)
      lFIRST := YES
      aREC := {}
    ENDIF
  ENDDO
  PolOP_02->( dbSKIP( -1))
  VYR_GenML_DILPR( aREC, nS1, nS2, nS3, nS4, nS5 )
  nMZD++
  PolOP_02->( dbSKIP())
**  BOX_THERMO( -1)
  PolOPER->( AdsSetOrder( cTAG), dbCommit() )
dbSelectAREA( nAREA)
RETURN nMZD

*
*-------------------------------------------------------------------------------
STATIC FUNCTION VYR_GenML_DILPR( aREC, nCelkKusCa, nPriprCas, nNmNaOpePL, nKcNaOpePL, nKusyCELK)
  Local cKEY, N, nREC
  Local lExist, lOK := ( PolOP_02->( LastRec()) <> 0 ), aARR

IF lOK
  drgDBMS:open('PolOPERZ' )
  * ListHD ... hlavièka ML
  IF ( lOK := ( ListHD->( dbAppend(), Sx_RLock()) ))  // ... vždy nová hlavièka
     mh_COPYFLD( 'Operace' , 'ListHD')
     mh_COPYFLD( 'PolOP_02', 'ListHD')
     ListHD->nRokVytvor := Year( Date())
     ListHD->nVarCis    := PolOp_02->nVarOper   // z VyrPol->nVarCis
     ListHD->cMaterPoza := 'N'
     ListHD->cZapKapac  := 'N'
     ListHD->nKusovCas  := nCelkKusCa
     ListHD->nPriprCas  := nPriprCas
     ListHD->nPorCisLis := VYR_NewCisLis()
     ListHD->nNmNaOpePl += nNmNaOpePL
     ListHD->nNhNaOpePl := ListHD->nNmNaOpePl / 60
     ListHD->nKcNaOpePl += nKcNaOpePL

     ListHD->nKusyCelk  += nKusyCelk
     ListHD->nPocCeZapZ := VyrZAK->nPocCeZapZ + 1
     ListHD->nCisloKusu := VyrZAK->nPocCeZapZ + 1
     mh_WRTzmena( 'ListHD', .T.)
     ListHD->( dbUnlock())
  Endif

  * ListIT ... položka ML
  If lOK
     IF ListIT->( dbAppend(), Sx_RLock())
        mh_COPYFLD( 'ListHD', 'ListIT')
**        nMZD++
        ListIT->cTypListku := 'TP'
        ListIT->nDruhMzdy  := PolOp_02->nDruhMzdy
        ListIT->cTarifStup := PolOp_02->cTarifStup
        ListIT->cTarifTrid := PolOp_02->cTarifTrid
        ListIT->cSmena     := '1'
        ListIT->cStavListk := '1'
        ListIT->cDruhListk := '1'
        ListIT->nNhNaOpePl := ListIT->nNmNaOpePl / 60
        ListIT->cNazPol2   := VyrZAK->cNazPol2
        mh_WRTzmena( 'ListIT', .T.)
        * Modifikace PolOper
        FOR N := 1 TO LEN( aREC)
          // M¡sto aREC ( pole Ÿ¡sel z znam… ) se mus¡ pýedat pole kl¡Ÿ…
          // PolOPER ( cCisZakaz + cVyrPol + nCisOper + nUkonOper + nPocCeZapZ  )

//            aARR := RecToARR( 'POLOPER')
            POLOPER->( dbGoTO( aREC[ N, 1]))
            IF PolOPERZ->( dbAppend(), Sx_RLock() )
                mh_COPYFLD( 'PolOPER', 'PolOPERZ')
               PolOPERZ->nRokVytvor := ListIT->nRokVytvor
               PolOPERZ->nPorCisLis := ListIT->nPorCisLis
               PolOPERZ->nZapusteno := 2
               PolOPERZ->nPocCeZapZ := ListHD->nPocCeZapZ
               PolOPERZ->nMnZadVK   := aREC[ N, 2]
               PolOPERZ->cOznPrac   := OPERACE->cOznPrac
               mh_WRTzmena( 'PolOPERZ', .T.)
               PolOPERZ->( dbUnLock( ))
            ENDIF
          *
        NEXT
        ListIT->( dbUnLock())
     EndIf
  Endif
ENDIF

RETURN NIL

* Mechanismus generování vazebního souboru následujících pracoviš
*===============================================================================
FUNCTION VYR_GenPracVAZ()
  Local cKeyOld, cIdVazby, nSumNhPlan := 0, aRec := {}

  drgDBMS:open('PracVAZ' )
  PracVAZ->( AdsSetOrder(2))
  *
  drgDBMS:open('PolOperZ' )
  PolOperZ->( AdsSetOrder( 7), dbGoTOP() )
  cKeyOld    := PolOperZ->( sx_KeyData())
  *
  DO WHILE !PolOperZ->( EOF())
    IF cKeyOld = PolOperZ->( sx_KeyData())
      AADD( aRec, PolOperZ->( RecNO()) )
      nSumNhPlan += ( PolOperZ->nCelkKusCa * PolOperZ->nMnZadVK ) + PolOperZ->nPriprCas
    ELSE
      GenPracVaz( aRec, nSumNhPlan)
      aRec := { PolOperZ->( RecNO()) }
      cKeyOld    := PolOperZ->( sx_KeyData())
      nSumNhPlan := ( PolOperZ->nCelkKusCa * PolOperZ->nMnZadVK ) + PolOperZ->nPriprCas
    ENDIF

    PolOperZ->( dbSkip())
  ENDDO
  *
  GenPracVaz( aRec, nSumNhPlan)
  *
RETURN NIL

* Vlastní generování vazebního souboru následujících pracoviš
*-------------------------------------------------------------------------------
STATIC FUNCTION GenPracVAZ( aRec, nSumNhPlan)
  Local cIdVazby, nRec

  * Zjisti nové cIdVazby
  PracVAZ->( dbGoBottom())
  cIdVazby := StrZERO( VAL( PracVAZ->cIdVazby) + 1, 12)
  * Založ  PracVAZ
  nRec := PolOperZ->( RecNO())
  PolOperZ->( dbSkip(-1))
  mh_COPYFLD( 'PolOperZ' , 'PracVAZ', .T. )
  PracVAZ->nSumNhPlan := nSumNhPlan
  PracVAZ->cIdVazby   := cIdVazby
  * Doplnit zpìtnì cIdVazby do PolOperZ
  IF PolOperZ->( sx_RLock( aRec))
    AEVAL( aRec, {|Rec| PolOperZ->( dbGoTO( Rec)),;
                        PolOperZ->cIdVazby := cIdVazby } )
    PolOperZ->( dbUnLock())
  ENDIF
  *
  PolOperZ->( dbGoTO( nRec))
RETURN NIL