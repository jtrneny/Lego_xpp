********************************************************************************
* VYR_MAJOPER_CRD
********************************************************************************
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
CLASS VYR_MAJOPER_CRD FROM drgUsrClass
EXPORTED:
  VAR     cNazevMAJ, cTypMaj, cCelek, cVykres, cVyrCisIM

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  postValidate
  METHOD  OnLoad, OnSave
  *
  METHOD  VYR_CMaj_sel

HIDDEN
  VAR     dm, cDruhMaj
ENDCLASS

*
********************************************************************************
METHOD VYR_MAJOPER_CRD:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_MAJ'    )
  drgDBMS:open('C_JEDNOT' )
  C_Maj->( dbSetRelation( 'C_Jednot', {|| Upper( C_Maj->cZkratJEDN) },;
                                         'Upper( C_Maj->cZkratJedn)' ))
  ::cNazevMaj := ::cTypMaj := ::cCelek := ::cVykres := ::cVyrCisIM := ''
RETURN self

*
*******************************************************************************
METHOD VYR_MAJOPER_CRD:destroy()
  ::drgUsrClass:destroy()
  ::cNazevMaj := ::cTypMaj := ::cCelek := ::cVykres := ::cVyrCisIM := NIL
RETURN self

*
********************************************************************************
METHOD VYR_MAJOPER_CRD:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  IsEditGET( 'M->cTypMaj', drgDialog, .F. )
RETURN self
                                                       *
********************************************************************************
METHOD VYR_MAJOPER_CRD:postValidate(oVar)
  Local lOK := .T. , nRecNo
  Local cName := oVar:Name, xVar := oVar:get(), cKEY
  Local lChanged := oVar:changed()
  local  nEvent := mp1 := mp2 := NIL
  *
  nEvent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, lChanged := .t., nil)

  DO CASE
  CASE  cName = 'MajOPER->nInvCis'
    IF mp1 = xbeK_ENTER //IF EMPTY( xVar) .or. lChanged
      lOK := ::VYR_CMaj_sel()
      IF( lOK := ControlDUE( oVar, .t.) )
        IF lChanged
          cKey := Upper( PolOper->cVyrPol) + StrZero( PolOper->nCisOper, 4) + ;
                  StrZero( PolOper->nUkonOper, 2) + StrZero( PolOper->nVarOper, 3) + ;
                  StrZero( ::dm:get(cName), 6) + ::cDruhMAJ
          IF MajOper->( dbSeek( cKey))
            drgMsgBox(drgNLS:msg('Majetek u dané operace již existuje !'))
            lOK := .F.
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDCASE

RETURN lOK

*
***************************************************************************
METHOD VYR_MAJOPER_CRD:OnLoad( isAppend)

  IF IsAppend    //  pøednastavení pøi INSertu
    ::dm:set( 'MajOPER->cDruhMaj'  , 'I ' )
    ::dm:set( 'M->cNazevMaj'       , ''   )
    ::dm:set( 'MajOPER->nMnozMaj'  , 1    )
    ::dm:set( 'MajOPER->cKodCasMaJ', 'A'  )
    IsEditGET( {'MajOPER->nInvCis', 'MajOPER->cDruhMaj'}, ::drgDialog, .T. )
  ELSE
    IsEditGET( {'MajOPER->nInvCis', 'MajOPER->cDruhMaj'}, ::drgDialog, .F. )
    ::dm:set( 'M->cNazevMaj', ::cNazevMaj  := C_MAJ->cNazevMaj )
    ::dm:set( 'M->cTypMaj'  , ::cTypMaj    := C_MAJ->cTypMaj   )
    ::dm:set( 'M->cCelek'   , ::cCelek     := C_MAJ->cCelek    )
    ::dm:set( 'M->cVykres'  , ::cVykres    := C_MAJ->cVykres   )
    ::dm:set( 'M->cVyrCisIM', ::cVyrCisIM  := C_MAJ->cVyrCisIM )
**    ::drgDialog:oForm:setNextFocus('MajOPER->nMnozMaj' )
  ENDIF
RETURN .t.

*
***************************************************************************
METHOD VYR_MAJOPER_CRD:OnSave( isBefore, isAppend)
  Local lOK, cKEY

  IF isBefore
  ELSE
    mh_COPYFLD( 'PolOPER', 'MajOPER')
    **mh_WRTzmena( 'MajOPER', isAppend)
    IF ReplREC( 'C_MAJ')
      C_MAJ->cNazevMaj  := ::cNazevMaj
      C_MAJ->cCelek     := ::cCelek
      C_MAJ->cVykres    := ::cVykres
      C_MAJ->cVyrCisIM  := ::cVyrCisIM
      C_MAJ->( dbUnlock())
    ENDIF
    * Vazba na úlohu IM
    IF ALLTRIM( UPPER( MajOPER->cDruhMAJ)) = 'I'
      drgDBMS:open('MAJ' )
      cKey := StrZero( C_MAJ->nTypMaj, 3) + StrZero( MajOper->nInvCis, 15)
      IF Maj->( dbSEEK( cKey,, 'MAJ01'))
        IF ReplREC( 'MAJ')
           MAJ->cNazev    := ::cNazevMaj
           MAJ->cCelek    := ::cCelek
           MAJ->cVykres   := ::cVykres
           MAJ->cVyrCisIM := ::cVyrCisIM
           MAJ->( dbUnlock())
        ENDIF
      ENDIF
    ENDIF
    * Vazba na úlohu DIM ???
    IF ALLTRIM( UPPER( MajOPER->cDruhMAJ)) = 'D'
    ENDIF
  ENDIF

RETURN .t.

*
********************************************************************************
METHOD VYR_MAJOPER_CRD:VYR_CMaj_sel()
  Local oDialog, nExit, lOK, cTAG, xVal, nInvCis, Filter
  local  nEvent := mp1 := mp2 := NIL, isF4
  *
  nEvent := LastAppEvent(@mp1,@mp2)
  isF4   := ( IsCHARACTER( mp1) .and. mp1 = 'VYR_CMaj_sel')

  ::cDruhMAJ := ::dm:get('MajOPER->cDruhMAJ')
  nInvCis := ::dm:get('MajOPER->nInvCis')
  C_MAJ->( AdsSetOrder( cTAG := IF( ::cDruhMAJ = 'I ', 'C_MAJ4', 'C_MAJ5' )))
  lOK := C_Maj->( dbSEEK( nInvCis,, cTAG))

  IF !lOK  .or. isF4
    Filter := FORMAT("(C_MAJ->cDruhMAJ = '%%')",{ ::cDruhMaj } )
    C_MAJ->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )

    oDialog := drgDialog():new('VYR_CMAJ_SEL', ::drgDialog)
    oDialog:cargo := ::cDruhMAJ
    oDialog:create(,,.T.)
    nExit := oDialog:exitState

    oDialog:destroy(.T.)
    oDialog := Nil
    C_MAJ->( dbClearFilter())  //C_MAJ->( dbClearSCOPE())
  ENDIF

  IF (nExit != drgEVENT_QUIT) .or. lOK
    ::dm:set('MajOPER->nInvCis' , IF( ::cDruhMAJ = 'I ', C_MAJ->nInvCis, C_MAJ->nInvCisDIM))
    ::dm:set('M->cTypMaj'  , C_Maj->cTypMaj   )
    ::dm:set('M->cNazevMaj', C_Maj->cNazevMaj )
    ::dm:set('M->cCelek'   , C_Maj->cCelek    )
    ::dm:set('M->cVykres'  , C_Maj->cVykres   )
    ::dm:set('M->cVyrCisIM', C_Maj->cVyrCisIM )
    ::dm:refresh()
  ENDIF

RETURN .t.