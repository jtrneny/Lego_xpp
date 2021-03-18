#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Konfigurace - Naplánované úlohy
** CLASS for SYS_userstsk_IN ******************************************************
CLASS SYS_userseuc_IN FROM drgUsrClass
EXPORTED:
  METHOD  itemSelected
  METHOD  init, drgDialogStart, preValidate, postValidate
  METHOD  postAppend, onSave
  METHOD  checkItemSelected, deleteTSK


  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      Return .T.

    CASE nEvent = drgEVENT_DELETE
*      ::deleteFRM()
      Return .T.

    CASE nEvent = drgEVENT_APPEND
*      if( oXbp:ClassName() <> 'XbpCheckBox', ::SYS_forms_modi_CRD(.T.), NIL)
      Return .T.

    CASE nEvent = drgEVENT_APPEND2
*      if( oXbp:ClassName() <> 'XbpCheckBox', ::copy_CRD(), NIL)
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR     msg, dm, dctrl, df, ab, pushOk, defOpr

*  METHOD  verifyActions
ENDCLASS


METHOD SYS_userseuc_IN:init(parent)

  ::defOpr   := defaultDisUsr('Forms','CTYPFORMS')

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_OPRAVN')
  drgDBMS:open('USERSEUC')
*  drgDBMS:open('FILTRS',,,,, 'FILTRSs')

  * tady nevím jestli zap *
*  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


method SYS_userseuc_IN:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager


*  ::odrgCombo_MBLOCKFRM  := ::dm:has( 'FORMS->MBLOCKFRM' )
*  ::odrgCombo_MBLOC_USER := ::dm:has( 'FORMS->MBLOC_USER')

// * nevím  if( ::newRec, ::postAppend(), ::dm:refresh())
return self


* ok
method SYS_userseuc_IN:postAppend()
  local x, ovar, type, val, ok, file

  for x := 1 to ::dm:vars:size() step 1
    ok   := .f.
    ovar := ::dm:vars:getNth(x)
    type := valtype(ovar:value)
    file := lower(drgParse(ovar:name,'-'))

    do case
    case(type == 'N')  ;  val := 0
    case(type == 'C')  ;  val := ''
    case(type == 'D')  ;  val := ctod('  .  .  ')
    case(type == 'L')  ;  val := .f.
    case(type == 'M')  ;  val := ''
    endcase

    ovar:set(val)
    ovar:initValue := ovar:prevValue := ovar:value := val
  next
return .t.


method SYS_userseuc_IN:CheckItemSelected(drgCheck)

return


method SYS_userseuc_IN:itemSelected(new)
  local  mod
  *
  if ::selForm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  else
*    if(.not. empty(forms->cidForms), ::SYS_forms_modi_CRD(.F.), nil)
  endif
RETURN SELF




METHOD SYS_userseuc_IN:preValidate(drgVar)
  local  lOk := .T., odesc

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
  endif
RETURN lOk


method SYS_userseuc_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
    endif

*    ::verifyActions(.T.)
  endif
RETURN lOk


method SYS_userseuc_IN:deleteTSK
  local ok := .f.

*   ok := if( At('DIST', ::defOpr) > 0, .t., (forms->ctypforms = 'USER') )

   if ok
*     if forms->( dbRlock())
*       if drgIsYESNO(drgNLS:msg('Opravdu požadujete zrušit vybranou sestavu ?'))
*         forms->( dbDelete())
*         ::dctrl:oBrowse[1]:refresh(.T.)
*         ::verifyActions()
*         ::dctrl:oBrowse[2]:refresh(.T.)
*         ::dctrl:oBrowse[3]:refresh(.T.)
*       endif
*       forms->( dbUnlock())
*     endif
   else
     drgNLS:msg('Nemáte oprávnìní rušit !!!')
   endif

return


method SYS_userseuc_IN:onSave()
  LOCAL aUsers
  LOCAL n

  if( ::newRec, userseuc->( mh_append()), userseuc->(dbRlock()))
  ::dm:save()
  userseuc->cidTask := ::dm:get('userseuc->cidTask')



  ::changeFRM := .F.
  if(Empty(userseuc->cTypForms), userseuc->cTypForms := Left(userseuc->cIdTask,4), NIL)
  userseuc->nCisForms := Val(SubStr(userseuc->cIdTask,5))
  mh_WRTzmena( 'userseuc', ::newRec)
  userseuc->(dbUnlock())

RETURN .T.

/*
FUNCTION newIDtask(typ)
  local newID
  local filtr

  drgDBMS:open('USERSEUC',,,,,'USERSEUCa')
  filtr := Format("cIDtask = '%%'", {typ})
  USERSEUCa->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(USERSEUCa->cIDtask,5,6))+1, 6)
  USERSEUCa->(ads_clearaof(), dbCloseArea())

RETURN(newID)
*/