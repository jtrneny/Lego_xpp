TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky ...) FILE(VYRZAKIT) ;
              CARGO(pro_vyrzakit_in)                              ;
              POST(postValidate)                                  ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

  TYPE(Action) CAPTION(~Zakázka)          EVENT(NIC)              TIPTEXT(Likvidace faktury pøijaté)
  TYPE(Action) CAPTION(~Expedièní listy)  EVENT(pro_explsthd_scr) TIPTEXT(Expedièní listy)


  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1)                       ;
                               FIELDS( M->is_expList:ex:1::2   , ;
                                       DMOZODVZAK:datOdv       , ;
                                       ncisloEL:expList:8      , ;
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
                                       dObDokKonS              , ;
                                       nCenaCelk               , ;
                                       czkratmenz:mìna           ) ;
                               SIZE(115,15.5) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(y) ITEMMARKED(ItemMarked)


* èíslo expListu
* datum nakládky
* èas   nakládky
* pøepoèet na CZK kurzem

* info
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
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
  TYPE(End)

*    TYPE(TEXT) CAPTION(Položky pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(End)

* úhrady
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(dodávky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(expedièní pøíkaz) CPOS(.1,0) CLEN(114) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(GET) NAME(vyrzakit->ncisloEL)  FPOS(26,1.5) FLEN(12) FCAPTION(2. Expedièní list èíslo)  CPOS(1,1.5)  PP(2) FONT(5) CLEN(18) PUSH(pro_explsthd_sel)
    TYPE(PushButton) POS(39.4,1.4) SIZE(3,.9) EVENT(pro_explsthd_del) ICON1(120) ICON2(220) ATYPE(1) TIPTEXT(Odpojení expedièního listu)

    TYPE(Static)  FPOS(44.5,1) SIZE(68.7,6.9) CAPTION(Dopravce)
      TYPE(Text)  CAPTION(Dopravce )          CPOS( 1,1.5) CLEN(11)
      TYPE(Text)  NAME(EXPLSTHD->NCISFIRDOP)  CPOS(12,1.5) CLEN(10) BGND(13)

      TYPE(Text)  CAPTION(Ièo)                CPOS(24,1.5) CLEN( 4)
      TYPE(Text)  NAME(EXPLSTHD->NICODOP)     CPOS(28,1.5) CLEN(11) BGND(13)

      TYPE(Text)  CAPTION(Diè)                CPOS(41,1.5)
      TYPE(Text)  NAME(EXPLSTHD->CDICDOP)     CPOS(45,1.5) CLEN(10) BGND(13)

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

* likvidace
*  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)
*    TYPE(TEXT) CAPTION(Likvidace pohledávky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(End)

* øádky výkazu dph
*  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(37,50) CAPTION(øádky dph) TABHEIGHT(.8) PRE(tabSelect)
*    TYPE(TEXT) CAPTION(Øádky výkazu dph) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(END)

