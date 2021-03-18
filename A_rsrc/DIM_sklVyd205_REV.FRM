TYPE(drgForm) SIZE(105,26) DTYPE(10) TITLE(Skladový výdej do DIMu _ kontrola ...) ;
              FILE(msDIMw) ;
              GUILOOK(Message:Y,Action:y,IconBar:n,Menu:n);
              POST(postValidate)


* TYPE(Action) CAPTION(~pohyb DIm) EVENT(Cards_ZMENYDIM) TIPTEXT(Pøevod/Vyøazení/Výdej)
* TYPE(Action) CAPTION(~test Footing) EVENT(test_Foot) TIPTEXT(Test chování patièky)


* Browser definition
  TYPE(DBrowse) FILE(MSDIMw)                       ;
                FIELDS( cKLICskMIS:SKUP_místo:8  , ;
                        cKLICodMIS:ODP_místo:8   , ;
                        nINVcisDIM:INV_èíslo:6   , ;
                        cNAZEVdim:název DIMu:30  , ;
                        dDATzarDIM:datZaøaz:10   , ;
                        nPOCkusDIM:množství::::1 , ;
                        nCENcelDIM:cenaCelk::::1 , ;
                        ddatPohDIm:datPohybu:10  , ;
                        dDATvyrDIM:datVyøaz:10     ) ;
                FPOS( -.2,1.1) SIZE(105,14) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(y) ;
                FOOTER(yy)


TYPE(TABPAGE) FPOS(0,15.2) SIZE(104.5,10.5) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.01) PRE(tabSelect) RESIZE(yx)

* A1
****  TYPE(TabPage) FPOS(.5,.5) SIZE(104,9.7)  TTYPE(3) OFFSET( 1,82) CAPTION(Základní údaje) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A1)

*   Základní údaje
    TYPE(Static) STYPE(2) SIZE(103.5,8.7) FPOS(.5,.01) RESIZE(y)
* 1
      TYPE(Text) CAPTION(SKUP_místo)   CPOS( 1,1)
      TYPE(Text) NAME(cKLICskMIS)      CPOS(17,1) CLEN(15) BGND(13) PP(2)
        TYPE(Text) NAME(M->nazSkMis)   CPOS(33,1) CLEN(25) FONT(5)
 
      TYPE(Text) FCAPTION(TYP__DIM  )  CPOS(60,1)
      TYPE(Text) NAME(nTYPdim)         CPOS(76,1) CLEN(15) BGND(13) PP(2) 
* 2
      TYPE(Text) FCAPTION(ODP__místo)  CPOS( 1,2)
      TYPE(Text) NAME(cKLICodMIS)      CPOS(17,2) CLEN(15) BGND(13) PP(2) 
        TYPE(Text) NAME(M->nazOdpMis)  CPOS(33,2) CLEN(25) FONT(5)

      TYPE(Text) FCAPTION(Typ cz-cpa)  CPOS(60,2)
      TYPE(Text) NAME(ctypCZcpa)       CPOS(76,2) CLEN(15) BGND(13) PP(2) 

*      TYPE(Text) FCAPTION(TYP__SKP)    CPOS(60,2)
*      TYPE(Text) NAME(cTYPskp)         CPOS(76,2) CLEN(15) BGND(13) PP(2) 
* 3
      TYPE(Text) FCAPTION(Množství)    CPOS( 1,3)
      TYPE(Text) NAME(nPOCkusDIM)      CPOS(17,3) CLEN(15) BGND(13) PP(2) CTYPE(2)
      TYPE(Text) FCAPTION(Cena za MJ)  CPOS(60,3)
      TYPE(Text) NAME(nCENjedDIM)      CPOS(76,3) CLEN(15) BGND(13) PP(2) CTYPE(2)
* 4
      TYPE(Text) FCAPTION(Cena celkem) CPOS(60,4)
      TYPE(Text) NAME(nCENcelDIM)      CPOS(76,4) CLEN(15) BGND(13) PP(2) CTYPE(2)
* 5
      TYPE(Text) FCAPTION(VÝR__èíslo)  CPOS( 1,5)
      TYPE(Text) NAME(cVYRcisDIM)      CPOS(17,5) CLEN(15) BGND(13) PP(2)          RESIZE(y) 
      TYPE(Text) FCAPTION(Revize)      CPOS(60,5)
      TYPE(Text) NAME(dDATrevDIM)      CPOS(76,5) CLEN(15) BGND(13) PP(2)          RESIZE(y)
* 6
* NS
      TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, 6.1) CLEN(11) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL1)   CPOS( 3,7.2) CLEN(13) PP(2) BGND(13)           RESIZE(y)

      TYPE(Text) FCAPTION(Výrobek)         CPOS(19, 6.1) CLEN( 8) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL2)   CPOS(19,7.2) CLEN(13)       BGND(13) PP(2)     RESIZE(y)

      TYPE(Text) FCAPTION(Zakázka)         CPOS(35, 6.1) CLEN( 8) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL3)   CPOS(35,7.2) CLEN(13)       BGND(13) PP(2)     RESIZE(y)

      TYPE(Text) FCAPTION(VýrMísto)        CPOS(51, 6.1) CLEN( 9) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL4)   CPOS(51,7.2) CLEN(13)       BGND(13) PP(2)     RESIZE(y)
 
      TYPE(Text) FCAPTION(Stroj)           CPOS(67, 6.1) CLEN( 6) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL5)   CPOS(67,7.2) CLEN(13)       BGND(13) PP(2)     RESIZE(y)

      TYPE(Text) FCAPTION(VýrOperace)      CPOS(83, 6.1) CLEN(10) PP(3) BGND( 1) 
      TYPE(Text) NAME(cNAZPOL6)   CPOS(83,7.2) CLEN(13)       BGND(13) PP(2)     RESIZE(y)

      TYPE(Static) STYPE(12) SIZE(103.5,.3) FPOS(.2,6.3) RESIZE(y)
      TYPE(End)

    TYPE(End)  
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
 
****  TYPE(End)
TYPE(End)

