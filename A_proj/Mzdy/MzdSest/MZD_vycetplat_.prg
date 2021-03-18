#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


* Pro TISK výèetka platidel
*===============================================================================
function MZD_vycetplat_()
  local  cmain_Ky, csub_Ky, x
  local  zaklMena  := upper( sysConfig('Finance:cZaklMena'))
  local  nsum_Mzda := 0
  local  pa_Mince  := {}
  *
  local  cnomHod, cpocPla, ccastka

  cmain_Ky := subStr(obdReport,4) +left(obdReport,2)
*  cmain_Ky := strZero( uctOBDOBI:MZD:NROK, 4) +strZero( uctOBDOBI:MZD:NOBDOBI, 2)
  *
  ** STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3)
  drgDBMS:open('msPrc_mo')  ;  msPrc_mo->( ordSetFocus('MSPRMO01'))
                               msPrc_mo->( dbsetScope(SCOPE_BOTH,cmain_ky), ;
                                           dbgotop()                        )

  *
  ** STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3) +STRZERO(nDoklad,10)
  drgDBMS:open('mzdyit',,,,,'mzdyit_X' )  ;  mzdyit_X  ->( ordSetFocus('MZDYIT12'))
  drgDBMS:open('c_mince' )
  c_mince->( dbeval( { || aadd( pa_Mince, { c_mince->cNAZmince, ;
                                            c_mince->nHODmince, ;
                                            c_mince->nVALmince, ;
                                            c_mince->ltaskMZD , ;
                                            0                 , ;
                                            0                 , ;
                                            0                   } ) }, ;
                     { || upper(c_mince->cZKRATmeny) = zaklMena .and. c_mince->ltaskMZD }  ))
  *
  ** setøídíme setupnì od nejvìtší hodnoty po nejmenší hodnotu mince
  asort( pa_Mince,,, { |ax,ay| ax[3] > ay[3] })

  drgDBMS:open('vycetkaW',.T.,.T.,drgINI:dir_USERfitm); ZAP

*  5 - nnomHod_01 ... 13
*  6 - npocPla_01 ... 13
*  7 - ncastka_01 ... 13

  drgServiceThread:progressStart(drgNLS:msg('Vytváøím sumy za období ...'),12 )

  do while .not. msPrc_mo->(eof())
    *
    ** suma DM 950 . 590
    nsum_Mzda := 0
    csub_Ky   := cmain_Ky +strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
    mzdyit_X->( dbsetScope( SCOPE_BOTH,csub_Ky)                                        , ;
                dbeval( { || nsum_Mzda += mzdyit_X->nmzda                             }, ;
                      { || (mzdyit_X->ndruhMzdy = 950 .or. mzdyit_X->ndruhMzdy = 590) }  ), ;
                dbclearScope()                                                              )

    if nsum_Mzda <> 0
      mh_copyFld( 'msPrc_mo', 'vycetkaW', .t. )
      vycetkaW->nsum_Mzda := nsum_Mzda

      for x := 1 to len( pa_Mince) step 1
        * i když ji nedostane musíme ji do TMP dát
        cnomHod := strTran( 'nnomHod_xx', 'xx', strZero(x,2))
        vycetkaW->&(cnomHod) := pa_Mince[x,2]

        if nsum_Mzda >= pa_Mince[x,3]
          cnomHod := strTran( 'nnomHod_xx', 'xx', strZero(x,2))
          cpocPla := strTran( 'npocPla_xx', 'xx', strZero(x,2))
          ccastka := strTran( 'ncastka_xx', 'xx', strZero(x,2))

          vycetkaW->&(cnomHod) := pa_Mince[x,2]
          vycetkaW->&(cpocPla) := int( nsum_Mzda / pa_Mince[x,3] )
          vycetkaW->&(ccastka) := vycetkaW->&(cpocPla) * pa_Mince[x,3]

          nsum_Mzda -= vycetkaW->&(ccastka)
        endif
      next
      vycetkaW->( dbcommit())
    endif

    drgServiceThread:progressInc()
    msPrc_mo->( dbskip())
  enddo
  *
  drgServiceThread:progressEnd()
return nil