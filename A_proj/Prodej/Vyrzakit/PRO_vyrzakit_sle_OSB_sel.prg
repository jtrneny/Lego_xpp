#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  OSOBY
** CLASS PRO_vyrzakit_sle_OSB_sel *********************************************
CLASS PRO_vyrzakit_sle_OSB_sel FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init
  method  drgDialogStart
  METHOD  EventHandled
  METHOD  itemMarked
  METHOD  itemSelected

  * browColumn
  inline access assign method is_isZAM() var is_isZAM      // ? je v msPrc_mo
    return if( osoby->nis_ZAM = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isPER() var is_isPER      // ? je v personal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isDOH() var is_isDOH      // ? je v dsPohyby
    return if( osoby->nis_DOH = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isRPR() var is_isRPR      // ? je v rodPrisl
    return if( osoby->nis_RPR = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isVYR() var is_isVYR      // ? je v výrobì
    return if( osoby->nis_VYR = 1, MIS_ICON_OK, 0 )


  inline  method osb_osoby_nova(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method osb_osoby_oprava(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.
ENDCLASS


method PRO_vyrzakit_sle_OSB_sel:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

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


method PRO_vyrzakit_sle_OSB_sel:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('OSOBY')
RETURN self


method PRO_vyrzakit_sle_OSB_sel:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby   ve skupnì prodej          ', 'nis_PRO = 1' }, ;
  { 'Osoby   ve skupnì výroba          ', 'nis_VYR = 1' }, ;
  { 'Osoby   ve skupnì obchod          ', 'nis_OBH = 1' }  }

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
return self


METHOD PRO_vyrzakit_sle_OSB_sel:itemMarked()
  c_psc  ->(dbseek( osoby->cpsc      ,, 'C_PSC1'  ))
  c_staty->(dbseek( osoby->czkratStat,, 'C_STATY1'))
RETURN self


METHOD PRO_vyrzakit_sle_OSB_sel:itemSelected()
*  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT ::drgDialog DESTROY
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
RETURN self