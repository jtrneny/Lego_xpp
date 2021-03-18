#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  trvZavHd
** CLASS MZD_trvZavHd_SEL *****************************************************
CLASS MZD_trvZavHd_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )

    ::drgUsrClass:init(parent)
    return self

  inline method drgDialogStart(drgDialog)
    ::dm        := drgDialog:dataManager             // dataMabanager
    ::q_oBrowse := drgDialog:odBrowse[1]
    return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .t.
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
    return .f.

  inline method itemSelected()

    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
    return self

hidden:
  var  dm, q_oBrowse
ENDCLASS