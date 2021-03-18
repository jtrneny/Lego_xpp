#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"

//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for FIN_upominhd_IN ***************************************************
CLASS FIN_upominhd_IN FROM drgUsrClass, FIN_finance_IN, SYS_ARES_forAll
EXPORTED:
  VAR     SYSTEM_nico
  VAR     SYSTEM_cdic
  VAR     SYSTEM_cpodnik
  VAR     SYSTEM_culice
  VAR     SYSTEM_cpsc
  VAR     SYSTEM_csidlo

  var     lnewrec, hd_file, it_file

  method  init, destroy, drgDialogStart, postValidate, postLastField, postSave
  method  FIN_upominhd_fir_sel, FIN_upominit_fv_sel

  inline method postDelete()
    FIN_upominhd_cmp()
    ::sumColumn(6)
    return .t.

  *
  inline method eventHandled(nevent,mp1,mp2,oxbp)
    local  inSav := 0   // 0-neumíme uložit 1-ukládáme položku 2-ukládáme doklad
    local  inBro := (lower(::df:oLastDrg:classname()) $ 'drgbrowse,drgdbrowse')

    do case
    case (nEvent = xbeBRW_ItemMarked)
      ::msg:WriteMessage(,0)
      ::state := 0

      if ::state <> 0
        (::cisFak:odrg:isEdit := .F., ::cisFak:odrg:oxbp:disable())
      endif

      ::dm:refresh()
      return .f.

    case nEvent = drgEVENT_SAVE .or. nevent = drgEVENT_EXIT
      ::restColor()

      if isObject(::brow)
        if     inBro                                 ; inSav := if(isMethod(self,'postSave'),2,0)
        elseif ::hd_file $ lower(::df:oLastDrg:name) ; inSav := if(isMethod(self,'postSave'),2,0)
        else                                         ; inSav := if(isMethod(self,'postLastField'),1,0)
        endif
      else
        inSav := if( isMethod(self,'postSave'),2,0)
      endif

      do case
      case (inSav = 0)
        drgMsg(drgNLS:msg('Doklad je ve stavu rozpracován -nebude uložen- omlouvám se ...'),,::dm:drgDialog)
        return .t.

      case (inSav = 1)
        ::postLastField()

      otherwise
        if ::postSave()
          if( .not. ::new_dok,PostAppEvent(xbeP_Close, nEvent,,oXbp),nil)
          return .t.
        endif
      endcase

    otherwise
      return ::handleEvent(nEvent, mp1, mp2, oXbp)
    endcase
  return .f.

 HIDDEN:
  var     cisFak
  VAR     nState                       // 0 - inBrowse  1 - inEdit  2 - inAppend

  * suma
  inline method sumColumn(column)
    local  recNo  := (::it_file)->(recNo())
    local  sumUpo := 0
    local  sumCol := ::brow:getColumn(column)

    upominitw->(dbgotop(),dbeval({ || sumUpo += upominitw->ncenupocel }))

    sumCol:Footing:hide()
    sumCol:Footing:setCell(1,str(sumUpo))
    sumCol:Footing:show()

    upominitw->(dbGoTo(recNo))
  return sumUpo

ENDCLASS


METHOD FIN_upominhd_IN:init(parent)
  LOCAL  nKy  := 0
  *
  local  cdirW := drgINI:dir_USERfitm +userWorkDir() +'\'

  (::hd_file  := 'upominhdw',::it_file  := 'upominitw')
  ::lnewrec  := .not. (parent:cargo = drgEVENT_EDIT)

  ::drgUsrClass:init(parent)
  ::nState      :=  0

  // SYS
  drgDBMS:open('FIRMY')
  drgDBMS:open('FAKVYSHD')

  // PØEDASTAVENÍ Z KONFIGURACE //
  ::SYSTEM_nico    := SysConfig('SYSTEM:nICO')
  ::SYSTEM_cdic    := SysConfig('SYSTEM:cDIC')
  ::SYSTEM_cpodnik := SysConfig('SYSTEM:cPODNIK')
  ::SYSTEM_culice  := SysConfig('SYSTEM:cULICE')
  ::SYSTEM_cpsc    := SysConfig('SYSTEM:cPSC')
  ::SYSTEM_csidlo  := SysConfig('SYSTEM:cSIDLO')

  IF parent:cargo = drgEVENT_EDIT
    nKy := UPOMINHD ->nCISUPOMIN
    ::lNEWrec  := .F.
  ELSE
    ::nState   := 2
  ENDIF

  FIN_upominhd_cpy(self)

  // SEZNAM DLUŽNÍKÚ
  if( select('fakvyshds') <> 0, fakvyshds->(dbCloseArea()), nil)
  FErase(cdirW +'fakvyshds.adi')
  FErase(cdirW +'fakvyshds.adm')
  FErase(cdirW +'fakvyshds.adt')

  FAKVYSHD ->(Ads_SetAOF('((DATE() > dSPLATFAK) .and. (nCENZAKCEL - nUHRCELFAK) <> 0)'))

  DbSelectARea('FAKVYSHD')
  FAKVYSHD ->(AdsSetOrder(4))
  TOTAL ON nCISFIRMY FIELDS nCENZAKCEL, nUHRCELFAK TO (cdirW +'FAKVYSHDs')
  FAKVYSHD ->(Ads_ClearAOF())

  drgDBMS:open('fakvyshds', .T., .T., drgINI:dir_USERfitm , , , .t. )
RETURN self


METHOD FIN_upominhd_IN:destroy()
  ::drgUsrClass:destroy()

  upominhdw->(dbCloseArea())
  upominitw->(dbCloseArea())
RETURN


method fin_upominhd_in:drgDialogStart(drgDialog)

 ::fin_finance_in:init(drgDialog,'poh',::it_file +'->ncisFak',' položku upomínky',.t.)
 ::sumColumn(6)

 ::cisFak := ::dm:get(::it_file +'->ncisFak', .F.)

 * propojka pro ARES
 ::sys_ARES_forAll:init(drgDialog)
return self


method fin_upominhd_in:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  ok    := .t., changed := drgVAR:Changed()
  * F4
  local  nevent := mp1 := mp2 := nil

  do case
  case(name = ::hd_file +'->ncisfirmy')
    ok := if( changed .or. empty(value), ::fin_upominhd_fir_sel(), .t.)

  case(name = ::it_file +'->ncisfak'  )
    ok := if( changed .or. empty(value), ::fin_upominit_fv_sel(), .t.)
  endcase

  if('upominhdw' $ name .and. ok, drgVAR:save(),nil)

  if(name = ::it_file +'->ncenupocel')
    if(nevent = xbeP_Keyboard .and. mp1 = xbeK_RETURN)
       ::postLastField()
    endif
  endif

return ok


method FIN_upominhd_in:postLastField(drgVar)
  local  isChanged := ::dm:changed()

  * ukládáme na posledním PRVKU *
  if((::it_file)->(eof()),::state := 2,nil)

  if isChanged .and. if(::state = 2, addrec(::it_file), .T.)
    if ::state = 2
       mh_copyfld(::hd_file,::it_file,, .f., .f.)
       ::copyfldto_w('fakvyshd',::it_file)
    endif
    (::it_file)->(flock())
    ::dm:save()

    if ::state = 2
      (::it_file)->nintCount := ::ordItem() +1
      ::brow:gobottom()
      ::brow:refreshAll()
    else
      ::brow:refreshCurrent()
    endif
  endif

  FIN_upominhd_cmp()

  ::setfocus(::state)
  ::sumColumn(6)
  ::dm:refresh()
return .t.


method FIN_upominhd_in:postSave()
  local ok := FIN_upominhd_wrt(self)

  if(ok .and. ::new_dok)
    upominhdw->(dbclosearea())
    upominitw->(dbclosearea())

    FIN_upominhd_cpy(self)

    ::fin_finance_in:refresh('upominhdw',,::dm:vars)

    ::brow:refreshAll()
    ::dm:refresh()
    ::df:setnextfocus('upominhdw->ncisFirmy',,.t.)
  endif
return ok



*
** SELL METHOD *****************************************************************
method FIN_upominhd_in:fin_upominhd_fir_sel(drgDialog)
  local  odialog, nexit, cKy
  *
  local  drgVar := ::dm:has(::hd_file +'->ncisfirmy')
  local  value  := drgVar:value
  local  ok     := fakvyshds->(dbSeek(value,,'FODBHD3'))

  if IsObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'FIN_upominhd_fir_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if nexit = drgEVENT_SELECT .or. ok
    ok    := .t.
    value := if(isNull(nexit), value, fakvyshds->ncisFirmy)
    firmy->(dbSeek(value))

    mh_copyfld('firmy',::hd_file,, .f.)
    *
    drgvar:value = drgvar:initValue := drgvar:prevValue := firmy->ncisfirmy

    ::fin_finance_in:refresh(drgVar)
    ::drgDialog:dataManager:refresh()
    ::df:setNextFocus(::it_file +'->ncisFak',,.t.)
  endif
return ok


METHOD FIN_upominhd_IN:FIN_upominit_fv_SEL(drgDialog)
  LOCAL  oDialog, nExit
  //
  LOCAL  drgVar := ::dm:get('upominitw->ncisfak',.F.)
  LOCAL  value  := drgVar:get()
  LOCAL  lOk    := (.not. Empty(value) .and. FIN_upominit_fv_SEEK(value))
  LOCAL  x, pA

  IF IsObject(drgDialog) .or. .not. lOk
    DRGDIALOG FORM 'FIN_upominit_fv_SEL' PARENT ::drgDialog MODAL EXITSTATE nExit

    pA := IF(IsNUll(oDialog:cargo), NIL, AClone(oDialog:cargo))
    oDialog:destroy(.T.)
    oDialog := NIL
  ENDIF

  IF nExit != drgEVENT_QUIT .or. (lOk .and. drgVar:changed())
    IF IsArray(pA)                                                              //výbìr ve smyèce
      oBROw:arSELECT := {}
      FOR x := 1 TO LEN(pA) STEP 1
        FAKPRIHD ->(DbGoTo(pA[x]))
        FIN_upominhd_INS()
        AAdd(oBROw:arSELECT, UPOMINITw ->(RecNo()))
      NEXT
      PostAppEvent(xbeP_Keyboard, xbeK_ESC,,::dm:has('upominitw->ncisfak'):oDrg:oXbp)
      ::bro:oXbp:GoTop():refreshAll()

    ELSE                                                                        //edituje dál
      ::dm:set('upominitw->ncisfak'   ,FAKVYSHD ->nCISFAK   )
      ::dm:set('upominitw->cnazev'    ,FAKVYSHD ->cNAZEV    )
      ::dm:set('upominitw->dsplatfak' ,FAKVYSHD ->dSPLATFAK )
      ::dm:set('upominitw->dposuhrfak',FAKVYSHD ->dPOSUHRFAK)
      ::dm:set('upominitw->ncenzakcel',FAKVYSHD ->nCENZAKCEL)
      ::dm:set('upominitw->czkratmeny',FAKVYSHD ->cZKRATMENY)
      *
      ::dm:set('upominitw->ndnyprek'  ,FIN_upominhd_in_BC(8))
      ::dm:set('upominitw->ncenupocel',FIN_upominhd_in_BC(9))
      ::dm:set('upominitw->cdoplntxt' ,PadR( 'K Fak_È '  +AllTrim(Str(FAKVYSHD ->nCISFAK))    + ;
                                             ' na '      +AllTrim(Str(FAKVYSHD ->nCENZAKCEL)) + ;
                                             ' splatné ' +DTOC(FAKVYSHD ->dSPLATFAK), 50 )      )
    ENDIF
  ENDIF
RETURN (nExit != drgEVENT_QUIT)


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
STATIC FUNCTION FIN_upominit_fv_SEEK(value)
  LOCAL  lDONe
  LOCAL  filter := "((nCISFIRMY = %%) .and. (nCISFAK = %%) .and. " + ;
                     "(DATE() > dSPLATFAK) .and. (nCENZAKCEL - nUHRCELFAK) <> 0)"

  FAKVYSHD ->( Ads_SetAOF(Format(filter, {UPOMINHDw ->nCISFIRMY,value})), DbGoTop())

    lDONe := (FAKVYSHD ->nCISFAK = value)
  FAKVYSHD ->( Ads_ClearAOF())
RETURN lDONe