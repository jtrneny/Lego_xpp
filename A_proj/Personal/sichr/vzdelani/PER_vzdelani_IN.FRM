TYPE(drgForm) DTYPE(10) TITLE(Dosažené vzdìlání) SIZE(100,21) ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) PRE(PreValidate) POST(postValidate)


* TYPE(Action) CAPTION(~Osoba) EVENT(per_osobakmen_crd)   TIPTEXT(Osoba)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)

  TYPE(Static) SIZE(98,3.8) FPOS(1,.2) RESIZE(y)

    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, -.14) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, -.14) CLEN(15)

    TYPE(TEXT)  NAME(osoby->cprijOsob)      CPOS( 1,1) CLEN(25) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(osoby->cjmenoOsob)     CPOS(28,1) CLEN(15) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(osoby->crozlJmena)     CPOS(45,1) CLEN(15) BGND(13) FONT(5) 
    TYPE(TEXT)  NAME(osoby->ctitulPred)     CPOS(62,1) CLEN(15) BGND(13)
    TYPE(TEXT)  NAME(osoby->ctitulZa)       CPOS(81,1) CLEN(15) BGND(13)

* èíslo osoby
    TYPE(Text)  CAPTION([)                  CPOS( 8,2.05)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(msPrc_mo->ncisOsoby)   CPOS( 9,2.048) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
    TYPE(Text)  CAPTION(])                  CPOS(16,2.05)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

* 2. øádek
    TYPE(TEXT)  FCAPTION(OsÈís/Poø)         CPOS( 1,3.01)   CLEN( 8)
     TYPE(TEXT) NAME(msPrc_mo->nosCisPrac)  CPOS( 9,3.01)   CLEN( 9) BGND(13) PP(2) FONT(5) CTYPE(2)
     TYPE(TEXT) FCAPTION(/)                 CPOS(18,3.01)   CLEN( 2)
     TYPE(TEXT) NAME(msPrc_mo->nporPraVzt)  CPOS(18.6,2.8) CLEN(10) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)
    TYPE(TEXT)  FCAPTION(kmenStøed)         CPOS(35,2.83)   CLEN( 9) 
     TYPE(TEXT) NAME(msPrc_mo->ckmenStrPr)  CPOS(45,2.83)   CLEN( 8) BGND(13) PP(2) FONT(5)
     TYPE(TEXT) NAME(cnazPol1->cnazev)      CPOS(54,2.83)   CLEN(22) 

    TYPE(TEXT)  FCAPTION(rodné Èíslo)       CPOS(81,2.05)   CLEN(15) 
     TYPE(TEXT) NAME(osoby->crodCisosb)     CPOS(81,2.87)   CLEN(15) BGND(13) PP(2) FONT(5) 
  TYPE(END)


  TYPE(Static) STYPE(13) SIZE(98,16) FPOS(1,4.5) RESIZE(y)

   TYPE(DBrowse) FPOS(0,0.5) SIZE(50,15.4) FILE(VzdelaniW)                        ;
                                         FIELDS( nPoradi:poø                    , ;
                                                 cZkrVzdel:typVzdìl             , ;
                                                 M->nazVzdela:název vzdìlání:40 , ;
                                                 dzacStudia:dat_OD              , ; 
                                                 dkonStudia:dat_DO              , ; 
                                                 nPocLetStu:roky                , ;
                                                 cZkrUkoVzd:zpuUkoè             , ;
                                                 dkonStudia:ukonèeno              ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(6) RESIZE(yy)                                        


   TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,15.2) RESIZE(ny)
  
      TYPE(TEXT) CAPTION(Typ vzdìlání)                CPOS( 1,  .5) CLEN(11)
        TYPE(GET)  NAME(vzdelaniW->czkrVzdel)         FPOS(12,  .5) FLEN(12)  NOREVISION()
        TYPE(TEXT) NAME(c_vzdel->cnazVzdela)          CPOS( 1, 1.7) CTYPE(1) CLEN(44) BGND(12) FONT(5)

      TYPE(TEXT) CAPTION(Obor vzdìlání)               CPOS( 1, 3  ) CLEN(11)
        TYPE(GET) NAME(vzdelaniW->coborVzdel)         FPOS(12, 3  ) FLEN(32) PP(2)
      
      TYPE(TEXT) CAPTION(Datum od ... )               CPOS( 1, 4  ) CLEN(11)
        TYPE(GET) NAME(vzdelaniW->dzacStudia)         FPOS(12, 4  ) FLEN(11) PP(2) PUSH(CLICKDATE)
        TYPE(TEXT) CAPTION(do)                        CPOS(24, 4  ) CLEN( 3)
        TYPE(GET) NAME(vzdelaniW->dkonStudia)         FPOS(27, 4  ) FLEN(11) PP(2) PUSH(CLICKDATE)
        TYPE(GET) NAME(vzdelaniW->npocLetStu)         FPOS(40, 4  ) FLEN( 2.5) PP(2)
        TYPE(TEXT) CAPTION(roky)                      CPOS(44, 4  ) CLEN( 2)

    TYPE(TEXT) CAPTION(zp_Ukonèení ...)               CPOS( 1, 6  ) CLEN(11)
      TYPE(GET)  NAME(vzdelaniW->czkrUkoVzd)          FPOS(12, 6  ) FLEN(12) PP(2)
      TYPE(TEXT) NAME(c_vzdeUK->cnazUkoVzd)           CPOS( 1, 7  ) CTYPE(1) CLEN(44) BGND(12) FONT(5)


* 1 - základní údaje pro školu 
      TYPE(Static) FPOS(0.5,8.5) SIZE(44.9,6.0) CAPTION(Název školy) RESIZE(xx)
        TYPE(GET) NAME(vzdelaniW->cnazevSkol)         FPOS( 1, .7) FLEN(42) PP(2)

        TYPE(TEXT)   CAPTION(Ulice/è.popisné)         CPOS( 1, 2) CLEN(12)
          TYPE(GET)  NAME(vzdelaniW->culice)          FPOS(14, 2) FLEN(29) PP(2)

        TYPE(TEXT)   CAPTION(Místo)                   CPOS( 1, 3)
          TYPE(GET)  NAME(vzdelaniW->cmisto)          FPOS(14, 3) FLEN(29) PP(2)

        TYPE(TEXT)   CAPTION(PSÈ)                     CPOS( 1, 4) CLEN(12)
          TYPE(GET)  NAME(vzdelaniW->cpsc)            FPOS(14, 4) FLEN( 8) PP(2)
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)            CPOS(23, 4) CLEN(21) 

        TYPE(TEXT)   CAPTION(Stát)                    CPOS( 1, 5) 
          TYPE(GET)  NAME(vzdelaniW->czkratStat)      FPOS(14, 5) FLEN( 8) PP(2)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)      CPOS(23, 5) CLEN(21) 
      TYPE(End)
    TYPE(End)
   TYPE(END)