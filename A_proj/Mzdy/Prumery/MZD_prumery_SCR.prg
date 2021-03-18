#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"

#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_prumery_SCR *******************************************************
CLASS MZD_prumery_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  var     stavem

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  method  stableBlock

  method  mzd_prumery_cmp, mzd_prumery_cmp_hv, mzd_podklady_scr, mzd_pracKalendar_in, mzd_prumery_del


  * browCOlumn
  inline access assign method is_Stavem() var is_Stavem
    return if( msprc_mo->lstavem, MIS_ICON_OK, 0 )

  * browCOlumn
  inline access assign method is_pravdPodHL() var is_pravdPodHL
    msvprumx->( dbSeek( msprc_mo->croobcpppv,,'PRUMV_06'))

    return if( msvprumx->lpravdPod, 560, 0 )    //560

  * browCOlumn
  inline access assign method typ_zpracPrumH() var typ_zpracPrumH
    local aret := { 0,561,561,561,561,560,0,0,0,0 }
    local typ  := 1
      //  ( 1) automatický výpoèet - založení období
      //  ( 2) automatický výpoèet - hromadný výpoèet
      //  ( 3) automatický výpoèet - nový PV
      //  ( 4) automatický výpoèet
      //  ( 9) ruèní výpoèet

      msvprumx->( dbSeek( msprc_mo->croobcpppv,,'PRUMV_06'))
      typ  := msvprumx->nStavZprac + 1

    return aret[typ]

  * browCOlumn
  inline access assign method pravdPodPrH() var pravdPodPrH
    local aret := { 0,553,552,560 }
    local typ  := 1
      //  ( 1) pravdìpodobný prùmìr z tarifu
      //  ( 2) pravdìpodobný prùmìr z hr.mzdy
      //  ( 3) pravdìpodobný prùmìr z min.období

      msvprumx->( dbSeek( msprc_mo->croobcpppv,,'PRUMV_06'))
      typ  := msvprumx->nAlgPraPru + 1
    return aret[typ]    //560

  * browCOlumn
  inline access assign method typ_zpracPrumP() var typ_zpracPrumP
    local aret := { 0,561,561,561,561,560,0,0,0,0 }
    local typ  := 1
      //  ( 1) automatický výpoèet - založení období
      //  ( 2) automatický výpoèet - hromadný výpoèet
      //  ( 3) automatický výpoèet - nový PV
      //  ( 4) automatický výpoèet
      //  ( 9) ruèní výpoèet

      typ  := msvprum->nStavZprac + 1
     return aret[typ]


  * browCOlumn
  inline access assign method pravdPodPrP() var pravdPodPrP
    local aret := { 0,553,552,560 }
    local typ  := 1

      typ  := msvprum->nAlgPraPru + 1
    return aret[typ]    //560

  * browCOlumn
  inline access assign method is_pravdPodPO() var is_pravdPodPO
    return if( msvprum->lpravdPod, 560, 0 )    //560


  inline method tabSelect( otabPage, tabNum)
    ::tabNum := tabNum
    ::stableBlock( ::brow[1]:oxbp )
  return .t.

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  VAR  msg, dm, dc, df, ab
  var  brow, oDBro_msPrc_mo, rok, obdobi, xbp_therm
  var  tabNum

ENDCLASS


*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_prumery_SCR:Init(parent)
  local  rokObd, cfiltr

  ::drgUsrClass:init(parent)

  ::rok    := uctOBDOBI:MZD:NROK
  ::obdobi := uctOBDOBI:MZD:NOBDOBI
  ::stavem := '1'
  ::tabNum := 1

  drgDBMS:open('msvprum')
  drgDBMS:open('msvprum',,,,,'msvprumx')


  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_prumery_SCR:drgDialogStart(drgDialog)
 ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )


  ::brow           := drgDialog:dialogCtrl:oBrowse
  ::oDBro_msPrc_mo := ::brow[1]
  ::xbp_therm      := drgDialog:oMessageBar:msgStatus

  * NEWs *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMabanager
  ::dc     := drgDialog:dialogCtrl              // dataCtrl
  ::df     := drgDialog:oForm                   // dialogForm
  ::ab     := drgDialog:oActionBar:members      // actionBar
RETURN self


method MZD_prumery_scr:stableBlock(oxbp)
  local  m_file, ctag, cky
  local  cfiltr

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       if ::tabNum = 1
         cfiltr := Format("cRoObCpPPv = '%%'", {msprc_mo->cRoObCpPPv})

//         ctag := 'PRUMV_03'
//         cky  := strZero(msprc_mo->nrok,4)       +strZero(msprc_mo->nobdobi,2) + ;
//                 strZero(msprc_mo->nosCisPrac,5) +strZero(msprc_mo->nporPraVzt,3 )
       else
         cfiltr := Format("nRok = %% and nOsCisPrac = %% and nPorPraVzt = %%", {msprc_mo->nRok, msprc_mo->nOsCisPrac, msprc_mo->nPorPraVzt})

//         ctag := 'PRUMV_04'
//         cky := strZero(msprc_mo->nosCisPrac,5) +strZero(msprc_mo->nporPraVzt,3) + ;
//                strZero(msprc_mo->nrok,4)
       endif

       msvPrum->( Ads_SetAOF( cfiltr), DbGoTop())
//       msvPrum->( ordSetFocus(ctag), dbsetscope(SCOPE_BOTH,cky), DbGoTop())

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
return self


method MZD_prumery_scr:mzd_prumery_cmp()
  local  cOBDnz  := strZero( ::rok, 4) +strZero( ::obdobi, 2)
  local  oDBro   := ::oDBro_msPrc_mo
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  lpravd := .f.
  *
  local  recNo   := msPrc_mo->(recNo()), ordFocus := msPrc_mo->( ordsetFocus())

  oDBro:oxbp:deHilite()
  msvPrum->( ordSetFocus('PRUMV_03'), dbclearscope(), dbgotop())

  do case
  case    oDBro:is_selAllRec
    ::mzd_prumery_cmp_hv( self, .t. )

  case len( oDBro:arSelect) <> 0
    nrecCnt := len( oDBro:arSelect)
    nkeyCnt := nrecCnt

    for x := 1 to len( oDBro:arSelect) step 1
      msPrc_mo->( dbgoTo( oDBro:arSelect[x]))
      fVYPprumer( .t.,lpravd,, cOBDnz,,, 4)

      nkeyNo++
      fin_bilancew_pb(::xbp_therm,nkeyCnt,nkeyNo )
    next
  otherwise

    fVYPprumer( .t.,lpravd,, cOBDnz,,,4 )
    fin_bilancew_pb(::xbp_therm, 1,nkeyNo )
  endcase

  msPrc_mo->( dbgoto( recNo), ordsetFocus( ordFocus))
  ::xbp_therm:setCaption( '  ' )

  * rušíme oznaèení
  oDBro:arselect := {}
  oDBro:oxbp:refreshAll()
  ::stableBlock(oDBro:oxbp)
  ::dm:refresh()
return self


method MZD_prumery_scr:mzd_prumery_cmp_hv( drgDialog, lfrom_cmp)
  local  cOBDnz  := strZero( ::rok, 4) +strZero( ::obdobi, 2)
  local  oDBro   := ::oDBro_msPrc_mo
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  *
  local  recNo   := msPrc_mo->(recNo()), ordFocus := msPrc_mo->( ordsetFocus())
  local  cky     := '201301'

  default lfrom_cmp to .f.

  oDBro:oxbp:deHilite()
  msvPrum->( ordSetFocus('PRUMV_03'), dbclearscope(), dbgotop())
  msvPrum->( Ads_ClearAof())

  nrecCnt := msPrc_mo->( ads_getKeyCount(1))
  nkeyCnt := nrecCnt

  msPrc_mo->( dbgoTop())

  do while .not. msPrc_mo->( eof())
    if( msPrc_mo->lAutoVypPr, fVYPprumer( .t.,,, cOBDnz,,,2 ), nil)
    msPrc_mo->( dbskip())

    nkeyNo++
    if( msPrc_mo->(eof()), nkeyno := nkeyCnt, nil )
    fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
  enddo

  if .not. lfrom_cmp
    msPrc_mo->( dbgoto( recNo), ordsetFocus( ordFocus))
    ::xbp_therm:setCaption( '  ' )

    oDBro:oxbp:refreshAll()
    ::dm:refresh()
  endif

  ::stableBlock(oDBro:oxbp)
return self


method MZD_prumery_scr:mzd_prumery_del( drgDialog)
  local  cOBDnz  := strZero( ::rok, 4) +strZero( ::obdobi, 2)
  local  oDBro   := ::oDBro_msPrc_mo
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  cfiltr
  *

//  default lfrom_cmp to .f.


  if drgIsYESNO(drgNLS:msg('Zrušit všechny vypoètené prùmìry za období ' + AllTrim( msprc_mo->cobdobi)+ '  ?'))

  oDBro:oxbp:deHilite()
  msvPrum->( ordSetFocus('PRUMV_03'), dbclearscope(), dbgotop())
  msvPrum->( Ads_ClearAof())

  cfiltr := Format("nRok = %% and nObdobi = %%", { ::rok, ::obdobi})
  msvPrum->( Ads_SetAOF( cfiltr), DbGoTop())

  nrecCnt := msvPrum->( ads_getKeyCount(1))
  nkeyCnt := nrecCnt

  msvPrum->( dbgoTop())

  do while .not. msvPrum->( eof())
    if( msvPrum->( RLock()), msvPrum->( dbDelete(), DbUnlock()), nil)
    msvPrum->( dbskip())

    nkeyNo++
    if( msvPrum->(eof()), nkeyno := nkeyCnt, nil )
    fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
  enddo

//  if .not. lfrom_cmp
//    msPrc_mo->( dbgoto( recNo), ordsetFocus( ordFocus))
  ::xbp_therm:setCaption( '  ' )

   oDBro:oxbp:refreshAll()
   ::dm:refresh()
//  endif
  msvPrum->( Ads_ClearAof())
  endif

  ::stableBlock(oDBro:oxbp)
return self



*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_prumery_scr:mzd_podklady_SCR()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prumery_mzdyitw_SCR' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self



*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_prumery_scr:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self



METHOD MZD_prumery_SCR:destroy()
 ::drgUsrClass:destroy()

RETURN SELF



static function fin_bilancew_pb(oxbp, nkeyCnt, nkeyNo, ncolor)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  nSize   := oxbp:currentSize()[1]
  local  nHight  := oxbp:currentSize()[2] -2

  default ncolor to GRA_CLR_PALEGRAY

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  GraGradient( ops                 , ;
               { newPos+1,2 }      , ;
               { { nsize, nhight }}, ;
               {ncolor,0,0}, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.