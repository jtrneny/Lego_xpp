#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

#include "..\Asystem++\Asystem++.ch"

*
****** CLASS for PRO_stroje_IN **********************************************
CLASS SKL_odbzboz_IN FROM drgUsrClass
EXPORTED:

  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
  method  fir_firmy_sp_sel
  method  eBro_saveEditRow
  method  destroy

  VAR     newRec, drgGet

  inline method init(parent)
    local  olastDrg

    ::drgUsrClass:init(parent)

    drgDBMS:open('firmy')

    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

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
  var     cisFirmy
ENDCLASS


METHOD SKL_odbzboz_IN:drgDialogStart(drgDialog)

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm        := ::drgDialog:dataManager           // dataMananager
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::cisFirmy  := ::dm:get('odbzboz->ncisfirmy' , .f.)

  filter := format( "nCENZBOZ = %%",{ isNull( cenzboz->sID, 0)})
  odbzboz ->(ads_setaof(filter),dbgotop())


RETURN self


METHOD SKL_odbzboz_IN:preValidate(drgVar)
  local lOk := .T.

//  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
//    ::dm:set('ucetprit->npoluctpr', ucetprit->(sx_keyCount()) +1)
//  endif
RETURN lOk


method SKL_odbzboz_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case(name = 'odbzboz->ncisfirmy')
    if value = 0
      drgMsgBox(drgNLS:msg('Firma musí být uvedena !!!'), XBPMB_INFORMATION)
      ok := .f.
    endif
  endcase

return ok


method SKL_odbzboz_IN:ebro_saveEditRow(o_ebro)
  local  cky_org, cky_new, nstate := 0, ok := .f.

  ::dm:save()

/*
  if odbzboz->( sx_RLock())

    vyrZakit->dOdvedZaka := vyrZakpl->dOdvedZaka
    vyrZakit->dMozOdvZak := vyrZakpl->dMozOdvZak
    vyrZakit->dSkuOdvZak := vyrZakpl->dSkuOdvZak
    vyrZakit->nRozmP_del := vyrZakpl->nRozmP_del
    vyrZakit->nRozmP_sir := vyrZakpl->nRozmP_sir
    vyrZakit->nRozmP_vys := vyrZakpl->nRozmP_vys
    vyrZakit->cRozmP_MJ  := vyrZakpl->cRozmP_MJ

    vyrZakit->(dbUnlock(), dbCommit())
  endif
*/

return


method SKL_odbzboz_IN:fir_firmy_sp_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := firmy->(dbseek( ::cisFirmy:value,,'FIRMY1'))

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


method SKL_odbzboz_IN:destroy()

  odbzboz->( Ads_ClearAof())


return SELF