/*==============================================================================
  VYR_VyrZakMAT_scr.PRG
  Materiálové požadavky na zakázku
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg

==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

********************************************************************************
* SCR - Materiálové požadavky na zakázku
********************************************************************************
CLASS VYR_VyrZakMAT_TST FROM drgUsrClass
EXPORTED:

  METHOD  Init, EventHandled
  METHOD  TabSelect, ItemMarked

  METHOD  ZAK_MATERIAL        //  tl. Materiál
  METHOD  ZAK_PLANSKUT        //  tl. Plán vs. skut.
  METHOD  ZAK_MATERIAL_DEL    //  tl. Zrušit materiál

  HIDDEN
  VAR      tabNUM

ENDCLASS

*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:Init(parent)
  ::drgUsrClass:init(parent)

*  drgDBMS:open('VyrZAK' )
RETURN self

*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:EventHandled( nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE nEvent = drgEVENT_DELETE
    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.


*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:tabSelect( tabPage, tabNumber)
  ::tabNUM := tabNumber
  IF ::tabNUM = 2
    VyrZakIT->( mh_SetScope( Upper(VYRZAK->cCisZakaz)))
  ENDIF
  ::itemMarked()
*  ( ::RefreshBROW('FakVysIT'), ::RefreshBROW('FakVnpIT') )
*  ::RefreshBROW('VyrZAK')
RETURN .T.

*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:ItemMarked()

  IF ::tabNUM = 1          //
    OBJITEM->( mh_SetScope( Upper(VYRZAK->cCisZakaz)))
  ELSEIF ::tabNUM = 2
    OBJITEM->( mh_SetScope( Upper(VYRZAK->cCisZakaz)))
  ENDIF
RETURN SELF

/*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:ItemMarked()
 OBJITEM->( dbSetScope(SCOPE_BOTH, Upper(VYRZAK->cCisZakaz)), dbGoTOP() )
RETURN SELF
*/
*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:ZAK_MATERIAL()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakMAT_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
  *
  ObjITEM->( AdsSetOrder(9), dbGoTOP() )
  SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()
RETURN self

*
********************************************************************************
METHOD VYR_VyrZakMAT_TST:ZAK_PLANSKUT()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_VZakPLSK_SCR' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

* Zruší všechny materiálové požadavky ( obj.pøijaté) na zakázku
********************************************************************************
METHOD VYR_VyrZakMAT_TST:ZAK_MATERIAL_DEL()
  Local nCount := dbCOUNT( 'ObjITEM'), cKEY

  IF nCount == 0
    drgMsgBox(drgNLS:msg( 'Není co rušit - materiálové požadavky neexistují !' ), XBPMB_INFORMATION )
    RETURN NIL
  ENDIF
  *
  IF drgIsYESNO(drgNLS:msg('Zrušit materiálové požadavky na zakázku < & >  ?', VyrZak->cCisZakaz ) )
    IF( Used('ObjHEAD'), NIL, drgDBMS:open('ObjHEAD') )
    ObjITEM->( dbGoTOP())
    DO WHILE !ObjITEM->( EOF())
      VYR_CenZboz_MODI( drgEVENT_DELETE, .T.)
      VYR_Kusov_MODI()
      DelREC( 'ObjITEM')
      ObjITEM->( dbSKIP())
    ENDDO
    *
    cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
    IF ObjHead->( dbSeek( Upper( cKey),, 'OBJHEAD1'))
      DelREC( 'ObjHead')
    EndIF
    *
    SetAppFocus(::drgDialog:dialogCtrl:oBrowse[1]:oXbp)   // brow VyrZAK
    ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()   // brow ObjITEM
  ENDIF
RETURN self

/*
********************************************************************************
* Materiál pro zakázku
********************************************************************************
CLASS VYR_VZakMAT_SCR FROM drgUsrClass
EXPORTED:
  VAR     SklCena_MJ, SklCena_CELK

  METHOD  Init
  METHOD  drgDialogStart, drgDialogEnd
  METHOD  EventHandled
  METHOD  ItemMarked
  METHOD  PostValidate
  METHOD  PostLastField

  METHOD  VYR_VYRPOL_SEL, SKL_CENZBOZ_SEL

  Inline Access Assign  METHOD NazVyrPOL() VAR  NazVyrPOL
    Local cKEY := Upper( VyrZak->cCisZakaz) + Upper( ObjItem->cVyrPol) + ;
                  StrZero( ObjItem->nVarCis, 3)
    VyrPol->( dbSeek( cKey,,1))
  RETURN VyrPOL->cNazev

HIDDEN
  VAR   dm, dc
  VAR   nCislPolOb
ENDCLASS

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:Init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('VyrPOL'   ) ; AdsSetOrder(1)
  drgDBMS:open('CenZboz'  )
*  drgDBMS:open('Kusov'    )
  drgDBMS:open('ObjHEAD'  ) ; AdsSetOrder(2)
  *
RETURN self

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:drgDialogStart(drgDialog)
*  Local  members  := drgDialog:dialogCtrl:members[1]:aMembers, x
  /*
  For x := 1 TO Len(members)
    If members[x]:ClassName() = 'drgText' .and. !Empty(members[x]:groups)
      If 'clrINFO' $ members[x]:groups
        members[x]:oXbp:setColorBG( GraMakeRGBColor( {221, 221, 221}) )
      EndIf
    EndIf
  Next
  /
  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  *
  ColorOfTEXT( ::dc:members[1]:aMembers)
  *
  Filter := FORMAT("(ObjITEM->cCisZakaz = '%%')",{ VyrZAK->cCisZakaz } )
  ObjITEM->( mh_SetFilter( Filter))    // dbSetFilter( COMPILE( Filter)), dbGoTOP() )
*  OBJITEM->( dbSetScope(SCOPE_BOTH, Upper(VYRZAK->cCisZakaz)), dbGoTOP() )
  VYRPOL ->( dbSetScope(SCOPE_BOTH, Upper(VYRZAK->cCisZakaz)), dbGoTOP() )
  *
  IsEditGET( {'OBJITEM->nVarCis'    ,;
              'OBJITEM->nMnPotVyr'} ,  drgDialog, .F. )
  *
  ::dc:isAppend := .f.
  ::SklCena_CELK := ObjItem->nCenNapDod * ObjItem->nMnozPoOdb
  *
  ::dc:oBrowse[1]:oXbp:refreshAll()
  ::dm:refresh()

RETURN SELF

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:drgDialogEnd( drgDialog)

  * Po ukonèení dialogu se aktualizuje hlavièka obj.pøijaté
  VYR_ObjHEAD_Modi()
  *
  VYRPOL->( DbClearScope())
  ObjITEM->( mh_ClrFilter())     // dbClearFilter() )
RETURN

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:EventHandled( nEvent, mp1, mp2, oXbp)
  LOCAL nRecNo, lOK

  DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::dc:isAppend := .T.
      nRecNo := OBJITEM ->( RecNo())
      OBJITEM ->( DbGoTo(0))
      ::dm:refresh()
      OBJITEM->( DbGoTo(nRecNo))
      *
      ::dm:set( 'ObjITEM->dDatDoOdb' , DATE() )
      ::dm:set( 'ObjITEM->nMnKalkul' , 1      )
      ::dm:set( 'ObjITEM->nMnozObOdb', 1      )
      ::nCislPolOb := VYR_NewCisObjITEM()
      *
      IsEditGET( {'OBJITEM->cSklPOL'}, ::drgDialog, .T. )
      ::drgDialog:oForm:setNextFocus('ObjITEM->cSklPOL',, .T. )
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT
      ::dc:isAppend := .F.
      IsEditGET( {'OBJITEM->cSklPOL'}, ::drgDialog, .F. )
      ::drgDialog:oForm:setNextFocus('ObjITEM->dDatDoOdb',, .T. )
      ::nCislPolOb := ObjITEM->nCislPolOb
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
*      drgMsgBOX( 'Zatím není rušení položky objednávky povoleno ...')
      IF ObjItem->( RecNo()) <= ObjItem->( LastRec())
         IF drgIsYESNO(drgNLS:msg('Zrušit položku zakázky ?' ) )
           VYR_CenZboz_MODI( nEvent, .T. )
           VYR_Kusov_MODI()
           DelRec( 'ObjItem')
           ::dc:oaBrowse:oXbp:refreshAll()
           ::dm:refresh()
           IF dbCount( 'ObjItem') == 0
             * Po zrušení všech položek zrušit i hlavièku
             cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
             IF ObjHead->( dbSeek( Upper( cKey),,2 ))
               DelRec( 'ObjHead')
             ENDIF
           ENDIF
         ENDIF
      ENDIF
      RETURN .T.

    CASE  nEvent = drgEVENT_SAVE
      IF( oXbp:ClassName() <> 'XbpBrowse')
        ::postLastField()
      ENDIF
      RETURN .T.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
          oXbp:setColorBG( oXbp:cargo:clrFocus )
        ENDIF
        *
        SetAppFocus(::dc:oaBrowse:oXbp)
        ::dm:refresh()
        ::dc:isAppend := .F.
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    CASE nEvent = xbeM_LbClick
      IF oXbp:ClassName() = 'XbpGet' .and. oXbp:cargo:isEdit
        ::dc:isAppend := .F.
        ::nCislPolOb  := ObjITEM->nCislPolOb
*          PostAppEvent(drgEVENT_EDIT,,, oXbp)
      ENDIF
      RETURN .F.


    OTHERWISE
      RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:postLastField()
  LOCAL lOK

  IF ::dm:changed()
    IF ( lOK := IF( ::dc:isAppend, AddREC('ObjITEM'), ReplREC('ObjITEM') ) )
      IF( .not. ::dc:isAppend, VYR_CenZboz_MODI( drgEVENT_EDIT, .T. ), Nil )
      ::dm:save()
      VYR_CenZboz_MODI( drgEVENT_APPEND, !::dc:isAppend  )
      If ::dc:isAppend
        ObjItem->cCislObInt  := VyrZak->cCisZakaz
        ObjItem->nCislPolOb  := ::nCislPolOb
        ObjItem->nCisFirmy   := 1  //MyFIRMA   // Firmy->nCisFirmy
        ObjItem->cCisZakaz   := VyrZak->cCisZakaz
        ObjItem->cNazZbo     := CenZboz->cNazZbo
        ObjItem->nKlicNaz    := CenZboz->nKlicNaz
        ObjItem->cSklPol     := CenZboz->cSklPol
        ObjItem->cPolCen     := CenZboz->cPolCen
        ObjItem->nZboziKat   := CenZboz->nZboziKat
        ObjItem->nKlicDph    := CenZboz->nKlicDph
        ObjItem->cCisSklad   := CenZboz->cCisSklad
        ObjItem->cZkratJedn  := CenZboz->cZkratJedn
        ObjItem->nUcetSkup   := CenZboz->nUcetSkup
        ObjItem->nRokRV      := YEAR( DATE())
        ObjItem->nPolObjRV   := VYR_PolObjRV()
      EndIf
      FOrdREC( { 'CenZBOZ, 3' } )
      IF !::dc:isAppend
        CenZBOZ->( dbSEEK( Upper( ObjITEM->cCisSklad) + Upper( ObjITEM->cSklPOL)) )
      ENDIF
      ObjItem->nMnozNeOdb  := ObjItem->nMnozObOdb - ObjItem->nMnozPoOdb
      ObjItem->nKcsBdObj   := ObjItem->nMnozObOdb *  CenZBOZ->nCenaSZBO // ObjItem->nCenProDod
      ObjItem->nKcsBdObj   += VYR_PrirazkaCMP( 'ObjItem->nKcsBdObj' )
      ObjItem->nKcsZdObj   := ObjItem->nMnozObOdb * ;
                             ( CenZboz->nCenaSZBO * ( 1 + ( SeekKodDph( CenZboz->nKlicDph) / 100)))
      FOrdREC()
      ObjITEM->( dbUnlock())
      *
      SetAppFocus(::dc:oaBrowse:oXbp)
      ::dc:oaBrowse:oXbp:refreshAll()
      ::dm:refresh()
      ::dc:isAppend := .F.
    Endif
  ENDIF
RETURN .T.

*
********************************************************************************
METHOD VYR_VZakMAT_SCR:ItemMarked()
  LOCAL cKEY := Upper( VyrZak->cCisZakaz) + Upper( ObjItem->cVyrPol) + ;
                StrZero( ObjItem->nVarCis, 3)

  VyrPol->( dbSeek( cKey))
  ::SklCena_CELK := ObjItem->nCenNapDod * ObjItem->nMnozPoOdb
  *
  CenZBOZ->( dbSEEK( Upper( ObjITEM->cCisSklad) + Upper( ObjITEM->cSklPol),, 3) )
RETURN SELF
*
********************************************************************************
METHOD VYR_VZakMAT_SCR:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::dc:isAppend .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name)
  Local  nEvent := mp1 := mp2 := nil

  * F4
  nEvent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, lChanged := .t., nil)

  DO CASE
    CASE cName = 'ObjITEM->cSklPol'
      lKeyFound := CENZBOZ->(dbSEEK( Upper(xVar),,1))
      lOK := ::SKL_CENZBOZ_SEL( self, lKeyFound )

    CASE cName = 'ObjITEM->nMnKalkul'
      IF ( lOK := ControlDUE( oVar)) .AND. lValid
        ::dm:set( 'ObjITEM->nMnozObODB', xVar )
      ENDIF
    CASE cName = 'ObjITEM->nMnozObODB'
      lOK := ControlDUE( oVar)
    CASE cName = 'ObjITEM->nMnozPoODB'
      IF xVar > ::dm:get( 'ObjITEM->nMnozObODB')
        drgMsgBox(drgNLS:msg('Nelze potvrdit více než bylo objednáno !',, XBPMB_WARNING ))
        lOK := .F.
      ELSE
        ::dm:set( 'M->SklCena_CELK', xVar * CenZboz->nCenaSZbo )
      ENDIF
    CASE cName = 'ObjITEM->nMnozVpInt'
      If ( xVar + ::dm:get( 'ObjITEM->nMnozPoODB') > ::dm:get( 'ObjITEM->nMnozObODB') )
        drgMsgBox(drgNLS:msg('K výrobì + potvrzeno odbìratelem nemùže být vìtší než objednáno odbìratelem !',, XBPMB_WARNING ))
        lOk := .F.
      EndIf
    CASE cName = 'ObjITEM->cText2'
      If(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        ::postLastField()
      Endif

  ENDCASE
RETURN lOK

* Výbìr výrobní zakázky do karty objednávky pøijaté
********************************************************************************
METHOD VYR_VZakMAT_SCR:VYR_VYRPOL_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'VYR_VYRPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( 'ObjITEM->cVyrPol', VYRPOL->cVyrPOL )
    ::dm:set( 'ObjITEM->nVarCis', VYRPOL->nVarCis )
  ENDIF
RETURN lOK

* Výbìr skladové položky do karty objednávky pøijaté
********************************************************************************
METHOD VYR_VZakMAT_SCR:SKL_CENZBOZ_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( 'ObjITEM->cSklPOL'   , CENZBOZ->cSklPol )
    ::dm:set( 'ObjITEM->cNazZBO'   , CENZBOZ->cNazZBO )
    ::dm:set( 'ObjITEM->nCenNapDod', CenZboz->nCenaSZbo )
    ::dm:set( 'M->SklCena_CELK'    , CenZboz->nCenaSZbo )
  ENDIF
RETURN lOK

* Modifikace Ceníku pøi editaci objednávky pøijaté
*===============================================================================
PROCEDURE VYR_CenZboz_MODI( nEvent, lSeekCenik )
  Local cKey

  IF( Used('CenZboz') , NIL, drgDBMS:open('CenZboz'  ))
  fOrdRec( { 'CenZboz, 3' } )
  If lSeekCenik
     cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
     CenZboz->( dbSeek( cKey))
  Endif

  If ReplREC( 'CenZboz')
    Do Case
      Case ( nEvent == drgEVENT_APPEND)
        Do Case
          Case ObjItem ->nMnozPoOdb <= CenZboz ->nMnozDZbo
            ObjItem->nMnozKoDod := 0
            ObjItem->nMnozReOdb := ObjItem->nMnozPoOdb
            CenZboz->nMnozRZbo  += ObjItem->nMnozReOdb
            CenZboz->nMnozRSES  += ObjItem->nMnozReOdb
            CenZboz->nMnozDZbo  -= ObjItem->nMnozReOdb

          Case CenZboz ->nMnozDZbo <= 0
            ObjItem->nMnozKoDod := ObjItem->nMnozPoOdb
            CenZboz->nMnozKZbo  += ObjItem->nMnozPoOdb

          Case ( ObjItem->nMnozPoOdb > CenZboz->nMnozDZbo ) .and. ;
               CenZboz->nMnozDZbo > 0
            ObjItem->nMnozKoDod := ObjItem->nMnozPoOdb -CenZboz->nMnozDZbo
            CenZboz->nMnozKZbo  += ObjItem->nMnozKoDod
            Objitem->nMnozReOdb := CenZboz->nMnozDZbo
            CenZboz->nMnozRZbo  += ObjItem->nMnozReOdb
            CenZboz->nMnozRSES  += ObjItem->nMnozReOdb
            CenZboz ->nMnozDZbo -= ObjItem->nMnozReOdb
        EndCase
        ObjItem->nMnozNeOdb := ObjItem->nMnozObOdb - ObjItem->nMnozPoOdb
        If( CenZboz->nMnozDZbo < 0, CenZboz->nMnozDZbo := 0, Nil )

      Case ( nEvent == drgEVENT_EDIT) .or. ( nEvent == drgEVENT_DELETE)
        CenZboz->nMnozRZbo -= ObjItem->nMnozReOdb
        CenZboz->nMnozRSES -= ObjItem->nMnozReOdb
        CenZboz->nMnozKZbo -= ObjItem->nMnozKoDod
        CenZboz->nMnozDZbo += MIN ( ObjItem->nMnozReOdb,;
                                    Cenzboz->nMnozSZbo - Cenzboz->nMnozRZbo )
        If( CenZboz->nMnozRZbo < 0, CenZboz->nMnozRZbo := 0, Nil )
        If( CenZboz->nMnozRSES < 0, CenZboz->nMnozRSES := 0, Nil )
        If( CenZboz->nMnozKZbo < 0, CenZboz->nMnozKZbo := 0, Nil )
        If( CenZboz->nMnozDZbo < 0, CenZboz->nMnozDZbo := 0, Nil )
    EndCase
    CenZboz->( dbUnlock())
  EndIf
  fOrdRec()
Return Nil

* Modifikace KUSOV pøi zrušení obj. pøijaté
*===============================================================================
PROCEDURE VYR_Kusov_MODI()
  Local cKEY := Upper( ObjITEM->cCislObINT) + StrZERO( ObjITEM->nCislPolOB, 5 )

  IF( Used('KUSOV'), NIL, drgDBMS:open('KUSOV') )
  nREC := KUSOV->( RecNO())
  IF KUSOV->( dbSEEK( cKEY,,5))
    IF ReplREC( 'KUSOV')
      KUSOV->cCislObINT := SPACE( 30)
      KUSOV->nCislPolOB := 0
      KUSOV->( dbUnlock())
    ENDIF
  ENDIF
  KUSOV->( dbGoTO( nREC))
RETURN NIL

* Modifikace ObjHead pøi generování materiálových požadavkù
*===============================================================================
STATIC FUNCTION VYR_ObjHead_Modi()
  Local cKey := StrZero( 1, 5) + VyrZak->cCisZakaz
  Local nRec := ObjItem->( RecNo())
  Local lExist, lOK
  Local aX := { 0, 0, 0, 0, 0 }

 If ObjItem->( RecNo()) <= ObjItem->( LastRec())
   lExist := ObjHead->( dbSeek( Upper( cKey)))
   If ( lOK := If( lExist, ReplRec( 'ObjHead'), AddRec( 'ObjHead')) )
      If !lExist
        // ... dosud neexistuje Hl. obj. pøijaté, založí se.
        ObjHead->nCisFirmy  := 1  // MyFIRMA
        ObjHead->nCislObInt := VYR_NewCisObjHEAD( VyrZak->cCisZakaz)
        ObjHead->cCislObInt := VyrZak->cCisZakaz
        ObjHead->dDatObj    := Date()
        ObjHead->dDatDoOdb  := VyrZak->dOdvedZaka - VyrZak->nPlanPruZa
        ObjHead->cNazPracov := SysConfig( 'System:cUserAbb')
        ObjHead->cCisZakaz  := VyrZak->cCisZakaz
      Endif
      ObjItem->( dbGoTop())
      ObjItem->( dbEval( {||  aX[ 1] += 1                    ,;
                              aX[ 2] += ObjItem->nKcsBdObj   ,;
                              aX[ 3] += ObjItem->nKcsZdObj   ,;
                              aX[ 4] += ObjItem->nMnozObODB  ,;
                              aX[ 5] += ObjItem->nMnozPoODB   }))
      ObjHead->nPocPolObj := aX[ 1]
      ObjHead->nKcsBdObj  := aX[ 2]
      ObjHead->nKcsZdObj  := aX[ 3]
      ObjHead->nMnozObODB := aX[ 4]
      ObjHead->nMnozPoODB := aX[ 5]
      ObjHead->nCenaZakl  := ObjHead->nKcsBdObj
      ObjItem->( dbGoTo( nRec))
      ObjHead->( dbUnlock())
   Endif
 Endif
Return( Nil)

********************************************************************************
* Materiál na zakázku - Porovnání plánu a skuteènosti
********************************************************************************
CLASS VYR_VZakPLSK_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  ItemMarked
  METHOD  drgDialogStart
ENDCLASS

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:Init(parent)
  ::drgUsrClass:init(parent)
RETURN self

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:drgDialogStart(drgDialog)
  * Objednávky na zakázku firmy '00001'
  OBJITEM->( dbSetScope(SCOPE_BOTH, '00001' + Upper(VYRZAK->cCisZakaz)), dbGoTOP() )
  * Výdejky na zakázku
  PVPITEM->( dbSetScope(SCOPE_BOTH, Upper(VYRZAK->cCisZakaz) + '-1')   , dbGoTOP() )
RETURN SELF

*
********************************************************************************
METHOD VYR_VZakPLSK_SCR:ItemMarked()
  Local cScope := Upper(VYRZAK->cCisZakaz) + '-1'
  Local cKey := Upper( ObjItem->cCisSklad) + Upper( ObjItem->cSklPol)
  Local nRecNO := PVPItem->( RecNO())

  * Pøi pohybu nad objednávkami se dohledává PVPITEM
  If( PVPItem->( dbSeek( cScope + cKey )), NIL, PVPItem->( dbGoTO( nRecNO)) )
  ::drgDialog:dialogCtrl:oBrowse[2]:oXbp:refreshAll()

RETURN SELF
*/