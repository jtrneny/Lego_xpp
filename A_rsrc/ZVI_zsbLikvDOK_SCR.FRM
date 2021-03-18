TYPE(drgForm) DTYPE(10) TITLE( ZVI - Likvidace dle dokladu ) SIZE(100,25) ;
              GUILOOK(Action:y)

TYPE(Action) CAPTION(~Pøeúètuj) EVENT(PREUCTUJ) TIPTEXT(Pøeúètování vybraných zásobových dokladù )              

* Seznam dokladù
  TYPE(DBrowse) FILE( ZvZmenHD)  INDEXORD(3);
                FIELDS( nDoklad,;
                        nOrdItem,;
                        nObdobi,;
                        nRok,;
                        cNazPol1,;
                        cNazPol4,;
                        nZvirKat,;
                        nUcetSkup,;
                        cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu);
                FPOS(0,.1) SIZE(100,13.8) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
                ITEMMARKED(itemMarked)

* Zaúètování dokladu
  TYPE(Static) STYPE(13) SIZE(99, 1) FPOS( 0, 14) RESIZE(yx)
    TYPE(Text) CAPTION(Zaúètování dokladu) CPOS( 0, 0) CLEN( 99) CTYPE(3) FONT(5)
  TYPE(End)

  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                FIELDS( nDoklad:Doklad  ,;
                        nOrdItem:Poø.   ,;
                        cObdobi:Období  ,;
                        cUcetMD    ,;
                        cUcetDAL   ,;
                        nKcMD      ,;
                        nKcDAL     ,;
                        nMnozNat:Naturální mn.1   ,;
                        cZkratJedn:MJ_1 ,;
                        nMnozNat2:Naturální mn.2  ,;
                        cZkratJed2:MJ_2 );
                FPOS(0,15) SIZE(100, 7) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)

* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(98,2.8) FPOS(1,22.1) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Výr.støed.)           CPOS( 3, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS( 3,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
    TYPE(Text) FCAPTION(Výrobek)             CPOS(18, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(18,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
    TYPE(Text) FCAPTION(Zakázka)             CPOS(33, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(33,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
    TYPE(Text) FCAPTION(Výr. místo)          CPOS(48, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(48,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
    TYPE(Text) FCAPTION(Stroj)               CPOS(63, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(63,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
    TYPE(Text) FCAPTION(Výr. operace)        CPOS(78, .2)          BGND( 1)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(78,1.2) CLEN(12) BGND(13) GROUPS( clrGREY)
  TYPE(End)