#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"

//  AKTUALIZACE promìnné o stavu výpoètu ÈM - nstaVypoCM v MSPRC_MO
*  0 - nebyl proveden žádný výpoèet èisté mzdy
*  1 - nad zamìstnancem byl proveden automatický výpoèet èisté mzdy
*  2 - nad zamìstnancem byl proveden ruèní  výpoèet èisté mzdy
*  6 - výpoèet èisté mzdy byl ruènì zrušen
*  7 - výpoèet èisté mzdy byl zrušen aktualizací dat
*  8 - výpoèet èisté mzdy neprobìhl do konce
*  9 - nad zamìstnancem probíhá výpoèet èisté mzdy

*
** CLASS MZD_mzEldpHd_ro_SCR **************************************************
CLASS MZD_mzEldpHd_ro_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart
  method  itemMarked, postDelete
  method  mzd_generuj_eldp

  class   var mo_prac_filtr READONLY

  * browCOlumn
  * mzEldpHd
  inline access assign method is_Stavem() var is_Stavem
    local cky := strZero( mzEldpHd->noscisPrac, 5) + ;
                 strZero( mzEldpHd->nporPraVzt,3) +'1'
    msPrc_mo->( dbseek(cky,,'MSPRMO10', .t.))
    return if( msPrc_mo->lstavem, MIS_ICON_OK, 0 )

  inline access assign method is_odesELSSZ() var is_odesELSSZ
    retur if( empty( mzEldpHd->dodesELSSZ), 0, MIS_ICON_OK)

  inline access assign method is_datTisk()   var is_datTisk
    retur if( empty( mzEldpHd->ddatTisk), 0, 553)

  inline access assign method obdobi_ELDP() var obdobi_ELDP
    return if( mzEldpHd->nrok = 0, '', str(mzEldpHd->nobdobi,2) +'/' +str(mzEldpHd->nrok,4) )

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      return .t.

    case nEvent = drgEVENT_EDIT .and. mzEldpHd->nrok = 0
      return .t.

    case nEvent = drgEVENT_DELETE
      if( mzEldpHd->nrok <> 0, ::postDelete(), nil )
      return .t.

    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'mzEldpHd', .t.)

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  msg, brow, oDBro_msPrc_mo, rok, obdobi, xbp_therm

  var  cmain_Ky
  var  pa_column_1
  var  oDBro_main

ENDCLASS


METHOD MZD_mzEldpHd_ro_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
  drgDBMS:open( 'mzEldpHd' )

  drgDbms:open( 'msMzdyhd' )
  drgDBMS:open( 'mzdDavHd' )
  *
  drgDBMS:open( 'druhyMzd' )
  drgDBMS:open( 'listit'   )

  ::mo_prac_filtr := ''
  ::cmain_Ky      := 'strZero(msPrc_mo->nrok,4) +strZero(msPrc_mo->nobdobi,2) + ' + ;
                     'strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)'

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI
  ::pa_column_1   := { { sysConfig( 'mzdy:cdenikMZ_H'), 534 }, ;
                       { sysConfig( 'mzdy:cdenikMZ_N'), 535 }, ;
                       { sysConfig( 'mzdy:cdenikMZ_S'), 536 }  }

  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'mzEldpHd')
RETURN self


METHOD MZD_mzEldpHd_ro_SCR:drgDialogStart(drgDialog)
  local  nposIn, x, odrg
  local  ab      := drgDialog:oActionBar:members    // actionBar
  local  members := drgDialog:oForm:aMembers
  *
  ::msg            := drgDialog:oMessageBar
  ::brow           := drgDialog:dialogCtrl:oBrowse
  ::oDBro_msPrc_mo := ::brow[1]
  ::oDBro_main     := ::brow[1]

  ::xbp_therm      := drgDialog:oMessageBar:msgStatus


  for x := 1 to len(members) step 1
    odrg := members[x]
    if lower( odrg:className()) <> 'drgstatic'
    endif

    if( lower( odrg:className()) <> 'drgdbrowse' .and. ismemberVar( odrg, 'isEdit'))
       odrg:isEdit := .f.
       if( isMemberVar( odrg, 'disabled'), odrg:disabled := .t., nil )
       if( lower( odrg:className()) = 'drgcombobox', odrg:oxbp:disable(), nil )
    endif
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


method MZD_mzEldpHd_ro_SCR:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  rokobd := (::rok*100) + ::obdobi
  *
  local  cf_h := "nROKOBD = %% .and. noscisPrac = %% .and. nporPraVzt = %%"
  local  cf_i := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"
  *
  local  cmain_Ky := DBGetVal(::cmain_Ky), ok
  local  cky      := strZero(::rok,4) +strZero(::obdobi,2) +;
                     strZero(mzeldphd->nosCisPrac,5) +strZero(mzeldphd->nporPraVzt,3)

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzeldphd' )
       msPrc_mo->( dbseek( cky,, 'MSPRMO01'))
     endcase
  endif
return self


method MZD_mzEldpHd_ro_SCR:mzd_generuj_eldp()
  local  cf := "nrok = %% .and. nobdobi = %%", cfiltr
  local  nsel, cinfo
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  *
  local  generuj_eldp := MZD_mzeldphd_CRD():new(::drgDialog)
  local  cStatement, oStatement
  local  stmt := "delete from mzEldpHd where nrok = %yyyy and nobdobi = %mm"
  *
  ** zrušíme evidenèní listy za pøíslušný rok a obdobi
  cStatement := strTran( stmt      , '%yyyy', str(::rok   ,4) )
  cStatement := strTran( cStatement, '%mm'  , str(::obdobi,2) )


  cinfo := '     ... kompletnì_za období ' +str(::obdobi,2) +'/' +str(::rok,4) +' ... '  +CRLF + ;
           if( mzEldpHd->nrok = 0, '',  'prosím POZOR, pøedchozí evidenèní listy budou zrušeny' )

  nsel  := ConfirmBox( ,'Dobrý den p. ' +logOsoba +CRLF +                                      ;
                        'opravdu požadujete generovat evidenèní listy _ ' +CRLF +CRLF +cinfo , ;
                        'Vytvoøení evidenèních listù ...'                                    , ;
                         XBPMB_YESNO                                                         , ;
                         XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES

    oStatement := AdsStatement():New(cStatement, oSession_data)
    if oStatement:LastError > 0
        *  return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif

    *
    ** vygenerujeme nové evidenèní listy
    cfiltr := format( cf, { ::rok, ::obdobi })
    msPrc_mo->( ads_setAof( cfiltr), dbgoTop() )

    nrecCnt := msPrc_mo->( ads_getKeyCount(1))
    nkeyCnt := nrecCnt

    do while .not. msPrc_mo->( eof())
      if msPrc_mo->lgenerELDP

        generuj_eldp:generuj_eldp()

        mh_copyFld( 'mzeldphdw', 'mzEldpHd', .t. )
        mzEldphdw->(dbzap())
      endif

      msPrc_mo->( dbSkip())

      nkeyNo++
      if( msPrc_mo->(eof()), nkeyno := nkeyCnt, nil )
      fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
    enddo

    mzEldpHd->( dbunlock(), dbCommit())

    ::xbp_therm:setCaption( '  ' )
    ::oDBro_msPrc_mo:oxbp:goTop():refreshAll()
  endif
return self


method MZD_mzEldpHd_ro_SCR:postDelete()
  local  cinfo  := '', nsel
  local  coscisPrac := '', x, pa_oscisPrac := {}
  *
  local  stmt := "delete from mzEldpHd where nrok = %yyyy and nobdobi = %mm"
  local  cStatement, oStatement

  do case
  case ::oDBro_main:is_selAllRec
    cinfo := 'kompletnì_za období ' +str(mzEldpHd->nobdobi,2) +'/' +str(mzEldpHd->nrok,4) +' ?'

  case len( ::oDBro_main:arSelect) <> 0
    cinfo  := 'pro vybrané pracovníky_'

    fordRec( {'mzEldpHd'} )
    for x := 1 to len(::oDBro_main:arSelect) step 1
      mzEldpHd->( dbgoTo( ::oDBro_main:arSelect[x]))

      coscisPrac += strTran( str(mzEldpHd->noscisPrac), ' ', '') +','
    next
    fordRec()
    coscisPrac := left( coscisPrac, len( coscisPrac) -1)

    stmt       += " and noscisPrac IN(' +coscisPrac +')'"
  otherWise
    cinfo := 'pro ' +allTrim(mzEldpHd->cJmenoRozl) +'_'

    stmt  += " and noscisPrac = %pppp"
  endcase

  cStatement := strTran( stmt      , '%yyyy', str(::rok,4) )
  cStatement := strTran( cStatement, '%mm'  , str(::obdobi,2) )
  cStatement := strTran( cStatement, '%pppp', str(mzEldpHd->noscisPrac) )

  nsel := ConfirmBox( ,'Dobrý den p. ' +logOsoba +CRLF +                                     ;
                       'opravdu požadujete zrušit evidenèní list(y) _ ' +CRLF +CRLF +cinfo , ;
                       'Zrušení evidenèních listù ...'                                     , ;
                        XBPMB_YESNO                                                        , ;
                        XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES

    * mzEldpHd
    oStatement := AdsStatement():New(cStatement, oSession_data)
    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
  endif

  mzEldpHd->( dbunlock(), dbCommit())
  ::drgDialog:dialogCtrl:refreshPostDel()
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



