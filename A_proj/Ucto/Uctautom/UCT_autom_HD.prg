#include "Common.ch"
#include "Gra.ch"
#include "drg.ch"
#include "XBP.Ch"
#include "appevent.ch"

#include "DRGres.Ch'
*
#include "..\Asystem++\Asystem++.ch"

*
** CLASS for FRM UCT_autom_HD **************************************************
CLASS UCT_autom_HD FROM drgUsrClass
EXPORTED:
  method  init
  method  eventHandled, drgDialogStart, itemMarked, tabSelect
  method  postChangeObdobi
  method  postValidate, postSave
  *
  method  post_drgEvent_Refresh

  * položky - bro
  inline access assign method isActive() var isActive
    return if(autom_hd->lset_aut, MIS_ICON_OK, 0)

  inline method info_in_msgStatus()
    local  cval, o_msg := ::msg:msgStatus, oPS
    local  ncolor, cinfo
    *
    local  curSize  := o_msg:currentSize()
    local  paColors := { { graMakeRGBColor( {  0, 183, 183} ), graMakeRGBColor( {174, 255, 255} ) }, ;
                         { graMakeRGBColor( {255, 255,  13} ), graMakeRGBColor( {255, 255, 166} ) }, ;
                         { graMakeRGBColor( {251,  51,  40} ), graMakeRGBColor( {254, 183, 173} ) }  }

    o_msg:setCaption( '' )

    do case
    case( ::lzavren )
      ncolor := 3
      cinfo  := 'Pracujete v uzavøeném úèetním odbobí, data nelze zmìnit ...'

    case( ::nrok_last    > ::nrok .or. ;
          ::nobdobi_last > ::nobdobi   )
      ncolor := 2
      cinfo  := 'Zmìna nastavení zruší aktualizace úèetních dat ...'

    otherwise
      ncolor := 1
      cinfo  := 'Nastavení automatických operací pro aktuálni období ...'
    endcase

    oPS := o_msg:lockPS()
    GraGradient( ops, {  0, 0 }    , ;
                      { curSize }, paColors[ncolor], GRA_GRADIENT_HORIZONTAL )
    graStringAT( ops, { 20, 4 }, cinfo )
    o_msg:unlockPS()
    return

HIDDEN:
  method  showGroup, postLastField
  var     nrok_last, nobdobi_last
  var     nrok     , nobdobi     , main_ky
  var     msg, dc, dm, df, brow, aEdits, panGroup, members
  var     state      // 0 - inBrowse  1 - inEdit  2 - inAppend
  var     lzavren    // indikce pro zavøené období, nic nejde zmìnit
  *
  var     members_NV, members_VR, members_SR, members_ZR


  inline method restColor()
    local members := ::df:aMembers
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.

  inline method setFocus(nbro)
    local  posBro

    for posBro := 1 to len(::members) step 1
    BEGIN SEQUENCE
      if ::members[posBro] = ::brow[nbro]
    BREAK
      endif
    END SEQUENCE
    next

    ::df:olastdrg   := ::brow[nbro]
    ::df:nlastdrgix := posBro
    ::df:olastdrg:setFocus()
    SetAppFocus(::brow[nbro]:oxbp)
  return .t.

  inline method setChange()
    autom_hd->( DbSetScope(SCOPE_BOTH, ::main_ky +left(::panGroup,1)), DbGoTop() )
    ::itemMarked()

    ::setFocus(1)
    ::dc:oaBrowse := ::brow[1]
    ::brow[1]:oxbp:refreshAll()
    PostAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oXbp)
    return .t.

  inline method setEdits()
    local  members := ::df:aMembers
    local  nIn

    BEGIN SEQUENCE
      for nin := 1 to len(members) step 1
        if members[nin]:isEdit .and. members[nin]:groups = ::panGroup
    BREAK
        endif
      next
    END SEQUENCE
    ::df:setNextFocus( members[nin],,.t. )
    return .t.

  inline method ucetsys_ks()
    local  anUc := {}

    ucetSys_Ax ->( ordSetFocus( 'UCETSYS3' ), dbseek( 'U' +::main_ky ))

    do while .not. ucetSys_Ax->( eof())
      if( ucetsys_Ax->nAKTUc_KS = 2, AAdd(anUc, ucetsys_Ax->(recNo())), nil )
      ucetSys_Ax->( dbskip())
    enddo

    if ucetSys_Ax->(sx_rlock(anUc))
      AEval(anUc, {|x| ( ucetSys_Ax ->(dbGoTo(x))          , ;
                         ucetSys_Ax ->nAKTUc_KS := 1       , ;
                         ucetSys_Ax ->cuctKdo   := logOsoba, ;
                         ucetSys_Ax ->ductDat   := date()  , ;
                         ucetSys_Ax ->cuctCas   := time()    ) })
    endif

    ucetSys_Ax->(dbCommit(), dbUnlock())
    return


ENDCLASS


METHOD UCT_autom_HD:eventHandled(nEvent, mp1, mp2, oXbp)
  local  lOk    := .t.
  local  inFile := ::dc:oaBrowse:cfile, currRec, cKy
//  local  inFile := lower(alias(::dc:dbArea)), curRec, cKy


  do case
  case( nevent = xbeP_KillInputFocus )
    ::info_in_msgStatus()

  case(nEvent = drgEVENT_EDIT)
    if .not. ::lzavren
      ::state := 1
      ::setEdits()
    endif
    return .t.

  case(nEvent = drgEVENT_APPEND)
    if .not. ::lzavren
      ::state := 2
      ::dm:refreshAndSetEmpty( inFile )

      ::setEdits()
    endif
    return .t.

  case(nEvent = drgEVENT_DELETE )
    if  .not. ::lzavren
      cKy := 'Zrušit ' +if(inFile = 'autom_hd', 'nastavení ', 'položku ') +'automatu ' +CRLF + ;
             '( ' +allTrim(autom_hd->cnaz_aut)  + ' pro období _ ' ;
                   +str   (autom_hd->nrok)      + '/'   ;
                   +strZero(autom_hd->nobdobi,2)+ ' )'

      if drgIsYesNo(cKy)
        if inFile = 'autom_hd'
          autom_it->( dbEval( { || if( autom_it->(DbRLock()), Nil, lOk := .F. ) } ))
          if( autom_hd->( DbRLock()) .and. lOk )
            autom_it->( dbEval( { || autom_it->( dbDelete()) } ))
            autom_hd->( dbDelete())
          endif
        else
          if( autom_it->(dbRlock()), autom_it->(dbDelete()), nil)
        endif

        ( autom_hd->( DbUnlock()), autom_it->( DbUnlock()) )
      endif

      ::dc:oaBrowse:oxbp:panHome()
      ::dc:oaBrowse:oxbp:refreshAll()
      ::dm:refresh()
    endif
    return .t.

  case( nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT)
    ::restColor()
    ::postLastField(inFile)
    return .t.

  case(nEvent = xbeP_Keyboard)
    if mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
      ::df:setNextFocus(AScan(::members, ::dc:oaBrowse),, .T. )
      ::restColor()

      setAppFocus(::dc:oaBrowse:oxbp)
      ::dm:refresh()
      return .t.
    else
      return .f.
    endif

  OTHERWISE
    RETURN .F.
  ENDCASE
RETURN .T.


method UCT_autom_HD:init(parent)
  ::drgUsrClass:init(parent)

  ::nrok_last    := uctOBDOBI_LAST:UCT:nrok
  ::nobdobi_last := uctOBDOBI_LAST:UCT:nobdobi

  ::nrok         := uctOBDOBI:UCT:nrok
  ::nobdobi      := uctOBDOBI:UCT:nobdobi
  ::lzavren      := uctOBDOBI:UCT:lzavren
  ::main_ky      := strZero(::nrok,4) +strZero(::nobdobi,2)

  drgDBMS:open( 'ucetsys',,,,,'ucetSys_Ax')
  drgDBMS:open( 'autom_hd')
  drgDBMS:open( 'autom_it')

  ucetSys_Ax ->( ordSetFocus( 'UCETSYS3'), DbSetScope(SCOPE_BOTH, 'U' +strZero(::nrok,4)), DbGoTop() )
  autom_hd   ->( DbSetScope(SCOPE_BOTH, ::main_ky +'1'), DbGoTop() )
  autom_it   ->( DbSetScope(SCOPE_BOTH, ::main_ky +strZero(autom_hd->ntyp_Aut,1)), DbGoTop())
return self


method UCT_autom_HD:drgDialogStart(drgDialog)
  Local  x, members

  ::aEdits     := {}
  ::panGroup   := '1:1'
  ::members    := drgDialog:oForm:aMembers
  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::brow       := drgDialog:odbrowse                // browses
  *
  ::msg:can_writeMessage := .f.
  ::msg:msgStatus:paint  := { |aRect| ::info_in_msgStatus(aRect) }
  *
  ::members_NV := {}
  ::members_VR := {}
  ::members_SR := {}
  ::members_ZR := {}

  for x := 1 to len(::members) step 1
    if ::members[x]:ClassName() = 'drgStatic' .and. AT(':',::members[x]:groups) <> 0
      AAdd(::aEdits, { ::members[x]:groups, x, ::members[x]:oxbp, ::members[x]:oxbp:currentSize() })
    endif
  next

  members := ::members

  for x := 1 to len(members) step 1
    if members[x]:classname() = 'drgPushButton'
      do case
      case isobject(members[x]:oxbp:cargo) .and. members[x]:oxbp:cargo:classname() = 'drgGet'
        odrg := members[x]:oxbp:cargo

      case members[x]:event = 'memoEdit'
        members[x]:isEdit := .f.
      endcase
    else
      odrg := members[x]
    endif

    groups := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    name   := if( ismemberVar(members[x],'name'  ), isnull(members[x]:name  ,''), '')

    do case
    case empty(groups) .or. at( ':', groups) = 0
      aadd(::members_NV,members[x])
      aadd(::members_VR,members[x])
      aadd(::members_SR,members[x])
      aadd(::members_ZR,members[x])
    otherwise
      groups := val( left( groups,1))

      do case
      case( groups = 1 )  ;  aadd(::members_NV,members[x])
      case( groups = 2 )  ;  aadd(::members_VR,members[x])
      case( groups = 3 )  ;  aadd(::members_SR,members[x])
      case( groups = 4 )  ;  aadd(::members_ZR,members[x])
      endcase
    endcase
  next

  aeval( ::aEdits, {|pa| pa[3]:Hide() }, 2 )
  ::setFocus(1)
return self


method UCT_autom_HD:postChangeObdobi()
  ::nrok    := uctOBDOBI:UCT:nrok
  ::nobdobi := uctOBDOBI:UCT:nobdobi
  ::lzavren := uctOBDOBI:UCT:lzavren
  ::main_ky := strZero(::nrok,4) +strZero(::nobdobi,2)

  ucetSys_Ax ->( ordSetFocus( 'UCETSYS3'), DbSetScope(SCOPE_BOTH, 'U' +strZero(::nrok,4)), DbGoTop() )

  ::setChange()
  ::info_in_msgStatus()
return self


method UCT_autom_HD:itemMarked()
  Local  cKy := ::main_ky +strZero(autom_hd->ntyp_Aut,1) +strZero(autom_hd->nsub_aut,2)

  if(cKy <> autom_it->( DbScope(SCOPE_TOP)), autom_it->(DbSetScope(SCOPE_BOTH, cKy), DbGoTop()), NIL )
  ::panGroup := LEFT(::panGroup,2) +'1'
  ::showGroup()
return self


method UCT_autom_HD:tabSelect(drgTabPage, tabNum)
  Local oBrowse := ::drgDialog:dialogCtrl:oBrowse
  *
  local  o_tabs, x

  o_tabs := ::df:tabPageManager:members
  for x := 1 to len(o_tabs) step 1
    o_tabs[x]:oxbp:setColorFG(GRA_CLR_BLACK)
  next

  ::panGroup := STR(tabNum,1) +':1'
  ::setChange()
return .t.


method UCT_autom_hd:post_drgEvent_Refresh()
  local group := left(::panGroup,2) + ::dc:oaBrowse:groups

  if( ::panGroup <> group, (::panGroup := group, ::showGroup(group)), nil )
return self


method UCT_autom_hd:postValidate(drgVar)
  local  lOk   := .t.
  local  name  := lower(drgVAR:name)
  local  cfile := lower(drgParse(name,'-'))
  local  group := left( ::panGroup,1)
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  last_it

  if lower(::dc:oaBrowse:cfile) = 'autom_hd'
    last_it := 'autom_hd->cuctyuc_nv,autom_hd->crozpuc_vr,autom_hd->crozpuc_sr,autom_hd->crozpuc_zr'
  else
    last_it := 'autom_it->' +if( group = '1', 'cmrozp_co', 'cmrozp_kam' )
  endif

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  if(name $ last_it)
    if ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
**    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      ::postLastField(cfile)
    endif
  endif
return lok

*
**
method UCT_autom_HD:showGroup( old_panGroup )
  local  x, nIn, new_panGroup := ::panGroup
  *
  local  members := ::df:amembers
  local  groups  := val( left( ::panGroup,1))

  ::members := members := if( groups = 1, ::members_NV  , ;
                           if( groups = 2, ::members_VR , ;
                            if( groups = 3, ::members_SR, ::members_ZR )))

  avars := drgArray():new()
  for x := 1 to len( members ) step 1
    if ismembervar(members[x],'ovar') .and. isobject(members[x]:ovar)
      if members[x]:ovar:className() = 'drgVar'
        avars:add( members[x]:ovar, lower( members[x]:ovar:name ))
      endif
    endif
  next

  ::df:aMembers := members      // members
  ::dm:vars     := avars        // drgVar

  aeval( ::aEdits, { |pa| if( pa[1] = new_panGroup, pa[3]:Show(), pa[3]:Hide() ) })
return self


method UCT_autom_HD:postLastField(cfile)
  local  lZMENa  := ::dm:changed()
  local  recNo   := (cfile)->(recNo()), pa := listAsArray(::panGroup,':')
  local  sub_aut := (cfile)->nsub_aut , x, o_nazpolX, value, values

  * ukládáme autom_hd - autom_it na posledním PRVKU hale jen pokud to jde
  if .not. ::lzavren
    if lower(cfile) = 'autom_hd'
      for x := 1 to len(::members) step 1
        if IsMemberVar(::members[x],'groups') .and. At(':',IsNull(::members[x]:groups,'')) <> 0
          if ::members[x]:groups = ::panGroup .and. ::members[x]:className() = 'drgComboBox'
            if( lower(::members[x]:name) = 'autom_hd->cnazpolx')
              o_nazpolX := ::members[x]
            endif
          endif
        endif
      next

      (cfile)->(dbGoBottom())
      sub_aut := (cfile)->nsub_aut +1
      (cfile)->(dbGoto(recNo))
    endif

    if((cfile)->(eof()), ::state := 2, nil)

    if lZMENa .and. If( ::state = 2, ADDrec(cfile), REPLrec(cfile))

      ::postSave(::panGroup)
      *
      (cfile)->nrok     := ::nrok
      (cfile)->nobdobi  := ::nobdobi
      (cfile)->cobdobi  := strZero(::nobdobi,2) +'/' +right(str(::nrok,4),2)
      (cfile)->ntyp_aut := val(pa[1])
      if ::state = 2
        (cfile)->nsub_aut := if(lower(cfile) = 'autom_hd', sub_aut, autom_hd->nsub_aut)
      endif

      if isObject(o_nazpolX)
         value  := o_nazpolX:value
         values := o_nazpolX:values
         x      := ascan(values, {|X| X[1] = value })
         if( x <> 0, (cfile)->cnazpol := values[x,2], nil)
      endif

      (cfile)->(dbUnlock(), dbCommit())
      ::ucetsys_ks()
    endif
  endif

  ::dc:oaBrowse:oxbp:panHome()
  ::dc:oaBrowse:oxbp:refreshAll()
  ::dm:refresh()
  ::df:setNextFocus(AScan(::members, ::dc:oaBrowse),, .T. )
return .t.


method UCT_autom_hd:postSave(panGroup)
  local  x, ok := .t., vars := ::dm:vars, drgVar

  for x := 1 to ::dm:vars:size() step 1
    drgVar := ::dm:vars:getNth(x)
    if ISCHARACTER(panGroup)
      ok := (empty(drgVar:odrg:groups) .or. drgVar:odrg:groups = panGroup)
    endif

    if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok
      if eval(drgvar:block) <> drgVar:value
        eval(drgVar:block,drgVar:value)
      endif
      drgVar:initValue := drgVar:value
    endif
  next
return self