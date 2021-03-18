#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

STATIC allRecs


* osoby     OSB
* vazSpoje  KAN
* vazFirmy  FIR
* vazUkoly  KAN
* vazDokum  SYS
* osobySk   OSB
*
*  OSOBY
** CLASS OSB_osoby_CRD *********************************************************
CLASS OSB_osoby_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init
  METHOD  drgDialogStart
  METHOD  itemMarked
 *
  METHOD  preValidate
  METHOD  postValidate
  METHOD  onSave

  METHOD  selSpoj, selFirma, selDok, selUkol
  method  editParent

  method  ebro_saveEditRow
  method  postSave
  method  destroy
  *
  var     lnewRec, pa_vazRecs

  *
  ** vazSpoje
  inline access assign method cisSpoj() var cisSpoj
    spojeni ->( dbseek( vazSpojeW->SPOJENI,, 'ID'))
    return spojeni->nCisSpoj

  inline access assign method caption_adrElSpoj() var caption_adrElSpoj
    c_typSpo->(dbseek( upper( spojeni->ctypSpoj),,'C_TYPSPO01'))
    return left(c_typSpo->cnazTyp, 17)
  *
  ** osobySK
  inline access assign method setSkup() var setSkup
    return if( osobySkW->_setSku, MIS_ICON_OK, 0)

  inline access assign method cnaz_Skup() var cnaz_Skup
     c_osobySk->(dbSeek( upper(osobySkW->czkr_Skup)))
     return c_osobySk->cnaz_Skup


  inline method tabSelect(oTabPage,tabNum)
    local  cfile
    *
    local  drgButton := ::paoB_editParent[otabPage:tabNumber]
    local  drgVar
    local  pa        := { ''         , ;
                          ''         , ;
                          ''         , ;
                          'vazSpojeW', ;
                          'vazFirmyW', ;
                          'vazUkolyW', ;
                          'vazDokumW', ;
                          ''         , ;
                          ''           }

    ::tabNum := otabPage:tabNumber

    if ( isObject(drgButton) .and. .not. empty(pa[::tabNum]) )
      cfile := pa[::tabNum]
      if( isNull((cfile)->sid,0) = 0, drgButton:oXbp:hide(), drgButton:oXbp:show() )
    endif

    ::relForText()
  return .t.


  inline method relForText()
    local  cfile := ''

    do case
    case ::tabNum = 4
      spojeni   ->( dbseek( vazSpojeW->SPOJENI ,, 'ID'        ))
      c_spojen  ->( dbseek( spojeni->czkrSpoj  ,, 'C_SPOJEN01'))
      c_psc_2   ->( dbseek( spojeni->cpsc      ,, 'C_PSC1'    ))
      c_staty_2 ->( dbseek( spojeni->czkratStat,, 'C_STATY1'  ))
      cfile := 'spojeni,c_spojen,c_psc_2,c_staty_2'

    case ::tabNum = 5
      firmy     ->( dbseek( vazFirmyW->FIRMY   ,, 'ID'        ))
      c_psc_3   ->( dbseek( firmy->cpsc        ,, 'C_PSC1'    ))
      c_staty_3 ->( dbseek( firmy->czkratStat  ,, 'C_STATY1'  ))
      cfile := 'firmy,c_psc_3,c_staty_3'

    case ::tabNum = 6
      ukoly     ->( dbseek( vazUkolyW->UKOLY   ,, 'ID'        ))
      cfile := 'ukoly'

    case ::tabNum = 7
      dokument  ->( dbseek( vazDokumW->DOKUMENT,, 'ID'        ))
      cfile := 'dokument'

    endCase

    if( .not. empty(cfile), ::refreshGroup( cfile ), nil )
    return self


  inline method ebro_afterAppend( o_eBro )
    local  cfile := lower(o_ebro:cfile)
    local  nitem := o_eBro:odata:nitem
    *
    local  isAppend  := ( o_eBro:state = 2 .or. (cfile)->(eof()))
    local  isAddData := isNull( o_eBro:oxbp:getColumn(1):getRow( o_eBro:oxbp:rowPos))

    if o_eBro:state = 2 .or. (cfile)->( eof())
      ::state := 2
      ::relForText()

      if     ( isAppend .and.        isAddData )
        nitem := nitem +1
      elseif  ( isAppend .and. .not. isAddData )
        nitem := nitem
      endif

      ::dm:set( cfile +'->nitem', nitem )
    endif
    return .t.


  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL  dc       := ::drgDialog:dialogCtrl
    LOCAL  lastXbp  := ::drgDialog:lastXbpInFocus
    LOCAL  dbArea   := ALIAS(SELECT(dc:dbArea))

*    if ::lnewRec
    ::oscisPrac:odrg:isEdit := ( osobyW->nis_EXT = 1 )
    if( osobyW->nis_EXT = 1, ::oscisPrac:odrg:oxbp:enable(), ::oscisPrac:odrg:oxbp:disable()  )
*    endif

    if nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_EDIT .or.         ;
        nEvent = drgEVENT_DELETE
      if lastXbp:ClassName() = 'XbpBrowse'
         ::cALIASw := Upper(lastXbp:cargo:cfile)
         ::cALIASa := Left( ::cALIASw,Len(::cALIASw)-1) +"A"
      endif
    endif

    do case
     case nEvent = xbeBRW_ItemMarked
*        ::restColor()
        ::state := 0
        ::setFocus_onTab()
        ::relForText()
        ::dm:refresh()
      RETURN .F.

    case (nEvent = drgEVENT_EXIT)
      ::msgSave := .F.
      PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      RETURN .T.

    case (nEvent = drgEVENT_DELETE)
     if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse,drgebrowse')
        cfile := lower( ::df:oLastDrg:cfile )
        if( .not. (cfile) ->(eof()), ::all_broDelete(cfile, ::df:oLastDrg), nil )
        return .t.
      endif

    case (nEvent = xbeP_Keyboard)
      do case
      case mp1 = xbeK_ESC
        ::msgSave := .T.
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      otherwise
        RETURN .F.
      endcase

    case (nevent = drgEVENT_EXIT .or. nevent = drgEVENT_SAVE)
      if ::postSave()
         PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
      endif
      return .t.

    case (AppKeyState(xbeK_ALT) == 1 .and. nevent = xbeM_LbClick)
      if( ::tabNum = 8 .and. oxbp:className() = 'XbpCellGroup', ::osobySk_set(), nil)
      return .t.

    otherwise
      RETURN .F.
    endcase
 RETURN .T.

HIDDEN:
  var   tabNum, pao_brow, closeW_files
  VAR   msg, dm, dc, df, ab, brow

  VAR   cALIASw, cALIASa, lNEWmainREC, msgSave, changeCRD
  VAR   valSel, valNaz, item, oldName
  var   state, paoB_editParent
  var   oscisPrac


  inline method all_broDelete( cfile, obro )
    local  cInfo  := 'Promiòte prosím,'          +CRLF + ;
                     'požadujete zrušit vazbu '
    local  cc     := '', nsel, recNo, npos

    do case
    case( cfile = 'vazspojew' ) ;  cc    := 'spojení'       // Vazby na spojení
                                   pa    := ::pa_vazRecs[1]
                                   recNo := spojeni->(recNo())

    case( cfile = 'vazfirmyw' ) ;  cc    := 'firmy'         // Vazby na firmy
                                   pa    := ::pa_vazRecs[2]
                                   recNo := firmy->(recNo())

    case( cfile = 'vazukolyw' ) ;  cc    := 'ukolu'         // Vazby na úkoly
                                   pa    := ::pa_vazRecs[3]
                                   recNo := ukoly->(recNo())

    case( cfile = 'vazdokumw' ) ;  cc    := 'dokument'      // Vazby na dokumenty
                                   pa    := ::pa_vazRecs[4]
                                   recNo := dokument->(recNo())

    endcase

    if .not. empty(cc)
      cInfo += '. ' +upper(cc) +' .' +CRLF + CRLF + ;
               'pro pracovníka _' +upper( allTrim(osobyW->cjmenoRozl)) +'_'

      nsel := ConfirmBox( , cInfo, ;
                           'Zrušení ' +cc +' ...' , ;
                            XBPMB_YESNO                   , ;
                            XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      if nsel = XBPMB_RET_YES
        (cfile)->_delrec := '9'
        if( (cfile) ->_nrecor = 0, (cfile)->( dbdelete()), nil )

        if( npos := ascan( pa, recNo)) <> 0
          aRemove( pa, npos)
        endif

        obro:oxbp:refreshAll()

        if (cfile)->( eof())
          obro:oxbp:up():forceStable()
          obro:oxbp:refreshAll()
        endif
      endif
    endif
  return .t.


  inline method osobySk_set()
    local  czkr_skup := osobySkW->czkr_skup
    local  cis_xxx   := 'nis_' +alltrim(czkr_skup)

    osobySkw->_setsku := .not. osobySkW->_setsku
    ::dc:oaBrowse:refresh(.f.)

    if ( npos := osobyW->(fieldPos( cis_xxx ))) <> 0
      osobyW->( fieldPut( npos, if( osobySkW->_setsku, 1, 0)) )

      PostAppEvent(xbeBRW_ItemMarked,,,::dc:oaBrowse:oxbp)
    endif
  return


  inline method refreshGroup(cfiles, drgVar, nextFocus, all_onTab)
    local  nin, ovar, new_val, dbarea, ok
    local  cfile
    local  vars  := ::dm:vars
    *
    local  xValue
    local  pa    := listAsArray( lower(cfiles))

    default nextFocus to .f., all_onTab to .f.

    for nIn := 1 TO vars:size() step 1
      oVar  := vars:getNth(nIn)
      cfile := lower(drgParse(oVar:name,'-'))

      if( ascan( pa, cfile) <> 0) .and. isblock(ovar:block) .and. if( ::state = 2 .or. all_onTab, .t., oVar:rOnly)
        new_val := eval(ovar:block)

        if ::state = 2 .and. isNull(drgvar)
          type   := valType( new_val )
          xvalue := if( type = 'C' .or. type = 'M', space( len( ovar:value)), ;
                     if( type = 'D', ctod('')                               , ;
                      if( type = 'L', .f.                                   , ;
                       if( type = 'N', 0, nil                                 ))))

          if type = 'N'
            if (npos := at('.', new_val := str( new_val ))) <> 0
              xValue := val( '0.' +replicate( '0', len(new_val) - npos))
            endif
          endif

          new_val := xValue
        endif

        ovar:set(new_val)
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    next

     if nextFocus
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    endif
  return .t.


/*
  inline method refreshGroup(cfiles, drgVar, nextFocus)
    local  nin, ovar, new_val, dbarea, ok
    local  cfile
    local  vars := ::dm:vars

    default nextFocus to .f.

    for nIn := 1 TO vars:size() step 1
      oVar  := vars:getNth(nIn)
      cfile := lower(drgParse(oVar:name,'-'))

      if( cfile $ lower(cfiles) ) .and. isblock(ovar:block) .and. oVar:rOnly
        new_val := eval(ovar:block)

        ovar:set(new_val)
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    next

    if nextFocus
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    endif
  return .t.
*/

  inline method setFocus_onTab( refreshAll )
    local  nIn, zkr_skup, cky, brow
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum
    local  drgVar   // := ::pa_focusOnEdit[::tabNum]

    default refreshAll to .f.

    if( nIn := ascan(pao_brow, {|x| x[3] = tabNum })) <> 0
      ::df:olastdrg   := ::pao_brow[nIn,2]
      ::df:nlastdrgix := ::pao_brow[nIn,1]
      ::df:olastdrg:setFocus()

      ::dc:oaBrowse := ::pao_brow[nIn,2]
      brow := ::dc:oaBrowse:oXbp
      ::dm:refresh()

      if( isObject(drgVar), ;
          ( drgVar:odrg:isEdit           := .f., ;
            drgVar:odrg:pushGet:disabled := .t., ;
            drgVar:odrg:oxbp:disable()           ), nil )

**      if( refreshAll, ( brow:refreshAll(), ::restColor()), nil )
      if( refreshAll, brow:refreshAll(), nil )
    endif
    return .t.


  inline method start_SEL_inThread(cformName)
    local  oThread
    local  nevent, mp1 := NIL, mp2 := NIL, oXbp := NIL

    oThread := drgDialogThread():new()
    oThread:start( ,cformName, ::drgDialog, .t.)

    do while .not. ( nEvent = drgDIALOG_END )
      nEvent := AppEvent( ,,,0 )
    endDo
    return

ENDCLASS


METHOD OSB_osoby_CRD:init(parent)
  local  pa_initParam
  local  formName := lower(parent:parent:formName)

  ::drgUsrClass:init(parent)

  * pokud to volám ze SEL dialogù
  drgDBMS:open('osoby'   )
  drgDBMS:open('c_typSpo')
  drgDBMS:open('C_FUNCPR')
  drgDBMS:open('C_SPOJEN')
  drgDBMS:open('msPrc_mo')
  drgDBMS:open('msOsb_mo')

  * karta osoby volaná pro opravu z ... vodevšad 2 parametr je recNo()
  if len(pa_initParam := listAsArray(parent:initParam)) = 2
    parent:cargo := drgEVENT_EDIT
    osoby->(dbgoTo( val( pa_initParam[2] )))
  endif

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( osoby->(eof()), ::lnewRec := .t., nil )

  *                       spojeni firmy ukoly dokument
  *                       4       5     6     7
  ::pa_vazRecs      := { {},     {},   {},   {} }
  ::tabNum          := 1
  ::pao_brow        := {}
  ::state           := 0
  ::paoB_editParent := { , , , , , , , , }

  ::closeW_files    := isNull( parent:cargo_Usr)


** tohle musíme zatím nechat a pak doøešit
  ::cALIASw     := 'OSOBYw'
  ::changeCRD   := .F.

  * pomocné alaisy pro OSOBY TABPAGE_2
  drgDBMS:open('c_psc'  ,,,,,'c_psc_2'  )
  drgDBMS:open('c_staty',,,,,'c_staty_2')

  * pomocné alaisy pro FIRMY  TABPAGE_3
  drgDBMS:open('c_psc'  ,,,,,'c_psc_3'  )
  drgDBMS:open('c_staty',,,,,'c_staty_3')


  * pomocný alias osoby pro kontolu cJmenoRozl - nesmíme povolit
  drgDBMS:open('osoby',,,,,'osoby_oW'   )
  osoby_oW->( ordSetFocus('Osoby09'))

  drgDBMS:open('spojeni' )  ;  drgDBMS:open('vazSpoje',,,,, 'vazSpojeX' )
  drgDBMS:open('firmy'   )  ;  drgDBMS:open('vazFirmy',,,,, 'vazFirmyX' )
  drgDBMS:open('ukoly'   )  ;  drgDBMS:open('vazUkoly',,,,, 'vazUkolyX' )
  drgDBMS:open('dokument')  ;  drgDBMS:open('vazDokum',,,,, 'vazDokumX' )

  drgDBMS:open('osobySk' )  ;  drgDBMS:open('c_osobySk')

  OSB_osoby_cpy( self )

  do case
  case ( formName = 'vyr_osoby_scr' )
    if osobySkW->( dbseek( 'VYR',,'OSBOSKW_1' ))
      osobyW  ->nis_VYR := 1
      osobySkW->_setsku := .t.
    endif
  endcase

  *
  ** tohle by mohl být problém
  if ::lnewRec
    FordRec( { 'osoby_oW,1' } )
    osoby_oW ->( DbGoBottom())
    osobyW ->ncisOsoby := osoby_oW->ncisOsoby +1
    FordRec()
  endif
RETURN self


METHOD OSB_osoby_CRD:drgDialogStart(drgDialog)
  local  amembers := drgDialog:oForm:amembers, x
  *
  local  acolors  := MIS_COLORS
  local  pa_groups, nin

  *
  ::msg      := drgDialog:oMessageBar             // messageBar
  ::dm       := drgDialog:dataManager             // dataMabanager
  ::dc       := drgDialog:dialogCtrl              // dataCtrl
  ::df       := drgDialog:oForm                   // form
  *
  ::oscisPrac  := ::dm:get( 'osobyW->nosCisPrac' , .F.)

  for x := 1 to len(amembers) step 1

    * font a barva u textù
    if  aMembers[x]:ClassName() = 'drgText' .and. .not. empty(aMembers[x]:groups)
      if 'SETFONT' $ aMembers[x]:groups
        pa_groups := ListAsArray(aMembers[x]:groups)
        nin       := ascan(pa_groups,'SETFONT')

        aMembers[x]:oXbp:setFontCompoundName(pa_groups[nin+1])

        if 'GRA_CLR' $ atail(pa_groups)
          if (nin := ascan(acolors, {|x| x[1] = atail(pa_groups)} )) <> 0
            aMembers[x]:oXbp:setColorFG(acolors[nin,2])
          endif
        else
          aMembers[x]:oXbp:setColorFG(GRA_CLR_BLUE)
        endif
      endif
    endif

    if lower(amembers[x]:ClassName()) $ 'drgdbrowse,drgebrowse'
      AAdd(::pao_brow, {x,amembers[x],val(amembers[x]:groups)})
    endif

    if ( amembers[x]:ClassName() = 'drgPushButton' .and. isCharacter( amembers[x]:event) )
      if lower( amembers[x]:event) = 'editparent'
        tabNum := val(amembers[x]:caption)

        ::paoB_editParent[tabNum] := amembers[x]
      endif
    endif
  next
RETURN self


method OSB_osoby_crd:itemMarked(x,y)

 ::relForText()
return self


*
*****************************************************************
METHOD OSB_osoby_CRD:preValidate(drgVar)                                       // kotroly a výpoèty
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  lOK  := .T., pa, xval
  LOCAL  oldRec, oldTag, nLastKey
  LOCAL  fldw

  ** pøednastavíme nItem vazby **

  fldw := Lower(::cALIASw +'->nitem')
  if ::dataManager:get(fldw) = 0
    oldTag := (::cALIASw)->(AdsSetOrder(1))
    (::cALIASw)->(DbGoBottom())
    oldRec := (::cALIASw)->(Recno())
    ::item := &fldw +1
    ((::cALIASw)->(AdsSetOrder(oldTag)), (::cALIASw)->(dbGoTo(oldRec)))
    ::dataManager:set(fldw, ::item)
  endif
RETURN .T.


METHOD OSB_osoby_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  lOK  := .T., pa, xval
  LOCAL  oldRec, nLastKey, isOk
  LOCAL  filter
  *
  local  cjmenoRozl, recCnt := 0
  local  cInfo     := 'Promiòte prosím,' +CRLF
  local  cForBlock    := format( "recNo() <> %%", { osobyW->_nrecOr })
  local  bForBlock

  bForBlock := if( ::lnewRec, { || .t. }, COMPILE( cForBlock ) )

  ** ukládáme pøi zmìnì do tmp **
  do case
  case ( file = 'osobyw' )
    if changed
      ::changeCRD := .T.
      ( ::dm:save(), ::dm:refresh(.T.) )
    endif

    cjmenoRozl := allTrim( osobyW->cprijOsob ) +' ' + ;
                  allTrim( osobyW->cjmenoOsob) +' ' + ;
                           osobyW->cRozlJmena

    osoby_oW->( ordSetFocus('Osoby09')                  , ;
                dbsetscope(SCOPE_BOTH,upper(cjmenoRozl)), ;
                dbgotop()                               , ;
                dbeval( {|| recCnt++ })                 , ;
                dbclearScope()                            )

    isOk := if( ::lnewRec, (recCnt = 0), ((recCnt = 1) .or. (recCnt = 0)))

    if .not. isOk
      cInfo += 'osoba < ' +cjmenoRozl +'>, již existuje v souboru osoby' +CRLF +CRLF + ;
               'je nutno zmìnit rozlišení osoby napø. (mladší, starší...)'
      lOk   := .f.

      fin_info_box( cInfo, XBPMB_CRITICAL )

      if name <> 'osobyw->crozljmena'
        ::drgDialog:oForm:setNextFocus('osobyW->crozlJmena',, .T.)
        lOk := .t.
      endif
    endif

    osobyW->cjmenoRozl := cjmenoRozl

    *
    ** kontrola na duplicitu czkrOsb
    if isOk .and. name = 'osobyw->czkrosob' .and. .not. empty(value)
      recCnt := 0

      osoby_oW->( ordSetFocus('Osoby20')            , ;
                  dbsetscope(SCOPE_BOTH,value)      , ;
                  dbgotop()                         , ;
                  dbeval( {|| recCnt++ }, bForBlock), ;
                  dbclearScope()                      )

**    isOk := if( ::lnewRec, (recCnt = 0), ((recCnt = 1) .or. (recCnt = 0)))
      isOk := (recCnt = 0)

      if .not. isOk
        cInfo += 'zkratka pro osobu < ' +cjmenoRozl +'>, již existuje ' +CRLF + ;
                 'je nutno zkratku zmìnit ...'
        lOk   := .f.

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif
    endif

    *
    ** kontrola na duplicitu osobního èísla pracovníka pro nis_EXT
    if isOk .and. name = 'osobyw->noscisprac'
      recCnt := 0

      osoby_oW->( ordSetFocus('OSOBY03')            , ;
                  dbsetscope(SCOPE_BOTH,value)      , ;
                  dbgotop()                         , ;
                  dbeval( {|| recCnt++ }, bForBlock), ;
                  dbclearScope()                      )
      isOk := (recCnt = 0 .or. value = 0)

      if .not. isOk
        cInfo += 'osobní èíslo pracovníka < ' +str(value) +' >, již existuje ' +CRLF + ;
                 'je nutno zmìnit osobní èíslo...'
        lOk   := .f.

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif
    endif

    *
    ** kontrola na duplicitu id karty
    if isOk .and. name = 'osobyw->cidoskarty' .and. changed

      isOk := .not. osoby_oW->( dbSeek( value,,'Osoby22')) .or. Empty(value)
      if .not. isOk
        cInfo += 'id karty < ' + AllTrim(value) +' >, je již použito u osoby ' +CRLF + ;
                 AllTrim( osoby_oW->cjmenorozl)
        lOk   := .f.

        fin_info_box( cInfo, XBPMB_CRITICAL )
      endif
    endif

  otherwise
    do case
    case (name = 'vazspojew->ncisspoj') .and. changed
      lok := ::selSpoj()
    case (name = 'vazfirmyw->ncisfirmy') .and. changed .and. name <> ::oldName
      lok := ::selFirma()
    case (name = 'vazukolyw->ncisukolu') .and. changed
      lok := ::selUkol()
    case (name = 'vazdokumw->ciddokum') .and. changed
      lok := ::selDok()
    endcase
  endcase

  ::oldName := name
RETURN lOK


* TAB 2 - spojeni
METHOD OSB_osoby_CRD:selSpoj(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar  := ::dm:has('vazSpojeW->ncisspoj' )
  local  cisSpoj := drgVar:odrg:ovar:value
  local  pa      := ::pa_vazRecs[1]

  if .not. empty( pa )
    spojeni->( ads_setAof('.T.'))
    spojeni->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., spojeni->( dbseek(cisSpoj,,'SPOJENI01')))

  if .not. ok
    ::start_SEL_inThread('KAN_spojeni_SEL,1')

    ok := ( drgvar:changed() .and. .not. empty(drgvar:oDrg:cargoGet))

    if( ok, spojeni->(ads_clearAof(), dbcommit(), dbskip(0), dbseek(drgvar:oDrg:cargoGet,,'ID')), nil )
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ( ::valSel := isNull( spojeni->sID, 0), ::valNaz := spojeni->cnazSpoj)
    ::dm:set( 'vazSpojew->ncisspoj'       , spojeni->ncisSpoj   )
    ::dm:set( 'vazSpojeW->czkrspoj'       , spojeni->czkrspoj   )
    ::dm:set( 'vazSpojeW->cnazspoj'       , spojeni->cnazspoj   )
    ::dm:set( 'vazSpojeW->cadrelspoj'     , spojeni->cadrelspoj )
    ::dm:set( 'vazSpojeW->mUsrElSpoj'     , spojeni->mUsrElSpoj )
    ::dm:set( 'vazSpojeW->mAdrPoSpoj'     , spojeni->mAdrPoSpoj )

    ::refreshGroup('spojeni', drgVar)
//    ::refreshGroup('vazSpojeW,spojeni', drgVar)
  endif

  ::df:setNextFocus( drgVar:oDrg )
  setAppFocus( drgvar:oDrg:oXbp )

  spojeni->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


* TAB 3 - firmy
METHOD OSB_osoby_CRD:selFirma(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar   := ::dm:has('vazFirmyw->ncisFirmy' )
  local  cisFirmy := drgVar:odrg:ovar:value
  local  pa       := ::pa_vazRecs[2]

  if .not. empty( pa )
    firmy->( ads_setAof('.T.'))
    firmy->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., firmy->( dbseek(cisFirmy,,'FIRMY1')))

  if .not. ok
    DRGDIALOG FORM 'FIR_firmy_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ( ::valSel := isNull( firmy->sID, 0), ::valNaz := firmy->cNazev)
    ::dm:set( 'vazFirmyw->ncisFirmy'    , firmy->ncisFirmy )
    ::dm:set( 'vazFirmyW->ncisfirmy'    , firmy->ncisfirmy )
    ::dm:set( 'vazFirmyW->cnazev'       , firmy->cnazev    )

    ::refreshGroup('firmy', drgVar)
//    ::refreshGroup('vazFirmyW,firmy', drgVar)
  endif

  firmy->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


* TAB 4 - úkoly
METHOD OSB_osoby_CRD:selUkol(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar   := ::dm:has('vazUkolyw->ncisUkolu' )
  local  cisUkolu := drgVar:odrg:ovar:value
  local  pa       := ::pa_vazRecs[3]

  if .not. empty( pa )
    ukoly->( ads_setAof('1 = 1'))
    ukoly->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., ukoly->( dbseek(cisUkolu,,'UKOLY01')))

  if .not. ok
    DRGDIALOG FORM 'KAN_ukoly_SEL,3' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ( ::valSel := isNull( ukoly->sID, 0), ::valNaz := ukoly->cNazUkolu)
    ::dm:set( 'vazUkolyw->ncisUkolu'    , ukoly->ncisUkolu )
    ::dm:set( 'vazUkolyW->czkrUkolu'    , ukoly->czkrUkolu )
    ::dm:set( 'vazUkolyW->cnazUkolu'    , ukoly->cnazUkolu )

    ::refreshGroup('ukoly', drgVar)
//    ::refreshGroup('vazUkolyW,ukoly', drgVar)
  endif

  ukoly->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


* TAB 5 - dokumenty
METHOD OSB_osoby_CRD:selDok(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgVar  := ::dm:has('vazDokumw->cIDdokum' )
  local  idDokum := upper(drgVar:odrg:ovar:value)
  local  pa      := ::pa_vazRecs[4]

  if .not. empty( pa )
    dokument->( ads_setAof('.T.'))
    dokument->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., dokument->( dbseek( idDokum,,'DOKUMEN03')))

  if .not. ok
    DRGDIALOG FORM 'KAN_dokument_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ( ::valSel := isNull( dokument->sID, 0)  , ::valNaz := dokument->cnazDokum)
    ::dataManager:set( 'vazDokumw->cIDdokum' , dokument->cIDdokum  )
    ::dataManager:set( 'vazDokumW->czkrdokum', dokument->czkrdokum )
    ::dataManager:set( 'vazDokumW->cnazdokum', dokument->cnazdokum )

    ::refreshGroup('dokument', drgVar)
//    ::refreshGroup('vazDokumW,dokument', drgVar)
  endif

  dokument->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


method OSB_osoby_crd:editParent()
  local  oDialog, nExit
  *
  local  pa := {{ ''                  , ''                     } , ;
                { ''                  , ''                     } , ;
                { ''                  , ''                     } , ;
                { 'KAN_SPOJENI_CRD'   , 'spojeni' , 'spojeni'  } , ;
                { 'FIR_firmy_CRD'     , 'firmy'   , 'firmy'    } , ;
                { 'KAN_ukoly_CRD'     , 'ukoly'   , 'ukoly'    } , ;
                { 'SYS_dokument_IN'   , 'dokument', 'dokument' } , ;
                { ''                  , ''                     } , ;
                { ''                  , ''                     }   }

  local  cformName := pa[::tabNum,1]
  local  cfileMain := pa[::tabNum,3]
  *
  ::start_SEL_inThread( cformName +',' +str((cfileMain)->(recNo())) )

  * refrešneme zmìny, moc nás nezajímá jestli nìjaké udìlal
  (cfileMain)->(dbcommit(), dbskip(0))
  ::setFocus_onTab( .t. )
  ::refreshGroup( pa[::tabNum,2] )
return self


METHOD OSB_osoby_CRD:onSave(lIsCheck,lIsAppend)

  osobyW->cosoba     := mh_JOINupSTR( osobyW->ctitulPred , " ", ;
                                      osobyW->cprijOsob  , " ", ;
                                      osobyW->cjmenoOsob , ",", ;
                                      osobyW->ctitulZa          )

  osobyW->cUlicCiPop := mh_JOINupSTR( osobyW->cUlice," ", ;
                                      osobyW->ccisPopis   )

  osobyW->cjmenoRozl := allTrim( osobyW->cprijOsob ) +' ' + ;
                        allTrim( osobyW->cjmenoOsob) +' ' + ;
                        allTrim( osobyW->crozlJmena)

  if ::lNEWrec
    mh_copyFld( 'osobyW', 'osoby', .t.)

  else
    if osoby->( sx_Rlock())
      mh_copyFld( 'osobyW', 'osoby')

      osoby->(dbUnlock())
    endif
  endif

  osoby->( dbcommit())
  PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
RETURN .t.


method OSB_osoby_crd:eBro_saveEditRow(o_eBro)
  local  cfile := lower(o_ebro:cfile),  pa
  local  recNo, nitem, czkrSpoj := '', lhlavVazba := .f.
  *
  local  lrefreshAll := .f.

  do case
  case ( cfile = 'vazspojew' )
    pa := ::pa_vazRecs[1]

    * nový záznam vazSpojew
    if empty((cfile)->SPOJENI)
      mh_copyFld( 'spojeni', 'vazSpojeW' )

      (cfile)->SPOJENI := ::valSel
      aadd( pa, spojeni->(recNo()) )
    endif
    czkrSpoj   := (cfile)->czkrSpoj
    lhlavVazba := (cfile)->lhlavVazba

  case ( cfile = 'vazfirmyw' )
    pa := ::pa_vazRecs[2]

    * nový záznam vazFirmyw
    if empty((cfile)->FIRMY )
      mh_copyFld( 'firmy', 'vazFirmyW' )

      (cfile)->FIRMY := ::valSel
      aadd( pa, firmy->(recNo()) )
    endif

  case ( cfile = 'vazukolyw' )
    pa := ::pa_vazRecs[3]

    * nový záznam vazUkolyw
    if empty((cfile)->UKOLY)
      mh_copyFld( 'ukoly', 'vazUkolyW' )

      (cfile)->UKOLY := ::valSel
      aadd( pa, ukoly->(recNo()) )
    endif

  case ( cfile = 'vazdokumw' )
    pa := ::pa_vazRecs[4]

    * nový záznam vazDokumw
    if empty((cfile)->DOKUMENT)
      mh_copyFld( 'dokument', 'vazDokumW' )

      (cfile)->DOKUMENT := ::valSel
      aadd( pa, dokument->(recNo()) )
    endif
  endcase

  * obecná mitomost, uživateli nabídneme èíslování nitem
  * hale dáme mu možnost to zmìnit, u spojení si ještì mùže nastavit
  * lhlavVazba ale ta musí být jen jedna
  ** 24.5.2012
  * ZMÌNA - lhlaVazba mùže být jedna ala v rámci promìnné czkrSpoj

  recNo      := (cfile)->(recNo())
  nitem      := (cfile)->nitem
//  lhlavVazba := if( (cfile)->(fieldPos('lhlavVazba')) = 0, .f., (cfile)->lhlavVazba )
  fordRec({ cfile })

  (cfile)->(dbgoTop())

  do while .not. (cfile)->(eof())
    if (cfile)->nitem >= nitem .and. (cfile)->(recNo()) <> recNo
      (cfile)->nitem++
      lrefreshAll := .t.
    endif

    if ( cfile = 'vazspojew' .and. lhlavVazba )
      if (cfile)->czkrSpoj = czkrSpoj .and. (cfile)->lhlavVazba .and. (cfile)->(recNo()) <> recNo
        (cfile)->lhlavVazba := .f.
        lrefreshAll := .t.
      endif
    endif

//    if( (cfile)->(fieldPos('lhlavVazba')) <> 0 .and. lhlavVazba .and. (cfile)->(recNo()) <> recNo )
//      (cfile)->lhlavVazba := .f.
//      lrefreshAll := .t.
//    endif

    (cfile)->(dbskip())
  enddo
  fordRec()

  if( lrefreshAll, o_eBro:oxbp:refreshAll(), nil )
return


method OSB_osoby_crd:postSave()
  local  ok  := .t.
  local  x, y, cfile_M, paLock, paObj, cfile_W, paVaz, isEmpty, val, nIn
  local  paF := { { 'osoby'     , {}, nil                , 0 }, ;
                  { 'vazSpojeX' , {}, nil                , 1 }, ;
                  { 'vazFirmyX' , {}, nil                , 1 }, ;
                  { 'vazUkolyX' , {}, nil                , 1 }, ;
                  { 'vazDokumX' , {}, nil                , 1 }, ;
                  { 'osobySk'   , {}, 'osobySkW->_setsku', 0 }  }

  local  sname    := drgINI:dir_USERfitm +'mmacro', fields, cKy, anMsp := {}
  local  lenBuff  := 40960, buffer := space(lenBuff)
  local  b_mblock         := { || .t. }
  local  b_osoby_msOsb_mo := { || .t. }, is_msOsb_mo := .f.
  *
  local  nrok     := uctOBDOBI_LAST:MZD:NROK
  local  nobdobi  := uctOBDOBI_LAST:MZD:NOBDOBI

  * slepenci ve slivenci
  OSB_glueItems()

  * na pokladnì se požívá výbìr osob s pùvodní indikací lpri_Zal
  osobyW->lpri_Zal := ( osobyW->nis_ZAL = 1 )

  if asystem->( dbseek( 'OSB_OSOBY_CRD',, 'ASYSTEM01'))
    memoWrit( sname, asystem->mMacro )
    *
    * naèetem ze sekce UsedIdentifiers Fields *
    * osoby - do -> msPrcMo
    GetPrivateProfileSectionA('macro', @buffer, lenBuff, sname)
    fields   := substr(buffer,1,len(trim(buffer))-1)
    fields   := strtran(fields,chr(0),',')
    fields   := substr(fields,1,len(fields) -1)

    if( .not. empty(fields), b_mblock := COMPILE(fields), nil )

    * osoby - do -> msOsb_mo
    buffer := space(lenBuff)
    GetPrivateProfileSectionA('OSOBY_MSOSB_MO', @buffer, lenBuff, sname)
    fields := substr(buffer,1,len(trim(buffer))-1)
    fields := strtran(fields,chr(0),',')
    fields := substr(fields,1,len(fields) -1)

    if( .not. empty(fields), b_osoby_msOsb_mo := COMPILE(fields), nil )

    ferase(sname)
    buffer := ''
  endif

  * zámky
  for x := 1 to len(paF) step 1
    cfile_M := paF[x,1]
    cfile_W := strTran(cfile_M, 'X', '') +'w'
    paLock  := paF[x,2]
    paObj   := paF[x,3]

    (cfile_W)->(ordSetFocus(0), dbgoTop())

    do while .not. (cfile_W)->(eof())
      if((cfile_W)->_nrecor <> 0, AAdd(paLock, (cfile_W)->_nrecor), nil)

      if isArray(paObj) .or. isCharacter(paObj)
        isEmpty := .t.
        if isArray(paObj)
          AEval(paObj,{|x| isEmpty := (isEmpty .and. empty( eval(x:ovar:block))) })
        else
          isEmpty := (isEmpty .and. .not. DBGetVal(paObj))
        endif

        if( isEmpty, (cfile_W)->_delrec := '9', nil)
      endif
      (cfile_W)->(dbSkip())
    enddo

    ok := (ok .and. (cfile_M)->(sx_RLock(paLock)))
  next

  * specialitna pro msPrc_mo a msOsb_mo
  if osoby->nosCisPrac <> 0 .and. osoby->nporPraVzt <> 0

    * osoby - do -> msPrc_mo
    cKy := strZero(nrok,4) +strZero(nobdobi,2) +strZero(osoby->nosCisPrac,5)
    msPrc_mo->( ordsetFocus('MSPRMO01'), dbsetScope(SCOPE_BOTH, cKy), DbGoTop() )
    msPrc_mo->( dbeval( { || aadd( anMsp, msPrc_mo->(recNo())) } ))

    ok := ( ok .and.  msPrc_mo->(sx_RLock(anMsp)))

    * osoby do -> msOsb_mo
    if( is_msOsb_mo := msOsb_mo->( dbseek( cKy,,'MSOSB_MO10')) )
      ok := ( ok .and. msosb_mo->(sx_RLock()) )
    endif
  endif


  * ukládáme
  if ok
    for x := 1 to len(paF) step 1
      cfile_M := paF[x,1]
      cfile_W := strTran(cfile_M, 'X', '') +'w'
      paLock  := paF[x,2]
      paVaz   := paF[x,4]

      (cfile_W)->(dbgoTop())

      do while .not. (cfile_W)->(eof())
        if (cfile_W)->_delrec <> '9'

          if((nrecor := (cfile_W)->_nrecor) = 0, nil, (cfile_M)->(dbgoto(nrecor)))
          if   (cfile_W)->_delrec = '9'  ;  (cfile_M)->(dbdelete())
          else
            if( paVaz = 1, (cfile_W)->nOSOBY := isNull( osoby->sID, 0), nil )

            if x <> 1 .and. (cfile_W)->(fieldPos('ncisOsoby')) <> 0
              (cfile_W)->ncisOsoby := osoby->ncisOsoby
            endif

            mh_copyFld(cfile_W,cfile_M,((cfile_W)->_nrecor = 0))

            if(nIn := AScan(paLock, nrecor)) <> 0
              (adel(paLock,nIn), asize(paLock, len(paLock) -1))
            endif
          endif
        endif

        (cfile_W)->(dbSkip())
      enddo

      AEval(paLock, {|recs| (cfile_M)->(dbgoTo(recs), dbDelete()) })
    next

    * specialitna pro msPrc_mo a msOsb_mo
    if osoby->nosCisPrac <> 0 .and. osoby->nporPraVzt <> 0
      msPrc_mo->(dbgotop())
      do while .not. msPrc_mo->(eof())
        eval( b_mblock )
        msPrc_mo->( dbskip())
      enddo

      if( is_msOsb_mo, eval(b_osoby_msOsb_mo), nil )
    endif
  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat OSOBY, blokováno uživatelem !!!'))
  endif

  AEval( paF, { |x| (x[1])->(dbUnlock(),dbCommit()) })
  msPrc_mo->(dbUnlock(),dbCommit())
return ok

/*
osoby->nosCisPrac <> 0

local  nrok    := uctOBDOBI:MZD:NROK
local  nobdobi := uctOBDOBI:MZD:NOBDOBI

msPrc_mo - scope MSPRMO01 - STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3)
zámek a smyèka

aplikovat b_mblock

*/



method OSB_osoby_crd:destroy()
  ::drgUsrClass:destroy()

  * uklidíme si
  * ale pokud to voláme z editaèního dialogu, tak by nám to áflo
  *
  if ::closeW_files
    osobyW   ->(dbcloseArea())
    vazSpojeW->(dbclearRelation(), dbcloseArea())
    vazFirmyW->(dbclearRelation(), dbcloseArea())
    vazUkolyW->(dbclearRelation(), dbcloseArea())
    vazDokumW->(dbclearRelation(), dbcloseArea())
    osobySkW ->(dbcloseArea())
  endif
RETURN SELF