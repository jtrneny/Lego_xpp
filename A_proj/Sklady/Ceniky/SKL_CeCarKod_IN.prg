#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

********************************************************************************
*
********************************************************************************
CLASS SKL_CeCarKod_IN FROM drgUsrClass
EXPORTED:
  METHOD  Init, drgDialogStart, EventHandled
  METHOD  postvalidate

  method  fir_firmy_sel
  method  ebro_afterAppend, ebro_afterAppendBlankRec, ebro_saveEditRow


  inline method ebro_beforSaveEditRow( drgEBrowse )
    local lok := .t.

    if .not. ::vld_carKod()
        fin_info_box('Promiòte prosím, ;Vámi zadaný èárový kód již existuje ...', XBPMB_CRITICAL)
        lok := .f.
     endif
  return lok


HIDDEN:
  VAR     o_EBro, dm
  var     cisFirmy


  inline method vld_carKod()
    local  cf := "ccissklad = '%%' and csklpol = '%%' and czkrCarKod = '%%' and ccarKod = '%%' and ncisFirmy = %%"
    local  zkrCarKod := ::dm:get( 'ceCarKod->czkrCarKod'), ;
           carKod    := ::dm:get( 'ceCarKod->ccarKod'   ), ;
           cisFirmy  := ::dm:get( 'ceCarKod->ncisFirmy' )
    local  filtr, ok := .t.

    filtr     := format( cf, { cenzboz->ccissklad, cenzboz->csklpol, zkrCarKod, carKod, cisFirmy })
    ceCarKod_v->( ads_setAof(filtr),dbgoTop())

    if ceCarKod_v->( ads_getKeyCount(1)) > if( ::o_Ebro:state = 2, 0, 1 )
      ok := .f.
    endif
  return ok

ENDCLASS

********************************************************************************
METHOD SKL_CeCarKod_IN:Init(parent)
  ::drgUsrClass:init(parent)

  drgDBMS:open('firmy'   )
  *
  * pro kontrolu
  drgDBMS:open('ceCarKod',,,,,'ceCarKod_v')
RETURN self

*******************************************************************************
METHOD SKL_CeCarKod_IN:drgDialogStart(drgDialog)

  ::o_Ebro   := drgDialog:dialogCtrl:oBrowse[1]
  ::dm       := drgDialog:dataManager

  ::cisFirmy := ::dm:get('ceCarKod->ncisfirmy' , .f.)
RETURN self


********************************************************************************
METHOD SKL_CeCarKod_IN:eventHandled(nEvent, mp1, mp2, oXbp)
  local cFile, aCenaMat := {}, lOk, cMsg

  DO CASE
  CASE nEvent = drgEVENT_APPEND
  CASE nEvent = drgEVENT_DELETE
    cMsg  := 'Zrušit èárový kód ?'

    if drgIsYESNO(drgNLS:msg( cMsg))
      if CeCarKod->( dbRlock())
        CeCarKod->( dbDelete(), dbUnlock())
      endif
      CeCarKod->(dbUnlock())
      ::o_Ebro:oXbp:refreshAll()
*      ::itemMarked()
    endif
     *  CASE nEvent = xbeP_Keyboard
  OTHERWISE
    RETURN .F.
  ENDCASE
 RETURN .T.



method skl_ceCarKod_in:fir_firmy_sel(drgDialog)
  local  odialog, nexit := drgEVENT_QUIT, ok, copy := .f.
  *
  local  cf := "ncisfirmy = %%"

  ok := firmy->(dbseek(::cisFirmy:value,,'FIRMY1'))

  if isobject(drgdialog) .or. .not. ok
    DRGDIALOG FORM 'FIR_FIRMY_SEL' PARENT ::dm:drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if((ok .and. ::cisFirmy:changed()) .or. (nexit != drgEVENT_QUIT))
    ::cisFirmy:set(firmy->ncisfirmy)
    ::dm:set('ceCarKod->cnazev', firmy->cnazev)
  endif
return (nexit != drgEVENT_QUIT) .or. ok



METHOD SKL_CeCarKod_IN:ebro_afterAppend( ebro)

  ::dm:set( 'cecarkod->ccissklad', cenzboz->ccissklad)
  ::dm:set( 'cecarkod->csklpol',   cenzboz->csklpol)
  ::dm:set( 'cecarkod->cnazzbo',   cenzboz->cnazzbo)

  if c_carKod->( mh_SEEK( .T., 3, .T.))
    ::dm:set( 'cecarKod->cZkrCarKod', c_carKod->czkrCarKod )
  endif
RETURN self


METHOD SKL_CeCarKod_IN:ebro_afterAppendBlankRec(eBro)

  cecarkod->ccissklad := cenzboz->ccissklad
  cecarkod->csklpol   := cenzboz->csklpol
  cecarkod->cnazzbo   := cenzboz->cnazzbo
return .t.

********************************************************************************
METHOD SKL_CeCarKod_IN:postValidate(drgVar)
  LOCAL  value := drgVar:get()
  LOCAL  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  lOK   := .T., changed := drgVAR:changed()
  *
  local  nevent := mp1 := mp2 := nil, isF4 := .F., nin, isReturn

  * F4
  nevent    := LastAppEvent(@mp1,@mp2)
  isReturn := (nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)

  if(IsNUMBER(mp1) .and. mp1 = xbeK_F4, changed := .t., nil)

  do case
  case ( name = 'cecarkod->ccarkod' )
    if empty(value)
      fin_info_box('Èárový kód povinný údaj ...', XBPMB_CRITICAL)
      lok := .f.
    endif

  case(name = 'cecarkod->ncisfirmy'  .and. isReturn .and. changed)
      ok := ::fir_firmy_sel()

  endcase
RETURN lOK


********************************************************************************
METHOD SKL_CeCarKod_IN:ebro_saveEditRow( o_eBro )
*  ::dm:save()

  ceCarKod->cnazev := ::dm:get( 'ceCarKod->cnazev' )
RETURN .T.