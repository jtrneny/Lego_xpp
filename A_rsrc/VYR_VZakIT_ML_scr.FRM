TYPE(drgForm) DTYPE(10) TITLE(Mzdové lístky k položce zakázky) SIZE(110, 25) FILE(VyrZakIT );
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:y)
*               CARGO( VYR_PolOPER_crd)

TYPE(Action) CAPTION(~info Zakázka)   EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky )

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(109,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS( 2, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZakIT->cCisZakaz)     CPOS( 2, 1.2) CLEN( 35) BGND(13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Vyrábìná položka)   CPOS(38, 0.2) CLEN( 16) FONT(2)
    TYPE(Text) NAME(VyrZakIT->cVyrPOL)       CPOS(38, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název položky)      CPOS(59, 0.2) CLEN( 25) FONT(2)
*    TYPE(Text) NAME(VyrPOL->cNazev)        CPOS(59, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta)           CPOS(100, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZakIT->nVarCis)       CPOS(100, 1.2) CLEN(  8) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
  TYPE(End)

* OPERACE k vyrábìné položce
  TYPE(DBrowse) FILE(POLOPER) INDEXORD(1);
                FIELDS( nCisOper:È.oper.  ,;
                        nUkonOper         ,;
                        nVarOper:Var.     ,;
                        cOznOper          ,;
                        nPriprCas::12:@N 999 999.9999  ,;
                        nKusovCas::12:@N 999 999.9999  ,;
                        nKcNaOper:Cena operace:12:@N 999 999.999  ,;
*                        OPERACE->cOznPrac,;
                        mPolOper:Popis operace:35 );
                FPOS( 0, 3) SIZE(110, 14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(nn);
                ITEMMARKED( ItemMarked)

* Popis operace
TYPE(TabPage) CAPTION(Popis operace) FPOS( 1, 17.2) SIZE(108, 7.5) RESIZE(yx) OFFSET(1,82)
  TYPE(MLE) NAME('POLOPER->mPolOper') FPOS( 1, 0.2) SIZE( 106, 6) RESIZE(yx) READONLY(y)
TYPE(End)

* Majetek operace
*TYPE(TabPage) CAPTION( Majetek operace) FPOS(1, 17.2) SIZE(108, 7.5) RESIZE(yx) OFFSET(18,66)

*  TYPE(DBrowse) FILE(MajOPER) INDEXORD(2);
*                FIELDS( nInvCis          ,;
*                        cDruhMaj         ,;
*                        C_MAJ->cTypMaj   ,;
*                        C_MAJ->cNazevMaj ,;
*                        nMnozMaj         ,;
*                        nCasNorMaj       ,;
*                        cKodCasMaj       ,;
*                        cKodKoeCas       );
*                SIZE(108, 6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(yn)

*TYPE(End)