#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*
** pro èíselníky BRO_column
function PER_c_pracvz_BC(column)
  local  val    := DBGetVal('c_pracvz->' +column )
  return if( val, MIS_ICON_OK, 0 )

function PER_c_ukoncpv_BC()
  return if( c_ukonpv->lOdstupne, MIS_ICON_OK, 0 )


*  OSOBY personalistika VZDELANI ***********************************************
CLASS PER_vzdelani_scr FROM PER_osoby_SCR, OSB_osoby_IN
EXPORTED:
  method  init
  *
  ** c_Vzdel->cNazVzdela
  inline access assign method nazVzdela() var nazVzdela
    c_vzdel->( dbseek( upper( vzdelani->czkrVzdel),,'C_VZDEL01'))
    return c_Vzdel->cnazVzdela

ENDCLASS


METHOD PER_vzdelani_SCR:init(parent)
  parent:formName := parent:initParam := 'PER_vzdelani_SCR'
  parent:helpName := 'PER_vzdelani_scr'

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_vzdel' )
  drgDBMS:open('c_vzdeUk')
  drgDBMS:open('c_staty' )

  drgDBMS:open('prSmlDoh')

  ::PER_osoby_scr:init('vdelani')
RETURN self


*  OSOBY personalistika SKOLENI ************************************************
CLASS PER_skoleni_scr FROM PER_osoby_SCR, OSB_osoby_IN
EXPORTED:
  method  init
  *
  ** c_skolen->cnazev
  inline access assign method nazSkolen() var nazSkolen
    c_skolen->(dbseek( upper(skoleni->czkratka),,'C_SKOLEN01'))
    return c_skolen->cnazev
ENDCLASS


METHOD PER_skoleni_SCR:init(parent)
  parent:formName := parent:initParam := 'PER_skoleni_SCR'
  parent:helpName := 'PER_skoleni_scr'

  ::drgUsrClass:init(parent)

  drgDBMS:open('vzdelani')
  drgDBMS:open('c_vzdel' )
  drgDBMS:open('c_vzdeUk')

  drgDBMS:open('c_skolen')
  drgDBMS:open('c_skoluk')

  drgDBMS:open('c_psc'   )
  drgDBMS:open('c_staty' )

  drgDBMS:open('prSmlDoh')

  ::PER_osoby_scr:init('skoleni')
RETURN self


*  OSOBY personalistika LEKPROHL************************************************
CLASS PER_lekprohl_scr FROM PER_osoby_SCR, OSB_osoby_IN
EXPORTED:
  method  init
  *
  ** c_lekPro->cnazev
  inline access assign method nazlekPr() var nazlekPr
    c_lekpro->(dbseek( upper(lekprohl->czkratka),,'C_LEKPRO01'))
    return c_lekPro->cnazev
ENDCLASS


METHOD PER_lekprohl_SCR:init(parent)
  parent:formName := parent:initParam := 'PER_lekprohl_SCR'
  parent:helpName := 'PER_lekprohl_scr'

  ::drgUsrClass:init(parent)

  drgDBMS:open('c_lekpro')
  drgDBMS:open('c_lekari')

  drgDBMS:open('vzdelani')
  drgDBMS:open('c_vzdel' )
  drgDBMS:open('c_vzdeUk')

  drgDBMS:open('c_skolen')
  drgDBMS:open('c_skoluk')

  drgDBMS:open('c_psc'   )
  drgDBMS:open('c_staty' )

  drgDBMS:open('prSmlDoh')

  ::PER_osoby_scr:init('lekprohl')
RETURN self



*  OSOBY personalistioka, podmožnia OSOBY nis_PER = 1
** CLASS PER_osoby_SCR ********************************************************
CLASS PER_osoby_SCR FROM drgUsrClass, OSB_osoby_IN  // , quickFiltrs
EXPORTED:
  METHOD  init, itemMarked, drgDialogStart
  METHOD  tabSelect

  var     tabNum

  * browColumn
  *
  ** TAB 3 duchody
  inline access assign method is_aktiv() var is_aktiv
    return if( duchody->lAktiv, MIS_ICON_OK, 0 )
  *
  ** TAb 5 vzdìlání
  inline access assign method nazev_Vzdelani var nazev_Vzdelani
    c_vzdel->(dbseek( upper( vzdelani->czkrVzdel),,'C_VZDEL01'))
    return c_vzdel->cnazVzdela
  *
  ** TAB 6 lékarské prohlídky
  inline access assign method nazev_lekPro()   var nazev_lekPro
    c_lekPro->( dbseek( upper( lekProhl->czkratka),,'C_LEKPRO01'))
    return c_lekPro->cnazev
  *
  ** TAB 7 školení/ kurzy
  inline access assign method nazev_Skoleni var nazev_Skoleni
    c_skolen->( dbseek( upper( skoleni->czkratka),,'C_SKOLEN01'))
    return c_skolen->cnazev


* BUTTONky
  inline  method PER_pershead_navPL(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'PER_pershead_navPL' PARENT drgDialog MODAL DESTROY EXITSTATE nExit //  CARGO drgEVENT_APPEND
*    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
  return .t.


* HIDDEN:
*   VAR tabNum

ENDCLASS


METHOD PER_osoby_SCR:init(parent)

  if( isObject(parent), ::drgUsrClass:init(parent), nil )
  ::tabNum  := 1

  drgDBMS:open('msPrc_mo')

  * TAB 2 rodinní pøíslušníci
  drgDBMS:open('osoby',,,,,'osoby_Rp')
  drgDBMS:open('vazOsoby')
*  vazOsoby->( dbsetRelation( 'osoby_Rp', { || vazOsoby->nOSOBY   },, 'ID' ))

  * TAB 3 duchody
  drgDBMS:open('duchody')

  * TAb 5 vzdìlání
  drgDBMS:open('c_vzdel')

  * TAb 6 lékarské prohlídky
  drgDBMS:open('c_lekpro')
  drgDBMS:open('lekProhl')
  drgDBMS:open('vazLekpr')
*  vazLekpr->( dbsetRelation( 'lekProhl', { || vazLekpr->LEKPROHL },, 'ID' ))

  * TAB 7 školení/ kurzy
  drgDBMS:open('c_skolen' )
  drgDBMS:open('skoleni'  )
  drgDBMS:open('vazSkol'  )
*  vazSkol->( dbsetRelation( 'skoleni'  , { || vazSkol->SKOLENI   },, 'ID' ))

 * programový filtr
 ::drgDialog:set_prg_filter( "nis_PER = 1", 'osoby')
RETURN self


METHOD PER_osoby_SCR:drgDialogStart()
/*
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }, ;
  { 'Osoby    v pracovnì právním vztahu', 'nis_ZAM = 1' }, ;
  { 'Osoby mimo pracovnì právním vztah ', 'nis_ZAM = 0' }, ;
  { 'Osoby    v personální evidenci    ', 'nis_PER = 1' }, ;
  { 'Osoby mimo personální evidenci    ', 'nis_PER = 0' }  }


  ::quickFiltrs:init( self, pa_quick, 'Osoby' )
*/
RETURN self


METHOD PER_osoby_SCR:tabSelect(oTabPage,tabnum)
  ::tabNum := tabnum
  ::itemMarked()
RETURN .T.


METHOD PER_osoby_SCR:itemMarked()
  local  cf      := "OSOBY  = %%", filtrs
  *
  local  nky     := osoby->ncisOsoby
  local  cf_tabs := format( "ncisOsoby = %%", {osoby->ncisOsoby} )

  filtrs := format( cf, { isNull( osoby->sID, 0) })

  vazOsoby->( ads_setAof(      filtrs ), dbgoTop())
  vazLekpr->( ads_setAof( "n" +filtrs ), dbgoTop())
  vazSkol ->( ads_setAof( "n" +filtrs ), dbgoTop())

  * TAB 3 duchody
  duchody ->( ads_setAof( cf_tabs ), dbgoTop())

  * TAB 4 pracobnì právní vztahy/ dohody
  prSmlDoh->( ads_setAof( cf_tabs ), dbgoTop())

  * TAB 5 vzdìlání
  vzdelani->( ads_setAof( cf_tabs ), dbgoTop())

  * TAB 6 lékaøské prohlídky
  lekprohl->( ads_setAof( cf_tabs ), dbgoTop())

  * TAB 7 školení
  skoleni->( ads_setAof( cf_tabs ), dbgoTop())

  * relFor txt
  c_psc    ->(dbseek( osoby->cpsc             ,, 'C_PSC1'  ))
  c_staty  ->(dbseek( osoby->czkratStat       ,, 'C_STATY1'))
RETURN SELF


* zpùsob volání
* PER_osoby_sel,1  -- druhý parametr urèuje rozmìr pole pa_vazRec na parentu
* state = 2        -- je to arr { recNo, recNo ... } tyto záznamy byly již pøevzaty
*                  -- musíme je odfiltrovat z nabídky
*
* PER_osoby_sel,,nis_PER = 0
* state = 3        -- tøetí rozmìr je požadavek na programový filtr
*                  -- ALE pokud je volání z PER mìlo by se zakázat tlaèítko per_osoby_new
*
*
** CLASS PER_osoby_SEL *********************************************************
CLASS PER_osoby_SEL FROM drgUsrClass
EXPORTED:

  inline method init( parent )
    local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
    *
    local   olastDrg, pa_initParam

    drgDBMS:open('osoby')

    nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
    if( IsNull(oxbp), NIL, If( IsOBJECT(oXbp:cargo), ::drgGet := oXbp:cargo, NIL ))

     if isObject( parent:parent )
      if isObject( parent:parent:oForm )
        if isObject( olastDrg := parent:parent:oForm:olastDrg )
          if lower( olastDrg:className()) = 'drgget'
            if( isNull(::drgGet), ::drgGet := olastDrg, nil )

            pa_initParam := listAsArray(parent:initParam)

            do case
            case len(pa_initParam) = 2
              ::state      := 2
              ::pa_vazRecs := pa := parent:parent:UDCP:pa_vazRecs[ val( pa_initParam[2] ) ]

              if .not. empty( pa )
                osoby->( ads_setAof('.T.'))
                osoby->( ads_customizeAOF( pa, 3))
              endif

            case len(pa_initParam) = 3
              ::state := 3
              osoby->( ads_setAOF( pa_initParam[3]), dbGoTop() )

            endCase

          endif
        endif
      endif
    endif

    if( isObject(::drgGet), ::drgGet:cargoGet := nil, nil )
    ::lsearch   := (::drgGet <> NIL)
    ::tabNumber := 1

    ::drgUsrClass:init(parent)
  return self


  inline method drgDialogInit(drgDialog)

    drgDialog:formHeader:title += if( ::state = 2, 'výbìr rodinného pøíslušníka ...' , ;
                                    if( ::state = 3, 'výbìr osoby do personalistiky ...', '' ))

    drgDialog:dialog:drawingArea:bitmap  := 1016
    drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
  RETURN self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oActionBar:members
    local  aPP     := drgPP:getPP(2), oColumn, x

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
      if( members[x]:event = 'per_osoby_new'   , ::act_new    := members[x], nil)
      if( members[x]:event = 'per_osoby_modify', ::act_modify := members[x], nil)
    next

    if( ::state = 3, ( ::act_new:disable(), ::act_new:oxbp:disable() ), nil )
  return self


  inline method onLoad( isApend )
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local name

    do case
    case nEvent = xbeP_Keyboard
*      do case
*      case( mp1 = xbeK_ALT_N )  ;  ::act_new:activate()
*      case( mp1 = xbeK_ALT_O )  ;  ::act_modify:activate()
*      otherWise
        RETURN .F.
*      endcase

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        name := 'osoby->' +drgParseSecond(::drgGet:name,'>')

        ::drgGet:ovar:set( DBGetVal( name ))
        ::drgGet:cargoGet := isNull( osoby->sID, 0)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        return .t.
      endif
    endcase
  return .f.


  inline method per_osoby_new(drgDialog)
    local oDialog, nExit
    *
    local  pa := ::pa_vazRecs

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_APPEND

    if .not. empty(pa)
      spojeni->( ads_setAof('.T.'))
      spojeni->( ads_customizeAOF( pa, 3))
    endif

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshAll()
    ::dm:refresh()
  return .t.


  inline method per_osoby_modify(drgDialog)
    local oDialog, nExit

    DRGDIALOG FORM 'OSB_OSOBY_CRD' PARENT drgDialog MODAL DESTROY EXITSTATE nExit CARGO drgEVENT_EDIT

    ::drgDialog:dialogCtrl:oaBrowse:oxbp:refreshCurrent()
    ::dm:refresh()
  return .t.

HIDDEN:
  var    msg, dm, dc, df, ab, brow
  *
  var    drgGet, lsearch, tabNumber, pa_vazRecs, state
  var    act_new, act_modify
ENDCLASS