TYPE(drgForm) DTYPE(10) TITLE(Strukturovaný kusovník ...) SIZE(120,26) FILE(KUSTREE) BORDER(2) ;
                        GUILOOK(Action:y,IconBar:y,Menu:y);
                        PRINTFILES(kustree,      ;
                                          poloper:cciszakaz=cciszakaz+cvyrpol=cvyrpol,      ;
                                          poloper_w1:cciszakaz=cciszakaz+cvyrpol=cvyrpol  ) ;
                        CARGO(VYR_POLOPER_CRD) CBSAVE(OnSave)

TYPE(Action) CAPTION(info ~Zakázka)  EVENT( VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION(info C~eník)     EVENT( VYR_CENZBOZ_INFO)  TIPTEXT(Informaèní karta materiálu)
TYPE(Action) CAPTION(Ko~ntr.na Ceník) EVENT( VYR_CENZBOZ_EXIST) TIPTEXT(Kontrola na existenci materiálù v ceníku)
TYPE(Action) CAPTION(~Techn. postup)  EVENT(VYR_POSTUPTECH)     TIPTEXT(Technologický postup)
TYPE(Action) CAPTION(~Kopie operací)  EVENT( POLOPER_COPY_more) TIPTEXT(Mechanismus kopírování položek operací)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) EVENT(SEPARATOR)
*TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION(info ~Operace)   EVENT( VYR_POLOPER_INFO) TIPTEXT(Informaèní karta operace k vyrábìné položce )
TYPE(Action) CAPTION(info ~Typ.oper.) EVENT( VYR_OPERACE_INFO) TIPTEXT(Informaèní karta typové operace)
TYPE(Action) CAPTION(~Kopie operace)  EVENT( POLOPER_COPY_one) TIPTEXT(Kopie jednotlivé položky operace)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Techn. postup)  EVENT(VYR_POSTUPTECH) TIPTEXT(Technologický postup)
*TYPE(Action) CAPTION(~Mont. postup)   EVENT(Vyr_PostupMont) TIPTEXT(Montážní postup)


* HLA
  TYPE(Static) STYPE(13) SIZE(120,2.6) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(Výrobní zakázka )  CPOS(  1, 0.2) CLEN( 18) FONT(2)

    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.2) CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 57, 0.2) CLEN( 62) BGND( 13) FONT(5) GROUPS(clrGREEN)

    TYPE(Text) CAPTION(Vyrábìná položka)  CPOS(   1, 1.2) CLEN( 18) FONT(2)
    TYPE(Text) NAME(VyrPol->cVyrPol)      CPOS(  20, 1.2) CLEN( 35) BGND( 13) FONT(5) PP(2)
    TYPE(Text) NAME(VyrPol->cNazev)       CPOS(  57, 1.2) CLEN( 50) BGND( 13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Var.)              CPOS( 109, 1.2) CLEN(  5) FONT(2)
    TYPE(Text) NAME(VyrPol->nVarCis)      CPOS( 115, 1.2) CLEN(  4) BGND( 13) PP(2) CTYPE(2)
  TYPE(End)

* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,2.7) SIZE(119,3) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 TREEINIT( TreeInit);
                 ITEMMARKED(TreeItemMarked);
                 ITEMSELECTED( TreeItemSelected)

  TYPE(TabPage) TTYPE(4) CAPTION(INFO) FPOS( 0.2, 5.8) SIZE( 119.6, 20.1) OFFSET(1,82) RESIZE(yx) PRE( tabSelect)
* 1.sl.
    TYPE(Text) CAPTION(Èisté množství)        CPOS(  1, 0.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nCiMno)          CPOS( 18, 0.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Spotøební množství)    CPOS(  1, 1.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nSpMno)          CPOS( 18, 1.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Spotø. mn. sklad.)     CPOS(  1, 2.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nSpMno)          CPOS( 18, 2.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mìrná jednotka)        CPOS(  1, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cZkratJedn)      CPOS( 18, 3.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ materiálu)         CPOS(  1, 4.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cTypMat)         CPOS( 18, 4.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Text 1)                CPOS(  1, 6.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cText1)          CPOS( 18, 6.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Text 2)                CPOS(  1, 7.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cText2)          CPOS( 18, 7.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
* 2.sl.
    TYPE(Text) CAPTION(Typ položky)           CPOS( 35, 0.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cTypPOL)         CPOS( 52, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Položka nižší-skladová)CPOS( 35, 1.5) CLEN( 17)
    TYPE(Text) NAME(KusTree->cVyrPol)         CPOS( 52, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(KusTree->cSklPol)         CPOS( 73, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název položky)         CPOS( 35, 2.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cNazev)          CPOS( 52, 2.5) CLEN( 42) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pozice)                CPOS( 35, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nPozice)         CPOS( 52, 3.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta pozice)       CPOS( 35, 4.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nVarPoz)         CPOS( 52, 4.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Kód pozice)            CPOS( 60, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cKodPoz)         CPOS( 75, 3.5) CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Index pozice)          CPOS( 60, 4.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cKodPoz)         CPOS( 75, 4.5) CLEN( 5) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(OPERACE) FPOS(0.2, 5.8) SIZE( 119.6, 20.1) OFFSET(18,66) RESIZE(yx) PRE( tabSelect)
    TYPE(DBrowse) FILE(PolOper) INDEXORD(1) ;
                 FIELDS( nCisOper:È.oper.  ,;
                         nUkonOper,;
                         cOznOper:Typová oper. ,;
                         VYR_KusCAS():Kusový èas:12:999 999.9999 ,;
                         VYR_PriprCas():Pøípravný èas:12:999 999.9999,;
                         nKcNaOper:Cena operace:13:999 999.999 ,;
                         OPERACE->cOznPrac,;
                         mPolOper:Popis operace:45 ,;
                         OPERACE->cNazOper ,;
                         cCisZakazI:Položka zakázky  ,;
                         nPorCisLis );
                 FPOS( 0.2, 0.0) SIZE(118.8, 18.9 ) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y)

  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(SKLADY) FPOS(0.2, 5.8) SIZE( 119.6, 20.1) OFFSET(34,50) RESIZE(yx) PRE( tabSelect)
    TYPE(DBrowse) FILE(CenZBOZ) INDEXORD(1) ;
                 FIELDS( cCisSklad     ,;
                         cSklPol       ,;
                         cNazZbo       ,;
                         nMnozSZBO     ,;
                         cZkratJEDN:MJ ,;
                         nCenaPZBO     ,;
                         nCenaSZBO     ,;
                         nCenaVNI      );
                 FPOS( 0.2, 0.0) SIZE(118.5, 18.9 ) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)
  TYPE(End)