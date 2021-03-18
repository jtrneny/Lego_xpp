TYPE(drgForm) SIZE(105,26) DTYPE(10) TITLE(Pøehled DIM v evidenci ...) ;
              CARGO(DIM_MSDIM_CRD) FILE(MSDIM) OBDOBI(DIM) ;
              PRINTFILES(zmenydim:cKLICskMIS=cKLICskMIS+cKLICodMIS=cKLICodMIS+ntypdim=ntypdim+ninvcisdim=ninvcisdim) ;
              CBSAVE(onSave)

TYPE(Action) CAPTION(~pohyb DIm) EVENT(Cards_ZMENYDIM) TIPTEXT(Pøevod/Vyøazení/Výdej)
* TYPE(Action) CAPTION(~test Footing) EVENT(test_Foot) TIPTEXT(Test chování patièky)


* Browser definition
  TYPE(DBrowse) FILE(MSDIM)                        ;
                FIELDS( M->msDim_naradi::3.3::2  , ;
                        M->msDim_state::2.6::2   , ;
                        cKLICskMIS:SKUP_místo:8  , ;
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


TYPE(TABPAGE) FPOS(0,15.2) SIZE(104.5,10.5) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.9) PRE(tabSelect) SUBTABS(A1,A2,A3) RESIZE(yx)

* A1
  TYPE(TabPage) FPOS(.5,.5) SIZE(104,9.7)  TTYPE(3) OFFSET( 1,82) CAPTION(Základní údaje) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A1)

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
 
  TYPE(End)

* A2
  TYPE(TabPage) FPOS(.5,.5) SIZE(104,9.7)  TTYPE(3) OFFSET( 18,64) CAPTION(Náøadí (El)) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A2)

*   Náøadí (El)
    TYPE(Static) STYPE(2) SIZE(103.5,8.7) FPOS(.5,.01) RESIZE(y)
* 1
      TYPE(Text) CAPTION(výrobce)           CPOS( 1, .5)
      TYPE(Text) NAME(elNarDIm->cVYROBCE)   CPOS(17, .5) CLEN(25) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(rokVýroby)        CPOS(60, .5)
      TYPE(Text) NAME(elNarDIm->nROKvyr)    CPOS(76, .5) CLEN(15) BGND(13) PP(2) 
* 2
      TYPE(Text) FCAPTION(výrobní èíslo)    CPOS( 1,1.5)
      TYPE(Text) NAME(MSDIM->cVYRcisDIM)    CPOS(17,1.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(katPouživ)        CPOS(60,1.5)
      TYPE(Text) NAME(elNarDIm->cKATEGpouz) CPOS(76,1.5) CLEN(15) BGND(13) PP(2) 
* 3
      TYPE(Text) FCAPTION(typOznaèení)      CPOS( 1,2.5)
      TYPE(Text) NAME(elNarDIm->cTYPoznac)  CPOS(17,2.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(tøOchrany)        CPOS(60,2.5)
      TYPE(Text) NAME(elNarDIm->cTRIDAochr) CPOS(76,2.5) CLEN(15) BGND(13) PP(2) 
* 4
      TYPE(Text) FCAPTION(napìtí)           CPOS( 1,3.5)
      TYPE(Text) NAME(elNarDIm->nNAPETI)    CPOS(17,3.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) CAPTION((V))               CPOS(33,3.5) CLEN(5)

      TYPE(Text) FCAPTION(proud)            CPOS(35,3.5)
      TYPE(Text) NAME(elNarDIm->nPROUD)     CPOS(42,3.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(pøíkon)           CPOS(60,3.5)
      TYPE(Text) NAME(elNarDim->nPRIKON)    CPOS(76,3.5) CLEN(15) BGND(13) PP(2) 

      TYPE(Static) STYPE(2) SIZE(102.5,2.5) FPOS(.5,6.2) CAPTION(Kontrola elektrického náøadí) CTYPE(1) FONT(5)
        TYPE(Text) CAPTION(plánovaná)          CPOS( 25, -.1)                   PP(3) BGND(1)
        TYPE(Text) NAME(ELNARDIM->DDATPOSKON)  CPOS( 25, 1  ) CLEN(12) BGND(13) PP(1) FONT(5)

        TYPE(Text) CAPTION(uskuteènìna)        CPOS( 42, -.1)                   PP(3) BGND(1) 
        TYPE(Text) NAME(ELNARDIM->DDATDALKON)  CPOS( 42, 1  ) CLEN(12) BGND(13) PP(1) FONT(5)

        TYPE(Text) CAPTION(hodnocení)          CPOS( 60, -.1)                   PP(3) BGND(1)
        TYPE(Text) NAME(ELNARDIM->CCELKHODNO)  CPOS( 60, 1  ) CLEN( 3) BGND(13) PP(1) FONT(5)
        TYPE(Text) NAME(C_TYPHOD->CNAZTYPHOD)  CPOS( 74,1   )                   PP(3) BGND(1) FONTS(5)
      TYPE(End)

    TYPE(End) 

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* A3
  TYPE(TabPage) FPOS(.5,.5) SIZE(104,9.7)  TTYPE(3) OFFSET( 35,47) CAPTION(Popis DIMu) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yy) SUB(A3)
    TYPE(MLE) NAME(msDIm->mpoznamka) FPOS(.5, .2) SIZE(103,8.3) FONT(5) SCROLL(ny) PP(3) RESIZE(yy) READONLY(y)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

TYPE(END)


  TYPE(TABPAGE) FPOS(0,15.2) SIZE(104.5,10.5) TTYPE(3) OFFSET(13,74) CAPTION(pohyby) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(DBrowse) SIZE(104.5,9.2) FILE(ZMENYDIM) FIELDS(nciszmDim:èísZmìny            , ;
                                                        cpopzmDim:názZmìny            , ;
                                                        cbropolDim:název položky zmìny, ;
                                                        coldVal:pùvodní hodnota       , ;
                                                        cnewVal:nová hodnota            ) ;
                  CURSORMODE(3) SCROLL(ny) RESIZE(yx) INDEXORD(8) PP(7)
  TYPE(End)


  TYPE(TABPAGE) FPOS(0,15.2) SIZE(104.5,10.5) TTYPE(3) OFFSET(25,62) CAPTION(zmìny v kartì) TABHEIGHT(.9) PRE(tabSelect) RESIZE(yx)
    TYPE(DBrowse) SIZE(104.5,9.2) FILE(ZMENYDIM) FIELDS(nciszmDim:èísZmìny            , ;
                                                        cpopzmDim:názZmìny            , ;
                                                        cbropolDim:název položky zmìny, ;
                                                        coldVal:pùvodní hodnota       , ;
                                                        cnewVal:nová hodnota            ) ;
                  CURSORMODE(3) SCROLL(ny) RESIZE(yx) INDEXORD(8) PP(7)
  TYPE(End)


* quickFilr
  TYPE(Static) STYPE(13) SIZE( 36.3,1.1) FPOS( 68, .02) RESIZE(nn) CTYPE(2)
    TYPE(PushButton) POS(.1,.01)   SIZE(253,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)


