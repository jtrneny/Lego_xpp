TYPE(drgForm) DTYPE(10) TITLE(Poøízení dokladù o mzdì - Mzdové doklady) SIZE(100,25)                         ;
                                                                        GUILOOK(Action:y,IconBar:y) CARGO() ;
                                                                        POST(postValidate)


TYPE(Static) FPOS(.5,.3) SIZE(99,11.8) STYPE(13)  RESIZE(yn) CTYPE(2)

  TYPE(ComboBox) NAME(mzdDavHDw->cTYPPOHYBU) FPOS(59,0.3) FLEN(39) VALUES(a,a,a,a)  RESIZE(nx) ;
                                                          ITEMMARKED(comboItemMarked)          ;
                                                          ITEMSELECTED(comboItemSelected) PP(2) NOREVISION()

  TYPE(STATIC) STYPE(12)  FPOS(.5,1.5) SIZE(98,2.15) CTYPE(2) RESIZE(yx)

*   P
    TYPE(TEXT) FCAPTION(OsobníÈíslo)        CPOS(  .5,-.05) CLEN(9)
     TYPE(GET) NAME(mzdDavHDw->nOsCisPrac)  FPOS(  .5,1   ) FLEN(8) PP(2) FONT(5) PUSH(MZD_kmenove_SEL) NOREVISION()

    TYPE(TEXT) FCAPTION(PrVz)               CPOS(10.5,-.05) CLEN(5) 
     TYPE(TEXT) NAME(mzdDavHDw->nPorPraVzt) CPOS(10.5,1   ) CLEN(5) PP(2) FONT(5)

    TYPE(TEXT) FCAPTION(Jméno)              CPOS(16.5,-.05) CLEN(8)
     TYPE(TEXT) NAME(mzdDavHDw->cPracovnik) CPOS(16.5,1   ) CLEN(27) PP(2) FONT(5)

*   L -horní
    TYPE(TEXT) FCAPTION(KmStø:)             CPOS(43, .1) CLEN(7)
    TYPE(TEXT) NAME(msPrc_MO->cKmenStrPr)   CPOS(50, .1) CLEN(7) PP(2)

    TYPE(TEXT) FCAPTION(TarStu:)            CPOS(58, .1) CLEN(7)
    TYPE(TEXT) NAME(msPrc_MO->cTarifStup)   CPOS(65, .1) CLEN(7) PP(2)

    TYPE(TEXT) FCAPTION(ZpOdm:)             CPOS(72, .1) CLEN(7)
    TYPE(TEXT) NAME(mzdDavhdw->cTypTarMzd)  CPOS(79, .1) CLEN(9) PP(2)
*    TYPE(TEXT) NAME(msPrc_MO->cTypTarMzd)   CPOS(79, .1) CLEN(9) PP(2)

    TYPE(TEXT) FCAPTION(Prùmìr H/D)         CPOS(88, .1) CLEN(10)

*   L -dolní
    TYPE(TEXT) FCAPTION(KmPrZa:)            CPOS(43,1.1) CLEN(7)
    TYPE(TEXT) NAME(msPrc_MO->cPracZar)     CPOS(50,1.1) CLEN(7) PP(2)

    TYPE(TEXT) FCAPTION(TarTøíd:)           CPOS(58,1.1) CLEN(7)
    TYPE(TEXT) NAME(msPrc_MO->cTarifTrid)   CPOS(65,1.1) CLEN(7) PP(2)

*     TYPE(TEXT) FCAPTION(Sazba :)            CPOS(72,1.1) CLEN( 6)
     TYPE(TEXT) NAME(M->tarSazba_hm)         CPOS(72,1.1) CLEN(13) PP(2) GROUPS(SETFONT, 9.Cambria)

    TYPE(TEXT) NAME(M->hodPrumPP)            CPOS(86.5,1.1) CLEN(7) PICTURE(9999.99) PP(2)
*    TYPE(TEXT) FCAPTION(/)                  CPOS(91.5  ,1.1) CLEN(2)
    TYPE(TEXT) NAME(M->denPrumPP)            CPOS(93  ,1.1) CLEN(5) PICTURE(9999) PP(2)
  TYPE(END)


  TYPE(STATIC) STYPE(12) FPOS(.5,3.7) SIZE(44.5,5.2) CTYPE(2) RESIZE(xx)
    TYPE(GET) NAME(mzdDavHDw->nDoklad   ) FPOS( 10.5,.4) FLEN(10) PP(2) FCAPTION(Doklad       : ) CPOS(   .5, .4) CLEN(10) NOREVISION()
    TYPE(GET) NAME(mzdDavHDw->ddatPoriz ) FPOS( 32.5,0.4) FLEN(10) FCAPTION(DatumPoø  :)          CPOS( 22.5, .4) CLEN(10) PUSH(CLICKDATE) NOREVISION()

    TYPE(GET) NAME(mzdDavHDw->cPracZarDo) FPOS( 10.5,1.4) FLEN(10) FCAPTION(ProfDoklad:) CPOS(  .5,1.4) CLEN(10)
    TYPE(GET) NAME(mzdDavHDw->cKmenStrSt) FPOS( 32.5,1.4) FLEN(10) FCAPTION(KmStrStroj:) CPOS(22.5,1.4) CLEN(10)
    TYPE(GET) NAME(mzdDavHDw->nExtFaktur) FPOS( 32.5,2.4) FLEN(10) FCAPTION(ExtFaktura:) CPOS(22.5,2.4) CLEN(10)

    TYPE(GET) NAME(mzdDavHDw->dDatumOd  ) FPOS( 10.5,3.4) FLEN(10) FCAPTION(Datum_OD:  ) CPOS(  .5,3.4) CLEN(10) PUSH(CLICKDATE)
    TYPE(GET) NAME(mzdDavHDw->dDatumDo  ) FPOS( 32.5,3.4) FLEN(10) FCAPTION(_DO_       ) CPOS(23.5,3.4) CLEN( 8) PUSH(CLICKDATE)

  TYPE(END)

* MH - matrice pro hrubé mzdy
  TYPE(ComboBox) NAME(mzdDavHDw->nkeyMatr)  FPOS(4.7,9.2) FLEN(39.95) ;
                                            VALUES(a,a,a,a)          ;
                                            ITEMSELECTED(comboItemSelected) NOREVISION()
  TYPE(STATIC) STYPE(3) FPOS( 1,9.1) SIZE( 20,20 ) CAPTION(427) 

* MN - nemocenky, èíslo Rozhodnutí
   TYPE(TEXT) CAPTION(èíslo Rozhodnutí:)  CPOS( 3,10.2) CLEN(14) GROUPS(MZD_MN_HD)
   TYPE(GET)  NAME(mzdDavHDw->ccisRozNem) FPOS(21,10.2) FLEN(20) GROUPS(MZD_MN_HD)

* pro test ndnyFondKD, nhodFondKD
*  TYPE(TEXT) NAME(mzdDavitW->ndnyFondKD)  CPOS( 7,10.2) CLEN(14)
*  TYPE(TEXT) NAME(mzdDavitW->nhodFondKD)  CPOS(21,10.2) CLEN(14)


* PRAVÁ STRANA
  TYPE(STATIC) STYPE(13) FPOS(45,3.7) SIZE(53.3,7.8) CTYPE(2) RESIZE(yx)

      TYPE(TEXT) FCAPTION(PracDoba:)          CPOS(   .5, .15) CLEN(9)
      TYPE(TEXT) NAME(msPrc_MO->cDelkPrDob)   CPOS( 9   , .15) CLEN(18) PP(2)
      TYPE(TEXT) FCAPTION(DovolZùst M/B:)     CPOS( 28.5, .15) CLEN(12)
      TYPE(TEXT) NAME(msPrc_MO->nDovMinZus)   CPOS(40   , .15) PICTURE(999) PP(2) CLEN(4)
      TYPE(TEXT) FCAPTION(/)                  CPOS(43.5 , .15) CLEN(2)
      TYPE(TEXT) NAME(msPrc_MO->nDovBezZus)   CPOS(45.5 , .15) PICTURE(999) PP(2) CLEN(4)

     TYPE(TEXT) FCAPTION(celkem)  CPOS( 2.0,1) CLEN(8) GROUPS(SETFONT, 9.Cambria)
     TYPE(TEXT) FCAPTION(KalDny)  CPOS(10.0,1) CLEN(6)
     TYPE(TEXT) FCAPTION(PrDny)   CPOS(17.0,1) CLEN(6)
     TYPE(TEXT) FCAPTION(Hod)     CPOS(25.5,1) CLEN(4)
     TYPE(TEXT) FCAPTION(Kè)      CPOS(35.5,1) CLEN(3)
     TYPE(TEXT) FCAPTION(Prùmìr)  CPOS(45.5,1) CLEN(6)

     TYPE(STATIC) STYPE(16) FPOS( .5, 1.3) SIZE(52, .4) CTYPE(1) RESIZE(xn)

      TYPE(TEXT) FCAPTION(zaDoklad)             CPOS(   .5,2.0)
        TYPE(TEXT) NAME(mzdDavHDw->nDnyFondKD)  CPOS(12  ,2.0) CLEN( 3  ) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 10.Treubuchet MS)
        TYPE(TEXT) NAME(mzdDavHDw->nDnyFondPD)  CPOS(17.5,2.0) CLEN( 4.5) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Lucida)
        TYPE(TEXT) NAME(mzdDavHDw->nHodFondPD)  CPOS(22  ,2.0) CLEN( 7  ) PICTURE(999.99) BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Lucida)
        TYPE(TEXT) NAME(mzdDavHDw->nMzda)       CPOS(29  ,2.0) CLEN(11  )                 BGND(13) CTYPE(2) GROUPS(SETFONT,10.Lucida,GRA_CLR_DARKGREEN)

      TYPE(TEXT) FCAPTION(hrubá mzda)           CPOS(  .5,3.15) CLEN(9)
        TYPE(TEXT) NAME(M->dnyFondKD_H)         CPOS(12  ,3.15) CLEN( 3  ) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->dnyFondPD_H)         CPOS(17.5,3.15) CLEN( 4.5) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->hodFondPD_H)         CPOS(22  ,3.15) CLEN( 7  ) PICTURE(999.99) BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->mzda_H)              CPOS(29  ,3.15) CLEN(11  )                 BGND(13) CTYPE(2) GROUPS(SETFONT,10.Cambria,GRA_CLR_DARKGREEN)
        TYPE(TEXT) NAME(M->prumer_H)            CPOS(44  ,3.15) CLEN( 7  ) PICTURE(999.99) BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)


      TYPE(TEXT) FCAPTION(nemocenská)           CPOS(  .5,4.00) CLEN(10)
        TYPE(TEXT) NAME(M->dnyFondKD_N)         CPOS(12  ,4.1) CLEN( 3  ) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->dnyFondPD_N)         CPOS(17.5,4.1) CLEN( 4.5) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->hodFondPD_N)         CPOS(22  ,4.1) CLEN( 7  ) PICTURE(999.99) BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
        TYPE(TEXT) NAME(M->mzda_N)              CPOS(29  ,4.1) CLEN(11  )                 BGND(13) CTYPE(2) GROUPS(SETFONT,10.Cambria,GRA_CLR_DARKGREEN)

      TYPE(TEXT) FCAPTION(srážka)               CPOS( 0.5,4.85) CLEN(9)
        TYPE(TEXT) NAME(M->mzda_S)              CPOS(29  ,5.05) CLEN(11)                   BGND(13) CTYPE(2) GROUPS(SETFONT,10.Cambria,GRA_CLR_RED)

    TYPE(STATIC) FPOS( .5,6.3) SIZE(52,.11) STYPE(12) CTYPE(2) RESIZE(xx)
    TYPE(End)

    TYPE(TEXT) FCAPTION(zaPracovníka)          CPOS(  .5,6.5) CLEN(10)
      TYPE(TEXT) NAME(M->dnyFondKD_sum)        CPOS(12  ,6.5) CLEN( 3  ) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
      TYPE(TEXT) NAME(M->dnyFondPD_sum)        CPOS(17.5,6.5) CLEN( 4.5) PICTURE(99)     BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
      TYPE(TEXT) NAME(M->hodFondPD_sum)        CPOS(22  ,6.5) CLEN( 7  ) PICTURE(999.99) BGND(13) CTYPE(2) GROUPS(SETFONT, 9.Cambria)
      TYPE(TEXT) NAME(M->mzda_sum)             CPOS(29  ,6.5) CLEN(11  )                 BGND(13) CTYPE(2) GROUPS(SETFONT,10.Cambria,GRA_CLR_DARKGREEN)
  TYPE(END)

TYPE(END)


* hrubé mzdy
  TYPE(Static) FPOS(.2,12.3) SIZE(99.5,12.5) STYPE(12) RESIZE(yy) CTYPE(2) GROUPS(MZD_PRIJEM,cdenikMZ_H,MATR_ANO) 
    TYPE(EBrowse) FPOS(-.7,.1) SIZE(99.5,12.6) FILE(MzdDavITw) INDEXORD(1)  ;
                                             CURSORMODE(3) PP(7) ITEMMARKED(EdItemMarked) ;
                                             POSTVALIDATE(postValidate) POPUPMENU(n) GROUPS(MZD_PRIJEM)

* lze vypustit uživatel nepoužívá nUcetMzdy, cnazPol1...6, ddatumOd, ddatumDo, npremie, ncisPrace, nspotrPhm, czkrNormy, czkratJedn

      TYPE(GET)  NAME(mzdDavITw->nUcetMzdy)  FPOS( 1,0) FLEN( 6) FCAPTION(VnitÚèet) FONT(5) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol1)   FPOS( 2,0) FLEN( 6) FCAPTION(VýrStøed) FONT(5) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol2)   FPOS( 3,0) FLEN( 6) FCAPTION(Výkon   ) FONT(5) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol3)   FPOS( 4,0) FLEN( 6) FCAPTION(Zakázka ) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol4)   FPOS( 5,0) FLEN( 6) FCAPTION(VýrMísto) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol5)   FPOS( 6,0) FLEN( 6) FCAPTION(Stroj   ) 
      TYPE(GET)  NAME(MzdDavITw->cnazPol6)   FPOS( 7,0) FLEN( 6) FCAPTION(Oper    ) 
      TYPE(GET)  NAME(MzdDavITw->ndnyDoklad) FPOS( 8,0) FLEN( 5) FCAPTION(Dny     ) 
      TYPE(GET)  NAME(MzdDavITw->dDatumOd)   FPOS( 9,0) FLEN(11) FCAPTION(DatOd   ) 
      TYPE(GET)  NAME(MzdDavITw->dDatumDo)   FPOS(10,0) FLEN(11) FCAPTION(DatDo   ) 
      TYPE(GET)  NAME(MzdDavITw->ndruhMzdy)  FPOS(11,0) FLEN( 6) FCAPTION(DrMzd   ) PRE(preValidate)
      TYPE(GET)  NAME(MzdDavITw->nsazbaDokl) FPOS(12,0) FLEN(10) CAPTION(Sazba    ) 
      TYPE(GET)  NAME(MzdDavITw->nhodDoklad) FPOS(13,0) FLEN( 8) CAPTION(Hodiny   ) 
      TYPE(GET)  NAME(MzdDavITw->nmnPDoklad) FPOS(14,0) FLEN(10)                    
      TYPE(GET)  NAME(MzdDavITw->nmzda)      FPOS(15,0) FLEN(10)                    
      TYPE(GET)  NAME(MzdDavITw->nPremie)    FPOS(16,0) FLEN( 5)                    
      TYPE(GET)  NAME(MzdDavITw->ncisPrace)  FPOS(17,0) FLEN( 5)                    
      TYPE(GET)  NAME(MzdDavITw->nspotrPhm)  FPOS(18,0) FLEN( 5)
      TYPE(GET)  NAME(MzdDavITw->czkrNormy)  FPOS(19,0) FLEN( 5)
      TYPE(GET)  NAME(MzdDavITw->czkratJedn) FPOS(20,0) FLEN( 5)
    TYPE(END)
  TYPE(END)

* Srážky  
  TYPE(Static) FPOS(.2,12.3) SIZE(99.5,12.5) STYPE(12) RESIZE(yy) CTYPE(2) GROUPS(MZD_SRAZKY,cdenikMZ_S,MATR_NE)
    TYPE(EBrowse) FPOS(-.7,.1) SIZE(99.5,12.6) FILE(MzdDavITw) INDEXORD(1)  ;
                                             CURSORMODE(3) PP(7) ITEMMARKED(EdItemMarked) ;
                                             POSTVALIDATE(postValidate) POPUPMENU(n) GROUPS(MZD_SRAZKY)

      TYPE(GET)      NAME(mzdDavITw->czkrSrazky)    FPOS( 1,0) FLEN( 8)    FCAPTION(zkrSrážky) 
      TYPE(GET)      NAME(mzdDavITw->ndruhMzdy)     FPOS( 2,0) FLEN( 6)    FCAPTION(drMzd    ) PRE(preValidate)
      TYPE(GET)      NAME(MzdDavITw->nsazbaDokl)    FPOS( 3,0) FLEN( 9)    CAPTION(srážka    ) 
      TYPE(GET)      NAME(MzdDavITw->nmzda)         FPOS( 3,0) FLEN(10)    FCAPTION(mzda     )
      TYPE(CHECKBOX) NAME(mzdDavITw->lprednPohl)    CLEN( 3)   CAPTION(pp) REF(LYESNO)     

      TYPE(GET)      NAME(MzdDavITw->cUcetI)        FPOS( 7,0) FLEN(20)    FCAPTION(uhraditNaÚèet)    
      TYPE(GET)      NAME(MzdDavITw->cKodBanky)     FPOS( 8,0) FLEN( 6)    FCAPTION(kódBanky )    
      TYPE(GET)      NAME(MzdDavITw->cVarSym)       FPOS( 9,0) FLEN(15)    FCAPTION(varSymbol)    
      TYPE(GET)      NAME(MzdDavITw->cSpecSymb)     FPOS( 9,0) FLEN(15)    FCAPTION(specSymbol)    
      TYPE(GET)      NAME(MzdDavITw->nKonstSymb)    FPOS( 9,0) FLEN(10)    FCAPTION(konstSymbol)    

      TYPE(GET)      NAME(MzdDavITw->cpohZavFir)    FPOS( 9,0) FLEN(15)    FCAPTION(typZáv   ) PUSH(mzd_trvZavhd_sel)       
      TYPE(GET)      NAME(MzdDavITw->czkrtypuhr)    FPOS( 9,0) FLEN(15)    

      TYPE(GET)      NAME(MzdDavITw->cBank_Uct)     FPOS(15,0) FLEN(20)    FCAPTION(uhraditZÚètu ) 
      TYPE(GET)      NAME(MzdDavITw->cUcet_Uct)     FPOS(14,0) FLEN( 6)    FCAPTION(suau_Ø   ) 
    TYPE(END)
  TYPE(END)


* Nemoc
  TYPE(Static) FPOS(.2,12.3) SIZE(99.5,12.5) STYPE(12) RESIZE(yy) CTYPE(2) GROUPS(MZD_NEMOC,cdenikMZ_N,MATR_NE)
    TYPE(EBrowse) FPOS(-.7,.1) SIZE(99.5,12.6) FILE(MzdDavITw) INDEXORD(1) ;
                                             CURSORMODE(3) PP(7) ITEMMARKED(EdItemMarked) ;
                                             POSTVALIDATE(postValidate) POPUPMENU(n) GROUPS(MZD_NEMOC)

      TYPE(GET)  NAME(MzdDavITw->nDruhMzdy)      FPOS( 1,0) FLEN( 6) FCAPTION(DrMz      ) PRE(preValidate)
      TYPE(GET)  NAME(MzdDavITw->dVykazN_Od)     FPOS( 2,0) FLEN(11) FCAPTION(NemocOd   ) 
      TYPE(GET)  NAME(MzdDavITw->dVykazN_Do)     FPOS( 3,0) FLEN(11) FCAPTION(NemocDo   ) 
      TYPE(GET)  NAME(MzdDavITw->nVykazN_KD)     FPOS( 4,0) FLEN( 4) FCAPTION(NKd       ) PICTURE(999) 
      TYPE(GET)  NAME(MzdDavITw->nVykazN_PD)     FPOS(14,0) FLEN( 4) FCAPTION(NPd       ) PICTURE(999) 
      TYPE(GET)  NAME(MzdDavITw->nVykazN_VD)     FPOS(15,0) FLEN( 4) FCAPTION(NVd       ) PICTURE(999) 
      TYPE(GET)  NAME(MzdDavITw->nVykazN_H1)     FPOS( 7,0) FLEN( 7) FCAPTION(Odpr1D    ) 

      TYPE(GET)  NAME(MzdDavITw->dProplN_Od)     FPOS( 5,0) FLEN(11) FCAPTION(PlacenoOd ) 
      TYPE(GET)  NAME(MzdDavITw->dProplN_Do)     FPOS( 6,0) FLEN(11) FCAPTION(PlacenoDo ) 
*      TYPE(GET)  NAME(MzdDavITw->nProplN_Ho)     FPOS( 7,0) FLEN( 7) FCAPTION(PHo       ) 
      TYPE(GET)  NAME(MzdDavITw->nProplN_KD)     FPOS( 8,0) FLEN( 4) FCAPTION(PKd       ) PICTURE(999)
      TYPE(GET)  NAME(MzdDavITw->nProplN_PD)     FPOS( 9,0) FLEN( 4) FCAPTION(PPd       ) PICTURE(999)
      TYPE(GET)  NAME(MzdDavITw->nhodDoklad)     FPOS(10,0) FLEN( 8) FCAPTION(Hodiny) 

      TYPE(GET)  NAME(MzdDavITw->nSazbaDokl)     FPOS(11,0) FLEN( 9) FCAPTION(Sazba     ) 
      TYPE(GET)  NAME(MzdDavITw->nMzda)          FPOS(12,0) FLEN( 5) FCAPTION(celkMzda  ) 
      TYPE(GET)  NAME(MzdDavITw->nNemocCelk)     FPOS(13,0) FLEN( 5) FCAPTION(celkemNem ) 
      TYPE(GET)  NAME(MzdDavITw->nSazDenNem)     FPOS(16,0) FLEN( 6) FCAPTION(SazNemÈist) 
* no visible
*      TYPE(TEXT) NAME(MzdDavITw->nhodDoklad)     FPOS(17,0) FLEN( 0) FCAPTION() 
      TYPE(TEXT) NAME(MzdDavITw->ndnyDoklad)     FPOS(18,0) FLEN( 0) FCAPTION() 
      TYPE(GET)  NAME(MzdDavITw->nProplN_Ho)     FPOS( 7,0) FLEN( 0) FCAPTION() 
    TYPE(END)
  TYPE(END)


*  TYPE(TEXT) NAME(DRUHYMZD->cNazevDMz) CPOS( 2.5,21.15) CLEN(35) PP(2) FONT(5)
* TYPE(END)

* neviditelné pomocné položky
TYPE(TEXT) NAME(mzddavITw->nhrubaMzd)    FPOS(0,0) CLEN(0) GROUPS(ITw)

TYPE(TEXT) NAME(mzddavITw->nDnyFondKD)   FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nDnyFondPD)   FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nDnyDovol)    FPOS(0,0) CLEN(0) GROUPS(ITw)

TYPE(TEXT) NAME(mzddavITw->nHodFondKD)   FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nHodFondPD)   FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nHodPresc)    FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nHodPrescS)   FPOS(0,0) CLEN(0) GROUPS(ITw)
TYPE(TEXT) NAME(mzddavITw->nHodPripl)    FPOS(0,0) CLEN(0) GROUPS(ITw)

* pro automaticky poèíttané pémie k položce dokladu
TYPE(TEXT) NAME(MzdDavITw->ndruhMzPre)   FPOS(0,0) CLEN(0) GROUPS(ITw)



