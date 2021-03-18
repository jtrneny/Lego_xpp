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
#define   _LIK_main  { {"fakprihd->dposlikfak"                , ;
                        "fakprihd->nlikcelfak"                , ;
                        "fakprihd->cobdobi"                   , ;
                        "fakprihd->cucet_uct"                 , ;
                                                              , }, ;
                       {"fakvyshd->dposlikfak"                , ;
                        "fakvyshd->nlikcelfak"                , ;
                        "fakvyshd->cobdobi"                   , ;
                        "fakvyshd->cucet_uct"                 , ;
                                                              , ;
                        "strzero(fakvysit->nintcount) +('00')", ;
                        "poldok_li->cucet"                      }, ;
                       {"pokladhd->dposlikdok"                , ;
                        "pokladhd->nlikcekdok"                , ;
                        "pokladhd->cobdobi"                   , ;
                        "pokladhd->cucet_uct"                 , ;
                        "pokladhd->cvarsym"                     }, ;
                       {"poklhd->dposlikfak"                  , ;
                        "poklhd->nlikcelfak"                  , ;
                        "poklhd->cobdobi"                     , ;
                        "poklhd->cucet_uct"                   , ;
                                                              , ;
                        "strzero(poklit->nintcount) +('00')"  , ;
                        "poldok_li->cucet"                      }  }


**

/*
 {"fakvnphd->dposlikfak"                , ;
  "fakvnphd->nlikcelfak"                , ;
  "fakvnphd->cobdobi"                   , ;
  "fakvnphd->cucet_uct"                 , ;
                                        , ;
  "strzero(fakvnpit->nintcount) +('00')", ;
  "poldok_li->cucet"                      }, ;
*/


/*
1 STRZERO(NPOLUCTPR,3)+STRZERO(NORDITEM,5)+STRZERO(NSUBUCTO,3)+STRZERO(NORDUCTO,1)

2 STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)
  NORDUCTO = 1 .AND. EMPTY(_DELREC)

3 STRZERO(NORDITEM,5) +STRZERO(NSUBUCTO,3) +STRZERO(NORDUCTO,1)
*/


/*
FUNCTION FIN_LIKVIDACE_BC(nCOLUMn)
  LOCAL  xRETval := 0

  DO CASE
  CASE nCOLUMn == 2
    xRETval := IF(UCETPOLw ->nSUBUCTO = 0, UCETPOLw ->nDOKLAD, BANVYPIT_4)
  CASE nCOLUMn == 8
    xRETval := CoalesceEmpty(UCETPOLw ->nKcDAL, UCETPOLw ->nKcMD)
  ENDCASE
RETURN(xRETval)
*/



**
** CLASS for FIN_fakvnphd_lik_IN **********************************************
CLASS FIN_fakvnphd_lik_IN FROM drgUsrClass, FIN_finance_IN, UCT_likvidace
EXPORTED:
  VAR     nCENZAKCEL, cUCET_UCT, nOSVODDAN, nZAKLDAN_1, nSAZDAN_1, cUCETDAN_1
  VAR                                       nZAKLDAN_2, nSAZDAN_2, cUCETDAN_2
  VAR     nDOKLAD, cVARSYM, dVYSTDOK, dSPLATDOK
  VAR     cZAKLMENA

  VAR     nkcmdd, okcmdd, omnoz, omnoz2

  METHOD  init

  METHOD  drgDialogInit, comboBoxInit, drgDialogStart, drgDialogEnd
  METHOD  overPostLastField, postLastField, postValidate
  method  lik_c_uctosn_hd

  inline method stableBlock()
    ::sumColumn()
    return .t.

  inline access assign method dod_cenzakcel var dod_cenzakcel
    return if(fakvnpitw->nsubcount = 0, str(fakvnpitw->ncenzakcel), '')

  inline access assign method odb_cenzakcel var odb_cenzakcel
    return if(fakvnpitw->nsubcount = 0, 0, fakvnpitw->ncenzakcel)

  * hd
  inline access assign method cnaz_uct_hd()  var cnaz_uct_hd
    c_uctosn->(dbseek(upper((::it_file)->cucetmd)))
*    c_uctosn->(dbseek(upper(::cucet_uct)))
    return c_uctosn->cnaz_uct
  *
  inline access assign method cnaz_uct_it()  var cnaz_uct_it
    c_uctosn->(dbseek(upper((::it_file)->cucetdal)))
*    c_uctosn->(dbseek(upper((::it_file)->cucetmd)))
    return c_uctosn->cnaz_uct

  * it
  * browColumn _ 1
  inline access assign method stavPol() var stavPol
    if empty((::it_file)->cucetmd)  .or. ;
       empty((::it_file)->cucetdal) .or. ;
       ((::it_file)->nkcmd +(::it_file)->nkcdal) = 0
      return MIS_ICON_ERR
    else
      return MIS_ICON_OK
    endif
    return

  inline access assign method bc_orditem() var bc_orditem
    local  cc := padr( allTrim( str( fakVnpitW->nintCount)), 5 )
    return if(fakVnpitW->nsubCount = 0, cc, ' |____' )


  * browColumn _ 3
  inline access assign method subUcto() var subUcto
    return if(ucetpolw->nsubucto = 0, 0, BANVYPIT_4)
  * browColumn _ 9
  inline access assign method celkPol() var celkPol
     return CoalesceEmpty(ucetpolw->nkcdal, ucetpolw->nkcmd)

  *
  inline access assign method nkcmdd()
    return if( ucetpolw->nsubucto = 0, 0, ::celkPol() )
*    return if( UCETPOLw ->(Eof()), 0, IF(UCETPOLw ->nKcDAL <> 0, UCETPOLw ->nKcDAL, UCETPOLw ->nKcMD))


  *
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
  var     typ, subTitle, mainFile, subFile, it_file, uctLikv, mainLikv, inScr
  var     msg, dm, dc, bro, noEdit, m_ctrl, patypUct
  var     nState     // 0 - inBrowse  1 - inEdit  2 - inAppend

  method  postSave, doAction, initMemVars, refresh
  var     lVSYMBOL, lNEWrec, nFINTYP, oucetmdd, obdLikv, ovarSym_hd

  * suma
  inline method sumColumn()
    local  recNo  := ucetpolW->(recNo())
    local  sumLik := 0, sumCol, x

    ucetpolW->(dbgotop(), ;
               dbeval({ || sumLik += ucetpolW->nkcMd +ucetpolW->nkcDal        }, ;
                      { || .not. empty(ucetpolW->cucetMd) .and. .not. empty(ucetpolW->cucetDal) } ))

    begin sequence
      for x := 1 to ::brow:colCount step 1
        sumCol := ::brow:getColumn(x)
        if 'fin_likvidace_bc' $ lower(sumCol:frmColum)
    break
        endif
      next
    end sequence

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(sumLik))
    sumCol:Footing:show()

    ucetpolW->(dbGoTo(recNo))
  return sumLik

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
*****************************************************************
METHOD FIN_fakvnphd_lik_IN:init(parent)
  LOCAL  cC, file_name, pa := _LIK_main, patypUct
  *
  local  pa_uctuj_Dal, pa_it, muctuj_2 := ''

  ::drgUsrClass:init(parent)
  *
  ::m_ctrl   := if(isnull(parent:parent:cargo), parent:parent:dialogCtrl, nil)
  ::typ      := IsNull(parent:parent:UDCP:typ_lik, '')
  ::it_file  := 'ucetpolw'
  patypUct   := ::patypUct := {}
  *
  drgDBMS:open('c_uctosn')
  drgDBMS:open('ucetprit')
  drgDBMS:open('c_typpoh')
  drgDBMS:open('typdokl' )  ;  typdokl->(AdsSetOrder('TYPDOKL01'))
  *
  DO CASE
  CASE ::typ = 'zav'
    ::subTitle := 'závazkù ...'
    ::mainFile := 'FAKPRIHD'
    ::subFile  := nil
    ::mainLikv := pa[1]
  CASE ::typ = 'poh'
    ::subTitle := 'pohledávek ...'
    ::mainFile := 'FAKVYSHD'
    ::subFile  := 'fakvysit'
    ::mainLikv := pa[2]
  CASE ::typ = 'pok'
    ::subTitle := 'pokladních dokladù ...'
    ::mainFile := 'POKLADHD'
    ::subFile  := nil
    ::mainLikv := pa[3]
  CASE ::typ = 'pok_r'
    ::subTitle := 'pokladních dokladù ...'
    ::mainFile := 'POKLHD'
    ::subFile  := nil
    ::mainLikv := pa[4]
  CASE ::typ = 'vnp_f'
    ::subTitle := 'vnitro_podnikové faktury ...'
    ::mainFile := 'FAKvnpHD'
    ::subFile  := 'FAKvnpIT'
    ::mainLikv := pa[1]
  ENDCASE
  *
  ::noEdit   := GraMakeRGBColor( {221, 221, 221} )
  ::nState   := 0

  ::lNEWrec    := .T.
  ::cZAKLMENA  := SYSCONFIG('FINANCE:cZAKLMENA')
  ::cUCETDAN_1 := SYSCONFIG('UCTO:cUCETDPH1')
  ::cUCETDAN_2 := SYSCONFIG('UCTO:cUCETDPH2')

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
  ucetprit->(ads_setAof("lwrtRecHd = .t.")                      , ;
             dbGoTop()                                          , ;
             DbEval( { || AAdd(patypUct, ucetprit->ctypUct) }), ;
             ads_clearAof()                                       )
  *
  if(select('ucetpols') <> 0, ucetpols->(dbclosearea()), nil )
  file_name := ucetpolw ->( DBInfo(DBO_FILENAME))
               ucetpolw ->( DbCloseArea())

  DbUseArea(.t., oSession_free, file_name, 'ucetpolw', .t., .f.)
  ucetpolw->( ordSetFocus( 'UCETPOW_C'), flock() )
*  ucetpolw->(AdsSetOrder(2), flock())

  DbUseArea(.t., oSession_free, file_name, 'ucetpols', .t., .t.)
  ucetpols->(AdsSetOrder(3), flock())

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

  muctuj_2 += 'FAKVNPITW->nsubCount := UCETPOL->nsubUcto'
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


METHOD FIN_fakvnphd_lik_IN:drgDialogInit(drgDialog)
  drgDialog:formHeader:title += ' ' +::subTitle
RETURN


method FIN_fakvnphd_lik_IN:comboBoxInit(drgCombo)
  local  cname := lower(drgParseSecond(drgCombo:name,'>'))
  local  uloha := 'F', acombo_val := {}, value
  *
  local  ky := ky := F_VNITROFAK, block := { || .t. }

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

  ucetpolw->(AdsSetOrder(2),dbgotop())

  ::fin_finance_in:init(drgDialog,::typ,::it_file +'->cucetmd','_likvidace dokladu_',.t.)
  *
  ::oucetmdd   := drgDialog:dataManager:has('fakVnpitW->cucet'):oDrg
  ::okcmdd     := drgDialog:dataManager:has('m->nkcmdd'):oDrg
  ::omnoz      := drgDialog:dataManager:has('fakVnpitW->nFAKTmnoz'):oDrg
  ::omnoz2     := drgDialog:dataManager:has('fakVnpitW->nFAKTmno2'):oDrg
  ::ovarSym_hd := drgDialog:dataManager:has('m->cvarSym'):oDrg

  ::msg    := drgDialog:oMessageBar
  ::dm     := drgDialog:dataManager
  ::dc     := drgDialog:dialogCtrl

***
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
        odrg:oxbp:disable()   // setColorBG( GraMakeRGBColor( {215, 255, 220 } ) )
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

*  isEditGet( { 'fakVNPhdW->cTYPPOHYBU', 'fakVnphdW->dVYSTFAK', 'fakVnphdW->nCISFAK', 'fakVnphdW->cnazPol1' }, ;
*             drgDialog, .f. )

  drgDialog:oForm:nextFocus := x
  ::dm:refresh()
RETURN


method FIN_fakvnphd_lik_IN:drgDialogEnd()

  if( isobject(::m_ctrl), if( isObject(::m_ctrl:oaBrowse), ::m_ctrl:refreshPostDel(),nil ), nil )

  ucetpolw->(AdsSetOrder(1),dbgotop())
  ucetpols->(dbclosearea())

  ::nCENZAKCEL := ::cUCET_UCT := ::nOSVODDAN  := ;
  ::nZAKLDAN_1 := ::nSAZDAN_1 := ::cUCETDAN_1 := ;
  ::nZAKLDAN_2 := ::nSAZDAN_2 := ::cUCETDAN_2 := ;
  ::nDOKLAD    := ::cVARSYM   := ::dVYSTDOK   := ;
  ::dSPLATDOK  := ::cZAKLMENA := ;
  ::nkcmdd     := ::okcmdd    := ;
  ::omnoz      := ::omnoz2    := NIL

  ::UCT_likvidace:destroy()
  ::drgUsrClass:destroy()
RETURN self


** kontrola výpoèty ************************************************************
method FIN_fakvnphd_lik_IN:lik_c_uctosn_hd(drgDialog)
  local  drgVar := ::dm:has('m->cucet_uct')
  local  value  := drgVar:get()
  local  srchDialog, ok := c_uctosn->(dbseek(upper(value),,'UCTOSN1')), lastDrg


  if IsObject(drgDialog) .or. .not. ok
    srchDialog := drgDialog():new('drgSearch', ::drgDialog)
    srchDialog:cargo := 'c_uctosn' + TAB + '321010' + TAB +'1' +TAB +'c_uctosn'

    srchDialog:create(,,.T.)

    if srchDialog:exitState != drgEVENT_QUIT
       drgVar:set(srchDialog:cargo)

       lastDrg := ::drgDialog:oform:oLastDrg
       ok      := .t.
       ::drgDialog:oform:setNextFocus(lastDrg:name,,.t.)
       PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,lastDrg:oxbp)
    endif

    srchDialog:destroy()
    srchDialog := NIL
  endif
return ok


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
  CASE ( item $ 'cucet_uct,cucetdan_1,cucetdan_2,cucetmd')
    c_uctosn->(dbseek(upper(value),,'UCTOSN1'))
    if name = 'm->cucet_uct'
      if(lok := ::lik_c_uctosn_hd(), ::dm:set('m->cnaz_uct_hd',c_uctosn->cnaz_uct), nil)
    else
      ::dm:set('m->cnaz_uct_it',c_uctosn->cnaz_uct)
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
  local  o_nazPol1 := ::dm:has(::it_file +'->cnazPol1')
  local  ucet      := ::dm:get(::it_file +'->cucetMd' )
  local  ok

  ok := ::c_naklst_vld(o_nazPol1,ucet)
return ok



METHOD FIN_fakvnphd_lik_IN:postLastField()
  local  mky      := strzero(ucetpolw->norditem,5) +'000', sky, modi_sub := .f.
  local  recs     := ucetpolw ->(recno()), groups, subUcto, ctext
  local  patypUct := ::patypUct
  local  kcmddp, kcmdds := ::okcmdd:ovar:value -IsNull(::okcmdd:ovar:initValue,0), ;
                 mnoz   := ::omnoz:ovar:value  -IsNull(::omnoz:ovar:initValue ,0), ;
                 mnoz2  := ::omnoz2:ovar:value -IsNull(::omnoz2:ovar:initValue,0)

  if(::nstate = in_Brow, ::nstate := do_Edit, nil)

  DO CASE
  CASE( ::nState = do_Append .or. ::nState = do_Edit .or. ::nstate = do_Delete)

    ::cvarSym := ::ovarSym_hd:ovar:value

    do case
    * rozùètování primárního záznamu *
    case ::nstate = do_Append
      ucetpols->(AdsSetOrder(3),dbsetscope(SCOPE_BOTH,mky),dbgotop())

      groups := 0
      do while .not. ucetpols->(eof())
        groups++
        ctext   := ucetpols->ctext

        mh_copyfld('ucetpols','ucetpolw',.t., .f.)
        if(groups = 1,subUcto := ucetpolw->(recno()),nil)
        ucetpolw->nsubucto := subUcto
        ::itSave(str(groups,1))

        DBPutVal('ucetpolw->nKC'   +ucetpolw->ctyp_r, ::okcmdd:ovar:value  )

        if groups = 2
          DBPutVal('ucetpolw->cucetdal', ::oucetmdd:ovar:value)
          ucetpolw->ctext := ctext
        endif
        ucetpols->(dbskip())
      enddo
      ucetpolw->(dbcommit())

    * oprava/zrušení sekundního záznamu *
    case  ucetpolw->nsubucto <> 0
      modi_sub := .t.
      sky      := strzero(ucetpolw->norditem,5) +strzero(ucetpolw->nsubucto,3)
      ucetpolw->(AdsSetOrder(3),dbsetscope(SCOPE_BOTH,sky),dbgotop())

      groups := 0
      do while .not. ucetpolw->(eof())
        groups++
        ctext   := ucetpolw->ctext

        if :: nstate = do_Delete
          ucetpolw->(dbdelete())
        else
          ::itSave(str(groups,1))

          DBPutVal('ucetpolw->nKC'   +ucetpolw->ctyp_r, ::okcmdd:ovar:value  )

          if groups = 2
            DBPutVal('ucetpolw->cucetdal', ::oucetmdd:ovar:value)
            ucetpolw->ctext := ctext

            if ::typ = 'zav' .or. ::typ = 'poh' .or. ::typ = 'pok_r'
              ucetpolw->csymbol := alltrim(str( ::ndoklad))
            endif

          endif
        endif
        ucetpolw->(dbskip())
      enddo
    endcase

    ucetpols->(dbclearscope())
    ucetpolw->(AdsSetOrder(3),dbsetscope(SCOPE_BOTH,mky),dbgotop(),flock())

    * modifikace primárních záznamù *
    groups := 0
    do while .not. ucetpolw->(eof())
      groups++
      kcmddp  := CoalesceEmpty(ucetpolw->nkcmd,ucetpolw->nkcdal)
      ctext   := ucetpolw->ctext

      if ::nstate = do_Delete
        DBPutVal('ucetpolw->nKC' +ucetpolw->ctyp_r, kcmddp +::okcmdd:ovar:value)
      elseif ::nState = do_Append
        DBPutVal('ucetpolw->nKC' +ucetpolw->ctyp_r, kcmddp -::okcmdd:ovar:value)  // ? kcmdds)
      endif

      if ::nState = do_Edit
        if modi_sub
           DBPutVal('ucetpolw->nKC' +ucetpolw->ctyp_r, kcmddp -kcmdds)
        else
          ::itSave(str(groups,1))

          if groups = 2
            DBPutVal('ucetpolw->cucetdal', ::oucetmdd:ovar:value)
            ucetpolw->ctext   := ctext

            if ::typ = 'zav' .or. ::typ = 'poh' .or. ::typ = 'pok_r'
              ucetpolw->csymbol := alltrim(str( ::ndoklad))
            endif

          endif
        endif
      endif
      *
      ** pro pokladnu
      if (::typ = 'pok' .and. ::ovarSym_hd:ovar:changed())
        if ascan(patypUct, ucetpolW->ctypUct) <> 0
          DBPutVal('ucetpolw->csymbol', ::cvarSym)
        endif
      endif

      ucetpolw->(dbskip())
    enddo
    ucetpolw->( AdsSetOrder(2))
    if( ::nstate <> do_Delete, ucetpolw->( dbgoto(recs)), nil )
  endcase

  if( ::nstate = do_Append,ucetpolw->(dbgoto(subUcto)),nil)

  ::bro:oXbp:refreshAll()
  SetAppFocus(::bro:oXbp)
  ::sumColumn()

  postAppEvent(xbeBRW_ItemMarked,,,::bro:oxbp)
return .t.

/*
 if ::typ = 'zav' .or. ::typ = 'poh' .or. ::typ = 'pok_r'
   ucetpolw->csymbol := alltrim(str( ::ndoklad))
 endif
*/


*
*****************************************************************
METHOD FIN_fakvnphd_lik_IN:refresh(drgVar)
  LOCAL  nIn, nFs
  LOCAL  oVAR, vars := ::drgDialog:dataManager:vars
//
  LOCAL  dc       := ::drgDialog:dialogCtrl
  LOCAL  dbArea   := ALIAS(dc:dbArea)

* 1- kotrola jen pro datové objekty aktuální DB
* 2- kominace refresh tj. znovunaètení dat
*  - mìl by probìhnout refresh od aktuálního prvku dolù

  nFs := AScan(vars:values, {|X| X[1] = Lower(drgVar:Name) })

  FOR nIn := nFs +1 TO vars:size()
    oVar := vars:getNth(nIn)
    IF !oVar:rOnly .and. (dbArea == drgParse(oVar:name,'-'))
      IF( oVar:changed(), Eval( oVar:block, oVar:value), NIL )
      oVar:refresh()
    ENDIF
  NEXT

  dc:aData := (dbArea)->( drgScatter())
RETURN .T.


*
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_fakvnphd_lik_IN:initMemVars()

  ::nCENZAKCEL := fakVnphdW ->nCENZAKCEL
  ::cUCET_UCT  := fakVnphdW ->cUCET_UCT
  ::nOSVODDAN  := 0
  ::nZAKLDAN_1 := 0
  ::nSAZDAN_1  := 0
  ::nZAKLDAN_2 := 0
  ::nSAZDAN_2  := 0
  ::obdLikv    := fakVnphdW->cobdobi
  ::nDOKLAD    := fakVnphdW->nCISFAK
  ::cVARSYM    := fakVnphdW->cVARSYM
  ::dVYSTDOK   := fakVnphdW->dVYSTFAK
  ::dSPLATDOK  := fakVnphdW->dVYSTFAK
return .t.


METHOD FIN_fakvnphd_lik_IN:doAction(nEvent)
  LOCAL  lastXbp, kcmddp, nkcmds, groups
  local  mky := strzero(ucetpolw->norditem,5) +'0001', recs := ucetpolw->(recno())

  DO CASE
  CASE(nEvent = in_Brow  )
**    fakVnpitW->( dbseek( strZero( ucetpolW->nordItem, 5),, 'FAKVNIT_1') )

    ::ovarSym_hd:isEdit := .f.
    ::ovarSym_hd:oxbp:setColorBG(::noEdit)

    ::okcmdd:isEdit := (UCETPOLw ->nSUBUCTO <> 0)
    ::okcmdd:oXbp:setColorBG(IF( ::okcmdd:isEdit, ::okcmdd:clrFocus, ::noEdit))

    ::msg:WriteMessage(,0)
    lastXbp := ::dc:drgDialog:lastXbpInFocus

     IF IsObject(lastXbp) .and. lastXbp:className() = 'XbpGet'
       lastXbp:SetColorBG(lastXbp:cargo:clrFocus)
     ENDIF

  case(nEvent = do_Edit .or. nEvent = do_Append)
    ucetpols->(dbseek(mky,, AdsCtag(3) ))

    if nevent = do_Append
      ::dm:refreshAndSetEmpty( 'ucetpolw' )

      ::dm:set('ucetpolw->cobdobi',ucetpols->cobdobi)
      ::dm:set('ucetpolw->csymbol',ucetpols->csymbol)
      ::dm:set('ucetpolw->ctext'  ,ucetpols->ctext  )
      ::dm:set('m->cnaz_uct_it'   , ''              )
      ::dm:set('m->nkcmdd'        , 0               )

      (::okcmdd:isEdit := .t., ::okcmdd:oXbp:setColorBG(::okcmdd:clrFocus))
    else
      if (::typ = 'pok' .and. ucetpolw->nordItem = 1)
        ::ovarSym_hd:isEdit := .t.
        ::ovarSym_hd:oxbp:setColorBG(::ovarSym_hd:clrFocus)
      endif
    endif
    ::drgDialog:oForm:setNextFocus('ucetpolw->cucetmd',, .T. )


  case(nEvent = do_Delete)
    if ucetpolw->nsubucto = 0
      ::msg:writeMessage('Nelze zrušit klíèovou položku likvidace ...',DRG_MSG_WARNING)

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
  local  m_filter := "ncisfak = %%", filter
  local  mainOk   := .t., modiItm := .not. isnull(::subFile), sky, aitm := {}
  *
  local  oobdLikv := ::dm:has('m->obdLikv'):odrg, nin
  local  condto_  := '( .not. empty(ucetpolw->cucetmd) .and. .not. empty(ucetpolw->cucetdal))'
  local  zlikvid  := 0
  *
  local  alock, pos

  * zmìna obdobi
  nin := ascan(oobdLikv:values, {|x| x[1] = oobdLikv:value})
  ucetsys->(dbseek(oobdLikv:values[nin,3],,'UCETSYS3'))

  if modiItm
    drgDBMS:open(::subFile ,,,,,'poldok_li')
    poldok_li->(AdsSetOrder('FVYSIT8')                                   , ;
                dbsetscope(SCOPE_BOTH, strzero((::mainFile)->ncisfak,10)), ;
                dbgotop()                                                , ;
                dbeval( {|| aadd(aitm,poldok_li->(recno())) })             )

    mainOk := poldok_li->(sx_rlock(aitm))
  endif

  if (::mainFile)->(sx_rlock()) .and. ucetpol->(sx_rlock(::uctLikv:ucetpol_rlo)) .and. mainOk
    DBPutVal(::mainLikv[1], date()          )
    DBPutVal(::mainLikv[3], ucetsys->cobdobi)
    DBPutVal(::mainLikv[4], ::cucet_uct     )
    if( isnull(::mainLikv[5]), nil, DBPutVal(::mainLikv[5], ::cvarsym))
*
    (::mainFile)->nrok     := ucetsys->nrok
    (::mainFile)->nobdobi  := ucetsys->nobdobi
*

    ucetpolw->(dbgotop())

    do while .not. ucetpolw->(eof())
      if .not. DBGetVal(condto_)
        ucetpolw->(dbdelete())

      elseif ucetpolw->nsubucto = 0
        zlikvid += (ucetpolw->nkcmd +ucetpolw->nkcdal)

        if modiItm
          sky     := strzero((::mainFile)->ncisfak,10) +strzero(ucetpolw->norditem,5)

          if poldok_li->(dbseek(sky))
            poldok_li->cobdobi := (::mainFile)->cobdobi
            poldok_li->nrok    := (::mainFile)->nrok
            poldok_li->nobdobi := (::mainFile)->nobdobi
            DBPutVal(::mainLikv[7],ucetpolw->cucetmd)
          endif
        endif

      else
        zlikvid += (ucetpolw->nkcmd +ucetpolw->nkcdal)

      endif
      ucetpolw->(dbskip())
    enddo

    ucetpolw->(AdsSetOrder(0), ;
               dbgotop()     , ;
               dbeval({|| (ucetpolw->nrok    := ucetsys->nrok   , ;
                           ucetpolw->nobdobi := ucetsys->nobdobi, ;
                           ucetpolw->cobdobi := ucetsys->cobdobi  ) }))

    (::mainfile)->nklikvid := zlikvid
    (::mainFile)->nzlikvid := zlikvid
    ::uctLikv:ucetpol_wrt()
  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat LIKVIDACI DOKLADU, blokováno uživatelem !!!'))
  endif

  (::mainFile)->(dbunlock(),dbcommit())
   if(modiItm, poldok_li->(dbunlock(),dbcommit()), nil)
    ucetpol->(dbunlock(),dbcommit())
return mainOk