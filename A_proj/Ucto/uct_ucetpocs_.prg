#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetpocs', 'c_uctosn', 'ucetsys' }

*
** CLASS for FRM UCT_ucetpocs_CRD **********************************************
CLASS UCT_ucetpocs_CRD FROM drgUsrClass, fin_finance_in
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart
  method  comboBoxInit, comboItemSelected
  method  postAppend, postValidate, overPostLastField, postLastField
  *
  inline access assign method cnaz_uct()  var cnaz_uct
    c_uctosn->(dbSeek(upper(ucetpocs->cucetmd),, AdsCtag(1) ))
    return c_uctosn->cnaz_uct

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local curRec := (::in_file)->(recNo()), ok, cKy


    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:editState:caption := 0
      ::msg:WriteMessage(,0)
      ::state := 0
      ::o_cdenik:isEdit := .f.

*      if(isobject(::brow), ::brow:hilite(), nil)
      return .f.

    case (nEvent = drgEVENT_APPEND .and. ::lis_openPs)
      ::dm:refreshAndSetEmpty( ::in_file )

      if( isMethod(self, 'postAppend'), ::postAppend(), nil)
      ::state := 2
      ::o_cdenik:isEdit := .t.

      ::brow:refreshCurrent():deHilite()
      ::df:setNextFocus('ucetpocs->cobdobi',, .T. )
      return .t.

    case (nEvent = drgEVENT_EDIT .and. ::lis_openPs)
      ::state := 1
      if (::in_file)->(eof())
        ::brow:refreshCurrent():deHilite()
        ::state := 2
        if( isMethod(self, 'postAppend'), ::postAppend(), nil)
      endif
      ::df:setNextFocus('ucetpocs->cobdobi',, .T. )

    case (nEvent = drgEVENT_SAVE)
      ::ps_restColor()

      if .not. (lower(::df:oLastDrg:classname()) $ 'drgdbrowse') .and. isobject(::brow)
        ok := if(isMethod(self,'overPostLastField'), ::overPostLastField(), .t.)

        if(IsMethod(self, 'postLastField') .and. ok, ::postLastField(), Nil)
      endif
      return .t.

    case (nEvent = drgEVENT_DELETE .and. ::lis_openPs)
      if .not. empty(ucetpocs->cucetMd)
        cKy := 'Zrušit nastavení poèáteèního stavu ' +CRLF + ;
               '( ' +         ucetpocs->cucetMd    + ' pro období _ ' ;
                    +str    (ucetpocs->nrok)      + '/'   ;
                    +strZero(ucetpocs->nobdobi,2) + ' )'

        if drgIsYesNo(cKy) .and. ucetpocs->(dbRlock())
          ucetpocs->(dbDelete())

          ::mod_ucetsys()
          ::dc:oaBrowse:oxbp:panHome()
          ::dc:oaBrowse:oxbp:refreshAll()
          ::dm:refresh()
        endif

        ucetpocs->( DbUnlock())
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
  VAR     nrok, cdenik, in_file, ks_ucetsys
  var     o_obdobi, o_cdenik
  var     osta_openPs, lis_openPs, otp_editPs

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                        , ;
         if(isnull(ordno), nil, (file)->(ordsetfocus( AdsCtag( ordno ))))                            })
  return nil

  * filtr
  inline method setFilter()
    local  m_filter := "nrok = %%" +if( .not. empty(::cdenik), " .and. cdenik = '%%'", '')
    local  filter, x
    local  cScope := 'U' +strZero(::nrok,4), lis_openPs := .t.

    * UCETSYS3
    ucetSys->( ordSetFocus( 'UCETSYS3' )     , ;
               dbsetScope(SCOPE_BOTH, cScope), ;
               dbeval( { || if( ucetSys->lzavren, lis_openPs := .f., nil ) } ), ;
               dbclearScope()                                                     )

    ::lis_openPs := lis_openPs
    ::osta_openPs:oxbp:setCaption( if( ::lis_openPs, 315, 301 ) ) // 301 x  -- 315 tužka

    ::otp_editPs:oxbp:setColorBG( GraMakeRGBColor( if( lis_openPs, {215,255,220}, {192,192,192} ) ))
    ::otp_editPs:oxbp:invalidateRect()
    ::enable_or_disable_items()

    if( .not. empty(ucetpocs->(ads_getaof())), ucetpocs->(ads_clearaof(),dbgotop()), nil)

    if .not. empty(::cdenik)
      filter := format(m_filter,{::nrok,::cdenik})
    else
      filter := format(m_filter,{::nrok})
    endif

    ucetpocs ->(ads_setaof(filter),dbgotop())

    ::brow:refreshAll()

    PostAppEvent(xbeBRW_ItemMarked,,,::brow)
    SetAppFocus(::brow)
    return self

  * modifikace ucetsys
  inline method mod_ucetsys()
    local  filter := Format("culoha = 'U' .and. nrok = %%", {::nrok}), anUc := {}

    if ::ks_ucetsys = 0
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

    ::state := isnull(state,0)

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


  inline method enable_or_disable_items()
    local  x, ok := .t., vars := ::dm:vars, drgVar, odrg
    local  groups := '1'

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
        odrg := drgVar:odrg

      if isblock(drgVar:block) .and. .not. empty( oDrg:groups )

        if oDrg:groups = groups
          if ::lis_openPs
            ( oDrg:isEdit := .t., oDrg:oXbp:enable()  )
          else
            ( oDrg:isEdit := .f., oDrg:oXbp:disable() )
          endif

          if( ismembervar(odrg,'pushGet') .and. isobject(odrg:pushGet))
            odrg:pushGet:disabled := .not. drgVar:odrg:isEdit
          endif
        endif
      endif
    next
    return self


ENDCLASS


method UCT_ucetpocs_crd:init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec    := .f.
  ::cdenik     := 'WP'                 // WP - bìžné úèty PS,  WX - nedVýroba
  ::nrok       := uctOBDOBI:UCT:NROK
  ::in_file    := 'ucetpocs'
  ::state      := 0
  ::ks_ucetsys := 0

  ** základní soubory
  ::openfiles(m_files)
  *
  ** pro kontrolu dulicity
  drgDBMS:open( 'ucetpocs',,,,,'ucet_pocs' )
return self

method UCT_ucetpocs_crd:drgDialogStart(drgDialog)
  local  members := drgDialog:dialogCtrl:members[1]:aMembers
  local  x, odrg

  ::msg      := drgDialog:oMessageBar                // messageBar
  ::dm       := drgDialog:dataManager                // dataManager
  ::dc       := drgDialog:dialogCtrl                 // dataCtrl
  ::df       := drgDialog:oForm                      // form
  ::brow     := drgDialog:dialogCtrl:oBrowse[1]:oXbp

  ::o_obdobi := ::dm:has('ucetpocs->cobdobi'):oDrg
  ::o_cdenik := ::dm:has('ucetpocs->cdenik' ):oDrg

  for x := 1 to len(members) step 1
    odrg    := members[x]

    if members[x]:ClassName() = 'drgStatic'
      if( members[x]:oxbp:type = XBPSTATIC_TYPE_BITMAP, ::osta_openPs := members[x], nil )
    endif

    if( odrg:ClassName() =  'drgTabPage', ::otp_editPs := members[x], nil )
  next

  ::setFilter()
return self


method UCT_ucetpocs_crd:comboBoxInit(drgComboBox)
  local  cname      := lower(drgComboBox:name)
  local  acombo_val := {}
  *
  local  isInit     := .f.

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

    isInit := .t.

  case( 'cobdobi' $ cname )
    if( .not. empty(ucetsys->(ads_getaof())), ucetsys->(ads_clearaof(),dbgotop()), nil)

    filter := Format("culoha = 'U' .and. nrok = %%", {::nrok})
    ucetsys->(DbSetFilter(COMPILE(filter)),DbGoTop(), ;
              DbEval( {|| AAdd(acombo_val, ;
                        { ucetsys->cobdobi                                           , ;
                          StrZero(ucetsys->nobdobi,2) +'/' +StrZero(ucetsys->nrok,4) , ;
                          'U' +StrZero(ucetsys->nrok,4) +StrZero(ucetsys->nobdobi,2) }) }), ;
              DbClearFilter() )

    isInit := .t.

  endcase

  if isInit
    drgComboBox:oXbp:clear()
    drgComboBox:values := ASort( acombo_val,,, {|aX,aY| aX[2] < aY[2] } )
    AEval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )
  endif
return self


method UCT_ucetpocs_crd:comboItemSelected(mp1, mp2, o)

  do case
  case ':nrok' $ lower(mp1:name)
    ::nrok       := mp1:value
    ::ks_ucetsys := 0
    ::setFilter()

    ::comboBoxInit(::o_obdobi)

  case ':cdenik' $ lower(mp1:name)
    ::cdenik := allTrim(mp1:value)
    ::setFilter()

  endcase

  ::ps_setFocus(0)
return .t.


method uct_ucetpocs_crd:postAppend()
  ::dm:set('ucetpocs->ddatZmeny', date())
  ::dm:set('ucetpocs->cdenik'   , 'WP'  )
return .t.


method UCT_ucetpocs_crd:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
  * F4
  local  nevent := mp1 := mp2 := nil

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)


  if(name = ::in_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if( ::overPostLastField(), ::postLastField(), nil )
    endif
  endif
return .t.


*
** kontrola NS - zatím nevím jestli je potøeba zapnout
method UCT_ucetpocs_crd:overPostLastField()
  local  o_nazPol1 := ::dm:has(::in_file +'->cnazPol1')
  local  ucet      := ::dm:get(::in_file +'->cucetMd' )
  local  cky
  local  ok        := .t.

//  ok := ::c_naklst_vld(o_nazPol1,ucet)

  if (::in_file)->(eof()) .or. ::state = 2
    cky := strZero( ::nrok, 4)                    + ;
           upper( ::dm:get( 'ucetpocs->cucetmd' ))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol1'))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol2'))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol3'))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol4'))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol5'))+ ;
           upper( ::dm:get( 'ucetpocs->cnazpol6'))

    if ucet_pocs->(dbseek( cky,,'POCSTU01'))
      fin_info_box('Duplicitní položka pro poèáteèní stav úctu, nelze uložit ...')
      ::df:setNextFocus( 'ucetpocs->cucetmd',, .t.)
      ok := .f.
    endif
  endif
return ok


method UCT_ucetpocs_crd:postLastField(drgVar)
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