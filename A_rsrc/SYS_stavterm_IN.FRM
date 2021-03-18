TYPE(drgForm) DTYPE(10) TITLE( Podporované terminály v ASYSTEM++ - definice) SIZE(100,26);
              GUILOOK( Menu:y)

*TYPE(Action) CAPTION(~Start )  EVENT(runDatKom) TIPTEXT( Spuštìní komunikace)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)


 TYPE(DBrowse)  FPOS(0.5,0.5) SIZE(45,24.4) FILE(C_TERMIN) FIELDS(nPorTermin,cNazTermin,lAktivni,cAdrTerm,cSNTerm,mINITpopis);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) ITEMMARKED(itemMarked) RESIZE(ny)


  TYPE(EBrowse) FPOS(48.5,0.5) SIZE(59,24.4) FILE(STAVTERM)  INDEXORD(1);
                CURSORMODE(3) PP(6)  SCROLL(ny) POPUPMENU(yy) RESIZE(yy)

*ITEMMARKED(itemMarked)
*                FIELDS(M->typ_datkom) ;
                    
*    TYPE(TEXT)     NAME(M->typ_datkom) BGND(14)
    TYPE(TEXT)      NAME(stavterm->czkrterm) LEN(7)
    TYPE(TEXT)      NAME(stavterm->nportermin) CAPTION(Poøadí)
    TYPE(GET)      NAME(stavterm->cstavterm)
    TYPE(GET)      NAME(stavterm->ckodprer)
    TYPE(MLE)      NAME(stavterm->mMetodika)  CAPTION(Metodika)                                          
    TYPE(MLE)      NAME(stavterm->mPoznamka)  CAPTION(Poznámka)                                          
    TYPE(TEXT)     NAME(stavterm->cTask)      CAPTION(Úloha)
    TYPE(TEXT)     NAME(stavterm->cSNterm)    
  TYPE(END)              

TYPE(END)              
