TYPE(drgForm) DTYPE(10) TITLE(Vyrábìná položka) SIZE(90,22) FILE(VYRPOLw);
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:y:myMenuBar);
              POST(postValidate)

TYPE(Static) STYPE(13) SIZE(89,5.0) FPOS(0.5,0.1) RESIZE(yn)

  TYPE(GET)  NAME(VYRPOLw->CCISZAKAZ) FPOS(15, 0.2) FLEN( 35) FCAPTION(Èíslo zakázky)  CPOS( 1, 0.2) PUSH(VYR_VYRZAK_SEL)
  TYPE(Text) NAME(VyrZak->cNazevZak1) CPOS(52, 0.2) CLEN( 31) BGND(13)
  TYPE(GET)  NAME(VYRPOLw->CCISVYK)   FPOS(15, 1.7) FLEN( 35) FCAPTION(Èíslo výkresu)  CPOS( 1, 1.7) PUSH(VYR_VYKRESY_SEL)
  TYPE(GET)  NAME(VYRPOLw->cNazVyk)   FPOS(52, 1.7) FLEN( 30) BGND(13)
  TYPE(GET)  NAME(VYRPOLw->CVYRPOL)   FPOS(15, 2.7) FLEN( 35) FCAPTION(Vyr. položka)   CPOS( 1, 2.7) PUSH(VYR_NAKPOL_SEL1) PP(2)
  TYPE(GET)  NAME(VYRPOLw->CNAZEV)    FPOS(52, 2.7) FLEN( 30)
  TYPE(GET)  NAME(VYRPOLw->NVARCIS)   FPOS(15, 3.7) FLEN( 20) FCAPTION(Varianta)       CPOS( 1, 3.7)  PP(2)
  TYPE(GET)  NAME(VYRPOLw->CVARPOP)   FPOS(52, 3.7) FLEN( 30) FCAPTION(Popis varianty) CPOS(40, 3.7)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(89, 10.6) FPOS(0.5, 5.2) RESIZE(yn)

  TYPE(GET)      NAME(CNAZPOL2)             FPOS(15, 0.2) FLEN( 18) FCAPTION(Úèetní výrobek)  CPOS( 1, 0.2)
  TYPE(Text)     NAME(CNAZPOL2->CNAZEV)     CPOS(35, 0.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(CSKLPOL)              FPOS(15, 1.2) FLEN( 18) FCAPTION(Skl. položka)    CPOS( 1, 1.2) PUSH(VYR_NAKPOL_SEL2) PP(2)
  TYPE(Text)     NAME(NAKPOL->CNAZTPV)      CPOS(35, 1.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(CCISSKLAD)            FPOS(15, 2.2) FLEN( 18) FCAPTION(Èíslo skladu)    CPOS( 1, 2.2) PP(2)
  TYPE(Text)     NAME(C_SKLADY->CNAZSKLAD)  CPOS(35, 2.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(CTYPPOL)              FPOS(15, 3.2) FLEN( 18) FCAPTION(Typ položky)     CPOS( 1, 3.2) PP(2)
  TYPE(Text)     NAME(C_TYPPOL->CNAZTYPPOL) CPOS(35, 3.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(CZKRATJEDN)           FPOS(15, 4.2) FLEN( 18) FCAPTION(MJ)              CPOS( 1, 4.2) PP(2)
  TYPE(Text)     NAME(C_JEDNOT->CNAZJEDNOT) CPOS(35, 4.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(CSTRVYR)              FPOS(15, 5.2) FLEN( 18) FCAPTION(Výrobní stø.)    CPOS( 1, 5.2) PP(2)
  TYPE(Text)     NAME(C_STRED->CSTRED)      CPOS(35, 5.2) CLEN( 30) BGND(13)
  TYPE(GET)      NAME(NEKDAV)               FPOS(15, 6.2) FLEN( 18) FCAPTION(Ekon. dávka)     CPOS( 1, 6.2)
  TYPE(COMBOBOX) NAME(cStav)                FPOS(15, 7.2) FLEN( 19) FCAPTION(Lze zapustit)    CPOS( 1, 7.2)
*  TYPE(GET)      NAME(CCISVYK)              FPOS(15, 8.2) FLEN( 26) FCAPTION(Èíslo výkresu)   CPOS( 1, 8.2) PUSH(VYR_VYKRESY_SEL)
TYPE(End)

*  TYPE(MLE) NAME('mPopisVP') FPOS(0.5, 10.7) SIZE(87,4.5) ;
*                             FCAPTION(Popis zboží) CPOS( 1, 9.7) CLEN(12) RESIZE(yx)

TYPE(Static) STYPE(13) SIZE( 89, 6) FPOS( 0.5, 15.8) RESIZE(yy)
  TYPE(Static) STYPE( 9) SIZE(89,  1.2) FPOS(0.5, 0) RESIZE(yn)
    TYPE(Text)   CAPTION(Popis zboží)     CPOS( 1, 0.1) CLEN( 15)
  TYPE(End)
  TYPE(MLE)  NAME('mPopisVP') FPOS(0.2, 1) SIZE(89,4.9) RESIZE(yy)
TYPE(End)