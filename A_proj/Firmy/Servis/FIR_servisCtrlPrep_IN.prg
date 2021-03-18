#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"

#include "odbcdbe.ch"
//#include "dll.ch"
//#pragma library("odbcut10.lib")

STATIC aKeyWords

*
** CLASS for FIR_servisCtrlPrep_IN ******************************************************
CLASS FIR_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlFirmyFI,ctrlFirUHDA
  method  mleinit
  var  obdobi, fileexp
  var  ctrlFirmyFI,ctrlFirUHDA
  var  message
  var  omle

//  inline method mleinit(odrg)
//    ::omle := oDrg:oXbp
//    ::omle:setWrap(.t.)
//  return self


/*
  * bro col for c_bankuc
  inline access assign method isMain_uc() var isMain_uc
    return if( c_bankuc->lisMain, 300, 0)


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    do case
    case(nevent = xbeBRW_ItemMarked)
     ::dm:refresh()

    case(nevent = drgEVENT_FORMDRAWN)
      if ::lsearch
        postAppEvent(xbeP_Keyboard,xbeK_LEFT,,::brow:oxbp)
        return .t.
      else
        return .f.
      endif

    case nEvent = drgEVENT_EDIT
      if IsObject(::drgGet)
        PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
        ::drgDialog:cargo := &(oXbp:cargo:arDef[1,2])
        return .t.
      endif

    endcase
  return .f.
*/

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method FIR_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)


  ::ctrlFirmyFI   := .f.
  ::ctrlFirUHDA   := .f.

  ::message       := 'inicializace'

return self


method FIR_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method FIR_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method FIR_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
//  ::dataManager:refresh()

return .t.


method FIR_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method FIR_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  lok := .t.

  if( ::ctrlFirmyFI,       ::ctrlFirmyFI(), nil)
  if( ::ctrlFirUHDA,       ::ctrlFirUHDA(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.


method FIR_servisCtrlPrep_IN:mleinit(odrg)

  ::omle := oDrg:oXbp

return self


// kontrola souboru FIRMYFI na duplicitu, existenci záznamu, atd.
method FIR_servisCtrlPrep_IN:ctrlFirmyFi(drgVar)
  local  lok, cx, xx
  local  recFlt
  local  cFiltr
  local  nky


  /////   kontrola FIRMYFI
  drgDBMS:open('firmy',,,,,'firmy_1')
  drgDBMS:open('firmyfi',,,,,'firmyfi_1')


  drgServiceThread:new()
//  cFiltr := Format("nROK = %% and cdenik = '%%'", { rok,"MN"})
//  mzddavitd->( ads_setAof( cFiltr), dbgoTop())
//  recFlt := mzddavitd->( Ads_GetRecordCount())

  recFlt := firmy_1->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrola tabulky FirmyFI - duplicita, existence záznamu ... ', 'firmy_1'), recFlt )

  firmy_1->( dbGoTop())
  do while .not. firmy_1->(eof())
    nky := firmy_1->ncisfirmy

    firmyfi_1->(AdsSetOrder('FIRMYFI1'), dbsetScope(SCOPE_BOTH, nKy), DbGoTop() )
    xx := 0
    firmyfi_1->( DbEval( {|| xx++ }))
//    xx := firmyfi_1->( Ads_GetRecordCount())

    do case
    case xx = 0
      ::message += 'záznam s firmou è.' + Str(firmy_1->ncisfirmy, 5,0) + ' neexistuje - záznam byl založen' + CRLF
      mh_CopyFld( 'firmy_1', 'firmyfi_1', .t.)

    case xx > 1
      ::message += 'existují duplicitní záznamy s firmou è.' + Str(firmy_1->ncisfirmy, 5,0) + ' je potøeba zkontrolovat' + CRLF
      firmyfi_1->( dbGoTop())
      firmyfi_1->( DbEval( {||( Rlock(),nUverDnyOd := xx, dbUnlock()) }))
    endcase

    firmyfi_1->(dbClearScope(SCOPE_BOTH))

    drgServiceThread:progressInc()
    firmy_1->(dbSkip())
  enddo

//  MemoEdit(message,,,,,,,,,,,30,60)
//  drgMsgBox( MemoEdit(message), XBPMB_INFORMATION)
//  drgMsgBox(drgNLS:msg(message), XBPMB_INFORMATION)

//  mzddavitd->( ads_ClearAof())

  drgServiceThread:progressEnd()

  recFlt := firmyfi_1->( Ads_GetRecordCount())
  drgServiceThread:progressStart(drgNLS:msg('Kontrola tabulky FirmyFI - na tabulku FIRMY ... ', 'firmyfi_1'), recFlt )

  firmyfi_1->( dbGoTop())
  do while .not. firmyfi_1->(eof())

    if .not. firmy_1->(dbSeek( firmyfi_1->ncisfirmy,,'FIRMY01'))
      ::message += 'záznam s firmou è.' + Str(firmyfi_1->ncisfirmy, 5,0) + ' ve FIRMY neexistuje - záznam bude zrušen' + CRLF
      if firmyfi_1->( rlock())
        firmyfi_1->( dbDelete())
        firmyfi_1->( dbUnlock())
      endif
    endif

    drgServiceThread:progressInc()
    firmyfi_1->(dbSkip())
  enddo

//  mzddavitd->( ads_ClearAof())

  drgServiceThread:progressEnd()
  ::dataManager:save()
//  ::dataManager:refresh()
//  ::oMLE:reconfigure()

return .t.


// doplní typ úhrady z dodací adresy-firmy do fakturaèní    !!!  original !!!
method FIR_servisCtrlPrep_IN:ctrlFirUHDA(drgVar)
  local  lok, cx, xx
  local  recFlt
  local  cFiltr
  local  rok


  /////   úprava typu úhrady
  drgDBMS:open('firmyfi',,,,,'firmyfi_1')
  drgDBMS:open('firmyfi',,,,,'firmyfi_2')
  drgDBMS:open('firmyva',,,,,'firmyva_1')


  drgServiceThread:new()
//  cFiltr := Format("nROK = %% and cdenik = '%%'", { rok,"MN"})
//  mzddavitd->( ads_setAof( cFiltr), dbgoTop())
//  recFlt := mzddavitd->( Ads_GetRecordCount())

  recFlt := firmyfi_1->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Doplnìní úhrad k fakturaèní firmì z dodací firmy ... ', 'firmyfi_1'), recFlt )

  firmyfi_1->( dbGoTop())
  do while .not. firmyfi_1->(eof())
    if firmyfi_1->cZkrTypUOd = ''
      xx := StrZero(firmyfi_1->ncisfirmy,5)+Upper( 'FAA')
      if firmyva_1->(dbSeek( xx,,'FIRMYVA02'))
        if firmyfi_2->(dbSeek(firmyva_1->ncisfirva,,'FIRMYFI1'))
          if firmyfi_1->(dbRlock())
            firmyfi_1->cZkrTypUOd = firmyfi_2->cZkrTypUOd
            firmyfi_1->(dbUnlock())
          endif
        endif
      endif
    endif
    drgServiceThread:progressInc()
    firmyfi_1->(dbSkip())
  enddo

//  mzddavitd->( ads_ClearAof())

  drgServiceThread:progressEnd()

return .t.

