#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"

#include "ads.ch"
#include "adsdbe.ch"
*
#include "..\SKLADY\SKL_Sklady.ch"


*
** CLASS SKL_pvphead_MAIN ******************************************************
CLASS  SKL_pvphead_MAIN from FIN_finance_in, WDS, SKL_datainfo
exported:
  var     m_drgDialog
  var     NEWhd, hd_file, it_file

  var     HD, IT, hd_udcp

  var     ncelkDOKLzm, ncelkDOKL, nrozPRIJzm, nCelkPCB, nCelkPCS
  var     nmnozPRdod

  var     cfg_ntypNabPol, cfg_lfakPARsym, cfg_lpovinSym, cfg_luctSKprev, cfg_cinDoklCycl
  var     recCenZbo, panGroup

  * hd    tyto prvky budou blokv·ny pokud je uzav¯eno UCT/SKL
  var     cislOBint_hd, varSym_hd, cisFak_hd, cisloDl_hd, cisZakaz_hd

  * it    seznam nov˝ch invent·rnÌch ËÌsel DIMu
  var     panew_invCISdim

  * hd/it pro vylouËenÌ p¯evzat˝ch z·znam˘ v vyrPol
  var     pa_vyrPol_ex

  *
  * napojenÌ na WDS - bacha tohle jsou objekty drgVar
  * it
  var     cisSklad , sklPol
  var     cisObj   , intCount
  var     cislOBint, cislPolob
  var     cisZakaz , vyrPol
  var     doklad_o , skladKam, sklPolKam, ucetSKKam, klicSKMis, klicODMis, invCISDim
  var     mnozPRdod
  var     mnozDOKL1, mjDOKL1, cenNADOzm
  var     o_nrecOr

  var     is_questionOk, is_pvpheadwOk, in_postValidateForm
  var     odialog_centerm

  method  init
  method  preValidate, postValidate, overPostLastField, postLastField, postSave
  method  skl_cenZboz_sel , skl_objVysit_sel, skl_objItem_sel, skl_pvpitem_sel
  method  skl_sklad_pk_sel, skl_cenZboz_pk_sel, skl_msDIm_pk_sel
  method  skl_vyrPol_sel
  *
  method  skl_c_uctskp_sel, skl_c_prepmj_sel
  method  skl_vyrCis_modi

  * propojka na smallBasket
  method  takeValue
  method  sp_saveSelectedItems, sp_overPostLastField


  * textovÈ info poloûky na kartÏ
  inline access assign method cenzboz_kDis(co) var cenzboz_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := ::cisSklad:get() + ::sklPol:get()

      if( lok := cenzboz->(dbseek(upper(cky),,'CENIK03')))
        * jen pro cennÌkovÈ poloûky *
        if upper(cenzboz->cpolcen) = 'C'
          ( retval := max(0, ::wds_cenzboz_kDis), lok := .f.)

          if isObject(::cenNADOzm) .and. ::cenNADOzm:odrg:ClassName() = 'drgGet'

            if upper(cenzboz->ctypSklCen) = 'PEV'
              ( ::cenNADOzm:odrg:isEdit := .f., ::cenNADOzm:odrg:oxbp:disable() )
            else
              ( ::cenNADOzm:odrg:isEdit := .t., ::cenNADOzm:odrg:oxbp:enable()  )
            endif
          endif
        endif
      endif

*      if isobject(::o_cenzboz_kDis)
*        if(lok, ::o_cenzboz_kDis:odrg:oxbp:show(), ::o_cenzboz_kDis:odrg:oxbp:hide())
*      endif
    endif
    return retVal

  inline access assign method objVysit_kDis()  var objVysit_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisObj) .and. isObject(::intCount)
      cky  := upper(::cisObj:get()) +strZero(::intCount:get(),5)

      if(lok := objVysit ->(dbseek(cky,,'OBJVYSI5')))
        retVal := ::wsd_objVysit_kDis
      endif

*      if isobject(::o_objitem_kDis)
*        if(lok, ::o_objitem_kDis:odrg:oxbp:show(), ::o_objitem_kDis:odrg:oxbp:hide())
*      endif
    endif
    return retVal

  inline access assign method objitem_kDis()  var objitem_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cislObInt) .and. isObject(::cislPolob)
      cky  := upper(::cislObInt:get()) +strZero(::cislPolob:get(),5)

      if(lok := objitem ->(dbseek(cky,,'OBJITEM2')))
        retVal := ::wsd_objitem_kDis
      endif

*      if isobject(::o_objitem_kDis)
*        if(lok, ::o_objitem_kDis:odrg:oxbp:show(), ::o_objitem_kDis:odrg:oxbp:hide())
*      endif
    endif
    return retVal

  *
  ** pro 400 - p¯ecenÏnÌ
  inline access assign method npuv_cenaCzbo() var npuv_cenaCzbo
    local o_nmnozPRdod, o_ncelkSlev

    if isObject(::dm)
      o_nmnozPRdod := ::dm:has( ::it_file +'->nmnozPRdod')
      o_ncelkSlev  := ::dm:has( ::it_file +'->ncelkSlev' )

      if isObject(o_nmnozPRdod) .and. isObject(o_ncelkSlev)
        return round(o_nmnozPRdod:value * o_ncelkSlev:value, 2)
      endif
    endif
  return 0

  inline access assign method ncenaSroz() var ncenaSroz
    local  o_ncenNAPdod, o_ncelkSlev

    if isObject(::dm)
      o_ncenNAPdod := ::dm:has( ::it_file +'->ncenNAPdod')
      o_ncelkSlev  := ::dm:has( ::it_file +'->ncelkSlev' )

      if isObject(o_ncenNAPdod) .and. isObject(o_ncelkSlev)
        return (o_ncenNAPdod:value - o_ncelkSlev:value)
      endif
    endif
  return 0


  inline method postDelete()
    ::nutneVn_cmp()
    ::sumColumn()
    ::wds_postDelete()

    *
    ::brow:panHome()
    ::brow:refreshAll()
    ::dm:refresh()

    ::enable_or_disable_items()
  return self


  inline method sumColumn()
    local  recNo   := pvpItemWW->( recNo())
    local  typPvp  := (::hd_file)->ntypPvp
    local  pa, x, sumCol
    *
    local cTypPohyb := LEFT( ALLTRIM(STR( (::hd_file)->nKarta)), 1 )
    local cTypHead  := SUBSTR( ALLTRIM(STR( (::hd_file)->nKarta)), 2, 1)

    ::ncelkDOKLzm  := ::nrozPRIJzm := 0
    ::ncelkDOKL    := ::nmnozPRdod := 0
    ::pa_vyrPol_ex := {}

    pvpitemWW->( dbgoTop())
    pvpItemWW->( dbeval( { || ::ncelkDOKLzm += pvpItemWW->ncenCELKzm , ;
                              ::ncelkDOKL   += pvpItemWW->ncenaCELK  , ;
                              ::nmnozPRdod  += pvpItemWW->nmnozPRdod , ;
                              if( pvpitemWW->_nrecor = 0 .and. pvpitemWW->cfile_iv ='vyrPol', aadd( ::pa_vyrPol_ex, pvpitemWW->nrecs_iv), nil ) } ), ;
                 dbgoTo( recNo )                                            )


*    pvpItemWW->( dbeval( { || ::ncelkDOKLzm += pvpItemWW->ncenCELKzm , ;
*                              ::ncelkDOKL   += pvpItemWW->ncenaCELK  , ;
*                              ::nmnozPRdod  += pvpItemWW->nmnozPRdod   } ), ;
*                 dbgoTo( recNo )                                            )


    if cTypPohyb = '1' .and. cTypHead $ '1,2,3'
    else
      pvpHeadW->nCenDokZM := ::ncelkDOKL
      pvpHeadW->ncenaPOL  := ::ncelkDOKL
      pvpHeadW->ncenaDOKL := ::ncelkDOKL
    endif

    ::nrozPRIJzm :=  pvpHeadW->ncenDOKzm +pvpHeadW->nnutneVNzm - ::ncelkDOKLzm

    pa    := { { 'pvpItemWW->nmnozPRdod', ::nmnozPRdod }, ;
               { 'pvpItemWW->ncenaCELK' , ::ncelkDOKL  }  }

    for x := 1 to len(pa) step 1
      sumCol := ::brow:cargo:getColumn_byName( pa[x,1] )
      sumCol:Footing:hide()
      sumCol:Footing:setCell(1, pa[x,2])
      sumCol:Footing:show()
    next
  return self


  inline method mnozPRdod_vld(drgVar)  // o_nmnozPRdod
    local  typPvp    := (::hd_file)->ntypPvp
    local  typSklCen := lower( cenZboz->ctypSklCen)
    local  value     := drgVar:get()
    *
    local  lok       := .t.
    local  nsign     := if( drgVar:prevValue > 0, +1, -1 )
    local  mnozDzbo  := ::wds_cenzboz_kDis +if( ::state <> 2, (drgVar:prevValue * nsign), 0 )

    do case
    case( typPvp = 1 )      // p¯Ìjem
      do case
      case ( ::o_nrecOr:value <> 0 .and. ::pvpitem_isOk() = 558 .and. ::lwatchPrij )
        lok := .f.
        fin_info_box( 'Poloûku p¯Ìjemky, ' +CRLF +'nelze opravit neboù jiû existujÌ pozdÏjöÌ v˝dejky na poloûku  ...', XBPMB_CRITICAL )

      case value < 0
        if ( abs(value) > mnozDzbo )
          lok := .not. ( typSklCen = 'pru' )
          fin_info_box( 'DispoziËnÌ mnoûstvÌ je pouze [' +str(mnozDzbo) +'] ...', if(lok, XBPMB_WARNING, XBPMB_CRITICAL) )
        endif
      endcase

    case( typPvp = 2 )      // v˝dej
      do case
      case value > 0
        if ( abs(value) > mnozDzbo )
          lok := .not. ( typSklCen = 'pru' )
          fin_info_box( 'DispoziËnÌ mnoûstvÌ je pouze [' +str(mnozDzbo) +'] ...', if(lok, XBPMB_WARNING, XBPMB_CRITICAL) )
        endif
      endcase

    case( typPvp = 3 )      // p¯evod
      do case
      case value > 0
        if ( abs(value) > mnozDzbo )
          lok := .not. ( typSklCen = 'pru' )
          fin_info_box( 'DispoziËnÌ mnoûstvÌ je pouze [' +str(mnozDzbo) +'] ...', if(lok, XBPMB_WARNING, XBPMB_CRITICAL) )
        endif
      endcase

    endcase
  return lok


hidden:
  var     o, dm, df, msg
  var     cflt_pvpTerm

  method  pvp_katCzbo, pvp_invCISdim, pvp_mnozZ_objvysit, pvp_mnozZ_vyrPol, pvp_mnozPRdod, pvp_cenNAPdod, pvp_nazPol
*  method  sp_saveSelectedItems, sp_overPostLastField


  inline method show_KDis(citem, xval)
    local ovar := ::dm:has(citem)

    if( isObject(ovar), ovar:set(xval), nil)
  return

  inline method nutneVn_cmp()
    local nOldRec := pvpitemWW->( RecNo())
    *
    local nsuma_PEV := 0
    local nSuma     := 0, nRest, nKoef, nNewSuma := 0, nrozdil := 0, nCenaCELK, nItemVN
    local nSumaZM   := 0, nRestZM, nKoefZM, nCenaCELKZM, nItemVNZM
    *
    local cTypPohyb := LEFT( ALLTRIM(STR( (::hd_file)->nKarta)), 1 )
    local cTypHead  := SUBSTR( ALLTRIM(STR( (::hd_file)->nKarta)), 2, 1)
    *
    local  pa_items := {}, x

    *
    if cTypPohyb = '1' .and. cTypHead $ '1,2,3'

*      if pvpheadW->nNutneVN <> 0

        pvpitemWW->( dbgoTop())

        do while .not. pvpitemWW->( eof())
          if upper(pvpitemWW->ctypSKLcen) = 'PRU'
            nSuma   += pvpitemWW->nmnozPRdod * pvpitemWW->ncenNAPdod
            nSumaZM += pvpitemWW->nMnozDokl1 * pvpitemWW->ncenNaDoZM
            aadd( pa_items, pvpitemWW->( recNo()) )
          else
            nsuma_PEV += pvpitemWW->nmnozPRdod * pvpitemWW->ncenNAPdod
          endif
          pvpitemWW->( dbskip())
        enddo

        nSuma  := Round( nSuma, 2)
        nRest  := pvpheadW->nNutneVN
        nKoef  := If( nSuma <> 0, pvpheadW->nNutneVN / nSuma, 0 )
        *
        nSumaZM := Round( nSumaZM, 2)
        nRestZM := pvpheadW->nnutneVNzm
        nKoefZM := If( nSumaZM <> 0, pvpheadW->nnutneVNzm / nSumaZM, 0 )

        for x := 1 to len(pa_items) step 1
          pvpitemWW->( dbgoTo( pa_items[x] ))

          * v TuzemskÈ_MÏnÏ
          nCenaCELK := pvpitemWW->nmnozPRdod * pvpitemWW->ncenNAPdod
          nItemVN   := If( x = len(pa_items), nRest, ROUND( ( nCenaCELK * nKoef ), 2 ) )

          pvpitemWW->nCenaCelk  := nCenaCELK + nItemVN
          pvpitemWW->nRozdilPoh := nItemVN
          pvpitemWW->nCenapDZBO := pvpitemWW->nCenaPZBO * ( 1 + ( SeekKodDph( pvpitemWW->nKlicDph) / 100))

          nRest := nRest - Round( (( pvpitemWW->nMnozPrDOD * pvpitemWW->nCenNapDOD) * nKoef ), 2 )

           * v ZahraniËnÌ_MÏnÏ
          nCenaCELKZM := pvpitemWW->nMnozDokl1 * pvpitemWW->ncenNaDoZM
          nItemVNZM   := If( x = len(pa_items), nRestZM, ROUND( ( nCenaCELKZM * nKoefZM ), 2 ) )

          pvpitemWW->nCenCelkZM  := nCenaCELKZM + nItemVNZM
          pvpitemWW->nrozPOHzm   := nitemVNzm
          nRestZM := nRestZM - Round( (( pvpitemWW->nMnozDokl1 * pvpitemWW->nCenNaDoZM) * nKoefZM ), 2 )
          *
          nnewSuma += pvpitemWW->nCenaCelk
        next

        nRozdil := round( pvpheadW->ncenaDOKL +pvpheadW->nnutneVN -(nnewSuma +nsuma_PEV), 2)
        *
        pvpheadW->ncenaPol := nnewSuma
        pvpheadW->nrozPrij := nRozdil
        ::dm:set('pvpheadW->nrozPrij', nRozdil)

*      else

*        pvpitemWW->nCenaCelk := Round( pvpitemWW->nMnozPrDOD * pvpitemWW->nCenNapDOD, 2 )
*        pvpitemWW->nCenapDZBO := pvpitemWW->nCenaPZBO * ( 1 + ( SeekKodDph( pvpitemWW->nKlicDph) / 100))
*        pvpitemWW->( dbeval( { || nSuma += pvpitemWW->ncenaCelk } ))
*        pvpheadW ->nrozPrij := round( pvpheadW->ncenaDOKL -nSuma, 2)
*      endif

      pvpitemWW->( dbGoTo( nOldRec))
    endif
  return self

ENDCLASS


method SKL_pvphead_MAIN:init(parent)
  local  cinDoklCycl := sysConfig( 'Sklady:cinDoklCycl' )

  ::m_drgDialog     := parent:drgDialog
  ::o               := parent
  ::dm              := parent:dm
  ::df              := parent:df
  ::msg             := parent:msg
  *
  ::ncelkDOKLzm  := ::ncelkDOKL := ::nrozPRIJzm := 0
  ::nmnozPRdod   := 0
  ::nCelkPCB     := ::nCelkPCS  := 0
  ::pa_vyrPol_ex := {}

  ::cfg_ntypNabPol  := sysConfig( 'Sklady:nTypNabPol' )
  ::cfg_lpovinSym   := SysConfig( 'Finance:lPovinSym' )
  ::cfg_lfakPARsym  := SysConfig( 'Sklady:lFakParSym' )
  ::cfg_luctSKprev  := SysConfig( 'Sklady:luctSKprev' )
  ::cfg_cinDoklCycl := if( isCharacter(cinDoklCycl), allTrim(cinDoklCycl), '' )

  ::recCenZbo       := cenZboz->( RecNo())
  ::panew_invCISdim := {}


  ::FIN_finance_in:init(self,'ucd','pvpItemWW->csklPol','_pohybovÈho dokladu_',.t.)
  *
  ** napojenÌ na WDS
  ::cisSklad   := ::dm:get( ::it_file +'->ccisSklad', .f.)
  ::sklPol     := ::dm:get( ::it_file +'->csklPol'  , .f.)

  ::hd_file := ::hd
  ::it_file := ::it

  ::wds_connect(self)
  ::cwds_itmnoz     := 'nmnozDokl1'
  ::cwds_itmnoz_org := 'nmnozD_org'
  ::bwds_objitem    := COMPILE( 'objitem->nmnozOBodb -objitem->nmnozPLodb' )

  ::sumColumn()
return self


method SKL_pvphead_MAIN:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-')
  *
  local  filter, cky
  local  sid := isNull( pvpitemWW->sid, 0 ), lok := .t.

  * My
  * myöÌ se snaûÌ dostat na poloûky, je pot¯eba zkotrolovat hlaviËku
  if ( file = ::it_file .and. sid = 0 .and. .not. ::is_pvpheadwOk )
    lok := ::postValidateForm(::hd_file)

    if( lok, (::restColor(), ::df:setNextFocus(::one_edt,, .T. )), nil )
    ::is_pvpheadwOk := lok
  endif

  do case
  case( file = ::hd_file )
  otherWise
    do case
    case( name = ::it_file +'->cmjdokl1' )
      cky := ::cisSklad:get() + ::sklPol:get()

      if cenZboz->( dbseek( cky,, 'CENIK12' ))

        filter := "( upper(czkratJedn) = '" +upper(cenZboz->czkratJedn) +"'"

        c_prepmj->( ordSetFocus('C_PREPMJ02')                                                               , ;
                    dbsetScope( SCOPE_BOTH, cky )                                                           , ;
                    dbgoTop()                                                                               , ;
                    dbeval( { || filter += " or upper(czkratJedn) = '" +upper(c_prepmj->cvychoziMj) +"'" } ), ;
                    dbclearScope()                                                                            )

         filter += " )"
         c_jednot->( ads_setAof(filter), dbgoTop() )

      else
        if( .not. empty(c_jednot->( ads_getAof())), c_jednot->( ads_clearAof(), dbgoTop()), nil )
      endif

    endcase
  endcase
return lok


/*
      do case
      case nevent = xbeP_SetInputFocus .or. mp1 = xbeK_RETURN .or. mp1 = xbeK_TAB
        ok := ::objhead_z_sel( if( empty(value), ::drgDialog, nil ) )

//        ok := if( ::nazOdes:odrg:isEdit, .t., ::objhead_z_sel( if( empty(value), ::drgDialog, nil ) ))
      endcase
*/


method SKL_pvphead_MAIN:postValidate(drgVar, dm)
  local  value  := drgVar:get()
  local  name   := Lower(drgVar:name)
  local  file   := drgParse(name,'-'), m_file
  local  lok    := .T., changed := drgVar:Changed()
   * F4
  local  nevent := mp1 := mp2 := nil
  local  always := 'ddatpvp' $ lower( name), lwaring := .f., cc, lcmp_nutneVN := .f.
  local  pa_kurz
  local  lValid := (::NEWhd .or. changed .or. always ), cKey, aKurz
  *
  local  nprep_nmnozPRdod, nkoef_prVC_MJ, old_sklad
  local  nkoe   := ((::hd_file)->nkurzahmen / (::hd_file)->nmnozprep)

  local  o_skladKAM  , o_sklPolKAM
  local  o_nmnozDokl1, o_cmjDokl1  , o_ncenaDokl1, o_ncenaCelk
  local                              o_ncenNADOzm, o_ncenCZAKzm, o_ncenCELKzm
  local  o_nmnozPRdod              , o_ncenNAPdod
  local                                            o_ncenaCzbo
  local  o_nazPol1
  *
  local  lastOk          := .f.
  local  typPvp          := (::hd_file)->ntypPvp
  local  ctypPoh         := if( typPvp = 1, 'p¯ijatÈ', if( typPvp = 2, 'vydanÈ', 'p¯evodu' ))
  local  cisSklad        := (::hd_file)->ccisSklad
  local  nsign_prevValue := +1, nsign_value := +1
  *
  local  m_dm     := ::dm
  local  aMembers := ::df:aMembers, nlastDRGIx := ::df:nlastDRGIx

  if( isObject(dm), ::dm := dm, nil )

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *
  if( ::df:in_postvalidateForm .and. (file = ::hd_file), file := '', nil )


  do case
  case( file = ::hd_file )
    * kontroly a v˝poËty na hlaviËce
    do case
    case( name = ::hd_file +'->ctyppohybu' )
      lok := ::o:skl_typPoh_sel()

    case( name = ::hd_file +'->ccissklad'  )
      old_sklad := pvpHeadW->ccisSklad
            lok := ::o:sklad_sel()
     if( old_sklad <> pvpHeadW->ccisSklad, ::odialog_centerm := nil, nil )

    case( name = ::hd_file +'->ndoklad'    )
      lok := ::o:doklad_vld(value)

    case( name = ::hd_file +'->ddatpvp'    )
      if .not. ( year(value) = uctObdobi:SKL:nROK .and. month(value) = uctObdobi:SKL:nOBDOBI)
        drgMsgBox(drgNLS:msg( 'Datum po¯ÌzenÌ dokladuje mimo aktu·lnÌ obdobÌ !'))
      endif

    case ( name = ::hd_file + '->ncisfirmy' .and. changed )
      lOK := ::o:skl_firmy_sel()

    case ( name = ::hd_file +'->czahrmena' .and. changed )
      pa_kurz := lastKurz( value, pvpHeadW->dDatPVP )
      ::dm:set( ::hd_file + '->nKurZahMen', pa_kurz[ 2] )
      ::dm:set( ::hd_file + '->nMnozPrep' , pa_kurz[ 1] )
      ::o:refreshAndSetEmpty()
      ::dm:save()

    case ( name = ::hd_file + '->ccislobint' )
      if typPvp = 1           // p¯Ìjemky - nabÌdka objVyshd
        lOK := ::o:skl_objVyshd_sel()
      else                    // v˝dejky  - nabÌdka objHead
        lOK := ::o:skl_objHead_sel()
      endif

*
*   PRI - dodacÌ list p¯ijat˝  , faktura p¯ijat·   DODLSTPHD / FAKPRIHD
*   VYD - dodacÌ list vystaven˝, faktura vystaven· DODLSTHD  / FAKVYSHD
    case ( name = ::hd_file +'->ncisfak' .or. name = ::hd_file +'->ncislodl' )
      if ( value = 0 )
        do case
        case ( name = ::hd_file +'->ncisfak'  .and.       ::cfg_lfakPARsym )
          ( lwaring := .t., cc := '»Ìslo faktury'        )

        case ( name = ::hd_file +'->ncislodl' .and. .not. ::cfg_lfakPARsym )
          ( lwaring := .t., cc := '»Ìslo dodacÌho listu' )
        endcase

        if lwaring
          fin_info_box( 'POZOR: ' +cc +' je p·rovacÌm symbolem !', if( ::cfg_lpovinSym, XBPMB_CRITICAL, XBPMB_WARNING ) )
          lok := if( ::cfg_lpovinSym, .f., .t. )
        endif
      endif

    case ( name = ::hd_file +'->cciszakaz' .and. changed )  // SKL_PRI115,SKL_VYD215 vyrZak
       lOK := ::o:skl_vyrZak_sel()

    case ( name = ::hd_file +'->ncendokzm' .and. changed )
      ::dm:set( ::hd_file +'->ncenaDokl', value * nkoe )
      ::dm:save()
      lcmp_nutneVN := .t.

    case ( name = ::hd_file +'->nnutnevnzm' .and. changed )
      ::dm:set( ::hd_file +'->nnutnevn', value * nkoe )
      ::dm:save()

      lcmp_nutneVN := .t.
    endcase
    *
    * hlaviËku ukl·d·me na kaûdÈm prvku
    if( drgVar:changed() .and. lok, drgVar:save(), nil )

    * p¯epoËteme nutne VN pokud doöko ke zmÏnÏ ncendokzm/ nnutnevnzm
    if( lok .and. lcmp_nutneVN, ::nutneVn_cmp(), nil )

  otherWise
    * konroly a v˝poËty na poloûce
    o_skladKAM    := ::dm:has( ::it_file +'->cskladKAM' )
    o_sklPolKAM   := ::dm:has( ::it_file +'->csklPolKAM')

    o_nmnozDokl1  := ::dm:has( ::it_file +'->nmnozDokl1')
    o_cmjDokl1    := ::dm:has( ::it_file +'->cmjDokl1'  )
    o_ncenNADOzm  := ::dm:has( ::it_file +'->ncenNADOzm')
    o_ncenCZAKzm  := ::dm:has( ::it_file +'->ncenCZAKzm')
    o_ncenCELKzm  := ::dm:has( ::it_file +'->ncenCELKzm')

    o_ncenaDokl1  := ::dm:has( ::it_file +'->ncenaDokl1')
    o_ncenaCelk   := ::dm:has( ::it_file +'->ncenaCelk' )
    *
    o_nmnozPRdod  := ::dm:has( ::it_file +'->nmnozPRdod')
    o_ncenNAPdod  := ::dm:has( ::it_file +'->ncenNAPdod')
    o_ncenCZAK    := ::dm:has( ::it_file +'->ncenCZAK'  )
    *
    o_ncenaCzbo   := ::dm:has( ::it_file +'->ncenaCzbo' )

    nkoef_prVC_MJ := koefPrVC_MJ( if( isObject(o_cmjDokl1),o_cmjDokl1:value, ''), CenZboz->cZkratJedn, 'cenZboz' )

*    if( ::df:in_postvalidateForm, drgVar:odrg:setFocus(), nil )

    do case
    case( name = ::it_file +'->ccisobj'    .and. changed)
      lok := ::skl_objvysit_sel()

    case( name = ::it_file +'->ccislobint' .and. changed)
      lok := ::skl_objitem_sel()


* SKL_PRI115 SKL_VYD215
    case( name = ::it_file +'->cciszakaz' .or. name = ::it_file +'->cvyrpol' ) .and. changed
      lok := ::skl_vyrPol_sel()


    case( name = ::it_file +'->csklpol'   )
     if ( empty(value) .or. .not. cenZboz->(dbseek( Upper(cisSklad) + Upper(value),, 'CENIK03')))
       lok := ::skl_cenZboz_sel()
     else

       if  changed
         ::recCenZbo := cenZboz->( recNo())
         ::takeValue( ::it_file, 'cenZboz', 2 )
       endif
     endif


* 305 - p¯evod
    case( name = ::it_file +'->cskladkam'  )
      lok := ::skl_sklad_pk_sel()

    case( name = ::it_file +'->csklpolkam' )
      if( .not. ::cfg_luctSKprev, ::df:setNextFocus( ::it_file +'->ctext',,.T.), nil )

    case( name = ::it_file +'->nucetskkam')
      lok := ::skl_c_uctskp_sel()

      if lok
        fordRec( {'cenzboz'} )
        ckey := upper(o_skladKAM:value) +upper(o_sklPolKAM:value)
        if cenZboz->( dbseek( ckey,, 'CENIK03'))
          if value <> cenZboz->nucetSkup
            fin_info_box( 'P¯evod nelze uskuteËnit na poloûku s jinou ˙ËetnÌ skupinou !', XBPMB_CRITICAL )
            lok := .f.
          endif
        endif

        fordRec()
      endif
* 305 - p¯evod

    case( name = ::it_file +'->nmnozdokl1' .or. name = ::it_file +'->cmjdokl1' .or.  name = ::it_file +'->ncennadozm' )

      * 1 - ¯·dek poloûky
      if( isObject(o_ncenCZAKzm), o_ncenCZAKzm:set( round( o_nmnozDokl1:value * o_ncenNADOzm:value, o_ncenCELKzm:ref:adt_dec )), nil )
      if( isObject(o_ncenCELKzm), o_ncenCELKzm:set( round( o_nmnozDokl1:value * o_ncenNADOzm:value, o_ncenCELKzm:ref:adt_dec )), nil )

      * 2 - ¯·dek poloûky
      nprep_nmnozPRdod := SKL_prepocetMJ( o_nmnozDokl1:value, o_cmjDokl1:value, cenZboz->czkratJedn, 'cenzboz' )
      o_nmnozPRdod:set(nprep_nmnozPRdod)

      if( isObject(o_ncenCZAK ) , o_ncenCZAK:set( round(o_ncenCELKzm:value  * nkoe, 2 ) )             , nil )
      if( isObject(o_ncenaCelk ), o_ncenaCelk:set( round(o_ncenCELKzm:value * nkoe, 2 ) )             , nil )
      if( isObject(o_ncenNAPdod), o_ncenNAPdod:set( round(o_ncenaCelk:value / o_nmnozPRdod:value, 4) ), nil )

      * 3 - kontrola na o_nmnozPRdod
      nsign_prevValue := if( o_nmnozDokl1:prevValue > 0, +1, -1 )
      nsign_value     := if( o_nmnozDokl1:Value     > 0, +1, -1 )

      do case
      case nprep_nmnozPRdod = 0
        fin_info_box( 'MnoûstvÌ ' +ctypPoh +' nesmÌ b˝t NULOV… ...  ', XBPMB_CRITICAL )

        ::dm := m_dm
        return .f.

      case ( ( typPvp = 3 .or. ::o:nkarta = 205 ) .and. nprep_nmnozPRdod < 0 )
        if( ::o:nkarta = 205, ctypPoh := 'v˝deje do DIMu', nil )
        fin_info_box( 'MnoûstvÌ ' +ctypPoh +' nesmÌ b˝t Z¡PORN… ...  ', XBPMB_CRITICAL )

        ::dm := m_dm
        return .f.

      case ( ::o_nrecOr:value <> 0 .and. nsign_prevValue <> nsign_value )
        fin_info_box( 'MnoûstvÌ ' +ctypPoh +' p¯ech·zÌ p¯es absolutnÌ hodnotu ...  ', XBPMB_CRITICAL )

        ::dm := m_dm
        return .f.

*      case o_ncenCELKzm:value = 0
*        fin_info_box( 'Cena za mj ' +ctypPoh +' nesmÌ b˝t NULOV… ...  ', XBPMB_CRITICAL )
*        return .f.

      endCase


      lok := ::mnozPRdod_vld(o_nmnozPRdod)

    case( name = ::it_file +'->ncennadozm' )
      o_ncenCELKzm:set( round(o_nmnozDokl1:value * value, o_ncenCELKzm:ref:adt_dec) )

      o_ncenaCelk:set( round(o_ncenCELKzm:value * nkoe, 2 ) )
      o_ncenNAPdod:set( round(o_ncenaCelk:value / o_nmnozPRdod:value, 4) )

    case( name = ::it_file +'->ncenadokl1' )
      o_ncenaCelk:set(  o_nmnozDokl1:value * value )

      nkoef_prVC_MJ := koefPrVC_MJ( o_cmjDokl1:value, CenZboz->cZkratJedn, 'cenZboz' )
      o_ncenNAPdod:set( o_ncenaDokl1:value / nkoef_prVC_MJ )

    case( name = ::it_file +'->ncennapdod' )
      o_ncenaCzbo:set( round( o_nmnozPRdod:value * value          , o_ncenaCzbo:ref:adt_dec ))
      o_ncenaCelk:set( round( o_ncenaCzbo:value  - ::npuv_cenaCzbo, o_ncenaCelk:ref:adt_dec ))
      ::dm:set( 'M->ncenaSroz', ::ncenaSroz )


    case( name = ::it_file +'->ninvcisdim' )
      lok := ::skl_msDIm_pk_sel()

    case( name = ::it_file +'->cnazpol3'   )
     if cnazPol3->lzavren
       cc := allTrim(cnazPol3->cnazPol3) +'_' +allTrim(cnazPol3->cnazev)
       fin_info_box( 'Zak·zka [ ' +cc +' ] je jiû byla uzav¯ena ...  ', XBPMB_CRITICAL )
       lok := .f.
     endif

/*
      lOK := ! ::ZakUKONC( 7, value )
      *
      ** v˝dej na zak·zku, pokud existujÌ poloûky v vyrZakit tak je nabÌdneme
      if lok .and. ::nkarta = 204
        * obecnÏ a Elektrosvit
        if .not. Empty( value)
          ::skl_vyrzakit_sel(value)
        endif
      endif
*/
    endcase

    if( nevent = xbeP_Keyboard .and. isNumber(mp1) )
      if( mp1 = xbeK_RETURN .and. lok)

        if ( name = ::it_file +'->cnazpol6' )
          lastOk := .t.

        else
          do case
          case ( name = ::it_file +'->nmnozdokl1' )                 // c_prepMj
            if c_jednot->( ads_getKeyCount(1)) = 1
              ::df:setNextFocus('pvpitemWW->ncenNADOzm',,.t.)
            endif

          case ( name = ::it_file +'->ctext'      )                 // SKL_PRI
            o_nazPol1 := ::dm:has( ::it_file +'->cnazPol1' )

          case ( name = ::it_file +'->nmnozprdod' )                 // SKL_VYD
            o_nazPol1 := ::dm:has( ::it_file +'->cnazPol1' )

          case ( name = ::it_file +'->ncennapdod' )                // SKL_CEN400
            o_nazPol1 := ::dm:has( ::it_file +'->cnazPol1' )

          endcase

          if isObject(o_nazPol1)
            lastOk := .not. o_nazPol1:odrg:isEdit
          endif
        endif

        if .not. lastOk
          BEGIN SEQUENCE
          for x := nlastDRGIx +1 to len(aMembers) step 1
            if aMembers[x]:isEdit
              if     aMembers[x]:className() <> 'drgDBrowse'
          BREAK
              elseif aMembers[x]:className() =  'drgDBrowse'
                lastOk := .t.
          BREAK
              endif
            endif
          next
          END SEQUENCE
        endif

        if lastOk
*           ::df:nexitState := 1  // GE_UP
*           postAppEvent(drgEVENT_ACTION, drgEVENT_SAVE,'2',drgVar:odrg:oXbp)

          _clearEventLoop(.t.)
          if( ::overPostLastField(), ::postLastField(), nil )
        endif

      endif
    endif
  endCase

  ::dm := m_dm
return lok


//  odialog:destroy()
//  odialog := nil


*
** pvpitemWW SEL-dialogy
*
* p¯Ìjemky - objedn·vky vystavenÈ objVysit.ccisObj
method skl_pvpHead_main:skl_objVysit_sel(drgDialog)
  local  odialog, nexit, lok := .f.
  local  cisFirmy  := (::hd_file)->ncisfirmy
  local  cisSklad  := (::hd_file)->ccisSklad
  local  cislOBint := (::hd_file)->ccislOBint
  local  value     := ::dm:get( 'pvpitemWW->ccisObj' )
  *
  local  cf, filter, pa_wds := ::wds_objvysit
  local  pa_arSelect

  if .not. empty(cislOBint)
    cf     := "ncisfirmy = %% and ccisSklad = '%%' and ccisObj = '%%'"
    filter := format( cf, { cisfirmy, cisSklad, left(cislOBint,15) } )
  else
    cf     := "ncisfirmy = %% and ccisSklad = '%%'" +if( .not. empty(value)," .and. ccisObj = '%%'", '')
    filter := format(cf, if(empty(value),{cisfirmy, cisSklad},{cisfirmy, cisSklad, value}))
  endif

  objvysit->( ads_setAof(filter), dbgoTop() )

  if isObject(drgDialog) .or. !lok
    odialog := drgDialog():new( 'SKL_OBJVYSIT_SEL', ::m_drgDialog)
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if nexit = drgEVENT_SELECT
    if odialog:udcp:sp_Saved
      pa_arSelect := odialog:udcp:d_Bro:arSelect
      ::sp_saveSelectedItems('objVysit', 4, pa_arSelect)
    else
      ::takeValue( ::it_file, 'objVysit', 4 )
    endif
  endif
return .t.


*
* v˝dej/ p¯evod - objedn·vky p¯ijatÈ  objitem.ccisOBint
method skl_pvpHead_main:skl_objitem_sel(drgDialog)
  local  odialog, nexit, lok := .f.
  local  nkarta    := pvpheadW->nkarta
  local  cisFirmy  := (::hd_file)->ncisfirmy
  local  cisSklad  := (::hd_file)->ccisSklad
  local  cislOBint := (::hd_file)->ccislOBint
  local  value     := ::dm:get( 'pvpitemWW->ccisOBint' )
  *
  local  cf        := "ncisfirmy = %% and ccisSklad = '%%' .and. (nmnozOBodb -nmnozPLodb) > 0 .and. upper(crozATRpro) <> 'ROK'"
  local  filter, pa_wds := ::wds_objItem
  local  pa_arSelect
  local  lok_it, pa_remove := {}
  *
  ** Hydrap specifikum crozATRpro <> ROK ostatnÌm by to nemÏlo vadit, ale musel se upravit filtr
  **
  if .not. empty(cislOBint)
    cf     += " .and. ccislOBint = '%%'"
    filter := format( cf, { cisfirmy, cisSklad, cislOBint } )
  else
    cf     += if( .not. empty(value)," .and. ccislOBint = '%%'", '')
    filter := format(cf, if(empty(value),{cisfirmy, cisSklad},{cisfirmy, cisSklad, value}))
  endif

  objItem->( ads_setAof(filter), dbgoTop() )
  *
  ** musÌme vylouËit poloûky ukonËen˝ch zak·zek
  do while .not. objItem->( eof())
    lok_it := .t.
    if vyrZak->( dbseek( upper(objItem->ccislOBint),, 'VYRZAK10'))
      lok_it := ( vyrZak->cstavZakaz <> 'U' )
    endif

    if( lok_it, nil, aadd( pa_remove, objItem->(recNo()) ) )
    objItem->( dbskip())
  enddo

  if( len(pa_remove) <> 0, objItem->( Ads_CustomizeAOF( pa_remove, 2 )), nil )
  objItem->( dbgoTop())


  if isObject(drgDialog) .or. !lok
    odialog := drgDialog():new( 'SKL_OBJITEM_SEL', ::m_drgDialog)
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if nexit = drgEVENT_SELECT
    if odialog:udcp:sp_Saved
      pa_arSelect := odialog:udcp:d_Bro:arSelect
      ::sp_saveSelectedItems('objitem', 5, pa_arSelect)
    else
      ::takeValue( ::it_file, 'objitem', 5 )
    endif
  endif
return .t.

*
* all - cenZboz.csklPol
method skl_pvpHead_main:skl_cenZboz_sel(drgDialog)
  local  odialog, nexit, lok := .f.
  local  cisSklad := pvpHeadW->ccisSklad, typPvp := pvpHeadW->ntypPvp
  local  drgVar   := ::dm:get( 'pvpItemWW->csklPol', .F.)
  local  value    := upper( drgVar:get())
  *
  local  iz_file, iz_pos

  local  flt_cenZboz, flt_pvpTerm, apuq_cenZboz


  if( .not. empty(c_jednot->( ads_getAof())), c_jednot->( ads_clearAof()), nil )
  *
  ** cenZboz / pvpTerm
  flt_cenZboz := Format("ccisSklad = '%%'", { cisSklad } )
  Filter      := Format("ccisSklad = '%%' .and. ntypPVP = %% .and. nStav_PLN <> 2", { cisSklad, typPVP })
  PVPterm->( mh_SetFilter( Filter, -3))

  lOk    := ( !empty(value) .and. cenZboz->(dbseek( Upper(cisSklad) + value,, 'CENIK03')))
  ::m_drgDialog:cargo_usr := if( lok, 1, 0 )

  if isObject(drgDialog) .or. !lok

   if( isMethod( ::dm:drgDialog, 'quickShow' ) .and. isObject( ::odialog_centerm ))
      odialog := ::odialog_centerm

      apuq_cenZboz := odialog:get_APU_filter('cenzboz', 'APUQ' )
      cenZboz->( ads_setAof( apuq_cenZboz ), dbgoTo( ::recCenZbo) )

      pvpTerm->( ads_setAof( ::cflt_pvpTerm ))
      odialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
      postAppEvent( xbeBRW_ItemMarked,,, odialog:dialogCtrl:oaBrowse:oxbp )

      odialog:quickShow(.t.)
    else
      odialog := drgDialog():new('SKL_centerm_SEL', ::m_drgDialog)
      odialog:set_prg_filter( flt_cenZboz, 'cenZboz')
      odialog:create(,,.T.)

      ::odialog_centerm := odialog
      ::cflt_pvpTerm    := pvpTerm->( ads_getAof())
    endif

          nexit := odialog:exitState
    ::recCenZbo := cenZboz->( recNo())

  endif

  if nexit != drgEVENT_QUIT .or. lok
    if( ::m_drgDialog:cargo_usr = 1, ( iz_file := 'cenZboz', iz_pos := 2 ), ;
                                     ( iz_file := 'pvpTerm', iz_pos := 3 )  )

    ::takeValue( ::it_file, iz_file, iz_pos)

    _clearEventLoop(.t.)
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oxbp)
  endif

  if( .not. empty(cenZboz->( ads_getAof())), cenZboz->( ads_clearAof()), nil )
return lok


* storno - poloûky pohybu pvpitem_ss.ndoklad
method skl_pvpHead_main:skl_pvpitem_sel(drgDialog)
  local  odialog, nexit, lok := .f.
  local  flt_objiem

*  local  ncisFirmy := if( ::nKarta = 274 .or. ::nKarta = 293, 1, pvpHeadW->nCisFirmy)
*  *
*  ** Hydrap specifikum crozATRpro <> ROK ostatnÌm by to nemÏlo vadit, ale musel se upravit filtr
*  local cf := "ncisFirmy = %% .and. (nmnozObODB -nmnozPlOdb) > 0 .and. upper(crozATRpro) <> 'ROK'"


 if isObject(drgDialog) .or. !lok
    odialog := drgDialog():new( 'SKL_PVPITEM_SEL', ::m_drgDialog)
    odialog:create(,,.T.)
  endif
return .t.


* p¯evod - sklad/ sklPol/ uctskp -> Kam
method skl_pvphead_main:skl_sklad_pk_sel(drgDialog)
  local  odialog, nexit
  local  skladKam := upper(::skladKam:value)
  local  lok      := ( !Empty(skladKam) .and. c_sklady->(dbseek(skladKam,,'C_SKLAD1')))

  if isObject(drgDialog) .or. !lok

     ::df:setNextFocus( ::it_file +'->cSkladKAM',,.T.)

     odialog := drgDialog():new( 'C_SKLADY', ::m_drgDialog )
     odialog:cargo := skladKam
     odialog:create(,,.T.)

     if odialog:exitState = drgEVENT_SELECT
       ::skladKam:set(odialog:cargo)
       lok := .t.

       ::df:setNextFocus( ::it_file +'->csklpPolKam',,.T.)
     endif

     if( .not. lok,  _clearEventLoop(.t.) , nil )
   endif
return lok


method skl_pvphead_main:skl_cenZboz_pk_sel(drgDialog)
  local  odialog, nexit, lok := .f.
  local  skladKam       := upper(::skladKam:value)
  local  sklPolKam      := upper(::sklPolKam:odrg:oxbp:value)
  local  cky            := padr(skladKam,8) +padr(sklPolKam,15)
  *
  local  flt_cenZboz_pk := format("ccisSklad = '%%'", { skladKam } )

  lOk    := cenZboz_pk->( dbseek( cky,, 'CENIK03'))

  if isObject(drgDialog) .or. !lok

    odialog := drgDialog():new('SKL_cenZboz_pk_SEL', ::m_drgDialog)
    odialog:set_prg_filter( flt_cenZboz_pk, 'cenZboz_pk')
    odialog:cargo := if( lOk, cenZboz_pk->( recNo()), 0 )
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if nexit != drgEVENT_QUIT .or. lok
    ::dm:set( ::it_file +'->cskladKAm' , cenZboz_pk->ccisSklad )
    ::dm:set( ::it_file +'->csklPOLKam', cenZboz_pk->csklPol   )

    ::df:setNextFocus( ::it_file +'->nmnozDokl1',,.T.)
    lok := .t.
  endif
return lok


* ˙ËetnÌ skupina
method skl_pvpHead_main:skl_c_uctskp_sel(drgDialog)
  local  odialog, nexit, copy := .f.
  local  drgVar := ::dm:get( 'pvpitemWW->nucetSkKAM', .F.)
  local  value  := drgVar:get()
  local  lok    := c_uctskp->( dbseek( value,,'C_USKUP1'))

  if isObject(drgDialog) .or. !lok
    odialog       := drgDialog():new('c_uctskp', ::m_drgDialog)
    odialog:cargo := value

    odialog:create(,,.T.)
  endif

  copy := if((lok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    lok := .T.
    ::dm:set( ::it_file +'->nucetSkKAM', c_uctskp->nucetSkup )
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oxbp)
  endif
return lok


* p¯evod do DIMu karta ... 205
method skl_pvphead_main:skl_msDIm_pk_sel(drgDialog)
  local  odialog, nexit, lok := .f., recNo := 0
  local  klicSKmis       := upper(::klicSKmis:value)
  local  klicODmis       := upper(::klicODmis:value)
  local  invCISdim       := ::invCISdim:odrg:oxbp:value
  local  cky             := klicSKmis +klicODmis +strZero(invCISdim,6)
  *                                                                    1
  local  o_file_iv       := ::dm:has( 'pvpitemWW->cfile_iv' )
  local  file_iv         := o_file_iv:value
  local  flt_msDim_pk    := format("cklicSKmis = '%%' and cklicODmis = '%%'", { klicSKmis, klicODmis } )
  *
  local  panew_invCISdim := ::panew_invCISdim

  do case
  case msDim->( dbseek( invCISdim,, 'DIM1'))
    lOk := ( upper(msDim->cklicSKmis) = klicSKmis .and. upper(msDIm->cklicODmis) = klicODmis )
    recNo := msDim->( recNo())
  otherWise
    lOk := .f.
  endcase

  if isObject(drgDialog) .or. !lok
    o_file_iv:value := ''

    odialog := drgDialog():new('SKL_msDIm_pk_SEL', ::m_drgDialog)
    odialog:set_prg_filter( flt_msDim_pk, 'msDim')
    odialog:cargo := recNo
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if nexit != drgEVENT_QUIT .or. lok
    lok := .t.
    *
    * postValidate ho tam zapÌöe 2x
    if ascan( panew_invCISdim, invCISdim ) = 0
      aadd( ::panew_invCISdim, invCISdim )
    endif

    ::df:setNextFocus( ::it_file +'->cnazPol1',,.T.)
  else
*    if( .not. empty(msDim->( ads_getAof())), msDim->(ads_clearAof()), nil )
*    ::dm:set( ::it_file +'->ninvCISdim', ::pvp_invCISdim() )
    ::df:setNextFocus( ::it_file +'->cklicSKmis',,.T.)
  endif


  o_file_iv:set(file_iv)
  if( .not. empty(msDim->( ads_getAof())), msDim->(ads_clearAof()), nil )
return lok


* SKL_PRI115, SKL_VYD215 vyrPol  -> skl_vyrPol_sel
method skl_pvpHead_main:skl_vyrPol_sel(drgDialog)
  local  odrg   := ::dm:drgDialog:lastXbpInFocus:cargo
  local  value  := ::dm:drgDialog:lastXbpInFocus:value
  local  items  := Lower(drgParseSecond(odrg:name,'>'))
  *
  local  recCnt := 0, showDlg := .f., ok := .f., isOk := .f.
  local  odialog, nexit, lok := .t.
  *
  local  ntypPvp := (::hd_file)->ntypPvp
  local  filtr, flt := "ccisZakaz = '%%' and "

*  flt += if( ntypPvp = 1, "nvyrSt <> 1 and (nmnPROhlvy -nmnSKLpri) <> 0" , ;
*                          "nvyrSt  = 2 and (nmnVYDzmon -nmnSKLvyd) <> 0"   )
*  filtr := format( flt, { cisZakaz } )
*  vyrPol->( ads_setAof(filtr), dbgoTop() )


  if isObject(drgDialog)
    showDlg := .t.

  else
    do case
    case( items = 'cciszakaz' )
        vyrpol->(AdsSetOrder('VYRPOL4')             , ;
                 dbsetscope(SCOPE_BOTH,upper(value)), ;
                 dbgotop()                          , ;
                 dbeval( {|| recCnt++ })            , ;
                 dbgotop()                            )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, vyrpol->(dbclearscope(),dbgotop()), nil)

    case( items = 'cvyrPol' )
        vyrpol->(AdsSetOrder('VYRPOL3')             , ;
                 dbsetscope(SCOPE_BOTH,upper(value)), ;
                 dbgotop()                          , ;
                 dbeval( {|| recCnt++ })            , ;
                 dbgotop()                            )

        showDlg := .not. (recCnt = 1)
             ok :=       (recCnt = 1)
        if(recCnt = 0, vyrpol->(dbclearscope(),dbgotop()), nil)
    endcase
  endif

  if showDlg
    odialog := drgDialog():new('skl_vyrPol_sel', ::dm:drgDialog)
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  if nexit = drgEVENT_SELECT
    if odialog:udcp:sp_Saved
      pa_arSelect := odialog:udcp:d_Bro:arSelect
      ::sp_saveSelectedItems('vyrPol', 6, pa_arSelect)
    else
      ::takeValue( ::it_file, 'vyrPol', 6 )
    endif
  endif


return (nexit != drgEVENT_QUIT) .or. ok



* evidence v˝robnÌch ËÌsel
method skl_pvpHead_main:skl_vyrCis_modi(drgDialog)
  local  odialog, nexit, lok := .f.
  local  nkey := if( ::state = 2, xbeK_INS, xbeK_ENTER )

  odialog := drgDialog():new('SKL_vyrCis_CRD', ::m_drgDialog)
  odialog:cargo     := nkey
  odialog:cargo_usr := 2

  odialog:create( ,::m_drgDialog:dialog,.T.)
  nExit := odialog:exitState

  IF nExit = drgEVENT_SAVE
  ENDIF

  odialog:destroy(.T.)
  odialog := NIL
return self


* p¯epoËty mÏrn˝ch jednotek
method skl_pvpHead_main:skl_c_prepmj_sel(drgDialog)
  local  odialog, nexit, copy := .f.
  local  drgVar := ::dm:get( 'pvpitemWW->cmjdokl1', .F.)
  local  value  := drgVar:get()
  local  lok    := c_jednot->( dbseek( upper(value),,'C_JEDNOT1'))

  if isObject(drgDialog) .or. !lok
    odialog := drgDialog():new('SKL_c_prepmj_sel', ::m_drgDialog)
    odialog:create(,,.T.)
  endif

  copy := if((lok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    lok := .T.
    ::dm:set( ::it_file +'->cmjdokl1', c_jednot->czkratJedn )
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oxbp)
  endif
return lok

*
** metody pro ukl·d·nÌ vybran˝ch poloûek v cyklu
method skl_pvpHead_main:sp_saveSelectedItems(iz_file,iz_pos,pa_arSelect)
  local  x

  for x := 1 to len(pa_arSelect) step 1
    (iz_file)->( dbgoTo( pa_arSelect[x] ))

    setAppFocus(::brow)
    ::takeValue( ::it_file, iz_file, iz_pos,, .t. )
    ::sp_overPostLastField()
   next

return self

method skl_pvpHead_main:sp_overPostLastField()
  local  pa := ::df:aMembers, x, drgVar
  *
  begin sequence
    for x := 1 to len(pa) step 1
      if isObject(drgVar := pa[x]:ovar)
        if isMemberVar( drgVar, 'name' ) .and. 'PVPITEMWW' $ drgVar:name .and. drgVar:odrg:isEdit

          if .not. ::postValidate(drgVar)
            ::df:olastdrg   := drgVar:oDrg
            ::df:nlastdrgix := x
            ::df:olastdrg:setFocus()
            return .f.
  break
          endif
        endif
      endif
    next
  end sequence

  if ::overPostLastField(.t.)
    ::postLastField()
    ::wds_watch_time()
  endif
return .t.
**
*

method skl_pvpHead_main:overPostLastField(in_spcykl)
  local  ok         := .t.
  local  lnewRec    := ( pvpitemWW->(eof()) .or. ::state = 2 )
  *
  local  o_nazPol1  := ::dm:has( ::it_file +'->cnazPol1' )
  local  cnazPol3, cc
  local  ucet       := ''
  *
  local  o_ucetSkup := ::dm:has( ::it_file +'->cucetSkup' )
  local  cKy        := upper(pvpheadw->cUloha) +upper(pvpheadw->ctypDoklad) +upper(pvpheadw->ctypPohybu)
  local  x, value   := ''


  *
  ** nov˝ poûadavek STS pro pohyb, kter˝ ˙Ëtuje tj. c_typPoh.luctuj = .t.
  ** zkontrolovat jestli existuje ˙ËetnÌ p¯edpis na ucetPRit pro cucetSkup
  if lnewRec .and. c_typPoh->luctuj
    if isObject(o_ucetSkup)
      cKy += upper( o_ucetSkup:value )
      if .not. ucetPRit->( dbseek( cKy,, 'UCETPRIT01'))
        cc := pvpheadw->ctypPohybu +' / ' +o_ucetSkup:value
        fin_info_box( '⁄ËetnÌ p¯edpis pro pohyb a ˙ËetnÌ skupinu [ ' +cc +' ] nenÌ nastaven, ' +CRLF +'nelze uloûit poloûku ...  ', XBPMB_CRITICAL )
        ::df:setNextFocus(::it_file +'->csklPol',,.t.)
        return .f.
      endif
    endif
  endif

  *
  ** nap¯ed musÌme zkontrolovat uzav¯enou zak·zku cnazPol3 a pak NS
  ** panÌ v Mopasu (ZajÌcov·) nechce kontrolovat uzav¯enou zak·zku na cnazPol3
  *  5.10.2016
  ** STS (Fric) pot¯ebuje kotrolvat uzav¯enou zak·zku, ale na cnazPol3
  *
  if isObject(o_nazPol1) .and. o_nazPol1:odrg:isEdit
    if .not. empty(cnazPol3 := upper( ::dm:get( ::it_file +'->cnazPol3' )))
       cnazPol3->( dbseek( cnazPol3,, 'CNAZPOL1' ))

       if cnazPol3->lzavren
         cc := allTrim(cnazPol3->cnazPol3) +'_' +allTrim(cnazPol3->cnazev)
         fin_info_box( 'Zak·zka [ ' +cc +' ] je jiû byla uzav¯ena ...  ', XBPMB_CRITICAL )
         ::df:setNextFocus(::it_file +'->cnazPol3',,.t.)
         return .f.
       endif
    endif

    *
    ** p˘vodnÌ poûadavek, na kter˝ se zapomÏlo, na c_typPoh.lnaklStr = .t.
    ** n·kladov· struktura nesmÌ b˝t pr·zdn·
    *
    if c_typPoh->lnaklStr
      for x := 1 to 6 step 1
        value += upper( ::dm:get(::it_file +'->cnazPol' +str(x,1)) )
      next

      if empty(value)
        fin_info_box('N·kladov· struktura je pro pohyb >' +pvpheadW->ctypPohybu +'<' +CRLF +' !!! POVINN¡ !!!')
        ::df:setNextFocus(::it_file +'->cnazPol1',,.t.)
        return .f.
      endif
    endif

    ok := ::c_naklst_vld(o_nazPol1,ucet)
    if .not. ok
      return .f.
    endif
  endif

  if lnewRec
    do case
    case ::o:nkarta = 305
      ok := ::skl_cenZboz_pk_sel()
    endcase
  endif
return ok


method skl_pvpHead_main:postLastField(dm)
  local  isChanged, file_iv, recs_iv
  local  cisZakaz, ok
  *
  local  lnewRec   := ( pvpitemWW->(eof()) .or. ::state = 2 )
  local  intCount  := if( lnewRec, ::ordItem() +1, pvpitemWW->nordItem )
  local  hd_typPoh := pvpheadW->ntypPOH
  local  m_dm      := ::dm

  if( isObject(dm), ( ::dm := dm, ::fin_finance_in:dm := dm), nil )

  isChanged := ::dm:changed()
  file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value)
  recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value

  * p¯Ìjem se nehlÌd· na WDS ale vyjÌmka je u objvysit - ten se musÌ hlÌdat
  ::nwds_sign := if( hd_typPoh = 1 .and. lower(file_iv) <> 'objvysit', +1, -1 )

*  ::nwds_sign := if( hd_typPoh = 1, +1, -1 )
  ::wds_watch_mnoz( lnewRec, intCount )
  *
  * ukl·d·me na poslednÌm PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  ok := if(::state = 2, addrec(::it_file), .t.)

  if ok
    if ::state = 2 ; if .not. empty(file_iv)
                       (file_iv)->( dbgoTo(recs_iv))
                       ::copyFldto_w(file_iv, ::it_file)
                     endif

                     ::copyFldto_w(::hd_file, ::it_file)
                     *
                     ** na pvpHead je ccisZakaz, musÌme pvpItem.ccisZakaz
                     ** naplnit ze vstupnÌho souboru, pokud tam je
                     if (file_iv)->( fieldPos( 'ccisZakaz')) <> 0
                       (::it_file)->ccisZakaz := (file_iv)->ccisZakaz
                     endif

                     (::it_file)->nordItem   := ::ordItem() +1
                     (::it_file)->ddatPVP    := date()
                     (::it_file)->ccasPVP    := time()
                     (::it_file)->ntypPoh    := pvpheadW ->ntypPohyb
    endif

    ::itSave()

    (::it_file)->ccisZakaz  := if( empty( (::it_file)->cnazPol3), (::it_file)->ccisZakaz , (::it_file)->cnazPol3 )
    (::it_file)->ccisZakazI := if( empty( (::it_file)->cnazPol3), (::it_file)->ccisZakazI, (::it_file)->cnazPol3 )

    if( pvpItemWW->ncenCELKzm = 0 , pvpItemWW->ncenCELKzm := pvpItemWW->ncenaCELK , nil )
    pvpItemWW->ncenaDokl1 := pvpItemWW->ncenNAPdod

    ::nutneVn_cmp()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshAll() )
  endif

  ::setfocus(::state)
  ::sumColumn()
  ::dm:refresh()

  ::dm                := m_dm
  ::fin_finance_in:dm := m_dm
return .t.


method skl_pvpHead_main:postSave()
  local  ctypPohybu := allTrim(pvpHeadw->ctypPohybu)
  local  ok         := .t.
  local  ctitle     := 'Doklad nelze uloûit ...'
  local  cinfo      := 'PromiÚte prosÌm,'                            +CRLF + ;
                       'doklad nem· poloûky, NELZE proto uloûit ...' +CRLF

  if isNull(pvpitemWW->sid,0) = 0
    confirmBox( , cinfo   , ;
                  ctitle  , ;
                  XBPMB_OK, ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
    return .f.
  endif


  * U p¯Ìjmov˝ch doklad˘ kontrolovat cenu na dokladu
  * P¯ed z·pisem kontrolovat duplicitu dokladu, pokud doklad jiû existuje po z·pisu
  * upozornit na zmÏnu ËÌsla dokladu !

  * cyklus po¯ÌzenÌ
  *
  * pro druh pohybu 177 musÌme zanulovat nmnozDokl1/ nmnozPRdod
  if ::o:nkarta = 177
    pvpitemWW->( AdsSetOrder(0), ;
                 dbgotop()     , ;
                 dbeval({|| ( pvpitemWW->nmnozDokl1 := 0, pvpitemWW->nmnozPRdod := 0 ) } ), ;
                 dbgotop()       )
  endif

  *
  ** uloûenÌ v trasakci
  ok := skl_pvphead_wrt_inTrans(self)

  if    ( ok .and.       ::newHd )

    pvpHeadw  ->(dbclosearea())
    pvpItemww ->(dbclosearea())
    pvpItemw  ->(dbclosearea())
    vyrCisw   ->(dbclosearea())
    vyrZakitw ->(dbclosearea())
    msDimW    ->(dbclosearea())

    if .not. empty(vyrPol->( ads_getAof()) )
      vyrZak->( ads_clearAof())
      vyrPol->( ads_clearAof())
    endif

    skl_pvpHead_cpy(self)

    ::enable_or_disable_items()
    ::del_panew_invCISdim()
    ::nutneVn_cmp()
    ::sumColumn()

    ::is_questionOk := .f.

    if ctypPohybu $ ::cfg_cinDoklCycl
      pvpHeadW->ndoklad := pvpHead->ndoklad +1
    endif


    ::df:setnextfocus('pvpHeadW->ctyppohybu',,.t.)
    ::brow:refreshAll()
    ::dm:refresh()

    ::wds_postSave()
  elseif( ok .and. .not. ::newHd )
    PostAppEvent(xbeP_Close,,,::m_drgDialog:dialog)

  endif
return ok


method skl_pvpHead_main:takeValue(it_file, iz_file, iz_pos, dm, in_spcykl )
  local  x, oVar, pos, value, items, mname, par
  local  iz_recs := (iz_file)->(recno())
  local  cky
  local  mnozReODB := 0
  local  m_dm := ::dm
  local  sID  := isNull(pvpitemWW->sID, 0)

*
*                             pvpItemWW       cenZboz             pvpTerm               objVysit                  objitem               vyrPol
*
  local  pa := { {            'ccisSklad'  , 'ccisSklad'       , 'ccisSklad'          , 'ccisSklad'             , 'ccisSklad'           , 'ccisSklad'           }, ;
                 {            'csklPol'    , 'csklPol'         , 'csklPol'            , 'csklPol'               , 'csklPol'             , 'csklPol'             }, ;
                 {            'cnazZbo'    , 'cnazZbo'         , 'cenZboz->cnazZbo'   , 'cnazZbo'               , 'cnazZbo'             , 'cnazev'              }, ;
                 {            'ckatCzbo'   , ':pvp_katCzbo'    , ':pvp_katCzbo'       , ':pvp_katCzbo'          , ':pvp_katCzbo'        , ':pvp_katCzbo'        }, ;
                 {            'ccisObj'    , ''                , ''                   , 'ccisObj'               , ''                    , ''                    }, ;
                 {            'nintCount'  , 0                 , 0                    , 'nintCount'             , 0                     , 0                     }, ;
                 {            'ncisloOBJv' , 0                 , 0                    , 'ndoklad'               , 0                     , 0                     }, ;
                 {            'ccislOBint' , ''                , ''                   , ''                      , 'ccislOBint'          , ''                    }, ;
                 {            'ncislPOLob' , 0                 , 0                    , 0                       , 'ncislPOLob'          , 0                     }, ;
                 {            'ccisZakaz'  , ''                , ''                   , ''                      , ''                    , 'ccisZakaz'           }, ;
                 {            'cvyrPol'    , ''                , ''                   , ''                      , ''                    , 'cvyrPol'             }, ;
                 {            'ninvCISdim' , ':pvp_invCISdim'  , 0                    , 0                       , 0                     , 0                     }, ;
                 {            'ndoklad_O'  , 0                 , 0                    , 0                       , 0                     , 0                     }, ;
                 {            'cskladKAM'  , ''                , 'cskladKAM'          , ''                      , ''                    , ''                    }, ;
                 {            'csklPolKAM' , 'csklPol'         , 'csklPol'            , 'csklPol'               , 'csklPol'             , 'csklPol'             }, ;
                 {            'nucetSkKAM' , 'nucetSkup'       , 'cenZboz->nucetSkup' , 'nucetSkup'             , 'cenZboz->nucetSkup'  , 'cenZboz->nucetSkup'  }, ;
                 {            'nmnozDokl1' , 0                 , 'nmnozDokl1'         , ':pvp_mnozZ_objvysit/1' , 'nmnozOBodb'          , ':pvp_mnozZ_vyrPol'   }, ;
                 {            'cmjDokl1'   , 'czkratJedn'      , 'cenZboz->czkratJedn', 'czkratJedn'            , 'czkratJedn'          , 'czkratJedn'          }, ;
                 {            'ncenNADOzm' , 'ncenaSzbo'       , 'cenZboz->ncenaSzbo' , 'ncenNAOdod'            , 'cenZboz->ncenaSzbo'  , 'cenZboz->ncenaSzbo'  }, ;
                 {            'ncenaDokl1' , 'ncenaSzbo'       , 'cenZboz->ncenaSzbo' , 'ncenNAOdod'            , 'cenZboz->ncenaSzbo'  , 'cenZboz->ncenaSzbo'  }, ;
                 {            'ncelkSlev'  , 'ncenaSzbo'       , 0                    , 0                       , 0                     , 0                     }, ;
                 {            'ncenaCelk'  , 0                 , 0                    , 0                       , 0                     , 0                     }, ;
                 {            'nmnozPRdod' , ':pvp_mnozPRdod/1', 0                    , 'nmnozOBdod'            , 'nmnozOBodb'          , 'nmnZADva'            }, ;
                 { 'M->cenZboz_czkratJedn' , 'czkratJedn'      , 'cenZboz->czkratJedn', 'czkratJedn'            , 'czkratJedn'          , 'czkratJedn'          }, ;
                 { 'M->cenZboz_czkratMeny' , 'czkratMeny'      , 'cenZboz->czkratMeny', 'czkratMeny'            , 'cenZboz->czkratMeny' , 'cenZboz->czkratMeny' }, ;
                 {            'ncenNAPdod' , 'ncenaSzbo'       , 'cenZboz->ncenaSzbo' , ':pvp_cenNAPdod'        , 'cenZboz->ncenaSzbo'  , 'cenZboz->ncenaSzbo'  }, ;
                 {            'ctext'      , ''                , ''                   , ''                      , ''                    , ''                    }, ;
                 {            'cnazPol1'   , ':pvp_nazPol/1'   , 'cstredisko'         , ''                      , 'cstred'              , 'cstrVyr'             }, ;
                 {            'cnazPol2'   , ':pvp_nazPol/2'   , 'cvyrobek'           , ''                      , ''                    , ''                    }, ;
                 {            'cnazPol3'   , ':pvp_nazPol/3'   , 'czakazka'           , ''                      , ''                    , ''                    }, ;
                 {            'cnazPol4'   , ':pvp_nazPol/4'   , 'cvyrMisto'          , ''                      , ''                    , ''                    }, ;
                 {            'cnazPol5'   , ':pvp_nazPol/5'   , 'cstroj'             , ''                      , ''                    , ''                    }, ;
                 {            'cnazPol6'   , ':pvp_nazPol/6'   , 'coperace'           , ''                      , ''                    , ''                    }, ;
                 {            'nPVPTERM'   , 0                 , 'pvpterm->sID'       , 0                       , 0                     , 0                     }, ;
                 {            'nOBJVYSIT'  , 0                 , 0                    , 'objVysit->sID'         , 0                     , 0                     }, ;
                 {            'nOBJITEM'   , 0                 , 0                    , 0                       , 'objitem->sID'        , 0                     }, ;
                 {            'nVYRPOL'    , 0                 , 0                    , 0                       , 0                     , 'vyrPol->sID'         }, ;
                 {            'ctypSKLcen' , 'ctypSKLcen'      , 'cenZboz->ctypSKLcen', 'cenZboz->ctypSKLcen'   , 'cenZboz->ctypSKLcen' , 'cenZboz->ctypSKLcen' }, ;
                 {            'nucetSkup'  , 'nucetSkup'       , 'cenZboz->nucetSkup' , 'cenZboz->nucetSkup'    , 'cenZboz->nucetSkup'  , 'cenZboz->nucetSkup'  }, ;
                 {            'cucetSkup'  , 'cucetSkup'       , 'cenZboz->cucetSkup' , 'cenZboz->cucetSkup'    , 'cenZboz->cucetSkup'  , 'cenZboz->cucetSkup'  }, ;
                 {            '_nrecOr'    , 0                 , 0                    , 0                       , 0                     , 0                     }  }


*   if( isObject(dm), ::dm := dm, nil )
   default in_spcykl to .f.

   if( isObject(dm), m_dm := dm, nil )

   * musÌme se u vËech z·znam˘ tj. pvpTerm, objVysit, objitem nav·zat na cenZboz
   if iz_pos <> 2
     cky := upper((iz_file)->ccisSklad) +upper((iz_file)->csklPol)
     cenZboz->( dbseek( cky,, 'CENIK12' ))
   endif

//   drgDump(::cenZboz_kDIS)

   for x := 1 to len(pa) step 1
     if IsObject(ovar := m_dm:has(if(at('->',pa[x,1]) = 0,::it_file +'->' +pa[x,1], pa[x,1])))

       do case
       case empty(pa[x,iz_pos])
         value := pa[x,iz_pos]

       case at(':', pa[x,iz_pos]) <> 0
         items := strtran(pa[x,iz_pos],':','')
         if at('/',items) = 0
           value := self:&items()
         else
           mname := substr(items,1,at('/',items) -1)
           par   := val(substr(items,  at('/',items) +1))
           value := self:&mname(par)
         endif

       otherwise
         if at('->',pa[x,iz_pos]) = 0
           value := DBGetVal(iz_file +"->" +pa[x,iz_pos])
         else
           value := DBGetVal(+pa[x,iz_pos])
         endif
       endcase

       if ( ( iz_pos = 2 .or. iz_pos = 4) .and. 'cnazPol' $ pa[x,1] )
         *
         * naöel p¯ednastavenÌ NS ?
         if ::pvp_nazPol(-1)
         else
           value := ovar:get()
         endif
       endif

       ovar:set(value)
       ovar:initValue := ovar:prevValue := value
     endif
   next

   if( IsObject(ovar := m_dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file), nil)
   if( IsObject(ovar := m_dm:has(::it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

   if isObject(dm)
     * nic je to volanÈ z koöÌku
   else
     if .not. in_spcykl
       if( ::o:nkarta = 177 .or. ::o:nkarta = 205 .or. ::o:nkarta = 305, nil, ::df:setNextFocus( ::it_file +'->nmnozDokl1',,.T.) )

       ::show_kDis('M->cenzboz_kDis'  , ::cenzboz_kDis +mnozReODB)
       ::show_kDis('M->objvysit_kDis' , ::objvysit_kDis          )
       ::show_kDis('M->objitem_kDis'  , ::objitem_kDis           )

       if ::o:nkarta = 177
         if( IsObject(ovar := m_dm:has(::it_file +'->nmnozDokl1')), ovar:set(1), nil)
         if( IsObject(ovar := m_dm:has(::it_file +'->nmnozPRdod')), ovar:set(1), nil)
       endif

     endif
   endif

*  ::show_kDis('M->dodlstit_kDis', ::udcp:dodlstit_kDis          )
*  ::show_kDis('M->objitem_kDis' , ::udcp:objitem_kDis           )
*  ::show_kDis('M->vyrzak_kDis'  , ::udcp:vyrzak_kDis            )

**   ::dm := m_dm

   if sID = 0
     for x := 1 to ::dm:vars:size() step 1
       drgVar := ::dm:vars:getNth(x)
         odrg := drgVar:odrg

       if isblock(drgVar:block)
         in_file := lower( left( drgVar:name, at( '-', drgVar:name)  -1))
         *
         ** pvpHeadW
         if ( in_file = ::hd_file .and. isMemberVar(drgVar:odrg, 'isEdit_org'))
           if .not. drgVar:odrg:isEdit_inRev
             ( drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
           endif

           if( ismembervar(odrg,'pushGet') .and. isobject(odrg:pushGet))
             odrg:pushGet:disabled := .not. drgVar:odrg:isEdit
           endif
         endif
       endif
     next
   endif

return .t.

*
**
method skl_pvpHead_main:pvp_katCzbo(par)
  local cky := strZero(pvpHeadW->ncisFirmy,5) +upper(cenZboz->ccisSklad) +upper(cenZboz->csklPol)

  dodZboz->( dbseek( cky,,'DODAV6' ))
return dodZboz->ckatCZbo


/*
method skl_pvpHead_main:pvp_mnokDis(par)
  local mnozDzbo := 0

  do case
  case( par = 1 )  ;  mnozDzbo := ::wsd_dodlstit_kDis()
  case( par = 2 )  ;  mnozDzbo := ::wsd_vyrzakit_kDis()
  case( par = 3 )  ;  mnozDzbo := ::wsd_objitem_kDis()
  endcase
return mnozDzbo
*/



method skl_pvpHead_main:pvp_invCISdim()
  msDim->( ordSetFocus('DIM1'), dbgoBottom())
return msDim->ninvCISdim +1


method skl_pvpHead_main:pvp_mnozZ_objvysit(par)
  local  nOB_PL := objvysit->nmnozOBdod - objvysit->nmnozPLdod
return if( nOB_PL > 0, nOB_PL, 1 )


method skl_pvpHead_main:pvp_mnozZ_vyrPol()
  local  nretVal := 0, ntypPvp := (::hd_file)->ntypPvp

  nretVal := if(ntypPvp = 1, (vyrPol->nmnPROhlvy -vyrPol->nmnSKLpri), ;
                             (vyrPol->nmnVYDzmon -vyrPol->nmnSKLvyd)  )
return nretVal


method skl_pvpHead_main:pvp_mnozPRdod(par)
  local nmnozSzbo := cenZboz->nmnozSzbo

  if( ::o:nkarta = 400, nil, nmnozSzbo := 0 )

  * pro objitem
  if ::o:nkarta = 274  // V˝dej na zak·zku - û·danky mater·l
     lMnNevyd := SysConfig( 'Sklady:lMnNevyd')
     xx       := IF( lMnNevyd, ObjItem->nMnozObOdb - ObjItem->nMnozPlOdb, 0 )
  endif
return nmnozSzbo


method skl_pvphead_main:pvp_cenNAPdod()
  local  cenNAPdod := 0

  do case
  case cenZboz ->ctypSKLcen = 'PEV'
    cenNAPdod := cenZboz->ncenaSzbo
  case objVysit->ncenNAOdod = 0
    cenNAPdod := cenZboz->ncenaSzbo
  otherwise
    cenNAPdod := objVysit->ncenNAOdod
  endcase
return cenNAPdod


method skl_pvphead_main:pvp_nazPol(par)
  local  retVal, cin_File, lin_File := .f.
  *
  local hd_file := ::dm:drgDialog:udcp:hd_file
  local cky     := upper((hd_file)->culoha    ) + ;
                   upper((hd_file)->ctypdoklad) + ;
                   upper((hd_file)->ctyppohybu) + upper(cenzboz->cucetskup)

  if(select('cenZb_ns') = 0, drgDBms:open('cenZb_ns'), nil)
  if(select('ucetprit') = 0, drgDBms:open('ucetprit'), nil)

  do case
  case cenZb_ns->( dbseek( upper((hd_file)->ctyppohybu) +upper(cenzboz->ccisSklad) +upper(cenZboz->csklPol),,'CENZBNS3') )
    cin_File := 'cenZb_ns'
    lin_File := .t.
  case cenZb_ns->( dbseek( upper((hd_file)->ctyppohybu),,'CENZBNS3') )
    cin_File := 'cenZb_ns'
    lin_File := .t.
  otherwise
    lin_File := ucetprit->(dbseek(cky,,'UCETPRIT01'))
    cin_File := 'ucetPrit'

    if par = -1
      lin_File := .not. empty( (cin_File)->cnazpol1 +(cin_File)->cnazpol2 +(cin_File)->cnazpol3 + ;
                               (cin_File)->cnazpol4 +(cin_File)->cnazpol5 +(cin_File)->cnazpol6   )
    endif
  endcase


  if par = -1
    return lin_File
  else
    do case
    case(par = 1)  ;  retVal := (cin_File)->cnazpol1
    case(par = 2)  ;  retVal := (cin_File)->cnazpol2
    case(par = 3)  ;  retVal := (cin_File)->cnazpol3
    case(par = 4)  ;  retVal := (cin_File)->cnazpol4
    case(par = 5)  ;  retVal := (cin_File)->cnazpol5
    case(par = 6)  ;  retVal := (cin_File)->cnazpol6
    endcase
  endif
return retVal


* ZjistÌ novÈ ËÌslo dokladu pro dan˝ typ pohybu( PVP) a sklad
*
* SKL_pvphead_main
* HIM_maj_scr
********************************************************************************
FUNCTION NewDoklad_skl( nKARTA, cSklad)
  Local nNewDokl := 0, lStart
  Local nRange, nStart, nKonec, cTop, cBot
  Local cTypPohyb  := LEFT( ALLTRIM( STR( nKarta)), 1 )
  Local nTypCisRad := SysConfig( 'Sklady:nTypCisRad')
  Local lRangePVP  := SysConfig( 'Sklady:lRangePVP' )
  *
  local ndoklad    := pvpHeadW->ndoklad, key

  drgDBMS:open('PVPHEAD',,,,, 'PVPHEADa')

  DO CASE
  CASE nTypCisRad = 1 .or. nTypCisRad = 3     // ËÌs.¯ady doklad˘ v r·mci celÈ firmy
    IF lRangePVP
      nRange  := IIf( cTypPohyb == PRIJEM, SysConfig( 'Sklady:nRangePrij'),;
                 IIF( cTypPohyb == VYDEJ , SysConfig( 'Sklady:nRangeVyde'),;
                 IIf( cTypPohyb == PREVOD, SysConfig( 'Sklady:nRangePrev'),;
                 IIf( cTypPohyb == PRECEN, SysConfig( 'Sklady:nRangePrij'), Nil ))))

      PVPHEADa->( AdsSetOrder( 7))
      cTop := cTypPohyb +StrZero( nRange[ 1], 10 )
      cBot := cTypPohyb +StrZero( nRange[ 2], 10 )
      key  := cTypPohyb +strZero(ndoklad,10)

      PVPHEADa->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                  Ads_SetScope( SCOPE_BOTTOM, cBot ))

    ELSE
      nRange  := SysConfig( 'Sklady:nRangePrij')
      PVPHEADa->( AdsSetOrder( 1))
      cTop := StrZero( nRange[ 1], 10 )
      cBot := StrZero( nRange[ 2], 10 )
      key  := ndoklad

      PVPHEADa->( Ads_SetScope( SCOPE_TOP   , nRange[ 1]),;
                  Ads_SetScope( SCOPE_BOTTOM, nRange[ 2]) )
    ENDIF
    nStart  := Val( Str( nRange[ 1], 10 ))
    nKonec  := Val( Str( nRange[ 2], 10 ))
  //
  CASE nTypCisRad = 2      // ËÌs.¯ady doklad˘ v r·mci sklad˘
    IF C_Sklady->( dbSEEK( Upper( cSklad),, 'C_SKLAD1'))
      IF C_Sklady->lRangePVP
        nStart := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemOd ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejOd  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodOd ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemOd , Nil ))))

        nKonec := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemDo ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejDo  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodDo ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemDo , Nil ))))

        PVPHEADa->( AdsSetOrder( 17))
        cTop := Upper(cSklad) +cTypPohyb +StrZero( nStart, 10 )
        cBot := Upper(cSklad) +cTypPohyb +StrZero( nKonec, 10 )
        key  := upper(csklad) +ctypPohyb +strZero(ndoklad, 10)

        PVPHEADa->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                    Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ELSE
        nStart := C_Sklady->nPrijemOd
        nKonec := C_Sklady->nPrijemDo
        PVPHEADa->( AdsSetOrder( 16))
        cTop := Upper(cSklad) + StrZero( nStart, 10 )
        cBot := Upper(cSklad) + StrZero( nKonec, 10 )
        key  := upper(csklad) +strZero(ndoklad,10)

        PVPHEADa->( Ads_SetScope( SCOPE_TOP   , cTop ),;
                    Ads_SetScope( SCOPE_BOTTOM, cBot ))
      ENDIF

    ENDIF
  ENDCASE

  PVPHEADa->( dbGoTop())
  lStart := ( PVPHEADa->nDoklad == 0 )
  PVPHEADa->( dbGoBottom())    // !!!!
  nNewDokl := If( lStart, nStart, PVPHEADa->nDoklad + 1 )
  *
  pvpheadW->nrange_beg := nStart
  pvpheadW->nrange_end := nKonec
  *
  if( ndoklad <> 0 .and. (ndoklad >= nstart .and. ndoklad <= nkonec ))
    if .not. pvpHeadA->( dbseek( key ))
      nNewDokl := ndoklad
    endif
  endif
  *
  PVPHEADa->( dbCloseArea())
Return( Val( Str( nNewDokl, 10)) )


*  V˝dejka/P¯Ìjemka z CenZboz nebo ObjItem/ObjVystIT
*
*  vyr_kalkToCen.prg
********************************************************************************
FUNCTION AddToPVPItem( cAlias )

  PVPItem->cSklPol    := ( cAlias)->cSklPol
  PVPItem->cNazZBO    := ( cAlias)->cNazZBO
  PVPItem->nKlicDPH   := ( cAlias)->nKlicDPH

  PVPItem->nUcetSkup  := CenZboz->nUcetSkup
  PVPItem->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
  PVPItem->cZkratMENY := CenZboz->cZkratMENY
  PVPItem->cZkratJedn := CenZboz->cZkratJedn
  PVPItem->nKlicNAZ   := CenZboz ->nKlicNaz
  PVPItem->nZboziKAT  := CenZboz ->nZboziKAT
  PVPItem->cPolCen    := CenZboz->cPolCen
  PVPItem->cTypSKP    := CenZboz->cTypSKP
  PVPItem->cUctovano  := ' '
  PVPItem->nTypPOH    := IIF( PVPHEAD->nKARTA < 200,  1,;
                         IIF( PVPHEAD->nKARTA < 300, -1,;
                         IIF( PVPHEAD->nKARTA = 400,  1, 0 )))
  PVPItem->cCisZakaz  := IF( PVPItem->nTypPoh = -1, PVPItem->cNazPol3, PVPItem->cCisZakaz )
  PVPItem->cCisZakazI := PVPItem->cCisZakaz
  PVPItem->cCasPVP    := time()
  mh_WRTzmena( 'PVPITEM', .T.,)

RETURN Nil


* kontrola na uzav¯enÈ obdobi
*
* SKL_pvphead_main
* HIM_maj_scr
* HIM_pohyby_crd
********************************************************************************
FUNCTION ObdobiUZV( cObd, cTask, lMessage )
  Local lOK := .F., cKey := cTask + cObd
  Local cNazevTask := IF( cTask = 'U', '⁄»TO'    ,;
                      IF( cTask = 'S', 'SKLADY'  ,;
                      IF( cTask = 'I', 'MAJETEK' ,;
                      IF( cTask = 'Z', 'ZVÕÿATA' , ''))))

  DEFAULT lMessage TO .T.
  drgDBMS:open('UCETSYS',,,,, 'UCETSYSw' )
  IF UCETSYSw->( dbSeek( Upper( cKey),,'UCETSYS2'))
    IF lOK := UCETSYSw->lZavren
      IF lMessage
        drgMsgBOX( drgNLS:msg( '⁄ËetnÌ obdobÌ  [ & ] jiû bylo v ˙loze ' + cNazevTask + ' uzav¯eno ...', cObd ))
      ENDIF
    ENDIF
  ENDIF
  UCETSYSw->( dbCloseArea())
RETURN( lOK)


* PodmÌnky pro pr·ci s dokladem
* SKL_pvphead_scr
********************************************************************************
FUNCTION SKL_AllOK( lNewDokl, lMessage, cHD, cIT)
*SKL_AllOK( lNewDokl, lMessage, o, cAlias)
*METHOD SKL_Pohyby_Main:SKL_AllOK( lNewDokl, lMessage, o, cAlias)
  Local cObd,  lOk := .F.

  DEFAULT lNewDokl TO .F., lMessage TO .T., cHD TO 'PVPHEAD', cIT TO 'PVPITEM'
*  If o = nil
*    o := ::drgDialog:odBrowse[2]:oXbp
*  EndIf

  IF lNewDokl
    *  Nov˝ doklad
    cObd := uctObdobi:SKL:cOBDOBI  // IF( cHD = 'PVPHEAD', uctObdobi:SKL:cOBDOBI, PVPHead->cObdPoh )
    IF !ObdobiUZV( cObd, 'U', lMessage)        // obdobÌ nenÌ ˙ËetnÏ uzav¯eno v ⁄»ETNICTVÕ
      IF !ObdobiUZV( cObd, 'S', lMessage)      // obdobÌ nenÌ ˙ËetnÏ uzav¯eno v ˙loze SKLADY
        lOK := .T.
      ENDIF
    ENDIF

  ELSE
    * Oprava a ruöenÌ dokladu
    IF !ObdobiUZV( (cHD)->cObdPoh, 'U', lMessage)        // obdobÌ nenÌ ˙ËetnÏ uzav¯eno v ⁄»ETNICTVÕ
      IF !ObdobiUZV( (cHD)->cObdPoh, 'S', lMessage)      // obdobÌ nenÌ ˙ËetnÏ uzav¯eno v ˙loze SKLADY
*        IF PrijemOK( o, lMessage)
        IF Prijem_isOK( cHD, cIT, .t., .f.)
          lOk := .T.
        ENDIF
      ENDIF
    ENDIF
  ENDIF

  IF !lOK .and. lMessage
    drgMsgBox(drgNLS:msg('Nejsou splnÏny podmÌnky pro pr·ci s dokladem !'),XBPMB_CRITICAL  )
  ENDIF
RETURN lOK

FUNCTION Prijem_isOK( cHD, cIT, lMessage, lVN)
  Local lOK := .T., nRec

  DEFAULT lMessage TO .T., lVN TO .F. //, cFile TO 'PVPITEMww'

  IF (cHD)->nTypPoh = 1
    drgDBMS:open('CENZBOZ',,,,,'CENZBOZa' )
    drgDBMS:open('PVPITEM',,,,,'PVPITEMa' )
    PVPITEMa->( AdsSetOrder( 'PVPITEM30'))  //21

    IF !lVN        //'PVPHEAD' $ cHD            //'PVPITEMww'
      IF( cIT = 'PVPITEMww', PVPITEM->( dbGoTO( PVPITEMww->_nRecOr)), nil )
      IF PVPITEM->( RecNo()) <> 0
        lOK := PrijemIT_isOK( cIT)
      endif
    ELSE    //IF cFile = 'PVPHEADw' .and. lVN
      nRec := (cIT)->( RecNO())
      (cIT)->( dbGoTOP())
      DO WHILE !(cIT)->( EOF())
        IF( cIT = 'PVPITEMww', PVPITEM->( dbGoTO( PVPITEMww->_nRecOr)), nil )
        IF PVPITEM->( RecNo()) <> 0
          lOK := IF( PrijemIT_isOK( cIT), lOK, .F. )
        ENDIF
        (cIT)->( dbSkip())
      ENDDO
      (cIT)->( dbGoTO( nRec))
    ENDIF
    PVPITEMa->( dbCloseArea())
    CENZBOZa->( dbCloseArea())
    *
    IF !lOK .and. lMessage
      drgMsgBOX( drgNLS:msg( IF( lVN, 'VedlejöÌ n·klady ','P¯Ìjemku ') + ;
                            'nelze opravit neboù jiû existujÌ pozdÏjöÌ v˝dejky na poloûku  ...' ))
    ENDIF
  ENDIF
RETURN lOK


* Kontrola, zda p¯Ìjemku jiû nen·sledovala v˝dejka
*-------------------------------------------------------------------------------
STATIC FUNCT PrijemIT_isOK( cIT)
  Local lOK := .T., lOpravaPri := SysConfig( 'Sklady:lOpravaPri')
  Local cKey := Upper( PVPITEM->cCisSklad) + Upper( PVPITEM->cSklPol)

  IF CENZBOZa->( dbSEEK( cKey,, 'CENIK03'))
    IF CenZBOZa->cTypSklCen = 'PRU'
      IF lOpravaPri
        PVPITEMa->( mh_SetScope( cKey + '-1'),;
                    dbGoBottom())
        lOK := IF( PVPITEMa->( Eof()), .T.,;
                   ( PVPITEM->( dDatPVP) > PVPITEMa->( dDatPVP)) .OR. ;
                    ( ( PVPITEM->( dDatPVP) = PVPITEMa->( dDatPVP)) .AND. ( VAL( StrTran( PVPITEM->( cCasPVP),':')) > VAL( StrTran(PVPITEMa->( cCasPVP), ':')) ))  )

      ENDIF
    ENDIF
  ENDIF
RETURN lOK