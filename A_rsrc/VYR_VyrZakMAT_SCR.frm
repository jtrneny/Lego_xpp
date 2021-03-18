TYPE(drgForm) DTYPE(10) TITLE(Materiálové požadavky na zakázku) FILE(VYRZAK);
              SIZE(115,26) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)

TYPE(Action) CAPTION(~Materiál)        EVENT(ZAK_MATERIAL) TIPTEXT(Požadavky na materiál)
TYPE(Action) CAPTION(~Plán vs. skut.)  EVENT(ZAK_PLANSKUT) TIPTEXT(Porovnání plánu a skuteènosti)
TYPE(Action) CAPTION(~Zrušit materiál) EVENT(ZAK_MATERIAL_DEL) TIPTEXT(Zrušit požadavky na materiál)

* VYRZAK ... Seznam zakázek/ test GITu
  TYPE(DBrowse) FILE(VYRZAK) INDEXORD(1);
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
               FPOS(0.5,1.40) SIZE(115,13) CURSORMODE(3) PP(7) Resize(yy) SCROLL(ny) POPUPMENU(yy);
               ITEMMARKED( ItemMarked)

* OBJITEM - položky Objednávky pøijaté
  TYPE(TabPage) CAPTION( matPožadavky) FPOS(0, 14.2) SIZE(113,10.5) RESIZE(yx) TTYPE(3) OFFSET(1,81)

    TYPE(DBrowse) FILE(OBJITEM) INDEXORD(9);
                 FIELDS( cCisSklad:sklad              ,;
                         cSklPOL:sklPol               ,;
                         cNazZbo:Název zboží:40       ,;
                         nMnozObOdb:mn_požadované     ,;
                         nMnozPrDod:mn_pøijatéODdod   ,;
                         nMnozPlOdb:mn_plnìní          );
                 SIZE(114, 9.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yn)
  TYPE(End)

* OBJHEAD - údaje o matPožadavku
  TYPE(TabPage) CAPTION( info matPožadavku) FPOS(0, 14.2) SIZE(113,10.5) RESIZE(yx) TTYPE(3) OFFSET(19,63)
    TYPE(STATIC) FPOS(0.5,0.5) SIZE(40,8  ) STYPE(12)  RESIZE(yx) CTYPE(2)   
   
      TYPE(TEXT) CAPTION(2. Objednávka èíslo)    CPOS( 1,0.5) CLEN(17)                         FONT(5) 
      TYPE(TEXT) NAME(objhead->ndoklad)          CPOS(19,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(int_Èíslo objednávky)   CPOS( 3,1.5) CLEN(16) 
      TYPE(TEXT) NAME(objhead->ccislobint)       CPOS(19,1.5) CLEN(25)       BGND(13) 
 
*      TYPE(TEXT) CAPTION(èís_objOdbìratele)      CPOS( 3,2.5) CLEN(16) 
*      TYPE(TEXT) NAME(objhead->ccisobj)          CPOS(19,2.5) CLEN(25)       BGND(13) 

      TYPE(TEXT) CAPTION(Objednáno dne)          CPOS( 3,3.5) CLEN(13)
      TYPE(TEXT) NAME(objhead->ddatobj)          CPOS(19,3.5) CLEN(15)       BGND(13)

      TYPE(TEXT) CAPTION(Datum dodání)           CPOS( 3,4.5) CLEN(13)
      TYPE(TEXT) NAME(objhead->ddatDOodb)        CPOS(19,4.5) CLEN(15)       BGND(13)
    TYPE(End)

    TYPE(STATIC) FPOS(41.1,0.5) SIZE(70.9,8) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(3. Odbìratel )          CPOS( 4,0.5) CLEN(11)                         FONT(5) 
      TYPE(TEXT) NAME(objhead->ncisFirmy)        CPOS(20,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(stát)                   CPOS(33,0.5) CLEN( 6)
      TYPE(TEXT) NAME(firmy->czkratStat)         CPOS(40,0.5) CLEN(10)       BGND(13)

      TYPE(TEXT) CAPTION(Ièo)                    CPOS( 6,1.5) CLEN( 5)
      TYPE(TEXT) NAME(firmy->nico)               CPOS(20,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Diè)                    CPOS(33,1.5) CLEN( 5)
      TYPE(TEXT) NAME(firmy->cdic)               CPOS(40,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Název)                  CPOS( 6,2.5) CLEN( 6)
      TYPE(TEXT) NAME(firmy->cnazev)             CPOS(20,2.5) CLEN(30)       BGND(13) 
      TYPE(TEXT) NAME(firmy->cnazev2)            CPOS(20,3.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(Ulice)                  CPOS( 6,4.5) CLEN( 6)
      TYPE(TEXT) NAME(firmy->culice)             CPOS(20,4.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(PSè)                    CPOS( 6,5.5) CLEN( 6)
      TYPE(TEXT) NAME(firmy->cpsc)               CPOS(20,5.5) CLEN(10)       BGND(13) 
      TYPE(TEXT) NAME(M->cnazevStat)             CPOS(31,5.5) CLEN(28)       BGND(13)

      TYPE(Text) CAPTION(Cena)                   CPOS( 6,6.7) CLEN( 5)       FONT(5) 
      TYPE(Text) CAPTION(bez danì)               CPOS(11,6.7) CLEN( 8) 
      TYPE(Text) NAME(objhead->nkcsbdobj)        CPOS(20,6.7) CLEN(15)       BGND(13) CTYPE(2)
      TYPE(Text) CAPTION(s daní)                 CPOS(37,6.7) CLEN( 7)     
      TYPE(Text) NAME(objhead->nkcszdobj)        CPOS(44,6.7) CLEN(15)       BGND(13) CTYPE(2)
    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)


* VYRZAK - údaje o zakázce
  TYPE(TabPage) CAPTION( info Zakázka) FPOS(0, 14.2) SIZE(113,10.5) RESIZE(yx) TTYPE(3) OFFSET(37,45)
    TYPE(Static) STYPE(13) SIZE( 99,10) FPOS(0.5, 0.2) RESIZE(yx)
*     1.SL
      TYPE(Text)  CAPTION(Výrábìná položka)  CPOS( 1, 0.5) CLEN( 14)
      TYPE(TEXT)  NAME(cVyrPol)              CPOS(15, 0.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  NAME(VYRPOL->cNazev)       CPOS(31, 0.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Varianta)          CPOS( 1, 1.5) CLEN( 13)
      TYPE(TEXT)  NAME(nVarCis)              CPOS(15, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  NAME(VYRPOL->cVarPop)      CPOS(31, 1.5) CLEN( 30) BGND(13)
      TYPE(Text)  CAPTION(Èíslo objednávky)  CPOS( 1, 2.5) CLEN( 13)
      TYPE(TEXT)  NAME(cCisloObj)            CPOS(15, 2.5) CLEN( 40) BGND(13) FONT(5)

      TYPE(Text)  CAPTION(Založení zak.)     CPOS( 1, 3.5) CLEN( 12)
      TYPE(TEXT)  NAME(dZapis)               CPOS(15, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Plán. odvedení)    CPOS( 1, 4.5) CLEN( 12)
      TYPE(TEXT)  NAME(dOdvedZAKA)           CPOS(15, 4.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Èíslo plánu)       CPOS( 1, 5.5) CLEN( 12)
      TYPE(TEXT)  NAME(cCisPlan)             CPOS(15, 5.5) CLEN( 15) BGND(13) FONT(5)
      TYPE(Text)  CAPTION(Skut. odvedení)    CPOS( 1, 6.5) CLEN( 12)
      TYPE(TEXT)  NAME(dSkuOdvZak)           CPOS(15, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Uzavøení zak.)     CPOS( 1, 7.5) CLEN( 12)
      TYPE(TEXT)  NAME(dUzavZaka)            CPOS(15, 7.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

*     2.SL
      TYPE(Text)  CAPTION(Mn.plán. z objednávek) CPOS(63, 0.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozPlano)               CPOS(82, 0.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Zadáno do výroby)      CPOS(63, 1.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozZadan)               CPOS(82, 1.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Mn. vyrobené)          CPOS(63, 2.5) CLEN( 18)
      TYPE(TEXT)  NAME(nMnozVyrob)               CPOS(82, 2.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Plánovaný prùbìh)      CPOS(63, 3.5) CLEN( 18)
      TYPE(TEXT)  NAME(nPlanPruZa)               CPOS(82, 3.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

      TYPE(Text)  CAPTION(Priorita zakázky)      CPOS(63, 5.5) CLEN( 18)
      TYPE(TEXT)  NAME(cPriorZaka)               CPOS(82, 5.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)
      TYPE(Text)  CAPTION(Stav kapacit)          CPOS(63, 6.5) CLEN( 18)
      TYPE(TEXT)  NAME(cStavKapZa)               CPOS(82, 6.5) CLEN( 15) BGND(13) CTYPE(2) FONT(5)

    TYPE(End)
    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* VYRPOL - vyrábìné položky zakázky
  TYPE(TabPage) CAPTION( vyrPoložky) FPOS(0, 14.2) SIZE(113,10.5) RESIZE(yx) TTYPE(3) OFFSET(55,27)

    TYPE(DBrowse) FILE(vyrPol) INDEXORD(1)     ;
                  FIELDS( VYR_isKusov(1;'VyrPol'):ku:1::2, ;
                          VYR_isPolOp(1;'VyrPol'):op:1::2, ;
                          cvyrPol:vyrPol                 , ;
                          cnazev:názevPol:30             , ;
                          nvarCis:var                    , ;
                          cvarPop:popisVar:20            , ; 
                          ccisVyk:výkres:20              , ;
                          nmnZADva:mnPož                   ) ;
                  SIZE(114, 9.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(yn) 

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114.75,1.25) RESIZE(yn)
   TYPE(TEXT) CAPTION(Výrobní zakázky)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
    TYPE(STATIC) STYPE(2) FPOS(78, .02) SIZE(36, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(253, 23) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 

 TYPE(END)
