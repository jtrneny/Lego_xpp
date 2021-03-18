TYPE(drgForm) DTYPE(10) TITLE(Objednávky vystavené hlavièky - VÝBÌR) SIZE(100,20);
               GUILOOK(Action:y,Message:n,IconBar:n,Menu:n)

  TYPE(DBrowse) SIZE(110,13.2) FILE(OBJVYSHD)                        ;
                               FIELDS(M->stav_objvyshd:S:2.7::2    , ;
                                      ndoklad:èísloObj             , ; 
                                      ccisobj:èísloObj_int         , ;
                                      ncisfirmy:firma              , ;
                                      cnazev:název firmy:26        , ;
                                      ddatobj:objDne               , ;
                                      nmnozobdod:mn_objednáno      , ;
                                      nmnozpodod:mn_potvrzeno      , ;  
                                      nmnozpldod:mn_dodáno         , ;
                                      nkczdobj:cenaCelk            , ;
                                      czkratMenz:mìna                ) ;
                               CURSORMODE(3) PP(7) INDEXORD(1) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y) ATSTART(LAST)


