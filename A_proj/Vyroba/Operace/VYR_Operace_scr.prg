/*==============================================================================
  VYR_Operace_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


#DEFINE  tab_ATRIB    3
#DEFINE  tab_OPER     4
#DEFINE  tab_POLOP    5

FUNCTION NazVyrPol()
  VyrPol->( dbSEEK( Upper(PolOper->cCisZakaz) + Upper(PolOper->cVyrPol),, 'VYRPOL1'))
RETURN VyrPol->cNazev

********************************************************************************
*
********************************************************************************
CLASS VYR_Operace_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  ItemMarked
  METHOD  OnSave

  METHOD  PolOPER_MAJ        // majetek u operací

HIDDEN:
  VAR     tabNUM
ENDCLASS

*
********************************************************************************
METHOD VYR_Operace_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('PracPost' )
  drgDBMS:open('PolOper'  )
  drgDBMS:open('VyrPol'   )
  ::tabNUM  := 1
RETURN self

*
********************************************************************************
METHOD VYR_Operace_SCR:drgDialogStart(drgDialog)

  PPOPER->( DbSetRelation( 'PracPost' , {|| Upper(PPOPER->cOznPrPo) }  ,'Upper(PPOPER->cOznPrPo)'))
  OPERACE->( DbSetRelation( 'C_TYPOP' , {|| Upper(OPERACE->cTypOper) } ,'Upper(OPERACE->cTypOper)'))
  OPERACE->( DbSetRelation( 'C_Stred' , {|| Upper(OPERACE->cStred) }   ,'Upper(OPERACE->cStred)'))
  OPERACE->( DbSetRelation( 'C_Pracov', {|| Upper(OPERACE->cOznPrac) } ,'Upper(OPERACE->cOznPrac)'))
  OPERACE->( DbSetRelation( 'C_PracZa', {|| Upper(OPERACE->cPracZar) } ,'Upper(OPERACE->cPracZar)'))
  OPERACE->( DbSetRelation( 'DruhyMzd', {|| OPERACE->nDruhMzdy} ,'OPERACE->nDruhMzdy'))
  OPERACE->( DbSetRelation( 'C_TarStu', {|| Upper(OPERACE->cTarifStup)},'Upper(OPERACE->cTarifStup)'))
  OPERACE->( DbSetRelation( 'C_TarTri', {|| Upper(OPERACE->cTarifTrid)},'Upper(OPERACE->cTarifTrid)'))

  ::tabSelect( , tab_ATRIB)
RETURN self

*
********************************************************************************
METHOD VYR_Operace_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_DELETE
      VYR_OPERACE_DEL()
      oXbp:cargo:refresh()
      RETURN .T.
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

*
********************************************************************************
METHOD VYR_Operace_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  ::itemMarked()
RETURN .T.

*
********************************************************************************
METHOD VYR_Operace_SCR:ItemMarked()

  IF ::tabNUM = tab_ATRIB .or. ::tabNUM = tab_OPER
    HodAtrib->( mh_SetScope( Upper( Operace->cOznOper)) )
*  ELSEIF ::tabNUM = tab_OPER
    PPOper->( mh_SetScope( Upper( Operace->cOznOper)) )
 ELSEIF ::tabNUM = tab_POLOP
    PolOper->( mh_SetScope( Upper( Operace->cOznOper)) )
*    VyrPol->( dbSEEK( Upper(PolOper->cCisZakaz) + Upper(PolOper->cVyrPol),, 1))
  ENDIF
RETURN SELF

*
********************************************************************************
METHOD VYR_Operace_SCR:OnSave()
RETURN .F.

*
********************************************************************************
METHOD VYR_Operace_SCR:PolOPER_MAJ()
LOCAL oDialog
/*
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_KusTREE_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
*/
RETURN self



*****************************************************************
* VYR_OPERACE_SEL ... Výbìr z typových operací
*****************************************************************
CLASS VYR_OPERACE_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  getForm

HIDDEN:
  VAR  drgGet
  METHOD  doAppend
ENDCLASS

*
*****************************************************************
METHOD VYR_OPERACE_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
//    ::drgGet := oXbp:cargo
    ::drgGet := if( oxbp:cargo:className() = 'drgGet', oxbp:cargo, nil )
  ENDIF
  ::drgUsrClass:init(parent)
  *
RETURN self

*
**********************************************************************
METHOD VYR_OPERACE_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
     ::doAppend( nEvent)

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

*
********************************************************************************
METHOD VYR_OPERACE_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .T.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

*
********************************************************************************
METHOD VYR_OPERACE_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF( .not. OPERACE->(DbSeek(::drgGet:oVar:value,,'OPER1')), OPERACE->(DbGoTop()), NIL )
    drgDialog:dialogCtrl:browseRefresh()
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_OPERACE_SEL:doAppend( nEvent)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('VYR_OPERACE_CRD', ::drgDialog)
  oDialog:cargo := nEvent  // drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
*    ::OnSave(,, oDialog )
    oDialog:dataManager:save()
    IF( oDialog:dialogCtrl:isAppend, C_PRACOV->( DbAppend()), Nil )
    IF OPERACE->(sx_RLock())
       mh_COPYFLD('OPERACEw', 'OPERACE' )
*       C_Pracov->cOznPracN  := C_Pracov->cOznPrac
*       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
       nREC := OPERACE->( RecNo())
       OPERACE->( dbUnlock())
       nREC := OPERACE->( RecNo())
       ::drgDialog:dialogCtrl:browseRefresh()
    ENDIF

  ENDIF
  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.

*
********************************************************************************
METHOD VYR_OPERACE_SEL:getForm()
  LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 75, 12 DTYPE '10' TITLE 'Seznam typových operací - VÝBÌR' ;
                                            FILE 'OPERACE'                   ;
                                            GUILOOK 'All:N,Border:Y,IconBar:y,Menu:y'

    DRGDBROWSE INTO drgFC SIZE 75,11.8 ;
                         FIELDS 'cOznOper, cNazOper, cTypOper'  ;
                         INDEXORD 1 SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'

RETURN drgFC