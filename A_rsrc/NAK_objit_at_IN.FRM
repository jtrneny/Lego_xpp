TYPE(drgForm) DTYPE(10) TITLE(Pokrytí objednávek pøijatých ...) SIZE(110,14) FILE(objit_at) GUILOOK(All:n) BORDER(4)

*  TYPE(STATIC) STYPE(2) FPOS(4,2) SIZE(96,12)
    TYPE(DBROWSE) FPOS(0,0) SIZE(109.9,7.8) FILE(OBJIT_AT)                             ;
                                             FIELDS(NCISFIRMY:odbìratel              , ;
                                                    CNAZEV:název Odbìratele:27.7     , ;
                                                    DDATDOODB:datDod                 , ;
                                                    DDATREODB:datRez                 , ;
                                                    CCISLOBINT:èísloObj              , ;
                                                    NMNOZKODOD:množKObj              , ;
                                                    NMNOZOBDOD:množObj               , ;
                                                    M->stavZakaz                       ) ;  
                                             ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny)

*   GETY v gridu
    TYPE(GET) FPOS(0,0) FLEN( 8) NAME(OBJIT_AT->NMNOZOBDOD) GROUPS(7)
*  TYPE(END)

