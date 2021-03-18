TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží ro) SIZE(105,25) FILE(CENZBOZ) ;
              CARGO( SKL_CENZBOZ_CRD) OBDOBI(SKL) ISREADONLY(Y) ;
              PRINTFILES(cenzboz:ccissklad=ccissklad+csklpol=csklpol, ;
                         pvpitem:ccissklad=ccissklad+csklpol=csklpol)

TYPE(Static) STYPE(13) SIZE(105,12.8) FPOS(0,1.2) RESIZE(yy)
  TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(3) FPOS(0.1,0.1) ;
               FIELDS( CenZBOZ_isAktivni():Akt:2.6::2  ,;
                       CCISSKLAD     ,;
                       CSKLPOL       ,;
                       CNAZZBO::30   ,;
                       NMNOZSZBO     ,;
                       cZkratJedn:MJ ,;
                       NCENASZBO     ,;
                       NCENACZBO     ,;
                       CNAZZBO2::30    )     ;
               SIZE(105,12.6) CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy);
               ITEMMARKED( ItemMarked) POPUPMENU(y)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 104.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(CENÍK ZBOŽÍ) CPOS( 45, 0.1) CLEN( 20) FONT(5)

  TYPE(Static) STYPE(1)       SIZE(23,1.2)  FPOS( 81.5,0.1)  RESIZE(nx)
  TYPE(PushButton) POS(0,0)   SIZE(23,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)

  TYPE(End)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,11) FPOS(0,13.9) RESIZE(yy)

* Základní údaje
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(1,82) PRE( tabSelect)

*   1.ø.
    TYPE(Text) CAPTION(Sklad)           CPOS(  3, 0.5) CLEN(  8)
    TYPE(Text) NAME(cCisSklad)          CPOS(  3, 1.5) CLEN(  8) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Sklad. položka)  CPOS( 13, 0.5) CLEN( 15)
    TYPE(Text) NAME(cSklPol)            CPOS( 13, 1.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název zboží 2)   CPOS( 30, 0.5) CLEN( 30)
    TYPE(Text) NAME(cNazZbo2)           CPOS( 30, 1.5) CLEN( 30) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Kateg.)          CPOS( 62, 0.5) CLEN(  6)
    TYPE(Text) NAME(nZboziKat)          CPOS( 62, 1.5) CLEN(  6) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Úè.sk.)          CPOS( 70, 0.5) CLEN(  6)
    TYPE(Text) NAME(nUcetSkup)          CPOS( 70, 1.5) CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Místo uložení)   CPOS( 77, 0.5) CLEN( 15)
    TYPE(Text) NAME(cUlozZbo)           CPOS( 77, 1.5) CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
* 2.ø.
    TYPE(Text) CAPTION(Typ ceny)        CPOS(  3, 2.5) CLEN(  8)
    TYPE(Text) NAME(cTypSklCen)         CPOS(  3, 3.5) CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skl. cena)       CPOS( 13, 2.5) CLEN( 13)
    TYPE(Text) NAME(nCenaSZBO)          CPOS( 13, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) NAME(cZkratMeny)         CPOS( 26, 3.5) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Množ. na skladì) CPOS( 33, 2.5) CLEN( 13)
    TYPE(Text) NAME(nMnozSZBO)          CPOS( 33, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) NAME(cZkratJedn)         CPOS( 46, 3.5) CLEN(  4) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skl. cena CELK)  CPOS( 52, 2.5) CLEN( 13)
    TYPE(Text) NAME(nCenaCZBO)          CPOS( 52, 3.5) CLEN( 13) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Jakost)         CPOS( 67, 2.5) CLEN( 10)
    TYPE(Text) NAME(cJakost)            CPOS( 67, 3.5) CLEN( 20) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)

* 3.ø.
    TYPE(Text) CAPTION(Pol.ceníku)      CPOS(  3, 4.5) CLEN(  8)
    TYPE(Text) NAME(cPolCen)            CPOS(  3, 5.5) CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ cz-cpa)      CPOS( 13, 4.5) CLEN( 17)
    TYPE(Text) NAME(ctypCZcpa)          CPOS( 13, 5.5) CLEN( 17) BGND( 13) PP(2) GROUPS(clrGREY)

*    TYPE(Text) CAPTION(Typ SKP)         CPOS( 13, 4.5) CLEN( 17)
*    TYPE(Text) NAME(cTypSkp)            CPOS( 13, 5.5) CLEN( 17) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Daòová položka)  CPOS( 32, 4.5) CLEN( 17)
    TYPE(Text) NAME(cDanPZBO)           CPOS( 32, 5.5) CLEN( 17) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èíslo JKPOV)     CPOS( 51, 4.5) CLEN( 15)
    TYPE(Text) NAME(cJKPOV)             CPOS( 51, 5.5) CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Katalog. èíslo)  CPOS( 68, 4.5) CLEN( 17)
    TYPE(Text) NAME(cKatCZBO)           CPOS( 68, 5.5) CLEN( 17) BGND( 13) PP(2) GROUPS(clrGREY)
* 4.ø.
    TYPE(Text) CAPTION(Mn. k dispozici) CPOS(  3, 6.5) CLEN( 12)
    TYPE(Text) NAME(nMnozDZBO)          CPOS(  3, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. rezervované) CPOS( 17, 6.5) CLEN( 12)
    TYPE(Text) NAME(nMnozRZBO)          CPOS( 17, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. objednané)   CPOS( 31, 6.5) CLEN( 12)
    TYPE(Text) NAME(nMnozOZBO)          CPOS( 31, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. k objednání) CPOS( 45, 6.5) CLEN( 12)
    TYPE(Text) NAME(nMnozKZBO)          CPOS( 45, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena bez danì)   CPOS( 62, 6.5) CLEN( 12)
    TYPE(Text) NAME(nCenaPZBO)          CPOS( 62, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION( DPH )           CPOS( 75, 6.5) CLEN(  5)
    TYPE(Text) NAME(C_DPH->nProcDph)    CPOS( 75, 7.5) CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( % )             CPOS( 80, 7.5) CLEN(  3)

    TYPE(Text) CAPTION(Cena s daní)     CPOS( 84, 6.5) CLEN( 12)
    TYPE(Text) NAME(nCenaMZBO)          CPOS( 84, 7.5) CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* Pohyby skl. položky
  TYPE(TabPage) TTYPE(4) CAPTION(Pohyby) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(18,66) PRE( tabSelect)

    TYPE(DBrowse) FILE(PVPITEM) INDEXORD(28) ;
                  FIELDS( cTypPohybu:Pohyb,;
                          C_TYPPOH->cNazTypPoh:Název pohybu:20,;
                          nDoklad,;
                          dDatPVP:DatPohybu,;
                          cObdPoh:ObdPoh,;
                          nCenNapDod,;
                          nMnozPrDOD,;
                          nCenaCelk ,;
                          nCisFak   ,;
                          nCisloDL  ,;
                          nCisFirmy ,;
                          PVPHEAD->cNazFirmy,;
                          cCisZakaz ,;
                          cNazPol1  ,;
                          cNazPol2  ,;
                          cNazPol3  ,;
                          cNazPol4  ,;
                          cNazPol5  ,;
                          cNazPol6  ,;
                          nMnozsZBO ,;
                          nCenacZBO );
                  SIZE(104.0,9.7) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy);
                  ITEMMARKED( ItemMarked1) POPUPMENU(n)
  TYPE(End)


* Detail položky
  TYPE(TabPage) TTYPE(4) CAPTION(Detail pohybu) FPOS(0.5,0.1) SIZE( 104.5,10.9) RESIZE(yx) OFFSET(34,50) PRE( tabSelect)
*   INFO
*   1.øádek
    TYPE(Text) CAPTION(Sklad)             CPOS(  3, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->cCisSklad)   CPOS(  3, 1.5)   CLEN( 10) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Sklad. položka)    CPOS( 15, 0.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cSklPol)     CPOS( 15, 1.5)   CLEN( 20) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název zboží)       CPOS( 37, 0.5)   CLEN( 30)
    TYPE(Text) NAME(PVPITEM->cNazZbo)     CPOS( 37, 1.5)   CLEN( 30) BGND( 13) PP(2) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Úè.skup.)          CPOS( 69, 0.5)   CLEN(  8)
    TYPE(Text) NAME(PVPITEM->nUcetSkup)   CPOS( 69, 1.5)   CLEN(  5) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 77, 0.5)   CLEN(  8)
    TYPE(Text) NAME(C_TYPPOH->cNazTypPoh)  CPOS( 77, 1.5)   CLEN( 25) BGND( 13) PP(2)GROUPS(clrGREY)
*   2.øádek
    TYPE(Text) CAPTION(Mn. na dokl.)       CPOS(  3, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nMnozPrDod)   CPOS(  3, 3.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2)  GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ)                 CPOS( 16, 2.5)   CLEN(  5)
    TYPE(Text) NAME(PVPITEM->cZkratJedn)   CPOS( 16, 3.5)   CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena na dokl.)      CPOS( 23, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenNapDod)   CPOS( 23, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena CELKEM)        CPOS( 37, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaCelk)    CPOS( 37, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(PC bez Dph)         CPOS( 51, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPZBO)    CPOS( 51, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(% Dph)              CPOS( 65, 2.5)   CLEN(  6)
    TYPE(Text) NAME(C_DPH->nProcDph)       CPOS( 65, 3.5)   CLEN(  6) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(PC s Dph)           CPOS( 73, 2.5)   CLEN( 12)
    TYPE(Text) NAME(PVPITEM->nCenaPDZBO)   CPOS( 73, 3.5)   CLEN( 12) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
*   3.øádek
    TYPE(Text) CAPTION(Faktura)           CPOS(  3, 4.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisFak)     CPOS(  3, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Dodací list)       CPOS( 15, 4.5)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->nCisloDL)    CPOS( 15, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Obj. vystavená)    CPOS( 27, 4.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCisObj)     CPOS( 27, 5.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Obj. pøijatá)      CPOS( 44, 4.5)   CLEN( 15)
    TYPE(Text) NAME(PVPITEM->cCislObInt)  CPOS( 44, 5.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Firma)             CPOS( 61, 4.5)   CLEN(  6)
    TYPE(Text) NAME(PVPHEAD->nCisFirmy)   CPOS( 61, 5.5)   CLEN(  6) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název firmy)       CPOS( 69, 4.5)   CLEN( 12)
    TYPE(Text) NAME(PVPHEAD->cNazFirmy)   CPOS( 69, 5.5)   CLEN( 30) BGND( 13) PP(2) GROUPS(clrGREY)


*   Nákladová struktura
    TYPE(Text) CAPTION( Stredisko)             CPOS(  3, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol1)         CPOS(  3, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Výkon)                 CPOS( 20, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol2)         CPOS( 20, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Zakázka)               CPOS( 37, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol3)         CPOS( 37, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Výr. místo)            CPOS( 54, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol4)         CPOS( 54, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Stroj)                 CPOS( 71, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol5)         CPOS( 71, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( Výr. operace)          CPOS( 88, 7)   CLEN( 10)
    TYPE(Text) NAME(PVPITEM->cNazPol6)         CPOS( 88, 8)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Dodavatelé) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(50,34) PRE( tabSelect)

    TYPE(DBrowse) FILE(DODZBOZ) INDEXORD(5);
                  FIELDS( HLAVNIDOD():Hlavní:1::2,;
                          NCISFIRMY:Èíslo,;
                          CNAZEV:Název dodavatele:30,;
                          NCENANZBO  ,;
                          DDATPNAK   ,;
                          CKATCZBO   ,;
                          NMINOBMNOZ ,;
                          NMINEXMNOZ ,;
                          CZKRATJEDN ,;
                          NCENNAKZM  ,;
                          CZKRATMENY ,;
                          NDODLHUTA  );
                  FPOS(0, 0) SIZE(104,9.7) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y)
  TYPE(End)

* Místa uložení
  TYPE(TabPage) TTYPE(4) CAPTION(Místa uložení) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(66,18) PRE( tabSelect)
        TYPE(DBrowse) FILE(ULOZENI) INDEXORD(1);
                  FIELDS( cUlozZbo   ,;
                          NazMistULOZ():Název místa,;
                          nPocStav   ,;
*                          nUlozMnoz  ,;
                          nUlozCelk  );
                  FPOS(0, 0) SIZE(104,9.7) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y)
  TYPE(End)

* Pøepoèet MJ
  TYPE(TabPage) TTYPE(4) CAPTION(Pøepoèet MJ) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(82,1) PRE( tabSelect)

    TYPE(DBrowse) FILE(C_PrepMJ) INDEXORD(2);
                FIELDS( nPocVychMJ:Poèet výchozích MJ,;
                        cVychoziMJ::7 ,;
                        nPocCilMJ:Poèet cílových MJ  ,;
                        cCilovaMJ::7  ,;
                        nKoefPrVC:Koeficient pøepoètu V->C  );
                SIZE(104,9.7) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y)

  TYPE(End)


TYPE(End)

