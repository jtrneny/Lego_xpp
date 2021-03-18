TYPE(drgForm) DTYPE(10) TITLE(Požadavky na vyrábìné položky na zakázky) FILE(VYRZAK);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

*TYPE(Action) CAPTION(~Materiál)        EVENT(ZAK_MATERIAL) TIPTEXT(Požadavky na materiál)
*TYPE(Action) CAPTION(~Plán vs. skut.)  EVENT(ZAK_PLANSKUT) TIPTEXT(Porovnání plánu a skuteènosti)
*TYPE(Action) CAPTION(~Zrušit materiál) EVENT(ZAK_MATERIAL_DEL) TIPTEXT(Zrušit požadavky na materiál)

* VYRZAK ... Seznam zakázek
  TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
               FIELDS( cCisZakaz::20   ,;
                       cStavZakaz:Stav ,;
                       nVarCis     ,;
                       nMnozPlano  );
               SIZE(30,24) CURSORMODE(3) PP(7) Resize(yy) SCROLL(ny) POPUPMENU(yn);
               ITEMMARKED( ItemMarked)

* VYRPOL - vyrábìnné položky 
  TYPE(TabPage) CAPTION( Požadavky) FPOS(33,0.10) SIZE(70,24.0) RESIZE(yx) OFFSET(1,82)

    TYPE(DBrowse) FILE(VYRPOL) INDEXORD(1);
                 FIELDS( cVyrPol:Vyrábìná položka:15     ,;
                         cNazev:Název položky:35         ,;
                         nMnZADva:požadované          );
                 SIZE(67, 23.0) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)
  TYPE(End)

TYPE(End)
