2TYPE(drgForm) DTYPE(10) TITLE(Kontrolní hlášení k DPH ...) SIZE(110,27) ;
                                                           FILE(dphKohHDw) POST(postValidate)


  TYPE(TEXT) CAPTION(Kontrolní hlášení k DPH za daòové období) CLEN(35) CPOS(30, .3) PP(2) FONT(5)
  TYPE(GET)  NAME(M->obdobiDan)               FPOS(  65, .2) FLEN(10)  NOREVISION()        

*  TYPE(COMBOBOX) NAME(dphKohHDw->COBDOBIDAN)  FPOS(  65, .2) FLEN(10) VALUES(a,a,a,a) FCAPTION(Kontrolní hlášení k DPH za daòové období) CLEN(35) CPOS(30, .3) PP(2) FONT(5)
  TYPE(GET)      NAME(dphKohHDw->nrok)        FPOS(  80, .2) FLEN( 4) FCAPTION(rok)        CPOS( 76, .2) CLEN(4) NOREVISION()
  TYPE(GET)      NAME(dphKohHDw->nM)          FPOS(  91, .2) FLEN( 4) FCAPTION(mìsíc)      CPOS( 86, .2) CLEN(5) NOREVISION()
  TYPE(GET)      NAME(dphKohHDw->nQ)          FPOS( 104, .2) FLEN( 4) FCAPTION(ètvrtletí)  CPOS( 97, .2) CLEN(7) NOREVISION()        

TYPE(TEXT) CAPTION(Základní údaje o kontrolním hlášení)  CPOS( 2, 1.1) CLEN(25)

TYPE(Static) FPOS(.5,1.5) SIZE(108.5,5.6) CAPTION(Základní údaje o kontrolním hlášení) STYPE(12) RESIZE(y) CTYPE(2) NAME(mainFrame) 

   TYPE(COMBOBOX) NAME(dphKohHDw->ctypKonthl)  FPOS(  16, 1) FLEN(15) REF(ctypKONTHL) FCAPTION(Typ hlášení _)           CLEN(15) CPOS(  1, 1) PP(2) FONT(5)

   TYPE(TEXT)                                                                        CAPTION(Dùvody pro podání následného kontrolního hlášení zjištìny dne) CLEN(45) CPOS( 35, 1)
   TYPE(GET)      NAME(dphKohHDw->ddatmDuvod)  FPOS(  82, 1) FLEN(12) PUSH(CLICKDATE)

   TYPE(TEXT)                                                                        CAPTION(Èíslo jednací výzvy)      CLEN(16) CPOS( 35, 2)
   TYPE(GET)      NAME(dphKohHDw->cIdVyzvy)    FPOS(  64, 2) FLEN(30)

   TYPE(TEXT)                                                                        CAPTION(Rychlá odpovìï na výzvu)  CLEN(22) CPOS( 35, 3)
   TYPE(COMBOBOX) NAME(dphKohHDw->crychODPOV)  FPOS(  64, 3) FLEN(31) REF(crychODPOV)  
  
   TYPE(TEXT)                                                                        CAPTION(Hlášení OD_DO pouze (FO)) CLEN(22) CPOS( 35, 4.3)
   TYPE(GET)      NAME(dphKohHDw->dOD)         FPOS(  64, 4.3) FLEN(12) PUSH(CLICKDATE)
   TYPE(GET)      NAME(dphKohHDw->dDO)         FPOS(  83, 4.3) FLEN(12) PUSH(CLICKDATE)
TYPE(End)


* 1- ZÁKLADNÍ ÚDAJE
TYPE(TEXT) CAPTION(Identifikace plátce DPH)  CPOS( 2, 7.1) CLEN(18)

TYPE(TabPage) FPOS(0,7) SIZE(110,19.5) TTYPE(3) OFFSET( 0.8,89) CAPTION(hlavièka) PRE(tabSelect) EXT() SUBTABS(A1,A2)

******
* HLAVNI RAMEC *
  TYPE(STATIC) FPOS( .5, .5) SIZE(108.8,18.8  ) STYPE(9) RESIZE(yy) 

    TYPE(TEXT)                                                                         CAPTION(Název právnické osoby)  CPOS(  2, 1) CLEN(20) FONT(5)
    TYPE(GET)      NAME(dphKohHDw->cPRAOSNAZ)     FPOS( 45, 1) FLEN(50)
    TYPE(GET)      NAME(dphKohHDw->cPRAOSDOP)     FPOS( 45, 2) FLEN(50)

    TYPE(TEXT)                                                                         CAPTION(Fyzická sosoba)         CPOS(  2, 2) CLEN(20) FONT(5)
    TYPE(GET)      NAME(dphKohHDw->cFYZOSPRIJ)    FPOS(  2, 4) FLEN(20)                 FCAPTION(Pøíjmení)              CPOS(  2, 3)
    TYPE(GET)      NAME(dphKohHDw->cFYZOSJMEN)    FPOS( 25, 4) FLEN(20)                 FCAPTION(Jméno)                 CPOS( 25, 3)   
    TYPE(GET)      NAME(dphKohHDw->cTITUL)        FPOS( 48, 4) FLEN(10)                 FCAPTION(Titul)                 CPOS( 48, 3)


    TYPE(TEXT)  CAPTION(Sídlo právnické osoby / adresa místa pobytu fyzické osoby podle § 16 odst. 1 daòového øádu)    CPOS(  2, 5.1) CLEN(65)

    TYPE(STATIC) FPOS( .1, 5.5) SIZE(108.8,6.8  ) STYPE(9) RESIZE(yy)

      TYPE(Get)  NAME(dphKohHDw->csidlo)     FPOS( 2, 2) FLEN(30)                          FCAPTION(obec)               CPOS( 2, 1) CLEN(5)
      TYPE(Get)  NAME(dphKohHDw->CPSC)       FPOS(35, 2) FLEN(10)                          FCAPTION(PSÈ)                CPOS(35, 1)  PP(2)
      TYPE(Get)  NAME(dphKohHDw->CULICE)     FPOS( 2, 3) FLEN(30) 
      TYPE(Get)  NAME(dphKohHDw->cCP)        FPOS(46, 3) FLEN(17)                          FCAPTION(èíslo popisné)      CPOS(35, 3) CLEN(10)
      TYPE(Get)  NAME(dphKohHDw->cCOrient)   FPOS(81, 3) FLEN(10)                          FCAPTION(èíslo orientaèní)   CPOS(66, 3) CLEN(12)
      TYPE(TEXT) NAME(c_staty->cnazevstat)                                                                             CPOS( 2, 4) CLEN(31) BGND(13)    
      TYPE(Get)  NAME(dphKohHDw->cTelefon)   FPOS(46, 4) FLEN(17)                          FCAPTION(telefon)            CPOS(35, 4) CLEN(10)
      TYPE(Get)  NAME(dphKohHDw->cIdDatSchr) FPOS(81, 4) FLEN(10)                          FCAPTION(ID datové schránky) CPOS(66, 4) CLEN(15)
      TYPE(Get)  NAME(dphKohHDw->cMail)      FPOS(46, 5) FLEN(50)                          FCAPTION(mail)               CPOS(35, 5) CLEN(10)
    TYPE(END)


    TYPE(TEXT)  CAPTION(Jméno/a/ a pøíjmení / Název právnické osoby)    CPOS(  2, 12.1) CLEN(35)

    TYPE(STATIC) FPOS( .1, 12.5) SIZE(108.8, 5 ) STYPE(9) RESIZE(yy)
      
      TYPE(GET)  NAME(dphKohHDw->cODPOSJMEN)  FPOS( 2, 1) FLEN(14)
      TYPE(GET)  NAME(dphKohHDw->cODPOSPRIJ)  FPOS(18, 1) FLEN(25)
      TYPE(GET)  NAME(dphKohHDw->cODPOSPOST)  FPOS(45, 1) FLEN(25)

      TYPE(TEXT)                                                                        CAPTION(Vyhotoveno dne _)         CPOS(  2, 3) CLEN(15)  PP(2)
      TYPE(GET)  NAME(dphKohHDw->dsesDne)     FPOS(  18, 3) FLEN(14) PUSH(CLICKDATE)
      TYPE(GET)  NAME(dphKohHDw->cSESJMENO)   FPOS(  45, 3) FLEN(25)                     FCAPTION(sestavil)                CPOS( 35, 3) CLEN(10)  PP(2)
      TYPE(GET)  NAME(dphKohHDw->cSESTELEF)   FPOS(  85, 3) FLEN(17)                     FCAPTION(telefon)                 CPOS( 75, 3) CLEN(10)
    TYPE(END)


* POD PENÌŽNÍM ÚSTAVEM
*    TYPE(STATIC) FPOS(0.01,2) SIZE(40,.05) STYPE(9)  RESIZE(yx)
*    TYPE(END)

* POD KONEÈNÝM PØÍJEMCEM
*    TYPE(STATIC) FPOS(0.01,6.01) SIZE(40,.05) STYPE(9)  RESIZE(yx)
*    TYPE(End)

* STØEDNÍ POD STÁTEM
*    TYPE(STATIC) FPOS(0.01,8.9) SIZE(40,.05) STYPE(9)  RESIZE(yx)
*    TYPE(End)

* STØEDNÍ DÌLÍCÍ
*    TYPE(STATIC) FPOS(40,2.01) SIZE(.2,16.7) STYPE(9)  RESIZE(yx)
*    TYPE(End)

* SPODNI POD FORMA ÚHRADY
*    TYPE(STATIC) FPOS(0.01,13.8) SIZE(108.8,.05) STYPE(9)  RESIZE(yx)
*    TYPE(End)

* HLAVNI RAMEC *
  TYPE(End)
TYPE(End)


* 4 - POLOŽKY
TYPE(TabPage) FPOS(0,7) SIZE(110,19.5) TTYPE(3) OFFSET(10.5,79) CAPTION(položky) PRE(tabSelect) EXT()

* M->isedit_Parent::3::2           , ;

  TYPE(STATIC) FPOS( .5, .5) STYPE(9)  SIZE(109,18.7) CTYPE(3) PP(2) 

    TYPE(DBrowse) FPOS(-.7,7.4) SIZE(109,10.9)  FILE(dphKohITw)                           ;
                                                FIELDS(cOddilKoHl:oddíl                 , ;
                                                       nradek:èØádku                    , ;
                                                       cdic:diè_obìratele               , ;
                                                       cdanDoklad:daòDoklad:20          , ;
                                                       dvystFak:datUzp:10               , ;
                                                       nzaklD_dph:záklDanì              , ;
                                                       nzaklDan_2:záklDaò_1             , ;
                                                       nsazDan_2:Daò_1                  , ;
                                                       nzaklDan_1:záklDaò_2             , ;
                                                       nsazDan_1:Daò_2                  , ;
                                                       nzaklDan_3:záklDaò_3             , ;
                                                       nsazDan_3:Daò_3                  , ;
                                                       nkodplneni:kódPln                , ;   
                                                       cdenik:denik                     , ;
                                                       ndoklad:doklad                     ) ; 
                                                INDEXORD(2) CURSORMODE(3) PP(5) PP(7) SCROLL(yy) RESIZE(yy) 

 
* dphKohITw
     TYPE(COMBOBOX) NAME(dphKohITw->coddilKohl)  FPOS( 10, 1)  FLEN( 6)   FCAPTION(oddil)              CPOS( 1, 1)          VALUES(A.1,A.2,A.3,A.4,A.5,B.1,B.2,B.3)
     TYPE(GET)      NAME(dphKohITw->nradek)      FPOS( 25, 1)  FLEN( 4)   FCAPTION(èØádku)             CPOS(18, 1) CLEN(6)

     TYPE(GET)       NAME(dphKohITw->cdic)       FPOS( 48, 1 ) FLEN(13) FCAPTION(DIÈ odb/dod     ___)  CPOS(32, 1) CLEN(15) PUSH(firmyico_sel) 
     TYPE(GET)       NAME(dphKohITw->cdanDoklad) FPOS( 78, 1 ) FLEN(20) FCAPTION(daòDoklad  ___)       CPOS(63, 1) CLEN(12) PUSH()    

     TYPE(TEXT)     CAPTION(deník/ doklad)       CPOS( 73, 2)  CLEN(10)
       TYPE(Text)     CAPTION([)                   CPOS( 85, 2)  CLEN( 2) CTYPE(2)   
       TYPE(Text)     NAME(dphKohITw->cdenik)      CPOS( 87, 2)  CLEN( 2) FONT(5)
       TYPE(Text)     NAME(dphKohITw->ndoklad)     CPOS( 93, 2)  CLEN(11) FONT(5)
     TYPE(Text)       CAPTION(])                   CPOS(104, 2) CLEN( 2) CTYPE(2) 


     TYPE(TEXT)      CAPTION(daò z pøidané hodnoty)  CPOS(  3,2.1) CLEN(17)
     TYPE(GET)       NAME(dphKohITw->dvystFak)        FPOS( 18, 4 )  FLEN(13) FCAPTION(Datum uzp      ___)       CPOS( 3, 4) PUSH(CLICKDATE)
     TYPE(GET)       NAME(dphKohITw->nzaklD_dph)      FPOS( 18, 5 )  FLEN(13) FCAPTION(Bez danì        ___)      CPOS( 3, 5) 
*
     TYPE(TEXT)      CAPTION(Základ danì   ____)     CPOS( 35, 4) CLEN(15)
     TYPE(TEXT)      CAPTION(Odvod danì   ____)      CPOS( 35, 5) CLEN(15)
     TYPE(TEXT)      CAPTION(Kód plnìní     ____)    CPOS( 35, 6) CLEN(15)  
*
     TYPE(TEXT)     NAME(dphKohHDw->nprocDan_3)      CPOS( 53, 3) CLEN( 7) BGND(12)
     TYPE(GET)      NAME(dphKohITw->nzaklDan_3)      FPOS( 50, 4) FLEN(13) 
     TYPE(GET)      NAME(dphKohITw->nsazDan_3)       FPOS( 50, 5) FLEN(13) 
*
     TYPE(TEXT)     NAME(dphKohHDw->nprocDan_1)      CPOS( 69, 3) CLEN( 7) BGND(12)
     TYPE(GET)      NAME(dphKohITw->nzaklDan_1)      FPOS( 66, 4) FLEN(13) 
     TYPE(GET)      NAME(dphKohITw->nsazDan_1)       FPOS( 66, 5) FLEN(13) 
*
     TYPE(TEXT)     NAME(dphKohHDw->nprocDan_2)      CPOS( 85, 3) CLEN( 7) BGND(12)
     TYPE(GET)      NAME(dphKohITw->nzaklDan_2)      FPOS( 82, 4) FLEN(13) 
     TYPE(GET)      NAME(dphKohITw->nsazDan_2)       FPOS( 82, 5) FLEN(13) 

     TYPE(COMBOBOX) NAME(dphKohITw->ctypPreDan)      FPOS( 50, 6) FLEN(13.5) REF(CTYPPREDAN)  

     TYPE(STATIC) FPOS(0.4,2.4) SIZE(108.6,.2) STYPE(12)
     TYPE(End)


*    TYPE(STATIC) STYPE(12) FPOS( 1,4.8) SIZE(107, 3) CTYPE(2)                                      GROUPS(FAK)

*      TYPE(GET)      NAME(dphKohITw->nzaklD_dph)     FLEN(13)   CAPTION(záklDanì)
*      TYPE(GET)      NAME(dphKohITw->nzaklDan_1)     FLEN(13)   CAPTION(záklDaò_1)
*      TYPE(GET)      NAME(dphKohITw->nsazDan_1)      FLEN(13)   CAPTION(Daò_1)
*      TYPE(GET)      NAME(dphKohITw->nzaklDan_2)     FLEN(13)   CAPTION(záklDaò_2)
*      TYPE(GET)      NAME(dphKohITw->nsazDan_2)      FLEN(13)   CAPTION(Daò_2)
*      TYPE(GET)      NAME(dphKohITw->nzaklDan_3)     FLEN(13)   CAPTION(záklDaò_3)
*      TYPE(GET)      NAME(dphKohITw->nsazDan_3)      FLEN(13)   CAPTION(Daò_3)
*      TYPE(GET)      NAME(dphKohITw->nOsvOdDan)      FLEN(13)   CAPTION(osvPlnnìní)

*        TYPE(COMBOBOX) NAME(dphKohITw->ntypPreDan)     FLEN(15)   CAPTION(kódPlnìní)     REF(NTYPPREDAN)  
*        TYPE(TEXT)     NAME(dphKohITw->cdenik)         CLEN( 3)   CAPTION(deník)  
*        TYPE(TEXT)     NAME(dphKohITw->ndoklad)        CLEN(10)   CAPTION(doklad)  

* memoEdit
*    TYPE(PushButton) POS(105.5,10.15) SIZE(3,1) EVENT(memoEdit) ICON1(114) ICON2(214) ATYPE(1) CAPTION(fakvysitw->mpozzbo,0)

*  TYPE(End)
TYPE(End)


TYPE(Static) FPOS(36,25.5) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(16)
* 1 a 6
  TYPE(TEXT) CAPTION(Bez DpH )   CPOS( 1, 0.01) CLEN( 8)                                          
  TYPE(Text) NAME(M->infoVal_11) CPOS( 9, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           
  TYPE(Text) CAPTION(DPH )       CPOS(22, 0.01) CLEN( 5)                                          
  TYPE(Text) NAME(M->infoVal_12) CPOS(26, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)           
  TYPE(Text) CAPTION(Celkem )    CPOS(39, 0.01) CLEN( 8)                                          
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS( 46, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS( 60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  
TYPE(END)


TYPE(Static) FPOS(36,25.6) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(25)
* 2 a 5
  TYPE(TEXT) CAPTION(Celkem )            CPOS(44, 0.01) CLEN( 8)                                  
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(60, 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   
TYPE(END)

TYPE(Static) FPOS(36,25.7) SIZE(73.5,1.1) STYPE(8) RESIZE(y) CTYPE(2) GROUPS(34)
* 3 a 4
  TYPE(Text) CAPTION(Celkem v )          CPOS( 1, 0.01) CLEN( 9)                                  
*  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENZ) CPOS( 9.5, 0.01) CLEN( 5) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(34,SETFONT,8.Arial,GRA_CLR_RED)
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAHCEL) CPOS(13  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1) 
  TYPE(Text) CAPTION(Kurz )              CPOS(26  , 0.01) CLEN( 5)                                  
  TYPE(Text) NAME(M->KURZAHMEN)          CPOS(31  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)  GROUPS(34,SETFONT,8.Arial,GRA_CLR_RED)  
  TYPE(Text) CAPTION(Celkem v )          CPOS(44  , 0.01) CLEN( 9)                                  
*  TYPE(Text) NAME(FAKVYSHDw->cZKRATMENY) CPOS(52.5, 0.01) CLEN( 4) FONT(5) BGND(1) PP(3) CTYPE(1) 
*  TYPE(Text) NAME(FAKVYSHDw->nCENZAKCEL) CPOS(60  , 0.01) CLEN(13) FONT(5) BGND(1) PP(3) CTYPE(1)   
TYPE(END)


* neviditelné pomocné položky
* TYPE(TEXT) NAME(fakvysitw->cfile_iv)    FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nrecs_iv)    FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nnapocet)    FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nnapocetpp)  FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nvypsazdan)  FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->njeddan)     FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->ncountDL)    FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->ncislPolob)  FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nisParZal)   FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nnullDph)    FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nCeJPrZDZ)   FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->ncenaSzbo)   FPOS(0,0) CLEN(0)
*
* TYPE(TEXT) NAME(fakvysitw->nparZalFak)  FPOS(0,0) CLEN(0)
* TYPE(TEXT) NAME(fakvysitw->nparZahFak)  FPOS(0,0) CLEN(0)
*
* TYPE(MLE)  NAME(fakvysitw->mpozzbo)     FPOS(0,0) SIZE(0,0) READONLY(y)
* TYPE(MLE)  NAME(fakvysitw->mapolSest)   FPOS(0,0) SIZE(0,0) READONLY(y)
*
* TYPE(TEXT) NAME(fakvysitw->_nrecor)     FPOS(0,0) CLEN(0)


