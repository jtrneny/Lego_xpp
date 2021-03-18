TYPE(drgForm) DTYPE(10) TITLE(Kontrolní pøepoèty v hmotném majetku);
              SIZE( 95,16) GUILOOK(Action:n,IconBar:y,Menu:y) ;
              POST( PostValidate) OBDOBI(HIM)

*TYPE(Action) CAPTION( ~Pøecenìní skladu)  EVENT() TIPTEXT(Automatizované pøecenìní z kalkulací)
*TYPE(Action) CAPTION( ~Akt.pøímých mezd)  EVENT() TIPTEXT(Automatizovaná aktualizace pøímých mezd z kalkulací)

  TYPE(Static) STYPE(12) SIZE(94.2, 13.9) FPOS( 0.5, 0.2) RESIZE(yx)
  TYPE(CHECKBOX) NAME(ctrlImpHim)       FPOS(35,0.5) FLEN(10)  FCAPTION(Import dat do HIM -STS)               CPOS(1,0.5)   VALUES(F:NE,T:ANO)
  TYPE(CHECKBOX) NAME(ctrlImpPoz)       FPOS(35,1.5) FLEN(10)  FCAPTION(Import dat do HIM -pozemky)           CPOS(1,1.5)   VALUES(F:NE,T:ANO)
  TYPE(CHECKBOX) NAME(ctrlImpTmp)       FPOS(35,2.5) FLEN(10)  FCAPTION(Pomocný pøepoèet POZEMKY)             CPOS(1,2.5)   VALUES(F:NE,T:ANO)

  TYPE(END)

  TYPE(PushButton) POS( 17, 14.7) SIZE(35,1.2) CAPTION(~Spustit pøepoèty) EVENT( START )  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(PushButton) POS( 57, 14.7) SIZE(22,1.2) CAPTION(~Storno)                   EVENT(140000002)       ICON1(102) ICON2(202) ATYPE(3)
