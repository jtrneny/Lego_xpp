********************************************************************************
*  SKL_CtrlPocSTAVY
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
* Kontrolní pøepoèet poèáteèních stavù v CenZb_PS a CenZboz
********************************************************************************
CLASS SKL_CtrlPocSTAVY FROM drgUsrClass

EXPORTED:
  VAR     nROK_cmp     // rok, pro který mají být pøepoèteny poè. stavy
  VAR     nROK_min     // pøedchozí rok ( nROK_cmp - 1)

  METHOD  Init, drgDialogStart, ItemMarked, eventHandled
  METHOD  PREPOCET_PocStavu, OPRAVA_PocStavu, Replace_PS, DELETE_Err
  METHOD  ROK_cmp

ENDCLASS

********************************************************************************
METHOD SKL_CtrlPocSTAVY:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('CENZB_PS' )
  *
  ::nROK_cmp  := uctObdobi:SKL:nROK
RETURN self

********************************************************************************
METHOD SKL_CtrlPocSTAVY:drgDialogStart(drgDialog)

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  IsEditGET( {'M->nROK_cmp'}, ::drgDialog, .F.)
  *
  ErrPocStav->( DbSetRelation( 'CenZboz'  , {|| Upper(ErrPocStav->cCisSklad) + Upper(ErrPocStav->cSklPol)   } ,;
                                                'Upper(ErrPocStav->cCisSklad) + Upper(ErrPocStav->cSklPol)'   ,;
                                                'CENIK12'    ))
  ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()

RETURN SELF

********************************************************************************
METHOD SKL_CtrlPocSTAVY:ItemMarked()
  if ::nROK_cmp <> uctObdobi:SKL:nROK
    ::nROK_cmp  := uctObdobi:SKL:nROK
    ::drgDialog:dataManager:refresh()
  endif
RETURN SELF

********************************************************************************
METHOD SKL_CtrlPocSTAVY:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    CASE nEvent = drgEVENT_DELETE
      ::DELETE_Err()
      RETURN .T.
      *
    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
        CASE mp1 = xbeK_CTRL_A
          ::drgDialog:dialogCtrl:oaBrowse:is_SelAllRec := !::drgDialog:dialogCtrl:oaBrowse:is_SelAllRec
          ::drgDialog:dialogCtrl:oaBrowse:refresh()
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

********************************************************************************
METHOD SKL_CtrlPocSTAVY:ROK_cmp( oVAR )

  IF oVAR:NAME = 'M->nRok_cmp'
    IF oVAR:value > uctObdobi:SKL:nROK
      drgMsgBOX( drgNLS:msg( 'Chybnì zadaný rok ...'))
      RETURN .F.
    ELSE
      ::nRok_cmp := oVAR:value
    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD SKL_CtrlPocSTAVY:PREPOCET_PocStavu()
  Local nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0
  Local nCeKonCMP, nMnKonCMP, nCenaPoc, nMnozPoc, nRec
  Local nMnRozPS, nCeRozPS, nMnRozCEN, nCeRozCEN , lOK, lErr := NO
  Local cTagCen, cTagPVP, cScope, cKey, cRokPVP, cScoROK_min, cScoROK_cmp, cKarta
  Local nRecCen, nRecPVP
  Local nRokPVP, lAppend
  *
  if ::nROK_cmp <> uctObdobi:SKL:nROK
    ::nROK_cmp  := uctObdobi:SKL:nROK
    ::drgDialog:dataManager:refresh()
  endif
  ::nROK_min  := ::nROK_cmp - 1
  *
  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést pøepoèet souboru poèáteèních stavù pro rok  [ & ] ?', ::nRok_cmp) )
    *
    drgDBMS:open('CenZb_PS',,,,,'CenZb_PSa' )
    drgDBMS:open('CENZBOZ' ,,,,,'CENZBOZa'  )
    *
    ( nRecCen := CenZb_PS->( RecNo()), cTagCen := CenZb_PS->( AdsSetOrder( 1)) )
    ( nRecPVP := PVPItem->( RecNo()) , cTagPVP := PVPItem->( AdsSetOrder( 16)) )
    CENZB_PS->( dbGoTop())

    drgServiceThread:progressStart(drgNLS:msg('Výpoèet poèáteèních stavù ...', 'CENZB_PS'), CenZb_PS->(LASTREC()) )

    cScoROK_min := StrZero( ::nROK_min, 4)
    cScoROK_cmp := StrZero( ::nROK_cmp, 4)
    CenZb_PS->( AdsSetOrder( 2), mh_SetScope( cScoROK_cmp))

    Do While !CenZb_PS->( Eof())
      cKey := Upper( CenZb_PS->cCisSklad) + Upper( CenZb_PS->cSklPol)
      CenZboz->( dbSEEK( cKey,,'CENIK03'))
      * Pouze ceníkové položky
      If Upper(CenZboz->cPolCen) == 'C'
        * Propoèet nad pohybovým souborem PVPItem
        nRec := PVPItem->( RecNo())
        PVPITEM->(mh_SetScope( cKey + cScoROK_Min ))
        ( nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0 )
        *
        PVPItem->( dbEval( { || ;
           cKarta := Right( alltrim( PVPITEM->cTypDoklad), 3)  ,;
           If( ::nROK_min == PVPITEM->nRok .AND. cKarta <> '400' ,;
               ( nMnPrCMP += If( PVPItem->nTypPoh ==  1, PVPItem->nMnozPrDod, 0 ),;
                 nMnVyCMP += If( PVPItem->nTypPoh == -1, PVPItem->nMnozPrDod, 0 )), Nil ),;
           If( ::nROK_min == PVPITEM->nRok ,;
               ( nCePrCMP += If( PVPItem->nTypPoh ==  1, PVPItem->nCenaCelk , 0 ),;
                 nCeVyCMP += If( PVPItem->nTypPoh == -1, PVPItem->nCenaCelk , 0 )), Nil )  } ))
        *
        IF CENZB_PSa->( dbSeek( cKey + StrZero( ::nRok_min, 4),,'CENPS01'))
          nCenaPoc  := CenZb_PSa->nCenaPoc
          nMnozPoc  := CenZb_PSa->nMnozPoc
        ELSE
          nCenaPoc  := 0
          nMnozPoc  := 0
        ENDIF
        nCeKonCMP := nCenaPoc + nCePrCMP - nCeVyCMP
        nMnKonCMP := nMnozPoc + nMnPrCMP - nMnVyCMP
        *
        nMnRozPS := ROUND( CenZb_PS->nMnozPoc - nMnKonCMP, 2)
        if nMnRozPS = 0
          nMnRozCEN := ROUND( CenZboz->nMnozPoc - nMnKonCMP, 2)
        endif
        nCeRozPS := ROUND( CenZb_PS->nCenaPOC - nCeKonCMP, 2)
        if nCeRozPS = 0
          nCeRozCEN := ROUND( CenZboz->nCenaPoc - nCeKonCMP, 2)
        endif

        If ( nMnRozPS + nMnRozCEN <> 0) .or. ( nCeRozPS + nCeRozCEN <> 0)
          cKey := DtoS( Date()) + Upper( CenZb_PS->cCisSklad) + Upper( CenZb_PS->cSklPol)
          lOK  := ErrPocStav->( dbSeek( cKey))
          lAppend := !lOK

          lOK  := If( lOK, ReplRec( 'ErrPocStav'), AddRec( 'ErrPocStav'))
          If lOK
            lErr := YES
            ErrPocStav->dDatKontr  := Date()
            ErrPocStav->cCisSklad  := CenZb_PS->cCisSklad
            ErrPocStav->cSklPol    := CenZb_PS->cSklPol
            ErrPocStav->nROK       := ::nROK_cmp
            ErrPocStav->nMnPocCMP  := nMnozPoc    // CenZb_PSa->nMnozPoc  pøedchozího roku
            ErrPocStav->nMnPrCMP   := nMnPrCMP    // suma pøíjmù za pøedchozí rok
            ErrPocStav->nMnVyCMP   := nMnVyCMP    // suma výdejù za pøedchozí rok
            ErrPocStav->nMnKonCMP  := nMnKonCMP   // pøepoètené koneèné množství
            ErrPocStav->nCePocCMP  := nCenaPoc    // CenZb_PSa->nCenaPoc pøedchozího roku
            ErrPocStav->nCePrCMP   := nCePrCMP
            ErrPocStav->nCeVyCMP   := nCeVyCMP
            ErrPocStav->nCeKonCMP  := nCeKonCMP   // pøepoètená koneèná cena
            ErrPocStav->nMnPocCEN  := CenZboz->nMnozPoc   // poè. skl.množství z ceníku
            ErrPocStav->nMnKonCEN  := CenZb_PS->nMnozPoc  // poè. skl.množství poèítaného roku
            ErrPocStav->nCePocCEN  := CenZboz->nCenaPoc   // poè. skl.cena z ceníku
            ErrPocStav->nCeKonCEN  := CenZb_PS->nCenaPoc  // poè. skl.cena poèítaného roku
            ErrPocStav->nMnRozdil  := nMnRozPS
            ErrPocStav->nCeRozdil  := nCeRozPS
            mh_WRTzmena( 'ErrPocStav', lAppend )
            ErrPocStav->( dbUnlock())
          EndIf

        EndIf
        PVPItem->( mh_ClrScope())
        PVPItem->( dbGoTo( nRec))
      ENDIF
      PVPItem->( mh_ClrScope())
      CenZb_PS->( dbSkip())
      drgServiceThread:progressInc()

    EndDo

    drgServiceThread:progressEnd()
    drgMsgBOX( drgNLS:msg( 'Konec pøepoètu souboru poèáteèních stavù ...'), XBPMB_INFORMATION)
    *
    PVPItem->( AdsSetOrder( cTagPVP), dbGoTo( nRecPVP) )
    CenZboz->( AdsSetOrder( cTagCen), dbGoTo( nRecCen) )
    CENZBOZa->( dbCloseArea())
    CENZB_PSa->( dbCloseArea())
    *
    ErrPocStav->( dbGoTop())
    ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
    ::drgDialog:dataManager:refresh()

  ENDIF

RETURN self

********************************************************************************
METHOD SKL_CtrlPocSTAVY:OPRAVA_PocStavu()
  Local arSelect := ::drgDialog:dialogCtrl:oBrowse[1]:arSelect
  Local is_SelAllRec := ::drgDialog:dialogCtrl:oBrowse[1]:is_SelAllRec
  Local oMoment, cMsg, cKey

  if( is_SelAllRec .or. !empty( arselect), 'Opravuji vybrané položky ... ' ,;
                                           'Opravuji vybranou položku ...' )

  IF drgIsYESNO(drgNLS:msg( 'Požadujete provést OPRAVU poèáteèních stavù ceníku ?') )
    oMoment := SYS_MOMENT( cMsg)

    Do case
    case   is_SelAllRec
       ErrPocStav->( dbGoTop())
       Do while !ErrPocStav->( eof())
         ::Replace_PS()
         ErrPocStav->( dbSkip())
       Enddo

    case   Len( arSelect) > 0
      For n := 1 to Len(arselect)
        ErrPocStav->( dbGoTo(arselect[n]))
        ::Replace_PS()
      next

    otherwise
      ::Replace_PS()
    endcase

    oMoment:destroy()
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_CtrlPocSTAVY:Replace_PS()
  Local  cKey := Upper( ErrPocStav->cCisSklad) + Upper( ErrPocStav->cSklPol) + StrZero( ErrPocStav->nROK, 4)

  IF CenZb_PS->( dbSeek( cKey,, 'CENPS01'))
    IF CenZb_PS->( dbRLock()) .and. CenZboz->( dbRLock())
      *
      CenZb_PS->nCenaPoc := ErrPocStav->nCeKonCMP
      CenZb_PS->nMnozPoc := ErrPocStav->nMnKonCMP
      CenZboz->nCenaPoc  := ErrPocStav->nCeKonCMP
      CenZboz->nMnozPoc  := ErrPocStav->nMnKonCMP
      *
      CenZb_PS->( dbRUnLock())
      CenZboz->( dbRUnLock())
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_CtrlPocSTAVY:DELETE_Err()
  Local arSelect := ::drgDialog:dialogCtrl:oBrowse[1]:arSelect
  Local is_SelAllRec := ::drgDialog:dialogCtrl:oBrowse[1]:is_SelAllRec
  Local oMoment, cMsg

  cMsg := if( is_SelAllRec .or. !empty( arselect), 'vybrané chybové záznamy ?' ,;
                                                   'vybraný chybový záznam ?' )

  IF drgIsYESNO(drgNLS:msg( 'Požadujete zrušit ' + cMsg) )
    oMoment := SYS_MOMENT()

    Do case
    case   is_SelAllRec
       ErrPocStav->( dbGoTop())
       Do while !ErrPocStav->( eof())
         if ErrPocStav->( sx_RLock())
           ErrPocStav->(dbDelete() )
         endif
         ErrPocStav->( dbSkip())
       Enddo

    case   Len( arSelect) > 0  .and. ErrPocStav->( sx_RLock(arSelect))
      For n := 1 to Len(arselect)
        ErrPocStav->( dbGoTo(arselect[n]), dbDelete())
      next

    otherwise
      if ErrPocStav->( sx_RLock())
        ErrPocStav->( dbDelete())
      endif

    endcase
    ErrPocStav->( dbUnlock())
    ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()

    oMoment:destroy()
  ENDIF
RETURN self