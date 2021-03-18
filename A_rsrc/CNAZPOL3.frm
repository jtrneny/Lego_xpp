TYPE(drgForm) DTYPE(2) TITLE(Èíselník zakázek) SIZE(75,15) FILE(CNAZPOL3) GUILOOK(Action:n)

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
  TYPE(GET) NAME(CNAZPOL3) FPOS(15,1) FLEN(8) FCAPTION(Zakázka) CPOS(1,1) PP(2) POST( drgPostUniqueKey)
  TYPE(GET) NAME(CNAZEV) FPOS(15,2) FLEN(25) FCAPTION(Název zakázky) CPOS(1,2)
  TYPE(GET) NAME(NPLANMATER) FPOS(15,3) FLEN(13) FCAPTION(Plán materiál) CPOS(1,3)
  TYPE(GET) NAME(NPLANMZDY) FPOS(15,4) FLEN(13) FCAPTION(Plán mzdy) CPOS(1,4)
  TYPE(GET) NAME(NPLANREZIE) FPOS(15,5) FLEN(13) FCAPTION(Plán režie) CPOS(1,5)
  TYPE(GET) NAME(NPLANCENA) FPOS(15,6) FLEN(13) FCAPTION(Plán cena celkem) CPOS(1,6)
  TYPE(GET) NAME(NSKUTMATER) FPOS(15,7) FLEN(13) FCAPTION(Skuteènost materiál) CPOS(1,7)
  TYPE(GET) NAME(NSKUTMZDY) FPOS(15,8) FLEN(13) FCAPTION(Skuteènost mzdy) CPOS(1,8)
  TYPE(GET) NAME(NSKUTREZIE) FPOS(15,9) FLEN(13) FCAPTION(Skuteènost režie) CPOS(1,9)
  TYPE(GET) NAME(NSKUTCENA) FPOS(15,10) FLEN(13) FCAPTION(Skut. cena celkem) CPOS(1,10)
TYPE(End)



*   TYPE(FIELD) NAME(cStavZakaz) DESC(Stav výrobní  zakázky)          CAPTION(Stav zak.)                  FTYPE(C) FLEN( 2) DEC(0) 
*   VALUES( 1:nová zakázka-vyr. položka neexis,
*           2:probíhá konstrukèní schválení,
*           3:vyrábìná položka není schválená,
*           4:vyrábìná položka je schválená,
*           5:pøedány èásteèné výrob. podklady,
*           6:pøedány kompletní výr. podklady,
*           7:vyrobena zèásti,
*           8:vyrobena celá a odvedena,
*           D:èásteènì pøijata do expedice,
*           P:celá pøijata do expedice,
*           U:ukonèená zakázka,
*           R:rezervovaná zakázka,
*           0:stornovaná zakázka)