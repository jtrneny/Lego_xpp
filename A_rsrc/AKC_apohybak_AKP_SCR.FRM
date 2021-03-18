TYPE(drgForm) DTYPE(10) TITLE(Pøehled pohybù akcií dle položek akcií ...) FILE(AKCIE)            ;
                                                                          SIZE(110,25)           ;
                                                                          GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar)



* AKCIE
  TYPE(DBrowse) FILE(AKCIE) INDEXORD(1);
                FIELDS( cZkrTypAkc:zkrTypu:10          , ;
                        M->nazevAkc:název typu akcie:40, ;
                        M->zpusNab:zpusNab:10          , ; 
                        cserCisAkc:sériovéÈíslo:30     , ;
                        nhodnotaAk:hodnota               ) ;
                SIZE(110, 13.6) RESIZE(yx) CURSORMODE(3) PP(7) SCROLL(yy) ITEMMARKED(itemMarked) POPUPMENU(y) 


* APOHYBAK - pohyby / zmìny akcií
  TYPE(TabPage) CAPTION(pohybAkcie) FPOS(0, 14.2) SIZE(110,10.5) RESIZE(yx) TTYPE(3) OFFSET(1,81)

    TYPE(DBrowse) FILE(APOHYBAK) INDEXORD(10)           ;
                  FIELDS(czkrTYPpoh:typPohybu         , ;
                         cserCisAkc:sériovéÈíslo      , ;
                         dzmenaZazn:datZmìny:10       , ;
                         czkrTYPakc:zkrTypu           , ;
                         crodCISnew:rodnéÈíslo        , ;
                         cjmenoNew:jméno akcionáøe:28 , ;
                         nhodnotaAk:hodnota             ) ;
                  FPOS(.1, .01) SIZE(110,9.5) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) 
  TYPE(End)




