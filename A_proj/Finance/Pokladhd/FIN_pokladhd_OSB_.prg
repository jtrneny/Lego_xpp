#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


CLASS FIN_pokladhd_osb_sel FROM drgUsrClass
EXPORTED:
  method  init, eventHandled, itemMarked, comboItemSelected

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

HIDDEN
   var   pri_zal
ENDCLASS


method FIN_pokladhd_osb_sel:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('osoby'   )
  drgDBMS:open('msprc_mo')
  drgDBMS:open('cnazpol1')
  drgDBMS:open('pokladms')

  ::pri_zal := 'A'
  osoby->(ads_setAof("lpri_zal = .t."),dbGoTop())
return self


method FIN_pokladhd_osb_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl, msg := ::drgDialog:oMessageBar

  do case
  case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
    if osoby->(sx_rlock())
      osoby->lpri_zal := .not. osoby->lpri_zal
      osoby->(dbunlock())
      dc:oBrowse[1]:refresh(.t.)
    endif
    return .t.

  case(nEvent = xbeBRW_ItemMarked)
    msg:WriteMessage(,0)
    return .f.

  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    if osoby->lpri_zal
      PostAppEvent(xbeP_Close,drgEVENT_SELECT,,::drgDialog:dialog)
    else
      msg:writeMessage('Osoba není oprávnìna pøevzít/zúètovat zálohu ...',DRG_MSG_ERROR)
      return .f.
    endif

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_DELETE
    return .t.

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method FIN_pokladhd_osb_sel:itemMarked()
  local cKy := strZero(osoby->ncisOsoby,6)

  pokza_za->(dbSetScope(SCOPE_BOTH,cKy), dbGoTop())
return self


method FIN_pokladhd_osb_sel:comboItemSelected(mp1, mp2, o)
  local  dc := ::drgDialog:dialogCtrl

  if ::pri_zal <> mp1:value
    ::pri_zal := mp1:value

    if(::pri_zal = 'A', osoby->(ads_setAof("lpri_zal = .t.")), osoby->(ads_clearAof()))
    osoby->(dbGoTop())

    dc:oBrowse[1]:refresh(.t.)
    SetAppFocus(dc:oBrowse[1]:oXbp)
  endif
return .t.
