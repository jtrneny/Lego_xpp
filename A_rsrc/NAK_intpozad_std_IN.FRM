TYPE(drgForm) DTYPE(10) TITLE(Poøízení/Oprava interní objednávky ...) SIZE(110,20) FILE(INTPOZADw) ;
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n)          ;
              BORDER(4)                                             ;
              POST(postValidate)

  TYPE(Static) STYPE(12) CTYPE(2) SIZE(110,1.2) FPOS(.1,0) RESIZE(yn)
    TYPE(Text) CAPTION(Vyøizuje pracovník ...)  CPOS(  2, .1) CLEN(16)
    TYPE(TEXT) NAME(intPozadw->cNazOsoZpr)      CPOS( 18, .1) CLEN(25)  GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
    TYPE(Text) NAME(M->c_text_nsspo_Zpr)        CPOS( 45, .1) CLEN(40)  GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)

    TYPE(Text)  NAME(cintPol)                   CPOS( 92, .01) CLEN(20) CTYPE(1) BGND(15) FONT(5) 
  TYPE(END)


  TYPE(Text)  CAPTION(èísloSklPoložky)    CPOS( 2,1.8 )  CLEN(11) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS( 0,2.5 )  CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  NAME(intPozadw->ccissklad)  CPOS( 2,2.55)  CLEN(15) CTYPE(1)  GROUPS(SETFONT,7.Arial CE,GRA_CLR_BLUE)
  TYPE(Text)  CAPTION(])                  CPOS(16,2.5 )  CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)

  TYPE(Text)  CAPTION(èísloVýrZakázky)    CPOS(19,1.8)   CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION([)                  CPOS(17,2.5)   CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)
  TYPE(Text)  CAPTION(])                  CPOS(50,2.5)   CLEN( 2) CTYPE(2)  GROUPS(SETFONT,7.Arial CE)

  TYPE(Text)  CAPTION(% dph)             CPOS(58 ,1.8) CLEN( 6) CTYPE(1)
  TYPE(Text)  CAPTION(objednánoDne)      CPOS(67 ,1.8) CLEN(12) CTYPE(1)
  TYPE(Text)  CAPTION(datumDodání)       CPOS(82 ,1.8) CLEN(10) CTYPE(1)
  TYPE(Text)  CAPTION(katalogÈíslo)      CPOS(96 ,1.8) CLEN(12) CTYPE(1)

  TYPE(Static) STYPE(2) SIZE(110,17.3) FPOS(.1,2) RESIZE(yn)

    TYPE(DBrowse) FPOS(-.15,10) SIZE(108.9,8) FILE(INTPOZADw)                    ;
                                                  FIELDS(M->stav_objvysitw::2.6::2 , ;
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
    TYPE(Get)      NAME(intPozadw->csklPol)    FPOS( 1,1.5) FLEN(15) PP(2) PUSH(objVyshd_z_sel)
    TYPE(Get)      NAME(intPozadw->ccisZakazI) FPOS(18,1.5) FLEN(32) PP(2) PUSH(vyr_vyrzakit_sel)

    TYPE(Text)     NAME(intPozadw->nklicdph)   CPOS(59,1.5) CLEN( 0) BGND(13)
    TYPE(Text)     NAME(M->procDph)            CPOS(58,1.5) CLEN( 7) BGND(13) FONT(5) CTYPE(2)
    TYPE(Get)      NAME(intPozadw->ddatObDod)  FPOS(66,1.5) FLEN(12) PUSH(clickdate)
    TYPE(Get)      NAME(intPozadw->dtermDod)   FPOS(80,1.5) FLEN(12) PUSH(clickdate)
    TYPE(Get)      NAME(intPozadw->ckatczbo)   FPOS(95,1.5) FLEN(12) 

    TYPE(Get)      NAME(intPozadw->cnazZbo)    FPOS( 1,2.6) FLEN(49) PP(2)
    TYPE(COMBOBOX) NAME(intPozadw->ctypSklPol) FPOS(58,2.6) FLEN(21) FCAPTION(typPol)  CPOS(52,2.6) CLEN(6) REF(typSklPol) 
    TYPE(COMBOBOX) NAME(intPozadw->cstavDokl)  FPOS(95,2.6) FLEN(13) FCAPTION(stavPol) CPOS(87,2.6) CLEN(6) REF(cstavDokl) 

    TYPE(Text) CAPTION(objednáno na_sklad)     CPOS(15,4) CLEN(14) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 
    TYPE(Text) CAPTION(nákupní cena)           CPOS(41,4) CLEN(10) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 
    TYPE(Text) CAPTION(celkem bez danì)        CPOS(73,4) CLEN(12) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 
    TYPE(Text) CAPTION(celkem s daní)          CPOS(91,4) CLEN(10) CTYPE(2) GROUPS(SETFONT,8.Cambria,GRA_CLR_BLUE) 

    TYPE(STATIC) FPOS(1,4.5) SIZE(107,5.3) STYPE(13) CTYPE(2)
* množství
      TYPE(Text) CAPTION(Množství v )         CPOS( 1, .5) CLEN( 9) 

      TYPE(Get)  NAME(intPozadw->nmnozObSkl)  FPOS(15, .5) FLEN(13) PP(2)
      TYPE(Get)  NAME(intPozadw->czkratJedn)  FPOS(30, .5) FLEN( 6) PP(2)
     
* ceny
      TYPE(Get)  NAME(intPozadw->ncennaodod)  FPOS(40, .5) FLEN(13)      
      TYPE(Text) NAME(intPozadw->czkratmenZ)  CPOS(54, .5) CLEN( 5) CTYPE(1) FONT(2)   
      TYPE(Text) NAME(intPozadw->nkcbdobj)    CPOS(73, .5) CLEN(13) BGND(13) CTYPE(2)
      TYPE(Text) NAME(intPozadw->nkczdobj)    CPOS(91, .5) CLEN(14) BGND(13) CTYPE(2)    
 
      TYPE(TEXT) CAPTION(Urèeno pro  ...  )  CPOS(  1, 1.7) CLEN(12)
      TYPE(GET)  NAME(intPozadw->cosoba_Pro) FPOS( 15, 1.7) FLEN(38) PUSH(osb_osoby_sel_spoj) 
      TYPE(Text) NAME(M->c_text_nsspo_Pro)   CPOS( 55, 1.7) CLEN(40) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)

* memoEdit      
      TYPE(GET)   NAME(intPozadw->cdoplnTxt)  FPOS(1,2.9) FLEN(100)
      TYPE(PushButton) POS(102.4,2.8) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(intPozadw->mpoznObj,0)

* potenciální dodvatel
       TYPE(TEXT) CAPTION(Dodavatel  ...  )   CPOS( 1, 4) CLEN(12)
       TYPE(GET)  NAME(nCisFirmy)             FPOS(15, 4) FLEN( 8) PUSH(fir_firmy_sel)
       TYPE(Text) NAME(M->nazFirmy)           CPOS(24, 4) CLEN(30) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
       TYPE(Text) NAME(M->c_text_infoFirmy)   CPOS(55, 4) CLEN(60) GROUPS(SETFONT,8.Arial CE,GRA_CLR_BLUE)
   TYPE(End)   


* TYPE(TEXT) CAPTION(Dodavatel)  CPOS( 2,8.5) CLEN(10) 
*    TYPE(STATIC) STYPE(9)  FPOS(1,.2) SIZE( 103, 6 ) RESIZE(yn)
*      TYPE(GET)  NAME(nCisFirmy)       FPOS(  7 ,0.5) FLEN( 8) FCAPTION(Firma)  CPOS( 1 ,0.5) PUSH(fir_firmy_sel)
*      TYPE(GET)  NAME(cNazFirmy)       FPOS( 25, 0.5) FLEN(51) FCAPTION(Název)  CPOS( 18,0.5) 
*      TYPE(GET)  NAME(cUlice)          FPOS( 25, 1.5) FLEN(20) FCAPTION(Ulice)  CPOS( 18,1.5)
*      TYPE(GET)  NAME(cSidlo)          FPOS( 53, 1.5) FLEN(23) FCAPTION(Místo)  CPOS( 47,1.5)
*      TYPE(GET)  NAME(nICO)            FPOS( 87, 0.5) FLEN(14) FCAPTION(IÈO)    CPOS( 80,0.5)
*      TYPE(GET)  NAME(cDIC)            FPOS( 87, 1.5) FLEN(14) FCAPTION(DIÈ)    CPOS( 80,1.5)
*  TYPE(End)   

  TYPE(End)
