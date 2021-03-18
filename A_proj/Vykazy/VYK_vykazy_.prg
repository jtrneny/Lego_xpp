#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"
//
#include "..\A_main\ace.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


// Doplòkové funkce pro jednotlivé moduly do výkazù


//// ------------------------- MZDY ------------------------------------------------
// Vrátí pøíslušná období pro výkaz potvrzení o zdanitelném pøíjmu
//    hodnoty parametrù
//               1  -  z MSPRC_MO vrátí období ve kterých podepsal daòové prohlášení
//               2  -  z MZDYHD vrátí období ve kterých mìl zúètovaný pøíjem
//               3  -  z MZDYHD vrátí období ve kterých mìl vypoètenou solidární daò
//               4  -  z MZDYHD vrátí období ve kterých mìl uplatnìnu slevu na dani
//
function fRetObdPotvrz(typ)
  local cret := ''
  local tmKey
  local aobd := {'--','--','--','--','--','--','--','--','--','--','--','--'}

//  tmKey  := Upper(Left(VYKAZW->cKey,12))

  do case
  case  typ = 1
    drgDBMS:open('msprc_mo',,,,,'msprc_mof')

    cFiltr := Format("nRok = %% and nOsCisPrac = %%", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)) })
    msprc_mof->(ads_setaof(cFiltr),dbGoTop())
     do while .not. msprc_mof->( Eof())
       if msprc_mof->lDanProhl //.and. msprc_mof->lStavem
         aobd[msprc_mof->nobdobi] := Left( msprc_mof->cobdobi,2)
       endif
       msprc_mof->( dbSkip())
     enddo
    msprc_mof->(ads_clearaof())

  case  typ = 2
    drgDBMS:open('mzdyhd',,,,,'mzdyhdf')
    cFiltr := Format("nRok = %% and nOsCisPrac = %%", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)) })
    mzdyhdf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. mzdyhdf->( Eof())
       if mzdyhdf->nDanZaklMz <> 0
         aobd[mzdyhdf->nobdobi] := Left( mzdyhdf->cobdobi,2)
       endif
       mzdyhdf->( dbSkip())
     enddo
    mzdyhdf->(ads_clearaof())

  case  typ = 3
    drgDBMS:open('mzdyhd',,,,,'mzdyhdf')
    cFiltr := Format("nRok = %% and nOsCisPrac = %%", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)) })
    mzdyhdf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. mzdyhdf->( Eof())
       if mzdyhdf->nDanSolVyp <> 0
         aobd[mzdyhdf->nobdobi] := Left( mzdyhdf->cobdobi,2)
       endif
       mzdyhdf->( dbSkip())
     enddo
    mzdyhdf->(ads_clearaof())

  case  typ = 4
    drgDBMS:open('mzdyhd',,,,,'mzdyhdf')
    cFiltr := Format("nRok = %% and nOsCisPrac = %%", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)) })
    mzdyhdf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. mzdyhdf->( Eof())
       if mzdyhdf->nSlevaDanU <> 0
         aobd[mzdyhdf->nobdobi] := Left( mzdyhdf->cobdobi,2)
       endif
       mzdyhdf->( dbSkip())
     enddo
    mzdyhdf->(ads_clearaof())
  endcase

  AEval( aobd, { |a|  cret += a + '.' })

return( cret)


// Vrátí pøíslušné období OD-DO a jméno rodinného pøíslušníka pro slevu na dani
//   pøedávaný parametr uvádí poøadí slevy
//
//
function fRetDanZvyh(por)
  local cret := ''
  local n := 1
  local tmKey

    drgDBMS:open('msodppol',,,,,'msodppolf')
    drgDBMS:open('vazosoby',,,,,'vazosobyf')
    drgDBMS:open('osoby',,,,,'osobyf')

    cFiltr := Format("nRok = %% and nOsCisPrac = %% and cTypOdpPol = '%%'", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)),'DITE'})
//    cFiltr := Format("Upper(cRoCpPPV) == '%%' and cTypOdpPol == '%%'", {Upper(Left(VYKAZW->cKey,9)),'DITE'})
    msodppolf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. msodppolf->( Eof()) .and. n < 5
       if n = por
         if vazosobyf->( dbseek( msodppolf->nvazosoby,, 'ID'))
           if osobyf->( dbseek( vazosobyf->nosoby,, 'ID'))
             cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ AllTrim(osobyf->cosoba) + ' - '+msodppolf->crodcisrp
           endif
         endif
       endif
       n++
       msodppolf->( dbSkip())
     enddo
    msodppolf->(ads_clearaof())

return( cret)


// Vrátí pøíslušné období OD-DO a jméno rodinného pøíslušníka pro slevu na dani
//   pøedávaný parametr uvádí poøadí slevy
//
//
function fRetDanZv15(por)
  local aret := {'','','','',''}
  local n := 1
  local cdite1 := '', cdite2 := '', cdite3 := ''
  local cod1o, cdo1d, cod2o, cdo2d, cod3o, cdo3d
  local tmKey

  drgDBMS:open('msodppol',,,,,'msodppolf')
  drgDBMS:open('vazosoby',,,,,'vazosobyf')
  drgDBMS:open('osoby',,,,,'osobyf')

  cod1o := cdo1d := cod2o := cdo2d := cod3o := cdo3d := ''
    cFiltr := Format("nRok = %% and nOsCisPrac = %% and nporadi = %% and Left(cTypOdpPol,3) = 'DIT'", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)),por})
//    cFiltr := Format("Upper(cRoCpPPV) == '%%' and cTypOdpPol == '%%'", {Upper(Left(VYKAZW->cKey,9)),'DITE'})
    msodppolf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. msodppolf->( Eof()) .and. n < 5
//       if msodppolf->nporadi = por
         if vazosobyf->( dbseek( msodppolf->nvazosoby,, 'ID'))
           if osobyf->( dbseek( vazosobyf->nosoby,, 'ID'))
             do case
             case msodppolf->ctypodppol = 'DIT1'
               if cod1o = ''
                 cod1o := msodppolf->cobdod
               endif
               cdite1 :=  cod1o +'-'+msodppolf->cobddo

             case msodppolf->ctypodppol = 'DIT2'
               if cod2o = ''
                 cod2o := msodppolf->cobdod
               endif
               cdite2 :=  cod2o +'-'+msodppolf->cobddo

             case msodppolf->ctypodppol = 'DIT3'
               if cod3o = ''
                 cod3o := msodppolf->cobdod
               endif
               cdite3 :=  cod3o +'-'+msodppolf->cobddo

             endcase
//             cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ AllTrim(osobyf->cosoba) + ' - '+msodppolf->crodcisrp
             aret[1] := msodppolf->cOsobaRP
             aret[2] := msodppolf->cRodCisRP
             aret[3] := cdite1
             aret[4] := cdite2
             aret[5] := cdite3
           endif
         endif
//       endif
       n++
       msodppolf->( dbSkip())
     enddo
    msodppolf->(ads_clearaof())

return( aret)




// Vrátí pøíslušné období OD-DO a slevu na dani na invaliditu
//   pøedávaný parametr uvádí poøadí slevy
//
//
function fRetDanInv(por)
  local cret := ''
  local n := 1
  local tmKey
  local nline

    drgDBMS:open('msodppol',,,,,'msodppolf')

    do case
    case  Val(Left(VYKAZW->cKey,4)) = 2014    ;   nline := 3
    otherwise                                 ;   nline := 4
    endcase

    cFiltr := Format("nRok = %% and nOsCisPrac = %% and Left(cTypOdpPol,3) = '%%'", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)),'INV'})
//    cFiltr := Format("Upper(cRoCpPPV) == '%%' and Left(cTypOdpPol,3) == '%%'", {Upper(Left(VYKAZW->cKey,9)),'INV'})
    msodppolf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. msodppolf->( Eof()) .and. n < nline
       if n = por
         do case
         case msodppolf->ctypodppol = 'INVC'
           cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ 'Sleva na dani na èásteènou inval.'
         case msodppolf->ctypodppol = 'INVP'
           cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ 'Sleva na dani na plnou inval.'
         case msodppolf->ctypodppol = 'INVZ'
           cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ 'Sleva na dani za ZTP-P'
         endcase
       endif
       n++
       msodppolf->( dbSkip())
     enddo
    msodppolf->(ads_clearaof())

return( cret)


// Vrátí pøíslušné období OD-DO a slevu na dani na studenta
//   pøedávaný parametr uvádí poøadí slevy
//
//
function fRetDanStu(por)
  local cret := ''
  local n := 1
  local tmKey
  local nline

    drgDBMS:open('msodppol',,,,,'msodppolf')
    drgDBMS:open('firmy',,,,,'firmyf')

    do case
    case  Val(Left(VYKAZW->cKey,4)) = 2014    ;   nline := 4
    otherwise                                 ;   nline := 3
    endcase

    cFiltr := Format("nRok = %% and nOsCisPrac = %% and cTypOdpPol = '%%'", {Val(Left(VYKAZW->cKey,4)),Val( Substr(VYKAZW->cKey,5,5)),'STUD'})
//    cFiltr := Format("Upper(cRoCpPPV) == '%%' and cTypOdpPol == '%%'", {Upper(Left(VYKAZW->cKey,9)),'STUD'})
    msodppolf->(ads_setaof(cFiltr),dbGoTop())
     do while .not. msodppolf->( Eof()) .and. n < nline
       if n = por
         firmyf ->( dbSeek( msodppolf->ncisfirmy,,'FIRMY1'))
         cret := msodppolf->cobdod +'-'+msodppolf->cobddo+' '+ msodppolf->cnazev
       endif
       n++
       msodppolf->( dbSkip())
     enddo
    msodppolf->(ads_clearaof())

return( cret)


// pracovní vztahy
function fRetMzLiPPV()
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
                Year(prsmldohm->dDatNast) <= msprc_mom->nrok .and.     ;
                  prsmldohm->nporpravzt = msprc_mom->nporpravzt
         ky    := StrZero( msprc_mom->nrok,4) +               ;
                    StrZero( msprc_mom->noscisprac,5) +       ;
                      StrZero( msprc_mom->nporpravzt,3)
         msprc_mop->(dbSeek(ky,,'MSPRMO22'))
         tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                    +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)
         if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
           mh_COPYFLD('defvykit', 'vykazw', .T.)
           vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
           vykazw->ckey      := ky
           vykazw->nrok      := msprc_mom->nrok
           vykazw->cSortKey1 := msprc_mom->cRoCpPPv //+StrZero(prsmldohm->nporpravzt,3)

           kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                      StrZero( msprc_mom->nporpravzt,3)


           if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
             vykazw->cSortKey2 := msprc_mok->cjmenorozl
             vykazw->cSortKey3 := msprc_mok->ckmenstrpr
           endif
           if lone
             vykazw->nsloupec01  := 1
             lone := .f.
           endif
           vykazw->nTm_sID1    := isNull( prsmldohm->sID, 0)
         endif

       endif
       prsmldohm->( dbSkip())
     enddo
   else
     ky    := StrZero( msprc_mom->nrok,4) +               ;
                StrZero( msprc_mom->noscisprac,5) +       ;
                  StrZero( msprc_mom->nporpravzt,3)

     tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                    +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)
     if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
       mh_COPYFLD('defvykit', 'vykazw', .T.)
       vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
       vykazw->ckey      := ky
       vykazw->nrok      := msprc_mom->nrok
       vykazw->cSortKey1 := msprc_mom->cRoCpPPv
       kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                StrZero( msprc_mom->nporpravzt,3)
       if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
         vykazw->cSortKey2 := msprc_mok->cjmenorozl
         vykazw->cSortKey3 := msprc_mok->ckmenstrpr
       endif
     endif
   endif
  prsmldohm->(ads_clearaof())
//  prsmldohm->( dbCloseArea())
//  msprc_mop->( dbCloseArea())

return nil


// rodinní pøíslušníci
function fRetMzLiRoPr()
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
           ky := StrZero( msprc_mom->nrok,4) +                              ;
                   StrZero( msprc_mom->noscisprac,5) +                      ;
                     '000' +                                                ;
                        StrZero( vazosobym->nosoby,10) +                    ;
                          StrZero( isNull( msodppolm->sID, 0),10)

           tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                     +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

           if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
             mh_COPYFLD('defvykit', 'vykazw', .T.)
             vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
             vykazw->ckey      := ky
             vykazw->nrok      := msprc_mom->nrok
             vykazw->cSortKey1 := msprc_mom->cRoCpPPv
             kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                      StrZero( msprc_mom->nporpravzt,3)
             if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
               vykazw->cSortKey2 := msprc_mok->cjmenorozl
               vykazw->cSortKey3 := msprc_mok->ckmenstrpr
             endif
             vykazw->nTm_sID1  := vazosobym->nosoby
             vykazw->nTm_sID2  := isNull( msodppolm->sID, 0)
           endif
           msodppolm->( dbSkip())
         enddo
       else
         ky := StrZero( msprc_mom->nrok,4) +                              ;
                 StrZero( msprc_mom->noscisprac,5) +                      ;
                   '000' +                                                ;
                      StrZero( vazosobym->nosoby,10) +                    ;
                        StrZero( 0, 10)

         tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                   +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

         if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
           mh_COPYFLD('defvykit', 'vykazw', .T.)
           vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
           vykazw->ckey      := ky
           vykazw->nrok      := msprc_mom->nrok
           vykazw->cSortKey1 := msprc_mom->cRoCpPPv
           kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                      StrZero( msprc_mom->nporpravzt,3)
           if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
             vykazw->cSortKey2 := msprc_mok->cjmenorozl
             vykazw->cSortKey3 := msprc_mok->ckmenstrpr
           endif
           vykazw->nTm_sID1  := vazosobym->nosoby
           vykazw->nTm_sID2  := 0
         endif
       endif
       vazosobym->( dbSkip())
     enddo
   else
     ky := StrZero( msprc_mom->nrok,4) +                            ;
            StrZero( msprc_mom->noscisprac,5) +                     ;
             '000'
     tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                 +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

     if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
       mh_COPYFLD('defvykit', 'vykazw', .T.)
       vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
       vykazw->ckey      := ky
       vykazw->nrok      := msprc_mom->nrok
       vykazw->cSortKey1 := msprc_mom->cRoCpPPv
       kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                StrZero( msprc_mom->nporpravzt,3)
       if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
         vykazw->cSortKey2 := msprc_mok->cjmenorozl
         vykazw->cSortKey3 := msprc_mok->ckmenstrpr
       endif
     endif
   endif
  msodppolm->(ads_clearaof())
  vazosobym->(ads_clearaof())

return nil


// dùchody
function fRetMzLiDuch()
  local n
  local ky, tmKey

  drgDBMS:open('duchody',,,,,'duchodym')

  cFiltr := Format("nOsCisPrac = %%", {msprc_mom->noscisprac})
  duchodym->(ads_setaof( cFiltr),dbGoTop())

  if duchodym->(Ads_GetRecordCount()) > 0
     do while .not. duchodym->( Eof())
       ky := StrZero( msprc_mom->nrok,4) +                              ;
               StrZero( msprc_mom->noscisprac,5) +                      ;
                 '000' +                                                ;
                    StrZero( isNull( duchodym->sID, 0),10)

       tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                  +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

         if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
           mh_COPYFLD('defvykit', 'vykazw', .T.)
           vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
           vykazw->ckey      := ky
           vykazw->nrok      := msprc_mom->nrok
           vykazw->cSortKey1 := msprc_mom->cRoCpPPv
           kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                      StrZero( msprc_mom->nporpravzt,3)
           if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
             vykazw->cSortKey2 := msprc_mok->cjmenorozl
             vykazw->cSortKey3 := msprc_mok->ckmenstrpr
           endif

           vykazw->nTm_sID1 := isNull( duchodym->sID, 0)
         endif
       duchodym->( dbSkip())
     enddo
   else
     ky := StrZero( msprc_mom->nrok,4) +                              ;
            StrZero( msprc_mom->noscisprac,5) +                      ;
             '000'
     tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                  +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

     if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
       mh_COPYFLD('defvykit', 'vykazw', .T.)
       vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
       vykazw->ckey      := ky
       vykazw->nrok      := msprc_mom->nrok
       vykazw->cSortKey1 := msprc_mom->cRoCpPPv
       kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                StrZero( msprc_mom->nporpravzt,3)
       if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
         vykazw->cSortKey2 := msprc_mok->cjmenorozl
         vykazw->cSortKey3 := msprc_mok->ckmenstrpr
       endif
     endif
   endif

  duchodym->(ads_clearaof())

return nil


// nemocenské dávky
function fRetMzLiNem()
  local n
  local ky, tmKey

  drgDBMS:open('mzddavhd',,,,,'mzddavhdm')
  drgDBMS:open('mzddavit',,,,,'mzddavitm')

  cFiltr := Format("nRok = %% .and. nOsCisPrac = %% .and. cDenik = 'MN'", {msprc_mom->nrok, msprc_mom->noscisprac})
  mzddavitm->(ads_setaof( cFiltr),dbGoTop())

  if mzddavitm->(Ads_GetRecordCount()) > 0
     do while .not. mzddavitm->( Eof())
       ky := StrZero( msprc_mom->nrok,4) +                              ;
               StrZero( msprc_mom->noscisprac,5) +                      ;
                 '000' +                                                ;
                    StrZero( isNull( mzddavitm->sID, 0),10) +                    ;
                      StrZero( 0, 10)

       tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                  +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

         if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
           mh_COPYFLD('defvykit', 'vykazw', .T.)
           vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
           vykazw->ckey      := ky
           vykazw->nrok      := msprc_mom->nrok
           vykazw->cSortKey1 := msprc_mom->cRoCpPPv
           kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                      StrZero( msprc_mom->nporpravzt,3)
           if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
             vykazw->cSortKey2 := msprc_mok->cjmenorozl
             vykazw->cSortKey3 := msprc_mok->ckmenstrpr
           endif

           vykazw->nTm_sID1 := isNull( mzddavitm->sID, 0)
           vykazw->nTm_sID2 := 0
         endif
       mzddavitm->( dbSkip())
     enddo
   else
     ky := StrZero( msprc_mom->nrok,4) +                              ;
            StrZero( msprc_mom->noscisprac,5) +                      ;
             '000'
     tmKey := Upper(defvykit->cskupina1)+Upper(defvykit->cskupina2)       ;
                  +Upper(defvykit->cskupina3)+ Padr(ky, 60)+StrZero(defvykit->nradekvyk,4)

     if .not. vykazw->(dbSeek(tmKey,,'VYKAZW01'))
       mh_COPYFLD('defvykit', 'vykazw', .T.)
       vykazw->dposobd   := mh_LastODate( msprc_mom->nrok, msprc_mom->nobdobi)
       vykazw->ckey      := ky
       vykazw->nrok      := msprc_mom->nrok
       vykazw->cSortKey1 := msprc_mom->cRoCpPPv
       kyM := obdKeyML + StrZero( msprc_mom->noscisprac,5) +            ;
                StrZero( msprc_mom->nporpravzt,3)
       if msprc_mok->( dbSeek(kyM,,'MSPRMO17'))
         vykazw->cSortKey2 := msprc_mok->cjmenorozl
         vykazw->cSortKey3 := msprc_mok->ckmenstrpr
       endif
     endif
   endif

  mzddavitm->(ads_clearaof())

return nil


// plnìní z výkazu   nemocenské dávky
function fRetUctVyk()
  local n, nbeg, m
  local ky, tmKey
  local cvyraz, cvyrazall
  local aVal := {}
  local aSlo := {}
  local aDef := {}
  local loper, coper
  local nval := 0
  local nret := 0

  drgDBMS:open('uctvykit',,,,,'uctvykita')

  aSlo := {{'A', 'uctvykita->nsloupec01'},           ;
           {'B', 'uctvykita->nsloupec02'},           ;
           {'C', 'uctvykita->nsloupec03'},           ;
           {'D', 'uctvykita->nsloupec04'},           ;
           {'E', 'uctvykita->nsloupec05'},           ;
           {'F', 'uctvykita->nsloupec06'},           ;
           {'G', 'uctvykita->nsloupec07'},           ;
           {'H', 'uctvykita->nsloupec08'} }

  cvyrazall := defvykit->mvyraz

//  cFiltr := Format("nRok = %% .and. nOsCisPrac = %% .and. cDenik = 'MN'", {msprc_mom->nrok, msprc_mom->noscisprac})
//  mzddavitm->(ads_setaof( cFiltr),dbGoTop())

     if .not. Empty( cvyrazall)
    nbeg := 1

    for n := 1 to len( cvyrazall)
      if SubStr( cvyrazall, n,1) = '+' .or.   ;
          SubStr( cvyrazall, n,1) = '-'
        cvyraz := SubStr( cvyrazall, nbeg, n-1)
        nbeg   := n + 1

        AAdd( adef, cvyraz)
        AAdd( adef, SubStr( cvyrazall, n,1))
      endif
    next

    do case
    case nbeg = 1
      AAdd( adef, cvyrazall)

    case nbeg < len( cvyrazall)
      AAdd( adef, SubStr( cvyrazall, nbeg))
    endcase

    loper := .f.
    coper := ''

    for n := 1 to len( adef)
      if .not. loper
        do case
        case Left(adef[n],1) = 'R'
          ky := Str(uctOBDOBI:UCT:NROKOBD,6) + 'ROZ' + StrZero(Val(SubStr(adef[n],4)),4)
        case Left(adef[n],1) = 'V'
          ky := Str(uctOBDOBI:UCT:NROKOBD,6) + 'VZZ' + StrZero(Val(SubStr(adef[n],4)),4)
        endcase

        if uctvykita->( dbSeek( ky,,'UCTVYKIT06'))
          if ( m := aScan( aSlo,{|X| X[1] = SubStr(adef[n],3,1)})) > 0
            nval := &(aSlo[m,2])
          endif
        endif

        do case
        case coper = '+'    ;    nret += nval
        case coper = '-'    ;    nret -= nval
        otherwise           ;    nret := nval
        endcase

        loper := .t.
      else
        coper := adef[n]
        loper := .f.
      endif
    next
  endif

//     do while .not. mzddavitm->( Eof())

return nret