TYPE(drgForm) DTYPE(10) TITLE(Dodavatelé zboží) SIZE(110,24) FILE(DODZBOZ);
              GUILOOK(Action:y,IconBar:y);
              POST( postVALIDATE)

TYPE(Action) CAPTION(info C~eník) EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

TYPE(TabPage) CAPTION(Seznam dodavatelù) RESIZE(yy) OFFSET( 1,80) PRE( tabSelect)

* dodZboz
    TYPE(Static) STYPE(13) SIZE(110,9.7) FPOS(0,.1) RESIZE(yy)
      TYPE(DBrowse) FILE(DODZBOZ) INDEXORD(5)            ;
                    FIELDS( M->hlavniDod:HL:2.7::2     , ;
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
                    FPOS(-.2, -.1) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy);
                    ITEMMARKED( ItemMarked) POPUPMENU(y)
    TYPE(End)

* info skladové položky
    TYPE(Static) STYPE(12) SIZE(109.8, 3) FPOS( 0.1, 9.8) CTYPE(2) RESIZE(yn)

      TYPE(STATIC) STYPE(3) FPOS( -.3, .11) SIZE( 23,45 ) CAPTION(337)

      TYPE(Text) CAPTION(Sklad)            CPOS(  3, 0.3) CLEN( 10) FONT(2)
      TYPE(Text) NAME(CENZBOZ->cCisSklad)  CPOS(  3, 1.5) CLEN( 10) BGND(11) FONT(5) GROUPS(clrBLUE)
      TYPE(Text) NAME(C_SKLADY->cNazSklad) CPOS( 14, 1.5) CLEN( 25) BGND(11) FONT(5) GROUPS(clrBLUE)
      TYPE(Text) CAPTION(Sklad. položka)   CPOS( 45, 0.3) CLEN( 20) FONT(2)
      TYPE(Text) NAME(CENZBOZ->cSklPol)    CPOS( 45, 1.5) CLEN( 20) BGND(11) FONT(5) GROUPS(clrGREEN)
      TYPE(Text) CAPTION(Název zboží)      CPOS( 66, 0.3) CLEN( 40) FONT(2)
      TYPE(Text) NAME(CENZBOZ->cNazZbo)    CPOS( 66, 1.5) CLEN( 40) BGND(11) FONT(5) GROUPS(clrGREEN)
    TYPE(End)

* možnost nastavení pøíjmových dokladù OD-DO
    TYPE(Static) STYPE(13) SIZE( 109,1.3) FPOS( 0, 12.8)  RESIZE(yx)
      TYPE(Text) CAPTION(PØÍJMOVÉ DOKLADY)  CPOS(   5, 0.1) CLEN(20) FONT(5)
      TYPE(Text) CAPTION(od:)               CPOS(  30, 0.1) CLEN( 4) FONT(5)
      TYPE(GET)  NAME(M->dPrijemOd)         FPOS(  35, 0.1) FLEN(12) PUSH(CLICKDATE)
      TYPE(Text) CAPTION(do:)               CPOS(  50, 0.1) CLEN( 4) FONT(5)
      TYPE(GET)  NAME(M->dPrijemDo)         FPOS(  55, 0.1) FLEN(12) PUSH(CLICKDATE)
    TYPE(End)

* pvpitem
    TYPE(DBrowse) FILE(PVPITEM) INDEXORD(20)                    ;
                  FIELDS( nDoklad                             , ;
                          dDatPVP:datPohybu:10                , ;
                          cObdPoh:obdPoh                      , ;
                          nCenNapDod:cena_Mj:13               , ;
                          nMnozPrDOD:množDok:13               , ;
                          nCenaCelk:cenaCelk:13               , ;
                          cTypPohybu:typPoh:8                 , ;
                          C_TypPoh->cNazTypPoh:název pohybu:30, ;
                          cCisZakaz:zakázka                   , ;
                          cUcetSkup:úèSkup:10                 , ;
                          nZboziKat:katZbo:5                  , ;
                          cNazPol1:výrStøedisko               , ;
                          cNazPol2:výrobek                    , ;
                          cNazPol3:zakázka                    , ;
                          cNazPol4:výrMísto                   , ;
                          cNazPol5:stroj                      , ;
                          cNazPol6:výrOperace                   ) ;
                  FPOS(0, 14.2) SIZE(110, 8.8) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy);
                  POPUPMENU(n) FOOTER(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) RESIZE(yy) OFFSET(20,65) PRE( tabSelect)

    TYPE(Static) STYPE(2) SIZE( 108, 12.5) FPOS( 1, 0) RESIZE(yn)
      TYPE(STATIC) STYPE(16) CPOS( 1,2) SIZE(105, 1.5 )
      TYPE(STATIC) STYPE(16) CPOS( 1,2) SIZE(105, 1.6 )

      TYPE(STATIC) STYPE(16) CPOS( 1,2) SIZE(105, 9.4 )
* Dodavatel
      TYPE(Text) CAPTION(Èíslo dodavatele) CPOS( 1, 1) CLEN( 15)
      TYPE(GET)      NAME(NCISFIRMY)       FPOS(20, 1) FLEN( 15) FONT(5) PUSH(FIRMY_SEL)
      TYPE(GET)      NAME(cNAZEV)          FPOS(37, 1) FLEN( 67) FONT(5) BGND( 13)

* 1.sl.
      TYPE(COMBOBOX) NAME(lHlavniDOD) FPOS(20, 3) FLEN(16) FCAPTION(Hlavní dodavatel)        CPOS(1,3) REF(LYESNO)
      TYPE(GET)      NAME(NCENAOZBO)  FPOS(20, 4) FLEN(15) FCAPTION(Objednávací cena)        CPOS(1,4)
      TYPE(GET)      NAME(NCENANZBO)  FPOS(20, 5) FLEN(15) FCAPTION(Nákupní cena)            CPOS(1,5)
      TYPE(GET)      NAME(NMINOBMNOZ) FPOS(20, 6) FLEN(15) FCAPTION(Minim. objednací množ.)  CPOS(1,6)
      TYPE(GET)      NAME(NMINEXMNOZ) FPOS(20, 7) FLEN(15) FCAPTION(Minim. expedièní množ.)  CPOS(1,7)
      TYPE(GET)      NAME(CZKRATJEDN) FPOS(20, 8) FLEN(15) FCAPTION(Mìrná jednotka)          CPOS(1,8)
* 2.sl
      TYPE(GET) NAME(CZKRATMENY) FPOS(65, 3) FLEN(15) FCAPTION(Zahranièní mìna)       CPOS(45, 3)
      TYPE(GET) NAME(NCENNAKZM)  FPOS(65, 4) FLEN(15) FCAPTION(Nákup.cena(zahr.mìna)) CPOS(45, 4)
      TYPE(GET) NAME(CKATCZBO)   FPOS(65, 5) FLEN(15) FCAPTION(Katalogové ozn.)       CPOS(45, 5)
      TYPE(GET) NAME(NDODLHUTA)  FPOS(65, 6) FLEN(15) FCAPTION(Dod.lhùta (dny))       CPOS(45, 6)
      TYPE(GET) NAME(DDATPNAK)   FPOS(65, 7) FLEN(15) FCAPTION(Dat.posl.nákupu)       CPOS(45, 7) PUSH(CLICKDATE)
      TYPE(GET) NAME(CNAZDOD1)   FPOS(65, 8) FLEN(30) FCAPTION(Název u dodavatele 1)  CPOS(45, 8)
      TYPE(GET) NAME(CNAZDOD2)   FPOS(65, 9) FLEN(30) FCAPTION(Název u dodavatele 2)  CPOS(45, 9)
*
      TYPE(GET) NAME(CZKRCARKOD) FPOS(20, 10.6) FLEN(15) FCAPTION(Typ èárového kódu)  CPOS( 1, 10.6)
      TYPE(GET) NAME(CCARKOD)    FPOS(20, 11.6) FLEN(85) FCAPTION(Èárový kód)         CPOS( 1, 11.6)

    TYPE(End)
*
    TYPE(Static) STYPE(12) SIZE( 108, 10) FPOS( 1, 13) RESIZE(yy)
      TYPE(Static) STYPE( 12) SIZE(110, 1.2) FPOS( 0, 0) RESIZE(yn)
        TYPE(Text) CAPTION(Poznámka k dodavateli)  CPOS( 1, 0.1) CLEN( 20)
      TYPE(End)
      TYPE(MLE)  NAME('MPOZDOD') FPOS( 0, 1.1) SIZE(108, 5.5) RESIZE(yy)
    TYPE(End)

TYPE(End)

