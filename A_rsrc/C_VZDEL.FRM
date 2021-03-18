TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù vzdìlání) SIZE(60,15) FILE(C_VZDEL);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_VZDEL) FIELDS(cZkrVzdel,cNazVzdela::38,cTypVzdSCP);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cZkrVzdel)  FPOS(15,1) FLEN( 8) FCAPTION(Zkratka)                    CPOS(1,1)    ;
                 POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazVzdela) FPOS(15,2)  FLEN(40) FCAPTION(Název typu vzdìlání)       CPOS(1,2)
  TYPE(COMBOBOX) NAME(cTypVzdSCP)  FPOS(15,3) FLEN(42) FCAPTION(Typ vzdìlání pro ISPV)     CPOS(1,3)    ; 
                 VALUES(A: A - bez vzdìlání,;
                        B: B - neúplné základní vzdìlání ,;
                        C: C - základní vzdìlání,;
                        D: D - nižší støední vzdìlání ,;
                        E: E - nižší støední odborné vzdìlání ,;
                        H: H - støední odborné vzdìlání s výuèním listem ,;
                        J: J - støední nebo støední odborné vzdìlání bez maturity i výuèního listu,;
                        K: K - úplné støední všeobecné vzdìlání,;
                        L: L - úplné støední odborné vzdìlání s vyuèením i maturitou ,;
                        M: M - úplné støední odborné vzdìlání s maturitou -bez vyuèení,; 
                        N: N - vyšší odborné vzdìlání,; 
                        R: R - bakaláøské vzdìlání,;
                        T: T - vysokoškolské vzdìlání,;
                        V: V - vysokoškolské doktorské vzdìlání)                                        ;
                   POST( postLastField_2)

TYPE(End)
