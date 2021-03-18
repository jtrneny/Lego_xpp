/*==============================================================================
  VYR_VyrPol1_scr.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_KUSOV_VP()       NazevVP()          ModVyr.Prg
  VYR_KUSOV_MjVP()     MjVP()             ModVyr.Prg
  VYR_KUSOV_TypVP()    TypVP()            ModVyr.Prg

==============================================================================*/
#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
*
********************************************************************************
CLASS VYR_VyrPol1_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  VAR     lDataFilter, FormIsRO
  VAR     cCil_Vyrpol, cZdroj_VyrPol


  METHOD  Init, drgDialogStart, EventHandled, ItemMarked, tabSelect
  METHOD  ComboItemSelected

  METHOD  KusTree_Full        // strukt. kusovník - plný rozpad
  METHOD  KusTree_First       // strukt. kusovník - jen 1. výr.stupeò
  METHOD  VyrPol_OperTree     // strukt. kusovník s operacemi OperTree
  METHOD  VyrPOL_IKUSOV
  METHOD  VyrPol_PRECISLUJ    // Pøeèíslování vyrábìné položky
  METHOD  VyrPol_NAHRADA      // Náhrada vyrábìné položky
  METHOD  VyrPol_Copy         // Kopie vyrábìné položky
  METHOD  KusOp_Copy          // Kopie kusovníku, operací k vyrábìné položce


  * pro test kalkulace
  inline method w_kalkul_Test()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus, cinfo
    local  ctime_Beg := time(), ctime_End

    drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)

    vyrPol->( dbgoTop())
    drgServiceThread:progressStart(drgNLS:msg('Probíhá test generování kusTree pro výpoèet kalkulace ...', 'VYRPOL'), VyrPOL->( LastREC()) )

    do while .not. vyrPol->( eof())

      if empty( VyrPOL->cCisZAKAZ)
        genTreeFile(0)
      endif

      vyrPol->( dbSkip())
      drgServiceThread:progressInc()

***      msgStatus:setCaption( 'vyrPol->' +str(vyrPol->(recNo()) ))
    enddo

    drgServiceThread:progressEnd()

    ctime_End := time()
    ::msg:WriteMessage( 'Start in: ' +ctime_Beg +'End in: ' +ctime_End, DRG_MSG_WARNING)
  return



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


********************************************************************************
  inline method w_kusTree_ex_Full()
    local  oDialog
    local  recNo := vyrPol->( recNo())
    local  ctag  := vyrPol->( ordSetFocus())

    DRGDIALOG FORM 'VYR_KusTREE_EX_SCR, 0' PARENT ::drgDialog MODAL DESTROY

    vyrPol->( OrdSetFocus( ctag))
    ::drgDialog:dialogCtrl:refreshPostDel()
  return self

  inline method w_operTree_ex()
    local  recNo := vyrPol->( recNo())
    local  ctag  := vyrPol->( ordSetFocus())

    DRGDIALOG FORM 'VYR_operTREE_EX_SCR' PARENT ::drgDialog MODAL DESTROY

    vyrPol->( OrdSetFocus( ctag))
    ::drgDialog:dialogCtrl:refreshPostDel()
  return self
********************************************************************************

HIDDEN
  VAR     msg, dm, dc, df, ab
  VAR     tabNUM, Areas, nArea, mainBro


  inline method info_in_msgStatus()
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo := '', oPs
    *
    local  curSize  := msgStatus:currentSize()
*    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
*                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
*                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }  }
    *
    local  paColors := { { graMakeRGBColor( {174, 255, 255} ), graMakeRGBColor( {  0, 183, 173} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {255, 183, 173} ), graMakeRGBColor( {251,  51,  40} ) }  }
    *
    local  cky := upper(vyrPol->ccisZakaz) +upper(vyrPol->cvyrPol) +strZero(vyrPol->nvarCis,3)


    cinfo := if( vyrZak->( dbseek( cky,, 'VYRZAK1')),'Zakázkový - ', 'Ne_Zakázkový - ' )

    if c_typPol->( dbseek( upper(vyrPol->ctypPol),,'TYPPOL1'))
      if right( allTrim(c_typPol->cnazTYPpol), 1) $ 'a,á'
        cinfo := strTran(cinfo, 'ý', 'á' )
      endif

      cinfo += c_typPol->cnazTYPpol
    endif

    msgStatus:setCaption( '' )
    picStatus:hide()

    ncolor := if( c_typPol->lfinal, 3, 1 )

    oPs := msgStatus:lockPS()
    GraGradient( oPs, {  0, 0 }    , ;
                      { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
    graStringAT( oPs, { 20, 4 }, cinfo )
    msgStatus:unlockPS()

    picStatus:setCaption( if(c_typPol->lfinal, DRG_ICON_MSGWARN, 0 ))
    picStatus:show()
  return

ENDCLASS

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('VYRPOL'  )
  drgDBMS:open('VYRPOLDT')
  drgDBMS:open('POLOPER' )
  drgDBMS:open('KUSOV'   )
  drgDBMS:open('NAKPOL'  )
  drgDBMS:open('c_typPol')

  *
  ::tabNUM        := 1
  ::lDataFilter   := 1
  ::cCil_Vyrpol   := ''
  ::cZdroj_VyrPol := ''
RETURN self

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:drgDialogStart(drgDialog)
  Local  oActions // := drgDialog:oActionBar:members
  Local  aEventsDisabled := 'vyrpol_precisluj,vyrpol_nahrada,vyrpol_copy,kusop_copy'
  *
  local  pa_quick := { { 'Kompletní seznam       ', ''                               }, ;
                       { 'Jen nezakázkové        ', 'ccisZakaz  = "               "' }, ;
                       { 'Jen   zakázkové        ', 'ccisZakaz <> "               "' }, ;
                       { ''                       , ''                               }  }

  c_typPol->( dbEval( { || aadd( pa_quick, { '(' +c_typPol->ctypPol +') _ ' +c_typPol->cnazTYPpol, ;
                                             'ctypPol = "' +c_typPol->ctypPol +'"' } ) }         ) )



  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form

  ::msg:can_writeMessage := .f.

  ColorOfText( drgDialog:dialogCtrl:members[1]:aMembers)
   *
   ::Areas := { drgDialog:odBrowse[1], drgDialog:odBrowse[2] }
   ::nArea := 1
   ::mainBro := drgDialog:odBrowse[1]
   *
   ::formIsRO := drgDialog:dialogCtrl:isReadOnly
   IF FormIsRO( drgDialog:FormName)
     drgDialog:SetReadOnly( .T.)
     ::formIsRO := drgDialog:dialogCtrl:isReadOnly
     oActions := drgDialog:oActionBar:members
     for x := 1 to len(oActions)
        if ( lower( oActions[x]:event) $ aEventsDisabled)
          oActions[x]:disabled := .t.
          oActions[x]:parent:amenu:disableItem( x)
          oActions[x]:oXbp:setColorFG( GraMakeRGBColor({128,128,128}))
        endif
     next
   ENDIF

   ::quickFiltrs:init( self, pa_quick, 'vyrPoložky' )
RETURN self


METHOD VYR_VyrPol1_SCR:comboItemSelected( Combo)
  Local Filter

  ::lDataFilter := Combo:value
  Do Case
  Case Combo:value = 1                          // Všechny položky
    IF( EMPTY(VyrPol->(ads_getAof())), NIL, VyrPol->(ads_clearAof(),dbGoTop()) )

  Case Combo:value = 2                          // Jen nezakázkové
    Filter := "cCisZakaz = '%%'"
    Filter := Format( Filter,{ EMPTY_VYRPOL})
    VyrPol->( mh_SetFilter( Filter))

  Case Combo:value = 3                          // Jen zakázkové
    Filter := "cCisZakaz <> '%%'"
    Filter := Format( Filter,{ EMPTY_VYRPOL})
    VyrPol->( mh_SetFilter( Filter))
  EndCase
  *
  ::mainBro:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::mainBro:oxbp)
  SetAppFocus(::mainBro:oXbp)

RETURN .T.

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_APPEND
    IF ::formIsRO
      MsgForRO()
      RETURN .T.
    ELSE
      RETURN .F.
    ENDIF

  CASE nEvent = drgEVENT_APPEND2
    ::VyrPol_Copy()
  CASE nEvent = drgEVENT_DELETE
    IF ::formIsRO
      MsgForRO()
      RETURN .T.
    ENDIF
    *
    VyrPOL_OnDELETE()
**      oXbp:cargo:refresh()
    ::drgDialog:dialogCtrl:oaBrowse:refresh()
    RETURN .T.
  *
  CASE nEvent = xbeM_LbClick
    IF oXbp:ClassName() = 'XbpCellGroup'
      nPos := aScan( ::Areas, {|o| o:cFile = ::drgDialog:dialogCtrl:oaBrowse:cFile})
      ::nArea := IF( nPos > 0, nPos, ::nArea )
    ENDIF
  *
  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ALT_F12
*      IF oXbp:ClassName() = 'XbpBrowse'
*        nPos := aScan( ::Areas, {|o| o:cFile = ::drgDialog:dialogCtrl:oaBrowse:cFile})
*        ::nArea := IF( nPos > 0, nPos, ::nArea )
        Do Case
        Case ::nArea = 1  ;  IF( ::tabNUM = 2, ::nArea++, Nil )
        Case ::nArea = 2  ;  ::nArea := 1
        EndCase
        oldXbp := SetAppFocus( ::Areas[ ::nArea]:oXbp )
        oldXbp:dehilite()
        ::Areas[ ::nArea]:oXbp:hilite()
*      EndIf
    CASE mp1 = xbeK_CTRL_C
      ::cCil_Vyrpol := STR( VyrPOL->( RecNO()) )
    CASE mp1 = xbeK_CTRL_Z
      ::cZdroj_Vyrpol := STR( VyrPOL->( RecNO()) )
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
 RETURN .T.

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:ItemMarked()
  Local cScope := Upper(VYRPOL->cCisZakaz)+ Upper(VYRPOL->cVyrPol)

*  IF ::tabNUM = 2
  KUSOV ->( mh_SetScope( cScope))

  ::info_in_msgStatus()
*  ENDIF
RETURN SELF

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:tabSelect( tabPage, tabNumber)

  ::tabNUM := tabNumber
  IF ::tabNUM = 2
    ::itemMarked()
  ENDIF
RETURN .T.

* Strukt. kusovník - plnì rozbalený
********************************************************************************
METHOD VYR_VyrPol1_SCR:KusTree_Full()
  LOCAL  oDialog
  local  recNo := vyrPol->( recNo())
  local  ctag  := vyrPol->( ordSetFocus())

*  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_KusTREE_SCR, 0' PARENT ::drgDialog MODAL DESTROY
*  ::drgDialog:popArea()                  // Restore work area

  vyrPol->( OrdSetFocus( ctag))
  ::drgDialog:dialogCtrl:refreshPostDel()
RETURN self

* Strukt. kusovník - rozbalený jen 1. výr. stupeò
********************************************************************************
METHOD VYR_VyrPol1_SCR:KusTree_First()
LOCAL oDialog

*  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_KusTREE_SCR, 1' PARENT ::drgDialog MODAL DESTROY
*  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Inverzní kusovník k vyrábìné položce
********************************************************************************
METHOD VYR_VyrPol1_SCR:VyrPol_IKUSOV()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_IKUSOV_SCR' CARGO 1 PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Kusovník s operacemi
********************************************************************************
METHOD VYR_VyrPol1_SCR:VyrPol_OperTree()
LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'VYR_OperTREE_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()
RETURN self

* Pøeèíslování vyrábìné položky
********************************************************************************
METHOD VYR_VyrPol1_SCR:VyrPol_PRECISLUJ()
LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VyrPOL_Nahrad' CARGO 1 PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Náhrada vyrábìné položky
********************************************************************************
METHOD VYR_VyrPol1_SCR:VyrPol_NAHRADA()
  LOCAL oDialog

  IF ::formIsRO  // ::drgDialog:dialogCtrl:isReadOnly
    MsgForRO()
    RETURN self
  ENDIF
  *
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VyrPOL_Nahrad' CARGO 2 PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
********************************************************************************
METHOD VYR_VyrPol1_SCR:VyrPol_Copy()
  LOCAL oDialog
  LOCAL cTag := VyrPol->( OrdSetFocus())

  IF ::formIsRO
    MsgForRO( 'Kopírování není povoleno ...')
    RETURN self
  ENDIF

  DRGDIALOG FORM 'VYR_VYRPOL_CRD'CARGO drgEVENT_APPEND2 PARENT ::drgDialog MODAL DESTROY

  VyrPol->( AdsSetOrder(cTag))
  ::drgDialog:dialogCtrl:oBrowse[1]:refresh()

RETURN self

* Kopie kusovníku, operací a podøízených položek k vyrábìné položce
********************************************************************************
METHOD VYR_VyrPol1_SCR:KusOp_Copy()
  LOCAL oDialog

  IF ::formIsRO  // ::drgDialog:dialogCtrl:isReadOnly
    MsgForRO()
    RETURN self
  ENDIF

*  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VYRPOL_copy' CARGO ::cZdroj_VyrPol + ',' + ::cCil_VyrPol ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::mainBro:oxbp:refreshAll()
*  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Zobrazení sloupce v SCR :  položka, název položky
*===============================================================================
Function VYR_KUSOV_VP()
  Local cRet, cKey, cTag //, cFileFLT := FHOMAdr() + '\TMP\VpFilt.Flt'
  Local nRec, nHandle, nArea
  Static cNazVP

  If Empty( Kusov->cNizPol)
     If IsNil( cNazVP)
        cKey := Kusov->cSklPol
        nRec := NakPol->( RecNo())
        cTag := NakPol->( AdsSetOrder( 1))
        NakPol->( dbSeek( Upper( cKey)))
        cRet := NakPol->cSklPol
        cNazVP := Left( NakPol->cNazTpv, 30)
        NakPol->( AdsSetOrder( cTag), dbGoTo( nRec))
     Else
        cRet   := cNazVP
        cNazVP := NIL
     Endif
  Else
     If IsNil( cNazVP)
        nRec := VyrPol->( RecNo())
        cTag := VyrPol->( AdsSetOrder( 1))
        nArea := SELECT()
        /*
        dbSelectAREA( 'VyrPOL')
        nHandle := M6_GetAreaFILTER()
        IF nHandle <> 0
           M6_FiltSave( nHandle, cFileFLT )
           VyrPol->( dbClearFILTER())
        Endif
        */
        cKey := Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) + ;
                StrZero( Kusov->nNizVar, 3)
        VyrPol->( dbSeek( cKey))
        cRet := VyrPol->cVyrPol
        cNazVP := Left( VyrPol->cNazev, 30)
        /*
        IF nHandle <> 0
           M6_FiltRestore( cFileFLT )
           M6_SetAreaFILTER( nHandle)
        ENDIF
        */
        VyrPol->( AdsSetOrder( cTag), dbGoTo( nRec))
        dbSelectArea( nArea)
     Else
        cRet   := cNazVP
        cNazVP := NIL
     Endif
  EndIf
Return( cRet)

* Zobrazení sloupce v SCR :  MJ nakupované / vyrábìné položky
*===============================================================================
Function VYR_KUSOV_MjVP()
  Local cRet := Space( 3), cKey, cTag
  Local nRec, lNakPol

  lNakPol := Empty( Kusov->cNizPol) .and. !Empty( Kusov->cSklPol)
  If lNakPol
     cKey := Kusov->cSklPol
     nRec := NakPol->( RecNo())
     cTag := NakPol->( AdsSetOrder( 1))
     NakPol->( dbSeek( Upper( cKey)))
     cRet := NakPol->cZkratJEDN
     NakPol->( AdsSetOrder( cTag), dbGoTo( nRec))
  Else
     cKey := Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) + ;
             StrZero( Kusov->nNizVar, 3)
     nRec := VyrPol->( RecNo())
     cTag := VyrPol->( AdsSetOrder( 1))
     VyrPol->( dbSeek( cKey))
     cRet := VyrPol->cZkratJEDN
     VyrPol->( AdsSetOrder( cTag), dbGoTo( nRec))
  Endif
Return( cRet)

* Zobrazení sloupce v SCR :  TYP nakupované / vyrábìné položky
*===============================================================================
Function VYR_KUSOV_TypVP()
  Local cRet := Space( 3), cTag
  Local cKey := Upper( Kusov->cCisZakaz) + Upper( Kusov->cNizPol) + StrZero( Kusov->nNizVar, 3)
  Local nRec := VyrPol->( RecNo())

  If Empty( Kusov->cNizPol)
//     cRet := '*NP'
     cTag := NakPol->( AdsSetOrder( 1))
     NakPol->( dbSeek( Upper( Kusov->cSklPol)))
     cRet := NakPol->cTypMat
     NakPol->( AdsSetOrder( cTag))
  Else
     cTag := VyrPol->( AdsSetOrder( 1))
     VyrPol->( dbSeek( cKey))
     cRet := VyrPol->cTypPol
     VyrPol->( AdsSetOrder( cTag), dbGoTo( nRec) )
  EndIf
Return( cRet)


#DEFINE   PRECISLOVANI_VP    1
#DEFINE   NAHRADA_VP         2

********************************************************************************
* VYR_VyrPOL_Nahrad ... Náhrada vyrábìné položky
********************************************************************************
CLASS VYR_VyrPOL_Nahrad FROM drgUsrClass

EXPORTED:
  VAR     newZAK, newPOL, newVAR
  VAR     nAction, aAction, cAction
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled
  METHOD  postValidate
  METHOD  But_Save

HIDDEN
  VAR     dm
  METHOD  ReWrtKUSOV, ReWrtPOLOPER
ENDCLASS

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:init(parent)
  ::drgUsrClass:init(parent)

  ::nAction := parent:cargo
  ::aAction := { 'Pøeèíslování ', 'Náhrada '}
  ::cAction := ::aAction[ ::nAction]

  ::newZAK := ::newPOL := ''
  ::newVAR := 0
  *
RETURN self

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:drgDialogInit(drgDialog)

  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
  drgDialog:Title := ::aAction[ ::nAction]
RETURN self

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:drgDialogStart(drgDialog)
  ::dm := drgDialog:dataManager
RETURN self

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_SAVE
    ::But_Save()

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

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:postValidate( oVar)
  LOCAL xVar  := oVar:get()
  LOCAL cName := UPPER(oVar:name), cKEY
  Local lOK := .T.,  nRec := VyrPol->( RecNo())
  Local cMsg  := IF( ::nAction = PRECISLOVANI_VP, 'JIŽ EXISTUJE', 'NEEXISTUJE' )

  DO CASE
    CASE cName = 'M->newVAR'
      cKey := PADR( Upper( ::dm:get( 'M->newPOL')),15) + StrZERO( xVar, 3)
      lOK := VyrPOL->( dbseek( cKey,, 'VYRPOL4'))
*      lOK := VyrPOL->( dbseek( PADR( Upper( ::newPOL),15) + StrZERO( ::NEWvar, 3),, 4))
      lOK := IF( ::nAction = PRECISLOVANI_VP, !lOK, lOK )
      IF lOK
         VyrPol->( dbGoTo( nRec))
*         PostAppEvent( drgEVENT_SAVE,,,::drgDialog:dialog)
      ELSE
        drgMsgBox(drgNLS:msg( ::cAction + '- nelze provést, nebo zadaná vyrábìná položka ' + cMsg + ' !'))
      ENDIF
  ENDCASE
  /*
*  IF dm:changed()
    IF ReplREC( 'VyrZak')
      dm:save()
      VyrZak->cStavZakaz := 'U'
      VyrZak->dUzavZAKA  := ::dUzavZAKA
      VyrZak->nRok       := YEAR( ::dUzavZAKA)
      VyrZak->nObdobi    := MONTH( ::dUzavZAKA)
      ** mh_WRTzmena( 'VYRZAK', .F.)
      VyrZAK->( dbUnlock())
      PostAppEvent(xbeP_Close, drgEVENT_SAVE,,::drgDialog:dialog)
    ENDIF
*  ENDIF
*/
RETURN lOK
*/

/*
  If LastKey() == K_CTRL_W
     cNewZak := GetList[ 1]:VarGet()
     cNewPol := GetList[ 2]:VarGet()
     nNewVar := GetList[ 3]:VarGet()
     cKey := Cs_Upper( cNewPol) + StrZero( nNewVar)
     lOK := VyrPol->( dbSeek( cKey))
     lOK := If( nTyp == 1, !lOK, lOK )
     If lOK    //   VyrPol->( dbSeek( cKey))
        VyrPol->( dbGoTo( nRec))
        If( lOK := AskForReWrt( nTyp) )
           ReWrtKusov( cNewZak, cNewPol, nNewVar)
           ReWrtPolOper( cNewZak, cNewPol)
           If nTyp == 1  // pýeŸ¡slov n¡
              If ReplRec( 'VyrPol') ;  VyrPol->cCisZakaz := cNewZak
                                       VyrPol->cVyrPol   := cNewPol
                                       VyrPol->cVysPol   := cNewPol
                                       VyrPol->cNizPol   := cNewPol
                                       VyrPol->nVarCis   := nNewVar
                                       DCrUnlock( 'VyrPol')
              Endif
           Endif
        EndIf
     Else
       Box_Alert( cEM,;
        If( nTyp == 1, "Nelze pýeŸ¡slovat, neboœ polo§ka ji§  existuje !",;
                       "Nelze prov‚st n hradu, neboœ polo§ka neexistuje." ), acWAIT,,10, 20 )
     Endif
  EndI
*/

*
********************************************************************************
METHOD VYR_VyrPOL_Nahrad:But_Save()
  LOCAL cKEY
  LOCAL aKusovN := {}, aKusovV := {}, aPolOper := {}
  LOCAL lKusovN, lKusovV, lPolOper, lVyrPol, lOK
  Local cMsg  := IF( ::nAction = PRECISLOVANI_VP,;
                     'Pøi pøeèíslování dojde k  náhradì vyrábìné položky: ;' + ;
                     '   - v databázi kusovníkù;' + ;
                     '   - v databázi operací k vyrábìným položkám ;' + ;
                     '   - v databázi vyrábìných položek ;;' + ;
                     'Skuteènì chcete pøeèíslovat ?' ,;
                     'Pøi náhradì dojde k  náhradì vyrábìné položky: ;' + ;
                     '   - v databázi kusovníkù;' + ;
                     '   - v databázi operací k vyrábìným položkám ;' + ;
                     'Skuteènì chcete provést náhradu ?' )

  drgMsgBox(drgNLS:msg('Save ...'))

  ::dm:save()
  IF drgIsYesNo(drgNLS:msg( cMsg ))
    * KUSOV - nahradí na pozici nižší položky + varianty
    cKey := Upper( VyrPol->cCisZakaz) + Upper( VyrPol->cVyrPol) + StrZero( VyrPol->nVarCis, 3)
    KUSOV->( AdsSetOrder( 2), mh_SetScope( cKey)    ,;
             dbEval( {|| AADD( aKusovN, Kusov->( RecNO()) ) }) ,;
             mh_ClrScope() )
    lKusovN := IF( LEN( aKusovN) = 0, .T., KUSOV->( sx_RLOCK( aKusovN)) )

    * KUSOV - nahradí na pozici vyšší položky
    cKey := Upper( VyrPol->cCisZakaz) + Upper( VyrPol->cVyrPol)
    KUSOV->( AdsSetOrder( 1), mh_SetScope( cKey)   ,;
             dbEval( {|| AADD( aKusovV, Kusov->( RecNO()) ) }) ,;
             mh_ClrScope() )
    lKusovV := IF( LEN( aKusovV) = 0, .T., KUSOV->( sx_RLOCK( aKusovV)) )

    *
    POLOPER->( AdsSetOrder( 1), mh_SetScope( cKey) ,;
               dbEval( {|| AADD( aPolOper, POLOPER->( RecNO()) ) }) ,;
               mh_ClrScope() )
    lPolOper := IF( LEN( aPolOper) = 0, .T., POLOPER->( sx_RLOCK( aPolOper)) )

*    ::ReWrtKUSOV()
*    ::ReWrtPOLOPER()
    IF ::nAction = PRECISLOVANI_VP
      lVyrPOL := VyrPOL->( dbRLock())
    ELSE
      lVyrPOL := .T.
    ENDIF

//    lVyrPOL := .F.  // TST
    lOK := ( lKusovN .and. lKusovV .and. lPolOper .and. lVyrPol )
    IF lOK
      * AKTUALIZACE SOUBORÙ
      FOR n := 1 TO LEN( aKusovN)
        KUSOV->( dbGoTO( aKusovN[ n]) )
        Kusov->cCisZakaz := ::NewZak
        Kusov->cNizPol   := ::NewPol
        Kusov->nNizVar   := ::NewVar
      NEXT
      FOR n := 1 TO LEN( aKusovV)
        KUSOV->( dbGoTO( aKusovV[ n]) )
        Kusov->cCisZakaz := ::NewZak
        Kusov->cVysPol   := ::NewPol
      NEXT
      FOR n := 1 TO LEN( aPolOper)
        POLOPER->( dbGoTO( aPolOper[ n]) )
        POLOPER->cCisZakaz := ::NewZak
        POLOPER->cVyrPol   := ::NewPol
      NEXT
      IF ::nAction = PRECISLOVANI_VP
        VyrPol->cCisZakaz := ::NewZak
        VyrPol->cVyrPol   := ::NewPol
        VyrPol->cVysPol   := ::NewPol
        VyrPol->cNizPol   := ::NewPol
        VyrPol->nVarCis   := ::NewVar
      ENDIF
    ELSE
      drgMsgBox(drgNLS:msg( ::cAction + ' - NELZE PROVÉST, nebo záznamy jsou blokovány jiným uživatelem !'))
    ENDIF
    *
    KUSOV->( dbUnlock())
    POLOPER->( dbUnlock())
    VYRPOL->( dbUnlock())
  ENDIF

RETURN NIL

*
* HIDDEN************************************************************************
METHOD VYR_VyrPOL_Nahrad:ReWrtKUSOV()

RETURN NIL

*
* HIDDEN************************************************************************
METHOD VYR_VyrPOL_Nahrad:ReWrtPOLOPER()

RETURN NIL

/********************************************************************************
********************************************************************************
CLASS VYR_VyrPol1_SCRx FROM VYR_VyrPol1_SCR

EXPORTED:
  VAR    VyrPOLro

  INLINE METHOD  Init(parent)
    ::VYR_VyrPol1_SCR:init( parent, .T. )
*    ::drgDialog:formName := 'VYR_VyrPol1_SCR'
  RETURN self
ENDCLASS
*/