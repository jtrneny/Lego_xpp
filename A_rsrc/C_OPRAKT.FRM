TYPE(drgForm) DTYPE(2) TITLE(Èíselník oprávnìní ) SIZE(60,15) FILE(C_OPRAKT);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_OPRAKT) FIELDS(nKodOprAkt,cNazOprAkt,cKodPrer,mcKODprer,nKodPrer,mnKODprer);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nKodOprAkt) FPOS( 1,1)  FLEN(15) FCAPTION(Kód opravnìní akt.)   CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazOprAkt) FPOS(15,2) FLEN(30) FCAPTION(Název oprávnìní akt.)  CPOS(1,2)
  TYPE(GET) NAME(cKodPrer)   FPOS(15,3) FLEN(10) FCAPTION(Kód pøerušení-text)    CPOS(1,3)
  TYPE(GET) NAME(mcKodPrer)  FPOS(15,4) FLEN(30) FCAPTION(Obsah)                 CPOS(1,4)
  TYPE(GET) NAME(nKodPrer)   FPOS(15,5) FLEN(10) FCAPTION(Kód pøerušení-num.)    CPOS(1,5)
  TYPE(GET) NAME(mnKodPrer)  FPOS(15,6) FLEN(30) FCAPTION(Obsah)                 CPOS(1,6)
TYPE(End)
