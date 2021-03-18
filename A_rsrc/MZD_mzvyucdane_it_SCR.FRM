TYPE(drgForm) DTYPE(10) TITLE(Podklady pro výpoèet roèní danì - položky ) SIZE(115,15)       ;
              GUILOOK(Action:y,IconBar:n,Menu:n) CARGO() OBDOBI(MZD)            ; 
              PRINTFILES(vyucdani: )                             

*  TYPE(Action) CAPTION(~HromadnéZpr)    EVENT(mzd_generuj_vypdan)  TIPTEXT(Hromadný výpoèet roèní danì ...)
*  TYPE(Action) CAPTION(~Doklady)    EVENT(mzd_doklhrmzdo_scr)    TIPTEXT(Poøizení dokladù o mzdì)
*  TYPE(Action) CAPTION(~Mzda)       EVENT(mzd_vypcistamzda_scr)  TIPTEXT(Vypoètená èistá mzda)


  TYPE(DBrowse) FPOS(.45,.20) SIZE(115,15) FILE(vyucdani)        ;
                              FIELDS( nOsCisPrac               , ;                        
                                      nObdobi                  , ;
                                      nUZD_Zames:úhrZDP        , ;  
                                      nPOJ_Zames:pojSocZdr     , ;
                                      nDZD_Zames:dílDanZak     , ; 
                                      nNEZ_Prac:nezdPrac       , ;
                                      nNEZ_Deti:nezdDìti       , ;
                                      nNEZ_CasIn:nezdInv       , ;
                                      nNEZ_PlnIn:nezdPlInv     , ;
                                      nNEZ_ZTP:nezdZTP         , ;
                                      nNEZ_Stud:nezdStud       , ;
                                      nNEZ_Uver:nezdÚvìr       , ;
                                      nZDA_Mzda:zdaòMzda       , ;
                                      nUSZ_Zames:úhrnSrZál       ) ;  
                              ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) PP(7) POPUPMENU(y) RESIZE(yy)                  




