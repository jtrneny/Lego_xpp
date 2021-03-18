TYPE(drgForm) SIZE(95,20) DTYPE(10) TITLE(Seznam investièního majetku - výbìr) ;
                                    FILE(MAJ)                                  ; 
                                    GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)

*  TYPE(Action) CAPTION(~Adresáø firem)  EVENT(FIR_FIRMY_SCR) TIPTEXT(Založení/oprava seznamu firem ...)


  TYPE(DBrowse) FPOS(0,1.1) SIZE(106,18.4) FILE(MAJ)                               ;
                                           FIELDS( NINVCIS:invÈíslo:10           , ;
                                                   CNAZEV::25                    , ;
                                                   NCENAVSTU                     , ;
                                                   NOPRUCT                       , ;
                                                   NCENAVSTD                     , ;
                                                   NOPRDAN                       , ;
                                                   nCenaPorU                       ) ;
                                           INDEXORD(1) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yy)


*  TYPE(Static) STYPE(13) SIZE(105,5) FPOS(0.5,10.7) RESIZE(y)
* P
*   TYPE(Text) CAPTION(Èíslo firmy)   CPOS( 5,  .5)   
*   TYPE(Text) NAME(FIRMY->NCISFIRMY) CPOS( 5, 1.5) CLEN(10) BGND(13) PP(2)
*   TYPE(Text) CAPTION(Název firmy)   CPOS(18,  .5) 
*   TYPE(Text) NAME(FIRMY->CNAZEV)    CPOS(18, 1.5) CLEN(28) BGND(13) PP(2)     
* L
*   TYPE(Text) CAPTION(Sídlo firmy)   CPOS(60,  .5)   
*   TYPE(Text) NAME(FIRMY->CULICE)    CPOS(60, 1.5) CLEN(38) BGND(13) PP(2)
*   TYPE(Text) NAME(FIRMY->cPSC)      CPOS(60, 2.5) CLEN(10) BGND(13) PP(2)
*   TYPE(Text) NAME(FIRMY->cSIDLO)    CPOS(73, 2.5) CLEN(25) BGND(13) PP(2)      
*
*   TYPE(TEXT) FCAPTION(REG_dph _ od)  CPOS( 5,3.5) CLEN(12)
*   TYPE(TEXT) NAME(FIRMY->DREGDPH_OD) CPOS(18,3.5) CLEN(10) BGND(13) PP(2)
*   TYPE(TEXT) FCAPTION(_ do _)        CPOS(29,3.5) CLEN( 6)
*   TYPE(TEXT) NAME(FIRMY->DREGDPH_DO) CPOS(36,3.5) CLEN(10) BGND(13) PP(2)
*  TYPE(End)

* quickFilr
  TYPE(Static) STYPE(13) SIZE( 95,1.1) FPOS( .2, .02) RESIZE(nn) CTYPE(2)
*    TYPE(PushButton) POS(460,.1)   SIZE(200,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
