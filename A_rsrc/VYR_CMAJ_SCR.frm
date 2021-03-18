TYPE(drgForm) DTYPE(10) TITLE(Majetek v evidenci);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,Menu:n,IconBar:Y:drgStdBrowseIconBar);
              CARGO(VYR_CMAJ_CRD)

*TYPE(Action) CAPTION(~Editace operací) EVENT(Edit_PolOper) TIPTEXT(Poøizování operací k vyrábìné položce )

* Èíselník majetku
  TYPE(DBrowse) FILE(C_MAJ) INDEXORD(1);
               FIELDS( cDruhMaj, nInvCis, nInvCisDIM, cNazevMaj, cTypMaj, nZivotNh, cZkratJEDN, cPouzMAJ) ;
               SIZE(100,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)

* Popis majetku
TYPE(TabPage) CAPTION( Popis majetku) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(1,82)
  TYPE(MLE) NAME('C_MAJ->mPopisMAJ') FPOS( 1, 0.5) SIZE( 98, 9) RESIZE(yx) READONLY(y)
TYPE(End)

* Návod na použití
TYPE(TabPage) CAPTION( Návod na použití) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66)
  TYPE(MLE) NAME('C_MAJ->mNavodPouz') FPOS( 1, 0.5) SIZE( 98, 9) RESIZE(yx) READONLY(y)
TYPE(End)