TYPE(drgForm) DTYPE(10) TITLE(Úèetní výkazy - pøehled) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() OBDOBI(UCT)                      ;
              PRINTFILES(uctvykhd:,                                                ;
                         uctvykit:nuctvykhd=sid)                                              

TYPE(Action) CAPTION(~aktVýkazu ) EVENT(aktVykazu)   TIPTEXT(Aktualizace úèetního výkazu )
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


TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Rozvaha) OFFSET( 1,82) PRE(tabSelect) TABHEIGHT(1.1) PRE(tabSelect)

  TYPE(DBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             FIELDS( M->aktStav:akt:3.3::2,               ;
                     nRok,                                ;
                     cObdobi,                             ;
                     cTypUctVyk,                          ;
                     cTypVykazu,                          ;
                     cNazVykazu::30,                      ;
                     cIDvykazu  )                         ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

  TYPE(DBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             FIELDS( cTypUctVyk,                     ;
                     cOznRadVyk,                     ;
                     cTextRadek::30,                 ;
                     nRadUctVyk,                     ;
                     nSloupec01:Brutto,              ; 
                     nSloupec02:Korekce,             ; 
                     nSloupec03:Netto,               ; 
                     nSloupec04:BruttoMinOb,         ; 
                     nSloupec05:KorekceMinOb,        ; 
                     nSloupec06:NettoMinOb,          ; 
                     nZaSloup01:ZaoBrutto,           ; 
                     nZaSloup02:ZaoKorekce,          ; 
                     nZaSloup03:ZaoNetto,            ; 
                     nZaSloup04:ZaoBruttoMinOb,      ;      
                     nZaSloup05:ZaoKorekceMinOb,     ;      
                     nZaSloup06:ZaoNettoMinOb,       ;	
                     nRadekVyk:tmØádek)              ;
             CURSORMODE(3) PP(7) 
TYPE(END) 


TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Výk.ziskù a ztrát)    OFFSET(17,66) PRE(tabSelect) TABHEIGHT(1.1)  PRE(tabSelect)

  TYPE(DBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             FIELDS( M->aktStav:akt:3.3::2,               ;
                     nRok,                                ;
                     cObdobi,                             ;
                     cTypUctVyk,                          ;
                     cTypVykazu,                          ;
                     cNazVykazu::30,                      ;
                     cIDvykazu  )                         ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

  TYPE(DBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             FIELDS( cTypUctVyk,                    ;
                     cOznRadVyk,                    ;
                     cTextRadek::30,                ;
                     nRadUctVyk,                    ;
                     nSloupec01:Bìzné období,       ; 
                     nSloupec02:Minulé období,      ;
                     nRadekVyk:tmØádek)             ;
             CURSORMODE(3) PP(7) 

TYPE(END) 



TYPE(TabPage) FPOS(0.5,1.75) SIZE(100,22.9) CAPTION(Cash flow)    OFFSET(33,49) PRE(tabSelect) TABHEIGHT(1.1)  PRE(tabSelect)
  TYPE(DBrowse) FPOS(0.50,0.10) SIZE(98.75,8.0) FILE(UCTVYKHD) INDEXORD(5)                     ;
             FIELDS( M->aktStav:akt:3.3::2,                          ;
                     nRok,                                ;
                     cObdobi,                             ;
                     cTypUctVyk,                          ;
                     cTypVykazu,                          ;
                     cNazVykazu::30,                      ;
                     cIDvykazu  )                         ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)

  TYPE(DBrowse) FPOS(0.50,8.00) SIZE(98.75,14.0) FILE(UCTVYKIT) INDEXORD(7)                    ;
             FIELDS( cTypUctVyk,                     ;
                     cOznRadVyk,                     ;
                     cTextRadek::30,                 ;
                     nRadUctVyk,                     ;
                     nSloupec01:Bìzné období,        ; 
                     nSloupec02:Minulé období,       ;
                     nRadekVyk:tmØádek)              ;
             CURSORMODE(3) PP(7) 


TYPE(END) 

