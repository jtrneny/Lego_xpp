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


*
** CLASS FIN_PRO_fakdol ********************************************************
CLASS  FIN_PRO_fakdol FROM WDS
exported:
  var     cmb_typPoh, cmb_kodPlneni, cmb_kodPlneni_orsize, cmb_kodPlneni_defval
  var                 cmb_typPreDan, get_procDPHpp
  var     lnewrec, hd_file, it_file
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
  var     o_cenzboz_kDis, o_dodlstit_kDis, o_objitem_kDis, o_vyrzak_kDis
  *
  var     mnozZdok
  var     m_sel_filter
  *
  var     splatn_cfg, splatn_ffi

  method  init
  method  infoShow, comboItemSelected, postAppend, postValidate
  method  fin_firmy_sel, fin_vykdph_rv_sel
  method  parvyzal_vykdph_in
  method  showGets

  * ctypPREdan a nprodDPHpp se edituje pouze pro nradVykDPH = 25, jinak není ani viditelný
  inline method typPreDan(nradek_Dph)
    default nradek_Dph to 0

    if lower(::it_file) = 'fakvysitw' .and. isObject(::cmb_typPreDan) .and. isObject(::get_procDPHpp)
      if nradek_dph = 25
        ::cmb_typPreDan:oxbp:enable()
        ::get_procDPHpp:oxbp:enable()

        (::cmb_typPreDan:isEdit := .t., ::cmb_typPreDan:oxbp:show() )
        (::get_procDPHpp:isEdit := .t., ::get_procDPHpp:oxbp:show() )
        ::get_procDPHpp:pushGet:oxbp:show()
      else
        (::cmb_typPreDan:isEdit := .f., ::cmb_typPreDan:oxbp:hide() )
        (::get_procDPHpp:isEdit := .f., ::get_procDPHpp:oxbp:hide() )
        ::get_procDPHpp:pushGet:oxbp:hide()
      endif
    endif
    return

  * jen pro fakvysitw je možno editovat ctypPREdan a nprocDPHpp
  inline method overPostAppend()
    if lower(::it_file) = 'fakvysitw'
      ::enable_or_disable_items(0,2)
      ::typPreDan()
    endif
    return .t.

  inline method enable_or_disable_items(subCount,state)
    local  x, ok := .t., vars := ::dm:vars, drgVar
    local  lpreDanPov

    default subCount to (::it_file)->nsubCount, ;
            state    to 0

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      if isblock(drgVar:block)
        in_file := lower( left( drgVar:name, at( '-', drgVar:name)  -1))
        if ( in_file = ::it_file .and. isMemberVar(drgVar:odrg, 'isEdit_org'))
          if( isNull(drgVar:odrg:isEdit_org), drgVar:odrg:isEdit_org := drgVar:odrg:isEdit, NIL )

          if subCount <> 0
            ( drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )
          else
            drgVar:odrg:isEdit := drgVar:odrg:isEdit_org
            if( drgVar:odrg:isEdit, drgVar:odrg:oxbp:enable(), drgVar:odrg:oxbp:disable() )
          endif
        endif
      endif
    next

    /*
    * blokujem lpreDanPov pro INS automaticky DISABLE
    vykdph_iw->( dbseek( (::it_file)->nradVykDph,,'VYKDPH_5'))
    lpreDanPov := if( state = 2, .f., vykdph_iw->lpreDanPov)

    if isObject(::chb_preDanPov)
      if lpreDanPov
        ( ::chb_preDanPov:isEdit := .t., ::chb_preDanPov:oxbp:enable() )
      else
        ( ::chb_preDanPov:isEdit := .f., ::chb_preDanPov:oxbp:disable())
      endif
    endif
    */
    return self


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

      if(lok :=  dodlstit->(dbseek(cky,,'DODLIT5')))
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

      if(lok := objitem ->(dbseek(cky,,'OBJITEM2')))
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

  **
  inline method tabSelect(oTabPage,tabnum)
    local ok := .t., oVar

    if ::hd_file = 'fakvyshdw'
      do case
      case(otabPage:tabNumber = 4)   // 1 -> 4
*        ok := ::postValidateForm(::hd_file)
*        if(ok, (::o:brow:refreshAll(), ::setfocus()), nil)
        if isObject(::cmb_kodPlneni)
          oVar  := ::cmb_kodPlneni:ovar
          ::cmb_kodPlneni:refresh(fakvysitw->nkodPlneni)

          oVar:initValue := oVar:prevValue := oVar:value := fakvysitw->nkodPlneni
        endif
        ::setfocus( if( (::it_file)->(eof()), 2, 0))
        ::dm:refresh()

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
**      if lower((::it_file)->cfile_iv) = 'cenzboz' .and. ::isSest = MIS_BOOKOPEN
      *
      ** HYDRAP - fakturují sestavy ctypSklPol = S - najeli na objednávky pøijaté
      if ::isSest = MIS_BOOKOPEN
        ** tady zavoláme pohled na kusov
        ::fin_cenzboz_ses()
      endif
      return .t.

    case(nevent = xbeBRW_ItemMarked)
      rowPos := if( isArray(mp1), mp1[1], mp1 )

      ::o:brow:hilite()
      ::o:msg:WriteMessage(,0)
      ::o:state := 0

      ::typPreDan( (::it_file)->nradVykDph )

      if rowPos = ::o:brow:rowPos
        if ::o:state <> 2
                                   (::sklPol:odrg:isEdit    := .F., ::sklPol:odrg:oxbp:disable()         )
          if(isobject(::cisloDl),  (::cisloDl:odrg:isEdit   := .F., ::cisloDl:odrg:oxbp:disable())  , nil)
                                   (::cislObInt:odrg:isEdit := .F., ::cislObInt:odrg:oxbp:disable()      )
                                   (::cisZakazi:odrg:isEdit := .F., ::cisZakazi:odrg:oxbp:disable()      )
          if(isobject(::cisZalFak),(::cisZalFak:odrg:isEdit := .F., ::cisZalFak:odrg:oxbp:disable()), nil)


// JS        ::showGets()
        endif

        if(ismethod(self, 'postItemMarked'), ::postItemMarked(), Nil)
        ::restColor()
      endif

      return .f.

    case(nevent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT)
      ::o:restColor()
      do case
      case(file_name = ::hd_file)  ;  saveOk := if((::it_file)->(eof()),-1,2)
      otherwise                    ;  if lower(::df:olastDrg:className()) $ 'drgbrowse,drgdbrowse'
                                        saveOk := if((::it_file)->(eof()),-1,2)
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
**                                if( .not. ::o:new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
                                return .t.
                              endif
                            endif
      elseif saveOk = -1
        drgMsg(drgNLS:msg('Doklad nemá položky -nelze uložit- omlouvám se ...'),,::dm:drgDialog)
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
    local  o_dialog   := ::dm:drgDialog:dialog

    if isObject(::o_cejPrZbz) .and. isObject(o_isParZal)
      nisParZal := o_isParZal:value
      o_push    := ::o_cejPrZbz:odrg:pushGet

      do case
      case(nisParZal = 0)  ;  o_push:event := 'fin_cmdph'
      case(nisParZal = 1)  ;  o_push:event := 'null'
                              ok           := .f.
      case(nisParZal = 2)  ;  o_push:event := 'parvyzal_vykdph_in'
      endcase

      if( ok, (o_push:oxbp:show(), o_push:enable() ), ;
              (o_push:oxbp:hide(), o_push:disable())  )

    endif
  return nisParZal   // isBlocked

  inline method post_drgEvent_Refresh()
    ::cejPrZbz_push()
  return

  inline access assign method isTuz() var isTuz
    return Equal(SysConfig('Finance:cZaklMena'), fakvyshdw->czkratMenz)


  inline method fin_cenzboz_ses()
    local  odialog, nexit := drgEVENT_QUIT

    DRGDIALOG FORM 'FIN_cenzboz_SEST' PARENT ::o:drgDialog MODAL DESTROY EXITSTATE nExit
  return

hidden:
  var     o, dm, df, msg, members_inf
*  var     splatn_cfg, splatn_ffi

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

      (::hd_file)->dsplatfak  := splatFak

      if (::hd_file)->( FieldPos('npokladEet')) <> 0
        (::hd_file)->npokladEet := c_typuhr->npokladEet
      endif
      ovar:set(splatFak)
    endif
  return
ENDCLASS


method FIN_PRO_fakdol:init(parent)
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


method FIN_PRO_fakdol:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values
  local  nin, pa, finTyp, obdobi, cfile, asize
  *
  local  duzp, cradDph


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
           duzp := (::hd_file)->dpovinfak
        cradDph := FIN_c_vykdph_cradDph( duzp, ::hd_file )
             pa := listAsArray( cradDph )

**        pa    := listAsArray(values[nIn,7])

        if len(pa) = 4
          ::cmb_kodPlneni_defval  := val(pa[4])
          ::cmb_kodPlneni:value   := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
          (::cmb_kodPlneni:isEdit := .t., ::cmb_kodPlneni:oxbp:setSize(::cmb_kodPlneni_orsize) )
          ::cmb_kodPlneni:refresh()
        else
          ::cmb_kodPlneni_defval  := 0
          ::cmb_kodPlneni:value   := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
          (::cmb_kodPlneni:isEdit := .f., ::cmb_kodPlneni:oxbp:setSize({0,0}) )
        endif

      endif

      * jen pro jistotu, 8 - parametr je cvypSAZdan
      if len(values[nin]) = 8
        if( .not. empty(values[nin,8]), (::hd_file)->cvypSAZdan := values[nin,8], nil )
      endif

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


method FIN_PRO_fakdol:infoShow()
  local  fintyp := (::hd_file)->nfintyp, groups, value
  *
  local  nwidth := ::members_inf[1]:oxbp:currentSize()[1]

  groups := if(fintyp = 1 .or. fintyp = 6, '16', if(fintyp = 2 .or. fintyp = 5, '25', '34'))

  aeval( ::members_inf, {|x| if(x:groups <> groups, x:oxbp:setSize( {nwidth, 0} ), ;
                                                    x:oxbp:setSize( {nwidth,23} )  ) } )
return


method FIN_PRO_fakdol:postAppend()
  local  cky, mainOk, finTyp, parTyp
  *
  local  filter, m_filter, cc := '', ok := .f.

  (::o:sklPol:odrg:isEdit   := .t., ::o:sklPol:odrg:oxbp:enable()  )

  * poøizujeme registraèní pokladnu
  if ::it_file = 'poklitw'
    ::o:cisSklad:set(::o:selSklad)
    ::o:cisSklad:initValue := ::o:cisSklad:prevValue := ::o:selSklad

  else
    * máme k dispozici položky DL pro ncisfirmy ?? a nepoøizujeme Skladovou Faktury ??
    if ::it_file = 'fakvysitw'

      cky := upper(fakvyshdw->culoha) +upper(fakvyshdw->ctypdoklad) +upper(fakvyshdw->ctyppohybu)
      c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

      if dodlstit->(dbseek(strzero((::hd_file)->ncisfirmy,5),,'DODLIT6')) .and. empty(c_typpoh->csubpohyb)
        (::o:cisloDl:odrg:isEdit := .t., ::o:cisloDl:odrg:oxbp:enable())
      else
        (::o:cisloDl:odrg:isEdit := .f., ::o:cisloDl:odrg:oxbp:disable())
      endif
    endif

    * máme k dispozici položky objednávek pro ncisfirmy ?
    if .not. objitem ->(dbseek(strzero((::hd_file)->ncisfirDOA,5),,'OBJITEM0'))
      (::o:cislObInt:odrg:isEdit := .f., ::o:cislObInt:odrg:oxbp:disable())
    else
      (::o:cislObInt:odrg:isEdit := .t., ::o:cislObInt:odrg:oxbp:enable())
    endif

    * máme k dispozici výrobní zakázky pro ncisfirmy ?
    if .not. vyrzak ->(dbseek(strzero((::hd_file)->ncisfirmy,5),,'VYRZAK4'))
      (::o:cisZakazi:odrg:isEdit := .f., ::o:cisZakazi:odrg:oxbp:disable())
    else
      (::o:cisZakazi:odrg:isEdit := .t., ::o:cisZakazi:odrg:oxbp:enable())
    endif

    * máme k dispozici zálohové faktury pro ncisfirmy ?
    if ::it_file = 'fakvysitw'
      filter   := "strzero(ncisFirmy,5) = '%%' .and. strZero(nfinTyp,1) = '%%' .and. (nuhrCelFak <> nparZalFak)"
      finTyp   := fakvyshdw->nfinTyp
      parTyp   := if(finTyp = 1, '2', '4')

      * tady mu trohu pomùžeme, a zbyteènì nefiltruje když tam nic cení

      if fakvyshd_p->(dbseek(strzero((::hd_file)->ncisfirmy,5) +parTyp,,'FODBHD16'))

        m_filter := format( filter, { strZero((::hd_file)->ncisFirmy,5),parTyp } )
        fakvysi_w->( dbGoTop(), ;
                     dbeval( { || cc += "ncisFak <> " +str( fakvysi_w->ncisZalFak) +" .and. " } , ;
                             { || fakvysi_w->ncisZalFak <> 0 .and. ;
                                  fakvysi_w->_delRec    <> '9'     }  ))

        if( .not. empty(cc), m_filter += " .and. (" +left( cc, len(cc) -7) +")", nil )

        fakvyshd_p->(ads_setAof(m_filter), dbgoTop())
        ok := .not. fakvyshd_p->(Eof())
        fakvyshd_p->(ads_clearAof())

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
    endif

    * je to EU faktura a je povolena editace nkodPlneni
    if ::it_file = 'fakvysitw' .and. isObject(::cmb_kodPlneni)
      if ::cmb_kodPlneni:isEdit
        * musíme nastavit startovací hodnotu *
        ::cmb_kodPlneni:value := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
        ::cmb_kodPlneni:refresh()
      endif
    endif

    * bez ohledu na typFak vždy pøedanstvit pro 0% DPH
    if ::it_file = 'fakvysitw'
      ::nazevrv()

      * není to penalizaèní faktura ?
      if fakvyshdw->nfinTyp <> 5

        * nový parametr FIN_fakvys 2 - urèuje kam se postavit po INS, pokud to jde
        * pokud ano                3 - urèuje zda ihned otevøít SEl dialog
        if isMemberVar(::o, 'itemForIns')
          if ::o:dm:get( ::o:itemForIns, .f. ):odrg:isEdit
            ::o:one_edt := ::o:itemForIns

            if ::o:itemSelIns = 'sel'
              postAppEvent(xbeP_Keyboard, xbeK_F4,, ::o:dm:has(::o:itemForIns):oDrg:oXbp )
            endif
          endif
        endif
      endif
    endif

    ::showGets(.t.)
    ::typPreDan()
  endif
return .t.


method FIN_PRO_fakdol:postValidate(drgVar)
  local  value       := drgVar:get()
  local  name        := Lower(drgVar:name)
  local  file        := drgParse(name,'-'), m_file
  local  ok          := .T., changed := drgVAR:Changed(), subtxt, rv, cky, pky
  local  it_sel      := '...->ncislodl,...->cciszakazi,...->ccislobint,...->nciszalfak,...->csklpol'
  local  cprocdan    := ::hd_file +'->nprocdan_', nprocdan_h
  local  n_roundDph  := SysConfig('Finance:nRoundDph'), n_zaklDan, c_sazDan, n_procDan, n_sazDan, n_procSlev
  local  n_typvykDph := sysconfig('FINANCE:nTypVykDPH')
  local  cQ_beg, cQ_end, nQ_beg, nQ_end
  * F4
  local  nevent := mp1 := mp2 := nil

// for ALL
  LOCAL  cC, aX, lastOk := .f., x, cmp_1 := .t., filter, odrg_m

// pro HD
  LOCAL  nFINTYP := (::hd_file) ->nFINTYP, nKONSTSYMB
  LOCAL  cUCET_UCT, cZKRTYPUHR

// pro IT
  local  nkoe        := ((::hd_file)->nkurzahmen / (::hd_file)->nmnozprep)
  local  lwatch_mnoz := .f.
  local  cfile_iv    := ''
  * it
  local  typSklCen,  mnozDzbo , cisZalFak
  local  nkoefMn  ,  nfaktMnKoe
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

  do case
  case(file = ::hd_file )
    * konroly na hlavièce
    do case
    CASE(name = ::hd_file +'->ncisfak')
       m_file := upper(left(::hd_file, len(::hd_file)-1))
       (aX := fin_range_key(m_file,value,,::msg), ok := aX[1])

       if ok
         (::hd_file)->cdanDoklad := alltrim(str(value))
         *
         ** na poklhd není get.cdanDoklad
         if isObject( ::dm:has(::hd_file +'->cdanDoklad'))
           ::dm:has(::hd_file +'->cdanDoklad'):set(alltrim(str(value)))
         endif
       endif

       if( ok .and. ::lVSYMBOL)
         (::hd_file)->cvarsym := alltrim(str(value))
         *
         ** na poklhd není get.cvarSym
         if isObject( ::dm:has(::hd_file +'->cvarsym'))
           ::dm:has(::hd_file +'->cvarsym'):set(alltrim(str(value)))
         endif
       endif

    case(name = ::hd_file +'->ncisfirmy' .or. name = ::hd_file +'->ncisfirdoa')
      *
      ** paramert z pro_poklhd_in ovlivní povinnost ncisFirmy
      if( name = ::hd_file +'->ncisfirmy' .and. ::hd_file = 'poklhdw' .and. empty(value) )
        changed := ( ::o:on_firmySel = '1')
      endif

      ok := if( changed, ::fin_firmy_sel(), .t.)

      if( ok .and. ::hd_file = 'poklhdw' )
        ::o:one_edt := ::it_file +'->csklPol'
        ::o:df:setNextFocus(::it_file +'->csklPol',,.t.)
      endif

    case(name = ::hd_file +'->cnazev')
      if empty(value)
        ::msg:writeMessage('Název firmy je POVINNÝ údaj ...',DRG_MSG_ERROR)
        ok := .f.
      endif

    case(name = ::hd_file +'->cpsc' .and. changed)
      (::hd_file)->csidlo := c_psc->cmisto

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
    endcase

  * zpracování na položce
  case(file = ::it_file )
    if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), cfile_iv := allTrim(lower(ovar:get())), nil)

    it_sel := strtran(it_sel,'...',::it_file)

    nfaktmnoz  := ::dm:has(::it_file +'->nFAKTMNOZ' )
    nprocdph   := ::dm:has(::it_file +'->nPROCDPH'  )
    nradVykDph := ::dm:has(::it_file +'->NRADVYKDPH')
    * 1
    ncejprzbz  := ::dm:has(::it_file +'->nCEJPRZBZ' )
    nhodnslev  := ::dm:has(::it_file +'->nHODNSLEV' )
    nprocslev  := ::dm:has(::it_file +'->nPROCSLEV' )
    ncejprkbz  := ::dm:has(::it_file +'->nCEJPRKBZ' )
    ncejprkdz  := ::dm:has(::it_file +'->nCEJPRKDZ' )
    ncejprzdz  := ::dm:has(::it_file +'->nCEJPRZDZ' )
    * 2
    ncecprzbz  := ::dm:has(::it_file +'->nCECPRZBZ' )
    ncelkslev  := ::dm:has(::it_file +'->nCELKSLEV' )
    ncecprkbz  := ::dm:has(::it_file +'->nCECPRKBZ' )
    ncecprkdz  := ::dm:has(::it_file +'->nCECPRKDZ' )
    *
    njeddan    := ::dm:has(::it_file +'->njeddan'   )
    nvypsazdan := ::dm:has(::it_file +'->nvypsazdan')
    *
    ncenZakCel := ::dm:has(::it_file +'->ncenZakCel')
    nsazDan    := ::dm:has(::it_file +'->nsazDan'   )
    ncenZakCed := ::dm:has(::it_file +'->ncenZakCed')

    if( ::it_file = 'poklitw',  nfaktMnKoe := ::dm:has(::it_file +'->nfaktMnKoe' ), nil )

    *
    ** penalizaèní faktura je bohužel jinak
    if ::it_file = 'fakvysitw' .and. nfinTyp = 5
      do case
      case(name $ it_sel .and. changed)
        ok := ::fakturovat_z_sel(drgVar:drgDialog)

      endcase

      if (name = ::it_file +'->npen_odb')
       ncejprkbz:set(::dm:get( ::it_file +'->ncenpencel') * (value / 100) )
      else
        ncejprkbz:set(::dm:get( ::it_file +'->ncenpencel') * ;
                     (::dm:get( ::it_file +'->npen_odb'  ) / 100) )
      endif

      ncecprkbz:set(::dm:get(::it_file +'->nfaktMnoz'  ) * ncejprkbz:value )

    else

      do case
      case(name $ it_sel .and. changed)
        ok := ::fakturovat_z_sel(drgVar:drgDialog)

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
          if lwatch_mnoz .or. (::it_file = 'poklitw')
            if cenzboz->(dbseek(upper(cky),,'CENIK03'))
              if upper(cenzboz->cpolcen) = 'C'

                * sestavav musím kontrolovat položky na nmnozDZbo
                if upper(cenzboz->ctypSklPol) = 'S '


                else
                  mnozDzbo  := cenzboz->nmnozDzbo +if(::o:state <> 2,(::it_file)->nfaktmnoz, 0)
                  typsklcen := lower(cenzboz->ctypsklcen)

                  if cfile_iv = 'objitem'
                    mnozDzbo := max( ::wds_cenzboz_kDis +if(::o:state <> 2, nfaktmnoz:prevValue, 0), ;
                                     objitem->nmnozReODB +objitem->nmnozplOdb)
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

// ne          if(changed .or. nradVykDph:value = 0,(::nazevrv(), nvypsazdan:set(0)), nil)
          drgvar:initvalue := drgvar:prevValue := drgvar:value
        endif

      case(name = ::it_file +'->nprocdphpp')
        if c_dphpp->nnapocet <> 0
          cc := cprocdan +str(c_dphpp->nnapocet,1)
          if((nprocdan_h := DBGetVal(cc)) = 0, DBPutVal(cc,value), ok := (nprocdan_h = value))

          if( IsObject(ovar := ::dm:has(::it_file +'->nnapocetpp')), ovar:set(c_dphpp->nnapocet), nil)
        endif

      case(name = ::it_file +'->nradvykdph')
        if changed
          ok := ::fin_vykdph_rv_sel()
        endif

        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if( ok, ::df:setNextFocus((::it_file)+ '->ncejPrZbz',,.t.), nil)
        endif

      *
      ** jen pro kasu mùže zadat ncejprkdz
      case(name = ::it_file +'->ncejprkdz' .and. changed .and. ::it_file = 'poklitw')
        nvypsazdan:set(1)
        cmp_1 := .t.
      **
      *

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

      case(name = ::it_file +'->ncejprzbz' .and. changed)

        if ::it_file = 'fakvysitw'
          * párovaná záloha
          if(nisParZal := ::cejPrZbz_push()) <> 0
            cisZalFak := ::dm:get(::it_file +'->ncisZalFak')
            if .not. empty(cisZalFak)
              fakvyshd->(dbSeek(cisZalFak,,'FODBHD1'))
              x  := round(FIN_fakturovat_z_bc(8,1),4)

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
                if (round(x,4) > round(value,4))
                  ::parvyzal_vykdph_in()
                endif

              endif
            endif
          endif
        endif

        nvypsazdan:set(0)

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
        if (name = ::it_file +'->nfaktmnkoe' )  // .and. changed )
          nkoefMn    := ::dm:get(::it_file +'->nkoefMn' )
          nfaktMnoz:set( value * nkoefMn )
        endif

        mnozDzbo  := ::wds_cenzboz_kDis +if(::o:state <> 2, nfaktmnoz:prevValue, 0)
        typsklcen := lower(cenzboz->ctypsklcen)

        if upper(cenzboz->cpolcen) = 'C'
          if nfaktMnoz:value > mnozDzbo
             ok := .not. (typsklcen = 'pru')
             ::msg:writeMessage('Dispozièní množství je pouze [' +str(mnozDzbo) +'] ...', ;
                                 if(ok, DRG_MSG_WARNING,DRG_MSG_ERROR)                    )
          endif
        endif

        n_zaklDan := (ncejprkdz:value * nfaktMnKoe:value)
        n_procDan := nprocdph:value

        *
        ** daò byla vypoèítaná F4 - nesmí se pøepoèítávat
**        if nvypsazdan:value = 1
**           n_sazDan := njedDan:value
**        else

        if n_roundDph = 0
          nkoeF    := n_procdan / (n_procdan +100)
          n_sazDan := n_zaklDan * nkoeF

*** oprava 26.2.2020
***          c_sazDan := str( n_sazDan )
***          n_sazDan := val( subStr( c_sazDan, 1, at( '.', c_sazDan) +2 ))

**          n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)
        else
          n_sazDan := mh_roundnumb(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), n_roundDph)
        endif
**        endif

        njeddan:set(n_sazDan    / nfaktMnKoe:value)
        ncejprkdz:set(n_zaklDan / nfaktMnKoe:value)
        ncejprkbz:set(n_zaklDan / nfaktMnKoe:value -n_sazDan / nfaktMnKoe:value)

        if (name = ::it_file +'->ncejprkdz' .and. changed )
          *
          ** prodejní cena je ncejPrZdz = 15 ale uživatel zadal ncejPrKdz = 15000
          ** neprodává se slevou, ale s obrovskou pøirážkou
          n_procSlev :=( (ncejPrZdz:value -ncejPrKdz:value) / ncejPrZdz:value ) *100

          if abs(n_procSlev) <= 999.99
            nhodnSlev:set( ncejPrZdz:value - ncejPrKdz:value   )
            nprocSlev:set( nhodnSlev:value/ncejPrZdz:value *100)
            ncelkSlev:set( nhodnSlev:value * nfaktMnKoe:value  )
          endif
        endif

      otherwise
  *** 1
        if nvypsazdan:value = 0
          ncejprkbz:set(ncejprzbz:value - nhodnslev:value)

          if cmp_1

            if ::it_file <> 'poklitw'
** 3.2.2021
*              ndeciMals := Set( _SET_DECIMALS, 4 )
*                n_sazDan := (ncejprkbz:value * nprocdph:value/100)
*                c_sazDan := str( n_SAZdan )
*                n_sazDan := val( subStr( c_sazDan, 1, at( '.', c_sazDan) +2 ))
*              Set( _SET_DECIMALS, ndeciMals)
*              ncejprkdz:set(ncejprkbz:value +n_sazDan)
              ncejprkdz:set(ncejprkbz:value + (ncejprkbz:value * nprocdph:value/100))
            endif
          else
            ncejprkdz:set(ncejprkbz:value + njeddan:value)
          endif
        else

          if cmp_1
            n_zaklDan := if( ::it_file = 'poklitw', ncejprkdz:value, ncejprzdz:value) -nhodnslev:value
            n_procDan := nprocdph:value

            *
            ** daò byla vypoèítaná F4 - nesmí se pøepoèítávat
            if nvypsazdan:value = 1
              n_sazDan := njedDan:value
            else

              if n_roundDph = 0
                n_sazDan := round(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), 2)
              else
                n_sazDan := mh_roundnumb(round(n_zaklDan * round((n_procDan/(100 +n_procDan)),4),2), n_roundDph)
              endif
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
      if ( ::it_file = 'poklitw' )
        ncecprzbz:set(ncejprkbz:value * nfaktMnKoe:value)
        ncelkslev:set(nhodnslev:value * nfaktMnKoe:value)
        ncecprkbz:set(ncejprkbz:value * nfaktMnKoe:value)
        ncecprkdz:set(ncejprkdz:value * nfaktmnKoe:value)
      else
        ncecprzbz:set(ncejprkbz:value * nfaktmnoz:value)
        ncelkslev:set(nhodnslev:value * nfaktmnoz:value)
        ncecprkbz:set(ncejprkbz:value * nfaktmnoz:value)
        ncecprkdz:set(ncejprkdz:value * nfaktmnoz:value)
      endif
      *
      if(isObject(ncenZakCel), ncenZakCel:set(ncecprzbz:value *nkoe)        , nil)
      if(isObject(nsazDan   ), nsazDan:set(ncecprkdz:value -ncecprzbz:value), nil)
      if(isObject(ncenZakCed), ncenZakCed:set(ncecprkdz:value *nkoe)        , nil)
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
**        lastOk := (name = ::it_file +'->nfaktmnkoe' .or. name = ::it_file +'->ncejprkdz')

        do case
        case( name = ::it_file +'->nfaktmnkoe' )  ;  lastOk := ( ::o:on_sklPol = '1')
        case( name = ::it_file +'->ncejprkdz'  )  ;  lastOk := .t.
        endcase

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


method fin_pro_fakdol:nazevrv()
  local cky := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad) +upper((::hd_file)->ctyppohybu)
  local pa, retVal := '0', cradDph
  local rv  := ::dm:has(::it_file +'->nradvykdph')
  local txt := ::dm:has('vykdph_iw->combotext'  )
  *
  local duzp    := (::hd_file)->dpovinfak

  if ::it_file = 'fakvysitw' .and. isobject(rv) .and. isobject(txt)
    if(select('c_typpoh') = 0, drgDBms:open('c_typpoh'), nil)
    c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

    cradDph := FIN_c_vykdph_cradDph( duzp, ::hd_file )

    if .not. empty(cradDph)
      pa := listasarray(cradDph)
      pa := asize(pa,5)

      do case
      case c_dph->nnapocet = 0 ;  retVal := isnull(pa[1],'0')
      case c_dph->nnapocet = 1 ;  retVal := isnull(pa[2],'0')
      case c_dph->nnapocet = 2 ;  retVal := isnull(pa[3],'0')
      case c_dph->nnapocet = 3 ;  retVal := isnull(pa[5],'0')
      endcase
    endif

    retVal := val(retVal)
    rv:set(retval)
  endif
return nil

*
** SEL METHOD ******************************************************************
method FIN_PRO_fakdol:fin_firmy_sel(drgDialog)
  local  odialog, nexit, finTyp := (::hd_file)->nfintyp, zkrTypUhr, ucet_uct, konstSymb, cKy
  local      vypSAZdan := (::hd_file)->cvypSAZdan, nprocSlHot
  local  cfg_vypSAZdan, cis_vypSAZdan, fir_vypSAZdan
  *
  local  drgVar, value, ok, name, splatn := sysConfig('FINANCE:nSPLATNOST'), npos
  local  in_firmyDA := .f., odrg
  *
  local  nEvent := mp1 := mp2 := oXbp := nil, copy := .f.
  *
  local  sel_ky := upper(padr('fir_firmy_sel',50))      + ;
                   upper(padr('firmy', 10))             + ;
                   upper(padr(name, 22))
  *
  * inovace do budoucna vazba na firmyVa bude nutnio vypustit vazbu na firmyDa
  local  cf_DOP   := "czkr_SKva = '%%'", cFilter
  local  arSelect := {}

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  drgVar := ::df:olastDrg:oVar   // ?? oXbp:cargo:ovar

  if ::hd_file = 'poklhdw'
    value := if( ::o:on_firmySel = '1' .and. empty(drgVar:value), -1, drgVar:value )
  else
    value := drgVar:value
  endif

    name := lower(drgVar:name)
      ok := (empty(value) .or. firmy->(::o:drgDialog:sel_dbseek( sel_ky, value,,'FIRMY1')))

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::o:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if (ok .and. drgVar:itemChanged())
    copy := .T.
  elseif nexit != drgEVENT_QUIT
    copy := .T.
  endif

  if copy
**  if nexit != drgEVENT_QUIT .or. ok
    ok := .t.
    if(select('firmyda') = 0, drgDBMS:open('firmyda'), nil)
    if(select('firmyva') = 0, drgDBMS:open('firmyva'), nil)


//    úprava  JT   27.7.2015
    if name = ::hd_file +'->ncisfirdoa'
      if firmyVA->(dbseek( StrZero( firmy->ncisFirmy,5) + 'DOA',,'FIRMYVA02'))
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy->cnazev
        (::hd_file)->cnazevDOA2 := firmy->cnazev2
        (::hd_file)->culiceDOA  := firmy->culice
        (::hd_file)->cpscDOA    := firmy->cpsc
        (::hd_file)->csidloDOA  := firmy->csidlo

        firmy->(dbseek( firmyVA->nCisFirVA,,'FIRMY1'))
      else
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy->cnazev
        (::hd_file)->cnazevDOA2 := firmy->cnazev2
        (::hd_file)->culiceDOA  := firmy->culice
        (::hd_file)->cpscDOA    := firmy->cpsc
        (::hd_file)->csidloDOA  := firmy->csidlo
      endif
    else
      if firmyVA->(dbseek( StrZero( firmy->ncisFirmy,5) + 'FAA',,'FIRMYVA04'))
        drgDBMS:open('firmy',,,,,'firmy_da')
        firmy_da->(dbseek( firmyVA->nCisFirmy,,'FIRMY1'))

        (::hd_file)->ncisFirDOA := firmy_da->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy_da->cnazev
        (::hd_file)->cnazevDOA2 := firmy_da->cnazev2
        (::hd_file)->culiceDOA  := firmy_da->culice
        (::hd_file)->cpscDOA    := firmy_da->cpsc
        (::hd_file)->csidloDOA  := firmy_da->csidlo

      else
        (::hd_file)->ncisFirDOA := firmy->ncisFirmy
        (::hd_file)->cnazevDOA  := firmy->cnazev
        (::hd_file)->cnazevDOA2 := firmy->cnazev2
        (::hd_file)->culiceDOA  := firmy->culice
        (::hd_file)->cpscDOA    := firmy->cpsc
        (::hd_file)->csidloDOA  := firmy->csidlo
      endif
    endif
//   --------------  konec úpravy JT

    cky := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad) +upper((::hd_file)->ctyppohybu)
    c_typpoh->(dbseek(cky,,'C_TYPPOH05'))

    cfg_vypSAZdan := lower( SYSCONFIG('FINANCE:cVYPSAZDPH'))
    cis_vypSAZdan := lower( c_typpoh->cvypSAZdan )
    fir_vypSAZdan := lower( firmy->cvypSAZdan )

    mh_copyfld('firmy',::hd_file,, .f.)

    do case
    case .not. empty(cis_vypSAZdan)
        (::hd_file)->cvypSAZdan := c_typpoh->cvypSAZdan

    case ( ( lower(vypSazDan) = cfg_vypSazDan ) .and. .not. empty(fir_vypSAZdan) )
      (::hd_file)->cvypSAZdan := firmy->cvypSAZdan

    otherWise
      (::hd_file)->cvypSAZdan := vypSAZdan
    endcase

*    (::hd_file)->cvypsazdan := vypSazDan
    (::hd_file)->dsplatfak  := (::hd_file)->dvystfak +splatn

    if name = ::hd_file +'->ncisfirdoa'
      *
      * 2.7.2015 finanèní údaje se berou z FAA
      if firmyfi->(dbseek(firmy->ncisfirmy,,'FIRMYFI1'))
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

      * poklhd má pøednastavený typ úhrady, nesmí se zmìnit
      if( ::it_file = 'poklitw',  zkrTypUhr := (::hd_file)->czkrtypuhr, nil )

      mh_copyfld('firmyfi',::hd_file,, .f.)

      (::hd_file)->nkonstsymb := konstSymb
      if(       empty(konstSymb), (::hd_file)->nkonstSymb := firmyfi->nkonstSymb, nil )
      if( .not. empty(zkrTypUhr), (::hd_file)->czkrtypuhr := zkrTypUhr          , nil )


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

    if ::it_file = 'poklitw'
      *
      ** dopravci
      if(select('firmyva')   = 0, drgDBMS:open('firmyva')              , nil)
      if(select('firmy_wav') = 0, drgDBMS:open('firmy',,,,,'firmy_vaw'), nil)
      if(select('stroje')    = 0, drgDBMS:open('stroje')               , nil)

      cFilter := format( cf_DOP, { 'DOP' } )
      firmyVa->( ads_setAof(cFilter) , ;
                 dbEval( { || if( firmy_vaw->( dbseek( firmyVa->ncisFirVa,,'FIRMY1')), aadd(arSelect, { firmyVa->ncisFirmy,firmy_vaw->( recNo()) }), nil ) } ), ;
                 ads_clearAof()       )

      if len(arSelect) > 0
        if( npos := ascan( arSelect, {|x| x[1] = firmy->ncisFirmy} )) <> 0
          firmy_vaw->( dbgoTo( arSelect[npos, 2] ))
        else
          firmy_vaw->( dbgoTo( arSelect[   1, 2] ))
        endif

        (::hd_file)->ncisFirDOP  := firmy_vaw->ncisFirmy
        (::hd_file)->cnazevDOP   := firmy_vaw->cnazev
        (::hd_file)->cnazevDOP2  := firmy_vaw->cnazev2
        (::hd_file)->nicoDOP     := firmy_vaw->nico
        (::hd_file)->cdicDOP     := firmy_vaw->cdic
        (::hd_file)->culiceDOP   := firmy_vaw->culice
        (::hd_file)->csidloDOP   := firmy_vaw->csidlo
        (::hd_file)->cpscDOP     := firmy_vaw->cpsc

        if stroje->( dbseek(firmy_vaw->ncisFirmy,, 'STROJE07'))
          (::hd_file)->cspz := stroje->cspzStroj
        endif
      endif
      ** end dopravci
      *
      ::o:one_edt := ::it_file +'->csklPol'
      ::o:df:setNextFocus(::it_file +'->csklPol',,.t.)
      if ( nprocSlHot := ::o:favst_procSlev() ) <> 0
        (::hd_file)->nprocSlHot := nprocSlHot
        ::o:dm:set( ::hd_file +'->nprocSlHot', nprocSlHot )
      endif
    else
      ::o:df:setNextFocus(::hd_file +'->czkrtypuhr',,.t.)
    endif
  endif
return ok


method fin_pro_fakdol:fin_vykdph_rv_sel(drgDialog)
  local  odialog, nexit, finTyp := (::hd_file)->nfintyp, filter
  *
  local  procDph := ::dm:has(::it_file +'->nprocdph'  ):value
  local  drgVar  := ::dm:has(::it_file +'->nradvykdph')
  local  value   := drgVar:value
  local  ok

  local  dat_od  := FIN_c_vykdph_ndat_od( (::hd_file)->dpovinFak )

  c_dph->(dbseek(nprocDph,,'C_DPH2'))
  filter := format("(ntyp_dph = %% .and. substr(fakvysit,%%,1) = '1') .and. ndat_od = %%", ;
                    {c_dph->nnapocet,finTyp,dat_od})

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
    ** nkodPlneni
    if lower(::it_file) = 'fakvysitw' .and. isObject(::cmb_kodPlneni)
      if ::cmb_kodPlneni:isEdit
        ::cmb_kodPlneni_defval  := vykdph_iw->nkodPlneni
        ::cmb_kodPlneni:value   := ::cmb_kodPlneni:ovar:value := ::cmb_kodPlneni_defval
        ::cmb_kodPlneni:refresh()
      endif
    endif
    *
    ** ctypPreDan a nprodDPHpp se edituje pouze pro nradVykDPH = 25
    ::typPreDan( vykdph_iw->nradek_dph )

    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
  vykdph_iw->(dbclearfilter(),dbgotop())
return ok


method FIN_PRO_fakdol:parvyzal_vykdph_in(drgDialog)
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


method FIN_PRO_fakdol:postValidateForm(m_file)
  local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
  local  drgVar
  *
  begin sequence
    for x := 1 to size step 1
      file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

      if file = m_file .and. values[x,2]:odrg:isEdit

        drgVar := values[x,2]

        if .not. ::postValidate(drgVar)
**        if .not. values[x,2]:odrg:postValidate()

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
method FIN_PRO_fakdol:showGets(inAppend,vld_ok)
  local oxbp, odrg
  local file_iv, po_Gets := ::po_Gets, pa, pos

  default inAppend to .f., vld_ok to .f.


  cc := ::it_file

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

*
**
** CLASS for fin_vykdph_rv_sel *************************************************
CLASS fin_vykdph_rv_sel FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit, drgDialogStart

  inline access assign method setPreDan() var setPreDan
    return if( vykdph_iw->lsetPreDan, 607, 0)

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
  local dc := ::drgDialog:dialogCtrl

  do case
  case(nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT)
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

  case(nEvent = drgEVENT_APPEND   )
  case(nEvent = drgEVENT_FORMDRAWN)
    return .T.

  case(nEvent = xbeP_Keyboard)
    do case
    case(mp1 = xbeK_ESC)
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.

hidden:
  var  drgGet
ENDCLASS


method fin_vykdph_rv_sel:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  if IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  endif

  ::drgUsrClass:init(parent)
return self


method fin_vykdph_rv_sel:getForm()
  local oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 65,10 DTYPE '10' TITLE 'Výbìr øádku výkazu DPH (položky faktury) ...' ;
                                           FILE 'vykdph_iw'                                     ;
                                           GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC SIZE 65,9.8 ;
                        FIELDS 'M->setPreDan:pdp:3::2,'               + ;
                               'nradek_dph:øv,'                       + ;
                               'comboText:název øádku výkazu dph:39,' + ;
                               'cucetu_dph:SuAu_'                       ;
                        SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'
return drgFC


method fin_vykdph_rv_sel:drgDialogInit(drgDialog)
  local  aPos, aSize
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*-  XbpDialog:titleBar := .F.

  if IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]-25}
  endif
return


method fin_vykdph_rv_sel:drgDialogStart(drgDialog)
  local obrow, oColumn, x

  obrow := drgDialog:dialogCtrl:obrowse[1]:oxbp

  for x := 1 to obrow:colCOunt step 1
    ocolumn := obrow:getColumn(x)
    ocolumn:colorBlock := &( '{|a,b,c| fin_vykdph_rv_sel_colorBlock( a, b, c ) }' )
  next
return self


function fin_vykdph_rv_sel_colorBlock( a, b, c )
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,32,32}), }

  AClr := if( vykdph_iw->lpreDanPov, aCOL_er, aCOL_ok )
return AClr