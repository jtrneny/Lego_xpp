TYPE(drgForm) DTYPE(10) TITLE(Vyr�b�n� polo�ky) FILE(VYRPOL);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              PRINTFILES(kusov, cSklpol = cSklPol) ;
              CARGO( VYR_VYRPOL_CRD)

TYPE(Action) CAPTION(~Kusovn�k pln�)   EVENT(KusTree_Full)     TIPTEXT(Zobrazen� pln�ho strukturovan�ho kusovn�ku )
TYPE(Action) CAPTION(K~usovn�k 1.vs)   EVENT(KusTree_First)    TIPTEXT(Zobrazen� strukturovan�ho kusovn�ku - 1.v�r.stupe�)
TYPE(Action) CAPTION(Kus~ovn�k s op.)  EVENT(VyrPol_OperTree)  TIPTEXT(Zobrazen� struk. kusovn�ku s operacemi )
TYPE(Action) CAPTION(~Inverzn� kusov.) EVENT(VyrPol_IKUSOV)    TIPTEXT(Zobrazen� inverzn�ho kusovn�ku k vyr�b�n� polo�ce)
TYPE(Action) CAPTION(~P�e��slov�n�)    EVENT(VyrPol_PRECISLUJ) TIPTEXT(P�e��slov�n� vyr�b�n� polo�ky )
TYPE(Action) CAPTION(~N�hrada)         EVENT(VyrPol_NAHRADA)   TIPTEXT(N�hrada vyr�b�n� polo�ky )
TYPE(Action) CAPTION(~Kopie polo�ky)   EVENT(VyrPol_Copy)      TIPTEXT(Kopie vyr�b�n� polo�ky )
TYPE(Action) CAPTION(kopie ~Z polo�ky) EVENT(KusOp_Copy)       TIPTEXT(Kopie kusovn�ku a operac� z vyr�b�n� polo�ky )

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kusovn�k pl_ex)   EVENT(kusTree_ex_Full)     TIPTEXT(Zobrazen� pln�ho strukturovan�ho kusovn�ku exTree)
TYPE(Action) CAPTION(~Kusovn�k sOper)   EVENT(operTree_ex)         TIPTEXT(Zobrazen� strukturovan�ho kusovn�ku s operacemi exTree)


  TYPE(DBrowse) FILE(VYRPOL) INDEXORD(4) ;
                FIELDS( ctypPol:typPol                  , ;
                        VYR_isKusov(1;'VyrPol'):Ku:1::2 , ;
                        VYR_isPolOp(1;'VyrPol'):Op:1::2 , ;
                        cVyrPol     ,;
                        cCisZakaz   ,;
                        cNazev      ,;
                        nVarCis:Var.,;
                        cVarPop     ,;
                        cCisVyk     );
                SIZE(110,14.6) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(yy);
                ITEMMARKED(ItemMarked)


*** QUICK FILTR ***
  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Vyr�b�n� polo�ky) CPOS( 45, 0.1) CLEN( 20) FONT(5)

    TYPE(STATIC) STYPE(2) FPOS(79,.1) SIZE( 40.5, 1.2) RESIZE(nx)
      TYPE(PushButton) POS( .1, .1)   SIZE(30.3,1.2) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)


*    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 93, 0.1)  RESIZE(nx)
*      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 16) VALUES(1:V�echny          ,;
*                                                                       2:Jen nezak�zkov�  ,;
*                                                                       3:Jen zak�zkov�    );
*                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Z�kladn� �daje) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)

*   1.��dek
    TYPE(Text) CAPTION(Zak�zka)               CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Vyr. polo�ka)          CPOS( 40, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 40, 1.5)   CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev polo�ky)         CPOS( 62, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazev)                   CPOS( 62, 1.5)   CLEN( 38) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Var.)                  CPOS(102, 0.5)   CLEN(  5)
    TYPE(Text) NAME(nVarCis)                  CPOS(102, 1.5)   CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
*   2.��dek
    TYPE(Text) CAPTION(Obch. ozna�en�)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                  CPOS(  3, 3.5)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)                CPOS( 20, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cTypPol)                  CPOS( 30, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cSkuPol)                  CPOS( 40, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(cZkratJedn)               CPOS( 54, 3.5)   CLEN(  3) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(��.v�robek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(cNazPol2)                 CPOS( 59, 3.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(St�. v�robn�)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrVyr)                  CPOS( 71, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(St�. odv�d�n�)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrOdv)                  CPOS( 85, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
*   3.��dek
    TYPE(Text) CAPTION(��slo v�kresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(cCisVyk)                  CPOS(  3, 5.5)   CLEN( 26) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Ek.d�vka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(nEkDav)                   CPOS( 31, 5.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(�ist� hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nCisHm)                   CPOS( 41, 5.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(cStav)                    CPOS( 55, 5.5)   CLEN(  4) BGND( 13) GROUPS(clrGREY)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Rozpiska) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(18,63) PRE( tabSelect)

  TYPE(DBrowse) FILE(KUSOV) INDEXORD(1) ;
               FIELDS(nPozice          :Pozice          ,;
                      nVarPoz          :Var.poz.        ,;
                      VYR_KUSOV_VP()   :Polo�ka:15      ,;
                      nNizVar          :Var.            ,;
                      VYR_KUSOV_VP()   :N�zev polo�ky:25,;
                      nCiMno           :Mn. �ist�       ,;
                      nSpMno           :Mn. spot�ebn�   ,;
                      VYR_KUSOV_MjVP() :MJ:3            ,;
                      VYR_KUSOV_TypVP():Typ:3           );
               SIZE(108, 7.5) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny)

TYPE(End)

TYPE(End)