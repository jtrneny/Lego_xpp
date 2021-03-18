TYPE(drgForm) DTYPE(10) TITLE(V�robn� zak�zky ...) FILE(VYRZAKIT) ;
              CARGO(pro_vyrzakit_in)                              ;
              POST(postValidate)                                  ;
              SIZE(115,26) GUILOOK(Action:y,IconBar:y)

  TYPE(Action) CAPTION(~Zak�zka)          EVENT(NIC)              TIPTEXT(Likvidace faktury p�ijat�)
  TYPE(Action) CAPTION(~Expedi�n� listy)  EVENT(pro_explsthd_scr) TIPTEXT(Expedi�n� listy)


  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1)                       ;
                               FIELDS( M->is_expList:ex:1::2   , ;
                                       DMOZODVZAK:datOdv       , ;
                                       ncisloEL:expList:8      , ;
                                       CCISZAKAZI:zak�zka:12   , ;
                                       CNAZEVZAK1::25          , ;
                                       CSTAVZAKAZ:Stav:2       , ;
                                       CCISLOOBJ:��sloObj:20   , ;
                                       CBARVA:barvaVni:10      , ;
                                       CBARVA_2:barvaVn�:10    , ;  
                                       NMNOZPLANO:Mno�         , ;
                                       nRozm_del:d�lka         , ;
                                       nRozm_sir:���ka         , ;
                                       nRozm_vys:v��ka         , ; 
                                       cRozm_MJ:mj             , ;
                                       CNAZFIRMY::20           , ;
                                       CSIDLODOA::20           , ;
                                       M->datExpedice:datExp:10, ;
                                       M->firmaDOP:dopravce:20 , ;
                                       dObDokKonS              , ;
                                       nCenaCelk               , ;
                                       czkratmenz:m�na           ) ;
                               SIZE(115,15.5) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(y) ITEMMARKED(ItemMarked)


* ��slo expListu
* datum nakl�dky
* �as   nakl�dky
* p�epo�et na CZK kurzem

* info
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
*   1.��dek
    TYPE(Text) CAPTION(Zak�zka)               CPOS(  3, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.1)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(N�zev zak�zky)         CPOS( 40, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cNazevZak1)               CPOS( 40, 1.1)   CLEN( 70) PICTURE(&X70) BGND( 13) GROUPS(clrYELLOW)
*
    TYPE(Text) CAPTION(Vyr. polo�ka)          CPOS(  3, 2.2)   CLEN( 15)
    TYPE(Text) NAME(cVyrPol)                  CPOS(  3, 3.2)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Varianta)              CPOS( 20, 2.2)   CLEN(  8)
    TYPE(Text) NAME(nVarCis)                  CPOS( 20, 3.2)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(��slo objedn�vky)      CPOS( 30, 2.2)   CLEN( 20)
    TYPE(Text) NAME(cCisloObj)                CPOS( 30, 3.2)   CLEN( 60) BGND( 13) GROUPS(clrGREY)

*   2.��dek
    TYPE(Text) CAPTION(Zalo�en� zak.)         CPOS(  3, 4.3)   CLEN( 10)
    TYPE(Text) NAME(dZapis)                   CPOS(  3, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Pl�n. odveden�)        CPOS( 15, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dOdvedZaka)               CPOS( 15, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(��slo pl�nu)           CPOS( 27, 4.3)   CLEN( 15)
    TYPE(Text) NAME(cCisPlan)                 CPOS( 27, 5.3)   CLEN( 15) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Skut. odveden�)        CPOS( 45, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dSkuOdvZak)               CPOS( 45, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Uzav�en� zak.)         CPOS( 57, 4.3)   CLEN( 12)
    TYPE(Text) NAME(dUzavZaka)                CPOS( 57, 5.3)   CLEN( 10) BGND( 13) GROUPS(clrGREY)

*   3.��dek
    TYPE(Text) CAPTION(Mn.pl�n. z obj.)       CPOS(  3, 6.4)   CLEN( 12)
    TYPE(Text) NAME(nMnozPlanO)               CPOS(  3, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Zad�no do v�r.)        CPOS( 17, 6.4)   CLEN( 13)
    TYPE(Text) NAME(nMnozZadan)               CPOS( 17, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn. vyroben�)          CPOS( 30, 6.4)   CLEN( 12)
    TYPE(Text) NAME(nMnozVyrob)               CPOS( 30, 7.4)   CLEN( 11) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Mn.fakturovan�)        CPOS( 43, 6.4)   CLEN( 13)
    TYPE(Text) NAME(nMnozVyrob)               CPOS( 43, 7.4)   CLEN( 13) BGND( 13) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Pl. pr�b�h)            CPOS( 63, 6.4)   CLEN( 10)
    TYPE(Text) NAME(NPLANPRUZA)               CPOS( 63, 7.4)   CLEN(  6) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Priorita)              CPOS( 75, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 75, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 85, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 85, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
  TYPE(End)

*    TYPE(TEXT) CAPTION(Polo�ky pohled�vky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(End)

* �hrady
  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(13,74) CAPTION(dod�vky) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(expedi�n� p��kaz) CPOS(.1,0) CLEN(114) FONT(5) PP(3) BGND(11) CTYPE(1)

    TYPE(GET) NAME(vyrzakit->ncisloEL)  FPOS(26,1.5) FLEN(12) FCAPTION(2. Expedi�n� list ��slo)  CPOS(1,1.5)  PP(2) FONT(5) CLEN(18) PUSH(pro_explsthd_sel)
    TYPE(PushButton) POS(39.4,1.4) SIZE(3,.9) EVENT(pro_explsthd_del) ICON1(120) ICON2(220) ATYPE(1) TIPTEXT(Odpojen� expedi�n�ho listu)

    TYPE(Static)  FPOS(44.5,1) SIZE(68.7,6.9) CAPTION(Dopravce)
      TYPE(Text)  CAPTION(Dopravce )          CPOS( 1,1.5) CLEN(11)
      TYPE(Text)  NAME(EXPLSTHD->NCISFIRDOP)  CPOS(12,1.5) CLEN(10) BGND(13)

      TYPE(Text)  CAPTION(I�o)                CPOS(24,1.5) CLEN( 4)
      TYPE(Text)  NAME(EXPLSTHD->NICODOP)     CPOS(28,1.5) CLEN(11) BGND(13)

      TYPE(Text)  CAPTION(Di�)                CPOS(41,1.5)
      TYPE(Text)  NAME(EXPLSTHD->CDICDOP)     CPOS(45,1.5) CLEN(10) BGND(13)

      TYPE(Text)  CAPTION(N�zev)              CPOS( 3,2.5) CLEN( 9)
      TYPE(Text)  NAME(EXPLSTHD->CNAZEVDOP)   CPOS(12,2.5) CLEN(27) BGND(13)
      TYPE(Text)  NAME(EXPLSTHD->CNAZEVDOP2)         CPOS(12,3.5) CLEN(27) BGND(13)

      TYPE(Text)  CAPTION(Ulice)              CPOS( 3,4.5)
      TYPE(Text)  NAME(EXPLSTHD->CULICEDOP)   CPOS(12,4.5) CLEN(27) BGND(13)

      TYPE(Text)  CAPTION(PS�)                CPOS( 3,5.5) CLEN( 5)
      TYPE(Text)  NAME(EXPLSTHD->CPSCDOP)     CPOS(12,5.5) CLEN(10) BGND(13)

      TYPE(Text)  NAME(EXPLSTHD->CSIDLODOP)   CPOS(24,5.5) CLEN(27) BGND(13)
   TYPE(End)
  TYPE(End)

* likvidace
*  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(25,62) CAPTION(likvidace) TABHEIGHT(.8) PRE(tabSelect)
*    TYPE(TEXT) CAPTION(Likvidace pohled�vky) CPOS(.1,0) CLEN(99.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(End)

* ��dky v�kazu dph
*  TYPE(TABPAGE) FPOS(.5,16) SIZE(114.5,9.7) TTYPE(3) OFFSET(37,50) CAPTION(��dky dph) TABHEIGHT(.8) PRE(tabSelect)
*    TYPE(TEXT) CAPTION(��dky v�kazu dph) CPOS(.1,0) CLEN(104.4) FONT(5) PP(3) BGND(11) CTYPE(1)
*  TYPE(END)

