#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "gra.ch"
#include "Xbp.ch"
#include "dll.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
//
#include "DRGres.Ch'

#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_mzpnatuo_IN ****************************************************
CLASS MZD_mzpnatuo_IN FROM drgUsrClass, MZD_enableOrDisable_action
EXPORTED:

  METHOD  Init
  METHOD  InFocus
  METHOD  drgDialogStart

  method  itemMarked

  method  mzd_pracKalendar_in
  method  mzd_podklady_NATURALIE
  method  mzd_import_NATURALIE
  method  gen_podklady
  method  gen_doklady

  class   var mo_prac_filtr READONLY


  inline access assign method nazevDruhu_Mzdy() var nazevDruhu_Mzdy
    local cky := strZero(mzdDavIt->nrok,4) + ;
                  strZero(mzdDavIt->nobdobi,2) + ;
                   strZero(mzdDavIt->ndruhMzdy,4)

    druhyMzd->(dbseek( cky,, 'DRUHYMZD04'))
  return druhyMzd->cnazevDmz

  * položky - bro
  inline access assign method is_genDoklad() var is_genDoklad
    return if( mzpnatuo->nMZDDAVIT <> 0, MIS_CHECK_BMP, 0)

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

  inline method copyfldto_w(from_db,to_db,app_db)
    local  npos, xval, afrom := (from_db)->(dbstruct()), x
    *
    local  citem

    if(isnull(app_db,.f.),(to_db)->(dbappend()),nil)
    for x := 1 to len(afrom) step 1
      citem := to_Db +'->' +(to_Db)->(fieldName(x))

      if .not. (lower(afrom[x,DBS_NAME]) $ 'nmzda,_nrecor,_delrec,nautogen')
        xval := (from_db)->(fieldget(x))
        npos := (to_db)->(fieldpos(afrom[x,DBS_NAME]))

        if(npos <> 0, (to_db)->(fieldput(npos,xval)), nil)
      endif
    next
  return nil



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
      if .not. mzPnatuo->( eof()) .and. mzd_postSave()
        ::postDelete()
      endif
      return .t.

    otherwise
      return .f.
    endcase
  return .f.

  inline method mzd_aktualizuj_Naturalie()
    local  odialog, nexit := drgEVENT_QUIT

//    odialog := drgDialog():new('mzd_vyucDane_imp',::drgDialog)
//    odialog:create(,,.T.)

    ::itemMarked(,,::brow[1]:oxbp)
    aeval( ::brow, { |o| o:oxbp:refreshAll() } )
  return self

  inline method ebro_beforSaveEditRow( drgEBrowse )
    local  oDialog, nExit := drgEVENT_QUIT
    local  x, cvalue := ''
    local  ok := .t.
    *
*    local  drgVar_nazPol1 := ::dm:has('mzdDavit->cnazPol1' )

/*
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
*/
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

/*
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

*/
  return .t.

hidden:
  var     dm, df, xbp_therm
  var     tabNum, brow, pa_column_1, is_form_mzd_kmenove_scr, isStart
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
      ::drgDialog:set_prg_filter(cfiltr, 'mzpnatuo')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzpnatuo', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'mzpnatuo')

      mzpnatuo->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif

    ::enableOrDisable_action()
  return self

/*
   inline method enable_or_disable_OpravaNs()
    local  nrok    := uctOBDOBI:MZD:NROK
    local  nobdobi := uctOBDOBI:MZD:NOBDOBI
    local  lcan_Edit

    ucetSys_U->( dbseek( 'U' +strZero(nrok,4) +strZero(nobdobi,2)))
    lcan_Edit := ( mzdDavit->ndoklad <> 0 .and. .not. ucetSys_U->lzavren )

    ::o_tabOpravaNs:oxbp:setImage( if( lcan_Edit, ::obmp_isEdit, ::obmp_noEdit) )
    ::o_dbroOpravaNs:enabled_enter := lcan_Edit
  return self
*/

ENDCLASS


METHOD MZD_mzpnatuo_IN:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('msPrc_mo',,,,,'msPrc_mow')

  drgDBMS:open('MZDDAVHD')
  drgDBMS:open('MZDDAVIT')
  drgDBMS:open('c_naklST')
  drgDBMS:open('ucetsys' ,,,,,'ucetsys_U')  ;  ucetSys_U->( ordSetFocus( 'UCETSYS3' ))
  drgDBMS:open('mzpnatuo',,,,,'mzpnatuoS')
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

    msPrc_mow->( dbseek( pa_initParam[3],,'MSPRMO01' ))
    ::is_form_mzd_kmenove_scr := .t.
  endif
RETURN self


METHOD MZD_mzpnatuo_IN:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD MZD_mzpnatuo_IN:drgDialogStart(drgDialog)
  local  nposIn
  local  ab := drgDialog:oActionBar:members    // actionBar

  ::dm          := drgDialog:dataManager       // dataMananager
  ::df          := drgDialog:oForm             // form
  ::xbp_therm   := drgDialog:oMessageBar:msgStatus

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


/*
METHOD MZD_mzpobedo_IN:tabSelect(oTabPage,tabnum)
 local lrest := (tabNum = 2)

  ::tabNum := tabnum

  if ::tabNum = 5
    cky := Upper(mzdDavHd->cDENIK) +StrZero(mzdDavHd->ndoklad,10)
    ucetpol  ->(mh_ordSetScope(cky))

    ::brow[4]:oxbp:refreshAll()
  endif

  if(lrest,::brow[3]:oxbp:refreshAll(),nil)
RETURN .T.
*/


method MZD_mzpnatuo_IN:itemMarked(arowco,unil,oxbp)
  local  m_file, cfiltr, cky
  *
  local  cf := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzddavhd' )
       if .not. ::is_form_mzd_kmenove_scr
         msPrc_mow->( dbseek( strZero( mzdDavhd->nrok,4)       +strZero( mzdDavhd->nobdobi,2)   + ;
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

*  if( ::isStart, ( ::enable_or_disable_OpravaNs(), ::isStart := .f. ), nil )
return self

/*
METHOD MZD_obedy_obd_IN:ImportMzLOld(drgDialog)
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
*/


*
**  metoda pro volání pracovního kalendáøe
**  MZD
method MZD_mzpnatuo_IN:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


*
**  metoda pro vytváøení podkladù pro naturálie
**  MZD
method MZD_mzpnatuo_IN:mzd_podklady_NATURALIE(drgDialog)
  local callFRM
  local key

    nsel := ConfirmBox( ,'Požadujete provést vytvoøení podkladù pro naturálie z kmenových údajù', ;
                         'Provádí se generování podkladù ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      ::gen_podklady()
    endif

  ::itemMarked(,,::brow[1]:oxbp)
  aeval( ::brow, { |o| o:oxbp:refreshAll() } )
RETURN self



method MZD_mzpnatuo_IN:gen_podklady()
  local  arecs  := {}, nhodnota := 0
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  zuctovano
  local  cfg_lAuKmStroj := sysConfig( "Mzdy:lAuKmStroj")
  local  rok, mes, rokobd
  local  cenaNatur := sysConfig( "Mzdy:nCenaNatur")
  local  cfiltr

  * pro bìžné poøízení

  drgDBMS:open('msPrc_mo',,,,,'msPrc_mop')
  drgDBMS:open('mzPNatuo',,,,,'mzPNatuop')

  rok     := uctOBDOBI:MZD:NROK
  mes     := uctOBDOBI:MZD:NOBDOBI
  rokobd  := (rok*100)+mes


  cfiltr  := Format("nROKOBD = %%", {rokObd})
  mzPNatuop->( ADS_SetAOF( cFiltr), dbGoTop())
   do while .not. mzPNatuop->( Eof())
     if mzPNatuop->( RLock())
       mzPNatuop->( dbDelete())
       mzPNatuop->( dbUnLock())
     endif
     mzPNatuop->( dbSkip())
   enddo
  mzPNatuop->( ADS_ClearAOF(), dbGoTop())


  cfiltr  := Format("nROKOBD = %% and nNarokNatu > 0", {rokObd})
  msPrc_mop->( ADS_SetAOF( cFiltr), dbGoTop())

  do while .not. msPrc_mop->( Eof())
    mh_copyFld( 'msPrc_mop', 'mzPNatuop', .t. )
    mzPNatuop->nCenaJedn  := cenaNatur
    mzPNatuop->nMnozst    := msPrc_mop->nNarokNatu
    mzPNatuop->nMnozstUp  := msPrc_mop->nNarokNatu
    mzPNatuop->cZkratJedn := msPrc_mop->cZkrJedNat
    mzPNatuop->nCenaCelk  := mzPNatuop->nMnozstUp * mzPNatuop->nCenaJedn
    mzPNatuop->nMSPRC_MO  := isNull( msPrc_mop->sID, 0)

    msPrc_mop->( dbSkip())
  enddo

  msPrc_mop->( ADS_ClearAOF(), dbGoTop())

RETURN self


*
**  metoda pro vytváøení dokladù do pro srážku za obìdy
**  MZD
method MZD_mzpnatuo_IN:mzd_import_NATURALIE(drgDialog)
  local callFRM
  local key

/*
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
*/

    nsel := ConfirmBox( ,'Požadujete provést vytvoøení srážkových dokladù z podkladù pro naturálie', ;
                         'Provádí se generování dokladù ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      ::gen_doklady()
    endif

  ::itemMarked(,,::brow[1]:oxbp)
  aeval( ::brow, { |o| o:oxbp:refreshAll() } )
RETURN self



method MZD_mzpnatuo_IN:gen_doklady()
  local  arecs  := {}, nhodnota := 0
  local  nrecCnt, nkeyCnt, nkeyNo := 1
  local  zuctovano
  local  cfg_lAuKmStroj := sysConfig( "Mzdy:lAuKmStroj")

  * pro bìžné poøízení
  drgDBMS:open('MZDDAVHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  do case
  case ::Brow[1]:is_selAllRec
    mzPnatuo->( dbgoTop())

  case len( ::Brow[1]:arSelect) <> 0
    fordRec( {'mzpnatuo'} )

    for x := 1 to len( ::Brow[1]:arSelect) step 1
      mzpnatuo->( dbgoTo( ::Brow[1]:arSelect[x]))
      aadd( aRecs, mzpnatuo->( recNo()) )
    next
    fordRec()
    mzpnatuo->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )

  otherWise
    aadd( aRecs, mzpnatuo->( recNo()) )
    mzpnatuo->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )
  endcase

  mzdDavhdw->( dbappend())
  mzdDavitw->( dbappend())

  nrecCnt := mzpnatuo->( ads_getKeyCount(1))
  nkeyCnt := nrecCnt

  do while .not. mzpnatuo->( eof())
    if mzpnatuo->nCenaCelk <> 0
      msPrc_moW->( dbseek( mzpnatuo->nMSPRC_MO,, 'ID'))
      ::copyFldto_W( 'msPrc_moW', 'mzdDavhdw' )
      *
      ** naplníme hlavièku
      mzdDavhdw ->ctask      := 'MZD'
      mzdDavhdw ->culoha     := "M"
      mzdDavhdw ->cdenik     := 'MS'
  //    mzdDavhdw ->nRok       := ::nrok
  //    mzdDavhdw ->nObdobi    := ::nobdobi
  //    mzdDavhdw ->cObdobi    := ::cobdobi
      mzdDavhdw ->nRokObd    := (mzdDavhdw ->nROK *100)+mzdDavhdw ->nOBDOBI

      mzdDavhdw ->cRoObCpPPv := StrZero(mzdDavhdw->nrokobd,6)+StrZero(msPrc_moW->noscisprac,5) +;
                                +StrZero(msPrc_moW->nporpravzt,3)
      mzdDavhdw->cRoCpPPv    := StrZero(mzdDavhdw->nrok,4)+StrZero(msPrc_moW->noscisprac,5) +;
                                +StrZero(msPrc_mow->nporpravzt,3)
      mzdDavhdw->cCpPPv      := StrZero(msPrc_mow->noscisprac,5) +StrZero(msPrc_mow->nporpravzt,3)

      mzdDavhdw ->ctypDoklad := 'MZD_SRAZKY'
      mzdDavhdw ->ctypPohybu := 'SRAZKA'
      mzdDavhdw ->ndoklad    := fin_range_key('MZDDAVHD:MS')[2]
      mzdDavhdw ->ddatPoriz  := date()
      mzdDavhdw ->nMZPNATUO  := isNull( mzpnatuo->sID, 0)
      mzdDavhdw ->nautoGen   := 8
      *
      ** Automaticky dotahovat kmenové støedisko stroje
      if( .not. cfg_lAuKmStroj, mzdDavhdw->ckmenStrSt := msPrc_moW->ckmenStrPr, nil )
      *
      ** naplníme položku bude jen jedna
      ::copyFldto_W( 'mzdDavhdw', 'mzdDavitw' )

      nhodnota := mzpnatuo->nCenaCelk

      mzdDavitw->nordItem    := 10
      mzdDavitw->ndruhMzdy   := 563
      mzdDavitw->nsazbaDokl  := nhodnota
      mzdDavitw->nMzda       := mzdDavitw->nsazbaDokl
      mzdDavitw->nHrubaMzd   := mzdDavitw->nMzda
      mzdDavitw->nMZPNATUO   := isNull( mzpnatuo->sID, 0)

      * pro generování pøíkazu k úhradì
      druhyMzd->( dbseek( strZero(mzdDavhdw ->nRok,4) +strZero(mzdDavhdw ->nObdobi,2) +strZero(mzdDavitw->ndruhMzdy,4),,'DRUHYMZD04'))

      mzdDavitw->ctypPohZav  := druhyMzd->ctypPohZav
      mzdDavitw->cZkratStat  := SysConfig( 'System:cZkrStaOrg' )
      mzdDavitw->czkratMeny  := SysConfig( 'Finance:cZaklMENA' )
      mzdDavitw->czkratMenZ  := SysConfig( 'Finance:cZaklMENA' )
      mzdDavitw->nMNOZPREP   := 1
      mzdDavitw->nKURZAHMEN  := 1

      * modifikace položky pøed nápoètem
      mzdDavitw->cucetskup  := allTrim( Str( mzdDavitw->ndruhMzdy))
      mzdDavItw->nzaklSocPo := 0
      mzdDavItw->nzaklZdrPo := 0

      mzd_mzddavhd_cmp(.t.)
      mzdDavhdw->( dbcommit())
      mzdDavitw->( dbcommit())
      *
      ** uložíme do dat originálu
      if mzpnatuo->( sx_RLock())
        mh_copyFld( 'mzdDavhdw', 'mzdDavhd', .t. )
        mh_copyFld( 'mzdDavitw', 'mzdDavit', .t. )

        mzdDavhd->( dbUnlock(), dbCommit())
        mzdDavit->( dbUnlock(), dbCommit())

        mzpnatuo->nMZDDAVHD := isNull( mzdDavhd->sID, 0)
        mzpnatuo->nMZDDAVIT := isNull( mzdDavit->sID, 0)

        mzpnatuo->( dbUnlock(), dbCommit())
      endif
    endif
    mzpnatuo->( dbskip())

    nkeyNo++
    if( mzpnatuo->(eof()), nkeyno := nkeyCnt, nil )
    fin_bilancew_pb(::xbp_therm, nkeycnt, nkeyno)
  enddo

  if( .not. empty( mzpnatuo->( ads_getAof())), mzpnatuo->( ads_clearAof()), nil )
  ::Brow[1]:oxbp:refreshAll()

  confirmBox(, 'Dobrý den p. ' +logOsoba +CRLF +                                     ;
               'Probìhlo generování mzdových dokladù z podkladù pro obìdy ...' , ;
               'Dokonèeno generování dokladù ...'                                  , ;
                XBPMB_OK                                                           , ;
                XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE                         )
  _clearEventLoop(.t.)

  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
return self


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


method mzd_mzpnatuo_IN:postDelete()
  local  nsel, nodel := .f.
  local  ndel  := 0
  local  arecs := {}
  local  arSelect := ::Brow[1]:arSelect
  local  cFiltr   := mzpnatuo->( ads_getAof())

  do case
  case      ::Brow[1]:is_selAllRec
    ok := mzpnatuoS->(Flock())
    mzpnatuoS->( ads_setAof(cFiltr), dbgoTop() )
  case len( arSelect) <> 0
    ok := mzpnatuoS->( sx_Rlock( arSelect ))
    mzpnatuoS->( ads_setAof(".f."), ads_customizeAof( arSelect,1), dbgoTop() )
  otherwise
    ok := mzpnatuoS->( sx_Rlock( { mzpnatuo->( recNo()) } ))
    mzpnatuoS->( ads_setAof(".f."), ads_customizeAof( { mzpnatuo->( recNo())} ,1), dbgoTop() )
  endcase


  if ok
    nsel := ConfirmBox( ,'Požadujete zrušit podklady za obìdy pro mzdy', ;
                         'Zrušení podkladù pro mzdy ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      do while .not. mzpnatuoS->( Eof())
        if .not. mzddavhd->( dbSeek( isNull( mzPobedoS->sid, 0),,'ID'))
          mzpnatuoS->( dbDelete())
        else
          nDel++
        endif
        mzpnatuoS->( dbSkip())
      enddo
    endif

  else
    ConfirmBox( ,'Podklad nelze zrušit', ;
                 'Zrušení mzdového podkladu ...' , ;
                 XBPMB_CANCEL                   , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  mzpnatuoS->( dbUnlock(), dbCommit(),ads_ClearAof(), dbgotop())

  if ndel > 0
    ctext := if( ndel > 1, "Nìkteré podklady", "Podklad")
    ConfirmBox( ,cText +' nelze zrušit existují vygenerované srážky ve mzdách ...', ;
                 'Zrušení podkladu pro obìdy ...' , ;
                 XBPMB_CANCEL                   , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
  ::drgDialog:dialogCtrl:refreshPostDel()



/*
  if mzd_postSave()

    nsel := ConfirmBox( ,'Požadujete zrušit podklady za obìdy pro mzdy', ;
                         'Zrušení podkladù pro mzdy ...' , ;
                          XBPMB_YESNO                   , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, XBPMB_DEFBUTTON2)

    if nsel = XBPMB_RET_YES
      filtr := mzpobedo->( ads_getAof())
      do case
      case ::Brow[1]:is_selAllRec
        mzpobedo->( dbgoTop())

      case len( ::Brow[1]:arSelect) <> 0
        fordRec( {'mzpobedo'} )

        for x := 1 to len( ::Brow[1]:arSelect) step 1
          mzpobedo->( dbgoTo( ::Brow[1]:arSelect[x]))
          aadd( aRecs, mzpobedo->( recNo()) )
        next
        fordRec()
        mzpobedo->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )

      otherWise
        aadd( aRecs, mzpobedo->( recNo()) )
        mzpobedo->( ads_setAof(".f."), ads_customizeAof( aRecs,1), dbgoTop() )
      endcase

      do while .not. mzpobedo->( Eof())
        if .not. mzddavhd->( dbSeek( mzpobedo->sid,,'ID'))
          if( mzpobedo->( dbRLock()), mzpobedo->( dbDelete(), dbUnLock()), nil)
        else
          nDel++
        endif
        mzpobedo->( dbSkip())
      enddo
    else

    endif
    mzpobedo->( dbCommit())
    mzpobedo->( ads_ClearAof())
    mzpobedo->( ads_setAof(filtr))
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Podklad nelze zrušit', ;
                 'Zrušení mzdového podkladu ...' , ;
                 XBPMB_CANCEL                   , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  if ndel > 0
    ctext := if( ndel > 1, "Nìkteré podklady", "Podklad")
    ConfirmBox( ,cText +' nelze zrušit existují vygenerované srážky ve mzdách ...', ;
                 'Zrušení podkladu pro obìdy ...' , ;
                 XBPMB_CANCEL                   , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif


  ::drgDialog:dialogCtrl:refreshPostDel()
*/
return .not. nodel


static function db_to_db(cDBfrom,cDBto)
  local aFrom := ( cDBFrom) ->( dbStruct())

  (cDBto)->(dbappend())
  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil