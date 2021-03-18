TYPE(drgForm) DTYPE(10) TITLE( Naplánované úlohy Asystem++ - èasovaè) SIZE(100,26);
              GUILOOK( Menu:y)


  TYPE(Action) CAPTION(      p~Arametry) EVENT (sel_datkomhd_usr) ATYPE(3) ICON1() ICON2(401) TIPTEXT(Nastavení parametrù komunikace)


  TYPE(Static) STYPE(13) SIZE( 51.6,25.2) FPOS( 48.0, 0.3)  RESIZE(yn)

   TYPE(TEXT) CAPTION(IdÚlohy)               CPOS( 1, .2) CLEN(11) FONT(1)
     TYPE(COMBOBOX) NAME(userstsk->cID)      FPOS(12, .2) FLEN(12)       VALUES(a,a,a) NOREVISION()
     TYPE(TEXT)     NAME(userstsk->cidtask)  CPOS(32, .2) CLEN(15) FONT(2)

   TYPE(TEXT) CAPTION(Uživatel)               CPOS( 1,1.4) CLEN(11) FONT(1)
     TYPE(COMBOBOX) NAME(userstsk->cuser)     FPOS(12,1.4) FLEN(30) FONT(2) VALUES(a,a,a,a,a,a,a) NOREVISION()

   TYPE(TEXT) CAPTION(Název objektu)          CPOS( 1,2.8) CLEN(11) FONT(1)
     TYPE(GET)      NAME(userstsk->cnameobj)  FPOS(12,2.8) FLEN(38) FONT(2) PUSH(sys_asystem_sel) NOREVISION()

   TYPE(TEXT) CAPTION(Název úlohy)            CPOS( 1,3.8) CLEN(11) FONT(1)
     TYPE(GET)      NAME(userstsk->cnametask) FPOS(12,3.8) FLEN(38) FONT(2) 

   TYPE(RadioButton) NAME( userstsk->ntypRun) FPOS(1, 6) SIZE(20,4)  ;
                           VALUES( 1:Spouštìt periodicky           , ;
                                   2:Spouštìt dennì                , ;
                                   3:Spouštìt týdnì                  ) ITEMSELECTED(radioItemSelected)


*  periodicky
   TYPE(STATIC) FPOS(0.4,11) SIZE(50,6.9) STYPE(13) CTYPE(2) GROUPS(PER)
     TYPE(TEXT) CAPTION(Datum a èas startu)    CPOS(   1,1) CLEN( 20) FONT(2)                    GROUPS(PER)
     TYPE(GET)       NAME(userstsk->dtskBegin) FPOS(  21,1) FLEN( 11) FONT(1) PUSH(CLICKDATE)    GROUPS(PER)
     TYPE(GET)       NAME(userstsk->ctskBegin) FPOS(  37,1) FLEN(  7) FONT(1) PICTURE(99:99:99)  GROUPS(PER)

     TYPE(TEXT) CAPTION(Perioda opakování)     CPOS(  1,2) CLEN(20) FONT(2)                      GROUPS(PER)
     TYPE(COMBOBOX)  NAME(userstsk->nPerioda)  FPOS( 21,2) FLEN(25) VALUES( 300:  5 min., ;
                                                                             600:10 min., ;
                                                                             900:15 min., ;
                                                                            1800:30 min., ;
                                                                            3600: 1 hod.  )      GROUPS(PER)   
   TYPE(END) 

*  dennì
   TYPE(STATIC) FPOS(0.4,11) SIZE(50,6.9) STYPE(13) CTYPE(2) GROUPS(DEN)
     TYPE(TEXT) CAPTION(Datum a èas startu)  CPOS(   1,1) CLEN( 20) FONT(2)                      GROUPS(DEN)
     TYPE(GET)       NAME(userstsk->dtskBegin)  FPOS(  21,1) FLEN( 11) FONT(1) PUSH(CLICKDATE)   GROUPS(DEN)
     TYPE(GET)       NAME(userstsk->ctskBegin)  FPOS(  37,1) FLEN(  7) FONT(1) PICTURE(99:99:99) GROUPS(DEN)

     TYPE(TEXT) CAPTION(V rozmezí od - do)      CPOS(  1, 2) CLEN(20) FONT(2)                    GROUPS(DEN)
     TYPE(GET)       NAME(userstsk->ctskDenBeg) FPOS( 21, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(DEN)
     TYPE(GET)       NAME(userstsk->ctskDenEnd) FPOS( 37, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(DEN)
   TYPE(END) 

*  týdnì
   TYPE(STATIC) FPOS(0.4,11) SIZE(50,6.9) STYPE(13) CTYPE(2) GROUPS(TYD) 
     TYPE(TEXT) CAPTION(Datum a èas startu)     CPOS(   1,1) CLEN( 20) FONT(2)                   GROUPS(TYD)
     TYPE(GET)       NAME(userstsk->dtskBegin)  FPOS(  21,1) FLEN( 11) FONT(1) PUSH(CLICKDATE)   GROUPS(TYD)
     TYPE(GET)       NAME(userstsk->ctskBegin)  FPOS(  37,1) FLEN(  7) FONT(1) PICTURE(99:99:99) GROUPS(TYD)

     TYPE(TEXT) CAPTION(V rozmezí od - do)      CPOS(  1, 2) CLEN(20) FONT(2)                    GROUPS(TYD)
     TYPE(GET)       NAME(userstsk->ctskDenBeg) FPOS( 21, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(TYD)
     TYPE(GET)       NAME(userstsk->ctskDenEnd) FPOS( 37, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(TYD)

     TYPE(CHECKBOX)  NAME(userstsk->lden1) FPOS( 1, 4) FLEN(10) VALUES(T:Pondìlí,F:Pondìlí)      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden2) FPOS(11, 4) FLEN(10) VALUES(T:Úterý  ,F:Úterý  )      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden3) FPOS(21, 4) FLEN(10) VALUES(T:Støeda ,F:Støeda )      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden4) FPOS(31, 4) FLEN(10) VALUES(T:Ètvrtek,F:Ètvrtek)      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden5) FPOS(41, 4) FLEN(10) VALUES(T:Pátek  ,F:Pátek  )      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden6) FPOS( 1, 5) FLEN(10) VALUES(T:Sobota ,F:Sobota )      GROUPS(TYD)
     TYPE(CHECKBOX)  NAME(userstsk->lden7) FPOS(11, 5) FLEN(10) VALUES(T:Nedìle ,F:Nedìle )      GROUPS(TYD)
   TYPE(END) 

   TYPE(TEXT) CAPTION(Platnost od - do)         CPOS( 1,19) CLEN( 20) FONT(2)
     TYPE(GET)      NAME(userstsk->dplatnyod)   FPOS(21,19) FLEN( 12) FONT(1) PUSH(CLICKDATE) 
     TYPE(GET)      NAME(userstsk->dplatnydo)   FPOS(37,19) FLEN( 12) FONT(1) PUSH(CLICKDATE) 

    TYPE(RadioButton) NAME( userstsk->nstateTsk) FPOS(10,21) SIZE(20,2)    ;
                            VALUES( 1:Spustit na klientovi               , ;
                                    2:Spustit na servru                    )
    TYPE(CHECKBOX)    NAME(userstsk->laktivni)   FPOS(10.2,24) FLEN(20) VALUES(T:   Aktivní úloha,F:   Neaktivní úloha) FONT(5)

  TYPE(End)
 

  TYPE(DBrowse) FILE(USERSTSK) INDEXORD(1) ;
                 FIELDS( cidtask         , ;
                         cnametask::35   , ;
                         ctypobject      , ;
                         czkrobject      , ;
                         cnameobj::35    , ;
                         ctypRun         , ;  
                         cuser             ) ;
                 SIZE(47,24.4) FPOS(0.5, 1.5 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
                 ITEMMARKED(ItemMarked)



* neviditelné pomocné položky
TYPE(TEXT) NAME(usersTsk->cidObject)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->ctypObject)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->czkrObject)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->cprgObject)   FPOS(0,0) CLEN(0)


