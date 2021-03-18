TYPE(drgForm) DTYPE(10) TITLE(Seznam objednávek vystavených _ výbìr) SIZE(110,25);
                                                                     GUILOOK(Action:y,Message:n,IconBar:n,Menu:n) ;
                                                                     POST(POSTVALIDATE)

* Objednávky vystavené k dodavateli
  TYPE(Static) STYPE(13) SIZE(110,10.8) FPOS(0,1.2) RESIZE(yy)
    TYPE(DBrowse) FILE(OBJVYSIT) INDEXORD(2)                            ;
                  FIELDS( M->objVysit_is::2.6::2                      , ;
                          M->stav_objvysit::2.6::2                    , ;
                          cCisObj:èísloObj_vystavené                  , ;
                          ccisSklad:sklad                             , ;
                          csklPol:sklPoložka                          , ;
                          CNAZZBO:Název zboží:30                      , ;
                          M->wds_objvysit_kDis:množKDisp:13           , ;
                          nMnozObDod:mn_Objednáno                     , ;
                          nMnozPlDod:mn_Plnìní                        , ;
                          nCenNaODOD:nákupní cena                     , ;
                          nZboziKat:katZboží                          , ;
                          nDoklad:doklad                              , ;
                          cCisZakaz:výrobní zakázka                   , ;
                          cCisZakazI:položka výrobní zakázky          , ;
                          M->cisObj_dodavatele:èísloObj_dodavatele:15)  ;
                  FPOS( -.2, -.1) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy) POPUPMENU(y) ITEMSELECTED( RecordSelected) STABLEBLOCK(stableBlock)
  TYPE(END)


*
** QUICK FILTR **
TYPE(STATIC) STYPE(13) FPOS(.2,.1) SIZE(109.6,1.25) RESIZE(yn)

  TYPE(Text) NAME(FIRMY->cNazev)         CPOS(  .5, .01) CLEN( 26) 
  TYPE(TEXT) CAPTION([ )                 CPOS(26.5, .01) CLEN(  2)
  TYPE(Text) NAME(FIRMY->nCisFirmy)      CPOS(27.5, .01) CLEN(  5) PICTURE(99999)
  TYPE(TEXT) CAPTION(])                  CPOS(32.5, .01) CLEN(  2)
  TYPE(Text) NAME(FIRMY->cSIDLO)         CPOS(35  , .01) CLEN( 28)
     
  TYPE(STATIC) STYPE(2) FPOS(73, .1) SIZE( 41, 1) RESIZE(nx)
    TYPE(PushButton) POS(  .01, 0)   SIZE( 30  , 1) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(30   , 0)   SIZE(  3  , 1) EVENT(mark_Doklad) ICON1(427) ICON2(428) ATYPE(1)
    TYPE(PushButton) POS(33   , 0)   SIZE(  3  , 1) EVENT(save_marked) ICON1(429) ICON2(430) ATYPE(1)
  TYPE(END) 
TYPE(END)


*
* košík
  TYPE(Static) STYPE(1) SIZE(110,13.3) FPOS(.5,12) CTYPE(2) RESIZE(yy)

    TYPE(Static) STYPE(10) FPOS(103, .5) SIZE( 6, 3.1) RESIZE(nx) 
      TYPE(PushButton)                              POS( .1, 2.1 ) ; 
                                                    SIZE( 6, 3.1) EVENT(smallBasket) ICON1(208) ICON2(108) ATYPE(1) ;
                                                    CAPTION(2) 
    TYPE(End)

    TYPE(TEXT) CAPTION(množství)     CPOS( 11, .02)                  
    TYPE(TEXT) CAPTION(v MJ)         CPOS( 26, .02) CLEN(7)           
    TYPE(TEXT) CAPTION(cena/MJ)      CPOS( 41, .02)                   
    TYPE(TEXT) CAPTION(celkemPøíjem) CPOS( 56, .00) CLEN(10)          
    TYPE(TEXT) CAPTION(vedlejšíNákl) CPOS( 70, .00) CLEN(10)          
    TYPE(TEXT) CAPTION(cenaCelkem)   CPOS( 84, .00)                   


  TYPE(STATIC) STYPE(12) FPOS( 0, .5) SIZE(103, 3) CTYPE(2) GROUPS(M) RESIZE(yx) 
    TYPE(STATIC) STYPE(3) FPOS( 0, .11) SIZE( 20,40 ) CAPTION(337)
    
    TYPE(Text) CAPTION( Dok_mj)    CPOS( 2.5,  .5) CLEN( 8)    
    TYPE(Text) CAPTION( Skl_mj )   CPOS( 2.5, 1.5) CLEN( 8)    

    TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 10, .5) FLEN( 13)                              GROUPS(SKL_PRI)
    TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 25, .5) FLEN( 10)                              GROUPS(SKL_PRI)  PUSH(SKL_c_prepmj_sel)   
    TYPE(GET)  NAME( pvpitemWW->ncenNADOzm)    FPOS( 40, .5) FLEN( 13)                              GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 55, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)      GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( pvpitemWW->nrozPOHzm)     CPOS( 69, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)      GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_BLACK)
    TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 83, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)      GROUPS(SKL_PRI)
    TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS( 97, .5) CLEN(  5)                              GROUPS(SKL_PRI,SETFONT,9.Cambria,GRA_CLR_RED)
*
    TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 10, 1.5) FLEN( 13) PP(1)                       GROUPS(SKL_PRI) PUSH(skl_vyrCis_modi) 
    TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 25, 1.5) CLEN(  8) BGND(13) CTYPE(1)           GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 40, 1.5) CLEN( 14) BGND(13) CTYPE(2)           GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 55, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)     GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( pvpitemWW->nRozdilPoh)    CPOS( 69, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)     GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_BLACK)
    TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 83, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)     GROUPS(SKL_PRI)
    TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS( 97, 1.5) CLEN( 5)                              GROUPS(SKL_PRI,SETFONT,9.Cambria,GRA_CLR_RED)
  TYPE(END)

*  M->pvpitem_isOk::2.6::2                         , ;

    TYPE(dBrowse) FPOS(-.7,3.8) SIZE(108,8.8) FILE(PVPITEMww) INDEXORD(4)   ;
                  FIELDS( nordItem:pol:5                                  , ;
                          csklPol:sklPoložka:14                           , ;
                          cnazZbo:název zboží:30                          , ;
                          nmnozPRdod:množ_Nadokl:12                       , ;
                          czkratJedn:mj                                   , ;
                          ncenNAPdod:cena_Zamj                            , ;
                          nCenaCelk:cenaCelkem                            , ;
                          nCenapZBO:cena_bezDph                           , ;
                          nCenapDZBO:cena_sDph                               ) ;
                  CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yx) POPUPMENU(nn) FOOTER(y) STABLEBLOCK(stableBlock)
  TYPE(End)


*
* neviditelné pomocné položky
TYPE(TEXT) NAME(pvpitemWW->ccisObj)     FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemWW->csklPol)     FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemWW->cnazZbo)     FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemWW->ckatCzbo)    FPOS(0,0) CLEN(0)

TYPE(TEXT) NAME(pvpitemww->ccisSklad)   FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nintCount)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->ncislPOLob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->cfile_iv)    FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nrecs_iv)    FPOS(0,0) CLEN(0) 
*
** naplníme sID z vazebních souborù
TYPE(TEXT) NAME(pvpitemww->nPVPTERM)    FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nOBJVYSIT)   FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nOBJITEM)    FPOS(0,0) CLEN(0) 
*
TYPE(TEXT) NAME(pvpitemWW->nucetSkup)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemWW->cucetSkup)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemWW->ctypSKLcen)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->_nrecOr)     FPOS(0,0) CLEN(0) 


