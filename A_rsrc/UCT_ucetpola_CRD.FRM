TYPE(drgForm) DTYPE(10) TITLE(Generovan� doklad automat� ...) SIZE(100,23) ;
              GUILOOK(Action:n,IconBar:n,Menu:n,Message:y)


TYPE(STATIC) STYPE(2) SIZE(99.8,5.1) FPOS(0.2,0.2) RESIZE(xx)
* 1 
    TYPE(Text) CAPTION(Datum po��zen�)     CPOS( 1,1)
    TYPE(Text) NAME(UCTDOKHDw->dPORIZDOK)  CPOS(16,1) CLEN(15) BGND(13) PP(2) 
    TYPE(Text) CAPTION(OBD_��)             CPOS(35,1) CLEN( 8)
    TYPE(Text) NAME(UCTDOKHDw->cOBDOBI)    CPOS(43,1) CLEN(10) BGND(13) PP(2)      
    TYPE(Text) CAPTION(OBD_da�)            CPOS(60,1) CLEN( 8)
    TYPE(Text) NAME(UCTDOKHDw->cOBDOBIDAN) CPOS(69,1) CLEN(10) BGND(13) PP(2)      
* 2
    TYPE(Text) CAPTION(��slo dokladu)      CPOS( 1,2)
    TYPE(Text) NAME(UCTDOKHDw->nDOKLAD)    CPOS(16,2) CLEN(15) BGND(13) PP(2) 
* 3 
    TYPE(Text) CAPTION(SuAu_�)             CPOS( 1,3) CLEN( 8)
    TYPE(Text) NAME(UCTDOKHDw->cUCET_UCT)  CPOS(16,3) CLEN(15) BGND(13) PP(2) 
    TYPE(Text) CAPTION(VarSymbol)          CPOS(55,3)
    TYPE(Text) NAME(UCTDOKHDw->cVARSYM)    CPOS(69,3) CLEN(15) BGND(13) PP(2)      
* 4
    TYPE(Text) CAPTION(Text dokladu)       CPOS( 1,4) CLEN( 8)
    TYPE(Text) NAME(UCTDOKHDw->cTEXTDOK)   CPOS(16,4) CLEN(35) BGND(13) PP(2) 
    TYPE(Text) CAPTION(Celkem doklad)      CPOS(55,4)
    TYPE(Text) NAME(UCTDOKHDw->nCENZAKCEL) CPOS(69,4) CLEN(15) BGND(13) PP(2)     
    TYPE(Text) NAME(UCTDOKHDw->cTYPOBRATU) CPOS(86,4) CLEN( 5) 
TYPE(End)


TYPE(STATIC) STYPE(9) SIZE(99.8,6) FPOS(0.2,6.1) RESIZE(xx) CTYPE(3)
* 1
    TYPE(Text) CAPTION(SuAu_S)             CPOS( 1, .3) CLEN( 8)
    TYPE(Text) NAME(UCETPOLA->cUCETDAL)    CPOS(16, .3) CLEN(10) BGND(13) PP(2) 
    TYPE(Text) CAPTION(Celkem polo�ka)     CPOS(55, .3)
    TYPE(Text) NAME(UCETPOLA->nKCMD)       CPOS(71, .3) CLEN(15) BGND(13) PP(2)      
* 2
    TYPE(Text) CAPTION(P�rovac� symbol)    CPOS( 1,1.4)
    TYPE(Text) NAME(UCETPOLA->cSYMBOL)     CPOS(16,1.4) CLEN(10) BGND(13) PP(2) 
    TYPE(Text) CAPTION(Mno�stv� polo�ka)   CPOS(55,1.4) CLEN(16)
    TYPE(Text) NAME(UCETPOLA->nMNOZNAT)    CPOS(71,1.4) CLEN(15) BGND(13) PP(2)      
* 3
    TYPE(Text) CAPTION(Text polo�ky)       CPOS( 1,2.4)
    TYPE(Text) NAME(UCETPOLA->cTEXT)       CPOS(16,2.4) CLEN(35) BGND(13) PP(2)      
    TYPE(Text) CAPTION(Mno�stv� pol_2)     CPOS(55,2.4) CLEN(16)
    TYPE(Text) NAME(UCETPOLA->nMNOZNAT2)   CPOS(71,2.4) CLEN(15) BGND(13) PP(2)      
* 4
    TYPE(Text) CAPTION(V�rSt�edisko)       CPOS( 3,3.6) CLEN(10)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL1)    CPOS( 3,4.6) CLEN(13) BGND(13) PP(2)
    TYPE(Text) FCAPTION(V�robek)           CPOS(19,3.6) CLEN(10)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL2)    CPOS(19,4.6) CLEN(13) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Zak�zka)           CPOS(35,3.6) CLEN(10)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL3)    CPOS(35,4.6) CLEN(13) BGND(13) PP(2)
    TYPE(Text) FCAPTION(V�robn� m�sto)     CPOS(51,3.6) CLEN(12)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL4)    CPOS(51,4.6) CLEN(13) BGND(13) PP(2)
    TYPE(Text) FCAPTION(Stroj)             CPOS(67,3.6) CLEN(10)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL5)    CPOS(67,4.6) CLEN(13) BGND(13) PP(2)
    TYPE(Text) FCAPTION(V�robn� operace)   CPOS(83,3.6) CLEN(13)
    TYPE(Text) NAME(UCETPOLA->cNAZPOL6)    CPOS(83,4.6) CLEN(13) BGND(13) PP(2)

    TYPE(Static) STYPE(9) SIZE(99.8,2) FPOS(0.2,4.2)
    TYPE(End)
TYPE(End)

TYPE(DBrowse) FILE(UCETPOLA) FPOS(0.2,12.3) FIELDS(nORDITEM:�Polo�ky    , ;
                                                   cTEXT:Text polo�ky:40, ;
                                                   cUCETMD:SuAu_�       , ;
                                                   nKCMD:K�_md          , ;
                                                   nKCDAL:K�_dal        , ;
                                                   cUCETDAL:SuAu_S      , ;
                                                   UCT_ucetpola_TIP()::7  ) ;
              SIZE(99.9,10.5) CURSORMODE(3) PP(7) SCROLL(ny) Resize(xy)

