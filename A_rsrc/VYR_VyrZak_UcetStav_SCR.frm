TYPE(drgForm) DTYPE(10) TITLE(Úèetní stav zakázky) FILE(UCETPOL);
              SIZE(110,24) GUILOOK(Action:n,IconBar:y)

* Výrobní zakázka
  TYPE(Static) STYPE(12) SIZE(107,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)          CPOS( 2, 0.2) CLEN(  8) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cCisZakaz)   CPOS( 2, 1.2) CLEN( 40) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Název zakázky)    CPOS(44, 0.2) CLEN( 15) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cNazevZak1)  CPOS(44, 1.2) CLEN( 45) BGND(13) FONT(5) GROUPS(clrBLUE)
    TYPE(Text) CAPTION(Stav)             CPOS(91, 0.2) CLEN(  6) FONT( 2)
    TYPE(Text) NAME(VYRZAK->cStavZakaz)  CPOS(91, 1.2) CLEN(  4) BGND(13) FONT(5) GROUPS(clrBLUE)
  TYPE(End)

*  TYPE(Static) STYPE(12) SIZE(99,1.2) FPOS(0.5,3) RESIZE(yn) CTYPE(2)
*    TYPE(Text) CAPTION( Úèetní náklady na zakázce)   CPOS( 0.5,0.1) CLEN( 98) FONT(5) CTYPE(1)
*  TYPE(End)

*  TYPE(Static) STYPE(12) SIZE(99,1.2) FPOS(0.5,14.6) RESIZE(yn) CTYPE(2)
*    TYPE(Text) CAPTION( Úèetní tržby na zakázce)   CPOS( 0.5,0.1) CLEN( 98) FONT(5) CTYPE(1)
*  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Náklady) OFFSET(1,87) FPOS(0.75,4.5) SIZE(108,20.15) RESIZE(yx)

  TYPE(DBrowse) FILE(UCETPOL) FPOS(0.1, 0.3) FIELDS(cObdobi:Období       , ;
                                                    nDoklad:ÈDokladu     , ;
                                                    nORDITEM:ÈPoložky    , ;
                                                    cTEXT:Text položky:40, ;
                                                    cUCETMD:SuAu_Ø       , ;
                                                    nKCMD:KÈ_md          , ;
                                                    nKCDAL:KÈ_dal        , ;
                                                    cUCETDAL:SuAu_S      , ;
                                                    cNazPol1:Støedisko   , ;
                                                    cNazPol2:Výrobek     , ;
                                                    cNazPol3:Zakázka     ) ;
                SIZE(107,18.0) CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yy) FOOTER(Y)

  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)


* 2
TYPE(TabPage) TTYPE(4) CAPTION(Tržby) OFFSET(13,75) FPOS(0.75,4.5) SIZE(108,20.15)  RESIZE(yx)

  TYPE(DBrowse) FILE(UCETPOLw) FPOS(0.1, 0.3) FIELDS(cObdobi:Období       , ;
                                                      nDoklad:ÈDokladu     , ;
                                                      nORDITEM:ÈPoložky    , ;
                                                      cTEXT:Text položky:40, ;
                                                      cUCETMD:SuAu_Ø       , ;
                                                      nKCMD:KÈ_md          , ;
                                                      nKCDAL:KÈ_dal        , ;
                                                      cUCETDAL:SuAu_S      , ;
                                                      cNazPol1:Støedisko   , ;
                                                      cNazPol2:Výrobek     , ;
                                                      cNazPol3:Zakázka     ) ;
                SIZE(107,18.0) CURSORMODE(3) PP(7) SCROLL(ny)  RESIZE(yy) FOOTER(Y)
  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)


* 3
TYPE(TabPage) TTYPE(4) CAPTION(Režie) OFFSET(25,63) FPOS(0.75,4.5) SIZE(108,20.15) RESIZE(yx)


  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
TYPE(End)
