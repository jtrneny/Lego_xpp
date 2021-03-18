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
*  msPrc_mo - mydzhd - mzdyit
** CLASS MZD_cistamzda_pv_SCR **************************************************
CLASS MZD_cistamzda_pv_SCR FROM drgUsrClass, quickFiltrs, mzd_cistaMzda_cmp
EXPORTED:
  method  Init
  method  drgDialogStart
  method  ItemMarked

  method  mzd_doklhrmzdo_scr
  method  mzd_vypcistamzda_scr

  * browCOlumn
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
/*
    retVal := if( nstaVypoCM = 1, MIS_ICON_OK, ;
               if( nstaVypoCM = 2, MIS_EDIT   , ;
                if( nstaVypoCM = 6, MIS_MINUS  , ;
                 if( nstaVypoCM = 7, MIS_NO_RUN , ;
                  if( nstaVypoCM = 8, MIS_ICON_ERR, ;
                   if( nstaVypoCM = 9, MIS_LIGHT   , 0 ))))))
    return retVal
*/

  inline access assign method is_Stavem() var is_Stavem
    return if( msprc_mo->lstavem, MIS_ICON_OK, 0 )


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::rok    := uctOBDOBI:MZD:NROK
       ::obdobi := uctOBDOBI:MZD:NOBDOBI

       rokobd := (::rok*100) + ::obdobi
       cfiltr := Format("nROKOBD = %%", {rokobd})
       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )
       ::oBtn_vypcistamzda_action()

       PostAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp )    
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  msg, brow, rok, obdobi
  var  oBtn_mzd_vypcistamzda_scr


  inline method oBtn_vypcistamzda_action()

    if  mzdZavHD->( dbseek( strZero(::rok,4) +strZero(::obdobi,2) +'1',,'MZDZAVHD13')) .and. drgINI:l_blockObdMzdy
      ::oBtn_mzd_vypcistamzda_scr:disable()
    else
      ::oBtn_mzd_vypcistamzda_scr:enable()
    endif
    return


endclass


METHOD MZD_cistamzda_pv_SCR:Init(parent)

  ::drgUsrClass:init(parent)

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDYHD')
  drgDBMS:open('MZDYIT')

  MZDYIT->( DbSetRelation( 'DRUHYMZD',  { || MZDYIT->nDruhMzdy },  'MZDYIT->nDruhMzdy'))

  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_cistamzda_pv_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className

  ::brow := drgDialog:dialogCtrl:oBrowse

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )

  ::mzd_cistaMzda_cmp:init( drgDialog, ::brow[1] )


  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'mzd_vypcistamzda_scr' ;  ::oBtn_mzd_vypcistamzda_scr := members[x]
        endcase
      endif
    endcase
  next

  ::oBtn_vypcistamzda_action()
RETURN self


METHOD MZD_cistamzda_pv_SCR:ItemMarked()
  Local  dc  := ::drgDialog:dialogCtrl
  local  cKy := strZero( msPrc_mo->nROK,4)       +strZero( msPrc_mo->nOBDOBI,2) + ;
                strZero( msPrc_mo->nOSCISPRAC,5) +strZero( msPrc_mo->nPORPRAVZT,3)

  mzdyhd->( dbsetScope( SCOPE_BOTH, cky),dbgoTop())

  cFiltr := Format("nROK = %% .and. nDOKLAD = %%", {MZDYHD->nROK, MZDYHD->nDOKLAD})
  mzdyit->( ads_setAOF( cFiltr), dbgoTop() )

*  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgBrowse', X:Refresh(.T.), NIL )} )
RETURN SELF


*
**  metody pro volání výkonných obrazovek
**  MZD
method mzd_cistamzda_pv_scr:mzd_doklhrmzdo_scr(drgDialog)
  local  othread
  local  filter
  local  cky := strZero( msPrc_mo->nrok,4)       +strZero( msPrc_mo->nobdobi,2)   + ;
                strZero( msPrc_mo->nosCisPrac,5) +strZero( msPrc_mo->nporPraVzt,3)

  filter := format("nrokObd = %% .and. nosCisPrac = %% .and. nporPraVzt = %%"  ;
                   , {msprc_mo->nrokObd, msprc_mo->nosCisPrac, msprc_mo->nporPraVzt})

  oThread := drgDialogThread():new()
  oThread:start( ,'mzd_doklhrmzdo_scr,' +filter +',' +cky, drgDialog)
return


method mzd_cistamzda_pv_scr:mzd_vypcistamzda_scr(drgDialog)
  *
  local  oDBro_msprc_mo := ::brow[1]

  *
  ** zpracujeme èistou mzdu dle požadavku, automatickz bìží èervík
  ::mzd_cistaMzda_start()

  oDBro_msprc_mo:oxbp:refreshAll()
  PostAppEvent(xbeBRW_ItemMarked,,,oDBro_msprc_mo:oxbp )
return