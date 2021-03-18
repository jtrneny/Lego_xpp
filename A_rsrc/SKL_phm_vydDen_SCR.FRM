TYPE(drgForm) DTYPE(10) TITLE(Výdej PHM dle dnù pohybu ...) ;
              SIZE(125,25)                                  ; 
              OBDOBI(SKL)                                   ;
              POST(postValidate)                            ;
              CARGO(SKL_phm_vydDen_in)                                        


  TYPE(STATIC) STYPE(12) FPOS(.5, .2) SIZE(57,9) RESIZE(XN) GROUPS(DAYS)
     
     TYPE(TEXT) NAME(M->nazMes)  CPOS(  2.5,  .6) FONT(6)  CLEN(12)    

     TYPE(STATIC) STYPE( 12) FPOS(15.6,0.6) SIZE(41,1 ) RESIZE(XX)
       TYPE(TEXT) CAPTION( Po)     CPOS( 1.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( Út)     CPOS( 7.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( St)     CPOS(13.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( Èt)     CPOS(19.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( Pá)     CPOS(25.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( So)     CPOS(31.0, 0.1) FONT(6)  CLEN(3)
       TYPE(TEXT) CAPTION( Ne)     CPOS(37.0, 0.1) FONT(6)  CLEN(3) 
     TYPE(End)  

***** 1 týden
     TYPE(GET) NAME(M->tyd1)      FPOS( 1.2,2.0) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION() 

     TYPE(PUSHBUTTON) POS( 16,1.8) SIZE( 4, .9) CAPTION(11) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,1.8) SIZE( 4, .9) CAPTION(12) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,1.8) SIZE( 4, .9) CAPTION(13) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,1.8) SIZE( 4, .9) CAPTION(14) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,1.8) SIZE( 4, .9) CAPTION(15) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,1.8) SIZE( 4, .9) CAPTION(16) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,1.8) SIZE( 4, .9) CAPTION(17) TIPTEXT(DAY)

***** 2 týden *****
     TYPE(GET) NAME(M->tyd2)      FPOS( 1.2,2.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

     TYPE(PUSHBUTTON) POS( 16,2.8) SIZE( 4, .9) CAPTION(21) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,2.8) SIZE( 4, .9) CAPTION(22) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,2.8) SIZE( 4, .9) CAPTION(23) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,2.8) SIZE( 4, .9) CAPTION(24) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,2.8) SIZE( 4, .9) CAPTION(25) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,2.8) SIZE( 4, .9) CAPTION(26) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,2.8) SIZE( 4, .9) CAPTION(27) TIPTEXT(DAY)


***** 3 týden ******
     TYPE(GET) NAME(M->tyd3)      FPOS( 1.2,3.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

     TYPE(PUSHBUTTON) POS( 16,3.8) SIZE( 4, .9) CAPTION(31) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,3.8) SIZE( 4, .9) CAPTION(32) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,3.8) SIZE( 4, .9) CAPTION(33) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,3.8) SIZE( 4, .9) CAPTION(34) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,3.8) SIZE( 4, .9) CAPTION(35) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,3.8) SIZE( 4, .9) CAPTION(36) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,3.8) SIZE( 4, .9) CAPTION(37) TIPTEXT(DAY)

***** 4 týden ******
     TYPE(GET) NAME(M->tyd4)      FPOS( 1.2,4.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

     TYPE(PUSHBUTTON) POS( 16,4.8) SIZE( 4, .9) CAPTION(41) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,4.8) SIZE( 4, .9) CAPTION(42) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,4.8) SIZE( 4, .9) CAPTION(43) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,4.8) SIZE( 4, .9) CAPTION(44) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,4.8) SIZE( 4, .9) CAPTION(45) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,4.8) SIZE( 4, .9) CAPTION(46) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,4.8) SIZE( 4, .9) CAPTION(47) TIPTEXT(DAY)

***** 5 týden *******
     TYPE(GET) NAME(M->tyd5)      FPOS( 1.2,5.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

     TYPE(PUSHBUTTON) POS( 16,5.8) SIZE( 4, .9) CAPTION(51) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,5.8) SIZE( 4, .9) CAPTION(52) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,5.8) SIZE( 4, .9) CAPTION(53) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,5.8) SIZE( 4, .9) CAPTION(54) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,5.8) SIZE( 4, .9) CAPTION(55) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,5.8) SIZE( 4, .9) CAPTION(56) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,5.8) SIZE( 4, .9) CAPTION(57) TIPTEXT(DAY)

***** 6 týden *******
     TYPE(GET) NAME(M->tyd6)      FPOS( 1.2,6.9) FLEN( 12) PP(1) FONT(1)  CTYPE(2)  NOREVISION()

     TYPE(PUSHBUTTON) POS( 16,6.8) SIZE( 4, .9) CAPTION(61) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 22,6.8) SIZE( 4, .9) CAPTION(62) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 28,6.8) SIZE( 4, .9) CAPTION(63) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 34,6.8) SIZE( 4, .9) CAPTION(64) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 40,6.8) SIZE( 4, .9) CAPTION(65) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 46,6.8) SIZE( 4, .9) CAPTION(66) TIPTEXT(DAY)
     TYPE(PUSHBUTTON) POS( 52,6.8) SIZE( 4, .9) CAPTION(67) TIPTEXT(DAY)
  TYPE(End)  




  TYPE(DBROWSE) FPOS(57,0) SIZE(66,9.5) FILE(PHMVYDstoj)                 ;
                                       FIELDS(nstojan:stojan           , ;
                                              cnazStoj:název Stojanu:19, ;
                                              npocStav:poèStav         , ;
                                              nvydej:výdej:10          , ;
                                              naktStav:aktStav           ) ;
                                       CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(ny) RESIZE(yx) 


  TYPE(EBrowse) FPOS(0,10) SIZE(124,13.5) FILE(PHMVYDstro) RESIZE(yx) PP(7) CURSORMODE(3) SCROLL(ny) ;
                                                                                          FOOTER(y)  ;   
                                                                                          ITEMMARKED(ItemMarked) GUILOOK(sizecols:y,headmove:n)

    TYPE(GET)  NAME(PHMVYDstro->nstojan)                   CLEN( 7)  CAPTION(stojan) 
    TYPE(TEXT) NAME(PHMVYDstro->cnazStoj)                  CLEN(18)  CAPTION(název stojanu)
    TYPE(GET)  NAME(PHMVYDstro->cstroj)                    CLEN( 8)  CAPTION(stroj) 
    TYPE(TEXT) NAME(PHMVYDstro->cnazStroj)                 CLEN(27)  CAPTION(název stroje)

    TYPE(TEXT) NAME(PHMVYDstro->npocStav)                  CLEN(12)  CAPTION(poèStav) 
    TYPE(GET)  NAME(PHMVYDstro->nspoDen)                   CLEN(12)  CAPTION(spoDen) 
    TYPE(TEXT) NAME(PHMVYDstro->naktStav)                  CLEN(12)  CAPTION(aktStav) 

    TYPE(TEXT) NAME(M->spoMes_BC)                          CLEN(12)  CAPTION(spoMes) 
    TYPE(TEXT) NAME(M->spoRok_BC)                          CLEN(12)  CAPTION(spoRok)
  TYPE(END)

*    TYPE(DBROWSE) FPOS(0,11) SIZE(119,12.5) FILE(PHMVYDstro)                  ;
*                                            FIELDS(nstojan:stojan           , ;
*                                                   nstroj:stroj             , ;
*                                                   cnazStroj:název stroje   , ;
*                                                   nspoDen:spoDen           , ;
*                                                   nspoMes:spoMes           , ;
*                                                   nspoRok:spoRok             ) ;
*                                         CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(ny) RESIZE(yx) 
*

  TYPE(TABPAGE) FPOS(.5,23.5) SIZE(124,1.2) TTYPE(3) OFFSET( 1,85) CAPTION(dle dne a stojanu) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) FPOS(.5,23.5) SIZE(124,1.2) TTYPE(3) OFFSET(15,71) CAPTION(dle dne výdeje)   TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

TYPE(End)