TYPE(drgForm) DTYPE(2) TITLE(Èíselník typù úhrady ...) SIZE(90,15) FILE(C_TYPUHR) ;
                                                                   CBLOAD(ONLOAD) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(90,14) FILE(C_TYPUHR) FIELDS(M->is_Eet:eet:2.6::2          , ;  
                                                  CZKRTYPUHR                    , ;
                                                  CPOPISUHR::33                 , ;
                                                  NKODZAOKR                     , ;
                                                  M->is_hotov:cash:2.6::2       , ;
                                                  M->is_inkaso:inkaso:2.6::2    , ;
                                                  M->is_regPok:regPok:2.6::2    , ;
                                                  M->is_regDef:regPok_def:2.6::2, ;
                                                  M->is_itZaokr:genZaokr:2.6::2   ) ;
                                           CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(CZKRTYPUHR) FPOS(15,1) FLEN( 7)  FCAPTION(Typ úhrady)   CPOS(1,1) POST(drgPostUniqueKey)
  TYPE(GET)      NAME(CPOPISUHR)  FPOS(15,2) FLEN(50)  FCAPTION(Popis úhrady) CPOS(1,2)
  TYPE(GET)      NAME(NKODZAOKR)  FPOS(15,3) FLEN( 7)  FCAPTION(Zaokrouhlit)  CPOS(1,3)

  TYPE(CHECKBOX) NAME(LISHOTOV)   FPOS(15,4) FLEN( 7)  FCAPTION(Platba v hotovosti)   CPOS(1,4) VALUES(F:NE,T:ANO) CLEN(14)
  TYPE(CHECKBOX) NAME(LISINKASO)  FPOS(15,5) FLEN(13)  FCAPTION(Typ inkaso)           CPOS(1,5) VALUES(F:NE,T:ANO)
*
  TYPE(STATIC) FPOS(.2,6.3) SIZE(89,.3) STYPE(12) CTYPE(2) RESIZE(yx)
  TYPE(End)

  TYPE(CHECKBOX) NAME(LISREGPOK)   FPOS(15,7) FLEN( 3)  FCAPTION(Pro regPokladnu)           CPOS( 1,7) VALUES(F: ,T: ) ItemSelected(CheckItemSelected)
  TYPE(CHECKBOX) NAME(LISREGDEF)   FPOS(28,7) FLEN( 3)  FCAPTION(pøedastavit)               CPOS(18,7) VALUES(F: ,T: )
  TYPE(COMBOBOX) NAME(npokladEET)  FPOS(36,7) FLEN(24)  FCAPTION()                          CPOS(35,7) VALUES(0:doklad se neodesílá na EET, 1:doklad se odesílá na EET)
  TYPE(COMBOBOX) NAME(nisITzaokr)  FPOS(63,7) FLEN(25)  FCAPTION()                          CPOS(75,7) VALUES(0:negeneruj zaokrouhlení fakVys, 1:generuj zaokrouhlení faVys)

*
  TYPE(STATIC) FPOS(.2,8.3) SIZE(89,.3) STYPE(12) CTYPE(2) RESIZE(yx)
  TYPE(End)
*

  TYPE(TEXT)     NAME(pokladms->cnazPoklad) CPOS(25, 9) CLEN(25)    
  TYPE(GET)      NAME(NPOKLADNA)            FPOS(15, 9) FLEN( 7) FCAPTION(Èíslo pokladny)  CPOS(1,9)
  TYPE(TEXT)     CAPTION(Typ pohybu)        CPOS( 1,10) CLEN(10)
  TYPE(ComboBox) NAME(cTYPPOHYBU)           FPOS(15,10) FLEN(28) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected) PP(2)

*
* neviditelné pomocné položky
  TYPE(GET) NAME(c_typuhr->ctypDoklad)   FPOS(0,0) FLEN(0) 
*  TYPE(GET) NAME(c_typUhr->npokladEET)   FPOS(0,0) FLEN(0)
TYPE(End)




