#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "gra.ch"
#include "dll.ch"

#include "..\Asystem++\Asystem++.ch"


function mzd_postSave()
  local  rok    := uctOBDOBI:MZD:NROK
  local  obdobi := uctOBDOBI:MZD:NOBDOBI

  if  mzdZavHD->( dbseek( strZero(rok,4) +strZero(obdobi,2) +'1',,'MZDZAVHD13')) .and. drgINI:l_blockObdMzdy
     ConfirmBox( ,'Pracujete v uzavøeném mzdovém/úèetním období doklad nelze modifikovat ...', ;
                  'Nelze uložit doklad ...'      , ;
                  XBPMB_CANCEL                  , ;
                  XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
     return .f.
  endif
  return .t.


//  AKTUALIZACE promìnné o stavu výpoètu ÈM - nstaVypoCM v MSPRC_MO
*  0 - nebyl proveden žádný výpoèet èisté mzdy
*  1 - nad zamìstnancem byl proveden automatický výpoèet èisté mzdy
*  2 - nad zamìstnancem byl proveden ruèní  výpoèet èisté mzdy
*  6 - výpoèet èisté mzdy byl ruènì zrušen
*  7 - výpoèet èisté mzdy byl zrušen aktualizací dat
*  8 - výpoèet èisté mzdy neprobìhl do konce
*  9 - nad zamìstnancem probíhá výpoèet èisté mzdy

*
*  MSPRC_MO
** CLASS MZD_kmenove_SCR *******************************************************
CLASS MZD_kmenove_SCR FROM drgUsrClass, quickFiltrs, mzd_cistaMzda_cmp, mzd_doplnujici_in
EXPORTED:
  method  Init
  method  drgDialogStart

  method  stableBlock
  *
  method  mzd_osobakmen_crd     // osb_osoby_crd
  method  mzd_rodprisl_in       // ne jsou souèástí osb_osoby_crd
  method  mzd_duchody_in        // ne jsou souèástí osb_osoby_crd
  method  mzd_prackalendar_in
  method  mzd_dochazkadny_in
  method  mzd_prumerykmen_crd
  method  mzd_doklhrmzdo_scr
  method  mzd_vypcistamzda_scr
  method  mzd_doklnemall_scr
  method  mzd_eldphd_crd
  method  mzd_vypdan_crd
  method  mzd_smldoh_in
  method  mzd_delporprvzt_

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


  inline access assign method is_Stavem() var is_Stavem
    return if( msprc_mo->lstavem, MIS_ICON_OK, 0 )
  *
  ** TAB 2 pracovní Vztah(y)
  inline access assign method nazPraVzt() var nazPraVzt
    c_pracvz->( dbseek( msPrc_mo->ntypPraVzt,,'C_PRACVZ01'))
    return c_pracVz->cnazPraVzt
  *
  ** TAB 6 duchody
  inline access assign method is_aktiv() var is_aktiv
    return if( duchody->lAktiv, MIS_ICON_OK, 0 )
  *
  ** TAB 8 èisé mzdy
  inline access assign method nazevDMz() var nazevDMz
    local  c_rokObd := strZero( ::rok,4) +strZero(::obdobi,2)
    local       cky := c_rokObd +strZero( mzdyit->ndruhMzdy,4)

    druhyMzd ->( dbseek( cky,, 'DRUHYMZD04'))
    return druhyMzd->cnazevDmz


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
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  msg, brow, rok, obdobi
  var  pa_relForText
  var  oBtn_mzd_vypcistamzda_scr, oBtn_mzd_eldphd_crd, oBtn_mzd_vypdan_crd, oBtn_mzd_smldoh_in, oBtn_mzd_delporprvzt_

  inline method oBtn_vypcistamzda_action()

    if isObject(::oBtn_mzd_vypcistamzda_scr)
      if  mzdZavHD->( dbseek( strZero(::rok,4) +strZero(::obdobi,2) +'1',,'MZDZAVHD13')) .and. drgINI:l_blockObdMzdy
        ::oBtn_mzd_vypcistamzda_scr:disable()
      else
        ::oBtn_mzd_vypcistamzda_scr:enable()
      endif
    endif
    return

endclass


METHOD MZD_kmenove_SCR:Init(parent)
  LOCAL cFiltr
  LOCAL cX

  ::drgUsrClass:init(parent)

  ::rok           := uctOBDOBI:MZD:NROK
  ::obdobi        := uctOBDOBI:MZD:NOBDOBI
  ::pa_relForText := {}
  *
  ** pro volání z PERSONAL se musí zabezpeèit otevøení souborù
  drgDBMS:open('prsmlDoh')
  drgDBMS:open('msSrz_mo')
  drgDBMS:open('osoby'   )
  drgDBMS:open('duchody' )
  *
  ** evidenèní listy dùchodového pojištìní
  drgDBMS:open('mzEldpHd')
  *  roèní vyúètování danì z pøíjmu
  drgDBMS:open('vyucdane')

  * TAB 5 rodinní pøíslušníci
  drgDBMS:open('osoby',,,,,'osoby_Vm')   // vazba msPrc_mo -> osoby.sID
  drgDBMS:open('osoby',,,,,'osoby_Rp')
  drgDBMS:open('vazOsoby')

  * TAb 7 prùmìry k období
  drgDBMS:open('msvPrum')

  * TAB 8 èité mzdy
  drgDBMS:open('mzddavhd')
  drgDBMS:open('mzdyhd')
  drgDBMS:open('mzdyit')
  drgDBMS:open('druhyMzd')

  drgDBMS:open('mzddavhd',,,,,'mzddavhdd')
  drgDBMS:open('mzdyhd',,,,,'mzdyhdd')

  * programový filtr
  rokobd := (::rok*100) + ::obdobi
  cfiltr := Format("nROKOBD = %%", {rokobd})
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_kmenove_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oForm:amembers, x, oDrg
  *
  local  pa := ::pa_relForText

  *
  ::msg  := drgDialog:oMessageBar
  ::brow := drgDialog:dialogCtrl:oBrowse

  ** doplòující nabídka
  ::MZD_doplnujici_in:init(drgDialog)



  ::quickFiltrs:init( self                                          , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }, ;
                        { 'Nový pracovníci        ', 'nrokobd = (year(msPrc_mo->ddatnast)*100) + month(msPrc_mo->ddatnast)' },   ;
                        { 'Pøedpokládané ukonè.pv ', 'nrokobd = (year(msPrc_mo->ddatpredvy)*100) + month(msPrc_mo->ddatpredvy)' }, ;
                        { 'Pracovníci s ukonè.pv  ', 'nrokobd = (year(msPrc_mo->ddatvyst)*100) + month(msPrc_mo->ddatvyst)' }  }, ;
                      'Zamìstnanci'                                      )

  ::mzd_cistaMzda_cmp:init( drgDialog, ::brow[1] )

  for x := 1 to len(members) step 1
    odrg := members[x]
    if     lower(odrg:ClassName()) $ 'drgtext'
      if( isArray(odrg:arRelate) .and. len(odrg:arRelate) <> 0, aadd( pa, odrg ), nil )
    endif
  next

  members := drgDialog:oActionBar:members
  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'mzd_vypcistamzda_scr' ;  ::oBtn_mzd_vypcistamzda_scr := members[x]
        case lower(members[x]:event) = 'mzd_eldphd_crd'       ;  ::oBtn_mzd_eldphd_crd       := members[x]
        case lower(members[x]:event) = 'mzd_vypdan_crd'       ;  ::oBtn_mzd_vypdan_crd       := members[x]
        case lower(members[x]:event) = 'mzd_smldoh_in'        ;  ::oBtn_mzd_smldoh_in        := members[x]
        case lower(members[x]:event) = 'mzd_delporprvzt_'     ;  ::oBtn_mzd_delporprvzt_     := members[x]
        endcase
      endif
    endcase
  next

  ::oBtn_vypcistamzda_action()
RETURN self


method MZD_kmenove_scr:stableBlock(oxbp, lsub_refresh)
  local  m_file, cfiltr, cmain_Ky, cmain_Kymi
  *
  local  pa  := ::pa_relForText
  local  x, odrg, rFile, rType, rOrd, rArea, type, aVal
  *
  local  cf      := "OSOBY  = %%", filtrs
  local  cf_tabs := format( "ncisOsoby = %%", {msPrc_mo->ncisOsoby} )

  default lsub_refresh to .f.

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       * TAB 2 pracovnì právní vztahy
       cfiltr := Format("noscisPrac = %%", {MSPRC_MO->noscisPrac})

       prSmlDoh ->(ads_setaof(cfiltr), dbGoTop())
       cfiltr := Format("nprsmldoh = %%", {prSmlDoh->sid})

       prSmDoZm ->(ads_setaof(cfiltr), dbGoTop())

       cfiltr := Format("nROKOBD = %% .and. nOSCISPRAC = %% .and. nPORPRAVZT = %%"  ;
                       , {MSPRC_MO->nROKOBD, MSPRC_MO->nOSCISPRAC, MSPRC_MO->nPORPRAVZT})

       msSrz_mo->(ads_setaof(cfiltr), dbGoTop())

       * TAB 4 osoby - osobní údaje
       osoby->(dbseek( msPrc_mo->ncisOsoby,,'OSOBY01'))

       * TAb 5 rodinní pøíslušníci
       osoby_Vm ->(dbseek( msPrc_mo->ncisOsoby,,'OSOBY01'))
       filtrs := format( cf, { isNull( osoby_Vm->sID, 0) })
       vazOsoby->( ads_setAof( filtrs ), dbgoTop())

       * TAB 6 duchody
       duchody ->( ads_setAof( cf_tabs ), dbgoTop())

       * TAB 7 pùmìry
       cmain_Ky := strZero(msPrc_mo->nrok   ,4) + ;
                   strZero(msPrc_mo->nobdobi,2) + ;
                   strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
       msvPrum->( dbseek( cmain_Ky,,'PRUMV_03'))

       *
       ** evidenèí listy dùchodového pojištìní
       cmain_Ky := strZero(msPrc_mo->nrok,4) + ;
                   strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
       mzEldpHd->( dbseek( cmain_Ky,, 'MZELDPHD06'))

       if isObject(::oBtn_mzd_eldphd_crd)
         if( msPrc_mo->lgenerELDP, ::oBtn_mzd_eldphd_crd:enable(), ::oBtn_mzd_eldphd_crd:disable() )
       endif

       if isObject(::oBtn_mzd_vypdan_crd)
         if( msPrc_mo->ldanVypoc, ::oBtn_mzd_vypdan_crd:enable(), ::oBtn_mzd_vypdan_crd:disable() )
       endif

       if isObject(::oBtn_mzd_delporprvzt_)
         cmain_Ky   := strZero(msPrc_mo->nrok,4) + ;
                       strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
         cmain_Kymi := strZero(msPrc_mo->nrok-1,4) + ;
                       strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
         if .not. mzddavhdd->( dbseek( cmain_Ky,,'MZDDAVHD23')) .and.          ;
             .not. mzdyhdd->( dbseek( cmain_Ky,,'MZDYHD09'))    .and.          ;
              .not. mzddavhdd->( dbseek( cmain_Kymi,,'MZDDAVHD23')).and.       ;
               .not. mzdyhdd->( dbseek( cmain_Kymi,,'MZDYHD09'))

//           if( isObject(::oBtn_mzd_smldoh_in), ::oBtn_mzd_smldoh_in:enable(), nil )
           ::oBtn_mzd_delporprvzt_:enable()
         else
//           if( isObject(::oBtn_mzd_smldoh_in), ::oBtn_mzd_smldoh_in:disable(), nil )
           ::oBtn_mzd_delporprvzt_:disable()
         endif
       endif
       *
       ** TAB 8 èisté mzdy
       cmain_Ky := strZero(msPrc_mo->nrok   ,4) + ;
                   strZero(msPrc_mo->nobdobi,2) + ;
                   strZero(msPrc_mo->nosCisPrac,5) +strZero(msPrc_mo->nporPraVzt,3)
       mzdyhd->( dbsetScope( SCOPE_BOTH, cmain_Ky),dbgoTop())

       mzdyit->( ordSetFocus('MZDYIT05'), dbsetScope(SCOPE_BOTH, mzdyhd->ndoklad), dbgoTop() )

       if lsub_refresh
         aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) }, 2 )
       endif
     endcase
  endif

  for x := 1 to len( pa) step 1
    odrg  := pa[x]
    rFile := odrg:arRelate[1,1]
    rType := odrg:arRelate[1,2]
    rOrd  := IsNull(odrg:arRelate[1,3],1)
    rArea := odrg:arRelate[1,4]
    cType := odrg:arRelate[1,5]

    aVal  := DBGetVal( odrg:ovar:name )
    aVal := if( cType = 'C', Upper( aVal), aVal )

    ( rArea )->( DbSeek(aVal,, AdsCtag(rOrd)))
  next

return self


*
**  metody pro volání výkonných obrazovek
**  MZD
method MZD_kmenove_SCR:mzd_osobakmen_crd()
  LOCAL oDialog

  ::drgDialog:pushArea()
                                          // Save work area
    DRGDIALOG FORM 'OSB_osoby_CRD' PARENT ::drgDialog CARGO drgEVENT_EDIT MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self

method mzd_kmenove_scr:mzd_doklhrmzdo_scr(drgDialog)
  local  othread
  local  filter
  local  cky := strZero( msPrc_mo->nrok,4)       +strZero( msPrc_mo->nobdobi,2)   + ;
                strZero( msPrc_mo->nosCisPrac,5) +strZero( msPrc_mo->nporPraVzt,3)

  filter := format("nrokObd = %% .and. nosCisPrac = %% .and. nporPraVzt = %%"  ;
                   , {msprc_mo->nrokObd, msprc_mo->nosCisPrac, msprc_mo->nporPraVzt})

  oThread := drgDialogThread():new()
  oThread:start( ,'mzd_doklhrmzdo_scr,' +filter +',' +cky, drgDialog)
return

*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_kmenove_SCR:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


*
**  metoda pro volání docházky
**  MZD
method MZD_kmenove_SCR:mzd_dochazkadny_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area

    drgDBMS:open('tmcelsumw'  ,.T.,.T.,drgINI:dir_USERfitm); ZAP
    DRGDIALOG FORM 'DOH_dochazkadny_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_kmenove_SCR:mzd_prumerykmen_crd()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prumery_crd' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_kmenove_SCR:mzd_rodprisl_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'PER_rodprisl_IN' PARENT ::drgDialog MODAL DESTROY
    ::stableBlock( ::brow[1]:oxbp, .t. )

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_kmenove_SCR:mzd_duchody_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'PER_duchody_IN' PARENT ::drgDialog MODAL DESTROY
    ::stableBlock( ::brow[1]:oxbp, .t. )

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method mzd_kmenove_scr:mzd_doklnemall_scr(drgDialog)
  local  othread
  local  filter
  local  cky := strZero( msPrc_mo->nosCisPrac,5) +strZero( msPrc_mo->nporPraVzt,3)

  filter := format("nosCisPrac = %% .and. nporPraVzt = %%"  ;
                   , {msprc_mo->nosCisPrac, msprc_mo->nporPraVzt})

  oThread := drgDialogThread():new()
  oThread:start( ,'mzd_doklnemall_scr,' +filter +',' +cky, drgDialog)

return


method MZD_kmenove_SCR:mzd_eldphd_crd()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area

  oDialog := drgDialog():new('MZD_mzeldphd_crd', ::drgDialog)

  if( mzEldpHd->nrok = 0, oDialog:cargo := drgEVENT_APPEND, nil )

  oDialog:create(,,.T.)
  oDialog:destroy(.T.)
  oDialog := NIL

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_kmenove_SCR:mzd_vypdan_crd()
  local  cky := strZero( msPrc_mo->nrok,4) +strZero( msPrc_mo->nosCisPrac,5)
  local  oDialog

  ::drgDialog:pushArea()                  // Save work area

    vyucDane->( dbseek( cky,,'VYUCDANE01'))
    DRGDIALOG FORM 'MZD_mzvyucdane_CRD' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


method MZD_kmenove_SCR:mzd_smldoh_in()
  local  cky := strZero( msPrc_mo->nrok,4) +strZero( msPrc_mo->nosCisPrac,5)
  local  oDialog

  ::drgDialog:pushArea()                  // Save work area

    DRGDIALOG FORM 'PER_smldoh_IN' PARENT ::drgDialog MODAL DESTROY
    ::stableBlock( ::brow[1]:oxbp, .t. )

  ::drgDialog:popArea()                  // Restore work area
RETURN self



method MZD_kmenove_SCR:mzd_delporprvzt_()
  LOCAL oDialog
  local cky    := msPrc_mo->crocpppv
  local ckymin
  local cfiltr

  ckymin := StrZero( Val( Left(msPrc_mo->crocpppv,4))-1,4) + Right(msPrc_mo->crocpppv,8)

  * ostatní

  drgDBMS:open('mzprkahd',,,,,'mzprkahdd')
  drgDBMS:open('msmzdyhd',,,,,'msmzdyhdd')
  drgDBMS:open('msodppol',,,,,'msodppold')
  drgDBMS:open('mssrz_mo',,,,,'mssrz_mod')
  drgDBMS:open('prsmldoh',,,,,'prsmldohd')
  drgDBMS:open('msvprum',,,,,'msvprumd')

  ::drgDialog:pushArea()                  // Save work area
  if .not. mzddavhdd->( dbseek( cky,,'MZDDAVHD23')) .and.                ;
       .not. mzdyhdd->( dbseek( cky,,'MZDYHD09'))    .and.               ;
        .not. mzddavhdd->( dbseek( ckymin,,'MZDDAVHD23')).and.           ;
          .not. mzdyhdd->( dbseek( ckymin,,'MZDYHD09'))

    if drgIsYesNo(drgNLS:msg( "Požadujete zrušit pøíslušný PPV"))
      cfiltr := Format("nmsprc_mo = %%", {isNull( MSPRC_MO->sid, 0)})
      mssrz_mod->(ads_setaof(cfiltr), dbGoTop())
      mssrz_mod->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnLock())} ))

      cfiltr := Format("sid = %%", {isNull( MSPRC_MO->nprsmldoh, 0)})
      prsmldohd->(ads_setaof(cfiltr), dbGoTop())
      prsmldohd->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnLock())} ))

//      cfiltr := Format("nmsprc_mo = %%", {MSPRC_MO->sid})
//      msmzdyhdd->(ads_setaof(cfiltr), dbGoTop())
//      msmzdyhdd->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnLock())} ))

      cfiltr := Format("nmsprc_mo = %%", {isNull( MSPRC_MO->sid, 0)})
      msvprumd->(ads_setaof(cfiltr), dbGoTop())
      msvprumd->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnLock())} ))

      cfiltr := Format("nrok = %% .and. noscisprac = %% .and. nporpravzt = %%", {MSPRC_MO->nrok,MSPRC_MO->noscisprac,MSPRC_MO->nporpravzt})
      mzprkahdd->(ads_setaof(cfiltr), dbGoTop())
      mzprkahdd->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnlock() ) } ))

      cfiltr := Format("nrok = %% .and. noscisprac = %% .and. nporpravzt = %%", {MSPRC_MO->nrok,MSPRC_MO->noscisprac,MSPRC_MO->nporpravzt})
      msodppold->(ads_setaof(cfiltr), dbGoTop())
      msodppold->( dbEval( { || ( if( RLock(), dbDelete(), nil), dbUnLock())} ))

      msprc_mo->( if( RLock(), dbDelete(), nil), dbUnlock() )
    endif
  endif

  ::drgDialog:popArea()                  // Restore work area
  ::brow[1]:oxbp:refreshAll()

//  msprc_mo->( dbSkip())
//  ::stableBlock( ::brow[1]:oxbp, .t. )


RETURN self



method mzd_kmenove_scr:mzd_vypcistamzda_scr(drgDialog)
  local  oThread
  local  filter
  *
  local  oDBro_msprc_mo := ::brow[1]
  local  coscisPrac := '', x, pa_oscisPrac := {}

  *
  ** zpracujeme èistou mzdu dle požadavku, automatickz bìží èervík
  if ::mzd_cistaMzda_start()

    do case
    case oDBro_msprc_mo:is_selAllRec
      coscisPrac := ''

    case len(oDBro_msprc_mo:arSelect) <> 0
      fordRec( {'msprc_mo'} )
      for x := 1 to len(oDBro_msprc_mo:arSelect) step 1
        msprc_mo->( dbgoTo( oDBro_msprc_mo:arSelect[x]))
        if ascan( pa_oscisPrac, msprc_mo->noscisPrac) = 0
          coscisPrac += str(msprc_mo->noscisPrac, 5) +';'
        endif
        aadd( pa_oscisPrac, msprc_mo->noscisPrac)
      next
      fordRec()
      coscisPrac := left( coscisPrac, len( coscisPrac) -1)

    otherwise
      coscisPrac := str(msprc_mo->noscisPrac, 5)

    endcase

    filter := format("nrokObd = %%", {msprc_mo->nrokObd})
    filter += if( coscisPrac <> '', " .and. at( str( noscisPrac;5); '" +coscisPrac +"') <> 0", "")

    oThread := drgDialogThread():new()
    oThread:start( ,'mzd_cistamzda_ob_scr,' +filter, drgDialog)
  endif

  oDBro_msprc_mo:oxbp:refreshAll()
return


procedure mzd_kmenove_scr_animate(xbp_therm,aBitMaps)
  local  aRect, oPS, nXD, nYD
  *
  local  oFont := XbpFont():new():create( "10.Arial CE" )
  local  aAttr := ARRAY( GRA_AS_COUNT ), nx_text
  local  cinfo := if( empty(xbp_therm:cargo), 'na datovém stroji ADs', xbp_therm:cargo)
  local  cText := '... probíhá zpracování èistých mezd ' +cinfo +' ...'

  xbp_therm:setCaption('')

  aRect   := xbp_therm:currentSize()
  oPS     := xbp_therm:lockPS()

  nXD     := abitMaps[2]
  nYD     := 0
  *
  nx_text := ( xbp_therm:currentSize()[1] / 2 ) - (( len( cText) * oFont:width) / 2)
  GraSetFont( oPS, oFont )

  aAttr [ GRA_AS_COLOR     ] := GRA_CLR_RED
  GraSetAttrString( oPS, aAttr )
  * 20
  GraStringAt( oPS, { nx_text, 4}, cText)
  *

  aBitMaps[1] ++
  if aBitMaps[1] > len(aBitMaps[3])
    aBitMaps[1] := 1
  endif

  aBitMaps[ 3, aBitMaps[1] ]:draw( oPS, {nXD,nYD} )
  xbp_therm:unlockPS( oPS )

  if abitMaps[2] +10 > aRect[1]
    abitMaps[2] := 0
  else
    abitMaps[2] := abitMaps[2] +10
  endif
return