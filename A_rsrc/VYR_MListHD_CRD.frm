TYPE(drgForm) DTYPE(10) TITLE(MZDOVÉ LÍSTKY - poøízení a oprava) FILE(LISTHD);
              SIZE(120,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              PRE(preValidate) POST(postValidate);
              CBSAVE(vyr_mlisthd_wrt_inTrans) OBDOBI(VYR)

TYPE(Action) CAPTION(~Uzavøít lístek) EVENT(ML_Uzavrit) TIPTEXT( Uzavøení / Otevøení mzdového lístku )
*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Rozdìlit ML)   EVENT(ML_Rozdelit) TIPTEXT( Rozdìlení položky mzdového lístku )
TYPE(Action) CAPTION(~Zaplánovat ML) EVENT(ML_Planovat) TIPTEXT( Zaplánování položky mzdového lístku )
TYPE(Action) CAPTION(~Pøep.operací)  EVENT(ML_Prepocet) TIPTEXT( Pøepoèítá èas operací z ceny mzdového lístku )
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Nulovat kusy)   EVENT(ML_Nulovat) TIPTEXT(Zanulovat kusy u položky lístku)



* LISTIT - plnìní ML
  TYPE(TabPage) CAPTION( Plnìní ML) FPOS(0, 12.5) SIZE(120,12.5) OFFSET(1,82) PRE( tabSelect) TABBROWSE(LISTIT)
    TYPE(DBrowse) FILE(LISTIT) INDEXORD(1);
                 FIELDS( nOsCisPrac     ,;
                         cPrijPrac::15  ,;
                         cTypListku     ,;
                         nDruhMzdy:Dr.mzdy    ,;
                         dVyhotPlan:Vyhot.PL  ,;
                         dVyhotSkut:Vyhot.SK  ,;
                         nKusyCelk   ,;
                         nKusyHotov  ,;
                         nNmNaOpeSK  ,;
                         nNhNaOpeSK  ,;
                         nKcNaOpeSK  ,;
                         cKodPripl   ,;
                         cStavListk:Stav  );
                 SIZE(120, 11.4) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) FOOTER(y)
  TYPE(End)

* POLOPER
  TYPE(TabPage) CAPTION( Operace k ML) FPOS(0, 12.5) SIZE(120,12.5) OFFSET(18,66) PRE( tabSelect) TABBROWSE(POLOPER)
    TYPE(STATIC) STYPE( 13) FPOS(0.3,0.3) SIZE(119.5,10.9) RESIZE(YX)

      TYPE(DBrowse) FILE(POLOPER) INDEXORD(5);
                    FIELDS( cOznOper    ,;
                            Operace->cNazOper  ,;
                            nCisOper    ,;
                            nUkonOper   ,;
                            nVarOper    ,;
                            nKoefKusCa  ,;
                            VyrPol->nMnZadVK  );
                   FPOS(-0.3,0.2) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(n) FOOTER(y)
    TYPE(End)
  TYPE(End)

  TYPE(STATIC) STYPE(12) FPOS(115, 12.3) SIZE(5,1.2) RESIZE(nx)
    TYPE(STATIC) STYPE(3) FPOS(-.3,0) SIZE( 40,26 ) CAPTION(337)
  TYPE(END)

*  LISTHD ... Karta hlavièky ML
   TYPE(Static) STYPE(13) SIZE(119.8, 12.2) RESIZE(yn) FPOS(0.1,0.1) GROUPS(LISTHD)

     TYPE(GET)      NAME(nPorCisLis)            FPOS(17, 0.2) FLEN( 15) FCAPTION(Poøadové èíslo lístku) CPOS( 1, 0.2) PP(2) NOREVISION()
     TYPE(Text)     CAPTION(Rok vytvoøení)      CPOS(35, 0.2) CLEN( 12)
     TYPE(TEXT)     NAME(nRokVytvor)            CPOS(48, 0.2) CLEN( 6) BGND(13) FONT(5) CTYPE(2)
     TYPE(Text)     CAPTION(Uzavøen)            CPOS(60, 0.2) CLEN( 7)
     TYPE(CHECKBOX) NAME(lUzv)                  FPOS(67, 0.2) FLEN( 7) BGND(13) FONT(5)

     TYPE(STATIC) STYPE(16) CPOS( 1, 0.5) SIZE(118, 0.6 )
     TYPE(GET)     NAME(cCisZakazI)           FPOS(17, 1.7) FLEN( 40) FCAPTION(Položka výr.zakázky) CPOS( 1, 1.7) PP(2) PUSH( ZAKAZKA_VYBER)  NOREVISION()
     TYPE(Text)    NAME(M->cNazevZak1)        CPOS(59, 1.7) CLEN( 40) BGND(13)
     TYPE(GET)     NAME(cVyrPol)              FPOS(17, 2.7) FLEN( 40) FCAPTION(Výrábìná položka) CPOS( 1, 2.7)    PUSH( VYR_VYRPOL_SEL) NOREVISION()
     TYPE(Text)    NAME(M->cNazev)            CPOS(59, 2.7) CLEN( 40) BGND(13)
     TYPE(GET)     NAME(nVarCis)              FPOS(17, 3.7) FLEN( 40) FCAPTION(Varianta položky) CPOS( 1, 3.7)    NOREVISION()
     TYPE(Text)    NAME(VyrPol->cVarPop)      CPOS(59, 3.7) CLEN( 30) BGND(13)
     TYPE(GET)     NAME(cOznOper)             FPOS(17, 4.7) FLEN( 40) FCAPTION(Typová operace) CPOS( 1, 4.7)      NOREVISION()
     TYPE(Text)    NAME(Operace->cNazOper)    CPOS(59, 4.7) CLEN( 30) BGND(13)
     TYPE(GET)     NAME(cOznPrac)             FPOS(17, 5.7) FLEN( 40) FCAPTION(Oznaèení pracovištì) CPOS( 1, 5.7) NOREVISION()
     TYPE(Text)    NAME(C_PRACOV->cNazevPrac) CPOS(59, 5.7) CLEN( 30) BGND(13)

     TYPE(GET)      NAME(nCisOper)             FPOS(17, 7.7) FLEN( 7) FCAPTION(Èíslo operace)     CPOS( 1, 7.7)
     TYPE(GET)      NAME(nUkonOper)            FPOS(17, 8.7) FLEN( 7) FCAPTION(Úkon operace)      CPOS( 1, 8.7)
     TYPE(GET)      NAME(nVarOper)             FPOS(17, 9.7) FLEN( 7) FCAPTION(Varianta operace)  CPOS( 1, 9.7)
     TYPE(GET)      NAME(nCisloKusu)           FPOS(17,10.7) FLEN( 7) FCAPTION(Èíslo kusu)        CPOS( 1,10.7)

     TYPE(GET)      NAME(nKusovCas)            FPOS(38, 7.7) FLEN(13) FCAPTION(Kusový èas)     CPOS(26, 7.7)
     TYPE(GET)      NAME(nPriprCas)            FPOS(38, 8.7) FLEN(13) FCAPTION(Pøípravný èas)  CPOS(26, 8.7)

     TYPE(Text)     CAPTION(Plán)              CPOS(75, 6.7) CLEN( 5) FONT(5)
     TYPE(GET)      NAME(nKusyCelk)            FPOS(65, 7.7) FLEN(13) FCAPTION(Kusy Celkem)    CPOS(53, 7.7)
     TYPE(GET)      NAME(nNhNaOpePl)           FPOS(65, 8.7) FLEN(13) FCAPTION(Nh na operaci)  CPOS(53, 8.7)
     TYPE(GET)      NAME(nNmNaOpePl)           FPOS(65, 9.7) FLEN(13) FCAPTION(Nm na operaci)  CPOS(53, 9.7)
     TYPE(GET)      NAME(nKcNaOpePl)           FPOS(65,10.7) FLEN(13) FCAPTION(Cena celkem)    CPOS(53,10.7)

     TYPE(Text)     CAPTION(Skuteènost)        CPOS(83, 6.7) CLEN( 12) FONT(5)
     TYPE(Text)     NAME(nKusyHotov)           CPOS(80, 7.7) CLEN( 13) BGND(13) CTYPE(2) GROUPS(clrGREY)
     TYPE(Text)     NAME(nNhNaOpeSK)           CPOS(80, 8.7) CLEN( 13) BGND(13) CTYPE(2) GROUPS(clrGREY)
     TYPE(Text)     NAME(nNmNaOpeSK)           CPOS(80, 9.7) CLEN( 13) BGND(13) CTYPE(2) GROUPS(clrGREY)
     TYPE(Text)     NAME(nKcNaOpeSK)           CPOS(80,10.7) CLEN( 13) BGND(13) CTYPE(2) GROUPS(clrGREY)
   TYPE(End)

