TYPE(drgForm) DTYPE(10) TITLE( Inventura pokladny ...) SIZE(90,23) FILE(POKIN_HDW) ;
                                                                    GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar) ;
                                                                    POST(postValidate)   



  TYPE(Static) STYPE(13) SIZE(88,5) FPOS(1,0.3) RESIZE(y)
    TYPE(STATIC) STYPE(9) FPOS(52.6,.5) SIZE(34,1.1) 
      TYPE(GET)  NAME(pokin_hdW->npokladna)     FPOS(0.3,0.01) FLEN( 7)   PUSH(FIN_POKLADMS_SEL) NOREVISION() 
      TYPE(TEXT) NAME(M->nazPoklad)             CPOS(8.4,0.01) PP(2) FONT(5) CTYPE(2) CLEN(25)
    TYPE(End

    TYPE(TEXT) CAPTION(Stav pokladny :)         CPOS(  3, .5) CLEN(15)
    TYPE(TEXT) NAME(pokin_hdW->naktStav)        CPOS( 17, .5) CLEN(13) FONT(5)
    TYPE(TEXT) NAME(pokin_hdW->czkratMeny)      CPOS( 31, .5) CLEN( 5)

    TYPE(TEXT) CAPTION(Pøedal              :)   CPOS(  3, 2.5) CLEN(15)
    TYPE(TEXT) NAME(pokin_hdW->cjmenoPred)      CPOS( 18, 2.5) CLEN(26) FONT(5) BGND(13)
    TYPE(TEXT) CAPTION(dne)                     CPOS( 46, 2.5) CLEN( 5)
    TYPE(TEXT) NAME(pokin_hdW->ddat_inv)        CPOS( 52, 2.5) CLEN(11) FONT(5) BGND(13)
    TYPE(TEXT) CAPTION(v)                       CPOS( 66, 2.5) CLEN( 3)
    TYPE(TEXT) NAME(pokin_hdW->ccas_inv)        CPOS( 69, 2.5) CLEN(10) FONT(5) BGND(13)

    TYPE(TEXT) CAPTION(Pøevzal            :)    CPOS(  3, 3.5) CLEN(15)
    TYPE(GET)  NAME(pokin_hdW->cjmenoPrev)      FPOS( 18, 3.5) FLEN(25) FONT(5) NOREVISION() PUSH(osb_osoby_sel)
    TYPE(TEXT) CAPTION(dne)                     CPOS( 46, 3.5) CLEN( 5)
    TYPE(TEXT) NAME(pokin_hdW->ddat_inv)        CPOS( 52, 3.5) CLEN(11) FONT(5) BGND(13)
    TYPE(TEXT) CAPTION(v)                       CPOS( 66, 3.5) CLEN( 3)
    TYPE(TEXT) NAME(pokin_hdW->ccas_inv)        CPOS( 69, 3.5) CLEN(10) FONT(5) BGND(13)
  TYPE(End)


  TYPE(EBROWSE) FPOS(10,6) SIZE(67,16) FILE(pokin_itW)                                          ;
                             ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                             GUILOOK(ins:n,del:n,sizecols:n,headmove:n) FOOTER(y)

    TYPE(TEXT)     NAME(pokin_itW->cnazMince)   CLEN(25)  CAPTION(název mince)

    TYPE(TEXT)     NAME(       M->L_gate)      CLEN( 2)  CAPTION()
      TYPE(TEXT)     NAME(pokin_itW->nhodMince)   CLEN( 7)  CAPTION(hodnota)
      TYPE(TEXT)     NAME(       M->multiply)    CLEN( 2)  CAPTION()
      TYPE(GET)      NAME(pokin_itW->npoc_mince)  FLEN( 4)  CAPTION(ks)
    TYPE(TEXT)     NAME(       M->R_gate)      CLEN( 2)  CAPTION()

    TYPE(TEXT)     NAME(       M->result)      CLEN( 2)  CAPTION()

    TYPE(TEXT)     NAME(pokin_itW->ncel_mince)  CLEN(13)  CAPTION(celkem)
    TYPE(TEXT)     NAME(pokin_itW->czkrMince)   CLEN( 4)  CAPTION( )
  TYPE(END)



  