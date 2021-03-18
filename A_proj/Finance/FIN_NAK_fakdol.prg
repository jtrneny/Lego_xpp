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
#include "..\Asystem++\Asystem++.ch"

* bacha ø. 439 v metodì postAppend musí být k ncisFirmy dotaženy dodací adresy firmy
* a tyto se nabídnou pro pøevzetí

*
** CLASS FIN_NAK_fakdol ********************************************************
CLASS  FIN_NAK_fakdol FROM WDS
exported:
  var     cmb_typPoh, cmb_kodPlneni, cmb_kodPlneni_orsize, cmb_kodPlneni_defval
  var                 chb_preDanPov, cmb_typPreDan
  var     lnewRec, hd_file, it_file
  var     info_16, info_25, info_34
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  *
  var     lvsymbol , cisZalFak, o_cejPrZbz
  var     cisSklad , sklPol
  var     cisloDl  , countdl
  var     cislObInt, cislPolob
  var     cisZakazi
  var     po_Gets
  *
  var     o_cejprkbz, o_cejprkdz      // pro metodu txt_zaMJ_dan()
  var     o_cecprkbz, o_cecprkdz      // pro metodu txt_zaPOL_dan
  var     o_cenZakCel, o_sazDan       // pro tuzemskou FA jsou tyto údaje needitovateln0
  *
  var     o_cenzboz_kDis, o_dodlstit_kDis, o_objitem_kDis, o_vyrzak_kDis
  *
  var     mnozZdok
  var     m_sel_filter

  method  init
  method  infoShow, comboItemSelected, postAppend, postValidate
  method  fin_firmy_sel, fin_vykdph_rv_sel
  method  parvyzal_vykdph_in
  method  showGets


  * textové info položky na kartì
  inline access assign method cenzboz_kDis(co) var cenzboz_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := ::cisSklad:get() + ::sklPol:get()

      if( lok := cenzboz->(dbseek(upper(cky),,'CENIK03')))
        * jen pro cenníkové položky *
        if( upper(cenzboz->cpolcen) = 'C', retval := max(0, ::wds_cenzboz_kDis), lok := .f.)
      endif

      if isobject(::o_cenzboz_kDis)
        if(lok, ::o_cenzboz_kDis:odrg:oxbp:show(), ::o_cenzboz_kDis:odrg:oxbp:hide())
      endif
    endif
    return retVal

  inline access assign method dodlstit_kDis() var dodlstit_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisloDl) .and. isObject(::countdl)
      cky  := strZero(::cisloDl:get(),10) +strZero(::countdl:get(),5)

      if(lok :=  dodlstPit->(dbseek(cky,,'DODLIT5')))
        retVal := ::wsd_dodlstit_kDis
      endif

      if isobject(::o_dodlstit_kDis)
        if(lok, ::o_dodlstit_kDis:odrg:oxbp:show(), ::o_dodlstit_kDis:odrg:oxbp:hide())
      endif
    endif
    return retVal

  inline access assign method objitem_kDis()  var objitem_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cislObInt) .and. isObject(::cislPolob)
      cky  := upper(::cislObInt:get()) +strZero(::cislPolob:get(),5)

      if(lok := objVysit ->(dbseek(cky,,'OBJITEM2')))
        retVal := ::wsd_objitem_kDis
      endif

      if isobject(::o_objitem_kDis)
        if(lok, ::o_objitem_kDis:odrg:oxbp:show(), ::o_objitem_kDis:odrg:oxbp:hide())
      endif
    endif
    return retVal

  inline access assign method vyrzak_kDis()   var vyrzak_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisZakazi)
      cky  := ::cisZakazi:get()

      if(lok := vyrzakit->(dbseek( upper(cky),,'ZAKIT_4')))
        retVal := ::wsd_vyrzakit_kDis
      endif

      if isobject(::o_vyrzak_kDis)
        if(lok, ::o_vyrzak_kDis:odrg:oxbp:show(), ::o_vyrzak_kDis:odrg:oxbp:hide())
      endif
    endif
    return retVal

  * položka je sestava ??
  inline access assign method isSest() var isSest
    local  retVal := 0, cky := space(30) +upper((::it_file)->csklPol)

    if (::it_file)->ctypSklPol = 'S '
      retVal := if( kusov->(dbSeek(cky,,'KUSOV1')), MIS_BOOKOPEN, MIS_BOOK)
    endif
    return retVal

  * položka je zálohová faktura a má vazbu na DD ??
  inline access assign method isZalFak() var isZalFak
    local  retVal := 0, cisZalFak := (::it_file)->ncisZalFak

    if cisZalFak <> 0
      if vykdph_Pw->( dbseek( cisZalFak,,'VYKDPH_6'))

       if (::it_file)->nsubCount = 0
         retVal := if( (::it_file)->_nstate = 0, MIS_MINUS, MIS_PLUS )
       else
         retVal := BANVYPIT_8
       endif
      endif
    endif
    return retVal

  **
  inline method tabSelect(oTabPage,tabnum)
    local ok          := .t.

    if ::hd_file = 'fakvyshdw'
      do case
      case(otabPage:tabNumber = 4)   // 1 -> 4
*        ok := ::postValidateForm(::hd_file)
*        if(ok, (::o:brow:refreshAll(), ::setfocus()), nil)
        if( isObject(::cmb_kodPlneni), ::cmb_kodPlneni:refresh(fakvysitw->nkodPlneni), nil )
        ::setfocus( if( (::it_file)->(eof()), 2, 0))

      otherwise
        do case
        case(otabPage:tabNumber = 3) // ; ::df:setNextFocus( ::hd_file +'->ncisFirmy'  )
        case(otabPage:tabNumber = 2) // ; ::df:setNextFocus( ::hd_file +'->ncisFirDoa' )
        case(otabPage:tabNumber = 1) // ; ::df:setNextFocus( ::hd_file +'->cbank_uct'  )

          if::o:onTabNum = 0
**            ::o:df:tabPageManager:members[2]:is_show := .f.
**            PostAppEvent(xbeP_Keyboard,xbeK_ALT_2,,oTabPage:oxbp)
          else
            ::o:df:tabPageManager:members[3]:is_show := .f.
            PostAppEvent(xbeP_Keyboard,xbeK_ALT_3,,oTabPage:oxbp)
          endif

        endcase
      endcase
    else
      do case
      case(otabPage:tabNumber = 2)   // 1 -> 2
*        ok := ::postValidateForm(::hd_file)
*        if(ok, (::o:brow:refreshAll(), ::setfocus()), nil)
         ::checkItemSelected()

        (::o:brow:refreshAll(), ::setfocus())
      case(otabPage:tabNumber = 1)   // 2 -> 1
      endcase
    endif
  return ok

  inline method fakdol_handleEvent(nevent,mp1,mp2,oxbp)
    local  myEv := {drgEVENT_APPEND,drgEVENT_EDIT,drgEVENT_SAVE,drgEVENT_EXIT,drgEVENT_DELETE}
    local  file_name, ok, hd_file := left(::hd_file,len(::hd_file)-1)
    local  members := ::df:amembers, pos, brow := ::o:brow

    *
    ::wds_watch_time()
    *
    * generovanou položku DD párované zálohy nelze  ZRUŠIT
     if nEvent = drgEVENT_DELETE .and. (::it_file)->nsubCount <> 0
      if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
        return .t.
      endif
    endif

    if ascan(myEv,nevent) <> 0
      if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
        file_name := ::it_file
      else
        file_name := lower( isNull(drgparse(::df:oLastDrg:name,'-'), ::it_file ))
      endif
    endif

    *
    do case
    case(nevent = xbeTab_TabActivate)
      if ::hd_file = 'fakvyshdw'
        if oxbp:cargo:tabNumber = 4
          if oxbp:Minimized
            return .not. ::postValidateForm(::hd_file)
          else
            return .t.
          endif
        endif
      else
        if oxbp:cargo:tabNumber = 2
          if oxbp:Minimized
            return .not. ::postValidateForm(::hd_file)
          else
            return .t.
          endif
        endif
      endif
      return .f.

    case(nevent = xbeP_Paint)
**      if( oxbp:className() = 'XbpTabPage', ::infoShow(), nil)
      return .f.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if lower((::it_file)->cfile_iv) = 'cenzboz' .and. ::isSest = MIS_BOOKOPEN
        ** tady zavoláme pohled na kusov
        ::fin_cenzboz_ses()
      endif
      return .t.

    case(nevent = xbeBRW_ItemMarked)
      rowPos := if( isArray(mp1), mp1[1], mp1 )

      ::o:msg:WriteMessage(,0)
      ::o:state := 0

      if rowPos = ::o:brow:rowPos
        if(ismethod(self, 'postItemMarked'), ::postItemMarked(), Nil)
        ::cejPrZbz_push()
        ::restColor()
      endif
      return .f.

    case(nevent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT)

      if  oSession_data:inTransaction()
        _clearEventLoop()

      else
        ::o:restColor()
        do case
        case(file_name = ::hd_file)  ;  saveOk := 2   // if((::it_file)->(eof()),-1,2)
        otherwise                    ;  if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
                                          saveOk := if((::it_file)->(eof()),0,2)
                                        else
                                          saveOk := if( ::postValidateForm(file_name), 1, 0)
                                        endif
        endcase
        *
        if     saveOk = 1
          ok := if(isMethod(::o,'overPostLastField'), ::o:overPostLastField(), .t.)
          if(ok, ::o:postLastField(), nil)

        elseif saveOk = 2  ;  if FIN_postsave():new(hd_file,::o):ok
                                if ::o:postSave()
                                  if .not. ::o:new_dok
                                    _clearEventLoop(.t.)
                                    setAppFocus(::o:drgDialog:dialog)
                                    PostAppEvent(xbeP_Close,,,::o:drgDialog:dialog)
                                    return .t.
                                  endif
                                endif
                              endif
        elseif saveOk = -1
          drgMsg(drgNLS:msg('Doklad nemá položky -nelze uložit- omlouvám se ...'),,::dm:drgDialog)
        endif
      endif
      return .t.

    otherwise
      return ::o:handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .t.

  *
  inline method modi_memvar(o,on_off)
    if ismembervar(o,'groups') .and. .not. empty(o:groups)
      if(on_off, o:oxbp:show(), o:oxbp:hide())
      if( ismembervar(o,'obord') .and. isobject(o:obord))
        if(on_off, o:obord:show(), o:obord:hide())
      endif

      if( ismembervar(o,'pushGet') .and. isobject(o:pushGet))
         if(on_off, o:pushGet:oxbp:show(), o:pushGet:oxbp:hide())
      endif
    endif
  return nil


  inline method cejPrZbz_push()
    local  nisParZal, o_push, isBlocked := .f., ok := .t.
    local  o_isParZal := ::dm:has(::it_file +'->nisParZal')
    local  o_cisloDD  := ::dm:has(::it_file +'->ncislodd' )
    local  o_dialog   := ::dm:drgDialog:dialog
    *
    local  pb         := { GraMakeRGBColor({255, 255,   0}), ;
                           GraMakeRGBColor({255, 255, 210})  }

    if isObject(::o_cejPrZbz) .and. isObject(o_isParZal) .and. isObject( o_cisloDD)
      nisParZal := if( ::o:state = 0, (::it_file)->nisParZal, o_isParZal:value )
      ncisloDD  := if( ::o:state = 0, (::it_file)->ncisloDD , o_cisloDD:value  )
      o_push    := ::o_cejPrZbz:odrg:pushGet

      o_push:oxbp:SetGradientColors()

      do case
      case(nisParZal = 0)  ;  o_push:event := 'fin_cmdph'
      case(nisParZal = 1)  ;  o_push:event := 'null'
                              ok           := .f.
      case(nisParZal = 2)  ;  if empty(ncisloDD)
                                o_push:oxbp:SetGradientColors(pb)
                                o_push:event := 'parvyzal_vykdph_in'
                              else
                                o_push:event := 'null'
                                ok           := .f.
                              endif
      endcase

      if( ok, (o_push:oxbp:show(), o_push:enable() ), ;
              (o_push:oxbp:hide(), o_push:disable())  )

    endif
  return nisParZal

//  inline method post_drgEvent_Refresh()
//    ::cejPrZbz_push()
//  return

  inline access assign method isTuz() var isTuz
    return Equal(SysConfig('Finance:cZaklMena'), fakprihdw->czkratMenz)


  inline method fin_cenzboz_ses()
    local  odialog, nexit := drgEVENT_QUIT

    DRGDIALOG FORM 'FIN_cenzboz_SEST' PARENT ::o:drgDialog MODAL DESTROY EXITSTATE nExit
  return

hidden:
  var     o, dm, df, msg, members_inf
  var     splatn_cfg, splatn_ffi

  method  postValidateForm, nazevrv

  inline method set_splatfak()
    local ovar    := ::dm:has(::hd_file +'->dsplatfak' )
    local vystFak := ::dm:get(::hd_file +'->dvystfak'  ), splatFak
    local typUhr  := ::dm:get(::hd_file +'->czkrtypuhr')

    if isobject(ovar)
      c_typuhr ->(dbseek( upper(typUhr),,'TYPUHR1'))

      * na c_typuhr je   nastavena hotovost -> nsplatfak = dvystfak
      *             není                    -> nsplatfak = dvystfak +CoalesceEmpty(splatn_ffi, splatn_cfg)

      splatFak := if( c_typuhr->lishotov, ;
                      vystFak           , ;
                      vystFak +CoalesceEmpty(::splatn_ffi, ::splatn_cfg) )

      (::hd_file)->dsplatfak := splatFak
      ovar:set(splatFak)
    endif
  return
ENDCLASS


method FIN_NAK_fakdol:init(parent)
  ::o               := parent
  ::dm              := parent:dm
  ::df              := parent:df
  ::msg             := parent:msg
  ::members_inf     := parent:members_inf
  ::po_Gets         := { ::sklPol, ::cisloDl, ::cislObInt, ::cisZakazi, ::cisZalFak }
  *
  ::m_sel_filter    := ''
  *
  ::splatn_cfg      := sysConfig('FINANCE:nSPLATNOST')
  ::splatn_ffi      := 0

  ::o_cenzboz_kDis  := ::dm:has('M->cenzboz_kDis' )
  ::o_dodlstit_kDis := ::dm:has('M->dodlstit_kDis')
  ::o_objitem_kDis  := ::dm:has('M->objitem_kDis' )
  ::o_vyrzak_kDis   := ::dm:has('M->vyrzak_kDis'  )
  *
  ::wds_connect(self)
return self


method FIN_NAK_fakdol:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values
  local  nin, pa, finTyp, obdobi, cfile, asize

  do case
  case right(drgcombo:name,7) = 'COBDOBI'
    nin    := ascan(values, {|X| X[1] = value })
    obdobi := values[nin,3]
    cfile  := drgParse(drgcombo:name,'-')

    (cfile)->nrok    := val(substr(obdobi,2,4))
    (cfile)->nobdobi := val(substr(obdobi,6,2))

  case 'ctyppohybu' $ lower(drgcombo:name)
    nIn    := ascan(values, {|X| X[1] = value })
     pa    := listasarray(values[nin,4])
    finTyp := if( len(pa) >= 2, val(pa[2]), 0 )
    *
    if values[nin,3] <> (::hd_file)->ctypdoklad .or. .not. ::lnewrec
      (::hd_file)->ctypdoklad := values[nin,3]
      (::hd_file)->ctyppohybu := values[nin,1]
      (::hd_file)->czkrtypfak := pa[1]
      (::hd_file)->nfintyp    := finTyp
      (::hd_file)->ciszal_fak := if(finTyp = 2 .or. finTyp = 4, '1', '0')
      *
      (::hd_file)->ctask      := values[nin,5]
      (::hd_file)->csubTask   := values[nin,6]

      if lower(::it_file) = 'fakvysitw' .and. isObject(::cmb_kodPlneni)
        pa    := listAsArray(values[nIn,7])
        if len(pa) = 4
          ::cmb_kodPlneni_defval  := val(pa[4])
          ::cmb_kodPlneni:value   := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
          (::cmb_kodPlneni:isEdit := .t., ::cmb_kodPlneni:oxbp:setSize(::cmb_kodPlneni_orsize) )
          ::cmb_kodPlneni:refresh()
        else
          (::cmb_kodPlneni:isEdit := .f., ::cmb_kodPlneni:oxbp:setSize({0,0}) )
        endif

      endif

**      ::infoShow()
      ::o:showGroup()
      if(isnull(mp2),PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgCombo:oxbp),nil)
    endif

  case 'czkratmenz' $ lower(drgcombo:name)
    if drgCombo:ovar:itemChanged()
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgcombo:oxbp)
    endif

  case 'nkodplneni' $ lower(drgcombo:name)
    ::df:setNextFocus((::it_file)+ '->ncejPrZbz',,.t.)

  endcase
return self


method FIN_NAK_fakdol:infoShow()
  local  fintyp := (::hd_file)->nfintyp, groups, value
  *
  local  nwidth := ::members_inf[1]:oxbp:currentSize()[1]

  groups := if(fintyp = 1 .or. fintyp = 6, '16', if(fintyp = 2 .or. fintyp = 5, '25', '34'))

  aeval( ::members_inf, {|x| if(x:groups <> groups, x:oxbp:setSize( {nwidth, 0} ), ;
                                                    x:oxbp:setSize( {nwidth,23} )  ) } )
return


method FIN_NAK_fakdol:postAppend()
  local  cky, mainOk, finTyp, parTyp
  *
  local  filter, m_filter, cc := '', ok := .f.

  (::o:sklPol:odrg:isEdit   := .t., ::o:sklPol:odrg:oxbp:enable()  )
  *
  ** nìkdo to nutnì potøeboval
  ::dm:set('fakpriitw->cnazZbo', fakPrihdw->ctextFakt )

  * máme k dispozici položky DL pøijatého pro ncisfirmy ?? a nepoøizujeme Skladovou Faktury ??
  cky := upper(fakprihdw->culoha) +upper(fakprihdw->ctypdoklad) +upper(fakprihdw->ctyppohybu)
  c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

  if dodlstPit->(dbseek(strzero((::hd_file)->ncisfirmy,5),,'DODLIT6')) .and. empty(c_typpoh->csubpohyb)
    (::o:cisloDl:odrg:isEdit := .t., ::o:cisloDl:odrg:oxbp:enable())
  else
    (::o:cisloDl:odrg:isEdit := .f., ::o:cisloDl:odrg:oxbp:disable())
  endif

  * máme k dispozici položky objednávek vystavených pro ncisfirmy ?
  if .not. objVysit ->(dbseek(strzero((::hd_file)->ncisfirmy,5),,'OBJVYSI1'))
    (::o:cislObInt:odrg:isEdit := .f., ::o:cislObInt:odrg:oxbp:disable())
  else
    (::o:cislObInt:odrg:isEdit := .t., ::o:cislObInt:odrg:oxbp:enable())
  endif

  * máme k dispozici zálohové faktury pro ncisfirmy ?
  filter   := "ncisFirmy = %% .and. nfinTyp = %% .and. (nuhrCelFak <> nparZalFak)"
  finTyp   := fakprihdw->nfinTyp
  parTyp   := if(finTyp = 4 .or. finTyp = 6, '5', '3')

  * tady mu trohu pomùžeme, a zbyteènì nefiltruje když tam nic není
  if fakprihd_p->(dbseek(strzero((::hd_file)->ncisfirmy,5) +parTyp,,'FPRIHD14'))
    m_filter := format( filter, { (::hd_file)->ncisFirmy, val(parTyp) } )

    fakprii_w->( dbGoTop(), ;
                 dbeval( { || cc += "ncisFak <> " +str(fakprii_w->ncisZalFak) +" .and. " } , ;
                         { || fakprii_w->ncisZalFak <> 0  .and. ;
                              fakprii_w->_delRec    <> '9'.and. ;
                              fakprii_w->nsubCount  =  0        }  ))

    if( .not. empty(cc), m_filter += " .and. (" +left( cc, len(cc) -7) +")", nil )
    m_filter := "(" +m_filter + ")"

    fakprihd_p->(ads_setAof(m_filter), dbgoTop())
    ok := .not. fakprihd_p->(Eof())
    fakprihd_p->(ads_clearAof())

    * základní filtr pro nabídku  >> FIN_parprzal_cvarsym_sel <<
    ::m_sel_filter := m_filter
  else
    ok             := .f.        // jen pro sichr
    ::m_sel_filter := ''
  endif

  if .not. ok
    (::o:cisZalFak:odrg:isEdit := .f., ::o:cisZalFak:odrg:oxbp:disable())
  else
    (::o:cisZalFak:odrg:isEdit := .t., ::o:cisZalFak:odrg:oxbp:enable())
  endif

//  ::showGets(.t.)
return .t.


method FIN_NAK_fakdol:postValidate(drgVar, cmp_it)
  local  value       := drgVar:get()
  local  name        := Lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  file        := drgParse(name,'-'), m_file

  local  ok          := .T., changed := drgVAR:Changed(), subtxt, rv, cky, pky
  local  it_sel      := '...->ncislodl,...->cciszakazi,...->ccislobint,...->nciszalfak,...->csklpol'
  local  cprocdan    := ::hd_file +'->nprocdan_', nprocdan_h
  local  n_roundDph  := SysConfig('Finance:nRoundDph'), n_zaklDan, n_procDan, n_sazDan
  local  n_typvykDph := sysconfig('FINANCE:nTypVykDPH')
  local  cQ_beg, cQ_end, nQ_beg, nQ_end
  * F4
  local  nevent := mp1 := mp2 := nil

// for ALL
  local  cC, aX, lastOk := .f., x, cmp_1 := .t., filter, odrg_m

// pro HD
  local  is_onlyHd := (::it_file)->(eof())
  local  nFINTYP   := (::hd_file) ->nFINTYP, nKONSTSYMB
  local  subValid  := if( nFINTYP = 1 .or. nFINTYP = 6, 'vlde', ;
                      if( nFINTYP = 2                 , 'vldc', ;
                      if( nFINTYP = 3 .or. nFINTYP = 4 .or. nFINTYP = 5, 'vldz', '')))

  LOCAL  cUCET_UCT, cZKRTYPUHR

// pro IT
  local  nkoe        := ((::hd_file)->nkurzahmen / (::hd_file)->nmnozprep)
  local  lwatch_mnoz := .f.
  local  cfile_iv    := ''
  * it
  local  typSklCen,  mnozDzbo , cisZalFak
  local  nfaktmnoz,  nprocdph , nradVykDph, ;
         ncejprzbz,  nhodnslev, nprocslev , ncejprkbz , ncejprkdz , ncejprzdz, ;
         nisParZal                                                , ;
         ncecprzbz,  ncelkslev,             ncecprkbz , ncecprkdz , ;
                                            njeddan               , ;
                                            nvypsazdan            , ;
         ncenZakCel,                        nsazDan   , ncenZakCed


* F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

* drgEVENT_SAVE
  if( ::df:in_postValidateForm, cmp_it := .f., nil )

  do case
  case(file = ::hd_file )
    * konroly na hlavièce
    do case
    case(name = ::hd_file +'->ncisfak' )
      ok := fin_range_key('FAKPRIHD',value,,::msg)[1]

    case(name = ::hd_file +'->cdandoklad')
      if .not. empty(value) .and. empty((::hd_file)->cvarSym)
        (::hd_file)->cvarsym := left(value,15)
        ::dm:has(::hd_file +'->cvarsym'):set( left(value,15))
      endif

    case(name = ::hd_file +'->cvarsym' )
      if empty(value)
        ::msg:writeMessage('Variabilní symbol je povinný údaj ...',DRG_MSG_WARNING)
        ok := .f.
      endif

    case(name = ::hd_file +'->cucet'   )
      ok := ::FIR_firmyuc_sel()

      if ok .and. ::lnewRec
        fordRec({'fakprihd,2'})
        cc := upper(fakprihdw->cvarSym) +strZero(fakprihdw->ncisFirmy,5)
        if fakprih_ow->(dbseek(cc,,'FPRIHD2'))
          fin_info_box('Duplicitní variabilní symbol v rámci firmy ...')
        endif
        fordRec()
      endif

    case(name = ::hd_file +'->cpsc'    )
      if( changed, (::hd_file)->csidlo := c_psc->cmisto, nil )

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz')
      if changed
        C_MENY ->( DBSeek( Upper( value)))
        IF( IsMethod(self, subValid), self:&subValid(drgVar), NIL)
      endif

    case(field_name $ 'dvystfakdo,dvystfak,dsplatfak')
      if empty(value)
        ::msg:writeMessage('Datum vystavení/uzp/splatnost jsou povinné údaje ...',DRG_MSG_WARNING)
        ok := .f.
      endif

      if(ok .and. name = 'fakprihdw->dvystfak')

        * zmìna rv_dph
        if .not. vykdph_iw->(dbseek( FIN_c_vykdph_ndat_od(value),, 'VYKDPH_6' ))
           eval(drgVar:block,drgVar:value)
           fin_vykdph_cpy('fakprihdw')
        endif

        cC := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)

        * 1 - mìsíèní plátce DPH
        do case
        case n_typvykDph = 1
          if fakprihdw->cobdobiDan <> cC
            fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
          endif

        * 3 - ètvrtletní plátce DPH
        case n_typvykDph= 3
          nQ_end := val( left( fakprihdw->cobdobiDan, 2)) *n_typvykDph
          nQ_beg := nQ_end -2

          cQ_beg := strZero(nQ_beg,2) +'/' +right(fakprihdw->cobdobiDan, 2)
          cQ_end := strZero(nQ_end,2) +'/' +right(fakprihdw->cobdobiDan, 2)

          if .not. (cQ_beg <= cc .and. cQ_end >= cc)
            fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
          endif
        endcase
      endif
      *
      **
      if ok .and. name = 'fakprihdw->dvystfakdo' .and. empty(fakprihdw->dsplatFak)
        firmyFi ->(dbSeek( fakprihdw->ncisFirmy,,'FIRMYFI1'))
        if firmyFi->nsplatnDOD <> 0
          fakprihdw->dsplatFak := value +firmyFi->nsplatnDOD
          ::dm:set('fakprihdw->dsplatFak', value +firmyFi->nsplatnDOD)
        endif
      endif

    case(name = ::hd_file +'->ncenzahcel' )
      if isNumber(mp1) .and. mp1 = xbeK_RETURN
        ::df:setNextFocus( ::hd_file +'->czkratMenz',,.t.)
      endif

    case(name = ::it_file+'->czkratmenz')
      if changed
        C_MENY ->( DbSeek(Upper(value)))
        if( IsMethod(self, subValid), self:&subValid(drgVar), NIL)
      endif
  endcase

  if(ok,eval(drgVar:block,drgVar:value),nil)
  if(ok .and. IsMethod(self, subValid), self:&subValid(drgVar), NIL)

  * modifikace vykdph_iw
  if( field_name $ 'nosvoddan,nzakldan_1,nsazdan_1,nzakldan_2,nsazdan_2,nzakldan_3,nsazdan_3') .and. changed
    ::o:fin_finance_in:FIN_vykdph_mod('fakprihdw')
  endif

  * modifikace nzustpozao
  ::zustpozao()

  * pozicování položek na hlavièce
  if (nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN .and. ok)
    do case
    case( field_name = 'nkonstsymb' )
      ::df:setNextFocus((::hd_file)+ '->ccisObj',,.t.)

    case( field_name = 'ctextfakt' )
      ::df:setNextFocus((::hd_file)+ '->cucet',,.t.)

    case( field_name = 'cnazev' )
      ::df:setNextFocus((::hd_file)+ '->cnazev2',,.t.)

    endCase
  endif

**//**

**//** tato èást je spíš pro dodací list pøijatý, zatím ji tady necháme
    case(name = ::hd_file +'->ncisfirmy' .or. name = ::hd_file +'->ncisfirdoa')
      ok := if( changed, ::fin_firmy_sel(), .t.)

    case(name = ::hd_file +'->cnazev')
      if empty(value)
        ::msg:writeMessage('Název firmy je POVINNÝ údaj ...',DRG_MSG_ERROR)
        ok := .f.
      endif

    case(name = ::hd_file +'->czkratstat' .or. ;
         name = ::hd_file +'->czkratmenz' .or. ;
         name = ::hd_file +'->cbank_uct'       )

      * paráda p.Muchová v Kovaru si zavedla zahranièní firmu,
      * nenastavila úèet úhrady, implicitní maji v KÈ a holt to nezahlásilo
      *
      if( changed, ::fin_kurzit(drgvar,(::hd_file)->dvystfak), nil )

      * u fakturu pøidáme kontolu na shodu mìny úètu
      if ::hd_file = 'fakvyshdw'
        if c_bankuc->czkratMeny <> (::hd_file)->czkratmenz
          fin_info_box('Mìna bankovního úètu, neodpovídá fakturaèní mìnì ...')
        endif
      endif

    case(name = ::hd_file +'->czkrtypuhr' .and. changed)
      ::set_splatfak()

    case(name = ::hd_file +'->dvystfak' ) .or. ;
        (name = ::hd_file +'->dpovinfak') .or. ;
        (name = ::hd_file +'->dsplatfak')
      if( Empty(value), ( ok := .F., drgMsgBOX( 'DATUM je povinný údaj ...' )), NIL )

      if(ok .and. name = ::hd_file +'->dpovinfak')
        * zmìna rv_dph
        if select( 'vykdph_iw') <> 0
          if .not. vykdph_iw->(dbseek( FIN_c_vykdph_ndat_od(value),, 'VYKDPH_6' ))
//        if  year(drgVar:prevValue) <> year(value)
            eval(drgVar:block,drgVar:value)
            if(::hd_file <> 'dodlsthdw', fin_vykdph_cpy(::hd_file), nil)
          endif
        endif

        cC := StrZero( Month(value), 2) +'/' +Right( Str( Year(value), 4), 2)

        * 1 - mìsíèní plátce DPH
        do case
        case n_typvykDph = 1
          if (::hd_file)->cobdobiDan <> cC
            fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
          endif

        * 3 - ètvrtletní plátce DPH
        case n_typvykDph= 3
          nQ_end := val( left( (::hd_file)->cobdobiDan, 2)) *n_typvykDph
          nQ_beg := nQ_end -2

          cQ_beg := strZero(nQ_beg,2) +'/' +right((::hd_file)->cobdobiDan, 2)
          cQ_end := strZero(nQ_end,2) +'/' +right((::hd_file)->cobdobiDan, 2)

          if .not. (cQ_beg <= cc .and. cQ_end >= cc)
            fin_info_box('Datum (uzp) neodpovídá daòovému období dokladu ...')
          endif
        endcase
      endif

      if(ok .and. name = ::hd_file +'->dvystfak' .and. changed)
        ::set_splatfak()

      endif
**//** tato èást je spíš pro dodací list pøijatý, zatím ji tady necháme
**    endcase

  * zpracování na položce
  case(file = ::it_file .and. ::df:tabPageManager:active:tabNumber = 2)
    if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), cfile_iv := lower(ovar:get()), nil)

    it_sel := strtran(it_sel,'...',::it_file)

    nfaktmnoz     := ::dm:has(::it_file +'->nFAKTMNOZ' )  // change
    nprocDph      := ::dm:has(::it_file +'->nPROCDPH'  )  // change
    nradVykDph    := ::dm:has(::it_file +'->NRADVYKDPH')
    * 1
    ncejprzbz     := ::dm:has(::it_file +'->nCEJPRZBZ' )  // change
    nhodnslev     := ::dm:has(::it_file +'->nHODNSLEV' )
    nprocslev     := ::dm:has(::it_file +'->nPROCSLEV' )
    ncejprkbz     := ::dm:has(::it_file +'->nCEJPRKBZ' )
    ncejprkdz     := ::dm:has(::it_file +'->nCEJPRKDZ' )
    ncejprzdz     := ::dm:has(::it_file +'->nCEJPRZDZ' )
    txt_zaMJ_dan  := ::dm:has('M->txt_zaMJ_dan'        )
    * 2
    ncecprzbz     := ::dm:has(::it_file +'->nCECPRZBZ' )
    ncelkslev     := ::dm:has(::it_file +'->nCELKSLEV' )
    ncecprkbz     := ::dm:has(::it_file +'->nCECPRKBZ' )
    ncecprkdz     := ::dm:has(::it_file +'->nCECPRKDZ' )
    txt_zaPOL_dan := ::dm:has('M->txt_zaPOL_dan'       )
    *
    njeddan       := ::dm:has(::it_file +'->njeddan'   )
    nvypsazdan    := ::dm:has(::it_file +'->nvypsazdan')
    *
    ncenZakCel    := ::dm:has(::it_file +'->ncenZakCel')
    nsazDan       := ::dm:has(::it_file +'->nsazDan'   )
    nsazDan_Z     := ::dm:has(::it_file +'->nsazDan_Z' )
    ncenZakCed    := ::dm:has(::it_file +'->ncenZakCed')
    *
    nsubCount     := ::dm:has(::it_file +'->nsubCount' )

    default cmp_it to (nfaktmnoz:changed() .or. nprocdph:changed() .or. ncejprzbz:changed())
    *
    ** položka daòového dokladu má specifické vlastnosti
    if ::it_file = 'fakpriitw' .and. nsubCount:value <> 0
      do case
      case (name = ::it_file +'->ncejprzbz'  .and. changed)

        if value = 0
          ::msg:writeMessage('Cena za MJ u daòového dokladu nesmí být NULOVÁ, DD lze zrušit ...',DRG_MSG_ERROR)
          ok := .f.
        else
          n_zaklDan := value

          if n_roundDph = 0
            n_sazDan := round(round(n_zaklDan * round((nprocDph:value/(100 +nprocDph:value)),4),2), 2)
          else
            n_sazDan := mh_roundnumb(round(n_zaklDan * round((nprocDph:value/(100 +nprocDph:value)),4),2), n_roundDph)
          endif

          ncenZakCel:set(n_zaklDan -n_sazDan)
          nsazDan:set(n_sazDan)
          ncenZakCeD:set(n_zaklDan)
        endif

      case (name = ::it_file +'->ncenzakcel' .and. changed)
        ncejPrZbz:set(value +nsazDan:value)
        ncenZakCeD:set(ncejPrZbz:value)

      case (name = ::it_file +'->nsazdan'    .and. changed)
        ncejPrZbz:set(value +ncenZakCel:value)
        ncenZakCeD:set(ncejPrZbz:value)

      endcase

    else

      do case
      case(name $ it_sel .and. changed)
        ok := ::fakturovat_z_sel(drgVar:drgDialog)

      case(name = ::it_file +'->cnazzbo')
        if( empty((::hd_file)->ctextFakt), (::hd_file)->ctextFakt := value, nil )

      case(name = ::it_file +'->nfaktmnoz')
        cky := ::dm:get(::it_file +'->ccissklad') +::dm:get(::it_file +'->csklpol')
        pky := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad)
        *
        ** zmìna vazby pro DL s automatickým vyskladnìním
        if lower( ::it_file ) = 'dodlstitw'
          typdokl ->(dbseek( pky,,'TYPDOKL02'))
          lwatch_mnoz := ( .not. empty(typdokl->mmacro) .and. .not. empty(cky))
        else
          pky += upper((::hd_file)->ctyppohybu)
          c_typpoh ->(dbseek(pky,,'C_TYPPOH05'))
          lwatch_mnoz := ( .not. empty(c_typpoh->csubpohyb) .and. .not. empty(cky))
        endif

//        cky := ::dm:get(::it_file +'->ccissklad') +::dm:get(::it_file +'->csklpol')
//        pky := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad) +upper((::hd_file)->ctyppohybu)
//        c_typpoh->(dbseek(pky,,'C_TYPPOH05'))

        do case
        case( value = 0 )
          ::msg:writeMessage('Fakturové množství nesmí být NULOVÉ ...',DRG_MSG_ERROR)
          ok := .f.

        otherwise
          * fakturuji z vazbou na pohyby
//          if .not. empty(c_typpoh->csubpohyb) .or. (::it_file = 'poklitw')

          if lwatch_mnoz .or. (::it_file = 'poklitw')
            if cenzboz->(dbseek(upper(cky),,'CENIK03'))
              if upper(cenzboz->cpolcen) = 'C'

                * sestavav musím kontrolovat položky na nmnozDZbo
                if upper(cenzboz->ctypSklPol) = 'S '


                else
                  mnozDzbo  := cenzboz->nmnozDzbo +if(::o:state <> 2,(::it_file)->nfaktmnoz, 0)
                  typsklcen := lower(cenzboz->ctypsklcen)

                  if cfile_iv = 'objitem'
                    mnozDzbo := max( ::wds_cenzboz_kDis, objitem->nmnozReODB +objitem->nmnozplOdb)
                  endif

                  if value > mnozDzbo
                    ok := .not. (typsklcen = 'pru')
                    ::msg:writeMessage('Dispozièní množství je pouze [' +str(mnozDzbo) +'] ...', ;
                                        if(ok, DRG_MSG_WARNING,DRG_MSG_ERROR)                    )
                  endif
                endif
              endif
            endif
          endif
        endcase

      case(name = ::it_file +'->nprocdph')
        if c_dph->nnapocet <> 0
          cc := cprocdan +str(c_dph->nnapocet,1)
          if((nprocdan_h := DBGetVal(cc)) = 0, DBPutVal(cc,value), ok := (nprocdan_h = value))

          if( IsObject(ovar := ::dm:has(::it_file +'->nnapocet')), ovar:set(c_dph->nnapocet), nil)
        endif
        *
        if isobject(nradVykDph)
          do case
          case changed   ;  (::nazevrv(), nvypsazdan:set(0))
          case value = 0
          endcase

          drgvar:initvalue := drgvar:prevValue := drgvar:value
        endif

      case(name = ::it_file +'->nradvykdph')
        if changed
          ok := ::fin_vykdph_rv_sel()
        endif

      case(name = ::it_file +'->nhodnslev'  .and. changed)
        if nvypsazdan:value = 0
          nprocslev:set(nhodnslev:value/ncejprzbz:value *100)
        else
          nprocslev:set(nhodnslev:value/ncejprkdz:value *100)
        endif
        nprocSlev:value     := round(nprocSlev:value,2)
        nhodnSlev:initValue := nhodnSlev:prevValue := nhodnSlev:value
        nprocSlev:initValue := nprocSlev:prevValue := nprocSlev:value

      case(name = ::it_file +'->nprocslev'  .and. changed)
       if nvypsazdan:value = 0
         nhodnslev:set((ncejprzbz:value * nprocslev:value) /100)
       else
         nhodnslev:set((ncejprkdz:value * nprocslev:value) /100)
       endif
       nhodnSlev:value     := round(nhodnSlev:value,2)
       nhodnSlev:initValue := nhodnSlev:prevValue := nhodnSlev:value
       nprocSlev:initValue := nprocSlev:prevValue := nprocSlev:value

      case(name = ::it_file +'->ncejprzbz' )  ///  .and. changed)

        if ::it_file = 'fakpriitw'
          * párovaná záloha
          if(nisParZal := ::cejPrZbz_push()) <> 0
            cisZalFak := ::dm:get(::it_file +'->ncisZalFak')
            if .not. empty(cisZalFak)
              fakPrihd_p->(dbSeek(cisZalFak,,'FODBHD1'))
              x  := round(FIN_NAK_fakturovat_z_bc(8,1,'fakPriHd_p'),4)

              * no INS .and. oprava uložené položky která modifikovala zálohovku
              if ::o:state <> 2 .and. (::it_file)->_nrecor <> 0
                x += value
              endif

              if (round(value,4) > x)
                ok := .f.
                ::msg:writeMessage('POZOR, povolená záloha je pouze ' +str(x), DRG_MSG_ERROR)
              endif

              * párovaná záloha s vazbou na DD
              if ok .and. nisParZal = 2
                x      := 0
                filter := format("ncisfak = %%",{cisZalFak})
                vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop()      , ;
                            dbeval({|| ( x += vykdph_pw->nzakld_zal      , ;
                                         x += vykdph_pw->nsazba_zal  ) }), ;
                            dbclearfilter()                                )

                * chyba musí opravit RV
*                if (round(x,4) > round(value,4))
                if( nevent = drgEVENT_SAVE, nil, ::parvyzal_vykdph_in() )
*                endif

              endif
            endif
          endif
        endif
        if( changed, nvypsazdan:set(0), nil )

      * pozor blokujeme výpoèty
      case( name = ::it_file +'->ncecprkbz'  .or. name = ::it_file +'->nsazdan_z' )
        if changed
          ncecPrKdz:set(ncecPrKbz:value +nsazDan_Z:value)

          ncenZakCel:set( ncecPrKbz:value *nkoe )
          nsazDan:set(nsazDan_Z:value * nkoe)
          ncenZakCeD:set( ncenZakCel:value +nsazDan:value )

          cmp_it := .f.
        endif

      case( name = ::it_file +'->ncenzakcel' .or. name = ::it_file +'->nsazdan'   )
        if changed
          ncenZakCeD:set( ncenZakCel:value +nsazDan:value )
          cmp_it := .f.
        endif


      case(name = ::it_file +'->cnazpol6')
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
        endif
      endcase

      *  vazba na daòové doklady zùètování záloh vystavených
      ** nisParZal 1 - není DD / 2 - je DD
      if ::it_file = 'fakvysitw' .and. isObject(nisParZal := ::dm:has(::it_file +'->nisParZal'))
        cmp_1 :=  (nisParZal:value <> 2)
      endif

      *
      ** jen pro kasu
      do case
      case ::it_file = 'poklitw'

        n_zaklDan := (ncejprkdz:value * nfaktmnoz:value)
        n_procDan := nprocdph:value

        if n_roundDph = 0
          n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)
        else
          n_sazDan := mh_roundnumb(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), n_roundDph)
        endif

        njeddan:set(n_sazDan    / nfaktmnoz:value)
        ncejprkdz:set(n_zaklDan / nfaktmnoz:value)
        ncejprkbz:set(n_zaklDan / nfaktmnoz:value -n_sazDan / nfaktmnoz:value)

      otherwise
  *** 1
        if nvypsazdan:value = 0
          ncejprkbz:set(ncejprzbz:value - nhodnslev:value)

          if cmp_1
            if ::it_file <> 'poklitw'
              if( cmp_it, ncejprkdz:set(ncejprkbz:value + (ncejprkbz:value * nprocdph:value/100)), NIL )
            endif
          else
            if( cmp_it, ncejprkdz:set(ncejprkbz:value + njeddan:value), nil )
          endif
        else

          if cmp_1
            n_zaklDan := if( ::it_file = 'poklitw', ncejprkdz:value, ncejprzdz:value) -nhodnslev:value
            n_procDan := nprocdph:value

            if n_roundDph = 0
              n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)
            else
              n_sazDan := mh_roundnumb(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), n_roundDph)
            endif

            njeddan:set(n_sazDan)
            ncejprkdz:set(n_zaklDan)
            ncejprkbz:set(n_zaklDan -n_sazDan)
          else
            ncejprkdz:set(ncejprkbz:value + njeddan:value)
          endif
        endif
      endcase

      *
      * kontrola na prodejní cenu u skladových položek
      if ncejprkdz:changed()
        if .not. empty(cky := ::dm:get(::it_file +'->ccissklad') +::dm:get(::it_file +'->csklpol'))
          if cenzboz->(dbseek(upper(cky),,'CENIK03'))
            value  := ncejprkdz:value * nkoe
            subtxt := if(value = 0                 , 'nulová !'                       , ;
                      if(value < cenzboz->ncenaSzbo, 'pod hranicí ceny skladové !'    , ;
                      if(value = cenzboz->ncenaSzbo, 'shodná  s cenou skladovou !', '')))

            if .not. empty(subtxt)
              ::msg:writeMessage('POZOR, prodejní cena je ' +subtxt,DRG_MSG_WARNING)

* nevím kdo to chtìl a proè
**            ncejprkdz:prevValue := ncejprkdz:initValue := ncejprkdz:value := value
*

            endif
          endif
        endif
      endif

  *** 2
      ncecprzbz:set(ncejprkbz:value * nfaktmnoz:value)
      ncelkslev:set(nhodnslev:value * nfaktmnoz:value)
      *
      *     pokud došlo ke zmìnì nfaktMnot, nprocDph, ncejPrZbz - vypoèteme nsazDan_Z a nsazDan
      * ale pokud došlo ke zmìnì nsazDan                        - nepoèítáme
      if cmp_it  // ( nfaktmnoz:changed() .or. nprocdph:changed() .or. ncejprzbz:changed() )
         ncecPrKbz:set(ncejPrKbz:value * nfaktmnoz:value)
         ncecPrKdz:set(ncejPrKdz:value * nfaktmnoz:value)

         ncenZakCel:set(ncecPrZbz:value *nkoe )

         nsazDan_Z:set( ncecprkdz:value -ncecprzbz:value )
         nsazDan:set((ncecprkdz:value -ncecprzbz:value) * nkoe )
      endif

      if(isObject(ncenZakCed), ncenZakCed:set(ncecprkdz:value *nkoe), nil)

      txt_zaMJ_dan:set ( ncejprkdz:value - ncejprkbz:value )
//      txt_zaPOL_dan:set( ncecprkdz:value - ncecprkbz:value )
    endif
  endcase


  if(file = ::hd_file .and. ok)
    eval(drgVar:block,drgVar:value)
    drgVar:initValue := drgVar:value

    do case
    case(name = ::hd_file +'->czkrtypuhr')
      (::hd_file)->nkodzaokr := c_typuhr->nkodzaokr

    case(name = ::hd_file +'->nkurzahmen')
      if isObject( odrg_m := ::dm:has( 'M->kurZahMen'))
        odrg_m:set( (::hd_file)->nkurZahMen )
      endif
    endcase
  endif

  if( nevent = xbeP_Keyboard .and. isNumber(mp1) )
    if( mp1 = xbeK_RETURN .and. ok)
      do case
      case ::it_file = 'poklitw'
        lastOk := (name = ::it_file +'->nfaktmnoz' .or. name = ::it_file +'->ncejprkdz')

      otherwise
        if ::hd_file = 'fakvyshdw'
          if     name = ::hd_file +'->cvnban_uct' .and. ::o:onTabNum = 1
            ::df:setnextfocus(::hd_file +'->ncisfirdoa',,.t.)

**          elseif name = ::hd_file +'->cjmenovys' .and. ::o:onTabNum = 1
**            ::df:tabPageManager:toFront(4)

          endif
        else
          lastOk := (name = ::it_file +'->cnazpol6' )
        endif
      endcase
    endif

    if( lastOk, (_clearEventLoop(.t.), ::o:postLastField()), nil)
  endif

  * rv
  if isobject(subtxt := ::dm:has('vykdph_iw->combotext'))
    rv  := ::dm:get(::it_file +'->nradvykdph')
    vykdph_iw->(dbseek(rv,,'VYKDPH_5'))
    subtxt:set(vykdph_iw->comboText)
  endif
RETURN ok

*
** SEL METHOD ******************************************************************
method FIN_NAK_fakdol:fin_firmy_sel(drgDialog)
  local  odialog, nexit, finTyp := (::hd_file)->nfintyp, zkrTypUhr, ucet_uct, konstSymb, cKy
  local  vypSazDan := (::hd_file)->cvypsazdan
  *
  local  drgVar, value, ok, name, splatn := sysConfig('FINANCE:nSPLATNOST'), npos
  local  in_firmyDA := .f., odrg
  *
  local  nEvent := mp1 := mp2 := oXbp := nil
  *
  local  sel_ky := upper(padr('fir_firmy_sel',50))      + ;
                   upper(padr('firmy', 10))             + ;
                   upper(padr(name, 22))

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  drgVar := oXbp:cargo:ovar
   value := drgVar:value
    name := lower(drgVar:name)

      ok := (empty(value) .or. firmy->(::o:drgDialog:sel_dbseek( sel_ky, value,,'FIRMY1')))
//      ok := (empty(value) .or. firmy->(dbseek(value,,'FIRMY1')))

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::o:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if nexit != drgEVENT_QUIT .or. ok
    ok := .t.
    if(select('firmyda') = 0, drgDBMS:open('firmyda'), nil)

    if name = ::hd_file +'->ncisfirdoa'
      if firmyDA->(dbseek(firmy->ncisFirmy,,'FIRMYDA3'))
        mh_copyfld('firmyda', ::hd_file,,.f.)
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy

        firmy->(dbseek(firmyDA->ncisFirmy,,'FIRMY1'))
      else
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy->cnazev
        (::hd_file)->cnazevDOA2 := firmy->cnazev2
        (::hd_file)->culiceDOA  := firmy->culice
        (::hd_file)->cpscDOA    := firmy->cpsc
        (::hd_file)->csidloDOA  := firmy->csidlo
      endif
    else
      if firmyDA->(dbseek(firmy->ncisFirmy,,'FIRMYDA1'))
        mh_copyfld('firmyda', ::hd_file,,.f.)
      else
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy->cnazev
        (::hd_file)->cnazevDOA2 := firmy->cnazev2
        (::hd_file)->culiceDOA  := firmy->culice
        (::hd_file)->cpscDOA    := firmy->cpsc
        (::hd_file)->csidloDOA  := firmy->csidlo
      endif
    endif

    mh_copyfld('firmy',::hd_file,, .f.)
    (::hd_file)->cvypsazdan := vypSazDan
    (::hd_file)->dsplatfak  := (::hd_file)->dvystfak +splatn

    if name = ::hd_file +'->ncisfirdoa'
      if firmyfi->(dbseek(value,,'FIRMYFI1'))
        in_firmyDA   := .t.
        zkrTypUhr    := if(finTyp = 5, (::hd_file)->czkrtypuhr, firmyfi->czkrtypuod)
        ::splatn_ffi := firmyfi->nsplatnost
      endif
    endif

    if firmyfi->(dbseek(firmy->ncisfirmy,,'FIRMYFI1'))
      konstSymb    := (::hd_file)->nkonstsymb

      if .not. in_firmyDA
        zkrTypUhr    := if(finTyp = 5, (::hd_file)->czkrtypuhr, firmyfi->czkrtypuod)
        ::splatn_ffi := firmyfi->nsplatnost
      endif

      mh_copyfld('firmyfi',::hd_file,, .f.)

      (::hd_file)->nkonstsymb := konstSymb
      if( .not. empty(zkrTypUhr), (::hd_file)->czkrtypuhr := zkrTypUhr, nil)
      (::hd_file)->czkrzpudop := firmyfi->czkrzpudod
      (::hd_file)->cucet_uct  := if(finTyp = 2 .or. finTyp = 4, firmyfi->cuct_fvz, firmyfi->cuct_odb)

      c_staty->(dbseek(upper((::hd_file)->czkratstat),,'C_STATY1'))
      c_meny->(dbseek(upper(c_staty->czkratmeny,,'C_MENY1')))

      *
      ** na firmyfi mùže být pøednastavný úèet úhrady cbank_ucod
      if .not. empty( firmyfi->cbank_ucod)
        c_bankuc->( dbSeek(upper(firmyfi->cbank_ucod),,'BANKUC1'))
        (::hd_file)->cbank_uct := firmyfi->cbank_ucod

        if isObject( odrg := ::dm:has(::hd_file +'->cbank_uct'))
          odrg:value     := firmyfi->cbank_ucod
          odrg:prevValue := ''
          ::fin_kurzit( odrg, (::hd_file)->dvystfak)
        endif
      *
      elseif ((::hd_file)->nkurzahmen +(::hd_file)->nmnozprep = 0 .or. ;
         empty((::hd_file)->czkratmenz)                       .or. ;
         (c_meny->czkratmeny <> (::hd_file)->czkratmenz)           )

         kurzit->(mh_seek(upper(c_meny->czkratmeny),2,,.t.))

         kurzit->( AdsSetOrder(2), dbsetScope(SCOPE_BOTH, UPPER(c_meny->czkratMeny)))
         cKy := upper(c_meny->czkratMeny) +dtos((::hd_file)->dvystFak)
         kurzit->(dbSeek(cKy, .T.))
         If( kurzit->nkurzStred = 0, kurzit->(dbgoBottom()), NIL )

         (::hd_file)->czkratmenz := c_meny->czkratmeny
         (::hd_file)->nkurzahmen := kurzit->nkurzstred
         (::hd_file)->nmnozprep  := kurzit->nmnozprep

         kurzit->(dbclearScope())
       endif
    endif

    * pokud zmìnil firmu, opravíme vazbu na položkách
    npos := (::it_file)->(fieldPos('cnazev'))
    (::it_file)->(dbgoTop()  , ;
                  dbeval({||   ;
                  (               (::it_file)->ncisFirmy := firmy->ncisFirmy, ;
                   if( npos <> 0, (::it_file)->cnazev    := firmy->cnazev   , nil) ) }), ;
                  dbgoTop()    )

    *
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->ncisfirmy

    ::o:fin_finance_in:refresh(drgVar)
    ::o:drgDialog:dataManager:refresh()

    if( ::it_file = 'dodlstitw', nil, ::set_splatfak())

    ::o:df:setNextFocus(::hd_file +'->czkrtypuhr',,.t.)
  endif
return ok


* nprocDph
method FIN_NAK_fakdol:nazevrv()
  local cky
  local rv      := ::dm:has(::it_file +'->nradvykdph')
  local pdp     := ::dm:has(::it_file +'->lpreDanPov')
  local cuc_dph := ::dm:has(::it_file +'->cucetu_Dph')
  *
  local duzp    := (::hd_file)->dvystFak

  if ::it_file = 'fakpriitw' .and. isobject(rv) .and. isobject(pdp) .and. isObject(cuc_dph)

    cky := strZero(c_dph->nnapocet,1) +'1'

    if .not. vykdph_iw->(dbseek( cky,,'VYKDPH_4'))
      vykdph_iw->(dbseek( left(cky,1),,'VYKDPH_4'))
    endif

*    if vykdph_iw->(dbseek( cky,,'VYKDPH_4'))
      rv:set(      vykdph_iw->nradek_Dph)
      pdp:set(     vykdph_iw->lpreDanPov)
      cuc_dph:set( vykdph_iw->cucetu_Dph)

      if vykdph_iw->lpreDanPov
        ( pdp:oDrg:isEdit := .t., pdp:oDrg:oxbp:enable() )
      else
        ( pdp:oDrg:isEdit := .f., pdp:oDrg:oxbp:disable())
      endif
*    endif
  endif
return nil


* nradVykPdh
method FIN_NAK_fakdol:fin_vykdph_rv_sel(drgDialog)
  local  odialog, nexit, finTyp := (::hd_file)->nfintyp, filter
  *
  local  procDph := ::dm:has(::it_file +'->nprocdph'  ):value
  local  drgVar  := ::dm:has(::it_file +'->nradvykdph')
  local  cuc_dph := ::dm:has(::it_file +'->cucetu_Dph')
  local  value   := drgVar:value
  local  ok

*  do 1.1.2011
  local  dat_od  := FIN_c_vykdph_ndat_od( (::hd_file)->dvystFak)  // povinFak )

  c_dph->(dbseek(nprocDph,,'C_DPH2'))

  filter := format("ntyp_dph = %%", {c_dph->nnapocet} )
  vykdph_iw->(dbsetfilter(COMPILE(filter)),dbgotop())

  ok := vykdph_iw->(dbseek(value,,'VYKDPH_5'))

  if isobject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'fin_vykdph_rv_sel' PARENT ::o:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if nexit != drgEVENT_QUIT .or. ok
    ok := .t.
    drgvar:set(vykdph_iw->nradek_dph)
    drgvar:initValue := drgvar:prevValue := vykdph_iw->nradek_dph
    *
    ** nkodPlneni, cucetu_Dph, lpreDanPov, ctypPreDan
    if lower(::it_file) = 'fakpriitw'
      if isObject(::cmb_kodPlneni)
        if ::cmb_kodPlneni:isEdit
          ::cmb_kodPlneni_defval  := vykdph_iw->nkodPlneni
          ::cmb_kodPlneni:value   := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
          ::cmb_kodPlneni:refresh()
        endif

        if isObject(cuc_dph)
          cuc_dph:set( vykdph_iw->cucetu_Dph)
        endif
      endif

      if isObject(::chb_preDanPov)
        ::chb_preDanPov:refresh( vykdph_iw->lpreDanPov )
        if vykdph_iw->lpreDanPov
          ( ::chb_preDanPov:isEdit := .t., ::chb_preDanPov:oxbp:enable() )
        else
          ( ::chb_preDanPov:isEdit := .f., ::chb_preDanPov:oxbp:disable())
        endif
      endif
      *
      ** ctypPreDan se edituje pouze pro nradVykDPH = 10 a 11, jinak není ani viditelný
      if isObject(::cmb_typPreDan)
        ::cmb_typPreDan:isEdit := (vykdph_iw->nradek_dph = 10 .or. vykdph_iw->nradek_dph = 11)

        if( ::cmb_typPreDan:isEdit, ::cmb_typPreDan:oxbp:enable(), nil )
        if( ::cmb_typPreDan:isEdit, ::cmb_typPreDan:oxbp:show()  , ::cmb_typPreDan:oxbp:hide() )
      endif
    endif

    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
  vykdph_iw->(dbclearfilter(),dbgotop())
return ok


method FIN_NAK_fakdol:parvyzal_vykdph_in(drgDialog)
  local  oDialog, nExit
  local  cisFak := ::dm:get(::it_file +'->nciszalfak')
  local  parFak := ::dm:get(::it_file +'->ncejPrZBZ' )
  local  koeZ   := (::hd_file)->nkurzahmen/(::hd_file)->nmnozprep
  *
  local  filter := format("ncisfak = %%",{cisFak})

  vykdph_pw->(dbSetfilter(COMPILE(filter)), dbgotop())

  oDialog := drgDialog():new('FIN_parzalfak_vykdph_IN',::o:drgDialog)
  oDialog:cargo_usr := parFak
  oDialog:create(,::o:drgDialog:dialog,.F.)

*  musíme naplnit, parprzalw->nparZalFak i parprzalw->nparZahFak
*  v podstatì je jedno kterou edituje, ale naplnit se musí po návratu z RV obì

  ::dm:set( 'fakvysitw->nparZalFak', oDialog:udcp:uplatneno + oDialog:udcp:uplatneno_zFA )
  ::dm:set( 'fakvysitw->nparZahFak', oDialog:udcp:uplat_v_cm                             )

  ::dm:set('fakvysitw->ncejPrZbz', ;
           if( ::isTuz, oDialog:udcp:uplatneno + oDialog:udcp:uplatneno_zFA , ;
                        oDialog:udcp:uplat_v_cm                               ) )

  vykdph_pw->(dbclearfilter(), dbgotop())
  oDialog:destroy(.T.)
  oDialog := NIL
return self


method FIN_NAK_fakdol:postValidateForm(m_file)
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
** vysvítíme položku GETu pro cfile_iv
method FIN_NAK_fakdol:showGets(inAppend,vld_ok)
  local oxbp, odrg
  local file_iv, po_Gets := ::po_Gets, pa, pos

  default inAppend to .f., vld_ok to .f.

  *
  file_iv := if(inAppend, '', ::dm:get(::it_file +'->cfile_iv'))
      pos := if(file_iv = 'cenzboz' , 1, ;
              if(file_iv = 'dodlstit', 2, ;
               if(file_iv = 'objitem' , 3, ;
                if(file_iv = 'vyrzakit', 4, ;
                 if(file_iv = 'fakvysitzw', 5, 0)))))


  for x := 1 to len(po_Gets) step 1
    if isObject(po_Gets[x])
      odrg  := po_Gets[x]:odrg
      oxbp  := odrg:oxbp
      if isMemberVar(odrg,'cargoGet')
        if isnull(odrg:cargoGet)
          odrg:cargoGet := {oxbp:setFont(),oxbp:setColorBG(),oxbp:setColorFG()}
        endif

        pa := odrg:cargoGet
        oxbp:setFont(pa[1])
        oxbp:setColorFG(pa[3])
      endif

      if( vld_ok .and. pos <> x, (odrg:isEdit := .f., oxbp:disable()), nil)
    endif
  next

  if pos <> 0 .and. isObject(po_Gets[pos]) .and. .not. inAppend
    oxbp  := po_Gets[pos]:odrg:oxbp
    oxbp:enable()
    oxbp:setFont(drgPP:getFont(5))
    oxbp:setColorFG(GRA_CLR_BLUE)
  endif

  ::cejPrZbz_push()
return self