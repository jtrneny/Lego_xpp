TYPE(drgForm) DTYPE(2) TITLE(Èíselník klasifikace zamìstnání - KZAM) SIZE(100,15) FILE(C_KLAZAM);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(99,14) FILE(C_KLAZAM) FIELDS(nKlasZam,cNazKlasZa, cPopisKlZa::56);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nKlasZam)   FPOS(20,1) FLEN(8)  FCAPTION(Klíè klasif_Zam      ...) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazKlasZa) FPOS(20,2) FLEN(30) FCAPTION(Název klasif_Zam ...)     CPOS(1,2)
  TYPE(GET) NAME(cPopisKlZa) FPOS(20,3) FLEN(50) FCAPTION(Popis klasif_Zam   ...)   CPOS(1,3)
TYPE(End)
