TYPE(drgForm) DTYPE(10) TITLE(Zavedení/oprava èíselníkù mìn a podrozvahových úètù) SIZE(100,26) FILE (C_MENY) ;
               GUILOOK(Action:n,IconBar:n)

TYPE(TabPage) TTYPE(3) CAPTION(Zavedení/oprava èís) OFFSET(1,82) RESIZE(xx)

  TYPE(Browse) FILE(C_MENY) INDEXORD(1) ;
               FIELDS(cNAZmeny,cZKRATmeny,nMNOZprep) ;
               SIZE(50,26) FPOS(0,0) ;
               CURSORMODE(3) SCROLL(ny) PP(3) Resize(yy)

  TYPE(Static) STYPE(2) SIZE(49,25) FPOS(50,0) RESIZE(xx)
    TYPE(Text) CAPTION(Závazky)    CPOS(0.5,2)
    TYPE(Text) CAPTION(Pohledávky) CPOS(0.5,8)


TYPE(End)