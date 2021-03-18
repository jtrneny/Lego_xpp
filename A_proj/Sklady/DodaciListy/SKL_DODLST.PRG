/*******************************************************************************
  SKL_DODLST.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
  SKL_NewDODLI     ->  NewFakt           FaktVYST
  SKL_DodLstHD_Modi->  FakVysHD_Modi     Vyd253
  SKL_DodLstIT_Modi->  FakVysIT_Modi     Vyd253
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

* NEW 3.4.2008
*===============================================================================
FUNCTION SKL_NewDODLI( cTypFak)
  Local nNewDL, nArea := SELECT(), cTag
  Local nRange := SysConfig( 'Sklady:nRangeDoLi')
  Local nStart := Val( Str( nRange[ 1], 10))
  Local nKonec := Val( Str( nRange[ 2], 10))

  drgDBMS:open( 'DODLSTHD' )
  ( dbSelectAREA( 'DODLSTHD'), cTag := DODLSTHD->( AdsSetOrder(1)) )
  DODLSTHD->( mh_SetScope( nStart, nKonec ),;
              dbGoBOTTOM() )
  nNewDL := IF( DODLSTHD->nDoklad = 0, nStart, DODLSTHD->nDoklad + 1 )

  DODLSTHD->( mh_ClrScope(), dbGoTOP(), AdsSetOrder( cTag), dbSelectAREA( nArea) )
RETURN( nNewDL )

*
*===============================================================================
FUNCTION SKL_DodLstHD_Wrt( lIsZahr)
  Local nTypVykDPH := SysConfig( 'FINANCE:nTypVykDPH')
  Local cObdobi := uctOBDOBI:SKL:COBDOBI
  Local nObdobi := uctOBDOBI:SKL:NOBDOBI
  Local lFirmyFI

  IF PVPHead->nKarta = 253 .or. PVPHead->nKarta = 293
    drgDBMS:open('FirmyFI'  )
    drgDBMS:open('C_TYPUHR' )
    lFirmyFI := FirmyFI->( dbSeek( PVPHead->nCisFirmy,,'FIRMYFI1'))
    IF AddREC(  'DodLstHD')
      DodLstHD->cUloha     := ULOHA_S
      DodLstHD->cTypDoklad := 'PRO_SKLDL'
      DodLstHD->cTypPohybu := 'DLGENSKLVY'
      DodLstHD->cObdobi    := cObdobi
      DodLstHD->nRok       := uctOBDOBI:SKL:NROK
      DodLstHD->nObdobi    := nObdobi
      DodLstHD->cObdobiDAN := StrZero( Round( nObdobi/ nTypVykDPH +nTypVykDPH/ 12, 0), 2) + ;
                              Right( cObdobi, 3 )
      DodLstHD->cZkratMeny := SysConfig( 'Finance:cZaklMena')
      DodLstHD->nKodZaokrD := SysConfig( 'Finance:nRoundDph')
      mh_COPYFLD( 'Firmy', 'DodLstHD')
      *
      DodLstHD->nCisFirDoa := Firmy->nCisFirmy
      DodLstHD->cNazevDoa  := Firmy->cNazev
      DodLstHD->cNazevDoa2 := Firmy->cNazev2
      DodLstHD->cUliceDoa  := Firmy->cUlice
      DodLstHD->cSidloDoa  := Firmy->cSidlo
      DodLstHD->cPscDoa    := Firmy->cPsc

      DodLstHD->dVystFak   := PVPHead->dDatPVP  // Date()   11.10.07
      DodLstHD->dPovinFak  := PVPHead->dDatPVP  // Date()   11.10.07
      DodLstHD->dSplatFak  := If( FirmyFi->nSplatnost <> 0 ,;
                                  DodLstHD->dVystFak + FirmyFi->nSplatnost      ,;
                                  DodLstHD->dVystFak + SysConfig( 'Finance:nSplatnost')  )

*      DodLstHd->nCisFak    := PVPHead->nCisloDL  /// Pujde pryc 17.8.07
      DodLstHd->nDoklad    := PVPHead->nCisloDL
      DodLstHd->nCisloDL   := PVPHead->nCisloDL
      DodLstHd->nCisloPVP  := PVPHead->nDoklad
      *
      DodLstHd->cZkrTypFak := 'DODLS'
      DodLstHd->cZkrTypUhr := 'HOTOV'
*      DodLstHd->nKodZaokr  := SeekKodZao( DodLstHd->cZkrTypUhr)
      C_TypUHR->( MH_Seek( DodLstHd->cZkrTypUHR, 1, .T. ))
      DodLstHd->nKodZAOKR  := C_TypUhr ->nKodZAOKR
      DodLstHd->nKonstSymb := If( lFirmyFi, FirmyFi->nKonstSymb, Val( '0008') )
      DodLstHd->lIsZahr    := lIsZahr
      DodLstHD->( dbUnlock())
    ENDIF
  ENDIF
RETURN NIL


* Modifikace hlavièky dod.listu [ DodLstHd ]
*===============================================================================
FUNCTION SKL_DodLstHD_Modi( nCisFaVy, nKey )

  Local nArea := Select(), n
  Local nOsvOdDan, nZaklDan_1, nSazDan_1, nZaklDan_2, nSazDan_2, nCenZakCel
  Local nOsv_S, nZakl1_S, nZakl2_S    // pro n poŸet polo§ek s dan¡
  Local nCenZakCeD := 0, nNapocet, nKoefDPH, nSazba
  Local nCountFAKT := 0, nCountDODLS := 0
  Local cKey, cFiHD, cFiIT, cHdDL, cItDL, cHdFA, cItFA
  Local acTyp := {}, anFak := {}, lOldDPH, nHLP
  Local nRoundDPH := SysConfig( 'Finance:nRoundDpH')

  Do Case
    Case  PVPHead->nKarta == 253 .or. PVPHead->nKarta == 293
      If ( PVPHead->nCisloDL <> 0,;
          ( aAdd( acTyp, 'DODLS' ), aAdd( anFak, PVPHead->nCisloDL) ), Nil )
    Case  PVPHead->nKarta == 283   // pùjde pryè
      ( aAdd( acTyp, 'PARAG'), aAdd( anFak, nCisFaVy ) )
  EndCase

  IF Len( acTyp) > 0
    drgDBMS:open('DODLSTHD' )
    drgDBMS:open('DODLSTIT' )
    drgDBMS:open('C_DPH'    )
    drgDBMS:open('C_TYPUHR' )
  *  ( cHdFA := FakVysHd->( AdsSetOrder( 5)), cItFA := FakVysIt->( AdsSetOrder( 4)) )
    ( cHdDL := DodLstHd->( AdsSetOrder( 5)), cItDL := DodLstIt->( AdsSetOrder( 4)) )

    FOR n = 1 TO Len( acTyp)
      cFiHd := 'DODLSTHD'  // If( n == 1, 'FAKVYSHD', 'DODLSTHD' )
      cFiIT := 'DODLSTIT'  // If( n == 1, 'FAKVYSIT', 'DODLSTIT' )
      cKey  := Upper( acTyp[ n]) + StrZero( anFak[ n], 10)
      IF ( cFiHD)->( dbSeek( cKey))
        ( cFiIT)->( mh_SetSCOPE( cKey))

         DO CASE
         CASE ( nKey == xbeK_DEL )
           DO WHILE !( cFiIT)->( Eof())
             SKL_DodLstIT_Modi( xbeK_DEL, acTyp[ n] )
             DelREC( cFiIT)
             ( cFiIT)->( dbSkip())
           ENDDO
           DelREC( cFiHD)

         CASE ( nKey == xbeK_ENTER ) .or. ( nKey == xbeK_INS )

           nOsvOdDan := nZaklDan_1 := nZaklDan_2 := 0
           nOsv_S := nZakl1_S := nZakl2_S := 0
           lOldDPH := SKL_AlgSazDPH( ( cFiHD)->nCisFirmy, ( cFiHD)->dPovinFAK )
           Do WHILE !( cFiIT)->( Eof())
             C_DPH->( dbSeek( (cFiIT)->nKlicDph))
             nNapocet := C_DPH->nNapocet
  *           nNapocet := SeekNapDPH( ( cFiIT)->nKlicDPH)
             DO CASE
               CASE nNapocet == 0 ;  nOsvOdDan  += ( cFiIT)->nCenZakCel
                                     nOsv_S     += ( cFiIT)->nCenZakCeD
               CASE nNapocet == 1 ;  nZaklDan_1 += ( cFiIT)->nCenZakCel
                                     nZakl1_S   += ( cFiIT)->nCenZakCeD
               CASE nNapocet == 2 ;  nZaklDan_2 += ( cFiIT)->nCenZakCel
                                     nZakl2_S   += ( cFiIT)->nCenZakCeD
             ENDCASE
             nCenZakCeD += ( cFiIT)->nCenZakCeD
             ( cFiIT)->( dbSkip())
           ENDDO

           ( cFiIT)->( dbGoTOP())
           IF ReplRec( cFiHD)

             IF lOldDPH     // DPH do 30.4.2004
               ( cFiHD)->nOsvOdDan   := nOsvOdDan
               ( cFiHD)->nZaklDan_1  := nZaklDan_1
               nSazba := SeekSazDPH( 1, ( cFiHD)->dPovinFAK)
               ( cFiHD)->nSazDan_1   := mh_RoundNumb( ( nZaklDan_1 / 100) * nSazba, nRoundDpH )
               ( cFiHD)->nZaklDan_2  := nZaklDan_2
               nSazba := SeekSazDPH( 2, ( cFiHD)->dPovinFAK)
               ( cFiHD)->nSazDan_2   := mh_RoundNumb( ( nZaklDan_2 / 100) * nSazba, nRoundDpH )

               ( cFiHD)->nCenDanCel  := nOsvOdDan + nZaklDan_1 + nZaklDan_2
               ( cFiHD)->nCenZakCel  := nOsvOdDan + nZaklDan_1 + nZaklDan_2 +;
                                        ( cFiHD)->nSazDan_1 + ( cFiHD)->nSazDan_2
               nCenZakCel           := ( cFiHD)->nCenZakCel
               ( cFiHD)->nCenZakCel := mh_RoundNumb( ( cFiHD)->nCenZakCel, ( cFiHD)->nKodZaokr)
               ( cFiHD)->nZustPoZao := ( cFiHD)->nCenZakCel - nCenZakCel
               ( cFiHD)->nCisUzv    := 0   // shození pøíznaku uzávìrky pøi opravì faktury
               ( cFiHD)->cZkrProdej := ( cFiIT)->cZkrProdej   // 24.5.2001
             ELSE            // DPH od 1.5.2004
               ( cFiHD)->nOsvOdDan   := nOsvOdDan
               ( cFiHD)->nCisUzv    := 0   //  shození pøíznaku uzávìrky pøi opravì faktury
               ( cFiHD)->cZkrProdej := ( cFiIT)->cZkrProdej   // 24.5.2001
  //              nZakl2_S += ( cFiHD)->nZustPoZao
               nSazba := SeekSazDPH( 1, ( cFiHD)->dPovinFAK)
               nKoefDPH := ROUND( nSazba / ( 100 + nSazba ), 4 )
               ( cFiHD)->nSazDan_1   := mh_RoundNumb( ( nKoefDPH * nZakl1_S ), nRoundDpH )
               ( cFiHD)->nZaklDan_1  := nZakl1_S - ( cFiHD)->nSazDan_1

               nSazba := SeekSazDPH( 2, ( cFiHD)->dPovinFAK)
               nKoefDPH := ROUND( nSazba / ( 100 + nSazba ), 4 )
               nHLP := ( nKoefDPH * nZakl2_S )
               ( cFiHD)->nSazDan_2   := mh_RoundNumb( ( nKoefDPH * nZakl2_S ), nRoundDpH )
               ( cFiHD)->nZaklDan_2  := nZakl2_S - ( cFiHD)->nSazDan_2
               // new
               (cFiHD) ->nCENzakCEL := (cFiHD) ->nOsvOdDan  + ;
                                       (cFiHD) ->nZaklDan_1 +(cFiHD) ->nSazDan_1 + ;
                                       (cFiHD) ->nZaklDan_2 +(cFiHD) ->nSazDan_2

               (cFiHD) ->nCENdanCEL := (cFiHD) ->nOSVodDAN  + ;
                                       (cFiHD) ->nZaklDan_1 +(cFiHD) ->nZaklDan_2

               (cFiHD) ->nZUSTpozao := (cFiHD) ->nCENdanCEL - ;
                                       ( nOsvOdDan + nZaklDan_1 + nZaklDan_2 )
             ENDIF

             ( cFiHD)->nCenZahCel  := ( cFiHD)->nCenZakCel
             ( cFiHD)->cZkratMenZ  := ( cFiHD)->cZkratMeny
             ( cFiHD)->nKurZahMen  := 1
             ( cFiHD)->cVypSazDan  := 'VYPSAZ_' + IIF( lOldDPH, '1', '2')
             ( cFiHD)->( dbUnlock())
           ENDIF
         ENDCASE
  *       nCountFAKT  := If( acTyp[ n] == 'FAKT ', dbCount( 'FakVysIt'), nCountFAKT  )
  *       nCountDODLS := If( acTyp[ n] == 'DODLS', dbCount( 'DodLstIt'), nCountDODLS )

         ( cFiIT)->( mh_ClrScope(), dbGoTOP() )
      ENDIF
    NEXT
  *  ( FakVysHd->( AdsSetOrder( cHdFA)), FakVysIt->( AdsSetOrder( cItFA)) )
    ( DodLstHd->( AdsSetOrder( cHdDL)), DodLstIt->( AdsSetOrder( cItDL)) )
    dbSelectArea( nArea)
  ENDIF
RETURN NIL   //( { nCountFAKT, nCountDODLS } )

* Promítnutí výdeje do DodLstIT
*===============================================================================
FUNCTION SKL_DodLstIT_Modi( nKey, cTypFak)
  Local  cIT := IF( cTypFak == 'DODLS', 'DODLSTIT', 'FAKVYSIT' )
  Local  cHD := IF( cTypFak == 'DODLS', 'DODLSTHD', 'FAKVYSHD' )
  Local  cKey, lOK := .F.

  IF PVPHead->nCisloDL <> 0
    *
    drgDBMS:open('OBJHEAD'  )
    drgDBMS:open('C_DPH'    )
    drgDBMS:open('FIRMYDA'  )
    drgDBMS:open('CENZB_NS' )
    drgDBMS:open( cHD)
    drgDBMS:open( cIT)
    *
    cKey := Upper( cTypFAK) + StrZero( PVPHEAD->nCisloDL,10)
    IF (cHD)->( dbSEEK( cKey,,AdsCtag(5)))
      DO CASE
        CASE ( nKey = xbeK_INS)
          lOK := AddREC( cIT)
        CASE ( nKey = xbeK_ENTER) .or. ( nKey = xbeK_DEL)
          cKey += StrZero( PVPItem->nOrdItem,5)
          IF ( cIT)->( dbSeek( cKey,,AdsCtag(4)))
            lOK := IF( nKey = xbeK_ENTER, ReplREC( cIT), .T. )
          EndIf
      ENDCASE
    ENDIF
    *
    IF lOK
      DO CASE
        CASE (nKey == xbeK_ENTER) .or. (nKey == xbeK_INS)
           mh_COPYFLD( cHD      , cIT )
           mh_COPYFLD( 'PVPITEM', cIT)
           ( cIT)->nDoklad      := ( cHD)->nDoklad
           ( cIT)->nCisloPVP    := ( cHD)->nCisloPVP
           ( cIT)->nCisFAK      := ( cHD)->nCisFAK
           ( cIT)->nIntCount    := PVPItem->nOrdItem
           ( cIT)->nFaktMnoz    := PVPItem->nMnozPrDod
           ( cIT)->nFaktMnKOE   := PVPItem->nMnozPrKOE
           ( cIT)->nCenaSZBO    := PVPItem->nCenNapDod

          DodLstIt->nCisFirmy  := PVPHead->nCisFirmy
          FirmyDA->( dbSeek( PVPHead->nCisFirmy,,'FIRMYDA1'))
          DodLstIt->nCisFirDoa := FirmyDA->nCisFirDoa
          IF CenZb_NS->( dbSeek( Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol),,'CENZBNS1'))
            DodLstIt->cNazPol1  := CenZb_Ns->cNazPol1
            DodLstIt->cNazPol2  := CenZb_Ns->cNazPol2
            DodLstIt->cNazPol3  := CenZb_Ns->cNazPol3
            DodLstIt->cNazPol4  := CenZb_Ns->cNazPol4
            DodLstIt->cNazPol5  := CenZb_Ns->cNazPol5
            DodLstIt->cNazPol6  := CenZb_Ns->cNazPol6
            DodLstIt->cUcet     := CenZb_Ns->cUcet
          ENDIF
*          DodLstIT->nRadVykDPH := RadVykDPH( PVPItem->nKlicDPH, DodLstHD->dPovinFAK, YES )  // 18.10.2004 JT

          ( cIT)->nCenJedZak  := PVPItem->nCenapZBO
          ( cIT)->nCenZakCel  := PVPItem->nCenapZBO * PVPItem->nMnozPrKOE
          ( cIT)->nSazDan     := ( ( cIT)->nCenZakCel / 100) * SeekKodDph( PVPItem->nKlicDph)
          ( cIT)->nCenJedZaD  := PVPItem->nCenapZBO * ;
                                  ( 1 + ( SeekKodDph( PVPItem->nKlicDph) / 100))

          ( cIT)->nCenZakCeD  := ( cIT)->nCenZakCel + ( cIT)->nSazDan
          ( cIT)->nCenZahCel  := ( cIT)->nCenZakCeD   // 29.4.2004
          ( cIT)->cCisObj     := IF( !EMPTY( ObjHead->cCisObj), ObjHead->cCisObj, ( cIT)->cCisObj )
    *?      ( cIT)->cDoplnTxt   := cDoplnTxt

           // Slevy
    ***       Slev_ToFile( cIT, 'PVPItem')

          * Nové ceny
          ( cIT)->nCeJPrZBZ  := ( cIT)->nCenaZakl
          ( cIT)->nCeJPrKBZ  := ( cIT)->nCenJedZAK
          ( cIT)->nCeJPrKDZ  := ( cIT)->nCenJedZaD
          ( cIT)->nCeCPrZBZ  := ( cIT)->nCenaZakC  //  IF( cIT == 'FAKVYSIT', ( cIT)->nCenaZakC, 0 )
          ( cIT)->nCeCPrKBZ  := ( cIT)->nCenZakCEL
          ( cIT)->nCeCPrKDZ  := ( cIT)->nCenZakCeD
          * a zpØt do PVPITEM
          PVPItem->nCeJPrZBZ  := ( cIT)->nCeJPrZBZ
          PVPItem->nCeJPrKBZ  := ( cIT)->nCeJPrKBZ
          PVPItem->nCeJPrKDZ  := ( cIT)->nCeJPrKDZ
          PVPItem->nCeCPrZBZ  := ( cIT)->nCeCPrZBZ
          PVPItem->nCeCPrKBZ  := ( cIT)->nCeCPrKBZ
          PVPItem->nCeCPrKDZ  := ( cIT)->nCeCPrKDZ

          ( cIT)->nKlicDPH     := PVPItem->nKlicDPH
          ( cIT)->( dbUnlock())
        CASE (nKey == xbeK_DEL)
          DelRec( cIT)
      ENDCASE
    ENDIF
  ENDIF
RETURN NIL

*
*-------------------------------------------------------------------------------
STATIC FUNCTION RadVykDPH( nKlicDPH, dPovinFAK, lDL)
  Local nCisRAD := 0, nSazba := SeekKodDPH( nKlicDPH)
  Local lStatEU

  DEFAULT lDL TO NO
  DO CASE
    CASE nSazba ==  5 ; IF dPovinFAK >= CTOD( '01.05.04')
                           nCisRAD := 215
                        ENDIF
    CASE nSazba == 19 ; nCisRAD := 210
    CASE nSazba == 0
      IF lDL
        lStatEU := FirmaIsEU( DodLstHD->cZkratSTAT)
        nCisRAD := IIF( DodLstHD->lIsZahr .AND.  lStatEU, 410,;
                   IIF( DodLstHD->lIsZahr .AND. !lStatEU, 430, 1))
      ELSE
        nCisRAD := 1
      ENDIF
  ENDCASE
RETURN nCisRAD

*
*-------------------------------------------------------------------------------
STATIC FUNCTION FirmaIsEU( cStat)
  Local lStatEU := NO

  drgDBMS:open( 'C_Staty',,,,, 'C_STATYa' )
  IF  C_STATYa->( dbSEEK( UPPER( cStat),,'C_STATY1'))
    lStatEU := ( C_STATYa->nMezEkoSes  == 1 )
  ENDIF
  C_STATYa->( dbCloseArea())
RETURN lStatEU