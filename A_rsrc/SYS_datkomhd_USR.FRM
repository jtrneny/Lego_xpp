TYPE(drgForm) DTYPE(10) TITLE(Seznam definovaných komunikací - test) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO()

TYPE(DBrowse) FPOS(0.5,0.1) SIZE(100,15) FILE(DATKOMHD)  ;
              FIELDS(cnazdatkom:Název dat_kom:60       , ;
                     cTASK:úloha:10                    , ;
                     cmainfile:hlavní soubor:10        , ;
                     ciddatkom:ID_datkom:17              ) ; 
              CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)


TYPE(MLE) NAME(datkomhd->mDEFIN_KOM) FPOS (0.5,15.2) SIZE (42,9.6) PP(2)

* TREEVIEW
TYPE(TreeView) ATYPE(3) FPOS(43,15.2) SIZE(56,8.4) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
               TREEINIT(usr_treeViewInit)     ;
               ITEMMARKED(TreeItemMarked)     ;
               ITEMSELECTED( TreeItemSelected) PP(2)

TYPE(Text) NAME(M->cname)   CPOS(43,23.8) CLEN(12) PP(2) FONT(5)
TYPE(Get)  NAME(M->cvalue)  FPOS(56,23.8) FLEN(42) PUSH(sel_dialog)

