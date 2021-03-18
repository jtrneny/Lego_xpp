#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
*
// #include "Asystem++.Ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for PRO_nabprihd_SCR **************************************************
CLASS VYR_servis_vyrpol_IN FROM drgUsrClass
EXPORTED:
  var     lnewRec
  method  init, drgDialogStart, tabSelect, itemMarked, postDelete
  method  empty_Kusov

  * bro nabvyshd
//  inline access assign method nazFirmy() var nazFirmy
//    local  ky := nabprihd ->ncisfirmy
//    firmy->(dbseek(ky,,'FIRMY1'))
//    return firmy->cnazev

  *
//  inline method eventHandled(nEvent, mp1, mp2, oXbp)
//    do case
//    case nEvent = drgEVENT_DELETE
//      ::postDelete()
//      return .t.
//    endcase
//    return .f.

  * nabvyshd
//  inline access assign method stav_nabvyshd() var stav_nabvyshd
//    local retVal := 0
//    local doklad := strZero(nabvyshd->ndoklad,10)
    *
//    local s_0    := objit_sth->(dbseek(doklad +'0'))
//    local s_1    := objit_sth->(dbseek(doklad +'1'))
//    local s_2    := objit_sth->(dbseek(doklad +'2'))

//    do case
//    case( .not. s_1 .and. .not. s_2)            ;  retVal := 0
//    case( .not. s_0 .and. .not. s_1) .and. s_2  ;  retVal := 302
//    otherwise                                   ;  retVal := 303
//    endcase
//    return retVal

/*
    do case
    case(nabvyshd->nmnozplodb = 0                   )  ;  retVal := 301
    case(nabvyshd->nmnozplodb >= nabvyshd->nmnozobodb)  ;  retVal := 302
    case(nabvyshd->nmnozplodb <  nabvyshd->nmnozobodb)  ;  retVal := 303
    endcase
    return retVal
*/

  * objitem

HIDDEN:
  var tabnum, brow

ENDCLASS


method VYR_servis_vyrpol_IN:init(parent)
  local  pa_initParam

  ::drgUsrClass:init(parent)
  *
  ::tabnum  := 1
  ::lnewRec := .f.
  *
  *
  ** vazba na FIRMY - volání z fir_firmy_scr
  if len(pa_initParam := listAsArray( parent:initParam )) = 2
    ::drgDialog:set_prg_filter(pa_initParam[2], 'nabvyshd')
  endif
return self


method VYR_servis_vyrpol_IN:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
return


method VYR_servis_vyrpol_IN:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
return .t.


method VYR_servis_vyrpol_IN:itemMarked()
  local mky := nabprihd->ndoklad

  nabpriit->( AdsSetOrder( 'NABPRII8' ), dbsetScope( SCOPE_BOTH,mky),dbgotop())
return self


method VYR_servis_vyrpol_IN:postDelete()
  local  nsel, nodel := .f.
  *
  local  cdoklad := allTrim(str(nabprihd->ndoklad))

  if nabprihd->ndoklad <> 0
    nsel := ConfirmBox( ,'Požadujete zrušit nabídku pøijatou _' +cdoklad +'_', ;
                         'Zrušení nabídky pøijaté ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

   if nsel = XBPMB_RET_YES
     nak_nabprihd_cpy(self)
     nodel := .not. nak_nabprihd_del(self)
     *
     nabprihdw->( dbCloseArea())
     nabpriitw->( dbCloseArea())
   else
     nodel := .f.
   endif
 endif


  if nodel
    ConfirmBox( ,'Nababídku pøijatou _' +cdoklad +'_' +' nelze zrušit ...', ;
                 'Zrušení nabídky pøijaté ...' , ;
                 XBPMB_CANCEL                       , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif

  postAppEvent(xbeBRW_ItemMarked,,,::brow[1]:oxbp)
return .not. nodel


method VYR_servis_vyrpol_IN:empty_Kusov()
  local nsel

  nsel := ConfirmBox( ,'Požadujete zrušit vyrábìné položky a všechny vazby', ;
                         'Zrušení kusovníkù a všech vazeb ...' , ;
                          XBPMB_YESNO                     , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE,XBPMB_DEFBUTTON2)

  if nsel = XBPMB_RET_YES
    drgDBMS:open('kusov',.t.) ; ZAP
    drgDBMS:open('kusovi',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP
    drgDBMS:open('kusovw',.t.,.t.,drgINI:dir_USERfitm,,,.t.) ; ZAP
//    drgDBMS:open('vyrpol',.t.) ; ZAP
    drgDBMS:open('vykresy',.t.) ; ZAP
    drgDBMS:open('poloper',.t.) ; ZAP
    drgDBMS:open('objhead',.t.) ; ZAP
    drgDBMS:open('objitem',.t.) ; ZAP
  //  drgDBMS:open('listhd',.t.) ; ZAP
  //  drgDBMS:open('listit',.t.) ; ZAP


    drgDBMS:open('vyrpol',,,,,'vyrpoli')
    vyrpoli->(dbgotop())
    do while .not. vyrpoli->(eof())
      if vyrpoli->( rLock())
        vyrpoli->(dbDelete())
        vyrpoli->(dbUnlock())
      endif
      vyrpoli->(dbSkip())
    enddo


    drgDBMS:open('cenzboz',,,,,'cenzbozi')
    cenzbozi->(dbgotop())
    do while .not. cenzbozi->(eof())
      if cenzbozi->ctypsklpol = 'R' .or. cenzbozi->ctypsklpol = 'P' .or.   ;
          cenzbozi->ctypsklpol = 'S' .or. cenzbozi->ctypsklpol = 'X'
        if cenzbozi->( rLock())
          cenzbozi->(dbDelete())
          cenzbozi->(dbUnlock())
        endif
      endif
      cenzbozi->(dbSkip())
    enddo

  //  drgDBMS:open('nakpol',,,,,'nakpoli')
  endif

return