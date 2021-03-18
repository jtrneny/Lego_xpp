TYPE(drgForm) DTYPE(2) TITLE(Èíselník listù vlastnictví ...) SIZE(80,15) FILE(C_LISTVL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(80,14) FILE(C_LISTVL) FIELDS(CTASK:úloha             , ;
                                                  cku_Kod                 , ;
                                                  cku_Nazev::20            , ;
                                                  nlistVlast:listVlast:10 , ;
                                                  CNAZEVLV:vlastník/ci:40   ) ;
                                           CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) 
TYPE(End)


TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CTASK)       FPOS(15,1) FLEN(10) FCAPTION(Úloha)               CPOS(1,1)
  TYPE(GET) NAME(cku_Kod)     FPOS(15,2) FLEN(50) FCAPTION(Kód katastru)        CPOS(1,2)
  TYPE(GET) NAME(cku_Nazev)   FPOS(15,3) FLEN(50) FCAPTION(Název katastru KÚ)   CPOS(1,3)
*  TYPE(GET) NAME(CKATASTR)    FPOS(15,4) FLEN(50) FCAPTION(Název katastru)      CPOS(1,4)
  TYPE(GET) NAME(NLISTVLAST)  FPOS(15,5) FLEN(10) FCAPTION(Èíslo listu vlast.)  CPOS(1,5)
  TYPE(GET) NAME(CNAZEVLV)    FPOS(15,6) FLEN(50) FCAPTION(Název LV)            CPOS(1,6)
TYPE(End)

