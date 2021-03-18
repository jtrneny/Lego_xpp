TYPE(drgForm) DTYPE(10) TITLE(Vyr�b�n� polo�ky - kalkulace materi�lu) FILE(VYRPOL);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y)
*              CARGO( VYR_VYRPOL_CRD)

TYPE(Action) CAPTION(info ~Polo�ky)   EVENT(VYR_VYRPOL_INFO) TIPTEXT(Informa�n� karta vyr�b�n� polo�ky)
TYPE(Action) CAPTION(~Kalkulace THN)  EVENT(VYR_KALK_THN)    TIPTEXT(Kalkulace materi�lu )

TYPE(DBrowse) FILE(VYRPOL) INDEXORD(4) ;
             FIELDS( ctypPol:typPol                  , ;
                     VYR_isKusov(1;'VyrPol'):Ku:1::2 , ;
                     VYR_isPolOp(1;'VyrPol'):Op:1::2 , ;
                     cCisZakaz   , ;
                     cVyrPol     , ;
                     cNazev      , ;
                     nVarCis:var , ;
                     cVarPop       ) ;
             SIZE(110,16) FPOS(0,1.4) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(yy);
             ITEMMARKED(ItemMarked)

*** QUICK FILTR ***
  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Vyr�b�n� polo�ky) CPOS( 45, 0.1) CLEN( 20) FONT(5)

    TYPE(STATIC) STYPE(2) FPOS(79,.1) SIZE( 40.5, 1.2) RESIZE(nx)
      TYPE(PushButton) POS( .1, .1)   SIZE(30.3,1.2) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(End)
  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(108,8.5) FPOS(1,16.2) RESIZE(yx)

*   1.��dek
    TYPE(Text) CAPTION(Zak�zka)               CPOS(  3, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 35) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Vyr. polo�ka)          CPOS( 40, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 40, 1.5)   CLEN( 15)  BGND( 13) PP(2)
    TYPE(Text) CAPTION(N�zev polo�ky)         CPOS( 57, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazev)                   CPOS( 57, 1.5)   CLEN( 30) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Var.)                  CPOS( 89, 0.5)   CLEN(  5)
    TYPE(Text) NAME(nVarCis)                  CPOS( 89, 1.5)   CLEN(  5) BGND( 13) PP(2)
*    TYPE(Text) CAPTION(Popis varianty)        CPOS( 76, 0.5)   CLEN( 20)
*    TYPE(Text) NAME(cVarPop)                  CPOS( 76, 1.5)   CLEN( 23) BGND( 13) PP(2)
*   2.��dek
    TYPE(Text) CAPTION(Obch. ozna�en�)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                  CPOS(  3, 3.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)                CPOS( 20, 3.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cTypPol)                  CPOS( 30, 3.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cSkuPol)                  CPOS( 40, 3.5)   CLEN( 12) BGND( 13) PP(2)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(cZkratJedn)               CPOS( 54, 3.5)   CLEN(  3) BGND( 13) PP(2)
    TYPE(Text) CAPTION(��.v�robek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(cNazPol2)                 CPOS( 59, 3.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(St�. v�robn�)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrVyr)                  CPOS( 71, 3.5)   CLEN( 12) BGND( 13) PP(2)
    TYPE(Text) CAPTION(St�. odv�d�n�)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrOdv)                  CPOS( 85, 3.5)   CLEN( 12) BGND( 13) PP(2)
*   3.��dek
    TYPE(Text) CAPTION(��slo v�kresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(cCisVyk)                  CPOS(  3, 5.5)   CLEN( 26) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Ek.d�vka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(nEkDav)                   CPOS( 31, 5.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(�ist� hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nCisHm)                   CPOS( 41, 5.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(cStav)                    CPOS( 55, 5.5)   CLEN(  4) BGND( 13) PP(2)

*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

  TYPE(End)

TYPE(End)