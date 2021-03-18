TYPE(drgForm) DTYPE(10) TITLE(Pøepoèty mìrných jednotek) SIZE(75,15) FILE(C_PrepMJ);
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n)  ;
              PRE(preValidate)   ; 
              POST(PostValidate)

  TYPE(EBrowse) SIZE(73,14) FPOS(1,0) FILE(C_PrepMJ) ;
                                      RESIZE(yx) CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) SCROLL(ny) GUILOOK(headmove:n)

    TYPE(TEXT) NAME(c_prepmj->nPocVychMJ)    CLEN(13) CAPTION(poèVýchozích_mj)
    TYPE(GET)  NAME(c_prepmj->cVychoziMJ)    FLEN(13) CAPTION(výchozí_mj)         PUSH(jednot_sel)

    TYPE(TEXT) NAME(       M->is_equal  )    CLEN( 4) CAPTION() BITMAP()

    TYPE(GET)  NAME(c_prepmj->nKoefPrVC )    FLEN(13) CAPTION(koef_pøepoètu V->C)
    TYPE(GET)  NAME(c_prepmj->cCilovaMJ )    FLEN(13) CAPTION(cílová_mj)          PUSH(jednot_sel)
*    TYPE(TEXT) NAME(c_prepmj->nPocCilMJ)     CLEN(13)
  TYPE(END)
