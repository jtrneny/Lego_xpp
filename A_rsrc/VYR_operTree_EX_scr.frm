TYPE(drgForm) DTYPE(10);
              TITLE(Strukturovaný kusovník s operacemi ...) SIZE(120,26);
              FILE(OperTREE);
              BORDER(2);
              GUILOOK(Action:y,IconBar:y,Menu:n) ;
              PRINTFILES(OperTree, ;
                         poloper:cciszakaz=cciszakaz+cvyrpol=cvyrpol)

TYPE(Action) CAPTION(info ~Zakázka)    EVENT( VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Detail pol./op.) EVENT( VYR_VYRPOL_INFO) TIPTEXT(Detail vyr.položky / operace)

* HLA
  TYPE(Static) STYPE(13) SIZE(100,2.6) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(Výrobní zakázka ..........)   CPOS(  1, 0.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.2) CLEN( 30) BGND( 13) FONT(5) PP(2)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 52, 0.2) CLEN( 30) BGND( 13) FONT(5) PP(2)

    TYPE(Text) CAPTION(Výrábìná položka ..........)  CPOS(  1, 1.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS( 20, 1.2) CLEN( 30) BGND( 13) FONT(5) PP(2)
    TYPE(Text) NAME(VyrPol->cNazev)       CPOS( 52, 1.2) CLEN( 30) BGND( 13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Varianta)          CPOS( 84, 1.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS( 93, 1.2) CLEN(  6) BGND( 13) PP(2) CTYPE(2)
   TYPE(End)

* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,2.7) SIZE(120,23) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT(treeViewInit);
                 ITEMMARKED(TreeItemMarked);
                 ITEMSELECTED( TreeItemSelected)

  