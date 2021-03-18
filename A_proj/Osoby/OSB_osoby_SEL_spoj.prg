#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  OSOBY
** CLASS OSB_osoby_SEL_spoj ***************************************************
CLASS OSB_OSOBY_SEL_spoj FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, itemMarked, itemSelected
  *
  var     pa_hlavVazba

  * browColumn
   inline access assign method is_hlavVazba()  var is_hlavVazba
     local pa := ::pa_hlavVazba
     return if( ascan( pa, spojeniWs->(recNo())) <> 0, MIS_ICON_CHECK, 0 )

  inline access assign method is_isZAM() var is_isZAM      // ? je v msPrc_mo
    return if( osoby->nis_ZAM = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isPER() var is_isPER      // ? je v personal
    return if( osoby->nis_PER = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isDOH() var is_isDOH      // ? je v dsPohyby
    return if( osoby->nis_DOH = 1, MIS_ICON_OK, 0 )

  inline access assign method is_isRPR() var is_isRPR      // ? je v rodPrisl
    return if( osoby->nis_RPR = 1, MIS_ICON_OK, 0 )


  inline method drgDialogEnd( drgDialog )
    spojeni->(ads_clearAof())
    return self


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

  inline method set_hlavVazba()
    if ascan( ::pa_hlavVazba, spojeniWs->(recNo())) = 0
      if allTrim( spojeniWs->czkrSpoj) = 'TEL_ZAM'
        ::pa_hlavVazba[1] := spojeniWs->(recno())
      else
        ::pa_hlavVazba[2] := spojeniWs->(recno())
      endif
      ::odbro_Spoj:oxbp:refreshAll()
    endif
    return .t.

HIDDEN
  var odbro_Spoj, ncisOsoby
ENDCLASS


*
********************************************************************************
METHOD OSB_osoby_SEL_spoj:eventHandled(nEvent, mp1, mp2, oXbp)
  local dc        := ::drgDialog:dialogCtrl
  local is_inSpoj := ( dc:oaBrowse = ::odbro_Spoj)

  do case
  case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

  case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick .and. is_inSpoj)
    ::set_hlavVazba()
    return .t.

  case nEvent = xbeP_Keyboard
    if( mp1 = xbeK_CTRL_ENTER .and. is_inSpoj, ::set_hlavVazba(), nil)

    do case
    case mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


METHOD OSB_osoby_SEL_spoj:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('OSOBY')
  *
  drgDBMS:open('vazSpoje')
  drgDBMS:open('spojeni' )
  *
  if select('spojeniW') = 0
    drgDBMS:open('spojeniWs',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  endif

  ::pa_hlavVazba := { 0, 0 }
  ::ncisOsoby    := parent:cargo
RETURN self


method OSB_osoby_SEL_spoj:drgDialogStart( drgDialog )
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }

  ::odbro_Spoj := drgDialog:odbrowse[2]
  ::quickFiltrs:init( self, pa_quick, 'Osoby' )

  if( ::ncisOsoby <> 0, osoby->(dbseek( ::ncisOsoby,,'OSOBY01')), nil )
return self


METHOD OSB_osoby_SEL_spoj:itemMarked()
  local  cf := "nOSOBY = %%", filtrs
  local  lDBApp

  filtrs         := format( cf, { isNull( osoby->sID, 0) })
  ::pa_hlavVazba := { 0, 0 }

  vazSpoje->( ads_setAof( filtrs ), dbgoTop())

  do while .not. vazSpoje->(eof())
    if spojeni->(dbseek( vazSpoje->spojeni,,'SPOJENI01'))
      lDBapp := .not. spojeniWs->( dbseek( strZero( osoby->ncisOsoby,10) +strZero(spojeni->ncisSpoj,10),,'spojeniW02'))

      mh_copyFld( 'spojeni', 'spojeniWs', lDBApp)

      spojeniWs->ncisOsoby  := osoby   ->ncisOsoby
      spojeniWs->spojeni    := vazSpoje->spojeni
      spojeniWs->lhlavVazba := vazSpoje->lhlavVazba

      if allTrim( spojeni->czkrSpoj) = 'TEL_ZAM'
        if( vazSpoje->lhlavVazba, ::pa_hlavVazba[1] := spojeniWs->(recno()), nil )
      else
        if( vazSpoje->lhlavVazba, ::pa_hlavVazba[2] := spojeniWs->(recno()), nil )
      endif
    endif

    vazSpoje->(dbskip())
  enddo

  spojeniWs->( dbsetScope(SCOPE_BOTH, osoby->ncisOsoby), dbgoTop())

  c_psc  ->(dbseek( osoby->cpsc      ,, 'C_PSC1'  ))
  c_staty->(dbseek( osoby->czkratStat,, 'C_STATY1'))
RETURN self


METHOD OSB_osoby_SEL_spoj:itemSelected()
*  DRGDIALOG FORM 'FIR_FIRMY_SCR' PARENT ::drgDialog DESTROY
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
RETURN self