TYPE(drgForm) DTYPE(10) TITLE(Docházka osob - zamìstnancù za období - w) SIZE(120,27)         ;
              GUILOOK(Action:y,IconBar:y) CARGO(DOH_dochazkadny_IN) OBDOBI(DOH)               ;
              PRINTFILES(osoby:ncisosoby=ncisosoby,                                           ;
                         dspohyby:ncisosoby=ncisosoby+cobdobi=cobdobi,                        ;
                         tmpsumkow:ncisosoby=ncisosoby+cobdobi=cobdobi)                       ;
              COMMFILES(osoby:,dspohyby:,dotermin:)  



 TYPE(Action) CAPTION(~Hromadnì)    EVENT(InputOfDochazka)       TIPTEXT(Hromadné vytvoøení docházky)
 TYPE(Action) CAPTION(a~Ktdatdos)   EVENT(AktZOldDat)            TIPTEXT(Aktualizace dat z pùvodních dat z DOSU)
 TYPE(Action) CAPTION(~Aktualdat)   EVENT(AktDsPohyby)           TIPTEXT(Aktualizace dat z terminálù)
 TYPE(Action) CAPTION(~ZrušAktDat)  EVENT(DelAktDsPoh)           TIPTEXT(Zruší aktualizaci dat z terminálù)



*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
  TYPE(DBrowse) FPOS(0.5,1.40) SIZE(56.5,25.45) FILE(OSOBY)        ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy)                ;
                 FIELDS( M->is_Doh_and_idKarty::2.6::2, ;
                         M->is_Pritomen:pri:2.6::2    , ;
                         cIdOsKarty:IdKar:7           , ;    
                         nCisOsoby                    , ;    
                         nOsCisPrac:OsÈísPrac         , ;
                         cJmenoRozl:Jméno:30          , ;
                         cKmenStrPr:KmenStø)            ;
                  CURSORMODE(3) PP(7) STABLEBLOCK(stableBlock)  


 TYPE(TabPage) TTYPE(4) CAPTION(Docházka) OFFSET(2,79) FPOS(57,1.40) SIZE(61.8,25.45)  RESIZE(yx) PRE(tabSelect) TABBROWSE(2)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(60.6,24.0) RESIZE(YX)
   TYPE(DBrowse) FPOS(-0.3,0.20) SIZE(59.0,23.80) FILE(DSPOHYBY) INDEXORD(9) RESIZE(yx)                      ;
                FIELDS( nDen,                      ;
                        cZkrDne:ZkrDne,            ;
                        cKodPrer:Pøíchod,          ;
                        cCasBeg:èasPø,       ;
                        cKodPrerE:Odchod,          ;
                        cCasEnd:èasOd,        ;
                        nCasCelCPD:Celkem za den,  ;
                        cobdobi                 )  ;
                CURSORMODE(3) PP(4)
  TYPE(End)
 TYPE(End)

* paravá strana tabNum = 2
 TYPE(TabPage) TTYPE(4) CAPTION(Sumáø) OFFSET(21,59) FPOS(57,1.40) SIZE(61.8,25.45)  RESIZE(yx) PRE(tabSelect) SUBTABS(A2,A3) TABBROWSE(3)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(60.6,24.0) RESIZE(YX)
    TYPE(DBrowse) FPOS( -.3,0.20) SIZE(61,16) FILE(TMInfSUMw) INDEXORD(1) RESIZE(yx)                      ;
                CURSORMODE(3) PP(4)     ;
                    FIELDS( cNazSumRad:Sumaèní údaj:23.5, ;
                            nHOD_den:HoDen            , ;
                            nDNY_tyden:DnTýd          , ;
                            nHOD_tyden:HoTýd          , ; 
                            nDNY_mesic:DnMìs          , ;
                            nHOD_mesic:HoMìs            )  

* pravá strana dolní záložky
   TYPE(TabPage) TTYPE(4) CAPTION(Hodiny) OFFSET( 2,79) FPOS(1,16.1) SIZE(60,7.5)  SUB(A2) RESIZE(yy) 
     TYPE(STATIC) STYPE(14) FPOS(1.0,0.3) SIZE(47.5,1.0) RESIZE(XX)
       TYPE(TEXT) CAPTION( Celkem za)     CPOS( 1.0, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Den )          CPOS(17.0, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Týden )        CPOS(28.5, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Mìsíc )        CPOS(41.0, 0.1)  CLEN(10)  
     TYPE(End)

    TYPE(TEXT) CAPTION(Fond___PD  :)     CPOS(1.0, 1.7) FONT(1)  CLEN(12)  
     TYPE(TEXT) NAME(tmcelsumw->nhoddenK)     CPOS( 16.6, 1.7) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodtydenK)   CPOS( 29.0, 1.7) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodmesicK)   CPOS( 40.0, 1.7) CLEN(10) FONT(1) 

    TYPE(TEXT) CAPTION(Z docházky  :)    CPOS(1.0, 2.6) FONT(1)  CLEN(12)  
     TYPE(TEXT) NAME(tmcelsumw->nhoddenD)     CPOS( 16.6, 2.6) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodtydenD)   CPOS( 29.6, 2.6) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodmesicD)   CPOS( 40.0, 2.6) CLEN(10) FONT(1) 

    TYPE(TEXT) CAPTION(Z výroby__  :)    CPOS(1.0, 3.5) FONT(1)  CLEN(12)  
     TYPE(TEXT) NAME(tmcelsumw->nhoddenV)     CPOS( 16.6, 3.5) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodtydenV)   CPOS( 29.6, 3.5) CLEN(10) FONT(1) 
     TYPE(TEXT) NAME(tmcelsumw->nhodmesicV)   CPOS( 40.0, 3.5) CLEN(10) FONT(1) 

    TYPE(STATIC) STYPE(15) FPOS(1.0,5.1) SIZE(47.5, .8) RESIZE(XX)
      TYPE(TEXT) CAPTION(Rozdíl        :)      CPOS(  1.0, -.1) FONT(1)  CLEN(12)  
      TYPE(TEXT) NAME(tmcelsumw->nhoddenR)     CPOS( 15.5, -.1) CLEN(10) FONT(6) 
      TYPE(TEXT) NAME(tmcelsumw->nhodtydenR)   CPOS( 28.5, -.1) CLEN(10) FONT(6) 
      TYPE(TEXT) NAME(tmcelsumw->nhodmesicR)   CPOS( 39.7, -.1) CLEN(10) FONT(6) 
    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
   TYPE(End)


   TYPE(TabPage) TTYPE(4) CAPTION(Dny)    OFFSET(21,59) FPOS(1,16.1) SIZE(60,7.5)  SUB(A3) RESIZE(yy) 
     TYPE(STATIC) STYPE(14) FPOS(1.0,0.3) SIZE(47.5,1.0) RESIZE(XX)
       TYPE(TEXT) CAPTION( Celkem za)     CPOS( 1.0, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Den )          CPOS(17.0, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Týden )        CPOS(28.5, 0.1)  CLEN(10)  
       TYPE(TEXT) CAPTION( Mìsíc )        CPOS(41.0, 0.1)  CLEN(10)  
     TYPE(End)

     TYPE(TEXT) CAPTION(Fond___PD  :)     CPOS(1.0, 1.7) FONT(1)  CLEN(12)  
      TYPE(TEXT) NAME(tmcelsumw->ndnydenK)     CPOS( 16.6, 1.7) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnytydenK)   CPOS( 30.0, 1.7) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnymesicK)   CPOS( 41.2, 1.7) CLEN(10) FONT(1) 

     TYPE(TEXT) CAPTION(Z docházky  :)    CPOS(1.0, 2.6) FONT(1)  CLEN(12)  
      TYPE(TEXT) NAME(tmcelsumw->ndnydenD)     CPOS( 16.6, 2.6) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnytydenD)   CPOS( 30.0, 2.6) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnymesicD)   CPOS( 41.2, 2.6) CLEN(10) FONT(1) 

     TYPE(TEXT) CAPTION(Z výroby__  :)    CPOS(1.0, 3.5) FONT(1)  CLEN(12)  
      TYPE(TEXT) NAME(tmcelsumw->ndnydenV)     CPOS( 16.6, 3.5) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnytydenV)   CPOS( 30.0, 3.5) CLEN(10) FONT(1) 
      TYPE(TEXT) NAME(tmcelsumw->ndnymesicV)   CPOS( 41.2, 3.5) CLEN(10) FONT(1) 

     TYPE(STATIC) STYPE(15) FPOS(1.0,5.1) SIZE(47.5, .8) RESIZE(XX)
       TYPE(TEXT) CAPTION(Rozdíl        :)      CPOS(  1.0, -.1) FONT(1)  CLEN(12)  
       TYPE(TEXT) NAME(tmcelsumw->ndnydenR)     CPOS( 15.5, -.1) CLEN(10) FONT(6) 
       TYPE(TEXT) NAME(tmcelsumw->ndnytydenR)   CPOS( 29.0, -.1) CLEN(10) FONT(6) 
       TYPE(TEXT) NAME(tmcelsumw->ndnymesicR)   CPOS( 40.2, -.1) CLEN(10) FONT(6) 
     TYPE(End)

     TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
   TYPE(End)

*   TYPE(STATIC) STYPE(13) FPOS(1.0,18.1) SIZE(63,5.5) RESIZE(YN)
*     TYPE(TEXT) CAPTION( den )          CPOS(18.5, 0.6)  CLEN(12)  
*     TYPE(TEXT) CAPTION( týden )        CPOS(30.5, 0.6)  CLEN(12)  
*     TYPE(TEXT) CAPTION( mìsíc )        CPOS(42.5, 0.6)  CLEN(12)  
*     TYPE(TEXT) CAPTION(Z docházky:)    CPOS(1.0, 1.7) FONT(6)  CLEN(12)  
**    TYPE(TEXT) NAME(tmcelsumw->nhoddenF)     CPOS( 15.5, 1.7) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodtydenF)   CPOS( 27.5, 1.7) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodmesicF)   CPOS( 39.5, 1.7) CLEN(10) FONT(6) 
*     TYPE(TEXT) CAPTION(Z výroby  :)    CPOS(1.0, 2.8) FONT(6)  CLEN(12)  
**    TYPE(TEXT) NAME(tmcelsumw->nhoddenV)     CPOS( 15.5, 2.8) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodtydenV)   CPOS( 27.5, 2.8) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodmesicV)   CPOS( 39.5, 2.8) CLEN(10) FONT(6) 
*     TYPE(TEXT) CAPTION(Rozdíl    :)    CPOS(1.0, 4.0) FONT(6)  CLEN(12)  
**    TYPE(TEXT) NAME(tmcelsumw->nhoddenR)     CPOS( 15.5, 4.0) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodtydenR)   CPOS( 27.5, 4.0) CLEN(10) FONT(6) 
**    TYPE(TEXT) NAME(tmcelsumw->nhodmesicR)   CPOS( 39.5, 4.0) CLEN(10) FONT(6) 
*  TYPE(End)  

  TYPE(End)
  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)


 TYPE(TabPage) TTYPE(4) CAPTION(Terminál) OFFSET(40,40) FPOS(57,1.40) SIZE(61.8,25.45)  RESIZE(yx) PRE(tabSelect) TABBROWSE(4)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(60.6,24.0) RESIZE(YX)
   TYPE(DBrowse) FPOS(-0.3,0.20) SIZE(59.0,23.80) FILE(DOTERMIN) INDEXORD(7) RESIZE(yx)                      ;
                FIELDS( dDatum,                      ;
                        cKodPreR,                    ;
                        cCas,                        ; 
                        cDenVtydnu,                  ;
                        cTypPrer,                    ;
                        cAdrTerm,                    ;
*                        tPohyb,                      ;    
                        cSNTerm                   )  ;
                CURSORMODE(3) PP(4)

  TYPE(End)
  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)


 TYPE(TabPage) TTYPE(4) CAPTION(Info) OFFSET(59,22) FPOS(57,1.40) SIZE(61.8,23.30)  RESIZE(yx) PRE(tabSelect)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(60.6,24.0) RESIZE(YX)
    TYPE(DBrowse) FPOS(-.3, .2) SIZE(59,.2) SIZE(59,23.8) FILE(PRSMLDOH) ;
                  POPUPMENU(n) INDEXORD(8) RESIZE(yy) SCROLL(ny)         ;
                  FIELDS( M->is_Stavem_prSml::2.4::2                   , ;
                          cdruPraVzt:druhPv:8                          , ; 
                          nosCisPrac:osÈísPrac                         , ; 
                          nporPraVzt:poøPv:4                           , ;
                          ntypPraVzt:pv:4                              , ;
                          ntypZamVzt:zamVz:4                           , ;
                          dDatNast:datNástupu:10                       , ;
                          dDatVyst:datVýstupu:10                       )  ;
                  CURSORMODE(3) PP(7)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
 TYPE(End)


*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(119.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Osoby pro docházku)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(82, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 23) CAPTION(~Osoby docházka) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)

TYPE(END)
