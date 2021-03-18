TYPE(drgForm) DTYPE(2) TITLE(Trvalé závazky) SIZE(60,15) FILE(TRVALZAV) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84)
TYPE(Browse) SIZE(75,14) FIELDS(cZkrTypZAV,cNazevZAV) CURSORMODE(3)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70)
  TYPE(GET) NAME(cZkrTypZav) FPOS(15,1) FLEN(6)   FCAPTION(Zkratka typu závazku)    CPOS(1,1);
            POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazevZAV)  FPOS(15,2) FLEN(30)  FCAPTION(Název trvalého závazku)  CPOS(1,2)
TYPE(End)
