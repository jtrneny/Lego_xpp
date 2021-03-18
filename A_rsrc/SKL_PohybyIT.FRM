TYPE(drgForm) DTYPE(10) TITLE(Položka dokladu ...) SIZE(105, 18) FILE( PVPITEMww) ;
               GUILOOK(Action:y,Message:n,IconBar:y:MyIconBar,Menu:n) ;
               PRE(PREVALIDATE)  POST(POSTVALIDATE)

*TYPE(Action) CAPTION( ~Terminál) EVENT() TIPTEXT(Data z terminálu ) ICON1(427) ICON1(427)  ATYPE(2)
*TYPE(Action) CAPTION( ~Terminál) EVENT() TIPTEXT(Data z terminálu ) ICON1(428) ICON1(428)  ATYPE(2)
*TYPE(Action) CAPTION( CTRL+S Uložit)     EVENT()     TIPTEXT(zaúètování dokladu )
*TYPE(Action) CAPTION( F2 Uložit+INS)     EVENT()     TIPTEXT(zaúètování dokladu )


TYPE(Static) STYPE(12) SIZE(104.8, 17.8) FPOS(0.1,0.1) RESIZE(yn) CTYPE(2)

* Údaje z HLA
  TYPE(Static) STYPE(12) SIZE(104.6,2.9) FPOS(0.2,0.0) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Doklad)             CPOS( 2, 0.3) CLEN( 10)
    TYPE(GET ) NAME(PVPHEADw->nDoklad)     FPOS( 2, 1.3) FLEN( 12) BGND(13) FONT(5)  GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Sklad)              CPOS(18, 0.3) CLEN( 10)
    TYPE(GET ) NAME(PVPHEADw->cCisSklad)   FPOS(18, 1.3) FLEN( 15) BGND(13) FONT(5) PP(2) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Pohyb)              CPOS(36, 0.3) CLEN( 10)
    TYPE(GET ) NAME(PVPHEADw->cTypPohybu)  FPOS(36, 1.3) FLEN( 15) BGND(13) FONT(5) PP(2) GROUPS(clrYELLOW)

    TYPE(Static) STYPE(2) SIZE( 31.5, 2) FPOS( 72, 0.0) RESIZE(nx)
      TYPE(Text) NAME(M->Naz_PolDoklad)    CPOS( 3, 0.5) CLEN( 25) FONT(4) CTYPE(3) RESIZE(xy)
    TYPE(End)
  TYPE(End)

  TYPE(Static) STYPE(12) SIZE(104, 14.8) FPOS(0.5, 3) RESIZE(yx) CTYPE(2)

*   Výbìr z ceníku
    TYPE(Static) STYPE(1) SIZE(103, 2.4) FPOS( .2, .2)  RESIZE(yx)
      TYPE(Text) CAPTION(Poøadí)   CPOS(  2, 0.2) CLEN(  8)
      TYPE(GET ) NAME(nOrdItem)    FPOS(  2, 1.2) FLEN(  5) BGND(13) PP(2)

      TYPE(GET)  NAME( cSklPol)    FPOS( 10, 1.2) FLEN( 20) FCAPTION( Skl. položka) CPOS( 10,0.2) PP(2) PUSH(SKL_CENZBOZ_SEL)
      TYPE(GET ) NAME( cNazZbo)    FPOS( 32, 1.2) FLEN( 30) FCAPTION( Název zboží)  CPOS( 32,0.2)

*   Výbìr z objednávky vystavené - objVysit nkarta.ccrd 110 116 117 
*
       TYPE(Text) CAPTION(èísloObj_vystavené)  CPOS( 65,0.2) CLEN( 17)                                 GROUPS(0100,0106,1107)
       TYPE(GET)  NAME( cCisObj)               FPOS( 65,1.2) FLEN( 17)                                 GROUPS(0100,0106,1107) PUSH(SKL_OBJVYSIT_SEL)
       TYPE(Text) CAPTION(doklad)              CPOS( 85,0.2) CLEN(  8)                                 GROUPS(0100,0106,1107)           
       TYPE(Text) NAME( nCisloObjV)            CPOS( 85,1.2) CLEN( 10) BGND(13) CTYPE(2)               GROUPS(0100,0106,1107)
       TYPE(Text) CAPTION(pol)                 CPOS( 96,0.2) CLEN(  8)                                 GROUPS(0100,0106,1107)
       TYPE(Text) NAME( nIntCount)             CPOS( 96,1.2) CLEN(  4) BGND(13) CTYPE(2) PICTURE(9999) GROUPS(0100,0106,1107)
    
*   Výbìr z objednávky pøijaté   - objItem  nkarta.ccrd 253 255 305.
*
      TYPE(GET)  NAME(cCislObInt)            FPOS( 65, 1.2) FLEN( 30)  GROUPS(0503,8051) PUSH(SKL_OBJITEM_SEL)
      TYPE(Text) CAPTION(èísloObj_pøijaté)   CPOS( 65,  .2) CLEN( 20)  GROUPS(0503,8051)
      TYPE(Text) CAPTION(Pol.)               CPOS( 97,  .2) CLEN(  5)  GROUPS(0503,8051)
      TYPE(GET)  NAME(nCislPolOb)            FPOS( 97, 1.2) FLEN(  5)  GROUPS(0503,8051)

*   Výbìr na zakázku - žádanky/ materiál - objItem nkarta.ccrd 274
*
      TYPE(GET)  NAME(cCislObInt)            FPOS( 65, 1.2) FLEN( 30)  GROUPS(0704) PUSH(SKL_OBJITEM_SEL)
      TYPE(Text) CAPTION( Výrobní zakázka)   CPOS( 65,  .2) CLEN( 20)  GROUPS(0704)
      TYPE(Text) CAPTION(Pol.)               CPOS( 97,  .2) CLEN(  5)  GROUPS(0704)
      TYPE(GET)  NAME(nCislPolOb)            FPOS( 97, 1.2) FLEN(  5)  GROUPS(0704)

*   Výdej - storno                       - pvpHead/ pvpItem nkarta.ccrd 299.
*
      TYPE(GET ) NAME(nDoklad_o)            FPOS( 65, 1.2) FLEN( 12) FCAPTION(Výdejka_org) CPOS(65, .2) PP(2) GROUPS(0909) PUSH(SKL_Vydejky)
      TYPE(GET ) NAME(nOrdItem_o)           FPOS( 97, 1.2) FLEN( 12) FCAPTION(Poø.org)     CPOS(97, .2) PP(2) GROUPS(0909)

*   Pøecenìní                                              nkarta.ccrd 400
*
      TYPE(Text) CAPTION(Mn. skladové)     CPOS( 65,  .2) CLEN( 15)                             GROUPS(0051,0400)
      TYPE(Text) NAME(CENZBOZ->nMnozsZBO)  CPOS( 65, 1.2) CLEN( 15)  BGND( 13) PP(1) CTYPE(2)   GROUPS(0051,0400)
      TYPE(Text) CAPTION(Úè.sk.)           CPOS( 97,  .2) CLEN(  7)                             GROUPS(0051)
      TYPE(Text) NAME(CENZBOZ->nUcetSkup)  CPOS( 97, 1.2) CLEN(  7)  BGND( 13) PP(1) CTYPE(2)   GROUPS(0051)

    TYPE(END)


****
*   Karta POL 0000
*   nkarta.ccrd 100 110 120 130.0000

    TYPE(Static) STYPE(13) SIZE(104.4, 10) FPOS(0.2, 2.7)  RESIZE(yx)         GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(GET)  NAME( cKatcZBO)      FPOS(  2,1.2) FLEN( 15) FCAPTION( Katalogové è.)     CPOS(  2,0.2) GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(GET)  NAME( nCenaDokl1)    FPOS( 19,1.2) FLEN( 13) FCAPTION( Skl.cena/MJ dokl.) CPOS( 19,0.2) GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(GET)  NAME( nMnozDokl1)    FPOS( 34,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )     CPOS( 34,0.2) GROUPS(0000,0100,010A,2100,2200,0300) POST( MnPrijate)
      TYPE(GET)  NAME( cMjDokl1)      FPOS( 49,1.2) FLEN( 10) FCAPTION( MJ dokl.     )     CPOS( 49,0.2) GROUPS(0000,0100,010A,2100,2200,0300)

      TYPE(Text) CAPTION(Cena celkem) CPOS( 62,0.2) CLEN( 13)   GROUPS(0000,0100,010A,2100,2200,0300)
*      TYPE(Text) NAME( nCenaCelk )    CPOS( 62,1.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0000,0100,010A,2100,2200,0300, clrGREY)
      TYPE(GET)  NAME( nCenaCelk )    FPOS( 62,1.2) FLEN( 13) CTYPE(2) BGND(13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0000,0100,010A,2100,2200,0300, clrGREY)

      TYPE(GET)  NAME( nCenNapDod)         FPOS( 19,3.2) FLEN( 13) FCAPTION( Skl.cena/MJ zákl.) CPOS( 19,2.2) GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(GET)  NAME( nMnozPrDod)         FPOS( 34,3.2) FLEN( 13) FCAPTION( Mn. pøijaté  )     CPOS( 34,2.2) GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(Text) CAPTION(MJ zákl.)         CPOS( 49,2.2) CLEN( 13)                   GROUPS(0000,0100,010A,2100,2200,0300)
      TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 49,3.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0000,0100,010A,2100,2200,0300, clrGREY)
    TYPE(END)

*   Karta POL 1
*   nkarta.ccrd 111

    TYPE(Static) STYPE(13) SIZE(104.4, 10) FPOS(0.2, 2.7)  RESIZE(yx)         GROUPS(0101)
**      TYPE(GET)  NAME(PVPITEM->cSklPol) FPOS( 1,1.2) FLEN( 18) FCAPTION( Skl. položka)  CPOS( 1,0.2)  GROUPS(0101)
       TYPE(Text) CAPTION(Karta 1)      CPOS( 1,2.2) CLEN( 6)  GROUPS(0101)
    TYPE(END)

*   Karta POL 2
*   nkarta.ccrd 102 142  ..  4302 neexistuje

    TYPE(Static) STYPE(13) SIZE(104.4, 10) FPOS(0.2, 2.7)  RESIZE(yx)   GROUPS(0A02,4102,4202,4302 )
*       TYPE(GET)  NAME( nCenNapDod)    FPOS(  1,1.2) FLEN( 13) FCAPTION( Skladová cena)  CPOS(  1,0.2) GROUPS(0A02,4102,4202,4302)
*       TYPE(GET)  NAME( nMnozPrDod)    FPOS( 16,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )  CPOS( 16,0.2) GROUPS(0A02,4102,4202,4302) POST( MnPrijate)
*       TYPE(Text) CAPTION(Cena celkem) CPOS( 31,0.2) CLEN( 13) GROUPS(0A02,4102,4202,4302)
*       TYPE(GET)  NAME( nCenaCelk )    FPOS( 31,1.2) FLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0A02,4102,4202,4302)

      TYPE(GET)  NAME( nCenaDokl1)    FPOS( 19,1.2) FLEN( 13) FCAPTION( Skl.cena/MJ dokl.) CPOS( 19,0.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET)  NAME( nMnozDokl1)    FPOS( 34,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )     CPOS( 34,0.2) GROUPS(0A02,4102,4202,4302) POST( MnPrijate)
      TYPE(GET)  NAME( cMjDokl1)      FPOS( 49,1.2) FLEN( 10) FCAPTION( MJ dokl.     )     CPOS( 49,0.2) GROUPS(0A02,4102,4202,4302)

      TYPE(Text) CAPTION(Cena celkem) CPOS( 62,0.2) CLEN( 13)   GROUPS(0A02,4102,4202,4302)
      TYPE(GET)  NAME( nCenaCelk )    FPOS( 62,1.2) FLEN( 13) CTYPE(2) BGND(13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(0A02,4102,4202,4302, clrGREY)

      TYPE(GET)  NAME( nCenNapDod)         FPOS( 19,3.2) FLEN( 13) FCAPTION( Skl.cena/MJ zákl.) CPOS( 19,2.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET)  NAME( nMnozPrDod)         FPOS( 34,3.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 34,2.2) GROUPS(0A02,4102,4202,4302)
      TYPE(Text) CAPTION(MJ zákl.)         CPOS( 49,2.2) CLEN( 13)                   GROUPS(0A02,4102,4202,4302)
      TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 49,3.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0A02,4102,4202,4302, clrGREY)

      TYPE(GET) NAME( cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME( cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME( cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME( cNazPol4)    FPOS( 49,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME( cNazPol5)    FPOS( 65,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0A02,4102,4202,4302)
      TYPE(GET) NAME( cNazPol6)    FPOS( 81,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0A02,4102,4202,4302) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 12
*   nkarta.ccrd 103 104

    TYPE(Static) STYPE(13) SIZE(104.4, 10) FPOS(0.2, 2.7)  RESIZE(yx)         GROUPS(1012)
       TYPE(GET)  NAME( nCenNapDod)    FPOS(  1,1.2) FLEN( 13) FCAPTION( Vnitrocena)  CPOS(  1,0.2) GROUPS(1012)
       TYPE(GET)  NAME( nMnozPrDod)    FPOS( 16,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  )  CPOS( 16,0.2) GROUPS(1012) POST( MnPrijate)
       TYPE(Text) CAPTION(Cena celkem) CPOS( 31,0.2) CLEN( 13)   GROUPS(1012)
       TYPE(GET) NAME( nCenaCelk )     FPOS( 31,1.2) FLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE( @N 99 999 999.99) GROUPS(1012)

      TYPE(Text) CAPTION( Nákladová struktura :) CPOS(  3, 6.2)   CLEN( 22) FONT(7)           GROUPS(1012)
      TYPE(GET) NAME( cNazPol1)    FPOS( 25,6.2)  FLEN( 10) FCAPTION(Stredisko)  CPOS(25,5.2) GROUPS(1012)
      TYPE(GET) NAME( cNazPol2)    FPOS( 37,6.2)  FLEN( 10) FCAPTION(Výkon)      CPOS(37,5.2) GROUPS(1012)
      TYPE(GET) NAME( cNazPol3)    FPOS( 49,6.2)  FLEN( 10) FCAPTION(Zakázka)    CPOS(49,5.2) GROUPS(1012)
      TYPE(GET) NAME( cNazPol4)    FPOS( 61,6.2)  FLEN( 10) FCAPTION(Výr.místo)  CPOS(61,5.2) GROUPS(1012)
      TYPE(GET) NAME( cNazPol5)    FPOS( 73,6.2)  FLEN( 10) FCAPTION(Stroj)      CPOS(73,5.2) GROUPS(1012)
      TYPE(GET) NAME( cNazPol6)    FPOS( 85,6.2)  FLEN( 10) FCAPTION(Výr.operace)CPOS(85,5.2) GROUPS(1012) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 6
*   nkarta.ccrd 116 

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(0106)
      TYPE(GET)  NAME( nCenaPZBO)        FPOS(  1,1.2) FLEN( 13) FCAPTION( PC bez Dph)  CPOS(  1,0.2) GROUPS(0106)
      TYPE(GET)  NAME( nCenaPDZBO)       FPOS( 18,1.2) FLEN( 13) FCAPTION( PC s Dph)    CPOS( 18,0.2) GROUPS(0106)
      TYPE(GET)  NAME(M->nMarzRabat)     FPOS( 35,1.2) FLEN(  8) FCAPTION( Sleva v %)   CPOS( 35,0.2) GROUPS(0106)
      TYPE(TEXT) CAPTION(Skladová cena)  CPOS( 47,0.2) CLEN( 13) GROUPS(0106)
      TYPE(GET)  NAME( nCenNapDod)       FPOS( 47,1.2) FLEN( 13) GROUPS(0106)
      TYPE(GET)  NAME( nMnozPrDod)       FPOS( 64,1.2) FLEN( 13) FCAPTION( Mn.pøijaté)  CPOS( 64,0.2) GROUPS(0106) POST( MnPrijate)
      TYPE(TEXT) CAPTION(Cena celkem)    CPOS( 80,0.2) CLEN( 13) GROUPS(0106)
      TYPE(TEXT) NAME( nCenaCelk)        CPOS( 80,1.2) CLEN( 13) CTYPE(2) BGND( 13) GROUPS(0106)
    TYPE(END)

*   Karta POL 7 - Pøíjem v zahr. mìnì
*   nkarta.ccrd 117

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(1107)
       TYPE(GET)  NAME( cKatcZBO)           FPOS(  1,1.2) FLEN( 15) FCAPTION( Katalogové è.) CPOS(  1,0.2) GROUPS(1107)
       TYPE(GET)  NAME( nCenNaDoZM)         FPOS( 18,1.2) FLEN( 13) FCAPTION( Skl.cena/MJ zahr.) CPOS( 18,0.2) GROUPS(1107)
       TYPE(TEXT) NAME(PVPHeadw->cZahrMena) CPOS( 33,1.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME(nMnozDokl1)          FPOS( 44,1.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 44,0.2) GROUPS(1107) POST( MnPrijate)
       TYPE(GET)  NAME(cMjDokl1)            FPOS( 59,1.2) FLEN( 10) FCAPTION( MJ dokl.     ) CPOS( 59,0.2) GROUPS(1107)

       TYPE(Text) CAPTION(Cena celkem)      CPOS( 71,0.2) CLEN( 13)   GROUPS(1107)
       TYPE(Text) NAME( nCenCelkZM)         CPOS( 71,1.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) FONT(5) PICTURE( @N 99 999 999.99) GROUPS(1107)
       TYPE(TEXT) NAME(PVPHeadw->cZahrMena) CPOS( 85,1.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME( nCenNapDod)         FPOS( 18,3.2) FLEN( 13) FCAPTION( Skl.cena/MJ zákl.) CPOS( 18,2.2) GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratMeny) CPOS( 33,3.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)

       TYPE(GET)  NAME( nMnozPrDod)         FPOS( 44,3.2) FLEN( 13) FCAPTION( Mn. pøijaté  ) CPOS( 44,2.2) GROUPS(1107)
       TYPE(Text) CAPTION(MJ zákl.)         CPOS( 59,2.2) CLEN( 10)                   GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 59,3.2) CLEN(  5) CTYPE(1) BGND(13) GROUPS(1107)
       TYPE(Text) CAPTION(Cena celkem)      CPOS( 71,2.2) CLEN( 13)   GROUPS(1107)
       TYPE(Text) NAME(nCenaCelk)  CPOS( 71,3.2) CLEN( 13) CTYPE(2) BGND(13) PP(1) FONT(5) PICTURE( @N 99 999 999.99) GROUPS(1107)
       TYPE(TEXT) NAME(CenZboz->cZkratMeny) CPOS( 85,3.2) CLEN(  5) CTYPE(1) FONT(5) GROUPS(1107)
    TYPE(END)


****
*   Karta POL 3
*   nkarta.ccrd 203 253 255 263 293   .. 0803 neexistuje

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(0A03,0503,0603,0803,0903)
*     1.ø.
      TYPE(Text) CAPTION(Sazba Dph)        CPOS(  2,0.2) CLEN( 10)                   GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) NAME(C_DPH->nProcDPH)     CPOS(  6,1.2) CLEN(  5) BGND( 1) PP(1)    GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nProcDPH)         CPOS(  8,1.2) CLEN(  6) BGND( 1) PP(1)    GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) CAPTION(%)                CPOS( 14,1.2) CLEN(  2)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME( nKlicDph)           FPOS(  2,1.2) FLEN(  6)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME( nMnozPrdod)         FPOS( 16,1.2) FLEN( 11) FCAPTION( Mn. spotøeby)  CPOS(16,0.2) GROUPS(0A03,0503,0603,0803,0903) POST( MnVydane)
      TYPE(Text) CAPTION(Balení)           CPOS( 30,0.2) CLEN(  6)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(CENZBOZ->cBal)       CPOS( 30,1.2) CLEN( 10) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903, clrGREY)
      TYPE(Text) CAPTION(Poèet)            CPOS( 40,0.2) CLEN(  5)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nPocetBal)        CPOS( 40,1.2) CLEN(  6) CTYPE(2) BGND( 13) PP(1)   GROUPS(0A03,0503,0603,0803,0903, clrGREY)
      TYPE(Text) CAPTION(Zùstatek)         CPOS( 46,0.2) CLEN(  8)                   GROUPS(0A03,0503,0603,0803,0903)
      TYPE(Text) NAME(M->nZustatek)        CPOS( 46,1.2) CLEN(  8) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 9999999.99)  GROUPS(0A03,0503,0603,0803,0903, clrGREY)


      TYPE(TEXT) CAPTION(% danì)       CPOS( 3,2.3) CLEN( 7)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(rv_dph)       CPOS(13,2.3) CLEN( 6)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(CENA)         CPOS(22,2.3) CLEN( 5)                                         GROUPS(0A03,0503,0603,0803,0903) FONT(5) 
      TYPE(TEXT) CAPTION(základní)     CPOS(33,2.2) CLEN( 7)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(sleva)        CPOS(50,2.2) CLEN( 5)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(% slevy)      CPOS(65,2.2) CLEN( 7)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(se slevou)    CPOS(81,2.2) CLEN( 8)                                         GROUPS(0A03,0503,0603,0803,0903)
      TYPE(TEXT) CAPTION(celkem)       CPOS(97,2.2) CLEN( 6)                                         GROUPS(0A03,0503,0603,0803,0903)

      TYPE(Text) CAPTION(za MJ   )     CPOS(22,4.3)                                                  GROUPS(0A03,0503,0603,0803,0903,SETFONT,8.Arial CE)   
      TYPE(Text) CAPTION(za POL  )     CPOS(22,5.1)                                                  GROUPS(0A03,0503,0603,0803,0903,SETFONT,8.Arial CE)

      TYPE(STATIC) STYPE(12) FPOS( 1,2.7) SIZE(107, 3) CTYPE(2)                                      GROUPS(0A03,0503,0603,0803,0903)
* 1
        TYPE(Get)   NAME(PVPITEMww->NKLICDPH)      FPOS( 1,0.5) FLEN( 7)                             GROUPS(0A03,0503,0603,0803,0903) PP(2)
        TYPE(Get)   NAME(PVPITEMww->NCENAZAKL)     FPOS(28,0.5) FLEN(13)   PP(2)                     GROUPS(0A03,0503,0603,0803,0903) PUSH(FIN_CMDPH)
        TYPE(Get)   NAME(PVPITEMww->NHODNSLEV)     FPOS(44,0.5) FLEN(13)                             GROUPS(0A03,0503,0603,0803,0903) 
        TYPE(Get)   NAME(PVPITEMww->NPROCSLEV)     FPOS(60,0.5) FLEN(13)                             GROUPS(0A03,0503,0603,0803,0903)
        TYPE(Text)  NAME(M->nVyslCenaB)            CPOS(76,0.5) CLEN(14)   BGND(13) CTYPE(2)         GROUPS(0A03,0503,0603,0803,0903)
        TYPE(Text)  NAME(M->nVyslCenaS)            CPOS(92,0.5) CLEN(14)   BGND(13) CTYPE(2)         GROUPS(0A03,0503,0603,0803,0903)
* 2
        TYPE(Text)  NAME(M->nSumaPolS)             CPOS(28,1.5) CLEN(14)  BGND(13) CTYPE(2)          GROUPS(0A03,0503,0603,0803,0903) PICTURE(@N 9999999999.99)
        TYPE(Text)  NAME(M->nSumHodnSl)            CPOS(44,1.5) CLEN(14)  BGND(13) CTYPE(2)          GROUPS(0A03,0503,0603,0803,0903) 
        TYPE(Text)  NAME(M->nSumaDoklB)            CPOS(76,1.5) CLEN(14)  BGND(13) CTYPE(2)          GROUPS(0A03,0503,0603,0803,0903) PICTURE(@N 9999999999.99)
        TYPE(Text)  NAME(M->nSumaDoklS)            CPOS(92,1.5) CLEN(14)  BGND(13) CTYPE(2)          GROUPS(0A03,0503,0603,0803,0903) PICTURE(@N 9999999999.99)
      TYPE(END) 


*      TYPE(Text) CAPTION( Prodejní ceny za MJ      - základní  :) CPOS(  2,3.3) CLEN( 26) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) CAPTION(- se slevou: )                           CPOS( 18,4.3) CLEN( 10) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) CAPTION( Prodejní ceny celkem  - za položku:)    CPOS(  2,5.3) CLEN( 26) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) CAPTION( - za doklad: )                          CPOS( 18,6.3) CLEN( 10) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) CAPTION( Èástka slevy )                          CPOS( 60,2.3) CLEN( 12) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(GET)  NAME( nCenaZakl)                                 FPOS( 28,3.3) FLEN( 12) FCAPTION(bez DPH) CPOS(34,2.3) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(GET)  NAME(M->nCenaMZbo)                               FPOS( 42,3.3) FLEN( 12) FCAPTION(s DPH)   CPOS(49,2.3) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(GET)  NAME( nHodnSlev)                                 FPOS( 57,3.3) FLEN( 12) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(GET)  NAME( nProcSlev)                                 FPOS( 71,3.3) FLEN(  7) PICTURE(@N 99.9999) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) CAPTION( % )                                     CPOS( 76,2.3) CLEN(  3) GROUPS(0A03,0503,0603,0803,0903)

*      TYPE(Text) NAME(M->nVyslCenaB)  CPOS( 28,4.3) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903, clrGREY)
*      TYPE(Text) NAME(M->nVyslCenaS)  CPOS( 42,4.3) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903, clrGREY)
*      TYPE(Text) NAME(M->nSumHodnSl)  CPOS( 57,4.3) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.99)    GROUPS(0A03,0503,0603,0803,0903, clrGREY)
*      TYPE(Text) NAME(M->nSumProcSl)  CPOS( 71,4.3) CLEN(  8) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99.9999)          GROUPS(0A03,0503,0603,0803,0903, clrGREY)
*      TYPE(Text) NAME(M->nSumaPolB)   CPOS( 28,5.3) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903, clrGREEN)
*      TYPE(Text) NAME(M->nSumaPolS)   CPOS( 42,5.3) CLEN( 13) CTYPE(2) BGND( 13) PP(3) PICTURE(@N 99,999,999.9999)  GROUPS(0A03,0503,0603,0803,0903, clrGREEN)
**      TYPE(Text) NAME(M->nCelkPCB)    CPOS( 28,6.3) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903, clrGREY)
**      TYPE(Text) NAME(M->nCelkPCS)    CPOS( 42,6.3) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903, clrGREY)
*      TYPE(Text) NAME(M->nSumaDoklB)  CPOS( 28,6.3) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903)
*      TYPE(Text) NAME(M->nSumaDoklS)  CPOS( 42,6.3) CLEN( 13) CTYPE(2) BGND( 13) PP(1) PICTURE(@N 99,999,999.9999) GROUPS(0A03,0503,0603,0803,0903)

      TYPE(GET)  NAME(cZkrProdej)     FPOS( 90,3.3) FLEN( 6) FCAPTION(Prodejce)    CPOS( 90,2.3) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET)  NAME(nCisFak)        FPOS( 90,5.3) FLEN(10) FCAPTION(Èís.faktury) CPOS( 90,4.3) GROUPS(0A03,0503,0603,0803,0903)

      TYPE(GET) NAME( cNazPol1)       FPOS(  2,6.7) FLEN( 12) FCAPTION(Stredisko)   CPOS( 2,5.7) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME( cNazPol2)       FPOS( 16,6.7) FLEN( 12) FCAPTION(Výkon)       CPOS(16,5.7) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME( cNazPol3)       FPOS( 30,6.7) FLEN( 12) FCAPTION(Zakázka)     CPOS(30,5.7) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME( cNazPol4)       FPOS( 44,6.7) FLEN( 12) FCAPTION(Výr.místo)   CPOS(44,5.7) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME( cNazPol5)       FPOS( 58,6.7) FLEN( 12) FCAPTION(Stroj)       CPOS(58,5.7) GROUPS(0A03,0503,0603,0803,0903)
      TYPE(GET) NAME( cNazPol6)       FPOS( 72,6.7) FLEN( 12) FCAPTION(Výr.operace) CPOS(72,5.7) GROUPS(0A03,0503,0603,0803,0903) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 4
*   nkarta.ccrd 204 274 244

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(0A04,0704,4304)
      TYPE(GET)  NAME(nMnozDokl1)          FPOS(  1,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS( 1,0.2) GROUPS(0A04,0704,4304) POST( MnVydane)
      TYPE(GET)  NAME(cMJDokl1)            FPOS( 15,1.2) FLEN( 13) FCAPTION( MJ dokl     )  CPOS(15,0.2) GROUPS(0A04,0704,4304)
      TYPE(GET)  NAME(nMnozPrdod)          FPOS( 30,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS(30,0.2) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(MJ zákl.)         CPOS( 45,0.2) CLEN( 13)                   GROUPS(0A04,0704,4304)
      TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 45,1.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0A04,0704,4304)

      TYPE(Text) CAPTION(Skladová cena)       CPOS(  1,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
       TYPE(GET)  NAME( nCenNapDod)           FPOS(  1,3.2) FLEN( 15)                            GROUPS(0A04,0704,4304)
**      TYPE(Text) NAME( PVPITEMww->nCenNapDod)  CPOS(  1,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
*      TYPE(Text) NAME(CENZBOZ->nCenaSZBO)     CPOS(  1,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Celkem položka)      CPOS( 17,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(M->nCelkITEM)           CPOS( 17,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304) PICTURE( @N 99 999 999.99)
*      TYPE(Text) NAME(PVPItem->nCenaCelk)     CPOS( 17,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Celkem doklad)       CPOS( 33,2.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(M->nCelkDOKL)           CPOS( 33,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304) PICTURE( @N 99 999 999.99)

      TYPE(Text) CAPTION(Mn. k dispozici)      CPOS( 58,0.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(CENZBOZ->nMnozDZBO)      CPOS( 58,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)
      TYPE(Text) CAPTION(Mn. rezervováno)      CPOS( 75,0.2)   CLEN( 15)                          GROUPS(0A04,0704,4304)
      TYPE(Text) NAME(CENZBOZ->nMnozRZBO)      CPOS( 75,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0A04,0704,4304)

      TYPE(GET) NAME( cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME( cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME( cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME( cNazPol4)    FPOS( 51,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME( cNazPol5)    FPOS( 67,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0A04,0704,4304)
      TYPE(GET) NAME( cNazPol6)    FPOS( 83,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0A04,0704,4304) POST( LastFieldIT)
*
*      TYPE(PushButton) POS(47, 6.2) SIZE(2,1) CAPTION()  EVENT(skl_vyrzakit_sel) PRE(2) ICON1(101) ICON2(201) ATYPE(1) GROUPS(0A04)
    TYPE(END)

*   Karta POL 05   (  ... karta 205 )
*   nkarta.ccrd 205

    TYPE(Static) STYPE(13) SIZE(104.8, 10)  FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(0A05)
      TYPE(GET)  NAME(nMnozPrDod)           FPOS(  1,1.2) FLEN( 13) FCAPTION( Mn. vydané)    CPOS( 1,0.2) GROUPS(0A05 ) POST( MnVydane)
      TYPE(GET)  NAME(nCenaCelk)            FPOS(  1,3.2) FLEN( 13) FCAPTION( Cena CELKEM)   CPOS( 1,2.2) GROUPS(0A05 )

      TYPE(GET)  NAME(cKlicSkMis)           FPOS( 17,1.2) FLEN( 13) FCAPTION( Skupin. místo) CPOS(17,0.2) GROUPS(0A05 )
      TYPE(Text) CAPTION(Název místa)       CPOS( 32,0.2) CLEN( 13)                    GROUPS(0A05)
      TYPE(Text) NAME(C_SkuMis->cNazSkMis)  CPOS( 32,1.2) CLEN( 30)          BGND( 13) GROUPS(0A05, clrGREY)

      TYPE(GET)  NAME(cKlicOdMis)           FPOS( 17,3.2) FLEN( 13) FCAPTION( Odpovìd.místo) CPOS(17,2.2) GROUPS(0A05 )
      TYPE(Text) CAPTION(Název místa)       CPOS( 32,2.2) CLEN( 13)                    GROUPS(0A05)
      TYPE(Text) NAME(C_OdpMis->cNazOdpMis) CPOS( 32,3.2) CLEN( 30)          BGND( 13) GROUPS(0A05, clrGREY)
      TYPE(Text) CAPTION(Os.è.prac.)        CPOS( 65,2.2) CLEN( 10)                    GROUPS(0A05)
      TYPE(Text) NAME(MsPrc_MD->nOsCisPrac) CPOS( 65,3.2) CLEN( 10) CTYPE(2) BGND( 13) GROUPS(0A05, clrGREY)
      TYPE(Text) CAPTION(Pracovník)         CPOS( 77,2.2) CLEN( 10)                    GROUPS(0A05)
      TYPE(TEXT) NAME(MsPrc_MD->cPracovnik) CPOS( 77,3.2) CLEN( 25) CTYPE(2) BGND( 13) GROUPS(0A05, clrGREY)
      TYPE(GET)  NAME(nInvCisDim)           FPOS( 17,5.2) FLEN( 13) FCAPTION( Inv.èíslo DIMu) CPOS(17,4.2) GROUPS(0A05 ) PUSH( KartaDIM)
      TYPE(Text) CAPTION(Název DIMu)        CPOS( 32,4.2) CLEN( 13)                    GROUPS(0A05)
      TYPE(Text) NAME(M->cNazDIMu)          CPOS( 32,5.2) CLEN( 30) CTYPE(2) BGND( 13) GROUPS(0A05, clrGREY)
      TYPE(GET)  NAME(nDokPriDim)           FPOS( 65,5.2) FLEN( 13) CTYPE(2) FCAPTION( Pøíjmový doklad) CPOS(63,4.2) GROUPS(0A05 ) PUSH(skl_prijDIM)

      TYPE(GET) NAME( cNazPol1)    FPOS(  1,8.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,7.2) GROUPS(0A05)
      TYPE(GET) NAME( cNazPol2)    FPOS( 17,8.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,7.2) GROUPS(0A05)
      TYPE(GET) NAME( cNazPol3)    FPOS( 33,8.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,7.2) GROUPS(0A05)
      TYPE(GET) NAME( cNazPol4)    FPOS( 49,8.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,7.2) GROUPS(0A05)
      TYPE(GET) NAME( cNazPol5)    FPOS( 65,8.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,7.2) GROUPS(0A05)
      TYPE(GET) NAME( cNazPol6)    FPOS( 81,8.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,7.2) GROUPS(0A05) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 9 - OPRAVA VÝDEJKY
*   nkarta.ccrd 299

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)         GROUPS(0909)
      TYPE(GET)  NAME(nMnozDokl1)          FPOS(  1,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS( 1,0.2) GROUPS(0909)
      TYPE(GET)  NAME(cMJDokl1)            FPOS( 15,1.2) FLEN( 13) FCAPTION( MJ dokl     )  CPOS(15,0.2) GROUPS(0909)
      TYPE(GET)  NAME(nMnozPrdod)          FPOS( 30,1.2) FLEN( 13) FCAPTION( Mn. spotøeby)  CPOS(30,0.2) GROUPS(0909)
      TYPE(Text) CAPTION(MJ zákl.)         CPOS( 45,0.2) CLEN( 13)                   GROUPS(0909)
      TYPE(TEXT) NAME(CenZboz->cZkratJedn) CPOS( 45,1.2) CLEN(  8) CTYPE(2) BGND(13) GROUPS(0909)

      TYPE(Text) CAPTION(Skladová cena)       CPOS(  1,2.2)   CLEN( 15)                          GROUPS(0909)
      TYPE(GET)  NAME( nCenNapDod)            FPOS(  1,3.2)   FLEN( 15)                          GROUPS(0909)

*      TYPE(GET) NAME( cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0909)
*      TYPE(GET) NAME( cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0909)
*      TYPE(GET) NAME( cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0909)
*      TYPE(GET) NAME( cNazPol4)    FPOS( 49,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0909)
*      TYPE(GET) NAME( cNazPol5)    FPOS( 65,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0909)
*      TYPE(GET) NAME( cNazPol6)    FPOS( 81,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0909) POST( LastFieldIT)
    TYPE(END)

*   Karta POL 51  (  ... karta 305 )
*   nkarta.ccrd .. 0051  neexistuje

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)  GROUPS(0051)
      TYPE(GET)  NAME(cSkladKAM)  FPOS(  1,1.2) FLEN( 12) FCAPTION( Pøevod na sklad)   CPOS( 1,0.2) GROUPS(0051) PUSH(SKL_C_Sklad)
      TYPE(GET)  NAME(cSklPolKAM) FPOS( 15,1.2) FLEN( 20) FCAPTION( Pøevod na položku) CPOS(15,0.2) GROUPS(0051)
      TYPE(GET)  NAME(nUcetSkKAM) FPOS( 37,1.2) FLEN( 12) FCAPTION( Pøevod na úè.sk.)  CPOS(37,0.2) GROUPS(0051) PUSH(SKL_C_UctSkp)
      TYPE(GET)  NAME(nMnozPrdod) FPOS( 51,1.2) FLEN( 15) FCAPTION( Mn. pøevodu)       CPOS(51,0.2) GROUPS(0051) POST( SKL_MnPrevodu_)
      TYPE(GET)  NAME(cText)      FPOS(  1,3.2) FLEN( 30) FCAPTION( Pozn. k pøevodu)   CPOS( 1,2.2) GROUPS(0051)
    TYPE(END)

*   Karta POL 8051  (  ... karta 305 )
*   nkarta.ccrd 305

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)  GROUPS(8051)
      TYPE(GET)  NAME(cSkladKAM)  FPOS(  1,1.5) FLEN( 12) FCAPTION(Pøevod na sklad)    CPOS( 1,0.5)          GROUPS(8051) PUSH(SKL_C_Sklad)
      TYPE(GET)  NAME(cSklPolKAM) FPOS( 15,1.5) FLEN( 20) FCAPTION(Pøevod na položku)  CPOS(15,0.5)          GROUPS(8051)

      TYPE(Text) CAPTION(skl_úèSkup)       CPOS( 38,0.5) CLEN( 12)                                           GROUPS(8051)
      TYPE(Text) NAME(M->cen_ucetSkup)     CPOS( 38,1.5) CLEN( 12)  FONT(5) BGND( 13) PP(1) CTYPE(2)         GROUPS(8051)
      TYPE(TEXT) CAPTION(->)               CPOS( 50,1.5) CLEN(  3)  FONT(5)                                  GROUPS(8051) 
      TYPE(GET)  NAME(nUcetSkKAM) FPOS( 53,1.5) FLEN( 12) FCAPTION(Pøevod na úèSkup)   CPOS(53,0.5) CLEN(14) GROUPS(8051) PUSH(SKL_C_UctSkp)

      TYPE(Text) CAPTION(skl_množství)     CPOS( 69,0.5) CLEN( 14)                                           GROUPS(8051)
      TYPE(Text) NAME(M->cen_mnozsZBO)     CPOS( 69,1.5) CLEN( 14)  FONT(5) BGND( 13) PP(1) CTYPE(2)         GROUPS(8051)
      TYPE(TEXT) CAPTION(->)               CPOS( 83,1.5) CLEN(  3)  FONT(5)                                  GROUPS(8051) 
      TYPE(GET)  NAME(nMnozPrdod) FPOS( 86,1.5) FLEN( 13) FCAPTION(množ_pøevodu)       CPOS(86,0.5)          GROUPS(8051) POST( SKL_MnPrevodu_) 

      TYPE(GET)  NAME(cText)      FPOS(  1,4.5) FLEN(98) FCAPTION(Poznámka k pøevodu) CPOS( 1,3.5)          GROUPS(8051)
    TYPE(END)


*   Karta POL 400 ... pøecenìní
*   nkarta.ccrd 400

    TYPE(Static) STYPE(13) SIZE(104.8, 10) FPOS(0.1, 2.7)  RESIZE(yx)    GROUPS(0400)
      TYPE(Text) CAPTION(Skl.cena/MJ)      CPOS( 25,0.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Cena celkem)      CPOS( 45,0.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Pùvodní hodnota)  CPOS(  2,1.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Nová  hodnota)    CPOS(  2,2.2)   CLEN( 15) GROUPS(0400)
      TYPE(Text) CAPTION(Nová - Pùvodní)   CPOS(  2,3.2)   CLEN( 15) GROUPS(0400)

      TYPE(Text) NAME( nCelkSLEV)  CPOS( 20,1.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(GET)  NAME( nCenNapDod) FPOS( 20,2.2)   FLEN( 14) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(Text) NAME( nCenaCZBO)  CPOS( 40,2.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)

      TYPE(Text) NAME(M->nCenaSROZ)  CPOS( 20,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)
      TYPE(Text) NAME( nCenaCelk)    CPOS( 40,3.2)   CLEN( 15) CTYPE(2) BGND( 13) PP(1) GROUPS(0400)

      TYPE(GET) NAME( cNazPol1)    FPOS(  1,6.2)  FLEN( 13) FCAPTION(Stredisko)  CPOS( 1,5.2) GROUPS(0400)
      TYPE(GET) NAME( cNazPol2)    FPOS( 17,6.2)  FLEN( 13) FCAPTION(Výkon)      CPOS(17,5.2) GROUPS(0400)
      TYPE(GET) NAME( cNazPol3)    FPOS( 33,6.2)  FLEN( 13) FCAPTION(Zakázka)    CPOS(33,5.2) GROUPS(0400)
      TYPE(GET) NAME( cNazPol4)    FPOS( 49,6.2)  FLEN( 13) FCAPTION(Výr.místo)  CPOS(49,5.2) GROUPS(0400)
      TYPE(GET) NAME( cNazPol5)    FPOS( 65,6.2)  FLEN( 13) FCAPTION(Stroj)      CPOS(65,5.2) GROUPS(0400)
      TYPE(GET) NAME( cNazPol6)    FPOS( 81,6.2)  FLEN( 13) FCAPTION(Výr.operace)CPOS(81,5.2) GROUPS(0400) POST( LastFieldIT)
    TYPE(END)


    TYPE(Static) STYPE(13) SIZE(104, 2) FPOS(0.1,12.8) RESIZE(yn)
      TYPE(Static) STYPE(12) SIZE(14, 1) FPOS( 88,0.5) RESIZE(nn)
        TYPE(PushButton) POS(0, 0) SIZE( 14,1) CAPTION(~Uložit + nová) EVENT(SaveAndIns);
                                               ICON1(101) ICON2(201) ATYPE(3)
      TYPE(End)

     TYPE(PushButton) POS(5, 0.5) SIZE( 12,1)CAPTION(Zásobník) EVENT(TT_data_yes);
                      ICON1(427) ICON2(427) ATYPE(3) GROUPS(TT)
     TYPE(PushButton) POS(5, 0.5) SIZE( 12,1)CAPTION(Zásobník) EVENT(TT_data_no);
                      ICON1(428) ICON2(428) ATYPE(3) GROUPS(TT)
    TYPE(End)

  TYPE(End)
TYPE(End)

* neviditelné pomocné položky
TYPE(TEXT) NAME(pvpitemww->cfile_iv)    FPOS(0,0) CLEN(0) GROUPS(clrYELLOW)
TYPE(TEXT) NAME(pvpitemww->nrecs_iv)    FPOS(0,0) CLEN(0) GROUPS(clrYELLOW)


