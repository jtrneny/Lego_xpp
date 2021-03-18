TYPE(drgForm) DTYPE(10) TITLE(Kusovníková vazba) SIZE(80,25) FILE( kusovWe);
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

TYPE(Static) STYPE(13) SIZE(78,20.2) FPOS(1, 4.5) RESIZE(yn)

  TYPE(Text) CAPTION( Položka NIŽŠÍ)  CPOS( 1 ,0.1) CLEN( 15) SIZE(15, 1.2) FONT(2)
  TYPE(ComboBox) NAME(KUSTREE->lNakPOL)  FPOS( 1, 1.4) FLEN(14);
                 ITEMSELECTED(comboItemSelected)

  TYPE(GET)      NAME(KUSOVwe->cNizPOL)         FPOS(16, 1.4) FLEN( 20) PUSH( VYR_VYRPOL_se_SEL) GROUPS(cVyrPOL)
  TYPE(GET)      NAME(KUSOVwe->cSklPOL)         FPOS(16, 1.4) FLEN( 20) PUSH( VYR_NAKPOL_SEL) GROUPS(cSklPOL)
  TYPE(GET)      NAME(M->cNazNizPOL)            FPOS(38, 1.4) FLEN( 38) PICTURE(&50X)

*  TYPE(Text)     NAME(M->cNazNizPOL)           CPOS(37, 1.4) CLEN( 40) BGND( 13) PP(2)
  TYPE(Text)     CAPTION(Popis var.:)          CPOS(37, 2.4) CLEN( 10)           GROUPS(cVyrPOL)
  TYPE(Text)     NAME(M->cNizVarPop)           CPOS(47, 2.4) CLEN( 30) BGND( 13) GROUPS(cVyrPOL)
  TYPE(GET)      NAME(KUSOVwe->nPozice)         FPOS(16, 2.8) FLEN(  8) FCAPTION(Pozice)           CPOS( 1, 2.8)
  TYPE(GET)      NAME(KUSOVwe->nVarPoz)         FPOS(16, 3.8) FLEN(  5) FCAPTION(Varianta pozice)  CPOS( 1, 3.8)
  TYPE(GET)      NAME(KUSOVwe->cKodPoz)         FPOS(16, 4.8) FLEN(  5) FCAPTION(Kód pozice)       CPOS( 1, 4.8)
  TYPE(GET)      NAME(KUSOVwe->cIndexPoz)       FPOS(16, 5.8) FLEN( 22) FCAPTION(Index pozice)     CPOS( 1, 5.8)

  TYPE(GET)      NAME(KUSOVwe->nCiMno)          FPOS(16, 6.8) FLEN( 15) FCAPTION(Množství èisté)    CPOS( 1, 6.8)
  TYPE(GET)      NAME(KUSOVwe->cMjTpv)          FPOS(32, 6.8) FLEN(  6) PUSH(Jednot_sel)

  TYPE(Static) STYPE( 2) SIZE(30, 5) FPOS( 44, 6.8) RESIZE(nx)
    TYPE(CHECKBOX) NAME(M->lVypCiMno)  FPOS(1, -0.1) FLEN(22) VALUES(F:Výpoèet èistého množství,T:Výpoèet èistého množství )
    TYPE(GET)      NAME(KUSOVwe->nRozmA)         FPOS(14, 1) FLEN( 13) FCAPTION(Rozmìr A)       CPOS( 1, 1) PICTURE(&N 9999999.999)
    TYPE(GET)      NAME(KUSOVwe->nRozmB)         FPOS(14, 2) FLEN( 13) FCAPTION(Rozmìr B)       CPOS( 1, 2) PICTURE(&N 9999999.999)
    TYPE(GET)      NAME(KUSOVwe->nKusRoz)        FPOS(14, 3) FLEN( 13) FCAPTION(Kusy rozmìrù)   CPOS( 1, 3) PICTURE(&N 999.999)
    TYPE(GET)      NAME(KUSOVwe->nNavysPrc)      FPOS(14, 4) FLEN( 13) FCAPTION(Navýšení v %)   CPOS( 1, 4) PICTURE(&N 99.99)
  TYPE(End)

  TYPE(GET)      NAME(KUSOVwe->nSpMno)          FPOS(16, 7.8) FLEN( 15) FCAPTION(Množství spotøební)CPOS( 1, 7.8)
  TYPE(GET)      NAME(KUSOVwe->cMjSpo)          FPOS(32, 7.8) FLEN(  6) PUSH(Jednot_sel)
*  TYPE(TEXT)     NAME(KUSTREE->cZkratJedn)     CPOS(32, 7.8) CLEN(  5) BGND( 13) PP(2)

  TYPE(Text)     CAPTION(Množství sklDisp)      CPOS( 1, 8.8) CLEN(  15)
  TYPE(Text)     NAME(M->nmnozDzbo)             CPOS(16, 8.8) CLEN(  16) BGND( 13) PP(2) PICTURE(@N 999999.999999) CTYPE(2) GROUPS(clrGREEN)
***  TYPE(Text)     NAME(M->nSpMnoSKL)            CPOS(16, 8.8) CLEN(  16) BGND( 13) PP(2) PICTURE(@N 999999.999999)CTYPE(2)
  TYPE(TEXT)     NAME(KUSOVwe->cZkratJedn)      CPOS(32, 8.8) CLEN(  6) BGND( 13) PP(2) GROUPS(clrGREEN)

  TYPE(GET)      NAME(KUSOVwe->nCisOper)        FPOS(16, 9.8) FLEN( 7) FCAPTION(Èíslo operace)    CPOS( 1, 9.8) PUSH( VYR_POLOPER_SEL)
  TYPE(GET)      NAME(KUSOVwe->nUkonOper)       FPOS(16,10.8) FLEN( 7) FCAPTION(Úkon operace)     CPOS( 1,10.8)
  TYPE(GET)      NAME(KUSOVwe->nVarOper)        FPOS(16,11.8) FLEN( 7) FCAPTION(Varianta operace) CPOS( 1,11.8)
  TYPE(GET)      NAME(KUSOVwe->cText1)          FPOS(16,12.8) FLEN(50) FCAPTION(Poznámka)         CPOS( 1,12.8)
  TYPE(GET)      NAME(KUSOVwe->cText2)          FPOS(16,13.8) FLEN(50)

  TYPE(MLE) NAME(mKusov) FPOS(0.5, 15.7) SIZE(77,4.5) ;
                           FCAPTION(Popis vazby) CPOS( 1, 14.7) CLEN(12) RESIZE(yx)
TYPE(End)