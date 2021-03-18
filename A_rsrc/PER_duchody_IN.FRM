TYPE(drgForm) DTYPE(10) TITLE(Dùchody) SIZE(100,21) ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) PRE(PreValidate) POST(postValidate)


* TYPE(Action) CAPTION(~Osoba) EVENT(per_osobakmen_crd)   TIPTEXT(Osoba)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)

  TYPE(Static) SIZE(98,3.8) FPOS(1,.2) RESIZE(yn)

    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, -.14) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, -.14) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, -.14) CLEN(15)

    TYPE(TEXT)  NAME(msPrc_mo->cprijOsob)   CPOS( 1,1) CLEN(25) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(msPrc_mo->cjmenoOsob)  CPOS(28,1) CLEN(15) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(msPrc_mo->crozlJmena)  CPOS(45,1) CLEN(15) BGND(13) FONT(5) 
    TYPE(TEXT)  NAME(msPrc_mo->ctitulPred)  CPOS(62,1) CLEN(15) BGND(13)
    TYPE(TEXT)  NAME(msPrc_mo->ctitulZa)    CPOS(81,1) CLEN(15) BGND(13)

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
     TYPE(TEXT) NAME(msPrc_mo->crodCisPra)  CPOS(81,2.87)   CLEN(15) BGND(13) PP(2) FONT(5) 
  TYPE(END)


  TYPE(Static) STYPE(13) SIZE(98,16) FPOS(1,4.5) RESIZE(y)

    TYPE(DBrowse) FPOS(0,0.5) SIZE(50,15.4) FILE(duchodyW)               ;
                                FIELDS( M->is_Aktiv:ad:2.6::2          , ;
                                        nporDuchod:poøadí              , ;
                                        ntypDuchod:typ dùchodu         , ;
                                        M->nazDuchod:název typu dùchodu, ;
                                        dpriznDuOd:pøiznán             , ; 
                                        dpriznDuDo:pøiznán DO            ) ;
                                CURSORMODE(3) PP(7) SCROLL(yy)  INDEXORD(2) ITEMMARKED(ItemMarked) GROUPS(7)

    TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,15.2) RESIZE(ny)
 
      TYPE(TEXT)  CAPTION(Typ dùchodu ...)         CPOS( 1, 1) CLEN(12) 
       TYPE(GET)  NAME(duchodyW->ntypDuchod)       FPOS(13, 1) FLEN( 7) NOREVISION()
*       TYPE(TEXT) CAPTION(/)                       CPOS(21, 1) CLEN( 2)
*       TYPE(TEXT) NAME(duchodyW->nporDuchod)       CPOS(22, 1) CLEN( 4) PICTURE(99)
       TYPE(TEXT) NAME(c_duchod->cnazDuchod)       CPOS(21, 1)

      TYPE(TEXT)  NAME(c_duchod->cnazDuchod)       CPOS( 2, 2.5) CTYPE(1) CLEN(48) BGND(12) GROUPS(SETFONT,11.Arial,GRA_CLR_BLUE)

      TYPE(TEXT)  CAPTION(Pøiznán _ od)            CPOS( 1, 4) CLEN(12)
       TYPE(GET)  NAME(duchodyW->dpriznDuOd)       FPOS(13, 4) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 4) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dpriznDuDo)       FPOS(33, 4) FLEN(11) PUSH(CLICKDATE)

      TYPE(TEXT)  CAPTION(Nárok _ od)              CPOS( 1, 5) CLEN(12)
       TYPE(GET)  NAME(duchodyW->dnarDuchOd)       FPOS(13, 5) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 5) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dnarDuchDo)       FPOS(33, 5) FLEN(11) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Aktivní dùchod)           CPOS( 1, 6) CLEN(12)
        TYPE(COMBOBOX) NAME(duchodyW->lAktiv)      FPOS(13, 6) FLEN(12) REF( LYESNO) 

* 1 - základní údaje pro pøiznané dùchody
      TYPE(Static) FPOS(0.5,8.0) SIZE(44.7,6.4) CAPTION(vyplácející OSSZ) RESIZE(xx)
        TYPE(Text)  CAPTION(Firma  ... )          CPOS( 1, 1) CLEN(12) FONT(5)        
          TYPE(GET)  NAME(duchodyW->ncisFirmy)     FPOS(13, 1) FLEN( 7) 
          TYPE(TEXT) NAME(firmy->cnazev)           CPOS(21, 1)
           
         TYPE(TEXT)   CAPTION(Ulice/è.popisné)     CPOS( 2, 2.5) CLEN(12)
           TYPE(TEXT) NAME(firmy->cUlice)           CPOS(15, 2.5) CLEN(30) BGND(13) 
           TYPE(TEXT) NAME(firmy->cSidlo)           CPOS(15, 2.5) CLEN(30) BGND(13) 

         TYPE(TEXT)   CAPTION(Místo)               CPOS( 2, 3.5)
           TYPE(TEXT) NAME(duchodyW->cnazev)        CPOS(15, 3.5) CLEN(30) BGND(13)

         TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 4.5) CLEN(12)
           TYPE(TEXT) NAME(firmy->cpsc)            CPOS(15, 4.5) FLEN( 8) BGND(13)
           TYPE(TEXT) NAME(C_PSC_3->CMISTO)        CPOS(25, 4.5) CLEN(21) BGND(13)                     

         TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 5.5) 
           TYPE(TEXT) NAME(firmy->czkratStat)      CPOS(15, 5.5) CLEN( 8) BGND(13)
           TYPE(TEXT) NAME(C_STATY_3->cNAZEVSTAT)  CPOS(25, 5.5) CLEN(21) BGND(13)
      TYPE(End)
    TYPE(End)
  TYPE(End)
