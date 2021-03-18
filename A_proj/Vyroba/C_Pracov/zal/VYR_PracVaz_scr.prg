/*==============================================================================
  VYR_PracVAZ_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.ch'
#include "XBP.ch"
#include "Gra.ch"
#include "adsdbe.ch"

*
*===============================================================================
FUNCTION VazbaVykazana()
RETURN IF( PracVAZwp->lVykazano, DRG_ICON_SELECTT, DRG_ICON_SELECTF)
********************************************************************************
*
********************************************************************************
CLASS VYR_PracVAZ_SCR FROM drgUsrClass
EXPORTED:
  VAR     cOznPrac_sel, dDatPlan_sel, nSumNhPLAN, lVykazano
  VAR     nCountVAZ

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  comboItemSelected
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  vyr_Pracov_sel
  METHOD  vazba_VYK, vazby_PLAN
HIDDEN
  VAR     dm, dc
  METHOD  Vyber_Pracov, Vyber_Datum, sumColumn
  METHOD  Vazby_PredOper
ENDCLASS

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRZAK'  )
  drgDBMS:open('PRACVAZ' )
  drgDBMS:open('PRACVAZwp' ,.T.,.T.,drgINI:dir_USERfitm); ZAP  // na pracovištì
  drgDBMS:open('PRACVAZwd' ,.T.,.T.,drgINI:dir_USERfitm); ZAP  // na den
  *
  drgDBMS:open('PolOperZ')
  PolOperZ->( OrdSetFocus( 'POLOPZ_7'), dbGoTOP() )
  drgDBMS:open('PolOperZ',,,,,'PolOperZ_w')
  PolOperZ_w->( OrdSetFocus( 1), dbGoTOP() )
  *
  ::cOznPrac_sel := ''
  ::dDatPlan_sel := DATE() + 1
  ::nSumNhPLAN   := 0
  ::lVykazano    := .T.
  *
  ::nCountVAZ := 0
RETURN self

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, oColumn

  SEPARATORs(members)
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  *
  FOR x := 1 TO ::dc:oBrowse[2]:oXbp:colcount
    ocolumn := ::dc:oBrowse[2]:oXbp:getColumn(x)

    ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
    ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
    ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
    ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
    ocolumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
    ocolumn:configure()
  NEXT
  ::dc:oBrowse[2]:oXbp:refreshAll()
  *
  drgDialog:oForm:setNextFocus( 'M->cOznPrac_sel',,.T.)
RETURN self

*
********************************************************************************
METHOD  VYR_PracVAZ_SCR:drgDialogEnd(drgDialog)
  PRACVAZwp->( DbCloseArea())
  PRACVAZwd->( DbCloseArea())
RETURN

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

    DO CASE
    CASE nEvent = drgEVENT_DELETE
    CASE nEvent = drgEVENT_EDIT
      IF oXbp:cargo:cFILE = 'PRACVAZwp'     // vazba vybrána
        PRACVAZwd->( dbGoTO( PRACVAZwp->( RecNO()) ))
        PRACVAZwp->cPlanovano := '1'
        PRACVAZwd->cPlanovano := '1'
        PracVAZwd->dDatPlan   := ::dDatPlan_sel
        ::nSumNhPLAN += PRACVAZwd->nSumNhPLAN
      ELSE                                 // výbìr vazby zrušen
        PRACVAZwp->( dbGoTO( PRACVAZwd->( RecNO()) ))
        PRACVAZwp->cPlanovano := ' '
        PRACVAZwd->cPlanovano := ' '
        PracVAZwp->dDatPlan   := CTOD('  .  .  ')
        ::nSumNhPLAN -= PRACVAZwd->nSumNhPLAN
      ENDIF
      ::SumColumn()
      ( PRACVAZwp->( dbGoTOP()), ::dc:oBrowse[1]:oXbp:refreshAll() )
      ( PRACVAZwd->( dbGoTOP()), ::dc:oBrowse[2]:oXbp:refreshAll() )
    OTHERWISE
      RETURN .F.
    ENDCASE

RETURN .T.

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:PostValidate(oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)

  DO CASE
  CASE cName = 'M->cOznPrac_sel'
    IF( lOK := ::Vyr_Pracov_sel() )
      ::dm:save()
      ::Vyber_PRACOV()
      ::Vyber_DATUM()
*      ::dc:oaBrowse:oXbp:refreshAll()
    ENDIF
  CASE cName = 'M->dDatPlan_sel'
    ::dm:save()
    ::Vyber_DATUM()
  ENDCASE
RETURN  lOK

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:ComboItemSelected(drgComboBox)
  ::lVykazano := drgComboBox:value
  ::Vyber_PRACOV()
  ::Vyber_DATUM()
RETURN SELF

* Výbìr pracovištì
********************************************************************************
METHOD VYR_PracVAZ_SCR:VYR_PRACOV_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('M->cOznPrac_sel'))
  LOCAL lOK   := Empty( value) .or. ;
                ( !Empty( value) .and. C_PRACOV->( dbSEEK( Value,, 'C_PRAC1')) )

  IF IsObject( oDlg) .or. ! lOK
    DRGDIALOG FORM 'VYR_PRACOV_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( 'M->cOznPrac_sel', ::cOznPrac_sel := C_PRACOV->cOznPrac )
    ::dm:refresh()
  ENDIF

RETURN lOK

* Zaplánování vazeb na vybraný den
********************************************************************************
METHOD VYR_PracVAZ_SCR:vazby_PLAN()
  Local aREC := {}, isLock

 IF drgIsYESNO(drgNLS:msg( 'Zaplánovat vazby na vybraný den ?') )
   * tj. naplnit PRACVAZ->dDatPlan u vybraných
   PRACVAZwd->( dbGoTOP(), dbEVAL({|| AADD( aREC, PRACVAZwd->_nrecor) })  )
   isLock := PRACVAZ->( sx_RLock( aREC))
   IF isLock
     FOR n := 1 TO LEN( aREC)
       PRACVAZ->( dbGoTO( aREC[n]))
       PRACVAZ->dDatPlan := ::dDatPlan_sel
     NEXT
     PRACVAZ->( dbUnlock())
   ENDIF
   * vyprázdnit PRACVAZ->dDatPlan u nevybraných
 ENDIF
RETURN

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:destroy()
  ::drgUsrClass:destroy()
  * EXPORTED
  ::cOznPrac_sel := ::dDatPlan_sel := ::nSumNhPLAN := ::lVykazano  := NIL
  *
RETURN self

* Vykázat vazbu
********************************************************************************
METHOD VYR_PracVAZ_SCR:Vazba_VYK()
  Local cMsg := IF( PRACVAZwp->lVykazano, 'Požadujete zrušit vykázání vazby ',;
                                          'Požadujete vykázat vazbu ' )
*  drgMsgBox(drgNLS:msg( 'Vykázat vazbu ?'))
  IF drgIsYESNO(drgNLS:msg( cMsg + '[ & ] ?', PracVAZwp->cIdVazby) )
    PRACVAZwp->lVykazano := !PRACVAZwp->lVykazano
    PRACVAZwp->dDatVykaz := IF( PRACVAZwp->lVykazano, DATE(),CTOD( '  .  .  ') )
    PracVAZ->( dbGoTO( PRACVAZwp->_nRecOr))
    IF PracVAZ->( RLock())
      PRACVAZ->lVykazano := PRACVAZwp->lVykazano
      PRACVAZ->dDatVykaz := IF( PRACVAZ->lVykazano, DATE(),CTOD( '  .  .  ') )
      PracVAZ->( dbUnLock())
    ENDIF
    ::dc:oBrowse[1]:oXbp:refreshCurrent()
  ENDIF

RETURN

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vyber_Pracov()
  LOCAL lCond, lVazbyPredOper, lZakOK := .F.

  PracVAZwp->( dbZAP())
  PracVAZwd->( dbZAP())
  PracVAZ->( OrdSetFOCUS('PRVAZ_1'),;
             dbSetSCOPE( SCOPE_BOTH, UPPER( ::cOznPrac_sel) ), dbGoTOP() )
  DO WHILE !PracVAZ->( EOF())
    IF  VYRZAK->( dbSEEK( Upper( PracVAZ->cCisZakaz),, 'VYRZAK1'))
      lZakOK := ( ALLTRIM( Upper(VYRZAK->cCisZakaz)) <> 'U' )
    ENDIF
    lVazbyPredOper := ::Vazby_PredOper()  // .t.  // vykázány vazby pøedchozích operací  !!!
    lCond := !PracVaz->lVykazano .and. ;
             lVazbyPredOper       .and. ;
             PRACVAZ->dDatPlan <= ::dDatPlan_sel .and. ;
             lZakOK
    IF lCond
      mh_COPYFLD( 'PRACVAZ', 'PRACVAZwp',.T.)
      mh_COPYFLD( 'PRACVAZ', 'PRACVAZwd',.T.)
    ENDIF
    PracVAZ->( dbSKIP())
  ENDDO
  ::dc:oBrowse[1]:oXbp:refreshAll()
RETURN

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vyber_Datum

  PracVAZwp->( dbGoTOP() )
  IF PRACVAZwp->( RecNO()) <> 0    // aktualizuje horní browse
    DO WHILE !PracVAZwp->( EOF())
      PRACVAZwd->( dbGoTO( PRACVAZwp->( RecNO()) ))
      lCond := PracVAZwp->dDatPlan < ::dDatPlan_sel
      IF lCond
        PRACVAZwd->cPlanovano := ' '  //   '1'
        PRACVAZwp->cPlanovano := ' '  // '1'
      ELSE
        PRACVAZwd->cPlanovano := '1'  //   '1'
        PRACVAZwp->cPlanovano := '1'  // '1'
      ENDIF
      PracVAZwp->( dbSKIP())
    ENDDO
*  PracVAZwp->( dbGoTOP() )
  ENDIF
  *
  PracVAZwd->( dbGoTOP() )
  IF PRACVAZwd->( RecNO()) <> 0    // aktualizuje spodní browse
    DO WHILE !PracVAZwd->( EOF())
      PRACVAZwp->( dbGoTO( PRACVAZwd->( RecNO()) ))
      lCond := PracVAZwd->dDatPlan = ::dDatPlan_sel
      IF lCond
        PRACVAZwd->cPlanovano := '1'
        PRACVAZwp->cPlanovano := '1'
        ::nSumNhPLAN += PRACVAZwd->nSumNhPLAN
      ELSE
        PRACVAZwd->cPlanovano := ' '
        PRACVAZwp->cPlanovano := ' '
        ::nSumNhPLAN -= PRACVAZwd->nSumNhPLAN
      ENDIF
      PracVAZwd->( dbSKIP())
    ENDDO
  ENDIF
  *
  ::SumColumn()
  ( PRACVAZwp->( dbGoTOP()), ::dc:oBrowse[1]:oXbp:refreshAll() )
  ( PRACVAZwd->( dbGoTOP()), ::dc:oBrowse[2]:oXbp:refreshAll() )
RETURN

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:SumColumn()
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:setCell(1, ::nSumNhPLAN)
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:show()
  *
**  ::nCountVAZ := PRACVAZwd->( Ads_GetKeyCount(ADS_RESPECTFILTERS))
  ::dm:refresh()
RETURN

* Zjistí, zda byly vykázány všechny vazby u všech pøedchozích operací dané vazby
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vazby_PredOper()
  Local lOK := .T., lVazbyPredOper := .T., cKEYw
  Local cKEY := Upper( PracVAZ->cCisZakaz) + StrZERO( PracVAZ->nPocCeZapZ, 2) +;
                StrZERO( PracVAZ->nRokVytvor, 4) + StrZERO( PracVAZ->nPorCisLis, 12) + ;
                Upper( PracVAZ->cOznPrac) + Upper( PracVAZ->cOznPracN)
  Local nRec := PracVaz->( RecNo()), cTag := PracVAZ->( OrdSetFOCUS( 'PRVAZ_2'))

  PolOperZ->( dbSetScope(SCOPE_BOTH, cKEY), dbGoTOP() )

  DO WHILE !PolOperZ->( EOF()) .AND. lVazbyPredOper
    * Zjistíme, zda existuje pøedchozí operace
    cKEYw := Upper( PolOperZ->cCisZakaz) + Upper( PolOperZ->cVyrPol)
*             StrZERO( PolOperZ->nCisOper, 4)
    PolOperZ_w->( dbSetScope( SCOPE_BOTH, cKEYw), dbGoTOP() )
    PolOperZ_w->( dbSeek( cKEYw + StrZERO( PolOperZ->nCisOper, 4) ))
    PolOperZ_w->( dbSkip( -1) )
    IF PolOperZ_w->nCisOper == 0
      * pøedchozí operace neexistuje => podmínka vykázanosti se považuje za splnìnou
      lOK := .T.
    ELSEIF PolOperZ_w->nCisOper < PolOperZ->nCisOper
      * Zjistíme, zda vazba pøedchozí operace je vykázána
      IF PracVAZ->( dbSeek( PolOperZ_w->cIdVazby))
        lOK := PracVAZ->lVykazano
      ENDIF
    ENDIF
    PolOperZ_w->( dbClearScope())
    lVazbyPredOper := IF( lVazbyPredOper, lOK, lVazbyPredOper )

    PolOperZ->( dbSkip())
  ENDDO
  PolOperZ->( dbClearScope())
  PracVAZ->( OrdSetFOCUS( cTag), dbGoTO( nRec))

  IF lVazbyPredOper   // všechny pøedchozí vazby byly vykázány
    lVazbyPredOper := IF( ::lVykazano, lVazbyPredOper, !lVazbyPredOper)
  ELSE
    lVazbyPredOper := IF( ::lVykazano, lVazbyPredOper, !lVazbyPredOper)
  ENDIF
RETURN lVazbyPredOper