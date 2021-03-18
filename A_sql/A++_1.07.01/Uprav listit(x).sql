update listit set nrok = Convert(('20'+Substring(cobdobi,4,2)),SQL_NUMERIC) where nrokvytvor >= 2000   ;
update listit set nobdobi = Convert(Substring(cobdobi,1,2),SQL_NUMERIC) where nrokvytvor >= 2000   ;
  
update listit set listit.ncisosoby  = msprc_mo.ncisosoby, 
                  listit.nporpravzt = msprc_mo.nporpravzt,
		  listit.cjmenorozl = msprc_mo.cjmenorozl,
		  listit.ckmenstrpr = msprc_mo.ckmenstrpr,  
		  listit.nosoby     = msprc_mo.nosoby,
	          listit.nmsprc_mo  = msprc_mo.sid			  
            from msprc_mo 
            where listit.nrok       = msprc_mo.nrok and 
                  listit.nobdobi    = msprc_mo.nobdobi and
                  listit.noscisprac = msprc_mo.noscisprac    ;

update list_dav set nrok =  YEAR( ddatpordav) where ddatpordav >= '01.01.2000'   ;
update list_dav set nobdobi = MONTH( ddatpordav) where ddatpordav >= '01.01.2000'   ;
  

update list_dav set list_dav.ncisosoby  = msprc_mo.ncisosoby, 
                    list_dav.nporpravzt = msprc_mo.nporpravzt,
     	            list_dav.cjmenorozl = msprc_mo.cjmenorozl,
		    list_dav.nosoby     = msprc_mo.nosoby,
		    list_dav.nmsprc_mo  = msprc_mo.sid			  
	       from msprc_mo 
              where list_dav.nrok       = msprc_mo.nrok and
	            list_dav.nobdobi    = msprc_mo.nobdobi and 
		    list_dav.noscisprac = msprc_mo.noscisprac
