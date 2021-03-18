#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"


# DEFINE    COMPILE(c)         &("{||" + c + "}")
# TRANSLATE SET_filter(<c>) => ( ORDsetFOCUS(0), dbSETFILTER( COMPILE(<c>)), dbGOTOP() )


//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS MZD_uctpredp_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
//  METHOD  ItemSelected
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave
  METHOD  postValidate
  METHOD  SelTypyUct
  METHOD  TypyUctovani

  VAR     newRec

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL appFocus
    LOCAL oA

    DO CASE
    CASE nEvent = drgEVENT_APPEND
      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        drgMSGBox('Pøidávat lze jen u položek úèetního pøedpisu ...')
        RETURN .T.
      else
        ::newRec := .T.
        ::SelTypyUct()
        RETURN .F.
      endif

    CASE nEvent = drgEVENT_EDIT
      ::newRec := .F.
      RETURN .F.

    CASE nEvent = drgEVENT_DELETE
      if ::drgDialog:dialogCtrl:oaBrowse:cfile == 'C_TYPPOH'
        drgMSGBox('Rušit lze jen položky úèetního pøedpisu ...')
//        ::msg:writeMessage('Rušit lze jen položky úèetního pøedpisu ...',DRG_MSG_ERROR)
        RETURN .T.
      else
        ::drgDialog:dialogCtrl:oBrowse[2]:Refresh()
        RETURN .F.
      endif


*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
 *       RETURN .F.
 *     EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  VAR     nFile, cFile, dm

ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_uctpredp_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  ::newRec := .F.
  ::dm     := ::drgDialog:dataManager             // dataMabanager

  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('C_UCTOSN')
  drgDBMS:open('C_TYPDOK')
  drgDBMS:open('C_TYPPOH')
  drgDBMS:open('UCETPRHD')
  drgDBMS:open('UCETPRIT')
  drgDBMS:open('UCETPRSY')

RETURN self


METHOD MZD_uctpredp_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_uctpredp_CRD:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

RETURN self


METHOD MZD_uctpredp_CRD:ItemMarked(a,b,c,newflt)
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  default newflt to .F.

  if dc:oaBrowse:cFile == "C_TYPPOH" .or. newflt
    cFiltr := Format("Lower(cTYPDOKLAD) = '%%'.and.Lower(cTYPPOHYBU) = '%%'",;
                      {Lower(C_TYPPOH->cTypDoklad),Lower(C_TYPPOH->cTypPohybu)})
    UCETPRIT->( dbClearFilter(), dbSetFilter( COMPILE( cFiltr)), dbGoTop())
    dc:oBrowse[2]:Refresh()
  endif

*  if dc:oaBrowse:cFile == "UCETPRIT"
    cFiltr := Format("Lower(cTYPUCT) = '%%'", {Lower(UCETPRIT->cTypUCT)})
    UCETPRSY->( dbClearFilter(), dbSetFilter( COMPILE( cFiltr)), dbGoTop())
*  endif

  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

RETURN SELF


METHOD MZD_uctpredp_CRD:postValidate(drgVar)
  LOCAL  name := Lower(drgVar:name), value := drgVar:get(), changed := drgVAR:changed()
  LOCAL  file := drgParse(name,'-')
  LOCAL  filtr, n, cval, cnam
  LOCAL  valueTm
  *
  LOCAL  lOK  := .T., pa, xval
  LOCAL  lZmPoh := .F.

  do case
  case(name = 'ucetprit->ctypuct')
    if changed
      if Empty(value)
        ::msg:writeMessage('Typ pohybu je povinný údaj ...',DRG_MSG_ERROR)
        lOk := .F.
      endif
      lZmPoh := .T.
    endif
  endcase

*  if(lOK, ::msg:writeMessage(), NIL)
  if( changed .and. lOK, ( ::onSave(), ::dm:refresh(.T.)), NIL )

RETURN lOk




METHOD MZD_uctpredp_CRD:onSave()

  if ::newRec
    UCETPRIT->ctypdoklad := C_TYPPOH->ctypdoklad
    UCETPRIT->cnazucpred := C_TYPPOH->cnaztyppoh
    ::newRec := .F.
  else
    UCETPRIT->(dbRlock())
  endif
  ::dm:save()
  UCETPRIT->(dbUnlock())

RETURN .T.


METHOD MZD_uctpredp_CRD:SelTypyUct()
  LOCAL oDialog
  LOCAL dopln  := .F.
  LOCAL newpol := 0

  UCETPRSY->(dbClearFilter())

  if ::newRec
    UCETPRIT->(dbGoBotTom())
    newpol := UCETPRIT->nPolUctPr+1
    UCETPRIT->(dbClearFilter())
    UCETPRIT->(DbAppend())
    UCETPRIT->nPolUctPr := newpol
  endif

  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_typyuct_SEL' PARENT ::drgDialog MODAL DESTROY EXITSTATE nExit
  ::drgDialog:popArea()                  // Restore work area

  if nExit != drgEVENT_QUIT
    dopln := if( ::newRec, .T., UCETPRIT->cTYPUCT <> UCETPRSY->cTYPUCT)
    if dopln
      UCETPRIT->( DbRlock())
      UCETPRIT->cULOHA     := C_TYPPOH->cULOHA
      UCETPRIT->cTASK      := C_TYPPOH->cTASK
      UCETPRIT->cTYPDOKLAD := C_TYPPOH->cTYPDOKLAD
      UCETPRIT->cTYPPOHYBU := C_TYPPOH->cTYPPOHYBU
      UCETPRIT->cTYPUCT    := UCETPRSY->cTYPUCT
      UCETPRIT->cNazUcPred := UCETPRSY->cNazTypUct
    endif
  else
    if(::newRec, UCETPRIT->(DbDelete()), NIL)
  endif

  UCETPRIT->(DbUnLock())

  ::itemMarked(,,,.T.)
//  ::drgDialog:dialogCtrl:oBrowse[2]:Refresh()

RETURN self


METHOD MZD_uctpredp_CRD:TypyUctovani()
LOCAL oDialog
  ::drgDialog:pushArea()                  // Save work area
  DRGDIALOG FORM 'MZD_typyuct_CRD' PARENT ::drgDialog MODAL DESTROY
  ::drgDialog:popArea()                  // Restore work area
RETURN self



//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS MZD_typyuct_CRD FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

  METHOD  Init
  METHOD  ItemMarked
  METHOD  ItemSelected
  METHOD  postValidate
*  METHOD  postAppend
  METHOD  InFocus
  METHOD  drgDialogStart
  METHOD  onSave

  VAR     newRec

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_APPEND
      ::newRec := .T.
      UCETPRSY->(dbAppend())
      ::drgDialog:dialogCtrl:oBrowse[1]:Refresh()
      RETURN .F.
    CASE nEvent = drgEVENT_EDIT
      ::newRec := .F.

*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
*        RETURN .F.
*      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

HIDDEN:
  VAR  dm   //, msg


ENDCLASS

*********************************************************************
* Initialization part. Open all files
*********************************************************************
METHOD MZD_typyuct_CRD:Init(parent)
  ::drgUsrClass:init(parent)

  ::newRec := .F.

  drgDBMS:open('UCETPRSY')
  UCETPRSY->( dbClearFilter())

RETURN self


METHOD MZD_typyuct_CRD:InFocus(oB)
 ::drgDialog:DialogCtrl:oBrowse := oB:cargo
RETURN .T.

**
METHOD MZD_typyuct_CRD:drgDialogStart(drgDialog)
  LOCAL nROK, nOBDOBI
  LOCAL cFiltr

  ::dm  := drgDialog:dataManager             // dataMabanager

RETURN self



METHOD MZD_typyuct_CRD:ItemMarked()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

RETURN SELF



METHOD MZD_typyuct_CRD:ItemSelected()
  Local  n, nTabPage := 0
  Local  dc      := ::drgDialog:dialogCtrl
  Local  aValues := ::drgDialog:dataManager:vars:values, drgVar
  Local  cKy_BP
  Local  cFT_BP

*  ::drgDialog:dataManager:Refresh()    // refrešne INFO-kartu

RETURN SELF



METHOD MZD_typyuct_CRD:postValidate(drgVar)
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


METHOD MZD_typyuct_CRD:onSave()
  LOCAL n

  IF( .not. ::newRec, UCETPRSY->(dbRlock()), NIL)
  ::dm:save()
  UCETPRSY->(dbUnlock())

RETURN .T.



//-----+ FI_fakprihd_SCR0 +-------------------------------------------------------
CLASS MZD_typyuct_SEL FROM drgUsrClass
EXPORTED:
//  VAR     KUHRADE_vzm    // k úhradì v základní mìnì

*  METHOD  Init
*  METHOD  ItemMarked
*  METHOD  ItemSelected
*  METHOD  postValidate
*  METHOD  postAppend
*  METHOD  InFocus
  METHOD  drgDialogStart
*  METHOD  onSave

*  VAR     newRec

  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    DO CASE
    CASE nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

*    CASE nEvent = xbeP_Keyboard
*      Do Case
*      Case mp1 = xbeK_INS   ;   ::CardOfKmenMzd(.T.)
*      Case mp1 = xbeK_ENTER ;   ::CardOfKmenMzd(.F.)
*      Case mp1 = xbeK_ESC   ;   PostAppEvent(xbeP_Close,nEvent,,oXbp)
*      Otherwise
*        RETURN .F.
*      EndCase
    OTHERWISE
      RETURN .F.
    ENDCASE
 RETURN .T.

ENDCLASS


**
METHOD MZD_typyuct_SEL:drgDialogStart(drgDialog)

  if( .not. Empty(UCETPRIT->cTypUct), UCETPRSY->(dbSeek(Upper(UCETPRIT->cTypUct))),NIL)

RETURN self
