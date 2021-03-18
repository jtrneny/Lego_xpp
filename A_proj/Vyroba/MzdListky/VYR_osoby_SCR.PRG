#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  OSOBY - VÝROBA
** CLASS VYR_osoby_SCR *********************************************************
CLASS VYR_osoby_SCR FROM drgUsrClass, OSB_osoby_IN, quickFiltrs


EXPORTED:
  METHOD  init
  METHOD  itemMarked
  METHOD  drgDialogStart
  METHOD  tabSelect
  *
  *
  ** osobySK
  inline access assign method adrPoSpoj() var adrPoSpoj
    spojeni ->( dbseek( vazSpoje->SPOJENI,, 'ID'))
    return spojeni->madrPoSpoj

  inline access assign method setSkup() var setSkup
    return if( osobySk->(eof()), 0, MIS_ICON_OK)

  inline access assign method cnaz_Skup() var cnaz_Skup
     c_osobySk->(dbSeek( upper(osobySK->czkr_Skup)))
     return c_osobySk->cnaz_Skup

  inline method osb_msTarind_in(drgDialog)
    local  odialog

    odialog := drgDialog():new( 'OSB_msTarind_in', ::drgDialog )
    odialog:create(,,.t.)
  return self



HIDDEN:
  var  ab
  VAR  vazFILE, tabNum, obtn_msTarind_in

ENDCLASS


METHOD VYR_osoby_SCR:init(parent)

  ::drgUsrClass:init(parent)
  ::tabNum  := 1

  ::vazFILE := {{'VAZSPOJE','SPOJENI'},{'VAZFIRMY','FIRMY'}                ;
               ,{'VAZUKOLY','UKOLY'},  {'VAZDOKUM','DOKUMENT'}}

  drgDBMS:open('msPrc_mo')
  *
  drgDBMS:open('vazSpoje')
  drgDBMS:open('spojeni' )
  *
  drgDBMS:open('vazFirmy')
  drgDBMS:open('firmy'   )
  *
  drgDBMS:open('vazUkoly')
  drgDBMS:open('ukoly'   )
  *
  drgDBMS:open('vazDokum')
  drgDBMS:open('dokument')

*** ??
  drgDBMS:open('c_osobysk')
  drgDBMS:open('c_firmysk')
  *
  *
  drgDBMS:open('C_FUNCPR')
  drgDBMS:open('C_SPOJEN')
  drgDBMS:open('C_PSC'   )
  drgDBMS:open('C_STATY' )
RETURN self


METHOD VYR_osoby_SCR:drgDialogStart(drgDialog)
  local  x
  local  czkr_Skup
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }  }


  c_osobysk->( dbgoTop())
  do while .not. c_osobysk->( eof())
    czkr_Skup := 'nis_' +allTrim(c_osobysk->czkr_Skup)

    if osoby->( fieldPos(czkr_Skup)) <> 0
      aadd( pa_quick, { c_osobysk->cnaz_Skup, czkr_Skup +' = 1' } )
    endif
    c_osobysk->( dbSkip())
  enddo

  ::ab := drgDialog:oActionBar:members      // actionBar

  for x := 1 to len(::ab) step 1
    do case
    case ::ab[x]:event = 'VYR_msTarind_in'  ;  ::obtn_msTarind_in := ::ab[x]
    endcase
  next

  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
RETURN self


METHOD VYR_osoby_SCR:tabSelect(oTabPage,tabnum)
  ::tabNum := tabnum
  ::itemMarked()
RETURN .T.


METHOD VYR_osoby_SCR:itemMarked()
  local  cf   := "nOSOBY = %%", filtrs
  local  nky  := osoby->ncisOsoby
  local  ntar := (osoby->nis_EXT + osoby->nis_VYR)

  if( ntar = 2, ::obtn_msTarind_in:oxbp:enable(), ::obtn_msTarind_in:oxbp:disable() )

  filtrs := format( cf, { isNull( osoby->sID, 0) })

  vazSpoje->( ads_setAof( filtrs ), dbgoTop())
  vazFirmy->( ads_setAof( filtrs ), dbgoTop())
  vazUkoly->( ads_setAof( filtrs ), dbgoTop())
  vazDokum->( ads_setAof( filtrs ), dbgoTop())

  * relFor txt
  c_psc   ->(dbseek( osoby->cpsc      ,, 'C_PSC1'  ))
  c_staty ->(dbseek( osoby->czkratStat,, 'C_STATY1'))

  osobySk->( adsSetOrder('OSOBYSK01'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
RETURN SELF



*  možnost zadání tarifù na OSOBY
** CLASS for OSB_msTarind_IN ***************************************************
CLASS VYR_msTarind_IN  FROM drgUsrClass
EXPORTED:

  inline method init( parent)
    ::drgUsrClass:init(parent)
    *
    drgDBMS:open( 'msTarind' )
    *
    ::m_udcp        := parent:parent:udcp
    ::is_osobyRlock := osoby->( sx_rlock())
    ::is_fromScr    := ( parent:parent:formName = 'OSB_OSB_SCR' )
  return self

  inline method drgDialogInit(drgDialog)
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
    local  members   := drgDialog:formObject:members, odrg

    xbpDialog:minButton   := .f.
    xbpDialog:maxButton   := .f.
    xbpDialog:drawingArea:bitmap  := 1015  // 1015 1016 1017 1018 1019 1020
    xbpDialog:drawingArea:options := XBP_IMAGE_SCALED
  return self

  inline method drgDialogStart(drgDialog)
    local  cf     := "ncisOsoby = %%"
    local  filter

    ::dc       := drgDialog:dialogCtrl              // dataCtrl
    ::df       := drgDialog:oForm                   // form

    filter := format( cf, { osoby->ncisOsoby } )
    msTarind ->( ads_setAof(filter), dbgoTop() )

    ::df:olastdrg   := ::dc:obrowse[1]
    ::df:nlastdrgix := 10
    ::df:olastdrg:setFocus()
  return self

  inline method drgDialogEnd(drgDialog)

    if( ::is_osobyRlock, osoby->( dbunlock()), nil )
    msTarind->( ads_clearAof())
  return self
  *
  **
  inline method ebro_saveEditRow()
    msTarind->ctask      := 'MZD'
    msTarind->culoha     := 'M'
    msTarind->ncisOsoby  := osoby->ncisOsoby
    msTarind->nosCisPrac := osoby->nOsCisPrac
    msTarind->nporPraVzt := 0
    msTarind->cjmenoRozl := osoby->cjmenoRozl
  return self

  inline method postValidate(drgVar)
    local  value   := drgVar:get()
    local  name    := lower(drgVar:name)
    local  ok      := .t., changed := drgVar:changed()
    local  save    := .f.
    *
    do case
    case ( name = 'osoby->ctyptarpou' .and. changed )
      save := .t.
    case ( name = 'osoby->cdelkprdob' .and. changed )
      save := .t.
    endcase

    if( save .and. ::is_osobyRlock, drgVar:save(), nil )
   return ok

HIDDEN:
  var     m_udcp, is_fromScr, is_osobyRlock
  var     dm, dc, df, tabPageManager, oDBro

ENDCLASS