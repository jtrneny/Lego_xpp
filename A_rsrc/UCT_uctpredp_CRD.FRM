TYPE(drgForm) DTYPE(10) TITLE(Úèetní pøedpisy) SIZE(110,27) ;
              GUILOOK(Action:y,IconBar:y) CARGO() POST( PostValidate) PRE(PreValidate)

TYPE(Action) CAPTION(~Typy úètování) EVENT(TypyUctovani) TIPTEXT(Systémové typy úètování )
TYPE(Action) CAPTION(~NáklStrukt)    EVENT(UsrTypPoh)    TIPTEXT(Pøednastavení nákladové struktury)


  TYPE(DBrowse) FPOS(.5,1.2) SIZE(109.5,8.0) FILE(ucetprhd) INDEXORD(3) RESIZE(yy)            ;
                                              FIELDS( cTask:úloha:10                        , ;   
                                                      cTypPohybu:typPoh:15                  , ;
                                                      cTypDoklad:typDokladu:15              , ;  
                                                      cnazUcPred:název úèetního pøedpisu:57 , ;
                                                      dPlatnyOd:patnýOd)                      ; 
                                              CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(yy)



  TYPE(EBrowse) FPOS(.5,9.2) SIZE(109.5,8) FILE(UcetPrIt) INDEXORD(2)   RESIZE(yx) ;
                             CURSORMODE(3) PP(6) ITEMMARKED(ItemMarked)

    TYPE(GET)  NAME(ucetprit->npolUctPr)   FPOS(1,0) FLEN( 4) FCAPTION(pol)
    TYPE(GET)  NAME(ucetprit->nsubPolUc)   FPOS(2,0) FLEN( 3) FCAPTION(sub)
    TYPE(GET)  NAME(ucetprit->ctypUct)     FPOS(3,0) FLEN(10) FCAPTION(typÚèt)         PUSH(selTypyUct)
    TYPE(GET)  NAME(ucetprit->cnazUcPred)  FPOS(3,0) FLEN(30) FCAPTION(název pøedpisu)
    TYPE(GET)  NAME(ucetprit->cucetSkup)   FPOS(3,0) FLEN(10) FCAPTION(úèSkup)
    TYPE(GET)  NAME(ucetprit->dplatnyOd)   FPOS(4,0) FLEN(12) FCAPTION(datPlat)
    TYPE(GET)  NAME(ucetprit->cucetMd)     FPOS(3,0) FLEN( 9) FCAPTION(suau_Ø)
    TYPE(GET)  NAME(ucetprit->cucetDal)    FPOS(3,0) FLEN( 9) FCAPTION(suau_S)
    TYPE(GET)  NAME(ucetprit->cnazPol1)    FPOS(3,0) FLEN(10) FCAPTION(VýrStøedisko)
    TYPE(GET)  NAME(ucetprit->cnazPol2)    FPOS(3,0) FLEN(10) FCAPTION(Výrobek)
    TYPE(GET)  NAME(ucetprit->cnazPol3)    FPOS(3,0) FLEN(10) FCAPTION(Zakázka)
    TYPE(GET)  NAME(ucetprit->cnazPol4)    FPOS(3,0) FLEN(10) FCAPTION(VýrMísto)
    TYPE(GET)  NAME(ucetprit->cnazPol5)    FPOS(3,0) FLEN(10) FCAPTION(Stroj)
    TYPE(GET)  NAME(ucetprit->cnazPol6)    FPOS(3,0) FLEN(10) FCAPTION(VýrOperace)
    TYPE(GET)  NAME(ucetprit->cmainFile)   FPOS(3,0) FLEN(10) FCAPTION(soubor)
    TYPE(MLE)  NAME(ucetprit->mpodminka)   FPOS(5,0) FLEN(15) FCAPTION(podmínka)       SCROLL(nn) RESIZE(xx)
    TYPE(MLE)  NAME(ucetprit->mpopisUcPr)  FPOS(5,0) FLEN(15) FCAPTION(popis)          SCROLL(nn) RESIZE(xx)
  TYPE(END)

*
  TYPE(Static) STYPE(14) SIZE( 109.6,1.2) FPOS(.2,.1) CTYPE(2) RESIZE(yn)
    TYPE(Text)     CAPTION(Úèetní pøedpisy) CPOS( 63, .1) CLEN(15) FONT(5)
    TYPE(COMBOBOX) NAME(M->sel_ctask)       FPOS( 79, .1) FLEN(30) VALUES(a,a,a,a,a,a,a,a) ;
                                                          ITEMSELECTED(comboItemSelected)
  TYPE(End)


TYPE(TabPage) FPOS(0.5,17.5) SIZE(109.5,9.2) TTYPE(3) OFFSET( 1,86) CAPTION(Info) RESIZE(yx)
  TYPE(TEXT) CAPTION(Typ zaúètování    :)       CPOS(  .5, .2) CLEN(14) 
   TYPE(TEXT) NAME(UcetPrIt->cTypUct)           CPOS(14.5, .2) CLEN(15) FONT(5) BGND(12)
   TYPE(TEXT) NAME(UcetPrSy->cNazTypUct)        CPOS(30.5, .2) CLEN(50) 

  TYPE(TEXT) CAPTION(Úèetní skupina     :)      CPOS(  .5,1.4) CLEN(14) 
   TYPE(TEXT) NAME(UcetPrIt->cUcetSkup)         CPOS(14.5,1.4) CLEN(12)

  TYPE(TEXT) CAPTION(Úèet øídící             :) CPOS(   .5,2.5) CLEN(14) 
   TYPE(TEXT) NAME(UcetPrIt->cUcetMD)           CPOS( 14.5,2.5) CLEN(12) FONT(2) BGND(13)
   TYPE(TEXT) NAME(M->cnaz_uctMD)               CPOS( 30.5,2.5) 

  TYPE(TEXT) CAPTION(Úèet souvztažný :)         CPOS(   .5,3.7) CLEN(14) 
   TYPE(TEXT) NAME(UcetPrIt->cUcetDAL)          CPOS( 14.5,3.7) CLEN(12) FONT(2) BGND(13)
   TYPE(TEXT) NAME(M->cnaz_uctDAL)              CPOS( 30.5,3.7) 

*
** ns
  TYPE(Static) SIZE(103,2.5) FPOS(3,5) RESIZE(y) CTYPE(2) 
    TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, -.1) CLEN(11) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)   CPOS( 3,1.2) CLEN(13) PP(2) BGND(13) 

    TYPE(Text) FCAPTION(Výrobek)         CPOS(19, -.1) CLEN( 8) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)   CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(Zakázka)         CPOS(35, -.1) CLEN( 8) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)   CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(VýrMísto)        CPOS(51, -.1) CLEN( 9) PP(3) BGND( 1) 
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)   CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(Stroj)           CPOS(67, -.1) CLEN( 6) PP(3) BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)   CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Text) FCAPTION(VýrOperace)      CPOS(83, -.1) CLEN(10) PP(3) BGND( 1) 
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)   CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

    TYPE(Static) STYPE(12) SIZE(101,.09) FPOS(1,.4)
    TYPE(End)
  TYPE(End)



*  TYPE(TEXT) CAPTION(Støedisko) CPOS(0.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol1) CPOS( 0.5,5.8) CLEN(12)
*  TYPE(TEXT) CAPTION(Výrobek) CPOS(15.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol2) CPOS(15.5,5.8) CLEN(12)
*  TYPE(TEXT) CAPTION(Zakázka) CPOS(30.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol3) CPOS(30.5,5.8) CLEN(12)
*  TYPE(TEXT) CAPTION(VýrMísto) CPOS(45.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol4) CPOS(45.5,5.8) CLEN(12)
*  TYPE(TEXT) CAPTION(Stroj) CPOS(60.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol5) CPOS(60.5,5.8) CLEN(12)
*  TYPE(TEXT) CAPTION(Operace) CPOS(75.5,4.8) CLEN(12)
*   TYPE(TEXT) NAME(UcetPrIt->cNazPol6) CPOS(75.5,5.8) CLEN(12)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(END)


TYPE(TabPage) FPOS(0.5,17.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(14,72) CAPTION(Podmínka) RESIZE(yx)
  TYPE(MLE) NAME('UcetPrIt->mPodminka') FPOS(0.5,0.2) SIZE(108.2,7.6) RESIZE(yx);
             READONLY(Y) FCAPTION(Strana MD) CPOS(1.5, 17.8) CLEN(20)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(END)


TYPE(TabPage) FPOS(0.5,17.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(28,58) CAPTION(Úètování) RESIZE(yx)
  TYPE(MLE) NAME('UcetPrSy->mUctuj_MD') FPOS(  0.1,0.1) SIZE(54.4,7.9) READONLY(Y) FCAPTION(Strana MD) CPOS(1.5, 17.8) CLEN(20) RESIZE(xx)
  TYPE(MLE) NAME('UcetPrSy->mUctuj_DAL') FPOS(54.6,0.1) SIZE(54.4,7.9) READONLY(Y) FCAPTION(Strana DAL) CPOS(51.35, 17.8) CLEN(20) RESIZE(yx)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(END)



