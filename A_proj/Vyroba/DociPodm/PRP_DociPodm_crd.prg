/*==============================================================================
  PRP_DociPodm_CRD.PRG
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#define  tab_ZAKLADNI     1
#define  tab_DALSI        2
#define  tab_KALKULACE    3
#define  tab_PARAMETRY    4


STATIC   nMnPotVyr

*****************************************************************
*
*****************************************************************
CLASS PRP_DociPodm_CRD FROM drgUsrClass
EXPORTED:
  VAR     lOpravy

  METHOD  Init, Destroy
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  tabSelect
  METHOD  PostValidate
  METHOD  OnSave //DoSave
  METHOD  VYR_VYRPOL_SEL

  METHOD  Opravy_Emise, btn_VyrZakIT
  METHOD  ObjToVyrZAK
  METHOD  PARAM_inZak    // pøehled zakázek s daným parametrem

HIDDEN:
  VAR     dc, dm
  VAR     lNewREC,lNewKALKUL, lNewPARAM, tabNUM
  VAR     lCopyREC
  METHOD  SetCisZAK
  METHOD  CondOfSTAV, RefreshBrow
  METHOD  Kalkul_CRD

ENDCLASS

*****************************************************************
*
*****************************************************************
METHOD PRP_DociPodm_CRD:init(parent)

  ::drgUsrClass:init(parent)
*  ::lNewREC := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC   := ( parent:cargo = drgEVENT_APPEND2)
  ::lNewREC    := ( parent:cargo = drgEVENT_APPEND)
  ::lNewKALKUL := .F.
  ::lNewPARAM  := .F.
  ::tabNUM     := tab_ZAKLADNI

*  drgDBMS:open('Config'   )
  drgDBMS:open('VyrPol'   )
  drgDBMS:open('cNazPol2' )
  drgDBMS:open('C_VniUct' )
  drgDBMS:open('C_StreOd' )
  drgDBMS:open('ListIT'   )

  drgDBMS:open('VYRPOLw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRZAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  IF ::lNewREC      ;  VYRZAKw->(dbAppend())
*                      VYRZAKw->cCisZakaz  :=  SetCisZakaz()
                       VYRZAKw->nVarCis    := 1
                       VYRZAKw->nMnozPlano := 1
                       VYRZAKw->dZapis     := DATE()
                       VYRZAKw->cNazPol1   := '200'   //  z CFG
                       VYRZAKw->cPriorZaka := '1 '    // normální
                       VYRZAKw->cStavZakaz := '1 '    // nová

  ELSEIF ::lCopyREC ; SetCopyREC()
  ELSE              ; mh_COPYFLD('VYRZAK', 'VYRZAKw', .T.)
  ENDIF
  ::lNewREC := ( ::lNewREC .OR. ::lCopyREC)
  ::lOpravy := .t.
  C_StreOD->( dbSetScope(SCOPE_BOTH, StrZERO( VYRZAKw->nCisFirmy, 5 )))
RETURN self

*
********************************************************************************
METHOD PRP_DociPodm_CRD:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN
*
********************************************************************************
METHOD PRP_DociPodm_CRD:drgDialogStart(drgDialog)
 LOCAL  members  := ::drgDialog:oActionBar:Members, x
 Local  aCFG := ListAsArray( SysCONFIG( 'Vyroba:cKarZakaz'))
 LOCAL  isEdit := ::CondOfStav( VyrZAKw->cStavZakaz, 7 )

 aCfg := AEVAL( aCFG, {|X,i| aCFG[i] := (X = '1')} )
 ::dc := drgDialog:dialogCtrl
 ::dm := drgDialog:dataManager

 IsEditGET( 'VyrZAKw->cCisZakaz' , drgDialog, ::lNewREC)
 IsEditGET( 'VyrZAKw->cNazPOL1'  , drgDialog, aCFG[ 1] )
 IsEditGET( 'VyrZAKw->cNazPOL3'  , drgDialog, aCFG[ 3] )
 IsEditGET( 'VyrZAKw->cNazPOL4'  , drgDialog, aCFG[ 4] )
 IsEditGET( 'VyrZAKw->cTypZAK'   , drgDialog, VyrZAKw->nMnozFAKT == 0 )
 IsEditGET( 'VyrZAKw->cNazPOL2'  , drgDialog, VyrZAKw->nMnozFAKT == 0 .and. aCFG[ 2] )
 IsEditGET( {'VyrZAKw->nMnozPlano'  ,;
             'VyrZAKw->nPlanPruZa'  ,;
             'VyrZAKw->dZapis'      ,;
             'VyrZAKw->dOdvedZaka'  ,;
             'VyrZAKw->dMozOdvZak'  ,;
             'VyrZAKw->cPriorZaka'} ,  drgDialog, isEdit )
 *
 IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
 *
 FOR x := 1 TO LEN( Members)
   IF members[x]:event = 'OPRAVY_EMISE'
*     IF( ::lOpravy, members[x]:enable(), members[x]:disable() )
     members[x]:oXbp:visible := ::lOpravy
     members[x]:oXbp:configure()
   ENDIF
   IF members[x]:event = 'SEPARATOR'
     members[x]:oXbp:visible := .F.
     members[x]:oXbp:configure()
   ENDIF
   /*
   IF members[x]:event = 'ZAK_CopyPrm'
     members[x]:disabled := (::tabNum <> 4)
     members[x]:oXbp:setColorFG( If( members[x]:disabled , GraMakeRGBColor({128,128,128}),;
                                                           GraMakeRGBColor({0,0,0})))
     members[x]:oXbp:configure()
   ENDIF
   */
 NEXT
 *
 ZAKAPAR->( dbSetScope(SCOPE_BOTH, UPPER( VYRZAKw->cCisZakaz )), dbGoTOP())
 *
 ::tabSelect( , ::tabNUM)

RETURN self

*
********************************************************************************
METHOD PRP_DociPodm_CRD:EventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK, nCisParam, oDialog, nExit

  DO CASE
  CASE  nEvent = drgEVENT_EDIT
    IF ( ::tabNUM = tab_KALKULACE, ::Kalkul_CRD( nEvent), NIL )
    IF  ::tabNUM = tab_PARAMETRY
       ::lNewPARAM := .F.
       ::drgDialog:oForm:setNextFocus( 'ZAKAPAR->nCisAtribZ',, .t. )
    ENDIF

  CASE  nEvent = drgEVENT_APPEND
    IF( ::lNewKALKUL := ( ::tabNUM = tab_KALKULACE), ::Kalkul_CRD( nEvent), NIL )
    IF ::lNewPARAM := ( ::tabNUM = tab_PARAMETRY)
      nCisPARAM := VYR_SetCisPARAM()
      ZAKAPAR->( dbGoTO(0) )
      ::dm:refresh()
      ::drgDialog:oForm:setNextFocus( 'ZAKAPAR->nCisAtribZ',, .t. )
      ::dm:set('ZAKAPAR->nCisAtribZ', nCisPARAM )
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_DELETE
    IF ::tabNUM = tab_PARAMETRY
      IF drgIsYESNO(drgNLS:msg('Zrušit vybraný parametr < & >  ?', ZAKAPAR->cAtrib ) )
        If ZAKAPAR->( DbRLock())
          ZAKAPAR->( DbDelete(), DbUnlock() )
          ::drgDialog:dialogCtrl:oaBrowse:refresh()
          ::dm:refresh()
        ENDIF
      ENDIF
    ENDIF
    RETURN .T.

  CASE  nEvent = drgEVENT_SAVE
    IF ::tabNUM = tab_KALKULACE .or. ::tabNUM = tab_PARAMETRY
      ::OnSave( .F.,  ::lNewREC )
    ELSE
      PostAppEvent(xbeP_Close, nEvent ,,oXbp)
    ENDIF
    RETURN .T.

  /*
*    ::DoSave( .F., ::lNewREC )
    IF ( ::tabNUM = 1 .or. ::tabNUM = 2 .or. ::tabNUM = 5)
*      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      PostAppEvent(xbeP_Close, nEvent ,,oXbp)
    ENDIF
    RETURN .T.
  */


  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      IF ( ::tabNUM = tab_PARAMETRY)
        /*
        ZAKAPAR->( dbGoTOP() )
        ::drgDialog:dataManager:refresh()
        ::drgDialog:dialogCtrl:oaBrowse:refresh()
        */
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
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
METHOD PRP_DociPodm_CRD:tabSelect( tabPage, tabNumber)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *
  FOR x := 1 TO LEN( Members)
    IF Upper(members[x]:event) $ 'ZAK_COPYPRM,PARAM_INZAK'
      members[x]:oXbp:visible := ( tabNumber = tab_PARAMETRY)
      members[x]:oXbp:configure()
    ENDIF

    /*
    IF members[x]:event = 'ZAK_CopyPrm'
      members[x]:disabled := (tabNumber <> 4)
      members[x]:oXbp:setColorFG( If( members[x]:disabled , GraMakeRGBColor({128,128,128}),;
                                                            GraMakeRGBColor({0,0,0})))
    ENDIF
    */
  NEXT
  *
  IF tabNumber = tab_KALKULACE
    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
    KALKUL->( dbSetScope(SCOPE_BOTH, UPPER( VYRZAKw->cCisZakaz )), dbGoTOP())
    ::RefreshBrow( 'KALKUL')
  ELSEIF  tabNumber = tab_PARAMETRY
    IF( ::lNewREC, ::OnSave( .F., ::lNewREC ), NIL )
    ZAKAPAR->( dbSetScope(SCOPE_BOTH, UPPER( VYRZAKw->cCisZakaz )), dbGoTOP())
    ::RefreshBrow( 'ZAKAPAR')
  ENDIF
  ::tabNUM := tabNumber
RETURN .T.
*
********************************************************************************
METHOD PRP_DociPodm_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
*  LOCAL  dc := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-'), cKey, cTag
  LOCAL  nREC, cStav
  LOCAL  nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)

*  IF lValid
    DO CASE
    CASE cName = 'VYRZAKW->CCISZAKAZ'
      IF lOK := EMPTY(xVar)
         drgMsgBox(drgNLS:msg('Oznaèení výrobní zakázky: ... údaj musí být vyplnìn !'),, ::drgDialog:dialog)
      ELSEIF lValid
        VYRZAK->( OrdSetFOCUS( 1))
        IF lOK := VYRZAK->(dbSEEK( Upper( xVar)))
          drgMsgBox(drgNLS:msg('DUPLICITA -  Výrobní zakázka < & > s tímto oznaèením již existuje !',;
                                VYRZAK->cCisZakaz ), XBPMB_WARNING )
        ENDIF
      Endif
      lOK := !lOK

      IF lOK  // .AND. nVyrZakBut == STS_PRUNEROV
* ??        dm:set('VyrZAKw->cNazPol3', LEFT( xVar, 8) )
//         G[ NazPOL3]:VarPUT( LEFT( xVAL, 8))
*         G[ NazPOL3]:VarPUT( LEFT( xVAL, LenNazPol3()  ))
*         ( G[ NazPOL3]:Display(), WhenBl( G[ NazPOL3]) )
      ENDIF

    CASE cName = 'VYRZAKW->CTYPZAK' .OR. cName = 'VYRZAKW->CNAZPOL2'
      If lValid
        cKEY := IF( cName = 'VYRZAKW->CTYPZAK', VyrZAKw->cNazPol2 + xVAR,;
                                                xVar + VyrZAKw->cTypZak )
        C_VniUCT->( dbSEEK( UPPER( cKEY)))
        VyrZAKw->cUcetVnitr := C_VniUCT->cUcetVnitr
        IF cName = 'VYRZAKW->CNAZPOL2'
           ListIT_NS2( ::dm)
        ENDIF
      EndIf

    CASE cName = 'VYRZAKW->CVYRPOL'
      IF lValid  // lChanged
        lOK := ControlDUE( oVar, .F.)
*          drgMsgBox(drgNLS:msg('Vyrábìná položka: ... údaj musí být vyplnìn !') )
*          RETURN .F.
*          lOK := .F.
*          lOK := ::VYR_VYRPOL_SEL( self )
*        ELSE
        IF !EMPTY( xVar)
          lKeyFound := VYRPOL->(dbSEEK( Upper( VYRZAKw->cCisZakaz) + Upper(xVar),, 1))
          lOK := ::VYR_VYRPOL_SEL( self, lKeyFound )
          xVar := IF( lOK, ::dm:get( 'VyrZAKw->cVyrPOL'), xVar )
        ENDIF
        IF lOK
          lOK := .F.
          IF ::lNewREC .OR. ( !::lNewREC .AND. ALLTRIM( VyrZAKw->cStavZAKAZ) $ '1234' )
*            cKEY := Upper( VyrZAKw->cCisZakaz) + Upper( xVar) + StrZero( VyrZAKw->nVarCis, 3 )
            cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + Upper( xVar) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
            IF ! VyrPol->( dbSeek( cKey,,1))
              cKey := EMPTY_ZAKAZ + Upper( xVar) + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
              * Pokud existuje nezakázková VyrPOL, vytvoø z ní novou zakázkovou pol.
              IF VyrPol->( dbSeek( cKey,,1))
                mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
                VYRPOLw->cCisZakaz := ::dm:get( 'VyrZAKw->cCisZakaz') // VYRZAKw->cCisZakaz
              ENDIF
            ENDIF
          ELSEIF !::lNewREC .AND. ALLTRIM(  ::dm:get( VyrZAKw->cStavZAKAZ)) $ '5678U'
            drgMsgBox(drgNLS:msg('NELZE ZMÌNIT -  Výrobní zakázka < & > není v odpovídajícím stavu ( 1,2,3,4)... !',;
                                  VyrZAKw->cCisZakaz ), XBPMB_WARNING )
            lOK := YES
          ENDIF
        ENDIF

        IF ( lOK := !lOK )
          // pøednastaví stav zakázky
          cStav := IF( EMPTY(VyrPOLw->cCisZakaz), VyrPOL->cStav, VyrPOLw->cStav)
          ::dm:set( 'VyrZAKw->cStavZakaz', IF( Empty( cStav), '1 ',;
                                           IF( 'A' $ Upper( cStav), '4 ', '3 ' )))
          // vynuluje mn. plánované z objednávek
          ::dm:set( 'VyrZAKw->nMnozPlano', 1 )
        ENDIF
      ENDIF

    CASE cName = 'VYRZAKW->NMNOZPLANO'
      If lValid // .and. AllTrim( G[ 3]:VarGet()) == 'O'   // z Objedn vky
         If ( xVar < 0 )
           drgMsgBox(drgNLS:msg('Hodnota musí být nezáporná !'),, ::drgDialog:dialog)
           lOK := FALSE
         ElseIf ( xVar < VyrZAKw->nMnozFakt )
           drgMsgBox(drgNLS:msg('Plánované množství < & > nesmí být menší, než již vyfakturované množství < & > !',;
                                 xVar, VyrZAKw->nMnozFakt  ),, ::drgDialog:dialog)
           lOK := FALSE
         Else
           nMnPotVyr := 0
           If Select( 'ObjZakW') <> 0
              SUM ObjZakW->nMnPotVyrZ TO nMnPotVyr
           Endif
           // nSuma := xVal + G[ 9]:VarGet() - G[ 8]:VarGet()
           lOK := ( nMnPotVyr <= xVar )
           If !lOK
             drgMsgBox(drgNLS:msg('Chyba pøi kontrolním výpoètu !;;' + ;
                                  'Suma z objednávek [ & ]  <=  Plánováno [ & ]',;
                                   nMnPotVyr, xVar ), XBPMB_WARNING )
             lOK := FALSE
           EndIf
         EndIf
      Endif

    CASE cName = 'VYRZAKW->NPLANPRUZA'
      If lValid  .and. ( xVar < 0 )
        drgMsgBox(drgNLS:msg('Hodnota musí být nezáporná !'),, ::drgDialog:dialog)
        lOK := FALSE
      EndIf

    CASE cName = 'VYRZAKW->NCENAMJ'       // Cna za MJ
     IF lChanged
       VyrZAKw->nCenaCELK  := ::dm:get('VYRZAKw->NMNOZPLANO') * xVar
       ::dm:has( 'VYRZAKW->NCENACELK'):refresh()
       VyrZAKw->nCenZakCEL := ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100)
       ::dm:has( 'VYRZAKW->NCENZAKCEL'):refresh()
     ENDIF

    CASE cName = 'VYRZAKW->NCENACELK' .OR.;    // Celkem bez DPH
         cName = 'VYRZAKW->NKLICDPH'
       VyrZAKw->nCenZakCEL := ::dm:get('VYRZAKw->NCenaCELK' ) * ( 1 + C_DPH->nProcDPH / 100)
       ::dm:has( 'VYRZAKW->NCENZAKCEL'):refresh()

*    CASE cName = 'ZAKAPAR->NCISATRIBZ'

    CASE cName = 'ZAKAPAR->NCISATRIBZ'
      IF lChanged
        cKey := VyrZak->cCisZakaz + StrZero( xVar, 5)
        nREC := ZAKAPAR->( RecNO())
        IF ZakaPAR->( dbSEEK( Upper( cKey)))
          drgMsgBox(drgNLS:msg('DuplicitnÍ èíslo atributu !'),, ::drgDialog:dialog)
          lOK := .F.
        ENDIF
        ZakaPAR->( dbGoTo( nRec))
        /*
        IF ZakaPAR->( dbRLock())
          ZakaPAR->NCISATRIBZ := xVar
          ZakaPAR->( dbRUnlock())
        ENDIF
        */
      ENDIF

    CASE cName = 'ZAKAPAR->nHodnAtrN'
      IF( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
**        PostAppEvent(xbeP_Close,drgEVENT_SAVE,,oXbp)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif


    ENDCASE
*  ENDIF

RETURN lOK

*
********************************************************************************
METHOD PRP_DociPodm_CRD:OnSave(isBefore, isAppend)
  Local lOK, dOdvedHLP
  Local dc := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager

  IF ::drgDialog:dialogCtrl:isReadOnly
    RETURN .T.
  ENDIF
  *
*  IF isBefore   // Pøed uložením
*  ELSE          // Po uložení
    IF     ::tabNUM = tab_KALKULACE
    ELSEIF ::tabNUM = tab_PARAMETRY
      IF ( lOK := if( ::lNewPARAM, AddREC('ZAKAPAR'), ReplREC('ZAKAPAR')) )
        ZAKAPAR->cCisZakaz  := VYRZAKw->cCisZakaz
        ZAKAPAR->nCisAtribZ := dm:get('ZAKAPAR->nCisAtribZ')
        ZAKAPAR->cAtrib     := dm:get('ZAKAPAR->cAtrib')   // PADL( ALLTRIM( dm:get('ZAKAPAR->cAtrib')), 20)
        ZAKAPAR->cHodnAtrC  := dm:get('ZAKAPAR->cHodnAtrC')
        ZAKAPAR->nHodnAtrN  := dm:get('ZAKAPAR->nHodnAtrN')
        ** mh_WRTzmena( 'ZAKAPAR', ::lNewPARAM)
        ZAKAPAR->( dbUnlock())
        dc:oaBrowse:refresh()
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        ::drgDialog:DataManager:refresh()
      ENDIF
    ELSE
      ::drgDialog:DataManager:save()
      IF ( lOK := if( ::lNewREC .or. ::lCopyREC, AddREC('VyrZAK'), ReplREC('VyrZAK')) )
        mh_COPYFLD( 'VYRZAKw', 'VYRZAK')
        dOdvedHLP := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        VyrZak->dZacatPrac := dOdvedHLP
  *        VyrZak->cCisPlan   := IF( EMPTY( dOdvedHLP), VyrZAK->cCisPLAN,;
  *                                  STRZERO( WEEK( dOdvedHLP), 2) + '/' + STR( YEAR( dOdvedHLP), 4) )
        VyrZak->cZkratMENY := IF( ::lNewRec, SysConfig( 'Finance:cZaklMena'), VyrZak->cZkratMenZ )
        VyrZak->cZkratMENY := IF( ::lNewRec, SysConfig( 'Finance:cZaklMena'), VyrZak->cZkratMeny )
        ** mh_WRTzmena( 'VYRZAK', isAppend)
        VyrZAK->( dbUnlock())
        * Pokud existuje nezakázková vyr.položka založí z ní zakázkovou
        IF !EMPTY(VyrPOLw->cCisZakaz)
          IF AddREC('VyrPOL')
            mh_COPYFLD( 'VYRPOLw', 'VYRPOL')
            ** mh_WRTzmena( 'VYRPOL', .T.)
            VyrPOL->( dbUnlock())
          ENDIF
        ENDIF
        ::lNewREC := IF( ::lNewREC, .f., ::lNewREC )
**        ::drgDialog:parent:dialogCtrl:oaBrowse:oXbp:refreshAll()
      ELSE
        drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
      ENDIF
    ENDIF
*  ENDIF

RETURN .t.

* Výbìr výrobní zakázky do karty vyrábìné položky
********************************************************************************
METHOD PRP_DociPodm_CRD:VYR_VYRPOL_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
*    ::drgDialog:oForm:setNextFocus( 'VYRZAKw->cVyrPol',, .t. )
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( 'VYRZAKw->cVyrPOL', VYRPOL->cVyrPOL )
    ::dm:set( 'VYRZAKw->nVarCis', VYRPOL->nVarCis )
    ::dm:refresh()
/*
    VYRZAKw->cVyrPOL    := VYRPOL->cVyrPOL
    VYRZAKw->nVarCis    := VYRPOL->nVarCis
    dm:has('VYRZAKw->cVyrPOL'):refresh()
    dm:has('VYRZAKw->nVarCis'):refresh()
*/
*    ::drgDialog:dataManager:refresh()
  ENDIF
RETURN lOK

*
********************************************************************************
METHOD PRP_DociPodm_CRD:Opravy_Emise
  LOCAL oDialog
*  drgMsgBox(drgNLS:msg('Opravy a emise ...'),, ::drgDialog:dialog)

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_ZakOprav_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
********************************************************************************
METHOD PRP_DociPodm_CRD:btn_VyrZakIT
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VyrZakIT_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
********************************************************************************
METHOD PRP_DociPodm_CRD:PARAM_inZak
  LOCAL oDialog
  LOCAL nTag  := ZAKAPAR->( OrdNumber()), nRecNo  := ZAKAPAR->( RecNO())
  LOCAL nTag2 := VyrZAK->( OrdNumber()) , nRecNo2 := VYRZAK->( RecNO())


  DRGDIALOG FORM 'VYR_PARZAK_inZAK' PARENT ::drgDialog MODAL DESTROY
*  dbSelectArea( cAlias)
  IF( nTag <> 0  , ZAKAPAR->( OrdSetFOCUS( nTag)), NIL )
  IF( nRecNo <> 0, ZAKAPAR->( dbGoTO( nRecNo))   , NIL )
  VYRZAK->( OrdSetFOCUS( nTag2), dbGoTO( nRecNo2) )

RETURN self
*
********************************************************************************
METHOD PRP_DociPodm_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::lCopyREC :=  ;
  ::lNewKALKUL   :=  ;
  ::lNewPARAM    :=  ;
  ::tabNUM       := NIL
RETURN self

*
**HIDDEN************************************************************************
METHOD PRP_DociPodm_CRD:Kalkul_CRD( nEvent)
  LOCAL oDialog, nExit, cKEY

  cKEY := Upper( ::dm:get( 'VyrZAKw->cCisZakaz')) + ;
          Upper( ::dm:get( 'VyrZAKw->cVyrPol')) + ;
          StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
  VYRPOL->( dbSEEK( cKEY))
  DRGDIALOG FORM 'VYR_KALKUL_CRD' PARENT ::drgDialog CARGO nEvent MODAL DESTROY ;
                                   EXITSTATE nExit
  ::drgDialog:dialogCtrl:oaBrowse:refresh()
RETURN self

*
**HIDDEN************************************************************************
METHOD PRP_DociPodm_CRD:RefreshBrow( cFILE)
  Local oBrowse := ::drgDialog:dialogCtrl:oBrowse

  FOR x := 1 TO LEN( oBrowse)
    IF oBrowse[ x]:cFile = cFile
       oBrowse[x]:oXbp:refreshAll()
    ENDIF
  NEXT
RETURN self


*
********************************************************************************
METHOD PRP_DociPodm_CRD:SetCisZAK()

RETURN self

*
********************************************************************************
METHOD PRP_DociPodm_CRD:CondOfStav( cStav, nCount, lEdit)
  Local lOK

  Default lEdit To YES
  IF !::lNewRec  ;   lOK := ( AllTrim( cStav) $ Left( '1234567', nCount) )
  ELSE           ;   lOK := lEdit
  ENDIF
RETURN( lOK)

*
********************************************************************************
METHOD PRP_DociPodm_CRD:ObjToVyrZAK()

  drgMsgBox( 'Testováno ...')
RETURN self


/*
STATIC FUNCTION SetCisZakaz()
  Local xRET := axE[ CisZAK, 4]
  Local nRec := VyrZak->( RecNo()), cTAG
  Local N, cPicturNUM := '', nLenPict := LEN( cPicturZAK)
  Local nMAX := 0

//  IF ( nVyrZakBUT == STS_PRUNEROV) .OR. ( nVyrZakBUT == ZPS_ZLIN )
  FOR N := 1 TO nLenPict
    cPicturNUM += '9'
  NEXT
  IF cPicturZAK == cPicturNUM  //  Pro Ÿ¡s.vzory pýednastavujeme o 1 vyçç¡
     ( cTAG := VyrZAK->( OrdSetFOCUS( 0)), VyrZAK->( dbGoBOTTOM()) )
     VyrZAK->( dbEVAL( {|| nMAX := MAX( nMAX, VAL( VyrZak->cCisZakaz))  }))
     xRet := PADR( ALLTRIM( STR( nMAX + 1, nLenPict )), nLenPict, ' ' )
//     xRet := PADR( ALLTRIM( STR( VAL( VyrZak->cCisZakaz) + 1, nLenPict )), nLenPict, ' ' )
     ( VyrZAK->( OrdSetFOCUS( cTAG), dbGoTO( nRec) )  )
  ENDIF
return xRET
*/


*===============================================================================
STATIC FUNCTION SetCopyREC()
  LOCAL nPos, aFld
*  LOCAL cFld := 'cCisloObj,cTypZak,nPlanPruZa,dZpraDokPL,dZpraDokSK,dOdvedZaka,' + ;
*                'cNazPol2,nCisFirmy,cTypCeny,cZkratMenZ,cZkrTypUhr,nKlicDph,'  + ;
*                'cStred_odb,cStroj_odb,cCisPlan,cZapis,cOdpovPrac'

  LOCAL cFld := 'cNazevZak1,cCisloObj,cTypZak,cPriorZaka,cVyrobCisl, cVyrPol,nVarCis,' + ;
                'nPlanPruZa,dZpraDokPL,dZpraDokSK,dOdvedZaka,' + ;
                'cNazPol2,nCisFirmy,cTypCeny,cZkratMenZ,cZkrTypUhr,nKlicDph,'  + ;
                'cStred_odb,cStroj_odb,cCisPlan,cZapis,cOdpovPrac'

  aFld :=  ListAsArray( cFld)
  VyrZAKw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := VyrZAK->( FieldPos( X))             , ;
                If( nPos <> 0, VyrZAKw->( FieldPut( nPos, VyrZAK->( FieldGet( nPos)) )), Nil ) ) } )
RETURN NIL

*
*===============================================================================
STATIC FUNCTION ListIT_NS2( dm)
  Local cTAG := ListIT->( OrdSetFOCUS( 6))
  Local cZakaz := dm:get('VYRZAKw->cCisZAKAZ'), cNazPol2 := dm:get('VYRZAKw->cNazPol2')

  ListIT->( dbSetScope(SCOPE_BOTH, UPPER( cZAKAZ)), dbGoTOP() )
  DO WHILE !ListIT->( EOF())
    IF ReplREC( 'ListIT')
      ListIT->cNazPol2 := cNazPol2
      ListIT->( dbUnlock())
    ENDIF
    ListIT->( dbSKIP())
  ENDDO
  ListIT->( dbClearScope(), OrdSetFOCUS( cTAG))
RETURN NIL

/*
*
*===============================================================================
FUNCTION VYR_SetCisPARAM()
  Local nCisParam, nRec := ZakaPAR->( RecNo())

  ZakaPAR->( dbGoBottom())
  nCisParam := ZakaPAR->nCisAtribZ + 1
  ZakaPAR->( dbGoTO( nRec))
RETURN( nCisParam)
*/