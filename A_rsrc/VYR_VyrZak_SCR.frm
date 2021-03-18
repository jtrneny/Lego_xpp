TYPE(drgForm) DTYPE(10) TITLE(Výrobní zakázky-my) FILE(VYRZAK);
              SIZE(115,26) GUILOOK(Action:y,IconBar:y) ;
              CARGO(VYR_VyrZak_CRD)

TYPE(Action) CAPTION(~Zapuštìní)      EVENT( ZAK_ZAPUSTIT)  TIPTEXT(Zapuštìní výrobní zakázky do výroby)
TYPE(Action) CAPTION(~Odvedení)       EVENT( ZAK_ODVEST)    TIPTEXT(Odvedení výrobní zakázky z výroby)
TYPE(Action) CAPTION(~Ukonèení)       EVENT( ZAK_UKONCIT)   TIPTEXT(Ukonèení výrobní zakázky)
TYPE(Action) CAPTION(~Nové otevøení)  EVENT( ZAK_OPEN)      TIPTEXT(Znovuotevøení výrobní zakázky)
*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Materiál zak.)  EVENT( ZAK_MATERIAL)  TIPTEXT(Žádanky na materiál)
TYPE(Action) CAPTION(~Kopie zakázky)  EVENT( ZAK_COPY)      TIPTEXT(Kopie výrobní zakázky)
TYPE(Action) CAPTION(~Položky zakáz.) EVENT( BTN_VYRZAKIT)  TIPTEXT(Položky výrobní zakázky)
TYPE(Action) CAPTION(Ku~sovník plný)  EVENT( KusTree_Full)  TIPTEXT(Zobrazení plného strukturovaného kusovníku )
TYPE(Action) CAPTION(~Generuj kusov.) EVENT( GEN_KUSOV)     TIPTEXT(Generování zakázkového kusovníku )
TYPE(Action) CAPTION(Kus~ovník s op.) EVENT(VyrPol_OperTree)TIPTEXT(Zobrazení struk. kusovníku s operacemi )
TYPE(Action) CAPTION(Mzdové ~lístky)  EVENT(ListHD_SCR)     TIPTEXT(Mzdové lístky k zakázce )
*TYPE(Action) CAPTION(MatForZak)       EVENT(Vyr_MatForZak)  TIPTEXT(Material k zakázce )
TYPE(Action) CAPTION(Úèe~tní stav)    EVENT(UcetStav_SCR)   TIPTEXT(Úèetní stav na zakázce )
TYPE(Action) CAPTION(D~okumenty)      EVENT(VazDokum)       TIPTEXT(Dokumenty pøipojené k zakázce)

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kusovník pl_ex)   EVENT(kusTree_ex_Full)     TIPTEXT(Zobrazení plného strukturovaného kusovníku exTree)
TYPE(Action) CAPTION(~Kusovník sOper)   EVENT(operTree_ex)         TIPTEXT(Zobrazení strukturovaného kusovníku s operacemi exTree)


*TYPE(TabPage) TTYPE(4) CAPTION(dle Zakázek) OFFSET(1,82) PRE(tabSelect)

  TYPE(DBrowse) FILE(VyrZak) INDEXORD(1);
               FIELDS( VyrZAKis_U():Uz:2.6::2     ,;
                       VYR_isKusov( 1; 'Vyrzak'):Ku:1::2 ,;
                       VYR_isPolOp( 1; 'Vyrzak'):Op:1::2 ,;
                       VYR_isZakIT():Po:1::2 ,;
                       CCISZAKAZ      ,;
                       CSTAVZAKAZ:Stav,;
                       CNAZEVZAK1::30 ,;
                       CVYRPOL        ,;
                       NVARCIS:Var.   ,;
                       cnazPol3:úèetníZak, ;  
                       nMnozPlanO:mn_plánZobj , ;
                       nMnozZadan:mn_doVýroby , ;
                       nMnozVyrob:mn_vyrobeno , ;
                       nMnozOdved:mn_odvedeno , ;
                       dOdvedZaka:Odved.PL   ,;
                       cBarva:Barva vnìjší   ,;
                       cBarva_2:Barva vnitøní,;
                       nRozm_vys             ,;
                       nRozm_sir             ,;
                       nRozm_del             ,;
                       cRozm_MJ              ,;
                       nCisFirmy             ,;
                       cNazFirmy            ) ;
               FPOS(0.5,1.4) SIZE(115,14.5) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(yy);
               ITEMMARKED(ItemMarked)

TYPE(TabPage) TTYPE(4) CAPTION(dle Zakázek) FPOS(1,16) SIZE( 113, 9.8) RESIZE(yx) OFFSET(1,82) PRE(tabSelect)
**  TYPE(Static) STYPE(13) SIZE(114.4,9) FPOS(0.3,15.9) RESIZE(yx)

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
    TYPE(Text) NAME(nMnozFakt)                CPOS( 43, 7.4)   CLEN( 13) BGND( 13) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Pl. prùbìh)            CPOS( 63, 6.4)   CLEN( 10)
    TYPE(Text) NAME(NPLANPRUZA)               CPOS( 63, 7.4)   CLEN(  6) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Priorita)              CPOS( 75, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 75, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 85, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 85, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

**  TYPE(End)
TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(dle Obj.pøijatých) FPOS(1,16)  SIZE( 113, 9.8) RESIZE(yx) OFFSET(18,66) PRE(tabSelect) TIPTEXT(Položky obj. pøijatých realizované ve výrobní zakázce)
  TYPE(STATIC) STYPE( 13) FPOS( .2, .1) SIZE(112.2, 8.6) RESIZE(YX)

    TYPE(DBrowse) FILE(ObjZak) INDEXORD(2);
                  FIELDS( cCislObINT,;
                          nCislPolOb,;
                          nMnPotVyrZ,;
                          nMnozDodVy,;
                          dTermPoVyr,;
                          cStavVazby ) ;
                  FPOS( -.3, .1) CURSORMODE(3) PP(7) RESIZE(yx)
  TYPE(End)
TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION( dle Parametrù) FPOS(1,16) SIZE( 113, 9.8) RESIZE(yx) OFFSET(34,50) PRE(tabSelect)
  TYPE(STATIC) STYPE( 13) FPOS( .2, .1) SIZE(112.2, 8.6) RESIZE(YX)

    TYPE(DBrowse) FILE(ZAKAPAR) INDEXORD(1) ;
                  FIELDS( nCisAtribZ  ,;
                          cAtrib      ,;
                          cHodnAtrC   ,;
                          nHodnAtrN   );
                  FPOS( -.3, .1) SCROLL(ny) CURSORMODE(3) PP(7 )RESIZE(yx)
  TYPE(End)
TYPE(End)

*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Výrobní zakázky)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(78, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 24) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)




*  TYPE(Text) CAPTION( Faktury vystavené - bìžné)   CPOS( 0.5,9.6) CLEN( 114) FONT(5) CTYPE(1)

*  TYPE(Browse) FILE(FakVysIT) INDEXORD(5);
*               FIELDS(cUloha,nCisFak,nFaktMnoz,nCenZakCel,cNazZbo ) ;
*               SIZE(115,6) FPOS(0.1, 10.7) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) POPUPMENU(yn)

*  TYPE(Text) CAPTION( Faktury vystavené - vnitropodnikové)   CPOS( 0.5,16.8) CLEN( 114) FONT(5) CTYPE(1)

*  TYPE(Browse) FILE(FakVnpIT) INDEXORD(4);
*               FIELDS(cUloha,nCisFak,nFaktMnoz,nCenZakCel,cNazZbo ) ;
*               SIZE(115,6) FPOS(0.1, 17.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) POPUPMENU(yn)

*TYPE(End)