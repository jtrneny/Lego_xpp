#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
//
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for NAK_intpozad_IN *******************************************
CLASS NAK_intpozad_IN FROM drgUsrClass, quickFiltrs
exported:
  method  init, drgDialogInit, drgDialogStart, drgDialogEnd
  method  postValidate
  *
  method  skl_cenzboz_sel, fir_firmy_sel, vyr_vyrzakit_sel, pro_vyrzakit_sle_OSB_sel

  method  eBro_beforSaveEditRow, eBro_saveEditRow
  method  nak_intPozad_to_objVys


  * intPozad položky - BRo
  inline access assign method bmp_stavDokl() var bmp_stavDokl
    local  stavDokl := intPozad->cstavDokl
    local  retVal   := 0

    retVal := if( stavDokl = 'U', MIS_ICON_OK   , ;
               if( stavDokl = 'R', 510          , ;
                if( stavDokl = 'K', MIS_BOOKOPEN, ;
                 if( stavDokl = 'O', MIS_BOOK   , ;
                  if( stavDokl = 'S', MIS_NO_RUN, 0 )))))

    return retVal


  inline access assign method nazFirmy() var nazFirmy
    local  cisFirmy := intPozad->ncisFirmy
    firmy->( dbseek( cisFirmy,,'FIRMY1'))
  return firmy->cnazev

  inline access assign method cenaOzbo() var cenaOzbo
    local  cky := strZero( ::cisFirmy:value,5) +::cisSklad:value +::sklPol:value

    dodzboz->(dbseek(cky,,'DODAV6'))
    return if( dodzboz->ncenaOzbo = 0, dodzboz->ncenaNzbo, dodzboz->ncenaOzbo)

  inline method ebro_afterAppend( drgEBrowse )
    local cisOsoby := logcisOsoby

    osoby->( dbseek( cisOsoby,,'OSOBY01'))
    *
    ** pro nový záznam musíme zanulovat info a pomocné položky
    ::it_cisOsoZpr:set( cisOsoby          )
    ::it_nazOsoZpr:set( osoby->cjmenoRozl )
    ::it_cisOsoVyr:set( cisOsoby          )
    ::it_nazOsoVyr:set( osoby->cjmenoRozl )

    ::it_poznobj:oxbp:clear()
    ::it_poznamka:oxbp:clear()

    ::it_cisOs_pro:set(0)
    ::it_cisZakaz:set('')
  return .t.

  inline method comboItemSelected(drgCombo,mp2,o)
    local value, values

    if isObject(drgCombo)
      value  := drgCombo:Value
      values := drgCombo:Values

      do case
      case 'cstavdokl' $ lower(drgCombo:name)
        if value = 'K '
          if (::it_file)->ncisFirmy <> 0       .and. ;
             .not. empty((::it_file)->cnazZbo) .and. ;
             .not. empty((::it_file)->dtermDod)

          else
            drgCombo:refresh( drgCombo:ovar:prevValue )
          endif
        endif
      endcase
    endif
  return self

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  cisOsoby := logcisOsoby
    local  brow, ocolumn, rowPos, colPos, arDef, citem, ctype, cval, xVal, npos

    do case
    case nevent = drgEVENT_APPEND2
      if isNull( intPozad->sID, 0) <> 0
        int_Pozad->( dbseek( isNull( intPozad->sID, 0),, 'ID'))
        osoby    ->( dbseek( cisOsoby,,'OSOBY01'))

        mh_copyFld( 'int_Pozad', 'intPozad', .t. )

        (::it_file)->ncisOsoZpr := cisOsoby
        (::it_file)->cNazOsoZpr := osoby->cjmenoRozl
        (::it_file)->ddatObDod  := ctod('  .  .  ')
        (::it_file)->dtermDod   := ctod('  .  .  ')
        (::it_file)->ccisZakazI := ''
        (::it_file)->cstavDokl  := ''

        (::it_file)->( dbunlock(), dbcommit())
        ::oEBro:oxbp:refreshAll()
      endif
*
     case nEvent = xbeP_Keyboard
     *
     * podivná úprava pro klávesu + pøevezme hodnotu z horního øádku, zaèalo to ve mzdách
     if chr(mp1) = '+' .and. oxbp:className() $ 'XbpGet,XbpDrgComboBox,XbpComboBox' .and. ::oEBro:oxbp:rowPos <> 1
       brow    := ::oEBro:oxbp
       arDef   := ::oEBro:ardef

       colPos  := ascan( arDef, {|x| x[7]:oxbp = oxbp } )
       rowPos  := brow:rowPos -1

       if ( colPos <> 0 )
         brow:colPos := colPos
         ocolumn     := brow:getColumn( colPos )

         citem   :=          ocolumn:defColum[2]
         ctype   := valType( ocolumn:defColum[7]:oVar:value )
         cval    := brow:getColumn( colPos ):getRow( rowPos )

         if isNull( cval )
           cVal := if( ctype == 'L', .f.                 , ;
                    if( ctype == 'D', cToD( '  .  .  ' ) , ;
                     if( ctype == 'N', '0', ''         ) ) )

         endif

         if ocolumn:type <> XBPCOL_TYPE_TEXT
           xVal := isNull( cVal, 0 )
         else
           xVal := if( ctype == 'L', If( cval, '.T.', '.F.' ) , ;
                    if( ctype == 'D', cToD( cval )            , ;
                     if( ctype == 'N', val( strTran(cval, ',', '.')), cval    ) ) )
         endif

         if oxbp:className() $ 'XbpDrgComboBox,XbpComboBox'
            npos := ascan( arDef[colPos,7]:values, {|x| x[2] = xVal} )
            xVal := arDef[colPos,7]:values[max(npos,1),1]
         endif

         ::dm:set( citem, xVal )
         ::postValidate(arDef[colPos,7]:oVar )

         PostAppEvent(xbeP_Keyboard,xbeK_TAB,,oXbp)
         return .t.
       endif
     endif


    case nevent = xbeBRW_ItemMarked
/*
      if intPozad->cstavDokl = 'K'
        ::oBtn_intPozad_to_objVys:enable()
      else
        ::oBtn_intPozad_to_objVys:disable()
      endif
*/
    endcase
  return .f.

hidden:
* sys
  var     msg, dm, dc, df, it_file, oEBro
* datové
  var     cisSklad, sklPol, cisFirmy, cenNAOdod, cisZakazI
  var     stavDokl, lopn_stavDokl
  var     it_cisOsoZpr, it_nazOsoZpr, it_cisOsoVyr, it_nazOsoVyr
  var     it_poznobj  , it_poznamka , it_cisOs_pro, it_cisZakaz
  var     oBtn_intPozad_to_objVys


  inline method itSave(panGroup)
    local  x, ok := .t., vars := ::dm:vars
    local  drgVar, groups

    for x := 1 to ::dm:vars:size() step 1
      drgVar := ::dm:vars:getNth(x)
      groups := isNull( drgVar:odrg:groups, '' )

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. (groups = panGroup)
        if (eval(drgvar:block) <> drgVar:value) // .and. .not. drgVar:rOnly
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
  return self


  inline method itSave_to_objVys( dm )
    local  x, ok := .t., vars := dm:vars, drgVar, ok_it

    for x := 1 to dm:vars:size() step 1
      drgVar := dm:vars:getNth(x)

      * musí to být jen objvyshdw, objvysitw
      ok_it := ( at( 'objvyshdw', lower(drgVar:name)) <> 0 .or. ;
                 at( 'objvysitw', lower(drgVar:name)) <> 0      )

      if isblock(drgVar:block) .and. at('M->',drgVar:name) = 0 .and. ok_it
        if (eval(drgvar:block) <> drgVar:value)
          eval(drgVar:block,drgVar:value)
        endif
        drgVar:initValue := drgVar:value
      endif
    next
  return self

ENDCLASS


method NAK_intpozad_IN:init(parent)
  local  filtr := '', l_isopn

  ::drgUsrClass:init(parent)
  *
  ::it_file        := 'intpozad'

  ::lopn_stavDokl := .f.
  if( isLogical( l_isopn := SysConfig('Nakup:cstavDokl')), ::lopn_stavDokl := l_isopn, nil )

  drgDBMS:open('cenZboz' )
  drgDBMS:open('dodZboz' )
  drgDBMS:open('firmy'   )
  drgDBMS:open('vyrzakit')
  drgDBMS:open('osoby'   )
  drgDBMS:open('c_dph'   )
  drgDBMS:open('intPozad',,,,,'int_Pozad' )
  *
  drgDBMS:open('vazSpoje')
  drgDBMS:open('spojeni')
  *
return self


method NAK_intpozad_IN:drgDialogInit(drgDialog)
  local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

*  drgDialog:hasIconArea := drgDialog:hasActionArea := ;
*  drgDialog:hasMsgArea  := drgDialog:hasMenuArea   := drgDialog:hasBorder := .F.
*  XbpDialog:titleBar    := .F.
return


method  NAK_intpozad_IN:drgDialogStart(drgDialog)
  local  x, members := drgDialog:oForm:aMembers, odrg
  local        obro := drgDialog:dialogCtrl:obrowse[1], ocolumn
  local       obord := drgDialog:obord
  local  odesc, pa_it := {}, pa_quick := {{ 'Kompletní seznam       ', ''                 }, ;
                                          { 'Není objednáno         ', 'cstavDokl <> "O"' }  }
  *
  local  pa_grous, nin, acolors := MIS_COLORS
  local  o_czkratJedn

  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  ::oEBro    := drgDialog:dialogCtrl:obrowse[1]

  *
  ** zkratka MJ pøi poøízení bude nepovvný údaj
  o_czkratJedn := ::dm:has('intpozad->czkratJedn')
  if( isObject(o_czkratJedn), o_czkratJedn:odrg:arRelate[1,2] := 2, nil )

  ::cisSklad     := ::dm:get( ::it_file +'->ccisSklad'  , .f.)
  ::sklPol       := ::dm:get( ::it_file +'->csklpol'    , .f.)
*  ::katZbo       := ::dm:get('intpozad->nzbozikat' , .f.)
  ::cisFirmy     := ::dm:get( ::it_file +'->ncisfirmy'  , .f.)
  ::cenNAOdod    := ::dm:get( ::it_file +'->ncennaodod' , .f.)
  ::cisZakazI    := ::dm:get( ::it_file +'->cciszakazi' , .f.)
  ::stavDokl     := ::dm:get( ::it_file +'->cstavDokl'  , .f.)

  * info a pomocné položky
  ::it_cisOsoZpr  := ::dm:has( ::it_file +'->ncisOsoZpr' )
  ::it_nazOsoZpr  := ::dm:has( ::it_file +'->cnazOsoZpr' )
  ::it_cisOsoVyr  := ::dm:has( ::it_file +'->ncisOsoVyr' )
  ::it_nazOsoVyr  := ::dm:has( ::it_file +'->cnazOsoVyr' )
*  ::it_poznobj    := ::dm:has( ::it_file +'->mpoznobj'   )
*  ::it_poznamka   := ::dm:has( ::it_file +'->mpoznamka'  )
  ::it_cisOs_pro  := ::dm:has( ::it_file +'->ncisOs_pro' )
  ::it_cisZakaz   := ::dm:has( ::it_file +'->ccisZakaz' )


  if( .not. ::lopn_stavDokl, ::stavDokl:odrg:isEdit := ::stavDokl:odrg:isEdit_inRev := .f., nil )

  for x := 1 to LEN(members) step 1
    odrg := members[x]

    do case
    case odrg:ClassName() = 'drgText' .and. .not. Empty(members[x]:groups)

      pa_groups := ListAsArray(members[x]:groups)
      nin       := ascan(pa_groups,'SETFONT')

      members[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

      if 'GRA_CLR' $ atail(pa_groups)
        if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
           members[x]:oXbp:setColorFG(acolors[nin,2])
        endif
      else
        members[x]:oXbp:setColorFG(GRA_CLR_BLACK)
      endif

    case odrg:className() = 'drgComboBox'
      if( 'cstavdokl' $ lower(odrg:name), pa_it := odrg:values, nil )

    case odrg:className() = 'drgMLE' .and. .not. Empty(members[x]:groups)
      if( lower(odrg:name) = 'intpozad->mpoznobj', ::it_poznobj  := odrg, ;
                                                   ::it_poznamka := odrg  )

    endcase
  next
*
  members := drgDialog:oActionBar:members

  for x := 1 TO LEN(members) step 1
    odrg := members[x]

    do case
    case odrg:className() = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'nak_intpozad_to_objvys'  ;  ::oBtn_intPozad_to_objVys := members[x]
        endcase
      endif
    endcase
  next

  aeval( pa_it, { |x| aadd( pa_quick, { x[2], 'cstavDokl = "' +x[1] +'"' } ) })
  ::quickFiltrs:init( self, pa_quick, 'int_požadavky' )

  obro:oXbp:refreshAll()
return self


method nak_intpozad_in:postValidate(drgVar)
  LOCAL  value  := drgVar:get()
  LOCAL  name   := lower(drgVar:name)
  local  file   := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok     := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nin, isReturn

   * F4
  nevent    := LastAppEvent(@mp1,@mp2)
  isReturn := (nevent = xbeP_Keyboard .and. ( mp1 = xbeK_RETURN .or. chr(mp1) = '+' ))

  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case(name = ::it_file +'->ncisfirmy'  .and. isReturn .and. changed)
    ok := ::fir_firmy_sel()

  case(name = ::it_file +'->csklpol'    .and. isReturn .and. changed)
    ok := ::skl_cenzboz_sel()

  case(name = ::it_file +'->czkros_pro' .and. isReturn .and. changed)
    ok := ::pro_vyrzakit_sle_OSB_sel()

  case(name = ::it_file +'->nmnozobskl' .and. value < 0 )
    fin_info_box('Objednávané množství je chybné, je povolena (0, >0) ...')
    ok := .f.

  case(name = ::it_file +'->cciszakazi' .and. isReturn .and. changed)
    ok := ::vyr_vyrzakit_sel()

  endcase

  if ok
    if( ::cisFirmy:value  = 0, ::dm:set(           'M->nazFirmy'  , '' ), nil )
    if( ::cenNAOdod:value = 0, ::dm:set( ::it_file +'->ncennaodod', ::cenaOzbo), nil )
  endif
return ok


method NAK_intpozad_IN:drgDialogEnd()
*  firmy->(dbclearfilter(), dbgotop())
return self


method nak_intpozad_in:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))
    ::dm:set( ::it_file +'->ccissklad',cenzboz->ccissklad)

    ::sklPol:set(cenzboz->csklpol)
    ::dm:set( ::it_file +'->cnazZbo'   , cenzboz->cnazzbo    )
    ::dm:set( ::it_file +'->czkratJedn', cenzboz->czkratJedn )
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method nak_intpozad_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('M->nazFirmy', firmy->cnazev)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method nak_intpozad_in:pro_vyrzakit_sle_OSB_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT
  *
  local  drgGet := ::df:olastdrg
  local  name   := lower( drgGet:name )
  local  value  := upper( allTrim( drgGet:oVar:get()))
  *
  local  recCnt := 0, showDlg := .f., ok := .f.

  if isObject(drgDialog)
    showDlg := .t.
  else
    if .not. empty(value)
      osoby->( ordsetFocus('Osoby20')       , ;
               dbsetScope(SCOPE_BOTH, value), ;
               dbeval( { || recCnt++ } )    , ;
               dbclearScope()                 )

      showDlg := .not. (recCnt = 1)
           ok :=       (recCnt = 1)

      if( recCnt = 1, osoby->( dbseek( value,,'Osoby20')), nil )
    endif
  endif

  if showDlg
    DRGDIALOG FORM 'PRO_vyrzakit_sle_OSB_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if .not. showDlg .or. (nexit != drgEVENT_QUIT)

    drgGet:oxbp:setData( osoby->czkrOsob )
    ::dm:set( ::it_file +'->cosoba_Pro', osoby->cjmenoRozl)
    ::dm:set( ::it_file +'->ncisOs_pro', osoby->ncisOsoby )
  endif
return(nexit = drgEVENT_SELECT .or. ok)


method nak_intpozad_in:vyr_vyrzakit_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := vyrzakit->(dbseek(upper(::cisZakazI:value),,'ZAKIT_4'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'NAK_objvyshd_vyr_sel' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. ::cisZakazI:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::cisZakazI:set(vyrzakit->ccisZakazI)
    ::dm:set( ::it_file +'->ccisZakaz', vyrzakit->ccisZakaz)
  endif
return (nexit != drgEVENT_QUIT) .or. ok


method nak_intpozad_in:eBro_beforSaveEditRow()
  local  oxbp      := ::oEBro:oxbp
  local  isAppend  := ( ::oEBro:state = 2 .or. (::it_file)->(eof()))
  local  isAddData := isNull( oxbp:getColumn(1):getRow( oxbp:rowPos))
  *
  local  arDef     := ::oEBro:ardef, isChanged := .f., nsel
  local  ocurr_oxbp := setAppFocus()

  if isWorkVersion

  BEGIN SEQUENCE
    for x := 1 to len(ardef) step 1
      drgEdit := ardef[x].drgEdit
      if drgEdit:isEdit
        if drgEdit:ovar:changed()
          isChanged := .t.
  BREAK
        endif
      endif
    next
  END SEQUENCE

  if isChanged
    nsel := ConfirmBox( ,'Promiòte prosím, '                        +CRLF + ;
                         'došlo ke zmìnì v datech, uložit záznam ?' +CRLF , ;
                         '... POZOR ZMÌNA DAT ...'                        , ;
                         XBPMB_YESNO                                      , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE     , ;
                         XBPMB_DEFBUTTON2                                   )



    if nsel = XBPMB_RET_YES
      return .t.
    else
      oxbp:panHome():refreshCurrent()
      setAppFocus( ocurr_oxbp )

      _clearEventLoop(.t.)
      return .f.
    endif
  endif

  endif

/*
  if .not. (isAppend .or. isAddData)
    if (::it_file)->nOBJVYSIT <> 0
      confirmBox( ,'Promiòte prosím ...' +CRLF + ;
                  'Váš požadavek na zmìnu interního požadavku nelze realizovat' +CRLF + ;
                 '    byla již vystavena objednávka                           ' +CRLF , ;
                 'Interní požadavek nelze uložit ...'                                 , ;
                  XBPMB_CANCEL                                                        , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE                          )

      return .f.
    endif
  endif
*/
return .t.


method nak_intpozad_in:ebro_saveEditRow( drgEBrowse )
  local cisOsoby := logcisOsoby
  local cKy_skl, cKy_fir


  osoby->( dbseek( cisOsoby,,'OSOBY01'))
  (::it_file)->nCisOsoZpr := cisOsoby
  (::it_file)->cNazOsoZpr := osoby->cjmenoRozl
  (::it_file)->nCisOsoVyr := cisOsoby
  (::it_file)->cNazOsoVyr := osoby->cjmenoRozl

  (::it_file)->cosoba_Pro := ::dm:get( ::it_file +'->cosoba_Pro' )

  ::itSave( 'ITw' )

  (::it_file)->ndoklad    := isNull( (::it_file)->sid, 0)
  (::it_file)->ncisintPoz := isNull( (::it_file)->sid, 0)

  *
  ** pokud má položka vazbu na cenZboz doplní me ji o údaje z ceníku
  if drgEBrowse:isAppend
    cKy_skl := upper((::it_file)->ccisSklad) +upper((::it_file)->csklPol)
    cKy_fir := strZero((::it_file)->ncisFirmy,5)

    if cenZboz->( dbseek( cKy_skl,,'CENIK03'))

      c_dph  ->( dbseek( cenZboz->nklicDph,,'C_DPH1'))
      dodZboz->( dbseek( cKy_fir +cKy_skl ,,'DODAV6'))

      (::it_file)->ckatcZbo   := dodzboz->ckatcZbo
      (::it_file)->nklicDph   := cenZboz->nklicDph
      (::it_file)->ncennaodod := dodzboz->ncenaOzbo
      (::it_file)->nhmotnost  := cenZboz->nhmotnost
      (::it_file)->nobjem     := cenZboz->nobjem

    endif
  endif
return .t.


method nak_intpozad_in:nak_intPozad_to_objVys(drgDialog)
  local  o_nak_objvyshd_in, o_dm
  local  o_udcp
  local  file_iv := 'intpozad', hd_file, it_file
  *
  local  cisFirmy, pa_intPozad := {}, x, npos, isOk := .f.
  local  cisOsoVyr, nazOsoVyr
  *
  ** podmínky pro možnost generování objednávky
  ** 1 - ncisFirmy <> 0, pokud je víc položek ncisFirmy.first = ncisFirmy.next
  ** 2 - cstavDokl   = 'K' ... k objednání
  ** 3 - nmnozobskl  >  0
  ** 4 - czkratJedn <> ''

  fordRec( {'intPozad'} )

  do case
  case     ::oEBro:is_selAllRec
    intPozad->( dbgoTop())
    cisFirmy := intPozad->ncisFirmy

    do while .not. intPozad->( eof())
      isOk := ( intPozad->ncisFirmy <> 0 .and. intPozad->cstavDokl = 'K ' .and. cisFirmy = intPozad->ncisFirmy )
      isOk := ( isOk .and. intPozad->nmnozobskl > 0 )
      isOk := ( isOk .and. czkratJedn <> '' )

      if( isOk, aadd( pa_intPozad, intPozad->( recNo()) ), nil )
      intPozad->( dbskip())
    enddo

  case len(::oEBro:arSelect) <> 0
    for x := 1 to len(::oEBro:arSelect) step 1
      intPozad->( dbGoTo( ::oEBro:arSelect[x]))
      if( x = 1, cisFirmy := intPozad->ncisFirmy, nil )

      isOk := ( intPozad->ncisFirmy <> 0 .and. intPozad->cstavDokl = 'K ' .and. cisFirmy = intPozad->ncisFirmy )
      if( isOk, aadd( pa_intPozad, intPozad->( recNo()) ), nil )
    next

  otherwise
    isOk := ( intPozad->ncisFirmy <> 0 .and. intPozad->cstavDokl = 'K ' )
    if( isOk, aadd( pa_intPozad, intPozad->( recNo()) ), nil )

  endcase


  if isOk
    * pro automat pøi ukádání
    drgDBMS:open( 'objVyshd' )
    drgDBMS:open( 'objVysit' )
    drgDBMS:open( 'vztahobj' )
    drgDBMS:open( 'objitem'  )

    o_nak_objvyshd_in := drgDialog():new('NAK_objvyshd_IN', ::drgDialog)
    o_nak_objvyshd_in:create( ,, .t. )

    o_udcp  := o_nak_objvyshd_in:udcp
    hd_file := o_udcp:hd_file
    it_file := o_udcp:it_file
    *
    ** hlavièka
    o_udcp:cisFirmy:value := ::cisFirmy:value
    o_udcp:fir_firmy_sel()
    *
    ** položky
    for x := 1 to len(pa_intPozad) step 1
      intPozad->( dbgoTo( pa_intPozad[x]))

      if( x = 1, (cisOsoVyr := intPozad->ncisOsoVyr, nazOsoVyr := intPozad->cnazOsoVyr), nil )

      cky  := upper(intpozad->ccisSklad) +upper(intpozad->csklPol)
      isOk := cenZboz->( dbSeek( cky,, 'CENIK03'))

      o_udcp:takeValue( file_iv, 3)
      o_udcp:copyfldto_w( hd_file, it_file,.t.)
      *
      ** pokud pøebírá položku z intPozad -> musíme napozicovat cenzboz
      if( isOk, o_udcp:copyfldto_w( 'cenZboz', it_file ), nil )
      o_udcp:copyfldto_w( file_iv, it_file )
      (it_file)->nintCount := o_udcp:ordItem() +1

      vztahobjw->(dbeval({||vztahobjw->nmnozOBorg := vztahobjw->nmnozOBdod }))
      (it_file)->(flock())
      ::itSave_to_objVys( o_udcp:dm )

      * výpoèet nKcBdObj / nkcZdObj
      c_dph  ->( dbseek( (it_file)->nklicDph,,'C_DPH1'))

      (it_file)->nmnozObDod := intPozad->nmnozObSkl
      (it_file)->nkcBdObj   := (it_file)->nmnozObDod  * (it_file)->ncenNaoDod
      (it_file)->nkcZdObj   := (it_file)->nkcBdObj    + int((it_file)->nkcBdObj * c_dph->nprocDph/100)
      (it_file)->nhmotnost  := ((it_file)->nmnozobdod * (it_file)->nhmotnostJ)
      (it_file)->nobjem     := ((it_file)->nmnozobdod * (it_file)->nobjemJ   )
      (it_file)->(dbcommit())

      nak_objvyshd_cmp()
    next

    (hd_file)->ncisOsoVyr := cisOsoVyr
    (hd_file)->cnazOsoVyr := nazOsoVyr

    o_dm := o_nak_objvyshd_in:dataManager
    o_dm:set( hd_file +'->cnazOsoVyr', nazOsoVyr )

    vazSpoje->( ordSetFocus( 'NOSOBY' ), dbsetScope(SCOPE_BOTH, cisOsoVyr), dbgotop())
    do while .not. vazSpoje->( eof())
      if spojeni->( dbseek( vazSpoje->spojeni,,'SPOJENI01'))

         do case
         case allTrim(spojeni->czkrSpoj) = 'TEL_ZAM'
           (hd_file)->nsspoTeVyr := spojeni->ncisSpoj

         case allTrim(spojeni->czkrSpoj) = 'EMAIL_ZAM'
           (hd_file)->nsspoEmVyr := spojeni->ncisSpoj
         endcase
      endif
      vazSpoje->( dbskip())
    enddo
    vazSpoje->( dbclearScope())
    *
    ** no a vèil by se to dalo zobrazit, a si s tím dìlá co chce
    (it_file)->( dbgoTop())
    o_udcp:brow:show()
    postAppEvent(drgEVENT_REFRESH,,,o_udcp:brow )

    o_nak_objvyshd_in:quickShow(.t.)

    ::oEBro:oxbp:refreshAll()
  else

    confirmBox( ,'Promiòte prosím ...' +CRLF + ;
                 'Váš požadavek na vytvoøení objednávky nelze realizovat' +CRLF + ;
                 '    1 - musí být vybrána shodná firma                 ' +CRLF + ;
                 '    2 - položky musí být ve stavu K_objednání         ' +CRLF + ;
                 '    3 - objednávané množství musí být > 0             ' +CRLF + ;
                 '    4 - musí být vyplnìna mìrná jednotka              ' +CRLF , ;
                 'Objednávku nelze vygenerovat ...'                             , ;
                  XBPMB_CANCEL                                                  , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE                    )
  endif

  fordRec()
return self