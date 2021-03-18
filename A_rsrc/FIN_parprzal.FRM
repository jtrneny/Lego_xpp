TYPE(drgForm) DTYPE(10) TITLE(Faktura pøijatá - párování záloh ...) SIZE(100,13) FILE(PARPRZALw) ;
              GUILOOK(Action:n) POST(postValidate)   

* PÁROVANI ZÁLOHOVÝCH FAKTUR
  TYPE(DBrowse) FPOS(.5,5) SIZE(99,7.5) FILE(PARPRZALw)                    ;
                                        FIELDS(CVARZALFAK:VarSymbol      , ;
                                               NCISZALFAK:ÈísloFaktury   , ;
                                               CUCTZALFAK:SuAu_S         , ;
                                               CTEXTFAKT:Text zálohy:33  , ;
                                               NCENZALFAK:zálohaCelkem   , ;   
                                               NCENZAHFAK:zálohaCelkem   , ;
                                               NPARZALFAK:pøevzatoCelkem , ;
                                               NPARZAHFAK:pøevzatoCelkem   ) CURSORMODE(3) PP(6) SCROLL(ny) BORDER(1) POPUPMENU(n) REST(n)


  TYPE(Static) STYPE(13) SIZE(99,4) FPOS(.5,.5) RESIZE(y) 
    TYPE(Get)  NAME(PARPRZALw->cVARZALFAK)   FPOS(15, .5)   FLEN(15) FCAPTION(VarSymbol    ___)  CPOS( 1, .5)  PUSH(parprzal_cvarsym_vld)  PP(2)
    TYPE(Get)  NAME(PARPRZALw->cUCTZALFAK)   FPOS(15,1.5)   FLEN( 9) FCAPTION(SuAu_S        ___) CPOS( 1,1.5)  PP(2)
    TYPE(TEXT) NAME(C_UCTOSN->cNAZ_UCT)      CPOS(25,1.5)   CLEN(24) BGND(13) PP(1)   

    TYPE(Get)  NAME(PARPRZALw->cTEXTFAKT )   FPOS(15,2.5)   FLEN(33) FCAPTION(Text zálohy  ___)  CPOS( 1,2.5) 
 
    TYPE(TEXT) CAPTION(Èíslo faktury)    CLEN(15) CPOS(52, .5)             BGND(10) FONT(5)
    TYPE(TEXT) NAME(PARPRZALw->nCISZALFAK)        CPOS(70, .5)   CLEN(14)  BGND(11) CTYPE(2)

    TYPE(TEXT) CAPTION(Datum úhrady          __)                 CLEN(18) CPOS(52,1.5)             
    TYPE(TEXT) NAME(PARPRZALw->dUHRZALFAK)        CPOS(70,1.5)   CLEN(14) BGND(11) CTYPE(2)

    TYPE(Text) CAPTION(Pøevzato celkem __)  CPOS(52,2.5)   CLEN(18) FONT(5)
    TYPE(Get)  NAME(PARPRZALw->nPARZALFAK )  FPOS(70,2.5)   FLEN(13) PUSH(parprzal_vykdph_in)
    TYPE(Get)  NAME(PARPRZALw->nPARZAHFAK )  FPOS(70,2.5)   FLEN(13) PUSH(parprzal_vykdph_in) 
    TYPE(Text) NAME(FAKPRIHDw->cZKRATMENZ)   CPOS(85,2.5)   CLEN( 5) BGND(13) PP(2)
  TYPE(END)


* neviditelné pomocné položky
TYPE(TEXT) NAME(parprzalw->_nrecor)    FPOS(0,0) CLEN(0)
