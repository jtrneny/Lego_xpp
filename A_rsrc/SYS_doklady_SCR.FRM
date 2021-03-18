TYPE(drgForm) DTYPE(10) TITLE( Rezervace ) SIZE(100,26);
              GUILOOK( Menu:y)

*TYPE(Action) CAPTION(~Rezervace  >>)  EVENT(RezervaceMenu) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)
*TYPE(Action) CAPTION(~Rezervace)  EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Rezervace na skl.položku nebo obj.pøijatou)

  TYPE(DBrowse) FILE(TypDokl)  INDEXORD(1);
               FIELDS(cUloha:Úloha,                    ;
                      cPodUloha:Podúloha              ,;
                      cTypDoklad:Typ dokladu          ,;
                      cNazTypDok:Název typu dokladu   ,;
                      cTypCRD:Typ vstupní karty       ,;
                      cMainFile:Øídící soubor         ,; 
                      dPlatnyOD:Platnost OD           ,;
                      mCondUcto:Podmínka pro úètování ,;
                      mPopisDokl:Popis dokladu)        ;
               FPOS(0,0.1) SIZE(98,25.4) CURSORMODE(3) SCROLL(ny) PP(7);
               ITEMMARKED(itemMarked) POPUPMENU(y)

