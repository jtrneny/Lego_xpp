TYPE(drgForm) DTYPE(10) TITLE(Vyrábìné položky) FILE(VYRPOL);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              PRINTFILES(kusov, cSklpol = cSklPol) ;
              CARGO( VYR_VYRPOL_CRD)

TYPE(Action) CAPTION(~Kusovník plný)   EVENT(KusTree_Full)     TIPTEXT(Zobrazení plného strukturovaného kusovníku )
TYPE(Action) CAPTION(K~usovník 1.vs)   EVENT(KusTree_First)    TIPTEXT(Zobrazení strukturovaného kusovníku - 1.výr.stupeò)
TYPE(Action) CAPTION(Kus~ovník s op.)  EVENT(VyrPol_OperTree)  TIPTEXT(Zobrazení struk. kusovníku s operacemi )
TYPE(Action) CAPTION(~Inverzní kusov.) EVENT(VyrPol_IKUSOV)    TIPTEXT(Zobrazení inverzního kusovníku k vyrábìné položce)
TYPE(Action) CAPTION(~Pøeèíslování)    EVENT(VyrPol_PRECISLUJ) TIPTEXT(Pøeèíslování vyrábìné položky )
TYPE(Action) CAPTION(~Náhrada)         EVENT(VyrPol_NAHRADA)   TIPTEXT(Náhrada vyrábìné položky )
TYPE(Action) CAPTION(~Kopie položky)   EVENT(VyrPol_Copy)      TIPTEXT(Kopie vyrábìné položky )
TYPE(Action) CAPTION(kopie ~Z položky) EVENT(KusOp_Copy)       TIPTEXT(Kopie kusovníku a operací z vyrábìné položky )

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kusovník pl_ex)   EVENT(kusTree_ex_Full)     TIPTEXT(Zobrazení plného strukturovaného kusovníku exTree)
TYPE(Action) CAPTION(~Kusovník sOper)   EVENT(operTree_ex)         TIPTEXT(Zobrazení strukturovaného kusovníku s operacemi exTree)


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
    TYPE(Text)     CAPTION(Vyrábìné položky) CPOS( 45, 0.1) CLEN( 20) FONT(5)

    TYPE(STATIC) STYPE(2) FPOS(79,.1) SIZE( 40.5, 1.2) RESIZE(nx)
      TYPE(PushButton) POS( .1, .1)   SIZE(30.3,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)


*    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 93, 0.1)  RESIZE(nx)
*      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 16) VALUES(1:Všechny          ,;
*                                                                       2:Jen nezakázkové  ,;
*                                                                       3:Jen zakázkové    );
*                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)

*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Vyr. položka)          CPOS( 40, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 40, 1.5)   CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název položky)         CPOS( 62, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazev)                   CPOS( 62, 1.5)   CLEN( 38) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Var.)                  CPOS(102, 0.5)   CLEN(  5)
    TYPE(Text) NAME(nVarCis)                  CPOS(102, 1.5)   CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
*   2.øádek
    TYPE(Text) CAPTION(Obch. oznaèení)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                  CPOS(  3, 3.5)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)                CPOS( 20, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cTypPol)                  CPOS( 30, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cSkuPol)                  CPOS( 40, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(cZkratJedn)               CPOS( 54, 3.5)   CLEN(  3) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Úè.výrobek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(cNazPol2)                 CPOS( 59, 3.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stø. výrobní)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrVyr)                  CPOS( 71, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stø. odvádìní)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrOdv)                  CPOS( 85, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
*   3.øádek
    TYPE(Text) CAPTION(Èíslo výkresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(cCisVyk)                  CPOS(  3, 5.5)   CLEN( 26) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Ek.dávka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(nEkDav)                   CPOS( 31, 5.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èistá hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nCisHm)                   CPOS( 41, 5.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(cStav)                    CPOS( 55, 5.5)   CLEN(  4) BGND( 13) GROUPS(clrGREY)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Rozpiska) FPOS(1,16.2) SIZE( 108, 8.5) RESIZE(yx) OFFSET(18,63) PRE( tabSelect)

  TYPE(DBrowse) FILE(KUSOV) INDEXORD(1) ;
               FIELDS(nPozice          :Pozice          ,;
                      nVarPoz          :Var.poz.        ,;
                      VYR_KUSOV_VP()   :Položka:15      ,;
                      nNizVar          :Var.            ,;
                      VYR_KUSOV_VP()   :Název položky:25,;
                      nCiMno           :Mn. èisté       ,;
                      nSpMno           :Mn. spotøební   ,;
                      VYR_KUSOV_MjVP() :MJ:3            ,;
                      VYR_KUSOV_TypVP():Typ:3           );
               SIZE(108, 7.5) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny)

TYPE(End)

TYPE(End)