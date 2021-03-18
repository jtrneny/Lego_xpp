TYPE(drgForm) DTYPE(10) TITLE(Evidence DIm - VÝBÌR) SIZE(96, 20);
               GUILOOK(Action:y,Message:y,IconBar:y:drgStdBrowseIconBar,Menu:n)


* TYPE(Action) CAPTION(info_C~eník)       EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)

  TYPE(Static) STYPE(12) SIZE(96,7.8) FPOS( .1, .1) RESIZE(xy) CTYPE(2) GROUPS(SKL_PRE)
    TYPE(Text) CAPTION(... inventární èíslo DIMu neexistuje v evidenci ... ) CLEN(90) CPOS(1, 0) CTYPE(1) FONT(7)  GROUPS(SKL_PRE_MAIN)

    TYPE(Text) CAPTION(INV_èíslo)          CPOS( 30, 1.2) CLEN(10)          FONT(5)                               
    TYPE(Text) NAME(M->invCISdim)          CPOS( 40, 1.3) CLEN( 9) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(TEXT) NAME(M->nazevDIm)           CPOS( 50, 1.3) CLEN(25)

    TYPE(Text) CAPTION(pøevod ze skladu ->)  CPOS(  2, 3) CLEN(18)          FONT(5)                                GROUPS(SKL_PRE)
    TYPE(Text) NAME(pvpheadW->ccisSklad)     CPOS( 20, 3) CLEN( 8) BGND( 9) FONT(5) CTYPE(1) PP(2)                  
    TYPE(Text) NAME(M->nazSklad)             CPOS( 29, 3) CLEN(12) 
    TYPE(Text) CAPTION(sklPoložku ->)        CPOS( 42, 3) CLEN(13)          FONT(5)                                GROUPS(SKL_PRE)
    TYPE(Text) NAME(M->sklPol)               CPOS( 55, 3) CLEN(15) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Text) NAME(M->nazZbo)               CPOS( 71, 3) CLEN(25)

    TYPE(Text) CAPTION(na SKUP_místo )     CPOS(  4, 4.2) CLEN(14)          FONT(5)                                GROUPS(SKL_PRE) 
    TYPE(Text) NAME(M->klicSKmis)          CPOS( 20, 4.2) CLEN( 8) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Text) NAME(C_SkuMis->cNazSkMis)   CPOS( 29, 4.2) CLEN(12)                                                                  

    TYPE(Text) CAPTION(ODP_místo)          CPOS( 42, 4.2) CLEN(12)          FONT(5)                                GROUPS(SKL_PRE)
    TYPE(Text) NAME(M->klicODmis)          CPOS( 55, 4.2) CLEN( 9) BGND( 9) FONT(5) CTYPE(1) PP(2) 
    TYPE(Text) NAME(C_OdpMis->cNazOdpMis)  CPOS( 71, 4.2) CLEN(20)

    TYPE(PushButton) POS( 64, 6.2) SIZE(15, 1.2) CAPTION(     ~založitKartu)  EVENT(skl_msDim_pk_autoNew) ICON1(119) ICON2(0) ATYPE(3) TIPTEXT(Automaticky založit novou kartu DIMu)
    TYPE(PushButton) POS( 80, 6.2) SIZE(15, 1.2) CAPTION(    ~poøídit_Kartu)  EVENT(skl_msDim_pk_editNew) ICON1(119) ICON2(0) ATYPE(3) TIPTEXT(Poøídit novou kartu DIMu)
  TYPE(End)


  TYPE(DBrowse) FILE(MSDIM) INDEXORD(1)        ;
                FIELDS(POCkusDIM()::1::2     , ;
                       cKLICskMIS:sk_Misto   , ;
                       cKLICodMIS:odp_Misto  , ;
                       nINVcisDIM:invÈíslo   , ;
                       cNAZEVdim:název DIm:30, ;
                       dDATzarDIM:datZaø:10  , ;
                       nPOCkusDIM:množství:10, ;
                       nCENcelDIM:cenaCelk     ) ;
                 FPOS( 0, 8) SIZE(96,11.5) CURSORMODE(3) RESIZE(yx) PP(7) SCROLL(ny) ;
                 ITEMMARKED(itemMarked) ITEMSELECTED(dBro_itemSelected) POPUPMENU(yn)



*
*  TYPE(Static) STYPE(1) SIZE( 20,1.2) FPOS( 89, 2)  RESIZE(nn)
*    TYPE(PushButton) POS(0,0)   SIZE(20,1.05) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*  TYPE(End)


