#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
****** CLASS for PRO_stroje_IN **********************************************
CLASS PRO_stroje_IN FROM drgUsrClass
EXPORTED:

  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
  method  fir_firmy_sp_sel

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


METHOD pro_stroje_in:drgDialogStart(drgDialog)

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm        := ::drgDialog:dataManager           // dataMananager
  ::msg       := drgDialog:oMessageBar             // messageBar

  ::cisFirmy  := ::dm:get('stroje->ncisfirmy' , .f.)
RETURN self


METHOD pro_stroje_in:preValidate(drgVar)
  local lOk := .T.

  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
    ::dm:set('ucetprit->npoluctpr', ucetprit->(sx_keyCount()) +1)
  endif
RETURN lOk


method pro_stroje_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case(name = 'ucetprit->ctypuct')
    ok := ::selTypyUct()
  endcase
return ok


method pro_stroje_in:fir_firmy_sp_sel(drgDialog)
  local  oDialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

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
    ::cisFirmy:set(firmy->ncisfirmy)
  endif
return (nexit != drgEVENT_QUIT) .or. ok

