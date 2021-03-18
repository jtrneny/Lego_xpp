********************************************************************************
*  SKL_CTRLPREP_SCR
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
* Kontroln� p�epo�et koncov�ch stav� cen�ku
********************************************************************************
CLASS SKL_CtrlSTAVY_SCR FROM drgUsrClass

EXPORTED:
  VAR     nCenaSZBO, nROK_start

  METHOD  Init, drgDialogStart, ItemMarked, eventHandled
  METHOD  Cenik_PREPOCET_Stavu, Cenik_OPRAVA_Stavu
  METHOD  ROK_start

 // BRO - aktualni stav polo�ky cenZboz
 inline access assign method nmnozSzbo()  var nmnozSzbo
   local cky := upper(errStav->ccisSklad) +upper(errStav->csklPol)

   cenZboz_as->( dbseek( cky,,'CENIK03'))
 return cenZboz_as->nmnozSzbo

 inline access assign method ncenaCzbo()  var ncenaCzbo
   local cky := upper(errStav->ccisSklad) +upper(errStav->csklPol)

   cenZboz_as->( dbseek( cky,,'CENIK03'))
 return cenZboz_as->ncenaCzbo

HIDDEN
  VAR     arSelected

ENDCLASS

*
********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'cenZboz' ,,,,, 'cenZboz_as' )   // akualni stav cenZboz
  *
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('C_DRPOHY' )
  drgDBMS:open('CENZB_PS' )
  *

  ::nCenaSZBO  := 0
  ::nROK_start := uctObdobi:SKL:nROK
RETURN self

********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:drgDialogStart(drgDialog)
  *
  ErrStav->( DbSetRelation( 'CenZboz'  , {|| Upper(ErrStav->cCisSklad) + Upper(ErrStav->cSklPol)   } ,;
                                             'Upper(ErrStav->cCisSklad) + Upper(ErrStav->cSklPol)'   ,;
                                             'CENIK12'    ))
  ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
RETURN SELF

*
********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:ItemMarked()

  ::nCenaSZBO := ErrStav->nCeKonCMP / ErrStav->nMnKonCMP
RETURN SELF

*
********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    CASE nEvent = drgEVENT_DELETE
      ::arSelected := ::drgDialog:dialogCtrl:oaBrowse:arSelect
      IF LEN( ::arSelected) = 0 .and. .not. ::drgDialog:dialogCtrl:oaBrowse:is_selAllRec
        IF drgIsYESNO(drgNLS:msg('Zru�it aktu�ln� z�znam ?' ) )
         IF ErrStav->( dbRLock())
             ErrStav->( dbDelete(), dbUnlock())
             ::drgDialog:dialogCtrl:oaBrowse:refresh()
             IF ErrStav->( EOF())
               ErrStav->( dbGoTOP())
               ::drgDialog:dialogCtrl:oaBrowse:refresh()
             ENDIF
          ENDIF
        ENDIF

      ELSEIF LEN( ::arSelected) > 0  .and. ErrStav->( sx_RLock( ::arSelected))
        IF drgIsYESNO(drgNLS:msg('Zru�it v�echny ozna�en� z�znamy ?' ) )
          FOR x := 1 TO LEN( ::arSelected)
             ErrStav->( dbGoTO( ::arSelected[ x] ),;
                        ( dbRlock(), dbDelete()) )
          NEXT
          ErrStav->( dbUnlock())
          ::drgDialog:dialogCtrl:oaBrowse:refresh()
        ENDIF
      else
        if drgIsYESNO(drgNLS:msg('Zru�it v�echny z�znamy ?' ) )
          ErrStav->( dbGoTop())
          do while .not. ErrStav->( Eof())
            if ErrStav->( dbRlock())
              ErrStav->(dbDelete())
            endif
            ErrStav->(dbSkip())
          enddo
          ErrStav->( dbUnlock())
          ::drgDialog:dialogCtrl:oaBrowse:refresh()
        endif
      endif
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          PostAppEvent(xbeP_Close,nEvent,,oXbp)
      Otherwise
        RETURN .F.
      EndCase
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .F.

*
********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:ROK_start( oVAR )

  IF oVAR:NAME = 'M->nRok_start'
    IF oVAR:value > uctObdobi:SKL:nROK
      drgMsgBOX( drgNLS:msg( 'Chybn� zadan� rok ...'))
      RETURN .F.
    ELSE
      ::nRok_start := oVAR:value
    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:Cenik_PREPOCET_stavu()
  Local nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0
  Local nCePrKUM := 0, nMnPrKUM := 0, nCeVyKUM := 0, nMnVyKUM := 0
  Local nCeKonCMP, nMnKonCMP, nCenaPoc, nMnozPoc, nRec
  Local nMnRozdil, nCeRozdil, lOK, lErr := NO
  Local cTagPVP, cScope, cKey, cRokPVP
  Local nRecPVP
  Local nRokPVP, lAppend
  *
  local  cflt := "nrok = %%"
  local  cfiltr


  IF drgIsYESNO(drgNLS:msg( 'Po�adujete prov�st kontroln� v�po�et koncov�ch stav� cen�ku od roku & ?', ::nROK_start) )
    *
    drgDBMS:open('CENZBOZ',,,,, 'CENZBOZa')
    ( nRecPVP := PVPItem->( RecNo()), cTagPVP := PVPItem->( AdsSetOrder( 1)) )

    CENZBOZa->( dbGoTop())

    drgServiceThread:progressStart(drgNLS:msg('V�po�et koncov�ch stav� cen�ku ...', 'CENZBOZ'), CenZboz->(LASTREC()) )
****
    cfiltr := format( cflt, { ::nRok_start } )
    pvpitem->( ads_setAof(cfiltr), dbgoTop())

    Do While !CenZboza->( Eof())
      * Pouze cen�kov� polo�ky
      If Upper(CenZboza->cPolCen) == 'C'

        cScope := Upper( CenZboza->cCisSklad) + Upper( CenZboza->cSklPol)
        cKey   := cScope + StrZero( ::nROK_start, 4)
        * Propo�et prov�d�t jen kdy� existuje po�. stav
        lOK := CENZB_ps->( dbSeek( cKey,,'CENPS01'))
        nCenaPoc := IF( lOK, CenZb_ps->nCenaPoc, 0 )
        nMnozPoc := IF( lOK, CenZb_ps->nMnozPoc, 0 )
        *
        nRec := PVPItem->( RecNo())
        PVPITEM->(mh_SetScope( cScope))
        ( nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0 )
        * Propo�et nad pohybov�m souborem PVPItem
        PVPItem->( dbEval( { || ;
           C_DrPohy->( dbSEEK( PVPItem->nCislPOH)) ,;
           If( ::nRok_start <= PVPITEM->nRok .AND. C_DrPohy->nKarta <> 400 ,;
               ( nMnPrCMP += If( PVPItem->nTypPoh ==  1, PVPItem->nMnozPrDod, 0 ),;
                 nMnVyCMP += If( PVPItem->nTypPoh == -1, PVPItem->nMnozPrDod, 0 )), Nil ),;
           If( ::nRok_start <= PVPITEM->nRok ,;
               ( nCePrCMP += If( PVPItem->nTypPoh ==  1, PVPItem->nCenaCelk , 0 ),;
                 nCeVyCMP += If( PVPItem->nTypPoh == -1, PVPItem->nCenaCelk , 0 )), Nil )  } ))

        nCeKonCMP := nCenaPoc + nCePrCMP - nCeVyCMP
        nMnKonCMP := nMnozPoc + nMnPrCMP - nMnVyCMP
        nMnRozdil := ROUND( CenZboza->nMnozsZBO - nMnKonCMP, 2)
        nCeRozdil := ROUND( CenZboza->nCenacZBO - nCeKonCMP, 2)
        If ( nMnRozdil <> 0) .or. ( nCeRozdil <> 0)
          cKey := DtoS( Date()) + Upper( CenZboza->cCisSklad) + Upper( CenZboza->cSklPol)
          lOK  := ErrStav->( dbSeek( cKey))
          lAppend := !lOK

          lOK  := If( lOK, ReplRec( 'ErrStav'), AddRec( 'ErrStav'))
          If lOK
            lErr := YES
            ErrStav->dDatKontr  := Date()
            ErrStav->cCisSklad  := CenZboza->cCisSklad
            ErrStav->cSklPol    := CenZboza->cSklPol
            ErrStav->nMnPocCMP  := nMnozPoc   // CenZboz->nMnozPoc
            ErrStav->nMnPrCMP   := nMnPrCMP
            ErrStav->nMnVyCMP   := nMnVyCMP
            ErrStav->nMnKonCMP  := nMnKonCMP
            ErrStav->nCePocCMP  := nCenaPoc   // CenZboz->nCenaPoc
            ErrStav->nCePrCMP   := nCePrCMP
            ErrStav->nCeVyCMP   := nCeVyCMP
            ErrStav->nCeKonCMP  := nCeKonCMP
            ErrStav->nMnPocCEN  := nMnozPoc   // CenZboz->nMnozPoc
            ErrStav->nMnKonCEN  := CenZboza->nMnozsZBO
            ErrStav->nCePocCEN  := nCenaPoc   // CenZboz->nCenaPoc
            ErrStav->nCeKonCEN  := CenZboza->nCenacZBO
            ErrStav->nMnRozdil  := nMnRozdil
            ErrStav->nCeRozdil  := nCeRozdil
            mh_WRTzmena( 'ErrStav', lAppend )
            ErrStav->( dbUnlock())
          EndIf

        EndIf
        PVPItem->( mh_ClrScope())
        PVPItem->( dbGoTo( nRec))
      Endif
      CenZboza->( dbSkip())
      drgServiceThread:progressInc()

    EndDo

    drgServiceThread:progressEnd()
    drgMsgBOX( drgNLS:msg( 'Konec v�po�tu koncov�ch stav� cen�ku ...'), XBPMB_INFORMATION)
    *
    pvpitem->( ads_clearAof())
    PVPItem->( AdsSetOrder( cTagPVP), dbGoTo( nRecPVP) )

    CenZboza->( dbCloseArea())
    *
    ::itemMarked()

    dbSelectArea('errStav')
    ErrStav->( dbGoTop())
    ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
    ::drgDialog:dataManager:refresh()
  ENDIF
RETURN self


*
********************************************************************************
METHOD SKL_CtrlSTAVY_SCR:Cenik_OPRAVA_stavu()

  IF drgIsYESNO(drgNLS:msg( 'Po�adujete prov�st OPRAVU koncov�ch stav� cen�ku ?') )
    IF CenZboz->( dbRLock())
      CenZboz->nMnozsZBO := ErrStav->nMnKonCMP
      CenZboz->nCenacZBO := ErrStav->nCeKonCMP
      CenZboz->nMnozdZBO := ErrStav->nMnKonCMP
*      nCenaSZBO := ErrStav->nCeKonCMP / ErrStav->nMnKonCMP
      IF ::nCenaSZBO <> CenZboz->nCenaSZBO
        IF drgIsYESNO(drgNLS:msg( 'Po�adujete prov�st i OPRAVU skladov� ceny za MJ ?') )
          CenZboz->nCenaSZBO := ::nCenaSZBO
        ENDIF
      ENDIF
      CenZboz->( dbRUnlock())
    ELSE
      drgMsgBOX( drgNLS:msg( 'Z�znam cen�ku nelze opravit, nebo� je blokov�n jin�m u�ivatelem ! ...'), XBPMB_INFORMATION)
    ENDIF

  ENDIF
RETURN self