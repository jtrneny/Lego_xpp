********************************************************************************
*  SKL_CTRLSTAVY_2
********************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"

********************************************************************************
* Kontroln� p�epo�et koncov�ch stav� cen�ku
********************************************************************************
CLASS SKL_CtrlSTAVY_2 FROM drgUsrClass

EXPORTED:
  VAR     nROK_start

  METHOD  Init, drgDialogStart, ItemMarked, eventHandled
  METHOD  Cenik_PREPOCET_Stavu, Do_CenZboz
  METHOD  ROK_start
HIDDEN
  VAR     arSelected

ENDCLASS

*
********************************************************************************
METHOD SKL_CtrlSTAVY_2:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('C_DRPOHY' )
  drgDBMS:open('CENZB_PS' )
  *
  ::nROK_start := uctObdobi:SKL:nROK
RETURN self

********************************************************************************
METHOD SKL_CtrlSTAVY_2:drgDialogStart(drgDialog)
RETURN SELF

********************************************************************************
METHOD SKL_CtrlSTAVY_2:ItemMarked()
RETURN SELF

********************************************************************************
METHOD SKL_CtrlSTAVY_2:eventHandled(nEvent, mp1, mp2, oXbp)
  Local dc := ::drgDialog:dialogCtrl

  DO CASE
    CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    CASE nEvent = drgEVENT_DELETE
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
METHOD SKL_CtrlSTAVY_2:ROK_start( oVAR )

  IF oVAR:NAME = 'M->nRok_start'
    IF oVAR:value > uctObdobi:SKL:nROK
      drgMsgBOX( drgNLS:msg( 'Chybn� zadan� rok ...'))
      RETURN .F.
    ELSE
      ::nRok_start := oVAR:value
    ENDIF
  ENDIF
RETURN .T.


METHOD SKL_CtrlSTAVY_2:Cenik_PREPOCET_stavu()
  Local cTagPVP, cScope, cKey
  Local nRecPVP, lOK := .F.

  IF drgIsYESNO(drgNLS:msg( 'Po�adujete prov�st kontroln� v�po�et koncov�ch stav� cen�ku od roku & ?', ::nROK_start) )
    IF PVPITEM->( FLock())

      ::arSelected := ::drgDialog:dialogCtrl:oaBrowse:arSelect
      *
      IF LEN( ::arSelected) > 0
        IF ( lOK := drgIsYESNO(drgNLS:msg( 'Prov�st kontroln� v�po�et ozna�en�ch z�znam� ?' ) ))
          FOR x := 1 TO LEN( ::arSelected)
            CenZBOZ->( dbGoTo( ::arSelected[ x] ))
            ::Do_CenZBOZ()
          NEXT
          RETURN self
        ELSE
          RETURN self
        ENDIF

      ELSE
        nCho := AlertBOX( , "Prov�st kontroln� v�po�et koncov�ch stav� cen�ku !" ,;
                            { "pro ~Aktu�ln� z�znam", "pro ~V�echny z�znamy" }  ,;
                            XBPSTATIC_SYSICON_ICONQUESTION,;
                            'Zvolte mo�nost'    )
        DO CASE
          CASE nCho = 1    //  aktu�ln� z�znam
            ::Do_CenZboz()
            return self
          CASE nCho = 2    //  v�echny z�znamy
            lOK := .T.
          otherwise
            return self
        ENDCASE
      ENDIF

      ( nRecPVP := PVPItem->( RecNo()), cTagPVP := PVPItem->( AdsSetOrder( 'PVPITEM27')) )
      CENZBOZ->( dbGoTop())

      drgServiceThread:progressStart(drgNLS:msg('V�po�et koncov�ch stav� cen�ku ...', 'CENZBOZ'), CenZboz->(LASTREC()) )

      Do While !CenZboz->( Eof())
*          Sleep( 5 )
        ::Do_CenZBOZ()

        CenZboz->( dbSkip())
        drgServiceThread:progressInc()
      EndDo

      drgServiceThread:progressEnd()
      drgMsgBOX( drgNLS:msg( 'Konec v�po�tu koncov�ch stav� cen�ku ...'), XBPMB_INFORMATION)
      *

      PVPItem->( dbUnlock(), AdsSetOrder( cTagPVP), dbGoTo( nRecPVP) )
      *
      ::drgDialog:dataManager:refresh()
    ELSE
      drgMsgBOX( drgNLS:msg( 'Soubor pohyb� je blokov�n jin�m u�ivatelem ! ...'), XBPMB_INFORMATION)
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_CtrlSTAVY_2:Do_CenZboz()
  Local cKey, cScope
  Local lCenik, nRokHLP
  Local nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0
  Local nCenaPoc := 0, nMnozPoc := 0, nCenaCMP := 0, nMnozCMP := 0
  Local lModi, lVydejToZero := .F.

  lCenik := CenZboz->( RLock())

  IF lCenik
    If Upper(CenZboz->cPolCen) == 'C'

      cScope := Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol)
      cKey   := cScope + StrZero( ::nROK_start, 4)
      * Propo�et prov�d�t jen kdy� existuje po�. stav
      lOK := CENZB_ps->( dbSeek( cKey,,'CENPS01'))
      nCenaPoc := IF( lOK, CenZb_ps->nCenaPoc, 0 )
      nMnozPoc := IF( lOK, CenZb_ps->nMnozPoc, 0 )
      CenZboz->nCenasZBO := IF( lOK, nCenaPoc/nMnozPoc, CenZboz->nCenasZBO )

      nCenaCMP := nCenaPoc
      nMnozCMP := nMnozPoc
      *
      PVPITEM->( OrdSetFocus('PVPITEM27'))
      PVPITEM->( mh_SetScope( cKey), dbGoTop())
      ( nCePrCMP := 0, nMnPrCMP := 0, nCeVyCMP := 0, nMnVyCMP := 0 )
      nRokHLP := ::nRok_start
      lModi := .f.

      * Propo�et nad pohybov�m souborem PVPItem
      DO WHILE ! PVPItem->( EOF())
        lVydejToZero := .F.

        IF nRokHLP < PVPITEM->nRok
          * nab�hl pohyb dal��ho roku => aktualizovat hodnoty po�. stav� v CenZBOZ
          CenZBOZ->nMnozPoc := nMnozPoc
          CenZBOZ->nCenaPoc := nCenaPoc
          nRokHLP := PVPITEM->nRok
        ENDIF
        *
        If ( ::nRok_start <= PVPITEM->nRok )
          C_DrPohy->( dbSEEK( PVPItem->nCislPOH))
          If ( C_DrPohy->nKarta <> 400 )
            nMnPrCMP += If( PVPItem->nTypPoh =  1, PVPItem->nMnozPrDod, 0 )
            nMnVyCMP += If( PVPItem->nTypPoh = -1, PVPItem->nMnozPrDod, 0 )
          EndIf
          nCePrCMP += If( PVPItem->nTypPoh =  1, PVPItem->nCenaCelk , 0 )
          *
          If PVPItem->nTypPoh = -1
            /*
            PVPItem->nCenNapDod := CenZBOZ->nCenasZBO
            PVPItem->nCenaCelk  := Round( PVPItem->nMnozPrDod * CenZBOZ->nCenasZBO, 2)
            nCeVyCMP +=PVPItem->nCenaCelk
            */
            If nMnozCMP <= PVPItem->nMnozPrDOD
              lVydejToZero := .T.
              PVPItem->nCenNapDod  := CenZBOZ->nCenasZBO
              PVPItem->nCenaCelk   := nCenaCMP  // CenZboz->nCenacZBO
              PVPItem->nRozdilPoh  := nCenaCMP - ( PVPItem->nMnozPrDOD * PVPItem->nCenNapDod )
              nMnozCMP := nCenaCMP := nMnPrCMP := nMnVyCMP := nCePrCMP := nCeVyCMP := 0
              PVPItem->nMnozsZBO   := PVPItem->nCenacZBO := 0
              nCenaPoc := nMnozPoc := 0

            Else
              PVPItem->nCenNapDod := CenZBOZ->nCenasZBO
              PVPItem->nCenaCelk  := Round( PVPItem->nMnozPrDod * CenZBOZ->nCenasZBO, 2)
              nCeVyCMP +=PVPItem->nCenaCelk
            EndIf
            */
          EndIf
          *
          IF ! lVydejToZero
            nCenaCMP := nCenaPoc + nCePrCMP - nCeVyCMP
            nMnozCMP := nMnozPoc + nMnPrCMP - nMnVyCMP

            PVPItem->nMnozsZBO := nMnozCMP
            PVPItem->nCenacZBO := nCenaCMP
          EndIf

          IF PVPItem->nTypPoh =  1
            CenZboz->nCenasZBO := SkladCena( CenZboz->cTypSklCen, nMnozCMP, nCenaCMP )
          ENDIF
          *
          lModi := .t.
        EndIf

        PVPItem->( dbSkip())
      ENDDO
      *
      IF lModi
        CenZBOZ->nMnozsZBO := nMnozCMP
        CenZBOZ->nCenacZBO := nCenaCMP
        CenZBOZ->nMnozdZBO := CenZBOZ->nMnozsZBO
      ENDIF

      PVPItem->( mh_ClrScope())
      CenZboz->( dbUnLock())
    Endif
  ENDIF

RETURN self

* Dle typu ceny stanov� SKLADOVOU CENU
*===============================================================================
STATIC FUNCTION SkladCENA( cTyp,nMnozCMP, nCenaCMP, file)
  Local nCenas, nRound := 2 //  DecCenaS()

  Default file To "PVPItem"

  Do Case
    Case Upper( cTyp) == 'PEV'
      nCenas := (file)->nCenNapDOD
    Case Upper( cTyp) == 'PRU'
      nCenas := If( nCenaCMP <> 0 .and. nMnozCMP <> 0   ,;
                    Round( nCenaCMP / nMnozCMP, nRound ),;
                    CenZboz->nCenasZBO )
    OtherWise
      nCenas  := CenZboz->nCenasZBO
  EndCase
Return( nCenas)