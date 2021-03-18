TYPE(drgForm) DTYPE(2) TITLE(»ÌselnÌk pojiöùoven) SIZE(60,15) FILE(C_POJUST);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_POJUST) FIELDS(cZkrPojist,cNazPojist,cZkratkaPo,cZkrRozlTP,cIdKoduPoj,nCisFirmy);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(cZkrPojist)  FPOS(15,1) FLEN(3)  FCAPTION(Zkratka pojiöùovny)              CPOS(1,1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cNazPojist)  FPOS(15,2) FLEN(30) FCAPTION(N·zev pojiöùovny)                CPOS(1,2)
  TYPE(GET) NAME(cZkratkaPo)  FPOS(15,3) FLEN(3)  FCAPTION(Zkratka n·zvu pojiöùovny)        CPOS(1,3)
  TYPE(GET) NAME(cIdKoduPoj)  FPOS(15,4) FLEN(4)  FCAPTION(P¯idÏlen˝ id.kÛd u pojiöùovny)   CPOS(1,4)
  TYPE(GET) NAME(nCisFirmy)   FPOS(15,5) FLEN(4)  FCAPTION(»Ìslo firmy)                     CPOS(1,5)
TYPE(End)
