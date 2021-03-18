/*==============================================================================NEW
  SKL_PRIJEM.PRG
==============================================================================*/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

CLASS SKL_pohyb_PRIJEM
EXPORTED:
  VAR     IT, HD, nMnHlp_prij

  METHOD  Init
  *
  METHOD  MnPrijate, MnHlp_prij
ENDCLASS


METHOD SKL_pohyb_PRIJEM:init(parent)

  ::IT := parent:parent:udcp:IT
  ::HD := parent:parent:udcp:HD

RETURN self

********************************************************************************
METHOD SKL_pohyb_PRIJEM:MnPrijate(oVar)
  Local lOK := .T.
  Local dm := oVar:drgDialog:dataManager,  UDCP := oVar:drgDialog:UDCP
  Local nVAL := oVar:value, nMnozsZBO, nPos, newIT := UDCP:newIt
  Local lValid := ( oVar:changed().or. newIT)
  Local nKarta := UDCP:nKarta

  ::IT := UDCP:IT

  IF lValid
    nVal := PrepocetMJ( nVal, dm:get(::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )
    dm:set(::IT + '->nMnozPrDod', nVal)

    IF !newIt .and. (::IT)->_nrecor <> 0 .AND. CenZboz->nMnozsZBO == 0
      drgMsgBox(drgNLS:msg('Nelze opravit pøíjemku, je-li skladové množství nulové !;'+ ;
                           'Je nutno udìlat pøíjem nebo zrušit výdej !'), XBPMB_CRITICAL )
      RETURN .F.
    ENDIF
    ::MnHlp_prij( dm:get(::IT + '->cSklPol') )
    nMnozsZBO := CenZboz->nMnozsZBO - If( newit, 0, (::IT)->nMnozPrDOD) + ::nMnHlp_prij
    Do Case
      Case nVal == 0
        drgMsgBox(drgNLS:msg('Množství pøijaté nesmí být nulové !'), XBPMB_CRITICAL )
        lOK := .f.
      Case nVal < 0
        lOK := If( Upper( CenZboz->cTypSklCen) == 'PEV', .T. ,;
                      !( Abs( nVal) > nMnozsZBO ))
        If !lOK
          drgMsgBox(drgNLS:msg('Množství skladové je pouze < & > !', nMnozsZbo), XBPMB_CRITICAL )
        Else
          TestMin( Abs( nVal))
        EndIf
      OtherWise
        lOK := ( CenZboz->nMnozSZBO + nVal - (::IT)->nMnozPrDod >= 0 )
        If     lOK ; TestMax( nVal)
        ElseIf !newIt .and. (::IT)->_nrecor <> 0   // isChanged
          drgMsgBox(drgNLS:msg('Touto opravou by se množství skladové dostalo do minusu !;'+;
                               'Na položku již zøejmì probìhl výdej !'), XBPMB_CRITICAL )
        Else           ; lOK := .T.
        EndIf
    EndCase
    dm:set(::IT + '->NCENACELK', dm:get(::IT + '->NCENNAPDOD') * dm:get(::IT + '->NMNOZPRDOD') )
    IF nKarta = 117
      dm:set(::IT + '->nCenCelkZM', dm:get(::IT + '->nCenNaDoZM') * dm:get(::IT + '->nMnozDokl1')  )
    ENDIF
  EndIf
RETURN lOk

********************************************************************************
METHOD SKL_pohyb_PRIJEM:MnHlp_prij( cSklPol)
  Local nRecNo := (::IT)->( RecNo())

  ::nMnHlp_prij := 0
*  (::IT)->( dbEval({|| ::nMnHlp_prij += IF( cSklPol = (::IT)->cSklPol, (::IT)->nMnozPrDod, 0 ) }))
  (::IT)->( dbEval({|| ::nMnHlp_prij += IF( cSklPol = (::IT)->cSklPol,  IF((::IT)->_nRecOr=0,(::IT)->nMnozPrDod,0), 0 ) }))
  (::IT)->( dbGoTo( nRecNo))
RETURN self


********************************************************************************
*METHOD SKL_pohyb_PRIJEM:NutneVN( nKey, nRecPVP, lKontrolSuma)
FUNCTION NutneVN( nKey, nRecPVP, lKontrolSuma)
*
  Local HD := 'PVPHEADw', IT := 'PVPITEMww'
  Local nOldRec := (IT)->( RecNo())
  Local nCountItem := 0, n := 0
  Local nSuma := 0, nRest, nKoef, nNewSuma := 0, nCenaCELK, nItemVN
  Local nSumaZM := 0, nRestZM, nKoefZM, nCenaCELKZM, nItemVNZM
  LOCAL cTypPohyb := LEFT( ALLTRIM(STR( (HD)->nKarta)), 1 )
  LOCAL cTypHead  := SUBSTR( ALLTRIM(STR( (HD)->nKarta)), 2, 1)
    *
  DEFAULT lKontrolSuma TO .T.
  DEFAULT nKey         TO xbeK_ENTER
  *
  IF cTypPohyb = PRIJEM .and. cTypHead $ '1,2,3'   // cTypHead <> '0' .and. cTypHead <> '4'
    IF (HD)->nNutneVN <> 0 .or. PCount() = 0
      (IT)->( dbGoTop())
      DO WHILE ! (IT)->( Eof())
*        SKL_UcetPol_DEL()
          (IT)->cUctovano := ' '
**        IF ( nKey == xbeK_DEL .and. (IT)->( RecNo()) == nRecPVP )
**        ELSE
          nSuma   += (IT)->nMnozPrDOD * (IT)->nCenNapDOD
          nSumaZM += (IT)->nMnozDokl1 * (IT)->nCenNaDoZM
**        ENDIF
        nCountItem++
        (IT)->( dbSkip())
      ENDDO
*      SKL_UcetPol_DEL( .t.)   // zruší zaúètování rozdílu pøi pøíjmu

      nSuma  := Round( nSuma, 2)
      nRest  := (HD)->nNutneVN
      nKoef  := If( nSuma <> 0, (HD)->nNutneVN / nSuma, 0 )
      *
      nSumaZM := Round( nSumaZM, 2)
      nRestZM := (HD)->nNutneVNZM
      nKoefZM := If( nSumaZM <> 0, (HD)->nNutneVNZM / nSumaZM, 0 )
      *
      (IT)->( dbGoTop())
      DO WHILE ! (IT)->( Eof())
        n++
        PVPITEMw->( dbZAP())
        mh_COPYFLD('PVPITEMww', 'PVPITEMw', .T.)
        nCenaCELK := (IT)->nMnozPrDOD * (IT)->nCenNapDOD
        nItemVN   := If( n = nCountItem, nRest, ROUND( ( nCenaCELK * nKoef ), 2 ) )
        (IT)->nCenaCelk  := nCenaCELK + nItemVN
        (IT)->nRozdilPoh := nItemVN
        (IT)->nCenapDZBO := (IT)->nCenaPZBO * ( 1 + ( SeekKodDph( (IT)->nKlicDph) / 100))

        nRest := nRest - Round( (( (IT)->nMnozPrDOD * (IT)->nCenNapDOD) * nKoef ), 2 )
        /* 3.7.2009
        IF  (IT)->( RecNo()) = nRecPVP ;  ModiCen_prijem( nKey )
        ELSE                           ;  ModiCen_prijem( xbeK_ENTER )
        ENDIF
        */
        * Pøíjem v zahr.mìnì - 29.10.2008
        IF (HD)->nKarta = 117
          nCenaCELKZM := (IT)->nMnozDokl1 * (IT)->nCenNaDoZM
          nItemVNZM   := If( n = nCountItem, nRestZM, ROUND( ( nCenaCELKZM * nKoefZM ), 2 ) )
          (IT)->nCenCelkZM  := nCenaCELKZM + nItemVNZM
          nRestZM := nRestZM - Round( (( (IT)->nMnozDokl1 * (IT)->nCenNaDoZM) * nKoefZM ), 2 )
        ENDIF
        *
        nNewSuma += (IT)->nCenaCelk
        (IT)->( dbSkip())
      ENDDO
    ELSE
    *
*      SKL_UcetPol_DEL()
      (IT)->cUctovano := ' '
      (IT)->nCenaCelk := Round( (IT)->nMnozPrDOD * (IT)->nCenNapDOD, 2 )
      (IT)->nCenapDZBO := (IT)->nCenaPZBO * ( 1 + ( SeekKodDph( (IT)->nKlicDph) / 100))
*      SKL_ModiCen( nKey )
    *
    ENDIF
*    IF ( lKontrolSuma, KontrolSuma( .t., xbeK_CTRL_S ), Nil )
    RozdilPriPrijmu()
    (IT)->( dbGoTo( nOldRec))
  ENDIF

RETURN( nNewSuma)

* Kontrolni rozdil do hlavicky pøim pøíjmu
*****************************************************************
FUNCTION RozdilPriPrijmu()      //( lControl, nKey)
  Local nSuma := 0, nRozdil := 0.00, nPos, aKarty := { 110,117,120,130}, nRec

  IF ( nPos := ASCAN( aKarty, PVPHEADw->nKarta)) > 0
    nRec := PVPITEMww->( RecNo())
    PVPITEMww->( dbEval( {|| nSuma +=  ;
      if( PVPITEMww->nDoklad == PVPHEADw->nDoklad, PVPITEMww->nCenaCelk, 0.00) } ))
    PVPITEMww->( dbGoTO( nRec))

    nRozdil := PVPHEADw->nCenaDokl + PVPHEADw->nNutneVN - nSuma
    nRozdil := ROUND( nRozdil, 2 )
    *
    IF PVPHeadw->( sx_RLock())
      PVPHEADw->nCenaPol := nSuma
      IF PVPHEADw->nRozPrij <> nRozdil
        PVPHeadw->nRozPrij := nRozdil
      ENDIF
      PVPHeadw->( dbUnlock())
    ENDIF
  ENDIF
Return( nRozdil)

* Modifikace skl.ceny celkem v CenZboz pøi pøíjmu
*===============================================================================
FUNCTION ModiCen_prijem( nKey, cTypPohyb, cTypHead, cIT )
  Local cKey := Upper( (cIT)->cCisSklad) + Upper( (cIT)->cSklPol )

IF cTypPohyb = PRIJEM .and. cTypHead $ '1,2,3'
  If CenZboz->( dbSeek( cKey,, 'CENIK03')) .and. ReplRec( 'CenZboz' )
    If Upper( CenZboz->cPolCen) = 'C'
      Do Case
        Case nKey = xbeK_INS
          CenZboz->nCenacZBO += (cIT)->nCenaCelk
        Case nKey = xbeK_ENTER
          CenZboz->nCenacZBO += (cIT)->nCenaCelk - PVPItem->nCenaCelk
        Case nKey = xbeK_DEL
          CenZboz->nCenacZBO -= (cIT)->nCenaCelk
      EndCase
*      PVPITEMww->nCenacZBO := CenZboz->nCenacZBO
*      CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, 'PVPITEMww' )
      IF cIT = 'PVPITEMww'
        (cIT)->nCenacZBO := CenZboz->nCenacZBO
      ENDIF
      CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen, cIT )

    EndIf
    CENZBOZ->( dbUnlock())
  EndIf
ENDIF
Return( Nil)

*-------------------------------------------------------------------------------
FUNCTION Prijem_isOK( cHD, cIT, lMessage, lVN)
  Local lOK := .T., nRec

  DEFAULT lMessage TO .T., lVN TO .F. //, cFile TO 'PVPITEMww'

  IF (cHD)->nTypPoh = 1
    drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
    drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
    PVPITEMa->( AdsSetOrder( 'PVPITEM30'))  //21

    IF !lVN        //'PVPHEAD' $ cHD            //'PVPITEMww'
      IF( cIT = 'PVPITEMww', PVPITEM->( dbGoTO( PVPITEMww->_nRecOr)), nil )
      IF PVPITEM->( RecNo()) <> 0
        lOK := PrijemIT_isOK( cIT)
      endif
    ELSE    //IF cFile = 'PVPHEADw' .and. lVN
      nRec := (cIT)->( RecNO())
      (cIT)->( dbGoTOP())
      DO WHILE !(cIT)->( EOF())
        IF( cIT = 'PVPITEMww', PVPITEM->( dbGoTO( PVPITEMww->_nRecOr)), nil )
        IF PVPITEM->( RecNo()) <> 0
          lOK := IF( PrijemIT_isOK( cIT), lOK, .F. )
        ENDIF
        (cIT)->( dbSkip())
      ENDDO
      (cIT)->( dbGoTO( nRec))
    ENDIF
    PVPITEMa->( dbCloseArea())
    CENZBOZa->( dbCloseArea())
    *
    IF !lOK .and. lMessage
      drgMsgBOX( drgNLS:msg( IF( lVN, 'Vedlejší náklady ','Pøíjemku ') + ;
                            'nelze opravit nebo již existují pozdìjší výdejky na položku  ...' ))
    ENDIF
  ENDIF

RETURN lOK

/*-------------------------------------------------------------------------------
FUNCTION Prijem_isOK( cFile, lMessage, lVN)
  Local lOK := .T., nRec

  DEFAULT lMessage TO .T., lVN TO .F., cFile TO 'PVPITEMww'

  IF PVPHEADw->nTypPoh = 1
    drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
    drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
    PVPITEMa->( AdsSetOrder( 21))

    IF cFile = 'PVPITEMww'
      lOK := PrijemIT_isOK()
    ELSEIF cFile = 'PVPHEADw' .and. lVN
      nRec := PVPITEMww->( RecNO())
      PVPITEMww->( dbGoTOP())
      DO WHILE !PVPITEMww->( EOF())
        lOK := IF( PrijemIT_isOK(), lOK, .F. )
        PVPITEMww->( dbSkip())
      ENDDO
      PVPITEMww->( dbGoTO( nRec))
    ENDIF
    PVPITEMa->( dbCloseArea())
    CENZBOZa->( dbCloseArea())
    *
    IF !lOK .and. lMessage
      drgMsgBOX( drgNLS:msg( IF( lVN, 'Vedlejší náklady ','Pøíjemku ') + ;
                            'nelze opravit nebo již existují pozdìjší výdejky na položku  ...' ))
    ENDIF
  ENDIF

RETURN lOK
*/

* Kontrola, zda pøíjemku již nenásledovala výdejka
*-------------------------------------------------------------------------------
STATIC FUNCT PrijemIT_isOK( cIT)
  Local lOK := .T., lOpravaPri := SysConfig( 'Sklady:lOpravaPri')
  Local cKey := Upper( PVPITEM->cCisSklad) + Upper( PVPITEM->cSklPol)

  IF CENZBOZa->( dbSEEK( cKey,, 'CENIK03'))
    IF CenZBOZa->cTypSklCen = 'PRU'
      IF lOpravaPri
        PVPITEMa->( mh_SetScope( cKey + '-1'),;
                    dbGoBottom())
        lOK := IF( PVPITEMa->( Eof()), .T.,;
                   ( PVPITEM->( dDatPVP) > PVPITEMa->( dDatPVP)) .OR. ;
                    ( ( PVPITEM->( dDatPVP) = PVPITEMa->( dDatPVP)) .AND. ( VAL( StrTran( PVPITEM->( cCasPVP),':')) > VAL( StrTran(PVPITEMa->( cCasPVP), ':')) ))  )

*                   PVPITEM->( RecNO()) > PVPITEMa->( RecNO())  )
      ENDIF
    ENDIF
  ENDIF

RETURN lOK

*
* Promítnutí pøíjmu do ObjVysIT, ObjVysHD
*===============================================================================
FUNCTION SKL_ObjVyst_akt( nKEY)
  Local lOk, lLock
  Local nTagHD, nTagIT, nRecHD, nRecIt, cKey, nMnHLP

  IF ( nPos := ASCAN( { 110,111,117 }, PVPHEAD->nKARTA)) > 0
    *
    drgDBMS:open('OBJVYSHD')
    drgDBMS:open('OBJVYSIT')
    *
    IF nKEY != xbeK_INS   // cAlias == 'PVPITEM'
       nTagHD := ObjVysHD->( AdsSetOrder( 2))
       cKey   := StrZero( PVPHead->nCisFirmy, 5) + Upper( PVPItem->cCisOBJ)
       ObjVysHD->( dbSeek( cKey))
       nRecHD := ObjVysHD->( RecNo())

       nTagIT := ObjVysIt->( AdsSetOrder( 1))
       cKey   += StrZero( PVPItem->nIntCount, 5)
       lOK    := ObjVysIt->( dbSeek( cKey,, 'OBJVYSI1'))
       nRecIT := ObjVysIT->( RecNo())
    ENDIF
    IF ( lLock := ( ReplRec( 'ObjVysIT') .AND. ReplRec( 'ObjVysHD') ) )
      Do Case
        Case nKey == xbeK_ENTER
          ObjVysIT->dDatPrDOD  := PVPHead->dDatPVP
          ObjVysIT->nCenNapDOD := PVPITEMww->nCenNapDOD
          ObjVysIT->nMnozPrDOD := PVPITEMww->nMnozPrDOD
          ObjVysIT->nMnozPlDOD += PVPITEMww->nMnozPrDOD - PVPITEM->nMnozPrDOD
          ObjVysIt->nMnozPoDOD := MAX( PVPITEM->nMnozPoODB - PVPITEMww->nMnozPrDod, 0 )

          nMnHLP := ObjVysIT->nMnozPlDOD - ObjVysIT->nMnozObDOD
          nMnHLP := IF( nMnHLP > 0, PVPITEMww->nMnozPrDOD - nMnHLP,;
                                    PVPITEMww->nMnozPrDOD )
          ObjVysHD->nMnozPlDOD += nMnHLP - PVPITEM->nMnozVyObV

        Case nKey == xbeK_DEL
          ObjVysIt->nMnozPoDOD := PVPITEM->nMnozPoODB
          ObjVysIT->nMnozPlDOD -= PVPITEM->nMnozPrDOD

          ObjVysHD->nMnozPlDOD -= MAX( PVPITEM->nMnozVyObV - ObjVysIT->nMnozPlDOD, 0 )

        Case nKey == xbeK_INS
          ObjVysIT->dDatPrDOD  := PVPHead->dDatPVP
          ObjVysIT->nCenNapDOD := PVPITEMww->nCenNapDOD
          ObjVysIT->nMnozPrDOD += PVPITEMww->nMnozVyObj
          ObjVysIt->nMnozPoDOD -= PVPITEMww->nMnozPrDod    // PVPItem->nMnozVyObj
          ObjVysIt->nMnozPoDOD := MAX( ObjVysIt->nMnozPoDOD, 0 )
          ObjVysIT->nMnozPlDOD += PVPITEMww->nMnozPrDOD    //  PVPItem->nMnozVyObj

          ObjVysHD->nMnozPlDOD += PVPITEMww->nMnozVyObV   //  PVPItem->nMnozPrDOD

      EndCase
      ObjVysHD->cPokrObj := If( ObjVysHD->nMnozObDOD > ObjVysHD->nMnozPlDOD, 'C', 'V' )
      ObjVysIT->( dbUnlock())
      ObjVysHD->( dbUnlock())
    ENDIF
  EndIf
Return Nil

* Aktualizace položky Množství nedodáno
*===============================================================================
FUNCTION SKL_Firmy_akt( nKey)

  fOrdRec( { 'Firmy, 1' } )
  If Firmy->( dbSeek( PVPHead->nCisFirmy)) .and. ReplRec( 'Firmy')
    Do Case
      Case nKey == xbeK_INS
        Firmy->nMnozNeDod -= PVPITEMww->nMnozVyObj
      Case nKey == xbeK_ENTER
        Firmy->nMnozNeDod += PVPITEMww->nMnozVyObj - PVPITEM->nMnozVyObj
      Case nKey == xbeK_DEL
        Firmy->nMnozNeDod += PVPITEM->nMnozVyObj
    EndCase
    Firmy->nMnozNeDod := MAX( Firmy->nMnozNeDod, 0)
    Firmy->( dbUnlock())
  Endif
  fOrdRec()
Return( Nil)

* Modifikace Mn. k objednání a Mn. objednáno v ceníku
*===============================================================================
FUNCTION SKL_MnozKzbo_akt( nKey)
  Local cKeyC := Upper( PVPITEMww->cCisSklad) + Upper( PVPITEMww->cSklPol)

  FOrdRec( { 'CenZboz, 3' } )
  If !Empty( PVPITEMww->cCisObj)
    If CenZboz->( dbSeek( cKeyC)) .and. ReplRec( 'CenZboz')
      Do Case
        Case nKey == xbeK_INS
          CenZboz->nMnozoZBO -= PVPITEMww->nMnozPrDod
          CenZboz->nMnozKZBO -= PVPITEMww->nMnozKOBJE
          CenZboz->nMnozKZBO += PVPITEMww->nMnozZObje

        Case nKey == xbeK_ENTER
          CenZboz->nMnozoZBO += PVPITEM->nMnozPrDod - PVPITEMww->nMnozPrDod
          CenZboz->nMnozKZBO += PVPITEM->nMnozKOBJE - PVPITEMww->nMnozKOBJE
          CenZboz->nMnozKZBO += - PVPITEM->nMnozZOBJE + PVPITEMww->nMnozZObje

        Case nKey == xbeK_DEL
          CenZboz->nMnozoZBO += PVPITEM->nMnozVyOBJ + PVPITEM->nMnozZOBJE
          CenZboz->nMnozKZBO += PVPITEM->nMnozKOBJE
          CenZboz->nMnozKZBO -= PVPITEM->nMnozZOBJE
      EndCase
      CenZboz->nMnozoZBO := MAX( CenZboz->nMnozoZBO, 0)
      CenZboz->nMnozKZBO := MAX( CenZboz->nMnozKZBO, 0)
      CenZboz->( dbUnlock())
    EndIf
  Endif
  FOrdRec()
Return( Nil)

* Zrušení položky pøíjmového dokladu - KONTROLA
*===============================================================================
FUNCTION SKL_DelPolPrijem()
  Local cKey := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol)
  Local lOk  := .f.

  FOrdRec( { 'VyrCis, 2' } )
  If CenZboz->( dbSeek( cKey,, 3))
    lOk := ( PVPItem->nMnozPrDod <= CenZboz->nMnozsZbo)
    If !lOk
      drgMsgBox(drgNLS:msg( ;
        'NELZE ZRUŠIT !;;'+ ;
        'Množství na rušené pøíjemce pøesahuje množství skladové !'), XBPMB_CRITICAL )
    Endif
  Endif

  If lOk
    cKey += StrZero( PVPItem->nDoklad, 10)
    VYRCIS->( dbSetScope(SCOPE_BOTH, cKEY), dbGOTOP() )
    VyrCis->( dbEval( { || lOk := If( VyrCis->nDokladV <> 0, .f., lOk) } ))
    VYRCIS->( dbClearScope())
    If !lOk
      drgMsgBox(drgNLS:msg( ;
        'NELZE ZRUŠIT !;;'+ ;
        'Výrobní èísla z této položky pøíjemky již prošla výdejem !'), XBPMB_CRITICAL )
    EndIf
  Endif
  FOrdRec()

Return( lOk)

* Zrušení pøíjmového dokladu - KONTROLA
*===============================================================================
FUNCTION SKL_DelDokPrijem()
  Local lOk := .t., cKey
  Local nRecIt := PVPItem->( RecNo()), nRecZbo := CenZboz->( RecNo())

  PVPItem->( dbGoTop())
  Do While ! PVPItem->( Eof())
    cKey := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol )
    If CenZboz->( dbSeek( cKey,, 3))
      lOk := If( PVPItem->nMnozPrDod <= CenZboz->nMnozsZbo, lOk, .f. )
    Endif
    PVPItem->( dbSkip())
  EndDo
  PVPItem->( dbGoTo( nRecIt))
  CenZboz->( dbGoTo( nRecZbo))
  If !lOk
    drgMsgBox(drgNLS:msg( ;
      'NELZE ZRUŠIT !;;'+ ;
      'Množství na rušené pøíjemce pøesahuje množství skladové !'), XBPMB_CRITICAL )
  Endif

RETURN( lOk)

* Modifikace skl.ceny celkem v CenZboz pøi pøíjmu
*===============================================================================
FUNCTION SKL_ModiCen( nKey )
  Local cKey := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol )

*  FOrdRec( { 'CenZboz, 3' } )
  If CenZboz->( dbSeek( cKey,, 3)) .and. ReplRec( 'CenZboz' )
    If Upper( CenZboz->cPolCen) == 'C'
      Do Case
        Case nKey == xbeK_INS
          CenZboz->nCenacZBO += PVPItem->nCenaCelk
        Case nKey == xbeK_ENTER
          CenZboz->nCenacZBO += PVPItem->nCenaCelk - PVPItemW->nCenaCelk
        Case nKey == xbeK_DEL
          CenZboz->nCenacZBO -= PVPItem->nCenaCelk
      EndCase
      PVPItem->nCenacZBO := CenZboz->nCenacZBO
      CenZboz->nCenasZBO := SKL_SkladCena( CenZboz->cTypSklCen )
    EndIf
    CENZBOZ->( dbUnlock())
  EndIf
*  FOrdRec()
Return( Nil)
*/

/* Rozpoèet vedlejších nákladù na položky dokladu
*===============================================================================
FUNCTION SKL_NutneVN( oDlg, nKey, nRecPVP, axOrigPVP, lKontrolSuma )

  Local nOldRec := PVPItem->( RecNo())
  Local nCountItem := 0, n := 0
  Local nSuma := 0, nRest, nKoef, nNewSuma := 0, nCenaCELK, nItemVN
  Local nSumaZM := 0, nRestZM, nKoefZM, nCenaCELKZM, nItemVNZM
  Local axOrig
  LOCAL cTypPohyb := LEFT( STR( PVPHEAD->nKarta), 1 )     // LEFT( STR( oDlg:UDCP:nKarta), 1 )
  LOCAL cTypHead  := SUBSTR( STR( PVPHEAD->nKarta), 2, 1) // SUBSTR( STR( oDlg:UDCP:nKarta), 2, 1)
    *
  DEFAULT lKontrolSuma TO .T.
  DEFAULT nKey         TO xbeK_ENTER
  *
  IF cTypPohyb = PRIJEM .and. cTypHead <> '0' .and. cTypHead <> '4'
    IF PVPHead->nNutneVN <> 0 .or. PCount() == 1
      PVPItem->( dbGoTop())
      DO WHILE ! PVPItem->( Eof())
        SKL_UcetPol_DEL()
        IF ReplRec( 'PVPItem')
          PVPItem->cUctovano := ' '
          IF ( nKey == xbeK_DEL .and. PVPItem->( RecNo()) == nRecPVP )
          ELSE
            nSuma   += PVPItem->nMnozPrDOD * PVPItem->nCenNapDOD
            nSumaZM += PVPItem->nMnozDokl1 * PVPItem->nCenNaDoZM
          ENDIF
          nCountItem++
          PVPItem->( dbUnlock())
        ENDIF
        PVPItem->( dbSkip())
      ENDDO
      SKL_UcetPol_DEL( .t.)   // zruší zaúètování rozdílu pøi pøíjmu

      nSuma  := Round( nSuma, 2)
      nRest  := PVPHead->nNutneVN
      nKoef  := If( nSuma <> 0, PVPHead->nNutneVN / nSuma, 0 )
      *
      nSumaZM := Round( nSumaZM, 2)
      nRestZM := PVPHead->nNutneVNZM
      nKoefZM := If( nSumaZM <> 0, PVPHead->nNutneVNZM / nSumaZM, 0 )
      *
      PVPItem->( dbGoTop())
      DO WHILE ! PVPItem->( Eof())
        IF ReplRec( 'PVPItem')
          n++
          PVPITEMw->( dbZAP())
          mh_COPYFLD('PVPITEM', 'PVPITEMw', .T.)
          nCenaCELK := PVPItem->nMnozPrDOD * PVPItem->nCenNapDOD
          nItemVN   := If( n = nCountItem, nRest, ROUND( ( nCenaCELK * nKoef ), 2 ) )
          PVPItem->nCenaCelk  := nCenaCELK + nItemVN
          PVPItem->nRozdilPoh := nItemVN
          PVPItem->nCenapDZBO := PVPItem->nCenaPZBO * ( 1 + ( SeekKodDph( PVPItem->nKlicDph) / 100))

          nRest := nRest - Round( (( PVPItem->nMnozPrDOD * PVPItem->nCenNapDOD) * nKoef ), 2 )
          IF  PVPItem->( RecNo()) == nRecPVP ;  SKL_ModiCen( nKey )
          ELSE                               ;  SKL_ModiCen( xbeK_ENTER )
          ENDIF
          *
          * Pøíjem v zahr.mìnì - 29.10.2008
          IF PVPHead->nKarta = 117
            nCenaCELKZM := PVPItem->nMnozDokl1 * PVPItem->nCenNaDoZM
            nItemVNZM   := If( n = nCountItem, nRestZM, ROUND( ( nCenaCELKZM * nKoefZM ), 2 ) )
            PVPItem->nCenCelkZM  := nCenaCELKZM + nItemVNZM
            nRestZM := nRestZM - Round( (( PVPItem->nMnozDokl1 * PVPItem->nCenNaDoZM) * nKoefZM ), 2 )
          ENDIF
          *
          nNewSuma += PVPItem->nCenaCelk
          PVPItem->( dbUnlock())
        ENDIF
        PVPItem->( dbSkip())
      ENDDO
    ELSE
      IF ReplRec( 'PVPItem')
*        axOrig := axOrigPVP
**        PVPITEMw->( dbZAP())
**        mh_COPYFLD('PVPITEM', 'PVPITEMw', .T.)
        SKL_UcetPol_DEL()
        PVPItem->cUctovano := ' '
        PVPItem->nCenaCelk := Round( PVPItem->nMnozPrDOD * PVPItem->nCenNapDOD, 2 )
        PVPItem->nCenapDZBO := PVPItem->nCenaPZBO * ( 1 + ( SeekKodDph( PVPItem->nKlicDph) / 100))
        SKL_ModiCen( nKey )
        PVPItem->( dbUnlock())
      ENDIF
    ENDIF
    IF ( lKontrolSuma, KontrolSuma( .t., xbeK_CTRL_S ), Nil )
    PVPItem->( dbGoTo( nOldRec))
  ENDIF

RETURN( nNewSuma)
*/

*
*===============================================================================
FUNCTION SKL_ChangeVN( dm)
  Local lChange := .F., nPos, aKarty := { 110,117,120,130}

  IF ( nPos := ASCAN( aKarty, PVPHEAD->nKarta)) > 0
    lChange := ( PVPHead->nNutneVN <> dm:get( 'PVPHead->nNutneVN') )
  ENDIF

RETURN lChange

*
*===============================================================================
FUNCTION SKL_VyrZAK_MODI( nKEY)
  Local lModiZAK

  IF PVPHead->nKarta == 102 .OR. PVPHead->nKarta == 103 .OR. PVPHead->nKARTA == 104
    drgDBMS:open('VYRZAK')
    drgDBMS:open('VYRPOL')
    lModiZAK := SKL_VyrZAK_TST( , YES )
    IF VyrZAK->( dbSEEK( Upper( PVPItem->cCisZAKAZ),, 1 ))
      IF VyrPOL->( dbSEEK( Upper( VyrZAK->cVyrPOL ),, 4))
        IF lModiZAK
          IF ReplREC( 'VyrZAK')
            DO CASE
            CASE nKEY == xbeK_INS
              VyrZAK->nMnozODVED += PVPItem->nMnozPrDod
            CASE nKEY == xbeK_ENTER
              VyrZAK->nMnozODVED += ( -PVPItemW->nMnozPrDOD + PVPItem->nMnozPrDod )
            ENDCASE
            VyrZAK->( dbUnlock())
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF
RETURN NIL

*
*===============================================================================
*FUNCTION SKL_VyrZAK_TST( cALIAS, cCisZakaz, lGetModiZAK)
*FUNCTION SKL_VyrZAK_TST( cSklPOL, cCisZakaz, lGetModiZAK)
FUNCTION SKL_VyrZAK_TST( dm, lGetModiZAK)
  Local lOK := NO, lModiZakHLP, lVyroba := .T. // SysConfig( 'Sklady:lVyroba')

  Local cQuestion := 'Výrobek nemá pøiøazenou skladovou kartu !;' + ;
                     'Pokud jde o koneèný výrobek zakázky,;' + ;
                     'pøiøaïte nejprve v TPV skladovou kartu výrobku, jinak ;' + ;
                     'se nepropojí odvedení na sklad se zakázkou v ;' + ;
                     'plánování výroby a zakázka zùstane nesplnìna. ;;' + ;
                     'Chcete opravdu provést pøíjem ?'
  STATIC lModiZAK

  DEFAULT lModiZAK TO YES, lGetModiZAK TO NO

  IF lGetModiZAK
    lModiZakHLP := lModiZAK
    lModiZAK := YES
    RETURN lModiZakHLP
  ENDIF

  IF PVPHead->nKarta = 102 .OR. PVPHead->nKarta = 103 .OR. PVPHead->nKARTA = 104
    drgDBMS:open('VYRZAK')
    drgDBMS:open('VYRPOL')
    IF VyrZAK->( dbSEEK( Upper( dm:get( 'PVPITEM->cNazPOL3')),, 1 ))
      IF VyrPOL->( dbSEEK( Upper( VyrZAK->cVyrPOL ),,4))
         lOK := ( VyrPOL->cSklPol = dm:get( 'PVPITEM->cSklPOL') )
      ENDIF
    ENDIF
*  ENDIF
    IF !lOK
      IF lVyroba
        IF drgIsYESNO(drgNLS:msg( cQuestion ))
           lOK := YES
           lModiZAK := NO
        ENDIF
      ELSE
        lOK := YES
      ENDIF
    ENDIF
  ENDIF
RETURN lOK

* Zrušení pøíjmového pohybu z výrobní produkce
*==============================================================================
FUNCTION SKL_DelVyrPROD()
  Local nAREA := SELECT()
  Local cKEY := StrZERO( PVPItem->nDoklad, 10) + StrZERO( PVPItem->nOrdItem, 5)
  Local nMnPrijato := 0

  IF PVPHead->nKARTA == 103 .OR. PVPHead->nKARTA == 104     // Výrobní produkce
  *  OpenFILES( { 'ObjZAK', 'ObjITEM', 'PVPZak', 'CenZBOZ', 'VYRZAK' } )
  *  FOrdREC( { 'ObjZAK, 2', 'ObjITEM, 3', 'PVPZak, 1', 'CenZBOZ, 3', 'VYRZAK, 1' } )

    drgDBMS:open('OBJZAK'  )
    drgDBMS:open('OBJITEM' )
    drgDBMS:open('PVPZAK'  )
    drgDBMS:open('CENZBOZ' )
    drgDBMS:open('VYRZAK'  )
    *
    PVPZak->( dbSetScope(SCOPE_BOTH, cKEY), dbGOTOP() )
    cKEY := Upper( PVPItem->cCisSKLAD) + Upper( PVPItem->cSklPOL)
    CenZBOZ->( dbSEEK( cKEY,, 3 ))

    DO WHILE !PVPZak->( EOF())
       * Aktualizace ObjITEM
       cKEY := Upper( PVPZak->cCislObInt) + StrZERO( PVPZak->nCislPolOb, 5)
       IF ObjITEM->( dbSEEK( cKEY,, 3))
          IF REPLREC( 'ObjITEM')
             ObjITEM->nMnozReODB -= PVPZak->nMnPRIJATO
             ObjITEM->( dbUnlock())
          ENDIF
       ENDIF
       * Aktualizace ObjZAK
       cKEY := Upper( PVPZak->cCisZAKAZ) + Upper( PVPZak->cCislObInt) + ;
               StrZERO( PVPZak->nCislPolOb, 5)
       IF ObjZAK->( dbSEEK( cKEY,, 2))
          IF ReplREC( 'ObjZAK')
            ObjZAK->nMnozDodVy -= PVPZak->nMnPRIJATO
            ObjZAK->( dbUnlock())
          ENDIF
       ENDIF
       * Aktualizace PVPZak
       nMnPrijato += PVPZak->nMnPrijato
       DelREC( 'PVPZak')
       PVPZak->( dbSKIP())
    ENDDO
    * Aktualizace CENZBOZ
    IF ReplREC( 'CenZBOZ')
      CenZBOZ->nMnozRZBO -= nMnPrijato
      IF PVPItem->nMnozPrDOD > nMnPRIJATO   //  ???
         CenZBOZ->nMnozDZBO += nMnPRIJATO
      ENDIF
      CenZBOZ->( dbUnlock())
      SKL_PrepocetCEN()         // 3.6.2003
    ENDIF

    PVPZAK->( dbClearSCOPE())
    FOrdREC()
  ENDIF

  IF PVPHead->nKARTA == 103 .OR. PVPHead->nKARTA == 102 .OR. PVPHead->nKARTA == 104   // Výrobní produkce + PRODUKCE
    drgDBMS:open('VYRZAK'  )
    drgDBMS:open('VYRPOL'  )
    * Aktualizace VYRZAK
    IF VyrZAK->( dbSEEK( Upper( PVPItem->cCisZAKAZ),, 1 ))
      IF VyrPOL->( dbSEEK( Upper( VyrZAK->cVyrPOL ),, 4))
        IF ReplREC( 'VyrZAK')
          VyrZAK->nMnozODVED -= PVPItem->nMnozPrDOD
          VyrZAK->( dbUnlock())
        ENDIF
      ENDIF
    ENDIF
  ENDIF
  dbSelectAREA( nAREA)

RETURN NIL

* Kontrolní pøepoèet množství v CenZboz
*===============================================================================
FUNCTION SKL_PrepocetCEN()
*===============================================================================
  Local nREC, cTAG
  Local cKEY := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
  Local nMnozRZBO := 0, nMnozKZBO := 0, nMnozDZBO := 0, nMnozRVYR := 0
  Local lRozdil

  nREC := ObjItem->( RECNO())
  cTAG := ObjITEM->( AdsSetOrder( 4))

  ObjITEM->( mh_SetScope( cKEY) )
  ObjItem->( dbEVAL( {||  nMnozRZBO += ObjItem->nMnozReODB ,;
                          nMnozKZBO += ObjItem->nMnozKoDOD   } ))

  nMnozRZBO := MH_RoundNumb( IF( nMnozRZBO < 0, 0, nMnozRZBO ), 32)
  nMnozKZBO := MH_RoundNumb( IF( nMnozKZBO < 0, 0, nMnozKZBO ), 32)
  nMnozDZBO := CenZboz->nMnozSZBO - nMnozRZBO
  nMnozDZBO := MH_RoundNumb( IF( nMnozDZBO < 0, 0, nMnozDZBO ), 32)
  nMnozRVYR := nMnozRZBO
  ObjItem->( mh_ClrScope())
  lRozdil := nMnozRZBO <> CenZboz->nMnozRZBO .or. ;
             nMnozKZBO <> CenZboz->nMnozKZBO .or. ;
             nMnozDZBO <> CenZboz->nMnozDZBO
  //- aktualizuje Cenik
  IF lRozdil
    IF REPLREC( 'CENZBOZ')
      CenZboz->nMnozRZBO  := nMnozRZBO   // Mn. rezervováno
      CenZboz->nMnozKZBO  := nMnozKZBO   // Mn. k objednání
      CenZboz->nMnozDZBO  := nMnozDZBO   // Mn. k dispozici
      CenZboz->nMnozRSES  := nMnozRVYR   // Mn. rezervováno pro výrobu
      CENZBOZ->( dbUnlock())
    ENDIF
  ENDIF
  ObjITEM->( dbclearScope(), AdsSetOrder( cTAG), dbGoTO( nREC))
RETURN NIL
