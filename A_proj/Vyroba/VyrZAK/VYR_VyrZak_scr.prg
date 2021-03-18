/*==============================================================================
  VYR_VyrZAK_scr.PRG
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

*===============================================================================
FUNCTION VyrZAKis_U()
RETURN if(VyrZak->cStavZakaz = 'U', MIS_ICON_OK, 0)

********************************************************************************
*
********************************************************************************
CLASS VYR_VyrZak_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  VAR     FormIsRO
  METHOD  Init, drgDialogStart, ItemMarked, eventHandled, drgDialogInit
  METHOD  tabSelect
  METHOD  ZAK_zapustit, ZAK_odvest, ZAK_ukoncit, ZAK_open, ZAK_material, ZAK_copy
  METHOD  btn_VyrZakIT, kustree_Full, Gen_Kusov, VyrPol_OperTree, ListHD_SCR
  METHOD  UcetStav_SCR
  METHOD  VazDokum

  * pro exontrol tree
  inline method kusTree_ex_Full(drgDialog)
    local  othread
    local  recNo := str(vyrPol->( recNo()))

    oThread := drgDialogThread():new()
    oThread:start( ,'vyr_kusTREE_ex_scr,' +recNo, drgDialog)
  return

  inline method operTree_ex(drgDialog)
    local  othread
    local  recNo := str(vyrPol->( recNo()))

    oThread := drgDialogThread():new()
    oThread:start( ,'VYR_operTREE_EX_SCR,' +recNo, drgDialog)
  return


HIDDEN:
  VAR      tabNUM, abMembers
  METHOD   RefreshBROW
ENDCLASS

********************************************************************************
METHOD VYR_VyrZak_SCR:Init(parent, FormIsRO)
  ::drgUsrClass:init(parent)
  *
  DEFAULT FormIsRO TO .F.
  *
  drgDBMS:open('VYRZAK'  )
  drgDBMS:open('VYRZAKIT')
  drgDBMS:open('OBJZAK'  )
  drgDBMS:open('OBJITEM' )
  drgDBMS:open('LISTHD'  )
  drgDBMS:open('KUSOV'   )
  drgDBMS:open('POLOPER' )
  drgDBMS:open('VYRPOL'  )
  drgDBMS:open('VYRPOLDT')
  drgDBMS:open('ZAKAPAR' )
  drgDBMS:open('PVPITEM' )
  *
  ::FormIsRO := FormIsRO
RETURN self

********************************************************************************
METHOD VYR_VyrZak_SCR:drgDialogInit(drgDialog)
  LOCAL nTypCRD := 1 //    1 - STD, 2 - MOPAS
  LOCAL aCrd    := { 'VYR_VYRZAK_CRD', 'VYR_VYRZAK_TST'}

  DEFAULT ::FormIsRO TO .F.
  drgDialog:formHeader:cargo := aCRD[ nTypCRD]
*  drgDialog:formHeader:title += IF( ::FormIsRO, ' - INFO', '' )
RETURN self

********************************************************************************
METHOD VYR_VyrZak_SCR:drgDialogStart(drgDialog)
  Local aEventsDisabled := 'zak_zapustit,zak_odvest,zak_ukoncit,zak_material,zak_copy,gen_kusov'
   *
  local  odesc, pa, pa_it := {},  pa_quick := {{ 'Kompletní seznam         ', ''                  }, ;
                                               { '(<>U) _neUkonèené zakázky', "cstavZakaz <> 'U'" }, ;
                                               { ''                         , ''                  }  }
  *
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
  ::abMembers := drgDialog:oActionBar:Members
  *
  drgDialog:SetReadOnly( ::formIsRO)
  IF ::formIsRO
    oActions := drgDialog:oActionBar:members
    for x := 1 to len(oActions)
      if isCharacter(oActions[x]:event)

        if ( lower( oActions[x]:event) $ aEventsDisabled)
          oActions[x]:oxbp:disable()
          oActions[x]:parent:amenu:disableItem( x)
          oActions[x]:oXbp:setColorFG( GraMakeRGBColor({128,128,128}))
        endif
      endif
    next
  ENDIF

  if isObject( odesc := drgRef:getRef( 'cstavZakaz' ))
    pa := listAsArray( odesc:values )

    aeval( pa, {|x| ( pb := listAsArray(x, ':'), aadd( pa_it, {allTrim(pb[1]) +' ', '(' +allTrim(pb[1]) +') _' +pb[2]} ) ) } )
  endif
  aeval( pa_it, { |x| aadd( pa_quick, { x[2], format( "cstavZakaz = '%%'", {x[1]} ) } ) })

  *
  ** vono je to použité jako PARENT ve zdrojáku -> VYR_VyrZak_Fakt_SCR
  if lower(drgDialog:initParam) <> 'vyr_vyrzak_fakt_scr'
    ::quickFiltrs:init( self, pa_quick, 'stavZakázky' )
  endif

RETURN self

*****************************************************************
METHOD VYR_VyrZak_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_DELETE
      VYR_VYRZAK_Del()
      ::RefreshBROW('VyrZAK')
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD VYR_VyrZak_SCR:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
  ::itemMarked()

*  ::RefreshBROW('VyrZAK')
RETURN .T.

********************************************************************************
METHOD VYR_VyrZak_SCR:ItemMarked()
//  IF  VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
  Local x, ckey := Upper( VyrZak->cCisZakaz) +Upper( VyrZak->cVyrPol) +StrZero( VyrZak->nVarCis, 3)

  OBJZAK->( mh_SetScope( Upper(VYRZAK->cCisZakaz)) )
  ZAKAPAR->( mh_SetScope( Upper(VYRZAK->cCisZakaz)) )

  FOR x := 1 TO LEN( ::abMembers)

    if isCharacter(::abMembers[x]:event)
      do case
      case ::abMembers[x]:event = 'ZAK_MATERIAL'            // Položky objitem
        ::abMembers[x]:disabled := empty(VyrZak->cCisZakaz)
      case ::abMembers[x]:event = 'BTN_VYRZAKIT'            // Položky zakáz.   --> VYR_VyrZAK.PRG
        ::abMembers[x]:disabled := ! VYR_isVyrZakIT()
      case ::abMembers[x]:event = 'GEN_KUSOV'               // Generuj kusov.   --> kusovniky\VYR_KUSOV.prg
        ::abMembers[x]:disabled := VYR_isKusov( 1, 'VyrZAK', .T. )
      case ::abMembers[x]:event = 'kusTree_ex_Full'
        ::abMembers[x]:disabled := .not. VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
      case ::abMembers[x]:event = 'operTree_ex'
        ::abMembers[x]:disabled := .not. VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
      endcase

      if( ::abMembers[x]:disabled, ::abMembers[x]:oXbp:disable(), ::abMembers[x]:oXbp:enable() )
    endif
  next
RETURN SELF

*
** Zapuštìní
METHOD VYR_VyrZak_SCR:ZAK_zapustit()
  LOCAL oDialog, nExit
  Local lOK, cMsg
  *
  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
BEGIN SEQUENCE
  * 1. podmínka pro zapuštìní
  If Empty( VyrZak->cVyrPol)
    cMsg := 'Výrobní zakázce < & > není pøiøazen žádný výrobek !'
    drgMsgBox(drgNLS:msg( cMsg, VyrZAK->cCisZakaz ))
BREAK
  Endif
  * 2. podmínka pro zapuštìní
  cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol) + StrZero( VyrZak->nVarCis, 3)
  IF ( lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1')))
     lOK := ( VyrPol->cStav = 'A' )
  EndIf
  If !lOK
    cMsg := 'Vyrábìná položka < & > není schválena k zapuštìní !'
    drgMsgBox(drgNLS:msg( cMsg, VyrZAK->cVyrPol ))
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
  VYRZAKIT->( dbSEEK( Upper( VyrZak->cCisZakaz),, 'ZAKIT_1'))
  DRGDIALOG FORM 'VYR_ZAKzapus,VYRZAK' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  ::RefreshBROW('VyrZAK')
ENDSEQUENCE
RETURN self

*
** Odvedení
METHOD VYR_VyrZak_SCR:ZAK_odvest()
  Local oDialog, nExit
  Local cStav := AllTrim( Upper( VyrZak->cStavZakaz))
  *
  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  DRGDIALOG FORM 'VYR_VYRZAK_odved' PARENT ::drgDialog DESTROY ;
                                    EXITSTATE nExit
*  IF ( nExit != drgEVENT_QUIT )
     ::drgDialog:dialogCtrl:oaBrowse:refresh()
     ::drgDialog:dataManager:refresh()
*  ENDIF
RETURN self

*
** Ukonèení
METHOD VYR_VyrZak_SCR:ZAK_ukoncit()
  Local oDialog, nExit
  Local cStav := AllTrim( Upper( VyrZak->cStavZakaz))

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF

*  IF cStav $ 'P678U'
     DRGDIALOG FORM 'VYR_VYRZAK_UKONC' PARENT ::drgDialog DESTROY ;
                                       EXITSTATE nExit
     IF ( nExit != drgEVENT_QUIT )
       ::drgDialog:dialogCtrl:oaBrowse:refresh()
       ::drgDialog:dataManager:refresh()
     ENDIF

*  ELSE
*    drgMsgBox(drgNLS:msg('NELZE UKONÈIT !;;Zakázka není v odpovídajícím stavu !!!'))
*  ENDIF
RETURN self

*
** Nové otevøení
METHOD VYR_VyrZak_SCR:ZAK_OPEN()
  Local oDialog, nExit
  Local cStav := AllTrim( Upper( VyrZak->cStavZakaz))
  *
  IF cStav <> 'U'
    drgMsgBox(drgNLS:msg('NELZE OTEVØÍT !;;Zakázka není v odpovídajícím stavu !!!'))
    RETURN Nil
  ENDIF
  * Znovu otevøít lze jen zakázku uzavøenou, tedy ve stavu 'U'
  DRGDIALOG FORM 'VYR_VYRZAK_OPEN' PARENT ::drgDialog DESTROY ;
                                    EXITSTATE nExit

  ::drgDialog:dialogCtrl:oaBrowse:refresh()
  ::drgDialog:dataManager:refresh()
RETURN self

*
** Materiál zak.
METHOD VYR_VyrZak_SCR:ZAK_MATERIAL()
  LOCAL oDialog
  *
  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakMAT_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  *
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()

  ::itemMarked()
RETURN self

*
** Kopie zakázky
METHOD VYR_VyrZAK_SCR:ZAK_Copy()
  LOCAL oDialog
  *
  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  PostAppEvent(drgEVENT_APPEND2,,,::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
RETURN self

*
** Položky zakázky
METHOD VYR_VyrZak_SCR:btn_VyrZakIT
  LOCAL oDialog, nTypEvidIT := 2, Filter

  ::drgDialog:pushArea()
  DO CASE
  CASE nTypEvidIT = 0    // bez položek k zakázce
    drgMsgBox(drgNLS:msg('K zakázce se neevidují položky !'))
  CASE nTypEvidIT = 1    // std
  CASE nTypEvidIT = 2    // KOVAR
*    Filter := FORMAT("cCisZakaz = '%%'",{  ALLTRIM(VyrZAK->cCisZakaz) } )
*    VyrZakIT->( mh_SetFilter( Filter))
    DRGDIALOG FORM 'VYR_VyrZakIT_SCR' PARENT ::drgDialog MODAL DESTROY
    ::RefreshBROW('VyrZAK')
*    VyrZakIT->( mh_ClrFilter())
  ENDCASE
  ::drgDialog:popArea()
RETURN self

* Strukt. kusovník - plnì rozbalený
********************************************************************************
METHOD VYR_VyrZak_SCR:KusTree_Full()
  LOCAL oDialog, cKey, nRec := VyrPol->( RecNO())
  LOCAL nArea, cTag, nRecNO

  cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol) + StrZero( VyrZak->nVarCis, 3)
  IF  VyrPol->( dbSeek( cKey,, 'VYRPOL1'))

    nArea := Select()
    cTag := OrdSetFocus()
    nRecNO := RecNO()
    *
    DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::drgDialog MODAL DESTROY
    *
    dbSelectArea( nArea)
    IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
    IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
  ELSE
    VyrPol->( dbGoTO( nRec))
    drgMsgBox(drgNLS:msg( 'Zakázkový kusovník neexistuje ...'))
  ENDIF
RETURN self

* Generování zakázkového kusovníku
********************************************************************************
METHOD VYR_VyrZak_SCR:Gen_Kusov()

  IF ::formIsRO
    MsgForRO()
    RETURN self
  ENDIF
  *
  VYR_GenKusovZAK()
  ::RefreshBROW('VyrZAK')
RETURN self

* Kusovník s operacemi nad zakázkou ( VyrZAK)
********************************************************************************
METHOD VYR_VyrZAK_SCR:VyrPol_OperTree()
LOCAL oDialog, cKey
LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  cKey := Upper( VyrZak->cCisZakaz) + Upper( VyrZak->cVyrPol) + StrZero( VyrZak->nVarCis, 3)
  IF ( lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1')))
*    ::drgDialog:pushArea()
    DRGDIALOG FORM 'VYR_OperTREE_SCR' PARENT ::drgDialog MODAL DESTROY
*    ::drgDialog:popArea()
  ENDIF
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )

RETURN self

* Mzdové lístky k zakázce
********************************************************************************
METHOD VYR_VyrZAK_SCR:ListHD_SCR()
LOCAL oDialog, Format
LOCAL nArea := Select(), cTag := OrdSetFocus(), nRecNO := RecNO()

  Filter  := Format("ListHD->cCisZakaz = '%%'", { VyrZak->cCisZakaz })
  ListHD->( mh_SetFilter( Filter))
*    ::drgDialog:pushArea()
    DRGDIALOG FORM 'Vyr_MListHD_scr' PARENT ::drgDialog MODAL DESTROY
*    ::drgDialog:popArea()
  ListHD->( mh_ClrFilter())
  *
  dbSelectArea( nArea)
  IF( cTag <> '' , ( nArea)->( AdsSetOrder( cTag)), NIL )
  IF( nRecNO <> 0, ( nArea)->( dbGoTO( nRecNO))   , NIL )
RETURN self

*
** Úèetní stav zakázky
METHOD VYR_VyrZak_SCR:UcetStav_SCR()
  LOCAL oDialog
  *
  *
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VyrZak_UcetStav_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  *
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()

  ::itemMarked()
RETURN self




********************************************************************************
METHOD VYR_VyrZak_SCR:VazDokum()
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('SYS_VazDOKUM_SCR',self:drgDialog)
  oDialog:cargo_usr := 'k výrobní zakázce : ' + Alltrim( VyrZAK->cCisZakaz)
  oDialog:create( ,,.F.)

  IF oDialog:exitState = drgEVENT_SAVE
  ENDIF

  oDialog:destroy(.T.)
  oDialog := NIL
  *
RETURN .T.

**HIDDEN************************************************************************
METHOD VYR_VyrZak_SCR:RefreshBrow( cFILE)
  Local oBrowse := ::drgDialog:dialogCtrl:oBrowse

  FOR x := 1 TO LEN( oBrowse)
    IF oBrowse[ x]:cFile = cFile
       oBrowse[x]:oXbp:refreshAll()
    ENDIF
  NEXT
RETURN self

********************************************************************************
* VYR_VYRZAK_UKONC ...
********************************************************************************
CLASS VYR_VYRZAK_UKONC FROM drgUsrClass

EXPORTED:
  VAR     dUzavZAKA
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, PostLastField
ENDCLASS

********************************************************************************
METHOD VYR_VYRZAK_UKONC:init(parent)
  ::drgUsrClass:init(parent)
  ::dUzavZAKA := IF( EMPTY( VyrZAK->dUzavZAKA), DATE(), VyrZAK->dUzavZAKA )
RETURN self

********************************************************************************
METHOD VYR_VyrZak_UKONC:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD VYR_VyrZak_UKONC:drgDialogStart(drgDialog)
  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
RETURN self

********************************************************************************
METHOD VYR_VYRZAK_UKONC:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_VYRZAK_UKONC:postLastField(drgVar)
  LOCAL dm := ::drgDialog:DataManager
  Local LockZAK, LockZakIT, aRecIT := {}

  LockZak := VyrZAK->( dbRLock())
  VyrZakIT->( AdsSetOrder(1), mh_SetSCOPE( Upper(VyrZAK->cCisZakaz)) )
  VyrZakIT->( dbEVAL( {|| aAdd( aRecIT, VyrZakIT->(RecNO()) ) }))
  LockZakIT := IF( LEN( aRecIT) = 0, .T., VyrZakIT->( sx_RLock( aRecIT)))
  *
  IF LockZak .and. LockZakIT
    dm:save()
    *
    VyrZak->dZnovuOtvZ := CTOD('  .  .  ')
    VyrZak->cStavZakUz := VyrZak->cStavZakaz  // uložíme stav zak. pøed uzavøením
    * Uzavøení hlavièky zakázky
    VyrZak->cStavZakaz := 'U'
    VyrZak->dUzavZAKA  := ::dUzavZAKA
    VyrZak->nRok       := YEAR( ::dUzavZAKA)
    VyrZak->nObdobi    := MONTH( ::dUzavZAKA)
    mh_WRTzmena( 'VYRZAK', .F.)
    * Uzavøení položek zakázky
    FOR n := 1 TO LEN( aRecIT)
      VyrZakIT->( dbGoTO( aRecIT[n]))
      VyrZakIT->cStavZakaz := 'U'
      VyrZakIT->dUzavZAKA  := ::dUzavZAKA
      VyrZakIT->nRok       := YEAR( ::dUzavZAKA)
      VyrZakIT->nObdobi    := MONTH( ::dUzavZAKA)
      *
      VyrZakIT->dZnovuOtvZ := VyrZak->dZnovuOtvZ
      VyrZakIT->cStavZakUz := VyrZak->cStavZakUz
      mh_WRTzmena( 'VYRZAKIT', .F.)
    NEXT
    VyrZAK->( dbUnlock())
    VyrZAKIT->( dbUnlock())
    *
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
  ELSE
    drgMsgBox(drgNLS:msg('ZAKÁZKU se nepodaøilo ukonèit,;'+;
                         'nebo související záznamy jsou blokovány jiným uživatelem !!!'))
    IF( LockZak  , VyrZAK->( dbUnlock())  , Nil )
    IF( LockZakIT, VyrZAKIT->( dbUnlock()), Nil )
  ENDIF

RETURN .T.

********************************************************************************
* VYR_VYRZAK_OPEN ...  Znovuotevøení uzavøené zakázky
********************************************************************************
CLASS VYR_VYRZAK_OPEN FROM drgUsrClass

EXPORTED:
  VAR     fromMENU, cAlias, cCisZakaz, cNazevZak1, dZnovuOtvZ
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  postValidate, VyrZak_sel, PostLastField

HIDDEN:
  VAR     dm
ENDCLASS

********************************************************************************
METHOD VYR_VYRZAK_OPEN:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VYRZAK'  )
  drgDBMS:open('VYRZAKIT')
  *
  ::cAlias     := parent:parent:dbName
  ::fromMENU   := ( ::cAlias = 'M')
  IF ::fromMENU
  ::cCisZakaz  := ''
  ::cNazevZak1 := ''
  ::dZnovuOtvZ := IF( EMPTY( VYRZAK->dZnovuOtvZ), DATE(), VYRZAK->dZnovuOtvZ )
  ELSE
    ::cCisZakaz  := (::cAlias)->cCisZakaz   //''
    ::cNazevZak1 := (::cAlias)->cNazevZak1  //''
    ::dZnovuOtvZ := IF( EMPTY( (::cAlias)->dZnovuOtvZ), DATE(), (::cAlias)->dZnovuOtvZ )
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_VyrZak_OPEN:drgDialogInit(drgDialog)
  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
RETURN self

********************************************************************************
METHOD VYR_VyrZak_OPEN:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
  IsEditGET( IF( ::fromMENU, {'M->cNazevZak1'},;
                             {'M->cCisZakaz', 'M->cNazevZak1'} ), drgDialog, .F.)
RETURN self

********************************************************************************
METHOD VYR_VYRZAK_OPEN:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_VyrZak_OPEN:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  cNAMe := UPPER(oVar:name)

*  IF lValid
    DO CASE
    CASE cName = 'M->CCISZAKAZ'
      IF !EMPTY( xVar) .and. lChanged
        lOK := ::VYRZAK_SEL()
      ENDIF

    ENDCASE
RETURN lOK

********************************************************************************
METHOD VYR_VyrZak_OPEN:VYRZAK_SEL( oDlg)
  LOCAL oDialog, nExit, Filter
  LOCAL cKey := Upper( ::dm:get('M->cCisZakaz'))
*  Local cKey := Upper(::dm:get( 'VyrZAKw->cCisZakaz')) + Value + StrZero( ::dm:get( 'VyrZAKw->nVarCis'), 3 )
  LOCAL lOK //:= ( !Empty(cKey) .and. VYRZAK->( dbSEEK( cKey,, 1)) )

  Filter := FORMAT("(VyrZak->cStavZakaz = '%%')", {'U'} )
  VyrZak->( mh_SetFilter( Filter))

  lOK := ( !Empty(cKey) .and. VYRZAK->( dbSEEK( cKey,, 'VYRZAK1')) )

  IF IsObject( oDlg) .or. ! lOk

    DRGDIALOG FORM 'VYR_VYRZAK_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF
  IF ( nExit != drgEVENT_QUIT )
    ::dm:set( 'M->cCisZAKAZ' , VyrZAK->cCisZAKAZ )
    ::dm:set( 'M->cNazevZak1', VyrZAK->cNazevZak1)
    ::dm:refresh()
  ENDIF
  VyrZAK->( mh_ClrFilter())

RETURN lOK

********************************************************************************
METHOD VYR_VYRZAK_OPEN:postLastField(drgVar)
  Local LockZAK, LockZakIT, aRecIT := {}, n

  LockZak := VyrZAK->( dbRLock())
  VyrZakIT->( AdsSetOrder(1), mh_SetSCOPE( Upper(VyrZAK->cCisZakaz)) )
  VyrZakIT->( dbEVAL( {|| aAdd( aRecIT, VyrZakIT->(RecNO()) ) }))
  LockZakIT := IF( LEN( aRecIT) = 0, .T., VyrZakIT->( sx_RLock( aRecIT)))
  *
  IF LockZak .and. LockZakIT
    IF drgIsYesNo(drgNLS:msg( 'Požadujete ukonèenou zakázku znovu otevøít ?' ))
      ::dm:save()
      * Znovuotevøení hlavièky zakázky
      VyrZak->cStavZakaz := CoalesceEmpty( VyrZak->cStavZakUz, '4')
      VyrZak->dZnovuOtvZ := ::dZnovuOtvZ
      VyrZak->cStavZakUz := ''

      VyrZak->dUzavZAKA  := CTOD('  .  .  ')
      VyrZak->nRok       := 0
      VyrZak->nObdobi    := 0
      mh_WRTzmena( 'VYRZAK', .F.)
      * Znovuotevøení položek zakázky
      FOR n := 1 TO LEN( aRecIT)
        VyrZakIT->( dbGoTO( aRecIT[n]))
        VyrZakIT->cStavZakaz := VyrZak->cStavZakaz
        VyrZakIT->dZnovuOtvZ := ::dZnovuOtvZ
        VyrZakIT->cStavZakUz := ''

        VyrZakIT->dUzavZAKA  := VyrZAK->dUzavZAKA
        VyrZakIT->nRok       := VyrZAK->nRok
        VyrZakIT->nObdobi    := VyrZAK->nObdobi
        mh_WRTzmena( 'VYRZAKIT', .F.)
      NEXT
      VyrZAK->( dbUnlock())
      VyrZAKIT->( dbUnlock())
      *
      if ::fromMENU
        ::dm:set( 'M->cCisZakaz' , ::cCisZakaz := ''  )
        ::dm:set( 'M->cNazevZak1', ::cNazevZak1 := '' )
        VyrZAK->( dbSeek( ::cCisZakaz,, 'VYRZAK1'))
        ::dm:refresh()
      endif
    ENDIF
      *
  ELSE
    drgMsgBox(drgNLS:msg('ZAKÁZKU se nepodaøilo znovu otevøít,;'+;
                         'nebo související záznamy jsou blokovány jiným uživatelem !!!'))
    IF( LockZak  , VyrZAK->( dbUnlock())  , Nil )
    IF( LockZakIT, VyrZAKIT->( dbUnlock()), Nil )
  ENDIF
  *
  if !::fromMENU
    PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
  endif
RETURN .T.

********************************************************************************
* VYR_VYRZAK_ODVED ...
********************************************************************************
CLASS VYR_VYRZAK_ODVED FROM drgUsrClass

EXPORTED:
  VAR     lNewREC
  VAR     nCelkODVED, nKVyrobeni

  METHOD  Init, drgDialogStart, EventHandled
  METHOD  PostValidate, PostLastField

HIDDEN
  VAR     dm, dc, nREC
  METHOD  CelkODVED, OdvListHD
ENDCLASS

********************************************************************************
METHOD VYR_VYRZAK_ODVED:init(parent)
  ::drgUsrClass:init(parent)

  ::lNewREC  := .F.
  ::nCelkOdved := ::nKVyrobeni := 0
  drgDBMS:open('ListHD'   )
  drgDBMS:open('ODVZAKw',.T.,.T.,drgINI:dir_USERfitm); ZAP
RETURN self

********************************************************************************
METHOD VYR_VyrZak_ODVED:drgDialogStart(drgDialog)
 LOCAL aInfo := { 'cCisZakaz', 'cNazevZak1', 'cStavZakaz',;
                  'M->nCelkOdved','nMnozPlano', 'nMnozZadan', 'nMnozVyrob', 'M->nKVyrobeni', 'nMnozFakt'}

  AEVAL( aInfo,;
   {|c| drgDialog:dataManager:has( IF( drgParse( c,'-') = c, 'VYRZAK->'+ c, c) ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {220, 220, 250} )) })

  ::dm := drgDialog:DataManager
  ::dc := drgDialog:dialogCtrl

  ODVZAK->( mh_SetScope( Upper( VYRZAK->cCisZakaz)) )
*  ODVZAK->( Ads_SetScope(SCOPE_TOP   , cScope),;
*            Ads_SetScope(SCOPE_BOTTOM, cScope),  DbGoTop() )
  ::CelkODVED()
RETURN self

********************************************************************************
METHOD VYR_VYRZAK_ODVED:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL cVyrobCisl, cMsg

  DO CASE
    CASE nEvent = drgEVENT_DELETE
*      VYR_ODVZAK_Del()
      IF OdvZAK->nMnozFAKT > 0
        cMsg := 'Toto odvedení zakázky nelze zrušit, nebo z nìj již bylo fakturováno !'
        drgMsgBox(drgNLS:msg( cMsg))
      ELSEIF drgIsYesNo( 'Zrušit odvedení zakázky ?' )
        IF ReplREC( 'VyrZAK')
          VyrZAK->nMnozVyrob -= OdvZAK->nMnozOdved
          VyrZAK->cStavZakaz := IIF( VyrZAK->nMnozVyrob == 0, '6',;
                                IIF( VyrZAK->nMnozVyrob < VyrZAK->nMnozPlano, '7 ', '8 ' ))
          VyrZak->dUzavZAKA  := CTOD( '  .  .  ')
          VyrZak->nRok       := 0
          VyrZak->nObdobi    := 0
          VyrZak->( dbUnlock())
          DelREC( 'OdvZAK')
          ::CelkODVED()
*          oXbp:refreshAll()
          ::dc:oaBrowse:oXbp:refreshAll()
          ::dm:refresh()
        ELSE
          drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
        ENDIF
      ENDIF

    CASE  nEvent = drgEVENT_SAVE
      IF oXbp:ClassName() <> 'XbpBrowse'
        ::PostLastField()
      ENDIF

    CASE nEvent = drgEVENT_EDIT
      ::lNewRec := .F.
      ::nRec := OdvZAK->( RecNO())
      mh_COPYFLD( 'ODVZAK', 'ODVZAKw', .T. )
      ::drgDialog:oForm:setNextFocus( 'ODVZAK->nMnozOdved',, .t. )

    CASE nEvent = drgEVENT_APPEND
      ::lNewRec := .T.
      ::nRec := OdvZAK->( RecNO())
      * zjistí výrobní èíslo u posledního odvedení a to pøednabídne
      OdvZAK->( dbGoBOTTOM())
      cVyrobCisl := IF( EMPTY( OdvZAK->cVyrobCisl), VyrZAK->cVyrobCisl ,;
                                                    OdvZAK->cVyrobCisl )
      *
      ODVZAK->( dbGoTO(-1) )
      ::dm:set( 'ODVZAK->nMnozOdved', MAX( 1, VyrZak->nMnozZadan - VyrZak->nMnozVyrob) )
      ::dm:set( 'ODVZAK->dDatumOdv' , DATE() )
      ::dm:set( 'ODVZAK->nCisloKusu', ODVZAK->nCisloKusu )
      ::dm:set( 'ODVZAK->cVyrobCisl', cVyrobCisl )
      ::dm:set( 'ODVZAK->cText'     , ODVZAK->cText      )
      *
      mh_COPYFLD( 'ODVZAK', 'ODVZAKw', .T. )
      ::drgDialog:oForm:setNextFocus( 'ODVZAK->nMnozOdved',, .t. )
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        IF oXbp:ClassName() <> 'XbpBrowse'
          IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
            oXbp:setColorBG( oXbp:cargo:clrFocus )
          ENDIF
          OdvZAK->( dbGoTO( ::nREC))
          SetAppFocus( ::dc:oaBrowse:oXbp)
          ::dc:oaBrowse:refresh()
          ::dm:refresh()
          RETURN .T.
        ELSE
          RETURN .F.
        ENDIF
      OTHERWISE
        RETURN .F.
      ENDCASE
  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD VYR_VyrZak_ODVED:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. ( !::lNewREC .and. lChanged))
  LOCAL  cNAMe := oVar:name, cKey,  nREC := OdvZAK->( RecNO())
  Local  nZbyvaVyrobit := VyrZak->nMnozZadan - VyrZak->nMnozVyrob //+ OdvTMP->nMnozOdved

  DO CASE
  CASE cName = 'ODVZAK->nMnozOdved'
    IF lChanged
      IF xVar < 0
        drgMsgBox(drgNLS:msg('Odvedené množství nesmí být záporné !'))
        lOK := .F.
      ELSEIF xVar < OdvZAK->nMnozFAKT
        drgMsgBox(drgNLS:msg('Nelze odvést ménì, než kolik již bylo vyfakturováno !;' + ;
                             'Vyfakturováno bylo : < & >', OdvZAK->nMnozFAKT ))
        lOK := .F.
      ELSEIF xVar >( VyrZak->nMnozZadan - ;
                   ( VyrZak->nMnozVyrob - OdvZAKw->nMnozOdved )) //  + OdvZAK->nMnozOdved))
        drgMsgBox(drgNLS:msg('Požadujete odvést více, než kolik zbývá vyrobit !;' + ;
                             'Zbývá vyrobit : < & >', nZbyvaVyrobit ))
      ENDIF
    ENDIF

  CASE cName = 'ODVZAK->nCisloKusu'
    IF !EMPTY( xVar) .and. lValid
       cKey := Upper( VyrZAK->cCisZakaz) + StrZERO( xVar, 6)
       IF OdvZAK->( dbSEEK( cKey)) .AND. ( OdvZAK->( RecNO()) <> nREC )
         drgMsgBox(drgNLS:msg('Duplicitní èíslo kusu !'))
         lOK := .F.
       ELSEIF xVar > VyrZAK->nMnozPlano
         drgMsgBox(drgNLS:msg('Èíslo kusu nesmí pøesáhnout plánované množství !;' + ;
                              'Množství plánované do výroby = < & >', VyrZAK->nMnozPlano ))
         lOK := .F.
       ENDIF
       OdvZAK->( dbGoTO( nREC))
    ENDIF
  ENDCASE

RETURN lOK

********************************************************************************
METHOD VYR_VYRZAK_ODVED:postLastField( drgVAR)
  LOCAL lOK, lOkML := .T., cText := ''
  LOCAL nMnOdved := ::dm:get( 'OdvZAK->nMnozOdved')

IF ::dm:changed()
  IF ( lOK :=  IF( ::lNewRec, AddREC( 'OdvZak'), ReplREC( 'OdvZak') ))
    ::dm:save()
    OdvZAK->cCisZakaz  := VyrZak->cCisZakaz
    OdvZAK->cCasODV    := IIF( ::lNewREC, TIME(), OdvZAK->cCasODV )
    OdvZAK->nMnozOdved := nMnOdved
    OdvZAK->dDatumOdv  := ::dm:get( 'OdvZAK->dDatumOdv'  )
    OdvZAK->nCisloKusu := ::dm:get( 'OdvZAK->nCisloKusu' )
    OdvZAK->cVyrobCisl := ::dm:get( 'OdvZAK->cVyrobCisl' )
    OdvZAK->cText      := ::dm:get( 'OdvZAK->cText'       )
    IF VyrZAK->nMnozVyrob - OdvZAKw->nMnozOdved + nMnOdved >= ;
       VyrZAK->nMnozPlano
       lOkML := ::OdvListHD()
       If lOkML .and. ReplRec( 'VyrZak')
          VyrZak->cStavZakaz := '8'
          VyrZak->dSkuOdvZak := OdvZAK->dDatumODV
          VyrZak->nMnozVyrob += - OdvZAKw->nMnozOdved + OdvZAK->nMnozOdved
          VyrZak->dUzavZAKA  := CTOD( '  .  .  ')
          VyrZak->nRok       := 0
          VyrZak->nObdobi    := 0
          cText := '... Probìhlo odvedení celé zakázky ...'
          drgMsgBox(drgNLS:msg( cText))
          VyrZak->( dbUnlock())
       Endif
    ELSEIF VyrZAK->nMnozVyrob - OdvZAKw->nMnozOdved + nMnOdved < ;
           VyrZAK->nMnozPlano
       If ReplRec( 'VyrZak')
          VyrZak->cStavZakaz := '7'
          VyrZak->dSkuOdvZak := OdvZAK->dDatumODV
          VyrZak->nMnozVyrob += - OdvZAKw->nMnozOdved + OdvZAK->nMnozOdved
          VyrZak->dUzavZAKA  := CTOD( '  .  .  ')
          VyrZak->nRok       := 0
          VyrZak->nObdobi    := 0
          cText := '... Probìhlo dílèí odvedení zakázky ...'
          drgMsgBox(drgNLS:msg( cText))
          VyrZak->( dbUnlock())
       Endif
    ENDIF
    mh_WRTzmena( 'OdvZAK',  ::lNewREC)
    IF lOkML .OR. !::lNewRec
       OdvZAK->cStavZakaz := VyrZAK->cStavZakaz
       OdvZAK->( dbUnlock())
    ELSE
       OdvZAK->( dbUnlock())
       DelREC( 'OdvZAK')
    ENDIF
  ENDIF
  ::lNewREC := .F.
  ::CelkODVED()
  *
  SetAppFocus(::dc:oaBrowse:oXbp)
  ::dc:oaBrowse:refresh()
  ::dm:refresh()
ENDIF

RETURN .T.

**HIDDEN************************************************************************
METHOD VYR_VYRZAK_ODVED:OdvListHD()
  Local lOK := YES, cMsg

  FOrdRec( { 'ListHD, 7' } )
  LISTHD->( mh_SetScope( Upper( VyrZak->cCisZakaz)) )
  Do While !ListHD->( Eof())
    lOK := If( ListHD->nKusyCelk <= ListHD->nKusyHotov, lOK, NO )
    ListHD->( dbSkip())
  EndDo
  LISTHD->( mh_ClrScope())
  FOrdRec()
  IF !lOK    // Nejsou ukonèeny všechny lístky
    cMsg := 'Nebyly ukonèeny všechny mzdové lístky !;;'       + ;
            'Odvedením zakázky bez ukonèení všech lístkù ;'   + ;
            'nebude správnì provedena kalkulace skuteèných ;' + ;
            'nákladù zakázky a výpoèet jednicových mezd. ;;'  + ;
            '  --- POŽADUJETE  ODVEDENÍ  ZAKÁZKY ? --- '
    lOK := drgIsYesNo( cMsg )
  ENDIF
RETURN lOK

**HIDDEN************************************************************************
METHOD VYR_VYRZAK_ODVED:CelkODVED()
  Local nRecNO := OdvZAK->( RecNO())

  * Aktualizace odvedeného mn. celkem
  ::nCelkODVED := 0
  OdvZAK->( dbGoTOP() ,;
            dbEVAL( {|| ::nCelkODVED += OdvZAK->nMnozOdved }) ,;
            dbGoTO( nRecNO) )
  * Aktualizace množství k vyrobení
  ::nKVyrobeni := VyrZAK->nMnozZadan - VyrZAK->nMnozVyrob
RETURN self



********************************************************************************
********************************************************************************
CLASS VYR_VyrZAK_SCRro FROM VYR_VyrZAK_SCR

EXPORTED:

  INLINE METHOD  Init(parent)
    ::VYR_VyrZAK_SCR:init( parent, .T. )
    ::drgDialog:formName := 'VYR_VyrZAK_SCR'
  RETURN self

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_APPEND  .or. ;
         nEvent = drgEVENT_APPEND2 .or. ;
         nEvent = drgEVENT_DELETE

      MsgForRO()
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_INS .or.  mp1 = xbeK_CTRL_DEL
        MsgForRO()
        RETURN .T.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

ENDCLASS