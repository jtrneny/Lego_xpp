TYPE(drgForm) DTYPE(10) TITLE(Èisté mzdy za období - Vypoètené èisté mzdy) SIZE(110,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD) PRINTFILES(mzdyit:croobcpppv=croobcpppv, ;                                     
                                                                          vykazw:cgrpkey=croobcpppv) 


  TYPE(Action) CAPTION(~Doklady)       EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøízení dokladù o mzdì)
  TYPE(Action) CAPTION(~HromadnýVýp)   EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Hromadný výpoèet èisté mzdy)
  TYPE(Action) CAPTION(~PrepPodDov)    EVENT(mzd_tmpdovol_)         TIPTEXT(Dovolená pøepoèet podklady MZDYHD)
  TYPE(Action) CAPTION(~PrepZùsDov)    EVENT(mzd_zustDovPrep_)      TIPTEXT(Dovolená pøepoèet zùstatky MSPRC_MO)
  TYPE(Action) CAPTION(~PrepMzdyHD)    EVENT(mzd_tmpPREPhd_)        TIPTEXT(Pøepoèet MZDYHD - nemoc)


  TYPE(STATIC) STYPE( 13) FPOS(0.3,1.3) SIZE(110,9) RESIZE(YN)

    TYPE(DBrowse) FPOS(0,.2) SIZE(110,8.80) FILE(MzdyHD) INDEXORD(1) RESIZE(yx)    ;
                  FIELDS( cObdobi:MzObd,                  ;  
                          nOsCisPrac,                     ;
                          nPorPraVzt:PoøPV,               ;
                          cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:25, ;  
                          nHrubaMzda,                     ; 
                          nCistPrije,                     ; 
                          nCastKVypl,                     ;
                          nDnyFondKD,                     ;
                          nDnyFondPD,                     ;
                          nHodFondPD,                     ;
                          nOdvoSocPZ,                     ;
                          nOdvoZdrPZ,                     ; 
                          nNezdCasZD,                     ;
                          nZdanMzdaP,                     ; 
                          nDanCelkem,                     ; 
                          nNemocCelk  )                   ;
                 CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)  POPUPMENU(y)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Mzda) OFFSET(1,85) FPOS(0.75,10.5) SIZE(110,14.25) RESIZE(yy) SUBTABS(A1, A2, A3)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(109.7,12.9) RESIZE(yy)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(0.5,0.2) SIZE(109, 12.5) Resize(yx) OFFSET(2,81) TABHEIGHT( 1) SUB(A1) PRE(TABSELECT)

      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(108,10.80) FILE(MzdyIT) INDEXORD(23)           ;
                    FIELDS( cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            M->nazevDMz::35,            ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
    TYPE(End)

    TYPE(TabPage) CAPTION(InfoPoložky) TTYPE(3) FPOS(0.5,0.2) SIZE(108, 12.5) Resize(yx) OFFSET(18,66) TABHEIGHT( 1) SUB(A2) PRE(TABSELECT)
*      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,10.80) FILE(MzdyIT) INDEXORD(1)           ;
*                    FIELDS( cDenik, nDoklad, nDruhMzdy, DRUHYMZD->cNazevDMz       ;
*                          , nSazbaDokl, nDnyDoklad, nHodDoklad, nMnPDoklad, nMzda  )       ;
*                 CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

    TYPE(TabPage) CAPTION(Doklady) TTYPE(3) FPOS(0.5,0.2) SIZE(108, 12.5) Resize(yx) OFFSET(34,50) TABHEIGHT( 1) SUB(A3) PRE(TABSELECT)
      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(108,10.80) FILE(MzdDavIT) INDEXORD(1)           ;
                    FIELDS( cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            M->mzdDavit_nazevDMz::35,   ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
    TYPE(End)

  TYPE(End)
TYPE(End)

* 2
TYPE(TabPage) TTYPE(4) CAPTION(Likvidace dokladu) OFFSET(14.9,72) FPOS(0.75,10.5) SIZE(110,14.25)  RESIZE(yy)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(109.7,12.9) RESIZE(yy)
    TYPE(DBrowse) FPOS(-.3,0.2) SIZE(109,12.8)  RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(4);
                  FIELDS( cUcetMD,;
                          cUcetDAL,;
                          nKcMD,;
                          nKcDAL,;
                          cText,;
                          nDoklad,;
                          cObdobi,;
                          cDenik,;
                          cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) 

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
TYPE(End)



*TYPE(TabPage) TTYPE(4) CAPTION(DosMzda) OFFSET(14.9,72) FPOS(0.75,10.5) SIZE(110,14.25)  RESIZE(yy)
*
*  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(109.7,12.9) RESIZE(yy)
*
*    TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(109,12.8) FILE(Mzdy) INDEXORD(1)           ;
*                  FIELDS( cDenik:De,                  ;
*                          nDoklad,                    ;
*                          nDruhMzdy:Dmz,              ;
*                          M->mzdy_nazevDMz::35,       ;
*                          nDnyDoklad,                 ;
*                          nHodDoklad,                 ; 
*                          nMzda,                      ;
*                          nSazbaDokl,                 ; 
*                          nMnPDoklad )                ;
*               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)
*
*    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*  TYPE(End)
*TYPE(End)


*** MOŽNÁ QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.2,1.1) RESIZE(yn)
  TYPE(TEXT) CAPTION(Vypoètené èisté mzdy zamìstnancù)     CPOS(1.5, 0.5) FONT(5)  CLEN(30)
*
*   TYPE(STATIC) STYPE(2) FPOS(85,0.09) SIZE(23.2,1.0) RESIZE(nx)
*     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*   TYPE(END) 
TYPE(END)
