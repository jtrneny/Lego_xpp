TYPE(drgForm) DTYPE(10) TITLE( Nastavení exportu lístkù do ÚÈTA) SIZE( 70, 20);
              GUILOOK( Menu:y)

*  TYPE(EBrowse) FILE(C_ExpML)  INDEXORD(1);
*                FIELDS( nRok:::::GET    ,;
*                        nPruchod:::::GET,;
*                        cDenik:::::GET  ,;
*                        cUcetMD:::::GET ,;
*                        cUcetDAL:::::GET,;
*                        nProc:::::GET   ,;
*                        cText:::::GET   );
*                FPOS(0,0) SIZE( 70, 20) CURSORMODE(3) SCROLL(ny) PP(7)

  TYPE(EBrowse) FILE(C_ExpML)  INDEXORD(1);
                FPOS(0,0) SIZE( 70, 20) CURSORMODE(3) SCROLL(ny) PP(7)

    TYPE(GET) NAME( C_ExpML->nRok)        FPOS( 1,0) FLEN( 5)  CAPTION( Rok )
    TYPE(GET) NAME( C_ExpML->nPruchod)    FPOS( 2,0) FLEN( 5)  CAPTION( Prùchod )
    TYPE(GET) NAME( C_ExpML->cDenik)      FPOS( 3,0) FLEN( 4)  CAPTION( Deník )
    TYPE(GET) NAME( C_ExpML->cUcetMD)     FPOS( 4,0) FLEN( 8)  CAPTION( Úèet_MD )
    TYPE(GET) NAME( C_ExpML->cUcetDAL)    FPOS( 5,0) FLEN( 8)  CAPTION( Úèet_DAL )
    TYPE(GET) NAME( C_ExpML->nProc)       FPOS( 6,0) FLEN( 7)  CAPTION( Proc. )
    TYPE(GET) NAME( C_ExpML->cText)       FPOS( 7,0) FLEN( 25)  CAPTION( Text )

  TYPE( END)