TYPE(drgForm) DTYPE(10) TITLE(P¯edchozÌ vazby pracoviöùÏ) SIZE(120,25) FILE(PRACVAZ);
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n);
              POST( PostValidate)

TYPE(Action) CAPTION(~Vyk·zat/Zruöit)   EVENT(VAZBA_VYK)        TIPTEXT(Vyk·zat aktu·lnÌ vazbu)

  TYPE(Static) STYPE(13) SIZE( 119,1.2) FPOS( 0.5, 0.1)  RESIZE(yn)
    TYPE(Text) CAPTION(P¯edchozÌ vazby pracoviötÏ :) CPOS(  1, 0.1) CLEN( 27) FONT(2)
    TYPE(TEXT) NAME(M->cOznPrac_sel)                 CPOS( 28, 0.1) CLEN( 13) FONT(5) BGND(13) GROUPS(clrBLUE)
    TYPE(TEXT) NAME(C_PRACOV->cNazevPrac)            CPOS( 43, 0.1) CLEN( 35) FONT(5) BGND(13) GROUPS(clrBLUE)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 119,23.5) FPOS(0.5, 1.4) RESIZE(yy)
    TYPE(dBrowse) FILE(PRACVAZ) INDEXORD(1) ;
                  FIELDS( cIdVazby    ,;
                          cCisZakaz   ,;
                          nPocCeZapZ:Zap.::99  ,;
                          nRokVytvor:Rok ML::9999  ,;
                          nPorCisLis:»Ìslo ML::999999999999  ,;
                          nSumNhPlan  ,;
                          nKcNaOper   ,;
                          cOznPrac    ,;
                          cOznPracN   ,;
                          dDatPlan    ,;
                          VazbaVykazana(3):Vyk.:1::2 ,;
                          VazbaVykZPlan(3):Vyk.PL:1::2 ,;
                          dDatVykaz  );
                  FPOS( 0.2, 0.1) SIZE(118, 23.3 ) RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7)
  TYPE(End)