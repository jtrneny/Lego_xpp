/*==============================================================================
  VYR_Vykresy_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
* Evidence výkresù
********************************************************************************
CLASS VYR_Vykresy_scr FROM drgUsrClass
EXPORTED:

INLINE METHOD Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

INLINE METHOD drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

INLINE METHOD ItemMarked()
  VyrPOL->( mh_SetScope( Upper( Vykresy->cCisVyk)))
RETURN self

  METHOD  EventHandled, Vykres_Delete
ENDCLASS

********************************************************************************
METHOD VYR_Vykresy_scr:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      ::Vykres_Delete()
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

 ********************************************************************************
METHOD VYR_Vykresy_scr:Vykres_delete()
  Local cMsg  := '< Zrušení výkresu >;; Chcete zrušit výkres èíslo [ ' + AllTrim(Vykresy->cCisVyk) + ' ] ?'

  IF VyrPOL->( dbSEEK( Upper( cCisVyk),, 'VYRPOL3'))
    cMsg := '< Zrušení výkresu >;; Tento výkres je pøiøazen vyrábìné položce [ ' + AllTrim(VyrPOL->cVyrPOL) + ' ] ;;' + ;
             'Chcete zrušit výkres èíslo [ ' + AllTrim(Vykresy->cCisVyk) + ' ] ?'
  ENDIF
  *
  IF drgIsYESNO(drgNLS:msg( cMsg) )
    IF Vykresy->( sx_RLock())
      Vykresy->( dbDelete(), dbUnlock())
      ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
    ENDIF
  ENDIF
RETURN self



********************************************************************************
* Karta Výkresu
********************************************************************************
CLASS VYR_Vykresy_crd FROM drgUsrClass
EXPORTED:
  VAR     lNewRec
  METHOD  Init, Destroy, drgDialogStart, eventHandled, postValidate
  METHOD  OnSave
HIDDEN
  VAR     dm, dc
  METHOD  newPorVyk
ENDCLASS

********************************************************************************
METHOD VYR_Vykresy_crd:Init(parent)

  ::drgUsrClass:init(parent)
  ::lNewRec := !( parent:cargo = drgEVENT_EDIT)
  *
  drgDBMS:open('VYKRESY'  )
  drgDBMS:open('VYKR_SET' )
  drgDBMS:open('VYKRESYw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  if ::lNewRec
    VYKRESYw->( dbAppend())
    if VYKR_SET->( dbSeek( Upper( usrName),, 'VYKR_SET1'))
      mh_COPYFLD('VYKR_SET', 'VYKRESYw')
    endif
    VYKRESYw->nPorVyk  := ::newPorVyk()
  else
    mh_COPYFLD('VYKRESY', 'VYKRESYw', .T.)
  endif

RETURN self

********************************************************************************
METHOD VYR_Vykresy_crd:newPorVyk()
  Local newPorVyk

  drgDBMS:open('VYKRESY',,,,,'VYKRESYa' )
  VYKRESYa->(ordSetFocus('VYKRES2'), dbGoBottom())
  newPorVyk := VYKRESYa->nPorVyk + 1
RETURN newPorVyk

********************************************************************************
METHOD VYR_Vykresy_crd:destroy()
  ::drgUsrClass:destroy()
  ::lNewRec      := ;
  Nil
RETURN self

********************************************************************************
METHOD VYR_Vykresy_crd:drgDialogStart(drgDialog)

  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::drgDialog:oForm:setNextFocus( 'VYKRESYw->cCisVyk',, .t. )
RETURN self

********************************************************************************
METHOD VYR_Vykresy_crd:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_Vykresy_crd:PostValidate( oVar)
  LOCAL xVar := oVar:get()
  LOCAL lChanged := oVar:changed(), lOK := .T.
  LOCAL lValid := ( ::lNewREC .or. lChanged )
  LOCAL cNAMe := UPPER(oVar:name), cKey, cMsg

  IF lValid
    DO CASE
    CASE cName = 'Vykresyw->nPorVyk'
      IF( lOK := ControlDUE( oVar) )
        IF VYKRESYa->( dbSeek( xVar,, 'VYKRES2'))
          cMsg := 'DUPLICITA !;; Výkres s tímto poøadovým èíslem již existuje !'
          drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
          lOK := .F.
        ENDIF
      ENDIF

    CASE cName = 'Vykresyw->cCisVyk'
      lOK := ControlDUE( oVar)

    CASE cName = 'Vykresyw->cModVyk'
      *
      IF ( lOK := ControlDUE( oVar))
        cKey := Upper( ::dm:get('Vykresyw->cCisVyk') + Upper(xVar))
        IF VYKRESYa->( dbSeek( cKey,, 'VYKRES1'))
          cMsg := 'DUPLICITA !;; Výkres v této modifikaci již existuje !'
          drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
          lOK := .F.
        ENDIF
      ENDIF
      *
    OTHERWISE
    ENDCASE
  ELSE
  ENDIF

RETURN lOK

********************************************************************************
METHOD VYR_Vykresy_crd:OnSave(isBefore, isAppend)

  IF ! ::dc:isReadOnly
    ::dm:save()
    IF( ::lNewREC, VYKRESY->( DbAppend()), NIL )
    IF VYKRESY->(sx_RLock())
      mh_COPYFLD('VYKRESYw', 'VYKRESY' )
      VYKRESY->( dbUnlock())
      ::drgDialog:parent:dialogCtrl:oaBrowse:oxbp:refreshAll()
    ENDIF
  ENDIF
RETURN .T.



*****************************************************************
* VYR_VYKRESY_SEL ...
*****************************************************************
CLASS VYR_VYKRESY_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
  METHOD  doAppend

ENDCLASS

*****************************************************************
METHOD VYR_VYKRESY_SEL:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

**********************************************************************
METHOD VYR_VYKRESY_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
*  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    ::doAppend( nEvent)

  CASE nEvent = drgEVENT_FORMDRAWN
  CASE nEvent = drgEVENT_DELETE

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

********************************************************************************
METHOD VYR_VYKRESY_SEL:doAppend( nEvent)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_VYKRESY_CRD', ::drgDialog)
  oDialog:cargo := nEvent
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
    oDialog:dataManager:save()
    IF( oDialog:dialogCtrl:isAppend, VYKRESY->( DbAppend()), Nil )
    IF VYKRESY->(sx_RLock())
       mh_COPYFLD('VYKRESYw', 'VYKRESY' )
       VYKRESY->( dbUnlock())
       ::drgDialog:dialogCtrl:browseRefresh()
    ENDIF
  ENDIF
  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.