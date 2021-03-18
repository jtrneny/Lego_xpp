TYPE(drgForm) DTYPE(10) TITLE(Docházka osob - zamìstnancù za období) SIZE(107,27)             ;
              GUILOOK(Action:y,IconBar:y) CARGO(DOH_dochazkadny_IN) OBDOBI(DOH)                  ;
              PRINTFILES(osoby:ncisosoby=ncisosoby,                                           ;
                         dspohyby:ncisosoby=ncisosoby+cobdobi=cobdobi)


 TYPE(Action) CAPTION(~Hromadnì)  EVENT(InputOfDochazka)      TIPTEXT(Hromadné vytvoøení docházky)
*TYPE(Action) CAPTION(~Dokl_NEM)  EVENT(PorDokl_NEMOCENKA)     TIPTEXT(Poøízení nemocenských dávek)


*TYPE(STATIC) STYPE( 13) FPOS(0,0) SIZE(100,25) RESIZE(YN)
  TYPE(DBrowse) FPOS(0.5,1.40) SIZE(38.5,23.45) FILE(OSOBY)        ;
                POPUPMENU(y) INDEXORD(1) RESIZE(yy)                ;
                 FIELDS( nCisOsoby,            ;    
                         nOsCisPrac,           ;
                         cJmenoRozl:Jméno:30)       ;
                  CURSORMODE(3) PP(7) STABLEBLOCK(stableBlock)  

*                        cKmenStrPr)           ;

 TYPE(TabPage) TTYPE(4) CAPTION(Docházka) OFFSET(2,79) FPOS(39.75,1.40) SIZE(65.0,23.30)  RESIZE(yx) 
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(59.5,22.5) RESIZE(YX)
   TYPE(DBrowse) FPOS(-0.3,0.20) SIZE(59.0,21.65) FILE(DSPOHYBY) INDEXORD(9) RESIZE(yx)                      ;
                FIELDS( nDen,                      ;
                        cZkrDne:ZkrDne,            ;
                        cKodPrer:Pøíchod,          ;
                        cCasBeg:èasPøíchodu,       ;
                        cKodPrerE:Odchod,          ;
                        cCasEnd:èasOdchodu,        ;
                        nCasCelCPD:Celkem za den,  ;
                        cobdobi                 )  ;
                CURSORMODE(3) PP(4)
  TYPE(End)
 TYPE(End)


 TYPE(TabPage) TTYPE(4) CAPTION(Sumáø) OFFSET(21,59) FPOS(39.75,1.40) SIZE(60.0,23.30)  RESIZE(yx)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(59.5,22.5) RESIZE(YX)

  TYPE(End)
  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)


 TYPE(TabPage) TTYPE(4) CAPTION(Terminál) OFFSET(40,40) FPOS(39.75,1.40) SIZE(60.0,23.30)  RESIZE(yx)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(59.5,22.5) RESIZE(YX)

  TYPE(End)
  TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
 TYPE(End)


 TYPE(TabPage) TTYPE(4) CAPTION(Info) OFFSET(59,22) FPOS(39.75,1.40) SIZE(60.0,23.30)  RESIZE(yx)
  TYPE(STATIC) STYPE( 13) FPOS(0.3,0.1) SIZE(59.5,22.5) RESIZE(YX)

   TYPE(PUSHBUTTON) POS(0,0)SIZE(0,0)
  TYPE(End)
 TYPE(End)


*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Osoby pro docházku)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(74.50,0.09) SIZE(23.2,1.0) RESIZE(nx)
      TYPE(PushButton) POS(0.1,0.46)   SIZE(23.3,1.2) CAPTION(~Osoby docházka) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)

TYPE(END)
