TYPE(drgForm) DTYPE(10) TITLE(Seznam pacovníkù a záloh na pokladnì ...) SIZE(110,25) 


* Browser definition
  TYPE(DBrowse) FPOS( 0, 0) SIZE(110,7.8) FILE(OSOBY)                                     ;  
                                          FIELDS(M->osoby_pri_zal:zál:2.7::2            , ;
                                                ncisOsoby:èísloOsoby                    , ; 
                                                nosCisPrac:èísloPrac                    , ;
                                                cOsoba:jméno a pøíjmení:43              , ;
                                                M->osoby_kmenStrPr:kmenové støedisko:45 ) ; 
                                         ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y)


  TYPE(Static) FPOS(.1,7.8) SIZE(110,1.2) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(zálohy dle pokladen a pracovníkù) CPOS(1,.01) CLEN(105) FONT(5) CTYPE(1)
  TYPE(END) 

  TYPE(DBrowse) FPOS(0,9) SIZE(110,6.8) FILE(POKZA_ZA)                                  ;
                                           FIELDS(nPokladna:pokladna                  , ;
                                                  M->pokza_nazPoklad:název pokladny:51, ;
                                                  nPrij_ZAL:pøijatá záloha            , ;
                                                  M->pokza_minus: :2.7::2             , ;
                                                  nVrac_ZAL:vrácená Záloha            , ;
                                                  M->pokza_equal: :2.7::2             , ;
                                                  M->pokza_zusZal:zùstZálohy          , ;
                                                  pokladms->czkratMeny:mìna             ) ;
                                           ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(2) SCROLL(ny) PP(7)
   
  TYPE(Static) FPOS(0.1,15.8) SIZE(110,1.2) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT)     CAPTION(pøehled pøijatých, zúètovaných a vrácených záloh) CPOS(1,.01) CLEN(108) FONT(5) CTYPE(1)
  TYPE(END) 

  TYPE(DBrowse) FPOS(0,17.1) SIZE(110,7.7) FILE(POKLADHD)                     ;
                                          FIELDS(M->oinf|tisk:T:2.6::2      , ;
                                                 M->oinf|danuzav:D:2.6::2   , ;
                                                 M->oinf|likvidace:L:2.6::2 , ;
                                                 M->oinf|ucuzav:U:2.6::2    , ;
                                                 COBDOBI:obd:5              , ;                                                                                                                       
                                                 NPOKLADNA:pokladna         , ;
                                                 M->typPohybu::2.7::2       , ;
                                                 NDOKLAD:èísDokladu         , ;
                                                 DPORIZDOK:datPoøízení      , ;
                                                 CUCET_UCT:SuAu_Ø           , ;
                                                 CTEXTDOK:úèel platby:27    , ;
                                                 FIN_pokladhd_BC(8):èástka:13, ;
                                                 CZKRATMENZ:mìna            , ;
                                                 nosvoddan:osvobozeno       , ; 
                                                 nzakldan_1:základ(sd)      , ;
                                                 nsazdan_1:sazba(sd)        , ;
                                                 nzakldan_2:základ(zd)      , ;
                                                 nsazdan_2:sazba(zd)          ) ;
                                          CURSORMODE(3) PP(7) 
