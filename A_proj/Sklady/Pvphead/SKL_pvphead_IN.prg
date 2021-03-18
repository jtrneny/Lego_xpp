#include "adsdbe.ch"
#include "common.ch"
#include "dmlb.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
#include "..\Asystem++\Asystem++.ch"

* Typy pohybù
# Define  PRIJEM     '1'
# Define  VYDEJ      '2'
# Define  PREVOD     '3'
# Define  PRECEN     '4'

# xTRANSLATE .chead  => \[ 1\]
# xTRANSLATE .citem  => \[ 2\]


*
** CLASS for SKL_pvphead_IN ***************************************************
CLASS SKL_pvphead_IN FROM drgUsrClass, SKL_pvphead_MAIN
exported:
  var     mainSklad, mainPohyb, nkarta
*  var     HD, IT, hd_udcp

  method  init, drgDialogStart
  method  comboItemSelected
  method  skl_typPoh_sel, sklad_sel, doklad_vld, skl_firmy_sel, skl_objVyshd_sel, skl_objhead_sel, skl_vyrZak_sel


  inline method tabSelect( o_tabPage )
    xx := o_tabPage:tabNumber
  return .t.


  inline access assign method nazTYPpoh() var nazTYPpoh
    local cky := upper(pvpHeadW->culoha) +upper(pvpHeadW->ctypPohybu)
    local ckarta
    local cc  := if( pvpHeadW->nstornoDok = 1, 'storno', '' )

    c_typPoh ->( dbseek( cky,,'C_TYPPOH06'))
    ckarta  := right( allTrim(c_typPoh->ctypDoklad), 3) +' ' +cc
  return allTrim(c_typPoh->cnazTYPpoh) +' [ ' +ckarta +' ]'


  inline access assign method rozdilPOHzm() var rozdilPOHzm
     return round( pvpitemWW->ncenCELKzm -(pvpitemWW->nMnozDokl1 * pvpitemWW->ncenNADOzm), 2 )


  inline method ev_stornoDok()
    local  nstornoDok := pvpHeadW->nstornoDok
    local  o_ndoklad  := ::dm:has( ::hd_file +'->ndoklad' ):odrg

    pvpHeadW->nstornoDok := if( nstornoDok = 0, 1, 0 )
    o_ndoklad:oxbp:setColorFG(if( pvpHeadW->nstornoDok = 1, GRA_CLR_RED, GRA_CLR_BLACK) )
    ::dm:refresh(.f.)
  return self

  *
  ** na pvpheadW
  inline access assign method pvpheadW_zahrMena() var pvpheadW_zahrMena
    return pvpheadW->czahrMena

  *
  ** na pvpitemWW
  inline access assign method pvpitemWW_zahrMena() var pvpitemWW_zahrMena
    return pvpheadW->czahrMena

  inline access assign method cenZboz_czkratJedn() var cenZboz_czkratJedn
    local  cky := upper( pvpItemWW->ccisSklad) +upper( pvpItemWW->csklPol)
**    cenZboz->( dbseek( cky,,'CENIK03' ))
    return cenZboz->czkratJedn

  inline access assign method cenZboz_czkratMeny() var cenZboz_czkratMeny
    local  cky := upper( pvpItemWW->ccisSklad) +upper( pvpItemWW->csklPol)
**    cenZboz->( dbseek( cky,,'CENIK03' ))
    return cenZboz->czkratMeny

  inline access assign method cenZboz_nucetSkup() var cenZboz_nucetSkup
    local  cky := upper( pvpItemWW->ccisSklad) +upper( pvpItemWW->csklPol)
**    cenZboz->( dbseek( cky,,'CENIK03' ))
    return cenZboz->nucetSkup


  inline method sel_typPohybu()
    local typDoklad := allTrim(c_typPoh->ctypDoklad)
    local typPohybu := left(typDoklad,7)
    *
    local chead, citem, x, odrg
    local filter
    local cf := "ctypPohybu = '%%' and ccisSklad = '%%' and nrok >= %% and empty(nstornoDok)"
    *
    local pa_emptyHd := { { 'pvpHeadW->ncisFirmy' , 0  }, { 'pvpHeadW->cnazFirmy' , '' }, ;
                          { 'pvpheadW->ccislOBint', '' }, { 'pvpheadW->cVarSym'   , '' }, ;
                          { 'pvpheadW->nCisFak'   , 0  }, { 'pvpheadW->nCisloDL'  , 0  }  }

*                          { 'pvpheadW->nCenDokZM' , 0  }, { 'pvpheadW->nNutneVNZM', 0  }, ;
*                          { 'pvpheadW->nCenaDokl' , 0  }, { 'pvpheadW->nNutneVN'  , 0  }, { 'pvpheadW->nRozPrij'  , 0 }  }

    ::nkarta      := val ( right( allTrim(c_typPoh->ctypDoklad), 3))

    do case
    case (typPohybu = 'SKL_PRI')
      // hd SKL_PRI it SKL_PRI
      do case
      case (typDoklad = 'SKL_PRI115')
       // hd SKL_PRI it SKL_PRI_115
        ( chead := 'SKL_PRIHD', citem := 'SKL_PRI115' )
        ::one_edt := 'pvpitemWW->ccisZakaz'

      case (typDoklad = 'SKL_PRI177')
       // hd SKL_PRI it SKL_PRI_177
        ( chead := 'SKL_PRIHD', citem := 'SKL_PRI177' )
        ::one_edt := 'pvpitemWW->csklPol'

      otherWise
        (chead := 'SKL_PRIHD', citem := 'SKL_PRI' )  //  +if( typDoklad = 'SKL_PRI117', '117', ''))
        ::one_edt := 'pvpitemWW->ccisObj'
      endcase

    case (typPohybu = 'SKL_VYD')
      do case
      case (typDoklad = 'SKL_VYD205')
       // hd SKL_VYD it SKL_VYD_205
        ( chead := 'SKL_VYDHD', citem := 'SKL_VYD205' )
        ::one_edt := 'pvpitemWW->ccislOBint'

      case (typDoklad = 'SKL_VYD215')
       // hd SKL_VYD it SKL_VYD_215
        ( chead := 'SKL_VYDHD', citem := 'SKL_VYD215' )
        ::one_edt := 'pvpitemWW->ccisZakaz'

      otherwise
        // hd SKL_VYD it SKL_VYD
        ( chead := 'SKL_VYDHD', citem := 'SKL_VYD' )
        ::one_edt := 'pvpitemWW->csklPol'
      endcase

    case (typDoklad = 'SKL_PRE305')
      // hd SKL_VYD it SKL_PRE
      ( chead := 'SKL_VYDHD', citem := 'SKL_PRE305' )
      ::one_edt := 'pvpitemWW->csklPol'

    case (typDoklad = 'SKL_CEN400')
      // hd SKL_PRI it SKL_CEN
      ( chead := 'SKL_PRIHD', citem := 'SKL_CEN400' )
       ::one_edt := 'pvpitemWW->csklPol'

    endCase

    if ::paCards.chead <> chead .or. ::paCards.citem <> citem
      ::showGroup( chead, citem )
      ( ::paCards.chead := chead, ::paCards.citem := citem )
    endif

    if ::NEWhd
      if ::nkarta = 274 .or. ::nkarta = 293
        pa_emptyHd[1,2] := pvpHeadW->ncisFirmy
        pa_emptyHd[2,2] := pvpHeadW->cnazFirmy
      endif

      for x := 1 to len(pa_emptyHd) step 1

        if isObject( odrg := ::dm:has(pa_emptyHd[x,1]) )

          if .not. odrg:odrg:isEdit
            &(pa_emptyHd[x,1]) := pa_emptyHd[x,2]
          endif
          odrg:refresh()
        else
          &(pa_emptyHd[x,1]) := pa_emptyHd[x,2]
        endif
      next
    endif

    if( ::newHD, ::refreshAndSetEmpty(), nil )
    ::panGroup := citem
    ::disable_items_onKards()

    if c_typPoh->nstornoDok = 1
      filter := format( cf, { allTrim(c_typPoh->ctypPohybu), allTrim(pvpHeadW->ccisSklad), year( date()) -1 } )
      pvpitem_ss->( ads_setAof(filter), dbgoTop())

      if( .not. pvpItem_ss->(eof()), ::opb_stornoDok:oxbp:show(), ::opb_stornoDok:oxbp:hide() )
    else
      ::opb_stornoDok:oxbp:hide()

      if isObject(::doklad_o)
        ( ::doklad_o:odrg:isEdit := ::doklad_o:odrg:isEdit_org := .f., ::doklad_o:odrg:oxbp:disable() )
      endif
    endif
  return self


  inline method refreshAndSetEmpty()
    local x
    local pa_emptyHd := { { 'pvpheadW->nCenDokZM' }, { 'pvpheadW->nNutneVNZM' }, { 'M->ncelkDoklZM' }, { 'M->mrozPrijZM'     }, ;
                          { 'pvpheadW->nCenaDokl' }, { 'pvpheadW->nNutneVN'   }, { 'M->ncelkDokl'   }, { 'pvpheadW->nRozPrij'}  }

    for x := 1 to len(pa_emptyHd) step 1
      if isObject( odrg := ::dm:has(pa_emptyHd[x,1]) )
        &(pa_emptyHd[x,1]) := 0
        odrg:prevValue := odrg:initValue := odrg:value := 0
        odrg:odrg:refresh(0)
      else
        &(pa_emptyHd[x,1]) := 0
      endif
    next
  return self


  inline method modi_memvar(o,on_off)
    local picture, new_Val

    if ismembervar(o,'groups') .and. .not. empty(o:groups)
      if(on_off, o:oxbp:show(), o:oxbp:hide())
      if( ismembervar(o,'obord') .and. isobject(o:obord))
        if(on_off, o:obord:show(), o:obord:hide())
      endif

      if( ismembervar(o,'pushGet') .and. isobject(o:pushGet))
         if(on_off, o:pushGet:oxbp:show(), o:pushGet:oxbp:hide())
      endif

      if( on_off .and. o:className() = 'drgGet' )
        if .not. empty( picture := o:oxbp:picture )
          o:oxbp:picture := strTran( picture, ',', '' )
        endif
      endif
    endif
  return nil

  *
  **
  inline method overPostAppend()
    ::enable_or_disable_items( 0, 2 )
  return .t.

  inline method postAppend()
    local  cky, ccisSklad, ncisFirmy
    local  pvpitemWW_zahrMena, cenZboz_czkratMeny
    *
    local  x, cc, pa_vyrZak := {}
    local  ntypPvp     := (::hd_file)->ntypPvp
    local  o_nazPol1   := ::dm:has( ::it_file +'->cnazPol1' )
    local  sID         := isNull(pvpitemWW->sID, 0)
    local  cf, filtr

    pvpitemWW_zahrMena := ::dm:has('M->pvpitemWW_zahrMena' )
    cenZboz_czkratMeny := ::dm:has('M->cenZboz_czkratMeny' )

    ::one_edt := 'pvpitemWW->csklPol'

    ::dm:set('M->nazTYPpoh', ::nazTYPpoh )
    if( isObject(::dm:has('M->nCelkDOKL')), ::dm:set('M->nCelkDOKL', ::nCelkDOKL), nil ) //  ncenaDokl +VN, ncenaPol bez VN

    if( isObject(pvpitemWW_zahrMena), pvpitemWW_zahrMena:set(pvpheadW->czahrMena), nil )
    if( isObject(cenZboz_czkratMeny), cenZboz_czkratMeny:set( sysConfig( 'FINANCE:cZAKLMENA' )), nil )

* SKL_PRI
*    M->nCelkDoklZM  no in DBD
**    M->nCelkDokl
*    M->nRozPrijZM   nrozPrij v ZM není

* SKL_VYD
*    M->nCelkPCB    no in DBD
*    M->nCelkPCS    no in DBD
* 400
*    M->nCenaSROZ   no in DBD


    ( ::sklPol:odrg:isEdit := .t., ::sklPol:odrg:oxbp:enable() )
      ::sklPol:odrg:pushGet:disabled := .not. ::sklPol:odrg:isEdit

    * SKL_PRI, SKL_PRI117, SKL_CEN400
    * máme k dispozici položky objednávek vystavených OBJVYSIT.ccisObj pro ncisfirmy ?
    if isObject(::cisObj)
      ::one_edt := 'pvpitemWW->ccisObj'

      cky := strZero(pvpHeadW->ncisFirmy,5) +upper(pvpHeadW->ccisSklad)

      if .not. objVysit->( dbseek( cky,,'OBJVYSI3'))
        (::cisObj:odrg:isEdit := .f., ::cisObj:odrg:oxbp:disable())
      else
        (::cisObj:odrg:isEdit := .t., ::cisObj:odrg:oxbp:enable())
      endif

      * My
      ::cisObj:odrg:isEdit_Org       := ::cisObj:odrg:isEdit
      ::cisObj:odrg:pushGet:disabled := .not. ::cisObj:drgVar:odrg:isEdit
    endif

    * SKL_VYD, SKL_VYD205, SKL_VYD299, SKL_PRE305
    * máme k dispozici položky objednávek pøijatých OBJITEM.ccislOBint pro ncisfirmy ?
    * pro 274 - výdej na zakázku-žádanky materíál
    *     293 - výdej - prodej na zakázku
    if isObject( ::cislOBint)
      ::one_edt := 'pvpitemWW->ccislOBint'

      ncisFirmy := pvpHeadW->nCisFirmy
      cky       := strZero(ncisFirmy,5) +upper(pvpHeadW->ccisSklad)

      if .not. objitem ->( dbseek( cky,,'OBJITE26'))
        (::cislOBint:odrg:isEdit := .f., ::cislOBint:odrg:oxbp:disable())
      else
        (::cislOBint:odrg:isEdit := .t., ::cislOBInt:odrg:oxbp:enable())
      endif

      * My
      ::cislOBint:odrg:isEdit_Org       := ::cislOBint:odrg:isEdit
      ::cislOBint:odrg:pushGet:disabled := .not. ::cislOBint:drgVar:odrg:isEdit
    endif

    if isObject(::ucetSKKam) .and. .not. ::cfg_luctSKprev
      (::ucetSKKam:odrg:isEdit := .f., ::ucetSKKam:odrg:oxbp:disable())
      ::ucetSKKam:odrg:pushGet:disabled := .not. ::ucetSKKam:drgVar:odrg:isEdit
    endif

    *
    * SKL_PRO115 SKL_VYD215 skl_vyrZak_sel - skl_vyrPol_sel
    * ::cisZakaz_hd, ::cisZakaz, ::vyrPol
    if isObject( ::cisZakaz_hd)
      ::one_edt := 'pvpitemWW->ccisZakaz'
      ccisSklad := pvpheadW->ccisSklad        // and "ccisSklad = '%%'"

//    if empty(vyrPol->( ads_getAof()) )
      cf := if( ntypPvp = 1, "nvyrSt <> 1 and ccisSklad = '%%' and (nmnPROhlvy -nmnSKLpri) <> 0" , ;
                             "nvyrSt <> 1 and ccisSklad = '%%' and (nmnVYDzmon -nmnSKLvyd) <> 0"   )
      filtr := format( cf, { ccisSklad } )
      vyrPol->( ads_setAof(filtr))
//    endif

      if( len(::pa_vyrPol_ex) <> 0, vyrPol->( Ads_CustomizeAOF( ::pa_vyrPol_ex, 2 )), nil )
      vyrPol->(dbgoTop())

      if vyrPol->(eof())
        ( ::cisZakaz_hd:odrg:isEdit := .f., ::cisZakaz_hd:odrg:oxbp:disable() )
        ( ::cisZakaz:odrg:isEdit    := .f., ::cisZakaz:odrg:oxbp:disable()    )
        ( ::vyrPol:odrg:isEdit      := .f., ::vyrPol:odrg:oxbp:disable()      )

      else                             // AOF nad vyrZak
        if( sid = 0 )
          ( ::cisZakaz_hd:odrg:isEdit := .t., ::cisZakaz_hd:odrg:oxbp:enable()  )
        else
          ( ::cisZakaz_hd:odrg:isEdit := .f., ::cisZakaz_hd:odrg:oxbp:disable() )
        endif
        ( ::cisZakaz:odrg:isEdit    := .t., ::cisZakaz:odrg:oxbp:enable()    )
        ( ::vyrPol:odrg:isEdit      := .t., ::vyrPol:odrg:oxbp:enable()      )

        vyrPol->( dbEval( { || ( vyrZak->( dbseek( upper(vyrPol->ccisZakaz),,'VYRZAK1' )), ;
                                 if( ascan( pa_vyrZak, vyrZak->( recNo())) = 0, aadd( pa_vyrzak, vyrzak->(recNo())), nil ) ) }), ;
                  dbgoTop()  )

        vyrZak->( ads_setAof('.F.'), ads_CustomizeAOF( pa_vyrZak), dbgoTop() )
      endif
    endif

    *
    * storno položek dokladu, c_typPoh.nstornoDok  = 1, povoluje storno
    *                         pvpHeadW=:nstornoDok = 1, je nastaveno na dokladu
    if pvpHeadW->nstornoDok = 1
      if isObject(::doklad_o)
**      ncislPoh = 62 and ccisSklad = '102' and nrok >= 2014 and nstornoDok = 0
*        ccisSklad, nrok, ctypPohybu, nstornoDok = 0
      endif
    endif

    * chtìjí NS z pøedchozí položky
    if isObject(o_nazPol1) .and. o_nazPol1:odrg:isEdit
      for x := 1 to 6 step 1
        cc := ::it_file +'->' +'cnazPol' +str(x,1)
        ::dm:set( cc, DBGetVal( cc ) )
      next
    endif

  return .t.


  inline method postEscape()
    ::enable_or_disable_items()
    *
    ** reakce na ESC v BROw
    if (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse')
      ::is_questionOk := .t.
    endif
  return self


  inline method enable_or_disable_items(subCount,state)
    local  x, ok := .t., vars := ::dm:vars, drgVar, odrg
    local  sID   := isNull(pvpitemWW->sID, 0)
    local  cclr  := GraMakeRGBColor( { 234,234,234 } ), n_clr

    default subCount to isNull(pvpitemWW->sID, 0), ;
            state    to 0


    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
        odrg := drgVar:odrg

      if isblock(drgVar:block)
        in_file := lower( left( drgVar:name, at( '-', drgVar:name)  -1))
        *
        ** pvpHeadW
        if ( in_file = ::hd_file .and. isMemberVar(drgVar:odrg, 'isEdit_org'))
          if .not. drgVar:odrg:isEdit_inRev
            if sID = 0
              ( drgVar:odrg:isEdit := .t., drgVar:odrg:oxbp:enable() )
            else
              ( drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
            endif

            if( ismembervar(odrg,'pushGet') .and. isobject(odrg:pushGet))
              odrg:pushGet:disabled := .not. drgVar:odrg:isEdit
            endif
          endif
        endif
        *
        ** pvpItemWW
        if ( in_file = ::it_file .and. isMemberVar(drgVar:odrg, 'isEdit_org'))
          if( isNull(drgVar:odrg:isEdit_org), drgVar:odrg:isEdit_org := drgVar:odrg:isEdit, NIL )

          n_clr := drgVar:odrg:oxbp:setColorBG()

          if subCount <> 0
            if drgVar:odrg:isEdit_org .and. drgVar:odrg:isEdit_inRev
              ( drgVar:odrg:isEdit := .t., drgVar:odrg:oxbp:enable() )
            else
              ( drgVar:odrg:isEdit := .f., if( n_clr = cclr, nil, drgVar:odrg:oxbp:disable() ) )
            endif
          else
            drgVar:odrg:isEdit := drgVar:odrg:isEdit_org
            if( drgVar:odrg:isEdit, drgVar:odrg:oxbp:enable(), if( n_clr = cclr, nil, drgVar:odrg:oxbp:disable() ) )
          endif

          if( ismembervar(odrg,'pushGet') .and. isobject(odrg:pushGet))
            odrg:pushGet:disabled := .not. drgVar:odrg:isEdit
          endif

        endif
      endif
    next
  return self

  *
  ** pokud je cenZboz->cvyrCis A,B,C - je zobrazen typ
  ** pokud ne, mnozPRdod je needitovatelné a BUTT zmizí
  *
  inline method enable_btn_vyrCis()
    local  pa_vyrCis := { 'A', 'B', 'C' }
    local  cky, vyrCis, opushGet, npos

    if isObject(::cisSklad) .and. isObject(::sklPol) .and. isObject( ::mnozPRdod )
      cky      := ::cisSklad:get() + ::sklPol:get()
      opushGet := ::mnozPRdod:odrg:pushGet

      cenZboz_vc->( dbseek( upper(cky),,'CENIK03' ))
      vyrCis := cenZboz_vc->cvyrCis

      if( opushGet:oxbp:caption = vyrCis )
        if( opushGet:oxbp:visible, nil, ( opushGet:disabled := .f., opushGet:oxbp:show() ))
        return self
      endif

      if ( npos := ascan( pa_vyrCis, vyrCis )) <> 0
        opushGet:disabled := .f.
        opushGet:oXbp:setCaption( upper( cenZboz_vc->cvyrCis ))
        opushGet:oXbp:show()
      else
        opushGet:oXbp:hide()
        opushGet:disabled := .t.
      endif
    endif
  return self

  *
  ** zrušíme založená a nepoužitá inventární èísla DIMu
  inline method del_panew_invCISdim()
    local  cStatement, oStatement
    local  stmt    := "delete from %file where"
    *
    local  pa_files := { 'msDim', 'zmenyDim' }
    local  c_in     := ''
    *
    aeval( ::panew_invCISdim, { |x| c_in += str(x) +',' } )

    if len(c_in) <> 0
      c_in := subStr ( c_in, 1, len(c_in)-1 )
      c_in := strTran( c_in, ' ', '' )

      stmt += " ninvCISdim IN (" +c_in +")"

      for x := 1 to len(pa_files) step 1
        cStatement := strTran( stmt, '%file', pa_files[x] )
        oStatement := AdsStatement():New(cStatement, oSession_data)

        if oStatement:LastError > 0
        *  return .f.
        else
          oStatement:Execute( 'test', .f. )
          oStatement:Close()
        endif

        (pa_files[x])->(dbUnlock(), dbCommit(), dbgoTop())
      next
    endif
  return self

  * My
  * postValitateItems
  * u nìkterých pohybù jsou na 1. a 2. EDT místì nepoviné položky,
  * pokud na tìcho položkách dá SAVE padlo to na snahu uložit položku
  inline method postValidateItems(m_file)
  local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
  local  drgVar
  *
  begin sequence
    for x := 1 to size step 1
      file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

      if file = m_file .and. values[x,2]:odrg:isEdit

        drgVar := values[x,2]

        if .not. ::postValidate(drgVar, .f. )
          ::df:olastdrg   := values[x,2]:odrg
          ::df:nlastdrgix := x
          ::df:olastdrg:setFocus()
          return .f.
  break
        endif
      endif
    next
  end sequence
  return .t.
  *
  * postValidateForm
  inline method postValidateForm(m_file)
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar
    *
    ::in_postValidateForm := .t.

    begin sequence
      for x := 1 to size step 1
        file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

        if file = m_file .and. values[x,2]:odrg:isEdit
          drgVar := values[x,2]
          isOk    := isNull(drgVar:odrg:postValidOk, .f. )

          if isOk
          else
            if .not. ::postValidate(drgVar)

              ::df:olastdrg   := values[x,2]:odrg
              ::df:nlastdrgix := x
              ::df:olastdrg:setFocus()
              ::in_postValidateForm := .f.
              return .f.
    break
            else
              drgVar:odrg:postValidOk := .t.
            endif
          endif
        endif
      next
    end sequence

    ::in_postValidateForm := .f.
  return .t.

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  olastDrg := ::df:olastDrg
    local  rowPos, lrefresh := .f., sid := isNull( pvpitemWW->sid, 0 ) // nordItem
    local  lok
    *
    s_skl_typPohybu := pvpheadW ->ctypPohybu
    s_skl_cisSklad  := pvpHeadw ->ccisSklad
    s_skl_datPvp    := pvpheadW ->ddatPvp
    *
    ::wds_watch_time()
    ::enable_btn_vyrCis()
    *
    if( isnumber(mp1) .and. mp1 = drgEVENT_QUIT, ::is_questionOk := .t., nil )
    *
    if nevent =  xbeP_Close  .and. .not. ::is_questionOk
      nevent := xbeP_Keyboard
      mp1    := xbeK_ESC
    endif

    * My
    * myší se snaží dostat na BROw položky, je potøeba zkotrolovat hlavièku
    if nevent = xbeM_LbClick
      if( oxbp:className() = 'XbpCellGroup' .and. sid = 0 .and. .not. ::is_pvpheadwOk )
        ::df:setNextFocus(::one_edt,, .T. )
        return .t.
      endif
    endif

    do case
    case(nevent = xbeBRW_ItemMarked)
      rowPos   := if( isArray(mp1), mp1[1], mp1 )
      lrefresh := ( ::state <> 0 )

      ::brow:hilite()
      ::msg:WriteMessage(,0)
      ::state := if( sid = 0, 2, 0 )

      if sid <> 0 .and. rowPos = ::brow:rowPos
        * hd
        if( isObject(::cislOBint_hd), (::cislOBint_hd:odrg:isEdit := .F., ::cislOBint_hd:odrg:oxbp:disable() ), nil )
        if( isObject(::cisZakaz_hd) , (::cisZakaz_hd:odrg:isEdit  := .F., ::cisZakaz_hd:odrg:oxbp:disable()  ), nil )

        * it
        if( isObject(::sklPol)      , (::sklPol:odrg:isEdit    := .F., ::sklPol:odrg:oxbp:disable()   ), nil )
        if( isObject(::cisObj)      , (::cisObj:odrg:isEdit    := .F., ::cisObj:odrg:oxbp:disable()   ), nil )
        if( isObject(::cislOBint)   , (::cislOBint:odrg:isEdit := .F., ::cislOBint:odrg:oxbp:disable()), nil )
        if( isObject(::doklad_o)    , (::doklad_o:odrg:isEdit  := .F., ::doklad_o:odrg:oxbp:disable() ), nil )

        if( isObject(::skladKam)    , (::skladKam:odrg:isEdit  := .F., ::skladKam:odrg:oxbp:disable() ), nil )
        if( isObject(::sklPolKam)   , (::sklPolKam:odrg:isEdit := .F., ::sklPolKam:odrg:oxbp:disable()), nil )
        if( isObject(::ucetSKKam)   , (::ucetSKKam:odrg:isEdit := .F., ::ucetSKKam:odrg:oxbp:disable()), nil )

        if( isObject(::klicSKMis)   , (::klicSKMis:odrg:isEdit := .F., ::klicSKMis:odrg:oxbp:disable()), nil )
        if( isObject(::klicODMis)   , (::klicODMis:odrg:isEdit := .F., ::klicODMis:odrg:oxbp:disable()), nil )
        if( isObject(::invCISDim)   , (::invCISDim:odrg:isEdit := .F., ::invCISDim:odrg:oxbp:disable()), nil )

        if(ismethod(self, 'postItemMarked'), ::postItemMarked(), Nil)
        ::restColor()
      endif

      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') .and. isobject(::brow)

         if ::postValidateItems(::it_file)
           ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

          if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
        endif
      else
        if isMethod(self,'postSave')

          if ::canBe_Save()
*          if skl_datainfo():new('pvpHeadW', 'pvpItemWW'):canBe_Save()

            if ::postSave()
              if( .not. ::new_dok, ( PostAppEvent(xbeP_Close, nEvent,,oXbp), ::is_questionOk := .t. ), nil)
              return .t.
            endif
          endif
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

    case nEvent = drgEVENT_DELETE
      if( olastDRG:className() = 'drgDBrowse' .or. oxbp:className() = 'XbpBrowse') .and. isobject(::brow)

         if ::pvpitem_isOk() = 558
           fin_info_box( 'Položku pøíjemky, ' +CRLF +'nelze zrušit nebo již existují pozdìjší výdejky na položku  ...', XBPMB_CRITICAL )
           return .t.
         else
           return ::handleEvent(nEvent, mp1, mp2, oXbp)
         endif
      endif

    otherWise
      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .t.


  inline method destroy()

    ::del_panew_invCISdim()

    ::wds_disconnect()

    if( select('pvpHeadw' ) = 0, nil, pvpHeadw ->(dbclosearea()) )
    if( select('pvpItemww') = 0, nil, pvpItemww->(dbclosearea()) )
    if( select('pvpItemw' ) = 0, nil, pvpItemw ->(dbclosearea()) )
    if( select('vyrCisw'  ) = 0, nil, vyrCisw  ->(dbclosearea()) )
    if( select('vyrZakitw') = 0, nil, vyrZakitw->(dbclosearea()) )
    if( select('msDimW'   ) = 0, nil, msDimW   ->(dbclosearea()) )

    vyrZak->( ads_clearAof())
    vyrPol->( ads_clearAof())

    ::drgUsrClass:destroy()
  return self
  **
  *

HIDDEN:
*  sys
  var     msg, dm, dc, df, ib, ab, tabPageManager

  var     paCards, members
  var     pa_onCards
  var     members_skl_pri, members_skl_vyd, members_inf
  var     opb_stornoDok
  method  showGroup


  inline method disable_items_onKards()
    local  x, pa, odrg
    local  nkarta := ::nkarta
    *
    local  cclr     := GraMakeRGBColor( { 234,234,234 } )


    for x := 1 to len(::pa_onCards) step 1
      odrg := ::pa_onCards[x]
      pa   := listAsArray( odrg:tipText )

     if ( nin := ascan( pa, str(nkarta,3) )) <> 0
        if( odrg:className() = 'drgText', nil, odrg:isEdit := .f.)
        if( odrg:className() = 'drgText', odrg:oxbp:disable(), odrg:oxbp:setColorBG( cclr ) )

      else
        if( odrg:className() = 'drgText', nil, odrg:isEdit := .t.)
        if( odrg:className() = 'drgText', odrg:oxbp:enable(), odrg:oxbp:setColorBG( GRA_CLR_WHITE ) )

      endif

      if( ismembervar(odrg,'clrFocus'), odrg:clrFocus := if( nin <> 0, cclr, GRA_CLR_WHITE), nil )

      if( ismembervar(odrg,'pushGet') .and. isobject(odrg:pushGet))
        odrg:pushGet:disabled := .not. odrg:isEdit
** bacha        if( odrg:isEdit, odrg:pushGet:oxbp:show(), odrg:pushGet:oxbp:hide() )
      endif
    next
  return self

ENDCLASS


method SKL_pvphead_in:init(parent)
  local  file_name
  public s_skl_typPohybu, s_skl_cisSklad, s_skl_datPvp

//  isWorkVersion := .F.

  ::drgUsrClass:init(parent)

  (::hd_file := 'pvpheadw', ::it_file := 'pvpitemww' )
  ::NEWhd    := .not. ( parent:cargo = drgEVENT_EDIT)

  drgDBMS:open( 'c_typPoh' )
  drgDBMS:open( 'c_sklady' )
  drgDBMS:open( 'kurzit'   )

  drgDBMS:open( 'cenZboz'  )
  drgDBMS:open( 'cenZboz',,,,, 'cenZboz_pk' )  // pro pøevod
  drgDBMS:open( 'cenZboz',,,,, 'cenZboz_vc' )  // pro button výrobní èísla

  drgDBMS:open( 'pvpTerm'  )
  drgDBMS:open( 'objVyshd' )
  drgDBMS:open( 'objVysit' )
  drgDBMS:open( 'objHead'  )
  drgDBMS:open( 'objItem'  )

  drgDBMS:open( 'vyrZak'   )
  drgDBMS:open( 'vyrPol'   )

  drgDBMS:open( 'dodZboz'  )
  drgDBMS:open( 'msDim'    )

  drgDBMS:open( 'c_uctskp' )
  drgDBMS:open( 'c_jednot' )
  drgDBMS:open( 'c_prepmj' )

  drgDBMS:open( 'ucetPRit' )

  drgDBMS:open( 'pvpHead',,,,, 'pvpHeadA'  )
  drgDBMS:open( 'pvpitem',,,,, 'pvpitemA'  )  // kontrola opravy položky pøíjemky
  drgDBMS:open( 'pvpitem',,,,, 'pvpitem_ss')  // Sel_Storno

  ::HD := ::hd_file
  ::IT := ::it_file

  ::mainSklad           := ''
  ::mainPohyb           := '0'
  ::nkarta              := 110
  ::is_questionOk       := .f.
  ::is_pvpheadwOk       := .t.
  ::in_postValidateForm := .f.

  ::skl_datainfo:init('pvpHeadW', 'pvpItemWW', ::NEWhd )

  skl_pvpHead_cpy(self)
return self


method SKL_pvphead_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers
  local  x, odrg, groups, name, tipText
  *
  local  acolors  := MIS_COLORS, pa_groups, nin
  local  pa_Karta := {}
  *
  local  values


  ::hd_udcp        := drgDialog:udcp

  ::msg            := drgDialog:oMessageBar             // messageBar
  ::dm             := drgDialog:dataManager             // dataManager
  ::dc             := drgDialog:dialogCtrl              // dataCtrl
  ::df             := drgDialog:oForm                   // form
  ::ab             := drgDialog:oActionBar:members      // actionBar
  ::ib             := drgDialog:oIconBar                // iconBar
  ::tabPageManager := drgDialog:oForm:tabPageManager    // tabPageManager

  ::paCards         := { '', '' }                       // GROUPS HD/IT and all empty
  ::pa_onCards      := {}
  ::members         := drgDialog:oForm:aMembers

  ::members_skl_pri := {}
  ::members_skl_vyd := {}

  * ošidíme záložku
*  ::tabPageManager:members[1]:onFormIndex := 1
*  ::tabPageManager:members[2]:onFormIndex := 2

  for x := 1 to len(members) step 1

    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)
    name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
    tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')
    *
    *
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
          odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN) // GRA_CLR_BLUE)
        endif
      endif

      groups      := pa_groups[1]
      odrg:groups := groups
    endif
    *
    * pomocné neviditelné položky
    if empty(groups)
      aadd(::members_skl_pri  , odrg)
      aadd(::members_skl_vyd  , odrg)
    endif

    do case
    case( groups = 'SKL_PRIHD')   ;  aadd(::members_skl_pri, odrg)
    case( groups = 'SKL_VYDHD')   ;  aadd(::members_skl_vyd, odrg)

    case( groups = 'SKL_PRI')     ;  aadd(::members_skl_pri, odrg)
    case( groups = 'SKL_PRI115')  ;  aadd(::members_skl_pri, odrg)
    case( groups = 'SKL_PRI117')  ;  aadd(::members_skl_pri, odrg)
    case( groups = 'SKL_PRI177')  ;  aadd(::members_skl_pri, odrg)
    case( groups = 'SKL_CEN400')  ;  aadd(::members_skl_pri, odrg)

    case( groups = 'SKL_VYD')     ;  aadd(::members_skl_vyd, odrg)
    case( groups = 'SKL_VYD205')  ;  aadd(::members_skl_vyd, odrg)
    case( groups = 'SKL_VYD215')  ;  aadd(::members_skl_vyd, odrg)
    case( groups = 'SKL_PRE305')  ;  aadd(::members_skl_vyd, odrg)
    endcase

    if odrg:className() = 'drgPushButton' .and. odrg:event = 'ev_stornoDok'
      odrg:isEdit     := .f.
      ::opb_stornoDok := odrg
*      odrg:oxbp:disable()
    endif

    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      if ( odrg:caption = groups, aadd( ::paCards, { groups, odrg, x } ), nil )
    endif

    if odrg:ClassName() =  'drgTabPage'
      if odrg:tabNumber = 2
        odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
      endif
    endif

    if .not. empty(tipText)
      aadd( ::pa_onCards, odrg )
    endif

  next

  cky := upper(pvpheadW->culoha) +upper(pvpheadW->ctypPohybu)
  c_typPoh ->( dbseek( cky,,'C_TYPPOH06'))
  ::sel_typPohybu()

  ::skl_pvphead_main:init(drgDialog:udcp)

  if( ::NEWhd, ::df:setNextFocus('pvpheadW->ctyppohybu',,.t.), nil )

  *
  ** pro pøecenìní pro opravu všechno zablokujem
  if .not. ::NEWhd
    if ( ::pvphead_mainTask <> 0 .or. (::cfile_hd)->ntypPvp = 4 )
      drgDialog:setReadOnly(.t.)
      ::cenNADOzm := nil

      values := ::dm:vars:values
      aeval( values, { |o| if( o[2]:odrg:isedit, ;
                             ( o[2]:odrg:isedit       := .f., ;
                               o[2]:odrg:isedit_inrev := .f., ;
                               O[2]:odrg:isEdit_org   := .f., ;
                               o[2]:odrg:oxbp:disable()       ), nil ) } )
    endif
  endif

  ::dm:refresh()
return self


method skl_pvphead_in:skl_typPoh_sel(drgDialog)
  local  srchDialog
  local  oDialog, nExit, showDialog := .f.
  local  cisSklad := pvpHeadW->ccisSklad
  local  drgVar   := ::dm:get('pvpheadW->ctypPohybu', .F.), lastDrg, oVar
  local  value    := upper( drgVar:get())
  local  ok       := ( !Empty(value) .and. C_typPoh->(dbseek(S_DOKLADY +value,,'C_TYPPOH02')))
  *
  if isObject(drgDialog) .or. !ok
     srchDialog := drgDialog():new( 'SKL_typPoh_SEL', ::drgDialog)
**     srchDialog:cargo := value
     showDialog := .t.
     srchDialog:create(,,.T.)
     *
     IF srchDialog:exitState = drgEVENT_SELECT
**        drgVar:set(srchDialog:cargo)

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
    pvpHeadW ->ctypDoklad  := c_typPoh->ctypDoklad
    pvpHeadW ->ctypPohybu  := c_typPoh->ctypPohybu
    pvpHeadW ->ntypPvp     := c_typPoh->ntypPvp
    pvpHeadW ->ncislPoh    := val(c_typPoh->ctypPohybu)
    pvpheadW ->ntypPohyb   := c_typPoh->ntypPohyb
    pvpHeadW ->ntypPoh     := c_typPoh->ntypPvp
    pvpHeadW ->nkarta      := val ( right( allTrim(c_typPoh->ctypDoklad), 3))

    ::nkarta               := pvpHeadW ->nkarta

    if .not. ::in_postValidateForm
      pvpHeadW->ndoklad      := newDoklad_skl( ::nkarta, cisSklad )
    endif

    if( ::nkarta = 274 .or. ::nkarta = 293 )
      firmy->( dbseek( 1,, 'FIRMY18' ))   // nis_MAF - mateøská firma
      ::dm:set( ::hd_file + '->ncisFirmy' , firmy->ncisFirmy)
      ::dm:set( ::hd_file + '->cnazFirmy' , firmy->cNazev   )

      pvpHeadW->ncisFirmy := firmy->ncisFirmy
      pvpHeadW->cnazFirmy := firmy->cnazev
    else
      if drgVar:changed()
        ::dm:set( ::hd_file + '->ncisFirmy' , 0 )
        ::dm:set( ::hd_file + '->cnazFirmy' , '')

        pvpHeadW->ncisFirmy := 0
        pvpHeadW->cnazFirmy := ''
      endif
    endif

    if( .not. showDialog, ::sel_typPohybu(), nil )
    ::refresh( drgVar )
    ::postAppend()
  endif
RETURN ok


method skl_pvphead_in:sklad_sel(drgDialog)
  local  lastDrg := ::df:oLastDrg
  local  drgVar  := ::dm:get('pvpheadW->ccisSklad', .F.)
  local  value   := upper( drgVar:get())
  local  ok      := ( !Empty(value) .and. c_sklady->(dbseek(value,,'C_SKLAD1')))
  local  zahrMena
  *
  local  name    := Lower(drgVar:name)
  local  file    := drgParse(name,'-')

  if IsObject(drgDialog) .or. !ok
     srchDialog := drgDialog():new( 'C_SKLADY', ::drgDialog)  // sklady\cis\skl_cisel_sel.prg
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

  if( ok .and. file = ::hd_file )
    if( pvpHeadW->ccisSklad <> c_sklady->ccisSklad, ::odialog_centerm := nil, nil )

    pvpHeadW->ccisSklad := c_sklady->ccisSklad

    if .not. ::in_postValidateForm
      pvpHeadW->ndoklad := newDoklad_skl( ::nkarta, c_sklady->ccisSklad )
    endif

    * sklad je vedený v rùzných mìnách
    zahrMena := coalesceEmpty( c_sklady->czkratMeny, sysConfig( 'FINANCE:cZAKLMENA' ) )
    pvpHeadW ->czahrMena   := zahrMena
    pvpHeadW ->nkurZAHmen  := 1
    pvpHeadW ->nmnozPrep   := 1

    if( drgVar:changed(), ::odialog_centerm := nil, nil )
    ::refresh( drgVar)
    ::postAppend()
  endif
RETURN ok


method skl_pvphead_in:doklad_vld( nDoklad, lMsgDouble)
  Local  lRetVal, nRange, nStart, nKonec, Key, nTag
  Local  cTypPohyb := LEFT( ALLTRIM( STR( ::nKarta)), 1 )
*
  local  nTypCisRad := SysConfig( 'Sklady:nTypCisRad')
  local  lRangePVP  := SysConfig( 'Sklady:lRangePVP' )
  local  cisSklad   := upper(pvpHeadW->ccisSklad)

  DEFAULT lMsgDouble TO .T.

  DO CASE
  CASE nTypCisRad = 1 .or. nTypCisRad = 3                                       // èís.øady dokladù v rámci celé firmy
    If lRangePVP
       nRange := IIF( cTypPohyb == PRIJEM, SysConfig( 'Sklady:nRangePrij'),;
                 IIF( cTypPohyb == VYDEJ , SysConfig( 'Sklady:nRangeVyde'),;
                 IIF( cTypPohyb == PREVOD, SysConfig( 'Sklady:nRangePrev'),;
                 IIF( cTypPohyb == PRECEN, SysConfig( 'Sklady:nRangePrij'), Nil ))))
       nTag := 7
       Key  := If( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nDoklad,10)
    Else
       nRange := SysConfig( 'Sklady:nRangePrij')
       nTag   := 1
       Key    := nDoklad
    EndIf
    ( nStart := nRange[1], nKonec := nRange[2] )

  CASE nTypCisRad = 2                                                           // èís.øady dokladù v rámci skladù
    IF C_Sklady->( dbSEEK( cisSklad,, 'C_SKLAD1'))
      IF C_Sklady->lRangePVP
        nStart := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemOd ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejOd  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodOd ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemOd , Nil ))))

        nKonec := IIF( cTypPohyb == PRIJEM, C_Sklady->nPrijemDo ,;
                  IIF( cTypPohyb == VYDEJ , C_Sklady->nVydejDo  ,;
                  IIf( cTypPohyb == PREVOD, C_Sklady->nPrevodDo ,;
                  IIf( cTypPohyb == PRECEN, C_Sklady->nPrijemDo , Nil ))))
        nTag := 17
        Key  := cisSklad + If( cTypPohyb == PRECEN, PRIJEM, cTypPohyb) + StrZero( nDoklad,10)
      ELSE
        nStart := C_Sklady->nPrijemOd
        nKonec := C_Sklady->nPrijemDo
        nTag   := 16
        Key    := cisSklad + StrZero( nDoklad,10)
      ENDIF
    ENDIF
  ENDCASE
  *
  If nDoklad < nStart .or. nDoklad > nKonec
    MsgBOX( 'Èíslo dokladu je mimo rozsah povolené èíselné øady !' )
    lRetVal := .f.
  Else
    drgDBMS:open('PVPHEAD',,,,, 'PVPHEADa')
    lRetVal := PVPHEADa->( dbSeek( Key,, AdsCtag(nTag)))
    PVPHEADa->( dbCloseArea())
    IF( lRetVal, IF( lMsgDouble, MsgBOX( 'Zadáno duplicitní èíslo dokladu !' ), nil), nil )
    lRetVal := !lRetVal
  EndIf
RETURN lRetVal


method skl_pvphead_in:skl_firmy_sel(drgDialog)
  LOCAL oDialog, nExit, copy := .f.
  Local drgVar := ::dm:get( 'pvpHeadW->nCisFirmy', .F.)
  Local value  := drgVar:get()
  Local ok     := ( empty(value) .or. firmy->( dbseek(value,,'FIRMY1')))
  *
  ** firma není povinná
  If IsObject(drgDialog) .or. !ok
    _clearEventLoop(.t.)
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit
  ENDIF

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ok := .T.
    ::dm:set( ::hd_file + '->ncisFirmy' , firmy->ncisFirmy)
    ::dm:set( ::hd_file + '->cnazFirmy' , firmy->cNazev   )

    pvpHeadW->ncisFirmy := firmy->ncisFirmy
    pvpHeadW->cnazFirmy := firmy->cnazev
    ::postAppend()
  endif
return ok


* pøíjemky nabídka objVyshd
method skl_pvphead_in:skl_objVyshd_sel(drgDialog)
  local  oDialog, nExit, copy := .f., cfilter
  local  cisFirmy := if( ::nKarta = 274 .or. ::nKarta = 293, 1, (::hd_file)->ncisFirmy )
  local  drgVar   := ::dm:get( 'pvpHeadW->ccislOBint', .F.)
  local  value    := upper( drgVar:get())
  local  ok       := ( empty(value) .or. objVyshd->( dbseek( strZero(cisFirmy,5) +value,,'OBJDODH2' )))

  * na hlavièce lze zadat ccisObj/ncisObj nebo nic
  if val(value) <> 0   // zadal ncisObj
    ok := objVyshd->( dbseek( strZero(cisFirmy,5) +strZero( val(value), 7),,'OBJDODH9' ))
  else
    if .not. empty(value)
      ok := objVyshd->( dbseek( strZero(cisFirmy,5) +value,,'OBJDODH2' ))
    else
      if .not. isObject(drgDialog)
        return .t.
      endif
    endif
  endif

  if isObject(drgDialog) .or. !ok
    cfilter := format( "ncisFirmy = %% .and. (nmnozOBdod-nmnozPLdod) > 0", { cisFirmy } )

    objVyshd->( ads_setAof(cfilter), dbgoTop())
    DRGDIALOG FORM 'skl_objVyshd_sel' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit

    objHead->( ads_clearAof())
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::dm:set( ::hd_file + '->ccislOBint', objVyshd->ccisObj )
    pvpHeadW->ccislOBint := objVyshd->ccisObj
  endif
return ok


* výdejky nabídka objHead
method skl_pvphead_in:skl_objhead_sel(drgDialog)
  local  oDialog, nExit := drgEVENT_QUIT, copy := .f., cfilter
  local  cisFirmy := (::hd_file)->ncisFirmy
  local  drgVar   := ::dm:get( 'pvpHeadW->ccislOBint', .F.)
  local  value    := upper( drgVar:get())
  local  ok       := ( empty(value) .or. objHead->( dbseek( strZero(cisFirmy,5) +value,,'OBJHEAD1' )))
  *
  local  cfirma   := strZero( cisFirmy, 5), csklad := upper(pvpheadW->ccisSklad), lok, pa_remove := {}

  /*
  * na hlavièce lze zadat ccisObj/ncisObj nebo nic
  if val(value) <> 0   // zadal ncisObj
    ok := objVyshd->( dbseek( strZero(cisFirmy,5) +strZero( val(value), 7),,'OBJDODH9' ))
  else
    if .not. empty(value)
      ok := objVyshd->( dbseek( strZero(cisFirmy,5) +value,,'OBJDODH2' ))
    else
      if .not. isObject(drgDialog)
        return .t.
      endif
    endif
  endif
*/

  if isObject(drgDialog) .or. !ok
    cfilter := format( "ncisFirmy = %% .and. (nmnozOBodb-nmnozPLodb) > 0", { cisFirmy } )

    objHead->( ads_setAof(cfilter), dbgoTop())

    do while .not. objHead->( eof())
      lok := objItem->( dbseek( cfirma +upper(objHead->ccislOBint) +csklad,,'OBJITE15' ))

      if lok .and. vyrZak->( dbseek( upper(objHead->ccislOBint),, 'VYRZAK10'))
        lok := ( vyrZak->cstavZakaz <> 'U' )
      endif

      if( lok, nil, aadd( pa_remove, objHead->(recNo()) ) )
      objHead->( dbskip())
    enddo

    if( len(pa_remove) <> 0, objHead->( Ads_CustomizeAOF( pa_remove, 2 )), nil )
    objHead->( dbgoTop())

    DRGDIALOG FORM 'skl_objHead_sel' PARENT ::drgDialog  MODAL DESTROY EXITSTATE nExit

    objHead->( ads_clearAof())
  endif

  copy := if((ok .and. drgVar:changed() .and. .not. empty(value)) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::dm:set( ::hd_file + '->ccislOBint', objHead->ccislOBint )
    pvpHeadW->ccislOBint := objHead->ccislOBint
  endif
return ok


* pøíjemky i výdejky SKL_PRI115 a SKL_VYD215 vyrZak
method skl_pvphead_in:skl_vyrZak_sel(drgDialog)
  local  oDialog, nExit := drgEVENT_QUIT, copy := .f., cfilter
  local  drgVar   := ::dm:get( 'pvpHeadW->ccisZakaz', .F.)
  local  value    := upper( drgVar:get())
  local  ok
  *
  local  pa_arSelect := {}

  ok  := ( empty(value) .or. vyrZak->(dbseek( upper(value),,'VYRZAK1')) )

  if isObject(drgDialog) .or. !ok
    ::postAppend()

    odialog := drgDialog():new('skl_vyrZak_sel', ::drgDialog)
    odialog:create(,,.T.)

    nexit := odialog:exitState
  endif

  copy := if((ok .and. drgVar:changed() .and. .not. empty(value)) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::dm:set( ::hd_file + '->ccisZakaz', vyrZak->ccisZakaz )
    pvpHeadW->ccisZakaz := vyrZak->ccisZakaz

    vyrPol->( dbEval( { || if( vyrZak->ccisZakaz = vyrPol->ccisZakaz, aadd( pa_arSelect, vyrPol->( recNo())), nil ) } ), ;
              dbgoTop()                                                                                                  )

    ::sp_saveSelectedItems('vyrPol', 6, pa_arSelect)
  endif

  vyrZak->( ads_clearAof())
  vyrPol->( ads_clearAof())
return ok



method SKL_pvphead_IN:comboItemSelected(drgComboBox,isMarked)
  local  value := drgComboBox:Value, values := drgComboBox:values
  local  nIn
  local  odrg

  do case
  case right(drgComboBox:name,7) = 'COBDOBI'
    ::cobdobi(drgComboBox)

  case 'CZAHRMENA' $ drgComboBox:name
    if drgComboBox:ovar:itemChanged()
      pvpHeadW->czahrMena := value
      if( isObject(::dm:has('M->pvpHeadW_zahrMena')), ::dm:set('M->pvpHeadW_zahrMena', value), nil )

      PostAppEvent(xbeP_Keyboard,xbeK_ENTER,,drgComboBox:oxbp)
    endif

  endcase
return self


method SKL_pvphead_IN:showGroup( chead, citem)
  local  x, odrg, groups, avars, members := ::df:aMembers
  local  pa_members_skl
  local  onFormIndex := 2
  *
  local  one_edt, que_del, ps := {}
  local  px := {}
  local  o_cenDOKzm, o_nutneVNZM
  local  nin, o_drg, x_groups
  *
  local  oico_edit  := XbpIcon():new():create()

* off
**  ::drgDialog:dialog:lockUpdate(.t.)
  aeval(members,{|o| ::modi_memvar(o,.f.)})
**  ::drgDialog:dialog:lockUpdate(.f.)

* on
  pa_members_skl := if( chead = 'SKL_PRIHD', ::members_skl_pri, ::members_skl_vyd )
  members        := {}

  for x := 1 to len(pa_members_skl) step 1
    odrg   := pa_members_skl[x]
    groups := if( ismembervar(odrg,'groups'), isnull(pa_members_skl[x]:groups,''), '')
    groups := allTrim(groups)

    *
    ** úprava pro kartu 115 a 215
    if ::nkarta = 115 .or. ::nkarta = 215
      if ( nin := ascan( ::pa_onCards, odrg )) <> 0
        o_drg := ::pa_onCards[nin]
        if '888' $ o_drg:tipText
          groups := '888'
        endif
      endif
    else

/*
      if odrg:className() = 'drgPushButton' .and. odrg:oxbp:cargo:className() = 'drgGet'
        x_groups := odrg:oxbp:cargo:groups
        if ( x_groups = 'SKL_PRI115' .or. x_groups = 'SKL_VYD215' )
          groups := x_groups
        endif
      endif
*/
      if ( groups = 'SKL_PRI115' .or. groups = 'SKL_VYD215' )
        groups := '888'
      endif
    endif

    if( groups = chead .or. groups = citem .or. empty(groups), aadd( members, odrg ), nil )
  next


//  members := if( panGroup = 'SKL_PRI', ::members_skl_pri, ::members_skl_vyd )
  aeval(members,{|o| ::modi_memvar(o,.t.)})


**  ::drgDialog:dialog:lockUpdate(.f.)

  avars := drgArray():new()
  for x := 1 to len(members) step 1
    odrg   := members[x]
    groups := if( ismembervar(odrg,'groups'), isnull(members[x]:groups,''), '')

    if odrg:ClassName() = 'drgTabPage'
       odrg:onFormIndex := x
    endif

    if isMemberVar( odrg, 'isEdit_inRev' )
      if( .not. isNull(odrg:isEdit_inRev, .t.), odrg:isEdit_org := .t., nil )
    endif


    if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
      if ( odrg:caption = citem, onFormIndex := x, nil )
    endif

    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add(members[x]:ovar,lower(members[x]:ovar:name))
      endif
    endif
  next
  * My
  * resetValidation
  aeval( members, {|o| if( o:isEdit, o:postValidOk := nil, nil ) } )
  ::df:aMembers := members
  ::dm:vars     := avars
  ::dm:refreshAndSetEmpty( 'pvpitemWW' )

  * hd
  if isObject( o_nutneVNZM := ::dm:get( ::hd_file +'->nNutneVNZM', .f.) )
    if (::hd_file)->nstav_Dokl = 9
      o_nutneVNZM:odrg:tipText := "100,102,103,104,110,111,116,117,120,130,142,400"
    endif
  endif

  if isObject( o_cenDOKzm := ::dm:get( ::hd_file +'->ncenDOKzm', .f.) )
    if (::hd_file)->nstav_Dokl = 9
      o_cenDOKzm:odrg:tipText := "100,102,103,104,110,111,116,117,120,130,142,400"
    endif
  endif


  * hd
  ::cislOBint_hd := ::dm:get( ::hd_file +'->ccislOBint' , .f.)
  ::varSym_hd    := ::dm:get( ::hd_file +'->cvarSym'    , .f.)
  ::cisFak_hd    := ::dm:get( ::hd_file +'->ncisFak'    , .f.)
  ::cisloDl_hd   := ::dm:get( ::hd_file +'->ncisloDl'   , .f.)
  ::cisZakaz_hd  := ::dm:get( ::hd_file +'->ccisZakaz'  , .f.)

  * it
  ::sklPol     := ::dm:get( ::it_file +'->csklPol'    , .f.)
  ::cisObj     := ::dm:get( ::it_file +'->ccisObj'    , .f.)
  ::intCount   := ::dm:get( ::it_file +'->nintCount'  , .f.)

  ::cislOBint  := ::dm:get( ::it_file +'->ccislOBint' , .f.)
  ::cislPolob  := ::dm:get( ::it_file +'->ncislPOLob' , .f.)

  ::cisZakaz   := ::dm:get( ::it_file +'->ccisZakaz'  , .f.)
  ::vyrpol     := ::dm:get( ::it_file +'->cvyrPol'    , .f.)

  ::doklad_o   := ::dm:get( ::it_file +'->ndoklad_o'  , .f.)

  ::skladKam   := ::dm:get( ::it_file +'->cskladKam'  , .f.)
  ::sklPolKam  := ::dm:get( ::it_file +'->csklPolKam' , .f.)
  ::ucetSKKam  := ::dm:get( ::it_file +'->nucetSKKam' , .f.)

  ::klicSKMis  := ::dm:get( ::it_file +'->cklicSKMis' , .f.)
  ::klicODMis  := ::dm:get( ::it_file +'->cklicODMis' , .f.)
  ::invCISDim  := ::dm:get( ::it_file +'->ninvCISDim' , .f.)

  ::mnozDOKL1  := ::dm:get( ::it_file +'->nmnozDOKL1' , .f.)
  ::mjDOKL1    := ::dm:get( ::it_file +'->cmjDOKL1'   , .f.)
  ::cenNADOzm  := ::dm:get( ::it_file +'->ncenNADOzm' , .f.)

  ::mnozPRdod  := ::dm:get( ::it_file +'->nmnozPRdod' , .f.)
  ::o_nrecOr   := ::dm:get( ::it_file +'->_nrecOr'    , .f.)

  if isObject(::mnozPRdod)
    ::mnozPRdod:odrg:clrFocus   := GraMakeRGBColor( {205, 255, 155 } )

    oico_edit:load( , 114)
*    ::mnozPRdod:odrg:pushGet:oxbp:setCaption('')
*    ::mnozPRdod:odrg:pushGet:oxbp:ImageAlign   := XBPALIGN_HCENTER+XBPALIGN_VCENTER

*    ::mnozPRdod:odrg:pushGet:oxbp:setImage( oico_edit )
  endif


  if ::NEWhd
    * My
    ::is_pvpheadwOk := .f.
***    ::postAppend()
    ::df:setNextFocus('pvpHeadW->ctyppohybu',,.t.)
  endif
return