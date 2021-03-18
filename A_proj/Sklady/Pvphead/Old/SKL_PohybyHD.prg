
#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "gra.Ch"
#include "..\SKLADY\SKL_Sklady.ch"

#define   dokl_isULOZEN       0
#define   dokl_isROZPRAC      1


********************************************************************************
CLASS SKL_POHYBYHD FROM drgUsrClass, SKL_POHYBY_Main, WDS, SKL_datainfo
EXPORTED:
  *
  ** napojení na WDS
  var     hd_file, it_file
  var     cisSklad, sklPol

  VAR     parentFRM
  VAR     naz_mainSklad, naz_mainPohyb, naz_Doklad, naz_DokladPol
  VAR     varsORG, membORG
  VAR     dc, dm, df, broIT, abMembers
  VAR     LastCislObInt, dokl_inSTAV
  *
  METHOD  Init, Destroy, drgDialogStart,drgDialogEnd, itemMarked
  METHOD  eventHandled, postValidate
  METHOD  modiCard

  METHOD  Sklad_sel, TypPohybu_sel, SKL_VyrZak_sel, SKL_Firmy_sel, SKL_ObjHead_sel

  METHOD  LastFieldHD, sumColumn
  METHOD  SaveDoklad, set_SaveBut

  METHOD  btn_VYROBCIS

  *
  inline access assign method naz_mainSklad()  var naz_mainSklad
      c_Sklady->( dbSeek( if(isnull(::mainSklad),'', alltrim(::mainSklad) ),, 'C_SKLAD1'))
      return c_Sklady->cNazSklad

  inline access assign method naz_mainPohyb()  var naz_mainPohyb
      C_TypPOH->( dbSEEK( S_DOKLADY + if(isnull(::mainPohyb), '', alltrim(::mainPohyb)),, 'C_TYPPOH02'))
      return C_TypPOH->cNazTypPoh

  inline access assign method naz_Doklad()  var naz_Doklad
    Local aDoklad  := { 'Pøíjemka', 'Výdejka', 'Pøevodka', 'Pøecenìní', '???' }
    Local aDoklPol := { 'pøíjemky', 'výdejky', 'pøevodky', 'pøecenìní', '???' }
    Local nPohyb   := Val( Left( Alltrim( Str(::nKarta)), 1)),  cRet

    nPohyb          := If( nPohyb < 1 .or. nPohyb > 4, 5, nPohyb )
    ::Naz_DokladPol := 'Položka ' + aDoklPol[ nPohyb]
    cRet            := aDoklad[ nPohyb]
  return cRet

  inline method Cenik_TiskCarKodu()
    local  odialog, nexit := drgEVENT_QUIT, ok := .t.

    odialog := drgDialog():new('SKL_PRNcarKODw_IN',::drgDialog)
    odialog:create(,,.T.)
    nexit := odialog:exitState
  return self

HIDDEN:
  VAR     nRecIT, cTagIT
  METHOD  SaveCardHD, sklParSymbol, DodIsZahr, BackToPVPTerm

ENDCLASS

********************************************************************************
METHOD SKL_POHYBYHD:init(parent)
  local odecs, len_cnazPol3

  *
  ::drgUsrClass:init(parent)
  ::SKL_POHYBY_Main:init(parent)
  *
  ::newHD := !( parent:cargo = drgEVENT_EDIT)
  ::parentFRM := parent:parent:formName
  *
  drgDBMS:open('CENZBOZ' )
  drgDBMS:open('CENZBOZ',,,,,'cenZboz_80' )

  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('TYPDOKL' )
  drgDBMS:open('OBJHEAD' )
  drgDBMS:open('OBJITEM' )
  drgDBMS:open('OBJVYSHD')
  drgDBMS:open('OBJVYSIT')
  drgDBMS:open('DODZBOZ' )
  drgDBMS:open('DODLSTHD')
  drgDBMS:open('VYRCIS'  )
  drgDBMS:open('C_UCTSKP')
  drgDBMS:open('UCETSYS' )
  *
  drgDBMS:open('vyrZakit')
  *
  *
  If ::newHD
    C_TypPoh->(dbseek(S_DOKLADY + ::mainPohyb,,'C_TYPPOH02'))
    ::nKarta := CoalesceEmpty( C_TypPOH->nKarta, VAL( Right( Alltrim(C_TypPOH->cTypDoklad),3)))
  Else
    ::mainSklad := PVPHead->cCisSklad
    ::mainPohyb := PVPHead->cTypPohybu
    ::nKarta    := PVPHead->nKarta
  EndIf
  ::nKarta := IF( ::nKarta = 0, 999, ::nKarta )
  ::Naz_Doklad()


  ::skl_datainfo:init('pvpHeadW', 'pvpItemWW', ::NEWhd )  
  skl_pvpHead_cpy(self)
  *
  ** bude se mìnit cnazPol3 z C8 -> C36
  odesc := drgDBMS:getFieldDesc('pvpitem', 'cnazPol3')
  len_cnazPol3 := odesc:len

  ::cNazPol1 := ::cNazPol2 := ::cNazPol3 := ::cNazPol4 := ::cNazPol5 := ::cNazPol6 := SPACE(8)
  ::cnazPol3 := space(len_cnazPol3)
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:drgDialogStart(drgDialog)

  *
  ::dc      := drgDialog:dialogCtrl
  ::dm      := drgDialog:dataManager
  ::df      := drgDialog:oForm
  ::broIT   := drgDialog:odBrowse[1]
  ::membORG := ::dc:members[1]:aMembers
  ::varsORG := ::dm:vars
  ::abMembers := drgDialog:oActionBar:Members
  *
  *
  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  SEPARATORs( ::abMembers)
  *
  ::selectCard()
  ::modiCard()
  *
  IF ::parentFRM = 'skl_pvpitem_scr'
    ::nRecIT := PVPItem->( RecNo())
    ::cTagIT := PVPItem->( AdsSetOrder( 'PVPITEM02'))
    PVPITEM->( mh_SetScope( Upper( PVPHEAD->cCisSklad) + StrZERO(PVPHEAD->nDoklad,10)))
  ENDIF

  If ::newHD
    ::df:setNextFocus( 'M->mainSklad')
  Else
    C_TypPoh->(dbseek(S_DOKLADY + ::mainPohyb,,'C_TYPPOH02'))

    ::broIT:oXbp:refreshAll()
    SetAppFocus(::broit:oxbp)
    ::set_SaveBut( 0)
  EndIf
  *
  ::sumColumn()
  ::dm:has('PVPHEADw->nRozPrij' ):oDrg:oXbp:setColorFG( IF( PVPHEADw->nRozPrij = 0, GRA_CLR_BLACK, GRA_CLR_RED) )
  * Zjistí, zda jede o Tuzemský nebo Zahranièní DL
  ::DodIsZahr()
  *
  ::dm:refresh()
  *
  ** napojení na WDS
  ::cisSklad   := ::dm:get( 'M->mainSklad'     , .f.)
  ::sklPol     := ::dm:get(::it +'->csklPol'   , .f.)

  ::hd_file := ::hd
  ::it_file := ::it

  ::wds_connect(self)

  ::cwds_itmnoz     := 'nmnozPRdod'
  ::cwds_itmnoz_org := 'nmnozP_org'
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:drgDialogEnd(drgDialog)
  *
  IF ::dokl_inSTAV = dokl_isROZPRAC
    ::BackToPVPTerm( .t.)
    SKL_VyrCis_MODI( xbeK_DEL, .T. )
  ENDIF
  *
  PVPHEAD->( DbSetRelation( 'C_TypPoh', { || UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU) },;
                                            'UPPER(PVPHEAD->CULOHA)+UPPER(PVPHEAD->CTYPPOHYBU)', 'C_TYPPOH06'))
  PVPITEM->( DbSetRelation( 'C_DPH', { || PVPITEM->nKlicDPH },'PVPITEM->nKlicDPH'))
  *
  IF ::parentFRM = 'skl_pvphead_scr'
    PVPITEM->( AdsSetOrder( 'PVPITEM02' ))
  ELSEIF ::parentFRM = 'skl_pvpitem_scr'
    PVPITEM->( mh_ClrScope(), AdsSetOrder( ::cTagIT), dbGoTo( ::nRecIT))
  ENDIF

  drgDialog:parent:odBrowse[1]:refresh()

  ::wds_disconnect()
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:eventHandled(nEvent, mp1, mp2, oXbp)
  Local nKey

  DO CASE
    CASE nEvent = drgEVENT_APPEND
      IF  Skl_allOK( .T. ,, ::HD, ::IT )
        RETURN .F.
      ENDIF
    CASE nEvent = drgEVENT_EDIT
      if .T.               // Skl_allOK( ,, ::HD, ::IT )
        RETURN .F.
      ELSE
        SetAppFocus(::broIT:oXbp)
      ENDIF

    CASE nEvent = drgEVENT_DELETE
      if (::IT)->_nrecor = 0
        if drgIsYESNO(drgNLS:msg('Zrušit položku dokladu èíslo... < & > ?', (::HD)->nDOKLAD))
          (::IT)->_delrec := '9'
          ::BackToPVPTerm()
          SKL_VydejDKP_SAVE( xbeK_DEL )
          SKL_VYRCIS_MODI( xbeK_DEL)

          ::hd_udcp:nwds_sign := (::it)->ntypPoh
          ::wds_postDelete()

          (::IT)->( dbSkip(-1))
        endif

      elseif Skl_allOK( ,, ::HD, ::IT )

        if (::HD)->cTypDoklad = 'SKL_PRE305' .and. (::HD)->cTypPohybu = '40'
           drgMsgBox(drgNLS:msg( 'NELZE ZRUŠIT !;;'+ ;
                                'Pohyb 40 je rušen automatizovanì pøi rušení pohybu 80 - pøevod mezi støedisky !'), XBPMB_CRITICAL )

        ElseIF (::HD)->cTypDoklad = 'SKL_CEN400'
           drgMsgBox(drgNLS:msg( 'NELZE ZRUŠIT !;;'+ ;
          'S dokladem o pøecenìní již nelze manipulovat !'), XBPMB_CRITICAL )

        elseif drgIsYESNO(drgNLS:msg( ;
                          'Zrušit položku dokladu èíslo... < & > ?', (::HD)->nDOKLAD))
          (::IT)->_delrec := '9'
          ::BackToPVPTerm()
          SKL_VydejDKP_SAVE( xbeK_DEL )
          SKL_VYRCIS_MODI( xbeK_DEL)
          (::IT)->( dbGoTop())
          ::set_SaveBut( dokl_isROZPRAC)

        endif
      endif
      NutneVN()
      ::sumColumn()
      ::dm:has('PVPHEADw->nRozPrij' ):oDrg:oXbp:setColorFG( IF( PVPHEADw->nRozPrij = 0, GRA_CLR_BLACK, GRA_CLR_RED) )
      ::broIT:oXbp:refreshAll()
      *
      DokladHasItem( ::newHD, ::IT, ::drgDialog )

    CASE nEvent = drgEVENT_EXIT
       ::saveDoklad()
       PostAppEvent(xbeP_Close, nEvent,,oXbp)

    CASE nEvent = drgEVENT_SAVE
      IF oXbp:ClassName() $ 'XbpBrowse, XbpStatic'
        * ULOŽIT CELÝ DOKLAD
        ::saveDoklad()
      ELSE
        * ULOŽIT HLAVIÈKU a vynést do polož. karty
        nKey := IF( Empty( (::HD)->dVznikZazn) .or. Empty( (::IT)->dVznikZazn),;
                    xbeK_INS, xbeK_ENTER)
        ::SaveCardHD( nKey)
        *
        IF nKey = xbeK_INS
          SetAppFocus(::broIT:oXbp)
          ::drgDialog:oForm:oLastDrg := ::broIT
          ::drgDialog:LastXbpInFocus := ::broIT:oXbp
          PostAppEvent(drgEVENT_APPEND,,, ::broIT:oXbp)
          RETURN .F.
        ELSE
          SetAppFocus(::broIT:oXbp)
        ENDIF
        *
      ENDIF


    CASE nEvent = xbeP_Keyboard .or. nEvent = xbeP_Close
      if( nEvent = xbeP_Close, mp1 := xbeK_ESC, nil )

      DO CASE
        CASE mp1 = xbeK_ESC
          If  ::dokl_inSTAV = dokl_isROZPRAC
            IF drgIsYesNO(drgNLS:msg('Doklad je rozpracován - chcete ukonèit práci (zmìny nebudou uloženy) ?'))
              * Vrátíme PVPTerm ( pro všechny záznamy)
              ::BackToPVPTerm( .t.)
              SKL_VydejDKP_SAVE( xbeK_DEL, .T. )
              SKL_VyrCis_MODI( xbeK_DEL, .T. )
              RETURN .F.
            ENDIF
          Else
            RETURN .F.
          EndIf

      OTHERWISE
        RETURN .F.
      ENDCASE

      CASE nEvent = xbeM_LbClick
        IF oXbp:ClassName() = 'XbpGet'
          IF !::newHD .and.  oXbp:cargo:isEdit
            PostAppEvent(drgEVENT_EDIT,,, oXbp)
          ENDIF
        ENDIF
        RETURN .F.

    OTHERWISE
      RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_PohybyHD:ItemMarked()
  Local cKey := Upper( (::IT)->cCisSklad) +  Upper( (::IT)->cSklPol)
  Local x, oActions := ::drgDialog:oActionBar:members

  CenZboz->( dbSeek( cKey,,'CENIK03'))
  PVPItem->( dbGoTo( (::IT)->_nrecor ))
  *
  for x := 1 to len(oActions)
    IF  oActions[x]:event = 'btn_vyrobcis'
      IF( empty( CenZBOZ->cVyrCis), oActions[x]:oXbp:disable(), oActions[x]:oXbp:enable() )

      oActions[x]:oXbp:setColorFG( If( empty( CenZBOZ->cVyrCis), GraMakeRGBColor({128,128,128}),;
                                                                 GraMakeRGBColor({0,0,0})))
    ENDIF
  next
RETURN self

********************************************************************************
METHOD SKL_PohybyHD:postValidate( oVar)
  Local lOK := .T., Ret
  Local value := oVar:value, name := oVar:name
  Local always := 'ddatpvp' $ lower( name)
  Local lValid := (::newHD .or. oVar:changed() .or. always ), cKey, aKurz

  If lValid
    Do Case
    Case ( name = 'M->mainSklad' )
      lOk := ::Sklad_sel()

    Case ( name = 'M->mainPohyb' )
      lOk := ::TypPohybu_sel()

    Case ( name = ::HD +'->nDoklad' )
      IF !(lOK := ::CisDoklad_skl( Value) )
        ::drgDialog:oForm:setNextFocus( name,,.T.)
      ENDIF
      DO CASE
      CASE ( nPos := ASCAN( { 253,263,244,293 }, ::nKARTA)) > 0
        ::dm:set(::HD + '->nCisloDL', SKL_NewDODLI( 'DODLS')  )
      ENDCASE
    *
    Case ( name = ::HD + '->dDatPVP' )
      IF EMPTY( Value)
        ClickDate(::drgDialog)
      ENDIF
      lOk := ( YEAR( value) = uctObdobi:SKL:nROK .and. MONTH( value) = uctObdobi:SKL:nOBDOBI)
      if !lOk
        drgMsgBox(drgNLS:msg( 'Datum poøízení je mimo aktuální období !'))
        lOK := .T.
      endif
    */
    Case ( name = ::HD + '->nCisFirmy' )
      lOK := ::Skl_Firmy_sel()

    Case ( name = ::HD + '->cCisZakaz' )
      lOK := ::Skl_VyrZak_sel()

    Case ( name = ::HD + '->cCislObInt' )
      If ::nKarta = 274
        lOK := ::Skl_ObjHead_sel()
      EndIf

    Case ( name = ::HD + '->cVarSym' )
      IF !::newHD
        drgDBMS:open('UCETSYS',,,,, 'UCETSYSa')
        IF UCETSYSa->( dbSeek( 'U' + StrZero( (::HD)->nROK, 4) + StrZero( (::HD)->nOBDOBI, 2),, 'UCETSYS3') )
          IF UCETSYSa->lZavren
            drgMsgBox(drgNLS:msg('Variabilní symbol nelze zmìnit, nebo období [ & ] je již v úèetnictví uzavøeno ...', (::HD)->cOBDOBI ))
            ::dm:set(::HD + '->cVarSym', oVar:prevValue  )
            lOK := .F.
          ENDIF
        ENDIF
      ENDIF

    Case ( name = ::HD + '->nCisFak' )
      lOK := ::sklParSymbol( oVAR)

    Case ( name = ::HD + '->nCisloDL')
      lOK := ::sklParSymbol( oVAR)
      IF lOK .and. ( LEFT( ALLTRIM(STR( ::nKARTA)), 1) == PRIJEM )
        cKEY := PRIJEM + StrZERO( ::dm:get(::HD + '->nCisFirmy'), 5) + StrZERO( value,10)
        drgDBMS:open('PVPHEAD' ,,,,, 'PVPHEADa' )
        IF PVPHEADa->( dbSeek( cKey,,'PVPHEAD13')) .and. value <> 0
           drgMsgBox(drgNLS:msg('K dodavateli [ & ], již existuje dodací list èíslo [ & ] ...', ::dm:get(::HD + '->nCisFirmy'), value  ))
        ENDIF
      ENDIF
      *
      IF lOK .and. ( LEFT( ALLTRIM(STR( ::nKARTA)), 1) == VYDEJ )
        drgDBMS:open('DODLSTHD',,,,, 'DODLSTHDa')
        IF DODLSTHDa->( dbSeek( Value,,AdsCtag(1)))
           drgMsgBox(drgNLS:msg('Dodací list èíslo [ & ] již existuje ...', value ))
           lOK := .F.
        ENDIF
      ENDIF
      *
    Case ( name = ::HD + '->nCenaDokl' )
      NutneVN()
*      ::dm:refresh()

    Case ( name = ::HD + '->nNutneVN' )
*      lOK := Prijem_isOK(::dc:oBrowse[1]:oXbp, .T., .T.)
      lOK := Prijem_isOK( ::HD, ::IT, .T., .T.)
      IF !lOK
        oVar:value := oVar:initvalue
       ::dm:set( Name, oVar:initvalue )
      ENDIF

    Case ( name = ::HD + '->cZahrMena' )
      IF ::nKarta = 117   // Pøíjem v zahr.mìnì
        aKurz := LastKurz( Value, ::dm:get( ::HD + '->dDatPVP'))
        ::dm:set( ::HD + '->nKurZahMen', aKurz[ 2] )
        ::dm:set( ::HD + '->nMnozPrep' , aKurz[ 1] )
      ENDIF

    Case ( name = ::HD + '->NCENDOKZM' )
      IF ::nKarta = 117   // Pøíjem v zahr.mìnì
        ::dm:set(::HD + '->nCenaDokl', Value *( ::dm:get( ::HD + '->nKurZahMen')/ ::dm:get( ::HD + '->nMnozPrep')))
      ENDIF

    Case ( name = ::HD + '->NNUTNEVNZM' )
      IF ::nKarta = 117   // Pøíjem v zahr.mìnì
        ::dm:set(::HD + '->nNutneVN', Value *( ::dm:get( ::HD + '->nKurZahMen')/ ::dm:get( ::HD + '->nMnozPrep')))
      ENDIF

    EndCase
    *
    * hlavièku ukládáme na každém prvku, obèas zmizí údaje, je zajímavé, že nikdo nebrblal
    if( oVar:changed() .and. lok )
       oVar:save()

       do case
       case lower(name) = 'm->mainSklad' ; (::hd)->ccisSklad  := ::mainSklad
       case lower(name) = 'm->mainPohyb' ; (::hd)->ctypPohybu := ::mainPohyb
       endcase
    endif
  EndIf

RETURN lOK

********************************************************************************
METHOD SKL_PohybyHD:LastFieldHD(drgVar)
  Local lChanged := ::dm:changed(), lRet
  Local cName := drgVar:Name
  LOCAL mp1, mp2, oXbp, nEvent

  nEvent := LastAppEvent( @mp1,@mp2,@oXbp)
  IF mp1 = xbeK_ENTER .or. mp1 = xbeK_TAB

    IF lChanged .or. ::newHD
       IF ( cName = ::HD + '->dDatPVP')
          /*
          IF EMPTY( drgVar:Value)
            ::postValidate( ::dm:has( cName))
          ENDIF
          */
         ::postValidate( ::dm:has( cName))
       ENDIF

       IF ( cName = ::HD + '->dDatPVP' .and. ;
            ALLTRIM(STR( ::nKARTA)) $ '100,102,203,204,205,206,305,400') .or. ;
          ( cName <> ::HD + '->dDatPVP'  .and. ;
            cName <> ::HD + '->nNutneVN'       )

         if ::nKarta = 305
           if     lower(cname) = lower(::HD + '->dDatPVP')
              retur .t.
           elseif lower(cName) = lower(::hd +'->ncisFirmy')
             if ::postValidate( ::dm:has(cName))
               PostAppEvent(drgEVENT_SAVE,,, oXbp)
             endif
           endif
         endif

         IF ::postValidate( ::dm:has( cName))
           PostAppEvent(drgEVENT_SAVE,,, oXbp)
         EndIf
       ENDIF

       IF ( cName = ::HD + '->nNutneVN' )
         IF ::postValidate( ::dm:has( cName))
           PostAppEvent(drgEVENT_SAVE,,, oXbp)
         ENDIF
       ENDIF

       IF ( cName = ::HD + '->nNutneVNZM' .and. ;
            ALLTRIM(STR( ::nKARTA)) $ '117')
         ::postValidate( ::dm:has( cName))
         PostAppEvent(drgEVENT_SAVE,,, oXbp)
       ENDIF

       IF ( cName = ::HD + '->cCislObInt' .and. ;
            ALLTRIM(STR( ::nKARTA)) $ '274')
         IF ::postValidate( ::dm:has( cName))
           PostAppEvent(drgEVENT_SAVE,,, oXbp)
         ENDIF
       ENDIF

    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD SKL_POHYBYHD:SaveCardHD( nKEY)
  LOCAL mp1, mp2, oXbp, nEvent, cKey, cErr := '???', lOK , o, oVN
  Local Filter := Format("Upper(cCisSklad) = '%%'", {Upper(::mainSKLAD)} )
  Local nPrevVN := IF( nKEY = xbeK_ENTER,(::HD)->nNutneVN, 0 )
  Local nPrevCenaDokl := IF( nKEY = xbeK_ENTER,(::HD)->nCenaDokl, 0 )
  Local nPos

  ::dm:save()
  IF nKEY = xbeK_INS
    (::HD)->nCislPoh  := Val( AllTrim(::mainPohyb))
    (::HD)->cCisSklad := ::mainSklad
*    (::HD)->cUloha    := ULOHA_S
    (::HD)->cDenik    := ::cfg_cDenik //  SysConfig( 'Sklady:cDenik' )
    (::HD)->nRok      := uctObdobi:SKL:nROK      //GetROK()
    (::HD)->nObdobi   := uctObdobi:SKL:nOBDOBI   //GetOBD()
    (::HD)->cObdPoh   := uctObdobi:SKL:cOBDOBI
    (::HD)->cObdobi   := uctObdobi:SKL:cOBDOBI
    (::HD)->nKarta    := ::nKarta
    (::HD)->nTypPoh   := If( ::nKarta == 400, 1, Val( Left( AllTrim( Str( ::nKarta)), 1)) )
    (::HD)->nTypPVP   := (::HD)->nTypPoh
    (::HD)->nKlicObl  := KlicOblasti( (::HD)->nCisFirmy )
    *
*    cKEY := S_DOKLADY +  ALLTRIM( STR( ::nPohyb ))
*    lOK := C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
    (::HD)->cTypDoklad := C_TypPoh->cTypDoklad
    (::HD)->cTypPohybu := C_TypPoh->cTypPohybu
    (::HD)->cUloha     := C_TYPPOH->cUloha
    (::HD)->cTask      := C_TYPPOH->cTask
    (::HD)->cSubTask   := C_TYPPOH->cSubTask
    (::HD)->dVznikZazn := Date()
    *
*    SKL_DodLstHD_Wrt( ::cIsZahr = 'Z')

  ENDIF
  *
  IF nKEY = xbeK_ENTER
    /*
    SKL_ModiRelFiles()
    SKL_ModifyPVPItem()
    */
    * Pøi zmìnì VN nebo ceny na dokladu na hlavièce pøepoète VN na všechny položky dokladu
    If (::HD)->nNutneVN <> nPrevVN .or. (::HD)->nCenaDokl <> nPrevCenaDokl
       nRec := (::IT)->( RecNO())
       NutneVN()
       ::broIT:oXbp:refreshAll()
       (::IT)->( dbGoTO( nRec))
    ENDIF
    /*
    mh_WRTzmena( 'PVPHEAD', .F., .t.)
    */
*    IF PVPHEAD->nKarta = 110 .or. PVPHEAD->nKarta = 130 .or. PVPHEAD->nKarta = 117 .or. PVPHEAD->nKarta = 120
    IF ( nPos := ASCAN( {110,117,120,130}, PVPHEADw->nKarta)) > 0
      RozdilPriPrijmu()
      *
      o := ::dm:has('PVPHEADw->nRozPrij' ):oDrg
      o:oXbp:setColorFG( IF( PVPHEADw->nRozPrij = 0, GRA_CLR_BLACK, GRA_CLR_RED) )
      o:oVar:value := o:oVar:initValue := PVPHEADw->nRozPrij
      *
      ::sumColumn()
      *
      o := ::dm:has('M->nCelkDokl' ):oDrg
      o:oVar:value := o:oVar:initValue := ::nCelkDokl
    ENDIF
    *
*    ::Uctuj_Doklad()
    ::dm:refresh()
    */
  ENDIF

*old  ::set_SaveBut( dokl_isROZPRAC .and.)
  ::set_SaveBut( if( (::IT)->nDoklad <> 0, dokl_isROZPRAC, dokl_isULOZEN ) )
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:sumColumn()
  LOCAL nRecF := (::IT)->( RecNo())
  Local nSumZAKcel := 0.00, nSumZAHcel := 0.00, nPos
  Local sumCol, aItems, x

  ::DokladCelkem( .f.)

  aItems := { { ::IT + '->nMnozPrDod', ::nMnozPrDod, ::broIT },;
              { ::IT + '->nCenaCelk' , ::nCelkDokl,  ::broIT },;
              { ::IT + '->nCenapZBO' , ::nCelkPCB ,  ::broIT },;
              { ::IT + '->nCenapDZBO', ::nCelkPCS ,  ::broIT } }

  for x := 1 to len(aitems) step 1
    sumCol := ::broit:getColumn_byName( aitems[x,1] )
    sumCol:Footing:hide()
    sumCol:Footing:setCell(1, aitems[x,2])
    sumCol:Footing:show()
  next

  ::dm:refresh()
RETURN self



*HIDDEN*************************************************************************
METHOD SKL_POHYBYHD:modiCARD()
  Local  oVar, x, membCRD := {}, varsCRD := drgArray():new()
  *
  aEval(::membOrg, {|x| if(isMembervar(x,'groups') .and. ;
                         ischaracter(x:groups)   .and. ;
                         (x:groups <> '') , ;
                      (x:isEdit := .F., x:oXbp:hide()), nil) })
*
  For x := 1 TO Len( ::membORG)
    oVar := ::membORG[x]
    IF IsMemberVar(oVAR,'Groups')
      IF IsNIL( oVAR:Groups)
        AADD( membCRD, oVar)
      ElseIf IsCharacter( oVAR:Groups)
        If EMPTY(  oVAR:Groups) .OR. oVAR:Groups == Left( ::cCRD, 2) .OR. 'clr' $ oVar:Groups
*        IF  EMPTY(  oVAR:Groups) .OR. ::cTASK = oVAR:Groups
          IF oVAR:ClassName() $ 'drgGet,drgComboBox,drgMLE'
            oVAR:IsEDIT := .t.
            oVAR:oXbp:Show()
            AADD( membCRD, oVar)
            //
            If ( IsMemberVar(oVar,'pushGet') .and. IsObject(oVar:pushGet))
              oVar:pushGet:oxbp:show()
            EndIf
            //
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
  For x := 1 To LEN( ::varsORG:values)
    IF ! IsNIL( ::varsORG:values[x, 2] )
      oVAR := ::varsORG:values[x, 2]:oDrg
      IF oVAR:ClassName() $ 'drgGet,drgText,drgComboBox'
        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. (oVAR:Groups == Left( ::cCRD, 2)) .OR. 'clr' $ oVar:Groups
*        If IsNIL( oVar:Groups) .OR. EMPTY(oVar:Groups) .OR. ( oVar:Groups = ::cTASK )
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
  *
  IsEditGET( { ::HD + '->cObdobi'   ,;
               ::HD + '->cNazFirmy'  }, ::drgDialog, .F.   )

RETURN self

* Výbìr skladu
********************************************************************************
METHOD SKL_POHYBYHD:SKLAD_SEL( drgDialog)
  Local drgVar := ::dm:get('M->mainSklad', .F.), lastDrg, oVar
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_SKLADY->(dbseek(value,,'C_SKLAD1')))

  if IsObject(drgDialog) .or. !ok
     srchDialog := drgDialog():new( 'C_SKLADY', ::drgDialog)
     srchDialog:cargo := value
     srchDialog:create(,,.T.)
     *
     IF srchDialog:exitState = drgEVENT_SELECT
        drgVar:set(srchDialog:cargo)

        lastDrg := ::df:oLastDrg
        ok      := .t.
        ::drgDialog:oform:setNextFocus(lastDrg:name,,.t.)
        PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,lastDrg:oxbp)
     ENDIF
     *
     srchDialog:destroy()
     srchDialog := NIL
  endif

  if ok
    ::mainSklad     := C_Sklady->cCisSklad
    ::naz_mainSklad := C_Sklady->cNazSklad
    oVar := ::dm:has('m->naz_mainSklad')
    oVar:initValue := oVar:prevValue := oVar:Value := ::naz_mainSklad
    ::dm:refresh()
  endif
RETURN ok


******
METHOD SKL_POHYBYHD:TypPohybu_SEL( xVar)
  Local oDialog, nExit, copy := .f.
  Local drgVar := ::dm:get('M->mainPohyb', .F.), lastDrg, oVar
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_TypPoh->(dbseek(S_DOKLADY + value,,'C_TYPPOH02')))
  *
  If IsObject( xVar) .or. !ok
     DRGDIALOG FORM 'SKL_TypPoh_Sel' PARENT ::drgDialog MODAL DESTROY EXIT nExit

     IF nExit = drgEVENT_SELECT
       ok := .T.
       ::dm:set( 'M->mainPohyb'    , C_TypPoh->cTypPohybu )
       ::dm:set( 'M->naz_mainPohyb', C_TypPoh->cNazTypPoh )
     ENDIF
  EndIf

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  If copy  ///  ok
    ::mainPohyb     := C_TypPoh->cTypPohybu
    ::naz_mainPohyb := C_TypPoh->cNazTypPoh
    oVar := ::dm:has('m->naz_mainPohyb')
    oVar:initValue := oVar:prevValue := oVar:Value := ::naz_mainPohyb
    ::dm:refresh()

    ::nKarta := VAL( Right( AllTrim(C_TypPoh->cTypDoklad), 3))
    ::naz_Doklad := ''
    oVar := ::dm:has('m->naz_Doklad')
    oVar:initValue := oVar:prevValue := oVar:Value := ::naz_Doklad
    ::dm:refresh()

    ::selectCard()
    ::modicard()
    *
    ::dm:set( ::HD + '->nDoklad', NewDoklad_skl( ::nKarta, ::mainSklad) )
    ::dm:set( ::HD + '->nCenaDokl', 0 )
    ::dm:refresh()
    *
    C_TypPoh->( mh_ClrFilter())

    ::SaveCardHD( xbeK_INS )
  EndIf
RETURN ok

* Výbìr èísla firmy z FIRMY do HL pohybového dokladu
********************************************************************************
METHOD SKL_POHYBYHD:SKL_FIRMY_SEL( Dialog)
  LOCAL oDialog, nExit, copy := .f.
  Local drgVar := ::dm:get( ::HD + '->nCisFirmy', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. Firmy->(dbseek(value,,'FIRMY1')))
  *
  ** u karty 305 - pøevod není firma povinná
  if ::nKarta = 305
    ok := if( empty(value), .t., firmy->(dbseek(value,,'FIRMY1')) )
  endif

  If IsObject( Dialog) .or. !ok
    _clearEventLoop(.t.)
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ok := .T.
    ::dm:set( ::HD + '->NCISFIRMY' , FIRMY->NCISFIRMY)
    ::dm:set( ::HD + '->cNazFIRMY' , FIRMY->cNazev   )

    (::HD)->ncisFirmy := firmy->ncisFirmy
    (::HD)->cnazFirmy := firmy->cnazev

    IF ::nKARTA = 253
      /*
      anSlevy := Slev_Firma( Firmy->nCisFirmy )
      nProcSlevy := If( lNewRec, anSlevy[ 1] + anSlevy[ 3],;
                                 PVPHead->nProcSlev        )
      ax[ Len( ax)]    := VAL( STR( nProcSlevy, 4, 1))
      ag[ Len( ax), 4] := ax[ Len( ax)]
      */
      ::cIsZahr := IF( UPPER( Firmy->cZkratStat) == 'CZ ' .OR. ;
                       UPPER( Firmy->cZkratStat) == 'CZE', 'T', 'Z' )
      ::dm:set('M->cIsZahr', ::cIsZahr )
    ENDIF
  ENDIF
RETURN ok

* Výbìr zakázky do hlavièky pohybového dokladu
********************************************************************************
METHOD SKL_POHYBYHD:SKL_VYRZAK_SEL( Dialog)
  LOCAL oDialog, nExit
  Local drgVar := ::dm:get( ::HD + '->cCisZakaz', .F.)
  Local value  := drgVar:get()
  Local lOk    := ( !Empty(value) .and. VyrZAK->(dbseek(value,,'VYRZAK1')))

  If IsObject( Dialog) .or. !lOk
    DRGDIALOG FORM 'VYR_VYRZAK_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  IF nExit != drgEVENT_QUIT .or. lOk
    ok := .T.
    ::dm:set( ::HD + '->cCisZakaz',  VYRZAK->cCisZakaz )
  ENDIF
RETURN lOK

********************************************************************************
METHOD SKL_PohybyHD:SKL_OBJHEAD_SEL( Dialog)
  LOCAL oDialog, nExit, cFilter
  Local nFirma := IF( ::nKarta = 274 .or. ::nKarta = 293, 1, (::HD)->nCisFirmy)
  Local drgVar := ::dm:get( ::HD + '->cCislObInt', .F.)
  Local value  := drgVar:get()
  Local lOk    := ( !Empty(value) .and. OBJHEAD->(dbSEEK( '00001' + Value,, 'OBJHEAD1')) ) .or. ;
                    Empty( value)

  Local dm := ::drgDialog:dataManager

  If IsObject( Dialog) .or. !lOk
    cFilter := FORMAT( "StrZero(nCisFirmy,5) = '%%' .and. ObjHEAD->nMnozObOdb - ObjHEAD->nMnozPlOdb > 0", { StrZero(nFirma,5)})
    ObjHEAD->( mh_SetFilter( cFilter))

    DRGDIALOG FORM 'ODB_OBJHEAD_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit

    ObjHEAD->( mh_ClrFilter())
  ENDIF

  IF nExit != drgEVENT_QUIT .or. lOk
    lOK := .T.
    ::dm:set( ::HD + '->CCISLOBINT' , IF( Empty(value), '', OBJHEAD->CCISLOBINT ))
*    ::LastCislObInt :=  OBJHEAD->CCISLOBINT
  ELSE
    ::dm:set( ::HD + '->CCISLOBINT',  '' )
  ENDIF
RETURN lOK


********************************************************************************
METHOD SKL_PohybyHD:SaveDoklad()
  Local isDouble := .F., newCisDokl

  * Doklad ukládat, je-li ve stavu rozpracování, tzn. že je nový nebo byl opraven
  IF ::dokl_inSTAV = dokl_isULOZEN
    RETURN self
  ENDIF

  * U pøíjmových dokladù kontrolovat cenu na dokladu
  IF (::HD)->nTypPoh = 1  // pøíjem
    IF (::HD)->nCenaDOKL = 0
      IF drgIsYESNO(drgNLS:msg( 'Cena na pøíjmovém dokladu je nulová !;' + ;
                                'Požadujete doklad uložit ?' ))
      ELSE
        RETURN self
      ENDIF
    ENDIF
  ENDIF
  * Pøed zápisem kontrolovat duplicitu dokladu, pokud doklad již existuje po zápisu
  * upozornit na zmìnu èísla dokladu !
  IF ::newHD
    isDouble := !::CisDoklad_skl( ::dm:get(::HD + '->nDoklad'), .F.  )
    IF isDouble
      newCisDokl := NewDoklad_skl( ::nKARTA, ::MainSklad)
      ::dm:set(::HD + '->nDoklad', newCisDokl )
      (::HD)->nDoklad := newCisDokl
      (::IT)->( dbEval({|| (::IT)->nDoklad := newCisDokl } ), dbGoTop() )
    ENDIF
  ENDIF
  *
  if (::IT)->nDoklad = 0
    drgMsgBox( drgNLS:msg( 'Doklad nemá položky a NELZE ULOŽIT !' ))
  elseIF Skl_allOK( ::newHD,, ::HD, ::IT )
    ::DokladCelkem()      // NEW 3.3.10

    oSession_data:beginTransaction()

    BEGIN SEQUENCE
//      SKL_SaveDoklad(self)
      skl_pvpHead_wrt(self)
      oSession_data:commitTransaction()
    RECOVER USING oError
      oSession_data:rollbackTransaction()
    END SEQUENCE

    ::set_SaveBut( dokl_isULOZEN)
    *
    IF isDouble
      drgMsgBox( drgNLS:msg( 'Doklad byl uložen pod èíslem [ & ] !', newCisDokl))
    ENDIF
    *
    PostAppEvent(xbeP_Close,,,::drgdialog:dialog)
  endif
Return self


* Evidence výrobních èísel
********************************************************************************
METHOD SKL_PohybyHD:btn_VYROBCIS()
  *
  ::drgDialog:pushArea()
  DRGDIALOG FORM 'SKL_VYRCIS_CRD' PARENT ::drgDialog CARGO_USR 2 MODAL DESTROY
  ::drgDialog:popArea()
  *
  ::set_SaveBut( dokl_isROZPRAC)
RETURN self

**HIDDEN************************************************************************
METHOD SKL_PohybyHD:sklParSymbol( oVAR)
  Local Name := UPPER( oVar:Name)
  Local Value := oVar:Value
  Local lRetVal := .T., lWarning
  Local cSymb   := If( ::cfg_lFakParSym, 'Èíslo faktury', 'Èíslo dodacího listu' )

  IF oVAR:oDrg:isEdit
    IF ( Value == 0)   //.and. lPovinSym
      DO CASE
      CASE( NAME = ::HD + '->NCISFAK' )
        lWarning := ::cfg_lFakParSym     //  Faktura je párovacím symbolem
      CASE( NAME = ::HD + '->NCISLODL' )
        lWarning := !::cfg_lFakParSym    // Èíslo DL je párovacím symbolem
      ENDCASE
      IF lWarning
        drgMsgBOX( 'POZOR : ' + cSymb + ' je párovacím symbolem !' )
        _clearEventLoop(.t.)
        lRetVal := !::cfg_lPovinSym
      ENDIF
*      lRetVal := !lPovinSym
    ENDIF
  ENDIF
RETURN(lRetVal )

* Zjistí typ DL - Tuzemský / Zahranièní
**HIDDEN************************************************************************
METHOD SKL_POHYBYHD:DodIsZAHR()

  IF ::nKarta = 253
    IF (::HD)->nCisloDL > 0
      IF DodLstHD->( dbSEEK( (::HD)->nCisloDL,,AdsCtag(1)))
         ::cIsZahr := IF( DodLstHD->lIsZahr, 'Z', 'T' )
      ENDIF
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:set_SaveBut( nStav)
  Local oActions, x, nIcon := If( nStav = 0, 428, 427)
  Local oIcon := XbpIcon():new():create()
  *
  ::dokl_inSTAV := nStav
  oActions := ::drgDialog:oActionBar:members
  for x := 1 to len(oActions)
     if ( lower( oActions[x]:event) $ 'savedoklad')  // aEventsDisabled)
       oActions[x]:icon1 := nIcon
       oActions[x]:icon2 := nIcon
*org       oActions[x]:oicon:caption := nIcon
*org       oActions[x]:oicon:configure()
*       oActions[x]:oxbp:caption := nIcon
*       oActions[x]:oxbp:configure()
*******
       oIcon:load( NIL, nIcon )
       oActions[x]:oxbp:setImage( oIcon )
       oActions[x]:oxbp:setTextAlign( 6)
     endif
  next
RETURN self



**HIDDEN************************************************************************
METHOD SKL_POHYBYHD:BackToPVPTerm( AllRecs)

  DEFAULT AllRecs TO .F.
  *
  IF AllRecs
    (::IT)->( dbGoTop())
    DO WHILE !(::IT)->( EOF())
      IF (::IT)->nrec_Term <> 0
         * vrací se nasnímaný záznam do nabídky seznamu (záložka  "Z terminálu")
         PVPTERM->( dbGoTo( (::IT)->nrec_Term ))
         IF ( (::IT)->_delrec = '9' .or. ;
              (::IT)->_nRecor = 0   .or. ;
              (::IT)->_nRecor <> 0  .and.( PVPTERM->nMnoz_PLN <> (::IT)->nMnozDokl1 ))
           IF PVPTERM->( RLock())
              PVPTERM->nMnoz_PLN -= (::IT)->nMnozDokl1
              PVPTERM->nMnoz_PLN := MAX( 0, PVPTERM->nMnoz_PLN)
              PVPTERM->nStav_PLN := IF( PVPTERM->nMnoz_PLN > 0 .and. PVPTERM->nMnoz_PLN < PVPTERM->nMnozDokl1, 1,;
                                      IF( PVPTERM->nMnoz_PLN = PVPTERM->nMnozDokl1, 2, 0))
              PVPTERM->( dbRUnlock())
           ENDIF
        ENDIF
      ENDIF

      (::IT)->( dbSKIP())
    ENDDO
  ELSE
    * Vrátíme do pùv.stavu jeden( aktuální) záznam
    IF (::IT)->nrec_Term <> 0
       * vrací se nasnímaný záznam do nabídky seznamu (záložka  "Z terminálu")
       PVPTERM->( dbGoTo( (::IT)->nrec_Term ))
         IF ( (::IT)->_delrec = '9' .or. ;
              (::IT)->_nRecor = 0   .or. ;
              (::IT)->_nRecor <> 0  .and.( PVPTERM->nMnoz_PLN <> (::IT)->nMnozDokl1 ))
         IF PVPTERM->( RLock())
            PVPTERM->nMnoz_PLN -= (::IT)->nMnozDokl1
            PVPTERM->nMnoz_PLN := MAX( 0, PVPTERM->nMnoz_PLN)
            PVPTERM->nStav_PLN := IF( PVPTERM->nMnoz_PLN > 0 .and. PVPTERM->nMnoz_PLN < PVPTERM->nMnozDokl1, 1,;
                                    IF( PVPTERM->nMnoz_PLN = PVPTERM->nMnozDokl1, 2, 0))
            PVPTERM->( dbRUnlock())
         ENDIF
      ENDIF
    ENDIF
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_POHYBYHD:destroy()
  *
  ::setMainItems()
  *
  ::naz_mainSklad := ::naz_mainPohyb := ;
  ::dc := ::dm := ::df := ::broIT :=  ; // ::broLIK := ;
  ::varsOrg := ::membOrg := ;
  ::LastCislObInt := ::parentFRM := ::nRecIT := ::cTagIT := ;
  NIL

RETURN self


*===============================================================================
*-------------------------------------------------------------------------------
STATIC FUNCTION DodLstHD_modi()
  *  Pøi opravì PVPHead promítnout do DodLstHD
  IF PVPHead->nKarta = 253 .and. PVPHead->nCisloDL = DodLstHD->nDoklad .and. ;
     PVPHEAD->dDatPVP <> DodLstHD->dVystFak
    *
    IF ReplRec( 'DodLstHD')
      FirmyFI->( dbSeek( PVPHead->nCisFirmy,,'FIRMYFI1'))
      DodLstHD->dVystFak   := PVPHead->dDatPVP
      DodLstHD->dPovinFak  := PVPHead->dDatPVP
      DodLstHD->dSplatFak  := If( FirmyFi->nSplatnost <> 0 ,;
                                  DodLstHD->dVystFak + FirmyFi->nSplatnost      ,;
                                  DodLstHD->dVystFak + SysConfig( 'Finance:nSplatnost')  )
    ENDIF
  ENDIF
RETURN nil

*-------------------------------------------------------------------------------
FUNCTION DEL_PVPItem( cAlias)
  Local cTypPohyb := LEFT( ALLTRIM(STR( PVPHEAD->nKARTA)), 1)
  LOCAL cTypHead  := SUBSTR( ALLTRIM(STR( PVPHead->nKarta)), 2, 1)
  Local nKey := xbeK_DEL, lOK := .F., nRec

  Do case
  case cTypPohyb = PREVOD
     SKL_DelPolPrevod_()
  case cTypPohyb = PRIJEM
    lOK := SKL_DelPolPrijem()
  case cTypPohyb = VYDEJ
    lOK := .T.
  Endcase
  If lOK
    If cAlias = 'PVPITEMww'       // v zobrazení dokladu
// js      skl_cenzboz_modi( nKey,,'pvpheadw','pvpitem','pvpitemww')
    elseif cAlias = 'PVPITEM'     // na screenu
// js      skl_cenzboz_modi( nKey)
    endif
    SKL_UcetPol_DEL()
    *
    If cTypPohyb = VYDEJ
      SKL_VydejDKP_SAVE( nKey,, cAlias)    // SKL_DelVydejDKP()
      *
      If ! Empty( PVPItem-> cCislObINT )
        SKL_ObjPrij_akt( nKey )
      EndIf
      SKL_DodLstIT_Modi( xbeK_DEL, 'DODLS' )
      *
    EndIf
    *
    If cTypPohyb = PRIJEM
      ModiCen_prijem( nKey, cTypPohyb, cTypHead, cAlias )
      SKL_DelVyrPROD()
      *
      If ! Empty( PVPItem-> cCisObj )
        *SKL_ObjVyst_R( xbeK_DEL )
        SKL_ObjVyst_akt( xbeK_DEL )
        SKL_MnozKzbo_akt( xbeK_DEL )
      EndIf
     *
    Endif
    *
    VyrCis_Modi( 'PVPITEM')
    SKL_DelMistaULOZ()

    PVPITEM ->( sx_RLock( PVPITEM->( RecNo())), DbDelete())
  EndIf
RETURN nil