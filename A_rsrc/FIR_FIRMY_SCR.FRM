TYPE(drgForm) SIZE(110,25) DTYPE(10) TITLE(Seznam firem v evidenci ...) CARGO(FIR_firmy_crd)

  TYPE(Action) CAPTION(  ~NabVyst)      EVENT(pro_nabvyshd_scr)  TIPTEXT(seznam nabídek vystavených k firmì)    
  TYPE(Action) CAPTION(  ~ObjPøijaté)   EVENT(pro_objhead_scr)   TIPTEXT(seznam objednávek pøijatých k firmì)   
  TYPE(Action) CAPTION(  ~Zakázky)      EVENT()                  TIPTEXT(seznam zakázek k firmì)   
  TYPE(Action) CAPTION(  ~Pohledávky)   EVENT(fin_fakvyshd_scr)  TIPTEXT(seznam pohledávek k firmì)            
  TYPE(Action) CAPTION(  ~OdebPoložky)  EVENT(Cenik_Odberatele)    TIPTEXT(seznam odebíraných položek k firmì - zalistované zboží)            
  TYPE(Action) ATYPE(5)

  TYPE(Action) CAPTION(  ~NabPøijaté)   EVENT()                  TIPTEXT(seznam nabídek pøijatých k firmì)    
  TYPE(Action) CAPTION(  ~ObjVyst)      EVENT(nak_objvyshd_scr)  TIPTEXT(seznam objednávek vystavených k firmì) 
  TYPE(Action) CAPTION(  ~Závazky)      EVENT(fin_fakprihd_scr)  TIPTEXT(seznam závazkù k firmì)               
  TYPE(Action) CAPTION(  ~NakuPoložky)  EVENT(fir_dodzboz_ebro)  TIPTEXT(seznam nakupovaných položek k firmì)            
  TYPE(Action) ATYPE(5)

  TYPE(Action) CAPTION(  ~ProdCeníky)   EVENT(pro_procenhd_in)       TIPTEXT(prodejní - slevové ceníky firmy) 
  TYPE(Action) CAPTION(  ~AktProdCeny)  EVENT(pro_aktproceny_scr)    TIPTEXT(aktuální prodejní ceny k firmì) 

  TYPE(Action) ATYPE(5)
  TYPE(Action) CAPTION(  ~Firmy_BCD)     EVENT(fir_firmybcd_in)    TIPTEXT(pøidìlìná identifikace èárového kódu k firmì) 
  TYPE(Action) CAPTION(  Firmy_~ARES)    EVENT(fir_firmy_Ares_scr) TIPTEXT(administrativní registr ekonomických subjektù - ARES) ICON1(422) ATYPE(3)



TYPE(DBrowse) FPOS(.1,1.3) SIZE(110,12.3) FILE(FIRMY) ;
                                      FIELDS(M->is_Aktivni::2.8::2, ;
                                             NCISFIRMY:èísloFirmy , ;
                                             CNAZEV:Název firmy:37, ;
                                             NICO:ièo             , ;
                                             CDIC:diè             , ;
                                             CZKRATSTAT:stát      , ;      
                                             CPSC:psè             , ;
                                             CSIDLO:sídloFirmy    , ;
                                             CULICE:ulice           ) ;
                                      CURSORMODE(3) INDEXORD(1) PP(7) LFREEZE(1) RESIZE(yy)    ;
                                      PRE(SetFocus) ITEMMARKED(itemMarked) POPUPMENU(y)

*** QUICK FILTR ***
  TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(109.05,1.25) RESIZE(xn)
*    TYPE(TEXT) NAME( osoby->cJmenoRozl)            CPOS( 1.5, 0.6) FONT(5)  CLEN(30) 
*    TYPE(TEXT) CAPTION([ )                         CPOS(31.5, 0.6)          CLEN( 2)
*    TYPE(TEXT) NAME( osoby->ncisOsoby)             CPOS(33  , 0.6)          PICTURE(9999999) 
*    TYPE(TEXT) CAPTION(/)                          CPOS(39.5, 0.6)          CLEN( 2)
*    TYPE(TEXT) NAME( osoby->nosCisPrac)            CPOS(40  , 0.6)          PICTURE(99999) 
*    TYPE(TEXT) CAPTION(] )                         CPOS(45.5, 0.6)          CLEN( 2)

     TYPE(STATIC) STYPE(2) FPOS(70.5, .05) SIZE(37.3,1.0) RESIZE(nx)
       TYPE(PushButton) POS(.1,-0.28)   SIZE(260,22) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
     TYPE(END) 
  TYPE(END)
* 1 - ZÁKLADNÍ ÚDAJE
TYPE(TabPage) TTYPE(3) CAPTION(Základní informace) OFFSET(1,82) TABHEIGHT(.8) FPOS(1,13.8) SIZE(108,11) RESIZE(yx)
* P
  TYPE(Text) CAPTION(Èíslo firmy)   CPOS( 5,  .1)   
  TYPE(Text) NAME(FIRMY->NCISFIRMY) CPOS( 5, 1.1) CLEN(10) BGND(13) PP(2)
  TYPE(Text) CAPTION(Název firmy)   CPOS(18,  .1) 
  TYPE(Text) NAME(FIRMY->CNAZEV)    CPOS(18, 1.1) CLEN(25) BGND(13) PP(2)     
  TYPE(Text) CAPTION([)             CPOS( 5, 2.1) CLEN( 2) 
  TYPE(Text) NAME(FIRMY->CZASTUPCE) CPOS( 7, 2.1) CLEN(35) FONT(5) CTYPE(1)
  TYPE(Text) CAPTION(])             CPOS(43, 2.1) CLEN( 2) 

* L
  TYPE(Text) CAPTION(Sídlo firmy)   CPOS(50,  .1)   
  TYPE(Text) NAME(FIRMY->CULICE)    CPOS(50, 1.1) CLEN(38) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->cPSC)      CPOS(50, 2.1) CLEN(10) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->cSIDLO)    CPOS(63, 2.1) CLEN(25) BGND(13) PP(2)      
  TYPE(Static) STYPE(16) SIZE(108,1) FPOS(0,2.5) RESIZE(y)

* P
  TYPE(Text) CAPTION(Zamìøení)       CPOS( 5, 3.7)   
  TYPE(Text) NAME(FIRMY->CCINNOST)   CPOS(18, 3.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(ObchZástupce)   CPOS( 5, 4.7)   
  TYPE(Text) NAME(FIRMY->CZASTOBCH)  CPOS(18, 4.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(Telefon)        CPOS( 5, 5.7)   
  TYPE(Text) NAME(FIRMY->CTELEFON)   CPOS(18, 5.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->CTELEFON2)  CPOS(18, 6.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(Èíslo_Faxu)     CPOS( 5, 7.7)   
  TYPE(Text) NAME(FIRMY->CFAX)       CPOS(18, 7.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(Mobil)          CPOS( 5, 8.7)   
  TYPE(Text) NAME(FIRMY->CMOBILTEL)  CPOS(18, 8.7) CLEN(25) BGND(13) PP(2)
* L
  TYPE(Text) CAPTION(Stát)           CPOS(50, 3.7) 
  TYPE(Text) NAME(FIRMY->CZKRATSTAT) CPOS(63, 3.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(Oblast)         CPOS(50, 4.7) 
  TYPE(Text) NAME(FIRMY->NKLICOBL)   CPOS(63, 4.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(Ièo/DIè)        CPOS(50, 5.7) 
  TYPE(Text) NAME(FIRMY->NICO)       CPOS(63, 5.7) CLEN(10) BGND(13) PP(2)
  TYPE(Text) NAME(FIRMY->CDIC)       CPOS(74, 5.7) CLEN(14) BGND(13) PP(2)
  TYPE(Text) CAPTION(Po_BOX)         CPOS(50, 6.7) CLEN(10)
  TYPE(Text) NAME(FIRMY->CPOBOX)     CPOS(63, 6.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(ObchVztah)      CPOS(50, 7.7) 
  TYPE(Text) NAME(FIRMY->COBVZTH)    CPOS(63, 7.7) CLEN(25) BGND(13) PP(2)
  TYPE(Text) CAPTION(UživVztah)          CPOS(50, 8.7)
  TYPE(Text) NAME(FIRMY->CUZVZTH)    CPOS(63, 8.7) CLEN(25) BGND(13) PP(2)

  TYPE(TEXT) NAME(FIRMY->CZASTOBCH)  CPOS(70,3.7) CLEN(25) 
* FCAPTION(Obch_Zastupce)    CPOS( 2,10)

*    TYPE(MLE) NAME(FIRMY->mPOZNAMKA) FPOS(.5,21.2) SIZE(99,2.5) FONT(5) SCROLL(nn) PP(3)

  TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 2 - BILANÈNÍ PØEHLED
TYPE(TabPage) TTYPE(3) CAPTION(Bilanèní pøehled) OFFSET(16,68) TABHEIGHT(.8) FPOS(1,13.8) SIZE(108,11) RESIZE(yx)
   TYPE(Text)  CAPTION(Dodavatel)    CPOS( 3, .25) CLEN(15) FONT(5)
   TYPE(Text)  CAPTION(Odbìratel)    CPOS(50, .25) CLEN(15) FONT(5)
   TYPE(Static) STYPE(14) SIZE(108,.3) FPOS( .1,1.35) RESIZE(y) CTYPE(2) 
   TYPE(End)

* P
   TYPE(Text) CAPTION(Limit   závazkù)  CPOS( 3, 3)
   TYPE(Text) NAME(FIRMYFI->NLIMZAV)    CPOS(20, 3) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Suma    závazkù)  CPOS( 3, 4)
   TYPE(Text) NAME(FIRMYFI->NSUMZAV)    CPOS(20, 4) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Celkem  závazky)  CPOS( 3, 5)
   TYPE(Text) NAME(FIRMYFI->NSUMZAVCEL) CPOS(20, 5) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(DatPosl závazku)  CPOS( 3, 6)
   TYPE(Text) NAME(FIRMYFI->DDATPOSZAV) CPOS(20, 6) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Úvìr  ve  dnech)  CPOS( 3, 7)
   TYPE(Text) NAME(FIRMYFI->NUVERDNY)   CPOS(20, 7) CLEN(25) BGND(13) PP(2)

* L
   TYPE(Text) CAPTION(Limit pohledávek)  CPOS(50, 3)  
   TYPE(Text) NAME(FIRMYFI->NLIMPOH)     CPOS(68, 3) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Suma  pohledávek)  CPOS(50, 4) 
   TYPE(Text) NAME(FIRMYFI->NSUMPOH)     CPOS(68, 4) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Celkem pohledávek) CPOS(50, 5) 
   TYPE(Text) NAME(FIRMYFI->NSUMPOHCEL)  CPOS(68, 5) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(DatPos_pohledávky) CPOS(50, 6) 
   TYPE(Text) NAME(FIRMYFI->DDATPOSPOH)  CPOS(68, 6) CLEN(25) BGND(13) PP(2)

   TYPE(Text) CAPTION(Pracovní doba OD)  CPOS(50, 7.5) CLEN(14)
   TYPE(Text) NAME(FIRMYFI->cpracDoba1)  CPOS(68, 7.5) CLEN(34) BGND(13)
   TYPE(Text) CAPTION(Pracovní doba OD)  CPOS(50, 8.5) CLEN(14)
   TYPE(Text) NAME(FIRMYFI->cpracDoba2)  CPOS(68, 8.5) CLEN(34) BGND(13)

   TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 3 - FINANÈNÍ ÚDAJE
TYPE(TabPage) TTYPE(3) CAPTION(Finanèní  údaje) OFFSET(31,53) TABHEIGHT(.8) FPOS(1,13.8) SIZE(108,11) RESIZE(yx)
   TYPE(Text)  CAPTION(Dodavatel)    CPOS( 3, .25) CLEN(15) FONT(5)
   TYPE(Text)  CAPTION(Odbìratel)    CPOS(50, .25) CLEN(15) FONT(5)
   TYPE(Static) STYPE(14) SIZE(108,.3) FPOS( 0,1.35) RESIZE(y) CTYPE(2)
   TYPE(End)
* P
   TYPE(Text) CAPTION(Úèet dodavatele)  CPOS( 3, 2) 
   TYPE(Text) NAME(FIRMYFI->CUCT_DOD)   CPOS(20, 2) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SpecSymbol)       CPOS( 3, 3)
   TYPE(Text) NAME(FIRMYFI->CSPECSYMBO) CPOS(20, 3) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(ProcPenále)       CPOS( 3, 4)
   TYPE(Text) NAME(FIRMYFI->NPEN_DOD)   CPOS(20, 4) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SkontoDny)        CPOS( 3, 5)
   TYPE(Text) NAME(FIRMYFI->NSKNDNYDOD) CPOS(20, 5) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SkontoProceno  )  CPOS( 3, 6)
   TYPE(Text) NAME(FIRMYFI->NSKNPRCDOD) CPOS(20, 6) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Typ úhrady)       CPOS( 3, 7)
   TYPE(Text) NAME(FIRMYFI->CZKRTYPUHR) CPOS(20, 7) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Úvìr ve dnech)    CPOS( 3, 8)
   TYPE(Text) NAME(FIRMYFI->NUVERDNY)   CPOS(20, 8) CLEN(25) BGND(13) PP(2)
*     TYPE(Text) CAPTION(Limit   závazkù)  CPOS( 3,10) 
*     TYPE(Text) NAME(FIRMYFI->NLIMZAV)    CPOS(18,10) CLEN(25) BGND(11)
*     TYPE(Text) CAPTION(Suma závazkù)     CPOS( 3,11)
*     TYPE(Text) NAME(FIRMYFI->NSUMZAV)    CPOS(18,11) CLEN(25) BGND(11)
* L
   TYPE(Text) CAPTION(Úèet odbìratele)  CPOS(50, 2)
   TYPE(Text) NAME(FIRMYFI->CUCT_ODB)   CPOS(68, 2) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(KonstSynbol)      CPOS(50, 3)
   TYPE(Text) NAME(FIRMYFI->NKONSTSYMB) CPOS(68, 3) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(ProcPenále)       CPOS(50, 4)
   TYPE(Text) NAME(FIRMYFI->NPEN_ODB)   CPOS(68, 4) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SkontoDny)        CPOS(50, 5)
   TYPE(Text) NAME(FIRMYFI->NSKNDNYODB) CPOS(68, 5) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SkontoProceno)    CPOS(50, 6)
   TYPE(Text) NAME(FIRMYFI->NSKNPRCODB) CPOS(68, 6) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(Typ úhrady)       CPOS(50, 7)
   TYPE(Text) NAME(FIRMYFI->CZKRTYPUOD) CPOS(68, 7) CLEN(25) BGND(13) PP(2)
   TYPE(Text) CAPTION(SplatnostDny)     CPOS(50, 8)
   TYPE(Text) NAME(FIRMYFI->NSPLATNOST) CPOS(68, 8) CLEN(25) BGND(13) PP(2)
*     TYPE(Text) CAPTION(Lim_pohledávek)   CPOS( 3,20)
*     TYPE(Text) NAME(FIRMYFI->NLIMPOH)    CPOS(18,20) CLEN(25) BGND(11)
*     TYPE(Text) CAPTION(Suma pohledávek)  CPOS( 3,21)
*     TYPE(Text) NAME(FIRMYFI->NSUMPOH)    CPOS(18,21) CLEN(25) BGND(11)

   TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
TYPE(End)


* 4 - BANKOVNÍ ÚÈTY
TYPE(TabPage) TTYPE(3) CAPTION(Bankovní úèty) OFFSET(46,38) TABHEIGHT(.8) FPOS(1,13.8) SIZE(108,11) RESIZE(yx)
  TYPE(DBrowse) FPOS(0,0) SIZE(48,10) FILE(FIRMYUC) ;
                                      FIELDS(M->is_AktivniUc::2.4::2, ;
                                             CUCET:Èíslo úètu       , ;
                                             cBANK_NAZ:Název banky    ) ;
                                      CURSORMODE(3) PP(1) SCROLL(ny) RESIZE(yx)

 TYPE(Static) STYPE(1) SIZE(60,10) FPOS(48,0) RESIZE(ny)
   TYPE(Text) NAME(FIRMYUC->CBANK_NAZ)    CPOS(5,.4) CLEN(35) BGND(13) PP(2)

   TYPE(Static) STYPE(14) SIZE(60,.2) FPOS(0,1.7) RESIZE(yx) CTYPE(2)
   TYPE(End)

   TYPE(Text) CAPTION(Sídlo)            CPOS( 3,2.3)
   TYPE(Text) NAME(FIRMYUC->CBANK_ULI)  CPOS(18,2.3) CLEN(28) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMYUC->CBANK_PSC)  CPOS(18,3.3) CLEN( 6) BGND(13) PP(2)
   TYPE(Text) NAME(FIRMYUC->CBANK_SID)  CPOS(26,3.3) CLEN(20) BGND(13) PP(2)
   TYPE(Text) CAPTION(Telefon)          CPOS( 3,4.3) 
   TYPE(Text) NAME(FIRMYUC->CBANK_TEL)  CPOS(18,4.3) CLEN(18) BGND(13) PP(2)
   TYPE(Text) CAPTION(ÈísloFaxu)        CPOS( 3,5.3)
   TYPE(Text) NAME(FIRMYUC->CBANK_FAX)  CPOS(18,5.3) CLEN(18) BGND(13) PP(2)
   TYPE(Text) CAPTION(Modem)            CPOS( 3,6.3) CLEN(10)
   TYPE(Text) NAME(FIRMYUC->CBANK_MOD)  CPOS(18,6.3) CLEN(18) BGND(13) PP(2)
   TYPE(Text) CAPTION(OdpOsoba)         CPOS( 3,7.3) CLEN(10)
   TYPE(Text) NAME(FIRMYUC->CBANKODPO)  CPOS(18,7.3) CLEN(18) BGND(13) PP(2)
   TYPE(Text) CAPTION(Úèet Su_)         CPOS( 3,8.3)
   TYPE(Text) NAME(FIRMYUC->CUCET_UCT)  CPOS(18,8.3) CLEN(18) BGND(13) PP(2)

   TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
 TYPE(End)
TYPE(End)


* 5 - ZAØAZENÍ DO SKUPIN
TYPE(TabPage) TTYPE(3) CAPTION(Zaøazení do skupin) OFFSET(61,23) TABHEIGHT(.8) FPOS(1,13.8) SIZE(108,11) RESIZE(yx)

  TYPE(TEXT)     CAPTION(Aktivní skupiny) CPOS(.1,.01) CLEN(40) FONT(5) CTYPE(1) BGND(12) GROUPS(TEXT-5) 
  TYPE(DBrowse) FPOS(.1,1.1) SIZE(40,9) FILE(firmySK)                           ;
                                        FIELDS(M->setSkup:_:2.6::2            , ;
                                               czkr_skup:skup:4               , ;
                                               M->cnaz_Skup:název skupiny:48.2  ) ;
                                        CURSORMODE(3) PP(7) SCROLL(nn) RESIZE(nx)


  TYPE(TEXT)     CAPTION(Definované vazby) CPOS(40.1,.01) CLEN(67.8) FONT(5) CTYPE(1) BGND(12) GROUPS(TEXT-5) 
  TYPE(DBrowse) FPOS(40.2,1.1) SIZE(67.5,9) FILE(FIRMYVA)                           ;
                                        FIELDS(CZKR_SKVA:vaz:             , ;
                                               NCISFIRVA:èísloFirmy       , ;
                                               M->nazev_vaw:Název firmy:20, ;
                                               M->ico_vaw:ièo             , ;
                                               M->dic_vaw:diè             , ;
                                               M->psc_vaw:psè             , ;
                                               M->sidlo_vaw:sídloFirmy    , ;
                                               M->ulice_vaw:ulice           ) ;
                                         CURSORMODE(3) INDEXORD(1) PP(7) LFREEZE(1) RESIZE(yx)    ;
                                         PRE(SetFocus) POPUPMENU(n) SCROLL(nn) 

TYPE(End)