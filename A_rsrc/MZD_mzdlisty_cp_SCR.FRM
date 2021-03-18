TYPE(drgForm) DTYPE(10) TITLE(Mzdové listy za osobní èíslo) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD)            ;
              PRINTFILES(msosb_mo:,                                      ;
                         mzdlisth:nmsosb_mo=sid,                         ;
                         mzdlisti:nmzdlisth=sid)                                              

TYPE(Action) CAPTION(~aktMzdList ) EVENT(aktMzdListy)   TIPTEXT(Aktualizace mzdových listù)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(DBrowse) FPOS(0.50,0.1) SIZE(98.75,7.8) FILE(MSOSB_MO) INDEXORD(1)                     ;
             FIELDS(nRok, cJmenoRozl::60, nOsCisPrac  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarkedOsb)


TYPE(DBrowse) FPOS(0.50,7.60) SIZE(98.75,5.0) FILE(MZDLISTH) INDEXORD(10)                     ;
             FIELDS( nOsCisPrac,nPorPraVzt)                                                  ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(DBrowse) FPOS(0.50,12.40) SIZE(98.75,9.8) FILE(MZDLISTI) INDEXORD(4)                    ;
             FIELDS( nRadMzdLis,        ;
                     cRadMzdLis::30,    ;
                     cCelkemRok::10,    ;
                     cObdobi_01::10,    ; 
                     cObdobi_02::10     ; 
                     cObdobi_03,        ; 
                     cObdobi_04,        ; 
                     cObdobi_05,        ; 
                     cObdobi_06,        ; 
                     cObdobi_07,        ; 
                     cObdobi_08,        ; 
                     cObdobi_09,        ; 
                     cObdobi_10,        ; 
                     cObdobi_11,        ; 
                     cObdobi_12,        ;  
                     nTypRadMzL)        ;
             CURSORMODE(3) PP(7) 

TYPE(STATIC) STYPE( 2) FPOS(0.50,21.80) CAPTION(Údaje mzdovéhio listu) SIZE(98.75,2.60) RESIZE(YX)
    TYPE(TEXT) CAPTION(01)                       CPOS( 2, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_01)      CPOS( 5, 0.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(02)                       CPOS(18, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_02)      CPOS(21, 0.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(03)                       CPOS(34, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_03)      CPOS(37, 0.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(04)                       CPOS(50, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_04)      CPOS(53, 0.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(05)                       CPOS(66, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_05)      CPOS(69, 0.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(06)                       CPOS(82, 0.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_06)      CPOS(85, 0.8)      CLEN(13)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(07)                       CPOS( 2, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_07)      CPOS( 5, 1.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(08)                       CPOS(18, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_08)      CPOS(21, 1.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(09)                       CPOS(34, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_09)      CPOS(37, 1.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(10)                       CPOS(50, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_10)      CPOS(53, 1.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(11)                       CPOS(66, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_11)      CPOS(69, 1.8)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(12)                       CPOS(82, 1.8)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_12)      CPOS(85, 1.8)      CLEN(13)  BGND(13) PP(2)


TYPE(END)