TYPE(drgForm) DTYPE(10) TITLE(Pro MOPAS ) ;
              SIZE( 85, 15) GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n) ;
              POST( PostValidate)

TYPE(Action) CAPTION(info ~Zakázky) EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)

  TYPE(TabPage) TTYPE(3) CAPTION(Zakázky ke zpracování) FPOS(0.2, 0.1) SIZE( 84.6, 13.5) RESIZE(yx) OFFSET(1, 72) PRE( tabSelect)
    TYPE(DBrowse) FILE(VyrZak) INDEXORD(1);
                  FIELDS( CCISZAKAZ      ,;
                          CNAZEVZAK1::30 ,;
                          CVYRPOL        ,;
                          NVARCIS:Var.   );
                  SIZE(85, 12.4) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(yy)

  TYPE(End)

  TYPE(TabPage) TTYPE(3) CAPTION(Popis ) FPOS(0, 0.1) SIZE( 84.6, 13.5) RESIZE(yx) OFFSET( 28, 46) PRE( tabSelect)
    TYPE(Text) NAME( M->cPopisRep)  FPOS( 2, 1)   CLEN( 60)
*    TYPE(PushButton) POS( 0, 0) SIZE( 0,0)
  TYPE(End)

  TYPE(PushButton) POS(60, 13.5) SIZE(17,1.2) CAPTION(~Start zpracování )  EVENT(Start_ZPRAC)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)

TYPE(END)