TYPE(drgForm) DTYPE(2) TITLE(Èíselník pracovních vztahù) SIZE(70,15) FILE(C_PRACVZ);
              GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(C_PRACVZ)                                    ;
                            FIELDS(nTypPraVzt                               , ;
                                   cNazPraVzt::33                           , ;
                                   cTypPPVReg:druhPPv                       , ;
                                   PER_c_pracvz_BC('lMimoPrVzt'):mpv:2.7::2 , ;
                                   PER_c_pracvz_BC('lSocPojis'):soc:2.7::2  , ;   
                                   PER_c_pracvz_BC('lZdrPojis'):zdr:2.7::2  , ;
                                   PER_c_pracvz_BC('lOdstupne'):ods:2.7::2  , ;
                                   PER_c_pracvz_BC('lDovolena'):dov:2.7::2    ) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y)
TYPE(End)

*                                   PER_c_pracvz_BC('lDovolena'):dov:2.7::2    ) ;
*                                    PER_c_pracvz_BC('lOdstupne'):ods:2.7::2  , ;  

TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) PRE( tabSelect)
  TYPE(GET)      NAME(nTypPraVzt) FPOS(20,1) FLEN(2)  FCAPTION(Typ)                     CPOS(1,1)              POST( drgPostUniqueKey)
  TYPE(GET)      NAME(cNazPraVzt) FPOS(20,2) FLEN(35) FCAPTION(Název pracovního vztahu) CPOS(1,2)
  TYPE(GET)      NAME(cTypPPVReg) FPOS(20,3) FLEN( 5) FCAPTION(Typ PPV pro ÈSSZ)        CPOS(1,3) 
    TYPE(TEXT) NAME(c_prvzDC->cnazDRUcin) CPOS( 27,3)  
  
  TYPE(COMBOBOX) NAME(lMimoPrVzt) FPOS(20,4) FLEN( 8) FCAPTION(Mimo pracovní vztah)     CPOS(1,4) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lSocPojis)  FPOS(20,5) FLEN( 8) FCAPTION(Sociální pojištìní)      CPOS(1,5) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lZdrPojis)  FPOS(20,6) FLEN( 8) FCAPTION(Zdravotní pojištìní)     CPOS(1,6) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lOdstupne)  FPOS(20,7) FLEN( 8) FCAPTION(Nárok na odstupné)       CPOS(1,7) REF( LYESNO) 
  TYPE(COMBOBOX) NAME(lDovolena)  FPOS(20,8) FLEN( 8) FCAPTION(Nárok na dovolenou)      CPOS(1,8) REF( LYESNO) POST( postLastField_2)

TYPE(End)
