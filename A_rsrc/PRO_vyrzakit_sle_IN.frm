TYPE(drgForm) DTYPE(10) TITLE(Prùbìh zakázky - informaèní tok ...) FILE(VYRZAKPL) ;
              CARGO()                                             ;
              POST(postValidate)                                  ;
              SIZE(115,26) GUILOOK(Action:n,IconBar:y)


  TYPE(EBROWSE) FPOS(0.75,1.40) SIZE(115,19.5) FILE(VYRZAKPL)                                    ;
                               ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(9) SCROLL(yy) ;
                               POPUPMENU(y)                                                      ;
                               LFREEZE(1)                                                        ;
                               GUILOOK(ins:n,del:n) 


      TYPE(TEXT) NAME(vyrZakpl->ccisZakazi)     CLEN(12) FCAPTION(zakázka)
      TYPE(TEXT) NAME(vyrZakit->nRozm_del)      CLEN(10) FCAPTION(délka)
      TYPE(TEXT) NAME(vyrZakit->nRozm_sir)      CLEN(10) FCAPTION(šíøka)
      TYPE(TEXT) NAME(vyrZakit->nRozm_vys)      CLEN(10) FCAPTION(výška)
      TYPE(TEXT) NAME(vyrZakpl->cnazFirmy)      CLEN(20) FCAPTION(zákazník)
      TYPE(TEXT) NAME(vyrZakpl->ccisloObj)      CLEN(20) FCAPTION(objednávka)
      TYPE(TEXT) NAME(vyrZakit->ckatOznOdb)     CLEN(15) FCAPTION(katalogOznaè)

      TYPE(TEXT) NAME(vyrZakpl->nCisFirDOA)     CLEN( 8) FCAPTION(èísFirmyDoA)
      TYPE(TEXT) NAME(vyrZakpl->cNazevDOA)      CLEN(20) FCAPTION(názevFirDoA)
      TYPE(TEXT) NAME(vyrZakpl->cSidloDOA)      CLEN(20) FCAPTION(sídloFirDoA)
      TYPE(TEXT) NAME(vyrZakpl->cPscDOA)        CLEN( 8) FCAPTION(pscFirDoA)

      TYPE(GET) NAME(vyrZakpl->nRozmP_del)      FLEN(10) FCAPTION(PøDélka)
      TYPE(GET) NAME(vyrZakpl->nRozmP_sir)      FLEN(10) FCAPTION(PøŠíøka)
      TYPE(GET) NAME(vyrZakpl->nRozmP_vys)      FLEN(10) FCAPTION(PøVýška)
      TYPE(GET) NAME(vyrZakpl->cRozmP_MJ)       FLEN( 4) FCAPTION(PøeprMJ)

* odchodní úsek
      TYPE(GET)  NAME(vyrZakpl->cjmeOsOdp)      FLEN(20) FCAPTION(Obchod)
      TYPE(GET)  NAME(vyrZakpl->dzapis)         FLEN(11) FCAPTION(datPoø   ) 
      TYPE(GET)  NAME(vyrZakpl->dodvedZaka)     FLEN(11) FCAPTION(datOdv_pl) 
      TYPE(GET)  NAME(vyrZakpl->dMozOdvZak)     FLEN(11) FCAPTION(datOdv_mo) 
      TYPE(GET)  NAME(vyrZakpl->dskuOdvZak)     FLEN(11) FCAPTION(datOdv_sk) 

* tpv
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Tpv)     FLEN(10) FCAPTION(Tpv) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Tpv)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Tpv)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Tpv)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Tpv)     FLEN(11) FCAPTION(datDok_sk)

* svárna
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Sva)     FLEN(10) FCAPTION(Svárna) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Sva)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Sva)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSk_Sva)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSk_Sva)     FLEN(11) FCAPTION(datDok_sk)

* lakovna
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Lak)     FLEN(10) FCAPTION(Lakovna) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Lak)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Lak)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Lak)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Lak)     FLEN(11) FCAPTION(datDok_sk)

* montáž
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Mon)     FLEN(10) FCAPTION(Montáž) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Mon)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Mon)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Mon)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Mon)     FLEN(11) FCAPTION(datDok_pl)

* elektro
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Ele)     FLEN(10) FCAPTION(Elektro) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Ele)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Ele)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Ele)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Ele)     FLEN(11) FCAPTION(datDok_pl)

* kooperace
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Koo)     FLEN(10) FCAPTION(Kooperace) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Koo)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Koo)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Koo)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Koo)     FLEN(11) FCAPTION(datDok_pl)

* kontrola jakosti
      TYPE(GET)  NAME(vyrZakpl->czkrOs_Kon)     FLEN(10) FCAPTION(Kontrola) PUSH(pro_vyrzakit_sle_OSB_sel)
      TYPE(GET)  NAME(vyrZakpl->dzahPL_Kon)     FLEN(11) FCAPTION(datZah_pl)
      TYPE(GET)  NAME(vyrZakpl->dkonPL_Kon)     FLEN(11) FCAPTION(datDok_pl)
      TYPE(GET)  NAME(vyrZakpl->dzahSK_Kon)     FLEN(11) FCAPTION(datZah_sk)
      TYPE(GET)  NAME(vyrZakpl->dkonSK_Kon)     FLEN(11) FCAPTION(datDok_pl)

* doprava
      TYPE(GET)  NAME(vyrZakpl->ndoklRozv)     FLEN(10) FCAPTION(èísloRozvozu)    PUSH(pro_rozvozhd_sel)
      TYPE(TEXT) NAME(       M->nazevDop)      CLEN( 25) CAPTION(název dopravce)
      TYPE(GET)  NAME(vyrZakpl->dNakladky)     FLEN(11) FCAPTION(DatNakládky)
      TYPE(GET)  NAME(vyrZakpl->cCasNaklad)    FLEN(11) FCAPTION(ÈasNakládky)
      TYPE(GET)  NAME(vyrZakpl->dVykladky)     FLEN(11) FCAPTION(DatVykládky)
      TYPE(GET)  NAME(vyrZakpl->cCasVyklad)    FLEN(11) FCAPTION(ÈasVykládky)
      TYPE(MLE)  NAME(vyrZakpl->mTextRozv)     FLEN(11) FCAPTION(RozvozPopis)

  TYPE(END)



* info 114,9.7  .5,15.5
  TYPE(Static) CTYPE(2) SIZE(114,6) FPOS(.5,19.5) RESIZE(y)

* 1. øádek
*    TYPE(Text) CAPTION(Zakázka)               CPOS(  1,  .2) CLEN( 15)
*    TYPE(Text) NAME(cCisZakazI)               CPOS(  1, 1.2) CLEN( 15) BGND( 12) FONT(5) GROUPS(clrYELLOW)
*    TYPE(Text) NAME(vyrzakit->cNazevZak1)     CPOS( 17, 1.2) CLEN( 60) PICTURE(&X70) BGND( 13) GROUPS(clrYELLOW)

*    TYPE(Text) CAPTION(pøepravní rozmìry)     CPOS( 82,  .2) CLEN( 20)  
*    TYPE(Text) NAME(M->crozm_del_sir_vys)     CPOS( 82, 1.2) CLEN( 30)

* 2. øádek
*    TYPE(Text) CAPTION( Odbìratel)            CPOS(  1, 2.3) CLEN( 10)
*    TYPE(Text) NAME(ncisFirmy)                CPOS( 17, 2.3) CLEN(  5) PICTURE(99999)
*    TYPE(Text) CAPTION( _  )                  CPOS( 23, 2.3) CLEN(  3)
*    TYPE(Text) NAME(cnazFirmy)                CPOS( 26, 2.3) CLEN( 50)
*    TYPE(Text) NAME(ccisloObj)                CPOS( 82, 2.3) 

* 3. øádek
*    TYPE(Text) CAPTION( Dodací adresa)        CPOS(  1, 3.2) CLEN( 15)
*    TYPE(Text) NAME(ncisFirDoA)               CPOS( 17, 3.2) CLEN(  5) PICTURE(99999)
*    TYPE(Text) CAPTION( _  )                  CPOS( 23, 3.2) CLEN(  3)
*    TYPE(Text) NAME(cnazevDoA)                CPOS( 26, 3.2) CLEN( 50)

* 4 - X. øádek
    TYPE(TEXT) CAPTION(plán)                  CPOS( 77,  .2) CLEN( 10)  
    TYPE(TEXT) CAPTION(skuteènost)            CPOS( 93,  .2) CLEN( 10)  

    TYPE(Text) CAPTION( Obchodní úsek)        CPOS(  1, 1.2) CLEN( 15) 
      TYPE(GET)      NAME(cJmeOsOdp)          FPOS( 17, 1.2) FLEN( 25) PUSH(osb_osoby_sel)
      TYPE(GET)      NAME(DZAPIS)             FPOS( 45, 1.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(DODVEDZAKA)         FPOS( 61, 1.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(DMOZODVZAK)         FPOS( 77, 1.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(DSKUODVZAK)         FPOS( 93, 1.2) FLEN( 13) PUSH(CLICKDATE) 

    TYPE(Text) CAPTION( TPV)                  CPOS(  1, 2.2) CLEN( 15)   
      TYPE(GET)      NAME(cjmeOs_Tpv)         FPOS( 17, 2.2) FLEN( 25) PUSH(osb_osoby_sel)
      TYPE(TEXT)     CAPTION(tpv      _    pøedání dokumentace do výroby) CPOS( 45, 2.2) CLEN(30)
      TYPE(GET)      NAME(dzahPL_Tpv)         FPOS( 77, 2.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(dkonPL_Tpv)         FPOS( 93, 2.2) FLEN( 13) PUSH(CLICKDATE)
 
    TYPE(Text) CAPTION( Svárna)               CPOS(  1, 3.2) CLEN( 15)    
      TYPE(GET)      NAME(cjmeOs_Sva)         FPOS( 17, 3.2) FLEN( 25) PUSH(osb_osoby_sel)
      TYPE(TEXT)     CAPTION(svárna _ zahájení práce) CPOS( 45, 3.2) CLEN(30)
      TYPE(GET)      NAME(dzahPL_Sva)         FPOS( 77, 3.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(dzahSk_Sva)         FPOS( 93, 3.2) FLEN( 13) PUSH(CLICKDATE)

    TYPE(Text) CAPTION( Lakovna)              CPOS(  1, 4.2) CLEN( 15)    
      TYPE(GET)      NAME(cjmeOs_Lak)         FPOS( 17, 4.2) FLEN( 25) PUSH(osb_osoby_sel)
      TYPE(TEXT)     CAPTION(lakovna _ zahájení práce) CPOS( 45, 4.2) CLEN(30)
      TYPE(GET)      NAME(dzahPL_Lak)         FPOS( 77, 4.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(dzahSK_Lak)         FPOS( 93, 4.2) FLEN( 13) PUSH(CLICKDATE)

    TYPE(Text) CAPTION( Montáž)               CPOS(  1, 5.2) CLEN( 15)    
      TYPE(GET)      NAME(cjmeOs_Mon)         FPOS( 17, 5.2) FLEN( 25) PUSH(osb_osoby_sel)
      TYPE(TEXT)     CAPTION(montáž _ zahájení práce) CPOS( 45, 5.2) CLEN(30)
      TYPE(GET)      NAME(dzahPL_Mon)         FPOS( 77, 5.2) FLEN( 13) PUSH(CLICKDATE)
      TYPE(GET)      NAME(dzahSK_Mon)         FPOS( 93, 5.2) FLEN( 13) PUSH(CLICKDATE)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

*** QUICK FILTR ***
TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Stav výrobní zakázky)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
   TYPE(STATIC) STYPE(2) FPOS(80.5,0.09) SIZE(33.2,1.0) RESIZE(nx)
     TYPE(PushButton) POS(0.1,0.46)   SIZE(33.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
   TYPE(END) 

TYPE(END)



