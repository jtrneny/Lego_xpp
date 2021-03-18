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
static  in_file
static  out_file
static  ctypMzd

*
** funkce pro okolí pro pøedání static hodnot
function pru_nPrcDobaHz()  ;  return  nPrcDobaHz
function pru_aAlgHOD()     ;  return  aAlgHod
function pru_nACTrok()     ;  return  nACTrok
**
*


*
** externí funkce
** 1 - volání na tlaèítko z mzd_prumery_crd  -->  1 - pracovník   do msvPrumW
** 2 - volání na tlaèítko z mzd_prumery_scr  -->  N - pracovníkù  do msvPrum
FUNCTION fVYPprumer( lNewGen, lPRAVd, lEXT, cOBDnz, nTYP, outFile, typZpr, inFile )
  LOCAL  aRET
  local  newR
  local  dlastDate

  DEFAULT lPRAVd  TO .F.  // pravdìpodobný prùmìr
  DEFAULT lEXT    TO .F.
  DEFAULT nTYP    TO  1   // typ výpoètu 1 .. za ètvrtletí, 2 .. za období
  default inFile  to 'msprc_mo'
  default outFile to 'msvPrum'

  lNewPrum  := lNewGen
  in_File   := inFile
  out_File  := outFile
  newR      := .t.
  dlastDate := mh_LastODate( (in_File)->nROK, (in_File)->nOBDOBI)

  ctypMZD   := if( in_File = 'msprc_mow', mstarindw->cTypTarMzd,   ;
                         fsazTAR( dlastDate, in_File)[3])

  drgDBMS:open( 'mzdyit',,,,,'mzdyit_p' )
  drgDBMS:open( 'mzdyitpr',,,,,'mzdyitpr_p' )

  drgDBMS:open( 'mzdyIT'   )
  drgDBMS:open( 'druhyMzd' )

  INcSTATic( lPRAVD, cOBDnz, in_File)

  aRET := IF( !lPRAVD, fPRACmzdu(), {.T.,.F.})

  IF aRET[1] .OR. aRET[2]

    if in_File = 'msvprumw'
      newR := if( msvprumw->( Recno()) = 0,  .t., .f.)
    end

    if( newR, fZalozREC( cOBDnz),0)

    IF( aRET[1], fNAPprumPP( lPRAVD ), NIL)
    IF( aRET[2], fNAPprumNM( lPRAVD ), NIL)

    fVYPprprac( typZpr)

    if( lower(out_file) = 'msvprum', (out_file)->( dbunlock()), nil )
    (out_file)->( dbcommit())

  ENDIF

RETURN( aRET[1] .OR. aRET[1])


** inicializace STATIC promìnných
** lpravd požadavek na pravdìpodobný prùmìr
** (r)
function INcSTATic( lPRAVD, cOBDnz, file)
  LOCAL  nX, cX, aX, n, nQ, nW
  LOCAL  dZACAT, dKONEC
  LOCAL  nREC, nY
  LOCAL  i
  LOCAL  aTMP
  LOCAL  nPocMesPr := SysConfig( "Mzdy:nPocMesPr")
  LOCAL  nAlgCelOdm
  *
  local  cky       := strZero( uctOBDOBI:MZD:NROK,4) +strZero( uctOBDOBI:MZD:NOBDOBI,2)

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

  nX      := Val( Right( MZD_ObdPrumPP( cOBDnz)[2],2))
  nVybRok := Val( Left( MZD_ObdPrumPP( cOBDnz)[2],4))

  nRokNemOD := Val( Left(  MZD_ObdPrumNM( cOBDnz)[1],4))
  nRokNemDO := Val( Left(  MZD_ObdPrumNM( cOBDnz)[2],4))
  nObdNemOD := Val( Right( MZD_ObdPrumNM( cOBDnz)[1],2))
  nObdNemDO := Val( Right( MZD_ObdPrumNM( cOBDnz)[2],2))

  xOBDkey   := cOBDnz
  nCtvrt    := mh_CTVRTzOBDn( nX)
  xCTVRTkey := StrZero( nVybRok, 4) +StrZero( nCtvrt, 1)


  nPracDoObH := fPracDOBA( (file)->cDelkPrDob)[3]
  nPracDoObD := fPracDOBA( (file)->cDelkPrDob)[1]
  nPraDoMsTH := fPracDOBA( (file)->cDelkPrDob)[2]
  nPracDoMsH := nPracDoObH
  nPracDoMsD := nPracDoObD

  IF .not. lPRAVD
    IF nRokNemOD < Year( (file)->dDatNast)
      nRokNemOD :=  Year( (file)->dDatNast)
      i         :=  Month( (file)->dDatNast)
      nObdNemOD := anObdobi[i,1]
    ENDIF
  ENDIF

  nPrcDobaHz := IF( nPracDoObH > 0, nPracDoObH, IF( nPracDoMsH > 0, nPracDoMsH, nPracDobaH))
  nPrcDobaDz := IF( nPracDoObD > 0, nPracDoObD, IF( nPracDoMsD > 0, nPracDoMsD, nPracDobaD))

  nAlgCelOdm := IF( (file)->nAlgCelOdm <> 0, (file)->nAlgCelOdm, aAlgODM[3])
  nPocMesPr  := IF( nPocMesPr = 0, 3, nPocMesPr)
  nPocMesPr  := IF((file)->nAlgCelOdm <> 0, (file)->nPocMesPr, nPocMesPr)
  aDMZodm    := {}

  * 19.11.2012
  drgDBMS:open('druhyMzd',,,,,'druhyMzd_p')
  druhyMzd_p->( adsSetOrder('DRUHYMZD04'), dbSetScope(SCOPE_BOTH, cky), dbgoTop() )

  DO WHILE !DruhyMzd_p ->( Eof())
    IF DruhyMzd_p ->lNapPrCelO
      nQ   := IF( DruhyMzd_p ->nAlgCelOdm = 0, nAlgCelOdm, DruhyMzd_p ->nAlgCelOdm)
      nW   := IF( DruhyMzd_p ->nPocMesPr  = 0, nPocMesPr , DruhyMzd_p ->nPocMesPr)

      ( aTMP := {}, aTMP := { StrZero( DruhyMzd_p ->nDruhMzdy, 4), nQ, nW})
      AAdd( aDMZodm, aTMP)
    ENDIF
    DruhyMzd_p ->( dbSkip())
  ENDDO

RETURN( NIL)


** STATICKÉ - vnitøní funkce
*
** test zda má pracovník pro PP v daném ètvrtletí vypoètenou mzdu
**                           NP v pøedchozím roku vypoètenou mzdu
** (r)
static function fPRACmzdu()
  LOCAL  aRET   := { .F., .F.}
  LOCAL  xKEY, n
  LOCAL  xKEYcp := strZero((in_File)->nosCisPrac,5) +strZero( (in_File)->nporPravZT,3)
  local  xKEYod, xKEYdo
  local  ncnt   := 0

  FOR n := 1 TO 3 step 1
    xKey :=  StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2) +xKEYcp

    IF mzdyit_p->( dbSeek( xKey,, 'mzdyIT08'))
      aRET[1] := .T.
      n := 3
    ENDIF
  NEXT

  xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
  xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

  mzdyit_p->( AdsSetOrder('MZDYIT18')         , ;
              dbSetScope(SCOPE_TOP   , xKEYod), ;
              dbSetScope(SCOPE_BOTTOM, xKEYdo), ;
              dbEval( { || ncnt ++ } )        , ;
              dbclearScope()                    )

  aRET[2] := ( ncnt > 0 )
RETURN( aRET)


*
** založíme, nebo vyprázdníme záznam pro výpoèet prùmìrù
** (r)
static function fZalozREC( newobd)
  LOCAL  xKEY, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM
  LOCAL  cVybObdPP := "", cVybObdNM := ""
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY
  *
  local  nrok, nobdobi

  lSVATKY := ( ctypMZD == "MESICNI ")
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := StrZero( (in_File)->nOsCisPrac,5) +StrZero( (in_File)->nPorPraVzt, 3)
  xKEY   := ACT_OBDn() +xKEYcp

  cVybObdPP :=  StrZero( anCtvrt[ nCtvrt,1], 2) + "/" +StrZero( nVybRok,4) + " - " ;
                 +StrZero( anCtvrt[ nCtvrt,3], 2) + "/" +StrZero( nVybRok,4)

  cVybObdNM :=  StrZero( nObdNemOD,2) + "/" + StrZero( nRokNemOD,4) + " - " ;
                 +StrZero( nObdNemDO,2) + "/" + StrZero( nRokNemDO,4)

  nPocM     := 3

  if out_file = 'msvprumw'
    mh_blankRec( out_file )
  else
    if msvPrum->(dbseek( xkey,, 'PRUMV_03'))
      msvPrum->( dbRlock(), mh_BLANKREC( 'msvPrum' ))
    else
      msvPrum->(dbAppend())
    endif
  endif

  nrok    := Val( Left(newobd,  4))
  nobdobi := Val( Right(newobd, 2))

  (out_File) ->nRok       := nrok
  (out_File) ->nObdobi    := nobdobi
  (out_File) ->cObdobi    := strZero(nobdobi, 2) +"/" +Right( StrZero(nrok, 4), 2)
  (out_file) ->nrokObd    := (nrok*100) + nobdobi
  (out_File) ->nCtvrtleti := mh_CTVRTzOBDn( nobdobi)
  (out_File) ->cCtvrtlRIM := mh_CTVRTzOBDc( nobdobi)

  (out_File) ->cPracovnik := (in_File)->cPracovnik
  (out_File) ->cJmenoRozl := (in_File)->cJmenoRozl
  (out_File) ->cKmenStrPr := (in_File)->cKmenStrPr
  (out_File) ->nOsCisPrac := (in_File)->nOsCisPrac
  (out_File) ->nPorPraVzt := (in_File)->nPorPraVzt
  (out_File) ->cVybObd_P  := cVybObdPP
  (out_File) ->cVybObd_N  := cVybObdNM
  (out_File) ->nDelkPDoby := nPracDoMsH

  (out_File) ->dDatNast   := (in_File)->dDatNast
  (out_File) ->dDatVyst   := (in_File)->dDatVyst
  (out_File) ->lAktivni   := (in_File)->lAktivni
  (out_File) ->lStavem    := (in_File)->lStavem
  (out_File) ->lAutoVypPr := (in_File)->lAutoVypPr
  (out_File) ->nAlgPraPru := (in_File)->nAlgPraPru

  (out_File) ->cRoObCpPPv := (in_File) ->cRoObCpPPv
  (out_File) ->nmsprc_mo  := isNull( (in_File)->sid, 0)
RETURN( NIL)


** (r)
static function F_PrumFND( lSVATKY)
  LOCAL  nDOdpra := 0

  DEFAULT lSVATKY TO .F.

  aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_PRACDNY( nVybRok, X)})
  IF lSVATKY
     aEval( anCtvrt[ nCtvrt],{ |X| nDOdpra += F_SVATKY( nVybRok, X)})
  ENDIF
RETURN( nDOdpra)


*
** PP - nápoèet do promìnných pro výpoèet pracovnì právního prùmìru
** (r)
STATIC FUNCTION fNAPprumPP( lPRAVd )
  local  xKEYcp := strZero( (in_File)->nOsCisPrac,5) +strZero( (in_File)->nPorPraVzt,3)
  LOCAL  xKEY, n, cX, nLen
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lOdp_POL
  LOCAL  nDnyFND
  LOCAL  nDnyHraPS, nHodHraPS
  LOCAL  nOldArea
  LOCAL  anSUMo[6,2]
  LOCAL  lSVATKY
*
  local  dSazbaKDni
  local  nSazba

  DEFAULT lPRAVd TO .F.

  lSVATKY := (ctypMZD == "MESICNI ")
  nDnyFND := F_PrumFND( lSVATKY)

  xKEY      := xCTVRTkey +xKEYcp
  nPocM     := 3
  nDnyHraPS := SysConfig( "Mzdy:nDnyPraPru")

  IF !IsNil( aDMZodm)
    IF !Empty( aDMZodm)
      (out_File) ->nAlgCelOdm := aDMZodm[1,2]
      (out_File) ->nPocMesPr  := aDMZodm[1,3]
    ENDIF
  ENDIF

  IF( (out_File) ->nAlgCelOdm <> 0, CELodm( xKEYcp, aDMZodm), NIL)

// novinka pro nekolik algoritmu vypoctu prumeru
  (out_File) ->nDFondu_PP := nDnyFND
  (out_File) ->nHFondu_PP := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                                        IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                                       , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  (out_File) ->nDFondu_NA := nDnyFND
  (out_File) ->nHFondu_NA := nDnyFND * IF( aAlgHOD[1] = 2, nPracDobaH, ;
                                        IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH ;
                                       , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))
  (out_File) ->nHFondu_OO := nDnyFND * IF( aAlgODM[1] = 2, nPracDobaH, ;
                                        IF( aAlgODM[1] = 3 .and. nPracDoObH = 0, nPracDobaH  ;
                                       , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

  (out_File) ->nDOdpra_PP := 0
  (out_File) ->nHOdpra_PP := 0
  (out_File) ->nDnyNap_NA := 0
  (out_File) ->nHodNap_NA := 0
  (out_File) ->nKcsODMEN  := 0

  if !lPRAVd
    FOR n := 1 TO 3
      anSUMo[1,1] := anSUMo[2,1] := anSUMo[3,1] := anSUMo[4,1] := anSUMo[5,1] := anSUMo[6,1] := 0
      anSUMo[1,2] := anSUMo[2,2] := anSUMo[3,2] := anSUMo[4,2] := anSUMo[5,2] := anSUMo[6,2] := 0

      xKey := StrZero( nVybRok, 4) + StrZero( anCtvrt[nCtvrt, n], 2) +xKEYcp

      anSUMo[1,1] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,1] := anSUMo[1,1]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                                   , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                                    , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      anSUMo[1,2] := IF( aAlgDNU[1] = 4, F_PRACDNY( nVybRok, anCtvrt[nCtvrt, n]), 0)
      anSUMo[2,2] := anSUMo[1,2]  * IF( aAlgHOD[1] = 2, nPracDobaH                                      ;
                                   , IF( aAlgHOD[1] = 3 .and. nPracDoObH = 0, nPracDobaH    ;
                                    , IF( nPracDoObH = 0, nPracDoMsH, nPracDoObH)))

      mzdyit_p->( AdsSetOrder('MZDYIT08')        , ;
                  dbSetScope(SCOPE_BOTH   , xkey), ;
                  dbgoTop()                        )

       DO WHILE !mzdyit_p ->( Eof())
         druhyMzd->( dbseek( left( xkey,6) +strZero( mzdyit_p->ndruhMzdy,4),, 'DRUHYMZD04'))

         IF ( DruhyMZD->nPrNapPpDn+DruhyMZD->nPrNapPpHo+DruhyMZD->nPrNapPpMz  ;
              +DruhyMZD->nPrNapNaDn+DruhyMZD->nPrNapNaHo+DruhyMZD->nPrNapNaMz  ;
               +DruhyMZD->nPrNapRoMz+DruhyMZD->P_KcsPOHSL ) <> 0

           lOdp_POL  := IF( DruhyMZD ->P_KcsPOHSL = 1, .T., .F.)

           (out_file) ->nHFondu_OO -= IF( lOdp_POL, mzdyit_p ->nHodDoklad, 0)
           anSUMo[1,1] -= IF( lOdp_POL .AND. aAlgDNU[1] = 4, mzdyit_p ->nDnyDoklad, 0)
           anSUMo[2,1] -= IF( lOdp_POL .AND. ( aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3), mzdyit_p ->nHodDoklad, 0)

           (out_File) ->nDOdpra_PP += mzdyit_p ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nDnyNap_PP += mzdyit_p ->nDnyDoklad * DruhyMZD->nPrNapPpDn
           (out_File) ->nHOdpra_PP += mzdyit_p ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nHodNap_PP += mzdyit_p ->nHodDoklad * DruhyMZD->nPrNapPpHo
           (out_File) ->nKcsPRACP  += mzdyit_p ->nMzda      * DruhyMZD->nPrNapPpMz
           (out_File) ->nMzdNap_PP += mzdyit_p ->nMzda      * DruhyMZD->nPrNapPpMz
           anSUMo[1,1]          += IF(aAlgDNU[1] <> 4, mzdyit_p->nDnyDoklad*DruhyMZD->nPrNapPpDn, 0)
           anSUMo[2,1]          += IF( aAlgHOD[1] = 1, mzdyit_p->nHodDoklad*DruhyMZD->nPrNapPpHo, 0)
           anSUMo[3,1]          += mzdyit_p ->nMzda      * DruhyMZD->nPrNapPpMz

           (out_File) ->nDnyNap_NA += mzdyit_p ->nDnyDoklad * DruhyMZD->nPrNapNaDn
           (out_File) ->nHodNap_NA += mzdyit_p ->nHodDoklad * DruhyMZD->nPrNapNaHo
           (out_File) ->nMzdNap_NA += mzdyit_p ->nMzda      * DruhyMZD->nPrNapNaMz
           anSUMo[1,2]          += IF(aAlgDNU[1] <> 4, mzdyit_p ->nDnyDoklad*DruhyMZD->nPrNapNaDn, 0)
           anSUMo[2,2]          += IF( aAlgHOD[1] = 1, mzdyit_p ->nHodDoklad*DruhyMZD->nPrNapNaHo, 0)
           anSUMo[3,2]          += mzdyit_p ->nMzda      * DruhyMZD->nPrNapNaMz

           (out_File) ->nKcsODMEN  += ( mzdyit_p ->nMzda*DruhyMZD->nPrNapRoMz / 12 ) * (out_File)->nPocMesPr
           (out_File) ->nHOD_presc += mzdyit_p ->nHodPresc
           (out_File) ->nHOD_presc += mzdyit_p ->nHodPrescS
         ENDIF

         IF mzdyit_p ->nDruhMzdy = 960
           (out_File) ->nDanUleva += mzdyit_p ->nMzda
         ENDIF

         mzdyit_p ->( dbSkip())
       ENDDO

      mzdyit_p ->( dbClearScope())

      cX := Padl( AllTrim( Str( n)), 2, "0")
      * asi nahradit
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nDNY_PP"+cX)), anSUMo[1,1] ))
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nHOD_PP"+cX)), anSUMo[2,1] ))
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nKC_PP" +cX)), anSUMo[3,1] ))
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nDNY_NA"+cX)), anSUMo[1,2] ))
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nHOD_NA"+cX)), anSUMo[2,2] ))
      (out_File) ->( fieldPut( (out_File) ->(fieldPos( "nMZD_NA"+cX)), anSUMo[3,1] ))

      (out_File) ->&( "nDNY_PP"+cX) := anSUMo[1,1]
      (out_File) ->&( "nHOD_PP"+cX) := anSUMo[2,1]
      (out_File) ->&( "nKC_PP" +cX) := anSUMo[3,1]
      (out_File) ->&( "nDNY_NA"+cX) := anSUMo[1,2]
      (out_File) ->&( "nHOD_NA"+cX) := anSUMo[2,2]
      (out_File) ->&( "nMZD_NA"+cX) := anSUMo[3,2]
    NEXT

    (out_File) ->nDNY_PPSUM := (out_File) ->nDNY_PP01 + ;
                               (out_File) ->nDNY_PP02 + ;
                               (out_File) ->nDNY_PP03
    (out_File) ->nHOD_PPSUM := (out_File) ->nHOD_PP01 + ;
                               (out_File) ->nHOD_PP02 + ;
                               (out_File) ->nHOD_PP03
    (out_File) ->nKC_PPSUM  := (out_File) ->nKC_PP01  + ;
                               (out_File) ->nKC_PP02  + ;
                               (out_File) ->nKC_PP03
    (out_File) ->nDNY_NASUM := (out_File) ->nDNY_NA01 + ;
                               (out_File) ->nDNY_NA02 + ;
                               (out_File) ->nDNY_NA03
    (out_File) ->nHOD_NASUM := (out_File) ->nHOD_NA01 + ;
                               (out_File) ->nHOD_NA02 + ;
                               (out_File) ->nHOD_NA03
    (out_File) ->nMZD_NASUM := (out_File) ->nMZD_NA01 + ;
                               (out_File) ->nMZD_NA02 + ;
                               (out_File) ->nMZD_NA03

    (out_File) ->lpravdPod := .f.

  endif

  nHodHraPS := nPracDoMsH * nDnyHraPS

  do case
  case lPRAVd  .or. ((out_File)->nDNY_PPSUM < nDnyHraPS .and. (out_File)->nHOD_PPSUM < nHodHraPS .and. (out_File)->nAlgPraPru = 1 )      //  21
    (out_File) ->nDNY_PPSUM := nDnyFND
    (out_File) ->nHOD_PPSUM := nPracDoMsH *nDnyFND
    (out_File) ->nDNY_NASUM := nDnyFND
    (out_File) ->nHOD_NASUM := nPracDoMsH *nDnyFND

    if Year((in_File)->ddatnast) = (in_File)->nrok .and. Month((in_File)->ddatnast) = (in_File)->nobdobi
      dSazbaKDni := mh_LastODate( (in_File)->nrok, (in_File)->nobdobi)
    else
      if (in_File)->nobdobi = 1
        dSazbaKDni := mh_LastODate( (in_File)->nrok-1, 12)
      else
        dSazbaKDni := mh_LastODate( (in_File)->nrok, (in_File)->nobdobi-1)
      endif
    endif

    do case
    case At( "MESICNI", ctypMZD) <> 0
      (out_File) ->nKC_PPSUM  := if( in_File = 'msprc_mow', mstarindw->nTarSazMes, fSazTar(dSazbaKDni)[2]) * nPocM
      (out_File) ->nMZD_NASUM := if( in_File = 'msprc_mow', mstarindw->nTarSazMes, fSazTar(dSazbaKDni)[2]) * nPocM

    case At( "CASOVA",  ctypMZD) <> 0
      (out_File) ->nKC_PPSUM  := if( in_File = 'msprc_mow', mstarindw->nTarSazHod, fSazTar(dSazbaKDni)[1]) * (out_File) ->nHOD_PPSUM
      (out_File) ->nMZD_NASUM := if( in_File = 'msprc_mow', mstarindw->nTarSazHod, fSazTar(dSazbaKDni)[1]) * (out_File) ->nHOD_NASUM

    otherwise
      (out_File) ->nKC_PPSUM  := if( in_File = 'msprc_mow', mstarindw->nTarSazHod, fSazTar(dSazbaKDni)[1]) * (out_File) ->nHOD_PPSUM
      (out_File) ->nMZD_NASUM := if( in_File = 'msprc_mow', mstarindw->nTarSazHod, fSazTar(dSazbaKDni)[1]) * (out_File) ->nHOD_NASUM

    endcase

    nSazba := fSazZAM('PRCPREHLCI', dSazbaKDni)
    (out_File) ->nKC_PPSUM  += if( nSazba <> 0, Round( (out_File)->nKC_PPSUM  * ( nSazba/100), 0), 0)
    (out_File) ->nMZD_NASUM += if( nSazba <> 0, Round( (out_File)->nMZD_NASUM * ( nSazba/100), 0), 0)

    nSazba := fSazZAM('SAZOSOOHOD', dSazbaKDni)
    (out_File) ->nKC_PPSUM  += if( nSazba <> 0, nSazba, 0)
    (out_File) ->nMZD_NASUM += if( nSazba <> 0, nSazba, 0)

    (out_File) ->lpravdPod  := .t.
    (out_File) ->nAlgPraPru := 1

  case (out_File)->nDNY_PPSUM < nDnyHraPS .and. (out_File)->nHOD_PPSUM < nHodHraPS .and. (out_File)->nAlgPraPru = 2       //  21
    (out_File) ->lpravdPod  := .t.
    (out_File) ->nAlgPraPru := 2

  case (out_File)->nDNY_PPSUM < nDnyHraPS .and. (out_File)->nHOD_PPSUM < nHodHraPS .and. (out_File)->nAlgPraPru = 3       //  21
    (out_File) ->lpravdPod  := .t.
    (out_File) ->nAlgPraPru := 3
   // doøešit aby se prùmìr vzal z pøedchozího období

  otherwise
    (out_File) ->nAlgPraPru := 0
  endcase


RETURN( NIL)


** (r)
static function CELodm( xKEY, aDMZ)
  LOCAL  n
  LOCAL  nCelODM := 0
  LOCAL  xKEYod, xKEYdo
  LOCAL  cOBDod, cOBDdo
  LOCAL  nTYP

  (out_File) ->nKC_ODMcel := 0
  (out_File) ->nKC_ODMroz := 0

  IF !IsNil( aDMZ)
    FOR n := 1 TO Len( aDMZ)
      nTYP := aDMZ[n,2]

      DO CASE
      CASE nTYP = 1
        cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
        cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

      CASE nTYP = 2
        cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
        cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"

      CASE nTYP = 3
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

      CASE nTYP = 4
        DO CASE
        CASE ACT_OBDqn() = 1
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        OTHERWISE
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE

      CASE nTYP = 5
        DO CASE
        CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2 .OR. ACT_OBDqn() = 3
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        CASE ACT_OBDqn() = 4
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"12"
        ENDCASE

      CASE nTYP = 6
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

      CASE nTYP = 7
        DO CASE
        CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2          //4
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"10"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        OTHERWISE
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"09"
        ENDCASE

      CASE nTYP = 8
        DO CASE
        CASE ACT_OBDqn() = 1 .OR. ACT_OBDqn() = 2          //4
          cOBDod := StrZero( ACT_OBDyn() -1, 4) +"07"
          cOBDdo := StrZero( ACT_OBDyn() -1, 4) +"12"
        OTHERWISE
          cOBDod := StrZero( ACT_OBDyn(), 4) +"01"
          cOBDdo := StrZero( ACT_OBDyn(), 4) +"06"
        ENDCASE
      ENDCASE

      xKEYod  := xKEY +aDMZ[n,1] +cOBDod
      xKEYdo  := xKEY +aDMZ[n,1] +cOBDdo
      ncelOdm := 0

      mzdyit_p->( AdsSetOrder('MZDYIT15')                    , ;
                  dbSetScope(SCOPE_TOP   , xKEYod)           , ;
                  dbSetScope(SCOPE_BOTTOM, xKEYdo)           , ;
                  dbgoTop()                                  , ;
                  dbeval( { || ncelOdm += mzdyit_p->nmzda } ), ;
                  dbClearScope()                               )

      mzdyitpr_p->( AdsSetOrder('MZDYITPR15')                    , ;
                  dbSetScope(SCOPE_TOP   , xKEYod)           , ;
                  dbSetScope(SCOPE_BOTTOM, xKEYdo)           , ;
                  dbgoTop()                                  , ;
                  dbeval( { || ncelOdm += mzdyitpr_p->nmzda } ), ;
                  dbClearScope()                               )

      (out_File) ->nKC_ODMcel += nCelODM
      (out_File) ->nKC_ODMroz += ( nCelODM / 12) * aDMZ[n,3]
    NEXT
  ENDIF
RETURN( NIL)


*
** NM - nápoèet do promìnných pro výpoèet prùmìrù pro nemocenskou dávku
** (r)
static function fNAPprumNM( lPRAVd )
  LOCAL  xKEYod, xKEYdo, n, cX, nLen, xKEYcp
  LOCAL  cRokHL_, nPocM, cVybObd := ""
  LOCAL  lNem_KCS, lNem_DNY, lDan_NP
  LOCAL  nDnyFND
  LOCAL  nOldArea
  LOCAL  anSUMo[6]
  LOCAL  lODPOCnem := .T.
  LOCAL  lSVATKY

  DEFAULT lPRAVd TO .F.

  lSVATKY := ( ctypMZD == "MESICNI ")
  nDnyFND := F_PrumFND( lSVATKY)

  xKEYcp := strZero( (in_File)->nOsCisPrac, 5) +strZero( (in_File)->nPorPraVzt, 3)

  (out_File) ->nKcsNEMOC  := 0
  (out_File) ->nKcsDAN_NP := 0

  fKalDnyNM()

  IF !lPRAVd
    anSUMo[1] := anSUMo[2] := anSUMo[3] := anSUMo[4] := anSUMo[5] := anSUMo[6] := 0

    xKEYod := xKEYcp +StrZero( nRokNemOD, 4) +StrZero( nObdNemOD, 2)
    xKEYdo := xKEYcp +StrZero( nRokNemDO, 4) +StrZero( nObdNemDO, 2)

    mzdyit_p->( AdsSetOrder('MZDYIT18')         , ;
                dbSetScope(SCOPE_TOP   , xKEYod), ;
                dbSetScope(SCOPE_BOTTOM, xKEYdo), ;
                dbgoTop()                         )

    DO WHILE !mzdyit_p ->( Eof())
      druhyMzd->( dbSeek( Left( xobdKey,4)    + ;
                           Right( xobdKey,2)  + ;
                            strZero( mzdyit_p->ndruhMzdy,4),, 'DRUHYMZD04'))


      IF ( DruhyMZD ->P_KcsNEMOC +DruhyMZD ->P_KcsHOPRP) != 0
        lNem_KCS  := IF( DruhyMZD ->P_KcsNEMOC = 1, .T., .F.)
        lNem_DNY  := IF( DruhyMZD ->P_KcsHOPRP = 1, .T., .F.)
        lDan_NP   := IF( mzdyit_p ->nDruhMzdy = 500 .OR. mzdyit_p ->nDruhMzdy = 501, .T., .F.)

        // byl vybrán tento mìsíc také pro nemocenské pojištìní ?
        IF !Empty( (out_File) ->dDatVyst)                               ;
            .AND. Month( (out_File) ->dDatVyst) < mzdyit_p ->nObdobi      ;
              .AND. Year( (out_File) ->dDatVyst) <= mzdyit_p ->nRok
          lODPOCnem := .F.
        ENDIF

        IF lODPOCnem
          (out_File) ->nDOdpra_NP -= IF( lNem_DNY, mzdyit_p ->nDnyDoklad, 0)
          anSUMo[5]               -= IF( lNem_DNY, mzdyit_p ->nDnyDoklad, 0)
        ENDIF

        IF lNem_KCS
          (out_File) ->nKcsNEMOC  += mzdyit_p ->nMzda
          anSUMo[6]               += mzdyit_p ->nMzda

          // naèteme si daò pro NP pro pøíslušný mìsíc
          (out_File) ->nKcsDAN_NP := (out_File) ->nKcsDAN_NP +if( lDan_NP, mzdyit_p ->nMzda, 0 )
        ENDIF
      ENDIF
      mzdyit_p ->( dbSkip())
    ENDDO
    mzdyit_p->( dbClearScope())

    (out_File) ->nKDO_NM01  := anSUMo[5]
    (out_File) ->nKC_NM01   := anSUMo[6]

    (out_File) ->nKD_NMSUM  := (out_File) ->nKD_NM01  + ;
                               (out_File) ->nKD_NM02  + ;
                               (out_File) ->nKD_NM03
    (out_File) ->nKDO_NMSUM := (out_File) ->nKDO_NM01 + ;
                               (out_File) ->nKDO_NM02 + ;
                               (out_File) ->nKDO_NM03
    (out_File) ->nKC_NMSUM  := (out_File) ->nKC_NM01  + ;
                               (out_File) ->nKC_NM02  + ;
                               (out_File) ->nKC_NM03

  ELSE
    (out_File) ->nKD_NMSUM := F_KalenFND( nVybRok, nCtvrt)
    (out_File) ->nKC_NMSUM := (out_File) ->nKC_PPSUM
  ENDIF

RETURN( NIL)

** (r)
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

  (out_File) ->nKDSkut    := D_DnyOdDo( dZACAT, dKONEC, "KALE", in_File)

  IF( dZACAT < (out_File) ->dDatNast  , dZACAT := (out_File) ->dDatNast, NIL)
  IF !Empty( (out_File) ->dDatVyst)
    IF( dKONEC > (out_File) ->dDatVyst, dKONEC := (out_File) ->dDatVyst, NIL)
  ENDIF

  (out_File) ->nKD_NM01   := D_DnyOdDo( dZACAT, dKONEC, "KALE", in_File)
  (out_File) ->nDOdpra_NP := (out_File) ->nKD_NM01
RETURN( NIL)


** (r)
STATIC FUNCTION F_KalenFND()
  LOCAL  nDKalen := 0

  aEval( anCtvrt[ nCtvrt],{ |X| nDKalen += F_KALDNY( nVybRok, X)})
RETURN( nDKalen)


*
** výpoèet prùmìrù PP a NP pro pracovníka
** (r)
static function fVYPprprac( typZpr)
  LOCAL  _nM172, _nM013, _nOdmH, _nOdmD, anNem
  LOCAL  nKoefCIST
  LOCAL  nTmpNA, nOdmNA

  _nOdmH := 0
  _nOdmD := 0
  _nM172 := 0
  nTmpNA := 0
  nOdmNA := 0

// PP _ tak‚ algoritmus výpoètu celoroèních odmìn
  nKoefCIST              := ( (out_File)->nHOD_PPSUM - (out_File)->nHOD_presc) / (out_File)->nHFondu_PP
  nKoefCIST              := IF( nKoefCIST > 1, 1, nKoefCIST)
  (out_File)->nKc_ODMcis := (out_File)->nKc_ODMroz * nKoefCIST

  IF aAlgHOD[1] = 1 .OR. aAlgHOD[1] = 2 .OR. aAlgHOD[1] = 3
    _nM172 := Round( IF( (out_File)->nHOD_PPSUM > 0, ( (out_File)->nKC_PPSUM  +(out_File)->nKC_ODMcis) ;
                                                     / (out_File)->nHOD_PPSUM, 0), 2)
    nTmpNA := Round( IF( (out_File)->nHOD_NASUM > 0, ( (out_File)->nMZD_NASUM +(out_File)->nKC_ODMcis) ;
                                                     / (out_File)->nHOD_NASUM, 0), 2)
  ENDIF

  DO CASE
  CASE aAlgODM[1] = 1
    _nOdmH := Mh_RoundNumb( IF( (out_File)->nHOdpra_PP > 0, ;
                                (out_File)->nKcsODMEN / (out_File)->nHOdpra_PP, 0), aAlgODM[2])
    nOdmNA := Mh_RoundNumb( IF( (out_File)->nHOD_NASUM > 0, ;
                                (out_File)->nKcsODMEN / (out_File)->nHOD_NASUM, 0), aAlgODM[2])

  CASE aAlgODM[1] = 2 .or. aAlgODM[1] = 3
    _nOdmH := Mh_RoundNumb( IF( (out_File)->nHFondu_PP > 0, ;
                                (out_File)->nKcsODMEN / (out_File)->nHFondu_PP, 0), aAlgODM[2])
    nOdmNA := Mh_RoundNumb( IF( (out_File)->nHFondu_NA > 0, ;
                                (out_File)->nKcsODMEN / (out_File)->nHFondu_NA, 0), aAlgODM[2])

    DO CASE
    CASE aAlgODM[1] = 2
      _nOdmD := Mh_RoundNumb( _nOdmH * nPracDobaH, aAlgODM[2])

    CASE aAlgODM[1] = 3
      _nOdmD := Mh_RoundNumb( _nOdmH * nPrcDobaHz, aAlgODM[2])

    ENDCASE
  ENDCASE

// PP _ tak a šupnem hodinový prùmìr do souboru, ale nesmí nám pøetéct
  (out_File)->nHodPrumPP := Mh_RoundNumb( IF( _nM172 + _nOdmH > 9999.99, 0,    ;
                                            ( _nM172 + _nOdmH ) * nKoefHM), aAlgHOD[2])
  (out_File)->nHodPrumNA := Mh_RoundNumb( IF( nTmpNA + nOdmNA > 9999.99, 0,    ;
                                            ( nTmpNA + nOdmNA) * nKoefHM), aAlgHOD[2])

  IF nPracDoMsH <> nPracDoObH .AND. nPracDoMsH <> 0 .AND. nPracDoObH <> 0
    (out_File)->nHodPrumPP := Mh_RoundNumb( (out_File)->nHodPrumPP *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
    (out_File)->nHodPrumNA := Mh_RoundNumb( (out_File)->nHodPrumNA *( nPracDoObH/nPracDoMsH), aAlgHOD[2])
  ENDIF

// PP _ respekujeme algoritmus výpoètu deního prùmìru vèetnì celoroèních odmìn
//      a šupnem denní prùmìr do souboru
  (out_File)->nDenPrumPP := VypDENpru( _nM172                  , ;
                                       _nOdmD                  , ;
                                       (out_File)->nDNY_PPSUM  , ;
                                       (out_File)->nKC_PPSUM   , ;
                                       (out_File) ->nKC_ODMcis   )


// NM _ vypoèteme prùmìr pro náhrady za nemocenské pojištìní
  IF (out_File)->nHodPrumPP > 0 .OR. (out_File)->nHodPrumNA > 0
    IF SysConfig( "Mzdy:lNezPrumNA")
      anNem := F_VypPrumNem( (out_File)->nHodPrumNA, 0, 0, nACTrok, .t.)
    ELSE
      anNem := F_VypPrumNem( (out_File)->nHodPrumPP, 0, 0, nACTrok, .t.)
    ENDIF

    (out_File)->nDenVZhruH := anNem[1]
    (out_File)->nDenVZcisH := anNem[2]
    (out_File)->nDenVZcikH := anNem[5]

    (out_File)->nSazDenH_1 := anNem[8]
    (out_File)->nSazDenH_2 := anNem[3]
  ENDIF

// NM _ vypoèteme prùmìr pro nemocenské pojištìní
  IF (out_File)->nKC_NMSUM > 0 .AND. ( (out_File)->nKD_NMSUM + (out_File)->nKDO_NMSUM) > 0
    anNem := F_VypPrumNem( (out_File)->nKC_NMSUM , ;
                           (out_File)->nKD_NMSUM , ;
                           (out_File)->nKDO_NMSUM, nACTrok)

    (out_File)->nDenVZhruN := anNem[1]
    (out_File)->nDenVZcisN := anNem[2]

    (out_File)->nSazDenNiN := Mh_RoundNumb( anNem[3], 32)
    (out_File)->nSazDenVyN := Mh_RoundNumb( anNem[4], 32)

    (out_File)->nDenVZcikN := anNem[5]

    (out_File)->nSazDenVKN := Mh_RoundNumb( anNem[6], 32)
    (out_File)->nSazDenMaN := Mh_RoundNumb( anNem[7], 32)

    (out_File)->nSazDenN_1 := Mh_RoundNumb( anNem[8], 32)
    (out_File)->nSazDenN_2 := Mh_RoundNumb( anNem[3], 32)
    (out_File)->nSazDenN_3 := Mh_RoundNumb( anNem[6], 32)
    (out_File)->nSazDenN_4 := Mh_RoundNumb( anNem[4], 32)
    (out_File)->nSazDenN_5 := 0
    (out_File)->nSazDenM_1 := Mh_RoundNumb( anNem[7], 32)
    (out_File)->nSazDenM_2 := Mh_RoundNumb( anNem[9], 32)
    (out_File)->nSazDenO_1 := Mh_RoundNumb( anNem[7], 32)
    (out_File)->nSazDenO_2 := 0
  ENDIF
  PRUmesMZD()

  (out_File)->nStavZprac := typZpr

RETURN( NIL)


** potøevujem v postvalidate na mzd_prumery_crd
** (r)
function VypDENpru( nHODpru, nODMmzd, nDNYsum, nKCsum, nODMcis)
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


** potøevujem v postvalidate na mzd_prumery_crd
** (r)
function F_VypPrumNem( nKC, nKD, nKDO, nROKlik, lNAHR)
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
  CASE nROKlik == 2012
    nRedHr1 :=  838 * nkoenahr
    nRedHr2 := 1257 * nkoenahr
    nRedHr3 := 2514 * nkoenahr
  CASE nROKlik == 2013
    nRedHr1 :=  863 * nkoenahr
    nRedHr2 := 1295 * nkoenahr
    nRedHr3 := 2589 * nkoenahr
  CASE nROKlik == 2014
    nRedHr1 :=  865 * nkoenahr
    nRedHr2 := 1298 * nkoenahr
    nRedHr3 := 2595 * nkoenahr
  CASE nROKlik == 2015
    nRedHr1 :=  888 * nkoenahr
    nRedHr2 := 1331 * nkoenahr
    nRedHr3 := 2662 * nkoenahr
  CASE nROKlik == 2016
    nRedHr1 :=  901 * nkoenahr
    nRedHr2 := 1351 * nkoenahr
    nRedHr3 := 2701 * nkoenahr
  CASE nROKlik == 2017
    nRedHr1 :=  942 * nkoenahr
    nRedHr2 := 1412 * nkoenahr
    nRedHr3 := 2824 * nkoenahr
  CASE nROKlik == 2018
    nRedHr1 := 1000 * nkoenahr
    nRedHr2 := 1499 * nkoenahr
    nRedHr3 := 2998 * nkoenahr
  CASE nROKlik == 2019
    nRedHr1 := 1090 * nkoenahr
    nRedHr2 := 1635 * nkoenahr
    nRedHr3 := 3270 * nkoenahr
  CASE nROKlik == 2020
    nRedHr1 := 1162 * nkoenahr
    nRedHr2 := 1742 * nkoenahr
    nRedHr3 := 3484 * nkoenahr
  CASE nROKlik == 2021
    nRedHr1 := 1182 * nkoenahr
    nRedHr2 := 1773 * nkoenahr
    nRedHr3 := 3545 * nkoenahr
  ENDCASE

  anPruNem[1] := anPruNem[2] := anPruNem[3] := anPruNem[4] := anPruNem[5] := anPruNem[6] := anPruNem[7] :=anPruNem[8] := anPruNem[9] := 0

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


** (r)
static function PRUmesMZD()
  LOCAL nX, nVAL
  LOCAL aX
  LOCAL nPruDNUmes, nHodCELKEM
  LOCAL nZaklad
  LOCAL nSoc := 0, nZdr := 0, nDan := 0, nPojOrg := 0
  LOCAL nRECms     := (in_File)->( Recno())
  LOCAL nSupHrMzda := 0

  IF nPracDoMsD <> 0
    nHodCELKEM :=  nKoefHOmes * nPraDoMsTH
  ELSE
    nHodCELKEM :=  nKoefHOmes * nPraDobaTH
  ENDIF

  nHodCELKEM := Mh_RoundNumb( nHodCELKEM,222)
  (out_file)->nPruMesMzH := Mh_RoundNumb( (out_file)->nHodPrumPP *nHodCELKEM, 32)

  nSoc := Round( ( ( (out_file)->nPruMesMzH * nPROCsocZ) / 100) + 0.49, 0)
  nZdr := Round( ( ( (out_file)->nPruMesMzH * nPROCzdrZ) / 100) + 0.49, 0)

  nPojOrg := ( fnOdvSocOR() + fnOdvZdrOR()) / 100

  nSupHrMzda := (out_file)->nPruMesMzH + ( (out_file)->nPruMesMzH * nPojOrg)
  nSupHrMzda := Mh_RoundNumb( nSupHrMzda, 32)

  nVAL := nSupHrMzda - (in_File)->nOdpocOBD
  nDan := fDanVyp( nVal, nACTrok)
  nDan := IF( nDan >= (in_File)->nDanUlObd, nDan - (in_File)->nDanUlObd, 0)

  (out_file)->nPruMesMzC := (out_file)->nPruMesMzH  - nSoc - nZdr - nDan

  (in_File)->( dbGoTo( nRECms))
RETURN( NIL)


*
** vnitøní funkce pro zpracování prùmìrù pozbírano y DOSu
** (r)
static function ACT_OBDn()   ;  return strZero(uctOBDOBI:MZD:nROK, 4) +strZero(uctOBDOBI:MZD:nOBDOBI, 2)
static function ACT_OBDyn()  ;  return uctOBDOBI:MZD:nROK
static function ACT_OBDon()  ;  return uctOBDOBI:MZD:nOBDOBI
static function ACT_OBDqn()
  local  aQ := { 1,1,1,2,2,2,3,3,3,4,4,4 }
return( aQ[ACT_OBDon()] )

function D_DnyOdDo( dDatOd, dDatDo, cTYP, cAlias)
  LOCAL nRokOd := Year( dDatOd)
  LOCAL nRokDo := Year( dDatDo)
  LOCAL nMesOd := Month( dDatOd)
  LOCAL nMesDo := Month( dDatDo)
  LOCAL nDenOd := Day( dDatOd)
  LOCAL nDenDo := Day( dDatDo)
  LOCAL nDNY   := 0
  LOCAL nR, nM, nMesDoTm, nDenDoTm, nDenLast

  default cAlias to 'msprc_mo'

  FOR nR := nRokOd TO nRokDo
    nMesDoTm := IF( nRokDo == nR, nMesDo, 12)
    FOR nM := nMesOd TO nMesDoTm
      nDenLast := LastDayOM( CtoD( "01/" +StrZero( nM, 2) +"/" +Str( nR, 4)))
      nDenDoTm := IF( nRokDo == nR .AND. nMesDoTm == nM , nDenDo, nDenLast)

      DO CASE
      CASE cTYP == "PRAC"
        nDNY  += F_PrcDnyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
      CASE cTYP == "SVAT"
        nDNY  += F_SvatkyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
      CASE cTYP == "VOLN"
        nDNY  += F_VolDnyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
      CASE cTYP == "KALE"
        nDNY  += F_PrcDnyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
        nDNY  += F_SvatkyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
        nDNY  += F_VolDnyOD( nR, nM, nDenOd, nDenDoTm, cAlias)
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
  CASE nROKvyp = 2012
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2013
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2014
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2015
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2016
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2017
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2018
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2019
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2020
    aSAZdan := { { 0, 0, 0, 0.15 } }
  CASE nROKvyp = 2021
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


//   funkce vrací vybrané období pro prùmìry v textovém formátu
//      aret[1]   - výpoèet pro dané ètvrtletí
//      aret[2]   - rozsah období pro PP prùmìry
//      aret[3]   - rozsah období pro NM prùmìry

function fRetVybObdPR()
  local aret := {'','', ''}
  local cOBDnz

  cOBDnz := (out_file)->cobdobi


  aret[1] :=  mh_CTVRTzOBDc( (out_file)->nobdobi) + "/" + StrZero((out_file)->nrok)
  aret[2] :=  Right( MZD_ObdPrumPP( cOBDnz)[1],2) + "/" +Left( MZD_ObdPrumPP( cOBDnz)[2],4) + " - " ;
                 +Right( MZD_ObdPrumPP( cOBDnz)[2],2) + "/" +StrZero( nVybRok,4)

  aret[3] :=  Right( MZD_ObdPrumNM( cOBDnz)[1],2) + "/" + Left(  MZD_ObdPrumNM( cOBDnz)[1],4) + " - " ;
                 +Right( MZD_ObdPrumNM( cOBDnz)[2],2) + "/" + Left(  MZD_ObdPrumNM( cOBDnz)[2],4)

return aret