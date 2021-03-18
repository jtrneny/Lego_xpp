TYPE(drgForm) DTYPE(10) SIZE(106,18) TITLE(Seznam lékaøských prohlídek ...(výbìr) ...)   ;
              FILE(lekprohl)                                                             ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)  


TYPE(Action) CAPTION(~Nová   lékProhl)  EVENT(per_lekprohl_new)    TIPTEXT(Založení nové lékaøské prohlídky do seznamu ...)
TYPE(Action) CAPTION(~Oprava lékProhl) EVENT(per_lekprohl_modify) TIPTEXT(Oprava údajù lékaøské prohlídky ...)

 TYPE(DBrowse) FPOS(0,0) SIZE(106,9.4) FILE(LekProhl) INDEXORD(1)        ;
               FIELDS( nPoradi:poøLp                                   , ;
                       cZkratka:typLp                                  , ;
                       M->nazev_lekProhl:název lékaøské prohlídky:26.5 , ;
                       nperioOpak:perOpakLp                            , ;
                       czkratJedn:za                                   , ;
                       cnazevLeka:prohlídku provedl lékaø              , ; 
                       dposlLekPr:dne                                  , ;
                       ddalsLekPr:dalšíLp                                )  ;
               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


 TYPE(Static) STYPE(13) SIZE(104,16.5) FPOS(1,9.7) RESIZE(yn) CTYPE(2)

    TYPE(TEXT) CAPTION(Typ lékaøské prohlídky    ...)      CPOS( 2, 1) CLEN(18) 
     TYPE(TEXT) NAME(LekProhl->cZkratka)                   CPOS(23, 1) CLEN(11) BGND(13)
     TYPE(TEXT) NAME(c_LekPro->cNazev)                     CPOS(23, 2) CLEN(30) FONT(5)

     TYPE(Static) STYPE( 2) CAPTION(Lékaøská prohlídka)    SIZE(53, 4.3) FPOS( 1,3) RESIZE(y)

      TYPE(TEXT) CAPTION(Prohlídka dne           ...)      CPOS( 3, 1  ) CLEN(18)
       TYPE(TEXT) NAME(LekProhl->dPoslLekPr)               CPOS(22, 1  ) CLEN(11) BGND(13)

      TYPE(TEXT) CAPTION(Perioda opakování   ...)          CPOS( 3, 2) CLEN(18)
       TYPE(TEXT) NAME(LekProhl->nPerioOpak)               CPOS(22, 2) CLEN( 7) BGND(13)
       TYPE(TEXT) NAME(LekProhl->cZkratJEDN)               CPOS(30, 2) CLEN( 5)

      TYPE(TEXT) CAPTION(Další lékaøská prohlídka ...)     CPOS( 3, 3) CLEN(18)
       TYPE(TEXT) NAME(LekProhl->dDalsLekPr)               CPOS(22, 3) CLEN(11) BGND(13)
     TYPE(End) 

* 1 - základní údaje o LÉKAØI
     TYPE(Static) STYPE( 2)  SIZE(47, 7) FPOS(55, .2) RESIZE(y)
      TYPE(TEXT) CAPTION(Ošetøující lékaø        ...)      CPOS( 3, 1) CLEN(18)
       TYPE(TEXT) NAME(LekProhl->cZkratLeka)               CPOS(21, 1) CLEN(10) BGND(13)
       TYPE(TEXT) NAME(LekProhl->cNazevLeka)               CPOS(32, 1) CLEN(30) 
  
      TYPE(TEXT) CAPTION(Odbornost              ...)       CPOS( 3, 2) CLEN(18)
       TYPE(TEXT) NAME(LekProhl->cOdbornLek)               CPOS(21, 2) CLEN(30) BGND(13)

      TYPE(TEXT) CAPTION(. . . Ordinace . . .)             CPOS( 3, 3.5) CLEN(14) FONT(2)

      TYPE(TEXT) CAPTION(ulice . . .)                      CPOS( 9, 4.5) CLEN( 8)
       TYPE(TEXT) NAME(LekProhl->cUlice)                   CPOS(18, 4.5) CLEN(25) BGND(13)

      TYPE(TEXT) CAPTION(místo . . .)                      CPOS( 9, 5.5) CLEN( 8)
       TYPE(TEXT) NAME(LekProhl->cMisto)                   CPOS(18, 5.5) CLEN(25) BGND(13)

      TYPE(TEXT) CAPTION(psè   . . .)                      CPOS( 9, 6.5) CLEN( 8)
       TYPE(TEXT) NAME(LekProhl->cPsc)                     CPOS(18, 6.5) CLEN( 8) BGND(13)
       TYPE(TEXT) NAME(c_Psc->cMisto)                      CPOS(27, 6.5) CLEN(40) 
     TYPE(End)
  TYPE(End)
