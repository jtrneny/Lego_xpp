TYPE(drgForm) DTYPE(10) TITLE(Druhy mezd DMZ) SIZE(100,25) FILE(druhyMzd)      ;
              GUILOOK(Action:y,IconBar:y) CARGO(MZD_druhymzd_CRD) OBDOBI(MZD)


TYPE(Action) CAPTION(~øádkyMzl ) EVENT(DoplnDMZ_RML)   TIPTEXT(Poøizování dokladù o hrubé mzdì)
* TYPE(Action) CAPTION(~Dokl_NEM) EVENT(PorDokl_NEMOCENKA)TIPTEXT(Poøízení nemocenských dávek)


TYPE(DBrowse) FPOS(0.1,0.1) SIZE(100,24.5) FILE(DRUHYMZD) INDEXORD(1)                    ;
              FIELDS( ndruhMzdy:druhMzdy            , ;
                      cnazevDmz:název druhu mzdy    , ;
                      ctypDmz:typMzdy               , ;
                      ntypVypHM:typVýp_HM           , ; 
                      ntypDane:typDanì              , ;
                      M->is_danZaklad:daòZák:2.6::2 , ;
                      M->is_vypocCM:výp_ÈM:2.6::2   , ;
                      M->is_uctuj:úètuj:2.6::2      , ;
                      M->is_socPojis:socPoj:2.6::2  , ; 
                      M->is_zdrPojis:zdrPoj:2.6::2  , ;
                      M->is_napEvidLi:napEvl:2.6::2   ) ;
             CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked) POPUPMENU(y)
