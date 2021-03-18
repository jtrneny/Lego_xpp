/*==============================================================================
  VYR_Kusov_CRD.PRG
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"

STATIC  cPOL

#define  FrmKUSOV_STD          0
#define  FrmKUSOV_1            1    // varianta Hydrap
#define  FrmKUSOV_2            2    // zatím nepoužito

********************************************************************************
*
********************************************************************************
CLASS VYR_Kusov_CRD FROM drgUsrClass
EXPORTED:
  VAR     cCisZakaz, cVyrPOL, cNazev, nVarCis, cVarPop
  VAR     cZakNizPol, cNazNizPol, cNizVarPop
  VAR     lNewREC
  VAR     nVarRoot                // generovaná varianta kusovníku
  var     nmnozDzbo               // dispozièní skladové množství kustree.nmnozDzbo

*  VAR     nSpMnoSKL              // spotøební mn. ve skladové  MJ
  VAR     nSpMnSklHR              // HRUBÉ spotøební mn. ve skladové  MJ
  VAR     nSpMnSklCI              // ÈISTÉ spotøební mn. ve skladové  MJ
  VAR     lVypCiMno              // checkBox pro výpoèet èisté hmotn.
  VAR     fromNABvys             // voláno z nabídek vystavených
  VAR     frm_KUSOV              // formuláø pro KUSOV
  VAR     nVarFrmKUSOV           // varianta formuláøe pro KUSOV

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  VYR_VYRPOL_se_SEL,  VYR_NAKPOL_SEL, Jednot_sel, C_Sklad
  METHOD  ComboItemSelected, CheckItemSelected

HIDDEN:
  VAR   dm, cGroup, members
  VAR   nRecNO

  METHOD  showGroup
  METHOD  KusControl
ENDCLASS

********************************************************************************
*
********************************************************************************
METHOD VYR_Kusov_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC    := !( parent:cargo = drgEVENT_EDIT)
  *
  ::fromNABvys := lower( parent:parent:parent:formname) $ 'pro_nabvyshd_in, pro_nabvyshd_cen_sel'
  ::frm_Kusov  := parent:drgDialog
  ::frm_Kusov:formname := if( ::fromNABvys, 'VYR_KUSOV_CRD_1', 'VYR_KUSOV_CRD')
  ::nVarFrmKUSOV := VAL( Right( ::frm_Kusov:formname, 1))
  *
  ::cNazNizPol := ''
  ::cNizVarPop := ''   // popis nižší varianty - mateøský celek ( ELSVIT)
  ::cGroup     := IF( ::lNewRec, 'cVyrPOL', 'cSklPOL' )
  cPol         := IsNull( cPol, ::cGroup)
  ::cCisZakaz  := KusTree->cCisZakaz
  ::cZakNizPol := KusTree->cCisZakaz  // zakázka nižší položky
  * Vyšší položka INFO
  ::cVyrPol    := If( ::lNewRec, KusTree->cVyrPol, KusTree->cVysPol   )
  ::cNazev     := If( ::lNewRec, KusTree->cNazev , KusTree->cNazevVys )
  ::nVarCis    := If( ::lNewRec, KusTree->nVarCis, KusTree->nVysVar   )
  ::cVarPop    := If( ::lNewRec, KusTree->cVarPop, KusTree->cVysVarPop)
  *
  ::nVarRoot   := GetVarPos()
  ::nSpMnSklHR := 0
  ::nSpMnSklCI := 0
  ::nRecNO     := VyrPOL->( RecNO())

  ::lvypCImno  := .f.

  drgDBMS:open('Kusov'   )
  drgDBMS:open('vyrPol',,,,,'vyrPol_se')

  drgDBMS:open('kusovWe'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  drgDBMS:open('KUSOVw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPOLDTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('POLOPERw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CenZBOZ'  )
  drgDBMS:open('C_MatPOL' )

  VYR_KUSOV_edit( self)

  if ::lnewRec
    kusovWe->ccisZakaz := kusTree->cCisZakaz
    kusovWe->cvysPol   := kusTree->cvyrPol
    kusovWe->cmjTpv    := 'ks'
    kusovWe->cmjSpo    := 'ks'
  endif

  *
  IF !::lNewREC
    IF KusTREE->lNakPol
      NakPol->( dbSeek( Upper(KusTree->cSklPol),,'NAKPOL1'))
      ::cNazNizPol :=  NakPOL->cNazTpv
    ELSE
      VYRPOL_se->(dbSEEK( Upper(::cCisZakaz) +Upper(KusTree->cVyrPol),, 'VYRPOL1'))
*      VYRPOL->(dbSEEK( Upper(KusTree->cVyrPol),, 'VYRPOL4'))
      ::cNazNizPol := VyrPOL_se->cNazev
      ::cNizVarPop := VyrPOL_se->cVarPop
    ENDIF
  ENDIF
  *
RETURN self

********************************************************************************
METHOD VYR_Kusov_CRD:drgDialogStart(drgDialog)

  ::dm      := ::drgDialog:dataManager
  ::members := drgDialog:oForm:aMembers
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  IF ::lNewREC
    ::drgDialog:oForm:setNextFocus('KusTree->lNakPOL')
    * pøednastavuje poslední zadání lNakPol
    ::dm:has('KusTREE->lNakPOL'):value := ( cPol = 'cSklPol' )
    ::cGroup := cPol
  ELSE
    ::comboItemSelected( ::dm:has('KusTREE->lNakPOL'):oDrg ,,::dm:has('KusTREE->lNakPOL'):oDrg:oXbp )
    IsEditGET( { 'KusTREE->lNakPOL'}, drgDialog, .F. )
    ::dm:set( 'M->nmnozDzbo' , kustree->nmnozDzbo )
**
    ::dm:set( 'M->nSpMnSklHR', KUSOVwe->nSpMnSklHR)
    ::dm:set( 'M->nSpMnSklCI', KUSOVwe->nSpMnSklCI)
  ENDIF

  if ::nVarFrmKUSOV = FrmKUSOV_STD
    ::CheckItemSelected( ::dm:has('M->lVypCiMno'):oDrg )
  elseif ::nVarFrmKUSOV = FrmKUSOV_1
    IsEditGET( { 'KUSOVwe->cSklOdp_1', 'KUSOVwe->cSklOdp_2','M->nSpMnSklHR',;
                 'KUSOVwe->cNazOdp_1', 'KUSOVwe->cNazOdp_2', 'KUSOVwe->nVahaMJ'}, drgDialog, .F. )
  endif
  ::showGroup()

  ::dm:refresh()

  kusovWe->(dbcommit())
RETURN self

********************************************************************************
METHOD VYR_Kusov_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    VYR_KUSOV_save( self)
    PostAppEvent(xbeP_Close, nEvent,,oXbp)

  * Ukonèit bez uložení
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukonèit bez uložení
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_Kusov_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  dc := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager
  LOCAL  cName := oVar:name, cFILe := drgParse(cNAMe,'-'), cKey, cTag
  LOCAL  nA, nB, nKR, nNP, nDivide, nMn
  LOCAL  nextFOCUS, nTypVar
  Local nEvent := mp1 := mp2 := nil

  nEvent := LastAppEvent(@mp1,@mp2)

  NAKPOL->(dbSEEK( Upper( ::dm:get('KUSOVwe->cSklPol')),, 'NAKPOL1'))

  DO CASE
  CASE cName = 'KUSOVwe->cNizPol' .and. ::cGroup = 'cVyrPol'
    If Empty( xVar ) .or. lValid
       lKeyFound := VYRPOL_se->(dbSEEK( Upper( ::cZakNizPol) + Upper(xVar),, 'VYRPOL1'))
       IF lOK := ::VYR_VYRPOL_se_SEL( self, lKeyFound )
         lOK := ::KusControl( xVar )
       ENDIF
    EndIf
    IF( lOK, ::drgDialog:oForm:setNextFocus('KUSOVwe->nVarPoz',, .T. ), NIL )

  CASE cName = 'KUSOVwe->cSklPol' .and. ::cGroup = 'cSklPol'
    If Empty( xVar ) .or. lValid
      lKeyFound := NAKPOL->(dbSEEK( Upper(xVar),, 'NAKPOL1'))
      IF lOK := ::VYR_NAKPOL_SEL()
        lOK := ::KusControl( ::dm:get('KUSOVwe->cSklPol'), .t.,  ::dm:get('KUSOVwe->nVarPoz'))
      ENDIF
    ENDIF
    IF( lOK, ::drgDialog:oForm:setNextFocus('KUSOVwe->nVarPoz',, .T. ), NIL )         // nìjaký problém s pozicováním JT 02.09.2016
                                                                                       // musel jsem øádek za removat

  CASE cName = 'KUSOVwe->nPozice'
    If lValid .and. ( xVar <= 0)
      drgMsgBox(drgNLS:msg('Pozice : ... údaj musí být kladný !'),, ::drgDialog:dialog)
      lOK := NO
    EndIf


  CASE cName = 'KUSOVwe->nVarPoz'   // ... Varianta pozice
    If lValid .and. ( xVar > 0)
      * 22.7.2010
      nTypVar := SysConfig( 'Vyroba:nTypVar')
      nTypVar := If( IsArray( nTypVar), 1, nTypVar )

      cKey := Upper( ::cCisZakaz) + Upper( ::cVyrPol) + StrZero( ::dm:get('KUSOVwe->nPozice'), 3)
      nRec := Kusov->( RecNo())
      If lOK := Kusov->( dbSeek( cKey + StrZero( xVar, 3) ))
        drgMsgBox(drgNLS:msg('Duplicitní èíslo varianty pozice !'),, ::drgDialog:dialog)
        lOK := FALSE
      Else
        If Empty( ::dm:get('KUSOVwe->cNizPol'))
          lOK := TRUE
        Else
          cKey := Upper( ::cZakNizPol) + Upper( ::dm:get('KUSOVwe->cNizPol'))
          If !( lOK := VyrPol_se->( dbSeek( cKey + StrZero( xVar, 3),, 'VYRPOL1' )))
            IF nTypVar = 1
              If !( lOK := VyrPol_se->( dbSeek( cKey + '001',, 'VYRPOL1' )))
                drgMsgBox(drgNLS:msg(;
                'Nexistuje ani varianta < & > , ani základní varianta 001  !', xVar ),, ::drgDialog:dialog)
              EndIf
            ELSEIF nTypVar = 2
            ENDIF
          Endif
        Endif
      EndIf
      Kusov->( dbGoTo( nRec))
    ELSEIF xVar = 0
      drgMsgBox(drgNLS:msg('Varianta pozice ... údaj musí být kladný !'),, ::drgDialog:dialog)
      lOK := NO
    Endif

  CASE cName = 'KUSOVwe->nCiMno'  // množství èisté  (Èistá délka dílce)
    IF ::nVarFrmKUSOV = FrmKUSOV_STD
      If ::lNewRec .and. xVar >= ::dm:get('KUSOVwe->nSpMno')
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjTpv'), ::dm:get('KUSOVwe->cMjSpo'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nSpMno', nMn)
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjTpv'), NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
      ENDIF
      If( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or. mp1 = xbeK_DOWN ))
        nextFOCUS := IF( ::lVypCiMno, 'KUSOVwe->nRozmA' , 'KUSOVwe->cMjTpv' )
        ::drgDialog:oForm:setNextFocus( nextFOCUS,, .T. )
      Endif

    ELSEIF ::nVarFrmKUSOV = FrmKUSOV_1
      If ::lNewRec .and. xVar >= ::dm:get('KUSOVwe->nSpMno')
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjTpv'), ::dm:get('KUSOVwe->cMjSpo'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nSpMno', nMn + ::dm:get('KUSOVwe->nPridUp') )
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjTpv'), NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn + ::dm:get('KUSOVwe->nPridUp'))
      ENDIF
      If( nEvent = xbeP_Keyboard .and.( mp1 = xbeK_RETURN .or. mp1 = xbeK_DOWN ))
        nextFOCUS := IF( ::lVypCiMno, 'KUSOVwe->nRozmA' , 'KUSOVwe->cMjTpv' )
        ::drgDialog:oForm:setNextFocus( nextFOCUS,, .T. )
      Endif

    ENDIF

  CASE cName = 'KUSOVwe->cMjTpv'  // MJ pro TPV
    IF lValid
      *
      IF lOK := ControlDUE( oVar)
        IF lChanged
          lOK := ::JEDNOT_SEL(, cName)
        ENDIF
      ENDIF
      *
      IF ::nVarFrmKUSOV = FrmKUSOV_STD
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nCiMno'), xVar, ::dm:get('KUSOVwe->cMjSpo'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nSpMno', nMn)
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nCiMno'), xVar, NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
      ELSEIF ::nVarFrmKUSOV = FrmKUSOV_1
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nCiMno'), xVar, ::dm:get('KUSOVwe->cMjSpo'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nSpMno', nMn + ::dm:get('KUSOVwe->nPridUp'))
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), xVar, NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->', nMn )  //+ ::dm:get('KUSOVwe->nPridUp'))

      ENDIF
    ENDIF

  CASE cName = 'KUSOVwe->nSpMno'  // množství spotøební  (Délka polotovaru)

    IF lValid
      IF ::nVarFrmKUSOV = FrmKUSOV_STD
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjSpo'), NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
        *new
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjSpo'), ::dm:get('KUSOVwe->cMjTPV'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nCiMno', nMn)
      ELSEIF ::nVarFrmKUSOV = FrmKUSOV_1
        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjSpo'), NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
        *new
*        nMn := PrepocetMJ( xVar, ::dm:get('KUSOVwe->cMjSpo'), ::dm:get('KUSOVwe->cMjTPV'), 'NAKPOL' )
*        ::dm:set( 'KUSOVwe->nCiMno', nMn)

      ENDIF
      *
    ENDIF

  CASE cName = 'KUSOVwe->cMjSpo'  // MJ spotøební
    IF lValid
      *
      IF lOK := ControlDUE( oVar)
        IF lChanged
          lOK := ::JEDNOT_SEL(, cName)
        ENDIF
      ENDIF
      *
      IF ::nVarFrmKUSOV = FrmKUSOV_STD
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), xVar, NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
        * new
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), xVar, ::dm:get('KUSOVwe->cMjTPV'), 'NAKPOL' )
        ::dm:set( 'KUSOVwe->nCiMno', nMn)
      ELSEIF ::nVarFrmKUSOV = FrmKUSOV_1
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), xVar, NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)
        * new
*        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), xVar, ::dm:get('KUSOVwe->cMjTPV'), 'NAKPOL' )
*        ::dm:set( 'KUSOVwe->nCiMno', nMn)
      ENDIF

    ENDIF

  CASE cName = 'KUSOVwe->nRozmA'  .or. cName = 'KUSOVwe->nRozmB'   .or. ;
       cName = 'KUSOVwe->nKusRoz' .or. cName = 'KUSOVwe->nNavysPrc'.or. ;
       cName = 'KUSOVwe->nVahaMJ' .or. cName = 'KUSOVwe->nPridUp'

    IF ::nVarFrmKUSOV = FrmKUSOV_STD
      IF lChanged
        nA  := ::dm:get('KUSOVwe->nRozmA')
        nB  := ::dm:get('KUSOVwe->nRozmB')
        nKR := ::dm:get('KUSOVwe->nKusRoz')
        nNP := ::dm:get('KUSOVwe->nNavysPrc')
        nB  := IF( nB = 0, 1, nB)
        nDivide := IF( nB = 0 .or. nB = 1, 1000, 1000000 )

        IF cName = 'KUSOVwe->nRozmA'
           xVar := IF( xVar == 0, 1, xVar )
           ::dm:set('KUSOVwe->nCiMno', ( xVar * nB * nKR) / nDivide )
           ::dm:set('KUSOVwe->nSpMno', ( ( xVar * nB * nKR ) * ( 1 + nNP/ 100 ) / nDivide )  )
        ELSEIF cName = 'KUSOVwe->nRozmB'
           xVar := IF( xVar == 0, 1, xVar )
           ::dm:set('KUSOVwe->nCiMno', ( nA * xVar * nKR) / nDivide )
           ::dm:set('KUSOVwe->nSpMno', ( ( nA * xVar * nKR ) * ( 1 + nNP/ 100 ) / nDivide ) )
        ELSEIF cName = 'KUSOVwe->nKusRoz'
           xVar := IF( xVar == 0, 1, xVar )
           ::dm:set('KUSOVwe->nCiMno', ( nA * nB * xVar) / nDivide )
           ::dm:set('KUSOVwe->nSpMno', ( ( nA * nB * xVar ) * ( 1 + nNP/ 100 ) / nDivide ) )
        ELSEIF cName = 'KUSOVwe->nNavysPrc'
           ::dm:set('KUSOVwe->nSpMno', ( ( nA * nB * nKR ) * ( 1 + xVar/ 100 ) / nDivide ) )
        ENDIF
        ::dm:set( 'M->nSpMnSklHR', ::dm:get('KUSOVwe->nSpMno') * NakPol->nKoefPrep)
      ENDIF
    ENDIF
    *----- Hydrap
    IF ::nVarFrmKUSOV = FrmKUSOV_1
*      IF lChanged
        IF cName = 'KUSOVwe->nRozmB' // délka dílce
          ::dm:set('KUSOVwe->nCiMno', xVar ) // + ::dm:get('KUSOVwe->nPridUp') ) * ::dm:get('KUSOVwe->nVahaMJ') ))
          ::dm:set('KUSOVwe->nSpMno', xVar + ::dm:get('KUSOVwe->nPridUp') )
        ELSEIF cName = 'KUSOVwe->nPridUp' // pøídavek na upnutí, úchyt
          ::dm:set('KUSOVwe->nSpMno', ( xVar + ::dm:get('KUSOVwe->nRozmB') ))
        ENDIF
        nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), ::dm:get('KUSOVwe->cMjSpo'), NAKPOL->cZkratJedn , 'NAKPOL' )
        ::dm:set( 'M->nSpMnSklHR', nMn)

        *
*        ::dm:set('KUSOVwe->nCiMno', ( ::dm:get('KUSOVwe->nSpMno') - ::dm:get('KUSOVwe->nMnozOdp_1') - ::dm:get('KUSOVwe->nMnozOdp_2') ))
*      ENDIF
    ENDIF
  /*
  CASE cName = 'KUSOVwe->nCiMnoVyk'  // množství èisté z výkresu
      if xVar > 0
        ::dm:set('KUSOVwe->nMnozOdp_1', ( ::dm:get( 'M->nSpMnSklHR') - xVar  ))
        ::dm:set('KUSOVwe->nProcOdp_1', (( ::dm:get( 'M->nSpMnSklHR') - xVar  ) / ( ::dm:get('KUSOVwe->nSpMno') /100 )))
      endif
  */
  CASE cName = 'M->nSpMnSklCI'  // Spotø. mn. skladové èisté  (Èistá hmotnost dílce)
      if xVar > 0
        ::dm:set('KUSOVwe->nMnozOdp_1', ( ::dm:get( 'M->nSpMnSklHR') - xVar  ))
        ::dm:set('KUSOVwe->nProcOdp_1', (( ::dm:get( 'M->nSpMnSklHR') - xVar  ) / ( ::dm:get('M->nSpMnSklHR') /100 )))
      endif

  CASE cName = 'KUSOVwe->cPolOdp_1' .or. cName = 'KUSOVwe->cPolOdp_2'
    * procento a mn. odpadu je editovatelné, je-li vyplnìna skl.položka
    if cName = 'KUSOVwe->cPolOdp_1'
      IsEditGET( { 'KUSOVwe->nProcOdp_1', 'KUSOVwe->nMnozOdp_1' }, ::drgDialog, !empty(xVar) )
    endif
    if cName = 'KUSOVwe->cPolOdp_2'
      IsEditGET( { 'KUSOVwe->nProcOdp_2', 'KUSOVwe->nMnozOdp_2' }, ::drgDialog, !empty(xVar) )
    endif
    *
    lOK := if( empty( xVar), lOk, ::VYR_NakPol_sel() )

  CASE cName = 'KUSOVwe->nProcOdp_1' .or. cName = 'KUSOVwe->nMnozOdp_1' .or. ;
       cName = 'KUSOVwe->nProcOdp_2' .or. cName = 'KUSOVwe->nMnozOdp_2'


    nMn := PrepocetMJ( ::dm:get('KUSOVwe->nSpMno'), ::dm:get('KUSOVwe->cMjSpo'), NAKPOL->cZkratJedn , 'NAKPOL' )
**     nMn := ::dm:get('M->nSpMnSklHR')
    *
    if cName = 'KUSOVwe->nProcOdp_1'
      ::dm:set('KUSOVwe->nMnozOdp_1', ( nMn /100 * xVar ))
    elseif cName = 'KUSOVwe->nMnozOdp_1'
      ::dm:set('KUSOVwe->nProcOdp_1', ( xVar / ( nMn /100 )))
    endif

    *
    if cName = 'KUSOVwe->nProcOdp_2'
      ::dm:set('KUSOVwe->nMnozOdp_2', ( nMn /100 * xVar ))
    elseif cName = 'KUSOVwe->nMnozOdp_2'
      ::dm:set('KUSOVwe->nProcOdp_2', ( xVar / ( nMn /100 )))
    endif
    *
*    ::dm:set( 'M->nSpMnSklCI', ( nMn - ::dm:get('KUSOVwe->nMnozOdp_1') - ::dm:get('KUSOVwe->nMnozOdp_2') ))
* zatím využíváme jen odpad_1
    ::dm:set( 'M->nSpMnSklCI', ( nMn - ::dm:get('KUSOVwe->nMnozOdp_1')))  //- ::dm:get('KUSOVwe->nMnozOdp_2') ))
  ENDCASE


  if lok
    eval(ovar:block,ovar:value)
    if( cfile <> 'M', ovar:initValue := ovar:value, nil )
  endif

**  if( lchanged .and. lok, ::dm:refresh(), nil )
RETURN lOK

* Výbìr vyrábìné položky do karty kusovníkové vazby
********************************************************************************
METHOD VYR_Kusov_CRD:VYR_VYRPOL_se_SEL( Dialog, KeyFound)
  local  oDialog, nExit, lOK := .F.
  local  cnizPol := upper( ::dm:get('KUSOVwe->cNizPol')), sid := 0

  if .not. empty(cnizPol)
    do case
    case vyrPol_se->( dbseek( upper( ::cZakNizPol) +cnizPol,, 'VYRPOL1'))
      sid := vyrPol_se->sid
    case vyrPol_se->( dbseek( cnizPol,, 'VYRPOL4'))
      sid := vyrPol_se->sid
    endcase
  endif

  DEFAULT KeyFound TO .F.

  IF !KeyFound
    oDialog := drgDialog():new('VYR_VYRPOL_se_SEL', ::drgDialog)
    oDialog:cargo_usr := sid
    oDialog:create(,,.T.)
    nExit := oDialog:exitState


*    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
*                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set('KUSOVwe->cNizPOL', VYRPOL_se->cVyrPOL )
     KUSOVwe->nNizVar := VYRPOL_se->nVarCis
*    ::dm:set('KUSOVwe->nVarCis', VYRPOL->nVarCis )
    ::dm:set( 'M->cNazNizPol', VyrPOL_se->cNazev )
    ::cZakNizPol := VyrPOL_se->cCisZakaz
  ENDIF
RETURN lOK

* Výbìr skladové položky v kartì KUSOV
********************************************************************************
METHOD VYR_Kusov_CRD:VYR_NAKPOL_SEL( oDlg)
  LOCAL oDialog, nExit
  Local cName := ::drgDialog:lastXbpInFocus:cargo:name
  Local Value, lOK, nRec

  if  .not. ( Lower(cName) $ 'kusovwe->csklpol,kusovwe->cpolodp_1')
    return .t.
  endif

  Value := Upper( ::dm:get( cName))          //('KUSOVwe->cSklPol'))
  lOK := ( !Empty(value) .and. NAKPOL->( dbSEEK( Value,, 'NAKPOL1')) )
  nRec := if( lOk, NakPOL->( RecNO()), NIL)

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_NAKPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit CARGO_USR nRec
  ENDIF
  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    if  Lower(cName) = 'kusovwe->csklpol'
      ::dm:set( 'KUSOVwe->cSklPOL'   , NAKPOL->cSklPOL )
      ::dm:set( 'M->cNazNizPol'     , ::cNazNizPol := NakPOL->cNazTpv )
      ::dm:set( 'KUSOVwe->cMjTpv'    , NakPOL->cMjTpv  )
      ::dm:set( 'KUSOVwe->cMjSpo'    , NakPOL->cMjSpo  )
      ::dm:set( 'KUSOVwe->cZkratJedn', NakPOL->cZkratJedn )
      *
      nMn := PrepocetMJ(  ::dm:get('KUSOVwe->nCiMno'), ::dm:get('KUSOVwe->cMjTpv'), NakPOL->cMjSpo    , 'NAKPOL' )
      ::dm:set( 'KUSOVwe->nSpMno', nMn)
      nMn := PrepocetMJ(  ::dm:get('KUSOVwe->nCiMno'), ::dm:get('KUSOVwe->cMjTpv'), NakPOL->cZkratJedn , 'NAKPOL' )
      ::dm:set( 'M->nSpMnSklHR', nMn)
      *
      IF ::nVarFrmKUSOV = FrmKUSOV_1
        ::dm:set( 'KUSOVwe->nVahaMJ', NakPOL->nVahaMJ )
        *

        IF CenZBOZ->( dbSEEK( upper(NAKPOL->cCisSklad) + upper(NAKPOL->cSklPOL),,'CENIK03'))
          IF C_MATPOL->( dbSEEK( upper( CenZBOZ->cZkrMat),,'C_MATPOL1'))
            ::dm:set( 'KUSOVwe->cSklOdp_1', C_MATPOL->cSklOdp_1 )
            ::dm:set( 'KUSOVwe->cPolOdp_1', C_MATPOL->cPolOdp_1 )
            ** new 7.2.12
            if ::fromNABvys
              ::dm:set( 'KUSOVwe->ncenMat_MJ', CenaMAT( CenZBOZ->cZkrMat, Nabvyshdw->dDatOdes ) )
            endif
            ** end 7.2.12
          ENDIF
        ENDIF
      ENDIF

    else
      ::dm:set( cName, NAKPOL->cSklPOL )
      ::dm:set( 'KUSOVwe->cSklOdp_' + right(alltrim(cName),1), NAKPOL->cCisSklad )
      ::dm:set( 'KUSOVwe->cNazOdp_' + right(alltrim(cName),1), NAKPOL->cNazTPV )
    endif
  ENDIF
RETURN lOK

********************************************************************************
METHOD VYR_Kusov_CRD:jednot_sel( oDlg, cName)
  LOCAL cHelp := IF( IsNULL( oDlg), '', oDlg:lastXbpInFocus:cargo:name )
  LOCAL cItem := Coalesce( cName, cHelp )
  Local cMJ :=  Upper(::dm:get( cItem))
  Local ret, lOK := C_jednot->( dbSEEK( cMJ,, 'C_JEDNOT1'))
  Local aREC := {}

  IF IsObject( oDlg) .or. !lOK
    * Pokud poøizuje cMjTpv, cMjSpo, èíselník jednotek musí být omezen jen
    * na skladovou MJ a již definované vztahy !
    aREC := CiloveMJ( 'NakPOL' )
    mh_RyoFILTER( aREC, 'C_JEDNOT')
    *
    ret := drgCallSearch( ::drgDialog, 'C_JEDNOT', cMJ, '1' )
    IF  ( lOK := (ret <> nil ))
      ::dm:set( cItem, ret)
    ENDIF
    *
    C_Jednot->( ads_ClearAOF())
    *
  ENDIF
RETURN lOK

********************************************************************************
METHOD VYR_Kusov_CRD:C_Sklad( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( 'KUSOVwe->cSklOdp_1', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_SKLADY->(dbseek(value,,'C_SKLAD1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'SKL_C_SKLAD' PARENT ::drgDialog MODAL DESTROY ;
                                 EXITSTATE nExit CARGO drgVar:odrg

    if nexit = drgEVENT_SELECT
     ::dm:set( 'KUSOVwe->cSklOdp_1', C_SKLADY->cCisSklad )
*     ::dm:refresh()
    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

********************************************************************************
METHOD VYR_Kusov_CRD:comboItemSelected( mp1, mp2, o)

  ::cGroup := IF( mp1:value, 'cSklPOL', 'cVyrPOL')
  cPol     := ::cGroup
  *
  ::showGroup()
  ::drgDialog:oForm:setNextFocus('KUSOVwe->' + ::cGroup,, .T. )

RETURN self

********************************************************************************
METHOD VYR_Kusov_CRD:CheckItemSelected(drgVar)
  local  value := drgVar:value
  local  name  := drgVar:name

  ::lvypCImno := value

  IsEditGET( {'KUSOVwe->nRozmA'  ,;
              'KUSOVwe->nRozmB'  ,;
              'KUSOVwe->nKusRoz' ,;
              'KUSOVwe->nNavysPrc'} ,  ::drgDialog, drgVar:Value )
RETURN self

*  HIDDEN
********************************************************************************
METHOD VYR_Kusov_CRD:showGroup()
  Local  x
*
  FOR x := 1 TO LEN(::members)
    If IsMemberVar(::members[x],'groups') .and. .not. Empty(::members[x]:groups)
     If .not.( 'clr' $ lower(::members[x]:groups))
      IF ::members[x]:groups <> ::cGroup
        ::members[x]:oXbp:hide()
        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .F.)
        IF( ::members[x]:ClassName() $ 'drgGet')
          IF IsObject(::members[x]:pushGet) .and. ::members[x]:pushGet:ClassName() = 'drgPushButton'
            ::members[x]:pushGet:oXbp:hide()
          ENDIF
        ENDIF

      ELSE
        ::members[x]:oXbp:show()
        IF( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .T.)
        IF( ::members[x]:ClassName() $ 'drgGet')
          IF IsObject(::members[x]:pushGet) .and. ::members[x]:pushGet:ClassName() = 'drgPushButton'
            ::members[x]:pushGet:oXbp:show()
          ENDIF
        ENDIF
      ENDIF
     ENDIF
    ENDIF
  NEXT
*
RETURN self

********************************************************************************
METHOD VYR_Kusov_CRD:destroy()
  ::drgUsrClass:destroy()
  *
  if !::fromNABvys
    VYRPOLw->( dbCloseArea())
  endif
  * EXPORTED
  ::cCisZakaz  := ::cVyrPol    :=  ::cNazev := ::cVarPop  := ::cZakNizPol :=  ;
  ::cNazNizPol := ::cNizVarPop := ::nVarCis := ::nVarRoot := nSpMnSklHR  :=  ;
  ::nSpMnSklCI := ::fromNABvys := ::nVarFrmKUSOV := NIL
  * HIDDEN
  ::lNewREC   := ;
  ::dm        := ;
  ::cGroup    := ;
  ::members   := NIL

  KUSOVwe->( dbCloseArea())
  VYRPOLDTw->( dbCloseArea())
  POLOPERw->( dbCloseArea())
  VyrPOL->( dbGoTO( ::nRecNO))
RETURN self

*  HIDDEN
********************************************************************************
METHOD VYR_Kusov_CRD:KusControl( cVyrPol, lNakPol, nVarPos)
  Local cTreeKey := AllTrim( KusTree->cTreeKey), cKey
  Local nLenKey  := ( Len( cTreeKey) -3) / 3, n, nPos
  Local aV, aN, acVyrPol := {}
  Local nRec := KusTree->( RecNo()), lExist := FALSE, lOK := TRUE

  Default  lNakPol  To  FALSE

BEGIN SEQUENCE
  * Kontrola na vyšší úrovnì ( jen u vyrábìných položek)
  If !lNakPol
     For n := 0 To  nLenKey
       cKey := Left( cTreeKey, n*3) + '000'
       KusTree->( dbSeek( Upper( cKey)))
       * položky na vyšší úrovni
       cKey :=  KusTree->cCisZakaz + KusTree->cVyrPol
       aAdd( acVyrPol, cKey )
       lExist := If( ( cKey = ::cCisZakaz + cVyrPol), TRUE, lExist)
     Next
     KusTree->( dbGoTo( nRec))

     If lExist
       drgMsgBox(drgNLS:msg(;
       'Položka  < & >  je již v kusovníku obsažena na vyšší úrovni !',;
        cVyrPol ), XBPMB_WARNING )
       lExist := !lExist
BREAK
     Endif
  Endif

  * Kontrola, zda nová  (složená) položka neobsahuje na nižších úrovních
  * položku z vyšší úrovnì, což by vedlo k zacyklení. ( jen u vyráìných položek)
  fOrdRec( { 'Kusov, 4' })
  ( aV := {}, aN := {} )
  aAdd( aV, ::cZakNizPol + cVyrPol )
  Do While lOK
    For n := 1 To Len( aV)
       KUSOV->( mh_SetScope( Upper( aV[n])))
       Do While !Kusov->( Eof())
          If(( nPos := aScan( acVyrPol, aV[ n]) <> 0  ))
            drgMsgBox(drgNLS:msg(;
             'Ve struktuøe této položky je již obsažena nìkterá z položek na vyšší úrovni !'), XBPMB_WARNING )
             lExist := FALSE
BREAK
          EndIf
/*
          if .not. empty(::cZakNizPol + Kusov->cNizPol)
            aAdd( aN, ::cZakNizPol + Kusov->cNizPol )
          endif
*/
          Kusov->( dbSkip())
       EndDo
       KUSOV->( mh_ClrScope())
    Next
    ( aV := aN, aN := {}  )
    lOK := ( Len( aV) <> 0 )
  EndDo
  fOrdRec()

  * Mìkká  kontrola na stejnou úroveò ( u vyrábìných i skladových položek)
  fOrdRec( { 'Kusov, 4' })
  cKey := Upper( If( ::lNewRec, KusTree->cVyrPol, KusTree->cVysPol) )

  KUSOV->( mh_SetScope( ::cZakNizPol + cKey ))
  If lNakPol ;   Kusov->( dbEval( {|| lExist := ;
                          If( Kusov->cSklPol == cVyrPol, TRUE, lExist) }))
  Else       ;   Kusov->( dbEval( {|| lExist := ;
                          If( Kusov->cNizPol == cVyrPol, TRUE, lExist) }))
  Endif
  KUSOV->( mh_ClrScope())
  fOrdRec()
  If lExist
    drgMsgBox(drgNLS:msg(;
             'Položka je již v kusovníku obsažena na stejné úrovni !'), XBPMB_WARNING )
BREAK
  Else
     lExist := TRUE
  Endif
END SEQUENCE

RETURN lExist