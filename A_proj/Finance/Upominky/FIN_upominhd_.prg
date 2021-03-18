#include "Common.ch"
#include "Xbp.ch"
#include "appevent.ch"
#include "drg.ch"
//
// #include "Asystem++.ch"
#include "..\Asystem++\Asystem++.ch"
*  #include "..\FINANCE\FIN_finance.ch"


function FIN_upominhd_cpy(oDialog)
  local  lnewRec := if( IsNull(oDialog), .F., oDialog:lNEWrec)
  local  nCENZAKCEL := 0
  LOCAL  cKy

  ** tmp soubory
  drgDBMS:open('UPOMINHDw',.T.,.T.,drgINI:dir_USERfitm); ZAP
  drgDBMS:open('UPOMINITw',.T.,.T.,drgINI:dir_USERfitm); ZAP

  IF .not. lnewRec
    mh_COPYFLD('UPOMINHD', 'UPOMINHDw', .t., .t.)

    upominit->( dbgoTop())

    DO WHILE !UPOMINIT ->(Eof())
      mh_COPYFLD('UPOMINIT', 'UPOMINITw', .t., .t.)
      UPOMINITw ->nDOKLADORG := UPOMINIT ->( RecNo())

      UPOMINIT ->(DbSkip())
    ENDDO
  ELSE
    FORDREC( {'UPOMINHD,1'} )
    UPOMINHD ->( DbGoBottom())

    UPOMINHDw ->(DbAppend())
    UPOMINHDw ->cULOHA     := 'F'
    UPOMINHDw ->nCISUPOMIN := UPOMINHD ->nCISUPOMIN +1
    UPOMINHDw ->dUPOMINKY  := Date()
    FORDREC()
  ENDIF
RETURN(Nil)


*
** pøevzetí vybraných položek do upomínky v cyklu ******************************
FUNCTION FIN_upominhd_ins()
  LOCAL  cKy := Upper( FAKPRIHD ->cDENIK) +StrZero( FAKPRIHD ->nCISFAK,10)


  mh_COPYFLD('FAKVYSHD', 'UPOMINITw', .t., .t.)

  UPOMINITw ->nDNYPREK   := FIN_upominhd_in_BC(8)
  UPOMINITw ->nCENUPOCEL := FIN_upominhd_in_BC(9)
  UPOMINITw ->cDOPLNTXT  := PadR( 'K Fak_È '  +AllTrim(Str(FAKVYSHD ->nCISFAK))    + ;
                                  ' na '      +AllTrim(Str(FAKVYSHD ->nCENZAKCEL)) + ;
                                  ' splatné ' +DTOC(FAKVYSHD ->dSPLATFAK),        50 )
RETURN(Nil)


*
** uložení upomínky **
FUNCTION FIN_upominhd_wrt(oDialog)
  local  anUpi   := {}, lUpi := .t.
  local  anFak   := {}, lFak := .t., mainOk := .t., nrecor

  upominitw->(AdsSetOrder(0), dbgotop())
  do while .not. upominitw->(eof())
    if(upominitw->_nrecor <> 0, aadd(anUpi,upominitw->_nrecor), nil)
    *
    fakvyshd->(dbSeek(upominitw->ncisFak,,'FODBHD1'))
    upominitw->nfakVysOrg := fakvyshd->(recNo())
    AAdd(anFak, fakvyshd->(recNo()))
    *
    upominitw->(dbSkip())
  enddo

  if .not. odialog:lnewRec
    upominhd->(dbgoto(upominhdw->_nrecor))
    mainOk := upominhd->(sx_rlock())                    .and. ;
              upominit->(sx_rlock(anUpi))               .and. ;
              fakvyshd->(sx_rlock(anFak))
  else
    mainOk := fakvyshd->(sx_rlock(anFak))
  endif

  if mainOk
    mh_copyfld('upominhdw','upominhd',odialog:lnewRec, .f.)
    upominitw->(dbgotop())
    do while .not. upominitw->(eof())

      if((nrecor := upominitw->_nrecor) = 0, nil, upominit->(dbgoto(nrecor)))
      fakvyshd->(dbGoTo(upominitw->nfakVysOrg))

      if   upominitw->_delrec = '9'
        if nrecor <> 0
          upominit->(dbdelete())
          fakvyshd->ncisUpomin := max(0,fakvyshd->ncisUpomin -1)
          fakvyshd->dupominky  := if(fakvyshd->ncisUpomin = 0, cToD('  .  .  '), upominhdw->dUpominky)
        endif
      else
        mh_copyfld('upominitw','upominit',(nrecor=0), .f.)
        fakvyshd->ncisUpomin  := fakvyshd->ncisUpomin +1
        fakvyshd->dUpominky   := upominhdw->dUpominky
        upominit->ncisUpomin  := upominhdw->ncisUpomin
        upominit->npocUpoFak  := fakvyshd->ncisUpomin
      endif

      upominitw->(dbskip())
    enddo

    if upominhdw->_delrec = '9'
      upominhd->(dbgoto(upominhdw->_nrecor),dbdelete())
    endif
  else

    drgMsg(drgNLS:msg('Nelze modifikovat UPOMÍNKY, blokováno uživatelem ...'),,::drgDialog)
  endif

  upominhd->(dbunlock(), dbcommit())
   upominit->(dbunlock(), dbcommit())
    fakvyshd->(dbunlock(), dbcommit())
RETURN mainOk

*
** pøepoèet hlavièky
function FIN_upominhd_cmp()
  local  recNo     := upominitw->(recNo())
  local  cenZakCel := 0

  upominitw->(dbGotop()                                        , ;
              dbEval( {|| cenZakCel += upominitw->ncenUpoCel } , ;
                      {|| upominitW->_delrec <> '9'          }), ;
              dbGoto(recNo)                                      )

  upominhdw->ncenZakCel := cenZakCel
return .t.

*
** zrušení upomínky
function FIN_upominhd_del(odialog)
  local  mainOk

  upominhdw->_delrec := '9'
  upominitw->(AdsSetOrder(0),dbgotop(),dbeval({|| upominitw->_delrec := '9'}))
  mainOk := FIN_upominhd_wrt(odialog)
return mainOk


**
** CLASS for FIN_upominit_fir_SEL **********************************************
**
** nabídka seznamu firem/ dlužníkù pro upomínky ********************************
FUNCTION FIN_upominhd_in_BC(nCOLUMn)
  LOCAL  xRETval

  DO CASE
  CASE( nCOLUMn = 5)
    xRETval := (FAKVYSHDs ->nCENZAKCEL -FAKVYSHDs ->nUHRCELFAK)

  ** pohledávky **
  CASE( nCOLUMn = 1)
    xRETval := IF(Empty(FAKVYSHD ->dUPOMINKY), 0, MIS_ICON_ERR)
  CASE( nCOLUMN = 8)
    xRETval :=  (Date() -FAKVYSHD ->dSPLATFAK)
  CASE( nCOLUMn = 9)
    xRETval := (FAKVYSHD  ->nCENZAKCEL -FAKVYSHD  ->nUHRCELFAK)
  ENDCASE
RETURN xRETval


CLASS FIN_upominhd_fir_SEL FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit

  inline method eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    do case
    case nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close,drgEVENT_SELECT,,::drgDialog:dialog)
      return .t.

    case nEvent = drgEVENT_APPEND
    case nEvent = drgEVENT_FORMDRAWN
      return .T.

    case nEvent = xbeP_Keyboard
      do case
      case mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      otherwise
        return .f.
      endcase

    otherwise
      return .f.
    endcase
  return .t.

HIDDEN:
  VAR  drgGet
ENDCLASS


METHOD FIN_upominhd_fir_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  drgDBMS:open('fakvyshds',.t.,.t.,drgINI:dir_USERfitm)
  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_upominhd_fir_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 85,11 DTYPE '10' TITLE 'Výbìr obchodního partnera pro upomínku...' ;
                                           GUILOOK 'All:N,Border:Y'

  DRGDBROWSE INTO drgFC FPOS 0,0 SIZE 85,10.6 FILE 'FAKVYSHDs'  ;
    FIELDS 'nCISFIRMY:firma,'                                + ;
           'cNAZEV:název firmy,'                             + ;
           'cPSC:psè,'                                       + ;
           'cULICE:ulice:29,'                                + ;
           'FIN_upominhd_in_BC(5):k úhradì:13:9999999999.99,'  ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'
RETURN drgFC


METHOD FIN_upominhd_fir_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

**  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF
RETURN


**
** CLASS for FIN_upominit_fv_SEL ***********************************************
**
** nabídka seznamu pohledávek pro umonínky *************************************
CLASS FIN_upominit_fv_SEL FROM drgUsrClass
EXPORTED:
  method  init, getForm, drgDialogInit
  method  doPrevzit

  **
  ** EVENT *********************************************************************
  INLINE METHOD eventHandled(nEvent, mp1, mp2, oXbp)
    LOCAL dc := ::drgDialog:dialogCtrl

    DO CASE
    CASE nEvent = drgEVENT_EXIT  .or. nEvent = drgEVENT_EDIT
      PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)

    CASE nEvent = drgEVENT_APPEND
    CASE nEvent = drgEVENT_FORMDRAWN
      Return .T.

    CASE nEvent = xbeP_Keyboard
      DO CASE
      CASE mp1 = xbeK_ESC
        PostAppEvent(xbeP_Close,,,::drgDialog:dialog)
      OTHERWISE
        RETURN .F.
      ENDCASE

    OTHERWISE
      RETURN .F.
    ENDCASE
  RETURN .T.

HIDDEN:
  VAR  drgGet, setVyber, drgBrowse
ENDCLASS


METHOD FIN_upominit_fv_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::setVyber := 0
  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_upominit_fv_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 97,12.6 DTYPE '10' TITLE 'Seznam pohledávek po splatnosti ...' ;
                                              GUILOOK 'All:N,Border:Y,ACTION:Y'

  DRGDBROWSE INTO drgFC FPOS 0,1.1 SIZE 97,11.4 FILE 'FAKVYSHD'  ;
    FIELDS 'FIN_upominhd_in_BC(1):U:2.6::2,'                   + ;
           'nCISFAK:èísloFaktury:10,'                          + ;
           'cVARSYM:varSymbol,'                                + ;
           'dSPLATFAK:datSplatn,'                              + ;
           'nCENZAKCEL:celkemFak,'                             + ;
           'dPOSUHRFAK:datÚhrady,'                             + ;
           'nUHRCELFAK:uhrazeno,'                              + ;
           'FIN_upominhd_in_BC(8):poSpl:4:9999,'               + ;
           'FIN_upominhd_in_BC(9):k úhradì:13:9999999999.99'     ;
    SCROLL 'ny' CURSORMODE 3 PP 7 POPUPMENU 'y'


  DRGTEXT FAKVYSHD->nCISFIRMY INTO drgFC CPOS  1,0.1 CLEN 10 BGND 13 FONT 5 CTYPE 2
  DRGTEXT FAKVYSHD->cNAZEV    INTO drgFC CPOS 12,0.1 CLEN 25 BGND 13 FONT 5

  DRGACTION INTO drgFC CAPTION '~Pøevzít' EVENT 'doPrevzit' PRE '2' ;
            TIPTEXT 'Pøevzít vybrané položky do pøíkazu'
RETURN drgFC


METHOD FIN_upominit_fv_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog
  //
  LOCAL  filter := "((nCISFIRMY = %%) .and. (DATE() > dSPLATFAK) .and. (nCENZAKCEL - nUHRCELFAK) <> 0)"


**  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2] -24}
  ENDIF

  FAKVYSHD ->(Ads_SetAOF(Format(filter, {UPOMINHDw ->nCISFIRMY})))
RETURN


METHOD FIN_upominit_fv_SEL:doPrevzit()
  LOCAL  pA := ::drgDialog:dialogCtrl:oaBrowse:arSELECT

  IF( Empty(pA), AAdd(pA,FAKVYSHD ->(RecNo())), NIL )
  ::drgDialog:cargo := pA
  PostAppEvent(xbeP_Close, drgEVENT_EXIT,,::drgDialog:dialog)
RETURN self