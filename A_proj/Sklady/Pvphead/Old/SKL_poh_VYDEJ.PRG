/*==============================================================================NEW
  SKL_VYDEJ.PRG
==============================================================================*/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

CLASS SKL_pohyb_VYDEJ // FROM SKL_POHYBY_Main
EXPORTED:
  VAR     IT, HD, nMnHlp
  VAR     parent, nPocetBal, nZustatek, cNazDIMu

  METHOD  Init
  *
  METHOD  MnVydane, MnHlp, Baleni_CMP, NewInvCis, KartaDIM
  METHOD  ZakUkonc   // test, zda výrobní zakázka, pøíslušející úèetní zakázce je již uzavøená
ENDCLASS

********************************************************************************
METHOD SKL_pohyb_VYDEJ:init(parent)

  ::IT := parent:parent:udcp:IT
  ::HD := parent:parent:udcp:HD
  *
  ::nPocetBal := 0
  ::nZustatek := 0
  ::parent    := parent
  ::cNazDIMu  := ''
  *
RETURN self

METHOD SKL_pohyb_VYDEJ:MnVydane(oVar)
  Local lOK := .T., cKey
  Local dm := oVar:drgDialog:dataManager, UDCP := oVar:drgDialog:UDCP
  Local nVAL := oVar:value, nMnozsZBO, nMnozdZBO, nPos, newIT := UDCP:newIt
  Local lValid := ( oVar:changed() .or. newIT )
  Local nKarta := UDCP:nKarta
  Local lVydNadNor := SysConfig( 'Sklady:lVydNadNor')
  Local nCelkDokl

  ::IT := UDCP:IT
  ::HD := UDCP:HD

  IF lValid
    nVal := PrepocetMJ( nVal, dm:get(::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )
    dm:set(::IT + '->nMnozPrDod', nVal)

    cKey := If( newIT, UDCP:uHd:mainSKLAD, (::IT )->cCisSklad)
    cKey +=  Upper( dm:get(::IT + '->cSklPol'))

    If CenZboz->( dbSeek( cKey,, 'CENIK03')) .and. Upper( CenZboz->cPolCen) == 'C'

      ::MnHlp( dm:get(::IT + '->cSklPol') )
      nMnozdZBO := CenZboz->nMnozdZBO + If( newIt, 0, (::IT)->nMnozPrDOD) - ::nMnHlp
      nMnozsZBO := CenZboz->nMnozsZBO + If( newIt, 0, (::IT)->nMnozPrDOD) - ::nMnHlp

      If nVal == 0
        drgMsgBox(drgNLS:msg('Množství vydané musí být nenulové !'), XBPMB_WARNING )
        lOK := .F.
      Else
        If Upper( CenZboz->cTypSklCen) == 'PRU'   ///// New
          lOK := ( nVal <= nMnozdZBO )
          IF (::HD)->nKarta == 274
            IF ( !lVydNadNor .AND. nVal > ObjItem->nMnozObOdb - ObjItem->nMnozPlODB )
              drgMsgBox(drgNLS:msg('Není povolen nadnormativní výdej !'), XBPMB_WARNING )
              lOK := .F.
            ELSEIF !lOK
              IF drgIsYesNO(drgNLS:msg('Množství k dispozici je pouze < & > !;' +;
                                       'Chcete pøedisponovat z jiných objednávek ?', nMnozdZBO) )

              ENDIF
            ENDIF
          ELSEIF !lOK
            drgMsgBox(drgNLS:msg('Množství  k dispozici je pouze < & > !', nMnozdZBO ), XBPMB_WARNING )
          ENDIF

          If lOK
            If !( lOK := ( nVal <= nMnozsZBO ))
              drgMsgBox(drgNLS:msg('Množství skladové je pouze < & > !', nMnozsZBO) )
            EndIf
          Endif
        EndIf

        ::Baleni_CMP( nVAL, .T., dm )

        IF ( nPos := ASCAN( { 203,253,263,283,293 }, (::HD)->nKARTA)) > 0
          dm:set('M->nVyslCenaB', dm:get(::IT + '->nCenaZakl') - dm:get(::IT + '->nHodnSlev') )
          dm:set('M->nVyslCenaS', dm:get('M->nVyslCenaB') * ;
                                 ( 1 + ( SeekKodDPH( dm:get(::IT + '->nKlicDph'))) / 100) )
          dm:set('M->nSumaPolB', dm:get('M->nVyslCenaB') * dm:get(::IT + '->NMNOZPRDOD') )
          dm:set('M->nSumaPolS', dm:get('M->nVyslCenaS') * dm:get(::IT + '->NMNOZPRDOD') )


        ELSEIF ( nPos := ASCAN( { 204,274 }, (::HD)->nKARTA)) > 0
          ::parent:UDCP:uHd:DokladCelkem( .F.)
          nCelkDokl := ::parent:UDCP:uHd:nCelkDokl  - (::IT)->nCenaCelk

          dm:set('M->nCelkITEM', UDCP:nCelkITEM := dm:get('PVPITEMww->nCenNapDod') * nVAL )
          dm:set('M->nCelkDokl', nCelkDOKL + UDCP:nCelkITEM  )

        ENDIF
      EndIf
    EndIF
  ENDIF
  *
  IF ( nPos := ASCAN( { 205 }, (::HD)->nKARTA)) > 0
    dm:set('PVPITEMww->nCenaCelk', CenZBOZ->NCENASZBO * nVAL )
  ENDIF
RETURN lOK

********************************************************************************
METHOD SKL_pohyb_VYDEJ:MnHlp( cSklPol)
  Local nRecNo := (::IT)->( RecNo())

  ::nMnHlp := 0
  (::IT)->( dbEval({|| ::nMnHlp += IF( cSklPol = (::IT)->cSklPol, IF((::IT)->_nRecOr=0,(::IT)->nMnozPrDod,0), 0 ) }))
  (::IT)->( dbGoTo( nRecNo))
RETURN self

* Výpoèet kusù balení a zùstatku vydávaného zboží
********************************************************************************
METHOD SKL_pohyb_VYDEJ:Baleni_CMP( nMnozPrDod, SetInEDIT, dm )

  DEFAULT SetInEdit TO .F.
  ::nPocetBal := If( CenZboz->nBalKs <> 0, INT( nMnozPrDod /CenZboz->nBalKs), 0 )
  ::nZustatek := If( CenZboz->nBalKs <> 0, nMnozPrDod % CenZboz->nBalKs     , nMnozPrDod )
  IF SetInEdit
    dm:set('M->nPocetBal', ::nPocetBal )
    dm:set('M->nZustatek', ::nZustatek )
  ENDIF
RETURN self

* Zjistí nejbližší inventární èíslo pro pøevádìný DIM ( karta 205) a nabídne ho
METHOD SKL_pohyb_VYDEJ:NewInvCis(nInvCis)

  drgDBMS:open('MsDIM',,,,, 'MsDIMa'  )
  IF nInvCIS <> 0 .AND. !MsDIMa->( dbSEEK( nInvCIS,, 'DIM1'))
  ELSE
    MsDIMa->( dbGoBOTTOM())
    nInvCIS := MsDIMa->nInvCisDIM + 1
  ENDIF
RETURN nInvCIS

********************************************************************************
METHOD SKL_pohyb_VYDEJ:ZakUKONC( nTAG, cKEY )
  Local lZakUKONC := NO

  IF ALLTRIM(STR( (::HD)->nKarta)) $ '204,206,253,274'
    IF VyrZAK->( dbSEEK( Upper( cKEY),, AdsCtag(nTag)))
      IF ( lZakUKONC := ( ALLTRIM( UPPER( VyrZAK->cStavZakaz)) = 'U' ))
        drgMsgBox(drgNLS:msg('Zakázka [ & ] již byla ukonèena !', VyrZAK->cCisZakaz ))
      ENDIF
    ENDIF
  ENDIF
RETURN lZakUKONC

*
METHOD SKL_pohyb_VYDEJ:KartaDIM( Dialog)
  Local nExit, oDialog

  drgDBMS:open( 'MSDIMw',.T.,.T.,drgINI:dir_USERfitm) ;  MSDIMw->( dbZAP())
  DRGDIALOG FORM 'SKL_MsDIM_CRD' PARENT Dialog  MODAL DESTROY EXITSTATE nExit
RETURN self

*
********************************************************************************
CLASS SKL_MsDIM_crd FROM drgUsrClass
EXPORTED:
  VAR     newDIM
  METHOD  Init, drgDialogStart, postValidate, eventhandled

HIDDEN
  VAR     parentDlg, prevdm, dm
  METHOD  saveCardDim, ZmenyDIM
  *
ENDCLASS

********************************************************************************
METHOD SKL_MsDIM_crd:init(parent)
  *
  ::parentDlg := parent:parentDialog:cargo
  ::prevdm    := ::parentDlg:dataManager
  ::newDIM    := !( parent:parent:cargo = drgEVENT_EDIT)
  *
  if ::newDIM
    MSDIMw->( dbAppend())
  ENDIF
  drgDBMS:open('MsDIM'    )
  drgDBMS:open('ZmenyDIM' )
RETURN self

********************************************************************************
METHOD SKL_MsDIM_crd:drgDialogStart( drgDialog)

  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::dm := drgDialog:dataManager
  * Pøednastavení karty DIMu z pøedchozího skladového dokladu
  ::dm:set( 'MSDIMw->cKlicSkMis'   , ::prevdm:get( 'PVPITEMww->cKlicSkMis'))
  C_SkuMis->( dbSeek( ::prevdm:get( 'PVPITEMww->cKlicSkMis'),, 'C_1') )
  ::dm:set( 'MSDIMw->cKlicOdMis'   , ::prevdm:get( 'PVPITEMww->cKlicOdMis'))
  C_OdpMis->( dbSeek( ::prevdm:get( 'PVPITEMww->cKlicOdMis'),, 'C_1') )
  ::dm:set( 'MSDIMw->nInvCisDim'   , ::prevdm:get( 'PVPITEMww->nInvCisDim'))
  ::dm:set( 'MSDIMw->cNazevDIM'    , CenZboz->cNazZbo )
  ::dm:set( 'MSDIMw->dDatZarDim'   , Date())
  ::dm:set( 'MSDIMw->nTypDIM'      , 1  )
  C_TypDim->( dbSeek( 1,, 'C_1' ))
  ::dm:set( 'MSDIMw->nPocKusDim'   , ::prevdm:get( 'PVPITEMww->nMnozPrDod') )
  ::dm:set( 'MSDIMw->cZkratJedn'   , CenZboz->cZkratJedn)
  ::dm:set( 'MSDIMw->nCenJedDim'   , CenZboz->nCenaSZBO )
  ::dm:set( 'MSDIMw->nCenCelDim'   , CenZboz->nCenaSZBO * ::prevdm:get( 'PVPITEMww->nMnozPrDod') )
  ::dm:refresh()
  *
  IsEditGET( { 'MSDIMw->cKlicSkMis', 'MSDIMw->cKlicOdMis', 'MSDIMw->nPocKusDim',;
               'MSDIMw->nCenJedDim', 'MSDIMw->nCenCelDim'}, drgDialog, .F. )
RETURN self

********************************************************************************
METHOD SKL_MsDIM_crd:eventHandled(nEvent, mp1, mp2, oXbp)
  Local x, lOK

  DO CASE
    CASE nEvent = drgEVENT_SAVE

      if oXbp:Classname() = 'xbpGet' .or. oXbp:Classname() = 'xbpStatic'
         If ( lOK := ::SaveCardDIM( If( ::newDim, xbeK_INS, xbeK_ENTER )))
           PostAppEvent(xbeP_Close,,, oXbp )
         Endif
         return .f.
      endif

    CASE nEvent = drgEVENT_QUIT

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
           RETURN .F.
        Otherwise
          RETURN .F.
       EndCase
     OTHERWISE
       RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SKL_MsDIM_crd:postValidate( oVar)
  Local lOK := .T.
  Local value := oVar:value, name := oVar:name
  Local mp1, mp2, oXbp, nEvent

  nEvent := LastAppEvent( @mp1, @mp2, @oXbp)

  Do Case
    Case name = 'MSDIMw->nInvCisDim'
       If lOK := ControlDUE( oVar, .t.)
          drgDBMS:open( 'MSDIM',,,,, 'MSDIM_a')
          If (lOK := MSDIM_a->(dbSeek( value,, 'DIM1')) )
             drgMsgBox(drgNLS:msg( 'Duplicitní inventární èíslo ...'))
          EndIf
          lOK := !lOK
          MSDIM_a->( dbCloseArea())
       EndIf

    Case name = 'MSDIMw->nCenJedDim'
      ::dm:set( 'MSDIMw->nCenCelDim', value * ::dm:get( 'MSDIMw->nPocKusDim'))

    Case name = 'MSDIMw->dDatRevDim'
        IF( nEvent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          PostAppEvent(drgEVENT_SAVE,,, oXbp)

        EndIf
  EndCase
RETURN lOK

*HIDDEN*************************************************************************
METHOD SKL_MsDIM_crd:saveCardDim( nKey)
  Local lRet := .T.
  *
  ::dm:save()
  MSDIMw->dDatPohDim := date()
  ::prevdm:set( 'PVPITEMww->nInvCisDim', MSDIMw->nInvCisDim )
  *
  PVPITEMww->nCenNapDod := MSDIMw->nCenJedDim
  PVPITEMww->nCenaCelk  := MSDIMw->nCenCelDim
RETURN lRet


*HIDDEN*************************************************************************
METHOD SKL_MsDIM_crd:zmenyDim( nKey)
  Local  lDelVydej := ( nKEY == xbeK_DEL ), cTAG, cKEY
  Local  cUSERabb := SYSCONFIG( 'SYSTEM:cUSERABB' )
  *
  IF lDelVydej
    cTAG := ZmenyDIM->( AdsSetOrder( 2))
    cKEY := STRZERO( MsDimw->nInvCisDIM)      //  + '0001'
    IF ZmenyDIM->( dbSEEK( cKEY))
       DELREC( 'ZmenyDIM')
    ENDIF
    ZmenyDIM->( OrdSetFOCUS( cTAG))

  ELSE
    mh_copyfld( 'MSDIM', 'ZmenyDIM', .T.)

    ZmenyDIM->cBroPolDim := 'SKLADY - VÝDEJ DO DKP'
    ZmenyDIM->cFldPolDim := 'nPocKusDim'
    ZmenyDIM->cPOPzmDIM  := 'ZAØAZENO'
    ZmenyDIM->cNEWVAL    := STR( PVPHeadw->nDoklad, 10)   //Ä 20.5.02
    ZmenyDIM->nPoh_DIM   := 10
    ZmenyDIM->lPoh_Dim   := YES
    *
    drgDBMS:open('ZmenyDIM',,,,, 'ZmenyDIMw' )
    ZmenyDIMw->( AdsSetOrder( 'C_ZMDIM5'), dbGoBottom())
    ZmenyDIM->nCISzmDIM  := ZmenyDIMw->nCisZmDIM + 1   // CisZmDIM()
    *
    ZmenyDIM->dDATzmDIM  := DATE()
    ZmenyDIM->cCASzmDIM  := TIME()
    ZmenyDIM->cUserAbb   := cUSERabb
    ZmenyDIM->nROK       := PVPHeadw->nROK
    ZmenyDIM->nObdobi    := PVPHeadw->nObdobi
    ZmenyDIM->cObdobi    := PVPHeadw->cObdPoh
    ZmenyDIM->nPoh_Sign  := 1

  ENDIF
RETURN self

*===============================================================================
FUNCTION SKL_VydejDKP_SAVE( nKEY, AllRecs, cIT, oDlg )
  Local cKey, cHD, dm

  DEFAULT  AllRecs TO .F., cIT TO 'PVPITEMww'

  cHD  := IF( cIT = 'PVPITEMww', 'PVPHEADw', 'PVPHEAD' )
  cKey := Upper((cIT)->cKlicOdMis) + StrZERO((cIT)->nInvCisDIM, 6)

  IF nKey = xbeK_INS
    * založit kartu DIMu
    if oDlg <> nil   // volání z položkové karty dokladu

      if select('MSDIMw') = 0   // nešel do karty DIMu
        drgDBMS:open( 'MSDIMw',.T.,.T.,drgINI:dir_USERfitm) ;  MSDIMw->( dbZAP())
        drgDBMS:open('MSDIM'   )
        drgDBMS:open('ZMENYDIM')
        *
        MSDIMw->( dbAppend())
        dm := oDlg:dataManager
        MSDIMw->cKlicSkMis  := dm:get( 'PVPITEMww->cKlicSkMis')
        MSDIMw->cKlicOdMis  := dm:get( 'PVPITEMww->cKlicOdMis')
        MSDIMw->nInvCisDim  := dm:get( 'PVPITEMww->nInvCisDim')
        MSDIMw->cNazevDim   := CenZboz->cNazZbo
        MSDIMw->dDatZarDim  := date()
        MSDIMw->nTypDim     := 1
        MSDIMw->nPocKusDim  := dm:get( 'PVPITEMww->nMnozPrDod')
        MSDIMw->cZkratJedn  := CenZboz->cZkratJedn
        MSDIMw->nCenJedDim  := CenZboz->nCenaSZBO
        MSDIMw->nCenCelDim  := CenZboz->nCenaSZBO * dm:get( 'PVPITEMww->nMnozPrDod')
        MSDIMw->nCisFak     := PVPITEMww->nCisFak
        MSDIMw->nDokPriDim  := PVPITEMww->nDokPriDim
      endif
    endif
    *
    MSDIMw->nCisloPVP := PVPITEMww->nDoklad
    *
    MSDIMw->cNazPol1  := PVPITEMww->cNazPol1
    MSDIMw->cNazPol2  := PVPITEMww->cNazPol2
    MSDIMw->cNazPol3  := PVPITEMww->cNazPol3
    MSDIMw->cNazPol4  := PVPITEMww->cNazPol4
    MSDIMw->cNazPol5  := PVPITEMww->cNazPol5
    MSDIMw->cNazPol6  := PVPITEMww->cNazPol6
    *
    mh_copyfld( 'MSDIMw','MSDIM', .T.)
    MSDIM->( dbCommit())
    MSDIMw->( dbCloseArea())
    * založit zmìnový záznam
    mh_copyfld( 'MSDIM', 'ZmenyDIM', .T.)
    ZmenyDIM->cBroPolDim := 'SKLADY - VÝDEJ DO DKP'
    ZmenyDIM->cFldPolDim := 'nPocKusDim'
    ZmenyDIM->cPOPzmDIM  := 'ZAØAZENO'
    ZmenyDIM->cNEWVAL    := STR( PVPHeadw->nDoklad, 10)   //Ä 20.5.02
    ZmenyDIM->nPoh_DIM   := 10
    ZmenyDIM->lPoh_Dim   := YES
    *
    drgDBMS:open('ZmenyDIM',,,,, 'ZmenyDIMw' )
    ZmenyDIMw->( AdsSetOrder( 'C_ZMDIM5'), dbGoBottom())
    ZmenyDIM->nCISzmDIM  := ZmenyDIMw->nCisZmDIM + 1   // CisZmDIM()
    *
    ZmenyDIM->dDATzmDIM  := DATE()
    ZmenyDIM->cCASzmDIM  := TIME()
    ZmenyDIM->nROK       := PVPHeadw->nROK
    ZmenyDIM->nObdobi    := PVPHeadw->nObdobi
    ZmenyDIM->cObdobi    := PVPHeadw->cObdPoh
    ZmenyDIM->nPoh_Sign  := 1

  ELSEIF nKey = xbeK_ENTER

  ELSEIF nKey = xbeK_DEL

    IF (cHD)->nKarta == 205
      *
      drgDBMS:open('MSDIM')
      drgDBMS:open('ZMENYDIM')

      IF AllRecs
        PVPITEMww->( dbGoTop())
        DO WHILE !PVPITEMww->( EOF())
          IF PVPITEMww->_nrecor = 0
            cKey := Upper( (cIT)->cKlicOdMis) + StrZERO( (cIT)->nInvCisDIM, 6)
            IF MsDIM->( dbSEEK( cKey,, 'DIM5'))
              IF MsDIM->( RLock())
                MsDIM->nPocKusDIM := IF( MsDIM->nPocKusDIM - (cIT)->nMnozPrDOD >= 0,;
                                         MsDIM->nPocKusDIM - (cIT)->nMnozPrDOD, 0 )
                IF ZmenyDIM->( dbSEEK( StrZero(MsDim->nInvCisDIM, 6),, 'C_ZMDIM2'))
                  ZmenyDIM->( dbRLock(), dbDelete(), dbUnlock())
                ENDIF
                MsDIM->( dbDelete())
              ENDIF
            ENDIF
          ENDIF
          (cIT)->( dbSKIP())
        ENDDO
        msDim->(dbunlock(), dbcommit())

      ELSE
        IF MsDIM->( dbSEEK( cKey,, 'DIM5'))
          IF MsDIM->( RLock())
            MsDIM->nPocKusDIM := IF( MsDIM->nPocKusDIM - (cIT)->nMnozPrDOD >= 0,;
                                     MsDIM->nPocKusDIM - (cIT)->nMnozPrDOD, 0 )
            IF ZmenyDIM->( dbSEEK( StrZero(MsDim->nInvCisDIM, 6),, 'C_ZMDIM2'))
              ZmenyDIM->( dbRLock(), dbDelete(), dbUnlock())
            ENDIF

            if cIT = 'PVPITEMww'
              if( PVPITEMww->_nrecor = 0, msDim->(dbDelete()), nil )
            endif
          ENDIF
          msDim->(dbunlock(), dbcommit())

        ENDIF
      ENDIF
    ENDIF
  ENDIF
RETURN NIL

********************************************************************************
* Výbìr ze seznamu pøíjemek dané skl. položky do dokladu o výdeji do DIMu
********************************************************************************
CLASS SKL_PrijDIM_SEL FROM drgUsrClass

EXPORTED:
  VAR     cCisSklad, cSklPol, dDatPVP
EXPORTED:
  METHOD  Init, EventHandled, itemMarked, itemSelected, drgDialogStart, drgDialogEnd
HIDDEN:
  VAR     dm_parent
ENDCLASS

********************************************************************************
METHOD SKL_PrijDIM_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_TYPPOH')

  *
  PVPITEM->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPITEM->CULOHA)+UPPER(PVPITEM->CTYPPOHYBU) },;
                                            'UPPER(PVPITEM->CULOHA)+UPPER(PVPITEM->CTYPPOHYBU)', 'C_TYPPOH06'))
RETURN self

********************************************************************************
METHOD SKL_PrijDIM_SEL:drgDialogStart(drgDialog)
  Local cKey, aRecs := {}, cTag := PVPITEM->( OrdSetFocus('PVPITEM30')), nCount
  *
  ::dm_parent := drgDialog:parent:dataManager
  ::cCisSklad := ::dm_parent:get( 'PVPHEADw->cCisSklad')
  ::cSklPol   := ::dm_parent:get( 'PVPITEMww->cSklPol')
  ::dDatPVP   := date() - 365
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  cKey := Upper(::cCisSklad) + Upper(::cSklPol) + '01'
  PVPITEM->( mh_SetScope( cKey))

  DO WHILE !PVPItem->( eof())
    * Nabízet se budou jen pøíjemky za uplynulý rok ( 365 dní)
    IF DTOS( PVPItem->dDatPVP) >= DTOS(::dDatPVP)
      AADD( aRecs, PVPItem->( RecNO()) )
    ENDIF
    PVPItem->( dbSkip())
  ENDDO
*
  PVPITEM->( mh_SetFilter( ".F."))
  nCount := Ads_GetRecordCount()
  IF Len( aRecs) > 0
    PVPItem->(Ads_customizeAOF(aRecs, 1))
    nCount := Ads_GetRecordCount()
  ENDIF
  *
  PVPItem->( mh_ClrScope(), OrdSetFocus( cTag))
  ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  PVPITEM->( dbGoTOP())
RETURN self

********************************************************************************
METHOD SKL_PrijDIM_SEL:drgDialogEnd(drgDialog)
  PVPItem->( mh_ClrFilter())
RETURN self

********************************************************************************
METHOD SKL_PrijDIM_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

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
METHOD SKL_PrijDIM_SEL:itemMarked()
RETURN self

********************************************************************************
METHOD SKL_PrijDIM_SEL:itemSelected()
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
RETURN self

********************************************************************************
* Výbìr ze seznamu výdejek pøi opravém dokladu
********************************************************************************
CLASS SKL_Vydejky_SEL FROM drgUsrClass

EXPORTED:
  VAR     cCisSklad, dDatPVP
EXPORTED:
  METHOD  Init, EventHandled, itemSelected, drgDialogStart, drgDialogEnd
HIDDEN:
  VAR     dm_parent
ENDCLASS

********************************************************************************
METHOD SKL_Vydejky_SEL:init(parent)
  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TYPPOH')
  *
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
RETURN self

********************************************************************************
METHOD SKL_Vydejky_SEL:drgDialogStart(drgDialog)
  Local cKey, aRecs := {}, cTag := PVPHEAD->( OrdSetFocus('PVPHEAD17')), nCount
  *
  ::dm_parent := drgDialog:parent:dataManager
  ::cCisSklad := ::dm_parent:get( 'PVPHEADw->cCisSklad')
  ::dDatPVP   := date() - 365
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  cKey := Upper(::cCisSklad) + '2'
  PVPHEAD->( mh_SetScope( cKey))    // Jen výdejky

  DO WHILE !PVPHEAD->( eof())
    * Nabízet se budou jen výdejky za uplynulý rok ( 365 dní)
    IF DTOS( PVPHEAD->dDatPVP) >= DTOS(::dDatPVP)
      AADD( aRecs, PVPHEAD->( RecNO()) )
    ENDIF
    PVPHEAD->( dbSkip())
  ENDDO
*
  PVPHEAD->( mh_SetFilter( ".F."))
  nCount := Ads_GetRecordCount()
  IF Len( aRecs) > 0
    PVPHEAD->(Ads_customizeAOF(aRecs, 1))
    nCount := Ads_GetRecordCount()
  ENDIF
  *
  PVPHEAD->( mh_ClrScope(), OrdSetFocus( cTag))
  ::drgDialog:dialogCtrl:oBrowse[1]:oXbp:refreshAll()
  PVPHEAD->( dbGoTOP())
RETURN self

********************************************************************************
METHOD SKL_Vydejky_SEL:drgDialogEnd(drgDialog)
  PVPHEAD->( mh_ClrFilter())
RETURN self

********************************************************************************
METHOD SKL_Vydejky_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

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
METHOD SKL_Vydejky_SEL:itemSelected()
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
RETURN self


********************************************************************************
* Výbìr ze seznamu položek výdejky pøi opravém dokladu - karta 299
********************************************************************************
CLASS SKL_Vydejky_IT_SEL FROM drgUsrClass

EXPORTED:
  VAR     cCisSklad, cSklPol, dDatPVP
EXPORTED:
  METHOD  Init, EventHandled, itemSelected, drgDialogStart, drgDialogEnd
HIDDEN:
  VAR     dm_parent
ENDCLASS

********************************************************************************
METHOD SKL_Vydejky_IT_SEL:init(parent)

  ::drgUsrClass:init(parent)
  drgDBMS:open('C_TYPPOH')
RETURN self

********************************************************************************
METHOD SKL_Vydejky_IT_SEL:drgDialogStart(drgDialog)
  Local cKey, aRecs := {}, cTag := PVPITEM->( OrdSetFocus('PVPITEM02')), nCount
  *
  ::dm_parent := drgDialog:parent:dataManager
  ::cCisSklad := ::dm_parent:get( 'PVPHEADw->cCisSklad')
  ::dDatPVP   := date() - 365
  *
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
RETURN self

********************************************************************************
METHOD SKL_Vydejky_IT_SEL:drgDialogEnd(drgDialog)
  PVPHEAD->( mh_ClrFilter())
RETURN self

********************************************************************************
METHOD SKL_Vydejky_IT_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::itemSelected()

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
METHOD SKL_Vydejky_IT_SEL:itemSelected()
  PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
RETURN self


* Promítnutí výdeje do ObjItem, ObjHead   ( náhrada SKL_ObjPrij_modi)
*===============================================================================
Function SKL_ObjPrij_akt( nKey)
*===============================================================================
  Local lOk, lIT, lHD, lMnozVpInt := NO
  Local nKarta := PVPHead->nKarta, nNesplneno, nHLP, nPos
  Local cKey, cHeadFlt, cItemFlt, cKodTPV
  local is_274_or_305
/*
   PVPItem->nMnozPrDOD  // Množ. vydané
   PVPItem->nMnozKobje  // Množ. k objednání u dod. v ObjItem
   PVPItem->nMnozPoODB  // Množ. potvrzené v ObjItem
   PVPItem->nMnozReODB  // Množ. rezervovano v ObjItem
   PVPItem->nMnozVyObj  // Množ. vykrývající ObjItem
   PVPItem->nMnozVpInt  // Množ. k výrobì
*/

IF ( nPos := ASCAN( { 253,274,293,305 }, nKarta)) > 0
    *
    drgDBMS:open('OBJHEAD')
    drgDBMS:open('OBJITEM')
    *
    IF nKey <> xbeK_INS
     cHeadFlt := ObjHead->( dbFilter())
     ObjHead->( dbClearFilter())
     cItemFlt := ObjITEM->( dbFilter())
     ObjItem->( dbClearFilter())

     cKey := StrZero( PVPHead->nCisFirmy, 5) + Upper( PVPItem->cCislObINT)
     lOK := ObjHead->( dbSeek( cKey,, 2))
     cKey := Upper( PVPItem->cCislObINT) +StrZero( PVPItem->nCislPolOb, 5)
     lOK := ObjItem->( dbSeek( cKey,, 3))
   ENDIF
  *
  drgDBMS:open('NAKPOL' )
  IF NakPOL->( dbSEEK( Upper( PVPItem->cCisSklad) + Upper( PVPItem->cSklPOL),, 3))
    cKodTPV := UPPER( ALLTRIM( NakPOL->cKodTPV))
    lMnozVpInt := ( cKodTPV $ 'PR')
  ENDIF
  *
  lIT           := ObjITEM->( sx_RLock())
  lHD           := ObjHEAD->( sx_RLock())
  is_274_or_305 := ( ascan({274,305}, nkarta) > 0 )

  IF lOK := ( lIT .and. lHD)
    Do Case
    Case nKey == xbeK_ENTER
        If PVPItem->nMnozPoODB < PVPItemWW->nMnozPrDod
           ObjItem->nMnozNeODB -= PVPItemWW->nMnozPrDod - PVPItem->nMnozPoODB
           ObjItem->nMnozNeODB := MAX( 0, ObjItem->nMnozNeODB )
        EndIf
        nHLP := PVPItemWW->nMnozPrDod - PVPItem->nMnozReODB
        IF lMnozVpInt .AND. nKARTA == 274
          ObjItem->nMnozVpInt := MAX( 0, PVPItem->nMnozVpInt - If( nHLP > 0, nHLP, 0))
        ELSE
          ObjItem->nMnozKoDod := MAX( 0, PVPItem->nMnozKobje - If( nHLP > 0, nHLP, 0))
        ENDIF
        IF  PVPItemWW->nMnozPrDod < 0 .AND. PVPItem->nMnozPrDOD < 0
          * neaktualizuj nMnozReODB
        ELSEIF PVPItemWW->nMnozPrDod < 0 .AND. PVPItem->nMnozPrDOD > 0
          ObjItem->nMnozReODB := MAX( 0, PVPItemWW->nMnozReODB )
        ELSE
          ObjItem->nMnozReODB := MAX( 0, PVPItemWW->nMnozReODB - PVPItemWW->nMnozPrDod )
        ENDIF
        nNesplneno := ObjItem->nMnozObODB - PVPItem->nMnozVyObj + ObjItem->nMnozPlODB

        * Množství vykrývající obj.pøijatou
        PVPItem->nMnozVyObj := If( PVPItemWW->nMnozPrDod > nNesplneno,;
                                   nNesplneno, PVPItemWW->nMnozPrDod )
        ObjItem->nMnozPlODB += IF( is_274_or_305,;
                                   PVPItemWW->nMnozPrDOD - PVPItem->nMnozPrDOD,;
                                   PVPItemWW->nMnozVyObj - PVPItem->nMnozVyObj )

        ObjHead->nMnozPlODB += IF( is_274_or_305,;
                                   PVPItemWW->nMnozPrDOD - PVPItem->nMnozPrDOD,;
                                   PVPItemWW->nMnozVyObj - PVPItem->nMnozVyObj )
        ObjHead->cPokrObj := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )

     Case nKey == xbeK_DEL

        IF( PVPItem->nMnozPrDod < 0, NIL, ObjItem->nMnozReODB := PVPItem->nMnozReODB )
        ObjItem->nMnozPlODB -= IF( is_274_or_305, PVPItem->nMnozPrDOD, PVPItem->nMnozVyObj )
        ObjItem->nMnozNeODB := ObjItem->nMnozObODB - ObjItem->nMnozPoODB
        IF( lMnozVpInt, ObjItem->nMnozVpInt := PVPItem->nMnozVpInt,;
                        ObjItem->nMnozKoDod := PVPItem->nMnozKobje )
        *
        ObjHead->nMnozPlODB -= IF( is_274_or_305, PVPItem->nMnozPrDOD, PVPItem->nMnozVyObj )
        ObjHead->cPokrObj   := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )

     Case nKey == xbeK_INS
        If ObjItem->nMnozPoODB < PVPItemWW->nMnozPrDod
           ObjItem->nMnozNeODB -= PVPItemWW->nMnozPrDod - ObjItem->nMnozPoODB
           ObjItem->nMnozNeODB := MAX( 0, ObjItem->nMnozNeODB )
        EndIf
        nHLP := PVPItemWW->nMnozPrDod - ObjItem->nMnozReODB
        IF lMnozVpInt
          ObjItem->nMnozVpInt -= If( nHLP > 0, nHLP, 0)
          ObjItem->nMnozVpInt := MAX( 0, ObjItem->nMnozVpInt )
        ELSE
          ObjItem->nMnozKoDod -= If( nHLP > 0, nHLP, 0)
          ObjItem->nMnozKoDod := MAX( 0, ObjItem->nMnozKoDod )
        ENDIF

        IF PVPItemWW->nMnozPrDod < 0
          * neaktualizuj nMnozReODB
        ELSE
          ObjItem->nMnozReODB -= PVPItemWW->nMnozPrDod
          ObjItem->nMnozReODB := MAX( 0, ObjItem->nMnozReODB )
        ENDIF
        nNesplneno := ObjItem->nMnozObODB - ObjItem->nMnozPlODB

        * Množství vykrývající obj.pøijatou
        PVPItem->nMnozVyObj := If( PVPItemWW->nMnozPrDod > nNesplneno,;
                                   nNesplneno, PVPItemWW->nMnozPrDod )
        ObjItem->nMnozPlODB += IF( is_274_or_305, PVPItemWW->nMnozPrDod, PVPItemWW->nMnozVyObj )
        *
        ObjHead->nMnozPlODB += IF( is_274_or_305, PVPItemWW->nMnozPrDod, PVPItemWW->nMnozVyObj )
        ObjHead->cPokrObj := If( ObjHead->nMnozObODB > ObjHead->nMnozPlODB, 'C', 'V' )
    EndCase

    objitem->nmnoz_Svyd := objitem->nmnozPlOdb
    objitem->nstav_Svyd := if(objitem->nmnoz_Svyd = 0                  , 0, ;
                           if(objitem->nmnoz_Svyd < objitem->nmnozObOdb, 1, ;
                           if(objitem->nmnoz_Svyd > objitem->nmnozObOdb, 3, 2)))

  ENDIF
  IF( lIT, ObjITEM->( dbUnlock()), NIL )
  IF( lHD, ObjHEAD->( dbUnlock()), NIL )
EndIf
RETURN Nil


* Kontrola prodejní ceny pøi výdeji
*===============================================================================
FUNCTION SKL_ProdCena( nCena)
*===============================================================================
  Local cMsg :=;
    IF( nCena == 0                 , 'nulová !',;
    IF( nCena < CenZboz->nCenasZBO , 'pod hranicí ceny skladové !',;
    IF( nCena == CenZboz->nCenasZBO, 'shodná  s cenou skladovou !', '' )))

  IF !EMPTY( cMsg)
    drgMsgBox(drgNLS:msg( 'POZOR, prodejní cena je ' + cMsg, XBPMB_WARNING ))
  ENDIF
RETURN .T.

