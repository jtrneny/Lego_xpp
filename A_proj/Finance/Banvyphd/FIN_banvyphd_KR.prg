#include "common.ch"
#include "drg.ch"
#include "appevent.ch"
#include "gra.ch"
#include "CLASS.CH"
#include "xbp.ch"

//
#include "..\FINANCE\FIN_finance.ch"

**
** CLASS for FIN_banvyphd_KR ***************************************************
CLASS FIN_banvyphd_KR FROM drgUsrClass
EXPORTED:
  METHOD init
  METHOD  drgDialogInit

HIDDEN:
  VAR  drgGet
ENDCLASS


METHOD FIN_banvyphd_KR:init(parent)
  Local nEvent,mp1,mp2,oXbp

  nEvent := LastAppEvent(@mp1,@mp2,@oXbp)
  IF IsOBJECT(oXbp:cargo)
    ::drgGet := oXbp:cargo
  ENDIF

  ::drgUsrClass:init(parent)
RETURN self


METHOD FIN_banvyphd_KR:drgDialogInit(drgDialog)
  LOCAL  aPos, aSize
  LOCAL  XbpDialog := drgDialog:dialogCtrl:drgDialog:dialog

  XbpDialog:titleBar := .F.

  IF IsObject(::drgGet)
    aPos := mh_GetAbsPosDlg(::drgGet:oXbp,drgDialog:dataAreaSize)
    drgDialog:usrPos := {aPos[1],aPos[2]}
  ENDIF
RETURN


/*
TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava kurzovního rozdílu ...) SIZE(100,9.5) FILE (BANVYPITw)   ;
                                                                                   POST(postValidate) ;
                                                                                   GUILOOK(All:n,Action:n,IconBar:n)


  TYPE(Text)                                            CAPTION(kurz      /      mnPøep) CPOS( 60,-.1) CLEN(18) FONT(5)
  TYPE(Text)                                            CAPTION(èástka v)                CPOS( 83,-.1) CLEN(10) FONT(5)

  TYPE(STATIC) FPOS(0.4,0.4) SIZE(99.2,9) STYPE(13) CTYPE(2)
* 1
    TYPE(Get)  NAME(nCENZAKCEL)   FPOS(15, .5)   FLEN(15) FCAPTION(Èástka/Typ ...)       CPOS( 1, .5)
    TYPE(Text) NAME(cZKRATMENY)                                                          CPOS(32.5, .5) CLEN( 8) BGND(13)
    TYPE(Text) NAME(cTYPOBRATU)                                                          CPOS(42, .5) CLEN( 4) BGND(13)
    TYPE(Get)  NAME(nKURZMENB)    FPOS(48, .5)   FLEN(15) FCAPTION(/)                    CPOS(66, .5) CLEN( 2)
    TYPE(Get)  NAME(nMNOZPREB)    FPOS(70, .5)   FLEN(10)
    TYPE(Text) NAME(nCENZAKCEL)                                                          CPOS(83, .5) CLEN(15) BGND(13) CTYPE(2)
* 2
    TYPE(Get)  NAME(nUHRBANFAK)   FPOS(15,1.5)   FLEN(15) FCAPTION(Úhrada fakury ...)    CPOS( 1,1.5)
    TYPE(Get)  NAME(cZKRATMENU)   FPOS(32.5,1.5) FLEN( 7) PUSH()
    TYPE(Get)  NAME(nKURZMENU)    FPOS(48,1.5)   FLEN(15) FCAPTION(/)                    CPOS(66,1.5) CLEN( 2)
    TYPE(Get)  NAME(nMNOZPREU)    FPOS(70,1.5)   FLEN(10)
    TYPE(Text) NAME(nLIKPOLBAV)                                                          CPOS(83,1.5) CLEN(15) BGND(13) CTYPE(2)
* 3
    TYPE(Get)  NAME(cZKRATMENK)   FPOS(32.5,2.5) FLEN( 7) FCAPTION(pøepoèet na)          CPOS(15,2.5) PUSH()
    TYPE(Get)  NAME(nKURZMENK)    FPOS(48,2.5)   FLEN(15)
* 4
    TYPE(Get)  NAME(nUHRCELFAZ)   FPOS(15,3.5)   FLEN(15) FCAPTION(Pøepoèet faktury ...) CPOS( 1,3.5)
    TYPE(Text) NAME(cZKRATMENF)                                                          CPOS(32.5,3.5) CLEN( 8) BGND(13)
    TYPE(Text) NAME(nKURZMENF)                                                           CPOS(48,3.5) CLEN(16) BGND(13) CTYPE(2)
    TYPE(Text) NAME(nMNOZPREF)                                                           CPOS(70,3.5) CLEN(11) BGND(13) CTYPE(2)
    TYPE(Text) NAME(nCENZAKCEF)                                                          CPOS(83,3.5) CLEN(15) BGND(13) CTYPE(2)
* 5

    TYPE(Text)                                          CAPTION(Kurzovní rozdíl)         CPOS(60,4.6) FONT(5)
    TYPE(STATIC) STYPE(2) SIZE(98.9,3.8) FPOS(.2,4.7) CTYPE(2)
      TYPE(Get)  NAME(cUCET_UCTK)   FPOS(15, .8)   FLEN( 8) FCAPTION(SuAu_S kurzRozd ...)       CPOS( 1, .8)
      TYPE(Get)  NAME(cTEXTK)       FPOS(62, .8)   FLEN(35) FCAPTION(Text kurzRozd ...)         CPOS(48, .8)

* NS
      TYPE(GET) NAME(cNAZPOL1K)     FPOS( 3,2.9) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,1.85) CLEN(10)
      TYPE(GET) NAME(cNAZPOL2K)     FPOS(19,2.9) FLEN(10) FCAPTION(Výrobek)      CPOS(19,1.85) CLEN( 8)
      TYPE(GET) NAME(cNAZPOL3K)     FPOS(35,2.9) FLEN(10) FCAPTION(Zakázka)      CPOS(35,1.85) CLEN( 8)
      TYPE(GET) NAME(cNAZPOL4K)     FPOS(51,2.9) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,1.85) CLEN( 8)
      TYPE(GET) NAME(cNAZPOL5K)     FPOS(67,2.9) FLEN(10) FCAPTION(Stroj)        CPOS(67,1.85) CLEN( 8)
      TYPE(GET) NAME(cNAZPOL6K)     FPOS(83,2.9) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,1.85) CLEN(10)

      TYPE(STATIC) FPOS(0.4,2.2) SIZE(98.4,.2) STYPE(12)
      TYPE(End)
    TYPE(End)
  TYPE(End)

*/