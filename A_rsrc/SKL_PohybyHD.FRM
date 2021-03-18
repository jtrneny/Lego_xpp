TYPE(drgForm) DTYPE(10) TITLE(Pohybový doklad ... w) SIZE(105, 26) FILE(PVPHEADw) ;
               GUILOOK(Action:y,Message:n,IconBar:Y:MyIconBar,Menu:n)           ;    
               CARGO(SKL_PohybyIT) POST(POSTVALIDATE) OBDOBI(SKL)


TYPE(Action) CAPTION( ~Ulož doklad)   EVENT( SaveDoklad) ICON1(428) ICON2(428) ATYPE(3) TIPTEXT(uložit skladový doklad )
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION( info ~Ceník)    EVENT( SKL_CENZBOZ_INFO) TIPTEXT(informaèní karta skladové položky )
TYPE(Action) CAPTION( ~Výrobní èísla) EVENT( btn_VYROBCIS)     TIPTEXT(Evidence výrobních èísel daného zboží)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION(tisk èárKódù)     EVENT(Cenik_TiskCarKodu) TIPTEXT(Tisk èárových kódù)



  TYPE(TabPage) TTYPE(4) CAPTION(POLOŽKY dokladu) FPOS( 0,13.9) SIZE(104.9, 11.8) RESIZE(yy) OFFSET(1,84) TABHEIGHT( 1.2) PRE(TabHD)
*  TYPE(TEXT) CAPTION(Položky dokladu) CPOS(.1,13.4) CLEN(104.9) FONT(5) PP(3) BGND(11)  RESIZE(yn) CTYPE(1)
    TYPE(dBrowse) FILE(PVPITEMww) INDEXORD(1);
                  FIELDS( nOrdItem   , ;
                          cSklPol    , ;
                          cNazZbo::29, ;
                          nMnozPrDOD , ;
                          cZkratJedn , ;
                          nCenNapDOD , ;
                          nCenaCelk  , ;
                          nCenapZBO  , ;
                          nCenapDZBO   ) ;
*                  FPOS( 0.5 , 14.4) SIZE(104, 10.5) CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yy) POPUPMENU(yn) FOOTER(y) ;
                  FPOS( 0.5 , 0.0) SIZE(104, 10.6) CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yy) POPUPMENU(y) FOOTER(y) COLORED(-29,-34) ;
                  ITEMMARKED( ItemMarked)
  TYPE(End

*TYPE(Static) STYPE(12) SIZE( 13, 1) FPOS( 90, 13.9) RESIZE(nn)
*  TYPE(PushButton) POS(0, 0) SIZE( 13,1) CAPTION(~Info skl.pol.) EVENT( SKL_CENZBOZ_INFO) TIPTEXT(informaèní karta skladové položky );
*      ICON1() ICON2() ATYPE(3)
*TYPE(End

TYPE(Static) STYPE(12) SIZE(104.8, 13.5) FPOS(0.1,0.1) RESIZE(yn) CTYPE(2)

  TYPE(Static) STYPE(12) SIZE(104.6,2.9) FPOS(0.2,0.0) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Sklad)              CPOS( 2, 0.3) CLEN( 10) FONT(2)
    TYPE(GET ) NAME(M->mainSklad)          FPOS(15, 0.3) FLEN( 12) BGND(13) FONT(5) PP(2) PUSH(SKLAD_SEL)      NOREVISION()    
    TYPE(Text) NAME(M->naz_mainSklad)      CPOS(30, 0.3) CLEN( 40) BGND(13) FONT(5) RESIZE(yx) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Pohyb)              CPOS( 2, 1.3) CLEN( 10) FONT(2)
    TYPE(GET ) NAME(M->mainPohyb)          FPOS(15, 1.3) FLEN( 12) BGND(13) FONT(5) PP(2) PUSH(TYPPOHYBU_SEL)  NOREVISION()
    TYPE(Text) NAME(M->naz_mainPohyb)      CPOS(30, 1.3) CLEN( 40) BGND(13) FONT(5) RESIZE(yx) GROUPS( clrGREY)

    TYPE(Static) STYPE(2) SIZE( 28.5, 2) FPOS( 75, 0.0) RESIZE(nx)
      TYPE(Text)   NAME(M->naz_Doklad)       CPOS( 7, 0.5) CLEN( 15) FONT(4) CTYPE(3) RESIZE(xy)
    TYPE(End)

    TYPE(TEXT) NAME(pvpitemww->csklPol)    FPOS(0,0) CLEN(0)
  TYPE(End)

* Karta pohybu
  TYPE(Static) STYPE(12) SIZE(104,10.5) FPOS(0.5, 3) RESIZE(yx) CTYPE(2)
    TYPE(Static) STYPE(1) SIZE(103,2.4) FPOS(0.2, 0.2) RESIZE(yx)
      TYPE(GET)  NAME(nDOKLAD)  FPOS(  2, 1.2) FLEN(12) FCAPTION( Doklad) CPOS(  2, 0.2) FONT(5) PP(2) NOREVISION()
      TYPE(GET)  NAME(dDatPVP)  FPOS( 17, 1.2) FLEN(12) FCAPTION( Datum)  CPOS( 17, 0.2) PUSH( ClickDATE) POST( LastFieldHD)
      TYPE(GET)  NAME(cObdobi)  FPOS( 32, 1.2) FLEN( 7) FCAPTION( Období) CPOS( 32, 0.2) PP(1)
    TYPE(End)

*   Karta HLA 0A
*   nkarta.ccrd 102, 203, 204, 205.0A

    TYPE(Static) STYPE(1) SIZE(103, 7.7) FPOS(0, 2.6)  RESIZE(xy) GROUPS(0A)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 2,0.2) CLEN( 13)                           GROUPS(0A)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS( 2,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)  GROUPS(0A)
    TYPE(END) GROUPS(0A)

*   Karta HLA 10
*   nkarta.ccrd 103, 104.10

    TYPE(Static) STYPE(1) SIZE(103, 7.7) FPOS(0.2, 2.6)  RESIZE(xy) GROUPS(10)
      TYPE(GET)  NAME(cCisZakaz)              FPOS(  2,1.2) FLEN( 28) FCAPTION( Zakázka) CPOS(  2,0.2) CLEN( 10) GROUPS(10) PUSH(SKL_VYRZAK_SEL) POST( LastFieldHD)
      TYPE(Text) NAME(VyrZAK->cNazevZak1)     CPOS( 32,1.2) CLEN( 40) BGND( 13) PP(1)                            GROUPS(10)
    TYPE(END) GROUPS(10)

*   Karta HLA 01
*   nkarta.ccrd 110, 111, 116.01

    TYPE(Static) STYPE(1) SIZE(103, 7.7) FPOS(0.2, 2.6) RESIZE(yx) GROUPS(01)
      TYPE(GET)  NAME(nCisFirmy)              FPOS(  2,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS(  2,0.2) CLEN( 10) GROUPS(01) PUSH(SKL_FIRMY_SEL) NOREVISION()
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 12,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(01)
      TYPE(GET)  NAME(cCislObInt)             FPOS(  2,3.2) FLEN( 35) FCAPTION( Objednávka)        CPOS(  2,2.2) GROUPS(01)
      TYPE(GET)  NAME(cVarSym)                FPOS( 39,3.2) FLEN( 15) FCAPTION( Variabilní symbol) CPOS( 39,2.2) GROUPS(01)
      TYPE(GET)  NAME(nCisFak)                FPOS( 56,3.2) FLEN( 10) FCAPTION( Faktura)           CPOS( 56,2.2)  GROUPS(01)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 68,3.2) FLEN( 10) FCAPTION( Dodací list)       CPOS( 68,2.2)  GROUPS(01)

      TYPE(GET)  NAME(nCenaDokl)              FPOS(  2,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 2,4.2) CLEN(13)  GROUPS(01)
      TYPE(Text) CAPTION(+)                   CPOS( 14,5.2) CLEN(  2) PP(1)  GROUPS(01)
      TYPE(GET)  NAME(nNutneVN)               FPOS( 16,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 16,4.2) GROUPS(01) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                   CPOS( 28,5.2) CLEN(  2) PP(1)  GROUPS(01)
      TYPE(Text) CAPTION(Suma položek)        CPOS( 30,4.2) CLEN( 11) PP(1)  GROUPS(01)
      TYPE(Text) NAME(M->nCelkDokl)           CPOS( 30,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(01)
      TYPE(Text) CAPTION(=)                   CPOS( 45,5.2) CLEN(  2) PP(1)   GROUPS(01)
      TYPE(Text) CAPTION(Kontrolní rozdíl)    CPOS( 48,4.2) CLEN( 14) PP(1)   GROUPS(01)
      TYPE(Text) NAME(nRozPrij)               CPOS( 48,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(01, clrGREY)
    TYPE(END)  GROUPS(01)

*   Karta HLA 11  Pøíjem v zahr. mìnì - s vazbou na dodavatele
*   nkarta.ccrd 117.11

    TYPE(Static) STYPE(1) SIZE(103, 7.7) FPOS(0.2, 2.6) RESIZE(yx) GROUPS(11)
      TYPE(GET)  NAME(nCisFirmy)              FPOS(  2,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS(  2,0.2) CLEN( 10) GROUPS(11) PUSH(SKL_FIRMY_SEL) NOREVISION()
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 12,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(11)
      TYPE(GET)  NAME(cCislObInt)             FPOS(  2,3.2) FLEN( 35) FCAPTION( Objednávka)        CPOS(  2,2.2) GROUPS(11)
      TYPE(GET)  NAME(cVarSym)                FPOS( 39,3.2) FLEN( 15) FCAPTION( Variabilní symbol) CPOS( 39,2.2) GROUPS(11)
      TYPE(GET)  NAME(nCisFak)                FPOS( 56,3.2) FLEN( 10) FCAPTION( Faktura)           CPOS( 56,2.2) GROUPS(11)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 68,3.2) FLEN( 10) FCAPTION( Dodací list)       CPOS( 68,2.2) GROUPS(11)

      TYPE(GET)  NAME(cZahrMena)              FPOS(  2,5.2) FLEN(  8) FCAPTION( Zahr. mìna)       CPOS(  2, 4.2) CLEN(10)  GROUPS(11)
      TYPE(GET)  NAME(nKurZahMen)             FPOS( 12,5.2) FLEN( 12) FCAPTION( Kurz zahr.mìny)   CPOS( 12, 4.2) GROUPS(11)
      TYPE(GET)  NAME(nMnozPrep)              FPOS( 26,5.2) FLEN(  7) FCAPTION( Mn.pøep.)        CPOS( 26, 4.2) GROUPS(11)
      TYPE(GET)  NAME(nCenDokZM)              FPOS( 35,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 35, 4.2) CLEN(13)  GROUPS(11)
      TYPE(GET)  NAME(nNutneVNZM)             FPOS( 49,5.2) FLEN( 11) FCAPTION( Nutné VN)        CPOS( 49, 4.2)           GROUPS(11) POST( LastFieldHD)
      TYPE(Text) NAME(M->nCelkDoklZM)         CPOS( 63,5.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) NAME(M->nRozPrijZM)          CPOS( 77,5.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) NAME(cZahrMena)              CPOS( 89,5.2) CLEN(  5) PP(1) FONT(5)  GROUPS(11)

      TYPE(GET)  NAME(nCenaDokl)              FPOS( 35,6.2) FLEN( 11)        GROUPS(11)
      TYPE(Text) CAPTION(+)                   CPOS( 47,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(GET)  NAME(nNutneVN)               FPOS( 49,6.2) FLEN( 11)        GROUPS(11)
      TYPE(Text) CAPTION(-)                   CPOS( 61,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(Text) CAPTION(Suma položek)        CPOS( 63,4.2) CLEN( 11) PP(1)  GROUPS(11)
      TYPE(Text) NAME(M->nCelkDokl)           CPOS( 63,6.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) CAPTION(=)                   CPOS( 75,6.2) CLEN(  2) PP(1)  GROUPS(11)
      TYPE(Text) CAPTION(Kontrolní rozdíl)    CPOS( 77,4.2) CLEN( 14) PP(1)  GROUPS(11)
      TYPE(Text) NAME(nRozPrij)               CPOS( 77,6.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(11)
      TYPE(Text) CAPTION(CZK)                 CPOS( 89,6.2) CLEN(  5) PP(1) FONT(5)  GROUPS(11)
    TYPE(END)  GROUPS(11)

*   Karta HLA 21
*   nkarta.ccrd 120.21 ::cfg_lFakParSym = .t.

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6) RESIZE(yx) GROUPS(21)
      TYPE(GET)  NAME(cVarSym)                FPOS(  2,1.2) FLEN( 15) FCAPTION( Variabilní symbol)  CPOS(  2,0.2)          GROUPS(21)
      TYPE(GET)  NAME(nCisFak)                FPOS( 19,1.2) FLEN( 15) FCAPTION( Faktura)            CPOS( 19,0.2)          GROUPS(21)
      TYPE(GET)  NAME(nCisloDL)               FPOS( 18,1.2) FLEN( 10) FCAPTION( Dodací list)        CPOS( 18,0.2)          GROUPS(22)

      TYPE(GET)  NAME(nCenaDokl)           FPOS(  2,5.2) FLEN( 11) FCAPTION( Cena na dokladu) CPOS( 2,4.2) CLEN(13)  GROUPS(21)
      TYPE(Text) CAPTION(+)                CPOS( 14,5.2) CLEN(  2) PP(1)  GROUPS(21)
      TYPE(GET)  NAME(nNutneVN)            FPOS( 16,5.2) FLEN( 11) FCAPTION( Nutné VN) CPOS( 15,4.2) GROUPS(21) POST( LastFieldHD)
      TYPE(Text) CAPTION(-)                CPOS( 28,5.2) CLEN(  2) PP(1)  GROUPS(21)
      TYPE(Text) CAPTION(Suma položek)     CPOS( 30,4.2) CLEN( 11) PP(1)  GROUPS(21)
      TYPE(Text) NAME(M->nCelkDokl)        CPOS( 30,5.2) CLEN( 14) CTYPE(2) BGND( 13) FONT(5) PP(1) GROUPS(21)
      TYPE(Text) CAPTION(=)                CPOS( 45,5.2) CLEN(  2) PP(1)   GROUPS(21)
      TYPE(Text) CAPTION(Kontrolní rozdíl) CPOS( 48,4.2) CLEN( 14) PP(1)   GROUPS(21)
      TYPE(Text) NAME(nRozPrij)            CPOS( 48,5.2) CLEN( 14) CTYPE(2) BGND( 13) PP(1) FONT(5) GROUPS(21)
    TYPE(END) GROUPS(21,22)

*   Karta HLA 22
*   nkarta.ccrd 120.22 ::cfg_lFakParSym = .f.

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6) RESIZE(yx) GROUPS(22)
      TYPE(GET)  NAME(cVarSym)             FPOS(  1,1.2) FLEN( 15) FCAPTION( Variabilní symbol)  CPOS( 1,0.2)           GROUPS(22)
      TYPE(GET)  NAME(nCisloDL)            FPOS( 18,1.2) FLEN( 10) FCAPTION( Dodací list)        CPOS( 18,0.2)          GROUPS(22)

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

*   Karta HLA 03
*   nkarta.ccrd 130.03

    TYPE(Static) STYPE(13) SIZE(103, 7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(03)
      TYPE(GET)  NAME(M->mainPohyb)        FPOS( 1,1.2)  FLEN( 6) FCAPTION( Pohyb) CPOS(1,0.2) CLEN( 10)       GROUPS(03)
      TYPE(Text) NAME(C_DrPohy->cNazevPoh) CPOS( 9,1.2)  CLEN( 25) BGND( 13) PP(1)                             GROUPS(03)
      TYPE(GET)  NAME(nCisFirmy)           FPOS( 37,1.2) FLEN( 8) FCAPTION( Dodavatel) CPOS( 37,0.2) CLEN( 10) GROUPS(03) PUSH(SKL_FIRMY_SEL) NOREVISION()
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

*   Karta HLA 41
*   nkarta.ccrd 142.41 ::cfg_lFakParSym = .t.

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(41)
      TYPE(GET)  NAME(nCisFak)            FPOS( 1,1.2) FLEN( 10) FCAPTION( Èís. faktury) CPOS( 1,0.2)  GROUPS(41) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(41)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(41)
    TYPE(END) GROUPS(41)

*   Karta HLA 42
*   nkarta.ccrd 142.42 ::cfg_lFakParSym = .f.

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(42)
      TYPE(GET)  NAME(nCisloDL)           FPOS( 1,1.2) FLEN( 10) FCAPTION( Dodací list)  CPOS( 1,0.2)  GROUPS(42) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(42)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(42)
    TYPE(END) GROUPS(42)

*   Karta HLA 43 
*   nkarta.ccrd 244.43

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(43)
      TYPE(GET)  NAME(nCisFak)             FPOS( 1,1.2) FLEN( 10) FCAPTION( Var. symbol)  CPOS( 1,0.2)  GROUPS(43) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(43)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(43)
    TYPE(END) GROUPS(43)

*   Karta HLA 05
*   nkarta.ccrd 253 255.05

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(05)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  2,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  2,0.2) CLEN( 10) GROUPS(05) PUSH(SKL_FIRMY_SEL) NOREVISION()
      TYPE(GET)  NAME(cNazFirmy)          FPOS( 12,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(05)
      TYPE(GET)  NAME(cCislObInt)         FPOS(  2,3.2) FLEN( 32) FCAPTION( Objednávka) CPOS( 2,2.2)  GROUPS(05)
      TYPE(GET)  NAME(nCisloDL)           FPOS( 36,3.2) FLEN( 10) FCAPTION( Dodací list)CPOS(36,2.2)  GROUPS(05)
      TYPE(COMBOBOX) NAME(M->cIsZahr)     FPOS( 48,3.2) FLEN( 11) FCAPTION( Typ DL)     CPOS(48,2.2)  VALUES(T:Tuzemský,Z:Zahranièní) GROUPS(05)
      TYPE(GET)  NAME(nProcSlev)          FPOS( 61,3.2) FLEN(  8) FCAPTION( Zákl.sleva) CPOS(61,2.2) GROUPS(05) POST( LastFieldHD)
      TYPE(Text) CAPTION( %)              CPOS( 70,3.2) CLEN(  3)                                     GROUPS(05)

      TYPE(Text) CAPTION(Èíslo faktury)   CPOS( 2,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME( nCisFak)           CPOS( 2,6.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(05, clrGREY)
      TYPE(Text) CAPTION(Cena na dokladu) CPOS(30,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS(30,6.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(05, clrGREY)
      TYPE(Text) CAPTION(PC bez danì)     CPOS(44,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS(44,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(05, clrGREY)
      TYPE(Text) CAPTION(PC s daní)       CPOS(58,5.2) CLEN( 13)                                     GROUPS(05)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS(58,6.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1)            GROUPS(05, clrGREY)
    TYPE(END) GROUPS(05)

*   Karta HLA 06
*   nkarta.ccrd 263.06

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(06)
      TYPE(GET)  NAME(nCisloDL)  FPOS( 1,1.2) FLEN( 10) FCAPTION( Dodací list) CPOS( 1,0.2) GROUPS(06) POST( LastFieldHD)

      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 31,2.2) CLEN( 13)                                     GROUPS(06)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS( 31,3.2) CTYPE( 2) CLEN( 13) BGND( 13) PP(1)           GROUPS(06)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 45,2.2) CLEN( 10)                          GROUPS(06)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS (45,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(06)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 59,2.2) CLEN( 10)                          GROUPS(06)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 59,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(06)
    TYPE(END) GROUPS(06)

*   Karta HLA 07
*   nkarta.ccrd 274.07

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(07)
      TYPE(GET)  NAME(cCislObInt)    FPOS(  2,1.2) FLEN( 35) FCAPTION( Èíslo zakázky)      CPOS(  2,0.2) GROUPS(07) PUSH(SKL_OBJHEAD_SEL) POST( LastFieldHD)
      TYPE(Text) CAPTION(Cena na dokladu)  CPOS( 55,0.2) CLEN( 13)                                     GROUPS(07)
      TYPE(Text) NAME(M->nCelkDOKL)        CPOS (55,1.2) CTYPE(2) CLEN( 13) BGND( 13) PP(1)            GROUPS(07, clrGREY)
    TYPE(END) GROUPS(07)

*   Karta HLA 08
*   nepopoužíváno

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(08)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(08) PUSH(SKL_FIRMY_SEL) NOREVISION()
      TYPE(GET)  NAME(cNazFirmy)              FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(08)
      TYPE(GET)  NAME(nCisFak)            FPOS( 38,1.2) FLEN( 10) FCAPTION( Èís. paragonu) CPOS( 38,0.2) GROUPS(08) POST( LastFieldHD)

      TYPE(Text) CAPTION(Cena na dokladu) CPOS( 23,2.2) CLEN( 13)                           GROUPS(08)
      TYPE(Text) NAME(M->nCelkDOKL)       CPOS (23,3.2) CTYPE( 2) CLEN( 13) BGND( 13) PP(1) GROUPS(08)
      TYPE(Text) CAPTION(PC bez danì)     CPOS( 38,2.2) CLEN( 13)                          GROUPS(08)
      TYPE(Text) NAME(M->nCelkPCB)        CPOS( 38,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(08)
      TYPE(Text) CAPTION(PC s daní)       CPOS( 53,2.2) CLEN( 13)                          GROUPS(08)
      TYPE(Text) NAME(M->nCelkPCS)        CPOS( 53,3.2) CLEN( 13) CTYPE(2) BGND( 13) PP(1) GROUPS(08)
    TYPE(END) GROUPS(08)

*   Karta HLA 09
*   nkarta.ccrd 283 293 299.09

    TYPE(Static) STYPE(13) SIZE(103,7.7)  FPOS(0.2,2.6)  RESIZE(yx) GROUPS(09)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(09) PUSH(SKL_FIRMY_SEL) NOREVISION()
      TYPE(GET)  NAME(cNazFirmy)          FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(09)
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

*   Karta HLA 80
*   nkarta.ccrd 305.80

    TYPE(Static) STYPE(13) SIZE(103,7.7) FPOS(0.2,2.6)  RESIZE(yx) GROUPS(80)
      TYPE(GET)  NAME(nCisFirmy)          FPOS(  1,1.2) FLEN(  8) FCAPTION( Odbìratel)  CPOS(  1,0.2) CLEN( 10) GROUPS(80) PUSH(SKL_FIRMY_SEL) NOREVISION() POST(LastFieldHD)
      TYPE(GET)  NAME(cNazFirmy)          FPOS( 11,1.2) FLEN( 50)   BGND( 13) PP(1)                             GROUPS(80)
    TYPE(END) GROUPS(80)

  TYPE(End)
TYPE(End)