TYPE(drgForm) DTYPE(2) TITLE(��seln�k zak�zek) SIZE(75,15) FILE(CNAZPOL3) GUILOOK(Action:n)

TYPE(TabPage) CAPTION(Seznam) OFFSET(0,84) PRE( tabSelect)
  TYPE(DBrowse) SIZE(75,14) FILE(CNAZPOL3) FIELDS(M->is_vyrZak_U::2.4::2 , ;
                                                  CNAZPOL3               , ;
                                                  CNAZEV                 , ;
                                                  NPLANMATER             , ;
                                                  NPLANMZDY              , ;
                                                  NPLANREZIE             , ;
                                                  NPLANCENA              , ;
                                                  NSKUTMATER             , ;
                                                  NSKUTMZDY              , ;
                                                  NSKUTREZIE             , ;
                                                  NSKUTCENA                ) ;
                            CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y) 
TYPE(End)

TYPE(TabPage) CAPTION(Detail)OFFSET(14,70) PRE( tabSelect)
  TYPE(GET) NAME(CNAZPOL3) FPOS(15,1) FLEN(8) FCAPTION(Zak�zka) CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV) FPOS(15,2) FLEN(25) FCAPTION(N�zev zak�zky) CPOS(1,2)
  TYPE(GET) NAME(NPLANMATER) FPOS(15,3) FLEN(13) FCAPTION(Pl�n materi�l) CPOS(1,3)
  TYPE(GET) NAME(NPLANMZDY) FPOS(15,4) FLEN(13) FCAPTION(Pl�n mzdy) CPOS(1,4)
  TYPE(GET) NAME(NPLANREZIE) FPOS(15,5) FLEN(13) FCAPTION(Pl�n re�ie) CPOS(1,5)
  TYPE(GET) NAME(NPLANCENA) FPOS(15,6) FLEN(13) FCAPTION(Pl�n cena celkem) CPOS(1,6)
  TYPE(GET) NAME(NSKUTMATER) FPOS(15,7) FLEN(13) FCAPTION(Skute�nost materi�l) CPOS(1,7)
  TYPE(GET) NAME(NSKUTMZDY) FPOS(15,8) FLEN(13) FCAPTION(Skute�nost mzdy) CPOS(1,8)
  TYPE(GET) NAME(NSKUTREZIE) FPOS(15,9) FLEN(13) FCAPTION(Skute�nost re�ie) CPOS(1,9)
  TYPE(GET) NAME(NSKUTCENA) FPOS(15,10) FLEN(13) FCAPTION(Skut. cena celkem) CPOS(1,10)
TYPE(End)



*   TYPE(FIELD) NAME(cStavZakaz) DESC(Stav v�robn�  zak�zky)          CAPTION(Stav zak.)                  FTYPE(C) FLEN( 2) DEC(0) 
*   VALUES( 1:nov� zak�zka-vyr. polo�ka neexis,
*           2:prob�h� konstruk�n� schv�len�,
*           3:vyr�b�n� polo�ka nen� schv�len�,
*           4:vyr�b�n� polo�ka je schv�len�,
*           5:p�ed�ny ��ste�n� v�rob. podklady,
*           6:p�ed�ny kompletn� v�r. podklady,
*           7:vyrobena z��sti,
*           8:vyrobena cel� a odvedena,
*           D:��ste�n� p�ijata do expedice,
*           P:cel� p�ijata do expedice,
*           U:ukon�en� zak�zka,
*           R:rezervovan� zak�zka,
*           0:stornovan� zak�zka)