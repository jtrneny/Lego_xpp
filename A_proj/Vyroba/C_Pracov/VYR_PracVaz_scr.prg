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

# Define   COMPILE(c)      &("{||" + c + "}")

*
*===============================================================================
FUNCTION SumNhPrepocet( nFILE)
  Local  aFILE := {'PracVAZwp', 'PracVAZwd' }
RETURN ( (aFILE[ nFile])->nSumNhPlan * C_Pracov->nKoefPrep )

*
*===============================================================================
FUNCTION VazbaVykazana( nFILE)
  Local  aFILE := {'PracVAZwp', 'PracVAZwd', 'PracVAZ' }

RETURN IF( (aFILE[ nFile])->lVykazano, DRG_ICON_SELECTT, DRG_ICON_SELECTF)
*
*===============================================================================
FUNCTION VazbaVykZPlan( nFILE)
  Local  aFILE := {'PracVAZwp', 'PracVAZwd', 'PracVAZ' }

RETURN IF( (aFILE[ nFile])->lVykZPlan, DRG_ICON_SELECTT, DRG_ICON_SELECTF)
*
*===============================================================================
FUNCTION VazbaVSCHM( nFILE)
  Local  aFILE := {'PracVAZwp', 'PracVAZwd', 'PracVAZ' }

RETURN IF( (aFILE[ nFile])->lVSCHM, DRG_ICON_SELECTT, DRG_ICON_SELECTF)


********************************************************************************
*
********************************************************************************
CLASS VYR_PracVAZ_SCR FROM drgUsrClass
EXPORTED:
  VAR     cOznPrac_sel, dDatPlan_sel, nSumNhPLAN, nSumNhPLANprep, nSumKcOPER
  VAR     nCountVAZ, nVazby_Show

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  comboItemSelected
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  vyr_Pracov_sel
  METHOD  vazba_VYK, vazby_PLAN, vazba_VSCHM
  METHOD  act_AktualDAT, act_OperaceVAZ, act_PredchVAZ, act_PreplanVAZ
  METHOD  Move_TOP, Move_UP, Move_DOWN, Move_BOT

HIDDEN
  VAR     dm, dc, msg
  METHOD  Vyber_Pracov, Vyber_Datum
  METHOD  sumColumn, newPoradi
  METHOD  Vazby_PredOper
ENDCLASS

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Init(parent)

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRZAK'   )
  drgDBMS:open('PRACVAZ'  )
  drgDBMS:open('PRACVAZwp' ,.T.,.T.,drgINI:dir_USERfitm); ZAP  // na pracovištì
  drgDBMS:open('PRACVAZwd' ,.T.,.T.,drgINI:dir_USERfitm); ZAP  // na den
  *
  drgDBMS:open('PolOperZ' )
  PolOperZ->( AdsSetOrder( 7), dbGoTOP() )
  drgDBMS:open('PolOperZ',,,,,'PolOperZ_w')
  PolOperZ_w->( AdsSetOrder( 1), dbGoTOP() )
  *
  drgDBMS:open('C_PRACOV' )

  ::cOznPrac_sel := ''
  C_PRACOV->( dbSeek( Upper( ::cOznPrac_sel )))

  ::dDatPlan_sel := DATE() + 1
  ::nSumNhPLAN   := ::nSumNhPLANprep := ::nSumKcOPER := 0
  ::nVazby_Show  := 1
  *
  ::nCountVAZ := 0
  *
RETURN self

********************************************************************************
METHOD VYR_PracVAZ_SCR:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x, oColumn

  SEPARATORs(members)
  *
  ::dm  := drgDialog:dataManager
  ::dc  := drgDialog:dialogCtrl
  ::msg := drgDialog:oMessageBar
  /*
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
  */
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
  Local nPoradi := 0

    DO CASE
    CASE nEvent = drgEVENT_DELETE
    CASE nEvent = drgEVENT_EDIT
      IF oXbp:cargo:cFILE = 'PRACVAZwp'     // vazba vybrána
*        nPoradi := PracVAZwd->( dbGoTOP(), dbEVAL( {|| nPoradi := nPoradi + 1 }))
        nPoradi := PracVAZwd->( mh_CountREC())
        nPoradi++
        PRACVAZwd->( dbGoTO( PRACVAZwp->( RecNO()) ))
        PRACVAZwp->cPlanovano := '1'
        PRACVAZwd->cPlanovano := '1'
        PracVAZwd->dDatPlan   := ::dDatPlan_sel
        *
        PRACVAZwd->lVykazano := PRACVAZwp->lVykazano
        PRACVAZwd->dDatVykaz := PRACVAZwp->dDatVykaz
        PRACVAZwd->lVykZPlan := PRACVAZwp->lVykZPlan
        PRACVAZwd->lVschm    := PRACVAZwp->lVschm
        PRACVAZwd->dDatVschm := PRACVAZwp->dDatVschm
        *
        ::nSumNhPLAN     += PRACVAZwd->nSumNhPLAN
        ::nSumNhPLANprep += SumNhPrepocet( 2)
        ::nSumKcOPER     += PRACVAZwd->nKcNaOper
        PracVAZwd->nPoradi    := nPoradi
        /*
        ::SumColumn()
        ::dc:oBrowse[1]:oXbp:refreshAll()
         PostAppEvent(xbeK_CTRL_PGDN,,::dc:obrowse[2]:oxbp)
        ::dc:oBrowse[2]:oXbp:goBottom()
        ::dc:oBrowse[2]:oXbp:refreshAll()
        */
      ELSE                                 // výbìr vazby zrušen
        PRACVAZwp->( dbGoTO( PRACVAZwd->( RecNO()) ))
        PRACVAZwp->cPlanovano := ' '
        PRACVAZwd->cPlanovano := ' '
        PracVAZwd->nPoradi    := 0
        PracVAZwp->dDatPlan   := CTOD('  .  .  ')
        ::nSumNhPLAN     -= PRACVAZwd->nSumNhPLAN
        ::nSumNhPLANprep -= SumNhPrepocet( 2)
        ::nSumKcOPER     -= PRACVAZwd->nKcNaOper
        ::newPoradi()
        ::SumColumn()
        /*
        ::dc:oBrowse[1]:oXbp:refreshAll()
        ::dc:oBrowse[2]:oXbp:refreshAll()
        */
      ENDIF

      ::SumColumn()
*      ::dc:oBrowse[1]:oXbp:refreshAll()
*      ::dc:oBrowse[2]:oXbp:refreshAll()
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
  CASE cName = 'PRACVAZwd->cPopVazby'
    ::dm:save()
    SetAppFocus(::dc:oaBrowse:oXbp)
*    SetAppFocus(::dc:oBrowse[2]:oXbp)
  ENDCASE
RETURN  lOK

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:ComboItemSelected(drgComboBox)
  ::nVazby_Show := drgComboBox:value
  ::Vyber_PRACOV()
  ::Vyber_DATUM()
RETURN SELF

* Výbìr pracovištì
********************************************************************************
METHOD VYR_PracVAZ_SCR:VYR_PRACOV_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ALLTRIM( ::dm:get('M->cOznPrac_sel')))
*  LOCAL lOK   := Empty( value) .or. ;
*                ( !Empty( value) .and. C_PRACOV->( dbSEEK( Value,,  5)) )
  LOCAL lOK   := Empty( value) .or. ;
                ( !Empty( value) .and. C_PRACOV->( dbLocate({|| C_PRACOV->cOznPrac = Value })) )

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
  Local aREC := {}, aRECor := {}, isLock

 IF drgIsYESNO(drgNLS:msg( 'Zaplánovat vazby na vybraný den ?') )
   * tj. naplnit PRACVAZ->dDatPlan u vybraných
   PRACVAZwd->( dbGoTOP(), dbEVAL({|| AADD( aRECor, PRACVAZwd->_nrecor),;
                                      AADD( aREC  , PRACVAZwd->( RecNO()) )  }) )
   isLock := PRACVAZ->( sx_RLock( aRECor))
   IF isLock
     FOR n := 1 TO LEN( aRECor)
       PRACVAZ->( dbGoTO( aRECor[n]))
       PRACVAZwd->( dbGoTO( aREC[n]))
       PRACVAZ->dDatPlan := ::dDatPlan_sel
       PRACVAZ->nPoradi  := PRACVAZwd->nPoradi
     NEXT
     PRACVAZ->( dbUnlock())
   ENDIF
   * vyprázdnit PRACVAZ->dDatPlan u nevybraných
   aREC   := {}
   aRECor := {}
   PRACVAZwp->( dbGoTOP(), dbEVAL({|| AADD( aRECor, PRACVAZwp->_nrecor),;
                                      AADD( aREC  , PRACVAZwp->( RecNO()) )  }) )
   isLock := PRACVAZ->( sx_RLock( aRECor))
   IF isLock
     FOR n := 1 TO LEN( aRECor)
       PRACVAZ->( dbGoTO( aRECor[n]))
*       PRACVAZwp->( dbGoTO( aREC[n]))
       PRACVAZ->dDatPlan := CTOD('  .  .  ')
       PRACVAZ->nPoradi  := 0
     NEXT
     PRACVAZ->( dbUnlock())
   ENDIF
   *
   ::act_AktualDAT()
 ENDIF
RETURN

*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Move_TOP()
  Local nOldRec := PracVAZwd->( RecNO()), nOldPoradi := PracVAZwd->nPoradi, aREC := {}

  PracVAZwd->( dbGoTOP())
  IF PracVAZwd->nPoradi = nOldPoradi
    TONE( 500)
    Return self
  ENDIF
  *
  DO WHILE PracVAZwd->nPoradi < nOldPoradi
    AADD( aREC, PracVAZwd->( RecNO()))
    PracVAZwd->( dbSKIP())
  ENDDO
  PracVAZwd->( dbGoTO( nOldRec))
  PracVAZwd->nPoradi := 1
  AEVAL( aREC, {|x| PracVAZwd->( dbGoTO( x)) ,;
                    PracVAZwd->nPoradi += 1  } )
  PracVAZwd->( dbGoTO( nOldRec))
  ::dc:oBrowse[2]:oXbp:refreshAll()

RETURN self
*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Move_UP()
  Local nRec := PracVAZwd->( RecNO()), nPrevREC

  IF PracVAZwd->nPoradi = 1
    TONE( 500)
  ELSE
    PracVAZwd->( dbSkip( -1))
    nPrevREC    := PracVAZwd->( RecNO())
    PracVAZwd->( dbSkip())
    PracVAZwd->nPoradi := PracVAZwd->nPoradi - 1
    PracVAZwd->( dbGoTO( nPrevREC))
    PracVAZwd->nPoradi := PracVAZwd->nPoradi + 1
    PracVAZwd->( dbGoTO( nREC))
    ::dc:oBrowse[2]:oXbp:refreshAll()

  ENDIF
RETURN self
*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Move_DOWN()
  Local nOldRec := PracVAZwd->( RecNO()), nOldPoradi := PracVAZwd->nPoradi
  Local nNewREC

  PracVAZwd->( dbGoBottom())
  IF PracVAZwd->nPoradi = nOldPoradi
    TONE( 500)
    Return self
  ENDIF

  PracVAZwd->( dbGoTO( nOldRec), dbSkip() )
  nNewREC    := PracVAZwd->( RecNO())
  PracVAZwd->( dbSkip( -1))
  PracVAZwd->nPoradi := PracVAZwd->nPoradi + 1
  PracVAZwd->( dbGoTO( nNewRec))
  PracVAZwd->nPoradi := PracVAZwd->nPoradi - 1
  PracVAZwd->( dbGoTO( nOldREC))
  ::dc:oBrowse[2]:oXbp:refreshAll()

RETURN self
*
********************************************************************************
METHOD VYR_PracVAZ_SCR:Move_BOT()
  Local nOldRec := PracVAZwd->( RecNO()), nOldPoradi := PracVAZwd->nPoradi, aREC := {}
  Local nMaxPoradi

  PracVAZwd->( dbGoBottom())
  IF PracVAZwd->nPoradi = nOldPoradi
    TONE( 500)
    Return self
  ENDIF
  nMaxPoradi := PracVAZwd->nPoradi
  *
  PracVAZwd->( dbGoTO( nOldRec), dbSKIP() )
  DO WHILE PracVAZwd->nPoradi > nOldPoradi
    AADD( aREC, PracVAZwd->( RecNO()))
    PracVAZwd->( dbSKIP())
  ENDDO
  PracVAZwd->( dbGoTO( nOldRec))
  PracVAZwd->nPoradi := nMaxPoradi
  AEVAL( aREC, {|x| PracVAZwd->( dbGoTO( x)) ,;
                    PracVAZwd->nPoradi -= 1  } )
  PracVAZwd->( dbGoTO( nOldRec))
  ::dc:oBrowse[2]:oXbp:refreshAll()
RETURN self


*
********************************************************************************
METHOD VYR_PracVAZ_SCR:destroy()
  ::drgUsrClass:destroy()
  *
  ::cOznPrac_sel := ::dDatPlan_sel := ::nSumNhPLAN := ::nSumNhPLANprep := ::nSumKcOPER :=  ;
  ::nVazby_Show  :=   NIL
  *
RETURN self

* Vykázat vazbu
********************************************************************************
METHOD VYR_PracVAZ_SCR:Vazba_VYK()
  Local cMsg := IF( PRACVAZwp->lVykazano, 'Požadujete zrušit vykázání vazby ',;
                                          'Požadujete vykázat vazbu ' )

  IF drgIsYESNO(drgNLS:msg( cMsg + '[ & ] ?', PracVAZwp->cIdVazby) )
    PRACVAZwp->lVykazano := !PRACVAZwp->lVykazano
    PRACVAZwp->dDatVykaz := IF( PRACVAZwp->lVykazano, DATE(),CTOD( '  .  .  ') )
    PRACVAZwp->lVykZPlan := PRACVAZwp->lVykazano
    PracVAZ->( dbGoTO( PRACVAZwp->_nRecOr))
    IF PracVAZ->( RLock())
      PRACVAZ->lVykazano := PRACVAZwp->lVykazano
      PRACVAZ->dDatVykaz := PRACVAZwp->dDatVykaz
      PRACVAZ->lVykZPlan := PRACVAZwp->lVykZPlan
      PracVAZ->( dbUnLock())
    ENDIF
    ::dc:oBrowse[1]:oXbp:refreshCurrent()
  ENDIF

RETURN

* Vykázat vazbu
********************************************************************************
METHOD VYR_PracVAZ_SCR:Vazba_VSCHM()
  Local cMsg := IF( PRACVAZwp->lVSCHM, 'Požadujete zrušit oznaèení vazby s chybìjícím materiálem',;
                                       'Požadujete oznaèit vazbu s chybìjícím materiálem ' )

  IF drgIsYESNO(drgNLS:msg( cMsg + '[ & ] ?', PracVAZwp->cIdVazby) )
    PRACVAZwp->lVSCHM := !PRACVAZwp->lVSCHM
    PRACVAZwp->dDatVSCHM := IF( PRACVAZwp->lVSCHM, DATE(),CTOD( '  .  .  ') )
*    PRACVAZwp->lVykZPlan := PRACVAZwp->lVykazano
    PracVAZ->( dbGoTO( PRACVAZwp->_nRecOr))
    IF PracVAZ->( RLock())
      PRACVAZ->lVSCHM    := PRACVAZwp->lVSCHM
      PRACVAZ->dDatVSCHM := PRACVAZwp->dDatVSCHM
*      PRACVAZ->lVykZPlan := PRACVAZwp->lVykZPlan
      PracVAZ->( dbUnLock())
    ENDIF
    ::dc:oBrowse[1]:oXbp:refreshCurrent()
  ENDIF

RETURN

* Aktualizace dat
********************************************************************************
METHOD VYR_PracVAZ_SCR:act_AktualDAT()
  Local  cMsg := drgNLS:msg('MOMENT PROSÍM - aktualizuji data ...')

  ::msg:writeMessage( cMsg)
  *
  ::Vyber_PRACOV()
  ::Vyber_DATUM()
  *
  ::msg:WriteMessage(,0)
RETURN

* Seznam operací k vazbì
********************************************************************************
METHOD VYR_PracVAZ_SCR:act_OperaceVAZ()
  LOCAL oDialog, Filter

*   Filter := FORMAT("(PolOperZ->cIdVazby = '%%')",{ PRACVAZwp->cIdVazby } )
*   PolOperZ->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_PolOpVaz_scr' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

*  PolOperZ->( dbClearFILTER())
RETURN self

* Seznam operací k vazbì
********************************************************************************
METHOD VYR_PracVAZ_SCR:act_PredchVAZ()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_PredchVaz_scr,' + ::cOznPrac_sel PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Pøeplánování vazeb
********************************************************************************
METHOD VYR_PracVAZ_SCR:act_PreplanVAZ()
  Local  cOznPrac, n, m, lOK
  Local  aRecPrac := {}  //  obsahuje záznamy vazeb za jednotlivé pracovištì
  Local  aRecALL  := {}  //  obsahuje pole všech pracovišt
  Local  cMsg := drgNLS:msg('MOMENT PROSÍM - zjišují se vazby k pøeplánování ...')


  IF drgIsYesNo( drgNLS:msg('Opravdu chcete pøeplánovat nevykázané vazby z pøedchozích dnù na zadaný den ?') )
    ::msg:writeMessage( cMsg)

    * Výbìr vazeb k pøeplánování
    PracVAZ->( dbGoTOP())
    cOznPrac := PracVAZ->cOznPrac
    DO WHILE !PracVAZ->( EOF())
      IF cOznPrac = PracVAZ->cOznPrac
        IF !PracVAZ->lVykazano .and. !PracVAZ->lVykZPlan .and. ;
           !EMPTY( PracVAZ->dDatPlan) .and. PracVAZ->dDatPlan <= ::dDatPlan_sel
          AADD( aRecPrac, PracVAZ->( RecNO()) )
        ENDIF
      ELSE
        IF LEN( aRecPrac) > 0
          AADD( aRecALL, aRecPrac )
          aRecPrac := {}
        ENDIF
        cOznPrac := PracVAZ->cOznPrac
        PracVAZ->( dbSKIP(-1))
      ENDIF
      PracVAZ->( dbSKIP())
    ENDDO
    *
    IF LEN( aRecPrac) > 0
      AADD( aRecALL, aRecPrac )
      aRecPrac := {}
    ENDIF

    * Není co pøeplánovat
    IF LEN( aRecALL) = 0
      drgMsgBox(drgNLS:msg('K pøeplánování nebyly nalezeny žádné vazby ...'))
      ::msg:WriteMessage(,0)
      RETURN NIL
    ENDIF

    * Zámky na záznamy, které bude potøeba pøeplánovat !
    lOK := .T.
    FOR n := 1 TO LEN( aRecALL)
      lOK := IF( PracVAZ->( sx_RLock( aRecALL[ n])), lOK, .F. )
    NEXT
    * Pøeplánování s novým poøadím
    IF lOK
      FOR n := 1 TO LEN( aRecALL)
        FOR m := 1 TO LEN( aRecALL[n])
          PracVAZ->( dbGoTO( aRecALL[ n, m ]))
          PracVAZ->dDatPlan := ::dDatPlan_sel
          PracVAZ->nPoradi  := m
        NEXT
      NEXT
      PracVAZ->( dbUnlock())
      * Obnova aktuální obrazovky
      ::Vyber_PRACOV()
      ::Vyber_DATUM()
      drgMsgBox(drgNLS:msg('Nevykázané vazby zaplánované na pøedchozí dny byly pøeplánovány na den : [ & ]', ::dDatPlan_sel))
    ELSE
      drgMsgBox(drgNLS:msg('Nelze pøeplánovat, záznamy jsou blokovány jiným uživatelem ...'))
    ENDIF

    ::msg:WriteMessage(,0)
    *
  ELSE
    drgMsgBox(drgNLS:msg('Pøeplánování vazeb bylo pøerušeno !'))
  ENDIF
RETURN NIL

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vyber_Pracov()
  LOCAL lCond, lVazbyPredOper, lZakOK := .F.

  PracVAZwp->( dbZAP())
  PracVAZwd->( dbZAP())
  PracVAZ->( AdsSetOrder( 1),;
             mh_SetSCOPE( UPPER( ::cOznPrac_sel) ) )
  DO WHILE !PracVAZ->( EOF())
    IF  VYRZAK->( dbSEEK( Upper( PracVAZ->cCisZakaz),, 'VYRZAK1'))
      lZakOK := ( ALLTRIM( Upper(VYRZAK->cCisZakaz)) <> 'U' )
    ENDIF
    lVazbyPredOper := ::Vazby_PredOper()  // .t.  // vykázány vazby pøedchozích operací  !!!
    lCond := IF( ::nVazby_Show = 3, .T., !PracVaz->lVykazano) .and. ;
             lVazbyPredOper       .and. ;
             PRACVAZ->dDatPlan <= ::dDatPlan_sel .and. ;
             lZakOK
    IF lCond
      mh_COPYFLD( 'PRACVAZ', 'PRACVAZwp',.T., .T.)
      mh_COPYFLD( 'PRACVAZ', 'PRACVAZwd',.T., .T.)
    ENDIF
    PracVAZ->( dbSKIP())
  ENDDO
  ::dc:oBrowse[1]:oXbp:refreshAll()
  *
  PracVAZ->( mh_ClrSCOPE(), dbGoTOP() )
RETURN

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vyber_Datum

  PracVAZwp->( AdsSetOrder(0), dbGoTOP() )         //**
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
  PracVAZwp->( AdsSetOrder(1), dbGoTOP() )         //**
  *
  PracVAZwd->( AdsSetOrder(0), dbGoTOP() )         //**
  PracVAZwd->( dbGoTOP() )
  IF PRACVAZwd->( RecNO()) <> 0    // aktualizuje spodní browse
    DO WHILE !PracVAZwd->( EOF())
      PRACVAZwp->( dbGoTO( PRACVAZwd->( RecNO()) ))
      lCond := PracVAZwd->dDatPlan = ::dDatPlan_sel
      IF lCond
        PRACVAZwd->cPlanovano := '1'
        PRACVAZwp->cPlanovano := '1'
      ELSE
        PRACVAZwd->cPlanovano := ' '
        PRACVAZwp->cPlanovano := ' '
      ENDIF
      PracVAZwd->( dbSKIP())
    ENDDO
    *  aktualizuje sumaèní položky
    PracVAZwd->( AdsSetOrder(1), dbGoTOP() )   //**
    ::nSumNhPLAN := ::nSumNhPLANprep := ::nSumKcOPER := 0
    DO WHILE !PracVAZwd->( EOF())
      IF PRACVAZwd->cPlanovano = '1'
        ::nSumNhPLAN     += PRACVAZwd->nSumNhPLAN
        ::nSumNhPLANprep += SumNhPrepocet( 2)
        ::nSumKcOPER     += PRACVAZwd->nKcNaOper
      ENDIF
      PracVAZwd->( dbSKIP())
    ENDDO
    *
    ::newPoradi()
  ENDIF
  PracVAZwd->( AdsSetOrder(1), dbGoTOP() )   //**
  *
  ::SumColumn()
  ( PRACVAZwp->( dbGoTOP()), ::dc:oBrowse[1]:oXbp:refreshAll() )
  ( PRACVAZwd->( dbGoTOP()), ::dc:oBrowse[2]:oXbp:refreshAll() )
RETURN

*
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:SumColumn()
  *
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:setCell(1, ::nSumNhPLAN)
  ::dc:oBrowse[2]:oXbp:getColumn(6):Footing:show()
  *
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:setCell(1, ::nSumNhPLANprep)
  ::dc:oBrowse[2]:oXbp:getColumn(7):Footing:show()
  *
  ::dc:oBrowse[2]:oXbp:getColumn(8):Footing:hide()
  ::dc:oBrowse[2]:oXbp:getColumn(8):Footing:setCell(1, ::nSumKcOPER)
  ::dc:oBrowse[2]:oXbp:getColumn(8):Footing:show()
  *
  ::dm:refresh()
RETURN

* Pøeèísluje poøadí v rámci dne pøi zrušení záznamu v daném dnu
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:newPoradi()
  Local nPoradi := 0, cIdVazby
  Local aRec := {}

*  PRACVAZwd->( dbGoTOP(), dbEVAL({|| PRACVAZwd->nPoradi := ++nPoradi }), dbGoTOP() )
/*
  PRACVAZwd->( dbGoTOP())
  DO WHILE ! PracVAZwd->( Eof())

    PRACVAZwd->nPoradi := ++nPoradi
    cIdVazby :=  PRACVAZwd->cIdVazby
    PracVAZwd->( dbSkip())
  ENDDO
  PRACVAZwd->( AdsSetOrder( cTAG))
  PRACVAZwd->( dbGoTOP())
*/

  PRACVAZwd->( dbGoTOP(), dbEVAL({|| AADD( aREC, { PracVAZwd->( RecNO()), ++nPoradi}) }), dbGoTOP() )
  AEVAL( aREC, {|x| PracVAZwd->( dbGoTO( x[ 1])),;
                    PracVAZwd->nPoradi := x[ 2]  } )
  PRACVAZwd->( dbGoTOP())
RETURN


* Zjistí, zda byly vykázány všechny vazby u všech pøedchozích operací dané vazby
** HIDDEN **********************************************************************
METHOD VYR_PracVAZ_SCR:Vazby_PredOper()
  Local lOK := .T., lVazbyPredOper := .T., cKEYw
  Local cKEY := Upper( PracVAZ->cCisZakaz) + StrZERO( PracVAZ->nPocCeZapZ, 2)
  Local nRec := PracVaz->( RecNo()), cTag, aREC := {}

  * Zobrazit všechny vazby - vykázané i nevykázané
  IF ::nVazby_Show = 3
    RETURN .T.
  ENDIF

  cTag := PracVAZ->( AdsSetOrder( 2))
  PolOperZ->( mh_SetScope( cKEY) )

  DO WHILE !PolOperZ->( EOF()) //.AND. lVazbyPredOper
    IF PolOperZ->cOznPracN = ::cOznPrac_sel
       AADD( aREC, PolOperZ->( RecNO()) )
    ENDIF
    PolOperZ->( dbSkip())
  ENDDO
  PolOperZ->( mh_ClrScope())
  *
  IF LEN( aREC) = 0
    * pracovištì není následujícím pracovištìm žádného jiného pracovištì => zobrazit
    lOK := .T.
  ELSE
    FOR n := 1 TO LEN( aREC)
      PolOperZ->( dbGoTO( aREC[n]))
      PracVAZ->( dbSEEK( Upper( PolOperZ->cIdVazby)))
      lOK := IF( PracVAZ->lVykazano, lOK, .F. )
    NEXT
  ENDIF
  PracVAZ->( AdsSetOrder( cTag), dbGoTO( nRec))
  *
  lVazbyPredOper := IF( ::nVazby_Show = 1,  lOK,;
                    IF( ::nVazby_Show = 2, !lOK,;
                    IF( ::nVazby_Show = 3,   .T., .F. )))
*
RETURN lVazbyPredOper

********************************************************************************
*
********************************************************************************
CLASS VYR_PolOpVAZ_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, Destroy, drgDialogStart, EventHandled
  METHOD  CopyTEXT
HIDDEN
  VAR     dm, dc
ENDCLASS

*
********************************************************************************
METHOD VYR_PolOpVAZ_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('PolOperZ' )
  PolOperZ->( AdsSetOrder( 7), dbGoTOP() )
  *
  PracVaz->( dbGoTO( PRACVAZwp->_nrecOr ))
  *
  Filter := FORMAT("PolOperZ->cIdVazby = '%%'",{ PRACVAZwp->cIdVazby } )
  PolOperZ->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )
  *
RETURN self

*
********************************************************************************
METHOD VYR_PolOpVAZ_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
RETURN self

*
********************************************************************************
METHOD VYR_PolOpVAZ_SCR:eventHandled(nEvent, mp1, mp2, oXbp)
  Local X

  DO CASE
  CASE nEvent = drgEVENT_SAVE
    IF oXbp:ClassName() = 'xbpMLE'
*      drgMsgBox(drgNLS:msg('Ulozit ...'))
      IF PracVaz->( dbRLock())
        X := ::dm:get('PracVaz->mPopVazby')
        PracVaz->mPopVazby := X
*        ::dm:save()
        PracVAZ->( dbUnlock())
      ENDIF
      SetAppFocus( ::dc:oaBrowse:oXbp)
    ENDIF
  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_PolOpVAZ_SCR:CopyTEXT()
  Local aSel := ::dc:oaBrowse:arSelect
  Local n, cMemo := ''

  IF( LEN( aSel) = 0, AADD( aSel, PolOperZ->( RecNO())), NIL )
  *
  FOR n := 1 TO LEN( aSel)
    PolOperZ->( dbGoTO( aSel[n]))
    cMemo += PolOperZ->mPolOper + ' Množství : ' + Str( PolOperZ->nMnZadVK) + CRLF
  NEXT
  ::dm:set('PracVAZ->mPopVazby', cMemo)
  IF PracVAZ->( dbRLock())
    ::dm:save()
    cMemo := StrTran( cMemo, CRLF )
    PracVAZ->cPopVazby := IF( EMPTY( cMemo), cMemo, 'ANO' )
    PracVAZ->( dbUnLock())
  ENDIF

RETURN  self

********************************************************************************
METHOD VYR_PolOpVAZ_SCR:destroy()
  ::drgUsrClass:destroy()
  PolOperZ->( dbClearFILTER())
RETURN self

********************************************************************************
*
********************************************************************************
CLASS VYR_PredchVAZ_SCR FROM drgUsrClass
EXPORTED:
  VAR     cOznPrac_sel
  METHOD  Init, Destroy, drgDialogStart
  METHOD  Vazba_VYK

HIDDEN
  VAR     dm, dc
ENDCLASS

*
********************************************************************************
METHOD VYR_PredchVAZ_SCR:Init(parent)
  Local cCisZakaz, nPocCeZapZ
  ::drgUsrClass:init(parent)
  *
  ::cOznPrac_sel := drgParseSecond( parent:initParam, ',' )
  cCisZakaz      := PracVAZwp->cCisZakaz
  nPocCeZapZ     := PracVAZwp->nPocCeZapZ
*  drgDBMS:open('PolOperZ',,, TPV_DAT )
*  PolOperZ->( AdsSetOrder( 7), dbGoTOP() )
  *
*  Filter := FORMAT("PracVAZ->cOznPracN = '%%'",{ ::cOznPrac_sel } )
  Filter := FORMAT("PracVAZ->cOznPracN = '%%' .and. PracVAZ->cCisZakaz = '%%' .and. PracVAZwp->nPocCeZapZ = %%",;
                   { ::cOznPrac_sel, cCisZakaz, nPocCeZapZ } )
  PracVAZ->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )
  *
RETURN self

*
********************************************************************************
METHOD VYR_PredchVAZ_SCR:drgDialogStart(drgDialog)
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl

RETURN self

* Vykázat vazbu
********************************************************************************
METHOD VYR_PredchVAZ_SCR:Vazba_VYK()
  Local cMsg := IF( PRACVAZ->lVykazano, 'Požadujete zrušit vykázání vazby ',;
                                        'Požadujete vykázat vazbu ' )

  IF drgIsYESNO(drgNLS:msg( cMsg + '[ & ] ?', PracVAZ->cIdVazby) )
    IF PracVAZ->( RLock())
      PRACVAZ->lVykazano := !PRACVAZ->lVykazano
      PRACVAZ->dDatVykaz := IF( PRACVAZ->lVykazano, DATE(),CTOD( '  .  .  ') )
      PRACVAZ->lVykZPlan := PRACVAZ->lVykazano
      PracVAZ->( dbUnLock())
    ENDIF
    ::dc:oBrowse[1]:oXbp:refreshCurrent()
  ENDIF
RETURN

********************************************************************************
METHOD VYR_PredchVAZ_SCR:destroy()
  ::drgUsrClass:destroy()
  PracVAZ->( dbClearFILTER())
  ::cOznPrac_sel := NIL
RETURN self