/*==============================================================================
  SKL_VyrCis_pvp.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "gra.ch"
#include "..\SKLADY\SKL_Sklady.ch"


********************************************************************************
* Evidence výrobních èísel pøi pohybech
********************************************************************************
CLASS SKL_VyrCis_PVP FROM  drgUsrClass
EXPORTED:
  VAR     nSumMnoz
  VAR     cWarning
  VAR     cText1,cText2,cText3,cText4,cText5,cText6,cText7,cText8,cText9
  VAR     nZarukaT   , nZarukaR
  VAR     nKonZarukaD, nKonZarukaT, nKonZarukaR
  VAR     isPrijem, isNewPVP, isNewREC, cTypEvid

  METHOD  Init
  METHOD  Destroy
  METHOD  drgDialogInit
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  ItemMarked
  METHOD  SumColumn
  METHOD  PostValidate, PostLastField

HIDDEN
  VAR     dm, dc, brow, members
  METHOD  ZarukaCMP, NewOrdItem
  METHOD  ShowGroups

ENDCLASS

*
*********************************************************************************
METHOD SKL_VyrCis_PVP:Init(parent)
  ::drgUsrClass:init(parent)
  *
  ::cText1 := ::cText2 := ::cText3 := ::cText4 := ::cText5 := ;
  ::cText6 := ::cText7 := ::cText8 := ::cText9 := ''
  ::cWarning  := ''
  ::nSumMnoz := 0.00
  *
  ::nZarukaT := ::nZarukaR := 0
  ::nKonZarukaD := ::nKonZarukaT := ::nKonZarukaR := 0
  *
  ::isNewPVP := ( parent:cargo = xbeK_INS )
  ::isPrijem := ( PVPItemWW->nTypPoh = 1)
  ::cTypEvid := Upper( CenZboz->cVyrCis)
  *
  drgDBMS:open( 'VyrCIS')
  drgDBMS:open( 'VYRCISw',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open( 'VyrCIS',,,,,'VyrCIS_1')
  *
RETURN self

*
********************************************************************************
METHOD SKL_VyrCis_PVP:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += ' - metoda ' + ::cTypEvid
RETURN

*
********************************************************************************
METHOD SKL_VyrCis_PVP:drgDialogStart(drgDialog)
  Local n
  Local oVar, cText, cKey
  Local aPopis := {'VyrCisw->cPopis1', 'VyrCisw->cPopis2', 'VyrCisw->cPopis3',;
                   'VyrCisw->cPopis4', 'VyrCisw->cPopis5', 'VyrCisw->nValue1',;
                   'VyrCisw->nValue2', 'VyrCisw->nValue3', 'VyrCisw->nValue4'}

  ::dm   := drgDialog:dataManager
  ::dc   := drgDialog:dialogCtrl
  ::brow := drgDialog:dialogCtrl:oBrowse
  ::members := drgDialog:oForm:aMembers
  *
  _clearEventLoop(.t.)
  ColorOfTEXT( ::dc:members[1]:aMembers )
  ::ShowGroups()
  *
  ::dm:has('PVPITEMww->cSklPol' ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  ::dm:has('PVPITEMww->cSklPol' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221} ))
  ::dm:has('PVPITEMww->cNazZBO' ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  ::dm:has('M->nSumMnoz' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  ::dm:has('PVPITEMww->nMnozPrDod' ):oDrg:oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ))
  *
  ::dm:has('VyrCISw->nDoklad' + IF( ::isPrijem, '', 'V') ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  ::dm:has('VyrCISw->dDat' + IF( ::isPrijem, 'Prijem', 'Prodej') ):oDrg:oXbp:setColorFG( GRA_CLR_BLUE)
  /*
  FOR n := 1 TO LEN( aPopis)
    cText := 'cText' + Str( n, 1)
    ::&cText := SysConfig( 'Sklady:' + cText )
    oVar :=  ::dm:has( aPopis[ n]):oDrg
    oVar:isEdit := !EMPTY( ::&cText)
    IF( oVar:isEdit, oVar:oXbp:show(), oVar:oXbp:hide() )
  NEXT
  */

  FOR n := 1 TO LEN( aPopis)
    cText := 'cText' + Str( n, 1)
    ::&cText := SysConfig( 'Sklady:' + cText )
    oVar :=  ::dm:has( aPopis[ n]):oDrg
    oVar:isEdit := !EMPTY( ::&cText)
    IF( oVar:isEdit, oVar:oXbp:show(), oVar:oXbp:hide() )
  NEXT

  if ::isNewPVP
    VyrCISw->( dbZAP())
  ELSE
    VyrCIS->( AdsSetOrder( IF( ::isPrijem, 2, 3)))
    cKEY := Upper( PVPItemww->cCisSklad) + Upper( PVPItemww->cSklPol) +;
                   StrZero( PVPItemww->nDoklad, 10)
    VyrCIS->( mh_SetSCOPE( cKey))
    VyrCIS->( mh_CopyFld( 'VyrCIS', 'VyrCisw', .t.))
  ENDIF

  */
  ::itemMarked()
  *
  ::sumColumn()
  ::brow[1]:oXbp:refreshAll()
  SetAppFocus( ::brow[1]:oXbp)
  *
  IsEditGET( { 'VyrCisw->nZust'  ,;
               'M->nZarukaT'     , 'M->nZarukaR'      ,;
               'M->nKonZarukaD'  , 'M->nKonZarukaT'   , 'M->nKonZarukaR',;
               'VyrCisw->nDoklad', 'VyrCisw->nDokladV', 'VyrCisw->dDatPrijem', 'VyrCisw->dDatProdej'},;
               drgDialog, .F.)

RETURN self

*
********************************************************************************
METHOD SKL_VYRCIS_PVP:eventHandled(nEvent, mp1, mp2, oXbp)
  Local nRecNo, lOK := .T.

  DO CASE

    CASE (nEvent = xbeBRW_ItemMarked)
      ::ItemMarked()
      RETURN .F.

    CASE nEvent = drgEVENT_APPEND
      ::isNewREC := .T.
      nRecNo := VyrCisw->(RecNo())
         VyrCisw->(DbGoTo(-1))
         ::ZarukaCMP( 0)
         ::dm:refresh()
      VyrCisw->(DbGoTo(nRecNo))

      ::dm:has('VyrCisw->cVyrobCis' ):oDrg:isEdit := ::isNewREC
      ::drgDialog:oForm:setNextFocus('VyrCisw->cVyrobCis',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      ::isNewREC := .F.
      ::dm:has('VyrCisw->cVyrobCis' ):oDrg:isEdit := ::isNewREC
      ::drgDialog:oForm:setNextFocus('VyrCisw->nMnoz',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      IF ::isPrijem
        IF !Empty( VyrCisw ->cVyrobCis)
          IF drgIsYESNO(drgNLS:msg('Zrušit výrobní èíslo < & > ?', VyrCISw->cVyrobCis ))
           ( DelRec( 'VyrCisw'), VyrCisw->( dbUnlock())  )
           ::brow[1]:oXbp:refreshAll()
           ::sumColumn()
          ENDIF
        ENDIF
      ENDIF
      RETURN .T.

    CASE nEvent = drgEVENT_SAVE
       IF oXbp:ClassName() <> 'XbpBrowse'
         ::postLastField()
         SetAppFocus( ::brow[1]:oXbp)
         ::brow[1]:oXbp:refreshAll()
       ELSE
          PostAppEvent(xbeP_Close, nEvent,,oXbp)
       ENDIF

       RETURN .T.

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
          IF oXbp:ClassName() <> 'XbpBrowse'
            SetAppFocus( ::brow[1]:oXbp)
            ::brow[1]:oXbp:refreshAll()
            ::dm:refresh()
            RETURN .T.
          ENDIF
        Otherwise
          RETURN .F.
      EndCase

    CASE nEvent = xbeM_LbClick
      IF oXbp:ClassName() = 'XbpGet'
        IF !::dc:isAppend .and.  oXbp:cargo:isEdit
          PostAppEvent(drgEVENT_EDIT,,, oXbp)
        ENDIF
      ENDIF
      RETURN .F.

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

*
********************************************************************************
METHOD SKL_VyrCis_PVP:destroy()
  ::drgUsrClass:destroy()
  *
  ::cText1 := ::cText2 := ::cText3 := ::cText4 := ::cText5 := ;
  ::cText6 := ::cText7 := ::cText8 := ::cText9 := ;
  ::nZarukaT := ::nZarukaR := ::nKonZarukaD := ::nKonZarukaT := ::nKonZarukaR := ;
  ::nSumMnoz := ::cWarning := ::isPrijem := ;
  ::cTypEvid := ;
    NIL
RETURN self

*
********************************************************************************
METHOD SKL_VyrCIS_PVP:ItemMarked()
  ::ZarukaCMP( VyrCisw->nZaruka)
RETURN self

*
********************************************************************************
METHOD SKL_VyrCis_PVP:sumColumn( lValid)
  Local nRec := VyrCisw->( RecNo()), value, cText := ' = ', lOK := .T.
  Local cText2 :=  IF( ::isPrijem, 'pøijmout', 'vydat' )

  DEFAULT lValid TO .F.
  ::nSumMnoz := 0.00
  VyrCisw->( DbGoTop())
  VyrCisw->( dbEVAL( {||  ::nSumMnoz += VyrCisw->nMnoz } ))
  VyrCisw->( dbGoTO( nRec))
  *
  cText := IIF( ::nSumMnoz > PVPItemww->nMnozPrDod, ' > ',;
           IIF( ::nSumMnoz < PVPItemww->nMnozPrDod, ' < ', cText ))
**  ::cWarning := IF( EMPTY( cText), '', '<>  množství na dokladu !')
  ::cWarning := cText + '  množství na dokladu'
  ::dm:has('M->cWarning' ):oDrg:oXbp:setColorFG( IF( cText = ' = ', GRA_CLR_BLACK, GRA_CLR_RED ))
  *
  ::dm:refresh()

RETURN lOK

*
********************************************************************************
METHOD SKL_VyrCis_PVP:postValidate(drgVar)
  LOCAL  lOK := .T., lChanged := drgVAR:changed()
  LOCAL  value := drgVar:get(), cName := drgVar:name
  LOCAL  lValid := drgVar:oDrg:isEdit .and. lChanged
  LOCAL  nREC, cKEY, nPos, nVal

  IF lValid
    DO CASE
    CASE cName = 'VyrCISw->cVyrobCis'
      cKEY := Upper( PVPItemww->cCisSklad) + Upper( PVPItemww->cSklPol) + Upper( value)
      IF VyrCIS_1->( dbSEEK( cKEY,,'C_VYRC1') )
        drgMsgBox(drgNLS:msg( 'Duplicitní výrobní èíslo !'))
        lOK := .F.
      ENDIF
      IF lOK .and. ::cTypEvid = 'C'
        IF (( nPos := At( '-', value)) > 0 )
          nVal := VAL( SubStr( value, nPos+1 )) - ;
                  VAL( SubStr( value, 1, nPos -1)) + 1
          ::dm:set( 'VyrCisw->nMnoz', nVal )
        ENDIF
      ENDIF

    CASE cName = 'VyrCisw->nMnoz'
*      IF ::isNewREC .AND. ( ::nSumMnoz + value) > PVPITEM->nMnozPrDod
      IF ( ::nSumMnoz - drgVar:prevValue + value) > PVPITEMww->nMnozPrDod
        drgMsgBox(drgNLS:msg( 'Nelze zaevidovat vìtší množství než je na dokladu !'))
        lOK := .F.
      ENDIF

    CASE cName = 'VyrCisw->nZaruka'
      ::ZarukaCMP( value, .t.)
  *    ::dm:refresh()
    ENDCASE
  ENDIF
RETURN lOK

*
********************************************************************************
METHOD SKL_VyrCis_PVP:PostLastField( oVar)
  LOCAL lOK

**  IF lOK := ( ::isNewREC, AddREC('VyrCIS'), ReplREC( 'VyrCIS'))
  IF( ::isNewREC, VyrCISw->( dbAppend()), NIL )
  IF VyrCisw->( RLock())
    ::dm:save()
    VyrCisw->cCisSklad  := PVPItemww->cCisSklad
    VyrCisw->cSklPol    := PVPItemww->cSklPol
    *
    VyrCisw->cVyrobCis  := ::dm:get('VyrCISw->cVyrobCis')
    VyrCisw->nMnoz      := ::dm:get('VyrCISw->nMnoz')
    VyrCisw->nZust      := ::dm:get('VyrCISw->nZust')
    VyrCisw->nZaruka    := ::dm:get('VyrCISw->nZaruka')
    *
    IF ::isNewREC
      VyrCisw->nOrdItem := ::NewOrdItem()
    ENDIF
    IF ::isPrijem ;  VyrCisw->nDoklad    := PVPItemww->nDoklad
                     VyrCisw->dDatPrijem := PVPItemww->dDatPVP
                     VyrCisw->nMnozP     := VyrCisw->nMnoz
    ELSE          ;  VyrCisw->nDokladV   := PVPItemww->nDoklad
                     VyrCisw->dDatProdej := PVPItemww->dDatPVP
                     VyrCisw->nMnozV     := VyrCisw->nMnoz
   Endif
   VyrCisw->nZust := VyrCisw->nMnoz - VyrCisw ->nMnozV
   VyrCISw->( dbUnlock())
   *
   ::SumColumn()
   *
  ENDIF

RETURN .T.

*
*HIDDEN*************************************************************************
METHOD SKL_VyrCis_PVP:ZarukaCMP( nDNY, lValid)

   DEFAULT lValid TO .F.
  ::nZarukaT := INT( nDny / 7)
  ::nZarukaR := ROUND( nDny / 365, 2 )
  * do konce záruky
  ::nKonZarukaD := MAX( nDny - ( Date() - PVPItemww->dDatPVP), 0 )
  ::nKonZarukaT := MAX( INT( ::nKonZarukaD / 7)            , 0 )
  ::nKonZarukaR := MAX( ROUND( ::nKonZarukaD / 365, 2 )    , 0 )
  *
  IF lValid
    ::dm:set( 'M->nZarukaT'   , ::nZarukaT )
    ::dm:set( 'M->nZarukaR'   , ::nZarukaR )
    ::dm:set( 'M->nKonZarukaD', ::nKonZarukaD )
    ::dm:set( 'M->nKonZarukaT', ::nKonZarukaT )
    ::dm:set( 'M->nKonZarukaR', ::nKonZarukaR )
  ENDIF
  *
  ::dm:refresh()

RETURN self

*
*HIDDEN*************************************************************************
METHOD SKL_VyrCis_PVP:NewOrdITEM()
  Local nOrd := 0
  Local cScope := Upper( PVPItemww->cCisSklad) + Upper( PVPItemww->cSklPol )

  VyrCis_1->( AdsSetOrder( 8))
  VyrCIS_1->( mh_SetSCOPE( cScope), dbGoBottom() )
    nOrd := VyrCis_1->nOrdItem + 1
  VyrCIS_1->( mh_ClrSCOPE())
RETURN nOrd

*
*HIDDEN*************************************************************************
METHOD SKL_VyrCis_PVP:ShowGroups()
  Local n, members := ::drgDialog:oForm:aMembers

  FOR n := 1 TO LEN( members)
    IF IsMemberVar( members[n],'groups') .and. !EMPTY( members[n]:groups)
      IF (::cTypEvid $ members[n]:groups)
        members[n]:oXbp:show()
        IF( members[n]:ClassName() $ 'drgStatic,drgText', NIL, members[n]:isEdit := .T.)
      ELSE
        members[n]:oXbp:hide()
        IF( members[n]:ClassName() $ 'drgStatic,drgText', NIL, members[n]:isEdit := .F.)
      ENDIF
    ENDIF
  NEXT

RETURN self

/*
*===============================================================================
FUNCTION SKL_VyrCIS_Modi( nKEY)
  IF nKEY = xbeK_DEL
*** Dopracovat
   *
    If  lPrijem
      VyrCis->( AdsSetOrder( 2))
      cScope := Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPol) +;
                       StrZero( PVPItem->nDoklad, 10)
      SetScope( 'VyrCis', cScope)
      VyrCis->( dbEval( {|| ( DelRec( 'VyrCis'), DCrUnlock( 'VyrCis')) }))
      ClrScope( 'VyrCis')
    Else
      ( VyrCis->( AdsSetOrder( 3)), VyrCis->( dbGoTop()) )
      cScope := Cs_Upper( PVPItem->cCisSklad) + Cs_Upper( PVPItem->cSklPol) +;
                          StrZero( PVPItem->nDoklad)
      SetScope( 'VyrCis', cScope)
      anTag := {}
      VyrCis->( dbEval( {|| aAdd( anTag, VyrCis->( RecNo())) }))
      For n := 1 To Len( anTag )
        VyrCis->( dbGoTo( anTag[ n] ))
        If ReplRec( 'VyrCis')  ; VyrCis->nDokladV   := 0
                                 VyrCis->dDatProdej := CtoD( '  .  .  ')
                                 DCrUnlock( 'VyrCis')
        Endif
      Next
      ClrScope( 'VyrCis')
    ENDIF
    *
  ENDIF
RETURN NIL
*/