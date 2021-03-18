TYPE(drgForm) DTYPE(2) TITLE(Èíselník materiálù pro položky) SIZE(70,15) FILE(C_MATPOL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(70,14) FILE(C_MATPOL) ;
                            FIELDS( cZkrMat     ,;
                                    cNazMat::40 );
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrMat)   FPOS(15,1) FLEN(15) FCAPTION(Zkratka materiálu) CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazMat)   FPOS(15,2) FLEN(50) FCAPTION(Název materiálu)   CPOS(1,2) POST( postLastField_2)
TYPE(End)
