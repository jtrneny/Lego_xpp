TYPE(drgForm) SIZE(120,26) DTYPE(10) TITLE(Seznam úkolù ...)         ;
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar) ;
              CARGO( KAN_ukoly_CRD)


TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Ukol_vaz_ex)  EVENT(ukolTree_ex_Full) TIPTEXT(Zobrazení vazeb úkolu pro osoby - exTree)


TYPE(DBrowse) FPOS(0.75,1.4) SIZE(119,15.2) FILE(UKOLY)                         ;
                                       FIELDS(M->is_podUkol:it:3.7::1    , ;
                                              nCisUkolu:úkol:7           , ;
                                              czkrUkolu:Zkratka úkolu:10 , ;
                                              cNazUkolu:Název úkolu:42   , ;
                                              cJmeRozlRe:øešitel:25      , ;
                                              dzacUkolu:zaèDne:10        , ;
                                              dkonUkolu:ukonDne:10       , ;
                                              dplzacUkol:plánZaè:10      , ;
                                              dplkonUkol:plánKon:10        )  ;
                                       CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked)


* 1
TYPE(TabPage) TTYPE(4) CAPTION(Info_Úkol) OFFSET(1,87) FPOS(0.75,16.9) SIZE(118.5,8.75) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(1,12) SIZE(98.2,11.2) RESIZE(YX)



* 1 - základní údaje OSOBY
*    TYPE(Static) STYPE(12) CAPTION(Info k úkolu) FPOS(1,10.5) SIZE(118,7.2) CTYPE(2)
  TYPE(Text) CAPTION(Info o úkolu)        CPOS( 1,  .1)  CLEN(15) FONT(5)
  TYPE(Text) CAPTION(ÈísÚkolu)            CPOS( 1,  1.2)  CLEN(11) 
    TYPE(Text) NAME(UKOLY->nCisUkolu)       CPOS(13, 1.2)  CLEN(30) BGND(13) PP(2)
  TYPE(Text) CAPTION(ZkrÚkolu)            CPOS( 1,  2.3)  CLEN(11) 
    TYPE(Text) NAME(UKOLY->cZkrUkolu)       CPOS(13, 2.3)  CLEN(30) BGND(13) PP(2)
  TYPE(Text) CAPTION(NazÚkolu)            CPOS( 1,  3.4)  CLEN(11) 
    TYPE(Text) NAME(UKOLY->cNazUkolu)       CPOS(13, 3.4)  CLEN(30) BGND(13) PP(2)
  TYPE(Text) CAPTION(StavÚkolu)           CPOS( 1, 4.5)   CLEN(11) 
    TYPE(Text) NAME(UKOLY->cZkrStaRes)      CPOS(13, 4.5)  CLEN(30) BGND(13) PP(2)


  TYPE(Text) CAPTION(Zaèátek)             CPOS( 57, .1)   CLEN(8) 
  TYPE(Text) CAPTION(Konec)               CPOS( 69, .1)   CLEN(8) 
  TYPE(Text) CAPTION(Plán)                CPOS( 45, 1.2)   CLEN(9) 
    TYPE(Text) NAME(UKOLY->dPlzacUkol)      CPOS(57, 1.2)  CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(UKOLY->dPlkonUkol)      CPOS(68, 1.2)  CLEN(10) BGND(13) PP(2)
  TYPE(Text) CAPTION(Skuteènost)          CPOS( 45, 2.3)   CLEN(9) 
    TYPE(Text) NAME(UKOLY->dzacUkolu)       CPOS(57, 2.3)  CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(UKOLY->dkonUkolu)       CPOS(68, 2.3)  CLEN(10) BGND(13) PP(2)
  TYPE(Text) CAPTION(Pøipomenutí)         CPOS( 45, 3.3)   CLEN(10) 
    TYPE(Text) NAME(UKOLY->dPripoUkol)      CPOS(57, 3.3)  CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(UKOLY->cPripoUkol)      CPOS(68, 3.3)  CLEN(10) BGND(13) PP(2)
  TYPE(MLE) NAME(UKOLY->mPopisUkol)       FPOS(80.0,0.1)   SIZE(36.4,7.4) SCROLL(nn) PP(2) READONLY(y)


TYPE(End)


* 2
TYPE(TabPage) TTYPE(4) CAPTION(Popis) OFFSET(13,75) FPOS(0.75,16.9) SIZE(118.5,8.75)  RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
  TYPE(MLE) NAME(UKOLY->mPopisUkol)       FPOS(0.3,0.5) SIZE(116,7.4) SCROLL(nn) PP(2) READONLY(y)


TYPE(End)


* 3
TYPE(TabPage) TTYPE(4) CAPTION(PodÚkoly) OFFSET(25,63) FPOS(0.75,16.9) SIZE(118.5,8.75) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)

  TYPE(DBrowse) FPOS(0,0.08) SIZE(119,7.8) FILE(UKOLYX)                        ;
                                     FIELDS(nCisUkolu:úkol:7           , ;
                                            czkrUkolu:Zkratka úkolu:10 , ;
                                            cNazUkolu:Název úkolu:42   , ;
                                            cJmeRozlRe:øešitel:25      , ;
                                            dzacUkolu:zaèDne:10        , ;
                                            dkonUkolu:ukonDne:10       , ;
                                            dplzacUkol:plánZaè:10      , ;
                                            dplkonUkol:plánKon:10        )  ;
                                     CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x) SCROLL(yy)



TYPE(End)


* 4
TYPE(TabPage) TTYPE(4) CAPTION(Øešitelé) OFFSET(37,51) FPOS(0.75,16.9) SIZE(118.5,8.75) RESIZE(yx)

*  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)

  TYPE(DBrowse) FPOS(0,.08) SIZE(119,7.9) FILE(OSOBY) ;
                                        FIELDS(M->is_inPersonal:per:2.6::2        , ;
                                               M->is_inMsPrc_mo:zam:2.6::2        , ;
                                               ncisOsoby:èíslOsoby                , ;
                                               nosCisPrac:èisloPrac               , ;
                                               cjmenoRozl:Pøíjmení_jméno a rozlišení osoby:35, ;
                                               cUlicCiPop:Ulice a èp:10              , ;
                                               CMISTO:Mìsto:25                    , ;
                                               CZKRATSTAT:Stát                    , ;
                                               cosoba:Osoba                       , ;  
                                               nosCisPrac:èísloPrac               , ;
                                               CTELEFON:Telefon:15                , ;
                                               CEMAIL:Email:30                      ) ;
                                        CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x) SCROLL(yy)



*  TYPE(DBrowse) FPOS(0,0.08) SIZE(119,7) FILE(UKOLYX)                        ;
*                                     FIELDS(nCisUkolu:úkol:7           , ;
*                                            czkrUkolu:Zkratka úkolu:10 , ;
*                                            cNazUkolu:Název úkolu:42   , ;
*                                            cJmeRozlRe:øešitel:25      , ;
*                                            dzacUkolu:zaèDne:10        , ;
*                                            dkonUkolu:ukonDne:10       , ;
*                                            dplzacUkol:plánZaè:10      , ;
*                                            dplkonUkol:plánKon:10        )  ;
*                                     CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x) SCROLL(yy)



TYPE(End)




*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(118.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Pøehled úkolùKmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(33.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(33.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)
