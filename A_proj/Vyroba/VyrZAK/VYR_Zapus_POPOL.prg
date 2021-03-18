/*==============================================================================
  VYR_Zapus_POPOL.PRG
  ----------------------------------------------------------------------------
  XPP              ->  DOS           in   DOS.Prg
  VYR_ScopeOPER()      ScopeOper()        Kusov.Prg
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#DEFINE  tab_INFO      1
#DEFINE  tab_OPERACE   2
********************************************************************************
*
********************************************************************************
CLASS VYR_Zapus_POPOL FROM drgUsrClass, VYR_KusTREE_gen
EXPORTED:
  VAR     nRec
  VAR     nMnPotreby, nMnKREZER, nMnVolne
  VAR     cTypStrFIN, cStredFIN

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled
  METHOD  TreeItemMarked, TreeItemSelected

  METHOD  PostValidate, PostLastField

  METHOD  Stred_VysPol, Stred_Final, Nuluj_MnZadVA

HIDDEN:
  VAR     dc, dm
  VAR     tabNUM, lNewREC

  METHOD  FilesSYNC
  METHOD  OptimMnoz
ENDCLASS

*
********************************************************************************
METHOD VYR_Zapus_POPOL:init(parent)

  ::drgUsrClass:init(parent)
  *
  ::VYR_KusTREE_gen:init(parent)
  ::VYR_KusTREE_gen:nRozpad := ROZPAD_POPOL

  ::nREC    := KusTREE->( RecNO())
  ::tabNUM  := 1
  ::lNewRec := .F.

  drgDBMS:open('A_VyrZAK'  ,.T.,.T.,drgINI:dir_USERfitm)

RETURN self

*
********************************************************************************
METHOD VYR_Zapus_POPOL:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x

  ::dc := ::drgDialog:dialogCtrl
  ::dm := ::drgDialog:dataManager

  * zamezí rozblikání obrazovky
    _clearEventLoop(.t.)
  *
  FOR x := 1 TO LEN( Members)
    IF members[x]:event = 'SEPARATOR'
      members[x]:oXbp:visible := .F.
      members[x]:oXbp:configure()
     ENDIF
  NEXT

  KusTree->( dbGoTOP())
  ::cTypStrFIN  := KusTREE->cTypStr
  ::cStredFIN   := KusTREE->cStred

  ::OptimMnoz()

  SetAppFocus( ::oTree)
  ::oTree:SetData( ::oTreeItem)

RETURN self

*
********************************************************************************
METHOD VYR_Zapus_POPOL:EventHandled(nEvent, mp1, mp2, oXbp)
*  LOCAL o, xRec

  DO CASE

  CASE nEvent = xbeTV_ItemMarked
    ::TreeItemMarked( mp1, mp2, oXbp)

  CASE nEvent = xbeTV_ItemSelected
*    ::VYR_KUSOV_CRD( xbeK_ENTER)
    ::lNewRec := .F.
    ::TreeItemSelected( mp1, mp2, oXbp)

  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

    CASE nEvent = drgEVENT_SAVE
      IF( oXbp:ClassName() <> 'XbpBrowse', ::postLastField() ,;
                                           PostAppEvent(xbeP_Close, nEvent,,oXbp) )
      RETURN .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    /*
    CASE mp1 = xbeK_INS
      ::lNewRec := .T.
      ::TreeItemSelected( oXbp:getData(),, oXbp)
      * posunout o stranku dolu
      PostAppEvent( xbeSB_Scroll, XBPSB_PREVPAGE,,oXbp)
     */
    CASE mp1 = xbeK_ESC
      IF( oXbp:className() = 'xbpTreeView',;
          PostAppEvent(xbeP_Close,nEvent,,oXbp), SetAppFocus( ::oTree) )
    CASE  ( mp1 > 31 .AND. mp1 < 255) .or. mp1 = xbeK_BS
      IF oXbp:className() = 'xbpTreeView'
        ::dlgSearch( mp1, self)
      ELSE
        RETURN .F.
      ENDIF
    OTHERWISE
      Return .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.

*
********************************************************************************
METHOD VYR_Zapus_POPOL:TreeItemMarked( oItem, aRect, oXbp)

  * Synchronizace TreeView s KusTREE
  KusTree->( dbGoTO( oItem:undoBuffer))
  ::oTreeItem := oItem
  * Synchronizace KusTREE s ost. soubory
  ::FilesSYNC()
  *
  ::nMnPotreby := KusTREE->nSpMnoNAS * KusTREE->nMnZadVA
  ::nMnKREZER  := ::nMnPotreby - KusTREE->nMnZadVA
**  ::nMnVOLNE   := MnozVOLNE()
  * 5.9.2006
  ::dm:set('KusTREE->nMnZadVA'  , KusTREE->nMnZadVA  )
  ::dm:set('KusTREE->cStred'    , KusTREE->cStred    )
  ::dm:set('KusTREE->cTypStr'   , KusTREE->cTypStr   )
  ::dm:set('KusTREE->nStrizPl'  , KusTREE->nStrizPl  )
  ::dm:set('KusTREE->nKusyPas'  , KusTREE->nKusyPas  )
  ::dm:set('CenZBOZ->nMnozSZBO' , CenZBOZ->nMnozSZBO )
  ::dm:set('CenZBOZ->nMnozDZBO' , CenZBOZ->nMnozDZBO )
  *
  ::dm:refresh()

RETURN SELF

*
********************************************************************************
METHOD VYR_Zapus_POPOL:TreeItemSelected( oItem, aRect, oXbp)
  Local oVar
*  ::VYR_KUSOV_CRD()
*  SetAppFocus( oXbp)
*  oXbp:setData( ::oTreeItem)
  ::drgDialog:oForm:setNextFocus('KusTree->nMnZadVA',, .T. )
  ::dm:has('KusTree->nMnZadVA'):initValue := KusTree->nMnZadVA
  ::dm:has('KusTREE->cStred'):initValue   := KusTree->cStred
  ::dm:has('KusTree->nStrizPl'):initValue := KusTree->nStrizPl
  ::dm:has('KusTree->nKusyPas'):initValue := KusTree->nKusyPas
*  oVar := ::dm:has('KusTree->nMnZadVA')
*  oVar:initValue := KusTree->nMnZadVA
RETURN SELF

*
********************************************************************************
METHOD VYR_Zapus_POPOL:PostValidate( oVar)
  LOCAL  xVAL := oVar:get()
  LOCAL  lChanged := oVar:changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-')
  LOCAL  cMSG := 'Množství mùže nabývat hodnot : ', cTypStr
  LOCAL  nMnDoVyroby

  DO CASE
    CASE cName = 'KUSTREE->nMnZadVA'
      IF SysConfig('Vyroba:lOptimMNOZ')
        cTypStr := ::dm:get( 'KUSTREE->cTypStr' )   //G[ 2]:VarGET()
        IF KusTREE->( RecNO()) == 1
          lOK  := ( xVAL == ::nMnPotreby )
          cMSG := 'U finálu nelze hodnotu mìnit !'
        ELSEIF cTypStr == ::cTypStrFIN .AND. CenZBOZ->nMnozDZBO >= ::nMnPotreby  //  lALG[ 1, 1]
          lOK  := ( xVAL == 0) .OR. ( xVAL == ::nMnPotreby )
          cMSG += ' 0 nebo ' + ALLTRIM( STR( ::nMnPotreby, 9, 2))
        ELSEIF cTypStr == ::cTypStrFIN .AND. CenZBOZ->nMnozDZBO < ::nMnPotreby  // lALG[ 1, 2]
          lOK  := ( xVAL == 0) .OR. ( xVAL == ::nMnPotreby )
          cMSG += ' 0 nebo ' + ALLTRIM( STR(:: nMnPotreby, 9, 2))

        ELSEIF cTypStr <> ::cTypStrFIN .AND. CenZBOZ->nMnozDZBO >= ::nMnPotreby   //  lALG[ 2, 1]
          lOK  := ( xVAL >= 0 .AND. xVAL <= ::nMnPotreby )
          cMSG += 'od 0 do ' + ALLTRIM( STR( ::nMnPotreby, 9, 2 )) + '  vèetnì.'
        ELSEIF cTypStr <> ::cTypStrFIN .AND. CenZBOZ->nMnozDZBO < ::nMnPotreby  // lALG[ 2, 2]
          lOK  := ( xVAL >= ::nMnPotreby - CenZBOZ->nMnozDZBO .AND. ;
                    xVAL <= ::nMnPotreby ) .OR. ( xVAL == 0 )
          cMSG += 'od ' + ALLTRIM( STR( ::nMnPotreby - CenZBOZ->nMnozDZBO, 9, 2)) + ;
                  ' do ' + ALLTRIM( STR( ::nMnPotreby, 9, 2)) + ' vèetnì.'
        ELSEIF cTypStr <> ::cTypStrFIN .AND. CenZBOZ->nMnozDZBO == 0   //  lALG[ 2, 3]
          lOK  := ( xVAL == 0) .OR. ( xVAL == ::nMnPotreby )
          cMSG += ' 0 nebo ' + ALLTRIM( STR( ::nMnPotreby, 9, 2))

        ENDIF
        IF !lOK
          drgMsgBox(drgNLS:msg( cMSG) )    // Box_Alert( cEM, cMSG, acWAIT)
         //*=  G[ n]:VarPut( xOrg)
        ELSE
          ::nMnKREZER := ::nMnPOTREBY - xVAL
          ::dm:refresh()
          //::dm:set( 'M->nMnKREZER', ::nMnPOTREBY - xVAL)  // G[ 1]:VarPUT( nMnPOTREBY - xVAL)
        ENDIF
      ELSE
        IF !( lOK := ( xVal >= 0))
          drgMsgBox(drgNLS:msg( 'Údaj nemùže být záporný !') )
          oVar:recall()
        ENDIF
      ENDIF

   CASE cName = 'KUSTREE->cStred'
     IF oVar:changed()
       cTypStr := ::dm:get( 'KUSTREE->cTypStr' )
       IF cTypStr <> KusTREE->cTypSTR
         nMnDoVyroby := MnDoVYROBY( cTypStr, ::cTypStrFIN, ::nMnPOTREBY )
         ::dm:set( 'KusTree->nMnZadVA', nMnDoVyroby )
         ::dm:set( 'M->nMnKREZER'     , ::nMnPOTREBY - nMnDoVyroby )
       ENDIF
     ENDIF

   CASE cName = 'KUSTREE->nStrizPl' .or. cName = 'KUSTREE->nKusyPas'
     IF !( lOK := ( xVal >= 0))
       drgMsgBox(drgNLS:msg( 'Údaj nemùže být záporný !') )
       oVar:recall()
     ENDIF

  ENDCASE

RETURN lOK

*
********************************************************************************
METHOD VYR_Zapus_POPOL:postLastField(drgVar)

  IF( ::dm:changed(), ::dm:save(), nil )
  SetAppFocus( ::oTree)
RETURN .T.

* Typ støediska u nižších nakupovaných položek kusovníku se naplní
* typem støediska vyššího výrobku
********************************************************************************
METHOD VYR_Zapus_POPOL:Stred_VysPol
  Local nREC := KusTREE->( RecNO()), cTypStrVP, nHandle, nVyrSt

  drgMsgBox(drgNLS:msg('Stred_VysPol  ...'),, ::drgDialog:dialog)

  KusTREE->( dbClearFILTER(), dbGoTOP() )
  cTypStrVP := KusTREE->cTypStr
  nVyrSt    := KusTREE->nVyrSt
  KusTREE->( dbSKIP())

  DO WHILE !KusTREE->( EOF())
    IF KusTREE->( RecNO()) > 1
      IF !KusTREE->lNakPol
         cTypStrVP := KusTREE->cTypStr
         nVyrSt    := KusTREE->nVyrSt
      ELSE
        IF KusTREE->nVyrST > nVyrST    // u všech nižších
          KusTREE->cTypStr := cTypStrVP
        ELSE
          // tož tady nevím
        ENDIF
      ENDIF
    ENDIF
    KusTREE->( dbSKIP())
  ENDDO

  /* Obnovení filtru
  nHandle := m6_NewFilter()
  KusTree->( m6_dbEval( ;
    {|| If( !KusTree->lNakPol, m6_FiltAddRec( nHandle, KusTree->( RecNo())), NIL) }))
  m6_SetAreaFilter( nHandle)
  */
  KusTREE->( dbGoTO( nREC))
  ::dm:refresh()

RETURN self

*
********************************************************************************
METHOD VYR_Zapus_POPOL:Stred_Final
  Local nREC := KusTREE->( RecNO()), cTypStrFINAL, nHandle
  Local cMsg := 'Typ støediska byl u všech položek kusovníku naplnìn;' + ;
                'typem støediska finálního výrobku !'

*  drgMsgBox(drgNLS:msg('Stred_Final ...'),, ::drgDialog:dialog)

  KusTREE->( dbClearFILTER(), dbGoTOP() )
  cTypStrFINAL := KusTREE->cTypStr
  KusTREE->( dbEVAL( {|| IF( KusTREE->( RecNO()) > 1,;
                             KusTREE->cTypStr := cTypStrFINAL, NIL ) }))
  drgMsgBox(drgNLS:msg( cMsg))
  ::dm:refresh()
  /* Obnovení filtru
  nHandle := m6_NewFilter()
  KusTree->( m6_dbEval( ;
    {|| If( !KusTree->lNakPol, m6_FiltAddRec( nHandle, KusTree->( RecNo())), NIL) }))
  m6_SetAreaFilter( nHandle)
  */
  KusTREE->( dbGoTO( nREC))

RETURN self

* Nuluje mn. zadané do výroby
********************************************************************************
METHOD VYR_Zapus_POPOL:Nuluj_MnZadVA()
 Local nREC := KusTREE->( RecNO())
  Local cMsg := 'Množství zadané do výroby bylo u všech položek kusovníku vynulováno !'

*  drgMsgBox(drgNLS:msg('Stred_Final ...'),, ::drgDialog:dialog)

  KusTREE->( dbClearFILTER(), dbGoTOP() )
  KusTREE->( dbEVAL( {|| IF( KusTREE->( RecNO()) > 1,;
                             KusTREE->nMnZadVA := 0, NIL ) }))
  drgMsgBox(drgNLS:msg( cMsg))
  ::dm:refresh()
  /* Obnovení filtru
  nHandle := m6_NewFilter()
  KusTree->( m6_dbEval( ;
    {|| If( !KusTree->lNakPol, m6_FiltAddRec( nHandle, KusTree->( RecNo())), NIL) }))
  m6_SetAreaFilter( nHandle)
  */
  KusTREE->( dbGoTO( nREC))
RETURN self

*
********************************************************************************
METHOD VYR_Zapus_POPOL:destroy()
  ::drgUsrClass:destroy()
* EXPORTED
  ::nMnPotreby := ::nMnKREZER := ::nMnVolne := ;
  ::cTypStrFIN := ::cStredFIN := ;
  ::tabNum     := ;
                  NIL
* HIDDEN
  ::dc := ::dm := ;
                  NIL
  KusTREE->( Ads_ClearAof(), dbGoTOP() )
*  KusTREE->( dbCloseArea())
RETURN self

* Synchronizace souborù s TreeView
* HIDDEN ***********************************************************************
METHOD VYR_Zapus_POPOL:FilesSYNC()
  LOCAL cKey, lOK

  cKey := Upper( KusTree->cSklPol)
  lOK := CenZboz->( dbSeek( Upper( KusTREE->cCisSklad) + Upper( cKey),,'CENIK03'))
  lOK := NakPol->( dbSeek( cKey))
  cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) + ;
          StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)
  lOK := Kusov->( dbSeek( cKey))
RETURN self

* Optimalizace množství
* HIDDEN ***********************************************************************
METHOD VYR_Zapus_POPOL:OptimMnoz()
  Local nREC := KusTREE->( RecNO()), nMnPOTREBY
  Local cKEY, cTypStrFIN

  IF SysConfig('Vyroba:lOptimMnoz')
    FOrdREC( { 'CenZBOZ, 3' } )
    KusTREE->( dbGoTOP())
    cTypStrFIN := KusTREE->cTypStr

    DO WHILE !KusTREE->( EOF())
      nMnPOTREBY := KusTREE->nSpMnoNAS * ::drgDialog:parent:UDCP:nMnZapus
      cKEY := Upper( KusTREE->cCisSKLAD) + Upper( KusTREE->cSklPOL)
      CenZBOZ->( dbSEEK( cKEY))
      IF KusTREE->( RecNO()) == 1

      ELSEIF KusTREE->cTypStr == cTypStrFIN     // Algoritmus 1
        IF CenZBOZ->nMnozDZBO >= nMnPOTREBY
           KusTREE->nMnZadVA := 0
        ELSEIF CenZBOZ->nMnozDZBO < nMnPOTREBY
           KusTREE->nMnZadVA := nMnPOTREBY
        ENDIF
      ELSE                                      // Algoritmus 2
        IF CenZBOZ->nMnozDZBO >= nMnPOTREBY
           KusTREE->nMnZadVA := 0
        ELSEIF CenZBOZ->nMnozDZBO == 0
           KusTREE->nMnZadVA := nMnPOTREBY
        ELSEIF CenZBOZ->nMnozDZBO < nMnPOTREBY
           KusTREE->nMnZadVA := nMnPOTREBY - CenZBOZ->nMnozDZBO
        ENDIF
      ENDIF
      KusTREE->( dbSKIP())
    ENDDO
    FOrdREC()
    KusTREE->( dbGoTO( nREC))
  ENDIF

RETURN self

* Výpoèet volného množství
*===============================================================================
STATIC FUNCTION MnozVOLNE()
  Local nMnVOLNE, nSumPLANO := 0, nSumPOTVR := 0
  Local nPotvZAK   //.. Suma ObjZAK->nMnPotVyrZ za jednotlivou zakázku
  Local nDodVyZAK  //.. Suma ObjZAK->nMnozDodVy za jednotlivou zakázku
  Local cTAG1, cTAG2, cTAG3, cKEY, nREC1, nREC2, nREC3, cSTAV
  Local nAREA := SELECT()

*  ( cTAG1 := VyrZAK->( AdsSetOrder( 2)), nREC1 := VyrZAK->( RecNO()) )
*  ( cTAG2 := ObjZAK->( AdsSetOrder( 2)), nREC2 := ObjZAK->( RecNO()) )
*   ( cTAG3 := PVPItem->( AdsSetOrder( 8)), nREC3 := PVPItem->( RecNO()) )
  FOrdREC( { 'VyrZAK, 2', 'ObjZAK, 2', 'PVPITEM, 8'} )
  cKEY := Upper( KusTREE->cVyrPOL) + STRZERO( KusTREE->nVarCis, 3)

  A_VyrZAK->( dbZAP())
//  CreateTMP( 'A_VyrZAK', 'VyrZAK', NO )

  VyrZAK->( mh_SetScope( cKey) )
    DO WHILE !VyrZAK->( EOF())
      cSTAV := ALLTRIM( VyrZAK->cStavZAKAZ)
      IF cSTAV <> 'U' .AND. cSTAV <> '8'
        cKEY := Upper( VyrZAK->cCisZAKAZ)
        ObjZAK->( mh_SetScope( cKey) )
        nPotvZAK := 0
        DO WHILE !ObjZAK->( EOF())
          nPotvZAK  += ObjZAK->nMnPotVyrZ
//          nDodVyZAK += ObjZAK->nMnozDodVy
          ObjZAK->( dbSKIP())
        ENDDO
        ObjZAK->( mh_ClrScope())

        IF VyrZAK->nMnozPLANO > nPotvZAK
          * PVPItem
          PVPItem->( mh_SetScope( Upper( VyrZAK->cNazPOL3) + '01' ) )
          nDodVyZAK := 0
          DO WHILE !PVPItem->( EOF())
            nDodVyZAK += PVPItem->nMnozPrDod
            PVPItem->( dbSKIP())
          ENDDO
          PVPItem->( mh_ClrScope())
          *
          nSumPLANO += VyrZAK->nMnozPLANO
          nSumPOTVR += nPotvZAK
          mh_COPYFLD( 'VyrZAK', 'A_VyrZAK', .T. )
          A_VyrZAK->nCenaMJ    := nPotvZAK
          A_VyrZAK->nCenaCELK  := nDodVyZAK
        ENDIF
      ENDIF
      VyrZAK->( dbSKIP())
    ENDDO
  VyrZAK->( mh_ClrScope())
  FOrdREC()
*  VyrZAK->( AdsSetOrder( cTAG1), dbGoTO( nREC1) )
*  ObjZAK->( AdsSetOrder( cTAG2), dbGoTO( nREC2) )
*  PVPItem->( AdsSetOrder( cTAG3), dbGoTO( nREC3) )
  dbSelectAREA( nAREA)
  nMnVOLNE := nSumPLANO - nSumPOTVR

RETURN nMnVOLNE

*
*===============================================================================
STATIC FUNCTION MnDoVYROBY( cTypStr, cTypStrFIN, nMnPOTREBY)
  Local nMnZadVA

  IF KusTREE->( RecNO()) == 1
     nMnZadVA := nMnPotreby
  //Ä Algoritmus 1
  ELSEIF cTypStr == cTypStrFIN
     IF CenZBOZ->nMnozDZBO >= nMnPotreby
        nMnZadVA   := 0
     ELSEIF CenZBOZ->nMnozDZBO < nMnPotreby
        nMnZadVA   := nMnPotreby
     ENDIF
  ELSE
     IF CenZBOZ->nMnozDZBO >= nMnPotreby
        nMnZadVA   := 0
     ELSEIF CenZBOZ->nMnozDZBO < nMnPotreby
        nMnZadVA   := nMnPotreby - CenZBOZ->nMnozDZBO
     ELSEIF CenZBOZ->nMnozDZBO == 0
        nMnZadVA   := nMnPotreby
     ENDIF
  ENDIF
RETURN nMnZadVA


*  Aktualizace VyrPol + Kusov pøi zapouštìní po položkách
*===============================================================================
FUNCTION VYR_VyrKusAKT( nTypZAP)
  Local cKey, cCisZakaz, n
  Local nRecVP := VyrPol->( RecNO())
  Local cTag   := VyrPol->( AdsSetOrder( 1)), cTagK := Kusov->( AdsSetOrder( 1))
  Local lAktVyrPol := SysConfig('Vyroba:lAktVyrPol')
  *
  local  nmnZADva, nmnZADvk, nmnPROhlvy, nmnVYDzmon

  If nTypZAP = typZAP_POPOL    // zapouštìní ( rozpad) po položkách
     KusTree->( dbGoTop())

     Do While !KusTree->( Eof())
       If !KusTree->lNakPol

          // Aktualizace VYRPOL
          IF lAktVyrPol         // ... zakázkový i nezakázkový
            FOR n := 1 TO 2
              cCisZakaz := If( n == 1, KusTree->cCisZakaz, EMPTY_ZAKAZ )

              cKey       := Upper( cCisZakaz) + Upper( KusTree->cVyrPol) +StrZero( KusTree->nVarPoz, 3)

              nmnZADva   := if( kusTree->nvyrST = 1, kusTree->nmnozZadan, kusTree->nMnZadVA   )
              nmnZADvk   := if( kusTree->nvyrST = 1, 0                  , kusTree->nMnZadVA   )
              nmnPROhlvy := kusTree->nmnozZadan   // if( kusTree->nvyrST = 1, 0                  , kusTree->nmnozZadan )
              nmnVYDzmon := kusTree->nspMNOnas    // if( kusTree->nvyrST = 2, kusTree->nspMNOnas , 0                   )

              If VyrPol->( dbSeek( cKey))
                If ReplRec( 'VyrPol')
                   //*
                   VyrPol->nKusyPas  := KusTree->nKusyPas
                   VyrPol->nStrizPl  := KusTree->nStrizPl
                   VyrPol->cStrVyr   := KusTree->cStred
                   VyrPol->nMnZadVA  := nmnZADva
                   VyrPol->nMnZadVK  += if( empty(ccisZakaz), 0, nmnZADvk )

                   if .not. empty(ccisZakaz)
                     vyrPol->nmnPROhlvy := nmnPROhlvy
                     vyrPol->nmnVYDzmon := nmnVYDzmon
                   endif
                   */
                   VyrPol->( dbUnLock())
                Endif
              Endif
            NEXT
          ELSE                   // ... jen zakázkový

            cKey       := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) +StrZero( KusTree->nVarPoz, 3)

            nmnZADva   := if( kusTree->nvyrST = 1, kusTree->nmnozZadan, kusTree->nMnZadVA   )
            nmnZADvk   := if( kusTree->nvyrST = 1, 0                  , kusTree->nMnZadVA   )
            nmnPROhlvy := kusTree->nmnozZadan
            nmnVYDzmon := kusTree->nspMNOnas

            If VyrPol->( dbSeek( cKey))
              If ReplRec( 'VyrPol')
                 //*
                 VyrPol->nKusyPas   := KusTree->nKusyPas
                 VyrPol->nStrizPl   := KusTree->nStrizPl
                 VyrPol->cStrVyr    := KusTree->cStred
                 VyrPol->nMnZadVA   := nmnZADva
                 VyrPol->nMnZadVK   += nmnZADvk
                 vyrPol->nmnPROhlvy := nmnPROhlvy
                 vyrPol->nmnVYDzmon := nmnVYDzmon
                 */
                 VyrPol->( dbUnLock())
              Endif
            Endif
          ENDIF

          // Aktualizace KUSOV
          cKey := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVysPol) +StrZero( KusTree->nPozice, 3) + StrZero( KusTree->nVarPoz, 3)

          If Kusov->( dbSeek( cKey))
             If ReplRec( 'Kusov')
                //*
                Kusov->nMnZadVAvp := KusTree->nMnZadVAvp
                */
                VyrPol->( dbUnLock())
             Endif
          Endif
       Endif
       KusTree->( dbSkip())
     EndDo

  ELSE    //  u ost.typù zapuštìní aktualizovat ve VyrPol nMnZadVa, nMnZadVk... 18.12.01

     KusTree->( dbGoTop())
     Do While !KusTree->( Eof())
       If !KusTree->lNakPol
          cKey       := Upper( KusTree->cCisZakaz) + Upper( KusTree->cVyrPol) +StrZero( KusTree->nVarPoz, 3)

          nmnZADva   := if( kusTree->nvyrST = 1, kusTree->nmnozZadan, kusTree->nMnZadVA   )
          nmnZADvk   := if( kusTree->nvyrST = 1, 0                  , kusTree->nMnZadVA   )
          nmnPROhlvy := kusTree->nmnozZadan
          nmnVYDzmon := kusTree->nspMNOnas

          If VyrPol->( dbSeek( cKey))
            If VyrPol->( Sx_RLock())
               VyrPol->nMnZadVA   := nmnZADva
               VyrPol->nMnZadVK   += nmnZADvk
               vyrPol->nmnPROhlvy := nmnPROhlvy
               vyrPol->nmnVYDzmon := nmnVYDzmon

               VyrPol->( dbUnLock())
            Endif
          Endif
       EndIf
       KusTree->( dbSkip())
     EndDo
  Endif
  VyrPol->( AdsSetOrder( cTag), dbGoTO( nRecVP) )  //... 11.3.02 ... dbGoTO
  Kusov->( AdsSetOrder( cTagK))
RETURN Nil
*/