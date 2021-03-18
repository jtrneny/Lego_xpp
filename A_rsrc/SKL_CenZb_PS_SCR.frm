TYPE(drgForm) DTYPE(10) TITLE(POÈÁTEÈNÍ STAVY skladových karet) FILE(CenZb_PS);
              SIZE(110,25) GUILOOK(Message:Y,Action:y,IconBar:Y) OBDOBI(SKL)

TYPE(Action) CAPTION(~Pøepoèet stavù) EVENT( PREPOCET_PocStavu) TIPTEXT(Pøepoèet poèáteèního stavu roku)
TYPE(Action) CAPTION(info C~eník)     EVENT( SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)

TYPE(DBrowse) FILE(CenZb_PS) INDEXORD(1) ;
              FIELDS( cCisSklad  ,;
                      cSklPol    ,;
                      CenZboz->cNazZbo::35 ,;
                      nRok       ,;
                      nCenaSZBO  ,;
                      nMnozPOC   ,;
                      nCenaPOC   );
              SIZE(110,23.7) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

*  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn) GROUPS(clrGREY)
*    TYPE(Text)     CAPTION(Poèáteèní stavy karet) CPOS( 45, 0.1) CLEN( 20) FONT(5)
*    TYPE(Static) STYPE(1) SIZE( 16,1.2) FPOS( 93, 0.1)  RESIZE(nx)
*      TYPE(COMBOBOX) NAME(M->nRok_filter)  FPOS( 0, 0) FLEN( 16) VALUES(1:Všechny roky  ,;
*                                                                        2:Rok 2006      ,;
*                                                                        3:Rok 2007      ,;
*                                                                        4:Rok 2008      ,;
*                                                                        5:Rok 2009      ,;
*                                                                        6:Rok 2010      ,;
*                                                                        6:Rok 2011      );
*                                           ITEMSELECTED(comboItemSelected)
*    TYPE(End)
*  TYPE(End)

*** QUICK FILTR ***
 TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(114.75,1.25) RESIZE(yn)
   TYPE(Text)     CAPTION(Poèáteèní stavy skladových karet) CPOS( 30, 0.5) CLEN(30) FONT(5)
*
    TYPE(STATIC) STYPE(2) FPOS(71, .02) SIZE(37, 1.1) RESIZE(nx)
      TYPE(PushButton) POS( .1, -.01)  SIZE(260, 23) CAPTION(~Kompletní poèáteèní stavy karet) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
    TYPE(END) 
 TYPE(END)

TYPE(End)