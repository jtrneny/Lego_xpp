#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys' ,'uzavisoz','dphdada','dph_2001','dph_2004'            , ;
                   'c_dph'   ,'c_bankuc','c_meny'  ,'c_vykdph','c_typpoh'           , ;
                   'dodlsthd','dodlstit','pvphead' ,'pvpitem'                       , ;
                   'banvyphd','banvypit','pokladhd','pokladit','range_hd','range_it', ;
                   'objitem' ,'ucetpol' ,'cenzboz'                                    }



*
** CLASS for PRO_dodlsthd_SCR **************************************************
CLASS PRO_dodlsthd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked
  method  pro_dodlsthd_vykr, pro_pvpHead

  * položky - bro
  * dodací listy z PRODEJE mají vyplnìný údaj cTask = 'PRO'
  *              z FINANCÍ                    cTaks = ''
  inline access assign method is_taskPro var is_taskPro
    return if( upper(dodlsthd->ctask) = 'PRO', 0, MIS_NO_RUN )

  * test jestli je již DL i èásteènì fakturován
  inline access assign method is_dlFak() var is_dolFak
    local  ky     := strzero(dodlsthd->ndoklad,10)
    local  is_fak := .f.

    dodlsti_fa->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    dodlsti_fa->( dbeval( { || ;
                  if( fakvysi_dl->( dbseek(dodlsti_fa->ncisVysFak,,'FVYSIT13')), is_fak := .t., nil ) } ) )
    return if( is_fak, MIS_ICON_ERR, 0)

  * dodlstit
  inline access assign method cenPol() var cenPol
    return if(dodlstit->cpolcen = 'C', MIS_ICON_OK, 0)

  * objitem
  inline access assign method stav_dodlstit() var stav_dodlstit
    local retVal := 0
    local stav_fakt := dodlstit->nstav_fakt

    do case
    case( stav_fakt = 1 )  ;  retVal := 303 // MIS_BOOKOPEN
    case( stav_fakt = 2 )  ;  retVal := 302 // MIS_BOOK
    endcase
    return retVal

 * explstit
  inline access assign method is_vyrZakit() var is_vyrZakit
    return if( .not. empty(explstit->ccisZakazI), MIS_ICON_OK, 0)

  inline access assign method is_dodList() var is_dodList
    return if( .not. empty(explstit->ncisloDL), MIS_ICON_OK, 0)

  inline access assign method firmaODB() var firmaODB
    local retVal := ''

    if .not. empty(explstit->ncisFirmy)
      retVal := str(explstit->ncisFirmy) +' _' +left(explstit->cnazev,25)
    endif
  return retVal

  inline access assign method firmaDOA() var firmaDOA
    local retVal := ''

    if .not. empty(explstit->ncisFirDOA)
      retVal :=  str(explstit->ncisFirDOA) +' _' +left(explstit->cnazevDOA,25)
    endif
   return retVal


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case nEvent = drgEVENT_REFRESH
      if( oxbp:classname() = 'XbpBrowse', ::enable_or_disable_buttVykr(), nil )

    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, dc, brow
  var     posVykr, buttVykr, menuVykr
  method  postDelete

  * tlaèítko a menu ruèní vykrytí dodacího listu jen pro is_taskPro = TRUE
  inline method enable_or_disable_buttVykr()
    local ok := .f.

    if ::posVykr <> 0
      * dodlsthd - dodlstit
      do case
      case ::dc:oaBrowse = ::brow[1]
        filter  := format( 'ndoklad = %% .and. ( nstav_FAKT = 1 .or. nstav_FAKT = 0 )', {dodlsthd->ndoklad} )
        dodlsti_sF ->( ads_setAof( filter ), dbgotop() )

        ok := ( ::is_taskPro = 0 ) .and. .not. dodlsti_sF->(eof())

      case ::dc:oaBrowse = ::brow[2]
        ok := ( ::is_taskPro = 0 ) .and. dodlstit->nstav_FAKT <> 2

      endcase

      ::buttVykr:disabled := .not. ok
      if(ok, ::buttVykr:oxbp:enable()        , ::buttVykr:oxbp:disable()         )
    endif
    return self

ENDCLASS


METHOD PRO_dodlsthd_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1
  ::posVykr := 0

  * základní soubory
  ::openfiles(m_files)
  drgDBMS:open( 'dodlstit',,,,, 'dodlsti_fa' )
  drgDBMS:open( 'dodlstit',,,,, 'dodlsti_sF' )  // stav fakturace
  drgDBMS:open( 'fakvysit',,,,, 'fakvysi_dl' )

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'

RETURN self


METHOD PRO_dodlsthd_SCR:drgDialogStart(drgDialog)
  local  nposIn
  local  ab := drgDialog:oActionBar:members    // actionBar

  ::dc   := drgDialog:dialogCtrl               // dataCtrl
  ::brow := drgDialog:dialogCtrl:oBrowse

  if( nposIn := ascan( ab, { |s| s:event = 'pro_dodlsthd_vykr' } )) <> 0
    ::posVykr  := nposIn
    ::buttVykr := ab[ nposIn ]
*    ::menuVykr := ab[ nposIn ]:parent:aMenu
  endif

*-  dodlsthd->(dbgobottom())
RETURN


METHOD PRO_dodlsthd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method pro_dodlsthd_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := '', ok := .f.
  local filter

  if(isObject(arowco) .and. arowco:className() = 'drgDBrowse', oxbp := arowco:oxbp, nil)

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'dodlsthd','ab',if(cfile = 'dodlstit','b', ''))

    if( 'a' $ rest)
      ky := strzero(dodlsthd->ndoklad,10)
      dodlstit->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

    if ('b' $ rest)
      ky := strzero(dodlstit->ncisVysFak,10) +strzero(dodlstit->nintcount,5)
*      fakvysit->(AdsSetOrder('FVYSIT8'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
      fakvysit->(AdsSetOrder('FVYSIT15'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

      ky := upper(dodlstit->ccissklad) +strzero(dodlstit->ncislopvp,10) +strzero(dodlstit->nintcount,5)
      pvpitem->(AdsSetOrder('PVPITEM26'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

      ky := strZero(dodlstit->ncisloel,10) +strZero(dodlstit->npolel,5)
      explstit->(AdsSetOrder('EXPLSTIT04'), dbsetScope(SCOPE_BOTH,ky), dbgotop())
    endif
  endif

  * info
  c_typpoh->(dbseek(upper(dodlsthd->culoha) +upper(dodlsthd->ctypdoklad) +upper(dodlsthd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)

  * tlaèítko a menu ruèní vykrytí dodacího listu jen pro is_taskPro = TRUE
  ::enable_or_disable_buttVykr()
return self


method pro_dodlsthd_scr:postDelete()
  local  nsel, nodel := .f.

  if dodlsthd->ncisfak = 0 .and. fakvysit->(eof())
    nsel := ConfirmBox( ,'Požadujete zrušit dodací list _' +alltrim(str(dodlsthd->ndoklad)) +'_', ;
                         'Zrušení dodacího listu dokladu ...'         , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      drgDBMS:open('pvphead',,,,,'pvp_head')
      drgDBMS:open('pvpitem',,,,,'pvp_item')

      pro_dodlsthd_cpy(self)
      nodel := .not. pro_dodlsthd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Dodací list _' +alltrim(str(dodlsthd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení dodacího listu ...' , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


method  pro_dodlsthd_scr:pro_dodlsthd_vykr()
  local  anDol := {}

  do case
  case ::dc:oaBrowse = ::brow[1]
    FORDrec({'dodlstit'})
    dodlstit->( dbeval( {|| aadd( anDol, dodlstit->(recNo())) }), dbgoTop())

    if dodlstit->(sx_rLock(anDol))
      if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí dodacího listu ?') )

        do while .not. dodlstit ->(eof())
          dodlstit->nmnoz_fakt := dodlstit->nfaktMnoz
          dodlstit->nstav_fakt := 2

          dodlstit->nmnoz_fakv := dodlstit->nfaktMnoz
          dodlstit->nstav_fakv := 2

          dodlstit->(dbskip())
        enddo
      endif
    endif
    FORDrec()

  otherwise
    if dodlstit->(sx_rLock())
      if drgIsYesNo( drgNLS:msg('Opravdu požadujete ruèní vykrytí pložky dodacího listu ?') )

        dodlstit->nmnoz_fakt := dodlstit->nfaktMnoz
        dodlstit->nstav_fakt := 2

        dodlstit->nmnoz_fakv := dodlstit->nfaktMnoz
        dodlstit->nstav_fakv := 2
      endif
    endif

  endcase

  dodlstit ->(dbunlock(), dbcommit())

  ::brow[2]:oxbp:refreshAll()
  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return


method pro_dodlsthd_scr:pro_pvpHead(drgDialog)
  local  odialog, nexit, pa := {}, x, filter := '', m_filter

  m_filter := format("ncislodl = %%",{dodlsthd->ndoklad})

  if(select('pvphead') = 0, drgDBMS:open('pvphead'), nil)
  pvphead->(ads_setAof(m_filter), dbgotop())

  oDialog := drgDialog():new('fin_fakvyshd_pvphead',drgDialog)
  odialog:create(,,.T.)

  pvphead->(ads_clearAof())

  odialog:destroy()
  odialog := nil

//  ::itemMarked()
return