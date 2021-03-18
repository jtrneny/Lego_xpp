TYPE(drgForm) DTYPE(10);
              TITLE(Zapuštìní zakázky dle dílen a pracoviš ...) SIZE(100,25);
              FILE(KusTREE);
              BORDER(2);
              GUILOOK(Action:y,IconBar:n,Menu:n)

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
  TYPE(TreeView) ATYPE(3) FPOS(0,2.7) SIZE(99,22) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT( TreeInit);
                 ITEMMARKED(TreeItemMarked);
                 ITEMSELECTED( TreeItemSelected)
