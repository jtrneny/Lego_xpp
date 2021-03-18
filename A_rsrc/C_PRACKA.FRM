TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù pracovních kalendáøù) SIZE(60,15) FILE(C_PRACKA);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRACKA) FIELDS(cTypPraKal:Typ,cNazPraKal:Název,cTypSmeny1,cTypSmeny2,cTypSmeny3,cTypSmeny4,cTypSmeny5,cTypSmeny6)           ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypPraKal)  FPOS(15,1)  FLEN(15) FCAPTION(Typ kalendáøe)              CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazPraKal)  FPOS(15,2)  FLEN(30) FCAPTION(Název kalendáøe)            CPOS(1,2)

  TYPE(GET) NAME(cTypSmeny1)  FPOS(15,4)  FLEN(15) FCAPTION(Smìna pro první  týden)     CPOS(1,4)
  TYPE(GET) NAME(cTypSmeny2)  FPOS(15,5)  FLEN(15) FCAPTION(Smìna pro druhý  týden)     CPOS(1,5)
  TYPE(GET) NAME(cTypSmeny3)  FPOS(15,6)  FLEN(15) FCAPTION(Smìna pro tøetí  týden)     CPOS(1,6)
  TYPE(GET) NAME(cTypSmeny4)  FPOS(15,7)  FLEN(15) FCAPTION(Smìna pro ètvrtý týden)     CPOS(1,7)
  TYPE(GET) NAME(cTypSmeny5)  FPOS(15,8)  FLEN(15) FCAPTION(Smìna pro pátý   týden)     CPOS(1,8)
  TYPE(GET) NAME(cTypSmeny6)  FPOS(15,9)  FLEN(15) FCAPTION(Smìna pro šestý  týden)     CPOS(1,9)


TYPE(End)
