#include "Common.ch"
#include "gra.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\Asystem++\Asystem++.ch"

*
*
** CLASS MZD_zavazky_ob_SCR ****************************************************
CLASS MZD_zavazky_ob_SCR FROM drgUsrClass, quickFiltrs
EXPORTED:

  METHOD  Init
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  ImportMzLOld

  method  stableBlock
  method  mzd_pracKalendar_in

  class   var mo_prac_filtr READONLY


  inline method genZavazky( oxbp)
    ::start_worm()
    MZD_zavazky_gen()
    ::stop_worm()

    ::setSysFilter()
    return self


  inline method delZavazky(oXbp)
    local  nsel, cinfo := space(20) +'... za období ' +str(mzdZavhd->nobdobi,2) +'/' +str(mzdZavhd->nrok,4) +' ...'
    *
    local  cStatement, oStatement
    local  stmt    := "delete from mzdZavhd where nrok = %yyyy and nobdobi = %mm and culoha = 'M'"
    *
    local  nrok       := uctOBDOBI:MZD:NROK
    local  nobdobi    := uctOBDOBI:MZD:NOBDOBI

    nsel  := ConfirmBox( ,'Dobrý den p. ' +logOsoba +CRLF +                                               ;
                          'opravdu požadujete zrušit vygenerované mzdové závazky _ ' +CRLF +CRLF +cinfo , ;
                          'Prosím POZOR, vygenerované mzdové závazky budou zrušeny ...'                 , ;
                           XBPMB_YESNO                                                                  , ;
                           XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)


    if nsel = XBPMB_RET_YES
      cStatement := strTran( stmt      , '%yyyy', str(nrok   ,4))
      cStatement := strTran( cStatement, '%mm'  , str(nobdobi,2))

      oStatement := AdsStatement():New(cStatement, oSession_data)
      if oStatement:LastError > 0
        *  return .f.
      else
        ::start_worm()
        oStatement:Execute( 'test', .f. )
        oStatement:Close()
        ::stop_worm()
      endif
      mzdZavhd->(dbUnlock(), dbCommit())

      ::setSysFilter()
    endif
  return self


  * položky - bro
  inline access assign method typDokladu() var typDokladu
    local  pa     := ::pa_column_1, npos
    local  retVal := 0

    if( npos := ascan( pa, { |x| x[1] = mzdZavHd->cdenik })) <> 0
      retVal := pa[npos,2]
    endif
    return retVal

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
  VAR  pa_column_1, oBtn_genZavazky, oBtn_delZavazky
  var  xbp_therm, oThread_w


  inline method setSysFilter( ini )
    local rok, mes
    local rokobd
    local cfiltr, ft_APU_cond, filtrs

    default ini to .f.

    rok     := uctOBDOBI:MZD:NROK
    mes     := uctOBDOBI:MZD:NOBDOBI
    rokobd  := (rok*100)+mes

    cfiltr  := Format("nROKOBD = %%", {rokObd}) + ::mo_prac_filtr

    ::drgDialog:set_prg_filter(cfiltr, 'mzdzavhd')

    if .not. ini
      * zmìna na < p >- programovém filtru
      ::quick_setFilter( , 'apuq' )
    endif

/*
    if ini
      ::drgDialog:set_prg_filter(cfiltr, 'mzdzavhd')

    else
      if .not. empty(ft_APU_cond := ::drgDialog:get_APU_filter('mzdzavhd', 'auq') )
        filtrs := '(' +ft_APU_cond +') .and. (' +cfiltr +')'
      else
        filtrs := cfiltr
      endif

      mzdzavhd->( ads_setaof(filtrs), dbGoTop())
      ::brow[1]:oxbp:refreshAll()
    endif
*/

    ::oBtn_genZavazky_action()
  return self


  inline method oBtn_genZavazky_action()
    local  rok       := uctOBDOBI:MZD:NROK
    local  obdobi    := uctOBDOBI:MZD:NOBDOBI
    *
    local  is_mzdZav := mzd_zavhd->( dbseek( strZero(rok,4) +strZero(obdobi,2) +'1',,'MZDZAVHD13'))

    if( is_mzdZav, ::oBtn_genZavazky:disable(), ::oBtn_genZavazky:enable() )

    if is_mzdZav
      if drgINI:l_blockObdMzdy
        ( ::oBtn_delZavazky:oxbp:hide(), ::oBtn_delZavazky:disable() )
      else
        ( ::oBtn_delZavazky:enable(), ::oBtn_delZavazky:oxbp:show() )
      endif

    else
      (::oBtn_delZavazky:disable(), ::oBtn_delZavazky:oxbp:hide())
    endif
    return


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
    ::oThread_w:start( "mzd_zavazky_ob_scr_animate", xbp_therm, aBitMaps, cinfoOBD)
    return self

  inline method stop_worm()
    ::oThread_w:setInterval( NIL )
    ::oThread_w:synchronize( 0 )
    ::oThread_w := nil

    ::xbp_therm:setCaption('')
    return self

ENDCLASS


METHOD MZD_zavazky_ob_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open( 'MZDZAVHD')
  drgDBMS:open( 'MZDZAVIT')
  *
  drgDBMS:open( 'DRUHYMZD')
  drgDBMS:open( 'mzdZavhd',,,,,'mzd_Zavhd')
  drgDBMS:open( 'c_typpoh' )

  ::pa_column_1 := { { sysConfig( 'mzdy:cdenikMZ_H'), 534 }, ;
                     { sysConfig( 'mzdy:cdenikMZ_N'), 535 }, ;
                     { sysConfig( 'mzdy:cdenikMZ_S'), 536 }  }

  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'mzdzavhd')
  endif
RETURN self


METHOD MZD_zavazky_ob_SCR:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD MZD_zavazky_ob_SCR:drgDialogStart(drgDialog)
  local  members := drgDialog:oActionBar:members, x, className
  local  pa_quick := { ;
  { 'Kompletní seznam                  ', ''            }  }

  c_typPoh->( dbsetScope( SCOPE_BOTH, 'MZAVAZKY'), ;
              dbgoTop()                          , ;
              dbeval( { || aadd( pa_quick, { c_typPoh->cnazTypPoh, 'ctypPohybu = "' +c_typPoh->ctypPohybu +'"' } ) } ), ;
              dbclearScope()                       )

  aeval( pa_quick, { |p| p[1] := strTran( p[1], 'Gener.závazek', '' ) })


  ::brow          := drgDialog:dialogCtrl:oBrowse
  ::xbp_therm     := drgDialog:oMessageBar:msgStatus
  ::mo_prac_filtr := ''

  ::quickFiltrs:init( self, pa_quick, 'Mzdové závazky' )

  for x := 1 to len(members) step 1
    className := members[x]:ClassName()

    do case
    case className = 'drgPushButton'
      if isCharacter( members[x]:event )
        do case
        case lower(members[x]:event) = 'genzavazky' ;  ::oBtn_genZavazky := members[x]
        case lower(members[x]:event) = 'delzavazky' ;  ::oBtn_delZavazky := members[x]
        endcase
      endif
    endcase
  next
  *
  ** vazba na MSPRC_MO - volání z mzd_kmenove_scr
  if len(pa_initParam := listAsArray( drgDialog:initParam )) = 2
    ::mo_prac_filtr := ' .and. ' +pa_initParam[2]
  endif

  ::setSysFilter( .t. )
RETURN self


method MZD_zavazky_ob_scr:stableBlock(oxbp)
  local  m_file, cfiltr
  *
  local  cf := "nROKOBD = %% .and. cDenik = '%%' .and. nDoklad = %%"

  if isObject(oxbp)
     m_file := lower(oxbp:cargo:cfile)

     do case
     case( m_file = 'mzdzavhd' )
       cfiltr := Format( cf, { mzdzavHd->nrokObd, mzdzavHd->cdenik, mzdzavHd->ndoklad })
       mzdzavit->(ads_setaof(cfiltr), dbGoTop())

       aeval( ::brow, { |o| if( o:oxbp = oxbp, nil, o:oxbp:refreshAll() ) })
     endcase
  endif

  c_typpoh->(dbseek(upper(mzdZavhd->culoha) +upper(mzdZavhd->ctypdoklad) +upper(mzdZavhd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self


METHOD MZD_zavazky_ob_SCR:ImportMzLOld(drgDialog)
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
method MZD_zavazky_ob_SCR:mzd_prackalendar_in()
  LOCAL oDialog

  ::drgDialog:pushArea()                  // Save work area
    DRGDIALOG FORM 'MZD_prackal_in' PARENT ::drgDialog MODAL DESTROY

  ::drgDialog:popArea()                  // Restore work area
RETURN self


procedure mzd_zavazky_ob_scr_animate(xbp_therm,aBitMaps,cinfoOBD)
  local  aRect, oPS, nXD, nYD
  *
  local  oFont := XbpFont():new():create( "10.Arial CE" )
  local  aAttr := ARRAY( GRA_AS_COUNT ), nx_text
  local  cText := '... generuji mzdové závazky za obdobi ' +cinfoOBD +' ...'

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