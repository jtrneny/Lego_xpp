TYPE(drgForm) DTYPE(10) TITLE(Podklad pro plnìní výkonových norem) SIZE(80,7) ;
              GUILOOK(Action:n,IconBar:y:myIconBar,Menu:n) OBDOBI(VYR) POST(postValidate)

* drgStdBrowseIconBar
* myIconBar

  TYPE(Static) STYPE(12) SIZE(78,4) FPOS( 1, .1) RESIZE(xy) CTYPE(2) GROUPS(SKL_PRE)
   TYPE(TEXT) CAPTION( Datum zpracování OD : )       CPOS( 7, 1.5) CLEN(22)  FONT(1) 
   TYPE(GET) NAME(M->datumOD)                        FPOS(26, 1.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)

   TYPE(TEXT) CAPTION( __ do __ )                    CPOS(41, 1.5) CLEN( 7)  FONT(1) 
   TYPE(GET) NAME(M->datumDO)                        FPOS(51, 1.5) FLEN(12) PP(2) FONT(5) PUSH(CLICKDATE)
  TYPE(End)


  TYPE(PushButton) POS( 1, 5) SIZE(35,1.5) CAPTION(~Zpracuj podklady pro tisk) EVENT(zpracuj_podklady) ATYPE(3) ;
                   TIPTEXT( Vytvoøí pomocný soubor plnìní výkonových norem pro tisk ....)



