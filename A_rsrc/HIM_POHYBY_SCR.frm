TYPE(drgForm) DTYPE(10) TITLE(Pohybov� doklady - dle doklad�);
              SIZE(105,25) GUILOOK(Message:Y,Action:Y,IconBar:Y:drgStdBrowseIconBar);
              OBDOBI(HIM)

TYPE(Action) CAPTION(~Tvorba doklad�) EVENT(VYBER_POHYB)  TIPTEXT(Po�izov�n� pohybov�ch doklad� )
TYPE(Action) CAPTION(info ~Majetku)   EVENT(HIM_MAJ_INFO) TIPTEXT(informa�n� karta investi�n�ho majetku )
*TYPE(Action) CAPTION(��etn� ~Odpisy ) EVENT(ODPISY_GEN)   TIPTEXT(Generov�n� ��etn�ch odpis� za obdob� )

* Seznam Doklad�
  TYPE(DBrowse) FILE(ZMAJU) INDEXORD(3);
               FIELDS( M->IsDoklad_LIK:L:2,;
                       nDoklad ,;
                       cObdobi ,;
                       nInvCis ,;
                       nTypMaj ,;
                       C_TypMaj->cNazTypu,;
                       cTypPohybu:Pohyb ,;
                       C_TypPoh->cNazTypPoh:N�zev pohybu) ;
               SIZE(105,14) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)

* TYPE(Static) STYPE(12) SIZE(105,10.5) FPOS(0,14.2) Resize(nx) CTYPE(2)

* Detail dokladu
  TYPE(TabPage) TTYPE(4) CAPTION(Detail dokladu) SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(1,82)
    TYPE(Static) STYPE(12) SIZE(103,6.8) FPOS(1, .01) RESIZE(yx) CTYPE(2)
      TYPE(TEXT) CAPTION(Invent�rn� ��slo)  CPOS( 1, 0.2) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nInvCis)       CPOS(18, 0.2) CLEN( 13) BGND( 13) CTYPE(2) PP(2) FONT(5) GROUPS(clrYELLOW)
      TYPE(TEXT) NAME(MAJ->cNazev)          CPOS(32, 0.2) CLEN( 31) BGND( 13) FONT(5) GROUPS(clrYELLOW)
      TYPE(Text) CAPTION(��slo dokladu )    CPOS(68, 0.2) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJU->nDOKLAD)       CPOS(81, 0.2) CLEN( 10) BGND( 13) CTYPE(2) PP(2) FONT(5) GROUPS(clrGREEN)

      TYPE(TEXT) CAPTION(Vstupn� cena ��.)    CPOS( 1, 1.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nCenaVstU)       CPOS(18, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Opr�vky ��etn�)      CPOS( 1, 2.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nOprUct)         CPOS(18, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Z�statkov� cena ��.) CPOS( 1, 3.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nZustCenaU)      CPOS(18, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(M�s��n� odpis)       CPOS( 1, 4.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nUctOdpMes)      CPOS(18, 4.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

      TYPE(TEXT) CAPTION(Zm�na vst. ceny ��.)  CPOS(33, 1.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nZmenVstCU)       CPOS(50, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Zm�na opr�vek ��et.)  CPOS(33, 2.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nZmenOprU)        CPOS(50, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Zm�na vst. ceny da�.) CPOS(33, 3.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nZmenVstCD)       CPOS(50, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Zm�na opr�vek da�.)   CPOS(33, 4.4) CLEN( 16)
      TYPE(TEXT) NAME(ZMAJU->nZmenOprD)        CPOS(50, 4.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

      TYPE(TEXT) CAPTION(Dodac� list)          CPOS(68, 1.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJU->nCisloDL)         CPOS(81, 1.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(��slo faktury)        CPOS(68, 2.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJU->nCisFak)          CPOS(81, 2.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
      TYPE(TEXT) CAPTION(Variab. symbol   )    CPOS(68, 3.4) CLEN( 12)
      TYPE(TEXT) NAME(ZMAJU->cVarSym)          CPOS(81, 3.4) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(End)

*   N�kladov� struktura
    TYPE(Static) STYPE(11) SIZE(103,2.6) FPOS(1, 6.9) RESIZE(yx) CTYPE(2)
      TYPE(Text) CAPTION(V�r.st�ed.)           CPOS( 2, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS( 2,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
      TYPE(Text) FCAPTION(V�robek)             CPOS(18, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(18,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
      TYPE(Text) FCAPTION(Zak�zka)             CPOS(34, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(34,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
      TYPE(Text) FCAPTION(V�r. m�sto)          CPOS(50, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(50,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
      TYPE(Text) FCAPTION(Stroj)               CPOS(66, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(66,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
      TYPE(Text) FCAPTION(V�r. operace)        CPOS(82, .2)          BGND( 1) PP(3)
      TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(82,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(End)
  TYPE(End)

* Detail majetku
**  TYPE(TabPage) TTYPE(4) CAPTION(Detail majetku)  SIZE(105,10.7) FPOS(0,14.2) RESIZE(yx) OFFSET(16,68)

*   INFO
*   1.��dek
**    TYPE(Text) CAPTION(Inv.��slo)                 CPOS(  3, 0.5)   CLEN(  8) FONT(5)
**    TYPE(Text) NAME(MAJ->nInvCis)       CPOS(  3, 1.5)   CLEN(  8) BGND( 13) PP(2)
**  TYPE(End)