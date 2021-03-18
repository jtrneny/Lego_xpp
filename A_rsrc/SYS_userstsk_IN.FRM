TYPE(drgForm) DTYPE(10) TITLE( Naplánované úlohy Asystem++ - èasovaè) SIZE(100,26) ;
              POST(postValidate)                                                   ;
              GUILOOK( Menu:y)


  TYPE(Action) CAPTION(        p~Arametry) EVENT(sel_datkomhd_usr) ATYPE(3) TIPTEXT(Nastavení parametrù komunikace)
  TYPE(Action) CAPTION(    ~Služby)        EVENT(set_asysSrvc_in)  ATYPE(3) TIPTEXT(Nastavení spuštìní služeb A++_service)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(   Start/Stop )       EVENT(set_lisAktivni)   ATYPE(3) ICON1() ICON2(401) TIPTEXT(Spuštìní / zastavení úlohy)


  TYPE(DBrowse) FILE(USERSTSK) INDEXORD(1) ;
                 FIELDS( cidtask         , ;
                         cnametask::35   , ;
                         ctypobject      , ;
                         czkrobject      , ;
                         cnameobj::35    , ;
                         ntypRun         , ;  
                         cuser             ) ;
                 SIZE(47,20) FPOS(.5,1.5) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)

 TYPE(Static) STYPE(13) SIZE(47,4) FPOS(.5,22)  RESIZE(yn)
   TYPE(TEXT) CAPTION( Vazba -> asystem ) CPOS( 1, .2) CLEN(15)
   TYPE(TEXT) NAME(userstsk->cidObject)   CPOS(30, .2) CLEN(15) FONT(2)

   TYPE(TEXT) CAPTION( Vazba -> datkomHd) CPOS( 1,1.2) CLEN(15)
   TYPE(TEXT) NAME(asystem->cidDatKom)    CPOS(30,1.2) CLEN(12) FONT(2)
   TYPE(TEXT) NAME(asystem->nrunTask)     CPOS(40,1.2) CLEN( 4) 
 TYPE(End)



 TYPE(TABPAGE) FPOS(48,0.1) SIZE(52, 25.7)  OFFSET( 2,78) CAPTION(Nastavení) PRE(tabSelect) RESIZE(yx)

   TYPE(Static) STYPE(13) SIZE( 51.4,24.2) FPOS(0.3, 0.2)  RESIZE(yn)

     TYPE(TEXT) CAPTION(IdÚlohy)               CPOS( 1, .2) CLEN(11) FONT(1)
       TYPE(COMBOBOX) NAME(userstsk->ctypTask) FPOS(12, .2) FLEN(12)          VALUES(a,a,a) NOREVISION()
       TYPE(TEXT)     NAME(userstsk->cidTask)  CPOS(32, .2) CLEN(15) FONT(2)

     TYPE(TEXT) CAPTION(Uživatel)               CPOS( 1,1.4) CLEN(11) FONT(1)
       TYPE(COMBOBOX) NAME(userstsk->cuser)     FPOS(12,1.4) FLEN(30) FONT(2) VALUES(a,a,a,a,a,a,a) NOREVISION()

     TYPE(TEXT) CAPTION(Název objektu)          CPOS( 1,2.8) CLEN(11) FONT(1)
       TYPE(GET)      NAME(userstsk->cnameobj)  FPOS(12,2.8) FLEN(38) FONT(1) PUSH(sys_asystem_sel) NOREVISION()

     TYPE(TEXT) CAPTION(Název úlohy)            CPOS( 1,3.8) CLEN(11) FONT(1)
       TYPE(GET)      NAME(userstsk->cnameTask) FPOS(12,3.8) FLEN(38) FONT(1) 

     TYPE(RadioButton) NAME( userstsk->ntypRun) FPOS(1, 5.5) SIZE(20,4)  ;
                             VALUES( 1:Spouštìt periodicky           , ;
                                     2:Spouštìt dennì                , ;
                                     3:Spouštìt týdnì                  ) ITEMSELECTED(radioItemSelected)


     TYPE(STATIC) FPOS(0.4,9) SIZE(50,6.4) STYPE(13) CTYPE(2)
       TYPE(TEXT) CAPTION(Datum a èas startu)    CPOS(   1,1) CLEN( 20) FONT(2)                   
       TYPE(GET)       NAME(userstsk->dtskBegin) FPOS(  21,1) FLEN( 11) FONT(1) PUSH(CLICKDATE)   
       TYPE(GET)       NAME(userstsk->ctskBegin) FPOS(  37,1) FLEN(  7) FONT(1) PICTURE(99:99:99) 
 
* periodicky
       TYPE(TEXT) CAPTION(Perioda opakování)     CPOS(  1,2  ) CLEN(20) FONT(2)                      GROUPS(PER)
       TYPE(COMBOBOX)  NAME(userstsk->nPerioda)  FPOS( 21,2.2) FLEN(24) VALUES(  10:10 sec., ;
                                                                                 15:15 sec., ; 
                                                                                 30:30 sec., ; 
                                                                                 60: 1 min., ;
                                                                                120: 2 min., ;      
                                                                                180: 3 min., ;      
                                                                                240: 4 min., ;      
                                                                                300: 5 min., ;
                                                                                600:10 min., ;
                                                                                900:15 min., ;
                                                                               1800:30 min., ;
                                                                               3600: 1 hod.  )      GROUPS(PER)
*  dennì
       TYPE(TEXT) CAPTION(V rozmezí od - do)      CPOS(  1, 2) CLEN(20) FONT(2)                    GROUPS(DEN)
       TYPE(GET)       NAME(userstsk->ctskDenBeg) FPOS( 21, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(DEN)
       TYPE(GET)       NAME(userstsk->ctskDenEnd) FPOS( 37, 2) FLEN( 7) FONT(1)  PICTURE(99:99:99) GROUPS(DEN)

*  týdnì
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


     TYPE(TEXT) CAPTION(Platnost od - do)         CPOS( 1,16.0) CLEN( 20) FONT(2)
       TYPE(GET)      NAME(userstsk->dplatnyod)   FPOS(21,16.0) FLEN( 12) FONT(1) PUSH(CLICKDATE) 
       TYPE(GET)      NAME(userstsk->dplatnydo)   FPOS(37,16.0) FLEN( 12) FONT(1) PUSH(CLICKDATE) 

     TYPE(TEXT) CAPTION(První start)            CPOS(  1,17.2) CLEN(20) FONT(2)                    
       TYPE(COMBOBOX)  NAME(userstsk->nfirstRun)  FPOS( 21,17.2) FLEN(29) VALUES( 0: dle zadaného intervalu,       ;
                                                                                  1: ihned pøi startu nebo zmìnì  ) 

     TYPE(RadioButton) NAME( userstsk->nstateTsk) FPOS(1,18.5) SIZE(50,2)     ;
                             VALUES( 1:úloha spouštìná na klientovi A++   , ;
                                     2:úloha spouštìná službou A++_service  )

     TYPE(COMBOBOX)  NAME(userstsk->cmachine)     FPOS( 8,21.0) FLEN(38) VALUES( a,a,a,a,a,a )   

     TYPE(PushButton)                             CAPTION( Neaktivní úloha )  ;
                                                  POS( 3, 1)                  ;
                                                  SIZE(355, 30) EVENT(info_stavUlohy) ICON1(0) ICON2(0) ATYPE(3)
    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0) 
  TYPE(End)

  TYPE(TABPAGE) FPOS(48.0,0.1) SIZE(52,25.6) OFFSET(21,60) CAPTION(Historie) PRE(tabSelect) RESIZE(yx)
   TYPE(Static) STYPE(13) SIZE( 51.4,24.2) FPOS(0.3, 0.2)  RESIZE(yn)
    TYPE(DBrowse) FILE(USRTSLOG) INDEXORD(3) ;
                   FIELDS( cdattim:DatumÈasZmìny:17     , ;
                           mLogTask::45                 , ;
                           cdattimbeg:Start:15          , ;
                           cdattimend:Konec:15          , ;
                           cdattimnext:Pøíštì:15        ) ;                          
                 FPOS(0.1, 0.1) SIZE(51.5,18.2) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y) ITEMMARKED(ItemMarked)
                 
    TYPE(MLE) NAME(USRTSLOG->mLogTask) FPOS(0.1, 18.3) SIZE(51.5,6.0) READONLY() 

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
   TYPE(End)    
  TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(usersTsk->cidObject)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->ctypObject)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->czkrObject)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->cprgObject)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(usersTsk->cdevice)      FPOS(0,0) CLEN(0)
