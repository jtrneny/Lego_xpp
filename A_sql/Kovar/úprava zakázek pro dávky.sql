//select * from vyrzak where cstavzakaz<>'U' and ctypzak='EK' and nmnozplano=1
//select * from vyrzakit, vyrzak where vyrzakit.cstavzakaz<>'U' and vyrzakit.ctypzak='EK' and vyrzakit.cciszakaz= vyrzak.cciszakaz and vyrzak.nmnozplano=1 and contains(vyrzakit.cciszakazi,'*/0*')
update vyrzakit set vyrzakit.cvyrobcisl = replace(vyrzakit.cvyrobcisl,'/0','/1'),
					vyrzakit.cciszakazi = replace(vyrzakit.cciszakazi,'/0','/1')
					 from vyrzak where vyrzakit.cstavzakaz<>'U' and vyrzakit.ctypzak='EK' and vyrzakit.cciszakaz= vyrzak.cciszakaz and vyrzak.nmnozplano=1 and contains(vyrzakit.cciszakazi,'*/0*')
update poloper set poloper.cvyrobcisl = replace(poloper.cvyrobcisl,'/0','/1'),
				    poloper.cciszakazi = replace(poloper.cciszakazi,'/0','/1')
					 from vyrzak where vyrzak.cstavzakaz<>'U' and vyrzak.ctypzak='EK' and poloper.cciszakaz= vyrzak.cciszakaz and vyrzak.nmnozplano=1 and contains(poloper.cciszakazi,'*/0*')