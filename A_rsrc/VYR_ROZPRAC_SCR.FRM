TYPE(drgForm) DTYPE(10) TITLE(PØEHLED nedokonèené výroby) SIZE(100,25);
                        GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar) 

  TYPE(Action) CAPTION(info ~Zakázka)   EVENT(VYR_VYRZAK_INFO)         TIPTEXT(Informaèní karta vyrobní zakázky )
  TYPE(Action) CAPTION(kontr ~SKLnákl)  EVENT(VYR_ROZPRAC_CTRL_SK_SCR) TIPTEXT(Kontrola materiálových nákladù )
  TYPE(Action) CAPTION(kontr ~MZDnákl)  EVENT(VYR_ROZPRAC_CTRL_MZ_SCR) TIPTEXT(Kontrola mzdových nákladù )

  TYPE(DBrowse) SIZE(100,24.9) FILE(ROZPRAC) INDEXORD(1) ;
               FIELDS( nROK,;
                       nObdobi,;
                       cCisZakaZ,;
                       nSkPrMatZ,;
                       nSkPrMzdZ,;
                       nSkPrKooZ,;
                       nSkRezieZ) ;
               CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) SCROLL(ny) POPUPMENU(yy)

* TYPE(Static) STYPE(13) SIZE(98, 3) FPOS(1,21.7) RESIZE(yx)
*   TYPE(Text) CAPTION(Nákupní cena)       CPOS(  2, .5) CLEN( 13)
*   TYPE(Text) NAME(CENZBOZ->nCenaNZBO)    CPOS(  2,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*   TYPE(Text) CAPTION(Cena bez danì)      CPOS( 15, .5) CLEN( 13)
*   TYPE(Text) NAME(CENZBOZ->nCenaPZBO)    CPOS( 15,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*   TYPE(Text) CAPTION(Cena s daní)        CPOS( 28, .5) CLEN( 13)
*   TYPE(Text) NAME(CENZBOZ->nCenaMZBO)    CPOS( 28,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*
*   TYPE(Text) CAPTION(Prodejní cena 1)    CPOS( 43, .5) CLEN( 13)
*   TYPE(Text) NAME(CENPRODC->nCenaP1ZBO)  CPOS( 43,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*   TYPE(Text) CAPTION(Prodejní cena 2)    CPOS( 57, .5) CLEN( 13)
*   TYPE(Text) NAME(CENPRODC->nCenaP2ZBO)  CPOS( 57,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*   TYPE(Text) CAPTION(Prodejní cena 3)    CPOS( 71, .5) CLEN( 13)
*   TYPE(Text) NAME(CENPRODC->nCenaP3ZBO)  CPOS( 71,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)
*   TYPE(Text) CAPTION(Prodejní cena 4)    CPOS( 85, .5) CLEN( 12)
*   TYPE(Text) NAME(CENPRODC->nCenaP4ZBO)  CPOS( 85,1.5) CLEN( 11) BGND(13) FONT(5) CTYPE(2)

* TYPE(End)