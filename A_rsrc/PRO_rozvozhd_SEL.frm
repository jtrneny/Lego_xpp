TYPE(drgForm) DTYPE(10) TITLE(Nastavení rozvozù zboží ...) FILE(rozvozhd) SIZE(100,15) ;
                                                           GUILOOK(Menu:n)             ;
                                                           PRE(preValidate)            ; 
                                                           POST(postValidate)



* 1 - rozvozhd
  TYPE(EBrowse) FPOS(0,0) SIZE(100,15) FILE(rozvozhd)                                            ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
 
    TYPE(GET)      NAME(rozvozhd->ndoklad)       FLEN(10)          CAPTION(èísRozvozu)
    TYPE(GET)      NAME(rozvozhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(rozvozhd->cnazrozvoz)    FLEN(10)          CAPTION(názRozvozu)

    TYPE(GET)      NAME(rozvozhd->ccistrasy)     FLEN( 7)          CAPTION(èísTrasy)
    TYPE(GET)      NAME(rozvozhd->cnaztrasy)     FLEN(10)          CAPTION(názTrasy)

    TYPE(GET)      NAME(rozvozhd->nstroj)        FLEN(10)          CAPTION(èísAutomobilu)   PUSH(pro_stroje_in)

    TYPE(GET)      NAME(rozvozhd->nCisOsoby)     FLEN( 7)          CAPTION(èísØidièe)       PUSH(osb_osoby_sel)
    TYPE(GET)      NAME(rozvozhd->cJmenoRozl)    FLEN(20)          CAPTION(jménoØidièe)

    TYPE(GET)      NAME(rozvozhd->ncisFirDOP)    FLEN( 7)          CAPTION(èísDopravce)     PUSH(fir_firmy_sel)
    TYPE(GET)      NAME(rozvozhd->cnazevDOP)     FLEN(20)          CAPTION(názDopravce)

    TYPE(GET)      NAME(rozvozhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)      PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasOdjezd)    FLEN(12)          CAPTION(èasOdjezdu) 
    TYPE(GET)      NAME(rozvozhd->dPrijezd)      FLEN(12)          CAPTION(datPøíjezdu)     PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasPrijezd)   FLEN(12)          CAPTION(èasPøíjezdu)
  TYPE(END)

* horní nastavení
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletní seznam nastavení) EVENT(createContext) RESIZE(x)

  TYPE(DBrowse) FPOS(0,0) SIZE(0,0) FILE(rozvozit)                  ;
                                    FIELDS( CCISZAKAZI:zakázka:12 ) ;
                                    INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(n)

TYPE(END)



