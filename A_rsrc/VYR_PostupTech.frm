TYPE(drgForm) DTYPE(10) TITLE(Technologický postup ELS ...) SIZE(120,26) FILE(PolOper_w1) BORDER(2) ;
                        GUILOOK(Action:y,IconBar:y,Menu:n)

TYPE(Action) CAPTION(info ~Zakázka)  EVENT( VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(info ~Operace)   EVENT( VYR_POLOPER_INFO) TIPTEXT(Informaèní karta operace k vyrábìné položce )
TYPE(Action) CAPTION(info ~Typ.oper.) EVENT( VYR_OPERACE_INFO) TIPTEXT(Informaèní karta typové operace)

* HLA
  TYPE(Static) STYPE(13) SIZE(120,2.6) FPOS(0, 0) RESIZE(yn)

    TYPE(Text) CAPTION(Pro CELEK )        CPOS(  1, 0.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cVarPop)      CPOS( 20, 0.2) CLEN( 50) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Kalk. jednice)     CPOS( 72, 0.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS( 88, 0.2) CLEN( 25) BGND( 13) FONT(5) GROUPS(clrGREEN)

    TYPE(Text) CAPTION(Název výrobku)     CPOS(  1, 1.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cNazev)       CPOS( 20, 1.2) CLEN( 50) BGND( 13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Èíslo výkresu)     CPOS( 72, 1.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS( 88, 1.2) CLEN( 25) BGND( 13) PP(2) CTYPE(2)

  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(118.5,12.2) FPOS(0.2, 2.7) RESIZE(yn)
  TYPE(DBrowse) FILE(PolOper_W1) INDEXORD(1) ;
                FIELDS( nCisOper:È.oper.  ,;
                        nUkonOper,;
                        cOznOper:Typová operace:25 ,;
                        cOznPrac ,;
                        cStred   ,;
                        cTarifTrid:Tar.tø. ,;
                        nCelkKusCa:Kusový èas:18:999 999.9999 ,;
                        nKcNaOper:Cena operace ,;
                        nVykon_cmp::19 );
                 RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7) ;
                 ITEMMARKED( ItemMarked)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 119, 11) FPOS( 0.5, 15) RESIZE(yy)
    TYPE(Static) STYPE( 9) SIZE(119,  1.2) FPOS(0.5, 0) RESIZE(yn)
      TYPE(Text)   CAPTION(POPIS OPERACE)     CPOS( 1, 0.1) CLEN( 119) FONT(2) CTYPE(3)
    TYPE(End)
    TYPE(MLE)  NAME('mPolOper') FPOS(0.2, 1) SIZE(119,9.9) RESIZE(yy)
  TYPE(End)