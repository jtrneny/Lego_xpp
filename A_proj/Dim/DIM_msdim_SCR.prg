#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "Gra.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

Static   allRecs


Function POCkusDIM() ; RETURN(If(MSDIM ->nPOCkusDIM <> 0, 172, 173))


*
** CLASS for FRM DIM_msdim_SCR *************************************************
CLASS DIM_msdim_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  METHOD  init, tabSelect, itemMarked
  METHOD  Cards_ZMENYDIM


  // Náøadí - zatím jen EL
  inline access assign method msDim_naradi() var msDim_naradi
    return if( elNarDIm->( dbseek( msDim->ninvCISdim,, 'DIM1' )), 535, 0 )


  // 555 - žlutá, 556 - zelená, 558 - èervená
  inline access assign method msDim_state() var msDim_state
    local  retVal := 0

    if( msDim->npocKusDIm > 0         , retVal := 556, nil )
    if( .not. empty(msDim->ddatVyrDIm), retVal := 558, nil )
    return retVal

  inline access assign method nazSkMis var nazSkMis
    c_skumis->( dbseek( upper( msdim->cklicSkMis),,'C_1'))
    return c_skumis->cnazSkMis

  inline access assign method nazOdpMis var nazOdpMis
    c_odpmis->( dbseek( upper( msdim->cklicOdMis),,'C_1'))
    return c_odpmis->cnazOdpMis


  inline method drgDialogStart(drgDialog)
    local  members  := drgDialog:oActionBar:members, x
    local  pa_quick := { { 'Kompletní seznam       ', ''                      }, ;
                         { 'Aktivní položky        ', 'npocKusDIm <> 0'       }, ;
                         { 'Neaktivní položky      ', 'npocKusDIm  = 0'       }, ;
                         { 'Vyøazené položky       ', 'not empty(ddatVyrDIm)' }  }

    ::d_brow  := drgDialog:odbrowse[1]
    ::is_Foot := .t.
    ::oBrowse := drgDialog:dialogCtrl:oBrowse


    for x := 1 to len(members) step 1
      do case
      case members[x]:ClassName() = 'drgPushButton'
        if isCharacter( members[x]:event )
          if( lower(members[x]:event) = 'cards_zmenydim', ::oBtn_cards_zmenyDim := members[x], nil )
        endif
      endcase
    next
    *
    c_skuMis->( dbeval( { || aadd( pa_quick, { c_skuMis->cnazSkMis +'( ' +allTrim(c_skuMis->cklicSkMis) +')', ;
                                               'cklicSkMis = "' +c_skuMis->cklicSkMis +'"'                    } ) }, ;
                        { || .not. empty(c_skuMis->cklicSkMis)                                                    }  ) )

    ::quickFiltrs:init( self, pa_quick, 'msDim' )
  return self


  inline method drgDialogEnd(drgDialog)
    zmenyDim->( ads_clearAof())
    return self


  inline method test_Foot()
    local  x, ocolumn
    local  colCount := ::d_brow:oxbp:colCount

    for x := 1 to colCount step 1
      oColumn := ::d_brow:oxbp:getColumn(x)

      oColumn:lockUpdate(.t.)
      oColumn:FooterLayout[XBPCOL_HFA_HEIGHT] := if( ::is_Foot, 0, drgINI:fontH -2)
      oColumn:configure()
      oColumn:lockUpdate(.f.)
    next

*    if ::is_Foot
      ::d_brow:oxbp:lockUpdate(.t.)
      ::d_brow:oxbp:configure()
      ::d_brow:oXbp:refreshAll()

      ::d_brow:oxbp:lockUpdate(.f.)
*    endif
    ::is_Foot := .not. ::is_Foot
  return self

HIDDEN:
  var  d_brow, is_Foot, oBtn_cards_zmenyDim
  var  tabNum, m_filtr, oBrowse
ENDCLASS


method DIM_msdim_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::tabNum  := 1
  ::m_filtr := "ninvCISdim = %% and cklicSKmis = '%%' and cklicODmis = '%%' and npoh_Dim "

  drgDBMS:open('MSDIM'   )
  drgDBMS:open('ELNARDIM')
  drgDBMS:open('ZMENYDIM')
  drgDBMS:open('C_TYPHOD')
  drgDBMS:open('ucetsys' )

  drgDBMS:open('C_SKUMIS')
  drgDBMS:open('C_ODPMIS')

  MSDIM    ->( DbSetRelation('ELNARDIM', { || MSDIM ->NINVCISDIM }))
  ELNARDIM ->( DbSetRelation('C_TYPHOD', { || UPPER(ELNARDIM->CCELKHODNO) }))
return self


method dim_msdim_scr:tabSelect(otabPage, tabNum )
  local  tabBrowse := val(otabPage:tabBrowse)

  ::tabNum := tabNum
  ::itemMarked()

  if( tabBrowse <> 0, ::oBrowse[tabBrowse]:oxbp:refreshAll(), nil )
RETURN .T.


method dim_msdim_scr:itemMarked()
  local  m_filtr := ::m_filtr +if( ::tabNum = 6, " = 0" , " <> 0" )
  local  filter

  elNarDIm->( dbseek( msDim->ninvCISdim,, 'DIM1' ))

  filter := format( m_filtr, { msDim->ninvCISdim, msDim->cklicSKmis, msDim->cklicODmis } )
  zmenyDim->( ads_setAof(filter), dbgoTop() )

  if isObject(::oBtn_cards_zmenyDim)
    if( msDim->npocKUSDim > 0, ::oBtn_cards_zmenyDim:enable(), ::oBtn_cards_zmenyDim:disable() )
  endif
return self


METHOD dim_msdim_scr:Cards_ZMENYDIM()
  Local  nRECs  := MSDIM ->(RECNO())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'DIM_zmenydim_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  MSDIM ->(DBGoTo(nRECs))

  ::drgDialog:dialogCtrl:refreshPostDel()
Return self


*
********* CLASS for FRM DIM_msdim_CRD ******************************************
CLASS DIM_msdim_CRD FROM drgUsrClass, FIN_finance_in
EXPORTED:
  method  init, drgDialogStart
  METHOD  preValidate, postValidate, onSave

  ** propojka na SKL_msDim_pk_SEL
  var     from_skl_msDim_pk_sel

HIDDEN:
  var     dm, df, oDialog, msg, prev_brow
  var     lnewREC, newInvDim

  inline method new_invCisDim()
    local newInvDim, cky

    do case
    case ( ::newInvDim = 0 ) ; newInvDim := 0

    case ( ::newInvDim = 1 )
      msdim_v->( ordSetFocus( 'DIM1' ), dbgoBottom())
      newInvDim := msdim_v->ninvCisDim +1

    case ( ::newInvDim = 2 )
      cky := strZero( ::dm:get('msdim->ntypDim'), 3)
      msdim_v->( ordSetFocus( 'DIM3' )       , ;
                 dbSetScope( SCOPE_BOTH, cky), ;
                 dbgoBottom()                  )

      newInvDim := msdim_v->ninvCisDim +1

      msdim_v->(dbclearScope())
    endcase
  return newInvDim

ENDCLASS


/*
0 - nepøednastavuje  ninvCisDim
1 -   pøednasatvuje  last.ninvCisDIm +1 tag DIM1 / ninvCisDim
2 -   pøednastavuje  last.ninvCisDIm +1 tag DIM3 / ntypDim +ninvCisDim
*/


method dim_msdim_crd:init(parent)
  ::drgUsrClass:init(parent)

  ::lnewREC   := .not. (parent:cargo = drgEVENT_EDIT)
  ::prev_brow := parent:parent:dialogCtrl:oBrowse[1]:oxbp

  ::newInvDim := sysConfig('DIM:nNewInvDim')
  if( isArray( ::newInvDim ), ::newInvDim := 1, nil )

   * pro kontrolu
  drgDBMS:open('msdim',,,,,'msdim_v')
return self


method dim_msdim_crd:drgDialogStart(drgDialog)

  ::oDialog := drgDialog
  ::dm      := ::drgDialog:dataManager
  ::df      := drgDialog:oForm                   // form
  ::msg     := drgDialog:oMessageBar             // messageBar

  if ::lnewREC
    ::dm:refreshAndSetEmpty( 'msdim' )
    ::dm:set( 'msdim->ninvCisDim', ::new_invCisDim())
  endif
  *
  ** propojka na SKL_msDim_pk_SEL
  ** dialog se spouští v metodì skl_msDim_pk_editNew - quickShow
  if( ::from_skl_msDim_pk_sel := ( drgDialog:parent:formName = 'skl_msDim_pk_sel' ))
  endif
return if( drgDialog:parent:formName = 'skl_msDim_pk_sel', .f., self )



METHOD DIM_msdim_CRD:preValidate(oVar)           // pøednastavení pøi INS
  Local  dm   := ::drgDialog:dataManager

  IF( dm:drgDialog:cargo = drgEVENT_EDIT, ;
                           NIL          , ;
                           MSDIM ->( AdsGotoRecord( 0 )) )
RETURN .T.


METHOD DIM_msdim_CRD:postValidate(drgVar)        // kotroly a výpoèty
  Local  dm    := ::drgDialog:dataManager
  Local  name  := upper( drgVAR:name )
  lOCAL  value := drgVar:get()
  local  ok    := .T., changed := drgVAR:changed()


  DO CASE
  case( 'NTYPDIM'    $ name )
    if( changed .and. ( ::newInvDim = 2 ))
      ::dm:set( 'msdim->ninvCisDim', ::new_invCisDim())
    endif

  case( 'NINVCISDIM' $ name )
   if     Empty(value)
      fin_info_box('Invenární èíslo DIm je povinný údaj ...', XBPMB_CRITICAL)
      ok := .F.
    elseif msdim_v ->( dbSeek(value,, 'DIM1') )
      fin_info_box('Promiòte prosím, ;Vámi zadané invenární èíslo DIm již existuje ...' )
    endif

  CASE( 'NPOCKUSDIM' $ name ) .or. ('NCENJEDDIM' $ name )
    dm:set('MSDIM->NCENCELDIM', dm:get('MSDIM->NPOCKUSDIM') * dm:get('MSDIM->NCENJEDDIM'))
  ENDCASE
RETURN ok


method dim_msdim_crd:onSave(lOk,isAppend,oDialog)                               // ukládání více záznamù 1:1
  Local  lLOCKs
  Local  lupdRECe := .F.
  Local  drgVar   := ::dm:vars:values

  AEval(drgVar, ;
    {|X| If( ISOBJECT(X[2]) .and. ('elnardim' $ X[1]), IF( X[2]:changed(), lupdRECe := .T., NIL), NIL ) } )

  lLOCKs := If( isAppend, ADDrec('MSDIM'), REPLrec('MSDIM'))
  If lupdRECe
    lLOCKs := lLOCKs .and. If( EMPTY(ELNARDIM ->NINVCISDIM), ADDrec('ELNARDIM'), REPLrec('ELNARDIM'))
  EndIf


  IF lLOCKs
    ZMENYDIM(::oDialog,IF(isAppend,1,2))

    ::oDialog:dataManager:save()

    If( lupdRECe, mh_COPYFLD( 'MSDIM', 'ELNARDIM',, .f.), NIL )

    MSDIM    ->(dbUnlock(), dbcommit())
    ELNARDIM ->(dbUnlock(), dbcommit())

*    oXbp := ::oDialog:parent:dialogCtrl:oaBrowse:oXbp
*    PostAppEvent(xbeP_Close,,,::drgDialog:dialog)

    if ::lnewREC .and. .not. ::from_skl_msDim_pk_sel

      setAppFocus(::prev_brow)

      ::dm:refreshAndSetEmpty( 'msdim' )
      ::dm:set( 'msdim->ninvCisDim', ::new_invCisDim() )

      ::df:setnextfocus('msdim->cklicSkMis',,.t.)
    else
      PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
    endif

  ENDIF
RETURN .t.


*
******** CLASS for FRM DIM_zmenydim_SCR ****************************************
CLASS DIM_zmenydim_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Cards_ZMENYDIM

  inline method init(parent)
    ::drgUsrClass:init(parent)

    ::tabNum      := 1
    ::m_filtr     := ::m_filtr := "ninvCISdim = %% and cklicSKmis = '%%' and cklicODmis = '%%'"
    ::onTab_filtr := ::m_filtr +" and lpoh_dim"
  return self

  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oActionBar:members, x

    ::odBro_msDim    := ::drgDialog:dialogCtrl:oBrowse[1]
    ::odBro_zmenyDim := ::drgDialog:dialogCtrl:oBrowse[2]

    for x := 1 to len(members) step 1
      do case
      case members[x]:ClassName() = 'drgPushButton'
        if isCharacter( members[x]:event )
          if( lower(members[x]:event) = 'cards_zmenydim', ::oBtn_cards_zmenyDim := members[x], nil )
        endif
      endcase
    next
  return self


  inline method drgDialogEnd(drgDialog)
    zmenyDim->( ads_clearAof())
  return self


  inline method itemMarked()
    local  filter

    filter := format( ::onTab_filtr, { msDim->ninvCISdim, msDim->cklicSKmis, msDim->cklicODmis } )
    zmenyDim->( ads_setAof(filter), dbgoTop() )

    if isObject(::oBtn_cards_zmenyDim)
      if( msDim->npocKUSDim > 0, ::oBtn_cards_zmenyDim:enable(), ::oBtn_cards_zmenyDim:disable() )
    endif
  return self


  inline method tabSelect( tabPage )

    if ::tabNum <> tabPage:tabNumber
      ::tabNum := tabPage:tabNumber

      do case
      case ::tabNum = 1  ; ::onTab_filtr := ::m_filtr +" and lpoh_dim"
      case ::tabNum = 2  ; ::onTab_filtr := ::m_filtr +" and (npoh_dim = 10 or npoh_dim = 40)"
      case ::tabNum = 3  ; ::onTab_filtr := ::m_filtr +" and npoh_dim = 0"
      case ::tabNum = 4  ; ::onTab_filtr := ::m_filtr +" and npoh_dim = 80"
      case ::tabNum = 5  ; ::onTab_filtr := ::m_filtr +" and npoh_dim = 53"
      endcase
    endif

    PostAppEvent(xbeBRW_ItemMarked,,,::odBro_msDim:oxbp)
  return .t.

HIDDEN:
  var  tabNum
  var  m_filtr, onTab_filtr
  var  odBro_msDim, odBro_zmenyDim, oBtn_cards_zmenyDim
ENDCLASS


METHOD DIM_zmenydim_SCR:Cards_ZMENYDIM()
  Local  nRECs  := MSDIM ->(RECNO())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'DIM_zmenydim_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  MSDIM ->(DBGoTo(nRECs))

  ::drgDialog:dialogCtrl:refreshPostDel()
Return self


*
******** CLASS for FRM DIM_zmenyDim_dleDok_SCR *********************************
CLASS DIM_zmenyDim_dleDok_SCR FROM drgUsrClass
EXPORTED:

  inline method init(parent)
    ::drgUsrClass:init(parent)

*    ::tabNum      := 1
*    ::m_filtr     := "ninvCISdim = %%"
*    ::onTab_filtr := ::m_filtr +" and lpoh_dim"
  return self

  inline method drgDialogStart(drgDialog)

*    ::odBro_msDim    := ::drgDialog:dialogCtrl:oBrowse[1]
*    ::odBro_zmenyDim := ::drgDialog:dialogCtrl:oBrowse[2]
  return self

  inline method itemMarked()
    msDim->( dbseek( zmenyDim->ninvCISdim,, 'DIM1' ))
  return self
ENDCLASS


*
******** CLASS for FRM DIM_zmenydim_CRD ****************************************
CLASS DIM_zmenydim_CRD FROM drgUsrClass
EXPORTED:
  VAR    klicSkMis, klicOdMis, invCisDim, pocKusDim

  METHOD init, drgDialogStart, drgDialogEnd, postValidate, tabSelect
  method zmenydim_sel
  METHOD BUTT_saveall, BUTT_save

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  ok := .f.
    local  pa := { ::o_klicSkMis:ovar:value, ::o_klicOdMis:ovar:value, ;
                   ::o_invCISdim:ovar:value, ::o_pocKUSdim:ovar:value  }

    do case
    case ::tabNum = 1
      ok := if( empty(pa[1]) .or. empty(pa[2]) .or. pa[4] = 0, .f., .t. )

    case ::tabNum = 2
      ok := if( empty(pa[1]) .or. empty(pa[2]) .or. empty(pa[3]) .or. pa[4] = 0, .f., .t. )

    case ::tabNum = 3
      ok := if( pa[4] = 0, .f., .t. )

    endcase

    if( ok, (::btn_saveAll:oxbp:enable() , ::btn_save:oxbp:enable()  ), ;
            (::btn_saveAll:oxbp:disable(), ::btn_save:oxbp:disable() )  )
  return .f.


HIDDEN:
  var    tabNum, on_tabSelect, msg, dm, dc, df, brow, m_bro, arSelect
  var    o_klicSkMis, o_klicOdMis, o_invCisDim, o_pocKusDim
  var    btn_saveAll, btn_save

  method zmenyDim_save
ENDCLASS


METHOD DIM_zmenydim_CRD:Init(parent)
  LOCAL arSelect := parent:parent:dialogCtrl:oBrowse[1]:arSELECT

  ::drgUsrClass:init(parent)
  ::arSelect     := arSelect
  ::tabNum       := 1
  ::m_bro        := parent:parent:dialogCtrl:oBrowse[1]
  ::on_tabSelect := {nil, nil, nil}

  ::klicSkMis := ''
  ::klicOdMis := ''
  ::invCisDim := 0
  ::pocKusDim := 0

  drgDBMS:open('c_skumis')  ;  c_skumis->(AdsSetOrder(1))
  drgDBMS:open('c_odpmis')  ;  c_odpmis->(AdsSetOrder(1))
  drgDBMS:open('ucetsys' )

  // TMP soubory //
  drgDBMS:open('MSDIMw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF Empty(arSelect)
    mh_COPYFLD('MSDIM', 'MSDIMw', .T., .t., allRecs)
  ELSE
    AEval( arSelect, {|X| MSDIM ->(DbGoto(X),mh_COPYFLD('MSDIM', 'MSDIMw', .T., .t.,allRecs)) })
  ENDIF
RETURN self


METHOD DIM_zmenydim_CRD:drgDialogStart(drgDialog)
  local x
  local members := drgDialog:oForm:aMembers
  *
  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

  for x := 1 to LEN(members) step 1
    do case
    case lower(members[x]:ClassName()) $ 'drgdbrowse'
      ::brow := members[x]:oXbp
*-      ::df:nextFocus := x

    case members[x]:ClassName() = 'drgPushButton' .and. ISCHARACTER(members[x]:event)
      do case
      case ('BUTT_saveall' $ members[x]:event)
        if .not. (len(::arSelect) > 1)
          members[x]:oXbp:hide()
          members[x]:isEdit := .f.
        endif
        ::btn_saveAll := members[x]
      case( 'BUTT_save'    $ members[x]:event)
        ::btn_save    := members[x]
      endcase

    case members[x]:className() = 'drgGet' .and. .not. empty(members[x]:groups)
      if members[x]:groups = '1,3'
        ::on_tabSelect[1] := {members[x],x}
        ::on_TabSelect[3] := {members[x],x}
      else
        ::on_TabSelect[2] := {members[x],x}
      endif

    endcase
  next

  ::o_klicSkMis := ::dm:has('m->klicSkMis'):odrg
  ::o_klicOdMis := ::dm:has('m->klicOdMis'):odrg
  ::o_invCISdim := ::dm:has('m->invCisDim'):odrg
  ::o_pocKUSdim := ::dm:has('m->pocKusDim'):odrg

  ::o_invCisDim:isEdit := .f.
  ::o_invCisDim:oxbp:disable()
return self


method dim_zmenydim_crd:tabSelect(oTabPage,tabnum)
  local pa      := ::on_tabSelect[tabnum]
  local pa_save := { '~Pøevod', '~Výdej', '~Vyøazení' }

  do case
  case(tabNum = 1)      // pøevod
    (::o_klicSkMis:isEdit := .t., ::o_klicSkMis:oxbp:enable() )
    (::o_klicOdMis:isEdit := .t., ::o_klicOdMis:oxbp:enable() )
    (::o_invCisDim:isEdit := .f., ::o_invCisDim:oxbp:disable())

  case(tabNum = 2)      // výdej
    (::o_klicSkMis:isEdit := .t., ::o_klicSkMis:oxbp:enable() )
    (::o_klicOdMis:isEdit := .t., ::o_klicOdMis:oxbp:enable() )
    (::o_invCisDim:isEdit := .t., ::o_invCisDim:oxbp:enable() )


  case(tabNum = 3)      // vyøazení
    (::o_klicSkMis:isEdit := .f., ::o_klicSkMis:oxbp:disable())
    (::o_klicOdMis:isEdit := .f., ::o_klicOdMis:oxbp:disable())
    (::o_invCisDim:isEdit := .f., ::o_invCisDim:oxbp:disable())

  endcas

  ::tabNum := tabNum
  ::o_klicSkMis:ovar:set('')
  ::o_klicOdMis:ovar:set('')
  ::o_invCisDim:ovar:set(0 )
  ::o_pocKusDim:ovar:set(0 )
  *
  ::btn_saveAll:oxbp:setCaption(space(8) +pa_save[tabNum] +' všech položek')
  ::btn_save:oxbp:setCaption(pa_save[tabNum])
  *
  ::df:setNextFocus( 'M->KLICskmis',, .t. )
*  ::df:olastdrg   := pa[1]
*  ::df:nlastdrgix := pa[2]
*  ::df:olastdrg:setFocus()
return (oTabPage:tabNumber = tabNum)


METHOD DIM_zmenydim_CRD:postValidate(drgVar)        // kotroly a výpoèty
  local  ok     := .t., is_Err := .f.
  local  name   := lower(drgVar:name), v_name
  local  value  := drgVar:get()
  local  it_sel := 'm->klicskmis, m->klicodmis, m->invcisdim, m->pockusdim', cKy, recNo, nsel
  local  ctitle := if( ::tabNum = 1, 'Pøevod ', 'Výdej ') +'položky DIMu ...'
  local  cinfo  := 'Promiòte prosím,'                 +CRLF + ;
                   'požadujete ' +if( ::tabNum = 1, 'PØEVÉST', 'VYDAT') +' položku DIMu ' +CRLF + CRLF
  *
  local  o_drgVar := drgVar

  do case
  case(name = 'm->klicskmis')
    ok := if( .not. empty(value) .or. ::tabNum = 2, ::zmenydim_sel( ,o_drgVar), .t.)

  case(name = 'm->klicodmis')
    ok := if( .not. empty(value) .or. ::tabNum = 2, ::zmenydim_sel( ,o_drgVar), .t.)

  case(name = 'm->invcisdim')
    do case
    case empty(value)
      fin_info_box('Invenární èíslo DIMu je povinný údaj ...', XBPMB_CRITICAL)
      ok := .f.

    case (::o_klicSkMis:ovar:value = msdimw->cklicSkMis .and. ;
          ::o_klicOdMis:ovar:value = msdimw->cklicOdmis .and. ;
          if( ::tabNum = 1, .t., ::o_invCisDim:ovar:value = msDimw->ninvCisDim )  )

      is_Err := .t.
      ok     := .f.
    endcase

*    ok := ::o_klicSkMis:ovar:value <> msdimw->cklicSkMis .and. ;
*          ::o_klicOdMis:ovar:value <> msdimw->cklicOdmis .and. .not. empty(value)

    if ok
      cKy := upper(padr(::o_klicSkMis:ovar:value,8)) + ;
             upper(padr(::o_klicOdMis:ovar:value,8)) +strZero(value,6)

      if msdim->(dbSeek(cKy,,'DIM11'))

        cinfo += msdimw->cklicSkMis               +'/ ' +msdimw->cklicOdmis                 +'/ ' +str(msdimw->ninvCisDim,6) +' _ ' +msdimW->cnazevDIM + CRLF
        cinfo += ' na '                                                                                                                                + CRLF
        cinfo += padR(::o_klicSkMis:ovar:value,8) +'/ ' +padR(+::o_klicOdMis:ovar:value,8)  +'/ ' +str(value,6)              +' _ ' +msdim->cnazevDIM

        nsel := confirmBox( , cInfo         , ;
                              ctitle        , ;
                              XBPMB_YESNO   , ;
                              XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

        ok := if( nsel = XBPMB_RET_YES, .t., .f. )
      endif
    endif

  case(name = 'm->pockusdim')
    ok := (msdimw->npocKusDim >= value)

  endcase

  *
  ** obecná kontrola
  if ok .or. is_Err
    if (::o_klicSkMis:ovar:value = msdimw->cklicSkMis .and. ;
        ::o_klicOdMis:ovar:value = msdimw->cklicOdmis .and. ;
        if( ::tabNum = 1, .t., ::o_invCisDim:ovar:value = msDimw->ninvCisDim )  )

      cinfo += '  !!! NA STEJNOU POLOŽKU !!! '
      confirmBox( , cinfo        , ;
                    ctitle       , ;
                    XBPMB_CANCEL , ;
                    XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

      ::o_klicSkMis:ovar:set('')
      ::df:setNextFocus( 'M->KLICskmis',, .t. )
      ok := .f.
    endif
  endif
RETURN ok


method DIM_zmenydim_CRD:zmenydim_sel(drgDialog,o_drgVar)
  local  odialog, nexit := drgEVENT_QUIT
  local  rFile, rOrd := 1, rArea
  *
  local  drgVar := if( isObject( o_drgVar), o_drgVar, ::drgDialog:lastXbpInFocus:cargo:ovar)
  local  name   := lower(drgVar:name)
  local  value  := drgVar:get()
  local  ok

  rFile := if(name = 'm->klicskmis', 'c_skumis', 'c_odpmis')
  rArea := rFile

  ok    := (rFile)->(dbSeek(upper(value),, AdsCtag( rOrd )))

  if isObject(drgDialog) .or. .not. ok

    if isNull( classObject(rFile))
      odialog       := drgDialog():new('drgSearch', ::drgDialog)
      odialog:cargo := rFile + TAB + value + TAB +STR(rOrd) +TAB +rArea
    else
      odialog       := drgDialog():new( rFILE, ::drgDialog)
      odialog:cargo := value
    endif

    odialog:create(,,.T.)
    nexit := odialog:exitState

    if (nexit != drgEVENT_QUIT)
      ok := .t.
      ::dm:set(name, if(rFile = 'c_skumis', c_skumis->cklicSkMis, c_odpmis->cklicOdMis))
    endif

    odialog:destroy()
    odialog := NIL
  endif
return ok


method DIM_zmenydim_CRD:BUTT_saveall(drgDialog)
  local nsel

  caption := strTran( allTrim( ::btn_saveAll:oxbp:caption), '~', '' )

  nsel := ConfirmBox( ,'Promiòte prosím, opravdu požadujete ... ' +CRLF +   ;
                        alltrim( caption )                                , ;
                        allTrim( caption )                                , ;
                        XBPMB_YESNO                                       , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE      , ;
                        XBPMB_DEFBUTTON2                                    )

  if nsel = XBPMB_RET_NO
    return .t.
  endif

  msdimw->(dbgotop() )
  do while .not. msdimw->(eof())
    ::o_pocKusDim:ovar:value := msdimw->npocKusDim

    ::BUTT_save(drgDialog, .t.)
    msdimw->(dbskip())
  end

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return .T.


METHOD DIM_zmenydim_CRD:BUTT_save(drgDialog, inCykl)
  local  cKy, anDim := {}
  local  klicSkMis := padR( ::o_klicSkMis:ovar:value, 8)
  local  klicOdMis := padR( ::o_klicOdMis:ovar:value, 8)
  local  invCisDim := ::o_invCisDim:ovar:value

  default inCykl to .f.

  msdim ->(dbGoTo(msdimw->_nrecor))
  aadd(anDim, msDim->( recNo()) )

  * pøevod / výdej
  if ::tabNum = 1 .or. ::tabNum = 2
    cKy := upper( if( empty(klicSkMis)   , msDim ->cklicSkMis, klicSkMis) ) + ;
           upper( if( empty(klicOdMis)   , msDim ->cklicOdMis, klicOdMis) ) + ;
           strZero ( if( empty(invCisDim), msDim ->ninvCisDim, invCisDim), 6)

    if msDim->(dbSeek(cKy,,'DIM11'))
      aadd(anDim, msDim->( recNo()) )
    endif
  endif


  if msDim->(sx_rLock( anDim ))
     msdim ->(dbGoTo(msdimw->_nrecor))

    ::zmenyDim_save()

    if( ::tabNum = 2, msdim->ddatVyrDim := date(), nil )

    msdim->(dbunlock(),dbcommit())

    msdimw->npocKusDim -= ::o_pocKusDim:ovar:value
    msdimw->ncenCelDim := msdimw->ncenJedDim * msdimw->npocKusDim

    ::brow:panHome()
    ::brow:refreshAll()
    ::dm:refresh()

    if .not. inCykl
      if msdimw->npocKusDim = 0
        msdimw->_delrec := '9'
        if( ::brow:rowPos = 1, ::brow:gotop(), nil )
        ::brow:refreshAll()
      endif

      if msdimw->( eof())
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
      endif
    endif
  endif
RETURN .T.


METHOD DIM_zmenydim_CRD:zmenyDim_save()
  Local  cTABLe, axMSdim, cKy
  *
  local  klicSkMis := padR( ::o_klicSkMis:ovar:value, 8)
  local  klicOdMis := padR( ::o_klicOdMis:ovar:value, 8)
  local  invCisDim := ::o_invCisDim:ovar:value
  local  pocKusDim := ::o_pocKusDim:ovar:value

  cTABLe := if( empty(klicSkMis), '0', '1') + ;
             IF( EMPTY(klicOdMis), '0', '1') + ;
              IF( EMPTY(pocKusDim), '0', '1')

  If( cTABLe == '000', NIL, ZMENYDIM( self, If( left(cTABLe,2) == '00', 4, 3 ), .T. ))

  do case
  case( cTABLe == '000' )
  case( cTABLe == '100' )  ;  msdim->cklicSkMis := klicSkMis
  Case( cTABLe == '010' )  ;  msdim->cklicOdMis := klicOdMis
  Case( cTABLe == '110' )  ;  msdim->cklicSkMis := klicSkMis
                              msdim->cklicOdMis := klicOdMis
  Case( cTABLe == '001' )  ;  msdim->npocKusDim -= pocKusDim

  Case( cTABLe == '101' )  ;  msdim->npocKusDim -= pocKusDim
                              if msdim->cklicSkMis <> klicSkMis
                                axMSdim := recToArr('MSDIM')
                              EndIf

  Case( cTABLe == '011' )  ;  msdim->npocKusDim -= pocKusDim
                              If msdim->cklicOdMis <> klicOdMis
                                axMSdim := recToArr('MSDIM')
                              endif

  Case( cTABLe == '111' )  ;  msdim->npocKusDim -= pocKusDim
    If( msdim->cklicSkMis <> klicSkMis .or. msdim->cklicOdMis <> klicOdMis )
      axMSdim := recToArr('MSDIM')
    EndIf
  EndCase

  msdim->ncenCelDim := msdim->npocKusDim * msdim->ncenJedDim

  if isArray(axMSdim)
    cKy := upper( if( empty(klicSkMis), MSDIM ->cklicSkMis, klicSkMis) ) + ;
           upper( if( empty(klicOdMis), MSDIM ->cklicOdMis, klicOdMis) ) + ;
           strZero ( if( empty(invCisDim), MSDIM ->ninvCisDim, invCisDim), 6)

    if .not. msdim->(dbSeek(cKy,,'DIM11'))
      msdim->( dbAppend())
      arrToRec( axMSdim, 'msdim')

      ZMENYDIM( self, 1, .T. )
      msdim->npocKusDim := 0
      msdim->( dbCommit())
    else

      ZMENYDIM( self, 1, .T. )
    endif

    if( .not. empty(klicSkMis), msdim->cklicSkMis := klicSkMis, Nil )
    if( .not. empty(klicOdMis), msdim->cklicOdMis := klicOdMis, Nil )
    msdim->npocKusDim += pocKusDim
    msdim->ncenCelDim := msdim->npocKusDim * msdim->ncenJedDim

*    msdim->(dbUnlock(), dbCommit())
  EndIf
RETURN self


method dim_zmenydim_crd:drgDialogEnd(drgDialog)
  ::m_bro:arSelect := {}
return self


**
******** CLASS for FRM DIM_elnardim_SCR ****************************************
CLASS DIM_elnardim_SCR FROM drgUsrClass
EXPORTED:

  METHOD  init, itemMarked, elnardim_crd
ENDCLASS


METHOD DIM_elnardim_SCR:init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('MSDIM'   )
  drgDBMS:open('ELNARDIM')
  drgDBMS:open('ZMEELNAR')
  drgDBMS:open('C_ODPMIS')
  ELNARDIM ->( DbSetRelation( 'MSDIM'   , { || ELNARDIM ->nINVcisDIM },'ELNARDIM ->nINVcisDIM'))
  MSDIM    ->( DbSetRelation( 'C_ODPMIS', { || MSDIM    ->cKLICODMIS } ))
RETURN self


METHOD DIM_elnardim_SCR:itemMarked()
  Local  dc    := ::drgDialog:dialogCtrl

  ZMEELNAR ->( dbSetScope(SCOPE_BOTH, STRZERO(ELNARDIM ->nINVcisDIM,6)), DbGoTop())
RETURN SELF


method dim_elnardim_scr:elnardim_crd()
  Local  nRECs  := MSDIM ->(RECNO())
  Local  oDialog

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'dim_elnardim_crd' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  MSDIM ->(DBGoTo(nRECs))
Return self


**
******** CLASS for FRM DIM_zmeelnar_SCR ****************************************
CLASS DIM_zmeelnar_SCR FROM drgUsrClass
EXPORTED:

  inline access assign method nazevDim() var nazevDim
    local invCISdim := zmeElnar->ninvCISdim

    msDIM->( dbseek( invCISdim,,'DIM1'))
  return msDim->cnazevDim

  inline access assign method jmenoMaj() var jmenoMaj
    local invCISdim := zmeElnar->ninvCISdim

    msDIM->( dbseek( invCISdim,,'DIM1'))
    c_odpMis->( dbseek( upper(msDim->cklicODmis),, 'C_1'))
  return c_odpMis->cnazODPmis


  inline method init(parent)
    ::drgUsrClass:init(parent)

    drgDBMS:open('MSDIM'   )
    drgDBMS:open('ELNARDIM')
    drgDBMS:open('C_ODPMIS')
  return self


  inline method drgDialogStart(drgDialog)
    local  members := drgDialog:oForm:aMembers
    local  x, odrg, groups, name, tipText
    *
    local  acolors  := MIS_COLORS, pa_groups, nin

    ::dm         := drgDialog:dataManager             // dataManager
    ::df         := drgDialog:oForm                   // form

*    ::odBro      := ::drgDialog:odBrowse[1]
*    ::oxbp_Brow  := ::odBro:oxbp

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
    next
  return self

HIDDEN:
   var     dc, dm, df

ENDCLASS



Function ELNpockus()
  Local  nINVcisDIM := ELNARDIM ->nINVcisDIM
  Local  cPOCkusDIM := 172

  If nINVcisDIM <> 0
    MSDIM ->( dbSEEK( nINVcisDIM))

    Do While MSDIM ->nINVcisDIM == nINVcisDIM .and. MSDIM ->nPOCkusDIM == 0
      MSDIM ->( dbSKIP())
      cPOCkusDIM := If( MSDIM ->nPOCkusDIM <> 0, 172, 173 )
    EndDo
  EndIf
Return(cPOCkusDIM)


Function ELNmajitel()
  Local  nINVcisDIM := ELNARDIM ->nINVcisDIM
  Local  cNAZodpMIS := ''

  If nINVcisDIM <> 0
    MSDIM ->( DbSeek( nINVcisDIM,,'DIM1'))
    cNAZodpMIS := C_ODPMIS ->cNAZodpMIS

    Do While MSDIM ->nINVcisDIM == nINVcisDIM .and. MSDIM ->nPOCkusDIM == 0
      MSDIM ->( dbSKIP())
      cNAZodpMIS := C_ODPMIS ->cNAZodpMIS
    EndDo
  EndIf
Return( cNAZodpMIS)



//
Static Function RECTOarr(cAlias)
  Local  nFCount := ( cAlias) ->(fCount()), nField
  Local  axRecArr := {}

  For nField := 1 to nFCount
    aAdd( axRecArr, ( cAlias) ->( fieldGet( nField)))
  Next
Return( axRecArr)


Static Function ARRTOrec( aArray, cAlias )
  Local  nFCount := ( cAlias)->( FCount()), nField

  For nField := 1 To nFCount
    ( cAlias)-> ( FieldPut( nField, aArray[ nField] ))
  Next
Return( Nil)