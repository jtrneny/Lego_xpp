TYPE(drgForm) DTYPE(10) TITLE(V�robn� zak�zky dle fakturace - KONTROLA) FILE(VYRZAKw);
              SIZE(115,26) GUILOOK(Action:y,IconBar:y) ;
              CARGO(VYR_VyrZak_CRD)

TYPE(Action) CAPTION(~Aktualizovat)   EVENT(Vyrzak_modi)  TIPTEXT(Aktualizovat zak�zky fakt.mno�stv�m)

  TYPE(DBrowse) FILE(VyrZakw) INDEXORD(1);
                FIELDS( CCISZAKAZ      ,;
                        CSTAVZAKAZ:Stav,;
                        CNAZEVZAK1::30 ,;
                        nMnozFakt      ,;
                        nSumFaktMn     ,;
                        cNazPol3       ) ;
                SIZE(115,11.5) CURSORMODE(3) PP(7) RESIZE(yy) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED(ItMarked_ZAKIT)

  TYPE(Text) CAPTION( Polo�ky v�robn� zak�zky)   CPOS( 0.5,11.6) CLEN( 114) FONT(5) CTYPE(1)

  TYPE(DBrowse) FILE(VyrZakITw) INDEXORD(1);
                FIELDS( cCisZakazI ,;
                        CNAZEVZAK1::30 ,;
                        nMnozFakt      ,;
                        nSumFaktMn     ,;
                        cNazPol3       ) ;
                SIZE(115,6) FPOS(0.1, 12.7) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) FOOTER(y);
                ITEMMARKED(ItMarked_FAKIT) 

  TYPE(Text) CAPTION( Faktury vystaven�)   CPOS( 0.5,18.8) CLEN( 114) FONT(5) CTYPE(1)

  TYPE(DBrowse) FILE(FakVysIT) INDEXORD(12);
                FIELDS( cCisZakazI ,;
                        cUloha     ,;
                        nCisFak    ,;
                        nFaktMnoz  ,;
                        nCenZakCel ,;
                        cNazZbo    );
                SIZE(115,6) FPOS(0.1, 19.9) CURSORMODE(3) SCROLL(ny) PP(7) RESIZE(yx) FOOTER(y)
