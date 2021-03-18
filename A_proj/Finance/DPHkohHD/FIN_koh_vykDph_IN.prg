#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
//
#include "DRGres.Ch'
#include "XBP.Ch"
#include "dmlb.ch"

//
#include "..\FINANCE\FIN_finance.ch"

#pragma Library( "XppUI2.LIB" )


#xtranslate IsDrgGet(<o>) => IF( IsNull(<o>)  , NIL, ;
                             IF( IsObject(<o>), IF( <o>:className() = 'drgGet', <o>, NIL ), NIL))



*
** CLASS for FIN_koh_vykdph_IN *****************************************************
CLASS FIN_koh_vykdph_IN FROM drgUsrClass
exported:
  var     nFINTYP
  *
  var     mainFile
  var     nosvoddan
  var     nprocdan_3, nzakldan_3, nsazdan_3, odvod_3, narok_3
  var     nprocdan_1, nzakldan_1, nsazdan_1, odvod_1, narok_1
  var     nprocdan_2, nzakldan_2, nsazdan_2, odvod_2, narok_2

  method  init, drgDialogStart, drgDialogEnd, itemMarked, tabSelect, postLastField, fin_cmdph
  method  preValidate, postValidate


  inline access assign method preDanPov() var preDanPov
    return if( vykDph_iw->lsetPreDan, MIS_CHECK_BMP, 0)

  inline access assign method cradek_dph() var cradek_dph
    local  cky := strZero(vykdph_iw ->noddil_dph,2) + ;
                  strZero(vykdph_iw ->nradek_dph,3) + ;
                  strZero(vykdph_iw ->ndat_od,8)

    c_vykdph->(dbSeek(cky,,'VYKDPH4'))
    return(c_vykDph->cradek_say)

  inline access assign method oddil_kohl var oddil_kohl
    local  cky := strZero(vykdph_iw ->noddil_dph,2) + ;
                  strZero(vykdph_iw ->nradek_dph,3) + ;
                  strZero(vykdph_iw ->ndat_od,8)

    c_vykdph->(dbSeek(cky,,'VYKDPH4'))
    return(allTrim(c_vykDph->coddilKohl))


   inline method comboBoxInit(drgCombo)
     local  cname := lower( drgParseSecond(drgCombo:name,'>'))
     local  cKy, acombo_val := {}, cc

     if ( cname = 'coddilkohl' )
       acombo_val := FIN_c_vykdph_coddilKohl()

       drgCombo:oXbp:clear()
       drgCombo:values := ASort( acombo_val,,, {|aX,aY| aX[1] < aY[1] } )
       aeval(drgCombo:values, { |a| drgCombo:oXbp:addItem( a[2] ) } )
     endif
   return self


  inline method ebro_saveEditRow()
    vykdph_iw->npreDanPov := if( vykdph_iw->lsetPreDan, 1, 0)
    ::sum()
    return .t.

  *
  ** event *********************************************************************
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE(nEvent = xbeBRW_ItemMarked)
      RETURN .f.

    case(nevent = drgEVENT_EXIT .or. nevent = drgEVENT_QUIT)
      ::sum()

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var     msg, dm, dc, df

  VAR    typ, subTitle, pa_tabs_typDph
  VAR    obrow, pos_obrow, editPos, drgGet, tabNum, roundDph
  VAR    is_inEdit

  METHOD  sum

ENDCLASS


method FIN_koh_vykDph_IN:init(parent)
  LOCAL  nEvent,mp1,mp2,oXbp
  local  cargo_usr
  *
  local  cky

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
*  ::drgGet := IsDrgGet(oXbp:cargo)
  *
  ::drgUsrClass:init(parent)
  *
  ::typ      := IsNull(parent:parent:UDCP:typ_lik, '')
  ::roundDph := SysConfig('Finance:nRoundDph')
  *
  do case
  case(::typ = 'zav')
    ::subTitle := 'závazkù ...'
    ::mainFile := 'FAKPRIHD'
  case(::typ = 'poh')
    ::subTitle := 'pohledávek ...'
    ::mainFile := 'FAKVYSHD'
  case(::typ = 'pok')
    ::subTitle := 'pokladních dokladù ...'
    ::mainFile := 'POKLADHD'
  case(::typ = 'ucd')
    ::subTitle := 'úèetních dokladù ...'
    ::mainFile := 'UCETDOHD'
  endcase

**
    drgDBMS:open('vykDph_i')

    if( select('vykDph_iW') = 0, nil, vykDph_iW->( dbcloseArea()) )
    if( select('vykDph_iS') = 0, nil, vykDph_iS->( dbcloseArea()) )

    drgDBMS:open('VYKDPH_Iw',.T.,.T.,drgINI:dir_USERfitm); ZAP

    cky := upper( (::mainFile)->cdenik) +strZero( (::mainFile)->ndoklad, 10)

    vykDph_i->( ordSetFocus( 'VYKDPH_1' ), ;
                dbsetScope(SCOPE_BOTH, cky), dbgoTop(), ;
                dbeval( { || mh_copyFld( 'vykDph_i', 'vykDph_iw', .t. ) } ) )

    vykDph_iw->( dbgoTop() )

    * is je pro souètování *
    file_name := vykdph_iw ->( DBInfo(DBO_FILENAME))
                 vykdph_iw ->( DbCloseArea())

    DbUseArea(.t., oSession_free, file_name, 'vykdph_iw', .t., .f.) ; vykdph_iw->(AdsSetOrder(1), Flock())
    DbUseArea(.t., oSession_free, file_name, 'vykdph_is', .t., .t.)
**

  drgDBMS:open('c_vykdph')
  drgDBMS:open('typdokl' )
  typdokl->(dbseek(upper((::mainFile)->ctypdoklad),,'TYPDOKL03'))

  * režim editace/ nebo jen zobrazení
  cargo_usr    := if( ismemberVar( parent, 'cargo_usr'), isnull( parent:cargo_usr, .f.), .f. )
  ::is_inEdit  := cargo_usr
return self


method FIN_koh_vykDph_IN:drgDialogStart(drgDialog)
  local  x, nIn, cfield
  local  aMembers := drgDialog:oForm:aMembers, oColumn, aVar
  *
  local  tabsNum    := IF( IsObject(::drgGet), Right(::drgGet:name,1), '0')
  local  pa_colSize := {}

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form

  ** naplníme M-> z DAT **
  aVar := ::classDescribe(CLASS_DESCR_MEMBERS)

  for x := 1 to len(aVar) step 1
    cfield := aVar[x,CLASS_MEMBER_NAME]
    if (::mainFile) ->(FieldPos(cfield)) <> 0
      self:&cfield :=  DBGetVal(::mainFile +'->' +cFIELD)
    endif
  next

  ::obrow        := ::dc:obrowse[1]:oxbp
  ::obrow:colPos := 3
  ::tabNum       := 1

  * režim editace/ nebo jen zobrazení
  ::dc:obrowse[1]:enabled_enter := ::is_inEdit

  *
  ** pøepneme ho na záložku z pøíslušnou daní
  tabsNum := if( dphKohit->nsazDan_1 <> 0, '1', if( dphKohit->nsazDan_2 <> 0, '2', if( dphKohit->nsazDan_3 <> 0, '3', '0' )))

  if( tabsNum $ '1,2,3' )
    ::tabNum := if( tabsNum = '3', 2, if( tabsNum = '1', 3, 4 ))
    postAppEvent(xbeTab_TabActivate,,, ::df:tabPageManager:members[::tabNum]:oxbp)
  endif

  for x := 1 to ::obrow:colCOunt step 1
    ocolumn := ::obrow:getColumn(x)
    ocolumn:colorBlock := &( '{|a,b,c| FIN_vykdph_in_colorBlock( a, b, c ) }' )

    aadd( pa_colSize, ocolumn:currSize )
  next

  ::tabSelect(nil, ::tabNum)
  ::sum()
RETURN self


function FIN_koh_vykdph_in_colorBlock( a, b, c )
  local useVisualStyle := if( isMemvar( 'visualStyle'), visualStyle, .f. )
  *
  local aCOL_ok := { , }
  local aCOL_er := { GraMakeRGBColor({255,128,128}), }

  if useVisualStyle .and. IsThemeActive(.T.)
    if vykdph_iw->lpreDanPov
      return { , GraMakeRGBColor( {255, 128, 128 } ) }
    else
      return aCOL_ok
    endif
  else
    return if( vykdph_iw->lpreDanPov, aCOL_er, aCOL_ok )
  endif
return aCol_ok


method FIN_koh_vykdph_in:drgDialogEnd()
  vykdph_iw->(dbclearfilter())

  ::sum()

  vykDph_iw->( dbcloseArea())
  vykdph_is->( dbcloseArea())
return self


method FIN_koh_vykDph_IN:itemMarked()
*-  ::showCell()
return self


* tabNum - 1 osvobozeno ntyp_dph 0
*          2 Snížená daò_2       3
*          3 Snížená daò         1
*          4 Základní daò        2
method FIN_koh_vykDph_IN:tabSelect(drgTabPage, tabNum)
  local  typ  := IF(tabNum = 1, 0, IF(tabNum = 2, 1, 2)), col_hd, x
  local  acol := { {'' , '', '', 'osvobozeno', ''   , ''       , 'prenDanPov', ''     }, ;
                   {'' , '', '', 'základ'    , 'daò', 'krácení', 'prenDanPov', 'SuAu_'}  }
  *
  local  m_filter := "ntyp_dph = %%", filter
  local  ocolumn
  *
  local  zakld_dph := ::dm:has('vykdph_IW->nzakld_dph'):odrg, ;
         sazba_dph := ::dm:has('vykdph_IW->nsazba_dph'):odrg, ;
         krace_dph := ::dm:has('vykdph_IW->nkrace_nar'):odrg, ;
         ucetu_dph := ::dm:has('vykdph_IW->cucetu_dph'):odrg


  do case
  case tabNum = 1  ;  typ := 0  // 1:Osvobozeno
  case tabNum = 2  ;  typ := 3  // 2:Snížená daò_2 od 1.1.2015
  case tabNum = 3  ;  typ := 1  // 3:Snížená daò
  otherWise        ;  typ := 2  // 4:Základni daò
  endcase

  if ::tabNum <> tabNum .or. isnull(drgTabPage)
    filter := format(m_filter,{typ})
    vykdph_iw->(dbsetfilter(COMPILE(filter)),dbgotop())

    for x := 4 to 8 step 1
      col_hd  := acol[if(tabNum = 1, 1, 2), x]
      ocolumn := ::obrow:getColumn(x)

      if empty(col_hd)
        ocolumn:setSize({0,0})
*        ocolumn:hide()
      else
*        ocolumn:show()
        ocolumn:setSize( ocolumn:currSize, .t. )

        ocolumn:heading:hide()
        ocolumn:heading:setCell(1,col_hd)
        ocolumn:heading:show()
      endif
    next

    ::obrow:configure()
    ::obrow:invalidateRect()

    **
    sazba_dph:isEdit := krace_dph:isEdit := ucetu_dph:isEdit := (tabNum >= 2)

    if tabNum = 1
       zakld_dph:pushGet:disable()
      (sazba_dph:oxbp:disable(), krace_dph:oxbp:disable(), ucetu_dph:oxbp:disable())

    else
      zakld_dph:pushGet:enable()
      (sazba_dph:oxbp:enable(), krace_dph:oxbp:enable(), ucetu_dph:oxbp:enable())
    endif

    ::tabNum       := tabNum

    ::obrow:colPos := 3
    ::obrow:refreshAll():hilite()

    * je v editaèním režimu a pøepíná záložky, musíme zhodit editaci a pøejít do BRO
    if( ::obrow:cargo:state <> 0, ::obrow:cargo:setBroFocus(), nil)

    * pošlem zprávu pro nastavení rámeèku na tøetí sloupec - nzakld_dph
    postAppEvent(xbeBRW_ItemMarked,1,1,::obrow:getColumn(3):dataArea)
  endif
return .t.


method fin_koh_vykDph_in:prevalidate(drgvar)
  local  name  := lower(drgVar:name)
  local  ok    := .t.
  *
  local  typPreDan := ::dm:has('vykdph_IW->ctypPreDan'):odrg

  if vykdph_iw->lsetpredan
    typPreDan:isEdit := .t.
    typPreDan:oxbp:enable()
  else
    typPreDan:isEdit := .f.
    typPreDan:oxbp:disable()
  endif

  if ( name = 'vykdph_iw->lsetpredan' )
    ok := vykdph_iw->lpreDanPov
  endif
return ok


method fin_koh_vykDph_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()
  *
  local  odrg, sazba_dph

  if (name = 'vykdph_iw->nzakld_dph' .and. ::tabNum <> 1)
    if value <> drgVar:prevValue

      vykdph_iw->(flock())

      sazba_dph := mh_roundnumb((value/100) * vykdph_iw->nprocdph, ::roundDph)

      odrg := ::dm:has('vykdph_iw->nsazba_dph')
      odrg:set(sazba_dph)

*-      vykdph_iw->nsazba_dph := sazba_dph

      * je to blbec snaží se o pøepoèet pøi uložení - mìl bych to strèit na EBro
      drgVar:prevValue := value
    endif
  endif
return ok


METHOD FIN_koh_vykDph_IN:postLastField(drgVar)
  LOCAL  dc     := ::drgDialog:dialogCtrl
  LOCAL  name   := drgVAR:name
  LOCAL  lZMENa := ::drgDialog:dataManager:changed()

  // ukládáme VYKDPH_Iw na každém PRVKU //
*  IF lZMENa
   ::dataManager:save()
   ::oBROw:refreshCurrent()
*  ENDIF

*---  ::killRead(.T.)
  ::sum()
RETURN .T.


method FIN_koh_vykDph_IN:FIN_cmdph(drgDialog)
  LOCAL oDialog, nExit, odrg := drgDialog:oform:olastdrg

  DRGDIALOG FORM 'FIN_CMDPH' PARENT drgDialog MODAL DESTROY  EXITSTATE nExit

  if(nExit != drgEVENT_QUIT)
    ::obrow:refreshcurrent()
    postappevent(drgEVENT_EDIT,,,::obrow)
  endif
RETURN (nExit != drgEVENT_QUIT)

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
method FIN_koh_vykDph_in:sum()
  local  czustuct, ntyp_dph, pa := {}

  ::nosvoddan  := 0
  ::nzakldan_3 := ::nsazdan_3 := ::odvod_3 := ::narok_3 := 0
  ::nzakldan_1 := ::nsazdan_1 := ::odvod_1 := ::narok_1 := 0
  ::nzakldan_2 := ::nsazdan_2 := ::odvod_2 := ::narok_2 := 0

  vykdph_is->(dbcommit(), dbgotop())

  do while .not. vykdph_is->(eof())
    czustuct := lower(vykdph_is->czustuct)
    ntyp_dph :=       vykdph_is->ntyp_dph
    do case
    case(czustuct = 'm')
      if(ntyp_Dph = 1, ::narok_1 += vykdph_is->nsazba_dph, ;
      if(ntyp_Dph = 2, ::narok_2 += vykdph_is->nsazba_dph, ::narok_3 += vykdph_is->nsazba_dph ))

    case(czustuct = 'd')
      if(ntyp_dph = 1, ::odvod_1 += vykdph_is->nsazba_dph, ;
      if(ntyp_dph = 2, ::odvod_2 += vykdph_is->nsazba_dph, ::odvod_3 += vykdph_is->nsazba_dph ))

    endcase

    * návratové hodnoty dokladu
    do case
    case empty(czustuct)
       ::nosvoddan += vykdph_is->nzakld_dph

    case (vykdph_is->nzakld_dph +vykdph_is->nsazba_dph) <> 0
      if ascan(pa,{|x| x = vykdph_is->nradek_vaz}) = 0
        aadd(pa,vykdph_is->nradek_vaz)
        *
        if     (ntyp_dph = 1)  ;  ::nzakldan_1 += vykdph_is->nzakld_dph
                                  ::nsazdan_1  += vykdph_is->nsazba_dph
        elseif (ntyp_dph = 2)  ;  ::nzakldan_2 += vykdph_is->nzakld_dph
                                  ::nsazdan_2  += vykdph_is->nsazba_dph
        elseif (ntyp_dph = 3)  ;  ::nzakldan_3 += vykdph_is->nzakld_dph
                                  ::nsazdan_3  += vykdph_is->nsazba_dph

        endif
      endif
    endcase

    vykdph_is->(dbskip())
  enddo

  ::drgDialog:dataManager:refresh()
return