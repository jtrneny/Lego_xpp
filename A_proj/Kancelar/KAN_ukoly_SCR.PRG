#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

function sp_mgGetConnectedUsers()
  local cStatement, oStatement
  local cAlias, hCursor
  local cfield :='OSUserLoginName', cUser, pa_OSUser := {}

  cStatement := "execute procedure sp_mgGetConnectedUsers()"
  oStatement := AdsStatement():New(cStatement,oSession_data)

  if oStatement:LastError > 0
    return nusers
  endif
  oStatement:Execute( 'test' )

  cAlias     := oStatement:Alias
  hCursor    := oStatement:hCursor

  do while .not. (cAlias)->( eof())

    pa    := AdsGetField( hCursor, cfield)
    cuser := allTrim( left(pa[1], pa[2]) )

    if ( .not. empty(cUser) .and. ascan(pa_OSuser, cUser) = 0 )
      aadd( pa_OSUser, cUser )
    endif
    (cAlias)->( dbskip())
  enddo

  nusers := len(pa_OSUser)

  oStatement:alias := ''
  oStatement:Close()
return nusers



*  UKOLY
** CLASS KAN_ukoly_SCR *********************************************************
CLASS KAN_ukoly_SCR FROM drgUsrClass, OSB_osoby_IN
EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart

  * BRO ukoly
  inline access assign method is_podUkol() var is_podUkol
    local  sID    := isNull(ukoly->sID,0)
    local  retVal := 0

    if sID <> 0
      retVal := if( vazUkolyX->( dbseek(sID,,'UKOLY')), 338, 0 )
    endif
  return retVal

  * pro exontrol ukolTree
  inline method ukolTree_ex_Full(drgDialog)
    local  othread
    local  recNo := str(ukoly->( recNo()))

    oThread := drgDialogThread():new()
    oThread:start( ,'kan_ukolTREE_ex_scr,' +recNo, drgDialog)

    drgDialog:dialogCtrl:refreshPostDel()
  return

ENDCLASS


METHOD KAN_ukoly_SCR:init(parent)

  ::drgUsrClass:init(parent)

//  RunShell( "/C START msg pc-jsuchy Mate ukol" )
//  RunShell( , 'c:\Windows\System32\msg.exe pc-jsuchy Mate ukol' )
//  xx := sp_mgGetConnectedUsers()

  drgDBMS:open('ukoly'   )
  drgDBMS:open('vazUkoly')

  drgDBMS:open('osoby'   ,,,,,'osobyX'   )
  drgDBMS:open('ukoly'   ,,,,,'ukolyX'   )
  drgDBMS:open('vazUkoly',,,,,'vazUkolyX')

  drgDBMS:open('osoby')
  drgDBMS:open('msprc_mo')
RETURN self


METHOD KAN_ukoly_SCR:drgDialogStart()
//  PostAppEvent(drgEVENT_MSG,,drgEVENT_SAVE, ::drgDialog:dialog)
RETURN self


METHOD KAN_ukoly_SCR:itemMarked( arowco, unil, oxbp)
  local  cf := "vazUkoly->UKOLY = %%", filtrs
  local  npolVys, npolNiz, pa_recNo := {}
  local  ncisOSOres,       pa_recOs := {}

  ncisOSOres := ukoly->ncisOSOres
  if( osobyX->( dbseek( ncisOSOres,,'OSOBY01')), aadd(pa_recOs,osobyX->(recNo())), nil )


  filtrs := format( cf, { isNull( ukoly->sID, 0) })
  vazUkoly->( ads_setAof( filtrs ), dbgoTop())

  do while .not. vazUkoly->( eof())
    npolVys    := vazUkoly->npolVys
    npolNiz    := vazUkoly->npolNiz

    if npolVys <> ukoly->sID
      if( ascan( pa_recNo, npolVys) = 0, aadd( pa_recNo, npolVys ), nil )
    endif

    if npolNiz <> ukoly->sID
      if( ascan( pa_recNo, npolNiz) = 0, aadd( pa_recNo, npolNiz ), nil )
    endif

    vazUkoly->( dbskip())
  enddo

  * podÚkoly
  ukolyX->( ads_setAof( '.F.'))
  UkolyX->( ads_customizeAOF( pa_recNo, 1), dbgoTop())

  * øešitelé
  aeval( pa_recNo, { |x| ukolyX->( dbgoTo(x))                                 , ;
                         if( osobyX->( dbseek( ukolyX->ncisOSOres,,'OSOBY01')), ;
                             aadd(pa_recOs,osobyX->(recNo())), nil           ), ;
                         ukolyX->( dbgoTop())                                   } )

  osoby ->( ads_setAof( '.F.'))
  osoby->( ads_customizeAOF( pa_recOs, 1), dbgoTop())
RETURN SELF


*
** CLASS KAN_ukoly_SEL *******************************************************
CLASS KAN_ukoly_SEL FROM drgUsrClass, quickFiltrs_withCustomizeAof
EXPORTED:

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

    ::lsearch    := (::drgGet <> NIL)
    ::tabNumber  := 1
    ::pa_vazRecs := {}

    if len(pa_initParam := listAsArray(parent:initParam)) = 2
      ::pa_vazRecs := parent:parent:UDCP:pa_vazRecs[ val( pa_initParam[2] ) ]
    endif

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogInit(drgDialog)
    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  RETURN self


  inline method drgDialogStart(drgDialog)
    local  members  := drgDialog:oActionBar:members
    local  aPP      := drgPP:getPP(2), oColumn, x
    local  pa_quick := { ;
    { 'Kompletní seznam                  ', ''            } }

    ::brow    := drgDialog:dialogCtrl:oBrowse[1]
    ::msg     := drgDialog:oMessageBar             // messageBar
    ::dm      := drgDialog:dataManager             // dataMabanager
    ::dc      := drgDialog:dialogCtrl              // dataCtrl
    ::df      := drgDialog:oForm                   // form
    if isobject(drgDialog:oActionBar)
      ::ab      := drgDialog:oActionBar:members    // actionBar
    endif

    if ::lsearch
      for x := 1 TO ::brow:oXbp:colcount
        ocolumn := ::brow:oXbp:getColumn(x)
        ocolumn:DataAreaLayout[XBPCOL_DA_BGCLR]   := GraMakeRGBColor( {255, 255, 200} )
        ocolumn:configure()
      next
    endif

    for x := 1 to len(members) step 1
      if( members[x]:event = 'kan_ukoly_new'   , ::act_new    := members[x], nil)
      if( members[x]:event = 'kan_ukoly_modify', ::act_modify := members[x], nil)
    next

    drgDBMS:open('c_typUkl')
    c_typUkl->(dbgotop())

    do while .not. c_typUkl->( eof())
      x := { left( c_typUkl->cnazTyp, 30)                     , ;
             format( "ctypUkolu = '%%'", {c_typUkl->ctypUkolu}) }

      aadd( pa_quick, x )
      c_typUkl->(dbskip())
    enddo

    ::quickFiltrs_withCustomizeAof:init( self, pa_quick, 'Úkoly', ::pa_vazRecs, 2 )
  return self


  inline method onLoad( isApend )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = xbeP_Keyboard
      do case
      case( mp1 = xbeK_ALT_N )  ;  ::act_new:activate()
      case( mp1 = xbeK_ALT_O )  ;  ::act_modify:activate()
      otherWise
        RETURN .F.
      endcase

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
    endcase
  return .f.


  inline method kan_ukoly_new(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'KAN_UKOLY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


  inline method kan_ukoly_modify(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'KAN_UKOLY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
  return .t.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber, pa_vazRecs
  var    act_new, act_modify
ENDCLASS