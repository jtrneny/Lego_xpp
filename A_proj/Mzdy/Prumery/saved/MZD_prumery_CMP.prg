#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


STATIC  anCtvrt  := { { 1, 2, 3}, { 4, 5, 6}, { 7, 8, 9}, { 10, 11, 12} }
STATIC  anObdobi := { { 1, 12}, { 2, 1}, { 3, 2}, { 4, 3}, { 5, 4}, { 6, 5}, { 7, 6}, { 8, 7}, { 9, 8}, { 10, 9}, { 11, 10}, { 12, 11} }
STATIC  nRYO_s
STATIC  aAlgHOD, aAlgDNU, aAlgODM, aZAOKnem
STATIC  nPracDobaH, nPracDobaD
STATIC  nPracDoMsH, nPracDoObH
STATIC  nPraDoMsTH, nPraDobaTH
STATIC  nPracDoMsD, nPracDoObD
STATIC  nPrcDobaHz, nPrcDobaDz
STATIC  xOBDkey, xCTVRTkey, nCtvrt, nVybRok
STATIC  nRokNemOD, nRokNemDO, nObdNemOD, nObdNemDO
STATIC  nPROCsocZ, nPROCzdrZ, nKoefDNmes, nKoefHOmes, nKoefHM
STATIC  nACTrok, nACTobd
STATIC  lNEWprum
STATIC  aDMZodm
STATIC  lINIstat
STATIC  pA

*
** funkce pro okolí pro møedání static hodnot
function pru_nPrcDobaHz()  ;  return  nPrcDobaHz
function pru_aAlgHOD()     ;  return  aAlgHod
function pru_nACTrok()     ;  return  nACTrok
**
*


static function ACT_OBDn()   ;  return strZero(uctOBDOBI:MZD:nROK, 4) +strZero(uctOBDOBI:MZD:nOBDOBI, 2)
static function ACT_OBDyn()  ;  return uctOBDOBI:MZD:nROK
static function ACT_OBDon()  ;  return uctOBDOBI:MZD:nOBDOBI
static function ACT_OBDqn()
  local  aQ := { 1,1,1,2,2,2,3,3,3,4,4,4 }
return( aQ[ACT_OBDon()] )

static function D_DnyOdDo( dDatOd, dDatDo, cTYP)
  LOCAL nRokOd := Year( dDatOd)
  LOCAL nRokDo := Year( dDatDo)
  LOCAL nMesOd := Month( dDatOd)
  LOCAL nMesDo := Month( dDatDo)
  LOCAL nDenOd := Day( dDatOd)
  LOCAL nDenDo := Day( dDatDo)
  LOCAL nDNY   := 0
  LOCAL nR, nM, nMesDoTm, nDenDoTm, nDenLast

  FOR nR := nRokOd TO nRokDo
    nMesDoTm := IF( nRokDo == nR, nMesDo, 12)
    FOR nM := nMesOd TO nMesDoTm
      nDenLast := LastDayOM( CtoD( "01/" +StrZero( nM, 2) +"/" +Str( nR, 4)))
      nDenDoTm := IF( nRokDo == nR .AND. nMesDoTm == nM , nDenDo, nDenLast)

      DO CASE
      CASE cTYP == "PRAC"
        nDNY  += F_PrcDnyOD( nR, nM, nDenOd, nDenDoTm)
      CASE cTYP == "SVAT"
        nDNY  += F_SvatkyOD( nR, nM, nDenOd, nDenDoTm)
      CASE cTYP == "VOLN"
        nDNY  += F_VolDnyOD( nR, nM, nDenOd, nDenDoTm)
      ENDCASE
      nDenOd   := 1
    NEXT
    nMesOd := 1
  NEXT
RETURN( nDNY)

STATIC FUNCTION fDanVyp( nVal, nROK)
  LOCAL nRetVal := 0, nDan := 0
  LOCAL aSAZdan, nN
  LOCAL nROKvyp

  DEFAULT nROKvyp TO ACT_OBDyn()

  DO CASE
  CASE nROKvyp = 2008
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2009
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2010
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2011
    aSAZdan := { { 0, 0, 0, 0.15 } }
  ENDCASE

  IF nVal > 0
    IF nVal <= 100
      nVal := round( nVal + 0.49, 0)
    ELSE
      nVal := ( round( nVal/100 + 0.49, 0 ) ) * 100
    ENDIF

    FOR nN := 1 TO Len( aSAZdan)
      IF nVal <= aSAZdan[nN,2] .OR. nN == Len( aSAZdan)
        nDan := IF( aSAZdan[nN,3] = 0, nVal * aSAZdan[nN,4]     ;
                  , aSAZdan[nN,3] +(( nVal - aSAZdan[nN,1]) * aSAZdan[nN,4]))
    EXIT
      ENDIF
    NEXT

    nRetVal := round( nDan + 0.49, 0)
  ENDIF
RETURN( nRetVal)
********************************************************************************


*
** externí funkce
FUNCTION fVYPprumer( lNewGen, lPRAVd, lEXT, cOBDnz, nTYP)
  LOCAL  cALIAS := 'msprc_mo'
  LOCAL  nX, cX, n
  LOCAL  aRET

  DEFAULT lPRAVd TO .F.
  DEFAULT lEXT   TO .F.
  DEFAULT nTYP   TO  1   // typ výpoètu 1 .. za ètvrtletí, 2 .. za období

  lNewPrum := lNewGen

  drgDBMS:open( 'mzdyIT' )

  INcSTATic( lPRAVD, cOBDnz)

  aRET := IF( !lPRAVD, fPRACmzdu( cALIAS), {.T.,.F.})
  IF aRET[1] .OR. aRET[2]
    fZalozREC( cALIAS)
    IF( aRET[1], fNAPprumPP( lPRAVD, cALIAS), NIL)
    IF( aRET[2], fNAPprumNM( lPRAVD, cALIAS), NIL)
**    DcrUnlock( "MsVPrum")
    fVYPprprac()
**    IF( lPRAVd .OR. lEXT, WRT_MSprum( cALIAS), NIL)
  ENDIF
RETURN( aRET[1] .OR. aRET[1])


** inicializace STATIC promìnných
** lpravd požadavek na pravdìpodobný prùmìr
FUNCTION INcSTATic( lPRAVD, cOBDnz)
  LOCAL  nX, cX, aX, n, nQ, nW
  LOCAL  dZACAT, dKONEC
  LOCAL  nREC, nY
  LOCAL  i
  LOCAL  aTMP
  LOCAL  cALIAS
  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")
  LOCAL  nAlgCelOdm

  cALIAS   := "MsPrc_MO"
  IF( lPRAVd, lINIstat := .T., lINIstat := .t. )

  nPracDoMsH := 0
  nPracDoObH := 0
  nPracDoMsD := 0
  nPracDoObD := 0
  nPraDoMsTH := 0

  IF  lINIstat
    aAlgHOD  := { 0, 0}
    aAlgDNU  := { 0, 0}
    aAlgODM  := { 0, 0, 0}
    aZAOKNem := { 31, 0, 31, 31, 31 }

    nACTrok := ACT_OBDyn()
    nACTobd := ACT_OBDon()

    cX := SysConfig( "Mzdy:cAlgHOD_PR")
    FOR n := 1 TO 2 ; aAlgHOD[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cAlgDNU_PR")
    FOR n := 1 TO 2 ; aAlgDNU[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cAlgODM_PR")
    FOR n := 1 TO 3 ; aAlgODM[n] := Val( Token( cX, ",", n))
    NEXT
    cX := SysConfig( "Mzdy:cZAOKnem")
    FOR n := 1 TO 5 ; aZAOKnem[n] := Val( Token( cX, ",", n))
    NEXT

    nPracDobaH := SysConfig( "Mzdy:nDelPrcTyd") / SysConfig( "Mzdy:nDnyPrcTyd")
    nPracDobaD := SysConfig( "Mzdy:nDnyPrcTyd")
    nPraDobaTH := SysConfig( "Mzdy:nDelPrcTyd")

    nPROCsocZ  := 0
    aEVAL( faOdvSocZA(), { |X| nPROCsocZ += X })
    nPROCzdrZ  := SysConfig( "Mzdy:nOdvZdrZam")
    nKoefHM    := SysConfig( "Mzdy:nKoefHM")

    dZACAT     := mh_FirstODate( nACTrok, 1)
    dKONEC     := mh_LastODate(  nACTrok, 12)
    nKoefDNmes := 21.74
    nKoefHOmes := 4.348
    lINIstat   := .F.
  ENDIF

  nY := Val( Right( AllTrim(cOBDnz), 2))

  DO CASE
  CASE nY = 1 .OR. nY = 2 .OR. nY = 3
    nX      := 12
    nVybRok := Val( Left( cOBDnz, 4)) -1

  CASE nY = 4 .OR. nY = 5 .OR. nY = 6
    nX      := 3
    nVybRok := Val( Left( cOBDnz, 4))

  CASE nY = 7 .OR. nY = 8 .OR. nY = 9
    nX      := 6
    nVybRok := Val( Left( cOBDnz, 4))

  CASE nY = 10 .OR. nY = 11 .OR. nY = 12
    nX      := 9
    nVybRok := Val( Left( cOBDnz, 4))
  ENDCASE

  i         := Val( Right( cOBDnz, 2))
  nRokNemOD := Val( Left( cOBDnz, 4)) -1
  nRokNemDO := IF( nY = 1, Val( Left( cOBDnz, 4)) -1, Val( Left( cOBDnz, 4)))
  nObdNemOD := anObdobi[i,1]
  nObdNemDO := anObdobi[i,2]

  xOBDkey   := cOBDnz
  nCtvrt    := mh_CTVRTzOBDn( nX)
  xCTVRTkey := StrZero( nVybRok, 4) +StrZero( nCtvrt, 1)


  IF lPRAVD
    nPracDoMsH := fPracDOBA( MsPrc_MO ->cDelkPrDob)[3]
    nPraDoMsTH := fPracDOBA( MsPrc_MO ->cDelkPrDob)[2]
    nPracDoObH := nPracDoMsH
    nPracDoMsD := fPracDOBA()[1]
    nPracDoObD := nPracDoMsD
  ELSE
    nPracDoObH := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[3]
    nPracDoObD := fPracDOBA( MsPrc_Mo ->cDelkPrDob)[1]

    IF nRokNemOD < Year( MsPrc_Mo ->dDatNast)
      nRokNemOD :=  Year(  MsPrc_Mo ->dDatNast)
      i         :=  Month( MsPrc_Mo ->dDatNast)
      nObdNemOD := anObdobi[i,1]
    ENDIF
  ENDIF


  nPrcDobaHz := IF( nPracDoObH > 0, nPracDoObH, IF( nPracDoMsH > 0, nPracDoMsH, nPracDobaH))
  nPrcDobaDz := IF( nPracDoObD > 0, nPracDoObD, IF( nPracDoMsD > 0, nPracDoMsD, nPracDobaD))

  nAlgCelOdm := IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
                                , ( cALIAS) ->nAlgCelOdm, aAlgODM[3])
  nPocMesPr  := IF( nPocMesPr = 0, 3, nPocMesPr)
  nPocMesPr  := IF( ( cALIAS) ->nAlgCelOdm <> 0 ;
                                , ( cALIAS) ->nPocMesPr, nPocMesPr)
  aDMZodm    := {}

  DruhyMZD ->( dbGoTop())
  DO WHILE !DruhyMZD ->( Eof())
    IF DruhyMZD ->lNapPrCelO
      nQ   := IF( DruhyMZD ->nAlgCelOdm == 0, nAlgCelOdm          ;
                                              , DruhyMZD ->nAlgCelOdm)
      nW   := IF( DruhyMZD ->nPocMesPr  == 0, nPocMesPr           ;
                                              , DruhyMZD ->nPocMesPr)

      * nelze zmìnit COMBEM
      lok  := ( DruhyMZD ->nAlgCelOdm <> 0 )

      ( aTMP := {}, aTMP := { StrZero(  DruhyMZD ->nDruhMzdy, 4), nQ, nW})
      AAdd( aDMZodm, aTMP)
    ENDIF
    DruhyMZD ->( dbSkip())
  ENDDO

RETURN( NIL)


** STATICKÉ - vnitøní funkce
*
** test zda má pracovník pro PP v daném ètvrtletí vypoètenou mzdu
**                           NP v pøedchozím roku vypoètenou mzdu
STATIC FUNCTION fPRACmzdu( cALIAS)
  LOCAL  aRET := { .F., .F.}
  LOCAL  xKEY, n
  LOCAL  xKEYcp, xKEYod, xKEYdo
  local  ncnt := 0

  drgDBMS:open('mzdyIT')

  FOR n := 1 TO 3
    xKey :=  StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2)         ;
            +StrZero( (cALIAS) ->nOsCisPrac, 5) +StrZero( (cALIAS) ->nPorPraVzt, 3)

    IF mzdyIT ->( dbSeek( xKey,, 'mzdyIT08'))
      aRET[1] := .T.
      n := 3
    ENDIF
  NEXT

  xKEYcp := StrZero( (cALIAS) ->nOsCisPrac, 5) +StrZero( (cALIAS) ->nPorPraVzt, 3)
  xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
  xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

  mzdyIT->( AdsSetOrder('MZDYIT18')         , ;
            dbSetScope(SCOPE_TOP   , xKEYod), ;
            dbSetScope(SCOPE_BOTTOM, xKEYdo), ;
            dbEval( { || ncnt ++ } )          )
  aRET[2] := ( ncnt > 0 )
RETURN( aRET)


*
** založíme, nebo vyprázdníme záznam pro výpoèet prùmìrù
STATIC FUNCTION fZalozREC( cALIAS)
  LOCAL  xKEY, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM
  LOCAL  cVybObdPP := "", cVybObdNM := ""
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY

  DEFAULT cALIAS TO "MsPrc_MO"

  lSVATKY := (cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := StrZero( (cALIAS)->nOsCisPrac,5) +StrZero( (cALIAS)->nPorPraVzt, 3)
  xKEY   := ACT_OBDn() +xKEYcp

  cVybObdPP :=  StrZero( anCtvrt[ nCtvrt,1], 2) + "/" +StrZero( nVybRok,4) + " - " ;
                 +StrZero( anCtvrt[ nCtvrt,3], 2) + "/" +StrZero( nVybRok,4)

  cVybObdNM :=  StrZero( nObdNemOD,2) + "/" + StrZero( nRokNemOD,4) + " - " ;
                 +StrZero( nObdNemDO,2) + "/" + StrZero( nRokNemDO,4)

  nPocM     := 3

  if msvPrum->(dbseek( xkey,, 'PRUMV_03'))
    msvPrum->( dbRlock(), mh_BLANKREC( 'msvPrum' ))
  else
    msvPrum->(dbAppend())
  endif

  MsVPrum ->nRok       := ACT_OBDyn()
  MsVPrum ->nObdobi    := ACT_OBDon()
  MsVPrum ->cObdobi    := StrZero( MsVPrum ->nObdobi, 2) +"/"      ;
                           +Right( StrZero( MsVPrum ->nRok, 4), 2)
  MsVPrum ->nCtvrtleti := mh_CTVRTzOBDn( MsVPrum ->nObdobi)
  MsVPrum ->cCtvrtlRIM := mh_CTVRTzOBDc( MsVPrum ->nObdobi)

  MsVPrum ->cPracovnik := Left( ( cALIAS) ->cPracovnik, 25)        ;
                           +StrZero( ( cALIAS) ->nOsCisPrac)
  MsVPrum ->cKmenStrPr := (cALIAS) ->cKmenStrPr
  MsVPrum ->nOsCisPrac := (cALIAS) ->nOsCisPrac
  MsVPrum ->nPorPraVzt := (cALIAS) ->nPorPraVzt
  MsVPrum ->cVybObd_P  := cVybObdPP
  MsVPrum ->cVybObd_N  := cVybObdNM
  MsVPrum ->nDelkPDoby := nPracDoMsH

  MsVPrum ->dDatNast   := (cALIAS) ->dDatNast
  MsVPrum ->dDatVyst   := (cALIAS) ->dDatVyst
RETURN( NIL)


STATIC FUNCTION F_PrumFND( lSVATKY)
  LOCAL  nDOdpra := 0

  DEFAULT lSVATKY TO .F.

  aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_PRACDNY( nVybRok, X)})
  IF lSVATKY
     aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_SVATKY( nVybRok, X)})
  ENDIF
RETURN( nDOdpra)


*
** PP - nápoèet do promìnných pro výpoèet pracovnì právního prùmìru
STATIC FUNCTION fNAPprumPP( lPRAVd, cALIAS)
  LOCAL  xKEY, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lOdp_POL
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  anSUMo[6,2]
  LOCAL  lSVATKY

  DEFAULT lPRAVd TO .F.
  DEFAULT cALIAS TO "msprc_MO"

  lSVATKY := (cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp  := strZero( (cALIAS) ->nOsCisPrac,5) +strZero( (cALIAS) ->nPorPraVzt,3)
  xKEY    := xCTVRTkey +xKEYcp
  nPocM   := 3

  IF !IsNil( aDMZodm)
    IF !Empty( aDMZodm)
      MsVPrum ->nAlgCelOdm := aDMZodm[1,2]
      MsVPrum ->nPocMesPr  := aDMZodm[1,3]
    ENDIF
  ENDIF

  IF( MsVPrum ->nAlgCelOdm <> 0, CELodm( xKEYcp, aDMZodm), NIL)

// novinka pro nekolik algoritmu vypoctu prumeru
  MsVPrum ->nDFondu_PP := nDnyFND
  MsVPrum ->nHFondu_PP := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                  IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                      , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  MsVPrum ->nDFondu_NA := nDnyFND
  MsVPrum ->nHFondu_NA := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                  IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                      , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  MsVPrum ->nHFondu_OO := nDnyFND * IF( aAlgODM[1] = 2, nPracDobaH, ;
                  IF( aAlgODM[1] = 3 .and. nPracDoObH = 0, nPracDobaH  ;
                      , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

  MsVPrum ->nDOdpra_PP := 0
  MsVPrum ->nHOdpra_PP := 0
  MsVPrum ->nDnyNap_NA := 0
  MsVPrum ->nHodNap_NA := 0
  MsVPrum ->nKcsODMEN  := 0

  IF !lPRAVd
    FOR n := 1 TO 3
      anSUMo[1,1] := anSUMo[2,1] := anSUMo[3,1] := anSUMo[4,1] := anSUMo[5,1] := anSUMo[6,1] := 0
      anSUMo[1,2] := anSUMo[2,2] := anSUMo[3,2] := anSUMo[4,2] := anSUMo[5,2] := anSUMo[6,2] := 0

      xKey := StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2)                                ;
               +StrZero( ( cALIAS) ->nOsCisPrac) +StrZero( ( cALIAS) ->nPorPraVzt)

      anSUMo[1,1] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,1] := anSUMo[1,1]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                    , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                          , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      anSUMo[1,2] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,2] := anSUMo[1,2]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                    , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                          , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      mzdyIT->( AdsSetOrder('MZDYIT08')        , ;
                dbSetScope(SCOPE_BOTH   , xkey), ;
                dbgoTop()                        )

       DO WHILE !mzdyIT ->( Eof())
         druhyMzd->( dbseek( left( xkey,6) +strZero( mzdyIT->ndruhMzdy,4),, 'DRUHYMZD04'))

         IF ( DruhyMZD->nPrNapPpDn+DruhyMZD->nPrNapPpHo+DruhyMZD->nPrNapPpMz  ;
              +DruhyMZD->nPrNapNaDn+DruhyMZD->nPrNapNaHo+DruhyMZD->nPrNapNaMz  ;
               +DruhyMZD->nPrNapRoMz+DruhyMZD->P_KcsPOHSL ) <> 0

           lOdp_POL  := IF( DruhyMZD ->P_KcsPOHSL = 1, .T., .F.)

           MsVPrum ->nHFondu_OO -= IF( lOdp_POL, mzdyIT ->nHodDoklad, 0)
           anSUMo[1,1] -= IF( lOdp_POL .AND. aAlgDNU[1] = 4, mzdyIT ->nDnyDoklad, 0)
           anSUMo[2,1] -= IF( lOdp_POL .AND. ( aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3), mzdyIT ->nHodDoklad, 0)

           MsVPrum ->nDOdpra_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           MsVPrum ->nDnyNap_PP += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           MsVPrum ->nHOdpra_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           MsVPrum ->nHodNap_PP += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapPpHo
           MsVPrum ->nKcsPRACP  += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           MsVPrum ->nMzdNap_PP += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz
           anSUMo[1,1]          += IF(aAlgDNU[1] <> 4,                       ;
                                      mzdyIT->nDnyDoklad*DruhyMZD->nPrNapPpDn, 0)
           anSUMo[2,1]          += IF( aAlgHOD[1] = 1,                       ;
                                      mzdyIT->nHodDoklad*DruhyMZD->nPrNapPpHo, 0)
           anSUMo[3,1]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapPpMz

           MsVPrum ->nDnyNap_NA += mzdyIT ->nDnyDoklad * DruhyMZD->nPrNapNaDn
           MsVPrum ->nHodNap_NA += mzdyIT ->nHodDoklad * DruhyMZD->nPrNapNaHo
           MsVPrum ->nMzdNap_NA += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz
           anSUMo[1,2]          += IF(aAlgDNU[1] <> 4,                       ;
                                      mzdyIT ->nDnyDoklad*DruhyMZD->nPrNapNaDn, 0)
           anSUMo[2,2]          += IF( aAlgHOD[1] = 1,                       ;
                                      mzdyIT ->nHodDoklad*DruhyMZD->nPrNapNaHo, 0)
           anSUMo[3,2]          += mzdyIT ->nMzda      * DruhyMZD->nPrNapNaMz

           MsVPrum ->nKcsODMEN  += ( mzdyIT ->nMzda*DruhyMZD->nPrNapRoMz / 12 );


           MsVPrum ->nHOD_presc += mzdyIT ->nHodPresc
           MsVPrum ->nHOD_presc += mzdyIT ->nHodPrescS
         ENDIF

         IF mzdyIT ->nDruhMzdy = 960
           MsVPrum ->nDanUleva += mzdyIT ->nMzda
         ENDIF

         mzdyIT ->( dbSkip())
       ENDDO

      mzdyIT ->( dbClearScope())

      cX := Padl( AllTrim( Str( n)), 2, "0")
      MsVPrum ->&( "nDNY_PP"+cX) := anSUMo[1,1]
      MsVPrum ->&( "nHOD_PP"+cX) := anSUMo[2,1]
      MsVPrum ->&( "nKC_PP" +cX) := anSUMo[3,1]
      MsVPrum ->&( "nDNY_NA"+cX) := anSUMo[1,2]
      MsVPrum ->&( "nHOD_NA"+cX) := anSUMo[2,2]
      MsVPrum ->&( "nMZD_NA"+cX) := anSUMo[3,2]
    NEXT

    MsVPrum ->nDNY_PPSUM := MsVPrum ->nDNY_PP01 +MsVPrum ->nDNY_PP02 ;
                             +MsVPrum ->nDNY_PP03
    MsVPrum ->nHOD_PPSUM := MsVPrum ->nHOD_PP01 +MsVPrum ->nHOD_PP02 ;
                             +MsVPrum ->nHOD_PP03
    MsVPrum ->nKC_PPSUM  := MsVPrum ->nKC_PP01 +MsVPrum ->nKC_PP02   ;
                             +MsVPrum ->nKC_PP03

    MsVPrum ->nDNY_NASUM := MsVPrum ->nDNY_NA01 +MsVPrum ->nDNY_NA02 ;
                             +MsVPrum ->nDNY_NA03
    MsVPrum ->nHOD_NASUM := MsVPrum ->nHOD_NA01 +MsVPrum ->nHOD_NA02 ;
                             +MsVPrum ->nHOD_NA03
    MsVPrum ->nMZD_NASUM  := MsVPrum ->nMZD_NA01 +MsVPrum ->nMZD_NA02   ;
                             +MsVPrum ->nMZD_NA03

  ELSE
    MsVPrum ->nDNY_PPSUM := nDnyFND
    MsVPrum ->nHOD_PPSUM := nPracDoMsH *nDnyFND
    MsVPrum ->nDNY_NASUM := nDnyFND
    MsVPrum ->nHOD_NASUM := nPracDoMsH *nDnyFND

    DO CASE
    CASE msprc_MO ->cTypTarMzd == "MESICNI "
      MsVPrum ->nKC_PPSUM  := msprc_MO ->nTarSazMes * nPocM
      MsVPrum ->nMZD_NASUM := msprc_MO ->nTarSazMes * nPocM

    CASE msprc_MO ->cTypTarMzd == "CASOVA  "
      MsVPrum ->nKC_PPSUM  := msprc_MO ->nTarSazHod *MsVPrum ->nHOD_PPSUM
      MsVPrum ->nMZD_NASUM := msprc_MO ->nTarSazHod *MsVPrum ->nHOD_NASUM

    CASE msprc_MO ->nTarSazHod <> 0
      MsVPrum ->nKC_PPSUM  := msprc_MO ->nTarSazHod *MsVPrum ->nHOD_PPSUM
      MsVPrum ->nMZD_NASUM := msprc_MO ->nTarSazHod *MsVPrum ->nHOD_NASUM

    CASE msprc_MO ->nTarSazMes <> 0
      MsVPrum ->nKC_PPSUM  := msprc_MO ->nTarSazMes * nPocM
      MsVPrum ->nMZD_NASUM := msprc_MO ->nTarSazMes * nPocM
    ENDCASE

    MsVPrum ->nKC_PPSUM += IF( msprc_MO ->nSazPrePr <> 0,                             ;
    Round( MsVPrum ->nKC_PPSUM * ( msprc_MO ->nSazPrePr/100), 0), 0)
    MsVPrum ->nKC_PPSUM += IF( msprc_MO ->nSazOsoOh <> 0, msprc_MO ->nSazOsoOh, 0)
    MsVPrum ->nMZD_NASUM += IF( msprc_MO ->nSazPrePr <> 0,                             ;
    Round( MsVPrum ->nMZD_NASUM * ( msprc_MO ->nSazPrePr/100), 0), 0)
    MsVPrum ->nMZD_NASUM += IF( msprc_MO ->nSazOsoOh <> 0, msprc_MO ->nSazOsoOh, 0)
  ENDIF
RETURN( NIL)


FUNCTION CELodm( xKEY, aDMZ)
  LOCAL  n
  LOCAL  nCelODM := 0
  LOCAL  xKEYod, xKEYdo
  LOCAL  cOBDod, cOBDdo
  LOCAL  nTYP

  fordRec( {'mzdyIT'} )

  MsVPrum ->nKC_ODMcel := 0
  MsVPrum ->nKC_ODMroz := 0

  IF !IsNil( aDMZ)
    FOR n := 1 TO Len( aDMZ)
      nTYP := aDMZ[n,2]

      DO CASE
      CASE nTYP == 1
        cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
        cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

      CASE nTYP == 2
        cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
        cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

      CASE nTYP == 3
        DO CASE
        CASE ACT_OBDqn() = 1
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        CASE ACT_OBDqn() = 2
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"04"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"03"
        CASE ACT_OBDqn() = 3
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"06"
        CASE ACT_OBDqn() = 4
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE

      CASE nTYP == 4
        DO CASE
        CASE ACT_OBDqn() = 1
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        OTHERWISE
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE

      CASE nTYP == 5
        DO CASE
        CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2 .OR. ACT_OBDqn() = 3
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        CASE ACT_OBDqn() = 4
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"12"
        ENDCASE

      CASE nTYP == 6
        DO CASE
        CASE ACT_OBDqn() = 1  //4
          cOBDod := StrZero( ACT_OBDyn()-1, 4) +"07"
          cOBDdo := StrZero( ACT_OBDyn()-1, 4) +"12"
        CASE ACT_OBDqn() = 2   //1
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"03"
        CASE ACT_OBDqn() = 3   //1
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"06"
        CASE ACT_OBDqn() = 4   //1
          cOBDod := StrZero( ACT_OBDyn(), 4) +"04"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE

      CASE nTYP == 7
        DO CASE
        CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2          //4
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        OTHERWISE
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE
      ENDCASE

      xKEYod  := xKEY +aDMZ[n,1] +cOBDod
      xKEYdo  := xKEY +aDMZ[n,1] +cOBDdo
      ncelOdm := 0

      mzdyIT->( AdsSetOrder('MZDYIT15')                  , ;
                dbSetScope(SCOPE_TOP   , xKEYod)         , ;
                dbSetScope(SCOPE_BOTTOM, xKEYdo)         , ;
                dbeval( { || ncelOdm += mzdyIT->nmzda } ), ;
                dbClearScope()                             )

      MsVPrum ->nKC_ODMcel += nCelODM
      MsVPrum ->nKC_ODMroz += ( nCelODM / 12) * aDMZ[n,3]
    NEXT
  ENDIF

  fordRec()
RETURN( NIL)



*
** NM - nápoèet do promìnných pro výpoèet prùmìrù pro nemocenskou dávku
STATIC FUNCTION fNAPprumNM( lPRAVd, cALIAS)
  LOCAL  xKEYod, xKEYdo, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lNem_KCS, lNem_DNY, lDan_NP
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  anSUMo[6]
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY

  DEFAULT lPRAVd TO .F.
  DEFAULT cALIAS TO "msprc_MO"

  fordRec( {'mzdyIT'} )

  lSVATKY := (cALIAS) ->cTypTarMZD == "MESICNI "
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := strZero( (cALIAS)->nOsCisPrac, 5) +strZero( (cALIAS)->nPorPraVzt, 3)

  MsVPrum ->nKcsNEMOC  := 0
  MsVPrum ->nKcsDAN_NP := 0

  fKalDnyNM()

  IF !lPRAVd
    anSUMo[1] := anSUMo[2] := anSUMo[3] := anSUMo[4] := anSUMo[5] := anSUMo[6] := 0

    xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
    xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

    mzdyIT->( AdsSetOrder('MZDYIT08')         , ;
              dbSetScope(SCOPE_TOP   , xKEYod), ;
              dbSetScope(SCOPE_BOTTOM, xKEYdo), ;
              dbgoTop()                         )

    DO WHILE !Mzdy ->( Eof())
      druhyMzd->( dbSeek( strZero( mzdyIT->nrok,4)    + ;
                          strZero( mzdyIT->nodbobi,2) + ;
                          strZero( mzdyIT->ndruhMzdy,4),, 'DRUHYMZD04'))


      IF ( DruhyMZD ->P_KcsNEMOC +DruhyMZD ->P_KcsHOPRP) != 0
        lNem_KCS  := IF( DruhyMZD ->P_KcsNEMOC = 1, .T., .F.)
        lNem_DNY  := IF( DruhyMZD ->P_KcsHOPRP = 1, .T., .F.)
        lDan_NP   := IF( mzdyIT ->nDruhMzdy = 500 .OR. mzdyIT ->nDruhMzdy = 501, .T., .F.)

        // byl vybrán tento mìsíc také pro nemocenské pojištìní ?
        IF !Empty( MsVPrum ->dDatVyst)                               ;
            .AND. Month( MsVPrum ->dDatVyst) < mzdyIT ->nObdobi      ;
              .AND. Year( MsVPrum ->dDatVyst) <= mzdyIT ->nRok
          lODPOCnem := .F.
        ENDIF

        IF lODPOCnem
          MsVPrum ->nDOdpra_NP -= IF( lNem_DNY, mzdyIT ->nDnyDoklad, 0)
          anSUMo[5]            -= IF( lNem_DNY, mzdyIT ->nDnyDoklad, 0)
        ENDIF

        IF lNem_KCS
          MsVPrum ->nKcsNEMOC  += mzdyIT ->nMzda
          anSUMo[6]            += mzdyIT ->nMzda

          // naèteme si daò pro NP pro pøíslušný mìsíc
          MsVPrum ->nKcsDAN_NP := MsVPrum ->nKcsDAN_NP +if( lDan_NP, mzdyIT ->nMzda, 0 )
        ENDIF
      ENDIF
      mzdyIT ->( dbSkip())
    ENDDO
    mzdyIT->( dbClearScope())

    MsVPrum ->nKDO_NM01 := anSUMo[5]
    MsVPrum ->nKC_NM01  := anSUMo[6]

    MsVPrum ->nKD_NMSUM  := MsVPrum ->nKD_NM01 +MsVPrum ->nKD_NM02   ;
                             +MsVPrum ->nKD_NM03
    MsVPrum ->nKDO_NMSUM := MsVPrum ->nKDO_NM01 +MsVPrum ->nKDO_NM02 ;
                             +MsVPrum ->nKDO_NM03
    MsVPrum ->nKC_NMSUM  := MsVPrum ->nKC_NM01 +MsVPrum ->nKC_NM02   ;
                             +MsVPrum ->nKC_NM03

  ELSE
    MsVPrum ->nKD_NMSUM := F_KalenFND( nVybRok, nCtvrt)
    MsVPrum ->nKC_NMSUM := MsVPrum ->nKC_PPSUM
  ENDIF

  fordRec()
RETURN( NIL)


STATIC FUNCTION fKalDnyNM()
  LOCAL  dZACAT, dKONEC
  LOCAL  nAKTobd := ACT_OBDon()
  LOCAL  nAKTrok := ACT_OBDyn()

  IF nAKTobd == 1
    dZACAT := mh_FirstODate( nAKTrok-1, anObdobi[nAKTobd,1])
    dKONEC := mh_LastODate(  nAKTrok-1, anObdobi[nAKTobd,2])
  ELSE
    dZACAT := mh_FirstODate( nAKTrok-1, anObdobi[nAKTobd,1])
    dKONEC := mh_LastODate(  nAKTrok,   anObdobi[nAKTobd,2])
  ENDIF

  MsVPrum ->nKDSkut    := D_DnyOdDo( dZACAT, dKONEC, "KALE")

  IF( dZACAT < MsVPrum ->dDatNast, dZACAT := MsVPrum ->dDatNast, NIL)
  IF !Empty( MsVPrum ->dDatVyst)
    IF( dKONEC > MsVPrum ->dDatVyst, dKONEC := MsVPrum ->dDatVyst, NIL)
  ENDIF

  MsVPrum ->nKD_NM01   := D_DnyOdDo( dZACAT, dKONEC, "KALE")
  MsVPrum ->nDOdpra_NP := MsVPrum ->nKD_NM01
RETURN( NIL)


STATIC FUNCTION F_KalenFND()
  LOCAL  nDKalen := 0

  aEval( anCtvrt[ nCtvrt],{ |X| nDKalen += F_KALDNY( nVybRok, X)})
RETURN( nDKalen)

*
** výpoèet prùmìrù PP a NP pro pracovníka
STATIC FUNCTION fVYPprprac()
  LOCAL  _nM172, _nM013, _nOdmH, _nOdmD, anNem
  LOCAL  nKoefCIST
  LOCAL  nTmpNA, nOdmNA

  _nOdmH := 0
  _nOdmD := 0
  _nM172 := 0
  nTmpNA := 0
  nOdmNA := 0

  IF ReplRec( "MsVPrum")
// PP _ tak‚ algoritmus výpoètu celoroŸních odmìn
    nKoefCIST            := ( MsVPrum ->nHOD_PPSUM - MsVPrum ->nHOD_presc) / MsVPrum ->nHFondu_PP
    nKoefCIST            := IF( nKoefCIST > 1, 1, nKoefCIST)
    MsVPrum ->nKc_ODMcis := MsVPrum ->nKc_ODMroz * nKoefCIST

    IF aAlgHOD[1] = 1 .OR. aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3
       _nM172 := Round( IF( MsVPrum ->nHOD_PPSUM > 0, ( MsVPrum ->nKC_PPSUM +MsVPrum ->nKC_ODMcis)   ;
                       / MsVPrum ->nHOD_PPSUM, 0), 2)
       nTmpNA := Round( IF( MsVPrum ->nHOD_NASUM > 0, ( MsVPrum ->nMZD_NASUM +MsVPrum ->nKC_ODMcis)   ;
                       / MsVPrum ->nHOD_NASUM, 0), 2)
    ENDIF

    DO CASE
    CASE aAlgODM[1] = 1
      _nOdmH := Mh_RoundNumb( IF( MsVPrum ->nHOdpra_PP > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHOdpra_PP, 0), aAlgODM[2])
      nOdmNA := Mh_RoundNumb( IF( MsVPrum ->nHOD_NASUM > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHOD_NASUM, 0), aAlgODM[2])

    CASE aAlgODM[1] = 2 .or. aAlgODM[1] = 3
      _nOdmH := Mh_RoundNumb( IF( MsVPrum ->nHFondu_PP > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHFondu_PP, 0), aAlgODM[2])
      nOdmNA := Mh_RoundNumb( IF( MsVPrum ->nHFondu_NA > 0, ;
                        MsVPrum ->nKcsODMEN / MsVPrum ->nHFondu_NA, 0), aAlgODM[2])

      DO CASE
      CASE aAlgODM[1] = 2
        _nOdmD := Mh_RoundNumb( _nOdmH * nPracDobaH, aAlgODM[2])

      CASE aAlgODM[1] = 3
        _nOdmD := Mh_RoundNumb( _nOdmH * nPrcDobaHz, aAlgODM[2])

      ENDCASE
    ENDCASE

// PP _ tak a šupnem hodinový prùmìr do souboru, ale nesmí nám pøetéct
    MsVPrum ->nHodPrumPP := Mh_RoundNumb( IF( _nM172 + _nOdmH > 9999.99, 0,                  ;
                                  ( _nM172 + _nOdmH ) * nKoefHM), aAlgHOD[2])
    MsVPrum ->nHodPrumNA := Mh_RoundNumb( IF( nTmpNA + nOdmNA > 9999.99, 0,                  ;
                                  ( nTmpNA + nOdmNA) * nKoefHM), aAlgHOD[2])

    IF nPracDoMsH <> nPracDoObH .AND. nPracDoMsH <> 0 .AND. nPracDoObH <> 0
      MsVPrum ->nHodPrumPP := Mh_RoundNumb( MsVPrum ->nHodPrumPP *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
      MsVPrum ->nHodPrumNA := Mh_RoundNumb( MsVPrum ->nHodPrumNA *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
    ENDIF

// PP _ respekujeme algoritmus výpoètu seního prùmìru vèetnì celoroèních odmìn
//      a šupnem denní prùmìr do souboru
    MsVPrum ->nDenPrumPP := VypDENpru( _nM172, _nOdmD                        ;
                                        , MsVPrum ->nDNY_PPSUM               ;
                                         , MsVPrum ->nKC_PPSUM               ;
                                          , MsVPrum ->nKC_ODMcis)


// NM _ vypoèteme prùmìr pro náhrady za nemocenské pojištìní
    IF MsVPrum ->nHodPrumPP > 0 .OR. MsVPrum ->nHodPrumNA > 0
      IF SysConfig( "Mzdy:lNezPrumNA")
        anNem := F_VypPrumNem( MsVPrum ->nHodPrumNA, 0, 0, nACTrok, .t.)
      ELSE
        anNem := F_VypPrumNem( MsVPrum ->nHodPrumPP, 0, 0, nACTrok, .t.)
      ENDIF

      MsVPrum ->nDenVZhruH := anNem[1]
      MsVPrum ->nDenVZcisH := anNem[2]
      MsVPrum ->nDenVZcikH := anNem[5]

      MsVPrum ->nSazDenH_1 := anNem[8]
      MsVPrum ->nSazDenH_2 := anNem[3]
    ENDIF

// NM _ vypoèteme prùmìr pro nemocenské pojištìní
    IF MsVPrum ->nKC_NMSUM > 0 .AND. ( MsVPrum ->nKD_NMSUM + MsVPrum ->nKDO_NMSUM) > 0  //    .and. Empty( MsVPrum ->nM010)
      anNem := F_VypPrumNem( MsVPrum ->nKC_NMSUM, MsVPrum ->nKD_NMSUM, MsVPrum ->nKDO_NMSUM, nACTrok)

      MsVPrum ->nDenVZhruN := anNem[1]
      MsVPrum ->nDenVZcisN := anNem[2]
      MsVPrum ->nSazDenNiN := anNem[3]
      MsVPrum ->nSazDenVyN := anNem[4]
      MsVPrum ->nDenVZcikN := anNem[5]
      MsVPrum ->nSazDenVKN := anNem[6]
      MsVPrum ->nSazDenMaN := anNem[7]

      MsVPrum ->nSazDenN_1 := anNem[8]
      MsVPrum ->nSazDenN_2 := anNem[3]
      MsVPrum ->nSazDenN_3 := anNem[6]
      MsVPrum ->nSazDenN_4 := anNem[4]
      MsVPrum ->nSazDenN_5 := 0
      MsVPrum ->nSazDenM_1 := anNem[7]
      MsVPrum ->nSazDenM_2 := anNem[9]
      MsVPrum ->nSazDenO_1 := anNem[7]
      MsVPrum ->nSazDenO_2 := 0

    ENDIF
    PRUmesMZD()

    msvPrum->( dbUnlock())
  ENDIF
RETURN( NIL)


FUNCTION VypDENpru( nHODpru, nODMmzd, nDNYsum, nKCsum, nODMcis)
  LOCAL  nDENpru := 0

  DO CASE
  CASE aAlgDNU[1] = 1 .OR. aAlgDNU[1] = 2
    nDENpru := ( nHODpru +nODMmzd) * nPrcDobaHz

  CASE aAlgDNU[1] = 3
    nDENpru := ( nHODpru +nODMmzd) * nPracDobaH

  CASE aAlgDNU[1] = 4 .OR.  aAlgDNU[1] = 5
    nDENpru := IF( nDNYsum > 0, ( nKCsum +nODMcis) / nDNYsum, 0) +nODMmzd
  ENDCASE

// PP _ tak a špnem denní prùmìr do souboru, ale nesmí nám pøetéct
  nDENpru :=  Mh_RoundNumb( IF( nDENpru > 9999.99, 0, nDENpru * nKoefHM), aAlgDNU[2])
RETURN( nDENpru)


FUNCTION F_VypPrumNem( nKC, nKD, nKDO, nROKlik, lNAHR)
  LOCAL  _nV_Nemoc, _nS_Nemoc, _nK_Nemoc
  LOCAL  anPruNem[9]
  LOCAL  nXzakl90, nXzakl, nX30, nX60, nX90
  LOCAL  nRedHr1, nRedHr2, nRedHr3
  LOCAL  n, cX
  LOCAL  nkoenahr

  DEFAULT lNAHR TO .F.

  IF Empty( aZAOKnem)
    aZAOKNem := { 31, 0, 0, 0, 0 }
    cX := SysConfig( "Mzdy:cZAOKnem")
    FOR n := 1 TO 5 ; aZAOKnem[n] := Val( Token( cX, ",", n))
    NEXT
  ENDIF

  nkoenahr := if(lnahr, 0.175, 1)

  DO CASE
  CASE nROKlik == 2004 .OR. nROKlik == 2005
    nRedHr1 := 480
    nRedHr2 := 690
  CASE nROKlik == 2006
    nRedHr1 := 510
    nRedHr2 := 730
  CASE nROKlik == 2007 .OR. nROKlik == 2008
    nRedHr1 := 550
    nRedHr2 := 790
  CASE nROKlik == 2009
    nRedHr1 :=  786 * nkoenahr
    nRedHr2 := 1178 * nkoenahr
    nRedHr3 := 2356 * nkoenahr
  CASE nROKlik == 2010
    nRedHr1 :=  791 * nkoenahr
    nRedHr2 := 1186 * nkoenahr
    nRedHr3 := 2371 * nkoenahr
  CASE nROKlik == 2011
    nRedHr1 :=  825 * nkoenahr
    nRedHr2 := 1237 * nkoenahr
    nRedHr3 := 2474 * nkoenahr
  ENDCASE

  anPruNem[1] := anPruNem[2] := anPruNem[3] := anPruNem[4] := anPruNem[5] := anPruNem[6] := anPruNem[7] := 0

  IF nKC > 0
    if lnahr
      _nV_Nemoc := nKC
    else
      IF nKD > 0
        _nV_Nemoc := nKC / ( nKD +nKDO)
      ELSE
        _nV_Nemoc := 0
      ENDIF
    endif

    DO CASE
    CASE _nV_Nemoc > nRedHr3
      nXzakl    := MH_RoundNumb(nRedHr3 - nRedHr2, aZAOKnem[2])  // 0
      nX30      := MH_RoundNumb( Round( nXzakl  * 0.30, 2), aZAOKnem[3])  // 31
      nXzakl    := MH_RoundNumb(nRedHr2 - nRedHr1, aZAOKnem[2])  // 0
      nX60      := MH_RoundNumb( Round( nXzakl  * 0.60, 2), aZAOKnem[3])  // 31
      nX90      := MH_RoundNumb( Round( nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

      _nS_Nemoc := nRedHr1 + nX60
      _nK_Nemoc := nX90 + nX60 + nX30

    CASE _nV_Nemoc > nRedHr2
      nXzakl    := MH_RoundNumb( _nV_Nemoc - nRedHr2,       aZAOKnem[2])  // 0
      nX30      := MH_RoundNumb( Round( nXzakl  * 0.30, 2), aZAOKnem[3])  // 31
      nXzakl    := MH_RoundNumb(nRedHr2 - nRedHr1, aZAOKnem[2])  // 0
      nX60      := MH_RoundNumb( Round( nXzakl  * 0.60, 2), aZAOKnem[3])  // 31
      nX90      := MH_RoundNumb( Round( nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

      _nS_Nemoc := nRedHr1 + nX60
      _nK_Nemoc := nX90 + nX60 + nX30


    CASE _nV_Nemoc > nRedHr1
      nXzakl    := MH_RoundNumb(          _nV_NEMOC - nRedHr1, aZAOKnem[2])  // 0
      nX60      := MH_RoundNumb( Round( nXzakl   * 0.60, 2), aZAOKnem[3])  // 31
      nX90      := MH_RoundNumb( Round(  nRedHr1 * 0.90, 2), aZAOKnem[4])  // 31

      _nS_Nemoc := nRedHr1 + nX60
      _nK_Nemoc := nX90 + nX60

    OTHERWISE
      nXzakl    := MH_RoundNumb( _nV_NEMOC, aZAOKnem[2])
      nX90      := MH_RoundNumb( Round( nXzakl * 0.9, 2), aZAOKnem[4])     //31

      _nS_Nemoc := nXzakl
      _nK_Nemoc := nX90

    ENDCASE

    anPruNem[1] := IF( _nV_Nemoc > 9999.99, 0, _nV_Nemoc)
    anPruNem[2] := IF( _nS_Nemoc > 9999.99, 0, _nS_Nemoc)
    anPruNem[5] := IF( _nK_Nemoc > 9999.99, 0, _nK_Nemoc)
    anPruNem[3] := MH_RoundNumb( Round( ( anPruNem[5] *0.60), 2), aZAOKnem[5])
    anPruNem[6] := MH_RoundNumb( Round( ( anPruNem[5] *0.66), 2), aZAOKnem[5])
    anPruNem[4] := MH_RoundNumb( Round( ( anPruNem[5] *0.72), 2), aZAOKnem[5])
    anPruNem[7] := MH_RoundNumb( Round( ( anPruNem[2] *0.69), 2), aZAOKnem[5])
    anPruNem[8] := MH_RoundNumb( Round( ( anPruNem[5] *0.25), 2), aZAOKnem[5])
    anPruNem[9] := MH_RoundNumb( Round( ( anPruNem[2] *0.70), 2), aZAOKnem[5])
  ENDIF
RETURN( anPruNem)


FUNCTION PRUmesMZD()
  LOCAL nX, nVAL
  LOCAL aX
  LOCAL nPruDNUmes, nHodCELKEM
  LOCAL nZaklad
  LOCAL nSoc := 0, nZdr := 0, nDan := 0
  LOCAL nRECms     := msprc_MO ->( Recno())
  LOCAL nSupHrMzda := 0

  IF nPracDoMsD <> 0
    nHodCELKEM :=  nKoefHOmes * nPraDoMsTH
  ELSE
    nHodCELKEM :=  nKoefHOmes * nPraDobaTH
  ENDIF

  nHodCELKEM := Mh_RoundNumb( nHodCELKEM,222)
  MsVPrum ->nPruMesMzH := Mh_RoundNumb( MsVPrum ->nHodPrumPP *nHodCELKEM, 32)

  nSoc := Round( ( ( MsVPrum ->nPruMesMzH * nPROCsocZ) / 100) + 0.49, 0)
  nZdr := Round( ( ( MsVPrum ->nPruMesMzH * nPROCzdrZ) / 100) + 0.49, 0)

  nSupHrMzda := MsVPrum ->nPruMesMzH + (MsVPrum ->nPruMesMzH * 0.35)
  nSupHrMzda := Mh_RoundNumb( nSupHrMzda, 32)

  nVAL := nSupHrMzda - msprc_MO ->nOdpocOBD
  nDan := fDanVyp( nVal, nACTrok)
  nDan := IF( nDan >= msprc_MO ->nDanUlObd, nDan - msprc_MO ->nDanUlObd, 0)

  MsVPrum ->nPruMesMzC := MsVPrum ->nPruMesMzH  - nSoc - nZdr - nDan

  msprc_MO ->( dbGoTo( nRECms))
RETURN( NIL)