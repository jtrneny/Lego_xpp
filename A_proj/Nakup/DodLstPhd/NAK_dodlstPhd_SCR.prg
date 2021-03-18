#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"

// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'ucetsys'  ,'uzavisoz' ,'dphdada' ,'dph_2001','dph_2004'           , ;
                   'c_dph'    ,'c_bankuc' ,'c_meny'  ,'c_vykdph','c_typpoh'           , ;
                   'dodlstPhd','dodlstPit','pvphead' ,'pvpitem','fakprihd','fakpriit' , ;
                   'banvyphd' ,'banvypit' ,'pokladhd','pokladit','range_hd','range_it', ;
                   'objitem'  ,'ucetpol'  ,'cenzboz'                                    }



*
** CLASS for NAK_dodlstPhd_SCR ************************************************
CLASS NAK_dodlstPhd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked

  * položky - bro
  * dodací listy z PRODEJE mají vyplnìný údaj cTask = 'PRO'
  *              z FINANCÍ                    cTaks = ''
  inline access assign method is_taskPro var is_taskPro
    return if( upper(dodlstPhd->ctask) = 'PRO', 0, MIS_NO_RUN )

  inline access assign method cenPol() var cenPol
    return if(dodlstPit->cpolcen = 'C', MIS_ICON_OK, 0)

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
    case nEvent = drgEVENT_DELETE
      ::postDelete()
      return .t.
    endcase
    return .f.

hidden:
  var     tabnum, brow
  method  postDelete
ENDCLASS


METHOD NAK_dodlstPhd_SCR:Init(parent)
  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)

  ** likvidace
  ::FIN_finance_in:typ_lik := 'poh'
RETURN self


METHOD NAK_dodlstPhd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
*-  dodlsthd->(dbgobottom())
RETURN


METHOD NAK_dodlstPhd_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
RETURN .T.


method NAK_dodlstPhd_scr:itemMarked(arowco,unil,oxbp)
  local ky, rest := ''


  if(isObject(arowco) .and. arowco:className() = 'drgDBrowse', oxbp := arowco:oxbp, nil)

  if isobject(oxbp)
    cfile := lower(oxbp:cargo:cfile)
    rest  := if(cfile = 'dodlstphd','ab',if(cfile = 'dodlstpit','b', ''))

    if( 'a' $ rest)
      ky := strzero(dodlstPhd->ndoklad,10)
      dodlstPit->(AdsSetOrder('DODLIT5'),dbsetscope(SCOPE_BOTH,ky),dbgotop())
    endif

    if ('b' $ rest)
      ky := strzero(dodlstPit->ncisVysFak,10) +strzero(dodlstPit->nintcount,5)
      fakpriit->(AdsSetOrder('FAKPRIIT01'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

      ky := upper(dodlstPit->ccissklad) +strzero(dodlstPit->ncislopvp,10) +strzero(dodlstPit->nintcount,5)
      pvpitem->(AdsSetOrder('PVPITEM26'),dbsetscope(SCOPE_BOTH,ky),dbgotop())

*      ky := strZero(dodlstPit->ncisloel,10) +strZero(dodlstPit->npolel,5)
*      explstit->(AdsSetOrder('EXPLSTIT04'), dbsetScope(SCOPE_BOTH,ky), dbgotop())
    endif
  endif

  * info
  c_typpoh->(dbseek(upper(dodlstPhd->culoha) +upper(dodlstPhd->ctypdoklad) +upper(dodlstPhd->ctyppohybu),,'C_TYPPOH05'))
  drgMsg(drgNLS:msg(c_typpoh->cnaztyppoh),DRG_MSG_INFO,::drgDialog)
return self


method NAK_dodlstPhd_scr:postDelete()
  local  nsel, nodel := .f.

  if dodlstPhd->ncisfak = 0
    nsel := ConfirmBox( ,'Požadujete zrušit dodací list pøijatý _' +alltrim(str(dodlsthd->ndoklad)) +'_', ;
                         'Zrušení dodacího listu dokladu ...'         , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      drgDBMS:open('pvphead',,,,,'pvp_head')
      drgDBMS:open('pvpitem',,,,,'pvp_item')

      NAK_dodlstPhd_cpy(self)
      nodel := .not. NAK_dodlstPhd_del(self)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'Dodací list pøijatý _' +alltrim(str(dodlstPhd->ndoklad)) +'_' +' nelze zrušit ...', ;
                 'Zrušení dodacího listu ...' , ;
                 XBPMB_CANCEL                     , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel