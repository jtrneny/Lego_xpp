#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "dmlb.ch"
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

STATIC allRecs


* osoby                                    OSB  1
* osoby     vazOsoby  rodinní pøíslušníci  OSB  2  vazOsobyW->ncisOsoby
* duchody                                  PER  3  duchodyW->ntypDuchod
* prSmlDoh                                 PER  4  osobyW->nosCisPrac
* vzdelani                                 PER  5  vzdelaniW->czkrVzdel
* lekprohl  vazLekpr                       PER  6  vazLekprW->cZkratka
* skoleni   vazSkol                        PER  7  vazSkolW->cZkratka
*
*  OSOBY
** CLASS PER_osoby_CRD *********************************************************
CLASS PER_osoby_CRD FROM drgUsrClass
EXPORTED:
  METHOD  init, drgDialogStart
  METHOD  itemMarked
  method  postValidate, all_tabOnSave, postSave
  *
  method  per_osoby_sel      , per_lekprohl_sel, per_skoleni_sel
  method  per_osoby_toPer_sel
  method  editParent

  var     lnewRec, pa_vazRecs


  inline access assign method oscisPrac() var oscisPrac
    return osobyW->noscisPrac
  *
  ** TAB 3 duchody
  inline access assign method is_aktiv() var is_aktiv
    return if( duchodyW->lAktiv, MIS_ICON_OK, 0 )

  inline access assign method nazDuchod() var nazDuchod
    c_duchod->(dbseek( duchodyW->ntypDuchod,,'C_DUCHOD01'))
    return c_duchod->cnazDuchod
  *
  ** TAb 5 vzdìlání
  inline access assign method nazev_Vzdelani var nazev_Vzdelani
    c_vzdel->(dbseek( upper( vzdelaniW->czkrVzdel),,'C_VZDEL01'))
    return c_vzdel->cnazVzdela
  *
  ** TAB 6 lékarské prohlídky
  inline access assign method nazev_lekPro var nazev_lekPro
    c_lekPro->(dbseek( upper( lekProhl->czkratka),,'C_LEKPRO01'))
    return c_lekPro->cnazev
  *
  ** TAB 7 školení/ kurzy
  inline access assign method nazev_Skoleni var nazev_Skoleni
    c_skolen->(dbseek( upper( skoleni->czkratka),,'C_SKOLEN01'))
    return c_skolen->cnazev

  *
  **
  inline method tabSelect(oTabPage,tabNum)
    local  cfile
    *
    local  drgVar    := ::pa_focusOnEdit[otabPage:tabNumber]
    local  drgButton := ::paoB_editParent[otabPage:tabNumber]

    ::tabNum := otabPage:tabNumber

    if isObject(drgVar)
      (drgVar:odrg:isEdit := .f., drgVar:odrg:oxbp:disable() )

      if isObject(drgButton)
        cfile := drgParse(drgVar:name,'-')

        if( (cfile)->(eof()), drgButton:disable(), ;
                              drgButton:enable()   )
      endif
    endif
    ::relForText()
    ::setFocus_onTab(.t.)
  return .T.


  inline method eventHandled(nEvent,mp1,mp2,oXbp)
    local  oaBrowse := ::dc:oaBrowse
    local  cfile    := oaBrowse:cfile
    local  drgVar   := ::pa_focusOnEdit[::tabNum]


    if nevent = xbeM_LbClick
      if   oXbp:className() = 'XbpCellGroup'
        if ::state <> 0
          oaBrowse:oxbp:refreshCurrent():hilite()
          PostAppEvent(xbeBRW_ItemMarked,,,oaBrowse:oxbp)
        endif
      else
        if( ::state = 0, ::state := 1, nil )
      endif
    endif

    do case
*    case nEvent = xbeP_Close
*      return .not. ::postEscape()

    case nEvent = xbeBRW_ItemMarked
      if ::state <> 0
        ::state := 0
        ::setFocus_onTab(.t.)
        osoby_Rp->(dbseek( vazOsobyW->ncisOsoby,,'OSOBY01'))
        ::dm:refresh()
      endif
      RETURN .F.

    case(nevent = drgEVENT_ACTION)
      if isNumber(mp1)
        if mp1     = drgEVENT_EDIT
          do case
          case  ::tabNum = 6 .or. ::tabNum = 7
            RETURN .T.

          case ::tabNum = 2 .or. ::tabNum = 3 .or. ::tabNum = 4 .or. ::tabNum = 5
            ::df:setNextFocus( drgvar:odrg,, .T. )
            RETURN .F.
          endcase

        elseif mp1 = drgEVENT_SAVE
          do case
          case ::tabNum <> 1 .and. oXbp:ClassName() <> 'XbpBrowse'
           ::all_tabOnSave( lower( cfile))
           ::setFocus_onTab(.t.)
           ::state := 0
           RETURN .T.

          otherwise
            ::postSave()

            _clearEventLoop()
            PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp)
            RETURN .T.
          endcase
        endif
      endif
      RETURN .F.

    case nEvent = drgEVENT_APPEND
      do case
      case ::tabNum = 2 .or. ::tabNum = 6 .or. ::tabNum = 7
        ::state := 2
        ::relForText()

        ::df:setNextFocus( drgVar:odrg,, .T. )
        ( drgVar:odrg:isEdit           := .t.                                          , ;
          if( isObject(drgVar:odrg:pushGet), drgVar:odrg:pushGet:disabled := .f., nil ), ;
          drgVar:odrg:oxbp:enable()            )
        RETURN .T.

      case ::tabNum = 3 .or. ::tabNum = 5
        ::state := 2
        ::dm:refreshAndSetEmpty( cfile )

        ::df:setNextFocus( drgvar:odrg,, .T. )
        ( drgVar:odrg:isEdit           := .t.                                          , ;
          if( isObject(drgVar:odrg:pushGet), drgVar:odrg:pushGet:disabled := .f., nil ), ;
          drgVar:odrg:oxbp:enable()            )
        RETURN .T.

      case ::tabNum = 4
        ::state := 2
        ::dm:refreshAndSetEmpty( cfile )

        ::df:setNextFocus( drgvar:odrg,, .T. )
        if empty( (cfile)->noscisPrac)
          ( drgVar:odrg:isEdit := .t., drgVar:odrg:oxbp:enable() )

          msPrc_mo->( ordsetFocus('MSPRMO09'), dbgoBottom())
          ::dm:set( "prsmldohW->noscisPrac", msPrc_mo->noscisPrac +1)
          else
          ::dm:set( "prsmlDohW->noscisPrac", (cfile)->noscisPrac )
        endif

        ::dm:set( "prsmlDohW->nporPraVzt", (cfile)->(Ads_getLastAutoinc()) +1)
        RETURN .T.

      endcase

    case nEvent = drgEVENT_EDIT
      do case
      case ::tabNum = 2 .or. ::tabNum = 6 .or. ::tabNum = 7
        RETURN .t.

      case ::tabNum = 3 .or. ::tabNum = 4 .or. ::tabNum = 5
        ::df:setNextFocus( drgvar:odrg,, .T. )
        RETURN .T.
      endcase

    case nEvent = drgEVENT_DELETE
      if ( lower(::df:oLastDrg:classname()) $ 'drgdbrowse')
        if( .not. (cfile) ->(eof()), ::all_broDelete( lower(cfile), ::df:oLastDrg), nil )
        return .t.
      endif

    case nEvent = xbeP_Keyboard
      if mp1 =  xbeK_ESC
        do case
        case ::tabNum <> 1 .and. oXbp:ClassName() <> 'XbpBrowse'
          ::state := 0
          ::setFocus_onTab(.t.)
          ::dm:refresh()
**          ::relForText( .t. )
          return .T.

        otherwise
          if( ::postEscape(), PostAppEvent(xbeP_Close,drgEVENT_QUIT,,oXbp), nil)
          RETURN .T.

        endcase
      endif
      return .F.

    otherWise
      RETURN .F.
    endCase
  RETURN .F.

HIDDEN:
  var   tabNum, pao_Brow
  VAR   msg, dm, dc, df, ab, brow
  var   m_udcp, m_formName
  VAR   state, oactive_Brow, pa_focusOnEdit, paoB_editParent
  *
  var   valSel


  inline method relForText( all_onTab)
    local  cfile := ''
    local  drgvar   := ::dm:has('vazOsobyW->ncisOsoby')
    *
    default all_onTab to .f.
    *
    do case
    case ::tabNum = 2
      osoby_Rp  ->( dbseek( vazOsobyW->nOSOBY   ,, 'ID'         ))
      c_psc_2   ->( dbseek( osoby_Rp->cpsc      ,, 'C_PSC1'     ))
      c_staty_2 ->( dbseek( osoby_Rp->czkratStat,, 'C_STATY1'   ))
      cfile := 'vazOsobyW,osoby_Rp,c_psc_2,c_staty_2'

    case ::tabNum = 3
      c_psc_3   ->( dbseek( firmy->cpsc        ,, 'C_PSC1'      ))
      c_staty_3 ->( dbseek( firmy->czkratStat  ,, 'C_STATY1'    ))
      cfile := 'firmy,c_psc_3,c_staty_3'

    case ::tabNum = 5
      c_psc_5   ->( dbseek( vzdelaniW->cpsc       ,, 'C_PSC1'   ))
      c_staty_5 ->( dbseek( vzdelaniW->czkratStat ,, 'C_STATY1' ))
      cfile := 'vzdelani,c_psc_5,c_staty_5'

    case ::tabNum = 6
      lekProhl  ->( dbseek( vazLekprW->LEKPROHL        ,, 'ID'        ))
      c_lekpro  ->( dbseek( upper(vazLekprW->czkratka) ,, 'C_LEKPRO01'))
      c_psc_6   ->( dbseek( lekprohl->cpsc             ,, 'C_PSC1'    ))
      c_staty_6 ->( dbseek( lekprohl->czkratStat       ,, 'C_STATY1'  ))
      cfile := 'lekprohl,c_lekpro,c_psc_6,c_staty_6'

    case ::tabNum = 7
      skoleni   ->( dbseek( vazSkolW->SKOLENI         ,, 'ID'         ))
      c_skolen  ->( dbseek( upper(vazSkolW->czkratka) ,, 'C_SKOLEN01' ))
      c_psc_7   ->( dbseek( skoleni->cpsc             ,, 'C_PSC1'     ))
      c_staty_7 ->( dbseek( skoleni->czkratStat       ,, 'C_STATY1'   ))
      cfile := 'skoleni,c_skolen,c_psc_7,c_staty_7'

    endCase

    if( .not. empty(cfile), ::refreshGroup( cfile,,, all_onTab ), nil )
    return self


  inline method all_broDelete( cfile, obro )
    local  cInfo  := 'Promiòte prosím,'          +CRLF + ;
                     'požadujete zrušit vazbu '
    local  cc     := '', nsel, pa := {}, recNo, npos

    do case
    case( cfile = 'vazosobyw' ) ;  cc    := 'rodinného pøíslušníka'       // Vazby na rodinné pøíslušníky
                                   pa    := ::pa_vazRecs[1]
                                   recNo := osoby_Rp->(recNo())

    case( cfile = 'duchodyw'  ) ;  cc    := 'pøiznaného dùchodu'          // dùchody

    case( cfile = 'prsmldohw' ) ;  cc    := 'pracovní smlouvy/ dohody'    // pracovní smlouvy/ dohody

    case( cfile = 'vzdelaniw' ) ;  cc    := 'vzdìlání pracovníka'         // vzdelání

    case( cfile = 'vazlekprw' ) ;  cc    := 'lékaøské prohlídky'          // Vazby na lékaøské prohlídky
                                   pa    := ::pa_vazRecs[2]
                                   recNo := lekprohl->(recNo())

    case( cfile = 'vazskolw'  ) ;  cc    := 'školení pracovníka'          // Vazby na školení
                                   pa    := ::pa_vazRecs[3]
                                   recNo := skoleni->(recNo())

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
        ::relForText()
      endif
    endif
    return .t.


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

    * naplníme prázdnou hodnotu první prvek na kartì pro vstup pri INS
    if ::state = 2 .and. isNull(drgvar)
      drgVar  := ::pa_focusOnEdit[::tabNum]
      new_Val := if( ::tabNum = 2 .or. ::tabNum = 3 .or. ::tabNum = 4, 0, '' )

      if isObject(drgVar)
        drgVar:set(new_Val)
        drgVar:initValue := drgVar:prevValue := drgVar:value
      endif
    endif

    if nextFocus
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    endif
    return .t.


  inline method restColor()
    local  members := ::df:aMembers
    local  brow, nin, npos := 0
    *
    local  pao_Brow := ::pao_Brow, tabNum := ::tabNum
    aeval(members, {|X| if(ismembervar(x,'clrFocus'),x:oxbp:setcolorbg(x:clrfocus),nil)})
    return .t.


  inline method setFocus_onTab( refreshAll )
    local  nIn, zkr_skup, cky, brow
    *
    local  pao_brow := ::pao_brow, tabNum := ::tabNum
    local  drgVar   := ::pa_focusOnEdit[::tabNum]

    default refreshAll to .f.

    if( nIn := ascan(pao_brow, {|x| x[3] = tabNum })) <> 0
      ::df:olastdrg                 := ::pao_brow[nIn,2]
      ::df:nlastdrgix               := ::pao_brow[nIn,1]
      ::dm:drgDialog:lastXbpInFocus := ::pao_brow[nIn,2]:oxbp
*      ::df:olastdrg:setFocus()

      ::dc:oaBrowse := ::pao_brow[nIn,2]
      brow := ::dc:oaBrowse:oXbp

*      ::df:olastdrg:setFocus( ,, brow)
      ::dm:refresh()

      if( isObject(drgVar), ;
          ( drgVar:odrg:isEdit           := .f.                                          , ;
            if( isObject(drgVar:odrg:pushGet), drgVar:odrg:pushGet:disabled := .t., nil ), ;
            drgVar:odrg:oxbp:disable()                                                     ), nil )

      if( refreshAll, ( brow:refreshAll(), ::restColor(), setAppFocus(brow) ), nil )
    endif
  return .t.


  inline method postEscape()
    local nsel

    nsel := confirmBox(,'Požadujete ukonèit poøízení BEZ uložení dat ?', ;
                        'Data nebudou uložena ...'                     , ;
                         XBPMB_YESNO                                   , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE  , ;
                         XBPMB_DEFBUTTON2                                )
    return (nsel = XBPMB_RET_YES)


  inline method start_SEL_inThread(cformName)
    local  oThread
    local  nevent, mp1 := NIL, mp2 := NIL, oXbp := NIL

    oThread := drgDialogThread():new()
    oThread:start( ,cformName, ::drgDialog, .t.)

    do while .not. ( nEvent = drgDIALOG_END )
      nEvent := AppEvent( ,,,0 )
    endDo
    return

  inline method refresh(drgVar,nextFocus,vars_)
    local  nin, ovar, vars, new_val, dbArea

    default nextFocus to .f.

    if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                            vars   := drgVar:drgDialog:dataManager:vars
    else                 ;  dbarea := lower(drgVar)
                            vars   := vars_
    endif

    for nIn := 1 TO vars:size() step 1
      oVar := vars:getNth(nIn)

      if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
        if(new_val := eval(ovar:block)) <> ovar:value
          ovar:set(new_val)
        endif
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    next

    if nextFocus
      PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
    endif
    return .t.

ENDCLASS


METHOD PER_osoby_crd:init(parent)

  ::drgUsrClass:init(parent)

  ::lnewRec := .not. (parent:cargo = drgEVENT_EDIT)
  if( osoby->(eof()), ::lnewRec := .t., nil )

  *                     rodinní pøíslušníci lékarské prohlídky školení/ kurzy
  *                     2                   3                  4
  ::pa_vazRecs      := { {},                 {},                {}     }
  ::tabNum          := 1
  ::pao_Brow        := {}
  ::state           := 0
  ::paoB_editParent := { , , , , , , }

  * pomocný alias osoby pro kontolu cJmenoRozl - nesmíme povolit
  *               msPrc_mo, jednak kontrola na noscisPrac
  *                         pokud založí nový PPV zaklídáme msPrc_mo
  drgDBMS:open('osoby',,,,,'osoby_oW'   )
  drgDBMS:open('osobySk' )
  drgDBMS:open('msPrc_mo')


  * TAB 2 rodinní pøíslušníci
  drgDBMS:open('c_psc'   ,,,,,'c_psc_2'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_2')
  drgDBMS:open('osoby'   ,,,,,'osoby_Rp' )
  drgDBMS:open('vazOsoby',,,,,'vazOsobyX')

  * TAb 3 dùchody
  drgDBMS:open('c_duchod'                )
  drgDBMS:open('c_psc'   ,,,,,'c_psc_3'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_3')

  * TAB 5 vzdìlání
  drgDBMS:open('c_psc'   ,,,,,'c_psc_5'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_5')

  * TAb 6 lékarské prohlídky
  drgDBMS:open('c_psc'   ,,,,,'c_psc_6'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_6')
  drgDBMS:open('c_lekpro')
  drgDBMS:open('lekProhl')
  drgDBMS:open('vazLekpr',,,,,'vazLekprX')

  * TAB 7 školení/ kurzy
  drgDBMS:open('c_psc'   ,,,,,'c_psc_7'  )
  drgDBMS:open('c_staty' ,,,,,'c_staty_7')
  drgDBMS:open('c_skolen' )
  drgDBMS:open('skoleni'  )
  drgDBMS:open('vazSkol',,,,,'vazSkolX' )


  PER_osoby_cpy( self )

  if ::lnewRec
    fordRec( { 'osoby_oW,1' } )
    osoby_oW  ->( DbGoBottom())
    osobyW ->ncisOsoby := osoby_oW->ncisOsoby +1
    fordRec()
  endif
RETURN self


METHOD PER_osoby_crd:drgDialogStart(drgDialog)
  local  amembers := drgDialog:oForm:amembers, x
  *
  local  acolors  := MIS_COLORS

  *
  ::msg        := drgDialog:oMessageBar             // messageBar
  ::dm         := drgDialog:dataManager             // dataMabanager
  ::dc         := drgDialog:dialogCtrl              // dataCtrl
  ::df         := drgDialog:oForm                   // form
  *
  ::m_formName := lower(drgDialog:parent:formName)
  ::m_UDCP     := drgDialog:parent:UDCP

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

    if lower(amembers[x]:ClassName()) $ 'drgdbrowse'
      AAdd(::pao_brow, {x,amembers[x],val(amembers[x]:groups)})
    endif

    if ( amembers[x]:ClassName() = 'drgPushButton' .and. isCharacter( amembers[x]:event) )
      if lower( amembers[x]:event) = 'editparent'
        tabNum := val(amembers[x]:caption)

        aMembers[x]:isEdit        := .f.
        ::paoB_editParent[tabNum] := amembers[x]
      endif
    endif
  next

  ::pa_focusOnEdit := { ''                               , ;
                        ::dm:has('vazOsobyW->ncisOsoby' ), ;
                        ::dm:has('duchodyW->ntypDuchod' ), ;
                        ::dm:has('prsmlDohw->nosCisPrac'), ;
                        ::dm:has('vzdelaniW->czkrVzdel' ), ;
                        ::dm:has('lekProhlW->cZkratka'  ), ;
                        ::dm:has('skoleniW->cZkratka'   )  }

   if .not. ::lnewRec
     do case
     case( ::m_formName = 'per_osoby_scr' )
       if ::m_UDCP:tabNum <> 1
         ::tabNum := ::m_UDCP:tabNum
         postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[::tabNum]:oxbp )
       endif
     case( ::m_formName = 'per_vzdelani_scr' )
       ::tabNum := 5
       postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[::tabNum]:oxbp )
     case( ::m_formName = 'per_skoleni_scr' )
       ::tabNum := 7
       postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[::tabNum]:oxbp )
     case( ::m_formName = 'per_lekprohl_scr' )
       ::tabNum := 6
       postAppEvent(xbeTab_TabActivate,,,::drgDialog:oForm:tabPageManager:members[::tabNum]:oxbp )
      endcase
   endif

RETURN self


method PER_osoby_crd:itemMarked(x,y)

 ::relForText()
return self


method PER_osoby_crd:postValidate(drgVar)
  local  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  local  file := drgParse(name,'-')
  local  lOK  := .T., xval
  LOCAL  oldRec, nLastKey, nis_Ok := 0
  *
  local  cjmenoRozl, recCnt := 0, recNo
  local  cInfo     := 'Promiòte prosím,' +CRLF
  local  exitState :=  ( ::df:nexitState = GE_ENTER .or. ::df:nexitState = GE_DOWN )
  *
  local  cf        := "upper(cjmenoRozl) = '%%'", filter // .and. nis_PER = 0", filter
  local  pa        := { 'cprijOsob', 'cjmenoOsob', 'crozlJmena' }

  ** ukládáme pøi zmìnì do tmp **
  do case
  case ( file = 'osobyw' )
    if changed
      ( ::dm:save(), ::dm:refresh(.T.) )
    endif

    cjmenoRozl := allTrim( osobyW->cprijOsob ) +' ' + ;
                  allTrim( osobyW->cjmenoOsob) +' ' + ;
                  allTrim( osobyW->cRozlJmena)

    filter := format( cf, { upper(cjmenoRozl) })
    osoby_oW->( ads_setAof( filter )        , ;
                dbgotop()                   , ;
                recNo := osoby_oW->(recNo()), ;
                dbeval( { || recCnt++ } )   , ;
                ads_clearAof()              , ;
                osoby_oW->(dbgoTo(recNo))     )

    if ::lnewRec
      if     recCnt = 0
        nis_Ok := 0
      elseif recCnt <> 0 .and. osoby_oW->nis_PER = 0
        nis_Ok := 1
      elseif recCnt <> 0 .and. osoby_oW->nis_PER = 1
        cInfo += 'osoba < ' +cjmenoRozl +'>, již existuje v souboru' +CRLF +CRLF + ;
                 'presonalní evidence ...'

        fin_info_box( cinfo, XBPMB_CRITICAL)
        ::drgDialog:oForm:setNextFocus('osobyW->crozlJmena',, .T.)
//      ::df:setNextFocus( 'osobyW->cprijOsob',, .T. )
        return .t.
      endif
    endif

    if nis_Ok = 1
      cInfo += 'osoba < ' +cjmenoRozl +'>, již existuje v souboru osoby' +CRLF +CRLF + ;
               'je možné pøevzít osobu do presonalistiky ...'

      if drgIsYESNO( cInfo )
        mh_copyFld('osoby_oW', 'osobyW',, .t.)

        * pøecházíme do opravy
        ::lnewRec := .f.
        ::refresh( ::dm:has('osobyW->cprijOsob') )

        for x := 1 to len(pa) step 1
          drgvar := ::dm:has('osobyW->' +pa[x])

          drgVar:odrg:isEdit := .f.
          drgVar:odrg:oXbp:disable()
        next
        ::df:setNextFocus( 'osobyW->ctitulPred',, .T. )
      else

        if name <> 'osobyw->crozljmena'
          ::drgDialog:oForm:setNextFocus('osobyW->crozlJmena',, .T.)
          lOk := .t.
        endif
      endif
    endif

    osobyW->cjmenoRozl := cjmenoRozl

  case ( name = 'prsmldohw->noscisprac' )
    if msPrc_mo->( dbseek( value,,'MSPRMO09'))
      fin_info_box('Duplicitní osobní èíslo ' +CRLF +'v matrièním souboru pracovníkù ...', XBPMB_CRITICAL)
      lok := .f.
    endif

  case ( name = 'duchodyw->ncisfirmy'    .or. ;
         name = 'prsmldohw->ddDatvyst'   .or. ;
         name = 'vzdelaniw->czkratstat'       )
    if exitState
      PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
    endif

  otherwise
    do case
    case (name = 'vazosobyw->lsleodpdan' .or. ;
          name = 'vazlekprw->czkratka'   .or. ;
          name = 'vazskolw->czkratka'         )

      if exitState
        PostAppEvent(drgEVENT_ACTION, drgEVENT_SAVE, '0', drgVar:odrg:oXbp)
      endif
    endcase
  endcase
RETURN lOK


method PER_osoby_crd:all_tabOnSave( cfile )
  local  pa
  local  npor    := (cfile)->( Ads_getLastAutoinc()) +1
  local  lnewRec := ((cfile)->(eof()) .or. ::state = 2)

  do case
  case( cfile = 'vazosobyw' )
    pa := ::pa_vazRecs[1]

    * nový záznam
    if ::state = 2
      mh_copyFld( 'osoby_Rp', 'vazOsobyW', .t. )

      (cfile)->nOSOBY    := ::valSel
      (cfile)->ncisosoby := osoby_Rp->ncisOsoby
      aadd( pa, osoby_Rp->(recNo()) )
    endif
    (cfile)->ddatNaroz  := ::dm:get( cfile +'->ddatNaroz' )
    (cfile)->crodCisOsb := ::dm:get( cfile +'->crodCisOsb')
    (cfile)->ctypRodPri := ::dm:get( cfile +'->ctypRodPri')
    (cfile)->lsleOdpDan := ::dm:get( cfile +'->lsleOdpDan')

  case( cfile = 'duchodyw'  )
    if( lnewRec, ((cfile)->(dbappend()),(cfile)->nporDuchod  := npor), nil )
    ::dm:save()

  case( cfile = 'prsmldohw' )
    if( lnewRec, ((cfile)->(dbappend()), (cfile)->nporPraVzt := npor), nil )
    ::dm:save()

  case( cfile = 'vzdelaniw' )
    if( lnewRec, ((cfile)->(dbappend()), (cfile)->nporadi    := npor), nil )
    ::dm:save()

  case( cfile = 'vazlekprw' )
    pa := ::pa_vazRecs[2]

    * nový záznam
    if lnewRec
      mh_copyFld( 'lekProhl', 'vazLekprW', .t.)

      (cfile)->LEKPROHL := ::valSel
      (cfile)->nporadi  := npor
      (cfile)->czkratka := lekprohl->czkratka
      aadd( pa, lekprohl->(recNo()) )
    endif

  case( cfile = 'vazskolw'  )
    pa := ::pa_vazRecs[3]

    * nový záznam
    if lnewRec
       mh_copyFld( 'skoleni', 'vazSkolW', .t. )

      (cfile)->SKOLENI  := ::valSel
      (cfile)->nporadi  := npor
      (cfile)->czkratka := skoleni->czkratka
      aadd( pa, skoleni->(recNo()) )
    endif
  endcase
return .t.


* nabídka osob pro pøevzetí do PERSONAL
* musíme je odfiltrovat "nis_PER = 0"
*
method PER_osoby_crd:per_osoby_toPer_sel(drgDialog)
  local  ok, x
  *
  local  drgvar    := ::dm:has('osobyW->cprijOsob')
  local  prijOsoby := drgVar:odrg:ovar:value
  *
  local  pa        := { 'cprijOsob', 'cjmenoOsob', 'crozlJmena' }


  ::start_SEL_inThread('PER_osoby_SEL,,nis_PER = 0')

  ok := ( drgvar:changed() .and. .not. empty(drgvar:oDrg:cargoGet))
  if( ok, osoby_oW->( dbcommit(), dbskip(0), dbseek(drgvar:oDrg:cargoGet,,'ID')), nil )

  if ok
    mh_copyFld('osoby_oW', 'osobyW',, .t.)

    * pøecházíme do opravy
    ::lnewRec := .f.
    ::refresh( drgVar )

    for x := 1 to len(pa) step 1
      drgvar := ::dm:has('osobyW->' +pa[x])

      drgVar:odrg:isEdit := .f.
      drgVar:odrg:oXbp:disable()
    next
    ::df:setNextFocus( 'osobyW->ctitulPred',, .T. )
  endif
return ok


* TAB  2 - rodinní pøíslušníci
method PER_osoby_crd:per_osoby_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgvar   := ::dm:has('vazOsobyW->ncisOsoby')
  local  cisOsoby := drgVar:odrg:ovar:value
  local  pa       := ::pa_vazRecs[1]
  *
  * ochráníme si osoby
  local  filtr    := osoby->(ads_getAof())
  fordRec( { 'osoby' } )

  if .not. empty( pa )
    osoby->( ads_setAof('.T.'))
    osoby->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., osoby->( dbseek(cisOsoby,,'OSOBY01')))

  if .not. ok
    ::start_SEL_inThread('PER_osoby_SEL,1')

    ok := ( drgvar:changed() .and. .not. empty(drgvar:oDrg:cargoGet))
    if( ok, osoby->( ads_clearAof(), dbCommit(), dbskip(0), dbseek(drgvar:oDrg:cargoGet,,'ID')), nil )
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::valSel := isNull( osoby->sID, 0)

    osoby_Rp->(dbseek( osoby->ncisOsoby,,'OSOBY01'))
    ::refreshGroup('osoby_Rp', drgVar)

    ::dm:set( "vazOsobyW->ncisOsoby" , osoby_Rp->ncisOsoby )
    ::dm:set( "vazOsobyW->ddatNaroz" , osoby_Rp->ddatNaroz )
    ::dm:set( "vazOsobyW->crodcisOsb", osoby_Rp->crodcisOsb)
  endif

  * obnovíme si osoby
  osoby->(ads_clearAof(), ads_setAof(filtr) )
  fordRec()

  setAppFocus( drgVar:odrg:oxbp )
RETURN (nexit = drgEVENT_SELECT .or. ok)


* TAB 6 - lékaøské prohlídky
method PER_osoby_crd:per_lekprohl_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgvar    := ::dm:has('vazLekprW->cZkratka')
  local  zkratkaLp := drgVar:odrg:ovar:value
  local  pa        := ::pa_vazRecs[2]

  if .not. empty( pa )
    lekProhl->( ads_setAof('.T.'))
    lekProhl->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., lekProhl->( dbseek(zkratkaLp,,'LEKPROHL06')))

  if .not. ok
    DRGDIALOG FORM 'PER_lekprohl_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::refreshGroup('vazLekprW,lekProhl', drgVar)

    ::valSel := isNull( lekProhl->sID, 0)
    ::dm:set( "vazLekprW->czkratka", lekProhl->czkratka)
  endif

  lekProhl->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


* TAB 7 - školení/ kurzy
method PER_osoby_crd:per_skoleni_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  drgvar    := ::dm:has('vazSkolW->cZkratka')
  local  zkratkaSk := drgVar:odrg:ovar:value
  local  pa        := ::pa_vazRecs[3]

  if .not. empty( pa )
    skoleni->( ads_setAof('.T.'))
    skoleni->( ads_customizeAOF( pa, 3))
  endif

  ok := if( isobject(drgDialog), .f., skoleni->( dbseek(zkratkaSk,,'SKOLENI07')))

  if .not. ok
    DRGDIALOG FORM 'PER_skoleni_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::refreshGroup('vazSkolW,skoleni', drgVar)

    ::valSel := isNull( skoleni->sID, 0)
    ::dm:set( "vazSkolW->czkratka", skoleni->czkratka)
  endif

  skoleni->(ads_clearAof())
RETURN (nexit = drgEVENT_SELECT .or. ok)


method PER_osoby_crd:editParent()
  local  oDialog, nExit
  *
  local  pa := {{ ''                , ''                               } , ;
                { 'OSB_OSOBY_CRD'   , 'vazOsobyW,osoby_Rp', 'osoby_Rp' } , ;
                { ''                , ''                               } , ;
                { ''                , ''                               } , ;
                { ''                , ''                               } , ;
                { 'PER_lekprohl_CRD', 'vazLekprW,lekProhl', 'lekProhl' } , ;
                { 'PER_skoleni_CRD' , 'vazSkolW,skoleni'  , 'skoleni'  }   }

  local  cformName := pa[::tabNum,1]
  local  cfileMain := pa[::tabNum,3]
  *
  ::start_SEL_inThread( cformName +',' +str((cfileMain)->(recNo())) )

  * refrešneme zmìny, moc nás nezajímá jestli nìjaké udìlal
  (cfileMain)->(dbcommit(), dbskip(0))
  ::setFocus_onTab( .t. )
  ::refreshGroup( pa[::tabNum,2] )
return self


method PER_osoby_crd:postSave()
  local  ok  := .t.
  local  x, y, cfile_M, paLock, paObj, cfile_W, paVaz, isEmpty, val, nIn
  local  lnew_osobySk
  local  paF := { { 'osoby'    , {}, nil                , 0, .f. }, ;
                  { 'vazOsoby' , {}, nil                , 1, .f. }, ;
                  { 'duchody'  , {}, nil                , 0, .t. }, ;
                  { 'prSmlDoh' , {}, nil                , 0, .t. }, ;
                  { 'vzdelani' , {}, nil                , 0, .t. }, ;
                  { 'vazLekpr' , {}, nil                , 2, .f. }, ;
                  { 'vazSkol'  , {}, nil                , 2, .f. }, ;
                  { 'osoby_Rp' , {}, nil                , 0, .f. }  }

  local  sname    := drgINI:dir_USERfitm +'mmacro', fields
  local  lenBuff  := 40960, buffer := space(lenBuff)
  local  b_mblock := { || .t. }

  * možná je potøeba ho založit do msPrc_mo
  if asystem->( dbseek( 'PER_OSOBY_CRD',, 'ASYSTEM01'))
    memoWrit( sname, asystem->mMacro )
    *
    * naèetem ze sekce UsedIdentifiers Fields *
    GetPrivateProfileSectionA('macro', @buffer, lenBuff, sname)
    fields := substr(buffer,1,len(trim(buffer))-1)
    fields := strtran(fields,chr(0),',')
    fields := substr(fields,1,len(fields) -1)

    b_mblock  := COMPILE( fields  )

    ferase(sname)
    buffer := ''
  endif

  * holt ovìøíme ncisOsoby
  if ::lnewRec
    fordRec( { 'osoby_oW,1' } )
    osoby_oW  ->( DbGoBottom())
    osobyW ->ncisOsoby := osoby_oW->ncisOsoby +1
    fordRec()
  endif

  * slepenci ve slivenci
  OSB_glueItems()

  * mno vazOsobyW ovlivní osoby_Rp, tak si je kopnem a modifikujem
  * pak je to stejné
  vazOsobyW->( dbgoTop())
  do while .not. vazOsobyW->(eof())
    if osoby_Rp->( dbseek( vazOsobyW->nOSOBY   ,, 'ID' ))
      *
      ** nemá cenu modifikovat parenta, pokud nic nezmìnil
      if vazOsobyW->ddatNaroz  <> osoby_Rp->ddatNaroz .or. ;
         vazOsobyW->crodCisOsb <> osoby_Rp->crodCisOsb

        mh_copyFld( 'osoby_Rp', 'osoby_RpW', .t., .t. )

        * tož tohle je na vazbì ale i na základní tøídì
        osoby_RpW->ddatNaroz  := vazOsobyW->ddatNaroz
        osoby_RpW->crodCisOsb := vazOsobyW->crodCisOsb
      endif
    endif
    vazOsobyW->(dbskip())
  enddo

  * zámky
  for x := 1 to len(paF) step 1
    cfile_M := paF[x,1]
    cfile_W := cfile_M +'w'
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

  * ukládáme
  if ok
    for x := 1 to len(paF) step 1
      cfile_M         := paF[x,1]
      cfile_W         := cfile_M +'w'
      paLock          := paF[x,2]
      paVaz           := paF[x,4]
      modify_cisOsoby := paF[x,5]
      lnew_osobySk    := .f.

      (cfile_W)->(dbgoTop())

      do while .not. (cfile_W)->(eof())
        if (cfile_W)->_delrec <> '9'

          if((nrecor := (cfile_W)->_nrecor) = 0, nil, (cfile_M)->(dbgoto(nrecor)))
          if   (cfile_W)->_delrec = '9'  ;  (cfile_M)->(dbdelete())
          else
            if( paVaz = 1, (cfile_W)->OSOBY  := isNull( osoby->sID, 0), nil )
            if( paVaz = 2, (cfile_W)->nOSOBY := isNull( osoby->sID, 0), nil )

            if cfile_M = 'osoby' .and. osobyW->nis_PER = 0
              osobyW->nis_PER := 1
              lnew_osobySk    := .t.
            endif

            if modify_cisOsoby .and. (cfile_W)->(fieldPos('ncisOsoby')) <> 0
              (cfile_W)->ncisOsoby := osoby->ncisOsoby
            endif

            mh_copyFld(cfile_W, cfile_M, ((cfile_W)->_nrecor = 0))

            if lnew_osobySk
              osobySk->(dbappend(),Rlock())
              osobySk->ncisOsoby := osoby->ncisOsoby
              osobySk->czkr_skup := 'PER'
              osobySk->(dbUnlock(), dbcommit())
            endif
            *
            ** je potøeba založit nový PPV do msPrc_mo ?
            if lower(cfile_m) = 'prsmldoh' .and. ((cfile_W)->_nrecor = 0)
              * jo
              mh_copyFld( 'prsmldoh', 'msPrc_mo', .t. )
              eval( b_mblock )
            endif

            if(nIn := AScan(paLock, nrecor)) <> 0
              (adel(paLock,nIn), asize(paLock, len(paLock) -1))
            endif
          endif
        endif

        (cfile_W)->(dbSkip())
      enddo

      AEval(paLock, {|recs| (cfile_M)->(dbgoTo(recs), dbDelete()) })
    next
  else
    drgMsgBox(drgNLS:msg('Nelze modifikovat OSOBY-personalistika, blokováno uživatelem !!!'))
  endif

  AEval( paF, { |x| (x[1])->(dbUnlock(),dbCommit()) })
return ok