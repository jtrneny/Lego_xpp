TYPE(drgForm) DTYPE(10) TITLE(Kmenové údaje zamìstnancù) SIZE(100,26.5)      ;
              GUILOOK(Action:y,IconBar:y) CBSAVE(onSave) POST(postValidate)  ;
                                                         COMMFILES( msprc_mo:,        ; 
                                                                    tmhlassow: )    
*             CARGO(MZD_kmenove_CRD)

* TYPE(Action) CAPTION(~RodPøísl) EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


  TYPE(Static) STYPE(13) SIZE(98,4.2) FPOS(1,0.2) RESIZE(yn)

* 1. øádek
    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, .15) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, .15) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, .15) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, .15) CLEN(15)

    TYPE(GET)  NAME(msPrc_moW->cprijOsob)   FPOS( 1,1.13) FLEN(25) NOREVISION() FONT(5) PUSH(MZD_kmenove_SEL)
    TYPE(GET)  NAME(msPrc_moW->cjmenoOsob)  FPOS(28,1.13) FLEN(15) NOREVISION() FONT(5)
    TYPE(GET)  NAME(msPrc_moW->crozlJmena)  FPOS(45,1.13) FLEN(15) NOREVISION() FONT(5) 
    TYPE(GET)  NAME(msPrc_moW->ctitulPred)  FPOS(62,1.13) FLEN(15)
    TYPE(GET)  NAME(msPrc_moW->ctitulZa)    FPOS(81,1.13) FLEN(15)

* èíslo osoby
    TYPE(Text)  CAPTION([)                  CPOS( 8,2.05) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(msPrc_moW->ncisOsoby)  CPOS( 9,2.048) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
    TYPE(Text)  CAPTION(])                  CPOS(16,2.05) CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

* 2. øádek
    TYPE(TEXT) FCAPTION(OsÈís/Poø)           CPOS( 1,3.01)  CLEN( 8)
     TYPE(GET)  NAME(msPrc_moW->nosCisPrac)  FPOS( 9,3.01)   FLEN( 7) PP(2) FONT(5) CTYPE(2) NOREVISION()
     TYPE(TEXT) FCAPTION(/)                  CPOS(18,3.01)   CLEN( 2)
     TYPE(TEXT) NAME(msPrc_moW->nporPraVzt)  CPOS(18.6,2.53) CLEN(10) FONT(8) CTYPE(4) PP(2) GROUPS(SETFONT,12.Arial Black,GRA_CLR_RED)
*    TYPE(TEXT) FCAPTION(poøPpv)             CPOS(17,2.83)   CLEN( 6)
*    TYPE(TEXT) NAME(msPrc_moW->nporPraVzt)  CPOS(22,2.83)   CLEN( 8) PP(2) CTYPE(3) GROUPS(SETFONT,10.Arial Black,GRA_CLR_RED) 

    TYPE(TEXT) FCAPTION(kmenStøed)           CPOS(35,2.83) CLEN( 9)
     TYPE(GET)  NAME(msPrc_moW->ckmenStrPr)  FPOS(45,2.83) FLEN( 8) PP(2) FONT(5)
     TYPE(TEXT) NAME(cnazPol1->cnazev)       CPOS(54,2.83) CLEN(22) 

    TYPE(TEXT) FCAPTION(rodné Èíslo)         CPOS(81,2.05) CLEN(15)
     TYPE(GET)  NAME(msPrc_moW->crodCisPra)  FPOS(81,2.87) FLEN(15) PP(2) FONT(5)
  TYPE(End)


* 1_TAB kmenové (E)MSPRC_MOw*
TYPE(TabPage) TTYPE(4) CAPTION(Kmenové) OFFSET(1,84) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) SUBTABS(A2,A3,A4,A5) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,5.4) FPOS(1,0.2) RESIZE(yn)
    TYPE(TEXT) CAPTION(Druh PV. . . .)                      CPOS( 1.0, 0.44)  CLEN(12)

     TYPE(COMBOBOX) NAME(MSPRC_MOw->cDruPraVzt)              FPOS(13.0, 0.39)  FLEN(32) ;
           VALUES(  HLAVNI:HLAVNÍ pracovní vztah, +
                  VEDLEJSI:VEDLEJŠÍ pracovní vztah, +
                  HLAVSOUB:SOUBÌŽNÝ HLAVNÍ pracovní vztah, +
                  VEDLSOUB:SOUBÌZNÝ VEDLEJŠÍ pracovní vztah, +
                    DOHODA:DOHODA, +    
                  NEPRACPO:Neexistuje vazba na prac.vztah   )

    TYPE(TEXT) CAPTION(Vznik PV. . . .)                     CPOS(51.0, 0.44)  CLEN(12)
     TYPE(COMBOBOX) NAME(MSPRC_MOw->cVznPraVzt)              FPOS(63.0, 0.39)   FLEN(32) ;
           VALUES(PRAC.SML.:Pracovní smlouva,                               ;
                 JMENOVANIM:Jmenováním do funkce,                           ;
                     VOLBOU:Volbou do funkce,                               ;
                    DOHODOU:Dohodou,                                         ;
                 NEVYTVOREN:Nevytvoøen)

    TYPE(TEXT) CAPTION(Nástup OD. .)              CPOS( 1.0, 2.05)   CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatNast)           FPOS(13.0, 1.95)   FLEN(10.7)  PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(Typ PV. . . . . .)          CPOS(26.0, 2.05)   CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nTypPraVzt)         FPOS(39.0, 1.95)   FLEN(5)
     TYPE(TEXT) NAME(C_PRACVZ->cNazPraVzt)         CPOS(45.5, 1.95)   CLEN(27) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Vznik Od . . .)            CPOS(73, 2.05)     CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatVznPrV)         FPOS(83.7, 1.95)   FLEN(10.7)  PUSH(CLICKDATE)

    TYPE(TEXT) CAPTION(Výstup OD. .)              CPOS( 1.0, 3.10)   CLEN(10)
     TYPE(GET) NAME(MSPRC_MOw->dDatVyst)           FPOS(13.0, 3.00)   FLEN(10.7)  PUSH(CLICKDATE)
    TYPE(TEXT) CAPTION(Typ ukonè.PV. .)           CPOS(26.0, 3.10)   CLEN(12)
     TYPE(GET)  NAME(MSPRC_MOw->nTypUkoPrV)        FPOS(39.0, 3.00)   FLEN(5)
     TYPE(TEXT) NAME(C_UKONPV->cNazUkoPrV)         CPOS(45.5, 3.00)   CLEN(27) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Zkuš.doba v mìs.  )        CPOS(73, 3.10)     CLEN(10)
     TYPE(GET)  NAME(MSPRC_MOw->nZkusDoba)         FPOS(83.7, 3.0)   FLEN(10.7) 

    TYPE(TEXT) CAPTION(Pøed.ukonè.)               CPOS(73, 4.15)     CLEN(10)
     TYPE(GET)  NAME(MSPRC_MOw->dDatPredVy)        FPOS(83.7, 4.05)   FLEN(10.7)  PUSH(CLICKDATE)
  TYPE(End) 


  TYPE(TabPage) CAPTION(Zaøazení) OFSET(1,80) TABHEIGHT(0.8) FPOS(1.2,6.90) SIZE(55.2,14.4) PRE(tabSelect) SUB(A2) RESIZE(yy)
 
    TYPE(STATIC) STYPE(13) FPOS(.2,0.1) SIZE(54.2,13.2)

      TYPE(TEXT) CAPTION(Zamìstnanecký vzt. . .)    CPOS( 1.0, 0.70)   CLEN(17)
       TYPE(GET) NAME(MSPRC_MOw->nTypZamVzt)         FPOS(19.0, 0.60)   FLEN(5)
       TYPE(TEXT) NAME(C_ZAMEVZ->cNazZamVzt)         CPOS(25.5, 0.60)   CLEN(29) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Typ evidenè.stavu.  . .)   CPOS( 1.0, 1.75)   CLEN(17)
       TYPE(GET)  NAME(MSPRC_MOw->nMimoPrVzt)        FPOS(19.0, 1.65)   FLEN(5)  PUSH(MZD_mimoprvz_CRD) CTYPE(2)
      TYPE(TEXT) NAME(C_MIMPRV->cNazMimPrV)         CPOS(25.5, 1.65)   CLEN(29) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Mzdová kategorie  . . .)   CPOS( 1.0, 2.80)   CLEN(17)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->cMzdKatPra)      FPOS(19.0,2.70)  FLEN(35) ;
           VALUES(DELNIK:Dìlník,                                                ;
                     THP:Techn.hospod.pracovník,                                ;
                 REZIJNI:Režijní pracovník,                                     ;
                        :Nezaøazen)
      TYPE(TEXT) CAPTION(Pracovní zaøazení . . .)   CPOS( 1.0, 3.85)   CLEN(17)
       TYPE(GET)  NAME(MSPRC_MOw->cPracZar)          FPOS(19.0, 3.75)   FLEN(10)
       TYPE(TEXT) NAME(C_PRACZA->cNazPracZa)         CPOS(30.5, 3.75)   CLEN(24) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Funkce pracovníka . . .)   CPOS( 1.0,4.90)   CLEN(17)
       TYPE(GET)  NAME(MSPRC_MOw->cFunPra)           FPOS(19.0,4.80)   FLEN(10)
       TYPE(TEXT) NAME(C_FUNCPR ->cNazFuncPr)        CPOS(30.5,4.80)   CLEN(24) BGND(13) PP(3)



      TYPE(TEXT) CAPTION(Organizaèní úsek   . . .)    CPOS( 1.0,6.95)  CLEN(15)
       TYPE(GET)  NAME(MSPRC_MOw->cOrgUsek)           FPOS(19.0,6.85)   FLEN(10)
       TYPE(TEXT) NAME(C_ORGUSEK ->cNazev)            CPOS(30.5,6.85)   CLEN(24) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Pracovištì . . . . . .)    CPOS( 1.0,8.00)  CLEN(15)
       TYPE(GET)  NAME(MSPRC_MOw->cNazPol4)          FPOS(19.0,7.90)   FLEN(10)
       TYPE(TEXT) NAME(CNAZPOL4 ->cNazev)            CPOS(30.5,7.90)   CLEN(24) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Náklad.støedisko . .)      CPOS( 1.0,9.05)   CLEN(15)
       TYPE(GET)  NAME(MSPRC_MOw->cNazPol1)          FPOS(19.0,8.95)   FLEN(10)
       TYPE(TEXT) NAME(CNAZPOL1 ->cNazev)            CPOS(30.5,8.95)   CLEN(24) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Výplatní místo . )         CPOS( 1.0,10.10)   CLEN(17)
       TYPE(GET)  NAME(MSPRC_MOw->cVyplMist)         FPOS(19.0,10.00)   FLEN(10)
       TYPE(TEXT) NAME(C_VYPLMI ->cNazVyplMi)        CPOS(30.5,10.00)   CLEN(24) BGND(13) PP(3)
      TYPE(TEXT) CAPTION(Typ dùchodu . . . . . . .) CPOS( 1.0,11.15)   CLEN(17)
       TYPE(GET)  NAME(MSPRC_MOw->nTypDuchod)        FPOS(19.0,11.05)   FLEN(5)  PUSH(MZD_duchody_CRD) CTYPE(2)
       TYPE(TEXT) NAME(C_DUCHOD->cNazDuchod)         CPOS(25.5,11.05)   CLEN(29) BGND(13) PP(3)

    TYPE(End) 

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End) 



  TYPE(TabPage) CAPTION(Daò) OFFSET(15.9,69) TABHEIGHT(0.8) FPOS(1.2,6.90) SIZE(55.2,14.4) PRE(tabSelect) SUB(A3) RESIZE(yy)
    TYPE(STATIC) STYPE(13) FPOS(.2,0.1) SIZE(54.2,13.2)
     TYPE(TEXT) CAPTION(Danit prac.vztah . . . .)  CPOS( 1.0,0.70)   CLEN(17)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->lDanPrVzt)     FPOS(23.0,0.60)   FLEN( 8)  REF( LYESNO) 
     TYPE(TEXT) CAPTION(Podepsal daò.prohl. . . .) CPOS( 1.0,1.75)   CLEN(17)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->lDanProhl)     FPOS(23.0,1.65)   FLEN( 8)  REF( LYESNO) 
     TYPE(TEXT) CAPTION(Daòový rezident. . . . .)  CPOS( 1.0,2.80)   CLEN(17)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->lDanRezid)     FPOS(23.0,2.70)   FLEN( 8)  REF( LYESNO) 
     TYPE(TEXT) CAPTION(Výpoèet roèní danì . . .)  CPOS( 1.0,3.85)   CLEN(17)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->lDanVypoc)     FPOS(23.0,3.75)   FLEN( 8)  REF( LYESNO) 


      TYPE(STATIC) FPOS(1.2,8.6) SIZE(52.8, 4) CAPTION( Odpoèitatelné položky ) FONT(5) RESIZE(xx)
        TYPE(TEXT) CAPTION( období                            rok )         CPOS( 22, 0.8) CLEN(20) 
        TYPE(TEXT) CAPTION(Slevy a odpoèty na dani...)         CPOS( 1  ,1.8)   CLEN(13.5)
          TYPE(GET)  NAME(MSPRC_MOw->nOdpocObd)         FPOS(22.5,1.8)   FLEN(10) PUSH(MZD_odpocpol_CRD) CTYPE(2)
          TYPE(TEXT) NAME(MSPRC_MOw->nOdpocRok)         CPOS(39  ,1.8)   CLEN(10) BGND(9) PP(3) CTYPE(2)

        TYPE(TEXT) CAPTION(Daòová úleva ...)            CPOS( 1  ,3)   CLEN(13.5)
          TYPE(TEXT) NAME(MSPRC_MOw->nDanUlObd)         CPOS(22.5,3)   CLEN(11) BGND(9) PP(3) CTYPE(2)
          TYPE(TEXT) NAME(MSPRC_MOw->nDanUlRok)         CPOS(39  ,3)   CLEN(10) BGND(9) PP(3) CTYPE(2)
      TYPE(End)

    TYPE(End) 

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End) 


  TYPE(TabPage) CAPTION(Zdravotní) OFFSET(30.8,52) TABHEIGHT(0.8) FPOS(1.2,6.90) SIZE(55.2,14.4) PRE(tabSelect) SUB(A4) RESIZE(yy)
    TYPE(STATIC) STYPE(13) FPOS(.2,0.1) SIZE(54.2,13.2)

      TYPE(TEXT) CAPTION(Zdravotnì pojištìn . . .)  CPOS( 1.0,0.70)   CLEN(17)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->lZdrPojis)     FPOS(19.0,0.60)   FLEN( 8)  REF( LYESNO) 

      TYPE(TEXT) CAPTION(Zdrav.pojišovna . . . .)  CPOS( 1.0,2.30)   CLEN(17)
       TYPE(GET) NAME(MSPRC_MOw->nZdrPojis)          FPOS(19.0,2.20)   FLEN( 5)
       TYPE(TEXT) NAME(C_ZDRPOJ->cNazZdrPoj)         CPOS(25.5,2.20)   CLEN(29) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Èíslo pojištìnce . . . .)  CPOS( 1.0,3.45)   CLEN(17)
       TYPE(GET) NAME(MSPRC_MOw->nZdrPojCP)          FPOS(19.0,3.35)   FLEN(12)

      TYPE(TEXT) CAPTION(Dopoè.zdr.poj.do min. .)   CPOS( 1.0,4.50)   CLEN(17)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->nZdrPojDop)    FPOS(19.0,4.40)   FLEN(35)  ;
           VALUES(0:Neprovádí se,                                                ;
                  1:Odvede jen organizace,                                       ;
                  2:Odvede jen pracovník,                                        ;
                  3:Odvede pracovník i organizace,                               ;
                  4:Odvede prac.za org.srážka ze mzdy)
      TYPE(TEXT) CAPTION(Dopoè.zdr.poj.z NV a ABS.)   CPOS( 1.0,5.55)   CLEN(17)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->nZdrPojNVA)    FPOS(19.0,5.45 )   FLEN(35)  ;
           VALUES(0:Neprovádí se,                                                 ;
                  1:Provádí se)

    TYPE(End) 

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End) 


  TYPE(TabPage) CAPTION(Sociální) OFFSET(46.9,34) TABHEIGHT(0.8) FPOS(1.2,6.90) SIZE(55.2,14.4) PRE(tabSelect) SUB(A5) RESIZE(yy)
    TYPE(STATIC) STYPE(13) FPOS(.2,0.1) SIZE(54.2,13.2)
      TYPE(TEXT) CAPTION(Sociálnì pojištìn ...)       CPOS( 1, .7)   CLEN(20)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->lSocPojis)      FPOS(21, .6)   FLEN( 8)  REF( LYESNO) 
 
      TYPE(TEXT) CAPTION(Dùchodové spoø.2 pil ...)    CPOS( 1,2  )   CLEN(20)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->lDuchSp2Pi)     FPOS(21,2  )   FLEN( 8)  REF( LYESNO) 

      TYPE(TEXT) CAPTION(Druh èinnosti pro ÈSSZ ...)  CPOS( 1,3.4)  CLEN(20)
       TYPE(GET) NAME(MSPRC_MOw->ctypPPVreg)          FPOS(21,3.4)  FLEN( 7) 
       TYPE(TEXT) NAME(c_prvzDC->cnazDRUcin)          CPOS(30,3.4)  CLEN(25) BGND(13) PP(3) 

      TYPE(TEXT) CAPTION(Èíslo pojištìnce . . . .)    CPOS( 1.0,4.8)   CLEN(17)
       TYPE(GET) NAME(MSPRC_MOw->cSocPojCP)           FPOS(21.0,4.8)   FLEN(20)
 
      TYPE(TEXT) CAPTION(Zpùsob odvodu soc.poji)      CPOS( 1.0,6.20)   CLEN(17)
       TYPE(COMBOBOX) NAME(MSPRC_MOw->nSocPojOdv)     FPOS(21.0,6.20)   FLEN(32)  ;
           VALUES(0:Odvádí se vše,                                                ;
                  1:Odvede se jen za organizaci,                                  ;
                  2:Odvede se jen za pracovníka)
 
    TYPE(End) 
    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End) 


  TYPE(Static) STYPE(13) SIZE(39.5,14.2) FPOS(56.5,6.0) RESIZE(y)
*    TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanProhl)       FPOS(1.0,0.25)    FLEN(19) ;
*        VALUES(T:podepsal daò.prohl.,F:podepsal daò.prohl.)            GROUP(12)
*    TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanPrVzt)       FPOS(1.0,1.25)    FLEN(19) ;
*        VALUES(T:danit prac.vztah,F:danit prac.vztah)                  GROUP(12)
*    TYPE(CHECKBOX) NAME(MSPRC_MOw->lDanRezid)       FPOS(1.0,2.25)    FLEN(19) ;
*          VALUES(T:daòový rezident,F:daòový rezident)                    GROUP(12)

     TYPE(CHECKBOX) NAME(MSPRC_MOw->lZamMalRoz)      FPOS(1.0,0.25)    FLEN(19) ;
          VALUES(T:zam.mal.rozsahu,F:zam.mal.rozsahu)                    GROUP(12)
*      TYPE(CHECKBOX) NAME(MSPRC_MOw->lZamKratko)      FPOS(1.0,1.25)    FLEN(19) ;
*          VALUES(T:krátkodobé zam.,F:krátkodobé zam.)                    GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lStatuZast)      FPOS(1.0,1.25)    FLEN(19) ;
          VALUES(T:statutární zástupce,F:statutární zástupcem)           GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lStudent)        FPOS(1.0,2.25)    FLEN(19) ;
          VALUES(T:student,F:student)                                    GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lOdborar)        FPOS(1.0,3.25)    FLEN(19) ;
          VALUES(T:èlen odborù,F:èlen odborù)                            GROUP(12)
*      TYPE(CHECKBOX) NAME(MSPRC_MOw->lDuchSp2Pi)      FPOS(1.0,5.25)    FLEN(19) ;
*          VALUES(T:dùchodové spoø.2 pil.,F:dùchodové spoø.2 pil.)        GROUP(12)


     TYPE(CHECKBOX) NAME(MSPRC_MOw->lVypCisMzd)      FPOS(20.0,0.25)   FLEN(19) ;
          VALUES(T:zpracovat èist.mzdu,F:zpracovat èist.mzdu)            GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypCM)      FPOS(20.0,1.25)   FLEN(19) ;
          VALUES(T:zapnut aut.vyp.ÈM,F:zapnut aut.vyp.ÈM)                GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypHM)      FPOS(20.0,2.25)   FLEN(19) ;
          VALUES(T:zapnut aut.vyp.HM,F:zapnut aut.vyp.HM)                GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lAutoVypPR)      FPOS(20.0,3.25)   FLEN(19) ;
          VALUES(T:poèítat prùmìry,F:poèítat prùmìry)                    GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lTiskMzdLi)      FPOS(20.0,4.25)   FLEN(19) ;
          VALUES(T:zpracovat mzd.list,F:zpracovat mzd.list)              GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lGenerELDP)      FPOS(20.0,5.25)   FLEN(19) ;
          VALUES(T:generovat ELDP,F:generovat ELDP)                      GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lZaokrNa10)      FPOS(20.0,6.25)    FLEN(19) ;
          VALUES(T:zaokrouhlovat na 10,F:zaokrouhlovat na 10)            GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lImportDoc)      FPOS(20.0,7.25)    FLEN(19) ;
          VALUES(T:import do docházky,F:importov.do docházky)            GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lExport)         FPOS(20.0,8.25)    FLEN(19) ;
          VALUES(T:import z výroby,F:import z výroby)                    GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lTiskKontr)      FPOS(20.0,9.25)   FLEN(19) ;
          VALUES(T:tisknout kontrolku,F:tisknout kontrolku)              GROUP(12)
     TYPE(CHECKBOX) NAME(MSPRC_MOw->lObedy)          FPOS(20.0,10.25)   FLEN(19) ;
          VALUES(T:sledovat obìdy,F:sledovat obìdy)                      GROUP(12)

  TYPE(End)

TYPE(End) 


* 6_TAB mzdové (E)MSPRC_MOw (EB)MSTARINDw (EB)MSSAZZAMw*
TYPE(TabPage) TTYPE(4) CAPTION(Mzdové) OFFSET(15,70) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect)  SUBTABS(A7,A8,A9) RESIZE(yy)

  TYPE(TabPage) CAPTION(ZákladMzdy) OFSET(1,85) TABHEIGHT(0.9) FPOS(0.8,1.50) SIZE(97,19.8) PRE(tabSelect) SUB(A7) RESIZE(yy)

*  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yn)
    TYPE(TEXT) CAPTION(Pracovní kalenáø. .)       CPOS( 1.0, 0.25)   CLEN(15)
     TYPE(GET) NAME(MSPRC_MOw->cTypPraKal)        FPOS(16.0, 0.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACKA->cNazPraKal)        CPOS(37.5, 0.20)   CLEN(58) BGND(13) PP(3)
    TYPE(TEXT) CAPTION(Pracovní doba. . . .)      CPOS( 1.0, 1.30)   CLEN(15)
     TYPE(GET) NAME(MSPRC_MOw->cDelkPrDob)         FPOS(16.0, 1.20)   FLEN(20)
     TYPE(TEXT) NAME(C_PRACDO->cNazDelPrD)         CPOS(37.5, 1.20)   CLEN(58) BGND(13) PP(3)
*    TYPE(TEXT) CAPTION(Pracovní smìny. . .)       CPOS( 1.0, 1.30)   CLEN(15)
*     TYPE(GET) NAME(MSPRC_MOw->cTypSmeny)          FPOS(16.0, 1.20)   FLEN(20)
*     TYPE(TEXT) NAME(C_PRACSM->cNazSmeny)          CPOS(37.5, 1.20)   CLEN(35) BGND(13) PP(3)
*    TYPE(TEXT) CAPTION(Pracovní doba. . . .)      CPOS( 1.0, 2.35)   CLEN(15)
*     TYPE(GET) NAME(MSPRC_MOw->cDelkPrDob)         FPOS(16.0, 2.25)   FLEN(20)
*     TYPE(TEXT) NAME(C_PRACDO->cNazDelPrD)         CPOS(37.5, 2.25)   CLEN(35) BGND(13) PP(3)


    TYPE(EBrowse) FPOS(0.35,2.45) SIZE(95.5,5.0) FILE(MSTARINDw)  RESIZE(yx) ;
                   CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1) GUILOOK(sizecols:n,headmove:n)

      TYPE(COMBOBOX) NAME(mstarindW->ctyptarpou)   FLEN(18) CAPTION(Typ tarifu)  ;
            VALUES(NEPOUZIV:Tarify se nepoužívají,           ;
                   INDIVIDU:Individuální tarif,              ;
                   HROMADNY:Hromadný tarif        )
      TYPE(COMBOBOX) NAME(mstarindW->ctyptarMzd)   FLEN(10)  ;
            VALUES(CASOVA:jen hodinová sazba,                ;
                   MESICNI:mìsíèní sazba se svátky,          ;
                   MESICNIb:mìsíèní bez svátkù,              ;
                   SMISENA:hodinová i mìsíèní,               ; 
                   UKOLOVA:úkolová mzda,                     ;
                   DOHODA:mzda dohodou,                      ;  
                   SMLUVNI:mzda stanovena smlouvou           )
      TYPE(GET)  NAME(mstarindW->dplattarod) FLEN(10)
      TYPE(GET)  NAME(mstarindW->ctariftrid) FLEN(5)  FCAPTION(Tøída)
      TYPE(GET)  NAME(mstarindW->ctarifstup) FLEN(5)  FCAPTION(Stupn)
      TYPE(GET)  NAME(mstarindW->cdelkprdob) FLEN(18)
      TYPE(GET)  NAME(mstarindW->ntarsazhod) FLEN(10)  FCAPTION(HodSaz)   
      TYPE(GET)  NAME(mstarindW->ntarsazmes) FLEN(9)  FCAPTION(MìsSaz) 
    TYPE(END)


    TYPE(EBrowse) FPOS(0.35,7.35) SIZE(95.5,5) FILE(MSSAZZAMw)  RESIZE(yx)    ;
                    CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1) GUILOOK(sizecols:n,headmove:n)

      TYPE(COMBOBOX) NAME(mssazzamW->ctypsazby)   FLEN(39)                  ;
            VALUES(PRCPREHLCI:Procento prémií v hlavní èinnosti,            ;
                   SAZOSOOHOD:Sazba osobního ohodnocení,                    ;
                   PRCPODNAHV:Procento podílu na HV,                        ;
                   HODPOVPRES:Hodiny povolené u pøesèasù        )
      TYPE(GET)  NAME(mssazzamW->dplatsazod)      FLEN(10)
      TYPE(GET)  NAME(mssazzamW->cdelkprdob)      FLEN(28)
      TYPE(GET)  NAME(mssazzamW->nsazba)          FLEN(14)
    TYPE(END)

*    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)

  TYPE(END)


  TYPE(TabPage) CAPTION(Dovolená) OFFSET(14.9,72) TABHEIGHT(0.9) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A8) RESIZE(yy)

    TYPE(TEXT) CAPTION(Nárok na dovolenou v týdnech)      CPOS( 1.0,0.20)  CLEN(30)
     TYPE(GET) NAME(MSPRC_MOw->nTDoBezNar)         FPOS(35.0,0.20)    FLEN(8) PICTURE(99999.9)

    TYPE(TEXT) CAPTION(-------------------------------  Hodiny  -------------------------------)  CPOS( 1.0, 1.4)  CLEN(43)
    TYPE(TEXT) CAPTION(Dovolená zákonná      nárok    krác.    èerp.o   èerp.r    zùst. )  CPOS( 1.0, 2.2)  CLEN(43)
    TYPE(TEXT) CAPTION(pøevod z roku)             CPOS( 3.0, 3.00)  CLEN(12)
    TYPE(TEXT) CAPTION(bìžný rok)                 CPOS( 3.0, 3.95)  CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nHDoMinNar)         FPOS(16.0,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoMinCeO)         FPOS(27.0,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoMinCeR)         FPOS(32.5,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoMinZus)         FPOS(38.5,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoBezNar)         FPOS(16.0,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoBezKra)         FPOS(21.5,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoBezCeO)         FPOS(27.0,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoBezCeR)         FPOS(32.5,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoBezZus)         FPOS(38.5,4.25)    FLEN(4) PICTURE(999.9)

    TYPE(TEXT) CAPTION(Dodatková)                 CPOS( 1.0,5.35)  CLEN(15)
    TYPE(TEXT) CAPTION(pøevod z roku)             CPOS( 3.0,6.25)  CLEN(12)
    TYPE(TEXT) CAPTION(bìžný rok)                 CPOS( 3.0,7.3)  CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nHDDMinNar)         FPOS(16.0,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDMinCeO)         FPOS(27.0,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDMinCeR)         FPOS(32.5,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDMinZus)         FPOS(38.5,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDBezNar)         FPOS(16.0,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDBezKra)         FPOS(21.5,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDBezCeO)         FPOS(27.0,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDBezCeR)         FPOS(32.5,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDDBezZus)         FPOS(38.5,7.10)    FLEN(4) PICTURE(999.9)
    TYPE(TEXT) CAPTION(Dovolená celkem)           CPOS( 1.0,8.60)  CLEN(15)
     TYPE(GET) NAME(MSPRC_MOw->nHDoNaroCe)         FPOS(16.0,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoKracCe)         FPOS(21.5,8.60)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoCerOCe)         FPOS(27.0,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoCerRCe)         FPOS(32.5,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nHDoZustCe)         FPOS(38.5,8.60)   FLEN(4) PICTURE(999.9)


    TYPE(TEXT) CAPTION(-------------------------------     Dny    -------------------------------)  CPOS( 51.0, 1.4)  CLEN(43)
    TYPE(TEXT) CAPTION(Dovolená zákonná      nárok    krác.    èerp.o   èerp.r    zùst. )  CPOS( 51.0, 2.2)  CLEN(43)
    TYPE(TEXT) CAPTION(pøevod z roku)             CPOS(53.0, 3.00)  CLEN(12)
    TYPE(TEXT) CAPTION(bìžný rok)                 CPOS(53.0, 3.95)  CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nDovMinNar)         FPOS(66.0,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovMinCeO)         FPOS(77.0,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovMinCeR)         FPOS(82.5,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovMinZus)         FPOS(88.5,3.20)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovBezNar)         FPOS(66.0,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovBezKra)         FPOS(71.5,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovBezCeO)         FPOS(77.0,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovBezCeR)         FPOS(82.5,4.25)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovBezZus)         FPOS(88.5,4.25)    FLEN(4) PICTURE(999.9)

    TYPE(TEXT) CAPTION(Dodatková)                 CPOS(51.0,5.35)  CLEN(15)
    TYPE(TEXT) CAPTION(pøevod z roku)             CPOS(53.0,6.25)  CLEN(12)
    TYPE(TEXT) CAPTION(bìžný rok)                 CPOS(53.0,7.3)  CLEN(12)
     TYPE(GET) NAME(MSPRC_MOw->nDoDMinNar)         FPOS(66.0,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDMinCeO)         FPOS(77.0,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDMinCeR)         FPOS(82.5,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDMinZus)         FPOS(88.5,6.05)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDBezNar)         FPOS(66.0,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDBezKra)         FPOS(71.5,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDBezCeO)         FPOS(77.0,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDBezCeR)         FPOS(82.5,7.10)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDoDBezZus)         FPOS(88.5,7.10)    FLEN(4) PICTURE(999.9)
    TYPE(TEXT) CAPTION(Dovolená celkem)           CPOS(51.0,8.60)  CLEN(15)
     TYPE(GET) NAME(MSPRC_MOw->nDovNaroCe)         FPOS(66.0,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovKracCe)         FPOS(71.5,8.60)    FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovCerOCe)         FPOS(77.0,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovCerRCe)         FPOS(82.5,8.60)   FLEN(4) PICTURE(999.9)
     TYPE(GET) NAME(MSPRC_MOw->nDovZustCe)         FPOS(88.5,8.60)   FLEN(4) PICTURE(999.9)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)

  TYPE(END)

  TYPE(TabPage) CAPTION(Prùmìry) OFFSET(27.8,59) TABHEIGHT(0.9) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A9) RESIZE(yy)
    TYPE(TEXT) CAPTION(Algoritmus výpoètu pravdìpodobného prùmìru)   CPOS( 3.0,0.42)  CLEN(35)
     TYPE(COMBOBOX)   NAME(MSPRC_MOw->nalgPraPru)             FPOS(4,1.40) FLEN(32) VALUES(0:(0) neprovádí se,   ;
                                                                                             1:(1) z tarifu,       ;
                                                                                             2:(2) z hrubé mzdy,   ;
                                                                                             3:(3) z minulého období )

    TYPE(TEXT) CAPTION(Algoritmus nápoètu celoroèních odmìn)   CPOS( 3.0,2.62)  CLEN(35)
     TYPE(COMBOBOX)   NAME(MSPRC_MOw->nalgCelOdm)             FPOS(4,3.60) FLEN(32) VALUES(0:(0) bez nápoètu,                       ;
                                                                                          1:(1) minulý rok,                        ;
                                                                                          2:(2) druhé pololetí minulého roku,      ;
                                                                                          3:(3) o rok zpìt,                        ;
                                                                                          4:(4) Q1=-10_-12 Q2_4=-10_9,             ;
                                                                                          5:(5) Q1_3=-1-12 Q4=1_12,                ;
                                                                                          6:(6) Q1=-7_-12 Q2=-10_3 Q3=1_6 Q4=4_9,  ;
                                                                                          7:(7) Q1_2=-10_-12 Q3_4=1_9,	           ;
                                                                                          8:(8) Q1_2=-07_-12 Q3_4=1_6	 )
     TYPE(COMBOBOX)   NAME(MSPRC_MOw->npocMesPr)               FPOS(4,5.00) FLEN(32) VALUES( 1:( 1) jeden mìsíc,     ;
                                                                                               2:( 2) dva mìsíce,      ;                                                                                                                                               3:( 3) tøi mìsíce,      ;
                                                                                               4:( 4) ètyøi mìsíce,    ;
                                                                                               5:( 5) pìt mìsícù,      ;
                                                                                               6:( 6) šest mìsícù,     ;
                                                                                               7:( 7) sedm mìsícù,     ;
                                                                                               8:( 8) osm mìsícù,      ;
                                                                                               9:( 9) devìt mìsícù,    ;
                                                                                              10:(10) deset mìsícù,    ;
                                                                                              11:(11) jedenáct mìsícù, ;
                                                                                              12:(12) dvanáct mìsícù )



    TYPE(TEXT) CAPTION(Prùmìr HOD/DEN)          CPOS( 45, 0.42)  CLEN(13)
    TYPE(TEXT) NAME(msvPrumw->nHodPrumPP)          CPOS( 46,1.55)  CLEN(11) PP(2) BGND(12) GROUPS(SETFONT,9.Tahoma Bold,GRA_CLR_RED)
    TYPE(TEXT) NAME(msvPrumw->nDenPrumPP)          CPOS( 46,2.70)  CLEN(11) PP(2) BGND(12) GROUPS(SETFONT,9.Tahoma Bold,GRA_CLR_RED)


    TYPE(TEXT) CAPTION(Prùmìry na nemocenské dávky) CPOS( 59.0,0.42)  CLEN(25)
    TYPE(TEXT) CAPTION(DVZ)                       CPOS( 59.0,1.55)  CLEN( 4)
    TYPE(TEXT) CAPTION(hru)                       CPOS( 69.5,1.55)  CLEN( 4)
    TYPE(TEXT) CAPTION(krá)                       CPOS( 80.5,1.55)  CLEN( 4)
    TYPE(TEXT) CAPTION(èis)                       CPOS( 92.5,1.55)  CLEN( 4)
     TYPE(TEXT) NAME(msvPrumw->nDenVZhruN)          CPOS( 61  ,1.55)  CLEN(10) GROUPS(SETFONT,8.Tahoma Bold,GRA_CLR_BLUE)
     TYPE(TEXT) NAME(msvPrumw->nDenVZciKN)          CPOS( 72  ,1.55)  CLEN(10) GROUPS(SETFONT,8.Tahoma Bold,GRA_CLR_BLUE)
     TYPE(TEXT) NAME(msvPrumw->nDenVZcisN)          CPOS( 84  ,1.55)  CLEN(10) GROUPS(SETFONT,8.Tahoma Bold,GRA_CLR_BLUE)

    TYPE(TEXT) CAPTION(DEN)                       CPOS( 59.0,2.80)  CLEN(4)
    TYPE(TEXT) CAPTION(25%)                       CPOS( 69.5,2.70)  CLEN(4.5)
    TYPE(TEXT) CAPTION(69k%)                      CPOS( 80.5,2.70)  CLEN(5)
    TYPE(TEXT) CAPTION(69%)                       CPOS( 92.5,2.70)  CLEN(4.5)
     TYPE(TEXT) NAME(msvPrumw->nSazDenNiN)          CPOS( 62.5,2.70)  CLEN( 7) PP(2) BGND(12) GROUPS(SETFONT,9.Tahoma Bold,GRA_CLR_RED)
     TYPE(TEXT) NAME(msvPrumw->nSazDenVKN)          CPOS( 73.5,2.70)  CLEN( 7) PP(2) BGND(12) GROUPS(SETFONT,9.Tahoma Bold,GRA_CLR_RED)
     TYPE(TEXT) NAME(msvPrumw->nSazDenVyN)          CPOS( 85.5,2.70)  CLEN( 7) PP(2) BGND(12) GROUPS(SETFONT,9.Tahoma Bold,GRA_CLR_RED)

*    TYPE(STATIC) STYPE(16) FPOS( 1, 11.25) SIZE(94,1) 
*    TYPE(STATIC) STYPE(16) FPOS(15, 17.40) SIZE(29,1) 

*    TYPE(STATIC) STYPE(9) FPOS(58, 16.80) SIZE(0.2,3.2) 
*    TYPE(End)
    
*    TYPE(STATIC) STYPE(9)  FPOS(44, 12.50) SIZE(0.2,7.2) RESIZE(xx)
*    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)

  TYPE(END)


  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)

TYPE(End)


* 7_TAB mzdy   (E)msMzdyhdW  (E) msMzdyitW  -  matrice
TYPE(TabPage) TTYPE(4) CAPTION(Šablony) OFFSET(29,56) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,20) FPOS(1,0.2) RESIZE(yn)

    TYPE(EBrowse) FPOS(-.5,0.45) SIZE(96,5.7) FILE(msMzdyhdW)  ;
                                              INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) GUILOOK(sizecols:n,headmove:n) ;
                                              GROUPS(3) ITEMMARKED(itemMarked_msMzdyhdW)  
      TYPE(CHECKBOX) NAME(msMzdyhdW->lAktivni)           CLEN( 3) CAPTION(akt)              REF(LYESNO)
      TYPE(COMBOBOX) NAME(msMzdyhdW->cTypMasky)          FLEN(23) ;
             VALUES( MZMAS:MZMAS mzdová maska,         ;
                     AUVYH:AUVYH aut.výpoè.hrubé mzdy, ;
                     AUVYC:AUVYC aut.výpoè.èisté mzdy, ;
                     AUGED:AUGED aut.gen.dok.pøed ÈM,  ;
                     GENDO:GENDO generovaný doklad)
      TYPE(COMBOBOX) NAME(msMzdyhdW->cTypPohybu)         FLEN(15) ;
             VALUES( HRUBMZDA:hrubá mzda )
*      TYPE(CHECKBOX) NAME(msMzdyhdW->lautoVypHM)         CLEN( 3) CAPTION(aut)              REF(LYESNO)
      TYPE(TEXT)     NAME(msMzdyhdW->nkeyMatr)           CLEN( 8) CAPTION(poø)
      TYPE(GET)      NAME(msMzdyhdW->cnazMatr)           FLEN(30) CAPTION(název matrice pro poøízení)
      TYPE(GET)      NAME(msMzdyhdW->dPlatnosOd)         FLEN(14) CAPTION(Platnost OD)
      TYPE(GET)      NAME(msMzdyhdW->dPlatnosDo)         FLEN(14) CAPTION(Platnost DO)
    TYPE(END)
*                                              GROUPS(3) STABLEBLOCK(stableBlock)  


    TYPE(EBrowse) FPOS(-.5,7.1) SIZE(96,12.6) FILE(msMzdyitW) INDEXORD(1)  ;
                                              CURSORMODE(3) PP(7) ITEMMARKED(EdItemMarked) ;
                                              POSTVALIDATE(postValidate) POPUPMENU(n)

      TYPE(CHECKBOX) NAME(msMzdyitW->lAktivni)   FPOS( 1,0) CLEN( 3) CAPTION(akt)              REF(LYESNO)
      TYPE(GET)      NAME(msMzdyitW->nUcetMzdy)  FPOS( 2,0) FLEN( 6) FCAPTION(VnitÚèet) FONT(5) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol1)   FPOS( 3,0) FLEN( 6) FCAPTION(VýrStøed) FONT(5) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol2)   FPOS( 4,0) FLEN( 6) FCAPTION(Výkon   ) FONT(5) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol3)   FPOS( 5,0) FLEN( 6) FCAPTION(Zakázka ) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol4)   FPOS( 6,0) FLEN( 6) FCAPTION(VýrMísto) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol5)   FPOS( 7,0) FLEN( 6) FCAPTION(Stroj   ) 
      TYPE(GET)      NAME(msMzdyitW->cnazPol6)   FPOS( 8,0) FLEN( 6) FCAPTION(Oper    ) 
      TYPE(GET)      NAME(msMzdyitW->ndnyDoklad) FPOS( 9,0) FLEN( 5) FCAPTION(Dny     ) 
*      TYPE(GET)      NAME(msMzdyitW->dDatumOd)   FPOS(10,0) FLEN( 8) FCAPTION(DatOd   ) 
*      TYPE(GET)      NAME(msMzdyitW->dDatumDo)   FPOS(11,0) FLEN( 8) FCAPTION(DatDo   ) 
      TYPE(GET)      NAME(msMzdyitW->ndruhMzdy)  FPOS(12,0) FLEN( 6) FCAPTION(DrMzd   ) 
      TYPE(GET)      NAME(msMzdyitW->nsazbaDokl) FPOS(13,0) FLEN(10) CAPTION(Sazba    ) 
      TYPE(GET)      NAME(msMzdyitW->nhodDoklad) FPOS(14,0) FLEN( 8) CAPTION(Hodiny   ) 
      TYPE(GET)      NAME(msMzdyitW->nmnPDoklad) FPOS(15,0) FLEN(10)                    
      TYPE(GET)      NAME(msMzdyitW->nmzda)      FPOS(16,0) FLEN(10)                    
      TYPE(GET)      NAME(msMzdyitW->nPremie)    FPOS(17,0) FLEN( 5)                    
*      TYPE(GET)      NAME(msMzdyitW->ncisPrace)  FPOS(18,0) FLEN( 5)  vazba na c_kpraci ncisPrace je C4 ?                 
*      TYPE(GET)      NAME(msMzdyitW->nspotrPhm)  FPOS(19,0) FLEN( 5)
      TYPE(GET)      NAME(msMzdyitW->czkrNormy)  FPOS(20,0) FLEN( 5)
      TYPE(GET)      NAME(msMzdyitW->czkratJedn) FPOS(21,0) FLEN( 5)
      TYPE(GET)      NAME(msMzdyitW->dPlatnosOd) FPOS(22,0) FLEN(14) CAPTION(Platnost OD)
      TYPE(GET)      NAME(msMzdyitW->dPlatnosDo) FPOS(23,0) FLEN(14) CAPTION(Platnost DO)
    TYPE(END)
  TYPE(END)
TYPE(END)



* 8_TAB srážky (E)MSPRC_MOw (B)MSSRZ_MOw (E)MSSRZ_MOw *
TYPE(TabPage) TTYPE(4) CAPTION(Srážky) OFFSET(43,42) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) SUBTABS(A15,A16) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yy)
    TYPE(DBrowse) FPOS(-.7, .1) SIZE(42.00,19.40) FILE(MSSRZ_MOw) INDEXORD(1) RESIZE(yy)  ;
                  FIELDS( M->is_AktivSrz:as:2.6::2 , ;
                          nPorUplSrz:poøUpl        , ;
                          cZkrSrazky               , ;
                          nSplatka                 , ;
                          dDatOdSpl                , ;
                          dDatDoSpl                , ;
                          cUcet)                     ;
                CURSORMODE(3) PP(1) GROUPS(11)


  TYPE(Static) STYPE(2) FPOS(43.4,-0.2) SIZE(52.5,19.8)  RESIZE(nn)
    TYPE(GET) NAME(MSSRZ_MOw->cZkrSrazky)        FPOS( 13.5, 0.40)   FLEN(11) NOREVISION() FONT(5) FCAPTION(Typ srážky...) CPOS(0.5, .45) CLEN(13) 
      TYPE(TEXT) NAME(C_SRAZKY->cNazSrazky)      CPOS(26.0, 0.30)   CLEN(25.5) GROUPS(SETFONT,9.Arial,GRA_CLR_RED)

    TYPE(GET) NAME(MSSRZ_MOw->cPopSrazky)        FPOS(13.5, 1.40)   FLEN(37) FCAPTION(Popis srážky...) CPOS(0.5,1.5) CLEN(13)

    TYPE(TEXT) CAPTION(Aktivní srážka.)          CPOS(0.5, 2.85)   CLEN(12)
     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lAktivSrz)    FPOS(13.5, 2.75)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 
    TYPE(TEXT) CAPTION(Pøedn.pohl. .)            CPOS(0.5, 3.90)   CLEN(13)
     TYPE(COMBOBOX) NAME(MSSRZ_MOw->lPrednPohl)   FPOS(13.5, 3.80)   FLEN(7)      CPOS(1, 9) REF( LYESNO) 


    TYPE(GET) NAME(MSSRZ_MOw->dDatOdSpl)         FPOS(39.5, 2.75) FLEN(10.7) FCAPTION(Srážka_OD...)        CPOS(26.5,2.85) CLEN(13) PUSH(CLICKDATE)
    TYPE(GET) NAME(MSSRZ_MOw->dDatDoSpl)         FPOS(39.5, 3.80) FLEN(10.7) FCAPTION(Srážka_DO...)        CPOS(26.5,3.9)  CLEN(13) PUSH(CLICKDATE)


    TYPE(GET) NAME(MSSRZ_MOw->dDatDorVyk)        FPOS(13.5, 4.85) FLEN(10.7) FCAPTION(DatDoruèení...)      CPOS(0.5,4.85) CLEN(13) PUSH(CLICKDATE)

    TYPE(SpinButton) NAME(MSSRZ_MOw->nPorUplSrz) FPOS(39.5, 4.85) FLEN(10.7) FCAPTION(Poøadí uplSrážky...) CPOS(26.5,4.95) CLEN(13) LIMITS(1,90)

    TYPE(COMBOBOX) NAME(MSSRZ_MOw->nTypCastka)   FPOS(0.5, 6.2)  FLEN(12.5) VALUES( 1:Srážka v Kè,2:Srážka v %)
    TYPE(GET) NAME(MSSRZ_MOw->nSplatka)          FPOS(13.5, 6.2)  FLEN(10.7) FCAPTION(Celkem srážka) CPOS(26.5,6.2)    CLEN(13)
    TYPE(GET) NAME(MSSRZ_MOw->nCelkem)           FPOS(39.5, 6.1)  FLEN(10.7)
    
    TYPE(GET) NAME(msSrz_mow->nNedoplat)         FPOS(39.5, 7.1)  FLEN(10.7) FCAPTION(nedoplatek)    CPOS(26.5,7.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(msSrz_mow->nSplaceno)         FPOS(39.5, 8.1)  FLEN(10.7) FCAPTION(splaceno)      CPOS(26.5,8.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)
    TYPE(GET) NAME(msSrz_mow->nZustatek)         FPOS(39.5, 9.1)  FLEN(10.7) FCAPTION(zùstává)       CPOS(26.5,9.19) CLEN(10) GROUPS(SETFONT,7.Arial CE)

    TYPE(GEt) NAME(msSrz_mow->ddatZustat)        FPOS(13.5,  9)   FLEN(10.7) FCAPTION(Datum posZùst) CPOS(0.5,9) CLEN(12)  PUSH(CLICKDATE)  

    TYPE(STATIC) STYPE(16) FPOS( 0.2, 5.1) SIZE(52.0,1)
    TYPE(STATIC) STYPE(16) FPOS( 0.2, 9.3) SIZE(52.0,1)
*    TYPE(STATIC) STYPE(16) FPOS( 0.2, 17.0) SIZE(52.0,1)

    TYPE(TabPage) CAPTION(Základní) OFFSET( 1,77) TABHEIGHT(0.8) FPOS( .8, 10.5) SIZE(51,9.5) PRE(tabSelect) SUB(A15) RESIZE(yy) TTYPE(2)

      TYPE(GET) NAME(MSSRZ_MOw->cBank_Uct)         FPOS(12.8, 0.1) FLEN(23)   FCAPTION(ÚhradZÚètu.)   CPOS( .5, 0.1) CLEN(10)
      TYPE(TEXT) NAME(C_BANKUC->cBank_Naz)         CPOS(37.8, 0.1) CLEN(15)   GROUPS(SETFONT,7.Arial CE)

      TYPE(GET) NAME(MSSRZ_MOw->cUcetI)            FPOS(12.8, 1.2) FLEN(14)   FCAPTION(Bank úèet. .)  CPOS( 0.5, 1.2) CLEN(10)
      TYPE(GET) NAME(MSSRZ_MOw->cKodBanky)         FPOS(30.5, 1.2) FLEN( 6)   FCAPTION(/)             CPOS(28.8, 1.2) CLEN(1.8)
      TYPE(TEXT) NAME(C_BANKY->cNazBanky)          CPOS(37.8, 1.2) CLEN(15)   GROUPS(SETFONT,7.Arial CE)
    

      TYPE(GET) NAME(MSSRZ_MOw->cVarSym)           FPOS(12.8,  2.2) FLEN(14)   FCAPTION(VS-SS-KS)      CPOS( 0.5, 2.2) CLEN(10)
      TYPE(GET) NAME(MSSRZ_MOw->cSpecSymb)         FPOS(27.5,  2.2) FLEN(14)   FCAPTION(-)             CPOS(26.0, 2.2) CLEN(1.5)
      TYPE(GET) NAME(MSSRZ_MOw->nKonstSymb)        FPOS(43.5,  2.2) FLEN( 6)   FCAPTION(-)             CPOS(42.0, 2.2) CLEN(1.5)

      TYPE(TEXT) FCAPTION(Typ trvalého závazku     ...)         CPOS(  .5, 3.2) CLEN(10)
      TYPE(ComboBox) NAME(msSrz_moW->cPohZavFir)                FPOS(12.8, 3.22) FLEN(37) ;
                          VALUES(a,a,a,a,a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected) 


      TYPE(GET) NAME(MSSRZ_MOw->cZkrTypUhr)         FPOS(12.8,  4.2) FLEN(10)   FCAPTION(Typ úhrady)      CPOS(0.5,4.3)   CLEN(10)
      TYPE(TEXT) NAME(C_TYPUHR->cPopisUhr)          CPOS(25.0,  4.2) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

      TYPE(GET)  NAME(MSSRZ_MOw->cZpusSraz)         FPOS(12.8, 5.2) FLEN(10)   FCAPTION(Typ srážení.)     CPOS( .5,5.3)   CLEN(10)
      TYPE(TEXT) NAME(C_ZPUSRZ->cPopisZpSr)         CPOS(25.0, 5.2) CLEN(29)   GROUPS(SETFONT,8.Arial CE) 

      TYPE(GET)  NAME(MSSRZ_MOw->nDruhMzdy)         FPOS( 1, 7.5)   FLEN(10)   FCAPTION(Gen_DMZ_1)        CPOS( 1.6, 6.5)  CLEN(10)
      TYPE(GET)  NAME(MSSRZ_MOw->nDruhMzdy2)        FPOS(13, 7.5)   FLEN(10)   FCAPTION(Gen_DMZ_2)        CPOS(13.6, 6.5)  CLEN(10)
      TYPE(GET)  NAME(MSSRZ_MOw->nDruhMzdy3)        FPOS(26, 7.5)   FLEN(10)   FCAPTION(Gen_DMZ_3)        CPOS(26.6, 6.5)  CLEN(10)
      TYPE(GET)  NAME(MSSRZ_MOw->cUcet_UCT)         FPOS(39, 7.5)   FLEN(10)   FCAPTION(Úèet_zaúèt)       CPOS(40.5, 6.5)  CLEN(10)
    TYPE(End) 

    TYPE(TabPage) CAPTION(Doplòující) OFFSET(21,57) TABHEIGHT(0.8) FPOS( .8, 10.5) SIZE(51,9.5) PRE(tabSelect) SUB(A16) RESIZE(yy) TTYPE(2)
       TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End) 

   TYPE(End)
  TYPE(End)
 
TYPE(End)


* 9_TAB osobní OSOBYw*
TYPE(TabPage) TTYPE(4) CAPTION(Osobní) OFFSET(57,28) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) SUBTABS(A10,A11,A12) RESIZE(yy)

  TYPE(TabPage) CAPTION(Info_osoby) OFSET(1,85) TABHEIGHT(0.8) FPOS(0.8,1.50) SIZE(97,19.8) PRE(tabSelect) SUB(A10) RESIZE(yy)

    TYPE(Static) STYPE(13) SIZE(96,18.6) FPOS(.5,.2) RESIZE(yn)
      TYPE(TEXT) CAPTION(Rodné jméno. . . .)         CPOS( 1, 0.40)    CLEN(17)
       TYPE(GET) NAME(osobyW->cjmenoRod)             FPOS(19, 0.30)    FLEN(29)

      TYPE(TEXT) CAPTION(Datum narození. . . .)      CPOS( 1, 1.45)    CLEN(17)
       TYPE(GET) NAME(osobyW->ddatNaroz)             FPOS(19, 1.35)    FLEN(10.7)  PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Místo narození. . .)        CPOS( 1, 2.50)    CLEN(17)
       TYPE(GET) NAME(osobyW->cmistoNar)             FPOS(19, 2.40)    FLEN(29)

      TYPE(TEXT) CAPTION(Stát narození. . . .)       CPOS( 1, 3.55)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrStatNa)            FPOS(19, 3.45)    FLEN( 5)
       TYPE(TEXT) NAME(c_statyNar->cnazevStat)       CPOS(25.5,3.45)   CLEN(23.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Národnost . . . . .)        CPOS( 1, 4.60)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkratNar)             FPOS(19, 4.50)    FLEN(29)

      TYPE(TEXT) CAPTION(Státní pøíslušnost . . .)   CPOS( 1, 5.65)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrStaPri)            FPOS(19, 5.55)    FLEN(29)

      TYPE(TEXT) CAPTION(Rodinný stav . . .)         CPOS( 1, 6.70)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrRodStv)            FPOS(19, 6.60)    FLEN(11)
       TYPE(TEXT) NAME(C_RODSTA->cNazRodStv)         CPOS(31.5,6.60)   CLEN(17.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Nejvyší dosažené.vzdìl. .)  CPOS( 1, 7.75)    CLEN(17)
       TYPE(GET) NAME(osobyW->czkrVzdel)             FPOS(19, 7.65)    FLEN(11)
       TYPE(TEXT) NAME(C_VZDEL->cNazVzdela)          CPOS(31.5,7.65)   CLEN(17.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Individuální KZAM. .)       CPOS( 1, 8.80)    CLEN(17)
       TYPE(GET) NAME(osobyW->nklasZam)              FPOS(19, 8.70)    FLEN(8)
       TYPE(TEXT) NAME(C_KLAZAM->cNazKlasZa)         CPOS(28.5,8.70)  CLEN(20.6) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Ident.èís.osobní karty)     CPOS( 1, 10.90)   CLEN(17)
       TYPE(GET) NAME(osobyW->cIdOsKarty)            FPOS(19,10.80)    FLEN(29)

      TYPE(TEXT) CAPTION(Celkový poèet let praxe)    CPOS( 1, 11.95)  CLEN(17)
       TYPE(GET) NAME(osobyW->npocLPraxe)            FPOS(19,11.85)   FLEN(8)

      TYPE(TEXT) CAPTION(Evidovat DIM u pracovníka)  CPOS( 1,13.00)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->levidDIM)         FPOS(19,12.90)   FLEN(9)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Vedoucí pracovník)          CPOS( 1,14.05)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->lvedPrac)         FPOS(19,13.95)   FLEN(9)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Zdravotní znevýhodnìní)     CPOS( 1,15.10)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->lEvidovZZN)       FPOS(19,15.00)   FLEN(9)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Prùkaz postižení)           CPOS( 1,16.15)   CLEN(17)
       TYPE(COMBOBOX) NAME(msprc_moW->cPrukazZPS)    FPOS(19,16.05)   FLEN(30)     CPOS(1, 9) REF( cPRUKAZZPS) 

      TYPE(TEXT) CAPTION(Zdravotní postižení)        CPOS( 1,17.20)   CLEN(17)
       TYPE(COMBOBOX) NAME(osobyW->lEvidovZP)        FPOS(19,17.10)   FLEN(9)      CPOS(1, 9) REF( LYESNO) 

      TYPE(TEXT) CAPTION(Bydlištì ulice. . )         CPOS(50, 0.40)   CLEN(15)
       TYPE(GET) NAME(osobyW->cUlice)                FPOS(65, 0.30)    FLEN(29)

      TYPE(TEXT) CAPTION(Èíslo popisné. .)           CPOS(50, 1.45)   CLEN(10)
       TYPE(GET) NAME(osobyW->ccisPopis)             FPOS(65, 1.35)    FLEN(11)

      TYPE(TEXT) CAPTION(Psè. . . .)                 CPOS(54, 2.50)   CLEN(10)
       TYPE(GET) NAME(osobyW->cPsc)                  FPOS(65, 2.40)    FLEN(8)
       TYPE(TEXT) NAME(c_psc->cmisto)                CPOS(74.5,2.40)   CLEN(20.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Místo . . . . )             CPOS(54, 3.55)    CLEN(10)
       TYPE(GET) NAME(osobyW->cMisto)                FPOS(65, 3.45)    FLEN(29)

      TYPE(TEXT) CAPTION(Stát . . )                  CPOS(54, 4.60)    CLEN(10)
       TYPE(GET) NAME(osobyW->czkratStat)            FPOS(65.0, 4.50)  FLEN( 5)
       TYPE(TEXT) NAME(c_staty->cnazevStat)          CPOS(71.5,4.50)   CLEN(23.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Pøe.bydl ulice. . )         CPOS(50, 6.70)   CLEN(15)
       TYPE(GET) NAME(osobyW->cpreUlice)             FPOS(65, 6.60)   FLEN(29)

      TYPE(TEXT) CAPTION(Èíslo popisné. .)           CPOS(54, 7.75)   CLEN(10)
       TYPE(GET) NAME(osobyW->cpreCisPop)            FPOS(65, 7.65)   FLEN(11)

      TYPE(TEXT) CAPTION(Psè . . . .)                CPOS(54, 8.80)   CLEN(10)
       TYPE(GET) NAME(osobyW->cPrePsc)               FPOS(65, 8.70)   FLEN( 8)
       TYPE(TEXT) NAME(c_pscPre->cmisto)             CPOS(74.5,8.70)   CLEN(20.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Místo . . . . )             CPOS(54, 9.85)   CLEN(10)
       TYPE(GET) NAME(osobyW->cpreMisto)             FPOS(65, 9.75)   FLEN(29)

      TYPE(TEXT) CAPTION(Stát . . )                  CPOS(54,10.90)   CLEN(10)
       TYPE(GET) NAME(osobyW->czkrStatPr)            FPOS(65,10.80)   FLEN( 5)
       TYPE(TEXT) NAME(c_statyPre->cnazevStat)       CPOS(71.5,10.80) CLEN(23.5) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Telefon privát. . . .)      CPOS(50,13.00)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelPriv)              FPOS(65,12.90)   FLEN(29)

      TYPE(TEXT) CAPTION(Telefon zamìstnání. .)      CPOS(50,14.05)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelZames)             FPOS(65,13.95)   FLEN(29)

      TYPE(TEXT) CAPTION(Telefon mobil. . . .)       CPOS(50,15.10)   CLEN(15)
       TYPE(GET) NAME(osobyW->ctelMobil)             FPOS(65,15.00)   FLEN(29)

      TYPE(TEXT) CAPTION(E-mailová adresa. . .)      CPOS(50,16.15)   CLEN(15)
       TYPE(GET) NAME(osobyW->cEmail)                FPOS(65,16.05)   FLEN(29)

      TYPE(STATIC) STYPE(16) FPOS( 1, 9.35) SIZE(48,1)
      TYPE(STATIC) STYPE(16) FPOS(50, 5.15) SIZE(45,1)
      TYPE(STATIC) STYPE(16) FPOS(50,11.35) SIZE(45,1)
    TYPE(End)
  TYPE(END)


  TYPE(TabPage) CAPTION(rodPøíslušníci) OFFSET(14.9,72) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A11) RESIZE(yy)

    TYPE(DBrowse) FPOS(.1,.5) SIZE(50,18.6) FILE(vazOsobyW)                           ;
                              FIELDS( vazOsobyW->ncisOsoby:èíslOsoby                , ;
                                      vazOsobyW->cjmenoRozl:Pøímení a jméno osoby:30, ;
                                      vazOsobyW->ctypRodPri:typVztahu               , ;
                                      vazOsobyW->cjmenoOsob:rozen(á)                , ;
                                      vazOsobyW->crodCisOsb:rodÈíslo                , ;
                                      vazOsobyW->ddatNaroz:datNaroz                 , ;   
                                      vazOsobyW->CMISTO:Mìsto:25                    , ;
                                      vazOsobyW->CZKRATSTAT:Stát                      ) ;
                              CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(13)


    TYPE(Static) STYPE(12) FPOS(50.4,.5) SIZE(45.8,18)  RESIZE(nn)

      TYPE(TEXT) CAPTION(Èíslo osoby )                CPOS( 1,  .5)
        TYPE(GET)  NAME(vazOsobyW->ncisOsoby)         FPOS(18,  .5) FLEN(12) PUSH(per_osoby_sel) NOREVISION()
        TYPE(PushButton)                              POS( 31,  .5) ;
                                                      SIZE( 3, .98) EVENT(editParent) ICON1(114) ICON2(114) ATYPE(1) ;
                                                      CAPTION(2)

        TYPE(TEXT) NAME(osoby_Rp->cjmenoRozl)         CPOS( 2, 2  ) CTYPE(1) BGND(12) FONT(5) CLEN(40)

      TYPE(TEXT) CAPTION(rozen(á))                    CPOS( 1, 3) CLEN( 7)
        TYPE(TEXT) NAME(osoby_Rp->cjmenoOsob)         CPOS(18, 3)          FONT(5)

      TYPE(TEXT) CAPTION(Datum narození )             CPOS( 1, 4)
        TYPE(GET) NAME(vazOsobyW->ddatNaroz)          FPOS(18 ,4) FLEN(13) PP(2) FONT(5) PUSH(CLICKDATE)

      TYPE(TEXT) CAPTION(Rodné èíslo)                 CPOS( 1, 5.2)
        TYPE(GET) NAME(vazOsobyW->crodCisOsb)         FPOS(18, 5) FLEN(15)  BGND(13) FONT(5)
 
      TYPE(TEXT) CAPTION(Typ vztahu)                  CPOS( 1, 6.2) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->ctypRodPri)    FPOS(18, 6) FLEN(25)  REF(ctypRodPri)

      TYPE(TEXT) CAPTION(Uplatnit slevu)              CPOS( 1, 7.4) CLEN(15)
        TYPE(COMBOBOX) NAME(vazOsobyW->lsleOdpDan)    FPOS(18, 7.2) FLEN( 7)  REF( LYESNO) 

* 1 - základní údaje pro rodinné pøíslušníky
      TYPE(Static) FPOS(0.5,10.5) SIZE(44.8,6.5) CAPTION(Základní údaje) RESIZE(xx)
        TYPE(Text) CAPTION(Adresa)            CPOS( 1, 0.8) CLEN(20) FONT(5)

        TYPE(TEXT)   CAPTION(Ulice/è.p.)              CPOS( 2, 2) CLEN(10)
          TYPE(TEXT) NAME(osoby_Rp->cUlicCiPop)       CPOS(12, 2) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)                   CPOS(2,3)
          TYPE(TEXT) NAME(osoby_Rp->cmisto)           CPOS(12, 3) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                     CPOS( 2, 4) CLEN(10)
          TYPE(TEXT) NAME(osoby_Rp->cpsc)             CPOS(12, 4) CLEN( 8) BGND(13) 
          TYPE(TEXT) NAME(C_PSC_2->CMISTO)            CPOS(22, 4) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                    CPOS( 2, 5) 
          TYPE(TEXT) NAME(osoby_Rp->czkratStat)       CPOS(12, 5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_2->cNAZEVSTAT)      CPOS(22, 5) CLEN(21) BGND(13)
      TYPE(End)
    TYPE(End) 
  TYPE(END)


  TYPE(TabPage) CAPTION(Dùchody) OFFSET(27.8,59) TABHEIGHT(0.8) FPOS(1,1.50) SIZE(96.8,19.8) PRE(tabSelect) SUB(A12) RESIZE(yy)

    TYPE(DBrowse) FPOS(0.1,0.5) SIZE(50,18) FILE(duchodyW)               ;
                                FIELDS( M->is_Aktiv:ad:2.6::2          , ;
                                        nporDuchod:poøadí              , ;
                                        ntypDuchod:typ dùchodu         , ;
                                        M->nazDuchod:název typu dùchodu, ; 
                                        dpriznDuOd:pøiznán OD          , ; 
                                        dpriznDuDo:pøiznán DO            ) ;
                                CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(ItemMarked) GROUPS(14)

    TYPE(Static) STYPE(12) FPOS(50.4,.5) SIZE(45.8,18)  RESIZE(nn)

      TYPE(TEXT)  CAPTION(Typ dùchodu ...)         CPOS( 1, .5) CLEN(10) 
       TYPE(GET)  NAME(duchodyW->ntypDuchod)       FPOS(13, .5) FLEN( 7) NOREVISION()
*       TYPE(TEXT) CAPTION(/)                       CPOS(21, .5) CLEN( 2)
*       TYPE(TEXT) NAME(duchodyW->nporDuchod)       CPOS(22, .5) CLEN( 4) PICTURE(99)
       TYPE(TEXT) NAME(c_duchod->cnazDuchod)       CPOS(22, .5)

      TYPE(TEXT)  NAME(c_duchod->cnazDuchod)       CPOS( .1, 2  ) CTYPE(1) CLEN(45) BGND(12) GROUPS(SETFONT,11.Arial,GRA_CLR_BLUE) 

      TYPE(TEXT)  CAPTION(Pøiznán _ od)            CPOS( 1, 4) CLEN(10)
       TYPE(GET)  NAME(duchodyW->dpriznDuOd)       FPOS(13, 4) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 4) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dpriznDuDo)       FPOS(33, 4) FLEN(11) PUSH(CLICKDATE)

      TYPE(TEXT)  CAPTION(Nárok _ od)              CPOS( 1, 5) CLEN(10)
       TYPE(GET)  NAME(duchodyW->dnarDuchOd)       FPOS(13, 5) FLEN(11) PUSH(CLICKDATE)
       TYPE(TEXT) CAPTION(_do_)                    CPOS(27, 5) CLEN( 5)
       TYPE(GET)  NAME(duchodyW->dnarDuchDo)       FPOS(33, 5) FLEN(11) PUSH(CLICKDATE)

     TYPE(TEXT) CAPTION(Aktivní dùchod)           CPOS( 1, 6) CLEN(10)
      TYPE(COMBOBOX) NAME(duchodyW->lAktiv)       FPOS(13, 6) FLEN(12) REF(LYESNO) 
*      TYPE(CHECKBOX) NAME(duchodyW->lAktiv)      FPOS(13, 6) FLEN(16) VALUES(T:aktivní dùchod,F:aktivní dùchod)


* 1 - základní údaje pro pøiznané dùchody
      TYPE(Static) FPOS(0.5,8.5) SIZE(44.8,6.5) CAPTION(vyplácející OSSZ) RESIZE(xx)
        TYPE(Text)  CAPTION(Firma  ... )          CPOS( 1, 1) CLEN(10) FONT(5)        
         TYPE(GET)  NAME(duchodyW->ncisFirmy)     FPOS(13, 1) FLEN( 7) 
         TYPE(TEXT) NAME(firmy->cnazev)           CPOS(21, 1)
           
        TYPE(TEXT)   CAPTION(Ulice/è.p.)          CPOS( 2, 2.5) CLEN(10)
         TYPE(TEXT) NAME(firmy->cUlice)           CPOS(13, 2.5) CLEN(30) BGND(13) 
         TYPE(TEXT) NAME(firmy->cSidlo)           CPOS(13, 2.5) CLEN(30) BGND(13) 

        TYPE(TEXT)   CAPTION(Místo)               CPOS( 2, 3.5)
         TYPE(TEXT) NAME(duchodyW->cnazev)        CPOS(13, 3.5) CLEN(30) BGND(13)

        TYPE(TEXT)   CAPTION(PSÈ)                 CPOS( 2, 4.5) CLEN(10)
          TYPE(TEXT) NAME(firmy->cpsc)            CPOS(13, 4.5) FLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_PSC_3->CMISTO)        CPOS(23, 4.5) CLEN(21) BGND(13)                     

        TYPE(TEXT)   CAPTION(Stát)                CPOS( 2, 5.5) 
          TYPE(TEXT) NAME(firmy->czkratStat)      CPOS(13, 5.5) CLEN( 8) BGND(13)
          TYPE(TEXT) NAME(C_STATY_3->cNAZEVSTAT)  CPOS(23, 5.5) CLEN(21) BGND(13)
       TYPE(End)

    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(END)

* 13_TAB ostatní (E)MSPRC_MOw (B)MSSRZ_MOw (E)MSSRZ_MOw *

TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Ostatní) OFFSET(71,14) FPOS(1,4.7) SIZE(98,21.5) PRE(tabSelect) RESIZE(yy)

  TYPE(Static) STYPE(13) SIZE(96,20.0) FPOS(1,0.2) RESIZE(yy)
    TYPE(TEXT)   CAPTION(Nárok na naturálie)                CPOS( 2, 0.5)       CLEN(20) 
      TYPE(GET) NAME(MSPRC_MOw->nNarokNatu)                   FPOS(23.0, 0.5)    FLEN(8)
      TYPE(GET) NAME(MSPRC_MOw->cZkrJedNat)                   FPOS(33.0, 0.5)    FLEN(5)

    TYPE(TEXT) CAPTION(Obor vzdìlání pro ISPV)              CPOS( 2, 1.5)       CLEN(20)
      TYPE(GET) NAME(osobyW->cObVzdISPV)                      FPOS(23.0, 1.5)    FLEN(30)

    TYPE(TEXT) CAPTION(Konto prac.doby pro ISPV)            CPOS( 2, 2.5)       CLEN(20)
      TYPE(COMBOBOX) NAME(MSPRC_MOw->lKonPDIspv)              FPOS(23.0, 2.5)   FLEN( 8)  REF( LYESNO) 

    TYPE(TEXT) CAPTION(Místo výkonu povolání)               CPOS( 2, 3.5)       CLEN(20)
      TYPE(GET) NAME(MSPRC_MOw->cZkrMiVyPo)                   FPOS(23.0, 3.5)    FLEN(10)
  
  TYPE(End)
TYPE(End) 

* neviditelné pomocné položky
TYPE(GET) NAME(mssrz_mow->ctypSrz)    FPOS(-1,0) FLEN(0)
