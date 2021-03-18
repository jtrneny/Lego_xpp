TYPE(drgForm) DTYPE(10) TITLE(LIKVIDACE - ZÁVAZKY) SIZE(100,26) FILE (FAKPRIHD) ;
               GUILOOK(Action:n,IconBar:n)

TYPE(TabPage) TTYPE(3) CAPTION(LIKVIDACE - ZÁVAZKY) OFFSET(1,82) RESIZE(xx)

 TYPE(STATIC) STYPE(2) SIZE(99.8,8) FPOS(0.2,0.2) RESIZE(xx)
    TYPE(Get) NAME(nCenZakCel)  FPOS(14,1.5) FLEN(13)  FCAPTION(CelkFAKT ...)  CPOS(1,1.5)  PP(2)
*    TYPE(Get) NAME()                         FPOS(27,1.5) FLEN()                                      PP(2)
*    TYPE(Get) NAME(LiUcet_UCT())             FPOS(40,1.5) FLEN()                                      PP(2)
*    TYPE(Get) NAME(LiUcet_OBD())             FPOS(74,1)   FLEN()   FCAPTION(OBD_úè ...)    CPOS(60,1) PP(2)
*    TYPE(Get) NAME(LiUcet_OBD())             FPOS(74,2)   FLEN()   FCAPTION(Doklad ...)    CPOS(60,2) PP(2)
    TYPE(Get) NAME(nCisFak)                   FPOS(74,3)   FLEN(10)  FCAPTION(VarSYMb ...)   CPOS(60,3) PP(2)
    TYPE(Get) NAME(cVarSym)                   FPOS(74,4)   FLEN(15)  FCAPTION(DatVYST ...)   CPOS(60,4) PP(2)
    TYPE(Get) NAME(dVystFak)                  FPOS(74,5)   FLEN( 8)  FCAPTION(DatSPLAT ...)  CPOS(60,5) PP(2)

   TYPE(STATIC) STYPE(2) SIZE(55,4) FPOS(1,3.5) RESIZE(xx)
      TYPE(Text) CAPTION(dph)              CPOS(3,-.25)   CLEN(4)
      TYPE(Text) CAPTION(základ)           CPOS(16,-.25)  CLEN(6)
      TYPE(Text) CAPTION(daò)              CPOS(34,-.25)  CLEN(4)

      TYPE(Get) NAME(nOsvOdDan)   FPOS(12,1) FLEN(13) FCAPTION(Nulové ...)   CPOS(1,1) PP(2)
      TYPE(Get) NAME(nOsvOdDan)   FPOS(12,2) FLEN(13) FCAPTION(Snížené ...)  CPOS(1,2) PP(2)
      TYPE(Get) NAME(nSazDan_1)   FPOS(29,2) FLEN(13)                                  PP(2)
      TYPE(Get) NAME(nZaklDan_1)  FPOS(12,3) FLEN(13) FCAPTION(Základní ...) CPOS(1,3) PP(2)
      TYPE(Get) NAME(nSazDan_1)   FPOS(29,3) FLEN(13)
   TYPE(End)
 TYPE(End)

 TYPE(STATIC) STYPE(2) SIZE(99.8,4) FPOS(0.2,8.4) RESIZE(xx)
    TYPE(Get) NAME(UcetPol->cUcetMD)      FPOS(14,1) FLEN( 6)  FCAPTION(SuAu_S ...)      CPOS(1,1)  PP(2)
*    TYPE(Get) NAME(LiUcet_Kc())          FPOS(65,1) FLEN(13)  FCAPTION(CelkPOL ...)     CPOS(55,1) PP(2)
*    TYPE(Get) NAME(SysConfig)            FPOS(85,1) FLEN(13)                                       PP(2)
    TYPE(Get) NAME(UcetPol->cUcetMD)      FPOS(14,2) FLEN( 6)  FCAPTION(PárSYMb ...)     CPOS(1,2)  PP(2)
*    TYPE(Get) NAME(LiUcet_Kc())          FPOS(65,2) FLEN( 3)  FCAPTION(MnožPOL ...)     CPOS(55,2) PP(2)
*    TYPE(Get) NAME(SysConfig)            FPOS(85,2) FLEN(13)                                       PP(2)
    TYPE(Get) NAME(UcetPol->cSYMBOL)      FPOS(14,3) FLEN(15)                                       PP(2)
    TYPE(Get) NAME(UcetPol->nMNOZnat)     FPOS(65,3) FLEN(11)  FCAPTION(MnožPOL2 ...)    CPOS(55,3) PP(2)
    TYPE(Get) NAME(UcetPol->cZKRATjedn)   FPOS(85,3) FLEN( 3)                                       PP(2)
 TYPE(End)

  TYPE(Browse) FILE(UcetPol) INDEXORD(1) ;
               FIELDS(cNazPol1,cNazPol2,cNazPol3,cNazPol4,cNazPol5,cNazPol6) ;
               SIZE(100,9) FPOS(0,15) ;
               CURSORMODE(3) SCROLL(ny) PP(1) Resize(xy)

TYPE(End)