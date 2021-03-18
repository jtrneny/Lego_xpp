/*******************************************************************************
  VYR_MLISTIT.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  VYR_MLISTIT_save()   MzdItem()         Mlodved.prg
  VYR_MLISTIT_del()
  VYR_TarifCASO()      TarifCASO()       Mlodved.prg
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION VYR_MLISTIT_edit( oDlg)
  Local cObdForML := uctObdobi:VYR:cOBDOBI  // SysCONFIG( 'Vyroba:cObdForML')
  Local nCFG := SysCONFIG( 'Vyroba:nMnozCelML')
  LOCAL cKey, lOK, nREC

  IF oDlg:lNewREC
     ListITw->( dbAppend())
     ListITw->nrok       := uctObdobi:VYR:nROK
     ListITw->nobdobi    := uctObdobi:VYR:nOBDOBI
     ListITw->cCisZakazI := ListHD->cCisZakazI
     ListITw->nPorCisLis := ListHD->nPorCisLis
     ListITw->nRokVytvor := ListHD->nRokVytvor
     ListITw->nCisloKusu := ListHD->nCisloKusu

     oDlg:cTypML := IF( IsNil( oDlg:cTypML) .OR. oDlg:nCisML <> ListHD->nPorCisLis,;
                     ListIT->cTypListku, odlg:cTypML)
     oDlg:nDrMZD := IF( IsNil( oDlg:nDrMZD) .OR. oDlg:nCisML <> ListHD->nPorCisLis,;
                     ListIT->nDruhMzdy, oDlg:nDrMZD)
     LISTITw->cTypListku := oDlg:cTypML
     LISTITw->nDruhMzdy  := oDlg:nDrMZD

     if usrIDdb = 110801
       LISTITw->nDruhMzdy  := 112
     endif

     LISTITw->nKusyCelk  := IF( nCFG == 2, MAX( ListHD->nKusyCELK - ListHD->nKusyHOTOV, 0), 0 )
     IF IsNIL( oDlg:dVyhotML)
//       oDlg:dVyhotML := CTOD( '01.' + LEFT( cObdForML, 2) + '.'+ RIGHT( cObdForML, 2) )
       oDlg:dVyhotML := CTOD( '01.' + StrZero( uctObdobi:VYR:nOBDOBI, 2) + '.'+ StrZero(uctObdobi:VYR:nROK, 4) )
     ENDIF
     LISTITw->dVyhotSkut := oDlg:dVyhotML
     LISTITw->nTydKapBlo := mh_WEEKofYear( DATE())
     LISTITw->cStavListk := '1'
*     LISTITw->nMzdaZaKus := SetMzdMJ()

  ELSE
     mh_COPYFLD('LISTIT', 'LISTITw', .T.)
     LISTITw->dVyhotSkut := CoalesceEmpty( ListIT->dVyhotSkut, DATE() )
     listitW->nmsprc_Mo  := 0

     if ListITw->nObdobi = 0
       ListITw->nObdobi := uctObdobi:VYR:nROK            // JT úprava
     endif
     if ListITw->nRok = 0
       ListITw->nRok    := uctObdobi:VYR:nOBDOBI         // JT úprava
     endif

     if msprc_mo->( dbSeek( StrZero( listITw->nrok, 4)          + ;
                             StrZero( listITw->nobdobi, 2)      + ;
                              StrZero( listITw->nOsCisPrac, 5)      + ;
                               StrZero( listITw->nPorPraVzt, 3),, 'MSPRMO01'))
        listitW->nmsprc_Mo  := msprc_Mo->sid
     endif
  ENDIF

RETURN NIL

*
*===============================================================================
FUNCTION VYR_MLISTIT_save( oDlg)

IF ! oDlg:drgDialog:dialogCtrl:isReadOnly
  oDlg:dataManager:save()
  IF( oDlg:lNewREC, LISTIT->( DbAppend()), Nil )
  IF LISTIT->(sx_RLock())
     mh_COPYFLD('LISTITw', 'LISTIT' )
     ListIT->cCisZakaz  := ListHD->cCisZakaz
     ListIT->cCisZakazI := ListHD->cCisZakazI
     ListIT->cVyrPol    := ListHD->cVyrPol
     ListIT->cObdobi    := VYR_WhatOBD()

     ListIT->nRok       := Val( Left( Str( Year( ListIT->dVyhotSkut),4),2) + Right(ListIT->cObdobi,2))  // JT úprava
     ListIT->nObdobi    := Val( Left( ListIT->cObdobi,2)) // uctObdobi:VYR:nOBDOBI         // JT úprava

     osoby->( dbseek( listITw->ncisOsoby,, 'OSOBY01'))
     listit->cprijPrac  := osoby->cprijOsob
     listit->cjmenoPrac := osoby->cjmenoOsob
     listit->cjmenoRozl := osoby->cjmenoRozl

     ListIT->cOznOper   := ListHD->cOznOper
     ListIT->cStred     := Operace->cStred
     ListIT->cOznPrac   := Operace->cOznPrac
     ListIT->cPracZar   := Operace->cPracZar
     IF Empty( ListIT->cNazPol1)
       ListIT->cNazPol1 := osoby->cNazPol1
       ListIT->cNazPol4 := osoby->cNazPol4
     ENDIF
     ListIT->cNazPol2   := VyrZak->cNazPol2
     ListIT->cTarifStup := Operace->cTarifStup
     ListIT->cTarifTrid := Operace->cTarifTrid
     IF oDlg:lNewRec
       ListIT->(Ads_customizeAOF( {ListIT->( RecNO()) }, 1))
     ENDIF
     mh_WRTzmena( 'ListIT', oDlg:lNewRec)
     VYR_StavLST()
     ListIT->( dbUnlock())
     IF oDlg:lNewRec
        oDlg:cTypML := If( UPPER( ListIT->cTypListku ) == UPPER( oDlg:cTypML),;
                           oDlg:cTypML, ListIT->cTypListku )
        oDlg:nDrMZD := If( ListIT->nDruhMzdy == oDlg:nDrMZD,;
                           oDlg:nDrMZD, ListIT->nDruhMzdy )
     ENDIF
     oDlg:dVyhotML := ListIT->dVyhotSkut
     /*/ Aktualizace hlaviŸky ML pýi poý¡zen¡ ze SCR ...20.1.2004
     IF lCallFromSCR
       FOrdRec( { 'ListIT, 1' })
       SetSCOPE( 'ListIT', StrZERO(ListIT->nRokVytvor) + StrZERO(ListIT->nPorCisLis))
       FootIT( YES, NO )
       FOrdRec()
     ENDIF
     LISTIT->( dbUnlock())
    */
  ENDIF
ENDIF
RETURN NIL

* Zrušení položky mzdového lístku
*===============================================================================
FUNCTION VYR_MLISTIT_del( oDlg)
  Local lOK := YES, lEXPORTed
  Local nRecNO := ListIT->( RecNO())
  Local nCount := dbCount( 'ListIT')
  Local cMsg := 'Zrušit položku mzdového lístku < & > ?', cMsg1

 ListIT->( dbGoTO( nRecNO))
 IF NazPOL1_TST( 'VyrZAK', xbeK_DEL, '3')
   lEXPORTed := !EMPTY( ListIT->dPrenos)
   IF lEXPORTed
     lOK := .F.
     cMsg := 'NELZE ZRUŠIT !;; Mzdový lístek < & > byl již pøenesen do úèetnictví !'
     drgMsgBox(drgNLS:msg( cMsg, ListIT->nPorCisLis ))
   ENDIF

   IF lOK
     cMsg := '< Zrušení lístku >;;' + ;
             IF( nCount = 1, 'Zrušením poslední položky bude celý lístek stornován !;;','') + ;
             cMsg
     IF nCount == 1
       IF drgIsYESNO(drgNLS:msg( cMsg, ListIT->nPorCisLis) )
         IF ListIT->( sx_RLock()) .and. ListHD->( sx_RLock())
           VYR_POLOPER_modi()
           ListIT->( dbDelete(), dbUnlock())
           ListHD->( dbDelete(), dbUnlock())
         ELSE
         ENDIF
       EndIf
     ELSEIF drgIsYESNO(drgNLS:msg( cMsg, ListIT->nPorCisLis) )
       DelRec( 'ListIT')
       ListIT->( dbGoTOP())
     ENDIF
   ENDIF
 ENDIF

RETURN Nil


* Pøednastavení Mzdy za MJ
*===============================================================================
STATIC FUNC SetMzdMJ()
  Local nMzdMJ, nREC := ListIT->( RecNO()), cKey
  /*
  IF lSCR  ;  FOrdREC( { 'ListIT, 2' } )
              cKey := StrZERO( ListHD->nPorCisLis)
              SetSCOPE( 'ListIT', cKey )
  ENDIF
  */
  ListIT->( dbGoTOP())
  nMzdMJ := ListIT->nMzdaZaKus
*  IF( lSCR, ( ClrSCOPE( 'ListIT'), FOrdREC()), NIL )
  ListIT->( dbGoTO( nREC))
RETURN( nMzdMJ)