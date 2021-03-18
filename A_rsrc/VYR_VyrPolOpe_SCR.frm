TYPE(drgForm) DTYPE(10) TITLE(Vyrábìné položky - operace);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              CARGO(VYR_VyrPol_crd)

TYPE(Action) CAPTION(~Editace operací) EVENT(Edit_PolOper) TIPTEXT(Poøizování operací k vyrábìné položce )

* Vyrábìné položky
  TYPE(DBrowse) FILE(VYRPOL) INDEXORD(4);
                FIELDS( VYR_isPolOp(1;'VyrPol'):Op:1::2 ,;
                        cVyrPOL   ,;
                        cNazev    ,;
                        nVarCis   ,;
                        cVarPop   ,;
                        cCisZakaz );
                SIZE(110,10.6) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Seznam operací k položce
TYPE(TabPage) CAPTION( Seznam operací) FPOS(0, 10.7) SIZE(110,14) RESIZE(yx) OFFSET(1,82)
  TYPE(DBrowse) FILE(POLOPER) INDEXORD(1);
               FIELDS( nCisOper:È.oper. ,;
                       nUkonOper        ,;
                       nVarOper         ,;
                       cOznOper         ,;
                       VYR_PriprCas():Pøípravný èas:12:@N 999 999.9999  ,;
                       VYR_KusCas():Kusový èas:12:@N 999 999.9999  ,;
                       nKcNaOper:Cena operace:12:@N 999 999.999  ,;
                       OPERACE->cOznPrac,;
                       mPolOper:Popis operace:25 );
                SIZE(110, 13) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) FOOTER(y)
TYPE(End)

* Popis Operace
TYPE(TabPage) CAPTION( Popis operace) FPOS(0, 10.7) SIZE(110,14) RESIZE(yx) OFFSET(18,66)
  TYPE(MLE) NAME('POLOPER->mPolOper') FPOS( 1, 0.5) SIZE( 108, 12.5) RESIZE(yx) READONLY(y)
TYPE(End)