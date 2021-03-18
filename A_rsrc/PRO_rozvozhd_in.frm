TYPE(drgForm) DTYPE(10) TITLE(Nastaven� rozvoz� zbo�� ...) FILE(rozvozhd) SIZE(120,25) ;
                                                                   PRE(preValidate)    ; 
                                                                   POST(postValidate)



TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(rozvozy) PRE(tabSelect) EXT() SUBTABS(A1,A2,A3)

* 1 - rozvozhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,9.7) FILE(rozvozhd)                                            ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
 
    TYPE(GET)      NAME(rozvozhd->ndoklad)       FLEN(10)          CAPTION(��sRozvozu)
    TYPE(GET)      NAME(rozvozhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(rozvozhd->cnazrozvoz)    FLEN(10)          CAPTION(n�zRozvozu)

    TYPE(GET)      NAME(rozvozhd->ccistrasy)     FLEN( 7)          CAPTION(��sTrasy)
    TYPE(GET)      NAME(rozvozhd->cnaztrasy)     FLEN(10)          CAPTION(n�zTrasy)

    TYPE(GET)      NAME(rozvozhd->nstroj)        FLEN(10)          CAPTION(��sAutomobilu)   PUSH(pro_stroje_in)
    TYPE(GET)      NAME(rozvozhd->nstroj_2)      FLEN(10)          CAPTION(��sP��v�su)      PUSH(pro_stroje_in)

    TYPE(GET)      NAME(rozvozhd->nCisOsoby)     FLEN( 7)          CAPTION(��s�idi�e)       PUSH(osb_osoby_sel)
    TYPE(GET)      NAME(rozvozhd->cJmenoRozl)    FLEN(20)          CAPTION(jm�no�idi�e)

    TYPE(GET)      NAME(rozvozhd->ncisFirDOP)    FLEN( 7)          CAPTION(��sDopravce)     PUSH(fir_firmydop_sel)
    TYPE(GET)      NAME(rozvozhd->cnazevDOP)     FLEN(20)          CAPTION(n�zDopravce)

    TYPE(GET)      NAME(rozvozhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)      PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasOdjezd)    FLEN(12)          CAPTION(�asOdjezdu) 
    TYPE(GET)      NAME(rozvozhd->dPrijezd)      FLEN(12)          CAPTION(datP��jezdu)     PUSH(clickdate)
    TYPE(GET)      NAME(rozvozhd->cCasPrijezd)   FLEN(12)          CAPTION(�asP��jezdu)

    TYPE(MLE)      NAME(rozvozhd->mpoznamka)     FLEN( 20)         FCAPTION(Pozn�mka)      FONT(5) 
  TYPE(END)


* 2 - rozvozit
   TYPE(TabPage) FPOS(0,10.8) SIZE(119.8,1.1) CAPTION(Trasa)    OFFSET( 1,82) PRE(tabSelect) SUB(A1) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
*                      
  TYPE(EBrowse) FPOS(0,10.8) SIZE(119.0,12.8) FILE(rozvozit)                                            ;
                                            INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(y)

    TYPE(GET)      NAME(rozvozit->nCisDodavk)    FLEN(10)             CAPTION(po�Dod�vky)
    TYPE(GET)      NAME(rozvozit->cCisZakazI)    FLEN(10)             CAPTION(polZak�zky)     PUSH(vyr_vyrzakit_sel)

    TYPE(GET)      NAME(rozvozit->cNazDodavk)    FLEN(25)             CAPTION(n�zDod�vky)

    TYPE(GET)      NAME(rozvozit->nCisFirmy)     FLEN(8)              CAPTION(��sOdb�ratele)  PUSH(fir_firmy_sel)
    TYPE(TEXT)     NAME(rozvozit->cNazFirmy)     FLEN(25)             CAPTION(n�zOdb�ratele)

    TYPE(GET)      NAME(rozvozit->dNakladky)        FLEN(12)          CAPTION(datNakl�dky)    PUSH(clickdate)
    TYPE(GET)      NAME(rozvozit->cCasNaklad)       FLEN(12)          CAPTION(�asNakl�dky) 
    TYPE(GET)      NAME(rozvozit->dVykladky)        FLEN(12)          CAPTION(datVykl�dky)    PUSH(clickdate)
    TYPE(GET)      NAME(rozvozit->cCasVyklad)       FLEN(12)          CAPTION(�asVykl�dky)
  TYPE(END) 

* ��rky pro odd�l�n� oblast�
*  TYPE(Static) FPOS(0.1,9.45) SIZE(119.9,.6) STYPE(7)
*  TYPE(End)
*  TYPE(Static) FPOS(65.714,9.5) SIZE(.5,15.4) STYPE(7) CTYPE(2)
*  TYPE(End)

* horn� nastaven�
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletn� seznam nastaven�) EVENT(createContext) RESIZE(x)

TYPE(END)



