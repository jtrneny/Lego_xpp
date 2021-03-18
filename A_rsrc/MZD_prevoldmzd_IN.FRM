TYPE(drgForm) DTYPE(10) TITLE(Pøevod pùvodních mezd A_SYSTEM - dos) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() POST( PostValidate) PRE(PreValidate) 

TYPE(Action) CAPTION(~Pøevod)    EVENT(PrevOldMzd)  TIPTEXT(Pøevod z pùvodního A_SYSTEM )
TYPE(Action) CAPTION(~DopòOsoby) EVENT(modifyOsoby) TIPTEXT(Doplníme si OSOBY o údaje z PRESONAL ... )
TYPE(Action) CAPTION(~ZákazPøev) EVENT(zrusPrevod)  TIPTEXT(Zakáže pøevod všech dat ... )
TYPE(Action) CAPTION(~Akt01/13)  EVENT(aktPocatek)  TIPTEXT(Aktualizuje období 01/13 z MSPRC_MZ-dovolená ... )
 

*
  TYPE(EBrowse) FPOS(0.50,0.20) SIZE(98.75,24.5) FILE(PREVODMZ) INDEXORD(4)  ;
                                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POSTVALIDATE(postValidate) POPUPMENU(yy)

    TYPE(TEXT)   NAME(prevodmz->ctask)       FPOS( 1,0) FLEN( 3) FCAPTION(úloha)
    TYPE(COMBOBOX) NAME(prevodmz->ntypprevod) FPOS( 2,0) FLEN(15)               ; 
                                              VALUES( 0:Provádìt   pøevod     , ;
                                                      1:Neprovádìt pøevod     , ;
                                                      2:Vylouèeno z pøevodu   , ;
                                                      3:Doèasnì vylouèeno z pøevodu )
    TYPE(GET)    NAME(prevodmz->cnewfile)    FPOS( 3,0) FLEN(10) FCAPTION(nová_tabulka pøevodu)
    TYPE(GET)    NAME(prevodmz->coldfile)    FPOS( 4,0) FLEN(15) FCAPTION(pùvodní_tabulka pøevodu)
    TYPE(GET)    NAME(prevodmz->coldpath)    FPOS( 5,0) FLEN(15) FCAPTION(pùvodní_cesta na tabulku)
    TYPE(GET)    NAME(prevodmz->nstavprev)   FPOS( 6,0) FLEN(15) FCAPTION(stav_pøevodu)
    TYPE(GET)    NAME(prevodmz->nporadi)     FPOS( 7,0) FLEN(5)  FCAPTION(poøadí)
    TYPE(COMBOBOX) NAME(prevodmz->nzpusmaz) FPOS( 8,0) FLEN(20)               ; 
                                              VALUES( 0:Nemazat novou tabulku     , ;
                                                      1:Vymazat novou tabulku      )
    TYPE(MLE)    NAME(prevodmz->mblok)       FPOS( 9,0) FLEN(15) FCAPTION(blok_pøevodu)
    TYPE(MLE)    NAME(prevodmz->mbeginblok)  FPOS(10,0) FLEN(15) FCAPTION(start_blok_pøevodu)
    TYPE(MLE)    NAME(prevodmz->mendblok)    FPOS(11,0) FLEN(15) FCAPTION(konec_blok_pøevodu)
    TYPE(MLE)    NAME(prevodmz->mprotokol)   FPOS(12,0) FLEN(15) FCAPTION(protokol)
    TYPE(TEXT)   NAME(prevodmz->czacprev)    FPOS(13,0) FLEN(15) FCAPTION(zaèátek_pøevodu)
    TYPE(TEXT)   NAME(prevodmz->ckonprev)    FPOS(14,0) FLEN(15) FCAPTION(konec_pøevodu)
    TYPE(TEXT)   NAME(prevodmz->nprevrec)    FPOS(15,0) FLEN(15) FCAPTION(poèet_pøev.záznamù)
    TYPE(TEXT)   NAME(prevodmz->nlastrec)    FPOS(16,0) FLEN(15) FCAPTION(posled_pøev.záznam)

  TYPE(END)

