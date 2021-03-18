#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch'
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
*
** CLASS MZD_doklhrmzdo_SCR ****************************************************
CLASS MZD_doklhrmzpo_SCR FROM drgUsrClass
EXPORTED:

  METHOD  Init
  METHOD  InFocus
  METHOD  drgDialogStart, tabSelect
  METHOD  ImportMzLOld

  method  itemMarked

  method  mzd_pracKalendar_in
  method  mzd_importdokl_ML
  method  mzd_newObdNemocHD

  class   var mo_prac_filtr READONLY


  inline access assign method nazevDruhu_Mzdy() var nazevDruhu_Mzdy
    local cky := strZero(mzdDavIt->nrok,4) + ;
                  strZero(mzdDavIt->nobdobi,2) + ;
                   strZero(mzdDavIt->ndruhMzdy,4)

    druhyMzd->(dbseek( cky,, 'DRUHYMZD04'))
  return druhyMzd->cnazevDmz

  * položky - bro
  inline access assign method typDokladu() var typDokladu
    local  pa     := ::pa_column_1, npos
    local  retVal := 0

    if( npos := ascan( pa, { |x| x[1] = mzdDavHd->cdenik })) <> 0
      retVal := pa[npos,2]
    endif
    return retVal

  * nautoGen 0 - mzdy 5 - výroba 6 - docházka
  inline access assign method autoGen_From() var autoGen_From
    return if( mzdDavHd->nautoGen = 6, 'D', ;
            if( mzdDavHd->nautoGen = 5, 'V', if( mzdDavHd->ndoklad <> 0,  'M', ' ' )))


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::setSysFilter()
       PostAppEvent(xbeBRW_ItemMarked,,, ::brow[1]:oxbp)
       return .t.

//    case nEvent = drgEVENT_EDIT
//      ::postDelete()
//      return .t.

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.

    otherwise
      return .f.
    endcase
  return .f.


hidden:
  var     tabNum, brow, pa_column_1, is_form_mzd_kmenove_scr
  var     butt_importdokl_ml
  method  postDelete

  inline method setSysFilter( ini )
    local rok, mes
    local rokobd
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok     := uctOBDOBI:MZD:NROK
    mes     := uctOBDOBI:MZD:NOBDOBI
    rokobd  := (rok*100)+mes

    cfiltr  := Format("nROKOBD = %%", {rokObd}) + ::mo_prac_filtr

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'mzddavit')
    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzddavit', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      mzddavit->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif
  return self
ENDCLASS


METHOD MZD_doklhrmzpo_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('msPrc_mo')

  drgDBMS:open('MZDDAVHD')
  drgDBMS:open('MZDDAVIT')
  *
  drgDBMS:open('DRUHYMZD')

  ::tabnum                  := 1
  ::is_form_mzd_kmenove_scr := .f.
  ::pa_column_1             := { { sysConfig( 'mzdy:cdenikMZ_H'), 534 }, ;
                                 { sysConfig( 'mzdy:cdenikMZ_N'), 535 }, ;
                                 { sysConfig( 'mzdy:cdenikMZ_S'), 536 }  }

  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 3
    ::drgDialog:set_prg_filter(pa_initParam[2], 'mzddavhd')

    msPrc_mo->( dbseek( pa_initParam[3],,'MSPRMO01' ))
    ::is_form_mzd_kmenove_scr := .t.
  endif
RETURN self


METHOD MZD_doklhrmzpo_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD MZD_doklhrmzpo_SCR:drgDialogStart(drgDialog)
  local  nposIn
  local  ab := drgDialog:oActionBar:members    // actionBar
  *
  ::brow          := drgDialog:dialogCtrl:oBrowse
  ::mo_prac_filtr := ''
  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( drgDialog:initParam )) = 3
    ::mo_prac_filtr := ' .and. ' +pa_initParam[2]
    drgDialog:set_uct_ucetsys_inlib()
  endif

  if( nposIn := ascan( ab, { |s| s:event = 'mzd_importdokl_ml' } )) <> 0
    ::butt_importdokl_ml := ab[ nposIn ]
  endif

  ::setSysFilter( .t. )
RETURN self


METHOD MZD_doklhrmzpo_scr:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabnum := tabnum

  if ::tabNum = 2
    cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
    ucetpol  ->(mh_ordSetScope(cky))

    ::brow[2]:oxbp:refreshAll()
  endif

//  if(lrest,::brow[2]:oxbp:refreshAll(),nil)
RETURN .T.


method MZD_doklhrmzpo_scr:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr, cky
  *
  local  cf := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzddavhd' )
       if .not. ::is_form_mzd_kmenove_scr
         msPrc_mo->( dbseek( strZero( mzdDavhd->nrok,4)       +strZero( mzdDavhd->nobdobi,2)   + ;
                             strZero( mzdDavhd->nosCisPrac,5) +strZero( mzdDavhd->nporPraVzt,3),,'MSPRMO01' ))
       endif

**       cfiltr := Format( cf, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
**       mzddavit->(ads_setaof(cfiltr), dbGoTop())

       cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
       ucetpol  ->(mh_ordSetScope(cky))

     case( m_file = 'mzddavit' )
       mzddavhd ->( dbSeek( mzddavit->nmzddavhd,,'ID'))
       cky := Upper(mzdDavIt->cDENIK) +StrZero(mzdDavIt->ndoklad,10) +strZero(mzdDavIt->nordItem,5)
       ucetpol->(mh_ordSetScope( cky))

     endcase
  endif
return self


METHOD MZD_doklhrmzpo_SCR:ImportMzLOld(drgDialog)
  local cPath, cFile, cIndex
  local nrok, nobdobi, cobdobi
  local key

  cPath  := AllTrim( SysConfig( "System:cPathUcto"))
  IF( Right( cPath, 1) <> "\", cPath := cPath +"\", NIL)

  cIndex := cpath +'MzLiOld.cdx'

  if drgIsYESNO(drgNLS:msg('Exportovat mzdové lístky za [' +uctOBDOBI:MZD:COBDOBI +'] ?'))

    drgDBMS:open('listit')
    drgDBMS:open('vyrzak')

    nROK    := uctOBDOBI:MZD:NROK
    nOBDOBI := uctOBDOBI:MZD:NOBDOBI
    cOBDOBI := "'"+ uctOBDOBI:MZD:cOBDOBI +"'"

    cFiltr := Format( "cOBDOBI = %%", {cobdobi})
    listit->( ADS_SetAOF( cFiltr), dbGoTop())

    cFile  := cpath +'MzLiOld'
    listit->( AdsConvertTable( cFile, 1 ))

    cFile  := cpath +'VyrZaOld'
    vyrzak->( AdsConvertTable( cFile, 2 ))
  endif
RETURN nil

*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_doklhrmzpo_SCR:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self

*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_doklhrmzpo_SCR:mzd_importdokl_ml(drgDialog)
  local callFRM
  local key

  callFRM := 'MZD_importdokl_ML,1'

  if len(pa_initParam := listAsArray( drgDialog:initParam )) = 2
    key := StrZero(Val(substr(pa_initParam[2],10,12)),6) +  ;
            StrZero(Val(substr(pa_initParam[2],41,12)),5) +  ;
              StrZero(Val(substr(pa_initParam[2],72,7)),3)

    callFRM := 'MZD_importdokl_ML,2,' +key
  endif

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM callFRM PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area

  ::itemMarked(,,::brow[1]:oxbp)
  aeval( ::brow, { |o| o:oxbp:refreshAll() } )
RETURN self

*
**  metoda pro pomocné založení neuzavøených nemocenek pro nové období
**  MZD
method MZD_doklhrmzpo_SCR:mzd_newObdNemocHD()
  local filtr
  local rok, mes
  local rokobd

  rok     := uctOBDOBI:MZD:NROK
  mes     := uctOBDOBI:MZD:NOBDOBI
  rokobd  := (rok*100)+ mes


*  drgDBMS:open('mzddavhd')
  drgDBMS:open('mzddavhd',,,,,'mzddavhdx')

  filtr     := Format("nROKOBD = %% .and. cDENIK = 'MN'", {rokobd})
  mzddavhdx ->( ads_setaof( filtr), dbGoTop())

  mzddavhdx->( dbGoTop())
  do while .not. mzddavhdx->( eof())
    if mzddavhdx->( dbRlock())
      mzddavhdx->( dbDelete())
      mzddavhd->( dbunlock())
    endif
    mzddavhdx ->( dbSkip())
  enddo

  mzddavhdx->( dbcommit() )


  if  mes <> 1
    rokobd := (rok*100)+ mes-1
  else
    rokobd := ((rok-1)*100)+ 12
  endif
//  rokobd  := (rok*100)+ if( mes <> 1, mes-1, 12)
  filtr     := Format("nROKOBD = %% .and. cDENIK = 'MN'", {rokobd})
  mzddavhdx ->( ads_setaof( filtr), dbGoTop())

  mzddavhdx->( dbGoTop())

  do while .not. mzddavhdx->( eof())

    if Empty( mzddavhdx->dDatumDO)
      db_to_db( 'mzddavhdx','mzddavhd' )

      mzddavhd->nrok    := rok
      mzddavhd->nobdobi := mes
      mzddavhd->cobdobi := StrZero(mes,2)+'/'+Right(StrZero(rok,4),2)
      mzddavhd->nrokobd := (rok*100)+mes
      mzddavhd->ndoklad := fin_range_key('MZDDAVHD:MN')[2]

    endif

    mzddavhdx ->( dbSkip())
  enddo

  mzddavhd->( dbunlock(), dbcommit() )
  ::brow[1]:oxbp:refreshAll()

RETURN self


method mzd_doklhrmzpo_scr:postDelete()
  local  nsel, nodel := .f.
  local  cky         := strZero( mzdDavHD->nrok, 4)       + ;
                        strZero( mzdDavHD->nOBDOBI, 2)    + ;
                        strZero( mzdDavHD->noscisPrac, 5) + ;
                        strZero( mzdDavHD->nporPraVzt, 3)

  if mzd_postSave()
    nsel := ConfirmBox( ,'Požadujete zrušit mzdový doklad _' +alltrim(str(mzdDavhd->ndoklad)) +'_', ;
                         'Zrušení mzdového dokladu ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      msPrc_mo->( dbseek( cky,,'MSPRMO01'))

      mzd_mzddavhd_cpy( self )
      nodel := .not. mzd_mzddavhd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Mzdový doklad _' +alltrim(str(mzdDavhd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení mzdového dokladu ...' , ;
                 XBPMB_CANCEL                   , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


static function db_to_db(cDBfrom,cDBto)
  local aFrom := ( cDBFrom) ->( dbStruct())

  (cDBto)->(dbappend())
  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil