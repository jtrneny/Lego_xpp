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


* Pro TISK výèetka platidel
*===============================================================================

function MZD_potvrozam_()
  local  cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  local  nRec
  local  key
  local  n,rr,mm
  local  cod, cdo, nod, ndo

//  drgDBMS:open('msprc_mo',,,,,'msprc_mot')
  drgDBMS:open('msprc_mo')
  drgDBMS:open('mssrz_mo',,,,,'mssrz_mot')
  drgDBMS:open('mzddavhd',,,,,'mzddavhdt')
  drgDBMS:open('tmpotzamw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  *

//  msprc_mot->( dbSeek( msprc_mo->croobcpppv,,'MSPRMO17'))
  drgServiceThread:progressStart(drgNLS:msg('Vytváøím podklady ...'), 12 )
  mh_copyFld( 'msprc_mo', 'tmpotzamw', .t., .t. )
  tmpotzamw->nmsprc_mo  := isNull( msprc_mo->sid, 0)
  tmpotzamw->cportisku  := '0'

  if .not. Empty( msprc_mo->dDatVyst)
    rr := if( Month(msprc_mo->dDatVyst) = 1, Year(msprc_mo->dDatVyst), Year(msprc_mo->dDatVyst)-1)
    mm := if( Month(msprc_mo->dDatVyst) = 12, 1, Month(msprc_mo->dDatVyst) + 1)
    nod := ( rr * 100) + mm
    ndo := ( Year(msprc_mo->dDatVyst) *100 ) +  Month(msprc_mo->dDatVyst)

    filtrs := Format( "ccpppv = '%%' .and. nrokobd >= %% .and. nrokobd <= %% .and. cdenik = 'MN'", {msprc_mo->cCpPPV, nod, ndo})

    ** MZDYHD - vypoètené èisté mzdy
    mzddavhdt->( Ads_setAOF(filtrs))
    mzddavhdt->( AdsSetOrder( 'MZDDAVHD22'), dbgoTop())

    key := 0
    do while .not. mzddavhdt->( Eof())
      if key <> mzddavhdt->nporadi
        mh_copyFld( 'msprc_mo', 'tmpotzamw', .t., .t. )
        tmpotzamw->cportisku  := '1'
        tmpotzamw->nporadi    := mzddavhdt->nporadi
        tmpotzamw->nmzddavhd  := isNull( mzddavhdt->sid, 0)
        tmpotzamw->nDnySumKD  := mzddavhdt->nDnyFondKD

        key := mzddavhdt->nporadi
      else
        tmpotzamw->nDnySumKD  += mzddavhdt->nDnyFondKD
        tmpotzamw->nmzddavhd  := isNull( mzddavhdt->sid, 0)
      endif

      mzddavhdt->( dbSkip())
      drgServiceThread:progressInc()
    enddo
    mzddavhdt->( Ads_ClearAOF())
  endif


  filtrs := Format("croobcpppv = '%%' and laktivsrz", {msprc_mo->croobcpppv})

    ** MZDYHD - vypoètené èisté mzdy
  mssrz_mot->( Ads_setAOF(filtrs))
  mssrz_mot->( AdsSetOrder( 'MSSRZ_04'), dbgoTop())

   do while .not. mssrz_mot->( Eof())
     mh_copyFld( 'mssrz_mot', 'tmpotzamw', .t., .t. )
     tmpotzamw->cportisku := '2'
     tmpotzamw->nmssrz_mo := isNull( mssrz_mot->sid, 0)

     mssrz_mot->( dbSkip())
     drgServiceThread:progressInc()
   enddo
  mssrz_mot->( Ads_ClearAOF())


  tmpotzamw->( dbcommit())

  *
  drgServiceThread:progressEnd()
  *

return nil