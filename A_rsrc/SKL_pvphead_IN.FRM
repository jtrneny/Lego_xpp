TYPE(drgForm) DTYPE(10) TITLE(Pohybový doklad ... NEWx) SIZE(120, 28) FILE(PVPHEAD) ;
              GUILOOK(Action:y,Message:y,IconBar:Y:MyIconBar,Menu:n)               ;    
              PRE(preValidate) POST(POSTVALIDATE) OBDOBI(SKL)



  TYPE(STATIC) FPOS(0,0) SIZE(120,27.4) STYPE(13) CTYPE(2) RESIZE(yy)

* hd
    TYPE(TabPage) FPOS(0,0) SIZE(120,7) CAPTION(Hlavièka) OFFSET(0,90) RESIZE(yy) TABHEIGHT(0) TTYPE(3) SUBTABS(A) 


    TYPE(TEXT) CAPTION(pohyb)     CPOS(  2, .5)  CLEN(10) 
    TYPE(TEXT) CAPTION(sklad)     CPOS( 51, .5)  CLEN( 5)
    TYPE(TEXT) CAPTION(doklad)    CPOS( 73, .5)  CLEN( 6)
    TYPE(TEXT) CAPTION(datPohybu) CPOS( 94, .5)  CLEN( 9)

    TYPE(GET ) NAME(pvpheadW->ctypPohybu)     FPOS( 12, .5) FLEN(10) FONT(5) PP(2) NOREVISION() PUSH(skl_typPoh_sel)
    TYPE(TEXT) NAME(M->nazTYPpoh)             CPOS( 23, .5) CLEN(26) 
    TYPE(GET ) NAME(pvpheadW->ccisSklad)      FPOS( 57, .5) FLEN(10) FONT(5) PP(2) NOREVISION() PUSH(sklad_sel)

    TYPE(PushButton)                           POS( 68, .4) SIZE(4, .9) EVENT(ev_stornoDok) ICON1(114) ICON2(214) ATYPE(1) 

    TYPE(GET ) NAME(pvpheadW->ndoklad)        FPOS( 80, .5) FLEN(11) FONT(5) PP(2) NOREVISION()
    TYPE(GET)  NAME(pvpheadW->ddatPvp)        FPOS(104, .5) FLEN(11)               NOREVISION() PUSH(clickDate)


* hd
***  TYPE(TabPage) FPOS(0.4,2) SIZE(119,6) CAPTION(Hlavièka) OFFSET(0,90) RESIZE(ny) TABHEIGHT(0) TTYPE(3) SUBTABS(A) 

* SKL_PRI
    TYPE(STATIC) STYPE(12) FPOS(.1,1.7) SIZE(120,7) CAPTION(SKL_PRIHD) CTYPE(2) RESIZE(yx)                          GROUPS(SKL_PRIHD)

      TYPE(GET)      NAME(pvpheadW->nCisFirmy)  FPOS( 12, .7) FLEN( 8) FCAPTION( Dodavatel) CPOS(  2, .7) CLEN( 10) GROUPS(SKL_PRIHD) PUSH(SKL_FIRMY_SEL) NOREVISION()    TIPTEXT(100,102,103,104,115,142,177,400)
      TYPE(GET)      NAME(pvpheadW->cNazFirmy)  FPOS( 22, .7) FLEN(40)                                              GROUPS(SKL_PRIHD)                                     TIPTEXT(100,102,103,104,115,142,177,400) 

      TYPE(ComboBox) NAME(pvpHeadW->czahrMena)  FPOS( 68, .7) FLEN(21) PP(2) GROUPS(SKL_PRIHD) VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate) NOREVISION()
      TYPE(GET)      NAME(pvpHeadW->nkurZAHmen) FPOS( 96, .7) FLEN(10) FCAPTION(Kurz)    CPOS(89, .7) CLEN(7)  CTYPE(2) PP(2) GROUPS(SKL_PRIHD) NOREVISION()
      TYPE(GET)      NAME(pvpHeadW->nmnozPrep)  FPOS(108, .7) FLEN( 7)                                         CTYPE(2) PP(2) GROUPS(SKL_PRIHD) NOREVISION()                                      
  
      TYPE(GET)      NAME(pvpheadW->ccislOBint) FPOS(  1,3.2) FLEN(15) FCAPTION( Objednávka)        CPOS(  2,2.2)   GROUPS(SKL_PRIHD) PUSH(skl_objVyshd_sel) NOREVISION() TIPTEXT(100,102,115,142,177,400,888)
      TYPE(GET)      NAME(pvpheadW->cVarSym)    FPOS( 18,3.2) FLEN(15) FCAPTION( Variabilní symbol) CPOS( 19,2.2)   GROUPS(SKL_PRIHD)                                     TIPTEXT(100,102,103,104,115,142,177,400,888)                                 
      TYPE(GET)      NAME(pvpheadW->nCisFak)    FPOS( 35,3.2) FLEN(10) FCAPTION( Faktura)           CPOS( 35,2.2)   GROUPS(SKL_PRIHD)                                     TIPTEXT(100,102,103,104,115,177,400,888)
      TYPE(GET)      NAME(pvpheadW->nCisloDL)   FPOS( 47,3.2) FLEN(10) FCAPTION( Dodací list)       CPOS( 47,2.2)   GROUPS(SKL_PRIHD)                                     TIPTEXT(100,102,103,104,115,177,142,400,888)                                  

      TYPE(GET)      NAME(pvpheadW->ccisZakaz)  FPOS( 1,3.2) FLEN(30) FCAPTION( èísloVýr_zakázky)   CPOS(  2,2.2)   GROUPS(SKL_PRI115) PUSH(skl_vyrZak_sel)  NOREVISION() TIPTEXT(100,102,103,104,142,177,400)

      TYPE(TEXT)     CAPTION( Cena na dokladu)  CPOS( 68,2.2) CLEN(13)                                              GROUPS(SKL_PRIHD)  
      TYPE(Text)     CAPTION(Nutné VN)          CPOS( 81,2.2) CLEN(11) PP(1)                                        GROUPS(SKL_PRIHD) 
      TYPE(Text)     CAPTION(Suma položek)      CPOS( 94,2.2) CLEN(11) PP(1)                                        GROUPS(SKL_PRIHD)
      TYPE(Text)     CAPTION(Kontrolní rozdíl)  CPOS(106,2.2) CLEN(14) PP(1)                                        GROUPS(SKL_PRIHD)

      TYPE(Text)     NAME(M->pvpHeadW_zahrMena) CPOS( 63,3.2) CLEN( 5) FONT(5)                                      GROUPS(SKL_PRIHD) 
      TYPE(GET)      NAME(pvpheadW->nCenDokZM)  FPOS( 68,3.2) FLEN(11)                                              GROUPS(SKL_PRIHD)                                    TIPTEXT(102)                          
      TYPE(GET)      NAME(pvpheadW->nNutneVNZM) FPOS( 81,3.2) FLEN(11)                                              GROUPS(SKL_PRIHD)                                    TIPTEXT(100,102,103,104,115,142,177,400)
      TYPE(Text)     NAME(M->nCelkDoklZM)       CPOS( 94,3.2) CLEN(11) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_PRIHD,SETFONT,8.Arial Bold,GRA_CLR_BLUE)
      TYPE(Text)     NAME(M->nRozPrijZM)        CPOS(106,3.2) CLEN(11) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_PRIHD,SETFONT,8.Arial Bold,GRA_CLR_RED)

      TYPE(Text)     CAPTION(CZK)               CPOS( 63,4.2) CLEN( 4) PP(1) FONT(5)                                GROUPS(SKL_PRIHD)
      TYPE(GET)      NAME(pvpheadW->nCenaDokl)  FPOS( 68,4.2) FLEN(11)                                              GROUPS(SKL_PRIHD)                            TIPTEXT(100,102,103,104,110,111,115,116,117,120,130,142,400)
      TYPE(GET)      NAME(pvpheadW->nNutneVN)   FPOS( 81,4.2) FLEN(11)                                              GROUPS(SKL_PRIHD)                            TIPTEXT(100,102,103,104,110,111,115,116,117,120,130,142,400)
      TYPE(Text)     NAME(M->nCelkDokl)         CPOS( 94,4.2) CLEN(11) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_PRIHD,SETFONT,8.Arial Bold,GRA_CLR_BLUE)
      TYPE(Text)     NAME(pvpheadW->nRozPrij)   CPOS(106,4.2) CLEN(11) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_PRIHD,SETFONT,8.Arial Bold,GRA_CLR_RED)
  
      TYPE(Text)     CAPTION(hd_pøíjemka)       CPOS(  1,4.2) CLEN(20) PP(1) FONT(5)                                GROUPS(SKL_PRIHD)
    TYPE(End)

* SKL_VYD
* SKL_PRE
    TYPE(STATIC) STYPE(12) FPOS(.1,1.7) SIZE(120,7) CAPTION(SKL_VYDHD) CTYPE(2) RESIZE(yx)                                        GROUPS(SKL_VYDHD)

      TYPE(GET)  NAME(pvpheadW->nCisFirmy)              FPOS( 12, .7) FLEN( 8) FCAPTION( Odbìratel) CPOS( 2, .7) CLEN( 10)        GROUPS(SKL_VYDHD) PUSH(SKL_FIRMY_SEL) NOREVISION() TIPTEXT(203,204,205,244,263,274)
      TYPE(GET)  NAME(pvpheadW->cNazFirmy)              FPOS( 22, .7) FLEN(40)                                                    GROUPS(SKL_VYDHD)                                  TIPTEXT(203,204,205,244,263,274)

      TYPE(GET)  NAME(pvpheadW->ccislOBint)             FPOS(  1, 3.2) FLEN(15) FCAPTION( Objednávka)        CPOS(  2,2.2)        GROUPS(SKL_VYDHD) PUSH(skl_objhead_sel)           TIPTEXT(203,204,205,244,263,305,888)                                   
      TYPE(GET)  NAME(pvpheadW->nCisloDL)               FPOS( 18, 3.2) FLEN(10) FCAPTION( Dodací list)       CPOS( 18,2.2)        GROUPS(SKL_VYDHD)                                 TIPTEXT(203,204,205,244,263,274,305,888)
      TYPE(GET)  NAME(pvpheadW->nCisFak)                FPOS( 30, 3.2) FLEN(10) FCAPTION( Faktura)           CPOS( 30,2.2)        GROUPS(SKL_VYDHD)                                 TIPTEXT(203,204,205,244,274,305,888)                             

      TYPE(GET)  NAME(pvpheadW->ccisZakaz)              FPOS( 1,3.2) FLEN(30) FCAPTION( èísloVýr_zakázky)    CPOS(  2,2.2)        GROUPS(SKL_VYD215) PUSH(skl_vyrZak_sel) NOREVISION() TIPTEXT(203,204,205,244,263,274,305)


      TYPE(ComboBox) NAME(pvpHeadW->czahrMena)  FPOS( 68, .7) FLEN(21)       PP(2) GROUPS(SKL_VYDHD) VALUES(C_MENY->CZKRATMENY:CNAZMENY) POST(postValidate) NOREVISION()             TIPTEXT(203,204,205,244,263,274,293,305) 
      TYPE(GET)      NAME(pvpHeadW->nkurZAHmen) FPOS( 96, .7) FLEN(10) FCAPTION(Kurz)    CPOS(89, .7) CLEN(7) CTYPE(2) PP(2) GROUPS(SKL_VYDHD) NOREVISION()                          TIPTEXT(203,204,205,244,263,274,293,305) 
      TYPE(GET)      NAME(pvpHeadW->nmnozPrep)  FPOS(108, .7) FLEN(7)                                         CTYPE(2) PP(2) GROUPS(SKL_VYDHD) NOREVISION()                          TIPTEXT(203,204,205,244,263,274,293,305)

*      TYPE(GET)  NAME(pvpheadW->nProcSlev)   FPOS( 42,3.2) FLEN(  8) FCAPTION( Zákl.sleva) CPOS(42,2.2)                            GROUPS(SKL_VYDHD)
*      TYPE(Text) CAPTION( %)                 CPOS( 51,3.2) CLEN(  3)                                                               GROUPS(SKL_VYDHD)

      TYPE(TEXT) CAPTION( Cena na dokladu)    CPOS( 68, 2.2) CLEN( 13)                                                              GROUPS(SKL_VYDHD)
      TYPE(GET)  NAME(pvpheadW->nCenaDokl)    FPOS( 68, 3.2) FLEN( 11)                                                              GROUPS(SKL_VYDHD)                               TIPTEXT(203,204,205,244,253,263,274,293,299,305)

*      TYPE(Text) NAME(M->nCelkDOKL)    CPOS( 68, 3.2) CLEN( 11)  BGND(13)                                                    GROUPS(SKL_VYDHD)
*      TYPE(Text) CAPTION(PC bez danì)         CPOS( 81, 2.2) CLEN( 13)                                                              GROUPS(SKL_VYDHD)
*      TYPE(Text) NAME(M->nCelkPCB)            CPOS( 81, 3.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1)                                     GROUPS(SKL_VYDHD)
*      TYPE(Text) CAPTION(PC s daní)           CPOS( 94, 2.2) CLEN( 13)                                                              GROUPS(SKL_VYDHD)
*      TYPE(Text) NAME(M->nCelkPCS)            CPOS( 94, 3.2) CLEN( 11) CTYPE(2) BGND( 13) PP(1)                                     GROUPS(SKL_VYDHD)

       TYPE(Text) CAPTION(hd_výdejka)  CPOS( 1,4.2) CLEN( 20) PP(1) FONT(5)                                                          GROUPS(SKL_VYDHD)
    TYPE(End)
  TYPE(End)

* it
* it pøíjem ALL
  TYPE(TabPage) FPOS(.1,7) SIZE(119.8,10) CAPTION(Položky) OFFSET(10,80) SUB(A) RESIZE(yx) TABHEIGHT(0) TTYPE(3) PRE(tabSelect)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,10) CAPTION(SKL_PRI) CTYPE(2) RESIZE(yx)                              GROUPS(SKL_PRI)

      TYPE(Text)  CAPTION(èísloObj_vystavené)  CPOS( 1, .1) CLEN(15) CTYPE(2)                                           GROUPS(SKL_PRI)              TIPTEXT(100,102,103,104,111,120,130,142)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS(22, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI) 
      TYPE(Text)  CAPTION(katalogÈíslo)        CPOS(73, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI) 

      TYPE(Get)   NAME(pvpitemWW->ccisObj)     FPOS( 1,1.1) FLEN(15) PP(2) PUSH(skl_objVysit_sel)                       GROUPS(SKL_PRI) NOREVISION() TIPTEXT(100,102,103,104,111,120,130,142)
      TYPE(Text)  NAME(M->objVysit_kDis)       CPOS( 1,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS(20,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                        GROUPS(SKL_PRI) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS(21,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS(39,1.1) CLEN(30) BGND(12)                                           GROUPS(SKL_PRI)
      TYPE(Get)   NAME(pvpitemWW->ckatCzbo)    FPOS(72,1.1) FLEN(15) PP(2)                                              GROUPS(SKL_PRI) NOREVISION()     

      TYPE(TEXT) CAPTION(množství)     CPOS( 20, 3.02)                                                                  GROUPS(SKL_PRI)
      TYPE(TEXT) CAPTION(v MJ)         CPOS( 35, 3.02) CLEN(7)                                                          GROUPS(SKL_PRI)
      TYPE(TEXT) CAPTION(cena/MJ)      CPOS( 50, 3.02)                                                                  GROUPS(SKL_PRI)
      TYPE(TEXT) CAPTION(celkemPøíjem) CPOS( 65, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI)  
      TYPE(TEXT) CAPTION(vedlejšíNákl) CPOS( 79, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI)  
      TYPE(TEXT) CAPTION(cenaCelkem)   CPOS( 93, 3.00)                                                                  GROUPS(SKL_PRI) 


      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(110, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_PRI)  
        TYPE(Text) CAPTION( Dokladové_jednotky)    CPOS( 1,  .5) CLEN(15)                                               GROUPS(SKL_PRI)  
        TYPE(Text) CAPTION( Skladové_jednotky )    CPOS( 1, 1.5) CLEN(15)                                               GROUPS(SKL_PRI)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_PRI) 
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_PRI) PUSH(SKL_c_prepmj_sel)   
        TYPE(GET)  NAME( pvpitemWW->ncenNADOzm)    FPOS( 49, .5) FLEN( 13)                                              GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( pvpitemWW->nrozPOHzm)     CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 92, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS(106, .5) CLEN(  5)                                              GROUPS(SKL_PRI,SETFONT,9.Cambria,GRA_CLR_RED)
*
        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PP(1)                                       GROUPS(SKL_PRI) PUSH(skl_vyrCis_modi) 
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( pvpitemWW->nRozdilPoh)    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 92, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS(106, 1.5) CLEN( 5)                                              GROUPS(SKL_PRI,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

      TYPE(GET)  NAME(pvpitemWW->cText)            FPOS(  2, 6.65) FLEN(112)                                            GROUPS(SKL_PRI)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_PRI) TIPTEXT(100,110,111,116,117,120,130)
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End)

      TYPE(Text) CAPTION(it_pøíjemka_All)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_PRI)
    TYPE(END)
* Tp  TYPE(END)


* it 115 pøíjem z výroby
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(PRI) SUB(SKL_PRI115) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,10) CAPTION(SKL_PRI115) CTYPE(2) RESIZE(yx)                            GROUPS(SKL_PRI115)

      TYPE(Text)  CAPTION(èísloVýr_zakázky)    CPOS(  1, .1) CLEN(15) CTYPE(2)                                           GROUPS(SKL_PRI115)
      TYPE(Text)  CAPTION(èísloVyr_položky)    CPOS( 32, .1) CLEN(15) CTYPE(2)                                           GROUPS(SKL_PRI115)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 52, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI115) 
      TYPE(Text)  CAPTION(katalogÈíslo)        CPOS(103, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI115) 

      TYPE(Get)   NAME(pvpitemWW->ccisZakaz)   FPOS(  1,1.1) FLEN(30) PP(2) PUSH(skl_vyrPol_sel)                         GROUPS(SKL_PRI115) NOREVISION() 
      TYPE(Get)   NAME(pvpitemWW->cvyrPol)     FPOS( 33,1.1) FLEN(15) PP(2) PUSH(skl_vyrPol_sel)                         GROUPS(SKL_PRI115) NOREVISION()
      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS( 50,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                        GROUPS(SKL_PRI115) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS( 49,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRI115,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS( 68,1.1) CLEN(31) BGND(12)                                           GROUPS(SKL_PRI115)
      TYPE(Get)   NAME(pvpitemWW->ckatCzbo)    FPOS(101,1.1) FLEN(15) PP(2)                                              GROUPS(SKL_PRI115) NOREVISION()     

      TYPE(TEXT) CAPTION(množství)     CPOS( 20, 3.02)                                                                  GROUPS(SKL_PRI115)
      TYPE(TEXT) CAPTION(v MJ)         CPOS( 35, 3.02) CLEN(7)                                                          GROUPS(SKL_PRI115)
      TYPE(TEXT) CAPTION(cena/MJ)      CPOS( 50, 3.02)                                                                  GROUPS(SKL_PRI115)
      TYPE(TEXT) CAPTION(celkemPøíjem) CPOS( 65, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI115)  
      TYPE(TEXT) CAPTION(vedlejšíNákl) CPOS( 79, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI115)  
      TYPE(TEXT) CAPTION(cenaCelkem)   CPOS( 93, 3.00)                                                                  GROUPS(SKL_PRI115) 


      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(110, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_PRI115)  
        TYPE(Text) CAPTION( Dokladové_jednotky)    CPOS( 1,  .5) CLEN(15)                                               GROUPS(SKL_PRI115)  
        TYPE(Text) CAPTION( Skladové_jednotky )    CPOS( 1, 1.5) CLEN(15)                                               GROUPS(SKL_PRI115)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_PRI115) 
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_PRI115) PUSH(SKL_c_prepmj_sel)   
        TYPE(GET)  NAME( pvpitemWW->ncenNADOzm)    FPOS( 49, .5) FLEN( 13)                                              GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( pvpitemWW->nrozPOHzm)     CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI115,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 92, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI115)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS(106, .5) CLEN(  5)                                              GROUPS(SKL_PRI115,SETFONT,9.Cambria,GRA_CLR_RED)
*
        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PP(1)                                       GROUPS(SKL_PRI115) PUSH(skl_vyrCis_modi) 
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( pvpitemWW->nRozdilPoh)    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI115,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 92, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI115)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS(106, 1.5) CLEN( 5)                                              GROUPS(SKL_PRI115,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

      TYPE(GET)  NAME(pvpitemWW->cText)            FPOS(  2, 6.65) FLEN(112)                                            GROUPS(SKL_PRI115)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_PRI115) 
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_PRI115) 
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_PRI115) 
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_PRI115) 
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_PRI115) 
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_PRI115) 
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End)

      TYPE(Text) CAPTION(it_pøíjemka_115)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_PRI115)
    TYPE(END)
* Tp  TYPE(END)


* it 177 Oprava stavu cenZboz jen pvpItem + likvidace
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(PRI) SUB(SKL_PRI177) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,10) CAPTION(SKL_PRI177) CTYPE(2) RESIZE(yx)                            GROUPS(SKL_PRI177)

      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS(  4, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI177) 
      TYPE(Text)  CAPTION(katalogÈíslo)        CPOS( 58, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_PRI177) 

      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS(  1,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                        GROUPS(SKL_PRI177) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS(  4,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRI177,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS( 21,1.1) CLEN(31) BGND(12)                                           GROUPS(SKL_PRI177)
      TYPE(Get)   NAME(pvpitemWW->ckatCzbo)    FPOS( 56,1.1) FLEN(15) PP(2)                                              GROUPS(SKL_PRI177) NOREVISION()     

      TYPE(TEXT) CAPTION(množství)     CPOS( 20, 3.02)                                                                  GROUPS(SKL_PRI177)
      TYPE(TEXT) CAPTION(v MJ)         CPOS( 35, 3.02) CLEN(7)                                                          GROUPS(SKL_PRI177)
      TYPE(TEXT) CAPTION(cena/MJ)      CPOS( 50, 3.02)                                                                  GROUPS(SKL_PRI177)
      TYPE(TEXT) CAPTION(celkemPøíjem) CPOS( 65, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI177)  
      TYPE(TEXT) CAPTION(vedlejšíNákl) CPOS( 79, 3.00) CLEN(10)                                                         GROUPS(SKL_PRI177)  
      TYPE(TEXT) CAPTION(cenaCelkem)   CPOS( 93, 3.00)                                                                  GROUPS(SKL_PRI177) 


      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(110, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_PRI177)  
        TYPE(Text) CAPTION( Dokladové_jednotky)    CPOS( 1,  .5) CLEN(15)                                               GROUPS(SKL_PRI177)  
        TYPE(Text) CAPTION( Skladové_jednotky )    CPOS( 1, 1.5) CLEN(15)                                               GROUPS(SKL_PRI177)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_PRI177)                        TIPTEXT(177)
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_PRI177) PUSH(SKL_c_prepmj_sel) TIPTEXT(177)  
        TYPE(GET)  NAME( pvpitemWW->ncenNADOzm)    FPOS( 49, .5) FLEN( 13)                                              GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( pvpitemWW->nrozPOHzm)     CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI177,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 92, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRI177)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS(106, .5) CLEN(  5)                                              GROUPS(SKL_PRI177,SETFONT,9.Cambria,GRA_CLR_RED)
*
        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PP(1)                                       GROUPS(SKL_PRI177) PUSH(skl_vyrCis_modi)  TIPTEXT(177)
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( pvpitemWW->nRozdilPoh)    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI177,SETFONT,8.Cambria,GRA_CLR_BLACK)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 92, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRI177)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS(106, 1.5) CLEN( 5)                                              GROUPS(SKL_PRI177,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

      TYPE(GET)  NAME(pvpitemWW->cText)            FPOS(  2, 6.65) FLEN(112)                                            GROUPS(SKL_PRI177)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_PRI177) 
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_PRI177) 
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_PRI177) 
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_PRI177) 
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_PRI177) 
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_PRI177) 
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End)

      TYPE(Text) CAPTION(it_pøíjemka_177)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_PRI177)
    TYPE(END)
* Tp  TYPE(END)


* it 203 253 255 263 293 výdej
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(VYD) SUB(SKL_VYD) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,12) CAPTION(SKL_VYD) CTYPE(2) RESIZE(yx)                              GROUPS(SKL_VYD)  

      TYPE(Text)  CAPTION(èísloObj_pøijaté)    CPOS(10, .1) CLEN(15) CTYPE(1)                                           GROUPS(SKL_VYD)             TIPTEXT(203,204,205,244,263,293)
      TYPE(Text)  CAPTION(stornoDokladu)       CPOS(31, .1) CLEN(15) CTYPE(2)                                           GROUPS(SKL_VYD)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS(52, .1) CLEN(11) CTYPE(2)                                           GROUPS(SKL_VYD) 

      TYPE(Get)   NAME(pvpitemWW->ccislOBint)  FPOS( 2,1.1) FLEN(28) PP(2) PUSH(skl_objitem_sel)                        GROUPS(SKL_VYD) NOREVISION() TIPTEXT(203,204,205,244,263,293)
      TYPE(Text)  NAME(M->objitem_kDis)        CPOS( 2,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_VYD,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Get)   NAME(pvpitemWW->nDoklad_o)   FPOS(34,1.1) FLEN( 12)                                                   GROUPS(SKL_VYD) NOREVISION() PUSH(SKL_pvpitem_SEL)
*      TYPE(Text)  NAME(M->pvpitem_kDis)        CPOS(21,2.1) CLEN(13) CTYPE(1)                                          GROUPS(SKL_VYD,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS(50,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                        GROUPS(SKL_VYD) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS(49,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_VYD,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS(68,1.1) CLEN(31) BGND(12)                                           GROUPS(SKL_VYD) 


      TYPE(TEXT) CAPTION(množství)    CPOS( 20, 3.02)                                                                   GROUPS(SKL_VYD)
      TYPE(TEXT) CAPTION(v MJ)        CPOS( 35, 3.02) CLEN(7)                                                           GROUPS(SKL_VYD)  
      TYPE(TEXT) CAPTION(cena/MJ)     CPOS( 50, 3.02)                                                                   GROUPS(SKL_VYD)
      TYPE(TEXT) CAPTION(celkemVýdej) CPOS( 65, 3.00) CLEN(10)                                                          GROUPS(SKL_VYD)  
      TYPE(TEXT) CAPTION(cenaCelkem)  CPOS( 79, 3.02)                                                                   GROUPS(SKL_VYD)

      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(110, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_VYD)
        TYPE(Text) CAPTION( Dokladové_jednotky)  CPOS( 1,  .5)                                                          GROUPS(SKL_VYD) 
        TYPE(Text) CAPTION( Skladové_jednotky)   CPOS( 1, 1.5)                                                          GROUPS(SKL_VYD)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_VYD) 
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->ncenNADOzm)    CPOS( 49, .5) CLEN( 14) CTYPE(2) BGND(13)                            GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS( 92, .5) CLEN( 5)                                               GROUPS(SKL_VYD,SETFONT,9.Cambria,GRA_CLR_RED)

        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PUSH(skl_vyrCis_modi)                       GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS( 92, 1.5) CLEN( 5)                                              GROUPS(SKL_VYD,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_VYD)
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_VYD)
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_VYD)
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_VYD)
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_VYD)
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_VYD)
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End)

      TYPE(Text) CAPTION(it_výdejka_All)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_VYD)
    TYPE(END)
* Tp  TYPE(END)


* it 215 výdej z výroby
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(VYD) SUB(SKL_VYD215) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,12) CAPTION(SKL_VYD) CTYPE(2) RESIZE(yx)                              GROUPS(SKL_VYD215)  

      TYPE(Text)  CAPTION(èísloVýr_zakázky)    CPOS(  1, .1) CLEN(15) CTYPE(2)                                          GROUPS(SKL_VYD215)
      TYPE(Text)  CAPTION(èísloVyr_položky)    CPOS( 32, .1) CLEN(15) CTYPE(2)                                          GROUPS(SKL_VYD215)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 52, .1) CLEN(11) CTYPE(2)                                          GROUPS(SKL_VYD215) 

      TYPE(Get)   NAME(pvpitemWW->ccisZakaz)   FPOS(  1,1.1) FLEN(30) PP(2) PUSH(skl_vyrPol_sel)                        GROUPS(SKL_VYD215) NOREVISION() 
      TYPE(Get)   NAME(pvpitemWW->cvyrPol)     FPOS( 33,1.1) FLEN(15) PP(2) PUSH(skl_vyrPol_sel)                        GROUPS(SKL_VYD215) NOREVISION()
      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS( 50,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                       GROUPS(SKL_VYD215) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS( 49,2.1) CLEN(13) CTYPE(1)                                          GROUPS(SKL_VYD215,SETFONT,8.Cambria,GRA_CLR_RED) 

      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS(68,1.1) CLEN(31) BGND(12)                                           GROUPS(SKL_VYD215) 


      TYPE(TEXT) CAPTION(množství)    CPOS( 20, 3.02)                                                                   GROUPS(SKL_VYD215)
      TYPE(TEXT) CAPTION(v MJ)        CPOS( 35, 3.02) CLEN(7)                                                           GROUPS(SKL_VYD215)  
      TYPE(TEXT) CAPTION(cena/MJ)     CPOS( 50, 3.02)                                                                   GROUPS(SKL_VYD215)
      TYPE(TEXT) CAPTION(celkemVýdej) CPOS( 65, 3.00) CLEN(10)                                                          GROUPS(SKL_VYD215)  
      TYPE(TEXT) CAPTION(cenaCelkem)  CPOS( 79, 3.02)                                                                   GROUPS(SKL_VYD215)

      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(110, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_VYD215)
        TYPE(Text) CAPTION( Dokladové_jednotky)  CPOS( 1,  .5)                                                          GROUPS(SKL_VYD215) 
        TYPE(Text) CAPTION( Skladové_jednotky)   CPOS( 1, 1.5)                                                          GROUPS(SKL_VYD215)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_VYD215) 
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->ncenNADOzm)    CPOS( 49, .5) CLEN( 14) CTYPE(2) BGND(13)                            GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD215)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS( 92, .5) CLEN( 5)                                               GROUPS(SKL_VYD215,SETFONT,9.Cambria,GRA_CLR_RED)

        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PUSH(skl_vyrCis_modi)                       GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD215)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS( 92, 1.5) CLEN( 5)                                              GROUPS(SKL_VYD215,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_VYD215)
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_VYD215)
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_VYD215)
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_VYD215)
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_VYD215)
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_VYD215)
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End)

      TYPE(Text) CAPTION(it_výdejka_215)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_VYD215)
    TYPE(END)
* Tp  TYPE(END)


* it 400 pøecenìní
*    TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(VYD) SUB(SKL_CEN) TABHEIGHT(.8) TTYPE(3)

      TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,12) CAPTION(SKL_CEN400) CTYPE(2) RESIZE(yx)                         GROUPS(SKL_CEN400)
     
        TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 4, .1) CLEN(11) CTYPE(2)                                          GROUPS(SKL_CEN400) 
        TYPE(Get)   NAME(pvpitemWW->CSKLPOL)    FPOS( 1,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                       GROUPS(SKL_CEN400) NOREVISION()
        TYPE(Text)  NAME(M->cenzboz_kDis)       CPOS( 2,2.1) CLEN(13) CTYPE(1)                                          GROUPS(SKL_CEN400,SETFONT,8.Cambria,GRA_CLR_RED) 
        TYPE(Text)  NAME(pvpitemWW->cnazZbo)    CPOS(18,1.1) CLEN(30) BGND(12)                                          GROUPS(SKL_CEN400) 

        TYPE(Text) CAPTION( Cena položky) CPOS(  2, 3.02)                                                               GROUPS(SKL_CEN400)
        TYPE(TEXT) CAPTION(množství)      CPOS( 20, 3.02)                                                               GROUPS(SKL_CEN400)
        TYPE(TEXT) CAPTION(v MJ)          CPOS( 35, 3.02) CLEN(7)                                                       GROUPS(SKL_CEN400)
        TYPE(TEXT) CAPTION(cena/MJ)       CPOS( 45, 3.02)                                                               GROUPS(SKL_CEN400)
        TYPE(TEXT) CAPTION(cenaCelkem)    CPOS( 63, 3.02)                                                               GROUPS(SKL_CEN400)

        TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(107, 4) CTYPE(2) RESIZE(yx)                                            GROUPS(SKL_CEN400)  
          TYPE(Text) CAPTION( - pùvodní)       CPOS( 5,  .7) FONT(5)                                                    GROUPS(SKL_CEN400)
          TYPE(Text) CAPTION( - nová)          CPOS( 5, 1.7) FONT(5) CLEN(8)                                            GROUPS(SKL_CEN400)
          TYPE(Text) CAPTION( - rozdíl)        CPOS( 5, 2.9) FONT(5)                                                    GROUPS(SKL_CEN400)

          TYPE(GET)  NAME(pvpItemWW->nmnozPRdod)  FPOS( 19,  .7) FLEN( 13)  PUSH(skl_vyrCis_modi)                       GROUPS(SKL_CEN400)
          TYPE(TEXT) NAME(pvpItemWW->cmjDokl1)    CPOS( 34,  .7) CLEN(  5)  CTYPE(2) BGND(12)                           GROUPS(SKL_CEN400)
          TYPE(TEXT) NAME(pvpItemWW->ncelkSlev)   CPOS( 44,  .7) CLEN( 13)  CTYPE(2) BGND(12)                           GROUPS(SKL_CEN400)
          TYPE(TEXT) NAME(M->npuv_cenaCzbo)       CPOS( 62,  .7) CLEN( 13)  CTYPE(2) BGND(12)                           GROUPS(SKL_CEN400)

          TYPE(GET)  NAME( pvpitemWW->nCenNapDod) FPOS( 44, 1.7) FLEN( 12) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_CEN400)
          TYPE(Text) NAME( pvpitemWW->nCenaCZBO)  CPOS( 62, 1.7) CLEN( 13) CTYPE(2) BGND( 13) PP(1)                     GROUPS(SKL_CEN400)

          TYPE(Text) NAME(M->nCenaSROZ)           CPOS( 44, 2.7) CLEN( 13) CTYPE(2) BGND( 12) PP(1)                     GROUPS(SKL_CEN400,SETFONT,9.Cambria,GRA_CLR_RED)
          TYPE(Text) NAME( pvpitemWW->nCenaCelk)  CPOS( 62, 2.7) CLEN( 13) CTYPE(2) BGND( 12) PP(1)                     GROUPS(SKL_CEN400,SETFONT,9.Cambria,GRA_CLR_RED)

          TYPE(Text) NAME( pvpitemWW->nMnozDokl1) CPOS( 19, .5) CLEN(0)                                                 GROUPS(SKL_CEN400) 
       TYPE(End)

* ns
       TYPE(GET) NAME( pvpitemWW->cNazPol1)      FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_CEN400)
       TYPE(GET) NAME( pvpitemWW->cNazPol2)      FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_CEN400)
       TYPE(GET) NAME( pvpitemWW->cNazPol3)      FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_CEN400)
       TYPE(GET) NAME( pvpitemWW->cNazPol4)      FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_CEN400)
       TYPE(GET) NAME( pvpitemWW->cNazPol5)      FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_CEN400)
       TYPE(GET) NAME( pvpitemWW->cNazPol6)      FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_CEN400)
       TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)                                                         GROUPS(SKL_CEN400)
       TYPE(End)

       TYPE(Text) CAPTION(it_400)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_CEN400)
     TYPE(END)
* Tp   TYPE(End)




* it 205 výdej do DIMu
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(VYD) SUB(SKL_VYD205) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,12) CAPTION(SKL_VYD205) CTYPE(2) RESIZE(yx)                           GROUPS(SKL_VYD205)

      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS( 4, .1) CLEN(11) CTYPE(1)                                           GROUPS(SKL_VYD205)
      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS( 1,1.1) FLEN(15) PP(2)                                              GROUPS(SKL_VYD205) NOREVISION() PUSH(skl_cenZboz_sel) 
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS( 2,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_VYD205,SETFONT,8.Cambria,GRA_CLR_RED) 
      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS(17,1.1) CLEN(30) BGND(12)                                           GROUPS(SKL_VYD205)

      TYPE(TEXT) CAPTION(množství)    CPOS( 20, 3.02)                                                                   GROUPS(SKL_VYD205)
      TYPE(TEXT) CAPTION(v MJ)        CPOS( 35, 3.02) CLEN(7)                                                           GROUPS(SKL_VYD205)
      TYPE(TEXT) CAPTION(cena/MJ)     CPOS( 50, 3.02)                                                                   GROUPS(SKL_VYD205)
      TYPE(TEXT) CAPTION(celkemVýdej) CPOS( 65, 3.00) CLEN(10)                                                          GROUPS(SKL_VYD205)  
      TYPE(TEXT) CAPTION(cenaCelkem)  CPOS( 79, 3.02)                                                                   GROUPS(SKL_VYD205)

      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(107, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_VYD205)
        TYPE(Text) CAPTION( Dokl_jednot) CPOS( 1,  .5)                                                                  GROUPS(SKL_VYD205)
        TYPE(Text) CAPTION( Skl_jednot ) CPOS( 1, 1.5)                                                                  GROUPS(SKL_VYD205)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_VYD205)
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->ncenNADOzm)    CPOS( 49, .5) CLEN( 14) CTYPE(2) BGND(13)                            GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 78, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_VYD205)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS( 92, .5) CLEN( 5)                                               GROUPS(SKL_VYD205,SETFONT,9.Cambria,GRA_CLR_RED)

        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PUSH(skl_vyrCis_modi)                       GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 13) BGND(13) CTYPE(2)                           GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 78, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_VYD205)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS( 92, 1.5) CLEN( 5)                                              GROUPS(SKL_VYD205,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

* msDim
      TYPE(GET)  NAME(pvpitemWW->cKlicSkMis)   FPOS( 60,1.1) FLEN( 9) FCAPTION(SKUP_místo) CPOS(50,1.1)                  GROUPS(SKL_VYD205) NOREVISION()
      TYPE(Text) NAME(C_SkuMis->cNazSkMis)     CPOS( 60, .1) CLEN(20) BGND(13)                                           GROUPS(SKL_VYD205)
      TYPE(GET)  NAME(pvpitemWW->cKlicOdMis)   FPOS( 81,1.1) FLEN( 9) FCAPTION(ODP__místo) CLEN(10) CPOS(71,1.1)         GROUPS(SKL_VYD205) NOREVISION()
      TYPE(Text) NAME(C_OdpMis->cNazOdpMis)    CPOS( 81, .1) CLEN(20) BGND(13)                                           GROUPS(SKL_VYD205)
      TYPE(GET)  NAME(pvpitemWW->nInvCisDim)   FPOS(103,1.1) FLEN(11) FCAPTION(INV_èíslo) CLEN( 8) CPOS(95,1.1)          GROUPS(SKL_VYD205) NOREVISION() PUSH(skl_msDIm_pk_sel)
*      TYPE(GET)  NAME(pvpitemWW->nDokPriDim)   FPOS(103,2.1) FLEN(11) FCAPTION(PØÍJ_dokl) CLEN( 8) CPOS(95,2.1)          GROUPS(SKL_VYD205) NOREVISION() PUSH(skl_prijDIM)

* ns
      TYPE(GET) NAME( pvpitemWW->cNazPol1)       FPOS( 32, 8.6) FLEN( 12) FCAPTION(VýrStøedisko) CPOS( 32,7.6) CLEN(10) GROUPS(SKL_VYD205)
      TYPE(GET) NAME( pvpitemWW->cNazPol2)       FPOS( 46, 8.6) FLEN( 12) FCAPTION(Výkon)        CPOS( 46,7.6) CLEN( 6) GROUPS(SKL_VYD205)
      TYPE(GET) NAME( pvpitemWW->cNazPol3)       FPOS( 60, 8.6) FLEN( 12) FCAPTION(Zakázka)      CPOS( 60,7.6) CLEN( 7) GROUPS(SKL_VYD205)
      TYPE(GET) NAME( pvpitemWW->cNazPol4)       FPOS( 74, 8.6) FLEN( 12) FCAPTION(VýrMísto)     CPOS( 74,7.6) CLEN( 7) GROUPS(SKL_VYD205)
      TYPE(GET) NAME( pvpitemWW->cNazPol5)       FPOS( 88, 8.6) FLEN( 12) FCAPTION(Stroj)        CPOS( 88,7.6) CLEN( 5) GROUPS(SKL_VYD205)
      TYPE(GET) NAME( pvpitemWW->cNazPol6)       FPOS(102, 8.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,7.6) CLEN(10) GROUPS(SKL_VYD205)
      TYPE(STATIC) FPOS(0.4,8) SIZE(119,.15) STYPE(8) CTYPE(2)
      TYPE(End) 

      TYPE(Text) CAPTION(it_205)  CPOS( 1,8.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_VYD205)
    TYPE(END)
* Tp  TYPE(End)


* it 305 pøevod
*  TYPE(TabPage) FPOS(0.4,2) SIZE(119,13) CAPTION(Položky) OFFSET(10,80) RESIZE(yx) GROUPS(VYD) SUB(SKL_PRE) TABHEIGHT(.8) TTYPE(3)

    TYPE(STATIC) STYPE(13) FPOS(.1,.1) SIZE(119.8,12) CAPTION(SKL_PRE305) CTYPE(2) RESIZE(yx)                           GROUPS(SKL_PRE305)

      TYPE(Text)  CAPTION(èísloObj_pøijaté)    CPOS( 1, .1) CLEN(15) CTYPE(1)                                           GROUPS(SKL_PRE305)
      TYPE(Text)  CAPTION(èísloSklPoložky)     CPOS(22, .1) CLEN(11) CTYPE(1)                                           GROUPS(SKL_PRE305) 

      TYPE(Get)   NAME(pvpitemWW->ccislOBint)  FPOS( 1,1.1) FLEN(15) PP(2) PUSH(skl_objItem_sel)                        GROUPS(SKL_PRE305) NOREVISION()
      TYPE(Text)  NAME(M->objitem_kDis)        CPOS( 1,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRE305,SETFONT,8.Cambria,GRA_CLR_RED)    

      TYPE(Get)   NAME(pvpitemWW->CSKLPOL)     FPOS(19,1.1) FLEN(15) PP(2) PUSH(skl_cenZboz_sel)                        GROUPS(SKL_PRE305) NOREVISION()
      TYPE(Text)  NAME(M->cenzboz_kDis)        CPOS(20,2.1) CLEN(13) CTYPE(1)                                           GROUPS(SKL_PRE305,SETFONT,8.Cambria,GRA_CLR_RED) 
      TYPE(Text)  NAME(pvpitemWW->cnazZbo)     CPOS(36,1.1) CLEN(30) BGND(12)                                           GROUPS(SKL_PRE305)    

      TYPE(TEXT) CAPTION(množství)   CPOS( 20,3.02)                                                                     GROUPS(SKL_PRE305)
      TYPE(TEXT) CAPTION(MJ_dok)     CPOS( 35,3.02) CLEN(7)                                                             GROUPS(SKL_PRE305)
      TYPE(TEXT) CAPTION(cena/MJ)    CPOS( 50,3.02)                                                                     GROUPS(SKL_PRE305)    
      TYPE(TEXT) CAPTION(cenaCelkem) CPOS( 65,3.02)                                                                     GROUPS(SKL_PRE305)

      TYPE(STATIC) STYPE(11) FPOS( 1,3.5) SIZE(107, 3) CTYPE(2) RESIZE(yx)                                              GROUPS(SKL_PRE305)
        TYPE(Text) CAPTION( Dokladové_jednotky)   CPOS( 1, .5)                                                          GROUPS(SKL_PRE305)
        TYPE(Text) CAPTION( Skladové_jednotky)    CPOS( 1,1.5)                                                          GROUPS(SKL_PRE305)

        TYPE(GET)  NAME( pvpitemWW->nMnozDokl1)    FPOS( 19, .5) FLEN( 13)                                              GROUPS(SKL_PRE305) 
        TYPE(GET)  NAME( pvpitemWW->cMjDokl1)      FPOS( 34, .5) FLEN( 10)                                              GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->ncenNADOzm)    CPOS( 49, .5) CLEN( 14) CTYPE(2) BGND(13)                            GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAKzm)    CPOS( 64, .5) CLEN(  0) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->ncenCELKzm)    CPOS( 64, .5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                      GROUPS(SKL_PRE305)
        TYPE(Text) NAME(M->pvpitemWW_zahrMena)     CPOS( 78, .5) CLEN( 5)                                               GROUPS(SKL_PRE305,SETFONT,9.Cambria,GRA_CLR_RED)

        TYPE(GET)  NAME( pvpitemWW->nMnozPrDod)    FPOS( 19, 1.5) FLEN( 13) PUSH(skl_vyrCis_modi)                       GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( M->cenZboz_czkratJedn)    CPOS( 34, 1.5) CLEN(  8) BGND(13) CTYPE(1)                           GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->nCenNapDod)    CPOS( 49, 1.5) CLEN( 14) BGND(13) CTYPE(2)                           GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->ncenCZAK)      CPOS( 64, 1.5) CLEN(  0) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( pvpitemWW->nCenaCelk )    CPOS( 64, 1.5) CLEN( 13) CTYPE(2) BGND(13) PP(1)                     GROUPS(SKL_PRE305)
        TYPE(TEXT) NAME( M->cenZboz_czkratMeny)    CPOS( 78, 1.5) CLEN( 5)                                              GROUPS(SKL_PRE305,SETFONT,9.Cambria,GRA_CLR_RED) 
      TYPE(END)

* pøevod KAM
      TYPE(Text) CAPTION(pøevod->)           CPOS( 66,1.1) CLEN(9)  FONT(5)                                             GROUPS(SKL_PRE305)
      TYPE(Text) CAPTION(na_Sklad)           CPOS( 75, .1)                                                              GROUPS(SKL_PRE305) 
      TYPE(GET)  NAME(pvpitemWW->cSkladKAM)  FPOS( 75,1.1) FLEN(10) PP(2)                                               GROUPS(SKL_PRE305) NOREVISION() PUSH(skl_sklad_pk_sel)

      TYPE(Text) CAPTION(na_SklPoložku)      CPOS( 87, .1)                                                              GROUPS(SKL_PRE305)
      TYPE(GET)  NAME(pvpitemWW->cSklPolKAM) FPOS( 87,1.1) FLEN(15) PP(2)                                               GROUPS(SKL_PRE305) NOREVISION() PUSH(skl_cenZboz_pk_sel)

      TYPE(Text) FCAPTION(na_ÚèSkup)         CPOS(104, .1) CLEN(14)                                                     GROUPS(SKL_PRE305)
      TYPE(GET)  NAME(pvpitemWW->nUcetSkKAM) FPOS(104,1.1) FLEN(12) PP(2)                                               GROUPS(SKL_PRE305) NOREVISION() PUSH(skl_c_uctSkp_sel)
      TYPE(Text) NAME(M->cenZboz_nucetSkup)  CPOS(103,2.1) CLEN(13) CTYPE(1)                                            GROUPS(SKL_PRE305,SETFONT,8.Cambria,GRA_CLR_RED)    

      TYPE(GET)  NAME(pvpitemWW->cText)      FPOS(  2, 6.5) FLEN(98)                                                    GROUPS(SKL_PRE305)

      TYPE(Text) CAPTION(it_305)  CPOS( 1,7.6) CLEN( 20) PP(1) FONT(5) GROUPS(SKL_PRE305)
    TYPE(END)
* Tp  TYPE(END)

* Tp položky, main tabPage
   TYPE(End)



***
* TYPE(TabPage) FPOS(.1,15.8) SIZE(119.8,1.2) CAPTION(výrÈísla)     OFFSET(1,87) SUB(B) RESIZE(ny) TABHEIGHT(.8) TTYPE(3)
* TYPE(GET) NAME( pvpitemWW->cNazPol6)      FPOS(102, 7.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,6.6) CLEN(10) 
* TYPE(End)

* TYPE(TabPage) FPOS(.1,15.8) SIZE(119.8,1.2) CAPTION(místaUložení) OFFSET(13,74) SUB(C) RESIZE(ny) TABHEIGHT(.8) TTYPE(3)
* TYPE(GET) NAME( pvpitemWW->cNazPol6)      FPOS(102, 7.6) FLEN( 12) FCAPTION(VýrOperace)   CPOS(102,6.6) CLEN(10)
* TYPE(End)


    TYPE(dBrowse) FPOS(.2,17.2) SIZE(118.9,10) FILE(PVPITEMww) INDEXORD(1);
                  FIELDS( M->pvpitem_isOk::2.6::2  , ;
                          nordItem:pol:5           , ;
                          csklPol:sklPoložka:14    , ;
                          cnazZbo:název zboží:30   , ;
                          nmnozPRdod:množ_Nadokl:12, ;
                          czkratJedn:mj            , ;
                          ncenNAPdod:cena_Zamj     , ;
                          nCenaCelk:cenaCelkem     , ;
                          nCenapZBO:cena_bezDph    , ;
                          nCenapDZBO:cena_sDph       ) ;
                  CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yx) POPUPMENU(yn) FOOTER(y)  ;
                  ITEMMARKED( ItemMarked) 

TYPE(END)

*
* neviditelné pomocné položky
TYPE(TEXT) NAME(pvpitemww->ccisSklad)   FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nintCount)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->ncislPOLob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->cfile_iv)    FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nrecs_iv)    FPOS(0,0) CLEN(0) 
*
** naplníme sID z vazebních souborù
* TYPE(TEXT) NAME(pvpitemww->nCENZBOZ)   FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nPVPTERM)    FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nOBJVYSIT)   FPOS(0,0) CLEN(0) 
TYPE(TEXT) NAME(pvpitemww->nOBJITEM)    FPOS(0,0) CLEN(0) 
*
TYPE(TEXT) NAME(pvpitemWW->nucetSkup)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemWW->cucetSkup)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemWW->ctypSKLcen)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(pvpitemww->_nrecOr)     FPOS(0,0) CLEN(0) 


