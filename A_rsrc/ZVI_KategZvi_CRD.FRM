TYPE(drgForm) DTYPE(10) TITLE(Kategorie zvíøete) SIZE(100,21) FILE(KategZVIw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)

*TYPE(Action) CAPTION(~Opravy a emise) EVENT( OPRAVY_EMISE) TIPTEXT(Opravy a emise)
*TYPE(Action) EVENT( SEPARATOR)

TYPE(Static) STYPE(13) SIZE(99, 2.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(GET)      NAME(nZvirKat)  FPOS( 3,1.2) FLEN(15) FCAPTION(Kategorie)               CPOS( 3,0.2) PP(2) NOREVISION()
  TYPE(GET)      NAME(cNazevKat) FPOS(20,1.2) FLEN(50) FCAPTION(Název kategorie zvíøete) CPOS(20,0.2)
  TYPE(COMBOBOX) NAME(cTypEvid)  FPOS(72,1.2) FLEN(20) FCAPTION(Typ evidence)            CPOS(72,0.2) PP(2)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(100,20) FPOS(0,3) RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) TTYPE(4) CAPTION(Základní údaje) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect) EXT()

    TYPE(Static) STYPE(13) SIZE( 99, 16.5) FPOS( 0.5,0.2) RESIZE(yn)
      TYPE(COMBOBOX) NAME(nPohlavi)            FPOS(20, 1) FLEN(21) FCAPTION(Pohlavi)        CPOS( 2,1)
      TYPE(GET)      NAME(nUcetSkup)           FPOS(20, 2) FLEN(20) FCAPTION(Úèetní skupina) CPOS( 2,2)  PP(2)
      TYPE(Text)     NAME(C_UctSkZ->cNazUctSk) CPOS(42, 2) CLEN(25) BGND(13)
      TYPE(GET)      NAME(cDanPZBO)            FPOS(20, 3) FLEN(20) FCAPTION(Daòová položka)        CPOS( 2,3)
      TYPE(GET)      NAME(ctypCZcpa)           FPOS(20, 4) FLEN(20) FCAPTION(Typ cz-cpa)            CPOS( 2,4)
      TYPE(Text)     NAME(c_czcpa->cnazCZcpa)  CPOS(42, 4) CLEN(17) BGND(13)

*      TYPE(GET)      NAME(cTypSkp)             FPOS(20, 4) FLEN(20) FCAPTION(SKP - klasif.produkce) CPOS( 2,4)
*      TYPE(Text)     NAME(C_TypSKP->cNazTypSkp)CPOS(42, 4) CLEN(17) BGND(13)

      TYPE(GET)      NAME(cNazPol2)            FPOS(20, 5) FLEN(20) FCAPTION(Výkon)                 CPOS( 2,5) PP(2)
      TYPE(Text)     NAME(cNazPol2->cNazev)    CPOS(42, 5) CLEN(17) BGND(13)

      TYPE(COMBOBOX) NAME(cTypVypCen)          FPOS(20, 6.5) FLEN(21) FCAPTION(Typ ceny)            CPOS( 2, 6.5) PP(2) REF(TYPSKLCEN)
      TYPE(COMBOBOX) NAME(nTypVypCel)          FPOS(20, 7.5) FLEN(21) FCAPTION(Výpoèet ceny celkem) CPOS( 2, 7.5) PP(2)
      TYPE(GET)      NAME(nCenaV1ZV)           FPOS(20, 8.5) FLEN(20) FCAPTION(V-cena narození)     CPOS( 2, 8.5)
      TYPE(GET)      NAME(nCenaV2ZV)           FPOS(20, 9.5) FLEN(20) FCAPTION(V-cena pøírùstek)    CPOS( 2, 9.5)
      TYPE(COMBOBOX) NAME(lVzrust)             FPOS(20,10.5) FLEN(21) FCAPTION(Vzrùstový pøírùstek) CPOS( 2,10.5) REF(LYESNO)

      TYPE(GET)      NAME(nZvirKatPR)          FPOS(20,12)   FLEN(20) FCAPTION(Kategorie pro pøevod) CPOS( 2,12)
      TYPE(GET)      NAME(cNazPol2PR)          FPOS(20,13)   FLEN(20) FCAPTION(Výkon pro pøevod)     CPOS( 2,13)
      TYPE(COMBOBOX) NAME(nZnAktD)             FPOS(20,14.1) FLEN(21) FCAPTION( Stav daò.aktivace)   CPOS( 2,14.1) VALUES(a,a,a)
      TYPE(COMBOBOX) NAME(nZnAkt)              FPOS(20,15.2) FLEN(21) FCAPTION( Stav úèet.aktivace)  CPOS( 2,15.2) VALUES(a,a,a)
**
      TYPE(COMBOBOX) NAME(nZpuOdpis)           FPOS(78, 3)   FLEN(16) FCAPTION(Zpùsob odpisování)    CPOS(60, 3) REF(NZPUODPIS)
      TYPE(GET)      NAME(cOdpiSkD)            FPOS(78, 4)   FLEN(15) FCAPTION(Daòová skupina)       CPOS(60, 4)
      TYPE(COMBOBOX) NAME(nTypDOdpi)           FPOS(78, 5)   FLEN(16) FCAPTION(Typ daòového odpisu)  CPOS(60, 5) REF(TYPDODPI)
      TYPE(GET)      NAME(cOdpiSk)             FPOS(78, 6)   FLEN(15) FCAPTION(Úèetní skupina)       CPOS(60, 6)
      TYPE(COMBOBOX) NAME(nTypUOdpi)           FPOS(78, 7)   FLEN(16) FCAPTION(Typ úèetního odpisu)  CPOS(60, 7) REF(TYPUODPI)
      TYPE(COMBOBOX) NAME(nTypVypUO)           FPOS(78, 8)   FLEN(16) FCAPTION(Typ výpoètu odpisu)   CPOS(60, 8) REF(NTYPVYPUO)
      TYPE(COMBOBOX) NAME(nUplProc)            FPOS(78, 9)   FLEN(16) FCAPTION(Uplatnìní procent)    CPOS(60, 9) REF(UPLPROC)

      TYPE(TEXT) CAPTION(Parametry pøevodu do ZS na jinou úè.sk.)    CPOS(  60, 10.2) CLEN(30)
      TYPE(Static) STYPE(17) SIZE(40, 0.1) FPOS( 55, 10.7) RESIZE(yx)

      TYPE(GET)      NAME(nKcPrevTop)          FPOS(78, 11.3) FLEN(15) FCAPTION(Horní hranice pøevodu) CPOS( 60, 11.3)
      TYPE(GET)      NAME(nKcPrevBot)          FPOS(78, 12.3) FLEN(15) FCAPTION(Dolní hranice pøevodu) CPOS( 60, 12.3)
      TYPE(GET)      NAME(nUcetSkupP)          FPOS(78, 13.3) FLEN(15) FCAPTION(Nová úèetní skupina)   CPOS( 60, 13.3)

      TYPE(GET)      NAME(cTypSkp)             FPOS(78, 15.2) FLEN(20) FCAPTION(SKP - klasif.produkce) CPOS( 60, 15.2)
*      TYPE(Text)     NAME(C_TypSKP->cNazTypSkp)CPOS(42, 4) CLEN(17) BGND(13)

    TYPE(END)
  TYPE(END)

* Karty zvíøat
  TYPE(TabPage) TTYPE(4) CAPTION(Karty zvíøat) FPOS( 1,6)  OFFSET(18,66) PRE( tabSelect) EXT()

   TYPE(DBrowse) FILE(ZVKARTY) INDEXORD(3) ;
                 FIELDS( cNazPol1:Stredisko ,;
                         cNazPol4  ,;
                         cNazPOL4->cNazev:Název stáje:20,;
                         nMnozSZV  ,;
                         nKusyZV   ,;
                         nCenaSZV  ,;
                         nCenaCZV  );
                 SIZE(98,16.5) FPOS(1, 0.5) SCROLL(ny) CURSORMODE(3) PP(7) FOOTER(Y)

TYPE(End)