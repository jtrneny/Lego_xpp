TYPE(drgForm) DTYPE(10) TITLE(P�ehled expedice za kalen��n� t�dny ...) FILE(KALENDAR) ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

  TYPE(Action) CAPTION(~Zak�zka)          EVENT(NIC) TIPTEXT(Likvidace faktury p�ijat�)
  TYPE(Action) CAPTION(~Expedi�n� listy)  EVENT(NIC) TIPTEXT(Expedi�n� listy)


* kalend�� dle t�dn�
  TYPE(DBrowse) FPOS(0,0) FILE(KALENDAR)                   ;
                          FIELDS( NROK:rok               , ;
                                  NMESIC:m�s�c           , ;
                                  CNAZMES:n�zM�s�ce      , ; 
                                  NTYDEN:t�den           , ;
                                  M->mnozPlano:mno�:13   , ;
                                  M->cenaCelk:cenaZakl:13, ;
                                  M->cenCelTuz:cenaTuz:13  ) ; 
                          SIZE(115,11.4) CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(2) ITEMMARKED(ItemMarked)


* vyrzakit
  TYPE(DBrowse) FPOS(0,11.8) FILE(VYRZAKIT)                    ;
                             FIELDS( M->is_expList:ex:1::2   , ;
                                     DMOZODVZAK:datOdv       , ;
                                     CCISZAKAZI:zak�zka:12   , ;
                                     CNAZEVZAK1::25          , ;
                                     CSTAVZAKAZ:Stav:2       , ;
                                     CCISLOOBJ:��sloObj:20   , ;
                                     CBARVA:barvaVni:10      , ;
                                     CBARVA_2:barvaVn�:10    , ;  
                                     NMNOZPLANO:Mno�         , ;
                                     nRozm_del:d�lka         , ;
                                     nRozm_sir:���ka         , ;
                                     nRozm_vys:v��ka         , ; 
                                     cRozm_MJ:mj             , ;
                                     CNAZFIRMY::20           , ;
                                     CSIDLODOA::20           , ;
                                     M->datExpedice:datExp:10, ;
                                     M->firmaDOP:dopravce:20 , ;
                                     dObDokKonS:datP�edDok   , ;
                                     nKurZahMen:kurz         , ;
                                     nCenaCelk:cena          , ;
                                     czkratmenz:m�na           ) ;
                             SIZE(115,14.2) CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(6)


