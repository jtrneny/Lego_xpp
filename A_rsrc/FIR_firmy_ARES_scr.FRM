TYPE(drgForm) DTYPE(10) TITLE(Seznam definovaných komunikací - test) SIZE(120,26) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(.5,.2) SIZE(119,11.4) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT(treeViewInit)         ;
                 ITEMMARKED(treeItemMarked)     ;
                 ITEMSELECTED(treeItemSelected) PP(2)


* BROWSE
* M->firmy_infoAres::2.8::1, ;

  TYPE(DBrowse) FPOS(0.5,11.7) SIZE(119,14) FILE(C_ARESW)  ;
                FIELDS(M->firmy_infoAres::3::2           , ;
                       cfieldName:název Položky:30       , ;
                       cares_Odp:ares_Opovìd:40          , ;
                       cfirmy_Dat:firmy_Data:40            ) ;
                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)

