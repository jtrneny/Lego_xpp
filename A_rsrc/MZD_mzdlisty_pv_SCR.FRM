TYPE(drgForm) DTYPE(10) TITLE(Mzdové listy za poøadí PV) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(MZD)                      ;
              PRINTFILES(mzdlisth:,                                                ;
                         mzdlisti:nmzdlisth=sid)                                              

TYPE(Action) CAPTION(~aktMzdList ) EVENT(aktMzdListy)   TIPTEXT(Aktualizace mzdových listù)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(98.75,1.25)

*  TYPE(TEXT) CAPTION(Upøesòující  nabídka : ) CPOS(13,0.4) CLEN(25) CTYPE(3) FONT(2)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:AKTIVNIOBD) FPOS(50,0.5) FLEN(22) ;
*                VALUES(a,a,a,a,a,a,a,a,a);
*                COMBOINIT(comboBoxInit);
*                ITEMSELECTED(comboItemSelected)

*  TYPE(ComboBox) NAME(UCT_ucetsald_CRD:NASTAVENI)  FPOS(76.5,0.5) FLEN(20);
*                VALUES(0:Otevøené položky,1:Zavøené položky,2:Kompletní saldo);
*                ITEMSELECTED(comboItemSelected)
TYPE(END)


TYPE(DBrowse) FPOS(0.50,1.60) SIZE(98.75,8.0) FILE(MZDLISTH) INDEXORD(8)                     ;
             FIELDS( nRok, cJmenoRozl::60, nPorPraVzt, nOsCisPrac,                           ;
                     cKmenStrPr  )      ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

TYPE(DBrowse) FPOS(0.50,9.60) SIZE(98.75,11.0) FILE(MZDLISTI) INDEXORD(1)                    ;
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

TYPE(STATIC) STYPE( 2) FPOS(0.50,20.80) CAPTION(Údaje mzdovéhio listu) SIZE(98.75,3.50) RESIZE(YX)
    TYPE(TEXT) CAPTION(01)                       CPOS( 2, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_01)      CPOS( 5, 1.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(02)                       CPOS(18, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_02)      CPOS(21, 1.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(03)                       CPOS(34, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_03)      CPOS(37, 1.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(04)                       CPOS(50, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_04)      CPOS(53, 1.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(05)                       CPOS(66, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_05)      CPOS(69, 1.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(06)                       CPOS(82, 1.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_06)      CPOS(85, 1.5)      CLEN(13)  BGND(13) PP(2)

    TYPE(TEXT) CAPTION(07)                       CPOS( 2, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_07)      CPOS( 5, 2.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(08)                       CPOS(18, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_08)      CPOS(21, 2.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(09)                       CPOS(34, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_09)      CPOS(37, 2.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(10)                       CPOS(50, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_10)      CPOS(53, 2.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(11)                       CPOS(66, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_11)      CPOS(69, 2.5)      CLEN(13)  BGND(13) PP(2)
    TYPE(TEXT) CAPTION(12)                       CPOS(82, 2.5)      CLEN( 3)
     TYPE(TEXT) NAME(MzdListI ->cObdobi_12)      CPOS(85, 2.5)      CLEN(13)  BGND(13) PP(2)


TYPE(END)