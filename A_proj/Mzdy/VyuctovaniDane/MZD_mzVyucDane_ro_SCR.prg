#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


*
** CLASS MZD_mzVyucDane_ro_SCR **************************************************
CLASS MZD_mzVyucDane_ro_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart
  method  mzd_generuj_vypDan
  method  refresh, postDelete

  class   var mo_prac_filtr READONLY

  * browCOlumn
  * mzEldpHd
  inline access assign method is_Stavem() var is_Stavem
    local cky := strZero( vyucdane->noscisPrac, 5)

    msPrc_mo->( dbseek(cky,,'MSPRMO10', .t.))
    return if( msPrc_mo->lstavem, MIS_ICON_OK, 0 )

  inline access assign method is_datTisk()   var is_datTisk
    retur if( empty( vyucdane->ddatTisk), 0, 553)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    case nEvent = drgEVENT_DELETE .and. .not. vyucDane->(eof())
      ::postDelete()
      return .t.

    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

*       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROK = %%", {::rok})
       ::drgDialog:set_prg_filter( cfiltr, 'vyucdane', .t.)

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       msPrc_mo->( dbseek( vyucDane->nMSPRC_MO,,'ID'))

       ::dm:refresh()
       return .t.

    otherwise
      return .f.
    endcase
  return .f.


  inline method itemMarked()
    if( vyucDane->nMSPRC_MO <> 0, msPrc_mo->( dbseek( vyucDane->nMSPRC_MO,,'ID')), nil )
  return self


  inline  method  mzd_mzvyucdane_it_scr()
    local  oDialog, filter
    local  cf := "nrok = %% .and. noscisPrac = %%"

    filter := format( cf, { ::rok, vyucdane->noscisPrac } )

    vyucDani->( ads_setAof( filter), dbGoTop())
    DRGDIALOG FORM 'mzd_mzvyucdane_it_scr' PARENT ::drgDialog MODAL DESTROY

    vyucDani->( ads_clearAof())
  return self

hidden:
  var  msg, dm, brow, oDBro_main, rok, obdobi, xbp_therm
  var  cmain_Ky

ENDCLASS


METHOD MZD_mzVyucDane_ro_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
  drgDBMS:open( 'vyucdane' )
  drgDBMS:open( 'vyucdani' )

  ::mo_prac_filtr := ''
  ::cmain_Ky      := 'strZero(msPrc_mo->nrok,4) +strZero(msPrc_mo->nobdobi,2) + ' + ;
                     'strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)'

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI

  * programový filtr
  cfiltr := Format("nROK = %%", {::rok})
  ::drgDialog:set_prg_filter( cfiltr, 'vyucdane')
RETURN self


METHOD MZD_mzVyucDane_ro_SCR:drgDialogStart(drgDialog)
  local  nposIn, x, odrg
  local  ab      := drgDialog:oActionBar:members    // actionBar
  local  members := drgDialog:oForm:aMembers
  *
  ::msg          := drgDialog:oMessageBar             // messageBar
  ::dm           := drgDialog:dataManager             // dataManager
  ::brow         := drgDialog:dialogCtrl:oBrowse
  ::oDBro_main   := ::brow[1]
  ::xbp_therm    := drgDialog:oMessageBar:msgStatus

  for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case lower( odrg:className()) = 'drgtext'
*      odrg:oxbp:setFontCompoundName( FONT_DEFPROP_SMALL + FONT_STYLE_BOLD )
      odrg:oXbp:setColorFG(GRA_CLR_BLUE)

    case lower( odrg:className()) = 'drgget'
      odrg:isEdit := .f.

    case lower( odrg:className()) <> 'drgstatic'
    endcase
  next

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )

  if( nposIn := ascan( ab, { |s| s:event = 'mzd_importdokl_ml' } )) <> 0
    ::butt_importdokl_ml := ab[ nposIn ]
  endif
RETURN self


method MZD_mzVyucDane_ro_SCR:postDelete()
  local  cinfo  := '', nsel
  local  coscisPrac := '', x, pa_oscisPrac := {}
  *
  local  stmt_E := "delete from vyucDane where nrok = %yyyy"
  local  stmt_I := "delete from vyucDani where nrok = %yyyy"
  local  cStatement_E, cStatement_I, oStatement

  do case
  case ::oDBro_main:is_selAllRec
    cinfo := 'kompletnì_'

  case len( ::oDBro_main:arSelect) <> 0
    cinfo  := 'pro vybrané pracovníky_'

    fordRec( {'vyucDane'} )
    for x := 1 to len(::oDBro_main:arSelect) step 1
      vyucDane->( dbgoTo( ::oDBro_main:arSelect[x]))

      coscisPrac += strTran( str(vyucDane->noscisPrac), ' ', '') +','
    next
    fordRec()
    coscisPrac := left( coscisPrac, len( coscisPrac) -1)

    stmt_E     += " and noscisPrac IN(' +coscisPrac +')'"
    stmt_I     += " and noscisPrac IN(' +coscisPrac +')'"
  otherWise
    cinfo := 'pro ' +allTrim(vyucDane->cJmenoRozl) +'_'

    stmt_E     += " and noscisPrac = %pppp"
    stmt_I     += " and noscisPrac = %pppp"
  endcase

  cStatement_E := strTran( stmt_E      , '%yyyy', str(::rok,4) )
  cStatement_E := strTran( cStatement_E, '%pppp', str(vyucDane->noscisPrac) )

  cStatement_I := strTran( stmt_I      , '%yyyy', str(::rok,4) )
  cStatement_I := strTran( cStatement_I, '%pppp', str(vyucDane->noscisPrac) )


  nsel := ConfirmBox( ,'Požadujete zrušit roèní zùètování danì _' +cinfo             , ;
                       'Zrušení zùètování danì ...'                                  , ;
                        XBPMB_YESNO                                                  , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES

    * vyucDane
    oStatement := AdsStatement():New(cStatement_E, oSession_data)
    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif

    * vyucDani
    oStatement := AdsStatement():New(cStatement_I, oSession_data)
    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
  endif

  if( vyucDane->( ads_getKeyCount(1)) = 0, vyucDane->( ads_refreshAof(), dbgoTop()), nil )
  ::oDBro_main:oxbp:refreshAll()

  setAppFocus( ::oDBro_main:oxbp )
  ::dm:refresh()
return .t.


method MZD_mzVyucDane_ro_SCR:mzd_generuj_vypDan()
  local  cf := "nrok = %% .and. nobdobi = %%", cfiltr
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  recNo := vyucDane->( recNo())
  *
  local  generuj_vypDan := MZD_mzVyucDane_CRD():new(::drgDialog)

/*
  local  cStatement, oStatement
  local  stmt := "delete from mzEldpHd where nrok = %yyyy"
  *
  ** zrušíme evidenèní listy za pøíslušký rok
  cStatement := strTran( stmt, '%yyyy', str(::rok,4) )

  oStatement := AdsStatement():New(cStatement, oSession_data)
  if oStatement:LastError > 0
        *  return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif
*/

  *
  ** vygenerujeme nové roèní zúètování danì - je pro ty kdo je nemají
  cfiltr := format( cf, { ::rok, ::obdobi })
  msPrc_mo->( ads_setAof( cfiltr), dbgoTop() )

  nrecCnt := msPrc_mo->( ads_getKeyCount(1))
  nkeyCnt := nrecCnt

  do while .not. msPrc_mo->( eof())
    if msPrc_mo->lDanVypoc .and. .not. vyucDane->( dbseek( strZero(::rok,4) +strZero(msPrc_mo->noscisPrac,5)))

      generuj_vypDan:generuj_vypDan()

      mh_copyFld( 'vyucDanew', 'vyucDane', .t. )
      vyucDanew->(dbzap())
      vyucDaniw->(dbzap())
    endif

    msPrc_mo->( dbSkip())

    nkeyNo++
    if( msPrc_mo->(eof()), nkeyno := nkeyCnt, nil )
    fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
  enddo

  vyucDane->( dbunlock(), dbCommit())
  vyucDani->( dbunlock(), dbCommit())
  msPrc_mo->( ads_clearAof())

  ::xbp_therm:setCaption( '  ' )

  setAppFocus( ::oDBro_main:oxbp )
  ::oDBro_main:oxbp:goTop():refreshAll()

  ::dm:refresh()
return self

method MZD_mzVyucDane_ro_SCR:refresh(drgVar,nextFocus,vars_)
  local  nin, ovar, vars, new_val, dbArea
  *
  local  groups

  default nextFocus to .f.

  if isobject(drgVar)  ;  dbarea := lower(drgParse(drgVar:name,'-'))
                          vars   := drgVar:drgDialog:dataManager:vars
  else                 ;  dbarea := lower(drgVar)
                          vars   := vars_
  endif

  for nIn := 1 TO vars:size() step 1
    oVar   := vars:getNth(nIn)
    groups := isNull( oVar:oDrg:groups, '' )

    if empty( groups) .or. ::panGroup = groups

      if (dbArea == lower(drgParse(oVar:name,'-')) .or. 'M' == drgParse(oVar:name,'-')) .and. isblock(ovar:block)
        if(new_val := eval(ovar:block)) <> ovar:value
          ovar:set(new_val)
        endif
        ovar:initValue := ovar:prevValue := ovar:value
      endif
    endif
  next

  if nextFocus
    PostAppEvent(xbeP_Keyboard,xbeK_RETURN,,drgVar:odrg:oXbp)
  endif
return .t.

static function fin_bilancew_pb(oxbp, nkeyCnt, nkeyNo, ncolor)
  local  charInf
  local  GradientColors := GRA_FILTER_OPTLEVEL[1,2]
  *
  local  charInf_1, newPos, nclr := oxbp:setColorBG()
  local  nSize   := oxbp:currentSize()[1]
  local  nHight  := oxbp:currentSize()[2] -2

  default ncolor to GRA_CLR_PALEGRAY

  charInf_1 := nsize / nkeyCnt
  newPos    := charInf_1 * nkeyNo

  ops := oxbp:lockPs()

  GraGradient( ops             , ;
              {2,2}            , ;
              {{newPos,nHight}}, ;
              GradientColors, GRA_GRADIENT_HORIZONTAL)

  val := int((newPos/nSize *100))
  prc := if( val >= 100, '100', str(val,3,0)) +' %'

  GraGradient( ops                 , ;
               { newPos+1,2 }      , ;
               { { nsize, nhight }}, ;
               {ncolor,0,0}, GRA_GRADIENT_HORIZONTAL)

  GraStringAt( oPS, {(nSize/2) -20,6}, prc)
  oXbp:unlockPS(oPS)
return .t.