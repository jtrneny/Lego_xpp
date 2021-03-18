TYPE(drgForm) SIZE(80,21) DTYPE(10) TITLE(Seznam osob - VÝBÌR);
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) ;
              CARGO()

TYPE(Action) CAPTION(~Nová   Osoba) EVENT(osb_osoby_nova)   TIPTEXT(Založení nové osoby do seznamu osob ...)
TYPE(Action) CAPTION(~Oprava Osoby) EVENT(osb_osoby_oprava) TIPTEXT(Oprava údajù osoby ...)


  TYPE(DBrowse) FPOS(0.5,1.1) SIZE(79,14.5) FILE(OSOBY)                       ;
                                            FIELDS(M->is_isZAM:zam:2.6::2   , ;
                                                   M->is_isPER:per:2.6::2   , ;
                                                   ncisOsoby:èísOsoby       , ;   
                                                   cosoba:Jméno osoby:40    , ;
                                                   CMISTO:Místo:25          , ; 
                                                   CZKRATSTAT:Stát          , ; 
                                                   CTELEFON:Telefon:15      , ; 
                                                   CEMAIL:Email:30            ) ;
                                                   CURSORMODE(3) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)


  TYPE(Static) SIZE(79,4.6) FPOS(0.5,15.7) RESIZE(y) CTYPE(1) CAPTION( Adresa osoby )
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
  TYPE(Static) STYPE(13) SIZE( 49.7,1.1) FPOS( 30.2, .02) RESIZE(nn) CTYPE(2)
    TYPE(PushButton) POS(.1,.1)   SIZE(345,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
  TYPE(End)
