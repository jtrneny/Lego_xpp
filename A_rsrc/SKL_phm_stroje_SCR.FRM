TYPE(drgForm) DTYPE(10) TITLE(Dopravní prostøedky - pro sledování PHM ...) FILE(STROJE) ;
              SIZE(120,25)                                                              ;
              OBDOBI(SKL)                                                               ; 
              CARGO(SKL_phm_stroje_in)                                                                   
            


  TYPE(DBrowse) FPOS(0,1.2) SIZE(120,12.4) FILE(STROJE)                   ;
                                        FIELDS(nTypStroje:typStroje:3   , ;
                                               cStroj:stroj:8           , ; 
                                               ninvCis:invÈíslo:10      , ;  
                                               cNazStroj:název stroje:25, ;
                                               ncisFirmy:Firma:6        , ;
                                               cSpzStroj:SPZ:22         , ;  
                                               cZnStroje:Znaèka:20      , ;
                                               M->spoMes_BC:spoMes:10   , ;
                                               M->spoRok_BC:spoRok:10     ) ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) POPUPMENU(y)


  TYPE(TABPAGE) FPOS(.5,14) SIZE(119,10.5) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.9) PRE(tabSelect)

    TYPE(Text) CAPTION(STROJE)                                  CPOS(70,3.2) CLEN(10) FONT(4) SIZE(30,1.0) CTYPE(3)
    TYPE(Text) CAPTION(Dopravní prostøedky - pro sledování PHM) CPOS(70,4.5) CLEN(20) FONT(5) SIZE(35,1.0) CTYPE(3)

    TYPE(GET)  NAME(ntypStroje)           FPOS(15, .5) FLEN(10) FCAPTION(Typ stroje) CPOS(1, .5) PP(2) NOREVISION() 
    TYPE(Text) NAME(c_stroje->cnazevTypu) CPOS(27, .5) CLEN(31) Font(5) PP(3) BGND(9)

    TYPE(GET)  NAME(cStroj)               FPOS(15,1.6) FLEN(10) FCAPTION(Èíslo stroje) CPOS( 1, 1.6) PP(2) NOREVISION() 
    TYPE(GET)  NAME(cnazStroj)            FPOS(27,1.6) FLEN(30) 
    TYPE(GET)  NAME(cspzStroj)            FPOS(75,1.6) FLEN(15) FCAPTION(SPZ stroje)   CPOS(63, 1.6) PP(2) 

    TYPE(GET)  NAME(ninvCis)              FPOS(15,2.7) FLEN(10) FCAPTION(invÈíslo_maj) CPOS( 1, 2.7) PP(2) 
    TYPE(TEXT) NAME(M->nazevMaj)          CPOS(27,2.7) CLEN(31) BGND(9)
 
    TYPE(GET)  NAME(ncisFirmy)            FPOS(15,3.8) FLEN(10) FCAPTION(Èíslo_firmy)  CPOS( 1, 3.8) PP(2) PUSH(fir_firmy_sel)
    TYPE(TEXT) NAME(cnazFirmy)            CPOS(27,3.8) CLEN(31) BGND(9)
*
    TYPE(GET)  NAME(nnorma_100)            FPOS(15,5.2) FLEN(10) FCAPTION(norma l/100km) CPOS( 1, 5.2) PP(2) 
    TYPE(GET)  NAME(nnorma_hod)            FPOS(37,5.2) FLEN(10) FCAPTION(norma l/hod)   CPOS(27, 5.2) CLEN(10) PP(2) 

* ns-stroje
    TYPE(Static) STYPE(8) SIZE(117,2.5) FPOS(.5,6.5) RESIZE(y)
      TYPE(Text) CAPTION(støStroje)       CPOS( 3, .1) CLEN(12) PP(3) BGND( 1) FONT(5) 
      TYPE(Text) NAME(stroje->cNAZPOL1)   CPOS( 3,1.2) CLEN(13) PP(2) BGND(13) 

      TYPE(Text) FCAPTION(Výrobek)        CPOS(19, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(stroje->cNAZPOL2)   CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Zakázka)        CPOS(35, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(stroje->cNAZPOL3)   CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrMísto)       CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(stroje->cNAZPOL4)   CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Stroj)          CPOS(67, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(stroje->cNAZPOL5)   CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(VýrOperace)     CPOS(83, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(stroje->cNAZPOL6)   CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Static) STYPE(12) SIZE(96,.2) FPOS(1,.4)
      TYPE(End)
    TYPE(End)

* tabPage se nemá kam potavit na focus - !
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,14) SIZE(119,10.5) TTYPE(3) OFFSET(14,73) CAPTION(spotøeba) TABHEIGHT(.9) PRE(tabSelect)

*   TYPE(Text) CAPTION(spotøeba PHM   ___           mìs : ..........               rok : ..........         od TU : .......... ...%  od DU : .......... ...% )     CPOS( 3,1)


   TYPE(Text) CAPTION(spotøeba PHM   ___           mìsíc : ) CPOS( 3, 1) CLEN(25)
   TYPE(Text) NAME(m->spoMes_BC)                             CPOS(31, 1) CLEN(10) PP(3) BGND( 1) FONT(5) PICTURE(9999999.99)
   TYPE(Text) CAPTION(rok :)                                 CPOS(42, 1) CLEN( 6) 
   TYPE(Text) NAME(m->spoRok_BC)                             CPOS(48, 1) CLEN(10) PP(3) BGND( 1) FONT(5) PICTURE(9999999.99)


    TYPE(Static) STYPE(12) SIZE(117,4.5) FPOS(1,3) RESIZE(y) GROUPS(OLE)
      TYPE(TEXT) CAPTION(Sledovat spotøebu oleje) CPOS( 1, .1) CLEN(18) PP(3)
      TYPE(TEXT) CAPTION(sklad)                   CPOS(27, .1) CLEN( 5) PP(3)
      TYPE(TEXT) CAPTION(sklPoložka)              CPOS(40, .1) CLEN( 8) PP(3)
      TYPE(TEXT) CAPTION(název sklPoložky)        CPOS(60, .1) CLEN(13) PP(3)   

      TYPE(TEXT) CAPTION(motorový    ->) CPOS( 1, 1.2) CLEN(25)
      TYPE(Get)  NAME(cskladMOo)         FPOS(27, 1.2) FLEN(10) 
      TYPE(Get)  NAME(csklPolMOo)        FPOS(40, 1.2) FLEN(17) PUSH(skl_cenzboz_sel)
      TYPE(Get)  NAME(cnazZboMOo)        FPOS(60, 1.2) FLEN(30) 

      TYPE(TEXT) CAPTION(pøevodový   ->) CPOS( 1, 2.2) CLEN(25)
      TYPE(Get)  NAME(cskladPRo)         FPOS(27, 2.2) FLEN(10)
      TYPE(Get)  NAME(csklPolPRo)        FPOS(40, 2.2) FLEN(17) PUSH(skl_cenzboz_sel)
      TYPE(Get)  NAME(cnazZboPRo)        FPOS(60, 2.2) FLEN(30) 

      TYPE(TEXT) CAPTION(hydraulický ->) CPOS( 1, 3.2) CLEN(25)
      TYPE(Get)  NAME(cskladHYo)         FPOS(27, 3.2) FLEN(10) 
      TYPE(Get)  NAME(csklPolHYo)        FPOS(40, 3.2) FLEN(17) PUSH(skl_cenzboz_sel)
      TYPE(Get)  NAME(cnazZboHYo)        FPOS(60, 3.2) FLEN(30) 

      TYPE(Static) STYPE(8) SIZE(119, .12) FPOS(.2,.6)
      TYPE(End)
    TYPE(End)

* tabPage se nemá kam potavit na focus - !
      TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(119,1.25)
    TYPE(TEXT) CAPTION(Výdej PHM na stroje dle dnù pohybu) CPOS(67, .6) CLEN(30) CTYPE(3) FONT(5)

    TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(99, .5) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)
