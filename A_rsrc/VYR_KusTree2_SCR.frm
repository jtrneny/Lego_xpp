TYPE(drgForm) DTYPE(10) TITLE(Strukturovan� kusovn�k ...) SIZE(120,26) FILE(KUSTREE) BORDER(2) ;
                        GUILOOK(Action:y,IconBar:y,Menu:y);
                        PRINTFILES(kustree,      ;
                                          poloper:cciszakaz=cciszakaz+cvyrpol=cvyrpol,      ;
                                          poloper_w1:cciszakaz=cciszakaz+cvyrpol=cvyrpol  ) ;
                        CARGO(VYR_POLOPER_CRD) CBSAVE(OnSave)

TYPE(Action) CAPTION(info ~Zak�zka)  EVENT( VYR_VYRZAK_INFO) TIPTEXT(Informa�n� karta v�robn� zak�zky)
TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION(info C~en�k)     EVENT( VYR_CENZBOZ_INFO)  TIPTEXT(Informa�n� karta materi�lu)
TYPE(Action) CAPTION(Ko~ntr.na Cen�k) EVENT( VYR_CENZBOZ_EXIST) TIPTEXT(Kontrola na existenci materi�l� v cen�ku)
TYPE(Action) CAPTION(~Techn. postup)  EVENT(VYR_POSTUPTECH)     TIPTEXT(Technologick� postup)
TYPE(Action) CAPTION(~Kopie operac�)  EVENT( POLOPER_COPY_more) TIPTEXT(Mechanismus kop�rov�n� polo�ek operac�)
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
TYPE(Action) CAPTION(info ~Operace)   EVENT( VYR_POLOPER_INFO) TIPTEXT(Informa�n� karta operace k vyr�b�n� polo�ce )
TYPE(Action) CAPTION(info ~Typ.oper.) EVENT( VYR_OPERACE_INFO) TIPTEXT(Informa�n� karta typov� operace)
TYPE(Action) CAPTION(~Kopie operace)  EVENT( POLOPER_COPY_one) TIPTEXT(Kopie jednotliv� polo�ky operace)
*TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) CAPTION(~Techn. postup)  EVENT(VYR_POSTUPTECH) TIPTEXT(Technologick� postup)
*TYPE(Action) CAPTION(~Mont. postup)   EVENT(Vyr_PostupMont) TIPTEXT(Mont�n� postup)


* HLA
  TYPE(Static) STYPE(13) SIZE(120,2.6) FPOS(0, 0) RESIZE(yn)
    TYPE(Text) CAPTION(V�robn� zak�zka )  CPOS(  1, 0.2) CLEN( 18) FONT(2)

    TYPE(Text) NAME(VyrPol->cCisZakaz)    CPOS( 20, 0.2) CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)   CPOS( 57, 0.2) CLEN( 62) BGND( 13) FONT(5) GROUPS(clrGREEN)

    TYPE(Text) CAPTION(Vyr�b�n� polo�ka)  CPOS(   1, 1.2) CLEN( 18) FONT(2)
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
    TYPE(Text) CAPTION(�ist� mno�stv�)        CPOS(  1, 0.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nCiMno)          CPOS( 18, 0.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Spot�ebn� mno�stv�)    CPOS(  1, 1.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nSpMno)          CPOS( 18, 1.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Spot�. mn. sklad.)     CPOS(  1, 2.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->nSpMno)          CPOS( 18, 2.5) CLEN( 15) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(M�rn� jednotka)        CPOS(  1, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cZkratJedn)      CPOS( 18, 3.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ materi�lu)         CPOS(  1, 4.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cTypMat)         CPOS( 18, 4.5) CLEN( 15) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Text 1)                CPOS(  1, 6.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cText1)          CPOS( 18, 6.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Text 2)                CPOS(  1, 7.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cText2)          CPOS( 18, 7.5) CLEN( 60) BGND( 13) PP(2) FONT(5) GROUPS(clrGREY)
* 2.sl.
    TYPE(Text) CAPTION(Typ polo�ky)           CPOS( 35, 0.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cTypPOL)         CPOS( 52, 0.5) CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Polo�ka ni���-skladov�)CPOS( 35, 1.5) CLEN( 17)
    TYPE(Text) NAME(KusTree->cVyrPol)         CPOS( 52, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) NAME(KusTree->cSklPol)         CPOS( 73, 1.5) CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev polo�ky)         CPOS( 35, 2.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cNazev)          CPOS( 52, 2.5) CLEN( 42) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pozice)                CPOS( 35, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nPozice)         CPOS( 52, 3.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta pozice)       CPOS( 35, 4.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->nVarPoz)         CPOS( 52, 4.5) CLEN(  5) BGND( 13) CTYPE(2) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(K�d pozice)            CPOS( 60, 3.5) CLEN( 15)
    TYPE(Text) NAME(KusTree->cKodPoz)         CPOS( 75, 3.5) CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Index pozice)          CPOS( 60, 4.5) CLEN( 15)
*    TYPE(Text) NAME(KusTree->cKodPoz)         CPOS( 75, 4.5) CLEN( 5) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TabPage) TTYPE(4) CAPTION(OPERACE) FPOS(0.2, 5.8) SIZE( 119.6, 20.1) OFFSET(18,66) RESIZE(yx) PRE( tabSelect)
    TYPE(DBrowse) FILE(PolOper) INDEXORD(1) ;
                 FIELDS( nCisOper:�.oper.  ,;
                         nUkonOper,;
                         cOznOper:Typov� oper. ,;
                         VYR_KusCAS():Kusov� �as:12:999 999.9999 ,;
                         VYR_PriprCas():P��pravn� �as:12:999 999.9999,;
                         nKcNaOper:Cena operace:13:999 999.999 ,;
                         OPERACE->cOznPrac,;
                         mPolOper:Popis operace:45 ,;
                         OPERACE->cNazOper ,;
                         cCisZakazI:Polo�ka zak�zky  ,;
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