TYPE(drgForm) DTYPE(10);
              TITLE(Zapuštìní zakázky po položkách ...) SIZE(100,25);
              FILE(KusTREE);
              BORDER(2);
              GUILOOK(Action:y,IconBar:n,Menu:n);
              POST(postValidate)

*TYPE(Action) CAPTION(~Nastavení) EVENT( SETTINGS) TIPTEXT(Nastavení)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Støedisko vyšší)  EVENT( Stred_VysPol)  TIPTEXT(Naplní typ støediska nižších položek typem støediska položky vyšší)
TYPE(Action) CAPTION(~Støedisko finálu) EVENT( Stred_Final)   TIPTEXT(Naplní typ støediska všech položek typem støediskem finální položky)
TYPE(Action) CAPTION(~Nuluj množství)   EVENT( Nuluj_MnZadVa) TIPTEXT(Vynuluje množství zadané do výroby u všech položek)

* HLA
  TYPE(Static) STYPE(13) SIZE(100,2.6) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(Výrobní zakázka )  CPOS(  1, 0.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.2) CLEN( 35) BGND( 13) FONT(5) PP(2)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 57, 0.2) CLEN( 30) BGND( 13) FONT(5) PP(2)

    TYPE(Text) CAPTION(Výrábìná položka)  CPOS(  1, 1.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS( 20, 1.2) CLEN( 35) BGND( 13) FONT(5) PP(2)
    TYPE(Text) NAME(VyrPol->cNazev)       CPOS( 57, 1.2) CLEN( 30) BGND( 13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Var.)              CPOS( 89, 1.2) CLEN(  5) FONT(2)
    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS( 95, 1.2) CLEN(  4) BGND( 13) PP(2) CTYPE(2)
   TYPE(End)

* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,2.7) SIZE(99,15) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT( TreeInit);
                 ITEMMARKED(TreeItemMarked);
                 ITEMSELECTED( TreeItemSelected)

* EDIT KARTA
  TYPE(Static) STYPE(13) SIZE(100, 7) FPOS(0, 18) RESIZE(yy)
    TYPE(Text) CAPTION(Množství potøeby)     CPOS(  1, 0.5) CLEN( 15)
    TYPE(Text) NAME(M->nMnPotreby)           CPOS( 20, 0.5) CLEN( 16) BGND( 13) PP(2) PICTURE(@N 999,999,999.9999) CTYPE(2)
    TYPE(Text) CAPTION(Zadat do výroby)      CPOS(  1, 1.5) CLEN( 15)
    TYPE(GET)  NAME(KusTREE->nMnZadVA)       FPOS( 20, 1.5) FLEN( 15)  PP(2) FONT(5)
    TYPE(Text) CAPTION(Množství k rezervaci) CPOS(  1, 2.5) CLEN( 15)
    TYPE(Text) NAME(M->nMnKRezer)            CPOS( 20, 2.5) CLEN( 16) BGND( 13) PP(2) PICTURE(@N 999,999,999.9999) CTYPE(2)
    TYPE(Text) CAPTION(Množství k dispozici) CPOS(  1, 3.5) CLEN( 15)
    TYPE(Text) NAME( CenZBOZ->nMnozDZBO)     CPOS( 20, 3.5) CLEN( 16) BGND( 13) PP(2)CTYPE(2)
    TYPE(Text) CAPTION(Množství skladové)    CPOS(  1, 4.5) CLEN( 15)
    TYPE(Text) NAME( CenZBOZ->nMnozSZBO)     CPOS( 20, 4.5) CLEN( 16) BGND( 13) PP(2)CTYPE(2)
*    TYPE(Text) CAPTION(Množství volné)       CPOS(  1, 5.5) CLEN( 15)
*    TYPE(Text) NAME( M->nMnVolne)            CPOS( 20, 5.5) CLEN( 16) BGND( 13) PP(2) PICTURE(@N 999,999,999.9999) CTYPE(2)

    TYPE(Text) CAPTION(Typ støediska)        CPOS( 40, 0.5) CLEN( 12)
    TYPE(Text) NAME( KusTREE->cTypStr)       CPOS( 52, 0.5) CLEN( 13) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Typ støed. finálu)    CPOS( 67, 0.5) CLEN( 15)
    TYPE(Text) NAME( M->cTypStrFIN)          CPOS( 82, 0.5) CLEN( 12) BGND( 13) PP(2)

    TYPE(Text) CAPTION(Stredisko)            CPOS( 40, 2.5) CLEN( 12)
    TYPE(GET)  NAME(KusTREE->cStred)         FPOS( 52, 2.5) FLEN( 12) PP(2) FONT(5)
    TYPE(Text) CAPTION(Støedisko finálu)     CPOS( 67, 2.5) CLEN( 12)
    TYPE(Text) NAME( M->cStredFIN)           CPOS( 82, 2.5) CLEN( 12) BGND( 13) PP(2)

    TYPE(Text) CAPTION(Støižný plán)         CPOS( 40, 3.5) CLEN( 12)
    TYPE(GET)  NAME(KusTree->nStrizPl)       FPOS( 52, 3.5) FLEN( 12) PP(2) FONT(5)
    TYPE(Text) CAPTION(Kusù na pás)          CPOS( 40, 4.5) CLEN( 12)
    TYPE(GET)  NAME(KusTree->nKusyPas)       FPOS( 52, 4.5) FLEN( 12) PP(2) FONT(5) POST( PostLastField)

*    TYPE(PushButton) POS(1,5.5) SIZE(18,1.1) CAPTION(~Množství volné) EVENT( MnozVolne) PRE(2) ;
*      ATYPE(3)

  TYPE(End)
