TYPE(drgForm) DTYPE(10) TITLE(Výsledovky za volitelné nákladové strukury) SIZE(100,25)   ;
                                                           FILE(C_NAKLST) ;
                                                           GUILOOK(Menu:y,IconBar:y,Action:y)

*
* UCETSYS
 TYPE(Text)    CAPTION(období zpracování) CPOS(.2,.1) FONT(5) BGND(12) CLEN(40) CTYPE(3) RESIZE(yn)
 TYPE(DBrowse) FPOS(0.1,1.4) SIZE(40.2,12.5) FILE(UCETSYS)                        ;
                                       FIELDS(M->obd_Select: :2.7::2            , ; 
                                              UCT_naklvysl_BC(2):_:2.7::2       , ;
                                              UCT_naklvysl_BC(3):u:2.7::2       , ;
                                              UCT_naklvysl_BC(4):a:2.7::2       , ;
                                              UCT_naklvysl_BC(5):období:8       , ;
                                              UCT_naklvysl_BC(6):úètoval:19       ) ; 
                                       CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(ny) INDEXORD(3)

*
* C_NAKLSTW / 
 TYPE(TABPAGE) FPOS(40.5,1.5) SIZE(58.8,12.15) OFFSET( 1,75) CAPTION(nákladové) TABHEIGHT(.8) PRE(tabSelect)
   TYPE(DBrowse) FPOS( .5, .2) SIZE(58,11) FILE(c_naklstW)                           ;
                                          FIELDS(M->porNs_Select:poø:3.5           , ; 
                                                 cnazev_Ns:nákladová struktura:55  ) ;
                                          CURSORMODE(3) PP(7) SCROLL(nn) RESIZE(yy)
 TYPE(End) 
 
 TYPE(TABPAGE) FPOS(39,1.5) SIZE(60,12.35) OFFSET(24,52) CAPTION(výètové)    TABHEIGHT(.8) PRE(tabSelect)
 TYPE(End) 


*
* C_NAZPOL
 TYPE(Text)    CAPTION(výbìr pro zpracování výsledovky) CPOS(.2,14) FONT(5) BGND(12) CLEN(99.8) CTYPE(3)
 TYPE(DBrowse) FPOS(0,15) SIZE(100,9.8) FILE(C_NAKLST)                    ;
                                        FIELDS(M->col0Ns_Select:_:3::2  , ;
                                               M->col1Ns_Select::15.6   , ;
                                               M->col2Ns_Select::15.6   , ;
                                               M->col3Ns_Select::15.6   , ;
                                               M->col4Ns_Select::15.6   , ;
                                               M->col5Ns_Select::15.6   , ;
                                               M->col6Ns_select::15.6     ) ;
                                         CURSORMODE(3) PP(7) SCROLL(ny) RESIZE(yn) INDEXORD(1) 


*  TYPE(Static) STYPE(12) SIZE(58.4,1.3) FPOS(41,0.1) RESIZE(y) CTYPE(2)
*    TYPE(ComboBox) NAME(UCT_naklvysl_in:selRok) FPOS(37.9,.15) FLEN(20)                ;
*                                                             VALUES(a,a,a)           ;
*                                                             COMBOINIT(comboBoxInit) ;
*                                                             TEMSELECTED(comboItemSelected)
*  TYPE(End) 