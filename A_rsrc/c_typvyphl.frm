TYPE(drgForm) DTYPE(10) TITLE(Nastavení vzorce pro výpoèet hlasù ...) SIZE(70,14) FILE(C_TYPVYPHL);
              GUILOOK(Action:n,IconBar:y:drgStdBrowseIconBar,Menu:n)  ;
              PRE(preValidate)   ; 
              POST(PostValidate)


  TYPE(EBrowse) SIZE(69,12) FPOS(1,0.5) FILE(C_TYPVYPHL) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) ;
                                                         GUILOOK(ins:nn,del:n,sizecols:n,headmove:n) 

    TYPE(CHECKBOX) NAME(c_typvyphl->laktivni)      CLEN( 3)  CAPTION(akt)              REF(LYESNO)
    TYPE(TEXT)     NAME(c_typvyphl->ntypVYPhla)    CLEN( 5)  CAPTION(typVýp)   
    TYPE(TEXT)     NAME(c_typvyphl->cpopVYPhla)    CLEN(45)  CAPTION(popis výpoètu poètu hlasù)      
    TYPE(GET)      NAME(c_typvyphl->ndelitel)      FLEN( 9)  FCAPTION(dìlitel)
  TYPE(END)

  TYPE(PushButton) CAPTION(    pøepoèet ~Hlasù)   POS(45, 12.7) SIZE(20,1.1) EVENT(set_datkomE) ICON1(142) ATYPE(3)  



