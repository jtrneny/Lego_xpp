#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
*
**
#include "..\FINANCE\FIN_finance.ch"

*
** CLASS for SKL_phm_stojany_IN ***************************************************
CLASS SKL_phm_stojany_IN FROM drgUsrClass
EXPORTED:
  var     hd_file, it_file

  method  init, drgDialogInit, drgDialogStart
  method  tabSelect, itemMarked
  method  preValidate, postValidate
  method  drgDialogEnd

  method  skl_cenzboz_sel
  method  ebro_afterAppend, ebro_saveEditRow


  inline access assign method cenZboz_mnozSZbo var cenZboz_mnozSZbo
    local  cky := upper(stojany->ccisSklad) +upper(stojany->csklPol)

    cenZboz->( dbseek( cky,,'CENIK03'))
  return cenZboz->nmnozSZbo

  inline access assign method pvpitem_datPoh() var pvpitem_datPoh
    return dtoc( pvpitem->ddatPvp) +' ' +pvpitem->ccasPvp


HIDDEN:
  * sys
  var   brow, msg, dm, dc, df, ab, showDialog
  var   o_drgTabs
  var   tabNum

* datové
  var     cisSklad, sklPol
ENDCLASS


METHOD SKL_phm_stojany_IN:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('cenzboz')
  drgDBMS:open('pvpitem')

  (::hd_file := 'stojany', ::it_file := 'stojanyit')
  ::tabNum   := 1
RETURN self


METHOD SKL_phm_stojany_IN:drgDialogInit(drgDialog)
RETURN


METHOD SKL_phm_stojany_IN:drgDialogStart(drgDialog)
  local  x, caption, o_bitMaps
  *
  local  members   := drgDialog:oForm:aMembers
  local  aBitMaps   := { { XbpBitMap():new():create(), 512 }, ;
                         { XbpBitMap():new():create(), 513 }, ;
                         { XbpBitMap():new():create(), 517 }  }


  ::brow      := drgDialog:dialogCtrl:oBrowse[1]
  ::msg       := drgDialog:oMessageBar             // messageBar
  ::dc        := drgDialog:dialogCtrl              // dataCtrl
  ::dm        := drgDialog:dataManager             // dataMananager
  ::df        := drgDialog:oForm                   // form
*  ::ab        := drgDialog:oActionBar:members      // actionBar

  ::o_drgTabs := ::df:tabPageManager:members

  for x := 1 to len(::o_drgTabs) step 1
    caption := ::o_drgTabs[x]:oxbp:caption
    caption := subStr( caption, at(':', caption) +1 )

    ::o_drgTabs[x]:oxbp:setCaption(caption)
    *
    **
    o_bitMaps := aBitMaps[x,1]
    n_bitMaps := aBitMaps[x,2]
    o_bitMaps:load( ,n_bitMaps)
    o_bitMaps:TransparentClr := o_bitMaps:GetDefaultBGColor()

    ::o_drgTabs[x]:oxbp:setImage(o_bitMaps)
  next

  * stojany
  ::cisSklad  := ::dm:get('stojany->ccisSklad' , .f.)
  ::sklPol    := ::dm:get('stojany->csklpol'   , .f.)
return self


METHOD SKL_phm_stojany_IN:tabSelect(oTabPage,tabnum)
  local  oBrowse := ::drgDialog:dialogCtrl:oBrowse
  local  o_tabs, x

  o_tabs := ::df:tabPageManager:members
  for x := 1 to len(o_tabs) step 1
    o_tabs[x]:oxbp:setColorFG(GRA_CLR_BLUE)
  next

  ::tabNum := tabNum
  ::itemMarked()

  oBrowse[2]:oxbp:refreshAll()
return .t.


* pøíjem  ntypPvp = 1 or ( ntypPvp = 3 and ndokladVyd <> 0 ) ... 40 tj. pøíjem pøevodem
* výdej   ntypPvp = 1
* pøevod  ntypPvp = 3 and ndokladVyd = 0                     ... 80 tj. výdej pøevodem


method SKL_phm_stojany_in:itemMarked()
  local  filter
  local  m_filter := "( ccisSklad = '%%' and csklPol = '%%' )" //  and ntypPvp = %% )"

  do case
  case ::tabNum = 1
    m_filter += " and (ntypPvp = %% or ( ntypPvp = 3 and ndokladVyd <> 0 ))"
    filter   := format( m_filter, { stojany->ccisSklad, stojany->csklPol, 1 } )

  case ::tabNum = 2
    m_filter += " and ntypPvp = %%"
    filter   := format( m_filter, { stojany->ccisSklad, stojany->csklPol, 2 } )

  case ::tabNum = 3
    m_filter += " and (ntypPvp = %%  and ndokladVyd = 0)"
    filter   := format( m_filter, { stojany->ccisSklad, stojany->csklPol, 3 } )
  endcase

  pvpitem->( ads_setAof(filter), dbgoTop() )
return self


METHOD SKL_phm_stojany_IN:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-')
  *
  local  filter, cky, lok := .t.
*  local  sid := isNull( stojanyit->sid, 0 ), lok := .t.

  do case

  * pøednastavení a blokování na hlavièce stojany
  case( file = ::hd_file )

    do case
    case( name = ::hd_file +'->nstojan' )
      if empty(value)
        ::dm:set( 'stojany->nstojan', stojany->( Ads_GetKeyCount()) +1 )
      endif
    endcase

  * pøednastavení a blokování na položce stojanyit
  case( file = ::it_file )

    do case
    case( name = ::it_file +'->ddatPoh' )
      if empty(value)
*        ::dm:set( 'stojanyit->nstojan' , stojany->nstojan  )
*        ::dm:set( 'stojanyit->cnazStoj', stojany->cnazStoj )
*        ::dm:set( 'stojanyit->ddatPoh' , date()            )
      endif
    endcase

  endcase
return lok


METHOD SKL_phm_stojany_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  lok    := .t., changed := drgVAR:changed(), cc
  local  npos, n_Cit, n_Jmen, npodVym_m2
  local  o_CenaPoz, o_DanNabPoz, o_CenaSDaNa
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)
  *
  if( ::df:in_postvalidateForm .and. (file = ::hd_file), file := '', nil )

  do case

  * kontroly na hlavièce stojany
  case( file = ::hd_file )
    * nstojan, cnazStoj, ccisSklad, csklPol, ddatPoh  , npocStav, nprijem, nvydej, naktStav
    * ++1    , pov     , noEd     , pov    , insDate(), insEd   , noEd   , noEd  , noEd

    do case
    case( name = ::hd_file +'->cnazstoj' )
      if empty(value)
        drgMsgBox(drgNLS:msg('Je mì líto, ;; ale Název stojanu /odbìrného místa/ je povinný údaj !!!'), XBPMB_CRITICAL )
        lok := .f.
      endif

    case( name = ::hd_file +'->csklpol'  )
      lok := ::skl_cenZboz_sel()

    endcase

  * kontroly na položce stojanyit
  case( file = ::it_file )
    * nstojan, cnazStoj, ddatPoh  , nprijem, nvydej, naktStav
    * noEd   , noEd    , insDate(), 10       noEd  , noEd
    *                                                      , nstojanKam, nvydej  80

  endcase
return lok


method SKL_phm_stojany_IN:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))
    ::dm:set('stojany->ccissklad',cenzboz->ccissklad)

    ::cisSklad:set(cenzboz->ccisSklad)
    ::sklPol:set(  cenzboz->csklPol  )
*    ::dm:set('M->nazZbo',cenzboz->cnazzbo)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method SKL_phm_stojany_IN:ebro_afterAppend(o_ebro)
  local  m_file     := lower(o_ebro:cfile), s_filter, filter
  local  m_filter   := "nstojan = %%"
  local  pa_oBrowse := ::dc:oBrowse

  do case
  case (m_file = ::hd_file )
*    filter := format(m_filter, { 0 })

*    (::it_file)->(ads_setAof(filter),dbgotop())
*    pa_oBrowse[::tabNum+1]:oxbp:refreshAll()

  case (m_file = ::it_file )
*    ::dm:set(stojanyit->nstojan , stojany->nstojan )
*    ::dm:set(stojanyit->cnazStoj, stojany->cnazStoj)
*    ::dm:set(stojanyit->datPoh  , date()           )

  endcase
return .t.


method SKL_phm_stojany_IN:ebro_saveEditRow(o_eBro)
  local  m_file := lower(o_ebro:cfile), cky

  do case
  case (m_file = ::hd_file )
    stojany->ccisSklad := ::cisSklad:value

    if o_ebro:isAppend
      stojany->naktStav := stojany->npocStav
   endif
 endcase

 o_eBro:enabled_insCykl := .f.
return .t.


METHOD SKL_phm_stojany_IN:drgDialogEnd(drgDialog)

  ::drgUsrClass:destroy()
RETURN


*
** CLASS SKL_stojany_SEL *******************************************************
CLASS SKL_phm_stojany_SEL FROM drgUsrClass
EXPORTED:
  method  init
*  method  drgDialogStart
  method  itemSelected
*  method  itemMarked


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self


  inline method drgDialogStart(drgDialog)

    if .not. stojany->( dbseek( ::nstojan,,'STOJANY01'))
      stojany->( dbgoTop())
    endif
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
     do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      ::itemSelected()
      return .t.
    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .f.

  inline method drgDialogEnd(drgDialog)
  return self

hidden:
  var  dm
  var  drgGet, nstojan

endclass


METHOD SKL_phm_stojany_SEL:init(parent)
  local  nevent := mp1 := mp2 := oxbp := nil

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'stojany' )

  nEvent    := LastAppEvent(@mp1,@mp2,@oXbp)
  ::drgGet  := if( IsOBJECT(oXbp:cargo), oXbp:cargo, nil )
  ::nstojan := if( isObject(::drgGet), ::drgGet:ovar:value, 0 )
return self


method SKL_phm_stojany_SEL:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self