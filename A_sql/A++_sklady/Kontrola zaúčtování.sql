select pvpitem.ndoklad,pvpitem.norditem,
       pvpitem.ctyppohybu, 
       pvpitem.ccissklad,pvpitem.csklpol,
	    pvpitem.ncenacelk, ucetpol.nkcmd
  from pvpitem, ucetpol where pvpitem.nrok = 2016 and pvpitem.cdenik = ucetpol.cdenik and
                                                           pvpitem.ndoklad = ucetpol.ndoklad and 
                                                            pvpitem.norditem = ucetpol.norditem and 
															  pvpitem.ncenacelk <> ucetpol.nkcmd and
															   ucetpol.norducto = 1