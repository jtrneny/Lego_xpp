TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky ...) FILE(VYRZAKIT) ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

*             CARGO(pro_vyrzakit_in)                              ;
*  TYPE(Action) CAPTION(~Zakázka)          EVENT(vyr_vyrzak_scr)   TIPTEXT(Výrobní zakázka)
*  TYPE(Action) CAPTION(~Expedièní listy)  EVENT(pro_explsthd_scr) TIPTEXT(Expedièní listy)


  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1)                       ;
                               FIELDS( M->is_expList:ex:1::2   , ;
                                       DMOZODVZAK:datOdv       , ;
                                       CCISZAKAZI:zakázka:12   , ;
                                       CNAZEVZAK1::25          , ;
                                       CSTAVZAKAZ:Stav:2       , ;
                                       CCISLOOBJ:èísloObj:20   , ;
                                       CBARVA:barvaVni:10      , ;
                                       CBARVA_2:barvaVnì:10    , ;  
                                       NMNOZPLANO:Množ         , ;
                                       nRozm_del:délka         , ;
                                       nRozm_sir:šíøka         , ;
                                       nRozm_vys:výška         , ; 
                                       cRozm_MJ:mj             , ;
                                       CNAZFIRMY::20           , ;
                                       CSIDLODOA::20           , ;
                                       M->datExpedice:datExp:10, ;
                                       M->firmaDOP:dopravce:20 , ;
                                       nTydenODV:týdenOdv      , ;
                                       dObDokKonS:datPøedDok   , ;
                                       nKurZahMen:kurz         , ;
                                       nCenaCelk:cena          , ;
                                       czkratmenz:mìna           ) ;
                               SIZE(115,15.5) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(y) ITEMMARKED(ItemMarked)


* položky - objvysit
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(položky objednávky) TABHEIGHT(.9) PRE(tabSelect)
    TYPE(TEXT) CAPTION(Položky objednávky) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(11) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109.6,7.6) FILE(OBJVYSIT)                      ;
                                             FIELDS(M->stav_objvysit::2.7::2  , ;
                                                    ccissklad:sklad           , ; 
                                                    csklpol:sklPol            , ;             
                                                    cnazzbo:název zboží:31    , ;
                                                    nmnozobdod:mn_objednáno   , ;
                                                    nmnozpodod:mn_potvrzeno   , ;  
                                                    nmnozpldod:mn_dodáno      , ;
                                                    M->sklVydeje:vydánoSKL:13 , ;
                                                    nkczdobj:cenaCelk         ) ;
                                             CURSORMODE(3) PP(7) INDEXORD(6) SCROLL(ny) RESIZE(x)     
  TYPE(End)

* info
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.1)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Název zakázky)         CPOS( 40, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cNazevZak1)               CPOS( 40, 1.1)   CLEN( 70) PICTURE(&X70) BGND( 13) GROUPS(clrYELLOW)
*
    TYPE(Text) CAPTION(Vyr. položka)          CPOS(  3, 2.2)   CLEN( 15)
    TYPE(Text) NAME(cVyrPol)                  CPOS(  3, 3.2)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta)              CPOS( 20, 2.2)   CLEN(  8)
    TYPE(Text) NAME(nVarCis)                  CPOS( 20, 3.2)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èíslo objednávky)      CPOS( 30, 2.2)   CLEN( 20)
    TYPE(Text) NAME(cCisloObj)                CPOS( 30, 3.2)   CLEN( 60) BGND( 13) GROUPS(clrGREY)

*   2.øádek
    TYPE(Text) CAPTION(Založení zak.)         CPOS(  3, 4.3)   CLEN( 10)
    TYPE(Text) NAME(dZapis)                   CPOS(  3, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Plán. odvedení)        CPOS( 15, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dOdvedZaka)               CPOS( 15, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Èíslo plánu)           CPOS( 27, 4.3)   CLEN( 15)
    TYPE(Text) NAME(cCisPlan)                 CPOS( 27, 5.3)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skut. odvedení)        CPOS( 45, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dSkuOdvZak)               CPOS( 45, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Uzavøení zak.)         CPOS( 57, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dUzavZaka)                CPOS( 57, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)

*   3.øádek
    TYPE(Text) CAPTION(Mn.plán. z obj.)       CPOS(  3, 6.4)   CLEN( 12)
    TYPE(Text) NAME(nMnozPlanO)               CPOS(  3, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Zadáno do výr.)        CPOS( 17, 6.4)   CLEN( 13)
    TYPE(Text) NAME(nMnozZadan)               CPOS( 17, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. vyrobené)          CPOS( 30, 6.4)   CLEN( 12)
    TYPE(Text) NAME(nMnozVyrob)               CPOS( 30, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn.fakturované)        CPOS( 43, 6.4)   CLEN( 13)
    TYPE(Text) NAME(nMnozVyrob)               CPOS( 43, 7.4)   CLEN( 13) BGND( 13) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Pl. prùbìh)            CPOS( 63, 6.4)   CLEN( 10)
    TYPE(Text) NAME(NPLANPRUZA)               CPOS( 63, 7.4)   CLEN(  6) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Priorita)              CPOS( 75, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 75, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 85, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 85, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)




