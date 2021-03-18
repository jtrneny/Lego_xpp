#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


# DEFINE    COMPILE(c)         &("{||" + c + "}")
//# TRANSLATE SET_filter(<c>) => ( ORDsetFOCUS(0), dbSETFILTER( COMPILE(<c>)), dbGOTOP() )


// ----------------- Vrátí procento odvodu pro soc.pojištìní za pracovníka -----
FUNCTION fOdvSocZA( nIt)
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocZa")

RETURN( Val( mh_Token( cX, ",", nIt)))


// ----------------- Vrátí procento odvodu pro soc.pojištìní za organizaci -----
FUNCTION fOdvSocOR( nIt)
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocOr")

RETURN( Val( mh_Token( cX, ",", nIt)))


// ----------------- Vrátí pole procent odvodu pro soc.pojištìní za organizaci -
FUNCTION faOdvSocOR()
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocOr")
  LOCAL aX := { 0, 0, 0 }
  LOCAL n

  FOR n := 1 TO 3      ; aX[n] := Val( mh_Token( cX, ",", n))
  NEXT

RETURN( aX)

// ----------------- Vrátí pole procent odvodu pro soc.pojištìní za pracovn. ---
FUNCTION faOdvSocZA()
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocZa")
  LOCAL aX := { 0, 0, 0 }
  LOCAL n

  FOR n := 1 TO 3      ; aX[n] := Val( mh_Token( cX, ",", n))
  NEXT

RETURN( aX)


// ----------------- Vrátí datum narození z rodného èísla ----------------------
FUNCTION fDATzRC( cRodCi)
  LOCAL cMes, cDatum

  cRodCi := StrTran( AllTrim( cRodCi), "/", "")
  cRodCi := StrTran( AllTrim( cRodCi), "-", "")

  DO CASE
  CASE  SubStr( cRodCi, 3, 1 ) = '5'
    cMes := '0'
  CASE  Substr( cRodCi, 3, 1 ) = '6'
    cMes := '1'
  OTHERWISE
    cMes := Substr( cRodCi, 3, 1 )
  ENDCASE

  IF cRodCi <> ' '
    cDatum := Substr( cRodCi, 5, 2 ) + '.' + cMes + Substr( cRodCi, 4, 1 ) + ;
                 + '.' + Substr( cRodCi, 1, 2 )
  ELSE
    cDatum := '  .  .  '
  ENDIF

RETURN( CToD( cDatum))


// ----------------- Fomátování rodného èásla do tvaru xxxxxx/xxxx -------------
FUNCTION fFORMcRC( cRC)

  IF cRC <> "  "
    cRC := SubStr( lTrim( cRC), 1, 6) +"/"  +SubStr(lTrim( cRC), 7, 4)
  ELSE
    cRC := "           "
  ENDIF

RETURN( Padr( cRC, 11, " "))


// ----------------- Odstranìní znakù z rodného èísla --------------------------
FUNCTION fFORMnRC( cRC)

  cRC := StrTran( cRC, "-", "")
  cRC := StrTran( cRC, "/", "")

RETURN( cRC)


FUNCTION POSdenOBD( nROK, nOBDOBI)
        LOCAL  aRETURN := { 0, CtoD( "  /  /  ")}

  aRETURN[1] := mh_LastDayOM( CtoD( "01/" +Str( nOBDOBI, 2) +"/" +Str( nROK, 4)))
  aRETURN[2] := CtoD( Str( aRETURN[1], 2) +"/" +Str( nOBDOBI, 2) +"/"         ;
                             +Str( nROK, 4))
RETURN( aRETURN)


// ----------------- Výpoèet zálohové danì -------------------------------------
FUNCTION fDanVypRo( nVal)
  LOCAL nRetVal := 0, nDan := 0

  IF nVal > 0
    IF nVal <= 100          ;   nVal := Round( nVal + 0.49, 0)
    ELSE                    ;   nVal := ( Round( nVal/100 + 0.49, 0 ) ) * 100
    ENDIF

    DO CASE
    CASE  uctOBDOBI:MZD:nROK == 2000
      DO CASE
      CASE nVal <=  102000  ;   nDan := nVal * 0.15
      CASE nVal <= 204000   ;   nDan := 15300 + (( nVal - 102000) * 0.20)
      CASE nVal <= 312000   ;   nDan := 35700 + (( nVal - 204000) * 0.25)
      OTHERWISE             ;   nDan := 62700 + (( nVal - 312000) * 0.32)
      ENDCASE
    CASE  uctOBDOBI:MZD:nROK == 2001 .OR. uctOBDOBI:MZD:nROK == 2002                    ;
           .OR. uctOBDOBI:MZD:nROK == 2003 .OR. uctOBDOBI:MZD:nROK == 2004              ;
            .OR. uctOBDOBI:MZD:nROK == 2005
      DO CASE
      CASE nVal <= 109200   ;   nDan := nVal * 0.15
      CASE nVal <= 218400   ;   nDan := 16380 +(( nVal - 109200) * 0.20)
      CASE nVal <= 331200   ;   nDan := 38220 +(( nVal - 218400) * 0.25)
      OTHERWISE             ;   nDan := 66420 +(( nVal - 331200) * 0.32)
      ENDCASE
    ENDCASE
    nRetVal := Round( nDan + 0.49, 0)
  ENDIF

RETURN( nRetVal)


// ----------------- Zjištìní pracovní doby pracovníka -------------------------
FUNCTION fPracDOBA( cDOBA)
  LOCAL aRET := { 0, 0, 0 }
  LOCAL cTAG

  drgDBMS:open('C_PRACDO')

  DEFAULT cDOBA TO MSPRC_MO->cDelkPrDob

  IF Empty( cDOBA)
    aRET[1] := SysConfig( "Mzdy:nDnyPrcTyd")
    aRET[2] := SysConfig( "Mzdy:nDelPrcTyd")
    aRET[3] := SysConfig( "Mzdy:nDelPrcTyd")/SysConfig( "Mzdy:nDnyPrcTyd")
  ENDIF

  cTAG := C_PRACDO->( OrdSetFOCUS( 1))
  IF C_PRACDO->( dbSeek( Upper( cDOBA)))
    aRET[1] := C_PRACDO->nDnyTyden
    aRET[2] := C_PRACDO->nHodTyden
    aRET[3] := C_PRACDO->nHodDen
  ENDIF
  C_PRACDO->( OrdSetFOCUS( cTAG))

RETURN( aRET)


// ----------------- Zjištìní pøednastavených sazeb pro tarify -----------------
FUNCTION fSazTAR( dDATUM)
  LOCAL aRET := { 0, 0 }
  LOCAL cTAG
  LOCAL xKEYod, xKEYdo

  DEFAULT dDATUM TO Date()   //   cTOd( "  /  /    " )

  drgDBMS:open('MSTARHRO')
  drgDBMS:open('MSTARIND')

  DO CASE
  CASE MSPRC_MO->cTypTarPou == "HROMADNY"     ;
         .OR. MSPRC_MO ->cTypTarPou == "INDIVIDU"
    cTAG   := MsTarInd ->( OrdSetFOCUS())
    xKEYod := StrZero( MSPRC_MO ->nOsCisPrac) +StrZero( MSPRC_MO ->nPorPraVzt) ;
               +DtoS( CtoD( "01/01/2001"))
    xKEYdo := StrZero( MSPRC_MO ->nOsCisPrac) +StrZero( MSPRC_MO ->nPorPraVzt) ;
               +DtoS( dDATUM)
    MSTARIND->( OrdSetFOCUS(4),                                                ;
                ADS_SetScope( SCOPE_TOP, xKEYod),                              ;
                ADS_SetScope( SCOPE_BOTTOM, xKEYdo),                           ;
                dbGoBotTom())

     aRET[1] := MSTARIND->nTarSazHod
     aRET[2] := MSTARIND->nTarSazMes

    MSTARIND->( ADS_ClearScope( SCOPE_TOP),                                    ;
                ADS_ClearScope( SCOPE_BOTTOM),                                 ;
                OrdSetFOCUS(cTAG))

    IF MSPRC_MO ->cTypTarPou == "HROMADNY"
      cTAG   := MSTARHRO->( OrdSetFOCUS())
      xKEYod := Upper( MSTARIND->cTarifTrid) +Upper( MSTARIND->cTarifStup);
                 +Upper( MSTARIND->cDelkPrDob) +DtoS( CtoD( "01/01/2001"))
      xKEYdo := Upper( MSTARIND->cTarifTrid) +Upper( MSTARIND->cTarifStup);
                 +Upper( MSTARIND->cDelkPrDob) +DtoS( dDATUM)
      MSTARHRO->( OrdSetFOCUS(2),                                              ;
                  ADS_SetScope( SCOPE_TOP, xKEYod),                            ;
                  ADS_SetScope( SCOPE_BOTTOM, xKEYdo),                         ;
                  dbGoBotTom())

       aRET[1] := MSTARHRO->nTarSazHod
       aRET[2] := MSTARHRO->nTarSazMes

      MSTARHRO->( ADS_ClearScope( SCOPE_TOP),                                  ;
                  ADS_ClearScope( SCOPE_BOTTOM),                               ;
                  OrdSetFOCUS(cTAG))
    ENDIF
  OTHERWISE
    aRET[1] := MSPRC_MO->nTarSazHod
    aRET[2] := MSPRC_MO->nTarSazMes
  ENDCASE

RETURN( aRET)


// ----------------- Zjištìní pøednastavených sazeb pracovníka------------------
FUNCTION fSazZAM( dDATUM)
  LOCAL aRET := { 0, 0, 0, 0 }
  LOCAL cTAG
  LOCAL xKEYod, xKEYdo

  DEFAULT dDATUM TO Date()        // cTOd( "  /  /    " )

  drgDBMS:open('MSSAZZAM')

  cTAG   := MSSAZZAM->( OrdSetFOCUS())
  xKEYod := StrZero( MSPRC_MO->nOsCisPrac) +StrZero( MSPRC_MO->nPorPraVzt)     ;
             +Upper( MSPRC_MO->cDelkPrDob) +DtoS( CtoD( "01/01/2001"))
  xKEYdo := StrZero( MSPRC_MO->nOsCisPrac) +StrZero( MSPRC_MO->nPorPraVzt)           ;
             +Upper( MSPRC_MO->cDelkPrDob) +DtoS( dDATUM)

  MSSAZZAM->( OrdSetFOCUS(2),                                                  ;
              ADS_SetScope( SCOPE_TOP, xKEYod),                                ;
              ADS_SetScope( SCOPE_BOTTOM, xKEYdo),                             ;
              dbGoBotTom())

   IF !MSSAZZAM ->( Eof()) .AND. !Empty( dDATUM)
     MSSAZZAM ->( dbGoBotTom())
     aRET[1] := MSSAZZAM ->nSazPrePr
     aRET[2] := MSSAZZAM ->nSazOsoOh
     aRET[3] := MSSAZZAM ->nSazPodHVP
     aRET[4] := MSSAZZAM ->nHodPovPre
   ELSE
     aRET[1] := MSPRC_MO ->nSazPrePr
     aRET[2] := MSPRC_MO ->nSazOsoOh
     aRET[3] := MSPRC_MO ->nSazPodHVP
     aRET[4] := MSPRC_MO ->nHodPovPre
   ENDIF
  MSSAZZAM->( ADS_ClearScope( SCOPE_TOP),                                      ;
              ADS_ClearScope( SCOPE_BOTTOM),                                   ;
              OrdSetFOCUS(cTAG))

RETURN( aRET)

// ----------------- Celé jméno pracovníka pro tøídìní--------------------------
FUNCTION cPRACsort( cALIAS)
 LOCAL cRET

 cRET := Left( ( cALIAS)->cPracovnik, 25) +StrZero( ( cALIAS)->nOsCisPrac, 5)
            +StrZero( ( cALIAS)->nPorPraVzt, 3)

RETURN( cRET)




// ----------------- Pomocné støedisko - závod --------------------------------
FUNCTION TMPkmenSTR( cKmenStr)
  LOCAL cRET := ""
  LOCAL nTYP := SysConfig( "Mzdy:nPlnTMkmSt")

  DO CASE
  CASE nTYP == 1   ;   cRET := Left( AllTrim( cKmenStr), 2) + "000"
  ENDCASE

RETURN( cRET)

// ----------------- Vìk pracovníka k danému datumu ----------------------------
FUNCTION fVEKzDATE( dNAROZ, dKDATE)
  LOCAL  nVEK
  LOCAL  cX1, cX2, cX3
  LOCAL  cROK, dDAT

  DEFAULT dKDATE TO Date()

  nVEK := Year( dKDATE) - Year( dNAROZ)
  cROK := Str( Year( dKDATE))
  dDAT := CtoD( Str( Day( dNAROZ)) +"." +Str( Month( dNAROZ)) +"." +cROK)

  nVEK := IF( dDAT < dKDATE, nVEK, nVEK-1)
  nVEK := IF( nVEK < 0,   0, nVEK)
  nVEK := IF( nVEK > 130, 0, nVEK)

RETURN( nVEK)


// ----------------- Pøepoèet stavu pracovníkù ---------------------------------
FUNCTION EvidPocPrac( cALIAS, nROK, nOBD)
  LOCAL  dFIRSTobd
  LOCAL  dLASTobd
  LOCAL  nPosDenOBD
  LOCAL  nPracDoba
  LOCAL  nPrDoZa := fPracDOBA( ( cALIAS) ->cDelkPrDob)[3]
  LOCAL  nX
  LOCAL  cRok, cObdobi
  LOCAL  nRokTm, nObdobiTm

  nRokTm    := IF( cALIAS == "MsPrc_Mo", MsPrc_Mo->nRok,    uctOBDOBI:MZD:nROK)
  nObdobiTm := IF( cALIAS == "MsPrc_Mo", MsPrc_Mo->nObdobi, uctOBDOBI:MZD:nOBDOBI)

  DEFAULT nROK TO nRokTm
  DEFAULT nOBD TO nObdobiTm

  cRok       := StrZero( nROK, 4)
  cObdobi    := StrZero( nOBD, 2)
  nPosDenOBD := mh_LastDayOM( cTod("01/" +cObdobi +"/" +cRok))
  dFIRSTobd  := cTod( "01/" +cObdobi +"/" +cRok)
  dLASTobd   := cTod( StrZero( nPosDenOBD, 2) +"/" +cObdobi +"/" +cRok)
  nPracDoba  := Round( SysConfig( "Mzdy:nDelPrcTyd")/SysConfig( "Mzdy:nDnyPrcTyd"), 2)

  (cALIAS)->lStavem := IF( Empty( (cALIAS)->dDatVyst), .T.                                 ;
                        , IF( Year( (cALIAS)->dDatVyst) > uctOBDOBI:MZD:nROK, .T.          ;
                         , IF( Month( (cALIAS)->dDatVyst) >= uctOBDOBI:MZD:nOBDOBI .AND.   ;
                                Year( (cALIAS)->dDatVyst) = uctOBDOBI:MZD:nROK, .T., .F.)))
  IF (cALIAS) ->nMimoPrVzt == 0
    (cALIAS) ->nFyzStavKo := IF((!Empty( (cALIAS) ->dDatNast)                      ;
                                  .AND. (cALIAS) ->dDatNast <= dLASTobd)           ;
                                   .AND. ( Empty( (cALIAS) ->dDatVyst)             ;
                                            .OR. (cALIAS) ->dDatVyst >= dLASTobd)  ;
                                            , 1, 0)
    IF (cALIAS)->nFyzStavKo == 1
      (cALIAS)->nFyzStavOb := 1
    ELSE
      ( cALIAS)->nFyzStavOb := IF( ( !Empty( (cALIAS)->dDatNast)                   ;
                                      .AND. (cALIAS)->dDatNast <= dLASTobd)        ;
                                        .AND. ( Empty( (cALIAS)->dDatVyst)       ;
                                                 .OR. ( ( cALIAS)->dDatVyst >= dFIRSTobd          ;
                                                           .AND. (cALIAS)->dDatVyst < dLASTobd))  ;
                                                               , 1, 0)
    ENDIF
    DO CASE
    CASE (cALIAS)->dDatNast < dFIRSTobd .AND. ( Empty( (cALIAS)->dDatVyst)     ;
           .OR. (cALIAS)->dDatVyst >= dLASTobd)
      (cALIAS)->nFyzStavPr := 1
      (cALIAS)->nPreStavPr := PrepSTAV(1,nPracDoba,nPrDoZa)
    CASE (cALIAS)->dDatNast < dFIRSTobd .AND. ( Empty( (cALIAS)->dDatVyst)     ;
           .OR. (cALIAS)->dDatVyst >= dFIRSTobd)
      nX := ((cALIAS)->dDatVyst - dFIRSTobd) +1
      (cALIAS)->nFyzStavPr := Round( nX /nPosDenOBD, 2)
      (cALIAS)->nPreStavPr := PrepSTAV( (cALIAS)->nFyzStavPr, nPracDoba, nPrDoZa)
    CASE ( cALIAS)->dDatNast >= dFIRSTobd .AND. (Empty((cALIAS)->dDatVyst)     ;
           .OR. (cALIAS)->dDatVyst >= dLASTobd)
      nX := ( nPosDenOBD - Day( (cALIAS)->dDatNast)) +1
      (cALIAS)->nFyzStavPr := Round( nX /nPosDenOBD, 2)
      (cALIAS)->nPreStavPr := PrepSTAV( (cALIAS)->nFyzStavPr, nPracDoba, nPrDoZa)
    CASE (cALIAS) ->dDatNast >= dFIRSTobd .AND. (cALIAS) ->dDatVyst < dLASTobd
      nX := ( Day( (cALIAS)->dDatVyst) - Day( (cALIAS)->dDatNast)) +1
      (cALIAS)->nFyzStavPr := Round( nX/nPosDenOBD, 2)
      (cALIAS)->nPreStavPr := PrepSTAV( (cALIAS)->nFyzStavPr, nPracDoba, nPrDoZa)
    OTHERWISE
      (cALIAS)->nFyzStavPr := 0
      (cALIAS)->nPreStavPr := 0
    ENDCASE
  ELSE
    (cALIAS)->nFyzStavKo := 0
    (cALIAS)->nFyzStavOb := 0
    (cALIAS)->nFyzStavPr := 0
    (cALIAS)->nPreStavPr := 0
  ENDIF
  (cALIAS)->nVekZamest := fVEKzDATE( fDATzRC( (cALIAS)->cRodCisPRA), mh_LastODate( nRok, nObd))
  (cALIAS)->nObdNarZam := Month( fDATzRC( (cALIAS)->cRodCisPRA))

RETURN( NIL)


// ----------------- Pøepoèet stavu pracovníkù ---------------------------------
FUNCTION PrepSTAV( nX, nPracDoba, nPrDobaPra)
RETURN( IF( nPracDoba < nPrDobaPra, Round( nPrDobaPra/nPracDoba, 2), nX))

// ----------------- Vrátí ètvrtletí k aktuálnímu období------------------------
FUNCTION MZD_ACTCtvrt()
RETURN( mh_CTVRTzOBDn( uctOBDOBI:MZD:nOBDOBI))


// ----------------- Vrátí poslední otevøené období úlohy-----------------------
FUNCTION LAST_OBDn( cULOHA)
  LOCAL  cRET
  LOCAL  nREC := UcetSys ->( Recno())
  LOCAL  cTAG := UcetSys ->( OrdSetFOCUS())

  UCETSYS->( OrdSetFOCUS(3),                                                  ;
              ADS_SetScope( SCOPE_TOP, Upper( cULOHA)),                                ;
              ADS_SetScope( SCOPE_BOTTOM, Upper( cULOHA)),                             ;
              dbGoBotTom())

   cRET := StrZero( UCETSYS->nROK) +StrZero( UCETSYS->nOBDOBI)

  UCETSYS->( ADS_ClearScope( SCOPE_TOP),                                      ;
             ADS_ClearScope( SCOPE_BOTTOM),                                   ;
             OrdSetFOCUS(cTAG),                                               ;
             dbGoTo(nREC))

RETURN( cRET)


// ----------------- Vrátí období ve tvaru MM/RR z datumu-----------------------
FUNCTION COBDzDAT( dDATE)
RETURN( StrZero(Month(dDATE),2) +'/' +Right(AllTrim(Str(Year(dDATE),4)),2))