#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "xbp.ch"
#include "dbstruct.ch"
#include "dmlb.ch"

#include "..\Asystem++\Asystem++.ch"

#xtranslate PutDBVal(<cs>) => ( Eval( &("{||" + <cs> + "}")) )


#define   in_Brow    0
#define   do_Edit    1
#define   do_Append  2
#define   do_Delete  3
#define   do_Save    5
**


**
**
** CLASS for FIN_fakvnphd_lik_IN **********************************************
CLASS FIN_fakvnphd_lik_IN FROM drgUsrClass, FIN_finance_IN, UCT_likvidace
EXPORTED:
  METHOD  init
  METHOD  drgDialogInit, comboBoxInit, drgDialogStart, drgDialogEnd
  METHOD  overPostLastField, postLastField, postValidate


  inline method stableBlock()
    ::sumColumn()
    return .t.

  * hd
  * it
  inline access assign method cnaz_ucet()  var cnaz_ucet
    c_uctosn->(dbseek(upper(fakVnpitW->cucet)))
    return c_uctosn->cnaz_uct

  inline access assign method mena_Dod()  var mena_Dod
    return ::czaklMena
  *
  inline access assign method cnaz_ucet_Uct()  var cnaz_ucet_Uct
    c_uctosn->(dbseek(upper(fakVnpitW->cucet_Uct)))
    return c_uctosn->cnaz_uct

  inline access assign method mena_Odb()  var mena_Odb
    return ::czaklMena

  * browColumn _ 1
  inline access assign method stavPol() var stavPol
    if empty(fakVnpitW->cucet)     .or. ;
       empty(fakVnpitW->cucet_uct) .or. fakVnpitW->ncenZAKlik = 0
      return MIS_BOOK
    else
      return 0  // MIS_ICON_OK
    endif
    return

  inline access assign method orditem() var orditem
    local  retVal := padr( allTrim( str( fakVnpitW->nintCount)), 5 )

    if fakVnpitW->nsubCount <> 0
      retVal := left( retVal, 2) +'_' +str(fakVnpitW->nsubCount,2)
    endif
    return retVal

  inline access assign method subUcto() var subUcto
    return if(fakVnpitW->nsubCount = 0, 0, BANVYPIT_4)

  inline access assign method celkem_Dod() var celkem_Dod
    return if(fakVnpitW->nsubCount = 0, fakVnpitW->ncenZAKcel, '')

  inline access assign method celkem_Odb() var celkem_Odb
    return if(fakVnpitW->nsubCount = 0, '', fakVnpitW->ncenZAKlik)

  inline access assign method typ_Pol() var typ_Pol
    return if(fakVnpitW->nsubCount = 0, 'DAL', 'MD ')

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  nRECs, lastXbp
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  dbArea   := ALIAS(dc:dbArea)

    DO CASE
    CASE (nEvent = xbeBRW_ItemMarked)
      ::doAction(in_Brow)
      RETURN .F.

    CASE nEvent = drgEVENT_APPEND
      ::doAction(do_Append)
      RETURN .T.

    CASE nEvent = drgEVENT_EDIT .or. (nevent = drgEVENT_MSG .and. mp2 = DRG_MSG_ERROR)
      ::doAction(do_Edit)
      RETURN .T.

    CASE nEvent = drgEVENT_DELETE
      ::doAction(do_Delete)
      RETURN .T.

    CASE ( nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT )
      lastXbp := dc:drgDialog:lastXbpInFocus

      IF IsObject(lastXbp) .and. lastXbp:className() = 'XbpGet'
        lastXbp:SetColorBG(lastXbp:cargo:clrFocus)
      ENDIF

      if SetAppFocus():className() <> 'XbpBrowse'
        if( ::overPostLastField(), ::postLastField(), nil)
      else
        ::doAction(do_Save)
      endif
      return .t.

    CASE nEvent = xbeP_Keyboard
      IF mp1 == xbeK_ESC .and. oXbp:ClassName() <> 'XbpBrowse'
        SetAppFocus(::drgDialog:dialogCtrl:oaBrowse:oXbp)
        ::bro:oXbp:refreshAll()
        ::dm:refresh()
        RETURN .T.
      ELSE
        RETURN .F.
      ENDIF

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  var     czaklMena
  var     typ, subTitle, mainFile, subFile, it_file, uctLikv, inScr
  var     msg, dm, dc, bro, noEdit, m_ctrl
  var     nState     // 0 - inBrowse  1 - inEdit  2 - inAppend

  method  postSave, doAction, initMemVars
  var     lNEWrec, obdLikv

  var     oget_cucet    , oget_ncenZAKcel
  var     oget_cucet_Uct, oget_ncenZAKlik

  * suma
  inline method sumColumn()
    local  recNo  := fakvnpitW->( recNo())
    local  pa_col := { { 'M->celkem_Dod', 0 }, { 'M->celkem_Odb', 0 } }

    fakvnpitW->( dbeval( { || ( pa_col[1,2] += fakvnpitW->ncenZAKcel, ;
                                pa_col[2,2] += fakVnpitW->ncenZAKlik  ) } ), ;
                 dbgoTo( recNo )                                             )


    for x := 1 to len(pa_col) step 1
      sumCol := ::brow:cargo:getColumn_byName( pa_col[x,1] )

      sumCol:Footing:setCell(1, pa_col[x,2] )
      sumCol:footing:invalidateRect()
      sumCol:Footing:show()
    next
  return self

  * kotrola položek pøed uložením dokladu
  inline method checkAll()
    local  ok := .t., recNo  := ucetpolW->(recNo())

    ucetpolW->(dbgotop(), ;
               dbEval({ || ok := if( empty(ucetpolW->cucetMd) .or. empty(ucetpolW->cucetDal), .f., ok) }))

    if( ok, nil, fin_info_box('Doklad nelze uložit, obsahuje ZÁVAŽNÉ chyby !!!'))
    ucetpolW->(dbGoTo(recNo))
  return ok
ENDCLASS

*
********************************************************************************
METHOD FIN_fakvnphd_lik_IN:init(parent)
  local  cC, file_name
  local  pa_uctuj_Dal, pa_it, muctuj_2 := ''

  ::drgUsrClass:init(parent)
  *
  ::m_ctrl   := if(isnull(parent:parent:cargo), parent:parent:dialogCtrl, nil)
  ::typ      := IsNull(parent:parent:UDCP:typ_lik, '')
  ::it_file  := 'ucetpolw'

  *
  drgDBMS:open('c_uctosn')
  drgDBMS:open('ucetprit')
  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))
  *

  ::subTitle := 'vnitro_podnikové faktury ...'
  ::mainFile := 'FAKvnpHD'
  ::subFile  := 'FAKvnpIT'
  *
  ::noEdit   := GraMakeRGBColor( {221, 221, 221} )
  ::nState   := 0

  ::lNEWrec    := .T.
  ::cZAKLMENA  := SYSCONFIG('FINANCE:cZAKLMENA')

  ::initMemVars()

  * pøi volání LIKVIDACE ze SCR je cargo = NIL objekt UCT_likvidace je nutno
  * inicializovat, pokud je doklad v editaèním modu je inicializace provedena
  * pøi staru dialogu poøízení/opravy dokladu !!! zkontrolovat likvidaci !!!

  IF( ::inScr := isnull(parent:parent:cargo))
  * _scr
    mainKey   := Upper((::mainFile) ->cULOHA) +Upper((::mainFile) ->cTYPDOKLAD)
    ::uctLikv := ::UCT_likvidace:init(mainKey,.t.,.t.)
  ELSE
  * _in
    if(select('ucetpolw') = 0)
      mainKey := Upper((::mainFile +'w') ->cULOHA) +Upper((::mainFile +'w') ->cTYPDOKLAD)
      ::uctLikv := ::uct_likvidace:init(mainKey,.t.,.t.)
    endif
  ENDIF
  *
  *
  ** pomocný soubor pro sumaci a rozlikvidaci
  fakVNPhdW->( dbcommit())

  if( select('fakvnp_iw') <> 0, fakvnp_iw->( dbCloseArea()), nil )
  file_name := fakVnpitW ->( DBInfo(DBO_FILENAME))
               fakVnpitW ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'fakVnpitW', .t., .f.) ; fakVnpitW ->(OrdSetFocus(1), Flock())
  DbUseArea(.t., oSession_free, file_name, 'fakvnp_iw', .t., .t.) ; fakvnp_iw ->(OrdSetFocus(1))

  *
  ** doplníme fakVnpitW z ucetpolW
  ucetprsy->( dbseek( 'FN_VNPFAK',,'UCETPRSY01' ))
  pa_uctuj_Dal := listAsArray( MemoTran(ucetprsy->muctuj_Dal, ', ', '') )

  for x := 1 to len(pa_uctuj_Dal) step 1
    if 'FAKVNPITW' $ upper(pa_uctuj_Dal[x])
      pa_it    := listAsArray( upper(pa_uctuj_Dal[x]), ':=' )
      muctuj_2 += allTrim(pa_it[2]) +' := ' +allTrim( pa_it[1]) +' ,'
    endif
  next

  muctuj_2 += 'FAKVNPITW->ncenZAKcel := 0, FAKVNPITW->nsubCount := UCETPOL->nsubUcto'
  muctuj_2 := strTran(muctuj_2,'UCETPOL','UCETPOLW')

  ucetpolW->( dbgoTop())
  do while .not. ucetpolW->( eof())
    if ucetpolW->nordUcto = 2 .and. ucetpolW->nsubUcto <> 0
      fakVnpit->( dbseek( strZero( ucetpolW->ndoklad,10) +strZero( ucetpolW->nordItem,5),, 'FVYSIT3' ))

      mh_copyFld( 'fakVnpit', 'fakVnpitW', .t. )
      PutDBVal( muctuj_2 )
    endif

    ucetpolW->( dbskip())
  enddo
RETURN self


method FIN_fakvnphd_lik_IN:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += ' ' +::subTitle

  drgDialog:dialog:drawingArea:bitmap  := 1019 // 1020  // 1017  // 1018
  drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED
RETURN


method FIN_fakvnphd_lik_IN:comboBoxInit(drgCombo)
  local  cname := lower(drgParseSecond(drgCombo:name,'>'))
  local  uloha := 'F', acombo_val := {}, value
  *
  local  ky    := F_VNITROFAK, block := { || .t. }

  do case
  case(cname = 'obdlikv')
    value  := ::obdLikv
    filter := Format("culoha = '%%' .and. .not. lzavren", {uloha})

    ucetsys->(DbSetFilter(COMPILE(filter)),DbGoTop(), ;
              DbEval( {|| AAdd(acombo_val, ;
                          { ucetsys->cobdobi                                           , ;
                            StrZero(ucetsys->nobdobi,2) +'/' +StrZero(ucetsys->nrok,4) , ;
                            uloha +StrZero(ucetsys->nrok,4) +StrZero(ucetsys->nobdobi,2) }) }), ;
              DbClearFilter() )
    *
    ** pracuje v zavøeném úèetní období ?
    ucetsys->(dbseek(uloha +value,,'UCETSYS2'))
    if ucetsys->lzavren
      (drgCombo:isEdit := .f., drgCombo:oxbp:disable())
    endif

    if ascan(acombo_val,{|x| x[1] = value }) = 0
      rok := year(ctod('01.' +left(value,2) +'.' +right(value,2)))
      aadd(acombo_val, {value, left(value,3) +str(rok,4), uloha +str(rok,4) +left(value,2)})
    endif

  case( cname = 'ctyppohybu' )
    c_typpoh->(dbsetscope(SCOPE_BOTH,ky), dbgotop())
    do while .not. c_typpoh ->(eof())
      if eval(block)
        typdokl ->(dbseek(c_typpoh ->(sx_keyData())))
        aadd( acombo_val, { c_typpoh ->ctyppohybu       , ;
                            c_typpoh ->cnaztyppoh       , ;
                            c_typpoh ->ctypdoklad       , ;
                            alltrim(typdokl  ->ctypcrd) , ;
                            c_typpoh->ctask             , ;
                            c_typpoh->csubtask          , ;
                            c_typpoh->craddph091        , ;
                            c_typpoh->cvypSAZdan          } )
      endif
      c_typpoh->(dbskip())
    endDo
    c_typpoh ->(dbclearscope())
  endcase

  drgCombo:oXbp:clear()
  drgCombo:values := ASort( acombo_val,,, {|aX,aY| aX[3] < aY[3] } )
  AEval(drgCombo:values, { |a| drgCombo:oXbp:addItem( a[2] ) } )

  if cname = 'obdlikv'
    drgCombo:value := ::obdLikv
  endif
return self


method FIN_fakvnphd_lik_IN:drgDialogStart(drgDialog)
  local  members  := drgDialog:oForm:aMembers, pa := {}
  local  x, odrg, groups, name, tipText
  *
  local  acolors  := MIS_COLORS, pa_groups, nin

  ::fin_finance_in:init(drgDialog,::typ,::it_file +'->cucetmd','_likvidace dokladu_',.t.)
  *

  ::msg    := drgDialog:oMessageBar
  ::dm     := drgDialog:dataManager
  ::dc     := drgDialog:dialogCtrl

  ::oget_cucet      := ::dm:has('fakVnpitW->cucet'):oDrg
  ::oget_ncenZAKcel := ::dm:has('fakVnpitW->ncenZAKcel'):oDrg
  ::oget_cucet_Uct  := ::dm:has('fakVnpitW->cucet_Uct'):oDrg
  ::oget_ncenZAKlik := ::dm:has('fakVnpitW->ncenZAKlik'):oDrg
  *
  ** úèty jsou v likvidaci povinné na DBD je nastavena 2 tj. mohou být prázdné
  ::oget_cucet:arRelate[1,2]     := 1
  ::oget_cucet_Uct:arRelate[1,2] := 1


  for x := 1 to len(members) step 1
    odrg    := members[x]
    groups  := if( ismembervar(odrg      ,'groups'), isnull(members[x]:groups,''), '')
    groups  := allTrim(groups)
    name    := if( ismemberVar(members[x],'name'    ), isnull(members[x]:name   ,''), '')
    tipText := if( ismemberVar(members[x],'tipText' ), isnull(members[x]:tipText,''), '')


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

    if ( isMemberVar(odrg, 'isedit' ) .and. isMemberVar(odrg, 'isedit_inRev' ) )
      if isLogical(odrg:isedit_inRev) .and. .not. odrg:isedit_inRev
        odrg:isEdit := .f.
        odrg:oxbp:disable()
      endif
    endif
  next
***

  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF members[x]:ClassName() = 'drgDBrowse'
        ::bro := members[x]
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  ::dm:has('fakVnphdW->dVYSTFAK'):odrg:isEdit := .f.

  drgDialog:oForm:nextFocus := x
  ::dm:refresh()
RETURN


method FIN_fakvnphd_lik_IN:drgDialogEnd()

  if isObject(::m_ctrl)
    if ::m_ctrl:drgDialog:formName = 'FIN_FAKVNPHD_IN'
    * nic volá likvidci z poøízení dokladu

    else
     if( isobject(::m_ctrl), if( isObject(::m_ctrl:oaBrowse), ::m_ctrl:refreshPostDel(),nil ), nil )

     fakVnphdW->(dbclosearea())
     fakvnpitw->(dbclosearea())
     fakVnp_iW->(dbclosearea())
    endif
  endif

  ::UCT_likvidace:destroy()
  ::drgUsrClass:destroy()
RETURN self


** kontrola výpoèty ************************************************************
METHOD FIN_fakvnphd_lik_IN:postValidate(drgVar)
  LOCAL  value := drgVar:get()
  LOCAL  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  LOCAL  lOk   := .T., cc
  local  nevent := mp1 := mp2 := nil, isF4 := .F.

  * F4
  nevent  := LastAppEvent(@mp1,@mp2)
  If(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  DO CASE
  CASE ( item $ 'cucet,cucet_uct')
    lok := c_uctosn->( dbseek(upper(value),,'UCTOSN1'))

    if name = 'fakvnpitw->cucet'
      ::dm:set('m->cnaz_ucet',c_uctosn->cnaz_uct)
    else
      ::dm:set('m->cnaz_ucet_uct',c_uctosn->cnaz_uct)
    endif

  case(name = ::it_file +'->csymbol')
    cc := ::dm:get(::it_file +'->cucetMd')
    c_uctosn->(dbSeek(cc,,'UCTOSN1'))
    if c_uctosn->lsaldoUct .and. empty(value)
      fin_info_box('Variabilní symbol pro ùèet >' +cc +'<' +CRLF + 'je POVINNÝ údaj !!!')
      lok := .f.
    endif
  endcase

  if(name = ::it_file +'->cnazpol6')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
      if( ::overPostLastField(), ::postLastField(), nil)
    endif
  endif
RETURN lOK


method FIN_fakvnphd_lik_IN:overPostLastField()
  local  ucet, o_nazPol1 := ::dm:has( 'fakVnpitW->cnazPol1'  )
  local  ok

  ucet := if( ::oget_cucet:isEdit, ::oget_cucet:ovar:value, ::oget_cucet_Uct:ovar:value )
    ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok



METHOD FIN_fakvnphd_lik_IN:postLastField()
  local  nintCount, nsubCount, recNo, cucet

  if(::nstate = in_Brow, ::nstate := do_Edit, nil)

  DO CASE
  CASE( ::nState = do_Append .or. ::nState = do_Edit .or. ::nstate = do_Delete)

    do case
    * rozùètování primárního záznamu *
    case ::nstate = do_Append
      nintCount := fakVnp_iW->nintCount
      nsubCount := 0

      mh_copyFld( 'fakVnp_iW', 'fakVnpitW', .t., .f. )
      fakVnpitW->nsubCount := 99

      ::itSave()

      recNo := fakVnpitW->( recNo())
      fakVnpitW->( dbEval( { || ( nsubCount += 1, fakVnpitW->nsubCount := nsubCount )                }, ;
                           { || ( fakVnpitW->nintCount = nintCount .and. fakVnpitW->nsubCount <> 0 ) }  ), ;
                   dbgoto(recNo)                                                                           )


    * oprava/zrušení sekundního záznamu *
    case  fakVnpitW->nsubCount <> 0

      if :: nstate = do_Delete
        fakVnpitW->(dbdelete())
      else
        ::itSave()
      endif

    * oprava primárního záznamu
    case  fakVnpitW->nsubCount = 0
      nintCount := fakVnpitW->nintCount

      ::itSave()

      recNo := fakVnpitW->( recNo())
      cucet := fakVnpitW->cucet

      fakVnpitW->( dbEval( { || fakVnpitW->cucet := cucet                                            }, ;
                           { || ( fakVnpitW->nintCount = nintCount .and. fakVnpitW->nsubCount <> 0 ) }  ), ;
                   dbgoto(recNo)                                                                           )

    endcase
  endcase

  ::bro:oXbp:refreshAll()
  SetAppFocus(::bro:oXbp)
  ::sumColumn()

  postAppEvent(xbeBRW_ItemMarked,,,::bro:oxbp)
return .t.

*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_fakvnphd_lik_IN:initMemVars()

  ::obdLikv    := fakVnphdW->cobdobi
return .t.


METHOD FIN_fakvnphd_lik_IN:doAction(nEvent)
  LOCAL  lastXbp, kcmddp, nkcmds, groups
  local  mky := strZero( fakVnpitW->nintCount,5) +'00'
  local  ncenZAKlik := 0
  local  nintCount  := fakVnpitW->nintCount
  local  nsubCount  := fakVnpitW->nsubCount

  DO CASE
  CASE(nEvent = in_Brow  )
    ::oget_cucet:isEdit      := ( nsubCount = 0 )
    if( ::oget_cucet:isEdit, ::oget_cucet:oxbp:enable(),           ::oget_cucet:oxbp:disable()     )

    ::oget_ncenZAKcel:isEdit := .f.  // ( nsubCount = 0 )
    if( ::oget_ncenZAKcel:isEdit, ::oget_ncenZAKcel:oxbp:enable(), ::oget_ncenZAKcel:oxbp:disable() )

    ::oget_cucet_Uct:isEdit  := ( nsubCount <> 0 )
    if( ::oget_cucet_Uct:isEdit, ::oget_cucet_Uct:oxbp:enable(),   ::oget_cucet_Uct:oxbp:disable()  )

    ::oget_ncenZAKlik:isEdit := ( nsubCount <> 0 )
    if( ::oget_ncenZAKlik:isEdit, ::oget_ncenZAKlik:oxbp:enable(), ::oget_ncenZAKlik:oxbp:disable() )

    ::msg:WriteMessage(,0)
    lastXbp := ::dc:drgDialog:lastXbpInFocus

     IF IsObject(lastXbp) .and. lastXbp:className() = 'XbpGet'
       lastXbp:SetColorBG(lastXbp:cargo:clrFocus)
     ENDIF

  case(nEvent = do_Edit .or. nEvent = do_Append)
    fakVnp_iW->( dbeval( { || ncenZAKlik += fakVnp_iW->ncenZAKlik }, ;
                         { || fakVnp_iW->nintCount = nintCount    }  ) )

    if nevent = do_Append

      ::dm:refreshAndSetEmpty( 'fakVnpitW' )

      fakvnp_iw->( dbseek( mky,, 'FAKVNIT_1' ) )

      ::dm:set( 'fakVnpitW->cucet'     , fakvnp_iW->cucet                  )
      ::dm:set( 'M->cnaz_ucet'         , c_uctosn->cnaz_uct                )

      ::dm:set( 'M->mena_Dod'          , ::czaklMena                       )
      ::dm:set( 'fakVnpitW->ncenZAKlik', fakVnp_iW->ncenZAKcel -ncenZAKlik )
      ::dm:set( 'M->mena_Odb'          , ::czaklMena                       )
      ::dm:set( 'fakVnpitW->czkratJedn', fakVnp_iW->czkratJedn             )
      ::dm:set( 'fakVnpitW->czkratJed2', fakVnp_iW->czkratJed2             )
      ::dm:set( 'fakVnpitW->cnazZbo'   , fakVnp_iW->cnazZbo                )

      ( ::oget_cucet:isEdit      := .f., ::oget_cucet:oxbp:disable()      )
      ( ::oget_ncenZAKcel:isEdit := .f., ::oget_ncenZAKcel:oxbp:disable() )
      ( ::oget_cucet_Uct:isEdit  := .t., ::oget_cucet_Uct:oxbp:enable()   )
      ( ::oget_ncenZAKlik:isEdit := .t., ::oget_ncenZAKlik:oxbp:enable()  )
    endif

    ::drgDialog:oForm:setNextFocus('fakVnpitW->cucet',, .T. )

  case(nEvent = do_Delete)
    if fakVnpitW->nsubCount = 0
      fin_info_Box('Nelze zrušit klíèovou položku dokladu ...' )

    elseif drgIsYESNO( 'Požadujete zrušit rozùètovanu položku dokladu ?' )
      ::nstate := do_Delete
      ::postLastField()
      nevent := in_Brow
    endif

  case(nEvent = do_Save)
    if FIN_postsave():new(::mainFile,self,.f.):ok
      if ::inScr .and. ::checkAll()
        ::postSave()
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      endif
    endif

    nEvent := in_Brow
  endcase

  ::nState := nEvent
RETURN


method FIN_fakvnphd_lik_IN:postSave()
  local  uctLikv
  local  omoment

  omoment := SYS_MOMENT( '=== UKLÁDÁM DOKLAD ===')
    uctLikv := UCT_likvidace():new(upper(fakvnphdW->culoha) +upper(fakvnphdW->ctypdoklad),.T.)
    uctLikv:ucetpol_wrt()

    if ::inScr
      if fakVnphd->( sx_RLock())
        fakVnphd->nklikvid := fakVnphdW->nklikvid
        fakVnphd->nzlikvid := fakVnphdW->nzlikvid

        fakVnphd->( dbunlock(),dbcommit())
      endif
    endif

  omoment:destroy()

  ucetpol ->(dbunlock(), dbcommit())
return .t.
