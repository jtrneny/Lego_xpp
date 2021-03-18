TYPE(drgForm) DTYPE(10) TITLE(Kalkulace mezd) SIZE(100,24) FILE(VYRPOL);
              GUILOOK(Action:y,IconBar:n,Menu:n)

*TYPE(Action) EVENT( SEPARATOR)

TYPE(Action) CAPTION(info ~Položky)     EVENT(DETAIL_1) TIPTEXT(Informaèní karta vyrábìné položky)
*TYPE(Action) ATYPE( 0)
*TYPE(Action) ATYPE( 0)
TYPE(Action) CAPTION(info p~Racovištì)  EVENT(DETAIL_2) TIPTEXT(Informaèní karta pracovištì)
TYPE(Action) CAPTION(info ~Operace)     EVENT(DETAIL_3) TIPTEXT(Informaèní karta operace)

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(99,2.8)    FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)          CPOS( 2, 0.2) CLEN(  8)
    TYPE(Text) NAME(M->cCisZakaz)        CPOS( 2, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS( clrBLUE)
    TYPE(Text) CAPTION(Vyrábìná položka) CPOS(43, 0.2) CLEN( 16)
    TYPE(Text) NAME(M->cVyrPOL)          CPOS(43, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS( clrBLUE)
    TYPE(Text) CAPTION(Název položky)    CPOS(64, 0.2) CLEN( 25)
    TYPE(Text) NAME(M->cNazev)           CPOS(64, 1.2) CLEN( 28) BGND(13) FONT(5) GROUPS( clrBLUE)
    TYPE(Text) CAPTION(Var.)             CPOS(93, 0.2) CLEN(  5)
    TYPE(Text) NAME(M->nVarCis)          CPOS(93, 1.2) CLEN(  5) BGND(13) FONT(5) GROUPS( clrBLUE)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 100,19.2) FPOS(0, 3)  RESIZE(yy)

*   DLE POLOŽEK
    TYPE(TABPAGE) CAPTION(dle POLOŽEK) OFFSET(1, 80) PRE( tabSelect)

      TYPE(Browse) FILE(KUSTREE) INDEXORD(1);
                   FIELDS( cVyrPol     ,;
                           nVarCis     ,;
                           nVyrSt      ,;
                           VYR_TypPOL():Typ pol.,;
                           nPriprCas   ,;
                           nPriprKc    ,;
                           nKusovCas   ,;
                           nKusovKc    );
                   SIZE(99, 17.8) FPOS(0.5, 0.3) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)
    TYPE(END)

*   DLE PRACOVIŠ
    TYPE(TabPage) TTYPE(4) CAPTION(dle PRACOVIŠ) OFFSET(19,62)  PRE( tabSelect)

      TYPE(Browse) FILE(KALKMZD) INDEXORD(1);
                   FIELDS( cOznPrac    ,;
                           C_Pracov->cNazevPrac ,;
                           nPriprCas   ,;
                           nPriprKc    ,;
                           nKusovCas   ,;
                           nKusovKc    );
                   SIZE(99, 17.8) FPOS(0.5, 0.3) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)
    TYPE(End)

*   DLE OPERACÍ
    TYPE(TabPage) TTYPE(4) CAPTION(dle OPERACÍ) OFFSET(37,43)  PRE( tabSelect)

      TYPE(Browse) FILE(KALKMZD) INDEXORD(1);
                   FIELDS( cVyrPol    ,;
                           cOznOper   ,;
                           Operace->cNazOper::13,;
                           nPriprCas   ,;
                           nPriprKc    ,;
                           nKusovCas   ,;
                           nKusovKc    );
                   SIZE(99, 17.8) FPOS(0.5, 0.3) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)
*      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)
  TYPE(End)

*
  TYPE(Static) STYPE(13) SIZE( 99.6,1.7) FPOS(0.2, 22.1)  RESIZE(yy)
    TYPE(Text) CAPTION(Nm celkem :)   CPOS( 28, 0.3) CLEN( 13) FONT(2)
    TYPE(Text) NAME(M->nCas)          CPOS( 41, 0.3) CLEN( 15) BGND(13) FONT(5) PP(1) PICTURE( @N 999 999 999.9999) CTYPE(2)
    TYPE(Text) CAPTION(Cena celkem :) CPOS( 58, 0.3) CLEN( 13) FONT(2)
    TYPE(Text) NAME(M->nKc)           CPOS( 71, 0.3) CLEN( 15) BGND(13) FONT(5) PP(3) PICTURE( @N 999 999 999.9999) CTYPE(2)
  TYPE(End)

TYPE(End)