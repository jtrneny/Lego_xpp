TYPE(drgForm) SIZE(110,26) DTYPE(10) TITLE(Karty obratù na úètech _) OBDOBI(UCT)
              

* Browser definition
  TYPE(DBrowse) FPOS(0,1.2) SIZE(110,9.8) FILE(C_UCTOSN)                      ;
                            FIELDS(cUCET:úèet                               , ;
                                   cNAZ_UCT:název úètu:33                   , ;
                                   uct_c_uctosn_all_('naklstr'):ns:2.6::2   , ;
                                   cZUSTUCT:zus                             , ; 
                                   uct_c_uctosn_all_('vynosuct'):vyn:2.6::2 , ;
                                   uct_c_uctosn_all_('nakluct'):nak:2.6::2  , ;
                                   uct_c_uctosn_all_('aktivuct'):akt:2.6::2 , ;
                                   uct_c_uctosn_all_('pasivuct'):pas:2.6::2 , ;
                                   uct_c_uctosn_all_('zaveruct'):zav:2.6::2 , ;
                                   uct_c_uctosn_all_('podrzuct'):podr:2.6::2, ;
                                   uct_c_uctosn_all_('naturuct'):nat:2.6::2 , ;
                                   uct_c_uctosn_all_('saldouct'):sal:2.6::2 , ;
                                   uct_c_uctosn_all_('finuct'):fin:2.6::2   , ;
                                   uct_c_uctosn_all_('danuct'):daò:2.6::2   , ;
                                   uct_c_uctosn_all_('mimoruct'):mim:2.6::2 , ;
                                   uct_c_uctosn_all_('syntuct'):syn:2.6::2  , ;
                                   cUSERABB:uživatel                        , ;
                                   dDATZMENY:datZmìny                         ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y)



  TYPE(DBrowse) FPOS(0,11.2) SIZE(110,8.7) FILE(UCETKUM)                           ;
                                         FIELDS(uct_ucetkum_all_('uzav'):U:2.6::2, ;
                                                uct_ucetkum_all_('aktu'):A:2.6::2, ; 
                                                M->obdDokl:obdobi:7              , ; 
                                                cUCETMD:SuAu_ø                   , ;
                                                M->nazevUctu:název úètu:31       , ;
                                                nKCMDOBRO:obrat(md)              , ;
                                                nKCDALOBRO:obrat(dal)            , ;
                                                nKCMDKSR:stav(md)                , ;
                                                nKCDALKSR:stav(dal)                ) ; 
                                         CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(4) 



*  TYPE(ComboBox) NAME(UCT_ucetsys:CULOHA) FPOS(1,.1) FLEN(28);
*                 VALUES(A:Generované automaty,AN:Nedokonèená výroba,AV:Výrobní režie,AS:Správní režie,AZ:Zásobová režie);
*                 ITEMSELECTED(comboItemSelected)


* Info definition
  TYPE(Static) STYPE(2) SIZE(109.4,3) FPOS(0.3,20) RESIZE(y) 
    TYPE(Text) CAPTION(PSo)  CPOS(10,0) CLEN(5)
    TYPE(Text) CAPTION(OBRo) CPOS(30,0) CLEN(5)
    TYPE(Text) CAPTION(PSr)  CPOS(50,0) CLEN(5)
    TYPE(Text) CAPTION(OBRr) CPOS(70,0) CLEN(5)
    TYPE(Text) CAPTION(KSr)  CPOS(90,0) CLEN(5)

* 1
    TYPE(Text) CAPTION(Kè_md)            CPOS( 1,1) CLEN( 8)
    TYPE(Text) NAME(UCETKUM->nKCMDPSO)   CPOS(10,1) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCMDOBRO)  CPOS(30,1) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCMDPSR)   CPOS(50,1) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCMDOBRR)  CPOS(70,1) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCMDKSR)   CPOS(90,1) CLEN(13) BGND(13) CTYPE(2)
* 2
    TYPE(Text) CAPTION(Kè_dal)           CPOS( 1,2) CLEN( 8)
    TYPE(Text) NAME(UCETKUM->nKCDALPSO)  CPOS(10,2) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCDALOBRO) CPOS(30,2) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCDALPSR)  CPOS(50,2) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCDALOBRR) CPOS(70,2) CLEN(13) BGND(13) CTYPE(2)
    TYPE(Text) NAME(UCETKUM->nKCDALKSR)  CPOS(90,2) CLEN(13) BGND(13) CTYPE(2)
  TYPE(End)

* NS *
  TYPE(Static) STYPE(9) SIZE(109.4,1.7) FPOS(0.3,24) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL1)   CPOS( 3,  .4)                BGND(1) FONT(5)

    TYPE(Text) FCAPTION(Výrobek)         CPOS(19, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL2)   CPOS(19,  .4)                BGND(1) FONT(5)

    TYPE(Text) FCAPTION(Zakázka)         CPOS(35, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL3)   CPOS(35,  .4)                BGND(1) FONT(5)

    TYPE(Text) FCAPTION(Výrobní místo)   CPOS(51, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL4)   CPOS(51,  .4)                BGND(1) FONT(5)

    TYPE(Text) FCAPTION(Stroj)           CPOS(67, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL5)   CPOS(67,  .4)                BGND(1) FONT(5)

    TYPE(Text) FCAPTION(Výrobní operace) CPOS(83, -.3)          PP(3) BGND(1) 
    TYPE(Text) NAME(UCETKUM->cNAZPOL6)   CPOS(83,  .4)                BGND(1) FONT(5)
  TYPE(End)


