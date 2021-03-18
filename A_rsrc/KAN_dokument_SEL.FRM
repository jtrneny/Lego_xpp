TYPE(drgForm) DTYPE(10) SIZE(106,18) TITLE(Seznam dokumentù ... (výbìr) ... ) ;
              FILE(dokument)                                                  ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n) 


TYPE(Action) CAPTION(~Nový   Dokum)  EVENT(kan_dokument_new)    TIPTEXT(Založení nového dokumentu do seznamu ...)
TYPE(Action) CAPTION(~Oprava Dokum ) EVENT(kan_dokument_modify) TIPTEXT(Oprava údajù dokumentu ...)


TYPE(DBrowse) FPOS(0,1.5) SIZE(106,9.4) FILE(DOKUMENT)                ;
                                        FIELDS( existFile()::2.6::2 , ;
                                                cIDdokum            , ;
                                                cZkrDokum           , ;
                                                cNazDokum           , ;
                                                cSoubor             , ;
                                                mAdresar            , ;
                                                mPoznamka             ) ;
                                        CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) ITEMSELECTED(itemSelected)


TYPE(Static) STYPE(13) SIZE(104,16.5) FPOS(1,10.7) RESIZE(yn)
 
  TYPE(TEXT) CAPTION(Typ dokumentu             __________)          CPOS( 1, 0.3) CLEN( 27)
  TYPE(TEXT) NAME(dokument->cID)                                    CPOS(28, 0.3) CLEN( 21) BGND(13) PP(2) CTYPE(2)

*  TYPE(TEXT) CAPTION(ientifikace)                                  CPOS(40, 0.3)
*  TYPE(TEXT) NAME(dokument->cIDdokum)                              CPOS(55, 0.3) CLEN( 20) BGND(13)

  TYPE(TEXT) CAPTION(Úloha                             __________)  CPOS( 1, 1.3) CLEN( 27)
  TYPE(TEXT) NAME(dokument->CTASK)                                  CPOS(28, 1.3) CLEN( 20) BGND(13)
  TYPE(TEXT) NAME(c_task->cnazUlohy)                                CPOS(50, 1.3) 
   
  TYPE(TEXT)  CAPTION(Zkratka dokumentu       __________)           CPOS( 1, 2.3) CLEN( 27)
  TYPE(TEXT)  NAME(dokument->czkrDokum)                             CPOS(28, 2.3) CLEN( 20) BGND(13)
  
  TYPE(TEXT)  CAPTION(Název dokumentu         __________)           CPOS( 1, 3.3) CLEN( 27)
  TYPE(TEXT)  NAME(dokument->cnazDokum)                             CPOS(28, 3.3) CLEN( 50) BGND(13)

  TYPE(TEXT)  CAPTION(Typ prohlížeèe-editoru  __________)           CPOS( 1, 4.3) CLEN( 27)
  TYPE(TEXT)  NAME(dokument->cTypEdit)                              CPOS(28, 4.3) CLEN( 50) BGND(13)

  TYPE(TEXT)  CAPTION(Umístìní dokumentu     __________)            CPOS( 1, 5.3) CLEN( 27)
  TYPE(TEXT)  NAME(dokument->csoubor)                               CPOS(28, 5.3) CLEN( 50) BGND(13)
TYPE(END)

TYPE(STATIC) STYPE(2) FPOS(0.50,-0.25) SIZE(105.75,1.25) RESIZE(yn)
  TYPE(TEXT) CAPTION(Seznam dokumentù ...)     CPOS(1.5, 0.6) FONT(5)  CLEN(30)
*
  TYPE(PushButton) POS(82.5,0.6)   SIZE(23,1.2) CAPTION(~Kompletní seznam) EVENT(createContext) ICON1(101) ICON2(201) ATYPE(3)
TYPE(END)


