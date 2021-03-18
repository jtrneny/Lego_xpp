TYPE(drgForm) DTYPE(2) TITLE(»ÌselnÌk zdravotnÌch pojiöùoven) SIZE(60,15) FILE(C_ZDRPOJ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_ZDRPOJ) FIELDS(nZdrPojis,cNazZdrPoj,cZkrZdrPoj,nCisFirmy);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nZdrPojis)  FPOS(15,1) FLEN(3)  FCAPTION(KÛd zdr.pojiöùovny) CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazZdrPoj) FPOS(15,2) FLEN(25) FCAPTION(N·zev zdravotnÌ pojiöùovny) CPOS(1,2)
  TYPE(GET) NAME(cZkrZdrPoj) FPOS(15,3) FLEN(10) FCAPTION(Zkratka zdravotnÌ pojiöùovny) CPOS(1,3)
  TYPE(GET) NAME(nCisFirmy)  FPOS(15,4) FLEN(5)  FCAPTION(»Ìslo firmy) CPOS(1,4)
TYPE(End)
