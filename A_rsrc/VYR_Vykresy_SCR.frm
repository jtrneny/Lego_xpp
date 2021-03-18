TYPE(drgForm) DTYPE(10) TITLE(V�kresy) FILE(VYKRESY);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              CARGO( VYR_VYKRESY_CRD)

*TYPE(Action) CAPTION(~Kusovn�k pln�)   EVENT(KusTree_Full)     TIPTEXT(Zobrazen� pln�ho strukturovan�ho kusovn�ku )

TYPE(DBrowse) FILE(VYKRESY) INDEXORD(1) ;
              FIELDS( nPorVyk     ,;
                      cCisVyk     ,;
                      cNazVyk     ,;
                      cTypVyk     ,;
                      cModVyk     ,;
                      cAutor      ,;
                      cStred      ,;
                      lVyhISO     ,;
                      cVypujKdo   ,;
                      dVypujDat   );
              SIZE(110,14.6) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(yy);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text) CAPTION(Seznam v�kres�) CPOS( 45, 0.1) CLEN( 20) FONT(5)
  TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Z�kladn� �daje) FPOS(0.5,16.2) SIZE( 109.2, 8.7) RESIZE(yx) OFFSET(2,79) PRE( tabSelect)

*   1.sloupec
    TYPE(Text) CAPTION(Po�.�. v�kresu)          CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(nPorVyk)                    CPOS( 20, 0.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Eviden�n� ��slo v�kresu) CPOS(  3, 1.5)   CLEN( 15)
    TYPE(Text) NAME(cCisVyk)                    CPOS( 20, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Modifikace v�kresu)      CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cModVyk)                    CPOS( 20, 2.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev v�kresu)           CPOS(  3, 3.5)   CLEN( 15)
    TYPE(Text) NAME(cNazVyk)                    CPOS( 20, 3.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ v�kresu)             CPOS(  3, 4.5)   CLEN( 15)
    TYPE(Text) NAME(cTypVyk)                    CPOS( 20, 4.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Autor v�kresu)           CPOS(  3, 5.5)   CLEN( 15)
    TYPE(Text) NAME(cAutor)                     CPOS( 20, 5.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)

*   2.sloupec
    TYPE(Text) CAPTION(Vlastn�c� st�edisko)     CPOS( 55, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cStred)                     CPOS( 72, 0.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Vyhovuje ISO 9001)       CPOS( 55, 1.5)   CLEN( 15)
    TYPE(Text) NAME(lVyhISO)                    CPOS( 72, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Zap�j�eno komu)          CPOS( 55, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cVypujKdo)                  CPOS( 72, 2.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Zap�j�eno kdy)           CPOS( 55, 3.5)   CLEN( 15)
    TYPE(Text) NAME(dVypujDat)                  CPOS( 72, 3.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(TabPage) CAPTION( Popis v�kresu) FPOS(0.5, 16.2) SIZE(109.2, 8.7) RESIZE(yx) OFFSET(21,59)
  TYPE(MLE) NAME('Vykresy->mPopisVyk') FPOS( 0.5, 0.2) SIZE( 108, 7.4) RESIZE(yx) READONLY(y)
TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Vyr�b�n� polo�ky) FPOS(0.5,16.2) SIZE( 109.2, 8.7) RESIZE(yx) OFFSET(40,40) PRE( tabSelect)

  TYPE(DBrowse) FILE(VYRPOL) INDEXORD(3) ;
               FIELDS(cCisZakaz        :Zak�zka         ,;
                      cVyrPol          :Vyr.polo�ka     ,;
                      nVarCis          :Var.            ,;
                      cCisSklad        :Sklad           ,;
                      cSklPol          :Skl.polo�ka     ,;
                      cNazev                            );
               SIZE(108.6, 7.5) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny)
TYPE(End)