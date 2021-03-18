TYPE(drgForm) DTYPE(10) TITLE(Pokrytí objednávek pøijatých ...) SIZE(110,10) FILE(VZTAHOBJw) GUILOOK(All:n) BORDER(4)

  TYPE(DBROWSE) FPOS(0,1.3) SIZE(109.9,8.7) FILE(VZTAHOBJw)                        ;
                                          FIELDS(NCISFIRMY:firma              , ;
                                                 M->nazev_firmy:název firmy:26, ;
                                                 DDATDOODB:datDod             , ;
                                                 DDATREODB:datRez             , ;
                                                 CCISLOBINT:èísloObj          , ;
                                                 NMNOZKODOD:množKobj          , ;
                                                 NMNOZOBDOD:množObj           , ;
                                                 M->stavZakaz::3                ) ;
                                          ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny)

*   GETY v gridu
*                                                    M->stavZakaz                       ) ;  
  TYPE(GET) FPOS(0,0) FLEN( 8) NAME(VZTAHOBJw->NMNOZOBDOD) GROUPS(6)

  TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(110,1.3) CTYPE(2)
    TYPE(Text) CAPTION(Pokrytí objednávek pøijatých ...) CPOS(1,0.1)  FONT(5)
    TYPE(PushButton) POS(106.9,.05) SIZE(3,1) EVENT(140000002) ICON1(102) ICON2(202) ATYPE(1)
  TYPE(End)


