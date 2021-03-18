TYPE(drgForm) DTYPE(10) TITLE(Pøehled expedice za kalenáøní týdny ...) FILE(KALENDAR) ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

  TYPE(Action) CAPTION(~Zakázka)          EVENT(NIC) TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Expedièní listy)  EVENT(NIC) TIPTEXT(Expedièní listy)


* kalendáø dle týdnù
  TYPE(DBrowse) FPOS(0,0) FILE(KALENDAR)                   ;
                          FIELDS( NROK:rok               , ;
                                  NMESIC:mìsíc           , ;
                                  CNAZMES:názMìsíce      , ; 
                                  NTYDEN:týden           , ;
                                  M->mnozPlano:množ:13   , ;
                                  M->cenaCelk:cenaZakl:13, ;
                                  M->cenCelTuz:cenaTuz:13  ) ; 
                          SIZE(115,11.4) CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(2) ITEMMARKED(ItemMarked)


* vyrzakit
  TYPE(DBrowse) FPOS(0,11.8) FILE(VYRZAKIT)                    ;
                             FIELDS( M->is_expList:ex:1::2   , ;
                                     DMOZODVZAK:datOdv       , ;
                                     CCISZAKAZI:zakázka:12   , ;
                                     CNAZEVZAK1::25          , ;
                                     CSTAVZAKAZ:Stav:2       , ;
                                     CCISLOOBJ:èísloObj:20   , ;
                                     CBARVA:barvaVni:10      , ;
                                     CBARVA_2:barvaVnì:10    , ;  
                                     NMNOZPLANO:Množ         , ;
                                     nRozm_del:délka         , ;
                                     nRozm_sir:šíøka         , ;
                                     nRozm_vys:výška         , ; 
                                     cRozm_MJ:mj             , ;
                                     CNAZFIRMY::20           , ;
                                     CSIDLODOA::20           , ;
                                     M->datExpedice:datExp:10, ;
                                     M->firmaDOP:dopravce:20 , ;
                                     dObDokKonS:datPøedDok   , ;
                                     nKurZahMen:kurz         , ;
                                     nCenaCelk:cena          , ;
                                     czkratmenz:mìna           ) ;
                             SIZE(115,14.2) CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(6)


