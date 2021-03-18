TYPE(drgForm) DTYPE(10) TITLE(MATERIÁLOVÉ požadavky na zakázku) FILE(VYRZAK);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(~Materiál)        EVENT(ZAK_MATERIAL) TIPTEXT(Požadavky na materiál)
TYPE(Action) CAPTION(~Plán vs. skut.)  EVENT(ZAK_PLANSKUT) TIPTEXT(Porovnání plánu a skuteènosti)
TYPE(Action) CAPTION(~Zrušit materiál) EVENT(ZAK_MATERIAL_DEL) TIPTEXT(Zrušit požadavky na materiál)

* VYRZAK ... Seznam zakázek
  TYPE(TabPage) CAPTION( Zakázky) FPOS(0, 0) SIZE(100,13.4) OFFSET(1,82) PRE(tabSelect)
    TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
                 FIELDS( cCisZakaz::25   ,;
                         cStavZakaz:Stav ,;
                         cNazevZak1::30  ,;
                         cVyrPol     ,;
                         nVarCis     ,;
                         nMnozPlano  );
                 SIZE(100,12.3) CURSORMODE(3) PP(7) Resize(yx) SCROLL(ny) POPUPMENU(yn);
                 ITEMMARKED( ItemMarked)
  TYPE(End)

  TYPE(TabPage) CAPTION( Položky zakázky) FPOS(0, 0) SIZE(100,13.4) OFFSET(18,66) PRE(tabSelect)
    TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1);
                 FIELDS( cCisZakaz::25   ,;
                         cStavZakaz:Stav ,;
*                         cNazevZak1::30  ,;
                         cVyrPol     ,;
                         nVarCis     ,;
                         cVyrobCisl  ,;
                         nMnozPlano  );
                 SIZE(100,12.3) CURSORMODE(3) PP(7) Resize(yx) SCROLL(ny) POPUPMENU(yn);
                 ITEMMARKED( ItemMarked)
  TYPE(End)


* OBJITEM - položky Objednávky pøijaté
*  TYPE(TabPage) CAPTION( Objednávky pøijaté) FPOS(0, 14.3) SIZE(100,10.5) RESIZE(yx) OFFSET(1,82)
    TYPE(TEXT) CAPTION(Objednávky pøijaté) CPOS(.1,13.5) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
     TYPE(DBrowse) FILE(OBJITEM) INDEXORD(9);
                 FIELDS( cSklPOL:Skladová položka     ,;
                         cNazZbo:Název zboží          ,;
                         nMnozObOdb:Mn.objednané odb. ,;
                         nMnozPrDod:Mn.pøijaté dod.   ,;
                         nMnozPlOdb:Mn.plnìní odb.    );
                 FPOS(0, 14.4) SIZE(100, 10.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)
*  TYPE(End)

** VYRZAK - údaje o zakázce
*  TYPE(TabPage) CAPTION( Údaje o zakázce) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66)
*    TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
**     1.SL
*      TYPE(Text)  CAPTION(Výrábìná položka)  CPOS( 1, 0.5) CLEN( 14)
*      TYPE(TEXT)  NAME(cVyrPol)              CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5)
*      TYPE(Text)  NAME(VYRPOL->cNazev)       CPOS(31, 0.5) CLEN( 30) BGND(13)
*      TYPE(Text)  CAPTION(Varianta)          CPOS( 1, 1.5) CLEN( 13)
*      TYPE(TEXT)  NAME(nVarCis)              CPOS(15, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  NAME(VYRPOL->cVarPop)      CPOS(31, 1.5) CLEN( 30) BGND(13)
*      TYPE(Text)  CAPTION(Èíslo objednávky)  CPOS( 1, 2.5) CLEN( 13)
*      TYPE(TEXT)  NAME(cCisloObj)            CPOS(15, 2.5) CLEN( 40) BGND(13) FONT(5)

*      TYPE(Text)  CAPTION(Založení zak.)     CPOS( 1, 3.5) CLEN( 12)
*      TYPE(TEXT)  NAME(dZapis)               CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Plán. odvedení)    CPOS( 1, 4.5) CLEN( 12)
*      TYPE(TEXT)  NAME(dOdvedZAKA)           CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Èíslo plánu)       CPOS( 1, 5.5) CLEN( 12)
*      TYPE(TEXT)  NAME(cCisPlan)             CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
*      TYPE(Text)  CAPTION(Skut. odvedení)    CPOS( 1, 6.5) CLEN( 12)
*      TYPE(TEXT)  NAME(dSkuOdvZak)           CPOS(15, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Uzavøení zak.)     CPOS( 1, 7.5) CLEN( 12)
*      TYPE(TEXT)  NAME(dUzavZaka)            CPOS(15, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

**     2.SL
*      TYPE(Text)  CAPTION(Mn.plán. z objednávek) CPOS(63, 0.5) CLEN( 18)
*      TYPE(TEXT)  NAME(nMnozPlano)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Zadáno do výroby)      CPOS(63, 1.5) CLEN( 18)
*      TYPE(TEXT)  NAME(nMnozZadan)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Mn. vyrobené)          CPOS(63, 2.5) CLEN( 18)
*      TYPE(TEXT)  NAME(nMnozVyrob)               CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Plánovaný prùbìh)      CPOS(63, 3.5) CLEN( 18)
*      TYPE(TEXT)  NAME(nPlanPruZa)               CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

*      TYPE(Text)  CAPTION(Priorita zakázky)      CPOS(63, 5.5) CLEN( 18)
*      TYPE(TEXT)  NAME(cPriorZaka)               CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
*      TYPE(Text)  CAPTION(Stav kapacit)          CPOS(63, 6.5) CLEN( 18)
*      TYPE(TEXT)  NAME(cStavKapZa)               CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

*    TYPE(End)

*  TYPE(End)