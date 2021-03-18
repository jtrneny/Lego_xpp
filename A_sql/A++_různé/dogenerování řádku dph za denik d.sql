DECLARE allTables CURSOR; 

delete from vykdph_i where cobdobi='04/11' and cdenik='D ';

OPEN allTables AS SELECT * from fakprihd where cobdobi='04/11'; //Open cursor with all tables. 


WHILE FETCH allTables DO
  try
    insert into vykdph_i (culoha,ndoklad,cobdobi,nrok,nobdobi,cobdobidan,ntyp_dph,noddil_dph,nradek_dph,nzakld_dph,nsazba_dph,cucetu_dph,czustuct,ndat_od,cdenik,
	fakprihd,pokladhd,ucetdohd,ctypuct,nporadi,nprocdph,nklikvid,nzlikvid) values(allTables.culoha,allTables.ndoklad,allTables.cobdobi,allTables.nrok,allTables.nobdobi,
	allTables.cobdobidan,2,4,40,allTables.nzakldan_2,allTables.nsazdan_2,'343020','M',20110401,allTables.cdenik,
	'010000','00010','01010','0111',6,20,allTables.nzakldan_2,allTables.nzakldan_2 ) ;  
	CATCH ALL

  end try;
end while;
