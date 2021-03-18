TYPE(drgForm) DTYPE(10) TITLE(Kopírování operací) SIZE(110,25) FILE(PolOPER);
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n);
              POST( PostValidate)

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
* TYPE(Action) CAPTION(~Návrh kopír.>> ) EVENT(SubMenu_COPY)     TIPTEXT(Typ kopírování operací)
* TYPE(Action) CAPTION(~Vyber všechny)  EVENT(POLOPER_Sel_ALL)  TIPTEXT(Vybere všechny operace ke kopírování)
* TYPE(Action) CAPTION(~Vyber 1 : N)    EVENT(POLOPER_Sel_1kuN) TIPTEXT(Vybere a ze zdrojové operace vytvoøí n-cílových operací)
TYPE(Action) CAPTION(~Detail operace) EVENT(VYR_POLOPER_INFO) TIPTEXT(Detail operace k vyrábìné položce)

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kopíruj operace) EVENT(POLOPER_copy) TIPTEXT(Nakopíruje vybrané operace k dané položce)

* Zdroj kopírování operací
  TYPE(Static) STYPE(13) SIZE(110,2.6) FPOS(0, 0) RESIZE(yn)  GROUPS(clrGREEN)
    TYPE(Text) CAPTION(ZDROJ :)          CPOS(  1, 0.2) CLEN(  8) FONT(5) 
    TYPE(Text) CAPTION(Výrobní zakázka)  CPOS( 10, 0.2) 
    TYPE(GET)  NAME(M->cZak_src)         FPOS( 25, 0.2) FLEN( 30) PP(2) PUSH(VYR_VYRPOL_SEL)
    TYPE(Text) NAME(M->cZakNaz_src)      CPOS( 57, 0.2) CLEN( 40) BGND( 13) FONT(5) PP(2)

    TYPE(Text) CAPTION(Vyrábìná položka) CPOS( 10, 1.2) CLEN( 15)
    TYPE(GET)  NAME(M->cPol_src)         FPOS( 25, 1.2) FLEN( 30) PP(2) PUSH(VYR_VYRPOL_SEL)
    TYPE(Text) NAME(M->cPolNaz_src)      CPOS( 57, 1.2) CLEN( 40) BGND( 13) FONT(5) PP(2)
  TYPE(End)

* Cíl operací
  TYPE(Static) STYPE(13) SIZE(110,2.6) FPOS(0, 13.3) RESIZE(yn)
    TYPE(Text) CAPTION(CÍL :)          CPOS(  1, 0.2) CLEN( 8) FONT(5)
    TYPE(GET)  NAME(M->cZak_trg)       FPOS( 25, 0.2) FLEN( 30) FCAPTION( Výrobní zakázka) CPOS(10, 0.2) PP(2)
    TYPE(Text) NAME(M->cZakNaz_trg)    CPOS( 57, 0.2) CLEN( 40) BGND( 12) FONT(5) PP(2)
    TYPE(GET)  NAME(M->cPol_trg)       FPOS( 25, 1.2) FLEN( 30) FCAPTION( Vyrábìná položka) CPOS(10, 1.2) PP(2)
    TYPE(Text) NAME(M->cPolNaz_trg)    CPOS( 57, 1.2) CLEN( 40) BGND( 12) FONT(5) PP(2)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 109,10.5) FPOS(0.5, 2.7) RESIZE(yn) 
    TYPE(DBrowse) FILE(polOper_se) INDEXORD(1)       ;
                 FIELDS( ccisZakaz:èíslZak:20      , ;
                         cVyrPol:vyrPol            , ;
                         nCisOper:èíslOp           , ;
                         nUkonOper:úkon            , ;
                         nVarOper:var              , ;
                         cOznOper:typOp:10         , ;
                         nCelkKusCa:Kusový èas:12  , ;
                         npriprCas:Pøípravný èas:10, ;
                         nKcNaOper:cenaOper:11     , ;
                         mpolOper:Popis operace:25 , ; 
                         M->polOper_se_nazOper:Název operace:25 );
                 FPOS( 0.2, 0.1) SIZE( 109, 10.3 ) RESIZE(yx) CURSORMODE(3) SCROLL(yy) PP(7) POPUPMENU(y) 
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 109, 8.9) FPOS(0.5, 16) RESIZE(yy)
*    TYPE(EBrowse) FILE(PolOPER_w2) INDEXORD(1) ;
*                 FIELDS( nCisOper:::::GET   ,;
*                         nUkonOper:::::GET  ,;
*                         nVarOper:::::GET   ,;
*                         cOznOper   ,;
*                         nCelkKusCa ,;
*                         nKcNaOper  ,;
*                         Operace->cNazOper,;
*                         Operace->cOznOper  );
*                 FPOS( 0.2, 0.1) SIZE( 109, 8.7 ) RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7)

    TYPE(EBrowse) FILE(PolOPER_w2) INDEXORD(1) ;
                 FPOS( 0.2, 0.1) SIZE( 109, 8.7 ) RESIZE(yy) CURSORMODE(3) SCROLL(yy) PP(7)

      TYPE(TEXT) NAME(M->polOper_w2_porCisLis)  CLEN( 3) CAPTION() BITMAP()

      TYPE(GET)  NAME( PolOPER_w2->nCisOper)    FLEN( 5)  CAPTION( È.oper. )
      TYPE(GET)  NAME( PolOPER_w2->nUkonOper)   FLEN( 5)  CAPTION( Úkon    )
      TYPE(GET)  NAME( PolOPER_w2->nVarOper)    FLEN( 5)  CAPTION( Var.    )

      TYPE(TEXT) NAME( PolOPER_w2->cOznOper)    CLEN(15)  CAPTION(Typová operace)
      TYPE(TEXT) NAME( PolOPER_w2->nCelkKusCa)  CLEN(15)  CAPTION(Kusový èas)
      TYPE(TEXT) NAME( PolOPER_w2->nPriprCas)   CLEN(15)  CAPTION(Pøípravný èas)
      TYPE(TEXT) NAME( PolOPER_w2->nkcNaOper)   CLEN(13)  CAPTION(Cena operace)
      TYPE(TEXT) NAME( PolOPER_w2->mpolOper)    CLEN(25)  CAPTION(Popis operace)
      TYPE(TEXT) NAME( M->polOper_w2_nazOper)   CLEN(25)  CAPTION(Název operace)
    TYPE(End)

  TYPE(End)