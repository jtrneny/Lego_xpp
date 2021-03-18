#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
****** CLASS for PRO_stroje_IN **********************************************
CLASS FIR_odbzboz_IN FROM drgUsrClass
EXPORTED:

//  METHOD  init
  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
//  method  fir_firmy_sp_sel
  method  skl_cenzboz_sel
  method  destroy
  method  ebro_beforeAppend, ebro_afterAppend, ebro_saveEditRow

  VAR     newRec, drgGet

  inline method init(parent)
    local  olastDrg

    ::drgUsrClass:init(parent)

    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

    drgDBMS:open('cenzboz' )

    ::newRec := .F.

  return self

  inline method drgDialogInit(drgDialog)
    local  aPos, aSize
    local  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

    if IsObject(::drgGet)
      **  XbpDialog:titleBar := .F.
      drgDialog:dialog:drawingArea:bitmap  := 1020
      drgDialog:dialog:drawingArea:options := XBP_IMAGE_SCALED

      if ::drgGet:oxbp:parent:className() = 'XbpCellGroup'
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp:parent,drgDialog:dataAreaSize)
        aPos[1] := 50
        return self
//        ( apos[1] := 50, apos[2] += 24 )
      else
        aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
      endif
      drgDialog:usrPos := {aPos[1],aPos[2]}
    endif
  return self


  inline method eventHandled(nEvent, mp1, mp2, oXbp)

    do case
    case ( nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT ) .and. isObject(::drgGet)
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR     nFile, cFile, dm, msg
//  var     cisFirmy
//  var     cisSklad, sklPol, katZbo
  var     sklPol

ENDCLASS


/*
method FIR_odbzboz_IN:init(parent)
  local  pa_initParam
  local  filter := "", cfilter

  ::drgUsrClass:init(parent)

//  drgDBMS:open('procenit',,,,,'procenit_w')

  drgDBMS:open('cenzboz' )

RETURN self
*/

method FIR_odbzboz_IN:drgDialogStart(drgDialog)

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm        := ::drgDialog:dataManager           // dataMananager
  ::msg       := drgDialog:oMessageBar             // messageBar

//  ::cisFirmy  := ::dm:get('odbzboz->ncisfirmy' , .f.)
//  ::cisSklad  := ::dm:get('odbzboz->ccisSklad' , .f.)
  ::sklPol    := ::dm:get('odbzboz->csklpol'   , .f.)

  ::dm:set('odbzboz->cnazFirmy',  firmy->cnazev)

  filter := format( "nFIRMY = %%",{ isNull( firmy->sID, 0)})
  odbzboz ->(ads_setaof(filter),dbgotop())


RETURN self


METHOD FIR_odbzboz_IN:preValidate(drgVar)
  local lOk := .T.

//  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
//    ::dm:set('ucetprit->npoluctpr', ucetprit->(sx_keyCount()) +1)
//  endif
RETURN lOk


method FIR_odbzboz_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case(name = 'odbzboz->csklpol')
    if value = ''
      drgMsgBox(drgNLS:msg('Skladová položka musí být uvedena !!!'), XBPMB_INFORMATION)
      ok := .f.
    endif
  endcase

return ok

* ok
method FIR_odbzboz_IN:ebro_beforeAppend(o_ebro)
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


method FIR_odbzboz_IN:ebro_afterAppend(o_ebro)

  ::dm:set('odbzboz->ncisFirmy',  firmy->ncisfirmy)
//  ::cisFirmy:set(firmy->ncisfirmy)
  ::dm:set('odbzboz->cnazFirmy',  firmy->cnazev)

return .t.



method FIR_odbzboz_IN:ebro_saveEditRow(o_ebro)
  local  cky_org, cky_new, nstate := 0, ok := .f.

   odbzboz->ncisFirmy  := ::dm:get( 'odbzboz->ncisFirmy')
   odbzboz->cnazFirmy  := ::dm:get( 'odbzboz->cnazFirmy')
   odbzboz->ccisSklad  := ::dm:get( 'odbzboz->ccissklad')
   odbzboz->cnazzbo    := ::dm:get( 'odbzboz->cnazzbo')
   odbzboz->ckatczbo   := ::dm:get( 'odbzboz->ckatczbo')
   odbzboz->czkratJedn := ::dm:get( 'odbzboz->czkratJedn')
   odbzboz->nfirmy     := isNull( firmy->sid, 0)
   odbzboz->ncenzboz   := isNull( cenzboz->sid, 0)

return


/*
method FIR_odbzboz_IN:fir_firmy_sp_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
//  ok := firmy->(dbseek( ::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    oDialog := drgDialog():new('FIR_FIRMY_sp_SEL', ::dm:drgDialog)
    oDialog:cargo_usr := ::cisFirmy:value
    oDialog:create(,,.T.)

    nExit := oDialog:exitState
    oDialog:destroy(.T.)
    oDialog := NIL
  endif

  copy := if((ok .and. drgVar:changed()) .or. (nexit != drgEVENT_QUIT),.t.,.f.)

  if copy
    ::dm:set('odbzboz->cnazFirmy',  firmy->cnazev)
    ::dm:set('odbzboz->ccissklad',  cenzboz->ccissklad)
    ::dm:set('odbzboz->csklpol',    cenzboz->csklpol)
    ::dm:set('odbzboz->cnazzbo',    cenzboz->cnazzbo)
    ::dm:set('odbzboz->czkratjedn', cenzboz->czkratjedn)
    ::dm:set('odbzboz->dDatumOD',   Date())
    ::dm:set('odbzboz->ncenzboz',   cenzboz->sid)
    ::dm:set('odbzboz->ncisFirmy',  firmy->ncisFirmy)

//    ::cisFirmy:set(firmy->ncisfirmy)
  endif
return (nexit != drgEVENT_QUIT) .or. ok

*/


method FIR_odbzboz_IN:skl_cenzboz_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.

  ok := cenzboz->(dbseek(upper(::sklPol:value),,'CENIK01'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'SKL_CENZBOZ_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::sklPol:changed()) .or. (nexit != drgEVENT_QUIT))
    ::sklPol:set(cenzboz->csklpol)
    ::dm:set('odbzboz->ccissklad',cenzboz->ccissklad)
    ::dm:set('odbzboz->ckatczbo', cenzboz->ckatczbo)
    ::dm:set('odbzboz->cnazZbo',cenzboz->cnazzbo)
    ::dm:set('odbzboz->czkratJedn',cenzboz->czkratJedn)
  endif

return (nexit != drgEVENT_QUIT) .or. ok



method FIR_odbzboz_IN:destroy()

  odbzboz->( Ads_ClearAof())

return SELF