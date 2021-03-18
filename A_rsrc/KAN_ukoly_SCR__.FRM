TYPE(drgForm) SIZE(120,26) DTYPE(10) TITLE(Seznam úkolù ...)         ;
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar) ;
              CARGO( KAN_ukoly_CRD)


TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Ukol_vaz_ex)  EVENT(ukolTree_ex_Full) TIPTEXT(Zobrazení vazeb úkolu pro osoby - exTree)


TYPE(DBrowse) FPOS(0,0) SIZE(119,10.2) FILE(UKOLY)                         ;
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



* 1 - základní údaje OSOBY
TYPE(Static) STYPE(12) CAPTION(Info k úkolu) FPOS(1,10.5) SIZE(118,7.2) CTYPE(2)
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
  TYPE(Text) CAPTION(Pøipomenutí)         CPOS( 84 , .1)   CLEN(10) 
    TYPE(Text) NAME(UKOLY->dPripoUkol)      CPOS(84, 1.2)  CLEN(10) BGND(13) PP(2)
    TYPE(Text) NAME(UKOLY->cPripoUkol)      CPOS(84, 2.3)  CLEN(10) BGND(13) PP(2)
  TYPE(MLE) NAME(UKOLY->mPopisUkol)       FPOS(56.3,3.5) SIZE(54,3.4) SCROLL(nn) PP(2) READONLY(y)



*  TYPE(Text) CAPTION(Adresa)            CPOS( 1,  .1)  CLEN(15) FONT(5)
*  TYPE(Text) CAPTION(ulice)             CPOS( 3, 1.2)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->cUlicCiPop)    CPOS(17, 1.2)  CLEN(30) BGND(13) PP(2)
*  TYPE(Text) CAPTION(mìsto)             CPOS( 3, 2.3)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->CMISTO)        CPOS(17, 2.3)  CLEN(30) BGND(13) PP(2)
*  TYPE(Text) CAPTION(psè)               CPOS( 3, 3.4)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->CPSC)          CPOS(17, 3.4)  CLEN( 6) BGND(13) PP(2)
*  TYPE(Text) NAME(C_PSC->CMISTO)        CPOS(24, 3.4)  CLEN(23) BGND(13)
*  TYPE(Text) CAPTION(stát)              CPOS( 3, 4.5)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->CZKRATSTAT)    CPOS(17, 4.5)  CLEN( 6) BGND(13) PP(2)
*  TYPE(Text) NAME(C_STATY->cNAZEVSTAT)  CPOS(24, 4.5)  CLEN(23) BGND(13)
*
*  TYPE(TEXT) NAME(osoby->cjmenoRozl)    CPOS(50, 1.1)  CLEN(45) BGND( 8) CTYPE(2) FONT(5) 

TYPE(End)


TYPE(DBrowse) FPOS(0,18) SIZE(119,7) FILE(UKOLYX)                        ;
                                     FIELDS(nCisUkolu:úkol:7           , ;
                                            czkrUkolu:Zkratka úkolu:10 , ;
                                            cNazUkolu:Název úkolu:42   , ;
                                            cJmeRozlRe:øešitel:25      , ;
                                            dzacUkolu:zaèDne:10        , ;
                                            dkonUkolu:ukonDne:10       , ;
                                            dplzacUkol:plánZaè:10      , ;
                                            dplkonUkol:plánKon:10        )  ;
                                     CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x) SCROLL(yy)


* TYPE(DBrowse) FPOS(0,18.0) SIZE(99,7) FILE(vazUkoly)                                                ;
*                                      FIELDS(M->is_inPersonal:per:2.6::2                          , ;
*                                             M->is_inMsPrc_mo:zam:2.6::2                          , ;
*                                             vazUkoly_osoby('ncisOsoby'):èíslOsoby                , ;
*                                             vazUkoly_osoby('nosCisPrac'):èísloPrac               , ;
*                                             vazUkoly_osoby('cjmenoRozl'):Pøímení a jméno osoby:35, ;
*                                             vazUkoly_osoby('CMISTO'):Mìsto:25                    , ;
*                                             vazUkoly_osoby('CZKRATSTAT'):Stát                    , ;
*                                             vazUkoly_osoby('CTELEFON'):Telefon:15                , ;
*                                             vazUkoly_osoby('CEMAIL'):Email:30                      ) ;
*                                      CURSORMODE(3) INDEXORD(2) PP(7) RESIZE(x) SCROLL(yy) PRE(SetFocus)


