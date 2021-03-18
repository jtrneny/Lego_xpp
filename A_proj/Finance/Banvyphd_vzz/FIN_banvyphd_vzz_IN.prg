#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"

//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for FIN_banvyphd_vzz_IN ***********************************************
CLASS FIN_banvyphd_vzz_IN FROM drgUsrClass, FIN_finance_IN
EXPORTED:
  VAR     lNEWrec, rozPo

  METHOD  init
  METHOD  drgDialogStart

**  METHOD  comboBoxInit
**  METHOD  comboItemSelected
**  METHOD  comboItemMarked
**  METHOD  preValidate
  METHOD  postValidate

  METHOD  FIN_FIRMY_ICO_SEL
  METHOD  FIN_banvyphd_KR
**  METHOD  FIN_CMDPH
**  METHOD  FIN_VYKDPH_I
**  METHOD  FIN_PARPRZAL

 HIDDEN:
  METHOD  showGroup
**  METHOD  refresh
  //
**  METHOD  vlde, vldc, vldz

**  VAR     aEdits
**  VAR     panGroup
**  VAR     members
ENDCLASS


METHOD FIN_banvyphd_vzz_IN:init(parent)
  LOCAL  nKy := 0

  ::drgUsrClass:init(parent)

  ::rozPo     := 0
  ::lNEWrec   := .T.

  // SYS
  drgDBMS:open('C_BANKUC')
  drgDBMS:open('KURZIT'  )  // *
  drgDBMS:open('FAKPRIHD')  // *
  drgDBMS:open('FAKVYSHD')  // *
  drgDBMS:open('UCETPOL' )  // *
  drgDBMS:open('RANGE_HD')
  drgDBMS:open('RANGE_IT')

  IF parent:cargo = drgEVENT_EDIT
    nKy := BANVYPHD ->nDOKLAD
    ::lNEWrec  := .F.
  ENDIF

  // TMP SOUBORY //
  drgDBMS:open('BANVYPHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('BANVYPITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  FIN_banvyp_cpy(self,'vzz')
RETURN self


METHOD FIN_banvyphd_vzz_IN:drgDialogStart(drgDialog)
 LOCAL x, members  := drgDialog:oForm:aMembers

  BEGIN SEQUENCE
    FOR x := 1 TO LEN(members)
      IF members[x]:ClassName() = 'drgBrowse'
  BREAK
      ENDIF
    NEXT
  ENDSEQUENCE

  IF( .not. ::lNEWrec, drgDialog:oForm:nextFocus := x, NIL )
  ::showGroup()
RETURN self


METHOD FIN_banvyphd_vzz_IN:postValidate(drgVar)
  LOCAL  drgDC20  := ::drgDialog:dialogCtrl
  LOCAL  xVAL     := drgVar:get()
  LOCAL  cNAMe    := UPPER(drgVar:name)
  LOCAL  cFILe    := drgParse(cNAMe,'-')
// for ALL
  LOCAL  lOK      := .T., lCHANGED := drgVAR:changed()

  IF lCHANGED
    DO CASE
    CASE( 'CBANK_UCT'    $ cNAMe )
      IF .not. C_BANKUC ->( DbSeek(xVAL,,'BANKUC1'))
        lOk := ::FIN_C_BANKUC_SEL()
      ENDIF
    ENDCASE
  ENDIF

RETURN lOk


**
** SELL METHOD *****************************************************************
METHOD FIN_banvyphd_vzz_IN:FIN_FIRMY_ICO_SEL()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_FIRMY_ICO_SEL' PARENT ::drgDialog MODAL DESTROY ;
                                     EXITSTATE nExit

  IF nExit != drgEVENT_QUIT
    BANVYPHDw ->nICO := FIRMY ->nICO
    ::drgDialog:dataManager:refresh()
  ENDIF
RETURN (nExit != drgEVENT_QUIT)


METHOD FIN_banvyphd_vzz_IN:FIN_banvyphd_KR()
  LOCAL oDialog, nExit

  DRGDIALOG FORM 'FIN_BANVYPHD_KR' PARENT ::drgDialog MODAL DESTROY ;
                                   EXITSTATE nExit

  IF nExit != drgEVENT_QUIT
*    BANVYPHDw ->cBANK_UCT := C_BANKUC ->cBANK_UCT
*    ::drgDialog:dataManager:refresh()
  ENDIF
RETURN (nExit != drgEVENT_QUIT)


**
** HIDDEN METHOD - FUNCTION - PROCEDURE ****************************************
METHOD FIN_banvyphd_vzz_IN:showGroup()
  LOCAL  nIn
  LOCAL  lOk
  LOCAL  pA  := {'banvyphdw->nprijem' , 'banvyphdw->nvydej' , 'banvypitw->ncenzakcel', ;
                 'banvyphdw->nprijemz', 'banvyphdw->nvydejz', 'banvypitw->ncenzahcel'  }
  LOCAL  drgVar, dm := ::dataManager

  FOR nIn := 1 TO LEN(pA)
    drgVar := dm:has(pA[nIn]):oDrg

    lOk    := IF(C_BANKUC ->lIsTUZ_UC, IF( nIn <= 3, .T., .F.), IF(nIn > 3, .T., .F.))

    IF( drgVar:className() = 'drgGet', drgVar:isEdit := lOk, NIL )
    IF( lOk, drgVar:oXbp:show(), drgVar:oXbp:hide() )
  NEXT
RETURN self