update druhymzd set ctyppohzav='GENODVSOC'  where czkrtrvpla = 'SocPo'      ;
update druhymzd set ctyppohzav='GENODVZDR'  where czkrtrvpla = 'ZdrPo'      ;
update druhymzd set ctyppohzav='GENODVDANZ' where czkrtrvpla = 'ZaDan'      ;
update druhymzd set ctyppohzav='GENODVDANS' where czkrtrvpla = 'SrDan'      ;
//update druhymzd set ctyppohzav='GENODVZAPO' where czkrtrvpla =        ;

update mssrz_mo set ctyppohzav='GENSRAZKA'  where ctypabo = 'PRUH_H' or ctypabo = 'PRUH_I' or ctypabo = 'KB_BBS'     ;
update mssrz_mo set ctyppohzav='GENODCSNFO'  where ctypabo = 'CS_NFO'       ;
update mssrz_mo set ctyppohzav='GENODVPPHO'  where Left(ctypabo,2) = 'Ep'   ;
update mssrz_mo set ctyppohzav='GENODVPKHO'  where Left(ctypabo,2) = 'Ek'   ;