TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky s daným parametrem) SIZE(110, 20);
               GUILOOK(Action:y,Message:n,IconBar:y:StdIconBar,Menu:n)

TYPE(Action) CAPTION(~info Zakázka) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky )

* Parametr zakázky
  TYPE(Static) STYPE(12) SIZE(109,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Oznaèení parametru) CPOS( 2, 0.2) CLEN( 20) FONT(2)
    TYPE(Text) NAME(ParZAK->cAtrib)        CPOS( 2, 1.2) CLEN( 30) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název parametru)    CPOS(35, 0.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(ParZAK->cAtribNaz)     CPOS(35, 1.2) CLEN( 60) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(End)

* Zakázky obsahující daný parametr
  TYPE(DBrowse) FILE(ZAKAPAR) INDEXORD(2);
                FIELDS( cCisZakaz   ,;
                        cAtrib      ,;
                        cHodnAtrC   ,;
                        nHodnAtrN:Hodnota èís.   );
                FPOS( 0, 3) SIZE(110, 17) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(nn);
                ITEMMARKED( itemMarked)
