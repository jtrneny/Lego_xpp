/*==============================================================================
  VYR_VyrZakIT_SCR.PRG                    ... Položky výrobní zakázky
==============================================================================*/
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*****************************************************************
*
*****************************************************************
CLASS VYR_VyrZakIT_SCR FROM drgUsrClass
EXPORTED:
  VAR     Filter

  METHOD  Init, Destroy
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  EventHandled, itemMarked
  METHOD  PostValidate, tabSelect
  METHOD  OnSave
  METHOD  GenVyrZakIT, GenPolOper, PRO_ExpLstHD, KusTree_Full, ZakIT_Zapustit
  METHOD  VyrPol_OperTree, ListHD_SCR
  METHOD  PolOper_CRD

*HIDDEN
  VAR     dc, dm, nSumaMnoz, tabNum, cCisZAKAZ
  METHOD  OrdItem, SumColumn, SumColOper, VyrZAK_sel
  METHOD  VyrZakIT_DEL

ENDCLASS

********************************************************************************
METHOD VYR_VyrZakIT_SCR:init(parent)
  ::drgUsrClass:init(parent)
  ::nSumaMnoz := 0
  ::cCisZAKAZ := EMPTY_ZAKAZ
  *
  drgDBMS:open('POLOPER' )
  drgDBMS:open('OPERACE' )
  POLOPER->( DbSetRelation( 'OPERACE', { || Upper(POLOPER->cOznOper) },;
                                           'Upper(POLOPER->cOznOper)' ))
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, n, x, oColumn , nRecCount, nArea
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  SEPARATORs( members)
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  *
  ::Filter := FORMAT("cCisZakaz = '%%'",{ VyrZAK->cCisZakaz } )
  VyrZakIT->( mh_SetFilter( ::Filter), dbGoTOP() )
*  VyrZakIT->( ads_SetAOF( ::Filter), dbGoTOP() )
*  nRecCount := VyrZakIT->( ads_GetRecordCount())
*  nArea := VyrZakIT->( Select() )

  * VyrZakIT
  FOR n := 1 TO 2
    FOR x := 1 TO ::dc:oBrowse[n]:oXbp:colcount
      ocolumn := ::dc:oBrowse[n]:oXbp:getColumn(x)

      ocolumn:FooterLayout[XBPCOL_HFA_CAPTION]     := ''
      ocolumn:FooterLayout[XBPCOL_HFA_HEIGHT]      := drgINI:fontH - 2
      ocolumn:FooterLayout[XBPCOL_HFA_FRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RECESSED
      ocolumn:FooterLayout[XBPCOL_HFA_ALIGNMENT]   := XBPALIGN_RIGHT
      ocolumn:FooterLayout[XBPCOL_HFA_FGCLR]       := GRA_CLR_DARKBLUE
      ocolumn:configure()
    NEXT
    IF( n = 1, ::sumColumn(), )
  NEXT
  *

  *
  drgDialog:odBrowse[2]:oxbp:refreshAll()
  drgDialog:odBrowse[1]:oxbp:refreshAll()
  *
  IsEditGet( { 'nOrdItem', 'cVyrobCisl'}, drgDialog, .F. )
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR:drgDialogEnd(drgDialog)
  *
  VyrZAKit->( mh_ClrFilter())
RETURN self

********************************************************************************
METHOD VYR_VyrZakIT_SCR:EventHandled(nEvent, mp1, mp2, oXbp)
  Local lOK, oDialog, nExit, nRec
  Local cFile

  DO CASE
  CASE  nEvent = drgEVENT_EDIT
    cFile := ::dc:oaBrowse:cFile   // oXbp:cargo:cFile
    IF cFile = 'VyrZakIT'
       RETURN .F.
    ELSEIF cFile = 'PolOper'
      ::PolOPER_CRD( nEvent)
      RETURN .T.
    ENDIF

  CASE  nEvent = drgEVENT_APPEND
    cFile := ::dc:oaBrowse:cFile  // oXbp:cargo:cFile
    IF cFile = 'VyrZakIT'
       * položku zak. nelze pøidávat, generuje se automaticky (KOVAR)
*       drgMsgBox(drgNLS:msg('Položku zakázky nelze pøidávat, generuje se automaticky ...'))
       RETURN .f.
    ELSEIF cFile = 'PolOper'
      ::PolOPER_CRD( nEvent)
      RETURN .T.
    ENDIF

  CASE  nEvent = drgEVENT_DELETE
    cFile := ::dc:oaBrowse:cFile   // oXbp:cargo:cFile
    IF cFile = 'VyrZakIT'
    * pøi zrušení položky se musí zrušit PolOper
      ::VyrZakIT_DEL()
       ::sumColumn()
      RETURN .T.
    ELSEIF cFile = 'PolOper'
      ::sumColOper()
    ENDIF
  *
  CASE nEvent = xbeP_SetDisplayFocus
    nRec := VyrZakIT->( RecNO())
    VyrZakIT->( mh_SetFilter( ::Filter), dbGoTO( nRec) )   // dbGoTOP() )
    ::sumColumn()
  *
  OTHERWISE
    RETURN .F.
  ENDCASE
*/
RETURN .F.

*
********************************************************************************
METHOD VYR_VyrZakIT_SCR:ItemMarked()
  Local cScope := Upper( VyrZAKIT->cCisZakaz) + Upper( VyrZAKIT->cVyrPol) + StrZero( VyrZakIT->nOrdItem, 3)

  PolOPER->( mh_SetScope( cScope))
  ::sumColOper()
RETURN SELF


********************************************************************************
METHOD VYR_VyrZakIT_SCR:PostValidate( oVar)
  LOCAL  xVar := oVar:get(), cNAMe := oVar:name, nRec
  LOCAL  lChanged := oVar:changed(), lOK := .T.

  IF lChanged
    DO CASE
    CASE cName = 'VyrZakIT->cVyrobCisl'
      nRec := VyrZakIT->( RecNo())
      VyrZakIT->( dbGoTOP(),;
                  dbEVAL( {|| lOK := IF( VyrZakIT->cVyrobCisl = xVar, .F., lOK) }),;
                  dbGoTO( nRec) )
      IF !lOK
        drgMsgBox(drgNLS:msg('Duplicitní výrobní èíslo'))
      ENDIF

    CASE cName = 'VyrZakIT->nMnozPlano'
      IF ::nSumaMnoz + xVar > VyrZak->nMnozPlano
        drgMsgBox(drgNLS:msg('Množství na položkách [ & ]  pøesáhlo množství na hlavièce [ & ]',;
                              ::nSumaMnoz + xVar , VyrZak->nMnozPlano))
        ::dm:set( cName, VyrZak->nMnozPlano - ::nSumaMnoz )
        lOK := .F.
      ENDIF

    ENDCASE
  ENDIF
RETURN lOK

*
***************************************************************************
METHOD VYR_VyrZakIT_SCR:OnSave( isBefore, isAppend)
  Local nOrdItem := ::OrdITEM()

  If !isBefore
    If IsAppend
*      mh_CopyFLD( 'VyrZAK', 'VyrZakIT', .T.)
      VyrZakIT->cCisZakaz := VyrZak->cCisZakaz
      VYRZAKIT->nOrdItem  := nOrdItem
    EndIf
    ::sumColumn()
  EndIf
RETURN .t.

********************************************************************************
METHOD VYR_VyrZakIT_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
RETURN .T.

********************************************************************************
METHOD VYR_VyrZakIT_SCR:PolOper_CRD( nEvent)
  LOCAL oDialog, nExit
  LOCAL cText := IF( nEvent = drgEVENT_APPEND, 'insert', 'edit')

  oDialog := drgDialog():new('VYR_PolOper_CRD',self:drgDialog)
  oDialog:cargo := nEvent
  oDialog:create(,self:drgDialog:dialog,.F.)

  IF oDialog:exitState != drgEVENT_QUIT
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL
  *
  ::sumColOper()
RETURN self

* Dodací podmínky
********************************************************************************
METHOD VYR_VyrZakIT_SCR:PRO_ExpLstHd
  LOCAL oDialog
  /*
   Bude se zobrazovat seznam expedièních listù k dané položce zakázky a
   nad každým záznamem se zobrazí karta pøíslušného exp. listu.
  */
  /*
  drgDBMS:open('ExpLstHd'  )
  drgDBMS:open('ExpLstIt'  )
  IF VyrZakIT->nCisloEL = 0
    drgMsgBox(drgNLS:msg('Zakázka nemá pøiøazen expedièní list !'))
    RETURN NIL
  ENDIF
  *
  IF ExpLstHd->( dbSeek( VyrZakIT->nCisloEL,,1))
    ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'PRO_ExpLstHd_IN' PARENT ::drgDialog CARGO drgEVENT_EDIT MODAL DESTROY
    ::drgDialog:popArea()                  // Restore work area
  ELSE
    drgMsgBox(drgNLS:msg('Expedièní list [ & ] nebyl nalezen !', VyrZakIT->nCisloEL))
  ENDIF
  */
RETURN self

* Strukt. kusovník - plnì rozbalený
********************************************************************************
METHOD VYR_VyrZakIT_SCR:KusTree_Full()
  LOCAL oDialog, cKey, cTag := PolOper->( OrdSetFocus())

*  cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol) + StrZero( VyrZak->nVarCis, 3)
  cKey := Upper( VyrZAKIT->cCisZakaz) + Upper( VyrZAKIT->cVyrPol) + StrZero( VyrZakIT->nOrdItem, 3)
  IF  VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
    ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::drgDialog MODAL DESTROY
    ::drgDialog:popArea()                  // Restore work area
    *
    PolOper->( AdsSetOrder( cTag))
    ::itemMarked()
    ::dc:oBrowse[2]:oXbp:refreshAll()
    *
  ENDIF
RETURN self

* Kusovník s operacemi nad položkou zakázky ( VyrZAKIT)
********************************************************************************
METHOD VYR_VyrZAKIT_SCR:VyrPol_OperTree()
LOCAL oDialog, cKey, cTag := PolOper->( AdsSetOrder())

  cKey := Upper( VyrZakIT->cCisZakaz) + Upper( VyrZakIT->cVyrPol) + StrZero( VyrZakIT->nOrdItem, 3)    //+ StrZero( VyrZakIT->nVarCis, 3)
  IF ( lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1')))
    ::drgDialog:pushArea()
    DRGDIALOG FORM 'VYR_OperTREE_SCR' PARENT ::drgDialog MODAL DESTROY
    ::drgDialog:popArea()
    PolOper->( AdsSetOrder( cTag))
  ENDIF
RETURN self

* Mzdové lístky k zakázce
********************************************************************************
METHOD VYR_VyrZAKIT_SCR:ListHD_SCR()
LOCAL oDialog, Filter, nRec := VyrZAK->( RecNO())

  Filter  := Format("cCisZakazI = '%%'", { VyrZakIT->cCisZakazI })
  ListHD->( mh_SetFilter( Filter))
    ::drgDialog:pushArea()
    DRGDIALOG FORM 'Vyr_MListHD_scr' PARENT ::drgDialog MODAL DESTROY
    ::drgDialog:popArea()
  ListHD->( mh_ClrFilter())
  VyrZAK->( dbGoTO( nRec))
RETURN self

*  Viz.  VYR_VyrZak_SCR:ZAK_zapustit()
********************************************************************************
METHOD VYR_VyrZakIT_SCR:ZAKIT_zapustit()
LOCAL oDialog, nExit
Local lOK, cMsg

BEGIN SEQUENCE
  * 1. podmínka pro zapuštìní
  If Empty( VyrZak->cVyrPol)
    cMsg := 'Výrobní zakázce < & > není pøiøazen žádný výrobek !'
    drgMsgBox(drgNLS:msg( cMsg, VyrZAK->cCisZakaz ))
BREAK
  Endif
  * 2. podmínka pro zapuštìní
  cKey := Upper( VyrZakIT->cCisZakaz) + Upper( VyrZakIT->cVyrPol) + StrZero( VyrZakIT->nOrdItem, 3)   // + StrZero( VyrZakIT->nVarCis, 3)
  IF ( lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1')))
     lOK := ( VyrPol->cStav = 'A' )
  EndIf
  If !lOK
    cMsg := 'Vyrábìná položka < & > není schválena k zapuštìní !'
    drgMsgBox(drgNLS:msg( cMsg, VyrZAKIT->cVyrPol ))
BREAK
  Endif
  * 3. podmínka pro zapuštìní
  lOK := ( VyrZak->nMnozPlano > VyrZak->nMnozVyrob)
  If !lOK
    drgMsgBox(drgNLS:msg( 'Není splnìna podmínka pro zapuštìní do výroby !' ))
BREAK
  Endif
/* Vyhodnocení stavu zakázky
  DrawSCR()
  If !( lOK := WhatSTAV() )
BREAK
  EndIf
*/
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_ZAKzapus,VyrZakIT' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
*  ::RefreshBROW('VyrZAK')
ENDSEQUENCE
RETURN self


********************************************************************************
METHOD VYR_VyrZakIT_SCR:destroy()
  ::drgUsrClass:destroy()
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_VyrZakIT_SCR:OrdITEM()
  Local cAlias := 'VyrZakIT_a'
  Local nOrdItem, nArea := Select()

  drgDBMS:open( 'VyrZakIT',,,,, cAlias)
  ( cAlias)->( AdsSetOrder( 1),;
               mh_SetScope( Upper( VyrZak->cCisZakaz)),;
               dbGoBottom() )
  nOrdItem := ( cAlias)->nOrdItem + 1
  ( cAlias)->( mh_ClrScope(), dbCloseArea())
  dbSelectArea( nArea)
Return( nOrdItem)

** HIDDEN **********************************************************************
METHOD VYR_VyrZakIT_SCR:SumColumn()
  LOCAL nRec := VyrZakIT->( RecNo()), nSuma := 0, aItems

  VyrZakIT->( dbGoTOP(),;
              dbEVAL( {|| nSuma += VyrZakIT->nMnozPlano } ),;
              dbGoTO( nRec) )
  ::nSumaMnoz := nSuma

  aItems := { {'VyrZakIT->nMnozPlano', ::nSumaMnoz, ::dc:oBrowse[1] } }

  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( (aItems[ x,3]):arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:hide()
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      (aItems[ x,3]):oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT
  ::dm:refresh()
  *
  * Pokud neexistují položky zak.( ::nSumaMnoz = 0), neaktualizovat hlavièku
  IF ::nSumaMnoz <> 0 .AND. ::nSumaMnoz <> VyrZAK->nMnozPlano
    IF VyrZAK->( dbRLock())
      VyrZAK->nMnozPlano := ::nSumaMnoz
      VyrZAK->( dbUnlock())
    ENDIF
  ENDIF

RETURN

** HIDDEN **********************************************************************
METHOD VYR_VyrZakIT_SCR:SumColOper()
  LOCAL aItems, nRec := PolOper->( RecNo()), nKcNaOper := 0

  PolOper->( dbGoTOP(),;
              dbEVAL( {|| nKcNaOper += PolOper->nKcNaOper } ),;
              dbGoTO( nRec) )

  aItems := { { 'PolOper->nKcNaOper', nKcNaOper } }
  FOR x := 1 TO LEN( aItems)
    IF ( nPos := AScan( ::dc:oBrowse[2]:arDef, {|Col| Col[ 2] = aItems[ x, 1] } ) ) > 0
      ::dc:oBrowse[2]:oXbp:getColumn( nPos):Footing:hide()
      ::dc:oBrowse[2]:oXbp:getColumn( nPos):Footing:setCell(1, aItems[ x, 2] )
      ::dc:oBrowse[2]:oXbp:getColumn( nPos):Footing:show()
    ENDIF
  NEXT
  ::dm:refresh()
  *
RETURN

* Generuje VyrZakIT a k nim PolOPER
********************************************************************************
METHOD VYR_VyrZakIT_SCR:GenVyrZakIT()
  Local cScope, cKey, x, nOrd, lCopy := .F., nTypVar

**  drgDBMS:open('PolOPER',,,,, 'PolOPERa' )
  drgDBMS:open('VyrPOL' ,,,,, 'VyrPOLa'  )

*  IF ::dm:get('VyrZAKw->nMnozPlano') <> 0
  IF EMPTY( VyrZakIT->cVyrobCisl)

**    ::VyrZAK_sel()
    * 22.7.10
    nTypVar := SysConfig( 'Vyroba:nTypVar')
    nTypVar := If( IsArray( nTypVar), 1, nTypVar )

    FOR x := 1 TO VyrZAK->nMnozPlano
      mh_CopyFLD( 'VyrZAK', 'VyrZakIT', .T. )
      VyrZakIT->cCisZakaz  := VyrZak->cCisZakaz
      nOrd                 := x
//      nOrd := IF( VyrZAK->nMnozPlano = 1, 0, x)     //  JT  09.09.2013
      VYRZAKIT->nOrdItem   := x
      VYRZAKIT->nVarCis    := x    // 15.8.2007
      VyrZakIT->cVyrobCisl := ALLTRIM( VyrZak->cCisZakaz) + '/' + ALLTRIM( STR( nOrd))
      VyrZakIT->cCisZakazI := ALLTRIM( VyrZak->cCisZakaz) + '/' + ALLTRIM( STR( nOrd))
      VyrZakIT->nMnozPlano := 1
      * generuje VyrPol v pøíslušné variantì
      cKey := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + STRZERO( x, 3)
      IF ! VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
        IF nTypVar = 1
          cKey := EMPTY_ZAKAZ + Upper( VyrZAK->cVyrPOL) + '001'  // STRZERO( x, 3)
          IF VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
            lCopy := .T.
          ELSE
            cKey := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + '001'
            IF VyrPOLa->( dbSEEK( cKEY,,'VYRPOL1'))
              lCopy := .T.
            ENDIF
          ENDIF
        ELSEIF nTypVar = 2
        ENDIF
        IF lCopy
          mh_CopyFLD( 'VyrPOLa', 'VyrPOL', .T.)
          VyrPOL->cCisZakaz := VyrZak->cCisZakaz
          VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
          VyrPOL->nVarCis   := x
          VyrPOL->nStavKalk := -1
         ENDIF
      ENDIF
      /* generuje PolOper k položkám zakázky
      cScope := ::cCisZAKAZ + Upper( VyrZAK->cVyrPOL)
      PolOPERa->( mh_SetSCOPE( cScope))
      DO WHILE !PolOPERa->( EOF())
        cKEY := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + STRZERO(PolOPERa->nCisOper,4) + ;
                STRZERO(PolOPERa->nUkonOper,2) + STRZERO( x, 3)
        IF .not. PolOPER->( dbSEEK( cKEY,, 1))
          mh_CopyFLD( 'PolOPERa', 'PolOPER', .T.)
          PolOPER->cCisZakaz  := VyrZak->cCisZakaz
          PolOper->cVyrobCisl := VyrZakIT->cVyrobCisl
          PolOper->nVarOper  := x
        ENDIF
        PolOPERa->( dbSkip())
      ENDDO
      PolOPERa->( mh_ClrSCOPE())
      */
    NEXT
    VyrZakIT->( dbGoTOP())
**    PolOPERa->( dbCloseArea())
    *
    ::itemMarked()
    ::dc:oBrowse[1]:oXbp:refreshAll()
**    ::dc:oBrowse[2]:oXbp:refreshAll()

  ELSE
    drgMsgBox(drgNLS:msg('Položky zakázky již existují ...'))
  ENDIF

RETURN self

* Generuje PolOPER k jednotlivým VyrZakIT
********************************************************************************
METHOD VYR_VyrZakIT_SCR:GenPolOper()
  Local cScope, cKey, nRec := VyrZakIT->( RecNO())

  drgDBMS:open('PolOPER',,,,, 'PolOPERa' )
*  drgDBMS:open('VyrPOL' ,,,,, 'VyrPOLa'  )

  VyrZakIT->( dbGoTop())
  IF VyrZakIT->( EOF())
    drgMsgBox(drgNLS:msg('Položky zakázky neeexistují, nelze generovat operace ...'))
    RETURN nil
  ENDIF
  *
  IF EMPTY( VyrZak->cVyrPOL)
    drgMsgBox(drgNLS:msg('Zakázka nemá vyrábìnou položku, nelze generovat operace ...'))
    RETURN nil
  ENDIF
  *
  ::VyrZAK_sel()

  DO WHILE ! VyrZakIT->( EOF())
    * generuje PolOper k položkám zakázky
    cScope := ::cCisZAKAZ + Upper( VyrZAK->cVyrPOL)
    PolOPERa->( mh_SetSCOPE( cScope))
    DO WHILE !PolOPERa->( EOF())
      *
      cKEY := Upper( VyrZAK->cCisZakaz)+ Upper( VyrZAK->cVyrPOL) + STRZERO(PolOPERa->nCisOper,4) + ;
              STRZERO(PolOPERa->nUkonOper,2) + STRZERO(VyrZakIT->nOrdItem, 3)
      IF .not. PolOPER->( dbSEEK( cKEY,, 'POLOPER1'))
        *- 16.2.12
        IF PolOPERa->nVarOper  <= VyrZakIT->nOrdItem
          mh_CopyFLD( 'PolOPERa', 'PolOPER', .T.)
          PolOPER->cCisZakaz  := VyrZak->cCisZakaz
          PolOPER->cCisZakazI := VyrZakIT->cCisZakazI
          PolOper->cVyrobCisl := VyrZakIT->cVyrobCisl
          PolOper->nVarOper   := VyrZakIT->nOrdItem
          PolOper->nRokVytvor := 0
          PolOper->nPorCisLis := 0
        ENDIF
      ENDIF
      PolOPERa->( dbSkip())
    ENDDO
    PolOPERa->( mh_ClrSCOPE())

    VyrZakIT->( dbSkip())
  ENDDO

  VyrZakIT->( dbGoTO( nRec))
  PolOPERa->( dbCloseArea())
  *
  ::itemMarked()
*  ::dc:oBrowse[1]:oXbp:refreshAll()
  ::dc:oBrowse[2]:oXbp:refreshAll()

RETURN self


* Výbìr z výrobních zakázek na danou vyrábìnou položku
** HIDDEN **********************************************************************
METHOD VYR_VyrZakIT_SCR:VYRZAK_SEL( Dialog)
  LOCAL oDialog, nExit, lOK := .T.
  Local nREC := VyrZAK->( RecNO()) // , cTag := VyrZAK->( AdsSetOrder(2))
  Local cVyrPOL := Upper( VyrZAK->cVyrPOL)

  Filter := FORMAT("(VyrZak->cVyrPOL = '%%')",{ cVyrPOL } )
  VyrZak->( mh_SetFilter( Filter))

  DRGDIALOG FORM 'VYR_VYRZAK_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                  EXITSTATE nExit
  IF ( nExit != drgEVENT_QUIT )
    ::cCisZAKAZ := VyrZAK->cCisZAKAZ
  ENDIF
  VyrZAK->( mh_ClrFilter(), dbGoTO( nREC) )

RETURN self

* Zruší položku zakázky vèetnì operací
** HIDDEN **********************************************************************
METHOD VYR_VyrZakIT_SCR:VYRZAKIT_DEL()
  Local aPolOper := {}, lPolOPER, lVyrZakIT, n

  IF drgIsYesNo(drgNLS:msg( 'Zrušit položku zakázky vèetnì operací ?' ))
    PolOPER->( dbGoTOP(),;
               dbEval( {|| AADD( aPolOper, PolOPER->( RecNO()) ) }))
    lPolOper  := IF( LEN( aPolOper) = 0, .T., POLOPER->( sx_RLOCK( aPolOper)) )
    lVyrZakIT := VyrZakIT->( sx_Rlock())

    IF lPolOper .and. lVyrZakIT
      FOR n := 1 TO LEN( aPolOper)
        POLOPER->( dbGoTO( aPolOper[ n]), dbDelete() )
      NEXT
      VyrZakIT->( dbDelete())
    ENDIF
    PolOPER->( dbUnlock())
    VyrZakIT->( dbUnlock())
    *
    ::dc:oBrowse[1]:oXbp:refreshAll()
    ::itemMarked()
    ::dc:oBrowse[2]:oXbp:refreshAll()
  ENDIF
  *
RETURN self