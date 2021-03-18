#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  DRUHYMZD
** CLASS MZD_druhyMzd_SEL *****************************************************
CLASS MZD_druhyMzd_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )
    local rok, obdobi, rokobd, cfiltr

    rok    := uctOBDOBI:MZD:NROK
    obdobi := uctOBDOBI:MZD:NOBDOBI
    rokObd := (rok*100)+obdobi

    ::drgUsrClass:init(parent)

    drgDBMS:open('druhyMzd',,,,,'druhyMz_S')

*    cfiltr := Format("nROKOBD = %%", {rokObd})
*    ::drgDialog:set_prg_filter( cfiltr, 'druhyMz_S')
  return self

  inline method drgDialogStart(drgDialog)
    ::dm        := drgDialog:dataManager             // dataMabanager
    ::q_oBrowse := drgDialog:odBrowse[1]

    drgDialog:set_uct_ucetsys_inlib()
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
