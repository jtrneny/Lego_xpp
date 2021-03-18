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
** CLASS MZD_mzEldpHd_pv_SCR **************************************************
CLASS MZD_mzEldpHd_pv_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart
  method  itemMarked, postDelete

  class   var mo_prac_filtr READONLY

  * browCOlumn
  * msPrc_mo
  inline access assign method ind_staVypCM var ind_staVypCM
    local retVal := 0
    local nstaVypoCM := msprc_mo->nstaVypoCM

    do case
    case( nstaVypoCM = 1 .or. nstaVypoCM = 2 )
      retVal := MIS_ICON_OK
    case( nstaVypoCM = 6 .or. nstaVypoCM = 7 .or. nstaVypoCM = 8 )
      retVal := MIS_NO_RUN
    endcase
    return retVal

  inline access assign method is_Stavem() var is_Stavem
    return if( msprc_mo->lstavem, MIS_ICON_OK, 0 )

  * mzdEldphd
  inline access assign method obdobi_ELDP() var obdobi_ELDP
    return if( mzEldpHd->nrok = 0, '', str(mzEldpHd->nobdobi,2) +'/' +str(mzEldpHd->nrok,4) )

  inline access assign method is_odesELSSZ() var is_odesELSSZ
    retur if( empty( mzEldpHd->dodesELSSZ), 0, MIS_ICON_OK)

  inline access assign method is_datTisk()   var is_datTisk
    retur if( empty( mzEldpHd->ddatTisk), 0, 553)


  * má definovanou automatickou matrici ?
  inline access assign method in_msMzdyhd() var in_msMzdyhd
    local cky := strZero( msPrc_mo->noscisPrac, 5) + ;
                  strZero( msPrc_mo->nporPraVzt,3) +'1'
    return if( msMzdyhd->( dbseek(cky,,'MSMZDYHD03')), MIS_ICON_OK, 0 )

  * nautoGen 0 - mzdy 5 - výroba 6 - docházka
  inline access assign method autoGen_From() var autoGen_From
    return if( mzdDavHd->nautoGen = 6, 'D', ;
            if( mzdDavHd->nautoGen = 5, 'V', if( mzdDavHd->ndoklad <> 0,  'M', ' ' )))

  *
  **
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  cKy, rokObd, cfiltr
    *
    ** pitomý blok
    if nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2 .or. nEvent = drgEVENT_EDIT
      if .not. msPrc_mo->lgenerELDP
        fin_info_box('Generovat evidenèní list není povoleno ...')
        return .t.
      endif
    endif

    do case
    case nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2
      cKy := strZero(::rok,4) +strZero(msPrc_mo->nosCisPrac,5) + ;
             strZero(msPrc_mo->nporPraVzt,3)+strZero(::obdobi,2)

      if mzEddph_iw->( dbseek( cKy,,'MZELDPHD06'))
        fin_info_box('Evidenèní list pro období a pracovníka již existuje ...')
        return .t.
      endif

    case nEvent = drgEVENT_EDIT
      if mzEldpHd->nrok = 0
        postAppEvent( drgEVENT_APPEND,,,oxbp )
        return .t.
      endif

    case nEvent = drgEVENT_DELETE
      if( mzEldpHd->nrok <> 0, ::postDelete(), nil )
      return .t.

    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo', .t.)

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  dc, msg, brow, rok, obdobi
  var  cmain_Ky, butt_importdokl_ml

ENDCLASS


METHOD MZD_mzEldpHd_pv_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
  drgDBMS:open( 'mzEldpHd' )
  drgDBMS:open( 'mzEldpHd',,,,,'mzEddph_iw' )

  ::rok     := uctOBDOBI:MZD:NROK
  ::obdobi  := uctOBDOBI:MZD:NOBDOBI

  drgDbms:open( 'msMzdyhd' )
  drgDBMS:open( 'mzdDavHd' )
  drgDBMS:open( 'druhyMzd' )
  drgDBMS:open( 'listit'   )

  ::mo_prac_filtr := ''
  ::cmain_Ky      := 'strZero(msPrc_mo->nrok,4) + ' + ;
                     'strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)'


  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_mzEldpHd_pv_SCR:drgDialogStart(drgDialog)
  local  nposIn, x, odrg
  local  ab      := drgDialog:oActionBar:members    // actionBar
  local  members := drgDialog:oForm:aMembers
  *
  ::msg        := drgDialog:oMessageBar
  ::brow       := drgDialog:dialogCtrl:oBrowse
  ::dc         := drgDialog:dialogCtrl              // dataCtrl

  for x := 1 to len(members) step 1
    odrg := members[x]
    if lower( odrg:className()) <> 'drgstatic'
    endif

    if( lower( odrg:className()) <> 'drgdbrowse' .and. ismemberVar( odrg, 'isEdit'))
       odrg:isEdit := .f.
*       if( isMemberVar( odrg, 'disabled'), odrg:disabled := .t., nil )
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


method MZD_mzEldpHd_pv_SCR:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  rokobd := (::rok*100) + ::obdobi
  *
  local  cf_h := "nROK = %% .and. noscisPrac = %% .and. nporPraVzt = %%"
  local  cf_i := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"
  *
  local  cmain_Ky := DBGetVal(::cmain_Ky), ok

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       mzEldpHd->( ordsetFocus('MZELDPHD06'))

       cfiltr := Format( cf_h, { msPrc_mo->nrok, msPrc_mo->noscisPrac, msPrc_mo->nporPraVzt })
       mzEldpHd->(ads_setaof(cfiltr), dbGoTop())

     case( m_file = 'mzeldphd' )
*       cfiltr := Format( cf_i, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
*       mzddavit->(ads_setaof(cfiltr), dbGoTop())

     endcase
  endif
return self


method MZD_mzEldpHd_pv_SCR:postDelete()
  local  cinfo  := '', nsel, nrecCnt
  local  coscisPrac := '', x, pa_oscisPrac := {}
  *
  local  stmt := "delete from mzEldpHd where nrok = %yyyy"
  local  cStatement, oStatement

  cfile   := lower(::dc:oaBrowse:cfile)
  nrecCnt := mzEldpHd->( ads_getKeyCount(1))

  do case
  case cfile = 'msprc_mo' .and. nrecCnt > 1
    cinfo := 'kompletnì pro pracovníka _' +allTrim(mzEldpHd->cJmenoRozl) +'_'  +CRLF + ;
             'prosím POZOR, všechny evidenèní listy budou zrušeny'

    stmt  += " and noscisPrac = %pppp"
  otherwise
    cinfo := 'pro pracovníka _' +allTrim(mzEldpHd->cJmenoRozl) +'_' +CRLF + ;
             ' ... za období ' +str(mzEldpHd->nobdobi,2) +'/' +str(mzEldpHd->nrok,4) +' ...'

    stmt  += " and nobdobi = %mm and noscisPrac = %pppp"
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