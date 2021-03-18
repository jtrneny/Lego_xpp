#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"


*  Konfigurace - Naplánované úlohy
** CLASS for SY
*OSB_zdrstav_IN ******************************************************
CLASS OSB_zdrstav_IN FROM drgUsrClass
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
  VAR     msg, dm, dctrl, df, ab, pushOk, defOpr

*  METHOD  verifyActions
ENDCLASS


METHOD OSB_zdrstav_IN:init(parent)
  local  filter

//  ::defOpr   := defaultDisUsr('Forms','CTYPFORMS')

  ::drgUsrClass:init(parent)
  drgDBMS:open('c_zdrsta')
  drgDBMS:open('zdrstavy')
*  drgDBMS:open('FILTRS',,,,, 'FILTRSs')

  filter := format("NCISOSOBY = %%", {osoby->ncisosoby})
  zdrstavy->(ads_setAof(filter),dbgotop())

  * tady nevím jestli zap *
*  drgDBMS:open('FILTRITw',.T.,.T.,drgINI:dir_USERfitm);ZAP
RETURN self


method OSB_zdrstav_IN:drgDialogStart(drgDialog)
  ::msg := drgDialog:oMessageBar             // messageBar
  ::dm  := drgDialog:dataManager             // dataMabanager


*  ::odrgCombo_MBLOCKFRM  := ::dm:has( 'FORMS->MBLOCKFRM' )
*  ::odrgCombo_MBLOC_USER := ::dm:has( 'FORMS->MBLOC_USER')

// * nevím  if( ::newRec, ::postAppend(), ::dm:refresh())
return self


METHOD OSB_zdrstav_IN:itemMarked()
  local  filtr

*  filtr := Format("nC_Termin = %%", { c_termin->sid})
*  stavterm->( AdsSetOrder(1), ads_setaof(filtr), DBGoTop())

return self


* ok
method OSB_zdrstav_IN:postAppend()
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


method OSB_zdrstav_IN:CheckItemSelected(drgCheck)

return


method OSB_zdrstav_IN:itemSelected(new)
  local  mod
  *
  if ::selForm
    PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
  else
*    if(.not. empty(forms->cidForms), ::SYS_forms_modi_CRD(.F.), nil)
  endif
RETURN SELF


METHOD OSB_zdrstav_IN:preValidate(drgVar)
  local  lOk := .T., odesc
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')

  do case
  case lower(drgVar:name) = 'zdrstavy->nporzdrsta'
    if value = 0
      ::dm:set( 'zdrstavy->nporzdrsta', newIDpor())
    endif

  endcase

RETURN lOk


method OSB_zdrstav_IN:postValidate(drgVar)
  local  value := drgVar:get(), lOk := .T.


  do case
  case lower(drgVar:name) = 'zdrstavy->nporzdrsta'
    if value = 0
      drgNLS:msg('Poøadí nesmí být nulové !!!')
//    lOk := .f.
//   ::dm:set( name, 'DOH' )
//    stavterm->ctask := 'DOH'
    endif

  case lower(drgVar:name) = 'zdrstavy->czkrzdrsta'
    ::dm:set( 'zdrstavy->cnazzdrsta', c_zdrsta->cnazzdrsta)

  case lower(drgVar:name) = 'zdrstavy->ntypduchod'
    ::dm:set( 'zdrstavy->cnazduchod', c_duchod->cnazduchod)


  endcase

*  if lower(drgVar:name) = 'filtritw->cvyraz_2u'
*    if drgVar:changed()
*    endif

**    ::verifyActions(.T.)
*  endif
RETURN lOk


method OSB_zdrstav_IN:ebro_beforeAppend(o_ebro)
  local  nporadi := 1

//  zdrstavy->nporzdrsta := 1
  ::dm:set( "ZDRSTAVY->NPORZDRSTA", nporadi)


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


method OSB_zdrstav_IN:ebro_afterAppend(o_ebro)
  local  cfile   := lower( o_EBro:cfile)


  ::dm:set( 'zdrstavy->ncisosoby' , osoby->ncisosoby)
*  ::dm:set( 'zdrstavy->czkrterm'  , c_termin->czkrterm)

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


method OSB_zdrstav_IN:deleteTSK
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


method OSB_zdrstav_IN:ebro_saveEditRow(o_eBro)
  local aUsers
  local n

//  if( o_eBro:isAppend, stavterm->( mh_append()), stavterm->(dbRlock()))
  ::dm:save()
  if o_eBro:isAppend
*    zdrstavy->ctask      := ::dm:get('stavterm->ctask')
*    zdrstavy->czkrterm   := ::dm:get('stavterm->czkrterm')
*    zdrstavy->nc_termin  := c_termin->sid
  endif
*  stavterm->nc_prerus  := c_prerus->sid

//  if(Empty(userseuc->cTypForms), userseuc->cTypForms := Left(userseuc->cIdTask,4), NIL)
//  userseuc->nCisForms := Val(SubStr(userseuc->cIdTask,5))
  mh_WRTzmena( 'zdrstavy', o_eBro:isAppend)
  zdrstavy->(dbUnlock())

RETURN .T.

FUNCTION newIDpor()
  local newPor
  local filtr

  drgDBMS:open('zdrstavy',,,,,'zdrstavya')
  filtr := format("ncisosoby = %%", {osoby->ncisosoby})
  zdrstavya->( ads_setAof(filtr),dbgotop())
  zdrstavya->( AdsSetOrder('ZDRSTAVY04'), ads_setaof(filtr), DBGoBotTom())

  newPor := zdrstavya->nporzdrsta + 1
  zdrstavya->(ads_clearaof(), dbCloseArea())

RETURN(newPor)
