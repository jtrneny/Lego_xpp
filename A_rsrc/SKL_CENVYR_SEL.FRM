TYPE(drgForm) DTYPE(10) TITLE(Skladové položky - VÝBÌR) SIZE(110, 23.5);
               GUILOOK(Action:y,Message:n,IconBar:y:drgBrowseIconBar,Menu:n)

TYPE(Action) CAPTION(info C~eník)       EVENT( SKL_CENZBOZ_INFO) TIPTEXT(Informaèní karta skladové položky)
TYPE(Action) CAPTION(info V~yr.pol.)    EVENT( VYR_VYRPOL_INFO)  TIPTEXT(Informaèní karta vyrábìné položky)
TYPE(Action) CAPTION(kopie ~Z položky)  EVENT( KusOp_Copy)       TIPTEXT(Kopie kusovníku a operací z vyrábìné položky )

* SKLAD
*  TYPE(Static) STYPE(1) SIZE(108,1.8) FPOS(1,0.2) RESIZE(yn)
*    TYPE(Text) CAPTION(SKLAD)              CPOS(  1, 0.3) CLEN(  8) FONT(2)
*    TYPE(Text) NAME(CenZBOZ->cCisSklad)    CPOS( 10, 0.3) CLEN( 10) BGND( 13) FONT(5) PP(2) GROUPS(clrGREEN)
*    TYPE(Text) NAME(C_Sklady->cNazSklad)   CPOS( 22, 0.3) CLEN( 80) BGND( 13) FONT(5) PP(2) GROUPS(clrGREEN)
*  TYPE(End)

TYPE(TabPage) TTYPE(4) CAPTION(Z ceníku zboží) FPOS(0,0.1) SIZE( 109.5, 23) RESIZE(yy) OFFSET(1,80) PRE( tabSelect)

  TYPE(DBrowse) FILE(CENZBOZ) INDEXORD(1) ;
                FIELDS( CCISSKLAD      ,;
                        CSKLPOL        ,;
                        CNAZZBO::30    ,;
                        nZboziKat:Kat.zboží,;
                        nMnozSZBO      ,;
                        cZkratJedn:MJ  ,;
                        nCenaSZBO      ,;
                        nCenaPZBO      ,;
                        nCenaNZBO       );
                FPOS( 0, 0) SIZE(110,12.5) CURSORMODE(3) RESIZE(yy) PP(7) SCROLL(yy);
                ITEMSELECTED( RecordSelected) POPUPMENU(yy)

  TYPE(Static) STYPE(1) SIZE(108, 9) FPOS(1,12.5) RESIZE(yx)
*   1.ø.
    TYPE(Text) CAPTION(Sklad. položka)     CPOS(  1, 0.2) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cSklPol)      CPOS(  1, 1.2) CLEN( 20) BGND( 13) PP(2) FONT( 5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název zboží 2)      CPOS( 22, 0.2) CLEN( 30)
    TYPE(Text) NAME(CENZBOZ->cNazZbo2)     CPOS( 22, 1.2) CLEN( 35) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Kateg.)             CPOS( 58, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nZboziKat)    CPOS( 58, 1.2) CLEN(  6) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) NAME(C_KatZbo->cNazevKat)   CPOS( 64, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Úè.sk.)             CPOS( 83, 0.2) CLEN(  6)
    TYPE(Text) NAME(CENZBOZ->nUcetSkup)    CPOS( 83, 1.2) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) NAME(C_UctSkp->CNAZUCTSK)   CPOS( 88, 1.2) CLEN( 18) BGND( 13) PP(2) GROUPS(clrGREEN)
* 2.ø.
    TYPE(Text) CAPTION(Typ ceny)          CPOS(  1, 2.4) CLEN(  8)
    TYPE(Text) NAME(CENZBOZ->cTypSklCen)  CPOS(  1, 3.4) CLEN(  8) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skl. cena)         CPOS( 11, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaSZBO)   CPOS( 11, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(CENZBOZ->cZkratMeny)  CPOS( 24, 3.4) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Množ. na skladì)   CPOS( 31, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nMnozSZBO)   CPOS( 31, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) NAME(CENZBOZ->cZkratJedn)  CPOS( 44, 3.4) CLEN(  4) BGND( 13) PP(2)
    TYPE(Text) CAPTION(Skl. cena CELK)    CPOS( 50, 2.4) CLEN( 13)
    TYPE(Text) NAME(CENZBOZ->nCenaCZBO)   CPOS( 50, 3.4) CLEN( 13) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Jakost)            CPOS( 70, 2.4) CLEN( 10)
    TYPE(Text) NAME(CENZBOZ->cJakost)     CPOS( 70, 3.4) CLEN( 25) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)

* 3.ø.
    TYPE(Text) CAPTION(Mn. k dispozici)   CPOS(  1, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozDZBO)   CPOS(  1, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. rezervované)   CPOS( 15, 4.6) CLEN( 14)
    TYPE(Text) NAME(CENZBOZ->nMnozRZBO)   CPOS( 15, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. objednané)     CPOS( 29, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozOZBO)   CPOS( 29, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. k objednání)   CPOS( 43, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nMnozKZBO)   CPOS( 43, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Cena bez danì)     CPOS( 64, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaPZBO)   CPOS( 64, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION( DPH )             CPOS( 77, 4.6) CLEN(  5)
    TYPE(Text) NAME(C_DPH->nProcDph)      CPOS( 77, 5.6) CLEN(  5) BGND( 13) PP(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(%)                 CPOS( 82, 5.6) CLEN(  2)
    TYPE(Text) CAPTION(Cena s daní)       CPOS( 85, 4.6) CLEN( 12)
    TYPE(Text) NAME(CENZBOZ->nCenaMZBO)   CPOS( 85, 5.6) CLEN( 12) CTYPE(2) BGND( 13) PP(2) GROUPS(clrGREY)
* 4.ø.
    TYPE(Text) CAPTION(Typ èár.kódu)        CPOS(  1, 6.8) CLEN( 15)
    TYPE(Text) NAME(CENZBOZ->cZkrCarKod)    CPOS(  1, 7.8) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èárový kód)          CPOS( 22, 6.8) CLEN( 10)
    TYPE(Text) NAME(CENZBOZ->cCarKod)       CPOS( 22, 7.8) CLEN( 85) BGND(13) FONT(5) GROUPS(clrGREY)

  TYPE(End)


TYPE(END)

TYPE(TabPage) TTYPE(4) CAPTION(Z vyrábìných pol.) FPOS(0,0.1) SIZE( 109.5, 23) RESIZE(yy) OFFSET(20,63) PRE( tabSelect)

TYPE(DBrowse) FILE(VYRPOL) INDEXORD( 3) ;
              FIELDS( cCisSklad,;
                      cSklPol  ,;
                      cCisVyk  ,; 
                      cCisZakaz,;
                      cVyrPol  ,;
                      cNazev   ,;
                      nVarCis  ,;
                      cVarPop  );
              FPOS( 0, 0) SIZE(110,14.5) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y) ;
              ITEMMARKED(ItemMarked)

*  TYPE(ComboBox) NAME(M->nFILTER)  FPOS(80, .2) FLEN(28) VALUES( 1:Všechny nezakázkové,2:Všechny nabídkové,3:Nabídkové k dané firmì) ITEMSELECTED(comboItemSelected) PP(2)

  TYPE(Static) STYPE(1) SIZE(108, 7) FPOS(1,14.5) Resize(nn)
*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(VYRPOL->cCisZakaz)        CPOS(  3, 1.5)   CLEN( 15) BGND( 13) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Vyr. položka)          CPOS( 20, 0.5)   CLEN( 15) FONT(5)
    TYPE(Text) NAME(VYRPOL->cVyrPol)          CPOS( 20, 1.5)   CLEN( 15) BGND( 13) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Název položky)         CPOS( 37, 0.5)   CLEN( 30)
    TYPE(Text) NAME(VYRPOL->cNazev)           CPOS( 37, 1.5)   CLEN( 30) BGND( 13) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Var.)                  CPOS( 69, 0.5)   CLEN(  5)
    TYPE(Text) NAME(VYRPOL->nVarCis)          CPOS( 69, 1.5)   CLEN(  5) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Popis varianty)        CPOS( 76, 0.5)   CLEN( 20)
    TYPE(Text) NAME(VYRPOL->cVarPop)          CPOS( 76, 1.5)   CLEN( 23) BGND( 13) GROUPS(clrGREY)
*   2.øádek
    TYPE(Text) CAPTION(Obch. oznaèení)        CPOS(  3, 2.5)   CLEN( 15)
    TYPE(Text) NAME(VYRPOL->cSklPol)          CPOS(  3, 3.5)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Sklad)                 CPOS( 20, 2.5)   CLEN(  8)
    TYPE(Text) NAME(VYRPOL->cCisSklad)        CPOS( 20, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Typ pol.)              CPOS( 30, 2.5)   CLEN(  8)
    TYPE(Text) NAME(VYRPOL->cTypPol)          CPOS( 30, 3.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skupina pol.)          CPOS( 40, 2.5)   CLEN( 12)
    TYPE(Text) NAME(VYRPOL->cSkuPol)          CPOS( 40, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(MJ)                    CPOS( 54, 2.5)   CLEN(  3)
    TYPE(Text) NAME(VYRPOL->cZkratJedn)       CPOS( 54, 3.5)   CLEN(  3) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Úè.výrobek)            CPOS( 59, 2.5)   CLEN( 10)
    TYPE(Text) NAME(VYRPOL->cNazPol2)         CPOS( 59, 3.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stø. výrobní)          CPOS( 71, 2.5)   CLEN( 12)
    TYPE(Text) NAME(VYRPOL->cStrVyr)          CPOS( 71, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stø. odvádìní)         CPOS( 85, 2.5)   CLEN( 12)
    TYPE(Text) NAME(VYRPOL->cStrOdv)          CPOS( 85, 3.5)   CLEN( 12) BGND( 13) GROUPS(clrGREY)
*   3.øádek
    TYPE(Text) CAPTION(Èíslo výkresu)         CPOS(  3, 4.5)   CLEN( 26)
    TYPE(Text) NAME(VYRPOL->cCisVyk)          CPOS(  3, 5.5)   CLEN( 26) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Ek.dávka)              CPOS( 31, 4.5)   CLEN(  8)
    TYPE(Text) NAME(VYRPOL->nEkDav)           CPOS( 31, 5.5)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èistá hm.(kg))         CPOS( 41, 4.5)   CLEN( 13)
    TYPE(Text) NAME(VYRPOL->nCisHm)           CPOS( 41, 5.5)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav )                 CPOS( 55, 4.5)   CLEN(  5)
    TYPE(Text) NAME(VYRPOL->cStav)            CPOS( 55, 5.5)   CLEN(  4) BGND( 13) GROUPS(clrGREY)

  TYPE(End)

TYPE(END)

TYPE(ComboBox) NAME(M->nFILTER)  FPOS(78, 0.1) FLEN(28) VALUES( 1:Všechny nezakázkové,2:Všechny nabídkové,3:Nabídkové k dané firmì) ITEMSELECTED(comboItemSelected) PP(2)

