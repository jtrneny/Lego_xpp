TYPE(drgForm) DTYPE(10) TITLE(Kurzovn� l�stek dle m�n ...) SIZE(115,25)       ;
                                                           POST(postValidate) ;
                                                           GUILOOK(Action:y) 

  TYPE(Action) CAPTION(�����~Aktualizace)      EVENT(get_kurzCNB_web) TIPTEXT(Akualizuje kurzovn� l�stek kurzem CNB) ICON1(101) ATYPE(3)



  TYPE(DBrowse) FPOS(0,.2) SIZE(56,24.5) FILE(C_MENY)                     ;
                                       FIELDS(cZKRATMENY:m�na         , ;
                                              cNAZMENY:N�zev m�ny:39.5, ;
                                              nMNOZPREP:p�epo�et      ) ;
                                       CURSORMODE(3) PP(7) ITEMMARKED(itemMarked) INDEXORD(1) POPUPMENU(y) SCROLL(ny) RESIZE(yy)


  TYPE(EBrowse) FPOS(56,.2) SIZE(59,24.5) FILE(KurzIT)                                             ;
                                          INDEXORD(2) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy) 

    TYPE(GET)      NAME(KurzIT->ddatPlatn)    FLEN(12)          CAPTION(datPlatn)       PUSH(clickDate) 
    TYPE(TEXT)     NAME(KurzIT->nmnozPrep)    CLEN( 7)          CAPTION(mnP�ep)         PICTURE(999999) 
    TYPE(GET)      NAME(KurzIT->nkurzNakup)   FLEN(12)          CAPTION(n�kup)          PICTURE(99999.999)
    TYPE(GET)      NAME(KurzIT->nkurzProde)   FLEN(12)          CAPTION(prodej)         PICTURE(99999.999) 
    TYPE(GET)      NAME(KurzIT->nkurzStred)   FLEN(12)          CAPTION(st�ed)          PICTURE(99999.999) 
  TYPE(END)

      
*  TYPE(DBrowse) FPOS(56,.5) SIZE(57,20.4) FILE(KURZIT)                          ;
*                                         FIELDS(dDATPLATN:datPlatn            , ;
*                                                nmnozPrep:p�epo�et            , ; 
*                                                nKURZNAKUP:n�kup:12:999999.999 , ;  
*                                                nKURZPRODE:prodej:12:999999.999, ;
*                                                nKURZSTRED:st�ed:12:999999.999   ) ;
*                                         CURSORMODE(3) PP(7) INDEXORD(2) SCROLL(ny) RESIZE(ny)


*  IN **
* TYPE(Static) FPOS(.8,21.2) SIZE(113,4.5) STYPE(13) CTYPE(2) GROUPS(1) RESIZE(yx)
*   TYPE(GET)  NAME(KURZIT->dDATPLATN)   FPOS(15, .5) FLEN(12) FCAPTION(Datum platnosti) CPOS( 2, .5) PP(2) PUSH(CLICKDATE)
*   TYPE(TEXT) CAPTION(m�na)             CPOS(29, .5) CLEN( 5) PP(2)
*   TYPE(TEXT) NAME(C_MENY->cZKRATMENY)  CPOS(35, .5) CLEN(10) BGND(13) FONT(5)
*   TYPE(TEXT) NAME(C_MENY->cNAZMENY)    CPOS(45, .5) CLEN(29) BGND(13) FONT(5)
*   TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT) CPOS(75, .5) CLEN(29) BGND(13)

*   TYPE(GET)  NAME(KURZIT->nMNOZPREP)   FPOS(45, 2.9) FLEN(10) FCAPTION(p�epo�et) CPOS(45,1.7) CLEN( 8) PP(2)
*   TYPE(GET)  NAME(KURZIT->nKURZNAKUP)  FPOS(60, 2.9) FLEN(13) FCAPTION(n�kup)    CPOS(65,1.7) CLEN( 6)
*   TYPE(GET)  NAME(KURZIT->nKURZPRODE)  FPOS(75, 2.9) FLEN(13) FCAPTION(prodej)   CPOS(80,1.7) CLEN( 6)
*   TYPE(GET)  NAME(KURZIT->nKURZSTRED)  FPOS(90, 2.9) FLEN(13) FCAPTION(st�ed)    CPOS(95,1.7) CLEN( 5) 

*   TYPE(STATIC) FPOS(15,2) SIZE(93.4,.2) STYPE(12) RESIZE(yx)
*   TYPE(End)
* TYPE(End)





