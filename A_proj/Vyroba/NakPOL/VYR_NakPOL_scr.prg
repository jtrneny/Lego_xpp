#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_NakPOL_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked

  METHOD  NakPOL_CENIK        // editace Ceníku zboží
  METHOD  NakPOL_IKUSOV       // Inverzní kusovník
  METHOD  NakPOL_PrepoctyMJ   // Pøepoèty mìrných jednotek

ENDCLASS

*
********************************************************************************
METHOD VYR_NakPOL_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('NAKPOL'  )
  drgDBMS:open('KUSOV'   )
  drgDBMS:open('CENZBOZ' )
  drgDBMS:open('C_TYPMAT')
  NakPOL->( DbSetRelation( 'C_TYPMAT', { || Upper(NakPOL->cTypMat) } ,'Upper(NakPOL->cTypMat)' ))
RETURN self

********************************************************************************
METHOD VYR_NakPOL_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN
*
********************************************************************************
METHOD VYR_NakPOL_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  DO CASE
  CASE  nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    drgMsgBox(drgNLS:msg('Skladovou položku lze založit pouze v ceníku zboží !'),, ::drgDialog:dialog)
    RETURN .T.
  CASE nEvent = drgEVENT_DELETE
    NakPOL_OnDELETE()
    ::drgDialog:dialogCtrl:oaBrowse:refresh()
    RETURN .T.
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_NakPOL_SCR:ItemMarked()
*  ::drgDialog:dataManager:Refresh()
  CenZboz->( dbSEEK( UPPER( NakPOL->cCisSklad) + UPPER(NakPOL->cSklPol),,'CENIK03'))
RETURN SELF

METHOD VYR_NakPOL_SCR:NakPOL_CENIK()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'SKL_CENZBOZ_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Inverzní kusovník k nakupované položce
********************************************************************************
METHOD VYR_NakPOL_SCR:NakPOL_IKUSOV()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_IKUSOV_SCR' CARGO 0 PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
********************************************************************************
METHOD VYR_NakPOL_SCR:NakPOL_PrepoctyMJ()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('C_PrepMJ,NAKPOL->cZkratJEDN', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
RETURN self

********************************************************************************
* VYR_NAKPOL_SEL ...
********************************************************************************
CLASS VYR_NAKPOL_SEL FROM drgUsrClass

EXPORTED:
  VAR     nRec
  METHOD  Init, EventHandled, drgDialogStart
  METHOD  NakPOL_scr
ENDCLASS

********************************************************************************
METHOD VYR_NAKPOL_SEL:init(parent)

  ::drgUsrClass:init(parent)
  ::nRec := parent:cargo_usr
  drgDBMS:open('CENZBOZ' )
  drgDBMS:open('C_TYPMAT')

  NakPOL->( DbSetRelation( 'Cenzboz' , {|| Upper(NakPOL->cSklPol) } ,'Upper(NakPOL->cSklPol)' ))
  NakPOL->( DbSetRelation( 'C_TYPMAT', {|| Upper(NakPOL->cTypMat) } ,'Upper(NakPOL->cTypMat)' ))
RETURN self

********************************************************************************
METHOD VYR_NakPOL_SEL:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  if ::nRec <> nil
    NakPOL->( dbGoTO( ::nRec))
    ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  endif
RETURN

********************************************************************************
METHOD VYR_NAKPOL_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
     DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
     ::drgDialog:dialogCtrl:refreshPostDel()

//     oXbp:refreshAll()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

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

/********************************************************************************
METHOD VYR_NAKPOL_SEL:ItemMarked()
  Local Key := Upper( NakPOL->cCisSklad) + Upper( NakPOL->csKLpol)

  CenZBOZ->( dbSEEK( Key,, 3))
  *
RETURN SELF
*/
*
********************************************************************************
METHOD VYR_NAKPOL_SEL:NakPOL_scr()
*  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_NAKPOL_SCR' PARENT ::drgDialog DESTROY
*  ::drgDialog:popArea()                  // Restore work area
RETURN self