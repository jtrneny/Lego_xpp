TYPE(drgForm) DTYPE(10) TITLE(Plánování rozvozù zboží ...) FILE(plrotrhd) SIZE(120,25) ;
                                                                   PRE(preValidate)            ; 
                                                                   POST(postValidate)


*TYPE(Action) CAPTION(ceník_~Firmy) EVENT(PRO_procenfi_IN)  TIPTEXT(Nastavení vazby mezi ceníky/firmy)
*TYPE(Action) CAPTION(ceník_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvoøení kopie ceníku)


TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(plán_trasy) PRE(tabSelect) EXT() SUBTABS(A1,A2,A3)

* 1 - procenhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,9.7) FILE(rozvozhd)                                                     ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
   
*    TYPE(TEXT)     NAME(       M->hlaProCen)           CLEN( 2) CAPTION() BITMAP()
*    TYPE(TEXT)     NAME(procenhd->ncisProCen)          CLEN(11) CAPTION(èísloCeníku) 
*    TYPE(COMBOBOX) NAME(procenhd->ntypprocen) FLEN(20) VALUES(1:Prodejní cena             , ; 
*                                                              2:Množstevní sleva          , ;
*                                                              3:Sleva na zboží  -obrat    , ;
*                                                              4:Sleva na zboží  -fakturace, ;
*                                                              5:Sleva na doklad -obrat    , ;
*                                                              6:Sleva na doklad -fakturace  ) CAPTION(prodejní ceník)

*    TYPE(GET)      NAME(rozvozhd->ctypdoklad)    FLEN(10)          CAPTION(typDokladu)
*    TYPE(GET)      NAME(rozvozhd->ctyppohybu)    FLEN(10)          CAPTION(typPohybu)
    TYPE(GET)      NAME(plrotrhd->ndoklad)       FLEN(10)          CAPTION(èísRozvozu)
    TYPE(GET)      NAME(plrotrhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(plrotrhd->cnazrozvoz)    FLEN(10)          CAPTION(názRozvozu)

    TYPE(GET)      NAME(plrotrhd->ccistrasy)     FLEN( 7)          CAPTION(èísTrasy)
    TYPE(GET)      NAME(plrotrhd->cnaztrasy)     FLEN(10)          CAPTION(názTrasy)

    TYPE(GET)      NAME(plrotrhd->nstroj)        FLEN(10)          CAPTION(èísAutomobilu)

    TYPE(GET)      NAME(plrotrhd->nCisOsoby)     FLEN( 7)          CAPTION(èísØidièe)
    TYPE(GET)      NAME(plrotrhd->cJmenoRozl)    FLEN(20)          CAPTION(jménoØidièe)

    TYPE(GET)      NAME(plrotrhd->ncisFirDOP)    FLEN( 7)          CAPTION(èísDopravce)
    TYPE(GET)      NAME(plrotrhd->cnazevDOP)     FLEN(20)          CAPTION(názDopravce)

    TYPE(GET)      NAME(plrotrhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrhd->cCasOdjezd)    FLEN(12)          CAPTION(èasOdjezdu) 
    TYPE(GET)      NAME(plrotrhd->dPrijezd)      FLEN(12)          CAPTION(datPøíjezdu) PUSH(clickdate)
    TYPE(GET)      NAME(plrotrhd->cCasPrijezd)   FLEN(12)          CAPTION(èasPøíjezdu)


*    TYPE(GET)      NAME(rozvozhd->ncisfirmy)  FLEN( 7)          CAPTION(firma)         PUSH(fir_firmy_sel) 
*    TYPE(TEXT)     NAME(       M->nazFirmy)   CLEN(25)          CAPTION(název firmy)
*    TYPE(GET)      NAME(procenhd->czkratmeny) FLEN( 7)          CAPTION(mìna)
  TYPE(END)


* 2 - procenit 
*     typ --> 1.2.3.4 - column 1,2,3,5
*     typ --> 5.6     - column 4,5
*
   TYPE(TabPage) FPOS(0,10.8) SIZE(119.8,1.1) CAPTION(Trasa)    OFFSET( 1,82) PRE(tabSelect) SUB(A1) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
*   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(sklPoložky)  OFFSET(17,67) PRE(tabSelect) SUB(A2) RESIZE(yx)
*     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*   TYPE(End)
*   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(katZboží)    OFFSET(32,52) PRE(tabSelect) SUB(A3) RESIZE(yx)
*     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*   TYPE(End)
*                      
  TYPE(EBrowse) FPOS(0,10.8) SIZE(119.0,12.8) FILE(rozvozit)                                            ;
                                            INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(y)

    TYPE(GET)      NAME(plrotrit->nCisDodavk)    FLEN(10)             CAPTION(poøDodávky)
    TYPE(GET)      NAME(plrotrit->cCisZakazI)    FLEN(10)             CAPTION(polZakázky)

    TYPE(GET)      NAME(plrotrit->cNazDodavk)    FLEN(25)             CAPTION(názDodávky)

    TYPE(GET)      NAME(plrotrit->nCisFirmy)     FLEN(8)              CAPTION(èísOdbìratele)
    TYPE(GET)      NAME(plrotrit->cNazFirmy)     FLEN(25)             CAPTION(názOdbìratele)

    TYPE(GET)      NAME(plrotrit->dNakladky)        FLEN(12)          CAPTION(datNakládky)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrit->cCasNaklad)       FLEN(12)          CAPTION(èasNakládky) 
    TYPE(GET)      NAME(plrotrit->dVykladky)        FLEN(12)          CAPTION(datVykládky)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrit->cCasVyklad)       FLEN(12)          CAPTION(èasVykládky)

*    TYPE(TEXT)     NAME(procenit->ccissklad)             CLEN( 6)  CAPTION(sklad)
*    TYPE(GET)      NAME(procenit->csklpol)    FLEN(15)             CAPTION(sklPoložka) PUSH(skl_cenzboz_sel)
*    TYPE(GET)      NAME(procenit->nzbozikat)  FLEN( 5)             CAPTION(katZbo)
*    TYPE(GET)      NAME(procenit->czkrtypuhr) FLEN( 5)             CAPTION(typÚhr)
*    TYPE(TEXT)     NAME(M->nazZbo)                       CLEN(35)  CAPTION(název položky)
  TYPE(END) 

* èárky pro oddìlìní oblastí
*  TYPE(Static) FPOS(0.1,9.45) SIZE(119.9,.6) STYPE(7)
*  TYPE(End)
*  TYPE(Static) FPOS(65.714,9.5) SIZE(.5,15.4) STYPE(7) CTYPE(2)
*  TYPE(End)

* horní nastavení
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletní seznam nastavení) EVENT(createContext) RESIZE(x)

TYPE(END)



