TYPE(drgForm) SIZE(110,26) DTYPE(10) TITLE(Úèetní položky dle všech deníkù _) OBDOBI(UCT)
              

* Browser definition
  TYPE(DBrowse) FPOS(0,1.2) SIZE(110,18.8) FILE(UCETPOL)                             ;
                                         FIELDS(uct_ucetpol_all_('uzav'):U:2.6::2, ;
                                                uct_ucetpol_all_('aktu'):A:2.6::2, ; 
                                                uct_ucetpol_all_('obdo'):období:7, ;
                                                cDENIK:deník:5                   , ;
                                                nDOKLAD:doklad                   , ;
                                                cUCETMD:SuAu_ø                   , ;
                                                nKCMD:Kè_md                      , ;
                                                nKCDAL:Kè_dal                    , ;
                                                cUCETDAL:SuAu_s                  , ;
                                                cTEXT:text dokladu:40                 ) ;
                                         ITEMSELECTED(itemSelected) CURSORMODE(3) PP(7) SCROLL(ny) INDEXORD(4) POPUPMENU(y)



*  TYPE(ComboBox) NAME(UCT_ucetsys:CULOHA) FPOS(1,.1) FLEN(28);
*                 VALUES(A:Generované automaty,AN:Nedokonèená výroba,AV:Výrobní režie,AS:Správní režie,AZ:Zásobová režie);
*                 ITEMSELECTED(comboItemSelected)



* Info definition
  TYPE(Static) STYPE(2) SIZE(109.4,3) FPOS(0.3,20) RESIZE(y) 
* 1
    TYPE(Text) CAPTION(SuAu_Ø)           CPOS( 1,1) CLEN( 8)
    TYPE(Text) NAME(UCETPOL->cUCETMD)    CPOS(12,1) CLEN(15) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(C_UCTOSN->cNAZ_UCT)  CPOS(29,1) BGND(13)
    TYPE(Text) CAPTION(Datum poøízení)   CPOS(76,1)
    TYPE(Text) NAME(UCETPOL->dDATPORIZ)  CPOS(92,1) CLEN(15) BGND(13) PP(2) CTYPE(2)    

* 2
    TYPE(Text) CAPTION(Množství)         CPOS( 1,2) CLEN( 8)
    TYPE(Text) NAME(UCETPOL->nMNOZNAT)   CPOS(12,2) CLEN(15) BGND(13) PP(2) CTYPE(2) 
    TYPE(Text) NAME(UCETPOL->cZKRATJEDN) CPOS(28,2) CLEN( 4) 
    TYPE(Text) CAPTION(/)                CPOS(32,2) CLEN( 2)
    TYPE(Text) NAME(UCETPOL->nMNOZNAT2)  CPOS(39,2) CLEN(15) BGND(13) PP(2) CTYPE(2)
    TYPE(Text) NAME(UCETPOL->cZKRATJED2) CPOS(55,2) CLEN( 4) 
    TYPE(Text) CAPTION(Datum splatnosti) CPOS(76,2)
    TYPE(Text) NAME(UCETPOL->dDATSPLAT)  CPOS(92,2) CLEN(15) BGND(13) PP(2) CTYPE(2)    
  TYPE(End)

* NS *
  TYPE(Static) STYPE(9) SIZE(109.4,1.7) FPOS(0.3,24) RESIZE(y) CTYPE(2)
    TYPE(Text) CAPTION(VýrStøedisko)     CPOS( 3, -.3)          PP(3) BGND(1) FONT(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL1)   CPOS( 3,  .4)                BGND(1)

    TYPE(Text) FCAPTION(Výrobek)         CPOS(19, -.3)          PP(3) BGND(1) FONS(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL2)   CPOS(19,  .4)                BGND(1)

    TYPE(Text) FCAPTION(Zakázka)         CPOS(35, -.3)          PP(3) BGND(1) FONS(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL3)   CPOS(35,  .4)                BGND(1)

    TYPE(Text) FCAPTION(Výrobní místo)   CPOS(51, -.3)          PP(3) BGND(1) FONS(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL4)   CPOS(51,  .4)                BGND(1)

    TYPE(Text) FCAPTION(Stroj)           CPOS(67, -.3)          PP(3) BGND(1) FONS(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL5)   CPOS(67,  .4)                BGND(1)

    TYPE(Text) FCAPTION(Výrobní operace) CPOS(83, -.3)          PP(3) BGND(1) FONS(5)
    TYPE(Text) NAME(UCETPOL->cNAZPOL6)   CPOS(83,  .4)                BGND(1)
  TYPE(End)


