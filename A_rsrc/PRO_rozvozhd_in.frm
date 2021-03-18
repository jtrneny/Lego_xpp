TYPE(drgForm) DTYPE(10) TITLE(Nastavení rozvozù zboží ...) FILE(rozvozhd) SIZE(120,25) ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)



TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(rozvozy) PRE(tabSelect) EXT() SUBTABS(A1,A2,A3)

* 1 - rozvozhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,9.7) FILE(rozvozhd)                                            ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
 
    TYPE(GET)      NAME(rozvozhd->ndoklad)       FLEN(10)          CAPTION(èísRozvozu)
    TYPE(GET)      NAME(rozvozhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(rozvozhd->cnazrozvoz)    FLEN(10)          CAPTION(názRozvozu)

    TYPE(GET)      NAME(rozvozhd->ccistrasy)     FLEN( 7)          CAPTION(èísTrasy)
    TYPE(GET)      NAME(rozvozhd->cnaztrasy)     FLEN(10)          CAPTION(názTrasy)

    TYPE(GET)      NAME(rozvozhd->nstroj)        FLEN(10)          CAPTION(èísAutomobilu)   PUSH(pro_stroje_in)
    TYPE(GET)      NAME(rozvozhd->nstroj_2)      FLEN(10)          CAPTION(èísPøívìsu)      PUSH(pro_stroje_in)

    TYPE(GET)      NAME(rozvozhd->nCisOsoby)     FLEN( 7)          CAPTION(èísØidièe)       PUSH(osb_osoby_sel)
    TYPE(GET)      NAME(rozvozhd->cJmenoRozl)    FLEN(20)          CAPTION(jménoØidièe)

    TYPE(GET)      NAME(rozvozhd->ncisFirDOP)    FLEN( 7)          CAPTION(èísDopravce)     PUSH(fir_firmydop_sel)
    TYPE(GET)      NAME(rozvozhd->cnazevDOP)     FLEN(20)          CAPTION(názDopravce)

    TYPE(GET)      NAME(rozvozhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)      PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasOdjezd)    FLEN(12)          CAPTION(èasOdjezdu) 
    TYPE(GET)      NAME(rozvozhd->dPrijezd)      FLEN(12)          CAPTION(datPøíjezdu)     PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasPrijezd)   FLEN(12)          CAPTION(èasPøíjezdu)

    TYPE(MLE)      NAME(rozvozhd->mpoznamka)     FLEN( 20)         FCAPTION(Poznámka)      FONT(5) 
  TYPE(END)


* 2 - rozvozit
   TYPE(TabPage) FPOS(0,10.8) SIZE(119.8,1.1) CAPTION(Trasa)    OFFSET( 1,82) PRE(tabSelect) SUB(A1) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
*                      
  TYPE(EBrowse) FPOS(0,10.8) SIZE(119.0,12.8) FILE(rozvozit)                                            ;
                                            INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(y)

    TYPE(GET)      NAME(rozvozit->nCisDodavk)    FLEN(10)             CAPTION(poøDodávky)
    TYPE(GET)      NAME(rozvozit->cCisZakazI)    FLEN(10)             CAPTION(polZakázky)     PUSH(vyr_vyrzakit_sel)

    TYPE(GET)      NAME(rozvozit->cNazDodavk)    FLEN(25)             CAPTION(názDodávky)

    TYPE(GET)      NAME(rozvozit->nCisFirmy)     FLEN(8)              CAPTION(èísOdbìratele)  PUSH(fir_firmy_sel)
    TYPE(TEXT)     NAME(rozvozit->cNazFirmy)     FLEN(25)             CAPTION(názOdbìratele)

    TYPE(GET)      NAME(rozvozit->dNakladky)        FLEN(12)          CAPTION(datNakládky)    PUSH(clickdate)
    TYPE(GET)      NAME(rozvozit->cCasNaklad)       FLEN(12)          CAPTION(èasNakládky) 
    TYPE(GET)      NAME(rozvozit->dVykladky)        FLEN(12)          CAPTION(datVykládky)    PUSH(clickdate)
    TYPE(GET)      NAME(rozvozit->cCasVyklad)       FLEN(12)          CAPTION(èasVykládky)
  TYPE(END) 

* èárky pro oddìlìní oblastí
*  TYPE(Static) FPOS(0.1,9.45) SIZE(119.9,.6) STYPE(7)
*  TYPE(End)
*  TYPE(Static) FPOS(65.714,9.5) SIZE(.5,15.4) STYPE(7) CTYPE(2)
*  TYPE(End)

* horní nastavení
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletní seznam nastavení) EVENT(createContext) RESIZE(x)

TYPE(END)



