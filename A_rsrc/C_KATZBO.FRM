TYPE(drgForm) DTYPE(2) TITLE(Èíselník kategorií zboží) SIZE(60,15) FILE(C_KATZBO) ;
              GUILOOK(Action:n)                                                   ;
              CBSAVE(save_c_katZbo)  


TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) INDEXORD(1) FILE(C_KATZBO);
                FIELDS(NZBOZIKAT,CNAZEVKAT,CROZPORADI,NPRIRAZKA,C_KATZBO->( RecNO()));
                CURSORMODE(3)  PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET) NAME(NZBOZIKAT)  FPOS(15,1) FLEN( 4) FCAPTION(Kat. zboží)       CPOS(1,1) PP(2);
             POST( drgPostUniqueKey)
    TYPE(GET) NAME(CNAZEVKAT)  FPOS(15,2) FLEN(20) FCAPTION(Název kategorie)  CPOS(1,2)
    TYPE(GET) NAME(CROZPORADI) FPOS(15,3) FLEN(15) FCAPTION(Rozlišení poøadí) CPOS(1,3)
    TYPE(GET) NAME(NPRIRAZKA)  FPOS(15,4) FLEN( 6) FCAPTION(Pøirážka)         CPOS(1,4)  POST( postLastField_2)
  TYPE(End)
TYPE(End)