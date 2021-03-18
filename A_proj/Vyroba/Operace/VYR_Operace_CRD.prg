/*==============================================================================
  VYR_Operace_CRD.PRG
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"

#define  tab_ZAKLADNI     1
#define  tab_POPIS        2
#define  tab_ATRIBUTY     3
#define  tab_POSTUPY      4
********************************************************************************
*
********************************************************************************
CLASS VYR_Operace_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, lCopyREC

  METHOD  Init, drgDialogInit, drgDialogStart
  METHOD  EventHandled, PostValidate, tabSelect, Destroy

HIDDEN
  VAR dm, dc, members
  VAR tabNUM, lNewHA, lNewPP

ENDCLASS

********************************************************************************
METHOD VYR_Operace_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC  := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC := ( parent:cargo = drgEVENT_APPEND2)
  ::lNewHA   := .F.
  ::lNewPP   := .F.
  ::tabNUM   := tab_ZAKLADNI

  IF( Used( 'PRACPOST'), NIL, drgDBMS:open( 'PRACPOST'))
  drgDBMS:open('OPERACEw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
*  drgDBMS:open('HODATRIBw',.T.,.T.,drgINI:dir_USERfitm); ZAP
*  drgDBMS:open('PPOPERw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open( 'HODATRIB')
  drgDBMS:open( 'PPOPER'  )

  VYR_OPERACE_edit( self, 'OPERACEw')
RETURN self

********************************************************************************
METHOD VYR_OPERACE_CRD:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN

********************************************************************************
METHOD VYR_Operace_CRD:drgDialogStart(drgDialog)
  ::dm      := ::drgDialog:dataManager
  ::dc      := ::drgDialog:dialogCtrl
  ::members := drgDialog:oForm:aMembers

  IF  'INFO' $ UPPER( drgDialog:title)
    drgDialog:SetReadOnly( .T.)
  ENDIF
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  /*
  IF UPPER( drgDialog:parent:formName) $ 'VYR_KALK_MZD'
    drgDialog:SetReadOnly( .T.)
  ENDIF
  */
RETURN self
*
********************************************************************************
METHOD VYR_Operace_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL cMsg, cPrm, cFile

  DO CASE

  CASE  nEvent = drgEVENT_SAVE
    IF oXbp:ClassName() <> 'XbpBrowse'
      IF ::tabNUM = 3 .or. ::tabNUM = 4
        cFile := IF( ::tabNUM = tab_ATRIBUTY, 'HodAtrib', 'PPOper')
        VYR_OPERACE_save( self, cFile, IF( ::tabNUM = tab_ATRIBUTY, ::lNewHA, ::lNewPP) )
        ::dc:oaBrowse:refresh()
        SetAppFocus(::dc:oaBrowse:oXbp)
        ::dm:refresh()
      ELSE
        VYR_OPERACE_save( self, 'OPERACEw')
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,oXbp)
      ENDIF
    ENDIF
    RETURN .T.

  CASE nEvent = drgEVENT_APPEND
    IF oXbp:ClassName() = 'XbpBrowse'
      ::lNewHA := ( ::tabNUM = tab_ATRIBUTY)
      ::lNewPP := ( ::tabNUM = tab_POSTUPY)
      cFile := IF( ::tabNUM = tab_ATRIBUTY, 'HodAtrib', 'PPOper')
      VYR_OPERACE_edit( self, cFILE, .T. )
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_EDIT
    IF oXbp:ClassName() = 'XbpBrowse'
      cFile := IF( ::tabNUM = tab_ATRIBUTY, 'HodAtrib', 'PPOper')
      VYR_OPERACE_edit( self, cFILE, .F. )
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_DELETE
    IF ::tabNUM = tab_ATRIBUTY .or. ::tabNUM = tab_POSTUPY
      cMsg  := IF( ::tabNUM = tab_ATRIBUTY, 'Zrušit vybraný atribut < & >  ?',;
                                            'Zrušit vybraný pracovní postup < & >  ?' )
      cFile := IF( ::tabNUM = tab_ATRIBUTY, 'HodAtrib', 'PPOper')
      cPrm  := IF( ::tabNUM = tab_ATRIBUTY, HodAtrib->cAtribOper, PPOper->cOznPrPo )
      IF drgIsYESNO(drgNLS:msg( cMsg, cPrm) )
        If ( cFile)->( sx_RLock())
          ( cFile)->( DbDelete(), DbUnlock() )
          ::dc:oaBrowse:refresh()
        ENDIF
      ENDIF
    ENDIF
    RETURN .T.
  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      IF oXbp:ClassName() <> 'XbpBrowse' .and. ::tabNUM > tab_POPIS
        ::dm:refresh()
        ::dc:oaBrowse:refresh()
        SetAppFocus(::dc:oaBrowse:oXbp)
      ELSE
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      ENDIF
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_Operace_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )
  LOCAL  cName := UPPER(oVar:name)

  IF lValid
    DO CASE
    CASE cName = 'OPERACEw->cOznOper'
      IF( lOK := ControlDUE( oVar) )
        IF lValid
          nRec := Operace->( RecNo())
          IF ( lOK := Operace->( dbSeek( xVar)) )
            cMsg := 'DUPLICITA !;; Operace s tímto oznaèením již existuje !'
            drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
          ENDIF
          Operace->( dbGoTo( nRec))
          lOK := !lOK
          IF( lOK, ::dm:set( cName, xVar ), NIL )
        EndIf
      ENDIF

    ENDCASE
  ENDIF
RETURN lOK

********************************************************************************
METHOD VYR_Operace_CRD:tabSelect( tabPage, tabNumber)

  IF ( ::tabNUM = 1 .or. ::tabNUM = 2) .and. tabNumber > 2
    VYR_OPERACE_save( self, 'OPERACEw')
    ::lNewREC := IF( ::lNewREC, .F., ::lNewREC )
  ENDIF
  ::tabNUM := tabNumber

RETURN .T.

*******************************************************************************
METHOD VYR_Operace_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC      := ;
  ::lCopyREC     := ;
  ::lNewHA       := ;
  ::lNewPP       := ;
  ::dm  := ::dc  :=  Nil

  OPERACEw->( dbCloseArea())
RETURN self