TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù odpoèitatelných položek) SIZE(90,15) FILE(C_ODPOC);
              OBDOBI(MZD) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_ODPOC) FIELDS(nPorOdpPol,cTypOdpPol,cNazOdpPol,dPlatnOd,dPlatnDo,nOdpocObd,nOdpocRok  ;
                                   ,nRok,nObdobi,cObdobi,lAktMesOdp,nDruhMzdy,nrok);
                            CURSORMODE(3) PP(7) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(nPorOdpPol)    FPOS(25,1) FLEN(3)  FCAPTION(Poøadí odpoè.položky)       CPOS( 1, 1) ;
             POST( drgPostUniqueKey)
  TYPE(GET) NAME(cTypOdpPol)  FPOS(25,2)  FLEN(4)  FCAPTION(Typ odpoè.položky)           CPOS( 1, 2)
  TYPE(GET) NAME(cNazOdpPol)  FPOS(25,3)  FLEN(50) FCAPTION(Název odpoè.položky)         CPOS( 1, 3)
  TYPE(GET) NAME(dPlatnOd)    FPOS(25,4)  FLEN(11) FCAPTION(Platnost OD-DO, Období OD)   CPOS( 1, 4)  PUSH(CLICKDATE)
  TYPE(GET) NAME(dPlatnDo)    FPOS(40,4)  FLEN(11) FCAPTION(-) CLEN(2)                   CPOS(38, 4)  PUSH(CLICKDATE)
  TYPE(GET) NAME(nRok)        FPOS(56,4)  FLEN(5)  
  TYPE(GET) NAME(nObdobi)     FPOS(64,4)  FLEN(3)  FCAPTION(-) CLEN(2)                   CPOS(62, 4)
  TYPE(GET) NAME(cObdobi)     FPOS(70,4)  FLEN(5)  FCAPTION(-) CLEN(2)                   CPOS(68, 4)
  TYPE(GET) NAME(nDanUlObd)   FPOS(25,6)  FLEN(7)  FCAPTION(Daò úleva období-rok)        CPOS( 1, 6)
  TYPE(GET) NAME(nDanUlRok)   FPOS(40,6)  FLEN(7)  FCAPTION(-) CLEN(2)                   CPOS(36, 6)
  TYPE(GET) NAME(nOdpocObd)   FPOS(25,7)  FLEN(7)  FCAPTION(Odpoèet období-rok)          CPOS( 1, 7)
  TYPE(GET) NAME(nOdpocRok)   FPOS(40,7)  FLEN(7)  FCAPTION(-) CLEN(2)                   CPOS(36, 7)
  TYPE(COMBOBOX) NAME(lAktMesOdp)  FPOS(25, 9) FLEN(7)  FCAPTION(Aktivní mìsíèní položka)     CPOS( 1, 9)  REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lDanUleva)   FPOS(25,10) FLEN(7)  FCAPTION(Daòová úleva)                CPOS( 1,10)  REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lOdpocet)    FPOS(25,11) FLEN(7)  FCAPTION(Odpoèitatelná položka)       CPOS( 1,11)  REF( LYESNO) 
  TYPE(GET) NAME(nDruhMzdy)   FPOS(25,12) FLEN(5)  FCAPTION(Druh mzdy 1,2,3,4,5)         CPOS( 1,12)
  TYPE(GET) NAME(nDruhMzdy2)  FPOS(33,12) FLEN(5)  FCAPTION(,) CLEN(2)                   CPOS(31,12)
  TYPE(GET) NAME(nDruhMzdy3)  FPOS(41,12) FLEN(5)  FCAPTION(,) CLEN(2)                   CPOS(39,12)
  TYPE(GET) NAME(nDruhMzdy4)  FPOS(49,12) FLEN(5)  FCAPTION(,) CLEN(2)                   CPOS(47,12)
  TYPE(GET) NAME(nDruhMzdy5)  FPOS(57,12) FLEN(5)  FCAPTION(,) CLEN(2)                   CPOS(55,12)
TYPE(End)
