TYPE(drgForm) SIZE(110,25) DTYPE(10) TITLE(Poèáteèní stavy úètù ...) ;
                                     FILE(UCETPOCS)                  ;
                                     POST(postValidate) 


* Browser definition
  TYPE(DBrowse) FPOS(0,1.4) FILE(UCETPOCS)                          ;
                           FIELDS(nROK:Rok                        , ;
                                  cOBDOBI:Období                  , ;
                                  cUCETMD:SuAu_Ø:10               , ;
                                  M->cnaz_uct:název úètu:52       , ;
                                  nKCMDPSR:PoèStav-MD:15          , ;
                                  nKCDALPSR:PoèSstav-DAL:15         ) ;
                           SIZE(110,15.8) CURSORMODE(3) PP(7) POPUPMENU(y) INDEXORD(1)


* Edit definition
  TYPE(TabPage) FPOS( .3,17.6) SIZE(109.5, 7.3) CAPTION(Editace) OFFSET(10,80) SUB(A) RESIZE(ny) TABHEIGHT(0) TTYPE(3) PRE(tabSelect)

*  TYPE(Static) STYPE(15) SIZE(109.5,6.9) FPOS(0.3,17.6) RESIZE(y) CTYPE(2) 
* 1
*     TYPE(Text) CAPTION(Úèetní odbobí)    CPOS( 1, .4) CLEN(11)
*     TYPE(Get)  NAME(cOBDOBI)             FPOS(13, .4) FLEN(10) BGND(13) PP(1) PICTURE(99/99)

     TYPE(COMBOBOX) NAME(COBDOBI)         FPOS(12, .4) FLEN(12) VALUES(a,a,a,a) FCAPTION(OBD_úè) CLEN(11) CPOS( 1, .4) PP(1) FONT(5) GROUPS(1)
     TYPE(Text) CAPTION(datum zmìny)      CPOS(25, .4) CLEN(11) 
     TYPE(Get)  NAME(dDATZMENY)           FPOS(36, .4) FLEN(12) BGND(13) PP(1) CTYPE(2) PUSH(CLICKDATE)                              GROUPS(1) 
     TYPE(Text) CAPTION(SuAu_Ø)           CPOS(50, .4) CLEN( 8)
     TYPE(Get)  NAME(cUCETMD)             FPOS(62, .4) FLEN(10) BGND(13) PP(2) CTYPE(2)                                              GROUPS(1)
     TYPE(Text) NAME(C_UCTOSN->cNAZ_UCT)  CPOS(74, .4) CLEN(25)
* 2
     TYPE(Text) CAPTION(Úèetní deník)      CPOS(50,1.8) CLEN(12)
     TYPE(COMBOBOX) NAME(ucetpocs->cdenik) FPOS(62,1.8) FLEN(31) PP(2) ;
                    VALUES(WP:poèáteèní stav úèetní                  , ;
                           WX:poèáteèní stav nedokonèené výroby  )     ;
                    COMBOINIT(comboBoxInit)                            ;
                    ITEMSELECTED(comboItemSelected) 



* 3
     TYPE(Text) CAPTION(Poèáteèní stav)   CPOS(50,2.8) CLEN(12)
     TYPE(Get)  NAME(nKCMDPSR)            FPOS(62,2.8) FLEN(11) BGND(13) PP(1) CTYPE(2) GROUPS(1)                                            
     TYPE(Text) CAPTION((MD))             CPOS(75,2.8) CLEN( 5) FONT(5)
     TYPE(Get)  NAME(nKCDALPSR)           FPOS(81,2.8) FLEN(11) BGND(13) PP(1) CTYPE(2) GROUPS(1)
     TYPE(Text) CAPTION((DAL))            CPOS(94,2.8) CLEN( 6) FONT(5)

* NS *
    TYPE(GET) NAME(ucetpocs->cNAZPOL1) FPOS(  3,5.4) FLEN(10) FCAPTION(VýrStøedisko) CPOS( 3,4.4) CLEN(10) GROUPS(1)
    TYPE(GET) NAME(ucetpocs->cNAZPOL2) FPOS( 19,5.4) FLEN(10) FCAPTION(Výrobek)      CPOS(19,4.4) CLEN( 8) GROUPS(1)
    TYPE(GET) NAME(ucetpocs->cNAZPOL3) FPOS( 35,5.4) FLEN(10) FCAPTION(Zakázka)      CPOS(35,4.4) CLEN( 8) GROUPS(1)
    TYPE(GET) NAME(ucetpocs->cNAZPOL4) FPOS( 51,5.4) FLEN(10) FCAPTION(VýrMísto)     CPOS(51,4.4) CLEN( 8) GROUPS(1)
    TYPE(GET) NAME(ucetpocs->cNAZPOL5) FPOS( 67,5.4) FLEN(10) FCAPTION(Stroj)        CPOS(67,4.4) CLEN( 8) GROUPS(1)
    TYPE(GET) NAME(ucetpocs->cNAZPOL6) FPOS( 83,5.4) FLEN(10) FCAPTION(VýrOperace)   CPOS(83,4.4) CLEN(10) GROUPS(1)

    TYPE(STATIC) FPOS(0.3,4.8) SIZE(109,.2) STYPE(12) CTYPE(2)
    TYPE(End)
  TYPE(End)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109,1.25)
    TYPE(ComboBox) NAME(UCT_ucetpocs_scr:cDENIK) FPOS( 1,0.5)          ;
                                                 FLEN(30)  VALUES(WP:poèáteèní stav úèetní            , ;
                                                                  WX:poèáteèní stav nedokonèené výroby, ;
                                                                    :poèáteèní stav za všechny úèty     ) ;
                                                 ITEMSELECTED(comboItemSelected)

   
    TYPE(TEXT) CAPTION(Poèáteèní stav úètù pro) CPOS(69, .5) CLEN(20) CTYPE(3) FONT(5)
    TYPE(ComboBox) NAME(UCT_ucetpocs_scr:NROK) FPOS(90.5, .5)          ;
                                               FLEN(15)  VALUES(a,a,a) ;
                                               COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)

*     TYPE(STATIC) STYPE(3) FPOS(106, .5) SIZE( 19,19 ) CAPTION(114) 
     TYPE(STATIC) STYPE(5) FPOS(106, .1) SIZE( 25,25 ) CAPTION(315) 
  TYPE(END)


