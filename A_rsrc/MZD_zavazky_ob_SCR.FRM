TYPE(drgForm) DTYPE(10) TITLE(Mzdové závazky - doklady) SIZE(100,23) FILE(mzdzavhd)                      ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD) PRINTFILES(mzdzavhd:,                      ;      
                                                                         mzdzavit:ndoklad=ndoklad, ;
                                                                         ucetpol:cdenik=cdenik+ndoklad=ndoklad                                                                                                                                 mzdzavit:ndoklad=ndoklad )      ;  
                                                              COMMFILES( mzdzavhd:)   

TYPE(Action) CAPTION(~GenZavazky)    EVENT(GenZavazky)           TIPTEXT(Generuje závazky za období ...)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)

TYPE(Action) CAPTION(~Zruš_Závazky)  EVENT(DelZavazky)          TIPTEXT(Zruší generované závazky za období ...)


TYPE(STATIC) STYPE( 13) FPOS(.3,1.5) SIZE(99,21.3) RESIZE(YN)
  TYPE(DBrowse) FPOS(.3,.05) SIZE(98.75,21) FILE(MZDZAVHD) INDEXORD(1)      ;
                FIELDS(M->typDokladu:T:2.6::2         , ;
                       cObdobi:obd                    , ;
                       nDoklad:doklad:10              , ;
                       cucet:bankovní Úèet            , ; 
                       cVARSYM:varSymb:15             , ;
                       cTEXTFAKT:název závazku:22     , ;
                       nCENzakCEL:celkem:12:::1       , ;
                       nCENzahCEL:celkem v zah:12:::1 , ;
                       cNazev:zamìstnanec/intituce:30 , ;
                       nOsCisPrac:osÈís               , ;
                       nPorPraVzt:poøPV:3) ;  
                CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(yy) STABLEBLOCK(stableBlock) POPUPMENU(y) FOOTER(yy)
TYPE(END)

*
** QUICK FILTR **
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Mzdové závazky zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)

   TYPE(STATIC) STYPE(2) FPOS(62.5,.1) SIZE(35.2,1) RESIZE(nx)
     TYPE(PushButton) POS(.1,.46)   SIZE(35.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 
TYPE(END)
