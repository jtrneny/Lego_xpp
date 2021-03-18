#include "Common.ch"
#include "drg.ch"
#include "dbstruct.ch"

#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
#include "Gra.ch"
//
#include "..\Asystem++\Asystem++.ch"



*   Oprava externího pohybu pvpTerm
*
**  CLASS for SKL_pvpTerm_CRD *************************************************
CLASS SKL_pvpTerm_CRD FROM drgUsrClass
exported:
  method  init
  method  drgDialogInit, drgDialogStart, drgDialogEnd, eventHandled
  method  postLastField
  *
  * cenzboz - ceníková/neceníková položka
  inline access assign method c_nazTypPoh() var c_nazTypPoh
    local  pa_typPoh := { 'Pøíjemka', 'Výdejka', 'Pøevodka' }
    local  typPVP    := (::it_file)->ntypPVP
    return if( typPvp <= len(pa_typPoh), pa_typPoh[typPvp], '???' )

  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0)


  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  acombo_val := {}
    local  typPVP     := (::it_file)->ntypPVP
    local  ccond      := ::pa_typPohybu[ntypPVP] + " and culoha = 'S'"
    *
    if( cname = 'ctyppohybu' )
      c_typPoh->( ads_setAof(ccond), dbgoTop() )

      do while .not. c_typPoh->( eof())
        aadd( acombo_val, {  c_typPoh->ctypPohybu                                                  , ;
                             allTrim(c_typPoh->ctypPohybu) +' _ ' + allTrim(c_typPoh->cnazTypPoh)  } )

        c_typPoh->( dbskip())
      enddo

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value := (::it_file)->ctypPohybu
    endif
    return self


  inline method postValidate(drgVar)
    local  value := drgVar:get()
    local  name  := lower(drgVar:name), field_name := lower(drgParseSecond(drgVar:name, '>'))
    local  ok    := .t., changed := drgVAR:changed(), cc
    *
    local  nevent := mp1 := mp2 := nil, isF4 := .F.

    * F4
    nevent  := LastAppEvent(@mp1,@mp2)
    if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

    do case
    case ( field_Name = 'coperace' )
      if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
        if( ::c_naklst_vld(), ::postLastField(), nil )
      endif
    endCase
  return ok


hidden:
  var     msg, dm, df, dc

  *       pvpTerm
  var     it_file
  var     pa_Gets, pa_typPohybu

  var     sta_activeBro
  *
  **
  inline method itSave(panGroup)
    local  x, ok := .t., vars := ::dm:vars, drgVar

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      if ISCHARACTER(panGroup)
        ok := (empty(drgVar:odrg:groups) .or. drgVar:odrg:groups = panGroup)
      endif

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok
        if (eval(drgvar:block) <> drgVar:value) // .and. .not. drgVar:rOnly
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
    return self


  inline method c_naklst_vld()
    local  drgVar_nazPol1 := ::dm:has( ::it_file +'->cStredisko' )
    *
    local  oDialog, nExit := drgEVENT_QUIT
    local  x, cvalue := ''
    local  ok := .f., showDlg := .f.
    local  pa := ::pa_Gets, pa_pvpTerm_ns := {}

    for x := 2 to len(pa) step 1
      cvalue += upper( ::dm:get( pa[x] ) )
      aadd( pa_pvpTerm_ns, pa[x] )
    next

    do case
    case empty(cvalue)
      ok      := .t.
    otherwise
      ok      := c_naklSt->(dbseek(cvalue,,'C_NAKLST1'))
      showDlg := .not. ok
    endcase

    if showDlg
      odialog           := drgDialog():new('c_naklst_sel',::dm:drgDialog)
      odialog:cargo     := drgVar_nazPol1
      odialog:cargo_Usr := pa_pvpTerm_ns
      odialog:create(,,.T.)

      nExit := odialog:exitState

      if nexit != drgEVENT_QUIT .or. ok
        for x := 2 to len(pa) step 1
          ::dm:set( pa[x], DBGetVal('c_naklSt->cnazPol' +str(x-1,1)))
        next
        postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar_nazPol1:odrg:oxbp)
        ok := .t.
      else
        ::df:setNextFocus(::it_file +'->cStredisko',,.t.)
      endif

      odialog:destroy()
      odialog := nil
    endif
  return ok


  inline method comboSearch(drgCombo,cVal,oXbp)
    local  values := drgCombo:values
    local  search := lower(drgCombo:search +cVal)
    *
    local  nSea   := len(search), pa := {}
    local  oPS, oFont, aAttr := ARRAY(GRA_AS_COUNT), nSize := oxbp:currentSize()[1]

    for x := 1 to len(values) step 1
      if left(lower(values[x,2]),nSea) = search
        AAdd(pa, values[x])
      endif
    next

    do case
    case( len(pa) = 0 )
    otherwise

      drgCombo:search := search
      drgCombo:refresh(pa[1,1])
      oXbp:XbpSle:setMarked({1,nSea})

      ops := oxbp:lockPs()
        aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
        GraSetAttrString( oPS, aAttr )
        GraStringAt( oPS, {4,4}, left(pa[1,2],nsea) )
      oXbp:unlockPS(oPS)
    endcase
  return self

ENDCLASS


method SKL_pvpTerm_CRD:eventHandled(nEvent, mp1, mp2, oXbp)
  local oDialog, nExit, m_file

  do case
  case nEvent = xbeP_Resize
    return .t.

  case nEvent = drgEVENT_SAVE // .or. nevent = drgEVENT_EXIT
    if ::c_naklst_vld()
      ::postLastField()
    else
      return .f.
    endif

  case nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    cenzboz->(ads_clearAof())
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  case nEvent = drgEVENT_FORMDRAWN
     Return .T.

  case nEvent = xbeP_Keyboard

    do case
    case oXbp:className() = 'XbpComboBox'  .and. oxbp:listBoxFocus()

      if ( mp1 > 31 .and. mp1 < 255)
        if oxbp:cargo:className() = 'drgComboBox'
          ::comboSearch(oXbp:cargo,chr(mp1),oXbp)
          PostAppEvent(xbeP_Keyboard,xbeK_ALT_DOWN,,oxbp)
          return .t.
        endif
      endif
      return .f.

    otherwise
      return .f.
    endcase

  otherwise
    return .f.
  endcase
return .t.


method SKL_pvpTerm_CRD:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'cenZboz'  )
  drgDBMS:open( 'c_naklST' )

  ::it_file := 'pvpTerm'
  ::pa_gets := { 'pvpTerm->nmnozDokl1', 'pvpTerm->cStredisko', 'pvpTerm->cVyrobek', 'pvpTerm->cZakazka', ;
                                        'pvpTerm->cVyrMisto' , 'pvpTerm->cStroj  ', 'pvpTerm->cOperace'  }

  * výbìr z c_typPoh dle pvpTerm.ntypPvp
  drgDBMS:open( 'c_typPoh' )
  ::pa_typPohybu := { "( contains( ctypDoklad, 'SKL_PRI*' ) )"                       , ;
                      "( contains( ctypDoklad, 'SKL_VYD*' ) and csubTask = '   ' ) " , ;
                      "( contains( ctypDoklad, 'SKL_PRE*' ) and ctypPohybu <> '40' )"  }

return self


method SKL_pvpTerm_CRD:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog, apos, asize

*  asize := xbpDialog:currentSize()
*  xbpDialog:maxSize := aclone(aSize)
*  xbpDialog:minSize := aclone(aSize)

  drgDialog:dialog:minButton := .f.
  drgDialog:dialog:maxButton := .f.
return


method SKL_pvpTerm_CRD:drgDialogStart(drgDialog)
  local  groups, pa_groups, nin
  *
  local  aMembers := drgDialog:oForm:aMembers
  local  acolors  := MIS_COLORS
  *
  **
  ::msg            := drgDialog:oMessageBar             // messageBar
  ::msg:can_writeMessage := .f.
//  ::msg:msgStatus:paint  := { |aRect| ::post_drgEvent_Refresh(aRect) }

  ::dm             := drgDialog:dataManager             // dataMananager
  ::dc             := drgDialog:dialogCtrl              // dataCtrl
  ::df             := drgDialog:oForm                   // form
  *

  for x := 1 TO LEN(aMembers) step 1
    if aMembers[x]:ClassName() = 'drgStatic'

      if aMembers[x]:oxbp:type = XBPSTATIC_TYPE_ICON
         ::sta_activeBro := aMembers[x]
      endif
    endif

    groups := if( isMemberVar(aMembers[x],'groups'), isnull(aMembers[x]:groups,''), '')

    if 'SETFONT' $ groups
      pa_groups := ListAsArray( groups )
      nin       := ascan(pa_groups,'SETFONT')

      if pa_groups[nin+1] = '11.Segoe Print Bold'
        if( aMembers[x]:ovar:name = 'M->c_nazTypPoh', aMembers[x]:oXbp:setSize( { 120, 35 } ), nil )
      endif

      aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
          aMembers[x]:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        aMembers[x]:oXbp:setColorFG(GRA_CLR_BLUE)
      endif
    endif
  next

  isEditGet( { 'pvpTerm->nmnoz_PLN', 'pvpTerm->ncenaDOKL1', 'pvpTerm->ncenaPZbo', ;
               'pvpTerm->ncenaMZbo', 'pvpTerm->ncenaSZbo' }, drgDialog, .f. )

  ::df:setNextFocus('pvpTerm->nmnozDOKL1',,.t.)
return self


method SKL_pvpTerm_CRD:postLastField()
  local  isChanged     := ::dm:changed()
  *
  ** ukládáme na posledním PRVKU *
  if( isChanged .and. replRec(::it_file) )

    ::dm:save()
    (::it_file)->( dbunlock())
  endif

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,, ::drgDialog:dialog)
return .t.


method SKL_pvpTerm_CRD:drgDialogEnd(drgDialog)

*  (::it_file)->(ads_clearAof())
*  fin_ap_modihd(::hd_file,.t.)
return self