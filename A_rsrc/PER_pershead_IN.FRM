TYPE(drgForm) DTYPE(10) TITLE(Plán personalních akcí ...) SIZE(120,26) FILE(PERSHEAD) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:myIconBar,Menu:n)                  ;
              PRE(preValidate) POST(postValidate)



TYPE(ComboBox) NAME(persHeadW->cTYPPOHYBU) FPOS( 1,  .4) FLEN(30) VALUES(lekProhl : lékaøské prohlídky, ;
                                                                         skoleni  : školení a kury      ) ; 
                                                                  ITEMSELECTED(comboItemSelected) ITEMMARKED(comboItemMarked) NOREVISION()

TYPE(TEXT) CAPTION(Datum návrhu OD : )       CPOS( 39, .5) CLEN(16)  FONT(1) 
TYPE(GET) NAME(M->ddatNAV_od)                FPOS( 56, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE) NOREVISION()
TYPE(TEXT) CAPTION( __ do __ )               CPOS( 71, .5) CLEN( 7)  FONT(1) 
TYPE(GET) NAME(M->ddatNAV_do)                FPOS( 81, .5) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE) NOREVISION()


TYPE(TabPage) CAPTION(lékaøské prohlídky) FPOS(0,2.5) SIZE(77,9) RESIZE(yx) TTYPE(3) OFFSET(1,81) TABHEIGHT(0) PRE(tabSelect) SUB(lekProhl)

  TYPE(Static) STYPE(13) SIZE(75,8.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2) 

    TYPE(TEXT) CAPTION(Typ lékaøské prohlídky )  CPOS( 2, 1) CLEN(17) 
    TYPE(GET) NAME(persHeadW->cZkratka)          FPOS(20, 1) FLEN(12)                    PUSH(per_czkratka_sel)   TIPTEXT(lekProhl) NOREVISION()
    TYPE(TEXT) NAME(persHeadW->cnazevT_LS)       CPOS(35, 1) CLEN(38) BGND(13) PP(3)
*    TYPE(TEXT) NAME(c_LekPro->cNazev)            CPOS(35, 1) CLEN(38) BGND(13) PP(3)

     TYPE(Static) STYPE( 2) CAPTION(Lékaøská prohlídka)  SIZE(72, 5.3) FPOS( 1, 2.5) RESIZE(y)
       TYPE(TEXT) CAPTION(Prohlídka dne )           CPOS(  3, 1) CLEN(16)
       TYPE(GET) NAME(persHeadW->ddatPL_od)         FPOS( 19, 1) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)          TIPTEXT(lekProhl)
       TYPE(TEXT) CAPTION( __ do __ )               CPOS( 34, 1) CLEN( 7)  FONT(1) 
       TYPE(GET) NAME(persHeadW->ddatPL_do)         FPOS( 43, 1) FLEN(12)  FONT(5) PP(2) PUSH(CLICKDATE)          TIPTEXT(lekProhl)

       TYPE(TEXT) CAPTION(Ošetøující lékaø)         CPOS(  3, 2.5) CLEN(16)
       TYPE(GET) NAME(persheadW->czkratk_LS)        FPOS( 19, 2.5) FLEN(12)              PUSH(per_czkratk_LS_sel) TIPTEXT(lekProhl)
       TYPE(TEXT) NAME(persheadW->cnazev_LS)        CPOS( 34, 2.5) CLEN(34) BGND(13) PP(3)

       TYPE(TEXT) CAPTION(Odbornost lékaøe)         CPOS(  3, 3.5) CLEN(16)
       TYPE(GET) NAME(persheadW->codborn_LS)        FPOS( 19, 3.5) FLEN(48) PP(2)                                 TIPTEXT(lekProhl)
    TYPE(End)
  TYPE(End)
TYPE(END)



TYPE(TabPage) CAPTION( školení a kurzy) FPOS(0,2.5) SIZE(77,9) RESIZE(yx) TTYPE(3) OFFSET(19,63) TABHEIGHT(0) PRE(tabSelect) SUB(skoleni)

  TYPE(Static) STYPE(13) SIZE(75,8.5) FPOS(1,0.1) RESIZE(yn) CTYPE(2)

    TYPE(TEXT) CAPTION(Typ školení  )        CPOS( 2, 1) CLEN(17)
    TYPE(GET) NAME(persHeadW->cZkratka)      FPOS(20, 1) FLEN(12)                        PUSH(per_czkratka_sel)   TIPTEXT(skoleni) NOREVISION()
    TYPE(TEXT) NAME(persHeadW->cnazevT_LS)   CPOS(35, 1) CLEN(38) BGND(13) PP(3)
*    TYPE(TEXT) NAME(C_Skolen->cNazev)        CPOS(35, 1) CLEN(38) BGND(13) PP(3)

    TYPE(Static) STYPE( 2) CAPTION(Školení)  SIZE(72, 5.30) FPOS( 1, 2.5) RESIZE(y)
      TYPE(TEXT) CAPTION(Školení dne )             CPOS(  3, 1) CLEN(16)
      TYPE(GET) NAME(persHeadW->ddatPL_od)         FPOS( 19, 1) FLEN(12)  FONT(5) PP(2)  PUSH(CLICKDATE)          TIPTEXT(skoleni)
      TYPE(TEXT) CAPTION( __ do __ )               CPOS( 34, 1) CLEN( 7)  FONT(1) 
      TYPE(GET) NAME(persHeadW->ddatPL_do)         FPOS( 43, 1) FLEN(12)  FONT(5) PP(2)  PUSH(CLICKDATE)          TIPTEXT(skoleni)

      TYPE(GET) NAME(persHeadW->nDelka)            FPOS( 57, 1) FLEN( 3) PP(2)                                    TIPTEXT(skoleni)
      TYPE(GET) NAME(persHeadW->cZkratJED2)        FPOS( 62, 1) FLEN( 5) PUSH()                                   TIPTEXT(skoleni)

      TYPE(TEXT) CAPTION(Školitel)                  CPOS(  3, 2.5) CLEN(16)
       TYPE(GET) NAME(persheadW->czkratk_LS)        FPOS( 19, 2.5) FLEN(12)              PUSH(per_czkratk_LS_sel) TIPTEXT(skoleni)
       TYPE(TEXT) NAME(persheadW->cnazev_LS)        CPOS( 34, 2.5) CLEN(34) BGND(13) PP(3)

      TYPE(TEXT) CAPTION(Zpùsob ukonèení)          CPOS(  3, 3.5) CLEN(16)
      TYPE(GET) NAME(persheadW->czkratkaUk)        FPOS( 19, 3.5) FLEN(12)                                        TIPTEXT(skoleni)
      TYPE(TEXT) NAME(c_SkolUk->cNazev)            CPOS( 34, 3.5) CLEN(34) PP(3) BGND(13)

      TYPE(TEXT) CAPTION(Lektor)                   CPOS(  3, 4.5) CLEN(16)
      TYPE(GET) NAME(persheadW->codborn_LS)        FPOS( 19, 4.5) FLEN(48) PP(2)                                  TIPTEXT(skoleni)
    TYPE(End)
  TYPE(END)
TYPE(END)


TYPE(Static) STYPE(12) CAPTION(Místo konání)  SIZE(43, 9) FPOS(77,2.5) RESIZE(y) CTYPE(2)
  TYPE(TEXT) CAPTION(Ulice)                 CPOS( 1, 2.05) CLEN( 6)
  TYPE(GET) NAME(persHeadW->cUlice)         FPOS( 7, 2.05) FLEN(25) PP(2)

  TYPE(TEXT) CAPTION(Místo)                 CPOS( 1, 3.10) CLEN( 6)
  TYPE(GET) NAME(persHeadW->cMisto)         FPOS( 7, 3.10) FLEN(25) PP(2)

  TYPE(TEXT) CAPTION(PSÈ )                  CPOS( 1, 4.15) CLEN( 6)
  TYPE(GET) NAME(persHeadW->cPsc)           FPOS( 7, 4.15) FLEN( 8) PUSH()
  TYPE(TEXT) NAME(c_Psc->cMisto)            CPOS(18, 4.15) CLEN(24) BGND(13) PP(3)

  TYPE(TEXT) CAPTION(Stát)                  CPOS( 1, 5.20) CLEN( 6)
  TYPE(GET) NAME(persHeadW->cZkratStat)     FPOS( 7, 5.20) FLEN( 8)
  TYPE(TEXT) NAME(C_Staty->cNazevStat)      CPOS(18, 5.20) CLEN(24) PP(3) BGND(13)
TYPE(End)


*
** persitem
TYPE(Static) STYPE(12) CAPTION(Položky plánu)  FPOS(.3,11.8) SIZE(119,14.2) RESIZE(y) CTYPE(2)
  TYPE(DBrowse) FPOS(0,0) SIZE(119,14) FILE(PERSITEMw)   ;
                                       FIELDS( ctypAkce:typAkce                         , ; 
                                               dDatPREDko:datKonání:10                  , ;
                                               nOrdItem:poø                             , ;
                                               cOblastTyp                               , ;
                                               cZkratka                                 , ;
                                               nperioOpak:perOpak                       , ;
                                               czkratJedn:za                            , ;
                                               cPracovnik::30                           , ;
                                               dDatUskuKo                               , ;
                                               dDatUkonce                                 ) ;
                                       CURSORMODE(3) INDEXORD(1) PP(7) POPUPMENU(y) ITEMMARKED(itemMarked)


*  TYPE(DBrowse) FPOS(0,0) SIZE(119,14) FILE(PERSITEM)   ;
*                                         FIELDS( dDatPREDko:datKonání:10                  , ;
*                                                 nOrdItem:poø                             , ;
*                                                 cOblastTyp                               , ;
*                                                 cZkratka                                 , ;
*                                                 cPracovnik::30                           , ;
*                                                 dDatUskuKo                               , ;
*                                                 dDatUkonce                                 ) ;
*                                          CURSORMODE(3) INDEXORD(1) PP(7) POPUPMENU(y) ITEMMARKED(itemMarked)


TYPE(End)
