TYPE(drgForm) DTYPE(10) TITLE(Pøehled kontrol elektrického náøadí ...) SIZE(100,25) FILE(ZMEELNAR) 

* CARGO(DIM_elnardim_CRD)
* TYPE(Action) CAPTION(~protokol ELn) EVENT(elnardim_crd) TIPTEXT(Protokoly o mìøení)


* Browser definition
  TYPE(DBrowse) FILE(ZMEELNAR) SIZE(100,16)                  ;
                FIELDS(ninvCISdim:invÈíslo                 , ;
                       M->nazevDim:název náøadí:30         , ;
                       ncisKontr:èMìø                      , ;                                             
                       elnarDim->cIDcislo:ID_èíslo         , ;
                       ddatPOSkon:dat_posKon:10            , ;  
                       ddatDALkon:dat_dalKon:10            , ; 
                       M->jmenoMaj:jméno majitele:30         ) ;     
                ITEMMARKED(ItemMarked) CURSORMODE(3) PP(7) POPUPMENU(y)


* Info definition
  TYPE(Static) STYPE(13) SIZE(98,8) FPOS(1,16.5) RESIZE(y) CTYPE(2)
* 1
    TYPE(Text) CAPTION(sestava)           CPOS( 1, .2)  
    TYPE(Text) NAME(zmeElnar->csestave)   CPOS(10, .2) CLEN(2)
    TYPE(Text) NAME(c_typses->cnazTYPses) CPOS(13, .2) CLEN(25)
* 2
    TYPE(Text) CAPTION(pøívod)            CPOS( 1, 1 )  
    TYPE(Text) NAME(zmeElnar->ndelkaVM)   CPOS(10, 1 ) 
    TYPE(Text) CAPTION((m))               CPOS(16, 1 ) CLEN(5)  

    TYPE(Text) CAPTION(materiál pøívodu)  CPOS(22, 1 ) CLEN(12) 
    TYPE(Text) NAME(zmeElnar->csitPrivod) CPOS(35, 1 ) 

    TYPE(Text) CAPTION(odpor vodièe)      CPOS(40, 1 ) CLEN(12) 
    TYPE(Text) NAME(zmeElnar->nodporVod)  CPOS(53, 1 ) 
    TYPE(Text) CAPTION((ohm))             CPOS(60, 1 ) CLEN(5)  
* 3
    TYPE(Text) CAPTION(zákl_izolace)      CPOS(15, 2 ) CLEN( 9) 
    TYPE(Text) CAPTION(pøíd_izolace)      CPOS(30, 2 ) CLEN( 9) 
    TYPE(Text) CAPTION(zesíl_izolace)     CPOS(45, 2 ) CLEN(10) 
    TYPE(Text) CAPTION(kontrola_Dne)      CPOS(60, 2 ) CLEN(11) 
    TYPE(Text) CAPTION(/kontroloval)      CPOS(72, 2 ) CLEN(10) 

    TYPE(Static) STYPE(12) SIZE(101,.1) FPOS(0,2.5) RESIZE(y)
    TYPE(End)

* 4
    TYPE(Text) CAPTION(izolaèní odpor)    CPOS( 1, 3  ) CLEN(12) 
    TYPE(Text) NAME(zmeElnar->nzaklIzol)  CPOS(15, 3  ) 
    TYPE(Text) NAME(zmeElnar->npridIzol)  CPOS(30, 3  ) 
    TYPE(Text) NAME(zmeElnar->nzesiIzol)  CPOS(45, 3  ) 
    TYPE(Text) NAME(zmeElnar->ddatPOSkon) CPOS(60, 3  ) 
    TYPE(Text) NAME(zmeElnar->copravil)   CPOS(72, 3  ) 
* 5
    TYPE(Text) CAPTION(metodaNáhrMìø)     CPOS( 1, 3.8 ) CLEN(12)
    TYPE(Text) NAME(zmeElnar->cmetodaMer) CPOS(15, 3.8 ) 
    TYPE(Text) NAME(c_typmer->cnazTYPmer) CPOS(20, 3.8 ) CLEN(25)

    TYPE(Text) CAPTION(proud)             CPOS(48, 3.8 ) CLEN(12)
    TYPE(Text) NAME(zmeElnar->nproudMa)   CPOS(61, 3.8 ) 
    TYPE(Text) CAPTION((mA))              CPOS(67, 3.8 ) CLEN(5)  
* 6
    TYPE(Text) CAPTION(popisKontroly)     CPOS( 1, 4.6 ) CLEN(12)
    TYPE(Text) NAME(zmeElnar->cpopisKon1) CPOS(15, 4.6 ) 
* 7
    TYPE(Text) NAME(zmeElnar->cpopisKon2) CPOS(15, 5.4 ) 
* 8 
    TYPE(Text) NAME(zmeElnar->cpopisKon3) CPOS(15, 6.2 ) 
* 9
    TYPE(Text) CAPTION(celkHodnocení)     CPOS( 1, 7   ) CLEN(12)
    TYPE(Text) NAME(zmeElnar->ccelkHodno) CPOS(15, 7   ) CLEN( 3)
    TYPE(Text) NAME(c_typhod->cnazTYPhod) CPOS(20, 7   ) CLEN(25)

    TYPE(Text) CAPTION(dalšíKontr)        CPOS(48, 7   ) CLEN(12)
    TYPE(Text) NAME(zmeElnar->ddatDALkon) CPOS(61, 7   ) CLEN(10)
  TYPE(End)


