/*==============================================================================
  VYR_exportML.PRG   do pùvodních mezd ( M_DAV)
==============================================================================*/
#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "..\VYROBA\VYR_Vyroba.ch"

#pragma Library( "XppUI2.LIB" )

** Hodnoty parametru nExportML - "Typ exportu úkolových mezd"
# DEFINE    DoMEZD       1      // export do modulu MZDY ... A_SYSTEM++
# DEFINE    DoUCTA       2      // export do modulu UCTO ... A_SYSTEM++
*
# DEFINE    aMESICE     { 'Leden'    ,'Únor'     , 'Bøezen'   ,;
                          'Duben'    ,'Kvìten'   , 'Èerven'   ,;
                          'Èervenec' ,'Srpen'    , 'Záøí'     ,;
                          'Øíjen'    ,'Listopad' , 'Prosinec'  }

********************************************************************************
* VYR_exportML ... Export mzdových lístkù
********************************************************************************
CLASS VYR_exportML FROM drgUsrClass

EXPORTED:
  VAR     nExportML, nStredVML, nUcetExp
  VAR     cExportML, aExport, cExpObd, cUloha
  VAR     acStred, alStred, cExpStr //, cExpNazStr
  VAR     Info_export
  *
  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled, getForm
  METHOD  postValidate, CheckItemSelected
  METHOD  exportML_START
  METHOD  exportML_DEL
  METHOD  exportML_UCTO    // Nastavení exportu mzdových lístkù do úèetnictví
  METHOD  Vyr_UcetSYS_sel, Vyr_Stred_sel

  ACCESS ASSIGN METHOD INFO_export  // VAR INFO_export

HIDDEN
  VAR     dm, dc
  METHOD  VisibleActions
  METHOD  SumMDAVx, AppendItms, GenUcetPol, CondIsOK, IsZavren

ENDCLASS

********************************************************************************
METHOD VYR_exportML:init(parent)
  Local cHlp     := AllTrim( SysCONFIG( 'Vyroba:cStrExpML'))
  Local aNazPol1 := ListAsARRAY( cHLP)
  *
  ::drgUsrClass:init(parent)
  *
  ::nExportML  := SysConfig( 'Vyroba:nExportML')
  ::nStredVML  := SysConfig( 'Vyroba:nStredVML')
  ::nUcetEXP   := SysConfig( 'Vyroba:nUcetExp')
  *
  drgDBMS:open('LISTIT'   )
  drgDBMS:open('MsPrc_MD' )
  drgDBMS:open('MsPrc_MZ' )
  drgDBMS:open('VYRZAK'   )
  drgDBMS:open('C_PRIPL'  )
  drgDBMS:open('cNazPOL1' )
  drgDBMS:open('UCETSYS'  )
  drgDBMS:open('UCETPOL'  )
  drgDBMS:open('M_DAV'    )
  drgDBMS:open('DruhyMZD' )
  drgDBMS:open('C_STRED'  )
  drgDBMS:open('C_EXPML'  )
  *
  ::aExport    := { 'do mezd ', 'do úèta '}
  ::cExportML  := 'EXPORT ' + ::aExport[ ::nExportML]
  ::cExpObd    := StrZERO(uctOBDOBI:VYR:NOBDOBI,2) + '/' + STR( uctOBDOBI:VYR:NROK, 4)   //'01/2007'
*  ::cExpStr    := PADR( aNazPOL1[ 1], 8 )
*  cNazPol1->( dbSEEK( Upper( ::cExpStr),, 1))
*  ::cExpNazStr := cNazPol1->cNazev
  ::cUloha     := 'V'   // IF( ::nExportML = DoMEZD, 'M', 'U')
*  UcetSYS->( dbSEEK( 'M' + ::cExpObd,, 2))

RETURN self

********************************************************************************
METHOD VYR_exportML:destroy()
  ::drgUsrClass:destroy()

  ::nExportML := ::nStredVML := ::nUcetEXP := ;
  ::aExport   := ::cExportML := ::cExpObd  := ::cExpStr := ; //::cExpNazStr := ;
  ::Info_export := ::cUloha    := ;
  NIL
RETURN self

********************************************************************************
METHOD VYR_exportML:drgDialogInit(drgDialog)

  drgDialog:dialog:maxButton := drgDialog:dialog:minButton := .F.
  drgDialog:Title := ::aExport[ ::nExportML]
RETURN self

********************************************************************************
METHOD VYR_exportML:drgDialogStart(drgDialog)
  LOCAL  members  := ::drgDialog:oActionBar:Members, x
  *
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  ::Info_export := ''
  ::VisibleActions()
  *
RETURN self

********************************************************************************
METHOD VYR_exportML:eventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE nEvent = drgEVENT_EXIT   //.or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_SAVE
*    ::But_Save()

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
METHOD VYR_exportML:postValidate( oVar)
  LOCAL xVar  := oVar:get(), cName := UPPER(oVar:name), cKEY
  Local lOK := .T.

  DO CASE
    CASE cName = 'M->cExpObd'
      lOK := ::Vyr_UcetSys_sel()
  ENDCASE
RETURN lOK

********************************************************************************
METHOD VYR_exportML:CheckItemSelected( CheckBox)
  Local name := drgParseSecond( CheckBox:oVar:Name,'>')
  Local nPos := VAL( SUBSTR( name, AT( '[', Name) +1, 2 ))

*  self:&Name := CheckBox:Value
  self:alStred[ nPos] := IF( CheckBox:Value = "T", .T., .F. )
RETURN self

* Zrušení exportu mzdových lístkù
********************************************************************************
METHOD VYR_exportML:exportML_Del()
  Local cKEY := Upper( 'V') + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  Local cMsg := 'Požadujete zrušit export mzdových lístkù za obobí [ & ] ?'
  Local oMoment, cKeyUcto

  IF drgIsYesNo(drgNLS:msg( cMsg, ::cExpObd))
     oMoment := SYS_MOMENT( 'Probíhá rušení exportu mzdových lístkù')
    *
    IF     ::nExportML = DoMEZD
      * ???

    ELSEIF ::nExportML = DoUCTA
      cKeyUcto := Upper( 'V') + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0') + '/'+ RIGHT( ::cExpOBD, 2)
      UcetPOL->( OrdSetFocus( 'UCETPOL6'),  mh_SetScope( cKeyUcto ))
      DO WHILE !UcetPOL->( EOF())
        IF UcetPOL->( dbRLock())
          UcetPOL->( dbDelete(), dbUnlock())
        ENDIF
        UcetPOL->( dbSKIP())
      ENDDO
      UcetPOL->( mh_ClrScope())
    ENDIF
    *
    IF UcetSYS->( dbSEEK( cKey,, 'UCETSYS3'))
      IF UcetSYS->( dbRLock())
        UcetSYS->lZavren := .F.
        UcetSYS->( dbUnlock())
        ::VisibleActions()
        ::Info_export := drgNLS:msg( '... EXPORT HRUBÝCH MEZD ZRUŠEN ...')
      ENDIF
    ENDIF

    oMoment:destroy()
  ENDIF
RETURN NIL

* Nastavení exportu mzdových lístkù do úèetnictví
********************************************************************************
METHOD VYR_exportML:exportML_Ucto()
  Local oDialog, nExit

  DRGDIALOG FORM 'VYR_exportML_Ucto' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
RETURN NIL
*
********************************************************************************
METHOD VYR_exportML:exportML_Start()
  Local nAREA := SELECT(), n
  Local cKey, cKeyOLD, cKeyNEW, cObdPREN
  Local nRYO, nCount := 0, nRecCount, nRemainder
  Local nHrubaMzda := 0, nHodiny   := 0, nMnozPrace := 0
  Local nHodFondPD := 0, nHodPresc := 0, nHodPripl := 0
  Local nDoklad, nOrdItem
  Local lNewREC, lOK, lExp, lSEEK
  Local dPrenos := DATE(), cPrenos := SysCONFIG( 'System:cUserAbb')
  Local aREC := {}, bREC := {}
  Local cMsg := 'Požadujete spustit export mzdových lístkùt za obobí [ & ] ?'

  IF ! drgIsYesNo(drgNLS:msg( cMsg, ::cExpObd))
    RETURN NIL
  ENDIF
* drgMsgBox(drgNLS:msg( 'Export ML ' + ::cExportML ))
  IF ! ::CondIsOK()
    RETURN NIL
  ENDIF
  *

  FOR n := 1 TO LEN( ::acStred)
    IF ::alStred[ n]
      ::cExpStr := ::acStred[ n]

      BEGIN SEQUENCE
        IF ::nExportML == DoMEZD              // MZDY A_SYSTEM++
          drgDBMS:open('M_DAVs',.T.,.T.,drgINI:dir_USERfitm); ZAP
          drgDBMS:open('M_DAVx',.T.,.T.,drgINI:dir_USERfitm); ZAP
        ELSEIF ::nExportML == DoUCTA          // ÚÈTO A_SYSTEM++
          drgDBMS:open('M_DAVs',.T.,.T.,drgINI:dir_USERfitm); ZAP
          drgDBMS:open('M_DAVx',.T.,.T.,drgINI:dir_USERfitm); ZAP
        ENDIF
        M_DAVx->( AdsSetOrder( 'M_DAVx01'))
      *  INDEX ON M_DAVx->cNazPol1 + M_DAVx->cNazPol2 + M_DAVx->cNazPol3 TAG NazPol

        IF ::nExportML == DoMEZD
           cKey := RIGHT( ::cExpOBD, 4) + STRTRAN( LEFT( ::cExpOBD, 2), ' ', '0') + '5'
           ** Zruší pøípadný pøedchozí pøenos
           M_DAV->( AdsSetOrder( 4),  mh_SetScope( cKey ))
           DO WHILE !M_DAV->( EOF())
             IF M_DAV->cKmenStrPr = ::cExpStr
               IF M_DAV->( dbRLock())
                  M_DAV->( dbDelete(), dbUnlock())
               ENDIF
             ENDIF
             M_DAV->( dbSKIP())
           ENDDO
           M_DAV->( mh_ClrScope())
        ENDIF
        *
        ::Info_export := drgNLS:msg('1. Generování hrubých mezd ... støedisko ' + ::cExpStr)
        *
        ** Generování M_DAVx z ListIT
        ListIT->( AdsSetOrder( 7) )
        C_Pripl->( AdsSetOrder( 1))

        cObdPREN := LEFT( ::cExpOBD, 3) + RIGHT( ::cExpOBD, 2)
        cObdPREN := STRTRAN( cObdPREN, ' ', '0')
        ListIT->( mh_SetSCOPE( Upper( cObdPREN)))
          nRecCount := dbCOUNT( 'ListIT')
          IF nRecCount == 0
            ::Info_export := drgNLS:msg('Nenalezena žádná data k exportu ...')

            BREAK
          ENDIF
          ListIT->( dbGoTOP())
          DO WHILE !ListIT->( EOF())
            MsPrc_MD->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRDO01'))
            VyrZAK->( dbSEEK( Upper( ListIT->cCisZakaz),, 'VYRZAK1'))
            lExp := NO
            IF UPPER( MsPrc_MD->cKmenStrPr) = UPPER( ::cExpSTR) .AND. MsPrc_MD->lExport
               IF ListIT->nOsCisPrac > 0     // Základní mzda
                  lExp := YES
                  mh_CopyFLD( 'ListIT', 'M_DAVx', .T. )
                  ::AppendITMs()
                  M_DAVx->nDruhMzdy  := ListIT->nDruhMzdy
                  M_DAVx->nHrubaMzd  := ListIT->nKcNaOpeSk
                  M_DAVx->nHodDoklad := ListIT->nNhNaOpeSK
                  IF DruhyMzd->( dbSEEK( ListIT->nDruhMzdy,, 'DRMZDY1'))
                     IF UPPER( DruhyMzd->cTypDMZ) $ 'UKOL,CASO'
                        M_DAVx->nHodFondPD := ListIT->nNhNaOpeSK
                     ENDIF
                  ENDIF

               ENDIF
               IF ListIT->nKcOpePrem > 0           // PRÉMIE KE MZDÌ
                  lExp := YES
                  mh_CopyFLD( 'ListIT', 'M_DAVx', .T. )
                  ::AppendITMs()
                  IF DruhyMzd->( dbSEEK( ListIT->nDruhMzdy,, 'DRMZDY1'))
                     M_DAVx->nDruhMzdy := DruhyMzd->nDruhMzPre
                  ENDIF
                  M_DAVx->nHrubaMzd  := ListIT->nKcOpePrem
                  M_DAVx->nHodDoklad := ListIT->nNhNaOpeSK
                  M_DAVx->nHodPresc  := ListIT->nNhNaOpeSK
               ENDIF
               IF ListIT->nKcOpePrip > 0           // PØÍPLATEK KE MZDÌ
                  lExp := YES
                  mh_CopyFLD( 'ListIT', 'M_DAVx', .T. )
                  ::AppendITMs()
                    cKey := ListIT->cKodPripl
                    C_Pripl->( dbSEEK( Upper( cKey),, 'C_PRIPL1'))
                  M_DAVx->nDruhMzdy  := C_Pripl->nDruhMzdy
                  M_DAVx->nHrubaMzd  := ListIT->nKcOpePrip
                  M_DAVx->nHodPripl  := ListIT->nNhNaOpeSK
               ENDIF
               IF lExp
                  IF LEN( aREC) <= 4095
                    AADD( aREC, ListIT->( RecNO()) )
                  ELSE
                    AADD( bREC, aREC )
                    aREC := {}
                    AADD( aREC, ListIT->( RecNO()) )
                  ENDIF
               ENDIF
            ENDIF
            ( ListIT->( dbSKIP()), nCount++ )
            nRemainder := nCount % 100
            IF( nRemainder == 0, M_DAVx->( dbCOMMIT()), NIL )
          ENDDO
          M_DAVx->( dbCOMMIT())
        ListIT->( mh_ClrSCOPE())


        ** Sumarizace M_DAVx do M_DAVs
        ::INFO_export := drgNLS:msg('2. Sumarizace hrubých mezd ... støedisko ' + ::cExpStr)
        M_DAVx->( AdsSetOrder( 'M_DAVx02'), dbGoTOP() )      // ( AdsSetOrder( 6'))
        *
        ::SumMDAVx()

        IF ::nExportML == DoMEZD   //... Export úkolových mezd == Do modulu MZDY A_SYSTEM

          ** Aktualizace M_DAV souborem M_DAVs
          ::INFO_export := drgNLS:msg('3. Export ( Aktualizace) hrubých mezd ... støedisko ' + ::cExpStr)
          M_DAV->( AdsSetOrder( 5))
          M_DAVs->( AdsSetOrder( 1), dbGoTOP() )
          ( nCount := 0, nRecCount := M_DAVs->( RecCOUNT()) )
          lExp := NO

          DO WHILE !M_DAVs->( EOF())

             cKey := M_DAVs->( Sx_KeyDATA())
             lSEEK := M_DAV->( dbSEEK( cKey,, 'M_DAV5'))
             lOK := IIF( !lSEEK                        , AddREC( 'M_DAV') ,;
                    IIF( M_DAV->cKmenStrPr == ::cExpSTR, ReplREC( 'M_DAV'), AddREC( 'M_DAV') ))
             IF lOK
                lExp := YES
                mh_CopyFLD( 'M_DAVs', 'M_DAV' )
                M_DAV->dDatPoriz  := dPrenos
                M_DAV->nOrdItem   := M_DAVs->nOrdItem * 10
                M_DAV->( dbUnlock())
             ENDIF
             M_DAVs->( dbSKIP())
             nCount++
          ENDDO

        ELSEIF ::nExportML == DoUCTA   //... Export úkolových mezd = Do modulu ÚÈTO A_SYSTEM
          ::GenUcetPOL()   // Generování záznamù do UcetPol
        ENDIF

        IF LEN( bREC) > 0
          AEVAL( bREC, { |Y|;
                 AEVAL( Y, {|X| ListIT->( dbGoTO( X)) ,;
                              IF( ReplREC( 'ListIT'),;
                                  ( ListIT->dPrenos := dPrenos,;
                                    ListIT->cPrenos := cPrenos,;
                                    ListIT->( dbUnlock()))       , NIL) }) })
        ELSE
           AEVAL( aREC, {|X| ListIT->( dbGoTO( X)) ,;
                              IF( ReplREC( 'ListIT'),;
                                  ( ListIT->dPrenos := dPrenos,;
                                    ListIT->cPrenos := cPrenos,;
                                    ListIT->( dbUnlock()))      , NIL) })
        ENDIF

        ::INFO_export := drgNLS:msg('... EXPORT HRUBÝCH MEZD UKONÈEN ... støedisko ' + ::cExpStr)
        ** Nastavení indikace uzavøení pøenosu
      **  nCountPRMs := UzavriPREN()
        ::IsZavren( .T.)

      ENDSEQUENCE
    ENDIF
  NEXT

dbSelectAREA( nAREA)
*/
RETURN NIL

********************************************************************************
METHOD VYR_exportML:SumMDAVx()
  Local cKeyOLD, cKeyNEW
  Local nCount := 0, nRecCount, nRemainder
  Local nHrubaMzda := 0, nHodiny   := 0, nMnozPrace := 0
  Local nHodFondPD := 0, nHodPresc := 0, nHodPripl := 0
  Local nDoklad, nOrdItem

  cKeyOLD   := M_DAVx->( Sx_KeyDATA())
  nDoklad   := M_DAVx->nDoklad
  nOrdItem  := 0
  nCount    := 0
  nRecCount := M_DAVx->( RecCOUNT())

  DO WHILE !M_DAVx->( EOF())

    cKeyNEW := M_DAVx->( Sx_KeyDATA())
    IF cKeyOLD == cKeyNEW
       nHrubaMzda += M_DAVx->nHrubaMzd     //  M_DAVx->Hruba_Mzda
       nHodiny    += M_DAVx->nHodDoklad    //  M_DAVx->Hodiny
       nMnozPrace += M_DAVx->nMnPDoklad    //  M_DAVx->Mnoz_Prace
       nHodFondPD += M_DAVx->nHodFondPD
       nHodPresc  += M_DAVx->nHodPresc
       nHodPripl  += M_DAVx->nHodPripl
    ELSE
       M_DAVx->( dbSKIP( -1))
        mh_CopyFLD( 'M_DAVx', 'M_DAVs', .T.)
        DruhyMzd->( dbSEEK( M_DAVs->nDruhMzdy,, 'DRUHYMZD01'))
        M_DAVs->nHrubaMzd  := mh_RoundNUMB( nHrubaMzda, DruhyMzd->nKodZaokr )
        M_DAVs->nHodDoklad := nHodiny
        M_DAVs->nMnPDoklad := nMnozPrace
        M_DAVs->nSazbaDokl := nHrubaMzda / nHodiny
        M_DAVs->nHodFondPD := nHodFondPD
        M_DAVs->nHodFondKD := nHodFondPD
        M_DAVs->nHodPresc  := nHodPresc
        M_DAVs->nHodPripl  := nHodPripl
        IF nDoklad == M_DAVx->nDoklad
           nOrdItem++
           M_DAVs->nOrdItem := nOrdItem
        ELSE
           nOrdItem := 1
           M_DAVs->nOrdItem := nOrdItem
        ENDIF
        nDoklad := M_DAVx->nDoklad
       M_DAVx->( dbSKIP())
       cKeyOLD := cKeyNEW
       nHrubaMzda := M_DAVx->nHrubaMzd   // Hruba_Mzda
       nHodiny    := M_DAVx->nHodDoklad  // Hodiny
       nMnozPrace := M_DAVx->nMnPDoklad  // Mnoz_Prace
       nHodFondPD := M_DAVx->nHodFondPD
       nHodPresc  := M_DAVx->nHodPresc
       nHodPripl  := M_DAVx->nHodPripl
    ENDIF
    M_DAVx->( dbSKIP())
    nCount++
    nRemainder := nCount % 100
    IF( nRemainder == 0, M_DAVs->( dbCOMMIT()), NIL )
  ENDDO
  *
  IF nRecCount > 0
     M_DAVx->( dbSKIP( -1))
       mh_CopyFLD( 'M_DAVx', 'M_DAVs', .T. )
       DruhyMzd->( dbSEEK( M_DAVs->nDruhMzdy,, 'DRUHYMZD01'))
       M_DAVs->nHrubaMzd  := mh_RoundNUMB( nHrubaMzda, DruhyMzd->nKodZaokr )
       M_DAVs->nHodDoklad := nHodiny
       M_DAVs->nMnPDoklad := nMnozPrace
       M_DAVs->nSazbaDokl := nHrubaMzda / nHodiny
       M_DAVs->nHodFondPD := nHodFondPD
       M_DAVs->nHodFondKD := nHodFondPD
       M_DAVs->nHodPresc  := nHodPresc
       M_DAVs->nHodPripl  := nHodPripl
       IF nDoklad == M_DAVx->nDoklad
          nOrdItem++
          M_DAVs->nOrdItem := nOrdItem
       ENDIF
     M_DAVx->( dbSKIP())
  ENDIF
  M_DAVs->( dbCOMMIT())

RETURN NIL

********************************************************************************
METHOD VYR_exportML:AppendITMs()
  *
  M_DAVx->cKmenStrPR := MsPrc_MD->cKmenStrPr   // NazPol1
  M_DAVx->nOsCisPrac := ListIT->nOsCisPrac
  IF ::nStredVML == 3
    M_DAVx->cNazPOL1 := ListIT->cNazPOL1
  ELSEIF ::nExportML == DoMEZD
    M_DAVx->cNazPOL1   := IF( EMPTY( VyrZAK->cNazPOL1), MsPrc_MD->cKmenStrPR, VyrZAK->cNazPOL1 )
  ELSEIF ::nExportML == DoUCTA
    C_Stred->( dbSEEK( Upper( MsPrc_MD->cKmenStrPr),, 'STRED1'))
    M_DAVx->cNazPOL1 := C_Stred->cNazPOL1
  ENDIF
  M_DAVx->cNazPOL2   := VyrZAK->cNazPOL2
  M_DAVx->cNazPOL3   := VyrZAK->cNazPOL3
  M_DAVx->cNazPOL4   := VyrZAK->cNazPOL4
  M_DAVx->nMnPDoklad := ListIT->nKusyHotov
  M_DAVx->cUloha     := 'M'
  M_DAVx->cDenik     := 'M'   // SysConfig( 'Mzdy:cDenikMzdy')
  M_DAVx->nRok       := YEAR( ListIT->dVyhotSkut)
  M_DAVx->nObdobi    := VAL( LEFT( ListIT->cObdobi, 2))
  M_DAVx->nDoklad    := IIF( ::nExportML == DoMEZD, 5000000000 + ListIT->nOsCisPrac,;
                        IIF( ::nExportML == DoUCTA, VAL( '50' + RIGHT( ListIT->cObdobi, 2) + LEFT( ListIT->cObdobi, 2) + LEFT( ::cExpSTR, 4) ), 0))
//  M_DAVx->JM         := ListIT->cPrijPrac
  M_DAVx->cPracovnik := LEFT( MsPrc_MD->cPracovnik, 25) + StrZERO( M_DAVx->nOsCisPrac)
  M_DAVx->nPorPraVzt := MsPrc_MD->nPorPraVzt
  M_DAVx->cPracZar   := MsPrc_MD->cPracZar
  M_DAVx->cPracZarDo := MsPrc_MD->cPracZar
  *2
  IF ::nExportML == DoMEZD
    IF MsPrc_MZ->( dbSEEK( ListIT->nOsCisPrac,, 'MSPRMZ01'))
      M_DAVx->nTypZamVzt := MsPrc_Mz->nTypZamVzt
      M_DAVx->nTypPraVzt := MsPrc_Mz->nTypPraVzt
      M_DAVx->cMzdKatPra := MsPrc_Mz->cMzdKatPra
      M_DAVx->nZdrPojis  := MsPrc_Mz->nZdrPojis
      M_DAVx->nClenSpol  := IF( MsPrc_Mz->nTypZamVzt = 2 .or. MsPrc_Mz->nTypZamVzt = 3, 1, 0 )
    ENDIF
  ENDIF
RETURN NIL

********************************************************************************
METHOD VYR_exportML:GenUcetPOL()
  Local N, cKEY, lEXIST, lOK
  Local nOrdUcto, nDoklad
  Local cUserAbb := SysConfig( 'System:cUserAbb' )
  Local dDate    := DATE()
  Local cTime    := TIME()

  M_DAVs->( dbGoTop())
  DO WHILE !M_DAVs->( EOF())
    FOR N := 1 TO 6
      cKEY := StrZERO( M_DAVs->nROK, 4) + StrZERO( N, 2)
      IF C_ExpML->( dbSEEK( cKEY,, 'EXPML1'))
         nOrdUcto := IF( N == 1 .OR. N == 3 .OR. N == 5, 1, 2 )
         nDoklad  :=  M_DAVs->nDoklad + IIF( N == 1 .OR. N == 2, 100000000,;
                                        IIF( N == 3 .OR. N == 4, 200000000,;
                                        IIF( N == 5 .OR. N == 6, 300000000, 0 ) ) )
         cKEY := Upper( C_ExpML->cDenik) + StrZERO( nDoklad, 10) + ;
                 StrZERO( M_DAVs->nOrdItem, 5) + StrZERO( nOrdUcto, 1)
         lEXIST := UcetPOL->( dbSEEK( cKEY,, 'UCETPOL1'))
         IF( lOK := IF( lEXIST, ReplREC( 'UcetPOL'), ADDREC( 'UcetPOL') ) )
            UcetPOL->cDENIK   := C_ExpML->cDenik
            IF ::nUcetEXP == 1         // úèet z èíselníku exportù
              UcetPOL->cUcetMD  := C_ExpML->cUcetMD
              UcetPOL->cUcetDAL := C_ExpML->cUcetDAL
            ELSEIF ::nUcetEXP == 2     // úèet vèetnì období
              UcetPOL->cUcetMD  := IF( N == 2, LEFT( C_ExpML->cUcetMD, 4) + STRZERO( M_DAVs->nObdobi, 2), C_ExpML->cUcetMD )
              UcetPOL->cUcetDAL := IF( N == 1, LEFT( C_ExpML->cUcetDAL, 4) + STRZERO( M_DAVs->nObdobi, 2), C_ExpML->cUcetDAL )
            ENDIF

            UcetPOL->cText    := ALLTRIM( C_ExpML->cText) + ' ' + ;
                                 RIGHT( M_DAVs->cObdobi, 2) + '/' + LEFT( M_DAVs->cObdobi, 2)
            DO CASE
              CASE N == 1  ; UcetPOL->nKcMD  := M_DAVs->nHrubaMzd  // Hruba_Mzda
              CASE N == 2  ; UcetPOL->nKcDAL := M_DAVs->nHrubaMzd  // Hruba_Mzda
              CASE N == 3  ; UcetPOL->nKcMD  := ( M_DAVs->nHrubaMzd / 100) * C_ExpML->nProc
              CASE N == 4  ; UcetPOL->nKcDAL := ( M_DAVs->nHrubaMzd / 100) * C_ExpML->nProc
              CASE N == 5  ; UcetPOL->nKcMD  := ( M_DAVs->nHrubaMzd / 100) * C_ExpML->nProc
              CASE N == 6  ; UcetPOL->nKcDAL := ( M_DAVs->nHrubaMzd / 100) * C_ExpML->nProc
            ENDCASE
            UcetPOL->cObdobi    := M_DAVs->cObdobi
            UcetPOL->nRok       := M_DAVs->nROK
            UcetPOL->nObdobi    := M_DAVs->nObdobi
            UcetPOL->cObdobiDan := M_DAVs->cObdobi
            UcetPOL->nDoklad    := nDoklad
            UcetPOL->nOrdItem   := M_DAVs->nOrdItem
            UcetPOL->nOrdUcto   := nOrdUcto
            UcetPOL->nMnozNat   := M_DAVs->nHodDoklad  // Hodiny
            UcetPOL->dDatPoriz  := M_DAVs->dDatPoriz
            UcetPOL->cNazPOL1   := M_DAVs->cNazPOL1
            UcetPOL->cNazPOL2   := M_DAVs->cNazPOL2
            UcetPOL->cNazPOL3   := M_DAVs->cNazPOL3
            UcetPOL->cNazPOL4   := M_DAVs->cNazPOL4
            UcetPOL->cNazPOL5   := M_DAVs->cNazPOL5
            UcetPOL->cNazPOL6   := M_DAVs->cNazPOL6
            UcetPOL->nMainItem  := M_DAVs->nOsCisPrac
            UcetPOL->cUloha     := 'V'      // vyroba  1.2.2010
            UcetPOL->cUserAbb   := cUserAbb
            UcetPOL->dDatZmeny  := dDate
            UcetPOL->cCasZmeny  := cTime
            UcetPOL->( dbUnlock())
         ENDIF
      ENDIF
    NEXT

    M_DAVs->( dbSKIP())
  ENDDO
RETURN NIL

**HIDDEN************************************************************************
METHOD VYR_exportML:CondIsOK()
  Local lOK := NO, nREC := UcetSYS->( RecNO())
  Local acULOHA := { 'MZDY', 'ÚÈETNICTVÍ' }, cKey

  cKey := UPPER( ::cULOHA) + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  IF UcetSYS->( dbSEEK( cKey,, 'UCETSYS3'))
    IF UcetSYS->lZavren
      drgMsgBox(drgNLS:msg( 'Období [ & ] z VÝROBY je v modulu [ & ] již uzavøené !', ::cExpObd, acULOHA[ ::nExportML] ))
    ELSE
      lOK := YES
    ENDIF
  ELSE
    drgMsgBox(drgNLS:msg( 'Období [ & ]  v modulu [ & ]  neexistuje !', ::cExpObd, acULOHA[ ::nExportML] ))
  ENDIF
  UcetSYS->( dbGoTO( nREC))
RETURN lOK

**HIDDEN************************************************************************
METHOD VYR_exportML:IsZavren( lWrtZavren)
  Local cKEY := Upper( 'V') + RIGHT( ::cExpOBD, 4) + PADL( ALLTRIM( LEFT( ::cExpOBD, 2)), 2, '0')
  Local lOK, lZavren := .F.

  DEFAULT lWrtZavren TO .F.
  * Zjistí, zda období existuje a zda je uzavøené
  IF ( lOK := UcetSYS->( dbSEEK( cKEY,, 'UCETSYS3')) )
    lZavren := UcetSYS->lZavren
    IF !lZavren .and. lWrtZavren
      * Není-li uzavøené a je požadavek na uzavøení - uzavøe ho
      IF UcetSYS->( dbRLock())
        UcetSYS->lZavren := YES
        UcetSYS->( dbUnlock())
        lZavren := UcetSYS->lZavren
        ::VisibleActions()
      ENDIF
    ENDIF
  ENDIF

RETURN lZavren

* Výbìr období pøenosu
********************************************************************************
METHOD VYR_exportML:VYR_UcetSYS_SEL( oDlg)
  LOCAL oDialog, nExit, nRec // := UcetSYS->( RecNO())
  LOCAL Value := Upper( ::dm:get('M->cExpObd'))
  Local lOK := ( !Empty( Value) .and. UcetSYS->( dbSEEK( 'V' + RIGHT(Value,4) + LEFT( Value,2),, 'UCETSYS3')))

  UcetSYS->( AdsSetOrder( 3),;
             mh_SetScope( ::cUloha ), dbGoBottom() )
  IF  IsObject( oDlg) .or. !lOK
    DRGDIALOG FORM 'VYR_UCETSYS_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set( oDlg:lastXbpInFocus:cargo:name,;
              StrZero(UcetSYS->nObdobi, 2) + '/' + StrZero(UcetSYS->nRok, 4) )
    nRec := UcetSYS->( RecNO())
    ::dm:save()
    ::VisibleActions()
  ENDIF
  *
  UcetSYS->( mh_ClrScope(), dbGoTo( nRec))

RETURN lOK

* Výbìr období pøenosu
********************************************************************************
METHOD VYR_exportML:VYR_STRED_SEL( oDlg)
  LOCAL oDialog, nExit, nRec // := UcetSYS->( RecNO())
*  LOCAL Value := Upper( ::dm:get('M->cExpObd'))
*  Local lOK := ( !Empty( Value) .and. UcetSYS->( dbSEEK( 'M' + RIGHT(Value,4) + LEFT( Value,2),, 3)))

*  UcetSYS->( AdsSetOrder( 3),;
*             mh_SetScope( ::cUloha ), dbGoBottom() )
  IF  IsObject( oDlg)   //.or. !lOK
    DRGDIALOG FORM 'VYR_STRED_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
*    ::dm:set( oDlg:lastXbpInFocus:cargo:name,;
*              StrZero(UcetSYS->nObdobi, 2) + '/' + StrZero(UcetSYS->nRok, 4) )
*    nRec := UcetSYS->( RecNO())
  ENDIF
  *
*  UcetSYS->( mh_ClrScope(), dbGoTo( nRec))

RETURN lOK


* Aktualizuje viditelnost action-tlaèítek
** HIDDEN******************************************************************************
METHOD VYR_exportML:VisibleActions()
  LOCAL members  := ::drgDialog:oActionBar:Members, x, lOk
  /* orig
  FOR x := 1 TO LEN( Members)
    IF Upper( members[x]:event) $ 'EXPORTML_UCTO'
      members[x]:disabled := ( ::nExportML = DoMEZD)
      members[x]:oXbp:setColorFG( If( members[x]:disabled , GraMakeRGBColor({128,128,128}),;
                                                            GraMakeRGBColor({0,0,0})))
    ENDIF
    IF Upper( members[x]:event) $ 'EXPORTML_DEL'
      members[x]:disabled := !::IsZavren()
      members[x]:oXbp:setColorFG( If( members[x]:disabled , GraMakeRGBColor({128,128,128}),;
                                                            GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT
  */
  FOR x := 1 TO LEN( Members)
    IF Upper( members[x]:event) $ 'EXPORTML_UCTO'
      lOk := ( ::nExportML = DoMEZD)
      IF( lOk, members[x]:oXbp:disable(), members[x]:oXbp:enable() )
      members[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                           GraMakeRGBColor({0,0,0})))
     ELSEIF Upper( members[x]:event) $ 'EXPORTML_DEL'
      lOk := !::IsZavren()
      IF( lOk, members[x]:oXbp:disable(), members[x]:oXbp:enable() )
      members[x]:oXbp:setColorFG( If( lOk, GraMakeRGBColor({128,128,128}),;
                                           GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT

RETURN self

********************************************************************************
METHOD VYR_exportML:INFO_export( cINFO)

  IF Valtype( cINFO ) == "C"
    ::INFO_export := cINFO
    ::dm:set('M->Info_export', ::Info_export)
    ::dm:save()
    ::dm:refresh()
  ENDIF
RETURN  ::Info_export

********************************************************************************
METHOD VYR_exportML:getForm()
  LOCAL oDrg, drgFC, n, x, y
  Local acStr

  ::acStred := ListAsARRAY(  ALLTRIM( SysCONFIG( 'Vyroba:cStrExpML')))
  ::alStred := {}
  acStr     := ListAsARRAY(  ALLTRIM( SysCONFIG( 'Vyroba:cStrExpML')))

  aEval( ::acStred, {|| aAdd( ::alStred, .F. )} )
 *
  FOR x := 1 TO Len( ::acStred)
    IF cNazPol1->( dbSEEK( Upper( ::acStred[ x] )))
      acStr[ x] := acStr[ x] + ' - ' + cNazPol1->cNazev
    ENDIF
  NEXT
  *
  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 80, 20 DTYPE '10' TITLE 'Export mzdových lístkù' ;
                                            GUILOOK 'All:N,Action:y,IconBar:n,Menu:n'

  DRGACTION INTO drgFC CAPTION '~Spustit export'   EVENT 'ExportML_Start' TIPTEXT 'Spustí export mzdových lístkù'
  DRGACTION INTO drgFC CAPTION '~Zrušit export'    EVENT 'ExportML_Del'   TIPTEXT 'Zruší export mzdových lístkù'
  DRGACTION INTO drgFC CAPTION '~Nastavit exp.'    EVENT 'ExportML_Ucto'  TIPTEXT 'Nastavení exportu mzdových lístkù do úèetnictví'

  DRGSTATIC INTO drgFC FPOS 0, 0 SIZE 79.6, 3 STYPE XBPSTATIC_TYPE_RAISEDBOX RESIZE 'yx'
  DRGTEXT INTO drgFC NAME M->cExportML      CPOS  1,  1  CLEN 15  FONT 5
    DRGTEXT INTO drgFC CAPTION 'za období'  CPOS 20,  1  CLEN 15
    DRGGET M->cExpObd INTO drgFC            FPOS 35,  1  FLEN 10
    drgFC:members[ Len( drgFC:members)]:push := 'VYR_UCETSYS_SEL'
  DRGEND  INTO drgFC

  DRGTABPAGE INTO drgFC CAPTION 'Støediska'  FPOS 0.2, 3 SIZE 79.6,13.8  OFFSET 1,82
    FOR x := 1 TO LEN( acStr)
      y := IF( x <= 10,  3,;
           IF( x <= 20, 30, 57 ))
      n := IF( y = 30, x - 4,;
           IF( y = 57, x - 8, x  ))
      DRGCHECKBOX M->alStred[x] INTO drgFC   FPOS y, n   FLEN 20   VALUES 'T:'+ acStr[ x]+ ',' + 'F:' + acStr[ x]
      oDrg:name := 'M->alStred[' + Str(x,2) + ']'

    NEXT
  DRGEND INTO drgFC
  *
  DRGTEXT INTO drgFC CAPTION 'Prùbìh exportu'      CPOS  1, 18  CLEN 15
  DRGTEXT INTO drgFC NAME M->Info_export           CPOS 20, 18  CLEN 58  BGND 13  FONT 5 CTYPE 3

RETURN drgFC

********************************************************************************
********************************************************************************

CLASS VYR_UcetSYS_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, getForm
HIDDEN:
  VAR  drgGet
ENDCLASS

********************************************************************************
METHOD VYR_UcetSYS_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('UcetSYS',,,,,'UcetSYSw')
RETURN self

**********************************************************************
METHOD VYR_UcetSYS_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

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
METHOD VYR_UcetSYS_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

********************************************************************************
METHOD VYR_UcetSYS_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF .not. Ucetsys ->(DbSeek( 'V' + Right(::drgGet:oVar:value, 4) + Left(::drgGet:oVar:value, 2),,'UCETSYS3'))
       UcetSYS->(DbGoTop())
    ENDIF
*    drgDialog:dialogCtrl:browseRefresh()
    drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_UcetSYS_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 25, 13 DTYPE '10' TITLE 'Úèetní období - VÝBÌR' ;
                                           FILE 'UcetSYS'                   ;
                                           GUILOOK 'All:N,Border:Y'
  DRGDBROWSE INTO drgFC SIZE 25,12.8 INDEXORD 3 ;
                       FIELDS 'MESIC():Mìsíc, nRok:Rok, cUloha'  ;
                       SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC

FUNCTION MESIC()
RETURN aMESICE[UcetSYS->nObdobi]

********************************************************************************
********************************************************************************

CLASS VYR_Stred_SEL FROM drgUsrClass

EXPORTED:
  METHOD  Init, drgDialogInit, drgDialogStart, EventHandled, getForm
HIDDEN:
  VAR  drgGet
ENDCLASS

********************************************************************************
METHOD VYR_Stred_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('UcetSYS',,,,,'UcetSYSw')
RETURN self

********************************************************************************
METHOD VYR_Stred_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

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
METHOD VYR_Stred_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.
  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN

********************************************************************************
METHOD VYR_Stred_SEL:drgDialogStart(drgDialog)
  IF IsObject(::drgGet)
    IF .not. Ucetsys ->(DbSeek('V' + Right(::drgGet:oVar:value, 4) + Left(::drgGet:oVar:value, 2),,'UCETSYS3'))
       UcetSYS->(DbGoTop())
    ENDIF
*    drgDialog:dialogCtrl:browseRefresh()
    drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  ENDIF
RETURN self

********************************************************************************
METHOD VYR_Stred_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 35, 13 DTYPE '10' TITLE 'Støediska exportu - VÝBÌR' ;
                                           FILE 'cNazPOL1'                   ;
                                           GUILOOK 'All:N,Border:Y'
  DRGDBROWSE INTO drgFC SIZE 35,12.8 INDEXORD 3 ;
                       FIELDS 'cNazPol1:Stredisko, cNazev:Název støediska'  ;
                       SCROLL 'ny' CURSORMODE 3 PP 7
RETURN drgFC