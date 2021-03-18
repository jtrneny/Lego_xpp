TYPE(drgForm) SIZE(80,22) DTYPE(10) TITLE(Seznam osob - VÝBÌR);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
              CARGO()

TYPE(Action) CAPTION(~Nová   Osoba) EVENT(osb_osoby_nova)   TIPTEXT(Založení nové osoby do seznamu osob ...)
TYPE(Action) CAPTION(~Oprava Osoby) EVENT(osb_osoby_oprava) TIPTEXT(Oprava údajù osoby ...)


  TYPE(DBrowse) FPOS(0.5,1.1) SIZE(79,12.5) FILE(OSOBY)                       ;
                                            FIELDS(ncisOsoby:èíslOsoby      , ;
                                                   cOsoba:Jméno osoby:40    , ;
                                                   CMISTO:Místo:25          , ; 
                                                   CZKRATSTAT:Stát            ) ;                                                                                                      
                                                   CURSORMODE(3) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)

* 1 - spojení  --> SPOJENI -> VAZSPOJE 
TYPE(TabPage) CAPTION(Spojení)  OFFSET(1,86) TABHEIGHT(1.0) FPOS(1,13.8) SIZE(78,8)  PRE(tabSelect) RESIZE(yx)

  TYPE(DBrowse) FPOS(0,0.1) SIZE(77.2,7) FILE(spojeniWs)              ;
                            FIELDS( M->is_hlavVazba::2::1           , ;
                                    ncisSpoj:Èíslo:7                , ;
                                    cZkrSpoj:Zkratka spojení:10     , ;
                                    cNazSpoj:Název spojení:25       , ;
                                    cAdrElSpoj:Elektronická adresa:40 ) ;
                            CURSORMODE(3) PP(7) SCROLL(yy) RESIZE(yx)

*  TYPE(MLE) NAME(M->adrPoSpoj) FPOS(73.0,1.1) FCAPTION(Poštovní adresa) CPOS(73.0,0.1) SIZE(24,6.0) SCROLL(nn) PP(2) READONLY(y) RESIZE(nx)
*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

* 2 - základní údaje OSOBY
TYPE(TabPage) CAPTION(Info) OFFSET(12,74) TABHEIGHT(1.0) FPOS(1,13.8) SIZE(78,8) PRE(tabSelect) RESIZE(yx)
  TYPE(Text) CAPTION(Adresa)            CPOS( 1,  .1) CLEN(9) FONT(5)
  TYPE(Text) CAPTION(ulice)             CPOS( 3, 1.2)  CLEN(9)
  TYPE(Text) NAME(OSOBY->cUlicCiPop)    CPOS(13, 1.2)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) CAPTION(mìsto)             CPOS( 3, 2.3)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CMISTO)        CPOS(13, 2.3)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) CAPTION(psè)               CPOS( 3, 3.4)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CPSC)          CPOS(13, 3.4)  CLEN(6) BGND(13) PP(2)
  TYPE(Text) NAME(C_PSC->CMISTO)        CPOS(20, 3.4)   CLEN(33) BGND(13)
  TYPE(Text) CAPTION(stát)              CPOS( 3, 4.5)  CLEN(9)
  TYPE(Text) NAME(OSOBY->CZKRATSTAT)    CPOS(13, 4.5)  CLEN(6) BGND(13) PP(2)
  TYPE(Text) NAME(C_STATY->cNAZEVSTAT)  CPOS(20, 4.5)   CLEN(33) BGND(13)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

* quickFilr
  TYPE(Static) STYPE(13) SIZE( 49.7,1.1) FPOS( 30.2, .02) RESIZE(nn) CTYPE(2)
    TYPE(PushButton) POS(.1,.1)   SIZE(345,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
