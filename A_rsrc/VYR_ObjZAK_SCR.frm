TYPE(drgForm) DTYPE(10) TITLE(Objedn�vky p�ijat�);
              SIZE(100,15) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              POST(postValidate)

TYPE(Action) CAPTION(~P�ebrat do zak.) EVENT(ObjItem_wrt) TIPTEXT(P�ebrat mn. potvrzen� na zak�zku )

  TYPE(EBrowse) FILE(OBJZAKw) INDEXORD(1);
                SIZE(100,14.6) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) FOOTER(y);
                ITEMMARKED( ItemMarked)

    TYPE(TEXT) NAME( OBJZAKw->cCislObInt)   CLEN( 20)  CAPTION(��slo obj.p�ijat� )
    TYPE(TEXT) NAME( OBJZAKw->nCislPolOb)   CLEN(  5)  CAPTION(Pol.)
    TYPE(TEXT) NAME( OBJZAKw->nMnozObODB)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->dDatOdvVyr)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->nMnozVpINT)   CLEN( 12)  CAPTION()
    TYPE(TEXT) NAME( OBJZAKw->nMnPotVyr )   CLEN( 12)  CAPTION( Potvrz./CELK.)
    TYPE(GET)  NAME( OBJZAKw->nMnPotVyrZ)   FLEN( 15)  FCAPTION(Potvrz./ZAK  )

  TYPE( END)