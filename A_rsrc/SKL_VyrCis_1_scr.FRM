TYPE(drgForm) DTYPE(10) TITLE(Evidence výr.èísel - dle skl.položek ...) SIZE(105,25) ;
              CARGO( SKL_VYRCIS_CRD) GUILOOK(Action:y) ;
              PRE(preValidate) POST(postValidate)

TYPE(Action) CAPTION(info C~eník)   EVENT( SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)
*TYPE(Action) ATYPE( 5)
TYPE(Action) CAPTION(~Inventura VÈ) EVENT(VYRCIS_INVENTURA) TIPTEXT( Inventura výrobních èísel)



  TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(3)  ;
                FIELDS( M->is_evidvyrCis:vè:3::2      , ;
                        CenZBOZ_isAktivni():Akt:2.6::2, ;
                        CCISSKLAD                     , ;
                        CSKLPOL                       , ;
                        CNAZZBO::30                   , ;
                        NMNOZSZBO                     , ;
                        cZkratJedn:MJ                 , ;
                        NCENASZBO                     , ;
                        NCENACZBO                       ) ;
                FPOS(0, 1.1 ) SIZE(105,13.8) CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yy);
                ITEMMARKED( ItemMarked) ITEMSELECTED( ItemSelected) POPUPMENU(yy)

TYPE(TabPage) TTYPE(4) CAPTION(Výrobní èísla) FPOS(0.5,15.1) SIZE( 104.2, 10) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)

  TYPE(DBrowse) FILE(VYRCIS) INDEXORD(1) ;
                FIELDS( nPoradi    ,;
                        cVyrobCIS  ,;
                        nMNOZ      ,;
                        nZust      ,;
                        nDoklad:Èís.pøíjemky ,;
                        dDatPrijem ,;
                        nMnozP     ,;
                        nDokladV:Èís.výdejky ,;
                        dDatProdej ,;
                        nMnozV     ,;
                        nZaruka    ,;
                        nMnozPoc   ,;
                        cVady      );
                SIZE(105, 9) CURSORMODE(3) RESIZE(yx) PP(7) SCROLL(yy)
  TYPE(End)


* Ceník zboží - seznam
  TYPE(Static) STYPE(13) SIZE(104.6,1.1) FPOS( 0.2, 0.1)  RESIZE(yn) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Seznam skladových položek) CPOS( 35, 0.1) CLEN( 30) FONT(5)

    TYPE(Static) STYPE(1)       SIZE(32,1.2)  FPOS( 72.5,0.1)  RESIZE(nx)
      TYPE(PushButton) POS(0,0)   SIZE(32,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(End) 
  TYPE(End)

* Výrobní èísla - karta
*  TYPE(Static) STYPE(13) SIZE(61.5,12.5) FPOS(38,12) RESIZE(y)
*    TYPE(TEXT) CAPTION(Výrobní èíslo)    CPOS( 1, 0.5) CLEN(12) PP(3) BGND( 1) FONT(5)
*    TYPE(GET)  NAME(VyrCis->cVyrobCis)   FPOS(13, 0.5) FLEN(20)       BGND(13)
*   TYPE(TEXT) CAPTION(Množ. pøijaté)    CPOS(35, 0.5) CLEN(10) PP(3) BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nMnoz)       FPOS(46, 0.5) FLEN(12)       BGND(13)
*    TYPE(TEXT) CAPTION(Zùstatek)         CPOS(35, 1.5) CLEN(10) PP(3) BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nZust)       FPOS(46, 1.5) FLEN(12)       BGND(13)
*
*    TYPE(TEXT) CAPTION(Záruèní doba)    CPOS( 1, 3.5) CLEN(10)  BGND( 1)
*    TYPE(TEXT) CAPTION(Dny)             CPOS(15, 2.5) CLEN( 5)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(15, 3.5) FLEN( 5)  BGND(13)
*    TYPE(TEXT) CAPTION(Týdny)           CPOS(25, 2.5) CLEN( 6)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(25, 3.5) FLEN( 5)  BGND(13)
*    TYPE(TEXT) CAPTION(Roky)            CPOS(35, 2.5) CLEN( 5)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(35, 3.5) FLEN( 5)  BGND(13)
*
*    TYPE(TEXT) CAPTION(Do konce záruky) CPOS( 1, 4.5) CLEN(13)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(15, 4.5) FLEN( 5)  BGND(13)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(25, 4.5) FLEN( 5)  BGND(13)
*    TYPE(GET)  NAME(VyrCis->nZaruka)    FPOS(35, 4.5) FLEN( 5)  BGND(13)
*
*    TYPE(TEXT) CAPTION(Doklad èíslo)    CPOS( 1, 6.5) CLEN(10)  BGND( 1)
*    TYPE(TEXT) CAPTION(Pøíjem)          CPOS(15, 5.5) CLEN( 6)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nDoklad)    FPOS(15, 6.5) FLEN(10)  BGND(13)
*    TYPE(TEXT) CAPTION(Výdej)           CPOS(27, 5.5) CLEN( 6)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->nDokladV)   FPOS(27, 6.5) FLEN(10)  BGND(13)
*
*    TYPE(TEXT) CAPTION(Datum)           CPOS( 1, 7.5) CLEN(10)  BGND( 1)
*    TYPE(GET)  NAME(VyrCis->dDatPrijem) FPOS(15, 7.5) FLEN(10)  BGND(13)
*    TYPE(GET)  NAME(VyrCis->dDatProdej) FPOS(27, 7.5) FLEN(10)  BGND(13)
*
*  TYPE(End)