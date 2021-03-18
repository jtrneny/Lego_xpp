TYPE(drgForm) DTYPE(10) TITLE(Výkazy a rozbory) FILE(C_VYKAZY);
              SIZE(110,25) GUILOOK(Message:Y,Action:n,IconBar:Y)

TYPE(DBrowse) FILE(C_VYKAZY) INDEXORD(1) ;
              FIELDS( nVykaz      ,;
                      cNazRadek   ,;
                      cVybKateg:Vybrané kategorie:30 ,;
                      cVybPohyb:Vybrané pohyby:30    ,;
                      ZVI_TypNapoc():Typ nápoètu          ,;
                      cPromRadek                     );
              SIZE(110,18.8) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y)

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Výkazy a rozbory) CPOS( 45, 0.1) CLEN( 20) FONT(5)
    TYPE(COMBOBOX) NAME(M->lDataFilter)      FPOS( 83, 0.1) FLEN( 26) VALUES(1:Výbìrové šetøení SKOTU   ,;
                                                                             2:Výbìrové šetøení PRASAT  );
                                             ITEMSELECTED(comboItemSelected)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(109.6, 4.5) FPOS(0.2, 20.4) RESIZE(yx)
   TYPE(Text) CAPTION(Název øádku      )           CPOS(  2,0.5)   CLEN( 17)
   TYPE(Text) CAPTION(Vybrané kategorie)           CPOS(  2,1.5)   CLEN( 17)
   TYPE(Text) CAPTION(Vybrané pohyby   )           CPOS(  2,2.5)   CLEN( 17)

*   TYPE(Text) NAME(C_VYKAZY->cNazRadek)            CPOS( 20,0.5)   CLEN( 80) BGND(13)
*   TYPE(Text) NAME(C_VYKAZY->cVybKateg)            CPOS( 20,1.5)   CLEN( 80) BGND(13)
*   TYPE(Text) NAME(C_VYKAZY->cVybPohyb)            CPOS( 20,2.5)   CLEN( 80) BGND(13)

   TYPE(Get)  NAME(C_VYKAZY->cNazRadek)            FPOS( 20,0.5)   FLEN( 80) BGND(13)
   TYPE(GET)  NAME(C_VYKAZY->cVybKateg)            FPOS( 20,1.5)   FLEN( 80) BGND(13)
   TYPE(Get)  NAME(C_VYKAZY->cVybPohyb)            FPOS( 20,2.5)   FLEN( 80) BGND(13)

  TYPE(End)

