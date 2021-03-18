#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


FUNCTION UCT_c_skupuc_CB()
  LOCAL cC := AllTrim(C_SKUPUc ->cSKUPUCT)
  C_UCTOSN ->( Ads_SetAOF( "AT('" +cC +"', C_UCTOSN->cSKUPUCT) <> 0"),  dbGoTop())
RETURN  IF( Empty(C_UCTOSN ->cSKUPUCT), 0, 172 )



**
** CLASS for FRM UCT_c_skupuc ***********************************************
CLASS UCT_c_skupuc FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart, eventHandled

  METHOD  postLastField
HIDDEN:
  VAR     dm, dc, df, brow, state      // 0 - inBrowse  1 - inEdit  2 - inAppend
ENDCLASS


METHOD UCT_c_skupuc:init(parent)
  ::drgUsrClass:init(parent)

  ::state   := 0

  drgDBMS:open('C_SKUPUC')
  drgDBMS:open('C_UCTOSN')
  // relace //
RETURN self


method UCT_c_skupuc:drgDialogStart(drgDialog)
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::brow     := ::dc:oBrowse[1]
return self


METHOD UCT_c_skupuc:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL  nRECs
  LOCAL  lUSEd
  LOCAL  dc       := ::drgDialog:dialogCtrl

  DO CASE
  CASE (nEvent = xbeBRW_ItemMarked)
    ::state := 0
    RETURN .F.

  CASE nEvent = drgEVENT_EDIT
    ::state := 1
    ::drgDialog:oForm:setNextFocus('C_SKUPUC->cSKUPUCT',, .T. )
    RETURN .T.

  CASE nEvent = drgEVENT_APPEND
    ::drgDialog:dataManager:refreshAndSetEmpty( 'c_skupuc' )

    ::state := 2
    ::drgDialog:oForm:setNextFocus('C_SKUPUC->cSKUPUCT',, .T. )
    RETURN .T.

  CASE nEvent = drgEVENT_DELETE
    lUSEd := (Eval(dc:oaBrowse:oXbp:getColumn(1):dataLink) = 172)

    IF     lUSEd ; drgMsgBox('Skupina je POUŽITA, nelze zrušit ...')
    ELSEIF drgIsYESNO( 'Zrušit skupinu úètù ... ' +AllTrim(C_SKUPUc ->cSKUPUCT) +' ... ?')
      IF( C_SKUPUC ->( DbRLock()), ;
          C_SKUPUC ->(DbDelete()), ;
          drgMsgBox('Nelze uložit zmìny, BLOKOVÁNO uživatelem ...') )
       dc:oaBrowse:oXbp:refreshAll()
    ENDIF

    C_SKUPUC ->( DbUnlock())
    RETURN .T.

  CASE nEvent = xbeP_Keyboard
    IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::drgDialog:oForm:setNextFocus(1,, .T. )
       RETURN .T.
    ELSE
      RETURN .F.
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


METHOD UCT_c_skupuc:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_SKUPUC na posledním PRVKU //

  do case
  case('C_SKUPUC->cNAZSKUPUC'  = name)
    if(c_skupuc->(eof()),::state := 2,nil)

    if lZMENa .and. If( ::state == 2, ADDrec('C_SKUPUC'), REPLrec( 'C_SKUPUC'))
      ::dataManager:save()
      C_SKUPUC ->cUSERABB  := SYSCONFIG('SYSTEM:cUSERABB')
      C_SKUPUC ->dDATZMENY := DATE()

      ::brow:refresh(.t.)
      PostAppEvent(xbeBRW_ItemMarked,,,::brow:oxbp)
    endif
  endcase

  ::drgDialog:oForm:setNextFocus(1,, .T.)
  C_SKUPUC ->( DbUnLock())
RETURN .T.