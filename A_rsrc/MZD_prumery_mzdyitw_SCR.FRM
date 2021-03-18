TYPE(drgForm) DTYPE(10) TITLE(Podklady pro výpoèet prùmìrù - položky mzdy) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD) PRINTFILES(mzdyitw:crokobcpppv=crokobcpppv)                                                                         ) 

//TYPE(Action) CAPTION(~Doklady)    EVENT(MZD_podklady_SCR)    TIPTEXT(Mzdové doklady)


TYPE(TabPage) TTYPE(4) CAPTION(Prac.právní) OFFSET(1,85) FPOS(0.75,0.5) SIZE(98.5,24.25) RESIZE(yy) SUBTABS(A1, A2, A3, A4)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,22.9) RESIZE(YX)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(2,81) TABHEIGHT( 1) SUB(A1) PRE(TABSELECT)

      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdyITw) INDEXORD(1)           ;
                    FIELDS( cObdobi,                    ;
                            cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            M->nazevDMZ:Název druhu mzdy:32,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

    TYPE(TabPage) CAPTION(DokladyPoložky) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(18,66) TABHEIGHT( 1) SUB(A2) PRE(TABSELECT)
      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdDavIT) INDEXORD(1)           ;
                    FIELDS( cObdobi:Obd,                ;
                            cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            DRUHYMZD->cNazevDMz::32,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

    TYPE(TabPage) CAPTION(RoèníOdmìny) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(33,51) TABHEIGHT( 1) SUB(A3) PRE(TABSELECT)
      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdyITww) INDEXORD(1)           ;
                    FIELDS( cObdobi,                    ;
                            cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            M->nazevDMZ:Název druhu mzdy:32,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

    TYPE(TabPage) CAPTION(RuèníPodklady) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(48,36) TABHEIGHT( 1) SUB(A4) PRE(TABSELECT)

      TYPE(eBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdyITpr) INDEXORD(1)           ;
                 CURSORMODE(3) PP(7) 

      TYPE(GET)      NAME(mzdyITpr->nRok)        FPOS( 1,0) FLEN( 6) FCAPTION(Rok)      FONT(5) 
      TYPE(COMBOBOX) NAME(mzdyITpr->nObdobi)     FPOS( 2,0) FLEN(10) FCAPTION(Období)   FONT(5)  ;
           VALUES(1:01,                               ;
                  2:02,                               ;
                  3:03,                               ;
                  4:04,                               ;
                  5:05,                               ;
                  6:06,                               ;
                  7:07,                               ;
                  8:08,                               ;
                  9:09,                               ;
                 10:10,                               ;
                 11:11,                               ;
                 12:12)

      TYPE(GET)  NAME(mzdyITpr->nDruhMzdy)   FPOS( 3,0) FLEN( 6) FCAPTION(DruhMzdy) FONT(5) 
      TYPE(GET)  NAME(mzdyITpr->nDnyDoklad)  FPOS( 4,0) FLEN( 6) FCAPTION(Dny)      FONT(5) 
      TYPE(GET)  NAME(mzdyITpr->nHodDoklad)  FPOS( 5,0) FLEN(10) FCAPTION(Hodiny)   FONT(5) 
      TYPE(GET)  NAME(mzdyITpr->nMzda)       FPOS( 6,0) FLEN(12) FCAPTION(Mzda)     FONT(5) 

      TYPE(End)
    TYPE(End)

  TYPE(End)
TYPE(End)

* 2
TYPE(TabPage) TTYPE(4) CAPTION(Nemocenská) OFFSET(14.9,72) FPOS(0.75,0.5) SIZE(98.5,24.25)  RESIZE(yy) SUBTABS(B1, B2)

  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(97.7,22.9) RESIZE(YX)
    TYPE(TabPage) CAPTION(Položky) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(2,81) TABHEIGHT( 1) SUB(B1) PRE(TABSELECT)

      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdyITw) INDEXORD(1)           ;
                    FIELDS( cObdobi,                    ;
                            cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            M->nazevDMZ:Název druhu mzdy:32,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

    TYPE(TabPage) CAPTION(DokladyPoložky) TTYPE(3) FPOS(0.5,0.2) SIZE(96.7, 22.5) Resize(yx) OFFSET(18,66) TABHEIGHT( 1) SUB(B2) PRE(TABSELECT)
      TYPE(dBrowse) FPOS(-0.30,0.2) SIZE(96.15,20.80) FILE(MzdDavIT) INDEXORD(1)           ;
                    FIELDS( cDenik:De,                  ;
                            nDoklad,                    ;
                            nDruhMzdy:Dmz,              ;
                            DRUHYMZD->cNazevDMz::32,    ;
                            nDnyDoklad,                 ;
                            nHodDoklad,                 ; 
                            nMzda,                      ;
                            nSazbaDokl,                 ; 
                            nMnPDoklad )                ;
                 CURSORMODE(3) PP(7) 
      TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
    TYPE(End)

  TYPE(End)
TYPE(End)

