//////////////////////////////////////////////////////////////////////
//
//  CENZBOZ.PRG
//
//////////////////////////////////////////////////////////////////////
#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dbstruct.ch"
#include "..\SKLADY\SKL_Sklady.ch"

*****************************************************************
*
*****************************************************************
CLASS SKL_CENZBOZ_CRD FROM drgUsrClass
EXPORTED:
  VAR     cKodTPV
  VAR     lEditALL

  METHOD  Init, Destroy
  METHOD  drgDialogStart
  METHOD  EventHandled

  METHOD  PreValidate, PostValidate
  METHOD  SKL_C_NAZZBO, C_SKLADY

  METHOD  CenapVLD
  METHOD  ProcMARZ
  METHOD  CenapZBO
  METHOD  CenamZBO
  METHOD  GetPC
  METHOD  SetEdit

  METHOD  OnSave

HIDDEN:
  VAR     dc, dm
  VAR     lNewCENZBOZ, lNewPC
  METHOD  SetNoChange
ENDCLASS

********************************************************************************
*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:init(parent)
  Local cKEY := Upper(CENZBOZ->cCisSklad) + Upper(CENZBOZ->cSklPol)

  ::drgUsrClass:init(parent)
  *
  ::lNewCENZBOZ := !( parent:cargo = drgEVENT_EDIT)
  ::lEditALL    := .F.
  *
  drgDBMS:open('UcetSYS' )
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('CenProdC')
  drgDBMS:open('CenZB_ps')
  drgDBMS:open('C_BCD'   )
  drgDBMS:open('NAKPOL'  )
  drgDBMS:open('PVPITEM' )
  drgDBMS:open('CENZBOZw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CENPRODCw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
  *
  CenProdC->( dbSetScope(SCOPE_BOTH, cKEY ))
  *
  IF ::lNewCENZBOZ
     CENPRODCw->( dbAppend())
     ::lNewPC := .T.
     *
     CENZBOZw->(dbAppend())
     ::cKodTPV            := 'U'  // U = Materiál nebo zboží
     CENZBOZw->cTypSklCen := Upper( SysCONFIG('Sklady:cTypCeny'))
     CENZBOZw->nKlicDph   := VAL( SysCONFIG('Finance:cZaklDph') )
     CENZBOZw->cPolCen    := SysCONFIG('Sklady:cPolCen')
     CENZBOZw->cZkratJedn := SysCONFIG('Sklady:cZaklJedn')
     CENZBOZw->cZkratMeny := SysCONFIG('Finance:cZaklMena')
     CENZBOZw->nCarkKod   := VldBarCod()
     CENZBOZw->cVyrCis    := ' ' // = neevidovat     acVyrCis[ GetCFG( 'cTypVyrCis')]
     CENZBOZw->cKatalCis  := 'N'
  ELSE
     mh_COPYFLD('CENZBOZ', 'CENZBOZw', .T.)
     NakPol->( dbSEEK( cKey,, 3))
     ::cKodTPV := NakPOL->cKodTPV
     ::lNewPC := EMPTY( CenProdC->cCisSklad)
     IF( ::lNewPC, CENPRODCw->( dbAppend()),;
                   mh_COPYFLD('CENPRODC', 'CENPRODCw', .T.) )
  ENDIF

RETURN self

********************************************************************************
*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:destroy()

  ::drgUsrClass:destroy()
  ::lEditALL    := ;
  ::lNewCENZBOZ := ;
  ::lNewPC      := ;
  ::cKodTPV     := ;
                 Nil
  CenProdC->( dbClearScope())
RETURN self

********************************************************************************
*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:EventHandled(nEvent, mp1, mp2, oXbp)

  DO CASE
    CASE  nEvent = drgEVENT_SAVE
      IF ::drgDialog:parent:formName <> 'SKL_CENZBOZ_SCR'
        ::onSave()
      ENDIF
      PostAppEvent(xbeP_Close, nEvent,, ::drgDialog:dialog)

    CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
      PostAppEvent(xbeP_Close,nEvent,,oXbp)

    CASE nEvent = xbeP_Keyboard
      DO CASE
        CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,, ::drgDialog:dialog)
        CASE mp1 = xbeK_ALT_F12
          ::lEditALL := !::lEditALL
          ::SetEdit()

        OTHERWISE
          Return .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:drgDialogStart(drgDialog)
  Local isPohyb
  ::dc := drgDialog:dialogCtrl
  ::dm := drgDialog:dataManager
  *
  IF !::lNewCENZBOZ
    * Pokud již existují pohyby, zablokovat opravu tìchto položek
    drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
    isPohyb := PVPITEMa->( dbSEEK( Upper(CenZBOZ->cCisSklad) + Upper(CenZBOZ->cSklPol),,1))
    PVPITEMa->( dbCloseArea())
    IsEditGET( {'CenZBOZw->cTypSklCen'  ,;
                'CenZBOZw->cPOLCEN'     ,;
                'CenZBOZw->nUcetSkup'   },  drgDialog, !isPohyb)
  ENDIF
  *
*  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
  IF ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
     drgDialog:SetReadOnly( .T.)
  ENDIF
  * Nastavení needitovatelných položek
  ::SetEdit()
  * Pøi volání z prodejních cen nastav záložku "Prodejní ceny"
  IF drgDialog:parent:formName = 'SKL_CenZboz2_SCR'
    drgDialog:oForm:tabPageManager:showPage( 2, .T.)
  ENDIF
RETURN self

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:PreValidate(oVar)
  LOCAL lOK := .T.
  LOCAL cName := oVar:Name, Filter

  DO CASE
    CASE cName = 'CENZBOZw->cUlozZbo'
      * Nabídnout jen místa uložení daného skladu
      Filter := FORMAT("(C_UlozMi->cCisSklad = '%%')",;
                IF( ::lNewCENZBOZ, { ::dm:get('CENZBOZw->cCisSklad')},;
                                   { CENZBOZ->cCisSklad } ) )
*      C_UlozMi->( Ads_setAOF(filter), dbGoTOP() )
     C_UlozMi->( dbSetFilter( COMPILE( Filter)), dbGoTOP() )
  ENDCASE
RETURN lOK

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:PostValidate(oVar)  // VLD_CENZBOZ(oVar)
  LOCAL xVar := oVar:get(), oIt
  LOCAL lFound, lRet := .T.
  LOCAL cName := oVar:Name, cKey, cSklPol
  Local lChanged := oVar:changed()
  Local aValues := ::dm:vars:values

  If ::lNewCENZBOZ .or. lChanged
    cSklPol := ::dm:get('CENZBOZw->cSklPol')

    DO CASE
    CASE cName = 'CENZBOZw->CCISSKLAD'
**      lRet := ::C_SKLADY()
      IF ( lRet := ::C_SKLADY() )
        IF ::lNewCENZBOZ .and. !Empty( cSklPol )
          cKey :=  Upper(xVar) + Upper( cSklPol)
          lFound := CENZBOZa->( DBSEEK( cKey,, 3))
          IF lFound
            drgMsgBox(drgNLS:msg('Skladová položka [ & ] v rámci skladu [ & ] již existuje !', cSklPol, xVar ))
            lRet := .F.
          ENDIF
          If lRet
            If CENZBOZa->( DBSEEK( Upper( cSklPol ),,1))
              drgMsgBox(drgNLS:msg( 'Skladová položka  [ & ]  existuje na jiném skladu !', cSklPol))
            EndIf
          EndIF

        ENDIF
      ENDIF

    CASE cName = 'CENZBOZw->CSKLPOL'
      ::drgDialog:pushArea()            // save SELECT() + ORDER()
      cKey := ::dm:get('CENZBOZw->cCisSklad') + Upper(xVar)
      lFound := CENZBOZa->( DBSEEK( cKey,, 3))

      IF ::lNewCENZBOZ
        IF lFound
          drgMsg(drgNLS:msg('Skladová položka v rámci skladu již existuje !'),, ::drgDialog:dialog)
          lRet := .F.
        ENDIF
        If lRet
          If CENZBOZa->( DBSEEK( Upper( xVar),,1))
            drgMsgBox(drgNLS:msg( 'Skladová položka  [ & ] existuje na jiném skladu !', cSklPol))
          EndIf
        EndIF
      ELSEIF lChanged .AND. lFound
        oVar:recall()
        drgMsgBox('Nelze mìnit klíèový údaj!')
        lRet := .F.
      ENDIF
      ::drgDialog:popArea()             // restore SELECT() + ORDER()

    CASE cName = 'CENZBOZw->CNAZZBO'
       ::SKL_C_NAZZBO()
       ::dm:set('CENZBOZw->nZboziKat', C_NAZZBO->nZboziKAT )

    CASE cName = 'CENZBOZw->CTYPSKLCEN'
      IsEditGET( 'CENZBOZw->nCenaSZBO', ::drgDialog, (Upper( xVar) == 'PEV') )

    CASE ( cName = 'CENZBOZw->NMNOZSZBO' .or. cName = 'CENZBOZw->NCENASZBO' )
      IF xVar <> 0
        ::dm:set('CENZBOZw->nCenaCZBO', ::dm:get('CENZBOZw->nMnozsZBO') * ::dm:get('CENZBOZw->nCenasZBO') )
      ENDIF

    CASE cName = 'CENZBOZw->NCENACZBO'
      IF xVar <> 0
        ::dm:set('CENZBOZw->nCenaSZBO', ::dm:get('CENZBOZw->nCenaCZBO') / ::dm:get('CENZBOZw->nMnozSZBO') )
      ENDIF

    CASE cName = 'CenProdCw->NCENCNZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMarz', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMARZ')
        IF( ::dm:get('CenProdCw->nCenaP1ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ1', ::ProcMARZ( 1)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ1')
        IF( ::dm:get('CenProdCw->nCenaP2ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ2', ::ProcMARZ( 2)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ2')
        IF( ::dm:get('CenProdCw->nCenaP3ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ3', ::ProcMARZ( 3)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ3')
        IF( ::dm:get('CenProdCw->nCenaP4ZBO') <> 0,;
            ::dm:set('CenProdCw->nProcMARZ4', ::ProcMARZ( 4)), NIL)
            ::SetNoChange( 'CenProdCw->nProcMARZ4')
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nCenaPZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaPZBO')
        ::dm:set('CenProdCw->nCenaMZBO', ::CenaMZBO() )
        ::SetNoChange( 'CenProdCw->nCenaMZBO')
        ::CenapVLD()
      ENDIF

    CASE cName = 'CenProdCw->NCENAPZBO'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nProcMARZ', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMarz')
        ::dm:set('CenProdCw->nCenaMZBO', ::CenaMZBO() )
        ::SetNoChange( 'CenProdCw->nCenaMZBO')
        ::CenapVLD()
      ENDIF

    CASE cName = 'CenProdCw->NCENAMZBO'
      IF xVar <> 0 .and. lChanged
        ::dm:set('CenProdCw->nCenaPZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaPZBO')
        ::dm:set('CenProdCw->nProcMARZ', ::ProcMARZ() )
        ::SetNoChange( 'CenProdCw->nProcMARZ')
*        CenapVLD( xVar, ::dm:get('CENZBOZ->NCENASZBO') )
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ1'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP1ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP1ZBO')
        ::CenapVLD( 1)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP1ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ1', ::ProcMARZ( 1) )
        ::SetNoChange( 'CenProdCw->nProcMARZ1')
        ::CenapVLD( 1 )
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ2'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP2ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP2ZBO')
        ::CenapVLD( 2)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP2ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ2', ::ProcMARZ( 2) )
        ::SetNoChange( 'CenProdCw->nProcMARZ2')
        ::CenapVLD( 2)
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ3'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP3ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP3ZBO')
        ::CenapVLD( 3)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP3ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ3', ::ProcMARZ( 3) )
        ::SetNoChange( 'CenProdCw->nProcMARZ3')
        ::CenapVLD( 3)
      ENDIF

    CASE cName = 'CenProdCw->NPROCMARZ4'
      IF xVar <> 0
        ::dm:set('CenProdCw->nCenaP4ZBO', ::CenaPZBO( cName) )
        ::SetNoChange( 'CenProdCw->nCenaP4ZBO')
        ::CenapVLD( 4)
      ENDIF

    CASE cName = 'CenProdCw->NCENAP4ZBO'
      IF xVar <> 0
        ::dm:set('CenProdCw->nProcMARZ4', ::ProcMARZ( 4) )
        ::SetNoChange( 'CenProdCw->nProcMARZ4')
        ::CenapVLD( 4)
      ENDIF
    ENDCASE

  ENDIF

RETURN lRet

********************************************************************************
METHOD SKL_CENZBOZ_CRD:SetNoChange( cItem)
  Local oIt := ::dm:has( cItem)
  Local value := Round( oIt:Value, 2)

  oIt:initValue := oIt:prevValue := oIt:Value := value
RETURN self

* Upozorní, pokud nìkterá z prodejních cen je <= skladové cenì
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenapVLD( nTypPC)
  Local nCenaP, nCenaS := ::dm:get( 'CENZBOZw->nCenaSZBO')

  nCenaP := ::GetPC( nTypPC)
  If nCenaP < nCenaS
     drgMsgBox(drgNLS:msg( 'Prodejní cena je nižší než cena skladová !'))
  ElseIf nCenaP = nCenaS
     drgMsgBox(drgNLS:msg( 'Prodejní cena je shodná s cenou skladovou !'))
  EndIf
Return Nil

* Z pøíslušné prodejní ceny vypoèítá pøíslušnou marži
* Parametry:
* /nTypPC/ ...typ prodejní ceny ( 0 = základní, 1-4 = PC1 - PC4 )
********************************************************************************
METHOD SKL_CENZBOZ_CRD:ProcMARZ( nTypPC)
  Local nProcMarz := 0, nPC
  Local nCenCNZBO := ::dm:get( 'CenProdCw->nCenCNZBO')

  IF nCenCNZBO <> 0
    nPC := ::GetPC( nTypPC)
    nProcMarz := (( nPC - nCenCNZBO ) * 100 )/ nCenCNZBO
    nProcMarz := IF( nPC <= 0, 0, ROUND( nProcMarz, 2) )
  ENDIF

RETURN( nProcMarz )

* Na základì typu prodejní ceny získá její hodnotu z editaèní karty
********************************************************************************
METHOD SKL_CENZBOZ_CRD:GetPC( nTypPC)
  Local nPC

  DEFAULT nTypPC TO 0
  nPC := IIF( nTypPC = 0, ::dm:get('CenProdCw->nCenaPZBO'),;
          IIF( nTypPC = 1, ::dm:get('CenProdCw->nCenaP1ZBO'),;
           IIF( nTypPC = 2, ::dm:get('CenProdCw->nCenaP2ZBO'),;
            IIF( nTypPC = 3, ::dm:get('CenProdCw->nCenaP3ZBO'),;
             IIF( nTypPC = 4, ::dm:get('CenProdCw->nCenaP4ZBO'), 0 )))))
Return( nPC)

* Pøepoèítá základní prodejní cenu bez danì, popø. PC1 - PC4
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenaPZBO( cName)
  Local nPC := 0.0000, nCenCNZBO := ::dm:get( 'CenProdCw->NCENCNZBO')
  Local nDph := SeekKodDPH( ::dm:get( 'CENZBOZw->nKlicDph'))

  Do Case
    Case cName = 'CenProdCw->NCENAMZBO'
      nPC := ::dm:get( 'CenProdCw->NCENAMZBO') / ( 1 + ( nDph / 100))
    Case cName = 'CenProdCw->NPROCMARZ'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ') / 100))
    Case cName = 'CenProdCw->NPROCMARZ1'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ1') / 100))
    Case cName = 'CenProdCw->NPROCMARZ2'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ2') / 100))
    Case cName = 'CenProdCw->NPROCMARZ3'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ3') / 100))
    Case cName = 'CenProdCw->NPROCMARZ4'
      nPC := nCenCNZBO * ( 1 + ( ::dm:get( 'CenProdCw->nProcMARZ4') / 100))
  EndCase

RETURN nPC

* Vypoèítá prodejní cenu s daní
********************************************************************************
METHOD SKL_CENZBOZ_CRD:CenaMZBO()
  Local nCenaMZBO := 0.0000
  Local nDph := SeekKodDPH( ::dm:get( 'CENZBOZw->nKlicDph'))

  nCenaMZBO := ::dm:get( 'CenProdCw->NCENAPZBO') * ( 1 + ( nDph / 100))
RETURN nCenaMZBO

* Nastaví (ne)editovatelnost definovaných položek
********************************************************************************
METHOD SKL_CENZBOZ_CRD:SetEdit()
  Local aFIELDs

  aFIELDs := { 'CENZBOZw->nMnozsZBO', 'CENZBOZw->nCenaCZBO', 'CENZBOZw->nCarkKod' ,;
               'CENZBOZw->nMnozPoc' , 'CENZBOZw->nMnozDZBO', 'CENZBOZw->nMnozRZBO',;
               'CENZBOZw->nMnozOZBO', 'CENZBOZw->nMnozRZBO', 'CENZBOZw->NMNOZKZBO',;
               'CENZBOZw->NMNOZRSES', 'CENZBOZw->NCENAPOC' , 'CENZBOZw->NCENASVZM',;
               'CENZBOZw->NCENAKURZ', 'CENZBOZw->NCENAVNI' }
  IsEditGET( aFIELDs, ::drgDialog, ::lEditAll )
RETURN NIL

* Realizace èinností pøi uložení karty CENZBOZ
********************************************************************************
METHOD SKL_CENZBOZ_CRD:OnSave(isBefore, isAppend)
  LOCAL lOkCEN, lOkPC

  IF ! ::dc:isReadOnly
    ::dm:save()
    lOkCEN := If( ::lNewCENZBOZ, AddREC('CenZBOZ') , ReplREC('CenZBOZ' ))
    lOkPC  := If( ::lNewPC     , AddREC('CenProdC'), ReplREC('CenProdC'))
    IF lOkCEN .and. lOkPC
      mh_COPYFLD( 'CenZBOZw' , 'CenZBOZ')
      CenZBOZ->cUcetSkup := ALLTRIM(STR( CenZBOZ->nUcetSkup))
      *
      mh_COPYFLD( 'CenProdCw', 'CenProdC')
      CenProdC->nProcMarz  := ::dm:get('CenProdCw->nProcMarz' )
      CenProdC->nCenaPZBO  := ::dm:get('CenProdCw->nCenaPZBO' )
      CenProdC->nCenaMZBO  := ::dm:get('CenProdCw->nCenaMZBO' )
      CenProdC->nCenaP1ZBO := ::dm:get('CenProdCw->nCenaP1ZBO')
      CenProdC->nCenaP2ZBO := ::dm:get('CenProdCw->nCenaP2ZBO')
      CenProdC->nCenaP3ZBO := ::dm:get('CenProdCw->nCenaP3ZBO')
      CenProdC->nCenaP4ZBO := ::dm:get('CenProdCw->nCenaP4ZBO')
      *
      CENZBOZ->nCenCNZBO := CenProdC->nCenCNZBO
      CENZBOZ->nCenapZBO := CenProdC->nCenapZBO
      CENZBOZ->nCenamZBO := CenProdC->nCenamZBO
      CENZBOZ->lViceCenP := ( CenProdC->nCenaP1ZBO + CenProdC->nCenaP2ZBO + ;
                              CenProdC->nCenaP3ZBO + CenProdC->nCenaP4ZBO ) > 0
      IF ::lNewPC
        CenProdC->cCisSklad := CENZBOZ->cCisSklad
        CenProdC->cSklPol   := CENZBOZ->cSklPol
        CenProdC->cNazZbo   := CENZBOZ->cNazZbo
      ENDIF
      IF ::lNewCENZBOZ
        * Zápis do èíselníku èárových kódù
        IF  lOK := AddREC('C_BCD')
          C_BCD->nCarkKod := CENZBOZ->nCarkKod
          mh_WRTzmena( 'C_BCD', .T.)
          C_BCD->( dbUnlock())
        ENDIF
        * Zápis do souboru poè.stavù
        mh_COPYFLD( 'CenZBOZ' , 'CenZB_ps', .T.)
        CenZB_ps->nROK   := uctOBDOBI:SKL:nRok
      EndIF
      * Aktualizace NakPol
      IF SysCONFIG('Sklady:lVyroba' )
         ::cKodTPV := ::dm:get('M->cKodTpv' )
         SKL_NakPOL_MODI( ::cKodTPV)
      ENDIF
      CenProdC->( dbCommit(), dbUnLock())
      CENZBOZ->( dbCommit(), dbUnLock())
      *
*      PostAppEvent(xbeP_Close,drgEVENT_EXIT,,::drgDialog:dialog)
    ELSE
      drgMsgBox(drgNLS:msg('Nelze modifikovat, záznam je blokován jiným uživatelem !'))
    ENDIF
  ENDIF
RETURN .T.

*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:C_SKLADY( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get('CENZBOZw->cCisSklad', .F.)
  Local value  := Upper( drgVar:get())
  Local ok     := ( !Empty(value) .and. C_SKLADY->(dbseek(value,,1)))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'C_SKLADY' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg

    if nExit = drgEVENT_SELECT
      ::dm:set( 'CENZBOZw->cCisSklad', C_Sklady->cCisSklad )
      ::dm:refresh()
    endif
  endif
RETURN (nExit = drgEVENT_SELECT .or. ok)


*
********************************************************************************
METHOD SKL_CENZBOZ_CRD:SKL_C_NAZZBO( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get('CENZBOZw->cNAZZBO', .F.)
  Local value  := Upper(drgVar:get())
  Local ok     := ( !Empty(value) .and. C_NAZZBO->(dbseek(value,,1)))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'C_NAZZBO' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg

    if nExit = drgEVENT_SELECT
      ::dm:set( 'CENZBOZw->cNazZBO', C_NAZZBO->cNazevNAZ )
    endif
  endif
RETURN (nExit = drgEVENT_SELECT .or. ok)

/* Realizace èinností pøi uložení Ceníku zboží.
*===============================================================================
FUNCTION CenZBOZ_OnSave( oDialog, isBefore)           // isBefore, isAppend)
  Local lNewCenZBOZ := oDialog:dialogCtrl:isAppend
  Local lNewCenProdC := EMPTY( CenProdC->cCisSklad)
  Local lOK, cKodTpv

  IF isBefore
    lOK := CenProdC->( RLock())
    *W  Kontrola na duplicitu skl.položky pøi zápisu
    * DoubleCEN() ... mohla by øešit validace nad cSklPol => otestovat !!!
  ELSE
    lOK := ( CenProdC->( RLock()) .and. CENZBOZ->( RLock()) )
    IF lOK
      CENZBOZ->nCenCNZBO := CenProdC->nCenCNZBO
      CENZBOZ->nCenapZBO := CenProdC->nCenapZBO
      CENZBOZ->nCenamZBO := CenProdC->nCenamZBO
      CENZBOZ->lViceCenP := ( CenProdC->nCenaP1ZBO + CenProdC->nCenaP2ZBO + ;
                                  CenProdC->nCenaP3ZBO + CenProdC->nCenaP4ZBO ) > 0
      SysFLD( 'CENZBOZ', lNewCenZboz  )

      IF lNewCenProdC
        CenProdC->cCisSklad := CENZBOZ->cCisSklad
        CenProdC->cSklPol   := CENZBOZ->cSklPol
        CenProdC->cNazZbo   := CENZBOZ->cNazZbo
      ENDIF
* !!!     SysFLD( 'CenProdC', lNewCenProdC )
*    V DBF souboru nejsou systémové položky

      IF lNewCenZboz
        * Zápis do èíselníku èárových kódù
        C_BCD->( dbAppend())
        IF  lOK := C_BCD->( drgLockOK())
          C_BCD->nCarkKod := CENZBOZ->nCarkKod
          //W SysFLD( 'C_BCD', lNewCenZboz  )
          C_BCD->( dbUnlock())
        ENDIF
        //Vytvoøení kumul. záznamu PVPKumul_Modi()
        PVPKUMUL_MODI()
      EndIF

      *W Aktualizace NakPol
      IF SysCONFIG('Sklady:lVyroba' )
         ::cKodTPV := oDialog:dataManager:get('M->cKodTpv' )
*         SKL_NakPOL_MODI( 'U' )
      ENDIF
      CenProdC->( dbCommit(), dbUnLock())
      CENZBOZ->( dbCommit(), dbUnLock())
    ENDIF
  ENDIF

RETURN NIL
*/

* Realizace èinností pøi zrušení záznamu v Ceníku zboží.
*===============================================================================
FUNCTION SKL_CENZBOZ_DEL()
  Local cText := 'Skladovou položku nelze zrušit, nebo ', acText
  Local cKey := Upper( CENZBOZ->cCisSklad) + Upper( CENZBOZ->cSklPol)
  Local lDelete := .T., lOK := .T.
  Local lVyroba := .T.  //SysConfig( "Sklady:lVyroba")

*  fOrdRec( { 'PVPITEM, 1', 'PVPKUMUL, 2', 'CenZb_NS, 1' } )
  IF( Used('PVPITEM'), NIL, drgDBMS:open('PVPITEM'))
  IF( Used('NAKPOL') , NIL, drgDBMS:open('NAKPOL' ))
  IF( Used('KUSOV')  , NIL, drgDBMS:open('KUSOV'  ))
  *
  IF CENZBOZ->nMnozsZBO > 0
     cText += ' ; množství na skladì   = ' + AllTrim( Str( CENZBOZ->nMnozsZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nCenacZBO > 0
     cText += ' ; skladová cena celkem = ' + AllTrim( Str( CENZBOZ->nCenacZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nMnozkZBO > 0
     cText += ' ; množství k objednání = ' + AllTrim( Str( CENZBOZ->nMnozkZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF CENZBOZ->nMnozrZBO > 0
     cText += ' ; množství rezervované = ' + AllTrim( Str( CENZBOZ->nMnozrZBO, 11, 2))
     lDelete := .F.
  ENDIF
  IF PVPITEM->( dbSeek( cKey,, 1))
     cText += ' ; existují k ní pohybové vìty '
     lDelete := .F.
  ENDIF
  *
  IF lVyroba   // .and. Upper( AllTrim( CenZboz->cKodTpv)) == 'V'
    IF( lOK := Kusov->( dbSeek( Upper( CENZBOZ->cSklPol),, 3)) )
      cText += ' ; je obsažena v kusovníku jako nižší položka !'
      lDelete := .F.
    ENDIF
  ENDIF

  **
  IF lDelete
    IF drgIsYESNO(drgNLS:msg('Zrušit skladovou položku < & - & > ?', CenZBOZ->cSklPol, CenZBOZ->cNazZBO ))
      * smaže Ceník prodejních cen
      IF( Used('CenProdC'), NIL, drgDBMS:open('CenProdC'))
      IF CenProdC->( dbSeek( cKey,, 1))
        DelREC( 'CenProdC')
      ENDIF
      * smaže Ceník zboží pro nákl. strukturu
      IF( Used('CenZb_NS'), NIL, drgDBMS:open('CenZb_NS'))
      IF CenZb_NS->( dbSeek( cKey,, 1))
        DelREC( 'CenZb_NS')
      ENDIF
      * smaže záznamy poè.stavù
      *
      IF( Used('CenZb_ps'), NIL, drgDBMS:open('CenZb_ps'))
      lOK := YES
      DO WHILE lOK
        IF( lOK := CenZb_ps->( dbSeek( cKey,,1)))
          IF CenZb_ps->( dbRLock())
            CenZb_ps->( dbDELETE(), dbUnlock() )
          ENDIF
        ENDIF
      ENDDO
      *
      /* smaže záznamy poè.stavù
      IF( Used('CenZb_ps'), NIL, drgDBMS:open('CenZb_ps'))
      IF CenZb_ps->( dbSeek( StrZero(uctObdobi:SKL:nRok, 4) + cKey,, 2))
        DelREC( 'CenZb_ps')
      ENDIF
      */
      * smaže NAKPOL
      IF lVyroba  // .and. Upper( AllTrim( CenZboz->cKodTpv)) == 'V'
        IF NakPol->( dbSeek( cKey,, 3))
          DelREC( 'NAKPOL')
        ENDIF
      ENDIF
      */
      DelREC( 'CenZBOZ')
    ENDIF
  Else
    drgMsgBox(drgNLS:msg( cText))
  EndIf
*  fOrdRec()

RETURN lDelete

* Pøi zakládání/opravì záznamu v CENZBOZ zakládá/opravuje záznam v NAKPOL
*===============================================================================
FUNCTION SKL_NakPol_Modi( cKodTpv)
  Local cKey := UPPER( CenZboz->cCisSklad) + UPPER(CenZboz->cSklPol)
  Local nREC := CenZBOZ->( RecNO())
  Local lExist, lOK

  Begin Sequence
    If( lExist := NakPol->( dbSEEK( cKey,, 3)) )
      If !( lOK := WasChange( 'NakPol', 'CenZboz'))
        If ( Upper( cKodTpv) == Upper( NakPol->cKodTpv)) .and. ;
           ( Upper( CenZboz->cNazZbo) == Upper( NakPol->cNazTPV))
  BREAK
        Endif
      EndIf
    EndIf

    If ( lOK := If( lExist, ReplRec( 'NakPol'), AddRec( 'NakPol') )  )
      CenZBOZ->( dbGoTO( nREC))   //
      mh_COPYFLD( 'CENZBOZ', 'NAKPOL' )
      If lExist  ;  NakPol->cZmena     := SysConfig( "System:cUserAbb")
                    NakPol->dZmena     := Date()
      Else       ;  NakPol->cZapis     := SysConfig( "System:cUserAbb")
                    NakPol->dZapis     := Date()
                    NakPol->cMjTPV     := CenZboz->cZkratJEDN
                    NakPol->cMjSpo     := CenZboz->cZkratJEDN
                    NakPol->nKoefPrep  := 1
                    NakPol->cKodRezSkl := SysConfig( "Vyroba:cKodRezSkl")
                    NakPol->cNazTPV    := CenZboz->cNazZbo
      Endif
      NakPol->cKodTpv := cKodTpv
      * NakPol->cNazTPV := CenZboz->cNazZbo
      NakPol->( dbUnLock())
    EndIf
  End Sequence

RETURN NIL

* Zjistí, zda nìkterá ze stejnojmených položek obou souborù e liší.
*===============================================================================
FUNCTION WasChange( cINTO, cFROM )
  Local aItmInto := {}, aItmFrom := {}, aStr := {}
  Local n, nPos, lWasChange := FALSE

  aStr := ( cINTO)->( dbStruct())
  aEval( aStr, { |aFld| aAdd( aItmInto, aFld[ DBS_NAME] )} )
  aStr := ( cFROM)->( dbStruct())
  aEval( aStr, { |aFld| aAdd( aItmFrom, aFld[ DBS_NAME] )} )
  For n := 1 To Len( aItmInto)
    If (( nPos := aScan( aItmFrom, aItmInto[ n]) ) <> 0 )
      lWasChange := ;
      If( ( cINTO)->( FieldGet( n)) <> ( cFROM)->( FieldGet( nPos)), TRUE, lWasChange )
    Endif
 Next
Return( lWasChange)

* Pøednastavení èárového kódu.
*===============================================================================
FUNCTION VldBarCod( nKod)
  Local nCarkKod := Val( '0000000000000' ), nBarCod
  Local nDigitBCD, nDigitCMP := 0, nEven := 0, nOdd := 0, n, nX, nRec
  Local cBCD, lOk := .f., lValid := !IsNil( nKod)

  If IsNil( nKod) ;  ( C_BCD->( dbGoBottom()), nBarCod := C_BCD->nCarkKod )
  Else            ;  nDigitBCD  := Val( Right( StrZero( nKod), 1 ))
                     nBarCod := nKod
  EndIf
  cBCD := Left( StrZero( nBarCod ), 12 )
  cBCD := If( IsNil( nKod), StrZero( Val( cBCD) + 1, 12, 0) + '0', cBCD + '0' )
  For n := 1 To Len( cBcd) Step 2
    nOdd += Val( SubStr( cBcd, n, 1))
  Next
  For n := 2 To Len( cBcd) Step 2
    nEven += Val( SubStr( cBcd, n, 1))
  Next
  nX := ( nEven * 3) + nOdd
  nDigitCMP := Round( nX +4, -1 ) - nX
  nCarkKod := Val( Left( cBCD, 12) + StrZero( nDigitCMP, 1))
  If !IsNil( nKod)
    Do Case
      Case nDigitBCD <> nDigitCMP
        drgMsgBox(drgNLS:msg( 'Èárový kód má chybnou kontrolní èíslici !'))
        Return( { .f., nKod, Nil } )
      EndCase
  EndIf
  nKod := If( IsNil( nKod), nCarkKod, nKod )
  If nKod > 0
    nRec := CENZBOZ->( RecNo())
    fOrdRec( { 'CENZBOZ, 8' })
    If lOk := CENZBOZ->( dbSeek( nKod))
      If lValid
        If( lOk := If( nRec == CENZBOZ->( RecNo()), .f., .t. ) )
          drgMsgBox(drgNLS:msg( 'Duplicitní èíslo èárového kódu !'))
        EndIf
      Endif
    Endif
    fOrdRec()
  Endif
  If lValid
    Return( { !lOk, nKod, Nil } )
  Endif
RETURN( nCarkKod )