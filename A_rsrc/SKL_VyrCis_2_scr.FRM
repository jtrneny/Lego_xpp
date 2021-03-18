TYPE(drgForm) DTYPE(10) TITLE(Evidence výrobních èísel) SIZE(100,25) FILE(VYRCIS);
              CARGO( SKL_VYRCIS_CRD) GUILOOK(Action:y) ;
              PRE(preValidate) POST(postValidate)

TYPE(Action) CAPTION(info C~eník)   EVENT( SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) ATYPE( 5)

* Ceník zboží - seznam
  TYPE(Static) STYPE(13) SIZE( 99.6,1.1) FPOS( 0.2, 0.1)  RESIZE(yn) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Seznam výrobních èísel) CPOS( 35, 0.1) CLEN( 30) FONT(5)
  TYPE(End)

  TYPE(DBrowse) FILE(VYRCIS) INDEXORD(1) ;
                FIELDS( nPoradi    ,;
                        cVyrobCIS  ,;
                        cCisSklad  ,;
                        cSklPol    ,;
                        CenZboz->cNazZbo::28 ,;
                        nZust      ,;
                        nDoklad:Èís.pøíjemky ,;
                        dDatPrijem ,;
                        nMnozP     ,;
                        nDokladV:Èís.výdejky ,;
                        dDatProdej ,;
                        nMnozV     ,;
                        nZaruka    ,;
                        nMnozPoc   ,;
                        nMNOZ      ,;
                        cVady      );
                 FPOS(0, 1.1 )SIZE(100, 13.8) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy) ;
                 ITEMMARKED( ItemMarked) ITEMSELECTED( ItemSelected) POPUPMENU(yy)

  TYPE(TabPage) TTYPE(4) CAPTION( Detail výr.èísla) FPOS(0.5,15.1) SIZE( 99.2, 9.8) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*
    TYPE(Text) CAPTION(Výrobní èíslo)      CPOS( 3, 1) CLEN( 12) FONT(5)
    TYPE(TEXT) NAME( cVyrobCis)            CPOS(19, 1) CLEN( 30) FONT(5) BGND(13) PP(2) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Množství pøijaté)   CPOS( 3, 2) CLEN( 12)
    TYPE(TEXT) NAME( nMnozP)               CPOS(19, 2) CLEN( 17) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Množství vydané)    CPOS( 3, 3) CLEN( 13)
    TYPE(TEXT) NAME( nMnozV)               CPOS(19, 3) CLEN( 17) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Zùstatek)           CPOS( 3, 4) CLEN( 12)
    TYPE(TEXT) NAME( nZust)                CPOS(19, 4) CLEN( 17) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION( Zkr. èár.kódu)     CPOS( 3, 5) CLEN( 15)
    TYPE(TEXT) NAME(cZkrCarKod)            CPOS(19, 5) CLEN( 17) BGND(13) PP(2)
    TYPE(Text) CAPTION( Èárový kód)        CPOS( 3, 6) CLEN( 15)
    TYPE(TEXT) NAME(cCarKod)               CPOS(19, 6) CLEN( 75) BGND(13) PP(2)
    TYPE(Text) CAPTION( Vady - chyby)      CPOS( 3, 7) CLEN( 15)
    TYPE(TEXT) NAME(CVADY)                 CPOS(19, 7) CLEN( 75) BGND(13) PP(2)
*
    TYPE(Text) CAPTION(Doklad o pøíjmu)   CPOS(55, 1) CLEN( 15)
    TYPE(TEXT) NAME(NDOKLAD)              CPOS(72, 1) CLEN( 15) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Datum pøíjmu)      CPOS(55, 2) CLEN( 15)
    TYPE(TEXT) NAME(dDatPrijem)           CPOS(72, 2) CLEN( 15) BGND(13) PP(2)

    TYPE(Text) CAPTION(Doklad o výdeji)   CPOS(55, 3) CLEN( 15)
    TYPE(TEXT) NAME(NDOKLADV)             CPOS(72, 3) CLEN( 15) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) CAPTION(Datum výdeje)      CPOS(55, 4) CLEN( 15)
    TYPE(TEXT) NAME(dDatProdej)           CPOS(72, 4) CLEN( 15) BGND(13) PP(2)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(Výdeje výr.èísla) FPOS(0.5,15.1) SIZE( 99.2, 9.8) RESIZE(yx) OFFSET(18,63) PRE( tabSelect)

    TYPE(DBrowse) FILE(VYRCISV) INDEXORD(2) ;
                  FIELDS( cVyrobCIS  ,;
                          CenZboz->cNazZbo::30 ,;
                          nDokladV:Èís.výdejky ,;
                          dDatProdej           ,;
                          nMnozV     );
                 FPOS(0,0) SIZE(100, 9.3) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) FOOTER(y)
  TYPE(End)