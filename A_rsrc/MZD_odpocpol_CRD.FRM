TYPE(drgForm) DTYPE(10) TITLE(Nastavení odpoèitatelných položek) SIZE(100,21) FILE(C_ODPOCw) ;
              GUILOOK(Message:Y,Action:n,IconBar:y:MyIconBar,Menu:n)                         ; 
              BORDER(2) POST(postValidate)

  TYPE(TEXT) CAPTION(K nastavení ) FONT(5)    CPOS( 2, 0.10)   CLEN(15)
  TYPE(TEXT) CAPTION(Nastavené )   FONT(5)    CPOS(59, 0.10)   CLEN(15)

  TYPE(DBrowse) FPOS( 0.5,1.5) SIZE(38,16) FILE(C_ODPOCw)  ;
                FIELDS( M->is_C_odpocet:o:2.6::2,    ; 
                        M->is_C_danUleva:u:2.6::2,   ;
                        cTypOdpPol:typPol:9,         ;
                        RetCOLcisOBD():odp_úlOBD:10, ;
                        RetCOLcisROK():odp_úlROK:10  )     ;
                CURSORMODE(3) PP(1) SCROLL(ny)


  TYPE(DBrowse) FPOS(53,1.5) SIZE(46,9) FILE(MSODPPOLw) ; 
                FIELDS( M->is_M_odpocet:o:2.6::2,    ; 
                        M->is_M_danUleva:u:2.6::2,   ;
                        M->is_M_aktiv::2.6::2,       ;
                        nPorOdpPol:poø:4,            ;
                        cTypOdpPol:typPol:10.5,      ;
                        RetCOLmsOBD():odp_úlOBD:10,  ;
                        RetCOLmsROK():odp_úlROK:10   )   ;               
                CURSORMODE(3) PP(1) SCROLL(ny)


**  TYPE(PushButton) POS(97,0) SIZE(3,1) ATYPE(1) ICON1(102) ICON2(202) EVENT(140000002) TIPTEXT(Ukonèi dialog)

*  TYPE(PUSHBUTTON) CAPTION(  ~Pøevzít položky do dokladu)                   ;
*                   POS(75,.1) SIZE(25,1.1) ATYPE(3) ICON1(429) ICON2(430)   ;
*                   EVENT(save_marked) TIPTEXT( Pøevzít položky do dokladu ...(CTRL_W))

  TYPE(PushButton) POS(41,7) SIZE(10,1) CAPTION(>>) EVENT(LeftACTION)
  TYPE(PushButton) POS(41,12) SIZE(10,1) CAPTION(<<) EVENT(RightACTION)

  TYPE(TEXT) FCAPTION(Název)                                CPOS( 1,17.65) CLEN(8)
   TYPE(TEXT) NAME(C_ODPOCw->cNazOdpPol)                     CPOS( 9,17.65) CLEN(29) BGND(13) PP(3)
  TYPE(TEXT) FCAPTION(Rod.è.)                               CPOS( 1,18.75) CLEN(8)
   TYPE(TEXT) NAME(C_ODPOCw->cRodCisRP)                      CPOS( 9,18.75) CLEN(29) BGND(13) PP(3)


  TYPE(Static) STYPE(13) FPOS(54,10.3) SIZE(45,10.4) RESIZE(y)

     TYPE(GET) NAME(MSODPPOLw->cTypOdpPol)                   FPOS(0.5,0.15) FLEN(8) PUSH(mzd_c_odpoc_sel)
     TYPE(GET) NAME(MSODPPOLw->cNazOdpPol)                   FPOS(10,0.15) FLEN(33) BGND(13) PP(3) FONT(5)
     TYPE(TEXT) FCAPTION(Rodn.è.RP)                          CPOS(0.5,1.35) CLEN(9)
     TYPE(TEXT) NAME(MSODPPOLw->cRodCisRP)                   CPOS(10,1.25) CLEN(34) BGND(13) PP(3)
     TYPE(TEXT) FCAPTION(Jméno)                              CPOS(0.5,2.55) CLEN(9)
     TYPE(TEXT) NAME(MSODPPOLw->cJmenoRoRP)                  CPOS(10,2.45) CLEN(34) BGND(13) PP(3)
     TYPE(TEXT) FCAPTION(Zdr.stav)                           CPOS(0.5,3.75) CLEN(9)
     TYPE(TEXT) NAME(MSODPPOLw->cZkrZdrSta)                  CPOS(10,3.65) CLEN( 8) BGND(13) PP(3)
     TYPE(TEXT) NAME(C_ZDRSTA->cNazZdrSta)                   CPOS(20,3.65) CLEN(23) BGND(13) PP(3)
     TYPE(TEXT) FCAPTION(Škola)                              CPOS(0.5,4.95) CLEN(9)
     TYPE(GET) NAME(MSODPPOLw->nCisFirmy)                   FPOS(10,4.85) FLEN(8) PUSH(fir_firmy_sel)
     TYPE(GET) NAME(MSODPPOLw->cNazev)                      FPOS(20,4.85) FLEN(23) BGND(13) PP(3)

    TYPE(TEXT) FCAPTION(Platnost_DAT)                       CPOS(0.5, 6.95) CLEN(10.5)
    TYPE(TEXT) FCAPTION(od)                                 CPOS(11, 6.95) CLEN(3)
    TYPE(TEXT) FCAPTION(do)                                 CPOS(28, 6.95) CLEN(3)
     TYPE(GET) NAME(MSODPPOLw->dPlatnOD)                     FPOS(15.5, 6.85) FLEN(11.7) FONT(5) PUSH(CLICKDATE)
     TYPE(GET) NAME(MSODPPOLw->dPlatnDO)                     FPOS(32.0, 6.85) FLEN(11.7) FONT(5) PUSH(CLICKDATE)

    TYPE(TEXT) FCAPTION(Platnost_OBD)                       CPOS(0.5, 8.05) CLEN(10.5)
    TYPE(TEXT) FCAPTION(od)                                 CPOS(11, 8.05) CLEN(3)
    TYPE(TEXT) FCAPTION(do)                                 CPOS(28, 8.05) CLEN(3)
     TYPE(GET) NAME(MSODPPOLw->cObdOD)                       FPOS(15.5, 7.80) FLEN(11.7) PICTURE (XX/XX)
     TYPE(GET) NAME(MSODPPOLw->cObdDO)                       FPOS(32.0, 7.80) FLEN(11.7) PICTURE (XX/XX)

    TYPE(TEXT) FCAPTION(Hodnota za)                         CPOS(0.5, 9.10) CLEN(9.6)
    TYPE(TEXT) FCAPTION(obd)                                CPOS(11, 9.10) CLEN(3.9)
    TYPE(TEXT) FCAPTION(rok)                                CPOS(28, 9.10) CLEN(3.9)
     TYPE(TEXT) NAME(M->sum_odpocOBD)                       CPOS(15.5, 9.00) CLEN(12) FONT(5) BGND(13) CTYPE(2)
     TYPE(TEXT) NAME(M->sum_odpocROK)                       CPOS(32.5, 9.00) CLEN(12) FONT(5) BGND(13) CTYPE(2)
  TYPE(End)


