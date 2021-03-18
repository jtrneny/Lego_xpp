TYPE(drgForm) DTYPE(2) TITLE(»ÌselnÌk zdravotnÌch pojiöùoven) SIZE(60,15) FILE(C_TYPDMZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_TYPDMZ) FIELDS(cTypDMz,cNazTypDMz,cTypNapHoC,cTypNapMzC);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cTypDMz)     FPOS(15,1) FLEN(4)  FCAPTION(KÛd typu druhu mzdy)   CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazTypDMz)  FPOS(15,3) FLEN(30) FCAPTION(N·zev typu druhu mzdy) CPOS(1,3)
  TYPE(GET) NAME(cTypNapHoC)  FPOS(15,4) FLEN(2)  FCAPTION(N·poËet hodin v »M)    CPOS(1,4)
  TYPE(GET) NAME(cTypNapMzC)  FPOS(15,5) FLEN(2)  FCAPTION(N·poËet mzdy v »M)     CPOS(1,5)
TYPE(End)
