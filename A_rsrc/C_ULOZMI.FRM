TYPE(drgForm) DTYPE(2) TITLE(Èíselník míst uložení) SIZE(60,15) FILE(C_ULOZMI);
              GUILOOK(Action:n) PRE(preValidate) POST(postValidate) CBSAVE(save_c_ulozmi) 

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) INDEXORD(2) FILE(C_ULOZMI);
               FIELDS(CCISSKLAD,CULOZZBO,CNAZEVMIST);
               SIZE(60,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(Static) STYPE(13) SIZE( 59, 13.6) FPOS( 0.5,0.2) RESIZE(yn)
    TYPE(GET)      NAME(CULOZZBO)   FPOS(17,1) FLEN(12) FCAPTION(Místo uložení)       CPOS(1,1)
    TYPE(GET)      NAME(CNAZEVMIST) FPOS(17,2) FLEN(25) FCAPTION(Název místa uložení) CPOS(1,2)
    TYPE(GET)      NAME(CCISSKLAD)  FPOS(17,3) FLEN(12) FCAPTION(Sklad)               CPOS(1,3)
    TYPE(Text)     NAME(C_SKLADY->cNazSklad)  CPOS(30,3) CLEN(25) BGND(13) PP(3)
    TYPE(COMBOBOX) NAME(CULOZSYS)   FPOS(17,4) FLEN(12) FCAPTION(Systém uložení)      CPOS(1,4) REF(CULOZSYS) 
  TYPE(End)
TYPE(End)