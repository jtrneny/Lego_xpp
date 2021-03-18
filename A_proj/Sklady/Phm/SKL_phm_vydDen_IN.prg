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
** CLASS for SKL_phm_vydDen_IN *************************************************
CLASS SKL_phm_vydDen_IN FROM drgUsrClass
  exported:
  var     hd_file, it_file

  method  init, drgDialogInit, drgDialogStart
  method  tabSelect, itemMarked
  method  drgDialogEnd

  method  skl_cenzboz_sel
  method  ebro_afterAppend, ebro_saveEditRow

  method  skl_stojany_sel, osb_osoby_sel


  inline access assign method cnazStoj()  var cnazStoj
    local nstojan := PHMVYDstro->nstojan

    stojany_S->( dbseek( nstojan,,'STOJANY01'))
  return stojany_S->cnazStoj

  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    if nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT .or.         ;
        nEvent = drgEVENT_DELETE
      if lastXbp:ClassName() = 'XbpBrowse'
 *        ::cALIASw := Upper(lastXbp:cargo:cfile)
 *        ::cALIASa := Left( ::cALIASw,Len(::cALIASw)-1) +"A"
      endif
    endif

    do case
    case nEvent = xbeBRW_ItemMarked
      return .f.

    case(nevent = drgEVENT_ACTION)
      if isNumber( mp1 )
         xx := 123
      endif
      return .f.

    otherwise
      return .f.

    endcase
  return .t.


  HIDDEN:
  * sys
  var   brow, msg, dm, dc, df, ab, showDialog
  var   o_drgTabs
  var   tabNum

* datové
  var     cisSklad, sklPol
  var     o_stojan
ENDCLASS


METHOD SKL_phm_vydDen_IN:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('stojany' ,,,,, 'stojany_S' )

  drgDBMS:open('cenzboz' )

  (::hd_file := 'stojany', ::it_file := 'stojanyit')
  ::tabNum   := 1
RETURN self


METHOD SKL_phm_vydDen_IN:drgDialogInit(drgDialog)
RETURN


METHOD SKL_phm_vydDen_IN:drgDialogStart(drgDialog)
  local x, caption
  *
  local members   := drgDialog:oForm:aMembers
  local obmp_edit := XbpBitMap():new():create()

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
    ** první a poslední záložka je editaèní - EBro
    if x = 1 .or. (x = len(::o_drgTabs))
       obmp_edit:load( ,315)
       obmp_edit:TransparentClr := obmp_edit:GetDefaultBGColor()

       ::o_drgTabs[x]:oxbp:setImage(obmp_edit)
    endif
  next

  * stojany
  ::o_stojan  := ::dm:get('PHMVYDstro->nstojan' , .f.)

  ::cisSklad  := ::dm:get('stojany->ccisSklad' , .f.)
  ::sklPol    := ::dm:get('stojany->csklpol'   , .f.)
return self


METHOD SKL_phm_vydDen_IN:tabSelect(oTabPage,tabnum)
  local  oBrowse := ::drgDialog:dialogCtrl:oBrowse
  local  o_tabs, x

  o_tabs := ::df:tabPageManager:members
  for x := 1 to len(o_tabs) step 1
    o_tabs[x]:oxbp:setColorFG(GRA_CLR_BLUE)
  next

  ::tabNum := tabNum
  ::itemMarked()
return .t.


METHOD SKL_phm_vydDen_IN:itemMarked()
  local  filter, pa
  local  m_filter   := "nstojan = %% .and. "
  local  pa_oBrowse := ::dc:oBrowse

  if ::tabNum = 1
    m_filter += "( ntypPohyb = %% .or. ntypPohyb = %% )"
    pa       := { stojany->nstojan, 10, 40 }
  else
    m_filter += "ntypPohyb = %%"
    pa       := if( ::tabNum = 2, { stojany->nstojan, 60 }, {  stojany->nstojan, 80 } )
  endif

  filter := format(m_filter, pa )

  (::it_file)->( ads_setAof(filter), dbgoTop())
  pa_oBrowse[::tabNum+1]:oxbp:refreshAll()
return self


method SKL_phm_vydDen_IN:skl_cenzboz_sel(drgDialog)
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


method SKL_phm_vydDen_IN:ebro_afterAppend(o_ebro)
  local  m_file     := lower(o_ebro:cfile), s_filter, filter
  local  m_filter   := "nstojan = %%"
  local  pa_oBrowse := ::dc:oBrowse

  do case
  case (m_file = ::hd_file )
    filter := format(m_filter, { 0 })

    (::it_file)->(ads_setAof(filter),dbgotop())
    pa_oBrowse[::tabNum+1]:oxbp:refreshAll()

  case (m_file = ::it_file )
*    ::dm:set(stojanyit->nstojan , stojany->nstojan )
*    ::dm:set(stojanyit->cnazStoj, stojany->cnazStoj)
*    ::dm:set(stojanyit->datPoh  , date()           )

  endcase
return .t.


method SKL_phm_vydDen_IN:skl_stojany_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
*  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'SKL_phm_stojany_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
*    (::hd_file)->cjmenoVys := osoby->cosoba
*    ::dm:set( 'PHMVYDstro->cosoba', osoby->cosoba)
  endif
return (nexit != drgEVENT_QUIT)



method SKL_phm_vydDen_IN:osb_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgVar := ::dm:drgDialog:lastXbpInFocus:cargo:ovar
*  local  name   := lower(drgVar:name)

  DRGDIALOG FORM 'OSB_osoby_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit

  if (nexit != drgEVENT_QUIT)
*    (::hd_file)->cjmenoVys := osoby->cosoba
    ::dm:set( 'PHMVYDstro->cosoba', osoby->cosoba)
  endif
return (nexit != drgEVENT_QUIT)


method SKL_phm_vydDen_IN:ebro_saveEditRow(o_ebro)
  local  m_file := lower(o_ebro:cfile), cky

  do case
  case (m_file = ::hd_file )
    if o_ebro:isAppend
      stojany->naktStav := stojany->npocStav
   endif
 endcase
return .t.


METHOD SKL_phm_vydDen_IN:drgDialogEnd(drgDialog)

  ::drgUsrClass:destroy()
RETURN