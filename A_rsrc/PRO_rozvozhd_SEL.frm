TYPE(drgForm) DTYPE(10) TITLE(Nastaven� rozvoz� zbo�� ...) FILE(rozvozhd) SIZE(100,15) ;
                                                           GUILOOK(Menu:n)             ;
                                                           PRE(preValidate)            ; 
                                                           POST(postValidate)



* 1 - rozvozhd
  TYPE(EBrowse) FPOS(0,0) SIZE(100,15) FILE(rozvozhd)                                            ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
 
    TYPE(GET)      NAME(rozvozhd->ndoklad)       FLEN(10)          CAPTION(��sRozvozu)
    TYPE(GET)      NAME(rozvozhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(rozvozhd->cnazrozvoz)    FLEN(10)          CAPTION(n�zRozvozu)

    TYPE(GET)      NAME(rozvozhd->ccistrasy)     FLEN( 7)          CAPTION(��sTrasy)
    TYPE(GET)      NAME(rozvozhd->cnaztrasy)     FLEN(10)          CAPTION(n�zTrasy)

    TYPE(GET)      NAME(rozvozhd->nstroj)        FLEN(10)          CAPTION(��sAutomobilu)   PUSH(pro_stroje_in)

    TYPE(GET)      NAME(rozvozhd->nCisOsoby)     FLEN( 7)          CAPTION(��s�idi�e)       PUSH(osb_osoby_sel)
    TYPE(GET)      NAME(rozvozhd->cJmenoRozl)    FLEN(20)          CAPTION(jm�no�idi�e)

    TYPE(GET)      NAME(rozvozhd->ncisFirDOP)    FLEN( 7)          CAPTION(��sDopravce)     PUSH(fir_firmy_sel)
    TYPE(GET)      NAME(rozvozhd->cnazevDOP)     FLEN(20)          CAPTION(n�zDopravce)

    TYPE(GET)      NAME(rozvozhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)      PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasOdjezd)    FLEN(12)          CAPTION(�asOdjezdu) 
    TYPE(GET)      NAME(rozvozhd->dPrijezd)      FLEN(12)          CAPTION(datP��jezdu)     PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasPrijezd)   FLEN(12)          CAPTION(�asP��jezdu)
  TYPE(END)

* horn� nastaven�
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletn� seznam nastaven�) EVENT(createContext) RESIZE(x)

  TYPE(DBrowse) FPOS(0,0) SIZE(0,0) FILE(rozvozit)                  ;
                                    FIELDS( CCISZAKAZI:zak�zka:12 ) ;
                                    INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(n)

TYPE(END)



