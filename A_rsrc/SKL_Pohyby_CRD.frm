TYPE(drgForm) DTYPE(20) TITLE(Pøehled pohybových dokladù) SIZE(120,25) FILE( PVPHEAD);
                       GUILOOK(Message:Y,Action:y,IconBar:y);
                       PRE(preValidate) POST(postValidate)  ;
                       CBLOAD( ONLOAD) CBSAVE( ONSAVE)      ;
                       PRINTFILES(pvphead:ndoklad=ndoklad,  ;
                                  pvpitem:ndoklad=ndoklad,  ;
                                  ucetpol:cdenik=cdenik+ndoklad=ncisfak)

TYPE(Action) CAPTION(~Likvidace)     EVENT( LikvDokl)          TIPTEXT(Zaúètování skladového dokladu ( položky dokladu ))
TYPE(Action) CAPTION(~Výrobní èísla) EVENT( VYRCIS_PVP)        TIPTEXT(Výrobní èísla)
TYPE(Action) CAPTION(info C~eník)    EVENT( SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)

***************** Hlavièky dokladù
  TYPE(TabPage) CAPTION(Doklady) FPOS( 0, 0.2) SIZE(119.8,13.5) RESIZE(yn) OFFSET(1,84) TABHEIGHT( 1.2) PRE(TabHD)

    TYPE(dBrowse) FILE(PVPHEAD) INDEXORD(1) ;
                  FIELDS( NDOKLAD,DDATPVP ) ;
                  SIZE(26,10.5) FPOS( 0.5,1.5) CURSORMODE(3) SCROLL(ny) RESIZE(xx) PP(7) POPUPMENU(y);
                  ITEMMARKED( ItemMarked) ATSTART(LAST)


** Panel klíèových údajù ( Doklad, Sklad, Pohyb )
    TYPE(Static) STYPE(12) SIZE(119.8,1.3) FPOS(0,0.1) RESIZE(yx)
*     TYPE(Text) CAPTION( Doklad :)  CPOS(  1,0.1) CLEN(  8) PP(1)
*     TYPE(Text) NAME(M->nDoklad)    CPOS(  8,0.1) CLEN( 12) PP(1) FONT( 5) CTYPE(2)

     TYPE(PushButton) POS(21,0.1)   SIZE(6,1) CAPTION(~Sklad) EVENT(Vyber_SKLAD) TIPTEXT(Výbìr aktuálního skladu )
     TYPE(Text) NAME( M->cSKLAD)    CPOS( 28,0.1) CLEN(  8) BGND(13) FONT( 5) PP(2)
     TYPE(Text) NAME( M->cNazSklad) CPOS( 36,0.1) CLEN( 25) BGND(13) FONT( 5) PP(2) CTYPE(1)

     TYPE(PushButton) POS(62,0.1)   SIZE(6,1) CAPTION(~Pohyb) EVENT(Vyber_POHYB) TIPTEXT(Výbìr druhu pohybových dokladù )
     TYPE(Text) NAME( M->nPohyb)    CPOS( 69,0.1) CLEN(  7) BGND(13) FONT( 5) PP(2)
     TYPE(Text) NAME( M->cNazPohyb) CPOS( 76,0.1) CLEN( 23) BGND(13) FONT( 5) PP(2) CTYPE(1)
    TYPE(END)

** Panel HLA karty
    TYPE(Static) STYPE(11) SIZE(93, 10.5) FPOS(26.5,1.5) RESIZE(yx)

*   Spoleèné údaje HLA
    TYPE(Static) STYPE(13) SIZE(93,2.4) FPOS(0,0) RESIZE(yx)
      TYPE(GET)  NAME(nDOKLAD)  FPOS(  1,1.2) FLEN(12) FCAPTION( Doklad) CPOS(  1,0.2) FONT(5) PP(2)
      TYPE(GET)  NAME(dDatPVP)  FPOS( 15,1.2) FLEN(12) FCAPTION( Datum)  CPOS( 15,0.2) PUSH( ClickDATE) POST( LastFieldHD)
      TYPE(GET)  NAME(cObdobi)  FPOS( 31,1.2) FLEN( 7) FCAPTION( Období) CPOS( 31,0.2) PP(1)
*      TYPE(Text) NAME(cObdobi)  CPOS( 31,1.2) CLEN( 10) BGND( 13) PP(1)
    TYPE(END)

*   Karta HLA 0
    TYPE(Static) STYPE(13) SIZE(93, 8) FPOS(0,2.5)  RESIZE(xy) GROUPS(0A)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                           GROUPS(0A)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)  GROUPS(0A)
    TYPE(END) GROUPS(0A)

*   Karta HLA 10
    TYPE(Static) STYPE(13) SIZE(93, 8) FPOS(0,2.5)  RESIZE(xy) GROUPS(10)
      TYPE(GET)  NAME(cCisZakaz)              FPOS(  1,1.2) FLEN( 28) FCAPTION( Zakázka) CPOS(  1,0.2) CLEN( 10) GROUPS(10) PUSH(SKL_VYRZAK_SEL) POST( LastFieldHD)
      TYPE(Text) NAME(VyrZAK->cNazevZak1)     CPOS( 31,1.2) CLEN( 40) BGND( 13) PP(1)                            GROUPS(10)
    TYPE(END)

*   Karta HLA 1  AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5) RESIZE(yx) GROUPS(01)
      TYPE(GET)  NAME(nCisFirmy)              FPOS(  1,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS(  1,0.2) CLEN( 10) GROUPS(01) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(01)
**      TYPE(Text) NAME(Firmy->cNazev)          CPOS( 11,1.2) CLEN( 50) BGND( 13) PP(1)                             GROUPS(01)
      TYPE(GET)  NAME(cCislObInt)             FPOS(  1,3.2) FLEN( 35) FCAPTION( Objednávka)        CPOS(  1,2.2) GROUPS(01)
      TYPE(GET)  NAME(cVarSym)                FPOS( 38,3.2) FLEN( 15) FCAPTION( Variabilní symbol) CPOS( 38,2.2) GROUPS(01)
      TYPE(GET)  NAME(nCisFak)                FPOS( 55,3.2) FLEN( 10) FCAPTION( Faktura)           CPOS( 55,2.2)  GROUPS(01)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 67,3.2) FLEN( 10) FCAPTION( Dodací list)       CPOS( 67,2.2)  GROUPS(01)

      TYPE(GET)  NAME(nCenaDokl)              FPOS(  1,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 1,4.2) CLEN(13)  GROUPS(01)
      TYPE(Text) CAPTION(+)                   CPOS( 13,5.2) CLEN(  2) PP(1)  GROUPS(01)
      TYPE(GET)  NAME(nNutneVN)               FPOS( 15,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 15,4.2) GROUPS(01) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                   CPOS( 27,5.2) CLEN(  2) PP(1)  GROUPS(01)
      TYPE(Text) CAPTION(Suma položek)        CPOS( 29,4.2) CLEN( 11) PP(1)  GROUPS(01)
      TYPE(Text) NAME(M->nCelkDokl)           CPOS( 29,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(01)
      TYPE(Text) CAPTION(=)                   CPOS( 44,5.2) CLEN(  2) PP(1)   GROUPS(01)
      TYPE(Text) CAPTION(Kontrolní rozdíl)    CPOS( 47,4.2) CLEN( 14) PP(1)   GROUPS(01)
      TYPE(Text) NAME(nRozPrij)               CPOS( 47,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(01)
    TYPE(END)  GROUPS(01)

*   Karta HLA 1_1  Pøíjem v zahr. mìnì - s vazbou na dodavatele
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5) RESIZE(yx) GROUPS(11)
      TYPE(GET)  NAME(nCisFirmy)              FPOS(  1,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS(  1,0.2) CLEN( 10) GROUPS(11) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(11)
      TYPE(GET)  NAME(cCislObInt)             FPOS(  1,3.2) FLEN( 35) FCAPTION( Objednávka)        CPOS(  1,2.2) GROUPS(11)
      TYPE(GET)  NAME(cVarSym)                FPOS( 38,3.2) FLEN( 15) FCAPTION( Variabilní symbol) CPOS( 38,2.2) GROUPS(11)
      TYPE(GET)  NAME(nCisFak)                FPOS( 55,3.2) FLEN( 10) FCAPTION( Faktura)           CPOS( 55,2.2) GROUPS(11)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 67,3.2) FLEN( 10) FCAPTION( Dodací list)       CPOS( 67,2.2) GROUPS(11)

      TYPE(GET)  NAME(cZahrMena)              FPOS(  1,5.2) FLEN(  8) FCAPTION( Zahr. mìna)       CPOS(  1, 4.2) CLEN(10)  GROUPS(11)
      TYPE(GET)  NAME(nKurZahMen)             FPOS( 11,5.2) FLEN( 12) FCAPTION( Kurz zahr.mìny)   CPOS( 11, 4.2) GROUPS(11)
      TYPE(GET)  NAME(nMnozPrep)              FPOS( 25,5.2) FLEN(  7) FCAPTION( Mn.pøep.)        CPOS( 25, 4.2) GROUPS(11)
      TYPE(GET)  NAME(nCenDokZM)              FPOS( 34,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 34, 4.2) CLEN(13)  GROUPS(11)
      TYPE(GET)  NAME(nNutneVNZM)             FPOS( 48,5.2) FLEN( 11) FCAPTION( Nutné VN)        CPOS( 48, 4.2)           GROUPS(11) POST( LastFieldHD)
      TYPE(Text) NAME(M->nCelkDoklZM)         CPOS( 62,5.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1)         GROUPS(11)
      TYPE(Text) NAME(M->nRozPrijZM)          CPOS( 76,5.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) NAME(cZahrMena)              CPOS( 88,5.2) CLEN(  5) PP(1) FONT(5)  GROUPS(11)

      TYPE(GET)  NAME(nCenaDokl)              FPOS( 34,6.2) FLEN( 11)        GROUPS(11)
      TYPE(Text) CAPTION(+)                   CPOS( 46,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(GET)  NAME(nNutneVN)               FPOS( 48,6.2) FLEN( 11)        GROUPS(11)
      TYPE(Text) CAPTION(-)                   CPOS( 60,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(Text) CAPTION(Suma položek)        CPOS( 62,4.2) CLEN( 11) PP(1)  GROUPS(11)
      TYPE(Text) NAME(M->nCelkDokl)           CPOS( 62,6.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) GROUPS(11)
      TYPE(Text) CAPTION(=)                   CPOS( 74,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(Text) CAPTION(Kontrolní rozdíl)    CPOS( 76,4.2) CLEN( 14) PP(1)  GROUPS(11)
      TYPE(Text) NAME(nRozPrij)               CPOS( 76,6.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) CAPTION(CZK)                 CPOS( 88,6.2) CLEN(  5) PP(1) FONT(5)  GROUPS(11)
    TYPE(END)  GROUPS(11)

*   Karta HLA 2_1  AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5) RESIZE(yx) GROUPS(21)
      TYPE(GET)  NAME(cVarSym)                FPOS(  1,1.2) FLEN( 15) FCAPTION( Variabilní symbol)  CPOS( 1,0.2)           GROUPS(21)
      TYPE(GET)  NAME(nCisFak)                FPOS( 18,1.2) FLEN( 15) FCAPTION( Faktura)            CPOS( 18,0.2)          GROUPS(21)
*      TYPE(GET)  NAME(nCenaDokl)              FPOS( 35,1.2) FLEN( 11) FCAPTION( Cena na dokladu)    CPOS( 35,0.2) CLEN(13) GROUPS(21)
*      TYPE(GET)  NAME(nNutneVN)               FPOS( 48,1.2) FLEN( 11) FCAPTION( Nutné VN)           CPOS( 48,0.2)          GROUPS(21)
* POST( LastFieldHD)

      TYPE(GET)  NAME(nCenaDokl)           FPOS(  1,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 1,4.2) CLEN(13)  GROUPS(21)
      TYPE(Text) CAPTION(+)                CPOS( 13,5.2) CLEN(  2) PP(1)  GROUPS(21)
      TYPE(GET)  NAME(nNutneVN)            FPOS( 15,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 15,4.2) GROUPS(21) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                CPOS( 27,5.2) CLEN(  2) PP(1)  GROUPS(21)
      TYPE(Text) CAPTION(Suma položek)     CPOS( 29,4.2) CLEN( 11) PP(1)  GROUPS(21)
      TYPE(Text) NAME(M->nCelkDokl)        CPOS( 29,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(21)
      TYPE(Text) CAPTION(=)                CPOS( 44,5.2) CLEN(  2) PP(1)   GROUPS(21)
      TYPE(Text) CAPTION(Kontrolní rozdíl) CPOS( 47,4.2) CLEN( 14) PP(1)   GROUPS(21)
      TYPE(Text) NAME(nRozPrij)            CPOS( 47,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(21)
    TYPE(END) GROUPS(21)

*   Karta HLA 2_2  AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5) RESIZE(yx) GROUPS(22)
      TYPE(GET)  NAME(cVarSym)                FPOS(  1,1.2) FLEN( 15) FCAPTION( Variabilní symbol)  CPOS( 1,0.2)           GROUPS(22)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 18,1.2) FLEN( 10) FCAPTION( Dodací list)        CPOS( 18,0.2)          GROUPS(22)
*      TYPE(GET)  NAME(nCenaDokl)              FPOS( 35,1.2) FLEN( 11) FCAPTION( Cena na dokladu)    CPOS( 35,0.2) CLEN(13) GROUPS(22)
*      TYPE(GET)  NAME(nNutneVN)               FPOS( 48,1.2) FLEN( 11) FCAPTION( Nutné VN)           CPOS( 48,0.2)          GROUPS(22)
* POST( LastFieldHD)

      TYPE(GET)  NAME(nCenaDokl)           FPOS(  1,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 1,4.2) CLEN(13)  GROUPS(22)
      TYPE(Text) CAPTION(+)                CPOS( 13,5.2) CLEN(  2) PP(1)  GROUPS(22)
      TYPE(GET)  NAME(nNutneVN)            FPOS( 15,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 15,4.2) GROUPS(22) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                CPOS( 27,5.2) CLEN(  2) PP(1)  GROUPS(22)
      TYPE(Text) CAPTION(Suma položek)     CPOS( 29,4.2) CLEN( 11) PP(1)  GROUPS(22)
      TYPE(Text) NAME(M->nCelkDokl)        CPOS( 29,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(22)
      TYPE(Text) CAPTION(=)                CPOS( 44,5.2) CLEN(  2) PP(1)   GROUPS(22)
      TYPE(Text) CAPTION(Kontrolní rozdíl) CPOS( 47,4.2) CLEN( 14) PP(1)   GROUPS(22)
      TYPE(Text) NAME(nRozPrij)            CPOS( 47,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(22)
    TYPE(END) GROUPS(22)

*   Karta HLA 3
    TYPE(Static) STYPE(13) SIZE(93, 8) FPOS(0,2.5)  RESIZE(yx) GROUPS(03)
      TYPE(GET)  NAME(M->nPohyb)           FPOS( 1,1.2)  FLEN( 6) FCAPTION( Pohyb) CPOS(1,0.2) CLEN( 10)       GROUPS(03)
      TYPE(Text) NAME(C_DrPohy->cNazevPoh) CPOS( 9,1.2)  CLEN( 25) BGND( 13) PP(1)                             GROUPS(03)
      TYPE(GET)  NAME(nCisFirmy)           FPOS( 37,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS( 37,0.2) CLEN( 10) GROUPS(03) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)           FPOS( 47,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(03)

      TYPE(GET)  NAME(cCislObInt)          FPOS(  1,3.2) FLEN( 35) FCAPTION( Objednávkal)   CPOS(  1,2.2) GROUPS(03)
      TYPE(GET)  NAME(cVarSym)             FPOS( 38,3.2) FLEN( 15) FCAPTION( V-symbol)      CPOS( 38,2.2) GROUPS(03)
      TYPE(GET)  NAME(nCisFak)             FPOS( 55,3.2) FLEN( 10) FCAPTION( Faktura)       CPOS( 55,2.2) GROUPS(03)
      TYPE(GET)  NAME(nCisloDL)            FPOS( 67,3.2) FLEN( 10) FCAPTION( Dodací list)   CPOS( 67,2.2) GROUPS(03)

      TYPE(GET)  NAME(nCenaDokl)           FPOS(  1,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 1,4.2) CLEN(13)  GROUPS(03)
      TYPE(Text) CAPTION(+)                CPOS( 13,5.2) CLEN(  2) PP(1)  GROUPS(03)
      TYPE(GET)  NAME(nNutneVN)            FPOS( 15,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 15,4.2) GROUPS(03) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                CPOS( 27,5.2) CLEN(  2) PP(1)  GROUPS(03)
      TYPE(Text) CAPTION(Suma položek)     CPOS( 29,4.2) CLEN( 11) PP(1)  GROUPS(03)
      TYPE(Text) NAME(M->nCelkDokl)        CPOS( 29,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(03)
      TYPE(Text) CAPTION(=)                CPOS( 44,5.2) CLEN(  2) PP(1)   GROUPS(03)
      TYPE(Text) CAPTION(Kontrolní rozdíl) CPOS( 47,4.2) CLEN( 14) PP(1)   GROUPS(03)
      TYPE(Text) NAME(nRozPrij)            CPOS( 47,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(03)
    TYPE(End) GROUPS(03)

*   Karta HLA 4_1
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(41)
      TYPE(GET)  NAME(nCisFak)            FPOS( 1,1.2) FLEN( 10) FCAPTION( Èís. faktury) CPOS( 1,0.2)  GROUPS(41) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(41)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(41)
    TYPE(END) GROUPS(41)

*   Karta HLA 4_2
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(42)
      TYPE(GET)  NAME(nCisloDL)           FPOS( 1,1.2) FLEN( 10) FCAPTION( Dodací list)  CPOS( 1,0.2)  GROUPS(42) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(42)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(42)
    TYPE(END) GROUPS(42)

*   Karta HLA 4_3  -
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(43)
      TYPE(GET)  NAME(nCisFak)             FPOS( 1,1.2) FLEN( 10) FCAPTION( Var. symbol)  CPOS( 1,0.2)  GROUPS(43) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(43)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(43)
    TYPE(END) GROUPS(43)

*   Karta HLA 5 - AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(05)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(05) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)          FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(05)
**      TYPE(Text) NAME(Firmy->cNazev)      CPOS( 11,1.2) CLEN( 50) BGND( 13) PP(1)                     GROUPS(05)
      TYPE(GET)  NAME(cCislObInt)         FPOS(  1,3.2) FLEN( 32) FCAPTION( Objednávka) CPOS( 1,2.2)  GROUPS(05)
      TYPE(GET)  NAME(nCisloDL)           FPOS( 35,3.2) FLEN( 10) FCAPTION( Dodací list)CPOS(35,2.2)  GROUPS(05)
      TYPE(COMBOBOX) NAME(M->cIsZahr)     FPOS( 47,3.2) FLEN( 11) FCAPTION( Typ DL)     CPOS(47,2.2)  VALUES(T:Tuzemský,Z:Zahranièní) GROUPS(05)
      TYPE(GET)  NAME(nProcSlev)          FPOS( 60,3.2) FLEN(  8) FCAPTION( Zákl.sleva) CPOS(60,2.2) GROUPS(05) POST( LastFieldHD)
      TYPE(Text) CAPTION( %)              CPOS( 69,3.2) CLEN(  3)                                     GROUPS(05)

      TYPE(Text) CAPTION(Èíslo faktury)   CPOS(  1,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME( nCisFak)           CPOS ( 1,6.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(05)
      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 29,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS (29,6.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(05)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 43,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS (43,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(05)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 57,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 57,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(05)
    TYPE(END) GROUPS(05)

*   Karta HLA 6   AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(06)
      TYPE(GET)  NAME(nCisloDL)  FPOS( 1,1.2) FLEN( 10) FCAPTION( Dodací list) CPOS( 1,0.2) GROUPS(06) POST( LastFieldHD)

      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 31,2.2) CLEN( 13)                                     GROUPS(06)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS( 31,3.2) CTYPE( 2) CLEN( 13) BGND( 13) PP(1)           GROUPS(06)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 45,2.2) CLEN( 10)                          GROUPS(06)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS (45,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(06)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 59,2.2) CLEN( 10)                          GROUPS(06)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 59,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(06)
    TYPE(END) GROUPS(06)

*   Karta HLA 7   AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(07)
      TYPE(GET)  NAME(cCislObInt)    FPOS(  1,1.2) FLEN( 35) FCAPTION( Èíslo zakázky)      CPOS(  1,0.2) GROUPS(07) PUSH(SKL_OBJHEAD_SEL) POST( LastFieldHD)
*      TYPE(GET)  NAME(cCislObInt)    FPOS( 18,1.2) FLEN( 15) FCAPTION( Èíslo objednávky)   CPOS( 18,0.2) GROUPS(07) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(07)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(07)
    TYPE(END) GROUPS(07)

*   Karta HLA 8 - AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(08)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(08) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(08)
**      TYPE(Text) NAME(Firmy->cNazev)      CPOS( 11,1.2) CLEN( 25) BGND( 13) PP(1)                        GROUPS(08)
      TYPE(GET)  NAME(nCisFak)            FPOS( 38,1.2) FLEN( 10) FCAPTION( Èís. paragonu) CPOS( 38,0.2) GROUPS(08) POST( LastFieldHD)

      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 23,2.2) CLEN( 13)                           GROUPS(08)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS (23,3.2) CTYPE( 2) CLEN( 13) BGND( 13) PP(1) GROUPS(08)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 38,2.2) CLEN( 13)                          GROUPS(08)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS( 38,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(08)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 53,2.2) CLEN( 13)                          GROUPS(08)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 53,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(08)
    TYPE(END) GROUPS(08)

*   Karta HLA 9 - AN
    TYPE(Static) STYPE(13) SIZE(93,8) FPOS(0,2.5)  RESIZE(yx) GROUPS(09)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(09) PUSH(SKL_FIRMY_SEL)
      TYPE(GET)  NAME(cNazFirmy)          FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(09)
**      TYPE(Text) NAME(Firmy->cNazev)      CPOS( 11,1.2) CLEN( 25) BGND( 13) PP(1)                     GROUPS(09)
      TYPE(GET)  NAME(cCislObInt)         FPOS(  1,3.2) FLEN( 15) FCAPTION( Zakázka)    CPOS( 1,2.2)  GROUPS(09)
      TYPE(GET)  NAME(nCisloDL)           FPOS( 18,3.2) FLEN( 10) FCAPTION( Dodací list)CPOS(18,2.2)  GROUPS(09)
      TYPE(COMBOBOX) NAME(M->cIsZahr)     FPOS( 30,3.2) FLEN( 11) FCAPTION( Typ DL)     CPOS(30,2.2)  VALUES(T:Tuzemský,Z:Zahranièní) GROUPS(09)
      TYPE(GET)  NAME(nProcSlev)          FPOS( 43,3.2) FLEN(  8) FCAPTION( Zákl.sleva) CPOS( 43,2.2) GROUPS(09) POST( LastFieldHD)
      TYPE(Text) CAPTION( %)              CPOS( 52,3.2) CLEN(  3)                                     GROUPS(09)

      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 29,5.2) CLEN( 13)                                     GROUPS(09)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS( 29,6.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(09)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 43,5.2) CLEN( 13)                                     GROUPS(09)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS( 43,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(09)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 57,5.2) CLEN( 13)                                     GROUPS(09)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 57,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(09)
    TYPE(END) GROUPS(09)

  TYPE(END)

  TYPE(End)


**************** Položky dokladù
  TYPE(TabPage) CAPTION(Položky) FPOS( 0, 0.2) SIZE(119.8,13.5) OFFSET(16,68) RESIZE(yn) TABHEIGHT( 1.2) TABBROWSE(PVPITEM) PRE( TABIT)

** Panel klíèových údajù ( Doklad, Sklad, Pohyb )
    TYPE(Static) STYPE(12) SIZE(119.8,1.3) FPOS(0,0.1) RESIZE(yx)
     TYPE(Text) CAPTION( Doklad :)     CPOS(  1,0.1)   CLEN(  8) PP(1)
     TYPE(Text) NAME(M->nDoklad)       CPOS(  9,0.1)   CLEN( 14) FONT( 5) PP(1)
     TYPE(Text) CAPTION( Sklad :)      CPOS( 25,0.1)   CLEN(  7) PP(1)
     TYPE(Text) NAME( M->cSKLAD)       CPOS( 32,0.1)   CLEN(  8) BGND(13) FONT( 5) PP(2)
     TYPE(Text) NAME( M->cNazSklad)    CPOS( 40,0.1)   CLEN( 25) BGND(13) FONT( 5) PP(2) CTYPE(1)
     TYPE(Text) CAPTION( Pohyb :)      CPOS( 66,0.1)   CLEN(  7) PP(1)
     TYPE(Text) NAME( M->nPohyb)       CPOS( 73,0.1)   CLEN(  5) BGND(13) FONT( 5) PP(2)
     TYPE(Text) NAME( M->cNazPohyb)    CPOS( 78,0.1)   CLEN( 25) BGND(13) FONT( 5) PP(2) CTYPE(1)
    TYPE(END)

*   Panel výbìru z ...
    TYPE(Static) STYPE(1) SIZE(63, 2.4) FPOS(55.8,1.5) RESIZE(yx) GROUPS(0100,0106,1107)
      TYPE(GET)  NAME(PVPITEM->cCisObj)    FPOS(  1,1.2) FLEN( 20) FCAPTION( Objednávka vystavená) CPOS( 1,0.2) GROUPS(0100,0106,1107) PUSH(SKL_OBJVYSIT_SEL)
      TYPE(Text) CAPTION(Položka)          CPOS( 23,0.2) CLEN( 10)                 GROUPS(0100,0106,1107)
      TYPE(Text) NAME(PVPITEM->nIntCount)  CPOS( 23,1.2) CLEN(  5) BGND(13) PP(1)  GROUPS(0100,0106,1107)

      TYPE(Text) CAPTION(Rozdíl pøi pøíjmu) CPOS( 45,0.2) CLEN( 15)                   GROUPS(0100,0106,1107)
      TYPE(Text) NAME(PVPHEAD->nRozPrij)    CPOS( 45,1.2) CLEN( 12) BGND(13) PP(1) CTYPE(2) GROUPS(0100,0106,1107)

    TYPE(END)
    TYPE(Static) STYPE(1) SIZE(63, 2.4) FPOS(55.8,1.5) RESIZE(yx) GROUPS(0503)
      TYPE(Text) CAPTION(Objednávka pøijatá)          CPOS( 1,0.2) CLEN( 20) GROUPS(0503)
*      TYPE(Text) CAPTION(Výrobní zakázka)             CPOS( 1,0.2) CLEN( 20) GROUPS(0704)
      TYPE(GET)  NAME(PVPITEM->cCislObInt) FPOS(  1,1.2) FLEN( 32)                 GROUPS(0503) PUSH(SKL_OBJITEM_SEL)
      TYPE(Text) CAPTION(Položka)          CPOS( 35,0.2) CLEN( 10)                 GROUPS(0503)
      TYPE(Text) NAME(PVPITEM->nCislPolOb) CPOS( 35,1.2) CLEN(  5) BGND(13) PP(1)  GROUPS(0503)
    TYPE(END)

    TYPE(Static) STYPE(1) SIZE(63, 2.4) FPOS(55.8,1.5) RESIZE(yx) GROUPS(0704)
      TYPE(GET)  NAME(PVPITEM->cCislObInt) FPOS(  1,1.2) FLEN( 20) FCAPTION( Výrobní zakázka) CPOS( 1,0.2) GROUPS(0704) PUSH(SKL_OBJITEM_SEL)
      TYPE(Text) CAPTION(Položka)          CPOS( 23,0.2) CLEN( 10)                 GROUPS(0704)
      TYPE(Text) NAME(PVPITEM->nCislPolOb) CPOS( 23,1.2) CLEN(  5) BGND(13) PP(1)  GROUPS(0704)
    TYPE(END)

    TYPE(Static) STYPE(1) SIZE(63, 2.4) FPOS(55.8,1.5) RESIZE(yx) GROUPS(0051, 0400)
      TYPE(Text) CAPTION(Mn. skladové)     CPOS(  1,0.2) CLEN( 15)                    GROUPS(0051, 0400)
      TYPE(Text) NAME(CENZBOZ->nMnozsZBO)  CPOS(  1,1.2) CLEN( 15)  BGND( 13) PP(1) CTYPE(2)   GROUPS(0051, 0400)
      TYPE(Text) CAPTION(Úè.sk.)           CPOS( 17,0.2) CLEN(  7)                             GROUPS(0051)
      TYPE(Text) NAME(CENZBOZ->nUcetSkup)  CPOS( 17,1.2) CLEN(  7)  BGND( 13) PP(1) CTYPE(2)   GROUPS(0051)
    TYPE(END)

*   Spoleèné údaje POL
    TYPE(Static) STYPE(1) SIZE(75, 2.4) FPOS(0.8,1.5)  RESIZE(yx)
      TYPE(GET)  NAME(PVPITEM->cSklPol)  FPOS(  1,1.2) FLEN( 18) FCAPTION( Skl. položka) CPOS(  1,0.2) PP(2) PUSH(SKL_CENZBOZ_SEL)
      TYPE(Text) CAPTION(Název zboží)    CPOS( 22,0.2) CLEN( 10)
      TYPE(Text) NAME(PVPITEM->cNazZbo)  CPOS( 22,1.2) CLEN( 30) BGND(13) PP(1)
    TYPE(END)

*    Karta POL 0
     TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(0000,0100,2100,2200,0300)
       TYPE(GET)  NAME(M->cKatcZBO)         FPOS(  1,1.2) FLEN( 15) FCAPTION( Katalogové è.) CPOS(  1,0.2) GROUPS(0000,0100,2100,2200,0300)
*       TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS( 18,1.2) FLEN( 13) FCAPTION( Skladová cena) CPOS( 18,0.2) GROUPS(0000,0100,2100,2200,0300)
       TYPE(GET)  NAME(PVPITEM->nCenaDokl1) FPOS( 18,1.2) FLEN( 13) FCAPTION( Skl.cena/MJ dokl.) CPOS( 18,0.2) GROUPS(0000,0100,2100,2200,0300)
       TYPE(GET)  NAME(PVPITEM->nMnozDokl1) FPOS( 33,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 33,0.2) GROUPS(0000,0100,2100,2200,0300) POST( SKL_MnPrijate)
       TYPE(GET)  NAME(PVPITEM->cMjDokl1)   FPOS( 47,1.2) FLEN( 10) FCAPTION( MJ dokl.     ) CPOS( 47,0.2) GROUPS(0000,0100,2100,2200,0300)

       TYPE(Text) CAPTION(Cena celkem)      CPOS( 60,0.2) CLEN( 13)   GROUPS(0000,0100,2100,2200,0300)
       TYPE(Text) NAME(PVPITEM->nCenaCelk ) CPOS( 60,1.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0000,0100,2100,2200,0300)

       TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS( 18,3.2) FLEN( 13) FCAPTION( Skl.cena/MJ zákl.) CPOS( 18,2.2) GROUPS(0000,0100,2100,2200,0300)
       TYPE(GET)  NAME(PVPITEM->nMnozPrDod) FPOS( 33,3.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 33,2.2) GROUPS(0000,0100,2100,2200,0300)
       TYPE(Text) CAPTION(MJ zákl.)         CPOS( 47,2.2) CLEN( 13)                   GROUPS(0000,0100,2100,2200,0300)
       TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 47,3.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0000,0100,2100,2200,0300)
     TYPE(END)

*   Karta POL 1
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(0101)
**      TYPE(GET)  NAME(PVPITEM->cSklPol) FPOS( 1,1.2) FLEN( 18) FCAPTION( Skl. položka)  CPOS( 1,0.2)  GROUPS(0101)
       TYPE(Text) CAPTION(Karta 1)      CPOS( 1,2.2) CLEN( 6)  GROUPS(0101)
    TYPE(END)

*   Karta POL 2
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)   GROUPS(0A02,4102,4202,4302 )
       TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS(  1,1.2) FLEN( 13) FCAPTION( Skladová cena)  CPOS(  1,0.2) GROUPS(0A02,4102,4202,4302)
       TYPE(GET)  NAME(PVPITEM->nMnozPrDod) FPOS( 16,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )  CPOS( 16,0.2) GROUPS(0A02,4102,4202,4302) POST( SKL_MnPrijate)
       TYPE(Text) CAPTION(Cena celkem)      CPOS( 31,0.2) CLEN( 13) GROUPS(0A02,4102,4202,4302)
       TYPE(Text) NAME(PVPITEM->nCenaCelk ) CPOS( 31,1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0A02,4102,4202,4302)

      TYPE(Text) CAPTION( Nákladová struktura :) CPOS(  3, 6.2)   CLEN( 22) FONT(7)                   GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol1)    FPOS( 25,6.2)  FLEN( 10) FCAPTION(Stredisko)  CPOS(25,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol2)    FPOS( 37,6.2)  FLEN( 10) FCAPTION(Výkon)      CPOS(37,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol3)    FPOS( 49,6.2)  FLEN( 10) FCAPTION(Zakázka)    CPOS(49,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol4)    FPOS( 61,6.2)  FLEN( 10) FCAPTION(Výr.místo)  CPOS(61,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol5)    FPOS( 73,6.2)  FLEN( 10) FCAPTION(Stroj)      CPOS(73,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME(PVPITEM->cNazPol6)    FPOS( 85,6.2)  FLEN( 10) FCAPTION(Výr.operace)CPOS(85,5.2) GROUPS(0A02,4102,4202,4302) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 12
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(1012)
       TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS(  1,1.2) FLEN( 13) FCAPTION( Vnitrocena)  CPOS(  1,0.2) GROUPS(1012)
       TYPE(GET)  NAME(PVPITEM->nMnozPrDod) FPOS( 16,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )  CPOS( 16,0.2) GROUPS(1012) POST( SKL_MnPrijate)
       TYPE(Text) CAPTION(Cena celkem)      CPOS( 31,0.2) CLEN( 13)   GROUPS(1012)
       TYPE(Text) NAME(PVPITEM->nCenaCelk ) CPOS( 31,1.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(1012)

      TYPE(Text) CAPTION( Nákladová struktura :) CPOS(  3, 6.2)   CLEN( 22) FONT(7)                   GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol1)    FPOS( 25,6.2)  FLEN( 10) FCAPTION(Stredisko)  CPOS(25,5.2) GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol2)    FPOS( 37,6.2)  FLEN( 10) FCAPTION(Výkon)      CPOS(37,5.2) GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol3)    FPOS( 49,6.2)  FLEN( 10) FCAPTION(Zakázka)    CPOS(49,5.2) GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol4)    FPOS( 61,6.2)  FLEN( 10) FCAPTION(Výr.místo)  CPOS(61,5.2) GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol5)    FPOS( 73,6.2)  FLEN( 10) FCAPTION(Stroj)      CPOS(73,5.2) GROUPS(1012)
      TYPE(GET) NAME(PVPITEM->cNazPol6)    FPOS( 85,6.2)  FLEN( 10) FCAPTION(Výr.operace)CPOS(85,5.2) GROUPS(1012) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 3
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(0A03,0503,0603,0803,0903)
*     1.ø.
      TYPE(Text) CAPTION(Sazba Dph)        CPOS(  1,0.2) CLEN( 10)                   GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) NAME(C_DPH->nProcDPH)     CPOS(  6,1.2) CLEN(  5) BGND( 1) PP(1)    GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nProcDPH)         CPOS(  6,1.2) CLEN(  5) BGND( 1) PP(1)    GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION(%)                CPOS( 11,1.2) CLEN(  2)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(PVPITEM->nKlicDph)   FPOS(  1,1.2) FLEN(  4)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(PVPITEM->nMnozPrdod) FPOS( 13,1.2) FLEN( 11) FCAPTION( Mn. spotøeby)  CPOS(13,0.2) GROUPS(0A03,0503,0603,0803,0903) POST( SKL_MnVydane)
      TYPE(Text) CAPTION(Balení)           CPOS(  1,2.2) CLEN(  6)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(CENZBOZ->cBal)       CPOS(  1,3.2) CLEN( 10) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION(Poèet)            CPOS( 11,2.2) CLEN(  5)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nPocetBal)        CPOS( 11,3.2) CLEN(  6) CTYPE(2) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION(Zùstatek)         CPOS( 17,2.2) CLEN(  8)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nZustatek)        CPOS( 17,3.2) CLEN(  8) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 9999999.99)  GROUPS(0A03,0503,0603,0803,0903)

      TYPE(Text) CAPTION( Prod. ceny za MJ    - základní  :)  CPOS( 26,1.2) CLEN( 23) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION( - se slevou : )    CPOS( 39,2.2) CLEN( 10) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION( Prod. ceny celkem  - za položku:)  CPOS( 26,3.2) CLEN( 23) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION( - za doklad: )     CPOS( 39,4.2) CLEN( 10) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION( Èástka slevy )     CPOS( 77,0.2) CLEN( 12) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(PVPITEM->nCenaZakl)    FPOS( 49,1.2) FLEN( 12) FCAPTION(bez DPH) CPOS(55,0.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(M->nCenaMZbo)          FPOS( 62,1.2) FLEN( 12) FCAPTION(s DPH)   CPOS(70,0.2) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(PVPITEM->nHodnSlev)    FPOS( 76,1.2) FLEN( 12) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(PVPITEM->nProcSlev)    FPOS( 89,1.2) FLEN(  7) PICTURE(@N 99.9999) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION( % )  CPOS( 94,0.2) CLEN( 3) GROUPS(0A03,0503,0603,0803,0903)

      TYPE(Text) NAME(M->nVyslCenaB)  CPOS( 49,2.2) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nVyslCenaS)  CPOS( 62,2.2) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nSumHodnSl)  CPOS( 76,2.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.99)  GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nSumProcSl)  CPOS( 89,2.2) CLEN(  8) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99.9999) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nSumaPolB)   CPOS( 49,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nSumaPolS)   CPOS( 62,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nCelkPCB)    CPOS( 49,4.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nCelkPCS)    CPOS( 62,4.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) NAME(M->nSumaDoklB) CPOS( 49,4.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) NAME(M->nSumaDoklS) CPOS( 62,4.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903)


      TYPE(GET)  NAME(PVPITEM->cZkrProdej)    FPOS( 1,6.2) FLEN( 6) FCAPTION(Prodejce) CPOS(1,5.2) GROUPS(0A03,0503,0603,0803,0903)

*      TYPE(Text) CAPTION( Nákladová struktura :) CPOS(  3, 6.2)   CLEN( 22) FONT(7)                  GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol1)    FPOS( 25,6.2)  FLEN( 10) FCAPTION(Stredisko)  CPOS(25,5.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol2)    FPOS( 37,6.2)  FLEN( 10) FCAPTION(Výkon)      CPOS(37,5.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol3)    FPOS( 49,6.2)  FLEN( 10) FCAPTION(Zakázka)    CPOS(49,5.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol4)    FPOS( 61,6.2)  FLEN( 10) FCAPTION(Výr.místo)  CPOS(61,5.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol5)    FPOS( 73,6.2)  FLEN( 10) FCAPTION(Stroj)      CPOS(73,5.2) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME(PVPITEM->cNazPol6)    FPOS( 85,6.2)  FLEN( 10) FCAPTION(Výr.operace)CPOS(85,5.2) GROUPS(0A03,0503,0603,0803,0903) POST( LastFieldIT)

    TYPE(END)

*   Karta POL 4
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(0A04,0704,4304)
      TYPE(GET)  NAME(PVPITEM->nMnozDokl1) FPOS(  1,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS( 1,0.2) GROUPS(0A04,0704,4304) POST( SKL_MnVydane)
      TYPE(GET)  NAME(PVPITEM->cMJDokl1)   FPOS( 15,1.2) FLEN( 13) FCAPTION( MJ dokl     )  CPOS(15,0.2) GROUPS(0A04,0704,4304)
      TYPE(GET)  NAME(PVPITEM->nMnozPrdod) FPOS( 30,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS(30,0.2) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(MJ zákl.)         CPOS( 45,0.2) CLEN( 13)                   GROUPS(0A04,0704,4304)
      TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 45,1.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0A04,0704,4304)

*      TYPE(Text) CAPTION(Balení)              CPOS( 18,0.2)   CLEN(  6)                          GROUPS(0A04,0704,4304)
*      TYPE(Text) NAME(CENZBOZ->cBal)          CPOS( 18,1.2)   CLEN( 10)          BGND( 13) PP(1) GROUPS(0A04,0704,4304)
*      TYPE(Text) CAPTION(Poèet bal.)          CPOS( 28,0.2)   CLEN(  8)                          GROUPS(0A04,0704,4304)
*      TYPE(Text) NAME(M->nPocetBal)           CPOS( 28,1.2)   CLEN( 10) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
*      TYPE(Text) CAPTION(Zùstatek)            CPOS( 38,0.2)   CLEN(  8)                          GROUPS(0A04,0704,4304)
*      TYPE(Text) NAME(M->nZustatek)           CPOS( 38,1.2)   CLEN( 10) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)

      TYPE(Text) CAPTION(Skladová cena)       CPOS(  1,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(CENZBOZ->nCenaSZBO)     CPOS(  1,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Celkem položka)      CPOS( 17,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(M->nCelkITEM)           CPOS( 17,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304) PICTURE( @N 99 999 999.99)
*      TYPE(Text) NAME(PVPItem->nCenaCelk)     CPOS( 17,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Celkem doklad)       CPOS( 33,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(M->nCelkDOKL)           CPOS( 33,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304) PICTURE( @N 99 999 999.99)

      TYPE(Text) CAPTION(Mn. k dispozici)      CPOS( 58,0.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(CENZBOZ->nMnozDZBO)      CPOS( 58,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Mn. rezervováno)      CPOS( 75,0.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(CENZBOZ->nMnozRZBO)      CPOS( 75,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)

      TYPE(GET) NAME(PVPITEM->cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME(PVPITEM->cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME(PVPITEM->cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME(PVPITEM->cNazPol4)    FPOS( 49,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME(PVPITEM->cNazPol5)    FPOS( 65,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME(PVPITEM->cNazPol6)    FPOS( 81,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0A04,0704,4304) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 5  ( Výdej do DKP ... karta 205 )
    TYPE(Static) STYPE(13) SIZE(119, 9) FPOS(0, 2.5)  RESIZE(yx)         GROUPS(0105)
**      TYPE(GET)  NAME(PVPITEM->cCisSklad) FPOS( 37,1.2) FLEN( 18) FCAPTION( Sklad) CPOS( 37,0.2) GROUPS(0105)
       TYPE(Text) CAPTION(Karta 5)      CPOS( 1,2.2) CLEN( 6)  GROUPS(0105)
    TYPE(END)

*   Karta POL 51  (  ... karta 305 )
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)  GROUPS(0051)
      TYPE(GET)  NAME(PVPITEM->cSkladKAM)  FPOS(  1,1.2) FLEN( 12) FCAPTION( Pøevod na sklad)   CPOS( 1,0.2) GROUPS(0051) PUSH(SKL_C_Sklad)
      TYPE(GET)  NAME(PVPITEM->cSklPolKAM) FPOS( 15,1.2) FLEN( 20) FCAPTION( Pøevod na položku) CPOS(15,0.2) GROUPS(0051)
      TYPE(GET)  NAME(PVPITEM->nUcetSkKAM) FPOS( 37,1.2) FLEN( 12) FCAPTION( Pøevod na úè.sk.)  CPOS(37,0.2) GROUPS(0051) PUSH(SKL_C_UctSkp)
      TYPE(GET)  NAME(PVPITEM->nMnozPrdod) FPOS( 51,1.2) FLEN( 15) FCAPTION( Mn. pøevodu)       CPOS(51,0.2) GROUPS(0051) POST( SKL_MnPrevodu)
      TYPE(GET)  NAME(PVPITEM->cText)      FPOS( 75,1.2) FLEN( 30) FCAPTION( Pozn. k pøevodu)   CPOS(75,0.2) GROUPS(0051)
    TYPE(END)


*   Karta POL 6
    TYPE(Static) STYPE(13) SIZE(118.4, 9) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(0106)
      TYPE(GET)  NAME(PVPITEM->nCenaPZBO)   FPOS(  1,1.2) FLEN( 13) FCAPTION( PC bez Dph)     CPOS(  1,0.2) GROUPS(0106)
      TYPE(GET)  NAME(PVPITEM->nCenaPDZBO)  FPOS( 18,1.2) FLEN( 13) FCAPTION( PC s Dph)       CPOS( 18,0.2) GROUPS(0106)
      TYPE(GET)  NAME(M->nMarzRabat)        FPOS( 35,1.2) FLEN(  8) FCAPTION( Sleva v %)      CPOS( 35,0.2) GROUPS(0106)
      TYPE(TEXT) CAPTION(Skladová cena)     CPOS( 47,0.2) CLEN( 13) GROUPS(0106)
      TYPE(GET)  NAME(PVPITEM->nCenNapDod)  FPOS( 47,1.2) FLEN( 13) GROUPS(0106)
      TYPE(GET)  NAME(PVPITEM->nMnozPrDod)  FPOS( 64,1.2) FLEN( 13) FCAPTION( Mn.pøijaté)    CPOS( 64,0.2) GROUPS(0106)
      TYPE(TEXT) CAPTION(Cena celkem)       CPOS( 80,0.2) CLEN( 13) GROUPS(0106)
      TYPE(TEXT) NAME(PVPITEM->nCenaCelk)   CPOS( 80,1.2) CLEN( 13) CTYPE(2) BGND( 13) GROUPS(0106)

*       TYPE(Text) CAPTION(Karta 6)      CPOS( 1,5.2) CLEN( 6)  GROUPS(0106)
    TYPE(END)

*    Karta POL 7   -  Pøíjem v zahr. mìnì
     TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)         GROUPS(1107)
       TYPE(GET)  NAME(M->cKatcZBO)         FPOS(  1,1.2) FLEN( 15) FCAPTION( Katalogové è.) CPOS(  1,0.2) GROUPS(1107)

       TYPE(GET)  NAME(PVPITEM->nCenNaDoZM) FPOS( 18,1.2) FLEN( 13) FCAPTION( Skladová cena) CPOS( 18,0.2) GROUPS(1107)
*       TYPE(Text) CAPTION(Mìna zahr.)       CPOS( 33,0.2) CLEN( 10)                   GROUPS(1107)
       TYPE(TEXT) NAME(PVPHead->cZahrMena)  CPOS( 33,1.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME(PVPITEM->nMnozDokl1) FPOS( 44,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 44,0.2) GROUPS(1107) POST( SKL_MnPrijate)
       TYPE(GET)  NAME(PVPITEM->cMjDokl1)   FPOS( 59,1.2) FLEN( 10) FCAPTION( MJ dokl.     ) CPOS( 59,0.2) GROUPS(1107)

       TYPE(Text) CAPTION(Cena celkem)      CPOS( 71,0.2) CLEN( 13)   GROUPS(1107)
       TYPE(Text) NAME(PVPITEM->nCenCelkZM) CPOS( 71,1.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) FONT(5) PICTURE( @N 99 999 999.99) GROUPS(1107)
       TYPE(TEXT) NAME(PVPHead->cZahrMena)  CPOS( 85,1.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS( 18,3.2) FLEN( 13) FCAPTION( Skladová cena) CPOS( 18,2.2) GROUPS(1107)
*       TYPE(Text) CAPTION(Mìna zákl.)       CPOS( 33,2.2) CLEN( 10)                   GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratMeny) CPOS( 33,3.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME(PVPITEM->nMnozPrDod) FPOS( 44,3.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 44,2.2) GROUPS(1107)
       TYPE(Text) CAPTION(MJ zákl.)         CPOS( 59,2.2) CLEN( 10)                   GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 59,3.2) CLEN(  5) CTYPE(1) BGND(13) GROUPS(1107)
       TYPE(Text) CAPTION(Cena celkem)      CPOS( 71,2.2) CLEN( 13)   GROUPS(1107)
       TYPE(Text) NAME(PVPITEM->nCenaCelk)  CPOS( 71,3.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) FONT(5) PICTURE( @N 99 999 999.99) GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratMeny) CPOS( 85,3.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

     TYPE(END)


*   Karta POL 400 ... pøecenìní
    TYPE(Static) STYPE(13) SIZE(118.4, 8) FPOS(0.8, 4)  RESIZE(yx)    GROUPS(0400)
      TYPE(Text) CAPTION(Skl.cena/MJ)      CPOS( 25,0.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Cena celkem)      CPOS( 45,0.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Pùvodní hodnota)  CPOS(  2,1.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Nová  hodnota)    CPOS(  2,2.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Nová - Pùvodní)   CPOS(  2,3.2)   CLEN( 15) GROUPS(0400)

      TYPE(Text) NAME(PVPITEM->nCelkSLEV)  CPOS( 20,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(GET)  NAME(PVPITEM->nCenNapDod) FPOS( 20,2.2)   FLEN( 14) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(Text) NAME(PVPITEM->nCenaCZBO)  CPOS( 40,2.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)

      TYPE(Text) NAME(M->nCenaSROZ)         CPOS( 20,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(Text) NAME(PVPITEM->nCenaCelk)   CPOS( 40,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)

      TYPE(GET) NAME(PVPITEM->cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0400)
      TYPE(GET) NAME(PVPITEM->cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0400)
      TYPE(GET) NAME(PVPITEM->cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0400)
      TYPE(GET) NAME(PVPITEM->cNazPol4)    FPOS( 49,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0400)
      TYPE(GET) NAME(PVPITEM->cNazPol5)    FPOS( 65,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0400)
      TYPE(GET) NAME(PVPITEM->cNazPol6)    FPOS( 81,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0400) POST( LastFieldIT)
    TYPE(END)


*   TYPE(End)

  TYPE(End)

*****************
  TYPE(dBrowse) FILE(PVPITEM) INDEXORD(2) ;
               FIELDS( IsUctovano( 1; 'PVPITEM'):L:3::2,;
                       nOrdItem,;
                       cSklPol,;
                       cNazZbo::29,;
                       nMnozPrDOD,;
                       cZkratJedn,;
                       nCenNapDOD,;
                       nCenaCelk ,;
                       nCenapZBO,;
                       nCenapDZBO);
               SIZE(119, 11) FPOS( 0.2,13.8) CURSORMODE(3) SCROLL(ny) RESIZE(yy) PP(6) POPUPMENU(n) ;
               ITEMMARKED(ItemMarked)