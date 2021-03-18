update mssrz_mo set mssrz_mo.cpracovnik=Left(msprc_mo.cpracovnik,30),
                    mssrz_mo.cjmenorozl=msprc_mo.cjmenorozl,
                    mssrz_mo.cosoba=msprc_mo.cosoba
				from msprc_mo	
				where mssrz_mo.nrok=2019 and mssrz_mo.croobcpppv=msprc_mo.croobcpppv	