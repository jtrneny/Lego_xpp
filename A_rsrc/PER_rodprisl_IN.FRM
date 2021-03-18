TYPE(drgForm) DTYPE(10) TITLE(Rodinní pøíslušníci) SIZE(100,21) ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) PRE(PreValidate) POST(postValidate)


* TYPE(Action) CAPTION(~Osoba) EVENT(per_osobakmen_crd)   TIPTEXT(Osoba)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)

  TYPE(Static) SIZE(98,3.8) FPOS(1,.2) RESIZE(y)

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

   TYPE(DBrowse) FPOS(0,0.5) SIZE(50,15.4) FILE(vazOsobyW)                             ;
                            FIELDS( vazOsobyW->ncisOsoby:èíslOsoby                 , ;
                                     vazOsobyW->cjmenoRozl:Pøímení a jméno osoby:30, ;
                                     vazOsobyW->ctypRodPri:typVztahu               , ;
                                     vazOsobyW->cjmenoOsob:rozen(á)                , ;
                                     vazOsobyW->crodCisOsb:rodÈíslo                , ;
                                     vazOsobyW->ddatNaroz:datNaroz                 , ;   
                                     vazOsobyW->CMISTO:Mìsto:25                    , ;
                                     vazOsobyW->CZKRATSTAT:Stát                      ) ;
                             CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(6) RESIZE(yy)


   TYPE(Static) STYPE(13) FPOS(51,.5) SIZE(46.1,15.2) RESIZE(ny)
  
      TYPE(TEXT) CAPTION(Èíslo osoby )                CPOS( 1,  .5)
        TYPE(GET)  NAME(vazOsobyW->ncisOsoby)         FPOS(18,  .5) FLEN(12) PUSH(per_osoby_sel) NOREVISION()
        TYPE(PushButton)                              POS( 31,  .5) ;
                                                      SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                      CAPTION(2)

        TYPE(TEXT) NAME(osoby_Rp->cjmenoRozl)         CPOS( 2, 2  ) CTYPE(1) CLEN(42) BGND(12) FONT(5)

      TYPE(TEXT) CAPTION(rozen(á))                    CPOS( 1, 3) CLEN( 7)
        TYPE(TEXT) NAME(osoby_Rp->cjmenoOsob)         CPOS(16, 3)          FONT(5)

      TYPE(TEXT) CAPTION(Datum narození )             CPOS( 1, 4)
        TYPE(GET) NAME(vazOsobyW->ddatNaroz)          FPOS(16 ,4) FLEN(14) PP(2) FONT(5) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Rodné èíslo)                 CPOS( 1, 5)
        TYPE(GET) NAME(vazOsobyW->crodCisOsb)         FPOS(16, 5) FLEN(14) PP(2) FONT(5)
 
      TYPE(TEXT) CAPTION(Typ vztahu)                  CPOS( 1, 6) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->ctypRodPri)    FPOS(16, 6) FLEN(28)  REF(ctypRodPri)

      TYPE(TEXT) CAPTION(Ulatnit slevu)               CPOS( 1, 7) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->lsleOdpDan)    FPOS(16, 7) FLEN( 9)  REF( LYESNO) 

      TYPE(TEXT) CAPTION(Vyživovaná osoba)            CPOS( 1, 8) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->lVyzivOsob)    FPOS(16, 8) FLEN( 9)  REF( LYESNO) 

* 1 - základní údaje pro rodinné pøíslušníky
      TYPE(Static) FPOS(0.5,9.5) SIZE(44.7,5.0) CAPTION(Adresa) RESIZE(xx)
*       TYPE(Text) CAPTION(Adresa)            CPOS( 1, 0.8) CLEN(20) FONT(5)

        TYPE(TEXT)   CAPTION(Ulice/è.popisné)         CPOS( 2, 1) CLEN(12)
          TYPE(TEXT) NAME(osoby_Rp->cUlicCiPop)       CPOS(15, 1) CLEN(29) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)                   CPOS( 2, 2)
          TYPE(TEXT) NAME(osoby_Rp->cmisto)           CPOS(15, 2) CLEN(29) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                     CPOS( 2, 3) CLEN(12)
          TYPE(TEXT) NAME(osoby_Rp->cpsc)             CPOS(15, 3) CLEN( 8) BGND(13) 
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)            CPOS(24, 3) CLEN(20) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                    CPOS( 2, 4) 
          TYPE(TEXT) NAME(osoby_Rp->czkratStat)       CPOS(15, 4) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)      CPOS(24, 4) CLEN(20) BGND(13)
      TYPE(End)
    TYPE(End)
   TYPE(END)