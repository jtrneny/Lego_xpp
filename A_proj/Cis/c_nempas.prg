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
CLASS c_nempas FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogInit
  METHOD  postLastField


  inline method drgDialogStart( drgDialog )

    ::brow := drgDialog:dialogCtrl:oBrowse
  return self

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
    case(nevent = drgEVENT_OBDOBICHANGED)
      ::setSysFilter()
      return .t.

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR    drgGet, brow
  VAR    nState       // 0 - inBrowse  1 - inEdit  2 - inAppend

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

ENDCLASS


METHOD c_nempas:init(parent)
  Local nEvent,mp1,mp2,oXbp

  ::drgUsrClass:init(parent)
  ::drgGet     := NIL
  ::nState     := 0

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

  ::setSysFilter(.t.)
RETURN self


METHOD c_nempas:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  IF IsObject(::drgGet)
    drgDialog:hasIconArea := drgDialog:hasActionArea := ;
    drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
    XbpDialog:titleBar    := .F.

    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN self


METHOD c_nempas:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_ZAMEST na posledním PRVKU //

  IF lZMENa .and. If( ::nState == 2, ADDrec('C_ZAMEST'), REPLrec( 'C_ZAMEST'))
*    ::dataManager:save()
  ENDIF

*  ::drgDialog:oForm:setNextFocus(1,, .T.)
*  C_ZAMEST ->( DbUnLock())
RETURN .T.