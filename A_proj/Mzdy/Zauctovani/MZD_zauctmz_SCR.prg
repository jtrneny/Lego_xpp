#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
#include "dbstruct.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


static b_mzdyhd, b_mzdyit

# define  stmt_mzdDavhd  ;
                         "select cdenik, ctypDoklad, ctypPohybu "           + ;
                                "from mzddavhd "                            + ;
                                "where ( nrok = %yyyy and nobdobi = %mm ) " + ;
                                "group by cdenik, ctypDoklad, ctypPohybu "  + ;
                                "order by cdenik, ctypDoklad, ctypPohybu"


# define  stmt_mzdDavit ;
            "select cdenik, ctypDoklad, ctypPohybu, ndruhMzdy, cNazPol1, cNazPol2, cNazPol3, cNazPol4, cNazPol5, cNazPol6, " + ;
                    "nUcetMzdy, nExtFaktur, cKmenStrPr, cKmenStrSt, nCisPrace, nClenSpol, nZdrPojis, " + ;
                    "sum(nDnyDoklad) as ndnyDoklad, "   + ;
                    "sum(nHodDoklad) as nHodDoklad, "   + ;
                    "sum(nMnPDoklad) as nMnPDoklad, "   + ;
                    "sum(nMzda)      as nMzda     , "   + ;
                    "sum(nZaklSocPo) as nZaklSocPo, "   + ;
                    "sum(nZaklZdrPo) as nZaklZdrPo, "   + ;
                    "sum(nMnozsVNU1) as nMnozsVNU1, "   + ;
                    "sum(nMnozsVNU2) as nMnozsVNU2  "   + ;
            "from mzdDavit "                            + ;
            "where ( nrok = %yyyy and nobdobi = %mm ) " + ;
            "group by cdenik    ,"                    + ;
                     "ctypDoklad,"                    + ;
                     "ctypPohybu,"                    + ;
                     "ndruhMzdy ,"                    + ;
                     "cNazPol1  ,"                    + ;
                     "cNazPol2  ,"                    + ;
                     "cNazPol3  ,"                    + ;
                     "cNazPol4  ,"                    + ;
                     "cNazPol5  ,"                    + ;
                     "cNazPol6  ,"                    + ;
                     "nUcetMzdy ,"                    + ;
                     "nExtFaktur,"                    + ;
                     "cKmenStrPr,"                    + ;
                     "cKmenStrSt,"                    + ;
                     "nCisPrace ,"                    + ;
                     "nClenSpol ,"                    + ;
                     "nZdrPojis  "                    + ;
            "order by cdenik    ,"                    + ;
                     "ctypDoklad,"                    + ;
                     "ctypPohybu,"                    + ;
                     "ndruhMzdy ,"                    + ;
                     "cNazPol1  ,"                    + ;
                     "cNazPol2  ,"                    + ;
                     "cNazPol3  ,"                    + ;
                     "cNazPol4  ,"                    + ;
                     "cNazPol5  ,"                    + ;
                     "cNazPol6  ,"                    + ;
                     "nUcetMzdy ,"                    + ;
                     "nExtFaktur,"                    + ;
                     "cKmenStrPr,"                    + ;
                     "cKmenStrSt,"                    + ;
                     "nCisPrace ,"                    + ;
                     "nClenSpol ,"                    + ;
                     "nZdrPojis  "


# define  stmt_mzdyhd   ;
                        "select cdenik, ctypDoklad, ctypPohybu "            + ;
                                "from mzdyhd "                              + ;
                                "where ( nrok = %yyyy and nobdobi = %mm ) " + ;
                                "group by cdenik, ctypDoklad, ctypPohybu "  + ;
                                "order by cdenik, ctypDoklad, ctypPohybu"

# define  stmt_mzdyit   ;
                        "select cdenik,ctypDoklad,ctypPohybu,ndruhMzdy,cKmenStrPr,nClenSpol,nZdrPojis, "  + ;
                                "sum(nDnyDoklad) as ndnyDoklad, "                     + ;
                                "sum(nHodDoklad) as nHodDoklad, "                     + ;
                                "sum(nMnPDoklad) as nMnPDoklad, "                     + ;
                                "sum(nMzda)      as nMzda     , "                     + ;
                                "sum(nZaklSocPo) as nZaklSocPo, "                     + ;
                                "sum(nZaklZdrPo) as nZaklZdrPo  "                     + ;
                        "from mzdyit "                                                + ;
                        "where ( nrok = %yyyy and nobdobi = %mm and cdenik = 'MC') "  + ;
                        "group by cdenik    , "                                       + ;
                                 "ctypDoklad, "                                       + ;
                                 "ctypPohybu, "                                       + ;
                                 "ndruhMzdy , "                                       + ;
                                 "cKmenStrPr, "                                       + ;
                                 "nClenSpol , "                                       + ;
                                 "nZdrPojis   "                                       + ;
                        "order by cdenik    , "                                       + ;
                                 "ctypDoklad, "                                       + ;
                                 "ctypPohybu, "                                       + ;
                                 "ndruhMzdy , "                                       + ;
                                 "cKmenStrPr, "                                       + ;
                                 "nClenSpol , "                                       + ;
                                 "nZdrPojis   "



*
** CLASS MZD_zauctmz_SCR *******************************************************
CLASS MZD_zauctmz_SCR FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart
  METHOD  ItemMarked
  *
  METHOD  ImportUctOld
  method  mzd_zauctmz_obd, mzd_zauctmz_sum


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    * zmìna období - budeme reagovat
    case(nevent = drgEVENT_OBDOBICHANGED)
       ::setSysFilter()
       return .t.
    otherwise
      return .f.
    endcase
  return .f.

hidden:
  var  brow
  var  uloha, rok, obdobi
  var  pa_deniky, pa_sumHeads, sumUctMzd
  var  xbp_therm, oThread_w
  var  oBtn_mzd_zauctmz_obd, oBtn_importuctold

  *
  ** pro úètování rozdílù sociálního a zdravotního pojištìní
  inline method ucetPol_suma()
    local  cStatement, oStatement
    local  stmt
    local  x, cfield, pa, calias, astru := { 'rok', 'obdobi', 'zdrPojis', 'nkcmd' }
    *
    local  pa_sumaUcetpol := {}, pi_Suma := {}

    stmt := "select nrok as rok, nobdobi as obdobi, nrecItem as zdrPojis, sum(nkcMD) as nkcmd "                       + ;
            "from ucetpol "                                                              + ;
            "where (nordUcto = 1 and nrok = %yyyy and nobdobi = %mm and "                + ;
            "  ( ( LEFT(ctypUct,7) = 'MZ_ZDPO' or LEFT(ctypUct,7) = 'MZ_ZDPZ' )  or "    + ;
            "    ( LEFT(ctypUct,7) = 'MZ_SOPO' or LEFT(ctypUct,7) = 'MZ_SOPZ' )    ) ) " + ;
            "group by nrok, nobdobi, nrecItem"


    cStatement := strTran( stmt      , '%yyyy', str(::rok   ) )
    cStatement := strTran( cStatement, '%mm'  , str(::obdobi) )

    oStatement := AdsStatement():New(cStatement, oSession_data)
    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test' )
    endif

    cAlias  := oStatement:Alias

    do while .not. (cAlias)->( eof())
      pi_suma := {}

      for x := 1 to len(astru) step 1
        aadd( pi_suma, (calias)->( fieldGet(x)) )
      next
      aadd( pa_sumaUcetPol, pi_suma )

      (cAlias)->( dbskip())
    enddo
  return pa_sumaUcetpol


  inline method is_mblok_for_likvRozdil()
    local lenBuff := 40960, buffer := space(lenBuff)
    local sname   := drgINI:dir_USERfitm +'mmacro', fields
    local ok      := .f.
    *
    local uloha   := 'M', typDoklad := 'MZD_GENZAO'

    * napozicovat se na záznam typdokl *
    if(select('typdokl') = 0, drgDBMS:open('typdokl'), nil)

    b_mzdyhd := b_mzdyit := nil

    if typdokl->(dbseek( uloha +typDoklad,,'TYPDOKL02'))

      * pokud je v typdokl mmacro tak ho zpøístupníme *
      if .not. empty(typdokl->mmacro)
        memowrit(sname,typdokl->mmacro)

        * naèteme ze sekce UsedIdentifiers Fields *
        GetPrivateProfileSectionA('mzdyhdw', @buffer, lenBuff, sname)
        fields    := substr(buffer,1,len(trim(buffer))-1)
        fields    := strtran(fields,chr(0),',')
        b_mzdyhd  := substr(fields,1,len(fields) -1)

        buffer    := space(lenBuff)

        GetPrivateProfileSectionA('mzdyitw', @buffer, lenBuff, sname)
        fields    := substr(buffer,1,len(trim(buffer))-1)
        fields    := strtran(fields,chr(0),',')
        b_mzdyit  := substr(fields,1,len(fields) -1)

        ferase(sname)
        ok := (.not. empty(b_mzdyhd) .and. .not. empty(b_mzdyit))
      endif
    endif
  return ok
  **
  *

  inline method setSysFilter( ini )
    local cfiltr, ft_APU_cond, filtrs
    local cky, lzavren_MZD, lzavren_UCT, lis_mzdZav

    default ini to .f.

    ::uloha  := 'M'
    ::rok      := uctOBDOBI:MZD:NROK
    ::obdobi   := uctOBDOBI:MZD:NOBDOBI

    cfiltr   := format("culoha = '%%' .and. nrok = %% .and. nobdobi = %%", {::uloha, ::rok, ::obdobi})
    cky      := strZero(::rok,4) +strZero(::obdobi,2)

    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'ucetPol')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('ucetPol', 'au') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      ::drgDialog:set_prg_filter(cfiltr, 'ucetPol')

      ucetPol->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif
    *
    ** hlídáme uzávìrku MZD a UCT
    ucetSys->( dbseek( 'M' +cky,,'UCETSYS3'))
    lzavren_MZD := ucetSys->lzavren

    ucetSys->( dbseek( 'U' +cky,,'UCETSYS3'))
    lzavren_UCT := ucetSys->lzavren

    lis_mzdZav := mzdzavhd->( dbseek( Val(cky),,'MZDZAVHD10'))

    if ( lzavren_MZD .or. lzavren_UCT .or. .not. lis_mzdZav ) .and. drgINI:l_blockObdMzdy
      ::oBtn_mzd_zauctmz_obd:disable()
//      ( ::oBtn_mzd_zauctmz_obd:disable(), ::oBtn_importuctold:disable() )
    else
      ::oBtn_mzd_zauctmz_obd:enable()
//      ( ::oBtn_mzd_zauctmz_obd:enable() , ::oBtn_importuctold:enable() )
    endif

  return self

  inline method start_worm()
    local  i, aBitMaps  := { 0, 0, {nil,nil,nil,nil} }, nPHASe := MIS_WORM_PHASE1, oThread_w
    local     xbp_therm := ::xbp_therm
    local     cinfoOBD  := '[ ' +strZero(uctOBDOBI:MZD:NOBDOBI,2) +'/' +strZero(uctOBDOBI:MZD:NROK,4) +' ]'
    *
    ** nachystáme si èervíka v samostatném vláknì
    for i := 1 to 4 step 1
      aBitMaps[3,i] := XbpBitmap():new():create()
      aBitMaps[3,i]:load( ,nPHASe )
      nPHASe++
    next

    ::oThread_w := Thread():new()
    ::oThread_w:setInterval( 8 )
    ::oThread_w:start( "mzd_zauctmz_scr_animate", xbp_therm, aBitMaps, cinfoOBD)
    return self

  inline method stop_worm()
    ::oThread_w:setInterval( NIL )
    ::oThread_w:synchronize( 0 )
    ::oThread_w := nil

    ::xbp_therm:setCaption('')
    return self

ENDCLASS


METHOD MZD_zauctmz_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'ucetSys')
  drgDBMS:open( 'mzdZavHd',,,, .t. )

  ::pa_deniky    := { '', '', '' }
  ::pa_deniky[1] := sysConfig('MZDY:cdenikMZ_H')
  ::pa_deniky[2] := sysConfig('MZDY:cdenikMZ_S')
  ::pa_deniky[3] := sysConfig('MZDY:cdenikMZ_N')

  * sumaèní likvidace
  ::pa_sumHeads := {}
  ::sumUctMzd   := sysConfig('MZDY:nsumUctMzd')
RETURN self


**
METHOD MZD_zauctmz_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className

  ::brow      := drgDialog:dialogCtrl:oBrowse
  ::xbp_therm := drgDialog:oMessageBar:msgStatus

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'mzd_zauctmz_obd' ;  ::oBtn_mzd_zauctmz_obd := members[x]
*        case lower(members[x]:event) = 'importuctold'    ;  ::oBtn_importuctold    := members[x]
        endcase
      endif
    endcase
  next

  ::setSysFilter( .t. )

*  cfiltr := format("culoha+cobdobi = '%%'", {'M' +uctOBDOBI:MZD:COBDOBI})
*  UCETPOL->( ADS_SetAOF( cFiltr))
*  UCETPOL->( dbGoTop())
RETURN self


METHOD MZD_zauctmz_SCR:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  aEVAL(dc:members[1]:aMembers,{|X| If( X:ClassName() = 'drgBrowse', X:Refresh(.T.), NIL )} )

RETURN SELF


METHOD MZD_zauctmz_SCR:ImportUctOld(drgDialog)
  local cPath, cFile, cIndex
  local key

  cPath  := AllTrim( SysConfig( "System:cPathUcto"))
  IF( Right( cPath, 1) <> "\", cPath := cPath +"\", NIL)

  cFile  := cpath +'UcetPol.dbf'
  cIndex := cpath +'UcetPol.cdx'

  if drgIsYESNO(drgNLS:msg('Naèíst zaúètování mezd za [' +uctOBDOBI:MZD:COBDOBI +'] ?'))
    if File(cFile) .and. file(cIndex)
      key := uctOBDOBI:MZD:COBDOBI
      drgServiceThread:progressStart( drgNLS:msg('Ruším pøedchozí zaúètování'), UcetPol->( mh_COUNTREC()))
      UcetPol->( dbGoTop())
      do while .not. UcetPol->( Eof())
        if UcetPol->cobdobi = key
          if UcetPol->( RLock())
            UcetPol->( dbDelete())
          endif
          UcetPol->( dbUnlock())
        endif
        drgServiceThread:progressInc()
        UcetPol->( dbSkip())
      enddo
      drgServiceThread:progressEnd()

      dbUseArea( .T.,'FOXCDX', cFile,'UctOld',.T.)
*      uctold->(DbSetIndex(cindex))

*      UctOld->( AdsSetOrder(6))
      UctOld->( AdsSetOrder(0))
*      UctOld->( dbSetScope( SCOPE_BOTH, key), dbgoTop())
      drgServiceThread:progressStart( drgNLS:msg('Pøevádím zaúètování'), UctOld->( LastRec()))
      UctOld->( dbGoTop())

      do while .not. UctOld->( Eof())
        if UctOld->cObdobi == key
          if UctOld->cUloha =='M'
            mh_COPYFLD('UctOld', 'UcetPol', .T.)
            UcetPol->( dbUnlock())
          endif
        endif
        drgServiceThread:progressInc()
        UctOld->( dbSkip())
      enddo
      drgServiceThread:progressEnd()
      UctOld->( dbCloseArea())
    else
      MsgBox( 'Chybí vstupní soubory'+' '+ cPath +' !!!', 'CHYBA...' )
    endif
  endif
RETURN nil


method mzd_zauctmz_scr:mzd_zauctmz_obd()
  local  cStatement, oStatement
  local  stmt
  *
  local  cky_Hd := strZero( ::rok,4) +strZero( ::obdobi,2)
  local  cky_It
  *
  local  uctLikv
  local  cold_tag
  *
  local  pa_sumaUcetpol, npos, nrozdil_SocZdr
  local  pa_rozdilHM := {0,0}
  local  x, cdenik, ndoklad := (::rok *100) + ::obdobi, cf_sum := "ndoklad = %%"
  local  filter
  local  cf := "nROK = %% .and. nOBDOBI = %% .and. (ctypPohybu = 'GENODVZDR' .or. ctypPohybu = 'GENODVSOC')"
  local  cf_mz := "nROK = %% .and. nOBDOBI = %%"


** TTT
/*
  drgDBMS:open( 'mzdDavHd',,,, .t. )
  drgDBMS:open('mzdDavIt',,,, .t. )
  drgDBMS:open('MZDDAVHDw',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm)

  ::mzd_zauctmz_sum('mzddavhd')

  drgDBMS:open( 'mzdyHd',,,, .t.  )
  drgDBMS:open( 'mzdyIt',,,, .t.  )
  drgDBMS:open( 'mzdyhdW',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open( 'mzdyitW',.T.,.T.,drgINI:dir_USERfitm)

  ::mzd_zauctmz_sum('mzdyhd')
  return self
*/
** TTT

  ::start_worm()

  *
  ** 1 - musíme zrušit komplennì likvidaci MEZD
  stmt := "delete from ucetPol where culoha = 'M' and nrok = %yyyy and nobdobi = %mm"

  cStatement := strTran( stmt      , '%yyyy', str(::rok   ) )
  cStatement := strTran( cStatement, '%mm'  , str(::obdobi) )

  oStatement := AdsStatement():New(cStatement, oSession_data)
  if oStatement:LastError > 0
    *  return .f.
  else
    oStatement:Execute( 'test', .f. )
    oStatement:Close()
  endif

  *
  ** uživatel si nastaví TAg, nebo rozšíøí stávající filr nad ucetPol
  cold_tag := ucetPol->( ordSetFocus( 'UCETPOL1' ))
              ucetPol->( ads_clearAof())

  *
  ** 2 - postupnì zaùèujeme - hrubé mzdy mzdDavHd
  drgDBMS:open( 'mzdDavHd',,,, .t. )
  mzdDavHd->( ordSetFocus('MZDDAVHD04'))   // STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nDoklad,10)
  drgDBMS:open( 'mzdDavIt',,,, .t. )
  mzdDavIt->( ordSetFocus('MZDDAVIT12'))   // STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3) +STRZERO(nDoklad,10)

  drgDBMS:open('MZDDAVHDw',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('MZDDAVITw',.T.,.T.,drgINI:dir_USERfitm)

  do case
  case ::sumUctMzd = 1

    ::mzd_zauctmz_sum('mzddavhd')

    mzdDavhdw->( dbgoTop())
    do while .not. mzdDavhdw->( eof())

      filter := format( cf_sum, { mzdDavhdw->ndoklad } )

      mzdDavITw->( ads_setAof(filter), dbgoTop() )

      uctLikv  := UCT_likvidace():new(upper(mzdDavHdw->culoha) +upper(mzdDavHdw->ctypdoklad),.T.)
      uctLikv:ucetpol_wrt()

      ucetPol  ->( dbcommit())
      mzdDavITw->( ads_clearAof())
      mzdDavHDw->( dbskip())
    enddo

  otherwise

    mzdDavHd->( dbsetScope( SCOPE_BOTH, cky_Hd), dbgoTop() )

    do while .not. mzdDavHd->(eof())
      mzdDavHdW->( dbZap())
      mzdDavItW->( dbZap())

      cky_It := strZero( mzddavhd->nrok, 4)       +strZero( mzddavhd->nOBDOBI,2)     + ;
                strZero( mzddavhd->noscisPrac, 5) +strZero( mzddavhd->nporPraVzt ,3) + ;
                strZero( mzddavhd->nDoklad ,10)

      mh_copyFld( 'MZDDAVHD', 'MZDDAVHDw', .t., .t. )

      mzdDavIt->( dbsetScope(SCOPE_BOTH,cky_It), dbgoTop() )
      do while .not. mzdDavIt->( eof())
        mh_copyFld( 'mzdDavit', 'mzdDavITw', .t., .t. )
        mzdDavit->( dbskip())
      enddo

      uctLikv  := UCT_likvidace():new(upper(mzdDavHdw->culoha) +upper(mzdDavHdw->ctypdoklad),.T.)
      uctLikv:ucetpol_wrt()

      mzdDavHd->( dbSkip())
    enddo
    ucetPol->( dbcommit())
  endcase

  *
  ** 3 - postupnì zaùèujeme - èisté mzdy mzdyHd
  drgDBMS:open( 'mzdyHd',,,, .t.  )
  mzdyHd->( ordSetFocus('MZDYHD01'))   // STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3)
  drgDBMS:open( 'mzdyIt',,,, .t.  )
  mzdyIt->( ordSetFocus('MZDYIT12'))   // STRZERO(nRok,4) +STRZERO(nObdobi,2) +STRZERO(nOsCisPrac,5) +STRZERO(nPorPraVzt,3) +STRZERO(nDoklad,10

  drgDBMS:open('mzdyhdW',.T.,.T.,drgINI:dir_USERfitm)
  drgDBMS:open('mzdyitW',.T.,.T.,drgINI:dir_USERfitm)

  do case
  case ::sumUctMzd = 1

    ::mzd_zauctmz_sum('mzdyhd')

    mzdyhdw->( dbgoTop())
    do while .not. mzdyhdw->( eof())

      filter := format( cf_sum, { mzdyhdw->ndoklad } )

      mzdyitw->( ads_setAof(filter), dbgoTop() )

      uctLikv  := UCT_likvidace():new(upper(mzdyhdw->culoha) +upper(mzdyhdw->ctypdoklad),.T.)
      uctLikv:ucetpol_wrt()

      ucetPol->( dbcommit())
      mzdyitw->( ads_clearAof())
      mzdyhdw->( dbskip())
    enddo

  otherwise

    mzdyHd->( dbsetScope( SCOPE_BOTH, cky_Hd), dbgoTop() )

    do while .not. mzdyHd->( eof())
      mzdyHdW->( dbZap())
      mzdyItW->( dbZap())

      cky_It := strZero( mzdyHd->nrok, 4)       +strZero( mzdyHd->nOBDOBI,2)     + ;
                strZero( mzdyHd->noscisPrac, 5) +strZero( mzdyHd->nporPraVzt ,3) + ;
                strZero( mzdyHd->nDoklad ,10)

      mh_copyFld( 'MZDYHD', 'MZDYHDW', .t., .t. )

      mzdyIt->( dbsetScope(SCOPE_BOTH,cky_It), dbgoTop() )
      do while .not. mzdyIt->( eof())

        if mzdyit->cdenik = 'MC'
          mh_copyFld( 'mzdyIt', 'mzdyItW', .t., .t. )
        endif

        mzdyIt->( dbskip())
      enddo

      uctLikv  := UCT_likvidace():new(upper(mzdyhdw->culoha) +upper(mzdyhdw->ctypdoklad),.T.)
      uctLikv:ucetpol_wrt()

      mzdyHd->( dbSkip())
    enddo
    ucetPol->( dbcommit())
  endcase

  *
  ** 4 - zaùèujeme - rozdíly likvidace soc/zdr sum.ucetPol proti mzdZavhd
  if ::is_mblok_for_likvRozdil()

    filter := format( cf, {::rok,::obdobi})
    drgDBMS:open( 'mzdZavHd',,,, .t.  )
    drgDBMS:open( 'mzdyIt',,,,,'mzdyIts')
    drgDBMS:open( 'druhymzd',,,,,'druhymzds')
    mzdZavhd->( ads_setAof(filter), dbgoTop())
    filter := format( cf_mz, {::rok,::obdobi})
    mzdyits->( ads_setAof( filter), dbgoTop())

    pa_sumaUcetpol := ::ucetPol_suma()

    mzdyHdW->( dbZap())
    mzdyItW->( dbZap())

    mh_copyFld( 'mzdZavhd', 'mzdyhdW', .t., .t. )
    Eval( &("{||" + b_mzdyhd + "}"))
    mzdyhdW->( dbcommit())

    do while .not. mzdZavhd->( eof())
      if ( npos := ascan( pa_sumaUcetpol, { |i| i[3] = mzdZavhd->nzdrPojis })) <> 0

        if ( nrozdil_SocZdr := mzdZavhd->ncenZakCel -pa_sumaUcetpol[npos,4] ) <> 0
          mh_copyFld( 'mzdyhdW', 'mzdyitW', .t., .t. )
          Eval( &("{||" + b_mzdyit + "}"))

          mzdyitW->ndruhMzdy := if( mzdZavhd->nzdrPojis = 0, 994, 995 )
          mzdyitW->cucetSkup := allTrim( Str( mzdyitw->ndruhMzdy))
          mzdyitW->nzdrPojis := mzdZavhd->nzdrPojis
          mzdyitW->nmzda     := nrozdil_SocZdr

          mzdyitW->( dbcommit())
        endif
      endif
      mzdZavhd->( dbskip())
    enddo

    do while .not. mzdyits ->( eof())
      npos :=  mzdyits->nClenSpol +1
      druhymzds->( dbSeek( StrZero(mzdyits->nrok,4)+StrZero(mzdyits->nobdobi,2) +StrZero(mzdyits->ndruhmzdy,4),,'DRUHYMZD04'))
      do case
      case mzdyits->nDruhMzdy = 900
        pa_rozdilHM[npos] += mzdyits->nmzda

      case mzdyits->nDruhMzdy <= 399 .and. druhymzds->lHrubaMzda
        pa_rozdilHM[npos] -= mzdyits->nmzda
      endcase
      mzdyits->( dbSkip())
    enddo

    for npos := 1 to 2
      if  pa_rozdilHM[npos] <> 0
        mh_copyFld( 'mzdyhdW', 'mzdyitW', .t., .t. )
        Eval( &("{||" + b_mzdyit + "}"))

        mzdyitW->ndruhMzdy := if( npos = 1, 999, 998 )
        mzdyitW->cucetSkup := allTrim( Str( mzdyitw->ndruhMzdy))
        mzdyitW->nmzda     := pa_rozdilHM[npos]

        mzdyitW->( dbcommit())
      endif
    next
    uctLikv  := UCT_likvidace():new(upper(mzdyhdw->culoha) +upper(mzdyhdw->ctypdoklad),.T.)
    uctLikv:ucetpol_wrt()

    mzdZavhd->( ads_clearAof())
    mzdyIts->( ads_clearAof())
  endif

  ::stop_worm()
  ucetPol->( ordSetFocus( cold_tag ))
  ::setSysFilter()
return self


method mzd_zauctmz_scr:mzd_zauctmz_sum(cfile_in)
  local  cStatement, oStatement
  local  stmt_hd, stmt_it, stmt
  *
  local  calias, cfile_ou
  local  ndoklad := ((::rok *100) + ::obdobi) *1000, nsub_Doklad
  local  lis_Head, cky_Head, pa := ::pa_sumHeads

  *
  if cfile_in = 'mzddavhd'  ;  stmt_hd := stmt_mzdDavhd
                               stmt_it := stmt_mzdDavit
  else                      ;  stmt_hd := stmt_mzdyhd
                               stmt_it := stmt_mzdyit
  endif


  for x := 1 to 2 step 1

    if x = 1  ;  stmt     := stmt_hd
                 cfile_ou := cfile_in +'w'
                 lis_Head := .t.
    else      ;  stmt     := stmt_it
                 cfile_ou := if( cfile_in = 'mzddavhd', 'mzddavitw', 'mzdyitw' )
                 lis_Head := .f.
    endif

    cStatement := strTran( stmt      , '%yyyy', str(::rok   ) )
    cStatement := strTran( cStatement, '%mm'  , str(::obdobi) )

    oStatement := AdsStatement():New(cStatement, oSession_data)
    if oStatement:LastError > 0
     *  return .f.
    else
      oStatement:Execute( 'test' )
    endif

    calias := oStatement:Alias

    do while .not. (calias)->( eof())

      (cfile_ou)->( dbappend())
      db_to_db( calias, cfile_ou )

      cky_Head := (cfile_ou)->cdenik +(cfile_ou)->ctypDoklad +(cfile_ou)->ctypPohybu

      if lis_Head
        nsub_Doklad := val( if( cfile_in = 'mzddavhd', '0', '1') +strZero(len(pa)+1, 2) )
        aadd( pa, { cky_Head, ndoklad +nsub_Doklad, 0 } )

        (cfile_ou)->culoha   := 'M'
        (cfile_ou)->ndoklad  := ndoklad +nsub_Doklad

      else
        if( npos := ascan( pa, { |x| x[1] = cky_Head })) <> 0

          pa[npos,3] += 1

          (cfile_ou)->cobdobi   := uctOBDOBI:MZD:COBDOBI
          (cfile_ou)->nrok      := ::rok
          (cfile_ou)->nobdobi   := ::obdobi
          (cfile_ou)->ndoklad   := pa[ npos,2]
          (cfile_ou)->norditem  := pa[ npos,3]
          (cfile_ou)->cucetSkup := allTrim( str( (cfile_ou)->ndruhMzdy ))
          (cfile_ou)->ddatPoriz := date()
          (cfile_ou)->culoha    := 'M'
        endif
      endif

      (calias)->( dbskip())
    enddo

    oStatement:close()
    (cfile_ou)->( dbcommit())
  next
return self


static function db_to_db(cDBfrom,cDBto)
  local aFrom := ( cDBFrom) ->( dbStruct())

  aEval( aFrom, { |X,M| ( xVal := ( cDBFrom) ->( FieldGet( M))                        , ;
                          nPos := ( cDBTo  ) ->( FieldPos( X[ DBS_NAME]))             , ;
                          If( nPos <> 0, ( cDBTo) ->( FieldPut( nPos, xVal)), Nil ) ) } )
return nil


procedure  mzd_zauctmz_scr_animate(xbp_therm,aBitMaps,cinfoOBD)
  local  aRect, oPS, nXD, nYD
  *
  local  oFont := XbpFont():new():create( "10.Arial CE" )
  local  aAttr := ARRAY( GRA_AS_COUNT ), nx_text
  local  cText := '... úètuji mzdy za obdobi ' +cinfoOBD +' ...'

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