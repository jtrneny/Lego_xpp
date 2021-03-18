#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define  m_files   { 'firmy', 'c_staty', 'c_bankuc', 'vyrzakit', 'vyrzak' }

*
** CLASS for PRO_explsthd_IN ***************************************************
CLASS PRO_explsthd_IN FROM drgUsrClass, FIN_finance_IN, FIN_fakturovat_z_vld, wds
exported:
  var     cmb_typPoh, typPol
  var     lnewrec, hd_file, it_file
  var     info_16, info_25, info_34
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo
  *
  var     cisSklad , sklPol
  var     cisloDl  , countdl
  var     cislObInt, cislPolob
  var     cisZakazi

  var     o_cenzboz_kDis, o_dodlstit_kDis, o_objitem_kDis, o_vyrzak_kDis

  method  init, drgDialogStart, postLastField, postSave, destroy
  method  comboItemSelected, postAppend, postValidate
  method  fir_firmy_sel, osb_osoby_sel
  *
  * textové info položky na kartì
  inline access assign method cenzboz_kDis(co) var cenzboz_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := ::cisSklad:get() + ::sklPol:get()
      oxbp := ::o_cenzboz_kDis:odrg:oxbp

      if( lok := cenzboz->(dbseek(upper(cky),,'CENIK03')))
        * jen pro cenníkové položky *
        if( upper(cenzboz->cpolcen) = 'C', retval := ::wds_cenzboz_kDis, lok := .f.)
      endif
      if(lok, oxbp:show(), oxbp:hide())
    endif
    return retVal

  inline access assign method dodlstit_kDis() var dodlstit_kDis
    local cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisloDl) .and. isObject(::countdl)
      cky  := strZero(::cisloDl:get(),10) +strZero(::countdl:get(),5)
      oxbp := ::o_dodlstit_kDis:odrg:oxbp

      if(lok :=  dodlstit->(dbseek(cky,,'DODLIT5')))
        retVal := ::wsd_dodlstit_kDis
      endif
      if(lok, oxbp:show(), oxbp:hide())
    endif
    return retVal

  inline access assign method objitem_kDis()  var objitem_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cislObInt) .and. isObject(::cislPolob)
      cky  := upper(::cislObInt:get()) +strZero(::cislPolob:get(),5)
      oxbp := ::o_objitem_kDis:odrg:oxbp

      if(lok := objitem ->(dbseek(cky,,'OBJITEM2')))
        retVal := ::wsd_objitem_kDis
      endif
      if(lok, oxbp:show(), oxbp:hide())
    endif
    return retVal

  inline access assign method vyrzak_kDis()   var vyrzak_kDis
    local  cky, retVal := 0, lok := .f., oxbp

    if isObject(::cisZakazi)
      cky  := ::cisZakazi:get()
      oxbp := ::o_vyrzak_kDis:odrg:oxbp

      if(lok := vyrzakit->(dbseek( upper(cky),,'ZAKIT_4')))
        retVal := ::wsd_vyrzakit_kDis
      endif
      if(lok, oxbp:show(), oxbp:hide())
    endif
    return retVal

  * hlavièka info
  * 1 -bìžná faktura/ 6 -euro faktura
  * 'Bez DpH    <infoval_11>   DpH  <infoval_12> Celkem                               '
  inline access assign method infoval_11 var infoval_11
    return (explsthdw->ncendancel +explsthdw->nzakldaz_1 +explsthdw->nzakldaz_2)
  inline access assign method infoval_12 var infoval_12
    return (explsthdw->nsazdan_1 +explsthdw->nsazdan_2 +explsthdw->nsazdaz_1 +explsthdw->nsazdaz_2)

  * položky - bro
  inline access assign method cenPol() var cenPol
    return if(explstitw->cpolcen = 'C', MIS_ICON_OK, 0)

  inline access assign method cena_za_mj() var cena_za_mj
    local retval := 0

    retval := if(explsthdw->nfintyp > 2 .or. explsthdw->nfintyp = 6, ;
              if(explsthdw->nfintyp = 4, explstitw->ncenzakcel,explstitw->ncejprkbz), explstitw->ncejprkbz)
    return retval

  inline method tabSelect(oTabPage,tabnum)
    do case
    case(otabPage:tabNumber = 2)   // 1 -> 2
      ::p_head:hide()
    case(otabPage:tabNumber = 1)   // 2 -> 1
      ::p_head:show()
    endcase
  return .t.

  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  inSav := 0   // 0-neumíme uložit 1-ukládáme položku 2-ukládáme doklad
    local  inBro := (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse')

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state := 0

      if ::state <> 0
        (::cisZakazi:odrg:isEdit := .F., ::cisZakazi:odrg:oxbp:disable())
      endif

      ::dm:refresh()
      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if isObject(::brow)
        if     inBro                                 ; inSav := if(isMethod(self,'postSave'),2,0)
        elseif ::hd_file $ lower(::df:oLastDrg:name) ; inSav := if(isMethod(self,'postSave'),2,0)
        else                                         ; inSav := if(isMethod(self,'postLastField'),1,0)
        endif
      else
        inSav := if( isMethod(self,'postSave'),2,0)
      endif

      do case
      case (inSav = 0)
        drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
        return .t.

      case (inSav = 1)
        ::postLastField()

      otherwise
        if ::postSave()
          if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
          return .t.
        endif
      endcase

    otherwise
      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.

  method  showGroup

HIDDEN:
  var     p_head
  var     members_fak, members_pen, members_inf
  method  fir_firmy_set
ENDCLASS


method PRO_explsthd_in:init(parent)
  ::drgUsrClass:init(parent)
  *
  (::hd_file  := 'explsthdw',::it_file  := 'explstitw')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::typPol   := .t.

  * základní soubory
  ::openfiles(m_files)

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )

  * likvidace
  ::FIN_finance_in:typ_lik := 'poh'

  PRO_explsthd_cpy(self)
return self


METHOD PRO_explsthd_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:dialogCtrl:members[1]:aMembers, odrg, groups
  local  fst_item := if(::lnewrec,'ctyppohybu','ncisFirmy'), pa, ph
  *
  local  pa_groups, nin, acolors := MIS_COLORS

  ::members_fak := {}
  ::members_pen := {}
  pa := ::members_inf := {}
  ph := ::p_head := nil

  aeval(members, {|x| if(ismembervar(x,'groups') .and. .not. isnull(x:groups), ;
                        if(x:groups $ 'HEAD', ph := x, nil),nil) })
  ::p_head     := ph:oxbp

  for x := 1 TO Len(members)
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        pa_groups := ListAsArray(members[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            members[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          members[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif
  next

  *
  ::fin_finance_in:init(drgDialog,'poh',::it_file +'->ccisZakazi',' položku expedièního listu')

  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg

  * cenzboz
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad' , .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'   , .F.)
  *dodldtit
  ::cisloDl    := ::dm:get(::it_file +'->ncislodl'  , .F.)
  ::countdl    := ::dm:get(::it_file +'->ncountdl'  , .F.)
  * objitem
  ::cislObInt  := ::dm:get(::it_file +'->ccislobint', .F.)
  ::cislPolob  := ::dm:get(::it_file +'->ncislPolob', .F.)
  * vyrzakit
  ::cisZakazi  := ::dm:get(::it_file +'->cciszakazi', .F.)

  ::o_cenzboz_kDis  := ::dm:has('M->cenzboz_kDis' )
  ::o_dodlstit_kDis := ::dm:has('M->dodlstit_kDis')
  ::o_objitem_kDis  := ::dm:has('M->objitem_kDis' )
  ::o_vyrzak_kDis   := ::dm:has('M->vyrzak_kDis'  )
  *
  ::wds_connect(self)

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      if isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo
      endif
    else
      odrg := members[x]
    endif

    groups := if( ismembervar(odrg,'groups'), isnull(members[x]:groups,''), '')

    do case
    case empty(groups)
      aadd(::members_fak,members[x])
      aadd(::members_pen,members[x])
    otherwise
      do case
      case('FAK' $ groups)  ;  aadd(::members_fak,members[x])
      case('PEN' $ groups)  ;  aadd(::members_pen,members[x])
      otherwise
        aadd(::members_fak,members[x])
        aadd(::members_pen,members[x])
      endcase
    endcase
  next

  if(::lnewrec, ::comboItemSelected(::cmb_typPoh,0)                 , ;
                ::df:setNextFocus((::hd_file) +'->ncisFirmy',, .T. )  )
*-  ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. )
RETURN


method PRO_explsthd_in:postAppend()
  ::dm:set('explstitw->czkratJedn','ks')
  ::dm:set('explstitw->ntypPriloh',  1 )
return .t.


method PRO_explsthd_in:postLastField()
  local  isChanged := ::dm:changed(), file_iv := alltrim(::dm:has(::it_file +'->cfile_iv'):value)
  local  cisZakaz

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2  ;  if(.not. empty(file_iv), ::copyfldto_w(file_iv,::it_file),nil)
                       cisZakaz := (::it_file)->ccisZakaz
                       ::copyfldto_w(::hd_file,::it_file)

                       (::it_file)->ccisZakaz  := cisZakaz
                       (::it_file)->nintcount  := ::ordItem()+1
    endif

    ::itsave()

    if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
    (::it_file)->(flock())
  endif

*-  fin_ap_modihd('DODLSTHDW')
  ::setfocus(::state)
  ::dm:refresh()
return .t.


method PRO_explsthd_IN:postSave()
  local ok := PRO_explsthd_wrt(self)

  if(ok .and. ::new_dok)
    explsthdw->(dbclosearea())
    explstitw->(dbclosearea())

    PRO_explsthd_cpy(self)

    ::fin_finance_in:refresh('explsthdw',,::dm:vars)

    ::brow:refreshAll()
    ::dm:refresh()
    ::df:tabPageManager:toFront(1)
    ::df:setnextfocus('explsthdw->ncisFirDOP',,.t.)
  endif
return ok


method PRO_explsthd_IN:showGroup()
  local  x, odrg, avars, members := ::df:aMembers
  local  panGroup := if((::hd_file)->nfintyp = 5, 'PEN', 'FAK')

* off
  aeval(members,{|o| ::modi_memvar(o,.f.)})

* on
  members := if( panGroup = 'FAK', ::members_fak, ::members_pen)
  aeval(members,{|o| ::modi_memvar(o,.t.)})

  avars := drgArray():new()
  for x := 1 to len(members) step 1
    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add(members[x]:ovar,lower(members[x]:ovar:name))
      endif
    endif
  next

  ::df:aMembers := members
  ::dm:vars     := avars

**  ::dm:refresh()
return


method pro_explsthd_in:comboItemSelected(drgcombo,mp2,o)
  local  value := drgcombo:Value, values := drgcombo:values
  local  nin, pa, finTyp, obdobi, cfile

  do case
  case 'ctyppohybu' $ lower(drgcombo:name)
    nIn    := ascan(values, {|X| X[1] = value })
     pa    := listasarray(values[nin,4])
     *
     if values[nin,3] <> (::hd_file)->ctypdoklad .or. .not. ::lnewrec
       (::hd_file)->ctypdoklad := values[nin,3]
       (::hd_file)->ctyppohybu := values[nin,1]
     endif
  endcase
return self


method pro_explsthd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  it_fir := 'ncisfirmy,ncisfirdop,ncisfirdoa'
  local  it_sel   := '...->ncislodl,...->cciszakazi,...->ccislobint,...->csklpol'
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  cisFirmy, cisFirmyDOA

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    case(item $ it_fir .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->dnakladky')
      if changed
        (::hd_file)->dexpedice :=  value
        ::dm:set(::hd_file +'->dexpedice', value)
      endif

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        ovar := ::dm:get(::hd_file +'->mpoznobj',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
    endcase

 * položky dokladu
  case(file = ::it_file)
    it_sel := strtran(it_sel,'...',::it_file)

    do case
    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case(item $ it_fir .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::it_file +'->ncennaodod')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endcase


    if name = ::it_file +'->cciszakazi'
      vyrzakit->(dbSeek(upper(value),,'ZAKIT_4'))
      cisFirmy  := ::dm:has(::it_file +'->ncisFirmy' )
      cisFirDOA := ::dm:has(::it_file +'->ncisFirDOA')

      if( empty(cisFirmy:get()), ;
        (firmy->(dbSeek(vyrzakit->ncisFirmy,,'FIRMY1')),::fir_firmy_set('ncisfirmy')), nil)

      if( empty(cisFirDOA:get()), ;
        ( firmy->(dbSeek(vyrzakit->ncisFirDOA,,'FIRMY1')),::fir_firmy_set('ncisfirdoa')), nil)
    endif
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok, drgVar:save(), nil )
return ok


method pro_explsthd_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  value  := drgVar:get()
  local  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')

  ok := firmy->(dbseek(value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    do case
    case(file = ::hd_file)  ;  (::hd_file)->ncisFirDOP  := firmy->ncisFirmy
                               (::hd_file)->cnazevDOP   := firmy->cnazev
                               (::hd_file)->cnazevDOP2  := firmy->cnazev2
                               (::hd_file)->nicoDOP     := firmy->nico
                               (::hd_file)->cdicDOP     := firmy->cdic
                               (::hd_file)->culiceDOP   := firmy->culice
                               (::hd_file)->csidloDOP   := firmy->csidlo
                               (::hd_file)->cpscDOP     := firmy->cpsc
      drgVar:set(firmy->ncisfirmy)
      ::fin_finance_in:refresh(drgVar)
      ::dm:refresh()

    case(file = ::it_file)  ;  ::fir_firmy_set(item)
    endcase
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_explsthd_in:fir_firmy_set(item)
  do case
  case(item = 'ncisfirmy' )  ;  ::dm:set(::it_file +'->ncisFirmy' ,firmy->ncisFirmy )
                                ::dm:set(::it_file +'->cnazev'    ,firmy->cnazev    )
                                ::dm:set(::it_file +'->cnazev2'   ,firmy->cnazev2   )
                                ::dm:set(::it_file +'->nico'      ,firmy->nico      )
                                ::dm:set(::it_file +'->cdic'      ,firmy->cdic      )
                                ::dm:set(::it_file +'->culice'    ,firmy->culice    )
                                ::dm:set(::it_file +'->csidlo'    ,firmy->csidlo    )
                                ::dm:set(::it_file +'->cpsc'      ,firmy->cpsc      )
                                ::dm:set(::it_file +'->czkratstat',firmy->czkratstat)

  case(item = 'ncisfirdoa')  ;  ::dm:set(::it_file +'->ncisFirDOA',firmy->ncisFirmy)
                                ::dm:set(::it_file +'->cnazevDOA' ,firmy->cnazev   )
                                ::dm:set(::it_file +'->cnazevDOA2',firmy->cnazev2  )
                                ::dm:set(::it_file +'->nicoDOA'   ,firmy->nico     )
                                ::dm:set(::it_file +'->cdicDOA'   ,firmy->cdic     )
                                ::dm:set(::it_file +'->culiceDOA' ,firmy->culice   )
                                ::dm:set(::it_file +'->csidloDOA' ,firmy->csidlo   )
                                ::dm:set(::it_file +'->cpscDOA'   ,firmy->cpsc     )
  endcase
return


method pro_explsthd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::drgDialog:lastXbpInFocus:cargo:ovar
  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
    if 'cjmenorid' $ name
      (::hd_file)->cjmenoRid := osoby->cosoba
    else
      (::hd_file)->cjmenoVYS := osoby->cosoba
    endif

    ::fin_finance_in:refresh(drgVar)
    ::dm:refresh()
  endif
return (nexit != drgEVENT_QUIT)

*
*****************************************************************
METHOD PRO_explsthd_IN:destroy()
  ::drgUsrClass:destroy()
RETURN self