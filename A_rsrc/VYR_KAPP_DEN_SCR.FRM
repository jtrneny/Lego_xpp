TYPE(drgForm) DTYPE(10) TITLE(Denní kapacity strojní) SIZE(110,25) FILE(KAPP_DEN);
              CARGO( VYR_KAPP_DEN_CRD) OBDOBI(VYR)

*TYPE(Action) CAPTION(~Pohyby) EVENT(HIM_POHYBY) TIPTEXT(Pohyby investièního majetku)

  TYPE(DBrowse) INDEXORD(1) ;
                FIELDS( dVyhotPlan   ,;
                        nTydKapBlo   ,;
                        nObdobi      ,;
                        nRokVytvor   ,;
                        cOznPrac     ,;
                        cStred       ,;
                        nPracoDoba   ,;
                        nPocetStro  ,;
                        nKapacNhod  ,;
                        nBlokaceNh  ,;
                        nVolnaKapa  ,;
                        nPocSmen    ,;
                        cCisPlan    ,;
                        cPoznamka   );
               SIZE(110,25) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(yy) POPUPMENU(y);
               ITEMMARKED( ItemMarked)