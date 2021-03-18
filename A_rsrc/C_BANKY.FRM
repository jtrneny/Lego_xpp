TYPE(drgForm) DTYPE(2) TITLE(Èíselník bank) SIZE(60,15) FILE(C_BANKY) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(60,14) FILE(C_BANKY) FIELDS(CZKRATSTAT,CKODBANKY,CNAZBANKY,NKODBANKY,CBANIS,CBIC) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CZKRATSTAT)      FPOS(15,1)    FLEN( 7)   FCAPTION(Zkrat.státu)                    CPOS(1,1)
  TYPE(GET) NAME(CKODBANKY)       FPOS(15,2)    FLEN( 4)   FCAPTION(Kód banky)                      CPOS(1,2)  PP(2)
  TYPE(GET) NAME(CNAZBANKY)       FPOS(15,3)    FLEN(40)   FCAPTION(Název banky)                    CPOS(1,3)
  TYPE(GET) NAME(NKODBANKY)       FPOS(15,4)    FLEN( 4)   FCAPTION(Kód banky-num)                  CPOS(1,4)
  TYPE(GET) NAME(CBANIS)          FPOS(15,5)    FLEN( 4)   FCAPTION(Banis kód)                      CPOS(1,5)
  TYPE(GET) NAME(CBIC)            FPOS(15,6)    FLEN(20)   FCAPTION(BIC - Swift kód)                CPOS(1,6)
  TYPE(GET) NAME(CKODBANZN)       FPOS(15,7)    FLEN(10)   FCAPTION(Kód banky-znak)                 CPOS(1,7)
  TYPE(GET) NAME(LAKTIVUCAS)      FPOS(15,8)    FLEN( 2)   FCAPTION(Aktivní úèast.)                 CPOS(1,8)
  TYPE(GET) NAME(DPLATNYOD)       FPOS(15,9)    FLEN(11)   FCAPTION(Platnost OD)                    CPOS(1,9)  PUSH(CLICKDATE)
  TYPE(GET) NAME(DPLATNYDO)       FPOS(15,10)   FLEN(11)   FCAPTION(Platnost DO)                    CPOS(1,10) PUSH(CLICKDATE)
TYPE(End)

