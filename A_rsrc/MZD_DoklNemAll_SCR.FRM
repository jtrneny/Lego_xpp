TYPE(drgForm) DTYPE(10) TITLE(Nemocenské dávky - pøehled všech èerpaných nemocenských dávek) SIZE(100,25) FILE(mzdnemoc)  ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_doklhrmz_CRD) OBDOBI(MZD) PRINTFILES(mzddavhdw:croobcpppv=croobcpppv,   ;                                                                                                                                       mzddavitw:croobcpppv+ndoklad=croobcpppv+ndoklad) ;                                                                                                            COMMFILES( mzddavhdw: )  

 
*TYPE(Action) CAPTION(~KmenPRA )     EVENT(Pohyby_DOKLADY)         TIPTEXT(Kmenové údaje pracovníka)
*TYPE(Action) CAPTION(~PracKal )     EVENT(mzd_prackalendar_in)    TIPTEXT(Pracovní kalendáø-odpracovaná doba)
*TYPE(Action) CAPTION(~GenNEMHD)     EVENT(mzd_newObdNemocHD)      TIPTEXT(Založí hlavièky pokraèujících nemocenek z pøedchozího období)


TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(99.0,11.00) RESIZE(YN)
  TYPE(DBrowse) FPOS(0.3,1.5) SIZE(98.75,9.5) FILE(MZDNEMOC) INDEXORD(7)      ;
                FIELDS(nPoradi                    , ; 
                       cnazev::25                 , ;
                       dDatumOd::12               , ;    
                       dDatumDo::12               , ;    
                       dDatPoriz::12              , ;
                       noscisprac                 , ;
                       nporpravzt                 , ; 
                       ctypDoklad                 , ;
                       ctypPohybu                 )  ;  
                CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) ITEMMARKED(itemMarked) POPUPMENU(y)


* INFO pokud zavolá SCR z msPrc_mo a nemá doklady nic nevidí
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.2,1.25) RESIZE(yx)
*   TYPE(TEXT) NAME( msPrc_mo->cJmenoRozl)            CPOS( 1.5, 0.6) FONT(5)  CLEN(30) 
*    TYPE(TEXT) CAPTION([ )                            CPOS(31.5, 0.6)          CLEN( 2)
*    TYPE(TEXT) NAME( msPrc_mo->nosCisPrac)            CPOS(33  , 0.6)          CLEN( 6) PICTURE(99999)
*    TYPE(TEXT) CAPTION(/)                             CPOS(38.5, 0.6)          CLEN( 2)
*    TYPE(TEXT) NAME( msPrc_mo->nporPraVzt)            CPOS(41  , 0.6)          PICTURE(999) 
*    TYPE(TEXT) CAPTION(] )                            CPOS(44  , 0.6)          CLEN( 2)
  TYPE(END)

TYPE(END)


TYPE(TabPage) CAPTION(Položky dokladu) FPOS(.4,11.4) SIZE(99.2,13.4) RESIZE(yy) OFFSET(1,82) SUBTABS(A1, A2, A3)

  TYPE(TabPage) CAPTION(Seznam položek) TTYPE(3) FPOS(.7,1.2) SIZE(97.7,12) Resize(yy) OFFSET(2,81) TABHEIGHT( 1) SUB(A1) PRE(TABSELECT)
    TYPE(DBrowse) FPOS(0.20,0.10) SIZE(96.75,11.00) FILE(MZDDAVIT) INDEXORD(7)      ;
                  FIELDS(nOrdItem:Pol:4,           ;
                         nDruhMzdy:DrMz:5,         ;
                         dDatumOd::12,             ;    
                         dDatumDo::12,             ;    
                         nSazbaDokl::10,           ;
                         nDnyDoklad,               ; 
                         nHodDoklad,               ;
                         nMnPDoklad,               ;
                         nMzda)                    ;
                  CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(n)
  TYPE(End)

*                         M->nazevDruhu_Mzdy::15,   ;


  TYPE(TabPage) CAPTION(Detail položky) TTYPE(3) FPOS(0.7,1.2) SIZE(97.7, 12) RESIZE(yy) OFFSET(18,66) TABHEIGHT( 1) SUB(A2) PRE(TABSELECT)
    TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(95.2, 9.9)  RESIZE(yy) CTYPE(2)
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)
  TYPE(End)

  TYPE(TabPage) CAPTION(Likvidace položky) TTYPE(3) FPOS(0.7, 1.2) SIZE( 97.7,12) OFFSET(33,51) RESIZE(yy) TABHEIGHT( 1) SUB(A3) PRE(TABSELECT)
*    TYPE(DBrowse) FPOS(0.2,0.1) SIZE( 96.75,11.0)  RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(4);
*                  FIELDS( cUcetMD  , ;
*                          cUcetDAL , ;
*                          nKcMD    , ;
*                          nKcDAL   , ;
*                          cText    , ;
*                          nDoklad  , ;
*                          cObdobi  , ;
*                          cDenik   , ;
*                          cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 )                 
  TYPE(End

TYPE(End)


TYPE(End)    



          