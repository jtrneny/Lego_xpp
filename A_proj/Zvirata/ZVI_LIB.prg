********************************************************************************
*  ZVI_LIB.PRG
********************************************************************************

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "dbstruct.ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

********************************************************************************
CLASS ZVI_Main

EXPORTED:
  VAR     cAktOBD, nAktOBD, nAktROK
  VAR     cUserAbb, cDenikZvZ, nDpVzrust, nRoundOdpi
  METHOD  Init, Destroy

ENDCLASS

********************************************************************************
METHOD ZVI_Main:init(parent)
  ::cAktOBD  := uctOBDOBI:ZVI:cObdobi
  ::nAktOBD  := uctOBDOBI:ZVI:nObdobi
  ::nAktROK  := uctOBDOBI:ZVI:nRok
  *
  ::cUserAbb   := SysConfig( 'System:cUserAbb')
  ::cDenikZvZ  := SysConfig( 'Zvirata:cDenikZvZ')
  ::nDpVzrust  := SysConfig( 'Zvirata:nDpVzrust')
  ::nRoundOdpi := SysConfig( 'Zvirata:nRoundOdpi')
RETURN self

********************************************************************************
METHOD ZVI_Main:destroy()
  ::cAktOBD   := ::nAktOBD   := ::nAktROK   :=  ;
  ::cUserAbb  := ::cDenikZvZ := ::nDpVzrust := ::nRoundOdpi := ;
  NIL
RETURN self

*===============================================================================
FUNCTION ZVI_ZVKARTY_INFO( oDlg)
  LOCAL oDialog
  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  IF EMPTY( ZVKarty->nZvirKat)
    drgMsgBox(drgNLS:msg( 'Karta zvíøete není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  DRGDIALOG FORM 'ZVI_zsbZvKarty_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Karta zvíøete - INFO') MODAL DESTROY
  *
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
RETURN NIL

*===============================================================================
FUNCTION ZVI_KATEGZVI_INFO( oDlg)
  LOCAL oDialog
  LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  IF EMPTY( KategZvi->nZvirKat)
    drgMsgBox(drgNLS:msg( 'Karta kategorie zvíøete není k didpozici ...' ))
    RETURN NIL
  ENDIF
  *
  DRGDIALOG FORM 'ZVI_KategZvi_CRD' PARENT oDlg CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Kategorie zvíøete - INFO') MODAL DESTROY
  *
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
RETURN NIL

* Pøednastavení èísla dokladu
*===============================================================================
FUNCTION ZVI_NewDOKL()
  Local nDoklad, cTop := '0000000000', cBot := '0000899998'

  drgDBMS:open( 'ZvZmenHD',,,,, 'ZvZmenHD_a')
  ZvZmenHD_a->( AdsSetOrder( 3))
  ZvZmenHD_a->( mh_SetScope( cTop, cBot), dbGoBottom()  )
  nDoklad := ZvZmenHD_a->nDoklad + 1
  ZvZmenHD_a->( dbCloseArea())
RETURN nDoklad

*  Pro požadovanou stáj zjistí èíslo farmy
*===============================================================================
FUNCTION ZVI_CisFARMY( cNazPol4, lSEEK, nPOL, nKARTA )
  Local nFARMA := 0, nOBEC := 0

  IF IsNull( nKARTA)
    nKARTA := ZvZmenHD->nKarta
  ENDIF
  IF nKARTA == 600 .OR. nKARTA == 610 .OR. nKARTA == 620 .OR. lSEEK
     drgDBMS:open('C_FarmyV' )
     C_FarmyV->( dbSEEK( Upper( cNazPol4),, 'FARMYV_1'))
     nFARMA := C_FarmyV->nFARMA
     nOBEC  := C_FarmyV->nOBEC
  ENDIF
RETURN( IF( nPOL == 1, nFARMA, nOBEC))

*===============================================================================
FUNCTION ZVI_CisRegFIR()
  Local nCisREG := 0

  IF ZvZmenHD->nCisFirmy <> 0
     drgDBMS:open('FIRMY',,,,, 'FIRMYa' )
     FIRMYa->( dbSEEK( ZvZmenHD->nCisFirmy,,'FIRMY1'))
     nCisREG := FIRMYa->nCisREG
  ENDIF
RETURN nCisREG

* Výpoèet skladové ceny zvíøete
*===============================================================================
FUNCTION ZVI_SkladCENA( cTypVypCEN)
  Local nCenas, nRound := 3  // DecCenaS()
  Local nMnoz := If( KategZvi->nTypVypCEL = 1, ZvKarty->nMnozsZV, ZvKarty->nKusyZV)

  Do Case
    Case Upper( cTypVypCEN) == 'PEV'
         nCenas := ZvZmenHd->nCenasZV
    Case Upper( cTypVypCEN) == 'PRU'
         nCenas := If( ZvKarty->nCenacZV <> 0 .and. nMnoz <> 0    ,;
                       Round( ZvKarty->nCenacZV / nMnoz, nRound ) ,;
                       ZvKarty->nCenasZV                           )
    OtherWise
         nCenas  := ZvKarty->nCenasZV
  EndCase

RETURN nCenas

* prevalidaèní funkce pøed založením období
*===============================================================================
FUNCTION ZVI_preAppendObdobi( oDlg)
  Local lOK := HIM_preAppendObdobi( oDlg, 'ZVI')

RETURN lOK

*===============================================================================
FUNCTION ZVI_postAppendObdobi( oDlg)

  * Základní stádo - udìlá totéž, co pøi založení období v HIM
  *  - odloží MAJz do MAJzOBD ,  - vygeneruje odpisy pro zakládané období

  oSession_data:beginTransaction()
  BEGIN SEQUENCE
    HIM_postAppendObdobi( oDlg, 'ZVI')
    ZVI_ZvKarty_ps( oDlg)              // zásoby, aktualizace poè. stavù
    ZVI_KDforOBD( oDlg)                // generuje krmné dny za období

    oSession_data:commitTransaction()

  RECOVER USING oError
    oSession_data:rollbackTransaction()

    * musíme zrušit obdbobí pro ZVI - padlo to
    if ucetSys->(sx_Rlock())
       ucetSys->(dbdelete(), dbcommit(), dbunlock())
    endif
  END SEQUENCE


RETURN NIL

* Pøi založení 1.období založit záznam s poè.stavem
*===============================================================================
FUNCTION  ZVI_ZvKarty_ps( oDlg)
  Local nCount, lLock, lZvKar, lZvKar_ps, lSeek
  Local newObdobi := oDlg:udcp:o_Obdobi:value
  LOCAL newRok    := oDlg:udcp:o_Rok:value
*  Local cOBDOBI   := STRZERO( nNewObdobi, 2) + '/' + RIGHT( STR( nNewRok, 4), 2 )
  Local cKey

  drgDBMS:open( 'ZvKarty'   )
  drgDBMS:open( 'ZvKarty_ps')
  *
  IF newObdobi = 1          // na poè. roku
    ZvKarty->( dbGoTop())
    lZvKar    := ZvKarty->( FLock())
    lZvKar_ps := ZvKarty_ps->( FLock())
    lLock     := ( lZvKar .and. lZvKar_ps )

    IF lLock
      nCount := ZvKarty->( mh_COUNTREC())
        *
      drgServiceThread:progressStart(drgNLS:msg('Generuji poèáteèní stavy pro rok [ ' + Str( newRok) + ' ]  ...', 'ZvKarty'), nCount  )

      DO WHILE !ZvKarty->( Eof())
        * aktualizace poè.hodnot na kartì zvíøete
        ZvKarty->nCenaPocZV  := ZvKarty->nCenacZV
        ZvKarty->nMnozPocZV  := ZvKarty->nMnozsZV
        ZvKarty->nKusyPocZV  := ZvKarty->nKusyZV
        ZvKarty->nKdPocZV    := 0    //  ZvKarty->nKd
        * aktualizace souboru poè. stavù
        cKey := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) +;
                StrZero( ZvKarty->nZvirKat, 6) + StrZero( newRok, 4)
        lSeek := ZvKarty_ps->( dbSeek( cKey,, 'ZVKARPS_01'))
*        IF( lSeek, ReplREC('ZvKarty_ps'), AddRec( 'ZvKarty_ps'))
        IF lSeek
          ZvKarty_ps->nCenaPocZV  := ZvKarty->nCenaPocZV
          ZvKarty_ps->nMnozPocZV  := ZvKarty->nMnozPocZV
          ZvKarty_ps->nKusyPocZV  := ZvKarty->nKusyPocZV
          ZvKarty_ps->nKdPocZV    := ZvKarty->nKdPocZV
        ELSE
          ZvKarty_ps->( dbAppend())
          mh_CopyFld( 'ZvKarty', 'ZvKarty_ps')
          ZvKarty_ps->nRok := newRok
        ENDIF
        ZvKarty->( dbSkip())
        *
        drgServiceThread:progressInc()
      ENDDO
      *
      drgServiceThread:progressEnd()
      *
      if .not. oSession_data:inTransaction()
        ZvKarty->( dbUnlock())
        ZvKarty_ps->( dbUnlock())
      endif
    ELSE

    ENDIF
  ENDIF
RETURN NIL

*===============================================================================
FUNCTION  ZVI_KDforOBD( oDlg)
  Local nRec, nRec1, nRec2, nPorZmeny, nCount
  Local newObdobi := oDlg:udcp:o_Obdobi:value
  LOCAL newRok    := oDlg:udcp:o_Rok:value
  Local cOBDOBI   := STRZERO( NewObdobi, 2) + '/' + RIGHT( STR( NewRok, 4), 2 )
  Local dDateForKD := CTOD( '01.' + LEFT(cObdobi, 2) + '.' + RIGHT(cObdobi, 2))
  Local nDaysInMonth := mh_LastDayOM( dDateForKD)
  Local cDenikZvZ := SysConfig( 'Zvirata:cDenikZvZ'), cKey
  Local cUserAbb  := SysConfig( 'System:cUserAbb')
  Local lLock, lProdukce := NO, lOK, uctLikv


  drgDBMS:open('ZvKarty'  )
  cTag := ZvKarty->( AdsSetOrder( 0))
  drgDBMS:open('C_TypPoh' )
  drgDBMS:open('c_typPoh',,,,,'c_typPohA' )

  drgDBMS:open('KategZvi' )
  drgDBMS:open('C_DrPohZ' )   // doèasnì
  drgDBMS:open('ZvZmenHD' )
  drgDBMS:open('ZvZmenHD',,,,, 'ZvZmenHDa' )
  ZvZmenHDa->( AdsSetOrder( 3))

  if c_typPohA->( dbSEEK( Z_DOKLADY + '95',, 'C_TYPPOH02'))
    lProdukce := c_typPohA->lProdukce
  endif

  ZvKarty->( dbGoTop())
  IF lLock := ZvKarty->( FLock())
*    IF drgIsYesNO(drgNLS:msg('Požadujete vygenerovat krmné dny za období ?'))

      nCount := ZvKarty->( mh_COUNTREC())
        *
      drgServiceThread:progressStart(drgNLS:msg('Generuji krmné dny za období [ ' + cObdobi + ' ]  ...', 'ZvKarty'), nCount  )

      DO WHILE !ZvKarty->( Eof())
        nPorZmeny := ZVI_GetPorZME()
**        If AddRec( 'ZvZmenHD')
           mh_CopyFld( 'ZvKarty', 'ZvZmenHD', .t.)
           ZvZmenHD->cDenik     := cDenikZvZ
           ZvZmenHD->nRok       := newRok      // uctObdobi:ZVI:nROK    //  GetROK()
           ZvZmenHD->nObdobi    := newObdobi   // uctObdobi:ZVI:nObdobi // GetOBD()
           ZvZmenHD->cObdobi    := cObdobi     // StoreOBD()
           ZvZmenHD->nKD        := nDaysInMonth * ZvZmenHD->nKusyZv
           ZvZmenHDa->( dbGoBottom())
           ZvZmenHD->nDoklad    := IF( ZvZmenHDa->nDoklad < 900000, 900000, ZvZmenHDa->nDoklad + 1 )
  *         ZvZmenHD->nDoklad    := GenDoklKD()
           ZvZmenHD->nOrdItem   := 0
           ZvZmenHD->nDrPohyb   := 95
           ZvZmenHD->nTypPohyb  := 1
           ZvZmenHD->lProdukce  := lProdukce
           KategZvi->( dbSeek( ZvZmenHD->nZvirKAT,, 'KATEGZVI_1'))
           ZvZmenHD->nTypVypCel := KategZvi->nTypVypCel
           ZvZmenHD->nCenaSZV   := IF( KategZvi->lVzrust, ZvKarty->nCenaV2ZV, 0 )
           ZvZmenHD->nCenaCZV   := ZvZmenHD->nCenasZV * ZvZmenHD->nKD
           ZvZmenHD->dDatPoriz  := DATE()
           ZvZmenHD->dDatZmZv   := DATE()
           ZvZmenHD->cUserAbb   := cUserAbb
           ZvZmenHD->dDatZmeny  := DATE()
           ZvZmenHD->cCasZmeny  := TIME()
           ZvZmenHD->cUloha     := 'Z'   //Uloha()
           ZvZmenHD->nPorZmeny  := nPorZmeny
           ZvZmenHD->nKusyZV    := 0
           ZvZmenHD->nMnozsZV   := 0
           ZvZmenHD->cFARMA     := PADR( ALLTRIM( STR( ZVI_CisFARMY( ZvZmenHD->cNazPol4, YES, 1 ) )), 10)
           *
           cKEY := Z_DOKLADY +  ALLTRIM( STR( ZvZmenHD->nDrPohyb ))
           lOK  := c_typPohA->( dbSEEK( cKEY,, 'C_TYPPOH02'))
           ZvZmenHD->cTypDoklad := IF( lOK, c_typPohA->cTypDoklad, '???' )
           ZvZmenHD->cTypPohybu := IF( lOK, c_typPohA->cTypPohybu, '???' )
           *
           mh_WRTzmena( 'ZvZmenHD', .T.)
           *
           * Aktualizace ZvKarty
           ZvKarty->nKD         := IF( ZvZmenHD->nObdobi == 1, ZvZmenHD->nKD,;
                                                               ZvKarty->nKD + ZvZmenHD->nKD )
           ZvKarty->nCenaCZV    += ZvZmenHD->nCenaCZV
           ZvKarty->nCenaSZV    := IF( ZvZmenHD->nCenaCZV <> 0 ,;
                                       ZVI_SkladCENA( ZvKarty->cTypVypCen),;
                                       ZvKarty->nCenaSZV )
           ZvKarty->nKdPocZv    := IF( ZvZmenHD->nObdobi == 1, 0, ZvKarty->nKdPocZv)
           *
**?         M_ZvKarObd( K_INS, ZvZmenHD->nTypPohyb)  //Ä ZvKarObd ... Kumulativn¡ soubor
**?         M_ZvZmObd( K_INS)                        //Ä ZvZmObd  ... Kumulativn¡ soubor

           uctLikv := UCT_likvidace():New(Upper( ZvZmenHD->cUloha) + Upper( ZvZmenHD->cTypDoklad),.T.)
           *
           if .not. oSession_data:inTransaction()
             ZvZmenHD->( dbUnlock())
           endif

**        Endif
        ZvKarty->( dbSkip())
        *
        drgServiceThread:progressInc()
      ENDDO
      *
      drgServiceThread:progressEnd()
*      drgMsgBox(drgNLS:msg( 'Krmné dny za období  [ & ] byly vygenerovány !', cObdobi))
      *
      if .not. oSession_data:inTransaction()
        ZvKarty->( dbUnlock(), AdsSetOrder( cTag))
      else
        ZvKarty->( AdsSetOrder( cTag))
      endif


*    ENDIF
  ELSE

  ENDIF
RETURN NIL

*===============================================================================
FUNCTION ZVI_UcetPOL_DEL( lPrevodZS)
  Local cDenik  := PadR( SysConfig( 'Zvirata:cDenikZvZ'), 2 ), lOK := .F.
  Local cMainKEY := Upper(cDenik ) + StrZero( ZvZmenHD->nDoklad, 10) + ;
                    StrZero( ZvZmenHD->nOrdItem, 5)

  DEFAULT lPrevodZS to .F.
  IF lPrevodZS
    cDenik  := PadR( SysConfig( 'Zvirata:cDenikZv'), 2 )
    cMainKEY := Upper(cDenik ) + StrZero( ZMajuZ->nDoklad, 10) + ;
                    StrZero( ZMajuZ->nOrdItem, 5)
  ENDIF
  *
  drgDBMS:open('UcetPOL',,,,, 'UcetPOLa')
  DO WHILE UcetPOLa->( dbSeek( cMainKEY,, 'UCETPOL1'))
    IF cDENIK == UcetPOLa->cDenik  // úloha ZVÍØATA má dva deníky !!!
       DelRec( 'UcetPOLa')
    ENDIF
    lOK := .T.
  ENDDO
  *
RETURN NIL

********************************************************************************
CLASS ZVI_zsbMODI
********************************************************************************

EXPORTED:
  VAR     parent, nEvent, nKarta, lNewREC, lVzrust, nDpVzrust

  METHOD  Init, Destroy
  METHOD  genVZRUST, genPrevod
  METHOD  m_Zvirata, m_ZvKarty, m_ZvKarObd, m_ZvZmObd, m_ZaklStado

HIDDEN
  METHOD  isProdukce, MajCMP

ENDCLASS

********************************************************************************
METHOD ZVI_zsbMODI:init(parent)

  ::parent := parent
  IF parent:drgDialog:formName = 'Zvi_zsbPohyby_crd'
    ::nEvent    := parent:nEvent
    ::nKarta    := parent:nKarta
    ::lNewREC   := parent:lNewREC
    ::lVzrust   := parent:lVzrust
    ::nDpVzrust := parent:nDpVzrust
*  ELSEIF parent:drgDialog:formName = 'Zvi_zsbZvKarty_scr'
*    ::nEvent    := drgEVENT_DELETE
  ENDIF

RETURN self

********************************************************************************
METHOD ZVI_zsbMODI:destroy()
  ::parent := ::nEvent := ::nKarta := ::lNewREC := lVzrust := ::nDpVzrust := ;
  NIL
RETURN self

*  Generuje "dvojkovì" záznamy se vzrùstovým pøírùstkem
********************************************************************************
METHOD ZVI_zsbMODI:GenVzrust( nOrdItem)
  Local nRec := ZvZmenHD->( RecNo())
  Local anKarty := { 400, 410, 420, 430, 431, 500, 510, 511, 513, 600, 610, 620, 206 }
  Local nPos := ASCAN( anKarty, ::nKARTA ), lOK
  Local cKey := StrZero( ZvZmenHD->nDoklad, 10) + StrZero( nOrdItem, 5)
  Local uctLikv


  drgDBMS:open( 'ZvZmenHDw'  ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'ZvZmenHDw2' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  If nPos > 0      // Záznam se generuje pro specifikované typy karet
    If ::lVzrust   // ( lOK := KatVZRUST() ) // Kategorie má nastaveno generování pøírùstku
      mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw', .T.)
      If( lOK := If( ::lNewRec, YES, ZvZmenHd->( dbSeek( cKey,,'ZVZMENHD03')) ))
        If( !::lNewRec,  mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw2', .t.) , Nil )
        If( lOK := If( ::lNewRec, AddRec( 'ZvZmenHD'), ReplRec( 'ZvZmenHd') ) )
          mh_CopyFld( 'ZvZmenHDw', 'ZvZmenHD' )
          ZvZmenHD->nOrdItem   := nOrdItem
          ZvZmenHD->nDrPohyb   := ::nDpVzrust
          ZvZmenHD->lProdukce  := ::isProdukce( ::nDpVzrust)   // GETprodukce( nDpVzrust)
          ZvZmenHD->cTypVypCen := 'PRU'      // vždy prùmìrná cena
          ZvZmenHD->nTypVypCel := 1
          ZvZmenHD->nCenasZV   := ZvKarty->nCenav2ZV
          ZvZmenHD->nCenacZV   := ZvZmenHd->nCenasZV * ZvZmenHd->nKD
          ZvZmenHD->nMnozsZV   := 0
          ZvZmenHD->nKusyZV    := 0
          ZvZmenHD->nPorZmeny  -= 1
          ZvZmenHD->nKdHlp     := ZvZmenHD->nKd
          ZvZmenHD->nKd        := 0
          *
          drgDBMS:open('c_typPoh',,,,,'c_typPohA' )
          cKEY := Z_DOKLADY +  ALLTRIM( STR( ZvZmenHD->nDrPohyb ))
          lOK  := C_TypPOHA->( dbSEEK( cKEY,, 'C_TYPPOH02'))
          ZvZmenHD->cTypDoklad := IF( lOK, C_TypPohA->cTypDoklad, '???' )
          ZvZmenHD->cTypPohybu := IF( lOK, C_TypPohA->cTypPohybu, '???' )
          *
          * Aktualizace souborù
          ::M_ZvKarty()     // nKey)
**          ::M_ZvKarObd( ::parent:nEvent, ZvZmenHD->nTypPohyb)
**          ::M_ZvZmObd( ::parent:nEvent)            //Ä ZvZmObd  ... Kumulativn¡ soubor

          uctLikv := UCT_likvidace():New(Upper( ZvZmenHD->cUloha) + Upper( ZvZmenHD->cTypDoklad),.T.)
          *
          ZvZmenHD ->( dbUnlock())
          C_TypPOHa->( dbCloseArea())
        Endif
      Endif
    Endif
  Endif
  ZvZmenHd->( dbGoTo( nRec))
  /*
  If !::lNewRec
    ZvZmenHDw2->( dbZAP())
    mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw2', .t.)
  ENDIF
  */
RETURN self

* Generuje pøíjmové záznamy pøi pøevodu
********************************************************************************
METHOD ZVI_zsbMODI:genPrevod()

  Local nRec := ZvZmenHD->( RecNo()), cTag // := ZvZmenHd->( AdsSetOrder( 3))
  Local nRecZv := ZvKarty->( RecNo())
  Local anKarty := { 600, 610, 620 }
  Local nPos := ASCAN( anKarty, ::nKARTA ), lOK
  Local cNazPol1, cNazPol2, cNazPol4, nZvirKat
  Local cKey := Upper( ZvZmenHD->cNazPol1_N) + Upper( ZvZmenHD->cNazPol4_N) + ;
                StrZero( ZvZmenHD->nZvirKAT_N, 6)
  Local uctLikv

  drgDBMS:open( 'ZvZmenHDw'  ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP
  drgDBMS:open( 'ZvZmenHDw2' ,.T.,.T.,drgINI:dir_USERfitm) ; ZAP

  If nPos > 0   // Záznam se generuje pro pøevodové karty
    * Napozicuje se na cílovou ZvKartu
    ZvKarty->( dbSeek( cKey,, 'ZVKARTY_01'))
    IF ZvZmenHD->( dbRLock())
       ZvZmenHD->nUcetSkupN := ZvKarty->nUcetSkup
       ZvZmenHD->( dbRUnlock())
    ENDIF

    cKey := StrZero( ZvZmenHD->nDoklad, 10) + StrZero( zm_PREVOD_PRIJEM, 5)
    mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw', .T.)
    If( lOK := If( ::lNewRec, YES, ZvZmenHd->( dbSeek( Upper( cKey,, 'ZVZMENHD03'))) ))
      If( !::lNewRec,  mh_CopyFld( 'ZvZmenHD', 'ZvZmenHDw2', .t.) , Nil )
      If( lOK := If( ::lNewRec, AddRec( 'ZvZmenHD'), ReplRec( 'ZvZmenHd') ) )
        mh_CopyFld( 'ZvZmenHDw', 'ZvZmenHD' )
        cNazPol1   := ZvZmenHD->cNazPol1
        cNazPol4   := ZvZmenHD->cNazPol4
        nZvirKat   := ZvZmenHD->nZvirKat
        cNazPol2   := ZvZmenHD->cNazPol2
        ZvZmenHD->cNazPol1   := ZvZmenHD->cNazPol1_N
        ZvZmenHD->cNazPol4   := ZvZmenHD->cNazPol4_N
        ZvZmenHD->nZvirKat   := ZvZmenHD->nZvirKat_N
        ZvZmenHD->cNazPol2   := ZvZmenHD->cNazPol2_N
        ZvZmenHD->cNazPol1_N := cNazPol1
        ZvZmenHD->cNazPol4_N := cNazPol4
        ZvZmenHD->nZvirKat_N := nZvirKat
        ZvZmenHD->cNazPol2_N := cNazPol2
        ZvZmenHD->nUcetSkupN := 0
        *
        ZvZmenHD->nKlikvid   := 0
        ZvZmenHD->nZlikvid   := 0
        *
        ZvZmenHD->nOrdItem   := zm_PREVOD_PRIJEM
        ZvZmenHD->nDrPohyb   := IIf( ZvZmenHd->nKarta == 600, 40,;
                                  IIF( ZvZmenHD->nKarta == 610, 41, 42 ))
        ZvZmenHD->lProdukce  := ::isProdukce( ZvZmenHD->nDrPohyb)   // GETprodukce( ZvZmenHD->nDrPohyb)
        ZvZmenHD->nTypPohyb  := 1
        IF ZvZmenHD->nKarta == 610
          ZvZmenHD->nCenaSZV := 0
          ZvZmenHD->nCenaCZV := 0
        ENDIF
        ZvZmenHD->lZmenaZAKL := YES
        *
        ZvZmenHD->cFarma     := PADR( ALLTRIM( STR( ZVI_CisFARMY( ZvZmenHD->cNazPol4, YES, 1 ))), 10)
        *
        * 7.6.2011 C_DrPohZ->( dbSEEK( ZvZmenHD->nDrPohyb,, 'DRPOHZ1'))
        drgDBMS:open('c_typPoh',,,,,'c_typPohA' )
        cKEY := Z_DOKLADY +  ALLTRIM( STR( ZvZmenHD->nDrPohyb ))
        C_TypPOHA->( dbSEEK( cKEY,, 'C_TYPPOH02'))

        IF ZvZmenHD->cTypZVR == 'V'
           ZvZmenHD->nDrPohybP := C_TypPOH->nDrPohPlPr
        ENDIF
        * Napozicuje se na cílovou ZvKartu
        cKey := Upper( ZvZmenHD->cNazPol1) + Upper( ZvZmenHD->cNazPol4) + ;
                StrZero( ZvZmenHD->nZvirKat, 6)
        ZvKarty->( dbSeek( cKey,, 'ZVKARTY_01'))
        *
        ZvZmenHD->nPorZmeny  := ZVI_GetPorZME()
        ZvZmenHD->nUcetSkup  := ZvKarty->nUcetSkup
        * 1.4.2008
        cKEY := Z_DOKLADY +  ALLTRIM( STR( ZvZmenHD->nDrPohyb ))
        lOK  := C_TypPOHA->( dbSEEK( cKEY,, 'C_TYPPOH02'))
        ZvZmenHD->cTypDoklad := IF( lOK, C_TypPohA->cTypDoklad, '???' )
        ZvZmenHD->cTypPohybu := IF( lOK, C_TypPohA->cTypPohybu, '???' )

        * Aktualizace souborù
        ::M_Zvirata()
        ::M_ZvKarty()
*=        ::M_ZvKarObd( nKey, ZvZmenHD->nTypPohyb)
*=        ::M_ZvZmObd( nKey)            //Ä ZvZmObd  ... Kumulativn¡ soubor

        IF ( ZvZmenHD->nKarta = 600 .OR. ZvZmenHD->nKarta = 620 )
          uctLikv := UCT_likvidace():New(Upper( ZvZmenHD->cUloha) + Upper( ZvZmenHD->cTypDoklad),.T.)
        ENDIF
        *
        ZvZmenHD->( dbUnlock())
        *
        If KategZvi->( dbSeek( ZvZmenHD->nZvirKAT,, 'KATEGZVI_1'))
          ::lVzrust := KategZvi->lVzrust
        EndIf

        ::GenVZRUST( zm_PREVOD_VZRUST)     // 4 ... Vzrùstový pøírùstek pro pøíjmovì pohyby
        ZvKarty  ->( dbGoTo( nRecZv))
        IF( Select('C_TypPOHa') <> 0, C_TypPOHa->( dbCloseArea()), NIL )
*=        C_TypPOHa->( dbCloseArea())
      Endif
    Endif
  Endif
  ZvZmenHd->( dbGoTo( nRec))
RETURN self

* Modifikace souborù : Zvirata, ZvZmenIT
********************************************************************************
METHOD ZVI_zsbMODI:m_Zvirata()    // nKEY)
  Local cKey := Upper( ZvKarty->cTypZvr ), cInvCis, cKeyIT, cTAG, cFARMA, cKeyHLP
  Local aInvCis, nLen, N, nCisREG, nOrd
  Local nFarmaODK, nFarmaKAM, nObecODK, nObecKAM, nObecO, nObecK, nKARTA
  Local nREC := ZvZmenHD->( RecNO()), nPorCisLis, nPorCisRad
  Local lExist, lOK
  Local nRadRegSko := SysConfig( 'Zvirata:nRadRegSko')
  Local lKartaOK := ( ZvZmenHD->nKarta <> 440) .and. ( ZvZmenHD->nKarta <> 512) .and. ;
                    ( ZvZmenHD->nKarta <> 450 )
  STATIC  nFarODK_3, nFarKAM_3, nObecODK_3, nObecKAM_3

  *
  IF UPPER( ZvKarty->cTypEvid) == 'I' .and. lKartaOK
    drgDBMS:open('Zvirata'  )
    drgDBMS:open('ZvZmenIT' )
    drgDBMS:open('C_DrPohZ' ) // doèasnì
    drgDBMS:open('C_TypPOH' )

    IF (::nEvent = drgEVENT_DELETE)
      *
      cTag := ZvZmenIT->( AdsSetOrder( 2))
      ZvZmenIT->( mh_SetSCOPE( StrZERO( ZvZmenHD->nDoklad, 10)))
      DO WHILE !ZvZmenIT->( EOF())
         If ZvZmenHD->nKarta <> 610
           ZvZmenIT->( dbRLock(), dbDelete(), dbRUnlock())
         Endif
         ZvZmenIT->( dbSkip())
      ENDDO
      ZvZmenIT->( mh_ClrSCOPE(), AdsSetOrder( cTag))
      *
    ELSE
      aInvCis := {}
      nLen := ZvZmenITw->( LastRec())
      IF nLen > 0
        nCisREG   := ZVI_CisRegFIR()

        IF ZvZmenHD->nOrdItem <> 3
           nFarmaODK := ZVI_CisFARMY( ZvZmenHD->cNazPol4  , YES, 1)
           nObecODK  := ZVI_CisFARMY( ZvZmenHD->cNazPol4  , YES, 2)
           nFarmaKAM := ZVI_CisFARMY( ZvZmenHD->cNazPol4_N,  NO, 1 )
           nObecKAM  := ZVI_CisFARMY( ZvZmenHD->cNazPol4_N,  NO, 2 )
           IF ZvZmenHD->nOrdItem == 1
              nFarODK_3  := nFarmaODK
              nFarKAM_3  := nFarmaKAM
              nObecODK_3 := nObecODK
              nObecKAM_3 := nObecKAM
           ENDIF
        ENDIF

        FOR N := 1 TO nLen
          ZvZmenITw->( dbGoTO( N))
          * Aktualizace ZvZmenIT
          nOrd   := IF( ZvZmenHD->nOrdItem == 3, 1000 + N, N )
          cKeyIT := StrZero( ZvZmenHD->nDoklad, 10) + StrZero( nOrd, 5)
          lExist := ZvZmenIT->( dbSeek( cKeyIT,,'ZVZMENIT02'))
          lOK := IF( lExist, ReplRec( 'ZvZmenIT'), AddRec( 'ZvZmenIT'))
          IF lOK
             mh_CopyFld( 'ZvZmenHD', 'ZvZmenIT')
             ZvZmenITw->_nrecor   := ZvZmenIT->( recno())
             ZvZmenIT->nOrdItem   := nOrd
             ZvZmenIT->nInvCis    := ZvZmenITw->nInvCis
             ZvZmenIT->cZvireZem  := ZvZmenITw->cZvireZem
             ZvZmenIT->dNarozZvir := ZvZmenITw->dNarozZvir
             ZvZmenIT->nPorod     := ZvZmenITw->nPorod
             ZvZmenIT->nPohlavi   := ZvZmenITw->nPohlavi
             ZvZmenIT->cPlemeno   := ZvZmenITw->cPlemeno
             ZvZmenIT->cMatkaZem  := ZvZmenITw->cMatkaZem
             ZvZmenIT->nInvCisMat := ZvZmenITw->nInvCisMat

             ZvZmenIT->nCisREG    := nCisREG
             ZvZmenIT->nFarmaODK  := IF( ZvZmenHD->nOrdItem == 3, nFarODK_3, nFarmaODK )
             ZvZmenIT->nFarmaKAM  := IF( ZvZmenHD->nOrdItem == 3, nFarKAM_3, nFarmaKAM )
             * Plemenáøi
             * 7.6.2011  C_DrPohZ->( dbSEEK( ZvZmenIT->nDrPohyb,,'DRPOHZ1'))
             cKEY := Z_DOKLADY +  ALLTRIM( STR( ZvZmenIT->nDrPohyb ))
             C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))

             IF ZvZmenIT->nFarmaKAM == 0 .OR. ;
               ( ZvZmenIT->nFarmaKAM <> 0 .AND. ZvZmenIT->nFarmaODK <> ZvZmenIT->nFarmaKAM )
               IF C_TypPOH->nPodm == 1
                 ZvZmenIT->nDrPohybP := C_TypPOH->nDrPohPL1
               ELSEIF C_TypPOH->nPodm == 2   // dle pohlaví
                 ZvZmenIT->nDrPohybP := IF( ZvZmenIT->nPohlavi == 1,;
                                            C_TypPOH->nDrPohPL1    ,;
                                            C_TypPOH->nDrPohPL2     )
              ELSEIF C_TypPOH->nPodm == 3   // pøevody
                 nObecO := IF( ZvZmenHD->nOrdItem == 3, nObecODK_3, nObecODK )
                 nObecK := IF( ZvZmenHD->nOrdItem == 3, nObecKAM_3, nObecKAM )
                 ZvZmenIT->nDrPohybP := IF( nObecO == nObecK,;
                                            C_TypPOH->nDrPohPL1    ,;
                                            C_TypPOH->nDrPohPL2     )
               ENDIF
             ENDIF
             ZvZmenIT->nFarma := ZVI_CisFARMY( ZvZmenIT->cNazPol4  , YES, 1)
             ZvZmenIT->( dbUnlock())
          ENDIF

          * Aktualizace Zvirata
          IF ( ZvZmenIT->nTypPohyb == 1 .AND. ZvZmenIT->nDrPohybP <> 0 .AND. !lExist)
            cTag := Zvirata->( AdsSetOrder( 4))
            cFARMA := PADR( ALLTRIM( STR( ZVI_CisFARMY( ZvKarty->cNazPol4, YES, 1 ))), 10)
            Zvirata->( mh_SetSCOPE( UPPER( cFARMA)))
              Zvirata->( dbGoBottom())
              nPorCisLis := IF( Zvirata->nPorCisLis == 0, 1, Zvirata->nPorCisLis)
              nPorCisRad := Zvirata->nPorCisRad
            Zvirata->( mh_ClrSCOPE(), AdsSetOrder( cTAG))
            lOK := AddRec( 'Zvirata')
          ELSE
            cKeyHLP := StrZero( ZvZmenIT->nInvCis, 15) + DTOS( CTOD( '  .  .  '))
            IF ( lOK := Zvirata->( dbSeek( cKeyHLP,, 'ZVIRATA05' ) ) )
              lOK := ReplRec( 'Zvirata')
            ENDIF
          ENDIF
          IF lOK
             IF ( ZvZmenIT->nTypPohyb == 1 .AND. ZvZmenIT->nDrPohybP <> 0 )   // pøíjem
               if !lExist  // 15.6.2011
                 * u nového záznamu
                 Zvirata->nPorCisLis := IF( nPorCisRAD = nRadRegSko, nPorCisLis + 1, nPorCisLis )
                 Zvirata->nPorCisRad := IF( nPorCisRAD = nRadRegSko, 1, nPorCisRAD + 1 )
               endif
               Zvirata->cTypEvid   := ZvKarty->cTypEvid
               Zvirata->cNazPol1   := ZvKarty->cNazPol1
               Zvirata->cNazPol4   := ZvKarty->cNazPol4
               Zvirata->nZvirKat   := ZvKarty->nZvirKat
               Zvirata->cNazev     := ZvKarty->cNazev
               Zvirata->nUcetSkup  := ZvKarty->nUcetSkup
               Zvirata->cDanpZBO   := ZvKarty->cDanpZBO
               Zvirata->cTypSKP    := ZvKarty->cTypSKP
               Zvirata->dDatPorKar := ZvKarty->dDatPorKar
               Zvirata->cNazPol2   := ZvKarty->cNazPol2
               Zvirata->mPopis     := ZvKarty->mPopis
               Zvirata->dDatpZV    := ZvKarty->dDatpZV
               Zvirata->nROK       := YEAR( ZvKarty->dDatpZV)
               Zvirata->nOBDOBI    := MONTH( ZvKarty->dDatpZV)

               Zvirata->nInvCis    := ZvZmenITw->nInvCis
               Zvirata->cZvireZem  := ZvZmenITw->cZvireZem
               Zvirata->dNarozZvir := ZvZmenITw->dNarozZvir

               Zvirata->nPohlavi   := ZvZmenITw->nPohlavi
               Zvirata->cPlemeno   := ZvZmenITw->cPlemeno
               Zvirata->cMatkaZem  := ZvZmenITw->cMatkaZem
               Zvirata->nInvCisMat := ZvZmenITw->nInvCisMat

               Zvirata->nKusy      := If( ZvZmenHD->nTypPohyb == 1, 1, 0)
               Zvirata->nFarma     := ZVI_CisFARMY( ZvKarty->cNazPol4, YES, 1 )
               Zvirata->cFarma     := PADR( ALLTRIM( STR( Zvirata->nFarma)), 10)
               Zvirata->cFarmaKrj  := LEFT( Zvirata->cFarma, 2)
               Zvirata->cFarmaPod  := SubSTR( Zvirata->cFarma, 3, 6)
               Zvirata->cFarmaStj  := RIGHT( Zvirata->cFarma, 2)
///              Zvirata->nCenaZV ( nCenasZV )  := co tam
               Zvirata->cPohlavi   := IF( Zvirata->nPohlavi == 1, 'B', 'J' )
               IF  ZvZmenIT->nKarta == 431
                 Zvirata->cText1  := 'Vlastní chov'
               ELSE
                 Zvirata->dDatKdyODK := ZvZmenIT->dDatZmZv
                 Zvirata->cFarmaODK  := IF( ZvZmenIT->nCisREG <> 0, STR( ZvZmenIT->nCisREG  , 10),;
                                                                    STR( ZvZmenIT->nFarmaODK, 10) )
                 Zvirata->cFarODKkrj := LEFT( Zvirata->cFarmaODK, 2)
                 Zvirata->cFarODKpod := SubSTR( Zvirata->cFarmaODK, 3, 6)
                 Zvirata->cFarODKstj := RIGHT( Zvirata->cFarmaODK, 2)
               ENDIF
             ELSE
                IF ( ZvZmenIT->nTypPohyb == -1 ) .AND. ( nFarmaODK <> nFarmaKAM )
                  Zvirata->nKusy := 0
                  Zvirata->cFarmaKAM  := IF( ZvZmenIT->nCisREG <> 0, STR( ZvZmenIT->nCisREG),;
                                                                     STR( ZvZmenIT->nFarmaKAM, 10) )
                  Zvirata->dDatKdyKAM := ZvZmenIT->dDatZmZv
                  Zvirata->cFarKAMkrj := LEFT( Zvirata->cFarmaKAM, 2)
                  Zvirata->cFarKAMpod := SubSTR( Zvirata->cFarmaKAM, 3, 6)
                  Zvirata->cFarKAMstj := RIGHT( Zvirata->cFarmaKAM, 2)
                ENDIF
                * pøi pøevodech mezi stájemi v rámci téže farmy zaktualizovat v registru stáj
                nKARTA := ZvZmenIT->nKARTA
                IF ( nKARTA == 600 .OR. nKARTA == 610 .OR. nKARTA == 620 )  //- pøevody
                  IF ( nFarmaODK <> nFarmaKAM )
                    Zvirata->cFarmaKAM  := IF( ZvZmenIT->nCisREG <> 0, STR( ZvZmenIT->nCisREG),;
                                                                       STR( ZvZmenIT->nFarmaKAM, 10) )
                    Zvirata->dDatKdyKAM := ZvZmenIT->dDatZmZv
                    Zvirata->cFarKAMkrj := LEFT( Zvirata->cFarmaKAM, 2)
                    Zvirata->cFarKAMpod := SubSTR( Zvirata->cFarmaKAM, 3, 6)
                    Zvirata->cFarKAMstj := RIGHT( Zvirata->cFarmaKAM, 2)
                  ENDIF
                  IF  ZvZmenIT->nTypPohyb == 1
                    Zvirata->cNazPol1  :=  ZvZmenIT->cNazPol1
                    Zvirata->cNazPol2  :=  ZvZmenIT->cNazPol2
                    Zvirata->cNazPol4  :=  ZvZmenIT->cNazPol4
                    Zvirata->nZvirKat  :=  ZvZmenIT->nZvirKat
                    Zvirata->nUcetSkup :=  ZvZmenIT->nUcetSkup
                  ENDIF
                ENDIF
             ENDIF
             Zvirata->dDatpZV := ZvZmenIT->dDatZmZv ////
             IF REPLREC( 'ZvZmenIT')
               ZvZmenIT->nPorCisLis := Zvirata->nPorCisLis
               ZvZmenIT->nPorCisRad := Zvirata->nPorCisRad
               ZvZmenIT->( dbUnlock())
             ENDIF
             Zvirata->( dbUnlock())
          ENDIF
        NEXT
        * Zrušit neaktuální ZvZmenIT pøi opravì
        ZvZmenIT->( mh_SetSCOPE( StrZero( ZvZmenHD->nDoklad, 10)))
        DO WHILE !ZvZmenIT->( EOF())
           If ZvZmenIT->nOrdItem > nLen .AND. ZvZmenIT->nOrdItem < 1000
              ZvZmenIT->( dbRLock(), dbDelete(), dbRUnlock() )
           Endif
           ZvZmenIT->( dbSkip())
        ENDDO
        ZvZmenIT->( mh_ClrSCOPE())
      ENDIF
    ENDIF
  ENDIF

RETURN self

* Modifikace souboru ZvKarty
********************************************************************************
METHOD ZVI_zsbMODI:m_ZvKarty()  // nKEY )
  Local lPRIJEM  := ( ZvZmenHd->nTypPohyb =  1 )
  Local lVYDEJ   := ( ZvZmenHd->nTypPohyb = -1 )
  Local lCenaPRU := ( UPPER( ZvKarty->cTypVypCen) == 'PRU' )

  DO CASE
    CASE (::nEvent = drgEVENT_APPEND )
      If ReplRec( 'ZvKarty')
         ZvKarty->nCenanZV   := ZvZmenHD->nCenasZV
         ZvKarty->nKD        += ZvZmenHD->nTypPohyb * ZvZmenHD->nKd
         ZvKarty->dDatpZV    := ZvZmenHD->dDatZmZv
         DO CASE
           CASE lPRIJEM
             ZvKarty->nMnozsZV += ZvZmenHd->nMnozsZV
             ZvKarty->nKusyZV  += ZvZmenHd->nKusyZV
             If lCenaPRU
               ZvKarty->nKusyZV := MAX( ZvKarty->nKusyZV, 0 )
             Endif
             ZvKarty->nCenacZV   += ZvZmenHD->nCenacZV
             ZvKarty->nCenasZV   := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)

           CASE lVYDEJ
             ZvKarty->nMnozsZV -= ZvZmenHd->nMnozsZV
             ZvKarty->nKusyZV  -= ZvZmenHd->nKusyZV
             ZvKarty->nKusyZV  := IF( lCenaPRU, MAX( ZvKarty->nKusyZV, 0 ),;
                                                ZvKarty->nKusyZV  )
             IF ( ZvKarty->nMnozsZV == 0 .AND. ZvKarty->nKusyZV == 0 )
                IF ZvZmenHD->( dbRLock())
                   ZvZmenHD->nCenacZV := ZvKarty->nCenacZV
                   ZvZmenHD->( dbRUnlock())
                ENDIF
             ENDIF
             ZvKarty->nCenacZV -= ZvZmenHD->nCenacZV
             If ZvZmenHd->nCenacZV < 0 .or.     ;     // Záporný výdej => pøíjem
                ( ::lVZRUST .AND. ZvZmenHD->nOrdITEM == 1 )
//                ZvZmenHd->nDrPohyb == nDpVzrust    // Jde o vzrùstovì pøírùstek => storno pøíjmu
                ZvKarty->nCenasZV  := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)
             Endif

         ENDCASE
         ZvKarty->( dbUnlock())
    Endif

    CASE (::nEvent = drgEVENT_EDIT )

      If ReplRec( 'ZvKarty')
         ZvKarty->nCenanZV   := ZvZmenHD->nCenasZV
         ZvKarty->nKd        += ZvZmenHD->nTypPohyb * ( - ZvZmenHDw2->nKd + ZvZmenHD->nKd )
         ZvKarty->dDatpZV    := ZvZmenHD->dDatZmZv
         DO CASE
           CASE lPRIJEM
             ZvKarty->nMnozsZV += ZvZmenHd->nMnozsZV - ZvZmenHDw2->nMnozsZV
             ZvKarty->nKusyZV  += ZvZmenHd->nKusyZV - ZvZmenHDw2->nKusyZV
             If ZvZmenHd->nKusyZV < 0 .and. lCenaPRU
                ZvKarty->nKusyZV := MAX( ZvKarty->nKusyZV, 0)
             Endif
             ZvKarty->nCenacZV   += ZvZmenHD->nCenacZV - ZvZmenHDw2->nCenacZV
             ZvKarty->nCenasZV   := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)

           CASE lVYDEJ
             ZvKarty->nMnozsZV += ZvZmenHDw2->nMnozsZV - ZvZmenHd->nMnozsZV
             ZvKarty->nKusyZV  += ZvZmenHDw2->nKusyZV - ZvZmenHd->nKusyZV
             ZvKarty->nKusyZV  := IF( lCenaPRU, MAX( ZvKarty->nKusyZV, 0),;
                                                ZvKarty->nKusyZV  )
             IF ( ZvKarty->nMnozsZV == 0 .AND. ZvKarty->nKusyZV == 0 )
                IF ZvZmenHD->( dbRLock())
                   ZvZmenHD->nCenacZV := ZvKarty->nCenacZV
                   ZvZmenHD->( dbRUnlock())
                ENDIF
                ZvKarty->nCenacZV  := 0
             ELSE
                ZvKarty->nCenacZV += ZvZmenHDw2->nCenacZV - ZvZmenHd->nCenacZV
             ENDIF
             If ZvZmenHd->nCenacZV < 0 .or.  ;
                ( ::lVZRUST .AND. ZvZmenHD->nOrdITEM == 1 )
                ZvKarty->nCenasZV   := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)
             Endif

         ENDCASE
         ZvKarty->( dbUnlock())
      Endif

    CASE (::nEvent = drgEVENT_DELETE)
      If ReplRec( 'ZvKarty')
         ZvKarty->nKd        -= ZvZmenHD->nTypPohyb * ZvZmenHD->nKd
         ZvKarty->dDatpZV    := ZvZmenHD->dDatZmZv
         DO CASE
           CASE lPRIJEM
             ZvKarty->nMnozsZV -= ZvZmenHd->nMnozsZV
             ZvKarty->nKusyZV  -= ZvZmenHd->nKusyZV
             ZvKarty->nKusyZV  := If( lCenaPRU, MAX( ZvKarty->nKusyZV, 0),;
                                                ZvKarty->nKusyZV )
             ZvKarty->nCenacZV -= ZvZmenHd->nCenacZV
             ZvKarty->nCenasZV := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)

           CASE lVYDEJ
             ZvKarty->nMnozsZV += ZvZmenHd->nMnozsZV
             ZvKarty->nKusyZV  += ZvZmenHd->nKusyZV
             ZvKarty->nKusyZV  := If( lCenaPRU, MAX( ZvKarty->nKusyZV, 0 ),;
                                                ZvKarty->nKusyZV )
             IF ( ZvKarty->nMnozsZV == 0 .AND. ZvKarty->nKusyZV == 0 )
                ZvKarty->nCenacZV  := 0
             ELSE
                ZvKarty->nCenacZV  += ZvZmenHd->nCenacZV
             ENDIF
             If ZvZmenHd->nCenacZV < 0 .or. ZvZmenHd->nDrPohyb == ::nDpVzrust
                ZvKarty->nCenasZV  := ZVI_SkladCENA( ZvZmenHd->cTypVypCEN)
             EndIf

         ENDCASE
         ZvKarty->( dbUnlock())
      EndIf
  ENDCASE

RETURN self

********************************************************************************
METHOD ZVI_zsbMODI:m_ZvKarObd()

RETURN self

********************************************************************************
METHOD ZVI_zsbMODI:m_ZvZmObd()

RETURN self

* Modifikace souborù pøi pøevodu do ZÁKLADNÍHO STÁDA
********************************************************************************
METHOD ZVI_zsbMODI:m_ZaklStado()

  Local lNewRec , lOK
  Local aInvCis, nInvCis, N, nRec, nCenaHLP := 0, nRecNo, nLen
  Local cScope, cKey, cTag, nMin, nMax

  If ::nKARTA == 610   // Lze pøevádìt oba typy evidence - I,S
    drgDBMS:open( 'MAJZ'     )
    drgDBMS:open( 'ZMAJUZ'   )
    drgDBMS:open( 'ZMAJNZ'   )
    drgDBMS:open( 'SUMMAJZ'  )
    drgDBMS:open( 'UCETPOL'  )
    drgDBMS:open( 'C_DANSKP' )
    drgDBMS:open( 'C_UCETSKP')
    drgDBMS:open( 'ZVIRATA'  )
    *
    cKey := Upper( ZvZmenHD->cNazPol1_N) + Upper( ZvZmenHD->cNazPol4_N) + ;
            StrZero( ZvZmenHD->nZvirKat_N, 6)
    nRec := ZvKarty->( RecNo())
    ZvKarty->( dbSeek( cKey,, 'ZVKARTY_01'))
    DO CASE
      CASE (::nEvent = drgEVENT_APPEND )
        nMin := SysCONFIG('Zvirata:nKcPrevBot')
        nMax := SysCONFIG('Zvirata:nKcPrevTop')
        nLen := ZvZmenITw->( LastREC())

        FOR N := 1 TO nLen
          ZvZmenITw->( dbGoTO( N))
          If AddRec( 'MajZ')
             mh_CopyFld( 'ZvZmenHD', 'MAJZ')
             MajZ->nInvCis    := ZvZmenITw->nInvCis
             MajZ->nDrPohyb   := 141                  // pøíjem ze zásob do ZS
             MajZ->cTypPohybu := '141'
             MajZ->nDoklPrev  := ZvZmenHD->nDoklad    // pøevodový doklad
             MajZ->cNazPol1   := ZvZmenHD->cNazPol1_N
             MajZ->cNazPol2   := ZvZmenHD->cNazPol2_N
             MajZ->cNazPol4   := ZvZmenHD->cNazPol4_N

             MajZ->nUcetSkup  := ZvKarty->nUcetSkup
             MajZ->cUcetSkup  := STR( MajZ->nUcetSkup)
             MajZ->nZvirKat   := ZvKarty->nZvirKat
             MajZ->cTypSkp    := ZvKarty->cTypSkp
             MajZ->cNazev     := ZvKarty->cNazev
             IF N = nLEN
               MajZ->nCenaVstU  := ZvZmenHD->nCenaCZV - nCenaHLP
             ELSE
               MajZ->nCenaVstU  := IF( ZvZmenHD->nTypVypCEL == 1,;
                                       ( ZvZmenHD->nCenaCZV / ZvZmenHd->nKusyZV ),;
                                         ZvZmenHD->nCenasZV )
               nCenaHLP += MajZ->nCenaVstU
             ENDIF
             MajZ->nCenaVstD  := MajZ->nCenaVstU
             MajZ->nCenaPorU  := MajZ->nCenaVstU
             MajZ->nCenaPorD  := MajZ->nCenaVstD
             MajZ->nOprUct    := 0
             MajZ->nOprDan    := 0
             MajZ->nOprUctPS  := 0
             MajZ->nOprDanPS  := 0
*             MajZ->nZnAkt     := 0  // = Aktivní
             MajZ->cObdZar    := ZvZmenHD->cObdobi
             MajZ->nKusy      := 1
             MajZ->dDatPor    := DATE()
             * Plnìní pøes soubor KATEGZVI
             nRECNO := KategZvi->( RecNO())
             KategZvi->( dbSEEK( MajZ->nZvirKat))
             *
             MajZ->nOdpiSk    := KategZvi->nOdpiSk
             MajZ->cOdpiSk    := KategZvi->cOdpiSk
             MajZ->nOdpiSkD   := KategZvi->nOdpiSkD
             MajZ->cOdpiSkD   := KategZvi->cOdpiSkD
             MajZ->nTypDOdpi  := KategZvi->nTypDOdpi
             MajZ->nTypUOdpi  := KategZvi->nTypUOdpi
             MajZ->nTypVypUO  := KategZvi->nTypVypUO
             MajZ->nZpuOdpis  := KategZvi->nZpuOdpis
             MajZ->nZnAkt     := KategZvi->nZnAkt
             MajZ->nZnAktD    := KategZvi->nZnAktD
             IF C_DanSkp->( dbSeek( upper( KategZVI->cOdpiSkD),, 'C_DANSKP1'))
               MajZ->nRokyOdpiD := C_DanSkp->nRokyOdpis
               MajZ->nMesOdpiD  := C_DanSkp->nMesOdpiD
             ENDIF
             IF C_UcetSkp->( dbSeek( upper( KategZVI->cOdpiSk),, 'C_UCETSKP1'))
               MajZ->nRokyOdpiU := C_UcetSkp->nRokyOdpis
             ENDIF

             MajZ->nUplProc   := KategZvi->nUplProc
             MajZ->nUplHodn   := ( MajZ->nCenaVstU / 100) * MajZ->nUplProc
             *-----
             nMin := IF( KategZvi->nKcPrevBot = 0, nMin, KategZvi->nKcPrevBot )
             nMax := IF( KategZvi->nKcPrevTop = 0, nMax, KategZvi->nKcPrevTop )
             IF MajZ->nCenaVstU >= nMin .and. MajZ->nCenaVstU < nMax
               MajZ->nUcetSkup := KategZvi->nUcetSkupP
               MajZ->cUcetSkup := STR( KategZvi->nUcetSkupP)
               ZvZmenIT->( dbGoTo( ZvZmenITw->_nrecor))
               IF ReplREC( 'ZvZmenIT')
                 ZvZmenIT->nUcetSkup := KategZvi->nUcetSkupP
                 ZvZmenIT->cUcetSkup := STR( KategZvi->nUcetSkupP)
                 ZvZmenIT->( dbUnlock())
               ENDIF
             ENDIF
             *
             KategZvi->( dbGoTO( nRECNO))
             * Automatizované vypoètení položky
             ::MajCMP()
             * Položky s nejasným plnìním
             MajZ->dDatZar    := ZvZmenHD->dDatZmZv
             MajZ->nDoklad    := HIM_NewDoklad( 'ZVI')  // NewDoklad()
             MajZ->nRokUpl    := If( MajZ->nUplProc > 0, YEAR( DATE()) ,;
                                                         MajZ->nRokUpl )
             MajZ->lHmotnyIM  := .T.
             *
             MajZ->( dbUnlock())
          Endif
          HIM_ZMajU_IM( .T., .F.)
          *
        NEXT

      CASE  (::nEvent = drgEVENT_DELETE )

        IF UPPER( ZvKarty->cTypEvid) == 'I'
          DO WHILE ZvZmenIT->( dbSeek( StrZero( ZvZmenHD->nDoklad, 10),, 'ZVZMENIT02' ))
            cKey := StrZero( ZvZmenIT->nUcetSkup, 3) + StrZero( ZvZmenIT->nInvCis, 15 )
            If MajZ->( dbSeek( cKey,, 'MAJZ_01')) .and. Empty( MajZ->cObdPosOdp)
              If ZMajUZ->( dbSeek( cKey,, 'ZMAJUZ1'))
                 *
                 uctLikv := UCT_likvidace():New(Upper( ZMajUZ->cUloha) + Upper( ZMajUZ->cTypDoklad),.T.)
                 *
                 DelRec( 'ZMajUZ')
              Endif
              If SumMajZ->( dbSeek( cKey))
                 DelRec( 'SumMajZ')
              EndIf
              DelRec( 'MajZ')
            Endif
            DelRec( 'ZvZmenIT')
          ENDDO

        ElseIf UPPER( ZvKarty->cTypEvid) == 'S'
          DO WHILE MajZ->( dbSeek( ZvZmenHD->nDoklad,,'MAJZ_11'))
            If EMPTY( MajZ->cObdPosOdp)
              cKey := StrZero( MajZ->nUcetSkup, 3) + StrZero( MajZ->nInvCis, 15)
              If ZMajUZ->( dbSeek( cKey + '00141',, 'ZMAJUZ7' ))
                *
                ZVI_UcetPOL_DEL( .T.)
                * uctLikv := UCT_likvidace():New(Upper( ZMajUZ->cUloha) + Upper( ZMajUZ->cTypDoklad),.T.)
                *
                 DelRec( 'ZMajUZ')
              Endif
              If SumMajZ->( dbSeek( cKey,, 'SUMMAJZ_2'))
                 DelRec( 'SumMajZ')
              EndIf
            Endif
            DelRec( 'MajZ')
          ENDDO
        EndIf

      CASE  (::nEvent = drgEVENT_EDIT )
         * Opravu pøevodu do ZS nepovolujeme
    ENDCASE
    ZvKarty->( dbGoTo( nRec))
  Endif

RETURN self

*
** HIDDEN **********************************************************************
METHOD ZVI_zsbMODI:isProdukce( nDrPohyb)
  Local lProdukce := NO
  /* 7.6.2011
  drgDBMS:open('C_DrPohZ',,,,, 'C_DrPohZa' )
  IF C_DrPohZa->( dbSeek( nDrPohyb,,'DRPOHZ1'))
     lProdukce := C_DrPohZa->lProdukce
  ENDIF
  */
  drgDBMS:open('C_TypPOH',,,,, 'C_TypPOHa' )
  IF C_TypPOHa->( dbSeek( Z_DOKLADY + AllTrim( Str( nDrPohyb)),,'C_TYPPOH02'))
     lProdukce := C_TypPOHa->lProdukce
  ENDIF
  C_TypPOHa->( dbCloseArea())
RETURN lProdukce

* Výpoèet odpisù do MAJZ
** HIDDEN **********************************************************************
METHOD ZVI_zsbMODI:MajCMP()
  Local nZCD := MajZ->nCenaVstD - MajZ->nOprDan, nDORok, nDOMes
  Local nZCU := MajZ->nCenaVstU - MajZ->nOprUct, nUORok, nUOMes, nAktMes
  Local nRokZar := VAL( mh_GETcRok4( MajZ->cObdZAR))
  Local nPocetDO := ( ::parent:nAktROK - nRokZar),  nProcRDO
  Local nRoundOdpi := SysConfig( 'Zvirata:nRoundOdpi')
*  Local nPocetDO := RokDO( .T., MajZ->cObdZar)

  If MajZ->nZnAktD = 1  // NEAKTIVNÍ
    MajZ->nProcDanOd := 0   // roèní daòový odpis %
    MajZ->nDanOdpRok := 0   // roèní daòový odpis

  ElseIf MajZ->nZnAktD = 0  // AKTIVNÍ

    nOdpiskD := IF( C_DanSkp->( dbSeek( Upper( MajZ->cOdpiSkD),, 'C_DANSKP1')),;
                    C_DanSkp->nOdpiSkD, 0)
    * Daòový odpis
    If MajZ->nTypDOdpi == 1        // rovnomìrný typ DO
      IF c_DanSkp->cMJCas = 'R'
        nProcRDO := HIM_ProcRDO( MajZ->cObdZar  ,;
                                 MajZ->cOdpiSkD ,;
                                 MajZ->nUplProc ,;
                                 nPocetDO       ,;
                                 'ZVI'           )
        MajZ->nProcDanOd := nProcRDO
        nDORok := PercToVal( MajZ->nCenaVstD, MajZ->nProcDanOd )
        MajZ->nDanOdpRok  := HIM_RocniOdpis( nDORok, nZCD )

      ELSEIF c_DanSkp->cMJCas = 'M'
        IF nOdpiSkD > 6
          nAktMes := HIM_AktMes( MajZ->cObdZar, 'ZVI' )
          nZCD    := ( MajZ->nCenaVstD - MajZ->nOprDan )
          Do Case
          Case nOdpiSkD = 7   // 1M
            nDOMes := mh_RoundNumb( ( MAJz->nCenaVstD / 12), nRoundOdpi )
          Case nOdpiSkD = 8
            nDOMes := MAJz->nUctOdpMes
          Case nOdpiSkD = 9   // 2M
            nDOMes := mh_RoundNumb( (( MAJz->nCenaVstD * 0.6) / 12), nRoundOdpi )
          Otherwise
             * sk. 10-8 mìs, 11=36, 12-60, 13-72, skupiny > 13
            nDOMes := mh_RoundNumb( ( MAJz->nCenaVstD / C_DanSkp->nMesOdpiD), nRoundOdpi )
          EndCase
          nDORok  := If( nAktMes == 12, 0, nDOMes * ( 12 - nAktMes) ) // od následujícího mìsíce
          MAJz->nDanOdpRok := HIM_RocniOdpis( nDORok, nZCD)
          MAJz->nProcDanOd := ValToPERC( MAJz->nCenaVstD, MAJz->nDanOdpRok )
        ENDIF
      ENDIF

    ElseIf MajZ->nTypDOdpi == 2   // zrychlenì typ DO
       nDORok := MajZ->nCenaVstD / C_DanSkp->nZrPrvni
       nDORok += MajZ->nUplProc
       MajZ->nDanOdpRok := HIM_RocniOdpis( nDORok, nZCD)
       MajZ->nProcDanOd := ValToPerc( MajZ->nCenaVstD, MajZ->nDanOdpRok )
    Endif
   EndIf

  * Úèetní odpis
  If MajZ->nZnAkt = 1    // NEAKTIVNÍ
    MajZ->nProcUctOd := 0   // roèní úèetní odpis %
    MajZ->nUctOdpRok := 0   // roèní úèetní odpis
    MajZ->nUctOdpMes := 0   // mìsíèní úèetní odpis

  ElseIf MajZ->nZnAkt = 0  // AKTIVNÍ

    nAktMes := HIM_AktMes( MajZ->cObdZar, 'ZVI')
    If MajZ->nTypUOdpi == 1        // rovnomìrný
       nUOMes := MajZ->nCenaVstU / ( MajZ->nRokyOdpiU * 12 )
       MajZ->nUctOdpMes := mh_RoundNumb( nUOMes, nRoundOdpi)
       nUORok := If( nAktMes == 12, 0, nUOMes * ( 12 - nAktMes) )
       MajZ->nUctOdpRok := HIM_RocniOdpis( nUORok, nZCU)
       MajZ->nProcUctOd := ValToPerc( MajZ->nCenaVstU, MajZ->nUctOdpRok)
    ElseIf MajZ->nTypUOdpi == 3    // roven daòovému
        MajZ->nProcUctOd := MajZ->nProcDanOd
        nUORok := MajZ->nDanOdpRok
        nUOMes := If( nAktMes == 12, 0,;
                      mh_RoundNumb( nUORok / ( 12 - nAktMes), nRoundOdpi) )
        nUORok := If( nAktMes == 12, nUORok, nUOMes * ( 12 - nAktMes) )
        MajZ->nUctOdpRok := nUORok
        MajZ->nUctOdpMes := nUOMes
    Endif
  EndIf

RETURN Nil

*************KOPIE POLOZEK DB -> DB********************************************
Function mh_COPYFLDarr(cDBFrom,cDBTo,lDBApp,IsMain,aLock,Uniq,arr )
  Local  nPOs, nUni, azamky
  Local  xVAL
  Local  aFrom := ( cDBFrom) ->( dbStruct())

  Default lDBApp To .F., IsMain TO .F., Uniq  TO .T.

//  nUni := ( cDBTo) ->( FieldPos('cUniqIdRec'))

  if ldbapp .and. .not. (cdbto)->(DbLocked())
    azamky := (cdbto)->(DbRLockList())

    (cdbto)->(DbAppend())
    aadd(azamky, (cdbto)->(recno()))
    (cdbto)->(sx_rlock(azamky))
  endif

*-  If( lDBApp, (cDBTo)->( DbAppend(),dbrlock()), Nil )

//  If( lDBApp .and. Uniq, (cDBTo)->( mh_GETLASTuniqID()), Nil)
  *
  IF IsNull( arr)
    AEval( aFrom, { |X,M| ;
                ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                  nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                  If( (nPos <> 0 .and. nPos <> nUni) .or.                       ;
                      (nPos <> 0 .and. nPos = nUni .and. !Uniq)               , ;
                       ( cDBTo) ->( FieldPut( nPos, xVal)), Nil))})
  ELSE
    aFrom := {}
    FOR x := 1 TO Len( arr:values)
      ref := arr:values[x, 2]:ref
      IF .not. IsNull( ref) .and. cDBFrom = drgParse( arr:values[x, 2]:name, '->')
        aadd( aFrom, { ref:name, ref:type, ref:len, ref:dec} )
      ENDIF
    NEXT
    *
    AEval( aFrom, { |X,M| ;
                (n    := ( cDBFrom) ->( FieldPos( X[ DBS_NAME]))               , ;
                 xVal := ( cDBFrom) ->( FieldGet( n))                        , ;
                 nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                 If( (nPos <> 0 .and. nPos <> nUni) .or.                       ;
                     (nPos <> 0 .and. nPos = nUni .and. !Uniq)               , ;
                      ( cDBTo) ->( FieldPut( nPos, xVal)), Nil))})
  ENDIF

  // zavedena konvence u TMP položka _nrecor pro zámky pøi ukládání //
  IF IsMain .and. (nPOs := (cDBTo) ->(FieldPos('_nrecor'))) <> 0 .and. !(cDBFrom) ->(EOF())
    (cDBTo) ->(FieldPut(nPOs, (cDBFrom) ->(RecNo())))
    IF(IsARRAY(aLock), AAdd(aLock,(cDBFrom) ->(RecNo())),NIL)
  ENDIF
Return( Nil)

* Vrací poslední otevøené období dané úlohy ve tvarU:
* nPRM = 1 : '201012'
* nPRM = 2 : '12/2010'
* nPRM = 3 : 12
*===============================================================================
FUNCTION LastOBDOBI( cULOHA, nPRM)
  Local xReturn

  drgDBMS:open('UCETSYS',,,,,'UCETSYSa' )
  UCETSYSa->( AdsSetOrder( 3)     ,;
              mh_setScope( cULOHA),;
              dbGoBottom()         )
  xReturn := IIF( nPRM == 1, VAL( STRZERO( UCETSYSa->nROK, 4) + StrZERO( UCETSYSa->nObdobi, 2)),;
             IIF( nPRM == 2, StrZERO( UCETSYSa->nObdobi, 2) + '/' + STRZERO( UCETSYSa->nROK, 4),;
             IIF( nPRM == 3, UCETSYSa->nObdobi, Nil ) ) )
  UCETSYSa->( dbCloseArea())

RETURN xReturn