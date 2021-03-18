TYPE(drgForm) SIZE(106,15) DTYPE(10) TITLE(Seznam firem výbìr-ièo) ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
              CARGO(FIR_firmy_SCR)

  TYPE(Action) CAPTION(~Adresáø firem)  EVENT(FIR_FIRMY_SCR) TIPTEXT(Založení/oprava seznamu firem ...)


  TYPE(DBrowse) FPOS(0,0) SIZE(106,9.4) FILE(FIRMY)                      ;
                                        FIELDS(nico:Ièo                , ;
                                               ncisfirmy:firma         , ; 
                                               cnazev:Název firmy:25   , ;
                                               cdic:Diè                , ;
                                               culice:ulice:20         , ;
                                               cpsc:psè                , ;
                                               csidlo:sídlo firmy        ) ;    
                                        CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)


  TYPE(Static) STYPE(13) SIZE(105,5) FPOS(0.5,9.7) RESIZE(y)
* P
   TYPE(Text) CAPTION(Èíslo firmy)   CPOS( 5,  .5)   
   TYPE(Text) NAME(FIRMY->NCISFIRMY) CPOS( 5, 1.5) CLEN(10) BGND(13) PP(2)
   TYPE(Text) CAPTION(Název firmy)   CPOS(18,  .5) 
   TYPE(Text) NAME(FIRMY->CNAZEV)    CPOS(18, 1.5) CLEN(28) BGND(13) PP(2)     
* L
   TYPE(Text) CAPTION(Sídlo firmy)   CPOS(60,  .5)   
   TYPE(Text) NAME(FIRMY->CULICE)    CPOS(60, 1.5) CLEN(38) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMY->cPSC)      CPOS(60, 2.5) CLEN(10) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMY->cSIDLO)    CPOS(73, 2.5) CLEN(25) BGND(13) PP(2)      

   TYPE(TEXT) FCAPTION(REG_dph _ od)  CPOS( 5,3.5) CLEN(12)
   TYPE(TEXT) NAME(FIRMY->DREGDPH_OD) CPOS(18,3.5) CLEN(10) BGND(13) PP(2)
   TYPE(TEXT) FCAPTION(_ do _)        CPOS(29,3.5) CLEN( 6)
   TYPE(TEXT) NAME(FIRMY->DREGDPH_DO) CPOS(36,3.5) CLEN(10) BGND(13) PP(2)
  TYPE(End)
