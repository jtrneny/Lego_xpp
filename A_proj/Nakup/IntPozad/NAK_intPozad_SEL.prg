#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
** CLASS FOR NAK_INTPOZAD_SEL **************************************************
CLASS NAK_INTPOZAD_SEL FROM drgUsrClass
EXPORTED:
  var     d_bro, pa_vazRecs, cfiltr_ip_sel


  inline method init(parent)
    local nEvent,mp1,mp2,oXbp

    drgDBMS:open('intPozad')
    drgDBMS:open('firmy'   )

    ::cfiltr_ip_sel := ''
    ::pa_vazRecs    := {}

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    IF IsOBJECT(oXbp:cargo)
      ::drgGet        := oXbp:cargo
      ::pa_vazRecs    := parent:parent:udcp:pa_vazRecs
      ::cfiltr_ip_sel := parent:parent:udcp:cfiltr_ip_sel
    ENDIF

    if( .not. empty(::cfiltr_ip_sel), parent:set_prg_filter(::cfiltr_ip_sel, 'intpozad'), nil )

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    **  XbpDialog:titleBar := .F.
    drgDialog:dialog:drawingArea:bitmap  := 1016 // 1018
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

    if IsObject(::drgGet)
      aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      drgDialog:usrPos := {aPos[1],aPos[2] -24}
    endif
  return


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::recordSelected()

    CASE nEvent = drgEVENT_APPEND
*      ::recordEdit()

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

  inline method RecordSelected()
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  return self

  inline method drgDialogEnd(drgDialog)
    local  a_act_filtrs := aclone(drgDialog:a_act_filtrs)
    local  npos

    if (npos := ascan( a_act_filtrs, {|p| p[1] = 'intpozad' } )) <> 0
       ARemove( a_act_filtrs, npos )
       drgDialog:a_act_filtrs := aclone(a_act_filtrs)

       intPozad->( ads_clearAof())
    endif
  return self

HIDDEN:
  VAR     drgGet, setVyber
  VAR     in_file, pb_mark_doklad, pb_save_marked

ENDCLASS