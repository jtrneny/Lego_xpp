TYPE(drgForm) DTYPE(10) TITLE(Seznam chybných dokladù ...) SIZE(120,25)                       ;
                                                           GUILOOK(Action:n)                  ; 
                                                           PRINTFILES(uctdokhd:ndoklad=ndoklad, ;
                                                                      ucetpol:cdenik=cdenik+ndoklad=ndoklad)

* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(.2,.02) SIZE(119.6,11.5) FILE(UCETERR)                   ;
                                          FIELDS(M->err_De:de:2.6::2        , ;
                                                 M->err_Do:do:2.6::2        , ;
                                                 M->err_Li:li:2.6::2        , ;   
                                                 CTASKS:úloha               , ;
                                                 CDENIK:deník               , ;
                                                 NDOKLAD:èíslo dokladu:10   , ;
                                                 CTEXTDOK:text dokladu:35   , ;
                                                 NCENZAKCEL:celkemDokl      , ;
                                                 NKLIKVID:klikv_Úèetnì      , ;
                                                 NZLIKVID:zlikv_Úèetnì        ) ;
                                         CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(y)


* likvidace
  TYPE(STATIC) STYPE(10) SIZE(119.6,10.5) FPOS(.5,11.5) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Likvidace dokladu) CPOS(.1,0) CLEN(119.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(119.2,9.5) FILE(UCETERRI)                  ;
                                           FIELDS(M->err_Uc:uc:2.6::2     , ;
                                                  M->err_Sy:sy:2.6::2     , ;
                                                  M->err_Dp:da:2.6::2     , ; 
                                                  M->err_Ns:ns:2.6::2     , ;
                                                  DDATPORIZ:datPoø        , ;
                                                  CSYMBOL:varSymbol:10    , ;              
                                                  NDOKLAD:doklad          , ;
                                                  COBDOBI:OBD_úè          , ;
                                                  CTEXT:Text dokladu:30   , ;
                                                  CUCETMD:SuAu_Ø          , ;
                                                  NKCMD:kèMd              , ;
                                                  NKCDAL:kèDal            , ;
                                                  CUCETDAL:SuAu_S           ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)
  TYPE(End)

* ns-uceterri
  TYPE(Static) STYPE(9) SIZE(119.2,2.5) FPOS(.5,22.2) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(VýrStøedisko)    CPOS(  2, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL1) CPOS(  2,1.2) CLEN(15) PP(2) BGND(13)
    TYPE(Text) FCAPTION(Výrobek)        CPOS( 22, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL2) CPOS( 22,1.2) CLEN(15)       BGND(13) PP(2)
    TYPE(Text) FCAPTION(Zakázka)        CPOS( 42, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL3) CPOS( 42,1.2) CLEN(15)       BGND(13) PP(2)
    TYPE(Text) FCAPTION(VýrMísto)       CPOS( 62, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL4) CPOS( 62,1.2) CLEN(15)       BGND(13) PP(2)
    TYPE(Text) FCAPTION(Stroj)          CPOS( 82, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL5) CPOS( 82,1.2) CLEN(15)       BGND(13) PP(2)
    TYPE(Text) FCAPTION(VýrOperace)     CPOS(102, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
    TYPE(Text) NAME(UCETERRI->cNAZPOL6) CPOS(102,1.2) CLEN(15)       BGND(13) PP(2)

    TYPE(Static) STYPE(12) SIZE(117,.1) FPOS(1,.4)
    TYPE(End)
  TYPE(End)