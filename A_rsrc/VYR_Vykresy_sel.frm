TYPE(drgForm) DTYPE(10) TITLE(V�kresy - V�B�R) FILE(VYKRESY);
              SIZE(110,20) GUILOOK(Message:Y,Action:N,IconBar:Y)

*TYPE(Action) CAPTION(~Info polo�ky)  EVENT(VYR_VyrPol_INFO)  TIPTEXT(Informa�n� karta vyr�b�n� polo�ky )

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
              SIZE(110,19.8) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)
*
*  TYPE(Static) STYPE(13) SIZE(108,7.2) FPOS(1,12.6) Resize(nn)
*    TYPE(Text) CAPTION(Po�.�. v�kresu)          CPOS(  3, 0.5)   CLEN( 15)
*    TYPE(Text) NAME(nPorVyk)                    CPOS( 20, 0.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Eviden�n� ��slo v�kresu) CPOS(  3, 1.5)   CLEN( 15)
*    TYPE(Text) NAME(cCisVyk)                    CPOS( 20, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Modifikace v�kresu)      CPOS(  3, 2.5)   CLEN( 15)
*    TYPE(Text) NAME(cModVyk)                    CPOS( 20, 2.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(N�zev v�kresu)           CPOS(  3, 3.5)   CLEN( 15)
*    TYPE(Text) NAME(cNazVyk)                    CPOS( 20, 3.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Typ v�kresu)             CPOS(  3, 4.5)   CLEN( 15)
*    TYPE(Text) NAME(cTypVyk)                    CPOS( 20, 4.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Autor v�kresu)           CPOS(  3, 5.5)   CLEN( 15)
*    TYPE(Text) NAME(cAutor)                     CPOS( 20, 5.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)

*   2.sloupec
*    TYPE(Text) CAPTION(Vlastn�c� st�edisko)     CPOS( 55, 0.5)   CLEN( 15)
*    TYPE(Text) NAME(cStred)                     CPOS( 72, 0.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Vyhovuje ISO 9001)       CPOS( 55, 1.5)   CLEN( 15)
*    TYPE(Text) NAME(lVyhISO)                    CPOS( 72, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Zap�j�eno komu)          CPOS( 55, 2.5)   CLEN( 15)
*    TYPE(Text) NAME(cVypujKdo)                  CPOS( 72, 2.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(Text) CAPTION(Zap�j�eno kdy)           CPOS( 55, 3.5)   CLEN( 15)
*    TYPE(Text) NAME(dVypujDat)                  CPOS( 72, 3.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*TYPE(End)



