TYPE(drgForm) SIZE(110,25) DTYPE(10) TITLE(Pøehled zmìn DIMu dle dokladù ...) ;
              CARGO(DIM_MSDIM_CRD) FILE(MSDIM) OBDOBI(DIM) ;
              PRINTFILES(zmenydim:cKLICskMIS=cKLICskMIS+cKLICodMIS=cKLICodMIS+ntypdim=ntypdim+ninvcisdim=ninvcisdim) ;
              CBSAVE(onSave)

* TYPE(Action) CAPTION(~pohyb DIm) EVENT(Cards_ZMENYDIM) TIPTEXT(Pøevod/Vyøazení/Výdej)
* TYPE(Action) CAPTION(~test Footing) EVENT(test_Foot) TIPTEXT(Test chování patièky)


* Browser definition
   TYPE(DBrowse) SIZE(110,21.5) FILE(ZMENYDIM)                          ; 
                              FIELDS(ninvCISdim:invÈíslo              , ;
                                     ncisZMdim:doklad:10              , ;
                                     cobdobi:obdZm                    , ;                                   
                                     cpopZMdim:názZmìny:10            , ;
                                     cbroPOLdim:název položky zmìny:36, ;
                                     coldVal:pùvodní hodnota:20       , ;
                                     cnewVal:nová hodnota:20            ) ;
                  CURSORMODE(3) INDEXORD(5) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(y)

  TYPE(STATIC) STYPE(13) FPOS(0,22) SIZE(110,3) RESIZE(y) CTYPE(2)
    TYPE(DBrowse) FPOS(-.5,.5) SIZE(109,3) FILE(MSDIM)   ;
                               FIELDS(POCkusDIM()::1::2 , ;
                                      cKLICskMIS               , ;
                                      cKLICodMIS               , ;
                                      nINVcisDIM               , ;
                                      cNAZEVdim::45            , ;
                                      dDATzarDIM::10           , ;
                                      nPOCkusDIM               , ;
                                      nCENcelDIM                 ) ;
                               SCROLL(nn) CURSORMODE(3) PP(7)
  TYPE(END)






