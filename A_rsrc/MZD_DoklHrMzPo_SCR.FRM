TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Položky dokladù) SIZE(100,25) FILE(mzddavit)                    ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_doklhrmz_CRD) OBDOBI(MZD) PRINTFILES(mzddavhd:croobcpppv=croobcpppv, ;                                                                                                                                       mzdyit:croobcpppv=croobcpppv, ; 
                                                                                         tmprinemw  )                  ;  
                                                                              COMMFILES( tmprinemw )  

 
TYPE(Action) CAPTION(~Kmen_PRA )  EVENT(Pohyby_DOKLADY)         TIPTEXT(Kmenové údaje pracovníka)
TYPE(Action) CAPTION(~PracKal )   EVENT(mzd_prackalendar_in)    TIPTEXT(Pracovní kalendáø-odpracovaná doba)
TYPE(Action) CAPTION(~Dochazka )  EVENT(mzd_prackalendar_in)    TIPTEXT(Docházka do zamìstnání)
TYPE(Action) CAPTION(~Imp_MZLI)   EVENT(mzd_importdokl_ml)      TIPTEXT(Import mzdových lístkù z výroby)
TYPE(Action) CAPTION(~Exp_MZLI)   EVENT(ImportMzLOld)           TIPTEXT(Export mzdových lístkù)
TYPE(Action) CAPTION(~GenNEMHD)   EVENT(mzd_newObdNemocHD)      TIPTEXT(Založí hlavièky pokraèujících nemocenek z pøedchozího období)

TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(99.0,15.00) RESIZE(YN)

   TYPE(DBrowse) FPOS(0.3,1.5) SIZE(98.75,13.5)  FILE(MZDDAVIT) INDEXORD(7)      ;
                FIELDS(nDoklad:Doklad:10,           ;
                       nOrdItem:Pol:5,           ;
                       nDruhMzdy:DrMz:5,         ;
                       M->nazevDruhu_Mzdy::15,   ;
                       dDatumOd,                 ;    
                       dDatumDo,                 ;    
                       nSazbaDokl::10,           ;
                       nDnyDoklad,               ; 
                       nHodDoklad,               ;
                       nMnPDoklad,               ;
                       nMzda,                    ;
                       nHrubaMZD,                ;
                       nUcetMzdy,                ; 
                       cnazpol1,                 ; 
                       cnazpol2,                 ; 
                       cnazpol3,                 ; 
                       cnazpol4,                 ; 
                       cnazpol5,                 ; 
                       cnazpol6)                 ;
                CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(y)

* INFO pokud zavolá SCR z msPrc_mo a nemá doklady nic nevidí
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.7,1.25) RESIZE(yx)
   TYPE(TEXT) NAME( msPrc_mo->cJmenoRozl)            CPOS( 1.5, 0.6) FONT(5)  CLEN(30) 
    TYPE(TEXT) CAPTION([ )                            CPOS(31.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( msPrc_mo->nosCisPrac)            CPOS(33  , 0.6)          CLEN( 6) PICTURE(99999)
    TYPE(TEXT) CAPTION(/)                             CPOS(38.5, 0.6)          CLEN( 2)
    TYPE(TEXT) NAME( msPrc_mo->nporPraVzt)            CPOS(41  , 0.6)          PICTURE(999) 
    TYPE(TEXT) CAPTION(] )                            CPOS(44  , 0.6)          CLEN( 2)
  TYPE(END)
TYPE(END)


TYPE(TabPage) CAPTION(Detail položky) FPOS(0.4, 15.4) SIZE(99.2,9.4) RESIZE(yy) OFFSET(1,82) SUBTABS(A1, A2, A3)


     TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(98.2, 8.0)  RESIZE(yy) CTYPE(2)
       TYPE(TEXT) CAPTION(Vnitro úèet: )                 CPOS(1.5, 0.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->nUcetMzdy)             CPOS(18,  0.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Støedisko náklad.: )           CPOS(1.5, 1.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol1)              CPOS(18,  1.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Výrobek/výkon.: )              CPOS(1.5, 2.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol2)              CPOS(18,  2.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Zakázka: )                     CPOS(1.5, 3.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol3)              CPOS(18,  3.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Výrobní místo: )               CPOS(1.5, 4.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol4)              CPOS(18,  4.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Stroj: )                       CPOS(1.5, 5.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol5)              CPOS(18,  5.6)          CLEN( 15)
       TYPE(TEXT) CAPTION(Operace: )                       CPOS(1.5, 6.6)          CLEN( 15)
        TYPE(TEXT) NAME( mzddavit->cNazPol6)              CPOS(18,  6.6)          CLEN( 15)

     


       TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
     TYPE(End)
                 
 TYPE(End)


 TYPE(TabPage) CAPTION(Likvidace položky) FPOS(0.4,15.4) SIZE( 99.2,9.4) OFFSET(18,66) RESIZE(yy) PRE(TABSELECT)
   TYPE(DBrowse) FPOS(0.40,0.20) SIZE(97.50, 8.0) RESIZE(yy) CURSORMODE(3) SCROLL(yy) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(4);
                 FIELDS( cUcetMD,;
                         cUcetDAL,;
                         nKcMD,;
                         nKcDAL,;
                         cText,;
                         nDoklad,;
                         cObdobi,;
                         cDenik,;
                         cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) 
                 
 TYPE(End
TYPE(End)    


          