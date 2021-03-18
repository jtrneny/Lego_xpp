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
    TYPE(Get)  NAME(OBJVYSHDw->czakobjint)   FPOS(24, 2.5) FLEN(14) PUSH(vyr_vyrzakit_selObj)
    TYPE(Text) CAPTION(gen_èísObjednávky)    CPOS( 6, 3.5) CLEN(16)
    TYPE(Text) NAME(OBJVYSHDw->ccisobj)      CPOS(24, 3.5) CLEN(15) BGND(13)
  TYPE(End)
TYPE(End)

* ZÁKLADNÍ ÚDAJE
TYPE(TabPage) FPOS(0,6.5) SIZE(110,22.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT()
  TYPE(TEXT) CAPTION(4. Koneèný pøíjemce   :)        CPOS(1, 0.6) FONT(5)
  TYPE(TEXT) CAPTION(5. Zpùsob dopravy     :)        CPOS(1, 4.6) FONT(5)
  TYPE(TEXT) CAPTION(6. Vyøizuje pracovník :)        CPOS(1, 7.6) FONT(5)
  TYPE(TEXT) CAPTION(7. Zpracoval          :)        CPOS(1,11.7) FONT(5)

* HLAVNI RAMEC *
  TYPE(STATIC) FPOS(0.5,0.2) SIZE(108.8,20) STYPE(9) RESIZE(yy)

* L - nad 5. Zpùsob dopravy
    TYPE(STATIC) FPOS(0.01,4.01) SIZE(44.5,.05) STYPE(16)  RESIZE(yx)

* L - nad 6. Vyøizuje pracovník
    TYPE(STATIC) FPOS(0.01,7.01) SIZE(44.5,.05) STYPE(16)  RESIZE(yx)

* STØEDNÍ POD STÁTEM
*    TYPE(STATIC) FPOS(0.01,7.01) SIZE(108.8,.05) STYPE(16)  

* SPODNI POD FORMA ÚHRADY
*    TYPE(STATIC) FPOS(44.51,11.8) SIZE(70,.05) STYPE(16)  

* 3. Dodavatel
  TYPE(STATIC) FPOS(44.5,0) SIZE(64.2,16) STYPE(9)  RESIZE(yx)
    TYPE(Get)  NAME(OBJVYSHDw->NCISFIRMY)        FPOS(13, 0.5) FLEN(10) FCAPTION(3. Dodavatel ) CPOS( 1, 0.5)  FONT(5) CLEN(12) PUSH(fir_firmy_sel) NOREVISION()
    TYPE(Text) CAPTION(Ièo)                      CPOS(26, 0.5) CLEN( 4) 
    TYPE(Get)  NAME(OBJVYSHDw->NICO)             FPOS(31, 0.5) FLEN(10) 
    TYPE(Text) CAPTION(Diè)                      CPOS(45, 0.5) CLEN( 4)
    TYPE(Get)  NAME(OBJVYSHDw->CDIC)             FPOS(49,  .5) FLEN(11) 

    TYPE(Text) CAPTION(Název)                    CPOS( 5, 1.5) CLEN( 6)   
    TYPE(Get)  NAME(OBJVYSHDw->CNAZEV)           FPOS(13, 1.5) FLEN(47) 
    TYPE(Get)  NAME(OBJVYSHDw->CNAZEV2)          FPOS(13, 2.5) FLEN(47)                                                

    TYPE(Text) CAPTION(Ulice)                    CPOS( 5, 3.5) 
    TYPE(Get)  NAME(OBJVYSHDw->CULICE)           FPOS(13, 3.5) FLEN(47) 

    TYPE(Text) CAPTION(PSè)                      CPOS( 5, 4.5) CLEN( 4)
    TYPE(Get)  NAME(OBJVYSHDw->CPSC)             FPOS(13, 4.5) FLEN(10)
    TYPE(Get)  NAME(OBJVYSHDw->CSIDLO)           FPOS(27, 4.5) FLEN(33)                                                

    TYPE(Text) CAPTION(Stát)                     CPOS( 5, 5.5) 
    TYPE(Get)  NAME(OBJVYSHDw->CZKRATSTAT)       FPOS(13, 5.5) FLEN(10)
    TYPE(Text) NAME(c_staty->cnazevstat)         CPOS(27, 5.5) CLEN(36) BGND(13)                                               

    TYPE(STATIC) FPOS(0.01,7.01) SIZE(64.2,.05) STYPE(16) RESIZE(xy) 

      TYPE(Text) CAPTION(poøadí Objednávky)        CPOS( 5, 7.5) 
      TYPE(Text) NAME(OBJVYSHDw->nrok_obj)         CPOS(25, 7.5) BGND(13) CLEN(6)
      TYPE(Text) CAPTION(/)                        CPOS(31, 7.5)          CLEN(2) FONT(5)
      TYPE(TEXT) NAME(OBJVYSHDw->npor_obj)         CPOS(33, 7.5) BGND(13) CLEN(8) CTYPE(2)
      TYPE(Get)  NAME(OBJVYSHDw->ddatobj)          FPOS(25, 8.5) FLEN(12) PUSH(clickdate) FCAPTION(objednáno Dne) CPOS( 5, 8.5) CLEN(13)
      TYPE(Get)  NAME(OBJVYSHDw->dtermdod)         FPOS(25, 9.5) FLEN(12) PUSH(clickdate) FCAPTION(datum Dodání)  CPOS( 5, 9.5) CLEN(12)
      TYPE(Get)  NAME(OBJVYSHDw->czkrtypuhr)       FPOS(25,10.5) FLEN(12)                 FCAPTION(forma Úhrady)  CPOS( 5,10.5) CLEN(12)
      TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR)         CPOS(38,10.5) CLEN(25) BGND(13)

    TYPE(STATIC) FPOS(0.01,11.8) SIZE(64.2,.05) STYPE(16) RESIZE(xy) 

      TYPE(ComboBox) FPOS(25,12.3) FLEN(25) NAME(OBJVYSHDw->CZKRATMENZ) VALUES(C_MENY->CZKRATMENY:CNAZMENY);
                                            FCAPTION(mìna) CPOS( 5,12.3) PP(2)
      TYPE(Get) NAME(OBJVYSHDw->NKURZAHMEN)        FPOS(25,13.3) FLEN(10) FCAPTION(Kurz/Pøep)            CPOS( 5,13.3)   PP(2)
      TYPE(Get) NAME(OBJVYSHDw->NMNOZPREP)         FPOS(38,13.3) FLEN(11)                                                PP(2)
  TYPE(END)

* 4. Koneèný pøíjemce
  TYPE(STATIC) FPOS(0,0) SIZE(44.5,16) STYPE(9)  RESIZE(yx)
      TYPE(GET)  NAME(OBJVYSHDw->CPRIJEMCE1)        FPOS( 2, 1.5) FLEN(40)
      TYPE(GET)  NAME(OBJVYSHDw->CPRIJEMCE2)        FPOS( 2, 2.5) FLEN(40)

* 5. Zpùsob dopravy
      TYPE(Get)  NAME(OBJVYSHDw->CZKRZPUDOP)        FPOS( 2, 5.5) FLEN(40)

* 6. Vyøizuje pracovník
      TYPE(Get)   NAME(OBJVYSHDw->cnazOsoVyr)     FPOS( 2, 8.3) FLEN(40  ) PUSH(osb_osoby_sel_spoj)
      TYPE(Text)  CAPTION(telefon)                CPOS( 2, 9.5) CLEN(7)    
      TYPE(Text)  NAME(m->c_text_nsspoTeVyr)      CPOS( 9, 9.4) CLEN(33.9)  BGND(13) 
      TYPE(Text)  CAPTION(mail)                   CPOS( 2,10.4) CLEN(7)
      TYPE(Text)  NAME(m->c_text_nsspoEmVyr)      CPOS( 9,10.45) CLEN(33.9) BGND(13)

* 7. Zpracoval 
    TYPE(Get)  NAME(OBJVYSHDw->cnazOsoZpr)     FPOS( 2,12.4) FLEN(40  ) PUSH(osb_osoby_sel_spoj) 
    TYPE(Text) CAPTION(telefon)                CPOS( 2,13.6) CLEN(7)
    TYPE(Text) NAME(m->c_text_nsspoTeZpr)      CPOS( 9,13.5) CLEN(33.9)  BGND(13)
    TYPE(Text) CAPTION(mail)                   CPOS( 2,14.5) CLEN(7)
    TYPE(Text) NAME(m->c_text_nsspoEmZpr)      CPOS( 9,14.55) CLEN(33.9) BGND(13)
  TYPE(END)


    TYPE(MLE) NAME('OBJVYSHDw->mpoznobj')        FPOS(.5,16.2) SIZE(107.5,3.5) RESIZE(yx) SCROLL(ny)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* POLOŽKY
TYPE(TabPage) FPOS(0,6.5) SIZE(110,22.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()
  TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 4,0.01)   CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS(.8,0.80)   CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(objVysitW->ccissklad)  CPOS( 2,0.80)   CLEN(15) CTYPE(1)  GROUPS(SETFONT,7.Arial CE,GRA_CLR_BLUE)
  TYPE(Text)  CAPTION(])                  CPOS(16,0.80)   CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(èísloIntPožadavku)  CPOS(19,0.01)   CLEN(14) CTYPE(2)
  TYPE(Text)  CAPTION(èísloVýrZakázky)    CPOS(37,0.01)   CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS(34.8,0.80) CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                  CPOS(50,0.80)   CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)

  TYPE(Text)  CAPTION(% dph)             CPOS(58 ,0.01) CLEN( 6) CTYPE(1)
  TYPE(Text)  CAPTION(objednánoDne)      CPOS(67 ,0.01) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)       CPOS(82 ,0.01) CLEN(10) CTYPE(1)
  TYPE(Text)  CAPTION(katalogÈíslo)      CPOS(96 ,0.01) CLEN(12) CTYPE(1)

  TYPE(STATIC) FPOS(.5,  .5) STYPE(9)  SIZE(109,20.7) CTYPE(3) PP(2) 
    TYPE(DBrowse) FPOS(-.15,10.8) SIZE(108.9,9.8) FILE(OBJVYSITw)                   ;
                                                 FIELDS(M->stav_objvysitw::2.6::2 , ;
                                                        nintCount:pol  :6         , ; 
                                                        ccissklad:sklad   :5      , ; 
                                                        csklpol:sklPol            , ; 
                                                        ckatCzbo:katalogÈíslo     , ;            
                                                        cjakost:jakost:10         , ;
                                                        cnazzbo:název zboží:19.5  , ;
                                                        nmnozobdod:mn_objednáno:10, ;
                                                        nmnozpodod:mn_potvrzeno:10, ;  
                                                        nmnozpldod:mn_dodáno      , ;
                                                        nkczdobj:cenaCelk           ) ;
                                                 CURSORMODE(3) PP(6) INDEXORD(1) SCROLL(ny) RESIZE(x) POPUPMENU(yn)

*  
* položka objednávky
    TYPE(Get)      NAME(OBJVYSITw->csklpol)    FPOS( 1,1.2) FLEN(15) PP(2) PUSH(objVyshd_z_sel)
    TYPE(Get)      NAME(objVysitW->ncisIntPoz) FPOS(18,1.2) FLEN(15) PP(2) PUSH(objVyshd_z_sel)
    TYPE(Get)      NAME(objVysitW->ccisZakazI) FPOS(35,1.2) FLEN(15) PP(2) PUSH(vyr_vyrzakit_selZak)

    TYPE(Text)     NAME(OBJVYSITw->nklicdph)   CPOS(59,1.2) CLEN( 0) BGND(13)
    TYPE(Text)     NAME(M->procDph)            CPOS(58,1.2) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
    TYPE(Text)     NAME(M->datObj)             CPOS(67,1.2) CLEN(12) BGND(13) CTYPE(2)
    TYPE(Get)      NAME(OBJVYSITw->dtermdod)   FPOS(80,1.2) FLEN(12) PUSH(clickdate)
    TYPE(Get)      NAME(OBJVYSITw->ckatczbo)   FPOS(95,1.2) FLEN(12) 

    TYPE(Get)      NAME(OBJVYSITw->cnazzbo)    FPOS( 1,2.5) FLEN(49) PP(2)
    TYPE(COMBOBOX) NAME(objVysitW->ctypSklPol) FPOS(58,2.5) FLEN(21) FCAPTION(typPol)  CPOS(52,2.5) CLEN(6) REF(typSklPol) 
    TYPE(COMBOBOX) NAME(objVysitW->cstavDokl)  FPOS(95,2.5) FLEN(13) FCAPTION(stavPol) CPOS(87,2.5) CLEN(6) REF(cstavDokl) 

    TYPE(Text) CAPTION(objednáno na_skl)  CPOS(16,4.05) CLEN(13)
    TYPE(Text) CAPTION(objednáno pro_odb) CPOS(39,4.05) CLEN(15)
    TYPE(Text) CAPTION(objednáno_celk)    CPOS(60,4.05) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(potvrzeno_dod)     CPOS(75,4.05) CLEN(12) CTYPE(2)
    TYPE(Text) CAPTION(dodáno_celkem)     CPOS(90,4.05) CLEN(12) CTYPE(2)    

    TYPE(Text) CAPTION(nákupní cena                 [) CPOS( 2,8.1) CLEN(15) GROUPS(SETFONT,8.Cambria,GRA_CLR_DARKBLUE)   
    TYPE(Text) NAME(M->cenaNzbo)                       CPOS(18,8.1) CLEN(10) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)   
    TYPE(Text) CAPTION(])                              CPOS(29,8.1) CLEN( 2) GROUPS(SETFONT,8.Cambria,GRA_CLR_DARKBLUE)   


    TYPE(STATIC) FPOS(1,4.5) SIZE(107,3.9) STYPE(13) CTYPE(2)

* množství
      TYPE(Text) CAPTION(Množství v )         CPOS( 1, .5) CLEN( 9) 

      TYPE(Get)  NAME(OBJVYSITw->nmnozobskl)  FPOS(15, .5) FLEN(13) PP(2)
      TYPE(Get)  NAME(OBJVYSITw->czkratJedn)  FPOS(30, .5) FLEN( 6) PP(2)

      TYPE(Get)  NAME(OBJVYSITw->nmnozobodb)  FPOS(38, .5) FLEN(13) PP(2) PUSH(nak_objvyshd_vzt)
      TYPE(Text) NAME(OBJVYSITw->nmnozobdod)  CPOS(59, .5) CLEN(13) PP(2) BGND(13) CTYPE(2)
      TYPE(Get)  NAME(OBJVYSITw->nmnozpodod)  FPOS(75, .5) FLEN(12) PP(2)
      TYPE(Text) NAME(OBJVYSITw->nmnozpldod)  CPOS(91, .5) CLEN(14) PP(2) BGND(13) CTYPE(2)  
     
* ceny
      TYPE(Text) CAPTION(Ceny v )            CPOS( 1,2.5) CLEN( 7) 
      TYPE(Text) NAME(OBJVYSHDw->czkratmenZ) CPOS(10,2.5) CLEN( 5) CTYPE(1) FONT(2)

      TYPE(Text) CAPTION(objednací cena)     CPOS(15,1.56) CLEN(13)         GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 
      TYPE(Get)  NAME(OBJVYSITw->ncennaodod) FPOS(15,2.5) FLEN(13)   

      TYPE(Text) CAPTION(prodejní cena)      CPOS(36,1.5) CLEN(11) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE)
      TYPE(Text) NAME(OBJVYSITw->ncenprodod) CPOS(38,2.5) CLEN(14) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem bez danì)    CPOS(73,1.5) CLEN(13) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE)
      TYPE(Text) NAME(OBJVYSITw->nkcbdobj)   CPOS(75,2.5) CLEN(13) BGND(13) CTYPE(2)

      TYPE(Text) CAPTION(celkem s daní)      CPOS(90,1.5) CLEN(10) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE)
      TYPE(Text) NAME(OBJVYSITw->nkczdobj)   CPOS(91,2.5) CLEN(14) BGND(13) CTYPE(2)
    TYPE(End)

* memoEdit
    TYPE(GET)   NAME(objvysitw->cdoplnTxt)  FPOS(1,9.6) FLEN(100)
    TYPE(PushButton) POS(105.4,9.8) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(objvysitw->mpoznObj,0)
*    TYPE(PushButton) POS(105.4,8.8) SIZE(3,1) EVENT(rtfEdit) ICON1(459) ICON2(214) ATYPE(1) CAPTION(objvysitw->mpoznObj,0)
 TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(objvysitw->cfile_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nrecs_iv)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->ccisZakaz)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nhmotnostJ) FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nobjemJ)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->mpoznObj)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(objvysitw->nINTPOZAD)  FPOS(0,0) CLEN(0)




