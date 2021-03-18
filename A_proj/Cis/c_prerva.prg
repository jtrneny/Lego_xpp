#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for c_nempas **********************************************************
CLASS c_prerva FROM drgUsrClass
EXPORTED:
  METHOD  init
//  METHOD  itemmarked
  METHOD  drgDialogStart
  METHOD  postLastField
  METHOD  ebro_afterAppend, ebro_afterAppendBlankRec, ebro_saveEditRow



  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs
    LOCAL  msg      := ::drgDialog:oMessageBar

    DO CASE
    CASE (nEvent = xbeBRW_ItemMarked)
      IF(IsObject(::drgGet), NIL, msg:WriteMessage(,0))
      ::nState := 0
      ::drgDialog:dialogCtrl:isAppend := (::nState = 2)
      RETURN .F.

  * zmìna období - budeme reagovat
//    case(nevent = drgEVENT_OBDOBICHANGED)
//      ::setSysFilter()
//      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR  drgGet, brow
  VAR  nState       // 0 - inBrowse  1 - inEdit  2 - inAppend
  VAR  o_EBro, dm
  VAR  nPREs, cPREs

/*
  * filtr
  inline method setSysFilter( ini )
    local rok, obdobi
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok    := uctOBDOBI:MZD:NROK
    obdobi := uctOBDOBI:MZD:NOBDOBI
    cfiltr := Format("nROK = %% .and. nOBDOBI = %%", {rok,obdobi} )

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'c_nempas')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('c_nempas', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'c_nempas')

      c_nempas->( ads_setaof(filtrs), dbGoTop())
      ::brow:oxbp:refreshAll()
    endif
  return self
*/


ENDCLASS


METHOD c_prerva:init(parent)

  ::drgUsrClass:init(parent)

  ::cPREs  := c_prerus->ckodprer
  ::nPREs  := c_prerus->nkodprer

  //  ::setSysFilter(.t.)
RETURN self


method c_prerva:drgDialogStart( drgDialog )
  local filtr

  ::brow   := drgDialog:dialogCtrl:oBrowse
  ::o_Ebro := drgDialog:dialogCtrl:oBrowse[1]
  ::dm     := drgDialog:dataManager

  filtr := Format("ckodprer = '%%'", {::cPREs})
  c_prerva->( ads_setaof(filtr), dbGoTop())

return self

/*
*******************************************************************************
METHOD c_prerva:drgDialogStart(drgDialog)

  ::o_Ebro := drgDialog:dialogCtrl:oBrowse[1]
  ::dm     := drgDialog:dataManager

RETURN self
*/


METHOD c_prerva:ebro_afterAppend( ebro)

  ::dm:set('c_prerva->cKodPrer', ::cPREs)

//  if c_carKod->( mh_SEEK( .T., 3, .T.))
//    ::dm:set( 'cecarKod->cZkrCarKod', c_carKod->czkrCarKod )
//  endif

RETURN self


METHOD c_prerva:ebro_afterAppendBlankRec(eBro)

  c_prerva->cTask    := 'DOH'
  c_prerva->cKodPrer := ::cPREs
  c_prerva->nKodPrer := ::nPREs

return .t.

********************************************************************************



METHOD c_prerva:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_ZAMEST na posledním PRVKU //

*  IF lZMENa .and. If( ::nState == 2, ADDrec('C_ZAMEST'), REPLrec( 'C_ZAMEST'))
*    ::dataManager:save()
*  ENDIF

*  ::drgDialog:oForm:setNextFocus(1,, .T.)
*  C_ZAMEST ->( DbUnLock())
RETURN .T.



********************************************************************************
METHOD c_prerva:ebro_saveEditRow
  ::dm:save()
RETURN .T.