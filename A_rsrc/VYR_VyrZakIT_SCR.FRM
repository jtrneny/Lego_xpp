TYPE(drgForm) DTYPE(10) TITLE(Seznam položek zakázky) SIZE(105,25) FILE(VYRZAKIT);
              GUILOOK(Action:y,IconBar:y,Menu:n);
              CARGO( VYR_VYRZAKIT_CRD);
              POST( POSTVALIDATE)
*              CBSAVE( OnSave)

TYPE(Action) CAPTION(~info Zakázka)   EVENT(VYR_VYRZAK_INFO) TIPTEXT(Informaèní karta výrobní zakázky )
TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) EVENT( SEPARATOR)
*TYPE(Action) EVENT( SEPARATOR)
TYPE(Action) CAPTION(~Gener. položek)  EVENT( GenVyrZakIT)    TIPTEXT(Automatické generování položek zakázky)
TYPE(Action) CAPTION(Gener. o~perací)  EVENT( GenPolOper)     TIPTEXT(Automatické generování operací k položce zakázky)
TYPE(Action) CAPTION(~Expedièní list)  EVENT( PRO_Explsthd)   TIPTEXT(Expedièní list)
TYPE(Action) CAPTION(~Kusovník plný)   EVENT( KusTree_Full)   TIPTEXT(Zobrazení plného strukturovaného kusovníku )
TYPE(Action) CAPTION(Kus~ovník s op.)  EVENT(VyrPol_OperTree) TIPTEXT(Zobrazení struk. kusovníku s operacemi )
TYPE(Action) CAPTION(Mzdové ~lístky)   EVENT(ListHD_SCR)      TIPTEXT(Mzdové lístky k položce zakázky )
TYPE(Action) CAPTION(~Zapustit)        EVENT( ZAKIT_ZAPUSTIT) TIPTEXT(Zapuštìní položky zakázky )


*
TYPE(Static) STYPE(13) SIZE(104, 3.8) FPOS( 0.5,0.1) RESIZE(yn) CTYPE(2)
  TYPE(TEXT) FCAPTION(Zakázka)          CPOS( 2,0.2) CLEN( 10) FONT(2)
  TYPE(TEXT) NAME(VYRZAK->cCisZakaz)    CPOS( 2,1.2) CLEN( 30) BGND(13) FONT(5) GROUPS(clrGREY)
  TYPE(TEXT) NAME(VYRZAK->cNazevZak1)   CPOS( 2,2.2) CLEN(100) BGND(13) FONT(5) GROUPS(clrGREY)
*  TYPE(TEXT) CAPTION(Èíslo objednávky)  CPOS(46,0.2) CLEN( 15) FONT(2)
*  TYPE(TEXT) NAME(VYRZAK->cCisloObj)    CPOS(46,1.2) CLEN( 56) BGND(13) FONT(5) GROUPS(clrGREY)
TYPE(End)

*TYPE(Static) STYPE(13) SIZE(105, 10.6) FPOS(0,3.8) RESIZE(yn)
* Seznam položek zakázky
  TYPE(DBrowse) FILE(VYRZAKIT) INDEXORD(1) ;
                FIELDS( nOrdItem      ,;
                        cVyrobCisl    ,;
                        nMnozPlano:Množství   ,;
                        cBarva:Barva vnìjší   ,;
                        cBarva_2:Barva vnitøní,;
                        nRozm_vys    ,;
                        nRozm_sir    ,;
                        nRozm_del    ,;
                        cRozm_MJ     ,;
                        cCisZakazI   );
                SIZE(104,8.6) FPOS(0.5, 3.8) SCROLL(ny) CURSORMODE(3) PP(7) POPUPMENU(y) ;
                ITEMMARKED( itemMarked)
*TYPE(End)

* Seznam operací k položce zakázky
  TYPE(TABPAGE) TTYPE(4) CAPTION(Seznam operací) FPOS(1,12.5) SIZE(105,12.4)  OFFSET(1,82) PRE(tabSelect)
    TYPE(DBrowse) FILE(POLOPER) INDEXORD(7);
                  FIELDS( nVarOper         ,;
                          nCisOper:È.oper. ,;
                          nUkonOper        ,;
                          cOznOper         ,;
                          cVyrPol          ,;
                          nPriprCas::12:@N 999 999.9999  ,;
                          nKusovCas::12:@N 999 999.9999  ,;
                          nKcNaOper:Cena operace:12:@N 999 999.999  ,;
                          OPERACE->cOznPrac,;
                          mPolOper:Popis operace:25,;
                          OPERACE->cNazOper,;
                          cCisZakazI:Položka zakázky ,;
                          nPorCisLis  );
                   SIZE(104, 11.2 ) FPOS(0, 0) CURSORMODE(3) PP(7) RESIZE(yn) SCROLL(ny)
  TYPE(END)

*TYPE(End)