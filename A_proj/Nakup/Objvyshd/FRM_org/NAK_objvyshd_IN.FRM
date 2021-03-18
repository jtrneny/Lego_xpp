TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava objednávky vystavené ...) SIZE(110,29) ;
                                                                        FILE(OBJVYSHDw) POST(postValidate)


TYPE(ComboBox) NAME(OBJVYSHDw->cTYPPOHYBU)  FPOS(80, .2) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()

TYPE(Static) FPOS(1,1.5) SIZE(108,5) STYPE(9) RESIZE(y) CTYPE(2)

  TYPE(TEXT) CAPTION(1. IÈO)         CPOS( 1, .5)          FONT(5)
  TYPE(TEXT) NAME(M->system_nico)    CPOS(15, .5) CLEN(10) BGND(13) CTYPE(2)
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26, .5) CLEN( 5)
  TYPE(TEXT) NAME(M->system_cdic)    CPOS(31, .5) CLEN(15) BGND(13)
  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,1.5) 
  TYPE(TEXT) NAME(M->system_cpodnik) CPOS(15,1.5) CLEN(31) BGND(13)

  TYPE(TEXT) CAPTION(Odbìratel)      CPOS( 1,2.7)                    FONT(6)   
  TYPE(TEXT) NAME(OBJVYSHDw->NICO)   CPOS(15,2.7)  CLEN(10) BGND(14) FONT(5) 
  TYPE(TEXT) CAPTION(DIÈ)            CPOS(26,2.7)  CLEN( 5)          
  TYPE(TEXT) NAME(OBJVYSHDw->CDIC)   CPOS(31,2.7)  CLEN(15) BGND(14) FONT(5)
  TYPE(TEXT) NAME(OBJVYSHDw->CNAZEV) CPOS(15,3.7)  CLEN(31) BGND(14) FONT(5)

  TYPE(STATIC) STYPE(2) FPOS(55,-.25) SIZE(52.8,4.6) RESIZE(yy)
    TYPE(GET)  NAME(OBJVYSHDw->ndoklad)      FPOS(24, 1  ) FLEN(14) FCAPTION(2. Objednávka èíslo) CPOS(4,1) FONT(5) CLEN(20)  NOREVISION()
    TYPE(Text) CAPTION(int_èísloObjednávky)  CPOS( 6, 2.5) CLEN(18)
    TYPE(Get)  NAME(OBJVYSHDw->czakobjint)   FPOS(24, 2.5) FLEN(14) 
    TYPE(Text) CAPTION(gen_èísObjednávky)    CPOS( 6, 3.5) CLEN(16)
    TYPE(Text) NAME(OBJVYSHDw->ccisobj)      CPOS(24, 3.5) CLEN(15) BGND(13)
  TYPE(End)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT()
  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce   :)        CPOS(1, 0.6) FONT(5)
  TYPE(TEXT) CAPTION(5. Zpùsob dopravy     :)        CPOS(1, 4.6) FONT(5)
  TYPE(TEXT) CAPTION(6. Vyøizuje pracovník :)        CPOS(1, 7.6) FONT(5)
  TYPE(TEXT) CAPTION(7. Zpracoval          :)        CPOS(1,11.7) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.2) SIZE(108.8,20) STYPE(9) RESIZE(yy)

* POD KONEÈNÝM PØÍJEMCEM
    TYPE(STATIC) FPOS(0.01,4.01) SIZE(44.5,.05) STYPE(9)  RESIZE(yx)
    TYPE(End) 

* STØEDNÍ POD STÁTEM
    TYPE(STATIC) FPOS(0.01,7.01) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* STØEDNÍ DÌLÍCÍ
    TYPE(STATIC) FPOS(44.5,0.01) SIZE(.2,15.9) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNI POD FORMA ÚHRADY
    TYPE(STATIC) FPOS(44.51,11.8) SIZE(70,.05) STYPE(9)  RESIZE(yx)
    TYPE(End)

* SPODNÍ PDO KURZ/PTØEPOÈET
    TYPE(STATIC) FPOS(0.01,15.9) SIZE(108.8,.2) STYPE(9)  RESIZE(yx)
    TYPE(End)


    TYPE(Get)  NAME(OBJVYSHDw->NCISFIRMY)        FPOS(58, 0.5) FLEN(10) FCAPTION(3. Dodavatel )         CPOS(45, 0.5)  FONT(5) CLEN(12) PUSH(fir_firmy_sel) NOREVISION()
    TYPE(Text) CAPTION(Ièo)                      CPOS(71, 0.5) CLEN( 4) 
    TYPE(Get)  NAME(OBJVYSHDw->NICO)             FPOS(76, .5) FLEN(10) 
    TYPE(Text) CAPTION(Diè)                      CPOS(88, 0.5) CLEN( 4)
    TYPE(Get)  NAME(OBJVYSHDw->CDIC)             FPOS(92, .5) FLEN(15) 
    TYPE(Text) CAPTION(Název)                    CPOS(50, 1.5) CLEN( 6)   
    TYPE(Get)  NAME(OBJVYSHDw->CNAZEV)           FPOS(58,1.5) FLEN(49) 
    TYPE(Get)  NAME(OBJVYSHDw->CNAZEV2)          FPOS(58,2.5) FLEN(49)                                                
    TYPE(Text) CAPTION(Ulice)                    CPOS(50, 3.5) 
    TYPE(Get)  NAME(OBJVYSHDw->CULICE)           FPOS(58,3.5) FLEN(49) 
    TYPE(Text) CAPTION(PSè)                      CPOS(50, 4.5) CLEN( 4)
    TYPE(Get)  NAME(OBJVYSHDw->CPSC)             FPOS(58,4.5) FLEN(10)
    TYPE(Get)  NAME(OBJVYSHDw->CSIDLO)           FPOS(70,4.5) FLEN(37)                                                
    TYPE(Text) CAPTION(Stát)                     CPOS(50, 5.5) 
    TYPE(Get)  NAME(OBJVYSHDw->CZKRATSTAT)       FPOS(58,5.5) FLEN(10)
    TYPE(Text) NAME(c_staty->cnazevstat)         CPOS(70, 5.5) CLEN(38) BGND(13)                                               


    TYPE(Text) CAPTION(poøadí Objednávky)        CPOS(50, 7.5) 
    TYPE(Text) NAME(OBJVYSHDw->nrok_obj)         CPOS(70, 7.5) BGND(13) CLEN(6)
    TYPE(Text) CAPTION(/)                        CPOS(76, 7.5)          CLEN(2) FONT(5)
    TYPE(TEXT) NAME(OBJVYSHDw->npor_obj)         CPOS(78, 7.5) BGND(13) CLEN(8) CTYPE(2)
    TYPE(Get)  NAME(OBJVYSHDw->ddatobj)          FPOS(70, 8.5) FLEN(12) PUSH(clickdate) FCAPTION(objednáno Dne) CPOS(50, 8.5) CLEN(13)
    TYPE(Get)  NAME(OBJVYSHDw->dtermdod)         FPOS(70, 9.5) FLEN(12) PUSH(clickdate) FCAPTION(datum Dodání)  CPOS(50, 9.5) CLEN(12)
    TYPE(Get)  NAME(OBJVYSHDw->czkrtypuhr)       FPOS(70,10.5) FLEN(12)                 FCAPTION(forma Úhrady)  CPOS(50,10.5) CLEN(12)
    TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR)         CPOS(83,10.5) CLEN(25) BGND(13)

    TYPE(ComboBox) FPOS(70,12.3) FLEN(25) NAME(OBJVYSHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                          FCAPTION(mìna) CPOS(50,12.3) PP(2)
    TYPE(Get) NAME(OBJVYSHDw->NKURZAHMEN)        FPOS(70,13.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS(50,13.3)   PP(2)
    TYPE(Get) NAME(OBJVYSHDw->NMNOZPREP)         FPOS(83,13.3) FLEN(11)                                                PP(2)


    TYPE(GET)  NAME(OBJVYSHDw->CPRIJEMCE1)        FPOS( 2, 1.5) FLEN(40)
    TYPE(GET)  NAME(OBJVYSHDw->CPRIJEMCE2)        FPOS( 2, 2.5) FLEN(40)

    TYPE(Get)  NAME(OBJVYSHDw->CZKRZPUDOP)        FPOS( 2, 5.5) FLEN(40)


*   6 Vyøizuje pracovník
    TYPE(Get)   NAME(OBJVYSHDw->cnazOsoVyr)     FPOS( 2, 8.3) FLEN(40  ) PUSH(osb_osoby_sel_spoj)
    TYPE(Text)  CAPTION(telefon)                CPOS( 2, 9.5) CLEN(7)    
    TYPE(Text)  NAME(m->c_text_nsspoTeVyr)      CPOS( 9, 9.4) CLEN(33.9)  BGND(13) 
    TYPE(Text)  CAPTION(mail)                   CPOS( 2,10.4) CLEN(7)
    TYPE(Text)  NAME(m->c_text_nsspoEmVyr)      CPOS( 9,10.45) CLEN(33.9) BGND(13)

* cnazOsoVyr, cintpracov
* ncisOsoVyr  ncisOsoby osoby
* nsspoTeVyr  sID       spojeni
* nsspoEmVyr  sID       spojeni

*   7 Zpracoval 
    TYPE(Get)  NAME(OBJVYSHDw->cnazOsoZpr)     FPOS( 2,12.4) FLEN(40  ) PUSH(osb_osoby_sel_spoj) 
    TYPE(Text) CAPTION(telefon)                CPOS( 2,13.6) CLEN(7)
    TYPE(Text) NAME(m->c_text_nsspoTeZpr)      CPOS( 9,13.5) CLEN(33.9)  BGND(13)
    TYPE(Text) CAPTION(mail)                   CPOS( 2,14.5) CLEN(7)
    TYPE(Text) NAME(m->c_text_nsspoEmZpr)      CPOS( 9,14.55) CLEN(33.9) BGND(13)

* cnazOsoZpr, cnazpracov
* ncisOsoZpr  ncisOsoby osoby
* nsspoTeZpr  sID       spojeni
* nsspoEmZpr  sID       spojeni
 

* 7 Zpracoval :
*    TYPE(Get)  NAME(OBJVYSHDw->cnazpracov)       FPOS(70,15) FLEN(37) PUSH(osb_osoby_sel) FCAPTION(odpPracovník)  CPOS(50,15)   CLEN(13)
* cnazOsoZpr
* ncisOsoZpr
* nsspoTeZpr
* nsspoEmZpr

    TYPE(MLE) NAME('OBJVYSHDw->mpoznobj')        FPOS(.5,16.2) SIZE(107.5,3.5) RESIZE(yx) SCROLL(ny)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,7) SIZE(110,21.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()
  TYPE(Text)  CAPTION(èísloSklPoložky)   CPOS( 4  ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                 CPOS(  .8,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  NAME(OBJVYSITw->ccissklad) CPOS( 2  ,0.80) CLEN(11) CTYPE(2) GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                 CPOS(16  ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

  TYPE(Text)  CAPTION(název zboží)       CPOS(19 ,0.01) CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                 CPOS(19 ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(text)  NAME(M->typ_objitem)       CPOS(22 ,0.80) CLEN(10) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
  TYPE(Text)  CAPTION(])                 CPOS(39 ,0.80) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  
  TYPE(Text)  CAPTION(% dph)             CPOS(58 ,0.01) CLEN( 6) CTYPE(1)

  TYPE(Text)  CAPTION(objednánoDne)      CPOS(67 ,0.01) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)       CPOS(82 ,0.01) CLEN(10) CTYPE(1)
  TYPE(Text)  CAPTION(katalogÈíslo)      CPOS(96 ,0.01) CLEN(12) CTYPE(1)

  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,19.7) CTYPE(3) PP(2) 
    TYPE(DBrowse) FPOS(.15,9.8) SIZE(108.9,9.8) FILE(OBJVYSITw)                   ;
                                                FIELDS(M->stav_objvysitw::2.6::2, ;
                                                       ccissklad:sklad          , ; 
                                                       csklpol:sklPol           , ;             
                                                       cjakost:jakost           , ;
                                                       cnazzbo:název zboží:19.5 , ;
                                                       nmnozobdod:mn_objednáno  , ;
                                                       nmnozpodod:mn_potvrzeno  , ;  
                                                       nmnozpldod:mn_dodáno     , ;
                                                       nkczdobj:cenaCelk          ) ;
                                                CURSORMODE(3) PP(6) INDEXORD(2) SCROLL(ny) RESIZE(x)    

*  
* položka objednávky
    TYPE(Get)  NAME(OBJVYSITw->csklpol)    FPOS( 1,1.2  ) FLEN(15) PP(2) PUSH(skl_cenzboz_sel)
    TYPE(Get)  NAME(OBJVYSITw->cnazzbo)    FPOS( 19,1.2  ) FLEN(36) PP(2)
*    TYPE(Text) NAME(OBJVYSITw->cnazzbo)   CPOS(19,1.2  ) CLEN(36) PP(2) BGND(13)
    TYPE(Text) NAME(OBJVYSITw->nklicdph)   CPOS(59,1.2  ) CLEN( 0) BGND(13)
    TYPE(Text) NAME(M->procDph)            CPOS(58,1.2  ) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text) NAME(M->datObj)             CPOS(67,1.2  ) CLEN(12) BGND(13) CTYPE(2)
    TYPE(Get)  NAME(OBJVYSITw->dtermdod)   FPOS(80.5,1.2) FLEN(12) PUSH(clickdate)
    TYPE(Get)  NAME(OBJVYSITw->ckatczbo)   FPOS(95,1.2  ) FLEN(12) 
 
    TYPE(GET)  NAME(OBJVYSITw->ccisZakazI) FPOS(19,2.3  ) FLEN(45) FCAPTION(èíslo Zakázky _____) CPOS( 4,2.3) CLEN(15) PUSH(vyr_vyrzakit_sel)

    TYPE(Text) CAPTION(objednáno na_skl)  CPOS(16,3.5) CLEN(13)
    TYPE(Text) CAPTION(objednáno pro_odb) CPOS(39,3.5) CLEN(15)
    TYPE(Text) CAPTION(objednáno_celk)    CPOS(60,3.5) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(potvrzeno_dod)     CPOS(77,3.5) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(dodáno_celkem)     CPOS(94,3.5) CLEN(12) CTYPE(2)    

    TYPE(STATIC) FPOS(1,4) SIZE(107,4.8) STYPE(13) CTYPE(2)

* množství
    TYPE(Text) CAPTION(Množství v )         CPOS( 1,0.7) CLEN( 9) 
*-    TYPE(Text) NAME(OBJVYSITw->czkratjedn)  CPOS(10,0.7) CLEN( 4) CTYPE(1) FONT(2)

    TYPE(Get)  NAME(OBJVYSITw->nmnozobskl)  FPOS(15,0.7) FLEN(13) PP(2)
    TYPE(Get)  NAME(OBJVYSITw->czkratJedn)  FPOS(30,0.7) FLEN( 6) PP(2)

    TYPE(Get)  NAME(OBJVYSITw->nmnozobodb)  FPOS(38,0.7) FLEN(13) PP(2) PUSH(nak_objvyshd_vzt)
    TYPE(Text) NAME(OBJVYSITw->nmnozobdod)  CPOS(59,0.7) CLEN(13) PP(2) BGND(13) CTYPE(2)
    TYPE(Get)  NAME(OBJVYSITw->nmnozpodod)  FPOS(75,0.7) FLEN(12) PP(2)
    TYPE(Text) NAME(OBJVYSITw->nmnozpldod)  CPOS(91,0.7) CLEN(14) PP(2) BGND(13) CTYPE(2)  
     
* ceny
      TYPE(Text) CAPTION(Ceny v )           CPOS( 1,3.5) CLEN( 7) 
      TYPE(Text) NAME(OBJVYSHDw->czkratmenZ) CPOS(10,3.5) CLEN( 5) CTYPE(1) FONT(2)

      TYPE(Text) CAPTION(nákupní cena)      CPOS(15,2.2) CLEN(13)
      TYPE(Get)  NAME(OBJVYSITw->ncennaodod) FPOS(15,3.5) FLEN(13)   

      TYPE(Text) CAPTION(prodejní cena)     CPOS(38,2.2) CLEN(11) CTYPE(2)
      TYPE(Text) NAME(OBJVYSITw->ncenprodod) CPOS(38,3.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)   CPOS(75,2.2) CLEN(13) CTYPE(2)
      TYPE(Text) NAME(OBJVYSITw->nkcbdobj)   CPOS(75,3.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)     CPOS(95,2.2) CLEN(10) CTYPE(2)
      TYPE(Text) NAME(OBJVYSITw->nkczdobj)   CPOS(91,3.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Static) FPOS(.3,2.3) SIZE(107, .01) STTYPE(9)
      TYPE(End)  
    TYPE(End)

* memoEdit
    TYPE(GET)   NAME(objvysitw->cdoplnTxt)  FPOS(1,8.8) FLEN(100)
    TYPE(PushButton) POS(105.4,8.8) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(objvysitw->mpoznObj,0)
*    TYPE(PushButton) POS(105.4,8.8) SIZE(3,1) EVENT(rtfEdit) ICON1(459) ICON2(214) ATYPE(1) CAPTION(objvysitw->mpoznObj,0)
 TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(objvysitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->ccisZakaz)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nhmotnostJ) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nobjemJ)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->mpoznObj)   FPOS(0,0) CLEN(0)




