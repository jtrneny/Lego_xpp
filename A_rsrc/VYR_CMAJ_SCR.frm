TYPE(drgForm) DTYPE(10) TITLE(Majetek v evidenci);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,Menu:n,IconBar:Y:drgStdBrowseIconBar);
              CARGO(VYR_CMAJ_CRD)

*TYPE(Action) CAPTION(~Editace operac�) EVENT(Edit_PolOper) TIPTEXT(Po�izov�n� operac� k vyr�b�n� polo�ce )

* ��seln�k majetku
  TYPE(DBrowse) FILE(C_MAJ) INDEXORD(1);
               FIELDS( cDruhMaj, nInvCis, nInvCisDIM, cNazevMaj, cTypMaj, nZivotNh, cZkratJEDN, cPouzMAJ) ;
               SIZE(100,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)

* Popis majetku
TYPE(TabPage) CAPTION( Popis majetku) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(1,82)
  TYPE(MLE) NAME('C_MAJ->mPopisMAJ') FPOS( 1, 0.5) SIZE( 98, 9) RESIZE(yx) READONLY(y)
TYPE(End)

* N�vod na pou�it�
TYPE(TabPage) CAPTION( N�vod na pou�it�) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66)
  TYPE(MLE) NAME('C_MAJ->mNavodPouz') FPOS( 1, 0.5) SIZE( 98, 9) RESIZE(yx) READONLY(y)
TYPE(End)