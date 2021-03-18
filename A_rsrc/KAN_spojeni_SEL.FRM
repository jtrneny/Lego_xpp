TYPE(drgForm) DTYPE(10) SIZE(106,18) TITLE(Seznam spojení ... (výbìr) ... ) ;
              FILE(spojeni)                                               ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) 


TYPE(Action) CAPTION(~Nové   Spojení) EVENT(kan_spojeni_new)    TIPTEXT(Založení nového spojení do seznamu ...)
TYPE(Action) CAPTION(~Oprava Spojení) EVENT(kan_spojeni_modify) TIPTEXT(Oprava údajù spojení ...)


*TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)

  TYPE(DBrowse) FPOS(0,1.5) SIZE(106,9.4) FILE(SPOJENI)                               ;
                                          FIELDS(nCisSpoj:Èíslo:7                   , ;
                                                 cZkrSpoj:Zkratka spojení:10        , ;
                                                 cNazSpoj:Název spojení:35          , ;
                                                 cAdrElSpoj                         , ;
                                                 mUsrElSpoj                         , ;
                                                 madrPoSpoj                           )   ;
                                                 CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) ITEMSELECTED(itemSelected)
* TYPE(END)


* TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)

  TYPE(Static) STYPE(13) SIZE(104,16.5) FPOS(1,10.7) RESIZE(yn)

    TYPE(TEXT) CAPTION(Èíslo spojení)            CPOS( 1, 0.3)
    TYPE(TEXT) NAME(spojeni->ncisSpoj)           CPOS(18, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

    TYPE(TEXT) CAPTION(Zkratka spojení)          CPOS( 1, 1.3)
    TYPE(TEXT) NAME(spojeni->czkrSpoj)           CPOS(18, 1.3) CLEN( 12) BGND(13)
    TYPE(TEXT) NAME(c_spojen->cnazSpoj)          CPOS(32, 1.3) CLEN( 15) 

    TYPE(TEXT)  CAPTION(Název spojení)           CPOS( 1, 2.3)
    TYPE(TEXT)  NAME(spojeni->cnazSpoj)          CPOS(18, 2.3) CLEN( 40) BGND(13)
  
    TYPE(TEXT)  CAPTION(Elektronické spojení)    CPOS( 1, 3.3) CLEN( 15)
    TYPE(TEXT)  NAME(spojeni->cadrElSpoj)        CPOS(18, 3.3) CLEN( 40) BGND(13)

    TYPE(TEXT)  CAPTION(Elektronické pøihlášení) CPOS( 1, 4.3) CLEN( 15)
    TYPE(TEXT)  NAME(spojeni->mUsrElSpoj)        CPOS(18, 4.3) CLEN( 40) BGND(13)

    TYPE(TEXT)  CAPTION(Poštovní adresa)         CPOS( 1, 5.3)
    TYPE(TEXT)  NAME(spojeni->madrPoSpoj)        CPOS(18, 5.3) CLEN( 40) BGND(13)


* 1 - základní údaje pro SPOJENÍ
   TYPE(Static) FPOS(60,0.2) SIZE(44,6) CAPTION(Základní údaje)
     TYPE(Text)  CAPTION(Adresa)            CPOS( 1,.8) CLEN(20) FONT(5)

     TYPE(TEXT)  CAPTION(Ulice/è.popisné)   CPOS( 2, 2) CLEN(12)
     TYPE(TEXT)  NAME(spojeni->culice)      CPOS(15, 2) CLEN(30) BGND(13)

     TYPE(TEXT)  NAME(spojeni->ccisPopis)   CPOS(48, 2) CLEN(15) BGND(13)

     TYPE(TEXT)  CAPTION(Místo)             CPOS( 2, 3)
     TYPE(TEXT)  NAME(spojeni->cmisto)      CPOS(15, 3) CLEN(30) BGND(13)

     TYPE(TEXT)  CAPTION(PSÈ)               CPOS( 2, 4) CLEN(10)
     TYPE(TEXT)  NAME(spojeni->cpsc)        CPOS(15, 4) CLEN( 8) BGND(13)
     TYPE(TEXT)  NAME(C_PSC->CMISTO)        CPOS(25, 4) CLEN(21) BGND(13)

     TYPE(TEXT)  CAPTION(Stát)              CPOS( 2, 5)
     TYPE(TEXT)  NAME(spojeni->czkratStat)  CPOS(15, 5) CLEN( 8) BGND(13)
     TYPE(TEXT)  NAME(C_STATY->cNAZEVSTAT)  CPOS(25, 5) CLEN(21) BGND(13)
   TYPE(End)
*
*    TYPE(MLE) NAME('ukoly->mpopisUkol') FPOS( .5,16) SIZE(53,3.5) RESIZE(yx) SCROLL(ny)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(END)

TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(105.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Seznam spojení ...)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
  TYPE(PushButton) POS(82.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
TYPE(END)


