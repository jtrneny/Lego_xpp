TYPE(drgForm) DTYPE(10) TITLE(FAKTURACE výrobní zakázky) FILE(VYRZAK);
              SIZE(100,20) GUILOOK(Action:n,IconBar:y)

* Výrobní zakázka
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)          CPOS( 2, 0.2) CLEN(  8) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cCisZakaz)   CPOS( 2, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Název zakázky)    CPOS(44, 0.2) CLEN( 15) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cNazevZak1)  CPOS(44, 1.2) CLEN( 45) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Stav)             CPOS(91, 0.2) CLEN(  6) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cStavZakaz)  CPOS(91, 1.2) CLEN(  4) BGND(13) FONT(5) GROUPS(clrBLUE)
  TYPE(End)

  TYPE(Static) STYPE(12) SIZE(99,1.2) FPOS(0.5,3) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION( Faktury vystavené - bìžné)   CPOS( 0.5,0.1) CLEN( 98) FONT(5) CTYPE(1)
  TYPE(End)

  TYPE(DBrowse) FILE(FakVysIT) INDEXORD(10);
                FIELDS( nCisFak:È.faktury         ,;
                        nIntCount:Poø.            ,;
                        FakVysHD->dVystFak        ,;
                        cNazZbo:Název zboží:25    ,;
                        nFaktMnoz:Fakt.mn.        ,;
                        cZkratJedn:MJ  ,;
                        nCenZakCel     ,;
                        nCenZahCel     ,;
                        FakVysHD->cZkratMenZ:Zahr.mìna     ,;
                        FakVysHD->nKurZahMen:Kurz zahr.mìny );
                SIZE(99.8,15) FPOS(0.1, 4.3) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yy) FOOTER(Y)

