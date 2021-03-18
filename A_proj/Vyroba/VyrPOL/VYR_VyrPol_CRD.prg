/*==============================================================================
  VYR_VyrPol_CRD.PRG
==============================================================================*/

#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Xbp.ch"
*****************************************************************
*
*****************************************�************************
CLASS VYR_VyrPol_CRD FROM drgUsrClass
EXPORTED:
  VAR     cZakPolSRC, zdrojZAK, zdrojPOL, zdrojVAR

  METHOD  Init, Destroy
  METHOD  drgDialogInit, drgDialogStart
  METHOD  EventHandled
  METHOD  PostValidate
  METHOD  DoSave
  METHOD  VYR_VYRZAK_SEL, VYR_NAKPOL_SEL1, VYR_NAKPOL_SEL2, VYR_VYKRESY_SEL

HIDDEN:
  VAR     dm, dc
  VAR     lNewREC, lCopyREC, lFromNABvys, cPicturPOL
  METHOD  SetCopyREC, CopyKusov, SetCisVPOL

ENDCLASS

********************************************************************************
METHOD VYR_VyrPol_CRD:init(parent)

  ::drgUsrClass:init(parent)
  ::lNewREC     := !( parent:cargo = drgEVENT_EDIT)
  ::lCopyREC    :=  ( parent:cargo = drgEVENT_APPEND2)
  ::lFromNABvys :=  ( parent:parent:formname = "PRO_nabvyshd_cen_SEL" )

  drgDBMS:open('VyrZak'   )
  drgDBMS:open('VyrZakIT' )
  drgDBMS:open('cNazPol2' )
  drgDBMS:open('NAKPOL'   )
  drgDBMS:open('CENZBOZ'  )
  drgDBMS:open('CENZB_ps' )
  drgDBMS:open('C_SKLADY' )
  drgDBMS:open('C_JEDNOT' )
  drgDBMS:open('C_TYPPOL' )
  drgDBMS:open('C_STRED'  )
  drgDBMS:open('VYKRESY'  )
  drgDBMS:open('VP_SET'   )
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('VYRPolDT' )
  drgDBMS:open('VYRPolDTw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('KUSOV'    )
  drgDBMS:open('KUSOVw'   ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('PolOPER'  )
  drgDBMS:open('PolOPERw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  *
  ::cPicturPol := AllTrim( SysCONFIG( 'Vyroba:cPicturPol'))
  *
  IF     ::lCopyREC  ;  ::SetCopyREC()
                        ::cZakPolSRC := Upper( VyrPOL->cCisZakaz) + Upper( VyrPOL->cVyrPol)
                        ::zdrojZAK   := Upper( VyrPOL->cCisZakaz)
                        ::zdrojPOL   := Upper( VyrPOL->cVyrPOL)
                        ::zdrojVAR   := VyrPOL->nVarCIS
  ELSEIF ::lNewREC   ;  VYRPOLw->(dbAppend())
                        *
*                        if ::lFromNABvys
                        if VP_SET->( dbSeek( Upper( Padr(usrName,10))+'1',, 'VP_SET_3'))
                          mh_COPYFLD('VP_set', 'VYRPOLw')
                        endif
                        *
                        VYRPOLw->cVyrPOL :=  ::SetCisVPOL()
                        VYRPOLw->nVarCis := 1
//                        VYRPOLw->cSklPol :=  VYRPOLw->cVyrPOL
                        VYRPOLw->cStav   := 'A'

  ELSE               ;  mh_COPYFLD('VYRPOL', 'VYRPOLw', .T.)
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_VyrPol_CRD:drgDialogInit(drgDialog)

  drgDialog:formHeader:title += IF( ::lCopyREC, ' - KOPIE ...', ' ...' )
RETURN

********************************************************************************
METHOD VYR_VyrPol_CRD:drgDialogStart(drgDialog)

  ::dm := drgDialog:dataManager
  ::dc := drgDialog:dialogCtrl
  *
  IsEditGET( {'VyrPOLw->cNazVyk'  } ,  ::drgDialog, .F. )
  IsEditGET( {'VyrPOLw->cCisZakaz'  ,;
              'VyrPOLw->cVyrPol'    ,;
              'VyrPOLw->nVarCis'  } ,  ::drgDialog, ::lNewREC )
  IF ::lNewRec
    * Nastav�me vzor vyr.polo�ky - pro ��seln� vzor to znamen�, �e znakov� polo�ka
    * se chov� jako numerick� ( lze editovat pouze ��s.�daje)
    ::dm:has('VyrPOLw->cVyrPol'):odrg:oxbp:picture := ::cPicturPOL
  ENDIF
  *
  IF ( 'INFO' $ UPPER( drgDialog:title) .OR. drgDialog:parent:dialogCtrl:isReadOnly )
     drgDialog:SetReadOnly( .T.)
  ENDIF

RETURN self

********************************************************************************
METHOD VYR_VyrPol_CRD:EventHandled(nEvent, mp1, mp2, oXbp)


  DO CASE

  CASE  nEvent = drgEVENT_SAVE
    ::DoSave()
    RETURN .T.
   * PostAppEvent(xbeP_Close, nEvent,,oXbp)
  /*
     IF ::DoSave( .T., ::lNewREC )
        ::drgDialog:DataManager:save()
        ::DoSave( .F., ::lNewREC )
        PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
     ENDIF
  */
  * Ukon�it bez ulo�en�
  CASE nEvent = drgEVENT_EXIT .OR. nEvent = drgEVENT_QUIT
    PostAppEvent(xbeP_Close,nEvent,,oXbp)

  CASE nEvent = xbeP_Keyboard
    DO CASE
    * Ukon�it bez ulo�en�
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
METHOD VYR_VyrPol_CRD:PostValidate( oVar)
  LOCAL  xVar := oVar:get()
  LOCAL  lChanged := oVar:Changed(), lOK := .T.
  LOCAL  lValid := ( ::lNewREC .or. lChanged ), lKeyFound
  LOCAL  cNAMe := UPPER(oVar:name), cFILe := drgParse(cNAMe,'-'), cKey, cTag
  LOCAL mp1, mp2, oXbp, nEvent

  nEvent := LastAppEvent( @mp1,@mp2,@oXbp)

  IF lValid
    DO CASE
    CASE cName = 'VYRPOLW->CCISZAKAZ'
      IF !EMPTY(xVar)
        lKeyFound := VYRZAK->(dbSEEK( Upper( xVar),, 'VYRZAK1'))
        lOK := ::VYR_VYRZAK_SEL( self, lKeyFound )
      ENDIF
      cKey := Upper( ::dm:get('VYRPOLw->cCisZakaz')) + Upper( ::dm:get('VYRPOLw->cVyrPOL')) + ;
              StrZero( ::dm:get('VYRPOLw->nVarCis'), 3)
      If lOK := VyrPol->( dbSeek( cKey,,'VYRPOL1'))
         drgMsgBox(drgNLS:msg('DUPLICITA -  Vyr�b�n� polo�ka < & > ji� existuje v t�to variant� !;' + ;
                              '             N�zev : & ', VyrPol->cVyrPol, VyrPol->cNazev ), XBPMB_WARNING )
      ELSE
        lOK := .T.
      Endif
     * lOK := !lOK
    /*
    CASE cName = 'VYRPOLW->CVYRPOL'
      lOK := ::VYR_NAKPOL_SEL1()
    */
    CASE cName = 'VYRPOLW->NVARCIS'
      IF lOK := ControlDUE( oVar)
        cKey := Upper( ::dm:get('VYRPOLw->cCisZakaz')) + Upper( ::dm:get('VYRPOLw->cVyrPOL')) + ;
                StrZero( ::dm:get('VYRPOLw->nVarCis'), 3)
        If lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
           drgMsgBox(drgNLS:msg('DUPLICITA -  Vyr�b�n� polo�ka < & > ji� existuje v t�to variant� !;' + ;
                                '             N�zev : & ', VyrPol->cVyrPol, VyrPol->cNazev ), XBPMB_WARNING )
        Endif
        lOK := !lOK
      ENDIF

    CASE cName = 'VYRPOLW->CSKLPOL'
      if .not. ::lFromNABvys
        lOK := ::VYR_NAKPOL_SEL2()
      endif

    CASE cName = 'VYRPOLW->CCISSKLAD'
      IF lOK := ControlDUE( oVar)
        cKEY := Upper( ::dm:get('VYRPOLw->cCisSklad')) + Upper( ::dm:get('VYRPOLw->cSklPol'))
        IF !( lOK := NakPOL->( dbSEEK( cKEY,, 'NAKPOL3')) )
          if .not. ::lFromNABvys
            drgMsgBox(drgNLS:msg('Nenalezena polo�ka s kl��em  SKLAD = [ & ] + SKL.POLO�KA = [ & ] !',;
                                 ::dm:get('VYRPOLw->cCisSklad'), ::dm:get('VYRPOLw->cSklPol')  ), XBPMB_WARNING )
          endif
          lOK := .T.
          oVar:oDrg:oXbp:undo()
        ENDIF
         ENDIF

    CASE cName $ 'VYRPOLW->CVYRPOL, VYRPOLW->CSKLPOL, VYRPOLW->CTYPPOL, VYRPOLW->CZKRATJEDN, VYRPOLW->CSTRVYR'
*      lOK := ControlDUE( oVar)
      IF Empty(xVar)
         PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( cName):oDrg:oXbp )
       ENDIF
      /*
      KOVAR - z povinn�ch �daj� bylo vyjmuto st�edisko - VYRPOLW->CNAZPOL2  // 22.8.2007
      */
    CASE cName = 'VYRPOLW->CCISVYK'
//      lOK := ::VYR_VYKRESY_SEL()

    ENDCASE
  ENDIF

RETURN lOK

********************************************************************************
METHOD VYR_VyrPol_CRD:DoSave(isBefore, isAppend)       // onsave
  LOCAL lOK, cKey, aZakIT := {}

  IF ! ::dc:isReadOnly
    ::dm:save()
    *
    IF ::lNewRec
      cKey := Upper( VYRPOLw->cCisZakaz) + Upper( VYRPOLw->cVyrPOL) + ;
              StrZero( VYRPOLw->nVarCis, 3)
      IF lOK := VyrPol->( dbSeek( cKey,, 'VYRPOL1'))
         drgMsgBox(drgNLS:msg('DUPLICITA -  Vyr�b�n� polo�ka < & > ji� existuje v t�to variant� !;' + ;
                              '             N�zev : & ', VyrPol->cVyrPol, VyrPol->cNazev ), XBPMB_WARNING )
         RETURN .T.
      ENDIF
    ENDIF
    *
    IF ( lOK := If( ::lNewREC, AddREC('VyrPOL'), ReplREC('VyrPOL')) )
      mh_COPYFLD( 'VYRPOLw', 'VYRPOL')
      VYRPOL->cCisZakaz := ::dm:get( 'VYRPOLw->cCisZakaz')
      VYRPOL->cVyrPOL   := ::dm:get( 'VYRPOLw->cVyrPOL'  )
      VYRPOL->cNazev    := ::dm:get( 'VYRPOLw->cNazev'   )
      VYRPOL->nVarCis   := ::dm:get( 'VYRPOLw->nVarCis'  )
      VYRPOL->cVarPop   := ::dm:get( 'VYRPOLw->cVarPop'  )
      VYRPOL->cNazPol2  := ::dm:get( 'VYRPOLw->cNazPol2' )
      VYRPOL->nStavKalk := -1       // aktu�ln� kalkulace
      VyrPol->nZakazVP  := VYR_ZakazVP( VyrPol->cCisZakaz)
      *
      IF( ::lCopyREC, ::CopyKUSOV(),  NIL )
      *
      * Pokud existuje pro zak�zkovou vyr.polo�ku ve VyrZak zalo�en� zak�zka,
      * pak se zkontroluje vypln�n� cVyrPol a p��padn� se dopln� do VyrZak a VyrZakIT
      * Udelame na parametr - chce to tak jen KOVAR
      IF ::lNewRec  // .and. CFG_parametr_nejaky
        cKey := Upper( VYRPOL->cCisZakaz)// + Upper( VYRPOL->cVyrPol) + StrZero( VYRPOL->nVarCis, 3)
        IF VYRZAK->( dbSeek( cKey,, 'VYRZAK1')) .and. EMPTY( VYRZAK->cVyrPol)
          VyrZakIT->( AdsSetOrder( 1),;
                      mh_SetScope( Upper( VyrZak->cCisZakaz)) )
          DO WHILE !VyrZakIT->( Eof())
            IF EMPTY( VyrZakIT->cVyrPol)
              AADD( aZakIT, VyrZakIT->( RecNO()) )
            ENDIF
            VyrZakIT->( dbSkip())
          ENDDO
          VyrZakIT->( mh_ClrScope())
          lOK := IF( Len( aZakIT) = 0, .T., VyrZakIT->( sx_RLock( aZakIT)) )
          IF VyrZak->( dbRLock()) .AND. lOK
            VyrZak->cVyrPol := VyrPol->cVyrPol
            FOR n := 1 TO LEN( aZakIT)
              VyrZakIT->( dbGoTO( aZakIT[ n]) )
              VyrZakIT->cVyrPOL := VyrPol->cVyrPol
            NEXT
            VyrZak->( dbUnlock())
            VyrZakIT->( dbUnlock())
          ENDIF
        ENDIF
      ENDIF
      *
      VyrPOL->( dbUnlock())
      * je-li karta VYRPOL zakl�d�na z nab�dek vystaven�ch =>
      if ::lFromNABvys
        cKey := Upper( VyrPOL->cCisSklad) + Upper( VyrPol->cSklPol)
        if CenZBOZ->( dbSeek( cKey,, 'CENIK03'))
        else
          drgDBMS:open('C_BCD')
          mh_COPYFLD( 'VYRPOL', 'CenZBOZ', .T. )
          CENZBOZ->cNazZBO    := VYRPOL->cNazev
          CENZBOZ->cTypSklPol := 'U'  // U = Materi�l nebo zbo�� // ::cKodTPV
          CENZBOZ->cTypSklCen := 'PEV'  // Upper( SysCONFIG('Sklady:cTypCeny'))
          CENZBOZ->nKlicDph   := VAL( SysCONFIG('Finance:cZaklDph') )
          CENZBOZ->cPolCen    := SysCONFIG('Sklady:cPolCen')
          CENZBOZ->cZkratJedn := SysCONFIG('Sklady:cZaklJedn')
          CENZBOZ->cZkratMeny := SysCONFIG('Finance:cZaklMena')
          CENZBOZ->nTypGenBCD := SysCONFIG('Sklady:nTypGenBcd')
          CENZBOZ->cCarKod    := GenBarCod()
          CENZBOZ->cVyrCis    := ' ' // = neevidovat     acVyrCis[ GetCFG( 'cTypVyrCis')]
          CENZBOZ->cKatalCis  := 'N'
          CENZBOZ->lAktivni   := .T.
          CenZBOZ->( dbUnlock())
          *
          SKL_NakPOL_MODI( CENZBOZ->cTypSklPol)
          *
          * Z�pis do souboru po�.stav�
          mh_COPYFLD( 'CenZBOZ', 'CenZB_ps', .T.)
          CenZB_ps->nROK := uctOBDOBI:SKL:nRok

        endif
      endif
      *
      PostAppEvent(xbeP_Close, drgEVENT_QUIT,, ::drgDialog:dialog)
    ELSE
      drgMsgBox(drgNLS:msg('Nelze modifikovat, z�znam je blokov�n jin�m u�ivatelem !'))
    ENDIF
  ENDIF
RETURN .T.

* V�b�r v�robn� zak�zky do karty vyr�b�n� polo�ky
********************************************************************************
METHOD VYR_VyrPol_CRD:VYR_VYRZAK_SEL( Dialog, KeyFound)
  LOCAL oDialog, nExit, lOK := .F.

  DEFAULT KeyFound TO .F., lOK TO .F.
  IF !KeyFound
    DRGDIALOG FORM 'VYR_VYRZAK_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
    ::drgDialog:oForm:setNextFocus( 'VYRPOLw->cCisZakaz',, .t. )
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. KeyFound )
    lOK := .T.
    ::dm:set('VYRPOLw->cCisZakaz', VYRZAK->cCisZakaz)
    IF !::lCopyREC
      ::dm:set('VYRPOLw->cVyrPol'  , VYRZAK->cVyrPol  )
      ::dm:set('VYRPOLw->nVarCis'  , VYRZAK->nVarCis  )
    ENDIF
    ::dm:refresh()
  ENDIF

RETURN lOK

* V�b�r skladov� polo�ky do vyr�b�n� polo�ky v kart� vyr�b�n� polo�ky
********************************************************************************
METHOD VYR_VyrPol_CRD:VYR_NAKPOL_SEL1( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('VyrPOLw->cVyrPol'))
  LOCAL lOK := ( !Empty(value) .and. NAKPOL->( dbSEEK( Value,, 'NAKPOL1')) )
  Local nRec := if( lOk, NakPOL->( RecNO()), NIL)

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_NAKPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit CARGO_USR nRec
    ::drgDialog:oForm:setNextFocus( 'VYRPOLw->cVyrPOL',, .t. )
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set('VYRPOLw->cVyrPol'   , NAKPOL->cSklPol    )
    ::dm:set('VYRPOLw->cNazev'    , NAKPOL->cNazTpv    )
    ::dm:set('VYRPOLw->cSklPol'   , NAKPOL->cSklPol    )
    ::dm:set('VYRPOLw->cZkratJedn', NAKPOL->cZkratJedn )
    ::dm:set('VYRPOLw->cCisSklad' , NAKPOL->cCisSklad  )
    ::dm:refresh()
    IsEditGET( 'VYRPOLw->cNazev', ::drgDialog, .F. )
  ENDIF

RETURN lOK

* V�b�r skladov� polo�ky do skladov� polo�ky v kart� vyr�b�n� polo�ky
********************************************************************************
METHOD VYR_VyrPol_CRD:VYR_NAKPOL_SEL2( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('VyrPOLw->cSklPol'))
  LOCAL lOK := ( !Empty(value) .and. NAKPOL->( dbSEEK( Value,, 'NAKPOL1')) )
  Local nRec := if( lOk, NakPOL->( RecNO()), NIL)

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_NAKPOL_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit CARGO_USR nRec
*    ::drgDialog:oForm:setNextFocus( 'VYRPOLw->cSklPOL',, .t. )
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set('VYRPOLw->cSklPol'   , NAKPOL->cSklPol    )
    ::dm:set('VYRPOLw->cCisSklad' , NAKPOL->cCisSklad  )
    ::dm:refresh()
  ENDIF
RETURN lOK

* V�b�r v�kresu do karty vyr�b�n� polo�ky
********************************************************************************
METHOD VYR_VyrPol_CRD:VYR_VYKRESY_SEL( oDlg)
  LOCAL oDialog, nExit
  LOCAL Value := Upper( ::dm:get('VyrPOLw->cCisVyk'))
  LOCAL lOK :=( !Empty(value) .and. VYKRESY->( dbSEEK( Value,, 'VYKRES1')) )

  IF IsObject( oDlg) .or. ! lOk
    DRGDIALOG FORM 'VYR_VYKRESY_SEL' PARENT ::drgDialog  MODAL DESTROY ;
                                    EXITSTATE nExit
  ENDIF

  IF ( nExit != drgEVENT_QUIT  .or. lOK )
    lOK := .T.
    ::dm:set('VYRPOLw->cCisVYK', VYKRESY->cCisVYK)
    ::dm:set('VYRPOLw->cNazVYK', VYKRESY->cNazVYK)

    if ::lNewRec .and. .not. empty(VYKRESY->cNazVYK)
      ::dm:set('VYRPOLw->cNazev' , VYKRESY->cNazVYK)
    endif

    ::dm:refresh()
  ENDIF

RETURN lOK

* P�ednastaven� numerick�ho ��sla vyr. polo�ky
**HIDDEN************************************************************************
METHOD VYR_VyrPol_CRD:SetCisVPOL()
  Local xRET := ''
  Local N, cPicturNUM := '', nLenPict := LEN( ::cPicturPOL), nMAX := 0

  drgDBMS:open('VyrPOL'  ,,,,, 'VyrPOLa'  )
  FOR N := 1 TO nLenPict
    cPicturNUM += '9'
  NEXT
  IF ::cPicturPOL == cPicturNUM
    *  Pro ��s. vzory p�ednastavujeme o 1 vy���
    VyrPOLa->( AdsSetOrder( 0), dbGoBOTTOM())
    VyrPOLa->( dbEVAL( {|| nMAX := MAX( nMAX, VAL( VyrPOLa->cVyrPOL))  }))
    xRet := PADR( ALLTRIM( STR( nMAX + 1, nLenPict )), nLenPict, ' ' )
  ENDIF
  VyrPOLa->( dbCloseArea())
RETURN xRET

**HIDDEN************************************************************************
METHOD VYR_VyrPol_CRD:SetCopyREC()
  LOCAL nPos, aFld
  LOCAL cFld := 'cCisZakaz,cVyrPOL,cNazev,nVarCis,cVarPop,cNazPol2,cSklPol,' + ;
                'cCisSklad,cTypPol,cZkratJedn,cStrVyr,nEkDav,cCisVyk,'  + ;
                'cStav,mPopisVP'

  aFld :=  ListAsArray( cFld)
  VyrPOLw->( DbAppend())
  aEVAL( aFld, { |X,i| ;
                ( nPos := VyrPOL->( FieldPos( X))             , ;
                If( nPos <> 0, VyrPOLw->( FieldPut( nPos, VyrPOL->( FieldGet( nPos)) )), Nil ) ) } )
RETURN NIL

**HIDDEN************************************************************************
METHOD VYR_VyrPol_CRD:CopyKusov()

  VYR_VyrPOL_cpy( NIL, ::zdrojZAK   , ::zdrojPOL      , ::zdrojVAR     ,;
                  VyrPOL->cCisZakaz , VyrPOL->cVyrPol , VyrPOL->nVarCis,;
                  .F., .F. )

RETURN NIL

********************************************************************************
METHOD VYR_VyrPol_CRD:destroy()
  ::drgUsrClass:destroy()
  ::lNewREC := ::lCopyREC := cZalPolSrc :=  ;
  ::dm    := dc  :=  ;
  ::cPicturPol  := ;
                    Nil
RETURN self


*  Zru�en� vyr�b�n� polo�ky
*===============================================================================
FUNCTION VyrPOL_OnDelete()
  Local  cTag, cKey := Upper( VyrPOL->cCisZakaz) + Upper( VyrPOL->cVyrPol)
  Local  lOK, lMore, nVarCis := VyrPOL->nVarCis

*  drgMsgBox(drgNLS:msg('DelVyrPOL'))

  FOrdREC( { 'Kusov, 2' } )
  IF( lOK := Kusov->( dbSEEK( cKey) ) )   // !!!
    drgMsgBox(drgNLS:msg( ;
      'Polo�ku < & > nelze zru�it, nebo� je obsa�ena v platn�m kusovn�ku !', VYRPOL->cVyrPOL), XBPMB_CRITICAL )
    FOrdREC()
    RETURN NIL
  ENDIF

  IF drgIsYesNO(drgNLS:msg('Skute�n� zru�it vyr�b�nou polo�ku < & > ?', VYRPOL->cVyrPOL ))
      * Zru�� se vazby na ni��� polo�ky
      cTag := Kusov->( AdsSetOrder( 4))
      KUSOV->( mh_SetScope( cKEY))
      lMore := MoreVyrPOL()
      DO WHILE !Kusov->( EOF())
        IF lMore  ;  IF VyrPol->nVarCis == Kusov->nVarPoz
                        DelREC( 'Kusov')
                     ENDIF
        ELSE      ;  DelREC( 'Kusov')
        ENDIF
        Kusov->( dbSKIP())
      ENDDO
      KUSOV->( mh_ClrScope())

      * Zru�� se operace definovan�  k vyr�b�n� polo�ce
      cTag := PolOPER->( AdsSetOrder( 1))
      PolOPER->( mh_SetScope( cKEY))

      DO WHILE PolOPER->( dbSEEK( cKey))
        DelREC( 'PolOPER')
      ENDDO

      PolOPER->( mh_ClrScope(), AdsSetOrder( cTag) )

      * Zru�� se detail vyr�b�n� polo�ky
      IF VyrPolDT->( dbSEEK( cKey + StrZERO( nVarCis, 3)))
        DelREC( 'VyrPolDT')
      ENDIF
      * Modifikuje se VyrZAK a VyrZAKIT
      IF !EMPTY( VyrPOL->cCisZakaz)
        drgDBMS:open('VyrZak'   )
        drgDBMS:open('VyrZakIT' )
        IF VyrZAK->( dbSEEK( cKey,, 'VYRZAK1'))
          IF drgIsYesNO(drgNLS:msg('Po�adujete odpojit vyr�b�nou polo�ku [ & ] od zak�zky [ & ] ?', VYRPOL->cVyrPOL, VyrZAK->cCisZakaz ))
            IF VyrZAK->( dbRLock())
               VyrZAK->cVyrPol := ''
*               VyrZAK->nVarCis := 0
               VyrZAK->( dbRUnLock())
            ENDIF
            *
            VyrZakIT->( AdsSetOrder( 1) ,;
                        mh_SetScope( Upper( VyrPOL->cCisZakaz)) )

            DO WHILE ! VyrZakIT->( EOF())
              IF VyrZAKIT->( dbRLock())
                 VyrZAKIT->cVyrPol := ''
*                 VyrZAKIT->nVarCis := 0
                 VyrZAKIT->( dbRUnLock())
              ENDIF
              VyrZakIT->( dbSkip())
            ENDDO
          ENDIF
        ENDIF
      ENDIF
      * Zru�� se vyr�b�n� polo�ka
      DelREC( 'VyrPOL')
  ENDIF
  FOrdREC()

RETURN Nil

* Zjist� existenci stejn� vyr�b�n� polo�ky, ale v jin� variant�
*===============================================================================
STATIC FUNCTION MoreVyrPol()
  Local lMore := FALSE
  Local nRec := VyrPOL->( RecNo()), nVarCis := VyrPOL->nVarCis
  Local cVyrPol := Upper( VyrPOL->cCisZakaz) + Upper( VyrPOL->cVyrPol)

  VYRPOL->( mh_SetScope( cVyrPol))
  VyrPOL->( dbEVAL( {|| lMore := If( VyrPOL->nVarCis == nVarCis, lMore, TRUE) }))
  VyrPOL->( mh_ClrScope(), dbGoTO( nRec))
RETURN( lMore)
