update c_typpoh set c_typpoh.ndrpohpl1  = c_drpohz.ndrpohpl1,
                    c_typpoh.ndrpohpl2  = c_drpohz.ndrpohpl2,
					c_typpoh.ndrpohplpr = c_drpohz.ndrpohplpr,
					c_typpoh.ntyppohyb  = c_drpohz.ntyppohyb,
					c_typpoh.npodm      = c_drpohz.npodm       
                from c_drpohz
                where c_typpoh.culoha='Z' and c_typpoh.ctyppohybu = cast(c_drpohz.ndrpohyb as SQL_CHAR);

update maj  set nOdpiSkD = nOdpiSk   ;
update majz  set nOdpiSkD = nOdpiSk   ;

update maj  set cOdpiSkD = cOdpiSk   ;
update majz  set cOdpiSkD = cOdpiSk   ;

update maj  set maj.nRokyOdpiD = c_danskp.nrokyodpis from c_danskp where maj.cOdpiSkD = c_danskp.cOdpiSkD  ;
update majz  set majz.nRokyOdpiD = c_danskp.nrokyodpis from c_danskp where majz.cOdpiSkD = c_danskp.cOdpiSkD  ;

update maj  set nOdpiSk = nRokyOdpiU   ;
update majz  set nOdpiSk = nRokyOdpiU   ;

update maj set cOdpiSk = Left(Convert(nOdpiSk,SQL_CHAR),4)   ;
update majz set cOdpiSk = Left(Convert(nOdpiSk,SQL_CHAR),4)   ;

update maj  set nTypVypUO = 2   ;
update majz  set nTypVypUO = 2   ;

update maj set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;
update majz set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;

update maj  set nCenaPorU = nCenaVstU   ;
update majz  set nCenaPorU = nCenaVstU   ;

update maj  set nCenaPorD = nCenaVstD   ;
update majz  set nCenaPorD = nCenaVstD   ;

update maj  set lHmotnyIM = true   ;
update majz  set lHmotnyIM = true   ;

update maj  set nZnAktD = IIF(nCenaVstD = nOprDan, 2, 0)   ;
update majz  set nZnAktD = IIF(nCenaVstD = nOprDan, 2, 0)   ;

update maj  set nZnAktD = nZnAkt where nZnAkt = 1 or nZnAkt = 9   ;
update majz  set nZnAktD = nZnAkt where nZnAkt = 1 or nZnAkt = 9   ;

update c_typskp  set nOdpiskD = nOdpisk   ;
update c_typskp  set cOdpiskD = cOdpisk   ;

update umaj  set nOdpiSkD = nOdpiSk   ;
update umajz  set nOdpiSkD = nOdpiSk   ;

update dmaj  set nOdpiSkD = nOdpiSk   ;
update dmajz  set nOdpiSkD = nOdpiSk   ;

update majobd  set nOdpiSkD = nOdpiSk   ;
update majzobd  set nOdpiSkD = nOdpiSk   ;

update umaj  set cOdpiSkD = cOdpiSk   ;
update umajz  set cOdpiSkD = cOdpiSk   ;

update dmaj  set cOdpiSkD = cOdpiSk   ;
update dmajz  set cOdpiSkD = cOdpiSk   ;

update majobd  set cOdpiSkD = cOdpiSk   ;
update majzobd  set cOdpiSkD = cOdpiSk   ;

update zmaju set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;
update zmajuz set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;

update zmaju set zmaju.cTypDoklad = c_typpoh.cTypDoklad from c_typpoh where zmaju.cTypPohybu = c_typpoh.cTypPohybu  ;
update zmajuz set zmajuz.cTypDoklad = c_typpoh.cTypDoklad from c_typpoh where zmajuz.cTypPohybu = c_typpoh.cTypPohybu  ;

update maj set cUcetSkup = Left(Convert(ntypmaj,SQL_CHAR),10)   ;
update zmaju set cUcetSkup = Left(Convert(ntypmaj,SQL_CHAR),10)   ;

update majz set cUcetSkup = Left(Convert(nucetskup,SQL_CHAR),10)   ;
update zmajuz set cUcetSkup = Left(Convert(nucetskup,SQL_CHAR),10)   ;
