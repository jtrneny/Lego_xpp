DECLARE allTables CURSOR; 

delete from vykdph_i where cobdobi='04/11' and cdenik='O ';

OPEN allTables AS SELECT * from fakvyshd where cobdobi='04/11'; //Open cursor with all tables. 


WHILE FETCH allTables DO
  try
    insert into vykdph_i (culoha,ndoklad,cobdobi,nrok,nobdobi,cobdobidan,ntyp_dph,noddil_dph,nradek_dph,nzakld_dph,nsazba_dph,cucetu_dph,czustuct,ndat_od,cdenik,
	fakvysit,pokladhd,ucetdohd,nporadi,nprocdph,nklikvid,nzlikvid) values(allTables.culoha,allTables.ndoklad,allTables.cobdobi,allTables.nrok,allTables.nobdobi,
	allTables.cobdobidan,2,1,1,allTables.nzakldan_2,allTables.nsazdan_2,'343020','D',20110401,allTables.cdenik,
	'1  1','01000','01010',3,20,allTables.nzakldan_2,allTables.nzakldan_2 ) ;  
	CATCH ALL

  end try;
end while;
