select pvpitem.ccislobint from pvpitem,objitem 
                where pvpitem.ccislobint=objitem.ccislobint and 
				       pvpitem.ncislpolob=objitem.ncislpolob and pvpitem.nobjitem = 0
//select ccislobint,nmnoz_svyd from pvpitem where nmnoz_svyd<>0