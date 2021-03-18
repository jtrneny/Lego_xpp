TYPE(drgForm) DTYPE(10) TITLE(Protokoly kontrol ELn) SIZE(100,26) FILE(ELNARDIM) ;
              GUILOOK(Action:n,IconBar:n)


TYPE(Static) FPOS(1,1) STYPE(12) SIZE(98,5) RESIZE(y)
* 1
  TYPE(Text) CAPTION(INV_èíslo)          CPOS( 1,0.5) 
  TYPE(Text) NAME(NINVCISDIM)            CLEN( 8) CPOS(17,0.5) BGND(13) PP(2)
  TYPE(Text) NAME(MSDIM->cNAZEVdim)      CPOS(25,0.5)
*2 
  TYPE(Text) FCAPTION(rokVýroby)         CPOS(60,1.5)
  TYPE(Text) NAME(nROKvyr)               CLEN(15) CPOS(76,1.5) BGND(13) PP(2) 
  TYPE(Text) FCAPTION(výrobce)           CPOS( 1,1.5)
  TYPE(Text) NAME(cVYROBCE)              CPOS(17,1.5) CLEN(25) BGND(13) PP(2)  
* 3
  TYPE(Text) FCAPTION(katPouživ)         CPOS(60,2.5)
  TYPE(Text) NAME(cKATEGpouz)            CPOS(76,2.5) CLEN(15) BGND(13) PP(2) 
  TYPE(Text) FCAPTION(výrobní èíslo)     CPOS( 1,2.5)
  TYPE(Text) NAME(MSDIM->cVYRcisDIM)     CPOS(17,2.5) CLEN(15) BGND(13) PP(2) 
* 4
  TYPE(Text) FCAPTION(tøOchrany)         CPOS(60,3.5)
  TYPE(Text) NAME(cTRIDAochr)            CPOS(76,3.5) CLEN(15) BGND(13) PP(2) 
  TYPE(Text) FCAPTION(typOznaèení)       CPOS( 1,3.5)
  TYPE(Text) NAME(cTYPoznac)             CPOS(17,3.5) CLEN(15) BGND(13) PP(2) 
TYPE(End)

* EDT
TYPE(Static) FPOS(1,6) STYPE(13) SIZE(98,11)
  TYPE(GET) NAME(ZMEELNAR->cSESTAVA)     FPOS( 17,0.5) FLEN(13) FCAPTION(èMìøení)          CPOS( 1,0.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->cSESTAVA)     FPOS( 17,1.5) FLEN(13) FCAPTION(sestava)          CPOS( 1,1.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->nDELKAVM)     FPOS( 17,2.5) FLEN(13) FCAPTION(pøívod)           CPOS( 1,2.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->cSITPRIVOD)   FPOS( 47,2.5) FLEN(13) FCAPTION(materiálPøív)     CPOS(35,2.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->nODPORVOD)    FPOS( 76,2.5) FLEN(13) FCAPTION(odpor vodièe)     CPOS(65,2.5) PP(3) BGND(1)


  TYPE(Text) FCAPTION(záklIzol)                   CPOS(17,3.5)
  TYPE(Text) FCAPTION(pøídIzol)                   CPOS(27,3.5)
  TYPE(Text) FCAPTION(zesílIzol)                  CPOS(37,3.5)
  TYPE(Text) FCAPTION(kotrola dne)                CPOS(60,3.5)
  TYPE(Text) FCAPTION(kotroloval)                 CPOS(80,3.5)
    TYPE(Static) FPOS(0,4) STYPE(15) SIZE(95,.1)
    TYPE(End)

  TYPE(GET) NAME(ZMEELNAR->nZAKLIZOL)    FPOS( 17,4.5) FLEN( 5) FCAPTION(izolaèíOdpor)    CPOS( 1,4.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->nPRIDIZOL)    FPOS( 27,4.5) FLEN( 5)
  TYPE(GET) NAME(ZMEELNAR->nZESIIZOL)    FPOS( 37,4.5) FLEN( 5)
  TYPE(GET) NAME(ZMEELNAR->dDATPOSKON)   FPOS( 60,4.5) FLEN(10)
  TYPE(GET) NAME(ZMEELNAR->cOPRAVIL)     FPOS( 80,4.5) FLEN( 8)
  TYPE(GET) NAME(ZMEELNAR->cMETODAmer)   FPOS( 17,5.5) FLEN(13) FCAPTION(metodaNáhrMìø)    CPOS( 1,5.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->nPROUDMA)     FPOS( 70,5.5) FLEN( 4) FCAPTION(proud)            CPOS(60,5.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->cPOPISKON1)   FPOS( 17,6.5) FLEN(60) FCAPTION(popiskontroly)    CPOS( 1,6.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->cPOPISKON2)   FPOS( 17,7.5) FLEN(60) 
  TYPE(GET) NAME(ZMEELNAR->cPOPISKON3)   FPOS( 17,8.5) FLEN(60) 
  TYPE(GET) NAME(ZMEELNAR->cCELKHODNO)   FPOS( 17,9.5) FLEN( 2) FCAPTION(celkHodnocení)    CPOS( 1,9.5) PP(3) BGND(1)
  TYPE(GET) NAME(ZMEELNAR->dDATDAlKON)   FPOS( 70,9.5) FLEN(10) FCAPTION(celkHodnocení)    CPOS(60,9.5) PP(3) BGND(1)
TYPE(End) 


TYPE(DBrowse) FPOS(0,18) SIZE(100,7) FILE(ZMEELNAR);
              FIELDS(nCISkontr,dDATposKON,cSESTAVA,nDELKAvm,cSITprivod,nODPORvod,nZAKLizol,nPRIDizol,nZESIizol,cMETODAmer,nPROUDma,cCELKhodno);
              CURSORMODE(3) 

