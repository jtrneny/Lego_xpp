TYPE(drgForm) DTYPE(10) TITLE(MzdovÈ z·vazky - doklady) SIZE(100,25) FILE(mzdzavhd)                      ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD) PRINTFILES(mzdzavhd:,                      ;      
                                                                         mzdzavit:ndoklad=ndoklad, ;
                                                                         ucetpol:cdenik=cdenik+ndoklad=ndoklad                                                                                                                                 mzdzavit:ndoklad=ndoklad )      ;  
                                                              COMMFILES( mzdzavhd:)   
 
*TYPE(Action) CAPTION(~Kmen_PRA )  EVENT(Pohyby_DOKLADY)         TIPTEXT(KmenovÈ ˙daje pracovnÌka)
*TYPE(Action) CAPTION(~PracKal )   EVENT(mzd_prackalendar_in)    TIPTEXT(PracovnÌ kalend·¯-odpracovan· doba)
*TYPE(Action) CAPTION(~Dochazka )  EVENT(mzd_prackalendar_in)    TIPTEXT(Doch·zka do zamÏstn·nÌ)
TYPE(Action) CAPTION(~GenZavazky)   EVENT(GenZavazky)           TIPTEXT(Generuje z·vazky za obdobÌ)

TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(99.0,11.00) RESIZE(YN)
  TYPE(DBrowse) FPOS(0.3,0.05) SIZE(98.75,10.80) FILE(MZDZAVHD) INDEXORD(1)      ;
                FIELDS(M->typDokladu:T:2.6::2         , ;
                       cObdobi:Obd                    , ;
                       nDoklad::10                    , ;
                       cucet                          , ; 
                       cVARSYM::15                    , ;
*                       FIRMY->cNAZEV::24             , ;
                       cTEXTFAKT:N·zev z·vazku:22     , ;
                       nCENzakCEL::12:::1             , ;
                       nCENzahCEL::12:::1             , ;
                       cNazev                         , ;
*                       dDatPoriz                      , ; 
                       nOsCisPrac:Os»Ìs               , ;
                       nPorPraVzt:Po¯PV:3)  ;  
                CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) STABLEBLOCK(stableBlock) POPUPMENU(y)
TYPE(END)


TYPE(TabPage) CAPTION(Poloûky dokladu) FPOS(0.4, 11.4) SIZE(99.2,13.4) RESIZE(yy) OFFSET(1,82) SUBTABS(A1, A2, A3)

  TYPE(TabPage) CAPTION(Seznam poloûek) TTYPE(3) FPOS(0.7,1.2) SIZE(97.7, 12) Resize(yy) OFFSET(2,81) TABHEIGHT( 1) SUB(A1) PRE(TABSELECT)
 
    TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(96.2, 10.4)  RESIZE(yy) CTYPE(2)

     TYPE(DBrowse) FPOS(0.20,0.20) SIZE(94.75,10.20) FILE(MZDZAVIT) INDEXORD(1)      ;
                FIELDS(nIntCount:Pol:4                , ;
                       cnazzbo:N·zev z·vazku:25       , ;
                       cucetSrz:˙Ëet::14              , ; 
                       cVARSYM::10                    , ;
                       nKonstSymb:ksymb:3             , ;
                       cSpecSymb::8                  , ;   
*                       FIRMY->cNAZEV::24             , ;
                       nCENzakCEL:Z·vazekTUZ:11:::1             , ;
                       nCENzahCEL:Z·vazekZAH:12:::1             ) ;
*                       dDatPoriz,   ; 
*                       nOsCisPrac:Os»Ìs,  ;
*                       nPorPraVzt:Po¯PV:3)  ;  
                CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(n)
       TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(End)

   TYPE(End)

   TYPE(TabPage) CAPTION(Detail poloûky) TTYPE(3) FPOS(0.7,1.2) SIZE(97.7, 12) RESIZE(yy) OFFSET(18,66) TABHEIGHT( 1) SUB(A2) PRE(TABSELECT)

     TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(95.2, 9.9)  RESIZE(yy) CTYPE(2)
       TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
     TYPE(End)

   TYPE(End)

   TYPE(TabPage) CAPTION(Likvidace poloûky) TTYPE(3) FPOS(0.7, 1.2) SIZE( 97.7,12) OFFSET(33,51) RESIZE(yy) TABHEIGHT( 1) SUB(A3) PRE(TABSELECT)
     TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(95.2, 9.9)  RESIZE(yy) CTYPE(2)
       TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
     TYPE(End)

*     TYPE(DBrowse) FPOS(0.2,0.1) SIZE( 96.75,11.0)  RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(1);
*                  FIELDS( cUcetMD,;
*                          cUcetDAL,;
*                          nKcMD,;
*                          nKcDAL,;
*                          cText,;
*                          nDoklad,;
*                          cObdobi,;
*                          cDenik,;
*                          cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) 
                  
   TYPE(End
 TYPE(End)


 TYPE(TabPage) CAPTION(Likvidace dokladu) FPOS(0.4,11.4) SIZE( 99.2,13.4) OFFSET(18,66) RESIZE(yy) PRE(TABSELECT)
    TYPE(Static) STYPE(12) FPOS(0.4,0.2) SIZE(96.9, 11.9)  RESIZE(yy) CTYPE(2)

      TYPE(DBrowse) FPOS(0.40,0.20) SIZE(94.50, 11.2) RESIZE(yy) CURSORMODE(3) SCROLL(yy) PP(7) FOOTER(y) FILE(UCETPOL) INDEXORD(1);
                   FIELDS( cUcetMD,;
                           cUcetDAL,;
                           nKcMD,;
                           nKcDAL,;
                           cText,;
                           nDoklad,;
                           cObdobi,;
                           cDenik,;
                           cNazpol1, cNazpol2, cNazpol3, cNazpol4, cNazpol5, cNazpol6 ) 
         TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
     TYPE(End)
                 
 TYPE(End
TYPE(End)              