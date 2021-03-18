TYPE(drgForm) DTYPE(10) TITLE(MZDOV� L�STKY - dle pln�n�) FILE(LISTIT);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO( VYR_MListIT_CRD)

TYPE(Action) CAPTION(~Rozd�len� ML)   EVENT( ML_Rozdelit ) TIPTEXT(Rozd�len� mzdov�ho l�stku )
TYPE(Action) CAPTION(~Zapl�nov�n� ML) EVENT( ML_Planovat ) TIPTEXT(Zapl�nov�n� mzdov�ho l�stku )

* LISTIT ... polo�ky (pln�n�) ML
  TYPE(DBrowse) FILE(LISTIT) INDEXORD(13);
                FIELDS(VyrZAK->cStavZakaz ,;
                       cCisZakaz   ,;
                       cVyrPol     ,;
                       nPorCisLis  ,;
                       nRokVytvor  ,;
                       nOsCisPrac  ,;
                       dVyhotSkut  ,;
                       nKusyHotov  ,;
                       nNmNaOpeSk  ,;
                       nNhNaOpeSk  ,;
                       cStavListk  );
               SIZE(100,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)

* �daje o pln�n�
  TYPE(TabPage) CAPTION( �daje o pln�n�) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(1,82) PRE(tabSelect)
      TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
*       1.SL
        TYPE(Text)  CAPTION(Pracovn�k)         CPOS( 1, 0.5) CLEN( 12)
        TYPE(TEXT)  NAME(nOsCisPrac)           CPOS(15, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  NAME(MsPrc_MD->cPracovnik) CPOS(31, 0.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Pracovn� za�azen�) CPOS( 1, 1.5) CLEN( 13)
        TYPE(TEXT)  NAME(cPracZar)             CPOS(15, 1.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_PracZa->cNazPracZa) CPOS(31, 1.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Tarifn� stupnice)  CPOS( 1, 2.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTarifStup)           CPOS(15, 2.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TarStu->cNazTarStu) CPOS(31, 2.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Tarifn� t��da)     CPOS( 1, 3.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTarifTrid)           CPOS(15, 3.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TarTri->cNazTarTri) CPOS(31, 3.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Druh mzdy)         CPOS( 1, 4.5) CLEN( 12)
        TYPE(TEXT)  NAME(nDruhMzdy)            CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  NAME(DruhyMzd->cNazevDmz)  CPOS(31, 4.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Typ l�stku)        CPOS( 1, 5.5) CLEN( 12)
        TYPE(TEXT)  NAME(cTypListku)           CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_TypLis->cPopisTypu) CPOS(31, 5.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Druh l�stku)       CPOS( 1, 6.5) CLEN( 12)
        TYPE(TEXT)  NAME(cDruhListk)           CPOS(15, 6.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  CAPTION(Stav l�stku)       CPOS( 1, 7.5) CLEN( 12)
        TYPE(TEXT)  NAME(cStavListk)           CPOS(15, 7.5) CLEN( 15) BGND(13) FONT(5)
*        2.SL
        TYPE(Text)  CAPTION(Nh na operaci PL�N)   CPOS(63, 0.5) CLEN( 18)
        TYPE(TEXT)  NAME(nNhNaOpePl)              CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nh na operaci SKUT.)  CPOS(63, 1.5) CLEN( 18)
        TYPE(TEXT)  NAME(nNhNaOpeSK)              CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nm na operaci PL�N)   CPOS(63, 2.5) CLEN( 18)
        TYPE(TEXT)  NAME(nNmNaOpePl)              CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nm na operaci SKUT.)  CPOS(63, 3.5) CLEN( 18)
        TYPE(TEXT)  NAME(nNmNaOpeSK)              CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(K� na operaci PL�N)   CPOS(63, 4.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKcNaOpePl)              CPOS(82, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(K� na operaci SKUT.)  CPOS(63, 5.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKcNaOpeSK)              CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
      TYPE(End)

  TYPE(End)

* Popis l�stku
  TYPE(TabPage) CAPTION( Popis l�stku) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66) PRE(tabSelect)
    TYPE(MLE) NAME('mTextML') FPOS( 1, 0.2) SIZE( 98, 9) RESIZE(yx) READONLY(y)
  TYPE(End)

* LISTHD - popis hlavi�ky ML
  TYPE(TabPage) CAPTION( Hlavi�ka l�stku) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(33,50) PRE(tabSelect)
      TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
*       1.SL
        TYPE(Text)  CAPTION(V�robn� zak�zka)   CPOS( 1, 0.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->cCisZakaz)    CPOS(15, 0.5) CLEN( 40) BGND(13) FONT(5)
*        TYPE(Text)  NAME(VyrZAK->cNazevZak1)   CPOS(31, 0.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Vyr�b�n� polo�ka)  CPOS( 1, 1.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->cVyrPol)      CPOS(15, 1.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(ListHD->cNazev)       CPOS(31, 1.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(��s.operace)       CPOS( 1, 2.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->nCisOper)     CPOS(15, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(�kon operace)      CPOS( 1, 3.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->nUkonOper)    CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Varianta operace)  CPOS( 1, 4.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->nVarOper)     CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Typov� operace)    CPOS( 1, 5.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->cOznOper)     CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(ListHD->cNazOper)     CPOS(31, 5.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(V�r. st�edisko)    CPOS( 1, 6.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->cStred)       CPOS(15, 6.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_Stred->cNazStr)     CPOS(31, 6.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Pracovi�t�)        CPOS( 1, 7.5) CLEN( 14)
        TYPE(TEXT)  NAME(ListHD->cOznPrac)     CPOS(15, 7.5) CLEN( 15) BGND(13) FONT(5)
        TYPE(Text)  NAME(C_Pracov->cNazevPrac) CPOS(31, 7.5) CLEN( 30) BGND(13)
*       2.SL
        TYPE(Text)  CAPTION(Kusov� �as)           CPOS(63, 0.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nKusovCas)       CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(P��pravn� �as)        CPOS(63, 1.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nPriprCas)       CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nh na operaci PL�N)   CPOS(63, 2.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nNhNaOpePl)      CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nh na operaci SKUT.)  CPOS(63, 3.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nNhNaOpeSK)      CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nm na operaci PL�N)   CPOS(63, 4.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nNmNaOpePl)      CPOS(82, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(Nm na operaci SKUT.)  CPOS(63, 5.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nNmNaOpeSK)      CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(K� na operaci PL�N)   CPOS(63, 6.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nKcNaOpePl)      CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
        TYPE(Text)  CAPTION(K� na operaci SKUT.)  CPOS(63, 7.5) CLEN( 18)
        TYPE(TEXT)  NAME(ListHD->nKcNaOpeSK)      CPOS(82, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(End)
  TYPE(End)