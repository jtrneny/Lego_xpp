#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"



function mzd_kmenove_sel_moB(cfield)
  local  npos := msPrc_moB->(fieldPos(cfield))

  msPrc_moB->( dbseek( osoby->ncisOsoby,, 'MSPRMO13'))
  return msPrc_moB->(fieldGet(npos))


*  OSOBY
** CLASS MZD_kmenove_SEL *******************************************************
CLASS MZD_kmenove_SEL FROM drgUsrClass
EXPORTED:
  var     obdobi

  method  init
  method  drgDialogStart
  method  itemSelected
  method  createContext, fromContext

  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

  inline access assign method caption_contextText() var caption_contextText
    return ::a_popUp[ ::popState, 1]

  inline access assign method is_Stavem() var is_Stavem
    return if( msprc_mob->lStavem,  MIS_ICON_OK, 0)

  inline access assign method is_Stavem_mo() var is_Stavem_mo
    msPrc_moB->( dbseek( osoby->ncisOsoby,,'MSPRMO13'))
    return if( msprc_mob->lStavem,  MIS_ICON_OK, 0)


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

hidden:
  var  dm
  var  q_oBrowse, pb_context, a_popUp, popState

endclass


METHOD MZD_kmenove_SEL:Init(parent)

  ::drgUsrClass:init(parent)

  ::popState :=  1
  ::a_popUp  := { { 'Komletní seznam osob v evidenci  ', ''             }, ;
                  { 'Osoby bez zamìstnaneckého stavu  ', 'nis_ZAM = 0'  }, ;
                  { 'Zamìstanci mimo stav             ', 'lstavem = .f.'}, ;
                  { 'Zamìstanci ve stavu              ', 'lstavem = .t.'}  }


  drgDBMS:open('osoby')
  drgDBMS:open('MSPRC_MO',,,,,'MSPRC_MOb')
return self


method MZD_kmenove_SEL:drgDialogStart(drgDialog)
  local  x, ocolumn
  local  members := drgDialog:oForm:aMembers

  ::dm        := drgDialog:dataManager             // dataMabanager
  ::q_oBrowse := drgDialog:odBrowse[1]

  drgDialog:set_uct_ucetsys_inlib()

  for x := 1 to len(members) step 1
    do case
    case(members[x]:ClassName() = 'drgPushButton') ; ::pb_context := members[x]
    endcase
  next

  if isobject(::pb_context)
    ::pb_context:oXbp:setFont(drgPP:getFont(5))
    ::pb_context:oxbp:gradientColors := {0,6,210}
  endif
return self


method MZD_kmenove_SEL:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


method MZD_kmenove_SEL:createContext()
  local  pa := ::a_popUp, opopup
  local  x, aPos, aSize

  opopup         := XbpImageMenu( ::drgDialog:dialog ):new()
  opopup:barText := 'osoby'
  opopup:create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {pa[x,1]                       , ;
                     de_BrowseContext(self,x,pA[x]), ;
                                                   , ;
                     XBPMENUBAR_MIA_OWNERDRAW        }, ;
                     if( x = ::popState, 500, 0)     )
  next


  oPopup:disableItem(::popState)

  aPos    := ::pb_context:oXbp:currentPos()
  aSize   := ::pb_context:oXbp:currentSize()
  opopup:popup( ::pb_context:oxbp:parent, { apos[1] -21, apos[2] } )
return self


method MZD_kmenove_SEL:fromContext(aorder,p_popUp)
  local  cfilter := p_popUp[2]

  ::pb_context:oxbp:setCaption( allTrim( p_popUp[1]))

  if ::popState <> aorder
    if empty(cfilter)
      osoby->(ads_clearAof())
    else
      osoby->(ads_setAof( cfilter), dbgoTop())
    endif
  endif

  ::popState := aorder
  ::q_oBrowse:oxbp:refreshAll()
  setAppFocus( ::q_oBrowse:oxbp )
  ::dm:refresh(.t.)
return self