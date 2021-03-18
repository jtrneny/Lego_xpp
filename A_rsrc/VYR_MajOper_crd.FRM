TYPE(drgForm) DTYPE(2) TITLE(Majetek u operací) SIZE(100, 20) FILE(MajOper) ;
              GUILOOK(Action:n,Message:n,IconBar:y,Menu:n) ;
              POST( PostValidate) CBLOAD( OnLoad)  CBSAVE( OnSave)

*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Majetek operací) EVENT(PolOper_MAJ) TIPTEXT(Poøízení majetku zaevidovaného u operací )

* Operace POLOPER
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(È.operace)          CPOS( 2, 0.2) CLEN( 10)
    TYPE(Text) NAME(POLOPER->nCisOper)     CPOS( 2, 1.2) CLEN( 10) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Úkon)               CPOS(13, 0.2) CLEN(  5)
    TYPE(Text) NAME(POLOPER->nUkonOper)    CPOS(13, 1.2) CLEN( 10) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Varianta)           CPOS(24, 0.2) CLEN(  8)
    TYPE(Text) NAME(POLOPER->nVarOper)     CPOS(24, 1.2) CLEN( 10) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Typová operace)     CPOS(35, 0.2) CLEN( 20)
    TYPE(Text) NAME(POLOPER->cOznOper)     CPOS(35, 1.2) CLEN( 60) BGND(13) FONT(5) GROUPS(clrBLUE)
  TYPE(End)
*
  TYPE(TabPage) CAPTION( Seznam majetkù) FPOS(1, 3) SIZE(98, 16.8) RESIZE(yn) OFFSET(1,82)

    TYPE(Browse) FILE(MajOPER) INDEXORD(2);
                 FIELDS( nInvCis          ,;
                         cDruhMaj         ,;
                         C_MAJ->cTypMaj   ,;
                         C_MAJ->cNazevMaj ,;
                         nMnozMaj         ,;
                         nCasNorMaj       ,;
                         cKodCasMaj       ,;
                         cKodKoeCas       );
                 SIZE(98, 15) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(yn)
  TYPE(End)
*
  TYPE(TabPage) CAPTION(Detail) FPOS( 1, 3) SIZE(98, 16.8) RESIZE(yn) OFFSET(18, 66)
    TYPE(STATIC) FPOS(1, 0.5) SIZE( 96, 2.5) STYPE(13) RESIZE(yx)
      TYPE(Text)     CAPTION(Druh majetku)     CPOS( 2, 0.1) CLEN( 15)
      TYPE(COMBOBOX) NAME(cDruhMaj)            FPOS( 2, 1.1) FLEN( 18)
      TYPE(Text)     CAPTION(Inventární èíslo) CPOS(22, 0.1) CLEN( 12)
      TYPE(GET)      NAME(nInvCis)             FPOS(22, 1.1) FLEN( 10) PUSH(VYR_CMAJ_sel)
      TYPE(Text)     CAPTION(Název majetku)    CPOS(35, 0.1) CLEN( 12)
      TYPE(GET)      NAME(M->cNazevMAJ)    FPOS(35, 1.1) FLEN( 40)
      TYPE(Text)     CAPTION(Typ majetku)      CPOS(78, 0.1) CLEN( 12)
      TYPE(COMBOBOX) NAME(M->cTypMaj)      FPOS(78, 1.1) FLEN( 17) VALUES( :- nezaøazen -,S:Stroj,P:Pøípravek,N:Nástroj,M:Mìøidlo)
    TYPE(End)

    TYPE(GET)      NAME(nMnozMAJ)              FPOS(23, 4) FLEN( 12) FCAPTION(Množství majetku)         CPOS(3, 4)
    TYPE(Text)     NAME( C_Maj->cZkratJEDN)    CPOS(37, 4) CLEN(  5) BGND(13)
    TYPE(Text)     NAME( C_Jednot->cNazJEDNOT) CPOS(42, 4) CLEN( 25) BGND(13)
    TYPE(GET)      NAME(nCasNorMaj)            FPOS(23, 5) FLEN( 12) FCAPTION(Èasová norma použití )    CPOS(3, 5)
    TYPE(COMBOBOX) NAME(cKodCasMaJ)            FPOS(23, 6) FLEN( 13) FCAPTION(Kód pro èasovou normu)    CPOS(3, 6)
    TYPE(COMBOBOX) NAME(cKodKoeCas)            FPOS(23, 7) FLEN( 13) FCAPTION(Kód pro násobení ÈN)      CPOS(3, 7)
    TYPE(GET)      NAME(M->cCelek)         FPOS(23, 9) FLEN( 30) FCAPTION(Oznaèení celku)           CPOS(3, 9)
    TYPE(GET)      NAME(M->cVykres)        FPOS(23,10) FLEN( 30) FCAPTION(Oznaèení výkresu)         CPOS(3,10)
    TYPE(GET)      NAME(M->cVyrCisIM)      FPOS(23,11) FLEN( 30) FCAPTION(Výrobní èíslo majetku)    CPOS(3,11)
  TYPE(End)
TYPE(End)