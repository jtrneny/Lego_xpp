TYPE(drgForm) DTYPE(10) TITLE(Zobrazení vazeb úkolu pro osoby - exTree) SIZE(130,26) FILE(UKOLY) BORDER(2) ;
                        GUILOOK(Action:y,IconBar:y,Menu:y);
                        CARGO(KAN_UKOLY_CRD) CBSAVE(OnSave)


* HLA
  TYPE(Static) STYPE(13) SIZE(120,2.6) FPOS(0, 0) RESIZE(yn)
*    TYPE(Text) CAPTION(Výrobní zakázka )  CPOS(  1, 0.2) CLEN( 18) FONT(2)

*    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.2) CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREEN)
*    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 57, 0.2) CLEN( 62) BGND( 13) FONT(5) GROUPS(clrGREEN)

*    TYPE(Text) CAPTION(Vyrábìná položka)  CPOS(   1, 1.2) CLEN( 18) FONT(2)
*    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS(  20, 1.23) CLEN( 15) BGND( 13) FONT(5) PP(2)
*    TYPE(Text) NAME(VyrPol->cNazev)       CPOS(  37, 1.23) CLEN( 40) FONT(5) PP(2)
*    TYPE(Text) CAPTION(Var-)              CPOS(  78, 1.2) CLEN(  5) FONT(2)
*    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS(  83, 1.2) CLEN(  4) PP(2) CTYPE(2)

*    TYPE(STATIC) STYPE(2) FPOS(94,1) SIZE(25.2,1.0) RESIZE(nx)
*      TYPE(PushButton) POS(.1,.1)   SIZE(25.3,1.2) CAPTION(~Kusovník plný) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3) 
*    TYPE(END) 
  TYPE(End)


* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,2.7) SIZE(129,13) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT( TreeInit);
                 ITEMMARKED(TreeItemMarked);
                 ITEMSELECTED( TreeItemSelected)


  TYPE(TabPage) TTYPE(4) CAPTION(INFO) FPOS( 0.2, 15.8) SIZE( 119.6, 10.1) OFFSET(1,82) RESIZE(yx) PRE( tabSelect)
* 1.sl.
    TYPE(Text) CAPTION(Èisté množství)        CPOS(  1, 0.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nCiMno)          CPOS( 18, 0.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(KusTree->cMjTpv)          CPOS( 33, 0.5) CLEN(  7) BGND( 13) CTYPE(2)
    TYPE(Text) CAPTION(Spotøební množství)    CPOS(  1, 1.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nSpMno)          CPOS( 18, 1.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(KusTree->cMjSpo)          CPOS( 33, 1.5) CLEN(  7) BGND( 13) CTYPE(2)
    TYPE(Text) CAPTION(Spotø. mn. sklad.)     CPOS(  1, 2.5) CLEN( 15)
*    TYPE(Text) NAME(M->nSpMnoSkl)             CPOS( 18, 2.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(KusTree->cZkratJedn)      CPOS( 33, 2.5) CLEN(  7) BGND( 13) CTYPE(2)
*
    TYPE(Text) CAPTION(Cena mater.CELK)       CPOS(  1, 3.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nCenaCelk5)      CPOS( 18, 3.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena mater.MJ)         CPOS(  1, 4.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nCenMat_MJ)      CPOS( 18, 4.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
*
    TYPE(Text) CAPTION(Text 1)                CPOS(  1, 6.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cText1)          CPOS( 18, 6.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Text 2)                CPOS(  1, 7.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cText2)          CPOS( 18, 7.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
* 2.sl.
    TYPE(Text) CAPTION(Typ položky)           CPOS( 45, 0.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cTypPOL)         CPOS( 62, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Položka nižší-skladová)CPOS( 45, 1.5) CLEN( 17)
*    TYPE(Text) NAME(KusTree->cVyrPol)         CPOS( 62, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) NAME(KusTree->cSklPol)         CPOS( 83, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název položky)         CPOS( 45, 2.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cNazev)          CPOS( 62, 2.5) CLEN( 42) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pozice)                CPOS( 45, 3.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nPozice)         CPOS( 62, 3.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta pozice)       CPOS( 45, 4.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nVarPoz)         CPOS( 62, 4.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Kód pozice)            CPOS( 70, 3.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cKodPoz)         CPOS( 85, 3.5) CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

 



