TYPE(drgForm) DTYPE(10) SIZE(106,19) TITLE(Seznam �kol� ...(v�b�r) ...)   ;
              FILE(ukoly)                                               ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)  


TYPE(Action) CAPTION(~Nov�   �kol)  EVENT(kan_ukoly_new)    TIPTEXT(Zalo�en� nov�ho �kolu do seznamu ...)
TYPE(Action) CAPTION(~Oprava �kolu) EVENT(kan_ukoly_modify) TIPTEXT(Oprava �daj� �kolu ...)


TYPE(DBrowse) FPOS(0,1.5) SIZE(106,9.4) FILE(UKOLY)                       ;
                                      FIELDS(nCisUkolu:�kol:7           , ;
                                             czkrUkolu:Zkratka �kolu:10 , ;
                                             cNazUkolu:N�zev �kolu:48   , ;
                                             dzacUkolu:za�Dne           , ;
                                             dkonUkolu:ukonDne          , ;
                                             dplzacUkol:pl�nZa�         , ;
                                             dplkonUkol:pl�nKon           )  ;
                                      CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(yy) PRE(SetFocus) ITEMMARKED(itemMarked)


TYPE(Static) STYPE(13) SIZE(104,15) FPOS(1,11.2) RESIZE(yn)

  TYPE(TEXT) CAPTION(��slo �kolu)         CPOS( 1, 0.3)
  TYPE(TEXT) NAME(ukoly->ncisUkolu)       CPOS(18, 0.3) CLEN( 12) BGND(13) PP(2) CTYPE(2)

  TYPE(TEXT) CAPTION(Zkratka �kolu)       CPOS( 1, 1.3)
  TYPE(TEXT) NAME(ukoly->czkrUkolu)       CPOS(18, 1.3) CLEN( 12) BGND(13)
  TYPE(TEXT) NAME(c_ukoly->cnazUkolu)     CPOS(31, 1.3) CLEN( 25)

  TYPE(TEXT) CAPTION(N�zev �kolu)         CPOS( 1, 2.3)
  TYPE(TEXT) NAME(ukoly->cnazUkolu)       CPOS(18, 2.3) CLEN( 46) BGND(13)

  TYPE(TEXT) CAPTION(Stav �e�en�)         CPOS( 1, 3.3)
  TYPE(TEXT) NAME(ukoly->czkrStaRes)      CPOS(18, 3.3) CLEN( 12) BGND(13)

  TYPE(TEXT) CAPTION(Pl�n za��tku)        CPOS( 1, 4.3) 
  TYPE(TEXT) NAME(ukoly->dplzacUkol)      CPOS(18, 4.3) CLEN( 12) BGND(13)
  TYPE(TEXT) CAPTION(pl�n ukon�en�)       CPOS(35, 4.3) 
  TYPE(TEXT) NAME(ukoly->dplkonUkol)      CPOS(52, 4.3) CLEN( 12) BGND(13)

  TYPE(TEXT) CAPTION(Datum za��tku)       CPOS( 1, 5.3) 
  TYPE(TEXT) NAME(ukoly->dzacUkolu)       CPOS(18, 5.3) CLEN( 12) BGND(13)
  TYPE(TEXT) CAPTION(ukon�en dne)         CPOS(35, 5.3) 
  TYPE(TEXT) NAME(ukoly->dkonUkolu)       CPOS(52, 5.3) CLEN( 12) BGND(13)
*
  TYPE(MLE) NAME('ukoly->mpopisUkol')     FPOS(65,.2) SIZE(38,6.5) RESIZE(yx) SCROLL(ny)  READONLY(y)

TYPE(End)

TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(105.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Seznam �kol� ...)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
  TYPE(PushButton) POS(82.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
TYPE(END)

