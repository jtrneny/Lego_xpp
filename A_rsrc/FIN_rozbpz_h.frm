TYPE(drgForm) DTYPE(10) TITLE(Rozbory pohledávek/závazkù ...) SIZE(115,23)       ;
                                                              POST(postValidate) 


  TYPE(DBrowse) FPOS(  .5,1.4) FILE(ROZBPZ_H)                       ;
                               FIELDS(FIN_rozbpz_BC(11):akt:2.7::2, ;
                                      cnaz_Roz:název rozboru:52   ) ;  
                               SIZE(58,16.2) CURSORMODE(3) PP(7) ITEMMARKED(itemMarked) INDEXORD(1) POPUPMENU(y) RESIZE(yy)
         

  TYPE(STATIC) FPOS(59,.1) SIZE(55,17.5) STYPE(12) RESIZE(ny)  
    TYPE(DBrowse) FPOS(0,0) FILE(ROZBPZ_I)                         ;
                            FIELDS(FIN_rozbpz_BC(21):akt:2.7::2  , ;
                                   FIN_rozbpz_BC(22):splatnost:20, ;
                                   crel_1::5                     , ;
                                   FIN_rozbpz_BC(24)::5          , ;
                                   FIN_rozbpz_BC(25)::5          , ;
                                   crel_2::3                     , ;
                                   FIN_rozbpz_BC(27)::5          , ;
                                   FIN_rozbpz_BC(28)::5          ) ;
                            SIZE(55,17.4) CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(ny)
  TYPE(End)

*  IN **
 TYPE(Static) FPOS(.8,18.2) SIZE(113,4.5) STYPE(13) CTYPE(2) RESIZE(yx)
   TYPE(GET)      NAME(rozbpz_h->cnaz_Roz) FPOS(16, .5) FLEN(50) FCAPTION(Název rozboru) CPOS( 3, .5) PP(2)
   TYPE(CHECKBOX) NAME(rozbpz_h->lset_Roz) FPOS(78, .5) FLEN( 8) FCAPTION(Aktivní )      CPOS(70, .5) VALUES(T:   ,F:   )

   TYPE(STATIC) FPOS(2,1.7) SIZE(109.4,1.7) STYPE(2) CAPTION(Položka rozboru) RESIZE(yx)
    TYPE(TEXT)     CAPTION(splatnost ->)    CPOS(13, .6) SIZE(14,1.4) CLEN(14) PP(2) FONT(3)
    TYPE(COMBOBOX) NAME(rozbpz_i->crel_1)   FPOS(27, .8) FLEN(10) VALUES(od:Od,do:Do,nad:Nad) ITEMSELECTED(comboItemSelected)
    TYPE(GET)      NAME(rozbpz_i->nval_1)   FPOS(39, .8) FLEN( 5)
    TYPE(TEXT)     CAPTION(dne(ù))          CPOS(45, .8) CLEN( 6) 
    TYPE(TEXT)     NAME(rozbpz_i->crel_2)   CPOS(51, .7) CLEN( 5) FONT(7)
    TYPE(GET)      NAME(rozbpz_i->nval_2)   FPOS(57, .8) FLEN( 5)  
    TYPE(TEXT)     CAPTION(dnù)             CPOS(63, .8) CLEN( 5) GROUPS(DNU)
    TYPE(CHECKBOX) NAME(rozbpz_i->lset_Roz) FPOS(76, .8) FLEN( 8) FCAPTION(Aktivní )      CPOS(68, .8) VALUES(T:    ,F:    )

   TYPE(End)
 TYPE(End)

* generování podkladú pro datum, období
 TYPE(STATIC) FPOS(.5,0) SIZE(58,1.4) STYPE(14) CTYPE(2) RESIZE(yn)
   TYPE(Text)     CAPTION(generuj podklady k datu) CPOS(  .5,.1) CLEN(18)
   TYPE(CHECKBOX) NAME(M->k_datRozb)               FPOS(18.4,.1) FLEN( 3.5) VALUES(T:   ,F:   )
   TYPE(Get)      NAME(M->datRozb)                 FPOS(21.8,.1) FLEN(11) PUSH(CLICKDATE)

   TYPE(TEXT)     CAPTION(k období)                CPOS(34.5,.1) CLEN( 7)
   TYPE(CHECKBOX) NAME(M->k_obdRozb)               FPOS(41.6,.1) FLEN( 3.5) VALUES(T:   ,F:   )
   TYPE(COMBOBOX) NAME(M->obdRozb)                 FPOS(45  ,.2) FLEN(12) VALUES(a,a,a,a)
 TYPE(End)




