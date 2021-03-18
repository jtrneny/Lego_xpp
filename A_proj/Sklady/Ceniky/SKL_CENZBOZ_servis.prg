#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
****** CLASS for SKL_cenzboz_servis *******************************************
CLASS SKL_cenzboz_servis FROM drgUsrClass
EXPORTED:

  METHOD  drgDialogStart
  METHOD  preValidate
  METHOD  postValidate
//  method  fir_firmy_sp_sel
  method  aktdat_agrikol

  VAR     newRec, drgGet

  inline access assign method porvKat() var porvKat
    local cret := '          '

    cret := if( c_katzbo->(dbSeek( cenzboz->nzbozikat,,'C_KATZB1')), c_katzbo->crozporadi, '          ')
    return cret


  inline method init(parent)
    local  olastDrg

    ::drgUsrClass:init(parent)

    drgDBMS:open('c_katzbo')

/*
    if isObject(parent:parent)
      if isObject( parent:parent:oform )
        if parent:parent:oform:olastDrg:className() = 'drgGet'
          ::drgGet := parent:parent:oform:olastDrg
        endif
      endif
    endif

    ::newRec := .F.
*/

  return self

/*

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
*/


/*
  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case ( nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT ) .and. isObject(::drgGet)
      PostAppEvent(xbeP_Close, drgEVENT_SELECT,,::drgDialog:dialog)

    otherwise
      return .f.
    endcase
  return .t.
*/


HIDDEN:
  VAR     nFile, cFile, dm, msg
  var     cisFirmy
ENDCLASS


METHOD SKL_cenzboz_servis:drgDialogStart(drgDialog)

  if( isObject(::drgGet), drgDialog:odbrowse[1]:enabled_enter := .f., nil )

  ::dm        := ::drgDialog:dataManager           // dataMananager
  ::msg       := drgDialog:oMessageBar             // messageBar

//  ::cisFirmy  := ::dm:get('stroje->ncisfirmy' , .f.)
RETURN self


METHOD SKL_cenzboz_servis:preValidate(drgVar)
  local lOk := .T.


RETURN lOk


method SKL_cenzboz_servis:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

/*
  do case
  case(name = 'ucetprit->ctypuct')
    ok := ::selTypyUct()
  endcase
*/


return ok



method SKL_cenzboz_servis:aktdat_agrikol(drgDialog)

  drgDBMS:open('cenzboz' ,,,,,'cenzboza')
  drgDBMS:open('c_katzbo',,,,,'c_katzboa')

  cenzboza->(dbGoTop())

  do while .not. cenzboza->( Eof())
    if c_katzboa->(dbSeek( cenzboza->nzbozikat,,'C_KATZB1' ))
      if cenzboza->( dbRlock())
        if Empty(cenzboza->crozporadi)
          cenzboza->crozlatr := c_katzboa->crozporadi
        else
          cenzboza->crozlatr := cenzboza->crozporadi
        endif
      endif
    else
      if cenzboza->( dbRlock()) .and. .not. Empty( cenzboza->crozporadi)
        cenzboza->crozlatr := cenzboza->crozporadi
      endif
    endif

    cenzboza->(dbUnlock())
    cenzboza->(dbSkip())
  enddo

  cenzboza->(dbCloseArea())
  c_katzboa->(dbCloseArea())

return ok




/*
method SKL_cenzboz_servis:fir_firmy_sp_sel(drgDialog)
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
*/