#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


function DOCH_sum( cisOsoby, rok, obdobi, dsel_Day )
  Local  nTYDEn, nDEN, nNAPprer, nSUMfond, nSTEPs, nKODprerx
  Local  lNAP_den, lNAP_hod, nDENtm
  Local  anKODprer
  local  aFond, aTyd[7], aMes[31]
  local  n
  local  nin, pa_listPrer := {}, skodPrer
  *
  local  ndnyPrcTyd := sysConfig('mzdy:ndnyPrcTyd')
  local  ndelPrcTyd := sysConfig('mzdy:ndelPrcTyd')

  default rok to uctOBDOBI:DOH:NROK
  default obdobi to uctOBDOBI:DOH:NOBDOBI

  aFond := { ndnyPrcTyd, ndelPrcTyd, round( ndelPrcTyd/ndnyPrcTyd,2 ) }
//  aEval( aTyd, { |X|  X := 0 })
//  aEval( aMes, { |X|  X := 0 })
  for n := 1 to Len(aTyd)  ;  aTyd[n] := 0
  next
  for n := 1 to Len(aMes)  ;  aMes[n] := 0
  next


*   mzdy:ndnyPrcTyd   1
*   mzdy:ndelPrcTyd   2
*   2 / 1

  drgDBMS:open('dspohyby',,,,,'dspohybys')
  drgDBMS:open('c_prerus',,,,,'c_preruss')
  drgDBMS:open('kalendar',,,,,'kalendars')
  drgDBMS:open('listit',,,,,'listitd')
  drgDBMS:open('osoby',,,,,'osobyf')
  drgDBMS:open('tmcelsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  tminfsumw->( ordSetFocus(0), dbGoTOP())
  TMInfSUMw->( dbEVAL( { || ( TMInfSUMw->nHOD_den   := 0, ;
                              TMInfSUMw->nDNY_tyden := 0, ;
                              TMInfSUMw->nHOD_tyden := 0, ;
                              TMInfSUMw->nDNY_mesic := 0, ;
                              TMInfSUMw->nHOD_mesic := 0, ;
                              TMInfSUMw->_nvisible  := 0, ;
                              aadd( pa_listPrer, { allTrim(tminfsumW->mnKODprer), tminfsumW->(recNo()) } ) ) }))
  tminfsumw->( dbGoTOP())
  tmcelsumw->( dbAppend())

  if osobyf->( dbSeek( cisOsoby,,'Osoby01'))
    aFond := fPracDOBA( osobyf->cdelkprDOB)
  endif

  cky := StrZero(cisOsoby,6) +StrZero(rok,4) +StrZero(obdobi,2)
  dsPohybyS->( ordSetFocus( 'DSPOHY21' )    , ;
               dbsetScope( SCOPE_BOTH, cky ), ;
               dbgoTop()                      )


  do While .not. dspohybys->( EOF())
    c_preruss ->( dbseek( 'DOH'+Upper(dsPohybyS->ckodprer),,'C_PRERUS05'))
    kalendars->( dbSeek( Dtos(dspohybyS->ddatum),,'KALENDAR01'))

    skodPrer := strZero(dspohybys->nKODprer,3)
    nNAPprer := c_PRERUSs ->nNAPprer
    nSUMfond := c_PRERUSs ->nSUMfond
    lNAP_den := nNAPprer = 1 .or. nNAPprer = 3
    lNAP_hod := ( nNAPprer = 1 .or. nNAPprer = 2 .or. nNAPprer = 3 )

    TMInfSUMw->( dbGOTOP())

    if( nin := ascan( pa_listPrer, { |x| skodPrer $ x[1] } )) <> 0
      tminfsumW->( dbgoTo( pa_listPrer[nin,2]) )
      *
      TMInfSUMw->_nvisible  := 1

      if .not. (dtos(dsPohybyS->dDatum) $ tmINFsumW->_mdatum)
        tmINFsumW->_mdatum := tmINFsumW->_mdatum +dtos(dsPohybyS->dDatum) +','
      endif

      If dspohybys->ddatum = dsel_Day
        If( lNAP_hod, TMInfSUMw->nHOD_den += dspohybys->nCAScelCPD, NIL )
      EndIf

      If Week( dspohybys ->dDATUM) = Week( dsel_Day )//kalendars->ntyden
        If lNAP_den
          IF TMInfSUMw->nDNY_tyden + 1 <= 9
            IF nNAPprer = 3
              TMInfSUMw->nDNY_tyden += MH_RoundNumb( dspohybys->nCAScelCPD/paFOND[1], 212)
            ELSE
              TMInfSUMw->nDNY_tyden += 1
            ENDIF
          ENDIF
        ENDIF
        If( lNAP_hod, TMInfSUMw->nHOD_tyden += dspohybys->nCAScelCPD, NIL )
      EndIf

      IF lNAP_den
        IF nNAPprer = 3
          TMInfSUMw->nDNY_mesic += MH_RoundNumb( dspohybys->nCA65ScelCPD/paFOND[1], 212)
        ELSE
          TMInfSUMw->nDNY_mesic += 1
        ENDIF
      ENDIF
      If( lNAP_hod, TMInfSUMw->nHOD_mesic += dspohybys->nCAScelCPD, NIL )
      *
    endif


    If c_preruss->nSUMfond == 1
      if nNAPprer = 3
        nDENtm := MH_RoundNumb( dspohybys->nCAScelCPD/paFOND[1], 212)
        if dspohybys->ddatum = dsel_Day
          tmcelsumw->ndnydenF := nDENtm
        endif
        if WOM(dspohybys->ddatum) = WOM(dsel_Day)
          tmcelsumw->ndnytydenF += nDENtm
        endif
        tmcelsumw->ndnymesicF += nDENtm
      else
        if dspohybys->ddatum = dsel_Day
          tmcelsumw->ndnydenF := 1
        endif
        if WOM(dspohybys->ddatum) = WOM(dsel_Day)
          tmcelsumw->ndnytydenF += 1
        endif
        tmcelsumw->ndnymesicF += 1
      endif
      if dspohybys->ddatum = dsel_Day
        tmcelsumw->nhoddenF := dspohybys->nCAScelCPD
      endif
      if WOM(dspohybys->ddatum) = WOM(dsel_Day)
        tmcelsumw->nhodtydenF += dspohybys->nCAScelCPD
      endif
      tmcelsumw->nhodmesicF += dspohybys->nCAScelCPD
    EndIf

    If c_preruss->nSUMvyr == 1
      if nNAPprer = 3
        nDENtm := MH_RoundNumb( dspohybys->nCAScelCPD/paFOND[1], 212)
        if dspohybys->ddatum = dsel_Day
          tmcelsumw->ndnydenD := IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
        endif
        if WOM(dspohybys->ddatum) = WOM(dsel_Day)
          tmcelsumw->ndnytydenD += IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
        endif
        tmcelsumw->ndnymesicD += IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
      else
        if dspohybys->ddatum = dsel_Day
          tmcelsumw->ndnydenD := 1
        endif
        if WOM(dspohybys->ddatum) = WOM(dsel_Day)
          tmcelsumw->ndnytydenD += 1
        endif
        tmcelsumw->ndnymesicD += 1
      endif
      if dspohybys->ddatum = dsel_Day
        tmcelsumw->nhoddenD += dspohybys->nCAScelCPD
      endif
      if WOM(dspohybys->ddatum) = WOM(dsel_Day)
        tmcelsumw->nhodtydenD += dspohybys->nCAScelCPD
      endif
      tmcelsumw->nhodmesicD += dspohybys->nCAScelCPD
    EndIf

    dspohybys->( dbSKIP())
  EndDo

  tmINFsumW->( ordSetFocus('TMInfSUMw1'),dbgoTop())

  cfiltr := Format("nCisOsoby = %% .and. nrok = %% .and. nobdobi = %%", {osobyf->nCisOsoby, rok, obdobi})
  listitd->( ads_setaof(cfiltr), dbGoTop())
   do while .not. listitd ->( Eof())
     if listitd->dvyhotskut = dsel_Day
       tmcelsumw->ndnydenV := 1
       tmcelsumw->nhoddenV += listitd->nnhnaopesk
     endif

     if WOM(listitd->dvyhotskut) = WOM(dsel_Day)
       n := DOW(listitd->dvyhotskut)
       aTyd[n] :=  1
       tmcelsumw->nhodtydenV += listitd->nnhnaopesk
     endif

     n := Day(listitd->dvyhotskut)
     aMes[n] :=  1
     tmcelsumw->nhodmesicV += listitd->nnhnaopesk

     listitd->( dbSkip())
   enddo
   tmcelsumw->( dbCommit())

   n := 0
   aEval( aTyd, { |X|  n += X })
   tmcelsumw->ndnytydenV := n

   n := 0
   aEval( aMes, { |X|  n += X })
   tmcelsumw->ndnymesicV := n

   tmcelsumw->ndnydenK   := 1
   tmcelsumw->nhoddenK   := aFond[3]
   tmcelsumw->ndnytydenK := aFond[1]
   tmcelsumw->nhodtydenK := aFond[2]
   tmcelsumw->ndnymesicK := F_PracDny( rok, obdobi )
   tmcelsumw->nhodmesicK := tmcelsumw->ndnymesicK * tmcelsumw->nhoddenK

   tmcelsumw->ndnydenR   := tmcelsumw->ndnydenD   - tmcelsumw->ndnydenV
   tmcelsumw->nhoddenR   := tmcelsumw->nhoddenD   - tmcelsumw->nhoddenV
   tmcelsumw->ndnytydenR := tmcelsumw->ndnytydenD - tmcelsumw->ndnytydenV
   tmcelsumw->nhodtydenR := tmcelsumw->nhodtydenD - tmcelsumw->nhodtydenV
   tmcelsumw->ndnymesicR := tmcelsumw->ndnymesicD - tmcelsumw->ndnymesicV
   tmcelsumw->nhodmesicR := tmcelsumw->nhodmesicD - tmcelsumw->nhodmesicV

*  tmcelsumw->( dbCommit())
*  TMInfSUMw->( dbGOTOP())
Return( Nil)


/*
    If c_PRERUS ->nSUMfond == 1
      nTYDEn := WOM( dspohybys->dDATUM)
      IF nNAPprer = 3
        nDENtm := MH_RoundNumb( dspohybys->nCAScelCPD/paFOND[1], 212)
        dKAL_den[ dspohybys->nDEN, 5] += nDENtm
        dKAL_tyden[ nTYDEn, 2]        += nDENtm
        dKAL_mesic[ 1]                += nDENtm
      ELSE
        dKAL_den[ dspohybys->nDEN, 5] += 1
        dKAL_tyden[ nTYDEn, 2]        += 1
        dKAL_mesic[ 1]                += 1
      ENDIF
      dKAL_den[ dspohybys->nDEN, 6] += dspohybya->nCAScelCPD
      dKAL_tyden[ nTYDEn, 3]        += dspohybya->nCAScelCPD
      dKAL_mesic[ 2]                += dspohybya->nCAScelCPD
    EndIf

    If c_PRERUS ->nSUMvyr == 1
      nTYDEn := WOM( dspohybys->dDATUM)
      IF nNAPprer = 3
        aKAL_den[ dspohybys->nDEN, 5] += IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
        aKAL_tyden[ nTYDEn, 2]        += IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
        aKAL_mesic[ 1]                += IF( dspohybys->nCAScelCPD > 4, 1, 0.5)
      ELSE
        aKAL_den[ dspohybys->nDEN, 5] += 1
        aKAL_tyden[ nTYDEn, 2]        += 1
        aKAL_mesic[ 1]                += 1
      ENDIF
      aKAL_den[ dspohybys->nDEN, 6] += dspohybys->nCAScelCPD
      aKAL_tyden[ nTYDEn, 3]        += dspohybys->nCAScelCPD
      aKAL_mesic[ 2]                += dspohybys->nCAScelCPD
    EndIf
*/