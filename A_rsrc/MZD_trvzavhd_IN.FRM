TYPE(drgForm) DTYPE(10) TITLE(Trvalý závazek) SIZE(110,17.5)  FILE(TRVZAVHDw)                               ;
                                                              GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar) ;
                                                              POST(postValidate)


  TYPE(Static) STYPE(1) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y)
    TYPE(ComboBox) NAME(cTYPPOHYBU) FPOS(66,0.5) FLEN(38) VALUES(a,a,a,a)             ;
                                                          ITEMMARKED(comboItemMarked) ;
                                                          ITEMSELECTED(comboItemSelected) PP(2) NOREVISION() 

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(106,9)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(54,-.25) CLEN(10)

      TYPE(ComboBox) NAME(cTYPVARSYM) FPOS(1,-.01) FLEN(47) VALUES(          :Variabilní symbol je konstantní     , ;
                                                                   PFv      :Vojenský otevøený penzijní fond      , ;
                                                                   PFp      :Penzijní spoleènost èeské pojišovny , ;
                                                                   PFc      :Penzijní fond èeské spoøitelny   ) ;  
                                                           ITEMMARKED(comboItemMarked) ;
                                                           ITEMSELECTED(comboItemSelected) PP(2)

      TYPE(GET)  NAME(CVARSYM)    FPOS(18,1.2) FLEN(20) FCAPTION(Variabilní symbol ... )  CPOS( 1,1.2)             PP(2)
      TYPE(GET)  NAME(NKONSTSYMB) FPOS(18,2.2) FLEN(10) FCAPTION(Konstantní symbol ... )  CPOS( 1,2.2)             PP(2)
        TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(30,2.2) CLEN(20) 
      TYPE(GET)  NAME(CSPECSYMB)  FPOS(18,3.2) FLEN(10) FCAPTION(Specifický symbol ... )  CPOS( 1,3.2)             PP(2)

      TYPE(STATIC) STYPE(2) FPOS(52,0) SIZE(54,9)
        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(28) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL) NOREVISION()
         TYPE(TEXT)     CAPTION([)      CPOS(44,1) CLEN( 2)
         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(45,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
         TYPE(TEXT)     CAPTION(])      CPOS(51,1) CLEN( 2)
        
        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
        TYPE(GET) NAME(CDIC)       FPOS(23,2) FLEN(28)

        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(38) FCAPTION(Název ...  )             CPOS(2,3)
      TYPE(END)  
    TYPE(END)
  TYPE(END)    


  TYPE(STATIC) STYPE(1) FPOS(1,6.5) SIZE(108,12.4)
    TYPE(STATIC) STYPE(2) FPOS(1,-1) SIZE(106,6)

      TYPE(STATIC) STYPE(2) FPOS(0,2) SIZE(52.1,4) CAPTION(ODBÌRATEL)
        TYPE(GET) NAME(CBANK_UCT)  FPOS(18,1) FLEN(25) FCAPTION(Uhradit z úètu ...  )   CPOS( 1,1)             PP(2)
        TYPE(GET) NAME(CVNBAN_UCT) FPOS(18,2) FLEN(25) FCAPTION(Vnitro úèet ...  )      CPOS( 1,2)
        TYPE(GET) NAME(CTEXTFAKT)  FPOS( 1,3)  FLEN(42)
      TYPE(End)

      TYPE(STATIC) STYPE(2) FPOS(52,-1) SIZE(54,9)
        
        TYPE(GET) NAME(CNAZEV2)    FPOS(13,2) FLEN(38)
        TYPE(GET) NAME(CULICE)     FPOS(13,3) FLEN(38) FCAPTION(Ulice ...  )             CPOS(2,3)
        TYPE(GET) NAME(CPSC)       FPOS(13,4) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,4)
        TYPE(GET) NAME(CSIDLO)     FPOS(23,4) FLEN(28)
        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,5) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,5)             PP(2)
         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(23,5) CLEN(29) BGND(13)

        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,6) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,6)             PP(2)
         TYPE(TEXT) NAME(hd_ucet->CNAZ_UCT) CPOS(23,6) CLEN(29) BGND(13)
      TYPE(END)   
    TYPE(END)

* --
    TYPE(STATIC) STYPE(2) FPOS(1,5.1) SIZE(106,5)
      TYPE(GET) NAME(cZpusSraz) FPOS(65, 0.8) FLEN(11) FCAPTION(Zpùsob gen ... )      CPOS(52, 0.8)          CLEN(12) PP(2)
        TYPE(TEXT) NAME(C_ZPUSRZ->CPOPISZPSR) CPOS(78,0.8) CLEN(28)
      TYPE(GET) NAME(cPerioda) FPOS(65, 1.8) FLEN(11) FCAPTION(Perioda gen ... )      CPOS(52, 1.8)          CLEN(12) PP(2)
        TYPE(TEXT) NAME(C_PERIOD->CNAZPERIOD) CPOS(78,1.8) CLEN(28)

      TYPE(GET) NAME(CZKRTYPUHR) FPOS(65, 2.8) FLEN(11) FCAPTION(Typ úhrady ... )      CPOS(52, 2.8)          CLEN(12) PP(2)
        TYPE(TEXT) NAME(C_TYPUHR->CPOPISUHR) CPOS(78,2.8) CLEN(28)

      TYPE(GET) NAME(DGENEROVAT) FPOS(65, 3.8) FLEN(11) FCAPTION(generovat od - do ... )  CPOS(50, 3.8) CTYPE(2) CLEN(12) PP(2) PUSH(CLICKDATE)
      TYPE(GET) NAME(DGENERLAST) FPOS(78, 3.8) FLEN(11)                                                 CTZPE(2)          PP(2) PUSH(CLICKDATE)

      TYPE(GET) NAME(NCENZAHCEL) FPOS(26,  2.3) FLEN(17) FCAPTION(Uhradit celkem  ... ) CPOS( .7,  2.3) CLEN(15) CTYPE(2)
    TYPE(End)
* --
    TYPE(PushButton) POS(102,18.2) SIZE(5,1)  EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(trvzavhdw->mpopisfak,1)
  TYPE(End)


* neviditelné pomocné položky
TYPE(TEXT) NAME(trvzavitw->cfile_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nrecs_iv)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nnapocet)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nvypsazdan)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->njeddan)     FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->ncountDL)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->ncislPolob)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nisParZal)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->ncisloDD)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nnullDph)    FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nCeJPrZDZ)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->ncenaSzbo)   FPOS(0,0) CLEN(0)
*
TYPE(TEXT) NAME(trvzavitw->nsubCount)   FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nparZalFak)  FPOS(0,0) CLEN(0)
TYPE(TEXT) NAME(trvzavitw->nparZahFak)  FPOS(0,0) CLEN(0)
*
TYPE(MLE)  NAME(trvzavitw->mpozzbo)     FPOS(0,0) SIZE(0,0) READONLY(y)
TYPE(MLE)  NAME(trvzavitw->mapolSest)   FPOS(0,0) SIZE(0,0) READONLY(y)
*
TYPE(TEXT) NAME(trvzavitw->_nrecor)     FPOS(0,0) CLEN(0)



