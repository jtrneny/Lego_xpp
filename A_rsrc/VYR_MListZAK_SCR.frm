TYPE(drgForm) DTYPE(10) TITLE(MZDOV� L�STKY - dle zak�zek) FILE(VYRZAK);
              SIZE(110,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(~Zru�en� l�stk�) EVENT(VYR_MListZAK_del) TIPTEXT(Zru�en� mzdov�ch l�stk� na zak�zku)
TYPE(Action) CAPTION(~Polo�ky zak�z.) EVENT(BTN_VYRZAKIT)     TIPTEXT(Polo�ky v�robn� zak�zky)


*  VYRZAK ... Seznam zak�zek
  TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
                FIELDS(cCisZakaz   ,;
                       cStavZakaz  ,;
                       cNazevZak1::30,;
                       cVyrPol     ,;
                       nVarCis     ,;
                       nMnozPlano  );
               SIZE(110,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)

* VYRZAK - �daje o zak�zce
  TYPE(TabPage) CAPTION( �daje o zak�zce) FPOS(0, 14.2) SIZE(110,10.5) RESIZE(yx) OFFSET(1,82) PRE(tabSelect)
    TYPE(Static) STYPE(13) SIZE( 109,10) FPOS(0.5, 0.2) RESIZE(yx)
*       1.SL
      TYPE(Text)  CAPTION(V�r�b�n� polo�ka)  CPOS( 1, 0.5) CLEN( 14)
      TYPE(TEXT)  NAME(cVyrPol)              CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  NAME(VYRPOL->cNazev)       CPOS(31, 0.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Varianta)          CPOS( 1, 1.5) CLEN( 13)
      TYPE(TEXT)  NAME(nVarCis)              CPOS(15, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  NAME(VYRPOL->cVarPop)      CPOS(31, 1.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(��slo objedn�vky)  CPOS( 1, 2.5) CLEN( 13)
      TYPE(TEXT)  NAME(cCisloObj)            CPOS(15, 2.5) CLEN( 40) BGND(13) FONT(5)

      TYPE(Text)  CAPTION(Zalo�en� zak.)     CPOS( 1, 3.5) CLEN( 12)
      TYPE(TEXT)  NAME(dZapis)               CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Pl�n. odveden�)    CPOS( 1, 4.5) CLEN( 12)
      TYPE(TEXT)  NAME(dOdvedZAKA)           CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(��slo pl�nu)       CPOS( 1, 5.5) CLEN( 12)
      TYPE(TEXT)  NAME(cCisPlan)             CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  CAPTION(Skut. odveden�)    CPOS( 1, 6.5) CLEN( 12)
      TYPE(TEXT)  NAME(dSkuOdvZak)           CPOS(15, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Uzav�en� zak.)     CPOS( 1, 7.5) CLEN( 12)
      TYPE(TEXT)  NAME(dUzavZaka)            CPOS(15, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

*       2.SL
      TYPE(Text)  CAPTION(Mn.pl�n. z objedn�vek) CPOS(63, 0.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozPlano)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Zad�no do v�roby)      CPOS(63, 1.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozZadan)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Mn. vyroben�)          CPOS(63, 2.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozVyrob)               CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Pl�novan� pr�b�h)      CPOS(63, 3.5) CLEN( 18)
      TYPE(TEXT)  NAME(nPlanPruZa)               CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

      TYPE(Text)  CAPTION(Priorita zak�zky)      CPOS(63, 5.5) CLEN( 18)
      TYPE(TEXT)  NAME(cPriorZaka)               CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Stav kapacit)          CPOS(63, 6.5) CLEN( 18)
      TYPE(TEXT)  NAME(cStavKapZa)               CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)

  TYPE(End)

* LISTHD - hlavi�ky ML
  TYPE(TabPage) CAPTION( Mzdov� l�stky) FPOS(0, 14.2) SIZE(109,10.5) RESIZE(yx) OFFSET(18,66) PRE(tabSelect)

    TYPE(DBrowse) FILE(LISTHD) INDEXORD(7);
                  FIELDS(nPorCisLis  ,;
                         cTypOper    ,;
                         nCisOper    ,;
                         nUkonOper   ,;
                         nVarOper    ,;
                         cOznOper    ,;
                         nNmNaOpePL  ,;
                         nKcNaOpePL  );
                 SIZE(110, 9.6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)