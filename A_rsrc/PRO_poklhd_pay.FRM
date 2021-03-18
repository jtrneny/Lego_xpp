TYPE(drgForm) DTYPE(10) TITLE(Registraèní pokladna ...) SIZE(62,12.5) ;
                                                        FILE(POKLHDw) POST(postValidate) PRE(preValidate) ;
                                                        GUILOOK(Action:n,IconBar:n,Menu:n,Message:n)


 TYPE(TABPAGE) FPOS(.2,.2) SIZE(61.5,12) TTYPE(3) OFFSET(1,83) CAPTION(úhrada) TABHEIGHT(.8) PRE(tabSelect)

    TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(61,11) CTYPE(2) 
      TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(61,3.1) CTYPE(2) 
        TYPE(Text) CAPTION(úhrada dokladu) CPOS(2,  .1 ) CLEN(58) FONT(4) SIZE(58,1.0) CTYPE(3)
        TYPE(COMBOBOX) NAME(poklhdw->czkrTypUhr)         FPOS(13,1.65) FLEN(0) VALUES(a,a,a,a) ITEMSELECTED(comboItemSelected)

        TYPE(PushButton)                          CAPTION( Platba v hotovosti ) ;
                                                  POS( 12, 1.75)                ;
                                                  SIZE(36, 1.2) EVENT(set_lisHotov) ICON1(208) ICON2(108) ATYPE(3)
      TYPE(End)      

      TYPE(Text) CAPTION(k platbì)         CPOS( 4, 4  ) FONT(4) CLEN(15)                   SIZE(15,1.5) 
      TYPE(Text) NAME(poklhdw->ncenzahcel) CPOS(26, 4  ) FONT(9) CLEN(30) CTYPE(2) BGND(13) SIZE(30,1.5) 


      TYPE(Text) CAPTION(platba)           CPOS( 6, 6.2) FONT(4) CLEN(15)                   SIZE(15,1.5)
      TYPE(Get)  NAME(poklhdw->nzaplaceno) FPOS(26, 7  ) FONT(9) FLEN(30)                   SIZE(30,1.5) 
      TYPE(STATIC) STYPE(3)                FPOS(57, 6.7)                                    SIZE( 20,20 ) CAPTION(427)

     TYPE(Text) CAPTION(vrátit)            CPOS( 6, 8.7) FONT(4) CLEN(15)                   SIZE(15,1.5) 
     TYPE(Text) NAME(poklhdw->nvraceno)    CPOS(26, 9  ) FONT(9) CLEN(30) CTYPE(2) BGND(13) SIZE(30,1.5) 
   TYPE(End)   

 TYPE(End)


 TYPE(TABPAGE) FPOS(.2,.2) SIZE(61.5,12) TTYPE(3) OFFSET(15,68) CAPTION(sleva) TABHEIGHT(.8) PRE(tabSelect) 

   TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(61,11) CTYPE(2) 
     TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(61,3.1) CTYPE(2) 
       TYPE(Text) CAPTION(Sleva na celkovou èástku) CPOS(2,  .1 ) CLEN(58) FONT(4) SIZE(58,1) CTYPE(3)

       TYPE(Text) CAPTION(procento slevy)   CPOS(19, 1.7) CLEN(15) FONT(5)
       TYPE(Get)  NAME(poklhdw->nprocSLHOT) FPOS(33, 1.7) FLEN( 8) FONT(5)
       TYPE(Text) CAPTION(%)                CPOS(42, 1.7) CLEN( 3) FONT(5)
     TYPE(End)      

     TYPE(Text) CAPTION(celkem bez slev)    CPOS( 2, 4)  FONT(4) CLEN(26) SIZE(26,1)
     TYPE(Text) NAME(M->pay_celkBezSlev)    CPOS(28, 4)  FONT(9) CLEN(30) CTYPE(2) BGND(13) SIZE(30,1.5) PICTURE(999999999.9999) 

     TYPE(Text) CAPTION(èástka slevy)       CPOS( 2, 6)  FONT(4) CLEN(26) SIZE(19,1)
     TYPE(Text) NAME(M->pay_celkSleva)      CPOS(28, 6)  FONT(9) CLEN(30) CTYPE(2) BGND(13) SIZE(30,1.5) PICTURE(999999999.99) 
     TYPE(PushButton)                       CAPTION( = 0% )  ;
                                            POS( 21, 6.5)    ;
                                            SIZE(7, 1.5) EVENT(set_nNullSlHot) ATYPE(2)


     TYPE(Text) CAPTION(celkem se slevou)   CPOS( 2, 8)  FONT(4) CLEN(26) SIZE(26,1)
     TYPE(Text) NAME(M->pay_celkSeSlevou)   CPOS(28, 8)  FONT(9) CLEN(30) CTYPE(2) BGND(13) SIZE(30,1.5) PICTURE(999999999.99) 
   TYPE(End)   


*   TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
 TYPE(End)


 TYPE(TABPAGE) FPOS(.2,.2) SIZE(61.5,12) TTYPE(3) OFFSET(30,53) CAPTION(expedice) TABHEIGHT(.8) PRE(tabSelect)
   TYPE(STATIC) STYPE(12) FPOS(0,0) SIZE(61,5.5) CTYPE(2)
     TYPE(Get)  NAME(poklhdw->NCISFIRDOP)  FPOS(11, .3) FLEN(10) FCAPTION(Dopravce )    GROUPS(DOP)  CPOS( 0, .3) FONT(5) CLEN(10) PUSH(fir_firmy_sp_sel)
     TYPE(Get)  NAME(poklhdw->NICODOP)     FPOS(27, .3) FLEN(11) FCAPTION(Ièo)          GROUPS(DOP)  CPOS(23, .3)         CLEN( 4)
     TYPE(Get)  NAME(poklhdw->CDICDOP)     FPOS(44, .3) FLEN(15) FCAPTION(Diè)          GROUPS(DOP)  CPOS(40, .3)  
     TYPE(Get)  NAME(poklhdw->CNAZEVDOP)   FPOS(11,1.3) FLEN(27) FCAPTION(Název)        GROUPS(DOP)  CPOS( 3,1.3) 
     TYPE(Get)  NAME(poklhdw->CSPZ)        FPOS(44,1.3) FLEN(15) FCAPTION(Spz)          GROUPS(DOP)  CPOS(40,1.3)         CLEN( 4) PUSH(pro_stroje_sp_sel)
     TYPE(Get)  NAME(poklhdw->CNAZEVDOP2)  FPOS(11,2.3) FLEN(27)                        GROUPS(DOP)                          
     TYPE(Get)  NAME(poklhdw->CULICEDOP)   FPOS(11,3.3) FLEN(27) FCAPTION(Ulice)        GROUPS(DOP)  CPOS( 3,3.3)  
     TYPE(Get)  NAME(poklhdw->CPSCDOP)     FPOS(11,4.3) FLEN(10) FCAPTION(PSè)          GROUPS(DOP)  CPOS( 3,4.3)  PP(2)
     TYPE(Get)  NAME(poklhdw->CSIDLODOP)   FPOS(23,4.3) FLEN(27)                        GROUPS(DOP)                          
  TYPE(END)

  TYPE(STATIC) STYPE(12) FPOS(0,5.5) SIZE(61,5.5) CTYPE(2)
    TYPE(Get)  NAME(poklhdw->NCISFIRDOA)   FPOS(11, .3) FLEN(10) FCAPTION(Místo dodání) GROUPS(DOA) CPOS( 0, .3)  FONT(5) CLEN(11) PUSH(fir_firmy_sp_sel)
    TYPE(Get)  NAME(poklhdw->NICODOA)      FPOS(27, .3) FLEN(11) FCAPTION(Ièo)          GROUPS(DOA) CPOS(23, .3)          CLEN( 4)
    TYPE(Get)  NAME(poklhdw->CDICDOA)      FPOS(44, .3) FLEN(15) FCAPTION(Diè)          GROUPS(DOA) CPOS(40, .3)  
    TYPE(Get)  NAME(poklhdw->CNAZEVDOA)    FPOS(11,1.3) FLEN(27) FCAPTION(Název)        GROUPS(DOA) CPOS( 3,1.3)  
    TYPE(Get)  NAME(poklhdw->CNAZEVDOA2)   FPOS(11,2.3) FLEN(27)                        GROUPS(DOA)                        
    TYPE(Get)  NAME(poklhdw->CULICEDOA)    FPOS(11,3.3) FLEN(27) FCAPTION(Ulice)        GROUPS(DOA) CPOS( 3,3.3)  
    TYPE(Get)  NAME(poklhdw->CPSCDOA)      FPOS(11,4.3) FLEN(10) FCAPTION(PSè)          GROUPS(DOA) CPOS( 3,4.3)  PP(2)
    TYPE(Get)  NAME(poklhdw->CSIDLODOA)    FPOS(23,4.3) FLEN(27)                        GROUPS(DOA)  
   TYPE(END)                                              
 TYPE(End)


