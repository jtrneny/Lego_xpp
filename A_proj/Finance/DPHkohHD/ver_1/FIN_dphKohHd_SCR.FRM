TYPE(drgForm) DTYPE(10) TITLE(Kontrolní hlášení o DPH ...) SIZE(100,25)             ;
                                                          PRINTFILES(dph_2015:cobdobidan=cobdobidan,    ;
                                                                     VYKDPH_SW:cobdobidan=cobdobidan,   ; 
                                                                     DPHEVDW:cobdobidan=cobdobidan  ) ;
                                                          COMMFILES(dph_2015:cobdobidan=cobdobidan,     ;
                                                                    VYKDPH_SW:cobdobidan=cobdobidan,   ; 
                                                                    DPHEVDW:cobdobidan=cobdobidan  ) 

  TYPE(Action) CAPTION(~Zpracovat)     EVENT(dph_Insert)   TIPTEXT(Zpracovat kontrolní hlášení k DPH ... )
  TYPE(Action) CAPTION(z~Rušit)        EVENT(dph_Delete)   TIPTEXT(Zrušit kontrolní hlášení k DPH ...)
*  TYPE(Action) CAPTION(o~Pravit)       EVENT(dph_Edit)     TIPTEXT(Úprava uzávìrky dph)

  TYPE(DBrowse) FPOS(.5,1.4) SIZE(99.5,12) FILE(DPHkohHD)                                    ; 
                                             FIELDS(cIDhlaseni                             , ; 
                                                    cRP:Ø                                  , ;
                                                    cOP:O                                  , ;
                                                    cDP:D                                  , ;
                                                    cOBDOBIDAN:obdDaò                      , ; 
                                                    cIdVyzvy:IdVyzvy                       , ; 
                                                    dSESDNE:datZpr:10                      , ;
                                                    cSESJMENO:výkaz Sestavil:36            , ;
                                                    nSumDaP01                              , ; 
                                                    nSumDaP02                              , ;
                                                    nSumDaP40                              , ;
                                                    nSumDaP41                              , ;
                                                    nSumDaP25                              , ; 
                                                    nSumDaP10                              , ;  
                                                    nSumDaP11                              , ; 
                                                    nSumDaP03_                             ) ;
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y)



  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(1,89) CAPTION(Komplet) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    cNazev                           , ; 
                                                    cSidlo                           , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                        , ;
                                                    nOsvOdDan                        , ;  
                                                    nkodplneni                       ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(10,82) CAPTION(A.1) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.1)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nzaklDan_1                       , ;
                                                    nkodPlneni                       ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(18,75) CAPTION(A.2) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.2)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                        ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(25,68) CAPTION(A.3) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.3)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cNazev                           , ; 
                                                    cSidlo                           , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nOsvOdDan                        ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(32,61) CAPTION(A.4) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.4)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                        , ;
                                                    nOsvOdDan                        , ;  
                                                    nkodplneni                       ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(39,54) CAPTION(A.5) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.5)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                          ) ;
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(46,47) CAPTION(B.1) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.1)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                        , ;
                                                    nkodplneni                       ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(53,40) CAPTION(B.2) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.2)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nradek                           , ;
                                                    cdic                             , ;
                                                    cdanDoklad                       , ;
                                                    dvystFak                         , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                        , ;
                                                    nkodplneni                       ) ;   
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(60,33) CAPTION(B.3) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.3)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                             FIELDS(cOddilKoHl                       , ;
                                                    nzaklDan_1                       , ;
                                                    nsazDan_1                        , ;
                                                    nzaklDan_2                       , ;
                                                    nsazDan_2                        , ;
                                                    nzaklDan_3                       , ;
                                                    nsazDan_3                          ) ;
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 

      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(99,1.25)
    TYPE(TEXT) CAPTION(Rok zpracování) CPOS(60,0.6) CLEN(15) CTYPE(3) FONT(5)

    TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(78.5,0.5) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)



