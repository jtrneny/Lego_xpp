TYPE(drgForm) DTYPE(10) TITLE(Pøehled evidovaných dokumentù) FILE(Dokument);
              SIZE(110,25) GUILOOK(Message:y,Action:y,IconBar:y) 

*TYPE(Action) CAPTION(~Pøepoèet) EVENT(PREPOCET_PocStavu) TIPTEXT(Pøepoèet poèáteèního stavu roku)
*TYPE(Action) CAPTION(info C~eník)    EVENT( SKL_CENZBOZ_INFO)  TIPTEXT(Informaèní karta skladové položky)

TYPE(DBrowse) FILE(Dokument) INDEXORD(1) ;
              FIELDS( existFile()::2.6::2,;
                      cIDdokum    ,;
                      cZkrDokum   ,;
                      cNazDokum   ,;
                      cSoubor     ,;
                      mAdresar    ,;
                      mPoznamka   );
              SIZE(110,20.7) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
    TYPE(Text)     CAPTION(Seznam dokumentù) CPOS( 45, 0.1) CLEN( 20) FONT(5)
    TYPE(Static) STYPE(1) SIZE( 21,1.2) FPOS( 88, 0.1)  RESIZE(nx)
      TYPE(COMBOBOX) NAME(M->cTask)  FPOS( 0, 0) FLEN( 21) VALUES(:Všechny úlohy  ,;
                                                                  SKL:Sklady  ,;
                                                                  HIM:Investièní majetek ,;
                                                                  VYR:Výroba      );
        ITEMSELECTED(comboItemSelected)
    TYPE(End)
  TYPE(End)

  TYPE(Static) STYPE(13) SIZE(109,2.5) FPOS(0.5,22.2) RESIZE(y)
    TYPE(PushButton) POS(85,0.9) SIZE(18,1.2) CAPTION(~Zobrazit dokument) EVENT(ViewDokum) ICON1(118) ICON2(219) ATYPE(3)
  TYPE(End)

TYPE(End)