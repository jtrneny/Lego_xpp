TYPE(drgForm) DTYPE(10) TITLE(V�robn� zak�zky-my) FILE(VYRZAK);
              SIZE(115,26) GUILOOK(Action:y,IconBar:y) ;
              CARGO(VYR_VyrZak_CRD)

TYPE(Action) CAPTION(~Zapu�t�n�)      EVENT( ZAK_ZAPUSTIT)  TIPTEXT(Zapu�t�n� v�robn� zak�zky do v�roby)
TYPE(Action) CAPTION(~Odveden�)       EVENT( ZAK_ODVEST)    TIPTEXT(Odveden� v�robn� zak�zky z v�roby)
TYPE(Action) CAPTION(~Ukon�en�)       EVENT( ZAK_UKONCIT)   TIPTEXT(Ukon�en� v�robn� zak�zky)
TYPE(Action) CAPTION(~Nov� otev�en�)  EVENT( ZAK_OPEN)      TIPTEXT(Znovuotev�en� v�robn� zak�zky)
*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Materi�l zak.)  EVENT( ZAK_MATERIAL)  TIPTEXT(��danky na materi�l)
TYPE(Action) CAPTION(~Kopie zak�zky)  EVENT( ZAK_COPY)      TIPTEXT(Kopie v�robn� zak�zky)
TYPE(Action) CAPTION(~Polo�ky zak�z.) EVENT( BTN_VYRZAKIT)  TIPTEXT(Polo�ky v�robn� zak�zky)
TYPE(Action) CAPTION(Ku~sovn�k pln�)  EVENT( KusTree_Full)  TIPTEXT(Zobrazen� pln�ho strukturovan�ho kusovn�ku )
TYPE(Action) CAPTION(~Generuj kusov.) EVENT( GEN_KUSOV)     TIPTEXT(Generov�n� zak�zkov�ho kusovn�ku )
TYPE(Action) CAPTION(Kus~ovn�k s op.) EVENT(VyrPol_OperTree)TIPTEXT(Zobrazen� struk. kusovn�ku s operacemi )
TYPE(Action) CAPTION(Mzdov� ~l�stky)  EVENT(ListHD_SCR)     TIPTEXT(Mzdov� l�stky k zak�zce )
*TYPE(Action) CAPTION(MatForZak)       EVENT(Vyr_MatForZak)  TIPTEXT(Material k zak�zce )
TYPE(Action) CAPTION(��e~tn� stav)    EVENT(UcetStav_SCR)   TIPTEXT(��etn� stav na zak�zce )
TYPE(Action) CAPTION(D~okumenty)      EVENT(VazDokum)       TIPTEXT(Dokumenty p�ipojen� k zak�zce)

TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) ATYPE(5)
TYPE(Action) CAPTION(~Kusovn�k pl_ex)   EVENT(kusTree_ex_Full)     TIPTEXT(Zobrazen� pln�ho strukturovan�ho kusovn�ku exTree)
TYPE(Action) CAPTION(~Kusovn�k sOper)   EVENT(operTree_ex)         TIPTEXT(Zobrazen� strukturovan�ho kusovn�ku s operacemi exTree)


*TYPE(TabPage) TTYPE(4) CAPTION(dle Zak�zek) OFFSET(1,82) PRE(tabSelect)

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
                       cnazPol3:��etn�Zak, ;  
                       nMnozPlanO:mn_pl�nZobj , ;
                       nMnozZadan:mn_doV�roby , ;
                       nMnozVyrob:mn_vyrobeno , ;
                       nMnozOdved:mn_odvedeno , ;
                       dOdvedZaka:Odved.PL   ,;
                       cBarva:Barva vn�j��   ,;
                       cBarva_2:Barva vnit�n�,;
                       nRozm_vys             ,;
                       nRozm_sir             ,;
                       nRozm_del             ,;
                       cRozm_MJ              ,;
                       nCisFirmy             ,;
                       cNazFirmy            ) ;
               FPOS(0.5,1.4) SIZE(115,14.5) CURSORMODE(3) PP(7) RESIZE(yy) POPUPMENU(yy);
               ITEMMARKED(ItemMarked)

TYPE(TabPage) TTYPE(4) CAPTION(dle Zak�zek) FPOS(1,16) SIZE( 113, 9.8) RESIZE(yx) OFFSET(1,82) PRE(tabSelect)
**  TYPE(Static) STYPE(13) SIZE(114.4,9) FPOS(0.3,15.9) RESIZE(yx)

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
    TYPE(Text) NAME(nMnozFakt)                CPOS( 43, 7.4)   CLEN( 13) BGND( 13) CTYPE(2) GROUPS(clrGREY)

    TYPE(Text) CAPTION(Pl. pr�b�h)            CPOS( 63, 6.4)   CLEN( 10)
    TYPE(Text) NAME(NPLANPRUZA)               CPOS( 63, 7.4)   CLEN(  6) BGND( 13) CTYPE(2) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Priorita)              CPOS( 75, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cPriorZaka)               CPOS( 75, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Stav zak.)             CPOS( 85, 6.4)   CLEN(  8)
    TYPE(Text) NAME(cStavZakaz)               CPOS( 85, 7.4)   CLEN(  8) BGND( 13) GROUPS(clrGREY)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

**  TYPE(End)
TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(dle Obj.p�ijat�ch) FPOS(1,16)  SIZE( 113, 9.8) RESIZE(yx) OFFSET(18,66) PRE(tabSelect) TIPTEXT(Polo�ky obj. p�ijat�ch realizovan� ve v�robn� zak�zce)
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


TYPE(TabPage) TTYPE(4) CAPTION( dle Parametr�) FPOS(1,16) SIZE( 113, 9.8) RESIZE(yx) OFFSET(34,50) PRE(tabSelect)
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
   TYPE(TEXT) CAPTION(V�robn� zak�zky)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(78, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 24) CAPTION(~Kompletn� seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)




*  TYPE(Text) CAPTION( Faktury vystaven� - b�n�)   CPOS( 0.5,9.6) CLEN( 114) FONT(5) CTYPE(1)

*  TYPE(Browse) FILE(FakVysIT) INDEXORD(5);
*               FIELDS(cUloha,nCisFak,nFaktMnoz,nCenZakCel,cNazZbo ) ;
*               SIZE(115,6) FPOS(0.1, 10.7) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) POPUPMENU(yn)

*  TYPE(Text) CAPTION( Faktury vystaven� - vnitropodnikov�)   CPOS( 0.5,16.8) CLEN( 114) FONT(5) CTYPE(1)

*  TYPE(Browse) FILE(FakVnpIT) INDEXORD(4);
*               FIELDS(cUloha,nCisFak,nFaktMnoz,nCenZakCel,cNazZbo ) ;
*               SIZE(115,6) FPOS(0.1, 17.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) POPUPMENU(yn)

*TYPE(End)