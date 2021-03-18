 ***************************************************************************
* SKL_CENZBOZ_SEL.PRG,  SKL_CENTERM_SKL, SKL_CENVYR
***************************************************************************

#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.Ch"

#include "DRGres.Ch'
#include "..\VYROBA\VYR_Vyroba.ch"

*
** CLASS for SKL_cenZboz_pk_SEL ************************************************
** cskladKAM, csklPolKAM        - Pøevod_Kam
*
CLASS SKL_cenZboz_pk_SEL from SKL_cenZboz_pk
EXPORTED:
  inline method init(parent)
    parent:formName  := 'SKL_cenZboz_pk_SEL'
    parent:initParam := 'SKL_cenZboz_pk'

    ::drgUsrClass:init(parent)
    ::SKL_cenZboz_pk:init(parent,'sel')
  return self
ENDCLASS


CLASS SKL_cenZboz_pk_VLD from SKL_cenZboz_pk
EXPORTED:
  inline method init(parent)
    parent:formName  := 'SKL_cenZboz_pk_VLD'
    parent:initParam := 'SKL_cenZboz_pk'

    ::drgUsrClass:init(parent)
    ::SKL_cenZboz_pk:init(parent,'vld')
  return self
ENDCLASS


// CLASS SKL_cenZboz_pk_SEL FROM drgUsrClass
CLASS SKL_cenZboz_pk FROM drgUsrClass
EXPORTED:
  var cisSklad, nazSklad   , sklPol   , nazZbo
  var skladKAM, nazSkladKAM, sklPolKAM, nazZboKAM

  *
  ** cenZboz
  inline access assign method isAktivni() var isAktivni
    local  retVal

    if cenZboz_pk->lAktivni
      retVal := if( cenZboz_pk->ctypSklPol = 'X', MIS_EXCL_WARN, 0 )
    else
      retVal := MIS_NO_RUN
    endif
    return retVal

  inline access assign method cenPol() var cenPol
    return if(cenZboz_pk->cpolcen = 'C', MIS_ICON_OK, 0)

  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
       Return .T.
    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  return .t.


  inline method init(parent)
    local  o_sklPolKAM

    ::drgUsrClass:init(parent)

    drgDBMS:open( 'cenZboz' )
    drgDBMS:open( 'cenZboz' ,,,,, 'cenZboz_pk' )
    drgDBMS:open( 'c_sklady',,,,, 'c_sklady_p' )

    ::m_udcp        := parent:parent:udcp:hd_udcp
    ::m_dm          := ::m_udcp:dataManager
    ::aof_cenZboz   := cenZboz->( ads_getAof())
    ::recNo_cenZboz := cenZboz->( recNo())
                       cenZboz->( ads_clearAof())

    c_sklady_p->( dbseek( upper( pvpheadW->ccisSklad),,'C_SKLAD1') )
    ::cisSklad      := ::m_dm:get('pvpheadW->ccisSklad'  )
    ::nazSklad      := c_sklady_p->cnazSklad
    ::sklPol        := ::m_dm:get('pvpitemWW->csklPol'   )
    ::nazZbo        := ::m_dm:get('pvpitemWW->cnazZbo'   )

    ::skladKAM      := ::m_dm:get('pvpitemWW->cskladKAM' )
    c_sklady_p->( dbseek( upper( ::skladKAM),,'C_SKLAD1') )

    ::nazSkladKAM   := c_sklady_p->cnazSklad
    o_sklPolKAM     := ::m_dm:has('pvpitemWW->csklPolKAM')
    ::sklPolKAM     := o_sklPolKAm:odrg:oxbp:value   // ::m_dm:get('pvpitemWW->csklPolKAM')
    ::nazZboKAM     := ::m_dm:get('pvpitemWW->cnazZbo'   )

    ::pa_itemsNew   := { { '...->cCisSklad' , ::skladKAM            }, ;
                         { '...->cSklPol'   , ::sklPolKAM           }, ;
                         { '...->nZboziKat' , CenZboz->nZboziKat    }, ;
                         { '...->nUcetSkup' , CenZboz->nUcetSkup    }, ;
                         { '...->cucetSkup' , CenZboz->cucetSkup    }, ;
                         { '...->cNazZbo'   , ::nazZbo              }, ;
                         { '...->cTypSklPol', cenZboz->ctypSKLpol   }, ;
                         { '...->cZkratJedn', CenZboz->cZkratJedn   }, ;
                         { '...->nKlicDph'  , CenZboz->nKlicDph     }, ;
                         { '...->cZkratMeny', CenZboz->cZkratMeny   }, ;
                         { '...->cZahrMena' , CenZboz->cZahrMena    }, ;
                         { '...->ncenaPzbo' , CenZboz->ncenaPzbo    }, ;
                         { '...->ncenaMzbo' , CenZboz->ncenaMzbo    }, ;
                         { '...->nCenasZbo' , CenZboz->nCenasZbo    }, ;
                         { '...->ctypSKLcen', CenZboz->ctypSKLcen   }, ;
                         { '...->cPolCen'   , CenZboz->cPolCen      }  }
  return self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oForm:aMembers
    local  x, odrg, groups, name, tipText
    *
    local  acolors  := MIS_COLORS, pa_groups, nin

*    ::msg      := drgDialog:oMessageBar             // messageBar
    ::dm         := drgDialog:dataManager             // dataManager
*    ::dc        := drgDialog:dialogCtrl              // dataCtrl
    ::df         := drgDialog:oForm                   // form

    if len(::drgDialog:odBrowse) <> 0
      ::odBro      := ::drgDialog:odBrowse[1]
      ::oxbp_Brow  := ::odBro:oxbp
    endif

    ::o_skladKAM := ::dm:has( 'M->skladKAM' )


    for x := 1 to len(members) step 1
      odrg    := members[x]
      groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
      groups  := allTrim(groups)
      name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
      tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')
      *
      *
      if odrg:className() = 'drgText' .and. .not. empty(groups)
        pa_groups := ListAsArray(groups)

        * XBPSTATIC_TYPE_RAISEDBOX           12
        * XBPSTATIC_TYPE_RECESSEDBOX         13

        if pa_groups[1] = 'SKL_PRE_MAIN'
          ::odrg_SKL_PRE_MAIN := odrg
          odrg:oxbp:disable()
        endif

        if odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13
          odrg:oxbp:setColorBG(GRA_CLR_BACKGROUND)
        endif

        if ( nin := ascan(pa_groups,'SETFONT') ) <> 0
          odrg:oXbp:setFontCompoundName(pa_groups[nin+1])
        endif

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            odrg:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          if isMemberVar(odrg, 'oBord') .and. ( odrg:oBord:Type = 12 .or. odrg:oBord:Type = 13)
            odrg:oXbp:setColorFG(GRA_CLR_BLUE)
          else
            odrg:oXbp:setColorFG(GRA_CLR_DARKGREEN) // GRA_CLR_BLUE)
          endif
        endif
      endif

      if odrg:ClassName() = 'drgStatic' .and. .not. empty(groups)
        odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
      endif

      if odrg:className() = 'drgPushButton'
        do case
        case odrg:event = 'skl_cenZboz_pk_autoNew'  ;  ::obtn_autoNew := odrg
        case odrg:event = 'skl_cenZboz_pk_editNew'  ;  ::obtn_editNew := odrg
        endcase
      endif
    next

    if drgDialog:cargo <> 0
      cenZboz_pk->( dbgoTo( drgDialog:cargo ))
      ::is_sklPolKAm( .t.)
    else
      cenZboz_pk->( dbgoTop())
    endif

    if( isObject(::odBro), ::df:setNextFocus( ::odBro ), nil )
  return self


  inline method skladKAM_vld(drgVar)
    return( ::sklad_sel() )


  inline method sklad_sel(drgDialog)
    local  value := ::o_skladKAm:value
    local  ok    := ( !Empty(value) .and. c_sklady->(dbseek(value,,'C_SKLAD1'))), lis_sklPol := .f.
    *
    local  flt_cenZboz_pk

    if IsObject(drgDialog) .or. !ok
      srchDialog := drgDialog():new( 'C_SKLADY', ::drgDialog)  // sklady\cis\skl_cisel_sel.prg
      srchDialog:cargo := value
      srchDialog:create(,,.T.)
      *
      if srchDialog:exitState = drgEVENT_SELECT
        if value <> srchDialog:cargo
          ::skladKAm := srchDialog:cargo
          ::o_skladKAm:set( srchDialog:cargo )

          c_sklady_p->( dbseek( upper( ::skladKAM),,'C_SKLAD1') )
          ::nazSkladKAM   := c_sklady_p->cnazSklad
          ::dm:set( 'M->nazSkladKAm', c_sklady_p->cnazSklad )

          flt_cenZboz_pk := format("ccisSklad = '%%'", { ::skladKAm } )
          drgDialog:set_prg_filter( flt_cenZboz_pk, 'cenZboz_pk', .t. )

          if( lis_sklPol := cenZboz_pk->( dbseek( upper(::sklPolKAm),, 'CENIK01')), nil, cenZboz_pk->( dbgoTop()) )
          ::is_sklPolKAm(lis_sklPol)

          ::odBro:oxbp:refreshAll()
        endif
      endif
      *
      srchDialog:destroy()
      srchDialog := NIL
    endif

    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,::o_skladKAm:odrg:oxbp)
    ::df:setNextFocus( ::odBro )
  return ok


  inline method drgDialogEnd()
    if( .not. empty(::aof_cenZboz), cenZboz->( ads_setAof(::aof_cenZboz)), nil )
    cenZboz->( dbgoTo(::recNo_cenZboz))
  return self


  inline method itemMarked()
    cenZboz->( dbseek( cenZboz_pk->sID,,'ID' ))
  return self


  inline method skl_cenZboz_pk_autoNew()
    local  pa := aclone(::pa_itemsNew)

    cenZboz->( dbseek( upper(::cisSklad) +upper(::sklPol),,'CENIK03' ) )
    for x := 1 to len(pa) step 1
      pa[x,1] := strTran( pa[x,1], '...', 'cenZboz_pk' )
    next

    if addRec( 'cenZboz_pk' )
      aeval( pa, { |X,n|  &(pa[n,1]) := pa[n,2] } )

      cenZboz_pk->( dbunlock(), dbcommit() )

      ::oxbp_Brow:refreshAll()
      postAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
    endif
  return .t.


  inline method skl_cenZboz_pk_editNew()
    local  nexit
    local  o_skl_cenZboz_crd, o_udcp, o_dm
    *
    local  pa := aclone(::pa_itemsNew)

    cenZboz->( dbseek( upper(::cisSklad) +upper(::sklPol),,'CENIK03' ) )
    for x := 1 to len(pa) step 1
      pa[x,1] := strTran( pa[x,1], '...', 'cenZbozW' )
    next

    o_skl_cenZboz_crd := drgDialog():new('SKL_cenZboz_CRD', ::drgDialog)
    o_skl_cenZboz_crd:cargo_Usr := pa       // 'EXT_CEN'
    o_skl_cenZboz_crd:create( ,, .t., .f. ) // 4. parametr can_showDialog default .t.

    o_udcp  := o_skl_cenZboz_crd:udcp
    o_dm    := o_skl_cenZboz_crd:dataManager

    setAppFocus(::oxbp_Brow)
    o_dm:refresh()

    o_skl_cenZboz_crd:quickShow(.t.,.t.)

    if o_skl_cenZboz_crd:exitState = drgEVENT_SAVE
      ::oxbp_Brow:goTop()

      cenZboz_pk->( dbseek( upper(cenZboz->csklPol),, 'CENIK01') )
      ::oxbp_Brow:refreshAll()
      postAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
    endif

    ::df:setNextFocus( ::odBro )
  return .t.

HIDDEN:
  var     aof_cenZboz, recNo_cenZboz
  VAR     m_udcp, m_dm
  var     dc, dm, df, ab, odBro, oxbp_Brow
  var     pa_itemsNew
  var     odrg_SKL_PRE_MAIN
  var     o_skladKAM, obtn_autoNew, obtn_editNew

  * skladová položka na cílovém skladu exituje/ nexituje
  inline method is_sklPolKAm(lis_sklPol)
    if lis_sklPol
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... skladová položka na cílovém skladu existuje ...' )
      ::obtn_autoNew:oxbp:disable()
      ::obtn_editNew:oxbp:disable()
    else
      ::odrg_SKL_PRE_MAIN:oxbp:setCaption( '... skladová položka na cílovém skladu neexistuje ...' )
      ::obtn_autoNew:oxbp:enable()
      ::obtn_editNew:oxbp:enable()
    endif
  return self

ENDCLASS



********************************************************************************
* SKL_CENZBOZ_SEL ...
********************************************************************************
CLASS SKL_CENZBOZ_SEL FROM drgUsrClass, quickFiltrs

EXPORTED:
  METHOD  Init, EventHandled, drgDialogStart

ENDCLASS

********************************************************************************
METHOD SKL_CENZBOZ_SEL:init(parent)
  ::drgUsrClass:init(parent)
  *
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
*  CENZBOZ->( DbSetRelation( 'C_SKLADY', {||CENZBOZ->cCisSklad },'CENZBOZ->cCisSklad' ))
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
RETURN self

********************************************************************************
METHOD SKL_CENZBOZ_SEL:drgDialogStart(drgDialog)
  ColorOfTEXT( drgDialog:dialogCtrl:members[1]:aMembers )
  *
  ::quickFiltrs:init( self                                                          , ;
                      { { 'Kompletní seznam        ', ''                           }, ;
                        { 'Aktivní položky         ', 'laktivni = .t.'             }, ;
                        { 'Neaktivní položky       ', 'laktivni = .f.'             }, ;
                        { 'Aktivní k dispozici <> 0', 'laktivni and nmnozDzbo <> 0'}  }, ;
                      'Ceník'                                                            )

RETURN

********************************************************************************
METHOD SKL_CENZBOZ_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
    ::drgDialog:odBrowse[1]:oXbp:refreshAll()

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.



#Define tabCENZBOZ        1
#Define tabPVPTERM        2
*
#define  ERR_TERM_PRIJEM_           1
#define  ERR_TERM_PRIJEM_CENA       1
#define  ERR_TERM_PRIJEM_NONE       2

#define  ERR_TERM_VYDEJ_            2
#define  ERR_TERM_VYDEJ_MNOZSKL     1
#define  ERR_TERM_VYDEJ_NAKLST      2
#define  ERR_TERM_VYDEJ_NONE        3


#Define  ERR_TERM_POPIS    { { 'Není cena na pøíjmovém dokladu                ',;
                               'Nedefinováno                                  ' } ,;
                             { 'Vydávané množství pøesahuje množství skladové ',;
                               'Není vyplnìna nákladová struktura             ',;
                               'Nedefinováno                                  ' }  }

********************************************************************************
* SKL_CENTERM_SEL ...
********************************************************************************
CLASS SKL_CENTERM_SEL FROM drgUsrClass, quickFiltrs

EXPORTED:
  var     cpvpTerm_filter
  var     m_udcp, oinf

  METHOD  Init, EventHandled, drgDialogStart, itemMarked, tabSelect
  METHOD  TermToPVP, RefreshDATA, post_bro_colourCode, doAppend

  *
  ** cenZboz
  inline access assign method cenPol() var cenPol
    return if(cenzboz->cpolcen = 'C', MIS_ICON_OK, 0) // C. 563

  inline access assign method wds_cenzboz_kDis() var wds_cenzboz_kDis
    local pa := ::m_udcp:wds_cenzboz, recNo := cenzboz->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, 2]
    endif
    return cenzboz->nmnozDzbo -nval

  *
  ** pvpTerm
  inline access assign method pvpTerm_ctypPvp() var pvpTerm_ctypPvp
    local  pa_typPvp := { 'pøíjem', 'výdej', 'pøevod' }
    local  ntypPvp   := pvpTerm->ntypPvp
    return if( ntypPvp > 0, pa_typPvp[ntypPvp], '' )

 inline access assign method wds_pvpterm_kDis() var wds_pvpterm_kDis
    local pa := ::m_udcp:wds_pvpterm, recNo := pvpterm->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, 2]
    endif
    return pvpterm->nmnozDokl1 -nval


  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  acombo_val := {}
    local  typPohybu  := allTrim( (::hd_file)->ctypPohybu)
    local  cc         := if( (::hd_file)->ntypPoh = 2, 'VÝDEJ', 'PØÍJEM' )

    c_typPOH->( dbSEEK( S_DOKLADY + typPohybu,, 'C_TYPPOH02'))

    if( cname = 'cpvpterm_filter' )
      aadd( acombo_val, {  typPohybu                                               , ;
                           '( ' +typPohybu +' ) _ ' + allTrim(c_typPoh->cnazTypPoh)  } )
      aadd( acombo_val, {  ''                                                      , ;
                           '         _ zásobník komletní seznam ' +cc                } )

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value := typPohybu
      ::cpvpTerm_filter := typPohybu
    endif
  return self

  inline method comboItemSelected(drgComboBox)
    local  value

     if isobject(drgComboBox)
       value  := drgComboBox:Value

       if( 'cpvpterm_filter' $ lower(drgComboBox:name) )
         ::cpvpTerm_filter := value
         ::set_pvpTerm_filter()
       endif
     endif
   return self


   inline method set_pvpTerm_filter()
     local c_filter

     if empty(::cpvpTerm_filter)
       pvpTerm->( ads_setAof(::m_filter), dbgoTop())
     else
       c_filter := format( ::m_filter +" .and. ctypPohybu = '%%'", {::cpvpTerm_filter} )
       pvpTerm->( ads_setAof(c_filter), dbgoTop())
     endif

     ::dc:oaBrowse:oXbp:refreshAll()
     setAppFocus( ::dc:oaBrowse:oXbp )
     PostAppEvent(xbeBRW_ItemMarked,,,::dc:oaBrowse:oXbp)
   return self


   inline method drgDialogEnd(drgDialog)
     ::o_DBro_pvpTerm:is_selAllRec := .f.
     ::o_DBro_pvpTerm:arSelect     := {}

     ::o_DBro_pvpTerm:oxbp:refreshAll()
   return self

HIDDEN:
  VAR     msg, dm, dc, ab

  *       cenZboz         pvpTerm
  var     o_DBro_cenZboz, o_DBro_pvpTerm

  var     m_filter, tabNum
  var     ost_context, ost_pvpTerm_filter
  var     is_vydej, it_file, hd_file

  METHOD  PVPTerm_CTRL_ENTER, PVPTerm_CTRL_A

  inline method pvpTerm_to_pvpItemWW( pnordItem )
    local  nMn

    mh_copyFld( 'pvpTerm' , 'pvpItemWW', .t.)
    mh_copyfld( 'pvpHeadW', 'pvpItemWW'     )
    *
    PVPITEMww->cNazPol1 := PVPTerm->cStredisko
    PVPITEMww->cNazPol2 := PVPTerm->cVyrobek
    PVPITEMww->cNazPol3 := PVPTerm->cZakazka
    PVPITEMww->cNazPol4 := PVPTerm->cVyrMisto
    PVPITEMww->cNazPol5 := PVPTerm->cStroj
    PVPITEMww->cNazPol6 := PVPTerm->cOperace
    *
    PVPITEMww->nrec_Term := PVPTERM->( RecNo())
    pnordItem++
    PVPITEMww->nordItem := pnordItem
    *
    nMn := KoefPrVC_MJ( PVPITEMww->cMJDokl1, CenZboz->cZkratJedn, 'CenZboz' )
    PVPITEMww->nCenNapDod := PVPITEMww->nCenaDokl1 / nMn
    *
    nMn := PrepocetMJ( PVPITEMww->nMnozDokl1, PVPITEMww->cMJDokl1, CenZboz->cZkratJedn, 'CenZboz' )
    PVPITEMww->nMnozPrDod := nMn
    *
    PVPITEMww->nCenaCelk := PVPITEMww->nCenNapDod * PVPITEMww->nMnozPrDod
    *
    * aktualizace plnìní v PVPTERM
    PVPTERM->nMnoz_PLN := PVPITEMww->nMnozDokl1
    PVPTERM->nStav_PLN := IF( PVPTERM->nMnoz_PLN > 0 .and. PVPTERM->nMnoz_PLN < PVPTERM->nMnozDokl1, 1,;
                          IF( PVPTERM->nMnoz_PLN = PVPTERM->nMnozDokl1, 2, 0))
    *
    * z CenZBOZ
    PVPITEMww->nKlicDPH   := CenZboz->nKlicDPH
    PVPITEMww->nUcetSkup  := CenZboz->nUcetSkup
    PVPITEMww->cUcetSkup  := PADR( CenZboz->nUcetSkup, 10)
    PVPITEMww->cZkratMENY := CenZboz->cZkratMENY
    PVPITEMww->cZkratJedn := CenZboz->cZkratJedn
    PVPITEMww->nKlicNAZ   := CenZboz ->nKlicNaz
    PVPITEMww->nZboziKAT  := CenZboz ->nZboziKAT
    PVPITEMww->cPolCen    := CenZboz->cPolCen
    PVPITEMww->cTypSKP    := CenZboz->cTypSKP
    PVPITEMww->cUctovano  := ' '
    PVPITEMww->nTypPOH    := IIF( PVPHEADw->nKARTA < 200,  1,;
                             IIF( PVPHEADw->nKARTA < 300, -1,;
                             IIF( PVPHEADw->nKARTA = 400,  1, 0 )))
    PVPITEMww->cCisZakaz  := IF( PVPITEMww->nTypPoh = -1, PVPITEMww->cNazPol3, PVPITEMww->cCisZakaz )
    PVPITEMww->cCisZakazI := PVPITEMww->cCisZakaz
    PVPITEMww->cCasPVP    := time()
    PVPITEMww->nRec_CenZb := CenZboz ->( RecNo())
    PVPITEMww->_nRecor    := 0
  return .t.

ENDCLASS

********************************************************************************
METHOD SKL_CENTERM_SEL:init(parent)
  ::drgUsrClass:init(parent)

  ::m_udcp          := parent:parent:udcp:hd_udcp
  ::oinf            := skl_pvpTerm_info():new()

  ::is_vydej        := .f.
  ::m_filter        := pvpTerm->( ads_getAof())
  ::cpvpTerm_filter := ''

  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
  * Možná na cfg.parametr budou chtít se pozicovat na záložku nasnímaných dat - zatím na ceník
  ::tabNum   := tabCENZBOZ

  ::hd_file  := if( ismemberVar( parent:parent:udcp, 'HD'), lower(parent:parent:udcp:HD), '' )
  ::it_file  := if( ismemberVar( parent:parent:udcp, 'IT'), lower(parent:parent:udcp:IT), '' )
RETURN self


method SKL_cenTerm_sel:drgDialogStart(drgDialog)
  Local  cmb_pvpTerm_filter
  local  obro_2, recNo
  *
  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := drgDialog:dataManager             // dataMananager
  ::dc     := drgDialog:dialogCtrl
  ::ab     := drgDialog:oActionBar:Members
  *
  ::o_DBro_cenZboz := drgDialog:odBrowse[1]
  ::o_DBro_pvpTerm := drgDialog:odBrowse[2]

      obro_2  := ::o_DBro_pvpTerm
  xbp_obro_2  := ::o_DBro_pvpTerm:oXbp
  xbp_obro_2:itemRbDown := { |mp1,mp2,obj| obro_2:createContext(mp1,mp2,obj) }

  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  ::hd_file  := if( ismemberVar( drgDialog:parent:udcp, 'HD'), lower(drgDialog:parent:udcp:HD), '' )
  ::it_file  := if( ismemberVar( drgDialog:parent:udcp, 'IT'), lower(drgDialog:parent:udcp:IT), '' )

  if ::hd_file = 'pvpheadw' .and. ::it_file = 'pvpitemww'
    ::is_vydej := ( (::hd_file)->ntypPoh = 2 )   // výdejky
  endif
  *
  recNo := cenZboz->( recNo())
  InCenZboz_akt()
  Check_TermERRs()
  cenZboz->( dbgoTo( recNo))


  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
  *
    cmb_pvpTerm_filter := ::dm:has('M->cpvpTerm_filter'):odrg
  ::ost_pvpTerm_filter := cmb_pvpTerm_filter:oxbp:parent

  if ::tabNum = tabCENZBOZ
    ::ost_pvpTerm_filter:hide()

    IF ::drgDialog:parent:udcp:cfg_nTypNabPol = 2
      cenzboz->( dbGoTO( ::drgDialog:parent:udcp:recCenZbo))
      ::drgDialog:odBrowse[2]:oXbp:refreshAll()
    endif
    *
     ::quickFiltrs:init( self                                                         , ;
                      { { 'Kompletní seznam        ', ''                             }, ;
                        { 'Aktivní položky         ', 'laktivni = .t.'               }, ;
                        { 'Neaktivní položky       ', 'laktivni = .f.'               }, ;
                        { 'Aktivní k dispozici <> 0', 'laktivni and nmnozDzbo <> 0'  } }, ;
                      'Ceník'                                                             )

  endif

  ::ost_context     := ::pb_context:oXbp:parent
  ::set_pvpTerm_filter()

  ::dm:refresh()
RETURN


method SKL_cenTerm_sel:itemMarked()
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  Local cKey := Upper( PVPTerm->cCisSklad) +  Upper( PVPTerm->cSklPol)
  *
  local  o_msg := ::msg:msgStatus, oPS
  local  c_file := ::dc:oaBrowse:cfile, termERRs, npos, cERRs := ''
  local  ofont, aATTR

  *
  * založit skl.kartu mùže pouze když neexistuje ( tj. buton je enabled)
  FOR x := 1 TO LEN( Members)
    IF  ::ab[x]:event = 'TERM_CENZBOZ_CRD'
      IF( PVPterm->lInCenZBOZ, ::ab[x]:oXbp:disable(), ::ab[x]:oXbp:enable() )
      ::ab[x]:oXbp:setColorFG( If( PVPterm->lInCenZBOZ, GraMakeRGBColor({128,128,128}),;
                                                        GraMakeRGBColor({0,0,0})))
    ENDIF
  NEXT

  o_msg:setCaption( '' )

  if ::dc:oaBrowse = ::o_DBro_pvpTerm

    CenZboz->( dbSeek( cKey,, 'CENIK03'))

    if .not. empty( termERRs := allTrim(pvpTerm->ctermERRs) )
      for x := 1 to len(termERRs) step 1
        npos  := val( termERRs,x,1)
        cERRs += ERR_TERM_POPIS[ pvpTerm->ntypPVP, npos] +'; '
      next

      oFont := XbpFont():new():create( "10.Arial Bold CE" )
      aAttr := ARRAY( GRA_AS_COUNT )

      oPS := o_msg:lockPS()

        GraSetFont( oPS, oFont )
        GraStringAt( oPS, { 4, 4}, cERRs )

      o_msg:unlockPS()
    endif
  endif

RETURN self


********************************************************************************
METHOD SKL_CENTERM_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit, lOK, cKey

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    IF ::tabNUM = tabCENZBOZ
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    ENDIF
    *
    IF ::tabNUM = tabPVPTERM
      IF ( lOK := InCenZboz_one( .T.) )
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
      ELSE
        drgMsgBox(drgNLS:msg( 'Položka nenalezena v ceníku zboží ...'  ))
      ENDIF
    ENDIF
    * uložíme si, ze které záložky jsme pøebírali - 1 = CenZboz, 2 = PVPTERM
    ::drgDialog:parent:cargo_usr := ::tabNum

  CASE nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
    DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY

    _clearEventLoop(.t.)
    ::dc:oBrowse[1]:oxbp:forceStable()
    ::dc:oBrowse[1]:oXbp:refreshAll()
    PostAppevent(xbeBRW_ItemMarked,,,::dc:oBrowse[1]:oXbp)
    return .t.

  /*
  CASE nEvent = drgEVENT_ACTION
    IF isCharacter(mp1) .and.  mp1 = 'TermToPVP'
       PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    ENDIF
   */
  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)

    CASE( mp1 = xbeK_CTRL_A)
      ::PVPTerm_CTRL_A()

    CASE( mp1 = xbeK_ALT_F1)
      Check_ERRsBOX()
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_CENTERM_SEL:post_bro_colourCode()
*
* Touto metodou se pøekrývá klávesa CTRL+ENTER na browse.
* Pokud položka nesplòuje podmínky, nesmí jít oznaèit.
RETURN ( ::PVPTerm_CTRL_ENTER())

* Oznaèení jednotlivého záznamu k pøenosu
********************************************************************************
METHOD SKL_CENTERM_SEL:PVPTerm_CTRL_ENTER()
  Local lOK := ( PVPterm->lInCenZboz .and. empty( PVPterm->cTermERRs ))
  *
  IF lOK
    RETURN .F.
  ELSE
      Check_ERRsBOX()
    RETURN .T.
  ENDIF
RETURN .T.

* Na CTRL+A se oznaèí všechny záznamy, které splòují podmínky pro pøenos do dokladu
********************************************************************************
METHOD SKL_CENTERM_SEL:PVPTerm_CTRL_A()
  Local x

  PVPterm->( dbGoTOP())
  DO WHILE !PVPterm->( eof())
    * K pøenosu se oznaèí jen položky, které jsou v ceníku a neobsahují chyby
    lOK := ( PVPterm->lInCenZboz .and. empty( PVPterm->cTermERRs ))
    IF lOK
       aadd( ::dc:oaBrowse:arselect, PVPTERM->( RecNo()) )
    ENDIF
    PVPterm->( dbSKIP())
  ENDDO
  PVPterm->( dbGoTOP())
  ::dc:oaBrowse:refresh()

RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:tabSelect( tabPage, tabNumber)
  LOCAL  x, lOk, oAktivni := ::dataManager:get('m->nAktivni', .f.)

  ::tabNUM := tabNumber
  lOk := ( ::tabNum = tabPVPTERM)
  *  aktivace/deaktivace tlaèítek pro záložky
  FOR x := 1 TO LEN( ::ab)
    IF Upper( ::ab[x]:event) $ 'REFRESHDATA,TERMTOPVP'
      IF( lOk, ::ab[x]:oXbp:enable(), ::ab[x]:oXbp:disable() )
    ENDIF
    *
    IF Upper( ::ab[x]:event) $ 'TERM_CENZBOZ_CRD'
      IF( lOk, nil,  ::ab[x]:oXbp:disable() )
    ENDIF
    ::ab[x]:oXbp:setColorFG( If( !lOk, GraMakeRGBColor({128,128,128}),;
                                       GraMakeRGBColor({0,0,0})))
   NEXT

   * aktivace/deaktivace quickfiltru a comba
   if tabNumber = 1
     ( ::ost_pvpTerm_filter:hide(), ::ost_context:show() )
   else
     ( ::ost_context:hide(), ::ost_pvpTerm_filter:show() )
     postAppEvent( xbeBRW_ItemMarked,,, ::o_DBro_pvpTerm:oxbp )
   endif
RETURN .T.

********************************************************************************
METHOD SKL_CENTERM_SEL:TermToPVP(drgDialog)
  local  cflt_pvpTerm := pvpTerm->(ads_getAof())
  local  recNo        := pvpTerm->( recNo())
  local  nsel, lrun_Sp, ncnt := 0
  local  ctitle       := 'Pøenos položek z terminálu do dokladu ...'
  local  cinfo        := 'Promiòte prosím,'                              +CRLF + ;
                         'požadujete pøenést do dokladu vybrané položky' +CRLF

  *
  local  nordItem := 0, isLock := PVPTERM->( FLock())

  IF !isLock
    RETURN nil
  ENDIF

  do case
  case  ::o_DBro_pvpTerm:is_selAllRec
    lrun_Sp := .t.

  case len(::o_DBro_pvpTerm:arSelect) <> 0
    pvpTerm->( ads_setAof('.F.'))
    pvpTerm->( ads_customizeAof(::o_DBro_pvpTerm:arSelect), dbgoTop())

    lrun_Sp := .t.
  otherWise
    pvpTerm->( ads_setAof('.F.'))
    pvpTerm->( ads_customizeAof( { pvpTerm->( recNo()) } ), dbgoTop() )

    lrun_Sp := ( pvpTerm->lincenZboz .and. empty( pvpTerm->ctermERRs ))
  endcase

  if lrun_Sp
    ::o_DBro_pvpTerm:oxbp:refreshAll()

    nrecs := pvpTerm->( Ads_GetKeyCount(1))
    cInfo += space(20) +'_  ' +str(nRecs,5) +'    _'

    nsel := ConfirmBox( , cinfo , ;
                          ctitle , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES

      pvpItemWW->_delrec := '9'
      * zjistíme poèet položek v dokladu, abysme mohli navázat s nOrdItem
      pvpItemWW->( dbGoBottom())
      nordItem := pvpItemWW->nordItem

      do while .not. pvpTerm->(eof())
        if ( pvpTerm->lincenZboz .and. empty( pvpTerm->ctermERRs ))
           cenZboz->( dbSeek( upper(pvpTerm->ccisSklad) + upper(pvpTerm->csklPol),,'CENIK03'))

           ::pvpTerm_to_pvpItemWW( @nordItem )
           ncnt++
        endif
        pvpTerm->(dbskip())
      enddo
    endif

    pvpTerm->( dbUnlock())
    pvpTerm->( ads_clearAof(), ads_setAof(cflt_pvpTerm), dbgoTo( recNo) )
//    ::o_DBro_pvpTerm:oxbp:refreshAll()

    pvpItemWW->( dbgoTop())
    *
    ** totální pitomost
    confirmBox( , 'Do pohybového dokladu [ ' +str(pvpHeadW->ndoklad,10) +' ]'  +CRLF + ;
                  'bylo ze zásobníku pøevzato '                                +CRLF + ;
                  space(7) +str(ncnt,5) +' položek/y z ' +str(nRecs,5) +' vybraných'   , ;
                  'Pøenos probìhl ' +if( ncnt = nRecs, 'úspìšnì', 'neúspìšnì') +' ...' , ;
                  XBPMB_OK                                                             , ;
                  XBPMB_INFORMATION+XBPMB_APPMODAL+XBPMB_MOVEABLE                        )

    _clearEventLoop(.t.)

    * nastaví stav dokladu na "rozpracován"
//    if( ncnt <> 0, drgDialog:parent:UDCP:uHd:set_saveBut(1), nil )

    * ukonèí výbìrový dialog z PVPTerm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, ::drgDialog:dialog )

//    drgDialog:parentdialog:cargo:udcp:lPrevzitTT := .T.
  endif
return .t.

* Aktualizece - refreš dat
********************************************************************************
METHOD SKL_CENTERM_SEL:RefreshDATA()
  *
  InCenZboz_akt()
  Check_TermERRs()
  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
RETURN self

********************************************************************************
METHOD SKL_CENTERM_SEL:doAppend( nEvent)
  LOCAL oDialog, nExit

  oDialog := drgDialog():new('SKL_CENZBOZ_CRD', ::drgDialog)
  oDialog:cargo := nEvent   // drgEVENT_APPEND
  oDialog:create(,,.T.)
  nExit := oDialog:exitState

  IF nExit = drgEVENT_SAVE
*    ::OnSave(,, oDialog )
    oDialog:dataManager:save()
    IF( oDialog:dialogCtrl:isAppend, CENZBOZ->( DbAppend()), Nil )
    IF CENZBOZ->(sx_RLock())
       mh_COPYFLD('CENZBOZw', 'CENZBOZ' )
*       mh_WRTzmena( 'C_PRACOV', ::lNewREC)
       CENZBOZ->( dbUnlock())
       ::drgDialog:dialogCtrl:browseRefresh()
    ENDIF

  ENDIF
  oDialog:destroy(.T.)
  oDialog := Nil
RETURN .T.

* Zobrazení zjištìných chyb na terminálových položkách - ALT + F1
*===============================================================================
FUNCTION Check_ERRsBOX()
  Local n, x, nTypPVP, cText := 'Terminálová položka obsahuje chyby : ;'
  *
  IF EMPTY( PVPTERM->cTermERRs)
    RETURN NIL
  ENDIF
  *
  FOR n := 1 TO LEN( Alltrim(PVPTERM->cTermERRs))
    x := Val( Substr( Alltrim(PVPTERM->cTermERRs), n, 1 ))
    cText += ' ;  ' + ERR_TERM_POPIS[ PVPTERM->nTypPVP, x]
  NEXT
  *
  drgMsgBox(drgNLS:msg( cText))
RETURN NIL

*===============================================================================
FUNCTION Check_TermERRs()
  Local cERR := '', cNs := ''

  IF PVPTerm->( FLock())
    drgDBMS:open('CENZBOZ',,,,, 'CenZBOZa' )
    PVPTerm->( dbGoTop())
    DO WHILE ! PVPterm->( Eof())
      CenZBOZa->( dbSeek( Upper(PVPterm->cCisSklad) + Upper(PVPterm->cSklPol),,'CENIK03'))
      cERR := ''
      cNs  := ''

      DO CASE
      Case PVPTERM->nTypPVP = 1        // Pøíjem
        * 1 = kontrola, zda cena pøijímané položky není nulová
        cERR += IF( PVPTERM->nCenaDokl1 = 0, STR( ERR_TERM_PRIJEM_CENA, 1), '' )

      Case PVPTERM->nTypPVP = 2        // Výdej
        * 1 = kontrola, zda vydávané množství nepøesahuje mn. skladové
        cERR += IF( (PVPTERM->nMnozDokl1 - PVPTERM->nMnoz_PLN) > CenZBOZa->nMnozsZBO,;
                    STR( ERR_TERM_VYDEJ_MNOZSKL, 1), '' )

        * 2 = kontrola, zda je vyplnìna nákladová struktura
         cNS += AllTrim( PVPTERM->cStredisko) + AllTrim( PVPTERM->cVyrobek)  + ;
                AllTrim( PVPTERM->cZakazka)   + AllTrim( PVPTERM->cVyrMisto) + ;
                AllTrim( PVPTERM->cStroj)     + AllTrim( PVPTERM->cOperace)
         cERR += IF( EMPTY( cNs), STR( ERR_TERM_VYDEJ_NAKLST, 1), '' )

      ENDCASE
      *
      PVPTERM->cTermERRs  := cERR

      PVPTerm->( dbSkip())
    ENDDO
    PVPterm->( dbUnlock(), dbGoTop())
    CenZBOZa->( dbCloseArea())
  ENDIF

RETURN NIL


#define  tabVYRPOL    2

********************************************************************************
* SKL_CENVYR_SEL ...     Výbìr z CenZboz a VyrPol
********************************************************************************
CLASS SKL_CENVYR_SEL FROM drgUsrClass

EXPORTED:
  VAR     nFilter
  METHOD  Init, EventHandled, drgDialogStart, drgDialogEnd, itemMarked, tabSelect
  METHOD  ComboItemSelected, KusOp_Copy

HIDDEN:
  VAR     dc, dm, tabNum, bro_Vyr
  METHOD  FilterOnVyrPol
ENDCLASS

********************************************************************************
METHOD SKL_CENVYR_SEL:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('VYRPOL'  )
  drgDBMS:open('VYRPOLw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('CenZBOZ' )
  drgDBMS:open('C_SKLADY')
  drgDBMS:open('C_DPH')
  CENZBOZ->( DbSetRelation( 'C_DPH', {||CENZBOZ->nKlicDPH },'CENZBOZ->nKlicDPH' ))
  drgDBMS:open('C_KATZBO')
  CENZBOZ->( DbSetRelation( 'C_KATZBO', {||CENZBOZ->nZboziKat },'CENZBOZ->nZboziKat' ))
  drgDBMS:open('C_UCTSKP')
  CENZBOZ->( DbSetRelation( 'C_UCTSKP', {||CENZBOZ->nUcetSkup } ,'CENZBOZ->nUcetSkup' ))
  *
  ::tabNum  := tabCENZBOZ
  ::nFilter := 1
RETURN self

********************************************************************************
METHOD SKL_CENVYR_SEL:drgDialogStart(drgDialog)
  *
  ::dc  := drgDialog:dialogCtrl
  ::dm  := drgDialog:dataManager
  ColorOfTEXT( ::dc:members[1]:aMembers )
  *
  ::bro_Vyr := drgDialog:odBrowse[tabVYRPOL]
  ::filterOnVyrPol()
*  ::drgDialog:odBrowse[2]:oXbp:refreshAll()
  *
RETURN

********************************************************************************
METHOD SKL_CENVYR_SEL:drgDialogEnd(drgDialog)
RETURN self

********************************************************************************
METHOD SKL_CENVYR_SEL:ItemMarked()
  LOCAL members  := ::drgDialog:oActionBar:Members, x
  Local cKey := Upper( VYRPOL->cCisSklad) +  Upper( VYRPOL->cSklPol)

  IF !EMPTY( VYRPOL->cCisSklad)
    CenZboz->( dbSeek( cKey,, 'CENIK03'))
  ENDIF

RETURN self
*
********************************************************************************
METHOD SKL_CENVYR_SEL:eventHandled(nEvent, mp1, mp2, oXbp)
  LOCAL oDialog, nExit, lOK, cKey, cCilZakaz, nRec, existPROCEN, existVYRPOL

  DO CASE
  CASE nEvent = drgEVENT_EXIT .or. nEvent = drgEVENT_EDIT
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,, oXbp)
    * uložíme si, ze které záložky jsme pøebírali - 1 = CenZboz, 2 = VYRPOL
    ::drgDialog:parent:cargo_usr := ::tabNum

    if ::tabNum = tabCENZBOZ
      cKey := Upper(CenZboz->cCisSklad) + Upper(CenZboz->cSklPol)
      existPROCEN := PROCENHO->( dbSeek( cKey,,'PROCENHO09'))
      existVYRPOL := VYRPOL->( dbSeek( cKey,,'VYRPOL9'))
    elseif ::tabNum = tabVYRPOL
      cKey := Upper(VyrPOL->cCisSklad) + Upper(VyrPOL->cSklPol)
      existPROCEN := PROCENHO->( dbSeek( cKey,,'PROCENHO09'))
      existVYRPOL := .T.
    endif
    * pro test
*    existPROCEN := .T.
*    existVYRPOL := .T.
    *
    ::drgDialog:parent:udcp:existPROCEN := existPROCEN
    ::drgDialog:parent:udcp:existVYRPOL := existVYRPOL

    IF nEvent = drgEVENT_EDIT .AND. existVYRPOL // ::tabNum = tabVYRPOL

      cCilZakaz := 'NAV-' + StrZero(NABVYSHDw->nCisFirmy, 5) + '-' + StrZero(NABVYSHDw->nDoklad,10)
      mh_CopyFld( 'VYRPOL' , 'VYRPOLw', .t.)
      *
      mh_CopyFld( 'VYRPOLw', 'VYRPOL' , .t.)
      VyrPOL->cCisZakaz  := cCilZakaz
      VyrPOL->nCisNabVys := NABVYSHDw->nDoklad
*      VyrPOL->nIntCount  := NABVYSITw->
//      VyrPOL->cUniqIdRec := VyrPOL->( mh_GetLastUniqID())
      VyrPOL->mUserZmenR := mh_WRTzmena( 'VyrPOL', .T.)
      nRec      := VyrPOL->( RecNo())
      VYR_VyrPOL_cpy( NIL, VyrPOLw->cCisZakaz, VyrPOLw->cVyrPol, VyrPOLw->nVarCis ,;
                           cCilZakaz         , VyrPOL->cVyrPol , VyrPOL->nVarCis  ,;
                     .T., .T.,.F. )

      VyrPOL->( dbGoTo(nRec))
      *
      NabVysITw->cCisZakaz  := cCilZakaz
      NabVysITw->cCisZakazI := cCilZakaz
      *
      ::itemMarked()
    ENDIF
    *
    IF nEvent = drgEVENT_EDIT .AND. existPROCEN
      * ??? zatím nevíme
    ENDIF

  CASE nEvent = drgEVENT_APPEND
    IF ::tabNum = tabCENZBOZ
      DRGDIALOG FORM 'SKL_CENZBOZ_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::dc:oBrowse[1]:oXbp:refreshAll()
    ELSEIF ::tabNum = tabVYRPOL
      DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO nEvent PARENT ::drgDialog DESTROY
      ::dc:oBrowse[2]:oXbp:refreshAll()
    ENDIF

  CASE nEvent = drgEVENT_FORMDRAWN
     Return .T.

  CASE nEvent = xbeP_Keyboard
    DO CASE
    CASE mp1 = xbeK_ESC
      PostAppEvent(xbeP_Close,,, oXbp)
    OTHERWISE
      RETURN .F.
    ENDCASE

  OTHERWISE
    RETURN .F.
  ENDCASE

RETURN .T.

********************************************************************************
METHOD SKL_CENVYR_SEL:tabSelect( tabPage, tabNumber)
  LOCAL odrg := ::dm:has('m->nFilter'), oActions

  ::tabNUM := tabNumber
  odrg:oDrg:disabled := ( ::tabNUM = 1)
  odrg:oDrg:isEdit   := ( ::tabNUM = 2)
  *
  if ::tabNUM = 1
    odrg:oDrg:oXbp:hide()
  elseif ::tabNUM = 2
    odrg:oDrg:oXbp:show()
  endif
  *
  oActions := ::drgDialog:oActionBar:members
  for x := 1 to len(oActions)
    if ( lower( oActions[x]:event) $ 'vyr_vyrpol_info,kusop_copy' )   //aEventsDisabled)
      if ::tabNUM = 1
        oActions[x]:oXbp:hide()
      elseif ::tabNUM = 2
        oActions[x]:oXbp:show()
      endif
    endif
  next
  *
RETURN .T.

********************************************************************************
METHOD SKL_CENVYR_SEL:comboItemSelected( Combo)
  ::nFilter := Combo:value
  ::filterOnVyrPol()
RETURN .T.

* Kopie
********************************************************************************
METHOD SKL_CENVYR_SEL:KusOp_Copy()
  Local  cZdroj_VyrPol := STR( VyrPOL->( RecNO()) )
  Local  cCil_VyrPol   := STR( VyrPOL->( RecNO()) )
  /* ORG
  DRGDIALOG FORM 'VYR_VYRPOL_copy' CARGO cZdroj_VyrPol + ',' + cCil_VyrPol ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:odBrowse[1]:oxbp:refreshAll()
  */
  DRGDIALOG FORM 'VYR_VYRPOL_CRD' CARGO drgEVENT_APPEND2 ;
                                   PARENT ::drgDialog MODAL DESTROY
  ::mainBro:oxbp:refreshAll()
  */
RETURN self

*** HIDDEN *********************************************************************
METHOD SKL_CENVYR_SEL:filterOnVyrPol()
  Local cFilter := "cCisZakaz = '%%'"
  Local aFilter := ;
        { { EMPTY_VYRPOL},;                            // Všechny nezakázkové
        { 'NAV'}         ,;                            // Všechny nabídkové
        { 'NAV-' + StrZero( NABVYSHDw->nCisFirmy, 5)}} // Nabídkové k firmì
  *
  cFilter := Format( cFilter, aFilter[ ::nFilter] )
  VyrPol->( mh_SetFilter( cFilter))
  *
  ::bro_Vyr:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,::bro_Vyr:oxbp)
  SetAppFocus(::bro_Vyr:oXbp)
RETURN .T.