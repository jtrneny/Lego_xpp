TYPE(drgForm) DTYPE(2) TITLE(Èíselník stavù pøerušení ) SIZE(80,24) FILE(C_PRERUS);
             GUILOOK(Action:y)

TYPE(Action) CAPTION(~PovolVazby)    EVENT(C_PrerVa_in) TIPTEXT(Povolené vzájemné vazby pøerušení)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,23) FILE(C_PRERUS) FIELDS(M->is_Vazba::3.3::2,cKodPrer,nKodPrer,cNazPrer,nNapPrer,nMaskInp,nMaskOut,nSayScr,lInfSum,cTypPrer,lIsEdit,lIsPovol,nCsPovol,nKodZaokr,nSUMfond,nSUMvyr,lPrestavka,nPritPrac,nDruhMzdy);
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(cKodPrer)    FPOS(30, 1) FLEN(15) FCAPTION(Kód pøerušení-text)      CPOS(1, 1)  ;
                  POST( drgPostUniqueKey)

  TYPE(GET)      NAME(nKodPrer)    FPOS(30, 2) FLEN(10) FCAPTION(Kód pøerušení-num.)      CPOS(1, 2)  ;
                  POST( drgPostUniqueKey) 

  TYPE(GET)      NAME(cNazPrer)    FPOS(30, 3) FLEN(40) FCAPTION(Název pøerušení)         CPOS(1, 3)
  TYPE(GET)      NAME(cTypPrer)    FPOS(30, 4) FLEN(40) FCAPTION(Typ pøerušení)           CPOS(1, 4)
  TYPE(COMBOBOX) NAME(nNapPrer)    FPOS(30, 5) FLEN(41) FCAPTION(Nápoèet pøerušení)       CPOS(1, 5) ;
                                   VALUES( 0: (0) nenapoèítává se , ;
                                           1: (1) napoèítají se dny a hodiny, ;
                                           2: (2) napoèítají se hodiny, ;
                                           3: (3) napoèítají se dny a hodiny)
  TYPE(COMBOBOX) NAME(nMaskInp)    FPOS(30, 6) FLEN(41) FCAPTION(Maska pro pøíchod)       CPOS(1, 6) ; 
                                   VALUES( 0: (0), ;
                                           1: (1), ;
                                           2: (2), ;
                                           3: (3), ;
                                           4: (4), ;
                                           5: (5)  )
  TYPE(COMBOBOX) NAME(nMaskOut)    FPOS(30, 7) FLEN(41) FCAPTION(Maska pro odchod)        CPOS(1, 7) ;
                                   VALUES( 0: (0), ;
                                           1: (1), ;
                                           2: (2))
  TYPE(COMBOBOX) NAME(nSayScr)     FPOS(30, 8) FLEN(41) FCAPTION(Zobrazení na pohledovém formuláøi)    CPOS(1, 8)  ;
                                   VALUES( 0: (0) nezobrazuje se, ;
                                           1: (1) zobrazuje se)

  TYPE(COMBOBOX) NAME(nSayFrm)     FPOS(30, 9) FLEN(41) FCAPTION(Maska pro tisk)          CPOS(1, 9)   ;
                                   VALUES( 0: (0) nezobrazuje se  , ;
                                           1: (1) zobrazuje se  )

  TYPE(COMBOBOX) NAME(lInfSum)     FPOS(30,10) FLEN( 6) FCAPTION(Provádìt sumaci)         CPOS(1,10) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lIsPovol)    FPOS(30,11) FLEN( 6) FCAPTION(Povoleno použít)         CPOS(1,11) REF( LYESNO) 
  TYPE(GET)      NAME(nCsPovol)    FPOS(30,12) FLEN(40) FCAPTION(Zpùsob využití)          CPOS(1,12)
  TYPE(COMBOBOX) NAME(lIsEdit)     FPOS(30,13) FLEN( 6) FCAPTION(Povolená editace)        CPOS(1,13) REF( LYESNO) 
  TYPE(GET)      NAME(nKodZaokr)   FPOS(30,14) FLEN(40) FCAPTION(Zpùsob zaokrouhlení)     CPOS(1,14)
  TYPE(COMBOBOX) NAME(nSUMfond)    FPOS(30,15) FLEN(41) FCAPTION(Nápoèet do fondu hod.)   CPOS(1,15)     ;
                                   VALUES( 0: (0) nezapoèítává se  , ;
                                           1: (1) zapoèítává se do fondu odpr.doby  )

  TYPE(COMBOBOX) NAME(nSUMvyr)     FPOS(30,16) FLEN(41) FCAPTION(Nápoèet do výroby)       CPOS(1,16)     ;
                                   VALUES( 0: (0) nezapoèítává se , ;
                                           1: (1) zapoèítává se vykázaná doba z výroby)

  TYPE(COMBOBOX) NAME(lPrestavka)  FPOS(30,17) FLEN( 6) FCAPTION(Pøestávka)               CPOS(1,17) REF( LYESNO) 
  TYPE(GET)      NAME(nPritPrac)   FPOS(30,18) FLEN(40) FCAPTION(Pøítomen v práci)        CPOS(1,18)
  TYPE(GET)      NAME(nDruhMzdy)   FPOS(30,19) FLEN(40) FCAPTION(Generovaný druh mzdy)    CPOS(1,19)
  TYPE(COMBOBOX) NAME(cInOut)      FPOS(30,20) FLEN(41) FCAPTION(Vstup-výstup)            CPOS(1,20) REF(cInOut) 
  TYPE(COMBOBOX) NAME(lAktivni)    FPOS(30,21) FLEN( 6) FCAPTION(Aktivní pøerušení)       CPOS(1,21) REF( LYESNO) 
TYPE(End)

