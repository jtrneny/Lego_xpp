TYPE(drgForm) DTYPE(10) SIZE(106,18) TITLE(Seznam �kolen� a kurz� ...(v�b�r) ...)  ;
              FILE(skoleni)                                                        ;
              GUILOOK(Action:y,IconBar:n,Menu:n,Message:n)  


TYPE(Action) CAPTION(~Nov�   �kolen�) EVENT(per_skoleni_new)    TIPTEXT(Zalo�en� nov�ho �kolen�/ kurzu do seznamu ...)
TYPE(Action) CAPTION(~Oprava �kolen�) EVENT(per_skoleni_modify) TIPTEXT(Oprava �daj� �kolen�/ kurzu ...)

 TYPE(DBrowse) FPOS(0,0) SIZE(106,9.4) FILE(Skoleni) INDEXORD(1)                          ;
                                       FIELDS( nPoradi:po��k                            , ;
                                               cZkratka:typ�k                           , ;
                                               M->nazev_Skoleni:n�zev �kolen�/ kurzu:27 , ;
                                               nperioOpak:perOpak�k                     , ;
                                               czkratJedn:za                            , ;
                                               clektor:�kolen�/ kurz vedl               , ;
                                               dposlSkole:dne                           , ;
                                               ddalsSkole:dal��k                         )  ;
                                       CURSORMODE(3) PP(7) ITEMMARKED(ItemMarked)


 TYPE(Static) STYPE(13) SIZE(104,16.5) FPOS(1,9.7) RESIZE(yn) CTYPE(2)

   TYPE(TEXT) CAPTION(Typ �kolen���...)         CPOS( 2, 1) CLEN(18)
     TYPE(TEXT) NAME(Skoleni->cZkratka)           CPOS(23, 1) CLEN(10) BGND(13)
     TYPE(TEXT) NAME(C_Skolen->cNazev)            CPOS(38, 1) CLEN(30) 


   TYPE(Static) STYPE( 2) CAPTION(�kolen�)  SIZE(93, 5.30) FPOS( 3, 2.5) RESIZE(y)
    TYPE(TEXT)  CAPTION(D�lka . . .)               CPOS( 3, 1) CLEN( 8)
     TYPE(TEXT) NAME(Skoleni->nDelkaSkol)          CPOS(22, 1) CLEN( 5) BGND(13)
     TYPE(TEXT) NAME(Skoleni->cZkratJED2)          CPOS(28, 1) CLEN( 5)

    TYPE(TEXT)  CAPTION(Term�n posledn� . . .)     CPOS(37, 1) CLEN(17)
     TYPE(TEXT) NAME(Skoleni->dPoslSkole)          CPOS(57, 1) CLEN(11) BGND(13)

    TYPE(TEXT)  CAPTION(Spl�uj�c� normy)           CPOS(77, 1) CLEN(14)

    TYPE(TEXT)  CAPTION(Perioda opakov�n� . . .)   CPOS( 3, 2.05) CLEN(19)
     TYPE(TEXT) NAME(Skoleni->nPerioOpak)          CPOS(22, 2.05) CLEN( 5) BGND(13)
     TYPE(TEXT) NAME(Skoleni->cZkratJEDN)          CPOS(28.5, 2.05) CLEN( 3) 

    TYPE(TEXT) CAPTION(Term�n n�sleduj�c� . . .)  CPOS(37, 2.05) CLEN(20)
     TYPE(TEXT) NAME(Skoleni->dDalsSkole)         CPOS(57, 2.05) CLEN(11) BGND(13)

    TYPE(TEXT)  CAPTION(1.)                        CPOS(72, 2.05) CLEN( 3)
     TYPE(TEXT) NAME(Skoleni->cNorma1)             CPOS(75, 2.05) CLEN(15) BGND(13)

    TYPE(TEXT) CAPTION(Zp�sob ukon�en� . . .)     CPOS( 3, 3.10) CLEN(17)
     TYPE(TEXT) NAME(Skoleni->cZkratkaUk)         CPOS(22, 3.10) CLEN(10) BGND(13)
     TYPE(TEXT) NAME(c_SkolUk->cNazev)            CPOS(33.5, 3.10) CLEN(30)

    TYPE(TEXT) CAPTION(2.)                        CPOS(72, 3.10) CLEN( 3)
     TYPE(TEXT) NAME(Skoleni->cNorma2)            CPOS(75, 3.10) CLEN(15) BGND(13)

    TYPE(TEXT) CAPTION(��slo pr�kazu . . .)       CPOS( 3, 4.15) CLEN(15)
     TYPE(TEXT) NAME(Skoleni->cCisPrukaz)         CPOS(22, 4.15) CLEN(20) BGND(13)

    TYPE(TEXT) CAPTION(3.)                        CPOS(72, 4.15) CLEN( 3)
     TYPE(TEXT) NAME(Skoleni->cNorma3)            CPOS(75, 4.15) CLEN(15) BGND(13)
   TYPE(End)

* 
   TYPE(Static) STYPE( 2)  SIZE(93, 6) FPOS( 3, 7.85) RESIZE(y)

    TYPE(TEXT) CAPTION(�kolitel . . .)          CPOS( 3, 1) CLEN(11)
     TYPE(TEXT) NAME(Skoleni->cZkratSkol)       CPOS(14, 1) CLEN(10) BGND(13)
     TYPE(TEXT) NAME(Skoleni->nCisFirmy)        CPOS(25.5, 1) FLEN( 7) BGND(13)
     TYPE(TEXT) NAME(Skoleni->cNazevSkol)       CPOS(34, 1) FLEN(35) PP(2)

    TYPE(TEXT) CAPTION(Ulice . . .)             CPOS( 5, 2.05) CLEN( 8)
     TYPE(TEXT) NAME(Skoleni->cUlice)           CPOS(14, 2.05) CLEN(25) BGND(13)

    TYPE(TEXT) CAPTION(. . . Lektor . . .)      CPOS(69, 2.05) CLEN( 12)

    TYPE(TEXT) CAPTION(M�sto . . .)             CPOS( 5, 3.10) CLEN( 8)
     TYPE(TEXT) NAME(Skoleni->cMisto)           CPOS(14, 3.10) CLEN(25) BGND(13)
     TYPE(TEXT) NAME(Skoleni->cLektor)          CPOS(59, 3.10) CLEN(30)

    TYPE(TEXT) CAPTION(PS� . . .)               CPOS( 5, 4.15)
     TYPE(TEXT) NAME(Skoleni->cPSC)             CPOS(14, 4.15) CLEN( 8) BGND(13)
     TYPE(TEXT) NAME(c_Psc->cMisto)             CPOS(23.5, 4.15) CLEN(30) 

    TYPE(TEXT) CAPTION(St�t . . .)              CPOS( 5, 5.20) CLEN( 7)
     TYPE(TEXT) NAME(Skoleni->cZkratStat)       CPOS(14, 5.20) CLEN( 5) BGND(13)
     TYPE(TEXT) NAME(C_Staty->cNazevStat)       CPOS(20.5, 5.20) CLEN(25) 
   TYPE(End)
 TYPE(End)
