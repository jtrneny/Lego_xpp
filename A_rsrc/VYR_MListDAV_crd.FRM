TYPE(drgForm) DTYPE(10) TITLE(Mzdové lístky - hromadný vstup) SIZE(110, 25) FILE(List_DAVw);
               GUILOOK(Action:y,Message:y,IconBar:y:MyIconBar,Menu:n);
               PRE( PreValidate) POST( PostValidate)

TYPE(Action) CAPTION(info ~Mzd.lístek)   EVENT(VYR_LISTIT_INFO) TIPTEXT( Informaèní karta mzdového lístku)
TYPE(Action) CAPTION(info ~Zakázka)      EVENT(VYR_VYRZAK_INFO) TIPTEXT( Informaèní karta výrobní zakázky)


* Položky dávky
  TYPE(EBrowse) FILE( List_DAVIw) INDEXORD(1) ;
                FPOS( 0.1, 6.3) SIZE(109.8,16.6) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(ny) POPUPMENU(yn);
                ITEMMARKED(itemMarked) FOOTER(y)

    TYPE(TEXT) NAME( List_DAVIw->nOrdItem)     FPOS( 1,0) CLEN( 7)  CAPTION(Poø.)
    TYPE(GET ) NAME( List_DAVIw->cCisZakazI)   FPOS( 2,0) FLEN(26)  CAPTION(Pol. zakázky) PUSH(VyrZakIT_sel)
    TYPE(GET ) NAME( List_DAVIw->nCisOper)     FPOS( 3,0) FLEN( 7)  CAPTION(È.op.)        PUSH(PolOper_Sel)
    TYPE(TEXT) NAME( List_DAVIw->cNazOper)     FPOS( 4,0) CLEN(25)  CAPTION(Název operace)
    TYPE(GET ) NAME( List_DAVIw->dVyhotSkut)   FPOS( 5,0) FLEN(12)  CAPTION(Dat.vyh.Sk)   PUSH( ClickDATE )
    TYPE(GET ) NAME( List_DAVIw->nKusyCelk)    FPOS( 6,0) FLEN(10)  CAPTION(Ks Celkem)
    TYPE(TEXT) NAME( List_DAVIw->nPorCisLis)   FPOS( 7,0) CLEN(12)  CAPTION(Èíslo ML)
    TYPE(TEXT) NAME( List_DAVIw->nRokVytvor)   FPOS( 8,0) CLEN( 6)  CAPTION(Rok ML)
    TYPE(TEXT) NAME( List_DAVIw->nKusyHotov)   FPOS( 9,0) CLEN(10)  CAPTION(Ks Hotové)
    TYPE(TEXT) NAME( List_DAVIw->nHodiny)      FPOS(10,0) CLEN(10)  CAPTION(Hodiny)

  TYPE(End)
*
  TYPE(Static) STYPE(13) SIZE(109.6, 1.8) FPOS(0.2, 23.1) CTYPE(2) RESIZE(ny)
    TYPE(PushButton) CAPTION( Uložit DÁVKU)     POS(94, 0.4) SIZE(15, 1.1) EVENT('Save_ML' ) PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
*
  TYPE(Static) STYPE(12) SIZE(109.6,1.3) FPOS(0.2,5.2) RESIZE(yn)
    TYPE(Text)       CAPTION( Mzdové lístky)   CPOS( 1, 0.1) CLEN( 20) SIZE(20, 1.2) FONT(5)
  TYPE(End)

* Hlavièka dávky
  TYPE(Static) STYPE(13) SIZE(109.6, 5) FPOS(0.2,0) CTYPE(2) RESIZE(yn)
    TYPE(Text) CAPTION(È.dávky)            CPOS(  1, 0.2) CLEN( 15) FONT(2)
    TYPE(GET)  NAME(List_DAVw->nDavka)     FPOS( 17, 0.2) FLEN( 10) FONT(5)
    TYPE(Text) CAPTION(Dat.poøízení)       CPOS( 57, 0.2) CLEN( 11) FONT(2)
    TYPE(GET)  NAME(List_DAVw->dDatPorDav) FPOS( 68, 0.2) FLEN( 12) FONT(5) PUSH( ClickDATE )
*
    TYPE(Text) CAPTION(Os.èís.prac-PV)     CPOS(  1, 1.5) CLEN( 15) FONT(2)
    TYPE(GET)  NAME(List_DAVw->nOsCisPrac) FPOS( 17, 1.5) FLEN( 10) FONT(5)  PUSH(VYR_kmenove_SEL) NOREVISION()
    TYPE(Text) NAME(List_DAVw->nPorPraVzt) CPOS( 30, 1.5) CLEN( 25) BGND(12) GROUPS(clrGREY)
*    TYPE(Text) NAME(Osoby->cjmenoRozl)     CPOS( 25, 1.5) CLEN( 25) BGND(12) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Hod. sazba)         CPOS( 52, 1.5) CLEN( 10) FONT(2)
*    TYPE(GET)  NAME(List_DAVw->nTarSazHod) FPOS( 63, 1.5) FLEN( 12) FONT(5)
*
    TYPE(Text) CAPTION(Èíslo osoby)        CPOS(  1, 2.6) CLEN( 15) FONT(2)
    TYPE(GET)  NAME(List_DAVw->nCisOsoby)  FPOS( 17, 2.6) FLEN( 10) FONT(5)  NOREVISION()
    TYPE(Text) NAME(List_DAVw->cjmenoRozl) CPOS( 30, 2.6) CLEN( 25) BGND(12) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Hod. sazba)         CPOS( 57, 2.6) CLEN( 10) FONT(2)
    TYPE(GET)  NAME(List_DAVw->nTarSazHod) FPOS( 68, 2.6) FLEN( 12) FONT(5)
*
    TYPE(Text) CAPTION(Støedisko)          CPOS(  1, 3.7) CLEN( 15) FONT(2)
    TYPE(GET)  NAME(List_DAVw->cStred)     FPOS( 17, 3.7) FLEN( 10) FONT(5)
    TYPE(Text) NAME(C_Stred->cNazStr)      CPOS( 30, 3.7) CLEN( 25) BGND(12) GROUPS(clrGREY)

  TYPE(End)