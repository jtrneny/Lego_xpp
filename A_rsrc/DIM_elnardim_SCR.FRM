TYPE(drgForm) DTYPE(10) TITLE(Pøehled elektrického náøadí ...) SIZE(100,25) FILE(ELNARDIM) CARGO(DIM_elnardim_CRD)

TYPE(Action) CAPTION(~protokol ELn) EVENT(elnardim_crd) TIPTEXT(Protokoly o mìøení)


* Browser definition
  TYPE(DBrowse) FILE(ELNARDIM) SIZE(100,12) ;
    FIELDS(ELNpockus()::1::2,cCELKhodno,nINVcisDIM,cNAZEVdim,ELNmajitel():jméno majitele:27,cIDcislo,dDATposKON,dDATdalKON,cKLICskMIS,cKLICodMIS ) ;
    ITEMMARKED(ItemMarked) CURSORMODE(3) PP(7) POPUPMENU(y)

* Info definition
  TYPE(Static) STYPE(13) SIZE(98,5) FPOS(1,12.5) RESIZE(y)
* 1
      TYPE(Text) CAPTION(výrobce)        CPOS( 1, .5)
      TYPE(Text) NAME(cVYROBCE)          CPOS(17, .5) CLEN(25) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(rokVýroby)     CPOS(60, .5)
      TYPE(Text) NAME(nROKvyr)           CPOS(76, .5) CLEN(15) BGND(13) PP(2) 
* 2
      TYPE(Text) FCAPTION(výrobní èíslo) CPOS( 1,1.5)
      TYPE(Text) NAME(MSDIM->cVYRcisDIM) CPOS(17,1.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(katPouživ)     CPOS(60,1.5)
      TYPE(Text) NAME(cKATEGpouz)        CPOS(76,1.5) CLEN(15) BGND(13) PP(2) 
* 3
      TYPE(Text) FCAPTION(typOznaèení)       CPOS( 1,2.5)
      TYPE(Text) NAME(cTYPoznac)             CPOS(17,2.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(tøOchrany)         CPOS(60,2.5)
      TYPE(Text) NAME(cTRIDAochr)            CPOS(76,2.5) CLEN(15) BGND(13) PP(2) 
* 4
      TYPE(Text) FCAPTION(napìtí)            CPOS( 1,3.5)
      TYPE(Text) NAME(nNAPETI)               CPOS(17,3.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(proud)             CPOS(35,3.5)
      TYPE(Text) NAME(nPROUD)                CPOS(42,3.5) CLEN(15) BGND(13) PP(2) 
      TYPE(Text) FCAPTION(pøíkon)            CPOS(60,3.5)
      TYPE(Text) NAME(nPRIKON)               CPOS(76,3.5) CLEN(15) BGND(13) PP(2) 
  TYPE(End)

 TYPE(DBrowse) FPOS(0,18) SIZE(100,7) FILE(ZMEELNAR);
    FIELDS(nINVcisDIM,nCISkontr,dDATposKON,cSESTAVA,nDELKAvm,cSITprivod,nODPORvod,nZAKLizol,nPRIDizol,nZESIizol,cMETODAmer,nPROUDma,cCELKhodno);
    CURSORMODE(3) PP(8) RESIZE(yx)
