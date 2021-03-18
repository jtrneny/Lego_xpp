TYPE(drgForm) DTYPE(10) TITLE(Výkaz DPH ...) SIZE(104,13) FILE(VYKDPH_Pw) ;
                                             GUILOOK(All:n) BORDER(4) POST(postValidate)

  TYPE(EBROWSE) FPOS(.1,1.3) SIZE(103.9,7.8) FILE(vykdph_Pw)                                   ;
                             ITEMMARKED(ItemMarked) INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) ;
                             FOOTER(y)                                                         ;   
                             GUILOOK(ins:n,del:n,sizecols:n,headmove:n) 

    TYPE(TEXT) NAME(       M->preDanPov  )   CLEN( 2)    CAPTION() BITMAP()
    TYPE(TEXT) NAME(vykdph_Pw->nradek_dph)   CLEN( 5)    CAPTION(øv)
    TYPE(TEXT) NAME(        M->cradek_dph)   CLEN(29)    CAPTION(název øádku výkazu dph)
    TYPE(TEXT) NAME(vykdph_Pw->ndoklad_or)   CLEN(10)    CAPTION(daòDoklad)
    TYPE(TEXT) NAME(vykdph_Pw->nzakld_or )   CLEN(13.7)  CAPTION(základ)
    TYPE(TEXT) NAME(vykdph_Pw->nsazba_or )   CLEN(13)    CAPTION(daò)
    TYPE(GET)  NAME(vykdph_Pw->nzakld_zal)   FLEN(13.7)  CAPTION(základ_zál)               PUSH(FIN_CMDPH)
    TYPE(GET)  NAME(vykdph_Pw->nsazba_zal)   FLEN(13)    CAPTION(sazba_zál)
  TYPE(END)
*
  TYPE(STATIC) STYPE(13) FPOS(0,0) SIZE(104,1.2) CTYPE(2)
    TYPE(Text) CAPTION(Daòové doklady párované zálohy ...) CPOS(1,0.1)  FONT(5)
    TYPE(PushButton) POS(100.9,.05) SIZE(3,1) EVENT(140000002) ICON1(102) ICON2(202) ATYPE(1)
* informace z ucdokhd
  TYPE(End)


* INFO ze základního souboru
  TYPE(Static) STYPE(13) SIZE(103.8,3.8) FPOS(.2, 9.2) CTYPE(2)
    TYPE(Text) CAPTION(k uplatnìní z_DD v ) CPOS(40,.13)    CLEN(15) 
    TYPE(TEXT) NAME(M->zaklMena)            CPOS(55,.15)    CLEN( 5) FONT(5)

    TYPE(Text) NAME(M->kuplatneni)          CPOS(61,.15)    CLEN(13) BGND(11) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
    TYPE(Text) CAPTION(uplatnìno)           CPOS(76,.07)    CLEN(11) FONT( 2)     
    TYPE(Text) NAME(M->uplatneno)           CPOS(87.5,.15)  CLEN(13) BGND( 9) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
    
    TYPE(Text) CAPTION(k uplatnìní z_FA v ) CPOS(40,1.15)   CLEN(15) 
    TYPE(TEXT) NAME(M->zaklMena)            CPOS(55,1.15)   CLEN( 5) FONT(5)

    TYPE(Text) NAME(M->kuplatneni_zFA)      CPOS(61,1.15)   CLEN(13) BGND(11) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
    TYPE(Text) CAPTION(uplatnìno)           CPOS(76,1.08)   CLEN(11) FONT( 2)     
    TYPE(GET)  NAME(M->uplatneno_zFA)       FPOS(87.5,1.15) FLEN(12) PP(3)          PICTURE(@N 9999999999.99)        
    
    TYPE(STATIC) STYPE(12) SIZE(103.4,.05) FPOS(.2,2.28) CTYPE(2)
    TYPE(End)

    TYPE(TEXT) CAPTION(Kurz/pøep úhrady)   CPOS( 1,2.5)     CLEN(14)
    TYPE(TEXT) NAME(vykdph_pw->nkurzMENU)  CPOS(15,2.5)     CLEN(13) BGND(9) CTYPE(2)
    TYPE(TEXT) CAPTION(/)                  CPOS(28,2.5)     CLEN( 2) FONT(5)
    TYPE(TEXT) NAME(vykdph_pw->nmnozPREU)  CPOS(30,2.5)     CLEN( 7) BGND(9) CTYPE(2)

    TYPE(Text) CAPTION(k uplatnìní v )     CPOS(40,2.5)     CLEN(15) FONT(2)     
    TYPE(TEXT) NAME(vykdph_pw->cZkratMenF) CPOS(55,2.5)     CLEN( 5) FONT(5)

    TYPE(Text) NAME(M->kuplat_v_cm)        CPOS(61,2.5)     CLEN(13) BGND(11) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
    TYPE(Text) CAPTION(uplatnìno)          CPOS(76,2.5)     CLEN(11) FONT( 2)     
    TYPE(Text) NAME(M->uplat_v_cm)         CPOS(87.5,2.5)   CLEN(13) BGND(10) PP(2) PICTURE(@N 9999999999.99) CTYPE(2)
  TYPE(End)







