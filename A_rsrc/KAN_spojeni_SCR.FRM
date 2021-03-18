TYPE(drgForm) SIZE(100,25) DTYPE(10) TITLE(Seznam spojení ...) ;
              GUILOOK(Action:y,IconBar:y,Message:y:custumMessageBar) ;
              CARGO(KAN_spojeni_CRD)


TYPE(DBrowse) FPOS(0,0) SIZE(99,10.2) FILE(SPOJENI)                           ;
                            FIELDS(nCisSpoj:Èíslo:7                         , ;
                                   cZkrSpoj:Zkratka spojení:10              , ;
                                   cNazSpoj:Název spojení:35                , ;
                                   cAdrElSpoj:Elektronická adresa:42)         ;
                            CURSORMODE(3) INDEXORD(1) PP(7) RESIZE(x)  POPUPMENU(y) SCROLL(ny) PRE(SetFocus) ITEMMARKED(itemMarked)


* 1 - základní údaje OSOBY
TYPE(Static) STYPE(12) CAPTION(Info) FPOS(1,10.5) SIZE(98,7.2) CTYPE(2)
  TYPE(Text) CAPTION(Info o spojení)      CPOS( 1,  .1)  CLEN(15) FONT(5)
  TYPE(Text) CAPTION(název)               CPOS( 3, 1.2)  CLEN(12)
  TYPE(Text) NAME(spojeni->cNazSpoj)      CPOS(15, 1.2)  CLEN(82) BGND(13) FONT(5) PP(2)
  TYPE(Text) CAPTION(hodnota)             CPOS( 3, 2.3)  CLEN(12)
  TYPE(Text) NAME(spojeni->cadrelspoj)    CPOS(15, 2.3)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) NAME(spojeni->culiccipop)    CPOS(57, 2.3)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) NAME(spojeni->cmisto)        CPOS(57, 3.4)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) NAME(spojeni->cpsc)          CPOS(57, 4.5)  CLEN(40) BGND(13) PP(2)
  TYPE(Text) NAME(spojeni->czkratstat)    CPOS(57, 5.6)  CLEN(40) BGND(13) PP(2)

*  TYPE(Text) CAPTION(psè)               CPOS( 3, 3.4)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->CPSC)          CPOS(17, 3.4)  CLEN( 6) BGND(13) PP(2)
*  TYPE(Text) NAME(C_PSC->CMISTO)        CPOS(24, 3.4)  CLEN(23) BGND(13)
*  TYPE(Text) CAPTION(stát)              CPOS( 3, 4.5)  CLEN(12)
*  TYPE(Text) NAME(OSOBY->CZKRATSTAT)    CPOS(17, 4.5)  CLEN( 6) BGND(13) PP(2)
*  TYPE(Text) NAME(C_STATY->cNAZEVSTAT)  CPOS(24, 4.5)  CLEN(23) BGND(13)
*
*  TYPE(TEXT) NAME(osoby->cjmenoRozl)    CPOS(50, 1.1)  CLEN(45) BGND( 8) CTYPE(2) FONT(5) 

TYPE(End)


                  
TYPE(DBrowse) FPOS(0,18.0) SIZE(99,7) FILE(vazSpoje)                                                    ;
                                          FIELDS(M->is_inPersonal:per:2.6::2                          , ;
                                                 M->is_inMsPrc_mo:zam:2.6::2                          , ;
                                                 vazSpoje_osoby('ncisOsoby'):èíslOsoby                , ;
                                                 vazSpoje_osoby('nosCisPrac'):èísloPrac               , ;
                                                 vazSpoje_osoby('cjmenoRozl'):Pøímení a jméno osoby:35, ;
                                                 vazSpoje_osoby('CMISTO'):Mìsto:25                    , ;
                                                 vazSpoje_osoby('CZKRATSTAT'):Stát                    , ;
                                                 vazSpoje_osoby('CTELEFON'):Telefon:15                , ;
                                                 vazSpoje_osoby('CEMAIL'):Email:30                      ) ;
                                          CURSORMODE(3) INDEXORD(SPOJENI) PP(7) RESIZE(x) SCROLL(yy) PRE(SetFocus)

