TYPE(drgForm) DTYPE(10) TITLE(Kategorie zvíøat) SIZE(110,25) FILE(KategZvi);
              CARGO( ZVI_KategZvi_CRD) OBDOBI(ZVI)

*TYPE(Action) CAPTION(~Pohyby) EVENT(HIM_POHYBY) TIPTEXT(Pohyby investièního majetku)

  TYPE(DBrowse) INDEXORD(1) ;
                FIELDS( nZvirKat    ,;
                        cNazevKat   ,;
                        nUcetSkup   ,;
                        C_UctSkZ->cNazUctSk::23,;
                        ctypCZcpa:typ cz-cpa   ,;
                        cTypSkp     ,;                        
                        cNazPol2    ,;
                        lVzrust     ,;
                        nZvirKatPR  ,;
                        cNazPol2PR ) ;
               SIZE(110,25) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y);
               ITEMMARKED( ItemMarked)