#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
****** CLASS for FIR_firmybcd_IN **********************************************
CLASS FIR_firmybcd_IN FROM drgUsrClass
EXPORTED:
  METHOD  init

  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
  method  ebro_saveEditRow

  VAR     newRec

  inline access assign method nazCarKod() var nazCarKod
    c_carkod->(dbSeek( upper( firmybcd->cZkrCarKod),,'C_CARK1'))
    return c_carkod->CNazCarKod


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL appFocus
    LOCAL oA

    DO CASE
    CASE nEvent = drgEVENT_APPEND
      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        ::msg:writeMessage('Pøidávat lze jen u položek úèetního pøedpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('Pøidávat lze jen u položek úèetního pøedpisu ...')
        RETURN .T.
      else
        RETURN .F.
      endif

    CASE nEvent = drgEVENT_DELETE
      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        ::msg:writeMessage('Rušit lze jen položky úèetního pøedpisu ...',DRG_MSG_WARNING)
        drgMSGBox('Rušit lze jen položky úèetního pøedpisu ...')
        RETURN .T.
      else
        RETURN .F.
      endif


*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
 *       RETURN .F.
 *     EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  VAR     nFile, cFile, dm, msg

ENDCLASS


METHOD fir_firmybcd_in:init(parent)
  ::drgUsrClass:init(parent)

  ::newRec := .F.

  drgDBMS:open('c_carkod')
RETURN self


METHOD FIR_firmybcd_IN:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD FIR_firmybcd_IN:drgDialogStart(drgDialog)

  ::dm     := ::drgDialog:dataManager           // dataMabanager
  ::msg    := drgDialog:oMessageBar             // messageBar
RETURN self


method fir_firmybcd_in:ebro_saveEditRow(o_ebro)
  firmybcd->ncisFirmy := firmy->ncisFirmy
return .t.


METHOD FIR_firmybcd_IN:preValidate(drgVar)
  local lOk := .T.

  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
    ::dm:set('ucetprit->npoluctpr', ucetprit->(sx_keyCount()) +1)
  endif
RETURN lOk


method FIR_firmybcd_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case(name = 'ucetprit->ctypuct')
    ok := ::selTypyUct()
  endcase
return ok



