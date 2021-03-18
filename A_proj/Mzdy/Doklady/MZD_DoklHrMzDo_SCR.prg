#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch'
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_doklhrmzdo_SCR ****************************************************
CLASS MZD_doklhrmzdo_SCR FROM drgUsrClass, MZD_enableOrDisable_action
EXPORTED:

  METHOD  Init
  METHOD  InFocus
  METHOD  drgDialogStart, tabSelect
  METHOD  ImportMzLOld

  method  itemMarked

  method  mzd_pracKalendar_in
  method  mzd_importdokl_ML
  method  mzd_importdokl_DOCH
  method  mzd_newObdNemocHD
  method  mzd_genDoklZMasky

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
    local  retVal := ' '

    do case
    case mzdDavHd->nautoGen =  8   ;   retVal := 'T'
    case mzdDavHd->nautoGen =  7   ;   retVal := 'O'
    case mzdDavHd->nautoGen =  6   ;   retVal := 'D'
    case mzdDavHd->nautoGen =  5   ;   retVal := 'V'
    case mzdDavHd->nautoGen =  4   ;   retVal := 'K'
    case mzdDavHd->nautoGen =  3   ;   retVal := 'N'
    case mzdDavHd->nautoGen =  2   ;   retVal := 'P'
    case mzdDavHd->nautoGen =  1   ;   retVal := 'M'
    otherwise                      ;   retVal := ' '
    endcase

  return retVal


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::setSysFilter()

       ::isStart := .t.
       PostAppEvent(xbeBRW_ItemMarked,,, ::brow[1]:oxbp)
       return .t.

    case (nEvent = drgEVENT_APPEND .or. nEvent = drgEVENT_APPEND2) .and. ::tabNum = 6
      _clearEventLoop()
      return .t.

    case nEvent = drgEVENT_DELETE
      ::postDelete()
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

  inline method ebro_beforSaveEditRow( drgEBrowse )
    local  oDialog, nExit := drgEVENT_QUIT
    local  x, cvalue := ''
    *
    local  drgVar_nazPol1 := ::dm:has('mzdDavit->cnazPol1' )

    for x := 1 to 6 step 1
      cvalue += upper(::dm:get( 'mzdDavit->cnazPol' +str(x,1)))
    next

    do case
    case empty(cvalue)
      ok      := .t.
    otherwise
      ok      := c_naklST->(dbseek(cvalue,,'C_NAKLST1'))
      showDlg := .not. ok
    endcase

    if showDlg
      DRGDIALOG FORM 'c_naklst_sel' PARENT ::dm:drgDialog MODAL           ;
                                                          DESTROY         ;
                                                          EXITSTATE nExit ;
                                                          CARGO drgVar_nazPol1

      if nexit != drgEVENT_QUIT .or. ok
        for x := 1 to 6 step 1
          ::dm:set('mzdDavit->cnazPol' +str(x,1), DBGetVal('c_naklSt->cnazPol' +str(x,1)))
        next
        postAppEvent(xbeP_Keyboard,xbeK_ESC,,drgVar_nazPol1:odrg:oxbp)
        ok := .t.
      else
        ::df:setNextFocus('mzdDavit->cnazPol1',,.t.)
      endif
    endif
  return ok


  inline method ebro_saveEditRow(o_ebro)
    local  cky     := 'M' +uctOBDOBI:MZD:COBDOBI
    local  nrok    := uctOBDOBI:MZD:NROK
    local  nobdobi := uctOBDOBI:MZD:NOBDOBI
    local  anUCT   := {}
    local  odata   := o_EBro:odata
    local  cStatement, oStatement
    local  stmt    := "delete from ucetPol where nrok = %yyyy and nobdobi = %mm and culoha = 'M'"

    ucetSys_U->( DbSetScope( SCOPE_BOTH, 'U' +strZero(nrok,4)), dbGoTop())

    if ucetPol->( dbseek( cky,,'UCETPOL6' ))
      if odata:cnazPol1 <> mzdDavit->cnazPol1 .or. ;
         odata:cnazPol2 <> mzdDavit->cnazPol2 .or. ;
         odata:cnazPol3 <> mzdDavit->cnazPol3 .or. ;
         odata:cnazPol4 <> mzdDavit->cnazPol4 .or. ;
         odata:cnazPol5 <> mzdDavit->cnazPol5 .or. ;
         odata:cnazPol6 <> mzdDavit->cnazPol6

        cStatement := strTran( stmt      , '%yyyy', str(nrok   ,4))
        cStatement := strTran( cStatement, '%mm'  , str(nobdobi,2))

        oStatement := AdsStatement():New(cStatement, oSession_data)
        if oStatement:LastError > 0
        *  return .f.
        else
          oStatement:Execute( 'test', .f. )
        endif
        oStatement:Close()

        ucetPol->(dbUnlock(), dbCommit())

        *
        ** musíme zrušit príznak aktualizace
        if ucetSys_U->( dbseek( 'U' +strZero(nrok,4) +strZero(nobdobi,2) +'2'))
          do while .not. ucetSys_U->(eof())
            if( ucetSys_U->nAKTUc_KS = 2, AAdd(anUc, ucetSys_U->(recNo())), nil)
            ucetsys_U->(dbSkip())
          enddo

          if ucetSys_U->(sx_rlock(anUc))
            AEval(anUc, {|x| ( ucetSys_U->(dbGoTo(x))          , ;
                               ucetSys_U->nAKTUc_KS := 1       , ;
                               ucetSys_U->cuctKdo   := logOsoba, ;
                               ucetSys_U->ductDat   := date()  , ;
                               ucetSys_U->cuctCas   := time()    ) })
          endif
          ucetSys_U->(dbCommit(), dbUnlock(), dbClearScope())
        endif

      endif
    endif
  return .t.

hidden:
  var     dm, df
  var     tabNum, brow, pa_column_1, is_form_mzd_kmenove_scr, isStart
  var     butt_importdokl_ml
  var     obmp_isEdit, obmp_noEdit, o_tabOpravaNs, o_dbroOpravaNs
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
      ::drgDialog:set_prg_filter(cfiltr, 'mzddavhd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzddavhd', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'mzddavhd')

      mzddavhd->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif

    ::enableOrDisable_action()
  return self

  inline method enable_or_disable_OpravaNs()
    local  nrok    := uctOBDOBI:MZD:NROK
    local  nobdobi := uctOBDOBI:MZD:NOBDOBI
    local  lcan_Edit

    ucetSys_U->( dbseek( 'U' +strZero(nrok,4) +strZero(nobdobi,2)))
    lcan_Edit := ( mzdDavit->ndoklad <> 0 .and. .not. ucetSys_U->lzavren )

    ::o_tabOpravaNs:oxbp:setImage( if( lcan_Edit, ::obmp_isEdit, ::obmp_noEdit) )
    ::o_dbroOpravaNs:enabled_enter := lcan_Edit
  return self

ENDCLASS


METHOD MZD_doklhrmzdo_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('msPrc_mo')

  drgDBMS:open('MZDDAVHD')
  drgDBMS:open('MZDDAVIT')
  drgDBMS:open('c_naklST')
  drgDBMS:open('ucetsys',,,,,'ucetsys_U')  ;  ucetSys_U->( ordSetFocus( 'UCETSYS3' ))
  *
  drgDBMS:open('DRUHYMZD')

  ::tabnum                  := 1
  ::is_form_mzd_kmenove_scr := .f.
  ::isStart                 := .t.
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


METHOD MZD_doklhrmzdo_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD MZD_doklhrmzdo_SCR:drgDialogStart(drgDialog)
  local  nposIn
  local  ab := drgDialog:oActionBar:members    // actionBar

  ::dm          := drgDialog:dataManager       // dataMananager
  ::df          := drgDialog:oForm             // form

  ::obmp_isEdit := XbpBitMap():new():create()
  ::obmp_noEdit := XbpBitmap():new():create()
  ::obmp_isEdit:load( NIL, 510 )
  ::obmp_isEdit:TransparentClr := ::obmp_isEdit:GetDefaultBGColor()

  ::obmp_noEdit:load( NIL, 316 )
  ::obmp_noEdit:TransparentClr := ::obmp_noEdit:GetDefaultBGColor()
  *
  ** povolí nebo zakáže definované akce pro nastavené období - PRG se jmenuje stejnì
  ::MZD_enableOrDisable_action:init(drgDialog)
  *
  ::brow          := drgDialog:dialogCtrl:oBrowse
  ::mo_prac_filtr := ''

  ::o_tabOpravaNs  := atail(drgDialog:oForm:tabPageManager:members)
  ::o_dbroOpravaNs := atail(::brow)
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


METHOD MZD_doklhrmzdo_scr:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabNum := tabnum

  if ::tabNum = 5
    cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
    ucetpol  ->(mh_ordSetScope(cky))

    ::brow[4]:oxbp:refreshAll()
  endif

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.


method MZD_doklhrmzdo_scr:itemMarked(arowco,unil,oxbp)
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

       cfiltr := Format( cf, { mzdDavHd->nrokObd, mzddavHd->cdenik, mzdDavHd->ndoklad })
       mzddavit->(ads_setaof(cfiltr), dbGoTop())

       cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
       ucetpol  ->(mh_ordSetScope(cky))

     case( m_file = 'mzddavit' )
       cky := Upper(mzdDavIt->cDENIK) +StrZero(mzdDavIt->ndoklad,10) +strZero(mzdDavIt->nordItem,5)
       ucetpol  ->(mh_ordSetScope(cky))

     endcase
  endif

  if( ::isStart, ( ::enable_or_disable_OpravaNs(), ::isStart := .f. ), nil )
return self


METHOD MZD_doklhrmzdo_SCR:ImportMzLOld(drgDialog)
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
method MZD_doklhrmzdo_SCR:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_doklhrmzdo_SCR:mzd_importdokl_ml(drgDialog)
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
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_doklhrmzdo_SCR:mzd_importdokl_doch(drgDialog)
  local callFRM
  local key

  callFRM := 'MZD_importdokl_DOCH,1'

  if len(pa_initParam := listAsArray( drgDialog:initParam )) = 2
    key := StrZero(Val(substr(pa_initParam[2],10,12)),6) +  ;
            StrZero(Val(substr(pa_initParam[2],41,12)),5) +  ;
              StrZero(Val(substr(pa_initParam[2],72,7)),3)

    callFRM := 'MZD_importdokl_DOCH,2,' +key
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
method MZD_doklhrmzdo_SCR:mzd_newObdNemocHD()
  local  nsel
  local  filtr
  local  cf_it := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%", cfiltr_it
  local rok, mes
  local rokobd


  nsel := confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                      ;
                       'opravdu požadujete založit'                            +CRLF        + ;
                       'hlavièky pokraèujících nemocenek z pøedchozího období' +CRLF + CRLF + ;
                       'Budou dogenerovány jen neexistující doklady z pøedchozích dokladù !'                      , ;
                       'Založení pokraèujících nemocenek z pøedchozího období...'            , ;
                       XBPMB_YESNO                                                          , ;
                       XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)
  _clearEventLoop(.t.)


  if nsel = XBPMB_RET_YES
    rok     := uctOBDOBI:MZD:NROK
    mes     := uctOBDOBI:MZD:NOBDOBI
    rokobd  := (rok*100)+ mes

    drgDBMS:open('mzddavhd',,,,,'mzddavhdx')
    drgDBMS:open('mzddavhd',,,,,'mzddavhds')
    drgDBMS:open('mzddavit',,,,,'mzddavitx')

/*
    filtr     := Format("nROKOBD = %% .and. cDENIK = 'MN' .and. nautoGen = %%", {rokobd,1})
    mzddavhdx ->( ads_setaof( filtr), dbGoTop())

    mzddavhdx->( dbGoTop())
    do while .not. mzddavhdx->( eof())
      if mzddavhdx->( dbRlock())

        cfiltr_it := Format( cf_it, { mzdDavHdx->nrokObd, mzddavHdx->cdenik, mzdDavHdx->ndoklad })
        mzdDavitx->( ads_setaof(cfiltr_it), dbGoTop())
        mzdDavitx->( dbeval( { || if( mzdDavitx->( sx_Rlock()), mzdDavitx->(dbdelete()), nil ) } ) )
        mzdDavitx->( ads_clearAof(), dbunlock(), dbCommit() )

        mzddavhdx->( dbDelete())
        mzddavhd->( dbunlock())
      endif
      mzddavhdx ->( dbSkip())
    enddo
    mzddavhdx->( dbcommit() )
*/

    if  mes <> 1
      rokobd := (rok*100)+ mes-1
    else
      rokobd := ((rok-1)*100)+ 12
    endif
    filtr     := Format("nROKOBD = %% .and. cDENIK = 'MN'", {rokobd})
    mzddavhdx ->( ads_setaof( filtr), dbGoTop())

    do while .not. mzddavhdx->( eof())
      if Empty( mzddavhdx->dDatumDO)
        ckey := StrZero(rok,4)+StrZero(mes,2)   + ;
                StrZero(mzddavhdx->noscisprac,5) + ;
                StrZero(mzddavhdx->nporpravzt,3) + ;
                'MN' + StrZero(mzddavhdx->nporadi,6)

        if .not. mzddavhds->( dbSeek( ckey,,'MZDDAVHD26'))
          db_to_db( 'mzddavhdx','mzddavhd' )

          mzddavhd->nrok     := rok
          mzddavhd->nobdobi  := mes
          mzddavhd->cobdobi  := StrZero(mes,2)+'/'+Right(StrZero(rok,4),2)
          mzddavhd->nrokobd  := (rok*100)+mes
          mzddavhd->ndoklad  := fin_range_key('MZDDAVHD:MN')[2]
          mzddavhd->nautoGen := 1

          mzddavhd->croobcpppv := StrZero(rok,4)+StrZero(mes,2)  + ;
                                  StrZero(mzddavhd->noscisprac,5)+ ;
                                  StrZero(mzddavhd->nporpravzt,3)

          mzddavhd->crocpppv   := StrZero(rok,4)                 + ;
                                  StrZero(mzddavhd->noscisprac,5)+ ;
                                  StrZero(mzddavhd->nporpravzt,3)

          mzddavhd->ccpppv   :=   StrZero(mzddavhd->noscisprac,5)+ ;
                                  StrZero(mzddavhd->nporpravzt,3)

        endif
      endif

      mzddavhdx ->( dbSkip())
    enddo

    mzddavhdx ->( ads_clearAof() )
    mzddavhd->( dbunlock(), dbcommit() )
    ::brow[1]:oxbp:refreshAll()
  endif

RETURN self



method mzd_doklhrmzdo_scr:postDelete()
  local  nsel, nodel := .f.
  local  ndokladTM   := mzdDavHD->ndoklad
  local  pokrNEM     := .f.
  local  rok, mes, ckey
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
      if mzdDavHD->cdenik = 'MN'

        drgDBMS:open('mzddavhd',,,,,'mzddavhdx')
        rok     := uctOBDOBI:MZD:NROK
        mes     := uctOBDOBI:MZD:NOBDOBI

        if  mes <> 1
          rokobd := (rok*100)+ mes-1
        else
          rokobd := ((rok-1)*100)+ 12
        endif

        ckey := StrZero(rokobd,6) +                   ;
                  StrZero(mzddavhd->noscisprac,5) +   ;
                    StrZero(mzddavhd->nporpravzt,3) + ;
                     'MN' + StrZero(mzddavhd->nporadi,6)
        pokrNEM := if( mzddavhdx->( dbSeek( ckey,,'MZDDAVHD26')), Empty( mzddavhdx->dDatumDO), .f.)

      endif


      msPrc_mo->( dbseek( cky,,'MSPRMO01'))

      mzd_mzddavhd_cpy( self )
      nodel := .not. mzd_mzddavhd_del(self)

      if .not. nodel .and. pokrNEM
        db_to_db( 'mzddavhdx','mzddavhd' )
        mzddavhd->nrok     := rok
        mzddavhd->nobdobi  := mes
        mzddavhd->cobdobi  := StrZero(mes,2)+'/'+Right(StrZero(rok,4),2)
        mzddavhd->nrokobd  := (rok*100)+mes
        mzddavhd->ndoklad  := ndokladTM
        mzddavhd->nautoGen := 1

        mzddavhd->croobcpppv := StrZero(rok,4)+StrZero(mes,2)  + ;
                                StrZero(mzddavhd->noscisprac,5)+ ;
                                StrZero(mzddavhd->nporpravzt,3)

        mzddavhd->crocpppv   := StrZero(rok,4)                 + ;
                                StrZero(mzddavhd->noscisprac,5)+ ;
                                StrZero(mzddavhd->nporpravzt,3)

        mzddavhd->ccpppv   :=   StrZero(mzddavhd->noscisprac,5)+ ;
                                StrZero(mzddavhd->nporpravzt,3)

        mzddavhd->( dbunlock(), dbcommit() )
      endif
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



*
**  metoda pro generování dokladù z masky hromadnì za pracovníky
**  MZD
method MZD_doklhrmzdo_SCR:mzd_genDoklZMasky()
  local  nsel
  local  filtr
  local  cf_it := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%", cfiltr_it
  local rok, mes
  local rokobd
  local key


  nsel := confirmBox(, 'Požadujete hromadnì vygenerovat doklady'                     +CRLF        + ;
                       'z pøedefinovaných šablon-masek z kmenových údajù pracovníka' +CRLF + CRLF + ;
                       'Pozor, pokud již byly doklady z masek generovány budou generovány jen rozdílové øádky !', ;
                       'Generování dokladù z pøeddefinovaných šablon...'            , ;
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

    filtr   := Format("cTYPMASKY = '%%' .and. lAktivni", {'GENDO'})
    msmzdyhdx ->( ads_setaof( filtr), dbGoTop())

    filtr   := Format("nRokObd = %% ", {rokobd})
    mzddavhdx ->( ads_setaof( filtr), dbGoTop())
    mzddavitx ->( ads_setaof( filtr), dbGoTop())

    msmzdyhdx->( dbGoTop())
    do while .not. msmzdyhdx->( eof())
      if .not. mzddavhdx->( dbSeek( isNull( msmzdyhdx->sid, 0),,'nMSMZDYHD'))
        key := StrZero( rokobd,6) +StrZero(msmzdyhdx->noscisprac,5) +StrZero(msmzdyhdx->nporpravzt,3)
        if msprc_mox->( dbSeek( key,,'MSPRMO17'))
          if msprc_mox->lstavem     // msprc_mox->lAktivni
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
    mzddavhdx->( dbunlock() )
    mzddavhdx->( dbcommit() )

    mzddavitx ->( ads_clearAof() )
    mzddavhdx ->( ads_clearAof() )
    ::brow[1]:oxbp:refreshAll()
  endif

RETURN self