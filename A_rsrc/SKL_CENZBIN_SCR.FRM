TYPE(drgForm) DTYPE(10) TITLE(Inventury skladových karet) SIZE(120,25) FILE(CENZB_IN);
              GUILOOK(Action:n,IconBar:y,Menu:y)

* Seznam inventurních záznamù
  TYPE(EBrowse) FILE(CENZB_IN)  INDEXORD(1);
                FPOS(0,0) SIZE(118,22) CURSORMODE(3) RESIZE(yy) SCROLL(ny) PP(7) POPUPMENU(y)

    TYPE(TEXT) NAME(CENZB_IN->DDATINVEN)    FPOS( 1,0) CLEN( 10)  FCAPTION( DatumInv)
    TYPE(TEXT) NAME(CENZB_IN->CCISSKLAD)    FPOS( 2,0) CLEN(  8)  FCAPTION( Sklad   )
    TYPE(TEXT) NAME(CENZB_IN->CSKLPOL)      FPOS( 3,0) CLEN( 15)  FCAPTION( SklPol  )
    TYPE(TEXT) NAME(CENZB_IN->CNAZZBO)      FPOS( 4,0) CLEN( 30)  FCAPTION( NazZbo  )
    TYPE(TEXT) NAME(CENZB_IN->NZBOZIKAT)    FPOS( 5,0) CLEN(  4)  FCAPTION( Kateg   )
    TYPE(TEXT) NAME(CENZB_IN->NUCETSKUP)    FPOS( 6,0) CLEN(  6)  FCAPTION( ÚèetSku )
    TYPE(TEXT) NAME(CENZB_IN->NMNOZSZBO)    FPOS( 7,0) CLEN( 14)  FCAPTION( SklMnož )
    TYPE(GET)  NAME(CENZB_IN->NMNOZIZBO)     FPOS( 8,0) FLEN( 14)  FCAPTION( InvMnož )
    TYPE(GET)  NAME(CENZB_IN->NMNOZIrZBO)    FPOS( 9,0) FLEN( 12)  FCAPTION( InvRozd )
    TYPE(TEXT) NAME(CENZB_IN->NCENASZBO)    FPOS(10,0) CLEN( 12)  FCAPTION( SklCena )
    TYPE(TEXT) NAME(CENZB_IN->NCENACZBO)    FPOS(11,0) CLEN( 12)  FCAPTION( CenaCelk)

 TYPE(End)

  TYPE(Static) STYPE(7) SIZE(113,2.5) FPOS(1,22.2) RESIZE(y)
* Spuštìní nové imventury
    TYPE(PushButton) POS(2,0.9) SIZE(20,1.2) CAPTION(~Nová inventura ke dni) EVENT(Inventura_INS);
      ICON1(107) ICON2(207) ATYPE(3)
    TYPE(GET) NAME(M->dDatumINS)   FPOS(23,0.8) FLEN(10) PP(2) POST( DatumINV)

* Zrušení inventury
    TYPE(PushButton) POS(70,0.9) SIZE(22,1.2) CAPTION(~Zrušení inventury ke dni) EVENT(Inventura_DEL) ;
      ICON1(110) ICON2(210) ATYPE(3)
    TYPE(GET) NAME(M->dDatumDEL)   FPOS(93,0.8) FLEN(10) PP(2) POST( DatumINV)

  TYPE(CHECKBOX) NAME(M->lALL)  FPOS(35, 0.8) FLEN(25) ItemSelected( CheckItemSelected) ;
                 VALUES(F:vèetnì neceníkových položek ,T:vèetnì neceníkových položek )

  TYPE(End)


TYPE(END)