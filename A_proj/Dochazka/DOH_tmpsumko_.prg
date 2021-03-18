//
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
*  Sumace - podklady pro kontrolku - tisky, tmp...
*
********************** DOH_tmpsumko *****************************************

static  nDAY_doch, nDNY_fond, nDNY_svat
static  cKEY_prac
static  nrok, nobdobi
static  lall, lvyr


function tmpsumkon_sel(oXbp)

  tmpsumkon(oXbp)

return nil


function tmpsumkon(oXbp, ctask)
  local  o_mainDBro
  local  is_selAllRec
  local  arSelect
  local  lrSelect_one := .f.

  default ctask to 'DOH'

//  lall, lvyr, oXbp

  if .not. Empty(oXbp) .and. oXbp:FormName <> "SYS_forms_IN"
    o_mainDBro   := oXbp:parent:odBrowse[1]
    is_selAllRec := o_mainDBro:is_selAllRec
    arSelect     := o_mainDBro:arSelect
    lAll := .f.
    lVyr := .t.
  else
    lAll := .t.
    lVyr := ( ctask = 'DOH' .or. ctask = 'VYR' )
    drgDBMS:open('osoby')
    filtr  := format( "nis_doh = %%", {1})
    osoby->( ads_setAof(filtr),dbgoTop())
  endif

  drgDBMS:open('dspohyby',,,,,'dspohybyt')
  drgDBMS:open('listit',,,,,'listitt')
  drgDBMS:open('c_svatky',,,,,'c_svatkyt')
  drgDBMS:open('c_prerus',,,,,'c_prerust')
  drgDBMS:open('c_pracsm',,,,,'c_pracsmt')
  drgDBMS:open('c_pracdo',,,,,'c_pracdot')
  drgDBMS:open('c_infsum',,,,,'c_infsumt')

  drgDBMS:open('tmpsumkow',.T.,.T.,drgINI:dir_USERfitm); ZAP

  osoby->( dbSetRelation( 'c_pracdot', {||osoby->cdelkprdob}, 'osoby->cDELKprDOB','C_PRACDO04'))
  dspohybyt->( dbRelation( 'c_prerust', {||dspohybyt->nkodprer},'dspohybyt->nkodprer','C_PRERUS03'))

  if lall
    do case
    case ( ctask = 'MZD' )
      nrok      := uctOBDOBI:MZD:NROK
      nobdobi   := uctOBDOBI:MZD:NOBDOBI
    case ( ctask = 'VYR' )
      nrok      := uctOBDOBI:VYR:NROK
      nobdobi   := uctOBDOBI:VYR:NOBDOBI
    otherwise
      nrok      := Val( SubStr(obdReport,4,4))
      nobdobi   := Val( Left(obdReport,2))
    endcase

    nDNY_svat := Kal_DnySVPD( nrok, nobdobi)
    nDNY_fond := Kal_DnyFPD( nrok, nobdobi)
    nDNY_fond -= nDNY_svat

    osoby->( dbGoTop())
    do while .not. osoby->( Eof())
      cky := strZero( osoby->ncisOsoby, 6) +strZero( nrok, 4) +strZero( nobdobi, 2)
      if( dsPohybyT ->( dbseek( cky,, 'DSPOHY21')),  genITkontrol(), nil )

      osoby->( dbSkip())
    enddo

  else
    nrok      := if( ctask = 'DOH', uctOBDOBI:DOH:NROK   , uctOBDOBI:MZD:NROK    )
    nobdobi   := if( ctask = 'DOH', uctOBDOBI:DOH:NOBDOBI, uctOBDOBI:MZD:NOBDOBI )
    nDNY_svat := Kal_DnySVPD( nrok, nobdobi)
    nDNY_fond := Kal_DnyFPD( nrok, nobdobi)
    nDNY_fond -= nDNY_svat

    do case
    case  is_selAllRec         ;  osoby->( dbgoTop())
    case  len( arSelect ) <> 0 ;  osoby->( dbgoTo( arSelect[1]))
    otherwise
      AAdd( arSelect, osoby->( Recno()))
      lrSelect_one := .t.
    endcase

    if is_selAllRec
      do while .not. osoby->( Eof())
        genITkontrol()
        osoby->( dbSkip())
      enddo
    else
      for n := 1 to len( arSelect)
        osoby->( dbgoTo( arSelect[n]))
        genITkontrol()
        osoby->( dbSkip())
      next
    endif
  endif

  if lall
    osoby->( ads_clearAof())
  endif

  if( lrSelect_one, o_mainDBro:arSelect := {}, nil)

  dspohybyt->( dbCloseArea())
  listitt->( dbCloseArea())
  c_svatkyt->( dbCloseArea())
  c_prerust->( dbCloseArea())
  c_pracsmt->( dbCloseArea())
  c_pracdot->( dbCloseArea())
  c_infsumt->( dbCloseArea())

return( nil)


static function genITkontrol()
  local  aPdDNY := {}
  local  cky := strZero( osoby->ncisOsoby, 6) +strZero( nrok, 4) +strZero( nobdobi, 2)
  local  cfiltr

  c_pracdot ->( dbSeek( UPPER( osoby ->cDELKprDOB),,'C_PRACDO01'))
  dsPohybyT->( ordSetFocus('DSPOHY21'), ;
               dbsetScope( SCOPE_BOTH, cky ), dbgoTop() )

** js  filtr  := format( "ncisosoby = %% and nrok = %% and nobdobi = %%", {osoby->ncisosoby, nrok, nobdobi})
** js  dspohybyt->( ads_setAof(filtr),dbgoTop())

   MH_CopyFld( "dspohybyt", "tmpsumkow", .T.)
   tmpsumkow->nFondPDHo := DOCH_fond('HOD', 'PD')
   tmpsumkow->nFondPDDn := DOCH_fond('DNY', 'PD')
   tmpsumkow->nFondSVHo := DOCH_fond('HOD', 'SV')
   tmpsumkow->nFondSVDn := DOCH_fond('DNY', 'SV')

   tmpsumkow->nFondPSHo := tmpsumkow->nFondPDHo +tmpsumkow->nFondSVHo

   tmpsumkow->nFondPSHo := tmpsumkow->nFondPDHo +tmpsumkow->nFondSVHo
   tmpsumkow->nFondPSDn := tmpsumkow->nFondPDDn +tmpsumkow->nFondSVDn

//         DSPOHYBY ->( dbGoTop())
   c_svatkyt->( OrdSetFOCUS( 1))

   do while .not. dspohybyt->( Eof())
     cTYP := AllTrim( dspohybyt->cKodPrer)

     if cTYP = "PRI" .or. cTYP = "MPR"
       tmpsumkow ->nOdpracoHo += dspohybyt->nCasCelCPD
       if cTYP = "PRI" .and. dspohybyt->cZkrDne <> "So"                     ;
            .and. dspohybyt->cZkrDne <> "Ne"                                  ;
             .and. .not. c_svatkyt ->( dbSEEK( DtoS( dspohybyt->dDatum)))
         if( aScan( aPdDNY, dspohybyt->nDen) = 0, AAdd( aPdDNY, { dspohybyt->nDen}), nil)
       endif
     endif

     tmpsumkow->nDovolenHo += if( cTYP = "DOV", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nNemocenHo += if( cTYP = "NEM", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nSvatkyHo  += if( cTYP = "SVA", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nOCRHo     += if( cTYP = "OSE", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nNahZMzdHo += if( cTYP = "NMZ", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nRefuMzdHo += if( cTYP = "REF", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nOstNahrHo += if( cTYP = "SOU" .or. cTYP = "LEK", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nPresc25Ho += if( cTYP = "PPD" .or. cTYP = "MPD", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nPresc50Ho += if( cTYP = "PSN" .or. cTYP = "MSN", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nSvatPriHo += if( cTYP = "PSV" .or. cTYP = "MSV", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nNocnPriHo += if( cTYP = "PNO", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nOdmenyHo  += if( cTYP = "MPR", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nPripl10SN += if( cTYP = "SNP", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nPripl10SV += if( cTYP = "SVP", dspohybyt->nCasCelCPD, 0)

     tmpsumkow->nNahrZa60h += if( cTYP = "NM3", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nNahrZa80h += if( cTYP = "NM1", dspohybyt->nCasCelCPD, 0)
     tmpsumkow->nNahrZ100h += if( cTYP = "NM2", dspohybyt->nCasCelCPD, 0)

     if cTYP == "NEV"
       tmpsumkow->nNeplVolHo += dspohybyt->nCasCelCPD
       tmpsumkow->nNeplVolDn += if( dspohybyt->nCasCelCPD >= c_PRACDOt->nHodDen, 1, 0)
     endif
     if cTYP == "ABS"
       tmpsumkow->nAbsenceHo += dspohybyt->nCasCelCPD
       tmpsumkow->nAbsenceDn += if( dspohybyt->nCasCelCPD >= c_PRACDOt->nHodDen, 1, 0)
     endif

     dspohybyt->( dbSkip())
   enddo

   tmpsumkow->nOdpracoDn := Len( aPdDNY)
   tmpsumkow->nDovolenDn := MH_RoundNumb( tmpsumkow->nDovolenHo /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nNemocenDn := MH_RoundNumb( tmpsumkow->nNemocenHo /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nSvatkyDn  := MH_RoundNumb( tmpsumkow->nSvatkyHo  /c_PRACDOt->nHodDen, 212)
//             TmpSumKo ->nNeplVolDn := MH_RoundNumb( TmpSumKo ->nNeplVolHo /c_PRACDO ->nHodDen, 212)
   tmpsumkow->nOCRDn     := MH_RoundNumb( tmpsumkow->nOCRHo     /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nNahZMzdDn := MH_RoundNumb( tmpsumkow->nNahZMzdHo /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nRefuMzdDn := MH_RoundNumb( tmpsumkow->nRefuMzdHo /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nOstNahrDn := MH_RoundNumb( tmpsumkow->nOstNahrHo /c_PRACDOt->nHodDen, 212)
//             TmpSumKo ->nAbsenceDn := MH_RoundNumb( TmpSumKo ->nAbsenceHo /c_PRACDO ->nHodDen, 212)

   tmpsumkow->nNahrZa60d += MH_RoundNumb( tmpsumkow->nNahrZa60h /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nNahrZa80d += MH_RoundNumb( tmpsumkow->nNahrZa80h /c_PRACDOt->nHodDen, 212)
   tmpsumkow->nNahrZ100d += MH_RoundNumb( tmpsumkow->nNahrZ100h /c_PRACDOt->nHodDen, 212)


   dsPohybyT->( dbclearScope())
** js  dspohybyt->( ads_clearAof())

  cfiltr := Format("nCISOSOBY= %% .and. nrok = %% .and. nobdobi = %%", {osoby->ncisOsoby, nrok, nobdobi})
  if lVYR
    listitt->( ads_setAof( cfiltr),dbgoTop())
     do while .not. listitt ->( Eof())
       tmpsumkow->nVyrobaHo += listitt->nNHnaOPEsk
       listitt->( dbSkip())
     enddo
    listitt ->( ads_clearAof())
  endif

return( nil)


static function DOCH_fond( cTYP, cFND )            //Äzobrazen¡ FONDU_PDÄÄÄÄÄÄÄÄ
  local nVAL := 0

  if     cTYP == 'DNY' .and. cFND == "PD"  ;  nVAL := nDNY_fond
  elseif cTYP == 'DNY' .and. cFND == "SV"  ;  nVAL := nDNY_svat
  elseif cTYP == 'HOD' .and. cFND == "PD"  ;  nVAL := nDNY_fond * c_pracdot->nHODden
  elseif cTYP == 'HOD' .and. cFND == "SV"  ;  nVAL := nDNY_svat * c_pracdot->nHODden
  endIf

return( nVAL)

/*
static function DOCH_kal()
  local  nFS_day, nLS_day, nPOS
  local  dFs_day := CTOD( '01.' +STRTRAN( ACT_OBDnc(), '/', '.'))
  local  cFS_day := UPPER( LEFT( CDOW( dFS_day), 2))
  local  cOB_ym  := ACT_OBDn()

  nDNY_fond := 0
  nDNY_svat := 0
  nLS_day   := LastDayOM( dFs_day)

  For nPOs := 1 To nLS_day STEP 1
    cFS_day := Upeer( Left( CDOW( dFS_day +nPOs -1), 2))
    if c_svatkyt->( dbSeek( cOB_ym +STRZERO( nPOs, 2),,'C_SVATKY03')) .or. cFS_day = 'SO' .or. cFS_day = 'NE'
      if c_svatkyt->( dbSeek( cOB_ym +STRZERO( nPOs, 2),,'C_SVATKY03')) .and. cFS_day <> 'SO' .and. cFS_day <> 'NE'
        nDNY_svat++
      endif
    else
      nDNY_fond++
    endif
  Next

return( nil)

*/