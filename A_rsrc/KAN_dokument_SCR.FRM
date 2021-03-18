TYPE(drgForm) SIZE(100,25) DTYPE(10) TITLE(Seznam dokumentù v evidenci ...) ;
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar)        ;
              CARGO(SYS_dokument_IN)

  TYPE(DBrowse) FPOS(0,0) SIZE(99,10.2) FILE(Dokument)                ;
                                        FIELDS( existFile()::2.6::2 , ;
                                                cIDdokum            , ;
                                                cZkrDokum           , ;
                                                cNazDokum           , ;
                                                cSoubor             , ;
                                                mAdresar            , ;
                                                mPoznamka             ) ;
                                        CURSORMODE(3) INDEXORD(1) SCROLL(yy) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)


  TYPE(Static) STYPE(12) CAPTION(Info k dokumentu) FPOS(1,10.5) SIZE(98,7.2) CTYPE(2)
    TYPE(Text) CAPTION(Info k dokumentu)            CPOS( 1, .1)  CLEN(25) FONT(5)

    TYPE(Text) CAPTION(ID dokumentu)          CPOS( 1,  1.2)  CLEN(15) 
      TYPE(Text) NAME(DOKUMENT->cIDdokum)      CPOS(16, 1.2)  CLEN(30) BGND(13) PP(2)
    TYPE(Text) CAPTION(ZkrDokumentu)          CPOS( 1,  2.3)  CLEN(15) 
      TYPE(Text) NAME(DOKUMENT->cZkrDokum)     CPOS(16, 2.3)  CLEN(30) BGND(13) PP(2)
*    TYPE(Text) CAPTION(TypProhlížeèe)         CPOS( 1,  3.4)  CLEN(15) 
      TYPE(Text) NAME(DOKUMENT->cTypEDIT)      CPOS(48, 2.3)  CLEN(28) BGND(13) PP(2)
    TYPE(Text) CAPTION(NazDokumentu)          CPOS( 1,  4.0)  CLEN(15) 
      TYPE(Text) NAME(DOKUMENT->cNazDokum)     CPOS(16, 4.0)  CLEN(60) BGND(13) PP(2)
    TYPE(Text) CAPTION(Pøipojený soubor)      CPOS( 1, 5.6)   CLEN(15) 
      TYPE(Text) NAME(DOKUMENT->cSoubor)       CPOS(16, 5.6)  CLEN(80) BGND(13) PP(2)
    
  TYPE(End)


* 1 - základní údaje OSOBY
*  TYPE(Static) STYPE(12) CAPTION(Info k dokumentu) FPOS(1,10.5) SIZE(98,7.2) CTYPE(2)
*    TYPE(Text) CAPTION(Adresa)            CPOS( 1,  .1)  CLEN(15) FONT(5)
*    TYPE(Text) CAPTION(ulice)             CPOS( 3, 1.2)  CLEN(12)
*    TYPE(Text) NAME(OSOBY->cUlicCiPop)    CPOS(17, 1.2)  CLEN(30) BGND(13) PP(2)
*    TYPE(Text) CAPTION(mìsto)             CPOS( 3, 2.3)  CLEN(12)
*    TYPE(Text) NAME(OSOBY->CMISTO)        CPOS(17, 2.3)  CLEN(30) BGND(13) PP(2)
*    TYPE(Text) CAPTION(psè)               CPOS( 3, 3.4)  CLEN(12)
*    TYPE(Text) NAME(OSOBY->CPSC)          CPOS(17, 3.4)  CLEN( 6) BGND(13) PP(2)
*    TYPE(Text) NAME(C_PSC->CMISTO)        CPOS(24, 3.4)  CLEN(23) BGND(13)
*    TYPE(Text) CAPTION(stát)              CPOS( 3, 4.5)  CLEN(12)
*    TYPE(Text) NAME(OSOBY->CZKRATSTAT)    CPOS(17, 4.5)  CLEN( 6) BGND(13) PP(2)
*    TYPE(Text) NAME(C_STATY->cNAZEVSTAT)  CPOS(24, 4.5)  CLEN(23) BGND(13)
*
*    TYPE(TEXT) NAME(osoby->cjmenoRozl)    CPOS(50, 1.1)  CLEN(45) BGND( 8) CTYPE(2) FONT(5) 
*  TYPE(End)

  TYPE(DBrowse)  FPOS(0,18.0) SIZE(99,7)  FILE(vazDokum)                                                ;
                                        FIELDS(M->is_inPersonal:per:2.6::2                          , ;
                                               M->is_inMsPrc_mo:zam:2.6::2                          , ;
                                               vazDokum_osoby('ncisOsoby'):èíslOsoby                , ;
                                               vazDokum_osoby('nosCisPrac'):èísloPrac               , ;
                                               vazDokum_osoby('cjmenoRozl'):Pøímení a jméno osoby:35, ;
                                               vazDokum_osoby('CMISTO'):Mìsto:25                    , ;
                                               vazDokum_osoby('CZKRATSTAT'):Stát                    , ;
                                               vazDokum_osoby('CTELEFON'):Telefon:15                , ;
                                               vazDokum_osoby('CEMAIL'):Email:30                      ) ;
                                        CURSORMODE(3) INDEXORD(9) PP(7) RESIZE(x) SCROLL(yy) PRE(SetFocus) 





