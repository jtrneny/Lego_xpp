TYPE(drgForm) DTYPE(10) TITLE(Kusovníková vazba - 1) SIZE(80,26) FILE( KUSOVw);
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n);
              POST(postValidate)

TYPE(Static) STYPE(12) SIZE( 78, 4.2) FPOS( 1,0.1) RESIZE(yn) CTYPE(2)
   TYPE(Text) CAPTION( Položka VYŠŠÍ)   CPOS(  1, 0.1) CLEN( 20) SIZE(20, 1.2) FONT(2)
   TYPE(Text) NAME(M->cVyrPol)    CPOS(  1, 1.5) CLEN(20) BGND( 13) FONT(5) GROUPS(clrGREEN)
   TYPE(Text) NAME(M->cNazev)     CPOS(  1, 2.5) CLEN(40) BGND( 13) FONT(5) GROUPS(clrGREY)
   TYPE(Text) CAPTION(Varianta)   CPOS( 42, 0.1) CLEN( 8)
   TYPE(Text) NAME(M->nVarCis)    CPOS( 42, 1.5) CLEN( 5) BGND( 13) PP(2) GROUPS(clrGREEN)
   TYPE(Text) NAME(M->cVarPop)    CPOS( 42, 2.5) CLEN(35) BGND( 13) PP(2) GROUPS(clrGREY)
   TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(78,21.2) FPOS(1, 4.5) RESIZE(yn)

  TYPE(Text) CAPTION( Položka NIŽŠÍ)  CPOS( 1 ,0.1) CLEN( 15) SIZE(15, 1.2) FONT(2)
  TYPE(ComboBox) NAME(KUSTREE->lNakPOL)  FPOS( 1, 1.5) FLEN(14);
                 ITEMSELECTED(comboItemSelected)

  TYPE(GET)      NAME(KUSOVw->cNizPOL)         FPOS(16, 1.5) FLEN( 20) PUSH( VYR_VYRPOL_SEL) GROUPS(cVyrPOL)
  TYPE(GET)      NAME(KUSOVw->cSklPOL)         FPOS(16, 1.5) FLEN( 20) PUSH( VYR_NAKPOL_SEL) GROUPS(cSklPOL)
  TYPE(Text)     NAME(M->cNazNizPOL)           CPOS(37, 1.5) CLEN( 40) BGND( 13) PP(2)
  TYPE(Text)     CAPTION(Popis var.:)          CPOS(37, 2.5) CLEN( 10)           GROUPS(cVyrPOL)
  TYPE(Text)     NAME(M->cNizVarPop)           CPOS(47, 2.5) CLEN( 30) BGND( 13) GROUPS(cVyrPOL)
  TYPE(GET)      NAME(KUSOVw->nPozice)         FPOS(16, 2.8) FLEN(  8) FCAPTION(Pozice)           CPOS( 1, 2.8)
  TYPE(GET)      NAME(KUSOVw->nVarPoz)         FPOS(16, 3.8) FLEN(  5) FCAPTION(Varianta pozice)  CPOS( 1, 3.8)
  TYPE(GET)      NAME(KUSOVw->cKodPoz)         FPOS(16, 4.8) FLEN(  5) FCAPTION(Kód pozice)       CPOS( 1, 4.8)

  TYPE(GET)      NAME(KUSOVw->nVahaMJ)         FPOS(16, 5.8) FLEN( 13) FCAPTION(Mìrná hmotnost)   CPOS( 1, 5.8) PICTURE(&N 9999999.999)
  TYPE(GET)      NAME(KUSOVw->nRozmB)          FPOS(16, 6.8) FLEN( 13) FCAPTION(Délka dílce)      CPOS( 1, 6.8) PICTURE(&N 9999.999999)
  TYPE(GET)      NAME(KUSOVw->nPridUp)         FPOS(16, 7.8) FLEN( 13) FCAPTION(Úchyt dílce)      CPOS( 1, 7.8)

  TYPE(GET)      NAME(KUSOVw->nCiMno)          FPOS(47, 3.8) FLEN( 15) FCAPTION(Èistá délka dílce) CPOS( 32, 3.8)
  TYPE(GET)      NAME(KUSOVw->cMjTpv)          FPOS(63, 3.8) FLEN(  6) PUSH(Jednot_sel)
  TYPE(GET)      NAME(KUSOVw->nSpMno)          FPOS(47, 4.8) FLEN( 15) FCAPTION(Délka polotovaru)  CPOS( 32, 4.8)
  TYPE(GET)      NAME(KUSOVw->cMjSpo)          FPOS(63, 4.8) FLEN(  6) PUSH(Jednot_sel)
*  TYPE(Text)     CAPTION(Mn.skladové hrubé)    CPOS(32, 5.8) CLEN( 15)
  TYPE(Text)     CAPTION(Hmotn. polotovaru)    CPOS(32, 5.8) CLEN( 15)
  TYPE(GET)      NAME(M->nSpMnSklHR)           FPOS(47, 5.8) FLEN( 15) BGND( 13) PP(2) PICTURE(@N 999999.999999)CTYPE(2)
  TYPE(TEXT)     NAME(KUSOVw->cZkratJedn)      CPOS(63, 5.8) CLEN(  6) BGND( 13) PP(2)
*  TYPE(Text)     CAPTION(Mn.skladové èisté)    CPOS(32, 6.8) CLEN( 15)
  TYPE(Text)     CAPTION(Èistá hmotnost dílce) CPOS(32, 6.8) CLEN( 15)
  TYPE(GET)      NAME(M->nSpMnSklCI)           FPOS(47, 6.8) FLEN( 15) BGND( 13) PICTURE(@N 999999.999999)CTYPE(2)
  TYPE(TEXT)     NAME(KUSOVw->cZkratJedn)      CPOS(63, 6.8) CLEN(  6) BGND( 13) PP(2)

  TYPE(GET)      NAME(KUSOVw->nCiMnoVyk)       FPOS(47, 7.8) FLEN( 15) FCAPTION(Váha z výkresu) CPOS( 32, 7.8)
  TYPE(TEXT)     NAME(KUSOVw->cZkratJedn)      CPOS(63, 7.8) CLEN(  6) BGND( 13) PP(2)

  TYPE(GET)      NAME(KUSOVw->nCenMAT_MJ)      FPOS(47, 8.8) FLEN( 15) FCAPTION(Cena za MJ) CPOS( 32, 8.8)
*
**  TYPE(Text)     CAPTION(Odpad 1)              CPOS( 1, 10) CLEN( 8)
  TYPE(Text)     CAPTION(Odpad  )              CPOS( 1, 12) CLEN( 8)
*
  TYPE(GET)      NAME(KUSOVw->cPolOdp_1)       FPOS(16, 12) FLEN( 18) FCAPTION(Skl.položka) CPOS(16, 11) PUSH(VYR_NAKPOL_SEL)
  TYPE(GET)      NAME(KUSOVw->cSklOdp_1)       FPOS(36, 12) FLEN( 10) FCAPTION(Sklad)       CPOS(36, 11)
  TYPE(GET)      NAME(KUSOVw->nProcOdp_1)      FPOS(48, 12) FLEN(  8) FCAPTION( % odpadu)   CPOS(48, 11)
  TYPE(GET)      NAME(KUSOVw->nMnozOdp_1)      FPOS(58, 12) FLEN( 11) FCAPTION( Množství)   CPOS(58, 11)
  TYPE(GET)      NAME(KUSOVw->cNazOdp_1)       FPOS(16, 13) FLEN( 53)

**  TYPE(GET)      NAME(KUSOVw->cPolOdp_1)       FPOS(16, 12) FLEN( 18) PUSH(VYR_NAKPOL_SEL)
**  TYPE(GET)      NAME(KUSOVw->cSklOdp_1)       FPOS(36, 12) FLEN( 10)
**  TYPE(GET)      NAME(KUSOVw->nProcOdp_1)      FPOS(48, 12) FLEN(  8)
**  TYPE(GET)      NAME(KUSOVw->nMnozOdp_1)      FPOS(58, 12) FLEN( 11)
**  TYPE(GET)      NAME(KUSOVw->cNazOdp_1)       FPOS(16, 13) FLEN( 53)

*  TYPE(GET)      NAME(KUSOVw->nHrHm)           FPOS(16,11.8) FLEN( 10) FCAPTION(Hrubá hmotnost)    CPOS( 1, 11.8)
*  TYPE(GET)      NAME(KUSOVw->nCiHm)           FPOS(16,12.8) FLEN( 10) FCAPTION(Èistá hmotnost)    CPOS( 1, 12.8)

  TYPE(GET)      NAME(KUSOVw->cText1)          FPOS(16,14.8) FLEN(53) FCAPTION(Poznámka)         CPOS( 1,14.8)
  TYPE(GET)      NAME(KUSOVw->cText2)          FPOS(16,15.8) FLEN(53)

  TYPE(MLE) NAME(mKusov) FPOS(0.5, 17.7) SIZE(77,3.5) ;
                           FCAPTION(Popis vazby) CPOS( 1, 16.7) CLEN(12) RESIZE(yx)
TYPE(End)