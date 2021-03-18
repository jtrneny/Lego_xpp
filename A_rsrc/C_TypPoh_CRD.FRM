TYPE(drgForm) DTYPE(10) TITLE(Typ pohybu ...) SIZE(75,24) FILE(C_TypPOHw);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST( POSTVALIDATE) CBSAVE(OnSave)


TYPE(Static) STYPE(12) SIZE(74, 3.5) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(Text) CAPTION(Typ pohybu)        CPOS( 4,  .2) CLEN( 17) FONT(2)
  TYPE(GET)  NAME(cTypPohybu)           FPOS( 4, 1.2) FLEN( 15) FONT(5) PP(2) NOREVISION()
  TYPE(Text) CAPTION(Název typu pohybu) CPOS(21,  .2) CLEN( 20) FONT(2)
  TYPE(GET)  NAME(cNazTypPoh)           FPOS(21, 1.2) FLEN( 50) FONT(5) PP(2)

  TYPE(CHECKBOX) NAME(c_typpohW->lnab_pohyb) FPOS(21, 2.3) FLEN(30) VALUES(T:  nabízet pohyb pro poøízeni dokladù,F:  nabízet pohyb pro poøízeni dokladù) 
TYPE(End)

TYPE(Static) STYPE(13) SIZE( 75,20.5) FPOS(0,3.7)  RESIZE(yy)

* ZÁKLADNÍ ÚDAJE
  TYPE(TABPAGE) CAPTION(Základní údaje) OFFSET(1, 75)

    TYPE(Static) STYPE(13) SIZE( 74,19) FPOS(0.5, 0.2) RESIZE(yn)
      TYPE(GET)      NAME(cTask)                 FPOS(20, 1) FLEN( 15) FCAPTION(Zkratka úlohy)             CPOS( 1, 1) NOREVISION()
      TYPE(Text)     NAME(c_Task->cNazUlohy)     CPOS(37, 1) CLEN( 30) BGND(13)
      TYPE(GET)      NAME(cSubTask)              FPOS(20, 2) FLEN( 15) FCAPTION(Zkratka podúlohy)          CPOS( 1, 2) NOREVISION()
      TYPE(GET)      NAME(cTypDoklad)            FPOS(20, 3) FLEN( 15) FCAPTION(Typ dokladu)               CPOS( 1, 3) NOREVISION()
      TYPE(Text)     NAME(TypDokl->cNazTypDok)   CPOS(37, 3) CLEN( 30) BGND(13)

*      TYPE(GET)      NAME(cUloha)                FPOS(20, 4.5) FLEN( 15) FCAPTION(Pøíslušnost k úloze)      CPOS( 1, 4.5)
      TYPE(GET)      NAME(cPoduloha)             FPOS(20, 4.5) FLEN( 15) FCAPTION(Podúloha pøíslušné úlohy) CPOS( 1, 4.5)
      TYPE(GET)      NAME(cSubPohyb)             FPOS(20, 5.6) FLEN( 15) FCAPTION(Generovaný typ pohybu)    CPOS( 1, 5.6)

      TYPE(COMBOBOX) NAME(lUctuj)               FPOS(20, 8.5) FLEN( 16) FCAPTION(Úètuj pohyb)               CPOS( 1, 8.5) REF( LYESNO)
      TYPE(COMBOBOX) NAME(lNaklStr)              FPOS(20, 9.5) FLEN( 16) FCAPTION(Nákladová struktura)      CPOS( 1, 9.5) REF( LYESNO)
      TYPE(Text)     CAPTION(Platnost parametru   od) CPOS( 1,10.5) CLEN( 19)
      TYPE(GET)      NAME(dPlatnyOd)            FPOS(20,10.5) FLEN( 15) PUSH(CLICKDATE)
      TYPE(Text)     CAPTION(do)                CPOS(37,10.5) CLEN(  3)
      TYPE(GET)      NAME(dPlatnyDo)            FPOS(41,10.5) FLEN( 15) PUSH(CLICKDATE)
*      TYPE(GET)      NAME(nKarta)               FPOS(20,11.5) FLEN( 15) FCAPTION(Typ editaèní karty)     CPOS( 1,11.5)

      TYPE(COMBOBOX) NAME(nTypPohyb)             FPOS(20,15.8) FLEN( 16) FCAPTION(Typ pohybu)            CPOS( 1,15.8)   VALUES(0:neurèen, 1:pøíjmový, -1:výdejový)
      TYPE(COMBOBOX) NAME(lProdukce)             FPOS(20,16.9) FLEN( 16) FCAPTION(Produkce)              CPOS( 1,16.9) REF( LYESNO)
      TYPE(GET)      NAME(nPodm)                 FPOS(20,18)   FLEN( 15) FCAPTION(Typ podmínky)          CPOS( 1,18)
    TYPE(End)
  TYPE(END)

* 2 - dolpòující údaje pro konkrétné specifika nastavení
  TYPE(TabPage) TTYPE(4) CAPTION(Doplòující) OFFSET(24,52)
    TYPE(Static) FPOS(1,.05) SIZE(72,4) RESIZE(yn)
      TYPE(TEXT) CAPTION(Mzdy - trvalé závazky a srážky)       CPOS( 1, .3) FONT(5)

      TYPE(COMBOBOX) NAME(nPovUcTrZa)  FPOS(23,1.5)   FLEN( 26) FCAPTION(Povinný úèet v trvZavhd) CPOS( 1,1.5) VALUES(0:úèet není povinný údaj  , 1:úèet je   povinný údaj)
      TYPE(COMBOBOX) NAME(nTrZaDoSrz)  FPOS(23,2.7)   FLEN( 26) FCAPTION(Povolit ve srážkách    ) CPOS( 1,2.7) VALUES(0:nelze použít v trv.srážkách, 1:lze použít ve srážkách)
    TYPE(END)

    TYPE(Static) FPOS(1,4.5) SIZE(72,3.6) RESIZE(yn)
      TYPE(TEXT) CAPTION(Sklady - pøednastavení úètuTržeb, nákladové struktury a storna dokladu )       CPOS( 1, .3) FONT(5)

      TYPE(COMBOBOX) NAME(npredCenZb)  FPOS(23,1.5)   FLEN( 26) FCAPTION(Povolit pøednastavení)  CPOS( 1,1.5) VALUES(0:není povoleno pøednastavení , 1:je povoleno pøednastavení)
      TYPE(COMBOBOX) NAME(nstornoDok)  FPOS(23,2.7)   FLEN( 26) FCAPTION(Povolit storno dokladu) CPOS( 1,2.7) VALUES(0:není povoleno storno Dokladu, 1:je povoleno storno Dokladu)
    TYPE(END)

    TYPE(Static) FPOS(1,8.6) SIZE(72,5.5) RESIZE(yn)
      TYPE(TEXT) CAPTION(Finance_ - kurz, pøednastavení výpoètu sazby danì )       CPOS( 1, .3) FONT(5)

      TYPE(COMBOBOX) NAME(cTypKurzu)   FPOS(23, 1.5)  FLEN( 26) FCAPTION(Typ kurzu)                  CPOS( 1, 1.5) REF( CTYPKURZU)
      TYPE(COMBOBOX) NAME(cvypSAZdan)  FPOS(23, 2.6)  FLEN( 26) FCAPTION(Pøednastavení výpoètu DPH)  CPOS( 1, 2.6) VALUES(        :není nastaveno            , ; 
                                                                                                                         VYPsaz_1:typ výpoètu pøes procento , ;
                                                                                                                         VYPsaz_2:typ výpoètu pøes koeficient )
* 2011
*     TYPE(GET)      NAME(cRadDph091)            FPOS(20, 7.5) FLEN( 20) FCAPTION(Od 2009)                   CPOS( 1, 7.5)
*     TYPE(GET)      NAME(cRadDph114)            FPOS(23, 3.7) FLEN( 26) FCAPTION(Øádky DPH od 4/2011)       CPOS( 1, 3.7) CLEN(19)
     TYPE(GET)       NAME(cRadDph151)            FPOS(23, 3.7) FLEN( 25) FCAPTION(Øádky DPH od 1/2015)       CPOS( 1, 3.7) CLEN(19)
     TYPE(COMBOBOX)  NAME(npokladEET)            FPOS(23, 4.8) FLEN( 26) FCAPTION(Elektronická evidence EET) CPOS( 1, 4.8) VALUES(0:doklad se neodesílá na EET, 1:doklad se odesílá na EET)

    TYPE(END)

    TYPE(Static) FPOS(1,14.6) SIZE(72,4.2) RESIZE(yn)
      TYPE(TEXT) CAPTION(Zvíøata_ - pøednastavení pohybù)                         CPOS( 1, .3) FONT(5)
      TYPE(GET)      NAME(nDrPohPL1)             FPOS(23,1.3)   FLEN( 26) FCAPTION(Pohyb plemen. 1)       CPOS( 1,1.3)
      TYPE(GET)      NAME(nDrPohPL2)             FPOS(23,2.4)   FLEN( 26) FCAPTION(Pohyb plemen. 2)       CPOS( 1,2.4)                     
      TYPE(GET)      NAME(nDrPohPLPr)            FPOS(23,3.5)   FLEN( 26) FCAPTION(Pohyb plemen. pras.)   CPOS( 1,3.5)


    TYPE(END)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(END)


* 3 - POPIS typu pohybu
  TYPE(TabPage) TTYPE(4) CAPTION(Popis typu) OFFSET(47,29)
    TYPE(MLE) NAME(mPOPITYPPO) FPOS(1, 0.5) SIZE(73,18)
  TYPE(End)

* 4 - POZNÁMKA k typu pohybu
  TYPE(TabPage) TTYPE(4) CAPTION(Poznámka) OFFSET(70,6)
    TYPE(MLE) NAME(mPoznamka) FPOS(1, 0.5) SIZE(73,18)
  TYPE(End)

TYPE(End)