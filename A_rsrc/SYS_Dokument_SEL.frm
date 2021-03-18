TYPE(drgForm) DTYPE(10) TITLE(Seznam dokumentù - VÝBÌR) FILE(DOKUMENT);
              SIZE(100,20) GUILOOK(Message:Y,Action:n,IconBar:Y); 
              CARGO( SYS_DOKUMENT_IN)

TYPE(DBrowse) FILE(DOKUMENT) INDEXORD(1) ;
              FIELDS( existFile()::2.6::2    ,;
                      cIDdokum               ,;
                      cOznDokum              ,;
                      cNazDokum              ,;
                      cSoubor              ) ;
              SIZE(100,19.8) CURSORMODE(3) SCROLL(ny) PP(7) POPUPMENU(y);
              ITEMMARKED(ItemMarked)

*  TYPE(Static) STYPE(13) SIZE(99,6.8) FPOS(0.5,13) Resize(nn)
*   1.øádek
*    TYPE(Text) CAPTION(Sklad)              CPOS(  1, 0.5)   CLEN(  8)
*  TYPE(End)