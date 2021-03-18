update c_typpoh set c_typpoh.lprodukce  = c_drpohz.lprodukce
                from c_drpohz
                where c_typpoh.culoha='Z' and c_typpoh.ctyppohybu = cast(c_drpohz.ndrpohyb as SQL_CHAR);

update majz  set nOdpiSkD = nOdpiSk   ;

update majz  set cOdpiSkD = cOdpiSk   ;

update majz  set majz.nRokyOdpiD = c_danskp.nrokyodpis from c_danskp where majz.cOdpiSkD = c_danskp.cOdpiSkD  ;

update majz  set nOdpiSk = nRokyOdpiU   ;

update majz set cOdpiSk = Left(Convert(nOdpiSk,SQL_CHAR),4)   ;

update majz  set nTypVypUO = 2   ;

update majz set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;

update majz  set nCenaPorU = nCenaVstU   ;

update majz  set nCenaPorD = nCenaVstD   ;

update majz  set lHmotnyIM = true   ;

update majz  set nZnAktD = IIF(nCenaVstD = nOprDan, 2, 0)   ;

update majz  set nZnAktD = nZnAkt where nZnAkt = 1 or nZnAkt = 9   ;

update umajz  set nOdpiSkD = nOdpiSk   ;

update dmajz  set nOdpiSkD = nOdpiSk   ;

update majzobd  set nOdpiSkD = nOdpiSk   ;

update umajz  set cOdpiSkD = cOdpiSk   ;

update dmajz  set cOdpiSkD = cOdpiSk   ;

update majzobd  set cOdpiSkD = cOdpiSk   ;

update zmajuz set cTypPohybu = Left(Convert(nDrPohyb,SQL_CHAR),10)   ;

update zmajuz set zmajuz.cTypDoklad = c_typpoh.cTypDoklad from c_typpoh where zmajuz.cTypPohybu = c_typpoh.cTypPohybu  ;

update zmaju set cUcetSkup = Left(Convert(ntypmaj,SQL_CHAR),10)   ;

update majz set cUcetSkup = Left(Convert(nucetskup,SQL_CHAR),10)   ;
update zmajuz set cUcetSkup = Left(Convert(nucetskup,SQL_CHAR),10)   ;
