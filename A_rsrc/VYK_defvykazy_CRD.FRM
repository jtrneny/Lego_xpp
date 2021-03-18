TYPE(drgForm) DTYPE(10) TITLE(Definice výkazù) SIZE(100,25) ;
              GUILOOK(Action:y,IconBar:y) CARGO() POST( PostValidate) 

TYPE(Action) CAPTION(~Typy nápoètù) EVENT(TypyNapoctu) TIPTEXT(Poøízení a oprava )


*
  TYPE(EBrowse) FPOS(0.50,0.20) SIZE(98.75,10.0) FILE(DEFVYKHD) INDEXORD(1)  ;
                                CURSORMODE(3) PP(7) POSTVALIDATE(postValidate) POPUPMENU(yy)

    TYPE(COMBOBOX) NAME(defvykhd->cid)     FPOS( 1,0) FLEN(13) FCAPTION(typ_výkazu )         ; 
                                                        VALUES( DIST:Distribuèní           , ;
                                                                USER:Uživatelský  )
    TYPE(TEXT)  NAME(defvykhd->cidvykazu)  FPOS( 2,0) CLEN(10) FCAPTION(id_Výkazu)
    TYPE(GET)   NAME(defvykhd->ctask)      FPOS( 3,0) FLEN( 7) FCAPTION(úloha)
    TYPE(GET)   NAME(defvykhd->ctypVykazu) FPOS( 4,0) FLEN(15) FCAPTION(zkratka_Výkazu)
    TYPE(GET)   NAME(defvykhd->crozatrvyk) FPOS( 5,0) FLEN(15) FCAPTION(rozlAtr_Výkazu)
    TYPE(GET)   NAME(defvykhd->cnazVykazu) FPOS( 6,0) FLEN(35) FCAPTION(název_Výkazu)
    TYPE(GET)   NAME(defvykhd->ctypNapVyb) FPOS( 7,0) FLEN(15) FCAPTION(blok_Start)  PUSH(selTypNapHb)
    TYPE(GET)   NAME(defvykhd->ctypNapVye) FPOS( 8,0) FLEN(15) FCAPTION(blok_Konec)  PUSH(selTypNapHe)

  TYPE(END)


*
  TYPE(EBrowse) FPOS(-0.5,10.2) SIZE(98.75,9.2) FILE(DEFVYKIT) INDEXORD(8)  ;  
                                                               CURSORMODE(3) PP(9) 

      TYPE(COMBOBOX) NAME(defvykit->ctypKumVyk) FLEN(27)                     ; 
                                                VALUES( K1:Kum.øádek                               [K1], ;
                                                        K2:Kum.klíè a øádek                      [K2], ;
                                                        K3:Kum.nák.výs. a øádek             [K3], ;
                                                        K4:Kum.nák.výs.a øád.i prázdné  [K4], ;
                                                        K5:Kum.skupina a øádek               [K5], ;
                                                        K6:Kum.skup.plus výbìr a øádek     [K6], ;
                                                        F1:Funkce v prùchodu do num.sloupce     [F1], ;
                                                        V0:Volný øádek                              [V0], ; 
                                                        V1:Výpoètový øádek                      [V1], ;
                                                        V2:Volný øádek s nák.str.              [V2], ;
                                                        V3:Výpoètový øádek s nák.str.      [V3], ;
                                                        B1:Blok vrátí do num.sloupce        [B1], ;
                                                        B2:Blok vrátí do txt.sloupce          [B2]) 

      TYPE(TEXT) NAME(defvykit->cidvykazu)       CLEN( 9) FCAPTION(id_Výkazu)
      TYPE(GET)  NAME(defvykit->cskupina1)       FLEN( 3) FCAPTION(skup_1)
      TYPE(GET)  NAME(defvykit->cskupina2)       FLEN( 3) FCAPTION(skup_2)
      TYPE(GET)  NAME(defvykit->cskupina3)       FLEN( 3) FCAPTION(skup_3)
      TYPE(GET)  NAME(defvykit->nradekVyk)       FLEN( 4) FCAPTION(øádek)
      TYPE(GET)  NAME(defvykit->cnazRadVyk)      FLEN(30) FCAPTION(název øádku)
      TYPE(GET)  NAME(defvykit->nsloupVyk)       FLEN( 5) FCAPTION(sloupec)
      TYPE(GET)  NAME(defvykit->cnazSloVyk)      FLEN(30) FCAPTION(název sloupce)
      TYPE(GET)  NAME(defvykit->cnazBunVyk)      FLEN(30) FCAPTION(název buòky)
      TYPE(MLE)  NAME(defvykit->mvyber)          FLEN(15) FCAPTION(výbìr) SCROLL(nn)
      TYPE(MLE)  NAME(defvykit->mvyraz)          FLEN(15) FCAPTION(výraz) SCROLL(nn)

      TYPE(COMBOBOX) NAME(defvykit->ntypZaokr)   FLEN(20)                            ; 
                                                VALUES( 0: Koneèná hodnota    [0] , ;
                                                        1: Pøed výrazy v tab.  [1] ) 

      TYPE(GET)  NAME(defvykit->nkodZaokr)       FLEN( 5) FCAPTION(zaokr)
      TYPE(GET)  NAME(defvykit->ctypNapVyk)      FLEN(15) FCAPTION(blok_Nápoètu) PUSH(selTypNapIn)
      TYPE(GET)  NAME(defvykit->ctypNapVyB)      FLEN(15) FCAPTION(blok_Start) PUSH(selTypNapIb)
      TYPE(GET)  NAME(defvykit->ctypNapVyE)      FLEN(15) FCAPTION(blok_Konec) PUSH(selTypNapIe)
      TYPE(GET)  NAME(defvykit->ctextRadek)      FLEN(30) FCAPTION(text_Øádek)
      TYPE(GET)  NAME(defvykit->ctextSloup)      FLEN(30) FCAPTION(text_Sloupce)
      TYPE(GET)  NAME(defvykit->ctextBunky)      FLEN(30) FCAPTION(text_Buòky)
      TYPE(GET)  NAME(defvykit->ctextTm1)        FLEN(20) FCAPTION(text_Tm1)
      TYPE(GET)  NAME(defvykit->ctextTm2)        FLEN(20) FCAPTION(text_Tm2)
      TYPE(GET)  NAME(defvykit->ctextTm3)        FLEN(20) FCAPTION(text_Tm3)
  TYPE(END)

TYPE(TabPage) FPOS(0.5,19.5) SIZE(99,5.2) TTYPE(3) OFFSET( 1,86) CAPTION(Výbìr)
  TYPE(MLE) NAME('DEFVYKIT->mVYBER') FPOS(0.50,0.2) SIZE(98.35,3.75) ;
             READONLY(Y) FCAPTION(Výbìr) CPOS(1.5, 17.8) CLEN(20)
TYPE(END)

TYPE(TabPage) FPOS(0.5,19.5) SIZE(99,5.2) TTYPE(3) OFFSET(14,72) CAPTION(Výraz)
  TYPE(MLE) NAME('DEFVYKIT->mVyraz') FPOS(0.50,0.2) SIZE(98.35,3.75) ;
             READONLY(Y) FCAPTION(Výraz) CPOS(1.5, 17.8) CLEN(20)
TYPE(END)

TYPE(TabPage) FPOS(0.5,19.5) SIZE(99,5.2) TTYPE(3) OFFSET(28,58) CAPTION(Nápoèet)
  TYPE(MLE) NAME('DEFVYKSY->mBlock') FPOS(0.50,0.2) SIZE(98.35,3.75) ;
             READONLY(Y) FCAPTION(Nápoèet) CPOS(1.5, 17.8) CLEN(20)
TYPE(END)

TYPE(TabPage) FPOS(0.5,19.5) SIZE(99,5.2) TTYPE(3) OFFSET(42,44) CAPTION(Podmínka)
  TYPE(MLE) NAME('DEFVYKSY->mPodminka') FPOS(0.50,0.2) SIZE(98.35,3.75) ;
             READONLY(Y) FCAPTION(Podmínka) CPOS(1.5, 17.8) CLEN(20)
TYPE(END)


  TYPE(Text) NAME(defvykhd->NID)          CPOS(0,0) CLEN( 0)
  TYPE(Text) NAME(defvykhd->CIDSYSVYKB)   CPOS(0,0) CLEN( 0)
  TYPE(Text) NAME(defvykhd->CIDSYSVYKE)   CPOS(0,0) CLEN( 0)
*
  TYPE(Text) NAME(defvykit->NID)          CPOS(0,0) CLEN( 0)
  TYPE(Text) NAME(defvykit->CIDSYSVYKN)   CPOS(0,0) CLEN( 0)
  TYPE(Text) NAME(defvykit->CIDSYSVYKB)   CPOS(0,0) CLEN( 0)
  TYPE(Text) NAME(defvykit->CIDSYSVYKE)   CPOS(0,0) CLEN( 0)



