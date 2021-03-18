TYPE(drgForm) DTYPE(10) TITLE(Kurzovní lístek dle mìn ...) SIZE(115,25)       ;
                                                           POST(postValidate) ;
                                                           GUILOOK(Action:y) 

  TYPE(Action) CAPTION(     ~Aktualizace)      EVENT(get_kurzCNB_web) TIPTEXT(Akualizuje kurzovní lístek kurzem CNB) ICON1(101) ATYPE(3)



  TYPE(DBrowse) FPOS(0,.2) SIZE(56,24.5) FILE(C_MENY)                     ;
                                       FIELDS(cZKRATMENY:mìna         , ;
                                              cNAZMENY:Název mìny:39.5, ;
                                              nMNOZPREP:pøepoèet      ) ;
                                       CURSORMODE(3) PP(7) ITEMMARKED(itemMarked) INDEXORD(1) POPUPMENU(y) SCROLL(ny) RESIZE(yy)


  TYPE(EBrowse) FPOS(56,.2) SIZE(59,24.5) FILE(KurzIT)                                             ;
                                          INDEXORD(2) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy) 

    TYPE(GET)      NAME(KurzIT->ddatPlatn)    FLEN(12)          CAPTION(datPlatn)       PUSH(clickDate) 
    TYPE(TEXT)     NAME(KurzIT->nmnozPrep)    CLEN( 7)          CAPTION(mnPøep)         PICTURE(999999) 
    TYPE(GET)      NAME(KurzIT->nkurzNakup)   FLEN(12)          CAPTION(nákup)          PICTURE(99999.999)
    TYPE(GET)      NAME(KurzIT->nkurzProde)   FLEN(12)          CAPTION(prodej)         PICTURE(99999.999) 
    TYPE(GET)      NAME(KurzIT->nkurzStred)   FLEN(12)          CAPTION(støed)          PICTURE(99999.999) 
  TYPE(END)

      
*  TYPE(DBrowse) FPOS(56,.5) SIZE(57,20.4) FILE(KURZIT)                          ;
*                                         FIELDS(dDATPLATN:datPlatn            , ;
*                                                nmnozPrep:pøepoèet            , ; 
*                                                nKURZNAKUP:nákup:12:999999.999 , ;  
*                                                nKURZPRODE:prodej:12:999999.999, ;
*                                                nKURZSTRED:støed:12:999999.999   ) ;
*                                         CURSORMODE(3) PP(7) INDEXORD(2) SCROLL(ny) RESIZE(ny)


*  IN **
* TYPE(Static) FPOS(.8,21.2) SIZE(113,4.5) STYPE(13) CTYPE(2) GROUPS(1) RESIZE(yx)
*   TYPE(GET)  NAME(KURZIT->dDATPLATN)   FPOS(15, .5) FLEN(12) FCAPTION(Datum platnosti) CPOS( 2, .5) PP(2) PUSH(CLICKDATE)
*   TYPE(TEXT) CAPTION(mìna)             CPOS(29, .5) CLEN( 5) PP(2)
*   TYPE(TEXT) NAME(C_MENY->cZKRATMENY)  CPOS(35, .5) CLEN(10) BGND(13) FONT(5)
*   TYPE(TEXT) NAME(C_MENY->cNAZMENY)    CPOS(45, .5) CLEN(29) BGND(13) FONT(5)
*   TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT) CPOS(75, .5) CLEN(29) BGND(13)

*   TYPE(GET)  NAME(KURZIT->nMNOZPREP)   FPOS(45, 2.9) FLEN(10) FCAPTION(pøepoèet) CPOS(45,1.7) CLEN( 8) PP(2)
*   TYPE(GET)  NAME(KURZIT->nKURZNAKUP)  FPOS(60, 2.9) FLEN(13) FCAPTION(nákup)    CPOS(65,1.7) CLEN( 6)
*   TYPE(GET)  NAME(KURZIT->nKURZPRODE)  FPOS(75, 2.9) FLEN(13) FCAPTION(prodej)   CPOS(80,1.7) CLEN( 6)
*   TYPE(GET)  NAME(KURZIT->nKURZSTRED)  FPOS(90, 2.9) FLEN(13) FCAPTION(støed)    CPOS(95,1.7) CLEN( 5) 

*   TYPE(STATIC) FPOS(15,2) SIZE(93.4,.2) STYPE(12) RESIZE(yx)
*   TYPE(End)
* TYPE(End)





