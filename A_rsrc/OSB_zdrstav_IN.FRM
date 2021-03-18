TYPE(drgForm) DTYPE(10) TITLE(Zdravotní stav) SIZE(100,17) ;
              GUILOOK(Action:n,IconBar:y) CBSAVE(onSave) PRE(PreValidate) POST(postValidate)


* TYPE(Action) CAPTION(~Osoba) EVENT(per_osobakmen_crd)   TIPTEXT(Osoba)
* TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)

  TYPE(Static) SIZE(98,3.8) FPOS(1,.2) RESIZE(yn)

    TYPE(TEXT) CAPTION(Pøíjmení)            CPOS( 1, .34) CLEN(20)
    TYPE(TEXT) CAPTION(Jméno)               CPOS(28, .34) CLEN(15)
    TYPE(TEXT) CAPTION(RozlišeníOsoby)      CPOS(45, .34) CLEN(15)
    TYPE(TEXT) CAPTION(Titul pøed)          CPOS(62, .34) CLEN(15)
    TYPE(TEXT) CAPTION(Titul za)            CPOS(82, .34) CLEN(15)

    TYPE(TEXT)  NAME(osoby->cprijOsob)   CPOS( 1,1.4) CLEN(25) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(osoby->cjmenoOsob)  CPOS(28,1.4) CLEN(15) BGND(13) FONT(5)
    TYPE(TEXT)  NAME(osoby->crozlJmena)  CPOS(45,1.4) CLEN(15) BGND(13) FONT(5) 
    TYPE(TEXT)  NAME(osoby->ctitulPred)  CPOS(62,1.4) CLEN(15) BGND(13)
    TYPE(TEXT)  NAME(osoby->ctitulZa)    CPOS(81,1.4) CLEN(15) BGND(13)

* èíslo osoby
    TYPE(Text)  CAPTION([)                  CPOS( 8,2.45)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE) 
    TYPE(Text)  NAME(osoby->ncisOsoby)   CPOS( 9,2.448) CLEN( 8) CTYPE(3) GROUPS(SETFONT,8.Cambria,GRA_CLR_RED)
    TYPE(Text)  CAPTION(])                  CPOS(16,2.45)  CLEN( 2) CTYPE(2) GROUPS(SETFONT,7.Arial CE)  

  TYPE(END)


*  TYPE(Static) STYPE(13) SIZE(98,10) FPOS(1,4.5) RESIZE(y)
  TYPE(Static) SIZE(98,11.8) FPOS(1,4.5) RESIZE(y)
    TYPE(EBrowse) FPOS(0.5,0.5) SIZE(97,11.4) FILE(ZdrStavy)  INDEXORD(1);
                  CURSORMODE(3) PP(6) ITEMMARKED(itemMarked) SCROLL(ny) POPUPMENU(yy)
      TYPE(GET)      NAME(zdrstavy->nPorZdrSta) FLEN( 5) CAPTION(Poø)
      TYPE(GET)      NAME(zdrstavy->cZkrZdrSta) FLEN( 8) CAPTION(Zkratka) 
      TYPE(TEXT)     NAME(zdrstavy->cNazZdrSta) FLEN(30) CAPTION(Název zdrstav) 
      TYPE(GET)      NAME(zdrstavy->dZdrStavOd) FLEN(10) CAPTION(Zdr stav OD) 
      TYPE(GET)      NAME(zdrstavy->dZdrStavDo) FLEN(10) CAPTION(Zdr stav DO) 
      TYPE(GET)      NAME(zdrstavy->dNarZdrSOd) FLEN(10) CAPTION(Nárok OD) 
      TYPE(GET)      NAME(zdrstavy->dNarZdrSDo) FLEN(10) CAPTION(Nárok DO) 
      TYPE(COMBOBOX) NAME(zdrstavy->lEvidovZP)  FLEN( 7) CAPTION(ZdrPost)                REF(LYESNO) 
      TYPE(COMBOBOX) NAME(zdrstavy->lEvidovZZN) FLEN( 7) CAPTION(ZdrZnev)                REF(LYESNO) 
      TYPE(COMBOBOX) NAME(zdrstavy->cPrukazZPS) FLEN(30) CAPTION(Prùkaz zdr_postiženého) REF(cPRUKAZZPS) 
      TYPE(COMBOBOX) NAME(zdrstavy->lPrukazZPS) FLEN( 7) CAPTION(VlastPrZP)              REF(LYESNO) 
      TYPE(GET)      NAME(zdrstavy->nTypDuchod) FLEN( 5) CAPTION(TypDùch)
      TYPE(TEXT)     NAME(zdrstavy->cNazDuchod) FLEN(30) CAPTION(Název dùchodu) 
      TYPE(MLE)      NAME(zdrstavy->mPoznamka )          CAPTION(Poznámka)                                          

  TYPE(End)
