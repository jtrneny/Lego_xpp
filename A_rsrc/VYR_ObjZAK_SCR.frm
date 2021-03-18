TYPE(drgForm) DTYPE(10) TITLE(Objednávky pøijaté);
              SIZE(100,15) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              POST(postValidate)

TYPE(Action) CAPTION(~Pøebrat do zak.) EVENT(ObjItem_wrt) TIPTEXT(Pøebrat mn. potvrzené na zakázku )

  TYPE(EBrowse) FILE(OBJZAKw) INDEXORD(1);
                SIZE(100,14.6) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) FOOTER(y);
                ITEMMARKED( ItemMarked)

    TYPE(TEXT) NAME( OBJZAKw->cCislObInt)   CLEN( 20)  CAPTION(Èíslo obj.pøijaté )
    TYPE(TEXT) NAME( OBJZAKw->nCislPolOb)   CLEN(  5)  CAPTION(Pol.)
    TYPE(TEXT) NAME( OBJZAKw->nMnozObODB)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->dDatOdvVyr)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->nMnozVpINT)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->nMnPotVyr )   CLEN( 12)  CAPTION( Potvrz./CELK.)
    TYPE(GET)  NAME( OBJZAKw->nMnPotVyrZ)   FLEN( 15)  FCAPTION(Potvrz./ZAK  )

  TYPE( END)