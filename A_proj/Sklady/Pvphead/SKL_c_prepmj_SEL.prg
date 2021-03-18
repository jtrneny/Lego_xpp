#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
** CLASS SKL_c_prepmj_sel ******************************************************
**           c_jednot
CLASS SKL_c_prepmj_sel FROM drgUsrClass
EXPORTED:

  inline access assign method cinfo_prepmj() var cinfo_prepmj
    local cky    := upper(c_jednot->czkratJedn)
    local retVal := ''

    if c_prepmj->( dbseek( cky,,'C_PREPMJ01'))
      retVal := allTrim( str( c_prepmj->npocVYCHmj))                       +' ' +c_prepmj->cvychoziMJ +' = ' + ;
                allTrim( str( c_prepmj->npocCILmj * c_prepmj->nkoefPRvc))  +' ' +c_prepmj->ccilovaMJ
    endif
  return retVal


  inline method drgDialogInit(drgDialog)
    local nEvent,mp1,mp2,oXbp

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)

    if isOBJECT(oXbp:cargo)
      ::drgGet := oxbp:cargo

      aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      drgDialog:usrPos := {aPos[1],aPos[2]-30}
    endif
  return self


  inline method init( parent )
    ::drgUsrClass:init(parent)
    return self


  inline method drgDialogStart(drgDialog)
    ::dm        := drgDialog:dataManager             // dataMananager
    ::q_oBrowse := drgDialog:odBrowse[1]
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .t.
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        return .t.
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
    return .f.

  inline method itemSelected()
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
    return self

hidden:
  var  dm, drgGet, q_oBrowse
ENDCLASS