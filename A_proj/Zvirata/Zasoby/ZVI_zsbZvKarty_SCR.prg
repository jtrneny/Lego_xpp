/*==============================================================================
  ZVI_zsbKarty_SCR.PRG
==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"

#Define  TAB_UCETNI      1
#Define  TAB_NEUCETNI    2
#Define  TAB_ZAKLUDAJE   3

********************************************************************************
*
********************************************************************************
CLASS ZVI_zsbZvKarty_SCR FROM drgUsrClass
EXPORTED:
  VAR     NazTypEvid

  METHOD  Init, drgDialogStart, EventHandled, ItemMarked, tabSelect
  METHOD  zsbPohyby, zsbPocStav, AllOK
  METHOD  KategZvi_INFO, zsbIndividEv

HIDDEN
  VAR     dc, tabNum
ENDCLASS

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('KategZVI'  )
  drgDBMS:open('C_UctSkZ'  )
  drgDBMS:open('C_TypPoh'  )
  drgDBMS:open('CNAZPOL1'  )
  drgDBMS:open('CNAZPOL4'  )
  drgDBMS:open('ZvZmenIT'  )
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ZvKarty->( DbSetRelation( 'KategZvi'  , {|| ZvKarty->nZvirKat  } ,'ZvKarty->nZvirKat'  ))
  ZvKarty->( DbSetRelation( 'C_UctSkZ'  , {|| ZvKarty->nUcetSkup } ,'ZvKarty->nUcetSkup' ))
  ZvZmenHD->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU) },;
                                         'UPPER(cULOHA)+UPPER(cTYPDOKLAD) +UPPER(CTYPPOHYBU))', 'C_TYPPOH05'))
  *
  ZvZmenHD->( DbSetRelation( 'cNazPol1'  , {|| ZvZmenHD->cNazPol1  } ,'ZvZmenHD->cNazPol1'  ))
  ZvZmenHD->( DbSetRelation( 'cNazPol4'  , {|| ZvZmenHD->cNazPol4  } ,'ZvZmenHD->cNazPol4'  ))
  *
  ::dc     := drgDialog:dialogCtrl
  ::tabNum := TAB_UCETNI
RETURN

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_APPEND
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_EDIT
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
        IF ZvZmenHD->nOrdItem = 1
          ::zsbPohyby( nEvent)
        ELSE
          drgMsgBox(drgNLS:msg( 'Tento druh zmìny nelze opravovat !' ))
        ENDIF

      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      IF ::dc:oaBrowse:cFile = 'ZvKarty'
        ZVI_ZvKarty_DEL()
        ::dc:oBrowse[1]:oXbp:refreshAll()
      ELSEIF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD ZVI_zsbZvKarty_scr:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.

*******************************************************************************
METHOD ZVI_zsbZvKarty_SCR:ItemMarked()
  Local cScope := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6)

  ::NazTypEvid := IF( ZvKarty->cTypEvid = 'S', 'Skupinová', 'Individuální' )
*  ZvZmenHD->( mh_SetScope( cScope + '1'))  // úèetní zmìny
  ZvZmenHD->( mh_SetScope( cScope))        // úèetní zmìny
  ZvKartyZ->( mh_SetScope( cScope))        // neúèetní zmìny
RETURN SELF

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:zsbPOHYBY( nEvent)
  LOCAL oDialog, nExit, cTag := ZvZmenHD->( OrdSetFocus())
  Local nDoklad, nRec, cKeyZme, cKeyKar, lOK
  Local zsbMODI
  *
  nEvent := IF( IsObject( nEvent), drgEVENT_APPEND, nEvent )
  *
  IF ( nEvent = drgEVENT_APPEND .or. ( nEvent = drgEVENT_EDIT .and. ::AllOK( nEvent) ) )
    *
    oDialog := drgDialog():new('ZVI_zsbPohyby_CRD', ::drgDialog)
    oDialog:cargo := nEvent
    oDialog:create(,,.T.)
    nExit := oDialog:exitState

    oDialog:destroy(.T.)
    oDialog := Nil
    *
    ZvZmenHD->( AdsSetOrder( cTag))
    *
    IF( nEvent = drgEVENT_APPEND, ::dc:oBrowse[2]:oXbp:refreshAll()   ,;
                                  ::dc:oBrowse[2]:oXbp:refreshCurrent() )
*    ::dc:oBrowse[1]:oXbp:refreshCurrent()
    nRec := ZvKarty->( RecNo())
    ::dc:oBrowse[1]:oXbp:refreshAll()
    ZvKarty->( dbGoTO( nRec))

  ELSEIF nEvent = drgEVENT_DELETE
    *
    IF ::AllOK( nEvent)
      IF drgIsYESNO(drgNLS:msg( 'Požadujete zrušit tuto zmìnu ?' ) )
        nRec := ZvKarty->( RecNo())
        cKeyKar := Upper( ZvKarty->cNazPol1) + Upper( ZvKarty->cNazPol4) + ;
                   StrZero( ZvKarty->nZvirKat, 6)
        nDoklad := ZvZmenHd->nDoklad
        Do While ZvZmenHd->( dbSeek( StrZero( nDoklad, 10),, 'ZVZMENHD03'))
          cKeyZme := Upper( ZvZmenHD->cNazPol1) + Upper( ZvZmenHD->cNazPol4) + ;
                     StrZero( ZvZmenHD->nZvirKat, 6)
          IF cKeyKar <> cKeyZme
            * Jde o zmìnu, která se promítá na jinou kartu
            * ( DP 40, 41 a k nim generované vzrùst. pøírùstky )
            ZvKarty->( dbSeek( Upper( cKeyZme),, 'ZVKARTY_01'))
          ENDIF
          *
          zsbMODI := ZVI_zsbMODI():new( self)
          zsbMODI:nEvent := nEvent
          zsbMODI:nKarta := ZvZmenHD->nKARTA

          zsbMODI:m_Zvirata()                // M_Zvirata( K_DEL)
          zsbMODI:m_ZvKarty()                // M_ZvKarty( K_DEL)
**          zsbMODI:m_ZvKarObd()               // M_ZvKarObd( K_DEL, ZvZmenHD->nTypPohyb)
**          zsbMODI:m_ZvZmObd()                // M_ZvZmOBD( K_DEL)

          ZVI_UcetPol_DEL()
          *
          zsbMODI:m_ZaklStado()              //  M_ZaklStado( K_DEL, ZvZmenHD->nKARTA)
          DelRec( 'ZvZmenHd')
        EndDo
        *
        ZvZmenHd->( AdsSetOrder( cTag), dbGoTOP() )
        ZvKarty->( dbGoTo( nRec))
        *
        ::dc:oBrowse[1]:oXbp:refreshAll()
        ZvKarty->( dbGoTo( nRec))
        ::dc:oBrowse[1]:oXbp:refreshCurrent():hilite()
        ::dc:oBrowse[2]:oXbp:refreshAll()
      ENDIF
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:zsbPocStav()
  Local StavyObd, lRozdil, lSeek, lOK, nRok, cKey

  drgMsgBox(drgNLS:msg( 'Pøepoèet poèáteèního stavu karty ... ' ))

  drgDBMS:open('ZvKarty_pc' )
  *
  StavyObd            := ZVI_zsbStavyObd_SCR():new() // SKL_StavyObd_SCR():new()
  nRok                := StavyObd:nRok
  StavyObd:nRok       := nRok - 1
  StavyObd:nObdPOC    :=  1                          // generovat pouze za poslední akt.období
  StavyObd:nObdKON    := 12
  StavyObd:oneZvKarty := .T.                          // generovat za jednu kartu zvíøete
  *
  ZvKarOBDw->( dbZAP())
  StavyObd:createKUMUL()
  ZvKarOBDw->( dbGoBottom())
  *
  lRozdil := ( ZvKarOBDw->nCenaKON <> ZvKarty->nCenaPocZV .or.  ;
               ZvKarOBDw->nMnozKON <> ZvKarty->nMnozPocZV .or.  ;
               ZvKarOBDw->nKusyKON <> ZvKarty->nKusyPocZV .or.  ;
               ZvKarOBDw->nKdKON   <> ZvKarty->nKdPocZV )
  IF lRozdil
*    IF drgIsYesNO(drgNLS:msg('Požadujete aktualizovat poèáteèní stavy pro rok [ & ] ?', nRok ))
    IF drgIsYesNO(drgNLS:msg( '                       KUSY        MNOŽSTVÍ              CENA          KD  ;' + ;
                              'pùvodní:             &          &         &          &  ;' + ;
                              'pøepoètené:         &          &         &          & ;;' + ;
                              'Požadujete aktualizovat poèáteèní stavy pro rok [ & ] ?',;
                               ZvKarty->nKusyPocZV, ZvKarty->nMnozPocZV, ZvKarty->nCenaPocZV, ZvKarty->nKdPocZV,;
                               ZvKarOBDw->nKusyKON, ZvKarOBDw->nMnozKON, ZvKarOBDw->nCenaKON, ZvKarOBDw->nKdKON, nRok ))

       cKey := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) +;
                StrZero( ZvKarty->nZvirKat, 6) + StrZero( nRok, 4)
       lSeek := ZvKarty_ps->( dbSeek( cKey,, 'ZVKARPS_01'))
       IF ( lOK := IF( lSeek, ReplREC('ZvKarty_ps'), AddRec( 'ZvKarty_ps')))
         IF ZvKarty->( RLock())
           ZvKarty->nCenaPocZV := ZvKarOBDw->nCenaKON
           ZvKarty->nMnozPocZV := ZvKarOBDw->nMnozKON
           ZvKarty->nKusyPocZV := ZvKarOBDw->nKusyKON
           ZvKarty->nKdPocZV   := ZvKarOBDw->nKdKON
           *
           IF lSeek
             ZvKarty_ps->nCenaPocZV  := ZvKarty->nCenaPocZV
             ZvKarty_ps->nMnozPocZV  := ZvKarty->nMnozPocZV
             ZvKarty_ps->nKusyPocZV  := ZvKarty->nKusyPocZV
             ZvKarty_ps->nKdPocZV    := ZvKarty->nKdPocZV
           ELSE
             ZvKarty_ps->( dbAppend())
             mh_CopyFld( 'ZvKarty', 'ZvKarty_ps')
             ZvKarty_ps->nRok := nRok
           ENDIF
         ENDIF
       ENDIF
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg( 'Nebyl zjištìn rozdíl mezi pùvodními a pøepoètenými poèáteèními stavy ... ' ))
  ENDIF


RETURN self

/*******************************************************************************
METHOD ZVI_zsbZvKarty_SCR:postAppendObdobi()
  drgMsgBox(drgNLS:msg( 'Akce ... postAppendObdobi' ))
RETURN self
*/

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:AllOK( nEvent)

  Local lOK := NO, cOBD := uctObdobi:ZVI:cObdobi
  Local nObdLast := LastOBDOBI( 'Z', 1)
  Local nObdZmen := VAL( StrZERO( ZvZmenHD->nROK, 4) + StrZERO( ZvZmenHD->nObdobi, 2))
  Local lObdOK

  IF ZvZmenHD->nOrdItem == 1
    IF nEvent = drgEVENT_APPEND     // lNewPOHYB
      lOK := YES
    ELSE
      IF ZvZmenHD->cObdobi <> cObd
        drgMsgBox(drgNLS:msg( 'NELZE;;Doklad spadá do období [ & ], avšak aktuální období je [ & ]!',;
                                     ZvZmenHD->cObdobi, cObd ))
      ELSEIF nEvent = drgEVENT_EDIT .AND. ZvZmenHD->nKarta >= 600
        drgMsgBox(drgNLS:msg( 'Pøevodní pohyb;;Pøevodní pohyby nelze opravovat !' ))
      ELSEIF nEvent = drgEVENT_DELETE .AND. nObdZMEN < nObdLAST
        IF KategZvi->( dbSEEK( ZvZmenHD->nZvirKat)) .and. KategZvi->lVzrust
          drgMsgBox(drgNLS:msg( 'Nelze rušit pohyb u kategorie se vzrùstovým pøírùstkem !' ))
        ELSEIF ZvZmenHD->nKarta == 610
          drgMsgBox(drgNLS:msg( 'Pøevodní pohyb;;Pohyb nelze rušit. Již byly vygenerovány odpisy !' ))
        ELSE
          lOK := YES
        ENDIF
      ELSE
        lOK := YES
      ENDIF
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg( 'Automatizovanì generovaný pohyb;;S tímto druhem pohybu nelze manipulovat !' ))
  ENDIF

RETURN lOK

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:KategZvi_INFO()
  Local nRec1 := KategZvi->( RecNO()), nRec2 := ZvKarty->( RecNO())
  *
  ZVI_KategZvi_INFO(  ::drgDialog)
  *
  ( KategZvi->( dbGoTo( nRec1)), ZvKarty->( dbGoTo( nRec2)) )
RETURN NIL

********************************************************************************
METHOD ZVI_zsbZvKarty_SCR:zsbIndividEv()
  Local oDialog, nExit
  Local cScope := StrZero( ZvZmenHD->nDoklad,10)

  ZvZmenIT->( AdsSetOrder(2), mh_SetScope( cScope))
  oDialog := drgDialog():new('ZVI_zsbZvZmenIt_INF', ::drgDialog)
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  oDialog:destroy(.T.)
  oDialog := Nil
  ZvZmenIT->( mh_ClrScope())
RETURN NIL

*
*===============================================================================
FUNCTION  ZVI_ZvKarty_DEL()
  Local  cText := 'Kartu zvíøete nelze zrušit, nebo ', acText, cKey
  Local  lDEL := YES, lOK := YES, lLock, lSeek

  drgDBMS:open('ZvKarty_ps')
  *
  cKey := StrZERO( uctObdobi:ZVI:nROK, 4) + Upper( ZvKarty->cNazPol1) + ;
          Upper( ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6 )
  IF  ZvZmenHd->( dbSeek( cKey,, 'ZVZMENHD07'))
      cText += ' ; existují k ní pohybové vìty !'
      lDEL := NO
  ENDIF
  IF ZvKarty->nMnozSZv <> 0 .OR. ZvKarty->nKusyZv <> 0 .OR. ZvKarty->nCenaCZv <> 0
    cText += ' ; stav karty není nulový !'
    lDEL := NO
  ENDIF

  IF lDEL
    IF drgIsYesNO(drgNLS:msg('Zrušit evidenèní kartu zvíøete ?'))
       lSeek := ZvKarty_ps->( dbSeek( cKey,, 'ZVKARPS_02'))
       lLock := IF( lSeek, ZvKarty_ps->( RLock()), .T. )
       IF lLock .and. ZvKarty->( RLock())
         IF( lSeek, ZvKarty_ps->( dbDelete(), dbUnlock() ), NIL )
         ZvKarty->( dbDelete(), dbUnlock() )
       ENDIF
       /*
       ZvKarty->( RLock(), dbDelete(), dbUnlock() )
       */
    Endif
  ELSE
    drgMsgBox(drgNLS:msg( cText ))
  ENDIF

RETURN NIL

/*
*===============================================================================
FUNCTION  ZVI_KDforOBD()
  Local nRec, nRec1, nRec2, nPorZmeny, nCount
  Local cObdobi := uctObdobi:ZVI:cObdobi, cTag
  Local dDateForKD := CTOD( '01.' + LEFT(cObdobi, 2) + '.' + RIGHT(cObdobi, 2))
  Local nDaysInMonth := mh_LastDayOM( dDateForKD)
  Local cDenik   := SysConfig( 'Zvirata:cDenikZvZ')
  Local cUserAbb := SysConfig( 'System:cUserAbb')
  Local lLock, lProdukce := NO

  drgDBMS:open('ZvKarty'  )
  cTag := ZvKarty->( AdsSetOrder( 0))
  drgDBMS:open('KategZvi' )
  drgDBMS:open('C_DrPohZ' )
  drgDBMS:open('ZvZmenHD',,,,, 'ZvZmenHDa' )
  ZvZmenHDa->( AdsSetOrder( 3))

  IF C_DrPohZ->( dbSeek( 95,, 1))
    lProdukce := C_DrPohZ->lProdukce
  ENDIF

  ZvKarty->( dbGoTop())
  IF lLock := ZvKarty->( FLock())
    IF drgIsYesNO(drgNLS:msg('Požadujete vygenerovat krmné dny za období ?'))

      nCount := ZvKarty->( mh_COUNTREC())
        *
      drgServiceThread:progressStart(drgNLS:msg('Generuji krmné dny za období [ ' + cObdobi + ' ]  ...', 'ZvKarty'), nCount  )

      DO WHILE !ZvKarty->( Eof())
        nPorZmeny := ZVI_GetPorZME()
        If AddRec( 'ZvZmenHD')
           mh_CopyFld( 'ZvKarty', 'ZvZmenHD')
           ZvZmenHD->cDenik     := cDenik
           ZvZmenHD->nRok       := uctObdobi:ZVI:nROK    //  GetROK()
           ZvZmenHD->nObdobi    := uctObdobi:ZVI:nObdobi // GetOBD()
           ZvZmenHD->cObdobi    := cObdobi            // StoreOBD()
           ZvZmenHD->nKD        := nDaysInMonth * ZvZmenHD->nKusyZv
           ZvZmenHDa->( dbGoBottom())
           ZvZmenHD->nDoklad    := IF( ZvZmenHDa->nDoklad < 900000, 900000, ZvZmenHDa->nDoklad + 1 )
  *         ZvZmenHD->nDoklad    := GenDoklKD()
           ZvZmenHD->nOrdItem   := 0
           ZvZmenHD->nDrPohyb   := 95
           ZvZmenHD->nTypPohyb  := 1
           ZvZmenHD->lProdukce  := lProdukce
           KategZvi->( dbSeek( ZvZmenHD->nZvirKAT,, 1))
           ZvZmenHD->nTypVypCel := KategZvi->nTypVypCel
           ZvZmenHD->nCenaSZV   := IF( KategZvi->lVzrust, ZvKarty->nCenaV2ZV, 0 )
           ZvZmenHD->nCenaCZV   := ZvZmenHD->nCenasZV * ZvZmenHD->nKD
           ZvZmenHD->dDatPoriz  := DATE()
           ZvZmenHD->cUserAbb   := cUserAbb
           ZvZmenHD->dDatZmeny  := DATE()
           ZvZmenHD->cCasZmeny  := TIME()
           ZvZmenHD->cUloha     := 'Z'   //Uloha()
           ZvZmenHD->nPorZmeny  := nPorZmeny
           ZvZmenHD->nKusyZV    := 0
           ZvZmenHD->nMnozsZV   := 0
           ZvZmenHD->cFARMA     := PADR( ALLTRIM( STR( ZVI_CisFARMY( ZvZmenHD->cNazPol4, YES, 1 ) )), 10)
           mh_WRTzmena( 'ZvZmenHD', .T.)
           /*
           * Aktualizace ZvKarty
           ZvKarty->nKD         := IF( ZvZmenHD->nObdobi == 1, ZvZmenHD->nKD,;
                                                               ZvKarty->nKD + ZvZmenHD->nKD )
           ZvKarty->nCenaCZV    += ZvZmenHD->nCenaCZV
           ZvKarty->nCenaSZV    := IF( ZvZmenHD->nCenaCZV <> 0 ,;
                                       ZVI_SkladCENA( ZvKarty->cTypVypCen),;
                                       ZvKarty->nCenaSZV )
           ZvKarty->nKdPocZv    := IF( ZvZmenHD->nObdobi == 1, 0, ZvKarty->nKdPocZv)
           */
  **?         M_ZvKarObd( K_INS, ZvZmenHD->nTypPohyb)  //Ä ZvKarObd ... Kumulativn¡ soubor
  **?         M_ZvZmObd( K_INS)                        //Ä ZvZmObd  ... Kumulativn¡ soubor
           /*
           // IF ZvZmenHD->nCenaCZV <> 0
             IF lOK := MakeUcto( K_INS)
                UcetSys_AKT( ZvZmenHD->cObdobi)
             ENDIF
             LikCelDOKLAD()
           // ENDIF
           *
           ZvZmenHD->( dbUnlock())
        Endif
        ZvKarty->( dbSkip())
        *
        drgServiceThread:progressInc()
      ENDDO
      *
      drgServiceThread:progressEnd()
      drgMsgBox(drgNLS:msg( 'Krmné dny za období  [ & ] byly vygenerovány !', cObdobi))
      *
      ZvKarty->( dbUnlock(), AdsSetOrder( cTag))
    ENDIF
  ELSE

  ENDIF
RETURN NIL
*/

/*
//ÚÄ< VìpoŸet krmnìch dn… pro nov‚ obdob¡ >ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNCT KDforObd( nObdobi, dDateForKD)
  Local nRec := ZvKarty->( RecNo()), nRec1, nRec2, nPorZmeny
  Local cTag := ZvKarty->( AdsSetOrder( 0)), cTag1, cTag2
  Local nCount := 1, nLastRec := ZvKarty->( LastRec())
  Local nDaysInMonth := LastDayOM( nObdobi)
  Local cDenik   := SysConfig( 'Zvirata:cDenikZvZ')
  Local cUserAbb := SysConfig( 'System:cUserAbb')
  Local lLock, lOK, lProdukce := NO

  nDaysInMonth := LastDayOM( dDateForKD)
  OpenFiles( { 'KategZvi', 'C_DrPohZ'} )
  ( nRec1 := KategZvi->( RecNo()), cTag1 := KategZvi->( AdsSetOrder( 1)) )
  ( nRec2 := C_DrPohZ->( RecNo()), cTag2 := C_DrPohZ->( AdsSetOrder( 1)) )
  IF C_DrPohZ->( dbSeek( 95))
    lProdukce := C_DrPohZ->lProdukce
  ENDIF

  ZvKarty->( dbGoTop())
  If lLock := ZvKarty->( FLock())
    DO WHILE !ZvKarty->( Eof())
      nPorZmeny := GetPorZME()
      If AddRec( 'ZvZmenHD')
         PutITEM( 'ZvZmenHD', 'ZvKarty')
         ZvZmenHD->cDenik     := cDenik
         ZvZmenHD->nRok       := GetROK()
         ZvZmenHD->nObdobi    := GetOBD()
         ZvZmenHD->cObdobi    := StoreOBD()
         ZvZmenHD->nKD        := nDaysInMonth * ZvZmenHD->nKusyZv
         ZvZmenHD->nDoklad    := GenDoklKD()
         ZvZmenHD->nOrdItem   := 0
         ZvZmenHD->nDrPohyb   := 95
         ZvZmenHD->nTypPohyb  := 1
         ZvZmenHD->lProdukce  := lProdukce
         KategZvi->( dbSeek( ZvZmenHD->nZvirKAT))
         ZvZmenHD->nTypVypCel := KategZvi->nTypVypCel
         ZvZmenHD->nCenaSZV   := IF( KategZvi->lVzrust, ZvKarty->nCenaV2ZV, 0 )
         ZvZmenHD->nCenaCZV   := ZvZmenHD->nCenasZV * ZvZmenHD->nKD
         ZvZmenHD->dDatPoriz  := DATE()
         ZvZmenHD->cUserAbb   := cUserAbb
         ZvZmenHD->dDatZmeny  := DATE()
         ZvZmenHD->cCasZmeny  := TIME()
         ZvZmenHD->cUloha     := Uloha()
         ZvZmenHD->nPorZmeny  := nPorZmeny
         ZvZmenHD->nKusyZV    := 0
         ZvZmenHD->nMnozsZV   := 0
         ZvZmenHD->cFARMA     := PADR( ALLTRIM( STR( CisFARMY( ZvZmenHD->cNazPol4, YES, 1 ) )), 10)
         //Ä Aktualizace ZvKarty
//         ZvKarty->nKD      += ZvZmenHD->nKD
         ZvKarty->nKD      := IF( ZvZmenHD->nObdobi == 1, ZvZmenHD->nKD,;
                                  ZvKarty->nKD + ZvZmenHD->nKD )
         ZvKarty->nCenaCZV += ZvZmenHD->nCenaCZV
         ZvKarty->nCenaSZV := IF( ZvZmenHD->nCenaCZV <> 0 ,;
                                  SkladCENA( ZvKarty->cTypVypCen),;
                                  ZvKarty->nCenaSZV )
         ZvKarty->nKdPocZv := IF( ZvZmenHD->nObdobi == 1, 0, ZvKarty->nKdPocZv)

         M_ZvKarObd( K_INS, ZvZmenHD->nTypPohyb)  //Ä ZvKarObd ... Kumulativn¡ soubor
         M_ZvZmObd( K_INS)                        //Ä ZvZmObd  ... Kumulativn¡ soubor
         // IF ZvZmenHD->nCenaCZV <> 0
           IF lOK := MakeUcto( K_INS)
              UcetSys_AKT( ZvZmenHD->cObdobi)
           ENDIF
           LikCelDOKLAD()
         // ENDIF
         DCrUnlock( 'ZvZmenHD')
      Endif
      ThermCTRL( nCount, nLastRec, 15, 20)
      ( ZvKarty->( dbSkip()), nCount++ )
    ENDDO
    @ 15, 72 Say '‹' Color 'n/w'
    ZvKarty->( dbUnlock())
    ( ZvKarty->( AdsSetOrder( cTag)), ZvKarty->( dbGoTo( nRec)) )
  EndIf
  ( KategZvi->( AdsSetOrder( cTag1)), KategZvi->( dbGoTo( nRec1)) )
  ( C_DrPohZ->( AdsSetOrder( cTag2)), C_DrPohZ->( dbGoTo( nRec2)) )

RETURN Nil

*/

*
*===============================================================================
FUNCTION ZVI_GETPorZme()
  Local nPorZmeny, cTag //  := ZvZmenHDa->( AdsSetOrder( 4))
  Local cScope    := Upper( ZvKarty->cNazPol1) + Upper( ZvKarty->cNazPol4) + ;
                     StrZero( ZvKarty->nZvirKat, 6)

  drgDBMS:open('ZvZmenHD',,,,, 'ZvZmenHDa' )
  cTag := ZvZmenHDa->( AdsSetOrder( 4))
*  ZvZmenHDa->( AdsSetOrder( 3))

  ZvZmenHDa->( mh_SetScope( cScope) )
  nPorZmeny := IF( ZvZmenHDa->nPorZmeny == 0, 99999, ZvZmenHDa->nPorZmeny - 1)
  ZvZmenHDa->( mh_ClrScope(), AdsSetOrder( cTag))
RETURN nPorZmeny