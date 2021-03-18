/*==============================================================================
  VYR_PolOper_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_PolOper_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked

  METHOD  PolOPER_MAJ      // majetek u operací
  METHOD  PolOPER_PRECIS   // pøeèíslování operací ( jen u nezakázkových operací)
HIDDEN
  VAR     dc, dm, oActions
  METHOD  sumColumn
ENDCLASS

*
********************************************************************************
METHOD VYR_PolOper_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('MajOPER'  )
  drgDBMS:open('C_MAJ'    )
  MajOPER->( DbSetRelation( 'C_MAJ', {|| MajOPER->nInvCis },'MajOPER->nInvCis','C_MAJ4'))
RETURN self

*
*****************************************************************
METHOD VYR_PolOper_SCR:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, oColumn, lOk := .t.

  ::dc       := drgDialog:dialogCtrl
  ::dm       := drgDialog:dataManager
  ::oActions := ::drgDialog:oActionBar:Members
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  /*
  FOR x := 1 TO LEN( Members)
    IF members[x]:event = 'PolOper_PRECIS'
      members[x]:oXbp:visible := EMPTY( PolOPER->cCisZakaz)
      members[x]:oXbp:configure()
     ENDIF
   NEXT
  */
  FOR x := 1 TO LEN( ::oActions)
    IF ::oActions[x]:event = 'PolOper_PRECIS'
      PolOper->( dbEval( {|| lOk := IF( EMPTY( PolOPER->cCisZakaz) .or. ;
                                      ( !EMPTY( PolOPER->cCisZakaz) .and. PolOPER->nPorCisLis = 0 ), lOk, .f.)}))
      PolOper->( dbGoTOP())
      IF( lOk .and. PolOper->nCisOper <> 0, ::oActions[x]:oXbp:enable(), ::oActions[x]:oXbp:disable() )
    ENDIF
    IF ::oActions[x]:event = 'PolOper_MAJ'
      IF( PolOper->nCisOper <> 0, ::oActions[x]:oXbp:enable(), ::oActions[x]:oXbp:disable() )
    ENDIF
  NEXT

  *
  ::sumColumn()
  ::dc:oBrowse[1]:oXbp:refreshAll()
RETURN self

*
********************************************************************************
METHOD VYR_PolOper_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      VYR_PolOPER_DEL()
      PolOper->( dbSkip())
      ::sumColumn()
      ::drgDialog:dialogCtrl:oaBrowse:refresh()
      RETURN .T.
    CASE nEvent = xbeP_SetDisplayFocus
      ::sumColumn()
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*
********************************************************************************
METHOD VYR_PolOper_SCR:ItemMarked()
  Local x
  Local cScope := Upper( PolOper->cVyrPol) + StrZero( PolOper->nCisOper, 4) + ;
                  StrZero( PolOper->nUkonOper, 2) + StrZero( PolOper->nVarOper, 3)
  *
  MajOPER->( mh_SetScope( cScope) )
  FOR x := 1 TO LEN( ::oActions)
    IF ::oActions[x]:event = 'PolOper_MAJ'
      IF( PolOper->nCisOper <> 0, ::oActions[x]:oXbp:enable(), ::oActions[x]:oXbp:disable() )
    ENDIF
  NEXT

RETURN SELF

*
** HIDDEN **********************************************************************
METHOD VYR_PolOper_scr:sumColumn()
  Local nRec := PolOper->( RecNO())
  Local nPriprCas_sum := 0, nKusovCas_sum := 0, nKcOper_sum := 0

  PolOPER->( dbGoTop() ,;
             dbEval( {|| nPriprCas_sum += PolOper->nPriprCas   ,;
                         nKusovCas_sum += PolOper->nCelkKusCa  ,;
                         nKcOper_sum   += PolOper->nKcNaOper   }) ,;
             dbGoTO( nRec))
  *
  nPriprCas_sum := MjCAS( nPriprCas_sum, to_CFG)
  nKusovCas_sum := MjCAS( nKusovCas_sum, to_CFG)
  *
  ::dc:oBrowse[1]:oXbp:getColumn(5):Footing:hide()
  ::dc:oBrowse[1]:oXbp:getColumn(5):Footing:setCell(1, nPriprCas_sum)
  ::dc:oBrowse[1]:oXbp:getColumn(5):Footing:show()
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:hide()
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:setCell(1, nKusovCas_sum)
  ::dc:oBrowse[1]:oXbp:getColumn(6):Footing:show()
  ::dc:oBrowse[1]:oXbp:getColumn(7):Footing:hide()
  ::dc:oBrowse[1]:oXbp:getColumn(7):Footing:setCell(1, nKcOper_sum)
  ::dc:oBrowse[1]:oXbp:getColumn(7):Footing:show()
  ::dm:refresh()

RETURN self
*
********************************************************************************
METHOD VYR_PolOper_SCR:PolOPER_MAJ()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_MajOper_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

RETURN self

* Pøeèíslování poøadí operací v PolOPER - jen u nezakázkových
********************************************************************************
METHOD VYR_PolOper_SCR:PolOPER_PRECIS()
  Local nRec := PolOper->( RecNo()), aRECs := {}

  IF drgIsYesNo(drgNLS:msg( 'Požadujete pøeèíslovat poøadí operací ?' ))
    PolOper->( dbGoTOP(), dbEVAL( {|| AADD( aRECs, RecNO()) } ))
    IF PolOPER->( sx_RLock( aRECs))
      FOR x := 1 TO LEN( aRECs)
        PolOper->( dbGoTO( aRECs[ x]))
        PolOper->nCisOper := IF( x = 1, 1, (x * 10) - 10 )
      NEXT
      PolOper->( dbUnlock())
    ENDIF
    PolOper->( dbGoTO( nRec))
    ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  ENDIF
RETURN self


* VYR_POLOPER_SEL ...
*****************************************************************
CLASS VYR_POLOPER_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
ENDCLASS

*****************************************************************
METHOD VYR_POLOPER_SEL:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

**********************************************************************
METHOD VYR_POLOPER_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  CASE nEvent = drgEVENT_APPEND
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


* VYR_POLOPER_SEL2 ... pro potøebu dávek mzd.lístkù (KOVAR)
*******************************************************************************
CLASS VYR_POLOPER_SEL2 FROM drgUsrClass

EXPORTED:
  METHOD  Init, EventHandled
ENDCLASS

*****************************************************************
METHOD VYR_POLOPER_SEL2:init(parent)
  ::drgUsrClass:init(parent)
RETURN self

**********************************************************************
METHOD VYR_POLOPER_SEL2:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  CASE nEvent = drgEVENT_APPEND
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