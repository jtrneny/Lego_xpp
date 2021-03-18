TYPE(drgForm) DTYPE(10) TITLE(Skladov� polo�ky - V�B�R) FILE(NAKPOL);
              SIZE(100,20) GUILOOK(Message:Y,Action:n,IconBar:Y)
*              CARGO( VYR_NAKPOL_SCR)

*TYPE(Action) CAPTION(~Skl. polo�ky)      EVENT(NakPOL_scr)   TIPTEXT(Nakupovan� polo�ky - editace )
*TYPE(Action) CAPTION(~Cen�k zbo��)  EVENT(NakPOL_CENIK)     TIPTEXT(Editace cen�ku zbo�� )


TYPE(DBrowse) FILE(NAKPOL) INDEXORD(1) ;
             FIELDS(cNazTPV                  ,;
                    cCisSklad                ,;
                    cSklPol                  ,;
                    cCsnro                   ,;
                    cZkratJedn:MJ_Skl        ,;
                    cMjTpv    :MJ_Tpv        ,;
                    nKoefPrep :Koef.p�epo�tu ,;
                    CenZBOZ->cJakost         ) ;
             SIZE(100,12.8) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
             ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE(99,6.8) FPOS(0.5,13) RESIZE(yy)

*   1.��dek
    TYPE(Text) CAPTION(Sklad)              CPOS(  1, 0.5)   CLEN(  8)
    TYPE(Text) NAME(cCisSklad)             CPOS(  1, 1.5)   CLEN(  8) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Skl. polo�ka)       CPOS( 10, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)               CPOS( 10, 1.5)   CLEN( 15) BGND( 13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(N�zev polo�ky)      CPOS( 26, 0.5)   CLEN( 30)
    TYPE(Text) NAME(cNazTPV)               CPOS( 26, 1.5)   CLEN( 30) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Norma DIN)          CPOS( 60, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cDinor)                CPOS( 60, 1.5)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(�SNR rozm�rov�)     CPOS( 76, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cCsnro)                CPOS( 76, 1.5)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
*   2.��dek
    TYPE(Text) CAPTION(MJ_skl)            CPOS(  1, 2.5)   CLEN( 6)
    TYPE(Text) NAME(cZkratJedn)           CPOS(  1, 3.5)   CLEN( 6) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ_tpv)            CPOS(  8, 2.5)   CLEN( 6)
    TYPE(Text) NAME(cMjTpv)               CPOS(  8, 3.5)   CLEN( 6) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Koef.p�epo�tu)     CPOS( 15, 2.5)   CLEN(12)
    TYPE(Text) NAME(nKoefPrep)            CPOS( 15, 3.5)   CLEN(12) CTYPE(2) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(V�ha/MJ)           CPOS( 28, 2.5)   CLEN(12)
    TYPE(Text) NAME(nVahaMJ)              CPOS( 28, 3.5)   CLEN(12) CTYPE(2) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ mat.)          CPOS( 44, 2.5)   CLEN( 8)
    TYPE(Text) NAME(cTypMat)              CPOS( 44, 3.5)   CLEN( 8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev typu)        CPOS( 53, 2.5)   CLEN(20)
    TYPE(Text) NAME(c_TypMat->cNazTypMat) CPOS( 53, 3.5)   CLEN(20) BGND( 13) GROUPS(clrGREY)

    TYPE(Text) CAPTION(K�d TPV)           CPOS( 75, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cKodTpv)              CPOS( 75, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(K�d rezerv.)       CPOS( 84, 2.5)   CLEN(  8)
    TYPE(Text) NAME(cKodRezSkl)           CPOS( 84, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
*   3.��dek
    TYPE(Text) CAPTION(Rozm�r 1)          CPOS(  1, 4.5)   CLEN( 20)
    TYPE(Text) NAME(cRozmer1)             CPOS(  1, 5.5)   CLEN( 20) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Koef.n�t�ru)       CPOS( 23, 4.5)   CLEN( 10)
    TYPE(Text) NAME(nKoefNater)           CPOS( 23, 5.5)   CLEN( 10) CTYPE(2) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Jakost)            CPOS( 35, 4.5)   CLEN( 10)
    TYPE(Text) NAME(CenZboz->cJakost)     CPOS( 35, 5.5)   CLEN( 15) CTYPE(2) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn.na skladu)      CPOS( 52, 4.5)   CLEN( 12)
    TYPE(Text) NAME(CenZboz->nMnozSZBO)   CPOS( 52, 5.5)   CLEN( 15) CTYPE(2) BGND( 13) GROUPS(clrGREY)

TYPE(End)