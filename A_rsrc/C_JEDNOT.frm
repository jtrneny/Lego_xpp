TYPE(drgForm) DTYPE(2) TITLE(��seln�k m�rn�ch jednotek) SIZE(75,15) FILE(C_JEDNOT);
              GUILOOK(Action:y)

TYPE(Action) CAPTION(~P�epo�ty MJ) EVENT( Prepocty)      TIPTEXT(P�epo�ty m�rn� jednotky)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE(tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_JEDNOT) FIELDS(CZKRATJEDN,CNAZJEDNOT::32,CZKRMEZOZN,CSTATKODZA,MNAZEVJEDP) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(15,69) PRE(tabSelect)
  TYPE(GET) NAME(CZKRATJEDN) FPOS(15,1)  FLEN(3)  FCAPTION(Zkratka_MJ)  CPOS(1,1) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZJEDNOT) FPOS(15,2)  FLEN(40) FCAPTION(NazevMJ)    CPOS(1,2)
  TYPE(GET) NAME(CZKRMEZOZN) FPOS(15,3)  FLEN(3)  FCAPTION(ZkrMezOzna) CPOS(1,3)
  TYPE(GET) NAME(CSTATKODZA) FPOS(15,4)  FLEN(6)  FCAPTION(StatKodZaz) CPOS(1,4)
*  TYPE(GET) NAME(MNAZEVJEDP) FPOS(15,5)  FLEN(10) FCAPTION(PopN�zJedn) CPOS(1,5)
TYPE(End)





