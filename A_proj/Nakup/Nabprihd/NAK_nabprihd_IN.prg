#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#define  m_files   {'typdokl' ,'c_typoh'                      , ;
                    'c_dph'   ,'c_meny'  ,'c_staty', 'kurzit' , ;
                    'firmy'   ,'firmyfi' ,'firmyuc', 'nakpol' , ;
                    'cenzboz' ,'cenprodc','procenho'            }

* výbìr do položek nabídky z definovaných záložek
#define  tab_CENZBOZ   1
#define  tab_VYRPOL    2

*  NABÍDKY PØIJAÉ     *
** CLASS for NAK_nabprihd_IN **************************************************
CLASS NAK_nabprihd_IN FROM drgUsrClass, FIN_finance_IN
  exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl, is_ban, hd_file, it_file, in_file, varSym
  var     existPROCEN, existVYRPOL

  * new
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, comboItemSelected, tabSelect
  method  postLastField, postSave, postAppend, postDelete, postEscape
  method  fir_firmy_sel, skl_cenzboz_sel, osb_osoby_sel


  * objitem
  inline access assign method stav_objitemw() var stav_objitemw
    local retVal := 0

    do case
    case(objitemw->nmnozplodb = 0                    )  ;  retVal := 301
    case(objitemw->nmnozplodb >= objitemw->nmnozobodb)  ;  retVal := 302
    case(objitemw->nmnozplodb <  objitemw->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal

  inline access assign method procDph() var procDph
    c_dph->(dbseek(if(IsNull(::klicDph), 0,::klicDph:value)))
    return c_dph->nprocdph

  inline access assign method typ_objitem() var typ_objitem
    local ky := if(IsNull(::cisSklad), '', ::cisSklad:value +::sklPol:value), isVyr := .F.

    nakpol->(dbseek(upper(ky),,'NAKPOL3'))
    isVyr := (nakpol->ckodtpv = 'R ' .or. nakpol->ckodtpv == 'P ')
    return if(isVyr, 'výrobek', 'zboží')

  inline access assign method in_file(m_file)
    local pos

    if ::state = 2
      if pcount() == 1
        ::in_file := m_file
      else
        ::in_file := if( Empty(::varSym:get()), '', ::in_file)
      endif
    else
    endif
  return ::in_file
  *
  **
  inline method int_cislNabidky(in_wrt)
    local  m_filter := "ncisfirmy = %%", filter

    default in_wrt to .f.

    filter := format( m_filter, {nabprihdw->ncisFirmy})
    nabhd_iw->(AdsSetOrder('NABPRIH3'), ads_setAof(filter), dbGoBottom())

    nabprihdw->ncisPrij   := nabhd_iw->ncisPrij +1
    nabprihdw->cnazPrij   := left(firmy->cnazev,4)       +'-' + ;
                             strzero(firmy->ncisfirmy,5) +'/' + ;
                             strzero(nabprihdw->ncisPrij,4)

    if .not. in_wrt
//      objheadw->mpoznobj   := objhd_iw->mpoznobj
    endif

    ::dm:get(::hd_file +'->cnazPrij', .F.):set(nabprihdw->cnazPrij)
    nabhd_iw->(ads_clearAof())
  return
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0

      if .not. (::it_file)->(eof())
        ( ::katCZbo:odrg:isEdit := .f., ::katCZbo:odrg:oxbp:disable() )
**        ( ::sklPol:odrg:isEdit   := .F., ::sklPol:odrg:oxbp:disable() )
      endif

      if(isobject(::brow), ::brow:hilite(), nil)
      ::dm:refresh()
      RETURN .F.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') .and. isobject(::brow)
        if(IsMethod(self, 'postLastField'), ::postLastField(), Nil)
      else
        if isMethod(self,'postSave')
          if ::postSave()
            if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
            return .t.
          endif
        else
          drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
          return .t.
        endif
      endif

    case nEvent = xbeP_Keyboard .and. mp1 = xbeK_ESC .and. oXbp:ClassName() = 'XbpBrowse'
      ::postEscape()

    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

 HIDDEN:
   * ok
   var     cisFirmy, datOdes, zkrTypUhr
   var     katCZbo, cisSklad, sklPol, zboziKat, cislObint, klicDph

   var     cenaZakl,  hodnSlev, procSlev
   var     mnozOdes
   var     mnozObOdb, mnozPoOdb, mnozVpInt, mnPotVyr, mnozPdOdb, mnozPlOdb
   method  sumColumn, takeValue, objvst_pc

   VAR     zaklMena, title, cisFak, tabNum
//   METHOD  postValidateForm, open_in
ENDCLASS


method nak_nabprihd_in:init(parent)
  *
  (::hd_file := 'nabprihdw', ::it_file := 'nabpriitw')
  *
  ::typ_dokl := 'xx'
  ::is_ban   := .F.  // (typ_dokl = 'ban')
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::zaklMena := SysConfig('Finance:cZaklMena')
  ::tabNum   := 1

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open('nabprihd',,,,,'nabhd_iw')

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )
  *
  nak_nabprihd_cpy(self)
return self


method nak_nabprihd_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'nabídky pøijatì'   //::title
  *
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  local  fst_item := if(::lNewrec,'ctyppohybu','ccisobj')

   for x := 1 to LEN(members) step 1
    if members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
      if 'SETFONT' $ members[x]:groups
        members[x]:oXbp:setFontCompoundName(ListAsArray(members[x]:groups)[2])
      endif
    endif
  next

  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->ckatCZbo',que_del,.t.)

  * hd
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy   := ::dm:get(::hd_file +'->ncisfirmy' , .F.)
  ::datOdes    := ::dm:get(::hd_file +'->ddatOdes'  , .F.)
  ::zkrTypUhr  := ::dm:get(::hd_file +'->czkrtypuhr', .F.)
  * it
  ::katCZbo    := ::dm:get(::it_file +'->ckatCZbo' , .F.)
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad', .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'  , .F.)
  ::zboziKat   := ::dm:get(::it_file +'->nzboziKat', .F.)
  ::klicDph    := ::dm:get(::it_file +'->nklicdph' , .F.)
  * pro take_value
  ::cenaZakl   := ::dm:get(::it_file +'->ncenaZakl' , .F.)
  ::hodnSlev   := ::dm:get(::it_file +'->nhodnSlev' , .F.)
  ::procSlev   := ::dm:get(::it_file +'->nprocSlev' , .F.)
  *
  ::mnozOdes   := ::dm:has('nabvysitw->nmnozOdes')

// -- VEN
  ::mnozObOdb  := ::dm:has('objitemw->nmnozobodb')
  ::mnozPoOdb  := ::dm:has('objitemw->nmnozpoodb')
  ::mnozVpInt  := ::dm:has('objitemw->nmnozvpint')
  ::mnPotVyr   := ::dm:has('objitemw->nmnpotvyr' )
  ::mnozPdOdb  := ::dm:has('objitemw->nmnozpdodb')
  ::mnozPlOdb  := ::dm:has('objitemw->nmnozplodb')
  *
  if( ::lNEWrec, ::comboItemSelected(::cmb_typPoh), nil)
  if( ::lNEWrec, nil, ::df:setNextFocus((::hd_file) +'->' +fst_item,, .T. ))
  *
  ::sumColumn()
return self


method nak_nabprihd_in:drgDialogEnd(drgDialog)
  nabpriitw ->(DbCloseArea())
   nabhd_iw  ->(DbCloseArea())
    nabit_iw  ->(DbCloseArea())
return


METHOD nak_nabprihd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed(), subtxt
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo
  local  nmnoznOdes, ;
         ncenaZakl , nhodnSlev, nproSlev, ncenjedZak, ncenZakCel, ncenZakCeD

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    CASE(name = ::hd_file +'->ndoklad')
      ok := fin_range_key('NABPRIHD',value,,::msg)[1]

    case(name = ::hd_file +'->ncisfirmy' .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz') .and. changed
      ::fin_kurzit(drgvar,(::hd_file)->ddatOdes)

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

        ovar := ::dm:get(::hd_file +'->mpoznnab',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)

        ovar := ::dm:get(::hd_file +'->mpoznamka',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
    endcase

  * položky dokladu
  case(file = ::it_file)
    nprocDph   := ::dm:has('nabpriitw->nprocDph'  )
    nmnoznOdes := ::dm:has('nabpriitw->nmnoznOdes')

    ncenaZakl  := ::dm:has('nabpriitw->ncenazakl' )
    nhodnSlev  := ::dm:has('nabpriitw->nhodnslev' )
    nprocslev  := ::dm:has('nabpriitw->nprocslev' )

    ncenJedZak := ::dm:has('nabpriitw->ncenJedZak')
    ncenZakCel := ::dm:has('nabpriitw->ncenZakCel')
    ncenZakCeD := ::dm:has('nabpriitw->ncenZakCeD')

    do case
    case(name = ::it_file +'->csklpol' .and. mp1 = xbeK_RETURN)
      ok    := ::skl_cenzboz_sel()

    case(name = ::it_file +'->ncenazakl' .and. changed)
      nhodnslev:set((ncenazakl:value * nprocslev:value)/100)

    case(name = ::it_file +'->nhodnslev' .and. changed)
      nprocslev:set((nhodnslev:value / ncenazakl:value)*100)
      if( nprocslev:value > 99.9, (nhodnslev:set(0), nprocslev:set(0)), nil)

    case(name = ::it_file +'->nprocslev')
      if changed
        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)
      endif

    case(name = ::it_file +'->cdoplntxt')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase

    * výpoèet ncenJedZak
    ncenJedZak:set( round(ncenazakl:value -(ncenazakl:value * nprocslev:value)/100,2))

    * výpoèet ncenZakCel / ncenYakCeD
    ncenZakCel:set( nmnoznOdes:value  * ncenJedZak:value )
    ncenZakCeD:set( ncenZakCel:value + int( ncenZakCel:value * nprocDph:value/100))
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()

    * výpoèet nprocslev na objhead
    (::hd_file)->nprocslev := (::hd_file)->nprocslfao +(::hd_file)->nprocslhot
    ::dm:set(::hd_file +'->nprocslev', (::hd_file)->nprocslev)
  endif
RETURN ok


method nak_nabprihd_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%", zkrProdej := '', zkrTypUhr := '', m_filter

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    if firmyfi->(dbseek(firmy->ncisfirmy,,'FIRMYFI1'))
      ::copyfldto_w('firmyfi','nabprihdw')
      zkrProdej := firmyFI->czkrProdej
      zkrTypUhr := firmyFI->czkrTypUod
    endif
    ::copyfldto_w('firmy'  ,'nabprihdw')

    ::int_cislNabidky()
    *
*    objheadw->czkrProdej := zkrProdej
    nabprihdw->czkrTypUhr := zkrTypUhr
    *
    c_staty->(dbseek(upper(nabprihdw->czkratStat),,'C_STATY1'))

*    ::cisFirmy:set(firmy->ncisfirmy)

    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ddatdoodb',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method nak_nabprihd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set(odrg:name, osoby->cosoba)
  endif
return .t.


method nak_nabprihd_in:comboItemSelected(drgcombo,mp2,o)
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

  case 'czkratmenz' $ lower(drgcombo:name)
    if drgCombo:ovar:itemChanged()
      PostAppEvent(xbeP_Keyboard,xbeK_TAB,,drgcombo:oxbp)
    endif
  endcase
return self


method nak_nabprihd_in:tabSelect(oTabPage,tabnum)
  local it_file := ::brow:cargo:cfile
  local tab_Num := oTabPage:tabNumber

  ::tabNum := tabnum
  do case
  case(tab_Num =  1)  ;  ::df:setNextFocus('nabprihdw->ncisfirmy' ,, .t.)
  otherwise
    _clearEventLoop(.t.)
    ::setfocus( if( (it_file)->(eof()), 2, 0) )
  endcase
return .t.


method nak_nabprihd_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f., recNo

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  * v cenzboz se záhadným zpùsobem objevují prázdné záznamy
  * validace se pak chová jako by bylo všecno OK

  ok := ( ok .and. .not. empty( ::sklPol:value ))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENVYR_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::takeValue('cenzboz',2)

*    recNo := (::it_file)->(recNo())
*    if objitemw->(dbseek( upper(cenzboz->ccisSklad) +upper(csklPol),,'OBJITEM_3'))
*      fin_info_box('Skladová položka je již obsažena v objednávce ...')
*    endif
*    (::it_file)->(dbgoTo(recNo))
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method nak_nabprihd_in:postLastField(drgVar)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         ok        := .t.

  if ok
    * ukládáme na posledním PRVKU *
    if((::it_file)->(eof()),::state := 2,nil)

    if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
      if ::state = 2  ;  if .not. empty(file_iv)
                           (file_iv)->(dbgoto(recs_iv))
                           ::copyfldto_w(file_iv,::it_file)
                         endif
                         ::copyfldto_w(::hd_file,::it_file)
                         *
                         (::it_file)->nintCount := ::ordItem()+1
      endif

      ::itsave()
      *
      if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
      (::it_file)->(flock())
    endif


    (::it_file)->ncelkslev := ((::it_file)->nhodnSlev  * (::it_file)->nmnozNOdes)
    (::it_file)->nhmotnost := ((::it_file)->nmnozNOdes * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem    := ((::it_file)->nmnozNOdes * (::it_file)->nobjemJ   )

    nak_nabprihd_cmp()

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
return ok


method nak_nabprihd_IN:postAppend()

  (::katCZbo:odrg:isEdit   := .t., ::katCZbo:odrg:oxbp:enable()  )
  ::tabNum := 2
return .t.


method nak_nabprihd_in:postSave()
  local ok
  *
  local  m_file := upper(left(::hd_file, len(::hd_file)-1))
  local  doklad := (::hd_file)->ndoklad

  if ::lnewRec
    if .not. fin_range_key(m_file,doklad,,::msg)[1]
      ::df:tabPageManager:toFront(1)
      ::df:setnextfocus(::hd_file +'->ndoklad',,.t.)
      return .f.
    endif
  endif

  nak_nabprihd_cmp()

  ok := nak_nabprihd_wrt(self)

  if(ok .and. ::new_dok)
    nabprihdw ->(dbclosearea())
    nabpriitw ->(dbclosearea())
    nabit_iw  ->(dbclosearea())

    nak_nabprihd_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh()

    ::df:tabPageManager:toFront(1)

    ::df:setnextfocus('nabprihdw->ctyppohybu',,.t.)
    ::comboItemSelected(::cmb_typPoh)
  endif
return ok


method nak_nabprihd_IN:postDelete()

  ::sumColumn()
  ::brow:refreshAll()
return .t.

method nak_nabprihd_in:postEscape()
return .t.

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method nak_nabprihd_in:sumColumn()
  local  cenZakCel := cenZakCed := 0, x, value, npos
  *
  local  pa    := { 'ncenzakcel', 'ncenzakced' }
  local  ardef := ::brow:cargo:ardef

  nabit_iw->( dbgotop())

  do while .not. nabit_iw ->(Eof())
    if nabit_iw->_delrec <> '9'
      ( cenZakCel += nabit_iw->ncenZakCel, cenZakCeD += nabit_iw->ncenZakCeD)
    endif
    nabit_iw->(dbskip())
  enddo

  for x := 1 to len( pa) step 1
    value := if( x = 1, cenZakCel, cenZakCed )

    if ( npos := ascan( ardef, { |ait| pa[x] $ lower( ait[2]) })) <> 0

      ::brow:getColumn(npos):Footing:hide()
      ::brow:getColumn(npos):Footing:setCell(1, value)
      ::brow:getColumn(npos):Footing:show()
    endif
  next
return .t.


method nak_nabprihd_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno())
*         nabvysitw,                cenzboz,
*
  local  pa := { ;
  {      'nzboziKat',            'nzboziKat' }, ;
  {      'ccissklad',            'ccissklad' }, ;
  {        'csklpol',              'csklpol' }, ;
  {        'cnazzbo',              'cnazzbo' }, ;
  { 'M->typ_objitem',         ':typ_objitem' }, ;
  {       'nklicdph',             'nklicdph' }, ;
  {     'M->procDph',             ':procDph' }, ;
  {     'czkratjedn',           'czkratjedn' }, ;
  {      'ddatdoodb', 'nabprihdw->ddatdoodb' }, ;
  {      'nprocslev', 'nabprihdw->nprocslev' }, ;
  {     'nprocslfao', 'nabprihdw->nprocslfao'}, ;
  {     'nprocslhot', 'nabprihdw->nprocslhot'}, ;
  {      'ncenazakl',            'ncenapzbo' }, ;
  {     'nhmotnostj',            'nhmotnost' }, ;
  {        'nobjemj',               'nobjem' }  }

   for x := 1 to len(pa) step 1
     if IsObject(ovar := ::dm:has(if(at('->',pa[x,1]) = 0,::it_file +'->' +pa[x,1], pa[x,1])))

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

       ovar:set(value)
       ovar:initValue := ovar:prevValue := value
     endif
   next

   ::objvst_pc()

   if( IsObject(ovar := ::dm:has(::it_file +'->cfile_iv')), ovar:set(iz_file), nil)
   if( IsObject(ovar := ::dm:has(::it_file +'->nrecs_iv')), ovar:set(iz_recs), nil)

   ::df:setNextFocus('nabpriitw->nmnozobodb',,.T.)
return


method nak_nabprihd_in:objvst_pc()
  local filtr, m_filtr, procento := 0  //100
  *
  local cisFirmy := ::cisFirmy:value, zkrTypUhr := ::zkrTypUhr:value, datOdes := ::datOdes:value
  local cisSklad := ::cisSklad:value, sklPol    := ::sklPol:value, ;
        zboziKat := ::zboziKat:value
  *
  local m_cky    := upper(cisSklad) +upper(sklPol)

  filtr := "ntypProCen = 1 .and. "                                  + ;
           "  (ncisFirmy = %% .or. ncisFirmy = 0) .and. "           + ;
           "( (ccisSklad = '%%' .and. csklPol = '%%') .or. nzboziKat = %% .or. czkrTypUhr = '%%')"

  m_filtr := format( filtr, {cisFirmy, cisSklad, sklPol, zboziKat, zkrTypUhr})

  procenho->(ads_setAof(m_filtr),dbgoTop())
  cenprodc->(dbseek( m_cky,,'CENPROD1'))

  ::cenaZakl:set(cenprodc->ncenaPzbo)


  if .not. procenho->(eof())
    procenho->(dbsetFilter( { || is_datumOk(datOdes) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento
    endcase

    ::procSlev:set(procento)
    ::hodnSlev:set((cenprodc->ncenaPzbo * procento) / 100)
  endif
return

static function is_datumOk(datum)
  local  ok :=  empty(procenho->dplatnyOD) .or. ;
                (procenho->dplatnyOD <= datum .and. procenho->dplatnyDO >= datum)
return ok
**
*

/*
method pro_objhead_in:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x

  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence
return .t.


method pro_objhead_in:open_in(file,alias)
  local file_name

  if select(alias) = 0
    file_name := (file) ->( DBInfo(DBO_FILENAME))
    DbUseArea(.t., oSession_free, file_name, alias, .t., .t.)
    (alias) ->(AdsSetOrder(1))
  endif
return alias
*/