TYPE(drgForm) DTYPE(10) TITLE(Trvalý závazek) SIZE(110,27) FILE(TRVZAVHDW)   ;
                                                           POST(postValidate);
                                                           CBSAVE(onSave)    ;
                                                           GUILOOK(IconBar:Y:MyIconBar,Menu:y:myMenuBar)



TYPE(Static) STYPE(14) SIZE(108,6.2) FPOS(1,0.3) RESIZE(y)
    TYPE(GET) NAME(DPORIZFAK)       FPOS(11,0.5) FLEN(11) FCAPTION(Datum ...   )  CPOS( 2,0.5) PP(2) PUSH(CLICKDATE)
    TYPE(COMBOBOX) NAME(COBDOBI)    FPOS(31,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_úè)  CLEN(7) CPOS(24,0.5) PP(2)
    TYPE(COMBOBOX) NAME(COBDOBIDAN) FPOS(50,0.5) FLEN(10) VALUES(a,a,a,a) FCAPTION(OBD_daò) CLEN(8) CPOS(42,0.5) PP(2)
    TYPE(ComboBox) NAME(cTYPPOHYBU) FPOS(66,0.5) FLEN(38) VALUES(a,a,a,a)             ;
                                                          ITEMMARKED(comboItemMarked) ;
                                                          ITEMSELECTED(comboItemSelected) PP(2) NOREVISION() 

    TYPE(STATIC) STYPE(2) FPOS(1,2) SIZE(106,9)
      TYPE(TEXT) CAPTION(Daòový doklad faktura) CPOS( 1,-.25) CLEN(17)
      TYPE(TEXT) CAPTION(DODAVATEL)             CPOS(54,-.25) CLEN(10)

      TYPE(GET) NAME(NCISFAK)    FPOS(18,1) FLEN(10) FCAPTION(Faktura èíslo ...     )  CPOS( 1,1)             PP(2) NOREVISION()
      TYPE(CHECKBOX) NAME(lno_indph) FPOS(30,1) FLEN(16) VALUES(T:vstupuje do DPH,F:vstupuje do DPH)

      TYPE(GET)  NAME(CVARSYM)    FPOS(18,2) FLEN(10) FCAPTION(Variabilní symbol ... )  CPOS( 1,2)             PP(2)
      TYPE(GET)  NAME(NKONSTSYMB) FPOS(18,3) FLEN(10) FCAPTION(Konstantní symbol ... )  CPOS( 1,3)             PP(2)
      TYPE(TEXT) NAME(C_KONSYM->CPOPISKS) CPOS(30,3) CLEN(18) BGND(13)
*
      TYPE(STATIC) STYPE(2) FPOS(52,0) SIZE(54,9)
        TYPE(GET) NAME(CUCET)      FPOS(13,1) FLEN(25) FCAPTION(Úèet ...  )              CPOS(2,1)             PP(2) PUSH(FIR_FIRMYUC_SEL)
         TYPE(TEXT)     CAPTION([)      CPOS(40,1) CLEN( 2)
         TYPE(TEXT)     NAME(NCISFIRMY) CPOS(41,1) CLEN( 6) CTYPE(2) PICTURE(@N 99999)
         TYPE(TEXT)     CAPTION(])      CPOS(47,1) CLEN( 2)
        
        TYPE(GET) NAME(NICO)       FPOS(13,2) FLEN( 8) FCAPTION(IÈO/DIèo ...  )          CPOS(2,2)    CTYPE(2)
        TYPE(GET) NAME(CDIC)       FPOS(23,2) FLEN(15)

        TYPE(GET) NAME(CNAZEV)     FPOS(13,3) FLEN(25) FCAPTION(Název ...  )             CPOS(2,3)
*----        TYPE(GET) NAME(CNAZEV2)    FPOS(13,4) FLEN(25)
*----        TYPE(GET) NAME(CULICE)     FPOS(13,5) FLEN(25) FCAPTION(Ulice ...  )             CPOS(2,5)
*----        TYPE(GET) NAME(CPSC)       FPOS(13,6) FLEN( 8) FCAPTION(Místo ...  )             CPOS(2,6)
*----        TYPE(GET) NAME(CSIDLO)     FPOS(23,6) FLEN(24)
*----        TYPE(GET) NAME(CZKRATSTAT) FPOS(13,7) FLEN( 8) FCAPTION(Stát ...  )              CPOS(2,7)             PP(2)
*----         TYPE(TEXT) NAME(C_STATY->CNAZEVSTAT) CPOS(23,7) CLEN(25) BGND(13)
*----        TYPE(GET) NAME(CUCET_UCT)  FPOS(13,8) FLEN( 8) FCAPTION(SuAu_Ø ...  )            CPOS(2,8)             PP(2)
*----         TYPE(TEXT) NAME(C_UCTOSN->CNAZ_UCT) CPOS(23,8) CLEN(25) BGND(13)
      TYPE(END)   
    TYPE(END)
  TYPE(END) 


TYPE(END)