TYPE(drgForm) DTYPE(10) TITLE(Objedn�vky p�ijat� dle zak�zek) FILE(OBJITEM);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y)

TYPE(Action) CAPTION(info ~Zak�zky)    EVENT(VYR_VYRZAK_INFO)  TIPTEXT(Informa�n� karta v�robn� zak�zky )


TYPE(DBrowse) FILE(OBJITEM) INDEXORD(3) ;
              FIELDS( M->ObjVykryta:V:2.6::2     ,;
                      cCislObInt:��s.objedn�vky  ,;
                      nCislPolOb:Pol.obj.        ,;
                      dDatDoOdb:Dat.dod�n�       ,;
                      cSklPol:Skl.polo�ka        ,;
                      cNazZbo:N�zev zbo��        ,;
                      cZkratJedn:MJ              ,;
                      nMnozObOdb:Mn.objedn�no    ,;
                      nMnozPoOdb:Mn.potvrzeno    ,;
                      nMnozPlOdb:Mn.dod�no       ,;
                      nKcsBdObj:Cena celkem      ,;
                      nMnozVpInt:Mn. k v�rob�   ) ;
              SIZE(100,14.6) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(yy);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 99.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(OBJEDN�VKY dle ZAK�ZEK) CPOS( 35, 0.1) CLEN( 25) FONT(5)
    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 83, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 16) VALUES(1:V�echny      ,;
                                                                       2:Vykryt�      ,;
                                                                       3:Nevykryt�    );
                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Pln�no zak�zkami) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)
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


TYPE(TabPage) TTYPE(4) CAPTION(Detail objedn�vky) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(18,63) PRE( tabSelect)

*   1.��dek
    TYPE(Text) CAPTION(Skl.polo�ka)            CPOS(  3, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cSklPol)                   CPOS(  3, 1.5)   CLEN( 20) BGND( 13) FONT(5) GROUPS(clrGREY)
    TYPE(Text) CAPTION(N�zev zbo��)            CPOS( 25, 0.5)   CLEN( 15)
    TYPE(Text) NAME(cNazZbo)                   CPOS( 25, 1.5)   CLEN( 30) BGND( 13) FONT(5) GROUPS(clrGREY)
*   2.��dek
*   3.��dek
TYPE(End)

TYPE(End)