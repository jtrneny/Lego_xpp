TYPE(drgForm) SIZE(100,25) DTYPE(10) TITLE(Generovan� doklady automat� _) FILE(UCETPOLA)  OBDOBI(UCT)
              

* Browser definition
  TYPE(DBrowse) FPOS(0,1.2) SIZE(100,17) FIELDS(UCT_ucetpola_INF():_UA:3   , ;
                                                UCT_ucetpola_OBD():OBD��:10, ;
                                                cDENIK:DE:5                , ;
                                                nDOKLAD:��sDokladu         , ;
                                                cUCETMD:SuAu_�             , ;
                                                nKCMD:K�_md                , ;
                                                nKCDAL:K�_dal              , ;
                                                cUCETDAL:SuAu_S            , ;
                                                cTEXT                        ) ;
                            ITEMSELECTED(itemSelected) CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(4) POPUPMENU(y)


  TYPE(ComboBox) NAME(UCT_ucetsys:CULOHA) FPOS(71,.1) FLEN(28.8);
                 VALUES(A:Generovan� automaty,AN:Nedokon�en� v�roba,AV:V�robn� re�ie,AS:Spr�vn� re�ie,AZ:Z�sobov� re�ie);
                 ITEMSELECTED(comboItemSelected)



* Info definition
  TYPE(Static) STYPE(2) SIZE(99.4,3) FPOS(0.3,18.2) RESIZE(y) 
* 1
    TYPE(Text) CAPTION(SuAu_�)           CPOS( 1,1) CLEN( 8)
    TYPE(Text) NAME(cUCETMD)             CPOS(12,1) CLEN(15) BGND(13) PP(2) 
    TYPE(Text) NAME(C_UCTOSN->cNAZ_UCT)  CPOS(29,1)
    TYPE(Text) CAPTION(Datum po��zen�)   CPOS(66,1)
    TYPE(Text) NAME(dDATPORIZ)           CPOS(82,1) CLEN(15) BGND(13) PP(2)     
* 2
    TYPE(Text) CAPTION(Mno�stv�)         CPOS( 1,2) CLEN( 8)
    TYPE(Text) NAME(nMNOZNAT)            CPOS(12,2) CLEN(15) BGND(13) PP(2) 
    TYPE(Text) NAME(cZKRATJEDN)          CPOS(28,2) CLEN( 4) 
    TYPE(Text) CAPTION(/)                CPOS(35,2) CLEN( 2)
    TYPE(Text) NAME(nMNOZNAT2)           CPOS(39,2) CLEN(15) BGND(13) PP(2) 
    TYPE(Text) NAME(cZKRATJED2)          CPOS(55,2) CLEN( 4) 
    TYPE(Text) CAPTION(Datum splatnosti) CPOS(66,2)
    TYPE(Text) NAME(dDATSPLAT)           CPOS(82,2) CLEN(15) BGND(13) PP(2)     
  TYPE(End)

* ns-ucetpola
    TYPE(Static) STYPE(9) SIZE(99.2,2.5) FPOS(.3,22.2) RESIZE(y)
      TYPE(Text) CAPTION(V�rSt�edisko) CPOS( 3, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL1)        CPOS( 3,1.2) CLEN(13) PP(2) BGND(13) 

      TYPE(Text) FCAPTION(V�robek)     CPOS(19, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL2)        CPOS(19,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Zak�zka)     CPOS(35, .1) CLEN( 8) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL3)        CPOS(35,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(V�rM�sto)    CPOS(51, .1) CLEN( 9) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL4)        CPOS(51,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(Stroj)       CPOS(67, .1) CLEN( 6) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL5)        CPOS(67,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Text) FCAPTION(V�rOperace)  CPOS(83, .1) CLEN(12) PP(3) BGND( 1) FONT(5)
      TYPE(Text) NAME(cNAZPOL6)        CPOS(83,1.2) CLEN(13)       BGND(13) PP(2)

      TYPE(Static) STYPE(12) SIZE(96,.1) FPOS(1,.4)
      TYPE(End)
    TYPE(End)

