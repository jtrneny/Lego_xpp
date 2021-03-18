/*==============================================================================
  VYR_VyrPolOPE_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_VyrPolOPE_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, Destroy
  METHOD  drgDialogStart, EventHandled, ItemMarked
  METHOD  Edit_PolOPER        // Editaèní mechanismus pro PolOPER

HIDDEN
  VAR     dc, dm
*  METHOD  Edit_PolOPER        // Editaèní mechanismus pro PolOPER
  METHOD  sumColumn
ENDCLASS

*
********************************************************************************
METHOD VYR_VyrPolOPE_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('OPERACE'  )
*  drgDBMS:open('POLOPER' )
RETURN self

*
********************************************************************************
METHOD VYR_VyrPolOPE_scr:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, ocolumn

  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager

  SEPARATORs(members)
  POLOPER->( DbSetRelation( 'OPERACE', { || Upper( POLOPER->cOznOper) },;
                                           'Upper( POLOPER->cOznOper)' ))
RETURN self

*
********************************************************************************
METHOD VYR_VyrPolOPE_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_DELETE
      VyrPOL_OnDELETE()
      oXbp:cargo:refresh()
      RETURN .T.
    CASE nEvent = xbeP_SetDisplayFocus
      ::sumColumn()
    OTHERWISE
      RETURN .F.
    ENDCASE

 RETURN .T.

*
********************************************************************************
METHOD VYR_VyrPolOPE_SCR:ItemMarked()
  Local cScope := Upper(VYRPOL->cCisZakaz)+ Upper(VYRPOL->cVyrPol) //+ StrZero(VYRPOL->nVarCis, 3)

  POLOPER->( mh_SetScope( cScope))
  ::sumColumn()
RETURN SELF

*
********************************************************************************
METHOD VYR_VyrPolOPE_scr:destroy()
  ::drgUsrClass:destroy()
RETURN self

*
** HIDDEN **********************************************************************
METHOD VYR_VyrPolOPE_SCR:Edit_PolOPER()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_PolOper_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
** HIDDEN **********************************************************************
METHOD VYR_VyrPolOPE_scr:sumColumn()
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
  ::dc:oBrowse[2]:oXbp:getColumn(5):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(5):Footing:setCell(1, nPriprCas_sum)
  ::dc:oBrowse[2]:oXbp:getColumn(5):Footing:show()
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:setCell(1, nKusovCas_sum)
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:show()
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:setCell(1, nKcOper_sum)
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:show()
  ::dm:refresh()

RETURN self