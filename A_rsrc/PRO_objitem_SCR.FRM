TYPE(drgForm) DTYPE(10) TITLE(Seznam objednávek pøijatých) SIZE(110,26.5) CARGO(PRO_objhead_IN) ;
                                                PRINTFILES(objitem:ndoklad=ndoklad) 

    TYPE(DBrowse) FPOS(0,0) SIZE(109.6,16.8) FILE(OBJITEM)                  ;
                                             FIELDS(ndoklad:èísloobj       , ;
                                                    ncislpolob:pol         , ;
                                                    csklpol:sklPol         , ;              
                                                    cnazzbo:název zboží:34 , ;
                                                    nmnozobodb:mn_objednáno, ;
                                                    nmnozpoodb:mn_potvrzeno, ;  
                                                    nmnozplodb:mn_dodáno   , ;
                                                    ncenazakl:cenaMj       , ;
                                                    nhodnslev:slevaZákl    , ;
                                                    nkcsbdobj:celkBDanì    , ;
                                                    nkcszdobj:ceklSDaní      ) ;
                                             CURSORMODE(3) PP(7) INDEXORD(4) SCROLL(yy) ITEMMARKED(itemMarked) RESIZE(x) POPUPMENU(y)   

*
**
* info
  TYPE(TABPAGE) FPOS(.5,17) SIZE(109.5,9.2) TTYPE(3) OFFSET(1,86) CAPTION(info) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(STATIC) FPOS(0.01,0.1) SIZE(40,8  ) STYPE(12)  RESIZE(yx) CTYPE(2)   
   
      TYPE(TEXT) CAPTION(2. Objednávka èíslo)    CPOS( 1,0.5) CLEN(17)                         FONT(5) 
      TYPE(TEXT) NAME(objhead->ndoklad)          CPOS(19,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(int_Èíslo objednávky)   CPOS( 3,1.5) CLEN(16) 
      TYPE(TEXT) NAME(objhead->ccislobint)       CPOS(19,1.5) CLEN(25)       BGND(13) 
 
      TYPE(TEXT) CAPTION(èís_objOdbìratele)      CPOS( 3,2.5) CLEN(16) 
      TYPE(TEXT) NAME(objhead->ccisobj)          CPOS(19,2.5) CLEN(25)       BGND(13) 

      TYPE(TEXT) CAPTION(Objednáno dne)          CPOS( 3,3.5) CLEN(13)
      TYPE(TEXT) NAME(objhead->ddatobj)          CPOS(19,3.5) CLEN(15)       BGND(13)

      TYPE(STATIC) FPOS(0.01,4.7) SIZE(40,3.5) STYPE(9)  RESIZE(yx)
        TYPE(TEXT) NAME(M->cnazMeny)             CPOS( 4,0.5) CLEN(32)       BGND(13)

       TYPE(TEXT) CAPTION(Kurz/Pøep)            CPOS( 4,1.6) CLEN( 8)
       TYPE(TEXT) NAME(objhead->nkurZahMen)     CPOS(13,1.6) CLEN(12)       BGND(13) CTYPE(2)

       TYPE(TEXT) CAPTION(/)                    CPOS(25,1.6) CLEN( 2)
       TYPE(TEXT) NAME(objhead->nmnozPrep)      CPOS(28,1.6) CLEN( 8)       BGND(13) CTYPE(2)    
      TYPE(End)
    TYPE(End)

    TYPE(STATIC) FPOS(40.1,0.1) SIZE(68.9,8) STYPE(12)  RESIZE(yx) CTYPE(2)   
      TYPE(TEXT) CAPTION(3. Odbìratel )          CPOS( 4,0.5) CLEN(11)                         FONT(5) 
      TYPE(TEXT) NAME(objhead->ncisFirmy)        CPOS(20,0.5) CLEN(10)       BGND(13) CTYPE(2)

      TYPE(TEXT) CAPTION(stát)                   CPOS(33,0.5) CLEN( 6)
      TYPE(TEXT) NAME(objhead->czkratStat)       CPOS(40,0.5) CLEN(10)       BGND(13)

      TYPE(TEXT) CAPTION(Ièo)                    CPOS( 6,1.5) CLEN( 5)
      TYPE(TEXT) NAME(objhead->nico)             CPOS(20,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Diè)                    CPOS(33,1.5) CLEN( 5)
      TYPE(TEXT) NAME(objhead->cdic)             CPOS(40,1.5) CLEN(10)       BGND(13) 

      TYPE(TEXT) CAPTION(Název)                  CPOS( 6,2.5) CLEN( 6)
      TYPE(TEXT) NAME(objhead->cnazev)           CPOS(20,2.5) CLEN(30)       BGND(13) 

      TYPE(TEXT) NAME(objhead->cnazev2)          CPOS(20,3.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(Ulice)                  CPOS( 6,4.5) CLEN( 6)
      TYPE(TEXT) NAME(objhead->culice)           CPOS(20,4.5) CLEN(30)       BGND(13)

      TYPE(TEXT) CAPTION(PSè)                    CPOS( 6,5.5) CLEN( 6)
      TYPE(TEXT) NAME(objhead->cpsc)             CPOS(20,5.5) CLEN(10)       BGND(13) 
      TYPE(TEXT) NAME(M->cnazevStat)             CPOS(31,5.5) CLEN(28)       BGND(13)

      TYPE(Text) CAPTION(Cena)                   CPOS( 6,6.7) CLEN( 5)       FONT(5) 
      TYPE(Text) CAPTION(bez danì)               CPOS(11,6.7) CLEN( 8) 
      TYPE(Text) NAME(objhead->nkcsbdobj)        CPOS(20,6.7) CLEN(15)       BGND(13) CTYPE(2)
      TYPE(Text) CAPTION(s daní)                 CPOS(37,6.7) CLEN( 7)     
      TYPE(Text) NAME(objhead->nkcszdobj)        CPOS(44,6.7) CLEN(15)       BGND(13) CTYPE(2)
    TYPE(End)

    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)
  TYPE(End)

* položky faktur vystavených
  TYPE(TABPAGE) FPOS(.5,17) SIZE(109.5,9.2) TTYPE(3) OFFSET(13,74) CAPTION(polFak) TABHEIGHT(.8) PRE(tabSelect)
    TYPE(TEXT) CAPTION(položky faktur vystavených) CPOS(.1,0) CLEN(109.4) FONT(5) PP(3) BGND(12) CTYPE(1)
    TYPE(DBrowse) FPOS(0,1) SIZE(109,7) FILE(FAKVYSIT)                 ;
                                           FIELDS(nCISFAK:èísFak:10     , ;
                                                  cNAZZBO:název zboží:35, ;
                                                  cSKLPOL:sklPol        , ;
                                                  nFAKTMNOZ:množFak:13  , ;
                                                  cZKRATJEDN:jed:3      , ;
                                                  nCeCPrKDZ:cenaCelk    , ;
                                                  nRADVYKDPH:rvDph      , ;
                                                  cCISZAKAZI:výrZakázka , ;
                                                  cUCETSKUP:UèSk          ) ;
                                           CURSORMODE(3) PP(7) INDEXORD(4) RESIZE(x)
  TYPE(End)