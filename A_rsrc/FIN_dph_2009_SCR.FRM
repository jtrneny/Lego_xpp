TYPE(drgForm) DTYPE(10) TITLE(Daòová pøiznání od ... 1.1.2009 ...) SIZE(100,23.5)             ;
                                                                   PRINTFILES(dph_2009:cobdobidan=cobdobidan,    ;
                                                                              VYKDPH_SW:cobdobidan=cobdobidan  ) ;
                                                                   COMMFILES(dph_2009:cobdobidan=cobdobidan,     ;
                                                                              VYKDPH_SW:cobdobidan=cobdobidan  ) 

  TYPE(Action) CAPTION(~Zpracovat)     EVENT(dph_Insert)   TIPTEXT(Zpracovat uzávìrku dph )
  TYPE(Action) CAPTION(z~Rušit)        EVENT(dph_Delete)   TIPTEXT(Zrušit uzávìrku dph)
  TYPE(Action) CAPTION(o~Pravit)       EVENT(dph_Edit)     TIPTEXT(Úprava uzávìrky dph)

  TYPE(DBrowse) FPOS(.5,1.4) SIZE(99.5,12.4) FILE(DPH_2009)                                ; 
                                             FIELDS(cOBDOBIDAN:obdDaò                      , ; 
                                                    dSESDNE:datZpr                         , ;
                                                    cSESJMENO:výkaz Sestavil:36            , ;
                                                    nPRIPLNENI:pøijPlnìní::@ 9 999 999 999 , ;
                                                    nUSKPLNENI:uskutPlnìní::@ 9 999 999 999, ;
                                                    nR065d:daòPovinnost::@ 9 999 999 999   , ;
                                                    nR066o:nadmìrOdpoè::@ 9 999 999 999      ) ;
                                             CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemSelected) POPUPMENU(y)

  TYPE(Static) STYPE(13) SIZE(99,9) FPOS(0.5,14) CTYPE(2) RESIZE(yx)
    TYPE(STATIC) FPOS(0.3,0) SIZE(98.5,1.6) STYPE(14) CTYPE(2) RESIZE(yx)
* 1
      TYPE(TEXT) CAPTION(Zdaòovací období:   mìsíc  ) CPOS(20,0.2 ) CLEN(24) FONT(2)
      TYPE(TEXT) NAME(DPH_2009 ->nM)                  CPOS(44,0.25) CLEN( 5) PP(2) BGND(13) FONT(5) CTYPE(2)
      TYPE(TEXT) CAPTION(ètvrtletí)                   CPOS(50,0.2 ) CLEN( 8) FONT(2)
      TYPE(TEXT) NAME(DPH_2009 ->nQ)                  CPOS(59,0.25) CLEN( 5) PP(2) BGND(13) FONT(5) CTYPE(2)
      TYPE(TEXT) CAPTION(rok)                         CPOS(65,0.2 ) CLEN( 6) FONT(2)
      TYPE(TEXT) NAME(DPH_2009 ->nROK)                CPOS(71,0.25) CLEN( 6) PP(2) BGND(13) FONT(5) CTYPE(2)
    TYPE(END) 

* 2
    TYPE(TEXT) CAPTION(Daò na výstupu)              CPOS(30,3.2 ) CLEN(22) FONT(2)   
    TYPE(TEXT) NAME(DPH_2009 ->nR063d)              CPOS(58,3.2 ) CLEN(13) PP(2) BGND(13) FONT(5) CTYPE(2) PICTURE(@N 9,999,999,999)

* 3
    TYPE(TEXT) CAPTION(Odpoèet danì)                CPOS(30,4.2 ) CLEN(22) FONT(2)   
    TYPE(TEXT) NAME(DPH_2009 ->nR064o)              CPOS(58,4.2 ) CLEN(13) PP(2) BGND(13) FONT(5) CTYPE(2) PICTURE(@N 9,999,999,999)

* 4
    TYPE(TEXT) CAPTION(Vlastní daòová povinnost)    CPOS(30,5.2 ) CLEN(22) FONT(2)   
    TYPE(TEXT) NAME(DPH_2009 ->nR065d)              CPOS(58,5.2 ) CLEN(13) PP(2) BGND(13) FONT(5) CTYPE(2) PICTURE(@N 9,999,999,999)

* 5
    TYPE(TEXT) CAPTION(Nadmìrný odpoèet)            CPOS(30,6.2 ) CLEN(22) FONT(2)   
    TYPE(TEXT) NAME(DPH_2009 ->nR066o)              CPOS(58,6.2 ) CLEN(13) PP(2) BGND(13) FONT(5) CTYPE(2) PICTURE(@N 9,999,999,999)

* 6
    TYPE(TEXT) CAPTION(Zmìna daòové povinnosti)     CPOS(30,7.2 ) CLEN(22) FONT(2)   
    TYPE(TEXT) NAME(DPH_2009 ->nR067d)              CPOS(58,7.2 ) CLEN(13) PP(2) BGND(13) FONT(5) CTYPE(2) PICTURE(@N 9,999,999,999)
  TYPE(End)

  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(99,1.25)
    TYPE(TEXT) CAPTION(Rok zpracování) CPOS(60,0.6) CLEN(15) CTYPE(3) FONT(5)

    TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(78.5,0.5) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)


