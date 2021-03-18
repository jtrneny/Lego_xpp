#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "drg.ch"
#include "DRGres.Ch'

#include "..\VYROBA\VYR_Vyroba.ch"

#define ItemsKALK       11   // poèet položek Kalkulace ( ::aVarPLAN)

#define ZA_VYRPOL_ZAK    1  // kalkulace za vyr.pol. zakázkovou
#define ZA_VYRPOL_ALL    2  // kalkulace za vyr.pol. globálnì - všechny zakázky

* CFG
STATIC nPrMatKAL
*
STATIC nDruhCeny
STATIC acDenikNE

********************************************************************************
*
********************************************************************************
CLASS VYR_Kalkul_CRD FROM drgUsrClass
EXPORTED:
  * CFG
  VAR     nKoefPOJ                // Sazba pojistného
//  VAR     acDenikNE               // Deníky nezahrnované do výsl.kalkulace
  VAR     nVypRez                 // Výpoèet režií
  VAR     cDenikSKL               //
  VAR     nPrMatKal               //  Výpoèet výsledného pøímého materiálu
  VAR     nFaktMnoz               //  Fakturované mn. pro výrobu
  VAR     nKalkNED                //  Kalkulace nedokonèené výroby
  VAR     cNazRezie1, cNazRezie2, cNazRezie3, cNazRezie4
  *
  VAR     nMnKalk                 // Kalkulované množství                          f
  VAR     nCenMatZMP, nCenMatZMS
  VAR     nCenMatMJP, nCenMatMJS, nProcMatS
  VAR     nCenMzdVDP, nCenMzdVDS, nProcMzdS
  VAR     nCenOstatP, nCenOstatS
  VAR     nCenSluzbP, nCenSluzbS
  VAR     nCenEnergP, nCenEnergS
  VAR     nCenMajetP, nCenMajetS
  VAR     nRezOdbytP, nRezOdbytS
  VAR     nRezVyrobP, nRezVyrobS
  VAR     nRezZasobP, nRezZasobS
  VAR     nRezSpravP, nRezSpravS
  VAR     nCenKalkP, nCenKalkS
  VAR     nZiskP   , nZiskS     , nProcZiskS
  VAR     nCenProdP, nCenProdS
  VAR     aVarPLAN , aVarSKUT
  VAR     lNewREC
  VAR     cFILE
  VAR     cActiveGET, nSumaKALK, nSumaCAS
  VAR     lPrepKalALL                  // pøepoèet celé kalkulace na tlaèítko
  VAR     lCopyREC
  VAR     nKalkulZA                    // kalkulace za : 1 - vyr.pol. zakázkovou, 2 - vyr.pol. globálnì
  VAR     aKalkulZAzak                 // pole zakázek, pro nìž se bude poèítat kalkulace vyr.položky
  VAR     nMnozPlano
  VAR     fromNabVys                   // voláno z nabídek vystavených

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  VYR_ALGREZ_SEL
  METHOD  OnSave

  METHOD  PrimeNAKL
  METHOD  KALK_CenMatMJP, KALK_CenMatZMP, KALK_CenMzdVDP, KALK_CenEnergP
  METHOD  KALK_CenMatMJS, KALK_CenMatZMS, KALK_CenMzdVDS, KALK_CenEnergS
  METHOD  KALK_CenSluzbS, KALK_CenMajetS

  METHOD  VYR_FIXNAKL_DET, Fakturace_ZAK

HIDDEN
  VAR     dm, dc, df, members, msg, cMsgMoment, kalkul_isOk

  METHOD  InitVarsPLAN, InitVarsSKUT
  METHOD  CmpKalkPLAN , CmpKalkSKUT
  METHOD  SetPorDen
  METHOD  RezieCMP
  METHOD  vREZ_Plan   // , vREZ_Skut
  METHOD  PlanMATER   , PrMatTMP
  METHOD  PlanMzdyKoop, PrMzdyTMP
  METHOD  SkutMATER, SkutMZDY, SkutKOOPER
  METHOD  SetColorBG, modiFrm
  METHOD  GetKalkulZaZak


  inline method info_in_msgStatus()
    local  oFont     := XbpFont():new():create( "10.Arial CE" )
    local  aAttr     := ARRAY( GRA_AS_COUNT )
    local  msgStatus := ::msg:msgStatus, picStatus := ::msg:picStatus
    local  ncolor, cinfo, oPs
    *
    local  curSize  := msgStatus:currentSize()
    local  paColors := { { graMakeRGBColor( {174, 255, 255} ), graMakeRGBColor( {  0, 183, 173} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {255, 183, 173} ), graMakeRGBColor( {251,  51,  40} ) }  }
    *
    local  cmainTask := 'Kalkulaci nelze opravovat - použita pøi pøecenìní doklad [' +allTrim(str(pvpitem_ka->ndoklad)) +'] ...'

    msgStatus:setCaption( '' )
    picStatus:hide()

    if .not. empty(cmainTask)
      ncolor := 3
      cinfo  := cmainTask

      oPs := msgStatus:lockPS()

      GraSetFont( oPS, oFont )
      GraGradient( oPs, {  0, 0 }    , ;
                        { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
      graStringAT( oPs, { 20, 4 }, cinfo )

//      aAttr [GRA_AS_COLOR] := GRA_CLR_WHITE
      GraSetAttrString( oPS, aAttr )
      graStringAT( oPs, { 20, 3 }, cinfo )

      msgStatus:unlockPS()

      picStatus:setCaption(DRG_ICON_MSGWARN)
      picStatus:show()
    endif
  return

ENDCLASS

*******************************************************************************
METHOD VYR_Kalkul_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC  := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC := ( parent:cargo = drgEVENT_APPEND2)
  *
  drgDBMS:open('C_AlgREZ' )
  drgDBMS:open('VyrZAK'   )
  drgDBMS:open('KUSOV'    )
  drgDBMS:open('POLOPER'  )
  drgDBMS:open('PVPITEM'  )
  drgDBMS:open('PVPITEMw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('FIXNAKL'  )
  drgDBMS:open('C_Stred'  )
  drgDBMS:open('MsPrc_MO' )
  drgDBMS:open('FakVysHD' )
  drgDBMS:open('FakVysIT' ) ; FakVysIT->( AdsSetOrder( 5))
  drgDBMS:open('FakVnpIT' ) ; FakVnpIT->( AdsSetOrder( 4))
  drgDBMS:open('UCETPOL'  )
  drgDBMS:open('UCETPOLw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('LISTHD'   )
  drgDBMS:open('LISTIT'   )
  drgDBMS:open('LISTITw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  drgDBMS:open('KusTREE',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('PRMATw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PRMZDYw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KALKULw',.T.,.T.,drgINI:dir_USERfitm); ZAP
*  POLOPER->( DbSetRelation( 'OPERACE', {|| POLOPER->cOznOper },'POLOPER->cOznOper'))
  *
  * z CFG
  ::nKoefPOJ    := SysConfig('Vyroba:nSazbaPoj') / 100
//  ::acDenikNE   := AllTrim( SysConfig('Vyroba:cDenikNE'))
//  ::acDenikNE   := ListAsArray( ::acDenikNE )
  acDenikNE   := AllTrim( SysConfig('Vyroba:cDenikNE'))
  acDenikNE   := ListAsArray( acDenikNE )
  ::nVypREZ     := SysConfig('Vyroba:nVypRezie')
  ::cDenikSKL   := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  ::nPrMatKal   := SysConfig('Vyroba:nPrMatKal')
  ::nFaktMnoz   := SysConfig('Vyroba:nFaktMnoz')
  ::nKalkNED    := SysConfig('Vyroba:nKalkNed')
  ::cNazRezie1  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie1')), 'Odbytová režie'  )
  ::cNazRezie2  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie2')), 'Výrobní režie'   )
  ::cNazRezie3  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie3')), 'Zásobovací režie')
  ::cNazRezie4  := CoalesceEmpty( AllTrim( SysConfig('Vyroba:cNazRezie4')), 'Správní režie'   )
  *
*  ::nMnKalk     := 2.00
  ::cFILE       := parent:parent:parent:dbName
*  ::nMnKalk     := IF( ::cFILE = 'Vyrzak', VyrZak->nMnozPlano, 1)

  ::nSumaKALK   := 0
  ::nSumaCAS    := 0
  ::lPrepKalALL := .F.
  ::nKalkulZA   := IF( parent:parent:formname = 'VYR_KALKULVP_SCR', ZA_VYRPOL_ALL, ZA_VYRPOL_ZAK )
  *
  ::GetKalkulZaZak()
  ::nMnKalk     := ::nMnozPlano
  *
  VYR_KALKUL_edit( self)
  *
  ::InitVarsPLAN()
  ::InitVarsSKUT()
  *
  ::cMsgMoment := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

RETURN self

********************************************************************************
METHOD VYR_Kalkul_CRD:drgDialogStart(drgDialog)
  LOCAL memb  := drgDialog:oActionBar:Members, x
  Local cKEY, isINFO
  Local aEvent := { 'KALK_CenMatZMP', 'KALK_CenMatZMS',;
                    'KALK_CenMatMJP', 'KALK_CenMatMJS',;
                    'KALK_CenMzdVDP', 'KALK_CenMzdVDS',;
                    'KALK_CenEnergP', 'KALK_CenEnergS',;
                    'KALK_CenMajetP', 'KALK_CenMajetS',;
                    'KALK_CenSluzbS' }
  *
  ::dc      := drgDialog:dialogCtrl
  ::dm      := drgDialog:dataManager
  ::df      := drgDialog:oForm
  ::members := drgDialog:oForm:aMembers
  ::msg     := drgDialog:oMessageBar
  *
  ::msg:can_writeMessage := .f.
  ::kalkul_isOk          := .t.

  ::fromNabVys := ( ::drgDialog:parent:parent:parent:dbName = 'NabVysHDw' )
  *
  ::modiFrm()
  *
  SetBUTTON_Edit( aEvent, ::Members, .F.)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  IsEditGET( { 'KALKULw->nMnozDavky'  ,;
               'KALKULw->cDruhCeny'   ,;
               'KALKULw->cTypKalk'    ,;
               'KALKULw->nRokVyp'     ,;
               'KALKULw->nObdMes'     ,;
               'KALKULw->dDatAktual'  ,;
               'KALKULw->nPorKalDen'} ,  drgDialog, ::lNewREC )
  *
  IF ::cFILE = 'VYRPOL'
    cKEY := Upper( VyrPOL->cCisZakaz) + Upper( VyrPOL->cVyrPOL) + StrZERO( VyrPOL->nVarCis, 3)
    VyrZAK->( dbSEEK( cKEY,,'VYRZAK1' ))
  ELSE
    cKEY := Upper( VyrZAK->cCisZakaz) + Upper( VyrZAK->cVyrPOL) + StrZERO( VyrZAK->nVarCis, 3)
    VyrPOL->( dbSEEK( cKEY,,'VYRPOL1' ))
  ENDIF
  *
  IF ::nKalkulZA = ZA_VYRPOL_ALL
    FOR x := 1 TO LEN( Memb)
      IF UPPER(memb[x]:event) $ 'DETAIL_1,FAKTURACE_ZAK'
        memb[x]:oXbp:visible := .F.
        memb[x]:oXbp:configure()
      ENDIF
    NEXT
    * Typ kalkulace needitovatelný - vždy je VPO ( za vyrábìnou položku )
    IsEditGET( { 'KALKULw->cTypKalk' }, drgDialog, .f. )
    *
  ENDIF
  *
  isINFO := ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
  IF( isINFO, drgDialog:SetReadOnly( .T.), NIL )
  *
  if .not. ::lnewRec
    if vyr_kalkul_isOk() = 558  // m_Cervena.bmp
      ::kalkul_isOk := .f.
      drgDialog:SetReadOnly(.T.)
    endif
  endif

RETURN self

********************************************************************************
METHOD VYR_Kalkul_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

** Ok
  if .not. ::kalkul_isOk
    if( nevent = drgEVENT_FORMDRAWN, ::info_in_msgStatus(), nil )
    if( nevent = xbeP_Move .or. nevent = xbeP_Resize, ::info_in_msgStatus(), nil )
  endif


  DO CASE
  CASE  nEvent = drgEVENT_SAVE
    * zápis nad kartou VyrZak - záložka Kalkulace
    IF ::drgDialog:parentDialog:cargo:formName = 'VYR_VYRZAK_CRD' .or. ::lCopyREC
      VYR_KALKUL_save( self)

      IF ::drgDialog:parentDialog:cargo:formName = 'VYR_KALKUL_SCR'
//        ::drgDialog:parentDialog:odBrowse[1]:refreshAll()
      ENDIF
    ENDIF
    *
    PostAppEvent(xbeP_Close, nEvent,,oXbp)
    RETURN .T.
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
METHOD VYR_Kalkul_CRD:OnSave(isBefore, isAppend)
  *
  VYR_Kalkul_save( self)
RETURN .T.

********************************************************************************
METHOD VYR_Kalkul_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
*  LOCAL  dc := ::drgDialog:dialogCtrl, dm := ::drgDialog:dataManager
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-'), cKey, cTag
  Local  lSetCisOp := SysConfig('Vyroba:lSetCisOp')
  LOCAL  nRec, nVal := 1, nKCas, nKKc, cMsg

  DO CASE
  CASE cName = 'KALKULw->nTypRezie'
    ::RezieCMP(cName)

  CASE cName = 'M->nMnKalk'
    If lValid
      If ( xVar > 0)
        ::CmpKalkPLAN( cName)
      ELSE
        drgMsgBox(drgNLS:msg('Kalkulaèní množství: ... údaj musí být kladný !'))
        lOK := .F.
      EndIf
**        ::CmpKalkPLAN( cName)
*        If( lOK, KalkulCMP( G), Nil )
    Endif

  CASE cName = 'KALKULw->nMnozDavky'
    If lValid
      If ( xVar <= 0)
        drgMsgBox(drgNLS:msg('Množství v dávce: ... údaj musí být kladný !'))
        lOK := .F.
      EndIf
    Endif

  CASE cName = 'KALKULw->cZkratMeny'
    IF lValid .AND. ;
      ( ::dm:get('KALKULw->nCenMatZMP' ) <> 0 .OR. ::dm:get('KALKULw->nCenMatMjP' ) <> 0 .OR. ;
        ::dm:get('KALKULw->nCenMatZMS' ) <> 0 .OR. ::dm:get('KALKULw->nCenMatMjS' ) <> 0  )
*          SetLastKEY( K_ALT_F4 )
*          PrimeNAKL( G)
    ENDIF

  CASE cName = 'KALKULw->cTypKalk'
    If lValid
      ::dm:set( 'KALKULw->nRezOdbytS', 0 )
      ::dm:set( 'KALKULw->nRezVyrobS', 0 )
      ::dm:set( 'KALKULw->nRezZasobS', 0 )
      ::dm:set( 'KALKULw->nRezSpravS', 0 )
      ::dm:set( 'M->nRezOdbytS', 0 )
      ::dm:set( 'M->nRezVyrobS', 0 )
      ::dm:set( 'M->nRezZasobS', 0 )
      ::dm:set( 'M->nRezSpravS', 0 )
      *
      ::RezieCMP(cName)
    Endif

    IF xVAR = 'NED'
      nREC := Kalkul->( RecNO())
      cTAG := Kalkul->( AdsSetOrder( 2))
      cKEY := ( ::cFILE)->cCisZAKAZ + ( ::cFILE)->cVyrPol +;
              StrZERO( ( ::cFILE)->nVarCis, 3 ) + xVAR
      IF Kalkul->( dbSEEK( Upper( cKEY)))
        drgMsgBox(drgNLS:msg('Kalkulace NEDOKONÈENÉ VÝROBY již existuje !'))
        lOK := NO
      ENDIF
      IF lOK
        ::dm:set( 'KALKULw->nRezOdbytP', 0 )
        ::dm:set( 'KALKULw->nRezVyrobP', 0 )
        ::dm:set( 'KALKULw->nRezZasobP', 0 )
        ::dm:set( 'KALKULw->nRezSpravP', 0 )
        ::dm:set( 'M->nRezOdbytP', 0 )
        ::dm:set( 'M->nRezVyrobP', 0 )
        ::dm:set( 'M->nRezZasobP', 0 )
        ::dm:set( 'M->nRezSpravP', 0 )
*          KalkulCMP( G, NO, PrMATp )
      ENDIF
      Kalkul->( AdsSetOrder( cTAG), dbGoTO( nREC))
    ENDIF

  CASE cName = 'KALKULw->nRokVyp' .OR. cName = 'KALKULw->nObdMes'
    IF ( xVar <= 0 )
      cKey := IIF( cName = 'KALKULw->nRokVyp', 'Rok výpoètu',;
                                               'Období výpoètu')
      drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... údaj musí být kladný !'))
      lOK := .F.
    ENDIF

    IF cName = 'KALKULw->nObdMes' .and. lOK
      VYR_SetFixNakl( ::dm:get('KALKULw->nRokVyp' ), ::dm:get('KALKULw->nObdMes' ),, ::drgDialog )
      ::SetPorDen()
    ENDIF

  CASE cName = 'KALKULw->nPorKalDen'
    If ( xVar <= 0)
      drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... údaj musí být kladný !'))
      lOK := .F.
    EndIf
    If ( lValid .and. lOK)   // .OR. lCOPY
      cKey := Upper( VyrPol->cCisZakaz) + Upper( VyrPol->cVyrPol) + ;
              StrZero( VyrPol->nVarCis, 3) + ;
              StrZero( ::dm:get('KALKULw->nRokVyp'), 4 ) + ;
              StrZero( ::dm:get('KALKULw->nObdMes'), 2 ) + ;
              DTOS( ::dm:get('KALKULw->dDatAktual') ) +  StrZero( xVar, 2)
      IF lOK := Kalkul->( dbSeek( cKey))
        cMsg := 'Kalkulace s tímto klíèem již existuje !;;' + ;
                 'Rok výpoètu režie :  < & >    ;' + ;
                 'Období ( mìsís)     :  < & >    ;' + ;
                 'Datum aktualizace :  < & >    ;' + ;
                 'Poøadí ve dni        :  < & >   '
        drgMsgBox(drgNLS:msg( cMsg, Kalkul->nRokVyp, Kalkul->nObdMes, Kalkul->dDatAktual, Kalkul->nPorKalDen))
      Endif
      lOK := !lOK
    Endif

  CASE cName = 'KALKULw->nCenMzdVDP'       //  Pøímé mzdy - plán
    ::dm:set( 'KALKULw->nCenOstatP', KALKULw->nCenOstatP := xVAR * ::nKoefPOJ )
    ::dm:set( 'M->nCenOstatP'      , ::nCenOstatP        := xVAR * ::nKoefPOJ * ::dm:get('M->nMnKalk' ) )

  CASE cName = 'KALKULw->nAlgOdbyt' .OR. cName = 'KALKULw->nAlgVyrob' .OR. ;
       cName = 'KALKULw->nAlgZasob' .OR. cName = 'KALKULw->nAlgSprav'
    IF lValid
      lKeyFound := C_AlgREZ->( dbSEEK( xVAR,,'C_ALGREZ1') )
      lOK := ::VYR_ALGREZ_SEL( cName, lKeyFound )
      /*
      IF ! C_AlgREZ->( dbSEEK( xVAR,,1) )
        PostAppEvent(xbeP_Keyboard,xbeK_F4,, oVar:oDrg:oXbp )
        IF (lOK := ( LastAppEvent() = xbeK_RETURN) )
          ::dm:set( cNAME, C_AlgREZ->nAlgRezie )
        ENDIF
      ENDIF
      */
      ::RezieCMP( cName, xVar)
    ENDIF

  CASE cName = 'KALKULw->nCenMzdVDS'       //  Pøímé mzdy - SKUT
    ::dm:set( 'KALKULw->nCenOstatS', KALKULw->nCenOstatS := xVAR * ::nKoefPOJ )
    ::dm:set( 'M->nCenOstatS'      , ::nCenOstatS        := xVAR * ::nKoefPOJ * ::dm:get('M->nMnKalk' ) )

  ENDCASE
  IF( lValid, ::CmpKalkPLAN( cNAME), NIL )

RETURN lOK

* Výbìr algoritmu výpoètu režií do karty KALKULace
********************************************************************************
METHOD VYR_Kalkul_CRD:VYR_ALGREZ_SEL( cName, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F.

  * F4 nebo ...
  if isObject(cName)
    cName := cname:lastXbpInFocus:cargo:name
  endif

  IF !KeyFound
    DRGDIALOG FORM 'VYR_ALGREZ_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set( cName, C_ALGREZ->nAlgRezie )
*    ::dm:set( Dialog:lastXbpInFocus:cargo:name, C_ALGREZ->nAlgRezie )
  ENDIF

RETURN lOK

********************************************************************************
METHOD VYR_KALKUL_CRD:VYR_FIXNAKL_DET()
  LOCAL cKEY

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'VYR_FIXNAKL_CRD,.T.' PARENT ::drgDialog CARGO drgEVENT_EDIT ;
  TITLE drgNLS:msg('Režijní náklady - INFO') MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self

********************************************************************************
METHOD VYR_KALKUL_CRD:Fakturace_ZAK()
LOCAL oDialog
Local nRecIT := FakVysIT->( RecNO()), cTagIT := FakVysIT->( OrdSetFocus())
Local nRecHD := FakVysHD->( RecNO()), cTagHD := FakVysHD->( OrdSetFocus())

  DRGDIALOG FORM 'VYR_VYRZAK_FAKT' PARENT ::drgDialog MODAL DESTROY
  *
  FakVysHD->( AdsSetOrder( cTagHD), dbGoTO( nRecHD) )
  FakVysIT->( AdsSetOrder( cTagIT), dbGoTO( nRecIT) )
RETURN self

*******************************************************************************
METHOD VYR_Kalkul_CRD:destroy()
  ::drgUsrClass:destroy()

  ::lNewREC     := ::lCopyREC := ;
  ::nMnKalk     := ;
  ::cFILE       := ;
                   NIL
  * CFG
  ::nKoefPOJ    := ::nVypREZ := ::cDenikSKL := ::nPrMatKal := ;
  ::nFaktMnoz   := nKalkNED := NIL
  *
  ::cActiveGET   := ;
  ::nSumaKALK    := ;
  ::nSumaCAS     := ;
  ::lPrepKalALL  := ;
  ::nKalkulZA    := ;
  ::aKalkulZAzak := ;
                    NIL
  acDenikNE      := NIL
  KALKULw->( dbCloseArea())
RETURN self

* Výpoèet pøímých nákladù  všech položek kalkulace
*******************************************************************************
METHOD VYR_Kalkul_CRD:PrimeNAKL( xxx)
  Local  oMoment
  local  values := ::dm:vars:values, size := ::dm:vars:size(), x

  ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING)
  oMoment := SYS_MOMENT( 'Probíhá kompletní výpoèet kalkulace')
  ::lPrepKalALL := .T.
  *                        // PLÁN
  ::KALK_CenMatZMP()       // - Pøímý materiál - zahr.mìna
  ::KALK_CenMatMJP()       // - Pøímý materiál - CZK
  ::KALK_CenMzdVDP()       // - Pøímé mzdy VD
  ::KALK_CenEnergP()       // - Kooperace 1

  *                        // SKUTEÈNOST
  ::KALK_CenMatZMS()       // - Pøímý materiál - zahr.mìna
  ::KALK_CenMatMJS()       // - Pøímý materiál - CZK
  ::KALK_CenMzdVDS()       // - Pøímé mzdy VD
  ::KALK_CenSluzbS()       // - Ostatní pøímé mzdy
  ::KALK_CenEnergS()       // - Kooperace 1
  ::KALK_CenMajetS()       // - Kooperace 2
  *
  ::lPrepKalALL := .F.
  ::msg:WriteMessage(,0)
  oMoment:destroy()
  *
  ** JS 2.9.2011
  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence

RETURN .t.

* PLÁN : Pøímý materiál - zahr.mìna
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMatZMP( oDlg)

  ::cActiveGET := 'nCenMatZMP'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  *
  ::PlanMATER( 1)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMatZMP', .F.):oDrg:oXbp )
RETURN self

* PLÁN : Pøímý materiál - CZK
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMatMJP( oDlg)

  ::cActiveGET := 'nCenMatMJP'
  IF .not. IsNIL( oDlg)
    ::SetColorBG( oDlg:lastXbpInFocus)
    oDlg:lastXbpInFocus := ::dm:get( 'Kalkulw->nCenMatMJP', .F.):oDrg:oXbp
  ENDIF
  ::PlanMATER( 2)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMatMJP', .F.):oDrg:oXbp )

RETURN self

* PLÁN : Pøímé mzdy VD
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMzdVDP( oDlg)

  ::cActiveGET := 'nCenMzdVDP'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  *
  ::PlanMzdyKOOP( 2)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMzdVDP', .F.):oDrg:oXbp )
RETURN self

* PLÁN : Kooperace 1
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenEnergP( oDlg)

  ::cActiveGET := 'nCenEnergP'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
*  ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
  ::PlanMzdyKOOP( 3)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenEnergP', .F.):oDrg:oXbp )
RETURN self

* SKUT.: Pøímý materiál - zahr.mìna
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMatZMS( oDlg)

  ::cActiveGET := 'nCenMatZMS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
*  ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
  ::SkutMATER( 1)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMatZMS', .F.):oDrg:oXbp )
RETURN self

* SKUT.: Pøímý materiál - CZK
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMatMJS( oDlg)

  ::cActiveGET := 'nCenMatMJS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
*  ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
  ::SkutMATER( 2)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMatMJS', .F.):oDrg:oXbp )
RETURN self

* SKUT. : Pøímé mzdy VD
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMzdVDS( oDlg)

  ::cActiveGET := 'nCenMzdVDS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  ::SkutMZDY( 1)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMzdVDS', .F.):oDrg:oXbp )
RETURN self

* SKUT. : Ostatní pøímé mzdy
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenSluzbS( oDlg)

  ::cActiveGET := 'nCenSluzbS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  ::SkutMZDY( 2)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenSluzbS', .F.):oDrg:oXbp )
RETURN self

* SKUT : Kooperace 1
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenEnergS( oDlg)

  ::cActiveGET := 'nCenEnergS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  ::SkutKOOPER( 3)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenEnergS', .F.):oDrg:oXbp )
RETURN self

* SKUT : Kooperace 2
*******************************************************************************
METHOD VYR_Kalkul_CRD:KALK_CenMajetS( oDlg)

  ::cActiveGET := 'nCenMajetS'
  IF( IsNIL( oDlg), NIL, ::SetColorBG( oDlg:lastXbpInFocus) )
  ::SkutKOOPER( 4)
  PostAppEvent(xbeP_Keyboard, xbeK_ENTER,, ::dm:get( 'Kalkulw->nCenMajetS', .F.):oDrg:oXbp )
RETURN self

*** HIDDEN
*
* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:InitVarsPLAN()
  Local n, cItemMJ, cItemMN

  ::aVarPLAN := { { 'KALKULw->nCenMatZMP', 'nCenMatZMP' } ,;
                  { 'KALKULw->nCenMatMJP', 'nCenMatMJP' } ,;
                  { 'KALKULw->nCenMzdVDP', 'nCenMzdVDP'} ,;
                  { 'KALKULw->nCenOstatP', 'nCenOstatP'} ,;
                  { 'KALKULw->nCenSluzbP', 'nCenSluzbP'} ,;
                  { 'KALKULw->nCenEnergP', 'nCenEnergP'} ,;
                  { 'KALKULw->nCenMajetP', 'nCenMajetP'} ,;
                  { 'KALKULw->nRezOdbytP', 'nRezOdbytP'} ,;
                  { 'KALKULw->nRezVyrobP', 'nRezVyrobP'} ,;
                  { 'KALKULw->nRezZasobP', 'nRezZasobP'} ,;
                  { 'KALKULw->nRezSpravP', 'nRezSpravP'} ,;
                  { 'KALKULw->nCenKalkP' , 'nCenKalkP' } ,;
                  { 'KALKULw->nZiskP'    , 'nZiskP'    } ,;
                  { 'KALKULw->nCenProdP' , 'nCenProdP' }  }

  FOR n := 1 TO LEN ( ::aVarPLAN)
    cItemMJ := ::aVarPLAN[ n, 1]    // položka pro cenu za  MJ
    cItemMN := ::aVarPLAN[ n, 2]    // položka pro cenu za  kalkulované mn.
    self:&cItemMN := DBGetVal( cItemMJ) * ::nMnKalk
  NEXT
RETURN self

*
* HIDDEN ***********************************************************************
METHOD VYR_KALKUL_CRD:InitVarsSKUT()
  Local n, cItemMJ, cItemMN

  ::aVarSKUT := { { 'KALKULw->nCenMatZMS', 'nCenMatZMS' } ,;
                  { 'KALKULw->nCenMatMJS', 'nCenMatMJS' } ,;
                  { 'KALKULw->nCenMzdVDS', 'nCenMzdVDS'} ,;
                  { 'KALKULw->nCenOstatS', 'nCenOstatS'} ,;
                  { 'KALKULw->nCenSluzbS', 'nCenSluzbS'} ,;
                  { 'KALKULw->nCenEnergS', 'nCenEnergS'} ,;
                  { 'KALKULw->nCenMajetS', 'nCenMajetS'} ,;
                  { 'KALKULw->nRezOdbytS', 'nRezOdbytS'} ,;
                  { 'KALKULw->nRezVyrobS', 'nRezVyrobS'} ,;
                  { 'KALKULw->nRezZasobS', 'nRezZasobS'} ,;
                  { 'KALKULw->nRezSpravS', 'nRezSpravS'} ,;
                  { 'KALKULw->nCenKalkS' , 'nCenKalkS' } ,;
                  { 'KALKULw->nZiskS'    , 'nZiskS'    } ,;
                  { 'KALKULw->nCenProdS' , 'nCenProdS' }  }

  FOR n := 1 TO LEN ( ::aVarSKUT)
    cItemMJ := ::aVarSKUT[ n, 1]       // položka pro cenu za  MJ
    cItemMN := ::aVarSKUT[ n, 2]       // položka pro cenu za  kalkulované mn.
    self:&cItemMN := DBGetVal( cItemMJ) * ::nMnKalk
  NEXT
  * procenta podílu z PC
  ::nProcMatS  := VYR_procento_zPC( KALKULw->nCenProdS, { KALKULw->nCenMatMJS} )
  ::nProcMzdS  := VYR_procento_zPC( KALKULw->nCenProdS, { KALKULw->nCenMzdVdS ,;
                                                          KALKULw->nCenSluzbS  } )
  ::nProcZiskS := VYR_procento_zPC( KALKULw->nCenProdS, { KALKULw->nZiskS} )
RETURN self

*
* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:CmpKalkPLAN( cNAME)
  Local a, n := m := 0, isALGOR
  Local nKalkP := nZiskP := nPCenaP := 0  // Plán: kalkulace, zisk, prodejní cena
  Local nKalkS := nZiskS := nPCenaS := 0  // Skut: kalkulace, zisk, prodejní cena
  Local nMnKalk := ::dm:get( 'M->nMnKalk')
  Local cItemMJ, cItemMN

  IF EMPTY( cNAME) .or. cNAME = 'M->nMnKalk'  // Pøepoèítej vše
    FOR n := 1 TO LEN ( ::aVarPLAN)
      cItemMJ := ::aVarPLAN[ n, 1]
      cItemMN := ::aVarPLAN[ n, 2]
      ::dm:set( cItemMN, &cItemMN := ::dm:get( cItemMJ) * nMnKalk )
    NEXT
    FOR n := 1 TO LEN ( ::aVarSKUT)
      cItemMJ := ::aVarSKUT[ n, 1]
      cItemMN := ::aVarSKUT[ n, 2]
      ::dm:set( cItemMJ, &cItemMJ := ::dm:get( cItemMN) / nMnKalk )
    NEXT
  ELSE                                        // Pøepoèítej jednu položku
     n := ASCAN( ::aVarPLAN, {|X| X[1] = cNAME } )
     m := ASCAN( ::aVarSKUT, {|X| X[1] = cNAME } )
     isALGOR := 'NALG' $ Upper(cNAME)
     IF n <> 0 .or. m <> 0 .or. cNAME = 'KALKULw->nTypRezie' .or. isALGOR .or. ;
       cNAME = 'KALKULw->nZiskProcP'
       * Pøepoèet aktivní položky
*       IF ::lNewREC
        IF n <> 0    ;  cItemMJ := ::aVarPLAN[ n, 1]
                        cItemMN := ::aVarPLAN[ n, 2]
                        ::dm:set( cItemMN, ::dm:get( cItemMJ) * nMnKalk )
                        self:&cItemMN := ::dm:get( cItemMJ) * nMnKalk
        ELSEIF m <> 0;  cItemMJ := ::aVarSKUT[ m, 1]
                        cItemMN := ::aVarSKUT[ m, 2]
                        ::dm:set( cItemMN, ::dm:get( cItemMJ) * nMnKalk )
                        self:&cItemMN := ::dm:get( cItemMJ) * nMnKalk
         ENDIF
*       ENDIF
       * Pøepoèet režií, pokud je potøeba
       IF ::nVypREZ == 1       // z FixNAKL ... vždy
         ::RezieCMP(cName)    //::RezieCMP( G)
       ELSEIF ::nVypREZ == 2   // z UcetPOL ... staèí jedenkrát
         ::RezieCMP(cName)    //::RezieCMP( G, n )
       ENDIF
       *
       FOR n := 2 TO ItemsKALK
         cItemMJ := ::aVarPLAN[ n, 1]
         nKalkP  += ::dm:get( cItemMJ)
         cItemMJ := ::aVarSKUT[ n, 1]
         nKalkS  += ::dm:get( cItemMJ)
       NEXT
       * PLÁN na MJ
       nZiskP  := ( nKalkP / 100) * ::dm:get('KALKULw->nZiskProcP')
       nPCenaP := nKalkP + nZiskP
       ::dm:set('KALKULw->nCenKalkP', KALKULw->nCenKalkP := nKalkP  )   // 30.1.2007
       ::dm:set('KALKULw->nZiskP'   , KALKULw->nZiskP    := nZiskP  )
       ::dm:set('KALKULw->nCenProdP', KALKULw->nCenProdP := nPCenaP )
       * PLÁN na Kalkulované mn.
       ::dm:set('M->nCenKalkP', nKalkP  * nMnKalk )
       ::dm:set('M->nZiskP'   , nZiskP  * nMnKalk )
       ::dm:set('M->nCenProdP', nPCenaP * nMnKalk )
       * SKUT. na Kalkulované mn.
       nPCenaS := ProdCenaSK( ::nFaktMnoz)
       ::dm:set('M->nCenKalkS', nKalkS  * nMnKalk )
       ::dm:set('M->nCenProdS', nPCenaS )
       ::dm:set('M->nZiskS'   , nPCenaS - (nKalkS  * nMnKalk) )
       * SKUT. na MJ
       ::dm:set('KALKULw->nCenKalkS', KALKULw->nCenKalkS := nKalkS  )
       ::dm:set('KALKULw->nCenProdS', KALKULw->nCenProdS := nPCenaS / nMnKalk )
       ::dm:set('KALKULw->nZiskS'   , KALKULw->nZiskS    := ( nPCenaS / nMnKalk) - nKalkS )
     ENDIF
  ENDIF
  *
  ::nProcMatS  := VYR_procento_zPC( ::dm:get( 'KALKULw->nCenProdS'),;
                                   { ::dm:get( 'KALKULw->nCenMatMjS')} )
  ::dm:set('M->nProcMatS', ::nProcMatS)

  ::nProcMzdS  := VYR_procento_zPC( ::dm:get( 'KALKULw->nCenProdS'),;
                                   { ::dm:get( 'KALKULw->nCenMzdVdS'),;
                                     ::dm:get( 'KALKULw->nCenSluzbS') } )
  ::dm:set('M->nProcMzdS', ::nProcMzdS)

  ::nProcZiskS  := VYR_procento_zPC( ::dm:get( 'KALKULw->nCenProdS'),;
                                   { ::dm:get( 'KALKULw->nZiskS')} )
  ::dm:set('M->nProcZiskS', ::nProcZiskS)
  *
  ::dm:refresh()
RETURN self

* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:CmpKalkSKUT()
  Local a, n, cITEM

  FOR n := 1 TO LEN ( ::aVarSKUT)
    cITEM := ::aVarSKUT[ n, 2]
    self:&cITEM := DBGetVal( ::aVarSKUT[ n, 1]) * ::nMnKalk
  NEXT
RETURN self

* Nastavení poøadí kalkulace ve dni
* HIDDEN************************************************************************
METHOD VYR_Kalkul_CRD:SetPorDen()
  Local nRec  := Kalkul->( RecNo()), cTag
  Local cScopeORG := KALKUL->( DbScope( SCOPE_TOP))
  Local cScopeNEW := cScopeORG + ;
                     StrZero( ::dm:get('KALKULw->nRokVyp' ), 4) + ;
                     StrZero( ::dm:get('KALKULw->nObdMes' ), 2) + ;
                     DTOS( ::dm:get('KALKULw->dDatAktual' ))

  cTag :=  KALKUL->( AdsSetOrder( 1))
  KALKUL->( mh_SetScope( cScopeNEW), dbGoBottom() )
  ::dm:set( 'KALKULw->nPorKalDen', Kalkul->nPorKalDen + 1 )
  KALKUL->( mh_ClrScope())
  * vrátí pùvodní scope a pozici
  KALKUL->( AdsSetOrder( cTag))
  KALKUL->( mh_SetScope( cScopeORG)) //, dbGoTO( nREC) )   //*?*

RETURN self

*  nParam : 1 - Pøímý materiál v zahranièní mìnì
*           2 - Pøímý materiál v CZK
**HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:PlanMATER( nParam)
  Local cZaklME
  Local cTagTREE, lOK, lCZK
  Local nSumaKalk := 0, nSuma
*  Local nRecZAK := VyrZAK->( RecNO())
  Local nRecVyr := VyrPOL->( RecNO()), nEXIT
  Local nLastKEY := LastKEY(), nKEY, nPOS, anCENA, aRECs := {}, cHLP
  Local lPrepKalP := SysConfig('Vyroba:lPrepKalP')
  Local lDrCenKal := SysConfig('Vyroba:lDrCenKal')

  IF( ::lPrepKalALL, NIL, ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING) )

  PRMATw->( dbZAP())
  nDruhCeny := if( ::fromNabVys, 5, 1 )   // 1
  *
  GenTreeFILE( ROZPAD_NENI,,,, ::fromNabVys )
  dbSelectAREA( 'KusTREE')
  cTagTREE := AdsSetOrder( 2)
  *
  KusTREE->( mh_SetSCOPE( '1' ) )
  DO WHILE !KusTREE->( EOF())
    lCZK := VYR_IsCZK( KusTree->cZkratMENY)
    lOK := IF( nParam == 2, IF( lCZK, YES, NO )  ,;
              !EMPTY( KusTREE->cZkratMENY) .AND. IF( lCZK, NO, YES) )
    IF lOK
       AADD( aRECs, RecNO() )
       anCENA := { KusTREE->nCenaCELK , KusTREE->nCenaCELK2,;
                   KusTREE->nCenaCELK3, KusTREE->nCenaCELK4, KusTREE->nCenaCELK5 }
       IF lDrCenKAL
         nSuma := IIF( IsNIL( nDruhCeny), KusTREE->nCenaCELK6 * KusTREE->nKoefPREP,;
                  IIF( nDruhCeny = 5    , anCENA[ nDruhCENY],;
                                          anCENA[ nDruhCeny]  * KusTREE->nKoefPREP ))
       ELSE
         nPOS := ASCAN( anCENA, {|X| X <> 0 } )
         nSuma := IIF( IsNIL( nDruhCeny), KusTREE->nKoefPREP * IF( KusTREE->nCenaCELK6 == 0, IF( nPOS <> 0, anCENA[ nPOS], 0), KusTREE->nCenaCELK6),;
                  IIF( nDruhCeny = 5    , anCENA[ nDruhCENY],;
                                          KusTREE->nKoefPREP * IF( anCENA[ nDruhCENY]  == 0, IF( nPOS <> 0, anCENA[ nPOS], 0), anCENA[ nDruhCENY] ) ))
       ENDIF
       cZaklMe := ::dm:get( 'KALKULw->cZkratMeny')
       nSumaKALK += IF( nParam == 1, VYR_MenaToMena( nSuma, 'CZK', cZaklME),;
                        VYR_MenaToMena( nSuma, KusTREE->cZkratMENY, cZaklME ))
    ENDIF
    KusTREE->( dbSKIP())
  ENDDO
  KusTREE->(dbGoTOP())
  *
  ::nSumaKALK := nSumaKALK
  *
  IF ::lPrepKalALL         //  pøepoèet celé kalkulace
    IF lPrepKalP .OR. ::nCenKalkP = 0
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk )
      ::PrMatTMP()
    ENDIF

  ELSE                   // pøepoèet jedné položky kalkulace
    mh_RyoFILTER( aRECs, 'KusTREE' )
    IF( ::lPrepKalALL, NIL, ::msg:WriteMessage(,0) )

    DRGDIALOG FORM 'VYR_PrimeNAKL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                       EXITSTATE nExit
    IF ( nExit != drgEVENT_QUIT )
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk )
      ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
      ::PrMatTMP()
    ENDIF
  ENDIF
  KusTREE->( mh_ClrSCOPE(), AdsSetOrder( cTagTREE), Ads_ClearAOF(), dbGoTOP() )

RETURN NIL

*  Výpoèet Pøímých mezd VD a Kooperace 1
*  nParam : - 2  = Pøímé mzdy VD
*             3  = Kooperace 1
**HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:PlanMzdyKOOP( nParam)
  Local nPriprCas := 0, nKusovCas := 0, nPriprKc := 0, nKusovKc := 0
  Local nHodSazZAM, cTagTree
  Local nPrMzdaPL := SysConfig('Vyroba:nPrMzdaPl')
  Local lPrepKalP := SysConfig('Vyroba:lPrepKalP')

  IF( ::lPrepKalALL, NIL, ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING) )

  PRMZDYw->( dbZAP())
  *
  GenTreeFile( ROZPAD_NENI,,,, ::fromNabVys )
  ActTreeFile( ::dm:get('KALKULw->nMnozDavky'),;
               ( nParam = 3 )                 ,;
               ::dm:get('KALKULw->cTypKalk')  ,;
               ::fromNabVys                    )

*  KusTree->( dbSetRelation( 'VyrPol', {|| Upper( KusTree->cVyrPol) },;
*                                         "Upper( KusTree->cVyrPol)") )
  dbSelectAREA( 'KusTREE')
  cTagTREE := AdsSetOrder( 2)
  KusTREE->( mh_SetSCOPE( '0' ) )

  SUM  KusTree->nPriprCas, KusTree->nKusovCas, KusTree->nPriprKc, KusTree->nKusovKc ;
   TO  nPriprCas, nKusovCas, nPriprKc, nKusovKc

  ::nSumaCas  := nPriprCas + nKusovCas
  ::nSumaKalk := nPriprKc  + nKusovKc
  //-26.1.2004 nove
  IF ::cActiveGET = 'nCenMzdVDP'
* ???    nPriprCASK := nPriprCas
* ???    nKusovCASK := nKusovCas
  EndIF
  //-
  IF nPARAM == 2 .AND. nPrMzdaPL == 2  // z prùmìrné hod.sazby zamìstnance
    nHodSazZAM := SysConfig('Vyroba:nHodSazZam')
    ::nSumaKalk  := ( ::nSumaCAS / 60 ) * nHodSazZAM
  ENDIF
  *
  IF( ::lPrepKalALL, NIL, ::msg:WriteMessage(,0) )
  *
  IF ::lPrepKalALL         //  pøepoèet celé kalkulace
    IF lPrepKalP .OR. ::nCenKalkP = 0
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk )
      ::PrMzdyTMP()
    ENDIF
  ELSE                   // pøepoèet jedné položky kalkulace

    DRGDIALOG FORM 'VYR_PrimeNAKL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                       EXITSTATE nExit
    IF ( nExit != drgEVENT_QUIT )
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk )
      ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
      ::PrMzdyTMP()
    ENDIF
  ENDIF
  KusTREE->( mh_ClrSCOPE(), AdsSetOrder( cTagTREE), dbGoTOP() )
RETURN self

*  nParam : 1 - Pøímý materiál v zahranièní mìnì
*           2 - Pøímý materiál v CZK
* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:SkutMATER( nParam)
  Local cZaklME, cScope
  Local lOK, lCZK
  Local nKcNaOpeSK, nNmNaOpeSK, nTag, n
  Local nCenaCELK, nPrirazka, aRECs := {}

  IF( ::lPrepKalALL, NIL, ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING) )
  *
  IF ::nPrMatKAL == 1       // Ze skladových dokladù - PVPITEM
*    cScope := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, ( ::cFILE)->cCisZakaz,;
*                                               ( ::cFILE)->cVyrPOL + StrZERO(( ::cFILE)->nVarCis, 3 ))
    nNmNaOpeSK := nKcNaOpeSK := 0
    ( dbSelectAREA( 'PVPItem'), AdsSetOrder( 9) )
    PVPITEMw->( dbZAP())

    FOR n := 1 TO LEN( ::aKalkulZaZak)
      cScope := ::aKalkulZaZak[ n]
      IF !EMPTY( cScope)

*         nTag := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, 9, 25 )
*        ( dbSelectAREA( 'PVPItem'), AdsSetOrder( nTag) )
        cScope += StrZERO( -1, 2)  // + Cs_Upper( 'V ')
        PVPITEM->( mh_SetSCOPE( UPPER( cScope) ))
*        PVPITEMw->( dbZAP())

        DO WHILE !EOF()
          lCZK := VYR_IsCZK( PVPItem->cZkratMENY)
          lOK := IF( nPARAM = 2, IF( lCZK, YES, NO),;
                     !EMPTY( PVPItem->cZkratMENY) .AND. IF( lCZK, NO, YES) )
          IF lOK
             mh_CopyFld( 'PVPITEM', 'PVPITEMw', .t. )
             nNmNaOpeSK += PVPItem->nMnozPrDOD
             cZaklMe := ::dm:get( 'KALKULw->cZkratMeny')
             nCenaCELK  := IF( nPARAM = 2, VYR_MenaToMena( PVPItem->nCenaCELK, 'CZK', cZaklME),;
                               VYR_MenaToMena( PVPItem->nCenaCELK, PVPItem->cZkratMENY, cZaklME ))
             nKcNaOpeSK += nCenaCELK
             nPrirazka := VYR_PrirazkaCMP( nCenaCELK)
             nKcNaOpeSK += nPrirazka
          ENDIF
          dbSKIP()
        ENDDO
        PVPITEM->( dbGoTop())
        PVPITEM->( mh_ClrSCOPE())
      ENDIF
    NEXT
    *
  ELSEIF ::nPrMatKAL == 2           // z úèetních dokladù
    ::SkutKOOPER(  nPARAM)
    RETURN self
  ENDIF

  ::nSumaKalk := nKcNaOpeSK
  *
  IF ::lPrepKalALL         //  pøepoèet celé kalkulace
    ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
    ::dm:set( IF( nParam = 1, 'M->nCenMatZMS', 'M->nCenMatMJS'), ::nSumaKalk )

  ELSE                   // pøepoèet jedné položky kalkulace
    PVPITEMw->( dbGoTOP())
    IF( ::lPrepKalALL, NIL, ::msg:WriteMessage(,0) )

    DRGDIALOG FORM 'VYR_PrimeNAKL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                       EXITSTATE nExit
    IF ( nExit != drgEVENT_QUIT )
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
      ::dm:set( IF( nParam = 1, 'M->nCenMatZMS', 'M->nCenMatMJS'), ::nSumaKalk )
      ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
    ENDIF
  ENDIF
  PVPITEM->( mh_ClrSCOPE(), Ads_ClearAOF(), dbGoTOP() )
RETURN self

*  nParam : 1 - Skuteèné pøímé mzdy
*           2 - Ostatní skuteèné pøímé mzdy
* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:SkutMZDY( nParam)
  Local cScope, lOK, aRECs := {}
  Local nNmNaOpeSK, nKcNaOpeSK, nKcOpePrem, nKcOpePrip, nTag, n
  Local acGET      := { 'nCenMzdVDS', 'nCenSluzbS'}
  Local nPrMzdy    := SysConfig( 'Vyroba:nPrMzdaKal')
  Local nOsPrMzdy  := SysConfig( 'Vyroba:nOsPrMzKal')
  Local cNazPol1   := SysConfig( 'Vyroba:cNazPol1'), aNazPOL1
  Local cStrMzdy   := SysConfig( 'Vyroba:cStrMzdy'), aStrMzdy
  Local cStrOsMzdy := SysConfig( 'Vyroba:cStrOsMzdy'), aStrOsMzdy

  IF( ::lPrepKalALL, NIL, ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING) )
  *
  IF !IsNIL( cNazPOL1 )
    aNazPOL1 := ListAsARRAY( ALLTRIM( cNazPOL1) )
    cNazPOL1 := aNazPOL1[ 1]
  ENDIF
  * Výèet støedisek pro výpoèet pøímých mezd
  IF !IsNIL( cStrMzdy )
    aStrMzdy := ListAsARRAY( ALLTRIM( cStrMzdy) )
  ENDIF
  * Výèet støedisek pro výpoèet ostatních pøímých mezd
  IF !IsNIL( cStrOsMzdy )
    aStrOsMzdy := ListAsARRAY( ALLTRIM( cStrOsMzdy) )
  ENDIF
  * nPrMzdy = 1 ... pro všechna støediska, 2 ... jen pro cfg-støedisko, 3 ... výèet støedisek

*  MsPrc_M_D->( AdsSetOrder( 1))
**  cScope := Upper( ( ::cFILE)->cCisZakaz)
**  ListIT->( AdsSetOrder( 8), mh_SetSCOPE( cScope))
  /*
  cScope := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, Upper( ( ::cFILE)->cCisZakaz) ,;
                                             Upper(VyrPOL->cVyrPOL )) // ??? + StrZERO( VyrPOL->nVarCis, 3 ))
  nTag   := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, 8, 13 )
  ListIT->( AdsSetOrder( nTag), mh_SetSCOPE( cScope))
  */

  ListIT->( AdsSetOrder( 8))
  ListITw->( dbZap())
  nNmNaOpeSK := nKcNaOpeSK := nKcOpePrem := nKcOpePrip := 0

  FOR n := 1 TO LEN( ::aKalkulZaZak)
    cScope := ::aKalkulZaZak[ n]
    ListIT->( mh_SetSCOPE( cScope))

    DO WHILE !ListIT->( EOF())
      IF UPPER( ::cFILE) = 'VYRPOL'
        VYRZAK->( dbSEEK( Upper( VYRPOL->cCisZAKAZ),, 'VYRZAK1'))
      ENDIF
      IF nParam = 1  // pøímé mzdy
         lOK := IIF( IsNIL( cNazPol1), YES,;
                IIF( nPrMzdy == 1,     YES,;
                IIF( nPrMzdy == 2, ListIT->cNazPol1 == VyrZAK->cNazPOL1,;
                IIF( nPrMzdy == 3, VYR_VycetSTR( aStrMzdy), NO  ) )))
      ELSEIF nParam = 2  //  ostatní pøímé mzdy
  //           lOK := ( ListIT->cNazPol1 <> VYRZAK->cNazPOL1 )
         lOK := IIF( IsNIL( nPrMZDY) .OR. nPrMZDY == 1, NO,;
                IIF( nPrMZDY == 2, ListIT->cNazPol1 <> VYRZAK->cNazPOL1,;
                IIF( nPrMZDY == 3, VYR_VycetSTR( aStrOsMzdy), NO  ) ))
      ENDIF
      IF lOK .AND. ListIT->nOsCisPrac <> 0
        mh_CopyFld( 'ListIT', 'ListITw', .t.)
        nNmNaOpeSK += ListIT->nNmNaOpeSK
        nKcOpePrem += ListIt->nKcOpePrem
        nKcOpePrip += ListIT->nKcOpePrip
        IF nParam == 2 .AND. nOsPrMzdy = 2     // dle sazeb pracovníkù

          MsPrc_MO->( dbSEEK( StrZero(ListIT->nRok) +StrZero(ListIT->nObdobi) +StrZero(ListIT->nOsCisPrac) ;
                                 +StrZero(ListIT->nPorPraVzt),,'MSPRMO01'))
          nKcNaOpeSK += ListIT->nNhNaOpeSK * ;
                        ( fSazTAR(ListIT->dVyhotSkut)[1] * ( fSazZam('PRCPREHLCI', ListIT->dVyhotSkut) / 100 +1))
        ELSE
          nKcNaOpeSK += ListIT->nKcNaOpeSK
        ENDIF
      ENDIF
      ListIT->( dbSKIP())
    ENDDO
    ListIT->( mh_ClrSCOPE())
  NEXT
  ListIT->( dbGoTOP())

  ::nSumaKalk := nKcNaOpeSK + nKcOpePrem + nKcOpePrip
  *
  IF ::lPrepKalALL         //  pøepoèet celé kalkulace
    ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
    ::dm:set( 'M->' + acGet[ nParam], ::nSumaKalk )
    IF nPARAM = 1
*         G[ POJISTs]:VarPUT( G[ PrMZDs]:VarGET() * nKoefPoj )
      ::dm:set( 'KALKULw->nCenSluzbS', ::nSumaKalk * ::nKoefPoj )
    ENDIF

  ELSE                   // pøepoèet jedné položky kalkulace
    LISTITw->( dbGoTOP())
    IF( ::lPrepKalALL, NIL, ::msg:WriteMessage(,0) )
    *
    DRGDIALOG FORM 'VYR_PrimeNAKL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                       EXITSTATE nExit
    IF ( nExit != drgEVENT_QUIT )
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
      ::dm:set( 'M->' + acGet[ nParam], ::nSumaKalk )
      ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
    ENDIF
  ENDIF
  ListIT->( mh_ClrSCOPE(), mh_ClrFilter())
RETURN self

* Výpoèet skuteèných kalkulací z UcetPOL
*  nParam : 1 - Pøímý materiál v zahranièní mìnì
*           2 - Pøímý materiál v CZK
*           3 - Kooperace 1
*           4 - Kooperace 2
* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:SkutKOOPER( nParam)
  Local nSumaKalk := 0, nKcMD, nTag, n
  Local acCFG := { 'cUctMatZM' , 'cUctMatCZK', 'cUctKoop1' , 'cUctKoop2'  }
  Local acGET := { 'nCenMatZMS', 'nCenMatMJS', 'nCenEnergS', 'nCenMajetS' }
  Local aUcty, cUctCFG, cScope,  aRECs := {}
  Local cDenikSKL := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  Local lCOND := ( nPARAM > 2)   // Vylouèit deník SKLADY
  Local lDenikOK := YES, lOK

  IF( ::lPrepKalALL, NIL, ::msg:writeMessage( ::cMsgMoment ,DRG_MSG_WARNING) )

*  cScope := LEFT( ( ::cFILE)->cCisZakaz, 8 )
*  ( dbSelectAREA( 'UcetPOL'), AdsSetOrder( 11) )
  /*
  cScope := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, LEFT(( ::cFILE)->cCisZakaz, 8),;
                                             LEFT( VyrPOL->cVyrPOL, 8 ) )
  nTag   := IF( ::nKalkulZA = ZA_VYRPOL_ZAK, 11, 16)
  ( dbSelectAREA( 'UcetPOL'), AdsSetOrder( nTag) )
  */
  UcetPOL->( AdsSetOrder( 11) )
*  UcetPOL->( mh_SetSCOPE( Upper( cScope)), dbGoTOP())
  UcetPOLw->( dbZAP())
  nKcMD := 0

  FOR n := 1 TO LEN( ::aKalkulZaZak)
    cScope := LEFT( ::aKalkulZaZak[ n], 8)
    UcetPOL->( mh_SetSCOPE( cScope))

    IF !EMPTY( cScope)
      cUctCFG := ALLTRIM( SysConfig( 'Vyroba:' + acCFG[ nPARAM]))
      aUcty := ListAsARRAY( cUctCFG)
      SET EXACT ON
      DO WHILE !UcetPOL->( EOF())
        lOK := EMPTY( cUctCFG)  // NO
        AEVAL( aUcty, {|X| lOK := IF( LIKE( X, UcetPOL->cUcetMD), YES, lOK) })
        lDenikOK := YES
        AEVAL( acDenikNE, {|X| ;
           lDenikOK := IF( ALLTRIM( UPPER( X)) <> ALLTRIM( UPPER( UcetPOL->cDenik)), lDenikOK, NO) } )  // 16.4.2003
        IF lOK .AND. IF( lCOND, ( UPPER( ALLTRIM( UcetPOL->cDenik)) <> cDenikSKL .AND. lDenikOK ), lDenikOK )
           AADD( aRECs, UcetPOL->(RecNO()) )
           mh_CopyFld( 'UcetPOL', 'UcetPOLw', .t.)
           nKcMD += UcetPOL->nKcMD
        ENDIF
        UcetPOL->( dbSKIP())
      ENDDO
      SET EXACT OFF
      UcetPOL->( dbGoTOP())
    ENDIF
    UcetPOL->( mh_ClrSCOPE())
  NEXT

  ::nSumaKalk := nKcMD
  *
  IF ::lPrepKalALL         //  pøepoèet celé kalkulace
    ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
    ::dm:set( 'M->' + acGet[ nParam], ::nSumaKalk )

  ELSE                   // pøepoèet jedné položky kalkulace
*    mh_RyoFILTER( aRECs, 'UCETPOL' )
    UcetPOLw->( dbGoTOP())
    IF( ::lPrepKalALL, NIL, ::msg:WriteMessage(,0) )
    *
    DRGDIALOG FORM 'VYR_PrimeNAKL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                       EXITSTATE nExit
    IF ( nExit != drgEVENT_QUIT )
      ::dm:set( 'KALKULw->' + ::cActiveGET, ::nSumaKalk / ::dm:get('M->nMnKalk' ))
      ::dm:set( 'M->' + acGet[ nParam], ::nSumaKalk )
      ::drgDialog:oForm:setNextFocus( 'KALKULw->' + ::cActiveGET,, .t. )
    ENDIF
    *
  ENDIF

  UcetPOL->( mh_ClrSCOPE(), mh_ClrFilter())
RETURN self

* Zápis pøímého materiálu dané kalkulace do PRMATw
**HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:PrMatTMP()

  KusTREE->( dbGOTOP())
  DO WHILE ! KusTREE->( EOF())
     PrMatW->( dbAPPEND())
     PrMatW->cCisZakaz  := VyrPol->cCisZakaz
     PrMatW->cVyrPol    := VyrPol->cVyrPol
     PrMatW->nVarCis    := VyrPol->nVarCis
     PrMatW->dDatAktual := ::dm:get('KALKULw->dDatAktual')
     PrMatW->nPorKalDen := ::dm:get('KALKULw->nPorKalDen')
     PrMatW->cSklPol    := KusTree->cSklPol
     PrMatW->nSpMnoMJ   := KusTree->nSpMnoNas
     PrMatW->cZkratJedn := KusTree->cZkratJedn
     PrMatW->nCenKalkMJ := VYR_CenaCelkem( 1)
    KusTREE->( dbSKIP())
  ENDDO
  PrMatW->( dbCommit())
RETURN self

* Zápis pøímých mezd dané kalkulace do PRMZDYw
**HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:PrMzdyTMP()
  Local cCisZakaz, cVyrPol, nVarCis, cTag

  cTAG := KusTREE->( AdsSetOrder( 1))
  KusTREE->( dbGoTOP())
  cCisZakaz := KusTREE->cCisZakaz
  cVyrPol   := KusTREE->cVyrPol
  nVarCis   := KusTREE->nVarCis
  KusTREE->( AdsSetOrder( cTAG))

  KusTREE->( dbGOTOP())
  DO WHILE ! KusTREE->( EOF())
     PrMzdyW->( dbAPPEND())
     mh_COPYFLD('KusTREE', 'PRMZDYw' )
     PrMzdyW->cCisZakaz  := cCisZakaz
     PrMzdyW->cVyrPol    := cVyrPol
     PrMzdyW->nVarCis    := nVarCis
     PrMzdyW->dDatAktual := ::dm:get('KALKULw->dDatAktual')
     PrMzdyW->nPorKalDen := ::dm:get('KALKULw->nPorKalDen')
     PrMzdyW->cVyrPolKal := KusTree->cVyrPol
     KusTREE->( dbSKIP())
  ENDDO
  PrMzdyW->( dbCommit())

RETURN self

* HIDDEN************************************************************************
METHOD VYR_KALKUL_CRD:RezieCMP( cCurGet, nAlg )
*  Local cCurGET := ::drgDialog:lastXbpInFocus:cargo:name
  Local cGET := IF( PCount() == 1, cCurGET, '' ), cITEM
  Local nRezieP := 0, nRezieS := 0, nReziePrc := 0
  Local nValALGp, nValALGs, anGET, anALG, n, nKcMD
  Local cKey, cUctyCFG, lReCMP := ( PCount() = 1 ), lOK
  Local cICO := STR( SYSCONFIG( 'SYSTEM:nICO'))
  Local nSemUC, nValUC  // nRunUC, nSemRV, nRunRV
  Local cTypKal := ::dm:get('KALKULw->cTypKalk'), nRecVyr := VyrPOL->( RecNO())

IF ( cTypKal <> 'NED') .OR. ( cTypKal == 'NED' .AND. ::nKalkNED == 2 )

  IF( Used('FixNAKL') , NIL, drgDBMS:open('FixNAKL'))
*  anALG := If( lReCMP, { oREZa, vREZa, zREZa, sREZa }, { nCurGet } )
  anALG := If( lReCMP, { 'KALKULw->nAlgOdbyt', 'KALKULw->nAlgVyrob',;
                         'KALKULw->nAlgZasob', 'KALKULw->nAlgSprav' },;
                       { cCurGet } )
  *
  IF ::nVypREZ == 2 .AND. ( Upper(cGET) = Upper('KALKULw->nTypRezie') .or. Upper(cGET) = Upper('KALKULw->cTypKalk') )
    drgDBMS:open('UcetPOLA')
     /*
     nSemUC := NNETSEMOPN( cICO +'UCTO_AKTUc_RUNs', 0)
     // nRunUC := NNETSEMOPC( nSemUC )
     nValUC := NNETSEMVAL( nSemUC )
     IF nValUC == 2
        BOX_ALERT( cEM, { 'SkuteŸn‚ re§ie nelze zjistit, neboœ nad',;
                          '£Ÿetn¡m souborem je v £Ÿetnictv¡ pr vØ ',;
                          'prov dØna aktualizace dat !' }, acWAIT,, 9   )
     ELSE
        DC_DcOPEN( { 'UcetPOLA,11'} )
     ENDIF
    */
  ENDIF
  *
  FOR n := 1 TO LEN( anALG)
    nALG    := If( lReCMP, ::dm:get( anALG[ n]), nALG  )
    cCurGet := If( lReCMP, anALG[ n]           , cCurGet )
*    cCurGet := If( lReCMP, anALG[ n]             , cGet )
    lOK     := ( cTypKal == 'STD' .OR. cTypKal == 'DAV' ) .OR. ;
               ( cTypKal == 'VYR' .AND. cCurGET = 'nAlgVyrob' ) .OR. ;
               ( cTypKal == 'NED' .AND. cCurGET = 'nAlgVyrob' .AND. ::nKalkNED == 2 )
    DO CASE
      CASE Upper(cCurGET) = Upper('KALKULw->nAlgOdbyt')  // oREZa   // Odbytová 
           anGET     := { 'M->nRezOdbytP', 'KALKULw->nRezOdbytS', 'M->nRezOdbytS' }
           nReziePrc := If( ::dm:get( 'KALKULw->nTypRezie') == 1, FixNakl->nOdbytReVy,;
                                                                  FixNakl->nOdbytReNa )
           cUctyCFG := 'cUctOdbREZ'

      CASE Upper(cCurGET) = Upper('KALKULw->nAlgZasob')         // zREZa   // Zásobovací
           anGET     := { 'M->nRezZasobP', 'KALKULw->nRezZasobS', 'M->nRezZasobS' }
           nReziePrc := If( ::dm:get( 'KALKULw->nTypRezie') == 1, FixNakl->nZasobReVy,;
                                                                  FixNakl->nZasobReNa )
           cUctyCFG := 'cUctZasREZ'

      CASE Upper(cCurGET) = Upper('KALKULw->nAlgVyrob')    //vREZa   // Výrobní
           *anGET     := { vREZpk, vREZs, vREZsk }
           anGET     := { 'M->nRezVyrobP', 'KALKULw->nRezVyrobS', 'M->nRezVyrobS' }
           nReziePrc := If( ::dm:get( 'KALKULw->nTypRezie') == 1, FixNakl->nVyrobReVy,;
                                                                  FixNakl->nVyrobReNa )
           cUctyCFG := 'cUctVyrREZ'

      CASE Upper(cCurGET) = Upper('KALKULw->nAlgSprav')     // sREZa   // Správní
           *anGET     := { sREZpk, sREZs, sREZsk }
           anGET     := { 'M->nRezSpravP', 'KALKULw->nRezSpravS', 'M->nRezSpravS' }
           nReziePrc := If( ::dm:get( 'KALKULw->nTypRezie') == 1, FixNakl->nSpravReVy,;
                                                                  FixNakl->nSpravReNa )
           cUctyCFG := 'cUctSprREZ'
    ENDCASE

    IF ::nVypREZ == 3 .AND. Upper(cCurGET) = Upper('KALKULw->nAlgVyrob')  // ze sazeb pracoviš a pouze výrobní režie
*      nRezieP := ::vREZ_Plan( ::dm:get( 'KALKULw->nMnozDavky'),, ::nVypREZ, cCurGET )
      nRezieP := ::vREZ_Plan()
      ::dm:set( 'KALKULw->nRezVyrobP', KALKULw->nRezVyrobP := nRezieP )
      ::dm:set( 'M->nRezVyrobP'      , ::nRezVyrobP        := nRezieP * ::dm:get( 'M->nMnKalk') )
    ELSEIF lOK
      nValALGp := IIF( nALG == 1, ::dm:get( 'KALKULw->nCenMatMjP'),;
                  IIF( nALG == 2, ::dm:get( 'KALKULw->nCenMzdVdP'),;
                  IIF( nALG == 3, ::dm:get( 'KALKULw->nCenMatMjP') + ::dm:get( 'KALKULw->nCenMzdVdP'),;
                  IIF( nALG == 4, ::dm:get( 'KALKULw->nCenMzdVdP') + ::dm:get( 'KALKULw->nCenSluzbP'),;
                  IIF( nALG == 5, ::dm:get( 'KALKULw->nCenMzdVdP') + ::dm:get( 'KALKULw->nCenMatMjP') + ;
                                  ::dm:get( 'KALKULw->nCenOstatP') + ::dm:get( 'KALKULw->nCenSluzbP') + ;
                                  ::dm:get( 'KALKULw->nCenSluzbP'),;
                  IIF( nALG == 6, ::vREZ_Plan( nALG),;
                  IIF( nALG == 7, ::dm:get( 'KALKULw->nCenSluzbP'), 0 )))))))
*                  IIF( nALG == 6, ::vREZ_Plan( ::dm:get( 'KALKULw->nMnozDavky'), nALG, ::nVypREZ, cCurGET ), 0 ))))))
      nRezieP := ( nValALGp / 100) * nReziePrc

      IF Upper(cCurGET) = Upper('KALKULw->nAlgOdbyt')
        ::dm:set( 'KALKULw->nRezOdbytP', KALKULw->nRezOdbytP := nRezieP)
      ELSEIF Upper(cCurGET) = Upper('KALKULw->nAlgZasob')
        ::dm:set( 'KALKULw->nRezZasobP', KALKULw->nRezZasobP := nRezieP)
      ELSEIF Upper(cCurGET) = Upper('KALKULw->nAlgVyrob')
        ::dm:set( 'KALKULw->nRezVyrobP', KALKULw->nRezVyrobP := nRezieP)
      ELSEIF Upper(cCurGET) = Upper('KALKULw->nAlgSprav')
        ::dm:set( 'KALKULw->nRezSpravP', KALKULw->nRezSpravP := nRezieP)
      ENDIF
      ::dm:set( anGet[ 1], nRezieP * ::dm:get( 'M->nMnKalk') )
      cITEM := StrTRAN( anGET[ 1], 'M->', '')
      self:&cITEM := nRezieP * ::dm:get( 'M->nMnKalk')
**      &(anGET[ 1]) := nRezieP * ::dm:get( 'M->nMnKalk')
**      self:&anGET[ 1] := nRezieP * ::dm:get( 'M->nMnKalk')
    ENDIF
    ** Skuteèné režie
    IF lOK
      IF ::nVypREZ = 1         // z režijních sazeb
        nValALGs := IIF( nALG == 1, ::dm:get( 'M->nCenMatMjS'),;
                    IIF( nALG == 2, ::dm:get( 'M->nCenMzdVdS'),;
                    IIF( nALG == 3, ::dm:get( 'M->nCenMatMjS') + ::dm:get( 'M->nCenMzdVdS'),;
                    IIF( nALG == 4, ::dm:get( 'M->nCenMzdVdS') + ::dm:get( 'M->nCenSluzbS'),;
                    IIF( nALG == 6, VYR_vREZ_Skut( nALG ),;
                    IIF( nALG == 7, ::dm:get( 'M->nCenSluzbS'), 0 ))))))
        nRezieS := ( nValALGs / 100) * nReziePrc
*        ::dm:set( anGET[ 3], nRezieS )
        ::dm:set( anGET[ 3], &(anGET[ 3]) := nRezieS )
        ::dm:set( anGet[ 2], &(anGet[ 2]) := nRezieS / ::dm:get( 'M->nMnKalk') )     // !!! nRezieS * ::dm:get( 'M->nMnKalk')
      ELSEIF ::nVypREZ = 2     // z úèetních položek
        * Vypoète skuteèné režie pouze jednou, po editaèní pol. typ režie
        IF ( Upper(cGET) = Upper('KALKULw->nTypRezie') .or. Upper(cGET) = Upper('KALKULw->cTypKalk') )  .AND. SELECT( 'UcetPOLA') <> 0
           nKcMD := UcetPOL_SKU( cUctyCFG, NO )
           ::dm:set( anGET[ 3], nKcMD )
           ::dm:set( anGET[ 2], nKcMD / ::dm:get( 'M->nMnKalk') )
        ENDIF
      ELSEIF ::nVypREZ == 3     // ze sazeb pracoviš
        IF Upper(cCurGET) = Upper('KALKULw->nAlgVyrob')   // vREZa
           nKcMD := VYR_vREZ_Skut()
           ::dm:set( anGET[ 3], nKcMD )
           ::dm:set( anGET[ 2], nKcMD / ::dm:get( 'M->nMnKalk') )
        ENDIF
      ENDIF
    ENDIF
  NEXT

  IF ::nVypREZ = 2 .AND. Upper(cGET) = Upper('KALKULw->nTypRezie') // cGET = TypREZ
*     DC_DcCLOSE( 'UcetPOLA' )
*     NNETSEMCLO( nSemUC)
  ENDIF
  VyrPOL->( dbGoTO( nRecVyr))
ENDIF


RETURN self

* Výpoèet plánované výrobní režie z POLOPER
** HIDDEN **********************************************************************
METHOD VYR_KALKUL_CRD:vREZ_Plan( nALG)
*  vREZ_Plan( nMnDavka, nALG, nVypRezPar, nCurGET)
  Local nVAL := 0, nHOD := 0, nKC := 0, cKEY
  Local cTAG1 := PolOper->( AdsSetOrder( 1)), cTAG2 := VyrPOL->( AdsSetOrder( 1))
  Local cCurGET := ::drgDialog:lastXbpInFocus:cargo:name
  Local nMnDavka := ::dm:get( 'KALKULw->nMnozDavky')

  DEFAULT nALG TO 0
  IF nALG == 6 .OR. ::nVypRez == 3
    * nad KusTree
    KusTree->( dbGoTOP())
    DO WHILE !KusTREE->( EOF())
      nHOD += IF( ::nVypRez == 3 .AND. cCurGET = 'KALKULw->nAlgVyrob',;
                  KusTREE->nVyrREZIE,;
                  ( KusTREE->nKusovCas + KusTREE->nPriprCas) / 60 )
      KusTREE->( dbSKIP())
    ENDDO
    nVAL := IF( ::nVypRez == 3 .AND. cCurGET = 'KALKULw->nAlgVyrob', nHOD, nHod * 100)
  ELSE
    * nad POLOPER
    PolOPER->( mh_SetScope( Upper( VYRZAK->cCisZakaz)))
    DO WHILE !PolOPER->( EOF())
      IF Operace->( dbSEEK( Upper( PolOPER->cOznOper),,'OPER1'))
         C_Pracov->( dbSEEK( Upper( Operace->cOznPrac),,'C_PRAC1'))
         nKC += (( PolOPER->nPriprCAS/nMnDavka + PolOPER->nCelkKusCA) * C_Pracov->nSazbaStro) / 60
      ENDIF
      PolOPER->( dbSKIP())
    ENDDO
    PolOPER->( mh_ClrScope())
    ( PolOPER->( AdsSetOrder( cTAG1)), VyrPOL->( AdsSetOrder( cTAG2)) )
    nVAL := nKC
  ENDIF

RETURN nVAL

* Zjistí a do pole ::aKalkulZaZak uloží zakázky, pro které se má kalkulace
* vyrábìné položky poèítat
** HIDDEN **********************************************************************
METHOD VYR_KALKUL_CRD:GetKalkulZaZak()
  Local lCondOK := .T.
  *
  IF ::nKalkulZA = ZA_VYRPOL_ALL
    ::nMnozPlano := 0
    *
    drgDBMS:open('VyrZAK',,,,,'VyrZAKa' )
    VyrZAKa->( AdsSetOrder( 2)     ,;
               mh_setScope( Upper(VyrPOL->cVyrPOL)) )
    ::aKalkulZaZak := {}
    DO WHILE ! VyrZAKa->( Eof())
/*
   Vyjasnit, jaké podmínky musí zakázka splòovat, aby byla zahrnuta do výpoètu kalkulace:
    1. musí být uzavøená
    2.  ???
*/
*      lCondOK := VyrZAKa->cStavZakaz = 'U'
      IF lCondOK
        IF ( nPos := aScan( ::aKalkulZaZak, VyrZAKa->cCisZakaz) = 0 )
          AADD( ::aKalkulZaZak, VyrZAKa->cCisZakaz )
          ::nMnozPlano += VyrZAKa->nMnozPlano
        ENDIF
      ENDIF
      VyrZAKa->( dbSkip())
    ENDDO
    VyrZAKa->( dbCloseArea())
  ELSE
    * Kalkulace na konkrétní zakázku, na níž uživatel stojí na scr
    ::aKalkulZaZak := { VyrPOL->cCisZakaz }
    ::nMnozPlano   := IF( ::cFILE = 'Vyrzak', VyrZak->nMnozPlano, 1)
  ENDIF
RETURN self

** HIDDEN **********************************************************************
METHOD VYR_KALKUL_CRD:SetColorBG( oXbp)

  IF ::cActiveGET <> drgParseSecond(oXbp:cargo:Name, '>')
    IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
      oXbp:setColorBG( oXbp:cargo:clrFocus )
    ENDIF
    *
    oXbp :=  ::dm:get( 'Kalkulw->' + ::cActiveGET, .F.):oDrg:oXbp
    IF IsObject(oXbp:Cargo) .and. oXbp:cargo:className() = 'drgGet'
      oXbp:setColorBG( GraMakeRGBColor( {255, 255, 200} ) )
    ENDIF
  ENDIF
RETURN self

* HIDDEN ***********************************************************************
METHOD VYR_KALKUL_CRD:modiFrm()
  Local  membORG := ::dc:members[1]:aMembers, membCRD := {}
  Local  varsORG := ::dm:vars, varsCRD := drgArray():new()
  Local  oVar, x

  For x := 1 TO Len( membORG)
    oVar := membORG[x]
    If IsMemberVar(oVAR,'Groups')
      If IsCharacter(oVAR:Groups)
        If oVAR:Groups <> ''
          oVAR:IsEDIT := .F.
          oVAR:oXbp:Hide()
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:hide()
          EndIf
        EndIf
      EndIf
    Endif
  Next
*
  For x := 1 TO Len( membORG)
    oVar := membORG[x]
    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        IF  EMPTY(  oVAR:Groups) .OR.  AllTrim( Str(::nKalkulZA)) $ oVAR:Groups  // ::nKalkulZA = VAL( oVAR:Groups)
          IF( isMemberVar( oVar,'obord') .and. isObject(oVar:obord))
            oVar:obord:Show()
          EndIf
          IF oVAR:ClassName() $ 'drgGet,drgComboBox,drgMLE,drgRadioButton,drgCheckBox'
            oVAR:IsEDIT := .t.
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ELSE
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
          ENDIF
        ELSEIf ! EMPTY( oVAR:Groups)
          If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
            oVar:pushGet:oxbp:hide()
          EndIf
        EndIf
      EndIf
    ELSE
      AADD( membCRD, oVar)
    ENDIF
  Next
  *
  For x := 1 To LEN( varsORG:values)
    IF ! IsNIL( varsORG:values[x, 2] )
      oVAR := varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. AllTrim( Str(::nKalkulZA)) $ oVAR:Groups  // ( VAL(oVar:Groups) = ::nKalkulZa )
          varsCRD:add(oVar:oVar, oVar:oVar:name)
        ENDIF
      ELSEIF oVAR:ClassName() $ 'drgMLE'
        varsCRD:add(oVar:oVar, oVar:oVar:name)
      ENDIF
    ENDIF
  NEXT
  *
  FOR x := 1 TO LEN( membCRD)
    IF membCRD[x]:ClassName() = 'drgTabPage'
      membCRD[x]:onFormIndex := x
    ENDIF
  NEXT

  ::df:aMembers := membCRD
  ::dm:vars     := varsCRD

RETURN NIL


*===============================================================================
FUNCTION VYR_MlOperace()
  Local cNazOper
  ListHD->( dbSEEK( StrZERO( ListITw->nRokVytvor,4) + StrZERO( ListITw->nPorCisLis, 12) ))
  cNazOper := LEFT( ListHD->cNazOper, 25 )
Return( ListHD->cNazOper )

*===============================================================================
FUNCTION VYR_KcNaOpeSK()
  Local nKcNaOpeSk
  nKcNaOpeSK := round( ListITw->nNhNaOpeSK * ;
                      ( fSazTAR(ListITw->dVyhotSkut)[1] * ( fSazZam('PRCPREHLCI', ListITw->dVyhotSkut) / 100 +1)), 2)
RETURN nKcNaOpeSk

* Výpoèet prodejní ceny skuteèné do kalkulace ...
*-------------------------------------------------------------------------------
FUNCTION ProdCENAsk( nFaktMn)
  Local nProdCENA  := 0
  Local cUctExtFak := ALLTRIM( SysCONFIG( 'Vyroba:cUctExtFak'))
  Local cUctIntFak := ALLTRIM( SysCONFIG( 'Vyroba:cUctIntFak'))
  Local aUcty, lOK := NO

  DEFAULT cUctExtFak TO '*', cUctIntFak TO '*'

  IF nFaktMn == 1     // Fakt.množství z odvádìných zakázek
    nProdCENA := VyrZAK->nCenaCELK
*  ELSE                // Fakt.množství brát z faktur
  ELSEIF !EMPTY( VYRZAK->cNazPol3)                // Fakt.množství brát z faktur
    *
    FakVysIT->( mh_SetScope( Upper( VYRZAK->cNazPol3)))
    aUcty := ListAsARRAY( cUctExtFak)
    DO WHILE !FakVysIT->( EOF())
      FakVysHD->( dbSEEK( FakVysIT->nCisFAK,, 'FODBHD1' ))
      IF FakVysHD->nFinTyp <> 2 .AND. FakVysHD->nFinTyp <> 4 // nezahrnovat zálohové fakt.
        lOK := NO
        AEVAL( aUcty, {|X| lOK := IF( LIKE( X, FakVysIT->cUcet), YES, lOK) })
        IF( lOK, nProdCENA += FakVysIT->nCenZakCEL, NIL )
      ENDIF
      FakVysIT->( dbSKIP())
    ENDDO
    FakVysIT->( mh_ClrScope())
    *
    FakVnpIT->( mh_SetScope( Upper( VYRZAK->cNazPol3)))
    aUcty := ListAsARRAY( cUctIntFak)
    DO WHILE !FakVNPIT->( EOF())
      lOK := NO
      AEVAL( aUcty, {|X| lOK := IF( LIKE( X, FakVNPIT->cUcet), YES, lOK) })
      IF( lOK, nProdCENA += FakVNPIT->nCenZakCEL, NIL )
      FakVNPIT->( dbSKIP())
    ENDDO
    FakVnpIT->( mh_ClrScope())
    *
  ENDIF
RETURN nProdCENA

* Výpoèet skuteèné režie do kalkulací z UcetPOLA - Viz. UcetPOL_NED()
*-------------------------------------------------------------------------------
FUNCTION UcetPOL_SKU( cUctyCFG, lDenSKL )
  Local cUcty := ALLTRIM( PADR( SysConfig('Vyroba:' + cUctyCFG), 58))
  Local aUcty := ListAsARRAY( cUcty)
  Local nKcMD := 0

  IF( Used('UcetPOLA') , NIL, drgDBMS:open('UcetPOLA'))
  UcetPOLA->( AdsSetOrder( 'UCETPO11'))
  dbSelectAREA( 'UcetPOLA')
  UcetPOLA->( mh_SetScope( Upper( VyrZAK->cNazPOL3)) )
    SUM UcetPOLA->nKcMD TO nKcMD FOR {|| UctoCOND( aUcty, lDenSKL) }
  UcetPOLA->( mh_ClrScope())
RETURN nKcMD

*
*-------------------------------------------------------------------------------
STATIC FUNC UctoCOND( aUcty, lDenSKL )
  Local lOK := NO
  Local lDenikOK := IF( lDenSKL, UPPER( ALLTRIM( UcetPOLA->cDenik)) <> cDenikSKL, YES)

  IF lDenikOK     // Vylouèí deník SKLADU ... je-li požadavek
    AEVAL( acDenikNE, {|X| ;
           lDenikOK := IF( X <> ALLTRIM( UPPER( UcetPOLA->cDenik)), lDenikOK, NO) } )
    IF lDenikOK   // Vylouèí deníky nastavené v CFG ... vždy
       AEVAL( aUcty, {|X| lOK := IF( LIKE( X, UcetPOLA->cUcetMD), YES, lOK) })
    ENDIF
  ENDIF
RETURN lOK