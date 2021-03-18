********************************************************************************
* ZVI_zsbPohybyObd_SCR.PRG
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch"
#include "XBP.Ch"

********************************************************************************
* ZVI_zsbPohybyObd_SCR ... Pohyby za období
********************************************************************************
CLASS ZVI_zsbPohybyObd_SCR FROM drgUsrClass
EXPORTED:
  VAR     nROK, nObdPOC, nObdKON, nObdobi, oneZvKarty, nDpVzrust
  VAR     nKusyZV  , nMnozSZV  , nKD  , nCenaCZV  , nCenapCeZV, nCenamCeZV
  VAR     nKusyZVor, nMnozSZVor, nKDor, nCenaCZVor, nCenapCEor, nCenamCEor

  METHOD  Init, Destroy, ItemMarked, drgDialogStart
  METHOD  ZVI_KUMUL, createKUMUL, emptyKUMUL, valorKUMUL

HIDDEN
  VAR     dc, dm, msg, cUser, dDate, cTime
  METHOD  copyToKUMUL, writeKumul
ENDCLASS

********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:init(parent)
  *
*  ::drgUsrClass:init(parent)
  drgDBMS:open('ZvKarty'   )
  drgDBMS:open('KategZvi'  )
  drgDBMS:open('C_UCTSKZ'  )
  *
  drgDBMS:open('ZvZmOBDw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('ZvZmenHD',,,,.T.,'ZvZmHD_1')
  ZvZmHD_1->( AdsSetOrder( 7))
  drgDBMS:open('C_TypPoh'  )
  *
  ::oneZvKarty := .T.
  ::cUser      := SysConfig( 'System:cUserABB')
  ::dDate      := Date()
  ::cTime      := Time()
  ::nDpVzrust  := SysConfig( 'Zvirata:nDpVzrust')
  *
  ::nROK    := uctObdobi:ZVI:nROK
  ::nObdobi := uctObdobi:ZVI:nOBDOBI
  ::nObdPOC := 1
  ::nObdKON := uctObdobi:ZVI:nOBDOBI
  *
RETURN self

********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ZvKarty->( DbSetRelation( 'KategZvi'  , {|| ZvKarty->nZvirKat  } ,'ZvKarty->nZvirKat'  ))
  ZvKarty->( DbSetRelation( 'C_UctSkZ'  , {|| ZvKarty->nUcetSkup } ,'ZvKarty->nUcetSkup' ))
  ZvZmOBDw->( DbSetRelation( 'C_TYPPOH', { || UPPER(cULOHA)+ UPPER(CTYPPOHYBU) },;
                                         'UPPER(cULOHA)+UPPER(CTYPPOHYBU)', 'C_TYPPOH06'))
RETURN self

********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:ItemMarked()
  Local cScope := Upper(ZvKarty->cNazPol1) + Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6)
  *
  ZvZmOBDw->( mh_SetScope( cScope))
  *
  IF ::oneZvKarty
    ::createKUMUL()
    *
    ::dc:oBrowse[2]:oXbp:refreshAll()
    ::dm:refresh()
  ENDIF

RETURN SELF

********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::nROK      := ::nObdPOC    := ::nObdKON  := ::oneZvKarty := ;
  ::nKusyZV   := ::nMnozSZV   := ::nKD      := ::nCenaCZV   := ::nCenapCeZV := ::nCenamCeZV := ;
  ::nKusyZVor := ::nMnozSZVor := ::nKDor    := ::nCenaCZVor := ::nCenapCEor := ::nCenamCEor := ;
  NIL
RETURN self

********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:createKUMUL()
  Local cScope, cKey, cTypPohybu, nObd, nObdPrev, nSign,x
  *
  IF( ::oneZvKarty, ZvZmOBDw->( dbZAP()), NIL )
  *
  ::nKusyZV   := ::nMnozSZV   := ::nKD      := ::nCenaCZV   := ::nCenapCeZV := ::nCenamCeZV := ;
  ::nKusyZVor := ::nMnozSZVor := ::nKDor    := ::nCenaCZVor := ::nCenapCEor := ::nCenamCEor := 0

  * kumulace pohybù
  cScope := StrZero(::nRok, 4) +Upper(ZvKarty->cNazPol1) +;
            Upper(ZvKarty->cNazPol4) + StrZero( ZvKarty->nZvirKat, 6)
  ZvZmHD_1->( mh_SetScope( cScope))
  cTypPohybu := ZvZmHD_1->cTypPohybu
  nObd       := ZvZmHD_1->nObdobi
  IF ! ZvZmHD_1->( Bof())
    ::emptyKumul( nObd)
  ENDIF
  *
  Do While !ZvZmHD_1->( Eof())

    nSIGN := IF( ZvZmHD_1->cTypPohybu = AllTrim(Str(::nDpVzrust)), ZvZmHD_1->nTypPohyb, 1 )

    IF cTypPohybu = ZvZmHD_1->cTypPohybu
      IF  nObd = ZvZmHD_1->nObdobi       // Aktuální období
        ::nKusyZV    += ( ZvZmHD_1->nKusyZV    * nSIGN )
        ::nMnozsZV   += ( ZvZmHD_1->nMnozsZV   * nSIGN )
        ::nKD        += ( ZvZmHD_1->nKD        * nSIGN )
        ::nCenacZV   += ( ZvZmHD_1->nCenacZV   * nSIGN )
        ::nCenapCeZV += ( ZvZmHD_1->nCenapCeZV * nSIGN )
        ::nCenamCeZV += ( ZvZmHD_1->nCenamCeZV * nSIGN )
      ELSE
        ZvZmHD_1->( dbSkip( -1))
        cKey := Upper(ZvZmHD_1->cNazPol1) + Upper(ZvZmHD_1->cNazPol4) + StrZero( ZvZmHD_1->nZvirKat, 6)+ ;
                Upper( ZvZmHD_1->cTypPohybu) + StrZero( ZvZmHD_1->nRok, 4) + StrZero( ZvZmHD_1->nObdobi, 2)
        IF ZvZmOBDw->( dbSEEK( cKey,, 'ZVZMOBD_01' ))
          ::writeKumul()
        ENDIF
        ZvZmHD_1->( dbSkip( 1))
        nObd         := ZvZmHD_1->nObdobi
        *
        ::nKusyZV    := ( ZvZmHD_1->nKusyZV    * nSIGN )
        ::nMnozsZV   := ( ZvZmHD_1->nMnozsZV   * nSIGN )
        ::nKD        := ( ZvZmHD_1->nKD        * nSIGN )
        ::nCenacZV   := ( ZvZmHD_1->nCenacZV   * nSIGN )
        ::nCenapCeZV := ( ZvZmHD_1->nCenapCeZV * nSIGN )
        ::nCenamCeZV := ( ZvZmHD_1->nCenamCeZV * nSIGN )
      ENDIF
      IF ZvZmHD_1->nObdobi <= ::nObdKON                // Od poèátku roku
        ::nKusyZVor  += ( ZvZmHD_1->nKusyZV    * nSIGN )
        ::nMnozsZVor += ( ZvZmHD_1->nMnozsZV   * nSIGN )
        ::nKDor      += ( ZvZmHD_1->nKD        * nSIGN )
        ::nCenacZVor += ( ZvZmHD_1->nCenacZV   * nSIGN )
        ::nCenapCEor += ( ZvZmHD_1->nCenapCeZV * nSIGN )
        ::nCenamCEor += ( ZvZmHD_1->nCenamCeZV * nSIGN )
      ENDIF

    ELSE
      ZvZmHD_1->( dbSkip( -1))
      cKey := Upper(ZvZmHD_1->cNazPol1) + Upper(ZvZmHD_1->cNazPol4) + StrZero(ZvZmHD_1->nZvirKat, 6)+ ;
              Upper( ZvZmHD_1->cTypPohybu) + StrZero( ZvZmHD_1->nRok, 4) + StrZero( ZvZmHD_1->nObdobi, 2)
      IF ZvZmOBDw->( dbSEEK( cKey,, 'ZVZMOBD_01' ))
        ::writeKumul()
      ENDIF
      ZvZmHD_1->( dbSkip( 1))
      cTypPohybu := ZvZmHD_1->cTypPohybu
      nObd       := ZvZmHD_1->nObdobi
      ::emptyKumul( nObd)
      *
      ::nKusyZV    := ( ZvZmHD_1->nKusyZV    * nSIGN )
      ::nMnozsZV   := ( ZvZmHD_1->nMnozsZV   * nSIGN )
      ::nKD        := ( ZvZmHD_1->nKD        * nSIGN )
      ::nCenacZV   := ( ZvZmHD_1->nCenacZV   * nSIGN )
      ::nCenapCeZV := ( ZvZmHD_1->nCenapCeZV * nSIGN )
      ::nCenamCeZV := ( ZvZmHD_1->nCenamCeZV * nSIGN )

      ::nKusyZVor  := ( ZvZmHD_1->nKusyZV    * nSIGN )
      ::nMnozsZVor := ( ZvZmHD_1->nMnozsZV   * nSIGN )
      ::nKDor      := ( ZvZmHD_1->nKD        * nSIGN )
      ::nCenacZVor := ( ZvZmHD_1->nCenacZV   * nSIGN )
      ::nCenapCEor := ( ZvZmHD_1->nCenapCeZV * nSIGN )
      ::nCenamCEor := ( ZvZmHD_1->nCenamCeZV * nSIGN )
    ENDIF

    ZvZmHD_1->( dbSkip())
  EndDo
  *
  ZvZmHD_1->( dbSkip( -1))
  cKey := Upper(ZvZmHD_1->cNazPol1) + Upper(ZvZmHD_1->cNazPol4) + StrZero(ZvZmHD_1->nZvirKat, 6)+ ;
          Upper( ZvZmHD_1->cTypPohybu) + StrZero( ZvZmHD_1->nRok, 4) + StrZero( ZvZmHD_1->nObdobi, 2)
  IF ZvZmOBDw->( dbSEEK( cKey,, 'ZVZMOBDw1' ))
    ::writeKumul()
  ENDIF
  *
  ZvZmHD_1->( mh_ClrScope())
  ZvZmOBDw->( dbGoTOP())
  *
  IF ::oneZvKarty
    ::valorKUMUL()
  ENDIF

  /* Do záznamù za období, kde nebyl pohyb, doplnit nápoèty od poèátku roku
  DO WHILE !ZvZmOBDw->( EOF())
    IF ( ZvZmOBDw->nKusyZV + ZvZmOBDw->nMnozsZV + ZvZmOBDw->nKD + ZvZmOBDw->nCenacZV = 0)
      *
      ZvZmOBDw->( dbSkip( -1))
      ::nKusyZVor  := ZvZmOBDw->nKusyZVor
      ::nMnozsZVor := ZvZmOBDw->nMnozsZVor
      ::nKDor      := ZvZmOBDw->nKDor
      ::nCenacZVor := ZvZmOBDw->nCenacZVor
      ::nCenapCEor := ZvZmOBDw->nCenapCEor
      ::nCenamCEor := ZvZmOBDw->nCenamCEor
      *
      ZvZmOBDw->( dbSkip())
      ZvZmOBDw->nKusyZVor  := ::nKusyZVor
      ZvZmOBDw->nMnozsZVor := ::nMnozsZVor
      ZvZmOBDw->nKDor      := ::nKDor
      ZvZmOBDw->nCenacZVor := ::nCenacZVor
      ZvZmOBDw->nCenapCEor := ::nCenapCEor
      ZvZmOBDw->nCenamCEor := ::nCenamCEor
    ENDIF
    ZvZmOBDw->( dbSkip())
  ENDDO
  *
  ZvZmOBDw->( dbGoTOP())
  */
RETURN SELF

* vygeneruje prázdné záznamy od období prvního výskytu pohybu do aktuálního období
********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:emptyKUMUL( nObd)
  Local x
  *
  FOR x := nObd TO ::nObdKON
    mh_CopyFLD( 'ZvZmHD_1', 'ZvZmOBDw', .T.)
    ZvZmOBDw->nRok       := ::nRok
    ZvZmOBDw->nObdobi    := x
    ZvZmOBDw->cObdobi    := StrZero( x, 2) + '/' + RIGHT( STR(::nROK), 2)

    ZvZmOBDw->nKusyZV    := 0
    ZvZmOBDw->nMnozsZV   := 0
    ZvZmOBDw->nKD        := 0
    ZvZmOBDw->nCenacZV   := 0
    ZvZmOBDw->nCenapCeZV := 0
    ZvZmOBDw->nCenamCeZV := 0
    *
    ZvZmOBDw->cUserAbb   := ::cUser
    ZvZmOBDw->dDatZmeny  := ::dDate
    ZvZmOBDw->cCasZmeny  := ::cTime
  NEXT
RETURN SELF

* Aktualizace hodnotami za období a od poè.roku
********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:writeKUMUL( nObd)

  * za dané období
  ZvZmOBDw->nKusyZV    := ::nKusyZV
  ZvZmOBDw->nMnozsZV   := ::nMnozsZV
  ZvZmOBDw->nKD        := ::nKD
  ZvZmOBDw->nCenacZV   := ::nCenacZV
  ZvZmOBDw->nCenapCeZV := ::nCenapCeZV
  ZvZmOBDw->nCenamCeZV := ::nCenamCeZV
  * od poè. roku
  ZvZmOBDw->nKusyZVor  := ::nKusyZVor
  ZvZmOBDw->nMnozsZVor := ::nMnozsZVor
  ZvZmOBDw->nKDor      := ::nKDor
  ZvZmOBDw->nCenacZVor := ::nCenacZVor
  ZvZmOBDw->nCenapCEor := ::nCenapCEor
  ZvZmOBDw->nCenamCEor := ::nCenamCEor
  *
RETURN SELF

* Do záznamù za období, kde nebyl pohyb, doplnit nápoèty od poèátku roku
********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:valorKUMUL()
  Local cKey
  /*
  ZvZmOBDw->( dbGoTOP())
  DO WHILE !ZvZmOBDw->( EOF())
    IF ( ZvZmOBDw->nKusyZV + ZvZmOBDw->nMnozsZV + ZvZmOBDw->nKD + ZvZmOBDw->nCenacZV = 0)
      *
      ZvZmOBDw->( dbSkip( -1))
      ::nKusyZVor  := ZvZmOBDw->nKusyZVor
      ::nMnozsZVor := ZvZmOBDw->nMnozsZVor
      ::nKDor      := ZvZmOBDw->nKDor
      ::nCenacZVor := ZvZmOBDw->nCenacZVor
      ::nCenapCEor := ZvZmOBDw->nCenapCEor
      ::nCenamCEor := ZvZmOBDw->nCenamCEor
      *
      ZvZmOBDw->( dbSkip())
      ZvZmOBDw->nKusyZVor  := ::nKusyZVor
      ZvZmOBDw->nMnozsZVor := ::nMnozsZVor
      ZvZmOBDw->nKDor      := ::nKDor
      ZvZmOBDw->nCenacZVor := ::nCenacZVor
      ZvZmOBDw->nCenapCEor := ::nCenapCEor
      ZvZmOBDw->nCenamCEor := ::nCenamCEor
    ENDIF
    ZvZmOBDw->( dbSkip())
  ENDDO
  */
  ZvZmOBDw->( dbGoTOP())
  cKey := Upper(ZvZmOBDw->cNazPol1) + Upper(ZvZmOBDw->cNazPol4) + StrZero(ZvZmOBDw->nZvirKat, 6)
  DO WHILE !ZvZmOBDw->( EOF())
    IF ( ZvZmOBDw->nKusyZV + ZvZmOBDw->nMnozsZV + ZvZmOBDw->nKD + ZvZmOBDw->nCenacZV = 0)
      if cKey = Upper(ZvZmOBDw->cNazPol1) + Upper(ZvZmOBDw->cNazPol4) + StrZero(ZvZmOBDw->nZvirKat, 6)
        *
        ZvZmOBDw->( dbSkip( -1))
        ::nKusyZVor  := ZvZmOBDw->nKusyZVor
        ::nMnozsZVor := ZvZmOBDw->nMnozsZVor
        ::nKDor      := ZvZmOBDw->nKDor
        ::nCenacZVor := ZvZmOBDw->nCenacZVor
        ::nCenapCEor := ZvZmOBDw->nCenapCEor
        ::nCenamCEor := ZvZmOBDw->nCenamCEor
        *
        ZvZmOBDw->( dbSkip())
        ZvZmOBDw->nKusyZVor  := ::nKusyZVor
        ZvZmOBDw->nMnozsZVor := ::nMnozsZVor
        ZvZmOBDw->nKDor      := ::nKDor
        ZvZmOBDw->nCenacZVor := ::nCenacZVor
        ZvZmOBDw->nCenapCEor := ::nCenapCEor
        ZvZmOBDw->nCenamCEor := ::nCenamCEor
      else
        ::nKusyZVor  := 0
        ::nMnozsZVor := 0
        ::nKDor      := 0
        ::nCenacZVor := 0
        ::nCenapCEor := 0
        ::nCenamCEor := 0
        *
        ZvZmOBDw->nKusyZVor  := ::nKusyZVor
        ZvZmOBDw->nMnozsZVor := ::nMnozsZVor
        ZvZmOBDw->nKDor      := ::nKDor
        ZvZmOBDw->nCenacZVor := ::nCenacZVor
        ZvZmOBDw->nCenapCEor := ::nCenapCEor
        ZvZmOBDw->nCenamCEor := ::nCenamCEor
        *
        cKey := Upper(ZvZmOBDw->cNazPol1) + Upper(ZvZmOBDw->cNazPol4) + StrZero(ZvZmOBDw->nZvirKat, 6)
      endif
    ENDIF
    ZvZmOBDw->( dbSkip())

    if cKey <> Upper(ZvZmOBDw->cNazPol1) + Upper(ZvZmOBDw->cNazPol4) + StrZero(ZvZmOBDw->nZvirKat, 6)
      cKey := Upper(ZvZmOBDw->cNazPol1) + Upper(ZvZmOBDw->cNazPol4) + StrZero(ZvZmOBDw->nZvirKat, 6)
    endif
  ENDDO
  *
  ZvZmOBDw->( dbGoTOP())
RETURN SELF

*
********************************************************************************
METHOD ZVI_zsbPohybyObd_SCR:ZVI_KUMUL()
  Local cC := 'Požadujete provést výpoèet kumulací pohybù za období pro všechny karty ?'
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  Local nRec := ZVKARTY->( RecNO()), nCount := 0
  *
  IF drgIsYESNO(drgNLS:msg( cC))
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Generuji pohyby za období ...', 'ZVKARTY'), ZVKARTY->(LASTREC()) )
    ::oneZvKarty := .F.
    ZvZmOBDw->( dbZAP())
    ZVKARTY->( dbGoTOP())
    DO WHILE !ZVKARTY->( EOF())
      ::createKUMUL( .F.)

      ZVKARTY->( dbSkip())
      drgServiceThread:progressInc()
    ENDDO
    ZVKARTY->( dbGoTO( nRec))
    drgServiceThread:progressEnd()
    ::msg:WriteMessage(,0)
    *
    ::valorKUMUL()
    *
    ::copyToKUMUL()
  ENDIF
  *
RETURN SELF

*
**HIDDEN ***********************************************************************
METHOD ZVI_zsbPohybyObd_SCR:copyToKUMUL()
  Local cTAG
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')
  *
  IF drgIsYESNO(drgNLS:msg( 'Požadujete uložit výpoètenou kumulaci pro všechny karty ?'))

    drgDBMS:open('ZvZmOBD', .T. )
    IF ZvZmOBD->( FLock())
      ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
      drgServiceThread:progressStart(drgNLS:msg('Ukládám vypoètené kumulace ...', 'ZvZmOBDw'), ZvZmOBDw->(LASTREC()) )
      ZvZmOBD->( dbZAP())

      cTag := ZvZmOBDw->( AdsSetOrder(0))
      ZvZmOBDw->( dbGoTOP())
      DO WHILE !ZvZmOBDw->( EOF())
        mh_CopyFLD( 'ZvZmOBDw', 'ZvZmOBD', .T.)
        ZvZmOBDw->( dbSkip())
        drgServiceThread:progressInc()
      ENDDO
      ZvZmOBDw->( AdsSetOrder( cTag))

      ZvZmOBD->( dbUnlock(), dbCloseArea() )
      drgServiceThread:progressEnd()
      ::msg:WriteMessage(,0)
    ELSE
      drgMsgBox(drgNLS:msg( 'Kumulativní soubor pohybù [ ZVZMOBD] se nepodaøilo uzamknout ... '))
    ENDIF
  ENDIF
  *
RETURN SELF

* Aktualizace ( pøepoèet) kumulativního souboru ZvZmOBDw  pøed TISKEM
*===============================================================================
FUNCTION ZVI_ZVZMOBD_PRN( nTypKum)
  Local zsbPohybyObd, cTag, cKey
  Local nKusyZV  , nMnozSZV  , nKD  , nCenaCZV  , nCenapCeZV, nCenamCeZV
  Local nKusyZVor, nMnozSZVor, nKDor, nCenaCZVor, nCenapCEor, nCenamCEor

  DEFAULT nTypKum TO 1
  * nTypKum ...typ kumulace :  1 = za stø., stáj, kateg., pohyb, rok, mìsíc
  *                            2 = za             kateg., pohyb, rok, mìsíc


  zsbPohybyObd            := ZVI_zsbPohybyObd_SCR():new()
  zsbPohybyObd:oneZvKarty := .F.                          // generovat za všechny položky ZVKARTY
  zsbPohybyObd:nRok       := VAL( RIGHT( obdReport, 4))
  zsbPohybyObd:nObdKON    := VAL( LEFT( obdReport, 2))
  *
  drgServiceThread:progressStart(drgNLS:msg('Generuji pohyby za období ' + obdReport + ' ...', 'ZVKARTY'), ZVKARTY->(LASTREC()) )

  ctag := zvZmObdw->( ordsetFocus())

  zvZmObdw->( ordsetFocus('ZVZMOBDw1'))
  ZvZmOBDw->( dbZAP(), mh_ClrScope() )
  ZVKARTY ->( dbGoTOP())

  ctag := zvZmObdw->( ordsetFocus())

  DO WHILE !ZVKARTY->( EOF())
    zsbPohybyObd:createKUMUL()
    ZVKARTY->( dbSkip())
    drgServiceThread:progressInc()
  ENDDO
  *
  drgServiceThread:progressEnd()
  *

  ZvZmOBDw->(dbcommit())
  zsbPohybyObd:valorKUMUL()
  *
  *-----
  IF nTypKum = 2
    * Kumulace za kategorie uložíme do ZvZmOBDww
    drgDBMS:open('ZvZmOBDww' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    ZvZmOBDw->( AdsSetOrder( 2), dbGoTOP() )
    cKey    := STRZERO(ZvZmOBDw->NZVIRKAT, 6) + UPPER(ZvZmOBDw->cTypPohybu) + ;
               STRZERO(ZvZmOBDw->NROK,4) + STRZERO(ZvZmOBDw->NOBDOBI,2)
    *
    nKusyZV   := nMnozSZV   := nKD   := nCenaCZV   := nCenapCeZV := nCenamCeZV := 0
    nKusyZVor := nMnozSZVor := nKDor := nCenaCZVor := nCenapCEor := nCenamCEor := 0
    *
    DO WHILE ! ZvZmOBDw->( EOF())

      cKeyNew := STRZERO(ZvZmOBDw->NZVIRKAT, 6) + UPPER(ZvZmOBDw->cTypPohybu) + ;
                 STRZERO(ZvZmOBDw->NROK,4) + STRZERO(ZvZmOBDw->NOBDOBI,2)

      IF cKey = cKeyNew
        nKusyZV    += ZvZmOBDw->nKusyZV
        nMnozsZV   += ZvZmOBDw->nMnozsZV
        nKD        += ZvZmOBDw->nKD
        nCenacZV   += ZvZmOBDw->nCenacZV
        nCenapCeZV += ZvZmOBDw->nCenapCeZV
        nCenamCeZV += ZvZmOBDw->nCenamCeZV
        * od poè. roku
        nKusyZVor  += ZvZmOBDw->nKusyZVor
        nMnozsZVor += ZvZmOBDw->nMnozsZVor
        nKDor      += ZvZmOBDw->nKDor
        nCenacZVor += ZvZmOBDw->nCenacZVor
        nCenapCEor += ZvZmOBDw->nCenapCEor
        nCenamCEor += ZvZmOBDw->nCenamCEor
      ELSE
        ZvZmOBDw->( dbSkip(-1))
        mh_CopyFLD( 'ZvZmOBDw', 'ZvZmOBDww', .T.)
        ZvZmOBDww->cNazPol1   := ''
        ZvZmOBDww->cNazPol4   := ''

        ZvZmOBDww->nKusyZV    := nKusyZV
        ZvZmOBDww->nMnozsZV   := nMnozsZV
        ZvZmOBDww->nKD        := nKD
        ZvZmOBDww->nCenacZV   := nCenacZV
        ZvZmOBDww->nCenapCeZV := nCenapCeZV
        ZvZmOBDww->nCenamCeZV := nCenamCeZV
        * od poè. roku
        ZvZmOBDww->nKusyZVor  := nKusyZVor
        ZvZmOBDww->nMnozsZVor := nMnozsZVor
        ZvZmOBDww->nKDor      := nKDor
        ZvZmOBDww->nCenacZVor := nCenacZVor
        ZvZmOBDww->nCenapCEor := nCenapCEor
        ZvZmOBDww->nCenamCEor := nCenamCEor

        cKey := cKeyNew
        *
        nKusyZV   := nMnozSZV   := nKD   := nCenaCZV   := nCenapCeZV := nCenamCeZV := 0
        nKusyZVor := nMnozSZVor := nKDor := nCenaCZVor := nCenapCEor := nCenamCEor := 0
        *
      ENDIF
      ZvZmOBDw->( dbSkip())
    ENDDO
    *
    ZvZmOBDw->( dbSkip(-1))
    mh_CopyFLD( 'ZvZmOBDw', 'ZvZmOBDww', .T.)
    ZvZmOBDww->cNazPol1   := ''
    ZvZmOBDww->cNazPol4   := ''
    *
    ZvZmOBDww->nKusyZV    := nKusyZV
    ZvZmOBDww->nMnozsZV   := nMnozsZV
    ZvZmOBDww->nKD        := nKD
    ZvZmOBDww->nCenacZV   := nCenacZV
    ZvZmOBDww->nCenapCeZV := nCenapCeZV
    ZvZmOBDww->nCenamCeZV := nCenamCeZV
    * od poè. roku
    ZvZmOBDww->nKusyZVor  := nKusyZVor
    ZvZmOBDww->nMnozsZVor := nMnozsZVor
    ZvZmOBDww->nKDor      := nKDor
    ZvZmOBDww->nCenacZVor := nCenacZVor
    ZvZmOBDww->nCenapCEor := nCenapCEor
    ZvZmOBDww->nCenamCEor := nCenamCEor
    *
    * Kumulace za kategorie pøeklopíme ze ZvZmOBDww do ZvZmOBDw
    ZvZmOBDw->( dbZap())
    ZvZmOBDww->( dbGoTOP(),;
                 dbEval( {||  mh_CopyFLD( 'ZvZmOBDww', 'ZvZmOBDw', .T.) }),;
                 dbGoTOP() )
  ENDIF
  *-----

  * Ponecháme jen poslední období
  zvZmObdw->( dbeval( { || zvZmObdw->(dbdelete()) }, ;
                      { || zvZmobdW->nobdobi <> zsbPohybyObd:nObdKON }), ;
              dbpack()                                                 , ;
              dbgoTop()                                                  )

/*
  cTag := ZvZmOBDw->( ordSetFocus(0))
  ZvZmOBDw->( dbGoTOP())
  Do While !ZvZmOBDw->( Eof())
    IF ZvZmOBDw->nObdobi <> zsbPohybyObd:nObdKON
      ZvZmOBDw->( dbDelete())
    ENDIF
    ZvZmOBDw->( dbSkip())
  EndDo
  ZvZmOBDw->( ordSetFocus(cTag), dbPack(), dbGoTOP())
*/
  *
RETURN NIL