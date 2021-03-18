TYPE(drgForm) DTYPE(1) TITLE(Odvedení mzdového lístku) SIZE(75,25) FILE(LISTITw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE)

*TYPE(Action) CAPTION(~Nìjaká ekšn) EVENT() TIPTEXT()

TYPE(Static) STYPE(12) SIZE(74, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(Text) CAPTION(Položka zakázky)       CPOS( 2, 0.3) CLEN( 12)
  TYPE(Text) NAME(cCisZakazI)               CPOS(16, 0.3) CLEN( 55) FONT( 5) BGND(13) GROUPS(clrGREEN)

  TYPE(Text) CAPTION(Èíslo lístku)          CPOS( 2, 1.6) CLEN( 12)
  TYPE(Text) NAME(nPorCisLis)               CPOS(16, 1.6) CLEN( 17) FONT( 5) BGND(13) CTYPE(2) GROUPS(clrGREEN)
  TYPE(Text) CAPTION(Rok vytvoøení)         CPOS(35, 1.6) CLEN( 12)
  TYPE(Text) NAME(nRokVytvor)               CPOS(47, 1.6) CLEN(  6) FONT( 5) BGND(13) CTYPE(2) GROUPS(clrGREEN)
  TYPE(Text) CAPTION(Stav lístku)           CPOS(55, 1.6) CLEN( 10)
  TYPE(Text) NAME(cStavListk)               CPOS(65, 1.6) CLEN(  6) FONT( 5) BGND(13) GROUPS(clrGREEN)
*
*  TYPE(Text) CAPTION(Èíslo lístku)          CPOS( 4, 0.4) CLEN( 17)
*  TYPE(Text) NAME(nPorCisLis)               CPOS( 4, 1.4) CLEN( 15) FONT( 5) BGND(13) CTYPE(2) PP(2)
*  TYPE(Text) CAPTION(Rok vytvoøení)         CPOS(21, 0.4) CLEN( 13)
*  TYPE(Text) NAME(nRokVytvor)               CPOS(21, 1.4) CLEN( 10) FONT( 5) BGND(13) CTYPE(2) PP(2)
*  TYPE(Text) CAPTION(Stav lístku)           CPOS(36, 0.4) CLEN( 15)
*  TYPE(Text) NAME(cStavListk)               CPOS(36, 1.4) CLEN( 35) FONT( 5) BGND(13)

TYPE(End)

TYPE(Static) STYPE(13) SIZE( 75,21.2) FPOS(0,3.7) RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74,19.8) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTypListku)           FPOS(20, 0.5) FLEN( 15) FCAPTION(Typ lístku)           CPOS( 1, 0.5)
      TYPE(Text)     NAME(c_TypLis->cPopisTypu) CPOS(37, 0.5) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nDruhMzdy)            FPOS(20, 1.5) FLEN( 15) FCAPTION(Druh mzdy)            CPOS( 1, 1.5)
      TYPE(Text)     NAME(DruhyMzd->cNazevDmz)  CPOS(37, 1.5) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(dVyhotSkut)           FPOS(20, 2.5) FLEN( 15) FCAPTION(Dat.skuteè. vyhotovení)  CPOS( 1, 2.5) PUSH(CLICKDATE)
      TYPE(GET)      NAME(nOsCisPrac)           FPOS(20, 3.5) FLEN( 15) FCAPTION(OsÈísPrac/Poø/KmenStø) CPOS( 1, 3.5)   PUSH(VYR_kmenove_SEL)
      TYPE(GET)      NAME(nPorPraVzt)           FPOS(37, 3.5) FLEN(  4) 
      TYPE(GET)      NAME(cKmenStrPr)           FPOS(43, 3.5) FLEN(  9) 
      TYPE(GET)      NAME(nCisOsoby)            FPOS(20, 4.5) FLEN( 15) FCAPTION(Èíslo osoby)          CPOS( 1, 4.5)
      TYPE(Text)     NAME(cjmenoRozl)           CPOS(37, 4.5) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(nMzdaZaKus)           FPOS(20, 5.8) FLEN( 15) FCAPTION(Mzda za MJ .)         CPOS( 1, 5.8)

* Vykázané množství
      TYPE(Text)  CAPTION( Vykázané množství) CPOS( 1, 7.8) CLEN( 15)
      TYPE(TEXT)  CAPTION( Celkem .)          CPOS(20, 6.8) CLEN( 7)
      TYPE(TEXT)  CAPTION( Hotové .)          CPOS(37, 6.8) CLEN( 7)
      TYPE(TEXT)  CAPTION( Neshodné .)        CPOS(54, 6.8) CLEN( 9)
      TYPE(STATIC) FPOS( 1, 7.3) SIZE( 72,.1) STYPE(13) RESIZE(yn)
      TYPE(End)
      TYPE(GET)      NAME(nKusyCelk)            FPOS(20, 7.8) FLEN( 15)
      TYPE(GET)      NAME(nKusyHotov)           FPOS(37, 7.8) FLEN( 15)
      TYPE(GET)      NAME(nKusyVadne)           FPOS(54, 7.8) FLEN( 15)

* Normoèasy
      TYPE(Text) CAPTION( Plán)          CPOS(20, 8.8) CLEN( 5)
      TYPE(Text) CAPTION( Skuteènost .)  CPOS(37, 8.8) CLEN(11)
      TYPE(Text) CAPTION( Plnìní)        CPOS(54, 8.8) CLEN( 7)
      TYPE(STATIC) FPOS( 1, 9.3) SIZE( 72,.1) STYPE(13)
      TYPE(End)

      TYPE(GET)  NAME(nNhNaOpePl)        FPOS(20, 9.8) FLEN( 15) FCAPTION(Nh na operaci)    CPOS( 1, 9.8)
      TYPE(GET)  NAME(nNmNaOpePl)        FPOS(20,10.8) FLEN( 15) FCAPTION(Nm na operaci)    CPOS( 1,10.8)
      TYPE(GET)  NAME(nKcNaOpePl)        FPOS(20,11.8) FLEN( 15) FCAPTION(Cena operace)     CPOS( 1,11.8)
      TYPE(GET)  NAME(nNhNaOpeSk)        FPOS(37, 9.8) FLEN( 15)
      TYPE(GET)  NAME(nNmNaOpeSk)        FPOS(37,10.8) FLEN( 15)
      TYPE(GET)  NAME(nKcNaOpeSk)        FPOS(37,11.8) FLEN( 15)
      TYPE(Text) NAME(M->nPlneniProc)    CPOS(54, 9.8) CLEN( 12) BGND(13) CTYPE( 2)
      TYPE(TEXT) CAPTION( %)             CPOS(67, 9.8) CLEN(  3)

      TYPE(STATIC) FPOS( 1, 13.3) SIZE( 72,.1) STYPE(13)
      TYPE(End)

**      TYPE(GET)  NAME(dVyhotSkut)         FPOS(20, 12.8) FLEN( 15) FCAPTION(Dat.skuteè. vyhotovení)  CPOS( 1, 12.8)PP(2) PUSH(CLICKDATE)
      TYPE(GET)  NAME(nTydKapBlo)         FPOS(20, 13.8) FLEN( 15) FCAPTION(Týden zaplánování)       CPOS( 1, 13.8)
      TYPE(GET)  NAME(nCisloKusu)         FPOS(54, 13.8) FLEN( 15) FCAPTION(Èíslo kusu)              CPOS(37, 13.8)
      TYPE(GET)  NAME(nTarSazHod)         FPOS(20, 14.8) FLEN( 15) FCAPTION(Sazba pracovníka)        CPOS( 1, 14.8)
     
      TYPE(TEXT) CAPTION(+)               CPOS(37, 14.8) CLEN(  2)
      TYPE(TEXT) NAME(M->procPremii)      CPOS(38, 14.8) CLEN( 10)
      TYPE(TEXT) CAPTION(% prémií)        CPOS(48, 14.8) CLEN( 10) 

      TYPE(GET)  NAME(cNazPol1)           FPOS(20, 15.8) FLEN( 15) FCAPTION(Støedisko nákladové)            CPOS( 1, 15.8)
      TYPE(Text) NAME(cNazPol1->cNazev)   CPOS(37, 15.8) CLEN( 35) BGND(13)
      TYPE(GET)  NAME(cNazPol4)           FPOS(20, 16.8) FLEN( 15) FCAPTION(Výrobní místo)                  CPOS( 1, 16.8)
      TYPE(Text) NAME(cNazPol4->cNazev)   CPOS(37, 16.8) CLEN( 35) BGND(13)
      TYPE(GET)  NAME(cKodPripl)          FPOS(20, 17.8) FLEN( 15) FCAPTION(Kód pøíplatku)                  CPOS( 1, 17.8)
      TYPE(Text) NAME(C_Pripl->cNazPripl) CPOS(37, 17.8) CLEN( 35) BGND(13)
      TYPE(GET)  NAME(nKcOpePrip)         FPOS(20, 18.8) FLEN( 15) FCAPTION(Pøíplatky celkem)               CPOS( 1, 18.8)
      TYPE(COMBOBOX)  NAME(lNoExpMzd)     FPOS(62, 18.9) FLEN( 10) FCAPTION(Zablokovat lístek pro mzdy)     CPOS(37, 18.9) REF( LYESNO)
    TYPE(End)
  TYPE(END)

* POPIS LÍSTKU
  TYPE(TabPage) TTYPE(4) CAPTION(Popis lístku) OFFSET(24,52)
    TYPE(MLE) NAME(mTextML) FPOS(1, 0.5) SIZE(73,19)
  TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(listitW->nmsprc_mo)    FPOS(0,0) CLEN(0) 

TYPE(End)


