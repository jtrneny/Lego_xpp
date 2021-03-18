TYPE(drgForm) DTYPE(10) TITLE(Docházka za období) SIZE(100,25)                                ;
              GUILOOK(Action:y,IconBar:y) OBDOBI(MZD)                                         ;
              PRINTFILES(msprc_mo:nrok=nrok+nobdobi=nobdobi+noscisprac=noscisprac+nporpravzt=nporpravzt, ;
                         dspohyby:noscisprac=noscisprac+cobdobi=cobdobi)


*TYPE(Action) CAPTION(~Doklady )  EVENT(mzd_doklhrmzdo_scr)  TIPTEXT(Poøizení dokladù o mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM)  EVENT(PorDokl_NEMOCENKA)   TIPTEXT(Poøízení nemocenských dávek)



 TYPE(STATIC) STYPE( 2) FPOS(0.5,0.2) SIZE(55,10) RESIZE(YN)
   TYPE(STATIC) STYPE( 12) FPOS(15.6,0.6) SIZE(37,1.2) RESIZE(YN)
     TYPE(TEXT) CAPTION( Po)     CPOS(2.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Út)     CPOS(7.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( St)     CPOS(12.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Èt)     CPOS(17.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Pá)     CPOS(22.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( So)     CPOS(27.5, 0.1) FONT(6)  CLEN(5)
     TYPE(TEXT) CAPTION( Ne)     CPOS(32.5, 0.1) FONT(6)  CLEN(5) 
   TYPE(End)  

 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS(0.5,12) SIZE(55,12) RESIZE(YN)
   TYPE(EBrowse) FPOS(0.5,0.20) SIZE(54.0,11.50) FILE(DSPOHYBYw)       ;
                  RESIZE(yx)                         ;
                   CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(1)          ;
                    GUILOOK(sizecols:n,headmove:n)
       TYPE(GET)  NAME(dspohybyw->cKodPrer)
       TYPE(GET)  NAME(dspohybyw->cCasBeg)
       TYPE(GET)  NAME(dspohybyw->cKodPrerE)
       TYPE(GET)  NAME(dspohybyw->cCasEnd)
       TYPE(GET)  NAME(dspohybyw->cCasCel)
   TYPE(End)  


 TYPE(End)  


 TYPE(STATIC) STYPE( 13) FPOS(56.5,0.2) SIZE(43,24) RESIZE(YN)
   
   

 TYPE(End)  



*TYPE(TabPage) TTYPE(4) CAPTION(Info_Zamìst) OFFSET(1,85) FPOS(0.75,12.5) SIZE(98.5,12.25);

*    TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*  TYPE(End)
*TYPE(End)

*TYPE(TabPage) TTYPE(4) CAPTION(PracVztahy) OFFSET(14.9,72) FPOS(0.75,12.5) SIZE(98.5,12.25)  ;
*                       RESIZE(yx)
*  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
*TYPE(End)



*  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
*    TYPE(TEXT) CAPTION(Kmenové údaje zamìstnancù)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*    TYPE(ComboBox) NAME(MZD_kmenove_SCR:STAVEM)  FPOS(76.5,0.6) FLEN(20) RESIZE(XY);
*                     VALUES(0:všichni pracovníci,1:pracovníci ve stavu,2:pracovníci mimo stav) ;
*                   ITEMSELECTED(comboItemSelected)
TYPE(END)
