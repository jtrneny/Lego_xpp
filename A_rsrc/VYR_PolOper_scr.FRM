TYPE(drgForm) DTYPE(10) TITLE(Operace k vyrábìné položce) SIZE(110, 25);
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:y) ;
               CARGO( VYR_PolOPER_crd)

*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Majetek oper.)    EVENT(PolOper_MAJ)    TIPTEXT(Poøízení majetku zaevidovaného u operací )
TYPE(Action) CAPTION(~Pøeèíslování op.) EVENT(PolOper_PRECIS) TIPTEXT(Pøeèíslování èísel operací )

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(109,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS(  2, 0.2) CLEN(  8)
    TYPE(Text) NAME(VyrPOL->cCisZakaz)     CPOS(  2, 1.2) CLEN( 35) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Vyrábìná položka)   CPOS( 38, 0.2) CLEN( 16)
    TYPE(Text) NAME(VyrPOL->cVyrPOL)       CPOS( 38, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Název položky)      CPOS( 59, 0.2) CLEN( 25)
    TYPE(Text) NAME(VyrPOL->cNazev)        CPOS( 59, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Varianta)           CPOS(100, 0.2) CLEN(  8)
    TYPE(Text) NAME(VyrPOL->nVarCis)       CPOS(100, 1.2) CLEN(  8) BGND(13) FONT(5) CTYPE(2) GROUPS(clrBLUE)
  TYPE(End)

* OPERACE k vyrábìné položce
  TYPE(DBrowse) FILE(POLOPER) INDEXORD(1);
                FIELDS( nCisOper:È.oper.  ,;
                        nUkonOper         ,;
                        nVarOper:Var.     ,;
                        cOznOper          ,;
                        VYR_PriprCas():Pøípravný èas:12:@N 999 999.9999  ,;
                        VYR_KusCas():Kusový èas:12:@N 999 999.9999  ,;
                        nKcNaOper:Cena operace:12:@N 999 999.999  ,;
                        OPERACE->cOznPrac,;
                        mPolOper:Popis operace:35 );
                FPOS( 0, 3) SIZE(110, 14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(nn) FOOTER(y);
                ITEMMARKED( ItemMarked)

* Popis operace
TYPE(TabPage) CAPTION(Popis operace) FPOS( 1, 17.2) SIZE(108, 7.5) RESIZE(yx) OFFSET(1,82)
  TYPE(MLE) NAME('POLOPER->mPolOper') FPOS( 1, 0.2) SIZE( 106, 6) RESIZE(yx) READONLY(y)
TYPE(End)

* Majetek operace
TYPE(TabPage) CAPTION( Majetek operace) FPOS(1, 17.2) SIZE(108, 7.5) RESIZE(yx) OFFSET(18,66)

  TYPE(DBrowse) FILE(MajOPER) INDEXORD(2);
                FIELDS( nInvCis          ,;
                        cDruhMaj         ,;
                        C_MAJ->cTypMaj   ,;
                        C_MAJ->cNazevMaj ,;
                        nMnozMaj         ,;
                        nCasNorMaj       ,;
                        cKodCasMaj       ,;
                        cKodKoeCas       );
                SIZE(108, 6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) POPUPMENU(yn)

TYPE(End)