TYPE(drgForm) DTYPE(10) TITLE( Plán školení, vzdìlání a lékaøských prohlídek ...) SIZE(110,25) ;
                                                                                  CARGO(per_pershead_in)


* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(.2,.2) SIZE(110,11.5) FILE(PERSHEAD)                     ;
                                          FIELDS(ctypPohybu:typAkce         , ;
                                                 czkratka:zkrAkce           , ;
                                                 cnazevT_LS:název           , ;
                                                 ddatPL_od:datPL_od:10      , ;
                                                 ddatPL_do:datPL_do:10      , ;  
                                                 czkratk_LS:zkrLékŠkol      , ;
                                                 cnazev_LS:název_LékŠkol    , ;
                                                 codborn_LS:odbornost       , ;
                                                 czkratkaUK:zkrUkoè           ) ;
                                         CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)


* položky
  TYPE(TABPAGE) FPOS(.5,12) SIZE(109.5,12.5) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky plánu personální akce) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(-.3,1) SIZE(109.6,10.6) FILE(PERSITEM)                               ;
                                               FIELDS( ctypAkce:typAkce                   , ; 
                                                 dDatPREDko:datKonání:10                  , ;
                                                 cZkratka                                 , ;
                                                 nperioOpak:perOpak                       , ;
                                                 czkratJedn:za                            , ;
                                                 cPracovnik::30                           , ;
                                                 czkratk_LS:zkr_LékŠk                     , ;
                                                 dDatUskuKo                               , ;
                                                 dDatUkonce                                 ) ;
                                               CURSORMODE(3) INDEXORD(1) PP(7) SCROLL(ny) RESIZE(yy)

  TYPE(END)

* likvidace
  TYPE(TABPAGE) FPOS(.5,12) SIZE(99.5,12.5) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Likvidace úèetního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)

  TYPE(End)

