/*******************************************************************************
  VYR_KUSOV.PRG
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "DRGres.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION VYR_KUSOV_edit( oDlg)
  LOCAL cKey, lOK, nREC, nTypVar

  nTypVar := SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )

  IF oDlg:lNewREC
     KUSOVwe->(dbAppend())
     KUSOVwe->nPozice   := VYR_NewPos()
     KUSOVwe->nVarPoz   := oDlg:nVarRoot
     KUSOVwe->nCiMno    := 1
     KUSOVwe->nSpMno    := 1
     oDlg:nSpMnSklHR   := 1
     KUSOVwe->cStav     := 'A'
     KUSOVwe->dPlaOd    := Date()
     KUSOVwe->dPlaDo    := Date() + ( 365*5) +1
     KUSOVwe->dZapis    := Date()
     *
  ELSE
    cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
            StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
    lOK := Kusov->( dbSeek( cKey))
    IF !lOK .and. KusTree->nVarPoz <> 1 .and. nTypVar = 1
      cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
              StrZero( KusTree->nPozice, 3) + '001'
      lOK := Kusov->( dbSeek( cKey))
    ENDIF
    nREC := KUSOV->( RecNO())
    mh_COPYFLD('KUSOV', 'KUSOVwe', .T.)

  ENDIF

RETURN NIL

*
*===============================================================================
FUNCTION VYR_KUSOV_save( oDlg)
  local  lnewRec     := odlg:lnewRec, mainOk  := .t.
  local  o_nazNizPol := odlg:dataManager:has('M->cnazNizPol')
  *
  local  cnazNizPol
  local  cStatement, oStatement
  local  stmt := "update vyrPol set cnazev = '%cnazev' where (ccisZakaz = '%czak' and cvyrPol = '%cvyr' and nvarCis = %nvar ) ; " + ;
                 "update listhd set cnazev = '%cnazev' where (ccisZakaz = '%czak' and cvyrPol = '%cvyr' and nvarCis = %nvar )"


  IF EMPTY( oDlg:cCisZakaz)    // vazba na nezakázkovou položku
    oDlg:dataManager:save()
    If( oDlg:lNewREC, KUSOV->( DbAppend()), Nil )
    IF KUSOV->(sx_RLock())
      mh_COPYFLD('KUSOVwe', 'KUSOV' )
      KUSOV->cCisZakaz  := oDlg:cCisZakaz
      KUSOV->cVysPol    := oDlg:cVyrPol
      KUSOV->nNizVar    := max( 1, VYR_SetNizVar( oDlg))
      KUSOV->cZkratJedn := NakPOL->cZkratJedn
      KUSOV->nSpMnSklHR := oDlg:nSpMnSklHR
      KUSOV->nSpMnSklCI := oDlg:nSpMnSklCI
      KUSOV->( dbUnlock())
    ENDIF

  ELSE                         // vazba na zakázkovou položku

    if .not. lnewRec
      mainOk := kusov->( sx_Rlock())
    else
      kusovWe->nnizVar := VYR_SetNizVar( oDlg)
    endif

    if mainOk
      mh_copyFld('KUSOVwe', 'KUSOV', lnewRec )
      KUSOV->nNizVar := max( 1, VYR_SetNizVar( oDlg)) 

      if lnewRec
        cKey := Upper( oDlg:cZakNizPol) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
        If VyrPol->( dbSeek( cKey))
           VYRPOLw->( dbZAP())
           mh_COPYFLD('VYRPOL', 'VYRPOLw', .T. )
           cKey := Upper( oDlg:cCisZAKAZ) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
           IF !VyrPOL->( dbSEEK( cKEY))
             If AddRec( 'VyrPol')
                mh_COPYFLD('VYRPOLw', 'VYRPOL' )
                VyrPol->cCisZakaz := oDlg:cCisZakaz
                VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
                VyrPol->nStavKalk := -1
                VyrPol->( dbUnlock())
             Endif
           ENDIF
        EndIf
        * Je-li položka strukturovaná, pak vícenásobný zápis do KUSOV a VYRPOL
        VYR_KusForRV( oDlg:cCisZakaz, oDlg:cZakNizPol, Kusov->cNizPol, Kusov->nNizVar )
      endif

      kusov->( dbUnlock(), dbCommit())
    endif
  ENDIF

  if isObject(o_nazNizPol)
    if o_nazNizPol:changed()

      cnazNizPol := o_nazNizPol:value

      cStatement := strTran( stmt      , '%cnazev', cnazNizPol          )
      cStatement := strTran( cStatement, '%czak'  , oDlg:cCisZAKAZ      )
      cStatement := strTran( cStatement, '%cvyr'  , Kusov->cNizPol      )
      cStatement := strTran( cStatement, '%nvar'  , str(Kusov->nNizVar) )

      oStatement := AdsStatement():New(cStatement, oSession_data)

      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif

      vyrPol->(dbUnlock(), dbCommit())
*      listhd->(dbUnlock(), dbCommit())
    endif
  endif

RETURN NIL

* Zrušení vazby v kusovníku
*===============================================================================
FUNCTION VYR_KUSOV_del( oDlg)
  Local o, cMsg, lDel := .F., IsYES, lOK := .T.
  *
  local  oItemd, h

  IF lOK .AND. KusTREE->( RecNO()) > 1

    cMsg  := '< Zrušení kusovníkové vazby >;;' + ;
             'Zrušení vazby mezi položkami vyšší - nižší se promítne do všech kusovníkù,' + ;
             'kde se tato vazba vyskytuje !;;' + ;
             'Skuteènì chcete zrušit vazbu v kusovníku ?'
    IF ( isYES := drgIsYESNO(drgNLS:msg( cMsg) ) )
      IF KusTREE->nVarPoz == 1
        cMsg := 'Rušíte základní variantu pozice èíslo 1,;' + ;
                'a proto je bezpodmíneènì nutné tuto pozici znovu definovat !;;' + ;
                'Skuteènì chcete zrušit vazbu v kusovníku ?'
        isYES := drgIsYESNO(drgNLS:msg( cMsg) )
      ENDIF
      IF isYES
        lDel := .T.
        IF EMPTY( KusTREE->cCisZakaz) .OR. KusTREE->lNakPOL  // Nezakázkový kusovník
          DelREC( 'Kusov')
          DelREC( 'KusTREE')
        ELSE                           // Zakázkový kusovník
          // Zrušení vazby v zakázkovém kusovníku
          DelREC( 'Kusov')
          DelREC( 'KusTREE')
          // DelKusZAK()
          // ???  - rušení všech vazeb nižších
          //      - rušení vyrábìných položek k této zakázce
        ENDIF
*        ENDIF
      ENDIF
    ENDIF
  ENDIF
  *
  IF lDel
    if odlg:otree:className() = 'XbpActiveXControl'
      oItems  := odlg:oTree:Items()
           h  := oItems:SelectedItem(0)
                 oItems:RemoveItem(h)
    else
      o := oDlg:oTree:getData()
      o:getParentItem():delItem( o)
    endif
  ENDIF

RETURN lDel

* Zjistí novou pozici v KUSOV
*===============================================================================
FUNCTION VYR_NewPos()
  LOCAL nNewPos := 0, nRec := KusTree->( RecNo())
  LOCAL cScope := LEFT( ALLTRIM(KusTree->cTreeKey), LEN( ALLTRIM( KusTree->cTreeKey))- 3)
/*
  KusTree->( Ads_SetScope( SCOPE_TOP   , cScope + '001' ),;
             Ads_SetScope( SCOPE_BOTTOM, cScope + '999' ),;
             dbGoBottom() )
  nNewPos := KusTree->nPozice + 1
  KusTree->( Ads_ClearScope( SCOPE_TOP), Ads_ClearScope( SCOPE_BOTTOM),;
             dbGoTo( nRec) )
*/
  KusTree->( mh_SetScope( cScope + '001', cScope + '999' ), dbGoTop() )
  KusTree->( dbEval( {|| ;
    nNewPos := Max( VAL( SubStr( KusTree->cTreeKey, Len( cScope)+ 1, 3)), nNewPos) }))
  nNewPos++
  KusTree->( mh_ClrScope( SCOPE_TOP), mh_ClrScope( SCOPE_BOTTOM),;
             dbGoTo( nRec) )

RETURN nNewPos

*
*===============================================================================
FUNCTION VYR_SetNizVar( oDlg)
  Local nNizVar := Kusov->nVarPoz
  Local cKey, lFound := .F., nTypVar
  * 22.7.10
  nTypVar := SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )
  *
  cKey := oDlg:cZakNizPol + Kusov->cNizPol + StrZero( Kusov->nVarPoz, 3)
  If !Empty( Kusov->cNizPol )
    IF !( lFound := VyrPol->( dbSeek( Upper( cKey))) )
      IF nTypVar = 1
        * pokud neexistuje pøíslušná varianta, hledá se základní varianta 1
        cKey := oDlg:cZakNizPol + Kusov->cNizPol + '001'
        IF !( lFound := VyrPol->( dbSeek( Upper( cKey))) )
        * pokud neexistuje zákl. varianta 1 =>  ???  ... dáme 1
          nNizVar := 1   // 0
        ENDIF
      ELSEIF nTypVar = 2
        nNizVar := 1
      ENDIF
    ENDIF
  ENDIF
  nNizVar := If( lFound, VyrPol->nVarCis, nNizVar)
RETURN nNizVar


* Funkce pro tvorbu zakázkového kusovníku
*
* Param.:cZakNEW- koresponduje se statickou promìnnou cCisZakaz a pro
*                 tuto hodnotu zakázky má být kusovník vytvoøen.
*        cZakOLD- obsahuje è.zakázky z níž má tvorba vycházet
*        cNizPol- vyr. položka, pro kterou má být kusovník generován.
*        nNizVar- varianta položky
*        Parametry byly použity proto, aby funkce byly použitelná 
*        z úlohy RV, kde plní stejnou funkci.
*===============================================================================
FUNCTION VYR_KusForRV( cZakNEW, cZakOLD, cNizPol, nNizVar, lZapust, lZapustAKT )
  Local aV, aN, acVyrPol:={}, aFILES
  Local anRecKUS := {}, anRecVYR := {}, anRecOPE := {}, anRecDT := {}
  Local axVYRPOL, axPOLOPE, axVYRDT
  Local n, nPos, nPOL, nPOZ, nVAR, nRecZakPoz, nRecRet, nPozOrg, nREC, nCelPocOp
  Local lOK := YES, lExist, lZaklPoz, lContinue, cKey, cKeyDT, cMsg
  Local alTypZapus  := ListAsArray( SysCONFIG( 'Vyroba:cTypZapus'))
  Local lSetRYO, lNakPOL // := EMPTY( Kusov->cNizPol)
  *
  local  ncnt, nmnozZadan, nspMNOnas, nvyrST, cky_KUSOV, lin_KUSOV, axKUSOV := {}
  local  nroot_vyrPol := 0


  alTypZapus := AEVAL( alTypZapus, {|X,i| alTypZapus[i] := ( X = '1')  })


  DEFAULT lZapust    TO NO    // Voláno z mechanismu zapouštìní zakázky
  DEFAULT lZapustAKT TO NO    // Voláno pøi "Zapuštìní s aktualizací"
  DEFAULT alTypZapus TO { NO, NO, NO, NO, NO }

  * lSetRYO ... urèuje, kdy se bude nad PolOper tvoøit specif. filter, který
  *             vylouèí duplicity
  lSetRYO := !( !alTypZapus[ 1] .AND. !alTypZapus[ 2] .AND. !alTypZapus[ 3] .AND. ;
               !alTypZapus[ 4] .AND.  alTypZapus[ 5] )
//  lSetRYO := ( alTypZapus <> { NO, NO, NO, NO, YES } ) .OR. ( !lZapust .AND. !lZapustAKT)

  lNakPOL := IF( lZapust .OR. lZapustAKT, NO, EMPTY( Kusov->cNizPol) )

  * Naplní se pole <anRecKus> èísly záznamù tìch vazeb, které jsou souèástí
  * struktury nižší položky poøizované vazby.
  drgDBMS:open('VYRPolDT' )
  FOrdREC( { 'Kusov, 1', 'VyrPol, 1', 'VyrPolDT, 1', 'PolOper, 1' })

  * Vrcholová  položka
  cKey := Upper( cZakOLD) + Upper( cNizPol) + StrZero( nNizVar, 3)
  IF( VyrPol->( dbSEEK( cKey))  , ( nroot_vyrPol := vyrPol->( recNo()), AADD( anRecVYR, VyrPol->( RecNO())) ) , NIL )
  IF( VyrPolDT->( dbSEEK( cKey)), AADD( anRecDT, VyrPolDT->( RecNO())), NIL )

//21.1.02 IF lZapust
     * Pøi zapouštìní se musí generovat záznamy do PolOper i pro vrcholovou pol.
     VYR_ScopePOLOPER( cZakOLD, nNizVar, lZapust, lSetRYO )
     DO WHILE !PolOper->( EOF())
        IF( nPos := aScan( anRecOPE, PolOper->( RecNO())) <> 0, NIL,;
        AADD( anRecOPE, PolOper->( RecNO()) ) )
        PolOper->( dbSKIP())
     ENDDO
     VYR_ScopePOLOPER()
//  ENDIF
  *
  ( aV := {}, aN := {} )
  AADD( aV, Upper( cZakOLD) + Upper( cNizPol) )
  DO WHILE lOK
    FOR n := 1 TO LEN( aV)
       KUSOV->( mh_SetScope( aV[n] ))
       DO WHILE !Kusov->( EOF())
          lExist   := NO
          lZaklPoz := NO
          nPozOrg  := Kusov->nPozice

          DO WHILE nPozOrg == Kusov->nPozice .AND. !Kusov->( EOF())
             IF Kusov->nVarPoz == nNizVar

                * Do kusovníku jsou pøebrány jen vazby s variantou pozice == variantì
                *  vrcholového výrobku
                AADD( aN, Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) )
                AADD( anRecKus, Kusov->( RecNO()) )
                lExist := YES

                * Vybere vyr.položku s daným klíèem pouze jednou
                cKey := Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
                IF VyrPol->( dbSEEK( cKey))
                  IF( nPos := ASCAN( anRecVYR, VyrPol->( RecNO())) <> 0, NIL,;
                      AADD( anRecVYR, VyrPol->( RecNO()) ) )
                  IF VyrPolDT->( dbSEEK( cKey))
                    IF( nPos := aScan( anRecDT, VyrPolDT->( RecNO())) <> 0, NIL,;
                        AADD( anRecDT, VyrPolDT->( RecNO()) ) )
                  ENDIF
                ENDIF
             ELSEIF Kusov->nVarPoz == 1
                nRecZakPoz := Kusov->( RecNo())
                lZaklPoz   := YES
             ENDIF
             Kusov->( dbSKIP())
          ENDDO
          IF !lExist .AND. lZaklPoz

             * pokud neexistuje požadovaná varianta pozice, uplatní se
             * základní 001 - ta s nejnižší hodnotou, tj. s nejvyšší prioritou
             nRecRet := Kusov->( RecNO())
             Kusov->( dbGoTO( nRecZakPoz))
             AADD( aN      , Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) )
             AADD( anRecKus, Kusov->( RecNO()) )

             * Vybere vyr.položku s daným klíèem pouze jednou
             cKey := Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
             IF VyrPol->( dbSEEK( cKey))
                IF( nPos := aScan( anRecVYR, VyrPol->( RecNO())) <> 0, NIL,;
                  AADD( anRecVYR, VyrPol->( RecNO()) ) )
                  IF VyrPolDT->( dbSEEK( cKey))
                     IF( nPos := aScan( anRecDT, VyrPolDT->( RecNO())) <> 0, NIL,;
                         AADD( anRecDT, VyrPolDT->( RecNO()) ) )
                  ENDIF
             ENDIF
             Kusov->( dbGoTO( nRecRet))
          EndIf
       EndDo
       KUSOV->( mh_ClrScope())
    NEXT
    aV  := aN
    aN  := {}
    lOK := ( Len( aV) <> 0 )
  ENDDO

  * Probìhne pøípadný vícenásobný zápis do KUSOV, VYRPOL, VYRPOLDT a POLOPER.
  If ( !Empty( anRecKus) .OR. !EMPTY( anRecOPE) ) .AND. !lNakPOL
     cMsg := 'Zkopírovat položku k nové zakázce i s rozpiskou ?'
     lContinue := If( lZapust, YES, drgIsYESNO(drgNLS:msg( cMsg) ))
     If lContinue
        * Vícenásobný zápis do Kusov
        KUSOVw->( dbZAP())

        for ncnt := 1 to len(anRecKUS) step 1
          kusov->( dbGoTo( anRecKUS[ncnt] ))
          mh_COPYFLD('KUSOV', 'KUSOVw', .T. )

          *
          ** pøi zapoouštìní s Aktualizací je kusTree otevøený ale prázdný
          ** nesmí pøepsat nmnozZadan pokud je nastaveno u plánu ani nvyrST
          if select('kusTree') <> 0
            if ( kusovW->_nsidOr <> 0 .and. kusTree->( dbseek( kusovW->_nsidOr,,'KUSOV' )) )
              kusovW->nmnozZadan := kusTree->nmnozZadan
              kusovW->nvyrST     := kusTree->nvyrST

              if .not. kusTree-> lnakPol
*                if kusTree->nmnozZadan <> kusTree->nspMNOnas
                   kusovW->nspMNOnas := kusTree->nspMNOnas
*                endif
              endif

            endif
          endif
        next

        KUSOVw->( dbCOMMIT())

        * 18.5.2001
         IF lZapustAKT
          KUSOV->( mh_SetScope( Upper( cZakNEW) ) )

          do while .not. kusov->( eof())
            cKey := Upper(cZakNEW) + Upper(kusov->cVysPol) + ;
                    StrZero(kusov->nPozice,3) + StrZero(kusov->nVarPOZ,3)
            aadd( axKUSOV, { ckey, kusov->nmnozZadan, kusov->nvyrST, kusov->nspMNOnas } )

            if(kusov->nCislPolOb == 0, DELREC( 'KUSOV'), nil )
            kusov->( dbSkip())
          enddo

//            KUSOV->( dbEVAL( {|| IF( KUSOV->nCislPolOb == 0, DELREC( 'KUSOV'), NIL) }))
          KUSOV->( mh_ClrScope())
        ENDIF
        *
        FOR n := 1 TO LEN( anRecKUS)
           KUSOVw->( dbGoTO( n))
           cKey := Upper( cZakNEW) + Upper( KUSOVw->cVysPol ) + ;
                   StrZero( KUSOVw->nPozice, 3) + StrZero( KUSOVw->nVarPOZ, 3)

           * Kontrola, aby se nezapsala duplicita
           IF Kusov->( dbSEEK( cKey))
              //////
              VYR_ScopePOLOPER( cZakOLD, nNizVar,,lSetRYO)
              DO WHILE !PolOper->( EOF())
                 IF( nPos := ASCAN( anRecOPE, PolOper->( RecNO())) <> 0, NIL,;
                    AADD( anRecOPE, PolOper->( RecNO()) ) )
                 PolOper->( dbSKIP())
              ENDDO
              VYR_ScopePOLOPER()
              ///////
              IF lZapustAKT .AND. Kusov->nCislPolOb == 0
                 IF KUSOV->( RLock())
                   nmnozZadan := kusov->nmnozZadan
                   nspMNOnas  := kusov->nspNMOnas
                   nvyrST     := kusov->nvyrST

                   mh_COPYFLD('KUSOVw', 'KUSOV' )
                   Kusov->cCisZakaz  := cZakNEW
                   kusov->nmnozZadan := nmnozZadan
                   kusov->nspMNOnas  := nspMNOnas
                   kusov->nvyrST     := nvyrST
                   Kusov->dZapis     := Date()
                   KUSOV->( dbUnLock())
                 ENDIF
              ENDIF
           ELSE
              If KUSOV->( dbAppend(), RLock())
                 mh_COPYFLD('KUSOVw', 'KUSOV' )
                 Kusov->cCisZakaz := cZakNEW

                 if( npos := ascan( axKUSOV, {|xI| xI[1] = ckey}) ) <> 0
                    nmnozZadan := axKUSOV[npos,2]
                    nvyrST     := axKUSOV[npos,3]
                    nspMNOnas  := axKUSOV[npos,4]

                    kusov->nmnozZadan := nmnozZadan
                    kusov->nvyrST     := nvyrST
                    kusov->nspMNOnas  := nspMNOnas
                 endif

                 Kusov->dZapis    := Date()
                 /////
                 VYR_ScopePolOper( cZakOLD, nNizVar,, lSetRYO)
                 Do While !PolOper->( Eof())
                    If( nPos := aScan( anRecOPE, PolOper->( RecNo())) <> 0, NIL,;
                      aAdd( anRecOPE, PolOper->( RecNo()) ) )
                    PolOper->( dbSkip())
                 EndDo
                 VYR_ScopePolOper()
                 /////
                 KUSOV->( dbUnLock())
              EndIf
           ENDIF
        NEXT

        * Vícenásobný zápis do VYRPOL
        VYRPOLw->( dbZAP())
        aEVAL( anRecVYR, { |Rec| ( VYRPOL->( dbGoTo( Rec))                , ;
                                   mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.) ) } )
        VYRPOLw->( dbCOMMIT())

        FOR n := 1 To Len( anRecVYR)
           VYRPOLw->( dbGoTO( n))
           cKey      := Upper( cZakNEW) + Upper( VyrPOLw->cVyrPol) + StrZero( VYRPOLw->nVarCis, 3)

           // KUSOV2 -> UPPER(CCISZAKAZ) +UPPER(CNIZPOL) +STRZERO(NNIZVAR,3)
           cky_KUSOV := upper(cZakNEW) +upper(vyrPolW->cvyrPol)
           lin_KUSOV := kusov->( dbseek( cky_KUSOV,,'KUSOV2' ))

           * Kontrola, aby se nezapsala duplicita
           If !VyrPol->( dbSeek( cKey))
              If VyrPol->( dbAppend(), RLock() )
                 mh_COPYFLD('VYRPOLw', 'VYRPOL')
                 VyrPol->cCisZakaz := cZakNEW
                 VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
                 VyrPol->nStavKalk := -1
                 vyrPol->nis_Root  := if( anrecVyr[n] = nroot_vyrPol, 1, 0 )
                 vyrPol->nvyrST    := if( lin_KUSOV, kusov->nvyrST, 1 )

                 VyrPol->( dbUnLock())
              endif

           else
             if vyrPol->(RLock())
                vyrPol->nis_Root := if( anrecVyr[n] = nroot_vyrPol, 1, 0 )
                vyrPol->nvyrST   := if( lin_KUSOV, kusov->nvyrST, 1 )

                VyrPol->( dbUnLock())
              endif
           Endif
        Next

        * Vícenásobný zápis do VyrPolDT
        VYRPOLDTw->( dbZAP())
        aEval( anRecDT, { |Rec| VyrPolDT->( dbGoTo( Rec)) ,;
                               mh_COPYFLD('VYRPOLDT', 'VYRPOLDTw', .T.)})
        VYRPOLDTw->( dbCOMMIT())

        For n := 1 To Len( anRecDT)
           VYRPOLDTw->( dbGoTO( n))
           cKey := Upper( cZakNEW) + Upper( VYRPOLDTw->cVyrPol) + StrZero( VYRPOLDTw->nVarCis, 3)
           * Kontrola, aby se nezapsala duplicita
           IF VyrPolDT->( dbSeek( cKey))
              IF lZapustAKT
                * pouze pøi zapuštìní s aktualizací aktualizovat poèet operací z nezak. výrobku
                nREC := VyrPolDT->( RecNO())
                cKEY := EMPTY_ZAKAZ + Upper( VYRPOLDTw->cVyrPol) + StrZero( VYRPOLDTw->nVarCis, 3)
                IF VyrPolDT->( dbSeek( cKey))
                   nCelPocOp := VyrPolDT->nCelPocOp
                   VyrPolDT->( dbGoTO( nREC))
                   IF VyrPolDT->( RLock())
                      VyrPolDT->nCelPocOp := nCelPocOp
                      VyrPolDT->( dbUnLock())
                   ENDIF
                ENDIF
              ENDIF
           ELSE
              If VyrPolDT->( dbAppend(), RLock())
                 mh_COPYFLD('VYRPOLDTw', 'VYRPOLDT')
                 VyrPolDT->cCisZakaz := cZakNEW
                 VyrPolDT->( dbUnLock())
              EndIf
           ENDIF
        Next

        cMsg := 'Zkopírovat položku k nové zakázce i s technologickým postupem ?'
        lContinue := If( lZapust, YES, drgIsYESNO(drgNLS:msg( cMsg) ))
        If lContinue
           * Vícenásobný zápis do PolOper
           POLOPERw->( dbZAP())
           aEVAL( anRecOPE, { |Rec| PolOper->( dbGoTo( Rec))  ,;
                                  mh_COPYFLD('POLOPER', 'POLOPERw', .T.)})
           POLOPERw->( dbCOMMIT())
           *
           IF lZapustAKT
             POLOPER->( mh_SetScope( Upper( cZakNEW)))
               POLOPER->( dbEVAL( {|| IF( POLOPER->nPorCisLis == 0, DELREC( 'POLOPER'), NIL) }))
             POLOPER->( mh_ClrScope())
           ENDIF
           *
           FOR n := 1 To LEN( anRecOPE)
             POLOPERw->( dbGoTO( n))
             cKey := Upper( cZakNEW) + Upper( POLOPERw->cVyrPOL) + ;
                     StrZERO( POLOPERw->nCisOper, 4) + StrZERO( POLOPERw->nUkonOper, 2) + ;
                     StrZERO( POLOPERw->nVarOper, 3)
             *
             IF PolOPER->( dbSEEK( cKey))
               IF lZapustAKT .AND. PolOPER->nPorCisLis == 0
                 IF PolOper->( RLock())
                   mh_COPYFLD('POLOPERw', 'POLOPER')
                   PolOPER->cCisZakaz := cZakNEW
                   VYR_POLOPER_fill( cZakNEW)
                   PolOper->( dbUnLock())
                 ENDIF
               ENDIF
             ELSE   // IF !PolOPER->( dbSEEK( cKey))
               IF PolOper->( dbAppend(), Sx_RLock() )
                 mh_COPYFLD('POLOPERw', 'POLOPER')
                 PolOPER->cCisZakaz := cZakNEW
                 *
                 PolOPER->nRokVytvor := 0
                 PolOPER->nPorCisLis := 0
                 PolOPER->nPocCeZapZ := 0
                 PolOPER->nMnZadVK   := 0
                 *
                 VYR_POLOPER_fill( cZakNEW)
                 PolOper->( dbUnLock())
               ENDIF
             ENDIF
           NEXT

        EndIf
     EndIf
  Endif
  FOrdREC()

RETURN Nil

*
*===============================================================================
FUNCTION VYR_ScopePOLOPER( cZakOLD, nVarCis, lZapust, lSetRYO )
  Local nArea := Select(), nRec, nPos, anRec := {}
  Local cKeyOld, cKeyNew, cScope
  Local lNakPol, nTypVar
  * 22.7.10
  nTypVar := SysConfig( 'Vyroba:nTypVar')
  nTypVar := If( IsArray( nTypVar), 1, nTypVar )
  *
  Default lZapust To NO
  IF PCOUNT() == 0        // zrušit omezení
     PolOPER->( mh_ClrScope())
     PolOPER->( Ads_ClearAOF(), dbGoTOP() )
     RETURN NIL
  ENDIF

  * Je-li lZapust=YES, jde o vrcholovou položku a ta nemùže být nakupovaná !
  lNakPol := If( lZapust, NO, Empty( Kusov->cNizPol))
  Select( 'PolOper')
  IF lSetRYO // .OR. !lZapust
    PolOPER->( Ads_ClearAOF(), dbGoTOP() )
  ENDIF
  cScope := IIf( lNakPol, Kusov->cVysPol ,;
            IIf( lZapust, VyrZak->cVyrPol, Kusov->cNizPol ))
  cScope := Upper( cZakOLD) + Upper( cScope)
  PolOPER->( mh_SetSCOPE( cScope ))
  IF lSetRYO // .OR. !lZapust
     If lNakPol
        cKeyNew := Upper( cZakOLD) + Upper( Kusov->cVysPol) + ;
                   StrZero( Kusov->nCisOper, 4) + StrZero( Kusov->nUkonOper, 2)   //  + StrZero( nVarRoot)
        If  PolOper->( dbSeek( cKeyNew + StrZero( nVarCis, 3) ))
        ElseIf nTypVar = 1
          PolOper->( dbSeek( cKeyNew + '001' ))
        EndIf
        aAdd( anRec, PolOper->( RecNo()) )
     Else
        cKeyOld := Space( 36)
        Do While !PolOper->( Eof())
          nRec := PolOper->( RecNo())
          cKeyNew := cScope + StrZero( PolOper->nCisOper, 4) + ;
                     StrZero( PolOper->nUkonOper, 2)
          If cKeyNew <> cKeyOld
              If PolOper->( dbSeek( cKeyNew + StrZero( nVarCis)))
                 nPos := aSCAN( anRec, PolOper->( RecNo()) )
                 If( nPos == 0, aAdd( anRec, PolOper->( RecNo()) ), NIL )
              ElseIf nTypVar = 1
                 If PolOper->( dbSeek( cKeyNew + '001'))
                    aAdd( anRec, PolOper->( RecNo()) )
                 EndIf
              Endif
          EndIf
          PolOper->( dbGoTo( nRec))
          cKeyOld := cKeyNew
          PolOper->( dbSkip())
      EndDo
     EndIf
     mh_RyoFILTER( anREC, 'POLOPER')
  ENDIF
  PolOper->( dbGoTop())
  dbSelectArea( nArea)

RETURN Nil

*===============================================================================
FUNCTION VYR_isKusov( nID, cAlias, retLogical)
  Local isKusov, cKey := Upper( (cAlias)->cCisZakaz) + Upper( (cAlias)->cVyrPol)

  DEFAULT retLogical TO .F.
  *
  drgDBMS:open('KUSOV',,,,, 'KUSOVa')
  cKey += IF( cAlias = 'VyrZakIT', StrZero( VyrZakIT->nOrdItem, 3), '' )
  isKusov := KUSOVa->( dbSeek( cKey,,'KUSOV4'))
  *
  IF retLogical
    RETURN isKusov
  ENDIF
RETURN( IF(isKusov, DRG_ICON_SELECTT, DRG_ICON_SELECTF))