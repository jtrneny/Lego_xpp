TYPE(drgForm) DTYPE(10) TITLE(Kontrolní pøepoèty ve mzdách);
              SIZE( 95,16) GUILOOK(Action:n,IconBar:y,Menu:y) ;
              POST( PostValidate) OBDOBI(MZD)

*TYPE(Action) CAPTION( ~Pøecenìní skladu)  EVENT() TIPTEXT(Automatizované pøecenìní z kalkulací)
*TYPE(Action) CAPTION( ~Akt.pøímých mezd)  EVENT() TIPTEXT(Automatizovaná aktualizace pøímých mezd z kalkulací)

  TYPE(Static) STYPE(12) SIZE(94.2, 13.9) FPOS( 0.5, 0.2) RESIZE(yx)
   TYPE(CHECKBOX) NAME(ctrlNem)         FPOS(35,0.5) FLEN(10)  FCAPTION(Pøepoèet dnù nemoci za rok)         CPOS(1,0.5); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlHodUP)       FPOS(35,1.7) FLEN(10)  FCAPTION(Pøepoèet hodin pro úøad práce)      CPOS(1,1.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlPrepCM)      FPOS(35,2.7) FLEN(10)  FCAPTION(Pøepoèet èistého pøíjmu)            CPOS(1,2.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlMzdaVRoce)   FPOS(35,3.7) FLEN(10)  FCAPTION(Pøepoèet vyplacené mzdy v roce)     CPOS(1,3.7); 
                  VALUES(F:NE,T:ANO) 
   TYPE(CHECKBOX) NAME(ctrlDovVObd)     FPOS(35,4.7) FLEN(10)  FCAPTION(Pøepoèet dovolené v období)         CPOS(1,4.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlPrepMzdyHD)  FPOS(35,5.7) FLEN(10)  FCAPTION(Pøepoèet atributù ve MzdyHD)        CPOS(1,5.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlPrepOdpoc)   FPOS(35,6.7) FLEN(10)  FCAPTION(Pøepoèet poøadí v odpoètech)        CPOS(1,6.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlPrepMsOsb)   FPOS(35,7.7) FLEN(10)  FCAPTION(Doplnìní do MSOSB z MSPRC)          CPOS(1,7.7); 
                  VALUES(F:NE,T:ANO)
   TYPE(CHECKBOX) NAME(ctrlPrepMzdNem)  FPOS(35,8.7) FLEN(10)  FCAPTION(Doplní do MzdNemoc z MzdDavHD)      CPOS(1,8.7); 
                  VALUES(F:NE,T:ANO)


  TYPE(END)

  TYPE(PushButton) POS( 17, 14.7) SIZE(35,1.2) CAPTION(~Spustit pøepoèty) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS( 57, 14.7) SIZE(22,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)
