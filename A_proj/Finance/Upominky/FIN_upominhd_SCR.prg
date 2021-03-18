#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
#include "..\FINANCE\FIN_finance.ch"


**
** CLASS for FIN_upominhd_SCR **************************************************
CLASS FIN_upominhd_SCR FROM drgUsrClass
EXPORTED:
  var     lnewRec
  *
  method  init, drgDialogStart, itemMarked
  METHOD  onSave

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  method  postDelete
ENDCLASS


METHOD FIN_upominhd_SCR:init(parent)

  drgDBMS:open('fakvyshd')

  ::drgUsrClass:init(parent)
  ::lnewRec := .f.
RETURN self


METHOD FIN_upominhd_SCR:onSave(lOk,isAppend,oDialog)
RETURN .F.

METHOD FIN_upominhd_SCR:drgDialogStart(drgDialog)
RETURN


METHOD FIN_upominhd_SCR:itemMarked()
  local cKy := StrZero(UPOMINHD ->nCISUPOMIN,10)

  upominit->(mh_ordSetScope(cKy))
RETURN SELF


method fin_upominhd_scr:postDelete()
  local  nsel, nodel := .f.
  local  cisUpomin   := padc(alltrim(str(upominhd->ncisUpomin)),28)

  nsel := ConfirmBox( ,'Požadujete zrušit upomínku _' + CRLF + cisUpomin +CRLF +upominhd->cnazev, ;
                       'Zrušení upomínky ...' , ;
                        XBPMB_YESNO                     , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
     FIN_upominhd_cpy(self)
     nodel := .not. FIN_upominhd_del(self)
  endif

  if nodel
    ConfirmBox( ,'Upomínku _' +alltrim(str(upominhd->ncisUpomin)) +'_' +' nelze zrušit ...', ;
                 'Zrušení upomínky ...' , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel