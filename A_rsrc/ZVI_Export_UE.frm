TYPE(drgForm) DTYPE(10) TITLE(Export do ústøední evidence ) ;
              SIZE( 75, 9) GUILOOK(Action:y,IconBar:n,Menu:n) ;
              POST( PostValidate)

TYPE(Action) CAPTION(~Kontrolní opis) EVENT(OpisTxt)  TIPTEXT(Kontrolní opis exportovaného souboru )
TYPE(Action) CAPTION(~Hlášení zmìn)   EVENT(RegHlZme) TIPTEXT(Hlášení zmìn )

  TYPE(Static) STYPE(12) SIZE(74.8, 8.8) FPOS( 0.1, 0.1) RESIZE(yx)
    TYPE(Text) NAME(m->cAction)              CPOS( 4, 0.3)   CLEN( 35)  FONT(5)

* Export SKOTU
    TYPE(Static) FPOS( 4,1.5) SIZE(65,3) STYPE(2) CAPTION() RESIZE(xx)          GROUPS(S)
      TYPE(RadioButton) NAME( M->nPrenos ) FPOS(1,1) SIZE(16,3) ;
        VALUES( 1:Pøenos za období, 2:Poèáteèní stavy ) ItemSelected( Selected) GROUPS(S)


     TYPE(GET)  NAME(M->dDatumOD)   FPOS(27, 1) FLEN( 12) FCAPTION( od:)      CPOS( 22, 1) PUSH( CLICKDATE) GROUPS(S)
     TYPE(GET)  NAME(M->dDatumDO)   FPOS(47, 1) FLEN( 12) FCAPTION( do:)      CPOS( 42, 1) PUSH( CLICKDATE) GROUPS(S)
     TYPE(GET)  NAME(M->dDatumPS)   FPOS(27, 2) FLEN( 12) FCAPTION( ke dni:)  CPOS( 20, 2) PUSH( CLICKDATE) GROUPS(S)
    TYPE(END)

* Export PRASAT
    TYPE(Static) FPOS( 4,1.5) SIZE(65,3) STYPE(2) CAPTION() RESIZE(xx)          GROUPS(V)
      TYPE(CHECKBOX) NAME( M->lAktReg)       FPOS( 1, 1)   FLEN(40) ;
         VALUES(T:aktualizovat stájový registr prasat za aktuální období,;
                F:aktualizovat stájový registr prasat za aktuální období)       GROUPS(V)
      TYPE(Text) NAME(m->cObdobi)            CPOS( 42, 1)   CLEN( 10)  FONT(5)  GROUPS(V)
    TYPE(END)


    TYPE(PushButton) POS(5, 7) SIZE(15,1.2) CAPTION(~Pøenos spustit )  EVENT(Start_prenos)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(23, 7) SIZE(15,1.2) CAPTION(~Storno pøenosu ) EVENT(140000002)            ICON1(102) ICON2(202) ATYPE(3)
*    TYPE(PushButton) POS(53, 7) SIZE(15,1.2) CAPTION(~Kontrolní opis ) EVENT(OpisTXT)              ICON1(603) ICON2(603) ATYPE(3) GROUPS(V)

  TYPE(END)