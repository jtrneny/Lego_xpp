TYPE(drgForm) SIZE(100,20) DTYPE(10) TITLE(Kalkulace výrobkù ve skuteèných nákladech);
              GUILOOK(Action:y,IconBar:y,Menu:n,Message:n) ;
              CARGO() RESIZE(ny) OBDOBI(UCT)

  TYPE(Action) CAPTION(~Rozpuštìní)  EVENT(rozpustit) TIPTEXT(Rozpuštìní skuteèných nákladù na stroje ...)
  TYPE(Action) CAPTION(~Kalkulace)   EVENT(kalkulace) TIPTEXT(Vytvoøení podkladù pro kalkulaci ...)
*  TYPE(Action) CAPTION(~AktualMezd)  EVENT(importmdav) TIPTEXT(Aktualizace mezd za rok ...)

  TYPE(STATIC) STYPE(1) SIZE(99,19) FPOS(0.5,0.5)
   TYPE(Text) CAPTION(Datum zpracování ...) CPOS(0.5,0.2)
    TYPE(Get) NAME(M->ddatzprac) FPOS(25,0.2) FLEN(12) PUSH(CLICKDATE)

   TYPE(EBrowse) FPOS(0.5,2.2) SIZE(98,17.0) FILE(kalkzem)                ;
                            CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x)
     TYPE(GET)  NAME(kalkzem->cOznac)     FLEN( 3) FCAPTION(Oznaè)
     TYPE(GET)  NAME(kalkzem->cnazpol2)   FLEN(10) FCAPTION(Výrobek)
     TYPE(GET)  NAME(kalkzem->cnazev)     FLEN(20) FCAPTION(Název)
     TYPE(GET)  NAME(kalkzem->nPrimNakl)  FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nSpoVlVyr)  FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nVnNakPoCi) FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nVyrRezie)  FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nVyrNakl)   FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nOdpVedlVy) FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nNakBezCDR) FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nCelDruRez) FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nNakSCDR)   FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nVyrobaMn)  FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nNakJedBeC) FLEN(15) 
     TYPE(GET)  NAME(kalkzem->nNakJedSC)  FLEN(15) 
   TYPE(End)
  TYPE(End)



