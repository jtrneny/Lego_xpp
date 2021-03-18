#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "Font.ch"
#include "CLASS.CH"
#include "dmlb.ch"
//
#include "xbp.ch"
//
#include "..\FINANCE\FIN_finance.ch"
#include "..\Asystem++\Asystem++.ch"

/*
TYPY vstupních karet --nFINTYP--                                  --párování záloh--
1 -> FAKPB  ->  FAKP       ... Faktura pøijatá bìžná                x
2 -> FAKPC  ->  FAKPCEL    ... Faktura pøijatá celní                -
3 -> FAKPZ  ->  FAKPZAL    ... Faktura pøijatá zálohová             -
4 -> FAKPZB ->  FAKPZAH    ... Faktura pøijatá zahranièní           x
5 -> FAKPZZ ->  FAKZAHZAL  ... Faktura pøijatá zahranièní zálohová  -
6 -> FAKPEU ->  FAKPEURO   ... Faktura pøijatá EURo                 x
*/


#translate SET_typ(<c>) => ;
           AScan( {'FAKP','FAKPCEL','FAKPZAL','FAKPZAH','FAKPZAHZAL','FAKPEURO'}, ;
                  Upper(AllTrim(<c>))                                             )

#define m_files  { 'typdokl'  ,'c_typoh'                                   , ;
                   'c_bankuc' ,'c_dph'     ,'c_meny' ,'c_staty','c_typfak' , ;
                   'kurzit'   ,'firmy'     ,'firmyfi','firmyuc','parprzal' , ;
                   'cenzboz'               , ;
                   'ucetDoHd'              , ;
                   'dodlstPhd', 'dodlstPit', ;
                   'objVyshd' , 'objVysit' , ;
                   'vyrzak'   , 'vyrzakit'   }


**
** CLASS for FIN_fakprihd_IT_IN ************************************************
CLASS FIN_fakprihd_IT_IN FROM drgUsrClass, FIN_finance_in, FIN_NAK_fakturovat_z_vld, FIN_NAK_fakdol, SYS_ARES_forAll
exported:
  var     uctLikv, vykDph, prepZakl
  var     cmb_typPoh
  var     chb_celPol
  var     ocol_isZalFak

  method  init, drgDialogStart, postSave, destroy
  method  comboItemSelected, comboItemMarked
  method  checkItemSelected
  method  postLastField, overPostLastField

  method  fir_firmyuc_sel, fin_parprzal
  method  vlde, vldc, vldz, zustpozao

  var     lok_append2
  *
  ** musíme postupnì pøesunout výkonné metody sem a volat je pro event
  inline method after_fakturovat_z_sel()
    ::postItemMarked(0,2,.t.)
    return self

  inline method overPostAppend()
    local  o_push  := ::o_cejPrZbz:odrg:pushGet

    ::postItemMarked(0,2)

    o_push:event := 'fin_cmdph'
    o_push:oxbp:SetGradientColors()
    (o_push:oxbp:show(), o_push:enable() )
    return .t.


  inline method postEscape()
    ::postItemMarked()

    if ::state <> 2
      if (::it_file)->ncisZalFak <> 0
        recNo  := (::it_file)->(recNo())
        filter := format("ncisfak = %%",{(::it_file)->ncisZalFak})

        vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop())

        do while .not. vykdph_Pw->(eof())
          cky := strZero(vykdph_pw ->ncisFak    ,10) + ;
                 strZero(vykdph_pw ->ndoklad_or ,10) + ;
                 strZero(vykdph_pw ->nradek_Dph , 3)

          if (::it_file)->(dbseek( cky,,'FAKPRIIT_4'))
            vykdph_Pw->cucetu_Dok := (::it_file)->cucetu_Dph
            vykdph_Pw->nzaklD_Zal := (::it_file)->ncenZakCel
            vykdph_Pw->nsazba_Zal := (::it_file)->nsazDan
          endif

          vykdph_Pw->(dbskip())
        enddo

        vykdph_pw->(dbclearfilter(), dbgotop())
        (::it_file)->(dbgoTo( recNo))
      endif
    endif
    ::cejPrZbz_push()
    return .t.

  inline method postDelete()
    local cisZalFak := fakpriitw->ncisZalFak
    local currTag   := fakpriitw->(ordSetFocus())

    if cisZalFak <> 0
      fakpriitw->( ordSetFocus(0), dbgotop() )
      vykdph_pw->(dbclearFilter(), dbgotop())

      if fakpriitw->_nrecor = 0
        fakpriitw->(dbeval({|| fakpriitw->(dbdelete())}          , ;
                           {|| fakpriitw->ncisZalFak = cisZalFak}) )

        vykdph_pw->(dbEval({|| vykdph_pw->(dbDelete())}          , ;
                           {|| vykdph_pw->ncisFak = cisZalFak}   ) )
      else
        vykdph_pw->(dbEval({|| vykdph_pw->_delrec := '9'}        , ;
                           {|| vykdph_pw->ncisFak = cisZalFak}   ) )

        fakpriitw->(dbeval({|| fakpriitw->_delRec := '9'}        , ;
                           {|| fakpriitw->ncisZalFak = cisZalFak}) )
      endif

      fakpriitw->(ordSetFocus( currTag ), dbgoTop())
      ::brow:refreshAll()
    endif

    fin_nak_ap_modihd(::hd_file)
    return


  inline method postItemMarked(subCount,state,after_sel)
    local  x, ok := .t., drgVar
    local  cisZalFak, lpreDanPov, nradVykDph
    *
    ** položky dle seznamu pa_Ins jsou editovatelné jen v INS
    local  pa_Ins := { 'csklpol'   , 'ncislodl' , 'ccislobint', 'nciszalfak' }
    *
    ** položky dle seznamu pa_Zal lze editovat pro položku zálohová faktura
    local  pa_Zal := ;
    { 'ncejprzbz', 'cucet', 'cnazpol1', 'cnazpol2', 'cnazpol3', 'cnazpol4', 'cnazpol5', 'cnazpol6' }
    *
    ** položky dle seznamu pa_Dd lze editovat pro položku daòové doklady
    local  pa_Dd  := { 'cucetu_dph', 'ncejprzbz', 'ncenzakcel', 'nsazdan'    }


    default subCount  to (::it_file)->nsubCount, ;
            state     to 0                     , ;
            after_sel to .f.

    * povolená editave pro zálohovou fakturu
    cisZalFak := if( state = 2, if(after_sel, ::cisZalFak:value, 0), (::it_file)->ncisZalFak )

    * blokujem lpreDanPov pro INS automaticky DISABLE
    vykdph_iw->( dbseek( (::it_file)->nradVykDph,,'VYKDPH_5'))
    lpreDanPov := if( state = 2, .f., vykdph_iw->lpreDanPov)

    * ctypPreDan se edituje pouze pro nradVykDPH = 10 a 11, jinak není ani viditelný
    nradVykDph := if( state = 2,   0, (::it_file)->nradVykDph )

    for x := 1 to len(::members_fak_it) step 1
      drgVar := ::members_fak_it[x,1]
      if( isNull(drgVar:isEdit_org), drgVar:isEdit_org := drgVar:isEdit, NIL )

      * daòové doklady zálohové faktury
      if subCount <> 0 .and. state = 0
        drgVar:isEdit := ( ascan(pa_Dd, { |it| 'fakpriitw->' +it = lower(drgVar:name) }) <> 0 )

      * bìžná položka, nebo položka zálohové faktury
      else
        if cisZalFak <> 0 // .and. state = 0
          drgVar:isEdit := ( ascan(pa_Zal, { |it| 'fakpriitw->' +it = lower(drgVar:name) }) <> 0 )

        else
          do case
          case( drgVar = ::chb_preDanPov )  ;  drgVar:isEdit := lpreDanPov

          case( drgVar = ::cmb_typPreDan )
            drgVar:isEdit := (nradVykDph = 10 .or. nradVykDph = 11)

            if( drgVar:isEdit, drgVar:oxbp:enable(), nil )
            if( drgVar:isEdit, drgVar:oxbp:show()  , drgVar:oxbp:hide() )

          case ascan(pa_Ins, { |it| 'fakpriitw->' +it = lower(drgVar:name) }) <> 0
            drgVar:isEdit := .f.

          otherWise
            drgVar:isEdit := drgVar:isEdit_org
          endcase
        endif
      endif

      if( drgVar:isEdit, drgVar:oxbp:enable(), drgVar:oxbp:disable() )
    next
    return self


*  inline method drgDialogInit(drgDialog)
*    drgDialog:dialog:drawingArea:bitmap  := 1019
*    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
*  return self

  * položky karty
  * info o použitelé hodnotì párované zálohy
  inline access assign method parPrzal_kDis() var parPrzal_kDis
    local  retVal    := 0
    local  cisZalFak := if( ::state = 2, ::cisZalFak:value, (::it_file)->ncisZalFak )

    if cisZalFak <> 0
      fakprih_pz->( dbseek( cisZalFak,,'FPRIHD1'))

      retVal := round(FIN_NAK_fakturovat_z_bc(8,1,'fakprih_pz'),4)
    endif
    return retVal

  * 1 øádek
  inline access assign method txt_zaMJ_dan() var txt_zaMJ_dan
    if isObject(::o_cejprkbz) .and. isObject(::o_cejprkdz)
      return ::o_cejprkdz:value - ::o_cejprkbz:value
    endif
    return 0

  * 2 øádek
  inline access assign method txt_zaPOL_dan() var txt_zaPOL_dan
    if isObject(::o_cecprkbz) .and. isObject(::o_cecprkdz)
      return ::o_cecprkdz:value - ::o_cecprkbz:value
    endif
    return 0

  * položky - IT - bro
  inline access assign method cenPol() var cenPol
    return if(fakpriit->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method bc_osvOdDane() var bc_osvOdDane
    return if( fakpriitw->nnapocet = 0, fakpriitw->ncenZakCel, 0 )

  inline access assign method bc_zaklDph_s() var bc_zaklDph_s
    return if( fakpriitw->nnapocet = 1, fakpriitw->ncenZakCel, 0 )

  inline access assign method bc_sazDph_s() var bc_sazDph_s
    return if( fakpriitw->nnapocet = 1, fakpriitw->nsazDan, 0 )

  inline access assign method bc_zaklDph_z() var bc_zaklDph_z
    return if( fakpriitw->nnapocet = 2, fakpriitw->ncenZakCel, 0 )

  inline access assign method bc_sazDph_z() var bc_sazDph_z
    return if( fakpriitw->nnapocet = 2, fakpriitw->nsazDan, 0 )


  inline access assign method k_disp_fak var k_disp_fak
    local retVal := '', cky

*    do case
*    case( fakpriit->cfile_iv = 'cenzboz')
*      cky := fakpriit->ccissklad +fakpriit->csklpol
*      cenzboz->(dbseek(upper(cky),,'CENIK03'))
*      retVal := str(cenzboz->nmnozDZbo)
*    endcase
    return retVal

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    if fakpriitw->nsubCount = 0
      return fakpriitw->ncejPrZbz
    endif
    return retval

  inline access assign method prepZakl() var prepZakl
    local koeD := fakprihdw->nkurzahmed/fakprihdw->nmnozpred
    return(fakprihdw->ncenzahcel * koeD)

  *
  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  xval      := ::ocol_isZalfak:dataArea:getCell(::brow:rowPos)
    local  cisZalFak := fakpriitw->ncisZalFak
    *
    local  state     := -1

    do case
    case nevent = xbeM_LbClick
      if oxbp:classname() = 'XbpCellGroup'
        if oxbp:parent = ::ocol_isZalfak
          if( xval = MIS_PLUS .or. xval = MIS_MINUS )
            state := if(fakpriitw->_nstate = 0, 1, 0 )
          endif
        endif
      endif

    case nEvent = xbeP_Keyboard
      if ( mp1 = 43 .or. mp1 = 45 )   // + -
        if( xval = MIS_PLUS .or. xval = MIS_MINUS )
          if( xval = MIS_PLUS  .and. mp1 = 43, state := 0, nil )
          if( xval = MIS_MINUS .and. mp1 = 45, state := 1, nil )
        endif
      endif
    endCase

    if state >= 0
      fordRec( {'fakpriitw'} )

      fakpriitw->_nstate := state
      fakpriitw->( ordSetFocus(0) , ;
                   dbeval( { || fakpriitw->_nvisible := state }, ;
                           { || fakpriitw->ncisZalFak = cisZalFak .and. fakpriitw->nsubCount <> 0 } ) )
      fordRec()

      ::brow:refreshAll()
    endif
    return ::fakdol_handleEvent(nevent,mp1,mp2,oxbp)


HIDDEN:
  VAR     aEdits, panGroup, members, roundDph
  var     butPar
  var     members_fak, members_pen, members_inf
  var     members_bc
  var     members_fak_it
  var     ncurrRec

  METHOD  showGroup, refresh

  *
  ** blokujeme ncenZakCel a nsazDan pro tuzemskou fakturu
  inline method isVisible_cenZakCel_sazDan(zkratMenZ)
    default zkratMenZ to (::hd_file)->czkratMenZ

    if Equal(SysConfig('Finance:cZaklMena'), zkratMenZ )
      ( ::o_cenZakCel:isEdit := ::o_cenZakCel:isEdit_org := .f., ::o_cenZakCel:oxbp:disable())
      ( ::o_sazDan:isEdit    := ::o_sazDan:isEdit_org    := .f., ::o_sazDan:oxbp:disable()   )
    else
      ( ::o_cenZakCel:isEdit := ::o_cenZakCel:isEdit_org := .t., ::o_cenZakCel:oxbp:enable() )
      ( ::o_sazDan:isEdit    := ::o_sazDan:isEdit_org    := .t., ::o_sazDan:oxbp:enable()    )
    endif
    return self

  inline method value(name)
    LOCAL fullName := IF( '->' $ name, name, 'fakprihdw->' +name)
    RETURN ::dm:has(fullName):value

  inline method recToArr(calias)
    local  nFCount := ( cAlias) ->(fCount()), nField
    local  axRecArr := {}

    for nField := 1 to nFCount step 1
      aAdd( axRecArr, ( cAlias) ->( fieldGet( nField)))
    Next
    return axRecArr

  inline method arrToRec( aArray, calias)
    local  nFCount := ( cAlias)->( FCount()), nField

    for nField := 1 To nFCount step 1
      (cAlias)-> ( FieldPut( nField, aArray[ nField] ))
    next
    return nil
ENDCLASS


method FIN_fakprihd_it_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file    := 'fakprihdw', ::it_file  := 'fakpriitw')
  ::lnewRec     := .not. (parent:cargo = drgEVENT_EDIT)
  ::lok_append2 := .f.
  ::ncurrRec    := fakPrihd->(recNo())

//  ::it_file  := 'parprzalw'

  * základní soubory
  ::openfiles(m_files)

  * pomocné pro párováníZáloh (z) a penalizaci (p)
  drgDBMS:open('fakprihd',,,,,'fakprihd_p')
  drgDBMS:open('fakprihd',,,,,'fakprih_pz')

  ::roundDph  := SysConfig('Finance:nRoundDph')
  fin_fakprihd_it_cpy(self)

  file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
               (::it_file) ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name,  ::it_file , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'fakprii_w', .t., .t.) ; fakprii_w  ->(AdsSetOrder(1))

  file_name := parprzalw ->( DBInfo(DBO_FILENAME))
               parprzalw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'parprzalw', .t., .f.) ; parprzalw->(AdsSetOrder(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'parprzi_w', .t., .t.) ; parprzi_w->(AdsSetOrder(1))
return self


method FIN_fakprihd_it_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'faktury pøijaté'
  local  x, groups, name, odrg
  *
  local  ardef    := drgDialog:odbrowse[1]:ardef, npos_isZalFak, ocolumn
  local  acolors  := MIS_COLORS

  ::members_fak    := {}
  ::members_pen    := {}
  ::members_inf    := {}
  ::members_bc     := {}
  ::members_fak_it := {}


  ::fin_finance_in:init(drgDialog, 'zav', ::it_file +'->cnazZbo', que_del)

  ::cmb_typPoh := ::dm:has('fakprihdw->ctyppohybu'):odrg

  * typPoložky lcelPol
  ::chb_celPol := ::dm:get(::it_file +'->lcelpol'   , .F.)

  * cenzboz
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)
  *dodldtit
  ::cisloDl    := ::dm:get(::it_file +'->ncislodl'  , .F.)
  ::countdl    := ::dm:get(::it_file +'->ncountdl'  , .F.)
  * objitem
  ::cislObInt  := ::dm:get(::it_file +'->ccislobint', .F.)
  ::cislPolob  := ::dm:get(::it_file +'->ncislPolob', .F.)

  ::cisZakazi  := ::dm:get(::it_file +'->cciszakazi', .F.)
  ::cisZalFak  := ::dm:get(::it_file +'->nciszalfak', .F.)

  * kombinované tlaèítko u FAKPRIITw->NCEJPRZBZ
  ::o_cejPrZbz := ::dm:get(::it_file +'->ncejPrZbz' , .F.)

  * pro metodu txt_zaMJ_dan()
  ::o_cejprkbz  := ::dm:get(::it_file +'->ncejprkbz', .F.)
  ::o_cejprkdz  := ::dm:get(::it_file +'->ncejprkdz', .F.)

  * pro metodu txt_zaPOL_dan
  ::o_cecprkbz  := ::dm:get(::it_file +'->ncecprkbz', .F.)
  ::o_cecprkdz  := ::dm:get(::it_file +'->ncecprkdz', .F.)

  * pro tuzemskou FA jsou tyto údaje needitovateln0
  ::o_cenZakCel := ::dm:get(::it_file +'->ncenZakCel', .F.):odrg
  ::o_sazDan    := ::dm:get(::it_file +'->nsazDan'   , .F.):odrg


  ::aEdits     := {}
  ::panGroup   := '1'
  ::members    := drgDialog:oForm:aMembers

  posPar       := AScan(::members, {|X| IF( x:className() = 'drgPushButton', X:event = 'FIN_PARPRZAL', NIL) })
  ::butPar     := ::members[posPar]
  ::butPar:disable()
  ::butPar:oxbp:hide()

  FOR x := 1 TO LEN(::members) step 1
    IF ::members[x]:ClassName() = 'drgStatic' .and. .not.Empty(::members[x]:groups)
      AAdd(::aEdits, { ::members[x]:groups, x })
    ENDIF

    if ::members[x]:ClassName() = 'drgTabPage'
      if ::members[x]:tabNumber = 2
        ::members[x]:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )  // XBPSYSCLR_TRANSPARENT )
      endif
    endif

    if ::members[x]:classname() = 'drgGet'
      if 'nparzahfak' $ lower( ::members[x]:name)
        ::members[x]:isEdit := .f.
        ::members[x]:oxbp:disable()
        ::members[x]:oXbp:setFontCompoundName('10.Arial CE Bold')
      endif
    endif

    if ::members[x]:classname() = 'drgPushButton'
      if( ::members[x]:event = 'memoEdit',  ::members[x]:isEdit := .f., nil )
    endIf

    groups := if( isMemberVar(::members[x],'groups'), isnull(::members[x]:groups,''), '')
    name   := if( ismemberVar(::members[x],'name'  ), isnull(::members[x]:name  ,''), '')

    * jen editaèní prvky (IT) pro validaci ukládání v cyklu
    if  ::members[x]:isEdit .and. .not. ('FAC' $ groups)
      if ::members[x]:className() <> 'drgMLE'
        if( 'fakpriitw' $ lower(name), aadd(::members_fak_it, {::members[x],x}), nil)
      endif
    endif


    if left(groups,3) = 'FAK' .or. left(groups,3) = 'FAB' .or. left(groups,3) = 'FAC'
      if 'SETFONT' $ groups
        pa_groups := ListAsArray( groups)
        nin       := ascan(pa_groups,'SETFONT')

        ::members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            ::members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          ::members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif


      * pololožky faktury se zobrazují vždy
      * ale logika lcelPol pøepíná poøízení èásti položky BÌŽNÁ - CELNÍ
      * toto pøepnutí je povoleno jen u typu celní faktura

      if left(groups,3) = 'FAB' .or. left(groups,3) = 'FAC'
        ::members[x]:groups := left(groups,3)
        aadd( ::members_bc, ::members[x] )
      else
        ::members[x]:groups := ''
      endif
    endif
  NEXT

  * lpreDanPov se edituje pouze pro vykdph_iw->lpreDanPov
  * ctypPreDan se edituje pouze pro nradVykDPH = 10 a 11, jinak není ani viditelný
  ::chb_preDanPov          := ::dm:has(::it_file +'->lpreDanPov'):odrg
  ::cmb_typPreDan          := ::dm:has(::it_file +'->ctypPreDan'):odrg
  ( ::cmb_typPreDan:isEdit := .f., ::cmb_typPreDan:oxbp:hide() )

  * projka FAKPRIHD - DODLSTPHD
  ::fin_NAK_fakdol:init(drgDialog:udcp)

  *
  ** append2 se musí chovat jako oprava ale kombinuje INS
  IF .not. ::lNEWrec .or. ::lok_append2
*    ::dm:has('fakprihdw->ncisfak'   ):oDrg:isEdit := ;
*    ::dm:has('fakprihdw->ctyppohybu'):oDrg:isEdit := .F.

    ::df:setNextFocus('fakprihdw->cvarsym',,.T.)
  ELSE

    ::comboItemSelected(::dm:has('fakprihdw->ctyppohybu'):oDrg)
    ::isVisible_cenZakCel_sazDan()
    ::df:setNextFocus('fakprihdw->ctyppohybu',, .T.)
  ENDIF

  * úprava pro sloucec isZalFak
  for x := 1 to ::brow:colCOunt step 1
    ocolumn := ::brow:getColumn(x)
    ocolumn:colorBlock := &( '{|a,b,c| fin_fakprihd_it_in_colorBlock( a, b, c ) }' )
  next

  npos_isZalFak   := ascan(ardef, {|x| x.defName = 'm->isZalFak'})
  ocolumn         := ::brow:getColumn(npos_isZalFak)
  ::ocol_isZalFak := oColumn

  ocolumn:dataAreaLayout[XBPCOL_DA_FRAMELAYOUT]       := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
  ocolumn:dataAreaLayout[XBPCOL_DA_HILITEFRAMELAYOUT] := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
  ocolumn:dataAreaLayout[XBPCOL_DA_CELLFRAMELAYOUT]   := XBPFRAME_DOTTED + XBPFRAME_BOX + XBPFRAME_RAISED
  ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]             := GraMakeRGBColor( {221,221,221})
  ocolumn:configure()
  ::brow:refreshAll()

  *
  ::dm:has('m->prepZakl'):odrg:oxbp:setFontCompoundName('SETFONT,8.Arial CE')
  ::dm:has('m->prepZakl'):odrg:oxbp:setColorFG(GRA_CLR_BLUE)

  ::panGroup := Str( IF(FAKPRIHDw ->nFINTYP = 6, 1,FAKPRIHDw ->nFINTYP), 1)
  ::fin_finance_in:refresh('fakprihdw',,drgDialog:dataManager:vars)

  * musíme pøepoèítat hlavièku, pokud má položky
  if .not. ::lnewRec .and. fakpriHdw->nhasItems = 1
    fin_nak_ap_modihd(::hd_file)
  endif

  drgDialog:dataManager:refresh()

  ::showGroup()
  ::zustpozao()

  ::sys_ARES_forAll:init(drgDialog)
RETURN self


function fin_fakprihd_it_in_colorBlock( a, b, c )
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,32,32}), }

  AClr := if( fakpriitw->nsubCount <> 0, aCOL_er, aCOL_ok )
return AClr


method fin_fakprihd_it_in:overPostLastField()

/*
zatím ne pak musíme zkotrolovat minimálnì NS
množství nemá cenu

  local  value := ::dm:get( 'fakprihdw->ncisfak' )

  if .not. FIN_postSave():new('fakprihd',self):ok
    return .f.
  endif

  if ::lnewRec
     if .not. fin_range_key('FAKPRIHD',value,,::msg)[1]
       ::df:setNextFocus('fakprihdw->ncisfak',,.t.)
       return .f.
     endif
  endif
*/
return .t.


method fin_fakprihd_it_in:postLastField()
  local  file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value
  local  cisZakaz, ok
  *
  local  filter, ax_fakpriiw, cky, cky_danDokl, recNo
  local  ncisloDD
  local  refreshAll := .f.

* tady je to divné, v cyklu postValidOK nìco obsahuje a nezkotroluje znovu prvky na FRM !!!
*  if(fakvyshdw->nprocDan_1 = 0, fakvyshdw->nprocDan_1 := seekSazDPH(1,fakvyshdw->dpovinFak), nil)
*  if(fakvyshdw->nprocDan_2 = 0, fakvyshdw->nprocDan_2 := seekSazDPH(2,fakvyshdw->dpovinFak), nil)

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()), ::state := 2, nil)

  ok := if(::state = 2, addrec(::it_file), .t.)

  if ok
    if ::state = 2  ;  if .not. empty(file_iv)
                         recNo := (file_iv)->( recNo())
                         (file_iv)->(dbgoto(recs_iv))

                         * penalizaèní faktura se nesmí kopírovat
                         if file_iv <> 'fakvyshd_p'
                           ::copyfldto_w(file_iv,::it_file)
                         endif

                         (file_iv)->(dbgoto( recNo))
                       endif

                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)
                       (::it_file)->ncislopvp  := 0
                       (::it_file)->nintcount  := ::ordItem()+1
                       (::it_file)->nsubcount  := 0
                       (::it_file)->_nstate    := 0
                       (::it_file)->_nvisible  := 0
                       (::it_file)->ccisZakaz  := cisZakaz
    endif

    ::itsave()
    *
    ** nullDph 4 a 14 jsou pro párování záloh nklicDph musí být -1 **
    if (::it_file)->nnullDph = 4 .or. (::it_file)->nnullDph = 14
       (::it_file)->ncenzahcel := (::it_file)->ncecprkdz
    else
      (::it_file)->ncenzahcel := (::it_file)->ncecprkbz
      c_dph->(dbseek((::it_file)->nprocdph,,'C_DPH2'))
      (::it_file)->nklicdph := c_dph->nklicdph
    endif
    *
    ** daòové doklady párované zálohy
    do case
    case (::it_file)->ncisZalFak <> 0 .and. (::it_file)->ncisloDD = 0

      ax_fakpriiw := ::recToArr( ::it_file )
      recNo       := (::it_file)->(recNo())
      filter      := format("ncisfak = %%",{(::it_file)->ncisZalFak})

      vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop())

      do while .not. vykdph_Pw->(eof())

        cky         := strZero(vykdph_pw ->noddil_dph,2) + ;
                       strZero(vykdph_pw ->nradek_dph,3) + ;
                       strZero(vykdph_pw ->ndat_od,8)

        cky_danDokl := strZero( (::it_file)->ncisZalFak,10) + ;
                       strZero( (::it_file)->nintCount , 5) + ;
                       strZero( isNull( vykDph_Pw->sID, 0), 5)

        c_vykdph->(dbSeek(cky,,'VYKDPH4'))

        if .not. (::it_file)->(dbseek( cky_danDokl,,'FAKPRIIT_3'))

          * pokud zanuloval nzaklD_Zal +nsazba_Zal nechce pøevzít položku
          if vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal <> 0

            (::it_file)->(dbappend())

            ::arrToRec( ax_fakpriiw, ::it_file)
            *
            (::it_file)->ncisloDD   := vykdph_Pw->ndoklad_Or
            (::it_file)->nnapocet   := vykdph_Pw->ntyp_Dph

            (::it_file)->cnazZbo    := 'DD_' +alltrim(str(vykDph_pw->ndoklad_Or)) +' odpoèet danì'
            (::it_file)->nfaktMnoz  := 1
            (::it_file)->czkratJedn := 'x'

            (::it_file)->nprocDph   := vykdph_Pw->nprocDph
            (::it_file)->nradVykDph := vykdph_Pw->nradek_Dph
            (::it_file)->lpreDanPov := vykdph_Pw->lpreDanPov
            (::it_file)->cucetu_Dph := vykdph_Pw->cucetu_Dok
            (::it_file)->nkrace_Nar := vykdph_Pw->nkrace_Nar

            (::it_file)->ncejPrZbz  := vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal
            (::it_file)->nhodnSlev  := 0
            (::it_file)->nprocSlev  := 0
            (::it_file)->ncejPrKBz  := 0           //JT  vykdph_Pw->nzaklD_Zal
            (::it_file)->ncejPrKDZ  := 0           //JT  vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal

            (::it_file)->ncecPrZBz  := 0           //JT  vykdph_Pw->nzaklD_Zal
            (::it_file)->ncelkSlev  := 0           //JT
            (::it_file)->ncecPrKBz  := 0           //JT  vykdph_Pw->nzaklD_Zal
            (::it_file)->nceCPrKDZ  := 0           //JT  vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal

            (::it_file)->ncenZakCel := vykdph_Pw->nzaklD_Zal
            (::it_file)->nsazDan    := vykdph_Pw->nsazba_Zal
            (::it_file)->ncenZakCeD := vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal
            (::it_file)->nsubCount  := isNull( vykDph_Pw->sid, 0)
            (::it_file)->_nstate    := 0
            (::it_file)->_nvisible  := 0

            refreshAll := .t.
          endif
        else

          * opravoval položku zálohy a mohl modifikovat vykDph_Pw
          * pokud zanuloval nzaklD_Zal +nsazba_Zal musímeme položku fakvysitw zru3it
          if vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal = 0
            (::it_file)->(flock())
            if( (::it_file)->_nrecor = 0, (::it_file)->(dbdelete()),  (::it_file)->_delRec := '9' )

          else
            (::it_file)->ncejPrZbz  := vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal

            (::it_file)->ncenZakCel := vykdph_Pw->nzaklD_Zal
            (::it_file)->nsazDan    := vykdph_Pw->nsazba_Zal
            (::it_file)->ncenZakCeD := vykdph_Pw->nzaklD_Zal +vykdph_Pw->nsazba_Zal
          endif
          refreshAll := .t.
        endif

        vykdph_Pw->(dbskip())
      enddo

      vykdph_pw->(dbclearfilter(), dbgotop())
      (::it_file)->(dbgoTo( recNo))

    case (::it_file)->ncisZalFak <> 0 .and. (::it_file)->ncisloDD <> 0

      * opravil -1- položku daòového dokladu, musíme to vrátit do vykDph_Pw
      cky := strZero((::it_file)->ncisloDD  ,10) + ;
             strZero((::it_file)->nradVykDph, 3)

       if vykDph_Pw->(dbseek( cky,,'VYKDPH_9'))
         vykdph_Pw->cucetu_Dok := (::it_file)->cucetu_Dph
         vykdph_Pw->nzaklD_Zal := (::it_file)->ncenZakCel
         vykdph_Pw->nsazba_Zal := (::it_file)->nsazDan
       endif
    endCase


    if( ::state = 2, ::brow:gobottom():refreshAll(), ;
      if( refreshAll, ::brow:refreshAll(), ::brow:refreshCurrent()) )
    (::it_file)->(flock())

    *
    ** párování zálohy zase z fakPrihd rozhodí postavení DB
    if( file_iv = 'fakprihd', fakPriHd->( dbgoto( ::ncurrRec)), nil )
    *
    ** penalizaèní faktury
    if (::hd_file)->nfintyp = 5
      fakvysitw->czkratJedn := 'DNY'
      fakvysitw->nnullDph   := 3
      fakvysitw->nceCPrKDZ  := fakvysitw->nceCPrKBZ
    endif
  endif

//  (::it_file)->nmnozZdok := isnull(::wds_mnozZdok,0)
//  (::it_file)->nhmotnost := ((::it_file)->nfaktmnoz * (::it_file)->nhmotnostJ)
//  (::it_file)->nobjem    := ((::it_file)->nfaktmnoz * (::it_file)->nobjemJ   )

  fin_nak_ap_modihd(::hd_file)

  ::setfocus(::state)
  ::dm:refresh()
return .t.


method fin_fakprihd_it_in:postSave()
  local ok, file_name, value     := ::cmb_typPoh:value
  local                dporizFAK := fakprihdw->dporizFAK

  ok := fin_fakprihd_it_wrt_inTrans(self)

  if ok .and. ::set_likvidace_inOn = 1
    ::FIN_likvidace_in(::drgDialog)
    ::set_likvidace_inOn = 0
    _clearEventLoop(.t.)
  endif


  if(ok .and. ::new_dok)
    fakprihdw->(dbzap())
    fakpriitw->(DbCloseArea())
    fakprii_w->(DbCloseArea())

    parprzalw->(DbCloseArea())
    parprzi_w->(DbCloseArea())

    fin_fakprihd_it_cpy(self)

    file_name := (::it_file) ->( DBInfo(DBO_FILENAME))
                 (::it_file) ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name,  ::it_file , .t., .f.) ; (::it_file)->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'fakprii_w', .t., .t.) ; fakprii_w  ->(AdsSetOrder(1))

    file_name := parprzalw ->( DBInfo(DBO_FILENAME))
                 parprzalw ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, 'parprzalw', .t., .f.) ; parprzalw->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'parprzi_w', .t., .t.) ; parprzi_w->(AdsSetOrder(1))

    * musíme se pøepnout na HD pokud je na IT
    if ::df:tabPageManager:active:tabNumber = 2
**      ::df:tabPageManager:toFront(1)
      ::df:tabPageManager:showPage(1)
    endif

    fakprihdw->dporizFAK := dporizFAK

    ::cmb_typPoh:value := value
    ::comboItemSelected(::cmb_typPoh)

    ::fin_finance_in:refresh('fakprihdw',,::dm:vars)
    ::dm:refresh( , .t.)

    ::showGroup()
    ::zustpozao()

    ::df:setnextfocus( 'fakprihdw->ctyppohybu',,.t.)

  elseif(ok .and. .not. ::new_dok)
    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  endif
return ok


METHOD FIN_fakprihd_it_in:destroy()
  ::drgUsrClass:destroy()

  ::lNEWrec  := ;
  ::aEdits   := ;
  ::panGroup := ;
  ::members  := NIL

  (::hd_file)->(dbcloseArea())
  (::it_file)->(DbCloseArea())

  parprzalW  ->(dbcloseArea())
  fakprii_w  ->(dbcloseArea())
  parprzi_w  ->(DbCloseArea())
  *
  if(select('vykdph_pw') <> 0, vykdph_pw->(dbclosearea()), nil)
  if(select('vykdph_ps') <> 0, vykdph_ps->(dbclosearea()), nil)

  if(select('ucetpolw') <> 0, ucetpolw->(dbclosearea()), nil)
  if(select('ucetpols') <> 0, ucetpols->(dbclosearea()), nil)
  FAKPRIHD ->(ads_clearAof())
RETURN


*
**
method FIN_fakprihd_it_in:fir_firmyuc_sel(drgDialog)
  local oDialog, nExit := drgEVENT_QUIT, fintyp := fakprihdw ->nfintyp, copy := .F.
  *
  local drgVar := ::dm:has('fakprihdw->cucet')
  local value  := drgVar:get()
  local lOk    := FIRMYUC ->(DBseek(Upper(value),,'FIRMYUC2')) .and. .not. empty(value)

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIR_FIRMYUC_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                     EXITSTATE nExit
  ENDIF

  if (lOk .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
    FIRMY ->( DbSeek( FIRMYUC ->nCISFIRMY,,'FIRMY1'))
    mh_COPYFLD('FIRMY', 'FAKPRIHDw',,.f.)

    IF FIRMYFI ->(DbSeek( FIRMYUC ->nCISFIRMY,,'FIRMYFI1'))
      fakprihdw ->cucet_uct  := IF( fintyp = 3 .or. fintyp = 5, firmyfi ->cuct_fpz, firmyfi ->cuct_dod)
      fakprihdw ->czkrtypuhr := firmyfi ->czkrtypuhr
    ENDIF

    c_staty->(dbseek(upper(fakprihdw->czkratstat),,'C_STATY1'))
    c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))
    *
    if (fakprihdw->nkurzahmen +fakprihdw->nmnozprep = 0 .or. ;
       empty(fakprihdw->czkratmenz)                     .or. ;
       (c_meny->czkratmeny <> fakprihdw->czkratmenz)         )

       kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

       kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
       cKy := upper(c_meny->czkratMeny) +dtos(fakprihdw->dvystFak)
       kurzit->(dbSeek(cKy, .T.))
       If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

       fakprihdw->czkratmenz := c_meny->czkratmeny
       fakprihdw->nkurzahmen := kurzit->nkurzstred
       fakprihdw->nmnozprep  := kurzit->nmnozprep

       fakprihdw->nkurzahmeD := kurzit->nkurzstred
       fakprihdw->nmnozpreD  := kurzit->nmnozprep

       kurzit->(dbclearScope())
    endif

    fakprihdw ->cucet := firmyuc ->cucet

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
    ::restColor()
    ::df:setNextFocus('fakprihdw->dvystfakdo',,.T.)

    ::showGroup()
  ENDIF
return (nExit != drgEVENT_QUIT) .or. lOk


METHOD FIN_fakprihd_it_in:fin_parprzal()
  local  oDialog, nExit
  local  koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep
  *
  local  recNo

  IF (FAKPRIHDw ->nFINtyp = 1 .or. FAKPRIHDw ->nFINtyp = 4 .or. FAKPRIHDw ->nFINtyp = 6)

    recNo := fakprihd->( recNo())

    oDialog := drgDialog():new('FIN_parprzal',self:drgDialog)
    oDialog:create(,self:drgDialog:dialog,.F.)

    ::dm:set('fakprihdw->nparzahfak', oDialog:udcp:sumPar)
    fakprihdw->nparzahfak := oDialog:udcp:sumPar
    fakprihdw->nparzalfak := oDialog:udcp:sumPar *koeZ

    oDialog:destroy(.T.)
    oDialog := NIL

    fakprihd->(dbgoTo( recNo ))
  ENDIF
RETURN self


method FIN_fakprihd_it_in:comboItemSelected(drgComboBox,isMarked)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn, finTyp

  do case
  case right(drgComboBox:name,7) = 'COBDOBI'
    ::cobdobi(drgComboBox)

  case 'CTYPPOHYBU' $ drgComboBox:name
    nIn := AScan(values, {|X| X[1] = value })

    finTyp := SET_typ(values[nIn,4])

    IF .not. IsNull(isMarked,.F.)
      FAKPRIHDw->cTYPDOKLAD := values[nIn,3]
      FAKPRIHDw->cTYPPOHYBU := values[nIn,1]
      FAKPRIHDw->nFINTYP    := finTyp
      fakprihdw->ciszal_fak := if(finTyp = 3 .or. finTyp = 5, '1', '0')

      * celní
      if(finTyp = 2, ::dm:has('fakprihdw->nparzahfak'):oDrg:isEdit := .f., nil)
    ENDIF

    * zmìna typupohybu znamená znovu vytvoøení vykdph_iw
    *                                          ucetpolw/ucetolw_2
    fin_vykdph_cpy('FAKPRIHDw')
    ::fin_finance_in:FIN_vykdph_mod('fakprihdw')

    ::panGroup := Str( IF(finTyp = 6, 1, finTyp), 1)
    ::showGroup()

  case 'CZKRATMENZ' $ drgComboBox:name
   if drgComboBox:ovar:itemChanged()

     * blokujeme ncenZakCel a nsazDan pro tuzemskou fakturu
     ::isVisible_cenZakCel_sazDan(value)
     PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
   endif

  endcase
return self


METHOD FIN_fakprihd_it_in:comboItemMarked(drgComboBox)
  DO CASE
  CASE('CTYPPOHYBU' $ drgComboBox:name)
    ::comboItemSelected(drgComboBox, .T.)
  CASE('NPROCDAN_'  $ drgComboBox:name)
    DBPutVal('FAKPRIHDw ->nPROCDAN_' +Right(drgComboBox:name,1),drgComboBox:Value)
  ENDCASE
RETURN self


method FIN_fakprihd_it_in:checkItemSelected(drgVar)
  local  ctypPol := if( ::chb_celPol:value, 'FAC', 'FAB' )

  for x := 1 to len(::members_bc) step 1
    if .not. (ctypPol $ ::members_bc[x]:groups)
      ::members_bc[x]:oXbp:hide()
      if( ::members_bc[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members_bc[x]:isEdit := .F.)
    else
      ::members_bc[x]:oXbp:show()
      if( ::members_bc[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members_bc[x]:isEdit := .T.)
    endif
  next
return self


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_fakprihd_it_in:showGroup()
  local  x, isedit_inrev
  *
  local  ctypPol  := if( ::chb_celPol:value, 'FAC', 'FAB' )
  local  panGroup := ::panGroup // +',' +ctypPol

  for x := 1 to len(::members) step 1
   if IsMemberVar(::members[x],'groups') .and. .not. Empty(::members[x]:groups)
***      1.8.2017
***      if .not. (::members[x]:groups $ panGroup )
      if .not. (::panGroup $ ::members[x]:groups)
        ::members[x]:oXbp:hide()
        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .F.)
      else
        ::members[x]:oXbp:show()

        if( ::members[x]:ClassName() $ 'drgStatic,drgText' )
        else
          if ::lnewRec
            ::members[x]:isEdit := .t.
          else
            isedit_inrev := if( isMemberVar( ::members[x], 'isedit_inrev'), isNull(::members[x]:isedit_inrev, .t.), .t.)
            ::members[x]:isEdit := isedit_inrev
          endif
        endif
//        if( ::members[x]:ClassName() $ 'drgStatic,drgText', NIL, ::members[x]:isEdit := .T.)
      endif
    endif
  next

  ::FIN_finance_IN:fakprihd_act(::drgDialog)
RETURN self


METHOD FIN_fakprihd_it_in:refresh(drgVar)
  LOCAL  nIn, nFs
  LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
//
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

  nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

  FOR nIn := nFs TO vars:size()
    oVar := vars:getNth(nIn)
    IF !oVar:rOnly .and. (dbArea == drgParse(oVar:name,'-'))
      IF( oVar:itemChanged(), Eval( oVar:block, oVar:value), NIL )
      oVar:refresh()
    ENDIF
  NEXT
RETURN .T.


METHOD FIN_fakprihd_it_in:vlde(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue, koeZ, koeD
  *
  LOCAL  nCENZAK_cm, nSAZdan, nPROCdan
  LOCAL  cKEYs
  LOCAL  lCMP := .F., lNULL_dph := .F., lcmp_osv := .f.

  DO CASE
  CASE( name = 'fakprihdw->czkratstat' .or. name = 'fakprihdw->czkratmenz') .and. changed
      ( lCMP  := .T., lNULL_dph := .T., lcmp_osv := .t. )
      KURZIT ->( AdsSetOrder(2), DBSetScope( SCOPE_BOTH, UPPER(C_MENY ->cZKRATmeny)))
      cKEYs := UPPER(C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dPORIZfak)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DBGoBottom()), NIL )

      FAKPRIHDw ->nKURZAHmen := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZprep  := KURZIT ->nMNOZprep

      cKEYs := UPPER( C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dVYSTfakdo)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DbGoBottom()), NIL )
      FAKPRIHDw ->nKURZAHmed := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZpred  := KURZIT ->nMNOZprep

      KURZIT ->( DbClearScope())

  CASE( name = 'fakprihdw->ncenzahcel' .or. name = 'fakprihdw->nparzahfak' .or. ;
        name = 'fakprihdw->cnazmeny'   .or. name = 'fakprihdw->nkurzahmen' .or. ;
        name = 'fakprihdw->nmnozprep'  .or. name = 'fakprihdw->ncenzakcel' .or. ;
        name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

    lCMP      := .T.
    lNULL_dph := ( name = 'fakprihdw->cnazmeny'   .or.                                     ;
                   name = 'fakprihdw->nkurzahmen' .or. name = 'fakprihdw->nmnozprep'  .or. ;
                   name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

   CASE( name = 'fakprihdw->nzakldan_1' .and. changed)
     FAKPRIHDw ->nSAZdan_1 := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )

   CASE( name = 'fakprihdw->nzakldan_2' .and. changed)
     FAKPRIHDw ->nSAZdan_2 := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )

  CASE( name = 'fakprihdw->nzakldan_3' .and. changed)
     FAKPRIHDw ->nSAZdan_3 := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_3, ::roundDph )

   ENDCASE

   drgVar:save()
*
   If lCMP
     koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep
     FAKPRIHDw ->nCENZAKCEL := FAKPRIHDw ->nCENzahCEL * koeZ

     do case
     case( name = 'fakprihdw->ncenzahcel')
       IF ::value('fakprihdw->nkurzahmed') <> ::value('fakprihdw->nmnozpred')
         koeD  := fakprihdw->nkurzahmed/fakprihdw->nmnozpred
         FAKPRIHDw ->nOSVodDAN += (value - initValue) * koeD
       ENDIF

     case lcmp_osv
       koeD  := fakprihdw->nkurzahmed/fakprihdw->nmnozpred
       FAKPRIHDw ->nOSVodDAN := FAKPRIHDw ->nCENzahCEL * koeD

     endcase
  EndIf

  ::fin_finance_in:refresh(drgVar)
RETURN .T.


METHOD FIN_fakprihd_it_in:vldc(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue


  if changed
    DO CASE
    CASE( name = 'fakprihdw->ncelzakl_1')
      FAKPRIHDw ->nZAKLDAN_1 := value
      FAKPRIHDw ->nSAZDAN_1  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )
      FAKPRIHDw ->nOSVODDAN  += (value -initValue) *(-1)

    CASE( name $ 'fakprihdw->ncelclo_1, fakprihdw->ncelspd_1, fakprihdw->nceldal_1')
      FAKPRIHDw ->nZAKLDAN_1 += (value -initValue)
                       value := FAKPRIHDw ->nZAKLDAN_1
      FAKPRIHDw ->nSAZDAN_1  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_1, ::roundDph )

    CASE( name = 'fakprihdw->ncelzakl_2')
      FAKPRIHDw ->nZAKLDAN_2 := value
      FAKPRIHDw ->nSAZDAN_2  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )
      FAKPRIHDw ->nOSVODDAN  += (value -initValue) *(-1)

    CASE( name $ 'fakprihdw->ncelclo_2, fakprihdw->ncelspd_2, fakprihdw->nceldal_2')
      FAKPRIHDw ->nZAKLDAN_2 += (value -initValue)
                       value := FAKPRIHDw ->nZAKLDAN_2
      FAKPRIHDw ->nSAZDAN_2  := mh_RoundNumb( (value/100) * FAKPRIHDw ->nPROCdan_2, ::roundDph )
    ENDCASE

    ::fin_finance_in:FIN_vykdph_mod('fakprihdw')
    ::fin_finance_in:refresh(drgVar)
  endif
RETURN .T.


METHOD FIN_fakprihd_it_in:vldz(drgVar)
  LOCAL  name  := Lower(drgVar:name), changed := drgVar:itemChanged()
  LOCAL  value := drgVar:value, initValue := drgVar:initValue, koeZ
  *
  LOCAL  cKEYs, lCMP := .F.

  DO CASE
  CASE( name = 'fakprihdw->czkratstat' .or. name = 'fakprihdw->czkratmenz') .and. changed
    IF FAKPRIHDw ->cZKRATmenz <> C_MENY ->cZKRATmeny
      ( lCMP  := .T., lNULL_dph := .T. )
      KURZIT ->( AdsSetOrder(2), DBSetScope( SCOPE_BOTH, UPPER(C_MENY ->cZKRATmeny)))
      cKEYs := UPPER(C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dPORIZfak)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DBGoBottom()), NIL )

      FAKPRIHDw ->nKURZAHmen := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZprep  := KURZIT ->nMNOZprep

      cKEYs := UPPER( C_MENy ->cZKRATmeny) +DTOS(FAKPRIHDw ->dVYSTfakdo)
      KURZIT ->( DBSeek( cKEYs, .T.))
      If( KURZIT ->nKURZstred == 0, KURZIT ->( DbGoBottom()), NIL )
      FAKPRIHDw ->nKURZAHmed := KURZIT ->nKURZstred
      FAKPRIHDw ->nMNOZpred  := KURZIT ->nMNOZprep

      KURZIT ->( DbClearScope())
    ENDIF

  CASE( name = 'fakprihdw->ncenzahcel' .or. name = 'fakprihdw->nparzahfak' .or. ;
        name = 'fakprihdw->nkurzahmen' .or. name = 'fakprihdw->nmnozprep'  .or. ;
        name = 'fakprihdw->cnazmeny'   .or. name = 'fakprihdw->nkurzahmen' .or. ;
        name = 'fakprihdw->nmnozprep'  .or. name = 'fakprihdw->ncenzakcel' .or. ;
        name = 'fakprihdw->nkurzahmed' .or. name = 'fakprihdw->nmnozpred'       )

     lCMP := changed
  ENDCASE

  drgvar:save()

  if lCMP
    koeZ  := fakprihdw->nkurzahmen/fakprihdw->nmnozprep
    FAKPRIHDw ->nCENZAKCEL := FAKPRIHDw ->nCENzahCEL * koeZ
  endif
  FAKPRIHDw ->nOSVODDAN := FAKPRIHDw ->nCENZAKCEL

  ::fin_finance_in:refresh(drgVar)
RETURN .T.


method FIN_fakprihd_it_in:zustpozao()
  local  osvoddan, fintyp := fakprihdw->nfintyp, zustpozao := 0
  local  nsum_sazba_Dph   := 0
  local  nsign            := 1
  *
  local  koeZ  := ::value('nkurzahmen')/::value('nmnozprep')

  do case
  case( fintyp = 6 )                             // EU faktura
    if ::value('nkurzahmen') <> ::value('nkurzahmed')
      zustpozao := 0
    else
      zustpozao := fakprihdw->ncenzakcel   - ;
                   ( fakprihdw->nosvoddan  + ;
                     fakprihdw->nzakldan_1 + ;
                     fakprihdw->nzakldan_2 + ;
                     fakprihdw->nzakldan_3 - fakprihdw->nparzahfak *koeZ)
    endif

  case( fintyp = 2 )                             // CELNÍ faktura
    * u celní poøizujeme ncenZahCel musíme tuto hodnotu šoupnout do ncenZakCel *
    fakprihdw->ncenZakCel := fakprihdw->ncenZahCel
    zustpozao := fakprihdw->ncenzakcel                           - ;
                 ((fakprihdw->nzakldan_1 +fakprihdw->nzakldan_2) - ;
                  (fakprihdw->ncelzakl_1 +fakprihdw->ncelzakl_2  + ;
                   fakprihdw->nceldal_1  +fakprihdw->nceldal_2 )   )

  case( fintyp = 3 .or. fintyp = 5)             // zálohová bìžná/zahrnièní
*   nekontroluje

  otherwise
    vykdph_iw->( dbGoTop()                                               , ;
                 dbEval( { || nsum_sazba_Dph += vykdph_iw->nsazba_Dph }, ;
                         { || vykdph_iw->lpredanPov }                   ), ;
                 dbgoTop()                                                 )

    zustpozao := fakprihdw->ncenzakcel                                              - ;
                 (fakprihdw->nosvoddan +fakprihdw->nzakldan_1 +fakprihdw->nsazdan_1 + ;
                                        fakprihdw->nzakldan_2 +fakprihdw->nsazdan_2 + ;
                                        fakprihdw->nzakldan_3 +fakprihdw->nsazdan_3 - ;
                                        fakprihdw->nparzalfak                         )

    nsign     := if(zustpozao >= 0, 1, -1 )
    zustpozao := ( abs(zustpozao) -abs( nsum_sazba_Dph))
    zustpozao := zustpozao * nsign
  endcase

  fakprihdw->nzustpozao := fakpriHdw->_nrozDok := zustpozao
  ::dm:set('fakprihdw->nzustpozao',zustpozao)

  ::dm:set('fakprihdw->_nrozDok'  ,zustpozao)
return zustpozao