TYPE(drgForm) DTYPE(10) TITLE(Pøevod pùvodních dat A_SYSTEM - dos) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() POST( PostValidate) PRE(PreValidate) 

TYPE(Action) CAPTION(~Pøevod) EVENT(PrevOldAsys) TIPTEXT(Pøevod z pùvodního A_SYSTEM )


*
  TYPE(EBrowse) FPOS(0.50,0.20) SIZE(98.75,24.5) FILE(PREVDAT) INDEXORD(4)  ;
                                CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POSTVALIDATE(postValidate) POPUPMENU(yy)

    TYPE(TEXT)   NAME(prevdat->ctask)       FPOS( 1,0) FLEN( 3) FCAPTION(úloha)
    TYPE(COMBOBOX) NAME(prevdat->ntypprevod) FPOS( 2,0) FLEN(15)               ; 
                                              VALUES( 0:Provádìt   pøevod     , ;
                                                      1:Neprovádìt pøevod     )
    TYPE(GET)    NAME(prevdat->cnewfile)    FPOS( 3,0) FLEN(10) FCAPTION(nová_tabulka pøevodu)
    TYPE(GET)    NAME(prevdat->coldfile)    FPOS( 4,0) FLEN(15) FCAPTION(pùvodní_tabulka pøevodu)
    TYPE(GET)    NAME(prevdat->coldpath)    FPOS( 5,0) FLEN(15) FCAPTION(pùvodní_cesta na tabulku)
    TYPE(GET)    NAME(prevdat->nstavprev)   FPOS( 6,0) FLEN(15) FCAPTION(stav_pøevodu)
    TYPE(COMBOBOX) NAME(prevdat->nzpusmaz) FPOS( 7,0) FLEN(20)               ; 
                                              VALUES( 0:Nemazat novou tabulku     , ;
                                                      1:Vymazat novou tabulku      )
    TYPE(MLE)    NAME(prevdat->mblok)       FPOS( 8,0) FLEN(15) FCAPTION(blok_pøevodu)
    TYPE(MLE)    NAME(prevdat->mbeginblok)  FPOS( 9,0) FLEN(15) FCAPTION(start_blok_pøevodu)
    TYPE(MLE)    NAME(prevdat->mendblok)    FPOS(10,0) FLEN(15) FCAPTION(konec_blok_pøevodu)
    TYPE(MLE)    NAME(prevdat->mprotokol)   FPOS(11,0) FLEN(15) FCAPTION(protokol)
    TYPE(TEXT)   NAME(prevdat->czacprev)    FPOS(12,0) FLEN(15) FCAPTION(zaèátek_pøevodu)
    TYPE(TEXT)   NAME(prevdat->ckonprev)    FPOS(13,0) FLEN(15) FCAPTION(konec_pøevodu)
    TYPE(TEXT)   NAME(prevdat->nprevrec)    FPOS(14,0) FLEN(15) FCAPTION(poèet_pøev.záznamù)
    TYPE(TEXT)   NAME(prevdat->nlastrec)    FPOS(15,0) FLEN(15) FCAPTION(posled_pøev.záznam)

  TYPE(END)

