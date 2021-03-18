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



*  PØIJATÉ OBJEDNÁVKY       *
** CLASS for PRO_objhead_IN ****************************************************
CLASS PRO_objhead_IN FROM drgUsrClass, FIN_finance_IN
  exported:
  var     lNEWrec,  cmb_typPoh
  var     typ_dokl, is_ban, hd_file, it_file, in_file, varSym

  * new
  var     system_nico, system_cdic, system_cpodnik, system_culice, system_cpsc, system_csidlo

  method  init, drgDialogStart, drgDialogEnd
  method  postValidate, comboItemSelected, tabSelect, postLastField, postSave, postAppend, postDelete
  method  fir_firmy_sel, skl_cenzboz_sel, osb_osoby_sel


  * objitem
  inline access assign method lastprocSlev() var lastprocSlev
    local  procSlev := 0, cky

    if isObject(::cisSklad) .and. isObject(::sklPol)
      cky  := strZero(objheadw->ncisFirmy,  5) + ;
              upper(::cisSklad:get()         ) + ;
              upper(::sklPol:get()           )

      objit_lpc ->(dbseek( cky,, 'OBJITE26'))
      procSlev := objit_lpc->nprocSlev
    endif
    return procSlev

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

*  inline access assign method datObj_hd var datObj_hd
*    return objheadw->ddatObj

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
  inline method int_cislObint(in_wrt)
    local  m_filter := "ncisfirmy = %%", filter

    default in_wrt to .f.

    filter := format( m_filter, {objheadw->ncisFirmy})
    objhd_iw->(AdsSetOrder('OBJHEAD1'), ads_setAof(filter), dbGoBottom())

    objheadw->ncislObint := objhd_iw->ncislobint +1
    objheadw->ccislObint := left(firmy->cnazev,4)       +'-' + ;
                            strzero(firmy->ncisfirmy,5) +'/' + ;
                            strzero(objheadw->ncislObint,4)

    if .not. in_wrt
      objheadw->mpoznobj   := objhd_iw->mpoznobj
    endif

    ::dm:get(::hd_file +'->ccislObint', .F.):set(objheadw->ccislobint)
    objhd_iw->(ads_clearAof())
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
        ( ::sklPol:odrg:isEdit   := .F., ::sklPol:odrg:oxbp:disable() )
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

    otherwise
      RETURN ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .F.

 HIDDEN:
   * ok
   var     cisFirmy, datObj, zkrTypUhr
   var     zboziKat, cisSklad, sklPol, cislObint, klicDph, datObj_hd

   var     cenaZakl,  hodnSlev, procSlev
   var     mnozObOdb, mnozPoOdb, mnozVpInt, mnPotVyr, mnozPdOdb, mnozPlOdb
   method  sumColumn, takeValue, objvst_pc, mnozValidate

   VAR     zaklMena, title, cisFak
//   METHOD  postValidateForm, open_in
ENDCLASS


method pro_objhead_in:init(parent)
  *
  (::hd_file := 'objheadw', ::it_file := 'objitemw')
  *
  ::typ_dokl := 'xx'
  ::is_ban   := .F.  // (typ_dokl = 'ban')
  ::lNEWrec  := .not. (parent:cargo = drgEVENT_EDIT)
  ::zaklMena := SysConfig('Finance:cZaklMena')

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open('objitem',,,,,'objit_lpc')
  drgDBMS:open('objhead',,,,,'objhd_iw' )

  * pøednastavení z CFG
  ::SYSTEM_nico    := sysconfig('system:nico'     )
  ::SYSTEM_cdic    := sysconfig('system:cdic'     )
  ::SYSTEM_cpodnik := sysconfig('system:cpodnik'  )
  ::SYSTEM_culice  := sysconfig('system:culice'   )
  ::SYSTEM_cpsc    := sysconfig('system:cpsc'     )
  ::SYSTEM_csidlo  := sysconfig('system:csidlo'   )
  *

  pro_objhead_cpy(self)
return self


method pro_objhead_in:drgDialogStart(drgDialog)
  local  que_del := ' ' +'objednávky pøijaté'   //::title
  *
  local  members  := drgDialog:oForm:aMembers, aedits := {}
  local  fst_item := if(::lNewrec,'ctyppohybu','ccisobj')
  *
  local  acolors  := MIS_COLORS

  for x := 1 TO Len(members)
    do case
    case members[x]:ClassName() = 'drgText' .and. .not.Empty(members[x]:groups)
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
    endcase
  next


  ::FIN_finance_in:init(drgDialog,::typ_dokl,::it_file +'->csklpol',que_del,.t.)

  * hd
  ::cmb_typPoh := ::dm:has(::hd_file +'->ctyppohybu'):odrg
  ::cisFirmy   := ::dm:get(::hd_file +'->ncisfirmy' , .F.)
  ::datObj     := ::dm:get(::hd_file +'->ddatObj'   , .F.)
  ::zkrTypUhr  := ::dm:get(::hd_file +'->czkrtypuhr', .F.)
  * it
  ::datObj_hd  := ::dm:get('M->datobj_hd'          , .F.)
  ::zboziKat   := ::dm:get(::it_file +'->nzboziKat', .F.)
  ::cisSklad   := ::dm:get(::it_file +'->ccissklad', .F.)
  ::sklPol     := ::dm:get(::it_file +'->csklpol'  , .F.)
  ::klicDph    := ::dm:get(::it_file +'->nklicdph' , .F.)
  * pro take_value
  ::cenaZakl   := ::dm:get(::it_file +'->ncenaZakl' , .F.)
  ::hodnSlev   := ::dm:get(::it_file +'->nhodnSlev' , .F.)
  ::procSlev   := ::dm:get(::it_file +'->nprocSlev' , .F.)
  *
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

  * datum objednávky z hlavièky na kartì položek
  ::datobj_hd:set( (::hd_file)->ddatobj )
return self


method pro_objhead_in:drgDialogEnd(drgDialog)
  objitemw ->(DbCloseArea())
   objhd_iw ->(DbCloseArea())
    objit_iw ->(DbCloseArea())
return


METHOD PRO_objhead_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-')
  local  ok     := .T., changed := drgVAR:changed(), subtxt
  local  it_sel := 'fakvnptw->ncislodl,fakvnptw->cciszakaz,fakvysitw->csklpol'
  *
  local  it_cmp := 'objitemw->nmnozobodb,objitemw->nmnozpoodb,objitemw->nmnozvpint,' + ;
                   'objitemw->nmnpotvyr,objitemw->nmnozpdodb'
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., ovar, recNo
  local  nmnozobodb, nmnozpoodb, nmnozvpint, nmnpotvyr , ;
         nmnozpdodb, ncenazakl , nhodnslev , nprocslev , ;
         ncenadlodb, nmnozplodb, nprocslfao, nprocslhot, nprocslmno, ;
         nkcsbdobj , nkcszdobj

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  do case
* hlavièka dokladu
  case(file = ::hd_file)
    do case
    CASE(name = ::hd_file +'->ndoklad')
      ok := fin_range_key('OBJHEAD',value,,::msg)[1]

    case(name = ::hd_file +'->ncisfirmy' .and. mp1 = xbeK_RETURN)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratstat' .or. name = ::hd_file +'->czkratmenz') .and. changed
      ::fin_kurzit(drgvar,(::hd_file)->ddatobj)

    case(name = ::hd_file +'->cnazpracov')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

        ovar := ::dm:get(::hd_file +'->mpoznobj',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)

        ovar := ::dm:get(::hd_file +'->mpoznamka',.f.)
        PostAppEvent(xbeP_Keyboard,xbeK_TAB,,ovar:odrg:oxbp)
      endif
    endcase

  * položky dokladu
  case(file = ::it_file)
    nmnozobodb := ::dm:has('objitemw->nmnozobodb')   // 12
    nmnozpoodb := ::dm:has('objitemw->nmnozpoodb')   // 13
    nmnozvpint := ::dm:has('objitemw->nmnozvpint')   // 14
    nmnpotvyr  := ::dm:has('objitemw->nmnpotvyr' )   // 15
    nmnozpdodb := ::dm:has('objitemw->nmnozpdodb')   // 16
    ncenazakl  := ::dm:has('objitemw->ncenazakl' )   // 17
    nhodnslev  := ::dm:has('objitemw->nhodnslev' )   // 18
    nprocslev  := ::dm:has('objitemw->nprocslev' )   // 19
    ncenadlodb := ::dm:has('objitemw->ncenadlodb')   // 20
**    nmnpotvyr  := ::dm:has('objitemw->nmnpotvyr' ) // 24
    nmnozplodb := ::dm:has('objitemw->nmnozplodb')   // 25
    nprocslfao := ::dm:has('objitemw->nprocslfao')   // 26
    nprocslhot := ::dm:has('objitemw->nprocslhot')   // 27
    nprocslmno := ::dm:has('objitemw->nprocslmno')   // 28
    nkcsbdobj  := ::dm:has('objitemw->nkcsbdobj' )
    nkcszdobj  := ::dm:has('objitemw->nkcszdobj' )

    do case
    case(name = ::it_file +'->csklpol' .and. mp1 = xbeK_RETURN)
      ok    := ::skl_cenzboz_sel()

    case(name $ it_cmp)
      if(name = ::it_file +'->nmnozobodb' .and. changed)

*        nprocslmno:set(::slevyMnoz())
*-        nprocslev:set(nprocslfao:value +nprocslhot:value +nprocslmno:value)
*-        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)
      endif

    case(name = ::it_file +'->ncenazakl' .and. changed)
      nhodnslev:set((ncenazakl:value * nprocslev:value)/100)

    case(name = ::it_file +'->nhodnslev' .and. changed)
      nprocslev:set((nhodnslev:value / ncenazakl:value)*100)
      if( nprocslev:value > 99.9, (nhodnslev:set(0), nprocslev:set(0)), nil)


    case(name $ it_sel .and. changed)
      ok := ::fakturovat_z_sel(drgVar:drgDialog)

    case(name = ::it_file +'->nprocslev')
      if changed
        nhodnslev:set((ncenazakl:value * nprocslev:value)/100)
      endif

    case(name = ::it_file +'->cdoplntxt')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    endcase

    * výpocet ncenadlodb
    ncenadlodb:set( round(ncenazakl:value -(ncenazakl:value * nprocslev:value)/100,2))

    * výpoèet nkcsbdobj / nkcszdobj
    nkcsbdobj:set(nmnozobodb:value * ncenadlodb:value)
    nkcszdobj:set(nkcsbdobj:value +int(nkcsbdobj:value * ::procDph/100))
  endcase

  if( changed .and. ok, ::dm:refresh(), nil)

* hlavièku ukládáma na každém prvku
  if( ::hd_file $ name .and. drgVar:changed() .and. ok)
    drgVar:save()

    * datum objednávky z hlavièky na kartì položek
    ::datobj_hd:set( (::hd_file)->ddatobj )

    * výpoèet nprocslev na objhead
    (::hd_file)->nprocslev := (::hd_file)->nprocslfao +(::hd_file)->nprocslhot
    ::dm:set(::hd_file +'->nprocslev', (::hd_file)->nprocslev)
  endif
RETURN ok


method pro_objhead_in:fir_firmy_sel(drgDialog)
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
      ::copyfldto_w('firmyfi','objheadw')
      zkrProdej := firmyFI->czkrProdej
      zkrTypUhr := firmyFI->czkrTypUod
    endif
    ::copyfldto_w('firmy'  ,'objheadw')

    ::int_cislObint()
    *
    objheadw->czkrProdej := zkrProdej
    objheadw->czkrTypUhr := zkrTypUhr
    *
    c_staty->(dbseek(upper(objheadw->czkratStat),,'C_STATY1'))

    ::cisFirmy:set(firmy->ncisfirmy)

    ::fin_finance_in:refresh(::cisFirmy)
    ::dm:refresh()
    ::df:setNextFocus(::hd_file +'->ddatdoodb',,.t.)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_objhead_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit,  odrg := drgDialog:lastXbpInFocus:cargo

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if nExit != drgEVENT_QUIT
    ::dm:set(odrg:name, osoby->cosoba)
  endif
return .t.


method pro_objhead_in:comboItemSelected(drgcombo,mp2,o)
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


method pro_objhead_in:tabSelect(oTabPage,tabnum)
  local it_file := ::brow:cargo:cfile
  local tab_Num := oTabPage:tabNumber

  do case
  case(tab_Num =  1)  ;  ::df:setNextFocus('objheadw->ncisfirmy' ,, .t.)
  otherwise
    _clearEventLoop(.t.)
    ::setfocus( if( (it_file)->(eof()), 2, 0) )
  endcase
return .t.


method pro_objhead_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f., recNo
  *
  local  ovar := ::dm:get('M->lastprocSlev' , .F.)

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'PRO_objhead_cen_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
**    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::takeValue('cenzboz',2)

    ovar:odrg:refresh( ::lastprocSlev )

*    recNo := (::it_file)->(recNo())
*    if objitemw->(dbseek( upper(cenzboz->ccisSklad) +upper(csklPol),,'OBJITEM_3'))
*      fin_info_box('Skladová položka je již obsažena v objednávce ...')
*    endif
*    (::it_file)->(dbgoTo(recNo))
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_objhead_in:postLastField(drgVar)
  local  isChanged := ::dm:changed()                                  , ;
         file_iv   := alltrim(::dm:has(::it_file +'->cfile_iv'):value), ;
         recs_iv   := ::dm:has(::it_file +'->nrecs_iv'):value         , ;
         ok        := ::mnozValidate()

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
                         (::it_file)->ncislPOLob := ::ordItem()+1
      endif

      ::itsave()
      *
      if( ::state = 2, ::brow:gobottom():refreshAll(), ::brow:refreshCurrent())
      (::it_file)->(flock())
    endif


    (::it_file)->ncelkslev := ((::it_file)->nhodnSlev  * (::it_file)->nmnozobodb)
    (::it_file)->nhmotnost := ((::it_file)->nmnozobodb * (::it_file)->nhmotnostJ)
    (::it_file)->nobjem    := ((::it_file)->nmnozobodb * (::it_file)->nobjemJ   )
    pro_objhdead_cmp()

    ::sumColumn()
    ::setfocus(::state)
    ::dm:refresh()
  endif
return ok


method PRO_objhead_IN:postAppend()
  (::sklPol:odrg:isEdit   := .t., ::sklPol:odrg:oxbp:enable()  )
return .t.


method pro_objhead_in:postSave()
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

  pro_objhdead_cmp()
  ok := pro_objhead_wrt_inTrans(self)

  if(ok .and. ::new_dok)
    objheadw->(dbclosearea())
    objitemw->(dbclosearea())
    objit_iw->(dbclosearea())

    pro_objhead_cpy(self)

    ::brow:refreshAll()

    setAppFocus(::brow)
    ::dm:refresh( , .t.)

    ::df:tabPageManager:toFront(1)

    ::df:setnextfocus('objheadw->ctyppohybu',,.t.)
    ::comboItemSelected(::cmb_typPoh)
  endif
return ok


method PRO_objhead_IN:postDelete()
  ::sumColumn()
  ::brow:refreshAll()
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method pro_objhead_in:sumColumn()
  local  kcsBdobj := kcsZdobj := 0, x, value

  objit_iw->(dbgotop())
  do while .not. objit_iw ->(Eof())
    if objit_iw->_delrec <> '9'
      ( kcsBdobj += objit_iw->nkcsBdobj, kcsZdobj += objit_iw->nkcsZdobj)
    endif
    objit_iw->(dbskip())
  enddo

  for x := 6 to 7 step 1
    value := if(x = 6,str(kcsBdobj), str(kcsZdobj))

    ::brow:getColumn(x):Footing:hide()
    ::brow:getColumn(x):Footing:setCell(1,value)
    ::brow:getColumn(x):Footing:show()
  next
return .t.


method pro_objhead_in:takeValue(iz_file,iz_pos)
  local  x, pos, value, items, mname, par, iz_recs := (iz_file)->(recno())
*           objitemw,        cenzboz,
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
  {      'ddatdoodb',  'objheadw->ddatdoodb' }, ;
  {     'ddatodvvyr', 'objheadw->ddatodvvyr' }, ;
  {      'nprocslev',  'objheadw->nprocslev' }, ;
  {     'nprocslfao', 'objheadw->nprocslfao' }, ;
  {     'nprocslhot', 'objheadw->nprocslhot' }, ;
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

   ::df:setNextFocus('objitemw->nmnozobodb',,.T.)
return


method pro_objhead_in:objvst_pc()
  local filtr, m_filtr, procento := 0  //100
  *
  local cisFirmy := ::cisFirmy:value, zkrTypUhr := ::zkrTypUhr:value, datObj := ::datObj:value
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
    procenho->(dbsetFilter( { || is_datumOk(datObj) }))

    do case
    case( procenho->(dbseek(m_cky   ,,'PROCENHO09')))
       procento := procenho->nprocento

    case( procenho->(dbseek(zboziKat,,'PROCENHO10')))
       procento := procenho->nprocento

*    case( procenho->(dbseek( upper(zkrTypUhr),,'PROCENHO11')) .and. is_datumOk(datObj))
*       procento := procenho->nprocento
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


method pro_objhead_in:mnozValidate()
  Local  potvrCel := 0, potvrBez := 0, cerr := ''

  Local  ok

  ok := ( ::mnozObOdb:value >  0           .and. ;
          ::mnozPoOdb:value >= 0           .and. ;
          ::mnozVpInt:value >= 0           .and. ;
          ::mnozPdOdb:value >= 0           .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value   .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value +::mnozVpInt:value  +::mnPotVyr:value .and. ;
          ::mnozVpInt:value <= ::mnozObOdb:value -::mnozPoOdb:value                    .and. ;
          ::mnozObOdb:value >= ::mnozPoOdb:value +::mnozVpInt:value  +::mnPotVyr:value +::mnozPlOdb:value )

  if .not. ok
    potvrCel := ::mnozPoOdb:value +::mnozVpInt:value +::mnPotVyr:value
    potvrBez := if(potvrCel < ::mnozPlOdb:value, ::mnozPlOdb:value -potvrCel, 0 )

    do case
    case (potvrCel +potvrBez) < ::mnozPlOdb:value
      cerr := 'Hodnota POTVRZENO +K_VÝROBÌ nemúže být menší než plnìní ...'

    case ::mnozObOdb:value < 0 .and. (potvrCel +potvrBez) = 0
      return .t.

    case (potvrCel +potvrBez) > ::mnozObOdb:value
      cerr := 'Hodnota POTVRZENO +K_VÝROBÌ nemùže být vìtší než objednáno ... '

    case (::mnozObOdb:value < ::mnozPoOdb:value +::mnozVpInt:value +::mnPotVyr:value +::mNozPlOdb:value)
      cerr := 'Hodnota OBJEDNÁNO nemùže být menší než POTV_ODB +MNOŽK_VÝR +POT_VÝR +PLNÌNÍ ...'
    endcase

    ::msg:writeMessage(cerr, DRG_MSG_ERROR)
    ::df:setnextfocus(::it_file +'->nmnozobodb',,.t.)
  endif
return ok


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