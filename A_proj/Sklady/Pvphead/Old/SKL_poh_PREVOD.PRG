/*==============================================================================
  SKL_PREVOD.PRG
  ------------------------------------------------------------------------------
  XPP              ->  DOS          in   DOS.Prg
==============================================================================*/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

*
*===============================================================================NEW
FUNCTION SKL_PrevodOK_( dm)
  Local nCenasZBO := CenZboz->nCenasZBO, nUcetSkup := CenZboz->nUcetSkup
  Local cOldSklPol := CenZboz->cSklPol
  Local cNewSklad  := dm:get('PVPITEMww->cSkladKAM')
  Local cNewSklPol := dm:get('PVPITEMww->cSklPolKAM'), cKey, lOK := .T.
  Local lUctSkPrev := SysConfig('Sklady:lUctSkPrev')

  drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
  cKey := Upper( cNewSklad) + Upper( cNewSklPol)
  IF CenZBOZa->( dbSeek( cKey,, 'CENIK03'))
    IF ( cOldSklPol == cNewSklPol ) .and. ( Upper( CenZboz->cTypSklCen) == 'PEV')
      lOK := ( nCenasZBO = CenZBOZa->nCenasZBO )
      IF !lOK
        drgMsgBox(drgNLS:msg('Pøevod nelze uskuteènit, nebo pøevádíte položku s PEVNOU cenou;'+ ;
                              'na stejnojmennou položku s jinou cenou !'), XBPMB_WARNING )
        RETURN .F.
      ENDIF
    ENDIF
    *
    IF lUctSkPrev
      dm:set('PVPITEMww->nUcetSkKAM', CenZBOZa->nUcetSkup)
    ELSEIF !(lOK := (nUcetSkup = CenZBOZa->nUcetSkup) )
      drgMsgBox(drgNLS:msg('Pøevod nelze uskuteènit na položku s jinou úèetní skupinou !'), XBPMB_WARNING )
    ENDIF
  ENDIF
  CenZBOZa->( dbCloseArea())
RETURN lOK

* Validace na množství pøevodu
*===============================================================================
FUNCTION SKL_MnPrevodu_( oVar)
  Local nVAL := oVar:value
  Local UDCP := oVar:drgDialog:UDCP
  Local dc := oVar:drgDialog:dialogCtrl
  Local isAppend := dc:isAppend, lOK := .T.

  IF nVal <= 0
    IF Upper( CenZboz->cTypSklCen) == 'PRU'
      drgMsgBox(drgNLS:msg('Pøevádìné množství musí být kladné !'), XBPMB_WARNING )
      lOK := .f.
    ENDIF
  ELSE
    nMnozsZBO := CenZboz->nMnozsZBO + IF( !isAppend, PVPItem->nMnozPrDOD, 0)
    lOK := If( Upper( CenZboz->cTypSklCen) == 'PRU',( nVal <= nMnozsZBO ), TRUE )
    IF !lOK
      drgMsgBox(drgNLS:msg('Množství skladové je pouze [ & ] !', nMnozSZBO), XBPMB_WARNING )
    ENDIF
  ENDIF
RETURN lOK

*
*===============================================================================
FUNCTION SKL_Prevod_SAVE_( Dlg, nKEY)
  Local lOK, Filter
  Local dm := Dlg:dataManager
  Local nRecZbo := CenZboz->( RecNo()), nRecIT, aScope

  IF nKEY = xbeK_INS
    PVPITEMww->cSkladKAM   := dm:get( 'PVPITEMww->cSkladKAM' )  // !!!
    PVPITEMww->nOrdItKAM   := PVPITEMww->nOrdItem + 1000
    PVPITEMww->cUcetSkKAM  := PADR( PVPITEMww->nUcetSkKAM, 10)
    PVPITEMww->nCenNapDod  := CenZboz ->nCenasZBO
    PVPITEMww->nCenapZBO   := CenZboz ->nCenapZBO
    PVPITEMww->nCenaCelk   := Round( PVPITEMww-> nMnozPrDod * PVPITEMww-> nCenNapDOD, 2)
    PVPITEMww->nTypPoh     := -1
    *
    IF ( lOk := PrevodIsOK_( Dlg) )
    EndIf
  *
  ELSEIF nKEY = xbeK_ENTER
    * modifikace zdrojové položky 80
    PVPITEMww-> nCenaCelk   := Round( PVPITEMww-> nMnozPrDod * PVPITEMww-> nCenNapDOD, 2)
    PVPITEMww ->cUctovano   := ' '

  ENDIF
RETURN NIL

*
*-------------------------------------------------------------------------------
STATIC FUNCTION PrevodIsOK_( Dlg)
  Local lPrevod := .T., lFound, aPrevod, nCho, cKey
  Local oDlg, nExit
  Local cKeyKAM := Upper( PVPITEMww->cSkladKAM) + Upper( PVPITEMww->cSklPolKAM)

  drgDBMS:open('CenZBOZ',,,,,'CenZBOZ_w')
  drgDBMS:open('CENZBOZw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  mh_COPYFLD('CENZBOZ', 'CENZBOZw', .T.)

  IF  !( lFound := CenZboz_w->( dbSeek( cKeyKAM,,'CENIK03')) )

     nCho := AlertBOX( , "Skladová položka na cílovém skladu neexistuje !" ,;
                          { "~Zápis", "~Oprava", "~Konec" }  ,;
                          XBPSTATIC_SYSICON_ICONQUESTION,;
                          'Zvolte možnost'    )
     DO CASE
       CASE nCho = 1    //  automaticky založit skl. položku
        cKey := Upper( CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
        aPrevod   := { 'nZboziKat' , 'nKlicDph' , 'cPolCen'   ,;
                       'cZkratJedn', 'cZkratMeny', 'cZahrMena', 'cTypSklCen',;
                       'nCenasZbo' , 'cNazZbo', 'nCenapZBO', 'nCenamZBO' }
        IF AddREC( 'CenZBOZ')
          aEval( aPrevod,;
           {|x| CenZboz->( FieldPut( FieldPos( x), CenZBOZw->( FieldGet( FieldPos( x))) )) } )
          CenZboz->cCisSklad := PVPITEMww->cSkladKam
          CenZboz->cSklPol   := PVPITEMww->cSklPolKam
          CenZboz->nUcetSkup := PVPITEMww->nUcetSkKam
          CenZboz->cUcetSkup := PVPITEMww->cUcetSkKam
          PrevodPC( cKey )
          CenZboz->( dbUnlock())
        ENDIF

       CASE nCho = 2    // založení neexistující pol. a její modifikace
         *
         cKey := Upper( CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
         IF ( lPrevod := CenZBOZ_crd_( Dlg) )
           PrevodPC( cKey )
         ELSE
           DelRec( 'PVPItem')
           drgMsgBox(drgNLS:msg( 'Pøevod položky byl zrušen !', XBPMB_INFORMATION ))
         ENDIF
         */
       CASE nCho = 3    // storno
         lPrevod := .F.
         PVPItem->( dbUnlock())
         DelRec( 'PVPItem')
         drgMsgBox(drgNLS:msg( 'Pøevod položky byl zrušen !', XBPMB_INFORMATION ))
     ENDCASE
   ENDIF
RETURN lPrevod

*-------------------------------------------------------------------------------
STATIC FUNCTION CenZboz_crd_( Dialog)
  LOCAL oDialog, nExit, lOK := .F.
  LOCAL aPrevod := { { 'CenZBOZw->cCisSklad' , PVPItemww->cSkladKam  },;
                     { 'CenZBOZw->cSklPol'   , PVPItemww->cSklPolKam },;
                     { 'CenZBOZw->cNazZbo'   , PVPItemww->cNazZbo    },;
                     { 'CenZBOZw->nZboziKat' , CenZboz->nZboziKat  },;
                     { 'CenZBOZw->nUcetSkup' , CenZboz->nUcetSkup  },;
                     { 'CenZBOZw->cTypSklPol', 'U '                },;
                     { 'CenZBOZw->nKlicDph'  , CenZboz->nKlicDph   },;
                     { 'CenZBOZw->cPolCen'   , CenZboz->cPolCen    },;
                     { 'CenZBOZw->cZkratJedn', CenZboz->cZkratJedn },;
                     { 'CenZBOZw->cZkratMeny', CenZboz->cZkratMeny },;
                     { 'CenZBOZw->cZahrMena' , CenZboz->cZahrMena  },;
                     { 'CenZBOZw->cTypSklCen', CenZboz->cTypSklCen },;
                     { 'CenZBOZw->nCenasZbo' , CenZboz->nCenasZbo  } }

  DRGDIALOG FORM 'SKL_CENZBOZ_CRD' PARENT Dialog CARGO drgEVENT_APPEND CARGO_USR aPrevod ;
                                    MODAL DESTROY EXITSTATE nExit
  lOK := ( nExit != drgEVENT_QUIT )

RETURN lOK

*== Pøetažení prodejních cen pøi pøevodu =======================================
FUNCTION PrevodPC( cKey)

  drgDBMS:open('CenProdC')
  drgDBMS:open('CENPRODC',,,,,'CENPRODCa' )
  drgDBMS:open('CENPRODCw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  If CENPRODCa->( dbSeek( cKey,, 'CENPROD1'))
     mh_COPYFLD('CENPRODCa', 'CENPRODCw', .T.)
     If CENPRODCa->( dbSeek( Upper( CenZboz->cCisSklad) + Upper( CenZboz->cSklPol),, 'CENPROD1'))
       * CenProdC se našel, tedy šlo se volbou Oprava ( pøes edit. skladovou kartu)
       * a CenProdC se založil odtud
       If CENPRODC->( sx_RLock())
         mh_COPYFLD('CENPRODCw', 'CENPRODC')
         CenProdC->cCisSklad := CenZboz->cCisSklad
         CenProdC->cSklPol   := CenZboz->cSklPol
         CenProdC->( dbUnlock())
       EndIf
     Else
       * CenProdC se nenašel, tedy šlo se volbou Zápis
       If CENPRODC->( dbAppend(), sx_RLock())
         mh_COPYFLD('CENPRODCw', 'CENPRODC')
         CenProdC->cCisSklad := CenZboz->cCisSklad
         CenProdC->cSklPol   := CenZboz->cSklPol
         CenProdC->( dbUnlock())
       Endif
     EndIf
  Endif
  CENPRODCa->( dbCloseArea())
RETURN Nil


* Vytvoøení párového dokladu  DP=40  k pøevodu DP=80
*===============================================================================
FUNCTION SKL_PVPHead_40_( cSkladKAM)  // (  dm)
  Local cKey, cErr := '???'
  Local lExistHD, lOK,  nOrdItem , nRecHD := PVPHead->( RecNO())
  *
  mh_COPYFLD('PVPHEAD', 'PVPHEADw', .T. )
  PVPHEADw->nCislPoh   := 40
  PVPHEADw->cCisSklad  := cSkladKAM
  pvpheadW->ndokladVYD := pvphead->ndoklad
  *
  cKEY := S_DOKLADY +  ALLTRIM( STR( PVPHEADw->nCislPoh ))
  lOK := C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
  PVPHEADw->cTypDoklad := IF( lOK, C_TypPoh->cTypDoklad, cErr )
  PVPHEADw->cTypPohybu := IF( lOK, C_TypPoh->cTypPohybu, cErr )
  *
  ckey     := cskladKam +strZero(pvpHeadw->ncislPoh,5) +strZero(pvpHeadw->ndoklad,10)

  if .not. pvpHead->( dbseek( ckey,,'PVPHEAD03'))
    mh_COPYFLD('PVPHEADw', 'PVPHEAD', .T.)
  endif
RETURN Nil

* Vytvoøení párových položek  DP=40  k pøevodu DP=80
*===============================================================================
FUNCTION SKL_PVPItem_40_()    // dm, nOrdItem, nCenNapDod )
*
  Local cIT := 'PVPITEMww', cHD := 'PVPHEADw', lExistIT, cKey
*
  cKey := Upper(PVPITEM->cCisSklad )+ Upper(PVPITEM->cSklPol )
  IF CenZboz->( dbSeek( cKey,, 'CENIK03' ))

     mh_COPYFLD('PVPHEADw', 'PVPITEMww', .t. )
    (cIT)->cSklPol    := CenZboz->cSklPol
    (cIT)->cNazZBO    := CenZboz->cNazZBO
    (cIT)->nKlicDPH   := CenZboz->nKlicDPH

    (cIT)->nUcetSkup  := CenZboz->nUcetSkup
    (cIT)->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
    (cIT)->cZkratMENY := CenZboz->cZkratMENY
    (cIT)->cZkratJedn := CenZboz->cZkratJedn
    (cIT)->nKlicNAZ   := CenZboz ->nKlicNaz
    (cIT)->nZboziKAT  := CenZboz ->nZboziKAT
    (cIT)->cPolCen    := CenZboz->cPolCen
    (cIT)->cTypSKP    := CenZboz->cTypSKP
    (cIT)->cUctovano  := ' '
    (cIT)->nTypPOH    := IIF( (cHD)->nKARTA < 200,  1,;
                          IIF( (cHD)->nKARTA < 300, -1,;
                          IIF( (cHD)->nKARTA = 400,  1, 0 )))
    (cIT)->cCisZakaz  := IF( (cIT)->nTypPoh = -1, (cIT)->cNazPol3, (cIT)->cCisZakaz )
    (cIT)->cCisZakazI := (cIT)->cCisZakaz
    (cIT)->cCasPVP    := time()
    (cIT)->nRec_CenZb := CenZboz ->( RecNo())
    (cIT)->_nRecor    := 0
    *
    PVPItemww->nMnozPrDod  := PVPITEM->nMnozPrDod
    PVPItemww->nCenNapDod  := PVPITEM->nCenNapDod  // skl. cena pøevádìné položky CenZboz->nCenasZBO
    PVPItemww->nCenapZBO   := CenZboz ->nCenapZBO
    PVPItemww->nOrdItem    := PVPITEM->nOrdItem + 1000
    PVPItemww->nTypPoh     := 1
    PVPItemww->cCislObINT  := space( 30)
    PVPItemww->nCenaCelk   := PVPITEM->nCenaCelk  // Round( PVPItemww-> nMnozPrDod * PVPItemww-> nCenNapDOD, 2)
    PVPItemww->cSkladKAM   := PVPItem->cCisSklad   // sklad   odkud byla pøevedena
    PVPItemww->cSklPolKAM  := PVPItem->cSklPol     // položka    dtto
    PVPItemww->nOrdItKAM   := PVPITEM->nOrdItem    // poøadí     dtto
    PVPItemww->nUcetSkKAM  := PVPITEM->nUcetSkup   // üè.sk.     dtto
    PVPItemww->cUcetSkKAM  := PVPITEM->cUcetSkup   // üè.sk.     dtto
    PVPItemww->nCislPoh    := 40
    PVPItemww->cCisSklad   := PVPITEM->cSkladKAM
    PVPItemww->cSklPol     := PVPITEM->cSklPolKAM
    PVPItemww->nUcetSkup   := PVPITEM->nUcetSkKAM
    PVPItemww->cUcetSkup   := PADR( PVPITEMww->nUcetSkup, 10)
    PVPItemww->nPVPHEAD    := isNUll(pvpHead->sID,0)

    pvpitemWW->ndokladVYD  := pvpitem->ndoklad

    *
    cKey := Upper(PVPITEM->cSkladKAM) + StrZero( PVPITEM->nDoklad, 10) + StrZero(PVPITEM->nOrdItKam,5)

    aScopeIT  := PVPITEM->( dbScope( SCOPE_BOTH))
                 PVPITEM->( mh_ClrScope())

    lExistIT := PVPITEM->( dbSeek( cKey,, 'PVPITEM02'))
    IF lExistIT
      IF PVPItemww->nMnozPrDod <> PVPItem->nMnozPrDod
// js        skl_cenzboz_modi( xbeK_ENTER,40,'pvpheadw','pvpitem','pvpitemww')
      ENDIF
      PVPITEM->( RLock())
    ELSE
// js      skl_cenzboz_modi( xbeK_INS,40,'pvpheadw','pvpitem','pvpitemww')
    ENDIF
    mh_COPYFLD('PVPITEMww', 'PVPITEM', IF( lExistIT, .F.,.T. ))

    PVPITEM->( mh_SetSCOPE( aScopeIT[ 1], aScopeIT[ 2]) )
  ENDIF
RETURN nil


* Rušení položky pøevodního dokladu
*===============================================================================
FUNCTION  SKL_DelPolPrevod_()
*
  Local  anPVPIT := {}, Filter, nRecZbo, n, aScopeIT, x, nRec, nRecHD
  Local  cSkladKAM := PVPItem->cSkladKAM, nDoklad := PVPItem->nDoklad
  Local  cKey := Upper( cSkladKAM) + StrZero( nDoklad, 10) + StrZero( PVPItem->nOrdItKAM, 5)

  * oba rušené záznamy do pole
  ** nejprve záznam 80
  AADD( anPVPIT, PVPITEM->( RecNO()) )
  * zrušíme scope, abysme mohli dohledat pøíjmový pohyb 40
  aScopeIT  := PVPITEM->( dbScope( SCOPE_BOTH))
               PVPITEM->( mh_ClrScope())
  *
  IF PVPITEM->( dbSeek( cKey,, 'PVPITEM02' ))
    ** potom i záznam 40
    AADD( anPVPIT, PVPITEM->( RecNO()) )
  ENDIF
  *
  IF PVPITEM->( sx_RLock( anPVPIT))
    FOR n := 1 TO LEN( anPVPIT)
      PVPITEM->( dbGoTO( anPVPIT[ n]))
      IF n = 1
// js        SKL_CenZboz_Modi( xbeK_DEL, 80 )
        *
        ** položka pøevodky maá vazbu na objitem
        if .not. empty( pvpItem->ccislObINT )
          SKL_ObjPrij_akt( xbeK_DEL )
        endif

      ELSEIF n = 2
// js        SKL_CenZboz_Modi( xbeK_DEL, 40 )
      ENDIF
      PVPITEM->( dbDelete())
      PVPITEM->( dbRUnlock( anPVPIT[n]))
    NEXT
  ENDIF
  *
  PVPITEM->( mh_SetSCOPE( aScopeIT[ 1], aScopeIT[ 2]) )
  *
  drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
  * již neexistuje položka párového dokladu 40, je tøeba smazat HLA40
  cKey := Upper( cSkladKAM) + StrZero( nDoklad, 10)
  IF !PVPITEMa->( dbSeek( cKey,, 'PVPITEM02' ))
    nRecHD := PVPHEAD->( RecNo())
    cKey := Upper( cSkladKAM) + '00040' + StrZero( nDoklad, 10)
    IF PVPHEAD->( dbSeek( cKey,, 'PVPHEAD03' ))
       nRec := PVPHEAD->( RecNo())
       IF PVPHEAD->( dbRLock( nRec))
          PVPHEAD->(dbDelete(), dbRUnlock( nRec))
       ENDIF
    ENDIF
    PVPHEAD->( dbGoTO( nRecHD))
  ENDIF

RETURN Nil

* Rušení pøevodního dokladu
*===============================================================================
Function  SKL_DelPrevod_()
*===============================================================================
  Local  anPVPHD := {}, anPVPIT := {}, acSklady := {}
  Local  nDoklad := PVPHead->nDoklad, n, nPos
  Local  nRecHD  := PVPHead->( RecNo()), nRecIT
  Local  nRecZbo := CenZboz->( RecNo())
  Local  cKeyHead, cKeyKAM
  Local  aScopeIT, lockHD, lockIT

  PVPItem->( dbEval( {|| ;
    IF( PVPItem->nCislPoh = 80, AADD( anPVPIT, PVPItem->( RecNo())), Nil) ,;
    If( ( nPos := aScan( acSklady, PVPItem->cSkladKam)) == 0 ,;
          aAdd( acSklady , PVPItem->cSkladKam ), Nil)  }))
  *
  aScopeIT  := PVPITEM->( dbScope( SCOPE_BOTH))
               PVPITEM->( mh_ClrScope())

  *
  AADD( anPVPHD, PVPHead->( RecNo()) )
  FOR n := 1 To Len( acSklady)
    cKeyHead := Upper( acSklady[ n]) + '00040' + StrZero( nDoklad, 10)
    If PVPHead->( dbSeek( cKeyHead,, 'PVPHEAD03'))
      AADD( anPVPHD, PVPHead->( RecNo()) )
    Endif
  NEXT
  PVPHead->( dbGoTo( nRecHD))
  *
  lockHD := PVPHEAD->( sx_RLock( anPVPHD))
  lockIT := PVPITEM->( sx_RLock( anPVPIT))
  * Rušení položek u jednotlivých pøevodních dokladù
  IF lockHD .and. lockIT
    FOR n := 1 To Len( anPVPIT)
      PVPItem->( dbGoTo( anPVPIT[ n]))
      *
// js      SKL_CenZboz_Modi( xbeK_DEL, 80 )
      *
      ** položka pøevodky maá vazbu na objitem
      if .not. empty( pvpItem->ccislObINT )
        SKL_ObjPrij_akt( xbeK_DEL )
      endif

      *
      cKeyKAM := Upper( PVPItem->cSkladKAM) + StrZero( PVPItem->nDoklad, 10)+;
                 StrZero( PVPItem->nOrdItKAM, 5)
      PVPItem->( dbDelete())
      *
      IF PVPItem->( dbSeek( cKeyKAM,,'PVPITEM02'))
        nRecIT := PVPItem->( RecNO())
// js        SKL_CenZboz_Modi( xbeK_DEL, 40 )
        PVPITEM->( dbRLock( nRecIT), dbDelete(), dbRUnlock( nRecIT) )
      ENDIF
    NEXT
    PVPITEM->( dbUnlock())
    *
    aEVAL( anPVPHD, {|x| PVPHEAD->(dbGoTo(x), dbDelete())} )
    PVPHEAD->( dbUnlock())
  ELSE
    drgMsgBox(drgNLS:msg( 'Pøevod nelze zrušit, doklad je blokován jiným uživatelem !', XBPMB_INFORMATION ))

  ENDIF
  *
  PVPITEM->( mh_SetSCOPE( aScopeIT[ 1], aScopeIT[ 2]) )
RETURN Nil