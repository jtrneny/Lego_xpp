TYPE(drgForm) DTYPE(10) TITLE(Režijní náklady na položku) FILE(FIXNAKL);
              SIZE(90,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              CARGO(VYR_FixNakl_crd)

*TYPE(Action) CAPTION(~Detail položky) EVENT(VYR_VYRPOL_DET) TIPTEXT(Detail vyrábìné položky)
*TYPE(Action) CAPTION(~Kalkulace THN)  EVENT(VYR_KALK_THN)   TIPTEXT(Kalkulace materiálu )
*TYPE(Action) CAPTION(~Kalkulace MEZD) EVENT(VYR_KALK_MZD)   TIPTEXT(Kalkulace mezd )

TYPE(DBrowse) FILE(FIXNAKL) INDEXORD(1) ;
              FIELDS( cNazPOL1,;
                      cNazPol1->cNazev,;
                      cNazPOL2,;
                      cNazPol2->cNazev,;
                      nRokVyp,;
                      nObdMes) ;
              SIZE(90,18.7) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE(88,6.1) RESIZE(yx) FPOS(1,18.8)

*   1.øádek
    TYPE(Text) CAPTION(R E Ž I E)    CPOS( 15, 0.2)   CLEN( 15) FONT(5)

    TYPE(Text) CAPTION(Vypoètená)    CPOS( 33, 0.2)   CLEN( 12) FONT(2) CTYPE(2)
    TYPE(Text) CAPTION(Nastavená)    CPOS( 52, 0.2)   CLEN( 12) FONT(2) CTYPE(2)

*    TYPE(Text) CAPTION(Odbytová)     CPOS( 18, 1.8)   CLEN( 15) FONT(2)
*    TYPE(Text) CAPTION(Výrobní)      CPOS( 18, 2.8)   CLEN( 15) FONT(2)
*    TYPE(Text) CAPTION(Zásobovací)   CPOS( 18, 3.8)   CLEN( 15) FONT(2)
*    TYPE(Text) CAPTION(Správní)      CPOS( 18, 4.8)   CLEN( 15) FONT(2)

    TYPE(Text) NAME(M->cNazRezie1) CPOS( 15, 1.8)   CLEN( 18) FONT(2)
    TYPE(Text) NAME(M->cNazRezie2) CPOS( 15, 2.8)   CLEN( 15) FONT(2)
    TYPE(Text) NAME(M->cNazRezie3) CPOS( 15, 3.8)   CLEN( 15) FONT(2)
    TYPE(Text) NAME(M->cNazRezie4) CPOS( 15, 4.8)   CLEN( 15) FONT(2)


    TYPE(Text) NAME(nOdbytReVy)      CPOS( 33, 1.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 46, 1.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nVyrobReVy)      CPOS( 33, 2.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 46, 2.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nZasobReVy)      CPOS( 33, 3.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 46, 3.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nSpravReVy)      CPOS( 33, 4.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 46, 4.8)   CLEN(  3) FONT(2)

    TYPE(Text) NAME(nOdbytReNa)      CPOS( 52, 1.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 65, 1.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nVyrobReNa)      CPOS( 52, 2.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 65, 2.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nZasobReNa)      CPOS( 52, 3.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 65, 3.8)   CLEN(  3) FONT(2)
    TYPE(Text) NAME(nSpravReNa)      CPOS( 52, 4.8)   CLEN( 12) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) CAPTION( %)           CPOS( 65, 4.8)   CLEN(  3) FONT(2)

  TYPE(End)

TYPE(End)