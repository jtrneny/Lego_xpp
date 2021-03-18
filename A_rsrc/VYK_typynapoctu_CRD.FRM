TYPE(drgForm) DTYPE(10) TITLE(Systémové nastavení pro definice výkazù) SIZE(100,25) ;
              GUILOOK(Action:n,IconBar:y,Menu:y) CARGO() POST( PostValidate)

*TYPE(Action) CAPTION(~Typy úètování) EVENT(Pohyby_DOKLADY)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
*TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


  TYPE(EBrowse) FPOS(0.50,0.2) SIZE(98.75,15.0) FILE(DEFVYKSY) INDEXORD(1) POPUPMENU(y)                              ;
                                              CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) ITEMSELECTED(ItemSelected)
    TYPE(COMBOBOX)       NAME(defvyksy->cid)          FPOS( 1,0) FLEN(13) FCAPTION(typ_výkazu )                  ; 
                                                                            VALUES( DIST:Distribuèní           , ;
                                                                                    USER:Uživatelská  )
    TYPE(TEXT)           NAME(defvyksy->cidsysvyk)    FPOS( 2,0) CLEN(10) FCAPTION(id_Výkazu)
    TYPE(GET)            NAME(defvyksy->ctask)        FPOS( 3,0) FLEN( 2) FCAPTION(úloha)      
    TYPE(GET)            NAME(defvyksy->ctypnapvyk)   FPOS( 4,0) FLEN(12) FCAPTION(typ nápoètu)   
    TYPE(GET)            NAME(defvyksy->cnaznapvyk)   FPOS( 5,0) FLEN(35) FCAPTION(název nápoètu)   
    TYPE(COMBOBOX)       NAME(defvyksy->ctyppounap)   FPOS( 6,0) FLEN(12) FCAPTION(vazba)                        ; 
                                                                            VALUES( I:položky                  , ;
                                                                                    H:hlavièky )
    TYPE(GET)            NAME(defvyksy->cmainfile)    FPOS( 7,0) FLEN( 12) FCAPTION(øídící tabulka)  
    TYPE(GET)            NAME(defvyksy->cmainfield)   FPOS( 8,0) FLEN( 12) FCAPTION(øídící atribut výbìru)   
    TYPE(GET)            NAME(defvyksy->cmainvyber)   FPOS( 9,0) FLEN( 30) FCAPTION(atribut výbìru)   
    TYPE(GET)            NAME(defvyksy->cgrptable)    FPOS(10,0) FLEN( 30) FCAPTION(výbìr za skupinu)  
    TYPE(GET)            NAME(defvyksy->mgrpvyber)    FPOS(11,0) FLEN( 30) FCAPTION(výbìr za skupinu)  
  TYPE(END)


  TYPE(TabPage) FPOS(0.5,15.5) SIZE(99,9.2) TTYPE(3) OFFSET( 1,86) CAPTION(Nastavení)
    TYPE(MLE) NAME('DEFVYKSY->mBlock') FPOS(0.50,0.95) SIZE(47.40,6.90) RESIZE(x,y) ;
            READONLY(N) FCAPTION(Nápoèet) CPOS(1.5, 0.10) CLEN(10) FONT(5)
 
    TYPE(MLE) NAME('DEFVYKSY->mPodminka') FPOS(50.35,0.95) SIZE(47.40,6.90) RESIZE(y,x) ;
           READONLY(N) FCAPTION(Podmínka) CPOS(51.35, 0.10) CLEN(10) FONT(5)

  TYPE(END)


  TYPE(TabPage) FPOS(0.5,15.5) SIZE(99,9.2) TTYPE(3) OFFSET(14,72) CAPTION(Metodika)
    TYPE(MLE) NAME('DEFVYKSY->mMetodika') FPOS(0.50,0.95) SIZE(98.35,6.90) ;
             READONLY(N) FCAPTION(Metodika) CPOS(1.5, 0.1) CLEN(20) FONT(5)
  TYPE(END)

  TYPE(Text) NAME(defvyksy->nid)          CPOS(0,0) CLEN( 0)

