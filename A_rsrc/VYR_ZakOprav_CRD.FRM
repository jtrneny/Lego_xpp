TYPE(drgForm) DTYPE(1) TITLE(Výrobní zakázka - OPRAVY a EMISE) SIZE(105,26) FILE(ZAKOPRAV);
              GUILOOK(Action:y,IconBar:n,Menu:n)


TYPE(Static) STYPE(13) SIZE(104, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)

  TYPE(TEXT) FCAPTION(Zakázka)          CPOS( 1,0.2) CLEN( 10) FONT(2)
  TYPE(TEXT) NAME(VYRZAKw->cCisZakaz)   CPOS( 1,1.2) CLEN( 30) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(TEXT) NAME(VYRZAKw->cNazevZak1)  CPOS( 1,2.2) CLEN(100) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(TEXT) CAPTION(Èíslo objednávky)  CPOS(45,0.2) CLEN( 15) FONT(2)
  TYPE(TEXT) NAME(VYRZAKw->cCisloObj)   CPOS(45,1.2) CLEN( 56) BGND(13) FONT(5) GROUPS(clrGREY)

*  TYPE(GET) NAME(VYRZAKw->CNAZEVZAK1)   FPOS( 1,2.2) FLEN(100) FONT(5)
*  TYPE(TEXT) CAPTION(Èíslo objednávky)  CPOS(45,0.2) CLEN( 15) FONT(2)
*  TYPE(GET) NAME(VYRZAKw->CCISLOOBJ)    FPOS(45,1.2) FLEN( 56) FONT(5)

*  TYPE(TEXT) NAME(VYRZAKw->cNazevZak1)  CPOS(33,1.2) CLEN(30) BGND(13) PP(3)
*  TYPE(TEXT) FCAPTION(Èíslo objednávky) CPOS(65,0.2) CLEN(15) FONT(5)
*  TYPE(TEXT) NAME(VYRZAKw->cCisloObj)   CPOS(65,1.2) CLEN(35) BGND(13) PP(3)

TYPE(End)

TYPE(Static) STYPE(13) SIZE(105,22) FPOS(0,4)  RESIZE(yy)

* OPRAVY
  TYPE(TABPAGE) TTYPE(4) CAPTION(Opravy) FPOS(1,6)  OFFSET(1,82) PRE( tabSelect)
    TYPE(Static) STYPE(13) SIZE(103, 17) FPOS( 1,0.2) RESIZE(yn)
      TYPE(GET)  NAME(cCisRekPro)        FPOS(25, 1) FLEN(40) FCAPTION(Èís. reklamaèního protokolu) CPOS( 4, 1) PICTURE(&30X)
      TYPE(GET)  NAME(dDatPreOpr)        FPOS(25, 2) FLEN(11) FCAPTION(Datum pøedání do opravy)     CPOS( 4, 2) PUSH( CLICKDATE)
      TYPE(GET)  NAME(nDruhOprav)        FPOS(25, 3) FLEN(20) FCAPTION(Druh opravy)                 CPOS( 4, 3) PICTURE(&N 999)
      TYPE(TEXT) NAME(C_Opravy->cNazevDruh)   CPOS(47, 3) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(nTypStroje)        FPOS(25, 4) FLEN(20) FCAPTION(Znaèka vozidla)              CPOS( 4, 4) PICTURE(999)
      TYPE(TEXT) NAME(C_Stroje->cNazevTypu)  CPOS(47, 4) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(cSPZ)              FPOS(25, 5) FLEN(20) FCAPTION(SPZ stroje)                  CPOS( 4, 5) PICTURE(&10X)
      TYPE(GET)  NAME(cVozTyp)           FPOS(25, 6) FLEN(20) FCAPTION(Typ vozidla)                 CPOS( 4, 6) PICTURE(&15X)
      TYPE(TEXT) NAME(C_VozTyp->cNazVozTyp)  CPOS(47, 6) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(cVozDruh)          FPOS(25, 7) FLEN(20) FCAPTION(Druh vozidla)                CPOS( 4, 7) PICTURE(&10X)
      TYPE(TEXT) NAME(C_VozDr->cNazVozDr)    CPOS(47, 7) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(cVozKateg)         FPOS(25, 8) FLEN(20) FCAPTION(Kategorie vozidla)           CPOS( 4, 8) PICTURE(&10X)
      TYPE(TEXT) NAME(C_VozKat->cNazVozKat)  CPOS(47, 8) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(cCisMotoru)        FPOS(25, 9) FLEN(20) FCAPTION(Èíslo motoru)                CPOS( 4, 9) PICTURE(&20X)
      TYPE(GET)  NAME(cTypMotoru)        FPOS(25,10) FLEN(20) FCAPTION(Typ motoru)                  CPOS( 4,10) PICTURE(&9X)
      TYPE(GET)  NAME(cCisPodvoz)        FPOS(25,11) FLEN(20) FCAPTION(Èíslo podvozku)              CPOS( 4,11) PICTURE(&20X)
      TYPE(GET)  NAME(nStavTacho)        FPOS(25,12) FLEN(20) FCAPTION(Stav tachometru)             CPOS( 4,12) PICTURE(&N 9999999)
      TYPE(GET)  NAME(nStavPHM)          FPOS(25,13) FLEN(20) FCAPTION(Stav PHM ( v litrech))       CPOS( 4,13) PICTURE(&N 999.99)
      TYPE(COMBOBOX) NAME(lObsFridex)    FPOS(25,14) FLEN(21) FCAPTION(Obsahuje FRIDEX)             CPOS( 4,14) VALUES(T:ANO,F:NE)
    TYPE(END)

    TYPE(Static) STYPE(13) SIZE(103, 3.5) FPOS( 1,17.3) RESIZE(yn)
      TYPE(GET)  NAME(cPredDoOpr)        FPOS(25, 0.3) FLEN(20) FCAPTION(Do opravy pøedal)          CPOS( 4, 0.3) PICTURE(&20X)
      TYPE(GET)  NAME(nOsProvOpr)        FPOS(25, 1.3) FLEN(20) FCAPTION(Opravu provede)            CPOS( 4, 1.3) PICTURE(&N 99999)
      TYPE(TEXT) NAME(cProvedeOpr)       CPOS(47, 1.3) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(nOsPrevzal)        FPOS(25, 2.3) FLEN(20) FCAPTION(Do opravy pøevzal)         CPOS( 4, 2.3) PICTURE(&N 99999)
      TYPE(TEXT) NAME(cPrevzOpr)         CPOS(47, 2.3) CLEN(40) BGND( 13)

    TYPE(END)
  TYPE(END)

  TYPE(TABPAGE) TTYPE(4) CAPTION(Opravy-popis) FPOS(1,6)  OFFSET(18,66) PRE( tabSelect)
    TYPE(TEXT) CAPTION( Rozsah opravy)     CPOS( 2,1) CLEN( 20)
    TYPE(MLE) NAME( mRozsahOpr) FPOS(2,2) SIZE(100, 6)
    TYPE(TEXT) CAPTION( Rozšíøení opravy)  CPOS( 2,8) CLEN( 20)
    TYPE(MLE) NAME( mRozsirOpr) FPOS(2,9) SIZE(100, 5)
    TYPE(TEXT) CAPTION( Poznámka k opravì)  CPOS( 2,14) CLEN( 20)
    TYPE(MLE) NAME( mPoznamka) FPOS(2,15) SIZE(100, 5)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(END)

* EMISE
  TYPE(TabPage) TTYPE(4) CAPTION(Emise)  FPOS( 1,6) OFFSET(34,50) PRE( tabSelect)

    TYPE(Static) STYPE(13) SIZE(103, 18) FPOS( 1,0.2) RESIZE(yn)
*   1.sloupec
      TYPE(GET)      NAME(cCisProtMe)        FPOS(25,0.5) FLEN(20) FCAPTION(Èíslo protokolu mìøení)     CPOS( 4,0.5) PICTURE(&15X)
      TYPE(GET)      NAME(nOsCisPrac)        FPOS(25, 2) FLEN( 8) FCAPTION(Opravu provede)              CPOS( 4, 2) PICTURE(&N 99999)
      TYPE(COMBOBOX) NAME(lSplEmiNor)        FPOS(25, 3) FLEN( 9) FCAPTION(Splòuje emisní normu)        CPOS( 4, 3)

      TYPE(GET)      NAME(nDalMerMes)        FPOS(25, 4) FLEN( 8) FCAPTION(Další mìøení za (mìsícù))    CPOS( 4, 4) PICTURE(&N 99)
      TYPE(GET)      NAME(dDatDalMer)        FPOS(25, 5) FLEN(11) FCAPTION(Datum dalšího mìøení)         CPOS( 4, 5)
      TYPE(COMBOBOX) NAME(lNovaPruka)        FPOS(25, 6) FLEN( 9) FCAPTION(Nová prùkazka)                CPOS( 4, 6) VALUES(T:ANO,F:NE)
      TYPE(GET)      NAME(cCisPrukaz)        FPOS(25, 7) FLEN(24) FCAPTION(Èíslo prùkazky)               CPOS( 4, 7)
      TYPE(Static) STYPE( 2) SIZE(45, 3) FPOS( 3, 8) RESIZE(ny)
        TYPE(TEXT) CAPTION(Namìøené rozpìtí hodnot kouøivosti)       CPOS( 1, 0) CLEN(26)
        TYPE(TEXT) CAPTION( 1.mìøení)     CPOS( 2, 1) CLEN( 8)
        TYPE(TEXT) CAPTION( 2.mìøení)     CPOS(13, 1) CLEN( 8)
        TYPE(TEXT) CAPTION( 3.mìøení)     CPOS(24, 1) CLEN( 8)
        TYPE(TEXT) CAPTION( 4.mìøení)     CPOS(35, 1) CLEN( 8)
        TYPE(GET)  NAME(nKourMer1)        FPOS( 2, 2) FLEN( 6) PICTURE(&N 9.99)
        TYPE(GET)  NAME(nKourMer2)        FPOS(13, 2) FLEN( 6) PICTURE(&N 9.99)
        TYPE(GET)  NAME(nKourMer3)        FPOS(24, 2) FLEN( 6) PICTURE(&N 9.99)
        TYPE(GET)  NAME(nKourMer4)        FPOS(35, 2) FLEN( 6) PICTURE(&N 9.99)
      TYPE(END)
      TYPE(GET)      NAME(nKorSouAbs)     FPOS(25,12) FLEN(15) FCAPTION(Korig. souèinitel absorpce)   CPOS( 4,12) PICTURE(&N 9999.99)
      TYPE(GET)      NAME(nDovHodKou)     FPOS(25,13) FLEN(15) FCAPTION(Dovolená hodnota kouøivosti)  CPOS( 4,13) PICTURE(&N 9999.99)
      TYPE(COMBOBOX) NAME(cStavSacSo)     FPOS(25,14) FLEN(16) FCAPTION(Stav sací soustavy)           CPOS( 4,14) VALUES(VYHOVUJE:VYHOVUJE,NEVYHOVUJE:NEVYHOVUJE)
      TYPE(GET)      NAME(nRokVyroby)     FPOS(25,15) FLEN(15) FCAPTION(Rok výroby)                   CPOS( 4,15) PICTURE(&N 9999)
      TYPE(COMBOBOX) NAME(cKontrolZn)     FPOS(25,16) FLEN(16) FCAPTION(Kontrolní známka)             CPOS( 4,16) VALUES(VYLEPENA:VYLEPENA,NEVYLEPENA:NEVYLEPENA)

*   2.sloupec
      TYPE(COMBOBOX) NAME(cTypEmiSys)     FPOS(81, 2) FLEN(16) FCAPTION(Typ emisního systému)         CPOS(60, 2) VALUES(NEØÍZENÝ:NEØÍZENÝ,OXIDAÈNÍ:OXIDAÈNÍ)
      TYPE(GET)      NAME(cVolOtacPr)     FPOS(81, 3) FLEN(15) FCAPTION(Volnob. ot. pøedepsané)       CPOS(60, 3) PICTURE(&11X)
      TYPE(GET)      NAME(nVolOtacNa)     FPOS(81, 4) FLEN(10) FCAPTION(Volnob. ot. namìøené)         CPOS(60, 4) PICTURE(&N 999999)
      TYPE(TEXT)     CAPTION( min-1)      CPOS(93, 4) CLEN( 8)
      TYPE(GET)      NAME(cPreOtacPr)     FPOS(81, 5) FLEN(15) FCAPTION(Maximální ot. pøedepsané)     CPOS(60, 5) PICTURE(&11X)
      TYPE(GET)      NAME(nPreOtacNa)     FPOS(81, 6) FLEN(10) FCAPTION(Maximální ot. namìøené)       CPOS(60, 6) PICTURE(&N 999999)
      TYPE(TEXT)     CAPTION( min-1)      CPOS(93, 6) CLEN( 8)
      TYPE(GET)      NAME(nNamHodKou)     FPOS(81, 7) FLEN(15) FCAPTION(Namìøená kouøivost)           CPOS(60, 7) PICTURE(&N 9999.99)
    TYPE(END)

    TYPE(Static) STYPE(13) SIZE(103, 2.5) FPOS( 1,18.3) RESIZE(yn)
      TYPE(GET)  NAME(nOsPredEmi)        FPOS(25, 0.3) FLEN( 8) FCAPTION(Kdo pøedal)          CPOS( 4, 0.3) PICTURE(&N 99999)
      TYPE(TEXT) NAME(cPredalEmi)        CPOS(35, 0.3) CLEN(40) BGND( 13)
      TYPE(GET)  NAME(cPrevzalZa)        FPOS(25, 1.3) FLEN(20) FCAPTION(Kdo pøevzal)         CPOS( 4, 1.3)


    TYPE(END)
*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

  TYPE(TABPAGE) TTYPE(4) CAPTION(Emise-popis) FPOS(1,6)  OFFSET(50,34)) PRE( tabSelect)
    TYPE(TEXT) CAPTION( Zjištìné závady)     CPOS( 2, 1) CLEN( 20)
    TYPE(MLE) NAME(mZjistZava) FPOS(2,2) SIZE(100,18)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(END)

TYPE(End)