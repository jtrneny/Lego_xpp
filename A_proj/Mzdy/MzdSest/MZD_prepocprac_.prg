//
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
* Pro TISK
*
********************** MZD_prepocprac *****************************************


function MZD_prepocprac_(typ)
  local  nFONDobd
  local  nPrescas
  local  xKEY, xKEYold
  local  tmRok, tmObd
  local  filtr

  default typ to 'mzd'

  drgDBMS:open('mzdyhd',,,,,'mzdyhds')
  drgDBMS:open('msprc_mo',,,,,'msprc_mos')

  drgDBMS:open('prepprcw',.t.,.t.,drgINI:dir_USERfitm); ZAP

//  tmObd := Val( Left( obdReport,2))
//  tmRok := Val( SubStr( obdReport,4,4))

  drgServiceThread:progressStart(drgNLS:msg('Zpracování podkladù pro pøepoètené pracovníky  ... '), 12)

  for n := 1 to 12
    FormDatPP( n, 2016)
    drgServiceThread:progressInc()
  next

  drgServiceThread:progressEnd()


return nil


static function FormDatPP( nMes, nRok)
  local nCount
  local filtr

  // nastavit scope
//  xKey := StrZero( ACT_OBDyn(), 4) + StrZero( nMes, 2)
//  mzdyhds->( SET_sSCOPE( 1, xKey))

  filtr := Format("nRok = %% .and. nObdobi = %%", {nRok, nMes})
  mzdyhds->( ads_setaof(filtr), OrdSetFocus('MZDYHD01'), dbGoTop())

   ReadFileSP( nCount, nMes, nRok)
//         fAKTInf( "PrepPRC", nMes, n)
  mzdyhds->( ads_clearaof())

return nil  // FormDatSZ


//  ReadFileSP()
//  Zpracovava vstupni soubor a vytvari napoctovy pro statistiku
//  osob pracpvnik…
//******************************

static function ReadFileSP( nCount, nMes, nRok)
  local  nKolIkOu  := 1, nKlic
  local  lKlic     := .f.
  local  xKey, cSeekKEY
  LOCAL  nDelPrcTyd := SysConfig( "Mzdy:nDelPrcTyd")
  LOCAL  nDnyPrcTyd := SysConfig( "Mzdy:nDnyPrcTyd")
  LOCAL  nKalDNY, nKalHOD
  LOCAL  nPraDNY, nPraHOD, nSvatDNY
  LOCAL  nFyzPracDn, nFyzPracHo
  LOCAL  nOldOsCP, nOldPorPV, lOK
  LOCAL  nTMPhodPD, nTMPhodKD

  nKalDNY  := Kal_DnyKD( nrok, nMes )     // F_KALDNY( nROK, nMes)
  nSvatDNY := Kal_DnySV( nrok, nMes )     // F_SVATKY( nROK, nMes)
  nPraDNY  := Kal_DnyFPD( nrok, nMes )    // F_PRACDNY( nROK, nMes)
  nPraHOD  := nPraDNY * ( nDelPrcTyd / nDnyPrcTyd)
  xKey     := StrZero(nRok, 4) +StrZero( nMes, 2)

//  PrepPrc ->( OrdSetFOCUS( 3))

  do while .not. mzdyhds->( Eof())
    if mzdyhds->nMimoPrVzt = 0
      if mzdyhds->nDnyFondKD <> 0 .or. mzdyhds->nHodFondKD <> 0 .or. mzdyhds->nHodFondPD <> 0
        msprc_mos->( dbSeek(  xKEY +StrZero( mzdyhds->nOsCisPrac,5) +StrZero( mzdyhds->nPorPraVzt,3),,'MSPRMO01'))
        cSeekKEY := xKEY +Upper( mzdyhds->cKmenStrPr)     ;
                            +Upper( mzdyhds->cPracZar)    ;
                               +Upper( mzdyhds->cDelkPrDob) +'0'

//        drgDump( cSeekKey + '; '+ mzdyhds->cKmenStrPr  + '; ' + mzdyhds->cPracZar  + '; ' + mzdyhds->cDelkPrDob +CRLF)

        if .not.( prepprcw->( dbSeek( cSeekKEY,,'PREPPRCw03')))
          prepprcw->( dbAppend())

          prepprcw->nRok       := mzdyhds->nRok
          prepprcw->nObdobi    := mzdyhds->nObdobi
          prepprcw->cObdobi    := mzdyhds->cObdobi
          prepprcw->cKmenStrPr := mzdyhds->cKmenStrPr
          prepprcw->cPracZar   := mzdyhds->cPracZar
          prepprcw->cDelkPrDob := mzdyhds->cDelkPrDob
          prepprcw->nSoubPraPo := 0

          prepprcw->nFondPDHo  := fPracDOBA( PrepPrcw ->cDelkPrDob)[3]
          prepprcw->nFondPDTHo := fPracDOBA( PrepPrcw ->cDelkPrDob)[2]

          prepprcw->nProf1  := if( Len( mzdyhds->cPracZar) > 2, Val( Left( mzdyhds->cPracZar, 1)), 0)
          prepprcw->cProf1  := StrZero( prepprcw->nProf1, 1)
          prepprcw->nProf23 := Val( if( Len( mzdyhds->cPracZar) > 2, SubStr( mzdyhds->cPracZar, 2, 2), mzdyhds->cPracZar))
          prepprcw->cProf23 := StrZero( PrepPrcw ->nProf23, 2)
          prepprcw->nFondPD := fPracDOBA(mzdyhds->cDelkPrDob)[3]
          prepprcw->cFondPD := StrZero( prepprcw->nFondPD * 100, 4)
          prepprcw->cVedCin := if( msprc_mos->cDruPraVzt = "HLAVNI  "        ;
                                    .or. msprc_mos->cDruPraVzt = "VEDLEJSI", ;
                                       '0', Str( msprc_mos->nTypPraVzt, 1))
          prepprcw->nKalDNY  := nKalDNY
          prepprcw->nPraDny  := nPraDNY + nSvatDNY
          prepprcw->nKalHOD  := prepprcw->nKalDNY * prepprcw->nFondPD
          prepprcw->nPraHOD  := prepprcw->nPraDny * prepprcw->nFondPD
          prepprcw->nONEitem := 1
        endif

        prepprcw->nKalDnyOdp += mzdyhds->nDnyFondKD
        prepprcw->nPrcDnyOdp += mzdyhds->nDnyFondPD

        nKalHod   := nKalDny *fPracDOBA( mzdyhds->cDelkPrDob)[3]
        nTMPhodKD := mzdyhds->nHodFondKD -( mzdyhds->nHodPresc +mzdyhds->nHodPrescS)
        nTMPhodPD := mzdyhds->nHodFondPD -( mzdyhds->nHodPresc +mzdyhds->nHodPrescS)

        prepprcw->nKalHodOdp += if( nTMPhodKD > nKalHod, nKalHod, nTMPhodKD)
        prepprcw->nPrcHodOdp += if( nTMPhodPD > mzdyhds->nFondPDSHo, mzdyhds->nFondPDSHo, nTMPhodPD)

        prepprcw->nPrEvPZaFy += mzdyhds->nPrEvPZaFy
        prepprcw->nPrEvPZaPr += mzdyhds->nPrEvPZaPr
        prepprcw->nTmEvPZaPr += mzdyhds->nTmEvPZaPr
        prepprcw->nFyzStavOb += mzdyhds->nFyzStavOb
        prepprcw->nFyzStavKo += mzdyhds->nFyzStavKo
        prepprcw->nFyzStavPr += mzdyhds->nFyzStavPr
        prepprcw->nPreStavPr += mzdyhds->nPreStavPr
      endif
    endif
    mzdyhds->( dbSkip())
  enddo

//  prepprcw->( SET_sSCOPE( 1, xKey))

  filtr := Format("nRok = %% .and. nObdobi = %%", {nRok, nMes})
  prepprcw->( ads_setaof(filtr), dbGoTop())

   do while .not. prepprcw->( Eof())
     nFyzPracDn := Round( ( prepprcw->nPrcDnyOdp / prepprcw->nPraDNY) +0.49, 0)
     nFyzPracHo := Round( ( prepprcw->nPrcHodOdp / prepprcw->nPraHOD) +0.49, 0)

     prepprcw->nPrEvPZaPr := Round( prepprcw->nTmEvPZaPr/prepprcw->nFondPDTHo, 0)
     prepprcw->nFyziPRAdn := if( prepprcw->cVedCin = '0', nFyzPracDn , 0)
     prepprcw->nFyziPRAho := if( prepprcw->cVedCin = '0', nFyzPracHo , 0)
     prepprcw->nPrepPRAho := prepprcw->nPrcHodOdp / prepprcw->nPraHOD

     prepprcw->( dbSkip())
   enddo

  prepprcw->( ADS_ClearAOF())

return nil



























































