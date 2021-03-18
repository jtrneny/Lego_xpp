#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
*
** CLASS MZD_zavazky_ob_SCR ****************************************************
CLASS MZD_trvzavhd_IT_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  InFocus
  METHOD  drgDialogStart

  method  stableBlock

  class   var mo_prac_filtr READONLY


*  inline access assign method nazevDruhu_Mzdy() var nazevDruhu_Mzdy
*    local cky := strZero(mzdZavIt->nrok,4) + ;
*                  strZero(mzdZavIt->nobdobi,2) + ;
*                   strZero(mzdZavIt->ndruhMzdy,4)

*    druhyMzd->(dbseek( cky,, 'DRUHYMZD04'))
*  return druhyMzd->cnazevDmz

  * položky - bro
  inline access assign method typDokladu() var typDokladu
    local  pa     := ::pa_column_1, npos
    local  retVal := 0

    if( npos := ascan( pa, { |x| x[1] = mzdZavHd->cdenik })) <> 0
      retVal := pa[npos,2]
    endif
    return retVal


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::setSysFilter()
       return .t.
    otherwise
      return .f.
    endcase
  return .f.

/*
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT   ;   ::CardOfKmenMzd()
    CASE nEvent = xbeP_Keyboard
      Do Case
      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.
*/

hidden:
  var  brow  // , mo_prac_filtr
  VAR  pa_column_1

  inline method setSysFilter( ini )
    local rok, mes
    local rokobd
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok     := uctOBDOBI:MZD:NROK
    mes     := uctOBDOBI:MZD:NOBDOBI
    rokobd  := (rok*100)+mes

    cfiltr  := Format("nROKOBD = %%", {rokObd}) + ::mo_prac_filtr

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'mzdzavhd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzdzavhd', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      mzdzavhd->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif


  return self
ENDCLASS


METHOD MZD_trvzavhd_IT_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('MZDZAVHD')
  drgDBMS:open('MZDZAVIT')
  *
  drgDBMS:open('DRUHYMZD')

  ::pa_column_1 := { { sysConfig( 'mzdy:cdenikMZ_H'), 534 }, ;
                     { sysConfig( 'mzdy:cdenikMZ_N'), 535 }, ;
                     { sysConfig( 'mzdy:cdenikMZ_S'), 536 }  }

  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'mzdzavhd')
  endif
RETURN self


METHOD MZD_trvzavhd_IT_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD MZD_trvzavhd_IT_SCR:drgDialogStart(drgDialog)

  ::brow          := drgDialog:dialogCtrl:oBrowse
  ::mo_prac_filtr := ''
  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( drgDialog:initParam )) = 2
    ::mo_prac_filtr := ' .and. ' +pa_initParam[2]
  endif

  ::setSysFilter( .t. )
RETURN self


method MZD_trvzavhd_IT_SCR:stableBlock(oxbp)
  local  m_file, cfiltr
  *
  local  cf := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzdzavhd' )
       cfiltr := Format( cf, { mzdzavHd->nrokObd, mzdzavHd->cdenik, mzdzavHd->ndoklad })
       mzdzavit->(ads_setaof(cfiltr), dbGoTop())

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif
return self


