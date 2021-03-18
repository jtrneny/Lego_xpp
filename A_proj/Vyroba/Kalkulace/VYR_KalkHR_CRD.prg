
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"
********************************************************************************
*
********************************************************************************
CLASS VYR_KalkHrCMP_CRD FROM drgUsrClass
EXPORTED:
  VAR     nMnKalk, lKalkToCen, lKalkSetAKT
  VAR     nAlgODBYT, nAlgVYROB, nAlgZASOB, nAlgSPRAV, nSazbaPOJ, lDrCenKAL,;
          nPrMatKal, nFaktMnoz,;
          lKalkPLAN, cFile, nKalkCount,;
          fromNabVys

  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled
  METHOD  PostValidate
  METHOD  btn_KalkCMP, KalkCMP_PLAN, KalkCMP_PL_One(), KalkCMP_SKUT  //, KalkCMP_SK_One

HIDDEN:
  VAR     dm, msg
  METHOD  PlanMATER, PlanMZDY, PlanREZIE
  METHOD  SkutMATER, SkutMZDY, SkutKOOPER, SkutREZIE
  METHOD  StavKALK

ENDCLASS

********************************************************************************
METHOD VYR_KalkHrCMP_CRD:init(parent)

  ::drgUsrClass:init(parent)
  *
  ::lKalkPLAN   := ( parent:parent:formName = 'VYR_VyrPolKal_SCR')
  ::cFile       := IF( ::lKalkPLAN, 'VYRPOL', 'VYRZAK' )
  ::fromNabVys  := .F.  //parent:UDCP:fromNabVys
  *
  drgDBMS:open('KUSOV'  )
  drgDBMS:open('VYRZAK' )
  drgDBMS:open('CENZBOZ'); CENZBOZ->( AdsSetOrder( 1))
  drgDBMS:open('FIXNAKL'); FIXNAKL->( AdsSetOrder( 1))
  drgDBMS:open('PRMZDY' ); PRMZDY->( AdsSetOrder( 1))
  drgDBMS:open('KALKUL' )
  drgDBMS:open('KALKULw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KusTREE' ,.T.,.T.,drgINI:dir_USERfitm)
  *
  IF !::lKalkPLAN
    * pøi výpoètu skut.kalkulací je tøeba otevøít další soubory
    drgDBMS:open('PVPITEM'  )
    drgDBMS:open('LISTIT'   )
    drgDBMS:open('MSPRC_MO' )
    drgDBMS:open('OSOBY' )
    drgDBMS:open('UCETPOL'  )
    drgDBMS:open('C_PRACOV' )
    drgDBMS:open('FakVysHD' )
    drgDBMS:open('FakVysIT' ) ; FakVysIT->( AdsSetOrder( 5))
  drgDBMS:open('FakVnpIT'   ) ; FakVnpIT->( AdsSetOrder( 4))
  ENDIF
  ::nMnKalk     := 1
  ::lKalkToCen  := .T.
  ::lKalkSetAKT := .T.

  ::nAlgODBYT := SysCONFIG( 'Vyroba:nOdbytREZ')
  ::nAlgVYROB := SysCONFIG( 'Vyroba:nVyrobREZ')
  ::nAlgZASOB := SysCONFIG( 'Vyroba:nZasobREZ')
  ::nAlgSPRAV := SysCONFIG( 'Vyroba:nSpravREZ')
  ::nSazbaPOJ := SysCONFIG( 'Vyroba:nSazbaPOJ') / 100    // nKoefPoj
  ::lDrCenKAL := SysCONFIG( 'Vyroba:lDrCenKal')
  *
  ::nPrMatKal := SysConfig('Vyroba:nPrMatKal')
  ::nFaktMnoz := SysConfig('Vyroba:nFaktMnoz')
  *
  KALKULw->( dbAppend())
  KALKULw->cTypKALK   := 'STD'
  KALKULw->cZkratMENY := 'CZK'
  KALKULw->nTypREZIE  := 1
  KALKULw->dDatAKTUAL := DATE()
  KALKULw->nRokVyp    := YEAR( DATE())
  KALKULw->nObdMES    := MONTH( DATE())
  KALKULw->nPorKalDen := 1
  KALKULw->nMnozDavky := 1
  KALKULw->cDruhCeny  := '1 '
  KALKULw->nZiskProcP := SysCONFIG( 'Vyroba:nProcZisk')
  *

RETURN self

********************************************************************************
METHOD VYR_KalkHrCMP_CRD:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += IF( ::lKalkPLAN, ' PLÁNOVÁ', ' SKUTEÈNÁ')
RETURN self

********************************************************************************
METHOD VYR_KalkHrCMP_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar

RETURN self

*
********************************************************************************
METHOD VYR_KalkHrCMP_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
**    ::OnSave()
     PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

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

*
********************************************************************************
METHOD VYR_KalkHrCMP_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  cNAMe := UPPER(oVar:name), cField := drgParseSecond(cName, '>')
  LOCAL  lChanged := oVar:changed(), lOK := .T.

  DO CASE
  CASE cField $ Upper('nRokVyp,nObdMes,nPorKalDen')
*     If lValid
      If ( xVar <= 0)
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... údaj musí být kladný !'))
        oVar:recall()
        lOK := .F.
      EndIf
*    Endif
  ENDCASE

RETURN lOK

********************************************************************************
METHOD VYR_KalkHrCMP_CRD:btn_KalkCMP()

  IF( ::lKalkPLAN, ::KalkCMP_PLAN(), ::KalkCMP_SKUT() )
RETURN self

* Výpoèet hromadné kalkulace PLÁNOVÉ
********************************************************************************
METHOD VYR_KalkHrCMP_CRD:KalkCMP_PLAN()

  Local cMsg := drgNLS:msg('MOMENT PROSÍM ...')
  Local nRec := VyrPOL->( RecNO()), nRecCount
  Local arSelect := ::drgDialog:parentDialog:cargo:odBrowse[1]:arSelect
  Local lSelect := (LEN(arSelect) > 0), nPos, lOK
  Local cText := if( lSelect, ' vybraných ', ' všech ' )

  IF drgIsYesNo(drgNLS:msg( 'Spustit výpoèet hromadné kalkulace PLÁNOVÉ' + cText + 'vyrábìných položek ?' ))
    ::dm:save()
    *
    ::nKalkCount := 0
    *
    KALKUL->( AdsSetOrder( IF( KALKULw->cTypKALK = 'NED', 2, 1 )))
    nRecCount := VyrPOL->( LastREC())
    *
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Probíhá hromadný výpoèet kalkulace ...', 'VYRPOL'), nRecCount  )
    *
    VyrPOL->( dbGoTOP())
    DO WHILE !VyrPOL->( EOF())
      *
      IF lSelect
        * Pokud je nìjaká vyr.položka oznaèena, zpracují se pouze oznaèené
        nPos := ascan( arSelect, VyrPol->( RecNo()) )
        lOK := nPos <> 0
      ELSE
        * Pokud není oznaèena žádná vyr.položka, zpracují se všechny
        lOK := .T.
      ENDIF
      *
      IF EMPTY( VyrPOL->cCisZAKAZ) .and. lOK
        *
        cMsg := drgNLS:msg('Probíhá výpoèet kalkulace pro vyrábìnou položku [ & ] ...', VyrPOL->cVyrPol )
        ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
        *
        ::KalkCMP_PL_One()
        *
      ENDIF

      VyrPOL->( dbSKIP())
      drgServiceThread:progressInc()
    ENDDO

    drgServiceThread:progressEnd()
    cMsg := drgNLS:msg('Výpoèet hromadné kalkulace ukonèen - zpracováno  &  kalkulací ...', ::nKalkCount )
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    *
    VyrPOL->( dbGoTO(nREC))
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_KalkHrCMP_CRD:KalkCMP_PL_One( cVypKalk )
  Local cKey, lExist

  DEFAULT cVypKalk TO 'HRO'     // zpùsob výpoètu kalkulace   HROmadná
  *
  ::StavKALK()
  *
  IF KALKULw->cTypKALK = 'NED'
    cKEY := Upper( VyrPOL->cCisZAKAZ) + Upper( VyrPOL->cVyrPol) +;
            StrZERO( VyrPOL->nVarCis, 3) + Upper( 'NED' )
  ELSE
    cKEY := Upper( VyrPOL->cCisZAKAZ) + Upper( VyrPOL->cVyrPOL) + ;
            StrZERO( VyrPOL->nVarCIS, 3) + StrZERO( KALKULw->nRokVyp, 4) + ;
            StrZERO( KALKULw->nObdMes, 2) + DTOS( KALKULw->dDatAktual) + ;
            StrZERO( KALKULw->nPorKalDen, 2 )
  ENDIF
  lEXIST := KALKUL->( dbSEEK( cKEY ))

  IF ( lOK := IF( lEXIST, REPLREC( 'Kalkul'), ADDREC( 'Kalkul') ) )

    ::nKalkCount++
    mh_CopyFLD( 'KALKULw', 'KALKUL' )
    Kalkul->cVyrPOL    := VyrPOL->cVyrPOL
    Kalkul->nVarCIS    := VyrPOL->nVarCIS
    Kalkul->cVypKalk   := cVypKalk
    Kalkul->cTypPol    := VyrPOL->cTypPol
    Kalkul->cZkratMENY := 'CZK'
    Kalkul->nMnozDavky := IF( VyrPOL->nEkDav == 0, 1, VyrPOL->nEkDAV )
    Kalkul->nCenMatMjP := ::PlanMATER()
    Kalkul->nCenMzdVdP := ::PlanMZDY( 2)
    Kalkul->nCenOstatP := Kalkul->nCenMzdVdP * ::nSazbaPOJ
//          Kalkul->nCenSluzbP :=  ??
    Kalkul->nCenEnergP := ::PlanMZDY( 3)
//          Kalkul->nCenMajetP :=  ??
    VYR_SetFixNAKL( Kalkul->nRokVYP, Kalkul->nObdMES, NO )
    Kalkul->nAlgOdbyt  := ::nAlgODBYT
    Kalkul->nRezOdbytP := ::PlanREZIE( 'O', ::nAlgODBYT )
    Kalkul->nAlgVyrob  := ::nAlgVYROB
    Kalkul->nRezVyrobP := ::PlanREZIE( 'V', ::nAlgVYROB )
    Kalkul->nAlgZasob  := ::nAlgZASOB
    Kalkul->nRezZasobP := ::PlanREZIE( 'Z', ::nAlgZASOB )
    Kalkul->nAlgSprav  := ::nAlgSPRAV
    Kalkul->nRezSpravP := ::PlanREZIE( 'S', ::nAlgSPRAV )
    Kalkul->nCenKalkP  := Kalkul->nCenMatMjP + Kalkul->nCenMzdVdP + Kalkul->nCenOstatP +;
                          Kalkul->nCenSluzbP + Kalkul->nCenEnergP + Kalkul->nCenMajetP +;
                          Kalkul->nRezOdbytP + Kalkul->nRezVyrobP + Kalkul->nRezZasobP +;
                          Kalkul->nRezSpravP
    Kalkul->nZiskP     := ( Kalkul->nCenKalkP / 100) * Kalkul->nZiskProcP
    Kalkul->nCenProdP  := Kalkul->nCenKalkP + Kalkul->nZiskP
    IF ::lKalkToCen .AND. UPPER( VyrPOL->cStav) = 'A'
      VYR_KalkToCENIK( VyrPol->cSklPOL)
    ENDIF
    *
    if ::lKalkSetAKT
      Kalkul->nStavKalk := -1    // aktuální kalkulace
    else
      Kalkul->nStavKalk :=  0    // aktuální kalkulace
    endif
    *
    Kalkul->( dbUnlock())
  ENDIF

RETURN self

*
********************************************************************************
METHOD VYR_KalkHrCMP_CRD:destroy()
  ::drgUsrClass:destroy()
  ::nMnKalk    := ;
  ::lKalkToCen := ;
  ::nAlgODBYT  := ;
  ::nAlgVYROB  := ;
  ::nAlgZASOB  := ;
  ::nAlgSPRAV  := ;
  ::nSazbaPOJ  := ;
  ::lDrCenKAL  := ;
  ::nPrMatKal  := ;
  ::lKalkPLAN  := ;
  ::cFile      := ;
  ::nFaktMnoz  := ;
                  Nil
RETURN self

*
** HIDDEN **********************************************************************
METHOD VYR_KalkHrCMP_CRD:PlanMATER()
  Local nKc := 0, nAREA := SELECT(), anCENA, nPOS
  Local cTagTREE, lCZK, nDruhCENY := VAL( KALKULw->cDruhCeny)
  Local cTag := VyrPOL->( OrdSetFocus()), nRec := VyrPOL->( RecNO())

  GenTreeFILE( ROZPAD_NENI,,,, ::fromNabVys )
  ( dbSelectAREA( 'KusTREE'), cTagTREE := AdsSetOrder( 2) )
  KusTree->( mh_SetSCOPE( '1'))

  DO WHILE !EOF()
    IF ( lCZK := VYR_IsCZK( KusTree->cZkratMENY) )
      anCENA := { KusTREE->nCenaCELK , KusTREE->nCenaCELK2,;
                  KusTREE->nCenaCELK3, KusTREE->nCenaCELK4, KusTREE->nCenaCELK5 }
      IF ::lDrCenKAL
         nKc += ( anCENA[ nDruhCENY] * KusTREE->nKoefPREP )
      ELSE
         nPOS := ASCAN( anCENA, {|X| X <> 0 } )
*         nKc += IF( anCENA[ nDruhCENY] = 0, IF( nPOS <> 0, anCENA[ nPOS], 0), anCENA[ nDruhCENY] ) * KusTREE->nKoefPREP
         if nDruhCENY = 5  // nabidkova cena
           nKc += anCENA[ nDruhCENY]
         else
           nKc += IF( anCENA[ nDruhCENY] = 0, IF( nPOS <> 0, anCENA[ nPOS], 0), anCENA[ nDruhCENY] ) * KusTREE->nKoefPREP
         endif
      ENDIF
    ENDIF
    dbSKIP()
  ENDDO
  KusTREE->( mh_ClrScope(), AdsSetOrder( cTagTREE) )
  VyrPOL->( AdsSetOrder( cTag), dbGoTO(nRec) )
  dbSelectAREA( nAREA)
RETURN nKc
*
** HIDDEN **********************************************************************
METHOD VYR_KalkHrCMP_CRD:PlanMZDY( nPARAM)
  Local nAREA := SELECT()
  Local nPriprCas := 0, nKusovCas := 0, nPriprKc := 0, nKusovKc := 0
  Local nSumaCas  := 0, nSumaKalk := 0, nREC := VyrPOL->( RecNO())
  Local nPrMzdaPL := SysConfig( 'Vyroba:nPrMzdaPL')
  Local nHodSazZAM := SysConfig( 'Vyroba:nHodSazZAM')
  *
  GenTreeFile( ROZPAD_NENI,,,, ::fromNabVys) // ,,,, YES)

  ActTreeFile( Kalkul->nMnozDavky, ( nParam = 3), 'STD', ::fromNabVys )  // Vypoèítá potøebné kalkulaèní položky do KusTree
  ( dbSelectArea( 'KusTree'), AdsSetOrder( 2) )
  KusTREE->( mh_SetSCOPE('0'))
*
  SUM KusTree->nPriprCas, KusTree->nKusovCas, KusTree->nPriprKc, KusTree->nKusovKc ;
   TO  nPriprCas, nKusovCas, nPriprKc, nKusovKc
  nSumaCas  := nPriprCas + nKusovCas
  nSumaKalk := nPriprKc  + nKusovKc
  IF nPARAM == 2 .AND. nPrMzdaPL == 2  // z prùm.hod.sazby zamìstnance
     nSumaKalk  := ( nSumaCAS / 60 ) * nHodSazZAM
  ENDIF
  IF( nPARAM == 2, PrMzdyADD(), NIL )
  VyrPOL->( dbGoTO( nREC))
RETURN nSumaKalk

*-------------------------------------------------------------------------------
STATIC FUNC PrMzdyADD()
  Local cCisZakaz, cVyrPol, nVarCis

  KusTREE->( dbGoTOP())
  cCisZakaz := KusTREE->cCisZakaz
  ( cVyrPol := KusTREE->cVyrPol, nVarCis := KusTREE->nVarCis )
  KusTREE->( dbEVAL( {|| PrMzdy->( dbAPPEND(), Sx_RLock() )        ,;
                         mh_CopyFLD( 'KusTREE', 'PrMzdy')          ,;
                         PrMzdy->cCisZakaz  := cCisZakaz           ,;
                         PrMzdy->cVyrPol    := cVyrPol             ,;
                         PrMzdy->nVarCis    := nVarCis             ,;
                         PrMzdy->dDatAktual := KALKULw->dDatAktual ,;
                         PrMzdy->nPorKalDen := KALKULw->nPorKalDen ,;
                         PrMzdy->cVyrPolKal := KusTree->cVyrPol    ,;
                         mh_WRTzmena( 'PrMzdy', YES )              ,;
                         PrMzdy->( dbUnlock())   }))
  PrMzdy->( dbCommit())
RETURN Nil

*
** HIDDEN **********************************************************************
METHOD VYR_KalkHrCMP_CRD:PlanREZIE( cREZ, nALG )
  Local nREZIE := 0, nReziePRC, lOK
  Local nVypREZ  := SysConfig( 'Vyroba:cVypREZIE')
  Local nKalkNED := SysConfig( 'Vyroba:cKalkNED')

  nVypREZ := 1   // Musí být nastaveno 1 kvùli kalkulaèní kartì
  IF nVypREZ == 1 .OR. nVypREZ == 2  //-  1 = z režijních sazeb, 2 = z úèet.pol.
    lOK := ( KALKUL->cTypKALK == 'STD' .OR. KALKUL->cTypKALK == 'DAV') .OR. ;
           ( KALKUL->cTypKALK == 'VYR' .AND. cREZ == 'V' ) .OR. ;
           ( KALKUL->cTypKALK == 'NED' .AND. cREZ == 'V' .AND. nKalkNED == 2 )
    IF lOK
      nREZIE := IIF( nALG == 1, Kalkul->nCenMatMjP,;
                IIF( nALG == 2, Kalkul->nCenMzdVdP,;
                IIF( nALG == 3, Kalkul->nCenMatMjP + Kalkul->nCenMzdVdP,;
                IIF( nALG == 4, Kalkul->nCenMzdVdP + Kalkul->nCenSluzbP,;
                IIF( nALG == 5, Kalkul->nCenMzdVdP + Kalkul->nCenMatMjP + Kalkul->nCenOstatP + Kalkul->nCenSluzbP + Kalkul->nCenEnergP,;
                IIF( nALG == 7, KALKUL->nCenSluzbP, 0 ))))))
      IF KALKUL->nTypREZIE == 1         // Vypoètená 
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReVy,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReVy,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReVy,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReVy, 0 ))))
      ELSEIF KALKUL->nTypREZIE == 2     // Nastavená
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReNa,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReNa,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReNa,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReNa, 0 ))))
      ENDIF
      nREZIE := ( nREZIE / 100 ) * nReziePRC
    ENDIF

  ELSEIF nVypREZ == 3   // ze sazeb pracoviš
    IF cREZ == 'V'      // pouze výrobní režie
       nREZIE := vREZ_HrKAL()
    ENDIF
  ENDIF

RETURN nREZIE

*
** HIDDEN **********************************************************************
METHOD StavKALK()
  Local cKey

  IF ::lKalkSetAKT
    cKey := Upper( (::cFile)->cCisZakaz) + Upper( (::cFile)->cVyrPol) + ;
            StrZero( (::cFile)->nVarCis, 3) + '-1'
    IF KALKUL->( dbSeek( cKEY,, 'KALKUL4'))
      IF KALKUL->( dbRLock())
        KALKUL->nStavKALK := 0
        KALKUL->( dbRUnlock())
      ENDIF
    ENDIF
  ENDIF

RETURN nil

* Výpoèet plánované výrobní režie z PolOPER pro hromadnou kalkulaci
*-------------------------------------------------------------------------------
STATIC FUNCT vREZ_HrKAL()
  Local nKc := 0
  Local cTAG1 := PolOper->( AdsSetOrder( 1)), cTAG2 := C_Pracov->( AdsSetOrder( 1))
  Local cTAG3 := Operace->( AdsSetOrder( 1))
  Local cKEY := Upper( VyrPOL->cCisZAKAZ) + Upper( VyrPOL->cVyrPOL) + ;
                StrZERO( VyrPOL->nVarCIS, 3)

  PolOPER->( mh_SetScope( cKey))
  DO WHILE !PolOPER->( EOF())
    IF Operace->( dbSEEK( Upper( PolOPER->cOznOper)))
       C_Pracov->( dbSEEK( Upper( Operace->cOznPrac)))
       nKc += (( PolOPER->nPriprCAS/VyrPOL->nEkDav + PolOPER->nCelkKusCA) * C_Pracov->nSazbaStro) / 60
    ENDIF
    PolOPER->( dbSKIP())
  ENDDO

  PolOPER->( mh_ClrSCOPE(), AdsSetOrder( cTAG1) )
  C_Pracov->( AdsSetOrder( cTAG2))
  Operace->( AdsSetOrder( cTAG3))
RETURN nKc


* Výpoèet hromadné kalkulace SKUTEÈNÉ
********************************************************************************
METHOD VYR_KalkHrCMP_CRD:KalkCMP_SKUT()

  Local cMsg := drgNLS:msg('MOMENT PROSÍM ...')
  Local nRec := VyrZAK->( RecNO()), nRecCount, nKalkCount := 0
  Local arSelect := ::drgDialog:parentDialog:cargo:odBrowse[1]:arSelect
  Local lSelect := (LEN(arSelect) > 0), nPos, lOK
  Local cText := if( lSelect, ' vybraných ', ' všech ' )
  *
  IF drgIsYesNo(drgNLS:msg( 'Spustit výpoèet hromadné kalkulace SKUTEÈNÉ' + cText + 'zakázek ?' ))
    ::dm:save()
    *
    KALKUL->( AdsSetOrder( IF( KALKULw->cTypKALK = 'NED', 2, 1 )))
    nRecCount := VyrZAK->( LastREC())
    *
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Probíhá hromadný výpoèet kalkulace ...', 'VYRZAK'), nRecCount  )
    *
    VyrZAK->( dbGoTOP())
    DO WHILE !VyrZAK->( EOF())
      *
      IF lSelect
        * Pokud je nìjaká vyr.zakázka oznaèena, zpracují se pouze oznaèené
        nPos := ascan( arSelect, VyrZAK->( RecNo()) )
        lOK := nPos <> 0
      ELSE
        * Pokud není oznaèena žádná vyr.zakázka, zpracují se všechny
        lOK := .T.
      ENDIF
      *
      IF lOK
        *
        cMsg := drgNLS:msg('Probíhá výpoèet kalkulace pro zakázku [ & ] ...', VyrZAK->cCisZAKAZ )
        ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
        * Napozicujeme se na VYRPOL
        cKEY := Upper( VyrZAK->cCisZAKAZ) + Upper( VyrZAK->cVyrPol) + StrZERO( VyrZAK->nVarCis, 3)
        VYRPOL->( dbSEEK( cKey,, 'VYRPOL1'))
        *
        ::StavKALK()
        *
        IF KALKULw->cTypKALK = 'NED'
          cKEY := Upper( VyrZAK->cCisZAKAZ) + Upper( VyrZAK->cVyrPol) +;
                  StrZERO( VyrZAK->nVarCis, 3) + Upper( 'NED' )
        ELSE
          cKEY := Upper( VyrZAK->cCisZAKAZ) + Upper( VyrZAK->cVyrPOL) + ;
                  StrZERO( VyrZAK->nVarCIS, 3) + StrZERO( KALKULw->nRokVyp, 4) + ;
                  StrZERO( KALKULw->nObdMes, 2) + DTOS( KALKULw->dDatAktual) + ;
                  StrZERO( KALKULw->nPorKalDen, 2 )
        ENDIF
        lEXIST := KALKUL->( dbSEEK( cKEY ))

        IF ( lOK := IF( lEXIST, REPLREC( 'Kalkul'), ADDREC( 'Kalkul') ) )
          nKalkCount++
          mh_CopyFLD( 'KALKULw', 'KALKUL' )
          Kalkul->cCisZakaz  := VyrZAK->cCisZakaz
          Kalkul->cVyrPOL    := VyrZAK->cVyrPOL
          Kalkul->nVarCIS    := VyrZAK->nVarCIS
          Kalkul->cVypKalk   := 'HRO'
          Kalkul->cZkratMENY := 'CZK'
          Kalkul->cTypPol    := VyrPOL->cTypPol
          Kalkul->nMnozDavky := IF( VyrPOL->nEkDav == 0, 1, VyrPOL->nEkDAV )
          *
          Kalkul->nCenMatMjP := ::PlanMATER()
          Kalkul->nCenMzdVdP := ::PlanMZDY( 2)
          Kalkul->nCenOstatP := Kalkul->nCenMzdVdP * ::nSazbaPOJ
//          Kalkul->nCenSluzbP :=  ??
          Kalkul->nCenEnergP := ::PlanMZDY( 3)
//          Kalkul->nCenMajetP :=  ??
          VYR_SetFixNAKL( Kalkul->nRokVYP, Kalkul->nObdMES, NO )
          Kalkul->nAlgOdbyt  := ::nAlgODBYT
          Kalkul->nRezOdbytP := ::PlanREZIE( 'O', ::nAlgODBYT )
          Kalkul->nAlgVyrob  := ::nAlgVYROB
          Kalkul->nRezVyrobP := ::PlanREZIE( 'V', ::nAlgVYROB )
          Kalkul->nAlgZasob  := ::nAlgZASOB
          Kalkul->nRezZasobP := ::PlanREZIE( 'Z', ::nAlgZASOB )
          Kalkul->nAlgSprav  := ::nAlgSPRAV
          Kalkul->nRezSpravP := ::PlanREZIE( 'S', ::nAlgSPRAV )
          Kalkul->nCenKalkP  := Kalkul->nCenMatMjP + Kalkul->nCenMzdVdP + Kalkul->nCenOstatP +;
                                Kalkul->nCenSluzbP + Kalkul->nCenEnergP + Kalkul->nCenMajetP +;
                                Kalkul->nRezOdbytP + Kalkul->nRezVyrobP + Kalkul->nRezZasobP +;
                                Kalkul->nRezSpravP
          Kalkul->nZiskP     := ( Kalkul->nCenKalkP / 100) * Kalkul->nZiskProcP
          Kalkul->nCenProdP  := Kalkul->nCenKalkP + Kalkul->nZiskP
          *
*          IF !::lKalkPLAN
          * Skuteèná kalkulace
          Kalkul->nCenMatMjS := ::SkutMATER( 2)
          Kalkul->nCenMzdVdS := ::SkutMZDY( 1)
          Kalkul->nCenOstatS := Kalkul->nCenMzdVdS * ::nSazbaPOJ
          Kalkul->nCenSluzbS := ::SkutMZDY( 2)
          Kalkul->nCenEnergS := ::SkutKOOPER( 3)  // Kooperace 1
          Kalkul->nCenMajetS := ::SkutKOOPER( 4)  // Kooperace 2
          *
          Kalkul->nRezOdbytS := ::SkutREZIE( 'O', ::nAlgODBYT )
          Kalkul->nRezVyrobS := ::SkutREZIE( 'V', ::nAlgVYROB )
          Kalkul->nRezZasobS := ::SkutREZIE( 'Z', ::nAlgZASOB )
          Kalkul->nRezSpravS := ::SkutREZIE( 'S', ::nAlgSPRAV )
          Kalkul->nCenKalkS  := Kalkul->nCenMatMjS + Kalkul->nCenMzdVdS + Kalkul->nCenOstatS +;
                                Kalkul->nCenSluzbS + Kalkul->nCenEnergS + Kalkul->nCenMajetS +;
                                Kalkul->nRezOdbytS + Kalkul->nRezVyrobS + Kalkul->nRezZasobS +;
                                Kalkul->nRezSpravS

          Kalkul->nCenProdS  := ProdCenaSK( ::nFaktMnoz)
          Kalkul->nZiskS     := Kalkul->nCenProdS - Kalkul->nCenKalkS
*          Kalkul->nProcZiskS := VYR_procento_zPC( KALKUL->nCenProdS,{ Kalkul->nZiskS} )
*          ENDIF
          IF ::lKalkToCen .AND. UPPER( VyrPOL->cStav) = 'A'
            VYR_KalkToCENIK( VyrPol->cSklPOL)
          ENDIF
          *
          IF ::lKalkSetAKT
            Kalkul->nStavKalk := -1    // aktuální kalkulace
          ENDIF
          *
          Kalkul->nCisFirmy := VYRZAK->nCisFirmy
          Kalkul->cNazFirmy := VYRZAK->cNazFirmy
          *
          Kalkul->( dbUnlock())
        ENDIF
        *
      ENDIF

      VyrZAK->( dbSKIP())
      drgServiceThread:progressInc()
    ENDDO

    drgServiceThread:progressEnd()
    cMsg := drgNLS:msg('Výpoèet hromadné kalkulace ukonèen - zpracováno  &  kalkulací ...', nKalkCount )
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    *
    VyrZAK->( dbGoTO(nREC))
  ENDIF
RETURN self


* Pøímý materiál v zákl.mìnì - SKUT.
*  nParam : 1 - Pøímý materiál v zahranièní mìnì
*           2 - Pøímý materiál v CZK
** HIDDEN **********************************************************************
METHOD VYR_KalkHrCMP_CRD:SkutMATER( nParam )
  Local cZaklME, cScope
  Local lOK, lCZK
  Local nKcNaOpeSK, nNmNaOpeSK, nTag, n, nCenaCELK, nPrirazka
  *
  IF ::nPrMatKAL = 1       // Ze skladových dokladù - PVPITEM
    *
    nNmNaOpeSK := nKcNaOpeSK := 0
    ( dbSelectAREA( 'PVPItem'), AdsSetOrder( 9) )
    cScope := Upper( VyrZAK->cCisZakaz) + StrZERO( -1, 2)  // + Cs_Upper( 'V ')
    PVPITEM->( mh_SetSCOPE( UPPER( cScope) ))

    DO WHILE !EOF()
      lCZK := VYR_IsCZK( PVPItem->cZkratMENY)
      lOK := IF( nPARAM = 2, IF( lCZK, YES, NO),;
                 !EMPTY( PVPItem->cZkratMENY) .AND. IF( lCZK, NO, YES) )
      IF lOK
*         mh_CopyFld( 'PVPITEM', 'PVPITEMw', .t. )
         nNmNaOpeSK += PVPItem->nMnozPrDOD
         cZaklMe := KALKULw->cZkratMeny
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
    *
  ELSEIF ::nPrMatKAL = 2           // z úèetních dokladù
   nKcNaOpeSk := ::SkutKOOPER(  nPARAM)
  ENDIF

  PVPITEM->( mh_ClrSCOPE(), Ads_ClearAOF(), dbGoTOP() )
RETURN nKcNaOpeSK

*  nParam : 1 - Skuteèné pøímé mzdy
*           2 - Ostatní skuteèné pøímé mzdy
* HIDDEN************************************************************************
METHOD VYR_KalkHrCMP_CRD:SkutMZDY( nParam)
  Local cScope, lOK
  Local nNmNaOpeSK, nKcNaOpeSK, nKcOpePrem, nKcOpePrip, nTag, n, nSumaKalk := 0
  Local nPrMzdy    := SysConfig( 'Vyroba:nPrMzdaKal')
  Local nOsPrMzdy  := SysConfig( 'Vyroba:nOsPrMzKal')
  Local cNazPol1   := SysConfig( 'Vyroba:cNazPol1'), aNazPOL1
  Local cStrMzdy   := SysConfig( 'Vyroba:cStrMzdy'), aStrMzdy
  Local cStrOsMzdy := SysConfig( 'Vyroba:cStrOsMzdy'), aStrOsMzdy
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
  /* nPrMzdy = 1 ... pro všechna støediska
               2 ... jen pro cfg-støedisko
               3 ... výèet støedisek
  */
  nNmNaOpeSK := nKcNaOpeSK := nKcOpePrem := nKcOpePrip := 0
*  MsPrc_M_D->( AdsSetOrder( 1))
  cScope := Upper( ( ::cFILE)->cCisZakaz)
  ListIT->( AdsSetOrder( 8), mh_SetSCOPE( cScope))

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
       lOK := IIF( IsNIL( nPrMZDY) .OR. nPrMZDY == 1, NO,;
              IIF( nPrMZDY == 2, ListIT->cNazPol1 <> VYRZAK->cNazPOL1,;
              IIF( nPrMZDY == 3, VYR_VycetSTR( aStrOsMzdy), NO  ) ))
    ENDIF
    IF lOK .AND. ListIT->nOsCisPrac <> 0
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

  nSumaKalk := nKcNaOpeSK + nKcOpePrem + nKcOpePrip
  *
  ListIT->( mh_ClrSCOPE(), mh_ClrFilter())
RETURN nSumaKALK

* Výpoèet skuteèných kalkulací z UcetPOL
*  nParam : 1 - Pøímý materiál v zahranièní mìnì
*           2 - Pøímý materiál v CZK
*           3 - Kooperace 1
*           4 - Kooperace 2
* HIDDEN************************************************************************
METHOD VYR_KalkHrCMP_CRD:SkutKOOPER( nParam)
  Local nKcMD := 0
  Local acCFG := { 'cUctMatZM' , 'cUctMatCZK', 'cUctKoop1' , 'cUctKoop2'  }
  Local acGET := { 'nCenMatZMS', 'nCenMatMJS', 'nCenEnergS', 'nCenMajetS' }
  Local aUcty, cUctCFG, cScope,  aRECs := {}
  Local cDenikSKL := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  Local acDenikNE  := ListAsArray( ALLTRIM( SysCONFIG( 'Vyroba:cDenikNE')))
  Local lCOND := ( nPARAM > 2)   // Vylouèit deník SKLADY
  Local lDenikOK := YES, lOK

  cScope := LEFT( ( ::cFILE)->cCisZakaz, 8 )
  UcetPOL->( AdsSetOrder( 11) )
  UcetPOL->( mh_SetSCOPE( Upper( cScope)), dbGoTOP())
  *
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
         nKcMD += UcetPOL->nKcMD
      ENDIF
      UcetPOL->( dbSKIP())
    ENDDO
    SET EXACT OFF
    UcetPOL->( dbGoTOP())
  ENDIF
  UcetPOL->( mh_ClrSCOPE())
  *
  UcetPOL->( mh_ClrSCOPE(), mh_ClrFilter())
RETURN nKcMD

*
** HIDDEN **********************************************************************
METHOD VYR_KalkHrCMP_CRD:SkutREZIE( cREZ, nALG )
  Local nREZIE := 0, nReziePRC, lOK, cUctyCFG
  Local nVypREZ  := SysConfig( 'Vyroba:cVypREZIE')
  Local nKalkNED := SysConfig( 'Vyroba:cKalkNED')

  nVypREZ := 1   // Musí být nastaveno 1 kvùli kalkulaèní kartì
  IF nVypREZ == 1  //.OR. nVypREZ == 2  //-  1 = z režijních sazeb, 2 = z úèet.pol.
    lOK := ( KALKUL->cTypKALK == 'STD' .OR. KALKUL->cTypKALK == 'DAV') .OR. ;
           ( KALKUL->cTypKALK == 'VYR' .AND. cREZ == 'V' ) .OR. ;
           ( KALKUL->cTypKALK == 'NED' .AND. cREZ == 'V' .AND. nKalkNED == 2 )
    IF lOK
      nREZIE := IIF( nALG == 1, Kalkul->nCenMatMjS,;
                IIF( nALG == 2, Kalkul->nCenMzdVdS,;
                IIF( nALG == 3, Kalkul->nCenMatMjS + Kalkul->nCenMzdVdS,;
                IIF( nALG == 4, Kalkul->nCenMzdVdS + Kalkul->nCenSluzbS,;
                IIF( nALG == 5, Kalkul->nCenMzdVdS + Kalkul->nCenMatMjS + Kalkul->nCenOstatS + Kalkul->nCenSluzbS + Kalkul->nCenEnergS,;
                IIF( nALG == 6, VYR_vREZ_Skut( nALG ),;
                IIF( nALG == 7, KALKUL->nCenSluzbS, 0 )))))))
      IF KALKUL->nTypREZIE == 1         // Vypoètená 
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReVy,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReVy,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReVy,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReVy, 0 ))))
      ELSEIF KALKUL->nTypREZIE == 2     // Nastavená
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReNa,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReNa,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReNa,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReNa, 0 ))))
      ENDIF
      nREZIE := ( nREZIE / 100 ) * nReziePRC
    ENDIF

  ELSEIF ::nVypREZ = 2     // z úèetních položek
    cUctyCFG := iif( cREZ = 'O', 'cUctOdbREZ',;
                iif( cREZ = 'Z', 'cUctZasREZ',;
                iif( cREZ = 'V', 'cUctVyrREZ',;
                iif( cREZ = 'S', 'cUctSprREZ', '' ))))

    nREZIE := UcetPOL_SKU( cUctyCFG, NO )

  ELSEIF nVypREZ == 3   // ze sazeb pracoviš
    IF cREZ == 'V'      // pouze výrobní režie
       nREZIE := VYR_vREZ_Skut()
    ENDIF
  ENDIF

RETURN nREZIE


********************************************************************************
* Hromadné rušení kalkulací
********************************************************************************
CLASS VYR_KalkHrDEL_CRD FROM drgUsrClass
EXPORTED:
  VAR     dDatumOd, dDatumDo, nDEL

  METHOD  Init, drgDialogStart // , EventHandled
  METHOD  btn_KalkDEL

HIDDEN:
  VAR     dm, msg

ENDCLASS

*****************************************************************
METHOD VYR_KalkHrDEL_CRD:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::dDatumOd := ::dDatumDo := DATE()
  ::nDEL := 0
RETURN self

********************************************************************************
METHOD VYR_KalkHrDEL_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
RETURN self

********************************************************************************
METHOD VYR_KalkHrDEL_CRD:btn_KalkDEL()
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  IF drgIsYesNo(drgNLS:msg( 'Provést hromadné zrušení kalkulací ?' ))
    ::dm:save()
    drgDBMS:open('KALKUL' )
    KALKUL->( AdsSetOrder(1), dbGoTOP() )
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('Probíhá hromadné rušení kalkulací ...', 'KALKUL'), KALKUL->(LASTREC()) )
    *
    IF KALKUL->( FLOCK())
      DO WHILE !KALKUL->( EOF())
         IF KALKUL->dDatAktual >= ::dDatumOD .AND. KALKUL->dDatAktual <= ::dDatumDO
            KALKUL->( dbDelete())
            ::nDEL++
         ENDIF
         KALKUL->( dbSKIP())
         drgServiceThread:progressInc()
      ENDDO
      KALKUL->( dbUnlock())
      drgServiceThread:progressEnd()
      cMsg := drgNLS:msg('Poèet zrušených kalkulací = ' + ALLTRIM( STR( ::nDEL)))
      ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    ELSE
      drgMsgBox(drgNLS:msg('NELZE - soubor kalkulací je blokován jiným uživatelem ...'))
    ENDIF
  ENDIF
  *
  ::dm:refresh()
RETURN self

********************************************************************************
* Hromadné nastavení aktuální kalkulace
********************************************************************************
CLASS VYR_KalkHrAKT_CRD FROM drgUsrClass
EXPORTED:
  VAR     dDatumKALK, nPoradiKALK

  METHOD  Init, drgDialogStart
  METHOD  btn_KalkAKT

HIDDEN:
  VAR     dm, msg

ENDCLASS

*****************************************************************
METHOD VYR_KalkHrAKT_CRD:init(parent)
  ::drgUsrClass:init(parent)
  *
  ::dDatumKALK  := DATE()
  ::nPoradiKALK := 1
RETURN self

********************************************************************************
METHOD VYR_KalkHrAKT_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
RETURN self

********************************************************************************
METHOD VYR_KalkHrAKT_CRD:btn_KalkAKT()
  Local cScope, nReCount
  Local cMsg := drgNLS:msg('MOMENT PROSÍM - generuji váš požadavek ...')

  IF drgIsYesNo(drgNLS:msg( 'Provést hromadné nastavení aktuální kalkulace ?' ))
    ::dm:save()
    drgDBMS:open('KALKUL' )
    KALKUL->( AdsSetOrder(1), dbGoTOP() )
    *
    IF KALKUL->( FLOCK())
      ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
      nRecCount := dbCOUNT( 'VyrPOL')
      drgServiceThread:progressStart(drgNLS:msg('Hromadné nastavení aktuálních kalkulací ...', 'VYRPOL'), nRecCount )
      *
      vyrpol->( dbGoTOP())
      do while !vyrpol->( EOF())
        cScope := Upper( vyrpol->cCisZakaz) + Upper( vyrpol->cVyrPol) + StrZero( vyrpol->nVarCis, 3)
        kalkul ->( mh_SetScope( cScope))
        do while !kalkul->( eof())
          do case
          case Empty( ::dDatumKALK)
            kalkul->nstavkalk := if( kalkul->nporkalden = ::nporadikalk, -1, 0 )
          case kalkul->ddataktual = ::ddatumkalk
            kalkul->nstavkalk := if( kalkul->nporkalden = ::nporadikalk, -1, 0 )
          otherwise
            kalkul->nstavkalk := 0
          endcase

/*
          IF EMPTY (::dDatumKALK)
            KALKUL->nStavKALK := IF( KALKUL->nPorKalDen = ::nPoradiKALK, -1, 0 )

          ELSEIF KALKUL->dDatAktual = ::dDatumKALK
            KALKUL->nStavKALK := IF( KALKUL->nPorKalDen = ::nPoradiKALK, -1, 0 )
          else
            KALKUL->nStavKALK := 0
          ENDIF
*/

          *
          kalkul->( dbSkip())
          drgServiceThread:progressInc()
        enddo

        kalkul->( mh_ClrScope())
        vyrpol->( dbSkip())
        drgServiceThread:progressInc()
      enddo

      kalkul->( dbUnlock())
      drgServiceThread:progressEnd()
      cMsg := drgNLS:msg('Nastavení aktuálních kalkulací ukonèeno !')
      ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)

    ELSE
      drgMsgBox(drgNLS:msg('NELZE - soubor kalkulací je blokován jiným uživatelem ...'))
    ENDIF
  ENDIF

RETURN self