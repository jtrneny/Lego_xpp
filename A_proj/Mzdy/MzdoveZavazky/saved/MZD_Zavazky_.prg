#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"


function MZD_zavazky_gen(oDialog)
  local  file_name, ky
  local  cky := strZero( mzdzavhd->nrok, 4)       +strZero( mzdzavhd->nOBDOBI,2)     + ;
                strZero( mzdzavhd->noscisPrac, 5) +strZero( mzdzavhd->nporPraVzt ,3) + ;
                strZero( mzdzavhd->nDoklad ,10)
  *
  local  lnewRec := if( isnull(oDialog), .f., oDialog:lnewRec )
  local  rok, mes, rokobd
  local  alias
  *
  local  filtrs

  drgDBMS:open('C_SRAZKY')
  drgDBMS:open('MZDYHD',,,,,'mzdyhda')
  drgDBMS:open('MZDYIT',,,,,'mzdyita')

  drgDBMS:open('MSSRZ_MO',,,,,'mssrz_moa')
  drgDBMS:open('MZDDAVIT',,,,,'mzddavita')
  drgDBMS:open('TRVZAVHD')
  drgDBMS:open('FIRMY')

*  drgDBMS:open('MZDZAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
*  drgDBMS:open('MZDZAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  rok     := uctOBDOBI:MZD:NROK
  mes     := uctOBDOBI:MZD:NOBDOBI
  rokobd  := (rok*100)+mes

  filtrs := Format("nROKOBD = %%", {rokObd})
  mzdyhda ->( ads_setaof(filtrs), dbGoTop())
  mzdyita ->( ads_setaof(filtrs), dbGoTop())
  mzdzavhd->( ads_setaof(filtrs), dbGoTop())

  do while .not. mzdzavhd->( Eof())
    if mzdzavhd->( dbRlock())
      mzdzavhd->( dbDelete())
    else
      return nil
    endif
    mzdzavhd->( dbSkip())
  enddo


  do while .not. mzdyita->( Eof())
    if mzdyita->cZkrTypZav = 'SrzMz'
      if .not. Empty(mzdyita->mssrz_mo)
        mssrz_moa->( dbSeek(mzdyita->mssrz_mo,,'ID') )
        alias := 'mssrz_moa'
      else
        mzddavita->( dbSeek(mzdyita->mzddavit,,'ID') )
        alias := 'mzddavita'
      endif
      c_srazky->( dbSeek((alias)->cZkrSrazky,,'C_SRAZKY01') )
      osoby->( dbSeek((alias)->ncisosoby,,'OSOBY01') )

      mzdzavhd->( dbAppend())

      mzdzavhd->culoha      :=  mzdyita->culoha
      mzdzavhd->cdenik      :=  mzdyita->cdenik
      mzdzavhd->ctask       :=  mzdyita->ctask
      mzdzavhd->ctypdoklad  :=  'MZD_ZAVGEN'
      mzdzavhd->ctyppohybu  :=  'GENSRAZKA'
      mzdzavhd->nrok        :=  mzdyita->nrok
      mzdzavhd->nobdobi     :=  mzdyita->nobdobi
      mzdzavhd->cobdobi     :=  mzdyita->cobdobi
      mzdzavhd->dPorizFak   :=  Date()
      mzdzavhd->nDoklad     :=  mzdyita->sid
      mzdzavhd->nCisFak     :=  mzdyita->sid
      mzdzavhd->cZkrTypFak  :=  mzdyita->czkrtypzav
      mzdzavhd->cZkrTypUhr  :=  mzdyita->czkrtypuhr
      mzdzavhd->cTextFakt   :=  c_srazky->cnazsrazky
      mzdzavhd->nCenZakCel  :=  mzdyita->nmzda
      mzdzavhd->nCENfakCEL  :=  mzdyita->nmzda
      mzdzavhd->nCenZahCel  :=  mzdyita->nmzda
      mzdzavhd->cZkratMeny  :=  mzdyita->cZkratMeny
      mzdzavhd->cZkratMenZ  :=  mzdyita->cZkratMenZ
      mzdzavhd->nKurZahMen  :=  mzdyita->nKurZahMen
      mzdzavhd->nMnozPrep   :=  mzdyita->nMnozPrep
      mzdzavhd->cVarSym     :=  (alias)->cvarsym
      mzdzavhd->nKonstSymb  :=  (alias)->nKonstSymb
      mzdzavhd->cSpecSymb   :=  (alias)->cSpecSymb
      mzdzavhd->nCisFirmy   :=  (alias)->ncisosoby
      mzdzavhd->nCisOsoby   :=  (alias)->ncisosoby
      mzdzavhd->cNazev      :=  osoby->cJmenoRozl
      mzdzavhd->cNazev2     :=  osoby->cOsoba
      mzdzavhd->cUlice      :=  osoby->cUlice
      mzdzavhd->cSidlo      :=  osoby->cSidlo
      mzdzavhd->cPsc        :=  osoby->cPsc
      mzdzavhd->cZkratStat  :=  osoby->cZkratStat
      mzdzavhd->cUcet       :=  (alias)->cUcet
      mzdzavhd->dVystFAKDo  :=  Date()
      mzdzavhd->dVystFak    :=  Date()
      mzdzavhd->dSplatFak   :=  Date()   // pozor musí se upravit podle zpùsobu srážení


* cUcet_Uct
* cBank_Uct
* nFinTyp

//

*      mzdzavhd->nIco
*      mzdzavhd->cDic
* nhasItems
* cObdobiDan
* dDatTisk
* nKlicDPH
* nOsvOdDan
* nPROCdan_1
* nZaklDan_1
* nSazDan_1
* nZAKLdaz_1
* nSAZdaz_1
* nPROCdan_2
* nZaklDan_2
* nSazDan_2
* nZAKLdaz_2
* nSAZdaz_2
* nSUMAdan
* nZustPoZao
* nKodZaokr
* nKodZaokrD
* nKurZahMeD
* nMnozPreD
* nPriUhrCel
* dDatPriUhr
* nUhrCelFak
* nUhrCelFaZ
* nKurzROZDf
* dPosUhrFak
* nPARzalFAK
* nPARzahFAK
* dPARzalFAK
* cVnBan_Uct
* nCisDobFak
* dPosLikFak
* cPrizLikv
* nLikCelFak
* nCisUzv
* dDatUzv
* cDENIK_puc
* cUCET_pucR
* cUCET_pucS
* cUCET_daz
* cCisObj
* cJmenoPrev
* dDatPrevz
* dDatVratil
* cZkrProdej
* lDovoz
* nCelZakl_1
* nCelClo_1
* nCelSPD_1
* nCELDAL_1
* nCelZakl_2
* nCelClo_2
* CelSPD_2
* nCELDAL_2
* nNULLdph
* cINT_ozn
* mPopisFAK
* lNo_InDPH
* cIsZAL_FAK
* nKLikvid
* nZLikvid

    endif

    mzdyita->( dbSkip())
  enddo


*  ctmpDav   := ::cdirW +'tmpDav2'
*  indexKey  := 'cNazPol1+cNazPol2'
*  filtr1    := "nRok = %% .and. nObdobi <= %%  .and. val(cnazPol2) < 800 .and. cnazPol5 <> '        '"
*  condition := format( filtr1, { nrok, nobdobi })

** - 2
*  hIndex    := m_dav->( Ads_CreateTmpIndex( ::cdirW +'m_davw2' , ;
*                                                     'tmpDav2' , ;
*                                                     indexKey  , ;
*                                                     condition   ) )


*  m_dav ->( dbTotal(  ctmpDav,  ;
*                      { || cNazPol1 +cNazPol2 }, ;
*                      {  'nHodDoklad', 'nMnPDoklad', 'nHrubaMzd' },,,,,,.f.))


  mzdyita->( dbGoTop())

  filtrs  := Format("culoha = '%%'", {'M'})
  trvzavhd->( ads_setaof(filtrs), dbGoTop())

  do while  .not. trvzavhd->( Eof())

    firmy->( dbSeek( trvzavhd->ncisfirmy,,'FIRMY1'))
    do case
    case trvzavhd->cZpusSraz = "CTVRT3"  // CTVRTL
      if mes = 3 .or. mes = 6 .or. mes = 9 .or. mes = 12
        DetailOdv()
      endif
    otherwise
      DetailOdv()
    endcase
    trvzavhd->( dbSkip())
  enddo

return nil


static function DetailOdv()
*  LOCAL  aRadek  := { '', 0, '', '', 0, '', '', '', '', 0}
*  LOCAL  nUHRADA := 0, nUHRAZENO := 0
*  LOCAL  nX, cX, xX, xKEY, nNahrady
*  LOCAL  cTAGsco, nRECsco, cSCOPE

  local  aSocOrg    := {}
  local  nuhrada    := 0
  local  nnahrady   := 0
  local  nsumpocpol := 0
  local  nx         := 0
  local  cdirW    := drgINI:dir_USERfitm +userWorkDir() +'\'

  aSocOrg := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr'))


//        LOCAL  anOdvSocZam := faOdvSocZA()

/*
  IF TrvalZav ->lCastUhrad
    cTAGsco := PrikUhIt ->( OrdSetFOCUS())
    nRECsco := PrikUhIt ->( Recno())
    cSCOPE  := PrikUhIt ->( Sx_SetScope())
    xKEY    := StrZero( ACT_OBDyn(), 4) + StrZero( ACT_OBDon(), 2)            ;
                +Cs_Upper( TrvalZav ->cZkrTypZav)

    PrikUhIt ->( Set_sSCOPE( 7, xKEY))
     DO WHILE !PrikUhIt ->( Eof())
       nUHRAZENO += PrikUhIt ->nPriUhrCel
       PrikUhIt ->( dbSkip())
     ENDDO
     IF !IsNIL( cSCOPE)
       PrikUhIt ->( Set_sSCOPE( cTAGsco, cSCOPE))
     ELSE
       PrikUhIt ->( Clr_SCOPE())
     ENDIF
    PrikUhIt ->( OrdSetFOCUS( cTAGsco))
    PrikUhIt ->( dbGoTo( nRECsco))
  ENDIF
*/


  do case
  case AllTrim(trvzavhd ->cTypPohybu) == "GENODVSOC"   // Generovaný závazek - soc.pojištìní
*    MzPod_Ob ->( OrdSetFOCUS( 1))
    nNahrady := 0
    nUHRADA  := 0
 *   aSocOrg  := faOdvSocOR()
    mzdyhda->( OrdSetFocus( 'MZDYHD07'))
    mzdyhda->( dbTotal( cdirW+'\'+'mzdyhdw', ;
                       { || nrokobd }, ;
                       { 'nZaklSocPo','nZakSocStO', 'nOdvoSocPZ', 'nNahradyPN','nNemocCelk', 'nSlevSocPO' } ))

    drgDBMS:open('MZDYHDw',.T.,.T.,drgINI:dir_USERfitm)


    nx                  := Val(aSocOrg[2])
    mzdyhdw->nOdvSocStO := Round( ( mzdyhdw->nZakSocStO *( nX/100)) +0.49, 0)

    nx :=  0
    aEval( aSocOrg, {|X|  nx += Val(X) })

    mzdyhdw->nOdvoSocPO := Round( ( (mzdyhdw->nZaklSocPo -mzdyhdw->nZakSocStO) *( nX/100)) +0.49, 0)
    mzdyhdw->nOdvoSocPC := mzdyhdw->nOdvoSocPO +mzdyhdw->nOdvoSocPZ + mzdyhdw->nOdvSocStO
    mzdyhdw->nProcNemoc := (mzdyhdw->nDnyNemoKD /mzdyhdw->nFondKDDn) *100

    if nx = 26
      mzdyhdw->nNahr1_2PN := Round( ( mzdyhdw->nNahradyPN * 0.5) +0.49, 0)
    else
      mzdyhdw->nNahr1_2PN := 0
    endif

    if mzdyhdw->nNahradyPN <> 0
      if Val(aSocOrg[1]) = 3.3
        nNahrady := Mh_RoundNumb( mzdyhdw->nNahradyPN / 2, 32)
      endif
    endif
    nUHRADA :=  mzdyhdw->nOdvoSocPC -mzdyhdw->nNemocCelk -mzdyhdw->nSlevSocPO -nNahrady

***
  case AllTrim(trvzavhd ->cTypPohybu) = "GENODVZAPO"  // Generovaný závazek - zákonné pojištìní
    ** mzdyhd - omezit na ctvrleti

    do while .not. mzdyhd->( eof())
      nUHRADA := nUHRADA +mzdyhd->nZaklSocPo
      mzdyhd->( dbskip())
    enddo
    nUHRADA  := nUHRADA * SysConfig( "Mzdy:nZakPojZam")

***
  otherwise                                            // GENSRAZKA Generovaný závazek - srážka
    ** mìsíèní údaje musí generovat hned mzdZavhd
    ** omezit na ctyppohZav

    mzdyita->( dbGoTop())
    do while .not. mzdyita->( Eof())
      if mzdyita ->trvzavhd = trvzavhd->sID
        do case
        case mzdyita ->cZkrTypZav = "CesSp"
          nSumPocPol++
        endcase
        nUHRADA := nUHRADA+ mzdyita->nmzda
      endif
      mzdyita ->( dbSkip())
    enddo
  endcase


** zápis do trvZavhd
  if !Empty( trvzavhd->cUcet) .and. nUHRADA > 0

    Mh_CopyFld('trvzavhd','mzdzavhd',.t.,.t.)

    mzdzavhd->nCenZakCel  :=  nuhrada
    mzdzavhd->nCENfakCEL  :=  nuhrada
    mzdzavhd->nCenZahCel  :=  nuhrada

    if Empty(trvzavhd->cvarsym)
      do case
      case trvzavhd->ncisfirmy <> 0 .and. trvzavhd ->cZkrTypZav = "PoPen"
        mzdzavhd->cVarSym := firmy->cidkodupoj
      endcase
    else
      mzdzavhd->cVarSym   := trvzavhd->cvarsym
    endif

    do case
    case TrvalZav ->cZkrTypZav = "CesSp" .and. nSumPocPol > 0 .and. nuhrada > 0
      if SysConfig( "Mzdy:nPoplCS_NF") > 0
        Mh_CopyFld('trvzavhd','mzdzavhd',.t.,.t.)

        nuhrada               := nSumPocPol * SysConfig( "Mzdy:nPoplCS_NF")
        mzdzavhd->nCenZakCel  :=  nuhrada
        mzdzavhd->nCENfakCEL  :=  nuhrada
        mzdzavhd->nCenZahCel  :=  nuhrada

*        aRadek[3]  := cX
*        mzdzavhd->cTextFakt   :=  := "Odvod za " +StrZero( nSumPocPol, 4) +" pol.pro ¬S-NF"
*        aRadek[8]  := IF( Empty( TrvalZav ->cBank_UCT), cUCETban, TrvalZav ->cBank_UCT)

      endif
    endcase

/*
      mzdzavhd->( dbAppend())

      mzdzavhd->culoha      :=  'M'
      mzdzavhd->cdenik      :=  'MC'
      mzdzavhd->ctask       :=  'MZD'
      mzdzavhd->ctypdoklad  :=  'MZD_ZAVGEN'
      mzdzavhd->ctyppohybu  :=  'GENODVOD'
      mzdzavhd->nrok        :=  rok
      mzdzavhd->nobdobi     :=  mesic
      mzdzavhd->cobdobi     :=  mzdyita->cobdobi
      mzdzavhd->dPorizFak   :=  Date()
      mzdzavhd->nDoklad     :=  mzdyita->sid
      mzdzavhd->nCisFak     :=  mzdyita->sid
      mzdzavhd->cZkrTypFak  :=  trvzavhd->cZkrTypFak
      mzdzavhd->cZkrTypUhr  :=  trvzavhd->czkrtypuhr
      mzdzavhd->cTextFakt   :=  trvzavhd->cnazevzav
      mzdzavhd->nCenZakCel  :=  nuhrada
      mzdzavhd->nCENfakCEL  :=  nuhrada
      mzdzavhd->nCenZahCel  :=  nuhrada
      mzdzavhd->cZkratMeny  :=  trvalzav->cZkratMeny
      mzdzavhd->cZkratMenZ  :=  trvalzav->cZkratMenZ
      mzdzavhd->nKurZahMen  :=  trvalzav->nKurZahMen
      mzdzavhd->nMnozPrep   :=  trvalzav->nMnozPrep

      mzdzavhd->cUcet       :=  trvalzav->cUcet
      mzdzavhd->nKonstSymb  :=  trvalzav->nKonstSymb
      mzdzavhd->cSpecSymb   :=  trvalzav->cSpecSymb
      mzdzavhd->nCisFirmy   :=  trvalzav->nCisFirmy
      mzdzavhd->cNazev      :=  firmy->cNazev
      mzdzavhd->cNazev2     :=  firmy->cNazev2
      mzdzavhd->cUlice      :=  firmy->cUlice
      mzdzavhd->cSidlo      :=  firmy->cSidlo
      mzdzavhd->cPsc        :=  firmy->cPsc
      mzdzavhd->cZkratStat  :=  firmy->cZkratStat
      mzdzavhd->dVystFAKDo  :=  Date()
      mzdzavhd->dVystFak    :=  Date()
      mzdzavhd->dSplatFak   :=  Date()   // pozor musí se upravit podle zpùsobu srážení
*/


  endif

//        Mzdy ->( dbEval( {|| nUHRADA =+ Mzdy ->nMZDA }                                     ;
//                          ,Mzdy ->cZkrTypZav == TrvalZav ->cZkrTypZav))

/*
  IF( TrvalZav ->lCastUhrad, nUHRADA := nUHRADA - nUHRAZENO, NIL)

  IF !Empty( TrvalZav ->cUcet) .AND. nUHRADA > 0
    aRadek[1] := TrvalZav ->cUcet
    aRadek[2] := nUHRADA

    IF !Empty( TrvalZav ->cVarSym)
      xX        := Eval( COMPILE( TrvalZav ->cVarSym))
      cX        := IF( IsNum( xX), AllTrim( Str( xX)), xX)
      aRadek[3] := cX
    ENDIF
//   aRadek[4] :=
    aRadek[5]  := TrvalZav ->nKonstSymb
    aRadek[6]  := TrvalZav ->cSpecSymb
    aRadek[7]  := TrvalZav ->cNazevZAV
    aRadek[8]  := IF( Empty( TrvalZav ->cBank_UCT), cUCETban, TrvalZav ->cBank_UCT)
    aRadek[9]  := TrvalZav ->cZkrTypZAV
    aRadek[10] := TrvalZav ->nCisFirmy

    AAdd( aPrikUh, aRadek)

    DO CASE
    CASE TrvalZav ->cZkrTypZav == "CesSp" .AND. nSumPocPol > 0 .AND. nUHRADA > 0
      IF SysConfig( "Mzdy:nPoplCS_NF") > 0
              aRadek    := { '', 0, '', '', 0, '', '', '', '', 0}

        aRadek[1]  := TrvalZav ->cUcet
        aRadek[2]  := nSumPocPol * SysConfig( "Mzdy:nPoplCS_NF")
        aRadek[3]  := cX
        aRadek[5]  := TrvalZav ->nKonstSymb
        aRadek[6]  := TrvalZav ->cSpecSymb
        aRadek[7]  := "Odvod za " +StrZero( nSumPocPol, 4) +" pol.pro ¬S-NF"
        aRadek[8]  := IF( Empty( TrvalZav ->cBank_UCT), cUCETban, TrvalZav ->cBank_UCT)
        aRadek[9]  := TrvalZav ->cZkrTypZAV
        aRadek[10] := TrvalZav ->nCisFirmy

        AAdd( aPrikUh, aRadek)
      ENDIF
    ENDCASE
  ENDIF
*/

RETURN( NIL)    // Eop DetailMl