TYPE(drgForm) DTYPE(10) TITLE(Adresáø firem ...) SIZE(110,20.5) ;
              GUILOOK(Action:n)  ;
              POST(postValidate) 


  TYPE(Static) STYPE(12) FPOS(0.5,0.1) SIZE(109,4.7)  RESIZE(yn) CTYPE(3) 
    TYPE(GET) NAME(FIRMYw->NICO)          FPOS(10, .5) FLEN(11) FCAPTION(Ièo)        CPOS( 2, .5) FONT(5) CLEN(8)
    TYPE(GET) NAME(FIRMYw->CDIC)          FPOS(31, .5) FLEN(16) FCAPTION(Diè)        CPOS(25, .5) FONT(5)

    TYPE(Text) NAME(M->firmy_errAres)    CPOS( 50, .1)  SIZE(50,1.2) CTYPE(3) 

    TYPE(GET) NAME(FIRMYw->NCISFIRMY)     FPOS(10, 2) FLEN( 5) FCAPTION(Firma)       CPOS( 2, 2) PP(2) FONT(5) NOREVISION()
    TYPE(GET) NAME(FIRMYw->CNAZEV)        FPOS(17, 2) FLEN(30)
    TYPE(GET) NAME(FIRMYw->CNAZEV2)       FPOS(17, 3) FLEN(30)

    TYPE(GET) NAME(FIRMYw->DREGDPH_OD)    FPOS(72,1.5) FLEN(11) FCAPTION(REG_dph od)  CPOS(61,1.5) FONT(5) CLEN(11) PUSH(CLICKDATE)
    TYPE(GET) NAME(FIRMYw->DREGDPH_DO)    FPOS(89,1.5) FLEN(11) FCAPTION(do)          CPOS(85,1.5) FONT(5) CLEN( 3) PUSH(CLICKDATE)
    TYPE(GET) NAME(FIRMYw->NKLICOBL)      FPOS(72,2.5) FLEN(11) FCAPTION(Oblast)      CPOS(61,2.5) FONT(5) CLEN(10)
    TYPE(GET) NAME(FIRMYw->CCINNOST)      FPOS(72,3.5) FLEN(15) FCAPTION(Zamìøení)    CPOS(61,3.5)
  TYPE(End)


* 1 - ZÁKLADNÍ ÚDAJE
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET( 1,87) CAPTION(Základní údaje) PRE(tabSelect) RESIZE(yy)

    TYPE(Static) STYPE(2) FPOS(0.5,0.03) SIZE(108,13.8) RESIZE(yn) CTYPE(2)

    TYPE(GET) NAME(FIRMYw->CULICE)     FPOS(15, 1) FLEN(32) FCAPTION(Ulice)       CPOS(2,1)
    TYPE(GET) NAME(FIRMYw->CPSC)       FPOS(15, 2) FLEN( 8) FCAPTION(PSÈ)         CPOS(2,2)
    TYPE(GET) NAME(FIRMYw->CSIDLO)     FPOS(27, 2) FLEN(20)

    TYPE(GET) NAME(FIRMYw->CZKRATSTAT) FPOS(15, 3) FLEN( 8) FCAPTION(Stát)        CPOS(2,3)
      TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT) CPOS(27,3) CLEN(21) BGND(13)

    TYPE(GET) NAME(FIRMYw->CKRAJ)      FPOS(15, 5) FLEN(12) FCAPTION(Kraj)        CPOS(2,5)
    TYPE(GET) NAME(FIRMYw->COKRES)     FPOS(15, 6) FLEN(12) FCAPTION(Okres)       CPOS(2,6)

    TYPE(GET) NAME(FIRMYw->CTELEFON)   FPOS(72, 1) FLEN(17) FCAPTION(Telefon_1)   CPOS(61,1)
    TYPE(GET) NAME(FIRMYw->CTELEFON2)  FPOS(72, 2) FLEN(17) FCAPTION(Telefon_2)   CPOS(61,2)
    TYPE(GET) NAME(FIRMYw->CFAX)       FPOS(72, 3) FLEN(17) FCAPTION(FaxFirmy)    CPOS(61,3)
    TYPE(GET) NAME(FIRMYw->CMODEMBBS)  FPOS(72, 4) FLEN(17) FCAPTION(Modem/BBS)   CPOS(61,4)
    TYPE(GET) NAME(FIRMYw->CMOBILTEL)  FPOS(72, 5) FLEN(17) FCAPTION(Mobil/TEL)   CPOS(61,5)
    TYPE(GET) NAME(FIRMYw->CPOBOX)     FPOS(72, 6) FLEN(20) FCAPTION(POBox)       CPOS(61,6)

    TYPE(Static) STYPE(16) SIZE(107,1) FPOS(1,6.7)
    TYPE(GET) NAME(FIRMYw->CEMAILTEL)  FPOS(15, 8) FLEN(77) FCAPTION(E-mail/TEL)       CPOS( 2, 8)
    TYPE(GET) NAME(FIRMYw->CZASTUPCE)  FPOS(15, 9) FLEN(25) FCAPTION(Odpov_Zástupce)   CPOS( 2, 9) CLEN(13)
    TYPE(GET) NAME(FIRMYw->CZARAZENI)  FPOS(72, 9) FLEN(25) FCAPTION(ZaøZástup)        CPOS(61, 9)
    TYPE(GET) NAME(FIRMYw->CZASTOBCH)  FPOS(15,10) FLEN(25) FCAPTION(Obch_Zastupce)    CPOS( 2,10)
    TYPE(GET) NAME(FIRMYw->CVYPSAZDAN) FPOS(72,10) FLEN( 8) FCAPTION(VYPsazDAN)        CPOS(61,10)

    TYPE(Static) STYPE(16) SIZE(107,1) FPOS(1,10.7)
    TYPE(TEXT) CAPTION(Obchodní stav) CPOS(2,12)
    TYPE(CHECKBOX) NAME(firmyW->laktivni) FPOS(15,12) FLEN(15) VALUES(T:aktivní Firma,F:aktivní Firma) 

    TYPE(GET) NAME(FIRMYw->CVAT_ID)    FPOS(72,12) FLEN(16) FCAPTION(Daò_id_VAT)           CPOS(61,12)
    TYPE(GET) NAME(FIRMYw->CVAT_VIES)  FPOS(72,13) FLEN(16) FCAPTION(Daò_id_VIES)          CPOS(61,13) 
*    CLEN(13)
*    TYPE(GET) NAME(FIRMYw->nCisREG)    FPOS(72,13) FLEN(16) FCAPTION(Reg_èíslo plemenáøi) CPOS(58,13) CLEN(13)

  TYPE(End)

  TYPE(End)

* 2 - BANKOVNÍ ÚÈTY
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(13,75) CAPTION(Bankovní úèty) PRE(tabSelect)
    TYPE(DBrowse) FPOS(0,0.1) SIZE(108.8,6) FILE(FIRMYUCw) ;
                              FIELDS(M->is_Aktivni::2.4::2,CUCET:Èíslo úètu,CBANK_NAZ:Název banky,CBANK_TEL:telefon,cBANKODPO:odpovìdná Osoba:38) ;
                              CURSORMODE(3) PP(7) SCROLL(nn) GROUPS(2)

    TYPE(Static) STYPE(13) FPOS(0.5,6.5) SIZE(108,7.5) RESIZE(y) CTYPE(2)
      TYPE(GET)  NAME(FIRMYUCw->CUCET)      FPOS(13,0.7) FLEN(25) FCAPTION(Èíslo úètu)  CPOS( 1,0.7)
      TYPE(GET)  NAME(FIRMYUCw->czkratMenY) FPOS(45,0.7) FLEN( 6) FCAPTION(v)           CPOS(41,0.7)

      TYPE(GET)  NAME(FIRMYUCw->CIBAN)     FPOS(13,1.7) FLEN(25) FCAPTION(IBAN)         CPOS( 1,1.7)

      TYPE(GET)  NAME(FIRMYUCw->CBANK_NAZ) FPOS(13,2.7) FLEN(25) FCAPTION(u banky)      CPOS( 1,2.7)
      TYPE(GET)  NAME(FIRMYUCw->CBIC)      FPOS(45,2.7) FLEN(13) FCAPTION(BIC)          CPOS(40,2.7) CLEN(4)

      TYPE(GET)  NAME(FIRMYUCw->CBANK_ULI) FPOS(13,3.7) FLEN(25) FCAPTION(Adresa banky) CPOS( 1,3.7)
      TYPE(CHECKBOX) NAME(firmyucW->laktivni) FPOS(45,3.7) FLEN(16) VALUES(T:aktivní Úèet,F:aktivní Úèet) 
      TYPE(GET)  NAME(FIRMYUCw->CBANK_PSC) FPOS(13,4.7) FLEN( 8) 
      TYPE(GET)  NAME(FIRMYUCw->CBANK_SID) FPOS(25,4.7) FLEN(25) 

      TYPE(GET)  NAME(FIRMYUCw->CBANK_STA) FPOS(13,5.7) FLEN( 8) FCAPTION(Stát)         CPOS( 1,5.7)
      TYPE(TEXT) NAME(C_STATY->cNAZEVSTAT) CPOS(25,5.7) CLEN(26) BGND(13)

      TYPE(GET)  NAME(FIRMYUCw->CBANK_POB) FPOS(72,0.7) FLEN(25) FCAPTION(Poboèka)    CPOS(61,0.7)
      TYPE(GET)  NAME(FIRMYUCw->CBANK_TEL) FPOS(72,1.7) FLEN(17) FCAPTION(Telefon)    CPOS(61,1.7)
      TYPE(GET)  NAME(FIRMYUCw->CBANK_FAX) FPOS(72,2.7) FLEN(17) FCAPTION(Faxk)       CPOS(61,2.7)
      TYPE(GET)  NAME(FIRMYUCw->CBANKODPO) FPOS(72,3.7) FLEN(25) FCAPTION(Odp_Osoba)  CPOS(61,3.7)
      TYPE(GET)  NAME(FIRMYUCw->CSPECSYMB) FPOS(72,4.7) FLEN(20) FCAPTION(SSymbol)    CPOS(61,4.7)
      TYPE(GET)  NAME(FIRMYUCw->CUCET_UCT) FPOS(72,5.7) FLEN( 8) FCAPTION(SuAu_Ø)     CPOS(61,5.7)
      TYPE(TEXT) NAME(firmyucw->_newrec)   CPOS(0,0) CLEN(0)
    TYPE(End)
  TYPE(End)

* 3 - DODAVATEL - FINANÈNÍ ÚDAJE 
    TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(25,63) CAPTION(Dodavatel) PRE(tabSelect)
    TYPE(Static) STYPE(2) FPOS(0.5,0.03) SIZE(108,13.8) RESIZE(yn) CTYPE(2)
      TYPE(Static) STYPE(2) SIZE(107,1.25) FPOS(0.5,0.2) RESIZE(yx)
        TYPE(TEXT) CAPTION(DODAVATEL) CPOS( .5, .35) CLEN(105) FONT(7) CTYPE(3)
      TYPE(End)
* L
      TYPE(GET) NAME(FIRMYFIw->CUCT_DOD)   FPOS(17, 2.5) FLEN( 8) FCAPTION(Úèet SuAu_Ø)     CPOS( 2, 2.5)
      TYPE(GET) NAME(FIRMYFIw->CUCT_FPZ)   FPOS(17, 3.5) FLEN( 8) FCAPTION(Úèet zálFaktur)  CPOS( 2, 3.5)
      TYPE(GET) NAME(FIRMYFIw->CVARSYMD)   FPOS(17, 4.5) FLEN(20) FCAPTION(VSymbol)         CPOS( 2, 4.5)
      TYPE(GET) NAME(FIRMYFIw->CSPECSYMD)  FPOS(17, 5.5) FLEN(20) FCAPTION(SSymbol)         CPOS( 2, 5.5)
      TYPE(GET) NAME(FIRMYFIw->NKONSTSYMD) FPOS(17, 6.5) FLEN(10) FCAPTION(KSymbol)         CPOS( 2, 6.5)
      TYPE(GET) NAME(FIRMYFIw->CZKRTYPUHR) FPOS(17, 7.5) FLEN(10) FCAPTION(TypÚhrady)       CPOS( 2, 7.5)
      TYPE(GET) NAME(FIRMYFIw->NPEN_DOD)   FPOS(17, 8.5) FLEN(10) FCAPTION(Procento penále) CPOS( 2, 8.5)
      TYPE(GET) NAME(FIRMYFIw->NSPLATNDOD) FPOS(17, 9.5) FLEN(10) FCAPTION(Splatnost)       CPOS( 2, 9.5)
      TYPE(GET) NAME(FIRMYFIw->NSKNDNYDOD) FPOS(17,10.5) FLEN( 5) FCAPTION(Skonto dny)      CPOS( 2,10.5)
      TYPE(GET) NAME(FIRMYFIw->NSKNPRCDOD) FPOS(26,10.5) FLEN( 6) FCAPTION(%)               CPOS(33,10.5) CLEN(3)
      TYPE(GET) NAME(FIRMYFIw->NUVERDNY)   FPOS(17,11.5) FLEN( 5) FCAPTION(Možnost úvìru)   CPOS( 2,11.5)
      TYPE(GET) NAME(FIRMYFIw->NLIMZAV)    FPOS(17,12.5) FLEN(15) FCAPTION(Limit závazkù)   CPOS( 2,12.5)
* P
      TYPE(GET) NAME(FIRMYFIw->CZKRZPUDOP) FPOS(72, 2.5) FLEN(15) FCAPTION(Zpùsob dopravy)  CPOS(58, 2.5)  
    TYPE(End)

    TYPE(End)
* 4 - ODBÌRATEL - FINANNÈNÍ ÚDAJE 
    TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(37,51) CAPTION(Odbìratel) PRE(tabSelect)
    TYPE(Static) STYPE(2) FPOS(0.5,0.03) SIZE(108,13.8) RESIZE(yn) CTYPE(2)
      TYPE(Static) STYPE(2) SIZE(107,1.25) FPOS(0.5,0.2)  RESIZE(yx)
        TYPE(TEXT) CAPTION(ODBÌRATEL) CPOS( .5, .35) CLEN(105) FONT(7) CTYPE(3)
      TYPE(End)
* L
      TYPE(GET) NAME(FIRMYFIw->CUCT_ODB)   FPOS(17, 2.5) FLEN( 8) FCAPTION(Úèet SuAu_Ø)      CPOS( 2, 2.5)
      TYPE(GET) NAME(FIRMYFIw->CUCT_FVZ)   FPOS(17, 3.5) FLEN( 8) FCAPTION(Úèet zálFaktur)   CPOS( 2, 3.5)
      TYPE(GET) NAME(FIRMYFIw->CSPECSYMO)  FPOS(17, 4.5) FLEN(20) FCAPTION(VSymbol)          CPOS( 2, 4.5)
      TYPE(GET) NAME(FIRMYFIw->CSPECSYMOD) FPOS(17, 5.5) FLEN(20) FCAPTION(SSymbol)          CPOS( 2, 5.5)
      TYPE(GET) NAME(FIRMYFIw->NKONSTSYMB) FPOS(17, 6.5) FLEN(10) FCAPTION(KSymbol)          CPOS( 2, 6.5)
      TYPE(GET) NAME(FIRMYFIw->CZKRTYPUOD) FPOS(17, 7.5) FLEN(10) FCAPTION(TypÚhrady)        CPOS( 2, 7.5)
      TYPE(GET) NAME(FIRMYFIw->NPEN_ODB)   FPOS(17, 8.5) FLEN(10) FCAPTION(Procento penále)  CPOS( 2, 8.5)
      TYPE(GET) NAME(FIRMYFIw->NSPLATNOST) FPOS(17, 9.5) FLEN(10) FCAPTION(Splatnost)        CPOS( 2, 9.5)
      TYPE(GET) NAME(FIRMYFIw->NSKNDNYODB) FPOS(17,10.5) FLEN( 5) FCAPTION(Skonto dny)       CPOS( 2,10.5)
      TYPE(GET) NAME(FIRMYFIw->NSKNPRCODB) FPOS(26,10.5) FLEN( 6) FCAPTION(%)                CPOS(33,10.5) CLEN(3)
      TYPE(GET) NAME(FIRMYFIw->NUVERDNYOD) FPOS(17,11.5) FLEN( 5) FCAPTION(Možnost úvìru)    CPOS( 2,11.5)
      TYPE(GET) NAME(FIRMYFIw->NLIMPOH)    FPOS(17,12.5) FLEN(15) FCAPTION(Limit pohledávek) CPOS( 2,12.5)
* 
      TYPE(GET) NAME(FIRMYFIw->CZKRZPUDOD) FPOS(72,2.5)  FLEN(15) FCAPTION(Zpùsob dopravy)   CPOS(58,2.5)
      TYPE(GET) NAME(FIRMYFIw->cZKRPRODEJ) FPOS(72,3.5)  FLEN( 8) FCAPTION(Prodejce)         CPOS(58,3.5)
        TYPE(TEXT) NAME(c_prodej->cnazprodej) CPOS(82,3.5) BGND(9) CLEN(25)

      TYPE(GET) NAME(FIRMYFIw->cpracDoba1) FPOS(72,4.5)  FLEN(34) FCAPTION(Pracovní doba OD) CPOS(58,4.5) CLEN(14)
      TYPE(GET) NAME(FIRMYFIw->cpracDoba2) FPOS(72,5.5)  FLEN(34) FCAPTION(Pracovní doba OD) CPOS(58,5.5) CLEN(14)
      TYPE(GET) NAME(FIRMYFIw->cPrijemce1) FPOS(72,6.5)  FLEN(34) FCAPTION(Pøíjemce 1)       CPOS(58,6.5) CLEN(14)

      TYPE(STATIC) STYPE(14) SIZE(49,5) FPOS(58,9) CTYPE(2) RESIZE(xx)
        TYPE(GET)  NAME(FIRMYFIw->cBank_UcOD) FPOS(14, .5) FLEN(25) FCAPTION(Úèet pro úhradu) CPOS( 1, .5) CLEN(13) 
          TYPE(TEXT) CAPTION( v  )                                                            CPOS(41, .5) CLEN( 2)
          TYPE(TEXT) NAME(c_bankuc->czkratMeny)                                               CPOS(43, .5) CLEN( 5) FONT(2)
          TYPE(TEXT) CAPTION([)                                                               CPOS(14,1.5) CLEN( 2)   
          TYPE(TEXT) NAME(c_bankuc->cbank_naz)                                                CPOS(15,1.5) CLEN(25) FONT(2)
          TYPE(TEXT) CAPTION(])                                                               CPOS(41,1.5) CLEN( 2)   

        TYPE(Static) STYPE(16) SIZE(48.8,1) FPOS(.1,2.2)

*        TYPE(GET)  NAME(FIRMYFIw->CZKRmenyOD) FPOS(14,3.5) FLEN( 7) FCAPTION(Mìna pro úhradu) CPOS( 1,3.5) CLEN(13)
*          TYPE(TEXT) NAME(c_meny->cnazMeny)                                                   CPOS(23,3.5) CLEN(25) FONT(2)
      TYPE(END) 

*      TYPE(GET) NAME(FIRMYFIw->cZACPRACDO) FPOS(72,3.5)  FLEN( 8) FCAPTION(Pracovní doba OD) CPOS(58,3.5) CLEN(14)
*      TYPE(GET) NAME(FIRMYFIw->cKONPRACDO) FPOS(88,3.5)  FLEN( 8) FCAPTION(DO)               CPOS(83,3.5) CLEN( 4)

*      TYPE(GET) NAME(FIRMYFIw->cZACPRACD1) FPOS(72,4.5)  FLEN( 8) FCAPTION(Pracovní doba OD) CPOS(58,4.5) CLEN(14)
*      TYPE(GET) NAME(FIRMYFIw->cKONPRACD1) FPOS(88,4.5)  FLEN( 8) FCAPTION(DO)               CPOS(83,4.5) CLEN( 4)
    TYPE(End)
    TYPE(End)


* 5 - PODROZVAHOVÉ ÚÈTY 
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(49,39) CAPTION(Podr_úèty) PRE(tabSelect)
    TYPE(DBrowse) FPOS(0.2,0.2) SIZE(40.2,14) FILE(C_PODRUCw) ;
                                FIELDS(c_meny->cNAZMENY:název Mìny:33, ;
                                       CZKRATMENY:zkr:6                ) ;
                                CURSORMODE(3) PP(7) SCROLL(nn) GROUPS(5)  RESIZE(ny)

    TYPE(Static) FPOS(42,.5) SIZE(66,13.7) STYPE(13) RESIZE(yn)
      TYPE(TEXT) CAPTION(PODROZVAHOVÉ ÚÈTY) CPOS( 5,.5) CLEN(30) FONT(5)

      TYPE(TEXT) CAPTION(závazky) CPOS( 5,2) CLEN(8)
      TYPE(Static) STYPE(17) SIZE(64,1) FPOS( 1,1.8)

      TYPE(GET) NAME(C_PODRUCw->CUCTZ_PUH)  FPOS(15,3.3) FLEN(8) FCAPTION(hlavní) CPOS( 5,3.5)
        TYPE(Static) STYPE(17) SIZE( 9,1) FPOS( 5,4.2)
        TYPE(GET) NAME(C_PODRUCw->CUCTZ_PUHS) FPOS(15,4.3) FLEN(8)
      TYPE(GET) NAME(C_PODRUCw->CUCTZ_PUZ)  FPOS(15,5.3) FLEN(8) FCAPTION(zálohový) CPOS( 5,5.5)
        TYPE(Static) STYPE(17) SIZE( 9,1) FPOS( 5,6.2)
        TYPE(GET) NAME(C_PODRUCw->CUCTZ_PUZS) FPOS(15,6.3) FLEN(8)

      TYPE(TEXT) CAPTION(pohledávky) CPOS( 5,8) CLEN(10)
      TYPE(Static) STYPE(17) SIZE(64,1) FPOS( 1,7.8)

      TYPE(GET) NAME(C_PODRUCw->CUCTP_PUH)  FPOS(15,9.3) FLEN(8) FCAPTION(hlavní) CPOS( 5,9.5)
        TYPE(Static) STYPE(17) SIZE( 9,1) FPOS( 5,10)
        TYPE(GET) NAME(C_PODRUCw->CUCTP_PUHS) FPOS(15,10.3) FLEN(8)
      TYPE(GET) NAME(C_PODRUCw->CUCTP_PUZ)  FPOS(15,11.3) FLEN(8) FCAPTION(zálohový) CPOS( 5,11.5)
        TYPE(Static) STYPE(17) SIZE( 9,1) FPOS( 5,12)
        TYPE(GET) NAME(C_PODRUCw->CUCTP_PUZS) FPOS(15,12.3) FLEN(8)
    TYPE(End)
  TYPE(End)


* 6 - SKUPINY
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(61,27) CAPTION(Skupiny) PRE(tabSelect) SUBTABS(FAA,DOA,DOP,ODB,DOD,KOA)

    TYPE(Static) FPOS(0.3,-0.2) SIZE(32,1.2) STYPE(2) RESIZE(xn)
      TYPE(TEXT)     CAPTION(skupina) CPOS( .6, 0.5) CLEN(31) FONT(5) BGND(12) GROUPS(TEXT-6)
    TYPE(END) 

    TYPE(DBrowse) FPOS(.2,1.6) SIZE(32,12.8) FILE(firmySKw) ;
                                             FIELDS(M->setSkup:_:2.6::2          , ;
                                                   czkr_skup:skup:5             , ;
                                                   M->cnaz_Skup:název skupiny:25  ) ;
                                             CURSORMODE(3) PP(7) ITEMMARKED(itemMarked) SCROLL(nn) GROUPS(6) RESIZE(ny)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(~Fakt_Adresa) OFFSET( 1,83) PRE(tabSelect) SUB(FAA) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(D~od_Adresy)  OFFSET(16,68) PRE(tabSelect) SUB(DOA) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(Do~pravci)    OFFSET(31,53) PRE(tabSelect) SUB(DOP) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(Od~bìratelé)  OFFSET(46,38) PRE(tabSelect) SUB(ODB) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(Dod~avatelé)  OFFSET(61,23) PRE(tabSelect) SUB(DOD) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)

    TYPE(TabPage) FPOS(32.9,1.2) SIZE(75,1.2) CAPTION(~Kor_Adresa)  OFFSET(76, 8) PRE(tabSelect) SUB(KOA) RESIZE(yn)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(END)
   
    TYPE(EBrowse) FPOS(32.8,1.3) SIZE(75.2,12.8) FILE(firmyVAw)                                         ;
                                                 CURSORMODE(3) INDEXORD(3) PP(7) LFREEZE(1) RESIZE(yy)  ;
                                                 PRE(SetFocus) POPUPMENU(n) SCROLL(yn) GROUPS(60)
      
      TYPE(GET)      NAME(firmyvaw->ncisfirVA)  FLEN( 9)          CAPTION(firma)         PUSH(fir_firmy_sel) NOREVISION()
      TYPE(TEXT)     NAME(M->nazev_vaw)         CLEN(20)          CAPTION(název firmy)
      TYPE(TEXT)     NAME(M->ico_vaw)           CLEN( 8)          CAPTION(ièo)
      TYPE(TEXT)     NAME(M->dic_vaw)           CLEN(16)          CAPTION(diè)
      TYPE(TEXT)     NAME(M->psc_vaw)           CLEN( 6)          CAPTION(psè)
      TYPE(TEXT)     NAME(M->sidlo_vaw)         CLEN(20)          CAPTION(sídloFirmy)
      TYPE(TEXT)     NAME(M->ulice_vaw)         CLEN(20)          CAPTION(ulice)
    TYPE(END) 
  TYPE(End)

* 7 - dolpòující údaje seskupení z nìkterých záložek
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(73,15) CAPTION(Doplòující) PRE(tabSelect)
    TYPE(Static) FPOS(1,.3) SIZE(107,13.7) STYPE(13) RESIZE(yn)
      TYPE(GET) NAME(FIRMYw->nCisREG)        FPOS(18,0.5) FLEN(16) FCAPTION(Reg_èíslo plemenáøi) CPOS(1,0.5) CLEN(15)
      TYPE(GET) NAME(FIRMYw->cIdKoduPoj)     FPOS(18,1.5) FLEN(16) FCAPTION(Id.kód pojišovny)   CPOS(1,1.5) CLEN(15)
      TYPE(GET) NAME(FIRMYw->nZdrPojis)      FPOS(18,2.5) FLEN(16) FCAPTION(Kód zdr.pojišovny)  CPOS(1,2.5) CLEN(15)


    TYPE(END)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(END)


* 9 - POZNÁMKY 
  TYPE(TabPage) FPOS(0.5,4.8) SIZE(109,15.5) TTYPE(3) OFFSET(85,3) CAPTION(Poznámky) PRE(tabSelect)
    TYPE(MLE) FPOS(.2,.2) NAME(FIRMYw->MPOZNAMKA) SIZE(108.6,14)
  TYPE(End)