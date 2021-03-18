/*==============================================================================
  ZVI_Export_UE.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


#DEFINE   EXPORT_SKOT    1
#DEFINE   EXPORT_PRAS    2

********************************************************************************
* ZVI_Export_UE ... Export do ústøední evidence
********************************************************************************
CLASS ZVI_Export_UE FROM drgUsrClass

EXPORTED:
  VAR     cTypZvr, nPrenos, dDatumOd, dDatumDo, dDatumPS, lAktReg, cObdobi
  VAR     nAction, aAction, cAction
  VAR     cPathUstEv
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled
  METHOD  postValidate
  METHOD  Start_prenos, OpisTxt, RegHlZme

HIDDEN
  VAR     dm, dc, df, msg, abMembers
  METHOD  exportSKOT, exportPRAS, modiFrm, UEviFILE
  METHOD  WriteExport
ENDCLASS

*******************************************************************************
METHOD ZVI_Export_UE:init(parent)
  ::drgUsrClass:init(parent)

  ::cTypZvr    := ALLTRIM( drgParseSecond( parent:initParam, ','))
  ::nAction    := IF( ::cTypZvr = 'S', 1, 2 )
  ::aAction    := { 'SKOTU ', 'PRASAT'}
  ::cAction    := 'Export do ústøední evidence ' + ::aAction[ ::nAction]
  ::nPrenos    := 1     // 1:Pøenos za období, 2:Poèáteèní stavy
  ::dDatumOd   := ::dDatumDo := ::dDatumPS := CTOD('  .  .  ')
  ::lAktReg    := .F.
  ::cObdobi    :=  uctObdobi:ZVI:cObdobi
  ::cPathUstEv := Alltrim( SysConfig( 'Zvirata:cPathUstEv'))
  *
RETURN self

********************************************************************************
METHOD ZVI_Export_UE:destroy()

  ::drgUsrClass:destroy()
  ::cTypZvr := ::nPrenos := ::dDatumOd   := ::dDatumDo := ::dDatumPS  := ;
  ::lAktReg := ::cObdobi := ::cPathUstEv := ::abMembers := ;
  Nil
RETURN self

********************************************************************************
METHOD ZVI_Export_UE:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD ZVI_Export_UE:drgDialogStart(drgDialog)
  Local x

  ::dc  := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  ::df  := drgDialog:oForm
  ::msg := drgDialog:oMessageBar
  ::abMembers := drgDialog:oActionBar:Members
  *
  ::modiFrm()
  *
  IsEditGET( {'M->dDatumPS'}, ::drgDialog, .F.)
  *
  FOR x := 1 TO LEN( ::abMembers)
    IF Upper(::abMembers[x]:event) $ 'REGHLZME'
      IF ::abMembers[x]:event = 'RegHlZme'
        IF (::cTypZvr = 'S')
          ::abMembers[x]:oXbp:disable()
          ::abMembers[x]:oXbp:visible := .F.
          ::abMembers[x]:oXbp:configure()
        EndIf
      ENDIF
    ENDIF
  NEXT
RETURN self

********************************************************************************
METHOD ZVI_Export_UE:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_SAVE
    ::Start_prenos()

  CASE nEvent = xbeP_Selected
    IF ( oXbp:cargo:ClassName() = 'drgRadioButton')
      IF oXbp:Caption = 'Pøenos za období'
         IsEditGET( {'M->dDatumOd', 'M->dDatumDo' }, ::drgDialog, .T.)
         IsEditGET( {'M->dDatumPS'                }, ::drgDialog, .F.)
         ::nPrenos  := 1
      ELSEIF oXbp:Caption = 'Poèáteèní stavy'
         IsEditGET( {'M->dDatumOd', 'M->dDatumDo' }, ::drgDialog, .F.)
         IsEditGET( {'M->dDatumPS'                }, ::drgDialog, .T.)
         ::nPrenos  := 2
      ENDIF
      mp1 := .t.
      RETURN .F.
    ENDIF
    IF ( oXbp:cargo:ClassName() = 'drgCheckBox')
      ::lAktReg := .not. ::lAktReg
    ENDIF

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

********************************************************************************
METHOD ZVI_Export_UE:postValidate( oVar)
  LOCAL xVar  := oVar:get()
  LOCAL cName := UPPER(oVar:name), cKEY, dDatOd, lOK := .T.

  DO CASE
   CASE cName = 'M->dDatumDo'
     dDatOd := ::dm:get('m->dDatumOd')
     lOK := ( !EMPTY( dDatOD) .AND. !EMPTY( xVar) .AND. dDatOD <= xVar )
     IF !lOK
       drgMsgBox(drgNLS:msg('Chybný datový interval ...'))
     ENDIF
   CASE cName = 'M->dDatumPS'
     IF EMPTY( xVar)
       drgMsgBox(drgNLS:msg('Datum je tøeba zadat ...'))
       lOK :=.F.
     ENDIF
  ENDCASE

RETURN lOK

********************************************************************************
METHOD ZVI_Export_UE:Start_prenos()
  Local cMsg  := 'Provést export do ústøední evidence ' + ::aAction[ ::nAction]

  IF drgIsYesNo(drgNLS:msg( cMsg ))
    IF ::nAction = EXPORT_SKOT
      ::ExportSKOT()
    ELSEIF ::nAction = EXPORT_PRAS
      ::ExportPRAS()
    ENDIF
  ENDIF
RETURN NIL

********************************************************************************
METHOD ZVI_Export_UE:ExportSKOT()
  Local  dDatOd, dDatDo
  Local nAREA := SELECT(), nHANDLE, nCount := 0, nRecCOUNT, nSizeFILE, nSizeDISK
  Local lDO := YES, lOK := YES, lPREN
  Local cDISK := CoalesceEmpty( LEFT( ::cPathUstEV, 1),LEFT( drgINI:dir_USERfitm, 1))
  Local cTargDIR  := 'C:\TEMP\'
  Local cTargFILE := 'UESKOT.TXT'
  Local cTARGET := cTargDIR + cTargFILE, cRecTXT
  Local cTMP := drgINI:dir_USERfitm + cTargFILE
  Local cCfgDIR := drgChkDirName( ::cPathUstEv)

  *
  drgDBMS:open( 'T_USTEVI' )
  IF ::nPrenos == 1     // Pøenos za období
    dDatOd := ::dm:get('M->dDatumOd')
    dDatDo := ::dm:get('M->dDatumDo')
    ::msg:WriteMessage( 'Probíhá pøenos za období ...', DRG_MSG_INFO)
    UstEviFILE( dDatOD, dDatDO)
  ENDIF
  IF ::nPrenos == 2     // Poèáteèní stavy
    ::msg:WriteMessage( 'Probíhá pøenos poèáteèních stavù ...', DRG_MSG_INFO)
    ::UEviFILE()
  ENDIF

  drgDBMS:open( 'OpisTXT' )
  If OpisTxt->(FLock())
     OpisTXT->( dbEval( {|| dbDelete()} ))
     OpisTXT->( DBUnlock())
  EndIf
  *
  nRecCOUNT := T_UstEvi->( LastREC())

  IF( FILE( cTMP), FERASE( cTMP), NIL )
  nHANDLE := FCREATE( cTMP)
  T_UstEVIw->( dbGoTOP())

  ::msg:WriteMessage( 'Probíhá tvorba opisu pøenášeného souboru  ...', DRG_MSG_INFO)
  DO WHILE !T_UstEVIw->( EOF())
    lPREN := IF( ::nPrenos == 1,;
                 T_UstEVIw->dDatZmZv >= dDatOD .AND. T_UstEVIw->dDatZmZv <= dDatDO .AND. ;
                 VAL( T_UstEVIw->cDrPohybP) <> 0, YES )
    IF lPREN
      cRecTXT := T_UstEVIw->cDruhZV + T_UstEVIw->cFarmaODK + ;
                 T_UstEVIw->cDrPohybP + 'CZ00' + PADL( ALLTRIM( T_UstEVIw->cInvCis), 10, "0") + ;
                 T_UstEVIw->cDatZmZvRR + T_UstEVIw->cDatZmZvMM + T_UstEVIw->cDatZmZvDD + ;
                 T_UstEVIw->cTmOdkKamM + ;
                 T_UstEVIw->cDatVytRR + T_UstEVIw->cDatVytMM + T_UstEVIw->cDatVytDD + ;
                 T_UstEVIw->cPorod
      FWRITE( nHANDLE, cRecTXT + CRLF )
      WriteOPIS( cRecTXT)
    ENDIF

    ( T_UstEVIw->( dbSKIP()), nCount++ )
  ENDDO
  *
  ::msg:WriteMessage( 'Konec pøenosu ...', DRG_MSG_INFO)
  *
  nSizeFILE := FSEEK( nHandle, 0, 2)
  FCLOSE( nHANDLE)
  dbSelectAREA( nAREA)

  /*  Kopie na výstupní zaøízení

  IF cDISK $ 'AB'         //Ä Pýipravenost mechaniky
     lOK := DriveTST( cDISK)
  ENDIF
  */

  IF lOK                  // Smazání pùvodního souboru
    IF FILE( cCfgDIR + cTargFILE )
      FERASE( cCfgDIR + cTargFILE )
    ENDIF
  ENDIF


/*
  IF lOK
    nSizeDISK := DiskSPACE( cDISK + ':')
    IF nSizeFILE > nSizeDISK
      drgMsgBox(drgNLS:msg('Na cílovém disku je málo místa ...'))
      ( lOK := NO, lDO := NO )
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg('Pøenos byl pøerušen ...'))
    lDO := NO
  ENDIF
*/

  IF lOK
    COPY FILE (cTMP) TO (cCfgDIR + cTargFILE)
  ENDIF

  * Test na úspìšnost pøenosu
  IF lOK
    IF FILE( cCfgDIR + cTargFILE )
*      ::msg:WriteMessage( 'Probíhá tvorba textového opisu  ...', DRG_MSG_INFO)
      drgMsgBox(drgNLS:msg('Pøenos probìhl úspìšnì ...'))
*      DispOUTAT( 14, 12, PADC( 'ALT+G ... opis pýenesen‚ho souboru', 51 ), 'b/w' )
    ELSE
      drgMsgBox(drgNLS:msg('Pøenos probìhl neúspìšnì ...'))
    ENDIF
  ENDIF
  */
RETURN lDO

********************************************************************************
METHOD ZVI_Export_UE:UEviFILE()
  Local cFarma, cInvCis
  Local dDatVytvor := DATE()

  drgDBMS:open( 'Zvirata' )
  drgDBMS:open( 'T_UstEVIw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  *
  Zvirata->( dbGoTOP())
  DO WHILE !Zvirata->( EOF())
     IF Zvirata->nKusy > 0
       T_UstEVIw->( dbAppend())
       T_UstEVIw->cDruhZV    := '1'
       cFarma :=  STR( Zvirata->nFarma, 10)
       T_UstEVIw->cFarmaODK  := cFarma
       T_UstEVIw->cFarODKkrj := LEFT( cFarma, 2)
       T_UstEVIw->cFarODKpod := SubSTR( cFarma, 3, 6)
       T_UstEVIw->cFarODKstj := RIGHT( cFarma, 2)
       cInvCis := RIGHT( STR( Zvirata->nInvCis, 10), 9)
       T_UstEVIw->cInvCis    := ' ' + cInvCis
       T_UstEVIw->cInvCisPor := LEFT( cInvCis, 6)
       T_UstEVIw->cInvCisOkr := RIGHT( cInvCis, 3)
       T_UstEVIw->cDrPohybP  := IF( Zvirata->nPohlavi == 1, '27', '28' )

       T_UstEVIw->dDatZmZv   := ::dDatumPS
       T_UstEVIw->cDatZmZvDD := STRZERO( DAY( ::dDatumPS), 2)
       T_UstEVIw->cDatZmZvMM := STRZERO( MONTH( ::dDatumPS), 2)
       T_UstEVIw->cDatZmZvRR := RIGHT( STR( YEAR( ::dDatumPS), 4), 2)

       T_UstEVIw->dDatVytvor := dDatVytvor
       T_UstEVIw->cDatVytDD  := STRZERO( DAY(   dDatVytvor  ), 2)
       T_UstEVIw->cDatVytMM  := STRZERO( MONTH(  dDatVytvor ), 2)
       T_UstEVIw->cDatVytRR  := RIGHT( STR( YEAR( dDatVytvor), 4), 2)
     ENDIF
     Zvirata->( dbSkip())
  ENDDO
RETURN NIL

********************************************************************************
METHOD ZVI_Export_UE:ExportPRAS()
  Local nAREA := SELECT(), nHANDLE, nCount := 0, nRecCOUNT, nSizeFILE, nSizeDISK
  Local lDO := YES, lOK, lMAIN := YES, nFILE := 0
  Local cDISK := LEFT( ::cPathUstEV, 1), cKEYstart, cKEY
  Local nROKakt := uctObdobi:ZVI:nROK, nOBDakt := uctObdobi:ZVI:nOBDOBI
  Local nROK := nROKakt, nOBD := nOBDakt, nROKstart, nOBDstart, nKusyKON, nREC
  Local cTargDIR := 'C:\TEMP\'
  Local cKodHosp, cTargFILE, cTARGET, cTMP
  Local cCfgDIR := drgChkDirName( ::cPathUstEv)
  Local cFARMA, cFarmaZMN, cRecTXT := ''

  * Aktualizace stájového registru
  IF( ::lAktReg, ::msg:WriteMessage( 'Aktualizace stájového registru ...', DRG_MSG_INFO),;
                 ::msg:WriteMessage(,0) )
  ZVI_RegZviPr( , .F., ::lAktReg )
  *
  * Aktualizace ZvKarOBD
  ::msg:WriteMessage( 'Aktualizace stavù za období ...', DRG_MSG_INFO)
  ZVI_ZvKarOBD()
  *
**  drgDBMS:open( 'OpisTXTw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'OpisTXT' )
  If OpisTxt->(FLock())
     OpisTXT->( dbEval( {|| dbDelete()} ))
     OpisTXT->( DBUnlock())
  EndIf
*  drgDBMS:open( 'RegHlZMEw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'RegHlZME' )
  If RegHlZME->(FLock())
     RegHlZME->( dbEval( {|| dbDelete()} ))
     RegHlZME->( DBUnlock())
  EndIf
  *
  drgDBMS:open( 'RegZviPR') ; RegZviPR->( AdsSetOrder( 3))
  drgDBMS:open( 'ZvKarObd') ; ZvKarObd->( AdsSetOrder( 4))
  *
  nObdSTART := IF( nOBD < 12, nOBD + 1, nOBD - 11 )
  nRokSTART := IF( nOBD < 12, nROK - 1, nROK      )
  cKEYstart := STRZERO( nROKstart, 4) + STRZERO( nOBDstart, 2)
  cKEY      := STRZERO( nROK     , 4) + STRZERO( nOBD     , 2)
  RegZviPr->( dbGoTOP())
  cFARMA    := RegZviPr->cFARMA
  cKodHosp  := RegZviPr->cKodHosp
  cTargFILE := ALLTRIM( cKodHosp) + STRZERO( nOBDAKT, 2) + RIGHT( STR( nROKAKT), 2) + '.TXT'
  cTARGET   := cTargDIR + cTargFILE
  cTMP      := drgINI:dir_USERfitm + cTargFILE
  *
  drgDBMS:open( 'SumREGw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  IF( FILE( cTMP), FERASE( cTMP), NIL )
  nHANDLE := FCREATE( cTMP)
  *  Kusy na konci pøedchozího období
  nKusyKon := SumZvKarOBD( IF( nOBDakt > 1, nROKakt, nROKakt - 1),;
                           IF( nOBDakt > 1, nOBDakt - 1, 12),;
                           cFARMA )
  *
  ::msg:WriteMessage( 'Vytváøím sumaèní soubor za farmu ' + cFARMA + ' ...', DRG_MSG_INFO)
  *
  DO WHILE lMAIN
    nRec := RegZviPr->( RecNO())
    RegZviPr->( mh_SetScope( Upper( cFARMA) + cKEYstart, Upper( cFARMA) + cKEY  ))
    lMAIN := !EMPTY( RegZviPr->cFarma)

    // nastal pripad, ze zrusili staj(farmu), takze za cely rok
    // nemela zaznam v RegZviPr
    IF EMPTY( RegZviPr->cFarma)
       RegZviPr->( mh_ClrScope(SCOPE_TOP), mh_ClrScope(SCOPE_BOTTOM))
       RegZviPr->( dbGoTO( nRec))
       DO WHILE !RegZviPr->( Eof()) .and. ( cFarma = RegZviPr->cFarma)
         RegZviPr->( dbSkip())
       ENDDO
       IF !RegZviPr->( Eof())
         cFarma    := RegZviPr->cFarma
         cKodHosp  := RegZviPr->cKodHosp
         cTargFILE := ALLTRIM( cKodHosp) + STRZERO( nOBDAKT, 2) + RIGHT( STR( nROKAKT), 2) + '.TXT'
         cTARGET   := cTargDIR + cTargFILE
         cTMP      := drgINI:dir_USERfitm + cTargFILE
         IF( FILE( cTMP), FERASE( cTMP), NIL )
         nHANDLE := FCREATE( cTMP)
         lMAIN := .T.
         LOOP
       ENDIF
    ENDIF
    //-END

    DO WHILE !RegZviPr->( EOF())
      *
      IF RegZviPr->nDrPohybP = 29    // vìta s poè. stavem
         cRecTXT := Rec_PocStav()
         FWRITE( nHANDLE, cRecTXT + CRLF )
         WriteOPIS( cRecTXT)
      ELSE                            // zjisti stav z pøedchozího období
      ENDIF

      SumREGISTR( Upper( cFARMA) + cKEYstart, Upper( cFARMA) + cKEY  )
      nCount    := 0
      nRecCOUNT := SumREGw->( LastREC())
      SumREGw->( dbGoTOP())
      nROK := SumREGw->nROK
      nOBD := SumREGw->nOBDOBI
      DO WHILE !SumREGw->( EOF())
        IF !( nROK == SumREGw->nROK .AND. nOBD == SumREGw->nOBDOBI )
          * Zmìna období => závìreèná  vìta
          nKusyKON := SumZvKarOBD( nROK, nOBD, cFARMA)
          SumREGw->( dbSKIP( -1))
          cRecTXT := LEFT( SumREGw->cFARMA, 8)         + ;       //  1 -  8 znak
                     STR( LastDayOM( SumREGw->nObdobi), 2) + STRZERO( SumREGw->nObdobi, 2) + STRZERO( SumREGw->nROK, 4) + ; //  9 - 16
                     '09'                             + ;       // 17 - 18
                     '00000'                          + ;       // 19 - 23
                     '00000000'                       + ;       // 24 - 31
                     '000'                            + ;       // 32 - 34
                     '00000'                          + ;       // 35 - 39
                     PADL( ALLTRIM( STR( nKusyKon)), 5, "0" )   // 40 - 44

          FWRITE( nHANDLE, cRecTXT + CRLF )
          WriteOPIS( cRecTXT)
          WriteHLZMEN( nROKakt, nOBDakt, nKusyKon, YES )
          SumREGw->( dbSKIP())
          nROK := SumREGw->nROK
          nOBD := SumREGw->nOBDOBI
        ENDIF
        * Bìžná vìta
        cFarmaZMN := LEFT( SumREGw->cFarmaZMN, 8)
        cRecTXT := LEFT( SumREGw->cFARMA, 8) +  ;                     //  1 -  8 znak
                   '00' + STRZERO( SumREGw->nObdobi, 2) + STRZERO( SumREGw->nROK, 4) + ;  //  9 - 16
                   STR( SumREGw->nDrPohybP, 2) + ;                    // 17 - 18
                   PADL( ALLTRIM( STR( SumREGw->nKusy)), 5, "0" ) + ; // 19 - 23
                   IF( EMPTY( cFarmaZMN) .OR. VAL( cFarmaZMN)==0, '00000000', cFarmaZMN) + ; // 24 - 31
                   IF( EMPTY( SumREGw->cZvireZEM), '000', SumREGw->cZvireZEM) + ; // 32 - 34
                   PADL( ALLTRIM( STR( SumREGw->nKusyPocSt)), 5, "0" ) + ; // 35 - 39
                   PADL( ALLTRIM( STR( SumREGw->nKusyKonSt)), 5, "0" )     // 40 - 44

        FWRITE( nHANDLE, cRecTXT + CRLF )
        WriteOPIS( cRecTXT)
        WriteHLZMEN( nROKakt, nOBDakt, nKusyKon )
        ( SumREGw->( dbSKIP()), nCount++ )
      ENDDO
      SumREGw->( dbGoBottom())
      nKusyKON := SumZvKarOBD( SumREGw->nROK, SumREGw->nOBDobi, cFARMA)
      cRecTXT := LEFT( SumREGw->cFARMA, 8)         + ;       //  1 -  8 znak
                 STR( LastDayOM( SumREGw->nObdobi), 2) + STRZERO( SumREGw->nObdobi, 2) + STRZERO( SumREGw->nROK, 4) + ; //  9 - 16
                 '09'                             + ;       // 17 - 18
                 '00000'                          + ;       // 19 - 23
                 '00000000'                       + ;       // 24 - 31
                 '000'                            + ;       // 32 - 34
                 '00000'                          + ;       // 35 - 39
                 PADL( ALLTRIM( STR( nKusyKon)), 5, "0" )   // 40 - 44

      FWRITE( nHANDLE, cRecTXT + CRLF)
      WriteOPIS( cRecTXT)
      WriteHLZMEN( nROKakt, nOBDakt, nKusyKon, YES )
      RegZviPr->( dbGoBottom())
      nREC := RegZviPr->( RecNO())
      RegZviPr->( mh_ClrScope())
      RegZviPr->( dbGoTO( nREC))
      RegZviPr->( dbSKIP())
      *
      IF cFARMA <> RegZviPr->cFARMA
         cFARMA := RegZviPr->cFARMA
         //-
         nCount := 0
         ::msg:WriteMessage( 'Vytváøím sumaèní soubor za farmu ' + cFARMA + ' ...', DRG_MSG_INFO)
         *
         nFILE++
         lDO := ::WriteEXPORT( nHANDLE, cCfgDIR, cTARGfile, cTMP, ALLTRIM( STR( nFILE)) + '.' )
         cKodHosp  := RegZviPr->cKodHosp
         cTargFILE := ALLTRIM( cKodHosp) + STRZERO( nOBDAKT, 2) + RIGHT( STR( nROKAKT), 2) + '.TXT'
         cTARGET   := cTargDIR + cTargFILE
         cTMP      := drgINI:dir_USERfitm + cTargFILE     // FHOMADR() + '\TMP\' + cTargFILE

         *CreateTMP( 'SumReg', 'RegZviPr', NO )
         drgDBMS:open( 'SumREGw',.T.,.T.,drgINI:dir_USERfitm) ; ZAP
         IF( FILE( cTMP), FERASE( cTMP), NIL )
         nHANDLE := FCREATE( cTMP)
         *  Kusy na konci pøedchozího období
         nKusyKon := SumZvKarOBD( IF( nOBDakt > 1, nROKakt, nROKakt - 1),;
                                  IF( nOBDakt > 1, nOBDakt - 1, 12),;
                                  cFARMA )
         lMAIN := !EMPTY( cFARMA)
         EXIT
      ENDIF

    ENDDO
  ENDDO

  FCLOSE( nHANDLE)
  IF( FILE( cTMP), FERASE( cTMP), NIL )
  ::msg:WriteMessage( 'KONEC EXPORTU ...', DRG_MSG_INFO)
  drgMsgBox(drgNLS:msg('Konec exportu ...',XBPMB_INFORMATION))
RETURN NIL

*-------------------------------------------------------------------------------
METHOD ZVI_Export_UE:WriteEXPORT( nHANDLE, cCfgDIR, cTARGfile, cTMP, cTEXT )
  LOCAL nSizeFILE, nSizeDISK, lOK := YES, lDO := YES
  Local cDISK := CoalesceEmpty( LEFT( ::cPathUstEV, 1),LEFT( drgINI:dir_USERfitm, 1))
  Local cKEYstart, cKEY

  nSizeFILE := FSEEK( nHandle, 0, 2)
  FCLOSE( nHANDLE)
  *
  ::msg:WriteMessage( 'MOMENT PROSÍM - vytváøím kopii souboru ' + cTargFile + ' na požadované místo ...', DRG_MSG_INFO)
  *
  /*
  IF cDISK $ 'AB'         // Pøipravenost mechaniky
     lOK := DriveTST( cDISK)
  ENDIF
  */
  IF lOK                  // Smazání pùvodního souboru
    IF FILE( cCfgDIR + cTargFILE )
      FERASE( cCfgDIR + cTargFILE )
    ENDIF
  ENDIF

  IF lOK
    nSizeDISK := DiskSPACE( cDISK + ':')
    IF nSizeFILE > nSizeDISK
      drgMsgBox(drgNLS:msg('Na cílovém disku je málo místa ...'))
      ( lOK := NO, lDO := NO )
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg('Pøenos byl pøerušen ...'))
    lDO := NO
  ENDIF

  IF lOK
    COPY FILE (cTMP) TO (cCfgDIR + cTargFILE)
  ENDIF

  * Test na úspìšnost pøenosu
  IF lOK
    IF FILE( cCfgDIR + cTargFILE )
      ::msg:WriteMessage( cText + 'Výstupní soubor byl uložen na urèené místo ...', DRG_MSG_INFO)
*      drgMsgBox(drgNLS:msg('Pøenos probìhl úspìšnì ...'))
*       DispOUTAT( 14, 12, PADC( 'ALT+G ... opis pýenesen‚ho souboru', 51 ), 'b/w' )
    ELSE
      ::msg:WriteMessage( cText + 'Výstupní soubor nebyl nalezen ...', DRG_MSG_WARNING)
*      drgMsgBox(drgNLS:msg('Pøenos probìhl neúspìšnì ...'))
    ENDIF
  ENDIF
RETURN lDO

* Zobrazení souboru OpisTXT.dbf pro potøebu tisku kontrolního opisu.
*  - soubor OpisTXT je využit pro oba exporty ( skot, prasata )
********************************************************************************
METHOD ZVI_Export_UE:OpisTxt()
  LOCAL  oDialog, nExit

  oDialog := drgDialog():new('ZVI_OpisTXT', self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL

RETURN self

* Registr hlášení zmìn ( prasata) - zobrazení pro potøeby tisku
********************************************************************************
METHOD ZVI_Export_UE:RegHlZme()
  LOCAL  oDialog, nExit

  oDialog := drgDialog():new('ZVI_RegHlZme', self:drgDialog)
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL

RETURN self

* HIDDEN ***********************************************************************
METHOD ZVI_Export_UE:modiFrm()
  Local  membORG := ::dc:members[1]:aMembers, membCRD := {}
  Local  varsORG := ::dm:vars, varsCRD := drgArray():new()
  Local  oVar, x

  For x := 1 TO Len( membORG)
    oVar := membORG[x]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
        If oVAR:Groups <> ''
          if !isnil( oVAR:oXbp)
            oVAR:IsEDIT := .F.
            oVAR:oXbp:Hide()
          elseif !isnil( ovar:ao_bord)
            oVar:isedit := .f.
            aeval(oVar:ao_bord, {|x| x:hide()} )
          endif
        EndIf
      EndIf
    Endif
  Next
*
  For x := 1 TO Len( membORG)
    oVar := membORG[x]
    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        IF  EMPTY(  oVAR:Groups) .OR. ::cTypZvr = oVAR:Groups
          IF oVAR:ClassName() $ 'drgGet,drgComboBox,drgMLE,drgRadioButton,drgCheckBox'
            oVAR:IsEDIT := .t.
            if !isnil( oVAR:oXbp)
              oVAR:oXbp:Show()
            elseif !isnil( ovar:ao_bord)
              aeval(oVar:ao_bord, {|x| x:show()} )
            endif
            AADD( membCRD, oVar)
          ELSE
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ENDIF
        ELSEIf ! EMPTY( oVAR:Groups)
          If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
            oVar:pushGet:oxbp:hide()
          EndIf
        EndIf
      EndIf
    ELSE
      AADD( membCRD, oVar)
    ENDIF
  Next
  *
  For x := 1 To LEN( varsORG:values)
    IF ! IsNIL( varsORG:values[x, 2] )
      oVAR := varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox,drgRadioButton'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. ( oVar:Groups = ::cTypZvr )
          varsCRD:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ELSEIF oVAR:ClassName() $ 'drgMLE'
        varsCRD:add(oVar:oVar, oVar:oVar:name)
      ENDIF
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( membCRD)
    IF membCRD[x]:ClassName() = 'drgTabPage'
      membCRD[x]:onFormIndex := x
    ENDIF
  NEXT

  ::df:aMembers := membCRD
  ::dm:vars     := varsCRD
  /*
  IF ::cTypZvr = 'S'
    PostAppEvent(xbeP_Selected,.T.,,::dm:has('M->nPrenos'):oDrg:oXbp )
  ENDIF
  */
RETURN NIL

*-- Záznam s poè. stavem ------------------------------------------------------
STATIC FUNCT Rec_PocStav()
  Local cRecTXT

  cRecTXT := LEFT( RegZviPr->cFARMA, 8) +  ;                           //  1- 8 znak
             '01'+ STRZERO( RegZviPr->nObdobi, 2) + STRZERO( RegZviPr->nROK, 4) + ; //  9 - 16
             '29' + ;                                                  // 17-18
             PADL( ALLTRIM( STR( RegZviPr->nKusyPocSt)), 5, "0" ) + ;  // 19-23
             '00000000' + ;                                            // 24-31
             '000' + ;                                                 // 32-34
             PADL( ALLTRIM( STR( RegZviPr->nKusyPocSt)), 5, "0" ) + ;  // 35-39
             PADL( ALLTRIM( STR( RegZviPr->nKusyPocSt)), 5, "0" )      // 40-44
RETURN cRecTXT

*-- Sumace ---------------------------------------------------------------------
STATIC FUNCTION SumREGISTR( cScopeTOP, cScopeBOT )
  Local nKusySUM := 0, nKusyPocSt, cKEY

  SumREGw->( dbZAP())

  RegZviPr->( AdsSetOrder( 4) ,;
              mh_SetScope( cScopeTOP, cScopeBOT ),;
              dbGoTOP())
  nKusyPocSt := RegZviPr->nKusyPocSt
  RegZviPr->( mh_ClrScope())
  *

  RegZviPr->( AdsSetOrder( 3), dbGoTOP() )
  IF RegZviPr->nDrPohybP == 29       // vynecháme vìtu s poè. stavem
     RegZviPr->( dbSKIP())
  ELSE
  ENDIF
  cKEY := RegZviPr->( Sx_KeyDATA())
  DO WHILE !RegZviPr->( EOF())
    IF cKEY == RegZviPr->( Sx_KeyDATA())
      nKusySUM += RegZviPr->nKusy
    ELSE
      RegZviPr->( dbSKIP( -1))
      SumREGw->( dbAPPEND())
        mh_CopyFLD( 'RegZviPr', 'SumREGw' )
        SumREGw->nKusy      := nKusySUM
        SumREGw->nKusyPocSt := nKusyPocSt
        SumREGw->nKusyKonSt := nKusyPocSt + IF( SumREGw->nTypPohyb == 1, nKusySUM, -nKusySUM)
        nKusyPocSt := SumREGw->nKusyKonSt
      RegZviPr->( dbSKIP())
      cKEY     := RegZviPr->( Sx_KeyDATA())
      nKusySUM := RegZviPr->nKusy

    ENDIF
    RegZviPr->( dbSKIP())
  ENDDO
  RegZviPr->( dbGoBottom())
  SumREGw->( dbAPPEND())
    *PutITEM( 'SumREG', 'RegZviPr')
    mh_CopyFLD( 'RegZviPr', 'SumREGw' )
    SumREGw->nKusy      := nKusySUM
    SumREGw->nKusyPocSt := nKusyPocSt
    SumREGw->nKusyKonSt := nKusyPocSt + IF( SumREGw->nTypPohyb = 1, nKusySUM, -nKusySUM)
  SumREGw->( dbGoTOP())
RETURN NIL

*-- Sumace ---------------------------------------------------------------------
STATIC FUNCTION SumZvKarOBD( nROK, nOBD, cFARMA)
  Local nKusyKON := 0
  Local cTAG := ZvKarObd->( AdsSetOrder( 4))
  Local cKey := STRZERO( nROK, 4) + STRZERO( nOBD, 2) + Upper( 'V') + Upper( cFARMA)

  ZvKarOBD->( mh_SetScope( cKEY))
  DO WHILE !ZvKarOBD->( EOF())
    IF ZvKarOBD->nUcetSkup == 143
       nKusyKON += ZvKarOBD->nKusyKon
    ENDIF
    ZvKarOBD->( dbSKIP())
  ENDDO
  ZvKarOBD->( mh_ClrScope(), AdsSetOrder( cTAG))
RETURN nKusyKON

*-------------------------------------------------------------------------------
STATIC FUNCTION WriteOPIS( cRecTXT)
  Local nRadek := OpisTXT->nRadek
  OpisTXT->( dbAPPEND())
  OpisTXT->nRadek := nRadek + 1
  OpisTXT->cTEXT  := cRecTXT
RETURN NIL

*-------------------------------------------------------------------------------
STATIC FUNCTION WriteHLZMEN( nROKakt, nOBDakt, nKusyKon, lV09)
  LOCAL cALIAS := 'RegHlZME' // 'RegHlZMEw'

  DEFAULT lV09 TO NO
  IF ( nROKakt = SumREGw->nROK .AND. nOBDakt == SumREGw->nObdobi )
    ( cALIAS)->( dbAPPEND())
    mh_CopyFLD( 'SumREGw', cALIAS )
    IF lV09                    // závìreèná vìta 09
      ( cALIAS)->nKusyKonST := nKusyKON
      ( cALIAS)->nDrPohybP  := 9
      ( cALIAS)->nKusy      := 0
      ( cALIAS)->nKusyPocSt := 0
      ( cALIAS)->cFarmaZMN  := 'PRASNICE'
    ELSE
      ( cALIAS)->nKusyMinOb := nKusyKON
    ENDIF
  ENDIF
RETURN NIL

*-------------------------------------------------------------------------------
STATIC FUNCTION LastDayOM( Date)
  LOCAL nRET
  LOCAL aDAY := {31,28,31,30,31,30,31,31,30,31,30,31,29}

  IF VALTYPE( Date) = 'D'
    nRET := IF( Month(DATE) <> 2, Month(DATE), if(IsLeapYear(YEAR(Date)),13,2))
  ELSEIF VALTYPE( Date) = 'N'
    nRET := Date
  ENDIF

RETURN( aDAY[nRET])

*===============================================================================
FUNCTION UstEviFILE( dDatOD, dDatDO )
  Local nDP, nDPz, cFarma, cInvCis, cTm, cKEY
  Local dDatExpPL := DATE()

  drgDBMS:open( 'ZvZmenHD' )
  drgDBMS:open( 'ZvZmenIT' )
  drgDBMS:open( 'C_DrPohP' )
  drgDBMS:open( 'Firmy'    )
  drgDBMS:open( 'T_UstEVIw' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  ZvZmenIT->( dbGoTOP())
  DO WHILE !ZvZmenIT->( EOF())
     nDP  := ZvZmenIT->nDrPohybP
     nDPz := ZvZmenIT->nDrPohyb
     T_UstEviw->( dbAppend())
     T_UstEviw->cDruhZV    := '1'
     IF ( nDP == 30) .OR. ( nDP == 31)
        cFarma := STR( ZvZmenIT->nFarma, 10)
     ELSE
        cFarma := STR( ZvZmenIT->nFarmaODK, 10)
     ENDIF
     *                 30, 31  nfarmakam
     T_UstEviw->cFarmaODK  := cFarma
     T_UstEviw->cFarODKkrj := LEFT( cFarma, 2)
     T_UstEviw->cFarODKpod := SubSTR( cFarma, 3, 6)
     T_UstEviw->cFarODKstj := RIGHT( cFarma, 2)
     cInvCis := RIGHT( STR( ZvZmenIT->nInvCis, 10), 9)
     T_UstEviw->cInvCis    := ' ' + cInvCis
     T_UstEviw->cInvCisPor := LEFT( cInvCis, 6)
     T_UstEviw->cInvCisOkr := RIGHT( cInvCis, 3)
     T_UstEviw->cDrPohybP  := STR( ZvZmenIT->nDrPohybP, 2)

     T_UstEviw->dDatZmZv   := ZvZmenIT->dDatZmZv
     T_UstEviw->cDatZmZvDD := STRZERO( DAY( ZvZmenIT->dDatZmZv), 2)
     T_UstEviw->cDatZmZvMM := STRZERO( MONTH( ZvZmenIT->dDatZmZv), 2)
     T_UstEviw->cDatZmZvRR := RIGHT( STR( YEAR( ZvZmenIT->dDatZmZv), 4), 2)
     T_UstEviw->cPorod     := STR( ZvZmenIT->nPorod, 1)

     Do Case
       Case nDP == 30 .AND. nDPz >= 40 .AND. nDPz <= 45
         cTm := '  00' + STRZERO( ZvZmenIT->nFarmaODK, 10)
       Case nDP == 70 .AND. nDPz >= 80 .AND. nDPz <= 85
         cTm := '  00' + STRZERO( ZvZmenIT->nFarmaKAM, 10)
       Case nDP == 31
         cTm := '  00' + STRZERO( ZvZmenIT->nFarmaODK, 10)
       Case nDP == 71
         cTm := '  00' + STRZERO( ZvZmenIT->nFarmaKAM, 10)
       Case nDP == 50 .OR. nDP == 60 .OR. nDP == 30 .OR. nDP == 70
         cTm := '  00' + STRZERO( ZvZmenIT->nCisREG, 10)
       Case nDP == 21 .OR. nDP == 22
         cTm := 'CZ00' + STRZERO( ZvZmenIT->nInvCisMat, 10)
       Case nDP == 80 .OR. nDP == 11 .OR. nDP == 12
         cKEY := StrZERO( ZvZmenIT->nRok,4) + StrZERO( ZvZmenIT->nObdobi,2) + StrZERO( ZvZmenIT->nDoklad,10)
         ZvZmenHD->( dbSEEK( cKEY,,'ZVZMENHD08'))
         Firmy->( dbSEEK( ZvZmenHD->nCisFirmy,, 'FIRMY1'))
         cTm := '  000000000' + Firmy->cZkratStat
       OtherWise
         cTm := SPACE( 14)
     EndCase
     T_UstEviw->cTmOdkKamM := cTm

     cTm                   := T_UstEviw->cTmOdkKamM
     T_UstEviw->cTm1_krj   := SubSTR( cTm, 5, 2)
     T_UstEviw->cTm2_pod   := SubSTR( cTm, 7, 6)
     T_UstEviw->cTm3_stj   := RIGHT( cTm, 2)
     T_UstEviw->dDatVytvor := DATE()
     T_UstEviw->cDatVytDD  := STRZERO( DAY(   DATE() ), 2)
     T_UstEviw->cDatVytMM  := STRZERO( MONTH( DATE() ), 2)
     T_UstEviw->cDatVytRR  := RIGHT( STR( YEAR( DATE()), 4), 2)
     C_DrPohP->( dbSEEK( nDP,, 'DRPOHP1'))
     T_UstEviw->cText     := C_DrPohP->cNazevPOH
     *
     IF !IsNIL( dDatOD)
       IF ( ZvZmenIT->dDatZmZv >= dDatOD .AND. ZvZmenIT->dDatZmZv <= dDatOD ;
            .AND. ZvZmenIT->nDrPohybP <> 0  )
         IF ZvZmenIT->( dbRLock())
           ZvZmenIT->dDatExpPL := dDatExpPL
           ZvZmenIT->( dbRUnlock())
         ENDIF
       ENDIF
     ENDIF
     *
     ZvZmenIT->( dbSkip())
  ENDDO
RETURN Nil

*===============================================================================
FUNCTION ZVI_ZVKAROBD()
  Local StavyObd

  drgDBMS:open('ZVKARTY')
  StavyObd            := ZVI_zsbStavyObd_SCR():new()
  StavyObd:oneZvKarty := .F.           // generovat za všechny položky ZVKARTY
  *
  drgServiceThread:progressStart(drgNLS:msg('Generuji stavy za období ' + uctObdobi:ZVI:cObdobi + ' ...', 'ZVKARTY'), ZVKARTY->(LASTREC()) )

  ZvKarOBDw->( dbZAP())
  ZvKarty->( dbGoTOP())
  DO WHILE !ZvKarty->( EOF())
    StavyObd:createKUMUL()
    ZvKarty->( dbSkip())
    drgServiceThread:progressInc()
  ENDDO
  *
  drgServiceThread:progressEnd()
  *
  StavyObd:copyToKumul( .F.)

RETURN NIL