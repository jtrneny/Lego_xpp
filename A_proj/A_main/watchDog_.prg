#include "class.ch"
#include "common.ch"
#include "dbstruct.ch"
#include "dmlb.ch"
*
#include "ads.ch"
#include "foxdbe.ch"
#include "adsdbe.ch"
#include "directry.ch"


*
********* OBECNÁ TØÍDA PRO KONROLU MNOŽSTVÍ NA DOKLADU *************************
CLASS WATCHDOG
EXPORTED:
  var  cky
  var  watch_time, watch_thread
  *
  ** sem umístíme metody a var pro - wds
  * var wds_time, wds_cenzboz, wsd_dodlstit, wds_objitem, wds_vyrzak
  * method wds_connect, wds_disconnect
  *
/*
  inline method  notify(nEvent, mp1, mp2)
    local cfile := lower(alias(select())), cinfo

    do case
    case cfile = 'watchdog'
      if mp1 = DBO_TABLE_UPDATE
        if ::watch_thread = watchDog->nthread
          cinfo := 'Vlákno '+ str(::watch_thread) +' provedlo zmìnu ...'
        else
          cinfo := 'Informace pro vlákno ' +str(::watch_thread) +'; vlákno '+ str(watchDog->nthread) +' provedlo zmìnu ...'
        endif

        fin_info_box(cinfo)
      endif

    case cfile = 'watch_hd'

    case cfile = 'watch_it'

    endcase
  return self
*/


  inline method wds_connect()
    local bSaveErrorBlock := ErrorBlock( {|e| Break(e)} )
    *
    local d_ext, i_ext, m_ext

    d_ext := DbeInfo( COMPONENT_DATA , DBE_EXTENSION       )
    i_ext := DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT    )
    m_ext := DbeInfo( COMPONENT_DATA , ADSDBE_MEMOFILE_EXT )

    begin sequence
      *
      ** pokud watchDog otevøu exclusive - jsem tam sám
      *
      drgDBMS:open('watchdog',.t.)
      watchDog->(dbCloseArea())

      fErase( drgINI:dir_DATA +'watchDog.' +d_ext)
      *
      fErase( drgINI:dir_DATA +'watch_hd.' +d_ext)
      fErase( drgINI:dir_DATA +'watch_hd.' +i_ext)

      fErase( drgINI:dir_DATA +'watch_it.' +d_ext)
      fErase( drgINI:dir_DATA +'watch_it.' +i_ext)
    recover using oError
    end sequence

    ErrorBlock(bSaveErrorBlock)

    drgDBMS:open('watchdog')
    drgDBMS:open('watch_hd')
    drgDBMS:open('watch_it')

*    watchDog->(DbRegisterClient( self ))

    ::watch_thread := ThreadID()


    if watchDog->(eof())
      watchDog->(dbappend())
      *
*      watchDog->nusers  := 1
*      watchDog->ctime   := time()
    else
*      watchDog->(sx_rlock())
      *
*      watchDog->nusers := watchDog->nusers +1
*      watchDog->ctime  := time()
    endif

    watchDog->(dbUnlock(),dbcommit())
    ::watch_time := watchDog->ctime
*/

  return self

  *
  ** FAKVYSITW
  inline method fakvysitw(parent)
    local  pky := upper(fakvyshdw->culoha) +upper(fakvyshdw->ctypdoklad) +upper(fakvyshdw->ctyppohybu)
    local  is_modCen, cfile_iv, isNew_it, drgVar

    * je to doklad který odepisuje z CENZBOZ ?
    c_typpoh->(dbseek(pky,,'C_TYPPOH05'))
    is_modCen :=  .not. empty(c_typpoh->csubpohyb)

    cfile_iv  := parent:dm:get('fakvysitw->cfile_iv')
    isNew_it  := (parent:state = 2)
    drgVar    := parent:dm:has('fakvysitw->nfaktmnoz')
    faktMnoz  := drgVar:value - drgVar:initValue

    if faktMnoz <> 0
      do case
      case( cfile_iv = 'cenzboz' .and. ::is_polCen(parent) .and. is_modCen )

      endcase
    endif
  return .t.

HIDDEN:

  *
  ** ceníková položka - doklad odepisuje ze stavu
  inline method is_polCen(parent)
    ::cky := upper(parent:dm:get('fakvysitw->ccisSklad') +parent:dm:get('fakvysitw->csklPol'))

    if cenzboz->(dbseek(::cky,,'CENIK03')) .and. upper(cenzboz->cpolcen) = 'C'
      return .t.
    endif
  return .f.
ENDCLASS





/*
wds_connectUser
wds_disconnectUser
wds_postAppend_key
wsd_postDelete_key

watchDog

cuser     c 10

cprocess  c 20   10 _str(GetCurrentProcessId()) + 10 _str(ThreadID())

cfile     c 10
nrecs     n 10
nval      n 13.4


function userWorkDir()
  local processID := if(isWorkVersion, '', allTrim(str(GetCurrentProcessId())))
  local cthreadID := allTrim(str(ThreadID()))

return 'dir_' +processID +cthreadID



nmnozWork n 13.4  -- rozpracované množství na dokladech


cfile_iv     cky                                   nabízí do dokladu           kontroluje na
--------     ----------------------------------    ---------------------       --------------
cenzboz      ccisSklad   [ 8] +csklPol     [15]    0                           nmnozDzbo                - watchdog->nval
dodlstit     ndoklad     [10] +nintCount   [ 5]    nfaktMnoz                   nfaktMnoz                - watchdog->nval
objitem      ccisloObInt [30] +ncisloPolOb [ 5]    nmnozobodb                  nmnozobodb               - watchdog->nval
vyrzak       ccisZakazI  [36]                      nmnozplano -nmnozfakt       (nmnozplano -nmnozfakt)  - watchdog->nval


    case(name = ::it_file +'->nfaktmnoz')
      cky := ::dm:get(::it_file +'->ccissklad') +::dm:get(::it_file +'->csklpol')
      pky := upper((::hd_file)->culoha) +upper((::hd_file)->ctypdoklad) +upper((::hd_file)->ctyppohybu)
      c_typpoh->(dbseek(pky,,'C_TYPPOH05'))

      do case
      case( value = 0 )
        ::msg:writeMessage('Fakturové množství nesmí být NULOVÉ ...',DRG_MSG_ERROR)
        ok := .f.

      otherwise
        * fakturuji z vazbou na pohyby
        if .not. empty(c_typpoh->csubpohyb)
          if cenzboz->(dbseek(upper(cky),,'CENIK03'))
            if upper(cenzboz->cpolcen) = 'C'
              mnozDzbo  := cenzboz->nmnozDzbo +if(::o:state <> 2,(::it_file)->nfaktmnoz, 0)
              typsklcen := lower(cenzboz->ctypsklcen)

              if value > mnozDzbo
                ok := .not. (typsklcen = 'pru')
                ::msg:writeMessage('Dispozièní množství je pouze [' +str(mnozDzbo) +'] ...', ;
                                    if(ok, DRG_MSG_WARNING,DRG_MSG_ERROR)                    )
              endif
            endif
          endif
        endif
      endcase

method watchDog:init()
  local  oadsSession, cConnect, cpath := 'G:\LEGO_xpp\Asystem++_JSU\DD\xbasemopas.add'

  cconnect := "DBE=ADSDBE;SERVER="+cpath

  oadsSession := DacSession():New(cConnect)

  If oadsSession:isConnected()
    DBEINFO( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_CDX )
    DBEINFO( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_CDX )
    AX_AXSLOCKING( .T. )
    AX_RIGHTSCHECK( .F. )
    DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, "CDX" )
  EndIf
RETURN oadsSession:isConnected()


 cConnect := "DBE=ADSDBE;SERVER=" +AllTrim(drgINI:dir_DATA)   //  \\LICHTENSTEIN\ROY01"
    oSession := dacSession():New( cConnect)



FUNC _ADSSESSION()
LOCAL oADSSession, cConnect
  C_PATH := "F:\CUSTLIST\ROSS\SYSDATA\Ross.ADD"
  cConnect := "DBE=ADSDBE;SERVER="+C_PATH+";UID=ADSSYS;PWD=ross"
  oADSSession := DacSession():New(cConnect)
  If oADSSession:isConnected()
    oADSSession:setdefault()
    DBEINFO( COMPONENT_DATA, ADSDBE_TBL_MODE, ADSDBE_CDX )
    DBEINFO( COMPONENT_ORDER, ADSDBE_TBL_MODE, ADSDBE_CDX )
    AX_AXSLOCKING( .T. )
    AX_RIGHTSCHECK( .F. )
    DbeInfo( COMPONENT_ORDER, ADSDBE_INDEX_EXT, "CDX" )
  EndIf
RETURN oADSSession:isConnected()
*/


*/