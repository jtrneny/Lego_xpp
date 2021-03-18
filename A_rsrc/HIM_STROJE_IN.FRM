TYPE(drgForm) DTYPE(10) TITLE(Editace evidence pozemkù) SIZE(110,25) FILE(POZEMKY);
              OBDOBI(HIM);
              PRINTFILES(zmaju:ntypmaj=ntypmaj+ninvcis=ninvcis)

*TYPE(Action) CAPTION(~Pohyby)    EVENT(HIM_POHYBY)  TIPTEXT(Pohyby investièního majetku)
*TYPE(Action) CAPTION(~Data akt.) EVENT(Data_aktual) TIPTEXT( Aktualizace dat)

  TYPE(EBrowse) FILE(POZEMKY) INDEXORD(1) ;
                SIZE(110,14) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
                ITEMMARKED( ItemMarked)
    TYPE(GET)  NAME( POZEMKY->nPozemek)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cPozemek)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cParcCis)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cParcCisP)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nDruhPozem)                CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cNazPozem)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nInvCis)                   CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nPodil)                    CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cPodil)                    CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cNazPol4)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cUlice)                    CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cCisPopis)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cCisOrien)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cObec)                     CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cPsc)                      CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cZkratStat)                CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nCisOsoby)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nCisFirmy)                 CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->cBPEJ)                     CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nVymera_m2)                CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nVymera_ha)                CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nCenaPoz)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nDanNabPoz)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nCenaSDaNa)                  CLEN( 15)  CAPTION( Druh pozemku ) 
    TYPE(GET)  NAME( POZEMKY->nCenaZaPod)                  CLEN( 15)  CAPTION( Druh pozemku ) 

  TYPE(End)


*  TYPE(FIELD) NAME(nCisOsobyP)  DESC(Èíslo osoby-pùvodní vlastník)   CAPTION(ÈísOsobyPùvVl)  FTYPE(n) FLEN( 6) DEC( 0)
*  TYPE(FIELD) NAME(cOsoba)      DESC(Osoby - celé jméno)             CAPTION(CelJmOsoby)     FTYPE(c) FLEN(50) DEC( 0)
*
*  TYPE(FIELD) NAME(nCisFirmy)   DESC(Èíslo firmy-vlastník)           CAPTION(ÈísFirmyVl)     FTYPE(n) FLEN( 5) DEC( 0)
*  TYPE(FIELD) NAME(nCisFirmyP)  DESC(Èíslo firmy-pùvodní vlastník)   CAPTION(ÈísFirmyPùvVl)  FTYPE(n) FLEN( 5) DEC( 0)
*  TYPE(FIELD) NAME(cNazev)      DESC(Název firmy)                    CAPTION(NázFirmy)       FTYPE(c) FLEN(100) DEC(0)
*
