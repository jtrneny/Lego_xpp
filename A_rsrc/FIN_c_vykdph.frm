TYPE(drgForm) SIZE(88,25) DTYPE(10) TITLE(Výkaz DPH nastavení ...) FILE(C_VYKDPH) POST(postValidate) GUILOOK(Action:n) 
             
*
** BROWSE definition        
  TYPE(DBrowse) FPOS(-.7,1.3) SIZE(88,16.3) FILE(C_VYKDPH)                              ;
                                          FIELDS(FIN_c_vykdph_BC(0)::2.7::2           , ;
                                                 FIN_c_vykdph_BC(1)::5                , ;  
                                                 cRADEK_DPH:Název øádku výkazu DPH:50 , ;
                                                 coddilKohl:oddil_                    , ; 
                                                 cUCETU_DPH:SuAu_:8                      ) ;
                                          CURSORMODE(3) PP(7) SCROLL(ny)

*
** INPUT definition
  TYPE(Static) STYPE(13) SIZE(87, 6.5) FPOS(0.5,18) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(Øádek DPH) CPOS( 1, .8) CLEN(12) FONT(5)
    TYPE(GET)  NAME(nRADEK_DPH)   FPOS(11, .8) FLEN( 9) 
    TYPE(GET)  NAME(cRADEK_DPH)   FPOS(22, .8) FLEN(39) 

    TYPE(TEXT)     CAPTION(oddíl_KOH) CPOS(63, .8) CLEN( 8)
    TYPE(COMBOBOX) NAME(coddilKohl)   FPOS(72, .8) FLEN(14) VALUES(a,a,a,a,a,a,a,a,a,a,a) FONT(5)    

    TYPE(TEXT) CAPTION(SuAu_)            CPOS( 1,2) CLEN(10) FONT(5)    
    TYPE(GET)  NAME(cUCETU_DPH)          FPOS(11,2) FLEN( 9) 
    TYPE(TEXT) NAME(C_UCTOSN->cNAZ_UCT)  CPOS(22,2) CLEN(40) BGND(13) PP(1)                   
    TYPE(CHECKBOX) NAME(lSETS__DPH)      FPOS(55,2) FLEN(10) VALUES(T:na Vstupu,F:na Vstupu)
    TYPE(TEXT) CAPTION(Náplò ø.)         CPOS( 1,2) CLEN(10)     
    TYPE(MLE)  NAME(mNaplnDPH)           FPOS(11,3) SIZE(75,3) RESIZE(yx)
  TYPE(End)


  TYPE(Static) STYPE(12) SIZE(21.1,1.2) FPOS(64.05, .05) RESIZE(nn) CTYPE(1)
    TYPE(ComboBox) NAME(M->selRok) FPOS(0.5,.1) FLEN(20)                 ;
                                               VALUES(a,a,a,a,a,a,a)    , ; 
                                               TEMSELECTED(comboItemSelected)
  TYPE(End) 




