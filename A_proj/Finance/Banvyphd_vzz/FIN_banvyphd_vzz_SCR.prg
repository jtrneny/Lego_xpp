#include "Common.ch"
#include "drg.ch"
#include "appevent.ch"
//
#include "DRGres.Ch'
#include "XBP.Ch"
//
#include "..\FINANCE\FIN_finance.ch"


FUNCTION FIN_banvyphd_vzz_TUZ()
  STATIC  cZAKLmena

  cZAKLmena := IsNull(cZAKLmena, SysConfig('Finance:cZaklMena'))
RETURN Equal(cZAKLmena, BANVYPHDw ->cZKRATMENY)


*
** CLASS for FIN_banvyphd_vzz_SCR **************************************************
CLASS FIN_banvyphd_vzz_SCR FROM drgUsrClass, fin_finance_in
EXPORTED:
  METHOD  init, drgDialogStart, itemMarked, tabSelect, drgDialogEnd

HIDDEN:
  VAR  tabnum, brow
ENDCLASS


METHOD FIN_banvyphd_vzz_SCR:init(parent)
  local filter := FORMAT("(cDENIK = '%%')", {SYSCONFIG('FINANCE:cDENIKVZZA')})

  ::drgUsrClass:init(parent)
  ::tabnum := 1

  // PRO INFO //
  drgDBMS:open('DPH_2004')
  drgDBMS:open('DPHDATA' )
  drgDBMS:open('UCETSYS' )
  drgDBMS:open('UZAVISOZ')

  drgDBMS:open('BANVYPHD')
  drgDBMS:open('BANVYPIT')
  drgDBMS:open('C_BANKUC')

  BANVYPHD ->( Ads_setAOF(filter))
RETURN self


METHOD FIN_banvyphd_vzz_SCR:drgDialogStart(drgDialog)
  ::brow := drgDialog:dialogCtrl:oBrowse
  BANVYPHD->( DBGoBottom())
RETURN


METHOD FIN_banvyphd_vzz_SCR:tabSelect(oTabPage,tabnum)
  ::tabnum := tabnum
  ::itemMarked()
RETURN .T.


METHOD FIN_banvyphd_vzz_SCR:itemMarked()
  LOCAL  cky

  do case
  case ::tabnum = 1
    cky := StrZero(BANVYPHD ->nDOKLAD,10)
    BANVYPIT ->( dbSetScope(SCOPE_BOTH, cky), DbGoTop())
    ::brow[2]:refresh(.T.)
  case ::tabnum = 2
    cky := Upper(BANVYPHD ->cDENIK) +StrZero(BANVYPHD ->nDOKLAD,10)
    UCETPOL ->(DbSetScope(SCOPE_BOTH,cky), DbGoTop())
    ::brow[3]:refresh(.T.)
  endcase
RETURN SELF


METHOD FIN_banvyphd_vzz_SCR:drgDialogEnd()

  BANVYPHD ->( Ads_ClearAOF())
  BANVYPIT ->( DbClearScope())
RETURN


**
** CLASS for FIN_firmy_ico_SEL *************************************************
CLASS FIN_firmy_ico_SEL FROM drgUsrClass

EXPORTED:
  METHOD  init
  METHOD  getForm
  METHOD  drgDialogInit

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
  VAR  drgGet
ENDCLASS


METHOD FIN_firmy_ico_SEL:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_firmy_ico_SEL:getForm()
LOCAL oDrg, drgFC

  drgFC := drgFormContainer():new()
  DRGFORM INTO drgFC SIZE 90,10 DTYPE '10' TITLE 'Výbìr dle ICO obchodního partnera ...' ;
                                           FILE 'FIRMY'                                  ;
                                           GUILOOK 'All:N,Border:Y'

  DRGBROWSE INTO drgFC SIZE 90,9.8 ;
                       FIELDS 'nICO:ièo,'           + ;
                              'cDIC:diè,'           + ;
                              'cNAZEV:název firmy,' + ;
                              'cULICE:ulice,'       + ;
                              'cPSC:psè,'             ;
                       SCROLL 'ny' CURSORMODE 3 PP 7

RETURN drgFC

METHOD FIN_firmy_ico_SEL:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN