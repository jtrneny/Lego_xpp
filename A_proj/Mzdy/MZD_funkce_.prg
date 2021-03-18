#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


# DEFINE    COMPILE(c)         &("{||" + c + "}")
//# TRANSLATE SET_filter(<c>) => ( AdsSetOrder(0), dbSETFILTER( COMPILE(<c>)), dbGOTOP() )


// ----------------- Vrátí procento odvodu pro soc.pojištìní za pracovníka -----
FUNCTION fOdvSocZA( nIt)
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocZa")

RETURN( Val( mh_Token( cX, ",", nIt)))


// ----------------- Vrátí procento odvodu pro soc.pojištìní za organizaci -----
FUNCTION fOdvSocOR( nIt)
  LOCAL cX, firstDay

  firstDay  := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
  cX := SysConfig( "Mzdy:cnOdvSocOr", firstDay)

RETURN( Val( mh_Token( cX, ",", nIt)))


// ----------------- Vrátí pole procent odvodu pro soc.pojištìní za organizaci -
FUNCTION faOdvSocOR()
  LOCAL cX, firstDay
  LOCAL aX := { 0, 0, 0 }
  LOCAL n

  firstDay  := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
  cX := SysConfig( "Mzdy:cnOdvSocOr", firstDay)

  FOR n := 1 TO 3      ; aX[n] := Val( mh_Token( cX, ",", n))
  NEXT

RETURN( aX)


// ----------------- Vrátí procento odvodu z pole pro soc.pojištìní za organizaci -
FUNCTION fnOdvSocOR()
  LOCAL cX, firstDay
  LOCAL aX := {}
  LOCAL n, ret := 0

  firstDay  := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
  cX := SysConfig( "Mzdy:cnOdvSocOr", firstDay)

  aX := mh_Token( cX)

  FOR n := 1 TO 3        ;       ret += Val( aX[n])
  NEXT

RETURN( ret)



// ----------------- Vrátí pole procent odvodu pro soc.pojištìní za pracovn. ---
FUNCTION faOdvSocZA()
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocZa")
  LOCAL aX := { 0, 0, 0 }
  LOCAL n, pa

  pa := mh_Token( cX )

  for n := 1 to len( pa) step 1
    aX[n] := val( pa[n])
  next
RETURN( aX)


// ----------------- Vrátí pole procent odvodu pro soc.pojištìní za pracovn. ---
FUNCTION fnOdvSocZA( par)
  LOCAL cX := SysConfig( "Mzdy:cnOdvSocZa")
  LOCAL aX := { 0, 0, 0 }
  LOCAL n, pa, ret := 0

  default par to 0

  pa := mh_Token( cX )

  for n := 1 to len( pa) step 1
    aX[n] := val( pa[n])
  next

  do case
  case  ret = 0
    ret :=  aX[1] +aX[2] +aX[3]
  case  ret = 4
    ret :=  aX[1] +aX[2]
  case  ret = 5
    ret :=  aX[2] +aX[3]
  otherwise
    ret := aX[ret]
  endcase


RETURN( ret)


// ----------------- Vrátí procento odvodu z pro zdr.pojištìní za organizaci -
FUNCTION fnOdvZdrOR()

RETURN(SysConfig( "Mzdy:nOdvZdrOrg"))


// ----------------- Vrátí procento odvodu z pro zdr.pojištìní za zamìstnance -
FUNCTION fnOdvZdrZA()

RETURN(SysConfig( "Mzdy:nOdvZdrZam"))


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

    CASE  uctOBDOBI:MZD:nROK == 2006 .OR. uctOBDOBI:MZD:nROK == 2007
      DO CASE
      CASE nVal <= 121200   ;   nDan := nVal * 0.12
      CASE nVal <= 218400   ;   nDan := 14544 +(( nVal - 121200) * 0.19)
      CASE nVal <= 331200   ;   nDan := 33012 +(( nVal - 218400) * 0.25)
      OTHERWISE             ;   nDan := 61212 +(( nVal - 331200) * 0.32)
      ENDCASE

    CASE uctOBDOBI:MZD:nROK == 2008 .OR. uctOBDOBI:MZD:nROK == 2009                     ;
           .OR. uctOBDOBI:MZD:nROK == 2010 .OR. uctOBDOBI:MZD:nROK == 2011              ;
             .OR. uctOBDOBI:MZD:nROK == 2012 .OR. uctOBDOBI:MZD:nROK == 2013            ;
               .OR. uctOBDOBI:MZD:nROK == 2014 .OR. uctOBDOBI:MZD:nROK == 2015          ;
                .OR. uctOBDOBI:MZD:nROK == 2016 .OR. uctOBDOBI:MZD:nROK == 2017         ;
                 .OR. uctOBDOBI:MZD:nROK == 2018 .OR. uctOBDOBI:MZD:nROK == 2019        ;
                   .OR. uctOBDOBI:MZD:nROK == 2020
      nDan := nVal * 0.15

    CASE uctOBDOBI:MZD:nROK == 2021
      nDan := nVal * 0.15

    ENDCASE

    nRetVal := Round( nDan + 0.49, 0)

  ENDIF

RETURN( nRetVal)



// Pozor zde by se mìl dát možnost zadat jako parametr soubor file
// pøidat do volání funkce druhý parametr)


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

  cTAG := C_PRACDO->( AdsSetOrder( 1))
  IF C_PRACDO->( dbSeek( Upper( cDOBA)))
    aRET[1] := C_PRACDO->nDnyTyden
    aRET[2] := C_PRACDO->nHodTyden
    aRET[3] := C_PRACDO->nHodDen
  ENDIF
  C_PRACDO->( AdsSetOrder( cTAG))

RETURN( aRET)


// ----------------- Zjištìní pøednastavených sazeb pro tarify -----------------
FUNCTION fSazTAR( dDATUM, filems)
  local aRET := { 0, 0, '', '', '' }
  local cTAG
  local xKEYod, xKEYdo
  local nasel := .f.

  DEFAULT dDATUM TO Date()      //   cTOd( "  /  /    " )
  DEFAULT filems TO 'MSPRC_MO'

  drgDBMS:open('mstarhro',,,,,'mstarhroT')
  drgDBMS:open('mstarind',,,,,'mstarindT')

  if upper(filemS) = 'OSOBY_S'
     mstarindT->( AdsSetOrder('C_TARIN14'))

     filtr := Format("ncisOsoby = %% .and. nPorPraVzt = 0 .and. dPlatTarOd >= '%%' .and. dPlatTarOd  <= '%%' .and. ( Empty(dPlatTarDo) .or. dPlatTarDo <= '%%' )",  ;
                    { (filems)->ncisOsoby, "01.01.2000", dDATUM, dDATUM})

     mstarindT->( ads_setaof(filtr), dbGoTop())

*     nasel := mstarindT->( ads_getKeyCount(1)) > 0
     nasel := ( mstarindT->( mh_countRec()) > 0 )

     if nasel
       aRET[1] := mstarindT ->nTarSazHod
       aRET[2] := mstarindT ->nTarSazMes
       aRET[3] := mstarindT ->cTypTarMzd
       aRET[4] := mstarindT ->cTarifTrid
       aRET[5] := mstarindT ->cTarifStup
     endif

     return aRET
   endif


  DO CASE
  CASE (filems)->cTypTarPou == "HROMADNY"     ;
         .OR. (filems)->cTypTarPou == "INDIVIDU"
    mstarindT->( AdsSetOrder('C_TARIN14'))
*    filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %% .and. dPlatTarOd >= '%%' .and. dPlatTarOd  <= '%%' .and.( dPlatTarDo = '%%' .or. dPlatTarDo <= '%%' )",  ;
*                    { msprc_mo->noscisprac, msprc_mo->nporpravzt, "01.01.2000", dDATUM, "  .  .    ", dDATUM})

    filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %% .and. dPlatTarOd >= '%%' .and. dPlatTarOd  <= '%%' .and. ( Empty(dPlatTarDo) .or. dPlatTarDo <= '%%' )",  ;
                    { (filems)->noscisprac, (filems)->nporpravzt, "01.01.2000", dDATUM, dDATUM})
    mstarindT->( ads_setaof(filtr), dbGoTop())

*    nasel := mstarindT->( ads_getKeyCount(1)) > 0
    nasel := ( mstarindT->( mh_countRec()) > 0 )

    if nasel
      aRET[1] := mstarindT ->nTarSazHod
      aRET[2] := mstarindT ->nTarSazMes
      aRET[3] := mstarindT ->cTypTarMzd
      aRET[4] := mstarindT ->cTarifTrid
      aRET[5] := mstarindT ->cTarifStup
    endif

    if (filems)->cTypTarPou == "HROMADNY"
      mstarhroT->( AdsSetOrder('C_TARHR9 '))
      filtr := Format("cTarifTrid = '%%' .and. cTarifStup = '%%' .and. cDelkPrDob = '%%' .and. dPlatTarOd >= '%%' .and. dPlatTarOd <= '%%'.and.( Empty(dPlatTarDo) .or. dPlatTarDo <= '%%' )",;
                      { mstarindT->cTarifTrid, mstarindT->cTarifStup, mstarindT->cDelkPrDob,"01.01.2000", dDATUM,  dDATUM})
      mstarhroT->( ads_setaof(filtr), dbGoTop())

*      nasel := mstarhroT->( ads_getKeyCount(1)) > 0
      nasel := ( mstarhroT->( mh_countRec()) > 0 )

      if nasel
        aRET[1] := mstarhroT->nTarSazHod
        aRET[2] := mstarhroT->nTarSazMes
      endif

/*
    cTAG   := mstarindT ->( AdsSetOrder())
    xKEYod := StrZero( MSPRC_MO ->nOsCisPrac) +StrZero( MSPRC_MO ->nPorPraVzt) ;
               +DtoS( CtoD( "01/01/2001"))
    xKEYdo := StrZero( MSPRC_MO ->nOsCisPrac) +StrZero( MSPRC_MO ->nPorPraVzt) ;
               +DtoS( dDATUM)
    mstarindT->( AdsSetOrder(4),                                                ;
                ADS_SetScope( SCOPE_TOP, xKEYod),                              ;
                ADS_SetScope( SCOPE_BOTTOM, xKEYdo),                           ;
                dbGoBotTom())

    mstarindT->( ADS_ClearScope( SCOPE_TOP),                                    ;
                 ADS_ClearScope( SCOPE_BOTTOM),                                 ;
                 AdsSetOrder(cTAG))

    if msprc_mo ->cTypTarPou == "HROMADNY"
      cTAG   := mstarhroT->( AdsSetOrder())
      xKEYod := Upper( mstarindT->cTarifTrid) +Upper( mstarindT->cTarifStup);
                 +Upper( mstarindT->cDelkPrDob) +DtoS( CtoD( "01/01/2001"))
      xKEYdo := Upper( mstarindT->cTarifTrid) +Upper( mstarindT->cTarifStup);
                 +Upper( mstarindT->cDelkPrDob) +DtoS( dDATUM)
      mstarhroT->( AdsSetOrder(2),                                              ;
                   ADS_SetScope( SCOPE_TOP, xKEYod),                            ;
                   ADS_SetScope( SCOPE_BOTTOM, xKEYdo),                         ;
                   dbGoBotTom())

      aRET[1] := mstarhroT->nTarSazHod
      aRET[2] := mstarhroT->nTarSazMes

      mstarhroT->( ADS_ClearScope( SCOPE_TOP),                                  ;
                   ADS_ClearScope( SCOPE_BOTTOM),                               ;
                   AdsSetOrder(cTAG))
*/
    endif
  otherwise
    mstarindT->( AdsSetOrder('C_TARIN14'))
    filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %% .and. dPlatTarOd >= '%%' .and. dPlatTarOd  <= '%%'.and.( Empty(dPlatTarDo) .or. dPlatTarDo <= '%%' )",  ;
                    { (filems)->noscisprac, (filems)->nporpravzt, "01.01.2000", dDATUM, dDATUM})
*    filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %% .and. dPlatTarOd >= '%%' .and. dPlatTarOd  <= '%%'",;
*                    { msprc_mo->noscisprac, msprc_mo->nporpravzt, "01.01.2000", dDATUM})
    mstarindT->( ads_setaof(filtr), dbGoTop())

*    nasel := mstarindT->( ads_getKeyCount(1)) > 0
    nasel := ( mstarindT->( mh_countRec()) > 0 )

    if .not. nasel
      filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %%" , ;
                        {(filems)->noscisprac, (filems)->nporpravzt})
      mstarindT->( ads_setaof(filtr), dbGoTop())

*      nasel := mstarindT->( ads_getKeyCount(1)) > 0
      nasel := ( mstarindT->( mh_countRec()) > 0 )

    endif

    if nasel
      aRET[1] := mstarindT ->nTarSazHod
      aRET[2] := mstarindT ->nTarSazMes
      aRET[3] := mstarindT ->cTypTarMzd
      aRET[4] := mstarindT ->cTarifTrid
      aRET[5] := mstarindT ->cTarifStup
    endif

  endcase

return( aRET)


// ----------------- Zjištìní pøednastavených sazeb pracovníka------------------
FUNCTION fSazZAM( TYPSAZ, dDATUM, filems, nosCISprac, nporPRAvzt)
  local nRET := 0
  local typ

  DEFAULT TYPSAZ TO ''            // cTOd( "  /  /    " )
  DEFAULT dDATUM TO Date()        // cTOd( "  /  /    " )
  DEFAULT filems TO 'MSPRC_MO'

  default nosCISprac to (filems)->noscisprac
  default nporPRAvzt to (filems)->nporpravzt

  TYPSAZ := Upper( TYPSAZ)
  typ    := Alltrim( TYPSAZ)

  drgDBMS:open('MSSAZZAM')
  MSSAZZAM->( AdsSetOrder('MSSAZZAM12'))

  if Lower(Right(typ,1)) == 'w'
    TYPSAZ := Left( typ, Len( typ)-1)
    dDATUM := fDatPor()
  endif

  filtr := Format("nOsCisPrac = %% .and. nPorPraVzt = %% .and. cTypSazby = '%%' .and. dPlatSazOd >= '%%' .and. dPlatSazOd  <= '%%' .and. ( Empty(dPlatSazDo) .or. dPlatSazDo <= '%%' )",  ;
                  { nosCISprac, nporPRAvzt, TYPSAZ, "01.01.2000", dDATUM, dDATUM})
  mssazzam->( ads_setaof(filtr), dbGoTop())

*  nasel := mssazzam->( ads_getKeyCount(1)) > 0
  nasel := ( mssazzam->( mh_countRec()) > 0 )

  if nasel
    nRET := mssazzam ->nSazba
  endif

  msSAZzam->( ads_clearAof())
RETURN( nRET)

*
** vrátí aktuální libovolnou hodnotu z msvPrum dle parametru cfieldName
** základní klíèe nrok, nobdobi, noscisPrac, nporPraVzt získá z msPrc_mo
function fSazPRM( cfieldName )
  local  retVal := 0
  local  npos, ckey
  *
  ** msPrc_mo musí být otevøený a napozicovaný z konkrétní èinnosti
     if select( 'msPrc_mo') <> 0
    if( select( 'msvPrum' ) = 0, drgDBMS:open( 'msvPrum' ), nil )

    * našel požadovaný prvek v souboru msvPrum ? - pozor pokud nenajde vrací 0 !!!
    if ( npos := msvPrum->(FieldPos( cfieldName ))) <> 0

      ckey := strZero( msPrc_mo->nrok      , 4) +strZero( msPrc_mo->nobdobi   , 2) + ;
              strZero( msPrc_mo->nosCisPrac, 5) +strZero( msPrc_mo->nporPraVzt, 3)

      msvPrum->( dbseek( ckey,,'PRUMV_03'))
      retVal := msvPrum->( FieldGet( npos ))
    endif
  endif
return retVal


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

/*
ne pøesunuto do mzd_kmenove_.prg fce ModiMsPrc()
  (cALIAS)->lStavem := IF( Empty( (cALIAS)->dDatVyst), .T.                                 ;
                        , IF( Year( (cALIAS)->dDatVyst) > uctOBDOBI:MZD:nROK, .T.          ;
                         , IF( Month( (cALIAS)->dDatVyst) >= uctOBDOBI:MZD:nOBDOBI .AND.   ;
                                Year( (cALIAS)->dDatVyst) = uctOBDOBI:MZD:nROK, .T., .F.)))
*/

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
  LOCAL  cTAG := UcetSys ->( AdsSetOrder())

  UCETSYS->( AdsSetOrder(3),                                 ;
             ADS_SetScope( SCOPE_TOP, Upper( cULOHA)),       ;
             ADS_SetScope( SCOPE_BOTTOM, Upper( cULOHA)),    ;
             dbGoBotTom())

  cRET := StrZero( UCETSYS->nROK,4) +StrZero( UCETSYS->nOBDOBI,2)

  UCETSYS->( ADS_ClearScope( SCOPE_TOP),                     ;
             ADS_ClearScope( SCOPE_BOTTOM),                  ;
             AdsSetOrder(cTAG),                              ;
             dbGoTo(nREC))

RETURN( cRET)


// ----------------- Vrátí období ve tvaru MM/RR z datumu-----------------------
FUNCTION COBDzDAT( dDATE)
RETURN( StrZero(Month(dDATE),2) +'/' +Right(AllTrim(Str(Year(dDATE),4)),2))


function RozDATvOB(dNastup, dVystup, rok, obd)
  local  aRETURN := { CtoD( "  /  /  "), CtoD( "  /  /  ")}
  local  dtmpZ, dtmpK

  default dNastup to msprc_mo->dDatNast
  default dVystup to msprc_mo->dDatVyst
  default rok     to msprc_mo->nrok
  default obd     to msprc_mo->nobdobi

  dtmpZ := mh_FirstODate( rok, obd)
  dtmpK := mh_LastODate( rok, obd)

  aRETURN[1] := if( dNastup < dtmpZ, dtmpZ, if( dNastup <= dtmpK, dNastup, CtoD('  .  .    ')))

  do case
  case Empty( dVystup)           ;    aRETURN[2] := dtmpK
  case .not. Empty(aRETURN[1])   ;    aRETURN[2] := if( dVystup < dtmpZ, dVystup, dtmpZ)
  otherwise                      ;    aRETURN[2] :=  CtoD('  .  .    ')
  endcase

  if( aRETURN[2] <  aRETURN[1], aRETURN[1] := aRETURN[2] :=  CtoD('  .  .    '), nil)

RETURN( aRETURN)


*
* kalendáøní dny v mìsíci
function F_kalDny( nROK, nMESIC )
  return mh_LastDayOM( CtoD( "01/" +Str( nMESIC,2) + "/" +Str( nROK)))


* pracovní dny v mìsíci
FUNCTION F_PracDny( nROK, nMESIC, cALIAS)
  LOCAL  cROK := STR( nROK), cMESIC := STR( nMESIC)
  LOCAL  cDat
  LOCAL  dDat1, dDat2
  LOCAL  nX, n
  LOCAL  nPracDny := 0
  LOCAL  nDnPD
  LOCAL  cOLDarea := Alias()

* ROK musi byt ctyrmistny numeric
* MESIC musi byt numeric

 DEFAULT cALIAS TO "MsPrc_Mo"

 drgDBMS:open( 'C_Svatky' )
 nDnPD := fPracDOBA( ( cALIAS) ->cDelkPrDob)[1]

  dDat1 := CTOD( "1." + cMESIC + "." +cROK)
  IF nMESIC = 12
    dDat2 := CTOD( "1." + "1." + STR( nROK+1, 4))
  ELSE
    dDat2 := CTOD( "1." + STR( nMESIC+1, 2) + "." + cROK)
  ENDIF
  nX := dDat2 - dDat1

  FOR n = 1 TO nX
    cDat := Str( n, 2) + "." + cMESIC + "." + cROK
    IF ( Left( CDOW( CTOD( cDat)), 2) = "So" .AND. nDnPD <= 5)           ;
                          .OR. ( Left( CDOW( CTOD( cDat)), 2) = "Ne" .AND. nDnPD <= 6)
    ELSE
     nPracDny := nPracDny + 1
    ENDIF
  NEXT n

  nPracDny := nPracDny - F_Svatky( nROK, nMESIC, cALIAS)
RETURN( nPracDny)


* svátky v mìsíci
FUNCTION F_Svatky( nROK, nMESIC, cALIAS)
  LOCAL  xKEY
  LOCAL  nSvatky := 0
  LOCAL  nOldAREA := Alias()
  LOCAL  nDnPD

  DEFAULT cALIAS TO "MsPrc_Mo"

  drgDBMS:open( 'C_Svatky' )  ;  c_svatky->(AdsSetOrder(' C_SVATKY01'))

  nDnPD := fPracDOBA( ( cALIAS) ->cDelkPrDob)[1]

  xKEY := StrZero( nROK, 4) +StrZero( nMESIC, 2)

  c_svatky->(dbsetscope(SCOPE_BOTH,xkey), dbgotop())

  DO WHILE !C_Svatky ->( Eof())
    IF ( LEFT( CDOW( C_Svatky ->dDatum), 2) = "So" .AND. nDnPD <= 5)          ;
                    .OR. ( LEFT( CDOW( C_Svatky ->dDatum), 2) = "Ne" .AND. nDnPD <= 6)
    ELSE
      nSvatky++
    ENDIF
    C_Svatky ->( dbSkip())
  ENDDO

  C_Svatky ->(dbclearscope())
RETURN( nSvatky)


* pracovní dny v rozsahu d_OD - d_DO
function Fx_prcDnyOD( ddenOD, ddenDO, lminusSvatky )
  local  nDnPD     := fPracDOBA( msprc_mo ->cDelkPrDob)[1]
  local  npracDnOD := 0
  local  ddenOD_or := ddenOD
  local  cc

  default lminusSvatky to .t.

  do while (ddenDO >= ddenOD)
    cc := lower( left( CDow(ddenOD), 2 ))

    if ( cc = 'so' .and. nDnPD <= 5) .or. ( cc = 'ne' .and. nDnPD <= 6 )
    else
      npracDnOD := npracDnOD +1
    endif
    ddenOD++
  enddo

  if npracDnOD > 0
    npracDnOD := max(0, npracDnOD -if( lminusSvatky, Fx_svatkyOD(ddenOD_or, ddenDO), 0))
  endif
return npracDnOD


* volné dny v rozsahu dOD - dDO
function Fx_volDnyOD( ddenOD, ddenDO )
  local  nDnPD   := fPracDOBA( msprc_mo->cDelkPrDob)[1]
  local  nVolDny := 0, cc

  do while (ddenDO >= ddenOD)
    cc := lower( left( CDow(ddenOD), 2 ))

    if ( cc = 'so' .and. nDnPD <= 5) .or. ( cc = 'ne' .and. nDnPD <= 6 )
      nVolDny := nVolDny +1
    endif
    ddenOD++
  enddo
return nVolDny

* svátky v rozsahu dOD - dDO
function Fx_svatkyOD( ddenOD, ddenDO )
  local  nDnPD   := fPracDOBA( msprc_mo->cDelkPrDob)[1]
  local  cky_OD  := strZero( year( ddenOD),4) +strZero( month( ddenOD),2)
  local  cky_DO  := strZero( year( ddenDO),4) +strZero( month( ddenDO),2)
  local  nSvatky := 0, cc

  drgDBMS:open( 'c_svatky' )
  c_svatky->( ordSetFocus( 'C_SVATKY03' )     , ;
              dbsetscope(SCOPE_TOP   , cky_OD), ;
              dbsetscope(SCOPE_BOTTOM, cky_DO), ;
              dbgotop()                         )

  do while .not. c_svatky->(eof())
    if c_svatky->ddatum >= ddenOD .and. c_svatky->ddatum <= ddenDO
      cc := lower( left( CDow(c_svatky->ddatum), 2 ))

      if ( cc = 'so' .and. nDnPD <= 5) .or. ( cc = 'ne' .and. nDnPD <= 6 )
      else
        nSvatky++
      endif
    endif
    c_svatky->(dbskip())
  enddo

  c_svatky->(dbClearscope())
return nSvatky


FUNCTION F_prcDnyOD( nROK, nMESIC, nDen_OD, nDen_DO, cALIAS)
  LOCAL  n
  LOCAL  cROK := STR( nROK),  cMESIC := STR( nMESIC)
  LOCAL  nPracDnOD := 0
  LOCAL  cDat
  LOCAL  nDnPD
  LOCAL  cOLDarea := Alias()

* ROK musi byt ctyrmistny numeric
* MESIC musi byt numeric

  DEFAULT cALIAS TO "MsPrc_Mo"

  drgDBMS:open( 'C_Svatky' )  ;  c_svatky->(AdsSetOrder(' C_SVATKY01'))

  nDnPD := fPracDOBA( (cALIAS) ->cDelkPrDob)[1]

  FOR n := nDen_OD TO nDen_DO
    cDat := STR( n, 2) + "."+ cMESIC + "." + cROK
    IF ( Left( CDOW( CTOD( cDat)), 2) = "So" .AND. nDnPD <= 5)              ;
        .OR. ( Left( CDOW( CTOD( cDat)), 2) = "Ne" .AND. nDnPD <= 6)
    ELSE
      nPracDnOD++
    ENDIF
  NEXT
  nPracDnOD := nPracDnOD - F_SvatkyOD( nROK, nMESIC, nDen_OD, nDen_DO, cALIAS)

  dbSelectArea( cOLDarea)
RETURN( nPracDnOD)


FUNCTION F_SvatkyOD( nROK, nMESIC, nDen_OD, nDen_DO, cALIAS)
  LOCAL  xKEY     := strZero( nrok, 4) +strZero( nmesic,2)
  LOCAL  nSvatky  := 0
  LOCAL  nOldAREA := Alias()
  LOCAL  nDnPD

  DEFAULT cALIAS TO "MsPrc_Mo"

  drgDBMS:open( 'C_Svatky' )
  c_svatky->( ordSetFocus( 'C_SVATKY03' ), ;
              dbsetscope(SCOPE_BOTH,xkey), dbgotop())


  nDnPD := fPracDOBA( ( cALIAS) ->cDelkPrDob)[1]

  DO WHILE !C_Svatky ->( Eof())
    IF C_Svatky ->nDEN >= nDen_OD .AND. C_Svatky ->nDEN <= nDen_DO
      IF ( LEFT( CDOW( C_Svatky ->dDatum), 2) = "So" .AND. nDnPD <= 5)                 ;
         .OR. ( LEFT( CDOW( C_Svatky ->dDatum), 2) = "Ne" .AND. nDnPD <= 6)
      ELSE
        nSvatky++
      ENDIF
    ENDIF
    C_Svatky ->( dbSkip())
  ENDDO
  C_Svatky ->( dbClearScope())

  dbSelectAREA( nOldAREA)
RETURN( nSvatky)


FUNCTION F_VolDnyOD( nROK, nMESIC, nDen_OD, nDen_DO, cALIAS)
  LOCAL  n
  LOCAL  cROK := STR( nROK), cMESIC := STR( nMESIC)
  LOCAL  nVolDny := 0
  LOCAL  cDat
  LOCAL  nDnPD
  LOCAL  cOLDarea := Alias()

* ROK musi byt ctyrmistny numeric
* MESIC musi byt numeric

  DEFAULT cALIAS TO "MsPrc_Mo"

  drgDBMS:open( "C_Svatky" )
  nDnPD := fPracDOBA( ( cALIAS) ->cDelkPrDob)[1]

  FOR n = nDen_OD TO nDen_DO
    cDAT := STR( n, 2) + "." + cMESIC + "." + cROK
    IF ( Left( CDOW( CTOD( cDat)), 2) = "So" .AND. nDnPD <= 5)                    ;
          .OR. ( Left( CDOW( CTOD( cDat)), 2) = "Ne" .AND. nDnPD <= 6)
      nVolDny++
    ENDIF
  NEXT

  dbSelectArea( cOLDarea)
RETURN( nVolDny)


FUNCTION PracFond( nROK, nOBDOBI, cTYP, lSVAT, cALIAS)
  LOCAL dDatOd, dDatDo
  LOCAL dFirstDAY := mh_FirstODate( nROK, nOBDOBI)
  LOCAL dLastDAY  := mh_LastODate( nROK, nOBDOBI)
  LOCAL aFOND := { 0, 0}
  LOCAL cOLDarea := Alias()

  DEFAULT cALIAS TO "MsPrc_Mo"

  IF ( cALIAS) ->dDatNast <= dLastDAY                                      ;
     .AND. ( ( cALIAS) ->dDatVyst >= dFirstDAY .OR. Empty( ( cALIAS) ->dDatVyst))

    dDatOd   := IF( ( cALIAS) ->dDatNast < dFirstDAY, dFirstDAY, ( cALIAS) ->dDatNast)
    dDatDo   := IF( Empty( ( cALIAS) ->dDatVyst) .OR. ( cALIAS) ->dDatVyst >= dLastDAY, dLastDAY, ( cALIAS) ->dDatVyst)

    IF lSVAT
      aFond[1] := D_DnyOdDo( dDatOd, dDatDo, cTYP, cALIAS)                         ;
                                  +D_DnyOdDo( dDatOd, dDatDo, "SVAT", cALIAS)
    ELSE
      aFond[1] := D_DnyOdDo( dDatOd, dDatDo, cTYP, cALIAS)
    ENDIF
    aFond[2] := fPracDOBA( ( cALIAS) ->cDelkPrDob)[3] * aFond[1]
  ENDIF

  dbSelectArea( cOLDarea)

RETURN( aFond)



/*
function fGenVNucZM( cucet)
  local  cFAKT, ctyp

  do case
  case mzddavitw->cnazpol2 <= "399" ;   ctyp := "1"
  case mzddavitw->cnazpol2 <= "699" ;   ctyp := "2"
  case mzddavitw->cnazpol2 <= "799" ;   ctyp := "3"
  case mzddavitw->cnazpol2 <= "849" ;   ctyp := "4"
  case mzddavitw->cnazpol2 <= "899" ;   ctyp := "5"
  case mzddavitw->cnazpol2 <= "929" ;   ctyp := "6"
  case mzddavitw->cnazpol2 <= "959" ;   ctyp := "7"
  case mzddavitw->cnazpol2 <= "964" ;   ctyp := "9"
  case mzddavitw->cnazpol2 <= "969" ;   ctyp := "8"
  case mzddavitw->cnazpol2 <= "973" ;   ctyp := "9"
  case mzddavitw->cnazpol2 <= "999" ;   ctyp := "8"
  endcase

  cFAKT := if( mzddavitw->nExtFaktur = 1, "2", if( mzddavitw->cKmenStrPr <> mzddavitw->cNazPol1, "1", "0"))

  if( SubStr( cucet, 4, 1) = "?", StrTran( cucet,'?',cFakt,4,1), nil)
  if( Left( cucet, 1) == "5" .and. SubStr( cucet, 5, 1) == "?", StrTran( cucet,'?',ctyp,5,1), nil)

RETURN( cucet)
*/


// ---------- Vrátí obdobi OD-DO k aktuálnímu období pro výpoèet PP prùmìrù ------------
function MZD_ObdPrumPP( obdobi)      //  obd - pøedává se ve tvaru char RRRRMM
  local  ret[2]

  default obdobi to StrZero(uctOBDOBI:MZD:nROK, 4) +       ;
                     StrZero(uctOBDOBI:MZD:nOBDOBI, 2)

  nY := Val( Right( AllTrim(obdobi), 2))

  do case
  case nY = 1 .or. nY = 2 .or. nY = 3
    obd := 12
    rok := Val( Left( obdobi, 4)) -1

  case nY = 4 .or. nY = 5 .or. nY = 6
    obd := 3
    rok := Val( Left( obdobi, 4))

  case nY = 7 .or. nY = 8 .or. nY = 9
    obd := 6
    rok := Val( Left( obdobi, 4))

  case nY = 10 .or. nY = 11 .or. nY = 12
    obd := 9
    rok := Val( Left( obdobi, 4))

  endcase

  ret[1] := StrZero( rok ,4) +StrZero( obd-2, 2)
  ret[2] := StrZero( rok ,4) +StrZero(   obd, 2)

return( ret)


// ---------- Vrátí obdobi OD-DO k aktuálnímu období pro výpoèet NM prùmìrù ------------
function MZD_ObdPrumNM( obdobi)      //  obd - pøedává se ve tvaru char RRRRMM
  local  anObdobi := { { 1, 12}, { 2, 1}, { 3, 2}, { 4, 3}, { 5, 4}, { 6, 5}, { 7, 6}, { 8, 7}, { 9, 8}, { 10, 9}, { 11, 10}, { 12, 11} }
  local  i
  local  ret[2]

  default obdobi to StrZero(uctOBDOBI:MZD:nROK, 4) +       ;
                     StrZero(uctOBDOBI:MZD:nOBDOBI, 2)

  i      := Val( Right( obdobi, 2))

  ret[1] := StrZero( Val( Left( obdobi, 4)) -1 ,4)                                     ;
              +StrZero( anObdobi[i,1], 2)
  ret[2] := StrZero( if( i = 1, Val( Left( obdobi, 4)) -1, Val( Left( obdobi, 4))) ,4) ;
              +StrZero( anObdobi[i,2], 2)

return( ret)


function fSazTarMzLi(cTYP)
  local  nsazba

  do case
  case cTYP = 'HOD'
    nsazba := fSazTar(mh_LastODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI))[1]
  case cTYP = 'MES'
    nsazba := fSazTar(mh_LastODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI))[2]
  endcase

return(nsazba)



