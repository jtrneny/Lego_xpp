//update mssrz_mo set czkrtypuhr = replace('PrevP','r','ř') where ctypabo = 'PRUH_H'   ;
update mssrz_mo set czkrtypuhr = 'PřevP' where ctypabo = 'PRUH_H'   ;
//update mssrz_mo set czkrtypuhr = replace(czkrtypuhr,'r','ř') where czkrtypuhr = 'PrevP'   ;
update mssrz_mo set czkratmeny = 'CZK' where czkratmeny = '' or czkratmeny is null    ;
update mssrz_mo set czkratmenz = 'CZK' where czkratmenz = '' or czkratmenz is null    ;
update mssrz_mo set czkratmenz = 'CZK' where czkratmenz = '' or czkratmenz is null    ;
update mssrz_mo set nkurzahmen = 1     where czkratmenz = 'CZK'                      ;
update mssrz_mo set nmnozprep  = 1     where czkratmenz = 'CZK'                      ;

