TYPE(drgForm) DTYPE(10) TITLE(Pl�nov�n� rozvoz� zbo�� ...) FILE(plrotrhd) SIZE(120,25) ;
                                                                   PRE(preValidate)            ; 
                                                                   POST(postValidate)


*TYPE(Action) CAPTION(cen�k_~Firmy) EVENT(PRO_procenfi_IN)  TIPTEXT(Nastaven� vazby mezi cen�ky/firmy)
*TYPE(Action) CAPTION(cen�k_~Kopie) EVENT(PRO_procenhd_CPY) TIPTEXT(Vytvo�en� kopie cen�ku)


TYPE(TabPage) FPOS(0,0) SIZE(120,24.8) TTYPE(3) OFFSET( 0.8,89) CAPTION(pl�n_trasy) PRE(tabSelect) EXT() SUBTABS(A1,A2,A3)

* 1 - procenhd
  TYPE(EBrowse) FPOS(0,0) SIZE(120,9.7) FILE(rozvozhd)                                                     ;
                                        INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)
   
*    TYPE(TEXT)     NAME(       M->hlaProCen)           CLEN( 2) CAPTION() BITMAP()
*    TYPE(TEXT)     NAME(procenhd->ncisProCen)          CLEN(11) CAPTION(��sloCen�ku) 
*    TYPE(COMBOBOX) NAME(procenhd->ntypprocen) FLEN(20) VALUES(1:Prodejn� cena             , ; 
*                                                              2:Mno�stevn� sleva          , ;
*                                                              3:Sleva na zbo��  -obrat    , ;
*                                                              4:Sleva na zbo��  -fakturace, ;
*                                                              5:Sleva na doklad -obrat    , ;
*                                                              6:Sleva na doklad -fakturace  ) CAPTION(prodejn� cen�k)

*    TYPE(GET)      NAME(rozvozhd->ctypdoklad)    FLEN(10)          CAPTION(typDokladu)
*    TYPE(GET)      NAME(rozvozhd->ctyppohybu)    FLEN(10)          CAPTION(typPohybu)
    TYPE(GET)      NAME(plrotrhd->ndoklad)       FLEN(10)          CAPTION(��sRozvozu)
    TYPE(GET)      NAME(plrotrhd->crozvoz)       FLEN(10)          CAPTION(oznRozvozu)
    TYPE(GET)      NAME(plrotrhd->cnazrozvoz)    FLEN(10)          CAPTION(n�zRozvozu)

    TYPE(GET)      NAME(plrotrhd->ccistrasy)     FLEN( 7)          CAPTION(��sTrasy)
    TYPE(GET)      NAME(plrotrhd->cnaztrasy)     FLEN(10)          CAPTION(n�zTrasy)

    TYPE(GET)      NAME(plrotrhd->nstroj)        FLEN(10)          CAPTION(��sAutomobilu)

    TYPE(GET)      NAME(plrotrhd->nCisOsoby)     FLEN( 7)          CAPTION(��s�idi�e)
    TYPE(GET)      NAME(plrotrhd->cJmenoRozl)    FLEN(20)          CAPTION(jm�no�idi�e)

    TYPE(GET)      NAME(plrotrhd->ncisFirDOP)    FLEN( 7)          CAPTION(��sDopravce)
    TYPE(GET)      NAME(plrotrhd->cnazevDOP)     FLEN(20)          CAPTION(n�zDopravce)

    TYPE(GET)      NAME(plrotrhd->dOdjezd)       FLEN(12)          CAPTION(datOdjezdu)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrhd->cCasOdjezd)    FLEN(12)          CAPTION(�asOdjezdu) 
    TYPE(GET)      NAME(plrotrhd->dPrijezd)      FLEN(12)          CAPTION(datP��jezdu) PUSH(clickdate)
    TYPE(GET)      NAME(plrotrhd->cCasPrijezd)   FLEN(12)          CAPTION(�asP��jezdu)


*    TYPE(GET)      NAME(rozvozhd->ncisfirmy)  FLEN( 7)          CAPTION(firma)         PUSH(fir_firmy_sel) 
*    TYPE(TEXT)     NAME(       M->nazFirmy)   CLEN(25)          CAPTION(n�zev firmy)
*    TYPE(GET)      NAME(procenhd->czkratmeny) FLEN( 7)          CAPTION(m�na)
  TYPE(END)


* 2 - procenit 
*     typ --> 1.2.3.4 - column 1,2,3,5
*     typ --> 5.6     - column 4,5
*
   TYPE(TabPage) FPOS(0,10.8) SIZE(119.8,1.1) CAPTION(Trasa)    OFFSET( 1,82) PRE(tabSelect) SUB(A1) RESIZE(yx)
     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)
*   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(sklPolo�ky)  OFFSET(17,67) PRE(tabSelect) SUB(A2) RESIZE(yx)
*     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*   TYPE(End)
*   TYPE(TabPage) FPOS(0,10.8) SIZE(65.8,1.1) CAPTION(katZbo��)    OFFSET(32,52) PRE(tabSelect) SUB(A3) RESIZE(yx)
*     TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*   TYPE(End)
*                      
  TYPE(EBrowse) FPOS(0,10.8) SIZE(119.0,12.8) FILE(rozvozit)                                            ;
                                            INDEXORD(1) CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) POPUPMENU(y)

    TYPE(GET)      NAME(plrotrit->nCisDodavk)    FLEN(10)             CAPTION(po�Dod�vky)
    TYPE(GET)      NAME(plrotrit->cCisZakazI)    FLEN(10)             CAPTION(polZak�zky)

    TYPE(GET)      NAME(plrotrit->cNazDodavk)    FLEN(25)             CAPTION(n�zDod�vky)

    TYPE(GET)      NAME(plrotrit->nCisFirmy)     FLEN(8)              CAPTION(��sOdb�ratele)
    TYPE(GET)      NAME(plrotrit->cNazFirmy)     FLEN(25)             CAPTION(n�zOdb�ratele)

    TYPE(GET)      NAME(plrotrit->dNakladky)        FLEN(12)          CAPTION(datNakl�dky)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrit->cCasNaklad)       FLEN(12)          CAPTION(�asNakl�dky) 
    TYPE(GET)      NAME(plrotrit->dVykladky)        FLEN(12)          CAPTION(datVykl�dky)  PUSH(clickdate)
    TYPE(GET)      NAME(plrotrit->cCasVyklad)       FLEN(12)          CAPTION(�asVykl�dky)

*    TYPE(TEXT)     NAME(procenit->ccissklad)             CLEN( 6)  CAPTION(sklad)
*    TYPE(GET)      NAME(procenit->csklpol)    FLEN(15)             CAPTION(sklPolo�ka) PUSH(skl_cenzboz_sel)
*    TYPE(GET)      NAME(procenit->nzbozikat)  FLEN( 5)             CAPTION(katZbo)
*    TYPE(GET)      NAME(procenit->czkrtypuhr) FLEN( 5)             CAPTION(typ�hr)
*    TYPE(TEXT)     NAME(M->nazZbo)                       CLEN(35)  CAPTION(n�zev polo�ky)
  TYPE(END) 

* ��rky pro odd�l�n� oblast�
*  TYPE(Static) FPOS(0.1,9.45) SIZE(119.9,.6) STYPE(7)
*  TYPE(End)
*  TYPE(Static) FPOS(65.714,9.5) SIZE(.5,15.4) STYPE(7) CTYPE(2)
*  TYPE(End)

* horn� nastaven�
  TYPE(PushButton) POS(104,0.1) SIZE(35,1) CAPTION(Kopletn� seznam nastaven�) EVENT(createContext) RESIZE(x)

TYPE(END)



