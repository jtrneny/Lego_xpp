TYPE(drgForm) DTYPE(10) TITLE( Pøehled pokladních dokladù ...) SIZE(100,25) FILE(POKLADHD)    ;
                                                               CARGO(FIN_POKLADHD_IN) OBDOBI(FIN) ;
                                                               PRINTFILES(pokladhd:ndoklad=ndoklad, ;
                                                                          pokladit:ndoklad=ndoklad, ;
                                                                          ucetpol:cdenik=cdenik+ndoklad=ndoklad)
                                                               
  TYPE(Action) CAPTION(~Likvidace)  EVENT(FIN_LIKVIDACE_IN) TIPTEXT(Likvidace pokladního dokladu)
  TYPE(Action) CAPTION(~Výkaz DPH)  EVENT(FIN_VYKDPH_IN)    TIPTEXT(Øádky výkazu DPH)


* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(.1,.1) SIZE(99.6,9.5) FILE(POKLADHD)                     ;
                                          FIELDS(M->oinf|stavEet:e:2.6::2   , ;
                                                 M->oinf|tisk:T:2.6::2      , ;
                                                 M->oinf|danuzav:D:2.6::2   , ;
                                                 M->oinf|likvidace:L:2.6::2 , ;
                                                 M->oinf|ucuzav:U:2.6::2    , ;
                                                 COBDOBI:obdÚè:5            , ;                                                                                                                       
                                                 NPOKLADNA:pokladna         , ;
                                                 M->typPohybu::2.7::2       , ;
                                                 NDOKLAD:èísDokladu         , ;
                                                 DPORIZDOK:datPoøízení:10   , ;
                                                 CUCET_UCT:SuAu_Ø           , ;
                                                 CTEXTDOK:úèel platby:25    , ;
                                                 FIN_pokladhd_BC(8):èástka:13, ;
                                                 CZKRATMENZ:mìna            , ;
                                                 nosvoddan:osvobozeno       , ; 
                                                 nzakldan_1:základ(sd)      , ;
                                                 nsazdan_1:sazba(sd)        , ;
                                                 nzakldan_2:základ(zd)      , ;
                                                 nsazdan_2:sazba(zd)          ) ;
                                          CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)

*  TYPE(COMBOBOX) NAME(FIN_pokladhd_SCR:npokladna) FPOS(60.5,.05) FLEN(39) ;
*                 VALUES(a,a,a,a,a) COMBOINIT(comboBoxInit) ITEMSELECTED(comboItemSelected)



* INFO DEFINITION
  TYPE(Static) STYPE(13) SIZE(98,6) FPOS(1,10) RESIZE(yx)
* 1
    TYPE(Text) CAPTION(Datum UZP __________________)    CPOS(15, .5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->DVYSTDOK)                 CPOS(40, .5) CLEN(13) BGND(13) PP(2)
    TYPE(Text) NAME(POKLADHD->CJMENOPRIJ)               CPOS(55, .5) CLEN(25) BGND(13) PP(2)
* 2
    TYPE(Text) CAPTION(Bez danì    __________________)  CPOS(15,1.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NOSVODDAN)                CPOS(40,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 3
    TYPE(Text) CAPTION(Snížená sazba danì  __________)  CPOS(15,2.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NZAKLDAN_1)               CPOS(40,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->NSAZDAN_1)                CPOS(55,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)

    TYPE(Text) NAME(POKLADHD->NZAKLDAN_3)               CPOS(70,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->NSAZDAN_3)                CPOS(84,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)

* 4
    TYPE(Text) CAPTION(Základní sazba danì  __________) CPOS(15,3.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NZAKLDAN_2)               CPOS(40,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->NSAZDAN_2)                CPOS(55,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 5
    TYPE(Text) CAPTION(Název firmy _________________)   CPOS(15,4.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NCISFIRMY)                CPOS(40,4.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->CNAZEV)                   CPOS(55,4.5) CLEN(25) BGND(13) PP(2)
   TYPE(End)


* položky
  TYPE(TABPAGE) FPOS(.5,16.2) SIZE(99.5,8.5) TTYPE(3) OFFSET(1,86) CAPTION(položky) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Položky pokladního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,6.5) FILE(POKLADIT);
                                            FIELDS(CVARSYM:varSymbol            , ;
                                                   NCISFAK:èísloFaktury         , ;
                                                   NCISFIRMY:èísloFirmy         , ;
                                                   CNAZEV:Název firmy:44        , ;
                                                   FIN_pokladhd_BC(52):èástka:13, ;
                                                   M->typObratu:typ:2.7::2        ) ;
                                            CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yx)
  TYPE(END)

* likvidace
  TYPE(TABPAGE) FPOS(.5,16.2) SIZE(99.5,8.5) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx)
    TYPE(TEXT) CAPTION(Likvidace pokladního dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,6.5) FILE(UCETPOL);
                                           FIELDS(NDOKLAD:doklad       , ;
                                                  COBDOBI:OBD_úè       , ;
                                                  CTEXT:Text dokladu:40, ;
                                                  CUCETMD:SuAu_Ø       , ;
                                                  NKCMD                , ;
                                                  NKCDAL               , ;
                                                  CUCETDAL:SuAu_S        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(4) SCROLL(ny)
  TYPE(End)

* øádky výkazu dph
  TYPE(TABPAGE) FPOS(.5,16.2) SIZE(99.5,8.5) TTYPE(3) OFFSET(25,62) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect) RESIZE(yx) 
    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1) RESIZE(yx)
    TYPE(DBrowse) FPOS(0,1) SIZE(99.6,6.5) FILE(VYKDPH_I)                                 ;  
                                           FIELDS(NRADEK_DPH:øv                         , ;
                                                  fin_vykdph_ibc():název øádku výkazu:43, ; 
                                                  NZAKLD_DPH:základ                     , ;
                                                  NSAZBA_DPH:sazba                      , ;
                                                  NKRACE_NAR:krácení                    , ;
                                                  CUCETU_DPH:SuAu_                        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yx) INDEXORD(1) SCROLL(ny)
  TYPE(END)
