TYPE(drgForm) DTYPE(10) TITLE( P�ehled pokladn�ch z�statk� ...) SIZE(110,25) ;
                                                                OBDOBI(FIN)  


  TYPE(Action) CAPTION(~P�epo�et stavu)  EVENT(fin_pokladks_cmp) TIPTEXT(Kontroln� p�epo�et stavu)


* BROWSER DEFINITION
  TYPE(DBrowse) FPOS(0,.1) SIZE(109.6,8) FILE(POKLADKS)                       ;
                                           FIELDS(NPOKLADNA:pokladna          , ;
                                                  M->nazPokl:n�zev pokladny:27, ;
                                                  DPORIZDOK:datP��zen�        , ;
                                                  NPOCSTAV:po�Stav            , ;
                                                  NPRIJEM:p��jem              , ;
                                                  NVYDEJ:v�dej                , ;
                                                  NAKTSTAV:stavPokl           , ;
                                                  M->zkrMeny:zkrM�ny:5          )  ;
                                           CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked) ATSTART(LAST) POPUPMENU(y)


  TYPE(DBrowse) FPOS(0,8.2) SIZE(109.6,7.1) FILE(POKLADHD)                      ;
                                            FIELDS(M->oinf|tisk:T:2.6::2      , ;
                                                   M->oinf|danuzav:D:2.6::2   , ;
                                                   M->oinf|likvidace:L:2.6::2 , ;
                                                   M->oinf|ucuzav:U:2.6::2    , ;
                                                   COBDOBI:obd:5              , ;
                                                   NPOKLADNA:pokladna         , ;
                                                   M->typPohybu::2.7::2       , ;
                                                   NDOKLAD:��sDokladu         , ;
                                                   DPORIZDOK:datPo��zen�      , ;
                                                   CUCET_UCT:SuAu_�           , ;
                                                   CTEXTDOK:��el platby:36    , ;
                                                   FIN_pokladhd_BC(8):��stka:13, ;
                                                   CZKRATMENZ:m�na              )  ;
                                            CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yy) ITEMMARKED(itemMarked)


* polo�ky
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(1,86) CAPTION(polo�ky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Polo�ky pokladn�ho dokladu) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,7) FILE(POKLADIT)                        ;
                                            FIELDS(CVARSYM:varSymbol            , ;
                                                   NCISFAK:��sloFaktury         , ;
                                                   NCISFIRMY:��sloFirmy         , ;
                                                   CNAZEV:N�zev firmy:55        , ;
                                                   FIN_pokladhd_BC(52):��stka:13, ;
                                                   M->typObratu:typ:2.7::2        ) ;
                                            CURSORMODE(3) PP(7) SCROLL(ny) Resize(yy)
  TYPE(END)

* likvidace
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Likvidace pokladn�ho dokladu) CPOS(0,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,7) FILE(UCETPOL)                 ;
                                            FIELDS(NDOKLAD:doklad       , ;
                                                   COBDOBI:OBD_��       , ;
                                                   CTEXT:Text dokladu:50, ;
                                                   CUCETMD:SuAu_�       , ;
                                                   NKCMD                , ;
                                                   NKCDAL               , ;
                                                   CUCETDAL:SuAu_S        ) ;
                                            CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)
  TYPE(End)

* informace o dokladu
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(109.5,9.2) TTYPE(3) OFFSET(25,62) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Stav pokladn�ho dokladu) CPOS(0,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(Static) STYPE(13) SIZE(108,6) FPOS(.8,1.3) RESIZE(y)
* 1
    TYPE(Text) CAPTION(Datum UZP __________________)    CPOS(25, .5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->DVYSTDOK)                 CPOS(50, .5) CLEN(13) BGND(13) PP(2)
    TYPE(Text) NAME(POKLADHD->CJMENOPRIJ)               CPOS(65, .5) CLEN(25) BGND(13) PP(2)
* 2
    TYPE(Text) CAPTION(Bez dan�    __________________)  CPOS(25,1.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NOSVODDAN)                CPOS(50,1.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 3
    TYPE(Text) CAPTION(Sn�en� sazba dan�  __________)  CPOS(25,2.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NZAKLDAN_1)               CPOS(50,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->NSAZDAN_1)                CPOS(65,2.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 4
    TYPE(Text) CAPTION(Z�kladn� sazba dan�  __________) CPOS(25,3.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NZAKLDAN_2)               CPOS(50,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->NSAZDAN_2)                CPOS(65,3.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
* 5
    TYPE(Text) CAPTION(N�zev firmy _________________)   CPOS(25,4.5) CLEN(25)
    TYPE(Text) NAME(POKLADHD->NCISFIRMY)                CPOS(50,4.5) CLEN(13) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(POKLADHD->CNAZEV)                   CPOS(65,4.5) CLEN(25) BGND(13) PP(2)
    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)