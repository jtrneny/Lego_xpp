#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Konfigurace - Naplánované úlohy
** CLASS for SYS_userstsk_IN ******************************************************
CLASS VYR_vyrpol_def_IN FROM drgUsrClass
EXPORTED:
  METHOD  itemSelected
  METHOD  init, drgDialogStart, preValidate, postValidate
  METHOD  postAppend   ///, onSave
  METHOD  itemMarked
  METHOD  checkItemSelected, deleteTSK
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow


  *
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EDIT
      ::itemSelected(.F.)
      Return .T.

    CASE nEvent = drgEVENT_DELETE
*      ::deleteFRM()
      Return .T.

    CASE nEvent = drgEVENT_APPEND
*      if( oXbp:ClassName() <> 'XbpCheckBox', ::SYS_forms_modi_CRD(.T.), NIL)
      Return .T.

    CASE nEvent = drgEVENT_APPEND2
*      if( oXbp:ClassName() <> 'XbpCheckBox', ::copy_CRD(), NIL)
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
        RETURN .F.
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR     msg, dm, dctrl, df, ab, pushOk, aktSID

*  METHOD  verifyActions
ENDCLASS


METHOD VYR_vyrpol_def_IN:init(parent)

//  ::defOpr   := defaultDisUsr('Forms','CTYPFORMS')

  ::drgUsrClass:init(parent)
  drgDBMS:open('vp_set',,,,, 'vp_seta')
*  drgDBMS:open('c_termin')
*  drgDBMS:open('stavterm')
*  drgDBMS:open('FILTRS',,,,, 'FILTRSs')

  * tady nevím jestli zap *
*  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


method VYR_vyrpol_def_IN:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager


*  ::odrgCombo_MBLOCKFRM  := ::dm:has( 'FORMS->MBLOCKFRM' )
*  ::odrgCombo_MBLOC_USER := ::dm:has( 'FORMS->MBLOC_USER')

// * nevím  if( ::newRec, ::postAppend(), ::dm:refresh())
return self


METHOD VYR_vyrpol_def_IN:itemMarked()
  local  filtr

//  filtr := Format("nC_Termin = %%", { c_termin->sid})
//  stavterm->( AdsSetOrder(1), ads_setaof(filtr), DBGoTop())

return self


* ok
method VYR_vyrpol_def_IN:postAppend()
  local x, ovar, type, val, ok, file
  local name

  for x := 1 to ::dm:vars:size() step 1
    ok   := .f.
    ovar := ::dm:vars:getNth(x)
    type := valtype(ovar:value)
    file := lower(drgParse(ovar:name,'-'))

    do case
    case(type == 'N')  ;  val := 0
    case(type == 'C')  ;  val := ''
    case(type == 'D')  ;  val := ctod('  .  .  ')
    case(type == 'L')  ;  val := .f.
    case(type == 'M')  ;  val := ''
    endcase

    ovar:set(val)
    ovar:initValue := ovar:prevValue := ovar:value := val
  next
return .t.


method VYR_vyrpol_def_IN:CheckItemSelected(drgCheck)

return


method VYR_vyrpol_def_IN:itemSelected(new)
  local  mod
  *
  if ::selForm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  else
*    if(.not. empty(forms->cidForms), ::SYS_forms_modi_CRD(.F.), nil)
  endif
RETURN SELF




METHOD VYR_vyrpol_def_IN:preValidate(drgVar)
  local  lOk := .T., odesc
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')


  if lower(drgVar:name) = 'vp_set->laktivni'
    ::aktSID := if( vp_seta->( dbSeek( Upper( Padr(usrName,10))+'1',, 'VP_SET_3')), vp_seta->sid, 0)
  endif


//  if lower(drgVar:name) = 'stavterm->ctask'
//   ::dm:set( name, 'DOH' )
//    stavterm->ctask := 'DOH'
//  endif


RETURN lOk


method VYR_vyrpol_def_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.

  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
    if drgVar:changed()
    endif

*    ::verifyActions(.T.)
  endif
RETURN lOk


method VYR_vyrpol_def_IN:ebro_beforeAppend(o_ebro)


/*
  local m_file   := lower(o_ebro:cfile), s_filter, filter
  local m_filter := "NTYPPROCEN = %% .and. NCISPROCEN = %%"

  do case
  case (m_file = ::hd_file )
    filter := format(m_filter, { 0, 0 })

    (::it_file)->(ads_setAof(filter),dbgotop())
    ::oabro[2]:oxbp:refreshAll()

    ::panGroup := Str(if(procenhd->ntypProcen <= 4, 1, procenhd->ntypProCen), 1)

    filter := format(filter +" .and. NPOLPROCEN = %%", {(::it_file)->npolprocen})
    (::ho_file)->(ads_setAof(filter),dbgotop())
    ::oabro[3]:oxbp:refreshAll()

  case (m_file = ::it_file )
     filter   := format(m_filter +" .and. NPOLPROCEN = %%", { 0, 0, 0 } )

     (::ho_file)->(ads_setAof(filter),dbgotop())
     ::oabro[3]:oxbp:refreshAll()

  endcase
*/
return .t.


method VYR_vyrpol_def_IN:ebro_afterAppend(o_ebro)
  local  cfile   := lower( o_EBro:cfile)

  ::dm:set( 'vp_set->cuser'     , usrName)
//  ::dm:set( 'stavterm->czkrterm'  , c_termin->czkrterm)
//  ::dm:set( 'stavterm->nportermin', c_termin->nportermin)
//  ::dm:set( 'stavterm->csnterm'   , c_termin->csnterm)

/*

  do case
  case cfile = 'msmzdyhdw'

*    keyMatr := msMzdyhdW->( Ads_getLastAutoinc()) +1
    keyMatr := msMzdyhdW->( Ads_GetRecordCount()) +1

    ::dm:set( 'msMzdyhdw->laktivni', .t.)
    ::dm:set( 'msMzdyhdw->nkeyMatr', keyMatr)

    msMzdyitW->( dbsetScope( SCOPE_BOTH, strZero( keyMatr,4)), dbgoTop())
    ::oBRO_msMzdyitw:oxbp:refreshAll()

  case cfile = 'msmzdyitw'
    ::dm:set( 'msMzdyitw->laktivni', .t.)

  endcase
*/

return .t.


method VYR_vyrpol_def_IN:deleteTSK
  local ok := .f.

*   ok := if( At('DIST', ::defOpr) > 0, .t., (forms->ctypforms = 'USER') )

   if ok
*     if forms->( dbRlock())
*       if drgIsYESNO(drgNLS:msg('Opravdu požadujete zrušit vybranou sestavu ?'))
*         forms->( dbDelete())
*         ::dctrl:oBrowse[1]:refresh(.T.)
*         ::verifyActions()
*         ::dctrl:oBrowse[2]:refresh(.T.)
*         ::dctrl:oBrowse[3]:refresh(.T.)
*       endif
*       forms->( dbUnlock())
*     endif
   else
     drgNLS:msg('Nemáte oprávnìní rušit !!!')
   endif

return


method VYR_vyrpol_def_IN:ebro_saveEditRow(o_eBro)
  local aUsers
  local n

//  if( o_eBro:isAppend, stavterm->( mh_append()), stavterm->(dbRlock()))
  ::dm:save()
  if o_eBro:isAppend
    vp_set->ctask      := ::dm:get('vp_set->ctask')
    vp_set->cuser      := ::dm:get('vp_set->cuser')
*    stavterm->czkrterm   := ::dm:get('stavterm->czkrterm')
*    stavterm->nportermin := ::dm:get('stavterm->nportermin')
*    stavterm->csnterm    := ::dm:get('stavterm->csnterm')
*    stavterm->nc_termin  := c_termin->sid
  endif

  if vp_set->laktivni .and. ::aktSID > 0
    if ::aktSID <> vp_set->sid
      if vp_seta->( dbSeek( ::aktSID,,'ID'))
        if vp_seta->(rLock())
          vp_seta->laktivni := .f.
          vp_seta->(dbUnlock())
        endif
      endif
    endif
  endif


//  if(Empty(userseuc->cTypForms), userseuc->cTypForms := Left(userseuc->cIdTask,4), NIL)
//  userseuc->nCisForms := Val(SubStr(userseuc->cIdTask,5))
  mh_WRTzmena( 'vp_set', o_eBro:isAppend)
  vp_set->(dbUnlock())
//  o_eBro:refreshAll()

RETURN .T.

/*
FUNCTION newIDtask(typ)
  local newID
  local filtr

  drgDBMS:open('USERSEUC',,,,,'USERSEUCa')
  filtr := Format("cIDtask = '%%'", {typ})
  USERSEUCa->( AdsSetOrder(1), ads_setaof(filtr), DBGoBotTom())
  newID := typ + StrZero( Val( SubStr(USERSEUCa->cIDtask,5,6))+1, 6)
  USERSEUCa->(ads_clearaof(), dbCloseArea())

RETURN(newID)
*/