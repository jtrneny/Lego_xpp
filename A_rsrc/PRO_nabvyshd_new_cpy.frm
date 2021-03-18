TYPE(drgForm) DTYPE(10) TITLE( Vytvoøení kopie nabídky vystavené ...)  ;
              SIZE( 65, 8) GUILOOK(Action:n,IconBar:n,Menu:n)          ;
              FILE( NABVYSHD) POST( PostValidate)

  TYPE(Static) STYPE(12) SIZE(94.8, 7.8) FPOS( 0.1, 0.1) RESIZE(yx)

     TYPE(Text) CAPTION(Vytvoøit kopii nabídky vystavené  ...)  CPOS(  9, .5)   CLEN( 30) FONT(2)      
     TYPE(TEXT) NAME(nabVysHd->cnazOdes)                        CPOS( 39, .5)   CLEN( 20) FONT(5)      

     TYPE(Static) SIZE(50, 3.5) FPOS( 7, 1.8) RESIZE(yx)
       TYPE(TEXT) CAPTION(pro firmu ...)               CPOS( 4,  .5) CLEN(11) FONT(2)
       TYPE(TEXT) NAME(nabVysHd->ncisFirmy)            CPOS(14,  .5) CLEN( 8) FONT(5)      
       TYPE(TEXT) NAME(nabVysHd->cnazev)               CPOS(23,  .5) CLEN(35) FONT(5)      
       TYPE(TEXT) NAME(nabVysHd->cnazev2)              CPOS(23, 1.5) CLEN(35) FONT(5) 

       TYPE(TEXT) CAPTION(nabízeno dne ...)            CPOS( 4, 2.6) CLEN(15)    
       TYPE(GET)  NAME(nabVysHdw->ddatOdes)            FPOS(23, 2.6) FLEN(12) PUSH(CLICKDATE) 
     TYPE(END)  

    TYPE(PushButton) POS(40  , 6.5) SIZE(12,1.2) CAPTION(  ~Kopírovat) EVENT(140000000)  PRE(2) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(PushButton) POS(52.5, 6.5) SIZE(12,1.2) CAPTION(  ~Storno)    EVENT(140000002)         ICON1(102) ICON2(202) ATYPE(3)
  TYPE(END)