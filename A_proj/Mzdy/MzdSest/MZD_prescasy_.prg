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
********************** MZD_prescasy *****************************************


function MZD_prescasy_(typ)
  local  nFONDobd
  local  nPrescas
  local  xKEY, xKEYold
  local  tmRok, tmObd
  local  filtr

  default typ to 'mzd'

  drgDBMS:open('mzddavit',,,,,'mzddavitb')
  drgDBMS:open('mzddavit',,,,,'mzddavitn')
  drgDBMS:open('msprc_mo')

  drgDBMS:open('tmpdavw',.t.,.t.,drgINI:dir_USERfitm); ZAP

  tmObd := Val(Left(obdReport,2))
  tmRok := Val(SubStr(obdReport,4,4))
  filtr := Format("nRok = %% .and. cdenik = 'MH'", {tmRok})
  mzddavitb ->( ads_setaof(filtr), OrdSetFocus('MZDDAVIT01'), dbGoTop())

  drgServiceThread:progressStart(drgNLS:msg('Hrubé mzdy  ... '), ;
                                             mzddavitb->(Ads_GetRecordCount()) )

  mzddavitb->( dbGoTop())

  do while .not. mzddavitb ->( Eof())    //.AND. mzddavitb ->nDruhMzdy < 500
    if mzddavitb ->nTypPraVZT <> 5 .and. mzddavitb ->nTypPraVZT <> 6
      if tmpdavw->cRoObCpPPv <> mzddavitb->cRoObCpPPv
//      if tmpdavw ->nObdobi <> mzddavitb ->nObdobi                                  ;
//          .or. tmpdavw ->nOsCisPrac <> mzddavitb ->nOsCisPrac                      ;
//           .or. tmpdavw ->nPorPraVzt <> mzddavitb ->nPorPraVzt

        if tmpdavw ->nOsCisPrac > 0                                                ;
            .and. tmpdavw ->nHodFondPD +F_HodNemoc() > tmpdavw ->nHodFonPDK
          nPrescas := tmpdavw ->nHodFondPD +tmpdavw ->nHodNemPrc - tmpdavw ->nHodFonPDK
          tmpdavw ->nPrumCP := nPrescas -( tmpdavw ->nHodNahrVo +tmpdavw ->nHodPresc)
          tmpdavw ->nPrumSP := 150 -tmpdavw ->nHodPresc
          tmpdavw ->nPrumPO := if( nPrescas > 0, nPrescas, 0)
        else
          tmpdavw ->nPrumSP := 150
        endif
        MH_CopyFLD( "mzddavitb", "tmpdavw", .T.)
        MsPrc_Mo ->( dbSeek( tmpdavw ->cRoObCpPpv,,'MSPRMO17'))
        tmpdavw ->nHodFonPDK := PracFond( tmpdavw ->nRok, tmpdavw ->nObdobi, "PRAC", .T., "MsPrc_Mo")[2]
        tmpdavw ->nHodNahrVo := if( mzddavitb ->nDruhMzdy = 205 .or. mzddavitb ->nDruhMzdy = 290             ;
                                                         , mzddavitb ->nHodDoklad, 0)
        tmpdavw ->nHodNemPrc := F_HodNemoc()
        tmpdavw ->nHodNahrVo += tmpdavw ->nHodNemPrc
        do case
        case typ = 'mzd'
          tmpdavw ->nHodPresc := if( mzddavitb ->nDruhMzdy = 143 .or. mzddavitb ->nDruhMzdy = 142        ;
                                                         , 0, mzddavitb ->nHodPresc)
        case typ = 'dmz'
          tmpdavw ->nHodPresc  := 0
          tmpdavw ->nHodPripl  := 0
          tmpdavw ->nHodPresc  := if( mzddavitb ->nDruhMzdy = 114 .or. mzddavitb ->nDruhMzdy = 124       ;
                                                           ,mzddavitb ->nHodDoklad, 0)
          tmpdavw ->nHodPripl  := if( mzddavitb ->nDruhMzdy = 137                                        ;
                                                           ,mzddavitb ->nHodPripl, 0)
        endcase


             ///             tmpdavw ->nHodPripl  += mzddavitb ->nHodPripl
        tmpdavw->nHodNahrVo += if( mzddavitb ->nDruhMzdy = 205 .or. mzddavitb ->nDruhMzdy = 290        ;
                                                           , mzddavitb ->nHodDoklad, 0)


        tmpdavw->nOpracHod += if( mzddavitb ->nDruhMzdy >= 109 .and. mzddavitb ->nDruhMzdy <= 129      ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nDovolHod  += if( mzddavitb ->nDruhMzdy = 180 .or. mzddavitb ->nDruhMzdy = 181         ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nSvatHod   += if( mzddavitb ->nDruhMzdy = 183 .or. mzddavitb ->nDruhMzdy = 183         ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nOstNahrHo += if( mzddavitb ->nDruhMzdy >= 184 .and. mzddavitb ->nDruhMzdy <= 189      ;
                                                           , mzddavitb ->nHodFondPD, 0)



      else
        tmpdavw ->nDnyDoklad += mzddavitb ->nDnyDoklad
        tmpdavw ->nHodDoklad += mzddavitb ->nHodDoklad
        tmpdavw ->nMnPDoklad += mzddavitb ->nMnPDoklad
        tmpdavw ->nHrubaMZD  += mzddavitb ->nHrubaMZD
        tmpdavw ->nDnyFondKD += mzddavitb ->nDnyFondKD
        tmpdavw ->nDnyFondPD += mzddavitb ->nDnyFondPD
        tmpdavw ->nHodFondKD += mzddavitb ->nHodFondKD
        tmpdavw ->nHodFondPD += mzddavitb ->nHodFondPD

        do case
        case typ = 'mzd'
          tmpdavw ->nHodPresc += if( mzddavitb ->nDruhMzdy = 143 .or. mzddavitb ->nDruhMzdy = 142       ;
                                                           , 0, mzddavitb ->nHodPresc)
        case typ = 'dmz'
          tmpdavw ->nHodPresc += if( mzddavitb ->nDruhMzdy = 114 .or. mzddavitb ->nDruhMzdy = 124       ;
                                                           , mzddavitb ->nHodDoklad, 0)
          tmpdavw ->nHodPripl += if( mzddavitb ->nDruhMzdy = 137                                        ;
                                                           , mzddavitb ->nHodPripl, 0)
        endcase

             ///             tmpdavw ->nHodPripl  += mzddavitb ->nHodPripl
        tmpdavw->nHodNahrVo += if( mzddavitb ->nDruhMzdy = 205 .or. mzddavitb ->nDruhMzdy = 290        ;
                                                           , mzddavitb ->nHodDoklad, 0)


        tmpdavw->nOpracHod += if( mzddavitb ->nDruhMzdy >= 109 .and. mzddavitb ->nDruhMzdy <= 129      ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nDovolHod  += if( mzddavitb ->nDruhMzdy = 180 .or. mzddavitb ->nDruhMzdy = 181         ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nSvatHod   += if( mzddavitb ->nDruhMzdy = 183 .or. mzddavitb ->nDruhMzdy = 183         ;
                                                           , mzddavitb ->nHodFondPD, 0)

        tmpdavw->nOstNahrHo += if( mzddavitb ->nDruhMzdy >= 184 .and. mzddavitb ->nDruhMzdy <= 189      ;
                                                           , mzddavitb ->nHodFondPD, 0)
//        tmpdavw->nHodNemPrc

      endif
    endif
    mzddavitb ->( dbSkip())
    drgServiceThread:progressInc()
  enddo

  nPrescas := tmpdavw ->nHodFondPD +tmpdavw ->nHodNemPrc - tmpdavw ->nHodFonPDK
  tmpdavw ->nPrumCP := nPrescas -( tmpdavw ->nHodNahrVo  +tmpdavw ->nHodPresc)
  tmpdavw ->nPrumSP := 150 -tmpdavw ->nHodPresc
  tmpdavw ->nPrumPO := if( nPrescas > 0, nPrescas, 0)

//  mzddavitb ->( ads_clearaof())


  filtr := Format("nRok = %% .and. cdenik = 'MN'", {tmRok})
  mzddavitn ->( ads_setaof(filtr), OrdSetFocus('MZDDAVIT01'),  dbGoTop())
*  mzddavitb ->( OrdSetFOCUS( 1))

  drgServiceThread:progressStart(drgNLS:msg('Nemocenky  ... '), ;
                                             mzddavitn->(Ads_GetRecordCount()) )

   xKEYold := ''
   do while .not. mzddavitn ->( Eof())
//     xKEY := StrZero( mzddavitb ->nRok, 4) +StrZero( m_Nem ->nObdobi, 2)      ;
//               +StrZero( m_Nem ->nOsCisPrac, 5) +StrZero( m_Nem ->nPorPraVzt, 2)
//     xKey := mzddavitn->cRoObCpPPv
     if mzddavitn ->nOsCisPrac = 155  .and. mzddavitn ->cobdobi = '07/15'
       cccc := 0
     endif

     if !mzddavitb ->( dbSeek( mzddavitn->cRoObCpPPv,,'MZDDAVIT16'))
       if mzddavitn->cRoObCpPPv <> xKEYold
         MH_CopyFLD( "mzddavitn", "tmpdavw", .T.)
         MsPrc_Mo ->( dbSeek( tmpdavw ->cRoObCpPpv,,'MSPRMO17'))
         tmpdavw ->nDruhMzdy  := 0
         tmpdavw ->nHodFondPD := 0
         tmpdavw ->nHodNemPRC += mzddavitn ->nHodFondPD
         tmpdavw ->nHodFondKD := PracFond( tmpdavw ->nRok, tmpdavw ->nObdobi, "PRAC", .T., "MsPrc_Mo")[2]
         tmpdavw ->nHodFonPDK := PracFond( tmpdavw ->nRok, tmpdavw ->nObdobi, "PRAC", .T., "MsPrc_Mo")[2]

         xKEYold := mzddavitn->cRoObCpPPv

//         xKEYold := StrZero( mzddavitb ->nRok, 4) +StrZero( mzddavitb ->nObdobi, 2)      ;
//                     +StrZero( mzddavitb ->nOsCisPrac, 5) +StrZero( mzddavitb ->nPorPraVzt, 2)
       else
         tmpdavw ->nHodNemPRC += mzddavitn ->nHodFondPD
       endif
     endif
     mzddavitn ->( dbSkip())
     drgServiceThread:progressInc()
   enddo

  mzddavitn ->( ads_clearaof())
  mzddavitb ->( ads_clearaof())
  tmpdavw ->( dbGoTop())

/*
         nPrescas := tmpdavw ->nHodFondPD +tmpdavw ->nHodNemPrc         ;
                                                                                - tmpdavw ->nHodFonPDK
         tmpdavw ->nPrumCP := nPrescas -( tmpdavw ->nHodNahrVo          ;
                                          +tmpdavw ->nHodPresc)
         tmpdavw ->nPrumSP := 150 -tmpdavw ->nHodPresc
         tmpdavw ->nPrumPO := IF( nPrescas > 0, nPrescas, 0)
*/

  *
  drgServiceThread:progressEnd()
  *

return nil


static function F_HodNemoc()
  local nHOD := 0
  local xKEY

  drgDBMS:open('mzddavit',,,,,'mzddavitc')

   filtr := Format("cRoObCpPPv = '%%' .and. cdenik = 'MN'", {tmpdavw ->cRoObCpPPv})
   mzddavitc ->( ads_setaof(filtr), dbGoTop())

   do while !mzddavitc ->( Eof())
     nHOD += mzddavitc ->nHodFondPD
     mzddavitc ->( dbSkip())
   enddo
  mzddavitc ->( ads_clearaof(), dbGoTop())

return( nHOD)