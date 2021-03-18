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
CLASS MZD_cistamzda_ob_SCR FROM drgUsrClass, mzd_cistaMzda_cmp
EXPORTED:
  method  Init
  method  drgDialogStart
  method  ItemMarked

  method  mzd_doklhrmzdo_scr
  method  mzd_vypcistamzda_scr
  method  mzd_tmpdovol_
  method  mzd_zustDovPrep_
  method  mzd_tmpPREPhd_

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
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzdyhd', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      mzdyhd->( ads_setaof(filtrs), dbGoTop())
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


METHOD MZD_cistamzda_ob_SCR:Init(parent)
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
//  drgDBMS:open('mzdy')
  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    cfilter := strTran( pa_initParam[2], ';', ',')
    ::drgDialog:set_prg_filter(cfilter, 'mzdyhd')

    ::from_mzd_kmenove_scr := .t.
  else

    * programový filtr
    rokobd  := (::rok*100) + ::obdobi
    cfilter := Format("nROKOBD = %%", {rokobd})
    ::drgDialog:set_prg_filter( cfilter, 'mzdyhd')
  endif
RETURN self


METHOD MZD_cistamzda_ob_SCR:drgDialogStart(drgDialog)
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


METHOD MZD_cistamzda_ob_SCR:ItemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  cKy     := strZero( MZDYHD->nROK,4)       +strZero( MZDYHD->nOBDOBI,2) + ;
                    strZero( MZDYHD->nOSCISPRAC,5) +strZero( MZDYHD->nPORPRAVZT,3)

  cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhd->nRok, mzdyhd->nDoklad})
  mzdyit->( ads_setAof( cFiltr), dbgoTop())

  if( mzdyhd->(eof()), ::oBtn_mzd_doklhrmzdo_scr:disable(), ::oBtn_mzd_doklhrmzdo_scr:enable() )

  if isObject(oxbp)
    m_file := lower(oxbp:cargo:cfile)

    do case
    case( m_file = 'mzdyhd' )
*      cky := Upper(mzdyhd->cDENIK) +StrZero(mzdyhd->ndoklad,10)
*      ucetpol  ->(mh_ordSetScope(cky))

      cfiltr := format( "( cdenik = 'MH' .or. cdenik = 'MN' .or. cdenik = 'MS' .or. cdenik = 'MC' ) .and. ndoklad = %%", ;
                      { mzdyhd->ndoklad } )
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
method mzd_cistamzda_ob_scr:mzd_doklhrmzdo_scr(drgDialog)
  local  othread
  local  filter, cky := strZero( mzdyhd->nrok,4)       +strZero( mzdyhd->nobdobi,2)   + ;
                        strZero( mzdyhd->nosCisPrac,5) +strZero( mzdyhd->nporPraVzt,3)

  msPrc_mo->( dbseek( cky,,'MSPRMO01'))

  filter := format("nrokObd = %% .and. nosCisPrac = %% .and. nporPraVzt = %%"  ;
                   , {mzdyhd->nrokObd, mzdyhd->nosCisPrac, mzdyhd->nporPraVzt})


  oThread := drgDialogThread():new()
  oThread:start( ,'mzd_doklhrmzdo_scr,' +filter +',' +cky, drgDialog)
return


method mzd_cistamzda_ob_scr:mzd_vypcistamzda_scr(drgDialog)
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


*
**  metody pro volání výkonných obrazovek
**  MZD
method mzd_cistamzda_ob_scr:mzd_tmpdovol_(drgDialog)
  local  othread
  local  cfiltr

//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')


  cFiltr := Format("nROK = %%", { ::rok})
  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())

  do while .not. mzdyhdd->(Eof())
    if mzdyhdd->( dbRlock())
      mzdyhdd->ndnyDovBPD := 0
      mzdyhdd->ndnyDovMPD  := 0

      cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhdd->nRok, mzdyhdd->nDoklad})
      mzdyitd->( ads_setAof( cFiltr), dbgoTop())
       do while .not. mzdyitd->(Eof())
         if mzdyitd->ndruhmzdy = 180
           mzdyhdd->ndnyDovBPD += mzdyitd->ndnydoklad
         endif
         if mzdyitd->ndruhmzdy = 181
           mzdyhdd->ndnyDovMPD += mzdyitd->ndnydoklad
         endif
         mzdyitd->( dbSkip())
       enddo
       mzdyitd->( ads_ClearAof())
       mzdyhdd->( dbUnlock())
    endif

    mzdyhdd->( dbSkip())
  enddo

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())

return


// pøepoèet zùstatkù dovolené zamìstnancù
method mzd_zustDovPrep_(drgDialog)
  local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
  local  dovBez := 0, dovMin := 0
  local  cerBez := 0, cerMin := 0
  local  cky
  local  newRok := 2016

  drgDBMS:open('msprc_mo',,,,,'msprc_moC')
  drgDBMS:open('msprc_mo',,,,,'msprc_moD')

  cfiltr := Format( "nrok = %% .and. nobdobi = %%", { 2015, 12})
  msprc_moc->( ads_setaof(cfiltr), dbGoTop())


  do while .not. msprc_moc ->( Eof())

      if msprc_moc->nTypPraVzt <> 5 .and. msprc_moc->nTypPraVzt <> 6      ;
                 .and. Empty( msprc_moc->dDatVyst)
        cky := "201601" + StrZero(msprc_moc->noscisprac,5)+StrZero(msprc_moc->nporpravzt,3)
        if msprc_mod->( dbSeek( cky ,,'MSPRMO17'))
          if msprc_mod->( dbRlock())

            msprc_mod->nDovBezNar := SysConfig( "Mzdy:nNarDovol")
            msprc_mod->nDovBezCer := 0
            msprc_mod->nDovBezZus := msprc_mod->nDovBezNar

            msprc_mod->nDovMinNar := msprc_moc ->nDovBezZus +msprc_moc->nDovMinZus
            msprc_mod->nDovMinCer := 0
            msprc_mod->nDovMinZus := msprc_mod->nDovMinNar

            msprc_mod->nDovZustat := msprc_mod->nDovBezZus +msprc_mod->nDovMinZus

            msprc_mod->nDoDBezNar := SysConfig( "Mzdy:nNarDovolD")
            msprc_mod->nDoDBezCer := 0
            msprc_mod->nDoDBezZus := msprc_mod->nDoDBezNar

            msprc_mod->nDoDMinNar := msprc_moc->nDoDBezZus
            msprc_mod->nDoDMinCer := 0
            msprc_mod->nDoDMinZus := msprc_mod->nDoDMinNar

            msprc_mod->nDoDZustat := msprc_mod->nDoDBezZus +msprc_mod->nDoDMinZus

            msprc_mod->nDovZustCe := msprc_mod->nDovZustat +msprc_mod->nDoDZustat
            msprc_mod->( dbUnLock())

          endif
        endif
      endif
      msprc_moc->( dbSkip())
    enddo

return self


/*
// pøepoèet zùstatkù dovolené zamìstnancù
method mzd_zustDovPrep_(drgDialog)
  local  cf := "nrok = %% .and. nobdobi <= %% .and. noscisprac = %% .and. nporpravzt = %%"
  local  dovBez := 0, dovMin := 0
  local  cerBez := 0, cerMin := 0
  local  cky

  drgDBMS:open('msprc_mo',,,,,'msprc_moC')
  drgDBMS:open('msprc_mo',,,,,'msprc_moD')
  drgDBMS:open('msprc_mo',,,,,'msprc_moM')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdc')

  cfiltr := Format( "nrok = %% .and. nobdobi = %%", { ::rok, ::obdobi})
  msprc_moc->( ads_setaof(cfiltr), dbGoTop())

  do while .not. msprc_moc ->( Eof())

    dovBez := dovMin := cerBez := cerMin := 0
    if msprc_moc ->( dbRlock())
      if mzdyhdd->( dbSeek( msprc_moc ->croobcpppv,,'MZDYHD08'))
        *
        if mzdyhdd->nobdobi > 1
          cfiltr := Format( cf, { mzdyhdd->nrok, mzdyhdd->nobdobi-1, mzdyhdd->noscisprac, mzdyhdd->nporpravzt })
          mzdyhdC->( ads_setaof(cfiltr), dbGoTop())
          mzdyhdC->( dbeval( { || (dovBez += mzdyhdC->nDnyDovBPD, dovMin += mzdyhdC->nDnyDovMPD)} ))
        endif

        if msprc_moD->( dbSeek( StrZero(msprc_moC->nrok,4)+ '01'+ StrZero(msprc_moC->noscisprac,5) + StrZero(msprc_moC->nporpravzt,3),,'MSPRMO01'))
          msprc_moC->nDovMinNar := msprc_moD->nDovMinNar
        endif

        msprc_moC->nDovMinCeO := 0
        msprc_moC->nDovMinCer := 0
        msprc_moC->nDovMinZus := msprc_moC->nDovMinNar

        msprc_moC->nDovBezCeO := 0
        msprc_moC->nDovBezCer := 0
        msprc_moC->nDovBezZus := msprc_moC->nDovBezNar

        if ( dovMin + mzdyhdd->nDnyDovMPD) = 0
          if (dovBez + mzdyhdd->nDnyDovBPD) <= msprc_moC->nDovMinNar
            msprc_moC->nDovMinCeO := mzdyhdd->nDnyDovBPD
            msprc_moC->nDovMinCer := dovBez + mzdyhdd->nDnyDovBPD
            msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
          else
            if dovBez <= msprc_moC->nDovMinNar .and. dovBez <> 0
              msprc_moC->nDovMinCeO := mzdyhdd->nDnyDovBPD - ((dovBez + mzdyhdd->nDnyDovBPD) - msprc_moC->nDovMinNar)
              msprc_moC->nDovMinCer := dovBez + msprc_moC->nDovMinCeO
              msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer

              msprc_moC->nDovBezCeO := mzdyhdd->nDnyDovBPD - msprc_moC->nDovMinCeO
              msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO
              msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR
            else
              if dovBez > 0 .and. msprc_moC->nDovMinNar = 0
                msprc_moC->nDovBezCeO := mzdyhdd->nDnyDovBPD
                msprc_moC->nDovBezCeR := msprc_moC->nDovBezCeO + dovBez
                msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR

              else
  //              msprc_moC->nDovMinCeO := msprc_moC->nDovMinNar
  //              msprc_moC->nDovMinCeR := msprc_moC->nDovMinCeO
                msprc_moC->nDovMinCeR := msprc_moC->nDovMinNar
                msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCeR

                msprc_moC->nDovBezCeO := mzdyhdd->nDnyDovBPD    //- msprc_moC->nDovMinCeO
                msprc_moC->nDovBezCeR := (msprc_moC->nDovBezCeO + dovBez) - msprc_moC->nDovMinCeR
                msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCeR

              endif
            endif
          endif
        else
          if mzdyhdd->nDnyDovMPD <> 0 .or. dovMin <> 0
            msprc_moC->nDovMinCeO := mzdyhdd->nDnyDovMPD
            msprc_moC->nDovMinCer := dovMin + msprc_moC->nDovMinCeO
            msprc_moC->nDovMinZus := msprc_moC->nDovMinNar - msprc_moC->nDovMinCer
          endif

          if mzdyhdd->nDnyDovBPD <> 0 .or. dovBez <> 0
            msprc_moC->nDovBezCeO := mzdyhdd->nDnyDovBPD
            msprc_moC->nDovBezCer := dovBez + msprc_moC->nDovBezCeO
            msprc_moC->nDovBezZus := msprc_moC->nDovBezNar - msprc_moC->nDovBezCer
          endif
        endif

        msprc_moC->nDovZustat := msprc_moC->nDovBezZus +msprc_moC->nDovMinZus
        msprc_moC->nDoDZustat := msprc_moC->nDoDBezZus +msprc_moC->nDoDMinZus

        msprc_moC->nDovNaroCe := msprc_moC->nDovMinNar+msprc_moC->nDovBezNar      ;
                                  +msprc_moC->nDoDMinNar+msprc_moC->nDoDBezNar

        msprc_moC->nDovCerOCe := msprc_moC->nDovMinCeO+msprc_moC->nDovBezCeO      ;
                                  +msprc_moC->nDoDMinCeO+msprc_moC->nDoDBezCeO

        msprc_moC->nDovCerRCe := msprc_moC->nDovMinCeR+msprc_moC->nDovBezCeR      ;
                                  +msprc_moC->nDoDMinCeR+msprc_moC->nDoDBezCeR

        msprc_moC->nDovZustCe := msprc_moC->nDovMinZus +msprc_moC->nDovBezZus     ;
                                  +msprc_moC->nDoDMinZus +msprc_moC->nDoDBezZus
      else
        if msprc_moM->( dbSeek( StrZero(msprc_moC->nrok,4)+ StrZero(msprc_moC->nobdobi-1,2)+ StrZero(msprc_moC->noscisprac,5) + StrZero(msprc_moC->nporpravzt,3),,'MSPRMO01'))
          msprc_moC->nDovMinCeO := 0
          msprc_moC->nDovMinCer := msprc_moM->nDovMinCer
          msprc_moC->nDovMinZus := msprc_moM->nDovMinZus

          msprc_moC->nDovBezCeO := 0
          msprc_moC->nDovBezCer := msprc_moM->nDovBezCer
          msprc_moC->nDovBezZus := msprc_moM->nDovBezZus

          msprc_moC->nDovZustat := msprc_moM->nDovZustat
          msprc_moC->nDoDZustat := msprc_moM->nDoDZustat

          msprc_moC->nDovCerOCe := 0
          msprc_moC->nDovCerRCe := msprc_moM->nDovCerRCe
          msprc_moC->nDovZustCe := msprc_moM->nDovZustCe
        endif
      endif
      msprc_moC ->( dbUnLock())
    endif
    msprc_moC->( dbSkip())
  enddo

  msprc_moC->(dbCloseArea())
  msprc_moD->(dbCloseArea())
  mzdyhdd->(dbCloseArea())
  mzdyhdC->(dbCloseArea())

return self
*/



*
**  metody pro volání výkonných obrazovek
**  MZD
method mzd_cistamzda_ob_scr:mzd_tmpPREPhd_(drgDialog)
  local  othread
  local  cfiltr

//  drgDBMS:open('DRUHYMZD')
  drgDBMS:open('MZDYHD',,,,,'mzdyhdd')
  drgDBMS:open('MZDYIT',,,,,'mzdyitd')


  cFiltr := Format("nROK = %%", { ::rok})
  mzdyhdd->( ads_setAof( cFiltr), dbgoTop())

  do while .not. mzdyhdd->(Eof())
    if mzdyhdd->( dbRlock())
      mzdyhdd->ndnynahrPN := 0
      mzdyhdd->nDnyNemoKD := 0
      mzdyhdd->nDnyNemoPD := 0
      mzdyhdd->nDnyVylocD := 0

      cFiltr := Format("nROK = %% .and. nDOKLAD = %%", { mzdyhdd->nRok, mzdyhdd->nDoklad})
      mzdyitd->( ads_setAof( cFiltr), dbgoTop())
       do while .not. mzdyitd->(Eof())
         if mzdyitd->ndruhmzdy >= 400 .and. mzdyitd->ndruhmzdy <= 499
           if mzdyitd->( dbRlock())
             mzdyitd->nDnyVylocD := mzdyitd->ndnyfondkd
           endif
           mzdyhdd->ndnynahrPN += mzdyitd->ndnydoklad
           mzdyhdd->nDnyNemoKD += mzdyitd->ndnyfondkd
           mzdyhdd->nDnyNemoPD += mzdyitd->ndnyfondpd
           mzdyhdd->nDnyVylocD += mzdyitd->nDnyVylocD
         endif
         mzdyitd->( dbSkip())
       enddo
       mzdyitd->( ads_ClearAof())
       mzdyitd->( dbUnlock())
       mzdyhdd->( dbUnlock())
    endif

    mzdyhdd->( dbSkip())
  enddo

  mzdyhdd->(dbCloseArea())
  mzdyitd->(dbCloseArea())

return