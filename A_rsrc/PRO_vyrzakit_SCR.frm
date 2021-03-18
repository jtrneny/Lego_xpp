TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky ...) FILE(VYRZAKIT) ;
              CARGO(pro_vyrzakit_in)                              ;
              POST(postValidate)                                  ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

  TYPE(Action) CAPTION(~Zakázka)          EVENT(vyr_vyrzak_scr)   TIPTEXT(Výrobní zakázka)
  TYPE(Action) CAPTION(~Expedièní listy)  EVENT(pro_explsthd_scr) TIPTEXT(Expedièní listy)


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


* expedièní listy
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET( 1,86) CAPTION(dodávky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(expedièní pøíkaz) CPOS(.1,0) CLEN(114) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(GET) NAME(explstit->ndoklad)   FPOS( .8,1.7) FLEN(13) FCAPTION(2. Expedièní list èíslo)  CPOS( 1,0.8) CLEN(18) PUSH(pro_explsthd_sel)
    TYPE(PushButton) POS(15.1,1.6) SIZE(3,.9) EVENT(pro_explsthd_del) ICON1(110) ICON2(210) ATYPE(1) TIPTEXT(Odpojení expedièního listu)
    TYPE(PushButton) POS(18.1,1.6) SIZE(3,.9) EVENT(pro_explsthd_ins) ICON1(107) ICON2(207) ATYPE(1) TIPTEXT(Pøipojení expedièního listu)
    TYPE(GET) NAME(explstit->nfaktMnoz) FPOS(36,1.7) FLEN(13) FCAPTION(množství)                 CPOS(36,0.8)


    TYPE(DBROWSE) FILE(EXPLSTIT) FPOS(0,2.8)                       ; 
                                 FIELDS(ndoklad:expList          , ;
                                        M->datNakladky:datNakl:12, ;
                                        M->datExpedice:datExp:12 , ;
                                        nfaktMnoz:množství        ) ;
                                 SIZE(50,5.5) CURSORMODE(3) PP(7) SCROLL(nn) RESIZE(ny) POPUPMENU(n) ITEMMARKED(ItemMarked) 
 


    TYPE(Static)  FPOS(55.5,1) SIZE(57.7,6.9) CAPTION(Dopravce)
      TYPE(Text)  CAPTION(Dopravce )          CPOS( 1,1.5) CLEN(11)
      TYPE(Text)  NAME(EXPLSTHD->NCISFIRDOP)  CPOS(12,1.5) CLEN(10) BGND(13)

      TYPE(Text)  CAPTION(Ièo)                CPOS(24,1.5) CLEN( 4)
      TYPE(Text)  NAME(EXPLSTHD->NICODOP)     CPOS(28,1.5) CLEN(11) BGND(13)

      TYPE(Text)  CAPTION(Diè)                CPOS(40,1.5)
      TYPE(Text)  NAME(EXPLSTHD->CDICDOP)     CPOS(43,1.5) CLEN(13) BGND(13)

      TYPE(Text)  CAPTION(Název)              CPOS( 3,2.5) CLEN( 9)
      TYPE(Text)  NAME(EXPLSTHD->CNAZEVDOP)   CPOS(12,2.5) CLEN(27) BGND(13)
      TYPE(Text)  NAME(EXPLSTHD->CNAZEVDOP2)         CPOS(12,3.5) CLEN(27) BGND(13)

      TYPE(Text)  CAPTION(Ulice)              CPOS( 3,4.5)
      TYPE(Text)  NAME(EXPLSTHD->CULICEDOP)   CPOS(12,4.5) CLEN(27) BGND(13)

      TYPE(Text)  CAPTION(PSè)                CPOS( 3,5.5) CLEN( 5)
      TYPE(Text)  NAME(EXPLSTHD->CPSCDOP)     CPOS(12,5.5) CLEN(10) BGND(13)

      TYPE(Text)  NAME(EXPLSTHD->CSIDLODOP)   CPOS(24,5.5) CLEN(27) BGND(13)
   TYPE(End)
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




