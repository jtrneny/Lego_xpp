TYPE(drgForm) DTYPE(10) TITLE(Zpracování kontrolního hlášení o DPH ...) SIZE(95,11) GUILOOK(IconBar:n,Menu:n)

  TYPE(ACTION) CAPTION(      ~Zpracovat) EVENT(dph_Insert) ICON1(107) ICON2(207) ATYPE(3) TIPTEXT(Zpracovat kontrolní hlášení k DPH ...)
  TYPE(ACTION) CAPTION(   ~Storno)       EVENT(140000002)  ICON1(110) ICON2(210) ATYPE(3)


  TYPE(STATIC) FPOS(0.5,0.5) SIZE(94,3) STYPE(14) CTYPE(2)
    TYPE(TEXT)     CAPTION(Zpracovat kontrolní hlášení o DPH za daòove období _ ) CPOS( 8, .1) CLEN(52) FONT(7) 
    TYPE(COMBOBOX) NAME(FIN_dphKohHd_INS:NASTAVENI)  FPOS(60, .2) FLEN(26);
                                                     VALUES(a,a,a,a,a,a,a,a,a,a,a,a);
                                                     ITEMSELECTED(comboItemSelected)

*    TYPE(TEXT)     CAPTION(_ obdÚèetní _)             CPOS(65, .2) CLEN(11)
*    TYPE(TEXT)     NAME(M->cobdobi_inf)               CPOS(76, .2) CLEN(8) BGND(8) CTYPE(1)


    TYPE(TEXT)     CAPTION(Typ hlášení _ )           CPOS( 1,1.5) CLEN(10)
    TYPE(COMBOBOX) NAME(M->ctypKONTHL)               FPOS(11,1.5) FLEN(16) REF(ctypKONTHL) 
    TYPE(GET)      NAME(M->cidVYZVY)                 FPOS(39,1.5) FLEN(30) FCAPTION(Èíslo výzvy _ ) CPOS(28,1.5) CLEN(11)
    TYPE(COMBOBOX) NAME(M->crychODPOV)               FPOS(72,1.5) FLEN(20) REF(crychODPOV)  

  TYPE(END)


  TYPE(TEXT) CAPTION(Závazky)             CPOS( 2,4) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->ZPRAC)               CPOS(22,4) CLEN( 7) FONT(2) BGND(13) GROUPS('FAKPRIHD:11:FAKPRIIT:1:STRZERO(FAKPRIHD->nDOKLAD,10):dphKoh_FAP()') PICTURE(999%)
    TYPE(STATIC) FPOS(32,4) SIZE(62,1) STYPE(13) CTYPE(1)                      GROUPS('FAKPRIHD') 
    TYPE(END) 
    TYPE(STATIC) STYPE(3)                 FPOS(19,4.2) SIZE(15,15) CAPTION(427)  GROUPS('FAKPRIHD') 
  
  TYPE(TEXT) CAPTION(Pohledávky)          CPOS( 2,5.4) CLEN(15) FONT(2)
  TYPE(TEXT) NAME(M->ZPRAC)               CPOS(22,5.4) CLEN( 7) FONT(2) BGND(13) GROUPS('FAKVYSHD:10:FAKVYSIT:1:STRZERO(FAKVYSHD->nCISFAK,10):dphKoh_FAV()') PICTURE(999%)
    TYPE(STATIC) FPOS(32,5.4) SIZE(62,1) STYPE(13) CTYPE(1)                      GROUPS('FAKVYSHD') 
    TYPE(END) 
    TYPE(STATIC) STYPE(3)                 FPOS(19,5.6) SIZE(15,15) CAPTION(427)    GROUPS('FAKVYSHD') 

  TYPE(TEXT) CAPTION(Pokladna)            CPOS( 2,6.7) CLEN(15) FONT(2) 
  TYPE(TEXT) NAME(M->ZPRAC)               CPOS(22,6.7) CLEN( 7) FONT(2) BGND(13) GROUPS('POKLADHD:5::::dphKoh_POF()') PICTURE(999%)
    TYPE(STATIC) FPOS(32,6.7) SIZE(62,1) STYPE(13) CTYPE(1)                      GROUPS('POKLADHD') 
    TYPE(END) 
    TYPE(STATIC) STYPE(3)                 FPOS(19,6.9) SIZE(15,15) CAPTION(427)  GROUPS('POKLADHD') 

  TYPE(TEXT) CAPTION(Úèetní doklady)      CPOS( 2,8) CLEN(15) FONT(2) 
  TYPE(TEXT) NAME(M->ZPRAC)               CPOS(22,8) CLEN( 7) FONT(2) BGND(13) GROUPS('UCETDOHD:3::::dphKoh_UCD()') PICTURE(999%)
    TYPE(STATIC) FPOS(32,8) SIZE(62,1) STYPE(13) CTYPE(1)                      GROUPS('UCETDOHD') 
    TYPE(END) 
    TYPE(STATIC) STYPE(3)                 FPOS(19,8.2) SIZE(15,15) CAPTION(427)  GROUPS('UCETDOHD') 

  TYPE(TEXT) CAPTION(Kasa)                CPOS( 2,9.3) CLEN(15) FONT(2) 
  TYPE(TEXT) NAME(M->ZPRAC)               CPOS(22,9.3) CLEN( 7) FONT(2) BGND(13) GROUPS('POKLHD:4:POKLIT:2:STRZERO(POKLHD->nKASA,3) +STRZERO(POKLHD->nCISFAK,10):dphKoh_POP()') PICTURE(999%)
    TYPE(STATIC) FPOS(32,9.3) SIZE(62,1) STYPE(13) CTYPE(1)                      GROUPS('POKLHD') 
    TYPE(END) 
    TYPE(STATIC) STYPE(3)                 FPOS(19,9.5) SIZE(15,15) CAPTION(427)  GROUPS('POKLHD') 


 TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)



