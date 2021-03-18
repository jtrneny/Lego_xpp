/*==============================================================================
  ZVI_zsbPohyby_SCR.PRG
==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"

********************************************************************************
*
********************************************************************************
CLASS ZVI_zsbPohyby_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, ItemMarked
  METHOD  zsbPohyby

ENDCLASS

********************************************************************************
METHOD ZVI_zsbPohyby_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('C_TypPoh' )
  drgDBMS:open('ZvKarty'  )
  drgDBMS:open('KategZvi' )
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbPohyby_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ZvZmenHD->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },;
                                         'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
RETURN

********************************************************************************
METHOD ZVI_zsbPohyby_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND
       ::zsbPohyby( nEvent)
    CASE nEvent = drgEVENT_EDIT
       IF ZvZmenHD->nKarta <> 0
         ::zsbPohyby( nEvent)
       ELSE
         drgMsgBox(drgNLS:msg( 'Pohyb nelze opravovat !'))
       ENDIF
    CASE nEvent = drgEVENT_DELETE
*      ZVI_ZvKarty_DEL()
*      ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD ZVI_zsbPohyby_SCR:ItemMarked()
  Local cKey := Upper(ZvZmenHD->cNazPol1) + Upper(ZvZmenHD->cNazPol4) + StrZero( ZvZmenHD->nZvirKat, 6)
  ZVKARTY->( dbSeek( cKey,, 'ZVKARTY_01' ))
  KATEGZVI->( dbSeek( ZvZmenHD->nZvirKat,, 'KATEGZVI_1' ))
RETURN SELF

********************************************************************************
METHOD ZVI_zsbPohyby_SCR:zsbPOHYBY( nEvent)
  LOCAL oDialog, nExit

  nEvent := IF( IsObject( nEvent), drgEVENT_APPEND, nEvent )

  oDialog := drgDialog():new('ZVI_zsbPohyby_CRD', ::drgDialog)
  oDialog:cargo := nEvent  // drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
RETURN self

