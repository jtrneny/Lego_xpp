TYPE(drgForm) DTYPE(10) TITLE(Úèetní osnova ...) SIZE(100,25) ;
              GUILOOK(Action:n)  ;
              POST(postValidate) 

* ANALYTIKY
TYPE(TabPage) FPOS(.2,.3) SIZE(65,20) CAPTION(Analytiky) OFFSET(1,82) RESIZE(xy) PRE(tabSelect)
  TYPE(DBrowse) SIZE(65,18.8) FILE(C_UCTOSN) ;
                            FIELDS(cUCET:ÚÈET          , ;
                                   cNAZ_UCT:Název úètu , ;
                                   cUSERABB:Uživatel:14, ;
                                   dDATZMENY:DatZmìny    ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)        
TYPE(End)

** SYNTETIKY
TYPE(TabPage) FPOS(.2,.3) SIZE(65,20) CAPTION(Syntetiky) OFFSET(17,66) RESIZE(xy) PRE(tabSelect)
  TYPE(DBrowse) SIZE(65,18.8) FILE(C_SYNTUC) ;
                            FIELDS(cUCET:sytnt             , ;
                                   cNAZ_UCT:Název syntetiky, ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)

** SKUPINY
TYPE(TabPage) FPOS(.2,.3) SIZE(65,20) CAPTION(Skupiny) OFFSET(33,50) RESIZE(xy) PRE(tabSelect)
  TYPE(DBrowse) SIZE(65,18.8) FILE(C_GRUPUC) ;
                            FIELDS(cUCET:skupina           , ;
                                   cNAZ_UCT:Název skupiny  , ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)

** TØÍDY
TYPE(TabPage) FPOS(.2,.3) SIZE(65,20) CAPTION(Tøídy) OFFSET(49,34) RESIZE(xy) PRE(tabSelect)
  TYPE(DBrowse) SIZE(65,18.8) FILE(C_TRIDUC) ;
                            FIELDS(cUCET:tøída             , ;
                                   cNAZ_UCT:Název tøídy    , ;
                                   cUSERABB:Uživatel:14    , ;
                                   dDATZMENY:DatZmìny        ) ;
                            ITEMMARKED(itemMarked) CURSORMODE(3) INDEXORD(1) SCROLL(ny) PP(7) POPUPMENU(y) RESIZE(ny)
TYPE(End)



** editaèní wokna **
  TYPE(TEXT) CAPTION() CPOS(.5,20.7) CLEN(65.2) FONT(5) PP(3) BGND(12) CTYPE(1) GROUPS(INFO)

 TYPE(Static) FPOS(.5,21.7) SIZE(65.2,2.5) STYPE(2) CTYPE(2) RESIZE(yx)
   TYPE(GET)  NAME(M->cucet)      FPOS( 1, 1.5) FLEN( 8) FCAPTION(Úèet)          CPOS( 1, .5) NOREVISION()                    
   TYPE(GET)  NAME(M->cnaz_uct)   FPOS(11, 1.5) FLEN(34) FCAPTION(Název úètu)    CPOS(11, .5) 
 TYPE(End)


TYPE(Static) FPOS(65.7, .7) SIZE(34,23.5) STYPE(2) CTYPE(2) RESIZE(yy)

  TYPE(CHECKBOX) NAME(M->lnaklStr)  FPOS(2,2.2) FLEN(30)  FCAPTION(Nákladová struktura ...)  CPOS(1,0.6) CLEN(25) ; 
                 VALUES(T:povinná,F:povinná) 

    TYPE(Static) FPOS(.3, .4) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End)  

  TYPE(RADIOBUTTON) NAME(M->czustUct) FPOS(1,5.2) SIZE(30,3) VALUES(M:na stranu MD,D:na stranu DAL,O:z obratu úètu) FLEN(30) ;
                    FCAPTION(Výpoèet zùstatku ...) CPOS(1,3.8) CLEN(30) 

    TYPE(Static) FPOS(.3, 3.6) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End)  

  TYPE(CHECKBOX) NAME(M->lnaklUct)  FPOS(2,10.2) FLEN(13)  FCAPTION(Typ úètu ...)  CPOS(1,8.7) CLEN(25) ; 
                 VALUES(T:nákladový,F:nákladový) 
  TYPE(CHECKBOX) NAME(M->LVYNOSUCT) FPOS(2,11.2) FLEN(13) VALUES(T:výnosový  ,F:výnosový  ) 
  TYPE(CHECKBOX) NAME(M->LAKTIVUCT) FPOS(2,12.2) FLEN(13) VALUES(T:aktivní   ,F:aktivní   ) 
  TYPE(CHECKBOX) NAME(M->LPASIVUCT) FPOS(2,13.2) FLEN(13) VALUES(T:pasivní   ,F:pasivní   ) 
  TYPE(CHECKBOX) NAME(M->LZAVERUCT) FPOS(2,14.2) FLEN(13) VALUES(T:závìrkový ,F:závìrkový ) 
  TYPE(CHECKBOX) NAME(M->LPODRZUCT) FPOS(2,15.2) FLEN(13) VALUES(T:podrozvaha,F:podrozvaha) 
  TYPE(CHECKBOX) NAME(M->LNATURUCT) FPOS(2,16.2) FLEN(13) VALUES(T:naturální ,F:naturální ) 

    TYPE(Static) FPOS(.3, 8.5) SIZE(33.3, 1.3) STYPE(14) RESIZE(yx)
    TYPE(End) 

  TYPE(CHECKBOX) NAME(M->LSALDOUCT)  FPOS(2,18) FLEN(13) VALUES(T:saldokontní,F:saldokontní) 
  TYPE(CHECKBOX) NAME(M->LFINUCT  )  FPOS(2,19) FLEN(13) VALUES(T:finanèní   ,F:finanèní   ) 
  TYPE(CHECKBOX) NAME(M->LDANUCT)    FPOS(2,20) FLEN(13) VALUES(T:daòový     ,F:daòový     ) 
  TYPE(CHECKBOX) NAME(M->LMIMORUCT)  FPOS(2,21) FLEN(13) VALUES(T:mimoøádný  ,F:mimoøádný  ) 

  TYPE(CHECKBOX) NAME(M->LREZUCTY)   FPOS(2,22) FLEN(13) VALUES(T:režijní    ,F:režijní    ) 
  TYPE(CHECKBOX) NAME(M->LREZZAKLAD) FPOS(2,23) FLEN(13) VALUES(T:záklRežie  ,F:záklRežie  ) 

    TYPE(Static) FPOS(.3, 17.5) SIZE(33.3, .3) STYPE(14) RESIZE(yx)
    TYPE(End) 
TYPE(End)


TYPE(TabPage) FPOS(.2,.3) SIZE(65,20) CAPTION(Rozpad) OFFSET(76,1) RESIZE(xy) PRE(tabSelect)
* TREEVIEW
  TYPE(TreeView) ATYPE(3) FPOS(0,0) SIZE(65,18.8) HASLINES(Y) HASBUTTONS(Y) Resize(yn);
                 ITEMMARKED(TreeItemMarked)     ;
                 ITEMSELECTED( TreeItemSelected)
TYPE(End)






