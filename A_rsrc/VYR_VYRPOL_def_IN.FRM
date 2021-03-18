TYPE(drgForm) DTYPE(10) TITLE(Vyrábìná položka - pøednastavení - mdefinice) SIZE(154,22) FILE(vp_set);
              GUILOOK(Message:Y,Action:n,IconBar:y,Menu:y:myMenuBar);
              POST(postValidate) PRE(preValidate)



  TYPE(EBrowse) FPOS(0.5,0.5) SIZE(150,20.4) FILE(vp_set)  INDEXORD(1);
                CURSORMODE(3) PP(6)  SCROLL(ny) POPUPMENU(yy) RESIZE(yy)

    TYPE(TEXT)     NAME(vp_set->CUSER)  
    TYPE(COMBOBOX) NAME(vp_set->laktivni)   REF(LYESNO) PRE(preValidate)     
    TYPE(GET)      NAME(vp_set->CCISZAKAZ)  
    TYPE(GET)      NAME(vp_set->CCISVYK)    
    TYPE(GET)      NAME(vp_set->cNazVyk)   
    TYPE(GET)      NAME(vp_set->CVYRPOL)   
    TYPE(GET)      NAME(vp_set->CNAZEV)    
    TYPE(GET)      NAME(vp_set->NVARCIS)   
    TYPE(GET)      NAME(vp_set->CVARPOP)   
    TYPE(GET)      NAME(vp_set->CNAZPOL2)     
    TYPE(GET)      NAME(vp_set->CSKLPOL)      
    TYPE(GET)      NAME(vp_set->CCISSKLAD)    
    TYPE(GET)      NAME(vp_set->CTYPPOL)      
    TYPE(GET)      NAME(vp_set->CZKRATJEDN) FLEN(8)   
    TYPE(GET)      NAME(vp_set->CSTRVYR)      
    TYPE(GET)      NAME(vp_set->NEKDAV)       
    TYPE(COMBOBOX) NAME(vp_set->cStav)        
    TYPE(MLE)      NAME(vp_set->mPopisVP) 
  TYPE(END)              

TYPE(End)

