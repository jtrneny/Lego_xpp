TYPE(drgForm) DTYPE(10) TITLE( ZVI - Položky dokladu ) SIZE(85,10) FILE( ZvZmenIT) ;
              GUILOOK(Action:n,IconBar:n,Menu:n,Message:n )

* Položky dokladù
  TYPE(DBrowse) FILE( ZvZmenIT) INDEXORD(2) ;
                FIELDS( cZvireZem:Zemì zvíøete:10    ,;
                        nInvCis:Inv.èíslo zv.:12     ,;
                        dNarozZvir:Datum narození:12 ,;
                        nPohlavi:Pohlavi zv.:8       ,;
                        cPlemeno:Plemeno:10          ,;
                        cMatkaZem:Zemì matky:10      ,;
                        nInvCisMat:Inv.èís. matky:12  ,;
                        nDoklad );
                FPOS(0,0) SIZE(85, 7.6) CURSORMODE(3) SCROLL(ny) PP(7)

