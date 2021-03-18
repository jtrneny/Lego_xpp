#include "appevent.ch"
#include "class.ch"
#include "Common.ch"
#include "drg.ch"
#include "Xbp.ch"
*
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"


*
** CLASS for FIN_c_bankuc ******************************************************
CLASS NAK_servisCtrlPrep_IN FROM drgUsrClass, drgServiceThread
EXPORTED:
  method  init, drgDialogInit, drgDialogStart, postLastField
  method  postValidate
  method  start
  method  ctrlPlnObjVys

  var  obdobi, fileexp
  var  ctrlPlnObjVys

HIDDEN:
  var    msg, dm, dc, df
  *
ENDCLASS


method NAK_servisCtrlPrep_IN:init(parent)
  local   nEvent := NIL, mp1 := NIL, mp2 := NIL, oXbp := NIL
 ::drgUsrClass:init(parent)


  ::ctrlPlnObjVys    := .f.

return self


method NAK_servisCtrlPrep_IN:drgDialogInit(drgDialog)

return self


method NAK_servisCtrlPrep_IN:drgDialogStart(drgDialog)

  ::msg     := drgDialog:oMessageBar             // messageBar
  ::dm      := drgDialog:dataManager             // dataMabanager
  ::dc      := drgDialog:dialogCtrl              // dataCtrl
  ::df      := drgDialog:oForm                   // form

return


method NAK_servisCtrlPrep_IN:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  ::dataManager:save()
  ::dataManager:refresh()

return .t.


method NAK_servisCtrlPrep_IN:postLastField(drgVar)
return .t.


method NAK_servisCtrlPrep_IN:start(drgVar)
  local  lok, cx

  if( ::ctrlPlnObjVys,  ::ctrlPlnObjVys(), nil)

  if( lok, drgMsgBox( "Pøepoèty byly dokonèeny"), nil)

return .t.

method NAK_servisCtrlPrep_IN:ctrlPlnObjVys(drgVar)
  local  lok, cx
  local  recFlt
  local  cFiltr
  local  rok

  drgDBMS:open('OBJVYSHD',,,,,'objvyshdc')
  drgDBMS:open('OBJVYSIT',,,,,'objvysitc')
  drgDBMS:open('PVPITEM',,,,,'pvpitemc')

  drgServiceThread:new()

  cFiltr := Format("nMnozPlDod < nMnozObDod", {})
  objvyshdc->( ads_setAof( cFiltr), dbgoTop())
  recFlt := objvyshdc->( Ads_GetRecordCount())

  drgServiceThread:progressStart(drgNLS:msg('Kontrolní pøepoèet plnìní objednávek vystavených ... ', 'MZDDAVITD'), recFlt )

  do while .not. objvyshdc->(Eof())
    if objvyshdc->( dbRlock())
      objvyshdc->nMnozPlDod := 0

      cFiltr := Format("nDOKLAD = %%", {objvyshdc->ndoklad})
      objvysitc->( ads_setAof( cFiltr), dbgoTop())

      do while .not. objvysitc->(Eof())
        if objvysitc->nMnozPlDod < objvysitc->nMnozObDod
          if objvysitc->( dbRlock())
            objvysitc->nMnozPlDod := 0

            cFiltr := Format("cCisObj = '%%' .and. nIntCount = %%", {objvysitc->cCisObj,objvysitc->nIntCount})
            pvpitemc->( ads_setAof( cFiltr), dbgoTop())
            do while .not. pvpitemc->(Eof())
              objvysitc->nMnozPlDod +=  pvpitemc->nmnozprdod
              pvpitemc->(dbSkip())
            enddo
            pvpitemc->(ads_ClearAof())
          endif
        endif
        objvysitc->( dbSkip())
      enddo

      objvysitc->( dbgoTop())
      do while .not. objvysitc->( Eof())
        objvyshdc->nMnozPlDod += objvysitc->nMnozPlDod
        objvysitc->( dbSkip())
      enddo

      objvysitc->( ads_ClearAof())
      objvysitc->( dbUnlock())
      objvyshdc->( dbUnlock())
    endif

    drgServiceThread:progressInc()
    objvyshdc->( dbSkip())
  enddo

  objvyshdc->(dbCloseArea())
  objvysitc->(dbCloseArea())
  pvpitemc->(dbCloseArea())

  drgServiceThread:progressEnd()

return .t.

