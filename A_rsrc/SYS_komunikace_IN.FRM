TYPE(drgForm) DTYPE(10) TITLE( Datová komunikace ASYSTEM++ - definice) SIZE(100,26);
              GUILOOK( Menu:y)

TYPE(Action) CAPTION(~Start )  EVENT(runDatKom) TIPTEXT( Spuštìní komunikace)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

  TYPE(EBrowse) FPOS(0.5,1.5) SIZE(99,12.4) FILE(DatKomHd)  INDEXORD(1);
                FIELDS(M->typ_datkom) ;
                CURSORMODE(3) PP(6) ITEMMARKED(itemMarked) SCROLL(ny) POPUPMENU(yy)
                    
*    TYPE(TEXT)     NAME(M->typ_datkom) BGND(14)
    TYPE(TEXT)     NAME(datkomhd->cIDDatKom)
    TYPE(GET)      NAME(datkomhd->cTask)
    TYPE(COMBOBOX) NAME(datkomhd->cTypDatKom) FPOS( 1,0) FLEN(15)        ; 
                                                VALUES( I:Import       , ;
                                                        E:Export  )
    TYPE(GET)      NAME(datkomhd->cZkrDatKom)
    TYPE(GET)      NAME(datkomhd->cNazDatKom)
    TYPE(MLE)      NAME(datkomhd->mBlok)
    TYPE(MLE)      NAME(datkomhd->mProtokol)                       
    TYPE(TEXT)     NAME(datkomhd->nCntDatKom)                       
    TYPE(MLE)      NAME(datkomhd->mMetodika)  CAPTION(Metodika)                                          
    TYPE(MLE)      NAME(datkomhd->mPoznamka)  CAPTION(Poznámka)                                          
  TYPE(END)              

TYPE(END)              
