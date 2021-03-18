TYPE(drgForm) DTYPE(10) TITLE(Parametry zakázek - seznam);
              SIZE(100,24) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              CARGO(VYR_ParZAK_crd)

TYPE(Action) CAPTION(~Výskyt v zak.) EVENT(PARAM_inZAK) TIPTEXT(Výskyt parametru v zakázkách )

* Seznam parametrù
  TYPE(DBrowse) FILE( PARZAK) INDEXORD(1);
                FIELDS( cAtrib   ,;
                        cAtribNaz::70 );
                SIZE(100,18) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy) ATSTART()

* Popis parametru
TYPE(TabPage) CAPTION( Popis parametru) FPOS(0, 18.1) SIZE( 100, 5.9) RESIZE(yx) OFFSET(1,82)
  TYPE(MLE) NAME('ParZAK->mPoznamka') FPOS( 0.5, 0.2) SIZE( 99, 4.6) RESIZE(yx) READONLY(y)
TYPE(End)