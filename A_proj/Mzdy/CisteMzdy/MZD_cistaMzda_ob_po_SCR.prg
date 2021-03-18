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
*  mydzhd - mzdyit
** CLASS MZD_cistamzda_ob_SCR **************************************************
CLASS MZD_cistamzda_ob_po_SCR FROM drgUsrClass, mzd_cistaMzda_cmp
EXPORTED:
  method  Init
  method  drgDialogStart
  method  ItemMarked

  method  mzd_doklhrmzdo_scr
  method  mzd_vypcistamzda_scr

  * browCOlumn
  inline access assign method nazevDMz() var nazevDMz
    local  cky := ::c_rokObd +strZero( mzdyit->ndruhMzdy,4)
    druhyMzd ->( dbseek( cky,, 'DRUHYMZD04'))
    return druhyMzd->cnazevDmz

  *
  ** dos
  inline access assign method mzdDavit_nazevDMz() var mzdDavit_nazevDMz
    local  cky := ::c_rokObd +strZero( mzdDavit->ndruhMzdy,4)
    druhyMza ->( dbseek( cky,, 'DRUHYMZD04'))
    return druhyMza->cnazevDmz

  inline access assign method mzdy_nazevDMz() var mzdy_nazevDMz
    local  cky := ::c_rokObd +strZero( mzdy->ndruhMzdy,4)
    druhyMzb ->( dbseek( cky,, 'DRUHYMZD04'))
    return druhyMzb->cnazevDmz


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  rokObd, cfiltr

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
      ::setSysFilter()
      ::oBtn_vypcistamzda_action()
      return .t.

    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var   from_mzd_kmenove_scr
  var   msg, brow, rok, obdobi, c_rokObd
  var   oBtn_mzd_doklhrmzdo_scr, oBtn_mzd_vypcistamzda_scr

  inline method setSysFilter( ini )
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    ::rok      := uctOBDOBI:MZD:NROK
    ::obdobi   := uctOBDOBI:MZD:NOBDOBI
    ::c_rokObd := strZero( ::rok,4) +strZero(::obdobi,2)

    rokobd     := (::rok*100) + ::obdobi

    cfiltr  := Format("nROKOBD = %%", {rokObd} )

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'mzdyhd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzdyit', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      mzdyit->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()

*      setAppFocus(oDBro_mzdyhd:oxbp)
      PostAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp )
    endif
  return self


  inline method oBtn_vypcistamzda_action()

    if  mzdZavHD->( dbseek( strZero(::rok,4) +strZero(::obdobi,2) +'1',,'MZDZAVHD13')) .and. drgINI:l_blockObdMzdy
      ::oBtn_mzd_vypcistamzda_scr:disable()
    else
      ::oBtn_mzd_vypcistamzda_scr:enable()
    endif
    return

ENDCLASS


METHOD MZD_cistamzda_ob_po_SCR:Init(parent)
  local rokObd, cfilter

  ::drgUsrClass:init(parent)

  ::rok      := uctOBDOBI:MZD:NROK
  ::obdobi   := uctOBDOBI:MZD:NOBDOBI
  ::c_rokObd := strZero( ::rok,4) +strZero(::obdobi,2)

  ::from_mzd_kmenove_scr := .f.

  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDYHD')
  drgDBMS:open('MZDYIT')
  drgDBMS:open('msPrc_mo')

  * dos
  drgDBMS:open('druhyMzd',,,,, 'druhyMza')
  drgDBMS:open('druhyMzd',,,,, 'druhyMzb')
  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    cfilter := strTran( pa_initParam[2], ';', ',')
    ::drgDialog:set_prg_filter(cfilter, 'mzdyit')

    ::from_mzd_kmenove_scr := .t.
  else

    * programový filtr
    rokobd  := (::rok*100) + ::obdobi
    cfilter := Format("nROKOBD = %%", {rokobd})
    ::drgDialog:set_prg_filter( cfilter, 'mzdyit')
  endif
RETURN self


METHOD MZD_cistamzda_ob_po_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className

  ::brow := drgDialog:dialogCtrl:oBrowse

  ::mzd_cistaMzda_cmp:init( drgDialog, ::brow[1] )

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'mzd_doklhrmzdo_scr'   ;  ::oBtn_mzd_doklhrmzdo_scr   := members[x]
        case lower(members[x]:event) = 'mzd_vypcistamzda_scr' ;  ::oBtn_mzd_vypcistamzda_scr := members[x]
        endcase
      endif
    endcase
  next

  if ::from_mzd_kmenove_scr
    drgDialog:set_uct_ucetsys_inlib()
    ( ::oBtn_mzd_vypcistamzda_scr:disable(), ::oBtn_mzd_vypcistamzda_scr:oxbp:hide() )
  else
    ::oBtn_vypcistamzda_action()
  endif
RETURN self


METHOD MZD_cistamzda_ob_po_SCR:ItemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  cKy     := strZero( MZDYIT->nROK,4)       +strZero( MZDYIT->nOBDOBI,2) + ;
                    strZero( MZDYIT->nOSCISPRAC,5) +strZero( MZDYIT->nPORPRAVZT,3)

//  cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhd->nRok, mzdyhd->nDoklad})
//  mzdyit->( ads_setAof( cFiltr), dbgoTop())
//  mzdyhd->( dbSeek( mzdyit->nMzdyHD,,'ID'))
  mzdyhd->( dbSeek( mzdyit->nDoklad,,'MZDYHD16'))

  if( mzdyhd->(eof()), ::oBtn_mzd_doklhrmzdo_scr:disable(), ::oBtn_mzd_doklhrmzdo_scr:enable() )

  if isObject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    do case
    case( m_file = 'mzdyit' )
*      cky := Upper(mzdyhd->cDENIK) +StrZero(mzdyhd->ndoklad,10)
*      ucetpol  ->(mh_ordSetScope(cky))

      cfiltr := format( "( cdenik = 'MH' .or. cdenik = 'MN' .or. cdenik = 'MS' .or. cdenik = 'MC' ) .and. ndoklad = %%", ;
                      { mzdyit->ndoklad } )
      ucetpol->( ads_setAof( cfiltr), dbgoTop())
    endcase
  endif

  * dos
//  mzdy->( ordSetFocus( 'MZDY_12' ), dbSetScope( SCOPE_BOTH, cky), DbGoTop())

*  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgBrowse', X:Refresh(.T.), NIL )} )
RETURN SELF


*
**  metody pro volání výkonných obrazovek
**  MZD
method mzd_cistamzda_ob_po_scr:mzd_doklhrmzdo_scr(drgDialog)
  local  othread
  local  filter, cky := strZero( mzdyit->nrok,4)       +strZero( mzdyit->nobdobi,2)   + ;
                        strZero( mzdyit->nosCisPrac,5) +strZero( mzdyit->nporPraVzt,3)

  msPrc_mo->( dbseek( cky,,'MSPRMO01'))

  filter := format("nrokObd = %% .and. nosCisPrac = %% .and. nporPraVzt = %%"  ;
                   , {mzdyit->nrokObd, mzdyit->nosCisPrac, mzdyit->nporPraVzt})


  oThread := drgDialogThread():new()
  oThread:start( ,'mzd_doklhrmzdo_scr,' +filter +',' +cky, drgDialog)
return


method mzd_cistamzda_ob_po_scr:mzd_vypcistamzda_scr(drgDialog)
  *
  local  oDBro_mzdyhd := ::brow[1]

  *
  ** zpracujeme èistou mzdu dle požadavku, automaticky bìží èervík
  oDBro_mzdyhd:is_selAllRec := .t.

  ::mzd_cistaMzda_start()

  oDBro_mzdyhd:is_selAllRec := .f.

  ::setSysFilter()
  setAppFocus(oDBro_mzdyhd:oxbp)
  PostAppEvent(xbeBRW_ItemMarked,,,oDBro_mzdyhd:oxbp )
return



