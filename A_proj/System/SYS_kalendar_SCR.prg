#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

**
** CLASS for SYS_config_scr *************************************************
CLASS SYS_kalendar_SCR FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  itemMarked, itemSelected
  METHOD  postValidate
  METHOD  onSave
  METHOD  postLastField
  METHOD  newKalendar

  VAR     crok
  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .T.

*    CASE nEvent = drgEVENT_APPEND
*      ::itemSelected(.T.)
*      Return .T.
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

HIDDEN:
  VAR  typ

ENDCLASS


METHOD SYS_kalendar_SCR:init(parent)
  LOCAL cULOHA
  LOCAL cFiltr

  ::drgUsrClass:init(parent)
  cParm    := drgParseSecond(::drgDialog:initParam)
  ::typ    := cParm
  ::crok   := AllTrim(Str( Year( date())))

  drgDBMS:open('kalendar')
  drgDBMS:open('c_svatky')
  drgDBMS:open('c_svatjm')

  cFiltr := Format("nROK = %%", { Val(::crok)})
  Kalendar->( ads_setAof( cFiltr), dbgoTop())


RETURN SELF


METHOD SYS_kalendar_SCR:drgDialogStart(drgDialog)
RETURN self


METHOD SYS_kalendar_SCR:itemMarked()


RETURN self


METHOD SYS_kalendar_SCR:itemSelected()


RETURN self


METHOD SYS_kalendar_SCR:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL lOK := .T.

  if changed
    do case
    case name = 'm->crok'
      cFiltr := Format("nROK = %%", { Val( value)})
      Kalendar->( ads_setAof( cFiltr), dbgoTop())
    endcase
  endif

  if changed
    ::onSave()
    ::drgDialog:odbrowse[1]:refresh()
  endif

RETURN lOk


METHOD SYS_kalendar_SCR:postLastField()

  ::onSave()

RETURN .T.


METHOD SYS_kalendar_SCR:onSave()
  LOCAL  val, file, key

  ::drgDialog:dataManager:save()             // dataMabanager

RETURN .T.


METHOD SYS_kalendar_SCR:newKalendar()

  genKalendar( Val(::cROK), .t.)

RETURN self

