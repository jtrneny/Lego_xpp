TYPE(drgForm) DTYPE(10) TITLE(Rodinní pøíslušníci mìstnancù (personalistika) ) SIZE(100,25) FILE(msprc_mo) ;
              GUILOOK(Action:y,IconBar:y) CARGO(PER_rodprisl_IN) OBDOBI(MZD)                               ;
              PRINTFILES(msprc_mo:noscisprac=noscisprac,                                                   ;
                         msodppol:noscisprac=noscisprac+nrok=nrok,                                         ;
                         mzddavit:noscisprac=noscisprac+nporpravzt=nporpravzt+cobdobi=cobdobi,             ; 
                         vykazw:cgrpkey=ccpppv)


* TYPE(Action) CAPTION(~Osoba)      EVENT(mzd_osobakmen_crd)     TIPTEXT(Poøízení a oprava údajù o osobì)
* TYPE(Action) CAPTION(~Rodpøísl)   EVENT(mzd_rodprisl_in)       TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(d~Uchody)    EVENT(mzd_duchody_in)        TIPTEXT(Evidované dùchody)
* TYPE(Action) CAPTION(prac~Kal)    EVENT(mzd_prackalendar_in)   TIPTEXT(Pracovní kalendáø-odpracovaná doba)
* TYPE(Action) CAPTION(doc~Házka)   EVENT(mzd_dochazkadny_in)    TIPTEXT(Docházka do zamìstnání)
* TYPE(Action) CAPTION(~Prùmìry)    EVENT(mzd_prumerykmen_crd)   TIPTEXT(Prùmìry pro náhrady a nemoc)
* TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøizení dokladù o mzdì)
* TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)



*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
TYPE(DBrowse) FPOS(0.75,1.40) SIZE(98.5,10.65) FILE(MSPRC_MO)    ;
              POPUPMENU(y) INDEXORD(9) RESIZE(yy)                ;
               FIELDS( M->ind_staVypCM::2.4::2, ;
                       M->is_Stavem::2.4::2   , ;
                       cDruPraVzt,              ;
                       nOsCisPrac,              ;
                       nPorPraVzt,              ;
                       cJmenoRozl:Pøíjmení_jméno a rozlišení pracovníka:30,  ;
                       nTypPraVzt,              ;
                       nTypZamVzt,              ;
                       cKmenStrPr,              ;
                       dDatNast,                ;
                       dDatPredVy,              ;
                       dDatVyst,                ;
                       nTypUkoPrv,              ;
                       ncisOsoby,               ;   
                       nROK,                    ;                         
                       nOBDOBI  )               ;
                CURSORMODE(3) PP(7) STABLEBLOCK(stableBlock) 


* 1 - rodinní pøíslušníci  --> OSOBY -> VAZOSOBY 
TYPE(TabPage) TTYPE(4) CAPTION(RodPøíslušníci) OFFSET(1,85) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,10.9) RESIZE(YX)
    TYPE(DBrowse) FPOS(-0.3,0.2) SIZE(97.25,10.8) FILE(vazOsoby)                                   ;
                                          RESIZE(yx)                            ;
                                FIELDS( vazOsoby_osoby_Rp('ncisOsoby'):èíslOsoby                , ;
                                        vazOsoby_osoby_Rp('cjmenoRozl'):Pøímení a jméno osoby:30, ;
                                        vazOsoby->ctypRodPri:typVztahu                          , ;
                                        vazOsoby_osoby_Rp('cjmenoRod'):rozen(á)                , ;
                                        vazOsoby_osoby_Rp('crodCisOsb'):rodÈíslo                , ;
                                        vazOsoby_osoby_Rp('ddatNaroz'):datNaroz                 , ;   
                                        vazOsoby_osoby_Rp('CMISTO'):Mìsto:25                    , ;
                                        vazOsoby_osoby_Rp('CZKRATSTAT'):Stát                      ) ;
                                        CURSORMODE(3) PP(7) SCROLL(yy)

  TYPE(End)
TYPE(End) 


* 2
TYPE(TabPage) TTYPE(4) CAPTION(OsobníÚdaje) OFFSET(14.9,12.5) FPOS(0.75,12.5) SIZE(98.5,12.25) RESIZE(yx)

    TYPE(TEXT) CAPTION(Rodné èíslo. . . .)         CPOS( 2, 0.40)   CLEN(17)
     TYPE(TEXT) NAME(osoby->crodCisOsb)            CPOS(20, 0.30)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodné jméno. . . .)         CPOS( 2, 1.45)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cjmenoRod)             CPOS(20, 1.35)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Datum narození. . . .)      CPOS( 2, 2.50)   CLEN(17)
     TYPE(TEXT) NAME(osoby->ddatNaroz)             CPOS(20, 2.40)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Místo narození. . .)        CPOS( 2, 3.55)   CLEN(17)
     TYPE(TEXT) NAME(osoby->cmistoNar)             CPOS(20, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Stát narození. . . .)       CPOS( 2, 4.60)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStatNa)            CPOS(20, 4.50)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Národnost . . . . .)        CPOS( 2, 5.65)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkratNar)             CPOS(20, 5.55)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Státní pøíslušnost . . .)   CPOS( 2, 6.70)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrStaPri)            CPOS(20, 6.60)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Rodinný stav . . .)         CPOS( 2, 7.75)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrRodStv)            CPOS(20, 7.65)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)  CPOS( 2, 8.80)   CLEN(17)
     TYPE(TEXT) NAME(osoby->czkrVzdel)             CPOS(20, 8.70)            BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Bydlištì ulice-è.p. . )     CPOS(48, 0.40)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cUlice)                CPOS(64, 0.30)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Psè-místo . .)              CPOS(54, 1.45)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cPsc)                  CPOS(64, 1.40)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cMisto)                CPOS(70, 1.40)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(stát . . )                  CPOS(54, 2.50)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkratStat)            CPOS(64, 2.40)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Pøe.bydl ulice-è.p. . )     CPOS(48, 3.55)   CLEN(15)
     TYPE(TEXT) NAME(osoby->cpreUlice)             CPOS(64, 3.45)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Psè-místo . .)              CPOS(54, 4.60)   CLEN(10)
     TYPE(TEXT) NAME(osoby->cprePsc)               CPOS(64, 4.50)            BGND(13) PP(2)
     TYPE(TEXT) NAME(osoby->cpreMisto)             CPOS(70, 4.50)   CLEN(25) BGND(13) PP(2)

    TYPE(TEXT) CAPTION(stát . . )                  CPOS(54, 5.65)   CLEN(10)
     TYPE(TEXT) NAME(osoby->czkrStatPr)            CPOS(64, 5.55)   CLEN(4)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(Telefon1/Telefon2 . .)      CPOS(48, 6.70)   CLEN(15)
     TYPE(TEXT) NAME(osoby->ctelPriv)              CPOS(64, 6.60)   CLEN(25) BGND(13) PP(2)

  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)


*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(74.50,0.09) SIZE(23.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)
