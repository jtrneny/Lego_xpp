#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "dbstruct.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for PER_pershead_IN **************************************************
CLASS PER_pershead_IN from drgUsrClass, per_cmp_navrhPL
EXPORTED:
  method  init, drgDialogStart
  method  preValidate, postValidate


  inline method comboItemSelected(drgComboBox,isMarked)
    local  value := drgComboBox:Value, values := drgComboBox:values
    local  tabPage := ::tabPage
    local  odrg
    *
    do case
    case ( value = 'lekProhl' )
      ( ::otab_lekProhl:oxbp:enable(), ::otab_lekProhl:oxbp:maximize(), ::otab_lekProhl:isEdit := .t. )
      ( ::otab_skoleni:oxbp:disable(), ::otab_skoleni:oxbp:minimize() , ::otab_skoleni:isEdit  := .f. )
      ::tabPage := 1

    case ( value = 'skoleni'   )
      ( ::otab_skoleni:oxbp:enable()  , ::otab_skoleni:oxbp:maximize() , ::otab_skoleni:isEdit  := .t.)
      ( ::otab_lekProhl:oxbp:disable(), ::otab_lekProhl:oxbp:minimize(), ::otab_lekProhl:isEdit := .f.)
      ::tabPage := 2
    endcase

    if tabPage <> ::tabPage
      persHeadW->( dbdelete(), dbappend() )
      persHeadW->ctypPohybu := value

      ::refresh()
      ::cmp_navrhPL()
      ::oDBro_main:oxbp:refreshAll()
    endif

    persHeadW->ctypPohybu := value
    ::enable_or_disable_items()
  return self


  inline method per_czkratka_sel(drgDialog)
    local  odrg   := ::has_oDrg(::hd_file +'->czkratka' )
    local  value  := odrg:value
    *
    local  odialog, nexit := drgEVENT_QUIT, ok := .f., copy := .f.
    local  cformName, ctagName

    if( ::tabPage = 1, ( cformName := 'c_lekPro', ctagName := 'C_LEKPRO01' ), ;
                       ( cformName := 'c_skolen', ctagName := 'C_SKOLEN01' )  )

    Ok    := ( .not. empty(value) .and. (cformName) ->(dbseek(upper(value),,ctagName)) )

    if isObject(drgDialog) .or. .not. ok

      odialog := drgDialog():new( cformName, ::drgDialog)
      odialog:cargo := value
      odialog:create(,,.T.)
      nexit := odialog:exitState
    endif

    if (nexit = drgEVENT_SELECT) .or. ok
      odrg:set( (cformName)->czkratka )
      persHeadW->czkratka   := (cformName)->czkratka
      persHeadW->cnazevT_LS := (cformName)->cnazev

      ::refresh( odrg )
    endif
  return (nexit = drgEVENT_SELECT) .or. ok


  inline method per_czkratk_LS_sel(drgDialog)
    local  odrg   := ::has_oDrg(::hd_file +'->czkratk_LS' )
    local  value  := odrg:value
    *
    local  odialog, nexit := drgEVENT_QUIT, ok := .f., copy := .f.
    local  cformName, ctagName

    if( ::tabPage = 1, ( cformName := 'c_lekari', ctagName := 'C_LEKARI01' ), ;
                       ( cformName := 'c_skolit', ctagName := 'C_SKOLIT01' )  )

    Ok    := ( .not. empty(value) .and. (cformName) ->(dbseek(upper(value),,ctagName)) )

    if isObject(drgDialog) .or. .not. ok
      odialog := drgDialog():new( cformName, ::drgDialog)
      odialog:cargo := ''
      odialog:create(,,.T.)
      nexit := odialog:exitState
    endif

    if (nexit = drgEVENT_SELECT) .or. ok
      if ::tabPage = 1
        persHeadW->czkratk_LS := c_lekari->cZkratLeka
        persHeadW->cnazev_LS  := c_lekari->cNazevLeka
        persHeadW->codborn_LS := c_lekari->cOdbornLek
      else
        persHeadW->czkratk_LS := c_skolit->cZkratSkol
        persHeadW->cnazev_LS  := c_skolit->cNazevSkol
        persHeadW->codborn_LS := c_skolit->cLektor
      endif

      mh_copyFld( cformName, 'persHeadW' )
      odrg:set(persHeadW->czkratk_LS)
      ::refresh( odrg )
    endif
  return (nexit = drgEVENT_SELECT .or. ok)


  inline method onSave(lOk,isAppend,oDialog)
    local  anPer    := {}
    local  mainOk   := .t., nrecOr
    *
    local  cStatement, oStatement
    local  c_in_1 := '', c_in_9 := ''
    local  stmt   := "update %cfile_iv set nstav_Pol = 1 where sID in (%c_in_1);" + ;
                     "update %cfile_iv set nstav_Pol = 0 where sID in (%c_in_9);"
    local  cfile_iv := persitemW->cfile_iv

    persitemW->( adsSetOrder(0), dbgoTop())
    do while .not. persitemW->(eof())
      aadd( anPer, persitemW->_nrecOr)

      if persitemW->_delRec = '9'
        c_in_9 += allTrim(str(persitemW->nfile_iv)) +','
      else
        c_in_1 += allTrim(str(persitemW->nfile_iv)) +','
      endif

      persitemW->( dbskip())
    enddo
    persitemW->( dbgoTop())

    * oprava
    if .not. ::lnewRec
      mainOk := mainOk                      .and. ;
                pershead->( sx_Rlock())     .and. ;
                persitem->( sx_rLock(anPer))
    endif


    if mainOk
      mh_copyFld( 'persHeadW', 'persHead', ::lnewRec, .f. )

      do while .not. persitemW->( eof())

        if((nrecOr := persitemW->_nrecor) = 0, nil, persitem->(dbgoto(nrecor)))

        if persitemW->_delRec = '9'
          if( nrecOr <> 0, persitem->( dbdelete()), nil )
        else
          persitemW->nstav_Pol := 1   // naplánovaná  
          persitemW->nPERSHEAD := pershead->sID
          mh_copyFld('persitemW', 'persitem', (nrecOr=0), .f. )
        endif

        persitemW->( dbskip())
      endDo

      c_in_1     := if( len(c_in_1) = 0, '0', subStr ( c_in_1, 1, len(c_in_1)-1 ))
      c_in_9     := if( len(c_in_9) = 0, '0', subStr ( c_in_9, 1, len(c_in_9)-1 ))

      cStatement := strTran( stmt      , '%c_in_1'  , c_in_1   )
      cStatement := strTran( cStatement, '%c_in_9'  , c_in_9   )
      cStatement := strTran( cStatement, '%cfile_iv', cfile_iv )
      oStatement := AdsStatement():New(cStatement, oSession_data)

      if oStatement:LastError > 0
        *  return .f.
      else
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
      endif

    else
      drgMsgBox(drgNLS:msg('Nelze uložit návrh plánu, blokováno uživatelem ...'))
    endif

    pershead->(dbunlock(),dbcommit())
    persitem->(dbunlock(),dbcommit())

    if isObject(::odata)
      if( mainOk, ::odata:nstav_Pol := 1, nil )
    endif

    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
  return mainOk

  *
  ** body class
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  olastDrg := ::df:olastDrg
    local  value, nin, ocolumn

    * My
    * myší se snaží dostat na BROw položky, je potøeba zkotrolovat hlavièku
    if nevent = xbeM_LbClick
      if( oxbp:className() = 'XbpCellGroup' .and. .not. ::is_persHeadwOk )
        ::is_persHeadwOk := ::postValidateForm(::hd_file)
        return .t.
      endif
    endif


    do case
    case (nevent = drgEVENT_OBJENTER .and. (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse') )
      ::is_persHeadwOk := ::postValidateForm(::hd_file)

    case ( nevent = drgEVENT_DELETE )
*      if .not. apohybakW->( eof())

*        value := ::dm:get('apohybakW->czkrTYPpoh')
*        nin   := AScan(::aCOMBO_val, {|X| X[1] = value })

*        if drgIsYesNo( 'Zrušit položku pohybu_ ' + allTrim(::aCOMBO_val[nin,2]) +' _ ;;    '  +allTrim(apohybakW->cjmenoNew) +' / ' +allTrim(str(apohybakW->nhodnotaAk,13,2)) +' CZK' )
*          if( apohybakW->_nrecOr = 0, apohybakW->( dbdelete()), apohybakW->_delRec := '9' )

*          ::oEBro_apohybakW:oxbp:goTop()
*          ::oEBro_apohybakW:oxbp:refreshAll()

*          ::sumColumn()

          * pošlem zprávu pro nastavení rámeèku na první sloupec ... cZkrTypAkc
*          ocolumn := ::oEBro_apohybakW:getColumn_byName( 'akcieW->cZkrTypPoh' )
*          postAppEvent(xbeBRW_ItemMarked, 1, 1, oColumn:dataArea)
*        endif
*      endif
      return .t.

*    case nEvent = drgEVENT_EDIT
*      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)
*    case nEvent = drgEVENT_EXIT
*      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    otherwise
      return .f.
    endCase
  return .t.


HIDDEN:
* sys
  var  msg, dm, dc, df, brow
  var  lnewRec, hd_file, it_file
  var  is_persHeadwOk

  var  cmb_typPoh
  var  oDBro_main, oget_ddatNAV_od, oget_ddatNAV_do
  var  pa_onTabs, tabPage
  var  otab_lekProhl, otab_skoleni
  var  odata


  inline method has_oDrg(cname)
    local  value := ::cmb_typPoh:value
    local  pa    := ::pa_onTabs

    nin := ascan( pa, { |o| o:tipText = value .and. o:name = cname  } )
    return pa[nin]:ovar


  inline method enable_or_disable_items()
    local  value := ::cmb_typPoh:value
    local  pa    := ::pa_onTabs, x

    for x := 1 to len(pa) step 1
      if pa[x]:tipText = value
        if ::drgDialog:cargo = drgEVENT_APPEND
          ( pa[x]:oxbp:enable() , pa[x]:isEdit := .t. )
        else
          if( pa[x]:isEdit_inRev, pa[x]:oxbp:enable(), pa[x]:oxbp:disable() )
          pa[x]:isEdit := pa[x]:isEdit_inRev
        endif
      else
        ( pa[x]:oxbp:disable(), pa[x]:isEdit := .f. )
      endif
    next
  return self


  inline method refresh(drgVar)
    LOCAL  nIn, nFs, odrg, xval
    LOCAL  oVAR, vars := ::drgDialog:dataManager:vars

    for nIn := 1 to vars:size() step 1
      oVar := vars:getNth(nIn)

      if isBlock( ovar:block )
        xVal := eval( ovar:Block )

        if ovar:value <> xVal
          ovar:initValue := ovar:prevValue := ovar:value := xval
          ovar:odrg:refresh( xVal )
        endif
      endif
    NEXT
  RETURN .T.
  *
  * postValidateForm
  inline method postValidateForm(m_file)
    local  values := ::dm:vars:values, size := ::dm:vars:size(), x, file
    local  drgVar
    *
    begin sequence
      for x := 1 to size step 1
        file := lower(if( ismembervar(values[x,2]:odrg,'name'),drgParse(values[x,2]:odrg:name,'-'), ''))

        if file = m_file .and. values[x,2]:odrg:isEdit
          drgVar := values[x,2]
          isOk    := isNull(drgVar:odrg:postValidOk, .f. )

          if isOk
          else
            if .not. ::postValidate(drgVar)

              ::df:olastdrg   := values[x,2]:odrg
              ::df:nlastdrgix := x
              ::df:olastdrg:setFocus()
              return .f.
    break
            else
              drgVar:odrg:postValidOk := .t.
            endif
          endif
        endif
      next
    end sequence
  return .t.

ENDCLASS


METHOD PER_pershead_IN:init(parent)
  local  odata, c_cisLS, c_tagLS


  ::drgUsrClass:init(parent)
  ::per_cmp_navrhPL:init()


  (::hd_file     := 'persheadw', ::it_file := 'persitemw')
   ::lnewRec     := .not. (parent:cargo = drgEVENT_EDIT)

  ::tabPage        := 1
  ::is_persHeadwOk := .f.
  *
  * tady se musí dát pozor, pokud to pùjde z parenta PER_pershead_navPL - BUTTON
  * ctypPohybu, ddatNAV_od, ddatNAV_do, czkratka je nastaveno noEdit
  *
  * INS   z pohledu persHead vše je edit
  * ENTER z pohledu persHead ???
  *
  if isObject( parent:parent )
    if lower(parent:parent:formName) = 'per_pershead_navpl'
      ::odata := parent:parent:udcp:odata  // persitemW - current record
    endif
  endif

  if( isObject(::odata) .or. ::lnewRec )
    persHeadW->( dbappend())
  else
    ::tabPage := if( pershead->ctypPohybu = 'lekProhl', 1, 2 )
    mh_copyFld( 'PERSHEAD', 'PERSHEADw', .t., .t. )
    persitem->( dbeval( { || mh_copyFld( 'PERSITEM', 'PERSITEMw', .t., .t. ) } ), dbgoTop() )
  endif


  if isObject(::odata)
    ::tabPage             := if( ::odata:ctypPohybu = 'lekProhl', 1, 2 )

    persHeadW->ctypPohybu := ::odata:ctypPohybu      // skoleni / lekProhl
    ::ddatNAV_od := parent:parent:udcp:ddatNAV_od
    ::ddatNAV_do := parent:parent:udcp:ddatNAV_do

    persHeadW->czkratka   := ::odata:czkratka
    persHeadW->cnazevT_LS := ::odata:cnazevT_LS
    persHeadW->czkratk_LS := ::odata:czkratk_LS
    persHeadW->cnazev_LS  := ::odata:cnazev_LS
    persHeadW->codborn_LS := ::odata:codborn_LS
    persHeadW->czkratkaUK := ::odata:czkratkaUK

    c_cisLS := if( ::tabPage = 1, 'c_lekari'  , 'c_skolit'  )
    c_tagLS := if( ::tabPage = 1, 'C_LEKARI01', 'C_SKOLIT01')

    (c_cisLS)->( dbseek( upper(::odata:czkratk_LS),,c_tagLS))
    mh_copyFld( c_cisLS, 'persHeadW' )

    parent:cargo := drgEVENT_EDIT // drgEVENT_APPEND
  endif

  ::caof_persitem := format( "ddatPREDko >= '%%' and ddatPREDko <= '%%'", {::ddatNAV_od, ::ddatNAV_do} )
  ::cond_inRange  := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"') .and. " +"ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"

  if( isObject(::odata), ::cmp_navrhPL(), nil )
return self


METHOD PER_pershead_IN:drgDialogStart(drgDialog)
  local  pa_groups, nin
  local  members := drgDialog:oForm:aMembers
  local  x, odrg, groups, name, tipText
  *
  local  acolors  := MIS_COLORS

  ::msg             := drgDialog:oMessageBar             // messageBar
  ::dm              := drgDialog:dataManager             // dataManager
  ::dc              := drgDialog:dialogCtrl              // dataCtrl
  ::df              := drgDialog:oForm                   // form

  ::oDBro_main      := drgDialog:dialogCtrl:oBrowse[1]

  ::cmb_typPoh      := ::dm:has('persHeadW->ctyppohybu'):odrg
  ::oget_ddatNAV_od := ::dm:has('M->ddatNAV_od'):odrg
  ::oget_ddatNAV_do := ::dm:has('M->ddatNAV_do'):odrg

  ::pa_onTabs     := {}
**  ::tabPage       := 1

  for x := 1 TO len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)
    name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
    tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')
    *
    * font a barva u textù
    if  odrg:ClassName() = 'drgText' .and. .not. empty(groups)
      if 'SETFONT' $ groups
        pa_groups := ListAsArray(groups)
        nin       := ascan(pa_groups,'SETFONT')

        odrg:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            odrg:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          odrg:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif

    if odrg:ClassName() =  'drgTabPage'
      if( odrg:subs = 'lekProhl', ::otab_lekProhl := odrg, ::otab_skoleni := odrg )
**      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif

    if odrg:ClassName() = 'drgStatic'
**      odrg:oxbp:setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
    endif
    if( tipText = 'lekProhl' .or. tipText = 'skoleni', aadd( ::pa_onTabs, odrg ), nil )
  next

  ::comboItemSelected( ::cmb_typPoh,0)
**  ::cmp_navrhPL()
return self


METHOD PER_pershead_IN:preValidate(drgVar)
  local  value := drgVar:get()
  local  name  := Lower(drgVar:name)
  local  file  := drgParse(name,'-'), lok := .t.

return lok


METHOD PER_pershead_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := lower(drgParse(name,'-')), field_name := lower(drgParseSecond(drgVar:name, '>'))
  local  ok    := .t., changed := drgVAR:changed(), cc
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F.
  local  odatPL_od, odatPL_do

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
    * kontroly v záhlaví karty ddatNAV_od - ddatNAV_do
    case( name = 'm->ddatnav_od' .or. name = 'm->ddatnav_do' )

      if( name = 'm->ddatnav_od', ::ddatNAV_od := value, ::ddatNAV_do := value )
      *
      ** od - do nemùže být prázdné
      if ( name = 'm->ddatnav_do' )
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if ( empty(::ddatNAV_od) .and. empty(::ddatNAV_do) )
            ::ddatNAV_od := date()
            ::oget_ddatNAV_od:ovar:set(::ddatNAV_od )

            ::ddatNAV_do := ::ddatNAV_od + ::nrangeNav
            ::oget_ddatNAV_do:ovar:set(::ddatNAV_do )
          endif
        endif
      endif

      do case
      case( .not. empty(::ddatNAV_od) .and.       empty(::ddatNAV_do) )
        ::caof_persitem_new := format( "ddatPREDko >= '%%'", {::ddatNAV_od} )
        ::cond_inRange      := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"')"

      case(       empty(::ddatNAV_od) .and. .not. empty(::ddatNAV_do) )
        ::caof_persitem_new := format( "ddatPREDko <= '%%'", {::ddatNAV_do} )
        ::cond_inRange      := "ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"

      otherwise
        if( ::ddatNAV_od > ::ddatNAV_do )
          ::ddatNAV_do := ctod('  .  .  ')
          ::oget_ddatNAV_do:ovar:set(::ddatNAV_od )
        else
          ::caof_persitem_new := format( "ddatPREDko >= '%%' and ddatPREDko <= '%%'", {::ddatNAV_od, ::ddatNAV_do} )
          ::cond_inRange      := "ddatPREDko >= ctod('" +dtoc(::ddatNAV_od) +"') .and. " +"ddatPREDko <= ctod('" +dtoc(::ddatNAV_do) +"')"
        endif
      endcase

      if ( name = 'm->ddatnav_do' )
        if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
          if ::caof_persitem <> ::caof_persitem_new
             ::caof_persitem := ::caof_persitem_new

             persitem->( ads_setAof(::caof_persitem_new), dbgotop())
**           ::cmp_navrhPL()
**           ::oDBro_main:oxbp:refreshAll()
           endif
         endif
       endif

    *
    * kontroly na hlavièce persHeadW
    case( file = ::hd_file )

      odatPL_od := ::has_oDrg(::hd_file +'->ddatPL_od' )
      odatPL_do := ::has_oDrg(::hd_file +'->ddatPL_do' )

      do case
      case( field_name = 'czkratka' )
        ok := ::per_czkratka_sel()

      *               ddatPL_od, ddatPL_do               not EMPTY
      * ddatNAV_od >= ddatPL_od, ddatPL_do <= ddatNAV_do
      *               ddatPL_od <= ddatPL_do
      *
      case( field_name = 'ddatpl_od' )
        do case
        case empty(value)
          ::msg:writeMessage('Datum plánu (OD) je povinný údaj ...',DRG_MSG_ERROR)
          ok := .f.
        case .not. ( value >= ::ddatNAV_od .and. value <= ::ddatNAV_do )
          ::msg:writeMessage('Datum plánu (OD) je mimo rozsah návrhu ...',DRG_MSG_ERROR)
          ok := .f.
        endcase

        if ok .and. ( empty( (::hd_file)->ddatPL_do) .or. value > (::hd_file)->ddatPL_do)
           odatPL_do:set(value)
           (::hd_file)->ddatPL_do := value
        endif

      case( field_name = 'ddatpl_do' )
        do case
        case empty(value)
          ::msg:writeMessage('Datum plánu (DO) je povinný údaj ...',DRG_MSG_ERROR)
          ok := .f.
        case .not. ( value >= ::ddatNAV_od .and. value <= ::ddatNAV_do )
          ::msg:writeMessage('Datum plánu (DO) je mimo rozsah návrhu ...',DRG_MSG_ERROR)
          ok := .f.
        case .not. ( value >= odatPL_od:value )
          ::msg:writeMessage('Datum plánu (DO) je chybné ...',DRG_MSG_ERROR)
          ok := .f.
        endcase

      case( field_name = 'czkratk_ls' )
        ok := ::per_czkratk_LS_sel()

      endcase
  endcase

  * na persHeadW ukládme vždy
  if('persheadw' $ name .and. ok, drgVAR:save(),nil)
RETURN ok