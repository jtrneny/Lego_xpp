#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


CLASS FIN_pokladhd_zal_scr FROM drgUsrClass
EXPORTED:
  var     oinf
  method  init, eventHandled, itemMarked

  * osoby
  inline access assign method osoby_pri_zal() var osoby_pri_zal
    return if(osoby->lpri_Zal, 172, 0)

  inline access assign method osoby_kmenStrPr() var osoby_kmenStrPr
    msprc_mo->(dbSeek(osoby->nosCisPrac,,'MSPRMO09'))
    cnazpol1->(dbSeek(msprc_mo->ckmenStrPr,,'CNAZPOL1'))
    return msprc_mo->ckmenStrPr +cnazpol1->cnazev

  * pokza_za
  inline access assign method pokza_nazPoklad() var pokza_nazPoklad
    pokladms->(dbSeek(pokza_za->npokladna,,'POKLADM1'))
    return pokladms->cnazPoklad

  inline access assign method pokza_minus() var pokza_minus
    return if(pokza_za->(eof()),0,MIS_MINUS)

  inline access assign method pokza_equal() var pokza_equal
    return if(pokza_za->(eof()),0,MIS_EQUAL)

  inline access assign method pokza_zusZal() var pokza_zusZal
    return (pokza_za->nPrij_ZAL - pokza_za->nVrac_ZAL)

  * pokladhd
  inline access assign method typPohybu() var typPohybu
    return if(pokladhd->ntypdok = 1, MIS_PLUS , ;
           if(pokladhd->ntypdok = 2, MIS_MINUS, MIS_BOOKOPEN))

HIDDEN
   var   pri_zal
ENDCLASS


method FIN_pokladhd_zal_scr:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('osoby'   )
  drgDBMS:open('msprc_mo')
  drgDBMS:open('cnazpol1')
  drgDBMS:open('pokladms')
  drgDBMS:open('c_typpoh')

  ::pri_zal := 'A'
  ::oinf    := fin_datainfo():new('POKLADHD')

  osoby->(ads_setAof("lpri_zal = .t."),dbGoTop())
return self


method FIN_pokladhd_zal_scr:eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl, msg := ::drgDialog:oMessageBar

  do case
  case(nEvent = xbeBRW_ItemMarked)
    msg:WriteMessage(,0)
    return .f.

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
    return .t.

  CASE nEvent = drgEVENT_FORMDRAWN
     return .T.

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method fin_pokladhd_zal_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'osoby','ab',if(cfile = 'pokza_za','b', ''))

    if( 'a' $ rest)
      ky := strzero(osoby->ncisOsoby,6)
      pokza_za->(AdsSetOrder('POKIN_02'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

    if ('b' $ rest)
      ky := strzero(pokza_za->npokladna,3) +strzero(pokza_za->nosCisPrac,5)
      pokladhd->(AdsSetOrder('POKLAD10'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

    c_typpoh->(dbseek(upper(pokladhd->culoha) +upper(pokladhd->ctypdoklad) +upper(pokladhd->ctyppohybu),,'C_TYPPOH05'))
    drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
  endif
return self
