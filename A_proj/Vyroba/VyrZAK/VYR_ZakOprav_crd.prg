/*==============================================================================
  VYR_ZakOprav_CRD.PRG                    ... Nadstavbový modul OPRAVY A EMISE
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"


*****************************************************************
*
*****************************************************************
CLASS VYR_ZakOprav_CRD FROM drgUsrClass
EXPORTED:
  VAR     lOpravy

  METHOD  Init
  METHOD  drgDialogStart
*  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  PostValidate
*  METHOD  DoSave
  METHOD  Destroy

HIDDEN:
  VAR     lNewREC, tabNUM
ENDCLASS

*****************************************************************
*
*****************************************************************
METHOD VYR_ZakOprav_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := .F.  //!( parent:cargo = drgEVENT_EDIT)
  ::tabNUM    := 1
/*
  drgDBMS:open('VYRPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRZAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF ::lNewREC  ;  VYRZAKw->(dbAppend())
*                   VYRZAKw->cCisZakaz  :=  SetCisZakaz()
                   VYRZAKw->nVarCis    := 1
                   VYRZAKw->nMnozPlano := 1
                   VYRZAKw->dZapis     := DATE()
                   VYRZAKw->cNazPol1   := '123'   //  z CFG
                   VYRZAKw->cPriorZaka := '1 '    // normální
                   VYRZAKw->cStavZakaz := '1 '    // nová

  ELSE          ;  mh_COPYFLD('VYRZAK', 'VYRZAKw', .T.)
  ENDIF
*/
  ::lOpravy := .t.
RETURN self

*
********************************************************************************
METHOD VYR_ZakOprav_CRD:drgDialogStart(drgDialog)
 LOCAL  members  := ::drgDialog:oActionBar:Members, x

* ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)

RETURN self

/*
********************************************************************************
METHOD VYR_ZakOprav_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

RETURN .T.

*/
********************************************************************************
METHOD VYR_ZakOprav_CRD:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.
*
********************************************************************************
METHOD VYR_ZakOprav_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  dc := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-')
/*
  DO CASE
  CASE cName = 'ZAKOPRAVW->CCISZAKAZ'
  CASE cName = 'ZAKOPRAVW->CTYPZAK'

  ENDCASE
*/
RETURN lOK


*
********************************************************************************
METHOD VYR_ZakOprav_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC      :=  ;
  ::tabNUM       := NIL
RETURN self