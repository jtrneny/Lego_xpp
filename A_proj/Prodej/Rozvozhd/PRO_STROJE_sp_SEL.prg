#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'firmy'    , 'firmyfi' , 'firmyuc', 'firmyda', 'firmysk', 'firmyva', ;
                   'c_firmysk', 'c_podruc'                                              }



*
** CLASS FOR PRO_stroje_sp_SEL **************************************************
CLASS PRO_stroje_sp_SEL FROM drgUsrClass
EXPORTED:
  method  init, EventHandled, RecordSelected
  method  drgDialogStart, drgDialogEnd
  method  createContext, fromContext
  *
  method  fir_firmy_nova, fir_firmy_oprava

  var     quickFilter
  var     sel_Item, cur_Value, sel_Filtrs

  inline method stableBlock()
    firmy->( dbseek( stroje->ncisFirmy,,'FIRMY1'))
  return self

HIDDEN:
  var     act_firmy_nova, act_firmy_oprava
  var     oico_noQuick, oico_isQuick
  var     m_cisFirmy, panGroup

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
method PRO_stroje_sp_SEL:init(parent)
  local m_parent, cc

  ::drgUsrClass:init(parent)
  ::openFiles(m_files)
  *
  ** pomocná pro vazbu na hd->ncisFirmy
  drgDBMS:open('firmy',,,,,'firmy_vaw')

  ::sel_Item   := ''
  ::cur_Value  := ''
  ::sel_Filtrs := {}
  ::m_cisFirmy := if( isNumber(parent:cargo_usr), parent:cargo_usr, 0 )
  ::panGroup   := ''

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

  firmy_vaw->( dbseek( ::m_cisFirmy,, 'FIRMY1'))
  cc := '[ ' +allTrim( str(firmy_vaw->ncisFirmy)) +'_' +allTrim(firmy_vaw->cnazev) +' ]'

  do case
  case( 'cspz' $ lower(::sel_Item) )
    ::panGroup   := 'SPZ'
    ::a_popup    := { { 'Stroje dopravce -> ' +cc            , 'dop_STROJE'  }, ;
                      { 'Vlastní stroje v evidenci'          , 'fir_STROJE'  }, ;
                      { 'Kompletní seznam strojù v evidenci' , ''            }  }

    if ::m_cisFirmy = 0
      ::sel_filtrs := { { 'stroje', { 'Kompletní seznam strojù v evidenci' , ''  } } }
    else
      ::sel_filtrs := { { 'stroje', { 'Stroje dopravce -> ' +cc  , 'dop_STROJE'  } } }
    endif
  endcase
RETURN self


method PRO_stroje_sp_SEL:drgDialogStart(drgDialog)
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
      if amembers[x]:event = 'createContext'
        amembers[x]:oxbp:setSize( { 400, 25} )
        amembers[x]:oxbp:configure()

        ::pb_context := amembers[x]
        ::pb_context:oxbp:gradientColors := {0,6}
      endif
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
  if .not. empty( sel_Filtrs )
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'stroje'} )) <> 0
      if ( nitem := ascan( a_popUp, {|x| x[2] = sel_Filtrs[nfile,2,2]} )) <> 0
        ::quickFilter := nitem
        ::fromContext(nitem, sel_Filtrs[nfile,2])
      endif
    endif
  endif

  if( .not. empty(::cur_Value), stroje->( dbseek( upper(::cur_Value),,'STROJE06')), nil)
  if( stroje->(eof()), stroje->(dbgoTop()), nil )
return self


method PRO_stroje_sp_SEL:drgDialogEnd(drgDialog)
  local  sel_Filtrs := ::sel_Filtrs, a_popUp := ::a_popUp
  local  nfile, nitem

  if ::quickFilter <> 0
    if empty( sel_Filtrs)
      aadd( sel_Filtrs, { 'stroje', a_popUp[::quickFilter] } )

    else
      if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'stroje'} )) = 0
        aadd( sel_Filtrs, { 'stroje', a_popUp[::quickFilter] } )

      else
        sel_Filtrs[nfile,2] := a_popUp[::quickFilter]

      endif
    endif
  else
    if( nfile := ascan( sel_Filtrs, {|x| x[1] = 'stroje'} )) <> 0
      aRemove( sel_Filtrs, nfile )
    endif
  endif

  sel_iltrs := {}
  stroje->(ads_clearAof())
return self


*
********************************************************************************
METHOD PRO_stroje_sp_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
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


METHOD PRO_stroje_sp_SEL:RecordSelected()
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN SELF

method PRO_stroje_sp_SEL:fir_firmy_nova(drgDialog)
  local oDialog, nExit

  DRGDIALOG FORM 'FIR_FIRMY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

  ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
return .t.


method PRO_stroje_sp_SEL:fir_firmy_oprava(drgDialog)
  local oDialog, nExit

  DRGDIALOG FORM 'FIR_FIRMY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

  ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
return .t.


*
**
METHOD PRO_stroje_sp_SEL:createContext()
  local  csubmenu, opopup
  *
  local  pa := ::a_popUp
  local  aPos    := ::pb_context:oXbp:currentPos()
  local  aSize   := ::pb_context:oXbp:currentSize()

  opopup         := XbpImageMenu():new( ::drgDialog:dialog )
  opopup:barText := ::panGroup
  opopup:create()

  for x := 1 to len(pa) step 1
    opopup:addItem( {pa[x,1]                       , ;
                     de_BrowseContext(self,x,pA[x]), ;
                                                   , ;
                     XBPMENUBAR_MIA_OWNERDRAW        }, ;
                     if( x = ::quickFilter, 500, 0)     )
  next

  opopup:popup( ::pb_context:oxbp:parent, apos )
RETURN self


METHOD PRO_stroje_sp_SEL:fromContext(aorder,p_popUp)
  local  d_obro  := ::drgDialog:dialogCtrl:oaBrowse
  local  in_file := d_obro:cfile
  local  filter  := p_popUp[2]
  *
  local  oIcon    := XbpIcon():new():create()
  local  cf       := "(ncisFirmy = %%)", cFilter

  ::popState := aorder
  *
  ** ? oznaèil si pøednastavený quickFilter, pokud ne je to jen pøepnutí
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
    do case
    case( filter = 'dop_STROJE' .or. filter = 'fir_STROJE'  )
      cFilter := format( cf, { if( filter = 'fir_STROJE', 0, ::m_cisFirmy ) } )
      (in_file)->( ads_setAof( cFilter ))
    endcase
  endif

  (in_file) ->(dbgotop())

  * rušíme oznaèení
  d_obro:arselect := {}
  d_obro:oxbp:refreshAll()
  setAppFocus( d_obro:oxbp )
return self