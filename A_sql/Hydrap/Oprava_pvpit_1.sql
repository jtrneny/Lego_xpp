update pvpitem set pvpitem.nobjitem = objitem.sid from objitem 
                where pvpitem.ccislobint=objitem.ccislobint and 
				       pvpitem.ncislpolob=objitem.ncislpolob and pvpitem.nobjitem = 0   