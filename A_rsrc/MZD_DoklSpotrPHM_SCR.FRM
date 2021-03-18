TYPE(drgForm) DTYPE(10) TITLE(Pøehled spotøeby PHM - položky dokladù) SIZE(100,25) FILE(mzddavit)                    ;
              GUILOOK(Action:n,IconBar:y) CARGO(MZD_doklhrmz_CRD)  OBDOBI(MZD) PRINTFILES(mzddavhd:croobcpppv=croobcpppv, ;                                                                                                                                       mzdyit:croobcpppv=croobcpppv, ; 
                                                                                         tmprinemw  )                  ;  
                                                                              COMMFILES( tmprinemw )  

 
//TYPE(Action) CAPTION(~GenNEMHD)   EVENT(mzd_newObdNemocHD)      TIPTEXT(Založí hlavièky pokraèujících nemocenek z pøedchozího období)

TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(99.0,15.00) RESIZE(YN)

   TYPE(DBrowse) FPOS(0.3,1.5) SIZE(98.75,13.5)  FILE(MZDDAVIT) INDEXORD(7)      ;
                FIELDS(nDoklad:Doklad:10,           ;
                       nOrdItem:Pol:5,           ;
                       cnazpol5,                 ; 
                       cnazpol4,                 ; 
                       ncisPrace,                ;
                       nDruhMzdy:DrMz:5,         ;
                       dDatumOd::14,             ;    
                       dDatumDo::14,             ;    
                       nSpotrPHM,                ;
                       nHodDoklad,               ;
                       nMnPDoklad,               ;
                       nUcetMzdy,                ; 
                       cnazpol1,                 ; 
                       cnazpol2,                 ; 
                       cnazpol3,                 ; 
                       cnazpol6)                 ;
                CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(y)

* INFO pokud zavolá SCR z msPrc_mo a nemá doklady nic nevidí
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.7,1.25) RESIZE(yx)
    TYPE(TEXT) CAPTION(Pøehled spotøeby PHM - dle položek dokladù )                            CPOS(24.5, 0.6)          CLEN( 30)
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


* TYPE(TabPage) CAPTION(Likvidace položky) FPOS(0.4,15.4) SIZE( 99.2,9.4) OFFSET(18,66) RESIZE(yy) PRE(TABSELECT)
*   TYPE(DBrowse) FPOS(0.40,0.20) SIZE(97.50, 8.0) RESIZE(yy) CURSORMODE(3) SCROLL(yy) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(4);
*                 FIELDS( cUcetMD,;
*                         cUcetDAL,;
*                         nKcMD,;
*                         nKcDAL,;
*                         cText,;
*                         nDoklad,;
*                         cObdobi,;
*                         cDenik,;
*                         cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) 
*                 
* TYPE(End


TYPE(End)    


                    