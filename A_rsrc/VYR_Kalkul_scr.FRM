TYPE(drgForm) DTYPE(10) TITLE(Kalkulace PLÁN) SIZE(100, 20);
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:y);
               CARGO( VYR_KALKUL_crd)

*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(info ~Položky)     EVENT(VYR_VYRPOL_INFO) TIPTEXT(Informaèní karta vyrábìné položky )
TYPE(Action) CAPTION(~Kopie kalkulace)  EVENT(Kalkul_COPY)     TIPTEXT(Kopie kalkulace vyrábìné položky )
TYPE(Action) CAPTION(ka~Lk. do ceníku)  EVENT(KalkToCENIK)     TIPTEXT(Pøenos kalkulace vyr.položky do ceníku )
TYPE(Action) CAPTION(kalk.do ~Nabídky)  EVENT(KalkToNABV)      TIPTEXT(Pøenos kalkulace vyr.položky do nabídky vystavené )

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)          CPOS( 2, 0.1) CLEN(  8) FONT( 2)
    TYPE(Text) NAME(M->cCisZakaz)        CPOS( 2, 1.3) CLEN( 40) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Vyrábìná položka) CPOS(43, 0.1) CLEN( 16) FONT( 2)
    TYPE(Text) NAME(M->cVyrPOL)          CPOS(43, 1.3) CLEN( 20) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Název položky)    CPOS(64, 0.1) CLEN( 25) FONT( 2)
    TYPE(Text) NAME(VyrPOL->cNazev)      CPOS(64, 1.3) CLEN( 28) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Var.)             CPOS(93, 0.1) CLEN(  5) FONT( 2)
    TYPE(Text) NAME(M->nVarCis)          CPOS(93, 1.3) CLEN(  5) BGND(13) FONT(5) GROUPS(clrBLUE)
  TYPE(End)

* KALKULACE k vyrábìné položce
  TYPE(DBrowse) FILE(KALKUL) INDEXORD(4);
               FIELDS( VYR_StavKALK():A:2.7::2 ,;
                       vyr_kalkul_isOk()::2.6::2, ;
                       cTypKalk:Typ kalk.  ,;
                       cVypKalk:Výpoèet   ,;
                       nRokVyp    ,;
                       nObdMes    ,;
                       dDatAktual ,;
                       nPorKalDen:Poø.kalk. ,;
                       nCenKalkP  ,;
                       nCenKalkS  ,;
                       nCenProdP  ,;
                       cZkratMeny:Mìna ,;
                       cDruhCeny:Druh ceny  ,;
                       nMnozDavky ,;
                       nCisFirmy  ,;
                       cNazFirmy  );
               FPOS( 0, 3) SIZE(100, 16.8) CURSORMODE(3) PP(7) Resize(ny) SCROLL(ny);
               ITEMMARKED( ItemMarked)