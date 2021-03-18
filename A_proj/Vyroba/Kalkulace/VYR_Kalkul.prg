/*******************************************************************************
  VYR_KALKUL.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  VYR_SetFixNakl       SetFixNakl        KalkPlan.prg
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*
*===============================================================================
FUNCTION VYR_KALKUL_edit( oDlg)
  LOCAL cKey, lOK, nREC

  IF oDlg:lCopyREC
     mh_COPYFLD('KALKUL', 'KALKULw', .T.)
     KALKULw->dDatAktual := DATE()
  ELSEIF oDlg:lNewREC
     KALKULw->(dbAppend())
     * Pøednastavení pøi INS
     KALKULw->nTypRezie  := 2
     KALKULw->nMnozDavky := IF( oDlg:cFILE = 'VYRZAK'    , VyrZak->nMnozPlano,;
                            IF( EMPTY( VyrPOL->cCisZAKAZ), VYRPOL->nEkDav    ,;
                                                           VyrZak->nMnozPlano))
     KALKULw->nMnozDavky := IF( KALKULw->nMnozDavky = 0, 1, KALKULw->nMnozDavky)
     KALKULw->cDruhCeny  := '1 '
     KALKULw->cZkratMENY := 'CZK'
     KALKULw->cTypKalk   := IF( oDlg:nKalkulZA = 1, 'STD', 'VPO')
     KALKULw->nRokVyp    := YEAR( Date())
     KALKULw->nObdMes    := MONTH( Date())
     KALKULw->dDatAktual := DATE()
     KALKULw->nAlgOdbyt  := SysCONFIG( 'Vyroba:nOdbytREZ')  // 2
     KALKULw->nAlgVyrob  := SysCONFIG( 'Vyroba:nVyrobREZ')  // 2
     KALKULw->nAlgZasob  := SysCONFIG( 'Vyroba:nZasobREZ')  // 2
     KALKULw->nAlgSprav  := SysCONFIG( 'Vyroba:nSpravREZ')  // 2
     KALKULw->nZiskProcP := SysCONFIG( 'Vyroba:nProcZisk')

  ELSE
     mh_COPYFLD('KALKUL', 'KALKULw', .T.)
  ENDIF
  VYR_SetFixNakl( KALKULw->nRokVyp, KALKULw->nObdMes, NO )

RETURN NIL

*
*===============================================================================
FUNCTION VYR_KALKUL_save( oDlg)
  Local cFILE := oDlg:cFILE

  IF ! oDlg:drgDialog:dialogCtrl:isReadOnly
    oDlg:dataManager:save()
    IF( oDlg:lNewREC, KALKUL->( DbAppend()), Nil )
    IF KALKUL->(sx_RLock())
       mh_COPYFLD('KALKULw', 'KALKUL' )
*       mh_WRTzmena( 'KALKUL', oDlg:lNewREC)
       IF oDlg:lNewREC
         * VyrPol->( dbGoTo( nRecVyrPol))
         Kalkul->cCisZakaz := ( cFILE)->cCisZakaz
         Kalkul->cVyrPol   := ( cFILE)->cVyrPol
//         Kalkul->cTypPol   := ( cFILE)->cTypPol
         Kalkul->nVarCis   := ( cFILE)->nVarCis
         IF oDlg:nKalkulZA == 2
           Kalkul->cTypKalk  := 'VPO'
           Kalkul->cCisZakaz := ''
         ENDIF
       EndIf
       IF cFILE = 'VYRZAK'
         Kalkul->cNazPOL1  := VYRZAK->cNazPOL1
         Kalkul->nCisFirmy := VYRZAK->nCisFirmy
         Kalkul->cNazFirmy := VYRZAK->cNazFirmy
       ENDIF
       /*
       //- 26.1.2004
       Kalkul->nPriprCAS := nPriprCASK
       Kalkul->nKusovCAS := nKusovCASK
       //-
       MatMzdyACT()
       */
       KALKUL->( dbUnlock())
    ENDIF
  ENDIF

RETURN NIL

* Zrušení kalkulace(KALKUL) k vyrábìné položce
*===============================================================================
FUNCTION VYR_KALKUL_del( nTypKalk)
  Local cKey, cMsg, lDel := .F., IsYES, aMAT := {}, aMZDY := {}
  Local lFAKT := NO, lMAT, lMZDY

  IF ( nTypKalk = KALKUL_PLAN .or. nTypKalk = KALKUL_VYSL ) .and.;
     ( !Kalkul->( BOF()) .or. !Kalkul->( EOF()) )

    IF ( lFAKT := ( Kalkul->cTypKalk == 'NED' .AND. VyrZAK->nMnozFAKT > 0 ) )
       cMsg := 'Kalkulace NEDOKONÈENÉ VÝROBY;;Na zakázku již bylo fakturováno !'
       drgMsgBox(drgNLS:msg( cMsg) )
    ELSE
      cMsg  := '< Zrušení kalkulace >;; Zrušit kalkulaci vyrábìné položky ?'
      IF ( isYES := drgIsYESNO(drgNLS:msg( cMsg) ) )
        cKey := Upper( Kalkul->cCisZakaz) + Upper( Kalkul->cVyrPol) +;
                StrZero( Kalkul->nVarCis, 3) + DtoS( Kalkul->dDatAktual) +;
                StrZero( Kalkul->nPorKalDen, 2)

        PrMAT->( mh_SetScope( cKey))
        PrMAT->( dbEVAL( {|| AADD( aMAT, PrMAT->( RecNO()) )}))
        PrMAT->( mh_ClrScope())
        lMAT := IF( LEN( aMAT) = 0, .T.,  PrMAT->( sx_RLock( aMAT)))
        PrMZDY->( mh_SetScope( cKey))
        PrMZDY->( dbEVAL( {|| AADD( aMZDY, PrMZDY->( RecNO()) )}))
        PrMZDY->( mh_ClrScope())
        lMZDY := IF( LEN( aMZDY) = 0, .T.,  PrMZDY->( sx_RLock( aMZDY)))

        IF KALKUL->( sx_RLock()) .and. lMAT .and. lMZDY
          *
          AEVAL( aMAT, {|nREC| PrMAT->( dbGoTO( nREC), dbDelete()) } )
          PrMAT->( dbUnlock())
          *
          AEVAL( aMZDY, {|nREC| PrMZDY->( dbGoTO( nREC), dbDelete()) } )
          PrMZDY->( dbUnlock())
          *
          KALKUL->( dbDelete(), dbUnlock())
          lDel := .T.
        ENDIF
        /*
        Do While PrMat->( dbSeek( cKey))  ; DelRec( 'PrMat')  ;  EndDo
        Do While PrMzdy->( dbSeek( cKey)) ; DelRec( 'PrMzdy') ;  EndDo
        DelREC( 'Kalkul')
        lDel := .T.
        */
      ENDIF
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg( 'Není co rušit !') )
  ENDIF

RETURN lDEL


* Nastavení FixNakl na pøíslušný záznam
*================================================================================
FUNCTION VYR_SetFixNakl( nRokVyp, nObdMes, lWarning, Dialog )
  Local  cKey := VyrPol->cStrVyr, cTag := FixNakl->( AdsSetOrder( 1)), cMsg
  Local  lExist := NO, nObdHLP, cSetGet

  DEFAULT lWarning TO YES
  IF C_Stred->( dbSeek( Upper( cKey),,'STRED1'))
     cKey := StrZero( nRokVyp, 4) + Upper( C_Stred->cNazPol1) + ;
             StrZero( nObdMes, 2) + Upper( VyrPol->cNazPol2)
     IF ! ( lExist := FixNakl->( dbSeek( cKey)) )
       cKEY := LEFT( cKEY, 14 )
       IF ! ( lExist := FixNakl->( dbSeek( cKey)) )
         nObdHLP := nObdMES
         DO WHILE !lExist .AND. nObdHLP >= 0
            nObdHLP := nObdHLP - 1
            cKey := StrZero( nRokVyp, 4) + Upper( C_Stred->cNazPol1) + StrZero( nObdHLP, 2)
            lExist := FixNAKL->( dbSEEK( cKey))
         ENDDO
       ENDIF
     ENDIF
  ENDIF
  IF !lExist .and. lWarning
     cMsg := 'Nebyly zadány režijní náklady !;;' + ;
             'Rok výpoètu    :  < & >    ;' + ;
             'Nákladové stø. :  < & >    ;' + ;
             'Období             :  < & >    ;' + ;
             'Úèetní výrobek :  < & >  ;;' + ;
             'Požadujete jejich zadání ? '

     IF drgIsYesNO(drgNLS:msg( cMsg, nRokVyp, C_Stred->cNazPol1, nObdMes, VyrPol->cNazPol2  ))

*        KarFixNAKL( K_INS, {  { 1, nRokVyp           } ,;
*                              { 2, C_Stred->cNazPol1 } ,;
*                              { 3, nObdMes           } ,;
*                              { 4, VyrPol->cNazPol2  } } )

*        cSetGet :=  "{  { 'nRokVyp', nRokVyp }, { 'cNazPol1', C_Stred->cNazPol1 }, { 'nObdMes', nObdMes }, { 'cNazPol2', VyrPol->cNazPol2  } } "
*        cSetGet :=  "{  { 'nRokVyp'; nRokVyp }; { 'cNazPol1'; C_Stred->cNazPol1 }; { 'nObdMes'; nObdMes }; { 'cNazPol2'; VyrPol->cNazPol2  } } "
        cSetGet :=  "{ KALKULw->nRokVyp; C_Stred->cNazPol1; KALKULw->nObdMes; VyrPol->cNazPol2 }"

        Dialog:pushArea()
        DRGDIALOG FORM 'VYR_FIXNAKL_CRD,.F.,' + cSetGet PARENT Dialog CARGO drgEVENT_APPEND ;
        MODAL DESTROY
        Dialog:popArea()

     ENDIF
  ENDIF
  FixNAKL->( AdsSetOrder( cTag))
RETURN Nil

* Pøenos kalkulované ceny do ceníku  ... jen plánové kalkulace
*===============================================================================
FUNCTION VYR_KalkToCENIK( cSklPOL)

  IF( Used('CENZBOZ') , NIL, drgDBMS:open('CENZBOZ'))
  FOrdREC( { 'CenZBOZ, 1' })
  CenZBOZ->( mh_SetScope( Upper(cSklPOL)) )
  DO WHILE !CenZBOZ->( EOF())
    IF ReplREC( 'CenZBOZ')
       CenZBOZ->nCenaVNI := Kalkul->nCenKalkP
       CenZBOZ->( dbUnlock())
    ENDIF
    CenZBOZ->( dbSKIP())
  ENDDO
  CenZBOZ->( mh_ClrScope())
  FOrdREC()
RETURN NIL

* Výpoèet skuteèné výrobní režie z LISTIT
*-------------------------------------------------------------------------------
FUNCTION VYR_vREZ_Skut( nALG)
  Local nKc := 0, nHOD := 0, nVAL, cKEY, lOK, cTAG1
  Local nPrMzdy  := SysCONFIG( 'Vyroba:nPrMzdaKal')
  Local cNazPol1 := SysCONFIG( 'Vyroba:cNazPol1'), aNazPOL1
  Local cStrMzdy := SysCONFIG( 'Vyroba:cStrMzdy'), aStrMzdy

  DEFAULT nALG TO 0
  IF( Used('ListIT') , NIL, drgDBMS:open('ListIT'))
  cTAG1 := ListIT->( AdsSetOrder( 8))
  drgDBMS:open('C_Pracov')
  *
  IF !IsNIL( cNazPOL1 )
    aNazPOL1 := ListAsARRAY( ALLTRIM( cNazPOL1) )
    cNazPOL1 := aNazPOL1[ 1]
  ENDIF
  * Výèet støedisek pro výpoèet pøímých mezd
  IF !IsNIL( cStrMzdy )
    aStrMzdy := ListAsARRAY( ALLTRIM( cStrMzdy) )
  ENDIF

  ListIT->( mh_SetScope( Upper( VyrZAK->cCisZAKAZ)) )
  DO WHILE !ListIT->( EOF())
    IF nALG == 6
       lOK := IIF( IsNIL( cNazPol1), YES,;
              IIF( nPrMzdy == 1,     YES,;
              IIF( nPrMzdy == 2, ListIT->cNazPol1 == VyrZAK->cNazPOL1,;
              IIF( nPrMzdy == 3, VYR_VycetSTR( aStrMzdy), NO  ) )))
      IF lOK
        nHOD += ListIT->nNmNaOpeSK / 60
      ENDIF
    ELSE
      C_Pracov->( dbSEEK( Upper( ListIT->cOznPrac),,'C_PRAC1') )
      nKc += ( ListIT->nNmNaOpeSK * C_Pracov->nSazbaStro) / 60
    ENDIF
    ListIT->( dbSKIP())
  ENDDO
  ListIT->( mh_ClrScope(), AdsSetOrder( cTAG1) )
  nVAL := IF( nALG == 6, nHOD * 100, nKC )
RETURN nVAL

* Zjistí, zda støedisko mzd.lístku je ve výètu støedisek zCFG
*===============================================================================
FUNCTION VYR_VycetSTR( aStrMzdy )
  Local lOK := NO, cNazPOL1 := ListIT->cKmenStrPr
//  Local lOK := NO, cNazPOL1 := ListIT->cNazPOL1

  IF( Used('MsPrc_MO') , NIL, drgDBMS:open('MsPrc_MO'))
  IF ListIT->nOsCisPrac <> 0
    if MsPrc_MO->( dbSEEK( StrZero(ListIT->nRok) +StrZero(ListIT->nObdobi) +StrZero(ListIT->nOsCisPrac) ;
                               +StrZero(ListIT->nPorPraVzt),,'MSPRMO01'))
      cNazPOL1 := MsPrc_MO->cKmenStrPr
    ENDIF
  ENDIF
  AEVAL( aStrMzdy, {|X| lOK := IF( LIKE( X, ALLTRIM( cNazPOL1)), YES, lOK) })
RETURN lOK

*
*===============================================================================
FUNCTION VYR_procento_zPC( nPC, aItems )
  Local nProcento, nSumaItems := 0

  aEval( aItems, {|X| nSumaItems += X } )
  nProcento := nSumaItems / nPC * 100
RETURN nProcento