TYPE(drgForm) DTYPE(10) TITLE(Položky pohybového - VÝBÌR -) SIZE(100,19) FILE(PVPITEM_ss) ;
              GUILOOK(Action:n,Message:n,IconBar:n,Menu:n)

* Pohybový doklad
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,0.2) RESIZE(xy)
    TYPE(Text) CAPTION(Doklad)            CPOS( 1, 0.2) CLEN(  6)
    TYPE(Text) NAME(PVPITEM_ss->nDoklad)   CPOS( 1, 1.2) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pohyb)              CPOS(17, 0.2) CLEN( 10)
    TYPE(Text) NAME(C_TypPoh->cTypPohybu)  CPOS(17, 1.2) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název pohybu)       CPOS(34, 0.2) CLEN( 15)
    TYPE(Text) NAME(C_TypPoh->cNazTypPoh)  CPOS(34, 1.2) CLEN( 60) BGND( 13) FONT(5) GROUPS(clrGREEN)
  TYPE(End)

  TYPE(DBrowse) FILE(PVPITEM_ss) INDEXORD(3)       ;
                FIELDS( ndoklad:doklad:10        , ;
                        nordItem:pol:5           , ;
                        csklPol:sklPoložka:14    , ;
                        cnazZbo:název zboží:25   , ;
                        nmnozPRdod:množ_Nadokl:12, ;
                        czkratJedn:mj            , ;
                        ncenaCelk:cenaCelkem:12  , ;
                        ddatPVP:datPohybu:11       ) ;
                FPOS( 0, 3) SIZE(100,16) CURSORMODE(3) RESIZE(x) PP(9) SCROLL(yy) LFREEZE(1) POPUPMENU(y);
                ITEMSELECTED( RecordSelected)