#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetpsnv', 'c_uctosn', 'ucetsys' }

**
** CLASS for FRM UCT_ucetpsnv_CRD **********************************************
CLASS UCT_ucetpsnv_CRD FROM drgUsrClass, fin_finance_in
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  postAppend, postValidate, postLastField
  *
  inline access assign method cnaz_uct()  var cnaz_uct
    c_uctosn->(dbSeek(upper(ucetpsnv->cucetmd),, AdsCtag(1) ))
    return c_uctosn->cnaz_uct

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local curRec := (::in_file)->(recNo()), ok, cKy

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0
      if(isobject(::brow), ::brow:hilite(), nil)
      return .f.

    case (nEvent = drgEVENT_APPEND)
      ::dm:refreshAndSetEmpty( ::in_file )

      if( isMethod(self, 'postAppend'), ::postAppend(), nil)
      ::state := 2
      ::brow:refreshCurrent():deHilite()
      ::df:setNextFocus('ucetpsnv->cobdobi',, .T. )
      return .t.

    case (nEvent = drgEVENT_EDIT)
      ::state := 1
      if (::in_file)->(eof())
        ::brow:refreshCurrent():deHilite()
        ::state := 2
        if( isMethod(self, 'postAppend'), ::postAppend(), nil)
      endif
      ::df:setNextFocus('ucetpsnv->cobdobi',, .T. )

    case (nEvent = drgEVENT_SAVE)
      ::ps_restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgdbrowse') .and. isobject(::brow)
        ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

        if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
      endif
      return .t.

    case (nEvent = drgEVENT_DELETE)
      if .not. empty(ucetpsnv->cucetMd)
        cKy := 'Zrušit nastavení poèáteèního stavu ' +CRLF + ;
               '( ' +         ucetpsnv->cucetMd    + ' pro období _ ' ;
                    +str    (ucetpsnv->nrok)      + '/'   ;
                    +strZero(ucetpsnv->nobdobi,2) + ' )'

        if drgIsYesNo(cKy) .and. ucetpsnv->(dbRlock())
          ucetpsnv->(dbDelete())

          ::mod_ucetsys()
          ::dc:oaBrowse:oxbp:panHome()
          ::dc:oaBrowse:oxbp:refreshAll()
          ::dm:refresh()
        endif

        ucetpsnv->( DbUnlock())
      endif
      return .t.

    case (nEvent = xbeP_Keyboard)
      if mp1 = xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        ::ps_restColor()
        ::df:olastdrg   := ::brow:cargo
        ::df:olastdrg:setFocus()

        postAppEvent(xbeBRW_ItemMarked,,,::brow)
        ::brow:refreshCurrent():hilite()
        return .t.
      endif

    endcase
  return .f.

HIDDEN:
  VAR     msg, dm, dc, df, ab, brow, state
  VAR     nrok, o_obdobi, in_file, ks_ucetsys

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                     , ;
         if(isnull(ordno), nil, (file)->(ordsetfocus( AdsCtag( ordno ))))                        })
  return nil

  * filtr
  inline method setFilter()
    local m_filter := "nrok = %%", filter, x

    if( .not. empty(ucetpsnv->(ads_getaof())), ucetpsnv->(ads_clearaof(),dbgotop()), nil)

    filter := format(m_filter,{::nrok})
    ucetpsnv ->(ads_setaof(filter),dbgotop())

    ::brow:refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::brow)
    SetAppFocus(::brow)
    return self

  * modifikace ucetsys
  inline method mod_ucetsys()
    local  filter := Format("culoha = 'U' .and. nrok = %%", {::nrok}), anUc := {}

    if ::ks_ucetsys = ucetpsnv
      ucetsys->(DbSetFilter(COMPILE(filter)), ;
                DbGoTop()                   , ;
                dbEval( {|| AAdd(anUc, ucetsys->(recNo())) } ))

      if ucetsys->(sx_Rlock(anUc))
        ucetsys->(dbGoTop(), ;
                  dbEval( { || if(ucetsys->naktUc_Ks = 2, ucetsys->naktUc_Ks := 1, nil) } ))
        ::ks_ucetsys := 1
      endif

      ucetsys->(dbUnlock(), dbClearFilter(), dbCommit())
    endif
    return .t.

  inline method ps_restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  inline method ps_setfocus(state)
    local  members := ::df:aMembers, pos, D_bro := ::brow:cargo

    ::state := isnull(state,ucetpsnv)

    do case
    case(::state = 2)
      PostAppEvent(drgEVENT_APPEND,,,::brow)
      SetAppFocus(::brow)
    otherwise
      pos := ascan(members,{|X| (x = D_bro)})
      ::df:olastdrg   := ::brow:cargo
      ::df:nlastdrgix := pos
      ::df:olastdrg:setFocus()
      if isobject(::brow)
        PostAppEvent(xbeBRW_ItemMarked,,,::brow)
        ::brow:refreshCurrent():hilite()
      endif
    endcase
    return .t.

ENDCLASS


method UCT_ucetpsnv_crd:init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec    := .f.
  ::nrok       := uctOBDOBI:UCT:NROK
  ::in_file    := 'ucetpsnv'
  ::state      := 0
  ::ks_ucetsys := 0

* základní soubory
  ::openfiles(m_files)
return self

method UCT_ucetpsnv_crd:drgDialogStart(drgDialog)

  ::msg      := drgDialog:oMessageBar                // messageBar
  ::dm       := drgDialog:dataManager                // dataMabanager
  ::dc       := drgDialog:dialogCtrl                 // dataCtrl
  ::df       := drgDialog:oForm                      // form
  ::brow     := drgDialog:dialogCtrl:oBrowse[1]:oXbp

  ::o_obdobi := ::dm:has('ucetpsnv->cobdobi'):oDrg

  ::setFilter()
return self


method UCT_ucetpsnv_crd:comboBoxInit(drgComboBox)
  local  cname      := lower(drgComboBox:name)
  local  acombo_val := {}

  do case
  case ( 'nrok' $ cname )
    drgComboBox:value := ::nrok
    ucetsys ->(dbgotop()       , ;
               dbeval( { ||      ;
               if( ascan(acombo_val,{|X| x[1] == ucetsys->nrok}) = 0 , ;
                   aadd(acombo_val,{ucetsys->nrok,'ROK _ ' +strzero(ucetsys->nrok,4)}), nil ) }))
    if empty(acombo_val)
      aadd(acombo_val, {::nrok-1, 'ROK _ ' +strzero(::nrok-1,4)})
      aadd(acombo_val, {::nrok  , 'ROK _ ' +strzero(::nrok  ,4)})
    endif

  case( 'cobdobi' $ cname )
    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := Format("culoha = 'U' .and. nrok = %%", {::nrok})
    ucetsys->(DbSetFilter(COMPILE(filter)),DbGoTop(), ;
              DbEval( {|| AAdd(acombo_val, ;
                        { ucetsys->cobdobi                                           , ;
                          StrZero(ucetsys->nobdobi,2) +'/' +StrZero(ucetsys->nrok,4) , ;
                          'U' +StrZero(ucetsys->nrok,4) +StrZero(ucetsys->nobdobi,2) }) }), ;
              DbClearFilter() )
  endcase

  drgComboBox:oXbp:clear()
  drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
  AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
return self


method UCT_ucetpsnv_crd:comboItemSelected(mp1, mp2, o)

  if 'nrok' $ lower(mp1:name)
    ::nrok       := mp1:value
    ::ks_ucetsys := 0
    ::setFilter()

    ::comboBoxInit(::o_obdobi)
  endif
return .t.


method uct_ucetpsnv_crd:postAppend()
  ::dm:set('ucetpsnv->ddatZmeny', date())
return .t.


method UCT_ucetpsnv_crd:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  * F4
  local  nevent := mp1 := mp2 := nil

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  if(name = ::in_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postLastField()
    endif
  endif
return .t.


/*
kontrola NS - zatím nevím jestli je potøeba zapnout
method UCT_ucetpsnv_crd:overPostLastField()
  local  o_nazPol1 := ::dm:has(::in_file +'->cnazPol1')
  local  ucet      := ::dm:get(::in_file +'->cucetMd' )
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok
*/


method UCT_ucetpsnv_crd:postLastField(drgVar)
  local  isChanged := ::dm:changed()
  local  value     := ::o_obdobi:value, values := ::o_obdobi:values, nIn

  * ukládáme na posledním PRVKU *
  if((::in_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::in_file), replReC(::in_file))
    ::dm:save()

    if ::state = 2
      nin    := ascan(values, {|X| X[1] = value })
      obdobi := values[nin,3]

      (::in_file)->nrok    := val(substr(obdobi,2,4))
      (::in_file)->nobdobi := val(substr(obdobi,6,2))

      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  ::mod_ucetsys()
  ::ps_setfocus(::state)
  ::dm:refresh()
RETURN .T.