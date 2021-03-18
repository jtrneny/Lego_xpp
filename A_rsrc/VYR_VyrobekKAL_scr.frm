TYPE(drgForm) DTYPE(10) TITLE(Vyr�b�n� polo�ky - SKUTE�N� kalkulace v�robku) FILE(VYRPOL);
              SIZE(110,25) GUILOOK(Message:Y,Action:Y,IconBar:Y)
*              CARGO( VYR_VYRPOL_CRD)

TYPE(Action) CAPTION(info ~Polo�ky)   EVENT(VYR_VYRPOL_INFO) TIPTEXT(Informa�n� karta vyr�b�n� polo�ky)
TYPE(Action) CAPTION(~Kalkulace SKUT) EVENT(VYR_KALKUL_SCR)  TIPTEXT(Skute�n� kalkulace v�robku )
*TYPE(Action) CAPTION(~Hromadn� kalk.) EVENT(KalkHR_CMP)      TIPTEXT(V�po�et hromadn� kalkulace )
*TYPE(Action) CAPTION(hromadn� ~Ru�. ) EVENT(KalkHR_DEL)      TIPTEXT(Hromadn� ru�en� kalkulac� )
*TYPE(Action) CAPTION(~Aktu�ln� kalk.) EVENT(KalkHR_AKT)      TIPTEXT(Hromadn� nastaven� aktu�ln� kalkulace )

TYPE(DBrowse) FILE(VYRPOL) INDEXORD(4) ;
              FIELDS( VYR_isKusov(1;'VyrPol'):Ku:1::2 ,;
                      VYR_isPolOp(1;'VyrPol'):Op:1::2 ,;
                      cVyrPol      ,;
                      cNazev       ,;
                      nVarCis:Var. ,;
                      cVarPop      );
              SIZE(110,16) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE(108,8.5) RESIZE(yx) FPOS(1,16.2))

*   1.��dek
    TYPE(Text) CAPTION(Zak�zka)               CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Vyr. polo�ka)          CPOS( 40, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 40, 1.5)   CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev polo�ky)         CPOS( 57, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazev)                   CPOS( 57, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Var.)                  CPOS( 89, 0.5)   CLEN(  5)
    TYPE(Text) NAME(nVarCis)                  CPOS( 89, 1.5)   CLEN(  5) BGND( 13) FONT(5) GROUPS(clrGREY)
*   2.��dek
    TYPE(Text) CAPTION(Obch. ozna�en�)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                  CPOS(  3, 3.5)   CLEN( 15) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)                CPOS( 20, 3.5)   CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cTypPol)                  CPOS( 30, 3.5)   CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cSkuPol)                  CPOS( 40, 3.5)   CLEN( 12) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(cZkratJedn)               CPOS( 54, 3.5)   CLEN(  3) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(��.v�robek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(cNazPol2)                 CPOS( 59, 3.5)   CLEN( 10) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(St�. v�robn�)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrVyr)                  CPOS( 71, 3.5)   CLEN( 12) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(St�. odv�d�n�)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrOdv)                  CPOS( 85, 3.5)   CLEN( 12) BGND( 13) PP(2) GROUPS(clrGREY)
*   3.��dek
    TYPE(Text) CAPTION(��slo v�kresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(cCisVyk)                  CPOS(  3, 5.5)   CLEN( 26) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Ek.d�vka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(nEkDav)                   CPOS( 31, 5.5)   CLEN(  8) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(�ist� hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nCisHm)                   CPOS( 41, 5.5)   CLEN( 10) BGND( 13) PP(2) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(cStav)                    CPOS( 55, 5.5)   CLEN(  4) BGND( 13) PP(2) GROUPS(clrGREY)

*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

  TYPE(End)

TYPE(End)