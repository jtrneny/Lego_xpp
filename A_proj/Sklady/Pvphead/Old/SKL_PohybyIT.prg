/*******************************************************************************NEW
  SKL_POHYBYIT.PRG
*******************************************************************************/

#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
#include "..\SKLADY\SKL_Sklady.ch"

#Define  setMNDOKLAD       0     // Mn.pøednastavované do dokladu

********************************************************************************
CLASS SKL_POHYBYIT FROM drgUsrClass, SKL_pohyb_PRIJEM, SKL_pohyb_VYDEJ

EXPORTED:
  *
  ** napojení na WDS ve tøídì skl_pohybyhd
  var     hd_udcp
  var     hd_file, it_file
  var     cisSklad, sklPol
  var     ofile_iv, orecs_iv

  VAR     cfg_nTypNabPol, recCenZbo
  VAR     oHD, uHd, HD, IT, newIT, Naz_PolDoklad, nKarta
*  VAR     cNazPol1, cNazPol2, cNazPol3, cNazPol4, cNazPol5, cNazPol6
  VAR     isDataTT, lPrevzitTT

  VAR     nCenaMZBO, nVyslCenaB, nVyslCenaS, nSumHodnSl, nSumProcSl
  VAR     nSumaPolB, nSumaPolS, nSumaDoklB, nSumaDoklS
  VAR     nProcDPH, nCenaSroz, nMarzRabat, nCelkITEM, nCelkDOKL
  VAR     cKatcZbo
  VAR     nFakPriDim   //
  var     nMnozDokl_o

  METHOD  Init, Destroy, drgDialogInit, drgDialogStart, drgDialogEnd, EventHandled
  METHOD  preValidate, postValidate, postValidateForm
  METHOD  SetNS, SaveNS

  METHOD  SKL_CENZBOZ_SEL, SKL_OBJVYSIT_SEL, SKL_OBJITEM_SEL

  method  SKL_C_Sklad, SKL_C_UctSkp, SKL_C_ODPMIS, SKL_C_SKUMIS, SKL_PRIJDIM, SKL_VYDEJKY

  METHOD  SaveAndIns, TT_data_yes
  METHOD  ControlNS, VyrCis_Modi, MistaUloz

  * strukrura pole
  * { recno()  ,curr_curr_mnozDokl1/pocPol, curr_mnozPrDod/pocPol,
  *             curr_celkItem/pocPol      , curr_celkDokl/pocPol , ccisZakazi }
  var      pa_mnozDokl1

  inline method skl_vyrzakit_sel(cnazPol3)
    local  chFilter := "ccisZakaz = '%%' .and. (.not. lzavren .or. isnull(lzavren))", cfilter
    local  odialog, nexit := drgEVENT_QUIT, ok := .t.
    *
    local  sklPol    := ::dm:get('pvpitemww->csklPol'   )
    local  nazPol3   := ::dm:get('pvpitemww->cnazPol3'  )
    local  mnozDokl1 := ::dm:get('pvpitemww->nmnozDokl1')
    local  mjDokl1   := ::dm:get('pvpitemww->cmjDokl1'  )
    *
    local  cmain_ky  := upper(sklPol) +upper(nazPol3) +strZero(mnozDokl1,15,4) +upper(mjDokl1)

    vyrZak  ->( dbseek( cnazPol3->ccisZakaz,,'VYRZAK1'))   // ccisZakaz
    vyrZakit->( dbseek( cnazPol3->cnazPol3 ,,'ZAKIT_4'))   // ccisZakazi

    cfilter   := format( chFilter, { cnazPol3->ccisZakaz })

    if .not. vyrZakitw->( dbseek( cmain_ky,,'ZAKITw_2' ))
      ::pa_mnozDokl1 := {}

      vyrZakitw->( dbzap())
      vyrZakit ->( ads_setAof( cfilter), dbgotop() )

      do while .not. vyrZakit->( eof())
        mh_copyFld( 'vyrZakit', 'vyrZakitw', .t. )

        vyrZakitw->cmain_Ky := cmain_Ky
        vyrZakit->( dbskip())
      enddo
    endif

    if .not. vyrZakitw->( eof())
      odialog := drgDialog():new('SKL_vyrZakit_SEL',::drgDialog)
      odialog:create(,,.T.)
      nexit := odialog:exitState

      ::pa_mnozDokl1 := aclone( odialog:udcp:pa_mnozDokl1 )

      odialog:destroy()
      odialog := nil
    endif
  return (nexit != drgEVENT_QUIT) .or. ok


  inline access assign method cen_ucetSkup() var cen_ucetSkup
    local cisSklad := (::hd)->cCisSklad, sklPol

    sklPol := if( isObject(::dm), ::dm:get('pvpitemww->csklPol'), '')
    cenZboz_80->( dbseek( cisSklad +sklPol,,'CENIK03'))
  return cenZboz_80->cucetSkup

  inline access assign method cen_mnozSZbo() var cen_mnozSZbo
    local cisSklad := (::hd)->cCisSklad, sklPol

    sklPol := if( isObject(::dm), ::dm:get('pvpitemww->csklPol'), '')
    cenZboz_80->( dbseek( cisSklad +sklPol,,'CENIK03'))
  return cenZboz_80->nmnozSZbo


HIDDEN:
  VAR     varsORG, membORG, LastCislObInt, cNameIT, nRecEnter
  VAR     dc, dm, df
  var     odialog_centerm, cflt_pvpTerm
  var     cisObj, cislObInt

  METHOD  modiCard, ClearVarIT, SaveCardIT, ordItem
  METHOD  FirstEditIT, SetEditIT, Recompute

  *
  ** pøi ukládání rozpadu z vyrZakit se musí prevValue a initValue zanulovat
  ** dm:save testuje rozdíl value a initValue, pokud by byly shodné neukládá
  inline method clear_initValue()
    local  x, ok := .t., vars := ::dm:vars, ovar

    for x := 1 to ::dm:vars:size() step 1
      ovar   := ::dm:vars:getNth(x)
      value  := ovar:value
      type   := valType( value )
      xvalue := if( type = 'C' .or. type = 'M', space( len( ovar:value)), ;
                 if( type = 'D', ctod('')                               , ;
                  if( type = 'L', .f.                                   , ;
                   if( type = 'N', 0, nil                                 ))))

      if type = 'N'
        if (npos := at('.', value := str( value ))) <> 0
          xValue := val( '0.' +replicate( '0', len(value) - npos))
        endif
      endif

      ovar:prevValue := ovar:initValue :=  xvalue
    next
  return self

ENDCLASS

********************************************************************************
METHOD SKL_POHYBYIT:init(parent)
  *
  ::drgUsrClass:init(parent)

  ::hd_udcp   := parent:parent:udcp

  ::SKL_pohyb_PRIJEM:init(parent)
  ::SKL_pohyb_VYDEJ:init(parent)
  *
  ::oHD    := parent:parent
  ::uHd    := parent:parent:udcp
  ::HD     := ::uHd:HD
  ::IT     := ::uHd:IT
  ::nKarta := ::uHd:nKARTA
  ::LastCislObInt := ::uHd:LastCislObInt
  ::lPrevzitTT    := .F.
  ::nRecEnter     := 0
  ::nMnozDokl_o   := 0
  *
  ::pa_mnozDokl1  := {}

  ::cfg_nTypNabPol := SysConfig( 'Sklady:nTypNabPol')
  ::recCenZbo := CenZboz->( RecNo())
*  ::cNazPol1 := ::cNazPol2 := ::cNazPol3 := ::cNazPol4 := ::cNazPol5 := ::cNazPol6 := SPACE(8)
  *
  ::ClearVarIT()
  *
  ::newIT := !(parent:cargo = drgEVENT_EDIT)
  ::Naz_PolDoklad := ::uHd:Naz_DokladPol
  *
  drgDBMS:open('PVPTerm' )
  ::isDataTT := PVPterm->(dbseek( ::uHD:mainSKLAD + StrZero((::HD)->nTypPVP,1),, 'PVPTERM01'))
  *
  drgDBMS:open('Osoby' )
  drgDBMS:open('C_OdpMis' )
  C_OdpMis->( DbSetRelation( 'Osoby', { || C_OdpMis->nCisOsoby } , 'C_OdpMis->nCisOsoby'   ))
RETURN self

********************************************************************************
METHOD SKL_POHYBYIT:drgDialogInit(drgDialog)
Local  aNewPos
Local  nX := GetSystemMetrics( 0), nY := GetSystemMetrics( 1)
  *
  IF IsNIL( drgDialog:usrPos)
    *
    do case
    case nX = 1280 .and. nY = 1024  ;  aNewPos := { 225, 440}
    case nX = 1280 .and. nY = 960   ;  aNewPos := { 225, 405}
    case nX = 1280 .and. nY = 768   ;  aNewPos := { 225, 315}
    case nX = 1152 .and. nY = 864   ;  aNewPos := { 160, 360}
    case nX = 1024 .and. nY = 768   ;  aNewPos := { 100, 315}
    case nX =  800 .and. nY = 600
    otherwise
    endcase
    *
    drgDialog:usrPos := aNewPos
  ENDIF
RETURN self

********************************************************************************
METHOD SKL_POHYBYIT:drgDialogStart(drgDialog)
  Local oVar, nPos
  Local Filter := Format("Upper(cCisSklad) = '%%'", {Upper((::HD)->cCisSklad)} )
  LOCAL members  := ::drgDialog:oActionBar:Members, x

  ::dc      := drgDialog:dialogCtrl
  ::dm      := drgDialog:dataManager
  ::df      := drgDialog:oForm
  ::membORG := ::dc:members[1]:aMembers
  ::varsORG := ::dm:vars
  *
  p_dm := drgDialog:parent:dataManager

  ::cisSklad   := p_dm:get( 'M->mainSklad'     , .f.)
  ::sklPol     := ::dm:get(::it +'->csklPol'   , .F.)
  ::cisObj     := ::dm:get(::it +'->ccisObj'   , .F.)
  ::cislObInt  := ::dm:get(::it +'->ccislobint', .F.)
  *
  IF( 'INFO' $ UPPER( drgDialog:title), drgDialog:SetReadOnly( .T.), NIL )
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::modiCard()
  *

  IsEditGET( { ::HD + '->nDoklad' , ::HD + '->cCisSklad', ::HD + '->cTypPohybu' ,;
               ::IT + '->nOrdItem', ::IT + '->nCenaCelk', ::IT + '->cNazZbo'    ,;
               ::IT + '->nCislPolOb', ::IT + '->nOrdItem_o' } ,;
               drgDialog, .F.   )

  * u definovaných karet editujeme hodnoty na dokladu ( nMnozDokl1, nCenaDokl1)
  nPos := ASCAN( {110,120}, ::nKarta )
  IsEditGET( { ::IT + '->nMnozPrDod' , ::IT + '->nCenNapDod' }, drgDialog, nPos = 0   )
  *
  if ::nKarta = 299
    IsEditGET( { ::IT + '->cMjDokl1', ::IT + '->nMnozPrDod', ::IT + '->nCenNapDod' },;
                 drgDialog, .F.   )
  endif
  *
  ::SetEditIT()          //  Nastavení editace položkové karty
  ::FirstEditIT()        //  Nastaví 1.editaèní položky v kartì
  *
  CenZboz->( mh_SetFILTER( Filter))
  PVPTerm->( mh_SetFILTER( Filter))
  *
  ::uHd:DokladCelkem( .F.)
  ::nCelkDOKL := ::uHD:nCelkDokl
  *
  If ::newIT
    (::IT)->( dbAppend())
    (::IT)->nOrdItem := ::ordItem() + 1
    ::nFakPriDim      := 0
  Else
    CenZboz->( dbSeek( Upper((::it)->cCisSklad) + Upper( (::it)->cSklPol),, 'CENIK03'))
    ::nCelkITEM := (::IT)->nCenaCelk
    ::nFakPriDim := (::IT)->nCisFak
    if ::nKarta = 299
       drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
       if PVPITEMa->( dbSeek( Upper((::it)->cCisSklad) + StrZero( (::it)->nDoklad_o,10) + StrZero( (::it)->nOrdItem_o,5 ),,'PVPITEM02'))
         ::nMnozDokl_o := if((::IT)->_nRecor = 0, PVPITEMa->nMnozDokl1 * -1, (::IT)->nMnozDokl1 )
       endif
       PVPITEMa->( dbCloseArea())
    endif
  EndIf

  ::dm:refresh()
  *
  ** napojení na WDS
  ::ofile_iv := ::dm:get(::it +'->cfile_iv' , .F.)
  ::orecs_iv := ::dm:get(::it +'->nrecs_iv' , .F.)

  ::hd_file  := ::hd
  ::it_file  := ::it

  ::hd_udcp:wds:dm := ::dm
RETURN self

********************************************************************************
METHOD SKL_POHYBYIT:drgDialogEnd(drgDialog)
  *
  DokladHasItem( ::uHD:newHD, ::IT, drgDialog:parent)
  * Pokud pøi poøízení v cyklu zavøe dialog køížkem, musí se zrušit prázdný záznam
  IF EMPTY( (::IT)->cSklPol)
    (::IT)->_delrec := '9'
  Endif
RETURN self

********************************************************************************
METHOD SKL_POHYBYIT:eventHandled(nEvent, mp1, mp2, oXbp)
  Local x, lOK
  *
  ::hd_udcp:wds_watch_time()
  *
  DO CASE
    CASE nEvent = drgEVENT_DELETE
    CASE nEvent = drgEVENT_EXIT   // ULOŽ + INS
      if  oXbp:Classname() = 'xbpStatic'
         ::SaveAndIns()
      endif

    CASE nEvent = drgEVENT_SAVE
      * Pokud pøi poøízení v cyklu dá ALT+U, CTRL+S nad pøidaným prázdným záznamem
      IF EMPTY( ::dm:get( ::IT + '->cSklPOL'))
        (::IT)->_delrec := '9'
        PostAppEvent(xbeP_Close,,, ::drgDialog:dialog )
        RETURN .F.
      ENDIF

      if lower(oXbp:Classname()) $ 'xbpget,xbpstatic,xbpimagebutton'
         if ::newIT
           ::SaveAndIns()
         else
           If ( lOK := ::SaveCardIT( If( ::newIT, xbeK_INS, xbeK_ENTER )))
             PostAppEvent(xbeP_Close,,,  ::uHD:broIt:oxbp )
           Endif
           return .f.
         endif
      else
         ::SaveAndIns()
      endif

    CASE nEvent = drgEVENT_QUIT
      IF EMPTY( (::IT)->cSklPol)
        (::IT)->_delrec := '9'
      Endif

    CASE nEvent = xbeP_Keyboard
      Do Case
        Case mp1 = xbeK_ESC
           IF EMPTY( (::IT)->cSklPol)
             (::IT)->_delrec := '9'
             if ::nRecEnter > 0
               PVPITEMww->( dbGoTO( ::nRecEnter))
               ::nRecEnter := 0
             endif
           Endif
           RETURN .F.
        Case  mp1 = xbeK_ALT_ENTER
          IF oXbp:cargo:Name = 'PVPITEMww->cSklPol'
            CENZBOZ->( dbGoTo( ::recCenZbo))
            ::dm:set( ::IT +'->cSklPol', CENZBOZ->cSklPol )
            ::postValidate( oXbp:cargo:oVar)
          ENDIF
        Otherwise
          RETURN .F.
       EndCase
     OTHERWISE
       RETURN .F.
  ENDCASE
RETURN .T.

********************************************************************************
METHOD SKL_PohybyIT:preValidate(drgVar)
  Local value := drgVar:Value
  Local Name := drgVar:Name, nPos

  DO CASE
  CASE ( nPos := ASCAN( { 253,274 }, ::nKARTA)) > 0
    ::dm:set(::IT + '->cCislObInt', CoalEsce( ::LastCislObInt, (::HD)->cCislObInt)  )
  ENDCASE
  *
  IF Name = ::IT + '->cSklPol' .or. Name = ::IT + '->cCislObInt'
    ::SetNS()
  ENDIF
  *
  IF ::cfg_nTypNabPol = 2           // Nabízet skl.položku jako seznam
    IF Name = ::IT + '->CSKLPOL'
      PostAppEvent(xbeP_Keyboard, xbeK_F4,, ::dm:has( Name):oDrg:oXbp )
    ENDIF
  ENDIF
RETURN .T.

********************************************************************************
METHOD SKL_PohybyIT:postValidate( oVar)
  Local lOK := .T.
  Local value := oVar:value, name := oVar:name
  Local lValid := (::newIT .or. oVar:changed() )
  Local nPom, nOldDecim, nKoef, nCenaSZbo, nDecimal := 4


  Do Case
  Case ( name = ::IT + '->cSklPol' )
    lOK := ::Skl_CenZboz_sel()

  Case ( name = ::IT + '->cCisObj' )
    IF EMPTY( value)
      (::cisObj:odrg:isEdit := .f., ::cisObj:odrg:oxbp:disable())
       ::drgDialog:oForm:setNextFocus(::IT + '->cSklPol',, .T. )
    ELSEIF ( lOK :=  ::Skl_ObjVysIT_sel() )
      ::drgDialog:oForm:setNextFocus(::cNameIT,, .T. )
    ENDIF

  Case ( name = ::IT + '->cCislObInt' )
    IF EMPTY( value)
      (::cislObInt:odrg:isEdit := .f., ::cislObInt:odrg:oxbp:disable())
       ::drgDialog:oForm:setNextFocus(::IT + '->cSklPol',, .T. )
    ELSEIF ( lOK :=  ::Skl_ObjITEM_sel() )
       ::drgDialog:oForm:setNextFocus(::cNameIT,, .T. )
    ENDIF

  Case ( name = ::IT + '->nDoklad_o' )
    IF ( lOK := ::Skl_Vydejky() )
      ::drgDialog:oForm:setNextFocus(::cNameIT,, .T. )
    ENDIF

  Case ( name = ::IT + '->cKlicSkMis' )
    lOK := ::Skl_C_SkuMis()

  Case ( name = ::IT + '->cKlicOdMis' )
    lOK := ::Skl_C_OdpMis()

  CASE ( name =  ::IT + '->nCenNaDoZM')
    IF ::nKarta = 117   // Pøíjem v zahr.mìnì
      * ORIG
      ::dm:set( ::IT + '->nCenCelkZM', value * ::dm:get( ::IT + '->NMNOZDOKL1') )
      ::dm:set( ::IT + '->NCENNAPDOD', Value *( PVPHEADw->nKurZahMen / PVPHEADw->nMnozPrep))
      ::dm:set( ::IT + '->NCENACELK' , ::dm:get( ::IT + '->NCENNAPDOD') * ::dm:get( ::IT + '->NMNOZPRDOD') )
    ENDIF

  CASE ( name = ::IT +'->NCENNAPDOD' )
    IF ::nKarta = 400
      ::dm:set( ::IT +'->nCENACZBO', value * CENZBOZ->nMnozSZBO )
      ::dm:set('M->nCenaSROZ'      , value - CENZBOZ->nCenaSZBO )
      ::dm:set( ::IT +'->nCenaCELK', (value - CENZBOZ->nCenaSZBO) * CENZBOZ->nMnozSZBO )
    ELSE
      ::dm:set( ::IT +'->NCENACELK', ::dm:get( ::IT +'->NCENNAPDOD') * ::dm:get( ::IT +'->NMNOZPRDOD') )
    ENDIF

  CASE ( name = ::IT + '->NCENADOKL1')
    nMn := KoefPrVC_MJ( ::dm:get( ::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )

    ::dm:set( ::IT + '->nCenNapDod', value / nMn )
    ::dm:set( ::IT + '->NCENACELK' , ::dm:get( ::IT + '->NCENNAPDOD') * ::dm:get( ::IT + '->NMNOZPRDOD') )    //29.10.09

  CASE ( NAME = ::IT + '->NMNOZDOKL1')
    IF ::nKarta = 117
      ::dm:set( ::IT + '->nCenCelkZM', ::dm:get( ::IT + '->nCenNaDoZM') * value  )
      ::dm:set( ::IT + '->NCENACELK' , ::dm:get( ::IT + '->NCENNAPDOD') * ::dm:get( ::IT + '->NMNOZPRDOD') )
    elseif ::nKarta = 299
      lOK := ( value < 0 .and. value >= ::nMnozDokl_o )
      if lOK
        nMn := PrepocetMJ( value, ::dm:get( ::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )

        ::dm:set( ::IT + '->nMnozPrDod', nMn )
        nMn := KoefPrVC_MJ( ::dm:get( ::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )

        IF IsObject( ::dm:has( ::IT + '->nCenaDokl1' ))
          ::dm:set( ::IT + '->nCenNapDod', ::dm:get( ::IT + '->nCenaDokl1') / nMn )
        ENDIF
      else
        drgMsgBox(drgNLS:msg('Množství musí být < 0  a vìtší nebo rovno ' + alltrim(str(::nMnozDokl_o))+ ' !'), XBPMB_WARNING )
      endif
    ENDIF

  CASE ( NAME = ::IT + '->cMJDokl1')
    nMn := PrepocetMJ( ::dm:get( ::IT + '->nMnozDokl1'), value, CenZboz->cZkratJedn, 'CenZboz' )

    ::dm:set( ::IT + '->nMnozPrDod', nMn )
    nMn := KoefPrVC_MJ( ::dm:get( ::IT + '->cMJDokl1'), CenZboz->cZkratJedn, 'CenZboz' )

    IF IsObject( ::dm:has( ::IT + '->nCenaDokl1' ))
      ::dm:set( ::IT + '->nCenNapDod', ::dm:get( ::IT + '->nCenaDokl1') / nMn )
    ENDIF
    IF IsObject( ::dm:has( ::IT + '->nCenNaDoZM' ))
      ::dm:set( ::IT + '->nCenNapDod', ::dm:get( ::IT + '->nCenNaDoZM')* ( PVPHEADw->nKurZahMen / PVPHEADw->nMnozPrep) / nMn )
    ENDIF

  CASE ( name = ::IT+'->NCENAZAKL')   // Základní PC bez danì
    nDPH := SeekKodDPH( ::dm:get( ::IT+'->nKlicDPH') )
    ::dm:set('M->nCenaMZBO', ::dm:get( NAME) * (1 + nDPH/100) )
    lOK := SKL_ProdCENA( ::dm:get(::IT+'->nCenaZakl') )

  CASE ( name = 'M->nCenaMZBO')   // PC s daní
    nDPH := SeekKodDPH( ::dm:get( ::IT+'->nKlicDPH') )
    ::dm:set(::IT+'->nCenaZakl', ::dm:get( name) / (1 + nDPH/100) )
    lOK := SKL_ProdCENA( ::dm:get('M->nCenaMZBO'))

  CASE ( name = ::IT+'->nHodnSlev')
    ::dm:set(::IT+'->nProcSlev', ::dm:get( name) / ::dm:get(::IT+'->nCenaZakl') * 100)

  CASE ( name = ::IT+'->nProcSlev')
    ::dm:set(::IT+'->nHodnSlev', ::dm:get(::IT+'->nCenaZakl') * ( ::dm:get( name)/ 100))

  CASE ( NAME = ::IT + '->cSkladKAM')
    lOK := ::SKL_C_Sklad()

  CASE ( NAME = ::IT + '->cSklPolKAM')
    lOK := SKL_PrevodOK_( ::dm)

  CASE ( NAME = ::IT+'->nUcetSkKAM')
    IF( lOK := ::SKL_C_UctSkp() )
      drgDBMS:open('CENZBOZ',,,,, 'CenZBOZw' )
      cKEY := Upper(::dm:get( ::IT+'->cSkladKAM')) + Upper(::dm:get(::IT+'->cSklPolKAM'))
      IF CenZBOZw->( dbSEEK( cKEY,,'CENIK03'))
        IF Value <> CenZBOZw->nUcetSkup
          drgMsgBox(drgNLS:msg('Pøevod nelze uskuteènit na položku s jinou úèetní skupinou !'), XBPMB_WARNING )
          lOK := .F.
        ENDIF
      ENDIF
      CenZBOZw->( dbCloseArea())
    ENDIF

  CASE ( NAME = ::IT+'->cText')

  CASE ( NAME = ::IT+'->nKlicDPH')  // u karty 3
    nDPH := SeekKodDPH( ::dm:get( Name) )

  CASE ( NAME = ::IT+'->nCenaPZBO')   // PC bez danì
    IF( lOK := ControlDUE( oVar) )
      nDPH := SeekKodDPH( CenZboz->nKlicDPH)
      ::dm:set(::IT+'->nCenaPDZBO', ::dm:get( NAME) * (1 + nDPH/100) )
    ENDIF

  CASE ( NAME = ::IT+'->nCenaPDZBO')   // PC s daní
    IF( lOK := ControlDUE( oVar) )
      nDPH := SeekKodDPH( CenZboz->nKlicDPH )
      ::dm:set(::IT+'->nCenaPZBO', ::dm:get( NAME) / (1 + nDPH/100) )
      ::dm:set(::IT+'->nCenNapDod', ::dm:get( ::IT+'->nCenaPZBO'))
    ENDIF

  CASE ( NAME = 'M->nMarzRabat')
    nDPH := SeekKodDPH( CenZboz->nKlicDPH)
    IF ::nKarta = 111
    ELSEIF ::nKarta = 116
      nPom      := ::dm:get(::IT+'->nCenaPDZBO') * (1 - ( Value / 100))
      nOldDecim := Set( _SET_DECIMALS, 6 )
      nKoef     := nDph / ( 100 + nDph )
      Set( _SET_DECIMALS, nOldDecim )
      nCenasZBO := Round( nPom - ( nPom * nKoef ), nDecimal )
      ::dm:set(::IT+'->nCenNapDod', nCenaSZBO )
    ENDIF

  CASE ( NAME = ::IT+'->NCENAZAKL')   // Základní PC bez danì
    nDPH := SeekKodDPH( ::dm:get( ::IT+'->nKlicDPH') )
    ::dm:set('M->nCenaMZBO', ::dm:get( NAME) * (1 + nDPH/100) )
    lOK := SKL_ProdCENA( ::dm:get(::IT+'->nCenaZakl') )

  CASE ( NAME = 'M->nCenaMZBO')   // PC s daní
    nDPH := SeekKodDPH( ::dm:get( ::IT+'->nKlicDPH') )
    ::dm:set(::IT+'->nCenaZakl', ::dm:get( NAME) / (1 + nDPH/100) )
    lOK := SKL_ProdCENA( ::dm:get('M->nCenaMZBO'))

  CASE ( NAME = ::IT+'->nHodnSlev')
    ::dm:set(::IT+'->nProcSlev', ::dm:get( NAME) / ::dm:get(::IT+'->nCenaZakl') * 100)

  CASE ( NAME = ::IT+'->nProcSlev')
    ::dm:set(::IT+'->nHodnSlev', ::dm:get(::IT+'->nCenaZakl') * ( ::dm:get( NAME)/ 100))

  CASE ( NAME = ::IT+'->cnazpol3')
    lOK := ! ::ZakUKONC( 7, value )
    *
    ** výdej na zakázku, pokud existují položky v vyrZakit tak je nabídneme
    if lok .and. ::nkarta = 204
      * obecnì a Elektrosvit
      if .not. Empty( value)
        ::skl_vyrzakit_sel(value)
      endif
    endif

  CASE ( NAME = ::IT+'->cnazpol6')
  CASE ( NAME = ::IT+'->nInvCisDim')
  EndCase

  *
  IF  Name $ UPPER(::IT+'->nKlicDPH,'+::IT+'->nMnozPrDOD,'+::IT+'->nCenaZakl,M->nCenaMZBO,'+::IT+'->nHodnSlev,'+::IT+'->nProcSlev')

    nDph := if( isObject( ::dm:has( ::IT+'->nKlicDPH')), SeekKodDPH( ::dm:get( ::IT+'->nKlicDPH') ),;
                                                         SeekKodDPH( CenZboz->nKlicDPH) )
    ::ReCompute( name  ,;
                   ::dm:get(::IT+'->nMnozPrDOD'),;
                   ::dm:get(::IT+'->nCenaZakl' ),;
                   ::dm:get('M->nCenaMZBO')     ,;
                   ::dm:get(::IT+'->nHodnSlev' ),;
                   nDPH    )
  ENDIF
RETURN lOK

********************************************************************************
METHOD SKL_POHYBYIT:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x, drgVar

  begin sequence
  for x := 1 to size step 1
    drgVar := values[x,2]
    if drgVar:odrg:isEdit
      if .not. ::postValidate( drgVar)
        return .f.
  break
      endif
    endif
  next
  end sequence
RETURN .t.


**HIDDEN************************************************************************
METHOD SKL_POHYBYIT:SaveCardIT( nKEY)
  LOCAL  mp1, mp2, oXbp, nEvent, cKey, cErr := '???', lOK , o
  local  ctext
  *
  local  file_iv   := alltrim(::dm:has(::it +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it +'->nrecs_iv'):value
  local  lnewRec   := ( nkey = xbeK_INS )
  local  intCount  := (::it)->nordItem
  local  hd_typPoh := (::hd)->ntypPoh

  * Kontrola na NS
  IF !(lOK := ::ControlNS())
    RETURN .F.
  ENDIF
  *
//  ::hd_udcp:nwds_sign := if( hd_typPoh = 1, +1, -1 )
//  ::hd_udcp:wds_watch_mnoz( lnewRec, intCount )

  *
  if( nkey = xbeK_INS,  mh_copyfld( ::HD, ::IT ), nil )
  ::dm:save()

  if lnewRec .and. .not. empty(file_iv)
    (::it)->cfile_iv := file_iv
    (::it)->nrecs_iv := recs_iv
  endif


  IF nKEY = xbeK_INS
// js     mh_copyfld( ::HD, ::IT )
*    (::IT)->nOrdItem   := ::ordItem() + 1
    (::IT)->cSklPol    := CenZboz->cSklPol
    (::IT)->cNazZBO    := CenZboz->cNazZBO
    (::IT)->nKlicDPH   := CenZboz->nKlicDPH

    (::IT)->nUcetSkup  := CenZboz->nUcetSkup
    (::IT)->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
    (::IT)->cZkratMENY := CenZboz->cZkratMENY
    (::IT)->cZkratJedn := CenZboz->cZkratJedn
    (::IT)->nKlicNAZ   := CenZboz ->nKlicNaz
    (::IT)->nZboziKAT  := CenZboz ->nZboziKAT
    (::IT)->cPolCen    := CenZboz->cPolCen
    (::IT)->cTypSKP    := CenZboz->cTypSKP
    (::IT)->cUctovano  := ' '
    (::IT)->nTypPOH    := IIF( (::HD)->nKARTA < 200,  1,;
                          IIF( (::HD)->nKARTA < 300, -1,;
                          IIF( (::HD)->nKARTA = 400,  1, 0 )))
    (::IT)->cCisZakaz  := IF( EMPTY( (::IT)->cNazPol3), (::IT)->cCisZakaz, (::IT)->cNazPol3 )
    (::IT)->cCisZakazI := (::IT)->cCisZakaz
    (::IT)->cCasPVP    := time()
    (::IT)->nRec_CenZb := CenZboz ->( RecNo())
    (::IT)->_nRecor    := 0

    IF PVPITEMww->nrec_Term <> 0

       * pøi zápisu položky z terminálu se tato vylouèí z nabídky seznamu (záložka  "Z terminálu")
       PVPTERM->( dbGoTo( PVPITEMww->nrec_Term))

       IF PVPTERM->( RLock())

         if ::nkarta = 305
           pvpitemWW->nmnozDokl1 := pvpitemWW->nmnozPRdod
         endif


         PVPTERM->nMnoz_PLN += (::IT)->nMnozDokl1
         PVPTERM->nStav_PLN := IF( PVPTERM->nMnoz_PLN > 0 .and. PVPTERM->nMnoz_PLN < PVPTERM->nMnozDokl1, 1,;
                                IF( PVPTERM->nMnoz_PLN = PVPTERM->nMnozDokl1, 2, 0))

         pvpTerm->dzmenaZazn := date()

         ctext   := 'mnoz_pln = ' +str( (::it)->nmnozDokl1) +' -> pvp_doklad = ' +str( (::hd)->ndoklad )
         mh_wrtZmena( 'pvpTerm',,, ctext )

         PVPTERM->( dbRUnlock())

******* js není v DBD ?        (::it)->nPVPTERM := pvpTerm->sID
       ENDIF
    ENDIF
    *
    mh_WRTzmena( ::IT, .T.,)
    *
    IF( ::nKARTA = 400, mh_COPYFLD('CENZBOZ', ::IT ), NIL )
  ENDIF
*/***---

  DO CASE
    CASE ( nPos := ASCAN( { 100,110,120,130, 116, 117 }, ::nKARTA)) > 0
      *
      IF IsObject( ::dm:has(::IT +'->cCisObj' ))
        (::IT)->cCisObj    := ::dm:get(::IT + '->cCisObj')
        (::IT)->nCisloOBJV := ::dm:get(::IT + '->nCisloOBJV')
      ENDIF
      */
      (::IT)->nCenaCelk := MH_RoundNumb( (::IT)->nMnozPrDod * (::IT)->nCenNapDod, 12)
      If PVPHead->nKarta == 117    // Pøíjem v Zahr.mìnì
        (::IT)->nCenCelkZM := MH_RoundNumb( (::IT)->nMnozDokl1 * (::IT)->nCenNaDoZM, 12)
      Endif

      * Objedn.vystavená
      IF ! EMPTY( (::IT)->cCisObj )   // .AND. PVPItem->nIntCount > 0

*          anMnR := ObjVyst_R( nKEY, PVPItem->nMnozPrDod )
        IF( nKEY = xbeK_INS )
          (::IT)->nIntCount  := ObjVysIT->nIntCount
          (::IT)->nMnozPoODB := ObjVysIT->nMnozPoDOD  // potvrzeno dodavatelem
        ENDIF
      ENDIF

      nSumaItem := NutneVN()    //( nKEY, PVPItemww->( RecNo()),.t. )

    CASE ( nPos := ASCAN( { 203,253,263,283,293 }, ::nKARTA)) > 0

      (::IT)->nKlicDph    := ::dm:get('PVPITEM->nKlicDph' )
      ::nProcDph := SeekKodDPH( (::IT)->nKlicDph )
      nKoefMn := IIF( CenZboz->nKoefMn <> 0,;
                 IIF( nKoefMn <> 0 , nKoefMn, CenZboz->nKoefMn ), 1 )
      (::IT)->nMnozPrKOE  := (::IT)->nMnozPrDod
      (::IT)->nMnozPrDod  := (::IT)->nMnozPrDod * nKoefMn
      (::IT)->nKoefMn     := nKoefMn
      (::IT)->nHodnSlev   := ::dm:get( ::IT+'->nHodnSlev')
      (::IT)->nProcSlev   := ::dm:get( ::IT+'->nProcSlev')
      (::IT)->nCenaZakl   := ::dm:get( ::IT+'->nCenaZakl')
* ?      PVPItem->nProcSlMn   := nProcSl
      (::IT)->nCelkSlev   := (::IT)->nHodnSlev * (::IT)->nMnozPrDod
      (::IT)->nCenapZBO   := (::IT)->nCenaZakl - (::IT)->nHodnSlev
      (::IT)->nCenapDZBO  := (::IT)->nCenapZbo * ( 1 + ( ::nProcDph / 100 ))
      (::IT)->nCenNapDOD  := CenZboz->nCenasZBO
      (::IT)->nCenaCelk   := Mh_RoundNumb( (::IT)->nMnozPrKOE *  (::IT)->nCenNapDod, 32 )
* ?      PVPItem->nIntCount   := ::nOrdItem
* ??     PVPItem->cCislObINT  := space( 15)
* ?     PVPItem->nPodilProd  := If( Empty( PVPItem->cZkrProdej), 0, nPodilProd )
      (::IT)->cCisZakaz  := ::dm:get( ::IT+'->cNazPol3')
      (::IT)->cCisZakazI := (::IT)->cCisZakaz

      If !EMPTY( (::IT)->cCislObINT) // Výdej o OBJ   // cAlias == 'OBJITEM'
        IF( nKEY = xbeK_INS )
          (::IT)->nMnozPoODB  := ObjItem->nMnozPoODB
          (::IT)->nMnozReODB  := ObjItem->nMnozReODB
          (::IT)->nMnozKobje  := ObjItem->nMnozKoDod
          (::IT)->nMnozVpInt  := ObjItem->nMnozVpInt
          (::IT)->cCisZakaz   := If( (::HD)->nKarta == 293, ObjItem->cCislObINT, (::IT)->cCisZakaz )
          (::IT)->cCisZakazI  := (::IT)->cCisZakaz
        ENDIF
      ENDIF

    *
    CASE ( nPos := ASCAN( { 204,244,274,206 }, ::nKARTA)) > 0
      IF( nKEY = xbeK_INS )
        (::IT)->nCenNapDod := CenZboz->nCenasZBO
        (::IT)->nCenapZBO  := CenZboz->nCenapZBO
        (::IT)->NCISLPOLOB := OBJITEM->NCISLPOLOB
      ENDIF
      (::IT)->nCenaCelk  := ::nCelkITEM  // MH_RoundNumb( PVPItem->nMnozPrDod * PVPItem->nCenNapDod, 32)
      (::IT)->cCisZakaz  := ::dm:get( ::IT +'->cNazPol3')  // PVPITEM->cNazPol3
      (::IT)->cCisZakazI := (::IT)->cCisZakaz
      IF ::nKARTA = 274
        (::IT)->cCislObInt := ::dm:get( ::IT + '->cCislObInt')
        (::IT)->cNazPol1   := ::dm:get(::IT + '->cNazPol1')
        ::LastCislObInt     := (::IT)->cCislObInt
      ENDIF
      IF !EMPTY( (::IT)->cCislObINT) // Výdej z OBJITEM
        IF( nKEY = xbeK_INS )
           (::IT)->nMnozPoODB  := ObjItem->nMnozPoODB
           (::IT)->nMnozReODB  := ObjItem->nMnozReODB
           (::IT)->nMnozKobje  := ObjItem->nMnozKoDod
           (::IT)->nMnozVpInt  := ObjItem->nMnozVpInt
           (::IT)->cCisZakaz   := If( (::HD)->nKarta = 274, ObjItem->cCislObINT, (::IT)->cCisZakaz )
           (::IT)->cCisZakazI  := (::IT)->cCisZakaz
        ENDIF
      ENDIF
    *
    CASE ( nPos := ASCAN( { 205 }, ::nKARTA)) > 0  // Výdej do DKP (DIMu)
      (::IT)->nCisFak    := ::nFakPriDim
      (::IT)->nCenNapDod := CenZboz->nCenaSZBO
      SKL_VydejDKP_SAVE( nKEY,,,::drgDialog )

    *
    CASE ( nPos := ASCAN( { 305 }, ::nKARTA)) > 0  // Pøevod
      SKL_Prevod_SAVE_( ::drgDialog, nKEY )

    *
    CASE ( nPos := ASCAN( { 400 }, ::nKARTA)) > 0  // Pøecenìní
      (::IT)->nTypPoh    := 1
      * Pùvodní cena skladová je zapsána do významovì jiné položky ( nCelkSlev)
      (::IT)->nCelkSLEV  := CENZBOZ->nCenaSZBO
      (::IT)->nMnozPrDod := CENZBOZ->nMnozSZBO
      (::IT)->nCenaCZBO  := (::IT)->nCenNapDod * (::IT)->nMnozPrDod  // ::dm:get('PVPITEM->nCenaCZBO')
      (::IT)->nCenaCelk  := ((::IT)->nCenNapDod - CENZBOZ->nCenaSZBO) * (::IT)->nMnozPrDod // ::dm:get('PVPITEM->nCenaCelk')
      * Hodnoty v CenZboz po zmìnì
      (::IT)->nMnozSZBO  := CenZboz->nMnozSZBO
      */
  ENDCASE
  *
  ::uHd:DokladCELKEM()
  ::SaveNS()
  *
  ::uHd:set_SaveBut( 1)
  *
  ::dm:refresh()
  IF nKEY = xbeK_INS
    ::uHd:broIT:oXbp:goBottom()
  ENDIF
  ::uHd:broIT:oXbp:refreshAll()

  * Evidence výrobních èísel
  IF ( lVyrCis := ( Upper( CenZboz->cVyrCis) $ 'ABC' ))
    cQuestion := IF( nKey = xbeK_INS, 'Evidovat ', 'Opravit ') + 'výrobní èísla ?'
    IF drgIsYESNO(drgNLS:msg( cQuestion ))
      ::VyrCis_Modi( nKey )
    ENDIF
  ENDIF
  *
  ::MistaULOZ( nKey)
  ::uHd:sumcolumn()

///  ::hd_udcp:wds_watch_time()
RETURN lOK



********************************************************************************
METHOD SKL_POHYBYIT:SaveAndIns()
  Local  lOK, x, drgVar, cTypVal
  local  recNo := cenZboz->( recNo())
  *
  local  pa_mnoz := ::pa_mnozDokl1

  * Pokud pøi poøízení v cyklu dá ALT+U nad pøidaným prázdným záznamem
  IF EMPTY( ::dm:get( ::IT + '->cSklPOL'))
    (::IT)->_delrec := '9'
    PostAppEvent(xbeP_Close,,, ::drgDialog:dialog )
    RETURN .F.
  ENDIF
  *
**1.4.2010  IF lOK := ::df:postValidateForm()
**  IF lOK := ::postValidateForm()
    * Save

    if ::newIt .and. ::nkarta = 204 .and. len(pa_mnoz) <> 0
      for x := 1 to len(pa_mnoz) step 1
        ::dm:set('pvpitemww->nmnozDokl1', pa_mnoz[x,2] )
        ::dm:set('pvpitemww->nmnozPrDod', pa_mnoz[x,3] )
        ::dm:set('M->ncelkItem'         , pa_mnoz[x,4] )
        ::dm:set('M->ncelkDokl'         , pa_mnoz[x,5] )
        ::dm:set('pvpitemww->cnazPol3'  , pa_mnoz[x,6] )

        ::ncelkItem := pa_mnoz[x,4]
        ::ncelkDokl := pa_mnoz[x,5]

        if x <> 1
          (::it)->( dbAppend())
          ::dm:set( 'pvpitemww->nordItem', ::ordItem() + 1 )
          ::clear_initValue()
        endif

        lOK := ::SaveCardIT( If( ::newIT, xbeK_INS, xbeK_ENTER ))
      next
    else

      lOK := ::SaveCardIT( If( ::newIT, xbeK_INS, xbeK_ENTER ))
    endif


    * Ins
    IF lOK
      ::ClearVarIT()
*      ::newit := .t.
      *
      for x := 1 to ::dm:vars:size()
        drgVar := ::dm:vars:getNth(x)
        if ISCHARACTER( ::uHD:cCrd)
          ok := (empty(drgVar:odrg:groups) .or. ::uhd:cCrd $ drgVar:odrg:groups  ) .and.;
                 at('NAZ_POLDOKLAD',drgVar:name) = 0
        endif
        If ok
          cTypVal := ValType(drgVar:value)
          drgVar:initValue := drgVar:prevValue := drgVar:value := If( cTypVal = 'C', '',;
                                                                  If( cTypVal = 'N', 0 ,;
                                                                  If( cTypVal = 'D', CTOD('  .  .  '), '' )))
        EndIf
      next
      *
// js      ::df:setNextFocus( ::cNameIT,, .T. )
      ::dm:set( ::IT + '->CNAZZBO'   , '' )
      ::dm:set( ::IT + '->nOrdItem'  , ::ordItem() + 1 )
      ::setNS()
      *
      ::dm:refresh()
      cenZboz->( dbgoTo( recNo ))

*      ::uHd:broIT:oXbp:goBottom()
*      ::uHd:broIT:oXbp:refreshAll()
      if( ::newit, ::uhd:broit:oxbp:gobottom():refreshAll(), ::uhd:broit:oxbp:refreshCurrent())

// js      IF ::newIT
// js       ::uHd:broIT:oXbp:goBottom()
// js     ENDIF
// js      ::uHd:broIT:oXbp:refreshAll()

      *
      ::SetEditIT()          //  Nastavení editace položkové karty
      ::FirstEditIT()        //  Nastaví 1.editaèní položky v kartì
      *
      if !::newIT            // pro pøípad, že opravoval položku a uložil tl. "Uložit+nová"
        ::nRecEnter := PVPITEMww->( RecNo())
      endif
      ::newit := .t.
      (::IT)->( dbAppend())
    ENDIF
**  ENDIF
RETURN lOK


* Výbìr skl.položky z CenZboz - ceníku zboží
********************************************************************************
METHOD SKL_POHYBYIT:SKL_CENZBOZ_SEL( Dialog)
  LOCAL  oDialog, nExit, nPos
  Local  cCisObj:= ::dm:get( ::IT + '->cCisObj')
  Local  cCisSklad := If( Empty( cCisObj), ::uHD:mainSKLAD, ObjVysIt->cCisSklad )
  Local  drgVar := ::dm:get( ::IT + '->cSklPol', .F.)
  Local  value  := Upper( drgVar:get())
  Local  lOk, nProcSl := 0, Filter, nDoklad_o, cScope, cTag
  local  flt_cenZboz
  *
  local  mnozDokl1 := isNull(::dm:get( ::IT + '->nMnozDokl1' ), 0)
  local  mnozPrDod := isNull(::dm:get( ::IT + '->nMnozPrDod' ), 0)
  local  mnoz_Org  := max( mnozDokl1, mnozPrDod)
  *
  local  odrg_ckatCZbo, cky

* Nad cSklPol musí být výbìr z položek výdejového dokladu
  IF ::nKarta = 299
    lOK := .F.
    cTag := PVPITEM->( OrdSetFocus())
    cScope := PVPITEM->( dbScope( 1))
    if( isnil( cScope), nil, PVPITEM->( mh_ClrScope()) )

    nDoklad_o := ::dm:get( ::IT + '->nDoklad_o')
    Filter := Format("nDoklad = %%", { nDoklad_o } )
    PVPITEM->( mh_SetFilter( Filter))

    IF IsObject( Dialog) .or. !lOk
     DRGDIALOG FORM 'SKL_VYDEJKY_IT_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
    ENDIF

    IF nExit = drgEVENT_SELECT   //.or. lOk
      lOK := .T.
      ::dm:set( ::IT + '->cSklPol', PVPITEM->cSklPol )
      ::dm:set( ::IT + '->CNAZZBO', PVPITEM->cNazZBO )
      *
      ::nMnozDokl_o := PVPITEM->nMnozDokl1 * -1
      ::dm:set( ::IT + '->nOrdItem_o', PVPITEM->nOrdItem )
      ::dm:set( ::IT + '->nMnozDokl1', PVPITEM->nMnozDokl1 * -1 )
      ::dm:set( ::IT + '->cMJDokl1'  , PVPITEM->cMJDokl1  )
      ::dm:set( ::IT + '->nMnozPrDod', PVPITEM->nMnozPrDod * -1 )
      ::dm:set( ::IT + '->nCenNapDod', PVPITEM->nCenNapDod )
    ENDIF
    PVPITEM->( mh_ClrFilter( Filter))
    PVPITEM->( AdsSetOrder( cTag))
    if( isnil( cScope), nil, PVPITEM->( mh_SetScope( cScope)) )
    RETURN lOK
  ENDIF

  *
  ** cenZboz / pvpTerm
*  flt_cenZboz := Format("Upper(cCisSklad) = '%%'", { Upper( cCisSklad) } )
*
*  if .not. ( upper( flt_cenZboz) $ upper( cenZboz ->( ads_getAof())))
*    CenZboz->( mh_SetFilter( flt_cenZboz ), dbgoTop() )
*  endif

  flt_cenZboz := Format( "ccisSklad = '%%'", { ccisSklad } )
  cenZboz->( ads_setAof( flt_cenZboz ), dbgoTop() )


  lOk    := ( !Empty(value) .and. CENZBOZ->(dbseek( Upper(cCisSklad) + value,, 'CENIK03')))
  *
  Filter  := Format("Upper( PVPterm->cCisSklad) = '%%' .and. StrZero( PVPterm->nTypPVP, 1) = '%%' .and. PVPterm->nStav_PLN <> 2",;
                   { Upper( (::HD)->cCisSklad), StrZero( (::HD)->nTypPVP, 1) })
  PVPterm->( mh_SetFilter( Filter, -3))

  *
  If IsObject( Dialog) .or. !lOk

    ::lPrevzitTT    := .F.

    if( isMethod( ::dm:drgDialog, 'quickShow' ) .and. isObject( ::odialog_centerm ))
      odialog := ::odialog_centerm

      pvpTerm->( ads_setAof( ::cflt_pvpTerm ))
      odialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
      postAppEvent( xbeBRW_ItemMarked,,, odialog:dialogCtrl:oaBrowse:oxbp )

      odialog:quickShow(.t.)
    else
      odialog := drgDialog():new('SKL_centerm_SEL', ::drgDialog)
      odialog:set_prg_filter( flt_cenZboz, 'cenZboz')
      odialog:create(,,.T.)

      ::odialog_centerm := odialog
      ::cflt_pvpTerm    := pvpTerm->( ads_getAof())
    endif

          nexit := odialog:exitState
    ::recCenZbo := cenZboz->( recNo())

    ** Došlo k pøevzetí oznaèených záznamù do dokladu
    IF ::lPrevzitTT
      NutneVN()
      ::uHd:DokladCELKEM()
      ::uHd:sumcolumn()
      PostAppEvent(xbeP_Close,,,  ::uHD:broIt:oxbp )
    ENDIF
  ENDIF


  if nExit != drgEVENT_QUIT .or. lok
    *
    ** csklPol je OK a jen se podíval do ceníku
    if nexit = drgEVENT_QUIT .and. lok
      return .t.
    endif

    if ( ::drgDialog:cargo_usr = 1, ( ::ofile_iv:set('cenZboz'), ::orecs_iv:set(cenZboz->(recNo()) ) ), ;
                                    ( ::ofile_iv:set('pvpTerm'), ::orecs_iv:set(pvpTerm->(recNo()) ) )  )



    ok := .T.
    ::dm:set( ::IT + '->cSklPol', CenZboz->cSklPol )
    ::dm:set( ::IT + '->CNAZZBO', CENZBOZ->CNAZZBO )
    ::recCenZbo := CenZboz->( RecNo())
    *
    if ::drgDialog:cargo_usr = 1                               // výbìr ze záložky 1 - CENZBOZ
       if( cenZboz->csklPol <> value, mnoz_Org := 0, nil )
       ::dm:set( ::IT + '->nMnozDokl1', max( mnoz_Org, 0) )
    elseif ::drgDialog:cargo_usr = 2                           // výbìr ze záložky 2 - PVPTERM
      ::dm:set( ::IT + '->nMnozDokl1' , PVPTERM->nMnozDokl1 )  // pøednastaví se nasnímané mn.
      (::IT)->nRec_Term := PVPTERM->(RecNo())                  // uloží se vazba na PVPTerm
    endif
    *
    if ::drgDialog:cargo_usr = 2   // výbìr ze záložky 2 - PVPTERM
      if( (::IT)->nRec_Term <> 0, PVPTERM->( dbGoTo((::IT)->nRec_Term)), nil )
      * pøebere se NS
      if( isobject( ::dm:has( ::IT + '->cNazPol1')), ::dm:set( ::IT + '->cNazPol1', PVPTERM->cStredisko ), nil )
      if( isobject( ::dm:has( ::IT + '->cNazPol2')), ::dm:set( ::IT + '->cNazPol2', PVPTERM->cVyrobek   ), nil )
      if( isobject( ::dm:has( ::IT + '->cNazPol3')), ::dm:set( ::IT + '->cNazPol3', PVPTERM->cZakazka   ), nil )
      if( isobject( ::dm:has( ::IT + '->cNazPol4')), ::dm:set( ::IT + '->cNazPol4', PVPTERM->cVyrMisto  ), nil )
      if( isobject( ::dm:has( ::IT + '->cNazPol5')), ::dm:set( ::IT + '->cNazPol5', PVPTERM->cStroj     ), nil )
      if( isobject( ::dm:has( ::IT + '->cNazPol6')), ::dm:set( ::IT + '->cNazPol6', PVPTERM->cOperace   ), nil )
    endif
    *
*ORG    ::dm:set( ::IT + '->nMnozDokl1' , ::dm:get( ::IT + '->NMNOZPRDOD') )
    ::dm:set( ::IT + '->cMJDokl1'   , CENZBOZ->cZkratJedn )
    ::dm:set( ::IT + '->cZkratJedn' , CENZBOZ->cZkratJedn )
    *
    * Pøíjmy
    IF ( nPos := ASCAN( { 100,102,103,104,110,116,117,120,130,142 }, ::nKARTA)) > 0
      IF  ALLTRIM(STR(::nKARTA)) $ '100,102,110,120,130,142'
        IsEditGET( ::IT + '->NCENNAPDOD', ::drgDialog,;
                   Upper( CenZboz->cTypSklCen) = 'PRU' .AND. Upper( CenZboz->cPolCen) = 'C'  )
      ENDIF
      *
      IF  ALLTRIM(STR(::nKARTA)) $ '103,104'
*        IsEditGET( 'PVPITEM->NCENNAPDOD', ::drgDialog, ::nKARTA = 104 )
        ::dm:set(::IT + '->NCENNAPDOD', CENZBOZ->NCENAVNI)
        IF ! ( lOK := IF( ::nKARTA = 104, YES, CenZBOZ->nCenaVNI <> 0 ) )
          drgMsgBox(drgNLS:msg('Nelze pøijmout, je-li vnitrocena nulová !'), XBPMB_WARNING )
        ENDIF
      ELSEIF ::nKARTA = 116
        ::dm:set(::IT + '->NCENNAPDOD', 0)
      ELSEIF  ::nKARTA = 110 .and. !empty( ::dm:get(::IT + '->cCisObj'))
        * pokud byl pøíjem z obj.vyst. je cena již naplnìna
      ELSE
        ::dm:set(::IT + '->NCENNAPDOD', CENZBOZ->NCENASZBO  )
      ENDIF
      ::dm:set(::IT + '->NCENACELK' , ::dm:get(::IT + '->NCENNAPDOD') * ::dm:get(::IT + '->NMNOZPRDOD') )
    ENDIF
    *
    IF IsObject( ::dm:has(::IT + '->nCenaDokl1' ))
      IF  ::nKARTA = 110 .and. !empty( ::dm:get(::IT + '->cCisObj'))
        * pokud byl pøíjem z obj.vyst. je cena již naplnìna
      ELSE
        ::dm:set(::IT + '->NCENADOKL1', CENZBOZ->NCENASZBO)
      ENDIF
    ENDIF

    * Výdeje
    IF ( nPos := ASCAN( { 203,253,263,283,293 }, ::nKARTA)) > 0
      ::dm:set(::IT + '->nKlicDPH'   , CENZBOZ->NKLICDPH )
      ::dm:set(::IT + '->nCenaZakl'  , CENZBOZ->NCENAPZBO)
      ::dm:set('M->nCenaMZBO'        , CENZBOZ->NCENAMZBO)

      * nProcSl :=  ... SLEVY !?!
      IF( ::dm:get(::IT + '->nProcSlev')  = 0, ::dm:set(::IT + '->nProcSlev' , nProcSl)             , NIL )
      IF( ::dm:get(::IT + '->nHodnSlev')  = 0, ::dm:set(::IT + '->nHodnSlev' , CENZBOZ->NCENAPZBO * nProcSl/100), NIL )
      ::ReCompute( ::IT + '->cSklPol' ,;
                   1,;
                   CENZBOZ->NCENAPZBO ,;
                   CENZBOZ->NCENAMZBO ,;
                   ::dm:get(::IT + '->nHodnSlev' ),;
                   SeekKodDPH(CenZBOZ->nKlicDPH)   )

*      IF( EMPTY( dm:get('PVPITEM->cZkrProdej')), dm:set('PVPITEM->cZkrProdej', TypValidProd() )              , NIL )
    ENDIF
    *
    IF ( nPos := ASCAN( { 204,244,274, 206 }, ::nKARTA)) > 0
*      ::dm:set('M->nCelkITEM' , ::dm:get('CenZBOZ->NCENASZBO') * ::dm:get('PVPITEM->NMNOZPRDOD') )
*      ::dm:set('M->NCELKDOKL' , ::dm:get('CenZBOZ->NCENASZBO') * ::dm:get('PVPITEM->NMNOZPRDOD') )
      ::dm:set(::IT + '->NCENNAPDOD', CENZBOZ->NCENASZBO  )
      ::dm:set('M->nCelkITEM' , ::nCelkITEM := CenZBOZ->NCENASZBO * ::dm:get(::IT + '->NMNOZPRDOD') )
      ::dm:set('M->NCELKDOKL' , ::nCelkDOKL + ::nCelkITEM )

    endif
    * Pøevod do DIMu
    IF ( nPos := ASCAN( { 205 }, ::nKARTA)) > 0
*      (::IT)->CNAZZBO := CENZBOZ->CNAZZBO
      ::dm:set('M->cNazDIMu', ::cNazDIMu := CENZBOZ->CNAZZBO )
      ::dm:set( ::IT + '->nMnozPrDod', 1  )
      ::dm:set( ::IT + '->nInvCisDim', ::newInvCis(0))
    endif

    * Pøevod
    if ( nPos := ASCAN( { 305 }, ::nKARTA)) > 0
      ::dm:set(::IT + '->cSklPolKAM' , CenZBOZ->cSklPol   )
      ::dm:set(::IT + '->nUcetSkKAM' , CenZBOZ->nUcetSkup )

      ::dm:set( 'M->cen_ucetSkup' , cenZboz->cucetSkup )
      ::dm:set( 'M->cen_mnozSZbo' , cenZboz->nmnozSZbo )
    endif
    * Pøecenìní
    IF ::nKARTA == 400
      ::dm:set(::IT + '->nCelkSlev' , CenZBOZ->nCenaSZBO)
    ENDIF

    *
    ** dotažení ckatCZbo
    if isObject( odrg_ckatCZbo := ::dm:get( ::IT + '->ckatCZbo', .f.) )
      cky := strZero( (::HD)->ncisFirmy,5) +upper( ::dm:get( ::HD +'->ccisSklad')) + ;
                                            upper( ::dm:get( ::IT +'->csklPol'))

      dodZboz->( dbseek( cky,,'DODAV6' ))
      odrg_ckatCZbo:set( dodZboz->ckatCZbo )
    endif
  ENDIF
  *
***  IsEditGET( 'M->cKatcZBO', ::drgDialog, CENZBOZ->cKatalCis = 'A' )
  isEditGet( ::IT +'->cKatcZBO', ::drgDialog, CENZBOZ->cKatalCis = 'A' )
  *
  PVPterm->( mh_clrFilter())
RETURN lOK



* Výbìr skl.položky z OBJVYSIT - obj. vystavených, do pøíjmového dokladu
* 110, 116, 117
********************************************************************************
method SKL_pohybyit:SKL_objVysit_SEL( Dialog)
  local oVar
  Local lVyrCis, lDodExist, cMENA, nCenNapDOD
  Local cFilter, n := 0
  Local value := Upper( ::dm:get(::IT + '->cCisObj'))
  Local nIntCount := ::dm:get(::IT + '->nIntCount')
  Local cKEY  :=  STRZERO( (::HD)->nCisFirmy, 5)+ PADR(value, 15)
  Local ok, nrecObj
  *
  local  odialog, nexit
  local  removeRecs := {}
  local  cf         := "ncisFirmy = %% .and. ccisSklad = '%%' .and. (nmnozOBdod -nmnozPLdod) > 0"

  ObjVysIT->( mh_ClrFilter())
  cKEY +=  StrZERO( nIntCount, 5)  //+ '00001'
  ok   := ( !Empty(value) .and. ObjVysIT->(dbseek( cKEY,,'OBJVYSI1')))
  If ok
    nRecOBJ := ObjVysIT->( RecNO())
  EndIf

  fordRec( { 'pvpitemww' } )
  pvpItemww->( dbeval( { || if( objVysit->( dbseek(pvpItemww->nobjVysit,,'ID')) .and.                        ;
                              (( objVysit->nmnozOBdod - objVysit->nmnozPLdod ) -pvpItemww->nmnozPRdod) <= 0, ;
                                aadd( removeRecs, objVysit->(recNo()) ), nil )                            }, ;
                       { || pvpItemww->nobjVysit <> 0 } ))
  fordRec()

  IF IsObject( Dialog) .or.  !Ok
    cfilter := format( cf, { (::hd)->ncisFirmy, (::hd)->ccisSklad } )
    objVysit->( ads_setAof(cfilter), dbgoTop() )
    if( len(removeRecs) <> 0, objVysit->(ads_customizeAof(removeRecs,2)), nil )

    odialog := drgDialog():new( 'SKL_OBJVYSIT_SEL', ::drgDialog)
    odialog:cargo_usr := removeRecs
    odialog:create(,,.T.)

    nexit := odialog:exitState

    objVysit->( ads_clearAof())
  ENDIF

  IF nExit = drgEVENT_SELECT // nExit != drgEVENT_QUIT
    *
    IF OBJVYSIT->( EOF()) .or. OBJVYSIT->( BOF())
       drgMsgBox(drgNLS:msg( 'Žádné objednávky nejsou k dispozici ...' ))
       RETURN .F.
    ENDIF
    *
    OK := .T.
    nRecOBJ := ObjVysIT->( RecNO())
    ::dm:set(::IT + '->CCISOBJ'    , OBJVYSIT->CCISOBJ )
    ::dm:set(::IT + '->NINTCOUNT'  , OBJVYSIT->NINTCOUNT )
    ::dm:set(::IT + '->nCisloOBJV' , OBJVYSIT->NDOKLAD )
    ::dm:set(::IT + '->CSKLPOL'    , OBJVYSIT->CSKLPOL )
    *
    ::dm:set(::IT + '->CNAZZBO'    , OBJVYSIT->CNAZZBO )
    ::dm:set(::IT + '->nMnozPrDOD' , OBJVYSIT->nMnozObDod )   // 19.8.
    *
    ::dm:set(::IT + '->nCenaDokl1' , OBJVYSIT->nCenNaODOD )
    ::dm:set(::IT + '->nMnozDokl1' , ::dm:get(::IT + '->NMNOZPRDOD') )
    ::dm:set(::IT + '->cMJDokl1'   , OBJVYSIT->cZkratJedn )
    ::dm:set(::IT + '->cZkratJedn' , OBJVYSIT->cZkratJedn )
    *
    ( ::ofile_iv:set('objvysit'), ::orecs_iv:set(objvysit->(recNo()) ) )
    (::it)->nOBJVYSIT := isNull(objVysit->sID,0)

**19.8.   IF( ::dm:get('PVPITEM->NMNOZPRDOD') = 0, ::dm:set('PVPITEM->NMNOZPRDOD' , setMNDOKLAD ), NIL )

    IF ::dm:get(::IT + '->NCENNAPDOD') = 0
      CENZBOZ->( dbSEEK( ::uHD:mainSklad + Upper(OBJVYSIT->CSKLPOL),,'CENIK03' ))

      lVyrCis := ( Upper( CenZboz->cVyrCis) $ 'ABC' )
      cKey := StrZero( PVPHead->nCisFirmy, 5) + Upper( ObjVysIT->cSklPol)
      lDodExist := DodZboz->( dbSeek( cKey,, 'DODAV4'))
      ObjVysHD->( AdsSetOrder(2))
      ObjVysHD->( dbSEEK( StrZERO( ObjVysIT->nCisFirmy, 5) + Upper( ObjVysIT->cCisObj),, 'OBJDODH2' ))
      cMena := UPPER( ObjVysHD->cZkratMeny)
      IF ( ( cMena <> '   ' .and. cMena <> 'CZK' ) .or. Upper(CenZboz->cTypSklCen) == 'PEV')
        nCenNapDOD := CenZboz->nCenaSZBO
      ELSEIF ObjVysIT->nCenNaODOD = 0
        nCenNapDOD := CenZboz->nCenaSZBO
      ELSE
        nCenNapDOD := ObjVysIT->nCenNaODod
      ENDIF
      ::dm:set(::IT + '->NCENNAPDOD', nCenNapDod )
*      dm:set('PVPITEM->NCENACELK',  dm:get('PVPITEM->NCENNAPDOD') * dm:get('PVPITEM->NMNOZPRDOD') )
*      FOrdREC()
    ENDIF
    IF( ::dm:get(::IT + '->NCENACELK' ) = 0,;
        ::dm:set(::IT + '->NCENACELK', ::dm:get(::IT + '->NCENNAPDOD') * ::dm:get(::IT + '->NMNOZPRDOD') ), NIL )
  ENDIF
  *
  IF nExit = drgEVENT_QUIT
    ::dm:set(::IT + '->CCISOBJ',  '' )
  ENDIF
RETURN OK


* Výbìr skl.položky z OBJITEM - obj. pøijatých, do výdejového dokladu
* 253, 255, 305, 274
********************************************************************************
METHOD SKL_POHYBYIT:SKL_OBJITEM_SEL(Dialog)
  LOCAL lMnNevyd
  Local nFirma := IF( ::nKarta = 274 .or. ::nKarta = 293, 1, (::HD)->nCisFirmy)
  Local cFilter, n := 0
  Local drgVar := ::dm:get( ::IT + '->cCislObINT', .F.)
  Local value := Upper( ::dm:get(::IT + '->cCislObINT'))
  Local nCislPolOb := ::dm:get(::IT + '->nCislPolOb')
  *
  Local cKEY  :=  STRZERO( nFirma, 5)+ PADR(value,30)
  Local ok, okPos, nRecObj, nMnozPlOdb := 0
  *
  local  odialog, nexit
  local  removeRecs := {}
  *
  ** Hydrap specifikum crozATRpro <> ROK ostatním by to nemìlo vadit, ale musel se upravit filtr
  local cf := "ncisFirmy = %% .and. (nmnozObODB -nmnozPlOdb) > 0 .and. upper(crozATRpro) <> 'ROK'"

  cKEY :=  STRZERO( nFirma, 5)+ PADR(value,30) + StrZERO( nCislPolOb, 5)  //+ '00001'
  ok   := ( !Empty(value) .and. ObjITEM->(dbseek( cKEY,,'OBJITE10')))

  fordRec( { 'pvpitemww' } )
  pvpItemww->( dbeval( { || if( objItem->( dbseek(pvpItemww->nobjItem,,'ID')) .and.                         ;
                              (( objItem->nmnozOBodb - objItem->nmnozPLodb ) -pvpItemww->nmnozPRdod) <= 0 , ;
                                aadd( removeRecs, objItem->(recNo()) ), nil )                            }, ;
                       { || pvpItemww->nobjItem <> 0 } ))
  fordRec()


  IF IsObject( Dialog) .or. !ok
    *
    cfilter := format( cf, { nFirma } )
    objItem->( ads_setAof(cfilter), dbgoTop() )
    if( len(removeRecs) <> 0, objItem->(ads_customizeAof(removeRecs,2)), nil )

    * pokud je filtr prázdný, v SKL_OBJITEM_SEL se nepozicujeme na nrecObj
    nRecObj := if( ObjItem->( eof()), 0, nRecObj)

    if objitem->(Ads_GetRecordCount()) = 0
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
      objitem->( ads_clearAof())
      return .t.
    endif

    odialog := drgDialog():new( 'SKL_OBJITEM_SEL', ::drgDialog)
    odialog:cargo_usr := removeRecs
    odialog:create(,,.T.)

    nexit := odialog:exitState

    objItem->( ads_clearAof())
  ENDIF

  IF nExit = drgEVENT_SELECT
    *
    OK := .T.

    (::sklPol:odrg:isEdit := .f., ::sklPol:odrg:oxbp:disable())

    ::dm:set(::IT + '->CCISLOBINT' , OBJITEM->CCISLOBINT )
    ::dm:set(::IT + '->NCISLPOLOB' , OBJITEM->NCISLPOLOB )
    ::dm:set(::IT + '->CSKLPOL'    , OBJITEM->CSKLPOL )
    ::dm:set(::IT + '->CNAZZBO'    , OBJITEM->CNAZZBO )

    ( ::ofile_iv:set('objitem'), ::orecs_iv:set(objitem->(recNo()) ) )
    (::it)->nOBJITEM := objItem->sID

    ::LastCislObInt := OBJITEM->CCISLOBINT

    IF( ::nKarta = 274 )
      lMnNevyd := SysConfig( 'Sklady:lMnNevyd')
      ::dm:set(::IT + '->nMnozPrDOD', IF( lMnNevyd, ObjItem->nMnozObOdb - ObjItem->nMnozPlOdb, setMNDOKLAD ))
    ELSE
      ::dm:set(::IT + '->nMnozPrDOD' , OBJITEM->nMnozPoODB )
    ENDIF

    * Pøevod
    if ::nKarta = 305
      cenZboz_80->( dbseek( objitem->ccisSklad +objitem->csklPol,,'CENIK03'))

      ::dm:set(::IT + '->cSklPolKAM' , CenZboz_80->cSklPol   )
      ::dm:set(::IT + '->nUcetSkKAM' , CenZboz_80->nUcetSkup )
      ::dm:set(::IT + '->nmnozPrDod' , objitem->nmnozObOdb -objitem->nmnozPlOdb )

      ::dm:set( 'M->cen_ucetSkup' , cenZboz_80->cucetSkup )
      ::dm:set( 'M->cen_mnozSZbo' , cenZboz_80->nmnozSZbo )
    endif

    ::dm:set(::IT + '->nMnozDokl1' , ::dm:get(::IT + '->NMNOZPRDOD') )
    ::dm:set(::IT + '->cMJDokl1'   , OBJITEM->cZkratJedn )
    ::dm:set(::IT + '->cZkratJedn' , OBJITEM->cZkratJedn )

    IF( ::dm:get(::IT + '->NMNOZPRDOD') = 0, ::dm:set(::IT + '->NMNOZPRDOD' , setMNDOKLAD ), NIL )
    **new 11.6.2009
    IF( ::dm:get(  'M->CELKITEM' ) = 0,;
        ::dm:set( 'M->CELKITEM', CenZboz->nCenaSZBO * ::dm:get(::IT + '->NMNOZPRDOD') ), NIL )
    ::dm:set('M->NCELKDOKL' , ::nCelkDOKL += ::nCelkITEM )
  ENDIF
  *
  if( .not. ok, ::dm:set(::IT + '->CCISLOBINT',  '' ), nil )
RETURN ( nExit != drgEVENT_QUIT .or. ok)


*
********************************************************************************
METHOD SKL_PohybyIT:SKL_C_Sklad( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->cSkladKAM', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_SKLADY->(dbseek(value,,'C_SKLAD1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'SKL_C_SKLAD' PARENT ::drgDialog MODAL DESTROY ;
                                 EXITSTATE nExit CARGO drgVar:odrg

    if nexit = drgEVENT_SELECT
     ::dm:set( ::IT + '->cSkladKAM', C_SKLADY->cCisSklad )
*     ::dm:refresh()
    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

*
********************************************************************************
METHOD SKL_PohybyIT:SKL_C_UctSkp( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->nUcetSkKAM', .F.)
  Local value  := drgVar:get()
  Local ok     := ( !Empty(value) .and. C_UCTSKP->(dbseek(value,,'C_USKUP1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'SKL_C_UCTSKP' PARENT ::drgDialog MODAL DESTROY ;
                                 EXITSTATE nExit CARGO drgVar:odrg

    if nexit = drgEVENT_SELECT
     ::dm:set( ::IT + '->nUcetSkKAM', C_UCTSKP->nUcetSkup )
*     ::dm:refresh()
    endif
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

*
********************************************************************************
METHOD SKL_PohybyIT:SKL_C_OdpMis( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->cKlicOdMis', .F.)
  Local value  := Upper( drgVar:get())
  Local ok     := ( !Empty(value) .and. C_OdpMis->(dbseek(value,,'C_1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'C_ODPMIS' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg
  endif
  if nexit = drgEVENT_SELECT .or. ok
    ok := .t.
    Osoby->( dbSeek(C_OdpMis->nOsCisPrac,, 'OSOBY01'))
    ::dm:set( ::IT + '->cKlicOdMis', C_OdpMis->cKlicOdMis )
    ::dm:refresh()
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

********************************************************************************
METHOD SKL_PohybyIT:SKL_C_SkuMis( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->cKlicSkMis', .F.)
  Local value  := Upper( drgVar:get())
  Local ok     := ( !Empty(value) .and. C_SkuMis->(dbseek(value,,'C_1')))

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'C_SKUMIS' PARENT ::drgDialog MODAL DESTROY ;
                              EXITSTATE nExit CARGO drgVar:odrg
  endif
  if nexit = drgEVENT_SELECT .or. ok
    ok := .t.
    ::dm:set( ::IT + '->cKlicSkMis', C_SkuMis->cKlicSkMis )
    ::dm:refresh()
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

********************************************************************************
METHOD SKL_PohybyIT:SKL_PRIJDIM( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->nDokPriDIM', .F.)

  DRGDIALOG FORM 'SKL_PRIJDIM_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                   EXITSTATE nExit   //CARGO drgVar:odrg

  if nexit = drgEVENT_SELECT
    ::dm:set( ::IT + '->nDokPriDIM', PVPITEM->nDoklad )
    ::nFakPriDim  := PVPITEM->nCisFak
*    ::dm:refresh()
  endif
RETURN

********************************************************************************
METHOD SKL_PohybyIT:SKL_VYDEJKY( drgDialog)
  Local oDialog, nExit
  Local drgVar := ::dm:get( ::IT + '->nDoklad_o', .F.)
  Local value  := drgVar:get(), ok

  drgDBMS:open('PVPHEAD',,,,, 'PVPHEADa' )
  ok := ( !Empty(value) .and. PVPHEADa->(dbseek(value,,'PVPHEAD01')) .and. PVPHEAD->nTypPoh = 2 )

  if IsObject(drgDialog) .or. !ok
    DRGDIALOG FORM 'SKL_VYDEJKY_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                     EXITSTATE nExit   //CARGO drgVar:odrg
  endif
  if nexit = drgEVENT_SELECT  .or. ok
    ::dm:set( ::IT + '->nDoklad_o', PVPHEAD->nDoklad )
*    ::nFakPriDim  := PVPITEM->nCisFak
*    ::dm:refresh()
  endif
RETURN (nexit = drgEVENT_SELECT .or. ok)

* Pøednastaví nákl. strukturu
********************************************************************************
METHOD SKL_PohybyIT:SetNS()
  Local x, oVar, cNazPol
  Local acNazPol := { ::uHD:cNazPol1, ::uHD:cNazPol2, ::uHD:cNazPol3, ::uHD:cNazPol4, ::uHD:cNazPol5, ::uHD:cNazPol6}

  FOR x := 1 TO 6
    cNazPol := ::IT + '->cNazPol'+ STR(x,1)
    IF IsObject( oVar := ::dm:has( cNazPol))
      oVar:set( acNazPol[ x] )
      oVar:InitValue := oVar:prevValue := oVar:Value := acNazPol[ x]
    ENDIF
  NEXT
RETURN self

* Uloží nákl.strukturu   pro potøebu pøednastavení v rámci dokladu
********************************************************************************
METHOD SKL_PohybyIT:SaveNS()
  Local x, cNazPol, xNazPol, oVar

  * Naplnit promìnné pro NS, naplnit položky NS v PVPITEM
  FOR x := 1 TO 6
    xNazPol := 'cNazPol'+ STR(x,1)
    cNazPol := 'PVPITEMww->' + xNazPol
    IF IsObject( oVar := ::dm:has( cNazPol))
      ::uHD:&(xNazPOL) := &(cNazPOL) := ::dm:get( cNazPOL)
*        ::&(xNazPOL) := &(cNazPOL) := ::dm:get( cNazPOL)
    ENDIF
  NEXT
RETURN self

********************************************************************************
METHOD SKL_POHYBYIT:TT_data_yes()

  DRGDIALOG FORM 'SKL_PVPTERM_SCR' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit

RETURN self


*HIDDEN*************************************************************************
METHOD SKL_POHYBYIT:modiCARD()
  local  ccrd := ::uHD:cCRD , pa
  Local  oVar, x, membCRD := {}, avars


  for x := 1 to len( ::membORG ) step 1
    ovar := ::membORG[x]

    if isMemberVar( ovar, 'Groups' )

      do case
      case isCharacter( ovar:Groups )
        pa := listAsArray( ovar:Groups )

        do case
        case ( empty(ovar:groups) .or. ascan( pa, ccrd ) <> 0 .or. 'clrYELLOW' $ ovar:Groups )
          ovar:oxbp:show()
          aadd( membCRD, ovar )

          if isMethod( ovar, 'setFocus' )
            if( isMemberVar( ovar, 'IsEdit'), ovar:isEdit := .t., nil )
            if( isMemberVar( ovar, 'pushGet') .and. isObject( ovar:pushGet), oVar:pushGet:oxbp:show(), nil )
          endif

        otherWise
          ovar:oxbp:hide()
          if( ovar:className() = 'drgText', ovar:obord:hide(), nil )

          if isMethod( ovar, 'setFocus' )
            if( isMemberVar( ovar, 'IsEdit'), ovar:isEdit := .f., nil )
            if( isMemberVar( ovar, 'pushGet') .and. isObject( ovar:pushGet), oVar:pushGet:oxbp:hide(), nil )
          endif
        endCase

      otherwise

         if ovar:className() $ 'drgPushButton'
           if  ovar:event = 'TT_data_yes' .and. ::isDataTT
             ovar:oXbp:Show()
             aadd( membCRD, ovar)

           elseIf ovar:event = 'TT_data_no' .and. !::isDataTT
             ovar:oXbp:Show()
             aadd( membCRD, ovar)

           elseIf ovar:event <> 'TT_data_yes' .AND. ovar:event <> 'TT_data_no'
             aadd( membCRD, ovar)

           else
             ovar:oxbp:hide()
           endIf
         endif
      endcase

    endif
  next
  *
  avars := drgArray():new()
  for x := 1 to len(membCRD) step 1
    if ismembervar(membCRD[x],'ovar') .and. isobject(membCRD[x]:ovar)
      if membCRD[x]:ovar:className() = 'drgVar'
        avars:add(membCRD[x]:ovar,lower(membCRD[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := membCRD
  ::dm:vars     := avars

  ::cislObInt  := ::dm:get(::it +'->ccislobint', .F.)
RETURN self

 */
********************************************************************************
METHOD SKL_POHYBYIT:destroy()
  *
  ::ClearVarIT( .T.)
  *
  ::dc := ::dm := ::df := ::varsOrg := ::membOrg := ;
  ::oHD := ::uHd := ::HD := ::IT := ::newIT := ::Naz_PolDoklad := ;
  ::cfg_nTypNabPol := ::LastCislObInt := ;
  ::cNameIT := ::nMnozDokl_o := ;
  NIL
  * zruší omezení na daný sklad
  CenZboz->( mh_ClrFilter())
RETURN self

**HIDDEN************************************************************************
METHOD SKL_PohybyIT:OrdITEM()
  local recNo, ordNo, nordItem := 0

  recNo := (::IT)->(recno())
  ordNo := (::iT)->(AdsSetOrder(0))

  (::IT)->( dbgotop(), dbeval({|| nordItem := max(nordItem,(::IT)->norditem) }, ;
                              {|| (::IT)->_delRec <> '9'                     } ))
  (::IT)->( AdsSetOrder(ordNo),dbgoto(recNo))

/*
  Local nOrdItem , nREC := (::IT)->( RecNO())

  (::IT)->( dbGoBOTTOM())
  nOrdITEM := MAX( 0, (::IT)->nOrdITEM )
  (::IT)->( dbGoTO( nREC))
*/
RETURN nOrdItem

* Vrací název první editaèní položky v položkové kartì
** HIDDEN **********************************************************************
METHOD SKL_PohybyIT:FirstEditIT
  Local nPos, lCisObjVys

  DO CASE
    CASE ( nPos := ASCAN( { 110 }, ::nKARTA)) > 0
      lCisObjVys := SysCONFIG( 'Sklady:lCisObjVys')
      ::cNameIT := ::IT + if( ::newIt,if( lCisObjVys, '->cCisObj', '->cSklPol') , '->nCenaDokl1' )
    CASE ( nPos := ASCAN( { 130,116,117 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt, '->cCisObj', '->nCenaDokl1')
    CASE ( nPos := ASCAN( { 100,102,120 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt, '->cSklPol', '->nCenaDokl1')
    CASE ( nPos := ASCAN( { 253, 274 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt,'->cCislObInt', '->nKlicDph' )   //'->nKlicDph'
    CASE ( nPos := ASCAN( { 203,263,283,293 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt,'->cSklPol', '->nKlicDph' )
    CASE ( nPos := ASCAN( { 204 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt,  '->cSklPol', '->nMnozDokl1')
    CASE ( nPos := ASCAN( { 205 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt,  '->cSklPol', '->nMnozPrDod')
    CASE ( nPos := ASCAN( { 299 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt,  '->nDoklad_o', '->nMnozDokl1')
    CASE ( nPos := ASCAN( { 305 }, ::nKARTA)) > 0
      ::cNameIT := ::IT + if( ::newIt, if( ::cislObInt:odrg:isEdit, '->ccislObInt', '->cSklPol'), '???')
    OTHERWISE
      ::cNameIT := ''
  ENDCASE
  **
  IF !EMPTY( ::cNameIT)
    odrg := ::dm:get(::cnameit, .F.)

    ::drgDialog:oForm:setNextFocus( ::cNameIT,, .T. )
  ENDIF
RETURN NIL

* Nastavení editace IT karet
*===============================================================================
METHOD SKL_PohybyIT:SetEditIT()
  Local nPos, aE
  Local lUctSkPrev := SysConfig('Sklady:lUctSkPrev')  // Editace úè. skup. pøi pøevodu

*  DEFAULT IsNewRec TO .F.
  IsEditGET( { 'PVPITEMww->cSklPol'   ,;
               'PVPITEMww->cCisObj'   ,;
               'PVPITEMww->cCislObInt',;
               'PVPITEMww->nDoklad_o'  }, ::drgDialog, ::newIt )

  if ::newit
    (::sklPol:odrg:isEdit := .t., ::sklPol:odrg:oxbp:enable())
    if( isObject(::cisObj   ), (::cisObj:odrg:isEdit    := .t., ::cisObj:odrg:oxbp:enable()   ), nil )
    if( isObject(::cislObInt), (::cislObInt:odrg:isEdit := .t., ::cislObInt:odrg:oxbp:enable()), nil )
  endif

  *
  DO CASE
    CASE ( nPos := ASCAN( { 205 }, ::nKARTA)) > 0
      aE := { 'PVPITEMww->cKlicSkMis', 'PVPITEMww->cKlicOdMis', 'PVPITEMww->nInvCisDIM'}
      IsEditGET( {'PVPITEMww->nCenaCelk'}, ::drgDialog, .F. )

    CASE ( nPos := ASCAN( { 305 }, ::nKARTA)) > 0
      aE := { 'PVPITEMww->cSkladKAM', 'PVPITEMww->cSklPolKAM'}
      IsEditGET( {'PVPITEMww->nUcetSkKAM'}, ::drgDialog, lUctSkPrev )
      IF( lUctSkPrev .and. !::newIT, AADD( aE, 'PVPITEMww->nUcetSkKAM'), NIL )

      * máme k dispozici položky objednávek pro ncisfirmy ?
      if ::newit
        if .not. objitem ->(dbseek(strzero((::hd)->ncisFirmy,5),,'OBJITEM0'))
          (::cislObInt:odrg:isEdit := .f., ::cislObInt:odrg:oxbp:disable())
        else
          (::cislObInt:odrg:isEdit := .t., ::cislObInt:odrg:oxbp:enable())
        endif
      endif

    CASE ::nKARTA = 400  //
      aE := { 'PVPITEMww->nCenNapDod',;
              'PVPITEMww->cNazPOL1', 'PVPITEMww->cNazPOL2', 'PVPITEMww->cNazPOL3',;
              'PVPITEMww->cNazPOL4', 'PVPITEMww->cNazPOL5', 'PVPITEMww->cNazPOL6' }
  ENDCASE
  IsEditGET( aE, ::drgDialog, ::newIT )
  * docasne
  IF ( nPos := ASCAN( { 100,102,110,117,130, 204, 244, 274 }, ::nKARTA)) > 0
    IsEditGET( {'PVPITEMww->nMnozPrDod'}, ::drgDialog, .F. )
  ENDIF
  /* 23.10.2008
     novì se edituje nCenaDokl1
  */
  IF ( nPos := ASCAN( { 100,102,110,120,130,116,117, 204, 244, 274 }, ::nKARTA)) > 0
    IsEditGET( {'PVPITEMww->nCenNapDod'}, ::drgDialog, .F. )
  ENDIF
  *
***  IsEditGET( 'M->cKatcZBO', ::drgDialog, CENZBOZ->cKatalCis = 'A' )
  isEditGet( ::IT +'->cKatcZBO', ::drgDialog, CENZBOZ->cKatalCis = 'A' )
RETURN NIL

* Vyprázdní ( vyèistí) všechny pamìové promìnné pro IT
**HIDDEN************************************************************************
METHOD SKL_PohybyIT:ClearVarIT( SetNIL)

  DEFAULT SetNIL TO .F.
*  ::nPocetBal  := IF( SetNIL, NIL, 0 )
*  ::nZustatek  := IF( SetNIL, NIL, 0 )
  ::nCelkITEM  := IF( SetNIL, NIL, 0.00 )
  ::nCelkDOKL  := IF( SetNIL, NIL, 0.00 )
  ::nCenaMZBO  := IF( SetNIL, NIL, 0.00 )
  ::nVyslCenaB := IF( SetNIL, NIL, 0.00 )
  ::nVyslCenaS := IF( SetNIL, NIL, 0.00 )
  ::nSumHodnSl := IF( SetNIL, NIL, 0.00 )
  ::nSumProcSl := IF( SetNIL, NIL, 0.00 )
  ::nSumaPolB  := IF( SetNIL, NIL, 0.00 )
  ::nSumaPolS  := IF( SetNIL, NIL, 0.00 )
  ::nSumaDoklB := IF( SetNIL, NIL, 0.00 )
  ::nSumaDoklS := IF( SetNIL, NIL, 0.00 )
  ::nCenaSroz  := IF( SetNIL, NIL, 0.00 )    // rozdíl skl. cen pøi pøecenìní
  ::cKatcZBO   := IF( SetNIL, NIL, SPACE(15) )
  ::nMarzRabat := IF( SetNIL, nil, 0.00 )
*  ::nZustatek( 0 )
RETURN self

** HIDDEN***********************************************************************
METHOD SKL_PohybyIT:ReCompute( name, nMn, nPCb, nPCs, nHodnSlev, nDPH)
  LOCAL lSetInEdit := ( PCOUNT() > 0 )

  DEFAULT nMn       TO (::IT)->nMnozPrDod,;
          nPCb      TO (::IT)->nCenaZakl ,;
          nHodnSlev TO (::IT)->nHodnSlev ,;
          nDPH      TO SeekKodDPH( (::IT)->nKlicDph),;
          nPCs      TO nPCb * ( 1 +  nDPH / 100)

  ::nCenaMZBO  := nPCs
  ::nVyslCenaB := nPCb - nHodnSlev
  ::nVyslCenaS := ::nVyslCenaB * ( 1 +  nDPH / 100)
  ::nSumaPolB  := ::nVyslCenaB * nMn
  ::nSumaPolS  := ::nVyslCenaS * nMn
  ::nSumHodnSl := nHodnSlev * nMn
  ::nProcDPH   := nDph
  IF lSetInEdit
    ::dm:set('M->nCenaMZBO' , ::nCenaMZBO  )
    ::dm:set('M->nVyslCenaB', ::nVyslCenaB )
    ::dm:set('M->nVyslCenaS', ::nVyslCenaS )
    ::dm:set('M->nSumaPolB' , ::nSumaPolB  )
    ::dm:set('M->nSumaPolS' , ::nSumaPolS  )
    ::dm:set('M->nSumHodnSl', ::nSumHodnSl )
    ::dm:set('M->nProcDph'  , ::nProcDph   )
    ::uHD:DokladCelkem(.F.)
    ::dm:set('M->nSumaDoklB' , ::uHd:nCelkPCB  )
    ::dm:set('M->nSumaDoklS' , ::uHd:nCelkPCS  )
*    IF( (name = ::IT + '->nCenaZakl'), SKL_ProdCena( nPCb), nil )
*    IF( (name = 'M->nCenaMZBO')      , SKL_ProdCena( nPCs), nil )
*    ::nCelkPCB := ::nCelkPCB - PVPItem->nCenaPZBO + ::nVyslCenaB
*    ::nCelkPCS := ::nCelkPCS - PVPItem->nCenaPDZBO + ::nVyslCenaS
  ENDIF
RETURN

* Kontrola na globální èíselník C_NaklSt pøi ukládání pohybových dokladù
** HIDDEN***********************************************************************
METHOD SKL_PohybyIT:ControlNS()   // dm)
  Local lOK := .t.
  Local cKEY := S_DOKLADY + ALLTRIM( (::HD)->cTypPohybu )

  IF C_TypPOH->( dbSEEK( cKEY,, 'C_TYPPOH02'))
    IF C_TypPOH->lNaklStr
      drgDBMS:open('C_NaklST')
      cKey := ''
      For x := 1 To 6
        cKey += Upper( ::dm:get( ::IT+'->cNazPol' + str( x, 1)))
      next
      *
      IF EMPTY( cKey)
        drgMsgBox( drgNLS:msg( 'Nákladová struktura nebyla vyplnìna !' ))
        ::df:setNextFocus( ::IT+'->cNazPol1',, .T. )
        lOK := .F.
      ELSE
      *
        IF ! C_NaklSt->( dbSEEK( cKey,,'C_NAKLST1'))
          IF drgIsYesNo(drgNLS:msg( 'Tato vazba neexistuje v èíselníku nákladové struktury;; '+;
                                    'Požadujete ji založit ?'))
            If ( lWriteNS := SysConfig( 'Sklady:lWriteNS' ))
              C_NaklSt->( dbAppend(), dbRLock())
              C_NaklSt->cNazPol1 := Upper( ::dm:get( ::IT+'->cNazPol1'))
              C_NaklSt->cNazPol2 := Upper( ::dm:get( ::IT+'->cNazPol2'))
              C_NaklSt->cNazPol3 := Upper( ::dm:get( ::IT+'->cNazPol3'))
              C_NaklSt->cNazPol4 := Upper( ::dm:get( ::IT+'->cNazPol4'))
              C_NaklSt->cNazPol5 := Upper( ::dm:get( ::IT+'->cNazPol5'))
              C_NaklSt->cNazPol6 := Upper( ::dm:get( ::IT+'->cNazPol6'))
              C_NaklSt->( dbRUnlock())
            ELSE
              lOK := .F.
              drgMsgBox( drgNLS:msg( 'Nemáte oprávnìní zakládat do èíselníku nákladové struktury !' ))
            ENDIF
          ELSE
            lOK := .F.
          ENDIF
        ENDIF
      ENDIF
    ENDIF
  ENDIF

RETURN lOK

**HIDDEN************************************************************************
METHOD SKL_PohybyIT:VyrCis_Modi( nKEY)
  Local oDialog, nExit

***  oDialog := drgDialog():new('SKL_VyrCis_CRD', ::drgDialog)
  oDialog := drgDialog():new('SKL_VyrCis_CRD', ::drgDialog)
  oDialog:cargo := nKEY
  oDialog:cargo_usr := 2
***  oDialog:create(,::drgDialog:dialog,.F.)
  oDialog:create(,::drgDialog:dialog,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
  ENDIF
  oDialog:destroy(.T.)
  oDialog := NIL

RETURN self

*
**HIDDEN************************************************************************
METHOD SKL_PohybyIT:MistaUloz( nKEY)
  Local oDialog, nExit, lExistMistoUL
  Local lMistaULOZ := SysCONFIG( 'Sklady:lMistaULOZ')
  *
  IF lMistaULOZ    // mech. pro evidenci na místech uložení je konfiguraènì nastaven
    drgDBMS:open('C_UlozMi' )
    C_UlozMi->( OrdSetFocus('C_ULOZM2'),;
                mh_SetSCOPE( Upper( PVPITEMww->cCisSklad)))
    lExistMistoUL := !EMPTY( C_UlozMi->CULOZZBO)
    *
    IF lExistMistoUL  // pro daný sklad existují místa uložení
      oDialog := drgDialog():new('SKL_Ulozeni_PVP', ::drgDialog)
      oDialog:create(,::drgDialog:dialog,.F.)
      oDialog:cargo := nKEY
      nExit   := oDialog:exitState

      IF nExit = drgEVENT_SAVE
      ENDIF
      oDialog:destroy(.T.)
      oDialog := NIL
    ENDIF
  ENDIF
  *
RETURN self