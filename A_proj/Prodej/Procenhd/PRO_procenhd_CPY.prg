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
** CLASS for PRO_procenhd_CPY *******************************************
CLASS PRO_procenhd_CPY FROM drgUsrClass
  exported:
  var     lNEWrec, hd_file, it_file, ho_file

  method  init, drgDialogStart, drgDialogEnd
  method  createContext, fromContext

  method  comboBoxInit, itemMarked
  method  postValidate, postAppend, postSave, postDelete

  * ok
  method  fir_firmy_sel, skl_cenzboz_sel, pro_procenfi_in
  method  ebro_saveEditRow

  * procenit
  inline access assign method cenCNZbo() var cenCNZbo
    local cky := upper(procenit->ccisSklad) +upper(procenit->csklPol)

     cenzboz->(dbseek(cky,,'CENIK03'))
     return cenzboz->ncenCNZbo

  inline access assign method cenaPZbo() var cenaPZbo
    local cky := strZero(procenit->ntypprocen, 5) + ;
                 strZero(procenit->ncisprocen,10) + ;
                 strZero(procenit->npolprocen, 6)

    procenho->(dbseek(cky,,'PROCENHO06'))
    return procenho->ncenaPZbo

  inline access assign method ho_procento() var ho_procento
    local  cky := strZero(procenit->ntypprocen, 5) + ;
                  strZero(procenit->ncisprocen,10) + ;
                  strZero(procenit->npolprocen, 6)

    procenho->(dbseek(cky,,'PROCENHO06'))
    return procenho->nprocento

  inline access assign method hodnota() var hodnota
    local  cky := strZero(procenit->ntypprocen, 5) + ;
                  strZero(procenit->ncisprocen,10) + ;
                  strZero(procenit->npolprocen, 6)

    procenho->(dbseek(cky,,'PROCENHO06'))
    return procenho->nhodnota

  *
  **
/*
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

    otherwise
      if(::tabNumber = 1)
        do case
        case(nevent = drgEVENT_APPEND)
          inFile := lower(::dc:oaBrowse:cfile)
          return .f.

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
            ::msg:writeMessage('Nelze ulo�it zm�ny, blokov�no u�ivatelem ...',DRG_MSG_ERROR)
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
*/

HIDDEN:
*  sys
  var     msg, dm, dc, df, ib, ab, state, oabro, ocol, drgPush, popState, panGroup
  var     in_drgPush, out_drgPush, popUp
  var     tabNumber
  method  enableItems

* datov�
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

      if(ok, ::ab[x]:enable()      , ::ab[x]:disable()      )
      if(ok, ::ab[x]:otext:enable(), ::ab[x]:otext:disable())

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

  * v�po�tov� prvky pro cenprodc
  inline method set_noChanged(drgVar, value)
    drgVar:set( round(value,2))

    drgVar:initValue := drgVar:prevValue := drgVar:Value
    return

  * ukl�d�me cenprodc
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


method pro_procenhd_cpy:init(parent)

  ::drgUsrClass:init(parent)

  drgDBMS:open('procenhd')
  drgDBMS:open('procenit')
  drgDBMS:open('procenho')
  drgDBMS:open('cenzboz' )

  drgDBMS:open('cenprodc')
return self



method PRO_procenhd_cpy:drgDialogStart(drgDialog)
  local  x, arect, apos
  local  members := drgDialog:oForm:aMembers
  *
  local  recNo   := procenhd->(recNo()), caption

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
  ::popUp     := { { 'Z�kladn� cen�k', 1, 0, 0 } }
  do while .not. procenhd->(eof())
    if procenhd->ntypProCen = 1
      aadd(::popUp, { procenhd->cnazProCen, 2, procenhd->ntypProCen, procenhd->ncisProCen })
    endif
    procenhd->(dbskip())
  enddo
  procenhd->(dbgoTo(recNo))

  for x := 1 to len(members) step 1
    do case
    case(members[x]:ClassName() = 'drgPushButton' .and. isCharacter(members[x]:event))
      do case
      case(members[x]:event = 'in_createContext' )
        ::in_drgPush       := members[x]
        ::in_drgPush:event := 'createContext'

      case(members[x]:event = 'out_createContext')
        ::out_drgPush       := members[x]
        ::out_drgPush:event := 'createContext'
      endcase
    endcase
  next

  *
  ::in_drgPush:oXbp:setFont(drgPP:getFont(5))
  ::in_drgPush:oXbp:setColorFG(GRA_CLR_RED)
  ::in_drgPush:isEdit := .f.
  ::in_drgPush:oxbp:setCaption(::in_drgPush:oxbp:caption + ' ' + ::popUp[1,1])

  ::out_drgPush:oXbp:setFont(drgPP:getFont(5))
  ::out_drgPush:oXbp:setColorFG(GRA_CLR_DARKGREEN)
  ::out_drgPush:isEdit := .f.
  ::out_drgPush:oxbp:setCaption(::out_drgPush:oxbp:caption + ' ' + procenhd->cnazProCen)
  *

/*
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
    ::drgPush:oXbp:setColorFG(GRA_CLR_BLUE)

    ::drgPush:isEdit := .f.
  endif

  ::itemMarked(nil,nil,::oabro[1]:oxbp)
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
*/
return self


method PRO_procenhd_cpy:drgDialogEnd(drgDialog)
return


**
static function cpy_browseContext(obj, ix, nMENU, odrg)
return {|| obj:fromContext( ix, nMENU, odrg) }


method PRO_procenhd_cpy:createContext()
  local csubmenu, opopup, apos, asize, xpos, x
  local popup := 'Z�kladn� prodejn� cen�k                           ,' + ;
                 'Akce vina�i podzim 2008                           ,' + ;
                 'Akce listopad-prosinec 2008                       ,' + ;
                 'Akce hadice 2008                                  '
  *
  local pa := listasarray(popUp)
  local nevent := mp1 := mp2 := oxbp := nil

  nevent  := LastAppEvent(@mp1,@mp2,@oxbp)

  csubmenu := drgNLS:msg(popUp)
  opopup   := XbpMenu():new( ::drgDialog:dialog ):create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {drgParse(@cSubMenu), cpy_BrowseContext(self,x,pA[x],oxbp:cargo) } )
  next

  apos    := oXbp:cargo:oxbp:currentPos()
  asize   := ::oabro[1]:oxbp:currentSize()

  xpos    := { apos[1], apos[2] +asize[2] +55 }

  oPopup:popup(::drgDialog:dialog, xPos)

*  opopup:disableItem(::popState)
*  arect := ::ib:obord:currentSize()
*  apos  := {arect[1] -::drgPush:oxbp:currentSize()[1],arect[2]-22}
*  opopup:popup(::ib:obord, {apos[1],apos[2]})
return self


method PRO_procenhd_cpy:fromContext(aorder,nmenu,drgPush)
  local caption := left(drgPush:oxbp:caption,18)
*  ::popState := aorder

  drgPush:oxbp:setCaption(caption + ' ' +nmenu)

*  ::setFilter(aorder-1)
return self


method PRO_procenhd_cpy:comboBoxInit(drgComboBox)
/*
  local  acombo_val := {}

  do case
  case(lower(drgComboBox:name) = 'procenit->czkrtypuhr')
    aadd(acombo_val,{'     ', 'Sleva za doklad' })
    c_typuhr->(dbeval({|| aadd(acombo_val, {c_typuhr->czkrtypuhr, c_typuhr->cpopisuhr})}))

    drgComboBox:oXbp:clear()
    drgComboBox:values := asort( acombo_val,,, {|ax,ay| aX[2] < ay[2] } )
    aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endcase
*/
return self


method PRO_procenhd_cpy:itemMarked(arowcol,unil,oxbp)
  local m_file, s_filter, filter
  *
  local m_filter := "STRZERO(NTYPPROCEN,5) = '%%' .and. STRZERO(NCISPROCEN,10) = '%%'"

// PROCENIT02 - STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)
// PROCENHO06 - STRZERO(NTYPPROCEN,5)+STRZERO(NCISPROCEN,10)+STRZERO(NPOLPROCEN,6)

/*
  if isobject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    do case
    case(m_file = ::hd_file)
      s_filter := (::it_file)->(ads_getAof())
      filter   := format(m_filter, ;
                        {strZero((::hd_file)->ntypprocen, 5), ;
                         strZero((::hd_file)->ncisprocen,10)  } )

      if .not. Equal(s_filter,filter)
        (::it_file)->(ads_setAof(filter),dbgotop())

        ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)
*-        ::showGroup()

        filter := format(filter +" .and. STRZERO(NPOLPROCEN,6) = '%%'",{strZero((::it_file)->npolprocen,6)})
        (::ho_file)->(ads_setAof(filter),dbgotop())
        ::oabro[3]:oxbp:refreshAll()
      endif

    case(m_file = ::it_file)
      s_filter := (::ho_file)->(ads_getAof())
      filter   := format(m_filter +" .and. STRZERO(NPOLPROCEN,6) = '%%'", ;
                        {strZero((::it_file)->ntypprocen, 5), ;
                         strZero((::it_file)->ncisprocen,10), ;
                         strZero((::it_file)->npolprocen, 6)  } )

      if .not. Equal(s_filter,filter)
        (::ho_file)->(ads_setAof(filter),dbgotop())
        ::oabro[3]:oxbp:refreshAll()
      endif
    endcase

    ::enableItems()
  endif
*/
return self

METHOD PRO_procenhd_cpy:postValidate(drgVar)
/*
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nin

  local  cenCNZbo
  local  procMarz, cenaPZbo
  local            cenaMZbo
  local  procMarz1,cenaP1Zbo, procMarz2, cenaP2Zbo, procMarz3, cenaP3Zbo, procMarz4, cenaP4Zbo
  *
  local  o_marzX, pa_marzX := {'nprocmarz1', 'nprocmarz2', 'nprocmarz3', 'nprocmarz4'}
  local  o_cenaX, pa_cenaX := {'ncenap1zbo', 'ncenap2zbo', 'ncenap3zbo', 'ncenap4zbo' }

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  * procenhd
  case(file = ::hd_file)
    do case
    case(name = ::hd_file +'->coznprocen' .and. changed)

    case(name = ::hd_file +'->ncisfirmy'  .and. mp1 = xbeK_RETURN .and. changed)
      ok := ::fir_firmy_sel()

    case(name = ::hd_file +'->czkratmeny' .and. mp1 = xbeK_RETURN)
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,,drgVar:odrg:oXbp)
        PostAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar:odrg:oXbp)
      endif
    endcase

  * procenit
  case(file = ::it_file)
    do case
    case(name = ::it_file +'->csklpol' .and. mp1 = xbeK_RETURN .and. changed)
      if(ok := ::skl_cenzboz_sel())
        (::katZbo:odrg:isEdit  := .f.,::katZbo:odrg:oxbp:disable())
      endif

    case(name = ::it_file +'->nzbozikat' .and. changed)
    endcase

  * procenho
  case(file = ::ho_file)
    do case
    case(name = ::ho_file +'->nhodnota' .and. ::typProCen:value = 1)
*-       .or. (name = ::ho_file +'->nprocento')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif

    case(name = ::ho_file +'->nprocento' .and. mp1 = xbeK_RETURN)
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

    * na posledn�m prvku uk�d�me
    if(item = 'ncenap4zbo')
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        PostAppEvent(drgEVENT_SAVE,,, ::dm:drgDialog:lastXbpInFocus)
      endif
    endif

  endcase
*/
RETURN .t.


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




method pro_procenhd_cpy:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"
/*
  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('M->nazFirmy', firmy->cnazev)
  endif
*/
return (nexit != drgEVENT_QUIT) .or. ok


method pro_procenhd_cpy:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
/*
  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))
    ::dm:set('procenit->ccissklad',cenzboz->ccissklad)
    ::sklPol:set(cenzboz->csklpol)
    ::dm:set('M->nazZbo',cenzboz->cnazzbo)
  endif
*/
return (nexit != drgEVENT_QUIT) .or. ok


method pro_procenhd_cpy:pro_procenfi_in(drgDialog)
/*
  local oDialog
  DRGDIALOG FORM 'PRO_procenfi_IN' PARENT ::drgDialog MODAL DESTROY
*/
return .t.

* ok
method PRO_procenhd_cpy:postAppend(drgEBro,drgVar)
  local typProcen
  local  name    := lower(drgVar:name)
  local  file    := drgParse(name,'-')
  local  changed := drgVAR:changed()

/*
  * procenhd - news
  do case
  case( file = ::hd_file)
    if (::hd_file)->ncisprocen = 0
      typProcen := ::typProCen:value

      filter := format("ntypprocen = %%",{typProcen})
      procenhd_w->(dbclearfilter()          , ;
                   AdsSetOrder('PROCENHD02'), ;
                   dbsetfilter(COMPILE(filter),filter),dbgobottom())

      (::hd_file)->ncisprocen := procenhd_w->ncisprocen+1
      (::hd_file)->(dbcommit())
    endif

  * procenit - news
  case( file = ::it_file)
    do case
    case(name = ::it_file +'->csklpol' .and. changed)
      (::it_file)->ccissklad := cenzboz->ccissklad
    endcase

    if (::it_file)->ncisprocen = 0
      mh_copyfld('procenhd','procenit',, .f.)
      filter := format("ntypprocen = %% .and. ncisprocen = %%",{(::hd_file)->ntypprocen,(::hd_file)->ncisprocen})

      procenit_w->(dbclearfilter()          , ;
                   AdsSetOrder('PROCENIT02'), ;
                   dbsetfilter(COMPILE(filter),filter),dbgobottom())

      (::it_file)->npolprocen := procenit_w->npolprocen+1
    endif
    (::it_file)->(dbcommit())

  * procenho - news
  case( file = ::ho_file)
    if(::ho_file)->ncisprocen = 0
      mh_copyfld('procenhd','procenho',, .f.)
      mh_copyfld('procenit','procenho',, .f.)
      ::state := 2
    endif
    (::ho_file)->(dbcommit())

  endcase
*/
return .t.


method pro_procenhd_cpy:ebro_saveEditRow(o_ebro)
/*
  local  cfile := lower(o_ebro:cfile)

  do case
  case (cfile = 'procenhd')
   if (::hd_file)->ncisprocen = 0
      typProcen := ::typProCen:value

      filter := format("ntypprocen = %%",{typProcen})
      procenhd_w->(dbclearfilter()          , ;
                   AdsSetOrder('PROCENHD02'), ;
                   dbsetfilter(COMPILE(filter),filter),dbgobottom())

      (::hd_file)->ncisprocen := procenhd_w->ncisprocen+1
    endif

  case (cfile = 'procenit')
    if (::it_file)->ncisprocen = 0
      mh_copyfld('procenhd','procenit',, .f.)
      filter := format("ntypprocen = %% .and. ncisprocen = %%",{(::hd_file)->ntypprocen,(::hd_file)->ncisprocen})

      procenit_w->(dbclearfilter()          , ;
                   AdsSetOrder('PROCENIT02'), ;
                   dbsetfilter(COMPILE(filter),filter),dbgobottom())

      (::it_file)->npolprocen := procenit_w->npolprocen+1
    endif

    procenit->ccisSklad := ::cisSklad:value

  case (cfile = 'procenho')
    if(::ho_file)->ncisprocen = 0
      mh_copyfld('procenhd','procenho',, .f.)
      mh_copyfld('procenit','procenho',, .f.)

      aeval(o_ebro:ardef, {|a| eval(a.drgEdit:ovar:block, a.drgEdit:ovar:value) })
    endif

  endcase
*/
return


* tohle p�ijde ven *
method PRO_procenhd_cpy:postSave()
  local  x, ovar, file, filter
  local  hd_vars := {}, hd_modi := .f., hd_lock := .t.
  local  it_vars := {}, it_modi := .f., it_lock := .t.
  local  ho_vars := {}, ho_modi := .f., ho_lock := .t.
/*
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
*/
return .t.


* ok
method PRO_procenhd_cpy:postDelete()
**  ::brow:refreshAll()
return .t.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
** news
method PRO_procenhd_cpy:enableItems()
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


method PRO_procenhd_cpy:showGroup()
  local  x, typ, itm, grp, drgVar, NoEdit := GraMakeRGBColor({221,221,221})
  *
  local  members := ::drgDialog:oForm:aMembers

/*
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
*/
RETURN self


METHOD PRO_procenhd_cpy:postValidateForm()
  local values := ::dm:vars:values, size := ::dm:vars:size(), x
/*
  begin sequence
  for x := 1 to size step 1
    if .not. values[x,2]:odrg:postValidate()
      return .f.
  break
    endif
  next
  end sequence
*/
RETURN .t.