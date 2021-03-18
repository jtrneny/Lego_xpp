/*==============================================================================
  SKL_MODICEN.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  SKL_CenZboz_Modi ->  CenZboz_Modi       ModiCen.Prg
  SKL_SkladCENA    ->  SkladCENA          ModiCen.Prg
==============================================================================*/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

Static  cTypPohyb, cTypHead

* Modifikuje CENZBOZ dle typu pohybu
*===============================================================================
FUNCTION SKL_CenZboz_Modi( nKEY, nPrevod, fHD, fIN, fOU)
  Local  cKEY, aPrevod, nCho
  Local  nPos
  Local  lFound := .f., lPrevod, lCenaPRU

  DEFAULT fHD TO "PVPHead"
  DEFAULT fIN TO "PVPItemw"
  DEFAULT fOU TO "PVPItem"

  nPos := ASCAN( { 110, 117, 120 }, (fHD)->nKarta)

  cTypPohyb := IIF( nPrevod == 80, VYDEJ ,;
               IIF( nPrevod == 40, PRIJEM,;
               Left( StrZero( (fHD)->nKarta, 3), 1 ) ))
*  cTypHead  := SubStr( Str( (fHD)->nKarta), 2, 1 )
  cTypHead  := SubStr( StrZero( (fHD)->nKarta, 3), 2, 1 )

  Do Case
    ************************
    Case cTypPohyb == PRIJEM
      Do Case
        Case nKey == xbeK_INS    // Novy prijem
          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz')
            If Upper( CenZboz->cPolCen) == 'C'
               CenZboz->nMnozsZBO += (fOU)->nMnozPrDOD

               If (fOU)->nMnozPrDOD < 0 .and. Upper( CenZboz->cTypSklCen) == 'PRU'   // pý¡jem minusem
                 CenZboz->nMnozsZBO := MAX( 0, CenZboz->nMnozsZbo)
               EndIf

               (fOU)->nMnozsZBO := CenZboz->nMnozsZBO

               If cTypHead == '0' .or. cTypHead == '4'
*               If cTypHead $ '0,1,2,3,4'
                 CenZboz->nCenacZBO += (fOU)->nCenaCelk
                 CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU)
                 (fOU)->nCenacZBO := CenZboz->nCenacZBO
               EndIf

               If !Empty( (fOU)->cCisObj)
                 CenZboz->nMnozdZBO += ( (fOU)->nMnozPrDod - (fOU)->nMnozVyObj )
                 CenZboz->nMnozRZBO += (fOU)->nMnozVyObj
               Else
                 CenZboz->nMnozdZBO += (fOU)->nMnozPrDod
               EndIf

               CenZboz->nMnozdZbo := MAX( 0, CenZboz->nMnozdZbo )
               CenZboz->nCenasVZM := CenZboz->nCenasZBO    // * KURZ     !!!!!!!!!
               CenZboz->nCenanZBO := IF( nPos <> 0, (fOU)->nCenNapDOD, CenZboz->nCenanZBO)
               CenZboz->nCenaKurz := CenZboz->nCenanZBO  // * KURZ     !!!!!!!!!
            Else

               CenZboz->nMnozsZBO += (fOU)->nMnozPrDOD
               (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
               CenZboz->nMnozdZBO += (fOU)->nMnozPrDod
            EndIf
            
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())   //  DCrUnlock( 'CenZboz' )


        Case nKey ==  xbeK_ENTER    // Oprava prijmu

          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz' )
            If Upper( CenZboz->cPolCen) == 'C'
               CenZboz->nMnozsZBO += (fOU)->nMnozPrDOD - (fIN)->nMnozPrDOD
               If (fOU)->nMnozPrDOD < 0 .and.  ;
                  Upper( CenZboz->cTypSklCen) == 'PRU'   // pý¡jem minusem
                 CenZboz->nMnozsZBO := MAX( 0, CenZboz->nMnozsZbo )
               EndIf
               (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
               If cTypHead == '0' .or. cTypHead == '4'
*               If cTypHead $ '0,1,2,3,4'
                 CenZboz->nCenacZBO += (fOU)->nCenaCelk  - (fIN)->nCenaCelk
                 (fOU)->nCenacZBO := CenZboz->nCenacZBO
                 CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU )
               EndIf
               If !Empty( (fOU)->cCisObj)
                 CenZboz->nMnozdZBO += - ( (fIN)->nMnozPrDOD - (fIN)->nMnozVyObj ) +;
                                         ( (fOU) ->nMnozPrDod - (fOU) ->nMnozVyObj )
                 CenZboz->nMnozRZBO += - (fIN)->nMnozVyObj + (fOU)->nMnozVyObj
               Else
                 CenZboz->nMnozdZBO +=  - (fIN)->nMnozPrDOD + (fOU)->nMnozPrDod
               EndIf
               CenZboz->nMnozdZbo :=  MAX( 0, CenZboz->nMnozdZbo )
               // CenZboz->nCenanZBO := (fOU)->nCenNapDOD
               CenZboz->nCenanZBO := IF( nPos <> 0, (fOU)->nCenNapDOD, CenZboz->nCenanZBO)
               CenZboz->nCenasVZM := CenZboz->nCenasZBO  // * KURZ     !!!!!!!!!
            Else
               CenZboz->nMnozsZBO += - (fIN)->nMnozPrDOD + (fOU)->nMnozPrDOD
               (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
               CenZboz->nMnozdZBO += - (fIN)->nMnozPrDOD + (fOU)->nMnozPrDOD
            EndIf
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())    //      DCrUnlock( 'CenZboz' )

*
        Case nKey == xbeK_DEL     // Zruçen¡ pý¡jmu

          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz' )
            If Upper( CenZboz->cPolCen) == 'C'
              CenZboz->nMnozsZBO -= (fOU)->nMnozPrDOD
              If Upper( CenZboz->cTypSklCen) == 'PRU'
                CenZboz->nMnozsZBO := MAX( 0, CenZboz->nMnozsZBO )
              Endif
              If cTypHead == '0' .or. cTypHead == '4'
*              If cTypHead $ '0,1,2,3,4'
                CenZboz->nCenacZBO -= (fOU)->nCenaCelk
                CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU )
              EndIf
              If !Empty( (fOU)->cCisObj)
                CenZboz->nMnozdZBO += - ( (fOU)->nMnozPrDOD - (fOU)->nMnozVyObj )
                CenZboz->nMnozRZBO += - (fOU)->nMnozVyObj
              Else
                CenZboz->nMnozdZBO += - (fOU)->nMnozPrDOD
              EndIf
              CenZboz->nMnozdZbo := MAX( 0, CenZboz->nMnozdZbo )
              CenZboz->nCenasVZM := CenZboz->nCenasZBO  // * KURZ     !!!!!!!!!
            Else
              CenZboz->nMnozsZBO -= (fOU)->nMnozPrDOD
 //               (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
              CenZboz->nMnozdZBO -= (fOU)->nMnozPrDOD
            EndIf
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())   // DCrUnlock( 'CenZboz' )
        EndCase

        If nPrevod == 40 .or. cTypHead == '0' .or. cTypHead == '4'
**          SKL_PVPKumul_Modi( nKey, cTypPohyb )
        EndIf

    ***********************
    Case cTypPohyb == VYDEJ
      Do Case
        Case nKey == xbeK_INS     // Nový výdej
          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz')
            If Upper( CenZboz->cPolCen) == 'C'
              If Upper( CenZboz->cTypSklCen) == 'PRU' .and. CenZboz->nMnozsZBO <= (fOU)->nMnozPrDOD
                (fOU)->nCenaCelk   := CenZboz->nCenacZBO
                (fOU)->nRozdilPoh  := CenZboz->nCenacZBO - ( (fOU)->nMnozPrDOD * (fOU)->nCenNapDod ) //20.4.07
                CenZboz->nMnozsZBO := CenZboz->nCenacZBO := 0
                (fOU)->nMnozsZBO    := (fOU)->nCenacZBO := 0

              Else
                (fOU)->nCenaCelk := Round( (fOU)->nMnozPrDOD * (fOU)->nCenNapDOD, 2)
                CenZboz->nMnozsZBO -= (fOU)->nMnozPrDOD
                (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
                CenZboz->nCenacZBO -= (fOU)->nCenaCelk
                (fOU)->nCenacZBO := CenZboz->nCenacZBO
                If (fOU)->nCenaCelk < 0
                  CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU )
                EndIf
              EndIf

              IF (fOU)->nMnozPrDod > 0
                If (fOU)->nMnozReODB > 0
                  CenZboz->nMnozrZBO  -= If( (fOU)->nMnozPrDOD > (fOU)->nMnozReODB,;
                                             (fOU)->nMnozReODB, (fOU)->nMnozPrDOD )
                  CenZboz->nMnozrZBO  := MAX( 0, CenZboz->nMnozrZBO )
                  y :=  (fOU)->nMnozPrDOD - (fOU)->nMnozReODB
                  IF y > 0
                    CenZboz->nMnozdZBO  -= y
                  ENDIF
                  y := CenZboz->nMnozdZBO - CenZboz->nMnozsZBO
                  If y > 0
                    CenZboz->nMnozdZBO  -= y
                    (fOU)->nMnozZObje := y  /// !!!!!!!!!
                  Endif
                Else
                  CenZboz->nMnozdZBO -= (fOU)->nMnozPrDod
                EndIf
              Else
                CenZboz->nMnozdZBO -= (fOU)->nMnozPrDod
              Endif
              CenZboz->nMnozdZBO := MAX( 0, CenZboz->nMnozdZBO )
              If (fOU)->nMnozKObje > 0
                //CenZboz->nMnozKZBO  -= If( (fOU)->nMnozPrDOD > (fOU)->nMnozKobje,;
                //                            (fOU)->nMnozKobje, (fOU)->nMnozPrDOD )
                CenZboz->nMnozKZBO  -= If( (fOU)->nMnozPrDOD - (fOU)->nMnozReOdb > 0,;
                (fOU)->nMnozPrDOD - (fOU)->nMnozReOdb, 0 )
                CenZboz->nMnozKZBO  :=  MAX( 0, CenZboz->nMnozKZBO)
              Endif
              CenZboz->nCenasVZM := CenZboz->nCenasZBO    // * KURZ     !!!!!!!!!
            Else
              CenZboz->nMnozsZBO -= (fOU)->nMnozPrDOD
              (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
              CenZboz->nMnozdZBO -= (fOU)->nMnozPrDod
            EndIf
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())


        Case nKey == xbeK_ENTER      // Oprava výdeje

          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz' )
            If Upper( CenZboz->cPolCen) == 'C'
              CenZboz->nMnozsZBO += (fIN)->nMnozPrDOD
              CenZboz->nCenacZBO += (fIN)->nCenaCelk
              If Upper( CenZboz->cTypSklCen) == 'PRU' .and. ;
                 CenZboz->nMnozsZBO <= (fOU)->nMnozPrDOD
                (fOU)->nCenaCelk   := CenZboz->nCenacZBO
                (fOU)->nRozdilPoh  := CenZboz->nCenacZBO - ( (fOU)->nMnozPrDOD * (fOU)->nCenNapDod ) //20.4.07
                CenZboz->nMnozsZBO := CenZboz->nCenacZBO := 0
                (fOU)->nMnozsZBO   := (fOU)->nCenacZBO := 0
              Else
                CenZboz->nMnozsZBO -= (fOU)->nMnozPrDOD
                (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
                CenZboz->nCenacZBO -= (fOU)->nCenaCelk
                (fOU)->nCenacZBO := CenZboz->nCenacZBO
              EndIf
              IF (fOU)->nMnozPrDod > 0
                If (fOU)->nMnozReODB > 0
                  CenZboz->nMnozrZBO  += If( (fIN)->nMnozPrDOD > (fIN)->nMnozReODB ,;
                                             (fIN)->nMnozReODB, (fIN)->nMnozPrDOD )
                  CenZboz->nMnozrZBO  -= If( (fOU)->nMnozPrDOD > (fOU)->nMnozReODB,;
                                             (fOU)->nMnozReODB, (fOU)->nMnozPrDOD )
                  CenZboz->nMnozrZBO := MAX( 0, CenZboz->nMnozrZBO )
                  y := (fOU)->nMnozPrDOD - (fOU)->nMnozReODB
                  z := (fIN)->nMnozPrDOD - (fIN)->nMnozReODB
                  CenZboz->nMnozdZBO  += IF( z > 0, z, 0 ) - IF( y > 0, y, 0)

                  y := CenZboz->nMnozdZBO + (fIN)->nMnozZObje - CenZboz->nMnozsZBO
                  If y > 0  ;  If CenZboz->nMnozdZBO == 0
                                 CenZboz->nMnozdZBO := (fIN)->nMnozZObje
                               EndIf
                               CenZboz->nMnozdZBO  -= y
                               (fOU)->nMnozZObje := y
                  Else      ;  CenZboz->nMnozdZBO  += (fIN)->nMnozZObje
                               (fOU)->nMnozZObje := 0
                  Endif
                Else
                  CenZboz->nMnozdZBO += (fIN)->nMnozPrDOD - (fOU)->nMnozPrDOD
                EndIf
              ELSE
                CenZboz->nMnozdZBO += (fIN)->nMnozPrDOD - (fOU)->nMnozPrDOD
              ENDIF
              CenZboz->nMnozdZBO := MAX( 0, CenZboz->nMnozdZBO )
              If (fOU)->nMnozKobje > 0
                CenZboz->nMnozKZBO += (fOU)->nMnozKobje - (fOU)->nMnozPrDOD
                CenZboz->nMnozKZBO := MAX( 0, CenZboz->nMnozKZBO )
              EndIf
              If (fOU)->nCenaCelk < 0
                 CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU )
              EndIf
              CenZboz->nCenasVZM := CenZboz->nCenasZBO  // * KURZ     !!!!!!!!!
            Else
              CenZboz->nMnozsZBO += (fIN)->nMnozPrDOD - (fOU)->nMnozPrDOD
              (fOU)->nMnozsZBO := CenZboz->nMnozsZBO
              CenZboz->nMnozdZBO += (fIN)->nMnozPrDOD - (fOU)->nMnozPrDOD
            EndIf
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())


        Case nKey == xbeK_DEL     // Zrušení výdeje

          cKey := Upper( (fOU)->cCisSklad) + Upper( (fOU)->cSklPol)
          If ( lFound := CenZboz->( dbSeek( cKey,,'CENIK03')) ) .and. ReplRec( 'CenZboz' )
            lCenaPRU := ( Upper( CenZboz->cTypSklCen) == 'PRU' )
            nOldMnozS := CenZboz->nMnozsZBO
            If Upper( CenZboz->cPolCen) == 'C'
              CenZboz->nMnozsZBO += (fOU)->nMnozPrDOD
              CenZboz->nMnozsZBO := IF( lCenaPRU, CenZboz->nMnozsZbo, MAX( 0, CenZboz->nMnozsZbo))
              CenZboz->nCenacZBO += (fOU)->nCenaCelk
              If (fOU)->nMnozPrDOD > 0
                If (fOU)->nMnozReODB > 0
                  CenZboz->nMnozrZBO  += If( (fOU)->nMnozPrDOD > (fOU)->nMnozReODB ,;
                                             (fOU)->nMnozReODB, (fOU)->nMnozPrDOD )
                  CenZboz->nMnozrZBO := MAX( 0, CenZboz->nMnozrZBO )

                  y :=  (fOU)->nMnozPrDOD - (fOU)->nMnozReODB
                  CenZboz->nMnozdZBO  += IF( y > 0, y, 0 )

                  CenZboz->nMnozdZBO += IIF( lCenaPRU, (fOU)->nMnozZObje ,;
                                        IIF( nOldMnozS < 0, 0, (fOU)->nMnozZObje ))
                Else
                  CenZboz->nMnozdZBO += IIF( lCenaPRU, (fOU)->nMnozPrDOD ,;
                                        IIF( nOldMnozS < 0, 0, (fOU)->nMnozPrDOD ))
                EndIf
              ELSE
                CenZboz->nMnozdZBO += IIF( lCenaPRU, (fOU)->nMnozPrDOD ,;
                                      IIF( nOldMnozS < 0, 0, (fOU)->nMnozPrDOD ))
              ENDIF
              CenZboz->nMnozdZBO := IIF( lCenaPRU, MAX( 0, CenZboz->nMnozdZBO),;
                                    IIF( nOldMnozS < 0, CenZboz->nMnozDZBO ,;
                                                        CenZboz->nMnozdZBO ))
              If (fOU)->nMnozKobje > 0
                CenZboz->nMnozKZBO +=  (fOU)->nMnozKObje
                CenZboz->nMnozKZBO := MAX( 0, CenZboz->nMnozKZBO )
              EndIf
              If (fOU)->nCenaCelk < 0
                CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, fOU )
              EndIf
              CenZboz->nCenasVZM := CenZboz->nCenasZBO  // * KURZ     !!!!!!!!!
            Else
              CenZboz->nMnozsZBO += (fOU)->nMnozPrDOD
              CenZboz->nMnozdZBO += (fOU)->nMnozPrDOD
            EndIf
            CenZboz->dDatpZBO  := (fOU)->dDatPVP
          EndIf
          CenZboz->( dbUnlock())
        EndCase

**        SKL_PVPKumul_Modi( nKey, cTypPohyb )
  ENDCASE

RETURN( lPrevod )

* Dle typu ceny stanoví SKLADOVOU CENU
*===============================================================================
FUNCTION SKL_SkladCENA( cTyp, file)
  Local nCenas, nRound := 4 //  DecCenaS()

  Default file To "PVPItem"

  Do Case
    Case Upper( cTyp) == 'PEV'
      nCenas := (file)->nCenNapDOD
    Case Upper( cTyp) == 'PRU'
      nCenas := If( CenZboz->nCenacZBO <> 0 .and. CenZboz->nMnozsZBO <> 0   ,;
                    Round( CenZboz->nCenacZBO / CenZboz->nMnozsZBO, nRound ),;
                    CenZboz->nCenasZBO )
    OtherWise
      nCenas  := CenZboz->nCenasZBO
  EndCase
Return( nCenas)