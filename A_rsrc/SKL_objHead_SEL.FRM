TYPE(drgForm) DTYPE(10) TITLE(Objednávky pøijaté hlavièky - VÝBÌR) SIZE(110,20);
               GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

  TYPE(DBrowse) SIZE(110,19.2) FILE(OBJHEAD)                       ;
                               FIELDS( M->stav_objhead::2.7::2   , ;
                                       ndoklad:èísloobj          , ;
                                       ccislobint:èíslo_objGen   , ;
                                       ccisobj:èíslo_objInt      , ;
                                       ddatobj:objDne:10         , ;
                                       nmnozobodb:mn_objednáno   , ;
                                       nmnozpoodb:mn_potvrzeno   , ;  
                                       nmnozplodb:mn_dodáno      , ;
                                       nkcsbdobj:celkBDanì       , ;
                                       nkcszdobj:celkSDaní         ) ;
                               CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


