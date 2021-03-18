/*******************************************************************************
  VYR_MLISTHD.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  VYR_NewCisLis()
  VYR_DoubleML()       DoubleML()         MLisHD.prg
  VYR_StavLST()        StavLST()          MzdLis.prg
  VYR_MListHD_del      DelMzdHEAD()       MzdLis.prg
  VYR_POLOPER_modi()   ModiPOLOPER()      MzdLis.prg
  VYR_ML_Rozdelit()    RozdelLST()        MzdLis.prg
  VYR_AllOK()          AllOK()            MzdLis.prg
  StavZakOK()          StavZakOK()        MzdLis.prg
  VYR_StredInCFG()     StredInCFG()       MzdLis.prg
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

* Zjistí nové èíslo mzd. lístku
*===============================================================================
FUNCTION VYR_NewCisLis()
  Local nCis, cRok := StrZero( YEAR( DATE()), 4 )

  drgDBMS:open('ListHD',,,,,'listHDa')
  listHDa->( ordSetFocus('LISTHD1'))

  listHDa->( mh_SetScope( cRok), dbGoBottom() )
    nCis := listHDa->nPorCisLis + 1
  listHDa->( mh_ClrScope())
Return( nCis)

* Kontrola duplcity mzd. lístku
*===============================================================================
FUNCTION VYR_DoubleML( Dlg, nCisloML)
  Local cKey := STRZERO( YEAR( DATE()), 4) + STRZERO( nCisloML, 12)
  Local lDOUBLE, cMsg

  drgDBMS:open('ListHD',,,,,'listHDa')
  listHDa->( ordSetFocus('LISTHD1'))

  lDOUBLE := If( Dlg:lNewRec, listHDa->( dbSEEK( cKey)), .F. )

  IF lDOUBLE
    cMsg := 'DUPLICITA !;; Mzdový lístek s tímto èíslem byl již zapsán !'
    drgMsgBox(drgNLS:msg( cMsg,, Dlg:drgDialog:dialog))
  ENDIF
RETURN( lDouble)

* Kontrola duplcity mzd. lístku
*===============================================================================
FUNCTION VYR_DoubleMLis()
  Local lOK := YES
  Local cTag := ListHD->( AdsSetOrder( 1))
  Local nRec := ListHD->( RecNo()), nOld := ListHD->nPorCisLis
  Local xKey := ListHD->( Sx_KeyData())

  DO WHILE lOK
     If ( lOk := ListHD->( OrdWildSeek( xKey)) )
       lOk := ListHD->( OrdWildSeek())
     EndIf
     ListHD->( dbGoTo( nRec))
     If lOk
        IF ReplRec( 'ListHD')
           ListHD->nPorCisLis := ListHD->nPorCisLis + 1
           ListHD->( dbCommit(), dbUnlock() )
           xKey := ListHD->( Sx_KeyData())
        ENDIF
     ENDIF
  ENDDO
  ListHD->( AdsSetOrder( cTag))
/*
  DO WHILE lOK
     If ( lOk := ListHD->( Sx_WildSeek( xKey)) )
       lOk := ListHD->( Sx_WildSeek( xKey, .t. ))
     EndIf
     ListHD->( dbGoTo( nRec))
     If lOk
        IF ReplRec( 'ListHD')
           ListHD->nPorCisLis := ListHD->nPorCisLis + 1
           ListHD->( dbCommit(), dbUnlock() )
           Unlock( 'ListHD')
           xKey := ListHD->( Sx_KeyData())
        ENDIF
     ENDIF
  ENDDO
  ListHD->( AdsSetOrder( cTag))
*/
RETURN NIL

*
*===============================================================================
FUNCTION VYR_StavLST()
  Do Case
    Case ( ListIt->nKusyHotov < ListIt->nKusyCelk ) .and. ;
           ListIt->nKusyHotov > 0
      ListIT->cStavListk := '4'
    Case ( ListIt->nKusyHotov = ListIt->nKusyCelk ) .and. ListIt->nKusyHotov > 0
      ListIT->cStavListk := '5'
   Case ( ListIt->nKusyKontr = ListIt->nKusyCelk )
      ListIT->cStavListk := '6'
  EndCase
Return( Nil)

* Zrušení hlavièky MZD. LÍSTKU
*===============================================================================
FUNCTION VYR_MListHD_del()
  Local lOK := YES, lEXPORTed := NO, lItem, cKEY, cMsg, nSUMA, n
  Local nREC := ListIT->( RecNO()), aRECs := {}

  IF NazPOL1_TST( 'VyrZAK', xbeK_DEL, '3')
    ListIT->( dbGoTOP())
    ListIT->( dbEVAL( {|| lEXPORTed := IF( EMPTY( ListIT->dPrenos), lEXPORTed, YES) }))
*    ListIT->( dbGoTO( nREC))
    nSUMA := ListHD->nKusyHotov + ListHD->nKcNaOpeSK + ListHD->nNhNaOpeSK
    IF lEXPORTed
      cMsg := 'NELZE ZRUŠIT !;; Mzdový lístek < & > byl již pøenesen do úèetnictví !'
      drgMsgBox(drgNLS:msg( cMsg, ListHD->nPorCisLis ))
    ELSE
      cMsg := 'Na tento mzdový lístek již bylo nìco vykázáno !;'
      cMsg := '< Zrušení lístku >;;' + ;
              IF( nSuma > 0, cMsg, 'Zrušit mzdový lístek < & > ?')
      IF drgIsYESNO(drgNLS:msg( cMsg, ListHD->nPorCisLis) )
         VYR_ListHD_del()
        /*
        ListIt->( dbGoTop())
        ListIt->( dbEval( {|| AADD( aRECs, ListIT->( RecNO())) }))
        lItem := IF( LEN( aRECs) = 0, .T.,  ListIT->( sx_RLock( aRECs)))
        IF ListHD->( sx_RLock()) .and. lItem
           FOR n := 1 TO LEN( aRECs)
             ListIT->( dbGoTO( aRECs[ n]), dbDelete() )
           NEXT
           ListIT->( dbUnlock())
           VYR_POLOPER_modi()
           ListHD->( dbDelete(), dbUnlock())
        ENDIF
        */
      ENDIF
    ENDIF
  ENDIF

RETURN Nil

* Zrušení hlavièky MZD. LÍSTKU ...
*===============================================================================
FUNCTION VYR_ListHD_del()
  Local lItem, n, aRECs := {}

  ListIt->( dbGoTop(),;
            dbEval( {|| AADD( aRECs, ListIT->( RecNO())) }))
  lItem := IF( LEN( aRECs) = 0, .T.,  ListIT->( sx_RLock( aRECs)))
  IF ListHD->( sx_RLock()) .and. lItem
     FOR n := 1 TO LEN( aRECs)
       ListIT->( dbGoTO( aRECs[ n]), dbDelete() )
     NEXT
     ListIT->( dbUnlock())
     VYR_POLOPER_modi()
     ListHD->( dbDelete(), dbUnlock())
  ENDIF
RETURN NIL


* Modifikace položek v PolOPER
*===============================================================================
function vyr_polOper_modi()
  local cStatement, oStatement
  local stmt := "update polOper set nrokVytvor = 0, " + ;
                                   "nporCisLis = 0, " + ;
                                   "nzapusteno = 0  " + ;
                        "where (nrokVytvor = %rokVytvor and nporCisLis = %porCisLis);"

  cStatement := strTran( stmt      , '%rokVytvor', str( listhd->nrokVytvor) )
  cStatement := strTran( cStatement, '%porCisLis', str( listhd->nporCisLis) )

  oStatement := AdsStatement():New(cStatement,oSession_data)

  if oStatement:LastError > 0
*    return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif

  polOper->(dbUnlock(), dbCommit())
return .t.



/* Modifikace hlavièky ML - LISTHD
*===============================================================================
FUNCTION ModiHD_ML( nKEY)
  DO CASE
    CASE nKEY == K_INS
      IF REPLREC( 'ListHD')
        ListHD->nKcNaOpePL += PolOPER->nKcNaOper
        ListHD->nNmNaOpePL += PolOPER->nCelkKusCa
        ListHD->nNhNaOpePL := ListHD->nNmNaOpePL / 60
        DCrUNLOCK( 'ListHD')
      ENDIF

    CASE nKEY == K_ENTER
      IF REPLREC( 'ListHD')
        ListHD->nKcNaOpePL += - PolOP_1->nKcNaOper + PolOPER->nKcNaOper
        ListHD->nNmNaOpePL += - PolOP_1->nCelkKusCa + PolOPER->nCelkKusCa
        ListHD->nNhNaOpePL := ListHD->nNmNaOpePL / 60
        DCrUNLOCK( 'ListHD')
      ENDIF

    CASE nKEY == K_DEL
      IF REPLREC( 'ListHD')
        ListHD->nKcNaOpePL -= PolOP_1->nKcNaOper
        ListHD->nNmNaOpePL -= PolOP_1->nCelkKusCa
        ListHD->nNhNaOpePL := ListHD->nNmNaOpePL / 60
        DCrUNLOCK( 'ListHD')
      ENDIF
  ENDCASE
RETURN NIL
*/
* Rozdìlení položky mzdového lístku
*===============================================================================
FUNCTION VYR_ML_Rozdelit( parDialog)
  Local oDialog, nExit, nPocetML := 2, n, nRecNO := ListIT->( RecNO())
  Local cOld := AllTrim( ListIT->cDruhListk), cNew, oB
  Local nStavML := Val( ListIT->cStavListk )
  LOCAL cMsg := 'NELZE !!!;; Mzdový lístek < & > již nelze rozdìlit !'

  If ListIT->( RecNo()) <= ListIT->( LastRec())
    If nStavML > 3
      drgMsgBox(drgNLS:msg( cMsg, ListIT->nPorCisLis ))
      RETURN NIL
    ENDIF

    DRGDIALOG FORM 'ROZDELIT_ML' PARENT parDialog CARGO nPocetML EXITSTATE nExit MODAL

    IF nExit != drgEVENT_QUIT
      nPocetML := oDialog:UDCP:nPocetML

      cNew := IIF( cOld == '1', '4',;
               IIF( cOld == '2', '5',;
                IIF( cOld == '3', '6',;
                 IIF( cOld == '7', '8', cOld ))))

      IF LISTIT->( sx_RLock())
        ListIT->nNmNaOpePl := ListIt->nNmNaOpePl / nPocetML
        ListIT->nKcNaOpePl := ListIt->nKcNaOpePl / nPocetML
        ListIT->nKusyCelk  := ListIt->nKusyCelk  / nPocetML
        ListIT->cDruhListk := cNew
        LISTIT->( dbUnlock())
      ENDIF
      drgDBMS:open('LISTITw',.T.,.T.,drgINI:dir_USERfitm); ZAP
      mh_COPYFLD('LISTIT', 'LISTITw', .T.)
      FOR n := 1 To nPocetML - 1
        If AddRec( 'ListIT')
           mh_COPYFLD('LISTITw', 'LISTIT')
           ListIT->( dbUnlock())
         Endif
       NEXT
       LISTIT->( dbGoTO( nRecNO))
       oB := parDialog:dialogCtrl:oaBrowse:oXbp
       SetAppFocus( oB)
       oB:refreshAll()
    ENDIF
    oDialog:destroy()
    oDialog := NIL
  ENDIF
RETURN NIL

* Zaplánování položky mzdového lístku
*===============================================================================
FUNCTION VYR_ML_Planovat( parDialog)
  Local oDialog, nExit, oB, n
  Local nStavML := Val( ListIT->cStavListk )
  LOCAL cMsg := 'NELZE !!!;; Mzdový lístek < & > již nelze zaplánovat !'
  Local aCargo := { CoalesceEmpty( ListIT->dVyhotPlan, Date() ),;
                    ListIT->nOsCisPrac,;
                    ListIT->cSmena }

  If ListIT->( RecNo()) <= ListIT->( LastRec())
    If nStavML > 3
      drgMsgBox(drgNLS:msg( cMsg, ListIT->nPorCisLis ))
      RETURN NIL
    ENDIF

    DRGDIALOG FORM 'PLANOVAT_ML' PARENT parDialog CARGO aCargo EXITSTATE nExit MODAL

    IF nExit != drgEVENT_QUIT

      IF ListIT->( sx_RLock())
         oDialog:dataManager:save()
         mh_COPYFLD('LISTITw', 'LISTIT')
*         ListIt->cObdobi    := WhatOBD( YES)
         ListIt->cPrijPrac  := osoby->cPrijOsob
         ListIt->cJmenoPrac := osoby->cJmenoOsob
         ListIt->cjmenoRozl := osoby->cjmenoRozl

         Do Case
           Case !Empty( ListIT->dVyhotPlan) .and. !Empty( ListIT->nOsCisPrac)
             ListIT->cStavListk := '3'
           Case !Empty( ListIT->dVyhotPlan) .and. Empty( ListIT->nOsCisPrac)
             ListIT->cStavListk := '2'
         EndCase
         ListIT->( dbUnlock())
      Endif
      oB := parDialog:dialogCtrl:oaBrowse:oXbp
      SetAppFocus( oB)
      oB:refreshAll()
    ENDIF
    oDialog:destroy()
    oDialog := NIL
  ENDIF
RETURN NIL

* Podmínky pro práci s mzdovým lístkem
*===============================================================================
FUNCTION VYR_AllOK( cZak)
  Local lOK := NO

  If StavZakOK( cZak)        // Zakázka je ve stavu <> U, 0
    lOK := YES
  EndIf
RETURN( lOK)

* Zjistí stav zakázky
*-------------------------------------------------------------------------------
STATIC FUNCTION StavZakOK( cZak)
  Local lOK := YES, cStav

  VyrZak->( dbSeek( Upper( cZak),, 'VYRZAK1'))
  cStav := AllTrim( VyrZak->cStavZakaz)
  If cStav = 'U'
     cMsg := 'NEPOVOLENÁ OPERACE;; Zakázka < & > je již ukonèena, nelze provádìt zmìny !'
     drgMsgBox(drgNLS:msg( cMsg, cZak ))
     lOK := NO
  ElseIf cStav = '0'
     cMsg := 'NEPOVOLENÁ OPERACE;; Zakázka < & > je stornována, nelze provádìt zmìny !'
     drgMsgBox(drgNLS:msg( cMsg, cZak ))
     lOK := NO
  Endif
RETURN( lOK)

* Zjistí zda požadované støedisko je v konfiguraèním seznamu
*===============================================================================
FUNCTION VYR_StredInCFG( cStredisko)
  Local cHLP := ALLTRIM( SysCONFIG( 'Vyroba:cNazPol1'))
  Local aNazPOL1 := ListAsARRAY( cHLP), M

  M := ASCAN( aNazPOL1, {|X| ALLTRIM( cStredisko ) == X } )
RETURN( M <> 0)