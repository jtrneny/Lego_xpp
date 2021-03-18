TYPE(drgForm) DTYPE(10) TITLE(Kalkulace materiálu) SIZE(100,24) FILE(KUSTREE);
              GUILOOK(Action:y,IconBar:y,Menu:n)  ;
                        PRINTFILES(KUSTREE:)
*              POST( POSTVALIDATE)

TYPE(Action) CAPTION(info ~Materiál) EVENT(DETAIL_material) TIPTEXT(Informaèní karta materiálu - ceníku)

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Výrobní zakázka)   CPOS(  1, 0.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.3) CLEN( 30) BGND( 13) FONT(5) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 52, 0.3) CLEN( 46) BGND( 13) FONT(5) PP(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Výrábìná položka ) CPOS(  1, 1.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS( 20, 1.3) CLEN( 30) BGND( 13) FONT(5) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(VyrPol->cNazev)       CPOS( 52, 1.3) CLEN( 30) BGND( 13) FONT(5) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta)          CPOS( 84, 1.3) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS( 93, 1.3) CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 100,19.2) FPOS(0, 3)  RESIZE(yy)

* DLE MJ v TPV
    TYPE(TABPAGE) CAPTION(dle MJ v TPV) OFFSET(1, 80) SIZE( 100,19) PRE( tabSelect)

      TYPE(DBrowse) FILE(KUSTREE) INDEXORD(1);
                   FIELDS( cSklPOL     ,;
                           cNazev:Název materiálu      ,;
                           nSpMnoNas:Spotøební množství,;
                           cMJTpv:MJ_TPV  ,;
                           VYR_CenaCELKEM():Nákupní cena:15:@N 99 999 999.9999,;
                           cTypMat     );
                   SIZE(99, 17.6) FPOS(0.5, 0.3) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)
    TYPE(END)

*   DLE MJ ve skladu
    TYPE(TabPage) TTYPE(4) CAPTION(dle MJ ve skladu) OFFSET(19,62) SIZE( 100,19) PRE( tabSelect)

      TYPE(DBrowse) FILE(KUSTREE) INDEXORD(1);
                   FIELDS( cSklPOL     ,;
                           cNazev:Název materiálu       ,;
                           VYR_Thn_bc2(1):Spotøební množství:18:@N 999 999 999.999999 ,;
                           cZkratJedn:MJ_SKL  ,;
                           VYR_Thn_bc2(2):Nákupní cena:15:@N 99 999 999.9999,;
                           cTypMat     );
                   SIZE(99, 17.6) FPOS(0.5, 0.3) CURSORMODE(3) PP(7) Resize(yn) SCROLL(ny) POPUPMENU(yn)
    TYPE(End)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 99.6,1.7) FPOS(0.2, 22.1)  RESIZE(yy)
*    TYPE(PUSHBUTTON) POS(5,0.4) SIZE( 15,1.1) ;
*                     CAPTION(Detail materiálu) TIPTEXT(Infokarta skladové položky)
    TYPE(Text) CAPTION(Cena celkem :)   CPOS( 58, 0.3) CLEN( 13) FONT(5)
    TYPE(Text) NAME(M->nSumaKALK)       CPOS( 71, 0.3) CLEN( 15) BGND(13) FONT(5) PICTURE( @N 999 999 999.9999) CTYPE(2) GROUPS(clrGREEN)
  TYPE(End)

TYPE(End)