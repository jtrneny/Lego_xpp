#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
*
#include "DRGres.Ch'
#include "XBP.Ch"


*
** CLASS MZD_doklhrmz_NEMOC ****************************************************
class MZD_doklhrmz_NEMOC
exported:

  inline method gen_nemoc( m_parent )
    local  cky := upper  ( mzdDavHdw->ctypDoklad) + ;
                  upper  ( mzdDavHDw->ctypPohybu) + ;
                  left   ( dtos(mzdDavHdw->ddatumOd), 6 )

* úprava 6.2.2014 musí pracovat vždy z ddatumOd pro výpoèet z c_nemPas
//                  strZero( mzdDavHDw->nrokObd, 6)

    *
    local  dvykazN_OD, ddatumDO, ndnyNem, npasmoOD, npasmoDO, ndnyPas, ndnyNepl
    local  ndny_nemoci := 0
    local  it_nordItem := 10
    local  nrok        := mzdDavHdw->nrok
    local  nobdobi     := mzdDavHdw->nobdobi
    local  _vykazN_KD  := mzdDavHDw->_vykazN_KD
    local  dPrvniPlDat
    local  filtr

    drgDBMS:open( 'mzddavit',,,,,'mzddavitp' )

    if c_nempas->( dbseek( cky,, 'C_NEMPAS01'))

      c_nempas->( ordSetFocus( 'C_NEMPAS01' ) , ;
                  dbsetScope( SCOPE_BOTH, cky), ;
                  dbgoTop()                     )

      * pokraèování menoci
      if mzdDavHDw->_npokrN_MO = 1
        dvykazN_OD  := mh_FirstODate( nrok, nobdobi)  // mzdDavHdw->ddatumOd + _vykazN_KD
      else
        dvykazN_OD  := mzdDavHdw->ddatumOd
      endif

      ddatumDo    := if( empty(mzdDavHdw->ddatumDo)  , mh_LastODate( nrok, nobdobi), mzdDavHdw->ddatumDo  )
      if .not. Empty( dvykazN_OD)
        ndny_nemoci := ddatumDo - dvykazN_OD +1
      endif
      ndnyNem     := ndny_nemoci

      do while .not. c_nempas->(eof())

        druhyMzd->(dbseek( c_nempas->ndruhMzdy,, 'DRUHYMZD01'))

        npasmoOD   := c_nemPas->npasmoOd
        npasmoDO   := c_nemPas->npasmoDo
        ndnyPas    := npasmoDO -npasmoOD + 1

        ndnyPas    := max( 0, (ndnyPas - _vykazN_KD) )
        _vykazN_KD := 0

        if ( ndnyNem > 0 .and. ndnyPas > 0 )

          ::copyfldto_w( 'mzdDavHDw', 'mzdDavITw', .t. )
          mzdDavITw->( dbcommit())

          mzdDavITw->nordItem   := it_nordItem
          mzdDavITw->nsubItem   := 0
          mzdDavITw->ndruhMzdy  := c_nempas->ndruhMzdy

          * kalendáøní dny
          if .not. Empty(dvykazN_OD)
            mzdDavITw->dvykazN_OD := dvykazN_OD
            mzdDavITw->dvykazN_DO := dvykazN_OD + min( ndnyPas, ndnyNem) -1
          endif

          if .not. Empty(mzdDavITw->dvykazN_OD) .and. .not. Empty(mzdDavITw->dvykazN_DO)
            mzdDavITw->nvykazN_KD := (mzdDavITw->dvykazN_DO -mzdDavITw->dvykazN_OD) +1
            mzdDavITw->nvykazN_PD := Fx_prcDnyOD( mzdDavITw->dvykazN_OD, mzdDavITw->dvykazN_DO, .f. )
            mzdDavITw->nvykazN_VD := Fx_volDnyOD( mzdDavITw->dvykazN_OD, mzdDavITw->dvykazN_DO )
          endif
          mzdDavITw->nvykazN_HO := mzdDavITw->nvykazN_PD * fPracDOBA()[3]

          * proplaceno dny
          * musíme nìjak najít první pracovní den, od nìj se platí
          if  c_nemPas->ndnyNeplPD <> 0
            if mzdDavHDw->_npokrN_MO = 0
              dvykazN_OD := Fx_firstWorkDay( dvykazN_OD, mzdDavITw->dvykazN_DO, c_nemPas->ndnyNeplPD +1)
            else
              filtr  := format( "nOsCisPrac = %% and nPoradi = %%", { mzdDavHDw->nOsCisPrac, mzdDavHDw->nPoradi})
              mzddavitp->( ads_setAof(filtr), OrdSetFocus('MZDDAVIT01'), DbGoBottom())
              dPrvniPlDat := if( empty(mzddavitp->dProplN_DO), mzdDavHDw->dDatumOD, mzddavitp->dProplN_DO + 1 )
              ndnyNepl    := if( c_nemPas->ndnyNeplPD < mzddavitp->nVykazN_PD, 0, c_nemPas->ndnyNeplPD + 1)
              dPrvniPlDat := if( ndnyNepl = 0, mzdDavITw->dvykazN_OD, dPrvniPlDat)
              dvykazN_OD  := Fx_firstWorkDay( dPrvniPlDat, mzdDavITw->dvykazN_DO, ndnyNepl)
//              dvykazN_OD := Fx_firstWorkDay( dPrvniPlDat, mzdDavITw->dvykazN_DO, c_nemPas->ndnyNeplPD +1)
            endif
          endif

          mzdDavITw->dproplN_OD := dvykazN_OD

          * dproplN_DO nesmí být vyšší než dvykazN_DO
          if dvykazN_OD + min( ndnyPas, ndnyNem) -1 > mzdDavITw->dvykazN_DO
            mzdDavITw->dproplN_DO := mzdDavITw->dvykazN_DO
          else
            mzdDavITw->dproplN_DO := dvykazN_OD + min( ndnyPas, ndnyNem) -1
          endif

          if (mzdDavITw->dproplN_DO -mzdDavITw->dproplN_OD) > 0               ;
             .or. (mzdDavITw->dproplN_DO = mzdDavITw->dproplN_OD .and. .not. Empty(mzdDavITw->dproplN_OD ))
            if .not. Empty(mzdDavITw->dvykazN_OD) .and. .not. Empty(mzdDavITw->dvykazN_DO)
              mzdDavITw->nproplN_KD := (mzdDavITw->dproplN_DO -mzdDavITw->dproplN_OD) +1
              mzdDavITw->nproplN_PD := Fx_prcDnyOD( mzdDavITw->dproplN_OD, mzdDavITw->dproplN_DO, .f. )
              mzdDavITw->nproplN_VD := Fx_volDnyOD( mzdDavITw->dproplN_OD, mzdDavITw->dproplN_DO )
            endif
          endif

          * výpoèet hodin z nproplN_PD  ntypVypHm = 1:hodiny * sazba
          if druhyMzd->ntypVypHm = 1
            mzdDavITw->nhodDoklad := mzdDavitw->nproplN_PD * fPracDOBA()[3]
          else
            mzdDavitw->ndnyDoklad := mzdDavitw->nproplN_KD
          endif

          * pomocné uložení
          mzdDavitw->ndnyDoklad := mzdDavitw->nproplN_KD

          * Vylouèená doba a Vylouèená doba v ochranné dobì
          * lVylouDoba  -->  nDnyVylocD
          * lVyloDobOD  -->  nDnyVylDOD
          mzdDavITw->nDnyVylocD := if( druhyMzd->lVylouDoba, mzdDavITw->nvykazN_KD, 0)
          mzdDavITw->nDnyVylDOD := if( druhyMzd->lVyloDobOD, mzdDavITw->nvykazN_KD, 0)

          m_parent:aktFndNem( mzdDavITw->nvykazN_KD, mzdDavITw->nvykazN_PD, .t. )
          m_parent:VypHrMz( .t. )

          it_nordItem += 10
        endif

        if Empty( mzdDavITw->dvykazN_DO)
          dvykazN_OD := mh_FirstODate( nrok, nobdobi)
        else
          dvykazN_OD := mzdDavITw->dvykazN_DO +1
        endif

        ndnyNem    -= ndnyPas

        c_nempas->(dbskip())
      enddo

      c_nempas ->( DbClearScope())

      mzdDavITw->( dbcommit())
      mzd_mzddavhd_cmp()
      m_parent:brow:goTop():refreshAll()
      setAppFocus( m_parent:brow )

      m_parent:dm:refresh()
    endif
  return self

endclass


static function Fx_firstWorkDay( ddenOD, ddenDO, ndnyNeplPD )
  local  dproplN_OD := ctod( '  .  .  ' )
  *
  local  ndnPD      := fPracDOBA( msprc_mo ->cDelkPrDob)[1]
  local  cc_kd, cc_sv
  local  lok := .t.

  drgDBMS:open( 'c_svatky',,,,,'c_svatkyf' )

  do while ( ddenDO >= ddenOD ) .and. lok
    cc_kd := lower( left( CDow(ddenOD), 2 ))
    cc_sv := ''

    if c_svatkyf->( dbseek( dtos(ddenOD),,'C_SVATKY01'))
      cc_sv := lower( left( CDow(c_svatkyf->ddatum), 2 ))
    endif

    if (( cc_kd = 'so' .or. cc_sv = 'so') .and. nDnPD <= 5) .or. ;
       (( cc_kd = 'ne' .or. cc_sv = 'ne') .and. nDnPD <= 6)
    else
      if ndnyNeplPD > 0
        dproplN_OD := ddenOD
        ndnyNeplPD := ndnyNeplPD -1
      endif

      if ndnyNeplPD <= 0
        dproplN_OD := ddenOD
        lok := .f.
      endif
    endif
    if( lok, ddenOD++, nil)
  endDo

//  test zda pøesáhl tøi dny a má se datum vyprázdnit vždy od zaèátku nemoci
//  if  dproplN_OD - mzdDavITw->dvykazN_OD + 1 <= c_nemPas->ndnyNeplPD
//    dproplN_OD := ctod('  .  .    ')
//  endif

  if  dproplN_OD - mzdDavHDw->dDatumOD + 1 <= c_nemPas->ndnyNeplPD
    dproplN_OD := ctod('  .  .    ')
  endif


return dproplN_OD