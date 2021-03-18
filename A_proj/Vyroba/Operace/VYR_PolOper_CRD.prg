/*==============================================================================
  VYR_PolOper_CRD.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_PrepocetCASU()   Prepocet()         VstPoop.prg
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_PolOper_CRD FROM drgUsrClass
EXPORTED:
  VAR     lNewREC, lCopyREC, nOperML
  VAR     parentForm
  VAR     fromNABvys             // voláno z nabídek vystavených
  VAR     frm_POLOPER            // formuláø pro POLOPER
  VAR     nVarFrmPOLOPER         // varianta formuláøe pro POLOPER

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogInit
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  DoSave //OnSave
  METHOD  VYR_OPERACE_SEL, VYR_PRACOV_SEL
  *
  METHOD  VYR_PrepocetCASU   // Pøepoèet èasù z ceny operace

  inline access assign method operace_cnazOper() var operace_cnazOper
    local  cKy := upper(polOperW->coznOper)
    operace->( dbseek( cKy,,'OPER1'))
    return operace->cnazOper

  inline access assign method cmjPripCas() var cmjPripCas
    return ::cmjCas

  inline access assign method cmjKusovCas() var cmjKusovCas
    return ::cmjCas


HIDDEN
  VAR     msg, dm, dc, df, members
  var     cmjCas, m_Key

  METHOD  KcNaOPER_cmp
  METHOD  KcDilec_cmp    // varFrm   = 1b ( Hydrap)
ENDCLASS

*
********************************************************************************
METHOD VYR_PolOper_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC   := ( parent:cargo = drgEVENT_APPEND2)
  *
  ::fromNABvys  := lower( parent:parent:parent:formname) $ 'pro_nabvyshd_in, pro_nabvyshd_cen_sel'
  ::frm_POLOPER := parent:drgDialog
  ::frm_POLOPER:formname := if( ::fromNABvys, 'VYR_POLOPER_CRD_1', 'VYR_POLOPER_CRD')
  ::nVarFrmPOLOPER := VAL( Right( ::frm_POLOPER:formname, 1))
  * CFG
  ::nOperML := SysCONFIG( 'Vyroba:nOperML')
  ::cmjCas  := if( SysConfig( 'Vyroba:nMjCas' ) = 1, 'hod', 'min' ) //  2 = minuty

  drgDBMS:open('OPERACE'   )
  drgDBMS:open('C_TARIF'   )

  * pro kontrolu
  drgDBMS:open('polOper',,,,,'polOper_v')
  polOper_v->( ordSetFocus('POLOPER1'))

  drgDBMS:open('POLOPERw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  POLOPER->( DbSetRelation( 'OPERACE', {|| Upper( POLOPER->cOznOper) },;
                                          'Upper( POLOPER->cOznOper)'))
  ::parentForm := ::drgDialog:parent:formName
  VYR_POLOPER_edit( self)
RETURN self

*
********************************************************************************
METHOD VYR_PolOPER_CRD:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN

*
********************************************************************************
METHOD VYR_PolOper_CRD:drgDialogStart(drgDialog)

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ::members := drgDialog:oForm:aMembers

  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )

  IF( ::nOperML = OPERML_STD  , drgDialog:oForm:setNextFocus( 'PolOperW->nCisOper'), NIL )
  IF( ::nOperML = OPERML_MOPAS, drgDialog:oForm:setNextFocus( 'PolOperW->cOznOper'), NIL )
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )

  ::m_Key := upper(polOperW->ccisZakaz) +upper(polOperW->cvyrPol)
/*
 IsEditGET( {'POLOPERw->cCisZakaz'  ,;
             'POLOPERw->cVyrPol'    ,;
             'POLOPERw->nVarCis'  } ,  ::drgDialog, ::lNewREC )

 FOR x := 1 TO LEN( Members)
   IF members[x]:event = 'PolOper_PRECIS'
     members[x]:oXbp:visible := EMPTY( PolOPER->cCisZakaz)
     members[x]:oXbp:configure()
    ENDIF
 NEXT
*/
RETURN self
*
********************************************************************************
METHOD VYR_PolOper_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
     ::DoSave()
    PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
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

********************************************************************************
METHOD VYR_PolOper_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged )

  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-')
  local  cKey  := Upper( VyrPol->cCisZakaz) + Upper( VyrPol->cVyrPol)
  Local  lSetCisOp := SysCONFIG( 'Vyroba:lSetCisOp')

  LOCAL  nRec, nVal := 1, cMsg, nNormaKsSt

  IF lValid
    DO CASE
    CASE cName = 'POLOPERw->nCisOper'
      IF( lOK := ControlDUE( oVar) )
        If lValid
           IF lSetCisOp
             polOper_v->( dbSetScope(SCOPE_BOTH, cKey +strZero(xVar,4)), dbgoBottom())
             nVal := polOper_v->nukonOper + 1
             polOper_v->( dbClearScope())
           ENDIF
           ::dm:set( 'POLOPERw->nUkonOper', nVal )
        EndIf
      ENDIF

    CASE cName = 'POLOPERw->nUkonOper'
      lOK := ControlDUE( oVar)

    CASE cName = 'POLOPERw->nVarOper'
      IF( lOK := ControlDUE( oVar) )
        IF lValid
          cKey := Upper( VyrPol->cCisZakaz) + Upper( VyrPol->cVyrPol) + ;
                  StrZERO( ::dm:get('POLOPERw->nCisOper' ), 4) + ;
                  StrZERO( ::dm:get('POLOPERw->nUkonOper'), 2) + StrZero( xVar, 3)
          IF ( lOK := polOper_v->( dbSeek( cKey)) )
            cMsg := 'DUPLICITA !;; Operace s tímto èíslem, úkonem a variantou již existuje !'
            drgMsgBox(drgNLS:msg( cMsg,, ::drgDialog:dialog))
          ENDIF
          lOK := !lOK
          IF( lOK, ::dm:set( 'POLOPERw->nVarOper', xVar ), NIL )
        EndIf
      ENDIF

    CASE cName = 'POLOPERW->cOznOper'
      lOK := ::Vyr_Operace_sel()

    CASE cName = 'POLOPERW->cOznPracN'
      lOK := ::Vyr_Pracov_sel()

    CASE cName = 'POLOPERW->nKusovCas'
      If lValid  //.and. xVar <> xOrg
        ::dm:set( 'POLOPERw->nCelkKusCa', xVar * ::dm:get('POLOPERw->nKoefKusCa' ) )
        ::KcNaOper_cmp()
      Endif

    CASE cName = 'POLOPERW->nKoefKusCa'
      If lValid .and. xVar <> 0
        ::dm:set( 'POLOPERw->nCelkKusCa', ::dm:get('POLOPERw->nKusovCas') * xVar )
        ::KcNaOper_cmp()
      Endif

    CASE cName = 'POLOPERW->nCelkKusCa'
      If ( lValid .and. xVar <> 0, ::KcNaOper_cmp(), nil )

    CASE  cName = 'POLOPERW->nProcRezie'
      If ( lValid, ::KcNaOper_cmp(), nil )

** var. formuláøe 1 - Hydrap
    CASE  cName = 'POLOPERW->nHodinSaz'
      ::KcDilec_cmp()
    CASE  cName = 'POLOPERW->nCyklCas'
      nNormaKsSt := (( 3600 / xVar) * 8 * 0.7 )
      ::dm:set( 'POLOPERw->nNormaKsSt', nNormaKsSt )
      ::KcDilec_cmp()
    CASE  cName = 'POLOPERW->nNormaKsSt'
      ::KcDilec_cmp()
    CASE  cName = 'POLOPERW->nKoefMnoSt'
      ::KcDilec_cmp()
    CASE  cName = 'POLOPERW->nKcDilec'
    ENDCASE
  ENDIF
RETURN lOK

********************************************************************************
METHOD VYR_PolOper_CRD:DoSave(isBefore, isAppend)
  *
  VYR_POLOPER_save( self)
  *  Pøi uložení nad strukt. kusovníkem
  IF ::parentForm = 'Vyr_KusTree_Scr'
    IF ::drgDialog:parent:dialogCtrl:isAppend
      VYR_ScopeOPER()
      PolOper->( dbGoBottom())
    ENDIF
**    ::drgDialog:parent:dialogCtrl:oaBrowse:oXbp:refreshAll()
  ENDIF
  *
  IF ::parentForm = 'Vyr_MListHD_Crd'
  ELSE
    ::drgDialog:parent:dialogCtrl:oaBrowse:oXbp:refreshAll()
  ENDIF
RETURN .T.

* Výbìr typové operace do karty POLOPER
********************************************************************************
METHOD VYR_PolOper_CRD:VYR_OPERACE_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('PolOPERw->cOznOper'))
  LOCAL lOK := ( !Empty(value) .and. Operace->( dbSEEK( Value,, 'OPER1')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_OPERACE_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'PolOPERw->cOznOper', OPERACE->cOznOper )
    if ::nVarFrmPOLOPER = 1
      c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid),, 'C_TARIF1'))
      ::dm:set( 'PolOPERw->nHodinSaz', c_Tarif->nHodinSaz )
    endif
    ::dm:refresh()
  ENDIF

RETURN lOK

* Výbìr následujícího pracovištì do karty POLOPER
********************************************************************************
METHOD VYR_PolOper_CRD:VYR_PRACOV_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('PolOPERw->cOznPracN'))
  LOCAL lOK   := Empty( value) .or. ;
                ( !Empty( value) .and. C_PRACOV->( dbSEEK( Value,, 'C_PRAC1')) )

  IF IsObject( oDlg) .or. ! lOK
    DRGDIALOG FORM 'VYR_PRACOV_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'PolOPERw->cOznPracN', C_PRACOV->cOznPrac )
    ::dm:refresh()
  ENDIF

RETURN lOK

*
*******************************************************************************
METHOD VYR_PolOper_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::lCopyREC := ::nOperML := Nil

  POLOPERw->( dbCloseArea())
RETURN self

* Pøepoèet èasù z ceny operace - na tlaèítko
*******************************************************************************
METHOD VYR_PolOper_CRD:VYR_PrepocetCASU()
  LOCAL cKey, nKCas, nKusovCas, nCelKusCas, nRound
  LOCAL nKcNaOper  := ::dm:get( 'POLOPERw->nKcNaOper')
  LOCAL nKoefKusCa := ::dm:get( 'POLOPERw->nKoefKusCa')

  IF nKcNaOper = 0
    drgMsgBox(drgNLS:msg( 'Cena je nulová, není tedy co pøepoèítat !'))
  ELSE
    cKey := Upper( ::dm:get('POLOPERw->cOznOper') )
    Operace->( dbSeek( cKey,,'OPER1'))
    c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid),, 'C_TARIF1'))
    nKCas := nKcNaOper / (( C_Tarif->nHodinSaz + C_Tarif->nHodinNav) / 60)
    nKCas := MjCAS( nKCas, 1 )
    nCelkKusCa := ROUND( nKCas / ( Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt), 4 )
    ::dm:set( 'POLOPERw->nCelkKusCa', nCelkKusCa )
    nKusovCas := ROUND( nCelkKusCa / nKoefKusCa, 4 )
    ::dm:set( 'POLOPERw->nKusovCas', nKusovCas )

  ENDIF

RETURN self

* Výpoèet ceny celkem
** HIDDEN **********************************************************************
METHOD VYR_PolOper_CRD:KcNaOPER_cmp()
  LOCAL cKey, nKCas, nKKc, nCelkKusCa, nKcDilec
  local nRezie := ::dm:get( 'POLOPERw->nProcRezie')

  if ::nVarFrmPOLOPER = 0  // STD
    nCelkKusCa := ::dm:get( 'POLOPERw->nCelkKusCa')
    cKey       := Upper( ::dm:get('POLOPERw->cOznOper') )
    Operace->( dbSeek( cKey))
    c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid),, 'C_TARIF1'))
    nKCas := nCelkKusCa * Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
    nKCas := MjCAS( nKCas, 1 )
    nKKc  := nKCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
    nKKc  +=  (nKKc / 100) * nRezie
    ::dm:set( 'POLOPERw->nKcNaOper', nKKc )

   elseif ::nVarFrmPOLOPER = 1  // varianta 1
     nKcDilec := ::dm:get( 'POLOPERw->nKcDilec')
     ::dm:set( 'POLOPERw->nKcNaOper', if( nRezie = 0, nKcDilec, (nKcDilec / 100) * nRezie ))
   endif

RETURN self

* Výpoèet ceny za dílec
** HIDDEN **********************************************************************
METHOD VYR_PolOper_CRD:KcDilec_cmp()
  local nHodinSaz := ::dm:get( 'POLOPERw->nHodinSaz')    // hodinová sazba
  local nKoefMnoSt := ::dm:get( 'POLOPERw->nKoefMnoSt')  // poèet strojù
  local nNormaKsSt:= ::dm:get( 'POLOPERw->nNormaKsSt')   // norma kusù na stroj
  LOCAL nKcDilec := 0

  if ::nVarFrmPOLOPER = 1  // varianta 1
    nKcDilec := ( nHodinSaz * 8) / ( nNormaKsSt / nKoefMnoSt)
    ::dm:set( 'POLOPERw->nKcDilec', nKcDilec )
    ::KcNaOper_cmp()
  endif
RETURN self