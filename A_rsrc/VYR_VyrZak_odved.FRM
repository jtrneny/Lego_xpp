TYPE(drgForm) DTYPE(10) TITLE(Odvedení zakázky) SIZE(120, 20);
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:y);
               POST( PostValidate)

TYPE(Action) CAPTION(info ~Zakázky) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky )

* VÝROBNÍ ZAKÁZKA
  TYPE(Static) STYPE(12) SIZE(119,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS(  2, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZAK->cCisZakaz)     CPOS(  2, 1.2) CLEN( 40) BGND(13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Název zakázky)      CPOS( 43, 0.2) CLEN( 25) FONT(2)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)    CPOS( 43, 1.2) CLEN( 40) BGND(13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Stav)               CPOS( 84, 0.2) CLEN(  6) FONT(2)
    TYPE(Text) NAME(VyrZAK->cStavZakaz)    CPOS( 84, 1.2) CLEN(  6) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION(Vyrábìná položka)   CPOS( 92, 0.2) CLEN( 16) FONT(2)
    TYPE(Text) NAME(VyrZAK->cVyrPOL)       CPOS( 92, 1.2) CLEN( 20) BGND(13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Var.)               CPOS(113, 0.2) CLEN(  5) FONT(2)
    TYPE(Text) NAME(VyrZAK->nVarCis)       CPOS(113, 1.2) CLEN(  5) BGND(13) FONT(5) CTYPE(2)
  TYPE(End)

* ODVEDENÍ zakázky z výroby
  TYPE(Browse) FILE(ODVZAK) INDEXORD(1);
               FIELDS( nMnozOdved  ,;
                       dDatumOdv   ,;
                       nCisloKusu  ,;
                       cVyrobCisl  ,;
                       cText       ,;
                       cStavZakaz:SZ:4  );
              FPOS( 0, 3) SIZE(120, 10.5) CURSORMODE(3) PP(7) Resize(yx) SCROLL(ny) POPUPMENU(yn);
              ITEMMARKED( ItemMarked)

  TYPE(Static) STYPE(2) SIZE(120, 3) FPOS(0,13.2)  RESIZE(yx)
    TYPE(GET)  NAME(ODVZAK->nMnozOdved)     FPOS(  1 ,1.8) FLEN(10) FCAPTION(Mn.odvedené)         CPOS( 1,0.8)
    TYPE(GET)  NAME(ODVZAK->dDatumOdv)      FPOS( 13 ,1.8) FLEN(12) FCAPTION(Dat.odvedení)        CPOS(13,0.8) PUSH(CLICKDATE)
    TYPE(GET)  NAME(ODVZAK->nCisloKusu)     FPOS( 27 ,1.8) FLEN( 6) FCAPTION(Èís.kusu)            CPOS(27,0.8)
    TYPE(GET)  NAME(ODVZAK->cVyrobCisl)     FPOS( 35 ,1.8) FLEN(40) FCAPTION(Výrobní èíslo)       CPOS(35,0.8)
    TYPE(GET)  NAME(ODVZAK->cText)          FPOS( 77 ,1.8) FLEN(40) FCAPTION(Text)                CPOS(77,0.8) POST( PostLastField)
  TYPE(End)
*  TYPE(Text) NAME( ODVZAK->nMnozOdved) CPOS( 1, 13.7) CLEN( 12)  BGND(13) FONT(5)

* INFO množství
  TYPE(Static) STYPE(12) SIZE(119.8,3.2) FPOS(0.1,16.7) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(MNOŽSTVÍ)       CPOS( 21, 1.3) CLEN( 10) FONT(2)
    TYPE(Text) CAPTION(Odvedeno CELKEM) CPOS( 1, 0.3) CLEN( 14)
    TYPE(Text) CAPTION(Plánované)      CPOS( 39, 0.3) CLEN( 12)
    TYPE(Text) CAPTION(Zadané do výr.) CPOS( 52, 0.3) CLEN( 12)
    TYPE(Text) CAPTION(Vyrobené)       CPOS( 73, 0.3) CLEN( 10)
    TYPE(Text) CAPTION(K vyrobení)     CPOS( 90, 0.3) CLEN( 10)
    TYPE(Text) CAPTION(Fakturované)    CPOS(105, 0.3) CLEN( 10)

    TYPE(Text) NAME( M->nCelkOdved)      CPOS(  1, 1.3) CLEN( 14) CTYPE(2) BGND(12) PP(3) FONT(5)
    TYPE(Text) NAME( VyrZAK->nMnozPlano) CPOS( 32, 1.3) CLEN( 15) CTYPE(2) BGND(13) FONT(5)
    TYPE(Text) NAME( VyrZAK->nMnozZadan) CPOS( 49, 1.3) CLEN( 15) CTYPE(2) BGND(13) FONT(5)
    TYPE(Text) NAME( VyrZAK->nMnozVyrob) CPOS( 66, 1.3) CLEN( 15) CTYPE(2) BGND(13) FONT(5)
    TYPE(Text) NAME( M->nKVyrobeni)      CPOS( 83, 1.3) CLEN( 15) CTYPE(2) BGND(13) FONT(5)
    TYPE(Text) NAME( VyrZAK->nMnozFakt)  CPOS(100, 1.3) CLEN( 15) CTYPE(2) BGND(13) FONT(5)
  TYPE(End)