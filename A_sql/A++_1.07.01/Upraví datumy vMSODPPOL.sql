update prsmldoh set prsmldoh.ddatvyst = msprc_mo.ddatvyst from msprc_mo
         where msprc_mo.cobdobi='09/13' and prsmldoh.noscisprac=msprc_mo.noscisprac 
		         and prsmldoh.nporpravzt=msprc_mo.nporpravzt and ifnull(prsmldoh.ddatvyst, curdate()) <>                               ifnull(msprc_mo.ddatvyst, curdate())
                                and ifnull(prsmldoh.ddatvyst, curdate()) = curdate()     ;

update prsmldoh set prsmldoh.ddatpredvy = msprc_mo.ddatpredvy from msprc_mo
         where msprc_mo.cobdobi='09/13' and prsmldoh.noscisprac=msprc_mo.noscisprac 
		         and prsmldoh.nporpravzt=msprc_mo.nporpravzt and ifnull(prsmldoh.ddatpredvy, curdate()) <> ifnull(msprc_mo.ddatpredvy, curdate())
                     and ifnull(prsmldoh.ddatpredvy, curdate()) = curdate()