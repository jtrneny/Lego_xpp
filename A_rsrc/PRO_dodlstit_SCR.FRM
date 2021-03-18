TYPE(drgForm) DTYPE(10) TITLE(Dodací listy vystavené dle položek ...) SIZE(110,25) ; 
                                                                      OBDOBI(SKL)  ;
                                                                      PRINTFILES(dodlstit:ndoklad=ndoklad) 

*  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace faktury vystavené)
*  TYPE(Action) CAPTION(~DodacíList) EVENT(fin_dodlsthd)     TIPTEXT(Pøipojený dodací list)
*  TYPE(Action) CAPTION(~Výdejka)    EVENT(fin_pvphead)      TIPTEXT(Pøipojené výdejky)


  TYPE(DBrowse) FPOS(0,1) SIZE(109.6,14.2) FILE(DODLSTIT)                   ;
                                           FIELDS(ndoklad:èísloDol        , ; 
                                                  csklpol:sklPoložka      , ;
                                                  cnazzbo:název zboží:33  , ;
                                                  nfaktmnoz:faktMnož      , ;                                                  
                                                  czkratjedn:mj           , ;     
                                                  ncenjedzak:cena/mj      , ;
                                                  ncenzakcel:cenaCelk       ) ;
                                           CURSORMODE(3) PP(7) RESIZE(x) SCROLL(ny) ITEMMARKED(itemMarked) POPUPMENU(y)

*
**
* info
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(STATIC) FPOS(0.01,0.1) SIZE(40,8  ) STYPE(12)  RESIZE(yx) CTYPE(2)   
   
      TYPE(TEXT) CAPTION(2. Dodací list èíslo)  CPOS( 4,0.5) CLEN(16)                         FONT(5) 
      TYPE(TEXT) NAME(dodlsthd->ndoklad)        CPOS(20,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(Èíslo objednávky)      CPOS( 6,1.5) CLEN(13) 
      TYPE(TEXT) NAME(dodlsthd->ccisObj)        CPOS(20,1.5) CLEN(15)       BGND(13) 

      TYPE(TEXT) CAPTION(Datum vystavení)       CPOS( 6,2.5) CLEN(13)
      TYPE(TEXT) NAME(dodlsthd->dvystFak)       CPOS(20,2.5) CLEN(15)       BGND(13)

      TYPE(STATIC) FPOS(0.01,4.5) SIZE(40,3.5) STYPE(9)  RESIZE(yx)
       TYPE(TEXT) NAME(M->cnazMeny)             CPOS( 3,0.5) CLEN(32)       BGND(13)

       TYPE(TEXT) CAPTION(Kurz/Pøep)            CPOS( 3,1.6) CLEN( 8)
       TYPE(TEXT) NAME(dodlsthd->nkurZahMen)    CPOS(12,1.6) CLEN(12)       BGND(13) CTYPE(2)

       TYPE(TEXT) CAPTION(/)                    CPOS(25,1.6) CLEN( 2)
       TYPE(TEXT) NAME(dodlsthd->nmnozPrep)     CPOS(27,1.6) CLEN( 8)       BGND(13) CTYPE(2)    
      TYPE(End)
    TYPE(End)

    TYPE(STATIC) FPOS(40.1,0.1) SIZE(68.9,8) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(3. Odbìratel )          CPOS( 4,0.5) CLEN(11)                         FONT(5) 
      TYPE(TEXT) NAME(dodlsthd->ncisFirmy)       CPOS(20,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(stát)                   CPOS(33,0.5) CLEN( 6)
      TYPE(TEXT) NAME(dodlsthd->czkratStat)      CPOS(40,0.5) CLEN(10)       BGND(13)

      TYPE(TEXT) CAPTION(Ièo)                    CPOS( 6,1.5) CLEN( 5)
      TYPE(TEXT) NAME(dodlsthd->nico)            CPOS(20,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Diè)                    CPOS(33,1.5) CLEN( 5)
      TYPE(TEXT) NAME(dodlsthd->cdic)            CPOS(40,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Název)                  CPOS( 6,2.5) CLEN( 6)
      TYPE(TEXT) NAME(dodlsthd->cnazev)          CPOS(20,2.5) CLEN(30)       BGND(13) 

      TYPE(TEXT) NAME(dodlsthd->cnazev2)         CPOS(20,3.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(Ulice)                  CPOS( 6,4.5) CLEN( 6)
      TYPE(TEXT) NAME(dodlsthd->culice)          CPOS(20,4.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(PSè)                    CPOS( 6,5.5) CLEN( 6)
      TYPE(TEXT) NAME(dodlsthd->cpsc)            CPOS(20,5.5) CLEN(10)       BGND(13) 
      TYPE(TEXT) NAME(M->cnazevStat)             CPOS(31,5.5) CLEN(28)       BGND(13)
    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* položky faktur vystavených
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(13,74) CAPTION(polFak) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(položky faktur vystavených) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(12) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109,7) FILE(FAKVYSIT)                 ;
                                           FIELDS(nCISFAK:èísFak:10     , ;
                                                  cNAZZBO:název zboží:35, ;
                                                  cSKLPOL:sklPol        , ;
                                                  nFAKTMNOZ:množFak:13  , ;
                                                  cZKRATJEDN:jed:3      , ;
                                                  nCeCPrKDZ:cenaCelk    , ;
                                                  nRADVYKDPH:rvDph      , ;
                                                  cCISZAKAZI:výrZakázka , ;
                                                  cUCETSKUP:UèSk          ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) RESIZE(x)



  TYPE(End)

* likvidace
*  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)  
*    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*
*  TYPE(End)

* øádky výkazu dph
*  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(99.5,9.2) TTYPE(3) OFFSET(37,50) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect)  
*    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*
*  TYPE(END)