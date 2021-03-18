TYPE(drgForm) DTYPE(10) TITLE(Objednávky pøijaté HLA - VÝBÌR) SIZE(100,20);
               GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

  TYPE(Browse) FILE(OBJHEAD) INDEXORD(1) ;
               FIELDS(cCislObINT:Èís. objednávky  ,;
                      nCisFirmy:Odbìratel         ,;
                      FIRMY->cNazev:Název odbìratele ,;
                      cCisObj:È.obj.odbìratele       ,;
                      dDatObj:Dat.objednání          ,;
                      dDatDoOdb:Dat.dodání           );
               FPOS( 0, 0.2) SIZE(100,9.5) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(ny);
               ITEMMARKED( ItemMarked) ITEMSELECTED( RecordSelected)

  TYPE(Browse) FILE(OBJITEM) INDEXORD(1) ;
               FIELDS(CSKLPOL:Skl. položka  ,;
                      CNAZZBO:Název zboží   ,;
                      nZboziKat:Kat.zboží   ,;
                      nMnozObODB:Mn.objedn. odb. ,;
                      nMnozNeODB:Mn.nepotv. odb. ,;
                      nKcsBDObj:Cena bez danì      );  
               FPOS( 0, 10) SIZE(100,10) CURSORMODE(3) RESIZE(x) PP(7) SCROLL(ny)


