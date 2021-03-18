TYPE(drgForm) DTYPE(10) TITLE(Seznam stojanù - výbìr) SIZE(80,15)    ;
                                                      GUILOOK(Action:n,Message:n,IconBar:n,Menu:n) 


  TYPE(DBROWSE) FPOS( 1, 2) SIZE(77,13) FILE(STOJANY)                 ;
                                        FIELDS(nstojan:stojan           , ;
                                               cnazStoj:název Stojanu:25, ;
                                               npocStav:poèStav         , ;
                                               nvydej:výdej             , ;
                                               naktStav:aktStav           ) ;
                                        CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(ny) RESIZE(yx) 


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(79, 1.25) RESIZE(yn) 
    TYPE(TEXT) CAPTION(Seznam odbìrných míst pro èerpání PHM ...)     CPOS(1.5, 0.6) FONT(7)  CLEN(50)
  TYPE(END)


