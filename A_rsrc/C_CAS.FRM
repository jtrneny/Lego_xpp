TYPE(drgForm) DTYPE(2) TITLE(Èíselník èasù-intervalù) SIZE(70,15) FILE(C_CAS);
              GUILOOK(Action:y)

TYPE(Action) CAPTION(~Generuj) EVENT(Generuj)   TIPTEXT(Pøegeneruje èasy na nové intervaly)

TYPE(Static) STYPE(13) SIZE( 68,14.5) FPOS(1.1,0.2)  RESIZE(yy)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect) 
 TYPE(Static) STYPE(2) SIZE( 66,12.5) FPOS(1.1,0.1)  RESIZE(yy)
  TYPE(DBrowse) SIZE(66,12.5) FILE(C_CAS) FIELDS(cCas,cCasInt,nCas,nCasInt) FPOS(0.5,0.2);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)  
TYPE(End)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
 TYPE(Static) STYPE(2) SIZE( 66,12.5) FPOS(1.1,0.1)  RESIZE(yy)

  TYPE(GET) NAME(cCas)        FPOS(15,1)  FLEN(7)  FCAPTION(Èas-znak)                     CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cCasInt)     FPOS(15,2)  FLEN(7)  FCAPTION(Èas interval-znak)            CPOS(1,2)
  TYPE(GET) NAME(nCas)        FPOS(15,3)  FLEN(7)  FCAPTION(Èas-num)                      CPOS(1,3)
  TYPE(GET) NAME(nCasInt)     FPOS(15,4)  FLEN(7)  FCAPTION(Èas interval-num)             CPOS(1,4)
TYPE(End)
TYPE(End)
TYPE(End)