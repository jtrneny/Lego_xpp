

#include "..\Asystem++\Asystem++.ch"


*
** podklady pro OSOBY vèetnì vazby na VAZOSOBY a MSPRC_MO  *******************************************************
function OSB_osb_vazmsw()
  local filtr
  local nobd_akt
  local pocOdp
  local  aodpDETI := {}

  nobd_akt := (uctOBDOBI:mzd:nrok *100) +uctOBDOBI:mzd:nobdobi

  drgDBMS:open('osoby')
  drgDBMS:open('osoby',,,,,'osobyV')
  drgDBMS:open('vazosoby')
  drgDBMS:open('msprc_mo')
  drgDBMS:open('msodppol')

  drgDBMS:open('tmposobyw',.t.,.t.,drgINI:dir_USERfitm); ZAP

  drgServiceThread:progressStart(drgNLS:msg('Osoby - vazby  ... '), ;
                                             osoby->(lastRec())                 )

  osoby->( dbGoTop())

  do while .not. osoby ->( eof())
    mh_copyfld( 'osoby', 'tmposobyw', .t.)
    tmposobyw ->nOSOBY    := isNull( osoby->sID, 0)
    tmposobyw ->cTmpJmeno := osoby->cJmenoRozl
    tmposobyw->nVekOsoby  := fVEKzDATE( osoby->dDatNaroz, Date())
    VazMsPrc_MO( nobd_akt)

    filtr := Format("OSOBY = %%", {isNull( osoby->sID, 0)})
    vazosoby ->( ads_setaof(filtr), dbGoTop())
    do while .not. vazosoby ->( eof())
      if osobyV ->( dbSeek( vazosoby->nOSOBY,,'ID' ))
        mh_copyfld( 'osobyV', 'tmposobyw', .t.)

        tmposobyw ->cTmpJmeno := osoby->cJmenoRozl
        tmposobyw->cTypRodPri := vazosoby->cTypRodPri
        tmposobyw->lSleOdpDan := vazosoby->lSleOdpDan
        tmposobyw->nVekOsoby  := fVEKzDATE( osoby->dDatNaroz, Date())
        tmposobyw->nOSOBY     := isNull( osoby->sID, 0)

        VazMsPrc_MO( nobd_akt)

        filtr := Format("nROK = %% .and. nCisOsoRP = %%", {msprc_mo->nrok, osobyV->ncisosoby})
        msodppol ->( ads_setaof(filtr), dbGoTop())

        if (pocOdp := msodppol->( Ads_GetRecordCount())) > 0
          AAdd( aodpDETI, { isNull( osoby->sID, 0)} )

          do while .not. msodppol->( Eof())
            if pocOdp > 1
              mh_copyfld( 'osobyV', 'tmposobyw', .t.)
              tmposobyw ->cTmpJmeno := osoby->cJmenoRozl
              tmposobyw->cTypRodPri := vazosoby->cTypRodPri
              tmposobyw->lSleOdpDan := vazosoby->lSleOdpDan
              tmposobyw->nVekOsoby  := fVEKzDATE( osoby->dDatNaroz, Date())
              tmposobyw->nOSOBY     := isNull( osoby->sID, 0)

              VazMsPrc_MO( nobd_akt)
            endif

            tmposobyw->nPorOdpPol := msodppol->nPorOdpPol
            tmposobyw->cTypOdpPol := msodppol->cTypOdpPol
            tmposobyw->cNazOdpPol := msodppol->cNazOdpPol
            tmposobyw->dPlatnOd   := msodppol->dPlatnOd
            tmposobyw->dPlatnDo   := msodppol->dPlatnDo
            tmposobyw->cObdOd     := msodppol->cObdOd
            tmposobyw->cObdDo     := msodppol->cObdDo
            tmposobyw->nOdpocObd  := msodppol->nOdpocObd
            tmposobyw->nOdpocRok  := msodppol->nOdpocRok
            tmposobyw->nDanUlObd  := msodppol->nDanUlObd
            tmposobyw->nDanUlRok  := msodppol->nDanUlRok
            tmposobyw->cRodCisRP  := msodppol->cRodCisRP
            tmposobyw->nCisOsoRP  := msodppol->nCisOsoRP
            tmposobyw->nRodPrisl  := msodppol->nRodPrisl
            tmposobyw->lAktiv     := msodppol->lAktiv
            tmposobyw->lAktMesOdp := msodppol->lAktMesOdp
            tmposobyw->lOdpocet   := msodppol->lOdpocet
            tmposobyw->lDanUleva  := msodppol->lDanUleva

            tmposobyw->lOdpDanUlv := .t.

            msodppol->( dbSkip())
          enddo
        endif
      endif

      vazosoby ->( dbSkip())
    enddo
    vazosoby ->( ads_clearaof())

    tmposobyw->( dbGoTop())

    drgServiceThread:progressInc()
    osoby->(dbSkip())
  enddo

  if .not. Empty( aodpDETI)
    for  n := 1 to len( aodpDETI)
      if tmposobyw->( dbSeek( StrZero(aodpDETI[n,1],5) + StrZero(0,1),,'TMPOSOBYw1'))
        tmposobyw->lOdpDanUlv := .t.
      endif
    next
  endif

  drgServiceThread:progressEnd()
  tmposobyw->(dbcommit())
return .t.

function VazMsPrc_MO( nobd_akt)

  filtr := Format("nROKOBD=%% .and. nCISOSOBY=%%", { nobd_akt, osoby->ncisosoby })
  msprc_mo ->( ads_setaof(filtr))

  if msprc_mo ->( ads_getKeyCount(1)) > 0
    msprc_mo ->( dbGoBotTom())

    tmposobyw ->nrokobd    := msprc_mo->nrokobd
    tmposobyw ->noscisprac := msprc_mo->noscisprac
    tmposobyw ->nporpravzt := msprc_mo->nporpravzt

  endif

return .t.