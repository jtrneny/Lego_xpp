TYPE(drgForm) DTYPE(10) TITLE(Plánování vazeb pracoviš na den) SIZE(120,26) FILE(PRACVAZ);
              GUILOOK(Action:y,IconBar:y:drgStdBrowseIconBar,Menu:n);
              POST( PostValidate)

TYPE(Action) EVENT(SEPARATOR)
TYPE(Action) CAPTION(~Vykázat/Zrušit)  EVENT(VAZBA_VYK)        TIPTEXT(Vykázat aktuální vazbu)
TYPE(Action) CAPTION(V~azba VSCHM)     EVENT(VAZBA_VSCHM)      TIPTEXT(Oznaèení vazby s chybným materiálem)
TYPE(Action) CAPTION(~Aktualizace dat) EVENT(act_AktualDAT)    TIPTEXT(Aktualizace vazebního souboru pracoviš)
TYPE(Action) CAPTION(~Operace vazby)   EVENT(act_OperaceVAZ)   TIPTEXT(Seznam operací k vazbám)
TYPE(Action) CAPTION(~Pøedch. vazby)   EVENT(act_PredchVAZ)    TIPTEXT(Pøehled pøedchozích vazeb k pracovšti)
TYPE(Action) CAPTION(Pø~eplánování)    EVENT(act_PreplanVAZ)   TIPTEXT(Pøeplánování nevykázaných vazeb na aktuální den)

  TYPE(Static) STYPE(13) SIZE( 119,1.2) FPOS( 0.5, 0.1)  RESIZE(yn)
    TYPE(Static) STYPE(1) SIZE( 38,1.2) FPOS( 80, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) FPOS( 0, 0) FLEN(38) NAME(M->nVazby_Show) VALUES(1:Nevykázané vazby s hotovými pøedch.vazbami,;
                                                                         2:Nevykázané vazby s nehotovými pøedch.vazbami ,;
                                                                         3:Všechny vazby - vykázané i nevykázané  );
                                            COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)
    TYPE(End)
    TYPE(Text) CAPTION(Seznam vazeb pro pracovištì :) CPOS( 1, 0.1) CLEN( 27) FONT(2)
    TYPE(GET)  NAME(M->cOznPrac_sel)       FPOS( 28, 0.1) FLEN( 13) FONT(5) PP(2)PUSH( vyr_PRACOV_sel)
    TYPE(TEXT) NAME(C_PRACOV->cNazevPrac)  CPOS( 43, 0.1) CLEN( 30) FONT(5) PP(2) BGND(13)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 119,10.5) FPOS(0.5, 1.4) RESIZE(yn)
    TYPE(dBrowse) FILE(PRACVAZwp) INDEXORD(1) ;
                 FIELDS( cIdVazby    ,;
                         cCisZakaz   ,;
                         nPocCeZapZ:Zap.::99  ,;
                         nRokVytvor:Rok ML::9999  ,;
                         nPorCisLis:Èíslo ML::999999999999  ,;
                         nSumNhPlan  ,;
                         SumNhPrepocet(1):NH-plán pøepoèet::@999 999 999.9999,;
                         nKcNaOper   ,;
                         cOznPrac    ,;
                         cOznPracN   ,;
                         dDatPlan    ,;
                         VazbaVykazana(1):Vyk.:1::2 ,;
                         VazbaVykZPlan(1):Vyk.PL:1::2 ,;
                         dDatVykaz     ,;
                         VazbaVSCHM(1):Vschm:1::2 ,;
                         dDatVSCHM     );
                 FPOS( 0.2, 0.1) SIZE(118, 10.3 ) RESIZE(yx) CURSORMODE(3) SCROLL(ny) PP(7)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 119,1.2) FPOS( 0.5, 12)  RESIZE(yn)
    TYPE(Text) CAPTION( Vazby plánované na den) CPOS( 1, 0.1) CLEN( 25) FONT(2)
    TYPE(GET)  NAME(M->dDatPlan_sel)            FPOS( 28, 0.1) FLEN( 15) FONT(5) PP(2) PUSH( clickDate)
*    TYPE(TEXT) NAME(M->nCountVAZ)               CPOS( 65, 0.1) CLEN( 10)
    TYPE(Static) STYPE(11) SIZE( 17, 1) FPOS( 90, 0.1)  RESIZE(ny)
      TYPE(PUSHBUTTON) POS( 0, 0) SIZE(17, 1)  CAPTION(Zaplánovat vazby) EVENT(vazby_plan)
    TYPE(End)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE( 119,12.5) FPOS(0.5, 13.3) RESIZE(yy)
    TYPE(dBrowse) FILE(PRACVAZwd) INDEXORD(1) ;
                 FIELDS( cIdVazby     ,;
                         cCisZakaz    ,;
                         nPocCeZapZ:Zap.::99    ,;
                         nRokVytvor:Rok ML::9999  ,;
                         nPorCisLis:Èíslo ML::999999999999   ,;
                         nSumNhPlan   ,;
                         SumNhPrepocet(2):NH-plán pøepoèet::@999 999 999.9999,;
                         nKcNaOper    ,;
                         cOznPrac     ,;
                         cOznPracN    ,;
                         dDatPlan     ,;
                         nPoradi:Poø. ,;
                         VazbaVykazana(2):Vyk.:1::2 ,;
                         VazbaVykZPlan(2):Vyk.PL:1::2 ,;
                         dDatVykaz    ,;
                         VazbaVSCHM(2):Vschm:1::2 ,;
                         dDatVSCHM    );
                 FPOS( 0.2, 0.1) SIZE(118, 10.6 ) RESIZE(yy) CURSORMODE(3) SCROLL(ny) PP(7) FOOTER(y)

    TYPE(Static) STYPE(1) SIZE( 24, 1) FPOS( 90, 11.2)  RESIZE(ny)
      TYPE(PUSHBUTTON) POS( 0, 0) SIZE( 5, 1.0)  CAPTION( ^^) EVENT(Move_TOP )
      TYPE(PUSHBUTTON) POS( 6, 0) SIZE( 5, 1.0)  CAPTION( ^ ) EVENT(Move_UP  )
      TYPE(PUSHBUTTON) POS(12, 0) SIZE( 5, 1.0)  CAPTION( v ) EVENT(Move_DOWN)
      TYPE(PUSHBUTTON) POS(18, 0) SIZE( 5, 1.0)  CAPTION( vv) EVENT(Move_BOT )

*      TYPE(PUSHBUTTON) POS( 90, 11.2) SIZE( 5, 1.0)  CAPTION( ^^) EVENT(Move_TOP )
*      TYPE(PUSHBUTTON) POS( 96, 11.2) SIZE( 5, 1.0)  CAPTION( ^ ) EVENT(Move_UP  )
*      TYPE(PUSHBUTTON) POS(102, 11.2) SIZE( 5, 1.0)  CAPTION( v ) EVENT(Move_DOWN)
*      TYPE(PUSHBUTTON) POS(108, 11.2) SIZE( 5, 1.0)  CAPTION( vv) EVENT(Move_BOT )
    TYPE(End)
  TYPE(End)