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


*
** CLASS for PRO_procenhd_IN *******************************************
CLASS PRO_procenhd_IN FROM drgUsrClass
  exported:
  var     lNEWrec, hd_file, it_file, ho_file

  method  init, drgDialogStart, drgDialogEnd
  method  createContext, fromContext, comboBoxInit
  method  preValidate, postValidate, postSave, postDelete

  * ok
  method  fir_firmy_sel, skl_cenzboz_sel, pro_procenfi_in, pro_procenhd_cpy, copy_crd
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow
  *
  method  stableBlock

  * procenhd
  inline access assign method hlaProCen() var hlaProCen
    return if( procenhd->lhlaProCen, 172, 0)

  inline access assign method bc_typprocen() var bc_typprocen
    return PRO_typprocen(procenhd->ntypprocen)

  inline access assign method nazFirmy() var nazFirmy
    local  ky := (::hd_file) ->ncisfirmy
    firmy->(dbseek(ky,,'FIRMY1'))
    return firmy->cnazev

  inline access assign method zkrProdej() var zkrProdej
    local  ky := (::hd_file) ->ncisfirmy
    firmy->(dbseek(ky,,'FIRMY1'))
    return firmy->czkrProdej

  * cenprodc porcento DPH
  inline access assign method procDph() var procDph
    cky := upper(cenprodc->ccisSklad) +upper(cenprodc->csklPol)

    cenzboz->(dbSeek(cky,,'CENIK03'))
    c_dph  ->(dbSeek(cenzboz->nklicDph,,'C_DPH1'))
    return c_dph->nprocDph

  * procenit
  inline access assign method nazZbo() var nazZbo
    local ky, retVal := ''

    do case
    case .not. empty(ky := upper((::it_file)->ccissklad +(::it_file)->csklpol))
      cenzboz->(dbseek(ky,,'CENIK03'))
      retval := cenzboz->cnazzbo
    case .not. empty(ky := (::it_file)->nzbozikat)
      c_katzbo->(dbseek(ky,,'C_KATZB1'))
      retVal := c_katzbo->cnazevkat
    case .not. empty(ky := upper((::it_file)->czkrtypuhr))
      c_typuhr->(dbseek(ky,,'TYPUHR1'))
      retVal := c_typuhr->cpopisuhr
    endcase
  return retVal

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local inFile, obro, ncol

    do case
    case(nevent = xbeP_SetInputFocus .and. oxbp:className() = 'XbpTabPage')
      ::setBroFocus(oxbp:cargo:tabNumber)
      return .t.

    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state := 0

      if ::tabNumber = 2
        ::restColor()
        if setAppFocus():className() <> 'XbpBrowse'
          ::oabro[4]:oxbp:lockUpdate(.t.)
           ::oabro[4]:oxbp:refreshAll()
            ::oabro[4]:oxbp:lockUpdate(.f.)
        endif
      endif
      return .f.

//    case (nEvent = drgEVENT_APPEND2 )
//      if( oxbp:className() <> 'XbpCheckBox' .and. ::tabNumber = 1, ::copy_crd(), nil)
//      return .t.

    otherwise
      if(::tabNumber = 1)
        do case
        case(nevent = drgEVENT_APPEND)
          inFile := lower(::dc:oaBrowse:cfile)
          return .f.

        case (nEvent = drgEVENT_APPEND2 )
          if( oxbp:className() <> 'XbpCheckBox' .and. ::tabNumber = 1, ::copy_crd(), nil)
          return .t.

        case(nevent = drgEVENT_EDIT)
          inFile := lower(::dc:oaBrowse:cfile)
          ::typProCen:odrg:oxbp:disable()
          return .f.

        case (nEvent = drgEVENT_SAVE)
          if IsObject(oXbp) .and. oXbp:className() = 'XbpGet'
           oXbp:SetColorBG(oXbp:cargo:clrFocus)
          endif

          if(oxbp:classname() <> 'XbpBrowse')  ;  ::postSave()
          else                                 ;  PostAppEvent(xbeP_Close, nEvent,,oXbp)
          endif
          return .t.

        case(nevent = drgEVENT_DELETE)
          inFile := lower(::dc:oaBrowse:cfile)

          if( (inFile)->(eof()), nil, ::postDelete() )
          return .t.
        endcase

      else
        do case
        case(nevent = drgEVENT_APPEND)
          return .t.

        case(nevent = drgEVENT_EDIT)
          obro := ::oabro[4]:oxbp

          obro:dehilite()
          obrocursorMode := XBPBRW_CURSOR_NONE

          for ncol := 1 to obro:colCount step 1
            obro:getColumn(ncol):dataArea:setCellColor(obro:rowPos,,GraMakeRGBColor({201, 210, 245}) )
          next

          ::df:setNextFocus('cenprodc->ncenCNZbo',,.t.)
          return .t.

        case(nevent = drgEVENT_DELETE)
          return .t.

        case(nevent = drgEVENT_SAVE)
          if cenprodc->(sx_rlock())
            ::cenprodc_Save()
          else
            ::msg:writeMessage('Nelze uložit zmìny, blokováno uživatelem ...',DRG_MSG_ERROR)
            sleep(20)
          endif
          cenprodc->(dbunlock())
          ::setBroFocus(::tabNumber)
          return .t.

        case(nevent = xbeP_Keyboard)
          if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
            ::setBroFocus(::tabNumber)
            return .t.
          endif

        endcase
      endif
    endcase
  return .f.

HIDDEN:
*  sys
  var     msg, dm, dc, df, ib, ab, state, oabro, ocol, drgPush, popState, panGroup
  var     tabNumber
  method  enableItems
  method  onSave_procenit

* datové
  var     typProCen, oznProCen, cisFirmy, zkrMeny
  var     cisSklad, sklPol, katZbo, proCento

  METHOD  postValidateForm, showGroup


  inline method setBroFocus(tabNumber)
    local  members := ::df:aMembers, pos, brow
    *
    local  x, ev, om, ok := (tabNumber = 1)

    ::tabNumber := tabNumber

    for x := 1 to len(::ab) step 1
      ev := lower(::ab[x]:event)
      om := ::ab[x]:parent:amenu

      if(ok, ::ab[x]:oxbp:enable() , ::ab[x]:oxbp:disable() )
    next

    if(ok, ::drgPush:enable(), ::drgPush:disable())

    brow := if(tabNumber = 1, ::oabro[1], ::oabro[4])
    oxbp := brow:oxbp
    pos  := ascan(members,{|X| (x = brow)})
    ::df:olastdrg   := brow
    ::df:nlastdrgix := pos
    ::df:olastdrg:setFocus()
    *
    ::dc:oabrowse := brow

    oxbp:deHilite()
    oxbp:refreshAll()
    PostAppEvent(xbeBRW_ItemMarked ,,,brow:oxbp)
  return .t.

  * obnova barvy GETu
  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  * filtr
  inline method setFilter(typProCen)
    local m_filter := "ntypprocen = %%", filter

    if( .not. empty((::hd_file)->(dbfilter())), (::hd_file)->(dbclearfilter(),dbgotop()), nil)

    if typProCen <> 0
      filter := format(m_filter,{typProCen})
      (::hd_file)->(dbsetfilter(COMPILE(filter),filter),dbgotop())
    endif
    ::dataManager:drgDialog:lastXbpInFocus := ::oabro[1]:oXbp
    ::oabro[1]:oxbp:refreshAll()
    PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oXbp)
    return self

  * je aktivni BROw ?
  inline method inBrow()
    return (SetAppFocus():className() = 'XbpBrowse')

  * fokus pro INS/ENTER
  inline method setFocus(inFile)
    if     (inFile = ::hd_file)  ; ::df:setNextFocus('procenhd->lhlaprocen',,.t.)
    elseif (inFile = ::it_file)  ; ::df:setNextFocus('procenit->' +if(::typProCen:value > 4,'czkrtypuhr','csklpol'),,.t.)
    else                         ; ::df:setNextFocus('procenho->dplatnyod',,.t.)
    endif
    return self

  * výpoètové prvky pro cenprodc
  inline method set_noChanged(drgVar, value)
    drgVar:set( round(value,2))

    drgVar:initValue := drgVar:prevValue := drgVar:Value
    return

  * ukládáme cenprodc
  inline method cenprodc_Save()
    local  x, vars := ::dm:vars, drgVar

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)

      if at('CENPRODC->',drgVar:name) <> 0
        if isblock(drgVar:block)
          if eval(drgvar:block) <> drgVar:value
            eval(drgVar:block,drgVar:value)
          endif
          drgVar:initValue := drgVar:value
        endif
      endif
    next
    return

ENDCLASS


method PRO_procenhd_IN:init(parent)
  local  pa_initParam
  local  filter := "", cfilter

  ::drgUsrClass:init(parent)
  *
  (::hd_file  := 'procenhd', ::it_file := 'procenit', ::ho_file := 'procenho')
  *

  drgDBMS:open('procenhd',,,,,'procenhd_w')
  drgDBMS:open('procenit',,,,,'procenit_w')

  drgDBMS:open('firmy'   )
  drgDBMS:open('cenzboz' )
  drgDBMS:open('cenprodc')
  drgDBMS:open('c_katzbo')
  drgDBMS:open('c_typuhr')
  drgDBMS:open('c_dph'   )


  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
//    cfilter := '(' +filter + ' .and. ' +pa_initParam[2] +')'
    cfilter := '(' +pa_initParam[2] +')'
  else
    cfilter := filter
  endif

  ::drgDialog:set_prg_filter( cfilter, 'procenhd')

return self


method PRO_procenhd_IN:drgDialogStart(drgDialog)
  local  x, arect, apos
  local  obro_2, xbp_obro_2
  local  obro_4, xbp_obro_4
  local  members := drgDialog:oForm:aMembers

  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dm        := drgDialog:dataManager             // dataMabanager
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::df        := drgDialog:oForm                   // form
  ::ab        := drgDialog:oActionBar:members      // actionBar
  ::ib        := drgDialog:oIconBar                // iconBar
  ::state     := 0
  *
  ::oabro     := drgDialog:dialogCtrl:obrowse
  ::ocol      := {}
  ::popState  := 1
  ::panGroup  := '1:2:3:4'
  ::tabNumber := 1
  *
      obro_2  := ::oabro[2]
  xbp_obro_2  := ::oabro[2]:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }
  *
      obro_4  := ::oabro[4]
  xbp_obro_4  := ::oabro[4]:oXbp
  xbp_obro_4:itemRbDown := { |mp1,mp2,obj| obro_4:createContext(mp1,mp2,obj) }
  *
  for x := 1 to ::oabro[2]:oxbp:colCount step 1
    aadd(::ocol,::oabro[2]:oxbp:getColumn(x))
  next
  *
  for x := 1 to len(members) step 1
    do case
    case(members[x]:ClassName() = 'drgPushButton') ; ::drgPush := members[x]
    endcase
  next

  if isobject(::drgPush)
    arect := ::ib:obord:currentSize()
    apos  := {arect[1] -::drgPush:oxbp:currentSize()[1],arect[2]-22}
    ::drgPush:oXbp:setPos(apos)
    ::drgPush:oxbp:setParent(::ib:obord)

    ::drgPush:oXbp:setFont(drgPP:getFont(5))
    ::drgPush:oXbp:setColorBG( graMakeRGBColor({170, 225, 170}) )

    ::drgPush:isEdit    := .f.
    ::drgPush:canResize := .t.
  endif

*---  ::itemMarked(nil,nil,::oabro[1]:oxbp)
  *
  * procenhd
  ::typProCen := ::dm:get('procenhd->ntypprocen', .f.)
  ::oznProCen := ::dm:get('procenhd->coznprocen', .f.)
  ::cisFirmy  := ::dm:get('procenhd->ncisfirmy' , .f.)
  ::zkrMeny   := ::dm:get('procenhd->czkratmeny', .f.)

  * procenit
  ::cisSklad  := ::dm:get('procenit->ccisSklad' , .f.)
  ::sklPol    := ::dm:get('procenit->csklpol'   , .f.)
  ::katZbo    := ::dm:get('procenit->nzbozikat' , .f.)

  * procenho
  ::proCento  := ::dm:get('procenho->nprocento' , .f.)

  * TEST
  ::oabro[1]:oxbp:stableBlock := { |a| ::stableBlock(a) }
  ::oabro[2]:oxbp:stableBlock := { |a| ::stableBlock(a) }
return self


method PRO_procenhd_IN:drgDialogEnd(drgDialog)
return


method PRO_procenhd_IN:createContext()
  local csubmenu, opopup, apos, ;
        popUp := 'Koplentí seznam nastavení  ,Prodejní ceny             ,' + ;
                 'Množstevní slevy           ,Slevy na zboží   -obrat   ,' + ;
                 'Slevy na zboží   -fakturace,Slevy na doklad -obrat    ,' + ;
                 'Slevy na doklad -fakturace '

  *
  local pa := listasarray(popUp)

  csubmenu := drgNLS:msg(popUp)
  opopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {drgParse(@cSubMenu), de_BrowseContext(self,x,pA[x]) } )
  next

  opopup:disableItem(::popState)
  arect := ::ib:obord:currentSize()
  apos  := {arect[1] -::drgPush:oxbp:currentSize()[1],arect[2]-22}
  opopup:popup(::ib:obord, {apos[1],apos[2]})
return self


method PRO_procenhd_IN:fromContext(aorder,nmenu)
  ::popState := aorder
  ::drgPush:oxbp:setCaption(nmenu)
  ::setFilter(aorder-1)
return self


method PRO_procenhd_IN:comboBoxInit(drgComboBox)
  local  acombo_val := {}

  do case
  case(lower(drgComboBox:name) = 'procenit->czkrtypuhr')
    aadd(acombo_val,{'     ', 'Sleva za doklad' })
    c_typuhr->(dbeval({|| aadd(acombo_val, {c_typuhr->czkrtypuhr, c_typuhr->cpopisuhr})}))

    drgComboBox:oXbp:clear()
    drgComboBox:values := asort( acombo_val,,, {|ax,ay| aX[2] < ay[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endcase
return self


method PRO_procenhd_IN:stableBlock(oxbp)
  local m_file, s_filter, filter
  *
  local m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%"

  if isobject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    oxbp:cargo:last_ok_rowPos := oxbp:rowPos
    oxbp:cargo:last_ok_recNo  := if( (m_file)->(eof()), 0, (m_file)->(recNo()) )

    do case
    case(m_file = ::hd_file)
      s_filter := (::it_file)->(ads_getAof())
      filter   := format(m_filter, {(::hd_file)->ntypprocen,(::hd_file)->ncisprocen })

      if .not. Equal(s_filter,filter)

        (::it_file)->(ads_setAof(filter),dbgotop())
        ::oabro[2]:oxbp:refreshAll()

        ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)

        filter := format(filter +" .and. NPOLPROCEN = %%", {(::it_file)->npolprocen})
        (::ho_file)->(ads_setAof(filter),dbgotop())
        ::oabro[3]:oxbp:refreshAll()
      endif

    case(m_file = ::it_file)
      s_filter := (::ho_file)->(ads_getAof())
      filter   := format(m_filter +" .and. NPOLPROCEN = %%", ;
                          {(::it_file)->ntypprocen, ;
                           (::it_file)->ncisprocen, ;
                           (::it_file)->npolprocen  })

      if .not. Equal(s_filter,filter)
        (::ho_file)->(ads_setAof(filter),dbgotop())
        ::oabro[3]:oxbp:refreshAll()
      endif
    endcase

    ::enableItems()
  endif
return self


method pro_procenhd_in:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t.
  *
  local  nevent := mp1 := mp2 := nil, lcanSet := procenho->( eof())

  nevent  := LastAppEvent(@mp1,@mp2)
  if( nevent = drgEVENT_ACTION .and. mp1 = drgEVENT_APPEND, lcanSet := .t., nil)
  if( nevent = xbeP_Keyboard   .and. mp1 = xbeK_DOWN      , lcanSet := .t., nil)

  * procenho
  do case
  case(file = ::ho_file)
    do case
    case( name = ::ho_file +'->dplatnyod' )

      if .not. empty( procenhd->dplatnyod ) .and. lcanSet
        ::dm:set( name, procenhd->dplatnyod )
      endif

    case( name = ::ho_file +'->dplatnydo' )

      if .not. empty( procenhd->dplatnydo ) .and. lcanSet
        ::dm:set( name, procenhd->dplatnydo )
      endif
    endcase
  endcase
return ok


METHOD PRO_procenhd_IN:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nin, isReturn

  local  cenCNZbo
  local  procMarz, cenaPZbo
  local            cenaMZbo
  local  procMarz1,cenaP1Zbo, procMarz2, cenaP2Zbo, procMarz3, cenaP3Zbo, procMarz4, cenaP4Zbo
  *
  local  o_marzX, pa_marzX := {'nprocmarz1', 'nprocmarz2', 'nprocmarz3', 'nprocmarz4'}
  local  o_cenaX, pa_cenaX := {'ncenap1zbo', 'ncenap2zbo', 'ncenap3zbo', 'ncenap4zbo' }

  * F4
  nevent    := LastAppEvent(@mp1,@mp2)
  isReturn := (nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  * procenhd
  case(file = ::hd_file)
    do case
    case(name = ::hd_file +'->coznprocen' .and. changed)

    case(name = ::hd_file +'->ncisfirmy'  .and. isReturn .and. changed)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratmeny' .and. isReturn )
*---      PostAppEvent(drgEVENT_SAVE,,,drgVar:odrg:oXbp)
*---      PostAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar:odrg:oXbp)
    endcase

  * procenit
  case(file = ::it_file)
    do case
    case(name = ::it_file +'->csklpol' .and. isReturn .and. changed)
      if(ok := ::skl_cenzboz_sel())
        ::dm:set(::it_file +'->cnazZbo', cenzboz->cnazZbo)
        (::katZbo:odrg:isEdit  := .f.,::katZbo:odrg:oxbp:disable())
      endif

    case(name = ::it_file +'->nzbozikat' .and. changed)
    endcase

  * procenho
  case(file = ::ho_file)
    do case
    case(name = ::ho_file +'->nhodnota' .and. ::typProCen:value = 1)
*-       .or. (name = ::ho_file +'->nprocento')
      if isReturn
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    case(name = ::ho_file +'->nprocento' .and. isReturn)
      PostAppEvent(drgEVENT_SAVE,,,drgVar:odrg:oXbp)
      if ::state = 2
        postappevent(drgEVENT_APPEND,,,drgVar:odrg:oXbp)
      else
        PostAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar:odrg:oXbp)
      endif
    endcase

  * cenprodc
  case(file = 'cenprodc')
    cenCNZbo  := ::dm:has('cenprodc->ncenCNZbo' )

    procMarz  := ::dm:has('cenprodc->nprocMarz' )
    cenaPZbo  := ::dm:has('cenprodc->ncenaPZbo' )
    cenaMZbo  := ::dm:has('cenprodc->ncenaMZbo' )

    procMarz1 := ::dm:has('cenprodc->nprocMarz1' )
    cenaP1Zbo := ::dm:has('cenprodc->ncenaP1Zbo' )

    procMarz2 := ::dm:has('cenprodc->nprocMarz2' )
    cenaP2Zbo := ::dm:has('cenprodc->ncenaP2Zbo' )

    procMarz3 := ::dm:has('cenprodc->nprocMarz3' )
    cenaP3Zbo := ::dm:has('cenprodc->ncenaP3Zbo' )

    procMarz4 := ::dm:has('cenprodc->nprocMarz4' )
    cenaP4Zbo := ::dm:has('cenprodc->ncenaP4Zbo' )

    do case
    case(item = 'ncencnzbo' .and. changed)
       ::set_noChanged( cenaPZbo , value +(value * procMarz:value) / 100 )

       ::set_noChanged( cenaMZbo , cenaPZbo:value +(cenaPZbo:value * ::procDph)/100 )

       ::set_noChanged( cenaP1Zbo, value + (value * procMarz1:value)/100 )
       ::set_noChanged( cenaP2Zbo, value + (value * procMarz2:value)/100 )
       ::set_noChanged( cenaP3Zbo, value + (value * procMarz3:value)/100 )
       ::set_noChanged( cenaP4Zbo, value + (value * procMarz4:value)/100 )

    case(item = 'nprocmarz' .and. changed)
       ::set_noChanged( cenaPZbo , cenCNZbo:value + (cenCNZbo:value * value    )/100 )
       ::set_noChanged( cenaMZbo , cenaPZbo:value + (cenaPZbo:value * ::procDph)/100 )

    case(item = 'ncenapzbo' .and. changed)
      ::set_noChanged( procMarz  , ((value - cenCNZbo:value) * 100 ) / cenCNZbo:value )
      ::set_noChanged( cenaMZbo  , value + (value * ::procDph )/100 )

    case(item = 'ncenamzbo' .and. changed)
     ::set_noChanged( procMarz, ((cenaPZbo:value - cenCNZbo:value) * 100 ) / cenCNZbo:value )
     ::set_noChanged( cenaPZbo, value / ( 1 + (::procDph / 100)) )

    case(item $ pa_marzX .and. changed)
       nin     := ascan(pa_marzX, item)
       o_cenaX := ::dm:has('cenprodc->' +pa_cenaX[nin])

       ::set_noChanged( o_cenaX, cenCNZbo:value + (cenCNZbo:value * value)/100 )

     case(item $ pa_cenaX .and. changed)
       nin     := ascan(pa_cenaX, item)
       o_marzX := ::dm:has('cenprodc->' +pa_marzX[nin])

       ::set_noChanged( o_marzX, ((value - cenCNZbo:value) * 100) / cenCNZbo:value )

    endcase

    * na posledním prvku ukádáme
    if(item = 'ncenap4zbo')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endif

  endcase
RETURN ok


/*
-  ncenCNZbo
     - ncenaPZbo  := ncenCNZbo + (ncenCNZbo * nprocMarz )/100
     - ncenaMZbo  := ncenaPZbo + (ncenaPZbo * pocDph    )/100

     - ncenaP1Zbo := ncenCNZbo + (ncenCNZbo * nprocMarz1)/100
     - ncenaP1Zbo := ncenCNZbo + (ncenCNZbo * nprocMarz2)/100
     - ncenaP1Zbo := ncenCNZbo + (ncenCNZbo * nprocMarz3)/100
     - ncenaP1Zbo := ncenCNZbo + (ncenCNZbo * nprocMarz4)/100

- nprocMarz
     - ncenaPZbo  := ncenCNZbo + (ncenCNZbo * nprocMarz )/100
     - ncenaMZbo  := ncenaPZbo + (ncenaPZbo * pocDph    )/100

- ncenaPZbo
     - nprocMarz  := ((ncenaPZbo - ncenaCNZbo) * 100 ) / ncenCNZbo
     - ncenaMZbo  := ncenaPZbo + (ncenaPZbo * pocDph )/100

- ncenaMZbo
     - nprocMZbo  := ((ncenaPZbo - ncenaCNZbo) * 100 ) / ncenCNZbo
     - ncenaPZbo  := ncenaMZbo / ( 1 + (procDph / 100))

- nprocMarzX
     - ncenaPXZbo := ncenCNZbo + (ncenaCNZbo * nprocMarzX)/100

- ncenaPXZbo
     - nprocMXZbo := ((ncenaPXZbo - ncenCNZbo) * 100) / ncenCNZbo
*/




method pro_procenhd_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('procenhd->cnazev', firmy->cnazev)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_procenhd_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))
    ::dm:set('procenit->ccissklad',cenzboz->ccissklad)
    ::sklPol:set(cenzboz->csklpol)
    ::dm:set('M->nazZbo',cenzboz->cnazzbo)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_procenhd_in:pro_procenfi_in(drgDialog)
  local oDialog
  DRGDIALOG FORM 'PRO_procenfi_IN' PARENT ::drgDialog MODAL DESTROY
return .t.


method pro_procenhd_in:pro_procenhd_cpy()
  local oDialog
  DRGDIALOG FORM 'PRO_procenhd_CPY' PARENT ::drgDialog MODAL DESTROY
return .t.


* ok
method pro_procenhd_in:ebro_beforeAppend(o_ebro)
/*
  local m_file   := lower(o_ebro:cfile), s_filter, filter
  local m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%"

  do case
  case (m_file = ::hd_file )
    filter := format(m_filter, { 0, 0 })

    (::it_file)->(ads_setAof(filter),dbgotop())
    ::oabro[2]:oxbp:refreshAll()

    ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)

    filter := format(filter +" .and. NPOLPROCEN = %%", {(::it_file)->npolprocen})
    (::ho_file)->(ads_setAof(filter),dbgotop())
    ::oabro[3]:oxbp:refreshAll()

  case (m_file = ::it_file )
     filter   := format(m_filter +" .and. NPOLPROCEN = %%", { 0, 0, 0 } )

     (::ho_file)->(ads_setAof(filter),dbgotop())
     ::oabro[3]:oxbp:refreshAll()

  endcase
*/
return .t.


method pro_procenhd_in:ebro_afterAppend(o_ebro)
  local m_file   := lower(o_ebro:cfile), s_filter, filter
  local m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%"

  do case
  case (m_file = ::hd_file )
    filter := format(m_filter, { 0, 0 })

    (::it_file)->(ads_setAof(filter),dbgotop())
    ::oabro[2]:oxbp:refreshAll()

    ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)

    filter := format(filter +" .and. NPOLPROCEN = %%", {(::it_file)->npolprocen})
    (::ho_file)->(ads_setAof(filter),dbgotop())
    ::oabro[3]:oxbp:refreshAll()

  case (m_file = ::it_file )
     filter   := format(m_filter +" .and. NPOLPROCEN = %%", { 0, 0, 0 } )

     (::ho_file)->(ads_setAof(filter),dbgotop())
     ::oabro[3]:oxbp:refreshAll()

  endcase
return .t.


method pro_procenhd_in:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky, lnew_proCENit := .f.

  do case
  case (cfile = 'procenhd')
   if (::hd_file)->ncisprocen = 0
      cky := strZero(::typProCen:value,5)
      procenhd_w->(AdsSetOrder('PROCENHD02'), dbsetScope(SCOPE_BOTH,cky), dbgoBottom())

      (::hd_file)->ncisprocen := procenhd_w->ncisprocen+1
      (::hd_file)->cnazev     := ::dm:get( 'procenhd->cnazev')
    endif

  case (cfile = 'procenit')
    if (::it_file)->ncisprocen = 0
      lnew_proCENit := .t.

      mh_copyfld('procenhd','procenit',, .t.)

      cky := strZero((::hd_file)->ntypprocen,5) +strZero((::hd_file)->ncisprocen,10)
      procenit_w->(AdsSetOrder('PROCENIT03'), dbsetScope(SCOPE_BOTH,cky), dbgoBottom())

      (::it_file)->npolprocen := procenit_w->npolprocen+1
      aeval(o_ebro:ardef, {|a| eval(a.drgEdit:ovar:block, a.drgEdit:ovar:value) })
    endif

    procenit->ccisSklad := ::cisSklad:value
    if( .not. lnew_proCENit, ::onSave_procenit(), nil )

  case (cfile = 'procenho')
    if(::ho_file)->ncisprocen = 0
      mh_copyfld('procenhd','procenho',, .t.)
      mh_copyfld('procenit','procenho',, .f.)

      aeval(o_ebro:ardef, {|a| eval(a.drgEdit:ovar:block, a.drgEdit:ovar:value) })
    endif
  endcase
return


method pro_procenhd_in:onSave_procenit()
 local cStatement, oStatement
 local stmt := "update procenho set ccisSklad = '%ccisSklad', " + ;
                                   "csklPol   = '%csklPol',   " + ;
                                   "nzboziKat =  %nzboziKat   " + ;
               "where ( ntypPROcen = %% and ncisPROcen = %% and npolPROcen = %% );"

  cStatement := strTran(       stmt, '%ccisSklad', procenit->ccisSklad      )
  cStatement := strTran( cStatement, '%csklPol'  , procenit->csklPol        )
  cStatement := strTran( cStatement, '%nzboziKat', str(procenit->nzboziKat) )
  cStatement := format(  cStatement, { procenit->ntypPROcen, procenit->ncisPROcen, procenit->npolPROcen })
  oStatement := AdsStatement():New(cStatement,oSession_data)

  if oStatement:LastError > 0
*      return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif
return self


* tohle pøijde ven *
method PRO_procenhd_IN:postSave()
  local  x, ovar, file, filter
  local  hd_vars := {}, hd_modi := .f., hd_lock := .t.
  local  it_vars := {}, it_modi := .f., it_lock := .t.
  local  ho_vars := {}, ho_modi := .f., ho_lock := .t.

  for x := 1 to ::dm:vars:size() step 1
    ovar := ::dm:vars:getNth(x)
    file := lower(drgParse(ovar:name,'-'))
    *
    if( isblock(ovar:block) .and. ovar:changed())
      do case
        * procenhd
        case(file = ::hd_file) ;   aadd(hd_vars,ovar)
                                   hd_modi := .t.
        * procenit
        case(file = ::it_file)  ;  aadd(it_vars,ovar)
                                   it_modi := .t.

        * procenho
        case(file = ::ho_file)  ;  aadd(ho_vars,ovar)
                                   ho_modi := .t.
      endcase
    endif
  next

  if hd_modi .or. it_modi .or. ho_modi
    if hd_modi
      hd_lock := if((::hd_file)->(eof()) .or. ::state = 2, addrec(::hd_file), replrec(::hd_file))
    endif

    if hd_lock .and. it_modi
      it_lock := if((::it_file)->(eof()) .or. (::state = 2 .or. ::state = 22), addrec(::it_file), replrec(::it_file))
    endif

    if hd_lock .and. it_lock .and. ho_modi
      ho_lock := if((::ho_file)->(eof()) .or. (::state = 2 .or. ::state = 32), addrec(::ho_file), replrec(::ho_file))
    endif

    if hd_lock .and. it_lock .and. ho_lock
      aeval(hd_vars,{|o| eval(o:block,o:value) })
      * procenhd - news
      if (::hd_file)->ncisprocen = 0
        filter := format("ntypprocen = %%",{(::hd_file)->ntypprocen})
        procenhd_w->(dbclearfilter()          , ;
                     AdsSetOrder('PROCENHD02'), ;
                     dbsetfilter(COMPILE(filter),filter),dbgobottom())

        (::hd_file)->ncisprocen := procenhd_w->ncisprocen+1
        (::hd_file)->(dbcommit())
      endif

      aeval(it_vars,{|o| eval(o:block,o:value) })
      * procenit - news
      if len(it_vars) <> 0 .and. (::it_file)->ncisprocen = 0
        mh_copyfld('procenhd','procenit',, .f.)
        filter := format("ntypprocen = %% .and. ncisprocen = %%",{(::hd_file)->ntypprocen,(::hd_file)->ncisprocen})

        procenit_w->(dbclearfilter()          , ;
                     AdsSetOrder('PROCENIT02'), ;
                     dbsetfilter(COMPILE(filter),filter),dbgobottom())

        (::it_file)->npolprocen := procenit_w->npolprocen+1
        (::it_file)->(dbcommit())
      endif

      aeval(ho_vars,{|o| eval(o:block,o:value) })
      * procenho - news
      if len(ho_vars) <> 0 .and. (::ho_file)->ncisprocen = 0
        mh_copyfld('procenit','procenho',, .f.)
      endif
    endif

    (::hd_file)->(dbunlock())
    (::it_file)->(dbunlock())
    (::ho_file)->(dbunlock())

    aeval(::oabro,{|X| x:oxbp:refreshAll()})
  endif
return .t.


* ok
method PRO_procenhd_IN:postDelete()
  local  inFile    := lower(::dc:oaBrowse:cfile)
  local  cMessage  := 'Požadujete zrušit'
  local  cTitle    := 'Zrušení'
  local  cInfo     := str( procenhd->ncisProCen) +'_ ' +allTrim(procenhd->cnazProCen)
  *
  local  anHD := {}, anIT := {}, anHO := {}, nsel, nodel := .f., lLock := .t.
  local  nrec_it, nrec_ho
  *
  local  oDBro_hd := ::oabro[1], oDBro_it := ::oabro[2], oDBro_ho := ::oabro[3]
  local  m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%", filter


  nrec_it := procenit->( recNo())
  nrec_ho := procenho->( recNo())

  oDBro_hd:arselect := {}
  oDBro_it:arselect := {}
  oDBro_ho:arselect := {}

  if      inFile = 'procenhd'
    aadd( oDBro_hd:arselect, proCenhd->(recNo()) )
    oDbro_hd:oxbp:refreshCurrent()

    oDBro_it:is_selAllRec := .t.
    oDbro_it:oxbp:refreshAll()

    oDBro_ho:is_selAllRec := .t.
    oDbro_ho:oxbp:refreshAll()

    filter   := format(m_filter, {(::hd_file)->ntypprocen,(::hd_file)->ncisprocen })
    (::ho_file)->(ads_setAof(filter),dbgotop())

  elseif inFile = 'procenit'
    aadd( oDBro_it:arselect, proCenit->(recNo()) )
    oDbro_it:oxbp:refreshCurrent()

    oDBro_ho:is_selAllRec := .t.
    oDbro_ho:oxbp:refreshAll()

  else
    aadd( oDBro_ho:arselect, proCenho->(recNo()) )
    oDbro_ho:oxbp:refreshCurrent()
  endif


  do case
  case( inFile = 'procenhd' )
    cMessage += ' prodejní ceník ' + CRLF + ;
                  cInfo            + CRLF + ;
                ' vèetne položek a hodnot ...'
    cTitle   += ' prodejního ceníku vèetnì položek a hodnot ...'
    *
    **
    aadd( anHD, procenhd->(recNo()) )
    procenit->( dbgotop(), dbeval( { || aadd( anIT, procenit->(recNo()) ) }) )
    procenho->( dbgotop(), dbeval( { || aadd( anHO, procenho->(recNo()) ) }) )

    lLock    := procenhd->( sx_RLock(anHD)) .and. ;
                procenit->( sx_RLock(anIT)) .and. ;
                procenho->( sx_RLock(anHO))

  case( inFile = 'procenit' )
    cMessage += ' položku prodejního ceníku ' + CRLF + ;
                  cInfo                       + CRLF + ;
                  ' vèetne hodnot ...'
    cTitle   += ' položku prodejního vèetnì hodnot ...'
    *
    **
    aadd(anIT, procenit->( recNo()) )
    procenho->( dbgotop(), dbeval( { || aadd( anHO, procenho->(recNo()) ) }) )

    lLock    := procenit->( sx_RLock(anIT))  .and. ;
                procenho->( sx_RLock(anHO))

  case( inFile = 'procenho' )
    cMessage += ' hodnotu prodejního ceníku ' +CRLF + ;
                  cInfo
    cTitle   += ' hodnotu prodejního ceníku ...'
    *
    **
    aadd( anHO, procenho->(recNo()) )
    lLock    := procenho->( sx_RLock( anHo))
  endcase

  if( procenit->( lastRec()) = 0, nil, procenit->( dbgoto( nrec_it)) )
  if( procenho->( lastRec()) = 0, nil, procenho->( dbgoto( nrec_ho)) )

  if lLock
    nsel := ConfirmBox( , cMessage           , ;
                          cTitle             , ;
                          XBPMB_YESNO       , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
    if nsel = XBPMB_RET_YES
      aeval( anHD, { |x| procenhd->( DbGoTo(x), DbDelete() ) })
      aeval( anIT, { |x| procenit->( DbGoTo(x), DbDelete() ) })
      aeval( anHO, { |x| procenho->( DbGoTo(x), DbDelete() ) })

      procenit->( Ads_RefreshAOF())
      procenho->( Ads_RefreshAOF())

      aeval( ::oabro, { |x| if( x:oxbp:rowPos = 1, x:oxbp:gotop(), nil ) } )

      if( len( anHD) = 0, aeval(::oabro,{|X| x:oxbp:panHome():refreshAll()}), nil )
    endif
  else
    nodel := .t.
  endif

  if nodel
    if .not. lLock
      ConfirmBox( ,'Záznamy prodejního ceníku' +CRLF + ;
                    cInfo                      +CRLF + ;
                   'blokovány uživatelem ...'          , ;
                    cTitle                             , ;
                    XBPMB_CANCEL                       , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    endif
  endif

  procenhd->(dbUnlock(), dbCommit())
   procenit->(dbUnlock(), dbCommit())
    procenho->(dbUnlock(), dbCommit())


  oDbro_hd:arselect     := {}
  oDbro_it:arselect     := {}
  if( oDBro_it:is_selAllRec, ;
    ( oDBro_it:is_selAllRec := .f.,oDBro_it:oxbp:refreshAll()), oDBro_it:oxbp:refreshCurrent() )
  oDbro_ho:arselect     := {}
  if( oDBro_ho:is_selAllRec, ;
    ( oDBro_ho:is_selAllRec := .f.,oDBro_ho:oxbp:refreshAll()), oDBro_ho:oxbp:refreshCurrent() )

  ::drgDialog:dialogCtrl:refreshPostDel()
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
** news
method PRO_procenhd_in:enableItems()
  local typProCen, inBrow := ::inBrow()
/*
  if isobject(::typProCen)
    typProCen := procenhd->ntypprocen

    * procenhd
    (::typProCen:odrg:isEdit := .f.,::typProCen:odrg:oxbp:disable()  )
    (::oznProCen:odrg:isEdit := .f.,::oznProCen:odrg:oxbp:disable())
    (::cisFirmy:odrg:isEdit  := .f.,::cisFirmy:odrg:oxbp:disable() )
    (::zkrMeny:odrg:isEdit   := .f.,::zkrMeny:odrg:oxbp:disable()  )

    * procenit
    do case
    case typProCen > 4
      (::sklPol:odrg:isEdit  := .f.,::sklPol:odrg:oxbp:disable() )
      (::katZbo:odrg:isEdit  := .f.,::katZbo:odrg:oxbp:disable() )
    case procenit->(Eof())
      (::sklPol:odrg:isEdit  := .t.,::sklPol:odrg:oxbp:enable()  )
      (::katZbo:odrg:isEdit  := .t.,::katZbo:odrg:oxbp:enable()  )
    case .not. empty(procenit->csklpol)
      (::sklPol:odrg:isEdit  := .t.,::sklPol:odrg:oxbp:enable()  )
      (::katZbo:odrg:isEdit  := .f.,::katZbo:odrg:oxbp:disable() )
    otherwise
      (::sklPol:odrg:isEdit  := .f.,::sklPol:odrg:oxbp:disable() )
      (::katZbo:odrg:isEdit  := .t.,::katZbo:odrg:oxbp:enable()  )
    endcase

    * procenho
    do case
    case typProCen = 1
      (::proCento:odrg:isEdit  := .f.,::proCento:odrg:oxbp:disable() )
    otherwise
      (::proCento:odrg:isEdit  := .t.,::proCento:odrg:oxbp:enable()  )
    endcase
  endif
*/
return self


method PRO_procenhd_in:showGroup()
  local  x, typ, itm, grp, drgVar, NoEdit := GraMakeRGBColor({221,221,221})
  *
  local  members := ::drgDialog:oForm:aMembers

  for x := 1 to len(members) step 1
    if IsMemberVar(members[x],'groups') .and. .not. Empty(members[x]:groups)
      drgVar := members[x]

      if .not. (::panGroup $ members[x]:groups)
        members[x]:oXbp:hide()
        if( members[x]:ClassName() $ 'drgStatic,drgText', NIL, members[x]:isEdit := .F.)
      else
        members[x]:oXbp:show()
        if( members[x]:ClassName() $ 'drgStatic,drgText', NIL, members[x]:isEdit := .T.)
      endif
    endif
  next
RETURN self


METHOD PRO_procenhd_IN:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x

  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence
RETURN .t.


METHOD PRO_procenhd_IN:copy_crd()
  LOCAL oDialog

  ::drgDialog:pushArea()
  DRGDIALOG FORM 'PRO_procenhd_in_copy_CRD' PARENT ::drgDialog MODAL DESTROY
//  ::drgDialog:popArea()

  ::oabro[1]:oxbp:refreshAll()
//  ::dctrl:oBrowse[1]:refresh(.T.)
//  ::all_itemMarked()

RETURN self





*  Kopírování ceníku
** CLASS for PRO_procenhd_in_copy_CRD *********************************************
CLASS PRO_procenhd_in_copy_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogStart
  METHOD  postValidate, onSave
  method  fir_firmy_sel

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_SAVE
      if ::onSave()
        PostAppEvent(xbeP_Close, nEvent,,oXbp)
      endif
      RETURN .t.

    CASE nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, nEvent,,oXbp)
      RETURN .t.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.


HIDDEN:
*  sys
  var     dm, msg
//  var     msg, dm, dc, df, ib, ab, state, oabro, ocol, drgPush, popState, panGroup

* datové
  var     typProCen, oznProCen, cisFirmy, zkrMeny, nazevFir
//  var     cisSklad, sklPol, katZbo, proCento


ENDCLASS


METHOD PRO_procenhd_in_copy_CRD:init(parent)
  local  filename, filedesc

  ::drgUsrClass:init(parent)
  drgDBMS:open('procenhd',,,,,'procenhdc')
  * tady nevím jestli zap *
  drgDBMS:open('procenhdw',.T.,.T.,drgINI:dir_USERfitm);ZAP
  mh_COPYFLD('procenhd', 'procenhdw', .T.)

RETURN self


METHOD PRO_procenhd_in_copy_CRD:getForm()
  LOCAL oDrg, drgFC
  local n
  LOCAL cVal := ''
  local defOpr
  local typCen

//  defOpr := defaultDisUsr('Forms','CTYPFORMS')

  typCen := ' 1:Prodejní cena            ,2:Množstevní sleva          ,' + ;
            ' 3:Sleva na zboží  -obrat   ,4:Sleva na zboží  -fakturace,' + ;
            ' 5:Sleva na doklad -obrat   ,6:Sleva na doklad -fakturace,' + ;
            ' 7:Maloobchodní cena '

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 128,5 DTYPE '10' TITLE 'Kopie prodejního ceníku' ;
                       GUILOOK 'All:N,Border:Y,Action:N,IconBar:Y:MyIconBar,Menu:Y:myMenuBar';
                       PRE 'preValidate' POST 'postValidate'

  DRGSTATIC INTO drgFC STYPE 14 SIZE 126,4.1 FPOS 1,0.4

    DRGTEXT INTO drgFC CAPTION 'Údaje nového ceníku'  CPOS 2,0.3 CLEN 35 PP 3// FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'èísloCeníku' CPOS 2,1.5 CLEN 10
     DRGGET procenhdw->ncisProCen INTO drgFC  FPOS 2,2.6 FLEN 10

    DRGTEXT INTO drgFC CAPTION 'Typ prod.ceníku'  CPOS 14,1.5 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGCOMBOBOX procenhdw->ntypprocen  INTO drgFC FPOS 14,2.6 FLEN 15 VALUES typCen PP 2

    DRGTEXT INTO drgFC CAPTION 'Ozn.ceníku'  CPOS 30,1.5 CLEN 10 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET procenhdw->coznprocen   INTO drgFC FPOS 30,2.6 FLEN 10 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Název ceníku'  CPOS 42,1.5 CLEN 31 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET procenhdw->cnazprocen   INTO drgFC FPOS 42,2.6 FLEN 30 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

    DRGTEXT INTO drgFC CAPTION 'Èíslo firmy'  CPOS 74,1.5 CLEN 10 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET procenhdw->ncisfirmy   INTO drgFC FPOS 74,2.6 FLEN 10 PP 2 // PUSH fir_firmy_sel
     oDrg:push := 'fir_firmy_sel'

    DRGTEXT INTO drgFC CAPTION 'Název firmy'  CPOS 86,1.5 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGTEXT procenhdw->cnazev   INTO drgFC CPOS 86,2.6 CLEN 20 PP 2 // PUSH fir_firmy_sel

    DRGTEXT INTO drgFC CAPTION 'Platnost OD'  CPOS 108,1.5 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
     DRGGET procenhdw->dplatnyod  INTO drgFC FPOS 108,2.6 FLEN 13 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
     oDrg:push := 'clickdate'

/*

    TYPE(TEXT)     NAME(procenhd->ncisProCen)          CLEN(11) CAPTION(èísloCeníku)
    TYPE(COMBOBOX) NAME(procenhd->ntypprocen) FLEN(20) VALUES(1:Prodejní cena             , ;
                                                              2:Množstevní sleva          , ;
                                                              3:Sleva na zboží  -obrat    , ;
                                                              4:Sleva na zboží  -fakturace, ;
                                                              5:Sleva na doklad -obrat    , ;
                                                              6:Sleva na doklad -fakturace, ;
                                                              7:Maloobchodní cena           ) CAPTION(prodejní ceník)

    TYPE(GET)      NAME(procenhd->coznprocen) FLEN(15)          CAPTION(oznCeníku)
    TYPE(GET)      NAME(procenhd->cnazprocen) FLEN(30)          CAPTION(název ceníku)
    TYPE(GET)      NAME(procenhd->ncisfirmy)  FLEN( 7)          CAPTION(firma)         PUSH(fir_firmy_sel)
    TYPE(TEXT)     NAME(procenhd->cNazev)     CLEN(25)          CAPTION(název firmy)
    TYPE(TEXT)     NAME(       M->zkrProdej)  CLEN( 5)          CAPTION(prod)
    TYPE(GET)      NAME(procenhd->czkratmeny) FLEN( 7)          CAPTION(mìna)
    TYPE(GET)      NAME(procenhd->dplatnyod)  FLEN(12)          CAPTION(platn_od)      PUSH(clickdate)
    TYPE(GET)      NAME(procenhd->dplatnydo)  FLEN(12)          CAPTION(platn_do)      PUSH(clickdate)




  DRGTEXT INTO drgFC CAPTION 'Typ formuláøe'  CPOS 2,1.6 CLEN 15 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGCOMBOBOX FORMSw->CTYPFORMS  INTO drgFC FPOS 2,2.6 FLEN 15 VALUES defOpr PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Id formuláøe'  CPOS 20,1.6 CLEN 21 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET FORMSw->CIDFORMS   INTO drgFC FPOS 20,2.6 FLEN 20 PP 2 //PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2
  DRGTEXT INTO drgFC CAPTION 'Název formuláøe'  CPOS 45,1.6 CLEN 20 // FCAPTION 'Distribuèní hodnota' CPOS 1,2
   DRGGET FORMSw->CFORMNAME  INTO drgFC FPOS 45,2.6 FLEN 50 PP 2//PUSH osoby// FCAPTION 'Distribuèní hodnota' CPOS 1,2

*/
RETURN drgFC


METHOD PRO_procenhd_in_copy_CRD:drgDialogStart(drgDialog)
  local typ, cval, nval
  local cky
  *
  local o_typProCen
  local o_cisProCen


  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager

//  ::dm:refresh()

  cky := strZero( procenhd->ntypprocen,5)
  procenhdc ->(AdsSetOrder('PROCENHD02'), dbsetScope(SCOPE_BOTH,cky), dbgoBottom())

  nval := procenhdc->ncisprocen+1
  ::dataManager:set("procenhdw->ncisprocen", nval)

  ::typProCen := ::dm:get('procenhdw->ntypprocen', .f.)
  ::oznProCen := ::dm:get('procenhdw->coznprocen', .f.)
  ::cisFirmy  := ::dm:get('procenhdw->ncisfirmy' , .f.)
  ::zkrMeny   := ::dm:get('procenhdw->czkratmeny', .f.)
  ::nazevFir  := proCenhdW->cnazev

  o_typProCen := ::dm:get('procenhdw->ntypprocen', .f. )
  o_typProCen:odrg:isEdit := .f.
  o_typProCen:odrg:oxbp:disable()
  o_cisProCen := ::dm:get('procenhdw->ncisProCen', .f. )
  o_cisProCen:odrg:isEdit := .f.
  o_cisProCen:odrg:oxbp:disable()

/*
  typ   := defaultDisUsr('Forms', 'DEFAULTOPR')

  cval  := newIDforms(typ)
  ::dataManager:set("formsw->cidforms", cval)

*/

RETURN self


METHOD PRO_procenhd_in_copy_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval


  do case
  case( name = 'procenhdw->ncisfirmy' .and. changed )
    lok := ::fir_firmy_sel()
  endCase

/*
  do case
  case(name = 'formsw->ctypforms')
    if !Empty( value) .and. changed
      cval := newIDforms(value)
      ::dataManager:set("formsw->cidforms", cval)
    endif

  case(name = 'formsw->cidforms')
    if !Empty( value) .or.  changed
      if FORMSc->(dbSeek(Upper(value),, AdsCtag(1) ))
         drgNLS:msg('Pod tímto ID již sestava existuje ...')
         lOK := .F.
      endif
    endif

  case(name = 'formsw->cformname')
    if Empty( value)
      drgNLS:msg('Název sestavy je povinný údaj ...')
      lOk := .F.
    endif

  endcase
*/


//  if( changed .and. .not. ::changeFRM, ::changeFRM := .T., NIL)

  ** ukládáme pøi zmìnì do tmp **
//  if(lOK, ::msg:writeMessage(), NIL)
//  if( changed, ::dm:refresh(.T.), NIL )

RETURN lOk



METHOD PRO_procenhd_in_copy_CRD:onSave()
  local filter
  local newRec
  local key
  local ok := .t.

  drgDBMS:open('procenhd',,,,,'procenhdt')
  ::dm:save()

  key := strzero(procenhdw->nTypProCen,5)+strzero(procenhdw->ncisfirmy,5)+upper(procenhdw->czkratmeny)   ;
             +if(empty(procenhdw->dPlatnyOD) ,'        ' , DTOS(procenhdw->dPlatnyOD))

  if procenhdt ->( dbSeek( key,,'PROCENHD06'))
    drgMsgBox(drgNLS:msg('Prodejní ceník s tímto klíèem již existuje !!!!'))
    ok := .f.
  else

    drgDBMS:open('procenit',,,,,'procenitc')
    drgDBMS:open('procenho',,,,,'procenhoc')

    drgNLS:msg('Kopírují prodejní ceník ...')


    oSession_data:beginTransaction()
    BEGIN SEQUENCE

      filter   := format("NTYPPROCEN = %% .and. NCISPROCEN = %%", {procenhd->ntypprocen, procenhd->ncisprocen })
      procenitc ->(ads_setAof(filter),dbgotop())

      do while .not. procenitc->( Eof())
        mh_COPYFLD('procenitc', 'procenit', .T.)

        procenit->ntypprocen := procenhdw->ntypprocen
        procenit->ncisprocen := procenhdw->ncisprocen
        procenit->ncisfirmy  := procenhdw->ncisfirmy
        procenit->coznprocen := procenhdw->coznprocen

        procenitc->( dbSkip())
      enddo

      filter   := format("NTYPPROCEN = %% .and. NCISPROCEN = %%", {procenhd->ntypprocen, procenhd->ncisprocen })
      procenhoc ->(ads_setAof(filter),dbgotop())

      do while .not. procenhoc->( Eof())
        mh_COPYFLD('procenhoc', 'procenho', .T.)

        procenho->ntypprocen := procenhdw->ntypprocen
        procenho->ncisprocen := procenhdw->ncisprocen
        procenho->ncisfirmy  := procenhdw->ncisfirmy

        procenhoc->( dbSkip())
      enddo

      mh_COPYFLD('procenhdw', 'procenhd', .T.)
      procenhd->cnazev := ::nazevFir

      procenitc ->( ADS_clearaof())
      procenhoc ->( ADS_clearaof())

      procenhd ->( dbCommit())
      procenit ->( dbCommit())
      procenho ->( dbCommit())

      oSession_data:commitTransaction()

    RECOVER USING oError
      oSession_data:rollbackTransaction()

    END SEQUENCE
  endif

RETURN ok


method PRO_procenhd_in_copy_CRD:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('procenhdw->cnazev', firmy->cnazev)
    ::nazevFir := firmy->cnazev
  endif

return (nexit != drgEVENT_QUIT) .or. ok