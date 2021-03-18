TYPE(drgForm) DTYPE(10) TITLE(Materiál - porovnání plánu se skuteèností) SIZE(100, 25) FILE( OBJITEM);
               GUILOOK(Action:y,Message:n,IconBar:myStdIconBar,Menu:n)

TYPE(Action) CAPTION(Detail ~Zakázky)    EVENT(VYR_VYRZAK_INFO)  TIPTEXT(Detail výrobní zakázky)
TYPE(Action) CAPTION(Detail ~Objednávky) EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Detail objednávky pøijaté na zakázku )
TYPE(Action) CAPTION(Detail ~Výdejky)    EVENT(SKL_CENZBOZ_INFO) TIPTEXT(Detail výdejky na zakázku )

* VÝROBNÍ ZAKÁZKA
  TYPE(Static) STYPE(12) SIZE(99,2.8) FPOS(0.5,0.1) RESIZE(yn) CTYPE(2)
    TYPE(Text) CAPTION(Zakázka)            CPOS( 2, 0.2) CLEN(  8) FONT(2)
    TYPE(Text) NAME(VyrZAK->cCisZakaz)     CPOS( 2, 1.2) CLEN( 40) BGND(13) FONT(5) PP(2)
    TYPE(Text) CAPTION(Název zakázky)      CPOS(44, 0.2) CLEN( 15) FONT(2)
    TYPE(Text) NAME(VyrZAK->cNazevZak1)    CPOS(44, 1.2) CLEN( 50) BGND(13) FONT(5) PP(2)
  TYPE(End)

* MATERIÁL objednaný na zakázku ( PLÁN )
  TYPE(Text) CAPTION( Materiál objednaný na zakázku) CPOS( 0.5,3) CLEN( 99) FONT(5) CTYPE(1) RESIZE(yn)
  TYPE(Browse) FILE(OBJITEM) INDEXORD(1);
               FIELDS( cNazZbo:Název zboží          ,;
                       cSklPol:Skladová položka     ,;
                       nZboziKat:Kateg.zb.          ,;
                       nCenNapDod:Cena na DL        ,;
                       nMnozObOdb:Mn.objednané odb. ,;
                       nMnozNeOdb:Mn. nepotvrzené );
              FPOS( 0, 4) SIZE(100, 9.7) RESIZE(yn) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn);
              ITEMMARKED( ItemMarked)

* MATERIÁL vydaný na zakázku ( SKUTEÈNOST )
  TYPE(Text) CAPTION( Materiál vydaný na zakázku) CPOS( 0.5,13.9) CLEN( 99) FONT(5) CTYPE(1) RESIZE(yn)
  TYPE(Browse) FILE(PVPITEM) INDEXORD(9);
               FIELDS( cCisSklad  ,;
                       cNazZbo    ,;
                       cSklPol    ,;
                       nZboziKat  ,;
                       nDoklad    ,;
                       nMnozPrDod );
              FPOS( 0, 15) SIZE(100, 9.8) RESIZE(yy) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(yn)

