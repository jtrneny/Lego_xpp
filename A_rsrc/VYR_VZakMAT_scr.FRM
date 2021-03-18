TYPE(drgForm) DTYPE(10) TITLE(Materiál pro zakázku) SIZE(100, 25) FILE( OBJITEM);
               GUILOOK(Action:y,Message:n,IconBar:y,Menu:y);
               POST( PostValidate)

TYPE(Action) CAPTION(info ~Zakázka)  EVENT(VYR_VYRZAK_INFO)  TIPTEXT(Informaèní karta výrobní zakázky)
TYPE(Action) CAPTION(info ~Položka)  EVENT(VYR_VYRPOL_INFO)  TIPTEXT(Informaèní karta vyrábìné položky)
TYPE(Action) CAPTION(info C~eník )   EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta materiálu z ceníku)

* VÝROBNÍ ZAKÁZKA
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS( 2, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZAK->cCisZakaz)     CPOS( 2, 1.2) CLEN( 40) BGND(13) FONT(5) PP(2) GROUPS(clrINFO)
    TYPE(Text) CAPTION(Název zakázky)      CPOS(44, 0.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)    CPOS(44, 1.2) CLEN( 50) BGND(13) FONT(5) PP(2) GROUPS(clrINFO)

    TYPE(CHECKBOX) NAME(M->lno_mnozOBodb_0)  FPOS(74,.2) FLEN(20) VALUES(F: - komplentí seznam,T: - bez nulových Položek )

  TYPE(End)

* MATERIÁL ( obj.pøijaté) pro zakázku
  TYPE(DBrowse) FILE(OBJITEM) INDEXORD(10);
               FIELDS( cNazZbo:Název zboží            ,;
                       cSklPol:Skladová položka       ,;
                       nMnozObOdb:Mn.objednané odb.   ,;
                       nMnozReOdb:Mn.rezervované odb. ,;
                       nPocCeZapZ:ÈD                  ,;
                       cVyrPol:Vyr. položka           ,;
                       nVarCis:Var.                   ,;
                       M->NazVyrPol:Název vyr.položky:40 ,;
                       nMnozKoDod:Mn.k objednání dod. ,;
                        );
               FPOS( 0, 14) SIZE(100, 10) CURSORMODE(3) PP(7) Resize(ny) SCROLL(yy) POPUPMENU(yn) LFREEZE(1);
               ITEMMARKED( ItemMarked)

  TYPE(Static) STYPE(12) SIZE(99,10.8) FPOS(0.5, 3) RESIZE(yn) CTYPE(2)
*   1.sl.
    TYPE(GET)      NAME(cSklPol)              FPOS(16, 0.6) FLEN( 20) FCAPTION(Skladová položka)     CPOS( 1, 0.6) PP(2) PUSH(SKL_CENZBOZ_SEL)
    TYPE(Text)     NAME(cNazZbo)              CPOS(38, 0.6) CLEN( 58) BGND(13) PP(2) FONT(5)
    TYPE(GET)      NAME(dDatDoOdb)            FPOS(16, 2.2) FLEN( 20) FCAPTION(Datum vydodání)       CPOS( 1, 2.2) PUSH( ClickDate)
    TYPE(GET)      NAME(nPozice)              FPOS(16, 3.2) FLEN( 20) FCAPTION(Pozice)               CPOS( 1, 3.2)
    TYPE(GET)      NAME(cKodPoz)              FPOS(16, 4.2) FLEN( 20) FCAPTION(Kód pozice)           CPOS( 1, 4.2)
    TYPE(GET)      NAME(cVyrPol)              FPOS(16, 5.2) FLEN( 20) FCAPTION(Vyrábìná položka)     CPOS( 1, 5.2) PUSH(VYR_VyrPol_sel)
    TYPE(GET)      NAME(nVarCis)              FPOS(16, 6.2) FLEN( 20) FCAPTION(Varianta položky)     CPOS( 1, 6.2)
    TYPE(GET)      NAME(cStred)               FPOS(16, 7.2) FLEN( 20) FCAPTION(Støed. požadující)    CPOS( 1, 7.2)
    TYPE(GET)      NAME(nMnKalkul)            FPOS(16, 8.2) FLEN( 20) FCAPTION(Kalkulaèní mn.)       CPOS( 1, 8.2) PP(2)
    TYPE(GET)      NAME(nMnNaKus)             FPOS(16, 9.2) FLEN( 20) FCAPTION(Množství na kus)      CPOS( 1, 9.2)
*   2.sl.
    TYPE(GET)      NAME(nMnozObOdb)           FPOS(55, 2.2) FLEN( 13) FCAPTION(Objednáno odbìr.)     CPOS(39, 2.2) PP(2)
    TYPE(GET)      NAME(nMnozPoOdb)           FPOS(55, 3.2) FLEN( 13) FCAPTION(Potvrzeno odbìr.)     CPOS(39, 3.2)
    TYPE(GET)      NAME(nMnozVpInt)           FPOS(55, 4.2) FLEN( 13) FCAPTION(Množ. k výrobì)       CPOS(39, 4.2)
    TYPE(GET)      NAME(nMnPotVyr)            FPOS(55, 5.2) FLEN( 13) FCAPTION(Potvrzeno výrobou)    CPOS(39, 5.2)
    TYPE(GET)      NAME(nDelka)               FPOS(55, 6.2) FLEN( 13) FCAPTION(Délka)                CPOS(39, 6.2)
    TYPE(GET)      NAME(nPocet)               FPOS(55, 7.2) FLEN( 13) FCAPTION(Poèet)                CPOS(39, 7.2)
    TYPE(GET)      NAME(cText1)               FPOS(55, 8.2) FLEN( 40) FCAPTION(Poznámky)             CPOS(39, 8.2)
    TYPE(GET)      NAME(cText2)               FPOS(55, 9.2) FLEN( 40)
*   3.sl
    TYPE(Text)    CAPTION(Skladová cena)      CPOS( 83, 2.2) CLEN( 12)
    TYPE(Text)    CAPTION(- za MJ    :)       CPOS( 74, 3.2) CLEN(  9)
    TYPE(Text)    CAPTION(- CELKEM :)         CPOS( 74, 4.2) CLEN(  9)
    TYPE(Text)    NAME(nCenNapDod)            CPOS( 83, 3.2) CLEN( 13) BGND(13) PP(2) CTYPE(2) PICTURE( @N 999 999 999.99)
    TYPE(Text)    NAME(M->SklCena_CELK)       CPOS( 83, 4.2) CLEN( 13) BGND(13) PP(2) CTYPE(2) PICTURE( @N 999 999 999.99)

  TYPE(End)