#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "DRGres.Ch'
#include "XBP.Ch"
*
#include "DMLB.CH"
*
#include "std.ch"
#include "..\Asystem++\Asystem++.ch"


#define m_files  { 'c_staty' , 'c_meny'  , 'c_typpoh', 'c_vykdph' , ;
                   'c_zpuSrz', 'c_period'                         , ;
                   'kurzit'                                       , ;
                   'trvZavHd', 'trvZavIt'                         , ;
                   'mzdZavhd', 'firmy'   , 'firmyFi' , 'firmyuc'    }


*
** CLASS for MZD_trvZavhd_SCR **************************************************
CLASS MZD_trvZavhd_SCR FROM drgUsrClass, FIN_finance_IN
exported:
  var     lnewRec
  method  init, drgDialogStart, tabSelect
  method  itemMarked
  *
  method  W_maximize
  *
  *
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


method MZD_trvZavhd_scr:W_maximize()
  local hWnd

  hWnd := ::drgDialog:dialog:getHwnd()

  if IsZoomed(hwnd) = 1
    ShowWindow(hwnd,SW_SHOWNORMAL)
  else
    ShowWindow(hwnd,SW_SHOWMAXIMIZED)
  endif

  ::drgDialog:dialog:invalidateRect()
*-  ::drgDialog:dialog:show()
return .t.


METHOD MZD_trvZavhd_scr:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)

  ::lnewRec := .f.
  ::tabnum  := 1

  * základní soubory
  ::openfiles(m_files)

  ** likvidace
  ::FIN_finance_in:typ_lik := 'zav'
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'fakprihd')
  endif
RETURN self


METHOD MZD_trvZavhd_SCR:drgDialogStart(drgDialog)

  ::brow := drgDialog:dialogCtrl:oBrowse
*-  FAKPRIHD ->(DbGoBottom())
RETURN


METHOD MZD_trvZavhd_SCR:tabSelect(oTabPage,tabnum)
  local lrest := (tabNum = 2)

  ::tabnum := tabnum
  ::itemMarked()

  if(lrest,::brow[2]:oxbp:refreshAll(),nil)
RETURN .T.


METHOD MZD_trvZavhd_SCR:itemMarked()
  local  cfiltr := format( "trvZavhd = %%", { isNull( trvZavhd->sID, 0) })

  mzdZavhd->( ads_setAof(cfiltr), dbgoTop())

  c_zpuSrz->(dbseek( upper(trvZavhd->czpusSraz),,'ZPUSRZ01'  ))
  c_period->(dbseek( upper(trvZavhd->cPerioda) ,,'C_PERIOD01'))

*  drgMsg(drgNLS:msg(c_zpuSrz->cpopisZPsr),DRG_MSG_INFO,::drgDialog)
RETURN SELF


method MZD_trvZavhd_scr:postDelete()
  local  nsel, nodel := .f.
  local  cinfo, lLock := .t.

  lLock := trvZavhd->( sx_RLock())

  c_typPoh->(dbseek( 'M' +upper( trvZavhd->ctypPohybu),,'C_TYPPOH06'))

  cinfo := 'Promiòte prosím,'                                         +CRLF + ;
           'požadujete zrušit trvalý závazek _'                       +CRLF + ;
           '[ ' +allTrim(c_typPoh->cnazTypPoh) +' ]'                  +CRLF +CRLF+ ;
           'pro firmu [' +str( trvZavhd->ncisFirmy) +'] _' +trvZavhd->cnazev


  if lLock
    nsel := ConfirmBox( , cinfo, ;
                         'Zrušení trvalého závazku...'                , ;
                          XBPMB_YESNO                                 , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE, ;
                          XBPMB_DEFBUTTON2                              )

    if nsel = XBPMB_RET_YES
      trvZavhd->(dbDelete())
    else
      nodel := .t.
    endif
  endif

  if nodel
    if .not. lLock
      ConfirmBox( ,'Záznam trvalého závazku _ '        +CRLF + ;
                   'je blokován uživatelem ...'              , ;
                   'Zrušení trvalého závazku...'             , ;
                    XBPMB_CANCEL                          , ;
                    XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    endif
  endif

  trvZavhd->( dbunLock(), dbcommit() )

  if( ::brow[1]:oxbp:rowPos = 1, ::brow[1]:oxbp:goTop(), nil )
  ::brow[1]:oxbp:refreshAll()
return .not. nodel