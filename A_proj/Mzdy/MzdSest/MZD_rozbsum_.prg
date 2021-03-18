***************************************************************************
*
* MZD_rozbsum_.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


* Pro TISK
*===============================================================================
function MZD_rozbsum_( ctyp )

   do case
   case ctyp == "roz_mo1"   ;     MZD_rozbsum_1()
//   case ctyp == "roz_mo2"   ;     MZD_rozbsum_2()

   endcase

return NIL


function MZD_rozbsum_1()
  local  cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  local  nRec
  local  key
  local  n
  local  pocet, suma, sumaho, sumahoza

  drgDBMS:open('mzddavit')
  mzddavit->( AdsSetOrder(1))
  drgDBMS:open('mzdyhd')
  mzdyhd->( AdsSetOrder(1))
  drgDBMS:open('mzdrozb1w',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('mzdyhdw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  *

  drgServiceThread:progressStart(drgNLS:msg('Vytváøím sumy za období ...'),12 )

  for n := 1 to Val(Left(obdReport,2))
    key := Right(obdReport,4) +StrZero(n,2)
    mzdrozb1w->(dbAppend())
    mzdrozb1w->nRok    := Val( Right(obdReport,4))
    mzdrozb1w->nObdobi := n
    mzdrozb1w->cObdobi := StrZero(mzdrozb1w->nObdobi,2) +"/" +Right(obdReport,2)

    mzdyhd->( mh_SetScope( Key))
    do while .not. mzdyhd->( Eof())
      if AllTrim(mzdyhd->cPracZar) == "10"
        mzdrozb1w->nFyzStavOb += mzdyhd->nFyzStavOb
        mzdrozb1w->nFyzStavKo += mzdyhd->nFyzStavKo
        mzdrozb1w->nFyzStavPr += mzdyhd->nFyzStavPr
        mzdrozb1w->nPreStavPr += mzdyhd->nPreStavPr
        mzdrozb1w->nPrEvPZaFy += mzdyhd->nPrEvPZaFy
        mzdrozb1w->nPrEvPZaPr += mzdyhd->nPrEvPZaPr
        mzdrozb1w->nFondPDHo  += mzdyhd->nFondPDHo
        mzdrozb1w->nFondPDSHo += mzdyhd->nFondPDSHo
        mzdrozb1w->nHodFondPD += mzdyhd->nHodFondPD
        mzdrozb1w->nHodOdprac += mzdyhd->nHodOdprac
      endif
      mzdyhd->( dbSkip())
    enddo

    mzddavit->( mh_SetScope( key))
    do while .not. mzddavit->( Eof())
      if AllTrim(mzddavit->cPracZar) == "10"
        if ( mzddavit->ndruhmzdy == 112 .or. mzddavit->ndruhmzdy == 116 .or. mzddavit->ndruhmzdy == 120)
          if .not. Empty(mzddavit->cnazpol3) .and. mzddavit->ndruhmzdy == 112
            if Left(AllTrim(mzddavit->cnazpol3),1) == "4"
              mzdrozb1w->nHodOdprRe += mzddavit->nHodDoklad
            else
              mzdrozb1w->nHodOdprZa += mzddavit->nHodDoklad
            endif
          endif
          mzdrozb1w->nHodOdpr += mzddavit->nHodDoklad
        endif

        if ( mzddavit->ndruhmzdy == 112 .or. mzddavit->ndruhmzdy == 116 .or. mzddavit->ndruhmzdy == 120)
          if .not. Empty(mzddavit->cnazpol3) .and. mzddavit->ndruhmzdy == 112
            if Left(AllTrim(mzddavit->cnazpol3),1) == "4"
            else
              mzdrozb1w->nMzdaFa += mzddavit->nHrubaMZD
            endif
            mzdrozb1w->nMzdaZa += mzddavit->nHrubaMZD
          endif
        endif

        if mzddavit->ndruhmzdy == 215
          mzdrozb1w->nMzdaFa += mzddavit->nHrubaMZD
          mzdrozb1w->nMzdaZa += mzddavit->nHrubaMZD
        endif
      endif
      mzddavit->( dbSkip())
    enddo

    if mzdrozb1w->nFyzStavOb > 1
      mzdrozb1w->nPocet  := 1
    endif

    drgServiceThread:progressInc()
  next

  pocet := 0
  suma  := sumaho := sumahoza := 0
  mzdrozb1w->(dbGoTop())
  do while .not.mzdrozb1w->( Eof())
    pocet    += mzdrozb1w->nPocet
    suma     += mzdrozb1w->nFyzStavKo
    sumaho   += mzdrozb1w->nHodOdpr
    sumahoza += mzdrozb1w->nHodOdprZa
    mzdrozb1w->nFyzStavOS := suma

    mzdrozb1w->(dbSkip())
  end

  mzdrozb1w->(dbGoTop())
  do while .not.mzdrozb1w->( Eof())
    mzdrozb1w->nPocetS    := pocet
    mzdrozb1w->nFyzStavKS := suma/pocet
    mzdrozb1w->nFyzStavCS := suma
    mzdrozb1w->nHodOdprS  := sumaho
    mzdrozb1w->nHodOdprZS := sumahoza
    mzdrozb1w->(dbSkip())
  end

  *
  drgServiceThread:progressEnd()
  *

return nil