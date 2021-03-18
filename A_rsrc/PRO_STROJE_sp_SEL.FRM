TYPE(drgForm) SIZE(106,16) DTYPE(10) TITLE(Seznam strojù - VÝBÌR);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) 


*  TYPE(Action) CAPTION(~Nová   Firma) EVENT(fir_firmy_nova)   TIPTEXT(Založení nové firmy do seznamu...)
*  TYPE(Action) CAPTION(~Oprava Firmy) EVENT(fir_firmy_oprava) TIPTEXT(Oprava údajù firmy...)

  TYPE(DBrowse) FPOS(0,1.2) SIZE(106,9.4) FILE(STROJE)                    ;
                                        FIELDS(nTypStroje:typStroje:3   , ;
                                               nStroj:èíslo:8           , ; 
                                               cStroj:oznaèení:15       , ;  
                                               cNazStroj:název stroje:25, ;
                                               ncisFirmy:Firma:6        , ;
                                               cSpzStroj:SPZ:22         , ;  
                                               cZnStroje:Znaèka:20        ) ;
                                        INDEXORD(2) CURSORMODE(3) PP(7) SCROLL(ny) STABLEBLOCK(stableBlock) POPUPMENU(yn)

*
*** QUICK FILTR ***
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(105,1.25) RESIZE(yn)
    TYPE(PushButton) POS(47.5,0.6)   SIZE(33,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(END)
*
  TYPE(Static) STYPE(13) SIZE(105,5) FPOS(0.5,10.7) RESIZE(y)
* P
   TYPE(Text) CAPTION(Èíslo firmy)    CPOS( 5,  .5)
   TYPE(Text) NAME(FIRMY->NCISFIRMY)  CPOS( 5, 1.5) CLEN(10) BGND(13) PP(2)
   TYPE(Text) CAPTION(Název firmy)    CPOS(18,  .5)
   TYPE(Text) NAME(FIRMY->CNAZEV)     CPOS(18, 1.5) CLEN(28) BGND(13) PP(2)
* L
   TYPE(Text) CAPTION(Sídlo firmy)    CPOS(60,  .5)
   TYPE(Text) NAME(FIRMY->CULICE)     CPOS(60, 1.5) CLEN(38) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMY->cPSC)       CPOS(60, 2.5) CLEN(10) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMY->cSIDLO)     CPOS(73, 2.5) CLEN(25) BGND(13) PP(2)

   TYPE(TEXT) FCAPTION(REG_dph _ od)  CPOS( 5,3.5) CLEN(12)
   TYPE(TEXT) NAME(FIRMY->DREGDPH_OD) CPOS(18,3.5) CLEN(10) BGND(13) PP(2)
   TYPE(TEXT) FCAPTION(_ do _)        CPOS(29,3.5) CLEN( 6)
   TYPE(TEXT) NAME(FIRMY->DREGDPH_DO) CPOS(36,3.5) CLEN(10) BGND(13) PP(2)
  TYPE(End)