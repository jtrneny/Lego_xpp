TYPE(drgForm) DTYPE(10) TITLE(Seznam stojanù pro evidenci PHM ...) ;
              CARGO()                                              ;
              PRE(preValidate)                                     ;
              POST(postValidate)                                   ;
              SIZE(115,20) GUILOOK(Action:n,IconBar:y) 


  TYPE(EBROWSE) SIZE(115,10.5) FILE(STOJANY)                                                     ;
                               ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(yy) ;
                               POPUPMENU(y)                                                      ;
                               LFREEZE(1)                                                        ;
                               GUILOOK(ins:y,del:n) 

      TYPE(GET)  NAME(stojany->nstojan)        FLEN( 5) FCAPTION(stojan       ) NOREVISION()
      TYPE(GET)  NAME(stojany->cnazStoj)       FLEN(30) FCAPTION(název Stojanu)
      TYPE(TEXT) NAME(stojany->ccisSklad)      FLEN( 8) FCAPTION(sklad        )
      TYPE(GET)  NAME(stojany->csklPol)        FLEN(15) FCAPTION(sklPoložka   ) PUSH(skl_cenzboz_sel)
      TYPE(TEXT) NAME(stojany->ddatPoh)        FLEN(10) FCAPTION(datPoh       ) 

      TYPE(GET)  NAME(stojany->npocStav)       FLEN(10) FCAPTION(poèStav      ) NOREVISION()
      TYPE(TEXT) NAME(stojany->nprijem)        FLEN(10) FCAPTION(pøíjem       ) 
      TYPE(TEXT) NAME(stojany->nvydej)         FLEN(10) FCAPTION(výdej        )
      TYPE(TEXT) NAME(M->cenZboz_mnozSZbo)     FLEN(11) FCAPTION(aktStav      )
  TYPE(END)


*
**
TYPE(TABPAGE) FPOS(.5,18.7) SIZE(114,1.1) TTYPE(3) OFFSET( 1,86) CAPTION(pøíjem) PRE(tabSelect) RESIZE(yx) SUB(A)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(TABPAGE) FPOS(.5,18.7) SIZE(114,1.1) TTYPE(3) OFFSET(13,74) CAPTION(výdej)  PRE(tabSelect) RESIZE(yx) SUB(B)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)

TYPE(TABPAGE) FPOS(.5,18.7) SIZE(114,1.1) TTYPE(3) OFFSET(25,62) CAPTION(pøevod) PRE(tabSelect) RESIZE(yx) SUB(C)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* pvpitem
*  TYPE(TABPAGE) FPOS(.5,10.7) SIZE(114, 9) TTYPE(3) OFFSET(37,50) CAPTION(pohyb) TABHEIGHT(1.1) PRE(tabSelect) RESIZE(yx)
*    TYPE(TEXT) CAPTION(Pvp) CPOS(.1,0) CLEN(113.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FILE(PVPITEM) FPOS( -.3,10.7) SIZE(113,8) INDEXORD(28);
                  FIELDS( IsUctovano( 1; 'PVPITEM'):L:3::2,;                          
                          cSklPol      ,;
                          cNazZbo::20  ,;
                          nDoklad      ,;
                          nOrdItem     ,;
                          nMnozPrDOD   ,;
                          nCenNapDod   ,;
                          nCenaCelk    ,;
                          cZkratMeny   ,;
                          nCenCelkZM   ,;
                          cZahrMena    ,;
                          cUcetSkup    ,;
                          cCisZakaz    ,;
                          cCisZakazI   ,;
                          M->pvpitem_datPoh:datumPohybu:20, ;
                          nKLikvid     ,;
                          nZlikvid       ) ;
                  CURSORMODE(3) RESIZE(yx) SCROLL(yy)
*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0) 
*  TYPE(End) 



