TYPE(drgForm) DTYPE(10) TITLE(Kontrolní hlášení o DPH ...) SIZE(100,25)   ;
                                                           PRINTFILES(DPHkohHD:cIDhlaseni=cIDhlaseni,   ; 
                                                                      DPHkohIT:cIDhlaseni=cIDhlaseni,   ;
                                                                      dph_2015:cobdobidan=cobdobidan  ) ;
                                                           COMMFILES( DPHkohHD:cIDhlaseni=cIDhlaseni,   ; 
                                                                      DPHkohIT:cIDhlaseni=cIDhlaseni,   ;
                                                                      dph_2015:cobdobidan=cobdobidan  ) 

  TYPE(Action) CAPTION(~Zpracovat)     EVENT(dph_Insert)      TIPTEXT(Zpracovat kontrolní hlášení k DPH ... )
  TYPE(Action) CAPTION(z~Rušit)        EVENT(dph_Delete)      TIPTEXT(Zrušit kontrolní hlášení k DPH ...)
  TYPE(Action) CAPTION(o~Pravit)       EVENT(dph_Edit)        TIPTEXT(Oprava kontrolního hlášení k DPH ...)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(~Výkaz DPH)    EVENT(koh_vykDph_in)    TIPTEXT(Øádky výkazu DPH kontrolního hlášení ...)





  TYPE(DBrowse) FPOS(-.7, 1.4) SIZE(99.5,12) FILE(DPHkohHD)                                  ; 
                                             FIELDS(M->isruc_Oprava::3::2                  , ;
                                                    cIDhlaseni                             , ; 
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
                                                    nSumDaP313                               ) ;
                                             INDEXORD(1) CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y)


 
  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(1,90) CAPTION(A.1) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.1)
    TYPE(TEXT) CAPTION(A.1. Uskuteènìná zdanitelná plnìní v režimu pøenesení daòové povinnosti, u kterých je povinen pøiznat daò pøíjemce plnìní podle § 92a) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                                FIELDS(M->isedit_Parent::3::2           , ;
                                                       cOddilKoHl:oddíl                 , ;
                                                       nradek:èØádku                    , ;
                                                       cdic:diè_obìratele               , ;
                                                       cdanDoklad:daòDoklad:30          , ;
                                                       dvystFak:datUzp:10               , ;
                                                       nzaklD_dph:záklDanì              , ;
                                                       ctypPREdan:preDan                , ;   
                                                       cdenik:denik                     , ;
                                                       ndoklad:doklad                     ) ; 
                                                CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(10,82) CAPTION(A.2) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.2)
    TYPE(TEXT) CAPTION(A.2. Pøijatá zdanitelná plnìní, u kterých je povinen pøiznat daò pøíjemce dle § 108 odst.1 písm. b a c §24, §25) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                                FIELDS(M->isedit_Parent::3::2           , ;
                                                       cOddilKoHl:oddíl                 , ;
                                                       nradek:èØádku                    , ;
                                                       cdic                             , ;
                                                       cdanDoklad:daòDoklad:20          , ;
                                                       dvystFak:datPdp:10               , ;
                                                       nzaklDan_2:záklDaò_1             , ;
                                                       nsazDan_2:Daò_1                  , ;
                                                       nzaklDan_1:záklDaò_2             , ;
                                                       nsazDan_1:Daò_2                  , ;
                                                       nzaklDan_3:záklDaò_3             , ;
                                                       nsazDan_3:Daò_3                  , ;
                                                       cdenik:denik                     , ;
                                                       ndoklad:doklad                     ) ; 
                                                CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(18,75) CAPTION(A.3) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.3)
    TYPE(TEXT) CAPTION(A.3. Uskuteènìná plnìní ve zvláštním režimu pro investièní zlato podle § 101c odst. 1 písm. c bod 2) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                                FIELDS(M->isedit_Parent::3::2           , ;
                                                       cOddilKoHl:oddíl                 , ;
                                                       nradek:èØádku                    , ;
                                                       cdic                             , ;
                                                       cNazev:obchodní jméno:30         , ; 
                                                       cSidlo:sídlo:30                  , ;
                                                       cdanDoklad:daòDoklad:20          , ;
                                                       dvystFak:datUp:10                , ;
                                                       nOsvOdDan:osvPlnìní              , ;   
                                                       cdenik:denik                     , ;
                                                       ndoklad:doklad                     ) ; 
                                                CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)


  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(25,68) CAPTION(A.4) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.4)
    TYPE(TEXT) CAPTION(A.4. Uskuteènìná zdanitelná plnìní a pøijaté úplaty s povinností pøiznat daò dle § 108 odst. 1 písm. a s hodnotou nad 10.000,- Kè vèetnì danì a všechny provedené opravy podle § 44 bez ohledu na limit) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                                FIELDS(M->isedit_Parent::3::2           , ;
                                                       cOddilKoHl:oddíl                 , ;
                                                       nradek:èØádku                    , ;
                                                       cdic:diè_obìratele               , ;
                                                       cdanDoklad:daòDoklad:20          , ;
                                                       dvystFak:datPdp:10               , ;
                                                       nzaklDan_2:záklDaò_1             , ;
                                                       nsazDan_2:Daò_1                  , ;
                                                       nzaklDan_1:záklDaò_2             , ;
                                                       nsazDan_1:Daò_2                  , ;
                                                       nzaklDan_3:záklDaò_3             , ;
                                                       nsazDan_3:Daò_3                  , ;
                                                       ctypPREdan:preDan                , ;   
                                                       cdenik:denik                     , ;
                                                       ndoklad:doklad                     ) ; 
                                                CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)


 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(32,61) CAPTION(A.5) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A.5)
   TYPE(TEXT) CAPTION(A.5. Ostatní uskuteènìná zdanitelná plnìní a pøijaté úplaty s povinností pøiznat daò dle § 108 odst. 1 písm. a s hodnotou do 10.000,- Kè vèetnì danì, nebo plnìní, u nichž nevznikla povinnost vystavit daòový doklad) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
   TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                               FIELDS(M->isedit_Parent::3::2           , ;
                                                      cOddilKoHl:oddíl                 , ;
                                                      nzaklDan_2:záklDaò_1             , ;
                                                      nsazDan_2:Daò_1                  , ;
                                                      nzaklDan_1:záklDaò_2             , ;
                                                      nsazDan_1:Daò_2                  , ;
                                                      nzaklDan_3:záklDaò_3             , ;
                                                      nsazDan_3:Daò_3                    ) ;
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) 
  TYPE(End)


  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(39,54) CAPTION(A5i) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(A5I)
    TYPE(DBrowse) FPOS(-.7,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                            ;
                                               FIELDS(M->isedit_Parent::3::2           , ;
                                                      cOddilKoHl:oddíl                 , ;
                                                      cdic:diè_obìratele               , ;
                                                      cdanDoklad:daòDoklad:20          , ;
                                                      dvystFak:datUzp:10               , ;
                                                      nzaklDan_2:záklDaò_1             , ;
                                                      nsazDan_2:Daò_1                  , ;
                                                      nzaklDan_1:záklDaò_2             , ;
                                                      nsazDan_1:Daò_2                  , ;
                                                      nzaklDan_3:záklDaò_3             , ;
                                                      nsazDan_3:Daò_3                  , ;
                                                      nOsvOdDan:osvPlnnìní             , ;
                                                      ctypPREdan:preDan                , ;                                          
                                                      cdenik:denik                     , ;
                                                      ndoklad:doklad                     ) ;  
                                               CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)


  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(46,47) CAPTION(B.1) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.1)
    TYPE(TEXT) CAPTION(B.1. Pøijatá zdanitelná plnìní v režimu pøenesení daòové povinnosti, u kterých je povinen pøiznat daò pøíjemce podle § 92a) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                           ;
                                                FIELDS(M->isedit_Parent::3::2          , ;
                                                       cOddilKoHl:oddíl                , ;
                                                       nradek:èØádku                   , ;
                                                       cdic:diè_dodavatele             , ;
                                                       cdanDoklad:daòDoklad:20         , ;
                                                       dvystFak:datUzp:10              , ;
                                                       nzaklDan_2:záklDaò_1            , ;
                                                       nsazDan_2:Daò_1                 , ;
                                                       nzaklDan_1:záklDaò_2            , ;
                                                       nsazDan_1:Daò_2                 , ;
                                                       nzaklDan_3:záklDaò_3            , ;
                                                       nsazDan_3:Daò_3                 , ;
                                                       ctypPREdan:preDan               , ;  
                                                       cdenik:denik                    , ;
                                                       ndoklad:doklad                    ) ; 
                                                CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)



 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(53,40) CAPTION(B.2) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.2)
   TYPE(TEXT) CAPTION(B.2. Pøijatá zdanitelná plnìní a poskytnuté úplaty, u kterých pøíjemce uplatòuje nárok na odpoèet danì dle § 73 odst. 1 písm. a s hodnotou nad 10.000,- Kè vèetnì danì a všechny pøijaté opravy podle § 44 bez ohledu na limit) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
   TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                               FIELDS(M->isedit_Parent::3::2           , ;
                                                      cOddilKoHl:oddíl                 , ;
                                                      nradek:èØádku                    , ;
                                                      cdic:diè_dodavatele              , ;
                                                      cdanDoklad:daòDoklad:20          , ;
                                                      dvystFak:datPdp:10               , ;
                                                      nzaklDan_2:záklDaò_1             , ;
                                                      nsazDan_2:Daò_1                  , ;
                                                      nzaklDan_1:záklDaò_2             , ;
                                                      nsazDan_1:Daò_2                  , ;
                                                      nzaklDan_3:záklDaò_3             , ;
                                                      nsazDan_3:Daò_3                  , ;
                                                      ctypPREdan:preDan                , ;  
                                                      cdenik:denik                     , ;
                                                      ndoklad:doklad                     ) ;  
                                               CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)


 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(60,33) CAPTION(B.3) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B.3)
   TYPE(TEXT) CAPTION(B.3. Pøijatá zdanitelná plnìní a poskytnuté úplaty, u kterých pøíjemce uplatòuje nárok na odpoèet danì dle § 73 odst. 1 písm. a s hodnotou do 10.000,- Kè vèetnì danì) CPOS(.1,0) CLEN(99.4) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
   TYPE(DBrowse) FPOS(-.7,1.1) SIZE(98.5,9.4)  FILE(DPHkohIT)                            ;
                                               FIELDS(M->isedit_Parent::3::2           , ;
                                                      cOddilKoHl:oddíl                 , ;
                                                      nzaklDan_2:záklDaò_1             , ;
                                                      nsazDan_2:Daò_1                  , ;
                                                      nzaklDan_1:záklDaò_2             , ;
                                                      nsazDan_1:Daò_2                  , ;
                                                      nzaklDan_3:záklDaò_3             , ;
                                                      nsazDan_3:Daò_3                    ) ;
                                               CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)


 TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(67,26) CAPTION(B3i) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) SUB(B3I)
   TYPE(DBrowse) FPOS(0.5,0.1) SIZE(98.5,10)  FILE(DPHkohIT)                           ;
                                              FIELDS(M->isedit_Parent::3::2          , ;
                                                     cOddilKoHl:oddíl                , ;
                                                     nradek:èØádku                   , ;
                                                     cdic:diè_dodavatele             , ;
                                                     cdanDoklad:daòDoklad:20         , ;
                                                     dvystFak:datUzp:10              , ;
                                                     nzaklDan_2:záklDaò_1            , ;
                                                     nsazDan_2:Daò_1                 , ;
                                                     nzaklDan_1:záklDaò_2            , ;
                                                     nsazDan_1:Daò_2                 , ;
                                                     nzaklDan_3:záklDaò_3            , ;
                                                     nsazDan_3:Daò_3                 , ;
                                                     ctypPREdan:preDan               , ;    
                                                     cdenik:denik                    , ;
                                                     ndoklad:doklad                    ) ;  
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,13.8) SIZE(99.5,11) TTYPE(3) OFFSET(74,17) CAPTION(Komplet) TABHEIGHT(1) PRE(tabSelect) RESIZE(yx)
    TYPE(DBrowse) FPOS(-.7,.1) SIZE(98.5,10)  FILE(DPHkohIT)                            ;
                                              FIELDS(M->isedit_Parent::3::2           , ;
                                                     cOddilKoHl:oddíl                 , ;
                                                     cdic:diè_obìratele               , ;
                                                     cdanDoklad:daòDoklad:20          , ;
                                                     dvystFak:datUzp:10               , ;
                                                     nzaklDan_2:záklDaò_1             , ;
                                                     nsazDan_2:Daò_1                  , ;
                                                     nzaklDan_1:záklDaò_2             , ;
                                                     nsazDan_1:Daò_2                  , ;
                                                     nzaklDan_3:záklDaò_3             , ;
                                                     nsazDan_3:Daò_3                  , ;
                                                     nOsvOdDan:osvPlnnìní             , ;
                                                     ctypPREdan:preDan                , ;
                                                     cdenik:denik                     , ;
                                                     ndoklad:doklad                     ) ;  
                                              CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 
  TYPE(End)



  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(99,1.25)
    TYPE(TEXT) CAPTION(Rok zpracování) CPOS(60,0.6) CLEN(15) CTYPE(3) FONT(5)

    TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(78.5,0.5) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)



