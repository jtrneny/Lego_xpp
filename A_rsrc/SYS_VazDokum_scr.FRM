TYPE(drgForm) DTYPE(10) TITLE(Pøehled pøipojených dokumentù) FILE(vazDokum);
              SIZE(110,20) GUILOOK(Message:Y,Action:y,IconBar:Y) 

TYPE(Action) CAPTION(~Dokument)       EVENT(sys_dokument_in) TIPTEXT(Údaje o evidovaném dokumentu) 


TYPE(DBrowse) FILE(vazDokum) INDEXORD(1)                       ;
              FIELDS( M->is_existFile::2.6::2                , ;
                      M->dokument_IDdokum:idetifikace:14     , ;
                      M->dokument_zkrDokum:zkratka:10        , ;                      
                      M->dokument_nazDokum:název dokumenu:30 , ;
                      M->dokument_soubor:soubor:50           , ;
                      M->dokument_adresar:20                   ) ; 
              SIZE(110,17.7) FPOS(0, 1.4 ) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

  TYPE(Static) STYPE(13) SIZE( 109.6,1.2) FPOS( 0.2, 0.1)  RESIZE(yn)
*    TYPE(Text)     CAPTION(Pøipojené dokumenty) CPOS( 45, 0.1) CLEN( 20) FONT(5)
    TYPE(Text)     NAME(M->titleText) CPOS( 20, 0.1) CLEN( 80) FONT(5)
  TYPE(End)

*  TYPE(Static) STYPE(13) SIZE(109,2.5) FPOS(0.5,17.2) RESIZE(y)
*    TYPE(PushButton) POS( 5,0.9) SIZE(18,1.2) CAPTION(~Pøipojit dokument) EVENT(AttachDokum)   ICON1(117) ICON2(218) ATYPE(3)
*    TYPE(PushButton) POS(25,0.9) SIZE(18,1.2) CAPTION(~Odpojit dokument)  EVENT(deAttachDokum) ICON1(119) ICON2(220) ATYPE(3)
*    TYPE(PushButton) POS(85,0.9) SIZE(18,1.2) CAPTION(~Zobrazit dokument) EVENT(ViewDokum)     ICON1(118) ICON2(219) ATYPE(3)
*  TYPE(End)

TYPE(End)