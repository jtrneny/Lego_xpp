TYPE(drgForm) DTYPE(10) TITLE(Typy úètování) SIZE(100,25) ;
              GUILOOK(Action:n,IconBar:y) CARGO() POST( PostValidate)

*TYPE(Action) CAPTION(~Typy úètování) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


  TYPE(EBrowse) FPOS(0.50,0.2) SIZE(98.75,8.0) FILE(UcetPrSy) INDEXORD(1)                           ;
                               CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) ITEMSELECTED(ItemSelected) 

    TYPE(GET)  NAME(ucetprsy->ctypUct)     FPOS(1,0) FLEN(10) FCAPTION(typÚèt)
    TYPE(GET)  NAME(ucetprsy->cnazTypUct)  FPOS(2,0) FLEN(30) FCAPTION(název typu_Úèt)
    TYPE(GET)  NAME(ucetprsy->cmainFile)   FPOS(3,0) FLEN(10) FCAPTION(soubor)
    TYPE(GET)  NAME(ucetprsy->dplatnyOd)   FPOS(4,0) FLEN(12) FCAPTION(datPlat)
    TYPE(MLE)  NAME(ucetprsy->mpopisUct)   FPOS(5,0) FLEN(15) FCAPTION(popis) SCROLL(nn)
  TYPE(END)

*
  TYPE(MLE) NAME('UcetPrSy->mUctuj_MD') FPOS(0.50,8.4) SIZE(49.40,16.15) ;
            READONLY(N) FCAPTION(Strana MD) CPOS(1.5, 17.8) CLEN(20) FONT(5)

  TYPE(MLE) NAME('UcetPrSy->mUctuj_DAL') FPOS(50.35,8.4) SIZE(49.40,16.15) ;
            READONLY(N) FCAPTION(Strana DAL) CPOS(51.35, 17.8) CLEN(20) FONT(5)


