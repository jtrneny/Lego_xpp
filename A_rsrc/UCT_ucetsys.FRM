TYPE(drgForm) SIZE(100,22) DTYPE(10) TITLE(Seznam otevøených období ...) FILE(UCETSYS) 

**  TYPE(Action) CAPTION(~Uzavøení) EVENT(switch) TIPTEXT(Uzavøe/Otevøe období úlohy)             

* Browser definition
  TYPE(DBrowse) FPOS(0,1.5) SIZE(100,12.35) FILE(ucetsys)                      ;
                                            FIELDS( M->sysObdobi:sys:2::1    , ;
                                                    M->usrObdobi:usr:2::1    , ;
                                                    M->zavren::2::2          , ;
                                                    M->aktuc_Ks:a:2::2       , ; 
                                                    M->rokObdobi:rok/obd:7   , ;
                                                    M->otevrelKdo:otevøel:28 , ;
                                                    M->uctovalKdo:úètoval:26 , ;
                                                    M->uzavrelKdo:uzavøel:28   ) ;
                                           ITEMMARKED(itemMarked) INDEXORD(3) CURSORMODE(3) PP(7) SCROLL(ny) 

*                                                     M->aktuc_Ks:a:2::1       , ;     

*  TYPE(DBrowse) FPOS(0,1.5) SIZE(100,14.5) FILE(ucetsys)  ;
*                                       FIELDS(UCT_ucetsys_BC(0)::1::2     , ;
*                                              UCT_ucetsys_BC(1)::1::2     , ;
*                                              UCT_ucetsys_BC(2):ROK/OBD:7 , ;
*                                              UCT_ucetsys_BC(3):OTEVØEL:28, ;
*                                              UCT_ucetsys_BC(4):ÚÈTOVAL:26, ;
*                                              UCT_ucetsys_BC(6):UZAVØEL:28  ) ;
*                                       CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(3) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(Static) STYPE(12) SIZE(99.6,1.3) FPOS(0.2,0.1) CTYPE(2) RESIZE(xx)
    TYPE(ComboBox) NAME(UCT_ucetsys:CULOHA) FPOS(1,.15) FLEN(28) VALUES(a,a,a) ;
                                                                ITEMSELECTED(comboItemSelected)

    TYPE(ComboBox) NAME(M->NROK) FPOS(84,.15) FLEN(15)  VALUES(a,a,a) ;
                                                        COMBOINIT(comboBoxInit) TEMSELECTED(comboItemSelected)



*    TYPE(ComboBox) NAME(UCT_ucetsys:NROK) FPOS(84,.15) FLEN(15)  VALUES(a,a,a) ;
*                                                                 COMBOINIT(comboBoxInit) TEMSELECTED(comboItemSelected)

  TYPE(End) 

* pro nastevení období na uživatele a system
  TYPE(Static) STYPE(12) SIZE(99,2.7) FPOS(0.5,13.4) RESIZE(y) CTYPE(2)
   TYPE(TEXT) CAPTION(Pøenastavené období pro uživatele a system ...) FONT(5) CPOS(1,.5) 

   TYPE(CHECKBOX) NAME(ucetsys->laktObd) FPOS(60, .5) FLEN(27) ;
                                                      VALUES(T:   systemové aktuální období    ,F:   systemové aktuální období) ;
                                                      TIPTEXT(Nastavení aktuálního systémpvého obdobi (ALT_S))  

   TYPE(CHECKBOX) NAME(M->e_usrObdobi)   FPOS(60,1.5) FLEN(27) ;
                                                      VALUES(T:   aktuální období pro uživatele,F:   aktuální období pro uživatele) ;
                                                      TIPTEXT(Nastavení aktuálního obdobi pro uživatele (ALT_U))

  TYPE(End)


* Info definition
  TYPE(Static) STYPE(13) SIZE(99,5.6) FPOS(0.5,16.2) RESIZE(y) CTYPE(2)
* 1
      TYPE(Text) CAPTION(Otevøel dne)    CPOS( 1,1)
      TYPE(Text) NAME(DOTVDAT)           CPOS(17,1) CLEN(10) BGND(13) PP(2) 
      TYPE(Text) CAPTION(uživatel)       CPOS(35,1) 
      TYPE(Text) NAME(COTVKDO)           CPOS(45,1) CLEN(10) BGND(13) PP(2) 
* 2
      TYPE(Text) CAPTION(Úètoval dne)    CPOS( 1,2)
      TYPE(Text) NAME(DUCTDAT)           CPOS(17,2) CLEN(10) BGND(13) PP(2) 
      TYPE(Text) CAPTION(uživatel)       CPOS(35,2) 
      TYPE(Text) NAME(CUCTKDO)           CPOS(45,2) CLEN(10) BGND(13) PP(2) 
* 3
      TYPE(Text) CAPTION(Aktualizoval dne) CPOS( 1,3)
      TYPE(Text) NAME(DAKTDAT)           CPOS(17,3) CLEN(10) BGND(13) PP(2) 
      TYPE(Text) CAPTION(uživatel)       CPOS(35,3) 
      TYPE(Text) NAME(CAKTKDO)           CPOS(45,3) CLEN(10) BGND(13) PP(2) 
* 4
      TYPE(Text) CAPTION(Uzavøel dne)      CPOS( 1,4)
      TYPE(Text) NAME(DUZVDAT)           CPOS(17,4) CLEN(10) BGND(13) PP(2) 
      TYPE(Text) CAPTION(uživatel)       CPOS(35,4) 
      TYPE(Text) NAME(CUZVKDO)           CPOS(45,4) CLEN(10) BGND(13) PP(2) 

      TYPE(Static) STYPE(12) SIZE(28.5,2) FPOS(68.5,3) CTYPE(2)
        TYPE(Text) CAPTION(období)         CPOS( 1,.5) CLEN(8)  FONT(5)
        TYPE(GET)  NAME(nobdobi)           FPOS(10,.5) FLEN( 5) PP(2) FONT(5)
        TYPE(Text) CAPTION(/)              CPOS(16,.5) CLEN(2)  FONT(5)
        TYPE(GET)  NAME(nrok)              FPOS(18,.5) FLEN( 8) PP(2) POST(postLastField)
      TYPE(End)
    TYPE(End)


