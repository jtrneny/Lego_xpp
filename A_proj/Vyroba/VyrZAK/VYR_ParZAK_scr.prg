/*==============================================================================
  VYR_ParZAK_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_ParZAK_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, EventHandled
  METHOD  PARAM_inZAK      // Výskyt parametru v zakázkách
ENDCLASS

*
********************************************************************************
METHOD VYR_ParZAK_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
*****************************************************************
METHOD VYR_ParZAK_SCR:drgDialogStart(drgDialog)
RETURN self

*
********************************************************************************
METHOD VYR_ParZAK_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  DO CASE
  CASE nEvent = drgEVENT_DELETE
    *
    IF drgIsYESNO(drgNLS:msg( 'Zrušit parametr zakázky [ & ] - &  ?' , ParZAK->cAtrib, ParZAK->cAtribNaz ) )
      * co když je parametr evidován u nìjaké zakázky - povolime zrušit
      If ParZAK->( sx_RLock())
        ParZAK->( DbDelete(), DbUnlock() )
        oXbp:cargo:refresh()
      ENDIF
    ENDIF
    *
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*  Výskyt parametru v zakázkách
********************************************************************************
METHOD VYR_ParZAK_SCR:PARAM_inZAK()
  LOCAL oDialog
  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  DRGDIALOG FORM 'VYR_ParZAK_inZAK' PARENT ::drgDialog MODAL DESTROY
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )

RETURN self


********************************************************************************
*
********************************************************************************
CLASS VYR_ParZAK_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, lCopyREC
  VAR     parentForm

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogInit
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  OnSave

HIDDEN
  VAR     dc,dm, members

ENDCLASS

*
********************************************************************************
METHOD VYR_ParZAK_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC   := ( parent:cargo = drgEVENT_APPEND2)

  drgDBMS:open('PARZAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP
**  VYR_POLOPER_edit( self)
  IF ::lCopyREC
*    SetCopyREC()
*    POLOPERw->nCisOper  := SetCisOper()
  ELSEIF ::lNewREC
    PARZAKw->(dbAppend())
  ELSE
    mh_COPYFLD('PARZAK', 'PARZAKw', .T.)
  ENDIF

RETURN self

*
********************************************************************************
METHOD VYR_ParZAK_CRD:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN

*
********************************************************************************
METHOD VYR_ParZAK_CRD:drgDialogStart(drgDialog)
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
RETURN self
*
********************************************************************************
METHOD VYR_ParZAK_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
**    VYR_POLOPER_save( self)
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    RETURN .T.
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

*
********************************************************************************
METHOD VYR_ParZAK_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get(), cNAMe := UPPER(oVar:name)
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), nRec

  DO CASE
  CASE cName = 'PARZAKw->cAtrib'
    IF( lOK := ControlDUE( oVar) )
      If lValid
        nRec := PARZAK->( RecNo())
        IF ( lOK := PARZAK->( dbSeek( Upper( xVar),,'PARZAK_1')) )
          cMsg := 'DUPLICITA !;; Parametr s tímto oznaèením již existuje !'
          drgMsgBox(drgNLS:msg( cMsg))
        ENDIF
        PARZAK->( dbGoTo( nRec))
        lOK := !lOK
      EndIf
    ENDIF
  ENDCASE

RETURN lOK

*
********************************************************************************
METHOD VYR_ParZAK_CRD:OnSave(isBefore, isAppend)
  *
  IF ! ::dc:isReadOnly
    ::dm:save()
    IF( ::lNewREC, ParZAK->( DbAppend()), Nil )
    IF ParZAK->(sx_RLock())
       mh_COPYFLD('ParZAKw', 'ParZAK' )
       ParZAK->( dbUnlock())
    ENDIF
  ENDIF
RETURN .T.

*
*******************************************************************************
METHOD VYR_ParZAK_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::lCopyREC := Nil

  ParZAKw->( dbCloseArea())
RETURN self

********************************************************************************
*  Výskyt parametru v zakázkách
********************************************************************************
CLASS VYR_ParZAK_inZAK FROM drgUsrClass
EXPORTED:

  METHOD  Init, drgDialogStart, drgDialogEnd, itemMarked //, EventHandled
ENDCLASS

********************************************************************************
METHOD VYR_ParZAK_inZAK:Init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('VyrZAK' )
RETURN self

********************************************************************************
METHOD VYR_ParZAK_inZAK:drgDialogStart(drgDialog)
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers )
  ZakaPAR->(  mh_SetScope( Upper( ParZAK->cAtrib)))
  drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
RETURN self

********************************************************************************
METHOD VYR_ParZAK_inZAK:drgDialogEnd(drgDialog)
  ZakaPAR->( mh_ClrScope())
RETURN self

*******************************************************************************
METHOD VYR_ParZAK_inZAK:ItemMarked()
  VyrZAK->( dbSEEK( Upper( ZAKAPAR->cCisZAKAZ),, 'VYRZAK1'))
RETURN SELF

/********************************************************************************
METHOD VYR_ParZAK_inZAK:eventHandled(nEvent, mp1, mp2, oXbp)
  DO CASE
  CASE nEvent = drgEVENT_DELETE
    /*
    IF drgIsYESNO(drgNLS:msg( 'Zrušit parametr zakázky [ & ] - &  ?' , ParZAK->cAtrib, ParZAK->cHodnAtrC ) )
      * co když je parametr evidován u nìjaké zakázky - povolime zrušit
      If ParZAK->( sx_RLock())
        ParZAK->( DbDelete(), DbUnlock() )
        oXbp:cargo:refresh()
      ENDIF
    ENDIF

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.
*/