/*==============================================================================
  VYR_PracVAZ_vyk.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.ch'
#include "XBP.ch"
#include "Gra.ch"
#include "adsdbe.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_PracVAZ_vyk FROM drgUsrClass
EXPORTED:
  VAR     cIdVazby, dDatVykaz

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  EventHandled
  METHOD  PostValidate
HIDDEN
  VAR     dm, dc
ENDCLASS

*
********************************************************************************
METHOD VYR_PracVAZ_vyk:Init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('PRACVAZ' )
  PracVAZ->( AdsSetOrder( 'PRVAZ_2'))
  ::cIdVazby    := ''
  ::dDatVykaz   := DATE()
RETURN self

*
********************************************************************************
METHOD VYR_PracVAZ_vyk:drgDialogStart(drgDialog)
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  *
  drgDialog:oForm:setNextFocus( 'M->cIdVazby',,.T.)
RETURN self

*
********************************************************************************
METHOD  VYR_PracVAZ_vyk:drgDialogEnd(drgDialog)
RETURN

*
********************************************************************************
METHOD VYR_PracVAZ_vyk:eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_DELETE
*    CASE nEvent = drgEVENT_EDIT
    OTHERWISE
      RETURN .F.
    ENDCASE

RETURN .T.

*
********************************************************************************
METHOD VYR_PracVAZ_vyk:PostValidate(oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)

  DO CASE
  CASE cName = 'M->cIdVazby'
    IF lOK := PracVAZ->( dbSEEK( Upper( PADL( xVar, 12, '0'))))
      IF PracVAZ->lVykazano
        drgMsgBox(drgNLS:msg('Vazba [ & ] JIŽ BYLA vykázána  !', VAL(PracVAZ->cIdVazby) ) )
        lOK := .F.
      ELSE
        ::dm:save()
      ENDIF
    ELSE
      drgMsgBox(drgNLS:msg('Chybné èíslo vazby  !') )
    ENDIF
  CASE cName = 'M->dDatVykaz'
    ::dm:save()
    IF PracVAZ->( RLock())
      PracVAZ->dDatVykaz := xVar
      PracVAZ->lVykazano := .T.
      drgMsgBox(drgNLS:msg('Vazba [ & ]  BYLA PRÁVÌ  vykázána  !', VAL(PracVAZ->cIdVazby) ), XBPMB_INFORMATION )
      ::dm:set('cIdVazby', '' )
      PracVAZ->( dbUnlock())
    ENDIF
  ENDCASE
RETURN  lOK

*
********************************************************************************
METHOD VYR_PracVAZ_vyk:destroy()
  ::drgUsrClass:destroy()
  * EXPORTED
  ::cIdVazby := ::dDatVykaz := NIL
  *
RETURN self
