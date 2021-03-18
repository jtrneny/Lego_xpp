TYPE(drgForm) DTYPE(10) TITLE(Èíselník zakázek - VÝBÌR) SIZE(100,25);
                        GUILOOK(Action:n,Message:n,IconBar:n,Menu:n)

  TYPE(DBrowse) FPOS(0,.1) SIZE(105,11.5) FILE(CNAZPOL3)    ;
                                          FIELDS(cnazPol3:èísZakázky    , ;
                                                 cnazev:název zakázky:39, ;
                                                 nplanMater:plánMat     , ;
                                                 nskutMater:skutMat     , ;  
                                                 nplanMzdy:plánMzdy     , ; 
                                                 nskutMzdy:skutMzdy     , ;
                                                 nplanRezie:plánRež     , ;
                                                 nskutRezie:skutRež     , ;
                                                 nplanCena:plánCena     , ;
                                                 nskutCena:skutCena       ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) RESIZE(yx)

* cstavZakaz <- vyrZakit
* VALUES( 1:nová zakázka-vyr. položka neexis,
*         2:probíhá konstrukèní schválení,
*         3:vyrábìná položka není schválená,
*         4:vyrábìná položka je schválená,
*         5:pøedány èásteèné výrob. podklady,
*         6:pøedány kompletní výr. podklady,
*         7:vyrobena zèásti,
*         8:vyrobena celá a odvedena,
*         D:èásteènì pøijata do expedice,
*         P:celá pøijata do expedice,
*         U:ukonèená zakázka,
*         R:rezervovaná zakázka,
*         0:stornovaná zakázka)


* ctavZakaz <> U R 0
* TYPE(DBrowse)  FPOS(0,1) SIZE(105,8.5) FILE(vyrZakit)          ;
*                          FIELDS ( cCISZAKAZI:výrÈíslo:20     , ;
*                                   cNAZEVZAK1:název zakázky:39, ) ;
*                          SIZE(100,11.3) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) POPUPMENU(yn);
*                          ITEMMARKED( ItemMarked)




TYPE(Static) STYPE(13) SIZE(105,12.5) FPOS(0,12)  RESIZE(yy)
  TYPE(TEXT) CAPTION(Položky výrobní zakázky) CPOS(0,0) CLEN(104) FONT(5) PP(3) BGND(11) CTYPE(1) Resize(yx)

  TYPE(DBrowse)  FPOS(0,1) SIZE(105,8.5) FILE(vyrZakit)  ;
                  FIELDS ( cCISZAKAZ:èísloZakázky:20    , ;
                           cCISZAKAZI:výrÈíslo:20       , ;
                           cNAZEVZAK1:název zakázky:39, ;
                           CNAZFIRMY::20              , ;
                           cSKP:skp                   , ;
                           cZKRATMENZ:mìna            , ;
                           nCENAMJ:cena/mj              ) ;
                 SIZE(100,11.3) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) POPUPMENU(yn);
                 ITEMMARKED( ItemMarked)

TYPE(END)

*                            M->mnozKFak:množKFak:10      ) ;