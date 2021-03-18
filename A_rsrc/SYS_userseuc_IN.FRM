TYPE(drgForm) DTYPE(10) TITLE( Elektronické úèty ASYSTEM++ - nastavení) SIZE(100,26);
              GUILOOK( Menu:y)

TYPE(Action) CAPTION(~Test )      EVENT(runDatKom) TIPTEXT( Test pošty - odeslání testovací zprávy)
TYPE(Action) CAPTION(~Doruèená)   EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Doruèená pošta k úètu)
TYPE(Action) CAPTION(~Odeslaná)   EVENT(RezervaceMenu) ATYPE(3) ICON1() ICON2(401) TIPTEXT( Odeslaná pošta z úètu)


TYPE(Text)     CAPTION(Seznam a nastavení elektronických úètù) CPOS( 6, 0.1) CLEN( 40) FONT(5)

TYPE(DBrowse) FILE(USERSEUC) INDEXORD(1) ;
              FIELDS( cideucet        ,;
                      cnazeucet::35   ,;
                      cadreucet       ,;
                      ctypeucet       ,;
                      cusreucet       ,;
                      cuser       );
              SIZE(47,24.4) FPOS(0.5, 1.5 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)



*  TYPE(EBrowse) FPOS(0.5,1.5) SIZE(45,24.4) FILE(USERSEUC)  INDEXORD(1);
*                CURSORMODE(3) PP(6) ITEMMARKED(itemMarked) SCROLL(ny) POPUPMENU(yy)
                    
*    TYPE(COMBOBOX) NAME(userseuc->cID)        FLEN( 10)        ; 
*                                                VALUES( DIST:DIST, ;
*                                                        USER:USER  )
*    TYPE(TEXT)     NAME(userseuc->cideucet)
*    TYPE(GET)      NAME(userseuc->cuser)
*    TYPE(GET)      NAME(userseuc->cnazeucet)  
*    TYPE(GET)      NAME(userseuc->cadreucet)
*    TYPE(COMBOBOX) NAME(userseuc->ctypeucet) FLEN(15)        ; 
*                                                VALUES( POP3:POP3, ;
*                                                        IMAP:IMAP  )
*    TYPE(GET)      NAME(userseuc->csrvpeucet)
*    TYPE(GET)      NAME(userseuc->csrvoeucet)
*    TYPE(GET)      NAME(userseuc->cusreucet)
*    TYPE(GET)      NAME(userseuc->cpsweucet)
*    TYPE(GET)      NAME(userseuc->lsvpweucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lzopweucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lovoseucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lsnpseucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lproseucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->cusroeucet)   
*    TYPE(GET)      NAME(userseuc->cpswoeucet)  
*    TYPE(GET)      NAME(userseuc->lsvpoeucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lpoppeucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->nptppeucet)  
*    TYPE(GET)      NAME(userseuc->lsslpeucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->nptopeucet)  
*    TYPE(GET)      NAME(userseuc->ctsioeucet)
*    TYPE(GET)      NAME(userseuc->ncasleucet)  
*    TYPE(GET)      NAME(userseuc->lkopseucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->lodeseucet)  REF(LYESNO) 
*    TYPE(GET)      NAME(userseuc->nodpoeucet)  
*    TYPE(GET)      NAME(userseuc->losopeucet)  REF(LYESNO) 

*  TYPE(END)              


  TYPE(Static) STYPE(13) SIZE( 51.6,25.2) FPOS( 48.0, 0.3)  RESIZE(yn)

   TYPE(TEXT) CAPTION(IdElÚètu)               CPOS(  1,0.2) CLEN( 20) FONT(1)
    TYPE(COMBOBOX) NAME(userseuc->cID)        FLEN( 10) FPOS( 21, 0.2)      ; 
                                               VALUES( DIST:DIST, ;
                                                        USER:USER  )
    TYPE(TEXT)     NAME(userseuc->cideucet)    CPOS( 32,0.2) CLEN( 15) FONT(2)

   TYPE(TEXT) CAPTION(Uživatel)               CPOS(  1,1.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->cuser)       FPOS(  21,1.2) FLEN( 10) FONT(2) NOREVISION()

   TYPE(TEXT) CAPTION(Název úètu)             CPOS(  1,2.8) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->cnazeucet)   FPOS(  21,2.8) FLEN( 28) FONT(2) 

   TYPE(TEXT) CAPTION(Adresa úètu)            CPOS(  1,4.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->cadreucet)   FPOS(  21,4.2) FLEN( 28) FONT(2)  

   TYPE(TEXT) CAPTION(Typ úètu)               CPOS(  1,5.2) CLEN( 20) FONT(1)
    TYPE(COMBOBOX) NAME(userseuc->ctypeucet)   FLEN(29) FPOS( 21, 5.2)        ; 
                                                VALUES( POP3:POP3, ;
                                                        IMAP:IMAP  )

   TYPE(TEXT) CAPTION(Server pøíchozí pošty)  CPOS(  1,6.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->csrvpeucet)  FPOS( 21,6.2) FLEN( 28) FONT(2)

   TYPE(TEXT) CAPTION(Server odchozí pošty)   CPOS(  1,7.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->csrvoeucet)  FPOS( 21,7.2) FLEN( 28) FONT(2)  

   TYPE(TEXT) CAPTION(Uživatelské jméno)      CPOS(  1,8.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->cusreucet)   FPOS( 21,8.2) FLEN( 28) FONT(2) 

   TYPE(TEXT) CAPTION(Uživatelské heslo)      CPOS(  1,9.2) CLEN( 20) FONT(1)
    TYPE(GET)      NAME(userseuc->cpsweucet)   FPOS( 21,9.2) FLEN( 28) FONT(2)  

   TYPE(CHECKBOX)      NAME(userseuc->lsvpweucet) FPOS( 21,10.2) FLEN( 27) FONT(2)        ;
       VALUES(T:Ukládat heslo,F:Ukládat heslo)

   TYPE(CHECKBOX)      NAME(userseuc->lzopweucet) FPOS( 1,11.2) FLEN( 47) FONT(2)        ;
       VALUES(T:Pøihlášení pomocí zabezpeèení ovìøení hesla,F:Pøihlášení pomocí zabezpeèení ovìøení hesla)



   TYPE(TabPage) TTYPE(4) CAPTION(Odchozí server) OFFSET(2,69) FPOS( 1,13.0) SIZE(49,11.5) PRE(tabSelect) RESIZE(yy)

     TYPE(CHECKBOX)      NAME(userseuc->lovoseucet) FPOS(  1,0.5) FLEN( 47) FONT(2)        ;
         VALUES(T:Server pro odchozí poštu SMTP vyžaduje ovìøení,F:Server pro odchozí poštu SMTP vyžaduje ovìøení)

     TYPE(CHECKBOX)      NAME(userseuc->lsnpseucet) FPOS(  3,1.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Použít stejná nastavení jako pro server pøíchozí pošty,F:Použít stejná nastavení jako pro server pøíchozí pošty)

     TYPE(CHECKBOX)      NAME(userseuc->lproseucet) FPOS(  3,2.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Pøihlašovat se jako,F:Pøihlašovat se jako)

     TYPE(TEXT) CAPTION(Uživatelské jméno)      CPOS(  5,3.5) CLEN( 15) FONT(1)
      TYPE(GET)      NAME(userseuc->cusroeucet)   FPOS(  21,3.5) FLEN( 26) FONT(2)

     TYPE(TEXT) CAPTION(Heslo)                  CPOS(  5,4.5) CLEN( 15) FONT(1)
      TYPE(GET)      NAME(userseuc->cpswoeucet)   FPOS(  21,4.5) FLEN( 26) FONT(2)

     TYPE(CHECKBOX)      NAME(userseuc->lsvpoeucet) FPOS( 21,5.5) FLEN( 27) FONT(2)        ;
         VALUES(T:Zapamatovat heslo,F:Zapamatovat heslo)

     TYPE(CHECKBOX)      NAME(userseuc->lpzoheucet) FPOS( 5,6.5) FLEN( 43) FONT(2)        ;
         VALUES(T:Požadovat zebezpeèené ovìøování hesla,F:Požadovat zebezpeèené ovìøování hesla)

     TYPE(CHECKBOX)      NAME(userseuc->lpoppeucet) FPOS( 3,7.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Pøed odesláním pošty se pøihlásit k serveru pøíchozí pošty,F:Pøed odesláním pošty se pøihlásit k serveru pøíchozí pošty)

    TYPE(End)



   TYPE(TabPage) TTYPE(4) CAPTION(Porty a další) OFFSET(30,41) FPOS( 1,13.0) SIZE(49,11.5) PRE(tabSelect) RESIZE(yy)

     TYPE(TEXT) CAPTION(Server pøíchozí pošty POP3 )      CPOS(  1,0.5) CLEN( 20) FONT(1)
      TYPE(GET)      NAME(userseuc->nptppeucet)  FPOS(  21,0.5) FLEN( 5) FONT(2) 

     TYPE(CHECKBOX)      NAME(userseuc->lsslpeucet) FPOS( 3,1.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Tento server požaduje šifrované pøipojení SSL,F:Tento server požaduje šifrované pøipojení SSL)

     TYPE(TEXT) CAPTION(Server pro odchozí poštu SMTP )      CPOS(  1,2.5) CLEN( 23) FONT(1)
      TYPE(GET)      NAME(userseuc->nptopeucet)  FPOS(  24,2.5) FLEN( 5) FONT(2) 

     TYPE(TEXT) CAPTION(Použít tento typ šifrovaného pøipojení )      CPOS(  3,3.5) CLEN( 28) FONT(1)
      TYPE(COMBOBOX) NAME(userseuc->ctsioeucet)  FPOS(  31,3.5) FLEN( 17) FONT(2) VALUES(   :Žádné       ,;
                                                                                        SSL:Sklady      ,;
                                                                                        TSL:TSL         ,;
                                                                                        AUT:Automatické )

     TYPE(TEXT) CAPTION(Èasový limit serveru )    CPOS(  1,4.5) CLEN( 20) FONT(1)
      TYPE(GET)      NAME(userseuc->ncasleucet)     FPOS(  24,4.5) FLEN( 15) FONT(2) 


     TYPE(TEXT) CAPTION(Doruèování pošty )    CPOS(  1,5.5) CLEN( 20) FONT(1)

     TYPE(CHECKBOX)      NAME(userseuc->lkopseucet) FPOS( 3,6.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Zachovat na serveru kopie správ,F:Zachovat na serveru kopie správ)

     TYPE(CHECKBOX)      NAME(userseuc->lodeseucet) FPOS( 6,7.5) FLEN( 20) FONT(2)        ;
         VALUES(T:Odebrat ze serveru po,F:Odebrat ze serveru po)

      TYPE(GET)      NAME(userseuc->nodpoeucet)  FPOS(  26,7.5) FLEN( 6) FONT(2)
     TYPE(TEXT) CAPTION(dny )    CPOS( 35,7.5) CLEN( 10) FONT(1)

     TYPE(CHECKBOX)      NAME(userseuc->losopeucet) FPOS( 6,8.5) FLEN( 45) FONT(2)        ;
         VALUES(T:Odebrat ze serveru po odstranìní z Odstranìné pošty,F:Odebrat ze serveru po odstranìní z Odstranìné pošty)

   TYPE(End)

  TYPE(End)



TYPE(END)              
