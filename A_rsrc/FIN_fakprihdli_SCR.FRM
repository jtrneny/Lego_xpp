TYPE(drgForm) DTYPE(10) TITLE( Likvidace závazkù ...) SIZE(105,25)          ;
                                                      CARGO(FIN_UCETDOHD_CRD)        

* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(0,.1) SIZE(105,11.5) FILE(FAKPRIHD);
                                         FIELDS(FIN_FAKPRIHD_BC(1;'H'):H:2.6::2, ;
                                                FIN_FAKPRIHD_BC(1;'P'):P:2.6::2, ;
                                                FIN_FAKPRIHD_BC(1;'D'):D:2.6::2, ;
                                                FIN_FAKPRIHD_BC(1;'L'):L:2.6::2, ;
                                                FIN_FAKPRIHD_BC(1;'U'):U:2.6::2, ;
                                                nCISFAK                        , ;
                                                cVARSYM:VarSymbol              , ;
                                                cNAZEV:Název dodavatele:20     , ;
                                                CTEXTFAKT:Text faktury:20      , ;
                                                nCENZAKCEL                     , ;
                                                CUCET_UCT:SuAu_Ø                 ) ;
                                         CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(yy) SCROLL(ny) ITEMMARKED(itemMarked) POPUPMENU(y)                

* BROWSE DEFINITION
  TYPE(TEXT) CAPTION(Likvidace závazku) CPOS(0.5,11.8) CLEN(104) FONT(5) PP(3) BGND(11) CTYPE(1)
  TYPE(DBrowse) FPOS(0,13) SIZE(105,8.5) FILE(UCETPOL);  
                                        FIELDS(NDOKLAD,COBDOBI:OBD_úè,CTEXT:Text dokladu:45,CUCETMD:SuAu_Ø,NKCMD,NKCDAL,CUCETDAL:SuAu_S) ;
                                        CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)

* INFO DEFINITION
  TYPE(Static) STYPE(13) SIZE(103,2.7) FPOS(1,22) RESIZE(y) CTYPE(2) 
    TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, .1) CLEN(11) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)   CPOS( 3,1.2) CLEN(13) PP(2) BGND(13) 

    TYPE(Text) FCAPTION(Výrobek)         CPOS(19, .1) CLEN( 8) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)   CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(Zakázka)         CPOS(35, .1) CLEN( 8) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)   CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(VýrMísto)        CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) 
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)   CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(Stroj)           CPOS(67, .1) CLEN( 6) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)   CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(VýrOperace)      CPOS(83, .1) CLEN(10) PP(3) BGND( 1) 
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)   CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Static) STYPE(12) SIZE(101,.1) FPOS(1,.4)
    TYPE(End)
  TYPE(End)
