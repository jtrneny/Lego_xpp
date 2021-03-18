#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"



function AktMzdListy()
  local cFiltr
  local ckey, ckeycp
  local aDMZ, alineDMZ
  local aPPV
  local n,i, j, k, m
  local nval
  local ntyp      //  0 - nic, 1 - dny, 2 - hod, 3 - mzda
  local cblok
  local newARR := .f.
  local catribut, ccatrcol, cnatrcol
  local cvykaz
  local nsidhd000,nsidhd999

//  drgDBMS:open('MZDLISTH')
//  drgDBMS:open('MZDLISTI')
//  drgDBMS:open('MSPRC_MO')
//  drgDBMS:open('MSPRC_OS')

  drgDBMS:open('mzdlisth',,,,,'mzdlistha')
  drgDBMS:open('mzdlisti',,,,,'mzdlistia')
  drgDBMS:open('defvykit',,,,,'defvykita')
  drgDBMS:open('defvyksy',,,,,'defvyksya')

  drgDBMS:open('msprc_mo',,,,,'msprc_moa')
  drgDBMS:open('msprc_mo',,,,,'msprc_mom')
  drgDBMS:open('msosb_mo',,,,,'msosb_mom')
  drgDBMS:open('osoby',,,,,'osobya')
  drgDBMS:open('mzdyit',,,,,'mzdyita')

  defvyksya->( AdsSetOrder( 'DEFVYKSY03'))
  defvykita->( DbSetRelation( 'defvyksya',  {|| defvykita->cidsysvykn }, 'defvykita->cidsysvykn'))
  defvykita->( dbGoTop())

  aDmz      := {}
  aPPV      := {}
  i         := 0
  nsidhd000 := 0
  nsidhd999 := 0

//  cFiltr  := format( "nrok = %%", { uctOBDOBI_LAST:MZD:NROK } )
  cFiltr  := format( "nrok = %%", { uctOBDOBI:MZD:NROK } )

  mzdlistha->( ads_setAof( cfiltr), dbgoTop())
  mzdlistha->( dbEval({|| if( Rlock(), dbdelete(),nil)}))
  mzdlistha->( dbUnlock())
  mzdlistha->( Ads_ClearAof())

  mzdlistia->( ads_setAof( cfiltr ), dbgoTop())
  mzdlistia->( dbEval({|| if( Rlock(), dbdelete(),nil)}))
  mzdlistia->( dbUnlock())
  mzdlistia->( Ads_ClearAof())

  cvykaz := AllTrim( SysConfig('Mzdy:cIDvykMzLi'))

//  cFiltr := "cTask = 'MZD' .and. cIdVykazu = cvykaz .and. nsloupvyk = 1"
  cFiltr  := format( "cIdVykazu = '%%' .and. cTask = 'MZD' .and. nsloupvyk = 1", { cvykaz } )
  defvykita->( ADS_SetAOF( cFiltr), dbGoTop())

  do while .not. defvykita->( Eof())
    ntyp   := 0
    cblok  := Lower(AllTrim(defvyksya->mblock))
    if .not. Empty(cblok)
      do case
      case cblok = 'mzdyit->ndnydoklad'     ;    ntyp := 1        // dny
      case cblok = 'mzdyit->nhoddoklad'     ;    ntyp := 2        // hodiny
      case cblok = 'mzdyit->nmzda'          ;    ntyp := 3        // mzda
      endcase

      if ntyp > 0
        alineDMZ := mh_token(AllTrim(defvykita->mvyber))
        if .not. Empty(alineDMZ)
          for n := 1 to Len( alineDMZ)
            if .not. Empty(admz)
              if (i := ascan( admz, {|X| X[1] == alineDMZ[n]})) = 0
                AAdd( admz, { alineDMZ[n], { {},{},{} } } )   // admz[n,2,ntyp]
              endif
            else
              AAdd( admz, { alineDMZ[n], { {},{},{} } } )   // admz[n,2,ntyp]
            endif
            i := ascan( admz, {|X| X[1] == alineDMZ[n]})
            AAdd( admz[i,2,ntyp], defvykita->nradekvyk )   // admz[n,2,ntyp]
          next
        endif
      endif
    endif

    defvykita->( dbSkip())
  enddo

  defvykita->( Ads_ClearAof())

//  cFiltr  := format( "cobdobi = '%%'", { uctOBDOBI_LAST:MZD:COBDOBI } )
  cFiltr  := format( "cobdobi = '%%' .and. nstavrok = 1", { uctOBDOBI:MZD:COBDOBI } )
  msprc_moa->( ads_setAof( cFiltr ), dbgoTop())

  do while .not. msprc_moa->(Eof())
//    if mzdyita->( dbSeek( msprc_moa->cRoCpPPV,,'MZDYIT21'))
      if .not. Empty(aPPV)
        if (i := ascan( aPPV, {|X| X[1] = msprc_moa->nOsCisPrac})) = 0
          AAdd( aPPV, { msprc_moa->nOsCisPrac, {} } )   // admz[n,2,ntyp]
        endif
      else
        AAdd( aPPV, { msprc_moa->nOsCisPrac, {} })   // admz[n,2,ntyp]
      endif
      i := ascan( aPPV, {|X| X[1] == msprc_moa->nOsCisPrac})
      AAdd( aPPV[i,2], msprc_moa->crocpppv )   // admz[n,2,ntyp]
//    endif
    msprc_moa->( dbSkip())
  enddo

//  cFiltr  := format( "cobdobi = '%%'", { uctOBDOBI_LAST:MZD:COBDOBI } )
  cFiltr  := format( "cobdobi = '%%' .and. nstavrok = 1", { uctOBDOBI:MZD:COBDOBI } )
  msprc_mom->( ads_setAof( cFiltr ), dbgoTop())

  drgServiceThread:progressStart(drgNLS:msg('Aktualizace mzdových listù  ... '), len( aPPV))

  for n := 1 to len( aPPV)
    lgenSum := ( Len( aPPV[n,2]) > 1)      // více pracovních vztahù

    if msprc_mom->( dbSeek( aPPV[n,1],,'MSPRMO18' ))
      mh_copyfld( 'msprc_mom', 'mzdlistha',.t.)
      mzdlistha->nporpravzt := 0
      mzdlistha->crocpppv   := Left(mzdlistha->crocpppv, 9) +'000'
      mzdlistha->crocp      := Left(mzdlistha->crocpppv, 9)

      MLRetMzLiPPV()
      MLRetMzLiRoPr()
      MLRetMzLiDuch()
      MLRetMzLiNem()
    endif

    if lgenSum
      //  založení hlavièky mzd.listu
      mh_copyfld( 'msprc_mom', 'mzdlistha',.t.)
      mzdlistha->nporpravzt := 999
      mzdlistha->crocpppv   := Left(mzdlistha->crocpppv, 9) +'999'
      mzdlistha->crocp      := Left(mzdlistha->crocpppv, 9)
      nsidhd999             := mzdlistha->sid
    endif

    for i := 1 to len( aPPV[n,2])
      cFiltr  := format( "crocpppv = '%%'", { aPPV[n,2,i] } )
      mzdyita->( ads_setAof( cfiltr ), dbgoTop())


      if .not. mzdlistha->( dbSeek( mzdyita->crocpppv,,'MZDLISTI10')) .and.  ;
           .not. Empty( mzdyita->crocpppv )
        //  založení hlavièky mzd.listu
        osobya->( dbSeek( mzdyita->noscisprac,,'OSOBY03' ))
        mh_copyfld( 'mzdyita', 'mzdlistha',.t.)

        mzdlistha->crocp     := Left(mzdlistha->crocpppv, 9)
        mzdlistha->nosoby    := osobya->sid
        mzdlistha->nmsosb_mo := msprc_mom->nmsosb_mo
      endif

      do while .not. mzdyita->( Eof())
        if ( j := ascan( admz, {|X| Val(X[1]) = mzdyita->ndruhmzdy})) > 0
          for k := 1 to 3
            /// procházím dny, hod, mzdu
            do case
            case k = 1   ;   catribut := 'ndnydoklad'
            case k = 2   ;   catribut := 'nhoddoklad'
            case k = 3   ;   catribut := 'nmzda'
            endcase

            if .not. Empty( admz[j,2,k])
              for m := 1 to Len(admz[j,2,k])
                ///   jsem na øádcích
                ckey   := mzdyita->crocpppv+'200'+StrZero(admz[j,2,k,m],4)
                ckeycp := Left(mzdyita->crocpppv,9) + '999'+ '200' +StrZero(admz[j,2,k,m],4)

                if .not. mzdlistia->( dbSeek( ckey,,'MZDLISTI09'))
                  //  nObdobi_01 ...
                  mh_copyfld( 'mzdyita', 'mzdlistia',.t.)
                  mzdlistia->nradmzdlis := admz[j,2,k,m]
                  mzdlistia->nradmzdlis := admz[j,2,k,m]
                  mzdlistia->ntypradmzl := 200
                  mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
                  mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
                  mzdlistia->nmzdlisth  := mzdlistha->sid

//                  ckey := UPPER(cIDvykazu)+STRZERO(nRadekVyk,4)+STRZERO(nSloupVyk,2)   TYPE(INDEX) NAME(DEFVYKIT08) FNAME(DefVykIT) CAPTION(Idvykazu+ØádVy+Sloup)           KEY()

                  ckey := UPPER(cvykaz)+STRZERO(admz[j,2,k,m],4)+ '01'
                  if defvykita->( dbSeek( ckey,,'DEFVYKIT08'))
                    mzdlistia->cskupina1  := defvykita->cskupina1
                    mzdlistia->cradmzdlis := defvykita->cnazradvyk
                    mzdlistia->cTextRadek := defvykita->cTextRadek
                  endif

                endif
                ccatrcol := 'cobdobi_' + StrZero( mzdyita->nobdobi,2)
                cnatrcol := 'nobdobi_' + StrZero( mzdyita->nobdobi,2)

                mzdlistia->&cnatrcol += mzdyita->&catribut
                mzdlistia->&ccatrcol := Str(mzdlistia->&cnatrcol,10,2)

                mzdlistia->ncelkemrok := mzdlistia->nobdobi_01+mzdlistia->nobdobi_02+mzdlistia->nobdobi_03+ ;
                                         mzdlistia->nobdobi_04+mzdlistia->nobdobi_05+mzdlistia->nobdobi_06+ ;
                                         mzdlistia->nobdobi_07+mzdlistia->nobdobi_08+mzdlistia->nobdobi_09+ ;
                                         mzdlistia->nobdobi_10+mzdlistia->nobdobi_11+mzdlistia->nobdobi_12
                mzdlistia->ccelkemrok := Str(mzdlistia->ncelkemrok,10,2)

                if lgenSum
                  if .not. mzdlistia->( dbSeek( ckeycp,,'MZDLISTI09'))
                    mh_copyfld( 'mzdyita', 'mzdlistia',.t.)
                    mzdlistia->nporpravzt := 999
                    mzdlistia->nradmzdlis := admz[j,2,k,m]
                    mzdlistia->nradmzdlis := admz[j,2,k,m]
                    mzdlistia->ntypradmzl := 200
                    mzdlistia->crocpppv   := Left(mzdlistia->crocpppv, 9) +'999'
                    mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
                    mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
                    mzdlistia->nmzdlisth  := nsidhd999

//                  ckey := UPPER(cIDvykazu)+STRZERO(nRadekVyk,4)+STRZERO(nSloupVyk,2)   TYPE(INDEX) NAME(DEFVYKIT08) FNAME(DefVykIT) CAPTION(Idvykazu+ØádVy+Sloup)           KEY()

                    ckey := UPPER(cvykaz)+STRZERO(admz[j,2,k,m],4)+ '01'
                    if defvykita->( dbSeek( ckey,,'DEFVYKIT08'))
                      mzdlistia->cskupina1  := defvykita->cskupina1
                      mzdlistia->cradmzdlis := defvykita->cnazradvyk
                      mzdlistia->cTextRadek := defvykita->cTextRadek
                    endif
                  endif

                  ccatrcol := 'cobdobi_' + StrZero( mzdyita->nobdobi,2)
                  cnatrcol := 'nobdobi_' + StrZero( mzdyita->nobdobi,2)

                  mzdlistia->&cnatrcol += mzdyita->&catribut
                  mzdlistia->&ccatrcol := Str(mzdlistia->&cnatrcol,10,2)

                  mzdlistia->ncelkemrok := mzdlistia->nobdobi_01+mzdlistia->nobdobi_02+mzdlistia->nobdobi_03+ ;
                                           mzdlistia->nobdobi_04+mzdlistia->nobdobi_05+mzdlistia->nobdobi_06+ ;
                                           mzdlistia->nobdobi_07+mzdlistia->nobdobi_08+mzdlistia->nobdobi_09+ ;
                                           mzdlistia->nobdobi_10+mzdlistia->nobdobi_11+mzdlistia->nobdobi_12
                  mzdlistia->ccelkemrok := Str(mzdlistia->ncelkemrok,10,2)
                endif

                mzdlistia->nradekvyk := mzdlistia->nradmzdlis
                mzdlistia->crocp     := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
              next
            endif
          next
        endif
        mzdyita->( dbSkip())
      enddo
    next
    drgServiceThread:progressInc()
   next

  defvykita->( dbCloseArea())
  defvyksya->( dbCloseArea())

  drgServiceThread:progressEnd()


return .t.



// pracovní vztahy
function MLRetMzLiPPV()
  local n
  local lone := .t.
  local ky, tmKey

  drgDBMS:open('prsmldoh',,,,,'prsmldohm')
  drgDBMS:open('msprc_mo',,,,,'msprc_mop')
  cFiltr := Format("nOsCisPrac = %%",       ;
                      {msprc_mom->noscisprac })
  prsmldohm->(ads_setaof( cFiltr),dbGoTop())
   if prsmldohm->(Ads_GetRecordCount()) > 0
     do while .not. prsmldohm->( Eof())
       if ( Empty( prsmldohm->dDatVyst)        ;
             .or. Year(prsmldohm->dDatVyst) >= msprc_mom->nrok ) .and. ;
                Year(prsmldohm->dDatNast) <= msprc_mom->nrok //.and.     ;
//                  prsmldohm->nporpravzt = msprc_mom->nporpravzt

//           tmKey := msprc_mom->crocpppv+'010'+StrZero( 10,4)
//         if .not. mzdlistia->(dbSeek(tmKey,,'MZDLISTI09'))
           mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
           mzdlistia->nporpravzt := 0
           mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
           mzdlistia->nradmzdlis := 10
           mzdlistia->nradmzdlis := 10
           mzdlistia->ntypradmzl := 10
           mzdlistia->cSkupina1  := '050'
//           mzdlistia->cRoCp      := msprc_mom->cRoCp    //+StrZero(prsmldohm->nporpravzt,3)
           mzdlistia->nprsmldoh  := isNull( prsmldohm->sID, 0)
           mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
           mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
           mzdlistia->cradmzdlis := 'Pracovní vztah - poøadí ' + StrZero( prsmldohm->nPorPravzt,3)
           mzdlistia->cTextRadek := mzdlistia->cradmzdlis
           mzdlistia->nmzdlisth  := mzdlistha->sid
//           mzdlistia->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
//           mzdlistia->ckey      := ky
//         endif

       endif
       prsmldohm->( dbSkip())
     enddo
   else
     tmKey := msprc_mom->crocpppv+'010'+StrZero( 10,4)
     if .not. mzdlistia->(dbSeek(tmKey,,'MZDLISTI09'))
       mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
       mzdlistia->nporpravzt := 0
       mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
       mzdlistia->nradmzdlis := 10
       mzdlistia->nradmzdlis := 10
       mzdlistia->ntypradmzl := 10
       mzdlistia->cSkupina1  := '010'
       mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
       mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
       mzdlistia->cradmzdlis := 'Pracovní vztah - poøadí ' + StrZero( prsmldohm->nPorPravzt,3)
       mzdlistia->cTextRadek := mzdlistia->cradmzdlis
       mzdlistia->nmzdlisth  := mzdlistha->sid
//       mzdlistia->cRoCp      := msprc_mom->cRoCp    //+StrZero(prsmldohm->nporpravzt,3)//
     endif

   endif
  prsmldohm->(ads_clearaof())
//  prsmldohm->( dbCloseArea())
//  msprc_mop->( dbCloseArea())

return nil


// rodinní pøíslušníci
function MLRetMzLiRoPr()
  local n
  local ky, tmKey

  drgDBMS:open('vazosoby',,,,,'vazosobym')
  drgDBMS:open('msodppol',,,,,'msodppolm')

  cFiltr := Format("OSOBY = %%", {msprc_mom->nosoby})
  vazosobym->(ads_setaof( cFiltr),dbGoTop())

   if vazosobym->(Ads_GetRecordCount()) > 0
     do while .not. vazosobym->( Eof())
       cFiltr := Format("nvazosoby = %% and nrok = %%", {isNull( vazosobym->sid, 0),msprc_mom->nrok})
       msodppolm->(ads_setaof( cFiltr),dbGoTop())
       if msodppolm->(Ads_GetRecordCount()) > 0
         do while .not. msodppolm->( Eof())
           mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
           mzdlistia->nporpravzt := 0
           mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
           mzdlistia->nradmzdlis := 20
           mzdlistia->nradmzdlis := 20
           mzdlistia->ntypradmzl := 10
           mzdlistia->cSkupina1  := '055'

           mzdlistia->nvazosoby  := vazosobym->nosoby
           mzdlistia->nmsodppol  := isNull( msodppolm->sID, 0)
           mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
           mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
           mzdlistia->cradmzdlis := 'Rodinní pøíslušníci - poøadí ' + StrZero( msodppolm->nPoradi,2)
           mzdlistia->cTextRadek := mzdlistia->cradmzdlis
           mzdlistia->nmzdlisth  := mzdlistha->sid

           msodppolm->( dbSkip())
         enddo
       else
         mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
         mzdlistia->nporpravzt := 0
         mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
         mzdlistia->nradmzdlis := 20
         mzdlistia->nradmzdlis := 20
         mzdlistia->ntypradmzl := 10
         mzdlistia->cSkupina1   := '055'

         mzdlistia->nvazosoby  := vazosobym->nosoby
         mzdlistia->nmsodppol  := 0
         mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
         mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
         mzdlistia->cradmzdlis := 'Rodinní pøíslušníci - poøadí ' + StrZero( msodppolm->nPoradi,2)
         mzdlistia->cTextRadek := mzdlistia->cradmzdlis
         mzdlistia->nmzdlisth  := mzdlistha->sid
       endif
       vazosobym->( dbSkip())
     enddo
   else
     mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
     mzdlistia->nporpravzt := 0
     mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
     mzdlistia->nradmzdlis := 20
     mzdlistia->nradmzdlis := 20
     mzdlistia->ntypradmzl := 10
     mzdlistia->cSkupina1  := '055'
     mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
     mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
     mzdlistia->cradmzdlis := 'Rodinní pøíslušníci - poøadí ' + StrZero( msodppolm->nPoradi,2)
     mzdlistia->cTextRadek := mzdlistia->cradmzdlis
     mzdlistia->nmzdlisth  := mzdlistha->sid
   endif

  msodppolm->(ads_clearaof())
  vazosobym->(ads_clearaof())

return nil


// dùchody
function MLRetMzLiDuch()
  local n
  local ky, tmKey

  drgDBMS:open('duchody',,,,,'duchodym')

  cFiltr := Format("nOsCisPrac = %%", {msprc_mom->noscisprac})
  duchodym->(ads_setaof( cFiltr),dbGoTop())

  if duchodym->(Ads_GetRecordCount()) > 0
     do while .not. duchodym->( Eof())
       mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
       mzdlistia->nporpravzt := 0
       mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
       mzdlistia->nradmzdlis := 30
       mzdlistia->nradmzdlis := 30
       mzdlistia->ntypradmzl := 10
       mzdlistia->cSkupina1  := '058'
       mzdlistia->nduchody   := isNull( duchodym->sID, 0)
       mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
       mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
       mzdlistia->cradmzdlis := 'Dùchod - poøadí ' + StrZero( duchodym->nPorDuchod,2)
       mzdlistia->cTextRadek := mzdlistia->cradmzdlis
       mzdlistia->nmzdlisth  := mzdlistha->sid

       duchodym->( dbSkip())
     enddo
   else
     mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
     mzdlistia->nporpravzt := 0
     mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
     mzdlistia->nradmzdlis := 30
     mzdlistia->nradmzdlis := 30
     mzdlistia->ntypradmzl := 10
     mzdlistia->cSkupina1  := '058'
     mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
     mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
     mzdlistia->cradmzdlis := 'Dùchod - poøadí ' + StrZero( duchodym->nPorDuchod,2)
     mzdlistia->cTextRadek := mzdlistia->cradmzdlis
     mzdlistia->nmzdlisth  := mzdlistha->sid
   endif

  duchodym->(ads_clearaof())

return nil


// nemocenské dávky
function MLRetMzLiNem()
  local n
  local ky, tmKey

  drgDBMS:open('mzddavhd',,,,,'mzddavhdm')
  drgDBMS:open('mzddavit',,,,,'mzddavitm')

  cFiltr := Format("nRok = %% .and. nOsCisPrac = %% .and. cDenik = 'MN'", {msprc_mom->nrok, msprc_mom->noscisprac})
  mzddavitm->(ads_setaof( cFiltr),dbGoTop())

  if mzddavitm->(Ads_GetRecordCount()) > 0
     do while .not. mzddavitm->( Eof())
       mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
       mzdlistia->nporpravzt := 0
       mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
       mzdlistia->nradmzdlis := 40
       mzdlistia->nradmzdlis := 40
       mzdlistia->ntypradmzl := 10
       mzdlistia->cSkupina1  := '060'
       mzdlistia->nmzddavit  := isNull( mzddavitm->sID, 0)
       mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
       mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
       mzdlistia->cradmzdlis := 'Nemoc - poøadí ' + StrZero( mzddavitm->nPoradi,2)
       mzdlistia->cTextRadek := mzdlistia->cradmzdlis
       mzdlistia->nmzdlisth  := mzdlistha->sid

       mzddavitm->( dbSkip())
     enddo
   else
     mh_COPYFLD('msprc_mom', 'mzdlistia', .T.)
     mzdlistia->nporpravzt := 0
     mzdlistia->crocpppv   := Left(msprc_mom->crocpppv, 9) +'000'
     mzdlistia->nradmzdlis := 40
     mzdlistia->nradmzdlis := 40
     mzdlistia->ntypradmzl := 10
     mzdlistia->cSkupina1  := '060'
     mzdlistia->nradekvyk  := mzdlistia->nradmzdlis
     mzdlistia->crocp      := StrZero(mzdlistia->nrok,4) + StrZero(mzdlistia->noscisprac,5)
     mzdlistia->cradmzdlis := 'Nemoc - poøadí ' + StrZero( mzddavitm->nPoradi,2)
     mzdlistia->cTextRadek := mzdlistia->cradmzdlis
     mzdlistia->nmzdlisth  := mzdlistha->sid
   endif

  mzddavitm->(ads_clearaof())

return nil