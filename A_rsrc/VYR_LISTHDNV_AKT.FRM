TYPE(drgForm) DTYPE(10) TITLE(VÝPOÈET nedokonèené výroby DLE OPERACÍ) SIZE(120,25) FILE( ListHDNV);
                        GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

  TYPE(Action) CAPTION(info ~Zakázka)   EVENT()               TIPTEXT(Informaèní karta vyrobní zakázky )
  TYPE(Action) CAPTION( ~Výpoèet ned.)  EVENT(btn_RozpracCmp) TIPTEXT(Výpoèet nedokonèené výroby dle operací )

  TYPE(DBrowse) SIZE(120,21) FILE(ListHDNV) INDEXORD(1) ;
                FIELDS( dDatumNV    ,;
                        cCisZakaz   ,;
                        cVyrPol     ,;
                        nCisOper    ,;
                        nMnozNV     ,;
                        nMaterNV    ,;
                        nMzdyNV     ,;
                        nKooperNV   );
                CURSORMODE(3) ITEMMARKED(ItemMarked) PP(7) POPUPMENU(y)

 TYPE(Static) STYPE(13) SIZE(119.6, 3.7) FPOS(0.2,21.1) RESIZE(yx)
*   TYPE(Text) CAPTION(Stav ke dni)          CPOS( 2,  .2) CLEN( 12)
*   TYPE(Text) NAME(ROZPRAC->dDatZprac)      CPOS( 2, 1.2) CLEN( 10) BGND(13) FONT(7) CTYPE(2)
*
*   TYPE(Text) CAPTION(Pøímý materiál)       CPOS( 34,  .2) CLEN( 12)
*   TYPE(Text) CAPTION(Pøímé mzdy)           CPOS( 53,  .2) CLEN( 10)
*   TYPE(Text) CAPTION(Kooperace)            CPOS( 71,  .2) CLEN( 10)
*   TYPE(Text) CAPTION(Výrobní režie)        CPOS( 86,  .2) CLEN( 10)
*   TYPE(Text) CAPTION(PLÁN )                CPOS( 15, 1.2) CLEN( 12) FONT(7)
*   TYPE(Text) CAPTION(SKUTEÈNOST )          CPOS( 15, 2.2) CLEN( 14) FONT(7)

*   TYPE(Text) NAME(ROZPRAC->nPlPrMatZ)      CPOS( 30, 1.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nPlPrMzdZ)      CPOS( 47, 1.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nPlPrKooZ)      CPOS( 64, 1.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nPlRezieZ)      CPOS( 81, 1.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)

*   TYPE(Text) NAME(ROZPRAC->nSkPrMatZ)      CPOS( 30, 2.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nSkPrMzdZ)      CPOS( 47, 2.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nSkPrKooZ)      CPOS( 64, 2.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)
*   TYPE(Text) NAME(ROZPRAC->nSkRezieZ)      CPOS( 81, 2.2) CLEN( 15) BGND(13) FONT(7) CTYPE(2)

 TYPE(End)