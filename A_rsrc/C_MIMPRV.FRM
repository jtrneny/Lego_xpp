TYPE(drgForm) DTYPE(2) TITLE(Èíselník mimopracovních vztahù) SIZE(60,15) FILE(C_MIMPRV);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_MIMPRV) FIELDS(nMimoPrVzt,cNazMimPrV:název mimoPr_Vztahu:47) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nMimoPrVzt) FPOS(15,1)  FLEN(2)  FCAPTION(Klíè mimoPr vztahu)          CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazMimPrV) FPOS(15,2) FLEN(30) FCAPTION(Název mimopracovního vztahu)  CPOS(1,2)
TYPE(End)
