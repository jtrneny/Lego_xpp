***************************************************************************
*
* MZD_hlasispv_.PRG
*
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

* Pro hlášení ISPV
*===============================================================================

function MZD_hlasispv_()
  local  cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  local  nRec
  local  key
  local  n,mm
  local  cKeyObdOD, cKeyObdDO
  local  filtrs

  drgDBMS:open('osoby',,,,,'osobyt')
  drgDBMS:open('msprc_mo',,,,,'msprc_mot')
  drgDBMS:open('mzdyit',,,,,'mzdyitt')
  drgDBMS:open('druhymzd',,,,,'druhymzdt')
  drgDBMS:open('c_pracza',,,,,'c_praczat')
  drgDBMS:open('c_statpr',,,,,'c_statprt')
  drgDBMS:open('c_vzdel',,,,,'c_vzdelt')
  drgDBMS:open('c_typdmz',,,,,'c_typdmzt')
  drgDBMS:open('mstarhro',,,,,'mstarhrot')

  msprc_mot->( DbSetRelation( 'c_praczat', {|| Upper(msprc_mot->cpraczar)}, 'Upper(msprc_mot->cpraczar)','C_PRACZA01'))
  osobyt->( DbSetRelation( 'c_statprt', {|| Upper(osobyt->czkrstapri)}, 'Upper(osobyt->czkrstapri)','C_STATPR01'))
  osobyt->( DbSetRelation( 'c_vzdelt', {|| Upper(osobyt->czkrvzdel)}, 'Upper(osobyt->czkrvzdel)','C_VZDEL01'))
  druhymzdt->( DbSetRelation( 'c_typdmzt', {|| Upper(druhymzdt->ctypdmz)}, 'Upper(druhymzdt->ctypdmz)','C_TYPDMZ01'))
  mzdyitt->( DbSetRelation( 'druhymzdt', {|| mzdyitt->ndruhmzdy}, 'mzdyitt->ndruhmzdy','DRUHYMZD01'))

  *
  filtrs := Format( "nrokobd = %%", {uctOBDOBI:MZD:NROKOBD})
  msprc_mot->( Ads_setAOF(filtrs), dbGoTop())

  drgServiceThread:progressStart(drgNLS:msg('Vytváøím podklady ...'), msprc_mot->( Ads_GetRecordCount()) )

  cKeyObdOD := StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( 1, 2)
  cKeyObdDO := StrZero( uctOBDOBI:MZD:NROK, 4) +StrZero( uctOBDOBI:MZD:NOBDOBI, 2)

  do while .not. msprc_mot ->( Eof())
    if osobyt->( dbSeek( msprc_mot->nosoby,,'ID'))
    if( Year( msprc_mot->dDatVyst) >= uctOBDOBI:MZD:NROK .or. Empty( msprc_mot->dDatVyst))  ;
          .and. msprc_mot->cDruPraVzt = "HLAVNI" .and. .not.msprc_mot->lNeStatika
      WR_ITISCPV( cKeyObdOd, cKeyObdDo)
    endif
    endif
    msprc_mot ->( dbSkip())
    drgServiceThread:progressInc()
  enddo

  tmhlispvw->( dbGoTop())
  do while .not. tmhlispvw->( Eof())
    if tmhlispvw->FONDSTA = 0
      tmhlispvw->( dbDelete())
    endif
    tmhlispvw->( dbSkip())
  enddo

  tmhlispvw->( dbGoTop())
  tmhlispvw->( dbcommit())

  *
  drgServiceThread:progressEnd()
  *

return nil


static function WR_ITISCPV( cKeyObdOd, cKeyObdDo)
  local nX1, nX2
  local dDatTMP
  local nLASTday, dLASTday

  tmhlispvw ->( dbAppend())

  tmhlispvw->ICO      := AllTrim( Str(SysConfig( "System:nICO")))
  tmhlispvw->IDZAM    := AllTrim( Str( msprc_mot->nOsCisPrac))
  tmhlispvw->ROKNAR   := Year( osobyt->dDatNaroz)
  tmhlispvw->POHLAVI  := if( Left( osobyt->cPohlavi, 1) = "M", "M", "Z")
  tmhlispvw->STOBC    := Left( C_StatPrt->cZkratStat, 2)
  tmhlispvw->VZDELANI := C_Vzdelt->cTypVzdSCP
  tmhlispvw->oborvzd  := osobyt->cObVzdISPV

  do case
  case msprc_mot->cVznPraVzt = "JMENOVANIM" ;  tmhlispvw->CZICSE := "1121"
  case msprc_mot->cVznPraVzt = "VOLBOU"     ;  tmhlispvw->CZICSE := "1122"
  case msprc_mot->nTypPraVzt = 5            ;  tmhlispvw->CZICSE := "1212"
  case msprc_mot->nTypPraVzt = 6            ;  tmhlispvw->CZICSE := "1211"

  case msprc_mot->nTypPraVzt = 1 .or. msprc_mot->nTypPraVzt = 3          ;
       .or. msprc_mot->nTypPraVzt = 7
    tmhlispvw->CZICSE := "1111"

  case msprc_mot->nTypPraVzt = 2 .or. msprc_mot->nTypPraVzt = 4          ;
       .or. msprc_mot->nTypPraVzt = 8
    tmhlispvw->CZICSE := "1112"

  otherwise
    tmhlispvw->CZICSE := "6110"
  endcase

  tmhlispvw->czisco   := Str( osobyt->nKlasZam,5,0)
  tmhlispvw->nazpoz   := c_praczat->cnazpracza

  tmhlispvw->MISTOVP  := AllTrim( SysConfig( "System:cKodUzemJe"))
  tmhlispvw->ZAMEST   := AllTrim( Str( if( Empty( osobyt->nKlasZam)                        ;
                       , C_PracZat->nKlasZam, osobyt->nKlasZam)))
  tmhlispvw->VEDOUCI  := if( osobyt->lVedPrac, "A", "N")

  do case
  case msprc_mot->nTypDuchod = 5 .or. msprc_mot->nTypDuchod = 6
    tmhlispvw->INVALD   := "P"
  case msprc_mot->nTypDuchod = 7
    tmhlispvw->INVALD   := "C"
  otherwise
    tmhlispvw->INVALD   := "Z"
  endcase

  nLASTday := LastDayOM( CtoD( "01."+ Right(cKeyObdDo,2) + "." + Left(cKeyObdDo,4)))
  dLASTday := CtoD( StrZero( nLASTday) +"." + Right(cKeyObdDo,2)+ "." + Left(cKeyObdDo,4))

  dDatTmp := if( Empty( msprc_mot->dDatVyst), dLASTday                    ;
                       , if( msprc_mot->dDatVyst > dLASTday, dLASTday           ;
                              , msprc_mot->dDatVyst))

  if dDatTmp >= CtoD( "01.01." +Left(cKeyObdDo,4))
    tmhlispvw->EVIDDNY := ( dDatTmp - CtoD( "01.01." +Left(cKeyObdDo,4)) ) +1
  endif

  tmhlispvw->KONECEP := if( msprc_mot->nTmDatVyst = 99999999, 0, msprc_mot->nTmDatVyst)

  if !Empty( msprc_mot->dDatNast)
    tmhlispvw->DOBAZAM  := Round( ( dLASTday - msprc_mot->dDatNast) /365, 2)
  endif

  tmhlispvw->PRUMVYD  := msprc_mot->nHodPrumPP

  filtrs := Format( "noscisprac = %% and nrokobd >= %% and nrokobd <= %%", {msprc_mot->noscisprac, Val(cKeyObdOd),Val(cKeyObdDo)})
  mzdyitt->( Ads_setAOF(filtrs), dbGoTop())
   do while .not. mzdyitt ->( Eof())
     SumISCPV()
     mzdyitt->( dbSkip())
   enddo
  mzdyitt->( Ads_ClearAOF())

  tmhlispvw->FONDSTA  := tmhlispvw->ODPRACD - tmhlispvw->PRESCAS + tmhlispvw->ABSCELK
  tmhlispvw->FONDSJE  := tmhlispvw->FONDSTA

  tmhlispvw->qFONDSTA := tmhlispvw->qODPRACD - tmhlispvw->qPRESCAS + tmhlispvw->qABSCELK
  tmhlispvw->qFONDSJE := tmhlispvw->qFONDSTA

//  tmhlispvw->KONTOPD := if( tmhlispvw->ODPRACD > 0, "A", "N")
  tmhlispvw->KONTOPD := if( msprc_mot->lKonPDIspv, "A", "N")

  if( tmhlispvw->ODPRACD +tmhlispvw->PRESCAS                                        ;
       +tmhlispvw->ABSCELK +tmhlispvw->ABSNEMOC +tmhlispvw->ABSPLAC +tmhlispvw->ABSDOVOL        ;
       +tmhlispvw->MZDA +tmhlispvw->POPRAV +tmhlispvw->PONEPRAV +tmhlispvw->PRIPPCAS           ;
       +tmhlispvw->PRIPLAT +tmhlispvw->NAHRADY +tmhlispvw->POHOTOV = 0   ;
        ,tmhlispvw->( dbDelete()), nil)

return( nil)


static function SumISCPV()
  local lqart

  lqart := mh_CTVRTzOBDn( mzdyitt->nobdobi) = mh_CTVRTzOBDn( uctOBDOBI:MZD:NOBDOBI)

  if C_TypDmzt->cTypNapHoC = "OD"
    tmhlispvw->OdpracD  += mzdyitt->nHodDoklad
    tmhlispvw->qOdpracD += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy > 139 .and. mzdyitt->nDruhmzdy < 150 .and. mzdyitt->nDruhmzdy <> 143
    tmhlispvw->prescas  += mzdyitt->nHodDoklad
    tmhlispvw->qprescas += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if ( mzdyitt->nDruhmzdy >= 180 .and. mzdyitt->nDruhmzdy <= 195) .or.     ;
      ( mzdyitt->nDruhmzdy >= 400 .and. mzdyitt->nDruhmzdy <= 499)
    tmhlispvw->abscelk  += mzdyitt->nHodDoklad
    tmhlispvw->qabscelk += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy >= 190 .and. mzdyitt->nDruhmzdy <= 191
    tmhlispvw->absnemoc  += mzdyitt->nHodDoklad
    tmhlispvw->qabsnemoc += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy = 400 .or. mzdyitt->nDruhmzdy = 410 .or. mzdyitt->nDruhmzdy = 419
    tmhlispvw->absnemoc  += mzdyitt->nHodDoklad
    tmhlispvw->qabsnemoc += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy >= 180 .and. mzdyitt->nDruhmzdy <= 189
    tmhlispvw->absplac  += mzdyitt->nHodDoklad
    tmhlispvw->qabsplac += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy >= 180 .and. mzdyitt->nDruhmzdy <= 181
    tmhlispvw->absdovol  += mzdyitt->nHodDoklad
    tmhlispvw->qabsdovol += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  if mzdyitt->nDruhmzdy = 409 .or. mzdyitt->nDruhmzdy = 411 .or. mzdyitt->nDruhmzdy = 420
    tmhlispvw->absnemoc  += mzdyitt->nHodDoklad
    tmhlispvw->qabsnemoc += if( lqart, mzdyitt->nHodDoklad, 0)

    tmhlispvw->absnemz   += mzdyitt->nHodDoklad
    tmhlispvw->qabsnemz  += if( lqart, mzdyitt->nHodDoklad, 0)
  endif

  do case
  case mzdyitt->nDruhMzdy = 901 .or. ( mzdyitt->nDruhmzdy >= 910 .and. mzdyitt->nDruhmzdy <= 917)
    tmhlispvw->mzda  += mzdyitt->nMzda
    tmhlispvw->qmzda += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy >= 127 .and. mzdyitt->nDruhmzdy <= 127
    tmhlispvw->poprav  += mzdyitt->nMzda
    tmhlispvw->qpoprav += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy >= 150 .and. mzdyitt->nDruhmzdy <= 169
    tmhlispvw->poneprav  += mzdyitt->nMzda
    tmhlispvw->qponeprav += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy >= 140 .and. mzdyitt->nDruhmzdy <= 140
    tmhlispvw->prippcas  += mzdyitt->nMzda
    tmhlispvw->qprippcas += if( lqart, mzdyitt->nMzda, 0)

  case ( mzdyitt->nDruhmzdy >= 130 .and. mzdyitt->nDruhmzdy <= 139)                        ;
          .or. mzdyitt->nDruhmzdy >= 230 .and. mzdyitt->nDruhmzdy <= 239
    tmhlispvw->priplat  += mzdyitt->nMzda
    tmhlispvw->qpriplat += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy >= 180 .and. mzdyitt->nDruhmzdy <= 189
    tmhlispvw->mzda     -= mzdyitt->nMzda
    tmhlispvw->nahrady  += mzdyitt->nMzda
    tmhlispvw->qmzda    -= if( lqart, mzdyitt->nMzda, 0)
    tmhlispvw->qnahrady += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy >= 137 .and. mzdyitt->nDruhmzdy <= 137
    tmhlispvw->pohotov  += mzdyitt->nMzda
    tmhlispvw->qpohotov += if( lqart, mzdyitt->nMzda, 0)

  case mzdyitt->nDruhmzdy = 409 .or. mzdyitt->nDruhmzdy = 411 .or. mzdyitt->nDruhmzdy = 420
    tmhlispvw->nahrnemz  += mzdyitt->nMzda
    tmhlispvw->qnahrnemz += if( lqart, mzdyitt->nMzda, 0)

  endcase

return( nil)