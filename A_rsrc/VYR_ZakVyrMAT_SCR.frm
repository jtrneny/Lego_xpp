TYPE(drgForm) DTYPE(10) TITLE(Po�adavky na vyr�b�n� polo�ky na zak�zky) FILE(VYRZAK);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

*TYPE(Action) CAPTION(~Materi�l)        EVENT(ZAK_MATERIAL) TIPTEXT(Po�adavky na materi�l)
*TYPE(Action) CAPTION(~Pl�n vs. skut.)  EVENT(ZAK_PLANSKUT) TIPTEXT(Porovn�n� pl�nu a skute�nosti)
*TYPE(Action) CAPTION(~Zru�it materi�l) EVENT(ZAK_MATERIAL_DEL) TIPTEXT(Zru�it po�adavky na materi�l)

* VYRZAK ... Seznam zak�zek
  TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
               FIELDS( cCisZakaz::20   ,;
                       cStavZakaz:Stav ,;
                       nVarCis     ,;
                       nMnozPlano  );
               SIZE(30,24) CURSORMODE(3) PP(7) Resize(yy) SCROLL(ny) POPUPMENU(yn);
               ITEMMARKED( ItemMarked)

* VYRPOL - vyr�b�nn� polo�ky 
  TYPE(TabPage) CAPTION( Po�adavky) FPOS(33,0.10) SIZE(70,24.0) RESIZE(yx) OFFSET(1,82)

    TYPE(DBrowse) FILE(VYRPOL) INDEXORD(1);
                 FIELDS( cVyrPol:Vyr�b�n� polo�ka:15     ,;
                         cNazev:N�zev polo�ky:35         ,;
                         nMnZADva:po�adovan�          );
                 SIZE(67, 23.0) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)
  TYPE(End)

TYPE(End)
