TYPE(drgForm) DTYPE(10) TITLE(Oprava kontrolního hlášení k DPH ...) SIZE(110,25)                                 ;
                                                                    PRINTFILES(DPHkohHD:cIDhlaseni=cIDhlaseni,   ; 
                                                                               DPHkohIT:cIDhlaseni=cIDhlaseni,   ;
                                                                               dph_2015:cobdobidan=cobdobidan  ) ;
                                                                    COMMFILES( DPHkohHD:cIDhlaseni=cIDhlaseni,   ; 
                                                                               DPHkohIT:cIDhlaseni=cIDhlaseni,   ;
                                                                               dph_2015:cobdobidan=cobdobidan  ) 

* csesjmeno, cidvyzvy, nQ, ddatmduvod, cOP,cRP, cOP, cDP, nM, nrok, crychodpov, ddo, ccorient, ccp, SysConfig('System:nFINURAD'), SysConfig('System:nFINURKRAJ')
* cdic, cmail, ciddatschr, cfyzosjmen, cSidlo, codposjmen, codposprij, cfyzosprij, cpsc, csestelef, cstat, ctitul, SysConfig('System:cTYPDANSUB')
* cUlice, dzasdatnar, czasevcis, czasico, czasjmeno, czaskod, czasnazev, czasprijm, czastyp, cpraosnaz         

  TYPE(DBrowse) FPOS(-.7, 1.4) SIZE(109.5,4) FILE(dphKoh_hW)                                 ; 
                                             FIELDS(cIDhlaseni                             , ; 
                                                    cRP:Ø                                  , ;
                                                    cOP:O                                  , ;
                                                    cDP:D                                  , ;
                                                    cOBDOBIDAN:obdDaò                      , ; 
                                                    cIdVyzvy:IdVyzvy                       , ; 
                                                    dSESDNE:datZpr:10                      , ;
                                                    cSESJMENO:výkaz Sestavil:36            , ;
                                                    nSumDaP01                              , ; 
                                                    nSumDaP02                              , ;
                                                    nSumDaP40                              , ;
                                                    nSumDaP41                              , ;
                                                    nSumDaP25                              , ; 
                                                    nSumDaP10                              , ;  
                                                    nSumDaP11                              , ; 
                                                    nSumDaP313                               ) ;
                                             INDEXORD(1) CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) ITEMMARKED(itemMarked) POPUPMENU(n)



  TYPE(TABPAGE) FPOS(.5,5.8) SIZE(109.5,19) TTYPE(3) OFFSET(74,17) CAPTION(Komplet) TABHEIGHT(0) PRE(tabSelect) RESIZE(yx)

    TYPE(EBrowse) FPOS(-.7,.1) SIZE(108.5,19) FILE(dphKoh_iW)                                         ;
                                              INDEXORD(2) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy) REST(n)


      TYPE(TEXT)     NAME(        M->isedit_Parent)  CLEN( 2)   CAPTION()              BITMAP()
      TYPE(COMBOBOX) NAME(dphKoh_iW->coddilKohl)     FLEN( 6)   CAPTION(oddil)         VALUES(A.1,A.2,A.3,A.4,A.5,B.1,B.2,B.3)
      TYPE(TEXT)     NAME(dphKoh_iW->nradek)         CLEN( 4)   CAPTION(èØádku)    
      TYPE(GET)      NAME(dphKoh_iW->cdic)           FLEN(16)   CAPTION(diè_obìratele)
      TYPE(GET)      NAME(dphKoh_iW->cdanDoklad)     FLEN(20)   CAPTION(daòDoklad)
      TYPE(GET)      NAME(dphKoh_iW->dvystFak)       FLEN(12)   CAPTION(datUzp)        PUSH(clickdate)

      TYPE(GET)      NAME(dphKoh_iW->nzaklD_dph)     FLEN(13)   CAPTION(záklDanì)
      TYPE(GET)      NAME(dphKoh_iW->nzaklDan_1)     FLEN(13)   CAPTION(záklDaò_1)
      TYPE(GET)      NAME(dphKoh_iW->nsazDan_1)      FLEN(13)   CAPTION(Daò_1)
      TYPE(GET)      NAME(dphKoh_iW->nzaklDan_2)     FLEN(13)   CAPTION(záklDaò_2)
      TYPE(GET)      NAME(dphKoh_iW->nsazDan_2)      FLEN(13)   CAPTION(Daò_2)
      TYPE(GET)      NAME(dphKoh_iW->nzaklDan_3)     FLEN(13)   CAPTION(záklDaò_3)
      TYPE(GET)      NAME(dphKoh_iW->nsazDan_3)      FLEN(13)   CAPTION(Daò_3)
      TYPE(GET)      NAME(dphKoh_iW->nOsvOdDan)      FLEN(13)   CAPTION(osvPlnnìní)
      TYPE(COMBOBOX) NAME(dphKoh_iW->ntypPreDan)     FLEN(15)   CAPTION(kódPlnìní)     REF(NTYPPREDAN)  

      TYPE(TEXT)     NAME(dphKoh_iW->cdenik)         CLEN( 3)   CAPTION(deník)  
      TYPE(TEXT)     NAME(dphKoh_iW->ndoklad)        CLEN(10)   CAPTION(doklad)  
    TYPE(END)

  TYPE(END)



  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(99,1.25)
    TYPE(TEXT) CAPTION(Rok zpracování) CPOS(60,0.6) CLEN(15) CTYPE(3) FONT(5)

    TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(78.5,0.5) FLEN(20);
                  VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
                  ITEMSELECTED(comboItemSelected)
  TYPE(END)



