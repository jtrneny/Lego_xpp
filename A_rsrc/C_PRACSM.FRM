TYPE(drgForm) DTYPE(2) TITLE(Èíselník pracovních smìn) SIZE(65,17) FILE(C_PRACSM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRACSM) FIELDS(cTypSmeny,cNazSmeny,cRanSmeZac,cRanSmeKon,cRanSmeDel,lRanPruzna,cOdpSmeZac,cOdpSmeKon, ;
                                                  cOdpSmeDel,lOdpPruzna,cNocSmeZac,cNocSmeKon,cNocSmeDel,lNocPruzna,nTypPruzna,          ;
                                                  nPresCas,nPresZaCas)                                                                  ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypSmeny) FPOS( 15, 1)  FLEN(15) FCAPTION(Typ smìny)             CPOS(1, 1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazSmeny)  FPOS(15, 2) FLEN(30) FCAPTION(Název smìny)            CPOS(1, 2)

  TYPE(TEXT) CAPTION( Zaèátek          Konec              Délka               Pružná/Pevná)       CPOS(15,4) 

  TYPE(GET)      NAME(cRanSmeZac) FPOS(15, 5) FLEN(7) PICTURE(99:99) FCAPTION(Ranní smìna)        CPOS(1,5) 
  TYPE(GET)      NAME(cRanSmeKon) FPOS(25, 5) FLEN(7) PICTURE(99:99)
  TYPE(GET)      NAME(cRanSmeDel) FPOS(35, 5) FLEN(7) PICTURE(99:99)
  TYPE(CHECKBOX) NAME(lRanPruzna) FPOS(47, 5) FLEN(7) CPOS(1,4) VALUES(F:pevná,T:pružná) CLEN(16)   

  TYPE(GET)      NAME(cOdpSmeZac) FPOS(15, 6) FLEN(7) PICTURE(99:99) FCAPTION(Odpolední smìna)    CPOS(1,6)
  TYPE(GET)      NAME(cOdpSmeKon) FPOS(25, 6) FLEN(7) PICTURE(99:99)
  TYPE(GET)      NAME(cOdpSmeDel) FPOS(35, 6) FLEN(7) PICTURE(99:99)
  TYPE(CHECKBOX) NAME(lOdpPruzna) FPOS(47, 6) FLEN(7) CPOS(1,4) VALUES(F:pevná,T:pružná) CLEN(16)        

  TYPE(GET)      NAME(cNocSmeZac) FPOS(15, 7) FLEN(7) PICTURE(99:99) FCAPTION(Noèní smìna)        CPOS(1, 7)
  TYPE(GET)      NAME(cNocSmeKon) FPOS(25, 7) FLEN(7) PICTURE(99:99)
  TYPE(GET)      NAME(cNocSmeDel) FPOS(35, 7) FLEN(7) PICTURE(99:99)
  TYPE(CHECKBOX) NAME(lNocPruzna) FPOS(47, 7) FLEN(7) CPOS(1,4) VALUES(F:pevná,T:pružná) CLEN(16)      

  TYPE(GET)      NAME(nKodZaokr)  FPOS(15, 8) FLEN(7) FCAPTION(Kód zaokr.èist èas)     CPOS(1, 8)
  TYPE(GET)      NAME(nKodZaokKS) FPOS(15, 9) FLEN(7) FCAPTION(Kód zaokr.konc smìny)   CPOS(1, 9)

  TYPE(GET)      NAME(nTypPruzna) FPOS(15,11) FLEN(4)  FCAPTION(Typ pružné smìny)    CPOS(1,11)
  TYPE(GET)      NAME(nPresCas)   FPOS(15,12) FLEN(10) FCAPTION(Délka pøestavky)     CPOS(1,12)
  TYPE(GET)      NAME(nPresZaCas) FPOS(15,13) FLEN(10) FCAPTION(Pøest.po èase)       CPOS(1,13)
TYPE(End)
