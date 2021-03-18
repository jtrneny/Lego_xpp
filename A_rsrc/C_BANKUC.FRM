TYPE(drgForm) DTYPE(2) TITLE(Seznam bankovních úètù ...) SIZE(100,21.5) FILE(C_BANKUC) CARGO(FIN_CBANKUC_CRD) ;
              POST(PostValidate)  CBLOAD(ONLOAD) GUILOOK(Action:n) 


TYPE(TabPage) CAPTION(Seznam) OFFSET(0,85) TABHEIGHT(.8) PRE(tabSelect) FPOS( .1, .5) SIZE(99.8,21) 

* Browser definition
  TYPE(DBrowse) SIZE(100,13.5) FILE(C_BANKUC)      ;
                FIELDS(M->isMain_uc::2.4::2    , ;
                       M->isDatKomE:e:2.4::2   , ;
                       M->isDatkomI:i:2.4::2   , ;   
                       CBANK_UCT:Èíslo úètu    , ;
                       CBANK_NAZ:Název banky:31, ;
                       DDATPOVYP:datumVýpisu   , ;
                       NPOSZUST:zùstatek úètu  , ;
                       CZKRATMENY:mìna         , ;
                       CUCET_UCT:suau_ø          ) ;
               CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y)

* Info definition
  TYPE(Static) STYPE(1) SIZE(98,6) FPOS(1,13.4) RESIZE(y)
* 1
      TYPE(Text) CAPTION(Bankovní úèet)    CPOS( 1,0)
      TYPE(Text) NAME(CBANK_UCT)           CPOS(17,0) CLEN(32) BGND(13) PP(2) 
      TYPE(Text) CAPTION(u banky)          CPOS(55,0)
      TYPE(Text) NAME(CBANK_NAZ)           CPOS(70,0) CLEN(25) BGND(13) PP(2) 
      TYPE(Text) NAME(CBANK_POB)           CPOS(70,1) CLEN(25) BGND(13) PP(2)  
* 3
      TYPE(Text) CAPTION(Adresa banky)      CPOS( 1,1)
      TYPE(Text) NAME(CBANK_ULI)            CPOS(17,1) CLEN(32) BGND(13) PP(2)
      TYPE(Text) NAME(CBANK_PSC)            CPOS(17,2) CLEN( 8) BGND(13) PP(2)
      TYPE(Text) NAME(CBANK_SID)            CPOS(28,2) FLEN(25) BGND(13) PP(2)

*      TYPE(Text) CAPTION(Sídlo banky)      CPOS( 1,1)
*      TYPE(Text) NAME(CBANK_PSC)           CPOS(17,1) CLEN( 6) BGND(13) PP(2) 
*      TYPE(Text) NAME(CBANK_SID)           CPOS(24,1) CLEN(25) BGND(13) PP(2) 
* 4
*      TYPE(Text) NAME(CBANK_ULI)           CPOS(24,2) CLEN(25) BGND(13) PP(2) 
      TYPE(Text) CAPTION(Odpovìdná osoba)  CPOS(55,2)
      TYPE(Text) NAME(CBANKODPO)           CPOS(70,2) CLEN(25) BGND(13) PP(2) 
* 6
      TYPE(Text) CAPTION(TELEFON)     CPOS(16,3.1)          PP(3) BGND(1) FONTS(5) CLEN(8)
      TYPE(Text) NAME(CBANK_TEL)      CPOS(16,4.2)                BGND(13)
      TYPE(Text) FCAPTION(FAX)        CPOS(45,3.1)          PP(3) BGND(1) FONTS(5) CLEN(4)
      TYPE(Text) NAME(CBANK_FAX)      CPOS(45,4.2)                BGND(13)
      TYPE(Text) FCAPTION(MODEM)      CPOS(70,3.1)          PP(3) BGND(1) FONTS(5) CLEN(7)
      TYPE(Text) NAME(CBANK_MOD)      CPOS(70,4.2)                BGND(13)

      TYPE(Static) STYPE(12) SIZE(96,2) FPOS(1,3.6) CTYPE(2)
      TYPE(End)
    TYPE(End)
TYPE(End)


TYPE(TabPage) CAPTION(Detail) OFFSET(14,70) TABHEIGHT(.8) PRE(tabSelect) FPOS( .1, .5) SIZE(99.8,21) 

   TYPE(Get) NAME(CBANK_UCT)  FPOS(18,1) FLEN(25) FCAPTION(Èíslo úètu ...)                CPOS( 1,1) PP(2)
     TYPE(TEXT) CAPTION([TXT]) CPOS(45,1) GROUPS(SETFONT,7.Arial CE)

   TYPE(Get) NAME(CBANK_UCE)  FPOS(18,2) FLEN(17) PP(2)
   TYPE(Get) NAME(cBANIS)     FPOS(39,2) FLEN( 4) PP(2)
     TYPE(TEXT) CAPTION(/)                    CPOS(37,2) CLEN( 2) GROUPS(SETFONT,9.Arial CE)
     TYPE(TEXT) CAPTION(el_formát /kód banky) CPOS( 2,2) CLEN(16) GROUPS(SETFONT,8.Arial CE) 

   TYPE(Get) NAME(CBANK_NAZ)  FPOS(70,1) FLEN(25) FCAPTION(u banky)                       CPOS(55,1) PP(2)
   TYPE(Get) NAME(CBANK_POB)  FPOS(70,2) FLEN(25) FCAPTION(  poboèka)                     CPOS(56,2) PP(2)
   TYPE(Get) NAME(CZKRATMENY) FPOS(70,3) FLEN( 8) FCAPTION(zkrMìny)                       CPOS(55,3) PP(2)
   TYPE(Get) NAME(CUCET_UCT)  FPOS(70,4) FLEN( 8) FCAPTION(SuAu_Ø)                        CPOS(55,4) PP(2)
   TYPE(CHECKBOX) NAME(LISMAIN)  FPOS(70,5) FLEN(13)  FCAPTION(Pøednastavit ...)          CPOS(55,5); 
                  VALUES(F:NE,T:ANO)


   TYPE(Get) NAME(CIBAN)     FPOS(18,3) FLEN(25) FCAPTION(International Bank Acount ...) CPOS( 1,3) PP(2)
     TYPE(TEXT) CAPTION([IBAN]) CPOS(45,3) GROUPS(SETFONT,7.Arial CE)

   TYPE(Get) NAME(CBIC)      FPOS(18,4) FLEN(13) FCAPTION(Bank Identifier Code ...)      CPOS( 1,4) PP(2)
     TYPE(TEXT) CAPTION([BIC/SWIFT])  CPOS(45,4) GROUPS(SETFONT,7.Arial CE)

   TYPE(Get) NAME(CVNBAN_UCT) FPOS(18,5.5) FLEN(25) FCAPTION(Vnitro bankÚèet ...)          CPOS( 1,5.5) 

   TYPE(Static) SIZE(98,5.5) FPOS(1,6.5) CTYPE(2)
     TYPE(Get)  NAME(CBANK_ULI)   FPOS(18,0.7) FLEN(35) FCAPTION(Adresa banky ...)           CPOS( 1, .7)                                                  PP(2)  
     TYPE(Get)  NAME(CBANK_PSC)   FPOS(18,1.7) FLEN( 8)                                      CPOS( 1,1.7) PP(2)
     TYPE(Get)  NAME(CBANK_SID)   FPOS(28,1.7) FLEN(25)                                                   PP(2)

*     TYPE(Get)  NAME(CBANK_PSC)   FPOS(18, .7) FLEN( 8) FCAPTION(Adresa banky ...)           CPOS( 1, .7) PP(2)
*     TYPE(Get)  NAME(CBANK_SID)   FPOS(28, .7) FLEN(25)                                                   PP(2)  
*     TYPE(Get)  NAME(CBANK_ULI)   FPOS(18,1.7) FLEN(35)                                                   PP(2)  
     TYPE(Get)  NAME(CBANKODPO)   FPOS(70,1.7) FLEN(25) FCAPTION(Zástupce banky ...)         CPOS(55,1.7) 

     TYPE(Text) CAPTION(TELEFON)  CPOS(16,3.1)          PP(3) BGND(1) FONTS(5) CLEN(8)
     TYPE(Text) FCAPTION(FAX)     CPOS(45,3.1)          PP(3) BGND(1) FONTS(5) CLEN(4)
     TYPE(Text) FCAPTION(MODEM)   CPOS(70,3.1)          PP(3) BGND(1) FONTS(5) CLEN(7)
     TYPE(Static) STYPE(9) SIZE(96,.1) FPOS(1,3.5)
     TYPE(End)

     TYPE(Get)  NAME(CBANK_TEL)   FPOS(16,4.2) FLEN(17) 
     TYPE(Get)  NAME(CBANK_FAX)   FPOS(45,4.2) FLEN(17) 
     TYPE(Get)  NAME(CBANK_MOD)   FPOS(70,4.2) FLEN(17) 
   TYPE(End)

   TYPE(Text) CAPTION(STAV ÚÈTU)  CPOS(11,12.7)          PP(3) BGND(1) FONTS(5) CLEN(9)
   TYPE(Text) CAPTION(ze dne)     CPOS(41,12.7)          PP(3) BGND(1) FONTS(5) CLEN(7)
   TYPE(Text) CAPTION(výpis)      CPOS(70,12.7)          PP(3) BGND(1) FONTS(5) CLEN(6)

   TYPE(Static) STYPE(12) SIZE(98,3) FPOS(1,12.5) CTYPE(2)
     TYPE(Text) NAME(NPOSZUST)    CPOS(10, 1.2) CLEN(25)    BGND(13)                                      PP(3)  
     TYPE(Text) NAME(DDATPOVYP)   CPOS(40, 1.2) CLEN(25)    BGND(13)                                      PP(3)  
     TYPE(Text) NAME(NCISPOVYP)   CPOS(69, 1.2) CLEN(25)    BGND(13)                                      PP(3)  
   TYPE(End)


   TYPE(TEXT) CAPTION(Export)                            CPOS( 1  , 16.2) CLEN( 6.5) GROUPS(SETFONT,10.Arial CE)
   TYPE(TEXT) CAPTION(-TUZEMSKÁ    komunikace s bankou ) CPOS( 7.4, 16.2) CLEN(26) 


   TYPE(COMBOBOX) NAME(c_bankuc->CIDDatKomE) FPOS(34, 16.2) FLEN(50) VALUES(a,a,a) 
   TYPE(PushButton) CAPTION(     Nastavení)   POS(86, 16.2) SIZE(13,1.1) EVENT(set_datkomE) ICON1(142) ATYPE(3)  

   TYPE(COMBOBOX) NAME(c_bankuc->CIDDatKozE) FPOS(34, 17.2) FLEN(50) VALUES(a,a,a) FCAPTION(-ZAHRANIÈNÍ komunikace s bankou ) CPOS( 7, 17.2 ) 
   TYPE(PushButton) CAPTION(     Nastavení)   POS(86, 17.2) SIZE(13,1.1) EVENT(set_datkozE) ICON1(142) ATYPE(3)  

   TYPE(TEXT) CAPTION(Import)                            CPOS( 1  , 18.6) CLEN( 6.5) GROUPS(SETFONT,10.Arial CE)

   TYPE(COMBOBOX) NAME(c_bankuc->CIDDatKomI) FPOS(34, 18.6) FLEN(50) VALUES(a,a,a) FCAPTION(-Datová komunikace s bankou ) CPOS( 7, 18.6 ) 
   TYPE(PushButton) CAPTION(     Nastavení)       POS(86,18.6) SIZE(13,1.1) EVENT(set_datkomI) ICON1(142) ATYPE(3)  

*
*
   TYPE(MLE)  NAME(mdefin_kom) FPOS(0,0) SIZE(0,0) 

TYPE(End)
