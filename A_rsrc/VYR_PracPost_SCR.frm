TYPE(drgForm) DTYPE(10) TITLE(Katalog pracovních postupù) FILE(PRACPOST);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_PracPost_crd)

*TYPE(Action) CAPTION(~) EVENT() TIPTEXT( )

* PRACPOST ... Katalog pracovních postupù
  TYPE(Browse) FILE(PRACPOST) INDEXORD(1);
               FIELDS( cOznPrPo  ,;
                       cTypPrPo  ,;
                       cNazPrPo  ,;
                       cStred    ,;
*                       C_Stred->cNazStr,;
                       cOznPrac  ,;
*                       C_Pracov->cNazevPrac,;
                       cStavPrPo) ;
               SIZE(100,14) CURSORMODE(3) PP(7) SCROLL(ny);
               ITEMMARKED( ItemMarked)

* Text prac.postupu
  TYPE(TabPage) CAPTION( Text postupu) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET( 1,82)

    TYPE(MLE) NAME('PracPost->mTextPrPo') FPOS( 1, 0.2) SIZE( 98, 9) RESIZE(yx) READONLY(y)

  TYPE(End)

* Výskyt v operacích
  TYPE(TabPage) CAPTION( Výskyt v operacích) FPOS(0, 14.2) SIZE(100,10.5) RESIZE(yx) OFFSET(18,66)

    TYPE(Browse) FILE(OPERACE) INDEXORD(1);
               FIELDS( cOznOper  ,;
                       cTypOper  ,;
                       cNazOper  ,;
                       cNazPol6  ,;
                       cStred    ,;
                       cOznPrac  ,;
                       cPracZar  ,;
                       nDruhMzdy) ;
               SIZE(100, 9.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)
  TYPE(End)
