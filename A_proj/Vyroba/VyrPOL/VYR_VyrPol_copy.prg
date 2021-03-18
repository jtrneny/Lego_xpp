/*==============================================================================
  VYR_VyrPol_copy.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
* VYR_VyrPOL_copy ... Kopie Z vyrábìné položky
********************************************************************************
CLASS VYR_VyrPOL_Copy FROM drgUsrClass

EXPORTED:
  VAR     cilZAK  , cilPOL  , cilVAR
  VAR     zdrojZAK, zdrojPOL, zdrojVAR, lKusov, lPolOper
  VAR     cNazev  , cVarPop , cCisVyk

  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled
  METHOD  checkItemSelected, PostValidate
  METHOD  But_Copy, VYR_VyrPOL_SEL

HIDDEN
  VAR     dm, msg

ENDCLASS

*
********************************************************************************
METHOD VYR_VyrPOL_Copy:init(parent)
  Local nRec

  ::drgUsrClass:init(parent)
  *
  VyrPOL->( dbGoTo( VAL( drgParse( parent:cargo))))
  ::zdrojZAK := VyrPOL->cCisZakaz
  ::zdrojPol := VyrPOL->cVyrPol
  ::zdrojVar := VyrPOL->nVarCis
  VyrPOL->( dbGoTo( VAL( drgParseSecond( parent:cargo))))
  ::cilZAK   := VyrPOL->cCisZakaz
  ::cilPol   := VyrPOL->cVyrPol
  ::cilVar   := VyrPOL->nVarCis
  /* Pøednastaveno pro KOVAR - do budoucna asi na cfg.parametr */
  ::lKusov   := .T.   //  kusovník kopírují VŽDY
  ::lPolOper := .F.   //  operace nekopírují NIKDY
RETURN self

*
********************************************************************************
METHOD VYR_VyrPOL_Copy:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

*
********************************************************************************
METHOD VYR_VyrPOL_Copy:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  ::dm:refresh()
RETURN self

*
***************/****************************************************************
METHOD VYR_VyrPol_Copy:destroy()
  ::drgUsrClass:destroy()
  *
  ::cNazev   := ::cVarPop  := ::cCisVyk  :=  ;
  ::cilZAK   := ::cilPOL   := ::cilVAR   :=  ;
  ::zdrojZAK := ::zdrojPOL := ::zdrojVAR :=  ;
  ::lKusov   := ::lPolOper := ;
  ::dm       := ;
                Nil
RETURN self

********************************************************************************
METHOD VYR_VyrPOL_Copy:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_FORMDRAWN
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

*/
*
********************************************************************************
METHOD VYR_VyrPOL_Copy:CheckItemSelected( CheckBox)
  Local name := drgParseSecond( CheckBox:oVar:Name,'>')

  self:&Name := CheckBox:Value
RETURN self


*
********************************************************************************
METHOD VYR_VyrPOL_Copy:PostValidate( oVar)
  LOCAL  xVar := oVar:get(), cName := oVar:Name, cKey
  LOCAL  lOK := .T., cTag

  Do Case
  Case cName = 'M->ZdrojPol'
    lOK := ::Vyr_VyrPol_sel( , cName)
    ::dm:refresh()

  Case cName = 'M->CilPol'
    lOK := ::Vyr_VyrPol_sel( , cName)
    ::dm:refresh()

    ::cNazev  := VyrPOL->cNazev
    ::cVarPop := VyrPOL->cVarPop
    ::cCisVyk := VyrPOL->cCisVyk
  EndCase


RETURN lOK

*
********************************************************************************
METHOD VYR_VyrPOL_Copy:But_Copy()
  Local cMsg := drgNLS:msg('MOMENT PROSÍM ...')

  ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
  *
  VYR_VyrPOL_cpy( ::drgDialog,;
                  ::zdrojZAK, ::zdrojPOL, ::zdrojVAR,;
                  ::cilZAK  , ::cilPOL  , ::cilVAR  ,;
                  ::lKusov  , ::lPolOper, .F. )
  *
  cMsg := drgNLS:msg( 'KOPÍROVÁNÍ ukonèeno ...' )
  ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
  *
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

RETURN NIL

* Výbìr vyrábìné polžky zdrojové , cílové
********************************************************************************
METHOD VYR_Vyrpol_Copy:VYR_VyrPOL_SEL( oDlg, cName)
  LOCAL oDialog, nExit, cKey
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  LOCAL Value := ::dm:get( cItem), nRec
  LOCAL nCopyVP :=  SysConfig('Vyroba:nCopyVP')
  LOCAL lOK  // := .F.  // := ( !Empty(value) .and. VyrPOL->( dbSEEK( Value,, 4)) )

  DO CASE
  CASE  nCopyVP = 1  // STD
    lOK := ( !Empty(value) .and. VyrPOL->( dbSEEK( Value,, 'VYRPOL4')) )

  CASE  nCopyVP = 2  // KOVAR
    * specifikum KOVAR ( asi na parametr)
    lOK := .F.
    cTag := VyrPol->( AdsSetOrder( 4))
    VyrPol->( mh_SetScope( Value))
    DO WHILE ! VyrPOL->( Eof())
     IF ! Empty( VyrPOL->cCisZakaz)
       IF cItem = 'M->zdrojPOL'
         ::zdrojZAK := ::dm:has('M->zdrojZAK'):value := VyrPOL->cCisZakaz
         ::zdrojVAR := ::dm:has('M->zdrojVAR'):value := VyrPOL->nVarCis
       ELSE
         ::cilZAK := ::dm:has('M->cilZAK'):value := VyrPOL->cCisZakaz
         ::cilVAR := ::dm:has('M->cilVAR'):value := VyrPOL->nVarCis
       ENDIF
       lOK := .T.
       nRec := VyrPOL->( RecNO())
       EXIT
     ENDIF
     VyrPOL->( dbSKIP())
    ENDDO
    VyrPol->( mh_ClrScope(), AdsSetOrder( cTag) )
    IF( lOK, VyrPOL->( dbGoTO(nRec)), NIL )
  ENDCASE
  *
  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF
  *
  IF ( nExit != drgEVENT_QUIT  .or. !lOK )
    lOK := .T.
    ::dm:set( cItem, VyrPOL->cVyrPOL )
    ::dm:save()
    IF cItem = 'M->zdrojPOL'
      ::zdrojZAK := ::dm:has('M->zdrojZAK'):value := VyrPOL->cCisZakaz
      ::zdrojPol := VyrPOL->cVyrPOL
      ::zdrojVAR := ::dm:has('M->zdrojVAR'):value := VyrPOL->nVarCis
    ELSE
      ::cilZAK := ::dm:has('M->cilZAK'):value := VyrPOL->cCisZakaz
      ::cilPol := VyrPOL->cVyrPOL
      ::cilVAR := ::dm:has('M->cilVAR'):value := VyrPOL->nVarCis
    ENDIF
    ::dm:refresh()
  ENDIF
RETURN lOK

*
*===============================================================================
FUNCTION VYR_VyrPOL_cpy( oDlg, zdrojZAK, zdrojPOL, zdrojVAR, cilZAK, cilPOL, cilVAR,;
                         lKusov, lPolOper, lQuery  )

  Local  anRecVyr := {}, anRecDT := {}, anRecKUS := {}, anRecPOLOP := {}, aV, aN
  Local  n, nPos, nVarPozSRC, nPozOrg, nVyrSt1 := 0
  Local  cTag, cTag2, cTag3, cScope, cKey, cZakPol, cVysPol, cNizPol, cVyrPol
  Local  lFound, lOK := YES, lVyrSt, lContinue, lCopyPodrizVP := .F.
  Local  nRecVYRPOL := VyrPOL->( RecNO())
  Local  nCopyVP :=  SysConfig('Vyroba:nCopyVP')

  DEFAULT lKusov TO .T., lPolOper TO .T., lQuery TO .T.

  IF EMPTY( zdrojPOL) .or. EMPTY( cilPOL)
    drgMsgBox(drgNLS:msg('NELZE KOPÍROVAT !;; nejsou zadány vyrábìné položky !'))
    RETURN NIL
  ENDIF

  drgDBMS:open('VYRPol'   ,,,,, 'VYRPolx')

  *
  DO CASE
  CASE  nCopyVP = 1  // STD
  CASE  nCopyVP = 2  // KOVAR
    * Jen na finálech je možno kopírovat podøízené položky specif. zpùsobem
    IF VyrPolx->( dbSeek( Upper( zdrojZAK + zdrojPOL),, 'VYRPOL1'))
      drgDBMS:open('C_TypPol' )
      IF C_TypPol->( dbSEEK( Upper( VyrPolx->cTypPOL),, 'TYPPOL1'))
        lCopyPodrizVP := C_TypPol->lFinal
      ENDIF
    ENDIF
    IF !lCopyPodrizVP
      IF ! drgIsYESNO(drgNLS:msg('Zdrojová položka není FINÁLEM;; Chcete pokraèovat ?') )
        RETURN NIL
      ENDIF
    ENDIF
  ENDCASE
  *
  drgDBMS:open('VYRZAK'   ,,,,, 'VYRZAKa' )
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPolDT' )
  drgDBMS:open('VYRPolDTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KUSOV'  ,,,,, 'kusovx'   )
  drgDBMS:open('KUSOVw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PolOPER'  ,,,,, 'PolOPERx')
  drgDBMS:open('PolOPERw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  KUSOVw->( dbZAP())
  VyrPOLw->( dbZAP())
  PolOPERw->( dbZAP())
  VYRPOLx->( AdsSetOrder('VYRPOL1'))

*  IF ::cZakPolSRC <> Upper( dmCisZakaz) +  Upper( dmVyrPOL)
  IF zdrojZAK + zdrojPOL <> cilZAK + cilPOL
*     lContinue := IF( lKusov, lKusov, drgIsYESNO(drgNLS:msg('Zkopírovat i rozpisku k vyrábìné položce ?') ))
     lContinue := IF( lKusov, lKusov,;
                  IF( lQuery, drgIsYESNO(drgNLS:msg('Zkopírovat i rozpisku k vyrábìné položce ?')), .F.))
     IF lContinue
*    IF drgIsYESNO(drgNLS:msg('Zkopírovat i rozpisku k vyrábìné položce ?') )

      ( cTag := kusovx->( AdsSetOrder( 1)), cTag2 := PolOperx->( AdsSetOrder( 'POLOPER1')) )
      nVarPozSRC := cilVAR     // ::dm:get('VyrPOLw->nVarCis')
      ( aV := {}, aN := {} )
      aAdd( aV, zdrojZAK + zdrojPOL )
      lVyrSt1 := YES  // Indikuje položky na 1. výr.stupni, tj. nejbližší nižší
                      //  pro vrcholovou položku
      Do While lOK
        For n := 1 To Len( aV)
          kusovx->( mh_SetSCOPE( Upper( aV[n])))
          Do While !kusovx->( Eof())
             nPozOrg := kusovx->nPozice

             Do While nPozOrg == kusovx->nPozice .and. !kusovx->( Eof())

               cKey := kusovx->cCisZakaz + kusovx->cNizPol + StrZero( kusovx->nNizVar,3)

               If kusovx->nVarPoz == nVarPozSRC
                  * Do kusovníku jsou pøebrány jen vazby s variantou pozice == variantì
                  *  vrcholového výrobku
                  aAdd( aN      , kusovx->cCisZakaz + kusovx->cNizPol )
                  aAdd( anRecKUS, kusovx->( RecNo()) )
                  mh_CopyFLD( 'kusovx', 'kusovw', .T. )
                  nVyrSt1 += IF( lVyrSt1, 1, 0)
                  // Vybere vyr.položku s daným klíèem pouze jednou
                  If VyrPolx->( dbSeek( Upper( cKey),,'VYRPOL1'))
                     If( nPos := aScan( anRecVYR, VyrPolx->( RecNo())) <> 0, NIL,;
                        aAdd( anRecVYR, VyrPolx->( RecNo()) ) )
                     If VyrPolDT->( dbSeek( Upper( cKey)))
                        If( nPos := aScan( anRecDT, VyrPolDT->( RecNo())) <> 0, NIL,;
                           aAdd( anRecDT, VyrPolDT->( RecNo()) ) )
                     Endif
                  Endif
               EndIf

               If kusovx->nVarPoz == 1 .and. nVarPozSRC <> 1
                  aAdd( aN      , kusovx->cCisZakaz + kusovx->cNizPol )
                  aAdd( anRecKUS, kusovx->( RecNo()) )
                  mh_CopyFLD( 'kusovx', 'kusovw', .T. )
                  nVyrSt1 += IF( n == 1, 1, 0)

                  // Vybere vyr.položku s daným klíèem pouze jednou
                  If VyrPolx->( dbSeek( Upper( cKey),,'VYRPOL1'))
                     If( nPos := aScan( anRecVYR, VyrPolx->( RecNo())) <> 0, NIL,;
                        aAdd( anRecVYR, VyrPolx->( RecNo()) ) )
                     If VyrPolDT->( dbSeek( Upper( cKey)))
                        If( nPos := aScan( anRecDT, VyrPolDT->( RecNo())) <> 0, NIL,;
                           aAdd( anRecDT, VyrPolDT->( RecNo()) ) )
                     Endif
                  Endif
               EndIF
               *
               kusovx->( dbSkip())
             EndDo
          EndDo
          kusovx->( mh_ClrScope())
        Next
        ( aV := aN, aN := {}, lVyrSt1 := NO )
        lOK := ( Len( aV) <> 0 )
      EndDo

      * Zápis do KUSOV s kontrolou duplicity !
      kusovw->( dbGoTOP())
      FOR n := 1 To Len( anRecKUS)
         kusovw->( dbGoTO( n))
         cVysPol := IF( n <= nVyrSt1, cilPOL , kusovw->cVysPOL )
         cNizPol := kusovw->cNizPOL
         IF     nCopyVP = 1     // STD
         ELSEIF nCopyVP = 2     // KOVAR
           IF lCopyPodrizVP
             cVysPol := IF( n <= nVyrSt1, cVysPol, PADR( AllTrim( cilZAK) + RIGHT( AllTrim( cVysPOL), 3), LEN( EMPTY_VYRPOL)))
             cNizPol := IF( n <= nVyrSt1 .and. !EMPTY( kusovw->cNizPOL),;
                            PADR( AllTrim( cilZAK) + RIGHT( AllTrim( kusovw->cNizPOL), 3), LEN( EMPTY_VYRPOL)),;
                            kusovw->cNizPOL )
           ENDIF
         ENDIF
         cKEY := Upper( cilZAK) + Upper( cVysPOL) + ;
                 StrZERO( kusovw->nPozice, 3) + StrZERO( kusovw->nVarPoz, 3)
         IF !kusovx->( dbSeek( cKey))
           **
           mh_CopyFLD( 'kusovw', 'kusovx', .T. )
           kusovx->cCisZakaz  := cilZAK
           kusovx->cVysPol    := cVysPol
           kusovx->cNizPol    := cNizPol
           kusovx->cCislObINT := SPACE( 30)
           kusovx->nCislPolOB := 0
           kusovx->dZapis     := Date()
           **
           kusovx->( dbUnlock())
         ENDIF
         kusovx->( AdsSetOrder( cTag3))
      NEXT

      ** Vícenásobný zápis do VyrPol
      aEval( anRecVYR, { |N| VyrPolx->( dbGoTo( N))               ,;
                             mh_CopyFLD( 'VyrPOLx', 'VyrPOLw', .T. )})

      FOR n := 1 To Len( anRecVYR)
        VyrPOLw->( dbGoTO( n))
        *
        cVyrPol := VyrPOLw->cVyrPol
        IF     nCopyVP = 1     // STD
        ELSEIF nCopyVP = 2     // KOVAR
          IF lCopyPodrizVP
            cVyrPol := PADR( AllTrim( cilZAK) + RIGHT( AllTrim( VyrPOLw->cVyrPol), 3), LEN( EMPTY_VYRPOL))
          ENDIF
        ENDIF
        *
        cKEY := cilZAK + cVyrPol + StrZERO( VyrPOLw->nVarCis, 3 )
         ** Kontrola na duplicitu
         If !VyrPolx->( dbSeek( Upper( cKey),,'VYRPOL1'))
            **
            mh_CopyFLD( 'VyrPOLw', 'VyrPOLx', .T. )
            VyrPolx->cCisZakaz := cilZAK
            VyrPolx->cVyrPol   := cVyrPol
            VyrPolx->nZakazVP  := VYR_ZakazVP( VyrPolx->cCisZakaz)
            * KOVAR - do podsestav nakopirovat z cílové položky cNazev, cVarPop, cCisVyk
            IF .not. IsNull( oDlg)
               VyrPolx->cNazev    := oDlg:UDCP:cNazev
               VyrPolx->cVarPop   := oDlg:UDCP:cVarPop
               VyrPolx->cCisVyk   := oDlg:UDCP:cCisVyk
            ENDIF
            **
            ** Zaeviduje techn.postupy zdrojového výrobku
// JS
            PolOPERx->( mh_SetSCOPE( Upper( VyrPOLw->cCisZakaz) + Upper( VyrPOLw->cVyrPOL) ))
//            PolOPERx->( mh_SetSCOPE( Upper( zdrojZak) + Upper( zdrojPol) ))      // úprava JT 25.08.2016

            PolOperx->( dbEVAL({ || AADD( anRecPOLOP, PolOPERx->( RecNO()) )   ,;
                                    mh_CopyFLD( 'PolOPERx', 'PolOPERw', .T. ) }))
            PolOperx->( mh_ClrScope())
            *
            VyrPolx->( dbUnlock())
         Endif
      NEXT

      ** Vícenásobný zápis do VyrPolDT
      aEval( anRecDT, { |N| VyrPolDT->( dbGoTo( N))               ,;
                            mh_CopyFLD( 'VyrPolDT', 'VyrPolDTw', .T. )})
      FOR n := 1 To Len( anRecDT)
        VyrPolDTw->( dbGoTO( n))
        *
        cVyrPol := VyrPOLDTw->cVyrPol
        IF     nCopyVP = 1     // STD
        ELSEIF nCopyVP = 2     // KOVAR
          IF lCopyPodrizVP
            cVyrPol := PADR( AllTrim( cilZAK) + RIGHT( AllTrim( VyrPOLDTw->cVyrPol), 3), LEN( EMPTY_VYRPOL))
          ENDIF
        ENDIF
        *
        cKEY := cilZAK + cVyrPol + StrZERO( VyrPolDTw->nVarCis, 3 )
         * Kontrola na duplicitu
         If !VyrPolDT->( dbSeek( Upper( cKey),,'VYRPOL1'))
            **
            mh_CopyFLD( 'VyrPolDTw', 'VyrPolDT', .T. )
            VyrPolDT->cCisZakaz := cilZAK
            VyrPolDT->cVyrPol   := cVyrPol
            **
            VyrPolDT->( dbUnlock())
         Endif
      NEXT
      kusovx->( mh_ClrSCOPE(), AdsSetOrder( cTag), dbGoTop() )
    Endif
    *
    ** Kopie technologických postupù k vyr. položkám
    lContinue := IF( lPolOper, lPolOper,;
                 IF( lQuery  , drgIsYESNO(drgNLS:msg('Zkopírovat i technologické postupy k vyrábìné položce ?')), .F.))
    IF lContinue
*    IF drgIsYESNO(drgNLS:msg('Zkopírovat i technologické postupy k vyrábìné položce ?') )

// upravené kopírování operací JT 1.9.2016

      cKey :=   if( empty(zdrojZAK), zdrojZAK + zdrojPOL, zdrojZAK)
      PolOPERx->( mh_SetSCOPE( cKey ))
       PolOperx->( dbEval( {|| mh_CopyFLD( 'PolOPERx', 'PolOPERw', .T. ) }))
      PolOPERx->( mh_ClrSCOPE())

      PolOPERw->( dbGoTOP())
      do while .not.PolOPERw->( Eof())
        PolOPERw->cCisZakaz  := cilZak
        PolOPERw->cCisZakazI := cilZak   // tvrdost

        if cilPol <> zdrojPOL
          PolOPERw->cVyrPol    := cilPol
        endif

        PolOPERw->nRokVytvor := 0
        PolOPERw->nPorCisLis := 0
        PolOPERw->nPocCeZapZ := 0
        PolOPERw->nMnZadVK   := 0

        if     nCopyVP = 1     // STD
        elseif nCopyVP = 2     // KOVAR      ??????????
          if lCopyPodrizVP
            cVyrPol := PADR( AllTrim( cilZAK) + ;
                             if( PolOPERw->cCisZakaz = PolOPERw->cVyrPol, '', RIGHT( AllTrim( PolOPERw->cVyrPol), 3)), LEN( EMPTY_VYRPOL))
          endif
        endif

        ckey := Upper(PolOPERw->cCisZakaz) + Upper(PolOPERw->cVyrPol) + StrZERO( PolOPERw->nCisOper, 4) + ;
                   StrZERO( PolOPERw->nUkonOper, 2) + StrZERO( PolOPERw->nVarOper, 3)

        if PolOPERx->( dbSeek( Upper( cKey),, 'POLOPER1') )
           * U cílové položky již operace s daným klíèem existuje ->nekopírovat
        else
           **
          mh_CopyFLD( 'PolOPERw', 'PolOPERx', .T. )
          VYR_POLOPER_fill( PolOperx->cCisZakaz, 'PolOperx')  //*  15.8.2007
           **
          PolOPERx->( dbUnlock())
        EndIf

        PolOPERw ->( dbSkip())
      enddo
    ENDIF
    PolOperx->( AdsSetOrder( cTag2), dbGoTop())


/*
       PolOPERx->( mh_SetSCOPE( zdrojZAK + zdrojPOL ))
         PolOperx->( dbEval( {|| aAdd( anRecPOLOP, PolOperx->( RecNO()) )  ,;
                                mh_CopyFLD( 'PolOPERx', 'PolOPERw', .T. ) }))
*                                PolOPERw->cVyrPOL := cilPOL }))
       PolOPERx->( mh_ClrSCOPE())

       FOR n := 1 To Len( anRecPOLOP)
         PolOPERw->( dbGoTO( n))
         *
//         cVyrPol := cilPOL  // PolOPERw->cVyrPol
         cVyrPol := PolOPERw->cVyrPol     // JT 22.03.2016
         IF     nCopyVP = 1     // STD
         ELSEIF nCopyVP = 2     // KOVAR
           IF lCopyPodrizVP
             cVyrPol := PADR( AllTrim( cilZAK) + ;
                              if( PolOPERw->cCisZakaz = PolOPERw->cVyrPol, '', RIGHT( AllTrim( PolOPERw->cVyrPol), 3)), LEN( EMPTY_VYRPOL))
           ENDIF
         ENDIF
         *
         cKEY := cilZAK + cVyrPOL + StrZERO( PolOPERw->nCisOper, 4) + ;
                 StrZERO( PolOPERw->nUkonOper, 2) + StrZERO( PolOPERw->nVarOper, 3)

         IF PolOPERx->( dbSeek( Upper( cKey),, 'POLOPER1') )
           * U cílové položky již operace s daným klíèem existuje ->nekopírovat
         Else
           **
           mh_CopyFLD( 'PolOPERw', 'PolOPERx', .T. )
           PolOperx->cCisZakaz  := cilZAK
           PolOperx->cCisZakazI := cilZAK         // pozor toto je tvrdost
           PolOperx->cVyrPol    := cVyrPol
           PolOPERx->nRokVytvor := 0
           PolOPERx->nPorCisLis := 0
           PolOPERx->nPocCeZapZ := 0
           PolOPERx->nMnZadVK   := 0
           VYR_POLOPER_fill( PolOperx->cCisZakaz, 'PolOperx')  //*  15.8.2007
           **
           PolOPERx->( dbUnlock())
         EndIf
       NEXT
    ENDIF
    PolOperx->( AdsSetOrder( cTag2), dbGoTop())
//    VyrPOLx->( dbGoTO( nRecVYRPOL))
*/
    * 15.8.2007
    cKey := cilZAK + cilPOL + StrZero( CilVar, 3)
    IF VyrZAKa->( dbSEEK( cKey,, 'VYRZAK1'))
      nMnozPlano := VyrZAKa->nMnozPlano
      IF nMnozPlano > 1
        VyrPOLw->( dbZAP())
        IF VyrPolx->( dbSeek( Upper( zdrojZAK + zdrojPOL),, 'VYRPOL1'))
          FOR x := 1 TO nMnozPlano
            mh_CopyFLD( 'VyrPOLx', 'VyrPOLw', .T. )
            VyrPOLw->nVarCis   := x
            VyrPOLw->cCisZakaz := cilZAK
            VyrPOLw->cVyrPOL   := cilPOL
   *         cKey := cilZAK + cilPOL + StrZero( x, 3)
          NEXT
          *
          VyrPOLw->( dbGoTOP())
          DO WHILE ! VyrPOLw->( EOF())
            cKey := Upper( VyrPOLw->cCisZakaz) + Upper( VyrPOLw->cVyrPOL) + ;
                    StrZERO( VyrPOLw->nVarCIS, 3)
            IF !VyrPOLx->( dbSEEK( cKEY,, 'VYRPOL1'))
              mh_CopyFLD( 'VyrPOLw', 'VyrPOLx', .T. )
            ENDIF
            VyrPOLw->( dbSKIP())
          ENDDO
        ENDIF
      ENDIF
    ENDIF
    *
    cKey := Upper(cilZAK) + Upper(cilPOL) + StrZero( CilVar, 3)
    VyrPOLx->( dbSEEK( cKey,, 'VYRPOL1'))
  ENDIF

RETURN NIL