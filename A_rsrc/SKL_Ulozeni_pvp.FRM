TYPE(drgForm) DTYPE(10) TITLE(Pøehled míst uložení) SIZE(97,11.5) FILE(ULOZMIw);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n);
              POST( PostValidate)

  TYPE(Action) EVENT(SEPARATOR)
  TYPE(Action) CAPTION(~ULOŽIT)          EVENT(DoSave) TIPTEXT( Uložit ...)

  TYPE(Static) STYPE(12) SIZE(96.3,1.2) FPOS(0.5, 0.1) CTYPE(2) RESIZE(yn)
    TYPE(Text) CAPTION(Místa uložení pro sklad :) CPOS( 1, 0.05) CLEN( 22) FONT(2)
    TYPE(Text) NAME(M->Sklad)    CPOS( 25, 0.05) CLEN( 14) FONT(5) PP(2)
    TYPE(Text) NAME(M->NazSklad) CPOS( 39, 0.05) CLEN( 25) FONT(5) PP(2)
  TYPE(End)

*  TYPE(EBrowse) FILE(ULOZMIw) INDEXORD(1);
*               FIELDS( cUlozZbo             ,;
*                       SKL_NazevMista():Název místa uložení:26 ,;
*                       nUlozCelk            ,;
*                       nUlozMnoz:::::GET    ,;
*                       cPoznamka:::::GET    );
*               SIZE(96, 8.8) FPOS(0,1.3) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn)

  TYPE(EBrowse) FILE(ULOZMIw) INDEXORD(1);
               SIZE(96, 8.8) FPOS(0,1.3) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) POPUPMENU(yn)

    TYPE(TEXT) NAME( ULOZMIw->cUlozZbo)     CLEN(10)  CAPTION(Místo ulož. )
    TYPE(TEXT) NAME( SKL_NazevMista() )      CLEN(26)  CAPTION(Název místa uložení)
    TYPE(TEXT) NAME( ULOZMIw->nUlozCelk)    CLEN(13)  CAPTION(Ulož.celkem)
    TYPE(GET)  NAME( ULOZMIw->nUlozMnoz)    FLEN(13)  FCAPTION(Ulož.množ.)
    TYPE(MLE)  NAME( ULOZMIw->cPoznamka)    FLEN(15)  FCAPTION(Popis) SCROLL(nn)

*    TYPE(TEXT) NAME( ULOZENIw->cUlozZbo)     CLEN(10)  CAPTION(Místo ulož. )
*    TYPE(TEXT) NAME( SKL_NazevMista() )      CLEN(26)  CAPTION(Název místa uložení)
*    TYPE(TEXT) NAME( ULOZENIw->nUlozCelk)    CLEN(13)  CAPTION(Ulož.celkem)
*    TYPE(GET)  NAME( ULOZENIw->nUlozMnoz)    FLEN(13)  CAPTION(Ulož.množ.)
*    TYPE(MLE)  NAME( ULOZENIw->cPoznamka)    FLEN(15)  FCAPTION(Popis) SCROLL(nn)

  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(96.3,1.2) FPOS(0.5, 10.1) RESIZE(yn)
    TYPE(Text) CAPTION(CELKEM)     CPOS( 38, 0.1) CLEN(  7)
    TYPE(Text) NAME(M->nUlozMnoz)  CPOS( 48, 0.05) CLEN( 12) FONT(5) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(M->cWarning)   CPOS( 61, 0.05) CLEN( 25) FONT(5) PP(2)
  TYPE(End)