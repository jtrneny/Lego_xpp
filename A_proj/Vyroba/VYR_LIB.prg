/*******************************************************************************
  VYR_LIB.PRG
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "DRGres.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

* Pøevod èasu do požadované MJ
*===============================================================================
*# DEFINE   to_MIN   1   // Pøevod na MINUTY ( v souboru jsou vždy uloženy minuty)
*# DEFINE   to_CFG   2   // Pøevod na MJ nastavenou v CFG

FUNCTION MjCAS( nCAS, nMOD)
  Local nMJ := SysConfig('Vyroba:nMjCas') //  2 = minuty
  Local nRetCAS

  DO CASE
     CASE nMJ == 1  ;  nRetCAS := IF( nMOD == to_MIN, nCAS / 60, nCAS * 60 )
     CASE nMJ == 2  ;  nRetCAS := nCAS
     CASE nMJ == 3  ;  nRetCAS := IF( nMOD == to_MIN, nCAS * 60, nCAS / 60 )
  ENDCASE
  nRetCAS := VAL( STR( nRetCAS, 13, 4))

RETURN( nRetCAS)

* Test na shodu cNazPol1 z CFG a daného souboru
*===============================================================================
FUNCTION NazPOL1_TST( cFILE, nKey, cKey)
  Local aKEY := {  xbeK_INS, xbeK_ENTER, xbeK_DEL }
  Local nPos, N, lTEST := .F., cMsg
  Local cHLP := AllTrim( SysConfig('Vyroba:cNazPol1'))
  Local aNazPOL1 := ListAsARRAY( cHLP) // { '200     '  }
  Local M := ASCAN( aNazPOL1, {|X| ALLTRIM( ( cFILE)->cNazPol1 ) = ALLTRIM(X) } )
  Local lOK := M <> 0 .OR. EMPTY( ( cFILE)->cNazPol1 )

  FOR N := 1 TO LEN( cKey)
    nPos  := VAL( SUBSTR( cKey, N, 1))
    lTEST := IF( nKey == aKEY[ nPOS], .T., lTEST )
  NEXT
  IF lTEST
    IF !lOK
      cMsg := 'Nemáte pøístup na støedisko < & > !'
      drgMsgBox(drgNLS:msg( cMsg, ( cFILE)->cNazPol1))
    ENDIF
  ELSE
    lOK := .T.
  ENDIF
RETURN lOK

* Výpoèet pøirážky dle priority
*===============================================================================
FUNCTION VYR_PrirazkaCMP( cPARAM)
  Local nAREA := SELECT(), nKc := 0, nCENA // := &cPARAM
  Local cFILE  //:= LEFT( cPARAM, AT( '->', cPARAM) - 1 )
  Local cTAG1, cTAG2, cTAG3
  /*
  IF VALTYPE( cPARAM) = 'C'         //  ''
    nCENA := &cPARAM
    cFILE := LEFT( cPARAM, AT( '->', cPARAM) - 1 )
  ELSE
    nCENA := cPARAM )
    cFILE := 'PVPITEM'
  ENDIF
  */
  nCENA := IF( VALTYPE( cPARAM) = 'C', &cPARAM , cPARAM )
  cFILE := IF( VALTYPE( cPARAM) = 'C', LEFT( cPARAM, AT( '->', cPARAM) - 1 ), 'PVPITEM' )

  IF nCENA <> 0
    IF( Used('C_KATZBO'), NIL, drgDBMS:open('C_KATZBO'))
    IF( Used('C_SKLADY'), NIL, drgDBMS:open('C_SKLADY'))
    IF( Used('CENZBOZ') , NIL, drgDBMS:open('CENZBOZ'))
    cTAG1 := C_KatZBO->( AdsSetOrder( 1))
    cTAG2 := C_Sklady->( AdsSetOrder( 1))
    cTAG3 := CenZboz->( AdsSetOrder( 3))
    * priorita 1  ... CenZboz
    IF CenZBOZ->( dbSEEK( Upper( ( cFILE)->cCisSklad) + Upper( ( cFILE)->cSklPol))) .AND. ;
       CenZboz->nPrirazka > 0
       nKc := nCENA * CenZboz->nPrirazka/100
    * priorita 2  ... C_KatZbo
    ELSEIF C_KatZBO->( dbSEEK( ( cFILE)->nZboziKat)) .AND. C_KatZBO->nPrirazka > 0
       nKc := nCENA * C_KatZBO->nPrirazka/100
    * priorita 3  ... C_Sklady
    ELSEIF C_Sklady->( dbSEEK( Upper( ( cFILE)->cCisSklad))) .AND. C_Sklady->nPrirazka > 0
      nKc := nCENA * C_Sklady->nPrirazka/100
    ENDIF
    C_KatZBO->( AdsSetOrder( cTAG1))
    C_Sklady->( AdsSetOrder( cTAG2))
    CenZboz->( AdsSetOrder( cTAG3))
    dbSelectAREA( nAREA)
  ENDIF

RETURN nKC

* Zjistí období pøi zápisu mzdového lístku
*===============================================================================
FUNCTION VYR_WhatOBD( lTydKapBlo )
  Local cObd, cDate := '  .  .  ', nWeekOfYear := 0

  DEFAULT lTydKapBlo TO NO
  IF !EMPTY( ListIT->dVyhotSkut)
    cDate := DtoC( ListIT->dVyhotSkut)
    nWeekOfYear := mh_WeekOfYear( ListIT->dVyhotSkut)  // WEEK( ListIT->dVyhotSkut)
  ELSEIF !EMPTY( ListIT->dVyhotPlan)
    cDate := DtoC( ListIT->dVyhotPlan)
    nWeekOfYear := mh_WeekOfYear( ListIT->dVyhotPlan)   // WEEK( ListIT->dVyhotPlan)
  ENDIF
  cObd := SubSTR( cDate, 4, 2) + '/' + RIGHT( cDate, 2)
  IF lTydKapBlo
    ListIT->nTydKapBlo := nWeekOfYear
  ENDIF
RETURN( cObd)

* Pro zpìtnou kompatibilitu
*===============================================================================
FUNCTION VYR_IsCZK( cZkratMENY )
  Local cCZK := 'CZK,KÈ,KC', lOK

  cZkratMENY := ALLTRIM( UPPER( cZkratMENY))
  lOK := cZkratMENY $ cCZK
RETURN lOK

*
*===============================================================================
FUNCTION VYR_MenaToMena( nVAL, cFromMENA, cToMENA )
  Local nToMENA := nVAL, n
  Local cCZK := 'CZK,Kè,KC', aKURZ
  Local lFromCZK := ( AllTRIM( cFromMENA) $ cCZK )
  Local lToCZK := ( AllTRIM( cToMENA) $ cCZK )

  IF nVAL <> 0 .AND. UPPER( cFromMENA) <> UPPER( cToMENA)
     IF lFromCZK   ;  nToMENA := nVAL
     ELSE          ;  aKURZ := LastKURZ( cFromMENA, DATE() )
                      nToMENA := ( nVAL / aKURZ[ 1]) * aKURZ[ 2]
     ENDIF
     IF !lToCZK    ;  aKURZ := LastKURZ( cToMENA, DATE() )
                      nToMENA := ( nToMENA * aKURZ[ 1]) / aKURZ[ 2]
     ENDIF
  ENDIF
RETURN( nToMENA )

*===============================================================================
FUNCTION LastKURZ( cMena, dDatum)
  Local aKURZ
  Local cKey := Upper( cMena) + DTOS( dDatum), cTag, nRec

  IF( Used('KurzIT'), NIL, drgDBMS:open('KurzIT'))
  cTag := KurzIT->( AdsSetOrder( 2))
  KurzIT->( mh_SetScope( Upper( cMena) ) )

  IF KurzIT->( dbSeek( cKey))
  Else  ;  KurzIt->( dbSkip( -1))
  EndIf
  nRec := KurzIT->( RecNo())
  aKURZ := { KurzIT->nMnozPrep , KurzIT->nKurzStred,;
             KurzIT->nKurzNakup, KurzIT->nKurzProde, KurzIT->dDatPlatn  }

  KurzIT->( mh_ClrScope())
  KurzIT->( AdsSetOrder( cTag), dbGoTo( nRec))
RETURN aKURZ

*===============================================================================
FUNCTION VYR_VYRPOL_INFO( oDlg)
LOCAL oDialog

  IF EMPTY( VyrPOL->cVyrPol)
    drgMsgBox(drgNLS:msg( 'Vyrábìná položka není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_VYRPOL_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Vyrábìná položka - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL

*===============================================================================
FUNCTION VYR_VYRZAK_INFO( oDlg)
LOCAL oDialog

  if select('vyrZak') = 0
    return nil
  endif

  IF EMPTY( VyrZAK->cCisZakaz)
    drgMsgBox(drgNLS:msg( 'Vyrobní zakázka není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_VYRZAK_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Výrobní zakázka - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL

*
*===============================================================================
FUNCTION VYR_VYRZAKIT_INFO( oDlg)
LOCAL oDialog

  IF EMPTY( VyrZAKIT->cCisZakazI)
    drgMsgBox(drgNLS:msg( 'Položka vyrobní zakázky není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_VYRZAKIT_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Položka výrobní zakázky - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL
*
*===============================================================================
FUNCTION VYR_POLOPER_INFO( oDlg)
  LOCAL oDialog
*  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  IF EMPTY( POLOPER->cVyrPol)
    drgMsgBox(drgNLS:msg( 'Operace k vyrábìné položce není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_POLOPER_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Operace k položce - INFO') MODAL DESTROY
  /*
  dbSelectArea( nArea)
  IF !EMPTY( Alias())
    IF( nTag <> 0  , ( nArea)->( AdsSetOrder( cTag)), NIL )
    IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
  ENDIF
  */
  oDlg:popArea()
RETURN NIL

*
*===============================================================================
FUNCTION VYR_OPERACE_INFO( oDlg)
LOCAL oDialog

  IF EMPTY( OPERACE->cOznOPER)
    drgMsgBox(drgNLS:msg( 'Typová operace není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_OPERACE_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Typová operace - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL

*===============================================================================
FUNCTION VYR_LISTIT_INFO( oDlg)
LOCAL oDialog

  IF ListIT->nPorCisLis = 0
    drgMsgBox(drgNLS:msg( 'Mzdový lístek není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_mLISTIT_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Mzdový lístek - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL

*===============================================================================
FUNCTION VYR_KALKUL_INFO( oDlg)
LOCAL oDialog

  IF EMPTY( Kalkul->cCisZakaz) .and. EMPTY( Kalkul->cVyrPOL)
    drgMsgBox(drgNLS:msg( 'Kalkulace není k dispozici ...' ))
    RETURN NIL
  ENDIF
  *
  oDlg:pushArea()
  DRGDIALOG FORM 'VYR_KALKUL_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Kalkulace - INFO') MODAL DESTROY
  oDlg:popArea()
RETURN NIL

*===============================================================================
FUNCTION VYR_IsVyrZAKIT()
  Local IsVyrZAKIT := ( VyrZAK->nPolZAK = 2 )    // VyrZAK->lPolZAK  // ( ALLTRIM( UPPER(VyrZAK->cTypZak)) = 'EK')
RETURN IsVyrZAKIT

* Zjistí, zda existují pol.operací(POLOPER) k vyr.položce(VYRPOL) nebo výrobní zakázce( VYRZAK)
* nebo položce výrobní zakázky( VYRZAKIT)
*===============================================================================
FUNCTION VYR_isPolOP( nID, cAlias, retLogical)
  Local cKey := Upper( (cAlias)->cCisZakaz) + Upper( (cAlias)->cVyrPol)
  Local isPolOper

  * Parametr nID - pro kompatibilitu pøi ukládání sloupcù browse
  DEFAULT retLogical TO .F.
  drgDBMS:open('POLOPER',,,,, 'POLOPERa')
  *
  cKey += IF( cAlias = 'VyrZakIT', StrZero( VyrZakIT->nOrdItem, 3), '' )
  isPolOper := POLOPERa->( dbSeek( cKey,,'POLOPER7'))                     //'POLOPER1'))
  *
  IF retLogical
    RETURN isPolOper
  ENDIF
RETURN( IF(isPolOper, DRG_ICON_SELECTT, DRG_ICON_SELECTF))
*
*===============================================================================
PROCEDURE SEPARATORs( members)
  Local x

  FOR x := 1 TO LEN( Members)
    IF members[x]:event = 'SEPARATOR'
      members[x]:oXbp:visible := .F.
      members[x]:oXbp:configure()

      members[x]:parent:drgDialog:oIconBar:oBord:visible := .f.
     ENDIF
  NEXT
RETURN

* Generování zakázkového kusovníku
********************************************************************************
FUNCTION VYR_GenKusovZAK( lAsk )
  Local lOK, nRec := VyrPOL->( RecNO()), cMsg
  Local cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol)

  DEFAULT lAsk TO .T.
  drgDBMS:open('KUSOVw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLDTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('POLOPERw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF( lOK := Kusov->( dbSeek( cKey)) )
    * Existuje zakázkový kusovník, ...
  ELSE
    * Neexistuje zakázkový kusovník, ...
    cKey := EMPTY_ZAKAZ + VyrZak->cVyrPol
    IF ( lOK := Kusov->( dbSeek( Upper( cKey))) )
      IF lAsk
        * ... ale existuje nezakázkový, tj. bez vztahu na zakázku
        cMsg := 'K vyrábìné položce neexistuje zakázkový kusovník !;;' + ;
                'Požadujete jeho vytvoøení vèetnì postupù z nezakázkového kusovníku této položky ?'
        IF drgIsYesNo(drgNLS:msg( cMsg ))
           *  Mechanismus vytvoøení z nezakázkového kusovníku ( Kusov, PolOper, Vyrpol)
           VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES )
           *
           drgMsgBox(drgNLS:msg( 'Generování kusovníku ukonèeno ... ' ))
        ENDIF
      ELSE
        VYR_KusForRV( VyrZak->cCisZakaz, EMPTY_ZAKAZ, VyrZak->cVyrPol, VyrZak->nVarCis, YES )
      ENDIF
    ELSE
      IF lAsk
        * ... neexistuje zakázkový ani nezakázkový kusovník
        cMsg := 'K vyrábìné položce neexistuje ani zakázkový ani nezakázkový kusovník !;;' + ;
                'Kusovník tedy není z èeho vygenerovat !!!'
        drgMsgBox(drgNLS:msg( cMsg ))
        lOK := FALSE
      ENDIF
    ENDIF
  ENDIF
  VyrPOL->( dbGoTO( nREC))

RETURN lOK

*===============================================================================
FUNCTION VYR_ZakazVP( cCisZakaz)
  Local nZakazVP := 0

  Do case
    case Left( cCisZakaz, 3) = 'NAV' ; nZakazVP := 2
    case !empty( cCisZakaz)          ; nZakazVP := 1
    case empty( cCisZakaz)           ; nZakazVP := 0
  endcase
RETURN nZakazVP

* Zjistí zda formuláø není nastaven jako ReadOnly
FUNCTION FormIsRO( cNameFrm)
  Local lReadOnly
  Local cForms := '' // 'vyr_vyrpol1_scr,vyr_vyrpol_crd,vyr_vyrzak_scr,vyr_vyrzak_crd'

  lReadOnly := ( lower(cNameFrm) $ cForms)
RETURN lReadOnly

********************************************************************************
FUNCTION MsgForRO( cMsg)

  DEFAULT cMsg TO 'Operace není povolena ...'
  drgMsgBox(drgNLS:msg( cMsg) )
RETURN Nil