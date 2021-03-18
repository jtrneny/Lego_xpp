TYPE(drgForm) DTYPE(10) TITLE(Vzdìlání, školení a kurzy - Dosažená vzdìlání) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y)


TYPE(Action) CAPTION(~RodPøísl)  EVENT(Pohyby_DOKLADY)   TIPTEXT(Rodinní pøíslušníci)
TYPE(Action) CAPTION(~OdpoèPol ) EVENT(MZD_odpocpol_CRD) TIPTEXT(Odpoèitatelné položky)


  TYPE(Static) STYPE(12) SIZE(98.5,2) FPOS(0.75,0.25) RESIZE(y)
    TYPE(TEXT) CAPTION(Pracovník . . .)         CPOS( 3, 0.5) CLEN(12)
     TYPE(TEXT) NAME(Vzdelani->cPracovnik)      CPOS(15, 0.5) CLEN(43) BGND(13) PP(3) FONT(5)
    TYPE(TEXT) CAPTION(Poøadí . . .)            CPOS(80, 0.5) CLEN( 9)
     TYPE(TEXT) NAME(Vzdelani->nPoradi)         CPOS(90, 0.5) CLEN( 3) BGND(13) PP(3) FONT(5)
  TYPE(End)


  TYPE(Static) STYPE(13) SIZE(98.5,22.25) FPOS(0.75,2.5) RESIZE(y)
    TYPE(TEXT) CAPTION(Typ vzdìlání . . .)      CPOS( 3, 1) CLEN(14)
     TYPE(GET) NAME(Vzdelani->cZkrVzdel)        FPOS(17, 1) FLEN(10)
     TYPE(TEXT) NAME(C_Vzdel->cNazVzdela)       CPOS(28.5, 1) CLEN(40) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Obor studia . . .)       CPOS( 3, 3) CLEN(13)
     TYPE(GET) NAME(Vzdelani->cOborVzdel)       FPOS(17, 3) FLEN(50) PP(2)

   TYPE(Static) STYPE( 2) CAPTION(Studium)  SIZE(65, 3.30) FPOS( 3, 4.5) RESIZE(y)

    TYPE(TEXT) CAPTION(Délka . . .)             CPOS( 3, 1) CLEN( 8)
     TYPE(GET) NAME(Vzdelani->nPocLetStu)       FPOS(12, 1) FLEN( 3) PP(2)
    TYPE(TEXT) CAPTION(OD . . .)                CPOS(22, 1) CLEN( 5)
     TYPE(GET) NAME(Vzdelani->dZacStudia)       FPOS(28, 1) FLEN( 8) PP(2)
    TYPE(TEXT) CAPTION(DO . . .)                CPOS(41, 1) CLEN( 5)
     TYPE(GET) NAME(Vzdelani->dKonStudia)       FPOS(47, 1) FLEN( 8) PP(2)

    TYPE(TEXT) CAPTION(Zpùsob ukonèení . . .)   CPOS( 3, 2.05) CLEN(17)
     TYPE(GET) NAME(Vzdelani->cZkrUkoVzd)       FPOS(20, 2.05) FLEN(10)
     TYPE(TEXT) NAME(C_VzdeUk->cNazUkoVzd)      CPOS(31.5, 2.05) CLEN(30) BGND(13) PP(3)

   TYPE(End)

  TYPE(Static) STYPE( 2)  SIZE(93, 6) FPOS( 3, 7.85) RESIZE(y)

    TYPE(TEXT) CAPTION(Název školy . . .)       CPOS( 3, 1) CLEN(13)
     TYPE(GET) NAME(Vzdelani->cNazevSkol)       FPOS(17, 1) FLEN(30) PP(2)
    TYPE(TEXT) CAPTION(Zkratka . . .)           CPOS(69, 1) CLEN(10)
     TYPE(GET) NAME(Vzdelani->cZkratSkol)       FPOS(80, 1) FLEN( 8) PP(2)

    TYPE(TEXT) CAPTION(Ulice . . .)             CPOS( 7, 2.05) CLEN( 8)
     TYPE(GET) NAME(Vzdelani->cUlice)           FPOS(17, 2.05) FLEN(25) PP(2)

    TYPE(TEXT) CAPTION(Místo . . .)             CPOS( 7, 3.10) CLEN( 8)
     TYPE(GET) NAME(Vzdelani->cMisto)           FPOS(17, 3.10) FLEN(25) PP(2)

    TYPE(TEXT) CAPTION(PSÈ . . .)               CPOS( 7, 4.15)
     TYPE(GET) NAME(Vzdelani->cPSC)             FPOS(17, 4.15) FLEN( 8)
     TYPE(TEXT) NAME(c_Psc->cMisto)             CPOS(26.5, 4.15) CLEN(40) BGND(13) PP(3)

    TYPE(TEXT) CAPTION(Stát . . .)              CPOS( 7, 5.20) CLEN( 7)
     TYPE(GET) NAME(Vzdelani->cZkratStat)       FPOS(17, 5.20) FLEN( 5)
     TYPE(TEXT) NAME(C_Staty->cNazevStat)       CPOS(23.5, 5.20) CLEN(25) BGND(13) PP(3)
  TYPE(End)
  TYPE(End)