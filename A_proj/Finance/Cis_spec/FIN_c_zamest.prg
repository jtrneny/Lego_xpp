#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_c_zamest_BC(nCOLUMn)
  LOCAL  xRETval := ''

  DO CASE
  * C_ZAMEST *
  CASE nCOLUMn ==  1  ;  xRETval := IF( C_ZAMEST ->lPRI_ZAL, 172, 0 )
                         CNAZPOL1 ->( DbSeek(C_ZAMEST ->cNAZPOL1,,'CNAZPOL1'))

  * POKZA_ZA *
  CASE nCOLUMn == 22  ;  POKLADMS ->( DbSeek( POKZA_ZA ->nPOKLADNA,,'POKLADM1'))
                         xRETval := POKLADMS ->cNAZPOKLAD
  CASE nCOLUMn == 24  ;  xRETval := IF( POKZA_ZA ->(Eof()), 0,MIS_MINUS)
  CASE nCOLUMn == 26  ;  xRETval := IF( POKZA_ZA ->(Eof()), 0,MIS_EQUAL)
  CASE nCOLUMn == 27  ;  xRETval := (POKZA_ZA ->nPRIJ_ZAL -POKZA_ZA ->nVRAC_ZAL)
  ENDCASE
RETURN(xRETVAL)



**
** CLASS for FIN_c_zamest ******************************************************
CLASS FIN_c_zamest FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogInit
  METHOD  postLastField

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

    CASE nEvent = drgEVENT_EDIT
      IF IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      ELSE
        DbSelectArea('C_ZAMEST')
        ::nState := 1
        ::drgDialog:oForm:setNextFocus('C_ZAMEST->nOSCISPRAC',, .T. )
        RETURN .T.
      ENDIF

    CASE nEvent = drgEVENT_APPEND .and. .not. IsObject(::drgGet)
      nRECs := C_ZAMEST ->( RecNo())
               C_ZAMEST ->( DbGoTo(-1))
               ::drgDialog:dataManager:refresh()
               C_ZAMEST ->( DbGoTo(nRECs))

      ::nState := 2
      ::drgDialog:dialogCtrl:isAppend := (::nState = 2)
      DbSelectArea('C_ZAMEST')
      ::drgDialog:oForm:setNextFocus('C_ZAMEST->nOSCISPRAC',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      msg:writeMessage('Zrušení položky ÈÍSELNÍKU ZAMÌSTNANCÚ, není povoleno ...',DRG_MSG_WARNING)
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

HIDDEN:
  VAR    drgGet
  VAR    nState       // 0 - inBrowse  1 - inEdit  2 - inAppend

ENDCLASS


METHOD FIN_c_zamest:init(parent)
  Local nEvent,mp1,mp2,oXbp

  ::drgUsrClass:init(parent)
  ::drgGet  := NIL
  ::nState  := 0

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

  drgDBMS:open('CNAZPOL1')
  drgDBMS:open('POKLADMS')
RETURN self


METHOD FIN_c_zamest:itemMarked()
  local cKy := strZero(c_zamest->nosCisPrac,5)

  pokza_za->(dbSetScope(SCOPE_BOTH,cKy), dbGoTop())
RETURN SELF


METHOD FIN_c_zamest:drgDialogInit(drgDialog)
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


METHOD FIN_c_zamest:postLastField(drgVar)
  Local  dc     := ::drgDialog:dialogCtrl
  Local  name   := drgVAR:name
  Local  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme C_ZAMEST na posledním PRVKU //

  IF lZMENa .and. If( ::nState == 2, ADDrec('C_ZAMEST'), REPLrec( 'C_ZAMEST'))
    ::dataManager:save()
  ENDIF

  ::drgDialog:oForm:setNextFocus(1,, .T.)
  C_ZAMEST ->( DbUnLock())
RETURN .T.


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************