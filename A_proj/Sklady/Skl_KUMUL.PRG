
********************************************************************************
* SKL_KUMUL.PRG     ... DOS : KUMUL.PRG
*
*
********************************************************************************

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"

#include "..\SKLADY\SKL_Sklady.ch"

* Modifikace kumulaèního pohybového souboru
*-------------------------------------------------------------------------------
FUNCTION SKL_PVPKumul_Modi( nKey, cTypPohyb )
/*  BLOKACE - vyøešíme jinak - 22.1.2007
  Local  cKey, cTag, cObd, lExist

  IF( Used('PVPKUMUL'), NIL, drgDBMS:open('PVPKUMUL'))
  cTag := PVPKumul->( AdsSetOrder( 1))

Begin Sequence
  If cTypPohyb == Nil     // Pøi založení nové skladové karty

    cObd := StoreObd()
    PVPKumul_Add( cObd)
    DalsiObd( cObd)

  Else                            // Pøi pohybu skl. karty
    cObd := If( nKey == xbeK_INS, StoreObd(), PVPItem->cObdPoh )
    cKey := Upper( cObd) + Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol)

    lExist := PVPKumul->( dbSeek( cKey))
    If !lExist
      // Jde o situaci poèáteèního najetí na práci s PVPKumul
      PVPKumul_Add( cObd)
    EndIf
    If ReplRec( 'PVPKumul')
      Do Case
        Case cTypPohyb == PRIJEM    // Pøíjem
          Do Case
            Case nKey == xbeK_INS
              PVPKumul->nMnozKon  += PVPItem->nMnozPrDod
              PVPKumul->nCenaKon  += PVPItem->nCenaCelk
              PVPKumul->nMnozPrij += PVPItem->nMnozPrDod
              PVPKumul->nCenaPrij += PVPItem->nCenaCelk
              PVPKumul->dDatPVP   := PVPItem->dDatPVP

            Case nKey == xbeK_ENTER
              PVPKumul->nMnozKon  += - PVPItemW->nMnozPrDod + PVPItem->nMnozPrDod
              PVPKumul->nCenaKon  += - PVPItemW->nCenaCelk + PVPItem->nCenaCelk
              PVPKumul->nMnozPrij += - PVPItemW->nMnozPrDod + PVPItem->nMnozPrDod
              PVPKumul->nCenaPrij += - PVPItemW->nCenaCelk + PVPItem->nCenaCelk
              PVPKumul->dDatPVP   := PVPItem->dDatPVP

            Case nKey == xbeK_DEL
              PVPKumul->nMnozKon  -= PVPItemW->nMnozPrDod
              PVPKumul->nCenaKon  -= PVPItemW->nCenaCelk
              PVPKumul->nMnozPrij -= PVPItemW->nMnozPrDod
              PVPKumul->nCenaPrij -= PVPItemW->nCenaCelk
            EndCase

        Case cTypPohyb == VYDEJ    // Výdej
          Do Case
            Case nKey == xbeK_INS
              PVPKumul->nMnozKon   -= PVPItem->nMnozPrDod
              PVPKumul->nCenaKon   -= PVPItem->nCenaCelk
              PVPKumul->nMnozVydej += PVPItem->nMnozPrDod
              PVPKumul->nCenaVydej += PVPItem->nCenaCelk
              PVPKumul->dDatPVP    := PVPItem->dDatPVP

            Case nKey == xbeK_ENTER
              PVPKumul->nMnozKon   +=  PVPItemW->nMnozPrDod - PVPItem->nMnozPrDod
              PVPKumul->nCenaKon   +=  PVPItemW->nCenaCelk - PVPItem->nCenaCelk
              PVPKumul->nMnozVydej += - PVPItemW->nMnozPrDod + PVPItem->nMnozPrDod
              PVPKumul->nCenaVydej += - PVPItemW->nCenaCelk + PVPItem->nCenaCelk
              PVPKumul->dDatPVP    := PVPItem->dDatPVP

            Case nKey == xbeK_DEL
              PVPKumul->nMnozKon   += PVPItemW->nMnozPrDod
              PVPKumul->nCenaKon   += PVPItemW->nCenaCelk
              PVPKumul->nMnozVydej -= PVPItemW->nMnozPrDod
              PVPKumul->nCenaVydej -= PVPItemW->nCenaCelk
          EndCase
      EndCase

      PVPKumul->cDatPosAkt := DTOS( Date())
      PVPKUMUL->( dbUnlock())
      // Pøípadný pøepoèet kumulativního souboru
      ReKumul( PVPKumul->( RecNo()) )

    EndIf
  Endif
End Sequence
PVPKumul->( AdsSetOrder( cTag))
*/
Return( Nil)


* Pøepoèet kumulativního souboru
*-------------------------------------------------------------------------------
FUNCTION ReKumul( nRecNo )
  Local cTag := PVPKumul->( AdsSetOrder( 2)), cKey
  Local nMnozKon, nCenaKon, nObd

  PVPKumul->( dbGoTo( nRecNo))
  cKey := Upper( PVPKumul->cCisSklad) + Upper( PVPKumul->cSklPol)
  PVPKUMUL->( Ads_SetScope(SCOPE_TOP   , cKey),;
              Ads_SetScope(SCOPE_BOTTOM, cKey),  DbGoTo( nRecNO) )

  nMnozKon := PVPKumul->nMnozKon
  nCenaKon := PVPKumul->nCenaKon
  PVPKumul->( dbSkip())

  Do While ! PVPKumul->( Eof())
    If ReplRec( 'PVPKumul')
      PVPKumul->nMnozPoc := nMnozKon
      PVPKumul->nCenaPoc := nCenaKon
      PVPKumul->nMnozKon := PVPKumul->nMnozPoc + ;
                            PVPKumul->nMnozPrij - PVPKumul->nMnozVydej
      PVPKumul->nCenaKon := PVPKumul->nCenaPoc + ;
                            PVPKumul->nCenaPrij - PVPKumul->nCenaVydej
      nMnozKon := PVPKumul->nMnozKon
      nCenaKon := PVPKumul->nCenaKon
      PVPKumul->cDatPosAkt := DTOS( Date())
      // Oprava roèních poèáteèních hodnot, v pøipadì pøepoètu 1. období
      nObd := Val( Left( PVPKumul->cObdPoh, 2))
      If( nObd == 1, ReWriteCen(), Nil )
      PVPKUMUL->( dbUnlock())
    EndIf
    PVPKumul->( dbSkip())
  EndDo

  PVPKUMUL->( Ads_ClearScope( SCOPE_TOP   ),;
              Ads_ClearScope( SCOPE_BOTTOM),;
              AdsSetOrder( cTag), dbGoTo( nRecNo) )
Return( Nil)

* Oprava roèních poèáteèních hodnot, v pøipadì pøepoètu 1. období
*-------------------------------------------------------------------------------
STATIC FUNCT ReWriteCen()
  Local nRec := CenZboz->( RecNo())
  Local cTag := CenZboz->( AdsSetOrder( 3))
  Local cKey := Upper( PVPKumul->cCisSklad) + Upper( PVPKumul->cSklPol)

  drgDBMS:open('CenZB_PS')
  IF CenZboz->( dbSeek( cKey))
    IF ReplRec( 'CenZboz')
      CenZboz->nCenaPoc := PVPKumul->nCenaPoc
      CenZboz->nMnozPoc := PVPKumul->nMnozPoc
      PocSTAVY( PVPKumul->nROK )
      CENZBOZ->( dbUnlock())
    ENDIF
  ENDIF
  CenZboz->( AdsSetOrder( cTag), dbGoTo( nRec) )
RETURN Nil

*
*===============================================================================
FUNCTION DalsiObd( cObd)
  Local nAktObd := Val( GETcRok4( cObd) + Left( cObd, 2)), nObd
  Local nRec, cTag

  drgDBMS:open('UcetSYS')
  nRec := UcetSys->( RecNo())
  cTag := UcetSys->( AdsSetOrder( 0))
  UcetSys->( dbGoTop())
  Do While ! UcetSys->( Eof())
    nObd := Val( StrZero( UcetSys->nRok) + StrZero( UcetSys->nObdobi))
    If UcetSys->cUloha == 'S' .AND. nObd > nAktObd
      PVPKumul_Add( UcetSys->cObdobi)
    Endif
    UcetSys->( dbSkip())
  EndDo
  UcetSys->( AdsSetOrder( cTag), dbGoTo( nRec) )
RETURN Nil

*
*-------------------------------------------------------------------------------
FUNCTION PVPKumul_Add( cObd)

  If AddRec( 'PVPKumul')
    PVPKumul->cCisSklad  := CenZboz->cCisSklad
    PVPKumul->cSklPol    := CenZboz->cSklPol
    PVPKumul->cPolCen    := CenZboz->cPolCen
    PVPKumul->nUcetSkup  := CenZboz->nUcetSkup
    PVPKumul->nZboziKat  := CenZboz->nZboziKat
    PVPKumul->cObdPoh    := cObd
    PVPKumul->dDatPVP    := CenZboz->dDatpZBO

    PVPKumul->nMnozPoc   := CenZboz->nMnozPoc
    PVPKumul->nCenaPoc   := CenZboz->nCenaPoc
    PVPKumul->nMnozKon   := CenZboz->nMnozPoc
    PVPKumul->nCenaKon   := CenZboz->nCenaPoc
    PVPKumul->nPoradi    := Val( Right( cObd, 2) + Left( cObd, 2) )
    PVPKumul->nRok       := VAL( GETcRok4( cObd))
    PVPKumul->nObdobi    := VAL( LEFT( cObd, 2))
    PVPKumul->cDatPosAkt := DTOS( Date())
    PVPKUMUL->( dbUnlock())
  Endif
RETURN Nil

/*
* Vytvoøení kumulaèních záznamù pro nové období
*-------------------------------------------------------------------------------
FUNCTION PVPKumul_New( cObdobi )
  Local nCount := 1, nRecCount := 0, nCountKum
  Local cRok4 := GETcRok4( cObdobi)
  Local nRok := Val( cRok4)
  Local nObd := Val( Left( cObdobi, 2))
  Local cTag, cKey, cTagCen
  Local nPoradi := Val( Right( cObdobi, 2) + Left( cObdobi, 2) )
  Local anKonObd
  Local lFirst, lLockCen, lLockKum, lLocked

  OpenFiles( { 'PVPKumul', 'CenZboz', 'CenZb_PS' } )
  If nObd == 1   // roèní uzávìrka
    ( lLockCen := CenZboz->( FLock()), lLockKum := PVPKumul->( FLock()) )
    lLocked  := ( lLockCen .and. lLockKum )
  Else
    lLocked := PVPKumul->( FLock())
  Endif

  If lLocked
    Box_Make( '< Okam§ik pros¡m ... >',;
              'Prob¡h  pý¡prava pro zalo§en¡ kumul.souboru pro dalç¡ obdob¡ ...',;
              'w+/g, gr+/n*')
    CenZboz->( dbEval( { || nRecCount++ } ))
    cTag      := PVPKumul->( AdsSetOrder( 2))
    cTagCen   := CenZboz->( AdsSetOrder(0))
    nCountKum := PVPKumul->( LastRec())
    lFirst    := ( nCountKum == 0 )
    Box_Make()

    CenZboz->( dbGoTop())
    Box_Thermo( 1, nCount, nRecCount, ;
                                       '< Aktualizace kumulativn¡ho souboru >' , ;
                                            'Zakl d m poŸ teŸn¡ stavy cen¡ku pro kumulativn¡ soubor...' )
    CenZb_PS->( AdsSetOrder( 1))

    Do While !CenZboz->( Eof())
      If nObd == 1  // roèní uzávìrka
      //                        If ReplRec( 'CenZboz')
        CenZboz->nMnozPoc := CenZboz->nMnozsZbo
        CenZboz->nCenaPoc := CenZboz->nCenacZbo
        PocSTAVY( nROK)
//                                DCrUnlock( 'CenZboz')
//                        Endif
      Endif

      If lFirst
        anKonObd := { CenZboz->nMnozsZBO, CenZboz->nCenacZBO }
      Else
        cKey := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
        PVPKumul->( dbSeek( cKey + StrZero( nRok) + StrZero( nObd), .T. ))
        PVPKumul->( dbSkip( -1))
        anKonObd := { PVPKumul->nMnozKon, PVPKumul->nCenaKon }
      EndIf

//          If AddRec( 'PVPKumul')
      PVPKumul->( dbAppend())
      PVPKumul->cCisSklad  := CenZboz->cCisSklad
      PVPKumul->cSklPol    := CenZboz->cSklPol
      PVPKumul->cPolCen    := CenZboz->cPolCen
      PVPKumul->nUcetSkup  := CenZboz->nUcetSkup
      PVPKumul->nZboziKat  := CenZboz->nZboziKat
      PVPKumul->cObdPoh    := cObdobi
      PVPKumul->dDatPVP    := CenZboz->dDatpZBO
      PVPKumul->nMnozPoc   := anKonObd[ 1]
      PVPKumul->nCenaPoc   := anKonObd[ 2]
      PVPKumul->nMnozKon   := anKonObd[ 1]
      PVPKumul->nCenaKon   := anKonObd[ 2]
      PVPKumul->nPoradi    := nPoradi
      PVPKumul->nRok       := nRok
      PVPKumul->nObdobi    := nObd
      PVPKumul->cDatPosAkt := DTOS( Date())
//                   DCrUnlock( 'PVPKumul')
//                Endif
      Box_Thermo( 0, nCount, nRecCount)
     ( CenZboz->( dbSkip()),        nCount++ )
    EndDo
    Box_Thermo( -1)
    PVPKumul->( AdsSetOrder( cTag))
    CenZboz->( AdsSetOrder( cTagCen))
     PVPKumul->( dbUnlock())
    If( nObd == 1, CenZboz->( dbUnlock()), Nil )
  Else
    If nObd == 1
      If( lLockCen, CenZboz->( dbUnlock()) , Nil )
      If( lLockKum, PVPKumul->( dbUnlock()), Nil )
      Box_Alert( cEM, { 'RoŸn¡ uz vØrka neprobØhla, neboœ se nepodaýilo',;
                        '£spØçnØ uzamknout soubory : - cen¡k zbo§¡     ',;
                                                                                         '                            - kumulativn¡ soubor. ' },;
                                                                                         acWAIT  )
    Else
    Endif
  EndIf
RETURN Nil
*/

* Aktualizace souboru poèáteèních stavù
*-------------------------------------------------------------------------------
STATIC FUNC PocSTAVY( nROK)
  Local lOK
  Local cKEY := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPOL) +;
                StrZERO( nROK, 4)
  lOK := CenZB_PS->( dbSEEK( cKEY))
  IF ( lOK := IF( lOK, ReplREC( 'CenZB_PS'), AddREC( 'CenZB_PS') ) )
    mh_COPYFLD( 'CENZBOZ', 'CENZB_PS' )
    CenZB_PS->nROK  := nROK
    CenZB_PS->( dbUnlock())
  ENDIF
RETURN NIL

/*
*-------------------------------------------------------------------------------
FUNCTION SetFlag()
  Local  nOldError := DosError( 1135)
  Local  lOK, lLock
  Local  cMsgHead := '< Kumulativn¡ soubor  u z a m Ÿ e n >'
  Local  aMsgText := { 'Bylo zalo§eno nov‚ obdob¡ a prob¡h  aktualizace',;
                       'kumulativn¡ho souboru.                         ',;
                       'Pohyby lze dØlat a§ po ukonŸen¡ t‚to Ÿinnosti !' }

  If PVPKumul->( FLock());  ( lLock := .F., PVPKumul->( dbUnlock()) )
  Else                   ;    lLock := .T.
  EndIf
  If lLock ; ( lOK := .F., Box_Alert( cMsgHead, aMsgText, acWAIT, 'R/W*, GR+/R' ) )
  Else     ;         lOK := .T.
  Endif
  DosError( nOldError)

Return( lOK )
*/


/*
* Naplnìní položek nROK, nOBDOBI
*-------------------------------------------------------------------------------
FUNCTION FillRokObd()
  Local cTag := PVPKumul->( AdsSetOrder( 0)), nRec := PVPKumul->( RecNo())
  Local cRok4

  IF Box_ALERT( cQM, 'Prov‚st naplnØn¡ polo§ek nROK, nOBDOBI  ?', acNOYES ) == 2
    PVPKumul->( dbGoTop())
    Box_WORK( 1)
    DO WHILE !PVPKumul->( EOF())
      IF ReplREC( 'PVPKumul')
        cRok4 := GETcRok4( PVPKumul->cObdPoh)
        PVPKumul->nROK    := VAL( cRok4)
        PVPKumul->nObdobi := VAL( LEFT( PVPKumul->cObdPOH, 2))
        PVPKUMUL->( dbUnlock())
      ENDIF
      PVPKumul->( dbSKIP())
    ENDDO
    Box_WORK()
  ENDIF
  PVPKumul->( dbGoTo( nRec), AdsSetOrder( cTag) )
RETURN Nil
*/

STATIC FUNCTION GETcRok4( cObdobi)
  Local cRok2 := RIGHT( cObdobi, 2)
  Local cRok4 := IIF( cRok2 == '  ', '    ',;
                 IIF( VAL( cRok2) > 30, '19' + cRok2, '20' + cRok2 ))
RETURN( cRok4)
