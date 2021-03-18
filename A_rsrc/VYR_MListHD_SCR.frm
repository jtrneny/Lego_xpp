TYPE(drgForm) DTYPE(10) TITLE(MZDOVÉ LÍSTKY - dle lístkù) FILE(LISTHD);
              SIZE(120,25) GUILOOK(Message:y,Action:y,IconBar:y);
              CARGO(VYR_MListHD_crd) OBDOBI(VYR)  ;
              PRINTFILES(LISTHD:nPorCisLis=nPorCisLis,   ; 
                         LISTIT:nPorCisLis=nPorCisLis    ) 


TYPE(Action) CAPTION(~KontrSaz) EVENT(ctrlKonTarLi) TIPTEXT(Kontrola sazeb tarifù a procent prémií na ML )

* LISTHD ... hlavièky ML
  TYPE(DBrowse) FILE(LISTHD) INDEXORD(1);
                FIELDS( ML_stavZakaz():uzZ:2.6::2 ,;
                        ML_uzavren():uvM:2.6::2   ,;
                        nPorCisLis              ,;
                        cCisZakaz::20           ,;
                        NazevZakaz()::30        ,;
                        cCisZakazI::20          ,;
                        cStred                  ,;
                        cOznPrac                ,;
                        nCisOper::10            ,;
                        cNazOper::25            ,;
                        nRokVytvor:Rok          ,;
                        cText1LHD:Text          ,;
                        nKusyCelk:PoèetKusù     ,;
                        nKusyHotov:HotovéKusy   );
                SIZE(120,14) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)
*      VYRZAK->cNazevZak1::30 ,;

* Základní údaje
  TYPE(TabPage) CAPTION( Základní údaje) FPOS(0, 14.2) SIZE(120,10.5) OFFSET(1,82) RESIZE(yx) PRE(tabSelect)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
      TYPE(Static) STYPE(13) SIZE( 119,10) FPOS(0.5, 0.2) RESIZE(yx) GROUPS(clrGREEN)
*       1.SL
        TYPE(Text)  CAPTION(Výrobní zakázka)   CPOS( 1, 0.5) CLEN( 14)
        TYPE(TEXT)  NAME(cCisZakaz)            CPOS(15, 0.5) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREEN)
*        TYPE(Text)  NAME(VyrZAK->cNazevZak1)   CPOS(31, 0.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Vyrábìná položka)  CPOS( 1, 1.5) CLEN( 14)
        TYPE(TEXT)  NAME(cVyrPol)              CPOS(15, 1.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(cNazev)               CPOS(31, 1.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Èís.operace)       CPOS( 1, 2.5) CLEN( 14)
        TYPE(TEXT)  NAME(nCisOper)             CPOS(15, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Úkon operace)      CPOS( 1, 3.5) CLEN( 14)
        TYPE(TEXT)  NAME(nUkonOper)            CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Varianta operace)  CPOS( 1, 4.5) CLEN( 14)
        TYPE(TEXT)  NAME(nVarOper)             CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Typová operace)    CPOS( 1, 5.5) CLEN( 14)
        TYPE(TEXT)  NAME(cOznOper)             CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(cNazOper)             CPOS(31, 5.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Výr. støedisko)    CPOS( 1, 6.5) CLEN( 14)
        TYPE(TEXT)  NAME(cStred)               CPOS(15, 6.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(C_Stred->cNazStr)     CPOS(31, 6.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Pracovištì)        CPOS( 1, 7.5) CLEN( 14)
        TYPE(TEXT)  NAME(cOznPrac)             CPOS(15, 7.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(C_Pracov->cNazevPrac) CPOS(31, 7.5) CLEN( 30) BGND(13)
*       2.SL
        TYPE(Text)  CAPTION(Kusový èas)           CPOS(63, 0.5) CLEN( 18)
        TYPE(TEXT)  NAME(nKusovCas)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Pøípravný èas)        CPOS(63, 1.5) CLEN( 18)
        TYPE(TEXT)  NAME(nPriprCas)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)

        TYPE(Text)  CAPTION(Plán)        CPOS( 85,2.5) CLEN( 5) FONT(5) GROUPS(clrYELL)
        TYPE(Text)  CAPTION(Skuteènost)  CPOS(101,2.5) CLEN(11) FONT(5) GROUPS(clrYELL)

*        TYPE(Static) STYPE(9) FPOS(63,3) SIZE(52,6) CTYPE(1) RESIZE(XX) TIPTEXT(INFO_plSkut)

        TYPE(Static) STYPE(12) FPOS(63,3) SIZE(52,6) CTYPE(2) RESIZE(XX) GROUPS(clrYELL)
          TYPE(TEXT) CAPTION(Kusy Celkem)    CPOS( 1, 1)
            TYPE(GET)  NAME(nKusyCelk)       FPOS(17, 1) FLEN(13) 
            TYPE(GET)  NAME(nKusyHotov)      FPOS(36, 1) FLEN(13)

          TYPE(TEXT) CAPTION(Nh na operaci)  CPOS( 1, 2)
            TYPE(GET) NAME(nNhNaOpePl)       FPOS(17, 2) FLEN(13)
            TYPE(GET) NAME(nNhNaOpeSK)       FPOS(36, 2) FLEN(13)

          TYPE(TEXT) CAPTION(Nm na operaci)  CPOS( 1, 3)
            TYPE(GET) NAME(nNmNaOpePl)       FPOS(17, 3) FLEN(13)
            TYPE(GET) NAME(nNmNaOpeSK)       FPOS(36, 3) FLEN(13)

          TYPE(TEXT) CAPTION(Cena celkem)    CPOS( 1, 4.5)
            TYPE(GET) NAME(nKcNaOpePl)       FPOS(17, 4.5) FLEN(13)
            TYPE(GET) NAME(nKcNaOpeSK)       FPOS(36, 4.5) FLEN(13)
        TYPE(End)  


 
*        TYPE(Text)  CAPTION(Nh na operaci PLÁN)   CPOS(63, 2.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nNhNaOpePl)              CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*        TYPE(Text)  CAPTION(Nh na operaci SKUT.)  CPOS(63, 3.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nNhNaOpeSK)              CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*        TYPE(Text)  CAPTION(Nm na operaci PLÁN)   CPOS(63, 4.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nNmNaOpePl)              CPOS(82, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*        TYPE(Text)  CAPTION(Nm na operaci SKUT.)  CPOS(63, 5.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nNmNaOpeSK)              CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*        TYPE(Text)  CAPTION(KÈ na operaci PLÁN)   CPOS(63, 6.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nKcNaOpePl)              CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*        TYPE(Text)  CAPTION(KÈ na operaci SKUT.)  CPOS(63, 7.5) CLEN( 18)
*        TYPE(TEXT)  NAME(nKcNaOpeSK)              CPOS(82, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
      TYPE(End)

  TYPE(End)

* LISTIT - plnìní ML
  TYPE(TabPage) CAPTION( Plnìní ML) FPOS(0, 14.2) SIZE(120,10.5) OFFSET(18,66) RESIZE(yx) PRE(tabSelect)

    TYPE(DBrowse) FILE(LISTIT) INDEXORD(1);
                  FIELDS(cobdobi          ,;
                         nOsCisPrac       ,;
                         cPrijPrac::15    ,;
                         cTypListku       ,;
                         nDruhMzdy:Dr.mzdy      ,;
                         dVyhotPlan:Dat.vyh.PL  ,;
                         dVyhotSkut:Dat.vyh.SK  ,;
                         nKusyCelk   ,;
                         nKusyHotov  ,;
                         nNmNaOpeSK  ,;
                         nNhNaOpeSK  ,;
                         nKcNaOpeSK  ,;
                         cStavListk:Stav  );
                 SIZE(120, 9.6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)
  TYPE(End)