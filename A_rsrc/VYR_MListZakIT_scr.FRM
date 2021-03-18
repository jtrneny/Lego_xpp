TYPE(drgForm) DTYPE(10) TITLE(Mzdové lístky k položce zakázky) SIZE(110, 25) FILE(VyrZakIT );
               GUILOOK(Action:y,Message:y,IconBar:y,Menu:y)
*               CARGO( VYR_PolOPER_crd)

TYPE(Action) CAPTION(~info Zakázka)    EVENT(VYR_VYRZAK_INFO)    TIPTEXT(Informaèní karta výrobní zakázky )
TYPE(Action) CAPTION(info ~Položka.)   EVENT(VYR_VYRZAKIT_INFO)  TIPTEXT(Informaèní karta položky výrobní zakázky )
TYPE(Action) CAPTION(~Zrušení lístkù)  EVENT(MListZAKIT_del)     TIPTEXT(Zrušení mzdových lístkù na položku zakázky)

* VYRÁBÌNÁ POLOŽKA
  TYPE(Static) STYPE(12) SIZE(109,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS( 2, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZakIT->cCisZakaz)     CPOS( 2, 1.2) CLEN( 35) BGND(13) FONT(5) GROUPS(clrGREEN)
    TYPE(Text) CAPTION(Vyrábìná položka)   CPOS(38, 0.2) CLEN( 16) FONT(2)
    TYPE(Text) NAME(VyrZakIT->cVyrPOL)       CPOS(38, 1.2) CLEN( 20) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název položky)      CPOS(59, 0.2) CLEN( 25) FONT(2)
*    TYPE(Text) NAME(VyrPOL->cNazev)        CPOS(59, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta)           CPOS(100, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZakIT->nVarCis)       CPOS(100, 1.2) CLEN(  8) BGND(13) FONT(5) CTYPE(2) GROUPS(clrGREY)
  TYPE(End)

* OPERACE k vyrábìné položce
  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1);
                FIELDS( nOrdItem      ,;
                        cVyrobCisl    ,;
                        nMnozPlano:Množství   ,;
                        cBarva:Barva vnìjší   ,;
                        cBarva_2:Barva vnitøní,;
                        nRozm_vys    ,;
                        nRozm_sir    ,;
                        nRozm_del    ,;
                        cRozm_MJ     ,;
                        cCisZakazI   ,;
                        cNazevZak1::30 );
                FPOS( 0, 3) SIZE(110, 11.5) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Popis operace
TYPE(TabPage) CAPTION(Mzdové lístky) FPOS(0.5, 14.7) SIZE(109, 10.3) RESIZE(yx) OFFSET(1,82)
*  TYPE(MLE) NAME('POLOPER->mPolOper') FPOS( 1, 0.2) SIZE( 106, 6) RESIZE(yx) READONLY(y)

  TYPE(DBrowse) FILE(LISTHD) INDEXORD(9);
                FIELDS( nPorCisLis  ,;
                        cCisZakazI::20   ,;
                        cStred      ,;
                        cOznPrac    ,;
                        cNazOper::25    ,;
                        nRokVytvor:Rok  ,;
                        ML_uzavren():Uzv:1::2 );
                SIZE(108, 8.7) CURSORMODE(3) PP(7) SCROLL(ny)
*                ITEMMARKED( ItemMarked)

TYPE(End)

* Majetek operace
*TYPE(TabPage) CAPTION( Majetek operace) FPOS(1, 17.2) SIZE(108, 7.5) RESIZE(yx) OFFSET(18,66)

*  TYPE(DBrowse) FILE(MajOPER) INDEXORD(2);
*                FIELDS( nInvCis          ,;
*                        cDruhMaj         ,;
*                        C_MAJ->cTypMaj   ,;
*                        C_MAJ->cNazevMaj ,;
*                        nMnozMaj         ,;
*                        nCasNorMaj       ,;
*                        cKodCasMaj       ,;
*                        cKodKoeCas       );
*                SIZE(108, 6) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny)

*TYPE(End)