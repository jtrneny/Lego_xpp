TYPE(drgForm) DTYPE(10) TITLE(Pøijatá plnìní ...) SIZE(110,26)
                                                              

*  TYPE(Action) CAPTION(~Zpracovat)     EVENT(dph_Insert)   TIPTEXT(Zpracovat uzávìrku dph )
*  TYPE(Action) CAPTION(z~Rušit)        EVENT(dph_Delete)   TIPTEXT(Zrušit uzávìrku dph)

  TYPE(DBrowse) FPOS(.5,.1) SIZE(109.5,16.2) FILE(PRIJATPL)                               ; 
                                          FIELDS(cOBDOBIDAN:obdDaò                      , ; 
                                                 nCISFAK:èísloFakt                      , ;
                                                 cVARSYM:varSymbol                      , ;
                                                 cNAZEV:název firmy:49.5                  , ;
                                                 dDATUZV:datUzáv                        , ;
                                                 nCENZAKCEL:celkem                        ) ; 
                                          CURSORMODE(3) PP(5) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(ItemSelected) POPUPMENU(y) ATSTART(LAST)

  TYPE(Static) STYPE(13) SIZE(109,9) FPOS(0.5,16.5) CTYPE(2)
    TYPE(TEXT) CAPTION(Informace o pøijatém plnìní) CPOS(.3,.1) CLEN(108.3) FONT(5) PP(3) BGND(12) CTYPE(1)
*
* L
    TYPE(TEXT) CAPTION(Fakturovaná èástka  )         CPOS( 1,1.5) CLEN(20) FONT(2)
    TYPE(TEXT) NAME(PRIJATPL->nCENZAKCEL)            CPOS(30,1.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(T U Z E M S K O)              CPOS(.3,3  ) CLEN(55) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(TEXT) CAPTION(Snížená sazba DPH)            CPOS( 1,4.5) CLEN(20)
    TYPE(TEXT) NAME(PRIJATPL->nZAKLDAN_1)            CPOS(30,4.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)
 
    TYPE(TEXT) CAPTION(Snížená daò)                  CPOS( 1,5.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nSAZDAN_1)             CPOS(30,5.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(Základní sazba DPH)           CPOS( 1,6.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nZAKLDAN_2)            CPOS(30,6.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(Základní daò)                 CPOS( 1,7.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nSAZDAN_2)             CPOS(30,7.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)
*
* P
    TYPE(TEXT) CAPTION(Osvobozeno od danì)           CPOS(56,1.5) CLEN(20) FONT(2)
    TYPE(TEXT) NAME(PRIJATPL->nOSVODDAN)             CPOS(86,1.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(D O V O Z)                    CPOS(55,3  ) CLEN(54) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(TEXT) CAPTION(Snížená sazba DPH)            CPOS(56,4.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nZAKLDAN1D)            CPOS(86,4.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(Snížená daò)                  CPOS(56,5.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nSAZDAN1D)             CPOS(86,5.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(Základní sazba DPH)           CPOS(56,6.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nZAKLDAN2D)            CPOS(86,6.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)

    TYPE(TEXT) CAPTION(Základní daò)                 CPOS(56,7.5) CLEN(20) 
    TYPE(TEXT) NAME(PRIJATPL->nSAZDAN2D)             CPOS(86,7.5) CLEN(15) PP(2) BGND(13) FONT(5) CTYPE(2)
  TYPE(End)



