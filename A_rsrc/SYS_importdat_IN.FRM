TYPE(drgForm) DTYPE(10) TITLE( Import dat do ASYSTEM++ - definice) SIZE(100,26);
              GUILOOK( Menu:y)

TYPE(Action) CAPTION(~Start  >>)  EVENT(runImport) TIPTEXT( Spuštìní importu dat do systému)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

  TYPE(EBrowse) FPOS(0.5,1.5) SIZE(99,12.4) FILE(ImpDatHd)  INDEXORD(1);
                CURSORMODE(3) PP(6) ITEMMARKED(itemMarked) SCROLL(ny) POPUPMENU(yy)
    TYPE(TEXT) NAME(impdathd->cIDimpDatH)
    TYPE(GET)  NAME(impdathd->cTask)
    TYPE(GET)  NAME(impdathd->cZkrImport)
    TYPE(GET)  NAME(impdathd->cNazImport)
    TYPE(MLE)  NAME(impdathd->mBlok)
    TYPE(MLE)  NAME(impdathd->mProtokol)                       
    TYPE(MLE)  NAME(impdathd->mMetodika)  CAPTION(Metodika)                                          
    TYPE(MLE)  NAME(impdathd->mPoznamka)  CAPTION(Poznámka)                                          
  TYPE(END)              

