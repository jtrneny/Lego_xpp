TYPE(drgForm) DTYPE(10) TITLE(Lékaøské prohlídky) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_osoby_CRD)


TYPE(DBrowse) FPOS(0,0) SIZE(99,10.2) FILE(OSOBY) ;
                                          FIELDS(M->is_inPersonal:per:2.6::2                   , ;
                                                 M->is_inMsPrc_mo:zam:2.6::2                   , ;
                                                 ncisOsoby:èíslOsoby                           , ;
                                                 cjmenoRozl:Pøíjmení_jméno a rozlišení osoby:35, ;
                                                 cUlicCiPop:Ulice a èp:10                      , ;
                                                 CMISTO:Mìsto:25                               , ;
                                                 CZKRATSTAT:Stát                               , ;
                                                 cosoba:Osoba                                  , ;  
                                                 nosCisPrac:èísloPrac                          , ;
                                                 CTELEFON:Telefon:15                           , ;
                                                 CEMAIL:Email:30                                 ) ;
                                          CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(yy) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)



TYPE(DBrowse) FPOS(0,10.) SIZE(99,7) FILE(LekProhl) INDEXORD(1)   ;
              FIELDS( nPoradi:poøLp                             , ;
                      cZkratka:typLp                            , ;
                      M->nazLekPr:název lékaøské prohlídky:40   , ;
                      nperioOpak:perOpakLp                      , ;
                      czkratJedn:za                             , ;
                      cnazevLeka:prohlídku provedl lékaø        , ; 
                      dposlLekPr:dne                            , ;
                      ddalsLekPr:dalšíLp                          )  ;
              CURSORMODE(3) PP(7) 

* TYPE(DBrowse) FPOS(0,10.5) SIZE(99,7) FILE(vazLekpr)                                                ;
*                                      FIELDS(M->is_inMsPrc_mo:zam:2.6::2                          , ;
*                                             vazLekpr_osoby('ncisOsoby'):èíslOsoby                , ;
*                                             vazLekpr_osoby('nosCisPrac'):èísloPrac               , ;
*                                             vazLekpr_osoby('cjmenoRozl'):Pøímení a jméno osoby:35, ;
*                                             vazLekpr_osoby('CMISTO'):Mìsto:25                    , ;
*                                             vazLekpr_osoby('CZKRATSTAT'):Stát                    , ;
*                                             vazLekpr_osoby('CTELEFON'):Telefon:15                , ;
*                                             vazLekpr_osoby('CEMAIL'):Email:30                      ) ;
*                                      CURSORMODE(3) INDEXORD(9) PP(7) RESIZE(x) SCROLL(yy) PRE(SetFocus)



TYPE(STATIC) STYPE(12) CAPTION(Údaje o lékaøské prohlídce pracovníka) FPOS(1,17.5)  SIZE(98,7.2) RESIZE(YX) CTYPE(2)
    TYPE(TEXT) CAPTION(Ošetøující lékaø   ...)  CPOS( 3, 1)   CLEN(18)
     TYPE(TEXT) NAME(LekProhl ->cZkratLeka)     CPOS(21, 1)   CLEN( 8)  BGND(13) PP(2)
     TYPE(TEXT) NAME(C_Lekari ->cNazevLeka)     CPOS(30, 1)   CLEN(30)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Odbornost         ...)   CPOS( 3, 2)   CLEN(18)
     TYPE(TEXT) NAME(LekProhl ->cOdbornLek)     CPOS(21, 2)   CLEN(30)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Ordinace           ...)  CPOS( 3, 3)   CLEN(18)
     TYPE(TEXT) NAME(LekProhl ->cUlice)         CPOS(21, 3)   CLEN(25)  BGND(13) PP(2)
     TYPE(TEXT) NAME(LekProhl ->cMisto)         CPOS(21, 4)   CLEN(25)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Prohlídka dne    ...)    CPOS( 3, 5.5) CLEN(18)
     TYPE(TEXT) NAME(LekProhl ->dposlLekPr)     CPOS(21, 5.5) CLEN(12)  BGND(13) PP(2) FONT(5)
     TYPE(TEXT) CAPTION(dallší lékProhlídka)    CPOS(32, 5.5) CLEN(14)   
     TYPE(TEXT) NAME(LekProhl ->ddalsLekPr)     CPOS(47, 5.5) CLEN(12)  BGND(13) PP(2) FONT(5)

   TYPE(MLE) NAME(lekprohl->mpoznamka) FPOS(63,1.1) ;
             FCAPTION(Poznámka k lékaøské prohlídce) CPOS(63,0.1) SIZE(34,5.8) SCROLL(nn) PP(2) READONLY(y)
TYPE(END)