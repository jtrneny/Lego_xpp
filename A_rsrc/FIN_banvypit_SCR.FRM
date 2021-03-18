TYPE(drgForm) DTYPE(10) TITLE(Bankovní výpisy dle položek ...) SIZE(115,25) ; 
                                                               OBDOBI(FIN)  ;
                                                               PRNFILES(banvyphd:ndoklad=ndoklad, ;
                                                                        banvypit:ndoklad=ndoklad, ;
                                                                        ucetpol:cdenik=cdenik+ndoklad=ndoklad)


  TYPE(DBrowse) FPOS(0,0) SIZE(114.8,10.6) FILE(BANVYPIT)                       ;
                                           FIELDS(M->err_imp_it:E:2.4::2      , ;
                                                  FIN_banvypit_BC(1):_:2.7::2 , ;
                                                  cVARSYM:varSymb             , ;
                                                  nCISFAK:èísloFak            , ;
                                                  dSPLATFAK:datSplat          , ;
                                                  dDATUHRADY:datÚhrady        , ;
                                                  cTEXT:text Položky:46       , ;
                                                  nCENZAKCEL:celkÚhrada       , ;
                                                  FIN_banvypit_BC(8):typ:2.5::2 ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) RESIZE(x) ITEMMARKED(itemMarked) POPUPMENU(y)
*
**
  TYPE(Static) FPOS(.1,10.8) SIZE(114.8,1.2) STYPE(12) RESIZE(y) CTYPE(2)
    TYPE(TEXT) CAPTION(bankovní výpis hlavièka) CPOS(1,.01) CLEN(98) FONT(5) CTYPE(1)
  TYPE(END) 

  TYPE(DBrowse) FPOS(0,12) SIZE(114.8,3.3) FILE(BANVYPHD)                         ;  
                                           FIELDS( M->err_imp_hd:E:2.4::2       , ;
                                                   M->oinf|likvidace:L:2.6::2   , ;
                                                   M->oinf|ucuzav:U:2.6::2      , ;
                                                   nDOKLAD:doklad:9             , ;
                                                   cBANK_UCT:bankovní Úèet:20   , ;
                                                   nCISPOVYP:výp                , ;
                                                   dDATPORIZ:ze dne             , ;
                                                   nPOSZUST:poèStav             , ;
                                                   nPRIJEM:pøíjemÚèt            , ;
                                                   nVYDEJ:výdejÚèt              , ;
                                                   nZUSTATEK:aktStav            , ;
                                                   nPRIJEMz:pøíjemZah           , ;
                                                   nVYDEJz:výdejZah             , ;
                                                   czkratmeny:mìna                ) ;
                                            CURSORMODE(3) PP(7) INDEXORD(1) SCROLL(yn) RESIZE(x)            

* info
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(114.5,9.2) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Základní informace o dokladu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
* pravá strana karty
    TYPE(Text) NAME(M->naztypPoh_hd)                  CPOS(11.3,1.7 ) CLEN(28)           BGND(13)

    TYPE(Text) CAPTION(Úèet)                          CPOS( 2.3,2.7 ) CLEN( 8)                    FONT(5)
    TYPE(Text) NAME(BANVYPHD->cBANK_UCT)              CPOS(11.3,2.7 ) CLEN(28)           BGND(13)

    TYPE(Text) CAPTION(SuAu_Ø)                        CPOS( 2.3,3.7 ) CLEN( 8)                    FONT(5) 
    TYPE(Text) NAME(BANVYPHD->cUCET_UCT)              CPOS(11.3,3.7 ) CLEN( 9) CTYPE(2)  BGND(13) FONT(5)

    TYPE(Text) CAPTION(Výpis)                         CPOS( 2.3,4.7 ) CLEN( 8)                    FONT(5)
    TYPE(Text) NAME(BANVYPHD->nCISPOVYP)              CPOS(11.3,4.7 ) CLEN( 6) CTYPE(2)  BGND(13) 
    TYPE(Text) CAPTION(/)                             CPOS(19.3,4.7 ) CLEN( 2)   
    TYPE(Text) NAME(BANVYPHD->nPOCPOLOZ)              CPOS(22.3,4.7 ) CLEN( 4) CTYPE(2)  BGND(13) 
    TYPE(Text) CAPTION(ze dne)                        CPOS(27.3,4.7 ) CLEN( 6)
    TYPE(Text) NAME(BANVYPHD->dDATPORIZ)              CPOS(34.3,4.7 ) CLEN(11) CTYPE(2)  BGND(13)

    TYPE(Text) CAPTION(Doklad)                        CPOS( 2.3,5.7 ) CLEN( 8)                    FONT(5)
    TYPE(Text) NAME(BANVYPHD->nDOKLAD)                CPOS(11.3,5.7 ) CLEN(11) CTYPE(2)  BGND(13)      

    TYPE(Text) CAPTION(kurz/pøep)                     CPOS(24.3,5.7 ) CLEN( 8)
    TYPE(Text) NAME(BANVYPHD->NKURZAHMEN)             CPOS(34.3,5.7 ) CLEN(11)           BGND(13)
    TYPE(Text) NAME(BANVYPHD->NMNOZPREP)              CPOS(45.3,5.7 ) CLEN( 5)           BGND(13)  

* levá strana karty
    TYPE(Text) CAPTION(OBD_úè)                        CPOS(50.3,1.7 ) CLEN( 7)
    TYPE(Text) NAME(BANVYPHD->COBDOBI)                CPOS(61.3,1.7 ) CLEN(11)  CTYPE(1) BGND(13)

    TYPE(Text) CAPTION(Stav den)                      CPOS(50.3,2.7 )                  
    TYPE(Text) NAME(BANVYPHD->dDATPOVYP)              CPOS(61.3,2.7 ) CLEN(11) CTYPE(2) BGND(13) 
    TYPE(Text) NAME(BANVYPHD->nPOSZUST)               CPOS(76.3,2.7 ) CLEN(14) CTYPE(2) BGND(13) 
    TYPE(Text) NAME(BANVYPHD->cZKRATMENY)             CPOS(93.3,2.7 ) CLEN( 4)          BGND(13)

    TYPE(Text) CAPTION(Ve prospìch úètu _______)      CPOS(50.3,3.7 ) CLEN(23) FONT(5)           
    TYPE(Text) NAME(M->veProspech_hd)                 CPOS(76.3,3.7 ) CLEN(14) CTYPE(2) BGND(13) 
    TYPE(Text) NAME(BANVYPHD->cZKRATMENY)             CPOS(93.3,3.7 ) CLEN( 4)          BGND(13) 

    TYPE(Text) CAPTION(Na vrub úètu          _______) CPOS(50.3,4.7 ) CLEN(23) FONT(5)           
    TYPE(Text) NAME(M->naVrub_hd)                     CPOS(76.3,4.7 ) CLEN(14) CTYPE(2) BGND(13) 
    TYPE(Text) NAME(BANVYPHD->cZKRATMENY)             CPOS(93.3,4.7 ) CLEN( 4)          BGND(13) 

    TYPE(Text) CAPTION(Zùstatek)                      CPOS(50.3,5.7 )
    TYPE(Text) NAME(BANVYPHD->dDATZUST)               CPOS(61.3,5.7 ) CLEN(11) CTYPE(2) BGND(13)
    TYPE(Text) NAME(BANVYPHD->nZUSTATEK)              CPOS(76.3,5.7 ) CLEN(14) CTYPE(2) BGND(13) FONT(5) 
    TYPE(Text) NAME(BANVYPHD->cZKRATMENY)             CPOS(93.3,5.7 ) CLEN( 4)          BGND(13)         

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* likvidace
  TYPE(TABPAGE) FPOS(.5,15.5) SIZE(114.5,9.2) TTYPE(3) OFFSET(13,74) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)  
    TYPE(TEXT) CAPTION(Likvidace bankovního výpisu) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(114,7.2) FILE(UCETPOL)                 ;  
                                           FIELDS(NDOKLAD:doklad       , ;
                                                  COBDOBI:OBD_úè       , ;
                                                  CTEXT:Text dokladu:40, ;
                                                  CUCETMD:SuAu_Ø       , ;
                                                  NKCMD                , ;
                                                  NKCDAL               , ;
                                                  CUCETDAL:SuAu_S        ) ;
                                           CURSORMODE(3) PP(7) RESIZE(yy) INDEXORD(4) SCROLL(ny)
  TYPE(End)







