#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


#xtranslate IsDrgGet(<o>) => IF( IsNull(<o>)  , NIL, ;
                             IF( IsObject(<o>), IF( <o>:className() = 'drgGet', <o>, NIL ), NIL))



*  OSOBY
** CLASS VYR_kmenove_SEL *******************************************************
CLASS VYR_kmenove_SEL FROM drgUsrClass
EXPORTED:
  var     obdobi

  method  init
  method  drgDialogStart
  method  itemSelected
  method  itemMarked
  method  createContext, fromContext


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1019
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

  inline access assign method caption_contextText() var caption_contextText
    return ::a_popUp[ ::popState, 1]


  inline access assign method is_Stavem_mo() var is_Stavem_mo
    msPrc_moB->( dbseek( osoby->ncisOsoby,,'MSPRMO13'))
    return if( msprc_mob->lStavem,  MIS_ICON_OK, 0)

  inline access assign method is_Stavem_prSml() var is_Stavem_prSml
    return if( prSmlDoh->lStavem,  MIS_ICON_OK, 0)


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
    osoby->( ads_clearAof() )
    prsmlDoh->( ads_clearAof() )
  return self

hidden:
  var  dm
  var  drgGet
  var  q_oBrowse, pb_context, a_popUp, popState
  var  firstDay

endclass


METHOD VYR_kmenove_SEL:Init(parent)
  local  nevent := mp1 := mp2 := oxbp := nil

  nEvent   := LastAppEvent(@mp1,@mp2,@oXbp)
  ::drgGet := if( IsOBJECT(oXbp:cargo), oXbp:cargo, nil )

  ::drgUsrClass:init(parent)

  ::popState := 1
  ::a_popUp  := { { 'Osoby v evidenci pro výrobu       ', 'nis_VYR = 1 .and. ( lstavem = .t. .or. nis_EXT = 1 )' }, ;
                  { 'Zamìstnanci mimo stav             ', 'nis_ZAM = 1 .and. lstavem = .f.'}, ;
                  { 'Zamìstnanci ve stavu              ', 'nis_ZAM = 1 .and. lstavem = .t.'}  }

  ::firstDay  := mh_FirstODate( uctOBDOBI:VYR:NROK, uctOBDOBI:VYR:NOBDOBI)

  drgDBMS:open('osoby')
  drgDBMS:open('MSPRC_MO',,,,,'MSPRC_MOb')
  drgDBMS:open('prSmlDoh')
return self


method VYR_kmenove_SEL:drgDialogStart(drgDialog)
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

    osoby->(ads_setAof( ::a_popUp[1,2] ), dbgoTop())
  endif

*  if isObject(::drgGet)
*    osoby->( dbseek( ::drgGet:ovar:value ))
*  endif
return self


METHOD VYR_kmenove_SEL:itemMarked()
  local cfiltr

  cfiltr := Format("nOSOBY = %% .and. ( dDATVYST >= '%%' .or. dDATVYST = ''.or. dDATVYST = null )", {isNull( osoby->sid, 0), ::firstDay})
  prsmldoh->( ads_setaof(cfiltr), dbGoTop())
RETURN self


method VYR_kmenove_SEL:itemSelected()

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


method VYR_kmenove_SEL:createContext()
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


method VYR_kmenove_SEL:fromContext(aorder,p_popUp)
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