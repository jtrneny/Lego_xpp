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
** CLASS MZD_doklHrMzPr_SCR ****************************************************
CLASS MZD_doklhrmzpr_SCR FROM drgUsrClass, quickFiltrs, MZD_enableOrDisable_action
EXPORTED:
  method  Init
  method  drgDialogStart
  method  itemMarked
  method  mzd_importdokl_ml
  method  mzd_importdokl_doch
  method  mzd_genDoklZMasky

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

  * má definovanou automatickou matrici ?
  inline access assign method in_msMzdyhd() var in_msMzdyhd
    local cky := strZero( msPrc_mo->noscisPrac, 5) + ;
                  strZero( msPrc_mo->nporPraVzt,3) +'1'
    return if( msMzdyhd->( dbseek(cky,,'MSMZDYHD03')), MIS_ICON_OK, 0 )

  * mzdDavHd
  inline access assign method typDokladu() var typDokladu
    local  pa     := ::pa_column_1, npos
    local  retVal := 0

    if( npos := ascan( pa, { |x| x[1] = mzdDavHd->cdenik })) <> 0
      retVal := pa[npos,2]
    endif
    return retVal

  * nautoGen 0 - mzdy 1-nemoc 2-prémie 3-vyp.daò  4-gen.dok.mask 5-výroba 6-docházka 7-obìdy
  inline access assign method autoGen_From() var autoGen_From
    local  retVal := ' '

    do case
    case mzdDavHd->nautoGen  =  7   ;   retVal := 'O'
    case mzdDavHd->nautoGen  =  6   ;   retVal := 'D'
    case mzdDavHd->nautoGen  =  5   ;   retVal := 'V'
    case mzdDavHd->nautoGen  =  4   ;   retVal := 'K'
    case mzdDavHd->nautoGen  =  3   ;   retVal := 'N'
    case mzdDavHd->nautoGen  =  2   ;   retVal := 'P'
    case mzdDavHd->nautoGen  =  1   ;   retVal := 'M'
    otherwise                       ;   retVal := ' '
    endcase

  return retVal

  * mzdDavIt
  inline access assign method nazevDruhu_Mzdy() var nazevDruhu_Mzdy
    local cky := strZero(mzdDavIt->nrok,4) + ;
                  strZero(mzdDavIt->nobdobi,2) + ;
                   strZero(mzdDavIt->ndruhMzdy,4)

    druhyMzd->(dbseek( cky,, 'DRUHYMZD04'))
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
       ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo', .t.)

       * zmìna na < p >- programovém filtru
       ::quick_setFilter( , 'apuq' )

       ::enableOrDisable_action()
       return .t.

    otherwise
      return .f.
    endcase
  return .f.

  inline method mzd_import_vypDan()
    local  odialog, nexit := drgEVENT_QUIT

    odialog := drgDialog():new('mzd_vyucDane_imp',::drgDialog)
    odialog:create(,,.T.)

    ::itemMarked(,,::brow[1]:oxbp)
    aeval( ::brow, { |o| o:oxbp:refreshAll() } )
  return self

hidden:
  var  msg, brow, rok, obdobi
  var  cmain_Ky, butt_importdokl_ml
  var  pa_column_1

ENDCLASS


METHOD MZD_doklhrmzpr_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'msPrc_mo' )
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
  ::drgDialog:set_prg_filter( cfiltr, 'msprc_mo')
RETURN self


METHOD MZD_doklhrmzpr_SCR:drgDialogStart(drgDialog)
  local  nposIn
  local  ab := drgDialog:oActionBar:members    // actionBar

  *
  ** povolí nebo zakáže definované akce pro nastavené období - PRG se jmenuje stejnì
  ::MZD_enableOrDisable_action:init(drgDialog)
  *
  ::msg  := drgDialog:oMessageBar
  ::brow := drgDialog:dialogCtrl:oBrowse

  ::quickFiltrs:init( self                                             , ;
                      { { 'Kompletní seznam       ', ''            }, ;
                        { 'Pracovníci ve stavu    ', 'nstavem = 1' }, ;
                        { 'Pracovníci mimo stav   ', 'nstavem = 0' }  }, ;
                      'Zamìstnanci'                                      )

  if( nposIn := ascan( ab, { |s| s:event = 'mzd_importdokl_ml' } )) <> 0
    ::butt_importdokl_ml := ab[ nposIn ]
  endif

  ::enableOrDisable_action()
RETURN self


method MZD_doklHrMzPr_scr:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr
  local  rokobd := (::rok*100) + ::obdobi
  *
  local  cf_h := "nROKOBD = %% .and. noscisPrac = %% .and. nporPraVzt = %%"
  local  cf_i := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"
  *
  local  cmain_Ky := DBGetVal(::cmain_Ky), ok

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'msprc_mo' )
       cfiltr := Format( cf_h, { msPrc_mo->nrokObd, msPrc_mo->noscisPrac, msPrc_mo->nporPraVzt })
       mzdDavHd->(ads_setaof(cfiltr), dbGoTop())
       ::mo_prac_filtr := cfiltr

       cfiltr := Format( cf_i, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
       mzdDavIt->(ads_setaof(cfiltr), dbGoTop())

     case( m_file = 'mzddavhd' )
       cfiltr := Format( cf_i, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
       mzddavit->(ads_setaof(cfiltr), dbGoTop())

     endcase
  endif

  * tlaèítko mzd_importdokl_ml
  ok :=( listit->( dbseek( cmain_Ky,,'LISTI22')) .and. ::mzd_is_open )
  ::butt_importdokl_ml:disabled := .not. ok
  if( ok, ::butt_importdokl_ml:oxbp:enable(), ::butt_importdokl_ml:oxbp:disable() )
return self


*
**  metoda pro volání importu mzdových lístkù
**  MZD
method MZD_doklhrmzpr_SCR:mzd_importdokl_ml(parent)
  local callFRM := 'MZD_importdokl_ml,4'

  if empty( ::brow[1]:arselect) .and. .not.::brow[1]:is_selAllRec
    callFRM := 'MZD_importdokl_ml,3'
  endif

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM callFRM PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                   // Restore work area

  ::itemMarked(,,::brow[1]:oxbp)
  aeval( ::brow, { |o| o:oxbp:refreshAll() }, 2 )
RETURN self


*
**  metoda pro volání importu mzdových lístkù
**  MZD
method MZD_doklhrmzpr_SCR:mzd_importdokl_doch(parent)
  local callFRM := 'MZD_importdokl_doch,4'

  if empty( ::brow[1]:arselect) .and. .not.::brow[1]:is_selAllRec
    callFRM := 'MZD_importdokl_doch,3'
  endif

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM callFRM PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                   // Restore work area

  ::itemMarked(,,::brow[1]:oxbp)
  aeval( ::brow, { |o| o:oxbp:refreshAll() }, 2 )
RETURN self



*
**  metoda pro generování dokladù z masky za pracovníka
**  MZD
method MZD_doklhrmzpr_SCR:mzd_genDoklZMasky()
  local  nsel
  local  filtr
  local  cf_it := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%", cfiltr_it
  local rok, mes
  local rokobd
  local key


  nsel := confirmBox(, 'Požadujete vygenerovat za pracovníka doklady'                +CRLF        + ;
                       'z pøedefinovaných šablon-masek z kmenových údajù pracovníka' +CRLF + CRLF + ;
                       'Pozor, pokud již byly doklady z masek generovány budou generovány jen rozdílové øádky !', ;
                       'Genrování dokladù z pøeddefinovaných šablon...'            , ;
                       XBPMB_YESNO                                                          , ;
                       XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
  _clearEventLoop(.t.)


  if nsel = XBPMB_RET_YES
    rok     := uctOBDOBI:MZD:NROK
    mes     := uctOBDOBI:MZD:NOBDOBI
    rokobd  := (rok*100)+ mes
    drgDBMS:open('mzddavhd',,,,,'mzddavhdx')
    drgDBMS:open('mzddavit',,,,,'mzddavitx')
    drgDBMS:open('msmzdyhd',,,,,'msmzdyhdx')
    drgDBMS:open('msmzdyit',,,,,'msmzdyitx')
    drgDBMS:open('msprc_mo',,,,,'msprc_mox')

    filtr   := Format("nRokObd = %%", {rokobd})
    mzddavhdx ->( ads_setaof( filtr), dbGoTop())
    mzddavitx ->( ads_setaof( filtr), dbGoTop())

    fordRec( {'msprc_mo'} )

    do case
    case ::brow[1]:is_selAllRec
      msprc_mo->( dbGoTop())
      do while .not. msprc_mo->( Eof())
        genDoklMask(rokobd)
        msprc_mo->( dbSkip())
      enddo

    case len( ::brow[1]:arSelect) <> 0
      for x := 1 to len(::oDBro_main:arSelect) step 1
        msprc_mo->( dbgoTo( ::oDBro_main:arSelect[x]))
        genDoklMask(rokobd)
      next
    otherWise
      genDoklMask(rokobd)
    endcase

    fordRec()

    mzddavitx ->( ads_clearAof() )
    mzddavhdx ->( ads_clearAof() )
    ::brow[1]:oxbp:refreshAll()
  endif

RETURN self


STATIC FUNCTION genDoklMask( rokobd)
  local  key
  local  filtr

    filtr   := Format("nOSCISPRAC = %% .and. nPORPRAVZT = %% .and. cTYPMASKY = '%%' .and. lAktivni", {msprc_mo->noscisprac,msprc_mo->nporpravzt,'GENDO'})
    msmzdyhdx ->( ads_setaof( filtr), dbGoTop())

    msmzdyhdx->( dbGoTop())
    do while .not. msmzdyhdx->( eof())
      if .not. mzddavhdx->( dbSeek( isNull( msmzdyhdx->sid, 0),,'nMSMZDYHD'))
        key := StrZero( rokobd,6) +StrZero(msmzdyhdx->noscisprac,5) +StrZero(msmzdyhdx->nporpravzt,3)
        if msprc_mox->( dbSeek( key,,'MSPRMO17'))
          if msprc_mox->lAktivni
            mh_copyfld('msprc_mox','mzddavhdx',.t.)
            mzddavhdx ->cdenik     := msmzdyhdx ->cdenik
            mzddavhdx ->ctypDoklad := msmzdyhdx ->ctypDoklad
            mzddavhdx ->ctypPohybu := msmzdyhdx ->ctypPohybu
            mzddavhdx ->ndoklad    := fin_range_key('MZDDAVHD:MH')[2]
            mzddavhdx ->ddatPoriz  := date()
            mzddavhdx ->nautoGen   := msmzdyhdx ->nautogen
        *
            mzddavhdx->nmsmzdyhd := isNull( msmzdyhdx->sid, 0)

            filtr   := Format("nmsmzdyhd = %% .and. lAktivni", {isNull( msmzdyhdx->sid,0)})
            msmzdyitx ->( ads_setaof( filtr), dbGoTop())

            msmzdyitx->( dbGoTop())
            do while .not. msmzdyitx->( eof())
              if .not. mzddavitx->( dbSeek( isNull( msmzdyitx->sid, 0),,'nMSMZDYIT'))
                mh_copyfld('msmzdyitx','mzddavitx',.t.)
                mzddavitx->nrok       := mzddavhdx->nrok
                mzddavitx->nobdobi    := mzddavhdx->nobdobi
                mzddavitx->nrokobd    := mzddavhdx->nrokobd
                mzddavitx->cobdobi    := mzddavhdx->cobdobi
                mzddavitx->ndoklad    := mzddavhdx->ndoklad

                mzddavitx->croobcpppv := mzddavhdx->croobcpppv
                mzddavitx->crocpppv   := mzddavhdx->crocpppv
                mzddavitx->nmsmzdyit  := isNull( msmzdyitx->sid, 0)
              endif
              mzddavitx->( dbcommit() )
              mzddavitx->( dbunlock() )
              msmzdyitx->( dbSkip())
            enddo

            msmzdyitx ->( ads_clearAof() )
          endif
        endif
      endif

      msmzdyhdx->( dbSkip())
    enddo
    mzddavhdx->( dbunlock())
    mzddavhdx->( dbcommit())
    msmzdyhdx->( ads_clearAof())

RETURN .t.