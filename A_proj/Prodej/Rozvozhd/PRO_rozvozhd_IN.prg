#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
*
#include "..\Asystem++\Asystem++.ch"

*
**  CLASS for PRO_rozvozhd_SEL *************************************************
CLASS PRO_rozvozhd_SEL FROM PRO_rozvozhd_IN
  exported:

  inline method init( parent )
    parent:formName  := 'PRO_rozvozhd_SEL'
    parent:initParam := 'PRO_rozvozhd_IN'

    ::drgUsrClass:init(parent)

    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

    ::PRO_rozvozhd_IN:init( parent )
  return self
ENDCLASS



*
** CLASS for PRO_procenhd_IN ***************************************************
CLASS PRO_rozvozhd_IN FROM drgUsrClass
  exported:
  var     lNEWrec, hd_file, it_file, drgGet

  method  init, drgDialogStart, drgDialogEnd
  method  createContext, fromContext, comboBoxInit
  method  preValidate, postValidate, postDelete

  * ok
  method  pro_stroje_in, osb_osoby_sel, fir_firmydop_sel, fir_firmy_sel, vyr_vyrzakit_sel
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow
  *
  method  stableBlock
  *
  **
  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
    *

    if IsObject(::drgGet)
      **  XbpDialog:titleBar := .F.
      drgDialog:dialog:drawingArea:bitmap  := 1020
      drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

      if ::drgGet:oxbp:parent:className() = 'XbpCellGroup'
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp:parent, drgDialog:dataAreaSize)
        aPos[1] := 50
        return self
**        ( apos[1] := 50, apos[2] += 24 )
      else
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      endif
      drgDialog:usrPos := {aPos[1],aPos[2]}
    endif
  return self
  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local inFile, obro, ncol

    if rozvozhd->( eof()) // .and. isObject(::oEBro_it)
      ::oEBro_it:enabled_ins := ::oEBro_it:enabled_enter := ::oEBro_it:enabled_del := .f.
    else
      ::oEBro_it:enabled_ins := ::oEBro_it:enabled_enter := ::oEBro_it:enabled_del := .t.
    endif

    do case
    case ( nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT ) .and. isObject(::drgGet)
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

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

    otherwise
      if(::tabNumber = 1)
        do case
        case(nevent = drgEVENT_APPEND)
          inFile := lower(::dc:oaBrowse:cfile)
          return .f.

        case(nevent = drgEVENT_EDIT)
          inFile := lower(::dc:oaBrowse:cfile)
*          ::typProCen:odrg:oxbp:disable()
          return .f.

        case (nEvent = drgEVENT_SAVE)
          if IsObject(oXbp) .and. oXbp:className() = 'XbpGet'
           oXbp:SetColorBG(oXbp:cargo:clrFocus)
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

*          ::df:setNextFocus('cenprodc->ncenCNZbo',,.t.)
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
  var     oEbro_hd, oEBro_it
  var     tabNumber

* datové
  var      stroj, cisOsoby, jmenoRozl, cisFirDop, nazevDop
  var      cisZakazI, nazDodavk, cisFirmy, nazFirmy

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

    brow := if(tabNumber = 1, ::oabro[1], ::oabro[2])
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
    if     (inFile = ::hd_file)  ; ::df:setNextFocus('rozvozhd->ndoklad',,.t.)
    elseif (inFile = ::it_file)  ; ::df:setNextFocus('rozvozit->cciszakazi',,.t.)
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


method PRO_rozvozhd_IN:init(parent)
  local  pa_initParam
  local  filter := "", cfilter

  ::drgUsrClass:init(parent)
  *
  (::hd_file  := 'rozvozhd', ::it_file := 'rozvozit')
  *
  drgDBMS:open('stroje'  )
  drgDBMS:open('osoby'   )
  drgDBMS:open('firmy'   )
  drgDBMS:open('vyrzakit')
  drgDBMS:open('vyrzakpl')

  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
//    cfilter := '(' +filter + ' .and. ' +pa_initParam[2] +')'
    cfilter := '(' +pa_initParam[2] +')'
  else
    cfilter := filter
  endif

  ::drgDialog:set_prg_filter( cfilter, 'procenhd')
return self


method PRO_rozvozhd_IN:drgDialogStart(drgDialog)
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
  ::oEBro_hd  := ::oabro[1]
  ::oEBro_it  := ::oabro[2]

      obro_2  := ::oabro[2]
  xbp_obro_2  := ::oabro[2]:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }
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
  *
  * rozvozhd
  ::stroj      := ::dm:get('rozvozhd->nstroj'    , .f.)
  ::cisOsoby   := ::dm:get('rozvozhd->ncisOsoby' , .f.)
  ::jmenoRozl  := ::dm:get('rozvozhd->cjmenoRozl', .f.)
  ::cisFirDop  := ::dm:get('rozvozhd->ncisFirDop', .f.)
  ::nazevDop   := ::dm:get('rozvozhd->cnazevDop' , .f.)
  *
  ** rozvozit
  ::cisZakazI  := ::dm:get('rozvozit->ccisZakazI', .f.)
  ::nazDodavk  := ::dm:get('rozvozit->cnazDodavk', .f.)
  ::cisFirmy   := ::dm:get('rozvozit->ncisFirmy' , .f.)
  ::nazFirmy   := ::dm:get('rozvozit->cnazFirmy' , .f.)

  * TEST
  ::oabro[1]:oxbp:stableBlock := { |a| ::stableBlock(a) }
  ::oabro[2]:oxbp:stableBlock := { |a| ::stableBlock(a) }

  if( isObject(::drgGet), ::oabro[1]:enabled_enter := ::oabro[1]:enabled_del:= .f., nil )
return self


method PRO_rozvozhd_IN:drgDialogEnd(drgDialog)
return


method PRO_rozvozhd_IN:createContext()
  local csubmenu, opopup, apos, ;
        popUp := 'Všechny rozvozy            ,Nerozvezené           ,' + ;
                 'Èásteènì rozvezené         ,Rozvezené              '

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


method PRO_rozvozhd_IN:fromContext(aorder,nmenu)
  ::popState := aorder
  ::drgPush:oxbp:setCaption(nmenu)
  ::setFilter(aorder-1)
return self


method PRO_rozvozhd_IN:comboBoxInit(drgComboBox)
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


method PRO_rozvozhd_IN:stableBlock(oxbp, lis_ins)
  local m_file, s_filter, filter
  *
  local m_filter := "ndoklad = %%"

  default lis_ins to .f.

  if isobject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    oxbp:cargo:last_ok_rowPos := oxbp:rowPos
    oxbp:cargo:last_ok_recNo  := if( (m_file)->(eof()), 0, (m_file)->(recNo()) )

    do case
    case(m_file = ::hd_file)

      s_filter := (::it_file)->(ads_getAof())
      filter   := format(m_filter, { if( lis_ins, 0, (::hd_file)->ndoklad ) } )

      if .not. Equal(s_filter,filter)
        (::it_file)->(ads_setAof(filter),dbgotop())
        ::oabro[2]:oxbp:refreshAll()
      endif
    endcase
  endif
return self


method PRO_rozvozhd_in:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t.
  *
  local  nevent := mp1 := mp2 := nil, lcanSet := rozvozhd->( eof())

  nevent  := LastAppEvent(@mp1,@mp2)
  if( nevent = drgEVENT_ACTION .and. mp1 = drgEVENT_APPEND, lcanSet := .t., nil)
  if( nevent = xbeP_Keyboard   .and. mp1 = xbeK_DOWN      , lcanSet := .t., nil)

  * procenho
  do case
  case(file = ::hd_file)
*    do case
*    case( name = ::ho_file +'->dplatnyod' )

*      if .not. empty( procenhd->dplatnyod ) .and. lcanSet
*        ::dm:set( name, procenhd->dplatnyod )
*      endif

*    case( name = ::ho_file +'->dplatnydo' )

*      if .not. empty( procenhd->dplatnydo ) .and. lcanSet
*        ::dm:set( name, procenhd->dplatnydo )
*      endif
*    endcase
  case(file = ::it_file)


  endcase
return ok


METHOD PRO_rozvozhd_IN:postValidate(drgVar)
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
  * rozvozhd
  case(file = ::hd_file)
    do case
    case(name = ::hd_file +'->coznprocen' .and. changed)

    case(name = ::hd_file +'->ncisfirmy'  .and. isReturn .and. changed)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratmeny' .and. isReturn )
*---      PostAppEvent(drgEVENT_SAVE,,,drgVar:odrg:oXbp)
*---      PostAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar:odrg:oXbp)
    endcase

  * rozvozit
  case(file = ::it_file)
    do case
    case(name = ::it_file +'->csklpol' .and. isReturn .and. changed)
      if(ok := ::skl_cenzboz_sel())
        ::dm:set(::it_file +'->cnazZbo', cenzboz->cnazZbo)
        (::katZbo:odrg:isEdit  := .f.,::katZbo:odrg:oxbp:disable())
      endif

    case(name = ::it_file +'->nzbozikat' .and. changed)
    endcase
  endcase
RETURN ok

*
** rozvozhd
method pro_rozvozhd_in:pro_stroje_in(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgGet := ::df:olastdrg
  local  name   := lower( drgGet:name )
  local  value  := drgGet:oVar:get()

  ok := stroje->(dbseek( value,,'STROJE01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'PRO_stroje_IN' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. drgGet:ovar:changed()) .or. (nexit != drgEVENT_QUIT))
    drgGet:oxbp:setData( stroje->nstroj )
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_rozvozhd_in:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := osoby->(dbseek( ::cisOsoby:value,,'OSOBY01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisOsoby:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisOsoby:set( osoby->ncisOsoby  )
    ::jmenoRozl:set( osoby->cjmenoRozl)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_rozvozhd_in:fir_firmydop_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirDop:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirDop:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirDop:set(firmy->ncisfirmy)
    ::nazevDop:set( firmy->cnazev   )
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method pro_rozvozhd_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::nazFirmy:set( firmy->cnazev  )
  endif
return (nexit != drgEVENT_QUIT) .or. ok


*
** rozvozit
method pro_rozvozhd_in:vyr_vyrzakit_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := vyrzakit->(dbseek(upper(::cisZakazI:value),,'ZAKIT_4'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'NAK_objvyshd_vyr_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisZakazI:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::cisZakazI:set(vyrzakit->ccisZakazI)
    ::nazDodavk:set(vyrZakit->cnazevZak1)
    ::cisFirmy:set(vyrZakit->ncisFirDoa)
    ::nazFirmy:set(vyrZakit->cnazevDoa)

    ::dm:set( ::it_file +'->ccisZakaz', vyrzakit->ccisZakaz)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


* ok
method pro_rozvozhd_in:ebro_beforeAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky, ok := .t.

  do case
  case (cfile = 'rozvozhd')
*    ::stableBlock(o_ebro:oxbp, .t.)

  case (cfile = 'rozvozit')

  endcase
return ok


method pro_rozvozhd_in:ebro_afterAppend(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'rozvozhd')
    ::stableBlock(o_ebro:oxbp, .t.)
    ::dm:set( 'rozvozhd->ndoklad', rozvozhd->( Ads_GetKeyCount()) +1 )

  case (cfile = 'rozvozit')
  endcase
return .t.


method pro_rozvozhd_in:ebro_saveEditRow(o_ebro)
  local  cfile := lower(o_ebro:cfile), cky

  do case
  case (cfile = 'rozvozhd')

  case (cfile = 'rozvozit')
    if( (::it_file)->ndoklad = 0,  mh_copyfld('rozvozhd','rozvozit',, .f.), nil )

    rozvozit->cnazFirmy := ::nazFirmy:value

    if vyrzakpl->( dbseek( upper( rozvozit->ccisZakazI),, 'ZAKPL_1'))
       if vyrzakpl->( sx_RLock())
         vyrZakpl->nrozvozit  := isNull( rozvozit->sID, 0)

         vyrZakpl->ndoklRozv  := rozvozhd->ndoklad
         vyrZakpl->crozvoz    := rozvozhd->crozvoz
         vyrZakpl->dNakladky  := rozvozit->dNakladky
         vyrZakpl->cCasNaklad := rozvozit->cCasNaklad
         vyrZakpl->dVykladky  := rozvozit->dVykladky
         vyrZakpl->cCasVyklad := rozvozit->cCasVyklad

         vyrZakpl->(dbUnlock(), dbCommit())
       endif
    endif

     if vyrzakit->( dbseek( upper( rozvozit->ccisZakazI),, 'ZAKIT_4'))
       if rozvozit->ncisFirmy <> 0 .and. (vyrzakit->ncisFirDOA <> rozvozit->ncisFirmy)

         if vyrzakit->( sx_RLock())
           firmy->( dbseek( rozvozit->ncisFirmy,,'FIRMY1'))

           vyrzakit->ncisFirDOA  := firmy->ncisFirmy
           vyrzakit->cnazevDOA   := firmy->cnazev
           vyrzakit->culiceDOA   := firmy->culice
           vyrzakit->csidloDOA   := firmy->csidlo
           vyrzakit->cpscDOA     := firmy->cpsc

           vyrZakit->(dbUnlock(), dbCommit())
         endif
       endif
     endif
  endcase
return


* ok
method PRO_rozvozhd_IN:postDelete()
  local  inFile    := lower(::dc:oaBrowse:cfile)
  local  cMessage  := 'Požadujete zrušit'
  local  cTitle    := 'Zrušení'
  local  cInfo     :=  '[ ' +allTrim( str( rozvozhd->ndoklad)) +'_ ' +allTrim(rozvozhd->cnazRozvoz)
  *
  local  anHD := {}, anIT := {}, anPL := {}, nsel, nodel := .f., lLock := .t., x
  local  nrec_it, nrec_ho
  *
  local  oDBro_hd := ::oabro[1], oDBro_it := ::oabro[2]

  nrec_it := rozvozit->( recNo())

  oDBro_hd:arselect := {}
  oDBro_it:arselect := {}

  if      inFile = 'rozvozhd'
    aadd( oDBro_hd:arselect, rozvozhd->(recNo()) )
    oDbro_hd:oxbp:refreshCurrent()

    oDBro_it:is_selAllRec := .t.
    oDbro_it:oxbp:refreshAll()

  elseif inFile = 'rozvozit'
    aadd( oDBro_it:arselect, rozvozit->(recNo()) )
    oDbro_it:oxbp:refreshCurrent()

  endif


  do case
  case( inFile = 'rozvozhd' )
    cMessage += ' rozvozovou trasu '            + CRLF + ;
                  padC( cInfo + ' ]', 35, ' ')  + CRLF + ;
                ' vèetne položek rozvozu ...'
    cTitle   += ' rozvozovou trasu vèetnì položek rozvozu ...'
    *
    **
    aadd( anHD, rozvozhd->(recNo()) )
    rozvozit->( dbgotop())
    do while .not. rozvozit->( eof())
      aadd( anIT, rozvozit->(recNo()) )
      if vyrzakpl->( dbseek( upper( rozvozit->ccisZakazI),, 'ZAKPL_1'))
        aadd( anPL, vyrZakpl->( recNo()) )
      endif

      rozvozit->( dbskip())
    enddo

    lLock    := rozvozhd->( sx_RLock(anHD)) .and. ;
                rozvozit->( sx_RLock(anIT)) .and. ;
                vyrZakpl->( sx_RLock(anPL))

  case( inFile = 'rozvozit' )
    cMessage += ' položku rozvozu .. ' + CRLF + ;
                  cInfo + ' _ pro zakázku _ ' +allTrim(rozvozit->ccisZakazI) +' ]'
    cTitle   += ' položky rozvozu ...'
    *
    **
    aadd(anIT, rozvozit->( recNo()) )
    if vyrzakpl->( dbseek( upper( rozvozit->ccisZakazI),, 'ZAKPL_1'))
      aadd( anPL, vyrZakpl->( recNo()) )
    endif

    lLock    := rozvozit->( sx_RLock(anIT)) .and. ;
                vyrZakpl->( sx_RLock(anPL))

  endcase

  if( rozvozit->( lastRec()) = 0, nil, rozvozit->( dbgoto( nrec_it)) )

  if lLock
    nsel := ConfirmBox( , cMessage           , ;
                          cTitle             , ;
                          XBPMB_YESNO       , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
    if nsel = XBPMB_RET_YES
      aeval( anHD, { |x| rozvozhd->( DbGoTo(x), DbDelete() ) })
      aeval( anIT, { |x| rozvozit->( DbGoTo(x), DbDelete() ) })

      for x := 1 to len(anPL) step 1
        vyrZakpl->( dbgoto(anPL[x]) )

        vyrZakpl->ndoklRozv  := 0
        vyrZakpl->nrozvozit  := 0
        vyrZakpl->crozvoz    := ''
        vyrZakpl->dNakladky  := ctod( '' )
        vyrZakpl->cCasNaklad := ''
        vyrZakpl->dVykladky  := ctod( '' )
        vyrZakpl->cCasVyklad := ''
      next

      rozvozit->( Ads_RefreshAOF())

      aeval( ::oabro, { |x| if( x:oxbp:rowPos = 1, x:oxbp:gotop(), nil ) } )

      if( len( anHD) = 0, aeval(::oabro,{|X| x:oxbp:panHome():refreshAll()}), nil )
    endif
  else
    nodel := .t.
  endif


  if nodel
    if .not. lLock
      ConfirmBox( ,'Záznamy rozvozové trasy '      +CRLF + ;
                    cInfo                          +CRLF + ;
                   'jsou blokovány uživatelem ...'       , ;
                    cTitle                               , ;
                    XBPMB_CANCEL                         , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    endif
  endif

  rozvozhd->(dbUnlock(), dbCommit())
   rozvozit->(dbUnlock(), dbCommit())
    vyrZakpl->(dbUnlock(), dbCommit())

  oDbro_hd:arselect     := {}
  oDbro_it:arselect     := {}
  if( oDBro_it:is_selAllRec, ;
    ( oDBro_it:is_selAllRec := .f.,oDBro_it:oxbp:refreshAll()), oDBro_it:oxbp:refreshCurrent() )

  ::drgDialog:dialogCtrl:refreshPostDel()
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
** news
method PRO_rozvozhd_in:showGroup()
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


METHOD PRO_rozvozhd_IN:postValidateForm()
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