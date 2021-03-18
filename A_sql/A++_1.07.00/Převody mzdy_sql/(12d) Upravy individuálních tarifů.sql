update mstarind  set mstarind.ctask = 'MZD',mstarind.culoha = 'M',mstarind.cjmenoRozl = msprc_mo.cjmenoRozl,mstarind.ncisosoby = msprc_mo.ncisosoby
                 from msprc_mo 
                 where mstarind.noscisprac = msprc_mo.noscisprac and mstarind.nporpravzt = msprc_mo.nporpravzt and msprc_mo.nrokobd=201212 ;
