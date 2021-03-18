TYPE(drgForm) DTYPE(10) TITLE( Likvidace dle majetku) SIZE(110,26) ;
              GUILOOK(Action:y,Menu:y)

TYPE(Action) CAPTION( info ~Majetku) EVENT(HIM_MAJ_INFO) TIPTEXT(informaèní karta investièního majetku  )

* Seznam majetku
  TYPE(DBrowse) FILE(MAJ) INDEXORD(1);
                FIELDS( NTYPMAJ:Typ,;
                        NINVCIS,;
                        CNAZEV,;
                        NCENAVSTU,;
                        NOPRUCT,;
                        NCENAVSTD,;
                        NOPRDAN ) ;
                FPOS(0,.1) SIZE(110,7.9) CURSORMODE(3)  SCROLL(ny) PP(7) POPUPMENU(y);
                ITEMMARKED(itMarked_MAJ)

* Pohybové doklady
  TYPE(Text) CAPTION( Pohybové doklady) CPOS( 0.5,8.1) CLEN( 109) FONT(5) CTYPE(1)
  TYPE(DBrowse) FILE(ZMAJU) INDEXORD(1);
                FIELDS( nDoklad    ,;
                        cObdobi    ,;
                        nInvCis    ,;
                        nTypMaj    ,;
                        cTypPohybu:Pohyb ,;
                        C_TypPoh->cNazTypPoh:Název pohybu ) ;
                FPOS(0,9.2) SIZE(110,7.9) CURSORMODE(3)  SCROLL(ny) PP(7) RESIZE(yx);
                ITEMMARKED(itMarked_ZMAJU)

* Zaúètování  dokladu
  TYPE(Text) CAPTION( Likvidace dokladu)   CPOS( 0.5,17.1) CLEN( 109) FONT(5) CTYPE(1)
  TYPE(DBrowse) FILE(UCETPOL) INDEXORD(1);
                FIELDS( cUcetMD ,;
                        cUcetDAL,;
                        nKcMD   ,;
                        nKcDAL  ,;
                        cText   ,;
                        nDoklad );
                FPOS(0,18.2) SIZE(110,5.2)  RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)

* Nákladová struktura
  TYPE(Static) STYPE(11) SIZE(109,2.4) FPOS(0.5,23.5) RESIZE(yx) CTYPE(2)
    TYPE(Text) CAPTION(Výr.støed.)           CPOS( 2, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)       CPOS( 2,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výrobek)             CPOS(18, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)       CPOS(18,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Zakázka)             CPOS(34, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)       CPOS(34,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výr. místo)          CPOS(50, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)       CPOS(50,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Stroj)               CPOS(66, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)       CPOS(66,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)
    TYPE(Text) FCAPTION(Výr. operace)        CPOS(82, .2)          BGND( 1) PP(3)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)       CPOS(82,1.2) CLEN(15) BGND(13) PP(2) GROUPS(clrGREEN)

  TYPE(End)