********************************************************************************
*
* FIR_FIRMY_SEL.PRG    .... Do FIRMY
*
********************************************************************************

#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'firmy'    , 'firmyfi' , 'firmyuc', 'firmyda', 'firmysk', 'firmyva', ;
                   'c_firmysk', 'c_podruc'                                              }



********************************************************************************
* FIR_FIRMY_SEL ...
********************************************************************************
CLASS FIR_FIRMY_SEL FROM drgUsrClass

EXPORTED:
  method  init, EventHandled, RecordSelected, stableBlock
  method  drgDialogStart, drgDialogEnd
  method  createContext, fromContext
  *
  method  fir_firmy_nova, fir_firmy_oprava

  var     quickFilter
  var     sel_Item, cur_Value, sel_Filtrs

  *
  * firmy aktivni/neaktivni
  inline access assign method is_aktivni() var is_aktivni
    return if( firmy->lAktivni, MIS_ICON_OK, MIS_NO_RUN )

HIDDEN:
  var     act_firmy_nova, act_firmy_oprava
  var     oico_noQuick, oico_isQuick

  var     pb_context, a_popUp, popState

  inline method openfiles(afiles)
    local  nin,file,ordno

    aeval(afiles, { |x| ;
         if(( nin := at(',',x)) <> 0, (file := substr(x,1,nin-1), ordno := val(substr(x,nin+1))), ;
                                      (file := x                , ordno := nil                )), ;
         drgdbms:open(file)                                                                        , ;
         if(isnull(ordno), nil, (file)->(AdsSetOrder(ordno)))                                     })
  return nil
ENDCLASS

*
********************************************************************************
METHOD FIR_FIRMY_SEL:init(parent)
  local m_parent

  ::drgUsrClass:init(parent)
  ::openFiles(m_files)

  ::sel_Item   := ''
  ::cur_Value  := 0
  ::sel_Filtrs := {}


  ::a_popUp := { { 'Kompletní seznam       ', ''                         }, ;
                 { 'Aktivní   Firmy        ', 'laktivni'                 }, ;
                 { 'Neaktivní Firmy        ', '!laktivni'                }, ;
                 { 'Odbìratel              ', 'nis_ODB = 1 and laktivni' }, ;
                 { 'Dodavatel              ', 'nis_DOD = 1 and laktivni' }, ;
                 { 'Fakturaèní adresa      ', 'nis_FAA = 1 and laktivni' }, ;
                 { 'Dopravce               ', 'nis_DOP = 1 and laktivni' }, ;
                 { 'Dodací adresa          ', 'nis_DOA = 1 and laktivni' }, ;
                 { 'Korenspondenèní adresa ', 'nis_KOA = 1 and laktivni' }, ;
                 { 'Zákazník               ', 'nis_ZAK = 1 and laktivni' }, ;
                 { 'Mateøská firma         ', 'nis_MAF = 1 and laktivni' } }

  if isObject( m_parent := parent:parent )
    if m_parent:lastXbpInFocus:className() = 'XbpGet'

      if upper(m_parent:lastXbpInFocus:cargo:name) = 'EBROWSE'
        ::sel_Item  := m_parent:oform:olastDrg:name
        ::cur_Value := m_parent:oform:olastDrg:ovar:value
      else
        ::sel_Item  := m_parent:lastXbpInFocus:cargo:name
        ::cur_Value := m_parent:lastXbpInFocus:cargo:oVar:value
      endif
    endif
  endif
RETURN self


method fir_firmy_sel:drgDialogStart(drgDialog)
  local   members := drgDialog:oActionBar:members
  local  amembers := drgDialog:oform:aMembers
  *
  local  x, odrg
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp
  local  nfile, nitem

  for x := 1 to len(members) step 1
    if( members[x]:event = 'fir_firmy_nova'  , ::act_firmy_nova   := members[x], nil)
    if( members[x]:event = 'fir_firmy_oprava', ::act_firmy_oprava := members[x], nil)
  next

  for x := 1 to len( amembers) step 1
    if  amembers[x]:ClassName() = 'drgPushButton'
      if( amembers[x]:event = 'createContext', ::pb_context := amembers[x], nil )
    endif
  next

  ::oico_noQuick := XbpIcon():new():create()
  ::oico_isQuick := XbpIcon():new():create()
  ::oico_isQuick:load( NIL, 101 )

  ::pb_context:oxbp:setImage( ::oico_noQuick )
  ::popState    := 1
  ::quickFilter := 0

  *
  ** quickFiltrs na SEL dialogu
  ** { { 'firmy,  { 'Dopravce               ', 'nis_DOP = 1' } }
  if .not. empty( sel_Filtrs )
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'firmy'} )) <> 0
      if ( nitem := ascan( a_popUp, {|x| x[2] = sel_Filtrs[nfile,2,2]} )) <> 0
        ::quickFilter := nitem
        ::fromContext(nitem, sel_Filtrs[nfile,2])
      endif
    endif
  endif

  if( ::cur_Value <> 0, firmy->( dbseek( ::cur_Value,,'FIRMY1')), nil)
  if( firmy->(eof()), firmy->(dbgoTop()), nil )
return self


method fir_firmy_sel:drgDialogEnd(drgDialog)
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp
  local  nfile, nitem

  if ::quickFilter <> 0
    if empty( sel_Filtrs)
      aadd( sel_Filtrs, { 'firmy', a_popUp[::quickFilter] } )

    else
      if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'firmy'} )) = 0
        aadd( sel_Filtrs, { 'firmy', a_popUp[::quickFilter] } )

      else
        sel_Filtrs[nfile,2] := a_popUp[::quickFilter]

      endif
    endif
  else
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'firmy'} )) <> 0
      aRemove( sel_Filtrs, nfile )
    endif
  endif

  firmy->(ads_clearAof())
return self


*
********************************************************************************
METHOD FIR_FIRMY_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL dc := ::drgDialog:dialogCtrl

  DO CASE
  CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
    ::recordSelected()

  CASE nEvent = drgEVENT_APPEND
    ::act_firmy_nova:activate()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

    case( mp1 = xbeK_ALT_N )  ;  ::act_firmy_nova:activate()
    case( mp1 = xbeK_ALT_O )  ;  ::act_firmy_oprava:activate()
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.


METHOD FIR_FIRMY_SEL:RecordSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN SELF


method fir_firmy_sel:stableBlock(obro)
  local nky := firmy->ncisFirmy

  firmyDa->(AdsSetOrder('FIRMYDA1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyFi->(AdsSetOrder('FIRMYFI1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyUc->(AdsSetOrder('FIRMYUC1' ), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmySk->(AdsSetOrder('FIRMYSK01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
  firmyVa->(AdsSetOrder('FIRMYVA01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
return


method fir_firmy_sel:fir_firmy_nova(drgDialog)
  local oDialog, nExit

  DRGDIALOG FORM 'FIR_FIRMY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

  ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
return .t.


method fir_firmy_sel:fir_firmy_oprava(drgDialog)
  local oDialog, nExit

  DRGDIALOG FORM 'FIR_FIRMY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

  ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
return .t.


*
**
METHOD fir_firmy_sel:createContext()
  local  csubmenu, opopup
  *
  local  pa := ::a_popUp
  local  aPos    := ::pb_context:oXbp:currentPos()
  local  aSize   := ::pb_context:oXbp:currentSize()

  opopup         := XbpImageMenu():new( ::drgDialog:dialog )
  opopup:barText := 'Seznam firem'
  opopup:create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {pa[x,1]                       , ;
                     de_BrowseContext(self,x,pA[x]), ;
                                                   , ;
                     XBPMENUBAR_MIA_OWNERDRAW        }, ;
                     if( x = ::quickFilter, 500, 0)     )
  next

//  opopup:disableItem( ::popState )

  apos    := ::pb_context:oXbp:currentPos()
***  aPos[2] := ::pb_context:oXbp:parent:currentPos()[2] +aSize[2]

  opopup:popup(::drgDialog:dialog, apos )
RETURN self


METHOD fir_firmy_sel:fromContext(aorder,p_popUp)
  local  d_obro  := ::drgDialog:dialogCtrl:oaBrowse
  local  in_file := d_obro:cfile
  local  filter  := p_popUp[2]
  *
  local  oIcon    := XbpIcon():new():create()

  ::popState := aorder
  *
  ** ? oznaèil si pøednastavený quickFilter, poku ne je to jen pøepnutí
  if AppKeyState( xbeK_CTRL ) = APPKEY_DOWN
    ::quickFilter := if( ::quickFilter = aorder, 0, aorder )
  endif

  ::pb_context:oxbp:setImage( if( ::quickFilter = aorder, ::oico_isQuick, ::oico_noQuick ))
  ::pb_context:oxbp:setCaption( allTrim( p_popUp[1]))
  ::pb_context:oxbp:setFont(drgPP:getFont(5))
  ::pb_context:oxbp:setColorFG(GRA_CLR_RED)

  if empty(filter)
    (in_file)->(Ads_clearAOF())
  else
    (in_file)->(ads_setAof(filter))

//    ::drgDialog:set_PRG_filter(filter, 'FIRMY')
  endif

  (in_file) ->(dbgotop())

  * rušíme oznaèení
  d_obro:arselect := {}
  d_obro:oxbp:refreshAll()
  setAppFocus( d_obro:oxbp )
return self