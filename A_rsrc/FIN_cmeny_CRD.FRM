TYPE(drgForm) DTYPE(10) TITLE(Zavedení/oprava èíselníkú mìn, mincí a státù) SIZE(100,26) FILE(C_STATY);
               GUILOOK(Action:n,IconBar:n)

TYPE(TabPage) TTYPE(3) CAPTION(Zavedení/oprava èíselníkú mìn, mincí a státù) OFFSET(1,82) RESIZE(xx)

  TYPE(Browse) FILE(C_MENY) INDEXORD(1) ;
               FIELDS(cNAZmeny,cZKRATmeny,nMNOZprep) ;
               SIZE(50,26) FPOS(0,0) ;
               CURSORMODE(3) SCROLL(ny) PP(3) Resize(yy)

  TYPE(Browse) FILE(C_MINCE) INDEXORD(1) ;
               FIELDS(cNAZmince,nHODmince,cZKRmince) ;
               SIZE(50,15) FPOS(50,0) ;
               CURSORMODE(3) SCROLL(ny) PP(3) Resize(yy)

  TYPE(Browse) FILE(C_STATY) INDEXORD(1) ;
               FIELDS(cNAZEVstat,cZKRATstat,cZKRATmeny) ;
               SIZE(50,11) FPOS(50,15) ;
               CURSORMODE(3) SCROLL(ny) PP(3) Resize(yy)
TYPE(End)