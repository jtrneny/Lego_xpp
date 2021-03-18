TYPE(drgForm) DTYPE(10) TITLE(Operace k vazbám) SIZE(100, 25) ;
               GUILOOK(Action:y,Message:y,IconBar:y:drgStdBrowseIconBar,Menu:n)

*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Kopie textù) EVENT(CopyTEXT) TIPTEXT( Kopie textù k vazbì)

* VAZBA
  TYPE(Static) STYPE(12) SIZE(99,1.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Identifikace vazby) CPOS(  2, 0.4) CLEN( 20) FONT(5)
    TYPE(Text) NAME(PracVAZ->cIdVazby)              CPOS( 24, 0.4) CLEN( 30) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(End)

* OPERACE k vazbì
  TYPE(Browse) FILE(POLOPERz) INDEXORD(7);
               FIELDS(cIdVazby    ,;
                      cCisZakaz   ,;
                      nPocCeZapZ  ,;
                      cVyrPol     ,;
                      nMnZadVK    ,;
                      nCisOper:È.oper.  ,;
                      nUkonOper  ,;
                      cOznOper   ,;
                      cOznPrac   ,;
                      cOznPracN  ,;
                      nPriprCas::12:@N999 999.9999  ,;
                      nKusovCas::12:@N999 999.9999  ,;
                      nKcNaOper:Cena operace:12:@N 999 999.999  ,;
                      mPolOper:Popis operace:25 );
              FPOS( 0, 2) SIZE(100, 15) LFREEZE(1) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yy)

  TYPE(Static) STYPE(12) SIZE(99,7.9) FPOS(0.5,17.1) RESIZE(yn) CTYPE(2) RESIZE(yy)
   TYPE(TEXT) CAPTION( Popis vazby) CPOS(.3,0.1) CLEN(98.4) FONT(5) PP(3) CTYPE(1)
   TYPE(MLE) NAME(PracVAZ->mPopVazby) FPOS(0.5, 1) SIZE(98,6.8) RESIZE(yx)

 TYPE(End)