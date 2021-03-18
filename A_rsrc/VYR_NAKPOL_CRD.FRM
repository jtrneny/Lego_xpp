TYPE(drgForm) DTYPE(10) TITLE(Skladová položka nakupovaná) SIZE(70,16) FILE(NAKPOLw);
              GUILOOK(Message:Y,Action:n,IconBar:n,Menu:n);
              POST(postValidate)

TYPE(Static) STYPE(13) SIZE(69,4.0) FPOS(0.5,0.2) RESIZE(yn)

  TYPE(GET)  NAME(cCisSklad)  FPOS(15,0.3) FLEN( 15) FCAPTION(Èíslo skladu)  CPOS(1,0.3) NOREVISION()
  TYPE(Text) NAME(C_SKLADY->cNazSklad)  CPOS(35,0.3) CLEN(31) BGND(12)
  TYPE(GET)  NAME(cSklPol)    FPOS(15,1.3) FLEN( 15) FCAPTION(Skl. položka)  CPOS(1,1.3) NOREVISION()
  TYPE(GET)  NAME(cNazTPV)    FPOS(15,2.3) FLEN( 50) FCAPTION(Název zboží)   CPOS(1,2.3)
TYPE(End)

TYPE(Static) STYPE(13) SIZE(69,11.6) FPOS(0.5, 4.3) RESIZE(yn)

  TYPE(GET)      NAME(cDinor)       FPOS(15,0.2) FLEN( 15) FCAPTION(Norma DIN)      CPOS(1,0.2)
  TYPE(GET)      NAME(cCsnro)       FPOS(15,1.2) FLEN( 18) FCAPTION(ÈSNR rozmìrová) CPOS(1,1.2)
  TYPE(GET)      NAME(cMjTpv)       FPOS(15,2.2) FLEN( 10) FCAPTION(MJ pro TPV)     CPOS(1,2.2) PUSH(Jednot_sel)
  TYPE(GET)      NAME(cMjSpo)       FPOS(15,3.2) FLEN( 10) FCAPTION(MJ spotøební)   CPOS(1,3.2) PUSH(Jednot_sel)
  TYPE(GET)      NAME(cZkratJedn)   FPOS(15,4.2) FLEN( 10) FCAPTION(MJ pro sklady)  CPOS(1,4.2) NOREVISION()
*  TYPE(Text)     NAME(M->cSkladSKL) CPOS(35,2.2) CLEN( 30) BGND(12)
*  TYPE(GET)      NAME(cMjTpv)       FPOS(15,3.2) FLEN(  6) FCAPTION(MJ pro TPV)     CPOS(1,3.2) PICTURE(&3X )
*  TYPE(Text)     NAME(M->cSkladTPV) CPOS(35,3.2) CLEN( 30) BGND(12)
*  TYPE(GET)      NAME(nKoefPrep)    FPOS(15,4.2) FLEN( 12) FCAPTION(Koef.pøepoètu MJ) CPOS(1,4.2) CLEN(14)
  TYPE(GET)      NAME(nVahaMJ)      FPOS(15,5.2) FLEN( 10) FCAPTION(Váha za MJ)       CPOS(1,5.2)
  TYPE(GET)      NAME(nKoefNater)   FPOS(15,6.2) FLEN( 10) FCAPTION(Koef. plochy nátìru) CPOS(1,6.2) CLEN(14)
  TYPE(GET)      NAME(cTypMat)      FPOS(15,7.2) FLEN( 10) FCAPTION(Typ materiálu)    CPOS(1,7.2) PICTURE(&3X )
  TYPE(Text)     NAME(C_TYPMAT->cNazTypMat) CPOS(35,7.2) CLEN(30) BGND(12)

  TYPE(COMBOBOX) NAME(cKodTPV)      FPOS(15, 9.2) FLEN( 20) FCAPTION(Kód pro TPV)   CPOS( 1, 9.2) REF(TYPSKLPOL)
  TYPE(COMBOBOX) NAME(cKodRezSkl)   FPOS(15,10.2) FLEN( 20) FCAPTION(Kód rezervace) CPOS( 1,10.2)
TYPE(End)