#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "font.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"

*
** CLASS MZD_mzVyucDane_os_SC **************************************************
CLASS MZD_mzVyucDane_os_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:
  method  Init
  method  drgDialogStart
  method  itemMarked, postDelete

  * browCOlumn
  * msPrc_mo

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr, cmain_Ky

    do case
    case nEvent = drgEVENT_DELETE .and. .not. vyucDane->(eof())
      ::postDelete()
      return .t.

    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %% .and. ldanVypoc", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo', .t.)

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )

       cmain_Ky := DBGetVal(::cmain_Ky)
       vyucDane->( dbseek( cmain_Ky,,'VYUCDANE01' ))

       ::dm:refresh()
       return .t.

    otherwise
      return .f.
    endcase
  return .f.


  inline  method  mzd_mzvyucdane_it_scr()
    local  oDialog, filter
    local  cf := "nrok = %% .and. noscisPrac = %%"

    filter := format( cf, { ::rok, msprc_mo->noscisPrac } )

    vyucDani->( ads_setAof( filter), dbGoTop())
    DRGDIALOG FORM 'mzd_mzvyucdane_it_scr' PARENT ::drgDialog MODAL DESTROY

    vyucDani->( ads_clearAof())
  return self

hidden:
  var  msg, dm, brow, rok, obdobi
  var  cmain_Ky
  var  oDBro_main

ENDCLASS


METHOD MZD_mzVyucDane_os_SCR:Init(parent)
  local  rokObd

  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
  drgDBMS:open( 'vyucdane' )
  drgDBMS:open( 'vyucdani' )
  *
  ::cmain_Ky      := 'strZero(msPrc_mo->nrok,4) +strZero(msPrc_mo->nosCisPrac,5)'
  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI

  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %% .and. ldanVypoc", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_mzVyucDane_os_SCR:drgDialogStart(drgDialog)
  local  nposIn, x, odrg
  local  ab      := drgDialog:oActionBar:members    // actionBar
  local  members := drgDialog:oForm:aMembers
  *
  ::msg          := drgDialog:oMessageBar             // messageBar
  ::dm           := drgDialog:dataManager             // dataManager
  ::brow         := drgDialog:dialogCtrl:oBrowse
  ::oDBro_main   := ::brow[1]

  for x := 1 to len(members) step 1
    odrg := members[x]

    do case
    case lower( odrg:className()) = 'drgtext'
*      odrg:oxbp:setFontCompoundName( FONT_DEFPROP_SMALL + FONT_STYLE_BOLD )
      odrg:oXbp:setColorFG(GRA_CLR_BLUE)

    case lower( odrg:className()) = 'drgget'
      odrg:isEdit := .f.

    case lower( odrg:className()) = 'drgpushbutton'

    case lower( odrg:className()) <> 'drgstatic'
    endcase
  next

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )

*  if( nposIn := ascan( ab, { |s| s:event = 'mzd_importdokl_ml' } )) <> 0
*    ::butt_importdokl_ml := ab[ nposIn ]
*  endif
RETURN self


method MZD_mzVyucDane_os_SCR:itemMarked(arowco,unil,oxbp)
  local  cmain_Ky := DBGetVal(::cmain_Ky), ok

  if isObject(oxbp)
    vyucDane->( dbseek( cmain_Ky,,'VYUCDANE01' ))
  endif
return self


method MZD_mzVyucDane_os_SCR:postDelete()
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

    fordRec( {'msPrc_mo'} )
    for x := 1 to len(::oDBro_main:arSelect) step 1
      msPrc_mo->( dbgoTo( ::oDBro_main:arSelect[x]))

      coscisPrac += strTran( str(msPrc_mo->noscisPrac), ' ', '') +','
    next
    fordRec()
    coscisPrac := left( coscisPrac, len( coscisPrac) -1)

    stmt_E     += " and noscisPrac IN(' +coscisPrac +')'"
    stmt_I     += " and noscisPrac IN(' +coscisPrac +')'"
  otherWise
    cinfo := 'pro ' +allTrim(msPrc_mo->cJmenoRozl) +'_'

    stmt_E     += " and noscisPrac = %pppp"
    stmt_I     += " and noscisPrac = %pppp"
  endcase

  cStatement_E := strTran( stmt_E      , '%yyyy', str(::rok,4) )
  cStatement_E := strTran( cStatement_E, '%pppp', str(msPrc_mo->noscisPrac) )

  cStatement_I := strTran( stmt_I      , '%yyyy', str(::rok,4) )
  cStatement_I := strTran( cStatement_I, '%pppp', str(msPrc_mo->noscisPrac) )


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

    * vzucDani
    oStatement := AdsStatement():New(cStatement_I, oSession_data)
    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
      oStatement:Close()
    endif
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .t.