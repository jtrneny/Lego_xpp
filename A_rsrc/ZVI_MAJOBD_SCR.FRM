TYPE(drgForm) DTYPE(10) TITLE(Karty zvíøat v období) SIZE(100,20) FILE(MAJZOBD);
              GUILOOK(Message:n,Action:y,IconBar:y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(info ~Zvíøete)   EVENT(MAJ_INFO) TIPTEXT(informaèní karta zvíøete )

  TYPE(Static) STYPE(13) SIZE(99.6, 1) FPOS( 0.2, 0) RESIZE(yn)
    TYPE(COMBOBOX) NAME(M->nObdobiFLT)  FPOS( 1, 0) FLEN( 14) VALUES( a,a,a,a,a );
                              COMBOINIT( comboBoxInit) ITEMSELECTED(comboItemSelected)

    TYPE(Text) CAPTION(Karty zvíøat) CPOS(17, 0) CLEN( 82.6) CTYPE(3) FONT(5)
  TYPE(End)
*
  TYPE(DBrowse) FILE(OBDOBIw) INDEXORD(1) ;
                FIELDS( nROK:Rok       ,;
                        nObdobi:Období );
                SIZE(15.8, 20) FPOS( 0, 1) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

  TYPE(DBrowse) FILE(MAJZOBD) INDEXORD(1) ;
                FIELDS( nUcetSkup:Úè.sk.          ,;
                        NINVCIS:Inv.èíslo         ,;
                        CNAZEV:Název majetku      ,;
                        NCENAVSTU:Vst.cena úèetní ,;
                        NOPRUCT:Oprávky úèetní    ,;
                        NCENAVSTD:Vst.cena daòová ,;
                        NOPRDAN:Oprávky daòové    );
                SIZE(84,20) FPOS( 16, 1) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y)
