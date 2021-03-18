#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
** CLASS for HIM_pozemkit_vypCen **********************************************
CLASS HIM_pozemkit_vypCen FROM drgUsrClass
exported:

  method  init, drgDialogStart
  method  postValidate

  method  cmp_Marked, save_Marked, update_Pozemky
  var     sum_podVym_M2, prum_cena_M2

 * pozemkyW
  inline access assign method nazevMaj() var nazevMaj      // název majeku
    majSW->( dbseek( pozemkyW->ninvCis,,'MAJ02'))
    return majSW->cnazev

  inline access assign method celkCena() var celkCena      // celkem Cena, celkem Daò
    local ctask := pozemkyW->ctask
    return if( ctask = 'DAN' .or. empty(ctask), 'celkem Daò', 'celkem Cena' )


  inline method comboItemSelected(drgComboBox,mp2)
    local  value := drgComboBox:Value, values := drgComboBox:values
    local  nIn

    if pozemkyW->ctask <> value
      ::dm:set('M->celkCena', if( value = 'DAN', 'celkem Daò', 'celkem Cena' ))

      // asi universální blok pro zmenu DAN/CEN, ninvCis, ncenaPoz
      pozemkyW->ctask    := value
      pozemkyW->ninvCis  := 0
      pozemkyW->ncenaPoz := 0

      ::him_pozemkit_cpy(.t.)
    endif
  return .t.

  * pozemkitWx
  inline access assign method canBeSave() var canBeSave
    return if(pozemkitWx->_canSave = 2, 6001, 0 )


  * body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  nselect      := len(::oDBro_pozemkitW:arSelect)
    local  is_selAllRec := ::oDBro_pozemkitW:is_selAllRec
    *
    local  sid := isNull( pozemkitWx->sid, 0)
    local  pax_pbCmp  := ::obtn_cmp_Marked:oxbp:GradientColors
    local  pax_pbSave := ::obtn_save_Marked:oxbp:GradientColors


    * podmínka pro start - má v seznamu položek záznamy
    *                    - má oznaèený/é záznamy > 1
    *                    - má zadanou ncenaPoz <> 0

    if( is_selAllRec .and. nselect = ::it_nrecCnt )
       is_selAllRec := ::oDBro_pozemkitW:is_selAllRec := .f.
                       ::oDBro_pozemkitW:arSelect     := {}
       nselect      := 0
    endif

    * btn CMP
    if( pozemkyW->ncenaPoz <> 0.and. sid <> 0 .and. ( nselect > 1 .or. is_selAllRec ))
      if( isNull(pax_pbCmp), ::obtn_cmp_Marked:oxbp:SetGradientColors({0,7}), nil )
      ::obtn_cmp_Marked:oxbp:enable()
    else
      if( isArray(pax_pbCmp),::obtn_cmp_Marked:oxbp:SetGradientColors(nil), nil )
      ::obtn_cmp_Marked:oxbp:disable()
    endif

    * btn SAVE
    if pozemkyW->_canSave = 2
     if( isNull(pax_pbSave), ::obtn_save_Marked:oxbp:SetGradientColors({0,5}), nil )
      ::obtn_save_Marked:oxbp:enable()
    else
      if( isArray(pax_pbSave),::obtn_save_Marked:oxbp:SetGradientColors(nil), nil )
      ::obtn_save_Marked:oxbp:disable()
    endif

    if( is_selAllRec <> ::is_selAllRec .or. nSelect <> ::nlen_arSelect, ::sumColumn(), nil )
  return .f.


hidden:
* sys
  var     msg, dm, dc, df, brow
  var     hd_file, it_file, it_nrecCnt, is_selAllRec, nlen_arSelect
  var     oDBro_pozemkitW, obtn_save_Marked, obtn_cmp_Marked


  inline method setEmptyAndRefresh(is_cenaPoz)
    local  nfield_Out := pozemkitWx->( fieldPos( if( pozemkyW->ctask = 'DAN', "ndanNabPoz", "ncenaPoz" )))
    local  canSave    := pozemkyW->_canSave
    local  ocolumn

    default is_cenaPoz to .f.

    pozemkyW->_canSave := 0
    ::sum_podVym_M2    := 0.00
    ::prum_cena_M2     := 0.00

    if .not. is_cenaPoz
      ::is_selAllRec     := .f.
      ::nlen_arSelect    := 0
      ::oDBro_pozemkitW:arSelect     := {}
      ::oDBro_pozemkitW:is_selAllRec := .f.
    endif

    ::refresh()

    if is_cenaPoz .and. canSave = 2
      pozemkitWx->( dbeval( {|| ( pozemkitWx->( fieldPut(nfield_Out, 0))                                , ;
                                  pozemkitWx->ncenaSDaNa := pozemkitWx->ncenaPoz +pozemkitWx->ndanNabPoz, ;
                                  pozemkitWx->_canSave := 0                                               ) } ), ;
                    dbgotop()                                                                                    )

      ::sumColumn()
      ::oDBro_pozemkitW:oxbp:refreshAll()
    endif
  return .t.


  inline method him_pozemkit_cpy(setEmpty)
    local  cf         := if( pozemkyW->ninvCis = 0, "", "ninvCis = %% and ")
    local  it_nrecCnt := 0

    default setEmpty to .f.

    if( setEmpty, ::setEmptyAndRefresh(), nil )

    cf     += if( pozemkyW->ctask = 'DAN', "(npodVym_m2 <> 0 and ncenaPoz <> 0 and ndanNabPoz = 0)", "(npodVym_m2 <> 0 and ncenaPoz = 0)" )
    filter := format( cf, {pozemkyW->ninvCis} )

    pozemkitSw->( ads_setAof(filter), dbgoTop())
    pozemkitWx->( dbZap())

    pozemkitSw->( dbeval( { || ( mh_copyFld( 'pozemkitSw', 'POZEMKITwx', .t., .t. ), it_nrecCnt++ ) } ))
    pozemkitWx->( dbgoTop())

    ::it_nrecCnt := it_nrecCnt
    ::oDBro_pozemkitW:oxbp:refreshAll()
  return nil
  *
  * suma
  inline method sumColumn()
    local  recNo    := pozemkitWx->( recNo())
    local  pa       := { {'npodVym_m2', 0}, {'ncenaPoz', 0}, {'ndanNabPoz', 0}, {'ncenaSDaNa', 0 } }
    local  oBrow    := ::oDBro_pozemkitW:oxbp, x, npos, value
    local  ardef    := ::oDBro_pozemkitW:ardef
    *
    local  arSelect     := ::oDBro_pozemkitW:arSelect
    local  is_selAllRec := ::oDBro_pozemkitW:is_selAllRec
    local  nrun_Sp      := 0, lis_recOk

    do case
      case ( is_selAllRec .and. len(arSelect) =  0 )
      nrun_Sp  := 1   // vše co je v seznamu
      arSelect := {}
    case ( is_selAllRec .and. len(arSelect) <> 0 )
      nrun_Sp  := 1 // vylouèit odznaèené záznamy
    case                       len(arSelect) <> 0
      nrun_Sp  := 3 // zpracovat je oznaèené záznamy
    endcase

    pozemkitWx->( dbgoTop())
    do while .not. pozemkitWx->( eof())

      nrecNo    := pozemkitWx->( recNo())
      lis_recOk := if( nrun_Sp = 1, .t., ;
                     if( nrun_Sp = 2 .and. ascan( arSelect, nrecNo) = 0, .t., ;
                       if( nrun_Sp = 3 .and. ascan( arSelect, nrecNo) <> 0, .t., .f. ) ) )

      if lis_recOk
        ( pa[1,2] += pozemkitWx->npodVym_m2, ;
          pa[2,2] += pozemkitWx->ncenaPoz  , ;
          pa[3,2] += pozemkitWx->ndanNabPoz, ;
          pa[4,2] += pozemkitWx->ncenaSDaNa  )
      endif

      pozemkitWx->( dbskip())
    enddo

    for x := 1 to len(pa) step 1
      if ( npos := ascan( ardef, { |ait| lower(pa[x,1]) $ lower( ait[2]) })) <> 0
        value := str(pa[x,2])

        if oBrow:getColumn(npos):Footing:getCell(1) <> value
          oBrow:getColumn(npos):Footing:hide()
          oBrow:getColumn(npos):Footing:setCell(1, value)
          oBrow:getColumn(npos):Footing:show()
        endif
      endif
    next

    ::is_selAllRec    := ::oDBro_pozemkitW:is_selAllRec
    ::nlen_arSelect   := len(::oDBro_pozemkitW:arSelect)

    ::sum_podVym_M2 := pa[1,2]
    ::dm:set('M->sum_podVym_M2', pa[1,2] )

    pozemkitWx->( dbgoTo(recNo))
  return self


  inline method refresh(drgVar)
    LOCAL  nIn, nFs, odrg
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
    //
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

//    nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  RETURN .T.


ENDCLASS


method HIM_pozemkit_vypCen:init(parent)
  local file_name

  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('maj')
  drgDBMS:open('maj',,,,,'majSW')
  drgDBMS:open('pozemkit',,,,,'pozemkitSw')
  *
  (::hd_file      := 'pozemkyW', ::it_file := 'pozemkitWx', ::it_nrecCnt := 0 )

  ::sum_podVym_M2 := 0.00
  ::prum_cena_M2  := 0.00

  ** tmp soubory **
  drgDBMS:open('POZEMKYw' ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    pozemkyW->( dbAppend())
    pozemkyW->ctask := 'DAN'

  drgDBMS:open('POZEMKITwX',.T.,.T.,drgINI:dir_USERfitm); ZAP
return self


method HIM_pozemkit_vypCen:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  local  acolors  := MIS_COLORS, pa_groups, nin

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form
  ::oDBro_pozemkitW := ::dc:oBrowse[1]
  *
  ::is_selAllRec    := ::oDBro_pozemkitW:is_selAllRec
  ::nlen_arSelect   := len(::oDBro_pozemkitW:arSelect)

*  ::msg:can_writeMessage := .f.
*  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }
  *
  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)


    if odrg:className() = 'drgText' .and. .not. empty(groups)
      pa_groups := ListAsArray(groups)

      * XBPSTATIC_TYPE_RAISEDBOX           12
      * XBPSTATIC_TYPE_RECESSEDBOX         13

      if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
        odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
      endif

      if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
      endif

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          odrg:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        else
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN)
        endif
      endif
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic' .and. odrg:oxbp:type = XBPSTATIC_TYPE_ICON
*      ::sta_activeBro := odrg
    endif

    if odrg:ClassName() = 'drgPushButton'
      if isCharacter( odrg:event )
        do case
        case odrg:event = 'save_marked'  ;  ::obtn_save_Marked := odrg
        case odrg:event = 'cmp_marked'   ;  ::obtn_cmp_Marked  := odrg
        endcase

      elseif isNumber( odrg:event )
        odrg:oxbp:setFontCompoundName('10.Arial CE Bold')
        odrg:oxbp:SetGradientColors( { 0,3 } )  // {0,5} -zelená, {0,3} - èervená, {0,7} - žlutá
      endif
    endif

  next
  *
  ::obtn_cmp_Marked:oxbp:setFontCompoundName("10.Arial Bold Italic")
  ::obtn_cmp_Marked:oxbp:disable()

  ::obtn_save_Marked:oxbp:setFontCompoundName("10.Arial Bold Italic")
  ::obtn_save_Marked:oxbp:disable()

  ::him_pozemkit_cpy()
return self


METHOD HIM_pozemkit_vypCen:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  local  npos, n_Cit, n_Jmen, npodVym_m2
  local  o_podVym_M2, o_CenaPoz, o_DanNabPoz, o_CenaSDaNa
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *
  if( ::df:in_postvalidateForm .and. (file = ::hd_file), file := '', nil )

  do case

   * kontroly na hlavièce pozemky
  case( file = ::hd_file )
    do case
    case( name = ::hd_file +'->ninvcis' )
      if value <> 0
        if .not. majSW->( dbSeek( value,,'MAJ02'))
          drgMsgBox(drgNLS:msg('Zadané inventární èíslo neexistuje !!!'), XBPMB_CRITICAL )
          ok := .f.
        endif
      endif
      ::dm:set( 'M->nazevMaj', majSW->cnazev )

      if( ok .and. pozemkyW->ninvCis <> value, (drgVAR:save(), ::him_pozemkit_cpy(.t.)), nil )

     case( name = ::hd_file +'->ncenapoz' )
       * asi by mìlo zùstat oznaèení ale sum po výpoètu musí být 0 a hodnoty taky 0
       if ( pozemkyW->ncenapoz <> value, (drgVar:save(), ::setEmptyAndRefresh(.t.)), nil )

    endcase
  endcase

  * na pozemkyW ukládme vždy
  if('pozemkyw' $ name .and. ok, drgVAR:save(),nil)
return ok


method HIM_pozemkit_vypCen:cmp_Marked()
  local  arSelect     := ::oDBro_pozemkitW:arSelect
  local  is_selAllRec := ::oDBro_pozemkitW:is_selAllRec
  *
  local  nrec_count := pozemkitWx->( ads_getRecordCount()), nrec_work  := 1
  local  nrun_Sp    := 0, lis_recOk
  local  nfield_Out := pozemkitWx->( fieldPos( if( pozemkyW->ctask = 'DAN', "ndanNabPoz", "ncenaPoz" )))
  local  ncenaPoz   := pozemkyW->ncenaPoz
  local  nsum_podvym_M2 := 0, nlast_Rec := 0, nprum_cena_M2, ndanCena


  do case
  case ( is_selAllRec .and. len(arSelect) =  0 )
    nrun_Sp  := 1   // vše co je v seznamu
    arSelect := {}
  case ( is_selAllRec .and. len(arSelect) <> 0 )
    nrun_Sp  := 1 // vylouèit odznaèené záznamy
  case                       len(arSelect) <> 0
    nrun_Sp  := 3 // zpracovat je oznaèené záznamy
  endcase

* 1 - sum     pozemkitWx->npodVym_m2
  pozemkitWx->( dbgoTop())
  do while .not. pozemkitWx->( eof())

    nrecNo    := pozemkitWx->( recNo())
    lis_recOk := if( nrun_Sp = 1, .t., ;
                   if( nrun_Sp = 2 .and. ascan( arSelect, nrecNo) = 0, .t., ;
                     if( nrun_Sp = 3 .and. ascan( arSelect, nrecNo) <> 0, .t., .f. ) ) )

    if lis_recOk
      nsum_podVym_M2       += pozemkitWx->npodVym_m2
      nlast_Rec            := max( nlast_Rec, pozemkitWx->( recNo()) )
      pozemkitWx->_canSave := 1
    else
      pozemkitWx->_canSave := 0
      pozemkitWx->( fieldPut(nfield_Out, 0))
    endif

    pozemkitWx->( dbskip())
  enddo

* 2 - cenaM2  pozemkyW->ncenaPoz / sum => cena/m2
  nprum_cena_M2 := round(ncenaPoz/nsum_podVym_M2, 2 )

  ::sum_podVym_M2 := nsum_podVym_M2
  ::dm:set('M->sum_podVym_M2', nsum_podVym_M2 )

  ::prum_cena_M2 := nprum_cena_M2
  ::dm:set('M->prum_cena_M2' ,  nprum_cena_M2 )

* 3 - cenDan  pro vybrané záznamy  pozemkitWx->npodVym_m2 * prum_cena_M2
* 4 - rozCen  pozemkyW->ncenaPoz - cenDan
  pozemkitWx->( dbgoTop())
  ::oDBro_pozemkitW:oxbp:goTop():refreshAll()

  do while ( nrec_count >= nrec_work )

    if pozemkitWx->_canSave = 1
      ndanCena  := round(pozemkitWx->npodVym_m2 * nprum_cena_M2, 2)
      ncenaPoz  -= ndanCena
      nlast_Rec := pozemkitWx->( recNo())

      pozemkitWx->( fieldPut(nfield_Out, ndanCena))
      pozemkitWx->ncenaSDaNa := pozemkitWx->ncenaPoz +pozemkitWx->ndanNabPoz
      pozemkitWx->_canSave   := 2
      *
      * enable/ disable obtn_save_Marked
      pozemkyW->_canSave     := 2
    endif

    nrec_work++
    ::oDBro_pozemkitW:oxbp:down():refreshAll()
  enddo

* 5 -  pro poslední záznam tam strèíme rozCen
  if ncenaPoz <> 0
    pozemkitWx->(dbgoTo(nlast_Rec))
    ndanCena := pozemkitWx->( fieldGet(nfield_Out))

    pozemkitWx->( fieldPut(nfield_Out, ndanCena +ncenaPoz))
    pozemkitWx->ncenaSDaNa := pozemkitWx->ncenaPoz +pozemkitWx->ndanNabPoz
  endif

  ::sumColumn()
  pozemkitWx->( dbgoTop())
  ::oDBro_pozemkitW:oxbp:goTop():refreshAll()
return self


method HIM_pozemkit_vypCen:save_Marked()
  local  anPoz  := {}
  local  mainOk := .t., nrecOr
  *
  local  csid_pozemky := '', cpozemky

  pozemkitWx->( adsSetOrder(0), dbgoTop()                         , ;
                dbeval( { || aadd( anPoz, pozemkitWx->_nrecOr ) } , ;
                        { || pozemkitWx->_canSave = 2           }   ), ;
                dbgoTop() )

  mainOk := pozemkitSw->( sx_rLock(anPoz))

  if mainOk
    do while .not. pozemkitWx->( eof())
      nrecOr := pozemkitWx->_nrecOr

      if pozemkitWx->_canSave = 2
        pozemkitSw->( dbgoTo(nrecOr))
        *
        * pro SQL modifikaci pozemky
        cpozemky := strTran( str(pozemkitWx->nPOZEMKY), ' ', '' )
        if .not. ( cpozemky $ csid_pozemky )
          csid_pozemky += cpozemky +','
        endif

        mh_copyFld( 'pozemkitWx', 'pozemkitSw', .f., .f. )
      endif

      pozemkitWx->( dbSkip())
    enddo
  endif

  pozemkitSw->(dbunlock(),dbcommit())
  csid_pozemky := left( csid_pozemky, len(csid_pozemky) -1 )
  if( mainOk .and. len(csid_pozemky) <> 0, ::update_Pozemky(csid_pozemky), nil )

  pozemkitWx->( dbgoTop())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
return self


method HIM_pozemkit_vypCen:update_Pozemky(csid_pozemky)
  local cStatement, oStatement
  local  stmt := "update pozemky set pozemky.ncenaPoz   = ( select sum(ncenaPoz)   from pozemkit where nPOZEMKY = pozemky.sid ), " + ;
                                    "pozemky.ndanNabPoz = ( select sum(ndanNabPoz) from pozemkit where nPOZEMKY = pozemky.sid ), " + ;
                                    "pozemky.ncenaSDaNa = ( select sum(ncenaSDaNa) from pozemkit where nPOZEMKY = pozemky.sid )  " + ;
                 "where pozemky.sid in(%sid_pozemky);"


  cStatement := strTran(       stmt, '%sid_pozemky', csid_pozemky )
  oStatement := AdsStatement():New(cStatement,oSession_data)

  if oStatement:LastError > 0
*      return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif
return