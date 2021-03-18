TYPE(drgForm) DTYPE(10) TITLE(Operace k položce) SIZE(70,27) FILE(POLOPERw);
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:y:myMenuBar) ;
              POST(postValidate) CBSAVE( OnSave)

TYPE(Static) STYPE(12) SIZE(68,4.0) FPOS(1,0.1) RESIZE(yn) CTYPE(2)
  TYPE(Text) CAPTION(Výrobní zakázka)  CPOS( 1, 0.2) CLEN( 20)
  TYPE(Text) NAME(CCISZAKAZ)           CPOS( 1, 1.3) CLEN( 31) BGND(13) FONT(5) GROUPS(clrGREEN)
  TYPE(Text) NAME(VyrZak->cNazevZak1)  CPOS( 1, 2.3) CLEN( 31) BGND(13) GROUPS(clrGREY)
  TYPE(Text) CAPTION(Vyrábìná položka) CPOS(35, 0.2) CLEN( 20)
  TYPE(Text) NAME(CVYRPOL)             CPOS(35, 1.3) CLEN( 31) BGND(13) FONT(5) GROUPS(clrGREEN)
  TYPE(Text) NAME(VyrPOL->cNazev)      CPOS(35, 2.3) CLEN( 31) BGND(13) GROUPS(clrGREY)
TYPE(End)

*TYPE(Static) STYPE(13) SIZE(68,20.6) FPOS(1, 4.2) RESIZE(yy)
TYPE(Static) STYPE(13) SIZE(68,16.7) FPOS(1, 4.2) RESIZE(yn)
  TYPE(GET)      NAME(nCisOper)             FPOS(16, 0.2) FLEN( 15) FCAPTION(Èíslo operace)     CPOS( 1, 0.2) PP(2)
  TYPE(GET)      NAME(nUkonOper)            FPOS(16, 1.2) FLEN( 15) FCAPTION(Úkon operace)      CPOS( 1, 1.2) PP(2)
  TYPE(GET)      NAME(nVarOper)             FPOS(16, 2.2) FLEN( 15) FCAPTION(Varianta operace)  CPOS( 1, 2.2) PP(2)
  TYPE(GET)      NAME(cOznOper)             FPOS(16, 3.2) FLEN( 15) FCAPTION(Typová operace)    CPOS( 1, 3.2) PP(2) PUSH( vyr_OPERACE_sel)
  TYPE(Text)     NAME(OPERACE->CNAZOPER)    CPOS(33, 3.2) CLEN( 30) BGND(13)

  TYPE(GET)      NAME(nHodinSaz)            FPOS(16, 4.2) FLEN( 15) FCAPTION(Hodinová sazba)    CPOS( 1, 4.2)
  TYPE(GET)      NAME(nCyklCas)             FPOS(16, 5.2) FLEN( 15) FCAPTION(Cyklový èas)       CPOS( 1, 5.2)
  TYPE(GET)      NAME(nNormaKsSt)           FPOS(16, 6.2) FLEN( 15) FCAPTION(Norma ks na stroj) CPOS( 1, 6.2)
  TYPE(GET)      NAME(nKoefMnoSt)           FPOS(16, 7.2) FLEN( 15) FCAPTION(Poèet strojù)      CPOS( 1, 7.2)
  TYPE(GET)      NAME(nKcDilec)             FPOS(16, 8.2) FLEN( 15) FCAPTION(Mzda za 1 dílec)   CPOS( 1, 8.2)
  TYPE(GET)      NAME(nProcRezie)           FPOS(16, 9.2) FLEN( 15) FCAPTION(Procento režie)    CPOS( 1, 9.2)
  TYPE(GET)      NAME(nKcNaOper)            FPOS(16,10.2) FLEN( 15) FCAPTION(Cena operace)      CPOS( 1,10.2)

  *  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*  TYPE(PushButton) POS(33,12.2) SIZE(24,1) CAPTION(~Pøepoèet èasù z ceny operace) EVENT(VYR_PrepocetCASU) PRE(2) ;
*    ICON1(101) ICON2(201) ATYPE(3)

  TYPE(GET)      NAME(cText1)               FPOS(16,13.5) FLEN( 40) FCAPTION(Poznámky) CPOS( 1,13.5)
  TYPE(GET)      NAME(cText2)               FPOS(16,14.5) FLEN( 40)
  TYPE(GET)      NAME(cText3)               FPOS(16,15.5) FLEN( 40)
TYPE(End)

TYPE(MLE) NAME(mPolOper) FPOS(0.5, 22.4) SIZE(68,4.5) ;
                         FCAPTION(Popis operace) CPOS( 1, 21.4) CLEN(12) RESIZE(yy)