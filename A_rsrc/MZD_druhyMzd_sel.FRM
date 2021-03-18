TYPE(drgForm) DTYPE(10) TITLE(Seznam druhù mezd výbìr) SIZE(54.2,18)    ;
              GUILOOK(Action:n,IconBar:y:drgStdBrowseIconBar,Menu:n,Message:n) OBDOBI(MZD)

  TYPE(DBrowse) FPOS(0.5,1.5) SIZE(52.8,15.20) FILE(druhymz_S)       ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy) SCROLL(ny)       ;
                FIELDS( ndruhMzdy:druhMzdy            , ;
                        cnazevDmz:název druhu mzdy:34 , ;
                        ctypDmz:typMzdy                 ) ;
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(93.05,1.25) RESIZE(yn)
    TYPE(TEXT) CAPTION(Seznam druhù mezd k období) CPOS(1.5, 0.6) FONT(7)  CLEN(40) 
*    TYPE(TEXT) NAME( M->caption_contextText)     CPOS(1.5, 0.6) FONT(7)  CLEN(40)
*    TYPE(PushButton) POS(57.5,0.6)   SIZE(35,1.2) CAPTION(~Kompletní seznam osob v evidenci) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(END)


