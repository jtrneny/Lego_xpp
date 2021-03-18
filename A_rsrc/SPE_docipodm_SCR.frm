TYPE(drgForm) DTYPE(10) TITLE(Pøehled dodávek) FILE(EXPLSTHD);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y);
              CARGO( SPE_DociPodm_CRD)

*TYPE(Action) CAPTION(~Tvorba dokladù) EVENT(VYBER_POHYB) TIPTEXT(Poøizování pohybových dokladù )

* Seznam Dodávek
  TYPE(Browse) SIZE(100,10) FILE(EXPLSTHD)                      ;
                             FIELDS(ndoklad:expList            , ;
                                    ncisFirmy:odbìratel        , ; 
                                    cnazev:název odbìratele:33 , ;
                                    dExpedice:datDodání        , ;
                                    ncisFirDOP:dopravce        , ;
                                    cnazevDOP:název dopravce:33, ;
                                    cZKRATmenz:mìna              ) ;
                             CURSORMODE(3) PP(7) POPUPMENU(y) ITEMMARKED( ItemMarked)                           



* Detail dodávky
TYPE(TabPage) CAPTION(Detail dodávky) FPOS(0,14.2) SIZE( 100,10.8) OFFSET(1, 82) Resize(yx) SUBTABS(A1,A2)
  TYPE(TabPage) SIZE(57.5,8.1) FPOS(2,2) CAPTION(Odbìratel)   OFFSET( 0,78) PRE(tabSelect) SUB(A1)
    TYPE(Get)  NAME(EXPLSTHD->NCISFIRMY)         FPOS(12, .5) FLEN(10) FCAPTION(Odbìratel )         CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fin_firmy_sel)
    TYPE(Get)  NAME(EXPLSTHD->NICO)              FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
    TYPE(Get)  NAME(EXPLSTHD->CDIC)              FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
    TYPE(Get)  NAME(EXPLSTHD->CNAZEV)            FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
    TYPE(Get)  NAME(EXPLSTHD->CNAZEV2)           FPOS(12,2.5) FLEN(27)                                                
    TYPE(Get)  NAME(EXPLSTHD->CULICE)            FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
    TYPE(Get)  NAME(EXPLSTHD->CPSC)              FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
    TYPE(Get)  NAME(EXPLSTHD->CSIDLO)            FPOS(24,4.5) FLEN(27)                                                
    TYPE(Get)  NAME(EXPLSTHD->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2)
    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(24,5.5) CLEN(28) BGND(13)       
  TYPE(End)

  TYPE(TabPage) SIZE(57.5,8.1) FPOS(2,2) CAPTION(Dopravce)  OFFSET(22,56) PRE(tabSelect) SUB(A2)
    TYPE(Get)  NAME(EXPLSTHD->NCISFIRDOA)      FPOS(12, .5) FLEN(10) FCAPTION(Dopravce )          CPOS( 1, .5)  FONT(5) CLEN(11) PUSH(fin_firmy_sel)
**    TYPE(Get)  NAME(EXPLSTHD->NICO)              FPOS(28, .5) FLEN(11) FCAPTION(Ièo)                CPOS(24, .5)          CLEN( 4)
**    TYPE(Get)  NAME(EXPLSTHD->CDIC)              FPOS(45, .5) FLEN(10) FCAPTION(Diè)                CPOS(41, .5)  
    TYPE(Get)  NAME(EXPLSTHD->CNAZEVDOA)       FPOS(12,1.5) FLEN(27) FCAPTION(Název)              CPOS( 3,1.5)  
    TYPE(Get)  NAME(EXPLSTHD->CNAZEVDOA2)      FPOS(12,2.5) FLEN(27)                                                
    TYPE(Get)  NAME(EXPLSTHD->CULICEDOA)       FPOS(12,3.5) FLEN(27) FCAPTION(Ulice)              CPOS( 3,3.5)  
    TYPE(Get)  NAME(EXPLSTHD->CPSCDOA)         FPOS(12,4.5) FLEN(10) FCAPTION(PSè)                CPOS( 3,4.5)  PP(2)
**    TYPE(Get)  NAME(EXPLSTHD->CSIDLO)            FPOS(24,4.5) FLEN(27)                                                
**    TYPE(Get)  NAME(EXPLSTHD->CZKRATSTAT)        FPOS(12,5.5) FLEN(10) FCAPTION(Stát)               CPOS( 3,5.5)  PP(2)
**    TYPE(TEXT) NAME(c_staty->cnazevstat)         CPOS(24,5.5) CLEN(28) BGND(13)    
  TYPE(End)

*  TYPE(TabPage) SIZE(100,1.5) FPOS(2,2) CAPTION(Správní režie)  OFFSET(31,53) PRE(tabSelect)
*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*  TYPE(End)

*  TYPE(TabPage) SIZE(100,1.5) FPOS(2,2) CAPTION(Zásobová režie) OFFSET(46,38) PRE(tabSelect)
*  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
*  TYPE(End)
TYPE(End)

* Seznam položek dodávky
TYPE(TabPage) CAPTION( Položky dodávky) FPOS(0, 14.2) SIZE(100,10.8) Resize(yx) OFFSET(18,66)
  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)