TYPE(drgForm) DTYPE(10) TITLE(��seln�k zak�zek - V�B�R) SIZE(100,25);
                        GUILOOK(Action:n,Message:n,IconBar:n,Menu:n)

  TYPE(DBrowse) FPOS(0,.1) SIZE(105,11.5) FILE(CNAZPOL3)    ;
                                          FIELDS(cnazPol3:��sZak�zky    , ;
                                                 cnazev:n�zev zak�zky:39, ;
                                                 nplanMater:pl�nMat     , ;
                                                 nskutMater:skutMat     , ;  
                                                 nplanMzdy:pl�nMzdy     , ; 
                                                 nskutMzdy:skutMzdy     , ;
                                                 nplanRezie:pl�nRe�     , ;
                                                 nskutRezie:skutRe�     , ;
                                                 nplanCena:pl�nCena     , ;
                                                 nskutCena:skutCena       ) ;
                                          CURSORMODE(3) PP(7) SCROLL(yy) POPUPMENU(y) RESIZE(yx)

* cstavZakaz <- vyrZakit
* VALUES( 1:nov� zak�zka-vyr. polo�ka neexis,
*         2:prob�h� konstruk�n� schv�len�,
*         3:vyr�b�n� polo�ka nen� schv�len�,
*         4:vyr�b�n� polo�ka je schv�len�,
*         5:p�ed�ny ��ste�n� v�rob. podklady,
*         6:p�ed�ny kompletn� v�r. podklady,
*         7:vyrobena z��sti,
*         8:vyrobena cel� a odvedena,
*         D:��ste�n� p�ijata do expedice,
*         P:cel� p�ijata do expedice,
*         U:ukon�en� zak�zka,
*         R:rezervovan� zak�zka,
*         0:stornovan� zak�zka)


* ctavZakaz <> U R 0
* TYPE(DBrowse)  FPOS(0,1) SIZE(105,8.5) FILE(vyrZakit)          ;
*                          FIELDS ( cCISZAKAZI:v�r��slo:20     , ;
*                                   cNAZEVZAK1:n�zev zak�zky:39, ) ;
*                          SIZE(100,11.3) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) POPUPMENU(yn);
*                          ITEMMARKED( ItemMarked)




TYPE(Static) STYPE(13) SIZE(105,12.5) FPOS(0,12)  RESIZE(yy)
  TYPE(TEXT) CAPTION(Polo�ky v�robn� zak�zky) CPOS(0,0) CLEN(104) FONT(5) PP(3) BGND(11) CTYPE(1) Resize(yx)

  TYPE(DBrowse)  FPOS(0,1) SIZE(105,8.5) FILE(vyrZakit)  ;
                  FIELDS ( cCISZAKAZ:��sloZak�zky:20    , ;
                           cCISZAKAZI:v�r��slo:20       , ;
                           cNAZEVZAK1:n�zev zak�zky:39, ;
                           CNAZFIRMY::20              , ;
                           cSKP:skp                   , ;
                           cZKRATMENZ:m�na            , ;
                           nCENAMJ:cena/mj              ) ;
                 SIZE(100,11.3) CURSORMODE(3) PP(7) Resize(yy) SCROLL(yy) POPUPMENU(yn);
                 ITEMMARKED( ItemMarked)

TYPE(END)

*                            M->mnozKFak:mno�KFak:10      ) ;