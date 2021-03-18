TYPE(drgForm) DTYPE(10) TITLE(MZDOV� L�STKY - dle d�vek) FILE(LIST_DAV);
              SIZE(100,25) GUILOOK(Message:y,Action:y,IconBar:y:drgStdBrowseIconBar);
              CARGO(VYR_MListDAV_crd) OBDOBI(VYR)

TYPE(Action) CAPTION(~Oprava ML) EVENT(Oprava_ML) TIPTEXT(Oprava polo�ek mzdov�ho l�stku )

* LIST_DAV ... hlavi�ky D�VEK ML
  TYPE(DBrowse) FILE(LIST_DAV) INDEXORD(1);
                FIELDS( nDoklad     ,;
                        nDavka      ,;
                        dDatPorDav  ,;
                        nOsCisPrac  ,;
                        osoby->cjmenoRozl:Jm�no pracovn�ka:30 ,;
                        nTarSazHod  ,;
                        cStred      ,;
                        C_Stred->cNazStr );
                SIZE(100,11.6) CURSORMODE(3) PP(7) SCROLL(ny) POPUPMENU(y);
                ITEMMARKED( ItemMarked)

* Z�kladn� �daje
  TYPE(TabPage) CAPTION( Polo�ky d�vky) FPOS(0, 11.7) SIZE(100,13.2) OFFSET(1,82) RESIZE(yx) PRE(tabSelect)
    TYPE(DBrowse) FILE(LISTIT) INDEXORD(14);
                  FIELDS(cCisZakazI        ,;
                         nPorCisLis        ,;
                         nRokVytvor        ,;
                         cTypListku        ,;
                         nDruhMzdy:Dr.mzdy ,;
                         nNmNaOpeSK  ,;
                         nNhNaOpeSK  ,;
                         nKcNaOpeSK  ,;
                         nKusyCelk   ,;
                         nKusyHotov  ,;
                         dVyhotPlan:Dat.vyh.PL  ,;
                         dVyhotSkut:Dat.vyh.SK  ,;
                         cStavListk:Stav  );
                 SIZE(100, 12) CURSORMODE(3) PP(7) RESIZE(yx) SCROLL(ny) FOOTER(y)
  TYPE(End)

* LISTIT - pln�n� ML
*  TYPE(TabPage) CAPTION( XXXXX ML) FPOS(0, 11.7) SIZE(100,13.2) OFFSET(18,66) RESIZE(yx) PRE(tabSelect)

*    TYPE(PUSHBUTTON) POS(0,0) SIZE(0,0)

*  TYPE(End)