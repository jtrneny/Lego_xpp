TYPE(drgForm) SIZE(106,18) DTYPE(10) TITLE(Seznam osob_) ;
              FILE(osoby)                                ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) 
              

TYPE(Action) CAPTION(~Nová   Osoba) EVENT(per_osoby_new)    TIPTEXT(Založení nové osoby do seznamu osob ...)
TYPE(Action) CAPTION(~Oprava Osoby) EVENT(per_osoby_modify) TIPTEXT(Oprava údajù osoby ...)


  TYPE(DBrowse) FPOS(0,0) SIZE(106,9.4) FILE(OSOBY)                       ;
                                        FIELDS(ncisOsoby:èíslOsoby      , ;
                                               cjmenoRozl:Jméno osoby s rozlišením:48    , ;
                                               cUlicCiPop:Ulice:25      , ;  
                                               CMISTO:Místo:25          , ; 
                                               CZKRATSTAT:Stát          , ; 
                                               CTELEFON:Telefon:15      , ; 
                                               CEMAIL:Email:30            ) ;
                                         CURSORMODE(3) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)


  TYPE(Static) STZPE(13) SIZE(104,16.5) FPOS(1,9.7) RESIZE(yn) CTYPE(2) CAPTION( Adresa osoby )

    TYPE(Text) CAPTION(ulice)             CPOS( 3,  .7)  CLEN(12)
     TYPE(Text) NAME(OSOBY->cUlicCiPop)   CPOS(17,  .7)  CLEN(30) BGND(13) PP(2) FONT(5)

    TYPE(Text) CAPTION(mìsto)             CPOS( 3, 1.7)  CLEN(12)
     TYPE(Text) NAME(OSOBY->CMISTO)       CPOS(17, 1.7)  CLEN(30) BGND(13) PP(2) FONT(2)

    TYPE(Text) CAPTION(psè)               CPOS( 3, 2.7)  CLEN(12)
     TYPE(Text) NAME(OSOBY->CPSC)         CPOS(17, 2.7)  CLEN( 6) BGND(13) PP(2) 
     TYPE(Text) NAME(C_PSC->CMISTO)       CPOS(24, 2.7)  CLEN(23) BGND(13)       

    TYPE(Text) CAPTION(stát)              CPOS( 3, 3.7)  CLEN(12)
     TYPE(Text) NAME(OSOBY->CZKRATSTAT)   CPOS(17, 3.7)  CLEN( 6) BGND(13) PP(2) 
     TYPE(Text) NAME(C_STATY->cNAZEVSTAT) CPOS(24, 3.7)  CLEN(23) BGND(13)       
  TYPE(End)

* quickFilr
*  TYPE(Static) STYPE(13) SIZE( 49.7,1.1) FPOS( .2, .02) RESIZE(nn) CTYPE(2)
*    TYPE(PushButton) POS(.1,.1)   SIZE(345,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
*  TYPE(End)
