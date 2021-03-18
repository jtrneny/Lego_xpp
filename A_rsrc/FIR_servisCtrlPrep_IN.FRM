TYPE(drgForm) DTYPE(10) TITLE(Kontrolní pøepoèty ve firmách);
              SIZE( 120,24) GUILOOK(Action:n,IconBar:y,Menu:y) ;
              POST( PostValidate)

*TYPE(Action) CAPTION( ~Pøecenìní skladu)  EVENT() TIPTEXT(Automatizované pøecenìní z kalkulací)
*TYPE(Action) CAPTION( ~Akt.pøímých mezd)  EVENT() TIPTEXT(Automatizovaná aktualizace pøímých mezd z kalkulací)

  TYPE(Static) STYPE(12) SIZE(118.0, 13.9) FPOS( 0.5, 0.2) RESIZE(yx)
   TYPE(CHECKBOX) NAME(ctrlFirmyFi)       FPOS(35,0.5) FLEN(10)  FCAPTION(Kontrola tabulky FIRMYFI)                         CPOS(1,0.5); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlFirUHDA)       FPOS(35,1.7) FLEN(10)  FCAPTION(Doplnìní úhrad z dodací firmy do fakturaèní)      CPOS(1,1.7); 
                  VALUES(F:NE,T:ANO)


  TYPE(END) 

  TYPE(MLE) NAME('M->message') FPOS(1,15) SIZE(118,7)  RESIZE(yx) 
*READONLY(y)
  
  TYPE(PushButton) POS( 17, 22.7) SIZE(35,1.2) CAPTION(~Spustit pøepoèty) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS( 57, 22.7) SIZE(22,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)
