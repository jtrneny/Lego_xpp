TYPE(drgForm) DTYPE(10) TITLE(Vazby mezi pøerušeními ) SIZE(60,14) FILE(C_PRERVA) ;
              GUILOOK(Action:n,IconBar:y:drgStdBrowseIconBar,Menu:n)  ;
              PRE(preValidate)   ; 
              POST(PostValidate)


  TYPE(EBrowse) SIZE(59,13) FPOS(1,0.5) FILE(C_PRERVA) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny) GUILOOK(headmove:n)

    TYPE(TEXT) NAME(c_prerva->cKodPrer)      CLEN(10) CAPTION(výchozí_pøer )   
    TYPE(GET)  NAME(c_prerva->cKodPrerE)     FLEN(10) CAPTION(cílové_pøer )      
    TYPE(COMBOBOX)  NAME(c_prerva->nDefault)  VALUES(0:(0)nepøednastven, 1:(1)pøednastven) FLEN(15) CAPTION(default)  

  TYPE(END)

*
* neviditelné pomocné položky
  TYPE(TEXT) NAME(c_prerva->cTask)         FPOS(0,0) CLEN(0)
  TYPE(TEXT) NAME(c_prerva->nKodPrer)      FPOS(0,0) CLEN(0)
  TYPE(TEXT) NAME(c_prerva->nKodPrerE)     FPOS(0,0) CLEN(0)


* PUSH(jednot_sel)
