TYPE(drgForm) DTYPE(10) TITLE(Vyrábìné položky - VÝBÌR_s) FILE(VYRPOL_se);
              SIZE(110,20) GUILOOK(Message:Y,Action:Y,IconBar:Y)
*              CARGO( VYR_VYRPOL_CRD)

TYPE(Action) CAPTION(~Info položky)  EVENT(VYR_VyrPol_INFO)  TIPTEXT(Informaèní karta vyrábìné položky )
*YPE(Action) CAPTION(~Kopie - F3  )  EVENT(doAppend)         TIPTEXT(Kopie vyrábìné položky )

TYPE(DBrowse) FILE(VYRPOL_se) INDEXORD( 4) ;
              FIELDS( cCisZakaz,;
                      cVyrPol  ,;
                      cNazev   ,;
                      nVarCis  ,;
                      cVarPop  );
              SIZE(110,12.4) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y) ;
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE(108,7.2) FPOS(1,12.6) Resize(nn)
*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Vyr. položka)          CPOS( 20, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(cVyrPol)                  CPOS( 20, 1.5)   CLEN( 15)  BGND( 13) PP(2)
    TYPE(Text) CAPTION(Název položky)         CPOS( 37, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazev)                   CPOS( 37, 1.5)   CLEN( 30) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Var.)                  CPOS( 69, 0.5)   CLEN(  5)
    TYPE(Text) NAME(nVarCis)                  CPOS( 69, 1.5)   CLEN(  5) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Popis varianty)        CPOS( 76, 0.5)   CLEN( 20)
    TYPE(Text) NAME(cVarPop)                  CPOS( 76, 1.5)   CLEN( 23) BGND( 13) PP(2)
*   2.øádek
    TYPE(Text) CAPTION(Obch. oznaèení)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                  CPOS(  3, 3.5)   CLEN( 15) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)                CPOS( 20, 3.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cTypPol)                  CPOS( 30, 3.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cSkuPol)                  CPOS( 40, 3.5)   CLEN( 12) BGND( 13) PP(2)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(cZkratJedn)               CPOS( 54, 3.5)   CLEN(  3) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Úè.výrobek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(cNazPol2)                 CPOS( 59, 3.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Stø. výrobní)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrVyr)                  CPOS( 71, 3.5)   CLEN( 12) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Stø. odvádìní)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(cStrOdv)                  CPOS( 85, 3.5)   CLEN( 12) BGND( 13) PP(2)
*   3.øádek
    TYPE(Text) CAPTION(Èíslo výkresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(cCisVyk)                  CPOS(  3, 5.5)   CLEN( 26) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Ek.dávka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(nEkDav)                   CPOS( 31, 5.5)   CLEN(  8) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Èistá hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(nCisHm)                   CPOS( 41, 5.5)   CLEN( 10) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(cStav)                    CPOS( 55, 5.5)   CLEN(  4) BGND( 13) PP(2)

  TYPE(End)