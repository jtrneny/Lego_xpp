
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "..\VYROBA\VYR_Vyroba.ch"
********************************************************************************
*
static nsecBeg

static function kalkHRcmp_ex_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)
  local  ops, nxD, nyD
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  ofont    := XbpFont():new():create( "9.Arial CE" )

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  if newPos < (nSize/2) -20
    GraGradient( ops                , ;
                 { newPos+1,2 }, ;
                 { { nsize -newPos, nhight }}, ;
                 {0,15,0}, GRA_GRADIENT_HORIZONTAL)
  endif

  GraSetFont( oPs, oFont )
  GraStringAt( oPS, {(nSize/2) -20,4}, prc)

  oXbp:unlockPS(oPS)
return .t.
*
*
********************************************************************************
CLASS VYR_kalkHRcmp_ex_CRD FROM drgUsrClass
EXPORTED:
  VAR     nMnKalk, lKalkToCen, lKalkSetAKT
  VAR     nAlgODBYT, nAlgVYROB, nAlgZASOB, nAlgSPRAV, nSazbaPOJ, lDrCenKAL,;
          nPrMatKal, nFaktMnoz,;
          lKalkPLAN, cFile, nKalkCount,;
          fromNabVys
  var     nrecCount, nrecNo, ctypKalk

  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, EventHandled
  METHOD  PostValidate
  METHOD  btn_KalkCMP, KalkCMP_PL_One(), KalkCMP_SKUT  //, KalkCMP_SK_One
  method  kalkCMP_plan_ex

HIDDEN:
  VAR     dm, msg
  var     nCenMatMJp
  var     nCenMzdVdP, nCenEnergP

  METHOD  PlanMATER, PlanMZDY, PlanREZIE
  METHOD  SkutMATER, SkutMZDY, SkutKOOPER, SkutREZIE
  METHOD  StavKALK


  inline method preparation_for_Plan()
    local  cFilter_m    := format("ccisZakaz = '%%' and nvarOper = %% and (", {kusTree->ccisZakaz, kustree->nvarCis} )
    local  cvyrPol_AOF  := '', cpolOper_AOF
    local  nDruhCENY    := VAL(KALKULw->cDruhCeny), anCena
    *
    local  nPrMzdaPL  := SysConfig( 'Vyroba:nPrMzdaPL')
    local  nHodSazZAM := SysConfig( 'Vyroba:nHodSazZAM')
    *
    local  npos, nin
    local  nPCas, nPKc, nKCas, nKKc, nVyrRez
    local  nsumaCas, nSumaKalk
    *
    local  nmnDavka := KALKULw->nMnozDavky
    //  1- nPriprCas += nPCas
    //  2- nPriprKc  += nPKc
    //  3- nKusovCas += nKCas
    //  4- nKusovKc  += nKKc
    //  5- nVyrRezie += nVyrRez
    local  paSuma     := { { 0, 0, 0, 0, 0 }, { 0, 0, 0, 0, 0 } }  // 1 - VP 2 - KOO
    local  paspMNOnas := {}, nspMNOnas

    ::nCenMatMJp := ::nCenMzdVdP := ::nCenEnergP := 0

    do while .not. kusTree->( eof())
      *
      * p¯Ìprava AOF pro polOper
      if kusTree->cvyrPol <> ''
        cvyrPol_Aof += "cvyrPol =" +"'" +kusTree->cvyrPol +"' or "
        aadd( paspMNOnas, { kusTree->cvyrPol, KusTree->nSpMnoNas })
      endif
      *
      ** plan material sumace
      if kusTree->lnakPol .and. upper(kusTree->czkratMeny) $ 'CZK,K»,KC'
        anCENA := { kusTree->nCenaCELK, kusTree->nCenaCELK2, kusTree->nCenaCELK3, kustree->nCenaCELK4, kusTree->nCenaCELK5 }

        if ::lDRcenKAL .or. ndruhCeny = 5  // Dodrûet druh ceny v kalkulaci ... NabÌdkov· cena
          ::nCenMatMJp += anCENA[nDruhCENY] * if( ::lDRcenKAL, KusTREE->nKoefPREP, 1 )
        else
          npos          := ascan( anCena, {|x| x <> 0} )
          ::nCenMatMJp  += IF( anCENA[nDruhCENY] = 0, if( nPOS <> 0, anCENA[nPOS], 0), anCENA[nDruhCENY] ) *KusTREE->nKoefPREP
        endif
      endif

      kusTree->( dbskip())
    enddo

    cpolOper_AOf := cFilter_m +substr(cvyrPol_Aof, 1, len(cvyrPol_Aof)-4 ) +")"
    polOper->( Ads_setAof(cpolOper_AOf), dbgoTop())

    do while .not. polOper->( Eof())
      nPCas := nPKc := nKCas := nKKc := nVyrRez := 0

      nin        := ascan( paspMNOnas, { |x| x[1] = polOper->cvyrPol })
      nspMNOnas  := if( nin <> 0, paspMNOnas[nin,2], 1 )

      Operace->( dbSeek( Upper( PolOper->cOznOper)))
      nPos := if( UPPER( Operace->cTypOper) == 'KOO', 2, 1 )

      C_Pracov->( dbSEEK( Upper( Operace->cOznPrac)))
      nPCas := PolOper->nPriprCas / nMnDavka

      c_Tarif->( dbSeek( Upper( Operace->cTarifStup + Operace->cTarifTrid)))
      nPKc  := nPCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )

      If PolOper->nCelkKusCa > 0
        nKCas := PolOper->nCelkKusCa * nSpMnoNas
      Else
        nKCas := Operace->nKusovCas * PolOper->nKoefKusCa * nSpMnoNas * ;
                 Operace->nKoefSmCas * Operace->nKoefViOb / Operace->nKoefViSt
      Endif

      nVyrRez := (( nKCas + nPCas) / 60 ) * C_Pracov->nSazbaStro

      If UPPER( Operace->cTypOper) == 'KOO' .or. ::fromNabVys
        nKKc := PolOper->nKcNaOper * KusTree->nSpMnoNas
      Else
        nKKc := nKCas * (( c_Tarif->nHodinSaz + c_Tarif->nHodinNav) / 60 )
      EndIf
      //
      paSuma[npos,1] += nPCas   // nPriprCas
      paSuma[npos,2] += nPKc    // nPriprKc
      paSuma[npos,3] += nKCas   // nKusovCas
      paSuma[npos,4] += nKKc    // nKusovKc
      paSuma[npos,5] += nVyrRez // nVyrRezie

      PolOper->( dbSkip())
    EndDo

    for npos := 1 to len(paSuma) step 1
      nsumaCas  := paSuma[npos,1] +paSuma[npos,3]
      nSumaKalk := paSuma[npos,2] +paSuma[npos,4]

      if npos = 1 .and. nPrMzdaPL = 2  // z pr˘m.hod.sazby zamÏstnance
        nSumaKalk  := ( nSumaCAS / 60 ) * nHodSazZAM
      endif

      if( npos = 1, ::ncenMZDvdP := nsumaKalk, ::ncenENERGp := nSumaKalk )
    next
  return self

ENDCLASS

********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:init(parent)

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
  drgDBMS:open('polOper' )
  drgDBMS:open('operace' )
  drgDBMS:open('c_pracov')
  drgDBMS:open('c_tarif' )

  IF !::lKalkPLAN
    * p¯i v˝poËtu skut.kalkulacÌ je t¯eba otev¯Ìt dalöÌ soubory
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
  ::nrecCount := 0
  ::nrecNo    := 0
  ::ctypKalk  :=  'kalkulace ' +if( ::lkalkPlan, 'PL¡NOV¡', 'SKUTE»N¡' )
RETURN self

********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += IF( ::lKalkPLAN, ' PL¡NOV¡', ' SKUTE»N¡')
RETURN self

********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:drgDialogStart(drgDialog)
*  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  ::msg := drgDialog:oMessageBar
RETURN self

*
********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
  CASE  nEvent = drgEVENT_SAVE
**    ::OnSave()
     PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)

  * UkonËit bez uloûenÌ
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * UkonËit bez uloûenÌ
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
METHOD VYR_kalkHRcmp_ex_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  cNAMe := UPPER(oVar:name), cField := drgParseSecond(cName, '>')
  LOCAL  lChanged := oVar:changed(), lOK := .T.

  DO CASE
  CASE cField $ Upper('nRokVyp,nObdMes,nPorKalDen')
*     If lValid
      If ( xVar <= 0)
        drgMsgBox(drgNLS:msg( oVar:ref:caption + ': ... ˙daj musÌ b˝t kladn˝ !'))
        oVar:recall()
        lOK := .F.
      EndIf
*    Endif
  ENDCASE

RETURN lOK

********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:btn_KalkCMP()

//  IF( ::lKalkPLAN, ::KalkCMP_PLAN(), ::KalkCMP_SKUT() )
  if( ::lKalkPLAN, ::kalkCMP_plan_ex(), ::KalkCMP_SKUT() )
RETURN self


* V˝poËet hromadnÈ kalkulace PL¡NOV…
********************************************************************************
method VYR_kalkHRcmp_ex_CRD:kalkCMP_plan_ex()
  local  x, nPHASE := MIS_PHASE1, abitMaps

  local  arSelect  := ::drgDialog:parentDialog:cargo:odBrowse[1]:arSelect
  local  ctext     := if( len(arSelect) > 0, ' vybran˝ch ', ' vöech ' ), cMsg
  *
  local  recNo     := vyrPol->(recNo()), caof_vyrPol := vyrPol->( ads_getAof())
  local  oXbp      := ::msg:msgStatus, nSize, nHight, nrecCnt, nkeyCnt, nkeyno

  local  picStatus := ::msg:picStatus

  *
  ** nachyst·me si ËervÌka v pro samostatnÈ vl·kno
  abitMaps            := { 0, 0, {nil,nil,nil} }

  for x := 1 to 3 step 1
    abitMaps[3,x] := XbpBitmap():new():create()
    abitMaps[3,x]:load( ,nPHASe )
    nPHASe++
  next

  nSize  := oxbp:currentSize()[1]
  nHight := oxbp:currentSize()[2] -2
  nkeyNo := 1
  *
  ** p¯ekofigurujene picStatus pro koleËko BMP
  picStatus:type := XBPSTATIC_TYPE_BITMAP
  picStatus:configure()

  if drgIsYesNo(drgNLS:msg( 'Spustit v˝poËet hromadnÈ kalkulace PL¡NOV…' +cText +'vyr·bÏn˝ch poloûek ?' ))
    ::dm:save()
    ::nKalkCount := 0

    vyrPol->( dbgoTop())
    kalkul->( AdsSetOrder( IF( KALKULw->cTypKALK = 'NED', 2, 1 )))

    if len(arSelect) <> 0
      vyrPol->( ads_setAof('.F.'))
      vyrPol->( ads_customizeAOF(arselect), dbgotop())
    endif

    nrecCnt := vyrPol->( ads_getKeyCount(1))  // ADS_RESPECTFILTERS
    nkeyCnt := nrecCnt
    ::dm:set('M->nrecCount', nrecCnt)
    ::dm:set('M->nrecNo'   , nkeyNo )

    do while .not. vyrPol->(eof())
      if empty(vyrPol->ccisZakaz)
        ::KalkCMP_PL_One()
      endif

      VyrPol->( dbSkip())
      nkeyNo++
      ::dm:set('M->nrecNo'   , nkeyNo )

      * teplomÏr
      kalkHRcmp_ex_pb(oxbp, nkeyCnt, nkeyNo, nsize, nhight)

      * koleËko
      abitMaps[1] ++
      if abitMaps[1] > len(aBitMaps[3])
        abitMaps[1] := 1
      endif

      picStatus:setCaption( abitMaps[ 3, abitMaps[1]] )
      picStatus:show()
    enddo

    cMsg := drgNLS:msg('V˝poËet hromadnÈ kalkulace ukonËen - zpracov·no  &  kalkulacÌ ...', ::nKalkCount )
    oXbp:setCaption( cMsg )

    picStatus:type    := XBPSTATIC_TYPE_ICON
    picStatus:configure()

    vyrPol->( ads_clearAof())
    if( .not. empty(caof_vyrPol), vyrPol->( ads_setAof(caof_vyrPol)), nil )
    vyrPol->( dbGoTo(recNo))
  endif
return self


********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:KalkCMP_PL_One( cVypKalk )
  Local cKey, lExist

  DEFAULT cVypKalk TO 'HRO'     // zp˘sob v˝poËtu kalkulace   HROmadn·
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
    GenTreeFILE( ROZPAD_NENI,,,, ::fromNabVys )
    ::preparation_for_Plan()

    Kalkul->cVyrPOL    := VyrPOL->cVyrPOL
    Kalkul->nVarCIS    := VyrPOL->nVarCIS
    Kalkul->cVypKalk   := cVypKalk
    Kalkul->cTypPol    := VyrPOL->cTypPol
    Kalkul->cZkratMENY := 'CZK'
    Kalkul->nMnozDavky := IF( VyrPOL->nEkDav == 0, 1, VyrPOL->nEkDAV )
    Kalkul->nCenMatMjP := ::nCenMatMJp
    Kalkul->nCenMzdVdP := ::nCenMzdVdP
    Kalkul->nCenOstatP := Kalkul->nCenMzdVdP * ::nSazbaPOJ
    Kalkul->nCenEnergP := ::nCenEnergP

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
      Kalkul->nStavKalk := -1    // aktu·lnÌ kalkulace
    else
      Kalkul->nStavKalk :=  0    // aktu·lnÌ kalkulace
    endif
    *
    Kalkul->( dbUnlock())
  ENDIF

RETURN self

*
********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:destroy()
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
METHOD VYR_kalkHRcmp_ex_CRD:PlanMATER()
  Local nKc := 0, nAREA := SELECT(), anCENA, nPOS
  Local cTagTREE, lCZK, nDruhCENY := VAL( KALKULw->cDruhCeny)
  Local cTag := VyrPOL->( OrdSetFocus()), nRec := VyrPOL->( RecNO())

///  GenTreeFILE( ROZPAD_NENI,,,, ::fromNabVys )
  ( dbSelectAREA( 'KusTREE'), cTagTREE := AdsSetOrder( 2) )
  KusTree->( mh_SetSCOPE( '1'))

  DO WHILE .not. kusTree->(eof())
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
METHOD VYR_kalkHRcmp_ex_CRD:PlanMZDY( nPARAM)
  Local nAREA := SELECT()
  Local nPriprCas := 0, nKusovCas := 0, nPriprKc := 0, nKusovKc := 0
  Local nSumaCas  := 0, nSumaKalk := 0, nREC := VyrPOL->( RecNO())
  Local nPrMzdaPL := SysConfig( 'Vyroba:nPrMzdaPL')
  Local nHodSazZAM := SysConfig( 'Vyroba:nHodSazZAM')
  *
///  GenTreeFile( ROZPAD_NENI,,,, ::fromNabVys) // ,,,, YES)

  ActTreeFile( KALKULw->nMnozDavky, ( nParam = 3), 'STD', ::fromNabVys )  // VypoËÌt· pot¯ebnÈ kalkulaËnÌ poloûky do KusTree
  ( dbSelectArea( 'KusTree'), AdsSetOrder( 2) )
  KusTREE->( mh_SetSCOPE('0'))
*
  SUM KusTree->nPriprCas, KusTree->nKusovCas, KusTree->nPriprKc, KusTree->nKusovKc ;
   TO  nPriprCas, nKusovCas, nPriprKc, nKusovKc
  nSumaCas  := nPriprCas + nKusovCas
  nSumaKalk := nPriprKc  + nKusovKc
  IF nPARAM == 2 .AND. nPrMzdaPL == 2  // z pr˘m.hod.sazby zamÏstnance
     nSumaKalk  := ( nSumaCAS / 60 ) * nHodSazZAM
  ENDIF

///  IF( nPARAM == 2, PrMzdyADD(), NIL )
  VyrPOL->( dbGoTO( nREC))
RETURN nSumaKalk

*
** HIDDEN **********************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:PlanREZIE( cREZ, nALG )
  Local nREZIE := 0, nReziePRC, lOK
  Local nVypREZ  := SysConfig( 'Vyroba:cVypREZIE')
  Local nKalkNED := SysConfig( 'Vyroba:cKalkNED')

  nVypREZ := 1   // MusÌ b˝t nastaveno 1 kv˘li kalkulaËnÌ kartÏ
  IF nVypREZ == 1 .OR. nVypREZ == 2  //-  1 = z reûijnÌch sazeb, 2 = z ˙Ëet.pol.
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
      IF KALKUL->nTypREZIE == 1         // VypoËten·†
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReVy,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReVy,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReVy,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReVy, 0 ))))
      ELSEIF KALKUL->nTypREZIE == 2     // Nastaven·
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReNa,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReNa,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReNa,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReNa, 0 ))))
      ENDIF
      nREZIE := ( nREZIE / 100 ) * nReziePRC
    ENDIF

  ELSEIF nVypREZ == 3   // ze sazeb pracoviöù
    IF cREZ == 'V'      // pouze v˝robnÌ reûie
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

* V˝poËet pl·novanÈ v˝robnÌ reûie z PolOPER pro hromadnou kalkulaci
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


* V˝poËet hromadnÈ kalkulace SKUTE»N…
********************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:KalkCMP_SKUT()

  Local cMsg := drgNLS:msg('MOMENT PROSÕM ...')
  Local nRec := VyrZAK->( RecNO()), nRecCount, nKalkCount := 0
  Local arSelect := ::drgDialog:parentDialog:cargo:odBrowse[1]:arSelect
  Local lSelect := (LEN(arSelect) > 0), nPos, lOK
  Local cText := if( lSelect, ' vybran˝ch ', ' vöech ' )
  *
  IF drgIsYesNo(drgNLS:msg( 'Spustit v˝poËet hromadnÈ kalkulace SKUTE»N…' + cText + 'zak·zek ?' ))
    ::dm:save()
    *
    KALKUL->( AdsSetOrder( IF( KALKULw->cTypKALK = 'NED', 2, 1 )))
    nRecCount := VyrZAK->( LastREC())
    *
    ::msg:writeMessage( cMsg ,DRG_MSG_WARNING)
    drgServiceThread:progressStart(drgNLS:msg('ProbÌh· hromadn˝ v˝poËet kalkulace ...', 'VYRZAK'), nRecCount  )
    *
    VyrZAK->( dbGoTOP())
    DO WHILE !VyrZAK->( EOF())
      *
      IF lSelect
        * Pokud je nÏjak· vyr.zak·zka oznaËena, zpracujÌ se pouze oznaËenÈ
        nPos := ascan( arSelect, VyrZAK->( RecNo()) )
        lOK := nPos <> 0
      ELSE
        * Pokud nenÌ oznaËena û·dn· vyr.zak·zka, zpracujÌ se vöechny
        lOK := .T.
      ENDIF
      *
      IF lOK
        *
        cMsg := drgNLS:msg('ProbÌh· v˝poËet kalkulace pro zak·zku [ & ] ...', VyrZAK->cCisZAKAZ )
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
          * SkuteËn· kalkulace
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
            Kalkul->nStavKalk := -1    // aktu·lnÌ kalkulace
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
    cMsg := drgNLS:msg('V˝poËet hromadnÈ kalkulace ukonËen - zpracov·no  &  kalkulacÌ ...', nKalkCount )
    ::msg:WriteMessage( cMsg, DRG_MSG_WARNING)
    *
    VyrZAK->( dbGoTO(nREC))
  ENDIF
RETURN self


* P¯Ìm˝ materi·l v z·kl.mÏnÏ - SKUT.
*  nParam : 1 - P¯Ìm˝ materi·l v zahraniËnÌ mÏnÏ
*           2 - P¯Ìm˝ materi·l v CZK
** HIDDEN **********************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:SkutMATER( nParam )
  Local cZaklME, cScope
  Local lOK, lCZK
  Local nKcNaOpeSK, nNmNaOpeSK, nTag, n, nCenaCELK, nPrirazka
  *
  IF ::nPrMatKAL = 1       // Ze skladov˝ch doklad˘ - PVPITEM
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
  ELSEIF ::nPrMatKAL = 2           // z ˙ËetnÌch doklad˘
   nKcNaOpeSk := ::SkutKOOPER(  nPARAM)
  ENDIF

  PVPITEM->( mh_ClrSCOPE(), Ads_ClearAOF(), dbGoTOP() )
RETURN nKcNaOpeSK

*  nParam : 1 - SkuteËnÈ p¯ÌmÈ mzdy
*           2 - OstatnÌ skuteËnÈ p¯ÌmÈ mzdy
* HIDDEN************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:SkutMZDY( nParam)
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
  * V˝Ëet st¯edisek pro v˝poËet p¯Ìm˝ch mezd
  IF !IsNIL( cStrMzdy )
    aStrMzdy := ListAsARRAY( ALLTRIM( cStrMzdy) )
  ENDIF
  * V˝Ëet st¯edisek pro v˝poËet ostatnÌch p¯Ìm˝ch mezd
  IF !IsNIL( cStrOsMzdy )
    aStrOsMzdy := ListAsARRAY( ALLTRIM( cStrOsMzdy) )
  ENDIF
  /* nPrMzdy = 1 ... pro vöechna st¯ediska
               2 ... jen pro cfg-st¯edisko
               3 ... v˝Ëet st¯edisek
  */
  nNmNaOpeSK := nKcNaOpeSK := nKcOpePrem := nKcOpePrip := 0
*  MsPrc_M_D->( AdsSetOrder( 1))
  cScope := Upper( ( ::cFILE)->cCisZakaz)
  ListIT->( AdsSetOrder( 8), mh_SetSCOPE( cScope))

  DO WHILE !ListIT->( EOF())
    IF UPPER( ::cFILE) = 'VYRPOL'
      VYRZAK->( dbSEEK( Upper( VYRPOL->cCisZAKAZ),, 'VYRZAK1'))
    ENDIF
    IF nParam = 1  // p¯ÌmÈ mzdy
       lOK := IIF( IsNIL( cNazPol1), YES,;
              IIF( nPrMzdy == 1,     YES,;
              IIF( nPrMzdy == 2, ListIT->cNazPol1 == VyrZAK->cNazPOL1,;
              IIF( nPrMzdy == 3, VYR_VycetSTR( aStrMzdy), NO  ) )))
    ELSEIF nParam = 2  //  ostatnÌ p¯ÌmÈ mzdy
       lOK := IIF( IsNIL( nPrMZDY) .OR. nPrMZDY == 1, NO,;
              IIF( nPrMZDY == 2, ListIT->cNazPol1 <> VYRZAK->cNazPOL1,;
              IIF( nPrMZDY == 3, VYR_VycetSTR( aStrOsMzdy), NO  ) ))
    ENDIF
    IF lOK .AND. ListIT->nOsCisPrac <> 0
      nNmNaOpeSK += ListIT->nNmNaOpeSK
      nKcOpePrem += ListIt->nKcOpePrem
      nKcOpePrip += ListIT->nKcOpePrip
      IF nParam == 2 .AND. nOsPrMzdy = 2     // dle sazeb pracovnÌk˘
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

* V˝poËet skuteËn˝ch kalkulacÌ z UcetPOL
*  nParam : 1 - P¯Ìm˝ materi·l v zahraniËnÌ mÏnÏ
*           2 - P¯Ìm˝ materi·l v CZK
*           3 - Kooperace 1
*           4 - Kooperace 2
* HIDDEN************************************************************************
METHOD VYR_kalkHRcmp_ex_CRD:SkutKOOPER( nParam)
  Local nKcMD := 0
  Local acCFG := { 'cUctMatZM' , 'cUctMatCZK', 'cUctKoop1' , 'cUctKoop2'  }
  Local acGET := { 'nCenMatZMS', 'nCenMatMJS', 'nCenEnergS', 'nCenMajetS' }
  Local aUcty, cUctCFG, cScope,  aRECs := {}
  Local cDenikSKL := UPPER( ALLTRIM( SysCONFIG( 'Sklady:cDenik')))
  Local acDenikNE  := ListAsArray( ALLTRIM( SysCONFIG( 'Vyroba:cDenikNE')))
  Local lCOND := ( nPARAM > 2)   // VylouËit denÌk SKLADY
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
METHOD VYR_kalkHRcmp_ex_CRD:SkutREZIE( cREZ, nALG )
  Local nREZIE := 0, nReziePRC, lOK, cUctyCFG
  Local nVypREZ  := SysConfig( 'Vyroba:cVypREZIE')
  Local nKalkNED := SysConfig( 'Vyroba:cKalkNED')

  nVypREZ := 1   // MusÌ b˝t nastaveno 1 kv˘li kalkulaËnÌ kartÏ
  IF nVypREZ == 1  //.OR. nVypREZ == 2  //-  1 = z reûijnÌch sazeb, 2 = z ˙Ëet.pol.
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
      IF KALKUL->nTypREZIE == 1         // VypoËten·†
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReVy,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReVy,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReVy,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReVy, 0 ))))
      ELSEIF KALKUL->nTypREZIE == 2     // Nastaven·
         nReziePRC := IIF( cREZ == 'O', FixNAKL->nOdbytReNa,;
                      IIF( cREZ == 'Z', FixNAKL->nZasobReNa,;
                      IIF( cREZ == 'V', FixNAKL->nVyrobReNa,;
                      IIF( cREZ == 'S', FixNAKL->nSpravReNa, 0 ))))
      ENDIF
      nREZIE := ( nREZIE / 100 ) * nReziePRC
    ENDIF

  ELSEIF ::nVypREZ = 2     // z ˙ËetnÌch poloûek
    cUctyCFG := iif( cREZ = 'O', 'cUctOdbREZ',;
                iif( cREZ = 'Z', 'cUctZasREZ',;
                iif( cREZ = 'V', 'cUctVyrREZ',;
                iif( cREZ = 'S', 'cUctSprREZ', '' ))))

    nREZIE := UcetPOL_SKU( cUctyCFG, NO )

  ELSEIF nVypREZ == 3   // ze sazeb pracoviöù
    IF cREZ == 'V'      // pouze v˝robnÌ reûie
       nREZIE := VYR_vREZ_Skut()
    ENDIF
  ENDIF

RETURN nREZIE