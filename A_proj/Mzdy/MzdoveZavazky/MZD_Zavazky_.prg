#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dmlb.ch"

/*
trvZavhd - nastaveno

ctypDoklad        ctypPohybu czpusSraz         cperioda
-----------------------------------------------------------------------
MZD_ZAVGEN        GENODVDANS PERIOD            MESIC_PD
MZD_ZAVGEN        GENODVDANZ PERIOD            MESIC
MZD_ZAVGEN        GENODVZDR  PERIOD            MESIC_PD
MZD_ZAVGEN        GENODVSOC  PERIOD            MESIC_PD
MZD_ZAVGEN        GENODVZAPO CTVRTL            DEN
MZD_ZAVGEN        GENSRAZKA  PERIOD            MESIC_PD
MZD_ZAVGEN        GENODVZDR  PERIOD            MESIC
*/


static  nrok_Smz, nobdobi_Smz, cobdobi_Smz, rokobd, aSocOrg, firstDay


function MZD_zavazky_gen(oDialog)
  local  file_name, ky
  local  cky := strZero( mzdzavhd->nrok, 4)       +strZero( mzdzavhd->nOBDOBI,2)     + ;
                strZero( mzdzavhd->noscisPrac, 5) +strZero( mzdzavhd->nporPraVzt ,3) + ;
                strZero( mzdzavhd->nDoklad ,10)
  *
  local  lnewRec := if( isnull(oDialog), .f., oDialog:lnewRec )
  local  alias
  *
  local  filtrs

  * static
  nrok_Smz    := uctOBDOBI:MZD:NROK
  nobdobi_Smz := uctOBDOBI:MZD:NOBDOBI
  cobdobi_Smz := uctOBDOBI:MZD:COBDOBI

  rokobd  := (nrok_Smz*100) + nobdobi_Smz

  firstDay  := mh_FirstODate( nrok_Smz, nobdobi_Smz)
  aSocOrg := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr', firstDay))

  drgDBMS:open('C_SRAZKY')
  drgDBMS:open('C_TYPUHR',,,,,'c_typuhra')
  drgDBMS:open('MZDYHD',,,,,'mzdyhda')
  drgDBMS:open('MZDYIT',,,,,'mzdyita')

  drgDBMS:open('MSSRZ_MO',,,,,'mssrz_moa')
  drgDBMS:open('MZDDAVIT',,,,,'mzddavita')
  drgDBMS:open('TRVZAVHD')
  drgDBMS:open('FIRMY')
  drgDBMS:open('UCETPRIT')
  drgDBMS:open('PRIKUHIT',,,,,'prikuhita')

*  drgDBMS:open('MZDZAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
*  drgDBMS:open('MZDZAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  filtrs := Format("nROKOBD = %%", {rokObd})

  mzdyhda ->( ads_setaof(filtrs), dbGoTop())
  mzdyita ->( ads_setaof(filtrs), dbGoTop())
  mzdZavhd->( ads_setaof(filtrs), dbGoTop())
  mzdZavit->( ads_setaof(filtrs), dbGoTop())

  do while .not. mzdzavhd->( Eof())
    if mzdzavhd->( dbRlock())
      mzdzavhd->( dbDelete())
    else
      return nil
    endif
    mzdzavhd->( dbSkip())
  enddo

  do while .not. mzdzavit->( Eof())
    if mzdzavit->( dbRlock())
      mzdzavit->( dbDelete())
    else
      return nil
    endif
    mzdzavit->( dbSkip())
  enddo

  mzdyita->( dbGoTop())

  filtrs  := Format("culoha = '%%'", {'M'})
  trvzavhd->( ads_setaof(filtrs), dbGoTop())

  do while  .not. trvzavhd->( Eof())

    firmy->( dbSeek( trvzavhd->ncisfirmy,,'FIRMY1'))
    do case
    case trvzavhd->cZpusSraz = "CTVRT3"  // CTVRTL
      if nobdobi_Smz = 3 .or. nobdobi_Smz = 6 .or. nobdobi_Smz = 9 .or. nobdobi_Smz = 12
        DetailOdv( nrok_Smz, nobdobi_Smz )
      endif
    otherwise
      DetailOdv( nrok_Smz, nobdobi_Smz )
    endcase
    trvzavhd->( dbSkip())
  enddo

  trvzavhd->( dbGoTop())
  mzdzavhd->( dbunlock(), dbcommit())
  mzdzavit->( dbunlock(), dbcommit())
return nil


static function DetailOdv()
  local  aRet       := {}
  local  nuhrada    := 0
  local  nit        := 0
  local  nnahrady   := 0
  local  nsumpocpol := 0
  local  nx         := 0
  local  cdirW    := drgINI:dir_USERfitm +userWorkDir() +'\'
  *
  local  cfiltr
  local  tm

//  firstDay  := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
//  aSocOrg := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr', firstDay))

  do case
  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVDANS'  // Generovaný závazek - daò srážková
    * suma pøes mzdyit
    *
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. ctyppohZav = '%%'", { nrok_Smz, nobdobi_Smz,'GENODVDANS' } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               dbeval( { || nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())

    add_to_mzdZavhd( nuhrada )
    nuhrada := 0

  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVDANZ'  // Generovaný závazek - daò zálohová
    * suma pøes mzdyit
    *
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. ctyppohZav = '%%'", { nrok_Smz, nobdobi_Smz,'GENODVDANZ' } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               dbeval( { || nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())

    add_to_mzdZavhd( nuhrada )
    nuhrada := 0


  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVZDR'   // Generovaný závazek - zdr.pojištìní
    * suma pøes mzdyit
    * za klíè   trvaZavhd -> firmy ->     nZdrPojis
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. ctyppohZav = '%%' .and. nzdrPojis = %%", ;
                     { nrok_Smz, nobdobi_Smz,'GENODVZDR', firmy->nzdrPojis } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               dbeval( { || nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())

    add_to_mzdZavhd( nuhrada )
    nuhrada := 0

  case AllTrim(trvzavhd ->cTypPohybu) == "GENODVSOC"   // Generovaný závazek - soc.pojištìní
*    MzPod_Ob ->( OrdSetFOCUS( 1))
    nNahrady := 0
    nUHRADA  := 0

    nUHRADA := retvalSoc()[9]

    add_to_mzdZavhd( nuhrada )
    nuhrada := 0

***
  case AllTrim(trvzavhd ->cTypPohybu) = "GENODVZAPO"  // Generovaný závazek - zákonné pojištìní
    ** mzdyhd - omezit na ctvrleti
    n_ctvrtleti :=  mh_CTVRTzOBDn( nobdobi_Smz )
    cfiltr      := format( "nrok = %% .and. nctvrtleti = %%", { nrok_Smz, n_ctvrtleti } )
    mzdyhda->( ads_setAof( cfiltr), dbgoTop() )

    do while .not. mzdyhda->( eof())
      nUHRADA := nUHRADA +mzdyhda->nZaklSocPo
      mzdyhda->( dbskip())
    enddo
    nUHRADA  := nUHRADA * SysConfig( "Mzdy:nZakPojZam")
    add_to_mzdZavhd( nuhrada )
    nuhrada := 0

  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODCSNFO'  // Generovaný závazek - hromadný odvod plateb do ÈS
    * suma pøes mzdyit
    *
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. cpohzavfir = '%%'", { nrok_Smz, nobdobi_Smz,'GENODCSNFO' } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               add_to_mzdZavhd( nuhrada, .t. ) ,;
               dbeval( { || nit++, add_to_mzdZavit( nuhrada, nit ), nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())
    uhr_to_mzdZavhd( nuhrada )

    nuhrada := 0
    nit     := 0

  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVPPHO'  // Generovaný závazek - hromadný penzijní pojištìní
    * suma pøes mzdyit
    *
    tm      := AllTrim(trvzavhd ->cTypPohybu) + StrZero( trvzavhd ->ncisfirmy,5)
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. cpohzavfir = '%%'", { nrok_Smz, nobdobi_Smz, tm } )

    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               add_to_mzdZavhd( nuhrada, .t. ) ,;
               dbeval( { || nit++, add_to_mzdZavit( nuhrada, nit ), nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())
    uhr_to_mzdZavhd( nuhrada )

    nuhrada := 0
    nit     := 0

  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVPKHO'  // Generovaný závazek - hromadný kapitálové pojištìní
    * suma pøes mzdyit
    *
    tm      := AllTrim(trvzavhd ->cTypPohybu) + StrZero( trvzavhd ->ncisfirmy,5)
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. cpohzavfir = '%%'", { nrok_Smz, nobdobi_Smz, tm } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               add_to_mzdZavhd( nuhrada, .t. ) ,;
               dbeval( { || nit++, add_to_mzdZavit( nuhrada, nit ), nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())
    uhr_to_mzdZavhd( nuhrada )

    nuhrada := 0
    nit     := 0

  case AllTrim(trvzavhd ->cTypPohybu) == 'GENODVODBO'  // Generovaný závazek - hromadný odvod odbory
    * suma pøes mzdyit
    *
    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. cpohzavfir = '%%'", { nrok_Smz, nobdobi_Smz,'GENODVODBO' } )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               add_to_mzdZavhd( nuhrada, .t. ) ,;
               dbeval( { || nit++, add_to_mzdZavit( nuhrada, nit ), nuhrada += mzdyita->nmzda } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())
    uhr_to_mzdZavhd( nuhrada )

    nuhrada := 0
    nit     := 0

***
  otherwise                                            // GENSRAZKA Generovaný závazek - srážka
    ** mìsíèní údaje musí generovat hned mzdZavhd
    ** omezit na ctyppohZav

    cfiltr  := format( "nrok = %% .and. nobdobi = %% .and. ctyppohZav = '%%'", { nrok_Smz, nobdobi_Smz, trvZavhd ->ctypPohybu} )
    mzdyita->( ads_setAof( cfiltr), ;
               dbgoTop()          , ;
               dbeval( { || add_to_mzdZavhd( mzdyita->nmzda ) } ), ;
               dbgoTop()                                   )

    mzdyita->( ads_clearAof())

/*
    mzdyita->( dbGoTop())

    do while .not. mzdyita->( Eof())
      if trvZavhd ->ctypPohybu = mzdyita ->ctyppohZav

        add_to_mzdZavhd( mzdyita->nmzda, rokObd )
      endif
      mzdyita ->( dbSkip())
    enddo
*/

  endcase


** zápis do trvZavhd
/*
  if !Empty( trvzavhd->cUcet) .and. nUHRADA > 0

    Mh_CopyFld('trvzavhd','mzdzavhd',.t.,.t.)

    mzdZavhd->nobdobi     :=  obdobi
    mzdZavhd->nrok        :=  rok
    mzdZavhd->nrokObd     :=  rokObd

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
*/

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


**  endif
RETURN( NIL)    // Eop DetailMl



static function add_to_mzdZavhd( nuhrada, hroplat )
  local varSym    := trvZavhd->cvarSym
  local typVarSym := upper( allTrim( trvZavhd->ctypVarSym))
  local typFak    := 0
  local atrr      := ''
  *
  local nid, iv_file
  local filtrs

  default hroplat to .f.     // hromadné platby penzijní, cs_nfo, odbory ....

  if .not. empty(typVarSym)
    do case
    case( typVarSym = 'PFV' )  ;  varSym := varSym_PFv()
    case( typVarSym = 'PFP' )  ;  varSym := varSym_PFp()
    case( typVarSym = 'PFC' )  ;  varSym := varSym_PFc()
    endcase
  endif

  do case
  case .not. empty(trvZavhd->cUcet) .and. ( nuhrada > 0 .or. hroplat) .and. trvZavhd->cTypPohybu <> 'GENSRAZKA '

    mh_copyFld( 'trvZavhd', 'mzdZavhd', .t., .t. )

      mzdzavhd->culoha      :=  'M'
      mzdzavhd->cdenik      :=  'MC'
*      mzdzavhd->ctask       :=  'MZD'
      mzdzavhd->ctypdoklad  :=  'MZD_ZAVGEN'
//      mzdzavhd->ctyppohybu  :=  'GENODVOD'
      mzdzavhd->nrok        :=  nrok_Smz
      mzdzavhd->nobdobi     :=  nobdobi_Smz
      mzdzavhd->cobdobi     :=  cobdobi_Smz
      mzdzavhd->dPorizFak   :=  Date()
      mzdzavhd->nDoklad     :=  (8000000000 + Val(Right( Str( rokObd),4))*100000) +isNull( trvZavhd->sid, 0)
      mzdzavhd->nCisFak     :=  mzdzavhd->nDoklad
      mzdZavhd->cvarSym     :=  varSym
      mzdzavhd->cZkrTypFak  :=  trvZavhd->cZkrTypFak
      mzdzavhd->cZkrTypUhr  :=  trvZavhd->czkrtypuhr

*      mzdzavhd->cTextFakt   :=  trvzavhd->cnazevzav
      nUHRADA  := Mh_RoundNumb( nUhrada, mzdzavhd->nkodzaokr)

      mzdzavhd->nCenZakCel  :=  nuhrada
      mzdzavhd->nCENfakCEL  :=  nuhrada
      mzdzavhd->nCenZahCel  :=  nuhrada
      mzdzavhd->cZkratMeny  :=  trvZavhd->cZkratMeny
      mzdzavhd->cZkratMenZ  :=  trvZavhd->cZkratMenZ
      mzdzavhd->nKurZahMen  :=  trvZavhd->nKurZahMen
      mzdzavhd->nMnozPrep   :=  trvZavhd->nMnozPrep

      mzdzavhd->cUcet       :=  trvZavhd->cUcet
      mzdzavhd->nKonstSymb  :=  trvZavhd->nKonstSymb
      mzdzavhd->cSpecSymb   :=  trvZavhd->cSpecSymb
      mzdzavhd->nCisFirmy   :=  trvZavhd->nCisFirmy
      mzdzavhd->cNazev      :=  firmy->cNazev
      mzdzavhd->cNazev2     :=  firmy->cNazev2
      mzdzavhd->cUlice      :=  firmy->cUlice
      mzdzavhd->cSidlo      :=  firmy->cSidlo
      mzdzavhd->cPsc        :=  firmy->cPsc
      mzdzavhd->cZkratStat  :=  firmy->cZkratStat
      mzdZavhd->nzdrPojis   :=  firmy->nzdrPojis
      mzdzavhd->dVystFAKDo  :=  Date()
      mzdzavhd->dVystFak    :=  Date()
      mzdzavhd->dSplatFak   :=  Date()   // pozor musí se upravit podle zpùsobu srážení
      mzdZavhd->nrokObd     :=  rokObd


  case trvZavhd->cTypPohybu = 'GENSRAZKA ' .and. nuhrada <> 0 //.and. .not. empty(mssrz_mo->cUcet)
      if mzdyita->nmssrz_mo <> 0
        nid     := mzdyita->nmssrz_mo
        iv_file := 'mssrz_moa'
        typFak  := 0
      else
        nid     := mzdyita->nmzdDavit
        iv_file := 'mzdDavita'
        typFak  := 7000000000
       endif


      if (iv_file)->( dbSeek( nid,,'ID'))
        mh_copyFld( iv_file, 'mzdZavhd', .t., .t. )

        mzdzavhd->culoha      :=  'M'
        mzdzavhd->cdenik      :=  'MC'
  *      mzdzavhd->ctask       :=  'MZD'
        mzdzavhd->ctypdoklad  :=  'MZD_ZAVGEN'
        mzdzavhd->ctyppohybu  :=  (iv_file)->cpohzavfir
        mzdzavhd->nrok        :=  nrok_Smz
        mzdzavhd->nobdobi     :=  nobdobi_Smz
        mzdzavhd->cobdobi     :=  cobdobi_Smz
        mzdzavhd->dPorizFak   :=  Date()
        mzdzavhd->nDoklad     :=  isNull( (iv_file)->sid, 0)
        mzdzavhd->nCisFak     :=  typFak + isNull( (iv_file)->sid, 0)

        if mssrz_moa->ctypsrz <> 'SR00'
          if Len( AllTrim( (iv_file)->cvarSym)) = 1 .and.                 ;
             ( AllTrim( (iv_file)->cvarSym) = '0' .or. AllTrim( (iv_file)->cvarSym) = '9')
            mzdZavhd->cvarSym   := SubStr( (iv_file)->croobcpppv,5,7) +     ;
                                    Right( (iv_file)->croobcpppv,1)+        ;
                                     StrZero( (iv_file)->nporadi,2)

          else
            mzdZavhd->cvarSym   := (iv_file)->cvarSym
          endi
        else
          mzdZavhd->cvarSym   := SubStr( (iv_file)->croobcpppv,5,7) +     ;
                                  Right( (iv_file)->croobcpppv,1)+        ;
                                   StrZero( (iv_file)->nporadi,2)
        endif

        mzdzavhd->cZkrTypFak  :=  trvZavhd->cZkrTypFak
        mzdzavhd->cZkrTypUhr  :=  (iv_file)->czkrtypuhr
        if c_srazky->( dbSeek( Upper( (iv_file)->czkrsrazky),,'C_SRAZKY01'))
          mzdzavhd->cTextFakt   := c_srazky->cnazsrazky
        endif
        mzdzavhd->nCenZakCel  :=  nuhrada
        mzdzavhd->nCENfakCEL  :=  nuhrada
        mzdzavhd->nCenZahCel  :=  nuhrada

        mzdzavhd->cZkratMeny  :=  (iv_file)->cZkratMeny
        mzdzavhd->cZkratMenZ  :=  (iv_file)->cZkratMenZ
        mzdzavhd->nKurZahMen  :=  (iv_file)->nKurZahMen
        mzdzavhd->nMnozPrep   :=  (iv_file)->nMnozPrep

        mzdzavhd->cUcet       :=  (iv_file)->cUcet
        mzdzavhd->nKonstSymb  :=  (iv_file)->nKonstSymb
        mzdzavhd->cSpecSymb   :=  (iv_file)->cSpecSymb

//        mzdzavhd->nCisFirmy   :=  trvZavhd->nCisFirmy
        mzdzavhd->cNazev      :=  (iv_file)->cJmenoRozl
        mzdZavHD->nosCisPrac  :=  (iv_file)->nosCisPrac
        mzdZavHD->nporPraVzt  :=  (iv_file)->nporPraVzt

//        mzdzavhd->cNazev2     :=  firmy->cNazev2
//        mzdzavhd->cUlice      :=  firmy->cUlice
//        mzdzavhd->cSidlo      :=  firmy->cSidlo
//        mzdzavhd->cPsc        :=  firmy->cPsc
//        mzdzavhd->cZkratStat  :=  firmy->cZkratStat
//        mzdZavhd->nzdrPojis   :=  firmy->nzdrPojis

        if Empty( mzdZavhd->cUcet_UCT)
          atrr  := AllTrim(Str(mzdZavhd->ndruhmzdy)) + "*"
          ucetprit->( ads_setAof( "cTASK = 'MZD' .and. Contains(cucetskup," + "'" +atrr + "'" + ")"), dbgoTop())
          mzdZavhd->cUcet_UCT := ucetprit->cucetdal
          ucetprit->( ads_clearAof())
        endif

        mzdzavhd->dVystFAKDo  :=  Date()
        mzdzavhd->dVystFak    :=  Date()
        mzdzavhd->dSplatFak   :=  Date()   // pozor musí se upravit podle zpùsobu srážení
        mzdZavhd->nrokObd     :=  rokObd
        mzdZavhd->nmzdyit     :=  isNull( mzdyita->sid, 0)
      endif
  endcase

/*    tady je chyba viz MOPAS
  filtrs := Format("cTypDoklad = 'MZD_PRUHTU' and nCisFak = %%", { mzdzavhd->ncisfak})
  prikuhita ->( ads_setaof(filtrs), dbGoTop())
   do while .not. prikuhita->( Eof())
     mzdzavhd->nexipriuhr := 1
     mzdzavhd->npriuhrcel += prikuhita->npriuhrcel
     mzdzavhd->ddatpriuhr := prikuhita->dporizpri
     prikuhita->( dbSkip())
   enddo
  prikuhita ->( ads_clearAof())
*/

return .t.


static function uhr_to_mzdZavhd( nuhrada )

  mzdzavhd->nCenZakCel  :=  nuhrada
  mzdzavhd->nCENfakCEL  :=  nuhrada
  mzdzavhd->nCenZahCel  :=  nuhrada

return .t.

static function add_to_mzdZavit( nuhrada, item )
  local varSym    := trvZavhd->cvarSym
  local typVarSym := upper( allTrim( trvZavhd->ctypVarSym))
  local cdat, tmUcet

  if .not. empty(typVarSym)
    do case
    case( typVarSym = 'PFV' )  ;  varSym := varSym_PFv()
    case( typVarSym = 'PFC' )  ;  varSym := varSym_PFc()
    case( typVarSym = 'PFP' )  ;  varSym := varSym_PFp()
    endcase
  endif


  if mzdyita->nmzda <> 0 .and. mssrz_moa->( dbSeek( mzdyita->nmssrz_mo,,'ID'))
    mh_copyFld( 'trvZavhd', 'mzdzavit', .t., .t. )

    mzdzavit->culoha      :=  'M'
    mzdzavit->cdenik      :=  'MC'
//      mzdzavit->ctask       :=  'MZD'
//      mzdzavit->ctypdoklad  :=  'MZD_ZAVGEN'
//      mzdzavit->ctyppohybu  :=  trvZavhd->cTypPohybu
    mzdzavit->nrok        :=  mzdyita->nrok
    mzdzavit->nobdobi     :=  mzdyita->nobdobi
    mzdzavit->cobdobi     :=  mzdyita->cobdobi
    mzdzavit->nRokObd     :=  mzdyita->nRokObd
    mzdzavit->nDoklad     :=  mzdzavhd->nDoklad
    mzdzavit->nCisFak     :=  mzdzavhd->nDoklad
    mzdzavit->nintcount   :=  item

    mzdzavit->cvarSym     :=  mssrz_moa->cvarSym
    mzdzavit->cZkrTypFak  :=  trvZavhd->cZkrTypFak
//    mzdzavit->cZkrTypUhr  :=  mssrz_moa->czkrtypuhr

//    if c_srazky->( dbSeek( Upper(mssrz_moa->czkrsrazky),,'C_SRAZKY01'))
//      mzdzavit->cNazZbo   := c_srazky->cnazsrazky   // cpopsrazky
//    endif
    mzdzavit->nCenZakCel  :=  mzdyita->nmzda
//    mzdzavit->nCENfakCEL  :=  mzdyita->nmzda
    mzdzavit->nCenZahCel  :=  mzdyita->nmzda

//    mzdzavit->cZkratMeny  :=  mssrz_moa->cZkratMeny
//    mzdzavit->cZkratMenZ  :=  mssrz_moa->cZkratMenZ
//    mzdzavit->nKurZahMen  :=  mssrz_moa->nKurZahMen
//    mzdzavit->nMnozPrep   :=  mssrz_moa->nMnozPrep

    mzdzavit->cUcetSrz    :=  mssrz_moa->cUcet
    mzdzavit->nKonstSymb  :=  mssrz_moa->nKonstSymb
    mzdzavit->cSpecSymb   :=  mssrz_moa->cSpecSymb

    mzdzavit->nCisFirmy   :=  trvZavhd->nCisFirmy
    mzdzavit->cNazZbo     :=  mssrz_moa->cJmenoRozl
//        mzdzavit->cNazev2     :=  firmy->cNazev2
//        mzdzavit->cUlice      :=  firmy->cUlice
//        mzdzavit->cSidlo      :=  firmy->cSidlo
//        mzdzavit->cPsc        :=  firmy->cPsc
//        mzdzavit->cZkratStat  :=  firmy->cZkratStat
//        mzdzavit->nzdrPojis   :=  firmy->nzdrPojis

//        mzdzavit->dVystFAKDo  := Date()
    mzdzavit->dVystFak    := Date()
    mzdzavit->dSplatFak   := Date()   // pozor musí se upravit podle zpùsobu srážení
    mzdzavit->nOsCisPrac  := mzdyita->nOsCisPrac
    mzdzavit->nPorPraVzt  := mzdyita->nPorPraVzt
    mzdzavit->nCisOsoby   := mssrz_moa->nCisOsoby
    mzdZavit->nmzdyit     := isNull( mzdyita->sid, 0)

    do case
    case trvZavhd->cTypPohybu = 'GENODCSNFO'
      cdat := Right( Str( if( mzdyita->nobdobi=12,mzdyita->nrok+1,mzdyita->nrok),4),2) +  ;
               StrZero(  Month(mzdzavit->dVystFak), 2) +                              ;
                Padl( Alltrim ( Str( SysConfig( "Mzdy:nDatumCS"))), 2, '0')
      tmUcet := ucetCsNFO( mssrz_moa->cUcetI)

      mzdzavit->cDoplnTxt := 'BZ:11'                                                     ;
                               +Padl(Alltrim(Str(mzdyita->nMzda*100, 7)),15,'0')    ;
                                +cdat +Padl( Alltrim( mssrz_moa->cKodBanky), 7, '0' )    ;
                                 +'000000'                                               ;
                                  +Padl(Alltrim(tmUcet),10,'0')   ;
                                   +Padl(Alltrim(mssrz_moa->cSpecSymb),10,'0')           ;
                                    +Padl(Alltrim(Str(mssrz_moa->nKonstSymb)),4,'0')
      mzdzavit->ctmSort   := sortKeyCsNFO( tmUcet)

    case trvZavhd->cTypPohybu = 'GENODVPPHO'
      mzdzavit->cDoplnTxt := if( mssrz_moa->nDruhMzdy == 577, "U", "Z") +";"        ;
                               +AllTrim( mssrz_moa->cSpecSymb) +";"                 ;
                                +AllTrim( fFORMnRC( mssrz_moa->cRodCisPra)) +";"    ;
                                +AllTrim( mssrz_moa->cPracovnik) +";" +";"          ;
                                 +AllTrim( Str( mzdyita->nmzda, 10, 2)) + ";" +";"

    case trvZavhd->cTypPohybu = 'GENODVPKHO'
      mzdzavit->cDoplnTxt := if( mssrz_moa->nDruhMzdy == 579, "2", "2") +";"        ;
                               +AllTrim( fFORMnRC( mssrz_moa->cRodCisPra)) +";"     ;
                                +AllTrim( mssrz_moa->cSpecSymb) +";"                ;
                                 +AllTrim( Str( mzdyita->nmzda, 10, 2)) + ";"       ;    ;
                                  +AllTrim( mssrz_moa->cPracovnik)

    endcase

  endif


return .t.


*
** specifické variabilní symboly
** Vojenský otevøený penzijní fond
static function varSym_PFv()
  local cret := ''

  cret := subStr( strZero( Year( Date()), 4), 3, 4) + ;
          strZero( Month( Date()) +80, 2)           + ;
          left( firmy->cidKoduPoj,5)                + ;
          '1'
return cret


** Penzijní fond èeské spoøitelny
static function varSym_PFc()
  local cret := ''

  cret := '00'                        + ;
          left( firmy->cidKoduPoj,5)  + ;
          strZero( Month( Date()), 2) + ;
          '0'
return cret


** Penzijní spoleènost èeské pojišovny
static function varSym_PFp()
  local cret := ''

  cret := left( firmy->cidKoduPoj,5)  + ;
          strZero( mzdzavhd->nobdobi, 2) + ;
          '2'
return cret


** Úèet pro CS_NFO
static function ucetCsNFO( ucetI)
  local cX, nX, nY
  local cret := ''

  cX := AllTrim( ucetI)
  nX := At( "-", cX)
  nY := ( Len( cX) + 1) - ( nX)

  do case
  case nX > 0
    if nY = 4
      cPredCiUc := '000000'
      cPomUcet  := Padl( StrTran( cX, '-', '' ), 10, '0')
    else
      cPredCiUc := SubStr( cX, 1, nX - 1)
      cPomUcet  := SubStr( cX, nX + 1)
    endif
  case Len( cX) > 10
    cPredCiUc := Left(  cX, 10 -Len( cX))
    cPomUcet  := Right( cX, 10)
  otherwise
    cPredCiUc := '000000'
    cPomUcet  := cX
  endcase

  cret := cPomUcet

return cret


function retvalSoc()
  local  nkdnemoc   := 0
  local  nkdfond    := 0
  local  nit        := 0
  local  nx         := 0
  local  ny         := 0
  local  cdirW      := drgINI:dir_USERfitm +userWorkDir() +'\'
  *
  local  aSocOrg    := {}
  local  cfiltr
  local  tm
  local  aSocRet
  local  firstDay
  local  rokobd

  firstDay  := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
  aSocOrg := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr', firstDay))
                                           //      1     2            3             4             5        6       7       8        9     10    11         12              13
  aSocRet := {0,0,0,0,0,0,0,0,0,0,0,0,0,0} // zákl.zam, poj.zam, zákl.duch.zam, poj.duch.zam, zákl.org, poj.org, náhr., náhr 1/2, odvod, typ, proc.nem, zakl.duch.sp, odv.duch.sp,

    mzdyhda->( OrdSetFocus( 'MZDYHD07'))
    mzdyhda->( dbTotal( cdirW+'\'+'mzdyhdw'                                                                , ;
                       { || nrokobd  }                                                                      , ;
                       { 'nZaklSocPo','nZakSocStO', 'nOdvoSocPZ', 'nNahradyPN','nNemocCelk', 'nSlevSocPO', 'nZakSocDS2', 'nOdvSoDS2Z', 'nZaklSlePo'}, ;
                       { || .t.   }                                                                     , ;
                                                                                                           , ;
                                                                                                           , ;
                                                                                                           , ;
                                                                                                           , ;
                       .f.                                                                                   ))

*    drgDBMS:open('MZDYHDw',.T.,.T.,drgINI:dir_USERfitm)
    aSocRet[1]  += mzdyhdw->nZaklSocPo
    aSocRet[2]  += mzdyhdw->nOdvoSocPZ

    aSocRet[3]  += mzdyhdw->nZakSocDS2
    aSocRet[4]  += mzdyhdw->nOdvSoDS2Z

    aSocRet[7]  += mzdyhdw->nNahradyPN
    nkdnemoc    += mzdyhdw->nDnyNemoKD
    nkdfond     += mzdyhdw->nFondKDDn

    aSocRet[14] += mzdyhdw->nZaklSlePo

    rokobd      := mzdyhdw->nrokobd

    mzdyhdw->( dbCloseArea())

    aEval( aSocOrg, {|X|  nx += Val(X) })

    aSocRet[5] := aSocRet[1]

    if rokobd >= 202006 .and. rokobd <= 202008
      ny := (aSocRet[1] - aSocRet[14])
      aSocRet[6] := Mh_RoundNumb( ny *( nX/100), 31)
    else
      aSocRet[6] := Mh_RoundNumb( aSocRet[5] *( nX/100), 31)
    endif

 //   aSocRet[6] := Mh_RoundNumb( aSocRet[5] *( nX/100), 31)

    aSocRet[11] := ( nkdnemoc/nkdfond) *100

    if nx = 26
      aSocRet[8]  := Mh_RoundNumb( aSocRet[7] *0.5, 31)
      aSocRet[10] := 2
    else
      aSocRet[7]  := 0
      aSocRet[8]  := 0
      aSocRet[10] := 1
    endif

    aSocRet[9] := ( aSocRet[2] + aSocRet[6]) - aSocRet[8]


return aSocRet


function retvalZdr()
  local  aZdrOrg    := {}
  local  nkdnemoc   := 0
  local  nkdfond    := 0
  local  nit        := 0
  local  nx         := 0
  local  cdirW      := drgINI:dir_USERfitm +userWorkDir() +'\'
  *
  local  cfiltr
  local  tm
  local  aZdrRet

                                       //      1     2            3             4             5        6       7       8        9     10    11
  aZdrRet := {0,0,0,0,0,0,0,0,0,0,0} // zákl.zam, poj.zam, zákl.duch.zam, poj.duch.zam, zákl.org, poj.org, náhr., náhr 1/2, odvod, typ, proc.nem
  aZdrOrg := Mh_Token( SysConfig( 'mzdy:cnOdvSocOr', firstDay))

  mzdyhda->( OrdSetFocus( 'MZDYHD07'))
  mzdyhda->( dbTotal( cdirW+'\'+'mzdyhdw'                                                                 , ;
                      { || nrokobd  }                                                                     , ;
                      { 'nZaklSocPo','nZakSocStO', 'nOdvoSocPZ', 'nNahradyPN','nNemocCelk', 'nSlevSocPO' }, ;
                      { || lDuchSp2Pi = .f.  }                                                            , ;
                                                                                                          , ;
                                                                                                          , ;
                                                                                                          , ;
                                                                                                          , ;
                       .f.                                                                                 ))

*    drgDBMS:open('MZDYHDw',.T.,.T.,drgINI:dir_USERfitm)
    aZdrRet[1] += mzdyhdw->nZaklSocPo
    aZdrRet[2] += mzdyhdw->nOdvoSocPZ
    aZdrRet[7] += mzdyhdw->nNahradyPN
    nkdnemoc   += mzdyhdw->nDnyNemoKD
    nkdfond    += mzdyhdw->nFondKDDn

    mzdyhdw->( dbCloseArea())

    mzdyhda->( dbTotal( cdirW+'\'+'mzdyhdw'                                                                , ;
                       { || nrokobd  }                                                                      , ;
                       { 'nZaklSocPo','nZakSocStO', 'nOdvoSocPZ', 'nNahradyPN','nNemocCelk', 'nSlevSocPO' }, ;
                       { || lDuchSp2Pi = .t.  }                                                                     , ;
                                                                                                           , ;
                                                                                                           , ;
                                                                                                           , ;
                                                                                                           , ;
                       .f.                                                                                   ))

*    drgDBMS:open('MZDYHDw',.T.,.T.,drgINI:dir_USERfitm)
    aZdrRet[3] := mzdyhdw->nZaklSocPo
    aZdrRet[4] := mzdyhdw->nOdvoSocPZ
    aZdrRet[7] += mzdyhdw->nNahradyPN
    nkdnemoc   += mzdyhdw->nDnyNemoKD
    nkdfond    += mzdyhdw->nFondKDDn

    mzdyhdw->( dbCloseArea())

    aEval( aZdrOrg, {|X|  nx += Val(X) })

    aZdrRet[5] := aZdrRet[1] +aZdrRet[3]
    aZdrRet[6] := Mh_RoundNumb( aZdrRet[5] *( nX/100), 31)

    aZdrRet[11] := ( nkdnemoc/nkdfond) *100

    if nx = 26
      aZdrRet[8]  := Mh_RoundNumb( aZdrRet[7] *0.5, 31)
      aZdrRet[10] := 2
    else
      aZdrRet[10] := 1
    endif

    aZdrRet[9] := ( aZdrRet[2] + aZdrRet[4] + aZdrRet[6]) - aZdrRet[8]

return aZdrRet


** Pomocný tøídící klíè pro CSNFO
function sortKeyCsNFO( tmUcet)
  local  cPomUcet, cPredCiUc
  local  nTypUctu, nTypAgendy, nTmpAgenda
  local  cX, nX, nY
  local  cret
  local  nOP_CS, nOU_CS, nPomUcSk, nCisloUcSk

  nTypUctu   := Val( Substr( tmUcet, 10, 1))
  nTmpAgenda := Val( Substr( tmUcet,  8, 1))
  nOP_CS := nOU_CS := nPomUcSk := nCisloUcSk := 0

  do case
  case nTypUctu = 0
    nTypAgendy := 1

  case nTypUctu = 3
    if nTmpAgenda <= 1
      nTypAgendy := 2
    else
      nTypAgendy := 3
    endif

  case nTypUctu = 8
    nOP_CS     := Val( Substr( tmUcet, 8, 3))
    nOU_CS     := Val( Substr( tmUcet, 1, 3))
    nPomUcSk   := Val( Substr( tmUcet, 4, 2))
    nCisloUcSk := nPomUcSk

    do case
    case nPomUcSk = 1 .or. nPomUcSk = 3                               ;
      .or. nPomUcSk = 10 .or. nPomUcSk = 11 .or. nPomUcSk = 12        ;
       .or. nPomUcSk = 13 .or. nPomUcSk = 14 .or. nPomUcSk = 15       ;
        .or. nPomUcSk = 18 .or. nPomUcSk = 71 .or. nPomUcSk = 72      ;
         .or. nPomUcSk = 76 .or. nPomUcSk = 77 .or.                   ;
             ( nPomUcSk >= 79 .AND. nPomUcSk <= 87)
      nTypAgendy := 1

    case nPomUcSk = 16
      nTypAgendy := 2

    case nPomUcSk = 49 .or. nPomUcSk = 50                                ;
      .or. nPomUcSk = 51 .or. nPomUcSk = 52 .or. nPomUcSk = 53       ;
       .or. nPomUcSk = 61 .or. nPomUcSk = 63 .or. nPomUcSk = 68      ;
        .or. nPomUcSk = 73 .or. nPomUcSk = 74 .or. nPomUcSk = 75     ;
         .or. nPomUcSk = 78
      nTypAgendy := 3
    endcase

  case nTypUctu = 9
    if nTmpAgenda = 1
      nTypAgendy := 3
    else
      nTypAgendy := 2
    endif
  endcase

//  cret := StrZero( SysConfig( "Mzdy:nCisPodCS"), 5)     ;
  cret := '61795'                                       ;
           +StrZero( ntypuctu, 2)                       ;
            +StrZero( nOP_CS, 3)                        ;
             +StrZero( nOU_CS, 2)                       ;
              +'11'                                     ;
               +StrZero( ntypagendy, 1)                 ;
                +StrZero( ncisloucsk, 2)                ;
                 +mssrz_moa->cSpecSymb

return cret

