TYPE(drgForm) DTYPE(10) TITLE(Pøíjmové doklady ke skladové položce - VÝBÌR) SIZE(100,19) FILE(PVPITEM);
               GUILOOK(Action:n,Message:n,IconBar:n,Menu:n)

* Skladová položka
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,0.2) RESIZE(xy)
    TYPE(Text) CAPTION(Sklad)              CPOS( 1, 0.2) CLEN(  6)
    TYPE(Text) NAME(M->cCisSklad)          CPOS( 1, 1.2) CLEN( 10) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název skladu)       CPOS(12, 0.2) CLEN( 25)
    TYPE(Text) NAME(C_Sklady->cNazSklad)   CPOS(12, 1.2) CLEN( 26) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skl. položka)       CPOS(41, 0.2) CLEN( 15)
    TYPE(Text) NAME(M->cSklPol)            CPOS(41, 1.2) CLEN( 17) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název zboží)        CPOS(60, 0.2) CLEN( 25)
    TYPE(Text) NAME(CNAZZBO)               CPOS(60, 1.2) CLEN( 35) BGND(13)  FONT(5) GROUPS(clrGREEN)
  TYPE(End)

  TYPE(DBrowse) FILE(PVPITEM) INDEXORD(3) ;
                FIELDS(nDoklad:Pøíjmový doklad,;
                       cTypPohybu:Pohyb,;
                       C_TypPoh->cNazTypPoh:Název pohybu:30  ,;
                       nMnozPrDod,;
                       cZkratJedn,;
                       nCenaCelk ,;
                       dDatPVP   ,;
                       cSklPol   ,;
                       cNazZbo   ,;
                       nCisFak   ,;
                       nTypPoh   );
                FPOS( 0, 3) SIZE(100,15) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(yy) LFREEZE(1) POPUPMENU(y);
                ITEMSELECTED( RecordSelected)