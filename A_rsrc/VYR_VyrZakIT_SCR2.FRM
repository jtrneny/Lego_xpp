TYPE(drgForm) DTYPE(10) TITLE(Položky výrobních zakázek) SIZE(105,26) FILE(VYRZAKIT);
              GUILOOK(Action:y,IconBar:y,Menu:n);
              CARGO( VYR_VYRZAKIT_CRD);
              POST( POSTVALIDATE)

TYPE(Action) CAPTION(~info Zakázka)    EVENT( VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky )
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Zapuštìní)       EVENT( ZAKIT_ZAPUSTIT)  TIPTEXT(Zapuštìní položky zakázky )
TYPE(Action) CAPTION(~Ukonèení)        EVENT( ZAKIT_UKONCIT)   TIPTEXT(Ukonèení položky výrobní zakázky)
TYPE(Action) CAPTION(~Nové otevøení)   EVENT( ZAKIT_OPEN)      TIPTEXT(Znovuotevøení položky výrobní zakázky)
TYPE(Action) CAPTION(~Kopie pol.zak.)  EVENT( ZAKIT_COPY)      TIPTEXT(Kopie pložky výrobní zakázky)
TYPE(Action) CAPTION(~Kusovník plný)   EVENT( KusTree_Full)    TIPTEXT(Zobrazení plného strukturovaného kusovníku )
TYPE(Action) CAPTION(Kus~ovník s op.)  EVENT( VyrPol_OperTree) TIPTEXT(Zobrazení struk. kusovníku s operacemi )
TYPE(Action) CAPTION(Mzdové ~lístky)   EVENT( ListHD_SCR)      TIPTEXT(Mzdové lístky k položce zakázky )


* Seznam položek zakázky
  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1) ;
                FIELDS( VyrZAKITis_U():Uz:2.6::2     ,;
                        VYR_isKusov( 1; 'VyrzakIT'):Ku:1::2 ,;
                        VYR_isPolOp( 1; 'VyrzakIT'):Op:1::2 ,;
                        cCisZakaz     ,;
                        nOrdItem      ,;
                        cVyrobCisl    ,;
                        nMnozPlano:Množství   ,;
                        cBarva:Barva vnìjší   ,;
                        cBarva_2:Barva vnitøní,;
                        nRozm_vys    ,;
                        nRozm_sir    ,;
                        nRozm_del    ,;
                        cRozm_MJ     ,;
                        cCisZakazI   );
                SIZE(105,15.9)FPOS(0.3, 0.0) SCROLL(ny) CURSORMODE(3) PP(7) POPUPMENU(y) ;
                ITEMMARKED( itemMarked)

* INFO položky zakázky
  TYPE(TabPage) TTYPE(4) CAPTION(Základní údaje) FPOS(0.5,16) SIZE( 104.4, 9.9) RESIZE(yx) OFFSET(1,82) PRE(tabSelect) TIPTEXT(Základní údaje položky zakázky)
*   1.øádek
    TYPE(Text) CAPTION(Zakázka)               CPOS(  3, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cCisZakaz)                CPOS(  3, 1.1)   CLEN( 35) BGND( 13) FONT(5) GROUPS(clrYELLOW)
    TYPE(Text) CAPTION(Název zakázky)         CPOS( 40, 0.1)   CLEN( 15)
    TYPE(Text) NAME(cNazevZak1)               CPOS( 40, 1.1)   CLEN( 60) PICTURE(&X60) BGND( 13) GROUPS(clrYELLOW)
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
    TYPE(Text) NAME(nMnozFakt)                CPOS( 43, 7.4)   CLEN( 13) BGND( 13) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Pl. prùbìh)            CPOS( 63, 6.4)   CLEN( 10)
    TYPE(Text) NAME(NPLANPRUZA)               CPOS( 63, 7.4)   CLEN(  6) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Priorita)              CPOS( 75, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 75, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 85, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 85, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

  TYPE(End)


* Seznam operací k položce zakázky
  TYPE(TABPAGE) TTYPE(4) CAPTION(Seznam operací) FPOS(0.5,16) SIZE(104.4,9.9) RESIZE(yx) OFFSET(18,66) PRE(tabSelect) TIPTEXT( Operace k položce výrobní zakázky)
    TYPE(DBrowse) FILE(POLOPER) INDEXORD(7);
                  FIELDS( nVarOper         ,;
                          nCisOper:È.oper. ,;
                          nUkonOper        ,;
                          cOznOper         ,;
                          nPriprCas::12:@N 999 999.9999  ,;
                          nKusovCas::12:@N 999 999.9999  ,;
                          nKcNaOper:Cena operace:12:@N 999 999.999  ,;
                          OPERACE->cOznPrac,;
                          mPolOper:Popis operace:25,;
                          OPERACE->cNazOper,;
                          cCisZakazI:Položka zakázky );
                   SIZE(104.2, 9.1 ) FPOS(-0.5 , 0) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny) FOOTER(y)
  TYPE(END)