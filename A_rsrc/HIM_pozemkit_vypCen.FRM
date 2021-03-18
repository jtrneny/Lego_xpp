TYPE(drgForm) DTYPE(10) TITLE(Výpoèet ceny a danì u vybarných pozemkù ...) ;
              CARGO()                                                      ;
              PRE(preValidate)                                             ;
              POST(postValidate)                                           ;            
              SIZE(110,25)                                                 ;
              OBDOBI(HIM)                                                  ;
              PRINTFILES(pozemky:npozemek=npozemek)

*
** pozemky
TYPE(STATIC) FPOS( .4, .2) SIZE(109.2,4.8) STYPE(13) CTYPE(2)

  TYPE(TEXT) CAPTION(typ Výpoètu ceny)  CPOS(  5,  .5) CLEN(18) FONT(5)  GROUPS(SETFONT,9.Arial CE)
  TYPE(COMBOBOX) NAME(pozemkyW->ctask)  FPOS(  5, 1.7) FLEN(30) VALUES(DAN: výpoèet danì pozemku         ,;
                                                                       CEN: výpoèet vstupní ceny pozemku  )

  TYPE(TEXT) CAPTION(inv_Èíslo)         CPOS( 40,  .5) CLEN(12)  FONT(5) GROUPS(SETFONT,9.Arial CE)            
  TYPE(GET)  NAME(pozemkyW->ninvCis)    FPOS( 40, 1.7) FLEN(10)  BGND(12) FONT(5) 
  TYPE(TEXT) NAME(M->nazevMaj)          CPOS( 52, 1.7) CLEN(25)      
*  TYPE(TEXT) CAPTION(výpoèet danì pozemku) CPOS( 5, 3) CLEN(60)  SIZE(60,2.8) CTYPE(3) GROUPS(SETFONT,16.Arial CE)
*  TYPE(TEXT) CAPTION(výpoèet danì pozemku) CPOS( 5.2, 3.2) CLEN(60)  SIZE(60,2.8) CTYPE(3) GROUPS(SETFONT,16.Arial CE,GRA_CLR_RED)


  TYPE(STATIC) FPOS(78.6, .1) SIZE(30.7, 4.5) STYPE(12)  RESIZE(yx) CTYPE(2) GROUPS(POZ)
    TYPE(TEXT) NAME(M->celkCena)          CPOS(  1  ,  .6) CLEN(12)  FONT(5) GROUPS(SETFONT,10.Lucida,GRA_CLR_RED)
    TYPE(GET)  NAME(pozemkyW->ncenaPoz)   FPOS( 13  ,  .6) FLEN(13)  FONT(5) 
    TYPE(TEXT) CAPTION(Kè)                CPOS( 27.5,  .6) CLEN( 3) 

    TYPE(STATIC) STYPE(3)                 FPOS(  1  , 1.9) SIZE(11,11) CAPTION(461)
    TYPE(TEXT)   CAPTION(podVým)          CPOS(  3  , 1.7) CLEN(8) FONT(5)
    TYPE(TEXT)   NAME(M->sum_podVym_M2)   CPOS( 13  , 1.7) CLEN(14) BGND(12) CTYPE(2)
    TYPE(TEXT) CAPTION(M2)                CPOS( 27.5, 1.7) CLEN( 3)  

    TYPE(STATIC) STYPE(3)                 FPOS(  1,   3.3) SIZE(14,14) CAPTION(426)
    TYPE(TEXT)   CAPTION(cena M2)         CPOS(  3  , 3.1) CLEN(8) FONT(5)
    TYPE(TEXT)   NAME(M->prum_cena_M2)    CPOS( 13  , 3.1) CLEN(14) BGND(13) CTYPE(2)
    TYPE(TEXT) CAPTION(Kè)                CPOS( 27.5, 3.1) CLEN( 3)
  TYPE(End)
TYPE(END)



* pozemkyit
*
  TYPE(STATIC) FPOS( .4, 5.8) SIZE(109.2,15.6) STYPE(12)  CTYPE(2)
    TYPE(TEXT) CAPTION(Pohyby - položky evidence pozemkù) CPOS(.2,.1) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(DBrowse) FILE(pozemkitWx) INDEXORD(2)        ;
                  FIELDS(M->canBeSave::3.5::2       , ;
                         ninvCis:invÈíslo:10        , ;
                         cku_Kod:KU:7               , ;
                         nlistVlast:LV:10           , ;
                         cparcCis:èísloParc:15      , ; 
                         cparcCisP:èísloParc_pùv:15 , ;
                         cpodil:podíl:7             , ;
                         nVymera_m2:výmìra_m2:10    , ;
                         npodVym_m2:podVým_m2:10    , ;
                         ndruhPozem:druhPoz:10      , ;
                         ncenaPoz:cena:11           , ;
                         ndanNabPoz:daò:11          , ;
                         ncenaSDaNa:cenaS_daní:11   , ;
                         cBPEJ:bonita:6             , ;
                         mpoznamka:pùvVlast:15        ) ;
                   FPOS(-.4,1.1) SIZE(109.2,14.3) CURSORMODE(3) PP(7) RESIZE(yx) POPUPMENU(y) SCROLL(yy) FOOTER(y)
  TYPE(End)
* TYPE(End)

*
**RUN**
  TYPE(Static) STYPE(12) SIZE(109.2,3) FPOS(.5,21.5) CTYPE(2) RESIZE(y) GROUPS(OK)
    TYPE(PushButton) POS(  .4,1.9) SIZE(36,2.8) CAPTION(~Storno)                            EVENT(140000002)    ICON1(102) ICON2(202) ATYPE(3)
    TYPE(PushButton) POS(36.5,1.9) SIZE(36,2.8) CAPTION(      ~Pøepoèet pozemkù dle zadání) EVENT(cmp_marked)   ICON1(142) ICON2(0)   ATYPE(3)
    TYPE(PushButton) POS(72.6,1.9) SIZE(36,2.8) CAPTION(  ~Uložit pøepoètené pozemky)       EVENT(save_marked)  ICON1(101) ICON2(0)   ATYPE(3)
  TYPE(END)

TYPE(End)
