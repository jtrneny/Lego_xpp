TYPE(drgForm) DTYPE(10) TITLE( Export dat do ASYSTEM++ - definice) SIZE(100,26);
              GUILOOK( Menu:y)

TYPE(Action) CAPTION(~Start  >>)  EVENT(runExport) TIPTEXT( Spuštìní exportu dat do systému)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

  TYPE(EBrowse) FPOS(0.5,1.5) SIZE(99,12.4) FILE(ExpDatHd)  INDEXORD(1);
                CURSORMODE(3) PP(6) ITEMMARKED(itemMarked) SCROLL(ny) POPUPMENU(yy)
    TYPE(TEXT) NAME(expdathd->cIDExpDatH)
    TYPE(GET)  NAME(expdathd->cTask)
    TYPE(GET)  NAME(expdathd->cZkrExport)
    TYPE(GET)  NAME(expdathd->cNazExport)
    TYPE(MLE)  NAME(expdathd->mBlok)
    TYPE(MLE)  NAME(expdathd->mProtokol)                       
    TYPE(MLE)  NAME(expdathd->mMetodika)  CAPTION(Metodika)                     
    TYPE(MLE)  NAME(expdathd->mPoznamka)  CAPTION(Poznámka)                                          
  TYPE(END)              

