TYPE(drgForm) SIZE(90,17) DTYPE(10) TITLE(Položky výrobní zakázky - VÝBÌR) FILE(VYRZAKIT);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)

  TYPE(Action) CAPTION( info ~Pol.zak.)  EVENT(VYR_VYRZAKIT_INFO) TIPTEXT( Informaèní karta položky výrobní zakázky)

  TYPE(DBrowse) FPOS(0,0) SIZE(90,9.4);
                FILE(VYRZAKIT) ;
                FIELDS(cCisZakaz  :Zakázka         , ;
                       cCisZakazI :Položka zakázky , ;
                       cVyrpol    :Vyrábìná položka , ;
                       nVarCis    :Varianta         , ;
                       cNazevZak1 :Název zakázky   , ;
                       cStavZakaz :Stav           ) ;
                CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)


  TYPE(Static) STYPE(13) SIZE(89,7) FPOS(0.5,9.7) RESIZE(y)

*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Vyr. položka)          CPOS( 20, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 20, 1.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Varianta)              CPOS( 37, 0.5)   CLEN(  8) FONT(5)
    TYPE(Text) NAME(nVarCis)                  CPOS( 37, 1.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Èíslo objednávky)      CPOS( 47, 0.5)   CLEN( 20)
    TYPE(Text) NAME(cCisloObj)                CPOS( 47, 1.5)   CLEN( 30) BGND( 13) PP(2)
*   2.øádek
    TYPE(Text) CAPTION(Založení zak.)         CPOS(  3, 2.5)   CLEN( 10)
    TYPE(Text) NAME(dZapis)                   CPOS(  3, 3.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Plán. odvedení)        CPOS( 15, 2.5)   CLEN( 12)
    TYPE(Text) NAME(dOdvedZaka)               CPOS( 15, 3.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Èíslo plánu)           CPOS( 27, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cCisPlan)                 CPOS( 27, 3.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skut. odvedení)        CPOS( 45, 2.5)   CLEN( 12)
    TYPE(Text) NAME(dSkuOdvZak)               CPOS( 45, 3.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Uzavøení zak.)         CPOS( 57, 2.5)   CLEN( 12)
    TYPE(Text) NAME(dUzavZaka)                CPOS( 57, 3.5)   CLEN( 10) BGND( 13) PP(2)
*   3.øádek
    TYPE(Text) CAPTION(Mn.plán. z obj.)       CPOS(  3, 4.5)   CLEN( 12)
    TYPE(Text) NAME(nMnozPlanO)               CPOS(  3, 5.5)   CLEN( 11) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Zadáno do výr.)        CPOS( 17, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nMnozZadan)               CPOS( 17, 5.5)   CLEN( 11) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Mn. vyrobené)          CPOS( 30, 4.5)   CLEN( 12)
    TYPE(Text) NAME(nMnozVyrob)               CPOS( 30, 5.5)   CLEN( 11) CTYPE(2) BGND( 13) PP(2)

    TYPE(Text) CAPTION(Pl. prùbìh)            CPOS( 48, 4.5)   CLEN( 10)
    TYPE(Text) NAME(nPlanPruZa)               CPOS( 48, 5.5)   CLEN(  6) CTYPE(2) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Priorita)              CPOS( 60, 4.5)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 60, 5.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 70, 4.5)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 70, 5.5)   CLEN(  8) BGND( 13) PP(2)

  TYPE(End)