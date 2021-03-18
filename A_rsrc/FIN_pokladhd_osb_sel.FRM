TYPE(drgForm) DTYPE(10) TITLE(Seznam pacovníkù a záloh na pokladnì ...) SIZE(100,17) ;
              GUILOOK(Action:n,Menu:n,IconBar:n) ;
              PRE(preValidate) POST(postValidate)  


* Browser definition
  TYPE(DBrowse) FPOS( .2,1.1) SIZE(99.6,7.8) FILE(OSOBY)                                    ;  
                                           FIELDS(M->osoby_pri_zal:zál:2.7::2             , ;
                                                  ncisOsoby:èísloOsoby                    , ; 
                                                  nosCisPrac:èísloPrac                    , ;
                                                  cOsoba:jméno a pøíjmení:37.7            , ;
                                                  M->osoby_kmenStrPr:kmenové støedisko:40 ) ; 
                                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y)

 TYPE(TEXT)     CAPTION(Seznam pacovníkù a záloh na pokladnì ...) CPOS(1,.01) CLEN(40) FONT(5)
 TYPE(ComboBox) NAME(UCT_ucetsys:CULOHA) FPOS(71,.01) FLEN(28);
                VALUES(A:Orávnìné osoby zúèZáloh,B:Kompletní seznam osob);
                ITEMSELECTED(comboItemSelected)


 TYPE(DBrowse) FPOS(0,9.4) SIZE(100, 7.5) FILE(POKZA_ZA)                               ;
                                          FIELDS(nPokladna:pokladna                  , ;
                                                 M->pokza_nazPoklad:název pokladny:41, ;
                                                 nPrij_ZAL:pøijatá záloha            , ;
                                                 M->pokza_minus: :2.7::2             , ;
                                                 nVrac_ZAL:vrácená Záloha            , ;
                                                 M->pokza_equal: :2.7::2             , ;
                                                 M->pokza_zusZal:zùstZálohy          , ;
                                                 pokladms->czkratMeny:mìna             ) ;
                                          CURSORMODE(3) INDEXORD(2) SCROLL(ny) PP(7)
   
