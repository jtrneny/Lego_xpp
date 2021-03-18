TYPE(drgForm) DTYPE(10) TITLE(Úèetní osnova ...) SIZE(100,25) ;
              GUILOOK(Action:n)  ;
              POST(postValidate) ;
              CBSAVE(onSave)

* ANALYTIKY
TYPE(TabPage) SIZE(65,24.7) CAPTION(Analytiky) OFFSET(1,82) RESIZE(xy)

  TYPE(DBrowse) SIZE(65,12) FILE(C_UCTOSN) ;
                            FIELDS(cUCET:ÚÈET          , ;
                                   cNAZ_UCT:Název úètu , ;
                                   cUSERABB:Uživatel:14, ;
                                   dDATZMENY:DatZmìny    ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
         
  TYPE(DBrowse) FPOS(0,15.4) SIZE(65, 8) FILE(C_SKUPUC)                           ;
                                         FIELDS(cSKUPUCT:SKUPINA                , ;
                                                cNAZSKUPUC:Název skupiny        , ;  
                                                cUSERABB:Uživatel:14            , ;
                                                dDATZMENY:DatZmìny                ) CURSORMODE(3) SCROLL(ny) PP(5) RESIZE(nn)
** støední èást **
 TYPE(Static) FPOS(.5,12.5) SIZE(63.5,2.5) STYPE(13) CTYPE(2) GROUPS(1) RESIZE(yx)
    TYPE(GET)  NAME(C_UCTOSN->cUCET)      FPOS( 1, 1.2) FLEN( 8) FCAPTION(Úèet)          CPOS( 1, .1)                     GROUPS(1)
    TYPE(GET)  NAME(C_UCTOSN->cNAZ_UCT)   FPOS(11, 1.2) FLEN(34) FCAPTION(Název úètu)    CPOS(11, .1) POST(postLastField) GROUPS(1)
  TYPE(End)

 TYPE(Static) FPOS(.5,12.5) SIZE(63.5,2.5) STYPE(13) CTYPE(2) GROUPS(2) RESIZE(yx)
    TYPE(GET)  NAME(C_SKUPUC->cSKUPUCT)   FPOS( 1, 1.2) FLEN( 8) FCAPTION(Skupina )      CPOS( 1, .1)                     GROUPS(2) 
    TYPE(GET)  NAME(C_SKUPUC->cNAZSKUPUC) FPOS(11, 1.2) FLEN(34) FCAPTION(Název skupiny) CPOS(11, .1) POST(postLastField) GROUPS(2)
  TYPE(End)

TYPE(End)

** SYNTETIKY
TYPE(TabPage) SIZE(65,24.7) CAPTION(Syntetiky) OFFSET(17,66) RESIZE(xy)

  TYPE(DBrowse) SIZE(65,12) FILE(C_SYNTUC) ;
                            FIELDS(cUCET:sytnt             , ;
                                   cNAZ_UCT:Název syntetiky, ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)

** SKUPINY
TYPE(TabPage) SIZE(65,24.7) CAPTION(Skupiny) OFFSET(33,50) RESIZE(xy)

  TYPE(DBrowse) SIZE(65,12) FILE(C_GRUPUC) ;
                            FIELDS(cUCET:skupina           , ;
                                   cNAZ_UCT:Název skupiny  , ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)

** TØÍDY
TYPE(TabPage) SIZE(65,24.7) CAPTION(Tøídy) OFFSET(49,34) RESIZE(xy)

  TYPE(DBrowse) SIZE(65,12) FILE(C_TRIDUC) ;
                            FIELDS(cUCET:tøída             , ;
                                   cNAZ_UCT:Název tøídy    , ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)



** pravá èást **
TYPE(Static) FPOS(65.7, .7) SIZE(34,23.5) STYPE(2) CTYPE(2) RESIZE(yy)

*  TYPE(CHECKBOX) NAME(c_uctosn->lnaklstr)  FPOS(2,2.2) FLEN(16) VALUES(T:povinná,F:nePovinná) GROUPS(12)

  TYPE(CHECKBOX) NAME(C_UCTOSN->LNAKLSTR)  FPOS(2,2.2) FLEN(30)  FCAPTION(Nákladová struktura ...)  CPOS(1,0.6) CLEN(25) ; 
                 VALUES(T:povinná,F:nePovinná) GROUPS(12)

    TYPE(Static) FPOS(.3, .4) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End)  

  TYPE(RADIOBUTTON) NAME(C_UCTOSn ->cZUSTUCT) FPOS(1,5.2) SIZE(30,3) VALUES(M:na stranu MD,D:na stranu DAL,O:z obratu úètu) FLEN(30) ;
                    FCAPTION(Výpoèet zùstatku ...) CPOS(1,3.8) CLEN(30) GROUPS(12)


*  TYPE(CHECKBOX) NAME(C_UCTOSn ->cZUSTUCT) FPOS(1,5.2) VALUES(M:na stranu MD,D,O) FLEN(30) ;
*                 FCAPTION(Výpoèet zùstatku ...) CPOS(1,3.8) CLEN(30) GROUPS(12)
*  TYPE(CHECKBOX) NAME(C_UCTOSn ->cZUSTUCT) FPOS(1,6.2) VALUES(D:na stranu DAL,M,O) FLEN(30) GROUPS(12)
*  TYPE(CHECKBOX) NAME(C_UCTOSn ->cZUSTUCT) FPOS(1,7.2) VALUES(O:z obratu úètu,M,D) FLEN(30) GROUPS(12)

    TYPE(Static) FPOS(.3, 3.6) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End)  

  TYPE(CHECKBOX) NAME(C_UCTOSN->LNAKLUCT)  FPOS(2,10.2) FLEN(13)  FCAPTION(Typ úètu ...)  CPOS(1,8.7) CLEN(25) ; 
                 VALUES(T:nákladový,F:nákladový) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LVYNOSUCT) FPOS(2,11.2) FLEN(13) VALUES(T:výnosový  ,F:výnosový  ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LAKTIVUCT) FPOS(2,12.2) FLEN(13) VALUES(T:aktivní   ,F:aktivní   ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LPASIVUCT) FPOS(2,13.2) FLEN(13) VALUES(T:pasivní   ,F:pasivní   ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LZAVERUCT) FPOS(2,14.2) FLEN(13) VALUES(T:závìrkový ,F:závìrkový ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LPODRZUCT) FPOS(2,15.2) FLEN(13) VALUES(T:podrozvaha,F:podrozvaha) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LNATURUCT) FPOS(2,16.2) FLEN(13) VALUES(T:naturální ,F:naturální ) GROUPS(12)

    TYPE(Static) FPOS(.3, 8.6) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End) 

  TYPE(CHECKBOX) NAME(C_UCTOSN->LSALDOUCT)  FPOS(2,19) FLEN(13) VALUES(T:saldokontní,F:saldokontní) GROUPS(12) 
  TYPE(CHECKBOX) NAME(C_UCTOSN->LFINUCT  )  FPOS(2,20) FLEN(13) VALUES(T:finanèní   ,F:finanèní   ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LDANUCT)    FPOS(2,21) FLEN(13) VALUES(T:daòový     ,F:daòový     ) GROUPS(12)
  TYPE(CHECKBOX) NAME(C_UCTOSN->LMIMORUCT)  FPOS(2,22) FLEN(13) VALUES(T:mimoøádný  ,F:mimoøádný  ) GROUPS(12) POST(postLastField)

    TYPE(Static) FPOS(.3, 17.6) SIZE(33.3, .3) STYPE(14) RESIZE(yx)
    TYPE(End) 

TYPE(End)


TYPE(TabPage) SIZE(65,24.7) CAPTION(Rozpad) OFFSET(76,1) RESIZE(xy)
* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,0) SIZE(65,23.5) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 ITEMMARKED(TreeItemMarked)     ;
                 ITEMSELECTED( TreeItemSelected)
TYPE(End)






