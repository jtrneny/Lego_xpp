TYPE(drgForm) DTYPE(10) SIZE(106,19) TITLE(Seznam úkolù ...(výbìr) ...)   ;
              FILE(ukoly)                                               ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)  


TYPE(Action) CAPTION(~Nový   Úkol)  EVENT(kan_ukoly_new)    TIPTEXT(Založení nového úkolu do seznamu ...)
TYPE(Action) CAPTION(~Oprava Úkolu) EVENT(kan_ukoly_modify) TIPTEXT(Oprava údajù úkolu ...)


TYPE(DBrowse) FPOS(0,1.5) SIZE(106,9.4) FILE(UKOLY)                       ;
                                      FIELDS(nCisUkolu:úkol:7           , ;
                                             czkrUkolu:Zkratka úkolu:10 , ;
                                             cNazUkolu:Název úkolu:48   , ;
                                             dzacUkolu:zaèDne           , ;
                                             dkonUkolu:ukonDne          , ;
                                             dplzacUkol:plánZaè         , ;
                                             dplkonUkol:plánKon           )  ;
                                      CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked)


TYPE(Static) STYPE(13) SIZE(104,15) FPOS(1,11.2) RESIZE(yn)

  TYPE(TEXT) CAPTION(Èíslo úkolu)         CPOS( 1, 0.3)
  TYPE(TEXT) NAME(ukoly->ncisUkolu)       CPOS(18, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

  TYPE(TEXT) CAPTION(Zkratka úkolu)       CPOS( 1, 1.3)
  TYPE(TEXT) NAME(ukoly->czkrUkolu)       CPOS(18, 1.3) CLEN( 12) BGND(13)
  TYPE(TEXT) NAME(c_ukoly->cnazUkolu)     CPOS(31, 1.3) CLEN( 25)

  TYPE(TEXT) CAPTION(Název úkolu)         CPOS( 1, 2.3)
  TYPE(TEXT) NAME(ukoly->cnazUkolu)       CPOS(18, 2.3) CLEN( 46) BGND(13)

  TYPE(TEXT) CAPTION(Stav øešení)         CPOS( 1, 3.3)
  TYPE(TEXT) NAME(ukoly->czkrStaRes)      CPOS(18, 3.3) CLEN( 12) BGND(13)

  TYPE(TEXT) CAPTION(Plán zaèátku)        CPOS( 1, 4.3) 
  TYPE(TEXT) NAME(ukoly->dplzacUkol)      CPOS(18, 4.3) CLEN( 12) BGND(13)
  TYPE(TEXT) CAPTION(plán ukonèení)       CPOS(35, 4.3) 
  TYPE(TEXT) NAME(ukoly->dplkonUkol)      CPOS(52, 4.3) CLEN( 12) BGND(13)

  TYPE(TEXT) CAPTION(Datum zaèátku)       CPOS( 1, 5.3) 
  TYPE(TEXT) NAME(ukoly->dzacUkolu)       CPOS(18, 5.3) CLEN( 12) BGND(13)
  TYPE(TEXT) CAPTION(ukonèen dne)         CPOS(35, 5.3) 
  TYPE(TEXT) NAME(ukoly->dkonUkolu)       CPOS(52, 5.3) CLEN( 12) BGND(13)
*
  TYPE(MLE) NAME('ukoly->mpopisUkol')     FPOS(65,.2) SIZE(38,6.5) RESIZE(yx) SCROLL(ny)  READONLY(y)

TYPE(End)

TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(105.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Seznam úkolù ...)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
  TYPE(PushButton) POS(82.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
TYPE(END)

