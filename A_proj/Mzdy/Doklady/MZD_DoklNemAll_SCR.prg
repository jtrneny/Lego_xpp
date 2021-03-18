#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


//-----+ MZD_srazky_SCR +-------------------------------------------------------
CLASS MZD_doklnemall_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart

  method  InFocus
  method  itemMarked
  method  stableBlock
  method  CardOfSrazkyMzd

  class   var mo_prac_filtr READONLY


  inline method setSysFilter( ini )
    local rok, mes
    local rokobd
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.


    cfiltr  := ::mo_prac_filtr

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'mzdnemoc')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzdnemoc', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'mzdnemoc')

      mzdnemoc->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif

    ::enableOrDisable_action()
  return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'mssrz_mo')

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  brow, rok, obdobi
  var  pa_relForText, is_form_mzd_kmenove_scr
  var  cmain_Ky

endclass

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_doklnemall_SCR:Init(parent)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr
  LOCAL cX

  ::drgUsrClass:init(parent)

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI
  ::pa_relForText := {}
  ::is_form_mzd_kmenove_scr := .f.

  drgDBMS:open('msprc_mo')
  drgDBMS:open('mzdnemoc')
  drgDBMS:open('mzddavhd')
  drgDBMS:open('mzddavit')
  drgDBMS:open('ucetpol')

  ::mo_prac_filtr := ''
  ::cmain_Ky      := 'strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)'

  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 3
    ::drgDialog:set_prg_filter(pa_initParam[2], 'mzdnemoc')

    msPrc_mo->( dbseek( pa_initParam[3],,'MSPRMO01' ))
    ::is_form_mzd_kmenove_scr := .t.
  endif

  * programový filtr
//  rokobd := (::rok*100) + ::obdobi
//  cfiltr := Format("nosCisPrac = %% and nporpravzt = %%", {msPrc_mo->nosCisPrac,msPrc_mo->nporPraVzt})
//  ::drgDialog:set_prg_filter( cfiltr, 'mzdnemoc')

RETURN self


METHOD MZD_doklnemall_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_doklnemall_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:amembers, x, oDrg
  *
  local  pa := ::pa_relForText

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )


  ::brow := drgDialog:dialogCtrl:oBrowse

   for x := 1 to len(members) step 1
     odrg := members[x]
     if lower(odrg:ClassName()) $ 'drgtext'

       if( isArray(odrg:arRelate) .and. len(odrg:arRelate) <> 0, aadd( pa, odrg ), nil )
     endif
   next

RETURN self

method MZD_doklnemall_SCR:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  rokobd := (::rok*100) + ::obdobi
  *
  local  cf_h := "nmzdnemoc = %%"
  local  cf_i := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"
  *
  local  cmain_Ky := DBGetVal(::cmain_Ky), ok

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

          do case
     case( m_file = 'mzdnemoc' )
//       mzEldpHd->( ordsetFocus('MZELDPHD06'))
       if .not. ::is_form_mzd_kmenove_scr
         msPrc_mo->( dbseek( strZero( ::rok,4)  +strZero( ::obdobi,2)   + ;
                             strZero( mzdnemoc->nosCisPrac,5) +strZero( mzdnemoc->nporPraVzt,3),,'MSPRMO01' ))
       endif

       cfiltr := Format( cf_h, { mzdnemoc->sid })
       mzddavhd->(ads_setaof(cfiltr), dbGoTop())

     case( m_file = 'mzddavhd' )
       cfiltr := Format( cf_i, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
       mzddavit->(ads_setaof(cfiltr), dbGoTop())

       cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
       ucetpol  ->(mh_ordSetScope(cky))

     case( m_file = 'mzddavit' )
       cky := Upper(mzdDavIt->cDENIK) +StrZero(mzdDavIt->ndoklad,10) +strZero(mzdDavIt->nordItem,5)
       ucetpol  ->(mh_ordSetScope(cky))

     endcase

/*
     do case
     case( m_file = 'mzdnemoc' )
//       mzEldpHd->( ordsetFocus('MZELDPHD06'))

       cfiltr := Format( cf_h, { mzdnemoc->sid })
       mzddavit->(ads_setaof(cfiltr), dbGoTop())

     case( m_file = 'mzddavhd' )
*       cfiltr := Format( cf_i, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
*       mzddavit->(ads_setaof(cfiltr), dbGoTop())

     endcase
*/
  endif
return self

*****************************************************************
* Pøi pohybu v seznamu
*****************************************************************

method MZD_doklnemall_scr:stableBlock(oxbp)
  local m_file, cfiltr

/*
  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       cfiltr := Format("nROK = %% .and. cRodCisPra = '%%'", {MSPRC_MO->nROK, MSPRC_MO->cRODCISPRA})
*       PRSMLDOH->(ads_setaof(cfiltr), dbGoTop())
       ::drgDialog:set_prg_filter(cfiltr, 'PRSMLDOH')

       cfiltr := Format("nROKOBD = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %%"  ;
                       , {MSPRC_MO->nROKOBD, MSPRC_MO->nOSCISPRAC, MSPRC_MO->nPORPRAVZT})
*       MSSRZ_MO->(ads_setaof(cfiltr), dbGoTop())
       ::drgDialog:set_prg_filter(cfiltr, 'MSSRZ_MO')

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
*/

return self


METHOD MZD_doklnemall_SCR:CardOfSrazkyMzd()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_srazky_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

