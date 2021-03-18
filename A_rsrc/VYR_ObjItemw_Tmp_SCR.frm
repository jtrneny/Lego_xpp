TYPE(drgForm) DTYPE(10) TITLE(Podklady pro v�robu dle v�robk�) FILE(OBJITEMw);
              SIZE(100,25) GUILOOK(Message:Y,Action:Y,IconBar:Y)

*TYPE(Action) CAPTION(info ~Objedn�vky)    EVENT(VYR_VYRZAK_INFO)  TIPTEXT(Seznam objedn�vek )


TYPE(DBrowse) FILE(OBJITEMw) INDEXORD(3) ;
              FIELDS( M->ObjVykryta:V:2.6::2     ,;
                      ccissklad:Sklad:8          ,;
                      cSklPol:Skl.polo�ka        ,;
                      cNazZbo:N�zev zbo��:25     ,;
                      cZkratJedn:MJ              ,;
                      M->ObjCenDis:K dispozici:10   ,; 
                      nMnozObOdb:Objedn�no:10       ,;
                      nMnozPoOdb:Potvrzeno:10       ,;
                      nMnozPlOdb:Dod�no:10          ,;
                      nMnozVpInt:K v�rob�:10       ,;
                      nKcsBdObj:Cena celkem  ) ;
              SIZE(100,14.6) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(yy);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 99.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Aktu�ln� objednan� v�robky) CPOS( 35, 0.1) CLEN( 25) FONT(5)
    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 83, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->lDataFilter) FPOS( 0, 0) FLEN( 16) VALUES(1:V�echny      ,;
                                                                       2:Vykryt�      ,;
                                                                       3:Nevykryt�    );
                                          ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Objedn�vky) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(1,80) PRE( tabSelect)
  TYPE(DBrowse) FILE(OBJITEM) INDEXORD(1) ;
                FIELDS( nDoklad                    ,;
                        ccislobint:Int��slo:20     ,; 
                        M->ObjFirma:N�zevOdb:30    ,;
                        nMnozObOdb:Objedn�no:10    ,;
                        nMnozPoOdb:Potvrzeno:10    ,;
                        nMnozPlOdb:Dod�no:10       ,;
                        nMnozVpInt:K v�rob�:10     ,;
                        nKcsBdObj:Cena celkem      ,;
                        ncisfirmy:��sFirmy    );
               SIZE(98, 7.5) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(ny)
TYPE(End)


TYPE(TabPage) TTYPE(4) CAPTION(Pln�no zak�zkami) FPOS(1,16.2) SIZE( 98, 8.5) RESIZE(yx) OFFSET(19,62) PRE( tabSelect)

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

TYPE(End)