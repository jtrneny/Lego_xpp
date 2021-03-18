TYPE(drgForm) DTYPE(10) TITLE(Ceník zboží ...) SIZE(105,25) FILE(CENZBOZ) ;
              CARGO( SKL_CENZBOZ_CRD) OBDOBI(SKL);
              PRINTFILES(cenzboz:ccissklad=ccissklad+csklpol=csklpol, ;
                         pvpitem:ccissklad=ccissklad+csklpol=csklpol, ;
                         cecarkod:ccissklad=ccissklad+csklpol=csklpol)

TYPE(Action) CAPTION(~Dodavatelé)      EVENT(Cenik_DODAVATELE)  TIPTEXT(Seznam dodavatelských firem)
TYPE(Action) CAPTION(odbìrate~Lé)      EVENT(Cenik_ODBERATELE)  TIPTEXT(Seznam odbìratelských firem - zalistované položky)
TYPE(Action) CAPTION(~Místa uložení)   EVENT(Cenik_MISTAULOZ)   TIPTEXT(Místa uložení daného zboží)
TYPE(Action) CAPTION(~Výrobní èísla)   EVENT(Cenik_VYROBCIS)    TIPTEXT(Evidence výrobních èísel daného zboží)
TYPE(Action) CAPTION(~Pohyby)          EVENT(Cenik_POHYBY  )    TIPTEXT(Pohyby daného zboží)
TYPE(Action) CAPTION(~Pohyby Od/Do)    EVENT(Cenik_pohyby_oDDo) TIPTEXT(Pohyby daného zboží oD-Do )
TYPE(Action) ATYPE(5)

TYPE(Action) CAPTION(pøepoèty M~J)     EVENT(Cenik_PrepoctyMJ) TIPTEXT(Pøepoèty mìrné jednotky)
TYPE(Action) CAPTION(pø~Ecenit sklad)  EVENT(Cenik_Preceneni)  TIPTEXT(Automatizované pøecenìní skladu z kalkulací)
TYPE(Action) CAPTION(èár~Kódy)         EVENT(Cenik_CarKody)    TIPTEXT(Pøiøazení(-é) èárové kódy)

TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(stav za o~Bbdobí) EVENT(Cenik_StavObd)    TIPTEXT(Stav za období)
TYPE(Action) CAPTION(stav ke dn~I)     EVENT(Cenik_StavDen)    TIPTEXT(Stav ke dni)


TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(tisk èárKódù)     EVENT(Cenik_TiskCarKodu) TIPTEXT(Tisk èárových kódù)
*
TYPE(Action) CAPTION(~Oprava dokladu)  EVENT(Cenik_skl_POHYBYHD)   TIPTEXT(Oprava skladového dokladu)


*TYPE(Action) CAPTION(Test_1)           EVENT(Test_01)       TIPTEXT(Pohyb vybraných zásob)
*TYPE(Action) CAPTION(Test_2)           EVENT(Test_02)       TIPTEXT(Pohyb vybraných zásob_2)
*TYPE(Action) CAPTION(Test_3)           EVENT(Test_03)       TIPTEXT(Spotøeba krmiv dle druhù zvíøat)
*TYPE(Action) CAPTION(Test_4)           EVENT(Test_04)       TIPTEXT(Spotøeba krmiv dle stájí)
*TYPE(Action) CAPTION(Test_5)           EVENT(Test_05)       TIPTEXT(Spotøeba PHM)

TYPE(Static) STYPE(13) SIZE(105,12.8) FPOS(0,1.2) RESIZE(YY)
  TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(3) FPOS(0.1,0.2)  ;
               FIELDS( M->poc_dodZboz:dOd:3:999        , ; 
                       M->is_inPrepmj:pMj:2.6::2       , ;
                       CenZBOZ_isAktivni():Akt:2.6::2  , ;
                       cenZboz_isUlozeni():ul:2.6::2   , ; 
                       cenZboz_isceCarKod():ean:2.1::2 , ;
                       CCISSKLAD ,;
                       CSKLPOL   ,;
                       CNAZZBO::30   ,;
                       NMNOZSZBO ,;
                       cZkratJedn:MJ  ,;
                       NCENASZBO,;
                       NCENACZBO,;
                       CULOZZBO,;
                       CNAZZBO2::30) ;
               SIZE(104.6,12.6) CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(YY);
               ITEMMARKED( ItemMarked) POPUPMENU(y)
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 104.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
  TYPE(Text)     CAPTION(CENÍK ZBOŽÍ) CPOS( 45, 0.1) CLEN( 20) FONT(5)

  TYPE(Static) STYPE(1)       SIZE(23,1.2)  FPOS( 81.5,0.1)  RESIZE(nx)
    TYPE(PushButton) POS(0,0)   SIZE(23,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,10) FPOS(0,14.1) RESIZE(yx)
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
    TYPE(Static) STYPE(13) SIZE(104,9) FPOS(0.3, 0.2)  RESIZE(yx)

      TYPE(DBrowse) FILE(PVPITEM) INDEXORD(28) ;
                    FIELDS( cTypPohybu:Pohyb,;
                            C_TYPPOH->cNazTypPoh:Název pohybu:20,;
                            nDoklad,;
                            dDatPVP:datPohybu:10,;
                            cObdPoh:obdPoh,;
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
                            nCenacZBO ,;
                            OBJVYSHD->cZakObjInt );
                    RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy);
                    ITEMMARKED( ItemMarked1) POPUPMENU(n)
    TYPE(End)
  TYPE(End)

* Detail položky
  TYPE(TabPage) TTYPE(4) CAPTION(Detail pohybu) FPOS(0.5,0.1) SIZE( 104.5,10.9) RESIZE(yx) OFFSET(34,49) PRE( tabSelect)
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

* tabPage se nemá kam potavit na focus - !
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* pøepoèty mìrných jednotek c_prepmjW
  TYPE(TabPage) TTYPE(4) CAPTION( pøepoèty_mj) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(50,33) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(104,9) FPOS(0.3, 0.2)  RESIZE(yx)

      TYPE(DBrowse) FILE(c_prepmjW)                          ;
                    FIELDS( ccisSklad:sklad                , ;
                            csklPol:sklPoložka             , ; 
                            cenZboz->cnazZbo:název zboží:30, ;
                            npocVYCHmj:poèetVých_mj:10     , ;
                            cvychoziMj:výchozí_mj          , ;
                            ccilovaMj:cílová_mj            , ; 
                            npocCILMj:poèetCíl_mj:10       , ;
                            nkoefPRvc:koefPøep:10            ) ;                          
                    RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy);
                    ITEMMARKED( ItemMarked1) POPUPMENU(n)
    TYPE(End)
  TYPE(End)

* dodavatelé zboží ddoZboz
  TYPE(TabPage) TTYPE(4) CAPTION( dodatatelé) FPOS(0.5,0.1) SIZE(104.5,10.9) RESIZE(yx) OFFSET(66,17) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(104,9) FPOS(.3,.2)  RESIZE(yx)

       TYPE(DBrowse) FILE(dodZboz) FPOS(-.3,.1)           ;
                     FIELDS( M->is_hlavniDod:hD:2.7::2  , ;
                             M->is_Aktivni:aF:2.8::2    , ;
                             NCISFIRMY:èísloFirmy       , ;
                             CNAZEV:Název dodavatele:37 , ;
                             CKATCZBO:katalOzn:15       , ;           
                             NCENANZBO:nákCena_CZ:13    , ;
                             NCENNAKZM:nákCena_ZM:13    , ;
                             NCENAOZBO:objCena:13       , ;
                             CZKRATMENY:mìna:4          , ;   
                             DDATPNAK:datNákupu:10      , ;
                             NMINOBMNOZ:minObjMnož:13   , ;
                             CZKRATJEDN:mj              , ;                       
                             NDODLHUTA:dodLhuta           ) ; 
                      RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) ;
                      ITEMMARKED( ItemMarked1) POPUPMENU(n)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)
  TYPE(End)

TYPE(End)
