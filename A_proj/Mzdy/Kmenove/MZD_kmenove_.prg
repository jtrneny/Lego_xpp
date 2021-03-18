#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


function MZD_kmenove_cpy(oDialog, in_whoIsIn, can_copyAll)
  local  lnewRec    := oDialog:lnewRec
  local  pa_vazRecs := oDialog:pa_vazRecs
  local  nKy        := if( lnewRec, -1, msPrc_mo->ncisOsoby )
  *
  local  cf := "OSOBY = %%", filtrs

  default in_whoIsIn  to .f. , ;
          can_copyAll to .f.

  if .not. in_whoIsIn
    ** tmp **
    *
    * TAB - 1 - msPrc_moW, mimPrvzW, duchodyW, msOdpPolW
    drgDBMS:open( 'msPrc_moW', .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'mimPrvzW' , .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'duchodyW' , .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'c_odpocW' , .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'msOdpPolW', .T., .T., drgINI:dir_USERfitm); ZAP

    * TAB - 2 - msPrc_moW, msTarindW, msSazZamW
    drgDBMS:open( 'msTarindW', .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'msSazZamW', .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'msVprumW', .T., .T., drgINI:dir_USERfitm); ZAP

    * TAB - 3 - msMzdyhdW, msMzdyitW
    drgDBMS:open( 'msMzdyhdW', .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'msMzdyitW', .T., .T., drgINI:dir_USERfitm); ZAP

    * TAB - 4 - msSrz_moW
    drgDBMS:open( 'msSrz_moW', .T., .T., drgINI:dir_USERfitm); ZAP

    * TAB - 5
    ** SUB TAB - 6 - osobyW
    drgDBMS:open( 'osobyW'   , .T., .T., drgINI:dir_USERfitm); ZAP

    ** SUB TAB - 7 - vazOsobyW, osoby_Rp
    drgDBMS:open( 'vazOsobyW', .T., .T., drgINI:dir_USERfitm); ZAP
    drgDBMS:open( 'osoby_RpW',.T. ,.T. , drgINI:dir_USERfitm); ZAP

    ** SUB TAB - 8 - duchodyW naplnní TAB - 1
    msPrc_moW->(dbappend())
    osobyW   ->(dbappend())

    ** SUB nikdo neví kde
    drgDBMS:open( 'msOsb_moW', .T., .T., drgINI:dir_USERfitm); ZAP
    msOsb_moW->( dbappend())
    * nrok +nobdobi +noscisPrac
  endif

  * vazOsobyX potøebujem pro msOdpPolW a pro rodiné pøíslušníky
  if lnewRec .or. in_whoIsIn
    filtrs := format( cf, { msPrc_moW->nOSOBY } )
    if( in_whoIsIn, nKy := msPrc_moW->ncisOsoby, nil )
  else
    filtrs := format( cf, { msPrc_mo ->nOSOBY } )
  endif
  vazOsobyX->( ads_setAof( filtrs ), dbgoTop() )

  ** SUB TAB - 7 rodinní pøíslušnící - platí jak pro INS i ENTER
  ** pro MZD_msOdpPol_cpy ji radìji udìláme hned
  vazOsobyX  ->( dbEval( { || OSB_copyFldTo_W( 'vazOsobyX', 'vazOsobyW', .t., 'osoby_Rp' , pa_vazRecs[1]) } ))


  if .not. lnewRec

    * TAB 1 a SUB TAB 8 - dùchody
    mh_copyFld( 'msPrc_mo', 'msPrc_moW',, .t. )
    MZD_msOdppol_cpy()

    * TAB 2
    MZD_msTarind_msSazzam_cpy()

    if msvPrum ->( dbseek( msPrc_mo->sid,,'nMSPRC_MO'))
      mh_copyFld( 'msvPrum', 'msvPrumW',.t., .t. )
    else
      mh_copyFld( 'msPrc_mo', 'msvPrumW',.t., .t. )
    endif

    * TAB 3 - matrice
    cKy     := strZero(msPrc_mo->nosCisPrac,5) + ;
               strZero(msPrc_mo->nporPraVzt,3)

    msMzdyhd->( dbSetScope(SCOPE_BOTH, cKy)                                  , ;
                dbEval( { || mh_copyFld('msMzdyhd', 'msMzdyhdW', .T., .t.) }), ;
                dbClearScope()                                                 )

    msMzdyit->( dbSetScope(SCOPE_BOTH, cKy)                                  , ;
                dbEval( { || mh_copyFld('msMzdyit', 'msMzdyitW', .T., .t.) }), ;
                dbClearScope()                                                 )

    * TAB 4
    cKy     := strZero(msPrc_mo->nrok,4)       + ;
               strZero(msPrc_mo->nobdobi,2)    + ;
               strZero(msPrc_mo->nosCisPrac,5) + ;
               strZero(msPrc_mo->nporPraVzt,3)

    msSrz_mox->( adsSetOrder('MSSRZ_01')                                       , ;
                 dbSetScope(SCOPE_BOTH, cKy)                                   , ;
                 dbgoTop()                                                     , ;
                 dbEval( { || mh_copyFld('msSrz_mox', 'msSrz_moW', .T., .t.) }), ;
                 dbClearScope()                                                  )

    * TAB - 5
    ** SUB TAB - 6 osoby
    osoby->(dbseek( msPrc_mo->nOSOBY,,'ID'))
    mh_copyFld( 'osoby', 'osobyW',, .t. )
    aadd( pa_vazRecs[1], osoby->(recNo()) )

  else

    eval( oDialog:b_INSERT )

     * TAB 4            - msSrz_mo
    if in_whoIsIn .and. can_copyAll
      cKy     := strZero(msPrc_moC->nrok,4)       + ;
                 strZero(msPrc_moC->nobdobi,2)    + ;
                 strZero(msPrc_moC->nosCisPrac,5) + ;
                 strZero(msPrc_moC->nporPraVzt,3)

      msSrz_moX->( adsSetOrder('MSSRZ_01'), dbSetScope(SCOPE_BOTH, cKy), dbgoTop())

      do while .not. msSrz_mox->( eof())
        mh_copyFld( 'msSrz_mox', 'msSrz_moW', .T., .t. )
        msSrz_moW->_nrecor    := 0
        msSrz_moW->nporPRAvzt := msPrc_moW->nporPRAvzt

        msSrz_moX->( dbSkip())
      enddo

      msSrz_moX->( dbClearScope())
    endif

    * TAB 2             - msTarind - prázdý záznam Tarify se nepoužívají
    if msTarindw->(eof())
       msTarindW->(dbappend())
       *
       msTarindW->ctypTarPou := 'NEPOUZIV'
       msTarindW->ctypTarMzd := 'CASOVA'
    endif

    mh_copyFld( 'msPrc_mo', 'msvPrumW',.t.,.t. )

  endif

  * TAB 1 a SUB TAB 8 - dùchody - platí jak pro INS i ENTER
  mimPrvz ->( adsSetOrder('MIMPRVZ06')    , ;
              dbsetScope( SCOPE_BOTH, nKy), ;
              dbgoTop()                   , ;
              dbEval( { || mh_copyFld('mimPrvz' , 'mimPrvzW', .t., .t.) } ))

  duchodyX->( adsSetOrder('DUCHODY04')   , ;
              dbsetScope(SCOPE_BOTH, nKy), ;
              dbgoTop()                  , ;
              dbEval( { || mh_copyFld('duchodyX', 'duchodyW' , .t., .t.) } ))

** SUB TAB - 7 rodinní pøíslušnící - platí jak pro INS i ENTER
**  vazOsobyX  ->( dbEval( { || OSB_copyFldTo_W( 'vazOsobyX', 'vazOsobyW', .t., 'osoby_Rp' , pa_vazRecs[1]) } ))

return nil



function MZD_msOdppol_cpy(in_setDialog)
  local  nCelkOdOBD := nCelkOdROK := nCelkUlOBD := nCelkUlROK := 0
  local  cKy        := strZero(msprc_mow->nrok,4)       + ;
                       strZero(msprc_mow->nosCisPrac,5) + ;
                       strZero(msprc_mow->nporPraVzt,3)
  local  ldopln, lgenRec, typOdpPol
  local  lgenDite
  local  cf := "OSOBY = %%", filtrs
  local  acOdpocw := {}
  local  n := 0
  local  dfirstObd, dlastObd

  default in_setDialog to .f.


  if .not. in_setDialog

    msOdppol->( AdsSetOrder('MSODPP07')   , ;
                dbsetScope(SCOPE_BOTH,cKy), dbgoTop())

    do while .not. msOdppol->( eof())
      mh_copyFld( 'msOdppol', 'msOdppolW', .t., .t. )
      msOdppolW->laktiv := .f.

      if (year( msOdppolW->dplatnDo) *100 +month( msOdppolW->dplatnDo)) >= ;
         (uctOBDOBI:MZD:nROK*100 +uctOBDOBI:MZD:nOBDOBI) .or. empty( msOdppolW->dplatnDo)

        msOdppolW->laktiv := .t.

        if msOdppolW->lOdpocet
          nCelkOdOBD += msOdppolW->nOdpocOBD
          nCelkOdROK += msOdppolW->nOdpocROK
        else
          nCelkUlOBD += msOdppolW->nDanUlOBD
          nCelkUlROK += msOdppolW->nDanUlROK
        endif
      endif
      msOdppol->(dbskip())
    enddo

    msOdppol->( dbclearScope())
  else

    c_odpocW->( dbZap())
  endif
  *
  ** odpoèet na dìti
//  c_odpoc  ->( adsSetOrder('C_ODPOC03'), ;
//               dbsetScope(SCOPE_BOTH, strZero(uctOBDOBI:MZD:nROK,4)), dbgoTop())

  dfirstObd := mh_FirstODate( uctOBDOBI:MZD:nROK, uctOBDOBI:MZD:nOBDOBI)
  dlastObd  := mh_LastODate( uctOBDOBI:MZD:nROK, uctOBDOBI:MZD:nOBDOBI)
  filtrs := format( "nrok = %% and dPlatnOd <= '%%' and ( dPlatnDo >= '%%' or Empty( dPlatnDo))", { uctOBDOBI:MZD:nROK, dlastObd, dfirstObd } )
  c_odpoc->( ads_setAof( filtrs ), dbgoTop() )


//  filtrs := format( cf, { msprc_MoW->nOSOBY } )
//  vazOsobyX->( ads_setAof( filtrs ), dbgoTop() )

  vazOsobyW->(dbgoTop())
  c_odpoc  ->(dbgoTop())

  do while .not. c_odpoc->(eof())
    ldopln    := .f.
    lgenRec   := .t.
    lgenDite  := .t.
    typOdpPol := upper( c_odpoc->ctypOdpPol)

    do case
    case( typOdpPol = 'DITE' )
      do while .not. vazOsobyW->(eof())
        if osoby->( dbseek( vazOsobyW->nOSOBY,,'ID'))
          if lower(allTrim(vazOsobyW->ctypRodPri)) $ 'syn,dcera' .and. vazOsobyW->lSleOdpDan
            if .not. msOdppolW->( dbseek( typOdpPol +upper( osoby->crodCisOsb) +'1',,'MSODPPOW02'))
              mh_copyFld( 'c_odpoc', 'c_odpocW', .t., .t.)

              c_odpocw ->nCisOsoRP  := osoby->nCisOsoby
              c_odpocw ->cOsobaRP   := osoby->cOsoba
              c_odpocw ->cJmenoRoRP := osoby->cJmenoRozl
              c_odpocw ->crodCisRP  := osoby->crodCisOsb
              c_odpocw ->nrodPrisl  := vazOsobyX->nitem
              c_odpocw ->nOsCisPrac := msPrc_mow->nosCisPrac
              c_odpocw ->cKmenStrPr := msPrc_mow->ckmenStrPr
              c_odpocw ->cPracovnik := msPrc_mow->cpracovnik
              c_odpocw ->cOsoba     := msPrc_mow->cOsoba
              c_odpocw ->cJmenoRozl := msPrc_mow->cJmenoRozl
              c_odpocw ->nPorPraVzt := msPrc_mow->nporPraVzt
              c_odpocw ->dPlatnOd   := cTOd( "01/" +Str( uctOBDOBI:MZD:nOBDOBI) +"/" +Str( uctOBDOBI:MZD:nROK))
              c_odpocw ->cObdOd     := uctOBDOBI:MZD:cOBDOBI
              c_odpocw ->cObdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
//              c_odpocw ->nvazosoby  := vazOsobyX->sID

            endif
          endif
        endif
        vazOsobyW->(dbskip())
      enddo
      lgenRec := .f.

    case( typOdpPol = 'DIT1' .or. typOdpPol = 'DIT2' .or. typOdpPol = 'DIT3' )

*      if typOdpPol = 'DIT1' .or. typOdpPol = 'DIT2'
*        if msOdppolW->( dbseek( typOdpPol,,'MSODPPOW01'))
*          lgenDite := .not. msOdppolW->laktiv
*        else
*          lgenDite := .t.
*        endif
//        lgenDite := .not. msOdppolW->( dbseek( typOdpPol,,'MSODPPOW01'))
*      endif
      if typOdpPol = 'DIT3'
        lgenDite := .t.
      else
        lgenDite := .not. msOdppolW->( dbseek( typOdpPol+'1',,'MSODPPOW05'))
      endif

      if lgenDite
        vazOsobyW->( dbGoTop())
        do while .not. vazOsobyW->(eof()) .and. lgenDite
          if osoby->( dbseek( vazOsobyW->nOSOBY,,'ID'))
            if lower(allTrim(vazOsobyW->ctypRodPri)) $ 'syn,dcera' .and. vazOsobyW->lSleOdpDan
              n := Ascan( acOdpocw, osoby->crodCisOsb)
              if (( .not. msOdppolW->( dbseek( osoby->crodCisOsb,,'MSODPPOW04'))) .or.                ;
                   ( .not. msOdppolW->( dbseek( StrZero(osoby->nCisOsoby,6) + '1',,'MSODPPOW06')) )) .and. n = 0
//                   ( msOdppolW->( dbseek( osoby->crodCisOsb,,'MSODPPOW04')) .and. .not. msOdppolW->lAktiv)) .and. n = 0
                mh_copyFld( 'c_odpoc', 'c_odpocW', .t., .t.)

                c_odpocw ->crodCisRP  := osoby->crodCisOsb
                c_odpocw ->nCisOsoRP  := osoby->nCisOsoby
                c_odpocw ->cOsobaRP   := osoby->cOsoba
                c_odpocw ->cJmenoRoRP := osoby->cJmenoRozl
                c_odpocw ->nrodPrisl  := vazOsobyX->nitem
                c_odpocw ->nOsCisPrac := msPrc_mow->nosCisPrac
                c_odpocw ->cKmenStrPr := msPrc_mow->ckmenStrPr
                c_odpocw ->cPracovnik := msPrc_mow->cpracovnik
                c_odpocw ->cOsoba     := msPrc_mow->cOsoba
                c_odpocw ->cJmenoRozl := msPrc_mow->cJmenoRozl
                c_odpocw ->nPorPraVzt := msPrc_mow->nporPraVzt
                c_odpocw ->dPlatnOd   := cTOd( "01/" +Str( uctOBDOBI:MZD:nOBDOBI) +"/" +Str( uctOBDOBI:MZD:nROK))
                c_odpocw ->cObdOd     := uctOBDOBI:MZD:cOBDOBI
                c_odpocw ->cObdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)

                if osoby->lPrukazZPS

                endif

                AAdd( acOdpocw, osoby->crodCisOsb )
    //              c_odpocw ->nvazosoby  := vazOsobyX->sID
//                lgenDite := if( typOdpPol = 'DIT1' .or. typOdpPol = 'DIT2', .f.,.t.)

              endif
            endif
          endif
          vazOsobyW->(dbskip())
        enddo
      endif
      lgenRec := .f.

    case typOdpPol = "ZAKL"                      // Sleva na dani za poplatníka
      lgenRec := if( msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01')), .F., msPrc_moW->ldanProhl)

    case typOdpPol = "INVC"                      // Sleva na dani na èásteè.inval.
      lgenRec := if( msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01')), .F., ( msPrc_moW->ntypDuchod = 7 .or.  ;
                                                   msPrc_moW->ntypDuchod = 13 .or. msPrc_moW->ntypDuchod = 14  ) )

    case typOdpPol = "INVP"                      // Sleva na dani na plnou inval.
      lgenRec := if( msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01')), .F., ( msPrc_moW->nTypDuchod = 5 .or.  ;
                                                                             msPrc_moW->nTypDuchod = 15) )

    case typOdpPol = "INVZ"                      // Sleva na dani za ZTP-P
      lgenRec := if( msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01')), .F., msPrc_moW->nTypDuchod = 6)

    case typOdpPol = 'STUD'
      lgenRec := if( msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01')), .F., msPrc_moW->lStudent)
//      lgenRec := .not.  msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01'))

    case typOdpPol = 'MANZ'
      do while .not. vazOsobyW->(eof())
        if osoby->( dbseek( vazOsobyW->nOSOBY,,'ID'))
          if lower(allTrim(vazOsobyW->ctypRodPri)) $ 'manzel' .and. vazOsobyW->lSleOdpDan
            if .not.  msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01'))
//            if .not. msOdppolW->( dbseek( typOdpPol +upper( osoby->crodCisOsb) +'1',,'MSODPPOW02'))
              mh_copyFld( 'c_odpoc', 'c_odpocW', .t., .t.)

              c_odpocw ->crodCisRP  := osoby->crodCisOsb
              c_odpocw ->nCisOsoRP  := osoby->nCisOsoby
              c_odpocw ->cOsobaRP   := osoby->cOsoba
              c_odpocw ->cJmenoRoRP := osoby->cJmenoRozl
              c_odpocw ->nrodPrisl  := vazOsobyX->nitem
              c_odpocw ->nOsCisPrac := msPrc_mow->nosCisPrac
              c_odpocw ->cKmenStrPr := msPrc_mow->ckmenStrPr
              c_odpocw ->cPracovnik := msPrc_mow->cpracovnik
              c_odpocw ->cOsoba     := msPrc_mow->cOsoba
              c_odpocw ->cJmenoRozl := msPrc_mow->cJmenoRozl
              c_odpocw ->nPorPraVzt := msPrc_mow->nporPraVzt
              c_odpocw ->dPlatnOd   := cTOd( "01/" +Str( uctOBDOBI:MZD:nOBDOBI) +"/" +Str( uctOBDOBI:MZD:nROK))
              c_odpocw ->cObdOd     := uctOBDOBI:MZD:cOBDOBI
              c_odpocw ->cObdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
//              c_odpocw ->nvazosoby  := vazOsobyX->sID

            endif
          endif
        endif
        vazOsobyW->(dbskip())
      enddo
      lgenRec := .f.

//      lgenRec := .not.  msOdppolW->( dbSeek( typOdpPol,,'MSODPPOW01'))
    otherwise
      lgenRec := .f.
    endcase

    if lgenRec
      mh_copyFld( 'c_odpoc', 'c_odpocW', .T., .t.)

      c_odpocW ->nosCisPrac := msPrc_moW ->nosCisPrac
      c_odpocW ->ckmenStrPr := msPrc_moW ->ckmenStrPr
      c_odpocW ->cpracovnik := Left( msPrc_moW ->cpracovnik, 25) +strZero( msPrc_moW ->nosCisPrac, 5)
      c_odpocw ->cOsoba     := msPrc_mow->cOsoba
      c_odpocw ->cJmenoRozl := msPrc_mow->cJmenoRozl
      c_odpocW ->dplatnOd   := mh_FirstODate( uctOBDOBI:MZD:NROK, uctOBDOBI:MZD:NOBDOBI)
      c_odpocw ->nPorPraVzt := msPrc_mow->nporPraVzt
      c_odpocW ->cobdOd     := uctOBDOBI:MZD:cOBDOBI
      c_odpocW ->cobdDo     := "12/" +SubStr( uctOBDOBI:MZD:cOBDOBI, 4, 2)
      c_odpocW ->nporOdpPol := c_odpocW->( recNo())
    endif

    c_odpoc->(dbskip())
  enddo

  c_odpoc->( dbclearScope())
  vazOsobyW->(dbgoTop())
return nil


static function MZD_msTarind_msSazzam_cpy()
  local  cKy  := strZero(msprc_mow->nosCisPrac,5) + ;
                 strZero(msprc_mow->nporPraVzt,3)

  * tarify individuální *
  msTarind->( adsSetOrder( 'C_TARIN4')   , ;
              dbsetScope(SCOPE_BOTH, cKy), ;
              dbgoTop()                  , ;
              dbeval( { || mh_copyFld( 'msTarind', 'msTarindW', .t., .t.) } ))

/*
  do while .not. msTarind->( eof())
    if .not. Empty( mstarind->dplatTarDo) .and.                         ;
            ( msPrc_moW->nrok    <= Year(  msTarind->dplatTarDo)) .and. ;
            ( msPrc_moW->nobdobi <= Month( msTarind->dplatTarDo))
      mh_copyFld( 'msTarind', 'msTarindW', .t., .t.)

    else
      if .not. Empty(msTarindW->dplatTarOd)

        msTarindW->dplatTarDo := msTarindW->dplatTarOd -1

        if ( msPrc_moW->nrok > Year( msTarindW->dplatTarDo))
          msTarindW->( dbDelete())
        else
         if ( msPrc_moW->nrok    = Year(  msTarindW->dplatTarDo)) .and. ;
            ( msPrc_moW->nobdobi > Month( msTarindW->dplatTarDo))
           msTarindW->( dbDelete())
         endIf
        endIf
      endIf

      mh_copyFld( 'msTarind', 'msTarindW', .T., .t.)
    endIf
    msTarind->( dbskip())
  enddo
*/
  *
  ** tarify zamìstancù
  msSazzam->( adsSetOrder('MSSAZZAM04'), ;
              dbsetScope(SCOPE_BOTH, cKy), dbgoTop())

  do while .not. msSazzam->( eof())
    mh_copyFld( 'msSazzam', 'msSazzamW', .T., .t. )

/*
    if .not. Empty( msSazzam->dplatSazDo) .and.                          ;
             ( msPrc_moW->nrok    <= Year(  msSazzam->dplatSazDo)) .and. ;
             ( msPrc_moW->nobdobi <= Month( msSazzam->dplatSazDo))
      mh_copyFld( 'msSazzam', 'msSazzamW', .T., .t. )

    else
      if .not. Empty( msSazzamW->dplatSazOd)

        msSazzamw->dplatSazDo := msSazzamW->dplatSazOd -1

        if ( msPrc_moW->nrok > Year( msSazzamW->dplatSazDo))
          msSazzamW->( dbDelete())
        else
          if ( msPrc_moW->nrok    = Year(  msSazzamW->dplatSazDo)) .and. ;
             ( msPrc_moW->nobdobi > Month( msSazzamW->dplatSazDo))
            msSazzamW->( dbDelete())
          endIf
        endIf
      endIf

      mh_copyFld( 'msSazzam', 'msSazzamW', .T., .t. )
    endIf
*/

    msSazzam->( dbskip())
  endDo
return nil


function MZD_kmenove_wrt( oDialog )
  local  lnewRec   := oDialog:lnewRec
  local  lPravdPod := oDialog:lPravdPod
  local  ok       := .t.
  local  lnewPrs  := .t., is_msOsb_mo := .f.
  local  x, cfile_M, paLock, paObj, cfile_W, paVaz, isEmpty, val, nIn
  local  pa_osobySk, nsk, nrecOr
  *
  local  modify_cisOsoby
  local  modify_oscisPrac
  local  tm_cisOsoby, tm_oscisPrac
  local  pa_glueItems, nstep_G, npos_G
  *
  local  paF := { { 'osoby'   , {}, nil, 0, .f., .t. }, ;
                  { 'msPrc_mo', {}, nil, 2, .t., .f. }, ;
                  { 'mimPrvz' , {}, nil, 0, .t., .t. }, ;
                  { 'msOdpPol', {}, nil, 0, .f., .t. }, ;
                  { 'msTarind', {}, nil, 0, .f., .t. }, ;
                  { 'msSazZam', {}, nil, 0, .f., .t. }, ;
                  { 'msMzdyhd', {}, nil, 0, .f., .t. }, ;
                  { 'msMzdyit', {}, nil, 0, .f., .t. }, ;
                  { 'msSrz_mo', {}, nil, 2, .f., .t. }, ;
                  { 'vazOsoby', {}, nil, 1, .f., .f. }, ;
                  { 'duchody' , {}, nil, 0, .t., .t. }, ;
                  { 'osoby_Rp', {}, nil, 0, .f., .f. }  }
  *
  local cStatement, oStatement
  local stmt   := 'update msprc_mo set ldanPrVzt = FALSE ' + ;
                  'where (nrok = %% and nobdobi = %% and noscisPrac = %% and nporPraVzt <> %%)'

  local stmt_1 := 'update msprc_mo set ldanVypoc = FALSE ' + ;
                  'where (nrok = %% and nobdobi = %% and noscisPrac = %% and nporPraVzt <> %%)'


  * holt ovìøíme ncisOsoby a noscisPrac
  nrecOr := osobyW->_nrecOr

  if lnewRec
    mh_copyFld('msPrc_moW', 'osobyW' )
    *
    ** nejednozanènost názvù údajù, pokud by jich bylo víc dáme to do EVAL bloku
    osobyW->crodCisOsb :=  msPrc_moW->crodCisPra

    * osoba již existuje ? dotažený záznam z osoby ?
    if nrecOr <> 0
      osobyW->_nrecOr := nrecOr
    else
      fordRec( { 'osoby,1' } )
      osoby->( DbGoBottom())
      osobyW ->ncisOsoby := osoby->ncisOsoby +1
      fordRec()
    endif
  else
    osobyW->crodCisOsb :=  msPrc_moW->crodCisPra

    osobyW->cPracZar   :=  msPrc_moW->cPracZar
    osobyW->cFunPra    :=  msPrc_moW->cFunPra
    osobyW->cOrgUsek   :=  msPrc_moW->cOrgUsek
    osobyW->cKmenStrPr :=  msPrc_moW->cKmenStrPr
    osobyW->cNazPol1   :=  msPrc_moW->cNazPol1
    osobyW->cNazPol4   :=  msPrc_moW->cNazPol4
    osobyW->cTypPraKal :=  msPrc_moW->cTypPraKal
    osobyW->cTypSmeny  :=  msPrc_moW->cTypSmeny
    osobyW->cDelkPrDob :=  msPrc_moW->cDelkPrDob

    osobyW->lstavem    :=  msPrc_moW->lstavem
    osobyW->nstavem    :=  msPrc_moW->nstavem

    if msPrc_moW->nstavem = 0
      osobyW->nis_DOH := 0
      AktSkupOSB( osobyW->ncisosoby, 'DOH', 'DEL')
      osobyW->nis_VYR := 0
      AktSkupOSB( osobyW->ncisosoby, 'VYR', 'DEL')
    endif

  endif

  * slepenci ve slivenci
  osobyW->(dbcommit())
  OSB_glueItems()

  * zpìtnì modifikujem msPrc_moW
  msPrc_moW->cosoba     := osobyW->cosoba
  msPrc_moW->cjmenoRozl := osobyW->cjmenoRozl
  msPrc_mow->cpracovnik := msPrc_moW->cosoba
  msPrc_mow->cprijPrac  := msPrc_mow->cprijOsob

  msPrc_mow->cjmenoPrac := msPrc_mow->cjmenoOsob
  msPrc_mow->nfyzStaZdr := if( msPrc_mow->lzdrPojis, 1, 0 )
  msPrc_mow->nclenSpol  := if( msPrc_mow->nTypZamVzt = 2 .or.  ;
                               msPrc_mow->nTypZamVzt = 3 .or.  ;
                               msPrc_mow->nTypZamVzt = 4, 1, 0 )


  * pokud by mìl náhodou spoèítanou èistou mzdu, shodíme to na 7
  *  1 - nad zamìstnancem byl proveden automatický výpoèet èisté mzdy
  *  2 - nad zamìstnancem byl proveden ruèní  výpoèet èisté mzdy
  *  7 - výpoèet èisté mzdy byl zrušen aktualizací dat
  if msPrc_moW->nstaVypoCM = 1 .or. msPrc_moW->nstaVypoCM = 2
    msPrc_moW->nstaVypoCM := 7
  endif

  * modifikace msPrc_moW a jakési volání TMPkmenSTR a EvidPocPrac
  msPrc_moW_modi()
  msPrc_moW ->(dbcommit())

  pa_glueItems := { { 'nporPRAvzt', msPrc_moW->nporPRAvzt }, ;
                    { 'cRoObCpPPv', msPrc_moW->cRoObCpPPv }, ;
                    { 'cRoCpPPv'  , msPrc_moW->cRoCpPPv   }, ;
                    { 'cCpPPv'    , msPrc_moW->cCpPPv     }, ;
                    { 'lstavem'   , msPrc_moW->lstavem    }  }

  * mno vazOsobyW ovlivní osoby_Rp, tak si je kopnem a modifikujem
  * pak je to stejné
  vazOsobyW->( dbgoTop())
  do while .not. vazOsobyW->(eof())
    if osoby_Rp->( dbseek( vazOsobyW->nOSOBY   ,, 'ID' ))
      *
      ** nemá cenu modifikovat parenta, pokud nic nezmìnil
      if vazOsobyW->ddatNaroz  <> osoby_Rp->ddatNaroz .or. ;
         vazOsobyW->crodCisOsb <> osoby_Rp->crodCisOsb

        mh_copyFld( 'osoby_Rp', 'osoby_RpW', .t., .t. )

        * tož tohle je na vazbì ale i na základní tøídì
        osoby_RpW->ddatNaroz  := vazOsobyW->ddatNaroz
        osoby_RpW->crodCisOsb := vazOsobyW->crodCisOsb
      endif
    endif
    vazOsobyW->(dbskip())
  enddo

  * prSmlDoh
  if prSmlDoh->(dbseek( strZero(msPrc_moW->noscisPrac,5) +strZero( msPrc_moW->nporPraVzt,3),,'PRSMLDOH09'))
    lnewPrs := .f.
    ok := prSmlDoh->(sx_Rlock())
  endif

  * msOsb_mo
  if( is_msOsb_mo := msOsb_mo->( dbseek( strZero(msPrc_moW->nrok,4)    + ;
                                         strZero(msPrc_mow->nobdobi,2) +;
                                         strZero(msPrc_mow->ncisOsoby,6),,'MSOSB_MO10' )) )
    ok := ( ok .and. msosb_mo->(sx_RLock()) )
  endif


  * zámky
  for x := 1 to len(paF) step 1
    cfile_M := paF[x,1]
    cfile_W := cfile_M +'w'
    paLock  := paF[x,2]
    paObj   := paF[x,3]

    (cfile_W)->(ordSetFocus(0), dbgoTop())

    do while .not. (cfile_W)->(eof())
      if((cfile_W)->_nrecor <> 0, AAdd(paLock, (cfile_W)->_nrecor), nil)

      if isArray(paObj) .or. isCharacter(paObj)
        isEmpty := .t.
        if isArray(paObj)
          AEval(paObj,{|x| isEmpty := (isEmpty .and. empty( eval(x:ovar:block))) })
        else
          isEmpty := (isEmpty .and. .not. DBGetVal(paObj))
        endif

        if( isEmpty, (cfile_W)->_delrec := '9', nil)
      endif
      (cfile_W)->(dbSkip())
    enddo

    (cfile_W)->(dbgoTop())

    ok := (ok .and. (cfile_M)->(sx_RLock(paLock)))
  next

  * ukládáme
  if ok

    tm_cisOsoby  := osobyW->ncisOsoby          //JT
    tm_oscisPrac := msPrc_moW->noscisPrac      //JT

    for x := 1 to len(paF) step 1
      cfile_M          := paF[x,1]
      cfile_W          := cfile_M +'w'
      paLock           := paF[x,2]
      paVaz            := paF[x,4]
      modify_cisOsoby  := paF[x,5]
      modify_oscisPrac := paF[x,6]
      pa_osobySk       := {}

      (cfile_W)->(dbgoTop())

      do while .not. (cfile_W)->(eof())
        if (cfile_W)->_delrec <> '9'

          if((nrecor := (cfile_W)->_nrecor) = 0, nil, (cfile_M)->(dbgoto(nrecor)))

          if   (cfile_W)->_delrec = '9'  ;  (cfile_M)->(dbdelete())

          else
            if( paVaz = 1, (cfile_W)->OSOBY  := isNull( osoby->sID, 0), nil )
            if( paVaz = 2, (cfile_W)->nOSOBY := isNull( osoby->sID, 0), nil )
            *
            ** doplníme glueItems - do ostatních souborù mimo msPrc_mo
            if cfile_M <> 'msprc_mo'
              for nstep_G := 1 to len(pa_glueItems) step 1
                if ( npos_G := (cfile_W)->(fieldPos(pa_glueItems[nstep_G,1]))) <> 0
                  (cfile_W)->(fieldPut(npos_G, pa_glueItems[nstep_G,2]))
                endif
              next
            endif

            do case
            case cfile_M = 'osoby'
              do case
              case ( osobyW->nis_PER +osobyW->nis_ZAM ) = 0
                osobyW->nis_PER := 1
                osobyW->nis_ZAM := 1
                pa_osobySk      := {'PER','ZAM'}

              case osobyW->nis_PER = 0
                osobyW->nis_PER := 1
                pa_osobySk      := {'PER'}

              case osobyW->nis_ZAM = 0
                osobyW->nis_ZAM := 1
                pa_osobySk      := {'ZAM'}
              endcase

              * úprava pro import z výroby lExport
              if msPrc_moW->lExport .and. osobyW->nis_VYR = 0
                osobyW->nis_VYR := 1
                aadd( pa_osobySk, 'VYR' )
              endif

            case cfile_M = 'msTarind'
              (cfile_W)->ctask      := 'MZD'
              (cfile_W)->ncisOsoby  := osoby->ncisOsoby
              (cfile_W)->cJmenoRozl := osoby->cJmenoRozl

            endcase

            if modify_cisOsoby  .and. (cfile_W)->(fieldPos('ncisOsoby' )) <> 0
              (cfile_W)->ncisOsoby := tm_cisOsoby
            endif

            if modify_oscisPrac .and. (cfile_W)->(fieldPos('noscisPrac')) <> 0
              (cfile_W)->noscisPrac := tm_oscisPrac
            endif

            mh_copyFld(cfile_W, cfile_M, ((cfile_W)->_nrecor = 0))

//  JT 28.5.2014
            do case
            case cfile_M = 'mssrz_mo'
              (cfile_M)->nmsprc_mo := isNull( msprc_mo->sid, 0)

            case cfile_M = 'msmzdyit'                    //  JT 05.09.2014
              (cfile_M)->nmsmzdyhd := isNull( msmzdyhd->sid, 0)

            endcase
//  JT
            for nsk := 1 to len(pa_osobySk) step 1
              osobySk->(dbappend(),Rlock())
              osobySk->ncisOsoby := osoby->ncisOsoby
              osobySk->czkr_skup := pa_osobySk[nsk]
              osobySk->(dbUnlock(), dbcommit())
            next

            if(nIn := AScan(paLock, nrecor)) <> 0
              (adel(paLock,nIn), asize(paLock, len(paLock) -1))
            endif
          endif
        endif

        (cfile_W)->(dbSkip())
      enddo

      AEval(paLock, {|recs| (cfile_M)->(dbgoTo(recs), dbDelete()) })
    next

    * založení/ modifikace prSmlDoh
    msPrc_moW->(dbgoTop())
    if lnewPrs
      mh_copyFld( 'msPrc_mo', 'prSmlDoh', .t.)
      msPrc_mo->nprSmlDoh := isNull( prSmlDoh->sid, 0)
    else
      eval(oDialog:b_MSPRC_MOW_PRSMLDOH)
    endif

    * založení / modifikace msOsb_mo
    if is_msOsb_mo
      eval(oDialog:b_MSPRC_MOW_MSOSB_MO)
    else
      mh_copyFld( 'msPrc_mo', 'msOsb_mo', .t.)
    endif

    if lPravdPod
      if .not. msvPrum->( dbSeek( msPrc_moW->cRoObCpPpv,,'PRUMV_06' ))
        mh_copyFld( 'msvPrumw', 'msvPrum', .t.)
        msvPrum->nmsprc_mo := msPrc_mo->sid
      else
        if msvPrum->( dbRlock())
          mh_copyFld( 'msvPrumw', 'msvPrum',.f. )
          msvPrum->( dbUnLock())
        endif
      endif
    endif

  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat KMENOVÉ údaje pracovníka, blokováno uživatelem !!!'))
  endif

  AEval( paF, { |x| (x[1])->(dbUnlock(),dbCommit()) })
   prSmlDoh->( dbUnlock(),dbCommit())
   msOsb_mo->( dbUnlock(),dbCommit())

  * Daòit pracovní vztah - musí být nastaveno jen na jednom záznamu msprc_mo
  msPrc_moW->(dbgoTop())

  if ok .and. msprc_mow->ldanPrVzt

    cStatement := format( stmt, { msprc_mo->nrok, msprc_mo->nobdobi, msprc_mo->noscisPrac, msPrc_mo->nporPraVzt })
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*      return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
  endif

  * Výpoèet roèní danì - musí být nastaveno jen na jednom záznamu msprc_mo
  if ok .and. msprc_mow->ldanVypoc

    cStatement := format( stmt_1, { msprc_mo->nrok, msprc_mo->nobdobi, msprc_mo->noscisPrac, msPrc_mo->nporPraVzt })
    oStatement := AdsStatement():New(cStatement,oSession_data)

    if oStatement:LastError > 0
*      return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
  endif

return ok


static function msPrc_moW_modi()
  local  pa
  local  c_CpPpv := strZero( msPrc_moW->noscisPrac,5) +strZero( msPrc_moW->nporPraVzt,3)

  msPrc_moW->cRoObCpPpv := str( msPrc_moW->nrokObd,6) +c_CpPpv
  msPrc_moW->cRoCpPpv   := str( msPrc_moW->nrok   ,4) +c_CpPpv
  msPrc_moW->cCpPPv     := c_CpPpv

  msprc_moW->nDokladCM  := Val( SubStr(msprc_moW->cRoObCpPPv,3,9) + right(msprc_moW->cRoObCpPPv,1))
  msPrc_moW->lStavem    := if( empty( msPrc_moW->ddatVyst), .t.                               ;
                            , if( year( msPrc_moW->ddatVyst) > uctOBDOBI:MZD:nROK, .t.        ;
                             , if( month( msPrc_moW->ddatVyst) >= uctOBDOBI:MZD:nOBDOBI .AND. ;
                                year( msPrc_moW->ddatVyst) = uctOBDOBI:MZD:nROK, .t., .f.)))
  msPrc_moW->nStavem    := if( msPrc_moW->lStavem, 1, 0)
  msPrc_moW->nrokobdsta := (msPrc_moW->nrokobd*10) +msPrc_moW->nStavem
  msprc_moW->nctvrtleti := mh_CTVRTzOBDn( msprc_moW->nobdobi)

  msPrc_moW->lzdrPojis  := ( msPrc_moW->lStavem .and. c_pracvz->lzdrPojis )
  msPrc_moW->lsocPojis  := ( msPrc_moW->lStavem .and. c_pracvz->lSocPojis )

  msPrc_moW->nTmOZprCMz  := 0
  msPrc_moW->cTmKmStrPr  := TMPkmenSTR( MSPRC_MOw->cKmenStrPr)

  if msPrc_moW->nWkStation = 0
    msPrc_moW->nWkStation := SysConfig( 'SYSTEM:nWKStation')
  endif

  EvidPocPrac( "MSPRC_MOw")

//  VypPravdPruMS()


** ?  lZMENvyst := MSPRC_MO->dDatVyst <> MSPRC_MOw->dDatVyst
  msPrc_moW->lPrukazZPS := if( !Empty( msPrc_mow->cPrukazZPS), .T., .F.)

  if msPrc_moW->nTypDuchod = 5 .or. msPrc_moW->nTypDuchod = 6 .or. msPrc_moW->nTypDuchod = 7   ;
       .or. ( msPrc_moW->nTypDuchod >= 11 .and. msPrc_moW->nTypDuchod <= 15)
    msPrc_moW->lEvidovZP  := .t.
  else
    msPrc_moW->lEvidovZP  := .f.
  endif
return nil


function prepNarDov( ddenOd, ddenDo, narok)
  local newNarok
  local pdRok,pdPPV
  local rokZpr
  local dOd, dDo

  rokZpr := uctOBDOBI:MZD:nROK

  dOd := mh_FirstODate( rokZpr, 1)
  dDo := mh_LastODate( rokZpr, 12)

  default ddenOd to dOd
  default ddenDo to dDo

  pdRok := Fx_prcDnyOD( dOd, dDo )
  pdPPV := Fx_prcDnyOD( ddenOd, ddenDo)

  newNarok := ( pdPPV * narok ) / pdRok

  newNarok :=  mh_roundnumb( newNarok, 222)

return newNarok


function prepNarDov21( ddenOd, ddenDo, narok, pracdoba)
  local newNarok
  local pdRok,pdPPV
  local rokZpr
  local dOd, dDo

  rokZpr   := uctOBDOBI:MZD:nROK
  newNarok := 0

  dOd := mh_FirstODate( rokZpr, 1)
  dDo := mh_LastODate( rokZpr, 12)

  default ddenOd to dOd
  default ddenDo to dDo

  pdRok := Fx_prcDnyOD( dOd, dDo )
  pdPPV := Fx_prcDnyOD( ddenOd, ddenDo)

  if c_pracdo->(dbSeek( Upper(pracdoba),,'C_PRACDO01'))
    newNarok :=  narok * c_pracdo->nHodTyden
    newNarok :=  mh_roundnumb( newNarok, 222)
  endif

//  newNarok := ( pdPPV * narok ) / pdRok
//  newNarok :=  mh_roundnumb( newNarok, 222)


return newNarok



function prepZustDov(dialog)
  local  nvalue

  nvalue := dialog:dataManager:get('msprc_mow->ndovbeznar') - dialog:dataManager:get('msprc_mow->ndovbezkra') -  ;
                  dialog:dataManager:get('msprc_mow->ndovbezcer')
  dialog:dataManager:set('msprc_mow->ndovbezzus', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndodbeznar') - dialog:dataManager:get('msprc_mow->ndodbezkra') -  ;
                  dialog:dataManager:get('msprc_mow->ndodbezcer')
  dialog:dataManager:set('msprc_mow->ndodbezzus', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndovbezzus') +dialog:dataManager:get('msprc_mow->ndovminzus')
  dialog:dataManager:set('msprc_mow->ndovzustat', nvalue)
    //msprc_moC->nDovZustat := msprc_moC->nDovBezZus +msprc_moC->nDovMinZus

  nvalue := dialog:dataManager:get('msprc_mow->ndodbezzus') +dialog:dataManager:get('msprc_mow->ndodminzus')
  dialog:dataManager:set('msprc_mow->ndodzustat', nvalue)
    //  msprc_moC->nDoDZustat := msprc_moC->nDoDBezZus +msprc_moC->nDoDMinZus

  nvalue := dialog:dataManager:get('msprc_mow->ndovminnar') +dialog:dataManager:get('msprc_mow->ndovbeznar') +   ;
              dialog:dataManager:get('msprc_mow->ndodminnar') +dialog:dataManager:get('msprc_mow->ndodbeznar')
  dialog:dataManager:set('msprc_mow->ndovnaroce', nvalue)
    //  msprc_moC->nDovNaroCe := msprc_moC->nDovMinNar+msprc_moC->nDovBezNar      ;
    //                        +msprc_moC->nDoDMinNar+msprc_moC->nDoDBezNar

// dialog:dataManager:get('msprc_mow->ndovminkra') , dialog:dataManager:get('msprc_mow->ndodminkra')
  nvalue :=  dialog:dataManager:get('msprc_mow->ndovbezkra') +   ;
               dialog:dataManager:get('msprc_mow->ndodbezkra')
  dialog:dataManager:set('msprc_mow->ndovkracce', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndovminceo') +dialog:dataManager:get('msprc_mow->ndovbezceo') +   ;
              dialog:dataManager:get('msprc_mow->ndodminceo') +dialog:dataManager:get('msprc_mow->ndodbezceo')
  dialog:dataManager:set('msprc_mow->ndovceroce', nvalue)
    //  msprc_moC->nDovCerOCe := msprc_moC->nDovMinCeO+msprc_moC->nDovBezCeO      ;
    //                         +msprc_moC->nDoDMinCeO+msprc_moC->nDoDBezCeO

  nvalue := dialog:dataManager:get('msprc_mow->ndovmincer') +dialog:dataManager:get('msprc_mow->ndovbezcer') +   ;
              dialog:dataManager:get('msprc_mow->ndodmincer') +dialog:dataManager:get('msprc_mow->ndodbezcer')
  dialog:dataManager:set('msprc_mow->ndovcerrce', nvalue)
    //  msprc_moC->nDovCerRCe := msprc_moC->nDovMinCeR+msprc_moC->nDovBezCeR      ;
    //                        +msprc_moC->nDoDMinCeR+msprc_moC->nDoDBezCeR

  nvalue := dialog:dataManager:get('msprc_mow->ndovminzus') +dialog:dataManager:get('msprc_mow->ndovbezzus') +   ;
              dialog:dataManager:get('msprc_mow->ndodminzus') +dialog:dataManager:get('msprc_mow->ndodbezzus')
  dialog:dataManager:set('msprc_mow->ndovzustce', nvalue)
    //  msprc_moC->nDovZustCe := msprc_moC->nDovMinZus +msprc_moC->nDovBezZus     ;
    //                        +msprc_moC->nDoDMinZus +msprc_moC->nDoDBezZus

  if nvalue < 0
    drgMsgBox(drgNLS:msg('POZOR zùstatek dovolené je záporný ! Mùže dojít k pøeèerpání dovolené !!!'))
  endif


return nil


function prepZustDov21(dialog)
  local  nvalue

  nvalue := dialog:dataManager:get('msprc_mow->ndovbeznar') - dialog:dataManager:get('msprc_mow->ndovbezkra') -  ;
                  dialog:dataManager:get('msprc_mow->ndovbezcer')
  dialog:dataManager:set('msprc_mow->ndovbezzus', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndodbeznar') - dialog:dataManager:get('msprc_mow->ndodbezkra') -  ;
                  dialog:dataManager:get('msprc_mow->ndodbezcer')
  dialog:dataManager:set('msprc_mow->ndodbezzus', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndovbezzus') +dialog:dataManager:get('msprc_mow->ndovminzus')
  dialog:dataManager:set('msprc_mow->ndovzustat', nvalue)
    //msprc_moC->nDovZustat := msprc_moC->nDovBezZus +msprc_moC->nDovMinZus

  nvalue := dialog:dataManager:get('msprc_mow->ndodbezzus') +dialog:dataManager:get('msprc_mow->ndodminzus')
  dialog:dataManager:set('msprc_mow->ndodzustat', nvalue)
    //  msprc_moC->nDoDZustat := msprc_moC->nDoDBezZus +msprc_moC->nDoDMinZus

  nvalue := dialog:dataManager:get('msprc_mow->ndovminnar') +dialog:dataManager:get('msprc_mow->ndovbeznar') +   ;
              dialog:dataManager:get('msprc_mow->ndodminnar') +dialog:dataManager:get('msprc_mow->ndodbeznar')
  dialog:dataManager:set('msprc_mow->ndovnaroce', nvalue)
    //  msprc_moC->nDovNaroCe := msprc_moC->nDovMinNar+msprc_moC->nDovBezNar      ;
    //                        +msprc_moC->nDoDMinNar+msprc_moC->nDoDBezNar

// dialog:dataManager:get('msprc_mow->ndovminkra') , dialog:dataManager:get('msprc_mow->ndodminkra')
  nvalue :=  dialog:dataManager:get('msprc_mow->ndovbezkra') +   ;
               dialog:dataManager:get('msprc_mow->ndodbezkra')
  dialog:dataManager:set('msprc_mow->ndovkracce', nvalue)

  nvalue := dialog:dataManager:get('msprc_mow->ndovminceo') +dialog:dataManager:get('msprc_mow->ndovbezceo') +   ;
              dialog:dataManager:get('msprc_mow->ndodminceo') +dialog:dataManager:get('msprc_mow->ndodbezceo')
  dialog:dataManager:set('msprc_mow->ndovceroce', nvalue)
    //  msprc_moC->nDovCerOCe := msprc_moC->nDovMinCeO+msprc_moC->nDovBezCeO      ;
    //                         +msprc_moC->nDoDMinCeO+msprc_moC->nDoDBezCeO

  nvalue := dialog:dataManager:get('msprc_mow->ndovmincer') +dialog:dataManager:get('msprc_mow->ndovbezcer') +   ;
              dialog:dataManager:get('msprc_mow->ndodmincer') +dialog:dataManager:get('msprc_mow->ndodbezcer')
  dialog:dataManager:set('msprc_mow->ndovcerrce', nvalue)
    //  msprc_moC->nDovCerRCe := msprc_moC->nDovMinCeR+msprc_moC->nDovBezCeR      ;
    //                        +msprc_moC->nDoDMinCeR+msprc_moC->nDoDBezCeR

  nvalue := dialog:dataManager:get('msprc_mow->ndovminzus') +dialog:dataManager:get('msprc_mow->ndovbezzus') +   ;
              dialog:dataManager:get('msprc_mow->ndodminzus') +dialog:dataManager:get('msprc_mow->ndodbezzus')
  dialog:dataManager:set('msprc_mow->ndovzustce', nvalue)
    //  msprc_moC->nDovZustCe := msprc_moC->nDovMinZus +msprc_moC->nDovBezZus     ;
    //                        +msprc_moC->nDoDMinZus +msprc_moC->nDoDBezZus

  if nvalue < 0
    drgMsgBox(drgNLS:msg('POZOR zùstatek dovolené je záporný ! Mùže dojít k pøeèerpání dovolené !!!'))
  endif


return nil



function VypPravdPruMS(dialog)
  local lok := .f.
  local key

//  dialog:dataManager:save()

  key := Str(msprc_mow->nrokobd,6) + StrZero(dialog:dataManager:get('msPrc_moW->nOsCisPrac'),5) +    ;
           StrZero( dialog:dataManager:get('msPrc_moW->nPorPraVzt'),3)
  if dialog:dataManager:get('msPrc_moW->lAutoVypPr') .and.  dialog:dataManager:get('msPrc_moW->nAlgPraPru') > 0
//    if .not. msvPrum->( dbSeek( key,,'PRUMV_06' )) .and. Month(dialog:dataManager:get('msPrc_moW->ddatnast')) = msPrc_moW->nobdobi
    if Month(dialog:dataManager:get('msPrc_moW->ddatnast')) = msPrc_moW->nobdobi
      fVYPprumer( .t., .t.,, Str(msprc_mow->nrokobd,6),,'msvPrumw', 3, 'msprc_mow')
      dialog:dataManager:set('msvPrumw->nhodprumpp', msvPrumw->nhodprumpp)
      dialog:dataManager:set('msvPrumw->ndenprumpp', msvPrumw->ndenprumpp)
      dialog:dataManager:set('msvPrumw->nDenVZhruN', msvPrumw->nDenVZhruN)
      dialog:dataManager:set('msvPrumw->nDenVZciKN', msvPrumw->nDenVZciKN)
      dialog:dataManager:set('msvPrumw->nDenVZcisN', msvPrumw->nDenVZcisN)
      dialog:dataManager:set('msvPrumw->nSazDenNiN', msvPrumw->nSazDenNiN)
      dialog:dataManager:set('msvPrumw->nSazDenVKN', msvPrumw->nSazDenVKN)
      dialog:dataManager:set('msvPrumw->nSazDenVyN', msvPrumw->nSazDenVyN)
      lok := .t.
    endif
  endif

return lok