update listit set nobdobi = 1 where COBDOBI='01/13' and nobdobi<>1   ;

update listit set listit.nporpravzt = msprc_mo.nporpravzt 
              from msprc_mo
			  where ( listit.nporpravzt = 0 or listit.nporpravzt is null ) and
			          listit.noscisprac = msprc_mo.noscisprac and
					  listit.cobdobi    = msprc_mo.cobdobi    	     ;

update listit set listit.ncisosoby = msprc_mo.ncisosoby,
                  listit.nosoby    = msprc_mo.nosoby   
              from msprc_mo
			  where   listit.noscisprac = msprc_mo.noscisprac and
					  listit.nporpravzt = msprc_mo.nporpravzt and
					  listit.cobdobi    = msprc_mo.cobdobi    	 
					    