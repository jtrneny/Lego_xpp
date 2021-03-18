/*==============================================================================
  ZVI_opeRegZviPR_SCR.PRG
==============================================================================*/

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Xbp.ch"
#include "Gra.ch"
#include "Collat.ch"
#include "..\Zvirata\ZVI_Zvirata.ch"

********************************************************************************
*
********************************************************************************
CLASS ZVI_opeRegZviPR_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled, ItemMarked, tabSelect
  METHOD  opeAktualREG

HIDDEN
  VAR     dc, tabNum
ENDCLASS

********************************************************************************
METHOD ZVI_opeRegZviPR_SCR:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('KategZVI'  )
  drgDBMS:open('C_DrPohP'  )
  drgDBMS:open('CNAZPOL1'  )
  drgDBMS:open('CNAZPOL4'  )
  *
RETURN self

********************************************************************************
METHOD ZVI_opeRegZviPR_SCR:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  RegZviPR->( DbSetRelation( 'KategZvi' , {|| RegZviPR->nZvirKat  } ,'RegZviPR->nZvirKat'  ))
  RegZviPR->( DbSetRelation( 'C_DrPohP' , {|| RegZviPR->nDrPohybP } ,'RegZviPR->nDrPohybP' ))
  *
  ::dc     := drgDialog:dialogCtrl
RETURN

********************************************************************************
METHOD ZVI_opeRegZviPR_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    /*
    CASE nEvent = drgEVENT_APPEND
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
*        drgMsgBox(drgNLS:msg( 'Úèetní  zmìny INSERT' ))
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = drgEVENT_EDIT
      IF ::tabNum = TAB_UCETNI .and. ::dc:oaBrowse:cFile = 'ZvZmenHD'
*        drgMsgBox(drgNLS:msg( 'Úèetní  zmìny ENTER' ))
        ::zsbPohyby( nEvent)
      ELSEIF ::tabNum = TAB_NEUCETNI
      ELSE
        RETURN .F.
      ENDIF
    */
    CASE nEvent = drgEVENT_DELETE

    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD ZVI_opeRegZviPR_scr:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.

********************************************************************************
METHOD ZVI_opeRegZviPR_SCR:ItemMarked()
RETURN SELF

********************************************************************************
METHOD ZVI_opeRegZviPR_SCR:opeAktualREG()
  *
  drgMsgBox( drgNLS:msg('Oprava stájového registru prasat ... '))
  *
  drgDBMS:open('C_TypPoh'  )
  RegZviPr->( DbGoTop())
  Do while !RegZviPr->( Eof())
    IF RegZviPr->( dbRLock())
*      IF C_DrPohZ->( dbSeek( RegZviPr->nDrPohyb,, 'DRPOHZ1' ))
      IF C_TypPoh->( dbSeek( 'Z' + Upper(RegZviPr->cTypPohybu),, 'C_TYPPOH06' ))
        RegZviPr->nTypPohyb := C_TypPoh->nTypPohyb
      ELSE
        RegZviPr->nTypPohyb := 1
      ENDIF
      RegZviPr->( dbUnlock())
    ENDIF
    RegZviPr->( dbSkip())
  EndDo
  *
RETURN self

* Aktualizace RegZviPR - stájového registru prasat
*===============================================================================
FUNCTION ZVI_RegZviPR( Dialog, lASK, lAktual)
  Local cKEY, cKEYmin, cTAG, cFARMA
  Local nCount := 1, nRecCount, nKusyPocSt, nCisReg := 0, nKARTA
  Local nPorCisLis, nPorCisRad, anCISLO, nFarmaODK, nFarmaKAM, lOK, lPREVOD := NO
  Local nROK := uctObdobi:ZVI:nROK, nOBD := uctObdobi:ZVI:nOBDOBI, nROKmin, nOBDmin
  Local nRadRegPra := SysConfig( 'Zvirata:nRadRegPra')

  DEFAULT lAsk TO .T.

*  IF drgIsYESNO(drgNLS:msg( 'Požadujete aktualizovat stájový registr prasat za  [ & / & ] ?', nObd, nRok ) )
  lOK := IF( lASK, drgIsYESNO(drgNLS:msg( 'Požadujete aktualizovat stájový registr prasat za  [ & / & ] ?', nObd, nRok ) ),;
                   lAktual )
  IF lOK
    drgDBMS:open('ZvZmenHD' )
    drgDBMS:open('ZvKarObd' )
*    drgDBMS:open('C_DrPohZ' )
    drgDBMS:open('C_TypPoh' )
    drgDBMS:open('C_Farmy'  )
    drgDBMS:open('Firmy'    )
    drgDBMS:open('RegZviPR' )

    * Zjištìní poè. stavu, tj. koncového stavu minulého období
    nOBDmin := IF( nOBD > 1, nOBD - 1, 12   )
    nROKmin := IF( nOBD > 1, nROK, nROK - 1 )
    cKEYmin := STRZERO( nROKmin, 4) + STRZERO( nOBDmin, 2) + UPPER( 'V')
  //  nKusyPocSt := PocSTAV( cKEYmin )
    * Vyèištìní RegZviPr
    cKEY := STRZERO( nROK, 4) + STRZERO( nOBD, 2) + UPPER( 'V')
    ClearREGISTER( LEFT( cKEY, 6) )
    *
    ZvZmenHD->( AdsSetOrder(10), mh_SetScope( cKey))
    nRecCount := dbCount( 'ZvZmenHD')
*    BOX_THERMO( 1, nCount, nRecCount, ;
*                  '< Okam§ik pros¡m >', 'Vytv ý¡m st jovì registr prasat za obdob¡ <'+ ;
*                                        STR( nOBD,2) + '/'+STR( nROK,4)+ '> ...',, 10 )
    drgServiceThread:progressStart(drgNLS:msg('Vytváøím stájový registr prasat za období ' + ;
                                   '< '+ Alltrim( str(nObd))+'/'+ Alltrim(str(nrok))+ ' > ', 'ZvZmenHD'), ZvZmenHD->(LASTREC()) )

    DO WHILE !ZvZmenHD->( EOF())
      IF ZvZmenHD->nDrPohybP <> 0
        EXIT
      ENDIF
      ZvZmenHD->( dbSKIP())
    ENDDO
    cFARMA := ZvZmenHD->cFARMA
    nKusyPocSt := PocSTAV( cKEYmin, cFARMA )

    anCISLO := CisLisRad( cFARMA)
    nPorCisLis := anCISLO[ 1]
    nPorCisRad := anCISLO[ 2]
    ZvZmenHD->( dbGoTOP())

    DO WHILE !ZvZmenHD->( EOF())
      lPREVOD := NO
      * pøi pøevodech zapisovat do registru jen když pøevádíme na jinou farmu
      nKARTA := ZvZmenHD->nKARTA
      IF ( nKARTA == 600 .OR. nKARTA == 610 .OR. nKARTA == 620 )  //- pýevody
        nFarmaODK := ZVI_CisFARMY( ZvZmenHD->cNazPol4  , YES, 1)
        nFarmaKAM := ZVI_CisFARMY( ZvZmenHD->cNazPol4_N, YES, 1)
        lOK := ( nFarmaODK <> nFarmaKAM )
        lPREVOD := lOK
      ELSE
        lOK := YES
      ENDIF
      //-
      IF ZvZmenHD->nDrPohybP <> 0 .AND. lOK   // zahrneme jen plemenáøské pohyby
        IF UPPER( cFARMA) <> UPPER( ZvZmenHD->cFARMA)
          cFARMA     := ZvZmenHD->cFARMA
          nKusyPocSt := PocSTAV( cKEYmin, cFARMA )
          anCISLO    := CisLisRad( cFARMA)
          nPorCisLis := anCISLO[ 1]
          nPorCisRad := anCISLO[ 2]
        ENDIF

        IF AddREC( 'RegZviPr')
*           PutITEM( 'RegZviPr', 'ZvZmenHD' )
           mh_CopyFld( 'ZvZmenHD', 'RegZviPr' )
           RegZviPr->dDatpZV    := ZvZmenHD->dDatZmZv
           RegZviPr->nPorCisLis := IF( nPorCisRAD = nRadRegPra, nPorCisLis + 1, nPorCisLis )
           RegZviPr->nPorCisRad := IF( nPorCisRAD = nRadRegPra, 1, nPorCisRAD + 1 )
           RegZviPr->nTypPohyb  := IF( ZvZmenHD->nTypPohyb == -1, 2, ZvZmenHD->nTypPohyb)
           RegZviPr->nKusy      := ZvZmenHD->nKusyZv
           RegZviPr->nKusyPocSt := nKusyPocSt
           RegZviPr->nKusyKonSt := nKusyPocSt + ( ZvZmenHD->nKusyZv * ZvZmenHD->nTypPohyb)
*           C_DrPohZ->( dbSEEK( ZvZmenHD->nDrPohyb,, 'DRPOHZ1'))
           C_TypPoh->( dbSeek( Upper(ZvZmenHD->cUloha) + Upper(ZvZmenHD->cTypPohybu),, 'C_TYPPOH06' ))
           RegZviPr->nDrPohybP  := C_TypPoh->nDrPohPlPr
           RegZviPr->nFarma     := ZVI_CisFARMY( ZvZmenHD->cNazPol4, YES, 1)
           RegZviPr->cFarma     := PADR( ALLTRIM( STR( RegZviPr->nFarma)), 10)
           RegZviPr->cFarmaKrj  := LEFT( RegZviPr->cFarma, 2)
           RegZviPr->cFarmaPod  := SubSTR( RegZviPr->cFarma, 3, 6)
           RegZviPr->cFarmaStj  := RIGHT( RegZviPr->cFarma, 2)
           RegZviPr->cKodHosp   := KodHOSP( RegZviPr->nFarma)

           IF lPREVOD
             nCisREG := nFarmaKAM
           ELSE
             nCisREG := ZVI_CisRegFIR()
           ENDIF
           RegZviPr->cFarmaZMN  := PADR( ALLTRIM( STR( nCisREG)), 10)
           RegZviPr->cFarZMNkrj := LEFT( RegZviPr->cFarmaZMN, 2)
           RegZviPr->cFarZMNpod := SubSTR( RegZviPr->cFarmaZMN, 3, 6)
           RegZviPr->cFarZMNstj := RIGHT( RegZviPr->cFarmaZMN, 2)

           IF ZvZmenHD->nTypPohyb == 1   // Pøíjem
             RegZviPr->cFarmaODK  := RegZviPr->cFarmaZMN
             RegZviPr->cFarODKkrj := LEFT( RegZviPr->cFarmaODK, 2)
             RegZviPr->cFarODKpod := SubSTR( RegZviPr->cFarmaODK, 3, 6)
             RegZviPr->cFarODKstj := RIGHT( RegZviPr->cFarmaODK, 2)
*             RegZviPr->cZvireZem  := IF( ZvZmenHD->nCisFirmy <> 0, Firmy->cZkratStat,;
*                                                                   RegZviPr->cZvireZem )
             IF ZvZmenHD->nCisFirmy <> 0
               Firmy->( dbSeek( ZvZmenHD->nCisFirmy,, 'FIRMY1'))
               RegZviPr->cZvireZem := Firmy->cZkratStat
             ENDIF

           ELSEIF ZvZmenHD->nTypPohyb == -1   // Výdej
             RegZviPr->cFarmaKAM  := RegZviPr->cFarmaZMN
             RegZviPr->cFarKAMkrj := LEFT( RegZviPr->cFarmaKAM, 2)
             RegZviPr->cFarKAMpod := SubSTR( RegZviPr->cFarmaKAM, 3, 6)
             RegZviPr->cFarKAMstj := RIGHT( RegZviPr->cFarmaKAM, 2)
           ENDIF
           mh_WRTzmena( 'RegZviPr', .T.)
           *
           nKusyPocSt := RegZviPr->nKusyKonSt
           nPorCisLis := RegZviPr->nPorCisLis
           nPorCisRad := RegZviPr->nPorCisRad
           RegZviPr->( dbUnlock())
        ENDIF
      ENDIF
*      BOX_THERMO( 0, nCount, nRecCount)
      ZvZmenHD->( dbSKIP()); nCount++
      drgServiceThread:progressInc()
    ENDDO
    ZvZmenHD->( mh_ClrScope())
*    BOX_THERMO( -1)
    drgServiceThread:progressEnd()
    RegZviPr->( dbGoTOP())

    IF( lASK, drgMsgBox( drgNLS:msg('Aktualizace stájového registru prasat ... KONEC ')), NIL )
  ENDIF

RETURN NIL

* Vyèištìní registru pro dané období a výše
*-------------------------------------------------------------------------------
STATIC FUNCTION ClearREGISTER( cKEY)
  Local cTAG := RegZviPr->( AdsSetOrder( 2))

  RegZviPr->( mh_SetScope( cKEY, '210012' ))
  DO WHILE !RegZviPr->( EOF())
     DelREC( 'RegZviPr')
     RegZviPr->( dbSKIP())
  ENDDO
  RegZviPr->( mh_ClrSCOPE(), AdsSetOrder( cTAG))
RETURN NIL

* Poèáteèní hodnoty èísla listu a èísla øádku
*-------------------------------------------------------------------------------
STATIC FUNCTION CisLisRad( cFARMA)
  Local nCisLis, nCisRad
  Local cTAG := RegZviPr->( AdsSetOrder( 1))

  RegZviPR->( mh_SetSCOPE( Upper( cFARMA)), dbGoBottom() )
  nCisLis := IF( RegZviPr->nPorCisLis == 0, 1, RegZviPr->nPorCisLis )
  nCisRad := RegZviPr->nPorCisRad
  RegZviPR->( mh_ClrSCOPE())
  RegZviPR->( AdsSetOrder( cTAG))
RETURN( { nCisLis, nCisRad } )

* Poèáteèní stav pro 1.pohyb v mìsíci
*-------------------------------------------------------------------------------
STATIC FUNCTION PocSTAV( cKEY, cFARMA )
  Local nKusyKon := 0, cTAG

 IF !EMPTY( cFARMA)
   RegZviPR->( mh_SetSCOPE( Upper( cFARMA)))
     IF RegZviPr->nPorCisLis == 0     // Prvn¡ z znam do registru dan‚ farmy
       RegZviPR->( mh_ClrSCOPE())
       IF AddREC( 'RegZviPr')
         RegZviPr->nROK       := uctObdobi:ZVI:nROK     // GetROK()
         RegZviPr->nOBDOBI    := uctObdobi:ZVI:nOBDOBI  // GetOBD()
         RegZviPr->COBDOBI    := STRZERO( RegZviPr->nObdobi, 2) + '/' + RIGHT( STR( RegZviPr->nROK, 4), 2)
         RegZviPr->dDatpZV    := CTOD( '01.' + LEFT( RegZviPr->cObdobi, 2) +'.'+RIGHT( RegZviPr->cObdobi, 2) )
         RegZviPr->nPorCisLis := 1
         RegZviPr->nPorCisRad := 1
//         RegZviPr->nTypPohyb  :=
         RegZviPr->nKusy      := 0
         nKusyKon := PocZvKarOBD( cKEY, cFARMA )
         RegZviPr->nKusyPocSt := nKusyKon
         RegZviPr->nKusyKonSt := RegZviPr->nKusyPocSt
         RegZviPr->nDrPohybP  := 29
         RegZviPr->nFarma     := VAL( cFARMA)
         RegZviPr->cFarma     := cFARMA
         RegZviPr->cKodHosp   := KodHOSP( RegZviPr->nFarma)
         mh_WRTzmena( 'RegZviPr', .T.)
         RegZviPr->( dbUnlock())
       ENDIF
     ELSE
       RegZviPR->( mh_ClrSCOPE())
       //- 10.6.2003
       cTAG := RegZviPr->( AdsSetOrder( 4))
       RegZviPR->( mh_SetSCOPE( Upper( cFarma) + LEFT( cKey, 6)),;
                   dbGoBottom())
       nKusyKon := RegZviPr->nKusyKonSt
       RegZviPR->( mh_ClrSCOPE(), AdsSetOrder( cTAG))
       *
    ENDIF
 ENDIF
RETURN( nKusyKon)

* Poèáteèní stav ze souboru ZvKarOBD
*-------------------------------------------------------------------------------
STATIC FUNCTION PocZvKarOBD( cKEY, cFARMA )
   Local cTAG := ZvKarObd->( AdsSetOrder( 4)), nKusyKon := 0

   ZvKarObd->( mh_SetSCOPE( cKEY + Upper( cFARMA) ))
   DO WHILE !ZvKarObd->( EOF())
     nKusyKon += ZvKarObd->nKusyKon
     ZvKarObd->( dbSKIP())
   ENDDO
   ZvKarObd->( mh_ClrSCOPE(), AdsSetOrder( cTAG))
RETURN( nKusyKon)

* Zjistí kód hosp. pro danou farmu
*-------------------------------------------------------------------------------
STATIC FUNCTION KodHOSP( nFARMA )
  C_Farmy->( dbSEEK( nFARMA,, 'FARMY_1'))
RETURN( C_Farmy->cKodHosp)