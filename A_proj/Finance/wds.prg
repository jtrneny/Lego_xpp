#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "dmlb.ch"
#include "xbp.ch"
#include "font.ch"
#include "dbstruct.ch"
#include "Drgres.ch"

#include "dll.ch"

#include "ads.ch"
#include "adsdbe.ch"
*
#include "..\Asystem++\Asystem++.ch"

#include "..\A_main\ace.ch"


/*
  wds_cenzboz, wds_dodlstit, wds_objitem, wds_vyrzak

struktura souètového pole
  { RecNo, nnozDok, nmnoz_fakv, nmnoz_dlv, nmnoz_vyrz }
*/

DLLFUNCTION GetExitCodeProcess( hProcess, plExitCode) USING STDCALL FROM KERNEL32.DLL

function xpp_GetExitCodeProcess(hProcess)
  local  plExitCode := .t.

  lStateProces := GetExitCodeProcess( hprocess, @plExitCode)

//  DllCall( 'Kernel32', DLL_STDCALL, 'GetExitCodeProcess', hProcess, @plExitCode )
return plExitCode


*
** pøi startu A++ ovìøíme záznamy ve WDS pro usrName, pokud by tan zùstaly smažeme
** jedná se o jakýkoliv pád A++
procedure wds_resetUsers_inStart()
  local  cStatement, oStatement
  *
  local  stmt := "delete from wds_it where contains( wds_key, '*%usrName*' );" + ;
                 "delete from wds_hd where contains( wds_key, '*%usrName*' );" + ;
                 "update wds set nusers = (select count(*) from wds_hd)"

   cStatement := strTran( stmt, '%usrName', upper(usrName)  )
   oStatement := AdsStatement():New(cStatement,oSession_data)


   if oStatement:LastError > 0
     *  return .f.
   else
     oStatement:Execute( 'test', .f. )
     oStatement:Close()
   endif
return


*
** ovìøíme jestli jsem na tabulce wds.adt sám, poku ano vymažeme wds, wds_hd, wds_it
static function users_on_wds()
  local  cStatement, oStatement
  local  nusers := 99
  local  stmt   := "delete from wds ; delete from wds_hd ; delete from wds_it ;"
  local  phConnect, tablePath := space(512), ctable_Path, ctable_User
  *
  local  hCursor

  phConnect    := oSession_data:getConnectionHandle()
  AdsDDGetDatabaseProperty( phConnect, ADS_DD_DEFAULT_TABLE_PATH, @tablePath, 512 )
  ctable_Path := strTran( tablePath, chr(0), '' )
  ctable_User := allTrim(ctable_Path) +"wds.adt"

  cStatement := "execute procedure sp_mgGetTableUsers( '" +ctable_User + "')"
  oStatement := AdsStatement():New(cStatement,oSession_data)

  if oStatement:LastError > 0
   *  return .f.
    return nusers
  endif
  oStatement:Execute( 'test',.f. )

  hCursor := oStatement:hCursor
  nusers  := Ads_GetRecordCount( , hCursor)

*  oStatement:alias := ''
  oStatement:Close()


  if nusers = 0
    oStatement := AdsStatement():New(stmt,oSession_data)

    if oStatement:LastError > 0
      *  return .f.
    else
      oStatement:Execute( 'test', .f. )
    endif
    oStatement:Close()
  endif
return nusers


CLASS WDS
  exported:
  var     dm

  var     wds_key, wds_nseconds
  var     wds_cenzboz , wds_dodlstit , wds_objitem , wds_vyrzak , wds_pvpterm , wds_objvysit
  var     bwds_cenzboz, bwds_dodlstit, bwds_objitem, bwds_vyrzak, bwds_pvpterm, bwds_objvysit
  *
  var     wds_mnozZdok
  var     cwds_popUp
  var     awds_filter

  * položky na kterých je provádìna kontrola, znaménko pro množství default is -1
  var     nwds_sign
  var     cwds_itmnoz
  var     cwds_itmnoz_org

  method  wds_connect, wds_watch_mnoz, wds_watch_time
  method  wds_postDelete, wds_postSave, wds_disconnect


   * virtuální sloupce BRO pro CLASS FIN_fakturovat_z_SEL
  inline access assign method wds_cenzboz_kDis() var wds_cenzboz_kDis
    local pa := ::wds_cenzboz, recNo := cenzboz->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, 2]
    endif
    return cenzboz->nmnozDzbo -nval

  inline access assign method wsd_dodlstit_kDis() var wsd_dodlstit_kDis
    local pa := ::wds_dodlstit, recNo := dodlstit->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, ::nwds_posSum]
    endif
    return eval( ::bwds_dodlstit ) -nval

  inline access assign method wsd_objitem_kDis() var wsd_objitem_kDis
    local pa := ::wds_objitem, recNo := objitem->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, ::nwds_posSum]
    endif
    return eval( ::bwds_objitem ) -nval

  inline access assign method wsd_vyrzakit_kDis() var wsd_vyrzakit_kDis
    local pa := ::wds_vyrzak, recNo := vyrzakit->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, ::nwds_posSum]
    endif
    return eval( ::bwds_vyrzak ) -nval

  inline access assign method wsd_pvpterm_kDis() var wsd_pvpterm_kDis
    local pa := ::wds_pvpterm, recNo := pvpterm->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, ::nwds_posSum]
    endif
    return eval( ::bwds_pvpterm ) -nval

  inline access assign method wsd_objvysit_kDis() var wsd_objvysit_kDis
    local pa := ::wds_objvysit, recNo := objvysit->(recNo()), nin, nval := 0

    if( nin := ascan( pa, {|x| x[1] = recNo} )) <> 0
      nval := pa[ nin, ::nwds_posSum]
    endif
    return eval( ::bwds_objvysit ) -nval


hidden:
  var     hd_file, it_file
  var     afile_m                 // hlavièky souborù které kontroluje WDS
  var     afile_iv                // vstupní soubory do poožek dokladù
  var     nwds_posSum             // pozice pro souètové hodnoty nmnoz_

  var     alock_hd, alock_it

  var     cisSklad , sklPol
  var     cisloDl  , countdl
  var     cislObInt, cislPolob
  var     cisZakazi
ENDCLASS


*
** wds - pøipojíme uživatele
method  wds:wds_connect(parent)
  local  d_ext, i_ext, m_ext
  local  cext := ''           // extenze pro nmnoz_ + FAKV - DLV  -  EXPV  - SVYD
  *
  ** nìco si nabereme z parenta a to nemusím pøehazovat až sem
  ::dm            := parent:dm
  ::hd_file       := lower( parent:hd_file )
  ::it_file       := lower( parent:it_file )

  ::afile_m       := { 'fakvyshdw', 'dodlsthdw', 'explsthdw' }
  ::afile_iv      := { 'cenzboz'  , 'dodlstit' , 'objitem'  , 'vyrzakit', 'objvysit' }

  ::awds_filter   := { '', ;
                       'nstav_? = 0 .or. nstav_? = 1' , ;
                       'nstav_? = 2'                  , ;
                       'nstav_? = 1'                    }

  ::nwds_sign       := -1
  ::cwds_itmnoz     := 'nfaktMnoz'
  ::cwds_itmnoz_org := 'nfaktm_org'


  do case
  case( ::it_file = 'fakvysitw' )
    ::cwds_popUp  := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
    ::nwds_posSum := 3
    cext          := 'FAKV'

 case( ::it_file = 'fakvnpitw' )
    ::cwds_popUp  := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
    ::nwds_posSum := 3
    cext          := 'FAKV'

  case( ::it_file = 'dodlstitw' )
    ::cwds_popUp  := 'Kompletní seznam ,Nedodané       , Dodané       , Èásteène dodané'
    ::nwds_posSum := 4
    cext          := 'DLV'

  case( ::it_file = 'explstitw' )
    ::cwds_popUp  := 'Kompletní seznam ,Nevyexpedované , Vyexpedované , Èásteène expedované'
    ::nwds_posSum := 5
    cext          := 'EXLV'

  case( ::it_file = 'objitemw' )
*    ::cwds_popUp  := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
    ::nwds_posSum := 3
*    cext          := 'FAKV'

  case( ::it_file = 'poklitw' )
*    ::cwds_popUp  := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
    ::nwds_posSum := 3

  case( ::it_file = 'pvpitemww' )
*    ::cwds_popUp  := 'Kompletní seznam ,Nevyfakturované, Vyfakturované, Èásteènì fakturované'
    ::nwds_posSum := 3
    cext          := 'SVYD'

  endCase


  ::awds_filter   := { '', ;
                       ' (nstav_' +cext +' = 0 .or. nstav_' +cext +' = 1)' , ;
                       ' (nstav_' +cext +' = 2)'                           , ;
                       ' (nstav_' +cext +' = 1)'                             }
  ::alock_it      := {}

  * cenzboz
  ::cisSklad      := parent:cisSklad
  ::sklPol        := parent:sklPol

  *dodlstit
  ::cisloDl       := if( isMemberVar( parent, 'cisloDl'  ), parent:cisloDl  , nil )
  ::countdl       := if( isMemberVar( parent, 'countdl'  ), parent:countdl  , nil )

  * objitem
  ::cislObInt     := if( isMemberVar( parent, 'cislObInt'), parent:cislObInt, nil )
  ::cislPolob     := if( isMembervar( parent, 'cislPolob'), parent:cislPolob, nil )

  * vyrzakit
  ::cisZakazi     := if( isMemberVar( parent, 'cisZakazi'), parent:cisZakazi, nil )
  *
  **                 UuidToChar( UuidCreate()) 36B
  ::wds_key       := upper(::hd_file) +upper(usrName) +allTrim(str(GetCurrentProcessID())) +allTrim(str(threadID()))

  ::wds_cenzboz   := {}
  ::bwds_cenzboz  := COMPILE( 'cenzboz->nmnozDzbo' )

  ::wds_dodlstit  := {}
  ::bwds_dodlstit := COMPILE( 'dodlstit->nfaktMnoz  -dodlstit->nmnoz_' +cext )

  ::wds_objitem   := {}
  ::bwds_objitem  := COMPILE( 'objitem->nmnozObOdb  -objitem->nmnoz_'  +cext )

  ::wds_vyrzak    := {}
  ::bwds_vyrzak   := COMPILE( 'vyrzakit->nmnozPlano -vyrzakit->nmnoz_' +cext )

  ::wds_pvpterm   := {}
  ::bwds_pvpterm  := COMPILE( 'pvpterm->nmnozDokl1  -pvpterm->nMnoz_PLN'     )

  ::wds_objvysit  := {}
  ::bwds_objvysit := COMPILE( 'objvysit->nmnozOBdod -objvysit->nmnozPLdod'   )


  d_ext := DbeInfo( COMPONENT_DATA , DBE_EXTENSION       )
  i_ext := DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT    )
  m_ext := DbeInfo( COMPONENT_DATA , ADSDBE_MEMOFILE_EXT )

  *
  ** ovìøíme jestli jsem na tabulce wds.adt sám, poku ano vymažeme wds, wds_hd, wds_it
  if( select('wds') = 0, users_on_wds(), nil )

/*
  stmt_wds  := "delete from wds_hd where wds_key = '%wds_key' ; " + ;
               "delete from wds_it where wds_key = '%wds_key' ; "
  cStatement := strTran( stmt_wds, '%wds_key', ::wds_key )
*/

  drgDBMS:open('wds'   )
  drgDBMS:open('wds_hd')
  drgDBMS:open('wds_it')
  *
  ** vazba pro Dl s automatickým vyskladnìním
  if(select('typdokl') = 0, drgDBMS:open('typdokl'), nil)

  if wds->(eof())
    wds->(dbappend())
    *
    wds->nusers   := 1
    wds->nseconds := seconds()
  else
    wds->(sx_rlock())
    wds->nusers := wds->nusers +1
  endif

  if .not.  wds_hd->(dbseek(::wds_key))
    wds_hd->(dbappend())

    wds_hd->wds_key := ::wds_key
    wds_hd->(dbcommit())
  endif

  wds_it->(dbsetScope(SCOPE_BOTH, ::wds_key))
  if .not. wds_it->(eof())
    wds_it->(dbgotop())
    wds_it->(dbeval( {|| if(wds_it->(sx_rlock()), wds_it->(dbdelete()), nil) } ))
    wds_it->(dbunlock())
  endif
  wds_it->(dbclearScope())

  ::wds_nseconds := 0
  ::wds_watch_time()

  ::wds_nseconds := wds->nseconds

  wds->(dbunlock(),dbcommit())
   wds_hd->(dbunlock(),dbcommit())
    wds_it->(dbunlock(),dbcommit())
return self


* wds zkontrolujeme množství
method wds:wds_watch_mnoz(lnewRec, intCount)
  local  ok := .t., lwatch_mnoz := .f., citem, lok
  local  cky, pky  := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad)
  *
  local  cfile_iv  := lower( alltrim(::dm:has(::it_file +'->cfile_iv'):value))
  local  nrecs_iv  :=                ::dm:has(::it_file +'->nrecs_iv'):value
  local  faktMnoz  :=                ::dm:has(::it_file + '->' +::cwds_itmnoz):value

* :get - závisí na setAppFocus, pokud je BRO bere data ze záznamu
*  local  cfile_iv  := lower( allTrim(::dm:get(::it_file + '->cfile_iv' )))
*  local  nrecs_iv  := ::dm:get(::it_file + '->nrecs_iv' )
*  local  faktMnoz  := ::dm:get(::it_file + '->' +::cwds_itmnoz)
  *
  local  faktm_org := 0, mnozZdok := 0, lnew_wds_it := .f., mnozReODB, faktMnoz_D

  * kontrola !!! pøed !!! ukádání záznamu na množství
  * metody na pro_fakdol správnì nastaví vazby na fakturaèní soubory      !!!!
  * pokud je ok zmodifikuje wds_it + wds->nseconds ten vyvolá kontrolní pøepoèet

  if ( ( ascan(::afile_iv,cfile_iv) = 0 .and. ::hd_file $ ::afile_m ) .or. faktMnoz = NIL )
    return .t.

  else
    ::wds_mnozZdok := 0
               cky := padr(::wds_key,40)       + ;
                      padr(upper(cfile_iv),10) + ;
                      strZero(nrecs_iv,10)     + ;
                      strZero(intCount,5)

    if lnewRec
      * nová položka dokladu
      faktm_org := 0
    else
      if DBGetVal( ::it_file +'->' +::cwds_itmnoz_org) = 0
        * opravuje novou položku dokladu
        faktm_org := DBGetVal( ::it_file +'->' +::cwds_itmnoz)
      else
        * opravuje položku uloženou v originálu
        faktm_org := DBGetVal( ::it_file +'->' +::cwds_itmnoz_org)
      endif
    endif


    do case
    case( cfile_iv = 'cenzboz' )
      *
      ** zmìna vazby pro DL s automatickým vyskladnìním
      do case
      case lower( ::hd_file ) = 'dodlsthdw'
        typdokl ->(dbseek( pky,,'TYPDOKL02'))
        lwatch_mnoz := .not. empty(typdokl->mmacro)

      *
      ** objednávka pøijatá vždy pokud je cpolCen = 'C'
      case lower( ::hd_file ) = 'objheadw'
        lwatch_mnoz := .t.

      *
      ** položka výdej/pøíjem/pøevod vždy pokud je cpolCen = 'C'
      case lower( ::hd_file ) = 'pvpheadw'
        lwatch_mnoz := .t.

      otherwise
        pky += upper((::hd_file)->ctyppohybu)
        c_typpoh ->(dbseek(pky,,'C_TYPPOH05'))
        lwatch_mnoz := .not. empty(c_typpoh->csubpohyb)
      endcase

      if cenzboz->cpolcen = 'C' .and. lwatch_mnoz
        if cenzboz->ctypSklCen = 'PRU'
          ok := (::wds_cenzboz_kDis  +faktm_org >= faktMnoz)
        else
          return .t.
        endif
      else
        return .t.
      endif

    case( cfile_iv = 'dodlstit')
      mnozZdok := ::wsd_dodlstit_kDis +faktm_org
            ok := (mnozZdok >= faktMnoz)

    case( cfile_iv = 'objitem' )
      mnozZdok  := ::wsd_objitem_kDis +faktm_org
      mnozReODB := objitem->nmnozReODB

      if upper(cenzboz->cpolcen) = 'C'

        * možnost fakturovat do sklDisp monžství - nmnozDzbo
        if cenzboz->nnadmnozZd = 1
          ok := (::wds_cenzboz_kDis +faktm_org >= faktMnoz)
        else
// ??          ok := (mnozZdok >= faktMnoz .and. (::wds_cenzboz_kDis +mnozReODB +faktm_org) >= faktMnoz)
          ok := (::wds_cenzboz_kDis +mnozReODB +faktm_org) >= faktMnoz
        endif
      else
        ok := (mnozZdok >= faktMnoz)
      endif

    case( cfile_iv = 'vyrzakit')
      mnozZdok := ::wsd_vyrzakit_kDis +faktm_org
            ok := (mnozZdok >= faktMnoz)

    case( cfile_iv = 'pvpterm' )
      mnozZdok  := ::wsd_pvpterm_kDis +faktm_org
             ok := (mnozZdok >= faktMnoz)

    case( cfile_iv = 'objvysit' )
      mnozZdok  := ::wsd_objvysit_kDis +faktm_org
             ok := (mnozZdok >= faktMnoz)

    endcase

    *
    ** pokud je faktMnoz * ::nwds_sign > 0, tj. dobropis, pøíjem +, výdej -
    if faktMnoz * ::nwds_sign > 0
      return .t.
    endif

    * ok zapíšem nebo pøepíšeme wds_it
    if ok
      faktMnoz_D := faktMnoz

      if cfile_iv <> 'cenzboz'
        ::wds_mnozZdok := min(mnozZdok,faktMnoz)
        faktMnoz_D     := ::wds_mnozZdok
      endif

      lnew_wds_it := .f.

      if .not. wds_it->(dbseek(cky,,'WDS_IT_2'))
        wds_it->(dbappend())

        lnew_wds_it := .t.
        aadd(::alock_it, wds_it->(recNo()))

        wds_it->wds_key   := wds_hd->wds_key
        wds_it->cfile_iv  := cfile_iv
        wds_it->nrecs_iv  := nrecs_iv
        wds_it->cfile_ov  := ::it_file
        wds_it->nintCount := intCount
      endif

      if( lok := if( lnew_wds_it, .t., wds_it->( sx_rLock()) ))
        wds_it->nval := abs( faktMnoz_D )
      endif
      wds_it->(dbunlock(), dbcommit())


      * fakturuje z objitem s vazbou na cenzboz
      if cfile_iv = 'objitem' .and. upper(cenzboz->cpolcen) = 'C'
        cfile_iv := 'cenzboz'
        nrecs_iv := cenzboz->(recNo())

        cky := padr(::wds_key,40) +padr(upper(cfile_iv),10) +strZero(nrecs_iv,10)

        lnew_wds_it := .f.

        if .not. wds_it->(dbseek(cky,,'WDS_IT_2'))
          wds_it->(dbappend())

          lnew_wds_it := .t.
          aadd(::alock_it, wds_it->(recNo()))

          wds_it->wds_key   := wds_hd->wds_key
          wds_it->cfile_iv  := cfile_iv
          wds_it->nrecs_iv  := nrecs_iv
          wds_it->cfile_ov  := ::it_file
          wds_it->nintCount := intCount
        endif

        if( lok := if( lnew_wds_it, .t., wds_it->( sx_rLock()) ))
          wds_it->nval -= min( wds_it->nval, abs(faktm_org) )
          wds_it->nval += abs( faktMnoz )
        endif
        wds_it->(dbunlock(), dbcommit())
      endif

      *
      wds_it->(dbunlock(), dbcommit())

      if wds->(sx_rlock())
        wds->nseconds := seconds()
        wds->(dbunlock(), dbcommit())
      endif

      ::wds_watch_time()
    endif
  endif
return ok


* wds - zkontrolujeme zmìnu wds->nseconds
method wds:wds_watch_time()
  local  pa := {}
  local  cfile_iv, nrecs_iv, cfile_ov

  wds->(dbskip(0))

  if ::wds_nseconds <> wds->nseconds
    wds_it->(dbgotop())
    *
    ::wds_cenzboz  := {}
    ::wds_dodlstit := {}
    ::wds_objitem  := {}
    ::wds_vyrzak   := {}
    ::wds_pvpterm  := {}
    ::wds_objvysit := {}

    do while .not. wds_it->(eof())
      cfile_iv := allTrim(wds_it->cfile_iv)
      nrecs_iv := wds_it->nrecs_iv
      cfile_ov := allTrim(wds_it->cfile_ov)

      if cfile_ov = ::it_file

        do case
        case( cfile_iv = 'cenzboz' )  ;  pa := ::wds_cenzboz
        case( cfile_iv = 'dodlstit')  ;  pa := ::wds_dodlstit
        case( cfile_iv = 'objitem' )  ;  pa := ::wds_objitem
        case( cfile_iv = 'vyrzakit')  ;  pa := ::wds_vyrzak
        case( cfile_iv = 'pvpterm' )  ;  pa := ::wds_pvpterm
        case( cfile_iv = 'objvysit')  ;  pa := ::wds_objvysit
        endcase

        if (npos := ascan(pa, {|x| x[1] = nrecs_iv})) = 0
          //                                 FAKV  DLV  EXPV
          aadd( pa, { nrecs_iv, wds_it->nval,   0,   0,    0 })
          if( ::nwds_posSum <> 0, atail( pa )[ ::nwds_posSum ] := wds_it->nval, nil )
        else
                                  pa[npos,             2] += wds_it->nval
          if( ::nwds_posSum <> 0, pa[npos, ::nwds_posSum] += wds_it->nval, nil )
        endif
      endif

      wds_it->(dbskip())
    enddo

    ::wds_nseconds := wds->nseconds
  endif
return self


* wds -  ruší novou položku, mùžeme uvolnit množství
method wds:wds_postDelete()
  local  cky
  *
  local  faktMnoz := DBGetVal( ::it_file +'->' +::cwds_itmnoz)
  local  pa       := ::alock_it, npos
  local  intCount := 0

  if (::it_file)->_delrec = '9' .and. (::it_file)->_nrecor = 0

    * ach jo máme tìch intCount nìja moc - a furt jinak
    do case
    case (::it_file)->(fieldpos('nintcount')) <> 0
      intCount := (::it_file)->nintcount

    case (::it_file)->(fieldpos('norditem')) <> 0
      intCount := (::it_file)->norditem

    case (::it_file)->(fieldpos('ncislpolob')) <> 0
      intCount := (::it_file)->ncislpolob
    endcase
    *
    ** na pvpitem je jak nintCount tak nordItem, nordItem je položka dokladu
    if lower(::it_file) = 'pvpitemww'
      intCount := (::it_file)->norditem
    endif

    cky := padr(::wds_key,40)               + ;
           upper((::it_file)->cfile_iv)     + ;
           strZero((::it_file)->nrecs_iv,10)+ ;
            strZero( intCount,5)

    if wds_it->(dbseek(cky,,'WDS_IT_2'))

      if wds_it->( sx_rLock())
        wds_it->nval := max( wds_it->nval -abs( faktMnoz ), 0)
        if wds_it->nval = 0
          if( npos := ascan(pa, wds_it->(recNo()))) <> 0
            aRemove(pa, npos)
          endif
          wds_it->(dbdelete())
        endif

        wds_it->(dbunlock(), dbcommit())
      endif
    endif
    *
    if wds->(sx_rlock())
       wds->nseconds := seconds()
       wds->(dbunlock(), dbcommit())
    endif
  endif
return


* wds - po uložení dokladu vyprázdníme wds_it pokud pokraèuje v kruhu
method wds:wds_postSave()

  if wds_hd->(dbseek(::wds_key))
    wds_it->(dbsetScope(SCOPE_BOTH, ::wds_key), dbgoTop() )

    if .not. wds_it->(eof())
       wds_it->(dbgotop())
       wds_it->(dbeval( {|| if(wds_it->(sx_rlock()), wds_it->(dbdelete()), nil) } ))
       wds_it->(dbunlock())
     endif
     wds_it->(dbclearScope())
  endif

  wds_it->(dbunlock(), dbcommit())

  if wds->(sx_rlock())
    wds->nseconds := seconds()
    wds->(dbunlock(), dbcommit())
  endif
return self


* wds - odpojíme uživatele
method wds:wds_disconnect()
/*
  local  cStatement, oStatement
  local  stmt  := "delete from wds_hd where wds_key = '%wds_key' ; " + ;
                  "delete from wds_it where wds_key = '%wds_key' ; "

  cStatement := strTran( stmt, '%wds_key', ::wds_key )
  oStatement := AdsStatement():New(cStatement, oSession_data)

  if wds->(sx_rlock())
    wds->nusers   := max(wds->nusers -1, 0)
    wds->nseconds := seconds()
  endif

  if oStatement:LastError > 0
    *  return .f.
  else
    oStatement:Execute( 'test', .f. )
  endif

  wds->(dbunlock(),dbcommit())
   whd_hd->(dbUnlock(), dbCommit())
    wds_it->(dbUnlock(), dbCommit())
*/
  if wds->(sx_rlock())
    wds->nusers   := max(wds->nusers -1, 0)
    wds->nseconds := seconds()

    if wds_hd->(dbseek(::wds_key))
      if( wds_hd->(sx_rLock()), wds_hd->(dbDelete()), nil )
    endif

    wds_it->(dbsetScope(SCOPE_BOTH, ::wds_key), dbgotop())
    if .not. wds_it->(eof())
      wds_it->(dbgotop())
      wds_it->(dbeval( {|| if(wds_it->(sx_rlock()), wds_it->(dbdelete()), nil) } ))
      wds_it->(dbunlock())
    endif
    wds_it->(dbclearScope())

  endif

  wds->(dbunlock(),dbcommit())
   wds_hd->(dbunlock(),dbcommit())
    wds_it->(dbunlock(),dbcommit())
return self