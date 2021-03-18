TYPE(drgForm) DTYPE(10) TITLE(Objednávky pøijaté dle zakázek) FILE(OBJITEM);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y)

TYPE(Action) CAPTION(info ~Zakázky)    EVENT(VYR_VYRZAK_INFO)  TIPTEXT(Informaèní karta výrobní zakázky )


TYPE(DBrowse) FILE(OBJITEM) INDEXORD(3) ;
              FIELDS( M->ObjVykryta:V:2.6::2     ,;
                      cCislObInt:Èís.objednávky  ,;
                      nCislPolOb:Pol.obj.        ,;
                      dDatDoOdb:Dat.dodání       ,;
                      cSklPol:Skl.položka        ,;
                      cNazZbo:Název zboží        ,;
                      cZkratJedn:MJ              ,;
                      nMnozObOdb:Mn.objednáno    ,;
                      nMnozPoOdb:Mn.potvrzeno    ,;
                      nMnozPlOdb:Mn.dodáno       ,;
                      nKcsBdObj:Cena celkem      ,;
                      nMnozVpInt:Mn. k výrobì   ) ;
              SIZE(100,14.6) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(yy);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 99.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(OBJEDNÁVKY dle ZAKÁZEK) CPOS( 35, 0.1) CLEN( 25) FONT(5)
    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 83, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 16) VALUES(1:Všechny      ,;
                                                                       2:Vykryté      ,;
                                                                       3:Nevykryté    );
                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Plnìno zakázkami) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)
  TYPE(DBrowse) FILE(OBJZAK) INDEXORD(1) ;
                FIELDS( cCisZakaz              ,;
                        nMnPotVyrZ             ,;
                        nMnozDodVy             ,;
                        VyrZAK->nMnozPlano     ,;
                        dTermPoVyr             ,;
                        cStavVazby             ,;
                        VyrZAK->cNazevZak1::50 );
               SIZE(98, 7.5) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny)
TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Detail objednávky) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(18,63) PRE( tabSelect)

*   1.øádek
    TYPE(Text) CAPTION(Skl.položka)            CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                   CPOS(  3, 1.5)   CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(Název zboží)            CPOS( 25, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cNazZbo)                   CPOS( 25, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*   2.øádek
*   3.øádek
TYPE(End)

TYPE(End)