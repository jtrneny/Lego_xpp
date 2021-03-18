TYPE(drgForm) DTYPE(10) TITLE(V�robn� zak�zky - SKUTE�N� kalkulace) FILE(VYRZAK);
              SIZE(110,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(info ~Zak�zka  ) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informa�n� karta v�robn� zak�zky)
TYPE(Action) CAPTION(~Kalkulace SKUT) EVENT(VYR_KALKUL_SCR)  TIPTEXT(Skute�n� kalkulace v�robn� zak�zky )
TYPE(Action) CAPTION(~Hromadn� kalk.) EVENT(KalkHR_CMP)      TIPTEXT(V�po�et hromadn� kalkulace skute�n� )
*
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kaklulace sk_ex)   EVENT()             TIPTEXT(V�po�et hromadn� skute�n� kalkulace_ex)
*
*  VYRZAK ... Seznam zak�zek
  TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
               FIELDS( VyrZAKis_U():Uz:2.6::2            , ;
                       VYR_isKusov( 1; 'Vyrzak'):Ku:1::2 , ;
                       VYR_isPolOp( 1; 'Vyrzak'):Op:1::2 , ;
                       M->is_kalkul:Kal:1.2::2           , ;
                       cCisZakaz      ,;
                       cNazevZak1::30 ,;
                       cVyrPol        ,;
                       nVarCis        ,;
                       nMnozPlano     ,;
                       cStavZakaz:St. );
               SIZE(110,16) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)


* Z�kladn� �daje vyrZak
  TYPE(TabPage) TTYPE(4) CAPTION(Z�kladn� �daje) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(1,83) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(108,8.5) RESIZE(yx) FPOS(.5,.2) GROUPS(clrGREEN)

*       1.SL
        TYPE(Text)  CAPTION(V�r�b�n� polo�ka)  CPOS( 1, 0.5) CLEN( 14)
        TYPE(TEXT)  NAME(cVyrPol)              CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(VYRPOL->cNazev)       CPOS(31, 0.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(Varianta)          CPOS( 1, 1.5) CLEN( 13)
        TYPE(TEXT)  NAME(nVarCis)              CPOS(15, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  NAME(VYRPOL->cVarPop)      CPOS(31, 1.5) CLEN( 30) BGND(13)
        TYPE(Text)  CAPTION(��slo objedn�vky)  CPOS( 1, 2.5) CLEN( 13)
        TYPE(TEXT)  NAME(cCisloObj)            CPOS(15, 2.5) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREY)

        TYPE(Text)  CAPTION(Zalo�en� zak.)     CPOS( 1, 3.5) CLEN( 12)
        TYPE(TEXT)  NAME(dZapis)               CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Pl�n. odveden�)    CPOS( 1, 4.5) CLEN( 12)
        TYPE(TEXT)  NAME(dOdvedZAKA)           CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(��slo pl�nu)       CPOS( 1, 5.5) CLEN( 12)
        TYPE(TEXT)  NAME(cCisPlan)             CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Skut. odveden�)    CPOS( 1, 6.5) CLEN( 12)
        TYPE(TEXT)  NAME(dSkuOdvZak)           CPOS(15, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Uzav�en� zak.)     CPOS( 1, 7.5) CLEN( 12)
        TYPE(TEXT)  NAME(dUzavZaka)            CPOS(15, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)

*       2.SL
        TYPE(Text)  CAPTION(Mn.pl�n. z objedn�vek) CPOS(63, 0.5) CLEN( 18)
        TYPE(TEXT)  NAME(nMnozPlano)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Zad�no do v�roby)      CPOS(63, 1.5) CLEN( 18)
        TYPE(TEXT)  NAME(nMnozZadan)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Mn. vyroben�)          CPOS(63, 2.5) CLEN( 18)
        TYPE(TEXT)  NAME(nMnozVyrob)               CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Pl�novan� pr�b�h)      CPOS(63, 3.5) CLEN( 18)
        TYPE(TEXT)  NAME(nPlanPruZa)               CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)

        TYPE(Text)  CAPTION(Priorita zak�zky)      CPOS(63, 5.5) CLEN( 18)
        TYPE(TEXT)  NAME(cPriorZaka)               CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)
        TYPE(Text)  CAPTION(Stav kapacit)          CPOS(63, 6.5) CLEN( 18)
        TYPE(TEXT)  NAME(cStavKapZa)               CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5) GROUPS(clrGREY)

        TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
        TYPE(End)
     TYPE(End)


** Skute�n� kalkulace kalkul
  TYPE(TabPage) TTYPE(4) CAPTION(Kalkulace skute�n�) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(17,68) PRE( tabSelect)

     TYPE(DBrowse) FILE(KALKUL_oW) INDEXORD(4);
               FIELDS( vyr_kalkul_oW_stav():A:2.7::2 ,;
                       vyr_kalkul_oW_isOk()::2.6::2, ;
                       cTypKalk:Typ kalk.  ,;
                       cVypKalk:V�po�et   ,;
                       nRokVyp    ,;
                       nObdMes    ,;
                       dDatAktual ,;
                       nPorKalDen:Po�.kalk. ,;
                       nCenKalkP  ,;
                       nCenKalkS  ,;
                       nCenProdP  ,;
                       cZkratMeny:M�na ,;
                       cDruhCeny:Druh ceny  ,;
                       nMnozDavky ,;
                       nCisFirmy  ,;
                       cNazFirmy  );
                SIZE(110,7.8) CURSORMODE(3) PP(7) Resize(ny) SCROLL(yy)
  TYPE(End) 