TYPE(drgForm) DTYPE(10) TITLE(Skladová karta) SIZE(100,25) FILE(CENZBOZw);
              GUILOOK(Message:y,Action:n,IconBar:y:MyIconBar,Menu:y:myMenuBar);
              POST( POSTVALIDATE) PRE( PREVALIDATE) CBSAVE(OnSave)
*              PRE( PRE_CENZBOZ) POST( POST_CENZBOZ)

TYPE(Static) STYPE(13) SIZE(99,3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(GET)  NAME(CCISSKLAD) FPOS( 1,1.2) FLEN(15) FCAPTION(Sklad) CPOS(1,0.2) PP(2) PUSH( C_SKLADY) NOREVISION()
  TYPE(Text) NAME(C_SKLADY->cNazSklad)  CPOS(1,2.2) CLEN(30) BGND(1) FONT(5)
  TYPE(GET)  NAME(CSKLPOL)   FPOS(20,1.2) FLEN(20) FCAPTION(Skladová položka) CPOS(20,0.2) PP(2) NOREVISION()
  TYPE(GET)  NAME(CNAZZBO)   FPOS(45,1.2) FLEN(50) FCAPTION(Název zboží) CPOS(45,0.2) PP(2) PUSH( SKL_C_NAZZBO)
  TYPE(GET)  NAME(CNAZZBO2)  FPOS(45,2.2) FLEN(50)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(100,21) FPOS(0,4) RESIZE(yn)

  TYPE(TABPAGE) CAPTION(Základní údaje) FPOS( 1,6) RESIZE(yx) OFFSET( 1,82) PRE(tabSelect)

    TYPE(GET)  NAME(CULOZZBO)  FPOS(15,1) FLEN(15) FCAPTION(Místo uložení) CPOS(1,1) PUSH(c_ulozmi_sel)
    TYPE(GET)  NAME(NZBOZIKAT) FPOS(15,2) FLEN(15) FCAPTION(Kategorie zboží) CPOS(1,2)
*    TYPE(Text) NAME(C_KATZBO->cNazevKat)  CPOS(22,2) CLEN(20)
    TYPE(GET)  NAME(NUCETSKUP) FPOS(15,3) FLEN(15) FCAPTION(Úèetní skupina) CPOS(1,3)  PP(2)
*    TYPE(Text) NAME(C_UCTSKP->cNazUctSk)  CPOS(22,3) CLEN(20)

    TYPE(Static) STYPE(12) SIZE(98, 3) FPOS(1,4.2) RESIZE(yx) CTYPE(2)
      TYPE(COMBOBOX) NAME(CTYPSKLCEN) FPOS( 3,1.2) FLEN(12) FCAPTION(Typ sklad. ceny) CPOS( 3,0.2) REF(TYPSKLCEN)
      TYPE(Text)     CAPTION(Skladová cena) CPOS(23, 0.2) CLEN( 12)
      TYPE(GET)      NAME(NCENASZBO)  FPOS(18,1.2) FLEN(15)
      TYPE(GET)      NAME(CZKRATMENY) FPOS(35,1.2) FLEN( 7) FCAPTION(Zákl.mìna)       CPOS(35,0.2)
      TYPE(GET)      NAME(CZAHRMENA)  FPOS(44,1.2) FLEN( 8) FCAPTION(Zahr.mìna)       CPOS(44,0.2)
      TYPE(GET)      NAME(NMNOZSZBO)  FPOS(55,1.2) FLEN(13) FCAPTION(Mn. na skladu)   CPOS(59,0.2) PP(3)
      TYPE(GET)      NAME(CZKRATJEDN) FPOS(70,1.2) FLEN( 6) FCAPTION(MJ)              CPOS(74,0.2)
      TYPE(GET)      NAME(NCENACZBO)  FPOS(80,1.2) FLEN(13) FCAPTION(Skl.cena celkem) CPOS(82,0.2) PP(3)
    TYPE(End)

    TYPE(COMBOBOX) NAME(CPOLCEN)    FPOS(15, 7.5) FLEN(21) FCAPTION(Položka ceníku)   CPOS(1, 7.5) REF(POLCEN)
    TYPE(GET)      NAME(NKLICDPH)   FPOS(15, 8.5) FLEN(20) FCAPTION(Klíè DPH)         CPOS(1, 8.5)
    TYPE(COMBOBOX) NAME(cTypSklPol) FPOS(15, 9.5) FLEN(21) FCAPTION(Typ položky)      CPOS(1, 9.5) REF(TYPSKLPOL)

*         VALUES(V :Materiál pro výrobu,O :Obchodní zboží,U :Materiál nebo zboží,R :Výrobek,P :Polotovar,S :Prodejní sestava)
*    TYPE(GET)      NAME(NKLICDPH)   FPOS(15, 8.5) FLEN(20) FCAPTION(Klíè DPH)         CPOS(1, 8.5)
*    TYPE(Text)     NAME(C_DPH->nProcDPH)  CPOS(22,8.5) CLEN(6)
*    TYPE(COMBOBOX) NAME(CPOLCEN)    FPOS(15, 9.5) FLEN(21) FCAPTION(Položka ceníku)   CPOS(1, 9.5) REF(POLCEN)
**    TYPE(GET)      NAME(CTYPSKP)    FPOS(15,10.5) FLEN(20) FCAPTION(Klíè SKp)         CPOS(1,10.5)

    TYPE(GET)      NAME(ctypCZcpa)  FPOS(15,10.5) FLEN(20) FCAPTION(Klíè cz-cpa)      CPOS(1,10.5)

    TYPE(GET)      NAME(CDANPZBO)   FPOS(15,11.5) FLEN(20) FCAPTION(Èíselný kód JCD)  CPOS(1,11.5)
    TYPE(GET)      NAME(CJKPOV)     FPOS(15,12.5) FLEN(20) FCAPTION(Èíslo JKPOV)      CPOS(1,12.5)
    TYPE(COMBOBOX) NAME(CVYRCIS)    FPOS(15,13.5) FLEN(21) FCAPTION(Evid. výr.èísel)  CPOS(1,13.5) REF(CVYRCIS)
    TYPE(COMBOBOX) NAME(CKATALCIS)  FPOS(15,14.6) FLEN(21) FCAPTION(Katalog. èíslo)   CPOS(1,14.6) REF(CKATALCIS)
*    TYPE(GET)      NAME(CKATALCIS)  FPOS(15,14.5) FLEN(20) FCAPTION(Katalog. èíslo)   CPOS(1,14.5)
    TYPE(GET)      NAME(CKATCZBO)   FPOS(15,15.55) FLEN(20) FCAPTION(Katalogové èíslo) CPOS(1,15.55)
*    TYPE(STATIC) STYPE(16) CPOS( 1, 16.5) SIZE(80,1)
    TYPE(Static) STYPE(12) SIZE(98, 3) FPOS(1,16.7) RESIZE(yx) CTYPE(2)
      TYPE(GET)      NAME(CZKRCARKOD) FPOS(12,0.5) FLEN(17) FCAPTION(Typ èár.kódu)    CPOS( 1,0.5)
      TYPE(COMBOBOX) NAME(NTYPGENBCD) FPOS(54,0.5) FLEN(25) FCAPTION(Typ generování)  CPOS(39,0.5) VALUES(0:negeneruje se,;
                                                                                                          1:standartní   ,;
                                                                                                          2:sklad + skl.položka + nuly,;
                                                                                                          3:skl.položka + sklad + nuly,;
                                                                                                          4:sklad + skl.položka + mezery,;
                                                                                                          5:skl.položka + sklad + mezery )
      TYPE(GET)      NAME(CCARKOD)    FPOS(12,1.5) FLEN(83) FCAPTION(Èárový kód)      CPOS( 1,1.5)
    TYPE(END)

    TYPE(GET)      NAME(NHMOTNOST)  FPOS(60, 1) FLEN(13) FCAPTION(Hmotnost položky) CPOS(45,1)
    TYPE(GET)      NAME(CZKRATJEDH) FPOS(80, 1) FLEN( 6) FCAPTION(MJ)               CPOS(75,1)
    TYPE(GET)      NAME(NOBJEM)     FPOS(60, 2) FLEN(13) FCAPTION(Objem položky)    CPOS(45,2)
    TYPE(GET)      NAME(CZKRATJEDO) FPOS(80, 2) FLEN( 6) FCAPTION(MJ)               CPOS(75,2)
    TYPE(GET)      NAME(CBAL)       FPOS(60, 3) FLEN(15) FCAPTION(Zpùsob balení)    CPOS(45,3)
    TYPE(GET)      NAME(NBALKS)     FPOS(87, 3) FLEN(11) FCAPTION(kusù v balení)    CPOS(76,3)

*    TYPE(GET) NAME(NKLICNAZ) FPOS(15,6) FLEN(5) FCAPTION(Klíè názvu) CPOS(1,6)

    TYPE(GET)      NAME(NMAXZBO)    FPOS(55,7.5) FLEN(11) FCAPTION(Maximální stav)    CPOS(40,7.5)
    TYPE(GET)      NAME(NMINZBO)    FPOS(55,8.5) FLEN(11) FCAPTION(Minimální stav)    CPOS(40,8.5)
*    TYPE(STATIC) STYPE(16) CPOS( 40,9.8) SIZE(60,1)

    TYPE(GET)      NAME(NMNOZDZBO)  FPOS(55,10)   FLEN(11) FCAPTION(Mn. k dispozici)  CPOS(40, 10) PP(3)
    TYPE(GET)      NAME(NMNOZRZBO)  FPOS(55,11)   FLEN(11) FCAPTION(Rezervované mn.)  CPOS(40, 11) PP(3)
    TYPE(GET)      NAME(NMNOZOZBO)  FPOS(55,12)   FLEN(11) FCAPTION(Objednané mn.)    CPOS(40, 12) PP(3)
    TYPE(GET)      NAME(NMNOZKZBO)  FPOS(55,13)   FLEN(11) FCAPTION(Mn. k objednání)  CPOS(40, 13) PP(3)

    TYPE(GET)      NAME(NMNOZRSES)  FPOS(55,14.5)  FLEN(11) FCAPTION(Rezerv. výroba)   CPOS(40, 14.5) PP(3)
    TYPE(GET)      NAME(CJAKOST)    FPOS(55, 15.5) FLEN(20) FCAPTION(Jakost)           CPOS(40, 15.5)

    TYPE(GET)      NAME(NMNOZPOC)   FPOS(86,7.5) FLEN(11) FCAPTION(Poèát. skl. množ.) CPOS(70, 7.5) PP(3)
    TYPE(GET)      NAME(NCENAPOC)   FPOS(86,8.5) FLEN(11) FCAPTION(Poèát. skl. cena)  CPOS(70, 8.5) PP(3)

    TYPE(GET)      NAME(NCENASVZM)  FPOS(86, 10) FLEN(11) FCAPTION(Skl.cena v zák.mìnì) CPOS(70, 10) PP(3)
    TYPE(GET)      NAME(NCENAKURZ)  FPOS(86, 11) FLEN(11) FCAPTION(Posl.cena pøi kurzu) CPOS(70, 11) PP(3)
    TYPE(GET)      NAME(NCENAVNI)   FPOS(86, 12) FLEN(11) FCAPTION(Vnitro cena)         CPOS(70, 12) PP(3)

*    TYPE(TEXT) CAPTION(Poslední pohyb) CPOS(70, 14.5)
    TYPE(TEXT) NAME(CenZboz->DDATPZBO) CPOS(87, 14.5) CLEN(10) BGND(13) FONT(5)
    TYPE(COMBOBOX) NAME(LAKTIVNI)      FPOS(87, 15.6) FLEN(10) FCAPTION(Aktivní)  CPOS(80, 15.6) REF(LYESNO)

*    TYPE(GET) NAME(NCENANZBO) FPOS(15,12) FLEN(11) FCAPTION(Posl. nákupní cena) CPOS(1,12)
*    TYPE(GET) NAME(NCENCNZBO) FPOS(15,13) FLEN(11) FCAPTION(Nákupní ceníková cena) CPOS(1,13)

  TYPE(END)

  TYPE(TabPage) CAPTION(Prodejní ceny) FPOS( 1,6) RESIZE(yx) OFFSET(18,66) PRE(tabSelect)

     TYPE(Static) STYPE(13) SIZE(94,2) FPOS(3,1) RESIZE(yx)
      TYPE(GET)    NAME(CenProdCw->NCENCNZBO)   FPOS(20,0.5) FLEN(11) FCAPTION(Nakupní ceník. cena) CPOS( 2,0.5)
      TYPE(GET)    NAME(CenZbozw->NCENANZBO)    FPOS(55,0.5) FLEN(11) FCAPTION(Posl. nákupní cena)  CPOS(35,0.5)

      TYPE(COMBOBOX) NAME(cenZbozW->ngetProCen) FPOS(72,.5) FLEN(20)  FCAPTION(Aktivní)  CPOS(80, 15.6) VALUES(0:prodejní cena   , ; 
                                                                                                               1:skladová cena     )

     TYPE(End)

     TYPE(Static) STYPE(13) SIZE(94,9) FPOS(3,3.5) RESIZE(yx)
       TYPE(Text) CAPTION(Prodejní ceny :)      CPOS( 1,0.5) CLEN(15) BGND(1) FONT(5)
       TYPE(Text) CAPTION(Marže v %)            CPOS(31,0.5) CLEN(10) BGND(1) FONT(5)
       TYPE(Text) CAPTION(Èástka )              CPOS(43,0.5) CLEN(15) BGND(1) FONT(5)
       TYPE(Text) CAPTION( - základní bez danì) CPOS(15,1.5) CLEN(15)
       TYPE(Text) CAPTION( - základní   s daní) CPOS(15,2.5) CLEN(15)

       TYPE(Static) STYPE(16) SIZE(40,1) FPOS(15,3)

       TYPE(Text) CAPTION( - èíslo 1  bez danì)  CPOS(15,4) CLEN(15)
       TYPE(Text) CAPTION( - èíslo 2  bez danì)  CPOS(15,5) CLEN(15)
       TYPE(Text) CAPTION( - èíslo 3  bez danì)  CPOS(15,6) CLEN(15)
       TYPE(Text) CAPTION( - èíslo 4  bez danì)  CPOS(15,7) CLEN(15)

       TYPE(GET)  NAME(CenProdCw->NPROCMARZ)  FPOS(31,1.5) FLEN( 8)
       TYPE(GET)  NAME(CenProdCw->NCENAPZBO)  FPOS(43,1.5) FLEN(11)
       TYPE(GET)  NAME(CenProdCw->NCENAMZBO)  FPOS(43,2.5) FLEN(11)
       TYPE(GET)  NAME(CenProdCw->NPROCMARZ1) FPOS(31,4)   FLEN( 8)
       TYPE(GET)  NAME(CenProdCw->NCENAP1ZBO) FPOS(43,4)   FLEN(11)
       TYPE(GET)  NAME(CenProdCw->NPROCMARZ2) FPOS(31,5)   FLEN( 8)
       TYPE(GET)  NAME(CenProdCw->NCENAP2ZBO) FPOS(43,5)   FLEN(11)
       TYPE(GET)  NAME(CenProdCw->NPROCMARZ3) FPOS(31,6)   FLEN( 8)
       TYPE(GET)  NAME(CenProdCw->NCENAP3ZBO) FPOS(43,6)   FLEN(11)
       TYPE(GET)  NAME(CenProdCw->NPROCMARZ4) FPOS(31,7)   FLEN( 8)
       TYPE(GET)  NAME(CenProdCw->NCENAP4ZBO) FPOS(43,7)   FLEN(11)
       TYPE(GET)  NAME(CenProdCw->dDatAkt   ) FPOS(79,7)   FLEN(11) FCAPTION(Poslední zmìna) CPOS( 65, 7) PUSH( CLICKDATE)

*       TYPE(TEXT) CAPTION(Poslední zmìna)  CPOS(68,7)
*       TYPE(TEXT) NAME(CenProdCw->DDATAKT) CPOS(82,7) CLEN(11) FONT(5)

     TYPE(End)
  TYPE(End)

  TYPE(TabPage) CAPTION(Ostatní údaje) FPOS( 1,6) RESIZE(yx) OFFSET(34,50) PRE(tabSelect)
    TYPE(GET)      NAME(CVYROBCE)   FPOS(22,1) FLEN(25) FCAPTION(Výrobce zboží)           CPOS(2,1)
    TYPE(GET)      NAME(NKOEFMN)    FPOS(22,2) FLEN(15) FCAPTION(Koeficient (mìrná hm.))  CPOS(2,2)
    TYPE(GET)      NAME(NPRIRAZKA)  FPOS(22,3) FLEN(15) FCAPTION(Pøirážka)                CPOS(2,3)
    TYPE(COMBOBOX) NAME(CTYPPREDAN) FPOS(22,4) FLEN(26) FCAPTION(Pøenesená daò.povinnost) CPOS(2,4) REF(CTYPPREDAN) 
    TYPE(GET)      NAME(CZKRMAT)    FPOS(22,5) FLEN(15) FCAPTION(Zkratka materiálu)       CPOS(2,5)
    TYPE(COMBOBOX) NAME(CULOZSYS)   FPOS(22,6) FLEN(16) FCAPTION(Systém uložení)          CPOS(2,6) REF(CULOZSYS) 

    TYPE(GET)      NAME(CRECPOPL)   FPOS(22,7) FLEN(10) FCAPTION(Recykl.poplatek)         CPOS(2,7)
    TYPE(TEXT)     NAME(c_recPop->cnazRECpop)  CPOS(35,7) CLEN(60)
    TYPE(TEXT)     NAME(M->nazRECpop_info)     CPOS(70,7) CLEN(40) FONT(5)
    TYPE(GET)      NAME(CTYPSKP)    FPOS(22,8) FLEN(20) FCAPTION(Klíè SKp)                CPOS(2,8)
  TYPE(End)

*  TYPE(TabPage) CAPTION(místa Uložení) FPOS( 1,6) RESIZE(yx) OFFSET(50,34) PRE(tabSelect)
*    TYPE(EBrowse) FILE(ulozeniW) INDEXORD(1);
*                  FPOS(0, 2.7) SIZE(105, 8.9) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn);
*                  ITEMMARKED( itemMarked) ITEMSELECTED( itemSelected) FOOTER(y)
*
*    TYPE(GET)  NAME( ulozeniW->culozZbo )    FPOS( 1,0) CLEN(13)  CAPTION(místoUložení )        
*    TYPE(TEXT) NAME( M->nazevMista_uloz )    FPOS( 2,0) CLEN(50)  CAPTION(název Místa uložení )
*    TYPE(GET)  NAME( ulozeniW->npocStav )    FPOS( 3,0) FLEN(13)  CAPTION(poèStav)
*    TYPE(TEXT) NAME( ulozeniW->nUlozMnoz)    FPOS( 4,0) CLEN(13)  CAPTION(Ulož.množ.)
*    TYPE(GET)  NAME( ulozeniW->nUlozCelk)    FPOS( 5,0) FLEN(13)  CAPTION(Ulož.celkem)
*  TYPE(End)
*
*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*  TYPE(End)

  TYPE(TabPage) CAPTION(Popis) FPOS( 1,6) RESIZE(yx) OFFSET(66,18) PRE(tabSelect)
    TYPE(MLE) NAME('MPOZZBO') FPOS(3,1) SIZE(92, 18) RESIZE(yx) ;
       FCAPTION(Popis zboží) CPOS(3,10) CLEN(12)
  TYPE(End)

  TYPE(TabPage) CAPTION(Dokumenty) FPOS( 1,6) RESIZE(yx) OFFSET(82,2) PRE(tabSelect)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
    TYPE(PushButton) POS(60, 18) SIZE(15,1.2) CAPTION(~Celá obrazovka) EVENT(FullViewIMG)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)

  TYPE(End)

TYPE(End)