#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"

*
****** CLASS for UCT_uctpredp_CRD **********************************************
CLASS UCT_uctpredp_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init
  METHOD  ItemMarked

  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave
  METHOD  preValidate
  METHOD  postValidate
  METHOD  postDelete
  METHOD  SelTypyUct
  METHOD  TypyUctovani
  method  ebro_saveEditRow

  VAR     newRec

  inline access assign method cnaz_uctMD() var cnaz_uctMD
    c_uctosn->( DbSeek(upper(ucetPrit->cucetMD),,'UCTOSN1'))
    return c_uctosn->cnaz_uct

  inline access assign method cnaz_uctDAL() var cnaz_uctDAL
    c_uctosn->( DbSeek(upper(ucetPrit->cucetDAL),,'UCTOSN1'))
    return c_uctosn->cnaz_uct


  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    local  cfile := lower(::drgDialog:dialogCtrl:oaBrowse:cfile)
    LOCAL  appFocus, oA

    DO CASE
    CASE nEvent = drgEVENT_APPEND
      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        ::msg:writeMessage('Pøidávat lze jen u položek úèetního pøedpisu ...',DRG_MSG_WARNING)
//        drgMSGBox('Pøidávat lze jen u položek úèetního pøedpisu ...')
        RETURN .T.
      else
        RETURN .F.
      endif

    case nEvent = drgEVENT_APPEND2
      if cfile = 'ucetprit' .and. (cfile)->npoluctpr <> 0
        ucetPritA->( dbseek( isNull( ucetPrit->sID,0),,'ID'))

        mh_copyFld( 'ucetPritA', 'ucetPrit', .t.)
        ucetprit->npoluctpr := ucetprit->(mh_countRec()) +1

        ucetPrit->( dbcommit(), dbunlock())
        ::oabro[2]:oxbp:goBottom():refreshAll()
      endif

    CASE nEvent = drgEVENT_DELETE
      do case
      case ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        ::msg:writeMessage('Rušit lze jen položky úèetního pøedpisu ...',DRG_MSG_WARNING)
        drgMSGBox('Rušit lze jen položky úèetního pøedpisu ...')
        RETURN .T.
      case ::drgDialog:dialogCtrl:oaBrowse:cfile == 'UCETPRIT'
        ::postDelete()
        RETURN .T.
      otherwise
        RETURN .F.
      endcase

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

  inline method comboBoxInit(drgComboBox)
    local  cname      := lower(drgParseSecond(drgComboBox:name,'>'))
    local  ctask
    local  acombo_val := {}

    do case
    case ( cname = 'sel_ctask' )
      aadd( acombo_val, {  ''                                                      , ;
                           '         _ komletní seznam pøedpisù'                     } )

      c_task->(dbgotop(), ;
               dbeval({|| aadd(acombo_val,{c_task->culoha,c_task->ctask +' _ ' +c_task->cnazulohy}) }, ;
                      {|| c_task->luctuj }))

      drgComboBox:oXbp:clear()
      drgComboBox:values := ASort( aCOMBO_val,,, {|aX,aY| aX[2] < aY[2] } )
      aeval(drgComboBox:values, { |a| drgComboBox:oXbp:addItem( a[2] ) } )

      * musíme nastavit startovací hodnotu *
      drgComboBox:value := drgComboBox:ovar:value := ::sel_ctask
    endcase
  return self

  inline method comboItemSelected(drgComboBox)
    local  cname := lower(drgParseSecond(drgComboBox:name,'>'))
    local  cfilr

    if cname = 'sel_ctask'
      if drgComboBox:value <> ::sel_ctask
        ::sel_ctask := drgComboBox:value

        cFiltr := Format("UPPER(ctask) = '%%'", { UPPER(::sel_ctask)})
        ucetPrhd->( ADS_SetAOF(cFiltr), dbgoTop() )

        ::oabro[1]:oxbp:forceStable()
        ::oabro[1]:oxbp:refreshAll()
        ::dm:refresh()

        PostAppEvent(xbeBRW_ItemMarked,,,::oabro[1]:oxbp)
        SetAppFocus(::oabro[1]:oXbp)
      endif
    endif
  return .t.

  inline method drgDialogEnd(drgDialog)
    ::msg   := ;
    ::dm    := ;
    ::oabro := NIL

    if( .not. empty(ucetPrhd->( ads_getAof())), ucetPrhd->(ads_clearaof()), nil )
  return self

HIDDEN:
  VAR  nFile, cFile, msg, dm, oabro
  var  sel_ctask

ENDCLASS


METHOD UCT_uctpredp_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  ::newRec    := .F.
  ::sel_ctask := ''

  drgDBMS:open( 'c_task'  )   // comboBox - sel_ctask

  drgDBMS:open( 'UCETPRHD')   // bro_1
  drgDBMS:open( 'UCETPRIT')   // bro_2
  drgDBMS:open( 'UCETPRSY')   // mle_1 - mle_2

  drgDBMS:open( 'C_UCTOSN')
  drgDBMS:open( 'C_TYPDOK')
  drgDBMS:open( 'C_TYPPOH')
  drgDBMS:open( 'TYPDOKL' )

  drgDBMS:open( 'UCETPRIT',,,,,'UCETPRITa')
RETURN self


METHOD UCT_uctpredp_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD UCT_uctpredp_CRD:drgDialogStart(drgDialog)

  ::msg    := drgDialog:oMessageBar             // messageBar
  ::dm     := ::drgDialog:dataManager           // dataMananager
  ::oabro  := drgDialog:dialogCtrl:obrowse
RETURN self


METHOD UCT_uctpredp_CRD:ItemMarked(a,b,c,newflt)
  local  dc := ::drgDialog:dialogCtrl, cky

  default newflt to .F.

  if isobject(dc:oaBrowse)
    if lower(dc:oaBrowse:cFile) = 'ucetprhd' .or. newflt
      cky := upper(ucetprhd->culoha) +upper(ucetprhd->ctypDoklad) +upper(ucetprhd->ctypPohybu)

      ucetprit->(dbsetScope(SCOPE_BOTH,cky), dbgoTop())
    endif
  endif

  ::drgDialog:dataManager:refresh(.T.)
  ::drgDialog:dialogCtrl:oBrowse[2]:refresh(.T.)

  cFiltr := Format("Lower(cTYPUCT) = '%%'", {Lower(UCETPRIT->cTypUCT)})
  UCETPRSY->(ads_setaof( cFiltr), dbGoTop())
RETURN SELF


method uct_uctpredp_crd:ebro_saveEditRow()

  ucetprit->ctask      := ucetprhd->ctask
  ucetprit->culoha     := ucetprhd->culoha
  ucetprit->ctypDoklad := ucetprhd->ctypDoklad
  ucetprit->ctypPohybu := ucetprhd->ctypPohybu

/*
  UCETPRIT->cULOHA     := C_TYPPOH->cULOHA
  UCETPRIT->cTASK      := C_TYPPOH->cTASK
  UCETPRIT->cTYPDOKLAD := C_TYPPOH->cTYPDOKLAD
  UCETPRIT->cTYPPOHYBU := C_TYPPOH->cTYPPOHYBU

  if .not. UCETPRHD->( dbSeek(Upper(C_TYPPOH->cULOHA)+Upper(C_TYPPOH->cTYPDOKLAD)+Upper(C_TYPPOH->cTYPPOHYBU),, AdsCtag(1) ))
    mh_CopyFLD('C_TYPPOH','UCETPRHD',.t., .f.)
    UCETPRHD->cNazUcPred := C_TYPPOH->cNazTypPoh
  endif
*/
return .t.


METHOD UCT_uctpredp_CRD:preValidate(drgVar)
  local lOk := .T.

  if lower(drgVar:name) = 'ucetprit->npoluctpr' .and. ::dm:get("ucetprit->npoluctpr") == 0
    ::dm:set('ucetprit->npoluctpr', ucetprit->(mh_countRec()) +1)
  endif
RETURN lOk


method uct_uctpredp_crd:postValidate(drgVar)
  local  value := drgVar:get()
  local  name  := lower(drgVar:name)
  local  file  := drgParse(name,'-'), item := drgParseSecond(name,'>')
  local  ok    := .t., changed := drgVar:changed()

  do case
  case(name = 'ucetprit->ctypuct')
    ok := ::selTypyUct()
  endcase
return ok


METHOD UCT_uctpredp_CRD:onSave()
RETURN .T.


method UCT_uctpredp_CRD:postDelete()
  local  nsel, nodel := .f.

  if .not. Empty( ucetprit->npoluctpr)
    nsel := ConfirmBox( ,'Požadujete zrušit položku úèetního pøedpisu', ;
                         'Zrušení øádku úèetního pøedpisu ...' , ;
                          XBPMB_YESNO                            , ;
                          XBPMB_QUESTION+XBPMB_APPMODAL+XBPMB_MOVEABLE )

    if nsel = XBPMB_RET_YES
      if( ucetprit->( dbRlock()), (ucetprit->( dbDelete()), ucetprit->( dbUnlock())),nil)
    endif
  else
    nodel := .t.
  endif

  if nodel
    ConfirmBox( ,'položku úèetního pøedpisu nelze zrušit ...', ;
                 'Zrušení položky úèetního pøedpisu ...' , ;
                 XBPMB_CANCEL                    , ;
                 XBPMB_CRITICAL+XBPMB_APPMODAL+XBPMB_MOVEABLE )
  endif
  ::drgDialog:dialogCtrl:refreshPostDel()
return .not. nodel


method uct_uctpredp_crd:selTypyUct(drgDialog)
  local  oDialog, nExit
  *
  local  drgVar := ::dm:has('ucetprit->ctypuct')
  local  value  := drgVar:value
  local  ok

  ucetprsy->(ads_clearAof(), dbgoTop())

  ok := ucetprsy->(dbseek(upper(value),,'UCETPRSY01'))

  if isObject(drgDialog) .or. .not. ok
    DRGDIALOG FORM 'UCT_typyuct_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  endif

  if nExit != drgEVENT_QUIT .or. ok
    ::dm:set("ucetprit->ctypuct",    ucetprsy->ctypuct)
    ::dm:set("ucetprit->cnazucpred", ucetprsy->cnaztypuct)
    ::dm:set("ucetprit->cmainfile",  ucetprsy->cmainfile)
  endif
return ok


METHOD UCT_uctpredp_CRD:TypyUctovani()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'UCT_typyuct_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self


*
********* CLASS for UCT_typyuct_CRD ********************************************
CLASS UCT_typyuct_CRD FROM drgUsrClass
EXPORTED:
  METHOD  Init
  METHOD  ItemMarked
  METHOD  ItemSelected
  METHOD  postValidate
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave

  VAR     newRec

HIDDEN:
  VAR  dm
ENDCLASS


METHOD UCT_typyuct_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  ::newRec    := .F.

  drgDBMS:open('UCETPRSY')
  UCETPRSY->(ads_clearaof())
RETURN self


METHOD UCT_typyuct_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.


METHOD UCT_typyuct_CRD:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  ::dm  := drgDialog:dataManager             // dataMabanager
RETURN self


METHOD UCT_typyuct_CRD:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu
RETURN SELF


METHOD UCT_typyuct_CRD:ItemSelected()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

*  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu
RETURN SELF


METHOD UCT_typyuct_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval

*  if(lOK, ::msg:writeMessage(), NIL)
*  if( changed, ::dm:refresh(.T.), NIL )
  if( changed, ::onSave(), NIL )
RETURN lOk


METHOD UCT_typyuct_CRD:onSave()
  LOCAL n

  IF( .not. ::newRec, UCETPRSY->(dbRlock()), NIL)
  ::dm:save()
  UCETPRSY->(dbUnlock())
RETURN .T.


*
********* CLASS for UCT_typyuct_SEL ********************************************
CLASS UCT_typyuct_SEL FROM drgUsrClass
EXPORTED:
  METHOD  drgDialogStart

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      xx := ucetprsy->ctypUct

      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

ENDCLASS


**
METHOD UCT_typyuct_SEL:drgDialogStart(drgDialog)

  if( .not. Empty(UCETPRIT->cTypUct), UCETPRSY->(dbSeek(Upper(UCETPRIT->cTypUct))),NIL)
RETURN self