TYPE(drgForm) DTYPE(10) TITLE() FILE(PVPHEAD);
              SIZE( 90, 20) GUILOOK(Action:n,IconBar:n,Menu:n) ;
              POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(89,1.4) FPOS(0.5,0.1) RESIZE(yn) GROUPS( clrGREEN)
    TYPE(Text) CAPTION(Párování výdejového dokladu dle V-symbolu) CPOS( 2, 0.2) CLEN( 86) CTYPE(3) FONT(5)
  TYPE(End)

  TYPE(Static) STYPE( 13) SIZE(89, 2.7) FPOS( 0.5, 1.5) RESIZE(yn) GROUPS( clrYELLOW)

    TYPE(Text) CAPTION(Doklad)            CPOS(  3, 0.2)   CLEN( 12)
    TYPE(Text) NAME(nDoklad)              CPOS(  3, 1.2)   CLEN( 12) BGND( 13) CTYPE(2) GROUPS( clrGREY) FONT(5)
    TYPE(Text) CAPTION(Sklad)             CPOS( 17, 0.2)   CLEN(  7)
    TYPE(Text) NAME(cCisSklad)            CPOS( 17, 1.2)   CLEN( 10) BGND( 13) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Pohyb)             CPOS( 29, 0.2)   CLEN(  7)
    TYPE(Text) NAME(cTypPohybu)           CPOS( 29, 1.2)   CLEN( 10) BGND( 13) GROUPS( clrGREY)
    TYPE(Text) CAPTION(Název pohybu)      CPOS( 41, 0.2)   CLEN( 25)
    TYPE(Text) NAME(C_TypPOH->cNazTypPoh) CPOS( 41, 1.2)   CLEN( 30) BGND( 13) GROUPS( clrGREY) FONT(5)
  TYPE(END)
*
  TYPE(EBrowse) FILE(PVPITEMww)  INDEXORD(1);
                FPOS(0, 4.1) SIZE( 90, 14) CURSORMODE(3) SCROLL(yy) PP(7) RESIZE(yy) POPUPMENU(y) ;
                GUILOOK(ins:n,del:n)

    TYPE(TEXT) NAME( PVPITEMww->nDoklad)     FPOS( 1,0) CLEN( 10)  CAPTION( Doklad )
    TYPE(TEXT) NAME( PVPITEMww->nOrdItem)    FPOS( 2,0) CLEN(  7)  CAPTION( Poøadí )
    TYPE(GET)  NAME( PVPITEMww->nCisFak)     FPOS( 3,0) FLEN( 10)  CAPTION( Èís.faktury)
    TYPE(TEXT) NAME( PVPITEMww->cSklPol)     FPOS( 4,0) CLEN( 15)  CAPTION( Skl.položka )
    TYPE(TEXT) NAME( PVPITEMww->cNazZbo)     FPOS( 5,0) CLEN( 45)  CAPTION( Název zboží )

  TYPE(END)
*
  TYPE(Static) STYPE( 13) SIZE(89, 2.3) FPOS( 0.1, 18.2) RESIZE(ny)
    TYPE(PushButton) POS(60, 0.5) SIZE(12,1.2) CAPTION( ~Párování)  EVENT(btn_GoParovani) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(75, 0.5) SIZE(12,1.2) CAPTION(~Storno)     EVENT(140000002)             ICON1(102) ICON2(202) ATYPE(3)
  TYPE(END)
